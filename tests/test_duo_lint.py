"""Tests for scripts/duo-lint. Run: python3 -m unittest discover -s tests -v"""
import importlib.machinery
import importlib.util
import json
import os
import re
import subprocess
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SCRIPT = os.path.join(ROOT, "scripts", "duo-lint")
FIX = os.path.join(HERE, "fixtures")

loader = importlib.machinery.SourceFileLoader("duo_lint", SCRIPT)
spec = importlib.util.spec_from_loader("duo_lint", loader)
duo_lint = importlib.util.module_from_spec(spec)
loader.exec_module(duo_lint)

EXPECT_RE = re.compile(r"//\s*expect:\s*([A-Z0-9, ]+)")


def expected(path):
    out = set()
    with open(path, encoding="utf-8") as fh:
        for n, line in enumerate(fh, 1):
            m = EXPECT_RE.search(line)
            if m:
                for rid in m.group(1).replace(",", " ").split():
                    out.add((n, rid))
    return out


def actual(path):
    with open(path, encoding="utf-8") as fh:
        return {(f["line"], f["rule"]) for f in duo_lint.scan_text(fh.read(), path)}


class FixtureTests(unittest.TestCase):
    def check_exact(self, name):
        path = os.path.join(FIX, name)
        exp, act = expected(path), actual(path)
        self.assertTrue(exp, "fixture has no expectations")
        self.assertEqual(sorted(exp - act), [], "missed findings")
        self.assertEqual(sorted(act - exp), [], "unexpected findings")

    def test_bad_swiftui(self):
        self.check_exact("bad_swiftui.swift")

    def test_bad_uikit(self):
        self.check_exact("bad_uikit.swift")

    def test_good_files_are_clean(self):
        for name in ("good_swiftui.swift", "good_uikit.swift"):
            path = os.path.join(FIX, name)
            self.assertEqual(sorted(actual(path)), [], name)

    def test_every_rule_is_exercised(self):
        seen = set()
        for name in os.listdir(FIX):
            if name.startswith("bad_"):
                seen |= {r for _, r in expected(os.path.join(FIX, name))}
        self.assertEqual(sorted(set(duo_lint.RULES) - seen), [])


class UnitTests(unittest.TestCase):
    def scan(self, src, **kw):
        return [(f["line"], f["rule"]) for f in duo_lint.scan_text(src, "t.swift", **kw)]

    def test_comments_and_strings_ignored(self):
        src = '// UIScreen.main\n/* UIScreen.main\n UIToolbar() */\nlet s = "UIScreen.main"\n'
        self.assertEqual(self.scan(src), [])

    def test_min_width_threshold(self):
        self.assertEqual(self.scan("x.frame(width: 120)"), [])
        self.assertEqual(self.scan("x.frame(width: 120)", min_width=100), [(1, "DUO002")])

    def test_even_grid_ok(self):
        self.assertEqual(self.scan("let c = Array(repeating: GridItem(), count: 2)"), [])

    def test_disable_previous_line_and_file(self):
        self.assertEqual(self.scan("// duo-lint:disable=DUO001\nlet b = UIScreen.main.bounds"), [])
        self.assertEqual(self.scan("// duo-lint:disable-file=DUO001\n\nlet b = UIScreen.main.bounds"), [])

    def test_disabled_argument(self):
        self.assertEqual(self.scan("let b = UIScreen.main.bounds", disabled=frozenset({"DUO001"})), [])

    def test_reserved_regions_silences_duo009(self):
        src = ("GeometryReader { p in\n let r = p.reservedRegions(kind: .division)\n"
               " Button(\"A\") { }\n  .position(x: p.size.width / 2, y: 10)\n}")
        self.assertEqual(self.scan(src), [])

    def test_background_ignores_safe_area_ok(self):
        src = "ZStack {\n Color.black.ignoresSafeArea()\n Button(\"Go\", systemImage: \"play\") { }\n}"
        self.assertEqual(self.scan(src), [])

    def test_supported_orientations_declaration_ok(self):
        self.assertEqual(self.scan("override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }"), [])

    def test_duo014_hardcoded_screen_size(self):
        self.assertIn((1, "DUO014"), self.scan("if view.bounds.height == 844 { }"))
        self.assertIn((1, "DUO014"), self.scan("let known = [812, 844, 896]"))
        self.assertEqual(self.scan("banner.frame = CGRect(x: 0, y: 0, width: 414, height: 60)"), [(1, "DUO002")])
        self.assertEqual(self.scan("view.frame(width: 44)"), [])

    def test_duo015_cropped_hero(self):
        src = 'Image("hero")\n    .resizable()\n    .scaledToFill()\n'
        self.assertEqual(self.scan(src), [(3, "DUO015")])
        self.assertIn((1, "DUO015"), self.scan("heroView.contentMode = .scaleAspectFill"))
        chosen = "background.contentMode = wide ? .scaleAspectFit : .scaleAspectFill\n"
        self.assertEqual(self.scan(chosen), [])
        aspect = 'Image("hero").aspectRatio(contentMode: wide ? .fit : .fill)\n'
        self.assertEqual(self.scan(aspect), [])
        self.assertEqual(self.scan("Color.red.scaledToFill()"), [])

    def test_duo016_size_read_at_launch(self):
        launch = "override func viewDidLoad() {\n    super.viewDidLoad()\n    cached = view.bounds.size\n}\n"
        self.assertEqual(self.scan(launch), [(3, "DUO016")])
        appearing = "override func viewIsAppearing(_ animated: Bool) {\n    side = view.bounds.width\n}\n"
        self.assertEqual(self.scan(appearing), [(2, "DUO016")])
        layout = "override func viewDidLayoutSubviews() {\n    frame = view.bounds\n}\n"
        self.assertEqual(self.scan(layout), [])
        swiftui = "var body: some View {\n    GeometryReader { proxy in Text(\"\\(proxy.size.width)\") }\n}\n"
        self.assertEqual(self.scan(swiftui), [])

    def test_duo017_regular_width_as_ipad(self):
        self.assertEqual(
            self.scan("let isIPad = horizontalSizeClass == .regular"),
            [(1, "DUO017")],
        )
        both = "if traitCollection.userInterfaceIdiom == .pad && traitCollection.horizontalSizeClass == .regular { }"
        self.assertEqual(sorted(self.scan(both)), [(1, "DUO004"), (1, "DUO017")])
        self.assertEqual(self.scan("if horizontalSizeClass == .regular { regular() }"), [])
        phone = "if UIDevice.current.userInterfaceIdiom == .phone && horizontalSizeClass == .compact { }"
        self.assertIn((1, "DUO017"), self.scan(phone))

    def test_duo018_design_requires_compatibility(self):
        swift = 'let key = "UIDesignRequiresCompatibility"\n'
        self.assertEqual(self.scan(swift), [(1, "DUO018")])
        plist = "<key>UIDesignRequiresCompatibility</key>\n<true/>\n"
        self.assertEqual(self.scan(plist), [(1, "DUO018")])
        self.assertEqual(self.scan("// UIDesignRequiresCompatibility was removed\nlet x = 1\n"), [])


class CLITests(unittest.TestCase):
    def run_cli(self, *args):
        return subprocess.run([sys.executable, SCRIPT, *args], capture_output=True, text=True)

    def test_text_output_and_exit_code(self):
        r = self.run_cli(os.path.join(FIX, "bad_uikit.swift"))
        self.assertEqual(r.returncode, 1)
        self.assertRegex(r.stdout, r"bad_uikit\.swift:\d+:\d+: error: DUO001 main-screen:")
        self.assertIn("    fix: ", r.stdout)

    def test_clean_exit_zero(self):
        r = self.run_cli(os.path.join(FIX, "good_swiftui.swift"), os.path.join(FIX, "good_uikit.swift"))
        self.assertEqual(r.returncode, 0, r.stdout)

    def test_json(self):
        r = self.run_cli("--format", "json", "--exit-zero", FIX)
        self.assertEqual(r.returncode, 0)
        data = json.loads(r.stdout)
        self.assertEqual(data["files"], 4)
        self.assertTrue(all({"path", "line", "rule", "fix", "source"} <= set(f) for f in data["findings"]))

    def test_info_only_needs_strict(self):
        import tempfile
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "g.swift")
            with open(p, "w") as fh:
                fh.write("let c = Array(repeating: GridItem(), count: 3)\n")
            self.assertEqual(self.run_cli(p).returncode, 0)
            self.assertEqual(self.run_cli("--strict", p).returncode, 1)

    def test_list_rules(self):
        r = self.run_cli("--list-rules")
        self.assertEqual(r.returncode, 0)
        self.assertIn("DUO013", r.stdout)
        for rid in ("DUO014", "DUO015", "DUO016", "DUO017", "DUO018"):
            self.assertIn(rid, r.stdout)

    def test_plist_file_is_scanned(self):
        import tempfile
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "Info.plist")
            with open(p, "w") as fh:
                fh.write("<key>UIDesignRequiresCompatibility</key>\n<true/>\n")
            r = self.run_cli("--format", "json", p)
            self.assertEqual(r.returncode, 1)
            data = json.loads(r.stdout)
            self.assertEqual(data["files"], 1)
            self.assertEqual([f["rule"] for f in data["findings"]], ["DUO018"])


if __name__ == "__main__":
    unittest.main()

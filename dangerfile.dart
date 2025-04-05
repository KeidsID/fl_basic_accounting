import "package:danger_core/danger_core.dart";

abstract class GitlintConfig {
  static const List<String> types = [
    "build",
    "chore",
    "docs",
    "feat",
    "fix",
    "refactor",
    "revert",
    "style",
    "test",
  ];

  static const List<String> scopes = [
    "root",
    "github",
    "lib",
    "lib-domain",
    "lib-infrastructures",
    "lib-interfaces",
    "lib-use_cases",
    "android",
    "ios",
    "web",
    "windows",
    "macos",
    "linux",
  ];

  static const List<String> issuePrefixes = ["#", "release-"];

  static const bool requireAssignee = true;
}

final pr = danger.github.pr;

void checkTitle() {
  final isTitleValid = RegExp(
    '^(${GitlintConfig.types.join("|")})'
    '(\\((${GitlintConfig.scopes.join(("|"))})(\\/(${GitlintConfig.scopes.join(("|"))}))*\\))?'
    "(!|): (.*\\S )?"
    '(${GitlintConfig.issuePrefixes.join("|")})\\d{1,6}((\\.\\d+){1,2})?\$',
  ).hasMatch(pr.title);

  if (!isTitleValid) {
    fail(
      "The PR title should use conventional commits.\n\n"
      "* Valid types: ${GitlintConfig.types.join(", ")}.\n"
      "* Valid optional scopes: ${GitlintConfig.scopes.join(", ")}.\n"
      "* Valid ref prefix: ${GitlintConfig.issuePrefixes.join(", ")}.",
    );
  }
}

void checkBranch() {
  final isBranchValid = RegExp(
    "^\\d{1,6}-"
    "${GitlintConfig.types.join("|")}-"
    "[a-zA-Z\\d-]+\$"
    "|(main)\$",
  ).hasMatch(pr.head.ref);

  if (!isBranchValid) {
    fail(
      "The PR branch should use the following format:\n\n"
      "<types>-<content>-${GitlintConfig.issuePrefixes.first}<ref_num>",
    );
  }
}

void checkAssignee() {
  final hasAssignee = pr.assignee == null ? false : true;

  if (!hasAssignee) {
    fail("The PR should have at least one assignee");
  }
}

void main() {
  checkTitle();
  checkBranch();

  if (GitlintConfig.requireAssignee) checkAssignee();
}

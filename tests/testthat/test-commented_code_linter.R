context("commented_code_linter")

test_that("returns the correct linting", {
  linter <- commented_code_linter
  msg <- rex("Commented code should be removed.")

  expect_lint("blah", NULL, linter)

  expect_lint("# blah <- 1", msg, linter)

  expect_lint(
    "bleurgh <- fun_call(1) # other_call()",
    c(message = msg, column_number = 26),
    linter)

  expect_lint(
    " #blah <- 1",
    c(message = msg, column_number = 3),
    linter)

  expect_lint("#' blah <- 1", NULL, linter)

  expect_lint(
    c("a <- 1", "# comment without code"),
    NULL,
    linter)

  expect_lint(
    c("a <- 1", "# comment without code"),
    NULL,
    linter)

  test_ops <- append(ops[ops != "%[^%]*%"], values = c("%>%", "%anything%"))
  for (op in test_ops) {
    expect_lint(paste("i", op, "1", collapse = ""), NULL, linter)
    expect_lint(paste("# something like i", op, "1", collapse = ""), NULL, linter)
    expect_lint(paste("# i", op, "1", collapse = ""), msg, linter)
  }

  expect_lint("TRUE", NULL, linter)
  expect_lint("#' @examples", NULL, linter)
  expect_lint("#' foo(1) # list(1)", NULL, linter) # comment in roxygen block ignored
  expect_lint("1+1 # gives 2", NULL, linter)

  expect_lint("# Non-existent:", NULL, linter) # "-" removed from code operators
  expect_lint("# 1-a", NULL, linter)

  expect_lint("1+1  # for example cat(\"123\")", NULL, linter)

  expect_lint("1+1 # cat('123')", msg, linter)
  expect_lint("#expect_ftype(1e-12 , t)", msg, linter)
})

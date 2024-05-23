# Contributing

Thanks for thinking about helping us!

## Getting started

After cloning the repository, then you'll want to bootstrap your system:

```console
script/bootstrap
```

This will ensure your system has all the programs needed to test
everything.

## Testing

-   Continuous Integration Status: [![Continuous Integration](https://github.com/docwhat/bashables/actions/workflows/ci.yaml/badge.svg)](https://github.com/docwhat/bashables/actions/workflows/ci.yaml)

To run all lint checks:

```console
script/lint
```

To run all tests:

```console
script/test
```

To run all Bats tests:

```console
bats tests
```

To run specific Bats tests:

```console
bats tests/<file>.bats
```

## Coding conventions

These coding conventions were initially copied from [bats-core's coding
conventions](https://github.com/bats-core/bats-core/blob/ee374d6dcc33958049134165efece137d46e99b7/docs/CONTRIBUTING.md#coding-conventions),
but I expect them to diverge over time.

Use [`shfmt`](https://github.com/mvdan/sh#shfmt) and [ShellCheck](https://www.shellcheck.net/). The CI will enforce this.

Use `snake_case` for all identifiers.

### Function declarations

-   Declare functions without the `function` keyword.
-   Strive to always use `return`, never `exit`, unless an error condition is
    severe enough to warrant it.
    -   Calling `exit` makes it difficult for the caller to recover from an error,
        or to compose new commands from existing ones.

### Variable and parameter declarations

-   Declare all variables inside functions using `local`.
-   Declare temporary file-level variables using `declare`. Use `unset` to remove
    them when finished.
-   Don't use `local -r`, as a readonly local variable in one scope can cause a
    conflict when it calls a function that declares a `local` variable of the same
    name.
-   Don't use type flags with `declare` or `local`. Assignments to integer
    variables in particular may behave differently, and it has no effect on array
    variables.
-   For most functions, the first lines should use `local` declarations to
    assign the original positional parameters to more meaningful names, e.g.:
    ```bash
    format_summary() {
      local cmd_name="$1"
      local summary="$2"
      local longest_name_len="$3"
    ```
    For very short functions, this _may not_ be necessary, e.g.:
    ```bash
    has_spaces() {
      [[ "$1" != "${1//[[:space:]]/}" ]]
    }
    ```

### Command substitution

-   If possible, don't. While this capability is one of Bash's core strengths,
    every new process created by Bats makes the framework slower, and speed is
    critical to encouraging the practice of automated testing. (This is especially
    true on Windows, [where process creation is one or two orders of magnitude
    slower][win-slow]. See [https://github.com/bats-core/bats-core#8][pr-8] for an illustration of
    the difference avoiding subshells makes.) Bash is quite powerful; see if you
    can do what you need in pure Bash first.
-   If you need to capture the output from a function, store the output using
    `printf -v` instead if possible. `-v` specifies the name of the variable into
    which to write the result; the caller can supply this name as a parameter.
-   If you must use command substitution, use `$()` instead of backticks, as it's
    more robust, more searchable, and can be nested.

[win-slow]: https://rufflewind.com/2014-08-23/windows-bash-slow
[pr-8]: https://github.com/bats-core/bats-core/pull/8

### Process substitution

-   If possible, don't use it. See the advice on avoiding subprocesses and using
    `printf -v` in the **Command substitution** section above.
-   Use wherever necessary and possible, such as when piping input into a `while`
    loop (which avoids having the loop body execute in a subshell) or running a
    command taking multiple filename arguments based on output from a function or
    pipeline (e.g. `diff`).
-   _Warning_: It is impossible to directly determine the exit status of a process
    substitution; emitting an exit status as the last line of output is a possible
    workaround.

### Conditionals and loops

-   Always use `[[` and `]]` for evaluating variables. Per the guideline under
    **Formatting**, quote variables and strings within the brackets, but not
    regular expressions (or variables containing regular expressions) appearing
    on the right side of the `=~` operator.

### Generating output

-   Use `printf` instead of `echo`. Both are Bash builtins, and there's no
    perceptible performance difference when running Bats under the `time` builtin.
    However, `printf` provides a more consistent experience in general, as `echo`
    has limitations to the arguments it accepts, and even the same version of Bash
    may produce different results for `echo` based on how the binary was compiled.
    See [Stack Overflow: Why is printf better than echo?][printf-vs-echo] for
    excruciating details.

[printf-vs-echo]: https://unix.stackexchange.com/a/65819

### Signal names

Always use upper case signal names (e.g. `trap - INT EXIT`) to avoid locale
dependent errors. In some locales (for example Turkish, see
[Turkish dotless i](https://en.wikipedia.org/wiki/Dotted_and_dotless_I)) lower
case signal names cause Bash to error. An example of the problem:

```bash
$ echo "tr_TR.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen tr_TR.UTF-8 # Ubuntu derivatives
$ LC_CTYPE=tr_TR.UTF-8 LC_MESSAGES=C bash -c 'trap - int && echo success'
bash: line 0: trap: int: invalid signal specification
$ LC_CTYPE=tr_TR.UTF-8 LC_MESSAGES=C bash -c 'trap - INT && echo success'
success
```

## Credit where credit due

This project uses several tools to ensure high quality:

-   [bats-core](https://bats-core.readthedocs.io/)
-   [trunk.io](https://docs.trunk.io)

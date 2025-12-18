return {
  addonManager        = {
    enable           = "Whether the addon manager is enabled or not.",
    repositoryBranch = "Specifies the git branch used by the addon manager.",
    repositoryPath   = "Specifies the git path used by the addon manager."
  },
  addonRepositoryPath = "Specifies the addon repository path (not related to the addon manager).",
  runtime             = {
    version           = "Lua runtime version.",
    path              = [[
When using `require`, how to find the file based on the input name.
Setting this config to `?/init.lua` means that when you enter `require 'myfile'`, `${workspace}/myfile/init.lua` will be searched from the loaded files.
if `runtime.pathStrict` is `false`, `${workspace}/**/myfile/init.lua` will also be searched.
If you want to load files outside the workspace, you need to set `Lua.workspace.library` first.
]],
    pathStrict        =
    'When enabled, `runtime.path` will only search the first level of directories, see the description of `runtime.path`.',
    special           =
    [[The custom global variables are regarded as some special built-in variables, and the language server will provide special support
The following example shows that 'include' is treated as' require '.
```json
"Lua.runtime.special" : {
    "include" : "require"
}
```
]],
    unicodeName       = "Allows Unicode characters in name.",
    nonstandardSymbol = "Supports non-standard symbols. Make sure that your runtime environment supports these symbols.",
    plugin            = "Plugin path. Please read [wiki](https://luals.github.io/wiki/plugins) to learn more.",
    pluginArgs        = "Additional arguments for the plugin.",
    fileEncoding      = "File encoding. The `ansi` option is only available under the `Windows` platform.",
    builtin           = [[
Adjust the enabled state of the built-in library. You can disable (or redefine) the non-existent library according to the actual runtime environment.
* `default`: Indicates that the library will be enabled or disabled according to the runtime version
* `enable`: always enable
* `disable`: always disable
]],
    meta              = 'Format of the directory name of the meta files.',
  },
  diagnostics         = {
    enable                       = "Enable diagnostics.",
    disable                      = "Disabled diagnostic (Use code in hover brackets).",
    globals                      = "Defined global variables.",
    globalsRegex                 = "Find defined global variables using regex.",
    severity                     = [[
Modify the diagnostic severity.
End with `!` means override the group setting `diagnostics.groupSeverity`.
]],
    neededFileStatus             = [[
* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic
End with `!` means override the group setting `diagnostics.groupFileStatus`.
]],
    groupSeverity                = [[
Modify the diagnostic severity in a group.
`Fallback` means that diagnostics in this group are controlled by `diagnostics.severity` separately.
Other settings will override individual settings without end of `!`.
]],
    groupFileStatus              = [[
Modify the diagnostic needed file status in a group.
* Opened:  only diagnose opened files
* Any:     diagnose all files
* None:    disable this diagnostic
`Fallback` means that diagnostics in this group are controlled by `diagnostics.neededFileStatus` separately.
Other settings will override individual settings without end of `!`.
]],
    workspaceEvent               = {
      "Set the time to trigger workspace diagnostics.",
      OnChange = "Trigger workspace diagnostics when the file is changed.",
      OnSave   = "Trigger workspace diagnostics when the file is saved.",
      None     = "Disable workspace diagnostics.",
    },
    workspaceDelay               = "Latency (milliseconds) for workspace diagnostics.",
    workspaceRate                =
    "Workspace diagnostics run rate (%). Decreasing this value reduces CPU usage, but also reduces the speed of workspace diagnostics. The diagnosis of the file you are currently editing is always done at full speed and is not affected by this setting.",
    libraryFiles                 = {
      "How to diagnose files loaded via `Lua.workspace.library`.",
      Enable  = "Always diagnose these files.",
      Opened  = "Only when these files are opened will it be diagnosed.",
      Disable = "These files are not diagnosed.",
    },
    ignoredFiles                 = {
      "How to diagnose ignored files.",
      Enable  = "Always diagnose these files.",
      Opened  = "Only when these files are opened will it be diagnosed.",
      Disable = "These files are not diagnosed."
    },
    validScheme                  = 'Enable diagnostics for Lua files that use the following scheme.',
    unusedLocalExclude           = 'Do not diagnose `unused-local` when the variable name matches the following pattern.',
    ['unused-local']             = 'Enable unused local variable diagnostics.',
    ['unused-function']          = 'Enable unused function diagnostics.',
    ['undefined-global']         = 'Enable undefined global variable diagnostics.',
    ['global-in-nil-env']        = 'Enable cannot use global variables （ `_ENV` is set to `nil`） diagnostics.',
    ['unused-label']             = 'Enable unused label diagnostics.',
    ['unused-vararg']            = 'Enable unused vararg diagnostics.',
    ['trailing-space']           = 'Enable trailing space diagnostics.',
    ['redefined-local']          = 'Enable redefined local variable diagnostics.',
    ['newline-call']             =
    'Enable newline call diagnostics. It\'s raised when a line starting with `(` is encountered, which is syntactically parsed as a function call on the previous line.',
    ['newfield-call']            =
    'Enable newfield call diagnostics. It is raised when the parenthesis of a function call appear on the following line when defining a field in a table.',
    ['redundant-parameter']      = 'Enable redundant function parameter diagnostics.',
    ['ambiguity-1']              =
    'Enable ambiguous operator precedence diagnostics. For example, the `num or 0 + 1` expression will be suggested `(num or 0) + 1` instead.',
    ['lowercase-global']         = 'Enable lowercase global variable definition diagnostics.',
    ['undefined-env-child']      =
    'Enable undefined environment variable diagnostics. It\'s raised when `_ENV` table is set to a new literal table, but the used global variable is no longer present in the global environment.',
    ['duplicate-index']          = 'Enable duplicate table index diagnostics.',
    ['empty-block']              = 'Enable empty code block diagnostics.',
    ['redundant-value']          =
    'Enable the redundant values assigned diagnostics. It\'s raised during assignment operation, when the number of values is higher than the number of objects being assigned.',
    ['assign-type-mismatch']     =
    'Enable diagnostics for assignments in which the value\'s type does not match the type of the assigned variable.',
    ['await-in-sync']            = 'Enable diagnostics for calls of asynchronous functions within a synchronous function.',
    ['cast-local-type']          =
    'Enable diagnostics for casts of local variables where the target type does not match the defined type.',
    ['cast-type-mismatch']       = 'Enable diagnostics for casts where the target type does not match the initial type.',
    ['circular-doc-class']       =
    'Enable diagnostics for two classes inheriting from each other introducing a circular relation.',
    ['close-non-object']         = 'Enable diagnostics for attempts to close a variable with a non-object.',
    ['code-after-break']         = 'Enable diagnostics for code placed after a break statement in a loop.',
    ['codestyle-check']          = 'Enable diagnostics for incorrectly styled lines.',
    ['count-down-loop']          =
    'Enable diagnostics for `for` loops which will never reach their max/limit because the loop is incrementing instead of decrementing.',
    ['deprecated']               = 'Enable diagnostics to highlight deprecated API.',
    ['different-requires']       = 'Enable diagnostics for files which are required by two different paths.',
    ['discard-returns']          =
    'Enable diagnostics for calls of functions annotated with `---@nodiscard` where the return values are ignored.',
    ['doc-field-no-class']       = 'Enable diagnostics to highlight a field annotation without a defining class annotation.',
    ['duplicate-doc-alias']      = 'Enable diagnostics for a duplicated alias annotation name.',
    ['duplicate-doc-field']      = 'Enable diagnostics for a duplicated field annotation name.',
    ['duplicate-doc-param']      = 'Enable diagnostics for a duplicated param annotation name.',
    ['duplicate-set-field']      = 'Enable diagnostics for setting the same field in a class more than once.',
    ['incomplete-signature-doc'] = 'Incomplete @param or @return annotations for functions.',
    ['invisible']                = 'Enable diagnostics for accesses to fields which are invisible.',
    ['missing-global-doc']       =
    'Missing annotations for globals! Global functions must have a comment and annotations for all parameters and return values.',
    ['missing-local-export-doc'] =
    'Missing annotations for exported locals! Exported local functions must have a comment and annotations for all parameters and return values.',
    ['missing-parameter']        =
    'Enable diagnostics for function calls where the number of arguments is less than the number of annotated function parameters.',
    ['missing-return']           = 'Enable diagnostics for functions with return annotations which have no return statement.',
    ['missing-return-value']     =
    'Enable diagnostics for return statements without values although the containing function declares returns.',
    ['need-check-nil']           =
    'Enable diagnostics for variable usages if `nil` or an optional (potentially `nil`) value was assigned to the variable before.',
    ['unnecessary-assert']       = 'Enable diagnostics for redundant assertions on truthy values.',
    ['no-unknown']               = 'Enable diagnostics for cases in which the type cannot be inferred.',
    ['not-yieldable']            = 'Enable diagnostics for calls to `coroutine.yield()` when it is not permitted.',
    ['param-type-mismatch']      =
    'Enable diagnostics for function calls where the type of a provided parameter does not match the type of the annotated function definition.',
    ['redundant-return']         =
    'Enable diagnostics for return statements which are not needed because the function would exit on its own.',
    ['redundant-return-value']   =
    'Enable diagnostics for return statements which return an extra value which is not specified by a return annotation.',
    ['return-type-mismatch']     =
    'Enable diagnostics for return values whose type does not match the type declared in the corresponding return annotation.',
    ['spell-check']              = 'Enable diagnostics for typos in strings.',
    ['name-style-check']         = 'Enable diagnostics for name style.',
    ['unbalanced-assignments']   =
    'Enable diagnostics on multiple assignments if not all variables obtain a value (e.g., `local x,y = 1`).',
    ['undefined-doc-class']      = 'Enable diagnostics for class annotations in which an undefined class is referenced.',
    ['undefined-doc-name']       = 'Enable diagnostics for type annotations referencing an undefined type or alias.',
    ['undefined-doc-param']      =
    'Enable diagnostics for cases in which a parameter annotation is given without declaring the parameter in the function definition.',
    ['undefined-field']          = 'Enable diagnostics for cases in which an undefined field of a variable is read.',
    ['unknown-cast-variable']    = 'Enable diagnostics for casts of undefined variables.',
    ['unknown-diag-code']        = 'Enable diagnostics in cases in which an unknown diagnostics code is entered.',
    ['unknown-operator']         = 'Enable diagnostics for unknown operators.',
    ['unreachable-code']         = 'Enable diagnostics for unreachable code.',
    ['global-element']           = 'Enable diagnostics to warn about global elements.',
  },
  workspace           = {
    ignoreDir        = "Ignored files and directories (Use `.gitignore` grammar).",
    ignoreSubmodules = "Ignore submodules.",
    useGitIgnore     = "Ignore files list in `.gitignore` .",
    maxPreload       = "Max preloaded files.",
    preloadFileSize  = "Skip files larger than this value (KB) when preloading.",
    library          =
    "In addition to the current workspace, which directories will load files from. The files in these directories will be treated as externally provided code libraries, and some features (such as renaming fields) will not modify these files.",
    checkThirdParty  = [[
Automatic detection and adaptation of third-party libraries, currently supported libraries are:
* OpenResty
* Cocos4.0
* LÖVE
* LÖVR
* skynet
* Jass
]],
    userThirdParty   =
    'Add private third-party library configuration file paths here, please refer to the built-in [configuration file path](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)',
    supportScheme    = 'Provide language server for the Lua files of the following scheme.',
  },
  completion          = {
    enable           = 'Enable completion.',
    displayContext   =
    "Previewing the relevant code snippet of the suggestion may help you understand the usage of the suggestion. The number set indicates the number of intercepted lines in the code fragment. If it is set to `0`, this feature can be disabled.",
    workspaceWord    = "Whether the displayed context word contains the content of other files in the workspace.",
    autoRequire      = "When the input looks like a file name, automatically `require` this file.",
    showParams       =
    "Display parameters in completion list. When the function has multiple definitions, they will be displayed separately.",
    requireSeparator = "The separator used when `require`.",
    postfix          = "The symbol used to trigger the postfix suggestion.",
    callSnippet      = {
      'Shows function call snippets.',
      Disable = "Only shows `function name`.",
      Both    = "Shows `function name` and `call snippet`.",
      Replace = "Only shows `call snippet.`",
    },
    keywordSnippet   = {
      'Shows keyword syntax snippets.',
      Disable = "Only shows `keyword`.",
      Both    = "Shows `keyword` and `syntax snippet`.",
      Replace = "Only shows `syntax snippet`.",
    },
    showWord         = {
      "Show contextual words in suggestions.",
      Enable   = "Always show context words in suggestions.",
      Fallback = "Contextual words are only displayed when suggestions based on semantics cannot be provided.",
      Disable  = "Do not display context words.",
    },
  },
  color               = {
    mode = {
      "Color mode",
      Semantic         = "Semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.",
      SemanticEnhanced =
      "Enhanced semantic color. Like `Semantic`, but with additional analysis which might be more computationally expensive.",
      Grammar          = "Grammar color.",
    },
  },
  semantic            = {
    enable     = "Enable semantic color. You may need to set `editor.semanticHighlighting.enabled` to `true` to take effect.",
    variable   = "Semantic coloring of variables/fields/parameters.",
    annotation = "Semantic coloring of type annotations.",
    keyword    =
    "Semantic coloring of keywords/literals/operators. You only need to enable this feature if your editor cannot do syntax coloring.",
  },
  hover               = {
    enable        = "Enable hover.",
    viewString    = "Hover to view the contents of a string (only if the literal contains an escape character).",
    viewStringMax = "The maximum length of a hover to view the contents of a string.",
    viewNumber    = "Hover to view numeric content (only if literal is not decimal).",
    fieldInfer    =
    "When hovering to view a table, type infer will be performed for each field. When the accumulated time of type infer reaches the set value (MS), the type infer of subsequent fields will be skipped.",
    previewFields = "When hovering to view a table, limits the maximum number of previews for fields.",
    enumsLimit    = "When the value corresponds to multiple types, limit the number of types displaying.",
    expandAlias   = [[,
Whether to expand the alias. For example, expands `---@alias myType boolean|number` appears as `boolean|number`, otherwise it appears as `myType'.
]]
  },
  develop             = {
    enable       = 'Developer mode. Do not enable, performance will be affected.',
    debuggerPort = 'Listen port of debugger.',
    debuggerWait = 'Suspend before debugger connects.',
  },
  intelliSense        = {
    searchDepth =
    'Set the search depth for IntelliSense. Increasing this value increases accuracy, but decreases performance. Different workspace have different tolerance for this setting. Please adjust it to the appropriate value.',
    fastGlobal  =
    'In the global variable completion, and view `_G` suspension prompt. This will slightly reduce the accuracy of type speculation, but it will have a significant performance improvement for projects that use a lot of global variables.',
  },
  window              = {
    statusBar   = 'Show extension status in status bar.',
    progressBar = 'Show progress bar in status bar.',
  },
  hint                = {
    enable         = 'Enable inlay hint.',
    paramType      = 'Show type hints at the parameter of the function.',
    setType        = 'Show hints of type at assignment operation.',
    await          = 'If the called function is marked `---@async`, prompt `await` at the call.',
    awaitPropagate = 'Enable the propagation of `await`. When a function calls a function marked `---@async`,\z
it will be automatically marked as `---@async`.',
    paramName      = {
      'Show hints of parameter name at the function call.',
      All     = 'All types of parameters are shown.',
      Literal = 'Only literal type parameters are shown.',
      Disable = 'Disable parameter hints.',
    },
    arrayIndex     = {
      'Show hints of array index when constructing a table.',
      Enable  = 'Show hints in all tables.',
      Auto    = 'Show hints only when the table is greater than 3 items, or the table is a mixed table.',
      Disable = 'Disable hints of array index.',
    },
    semicolon      = {
      'If there is no semicolon at the end of the statement, display a virtual semicolon.',
      All      = 'All statements display virtual semicolons.',
      SameLine = 'When two statements are on the same line, display a semicolon between them.',
      Disable  =
      'Disable virtual semicolons.'
    },
  },
  codeLens            = {
    enable = 'Enable code lens.',
  },
  format              = {
    enable        = 'Enable code formatter.',
    defaultConfig = [[
The default format configuration. Has a lower priority than `.editorconfig` file in the workspace.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]],
  },
  spell               = {
    dict = 'Custom words for spell checking.',
  },
  nameStyle           = {
    config = [[
Set name style config.
Read [formatter docs](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs) to learn usage.
]],
  },
  telemetry           = {
    enable = [[
Enable telemetry to send your editor information and error logs over the network. Read our privacy policy [here](https://luals.github.io/privacy/#language-server).,
]],
  },
  misc                = {
    parameters     =
    '[Command line parameters](https://github.com/LuaLS/lua-telemetry-server/tree/master/method) when starting the language server in VSCode.',
    executablePath = 'Specify the executable path in VSCode.',
  },
  language            = {
    fixIndent          =
    '(VSCode only) Fix incorrect auto-indentation, such as incorrect indentation when line breaks occur within a string containing the word "function".',
    completeAnnotation = '(VSCode only) Automatically insert "---@ " after a line break following a annotation.',
  },
  type                = {
    castNumberToInteger = 'Allowed to assign the `number` type to the `integer` type.',
    weakUnionCheck      = [[
Once one subtype of a union type meets the condition, the union type also meets the condition.
When this setting is `false`, the `number|boolean` type cannot be assigned to the `number` type. It can be with `true`.
]],
    weakNilCheck        = [[
When checking the type of union type, ignore the `nil` in it.
When this setting is `false`, the `number|nil` type cannot be assigned to the `number` type. It can be with `true`.
]],
    inferParamType      = [[
When a parameter type is not annotated, it is inferred from the function's call sites.
When this setting is `false`, the type of the parameter is `any` when it is not annotated.
]],
    checkTableShape     = 'Strictly check the shape of the table.',
    inferTableSize      = 'Maximum number of table fields analyzed during type inference.',
  },
  doc                 = {
    privateName   =
    'Treat specific field names as private, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are private, witch can only be accessed in the class where the definition is located.',
    protectedName =
    'Treat specific field names as protected, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are protected, witch can only be accessed in the class where the definition is located and its subclasses.',
    packageName   =
    'Treat specific field names as package, e.g. `m_*` means `XXX.m_id` and `XXX.m_type` are package, witch can only be accessed in the file where the definition is located.',
    regengine     = {
      'The regular expression engine used for matching documentation scope names.',
      glob = 'The default lightweight pattern syntax.',
      lua  = 'Full Lua-style regular expressions.',
    },
  },
  docScriptPath       = 'The regular expression engine used for matching documentation scope names.',
  signatureHelp       = {
    enable = "Enable signature help.",
  },
  typeFormat          = {
    config = {
      'Configures the formatting behavior while typing Lua code.',
      auto_complete_end       = 'Controls if `end` is automatically completed at suitable positions.',
      auto_complete_table_sep = 'Controls if a separator is automatically appended at the end of a table declaration.',
      format_line             = 'Controls if a line is formatted at all.',
    },
  },
}

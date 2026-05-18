# DeepSeek V4 Pro Setup

OpenCode is installed in this workspace. DeepSeek credentials still need to be connected interactively.

## Connect DeepSeek

From this directory:

```powershell
opencode
```

Inside OpenCode:

```text
/connect
```

Choose `deepseek`, paste your DeepSeek API key, then run:

```text
/models
```

Choose `DeepSeek-V4-Pro`.

If OpenCode displays a model id different from `deepseek/DeepSeek-V4-Pro`, update this field in `opencode.jsonc`:

```jsonc
"model": "deepseek/DeepSeek-V4-Pro"
```

## Expected State

After connection, this command should list DeepSeek models:

```powershell
opencode models deepseek
```

Before connection, `opencode models deepseek` may report `Provider not found: deepseek`. That is expected.

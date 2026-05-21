# Neovim 快捷键速查（LazyVim + Cursor Agent）

> 配置文件目录：`~/.config/nvim`  
> 最后更新：2026-05-21

---

## 1. 先搞懂 `<leader>` 是什么

你的配置里：

```lua
vim.g.mapleader = " "
```

所以 **`<leader>` = 空格键（Space）**。

### 怎么按组合键？

**依次按**，不要同时按：

| 写法 | 实际按法 |
|------|----------|
| `<leader>e` | **空格** → `e` |
| `<leader>aa` | **空格** → `a` → `a` |
| `<leader>cf` | **空格** → `c` → `f` |

按空格后，底部常会弹出 **which-key** 菜单，可以看着选，不用死记。

---

## 2. 推荐日常流程

### 打开项目

```bash
cd /path/to/your/project   # 必须在有 go.mod 等项目根的目录
nvim .                     # 或 nvim <某个文件>
```

Go 项目示例：

```bash
cd /Users/mobvista/fegtech/topon-bidder/engine/tracking/adn-tracking
nvim .
```

### 终端一键进入 Cursor Agent Zen 模式

```bash
avante
```

（已在 `~/.zshrc` 里配置 alias，新开终端后可用。）

---

## 3. Cursor Agent（avante.nvim + ACP）

AI 能力由 **avante.nvim** 接入 **Cursor CLI Agent**（`agent acp`）。

### 3.1 全局快捷键（Normal 模式）

| 快捷键 | 作用 |
|--------|------|
| `<leader>at` | 打开/关闭 Agent **侧边栏** |
| `<leader>aa` | **提问**（Ask，弹出输入框） |
| `<leader>an` | **新建对话** |
| `<leader>ae` | **编辑选中代码**（先 `v` 选中，再按） |
| `<leader>az` | **Zen 模式**（全屏 CLI 风格 Agent 界面） |
| `<leader>ar` | 刷新 |
| `<leader>af` | 聚焦 Agent 窗口 |
| `<leader>aS` | **停止** Agent 运行 |
| `<leader>ac` | 把**当前文件**加入 Agent 上下文 |
| `<leader>aB` | 把所有已打开 buffer 加入上下文 |
| `<leader>ah` | 选择历史对话 |
| `<leader>am` | 选择 ACP **模式**（Agent / Ask / Plan 等） |
| `<leader>aM` | 选择 ACP **模型** |
| `<leader>a?` | 选择模型（命令） |

> 按 **空格** 后等 which-key，可看到所有 `a` 开头的 AI 快捷键。

### 3.2 侧边栏内快捷键（焦点在 Agent 面板时）

| 键 | 作用 |
|----|------|
| `A` | 应用全部改动 |
| `a` | 应用当前光标处改动 |
| `r` | 重试上一条请求 |
| `e` | 编辑上一条请求 |
| `d` | 从上下文移除文件 |
| `@` | 添加文件 |
| `Tab` / `Shift+Tab` | 切换窗口 / 反向切换 |
| `]`p / `[`p | 下一条 / 上一条 prompt |
| `q` / `Esc` | 关闭 |

### 3.3 输入框内

| 键 / 输入 | 作用 |
|-----------|------|
| `@` | 引用文件、codebase、diagnostics 等 |
| `/` | 斜杠命令，如 `/help` `/clear` `/new` `/compact` |
| `#` | 快捷模板（如 `#refactor`） |
| `Enter` | 发送（Normal 模式） |
| `Ctrl+s` | 发送（Insert 模式） |
| `Ctrl+c` / `Esc` | 取消 |

### 3.4 Diff 冲突（Agent 改代码后）

| 键 | 作用 |
|----|------|
| `co` | 保留我的（ours） |
| `ct` | 采用 Agent 的（theirs） |
| `ca` | 全部采用 theirs |
| `cb` | 两者都保留 |
| `cc` | 以光标处为准 |
| `]x` / `[x` | 下一个 / 上一个冲突 |

### 3.5 认证

首次使用如提示登录，在终端执行：

```bash
agent login
agent whoami   # 确认已登录
```

---

## 4. 文件与窗口

### 4.1 文件树（Neo-tree）

| 快捷键 | 作用 |
|--------|------|
| `<leader>e` | 打开/关闭文件树（项目根目录） |
| `<leader>E` | 文件树（当前工作目录 cwd） |
| `<leader>fe` | 同 `<leader>e` |
| `<leader>ge` | Git 状态文件树 |
| `<leader>be` | Buffer 文件树 |

**文件树内（焦点在左侧树时）：**

| 键 | 作用 |
|----|------|
| `l` / `Enter` | 打开 / 展开 |
| `h` | 折叠 |
| `Y` | 复制文件路径到剪贴板 |
| `O` | 用系统默认程序打开 |
| `P` | 切换预览 |
| `Backspace` | 根目录上移一级 |
| `.`（点在文件夹上） | 把该文件夹设为新的根目录 |
| `IP`（先按 `I` 再按 `P`） | 光标跳到父节点（自定义） |

**文件树图标说明（从左到右）：**

| 位置 | 含义 |
|------|------|
| 第 1 个 | 展开/折叠箭头 |
| 第 2 个 | 文件夹 / 文件类型图标 |
| 最右侧 | LSP 诊断（错误/警告）或 Git 状态 |

### 4.2 查找文件

| 快捷键 | 作用 |
|--------|------|
| `<leader><space>` | 查找文件（**Neo-tree 当前根**；未打开树时等同项目根） |
| `<leader>ff` | 同上 |
| `<leader>fF` | 查找文件（cwd） |
| `<leader>fr` | 最近打开的文件 |
| `<leader>/` | 项目内 Live Grep |
| `<leader>sg` | 项目内 Live Grep |
| `<leader>,` | 切换 Buffer 列表 |

> 在文件树里用 `.` 把某文件夹设为根目录后，`<leader><space>` / `ff` 会在该目录下找文件。

### 4.3 Buffer（标签页）

| 快捷键 | 作用 |
|--------|------|
| `<S-h>` / `<S-l>` | 上一个 / 下一个 Buffer |
| `[b` / `]b` | 上一个 / 下一个 Buffer |
| `<leader>bd` | 关闭当前 Buffer |
| `<leader>bo` | 关闭其他 Buffer |
| `<leader>bh` / `<leader>bl` | Buffer 线：上一个 / 下一个 |
| `<leader>b[` / `<leader>b]` | 移动 Buffer 位置 |

### 4.4 窗口与分屏

| 快捷键 | 作用 |
|--------|------|
| `<leader>\|` | 垂直分屏（左右） |
| `<leader>-` | 水平分屏（上下） |
| `<leader>wd` | 关闭当前窗口 |
| `<leader>wm` | 最大化/还原窗口 |
| `Ctrl+w` + `h/j/k/l` | 在窗口间移动（Vim 原生） |

> **注意**：你的自定义配置里，`Ctrl+h/j/k/l` 被映射为**调整窗口大小**（见第 8 节），不再用于切换窗口。切换窗口请用 `Ctrl+w h` 等。

### 4.5 终端（Snacks 浮动窗）

浮动终端默认 **85%×80%** 居中圆角窗（`lua/plugins/p-editor.lua`）。

#### 打开终端

| 快捷键 | 模式 | 作用 |
|--------|------|------|
| `<leader>ft` | Normal | 在 **Neo-tree 当前根** 打开终端（每次新建/聚焦，不 toggle） |
| `<Ctrl-/>` | Normal、Terminal | 同上（Neo-tree 根） |
| `<leader>fT` | Normal | **切换** 浮动终端（**cwd**；已开则关闭） |
| `<Ctrl-_>` / `<Ctrl-\>` | Normal、Insert、Visual、Terminal | **切换** 浮动终端（LazyVim 项目根） |
| `<Ctrl-/>` | Insert、Visual | **切换** 浮动终端（LazyVim 项目根） |

> **Neo-tree 根**：与 4.2 相同——文件树里 `.` 设过的目录，或树未打开时的项目根。

#### 关闭浮窗

| 方式 | 说明 |
|------|------|
| 用 **toggle** 打开的（`Ctrl-_` / `Ctrl-\` / `fT` / Insert·Visual 下 `Ctrl+/`） | 再按一次相同快捷键即可关闭 |
| 终端 **Normal/Insert** 内 | `Ctrl+/`、`Ctrl-\`、`Ctrl-_` 直接关窗 |
| 终端 Normal 模式 | `q` |
| `Esc` `Esc` | 仅从 Insert 回到终端 Normal，**不**关窗 |

> **Cursor 终端**：若 `Ctrl+/` 被 IDE 拦截，请用 `Ctrl-\` 或 `Ctrl-_` 切换浮动终端。

### 4.6 保存与退出

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+s` | 保存 |
| `<leader>qq` | 退出全部 |
| `:q` | 退出 |
| `:wq` | 保存并退出 |

---

## 5. 代码导航与 LSP（Go / C++ / Python 等）

光标放在符号（函数名、变量名）上，在 **Normal 模式**使用：

| 快捷键 | 作用 |
|--------|------|
| `gd` | 跳转到**定义** |
| `gD` | 跳转到**声明** |
| `gr` | 查看**引用** |
| `gI` | 跳转到**实现** |
| `gy` | 跳转到**类型定义** |
| `K` | 悬停文档（Hover） |
| `gK` | 签名帮助 |
| `Ctrl+o` | 跳回上一位置 |
| `Ctrl+i` | 跳转到下一位置 |

### 代码操作

| 快捷键 | 作用 |
|--------|------|
| `<leader>ca` | 代码动作（Code Action） |
| `<leader>cr` | 重命名符号 |
| `<leader>cf` | 格式化文件/选中区域（**C/C++ 保存时不自动格式化**） |
| `<leader>cl` | LSP 信息（Snacks picker） |
| `<leader>co` | 整理 import（Go 等支持时） |
| `<leader>cc` | 运行 Code Lens |
| `<leader>cs` | 符号列表（Trouble） |
| `<leader>cS` | LSP 引用/定义列表（Trouble） |

> **Go 项目提示**：第一次打开大项目，gopls 索引约需 30~60 秒，等索引完成后再 `gd` 跳转更稳定。

---

## 6. 诊断（错误 / 警告）

| 快捷键 | 作用 |
|--------|------|
| `]d` / `[d` | 下一条 / 上一条诊断 |
| `]e` / `[e` | 下一条 / 上一条 **错误** |
| `]w` / `[w` | 下一条 / 上一条 **警告** |
| `<leader>cd` | 当前行诊断浮窗 |
| `Ctrl+n` | 下一条警告及以上（**自定义**） |
| `Ctrl+m` | 下一条错误（**自定义**） |
| `<leader>xx` | Trouble 诊断面板 |
| `<leader>xX` | 当前 Buffer 诊断 |
| `<leader>sd` | 搜索全部诊断 |
| `<leader>sD` | 搜索当前 Buffer 诊断 |
| `<leader>ud` | 开关行内诊断显示 |

---

## 7. Git

**光标所在行**会自动显示 Git 信息（作者、提交时间、说明）：
- 行尾灰色 virtual text（gitsigns）
- 底部状态栏同步显示

| 快捷键 | 作用 |
|--------|------|
| `<leader>gg` | LazyGit（项目根） |
| `<leader>gG` | LazyGit（cwd） |
| `<leader>gs` | Git 状态搜索 |
| `<leader>gd` | Git Diff（hunks） |
| `<leader>gl` | Git Log |
| `<leader>uB` | 开关行内 Git Blame 显示 |
| `]h` / `[h` | 下一个 / 上一个 Hunk |

### Hunk 操作

| 快捷键 | 作用 |
|--------|------|
| `<leader>ghs` | Stage Hunk |
| `<leader>ghr` | Reset Hunk |
| `<leader>ghp` | Preview Hunk |
| `<leader>ghb` | 当前行 Blame 浮窗（完整信息） |

---

## 8. 你的自定义快捷键

来自 `lua/config/keymaps.lua`：

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+n` | 跳到下一条警告/错误诊断 |
| `Ctrl+m` | 跳到下一条错误诊断 |
| `Ctrl+h` | 窗口**变宽** |
| `Ctrl+l` | 窗口**变窄** |
| `Ctrl+j` | 窗口**变矮** |
| `Ctrl+k` | 窗口**变高** |
| `<leader>zif` | 插入当前文件名 |
| `<leader>zit` | 插入当前时间 |
| `<leader>td` | 插入 Doxygen 文件头注释 |
| `<leader>tf` | 插入 Doxygen 函数注释 |
| `v` + `<leader>y` | 复制选中内容到系统剪贴板 |
| `v` + `<leader>p` | 从系统剪贴板粘贴 |

---

## 9. 自定义命令

在 Normal 模式输入 `:` 后执行：

| 命令 | 作用 |
|------|------|
| `:LspInfo` | 查看当前 LSP 附着状态 |
| `:checkhealth` | 健康检查 |
| `:checkhealth vim.lsp` | LSP 健康检查 |
| `:checkhealth vim.treesitter` | Treesitter 检查 |
| `:TSUpdate` | 更新 Treesitter 解析器 |
| `:Lazy` | 插件管理 |
| `:messages` | 查看历史消息/报错 |
| `:Ibd` | 关闭 buffer 并切到下一个 |
| `:Ibdp` | 关闭 buffer 并切到上一个 |
| `:Ibdo` | 关闭所有 buffer，保留最后一个 |
| `:ClangFmt` | 用 clang-format 格式化当前文件 |
| `:NewClangFmtFile` | 生成 `.clang-format` 配置 |
| `:TermShow` | 显示终端 ANSI 内容 |

---

## 10. 其他常用 LazyVim 快捷键

| 快捷键 | 作用 |
|--------|------|
| `<leader>sk` | 搜索所有快捷键 |
| `<leader>?` | 当前 Buffer 可用快捷键 |
| `<leader>ur` | 清搜索高亮 + 刷新界面 |
| `<leader>l` | 打开 Lazy 插件面板 |
| `<leader>fn` | 新建空文件 |
| `<leader>uf` | 开关保存时自动格式化 |
| `<leader>uF` | 全局开关自动格式化 |
| `<leader>uw` | 开关自动换行 |
| `<leader>uh` | 开关 Inlay Hints |
| `<leader>n` | 通知历史 |
| `<leader>cm` | Mason（LSP 工具管理） |

---

## 11. 模式说明

| 模式 | 如何识别 | 说明 |
|------|----------|------|
| Normal | 左下角无 `-- INSERT --` | 默认模式，按快捷键 |
| Insert | 左下角 `-- INSERT --` | 编辑文本，按 `Esc` 回到 Normal |
| Visual | 左下角 `-- VISUAL --` | 选中文本，按 `v` / `V` / `Ctrl+v` 进入 |
| Command | 底部出现 `:` | 输入命令，如 `:LspInfo` |

---

## 12. 速记卡片

```
打开项目:     cd 项目 && nvim .
文件树:       空格 e
AI 侧边栏:    空格 a t
AI 提问:      空格 a a
AI 全屏:      空格 a z  /  终端 avante
跳转定义:     g d
返回:         Ctrl o
保存:         Ctrl s
查找文件:     空格 空格  (Neo-tree 根)
浮动终端:     Ctrl-_ / Ctrl-\  (toggle)
Neo-tree终端: 空格 f t  /  Ctrl+/ (Normal)
搜索内容:     空格 /
格式化:       空格 c f
LazyGit:      空格 g g
退出:         空格 q q
```

---

## 13. 相关文件

| 文件 | 内容 |
|------|------|
| `lua/plugins/p-git.lua` | Git blame、变更标记 |
| `lua/plugins/tool-ai.lua` | Cursor Agent (avante) 配置 |
| `lua/plugins/p-ui.lua` | 文件树、图标配置 |
| `lua/plugins/lang-go.lua` | Go / gopls 配置 |
| `lua/plugins/p-editor.lua` | Snacks 查找/终端、conform、lint |
| `lua/config/autocmds.lua` | 大文件优化、C/C++ 禁用保存格式化、vim parser 自检 |
| `lua/config/keymaps.lua` | 自定义快捷键 |
| `lua/config/options.lua` | leader = 空格 等 |

如有疑问，在 nvim 里按 `<leader>sk` 可搜索全部快捷键。

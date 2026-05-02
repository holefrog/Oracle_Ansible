# 🚀 Ubuntu AI 编程环境安装指南

本指南用于在 Ubuntu (x86_64) 上部署 VS Code、Cline 及接入 NVIDIA 算力。

---

## 1. 安装 VS Code (两种方法)

### 方法 A：官方软件源安装（推荐，支持自动更新）
这种方法更稳定，不会出现找不到文件的问题：
```bash
# 1. 下载密钥
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > temp_microsoft.gpg

# 2. 移动到系统目录
sudo install -D -o root -g root -m 644 temp_microsoft.gpg /etc/apt/keyrings/microsoft.gpg

# 3. 写入源 (使用引号包裹 URL)
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# 4. 更新并安装
sudo apt update
sudo apt install code -y
```

### 方法 B：直接下载 .deb 安装包
如果你坚持使用 .deb 文件，请确保 URL 使用引号包裹：
```bash
# 确保在 Temp 目录下执行
wget -O vscode.deb "[https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64](https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64)"
sudo apt install ./vscode.deb -y
```

---

## 2. 配置 AI 重构环境 (Cline + NVIDIA)

1.  **安装插件:** 打开 VS Code，搜索并安装插件 `Cline`。
2.  **接入算力:** 点击 Cline 图标 -> 设置 (Settings)，按以下参数配置：
    *   **API Provider:** `OpenAI Compatible`
    *   **Base URL:** `https://integrate.api.nvidia.com/v1`
    *   **API Key:** `你的nvapi-key`
    *   **Model ID:** `deepseek-ai/deepseek-v4-pro` (推荐重构使用)
3.  **规则约束:** 在项目根目录创建 `.clinerules`，内容如下：
```markdown
# Ansible & Linux Refactoring Rules
- 优先级：严格区分 defaults/ 与 vars/。
- 模块：优先使用原生模块，禁止滥用 shell。
- 实验：修改前必须运行 ansible-lint --syntax-check。
- 安全：严禁读取包含 "secret"、"key" 或 .env 的文件。
```

---

## 3. 常见问题排查
- **权限不足:** 确保在命令前添加 `sudo`。
- **依赖冲突:** 如果 `apt install ./vscode.deb` 报错，尝试运行 `sudo apt --fix-broken install`。
- **API 限流:** NVIDIA 免费 Key 有频率限制，重构大项目时请在 Cline 设置中调低并发。

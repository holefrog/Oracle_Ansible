# 🚀 Ubuntu AI 开发环境一键安装与配置手册 (NVIDIA + Cursor)

这份文档涵盖了从环境安装到 NVIDIA API 集成的全过程，专门针对加拿大（BC省）网络环境及你的开发习惯优化。

---

## 📦 第一阶段：基础环境安装 (Ubuntu)

在 Ubuntu 上，我们首选安装 Cursor 作为核心 IDE，因为它对全库感知（Anti-gravity）的支持最出色。

### 1. 安装 Cursor
官网下载最新deb [https://api2.cursor.sh/updates/download/golden/linux-x64-deb/cursor/3.2]

```bash
sudo apt install cursor_3.2.16_amd64.deb 
```

### 2. 安装必备依赖 (用于 Python/Ansible 开发)
```bash
sudo apt update && sudo apt install -y \
    python3-pip \
    python3-venv \
    ansible \
    curl \
    git
```

---

## ⚙️ 第二阶段：NVIDIA API 深度集成

将 NVIDIA 的算力注入 Cursor，替代昂贵的订阅服务。

### 1. 接入步骤
1.  启动 Cursor，按下 `Ctrl + Shift + J` 进入 **Models** 设置。
2.  在 **"Override OpenAI Base URL"** 填入：
    `https://integrate.api.nvidia.com/v1`
3.  在 **"API Key"** 填入你的 `nvapi-xxxxxxxx....`
4.  **模型清单 (手动添加)**：
    *   `meta/llama-3.1-405b-instruct` (主力逻辑模型)
    *   `nvidia/qwen-2.5-coder-32b` (高频补全模型)
    *   `deepseek-ai/deepseek-r1` (深度推理/查错)

### 2. 网络链路优化 (加拿大本地)
*   **直连测试**：`ping integrate.api.nvidia.com`
*   **路由配置**：若延迟 >100ms，请在 **v2rayNG** 路由规则中将 `integrate.api.nvidia.com` 设为 **Direct**。

---

## 🤖 第三阶段：注入你的开发逻辑 (Anti-gravity 体验)

为了让 AI 遵循你的排查和编写习惯，请在项目根目录创建 `.cursorrules` 文件。

### .cursorrules 预设内容：
```text
# 核心原则
- 解决问题前，先假定主要原因并要求我给出实验结果，再根据结果验证猜测。
- 给出代码修改时，仅针对目标区域，严禁修改或精简无关代码。
- 除非明确要求，不主动编写大段代码。

# 本地化设置
- 默认时区：America/Vancouver (PST/PDT)。
- 开发习惯：优先考虑 Python 异步逻辑与 Ansible 自动化兼容性。

# 隐私保护
- 严禁读取 .env 文件中的敏感 Token。
```

---

## 🛠 第四阶段：故障排查 Ledger (必看)

| 场景 | 故障现象 | 判定与操作 |
| :--- | :--- | :--- |
| **连接故障** | Cursor 右下角报错 "Connection Error" | 1. 检查 ping 延迟；2. **判定为 Pixel 底层故障，直接重启手机**。 |
| **频率限制** | 提示 "429 Too Many Requests" | 免费 Key 每分钟限 40 次。将补全模型切换为较小的 `qwen-2.5-coder-7b`。 |
| **代码截断** | 修改代码时删除了其他部分 | 引用 `.cursorrules` 规则提醒 AI “仅修改目标区域”。 |
| **Oracle 云同步** | 本地代码与服务器不一致 | 使用 Cursor 的 **Remote-SSH** 扩展直接连接 Oracle Cloud 实例进行开发。 |

---

## 📝 五、 验证安装
在终端输入以下命令验证 API 是否畅通：
```bash
curl [https://integrate.api.nvidia.com/v1/models](https://integrate.api.nvidia.com/v1/models) \
     -H "Authorization: Bearer 你的NVIDIA_KEY"
```
若返回一长串模型列表，说明你的“Anti-gravity”开发环境已就绪。

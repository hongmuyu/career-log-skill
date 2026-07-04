# Career Log Skill 设计文档

## 背景

开发者在日常开发中解决问题后，如果等找实习时再整理项目经历，往往记不清当时遇到的困难和解决过程。而简历上最能打动 HR 的是**解决问题的能力**——不是"做了什么"，而是"遇到了什么问题、怎么定位的、怎么解决的、结果如何"。

本 skill 的目标：在日常开发过程中，将问题解决过程持续、细致地沉淀为结构化职业资产，避免事后回忆丢失细节。

核心理念：**不是一次性生成简历，而是把日常开发记录持续转化为高质量的职业资产，比传统简历生成器更符合 AI 开发者的工作方式。**

## 信息源

- **对话上下文为主**：Claude CLI 的对话中天然包含问题定位过程、尝试方案、最终解法等完整叙事
- **git diff 为辅**：补充技术栈、代码变更细节、可量化的指标

## YAML 数据结构

每条开发记录：

```yaml
- id: 20260704-001
  date: 2026-07-04

  project: A2A-Gateway
  project_brief: 基于 Go 的 Agent-to-Agent 通信网关中间件

  task: 修复 WebSocket goroutine 泄漏

  tech:
    - Go
    - WebSocket
    - Context
    - pprof

  problem: 高并发下 WebSocket 连接池泄漏，导致服务 OOM。

  solution: 使用 pprof 定位问题，为每个连接引入 derived context，实现连接关闭时 goroutine 自动释放。

  result: goroutine 泄漏率降为 0，72 小时压力测试无 OOM。

  metrics:
    - goroutine_leak=0
    - stress_test=72h

  role:
    - 后端开发
```

字段说明：
- `id`：日期 + 序号，自动生成
- `date`：自动取当天
- `project`：从 git 仓库名推断，或用户手动指定
- `project_brief`：同项目已有则继承，首次需生成
- `task`：简要描述本次做了什么
- `tech`：涉及的技术栈，从 git diff 和对话上下文推断
- `problem`：遇到了什么问题
- `solution`：怎么定位和解决的
- `result`：最终效果
- `metrics`：可量化的结果指标
- `role`：在项目中的角色

## 工作流

```
1. 用户输入 /skill（或 /skill <项目名>）

2. Skill 确定项目名：
   - 优先使用用户指定的项目名
   - 未指定则从 git 仓库名自动推断
   - 推断失败则询问用户

3. Skill 综合两个信息源全自动生成完整 YAML：
   - 对话上下文 → problem / solution / result 的核心内容
   - git diff → tech / 具体技术细节 / metrics
   - 所有字段均自动填充，推断不了的字段留空

4. 展示给用户 review：
   - 用户逐条确认或修改
   - 补充自动推断不了的内容

5. 确认后写入：
   - YAML 追加到日志文件（配置的 log_dir 下按项目分文件）
   - 从 YAML 生成精炼中文条目，追加到简历文件
```

## 简历条目模板

同一项目的多条记录挂在同一个项目标题下，按时间倒序：

```markdown
## A2A-Gateway

> 基于 Go 的 Agent-to-Agent 通信网关中间件 | 后端开发

- **修复 WebSocket goroutine 泄漏**：高并发下连接池泄漏导致服务 OOM，
  使用 pprof 定位后引入 derived context 自动释放 goroutine，
  泄漏率降为 0，72h 压测稳定
- **优化消息路由性能**：路由表全量扫描导致 P99 延迟 800ms，
  改用前缀树索引后降至 15ms，吞吐提升 50 倍
```

模板规则：
1. 项目标题 + 简介 + 角色放一行，用 `>` 引用块
2. 每条记录一个要点，加粗 task 作为标题，problem → solution → result 一句话串联
3. 有 metrics 就带数字，没有就不硬凑
4. 同项目 `project_brief` 和 `role` 只在项目标题行出现一次（取最新记录的值）

## 配置

配置文件：`~/.career/config.yaml`

```yaml
log_dir: "~/career/log"           # YAML 日志存放目录
resume_path: "~/career/resume.md" # 简历文件路径
default_project: ""               # 可选，默认项目名（不填则从 git 仓库名推断）
```

- 首次调用 skill 时如未配置，引导用户设置
- 配置一次后持久生效，用户可随时自行修改

## 存储设计

- **日志目录**：用户指定（如 `~/career/log/`），下按项目分文件（`A2A-Gateway.yaml`、`chat-app.yaml`...）
- **简历文件**：用户指定路径（如 `~/career/resume.md`）
- 存储与项目目录完全解耦，所有职业资产集中管理

## 开源项目定位

本项目将作为开源 plugin 发布，任何 Claude Code 用户都可以安装使用。

### 项目结构

```
career-log-skill/
├── .claude-plugin/
│   └── plugin.json              # 插件清单
├── README.md                    # 使用说明
├── skills/
│   └── career-log/
│       ├── SKILL.md             # skill 定义文件
│       └── references/
│           ├── yaml-schema.md   # YAML 字段规范
│           └── resume-template.md # 简历模板规则
├── scripts/
│   └── git-scan.sh              # git 扫描辅助脚本
├── docs/
│   └── specs/                   # 设计文档
└── LICENSE
```

### 开源需考虑的通用性

- 配置路径不能硬编码，每个用户的 `log_dir` 和 `resume_path` 不同
- 首次使用需引导配置流程
- 简历模板可考虑未来支持用户自定义（当前先内置中文模板）
- README 需包含安装方式、配置说明、使用示例

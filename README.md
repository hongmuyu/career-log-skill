# career-log-skill

将日常开发中的问题解决过程持续沉淀为结构化职业资产，自动生成简历条目。

不是一次性生成简历，而是把日常开发记录持续转化为高质量的职业资产——比传统简历生成器更符合 AI 开发者的工作方式。

## 为什么需要这个 skill？

等找实习时再整理项目经历，往往记不清当时遇到的困难和解决过程。而简历上最能打动 HR 的是**解决问题的能力**。

career-log 在你解决问题的当下就记录下来——对话上下文里有完整的问题定位过程，比事后回忆真实 10 倍。

## 核心特点

- **对话上下文为主**：自动从当前对话中提炼 problem → solution → result
- **git 变更为辅**：补充技术栈和代码细节
- **全自动生成，你只管审**：所有字段自动填充，review 后一键写入
- **细致不笼统**：重点放在遇到了什么问题、怎么解决的、结果如何
- **双输出**：YAML 日志保留原始结构化数据，简历输出精炼中文条目

## 安装

```bash
# 克隆到 Claude Code skills 目录
git clone https://github.com/hongmuyu/career-log-skill.git ~/.claude/skills/career-log-skill
```

或在 Claude Code 中手动添加插件路径。

## 首次配置

首次调用 `/career-log` 时会引导你配置：

```yaml
# ~/.career/config.yaml
log_dir: "~/career/log"           # YAML 日志存放目录
resume_path: "~/career/resume.md" # 简历文件路径
default_project: ""               # 可选，默认项目名
```

也可以手动创建此文件。

## 使用方式

```
# 在任何项目目录下
/career-log-skill:career-log              # 自动推断项目名
/career-log-skill:career-log A2A-Gateway  # 指定项目名
```

## 生成的 YAML 日志示例

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

## 生成的简历条目示例

```markdown
## A2A-Gateway

> 基于 Go 的 Agent-to-Agent 通信网关中间件 | 后端开发

- **修复 WebSocket goroutine 泄漏**：高并发下连接池泄漏导致服务 OOM，
  使用 pprof 定位后引入 derived context 自动释放 goroutine，
  泄漏率降为 0，72h 压测稳定
- **优化消息路由性能**：路由表全量扫描导致 P99 延迟 800ms，
  改用前缀树索引后降至 15ms，吞吐提升 50 倍
```

## 目录结构

```
career-log-skill/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── career-log/
│       ├── SKILL.md
│       └── references/
│           ├── yaml-schema.md
│           └── resume-template.md
├── scripts/
│   └── git-scan.sh
├── docs/
│   └── specs/
├── README.md
└── LICENSE
```

## License

MIT

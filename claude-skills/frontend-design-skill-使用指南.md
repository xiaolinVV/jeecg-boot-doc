# frontend-design Skill 使用指南

> 本文档汇总了 `frontend-design` Skill 的核心能力、使用方法及最佳实践，帮助你高效创建高质量的前端界面。

---

## 目录

- [1. Skill 概述](#1-skill-概述)
- [2. 核心能力](#2-核心能力)
- [3. 输出格式](#3-输出格式)
- [4. 资源处理](#4-资源处理)
- [5. 产品思维边界](#5-产品思维边界)
- [6. 最佳实践案例](#6-最佳实践案例)
- [7. 技术实现原理](#7-技术实现原理)
- [8. 常见问题](#8-常见问题)

---

## 1. Skill 概述

### 1.1 什么是 frontend-design？

`frontend-design` 是 Claude Code 内置的专业级前端设计 Skill，用于创建**生产级、高设计质量**的前端界面。

### 1.2 核心定位

```
frontend-design = 设计师 + 前端工程师
```

| 角色 | 负责内容 |
|-----|---------|
| 设计师 | 风格选择、色彩搭配、字体排版、动画交互 |
| 前端工程师 | HTML/CSS/JS 实现、组件封装、响应式布局 |

### 1.3 安装位置

```
~/.claude/plugins/cache/anthropic-agent-skills/document-skills/69c0b1a06741/skills/frontend-design/SKILL.md
```

---

## 2. 核心能力

### 2.1 设计能力矩阵

| 能力维度 | 说明 |
|---------|------|
| **Typography** | 拒绝通用字体（Inter/Roboto/Arial），使用独特、有个性的字体组合 |
| **Color & Theme** | CSS 变量管理一致性，主导色 + 强调色方案 |
| **Motion** | CSS 动画、staggered reveals、scroll/hover 微交互 |
| **Spatial Composition** | 非对称、重叠、对角线、打破网格、负空间运用 |
| **Backgrounds** | 渐变网格、噪点纹理、几何图案、装饰边框、自定义光标 |

### 2.2 支持的界面类型

- ✅ 网页页面（Landing Page、Home Page）
- ✅ 组件库（Button、Input、Card...）
- ✅ Dashboard / 管理后台
- ✅ 移动端界面
- ✅ 海报 / 宣传页面
- ✅ 交互原型

### 2.3 设计风格选择

Skill 支持多种美学方向，每次设计会根据需求选择不同的风格：

| 风格类型 | 特征 |
|---------|------|
| **Brutalist** | 原始、粗犷、裸露结构 |
| **Minimal** | 极简、留白、克制 |
| **Luxury** | 精致、优雅、高端 |
| **Retro-futuristic** | 复古未来主义 |
| **Playful** | 俏皮、玩具感、趣味 |
| **Editorial** | 杂志风格、排版驱动 |
| **Industrial** | 工业风、实用性 |

---

## 3. 输出格式

### 3.1 默认输出行为

**没有固定默认格式**，根据需求上下文决定：

| 你的描述 | 输出格式 |
|---------|---------|
| "设计一个登录页" | HTML + CSS + 内联 JS（单文件） |
| "做一个 React 组件" | React JSX + CSS |
| "Vue 登录表单" | Vue SFC |
| "Ant Design 页面" | 符合 Ant Design 规范的代码 |

### 3.2 如何明确指定输出格式

```bash
# 直接在需求中指定
"用 frontend-design 做一个单文件 HTML 登录页，brutalist 风格"

# 指定框架
"用 frontend-design 做一个 React Button 组件"

# 指定风格
"用 frontend-design 做一个 brutalist 风格的 HTML 页面"
```

### 3.3 输出物特性

| 特性 | 说明 |
|-----|------|
| **高保真** | 接近最终产品视觉效果 |
| **可交互** | 支持动画、hover、scroll 等交互 |
| **生产级** | 代码可直接用于生产环境 |
| **单文件** | 可输出 HTML artifact，开箱即用 |

---

## 4. 资源处理

### 4.1 图标处理方案

| 方案 | 优点 | 适用场景 |
|-----|------|---------|
| **内联 SVG** | 无依赖、可定制颜色 | 简单图标、logo |
| **Lucide / Heroicons** | 现代、轻量 | React/Vue 项目 |
| **Font Awesome / Iconify** | 库大、CDN 即用 | 快速原型 |
| **纯 CSS 绘制** | 零请求 | 简单几何图标 |
| **Emoji** | 极简 | 休闲风格 |

### 4.2 图片处理方案

| 方案 | 优点 | 适用场景 |
|-----|------|---------|
| **Unsplash API** | 真实照片、免费 | 产品展示、头像 |
| **placeholder.com** | 快速占位 | 布局阶段 |
| **CSS 渐变/图案** | 零请求、性能好 | 背景纹理 |
| **Data URI** | 单文件、无外链 | 小图标、base64 |
| **纯 CSS 艺术** | 极致、无依赖 | 装饰元素 |

### 4.3 推荐做法

在调用时明确说明资源处理方式：

```bash
"用 frontend-design 做一个可交互的 HTML 登录页，
- 图标用内联 SVG
- 背景图用 Unsplash 随机图片
- 风格 brutalist"
```

---

## 5. 产品思维边界

### 5.1 Skill 有什么（设计维度）

| 设计思维 | 产出 |
|---------|------|
| **Purpose** | 解决什么问题？给谁用？ |
| **Tone** | 风格定位（brutalist / luxury / playful...） |
| **Constraints** | 技术约束（框架、性能、无障碍） |
| **Differentiation** | 让人记住的 ONE THING |

### 5.2 Skill 没有什么（产品维度）

| 产品经理思维 | 状态 |
|-------------|------|
| 用户画像 | ❌ 不具备 |
| 用户场景/旅程 | ❌ 不具备 |
| 功能优先级/MVP | ❌ 不具备 |
| 业务目标 | ❌ 不具备 |
| 边界情况 | ❌ 不具备 |
| 竞品分析 | ❌ 不具备 |

### 5.3 责任划分

```
┌─────────────────────────────────────────────┐
│          你的责任（PM 工作）                  │
├─────────────────────────────────────────────┤
│ • 要做什么功能                               │
│ • 目标用户是谁                               │
│ • 核心流程是什么                             │
│ • 业务目标是什么                             │
└─────────────────┬───────────────────────────┘
                  │
                  ▼ 传递给 frontend-design
┌─────────────────────────────────────────────┐
│      frontend-design 的责任（设计工作）        │
├─────────────────────────────────────────────┤
│ • 如何用设计表达这个功能                      │
│ • 选择什么风格/配色/字体                      │
│ • 如何做出差异化                              │
│ • 技术上如何实现                              │
└─────────────────────────────────────────────┘
```

### 5.4 如需产品级需求梳理

使用 `/doc-coauthoring` Skill 进行 PRD 编写和需求梳理。

---

## 6. 最佳实践案例

### 6.1 案例 1：B2B SaaS 登录页

#### 需求描述（推荐）

```bash
"用 frontend-design 做一个 B2B SaaS 的登录页，
- 目标用户：企业 IT 管理员
- 需要的功能：邮箱登录、SSO 登录、忘记密码
- 风格：专业、值得信赖
- 输出单文件 HTML
- 图标用内联 SVG"
```

#### 预期输出

- 单文件 HTML artifact
- 专业配色方案（深蓝/灰白）
- 干净的排版布局
- 表单验证交互
- SSO 登录按钮

---

### 6.2 案例 2：电商 Dashboard

#### 需求描述（推荐）

```bash
"用 frontend-design 做一个电商后台 Dashboard，
- 包含：数据概览卡片、订单列表、销售趋势图
- 目标用户：运营人员
- 风格：现代、数据驱动
- 输出单文件 HTML
- 图表用纯 CSS/JS 实现（无外部库）"
```

#### 预期输出

- 响应式布局
- 数据卡片带微交互
- CSS 实现的趋势图
- 列表带 hover 效果
- 侧边栏导航

---

### 6.3 案例 3：移动端 App 原型

#### 需求描述（推荐）

```bash
"用 frontend-design 做一个移动端 Todo App，
- 功能：添加任务、标记完成、删除
- 目标用户：年轻用户
- 风格：playful、俏皮
- 输出单文件 HTML（移动端优先）
- 动画要流畅"
```

#### 预期输出

- 移动端优化布局
- 滑动删除交互
- 添加任务动画
- 完成任务勾选动画
- 鲜艳的配色

---

### 6.4 案例 4：React 组件库

#### 需求描述（推荐）

```bash
"用 frontend-design 做一套 React 组件，
- 组件：Button、Input、Card、Modal
- 风格：minimalist、极简
- 输出 React 代码
- 支持主题切换（亮色/暗色）"
```

#### 预期输出

- 组件化代码结构
- TypeScript 类型定义
- CSS 变量主题系统
- Storybook 风格预览

---

### 6.5 案例 5：营销 Landing Page

#### 需求描述（推荐）

```bash
"用 frontend-design 做一个产品营销页，
- 产品：AI 写作助手
- 目标用户：内容创作者
- 包含：Hero、特性介绍、价格、CTA
- 风格：editorial、杂志感
- 输出单文件 HTML
- 背景图用 Unsplash"
```

#### 预期输出

- 强烈的视觉层次
- 大字号标题
- 留白运用
- Scroll 触发动画
- 高对比度 CTA

---

### 6.6 需求描述对比

| 需求描述质量 | 示例 | 结果 |
|-------------|------|------|
| ❌ 太模糊 | "做一个登录页" | 会反问你多个问题 |
| ✅ 简洁完整 | "B2B 登录页，IT 管理员用，专业风格" | 直接产出 |
| ✅ 详细明确 | 包含用户、功能、风格、技术栈 | 最佳效果 |

---

## 7. 技术实现原理

### 7.1 Skill 工作流程

```
用户输入需求
        │
        ▼
┌──────────────────────┐
│  Skill Prompt 注入   │
│  (设计准则、美学规范) │
└──────────┬───────────┘
           │
           ▼
    ┌─────────────┐
    │ 设计思维阶段 │
    │ • Purpose   │
    │ • Tone      │
    │ • Constraints│
    │ • Differentiation│
    └─────────────┘
           │
           ▼
    ┌─────────────────┐
    │ 技术栈判断       │
    │ • 指定框架?      │
    │ • 单文件?        │
    │ • 图标/图片方案? │
    └─────────────────┘
           │
           ▼
    ┌─────────────────┐
    │ 代码生成         │
    │ • HTML/CSS/JS   │
    │ • React/Vue     │
    │ • 动画交互       │
    └─────────────────┘
           │
           ▼
      输出代码
```

### 7.2 设计准则来源

Skill 内置的设计准则来自 SKILL.md 文件：

```markdown
## Frontend Aesthetics Guidelines

Focus on:
- Typography: 避免 Inter/Roboto/Arial
- Color & Theme: CSS 变量，主导色 + 强调色
- Motion: staggered reveals, scroll/hover 惊喜
- Spatial Composition: 非对称、重叠、对角线
- Backgrounds & Details: 渐变网格、噪点、纹理

NEVER use generic AI aesthetics:
- 紫色渐变 + 白底
- Inter 字体
- 预测性布局
```

### 7.3 插件系统架构

```
~/.claude/plugins/
├── marketplaces/
│   └── anthropic-agent-skills/     # 官方 Skill 市场
├── cache/
│   └── anthropic-agent-skills/
│       └── document-skills/
│           └── 69c0b1a06741/       # 版本哈希
│               └── skills/
│                   └── frontend-design/
│                       └── SKILL.md
└── installed_plugins.json          # 安装注册表
```

---

## 8. 常见问题

### Q1: frontend-design 能替代设计师吗？

**A:** 不能完全替代。它的优势是：
- ✅ 快速原型验证
- ✅ 多风格探索
- ✅ 生产级代码实现

但仍需要：
- ❌ 品牌规范设定
- ❌ 复杂业务逻辑设计
- ❌ 用户测试迭代

### Q2: 输出的代码可以直接用吗？

**A:** 是的，代码是生产级的：
- 语义化 HTML
- 模块化 CSS
- 可访问性考虑
- 响应式设计

但建议：
- 根据项目规范调整
- 添加必要的测试
- 集成到现有框架

### Q3: 如果我不喜欢输出的设计怎么办？

**A:** 可以迭代：
```bash
"太复杂了，改得更 minimal 一些"
"颜色太鲜艳，换成专业一点的"
"动画太多，保留关键交互就好"
```

### Q4: 能和现有项目集成吗？

**A:** 可以，指定你的技术栈：
```bash
"用 Ant Design 组件库做这个页面"
"用 Tailwind CSS 实现这个设计"
"符合我们项目的 Design System"
```

### Q5: 图标/图片资源从哪里来？

**A:** 根据你的需求选择：
- 单文件原型 → 内联 SVG + CSS 渐变
- 真实项目 → 你提供资源路径
- 演示用 → Unsplash / 占位服务

---

## 9. 快速参考

### 9.1 需求描述模板

```bash
"用 frontend-design 做一个 [页面类型]，
- 目标用户：[用户群体]
- 核心功能：[功能列表]
- 风格：[美学方向]
- 技术栈：[HTML/React/Vue/...]
- 图标：[SVG/Iconify/Font Awesome]
- 图片：[Unsplash/CSS 渐变/占位图]"
```

### 9.2 风格关键词速查

| 关键词 | 风格方向 |
|-------|---------|
| brutalist | 粗犷、原始、裸露结构 |
| minimal | 极简、留白、克制 |
| luxury | 精致、优雅、高端 |
| playful | 俏皮、玩具感、趣味 |
| editorial | 杂志风格、排版驱动 |
| industrial | 工业风、实用性 |
| retro-futuristic | 复古未来主义 |
| soft | 柔和、粉彩、亲和 |

### 9.3 技术栈关键词

| 关键词 | 输出 |
|-------|------|
| 单文件 HTML | HTML + CSS + 内联 JS |
| React | JSX + 组件化代码 |
| Vue | Vue SFC |
| Ant Design | 基于 Ant Design 的页面 |
| Tailwind | Tailwind CSS 类名 |

---

## 10. 相关 Skills

| Skill | 用途 |
|-------|------|
| **doc-coauthoring** | 产品需求文档（PRD）编写 |
| **web-artifacts-builder** | 复杂 React + shadcn/ui 构件 |
| **canvas-design** | 静态视觉设计（PNG/PDF） |
| **webapp-testing** | Playwright 网页测试 |

---

## 版本信息

- **Skill 版本**: 1.0.0
- **文档更新**: 2024-12-24
- **作者**: Keith Lazuka (Anthropic)

---

*本文档由 Claude Code 生成并维护*

# Playbook E · 设计稿 → 页面与交互 SOP（Figma / UI 文档 → Flutter 页面）

> 场景：拿到 Figma 链接（或截图/手写 UI 规格），生成页面代码与交互接线。
> 本文件是 `PLAYBOOK-NEW-FEATURE.md` 中**类型 A（新页面/新功能）UI 部分**的详细版。
> 输入标准见 `UI-DOC-TEMPLATE.md`；业务规则不在本流程——先走 `PLAYBOOK-BIZ-LOGIC.md`。

---

## 通道选择

| 条件 | 通道 |
|---|---|
| Figma 链接 + Agent 已接入 Figma MCP | **通道 A · MCP 直连**（推荐，无需人工导图） |
| Figma 但无 MCP / 只有截图、标注图 | **通道 B · 人工导出**：设计稿图 + `UI-DOC-TEMPLATE.md` |
| 无任何设计稿 | **通道 C · 基线生成**：只写 UI 文档，按设计基线自由发挥 |

## 通道 A · Figma MCP 直连

### A-1. 从链接取参数

```text
https://www.figma.com/design/<fileKey>/xxx?node-id=1234-5678
                                    └──fileKey──┘   └─nodeId（- 换成 :）→ 1234:5678
```

- 必须带 `node-id`：只拉当前页面/组件，别拉整个文件（token 爆炸）
- 多页面需求逐页取 node-id，一页一个需求卡

### A-2. 拉取设计数据与资源（发给 Agent 的指令序列）

1. `get_figma_data(fileKey, nodeId)` → 拿布局树、组件结构、颜色/字体/圆角
2. 提取 **design token 映射表**（先做映射，再写页面）：

| Figma | Flutter 去处 |
|---|---|
| 颜色样式 | `lib/theme/` 语义色（primary/success…，**禁** blue500 式命名直翻） |
| 字体样式 | theme TextStyle（≤4 字号、2 字重） |
| 圆角/间距 | theme 常量，对齐 8pt 网格 |
| AutoLayout 横/竖 | Row / Column；fill → Expanded；gap → SizedBox |
| 组件（重复结构） | `lib/widgets/`（复用 ≥2 处才入库） |

3. `download_figma_images` 导资源：
   - 图标 → **SVG**（可随主题变色）
   - 插画/照片 → **PNG，pngScale=3**
   - 保存到 `assets/images/`（或 `assets/icons/`），并在 `pubspec.yaml` 声明
   - ⚠️ SVG 渲染需 `flutter_svg`——**新增依赖必须先征得用户同意**（红线）；
     未同意时用 PNG 或内置 `Icons` 替代并在交付说明里注明

### A-3. 生成顺序（Prompt 要点）

```text
请按 Figma（fileKey=…, nodeId=…）实现 <页面名>，UI 规格见 docs/ui/<页面名>.md：

1. 先读 lib/pages/AGENTS.md、lib/AGENTS.md、docs/ui/<页面名>.md
2. 用 get_figma_data 拉设计 → 先产出 token 映射表（Figma 样式 → theme）给我确认
3. 落 theme（若需新增）→ 页面骨架 → 拆组件（>80行或4层嵌套必拆）→ 资源经 download_figma_images 导入
4. 实现四态（loading/empty/error/success，以 UI 文档为准，Figma 没画的按文档）
5. 按事件表 I1…In 逐条接线；路由接入与入口
6. flutter analyze 零 error；新增 widget 至少 1 个渲染测试

约束：样式全走 theme（禁色值/裸 TextStyle）；热区≥44；不新增依赖（SVG 需 flutter_svg 时先问我）。
```

### A-4. 还原度走查（人工 review）

- [ ] 逐屏对比 Figma：布局、间距（8pt）、字号字重、圆角、颜色
- [ ] **四态齐全**（Figma 只画了 success；空态/错误态按 UI 文档验收）
- [ ] 事件表逐条接线：每个可点元素都有行为（或显式"无"）
- [ ] 取色全走 theme（grep 无 `Color(0xFF`）；文本溢出有 maxLines/ellipsis
- [ ] 长列表 builder + Key；窄屏/宽屏用 Expanded 自适应，无写死宽度
- [ ] 资源已进 pubspec、体积已压缩；路由返回关系正确

## 通道 B · 人工导出

1. 设计师导出：整页标注图（或逐区块截图）→ `docs/ui/assets/<页面名>/`
2. 按 `UI-DOC-TEMPLATE.md` 写规格（样式节写"见图"），事件表/四态/文案照常必填
3. 走 A-3 的 Prompt（第 2 步改为"读 docs/ui/assets/ 下的标注图"）

## 通道 C · 无设计稿（基线生成）

只写 UI 文档，样式节留空；Prompt 追加设计基线约束：

> 单字体族、≤4 字号 2 字重；60/30/10 配色（主色只给 CTA/关键指标）；
> 8pt 间距网格；软阴影；主操作置拇指区；空态必须有插画+CTA；热区≥44。

生成后人工走查仍按 A-4（四态/事件表/theme 三项最常缺）。

## ⑤ DoD / ⑥ 提交

同 `PLAYBOOK-NEW-FEATURE.md` 第 4 步 + A-4 走查全过；提交 `feat(ui): add <页面名>`。

---

## 常见坑（踩过才留）

- 直接把 Figma 色值/间距硬编码进页面 → 主题一改全崩；**token 映射先行**
- 只实现 success 态 → 空数据/断网白屏；四态在 UI 文档定义、代码必现
- 整文件拉 Figma 数据 → token 爆炸；**必须按 node-id 拉单页**
- 事件表省略"无" → Agent 给不可点元素乱加点击
- Figma 改版后没人知道 → UI 文档登记 Figma 版本/链接，改版走需求卡

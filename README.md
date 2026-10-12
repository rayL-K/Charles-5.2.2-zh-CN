Charles 汉化包（v5.2.2）
========================

【怎么装·最简单】
1. 先把本压缩包完整解压到一个普通文件夹（不要在压缩软件里直接双击）。
2. 完全退出 Charles（含托盘图标）。
3. 双击 安装.bat → UAC 弹窗选「是」→ 看到「汉化完成：重启 Charles 即可。」后重新打开 Charles。

安装.bat 会自动：备份原文件为 lib\charles.jar.bak 与 Charles.ini.bak → 覆盖两个文件 → 结束。
想还原：把 .bak 改回原名覆盖回去即可（或删掉 .bak 不管，重装 Charles 也行）。

【Charles 装在别的目录？】
默认目标 C:\Program Files\Charles。若不是这个目录，用参数指定（目录里要有 Charles.exe 和 lib）：
    安装.bat "D:\你的\Charles目录"
也可以完全手动：把本包 lib\charles.jar 覆盖到 安装目录\lib\，Charles.ini 覆盖到安装目录根，然后重启 Charles。

【版本要求】
本包是用 Charles 5.2.2 的 charles.jar 打补丁做的。对方版本不一致时不要直接覆盖 jar
（会变成 5.2.2 的程序文件配别版本的其它组件），需要针对对方那个 charles.jar 重新打一次补丁。

【包里有什么】
- lib\charles.jar  已汉化的主程序（常量池替换 + 内置 zh_CN 资源束）
- Charles.ini      追加了 -Duser.language=zh / -Duser.country=CN，非中文系统也显示中文
- 安装.bat         一键安装（自动请求管理员权限 + 自动备份），推荐用这个
- 安装.ps1         同上，提权被拦时的备用（右键 → 使用 PowerShell 运行）
- 说明.txt         本文件

【为什么有些还是英文】
以下名称有意保留英文——它们是 charles.config 里的持久化键，翻译会导致已保存的配置失效：
Breakpoints / Reverse Proxies / Block List / Map Remote / Port Forwarding / Viewer Mappings /
Rewrite / Map Local / Allow List / Client Process / No Caching / DNS Spoofing / Mirror /
Auto Save / Block Cookies

【左侧两个视图模式是什么意思】
- 结构（Structure）：按域名/站点层级树状排列所有请求，同一个 host 的请求折叠在一起，适合看一个网站整体发了哪些请求。
- 序列（Sequence）：按时间先后平铺列出每一个请求，来了就排在后面，适合按发生顺序排查。
这两个按钮本包已汉化成「结构 / 序列」。

【注意】
- 升级 Charles 后需要重新应用本包。
- 卸载/还原只需把 lib\charles.jar.bak 与 Charles.ini.bak 改回原名覆盖，然后重启 Charles。

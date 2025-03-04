---
title: 生成带有自定义出站和规则的 sing-boxp 配置文件直链-ruleset 方案
description: 此教程搭载 sing-boxp 内核，采用 `rule_set` 规则搭配 .srs 规则集文件
date: 2024-08-22 17:44:59 +0800
categories: [直链配置, sing-boxp 直链]
tags: [sing-box, sing-boxp, 直链, 订阅, ruleset, rule_set, 基础]
---

> 说明
{: .prompt-tip }
1. 本教程可以生成扩展名为 .json 配置文件直链，可以**一键导入使用了 [sing-box PuerNya 版内核](https://github.com/PuerNya/sing-box/tree/building)的客户端**  
如：[ShellCrash](https://github.com/juewuy/ShellCrash) 和 [sing-box for Android](https://github.com/PuerNya/sing-box/actions/workflows/sfa.yml) 等
1. 生成的订阅链接地址不会改变，支持更新订阅，**支持国内访问，支持同步机场节点**
2. 生成的订阅链接**自带规则集**，规则集来源 [DustinWin/ruleset_geodata/ruleset](https://github.com/DustinWin/ruleset_geodata#%E4%BA%8C-ruleset-%E8%A7%84%E5%88%99%E9%9B%86%E6%96%87%E4%BB%B6%E8%AF%B4%E6%98%8E)
3. 本教程必须使用支持[出站提供者](https://sing-boxp.dustinwin.top/zh/configuration/provider/) `outbound_providers`（类似于 [mihomo 内核](https://github.com/MetaCubeX/mihomo)的[代理集合](https://wiki.metacubex.one/config/proxy-providers/) `proxy-providers`）的 [sing-box PuerNya 版内核](https://github.com/PuerNya/sing-box)，请先**确定自己机场的订阅链接是否为 Clash 或 sing-box 订阅链接**，若不是，需前往[肥羊在线订阅转换工具](https://suburl.v1.mk)进行转换，“生成类型”选择“Clash”或“sing-box”，其它参数保持默认即可，转换后的 Clash 订阅链接需要在末尾添加 `&flag=clash`，然后添加到 .json 文件出站提供者 `outbound_providers` 的 `download_url` 中
4. 推荐使用 [Visual Studio Code](https://code.visualstudio.com/Download) 等专业编辑器来修改配置文件
5. ShellCrash 支持本地导入配置文件，可以直接将下方的 .json 直链文件内容复制到 `$CRASHDIR/jsons/config.json`{: .filepath} 文件中，可代替通过 ShellCrash 配置脚本 → 6 → 2 导入配置文件的方式

## 一、 准备编辑 .json 直链文件
### 1. 注册 [Gist](https://gist.github.com)
进入 <https://gist.github.com> 网站并注册

### 2. 打开编辑页面
登录并打开 Gist 可以直接编辑文件，或者点击页面右上角头像左边的“+”图标新建文件

### 3. 输入描述和完整文件名
“Gist description...”输入描述，随意填写；“Filename including extension...”输入完整文件名**包括扩展名**，如 singboxlink.json  
<img src="/assets/img/link/file-extension-json.png" alt="输入描述和完整文件名" width="60%" />

## 二、 添加模板
### 1. 白名单模式（没有命中规则的网络流量统统使用代理，适用于服务器线路网络质量稳定、快速，不缺服务器流量的用户，推荐）

```json
{
  // 出站提供者（获取机场订阅链接内的所有节点）
  "outbound_providers": [
    {
      "tag": "🛫 机场订阅 1",
      "type": "remote",
      // 机场订阅链接，使用 Clash 链接
      "download_url": "https://example.com/xxx/xxx&flag=clash",
      "path": "./providers/airport1.yaml",
      "download_interval": "24h",
      "download_ua": "clash.meta",
      // 初步筛选需要的节点，可有效减轻路由器压力，支持正则表达式，若不筛选可删除此配置项
      "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong|🇹🇼|台|tw|taiwan|tai wan|🇯🇵|日|jp|japan|🇸🇬|新|sg|singapore|🇺🇸|美|us|unitedstates|united states)" ],
      // 初步排除不需要的节点，支持正则表达式，若不排除可删除此配置项
      "excludes": "高倍|直连|×10",
      "healthcheck_url": "https://www.gstatic.com/generate_204",
      "healthcheck_interval": "10m",
      "outbound_override": {
        // 设置出站标签的前缀，如出站标签原为“香港节点”会变成“🛫 机场订阅 1-香港节点”；推荐有多个机场时使用
        "tag_prefix": "🛫 机场订阅 1-",
        // 设置出站标签的后缀，如出站标签原为“香港节点”会变成“香港节点-🛫 机场订阅 1”；推荐有多个机场时使用
        "tag_suffix": "-🛫 机场订阅 1"
      }
    },
    {
      "tag": "🛫 机场订阅 2",
      "type": "remote",
      // 机场订阅链接，使用 sing-box 链接
      "download_url": "https://example.com/xxx/xxx",
      "path": "./providers/airport2.json",
      "download_interval": "24h",
      "download_ua": "sing-box",
      "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong|🇹🇼|台|tw|taiwan|tai wan|🇯🇵|日|jp|japan|🇸🇬|新|sg|singapore|🇺🇸|美|us|unitedstates|united states)" ],
      "excludes": "高倍|直连|×10",
      "healthcheck_url": "https://www.gstatic.com/generate_204",
      "healthcheck_interval": "10m",
      "outbound_override": {
        // 设置出站标签的前缀，如出站标签原为“香港节点”会变成“🛫 机场订阅 2-香港节点”；推荐有多个机场时使用
        "tag_prefix": "🛫 机场订阅 2-",
        // 设置出站标签的后缀，如出站标签原为“香港节点”会变成“香港节点-🛫 机场订阅 2”；推荐有多个机场时使用
        "tag_suffix": "-🛫 机场订阅 2"
      }
    }
  ],
  // 出站
  "outbounds": [
    // 手动选择国家或地区节点；根据“国家或地区出站”的名称对 `outbounds` 值进行增删改，须一一对应
    { "tag": "🚀 节点选择", "type": "selector", "outbounds": [ "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    // 选择`🎯 全球直连`为测试本地网络（运营商网络速度和 IPv6 支持情况），可选择其它节点用于测试机场节点速度和 IPv6 支持情况
    { "tag": "📈 网络测试", "type": "selector", "outbounds": [ "🎯 全球直连", "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    { "tag": "🤖 人工智能", "type": "selector", "outbounds": [ "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇰🇷 韩国节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点" ] },
    { "tag": "📥 Trackerslist", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🎮 游戏服务", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🪟 微软服务", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🇬 谷歌服务", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🍎 苹果服务", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🛡️ 直连域名", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🀄️ 直连 IP", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🧱 代理域名", "type": "selector", "outbounds": [ "🚀 节点选择", "🎯 全球直连" ] },
    { "tag": "📲 电报消息", "type": "selector", "outbounds": [ "🚀 节点选择" ] },
    { "tag": "🐟 漏网之鱼", "type": "selector", "outbounds": [ "🚀 节点选择", "🎯 全球直连" ] },
    { "tag": "🛑 广告域名", "type": "selector", "outbounds": [ "🔴 全球拦截", "🎯 全球直连" ] },
    { "tag": "🔴 全球拦截", "type": "selector", "outbounds": [ "REJECT" ] },
    { "tag": "🎯 全球直连", "type": "selector", "outbounds": [ "DIRECT" ] },
    { "tag": "REJECT", "type": "block" },
    { "tag": "DIRECT", "type": "direct" },
    { "tag": "GLOBAL", "type": "selector", "outbounds": [ "DIRECT", "REJECT", "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    { "tag": "dns-out", "type": "dns" },

    // 单个出站节点（以 vless 为例）
    {
      "tag": "🆓 免费节点",
      "type": "vless",
      "server": "example.com",
      "server_port": 443,
      "uuid": "{uuid}",
      "network": "tcp",
      "tls": { "enabled": true, "server_name": "example.com", "insecure": false },
      "transport": { "type": "ws", "path": "/?ed=2048", "headers": { "Host": "example.com" } }
    },

    // -------------------- 国家或地区出站 --------------------
    // 自动选择节点，即按照 url 测试结果使用延迟最低的节点；测试后容差大于 50ms 才会切换到延迟低的那个节点；筛选出“香港”节点，支持正则表达式
    { "tag": "🇭🇰 香港节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong)" ] },
    // 可使用 `"use_all_providers": true` 代替 `"providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2", ... ]`，意思为引入所有出站提供者
    { "tag": "🇹🇼 台湾节点", "type": "urltest", "tolerance": 50, "use_all_providers": true, "includes": [ "(?i)(🇹🇼|台|tw|taiwan|tai wan)" ] },
    { "tag": "🇯🇵 日本节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇯🇵|日|jp|japan)" ] },
    { "tag": "🇸🇬 新加坡节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇸🇬|新|sg|singapore)" ] },
    { "tag": "🇺🇸 美国节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇺🇸|美|us|unitedstates|united states)" ] }
  ],
  // 路由
  "route": {
    // 规则
    "rules": [
      { "protocol": [ "dns" ], "outbound": "dns-out" },
      { "clash_mode": [ "Direct" ], "outbound": "DIRECT" },
      { "clash_mode": [ "Global" ], "outbound": "GLOBAL" },
      // 自定义规则优先放前面
      { "rule_set": [ "private" ], "outbound": "🎯 全球直连" },
      { "rule_set": [ "ads" ], "outbound": "🛑 广告域名" },
      { "rule_set": [ "trackerslist" ], "outbound": "📥 Trackerslist" },
      // 为了使 P2P 流量（BT 下载）走直连，可添加一条 `DST-PORT` 规则（ShellCrash 会默认开启“只代理常用端口”，可删除此条 `DST-PORT`）
      { "port_range": [ "6881:6889" ], "outbound": "🎯 全球直连"},
      // 若使用 ShellCrash，由于无法判断本机进程（默认删除 `process_name` 规则），需删除此条 `rule_set`
      { "rule_set": [ "applications" ], "outbound": "🎯 全球直连" },
      { "rule_set": [ "microsoft-cn" ], "outbound": "🪟 微软服务" },
      { "rule_set": [ "apple-cn" ], "outbound": "🍎 苹果服务" },
      { "rule_set": [ "google-cn" ], "outbound": "🇬 谷歌服务" },
      { "rule_set": [ "games-cn" ], "outbound": "🎮 游戏服务" },
      { "rule_set": [ "ai" ], "outbound": "🤖 人工智能" },
      { "rule_set": [ "networktest" ], "outbound": "📈 网络测试" },
      { "rule_set": [ "proxy" ], "outbound": "🧱 代理域名" },
      { "rule_set": [ "tld-cn" ], "outbound": "🛡️ 直连域名" },
      { "rule_set": [ "cn" ], "outbound": "🛡️ 直连域名" },
      { "rule_set": [ "privateip" ],  "outbound": "🎯 全球直连", "skip_resolve": true },
      { "rule_set": [ "cnip" ], "outbound": "🀄️ 直连 IP" },
      { "rule_set": [ "telegramip" ], "outbound": "📲 电报消息", "skip_resolve": true }
    ],
    // 规则集（binary 文件每天自动更新）
    "rule_set": [
      {
        "tag": "private",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/private.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/private.srs"
      },
      {
        "tag": "ads",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/ads.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/ads.srs"
      },
      {
        "tag": "trackerslist",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/trackerslist.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/trackerslist.srs"
      },
      // 若使用 ShellCrash，由于无法判断本机进程（默认删除 `process_name` 规则），需删除此条 `applications`
      {
        "tag": "applications",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/applications.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/applications.srs"
      },
      {
        "tag": "microsoft-cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/microsoft-cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/microsoft-cn.srs"
      },
      {
        "tag": "apple-cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/apple-cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/apple-cn.srs"
      },
      {
        "tag": "google-cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/google-cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/google-cn.srs"
      },
      {
        "tag": "games-cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/games-cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/games-cn.srs"
      },
      {
        "tag": "ai",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/ai.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/ai.srs"
      },
      {
        "tag": "networktest",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/networktest.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/networktest.srs"
      },
      {
        "tag": "proxy",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/proxy.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/proxy.srs"
      },
      {
        "tag": "tld-cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/tld-cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/tld-cn.srs"
      },
      {
        "tag": "cn",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/cn.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/cn.srs"
      },
      {
        "tag": "privateip",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/privateip.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/privateip.srs"
      },
      {
        "tag": "cnip",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/cnip.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/cnip.srs"
      },
      {
        "tag": "telegramip",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/telegramip.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/telegramip.srs"
      }
    ],
    // 默认出站，即没有命中规则的域名或 IP 走该规则
    "final": "🐟 漏网之鱼",
    "auto_detect_interface": true,
    "concurrent_dial": true
  }
}
```

将模板内容复制到自己 Gist 新建的 .json 文件中

### 2. 黑名单模式（只有命中规则的网络流量才使用代理，适用于服务器线路网络质量不稳定或不够快，或服务器流量紧缺的用户。通常也是软路由用户、家庭网关用户的常用模式）

```json
{
  // 出站提供者（获取机场订阅链接内的所有节点）
  "outbound_providers": [
    {
      "tag": "🛫 机场订阅 1",
      "type": "remote",
      // 机场订阅链接，使用 Clash 链接
      "download_url": "https://example.com/xxx/xxx&flag=clash",
      "path": "./providers/airport1.yaml",
      "download_interval": "24h",
      "download_ua": "clash.meta",
      "download_detour": "PROXY",
      // 初步筛选需要的节点，可有效减轻路由器压力，支持正则表达式，若不筛选可删除此配置项
      "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong|🇹🇼|台|tw|taiwan|tai wan|🇯🇵|日|jp|japan|🇸🇬|新|sg|singapore|🇺🇸|美|us|unitedstates|united states)" ],
      // 初步排除不需要的节点，支持正则表达式，若不排除可删除此配置项
      "excludes": "高倍|直连|×10",
      "healthcheck_url": "https://www.gstatic.com/generate_204",
      "healthcheck_interval": "10m",
      "outbound_override": {
        // 设置出站标签的前缀，如出站标签原为“香港节点”会变成“🛫 机场订阅 1-香港节点”；推荐有多个机场时使用
        "tag_prefix": "🛫 机场订阅 1-",
        // 设置出站标签的后缀，如出站标签原为“香港节点”会变成“香港节点-🛫 机场订阅 1”；推荐有多个机场时使用
        "tag_suffix": "-🛫 机场订阅 1"
      }
    },
    {
      "tag": "🛫 机场订阅 2",
      "type": "remote",
      // 机场订阅链接，使用 sing-box 链接
      "download_url": "https://example.com/xxx/xxx",
      "path": "./providers/airport2.json",
      "download_interval": "24h",
      "download_ua": "sing-box",
      "download_detour": "PROXY",
      "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong|🇹🇼|台|tw|taiwan|tai wan|🇯🇵|日|jp|japan|🇸🇬|新|sg|singapore|🇺🇸|美|us|unitedstates|united states)" ],
      "excludes": "高倍|直连|×10",
      "healthcheck_url": "https://www.gstatic.com/generate_204",
      "healthcheck_interval": "10m",
      "outbound_override": {
        // 设置出站标签的前缀，如出站标签原为“香港节点”会变成“🛫 机场订阅 2-香港节点”；推荐有多个机场时使用
        "tag_prefix": "🛫 机场订阅 2-",
        // 设置出站标签的后缀，如出站标签原为“香港节点”会变成“香港节点-🛫 机场订阅 2”；推荐有多个机场时使用
        "tag_suffix": "-🛫 机场订阅 2"
      }
    }
  ],
  // 出站
  "outbounds": [
    // 手动选择国家或地区节点；根据“国家或地区出站”的名称对 `outbounds` 值进行增删改，须一一对应
    { "tag": "🚀 节点选择", "type": "selector", "outbounds": [ "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    // 选择`🎯 全球直连`为测试本地网络（运营商网络速度和 IPv6 支持情况），可选择其它节点用于测试机场节点速度和 IPv6 支持情况
    { "tag": "📈 网络测试", "type": "selector", "outbounds": [ "🎯 全球直连", "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    { "tag": "🤖 人工智能", "type": "selector", "outbounds": [ "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇰🇷 韩国节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点" ] },
    { "tag": "📥 Trackerslist", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🧱 代理域名", "type": "selector", "outbounds": [ "🚀 节点选择", "🎯 全球直连" ] },
    { "tag": "📲 电报消息", "type": "selector", "outbounds": [ "🚀 节点选择" ] },
    { "tag": "🐟 漏网之鱼", "type": "selector", "outbounds": [ "🎯 全球直连", "🚀 节点选择" ] },
    { "tag": "🛑 广告域名", "type": "selector", "outbounds": [ "🔴 全球拦截", "🎯 全球直连" ] },
    { "tag": "🔴 全球拦截", "type": "selector", "outbounds": [ "REJECT" ] },
    { "tag": "🎯 全球直连", "type": "selector", "outbounds": [ "DIRECT" ] },
    { "tag": "REJECT", "type": "block" },
    { "tag": "DIRECT", "type": "direct" },
    { "tag": "PROXY", "type": "urltest", "tolerance": 50, "use_all_providers": true },
    { "tag": "GLOBAL", "type": "selector", "outbounds": [ "DIRECT", "REJECT", "🇭🇰 香港节点", "🇹🇼 台湾节点", "🇯🇵 日本节点", "🇸🇬 新加坡节点", "🇺🇸 美国节点", "🆓 免费节点" ] },
    { "tag": "dns-out", "type": "dns" },

    // 单个出站节点（以 vless 为例）
    {
      "tag": "🆓 免费节点",
      "type": "vless",
      "server": "example.com",
      "server_port": 443,
      "uuid": "{uuid}",
      "network": "tcp",
      "tls": { "enabled": true, "server_name": "example.com", "insecure": false },
      "transport": { "type": "ws", "path": "/?ed=2048", "headers": { "Host": "example.com" } }
    },

    // -------------------- 国家或地区出站 --------------------
    // 自动选择节点，即按照 url 测试结果使用延迟最低的节点；测试后容差大于 50ms 才会切换到延迟低的那个节点；筛选出“香港”节点，支持正则表达式
    { "tag": "🇭🇰 香港节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇭🇰|港|hk|hongkong|hong kong)" ] },
    // 可使用 `"use_all_providers": true` 代替 `"providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2", ... ]`，意思为引入所有出站提供者
    { "tag": "🇹🇼 台湾节点", "type": "urltest", "tolerance": 50, "use_all_providers": true, "includes": [ "(?i)(🇹🇼|台|tw|taiwan|tai wan)" ] },
    { "tag": "🇯🇵 日本节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇯🇵|日|jp|japan)" ] },
    { "tag": "🇸🇬 新加坡节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇸🇬|新|sg|singapore)" ] },
    { "tag": "🇺🇸 美国节点", "type": "urltest", "tolerance": 50, "providers": [ "🛫 机场订阅 1", "🛫 机场订阅 2" ], "includes": [ "(?i)(🇺🇸|美|us|unitedstates|united states)" ] }
  ],
  // 路由
  "route": {
    // 规则
    "rules": [
      { "protocol": [ "dns" ], "outbound": "dns-out" },
      { "clash_mode": [ "Direct" ], "outbound": "DIRECT" },
      { "clash_mode": [ "Global" ], "outbound": "GLOBAL" },
      // 自定义规则优先放前面
      { "rule_set": [ "private" ], "outbound": "🎯 全球直连" },
      { "rule_set": [ "ads" ], "outbound": "🛑 广告域名" },
      { "rule_set": [ "trackerslist" ], "outbound": "📥 Trackerslist" },
      { "rule_set": [ "ai" ], "outbound": "🤖 人工智能" },
      { "rule_set": [ "networktest" ], "outbound": "📈 网络测试" },
      { "rule_set": [ "tld-proxy" ], "outbound": "🧱 代理域名" },
      { "rule_set": [ "proxy" ], "outbound": "🧱 代理域名" },
      { "rule_set": [ "telegramip" ], "outbound": "📲 电报消息", "skip_resolve": true }
    ],
    // 规则集（binary 文件每天自动更新）
    "rule_set": [
      {
        "tag": "private",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/private.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/private.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "ads",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/ads.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/ads.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "trackerslist",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/trackerslist.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/trackerslist.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "ai",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/ai.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/ai.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "networktest",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/networktest.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/networktest.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "tld-proxy",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/tld-proxy.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/tld-proxy.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "proxy",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/proxy.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/proxy.srs",
        "download_detour": "PROXY"
      },
      {
        "tag": "telegramip",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/telegramip.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/telegramip.srs",
        "download_detour": "PROXY"
      }
    ],
    // 默认出站，即没有命中规则的域名或 IP 走该规则
    "final": "🐟 漏网之鱼",
    "auto_detect_interface": true,
    "concurrent_dial": true
  }
}
```

将模板内容复制到自己 Gist 新建的 .json 文件中

## 三、 修改模板
1. 将出站提供者 `outbound_providers` 中的 `download_url` 链接改成自己机场的订阅链接（必须为 Clash 或 sing-box 订阅链接，详见《说明 4》）
2. 确定自己机场中有哪些国家或地区的节点，然后对模板文件里 `outbounds` 中“**国家或地区出站**”以及 `🚀 节点选择`、`📈 网络测速`、 `🤖 人工智能` 和 `GLOBAL` 出站下的 `outbounds` 里面的国家或地区进行增删改
   - 注：两者中的国家或地区必须一一对应，新增就全部新增，删除就全部删除，修改就全部修改（重要）

3. 在“国家或地区出站”中的 `includes` 支持[正则表达式](https://tool.oschina.net/regex)，可以精确地筛选出指定的国家或地区节点  
例如：我想筛选出“香港 IPLC”节点，`includes` 可以这样写：`"includes": [ "香港.*IPLC|IPLC.*香港" ]`
   - 小窍门：使用 [ChatGPT](https://chatgpt.com) 等 AI 工具查询符合自己要求的正则表达式

4. 在 `🚀 节点选择` 出站下的 `outbounds` 里，可以将最稳定的节点放在最前面，配置完成后会自动选择最稳定的节点
5. 在“国家或地区出站”里，`type` 为 `urltest` 就是自动选择延迟最低的节点，将 `urltest` 改成 `selector` 就是手动选择节点
举个例子：我的机场包含有 2 个节点，分别是新加坡节点和日本节点，我想让 [Netflix](https://www.netflix.com/) 自动选择延迟最低的新加坡节点，[哔哩哔哩](https://www.bilibili.com)可以手动选择日本任一节点，这个需求怎么写？  
注：
   - ① 以下只是节选，请酌情套用
   - ② 本教程搭配的规则集合文件包含有 `netflix`、`netflixip` 和 `bilibili`

```json
{
  // 出站
  "outbounds": [
    // 默认选择新加坡节点
    { "tag": "🎥 奈飞视频", "type": "selector", "outbounds": [ "🇸🇬 新加坡节点" ] },
    // 默认选择日本节点，也可切换到直连
    { "tag": "📺 哔哩哔哩", "type": "selector", "outbounds": [ "🇯🇵 日本节点", "🎯 全球直连" ] },
    // 自动选择延迟最低的新加坡节点；容差大于 50ms 才会切换到延迟低的那个节点
    { "tag": "🇸🇬 新加坡节点", "type": "urltest", "tolerance": 50, "use_all_providers": true, "includes": [ "(?i)(🇸🇬|新|sg|singapore)" ] },
    // 手动选择日本任一节点
    { "tag": "🇯🇵 日本节点", "type": "selector", "use_all_providers": true, "includes": [ "(?i)(🇯🇵|日|jp|japan)" ] },
    { "tag": "🎯 全球直连", "type": "selector", "outbounds": [ "DIRECT" ] },
    { "tag": "DIRECT", "type": "direct" }
  ],
  // 路由
  "route": {
    // 规则
    "rules": [
      // 自定义规则优先放前面
      { "rule_set": [ "netflix", "netflixip" ], "outbound": "🎥 奈飞视频", "skip_resolve": true },
      { "rule_set": [ "bilibili" ], "outbound": "📺 哔哩哔哩" }
    ],
    // 规则集（binary 文件每天自动更新）
    "rule_set": [
      {
        "tag": "netflix",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/netflix.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/netflix.srs"
      },
      {
        "tag": "netflixip",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/netflixip.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/netflixip.srs"
      },
      {
        "tag": "bilibili",
        "type": "remote",
        "format": "binary",
        "path": "./ruleset/bilibili.srs",
        "url": "https://github.com/DustinWin/ruleset_geodata/releases/download/sing-box-ruleset-compatible/bilibili.srs"
      }
    ]
  }
}
```
> 若有其它需求，可进入 [MetaCubeX/meta-rules-dat/sing](https://github.com/MetaCubeX/meta-rules-dat/tree/sing) 搜索关键字，通过能够搜索到的关键字来编写出站和规则（推荐使用“*.srs”文件，`route.rule_set` 内须配置 `"format": "binary"`）
{: .prompt-tip }

## 四、 生成 .json 文件链接
1. 编辑完成后，点击右下角的“Create secret gist”按钮，然后点击右上角的“Raw”按钮  
<img src="/assets/img/link/click-raw-json.png" alt="生成 .json 文件链接 1" width="60%" />

2. 取出地址栏中的网址，删除后面的一串随机码，**完成后该 .json 文件直链才是最终生成的订阅链接**，该订阅链接地址不会改变，在不更改文件名的情况下即使编辑该 .json 文件并提交了 n 次也不会改变。举个例子，这是原地址：  
`https://gist.githubusercontent.com/DustinWin/e712f40922381a8d74304d592d17b90b/raw/2797de01661e33689fc980c7b6537f3d43a7d0b6/singboxlink.json`  
删除后面的一串随机码（当前编辑该文件生成的随机码“2797de01661e33689fc980c7b6537f3d43a7d0b6”）  
<img src="/assets/img/link/d0b6-json.png" alt="生成 .json 文件链接 2" width="60%" />  
删除后变成：  
`https://gist.githubusercontent.com/DustinWin/e712f40922381a8d74304d592d17b90b/raw/singboxlink.json`

- 注：若无法直连访问，可在链接上添加 `https://ghfast.top/` 前缀，即：将链接改为 `https://ghfast.top/https://gist.githubusercontent.com/DustinWin/e712f40922381a8d74304d592d17b90b/raw/singboxlink.json`

## 五、 导入订阅链接（以 ShellCrash 导入订阅链接为例）
1. 连接 SSH 后执行命令 `mkdir -p $CRASHDIR/providers/ $CRASHDIR/ruleset/`  
注：
   - ① 因出站提供者 `outbound_providers` 配置的 `path` 路径中含有文件夹 `providers`{: .filepath}，须手动新建此文件夹才能使 .yaml 订阅文件保存到本地，否则将保存到内存中（每次启动服务都要重新下载）
   - ② 因规则集 `route.rule_set` 配置的 `path` 路径中含有文件夹 `ruleset`{: .filepath}，须手动新建此文件夹才能使 .srs 规则集文件保存到本地，否则将保存到内存中（每次启动服务都要重新下载）

2. 进入 ShellCrash 配置脚本 → 6 → 2，粘贴最终生成的订阅链接即可，具体设置请参考《[ShellCrash 搭载 sing-boxp 内核的配置-ruleset 方案](https://proxy-tutorials.dustinwin.top/posts/toolsettings-shellcrash-singboxp-ruleset)》

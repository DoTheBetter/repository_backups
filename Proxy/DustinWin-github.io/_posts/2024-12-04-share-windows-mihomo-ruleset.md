---
title: 分享 mihomo for Windows 采用 ruleset 方案的一套配置
description: 此配置搭载 mihomo 内核，采用 `RULE-SET` 规则搭配 .list 和 .mrs 规则集合文件
date: 2024-12-04 02:30:00 +0800
categories: [分享配置, Windows]
tags: [Clash, mihomo, Windows, ruleset, rule-set, 分享]
---

> 声明
{: .prompt-warning }
1. 请根据自身情况进行修改，**适合自己的方案才是最好的方案**，如无特殊需求，可以照搬
2. 此方案采用**裸核**的方式运行，更加精简

## 一、 生成配置文件 .yaml 文件直链
具体方法请参考《[生成带有自定义策略组和规则的 mihomo 配置文件直链-ruleset 方案](https://proxy-tutorials.dustinwin.top/posts/link-mihomo-ruleset)》，贴一下我使用的配置：

```yaml
proxy-providers:
  🛫 机场订阅:
    type: http
    ## 修改为你的 Clash 订阅链接
    url: "https://example.com/xxx/xxx&flag=clash"
    path: ./proxies/airport.yaml
    interval: 86400
    filter: "(?i)(🇭🇰|港|hk|hongkong|hong kong|🇹🇼|台|tw|taiwan|tai wan|🇯🇵|日|jp|japan|🇸🇬|新|sg|singapore|🇺🇸|美|us|unitedstates|united states)"
    health-check:
      enable: true
      url: https://www.gstatic.com/generate_204
      interval: 600
  🆓 免费订阅:
    type: http
    ## 修改为你的 Clash 订阅链接
    url: "https://example.com/xxx/xxx&flag=clash"
    path: ./proxies/free.yaml
    interval: 86400
    health-check:
      enable: true
      url: https://www.gstatic.com/generate_204
      interval: 600

mode: rule
log-level: error
ipv6: true
allow-lan: true
mixed-port: 7890
unified-delay: true
tcp-concurrent: true
external-controller: 127.0.0.1:9090
external-ui: ui
external-ui-url: "https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip"
find-process-mode: strict
global-client-fingerprint: chrome
profile: {store-selected: true}

sniffer:
  enable: true
  parse-pure-ip: true
  sniff: {HTTP: {ports: [80, 8080-8880], override-destination: true}, TLS: {ports: [443, 8443]}, QUIC: {ports: [443, 8443]}}
  skip-domain: ['Mijia Cloud']

tun:
  enable: true
  stack: mixed
  dns-hijack: [any:53]
  auto-route: true
  auto-detect-interface: true
  device: mihomo
  strict-route: true

hosts:
  doh.pub: [1.12.12.12, 120.53.53.53, 2402:4e00::]
  dns.alidns.com: [223.5.5.5, 223.6.6.6, 2400:3200::1, 2400:3200:baba::1]
  miwifi.com: 192.168.31.1

dns:
  enable: true
  ipv6: true
  listen: 0.0.0.0:53
  fake-ip-range: 198.18.0.1/16
  enhanced-mode: fake-ip
  fake-ip-filter: ['rule-set:fakeip-filter,trackerslist,private,cn']
  nameserver:
    - https://doh.pub/dns-query
    - https://dns.alidns.com/dns-query
  direct-nameserver:
    - https://doh.pub/dns-query
    - https://dns.alidns.com/dns-query

## 若没有单个出站代理节点，须删除所有 `🆚 vless 节点` 相关内容
proxies:
  - name: 🆚 vless 节点
    type: vless
    server: example.com
    port: 443
    uuid: {uuid}
    network: ws
    tls: true
    udp: false
    sni: example.com
    client-fingerprint: chrome
    ws-opts:
      path: "/?ed=2048"
      headers:
        host: example.com

proxy-groups:
  - {name: 节点选择, type: select, proxies: [香港节点, 台湾节点, 日本节点, 新加坡节点, 美国节点, 免费节点, 🆚 vless 节点], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Proxy.png"}
  - {name: 网络测试, type: select, proxies: [全球直连, 香港节点, 台湾节点, 日本节点, 新加坡节点, 美国节点, 免费节点, 🆚 vless 节点], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Speedtest.png"}
  - {name: 人工智能, type: select, proxies: [香港节点, 台湾节点, 日本节点, 新加坡节点, 美国节点], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Bot.png"}
  - {name: Trackerslist, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Filter.png"}
  - {name: 游戏服务, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Game.png"}
  - {name: 微软服务, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Microsoft.png"}
  - {name: 谷歌服务, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Google_Search.png"}
  - {name: 苹果服务, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Apple_2.png"}
  - {name: 直连域名, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/China_Map.png"}
  - {name: 直连 IP, type: select, proxies: [全球直连, 节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/CN.png"}
  - {name: 代理域名, type: select, proxies: [节点选择, 全球直连], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Global.png"}
  - {name: 电报消息, type: select, proxies: [节点选择], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Telegram.png"}
  ## 若机场的 UDP 质量不是很好，导致某游戏无法登录或进入房间，可以添加 `disable-udp: true` 配置项解决
  - {name: 漏网之鱼, type: select, proxies: [节点选择, 全球直连], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Final.png"}
  - {name: 广告域名, type: select, proxies: [全球拦截, 全球绕过], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Advertising.png"}
  - {name: 全球拦截, type: select, proxies: [REJECT], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Reject.png"}
  - {name: 全球绕过, type: select, proxies: [PASS], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Bypass.png"}
  - {name: 全球直连, type: select, proxies: [DIRECT], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Direct.png"}

  - {name: 香港节点, type: load-balance, strategy: consistent-hashing, use: [🛫 机场订阅], filter: "(?i)(🇭🇰|港|hk|hongkong|hong kong)", icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Hong_Kong.png"}
  - {name: 台湾节点, type: load-balance, strategy: consistent-hashing, use: [🛫 机场订阅], filter: "(?i)(🇹🇼|台|tw|taiwan|tai wan)", icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Taiwan.png"}
  - {name: 日本节点, type: load-balance, strategy: consistent-hashing, use: [🛫 机场订阅], filter: "(?i)(🇯🇵|日|jp|japan)", icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Japan.png"}
  - {name: 新加坡节点, type: load-balance, strategy: consistent-hashing, use: [🛫 机场订阅], filter: "(?i)(🇸🇬|新|sg|singapore)", icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/Singapore.png"}
  - {name: 美国节点, type: load-balance, strategy: consistent-hashing, use: [🛫 机场订阅], filter: "(?i)(🇺🇸|美|us|unitedstates|united states)", icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/qure/color/United_States.png"}
  - {name: 免费节点, type: url-test, tolerance: 50, use: [🆓 免费订阅], icon: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/icon/color/vpn.png"}

rule-providers:
  fakeip-filter:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/fakeip-filter.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/fakeip-filter-lite.mrs"
    interval: 86400

  private:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/private.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/private.mrs"
    interval: 86400

  ads:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/ads.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/ads.mrs"
    interval: 86400

  trackerslist:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/trackerslist.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/trackerslist.mrs"
    interval: 86400

  applications:
    type: http
    behavior: classical
    format: text
    path: ./rules/applications.list
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/applications.list"
    interval: 86400

  microsoft-cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/microsoft-cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/microsoft-cn.mrs"
    interval: 86400

  apple-cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/apple-cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/apple-cn.mrs"
    interval: 86400

  google-cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/google-cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/google-cn.mrs"
    interval: 86400

  games-cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/games-cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/games-cn.mrs"
    interval: 86400

  ai:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/ai.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/ai.mrs"
    interval: 86400

  networktest:
    type: http
    behavior: classical
    format: text
    path: ./rules/networktest.list
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/networktest.list"
    interval: 86400

  proxy:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/proxy.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/proxy.mrs"
    interval: 86400

  tld-cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/tld-cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/tld-cn.mrs"
    interval: 86400

  cn:
    type: http
    behavior: domain
    format: mrs
    path: ./rules/cn.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/cn.mrs"
    interval: 86400

  privateip:
    type: http
    behavior: ipcidr
    format: mrs
    path: ./rules/privateip.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/privateip.mrs"
    interval: 86400

  cnip:
    type: http
    behavior: ipcidr
    format: mrs
    path: ./rules/cnip.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/cnip.mrs"
    interval: 86400

  telegramip:
    type: http
    behavior: ipcidr
    format: mrs
    path: ./rules/telegramip.mrs
    url: "https://github.com/DustinWin/ruleset_geodata/releases/download/mihomo-ruleset/telegramip.mrs"
    interval: 86400

rules:
  - RULE-SET,private,全球直连
  - RULE-SET,ads,广告域名
  - RULE-SET,trackerslist,Trackerslist
  - RULE-SET,applications,全球直连
  - RULE-SET,microsoft-cn,微软服务
  - RULE-SET,apple-cn,苹果服务
  - RULE-SET,google-cn,谷歌服务
  - RULE-SET,games-cn,游戏服务
  - RULE-SET,ai,人工智能
  - RULE-SET,networktest,网络测试
  - RULE-SET,proxy,代理域名
  - RULE-SET,tld-cn,直连域名
  - RULE-SET,cn,直连域名
  - RULE-SET,privateip,全球直连,no-resolve
  - RULE-SET,cnip,直连 IP
  - RULE-SET,telegramip,电报消息,no-resolve
  - MATCH,漏网之鱼
```

## 二、 导入 [mihomo 内核](https://github.com/MetaCubeX/mihomo)和配置文件并启动 mihomo
### 1. 导入内核和配置文件
- ① 编辑本文文档，粘贴如下内容：  
  注：
  - ➊ 将《[一](https://proxy-tutorials.dustinwin.top/posts/share-windows-mihomo-ruleset/#%E4%B8%80-%E7%94%9F%E6%88%90%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6-yaml-%E6%96%87%E4%BB%B6%E7%9B%B4%E9%93%BE)》中生成的配置文件 .yaml 文件直链替换下面命令中的 `{.yaml 配置文件直链}`
  - ➋ 或者删除此条命令，直接进入 `%PROGRAMFILES%\mihomo\profiles`{: .filepath} 文件夹，新建 config.yaml 文件并粘贴配置内容

  ```shell
  rem 导入 mihomo 内核和配置文件
  md "%PROGRAMFILES%\mihomo\profiles"
  takeown /f "%PROGRAMFILES%\mihomo" /a /r /d y
  icacls "%PROGRAMFILES%\mihomo" /inheritance:r
  icacls "%PROGRAMFILES%\mihomo" /remove[:g] "TrustedInstaller"
  icacls "%PROGRAMFILES%\mihomo" /remove[:g] "CREATOR OWNER"
  icacls "%PROGRAMFILES%\mihomo" /remove[:g] "ALL APPLICATION PACKAGES"
  icacls "%PROGRAMFILES%\mihomo" /remove[:g] "所有受限制的应用程序包"
  icacls "%PROGRAMFILES%\mihomo" /grant[:r] SYSTEM:(OI)(CI)F
  icacls "%PROGRAMFILES%\mihomo" /grant[:r] Administrators:(OI)(CI)F
  icacls "%PROGRAMFILES%\mihomo" /grant[:r] Users:(OI)(CI)F
  curl -o "%PROGRAMFILES%\mihomo\mihomo.exe" -L https://ghfast.top/https://github.com/DustinWin/proxy-tools/releases/download/mihomo/mihomo-meta-windows-amd64v3.exe
  curl -o "%PROGRAMFILES%\mihomo\profiles\config.yaml" -L {.yaml 配置文件直链}
  echo 导入 mihomo 内核和配置文件成功
  pause
  ```

- ② 另存为 .bat 文件，右击并选择“以管理员身份运行”

### 2. 启动 mihomo
- ① 编辑本文文档，粘贴如下内容：

  ```shell
  cd "%PROGRAMFILES%\mihomo"
  start /min mihomo.exe -d profiles
  ```

- ② 另存为 run.bat 文件并复制到 `%PROGRAMFILES%\mihomo`{: .filepath} 文件夹中
- ③ 右击 run.bat 文件并选择“以管理员身份运行”即可  
  小窍门：
  - ➊ 右击 run.bat 文件并选择“发送到桌面快捷方式”
  - ➋ 右击快捷方式并点击“属性” → “高级”，勾选“以管理员身份运行”并“确定”
  - ➌ 若想开机启动 mihomo，可搜索“Windows 添加任务计划”教程自行添加

## 三、 更新 mihomo 内核和配置文件
编辑本文文档，粘贴如下内容：  
注：
- ① 将《[一](https://proxy-tutorials.dustinwin.top/posts/share-windows-mihomo-ruleset/#%E4%B8%80-%E7%94%9F%E6%88%90%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6-yaml-%E6%96%87%E4%BB%B6%E7%9B%B4%E9%93%BE)》中生成的配置文件 .yaml 文件直链替换下面命令中的 `{.yaml 配置文件直链}`
- ② 或者删除此条命令，直接进入 `%PROGRAMFILES%\mihomo`{: .filepath} 文件夹，修改 config.yaml 文件内的配置内容

```shell
@echo off
rem 下载 mihomo 相关文件
curl -o "%USERPROFILE%\Downloads\mihomo.exe" -L https://github.com/DustinWin/proxy-tools/releases/download/mihomo/mihomo-meta-windows-amd64v3.exe
curl -o "%USERPROFILE%\Downloads\config.yaml" -L {.yaml 配置文件直链}
echo 下载 mihomo 相关文件成功

rem 结束 mihomo 相关进程
taskkill /f /t /im mihomo*
echo 结束 mihomo 相关进程成功

rem 更新 mihomo 内核和配置文件
copy /y "%USERPROFILE%\Downloads\mihomo.exe" "%PROGRAMFILES%\mihomo"
copy /y "%USERPROFILE%\Downloads\config.yaml" "%PROGRAMFILES%\mihomo\profiles"
echo 更新 mihomo 内核和配置文件成功

rem 更新 mihomo 内核和配置文件成功，等待 10 秒启动 mihomo 服务
timeout /t 10 /nobreak
cd "%PROGRAMFILES%\mihomo"
start /min mihomo.exe -d profiles
echo 启动 mihomo 服务成功
pause
```

另存为 .bat 文件，右击并选择“以管理员身份运行”

## 四、 访问 Dashboard 面板
.json 文件已配置 [zashboard 面板](https://github.com/Zephyruso/zashboard)  
打开 <http://127.0.0.1:9090/ui/> 后可直接点击“提交”，即可访问 Dashboard 面板  
<img src="/assets/img/share/127-9090-dashboard.png" alt="在线 Dashboard 面板" width="60%" />

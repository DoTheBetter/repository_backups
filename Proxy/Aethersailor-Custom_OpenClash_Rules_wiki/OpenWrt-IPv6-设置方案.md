# 前言  
让你优雅的使用 OpenWrt 的 IPv6 功能。  
## 关于旁路由和二级路由  
**不提供旁路由的任何设置方案**  
**强烈建议使用主路由环境，抛弃旁路由。旁路由出问题自己想办法，不要提问。**  
具体原因见：[为什么不推荐设置旁路由](https://github.com/Aethersailor/Custom_OpenClash_Rules/wiki/%E6%95%85%E9%9A%9C%E6%8E%92%E9%99%A4#%E4%B8%8D%E5%BB%BA%E8%AE%AE%E4%BD%BF%E7%94%A8%E6%97%81%E8%B7%AF%E7%94%B1)   

至于二级路由，网上教程很多，我自己没有这样的使用环境，所以也不提供任何设置方案，请自行百度。  

## 关于 DNS  
强烈建议使用三大运行商通告的 DNS，不论是解析速度还是结果的科学性，都不是第三方 DNS 可以比拟的。  
且运行商 DNS 只用于解析中国大陆域名，不存在污染问题，没必要折腾 DNS 插件去搞所谓的优选。   
## 关于 IPv6  
现在三大运行商的家宽基本都提供 IPv6 地址，首先确定你的宽带能够获得 IPv6-PD 地址才能适用本方案。如果不能的话，暂时请寻求其他的解决方案。日后我会更新无 PD 地址的设置方案。  

# IPv6 设置方案  
由于 OpenWrt 和 Lean's Lede 的设置界面不同，两种固件都提供了相应的截图，请根据你的设置界面在下方方案中找对应的设置。  
  
## OpenWrt  
本人使用的是 ImmortalWrt 的 SNAPSHOT 版本，OpenWrt 设置同理  

### 1. Dnsmasq 设置  
关闭 Dnsmasq 的“过滤 IPv6 AAAA 记录”功能。如果不关闭此项，Dnsmasq 解析的地址中不会返回 IPv6 地址，也就无法访问 IPv6 网站。  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-7.png)  

### 2. WAN 口设置 IPv6 地址  
不需要新建 WAN6，已有的 WAN6 接口要删除。  
然后直接在 WAN 口的高级设置中，开启 IPv6 的选项，并勾选使用运行商通告的 DNS。  
注意 IPv6 分配长度设为禁用。委托 IPv6 前缀勾选(不勾的话 lan 是没有 IPv6 地址的)。下面的 IPv6 首选项不要填，填了会获取不到地址的。  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-1.png)  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-2.png)  
在 WAN 接口的 DHCP 中检查设置，确保 DHCP > IPv6 设置已经关闭  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-3.png)    
保存并应用设置后，你的接口界面中应该会出现一个虚拟的 wan_6接口。注意此接口是无法编辑设置的。    
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/wan.png)   
注意红框中的 IPv6-PD 地址，获取到了这个地址才能进行下一步操作。   
如果你没有 PD 地址，说明你的 PD 地址被上一级路由占用了，或者干脆你的运行商没给。  
如果是前者，不适用本方案。如果是后者，直接打你光猫上的电话联系运维师傅（不要打 10000 号等电话，浪费时间），和运维师傅确认宽带是否能提供 IPv6-PD 地址，以及你的光猫桥接设置中是否选择了 IPv4&IPv6（有些师傅会只设置 IPv4）。   

### 3. LAN 口设置下发 IPv6 地址  
完成 WAN 设置后，接着进行 LAN 设置。如果你没有二级路由的话，不要勾选“委托 IPv6 前缀”  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-4.png)  
接着设置 LAN 口的 IPv6 DHCP 服务，让局域网设备可以取得 IPv6 地址。  
需要说明的是，IPv6 有两种获取 IP 的方式  
1、SLAAC（无状态）：IPv6 地址后缀由局域网设备自身完全随机生成。  
2、DHCPv6（有状态）：IPv6 地址后缀由 OpenWrt 统一管理。  
图中为 DHCPv6 的设置，如果你需要启用 SLACC 功能，勾选 SLACC 即可。  
SLACC 和 DHCPv6 可以同时开启，也可以开启其中之一。  

**务必启用 SLACC 功能，因为目前 Android 系统以及大量的智能家居设备，均不支持 DHCPv6。DHCPv6 功能根据个人需求选择是否开启即可**
个人建议是启用 SLACC，关闭 DHCPv6，亦或同时开启。  

注意：有些教程会推荐开启 eui64 功能，eui64 功能会依据设备的 MAC 地址来生成 IPv6 地址后缀  
eui64 的优点是生成的 IPv6 地址相对固定不会变动，且不用像 DHCPv6 那样手动指定静态地址分配，对需要静态地址的用户使用起来更佳便捷。缺点则是有泄露 MAC 地址的风险，因此不建议启用 eui64 功能。本方案不包含 eui64 的设置内容。  
关于 eui64 可以参考这里的设置：https://github.com/immortalwrt/user-FAQ/blob/main/immortalwrt%20%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E6%8C%87%E5%8C%97.md


![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-5.png)  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/v6-6.png)  
如此设置之后，局域网内的设备将获取 OpenWrt 分配的 IPv6 地址（如果启用了 SLACC 则为随机生成的地址）以及 DNS 服务器地址，DNS 服务器地址通常为 OpenWrt 自身的局域网 IPv6 地址。  

### 4. 测试  
访问 IPv6 测试网站来验证设置是否正确：  
[https://testipv6.cn/](https://testipv6.cn/)  
正常情况下，会取得全部通过的结果  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/openwrt/pics/ipv6test.png)  

至此，OpenWrt 的 IPv6 功能设置完毕。  

## Lean's LEDE 设置方案  
手头所有设备目前均不再使用 Lean's LEDE 源码固件，单纯是因为个人更喜欢官方版和 ImmortalWrt，所以以后也不会有 LEDE 的设置方案。  
请自行摸索相关设置，设置内容相似。   
图片仅供参考  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/lede/pics/lede6-1.png)  
![](https://github.com/Aethersailor/Custom_OpenClash_Rules/blob/main/doc/ipv6/lede/pics/dhcpv6.png)

## 关于本地的 IPv6 DNS  
需要说明一点，能否解析 IPv6 的 AAAA 地址并不取决于服务器自身是否有 IPv6 地址。比如当你的 OpenWrt 的上游 DNS 服务器提供 AAAA 记录解析时，你的 OpenWrt 的 Dnsmasq 就可以提供 IPv6 网站的解析服务，这和你通过 IPv4 还是 IPv6 去请求 Dnsmasq 解析是无关的。  
也就是说，当 OpenWrt 作为你的 DNS 服务器时，只要你的局域网设备获得了 IPv6 地址并且可以正常访问 IPv6 网络，即使局域网设备只取得了 IPv4 的 DNS 地址（比如 192.168.1.1），仍然可以通过 IPv4 的 DNS（192.168.1.1）去解析获得 AAAA 记录从而正常访问 IPv6 网站。  
在我实际使用的过程中，Win11 就会偶尔出现可以 ping 通 OpenWrt 的 IPv4 局域网地址（192.168.1.1）但是无法 ping 通 OpenWrt 的 IPv6 局域网地址（fda6:xxxx:xxxx::1）的情况，此时只要取消“本地 IPv6 DNS 服务器”勾选，并在“RA 标记”中取消“其他配置”的勾选，即让 OpenWrt 分配给 Win11 的 IPv6 DNS 地址为空，从而强迫系统以 IPv4 DNS（192.168.1.1）来解析 IPv6 网站的域名来正常进行访问。  
有点拗口是不是，那么无脑按照图中内容设置即可。  
一句话解释：  
**你可以直接使用 IPv4 DNS （比如路由本身的192.168.1.1）来取得 IPv6 解析结果，不需要去折腾 IPv6 相关的 DNS 设置，让下游设备不要取得 IPv6 DNS 即可**
 
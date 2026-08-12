#!/bin/sh

function init_dir(){
    dir=$1

    if [ ! -d ${dir} ]; then
        echo `date "+%Y/%m/%d %H:%M:%S"`' [info] init dir: '${dir}
        mkdir -p ${dir}
    fi
}

function init_file_conf(){
    filename=$1

    if [ ! -f /nestingdns/etc/conf/${filename} ]; then
        echo `date "+%Y/%m/%d %H:%M:%S"`' [info] init conf file: '${filename}
        cp /nestingdns/default/conf/${filename} /nestingdns/etc/conf/
    fi
}

function init_file_site(){
    filename=$1

    if [ ! -f /nestingdns/etc/site/${filename} ]; then
        echo `date "+%Y/%m/%d %H:%M:%S"`' [info] init site file: '${filename}
        if [ -f /nestingdns/default/site/${filename} ]; then
            cp /nestingdns/default/site/${filename} /nestingdns/etc/site/
        else
            touch /nestingdns/etc/site/${filename}
        fi
    fi
}


echo  "========================================================"
echo  " _   _           _   _             _____  _   _  _____ "
echo  "| \ | |         | | (_)           |  __ \| \ | |/ ____|"
echo  "|  \| | ___  ___| |_ _ _ __   __ _| |  | |  \| | (___  "
echo  "| . \` |/ _ \/ __| __| | '_ \ / _\` | |  | | . \` |\___ \ "
echo  "| |\  |  __/\__ \ |_| | | | | (_| | |__| | |\  |____) |"
echo  "|_| \_|\___||___/\__|_|_| |_|\__, |_____/|_| \_|_____/ "
echo  "                              __/ |                    "
echo  "                             |___/                     "
echo  "========================================================"


# /nestingdns/etc/conf 初始化
init_dir /nestingdns/etc/conf
init_file_conf smartdns.conf
init_file_conf mosdns.yaml
init_file_conf mosdns_load_rules.yaml
init_file_conf mosdns_forward.yaml
init_file_conf adguardhome.yaml


# /nestingdns/etc/site 初始化
init_dir /nestingdns/etc/site
init_file_site direct.txt
init_file_site proxy.txt
init_file_site private.txt
init_file_site ipv4_china.txt
init_file_site ipv4_cloudflare.txt
init_file_site direct_custom.txt
init_file_site proxy_custom.txt
init_file_site hosts.txt


# /nestingdns/work 初始化
init_dir /nestingdns/work/smartdns
init_dir /nestingdns/work/mosdns
if [ ! -f /nestingdns/work/mosdns/cache.dump ]; then
    echo `date "+%Y/%m/%d %H:%M:%S"`' [info] init: mosdns cache file'
    cp /nestingdns/default/cache/cache.dump /nestingdns/work/mosdns/
fi
init_dir /nestingdns/work/adguardhome


# 设置时区及定时任务
if [ -f /nestingdns/default/init ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
	echo $TZ > /etc/timezone
    echo "$SCHEDULE /nestingdns/bin/update.sh > /nestingdns/log/update.log 2>&1 &" >> /var/spool/cron/crontabs/root
    rm -f /nestingdns/default/init
fi


# 启动应用
# 启动 smartdns（后台）
echo `date "+%Y/%m/%d %H:%M:%S"`' [info] start smartdns: '`/nestingdns/bin/smartdns -v` | sed 's/smartdns /v/'
/nestingdns/bin/smartdns -f -x -c /nestingdns/etc/conf/smartdns.conf > /dev/null 2>&1 &
PID_SMARTDNS=$!

# 启动 mosdns（后台）
echo `date "+%Y/%m/%d %H:%M:%S"`' [info] start mosdns: '`/nestingdns/bin/mosdns version`
/nestingdns/bin/mosdns start -c /nestingdns/etc/conf/mosdns.yaml -d /nestingdns/work/mosdns > /dev/null 2>&1 &
PID_MOSDNS=$!

# 启动 adguardhome（后台）
echo `date "+%Y/%m/%d %H:%M:%S"`' [info] start adguardhome: '`/nestingdns/bin/adguardhome --version` | sed 's/AdGuard Home, version //'
/nestingdns/bin/adguardhome --no-check-update -c /nestingdns/etc/conf/adguardhome.yaml -w /nestingdns/work/adguardhome > /dev/null 2>&1 &
PID_ADGUARD=$!

# 启动定时任务 crond，定时任务包含重启mosdns，放在 mosdns 后启动
crond

# 监控三个关键进程，任意一个退出则整个容器退出（非0）
while true; do
    sleep 5

    # 检查 smartdns
    if ! kill -0 $PID_SMARTDNS 2>/dev/null; then
        echo "$(date "+%Y/%m/%d %H:%M:%S") [ERROR] smartdns (PID $PID_SMARTDNS) is dead, exiting container..."
        kill $PID_SMARTDNS $PID_MOSDNS $PID_ADGUARD 2>/dev/null
        exit 1
    fi

    # 检查 mosdns
    if ! kill -0 $PID_MOSDNS 2>/dev/null; then
        echo "$(date "+%Y/%m/%d %H:%M:%S") [ERROR] mosdns (PID $PID_MOSDNS) is dead, exiting container..."
        kill $PID_SMARTDNS $PID_MOSDNS $PID_ADGUARD 2>/dev/null
        exit 1
    fi

    # 检查 adguardhome
    if ! kill -0 $PID_ADGUARD 2>/dev/null; then
        echo "$(date "+%Y/%m/%d %H:%M:%S") [ERROR] adguardhome (PID $PID_ADGUARD) is dead, exiting container..."
        kill $PID_SMARTDNS $PID_MOSDNS $PID_ADGUARD 2>/dev/null
        exit 1
    fi
done
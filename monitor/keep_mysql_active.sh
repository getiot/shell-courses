#!/bin/bash

function keep_mysql_service_active()
{
    #result=`service mysql status`
    result=`systemctl is-active mysql`

    # result: active or inactive
    if [[ $result = "active" ]]; then
        echo "[-] MySQL is active"
        exit
    fi

    echo "[-] MySQL is inactive"
    echo "[-] Restart now"
    systemctl restart mysql
    echo "[-] Done!"
}

function main()
{
    keep_mysql_service_active
}

main
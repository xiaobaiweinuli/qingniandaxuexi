#!/bin/bash

# 设置请求头部信息
headers=(
  "-H 'Accept-Encoding: gzip, deflate'"
  "-H 'Accept-Language: *'"
  "-H 'Content-Type: application/json'"
  "-H 'Host: hnqndaxuexi.dahejs.cn'"
  "-H 'Proxy-Connection: keep-alive'"
  "-H 'Referer: http://hnqndaxuexi.dahejs.cn/'"
  "-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat(0x6309071d) XWEB/8519 Flue'"
  "-H 'accept: */*'"
)

# 发送 HTTP 请求以获取 JSON 数据
echo "正在获取 JSON 数据..."
response=$(curl -s -X GET "http://hnqndaxuexi.dahejs.cn/stw/news/list?&pageNumber=1&pageSize=10" "${headers[@]}")
echo "JSON 数据获取成功"

# 提取 pubDate 的值
pub_date=$(echo "$response" | jq -r '.obj.news.list[0].pubDate')
echo "提取 pubDate 的值：$pub_date"

# 提取 title 的值
title_value=$(echo "$response" | jq -r '.obj.news.list[0].title')
echo "提取 title 的值：$title_value"

# 获取当前日期
current_date=$(date +"%Y-%m-%d")
echo "当前日期：$current_date"

# 比较两个日期是否相同
if [ "$pub_date" == "$current_date" ]; then
  echo "日期相同，发送 PushPlus 通知..."

  # 使用环境变量 xizhi_token
xizhi_token="$XIZHI_TOKEN"

  if [ -z "$xizhi_token" ]; then
    echo "未设置 XIZHI_TOKENn，请设置环境变量 XIZHI_TOKEN"
    exit 1
  fi

  title="大学习更新-$pub_date"
  content="$title_value：[http://hnqndaxuexi.dahejs.cn/study/studyList](http://hnqndaxuexi.dahejs.cn/study/studyList)"
  
# 使用 curl 发送 POST 请求 频道推送
push_response=$(curl -s -X POST "https://xizhi.qqoq.net/${xizhi_token}.channel?" -d "title=${title}&content=${content}")
  
  echo "息知 响应：$push_response"
  echo "推送通知已发送"
else
  echo "日期不相同，不执行后续操作"
fi

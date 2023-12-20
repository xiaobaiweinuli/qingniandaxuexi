title="浅蓝色"
content="[大学习更新](http://hnqndaxuexi.dahejs.cn/study/studyList)"

# 使用环境变量 xizhi_token
xizhi_token="$XIZHI_TOKEN"

# 使用 curl 发送 POST 请求
push_response=$(curl -s -X POST "https://xizhi.qqoq.net/${xizhi_token}.channel?" -d "title=${title}&content=${content}")

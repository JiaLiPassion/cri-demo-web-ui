# CriDemo

1. Config `darkflow frontend server url` in this file [src/assets/config/config.json](./src/assets/config/config.json).
2. docker build -t cri-demo .
3. docker run --name cri-demo -p 8081:80 cri-demo
4. open browser and navigate to `http://localhost:8081`.
5. here is a demo (with fake data), [demo](./cri-demo.gif)

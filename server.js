const express = require('express');
const fetch = require("node-fetch");
const fs = require('fs')
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});


const filePath = "./video.mp4";

app.get('/video', function(req, response) {
    let url = 'http://192.168.0.112:9981/stream/channel/557a1cec850153808d4d42a4f6c7ab14?ticket=E61B6AF4A3E5B2F3C204EEDB32579D72EBD57A15';
    let encoded = Buffer.from('pi:raspberry').toString('base64');
    fetch(url, {
        method: 'GET',
        headers: {
            Authorization: 'Basic ' + encoded,
        }
    }).then((res)=> {
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
        const outVideo = fs.createWriteStream(filePath); 
        let start = new Date();
        let end = new Date(start.getTime() + 10000);
        console.log(`start recording`)
        res.body.on('data', (data) => {
            if (new Date() > end) {
                outVideo.end();
                outVideo.close();
                console.log(`end recording`)
                res.body.destroy();
                response.status(200).send(res.body);
            } else {
                outVideo.write( data, "binary" );
            }
        });
    });
});


app.get('/watch', function(req, res) {
    const path = filePath;
    const stat = fs.statSync(path)
    const fileSize = stat.size
    const range = req.headers.range
    if (range) {
        const parts = range.replace(/bytes=/, "").split("-")
        const start = parseInt(parts[0], 10)
        const end = parts[1] 
        ? parseInt(parts[1], 10)
        : fileSize-1
        const chunksize = (end-start)+1
        const file = fs.createReadStream(path, {start, end})
        const head = {
        'Content-Range': `bytes ${start}-${end}/${fileSize}`,
        'Accept-Ranges': 'bytes',
        'Content-Length': chunksize,
        }
        res.writeHead(206, head);
        file.pipe(res);
    } else {
        const head = {
        'Content-Length': fileSize,
        }
        res.writeHead(200, head)
        fs.createReadStream(path).pipe(res)
    }
});


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
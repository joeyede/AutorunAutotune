/***
 Simple node JS server that will return alive for / and execute autotune-script.sh for /exec
 */
 
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  console.log('cloudrun-autot received a request.');
  res.send(`cloudrun-autot is up and running!`);
});


app.get('/exec', (req, res) => {
  console.log('cloudrun-autot received an exec request.');
  const { execFile } = require('child_process');
  const child = execFile('/usr/src/autot/autotune-scrip.sh', {cwd : '/usr/src/autot', maxBuffer : 1024*1024*10} ,(error, stdout, stderr) => {
  if (error) {
    console.error(`cloudrun-autot script exited with error`,error);
    res.send(`Error! cloudrun-autot exec error:` + error.message);
    return;
  }
  console.log(stdout);
  console.error(stderr);
  res.send(`cloudrun-autot exec OK!`);
  });
 
});


const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('cloudrun-autot listening on port', port);
});

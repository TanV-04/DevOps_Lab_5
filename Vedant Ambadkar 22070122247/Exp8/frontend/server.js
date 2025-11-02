const express = require('express');
const path = require('path');
const cors = require('cors'); 
const app = express();
const port = process.env.PORT || 8080;

app.use(express.static(path.join(__dirname)));

app.get('/healthz', (req, res) => res.send('ok'));
app.get('/readyz', (req,res) => res.send('ready'));

app.listen(port, () => console.log(`frontend listening on ${port}`));

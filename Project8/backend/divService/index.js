const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3002;

// Use CORS and JSON middleware
app.use(cors());
app.use(express.json());  // This is required to parse JSON in the request body

// Health check endpoints
app.get('/healthz', (req, res) => res.status(200).send('ok'));
app.get('/readyz', (req, res) => res.status(200).send('ready'));

// Divide endpoint: POST /divide
app.post('/divide', (req, res) => {
  const { num1, num2 } = req.body; // Get num1 and num2 from request body
  if (Number.isNaN(num1) || Number.isNaN(num2)) {
    return res.status(400).json({ error: 'invalid numbers' });
  }
  if (num2 === 0) {
    return res.status(400).json({ error: 'division by zero' }); // Prevent division by zero
  }
  res.json({ result: num1 / num2 }); // Return the result of num1 / num2
});

// Start the service
app.listen(port, () => console.log(`div-service listening on ${port}`));

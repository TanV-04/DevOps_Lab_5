const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to parse JSON
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    pid: process.pid,
    hostname: require('os').hostname()
  });
});

// Main ping endpoint
app.get('/ping', (req, res) => {
  const timestamp = new Date().toISOString();
  const hostname = require('os').hostname();
  
  console.log(`[${timestamp}] Ping request received from ${req.ip} on pod ${hostname}`);
  
  res.status(200).json({
    message: 'pong',
    timestamp: timestamp,
    hostname: hostname,
    pid: process.pid,
    uptime: process.uptime(),
    requestHeaders: req.headers
  });
});

// CPU stress endpoint for testing autoscaling
app.get('/stress', (req, res) => {
  const duration = parseInt(req.query.duration) || 5000; // Default 5 seconds
  const maxDuration = 30000; // Max 30 seconds
  
  const actualDuration = Math.min(duration, maxDuration);
  const timestamp = new Date().toISOString();
  const hostname = require('os').hostname();
  
  console.log(`[${timestamp}] Stress test started on pod ${hostname} for ${actualDuration}ms`);
  
  // CPU intensive task
  const startTime = Date.now();
  while (Date.now() - startTime < actualDuration) {
    Math.random() * Math.random();
  }
  
  res.status(200).json({
    message: 'stress test completed',
    duration: `${actualDuration}ms`,
    timestamp: timestamp,
    hostname: hostname,
    pid: process.pid
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Ping Server is running!',
    endpoints: {
      '/ping': 'GET - Returns pong with server info',
      '/health': 'GET - Health check endpoint',
      '/stress': 'GET - CPU stress test (query: ?duration=5000)'
    },
    hostname: require('os').hostname(),
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'The requested endpoint does not exist',
    availableEndpoints: ['/', '/ping', '/health']
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: 'Something went wrong!'
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Ping server is running on port ${PORT}`);
  console.log(`📍 Hostname: ${require('os').hostname()}`);
  console.log(`🔍 PID: ${process.pid}`);
  console.log(`📊 Available endpoints:`);
  console.log(`   GET / - Server info`);
  console.log(`   GET /ping - Ping endpoint`);
  console.log(`   GET /health - Health check`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('Received SIGINT, shutting down gracefully');
  process.exit(0);
});

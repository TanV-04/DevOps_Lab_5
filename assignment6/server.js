const express = require('express');
const app = express();
const port = process.env.PORT || 4201;

app.use(express.json());

// In-memory data for demo
let posts = [
  { id: 1, user: 'user1', content: 'Hello World!', likes: 0 },
  { id: 2, user: 'user2', content: 'This is a social media post', likes: 5 }
];

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Social Media App' });
});

app.get('/posts', (req, res) => {
  // Simulate some CPU work to demonstrate autoscaling
  let sum = 0;
  for (let i = 0; i < 100000; i++) {
    sum += Math.random();
  }
  res.json(posts);
});

app.post('/posts', (req, res) => {
  const newPost = {
    id: posts.length + 1,
    user: req.body.user || 'anonymous',
    content: req.body.content || '',
    likes: 0
  };
  posts.push(newPost);
  res.status(201).json(newPost);
});

app.listen(port, () => {
  console.log(`Social Media App listening on port ${port}`);
});

import express from 'express';
import { databaseInit, execute } from './db.js';
import router from './routes/index.js';
import cors from 'cors'

const PORT = 5000;
const app = express();

async function start() {
    await databaseInit();
    app.use(cors());
    app.use(express.json());
    app.use('/api', router);
    app.listen(PORT, () => console.log('Server started'));
}

start();
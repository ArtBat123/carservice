import { Router } from "express";
import {post} from '../controllers/sendMessage.controller.js';

const router = new Router();

router.post('/send_message', post);

export default router;
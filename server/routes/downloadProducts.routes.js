import { Router } from "express";
import {post} from '../controllers/downloadProducts.controller.js';
import multer from "multer";

const upload = multer()
const router = new Router();

router.post('/download_products', upload.single("products"), post);

export default router;
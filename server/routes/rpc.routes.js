import { Router } from "express";
import {get, post, del} from '../controllers/rpc.controller.js';

const router = new Router();

router.get('/:pkg/:fun', get);
router.post('/:pkg/:fun', post);
router.delete('/:pkg/:procedure', del)

export default router;
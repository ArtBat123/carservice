import { Router } from "express";
import rpcRouter from "./rpc.routes.js";

const router = new Router();
router.use('/rpc', rpcRouter);

export default router;
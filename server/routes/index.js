import { Router } from "express";
import rpcRouter from "./rpc.routes.js";
import downloadProducts from "./downloadProducts.routes.js";
import sendMessage from "./sendMessage.routrs.js";

const router = new Router();
router.use('/rpc', rpcRouter);
router.use(downloadProducts);
router.use(sendMessage);

export default router;
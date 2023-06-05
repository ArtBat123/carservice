import { Router } from "express";
import rpcRouter from "./rpc.routes.js";
import downloadProducts from "./downloadProducts.routes.js";

const router = new Router();
router.use('/rpc', rpcRouter);
router.use(downloadProducts);

export default router;
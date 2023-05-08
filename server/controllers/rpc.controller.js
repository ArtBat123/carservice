import { execute, callFunction, callProcedure } from '../db.js';

export async function get(req, res) {
    const {pkg, fun} = req.params;
    let result;
    try {
        result = await callFunction(pkg, fun);
    } catch(e) {
        console.log(e);
        res.status(500).send({error: e.toString()});
    }
    res.json(JSON.parse(result.outBinds.ret));
}

export async function post(req, res) {
    const {pkg, fun} = req.params;
    const result = await callFunction(pkg, fun, req.body);
    res.json(JSON.parse(result.outBinds.ret));
}

export async function del(req, res) {
    const {pkg, procedure} = req.params;
    await callProcedure(pkg, procedure, req.body);
    res.send('deleted');
}
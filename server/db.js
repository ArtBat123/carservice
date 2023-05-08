import oracledb from 'oracledb';

export async function databaseInit() {
    oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
    oracledb.autoCommit = true;
    oracledb.fetchAsString = [oracledb.CLOB];
    await oracledb.createPool(
        {
            user: 'c##car',
            password: 'car',
            connectionString: 'XE',
            poolMin: 10,
            poolMax: 10,
            poolIncrement: 0,
        }
    );
    console.log("DB init");
}

export async function close() {
    await oracledb.getPool().close();
}

export async function execute(sqlString, bindParams = [], options = {}) {
    let conn;
    try {
        conn = await oracledb.getConnection();
        const result = await conn.execute(sqlString, bindParams, options);
        return result;
    } catch (error) {
        console.error(error);
        throw new Error(error)
    } finally {
        if (conn) {
            try {
                await conn.close();
            } catch (error) {
                console.error(error);
            }
        }
    }
}

export async function callFunction(pck, fun, payload) {
    let result;
    const params = payload ? `'${JSON.stringify(payload)}'` : null;
    const sql = `
        DECLARE
            ret clob;
        BEGIN
            :ret := ${pck}.${fun}(${params});
        END;`;
    try {
        result = await execute(sql, { ret: {dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 1024 * 1024} });
    } catch (error) {
        throw new Error(error);
    }
    return result
}

export async function callProcedure(pck, procedure, payload) {
    const params = `'${JSON.stringify(payload)}'`;
    const sql = `
        BEGIN
            ${pck}.${procedure}(${params});
        END;`;
    await execute(sql);
}
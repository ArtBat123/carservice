import { callProcedure, execute } from '../db.js';
import xlsx from "xlsx";
export async function post(req, res) {
    const readedData = xlsx.read(req.file.buffer);
    const wbname = readedData.SheetNames[0];
    const wb = readedData.Sheets[wbname];
    const dataParse = xlsx.utils.sheet_to_json(wb, {header: 1});

    const payload = []
    dataParse.forEach((item, index) => {
        if(index === 0) return;
        payload.push({
            name: item[0],
            price: item[1],
            count: item[2],
            producer: item[3],
            vendorCode: item[4]
        });
    });
    callProcedure('web_product_api', 'download_products', payload);
    res.send('Успешно')
}

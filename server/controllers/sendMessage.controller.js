import { execute, callFunction, callProcedure } from '../db.js';
import { sendMessage } from '../telegramBog.js';

export async function post(req, res) {
    const {phone, car} = req.body;
    console.log(req.body);
    const text = `Работы для вашего автомобиля ${car.brand} ${car.model} ${car.number} закончены. Можете приехать в автосервис и забрать его`;
    await sendMessage(phone, text);
    res.json({msg: "Успешно"});
}

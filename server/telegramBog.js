import TelegramBot from "node-telegram-bot-api";
import { callProcedure, callFunction } from "./db.js";

const token = '5901462596:AAEULbO3FEpRbGoE9wZkEC85-_iAqBHlyeg';
const bot = new TelegramBot(token, {polling: true});

export function startBot() {
    bot.on('message', (msg) => {
        // bot.sendMessage(msg.chat.id, 'ads')
        console.log(msg.text);
        if (msg.text !== "/start") {
            return;
        }
        bot.sendMessage(msg.chat.id, 'Разрешите сохранить ваш номер для уведомления об окончании работ', {
            reply_markup: {
                one_time_keyboard: true,
                keyboard: [[{request_contact: true, text: "Разрешить"}],[{text: "Отклонить"}]]
            },
        })
    });

    bot.on('contact', (msg) => {
        const payload = {
            phone: msg.contact.phone_number,
            chat: msg.chat.id,
        };
        callProcedure('web_order_api', 'save_telegram_char', payload)
        bot.sendMessage(msg.chat.id, 'Спасибо, теперь вы будете получать сообщения об окончани работ', {
            reply_markup: {
                remove_keyboard: true,
            },
        })
    })
}

export async function sendMessage(phone, text) {
    const response = await callFunction('web_order_api', 'get_chatid_by_phone', {phone});
    const chatid = JSON.parse(response.outBinds.ret).chat;
    if (chatid === null) {
        return;
    }
    bot.sendMessage(chatid, text);
}


// bot.onText(/\/echo (.+)/, (msg, match) => {
//     // 'msg' is the received Message from Telegram
//     // 'match' is the result of executing the regexp above on the text content
//     // of the message
//     msg.contact
//     const chatId = msg.chat.id;
//     const resp = match[1]; // the captured "whatever"
  
//     // send back the matched "whatever" to the chat
//     bot.sendMessage(chatId, resp);
//   });
const TelegramBot = require('node-telegram-bot-api');

const token = '5901462596:AAEULbO3FEpRbGoE9wZkEC85-_iAqBHlyeg';
const bot = new TelegramBot(token, {polling: true});

bot.on('message', (msg) => {
    // bot.sendMessage(msg.chat.id, 'ads')
    if (msg.contact) {
        return;
    }
    bot.sendMessage(msg.chat.id, 'Разрешите сохранить ваш номер для уведомления об окончании работ', {
        reply_markup: {
            one_time_keyboard: true,
            keyboard: [[{request_contact: true, text: "Разрешить"}],[{text: "Отклонить"}]]
        },
    }).then((data)=>{console.log(data);})
});

bot.on('contact', (msg) => {
    console.log(msg.contact.phone_number);
})


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
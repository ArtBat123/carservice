/**
 * Возвращает дату в виде строки dd.mm.yyyy hh24:mi:ss
 * @param {Date} date 
 * @returns 
 */
export function dateToString(date) {
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
}

/**
 * Возвращает дату в виде строки dd.mm.yyyy
 * @param {Date} date 
 * @returns 
 */
export function dateToDayString(date) {
    return date.toLocaleDateString();
}

/**
 * Получить время из даты формата "dd.mm.yyyy hh:mi:ss"
 * Возвращает hh:mi
 * @param {String} dateString 
 * @returns 
 */
export function getTimeOfDateString(dateString) {
    return dateString.split(' ')[1].slice(0, 5);
}

/**
 * Получить объект класса Date из строки "dd.mm.yyyy hh:mi:ss"
 * Возвращает hh:mi
 * @param {String} dateString 
 * @returns 
 */
export function getDateOfString(dateString) {
    const [date, time] = dateString.split(' ');
    const [day, month, year] = date.split('.');
    const [hour, minute, second] = time.split(':');
    return new Date(Number(year), Number(month) - 1, Number(day), Number(hour), Number(minute), Number(second));
}
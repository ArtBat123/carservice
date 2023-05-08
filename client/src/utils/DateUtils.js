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
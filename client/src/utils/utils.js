export function parsPhoneNumber(str) {
    if (isNaN(str)) {
        return str.replace(/[+,(,),-]/g, '');
    }
    return str;
}
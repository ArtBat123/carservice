/**
 * Служба для работы с хранилищем (localStorage)
 * методы: set, get, remove, clear
 */
class StorageSrv {
    constructor() {
        console.info('%cStorage service init!', 'color: lightGreen;');
    }

    /**
     * Сохранить значение по ключу
     *
     * @param {string} key
     * @param {*} value
     */
    set(key, value) {
        try {
            window.localStorage.setItem(
                key,
                JSON.stringify(new StoredWrapper(value, Date.now()))
            );
        } catch (error) {
            console.error(error);
        }
    }

    /**
     * Получить значение по ключу
     *
     * @param {string} key
     * @returns {*} сохранённое значение
     */
    get(key) {
        let result;

        try {
            result = JSON.parse(window.localStorage.getItem(key))?.storedValue;
        } catch (error) {
            console.error(error);
        }

        return result;
    }

    /**
     * Удалить запись по ключу
     *
     * @param {string} key
     */
    remove(key) {
        try {
            window.localStorage.removeItem(key);
        } catch (error) {
            console.error(error);
        }
    }

    /**
     * Очистить хранилище (удалить все записи)
     */
    clear() {
        try {
            window.localStorage.clear();
        } catch (error) {
            console.error(error);
        }
    }
}

/**
 * Обертка над сохраняемым объектом
 *
 * @this storedValue  - сохраняемое значение
 * @this storedTime - время сохранения в миллисекундах
 */
class StoredWrapper {
    storedValue;
    storedTime;

    constructor(storedValue, storedTime) {
        this.storedValue = storedValue;
        this.storedTime = storedTime;
    }
}

export default new StorageSrv();

/**
 * Объект для выполнения HTTP запросов
 */
class ReqExec {
    requestInit = {
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
        },
    };

    baseUrl = 'http://localhost:5000/api/';

    async get(url) {
        const init = {
            ...this.requestInit,
            method: 'GET',
        };
        try {
            const response = await fetch(this.baseUrl + url, init);
            return await response.json();
        } catch(error) {
            console.error(error);
        }
    }

    async post(url, data) {
        const init = {
            ...this.requestInit,
            method: 'POST',
            body: JSON.stringify(data),
        };
        try {
            const response = await fetch(this.baseUrl + url, init);
            return await response.json();
        } catch(error) {
            console.error(error);
        }
    }

    async delete(url, data) {
        const init = {
            ...this.requestInit,
            method: 'DELETE',
            body: JSON.stringify(data),
        };
        try {
            await fetch(this.baseUrl + url, init);
        } catch(error) {
            console.error(error);
        }
    }
}

export default new ReqExec();

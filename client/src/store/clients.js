import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';
import WarehouseItem from '@/model/WarehouseItem';
import { parsPhoneNumber } from '@/utils/utils';
import Client from '@/model/Client';
import { dateToDayString } from '@/utils/DateUtils';

export const useClientsStore = defineStore('clients', {
    state: () => ({
        /**
         * @type {Array.<WarehouseItem>}
         */
        clients: [],
    }),

    getters: {
        getClientByCode(state) {
            return (code) => state.clients.find(item => item.code === code);
        },
    },

    actions: {
        async getClients() {
            this.clients = await ReqExec.get('rpc/web_clients_api/get_clients');
        },
        async saveClient(data) {
            const client = new Client(data);
            client.phone = parsPhoneNumber(data.phone);
            const response = await ReqExec.post('rpc/web_clients_api/save_client', {...client, addedCars: data.addedCars, deletedCarsCode: data.deletedCarsCode});
            const addedCars = client.cars.filter(item => item.code === null);
            addedCars.forEach((item, index) => item.code = response.carsCodes[index])
            if (data.code) {
                const foundClientIndex = this.clients.findIndex(item => item.code === data.code);
                this.clients[foundClientIndex] = client;
            } else {
                client.code = response.code;
                client.createDate = dateToDayString(new Date());
                this.clients.push(client);
            }
        },
        async deleteClient(client) {
            const payload = {code: client.code}
            await ReqExec.delete('rpc/web_clients_api/delete_client', payload);
            this.clients = this.clients.filter(item => {
                return item.code != client.code;
            });
        }
    },
});
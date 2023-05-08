import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';

export const useClientsStore = defineStore('clients', {
    state: () => ({
        clients: [],
    }),

    actions: {
        async getClients() {
            this.clients = await ReqExec.get('rpc/web_clients_api/get_clients');
        },
        async saveClient(client) {
            const payload = {...client};
            payload.phone = payload.phone.replace(/[+,(,),-]/g, '');
            if (!payload.addedCars) {
                payload.addedCars = [];
            }
            
            const response = await ReqExec.post('rpc/web_clients_api/save_client', payload);
            const newClient = {...payload};
            newClient.code = response.code;
            newClient.fullName = `${newClient.lastName} ${newClient.firstName} ${newClient.middleName}`;
            if (client.code) {
                let ind = this.clients.findIndex(item => item.code === client.code);
                this.clients[ind] = newClient;
            } else {
                this.clients.push(newClient);
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
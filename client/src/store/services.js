import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';

export const useServicesStore = defineStore('services', {
    state: () => ({
        servicesList: [],
        groupsList: [],
        groupsTree: [],
        selectedGroup: 1,
    }),

    actions: {
        async getServicesByGroup() {
            this.servicesList = await ReqExec.post('rpc/web_service_api/get_services_by_group', {code: this.selectedGroup});
        },
        async getGroups() {
            const response = await ReqExec.get('rpc/web_service_api/get_service_groups');
            this.groupsList = structuredClone(response);
            const root = response.find(item => item.parentGroup === null);
            
            const getChildrens = function(parant) {
                const childrens = response.filter(item => item.parentGroup === parant.key);
                if (!childrens.length) {
                    return;
                }
                parant.children = childrens;
                childrens.forEach(item => getChildrens(item));
            }

            getChildrens(root);
            // отсоединим корень от потомков
            const result = [root, ...root.children]
            root.children = null,
            this.groupsTree = result;
        },
        async saveService(service) {
            await ReqExec.post('rpc/web_service_api/save_service', service);
        },
        async saveGroup(group) {
            const payload = {...group, code: null};
            await ReqExec.post('rpc/web_service_api/save_group', payload);
        },
        async deleteService(service) {
            const payload = {code: service.code};
            await ReqExec.delete('rpc/web_service_api/delete_service', payload);
        },
    },
});
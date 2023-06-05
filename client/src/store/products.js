import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';

export const useProductsStore = defineStore('products', {
    state: () => ({
        productsList: [],
        groupsList: [],
        groupsTree: [],
        selectedGroup: 1,
    }),

    actions: {
        async getProductsByGroup() {
            this.productsList = await ReqExec.post('rpc/web_product_api/get_products_by_group', {code: this.selectedGroup});
        },
        async getGroups() {
            const response = await ReqExec.get('rpc/web_product_api/get_product_groups');
            this.groupsList = structuredClone(response);
            const root = response.find(item => item.parentGroup === null);
            
            const getChildrens = function(parant) {
                const childrens = response.filter(item => item.parentGroup === parant.key);
                // if (!childrens.length) {
                //     return;
                // }
                parant.children = childrens;
                childrens.forEach(item => getChildrens(item));
            }

            getChildrens(root);
            // отсоединим корень от потомков
            const result = [root, ...root.children]
            root.children = null,
            this.groupsTree = result;
        },
        async saveProduct(product) {
            await ReqExec.post('rpc/web_product_api/save_product', product);
        },
        async saveGroup(group) {
            const payload = {...group, code: null};
            await ReqExec.post('rpc/web_product_api/save_group', payload);
        },
        async deleteProducts(product) {
            const payload = {code: product.code};
            await ReqExec.delete('rpc/web_product_api/delete_product', payload);
        },
    },
});
import { defineStore } from 'pinia';

export const useWarehouseStore = defineStore('warehouse', {
    state: () => ({
        warehouseItemList: []
    }),

    getters: {

    },

    actions: {
        getWarehouseItems() {
            
        },
        addWarehouseItem(warehouseItem) {
            this.warehouseItemList.push(warehouseItem)
        },
        deleteWarehouseItem(warehouseItem) {
            this.warehouseItemList = this.warehouseItemList.filter(item => {
                return item.code != warehouseItem.code;
            })
        }
    },
});
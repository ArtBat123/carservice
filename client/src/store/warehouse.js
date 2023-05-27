import { defineStore } from 'pinia';

export const useWarehouseStore = defineStore('warehouse', {
    state: () => ({
        warehouseItemList: [
            {
                name: 'Летние шины PIRELLI CINTURATO P7',
                count: '123',
                article: '641−2-BLK',
            },
            {
                name: 'Летние шины KUMHO ES31',
                count: '21',
                article: '642−2-BLK',
            },
            {
                name: 'Летние шины KUMHO ES33',
                count: '12',
                article: '643−2-BLK',
            },
            {
                name: 'Летние шины KUMHO KZ123',
                count: '32',
                article: '644−2-BLK',
            },
            {
                name: 'Летние шины PIRELLI CINTURATO S9',
                count: '51',
                article: '645−2-BLK',
            },
            {
                name: 'Летние шины PIRELLI CINTURATO U12',
                count: '88',
                article: '646−2-BLK',
            },
            {
                name: 'Летние шины PIRELLI CINTURATO KK12',
                count: '45',
                article: '647−2-BLK',
            }
        ]
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
import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';
import { dateToDayString, dateToString } from '@/utils/DateUtils';

export const useOrdersStore = defineStore('orders', {
    state: () => ({
        carBoxesList: [],
        boxSchedulesList: [],
        orderList: [],
        date: new Date(),        // Дата расписания
        statusList: [],
        // Данные в заказ наряде
        servicesList: [],
        productsList: [],
    }),

    getters: {
        getCarBoxByCode(state) {
            return (code) => state.carBoxesList.find(item => item.code === code);
        },
        getOrderByCode(state) {
            return (carBoxcode, orderCode) => {
                const carBox = state.boxSchedulesList.find(item => item.code === carBoxcode);
                return carBox.schedule.find(item => item.code === orderCode);
            };
        },
        getBoxSchedule(state) {
            return (carBoxcode, orderCode) => {
                const carBox = state.boxSchedulesList.find(item => item.code === carBoxcode);
                return carBox.schedule.find(item => item.orderCode === orderCode);
            };
        },
    },

    actions: {
        addProduct(data) {
            data.sum = data.price * data.count;
            this.productsList.push(data);
        },
        addService(data) {
            data.sum = data.price * data.count;
            this.servicesList.push(data);
        },
        async savePurchaseOrder(payload) {
            const order = this.getBoxSchedule(payload.carBoxCode, payload.orderCode);
            const response =  await ReqExec.post('rpc/web_order_api/save_purchase_order', payload);
            order.purchaseOrderList.push(response.code);
        },
        async getPurchaseOrderData(code) {
            if (code === null) return;
            const response = await ReqExec.post('rpc/web_order_api/get_purchase_order', {code});
            this.productsList = response.products;
            this.servicesList = response.services;
        },
        async getCarBoxes() {
            this.carBoxesList = await ReqExec.get('rpc/web_car_box_api/get_car_boxes');
        },
        async saveOrder(order) {
            const payload = {
                code: order.code,
                carBoxCode: order.carBox.code,
                dateStart: order.dateStart,
                dateEnd: order.dateEnd,
                carCode: order.car.code,
                status: order.status.code,
                orderCode: order.orderCode
            }
            const currentOrder = this.getOrderByCode(order.carBox.code, order.code);
            await ReqExec.post('rpc/web_order_api/save_box_schedule', payload);
            if (order.status.name === "Готов" && currentOrder.status.code !== order.status.code) {
                await ReqExec.post('send_message', {phone: order.client.phone, car: order.car});
            }
        },
        async deleteOrder(code) {
            await ReqExec.delete('rpc/web_order_api/delete_order', {code});
            console.log(code);
            this.orderList = this.orderList.filter(item => item.code !== code);
        },
        async getBoxSchedules() {
            this.boxSchedulesList = await ReqExec.post('rpc/web_order_api/get_box_schedules', {date: dateToDayString(this.date)});
        },
        async getOrders() {
            this.orderList = await ReqExec.get('rpc/web_order_api/get_orders');
        },
        async getOrderStatusList() {
            this.statusList = await ReqExec.get('rpc/web_order_api/get_order_status_list'); 
        },
    },
});
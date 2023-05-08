import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';
import { dateToDayString, dateToString } from '@/utils/DateUtils';

export const useOrdersStore = defineStore('orders', {
    state: () => ({
        requestsList: [],
        carBoxesList: [],
        boxSchedulesList: [],
        date: new Date(),        // Дата расписания
    }),

    getters: {
        getCarBoxByCode(state) {
            return (code) => state.carBoxesList.find(item => item.code === code);
        }
    },

    actions: {
        getRequests() {
            this.requestsList = [];
        },
        addRequest(request) {
            this.requestsList.push(request);
        },
        async getCarBoxes() {
            this.carBoxesList = await ReqExec.get('rpc/web_car_box_api/get_car_boxes');
        },
        async createOrder(order) {
            await ReqExec.post('rpc/web_order_api/save_box_schedule', order);
        },
        async getBoxSchedules() {
            this.boxSchedulesList = await ReqExec.post('rpc/web_order_api/get_box_schedules', {date: dateToDayString(this.date)});
        }
    },
});
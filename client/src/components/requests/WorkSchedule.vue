<template>
    <div>
        <div
            v-if="ordersStore.boxSchedulesList.length"
            class="cars-schedules"
        >
            <div class="cars-schedules-time-col">
                <div class="flex justify-content-between align-items-center mx-1" style="height: 40px;">
                    <i class="pi pi-caret-left text-400 hover:text-primary-500"></i>
                    <i class="pi pi-caret-right text-400 hover:text-primary-500"></i>
                </div>
                <div
                    v-for="hour in ordersStore.boxSchedulesList[0].schedule.map(item => item.timeString)"
                    class="cars-schedules-time-col-item text-400 text-sm"
                >
                    {{ hour }}
                </div>
            </div>
            <div v-for="(box, index) in ordersStore.boxSchedulesList" class="cars-schedules-col">
                <div class="cars-schedules-col-header" :style="{borderRight: ordersStore.carBoxesList.length - 1 == index ? '1px solid var(--primary-100)' : null}">
                    <i class="pi pi-car ml-2"></i>
                    <div class="ml-2">{{ box.name }}</div>
                </div>
                <div class="cars-schedules-col-body">
                    <div v-for="scheduleItem in box.schedule"
                        class="cars-schedules-col-body-item"
                        :style="{borderRight: ordersStore.carBoxesList.length - 1 == index ? '1px solid var(--primary-100)' : null}"
                        @mouseover="focusedCell = [box.code, scheduleItem.timeString]"
                        @mouseleave="focusedCell = []"
                    >
                        <div
                            v-if="scheduleItem.code"
                            class="order"
                            :style="{height: scheduleItem.height - 3 + 'px'}"
                            @click="openOrder(box.code, scheduleItem.code)"
                        >
                            {{ scheduleItem.timeStart }} - {{ scheduleItem.timeEnd }}
                            <div class="mt-1 text-color-secondary">
                                {{ scheduleItem.client.fullName }}
                            </div>
                            <div class="text-color-secondary">
                                {{ scheduleItem.car.brand }} {{ scheduleItem.car.model }} {{ scheduleItem.car.number }}
                            </div>
                        </div>
                        <div
                            v-if="focusedCell[0] == box.code && focusedCell[1] == scheduleItem.timeString && !scheduleItem.code"
                            class="create-container"
                            style="z-index: 1;"
                        >
                            <p-button
                                icon="pi pi-plus"
                                class="p-button-rounded p-button-text"
                                icon-class="text-2xl font-bold"
                                @click="openCreateOrderForm"
                            ></p-button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <create-order-form
            v-model="visibleCreateForm"
            :focusedCell="focusedCell"
            ref="create-order-form"
        />
    </div>
</template>
<script>
import { useOrdersStore } from '@/store/orders';
import { mapStores } from 'pinia';
import CreateOrderForm from './CreateOrderForm.vue';
import { getTimeOfDateString } from '@/utils/DateUtils';
export default {
    name: 'WorkSchedule',

    components: {
        CreateOrderForm,
    },
    data() {
        return {
            focusedCell: [],
            visibleCreateForm: false,
        }
    },
    methods: {
        openAddingOrder() {

        },
        openCreateOrderForm() {
            this.visibleCreateForm = true;
            this.$refs['create-order-form'].clearOrderData();
            this.$refs['create-order-form'].setCell(this.focusedCell);
        },
        openOrder(carBoxcode, orderCode) {
            const order = this.ordersStore.getOrderByCode(carBoxcode, orderCode);
            const carBox = this.ordersStore.getCarBoxByCode(carBoxcode);
            this.visibleCreateForm = true;
            this.$refs['create-order-form'].setOrderData(order, carBox);
        }
    },
    computed: {
        ...mapStores(useOrdersStore),
    },
    created() {
        this.ordersStore.getCarBoxes();
        this.ordersStore.getBoxSchedules();
    }

}
</script>
<style scoped>
.cars-schedules {
    display: flex;
    overflow-x: auto;
    width: 100%;
}
.cars-schedules-col {
    width: 300px;
    height: 100%;
    flex-shrink: 0;
}
.cars-schedules-col-header {
    width: 100%;
    height: 40px;
    border-left: 1px solid var(--primary-100);
    display: flex;
    justify-content: start;
    align-items: center;
}
.cars-schedules-col-body {
    width: 100%;
}
.cars-schedules-col-body:last-child {
    border-bottom: 1px solid var(--primary-100);
}
.cars-schedules-col-body-item {
    height: 100px;
    background-color: var(--primary-50);
    border: 1px solid var(--primary-100);
    border-bottom: 0px;
    border-right: 0px;
    position: relative;
    display: flex;
    justify-content: center;
    /* align-items: center; */
}
.cars-schedules-time-col-item:nth-child(2) {
    border-top: 1px solid var(--primary-100);
}
.cars-schedules-time-col-item {
    height: 100px;
    padding-right: 5px;
    padding-left: 10px;
}
.create-container {
    border-radius: 5px;
    background-color: var(--bluegray-50);
    width: calc(100% - 5px);
    height: calc(100% - 5px);
    position: absolute;
    display: flex;
    justify-content: center;
    align-items: center;
}
.order {
    width: 95%;
    height: 95%;
    padding: 5px;
    background-color: var(--yellow-100);
    border: 3px solid var(--yellow-200);
    border-radius: 10px;
    box-shadow: 0px 0px 3px black;
    cursor: pointer;
    position: relative;
    z-index: 11;
}
</style>
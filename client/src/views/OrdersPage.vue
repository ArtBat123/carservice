<template>
    <div class="p-card" style="max-height: calc(100vh - 5rem);">
        <div class="flex justify-content-between align-items-center">
            <h3 class="ml-4">Заявки</h3>
            <div style="position: relative;">
                <div style="position: relative; top: 50px; z-index: 111;">
                    <i
                        class="pi pi-angle-left calendar-btn"
                        @click="calendarBtnClick(-1)"
                    ></i>
                    <p-calendar
                        date-format="dd MM yy"
                        input-style="border: 0px; width: 150px"
                        v-model="ordersStore.date"
                    />
                    <i
                        class="pi pi-angle-right calendar-btn"
                        @click="calendarBtnClick(1)"
                    ></i>
                </div>
            </div>
        </div>
        <p-tab-view class="tabview-custom" ref="tabview" lazy>
            <div>asdsad11</div>
            <p-tab-panel>
                <template #header>
                    <i class="pi pi-list mr-1"></i>
                    <span>Список</span>
                </template>
                <requests-table/>
            </p-tab-panel>
            <p-tab-panel>
                <template #header>
                    <i class="pi pi-calendar mr-1"></i>
                    <span>Доска</span>
                </template>
                <work-schedule/>
            </p-tab-panel>
        </p-tab-view>
    </div>
</template>
<script>
import RequestsTable from "@/components/requests/RequestsTable.vue";
import WorkSchedule from "@/components/requests/WorkSchedule.vue";
import { useOrdersStore } from "@/store/orders";
import { mapStores } from "pinia";

export default {
    name: 'RequestsPage',

    components: {
        RequestsTable,
        WorkSchedule
    },

    data() {
        return {
        }
    },

    methods: {
        calendarBtnClick(number) {
            const date = new Date(+this.ordersStore.date + 24 * 3600 * 1000 * number);
            this.ordersStore.date = date;
            this.ordersStore.getBoxSchedules();
        }
    },

    computed: {
        ...mapStores(useOrdersStore),
    },
    
}
</script>
<style scoped>
:deep(.p-tabview-panels) {
    padding: 0 !important;
}
:deep(.p-calendar-w-btn) {
    border: none !important;
    box-shadow: none !important;
}
:deep(.p-inputtext.p-component) {
    cursor: pointer !important;
    caret-color: transparent; 
    text-align: center;
    padding: 0;
}
:deep(.p-inputtext.p-component:hover) {
    color: var(--primary-color);
}
:deep(.p-inputtext:enabled:focus) {
    box-shadow: none !important;
    color: var(--primary-color);
}
.calendar-btn {
    color: var(--surface-400);
}
.calendar-btn:hover {
    cursor: pointer;
    color: var(--primary-color);
}
</style>
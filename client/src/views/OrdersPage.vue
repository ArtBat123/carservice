<template>
    <div class="p-card" style="max-height: calc(100vh - 5rem);">
        <div class="flex justify-content-between align-items-center">
            <div class="ml-4 text-4xl font-bold">Заявки</div>
            <div style="position: relative;">
                <div v-if="activePanel == 1" style="position: relative; top: 50px; z-index: 111;">
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
        <p-tab-view
            v-model:activeIndex="activePanel"
            class="tabview-custom"
            ref="tabview"
            lazy
        >
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
            activePanel: 0,
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
.calendar-btn {
    color: var(--surface-400);
}
.calendar-btn:hover {
    cursor: pointer;
    color: var(--primary-color);
}
</style>
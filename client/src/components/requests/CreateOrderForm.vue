<template>
    <p-sidebar
        :baseZIndex="10000"
        position="right"
        class="p-sidebar-md"
        :visible="modelValue"
        @update:visible="$emit('update:modelValue', e)"
        @hide="clearOrderData"
    >
        <template #header>
            <h3 class="pl-3">Информация о заказе</h3>
        </template>
        <div class="p-fluid">
            <div class="field">
                <label>Клиент</label>
                <div class="flex">
                    <p-auto-complete
                        v-model="client"
                        :suggestions="filteredClients"
                        forceSelection
                        completeOnFocus
                        optionLabel="fullName"
                        dropdown
                        :delay="0"
                        placeholder="Выберите клиента"
                        style="width: 100%; margin-right: 5px;"
                        @complete="searchClient"
                    />
                    <p-button
                        icon="pi pi-plus"
                        v-tooltip="'Добавить клиента'"
                        @click="isOpenedClientForm = true"
                    ></p-button>
                </div>
            </div>
            <div class="field">
                <label>Автомобиль</label>
                <p-dropdown
                    v-model="car"
                    :options="client?.cars"
                    placeholder="Выберите авто клиента"
                    :optionLabel="car => `${car.brand} ${car.model} ${car.number}`"
                />
            </div>
            <div class="field">
                <label>Начало работы</label>
                <p-calendar
                    v-model="startWork"
                    showTime
                    hourFormat="24"
                    showIcon
                    :showOnFocus="false"
                    dateFormat="dd/mm/yy"
                />
            </div>
            <div class="field">
                <label>Конец работы</label>
                <p-calendar
                    v-model="endWork"
                    showTime
                    hourFormat="24"
                    showIcon
                    :showOnFocus="false"
                    dateFormat="dd/mm/yy"
                />
            </div>
            <div class="field">
                <label>Статус</label>
                <p-dropdown
                    v-model="status"
                    :options="['В работе', 'Готов', 'Ожидает']"
                    placeholder="Статус"
                />
            </div>
            <div class="field">
                <label>Авто-бокс</label>
                <p-dropdown
                    v-model="carBox"
                    :options="ordersStore.carBoxesList"
                    optionLabel="name"
                    placeholder="Авто-бокс"
                />
            </div>
            <div class="text-xl field flex align-items-center">
                <div class="mr-4">Заказ-наряд:</div>
                <p-chip>
                    <div class="p-2">
                        <span
                            class="text-primary hover:underline cursor-pointer"
                            @click="visiblePurchaseOrder = true"
                        >
                            №123
                        </span>
                        <span class="ml-2">Сумма: 14503₽</span>
                    </div>
                </p-chip>
            </div>
        </div>
        <div>
            <p-button
                label="Закрыть"
                icon="pi pi-times"
                class="p-button-text"
                @click="$emit('update:modelValue', false)"
            ></p-button>
            <p-button
                label="Сохранить"
                icon="pi pi-check"
                class="p-button-text"
                @click="save"
            ></p-button>
        </div>
    </p-sidebar>
    <p-sidebar
        v-model:visible="isOpenedClientForm"
        :baseZIndex="10001"
        position="right"
        class="p-sidebar-md"
    >
        <template #header>
            <h3 class="pl-3">Информация о клиенте</h3>
        </template>
        <client-form
            :initialClient="null"
            @close="isOpenedClientForm = false"
        ></client-form>
    </p-sidebar>
    <purchase-order-dialog
        v-model="visiblePurchaseOrder"
    />
</template>
<script>
import { useClientsStore } from '@/store/clients';
import { useOrdersStore } from '@/store/orders';
import { mapStores } from 'pinia';
import { dateToString, getDateOfString } from '@/utils/DateUtils';
import ClientForm from '@/components/client/ClientForm.vue';
import PurchaseOrderDialog from "@/components/requests/PurchaseOrderDialog.vue";

export default {
    name: 'CreateOrderForm',
    components: {
        ClientForm,
        PurchaseOrderDialog,
    },
    emits: ['update:modelValue'],
    props: {
        modelValue: Boolean,
    },
    data() {
        return {
            visiblePurchaseOrder: false,
            isOpenedClientForm: false,
            client: null,
            car: null,
            filteredClients: null,
            startWork: new Date(),
            endWork: new Date(),
            status: null,
            carBox: null,
            code: null,
            orderCode: null,
        };
    },
    methods: {
        searchClient(e) {
            console.log(e);
            const substring = e.query.toLowerCase();
            this.filteredClients = this.clientsStore.clients.filter(item => item.fullName.toLowerCase().includes(substring)); 
        },
        setCell(cell) {
            this.carBox = this.ordersStore.getCarBoxByCode(cell[0]);
            const minute = Number(cell[1].split(':')[1]);
            const hour = Number(cell[1].split(':')[0]);
            this.startWork = new Date(new Date(this.ordersStore.date).setHours(hour, minute));
            this.endWork = new Date(this.ordersStore.date.setHours(hour + 1, minute));
        },
        setOrderData(order, carBox) {
            const {client, car, dateStart, dateEnd, status, code, orderCode} = order;
            this.code = code;
            this.client = this.clientsStore.getClientByCode(client.code);
            this.car = this.client.cars.find(item => item.code === car.code);
            console.log(dateStart);
            console.log(getDateOfString(dateStart));
            this.startWork = getDateOfString(dateStart);
            this.endWork = getDateOfString(dateEnd);
            this.status = status;
            this.carBox = this.ordersStore.carBoxesList.find(item => item.code === carBox.code);
            this.orderCode = orderCode;
        },
        clearOrderData() {
            this.code = null;
            this.client = null;
            this.car = null;
            this.startWork = null;
            this.endWork = null;
            this.status = null;
            this.carBox = null;
            this.orderCode = null;
        },
        async save() {
            const order = {
                code: this.code,
                carBox: this.carBox,
                dateStart: dateToString(this.startWork),
                dateEnd: dateToString(this.endWork),
                car: this.car,
                client: this.client,
                status: this.status,
                orderCode: this.orderCode,
            };
            await this.ordersStore.saveOrder(order);
            await this.ordersStore.getOrders();
            await this.ordersStore.getBoxSchedules();
            this.$emit('update:modelValue', false)
        }
    },
    computed: {
        ...mapStores(useClientsStore, useOrdersStore),
    },
    mounted() {
        console.log(1);
        this.clientsStore.getClients();
        this.ordersStore.getCarBoxes();
    }
};
</script>
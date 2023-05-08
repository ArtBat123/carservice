<template>
    <p-sidebar
        :baseZIndex="10000"
        position="right"
        class="p-sidebar-md"
        :visible="modelValue"
        @update:visible="$emit('update:modelValue', e)"
    >
        <template #header>
            <h3 class="pl-3">Информация о заказе</h3>
        </template>
        <div class="p-fluid">
            <div class="field">
                <label>Клиент</label>
                <p-auto-complete
                    v-model="client"
                    :suggestions="filteredClients"
                    forceSelection
                    completeOnFocus
                    optionLabel="fullName"
                    dropdown
                    :delay="0"
                    placeholder="Выберите клиента"
                    @complete="searchClient"
                />
            </div>
            <div class="field">
                <label>Автомобиль</label>
                <p-dropdown
                    v-model="car"
                    :options="client?.cars"
                    placeholder="Выберите авто клиента"
                    :optionLabel="car => `${car.brang} ${car.model} ${car.number}`"
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
</template>
<script>
import { useClientsStore } from '@/store/clients';
import { useOrdersStore } from '@/store/orders';
import { mapStores } from 'pinia';
import { dateToString } from '@/utils/DateUtils';

export default {
    name: 'CreateOrderForm',
    emits: ['update:modelValue'],
    props: {
        modelValue: Boolean,
        focusedCell: Array,
    },
    data() {
        return {
            client: null,
            car: null,
            filteredClients: null,
            startWork: new Date(),
            endWork: new Date(),
            status: null,
            carBox: null,
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
            const minute = cell[1].split(':')[1];
            const hour = cell[1].split(':')[0];
            this.startWork = new Date(new Date(this.ordersStore.date).setHours(hour, minute));
            this.endWork = new Date(this.ordersStore.date);
        },
        async save() {
            const order = {
                code: null,
                carBoxCode: this.carBox.code,
                dateStart: dateToString(this.startWork),
                dateEnd: dateToString(this.endWork),
                carCode: this.car.code,
            };
            await this.ordersStore.createOrder(order);
            await this.ordersStore.getBoxSchedules();
            this.$emit('update:modelValue', false)
        }
    },
    computed: {
        ...mapStores(useClientsStore, useOrdersStore),
    },
    mounted() {
        this.clientsStore.getClients();
        this.ordersStore.getCarBoxes();
    }
};
</script>
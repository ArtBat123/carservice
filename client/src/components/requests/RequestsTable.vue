<template lang="">
    <div class="p-card">
        <p-toolbar>
            <template #start>
                <p-button
                    @click="visibleOrderForm = true"
                    label="Добавить"
                    icon="pi pi-plus"
                />
            </template>
            <template #end>
                <span class="p-input-icon-left ml-4">
                    <i class="pi pi-search"></i>
                    <p-input-text
                        v-model="filterObj['global'].value"
                        placeholder="Поиск"
                        class="p-inputtext-sm"
                    ></p-input-text>
                </span>
            </template>
        </p-toolbar>
        <p-data-table
            :value="ordersStore.orderList"
            v-model:contextMenuSelection="contextMenuSelection"
            v-model:filters="filterObj"
            @rowContextmenu="onRowContextMenu"
        >
            <p-column field="client.fullName" header="Клиент" :sortable="true"></p-column>
            <p-column field="car.fullName" header="Авто" :sortable="true"></p-column>
            <p-column field="carBox.name" header="Пост" :sortable="true"></p-column>
            <p-column field="dateStart" header="Дата начала" :sortable="true"></p-column>
            <p-column field="dateEnd" header="Дата окончания" :sortable="true"></p-column>
            <p-column field="createDate" header="Дата создания" :sortable="true"></p-column>
            <p-column field="status.name" header="Статус" :sortable="true"></p-column>
        </p-data-table>
    </div>
    <create-order-form
        v-model="visibleOrderForm"
        ref="create-order-form"
    />
    <p-context-menu :model="menuModel" ref="cm" />
    <!-- Удаление заказа -->
    <p-dialog
            v-model:visible="showDeleteDialog"
            header="Подтверждение"
        >
        <div class="flex align-items-center">
            <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
            <span>Вы действительно хотите удалить заказ?</span>
        </div>
        <template #footer>
            <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="showDeleteDialog = false"/>
            <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteOrder"/>
        </template>
    </p-dialog>
</template>
<script>
import { mapStores } from 'pinia';
import { useOrdersStore } from "@/store/orders.js";
import CreateOrderForm from "@/components/requests/CreateOrderForm.vue";
import { FilterMatchMode } from 'primevue/api';

export default {
    name: 'RequestsTable',
    components: {
        CreateOrderForm,
    },
    data() {
        return {
            contextMenuSelection: null,
            showDeleteDialog: false,
            visibleOrderForm: false,
            menuModel: [
                { label: "Удалить", icon: "pi pi-fw pi-times", command: () => this.openDeleteDialog() },
                { label: "Изменить", icon: "pi pi-pencil", command: () => this.openEditOrder() },
            ],
            filterObj: {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            },
        };
    },
    methods: {
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        openDeleteDialog() {
            this.showDeleteDialog = true;
        },
        openEditOrder() {
            this.visibleOrderForm = true;
            const order = this.ordersStore.orderList.find(item => item.code === this.contextMenuSelection.code);
            const orderCopy = {...order};
            orderCopy.code = order.boxScheduleCode;
            orderCopy.orderCode = order.code;
            this.$refs['create-order-form'].setOrderData(orderCopy, orderCopy.carBox);
        },
        deleteOrder() {
            this.ordersStore.deleteOrder(this.contextMenuSelection.code);
            this.showDeleteDialog = false;
        }
    },
    computed: {
        ...mapStores(useOrdersStore),
    },

    created() {
        this.ordersStore.getOrders();
    }
}
</script>

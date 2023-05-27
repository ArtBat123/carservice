<template lang="">
    <div class="p-card">
        <p-toolbar>
            <template #start>
                <p-button
                    @click="visibleSidebar = true"
                    label="Добавить"
                    icon="pi pi-plus"
                />
                <p-button
                    @click="deleteItemsDialog = true"
                    label="Удалить"
                    icon="pi pi-trash"
                    class="ml-3"
                />
            </template>
            <template #end>
                <span class="p-input-icon-left p-input-icon-right">
                    <i class="pi pi-search"></i>
                    <p-input-text
                        placeholder="Поиск"
                    ></p-input-text>
                    <i
                        class="pi pi-filter-slash cursor-pointer"
                        @click="initFilter"
                    ></i>
                </span>
            </template>
        </p-toolbar>
        <p-data-table
            :value="ordersStore.requestsList"
        >
            <p-column field="client" header="Клиент"></p-column>
            <p-column field="status" header="Статус"></p-column>
            <p-column field="createDate" header="Дата создания"></p-column>
            <p-column field="car" header="Авто"></p-column>
        </p-data-table>
    </div>
</template>
<script>
import { mapStores } from 'pinia';
import { useOrdersStore } from "@/store/orders.js";

export default {
    name: 'RequestsTable',

    computed: {
        ...mapStores(useOrdersStore),
    }
}
</script>
<style lang="">
    
</style>
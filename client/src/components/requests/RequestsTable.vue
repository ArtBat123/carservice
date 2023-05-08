<template lang="">
    <div class="p-card">
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
<template>
    <p-dialog
        :visible="modelValue"
        :closable="true"
        :header="purchaseOrderCode ? `Заказ-наряд №${purchaseOrderCode}` : 'Новый заказ-наряд'"
        modal
        @update:visible="$emit('update:modelValue', e)"
    >
        <div :style="{ width: '80vw', height: '75vh' }">
            <p-tab-view>
                <p-tab-panel header="Услуги">
                    <services-list/>
                </p-tab-panel>
                <p-tab-panel header="Товары">
                    <products-list/>
                </p-tab-panel>
                <p-tab-panel header="Акт осмотра">
                    
                </p-tab-panel>
            </p-tab-view>
        </div>
    </p-dialog>
</template>
<script>
import { mapStores } from 'pinia';
import ServicesList from './ServicesList.vue';
import ProductsList from './ProductsList.vue';
import { useOrdersStore } from '@/store/orders';

export default {
    name: "PurchaseOrderDialog",
    components: { ServicesList, ProductsList },
    props: {
        modelValue: Boolean,
        purchaseOrderCode: Number,
    },
    emits: ["update:modelValue"],
    data() {
        return {};
    },
    computed: {
        ...mapStores(useOrdersStore),
    },
    created() {
        console.log(111);
    }
};
</script>
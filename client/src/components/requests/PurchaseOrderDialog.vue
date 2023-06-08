<template>
    <p-dialog
        :visible="modelValue"
        :closable="true"
        :header="purchaseOrderCode ? `Заказ-наряд №${purchaseOrderCode}` : 'Новый заказ-наряд'"
        modal
        @update:visible="$emit('update:modelValue', e)"
    >
        <div :style="{ width: '80vw', height: '70vh' }">
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
        <div>
            <p-button
                label="Закрыть"
                icon="pi pi-times"
                class="p-button-text"
                @click="closeDialog"
            ></p-button>
            <p-button
                label="Сохранить"
                icon="pi pi-check"
                class="p-button-text"
                @click="savePurchaseOrder"
            ></p-button>
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
        orderCode: Number,
        carBox: Object,
    },
    emits: ["update:modelValue"],
    data() {
        return {};
    },
    methods: {
        closeDialog() {
            this.ordersStore.productsList = [];
            this.ordersStore.servicesList = [];
            this.$emit('update:modelValue', false);
        },
        savePurchaseOrder() {
            this.ordersStore.savePurchaseOrder({
                orderCode: this.orderCode,
                products: this.ordersStore.productsList,
                services: this.ordersStore.servicesList,
                carBoxCode: this.carBox?.code,
            });
            this.closeDialog();
        }
    },
    computed: {
        ...mapStores(useOrdersStore),
    },
    watch: {
        purchaseOrderCode(newCode) {
            this.ordersStore.getPurchaseOrderData(newCode);
        }
    },
    created() {
        this.ordersStore.getPurchaseOrderData(this.purchaseOrderCode);
    }
};
</script>
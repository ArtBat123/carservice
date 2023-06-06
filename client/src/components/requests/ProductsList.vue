<template>
    <div
        v-if="openAddingForm"
        class="flex"
        style="height: 50px;"
    >
        <p-auto-complete
            v-model="selectedProduct"
            placeholder="Наименование"
            :suggestions="filteredProducts"
            dropdown
            optionLabel="name"
            style="width: 600px;"
            @complete="searchProduct"
        />
        <div class="flex flex-column">
            <p-input-number
                v-model="selectedCount"
                class="p-inputtext-sm ml-2"
                placeholder="Количество"
                :useGrouping="false"
                autofocus
            />
            <small
                v-if="selectedProduct && selectedCount > selectedProduct.count"
                class="p-error pl-2"
            >
                На складе {{ selectedProduct.count }} шт
            </small>
        </div>
        <p-button
            icon="pi pi-plus"
            class="p-button-text p-button-rounded ml-4"
            @click="addProducts"
        ></p-button>
        <p-button
            icon="pi pi-trash"
            class="p-button-text p-button-rounded"
            @click="closeForm"
        ></p-button>
    </div>
    <div v-else style="height: 50px;">
        <p-button
            label="Добавить"
            @click="openAddingForm = true"
        ></p-button>
    </div>
    <p-data-table
        :value="ordersStore.productsList"
        class="mt-3"
        scrollHeight="calc(70vh - 150px)"
        :scrollable="true"
    >
        <p-column field="name" header="Наименование"></p-column>
        <p-column field="count" header="Количество"></p-column>
        <p-column field="price" header="Цена"></p-column>
        <p-column field="sum" header="Сумма"></p-column>
    </p-data-table>
</template>
<script>
import { useOrdersStore } from '@/store/orders';
import { useProductsStore } from '@/store/products';
import { mapStores } from 'pinia';

export default {
    name: 'ProductsList',
    data() {
        return {
            openAddingForm: false,
            filteredProducts: [],

            selectedProduct: null,
            selectedCount: 0,
        }
    },
    methods: {
        searchProduct(e) {
            const substring = e.query.toLowerCase();
            this.filteredProducts = this.productsStore.productsList.filter(item => item.name.toLowerCase().includes(substring)); 
        },
        addProducts() {
            if (!this.selectedProduct || this.selectedCount > this.selectedProduct.count || this.selectedCount <= 0) {
                return;
            }
            const payload = {
                ...this.selectedProduct,
                count: this.selectedCount,
            };
            this.ordersStore.addProduct(payload);
            this.clearForm();
        },
        closeForm() {
            this.clearForm();
            this.openAddingForm = false;
        },
        clearForm() {
            this.selectedCount = 0;
            this.selectedProduct = null;
        }
    },
    computed: {
        ...mapStores(useOrdersStore, useProductsStore),
    },
    created() {
        this.productsStore.getProductsByGroup(1);
    }
};
</script>
<template>
    <div>
        <p-data-table
            :value="productsAndCategoriesStore.productsList"
            selectionMode="multiple"
            dataKey="id"
            v-model:selection="selectedProducts"
            :filters="productFilter"
        >
            <template #header>
                <div class="flex align-items-center justify-content-between">
                    <div>
                        <div class="p-input-icon-left">
                            <i class="pi pi-search"></i>
                            <p-input-text v-model="productFilter['global'].value" placeholder="Поиск" class="p-inputtext-sm" />
                        </div>
                        <p-button
                            label="Добавить"
                            icon="pi pi-plus"
                            class="ml-2"
                            @click="visibleSidebar = true"
                        />
                    </div>
                    <div>
                        <p-button
                            v-if="selectedProducts.length"
                            icon="pi pi-trash"
                            class="p-button-rounded p-button-text p-button-danger"
                        />
                        <p-button
                            v-if="selectedProducts.length"
                            icon="pi pi-upload"
                            class="p-button-rounded p-button-text"
                            v-tooltip.top="'Скачать данные из таблицы'"
                        />
                        <p-button
                            icon="pi pi-download"
                            class="p-button-rounded p-button-text"
                            v-tooltip.top="'Загрузить данные в таблицу'"
                        />
                    </div>
                </div>
            </template>
            <p-column selectionMode="multiple"></p-column>
            <p-column field="vendorСode" header="Артикул"></p-column>
            <p-column field="name" header="Название"></p-column>
        </p-data-table>
        <p-sidebar v-model:visible="visibleSidebar" :baseZIndex="10000" position="right" class="p-sidebar-md">
            <template #header>
                <h3 class="pl-3">Добавление товара</h3>
            </template>
            <div class="p-fluid">
                <div class="field">
                    <label for="name">Категория</label>
                    <div class="flex justify-content-between">
                        <p-dropdown
                            v-model="newProduct.category"
                            :options="productsAndCategoriesStore.categoriesChoosing"
                            optionLabel="data.сategory"
                            optionValue="key"
                            showClear
                            class="flex-grow-1 mr-5 p-inputtext-sm"
                        />
                        <p-button
                            class="w-max"
                            label="Категория"
                            icon="pi pi-plus"
                        />
                    </div>
                </div>
                <div class="field">
                    <label for="name">Название товара</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.name"
                        class="p-inputtext-sm"
                    />
                </div>
                <div class="field">
                    <label for="name">Производитель</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.name"
                        class="p-inputtext-sm"
                    />
                </div>
                <div class="field">
                    <label for="name">Описание</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.description"
                        class="p-inputtext-sm"
                    />
                </div>
                <div class="field">
                    <label for="name">Цена</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.description"
                        class="p-inputtext-sm"
                    />
                </div>
                <!-- <div class="field">
                    <label for="name">Код</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.code"
                        class="p-inputtext-sm"
                    />
                </div> -->
                <div class="field">
                    <label for="name">Артикул</label>
                    <p-input-text
                        autofocus
                        v-model="newProduct.vendorСode"
                        class="p-inputtext-sm"
                    />
                </div>
                <!-- <div class="field">
                    <label for="name">Штрихкод</label>
                </div> -->
                <div>
                    <p-button
                        label="Добавить"
                        class="ml-auto w-max ml-auto"
                        @click="addProduct"
                    />
                </div>
            </div>
        </p-sidebar>
    </div>
</template>

<script>
import { mapStores } from 'pinia';
import { useProductsAndCategoriesStore } from '@/store/productsAndCategories';
import { FilterMatchMode } from 'primevue/api';

export default {
    name: "ProductsPanel",

    data() {
        return {
            productFilter: {
                'global': {value: null, matchMode: FilterMatchMode.CONTAINS},
            },
            newProduct: {
                category: null,
                name: null,
                description: null,
                code: null,
                vendorСode: null,
            },
            visibleSidebar: false,
            selectedProducts: [],
        }
    },

    methods: {
        addProduct() {
            this.productsAndCategoriesStore.addProduct(this.newProduct);
            this.visibleSidebar = false;
        }
    },

    computed: {
        ...mapStores(useProductsAndCategoriesStore)
    },

    mounted() {
        this.productsAndCategoriesStore.getProducts();
    }
}
</script>

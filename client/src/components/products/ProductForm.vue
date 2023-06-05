<template>
    <p-sidebar
        :visible="modelValue"
        :baseZIndex="10000"
        position="right"
        class="p-sidebar-md"
        @update:visible="$emit('update:modelValue', e)"
        @hide="closeProductsForm"
    >
        <template #header>
            <h3 class="pl-3">Информация о товаре</h3>
        </template>
        <div class="p-fluid">
            <div class="field">
                <div>Наименование</div>
                <p-input-text
                    v-model="product.name"
                    autofocus
                />
            </div>
            <div class="field">
                <div>Производитель</div>
                <p-input-text
                    v-model="product.producer"
                    autofocus
                />
            </div>
            <div class="field">
                <div>Группа</div>
                <p-tree-select 
                    v-model="product.productGroup"
                    :options="productsStore.groupsTree"
                    scrollHeight="300px"
                />
            </div>
            <div class="field">
                <div>Цена</div>
                <p-input-number
                    v-model="product.price"
                    autofocus
                    suffix="₽"
                />
            </div>
            <div class="field">
                <div>Артикул</div>
                <p-input-text
                    v-model="product.vendorCode"
                    autofocus
                />
            </div>
            <div class="field">
                <div>Описание</div>
                <p-textarea
                    v-model="product.description"
                    autofocus
                />
            </div>
            <div class="field">
                <div>Остаток</div>
                <p-input-number
                    v-model="product.count"
                    autofocus
                />
            </div>
        </div>
        <div class="mt-2">
            <p-button
                label="Закрыть"
                icon="pi pi-times"
                class="p-button-text"
                @click="$emit('update:modelValue', false)"
            />
            <p-button
                label="Сохранить"
                icon="pi pi-check"
                class="p-button-text"
                @click="saveProduct"
            />
        </div>
    </p-sidebar>
</template>
<script>
import { useProductsStore } from '@/store/products';
import { mapStores } from 'pinia';
import Product from "@/model/Product";
export default {
    name: 'ProductForm',
    emits: ['update:modelValue'],
    props: {
        modelValue: Boolean,
        initialProduct: Object,
    },
    data() {
        return {
            product: new Product(),
        };
    },
    methods: {
        async saveProduct() {
            const product = {...this.product};
            product.productGroup = Number(Object.keys(product.productGroup)[0]);
            await this.productsStore.saveProduct(product);
            this.$emit('update:modelValue', false);
            this.product = new Product();
            this.productsStore.getProductsByGroup()
        },
        closeProductsForm() {
            this.product = new Product();
        }
    },
    watch: {
        initialProduct(newVal) {
            if (newVal) {
                this.product = new Product(newVal);
                const productGroup = {};
                productGroup[newVal.productGroupCode] = true
                this.product.productGroup = productGroup;
            } else {
                this.product = new Product();
            }
        }
    },
    computed: {
        ...mapStores(useProductsStore),
    },
};
</script>
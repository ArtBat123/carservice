<template>
    <div>
        <p-tree-table
            :value="productsAndCategoriesStore.categoriesList"
            selectionMode="multiple"
            v-model:selectionKeys="selectedCategories"
            class="p-treetable-sm"
            :filters="categoriesFilter"
        >
            <template #header>
                <div class="flex align-items-center">
                    <div class="p-input-icon-left">
                        <i class="pi pi-search"></i>
                        <p-input-text v-model="categoriesFilter['global']" placeholder="Поиск" class="p-inputtext-sm" />
                    </div>
                    <p-button
                        label="Добавить"
                        icon="pi pi-plus"
                        class="ml-2"
                        @click="visibleSidebar = true"
                    />
                </div>
            </template>
            <p-column field="сategory" header="Категория" :expander="true"></p-column>
            <p-column field="quantity" header="Количество"></p-column>
        </p-tree-table>
        <p-sidebar v-model:visible="visibleSidebar" :baseZIndex="10000" position="right" class="p-sidebar-md">
            <template #header>
                <h3 class="pl-3">Добавление категории</h3>
            </template>
            <div class="p-fluid">
                <div class="field">
                    <label for="name">Название категории</label>
                    <p-input-text
                        id="name"
                        required="true"
                        autofocus
                        v-model="newCategory.name"
                        class="p-inputtext-sm"
                    />
                </div>
                <div class="field">
                    <label for="name">Родительская категория</label>
                    <p-dropdown
                        v-model="newCategory.parentCategoryKey"
                        :options="productsAndCategoriesStore.categoriesChoosing"
                        optionLabel="data.сategory"
                        optionValue="key"
                        showClear
                        class="p-inputtext-sm"
                    />
                </div>
                <div>
                    <p-button
                        label="Добавить"
                        class="ml-auto w-max ml-auto"
                        @click="addCategory"
                    />
                </div>
            </div>
        </p-sidebar>
    </div>
</template>
<script>
import { mapStores } from "pinia";
import { useProductsAndCategoriesStore } from "@/store/productsAndCategories";

export default {
    name: "CategoriesPanel",

    data() {
        return {
            visibleSidebar: false,
            selectedCategories: [],
            categoriesFilter: {},

            newCategory: {
                name: null,
                parentCategoryKey: null,
            }
        }
    },

    methods: {
        addCategory() {
            this.productsAndCategoriesStore.addCategory(this.newCategory);
        }
    },

    computed: {
        ...mapStores(useProductsAndCategoriesStore),
    },

    mounted() {
        this.productsAndCategoriesStore.categoriesList = [
            {
                key:1,
                data: {
                    сategory: "Ходовая часть",
                    quantity: 1,
                }
            },
            {
                key:2,
                data: {
                    сategory: "Резина",
                    quantity: 2,
                }
            },
        ]
    }
}
</script>
<style scoped>
:global(.p-sidebar-header) {
    justify-content: space-between;
}
</style>
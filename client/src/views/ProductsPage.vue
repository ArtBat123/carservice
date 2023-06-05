<template>
    <p-card class="p-2 flex-grow-1">
        <template #header>
            <div class="flex align-items-center justify-content-between">
                <div class="flex align-items-center">
                    <div class="text-6xl font-bold mr-4">Товары</div>
                    <p-button
                        @click="openCreateProduct"
                        label="Товар"
                        icon="pi pi-plus"
                        style="height: 40px; margin-right: 10px;"
                    />
                    <p-button
                        @click="groupFormDialog = true"
                        label="Группу"
                        icon="pi pi-plus"
                        style="height: 40px;"
                    />
                    <p-button
                        @click="uploadFile"
                        icon="pi pi-upload"
                        label="Скачать"
                        class="p-button-text ml-4"
                        v-tooltip.top="'Скачать excel файл'"
                    />
                    <p-file-upload
                        mode="basic"
                        name="products"
                        uploadIcon="pi pi-download"
                        :chooseLabel="'Загрузить'"
                        class="p-button-text primary hover:bg-indigo-50 hover:text-indigo-500"
                        v-tooltip.top="'Загрузить данные из excel файла'"
                        url="http://localhost:5000/api/download_products"
                        @upload="downloadFile"
                    />
                </div>
                <div>
                    <span class="p-input-icon-left ml-4">
                        <i class="pi pi-search"></i>
                        <p-input-text
                            v-model="filterObj['global'].value"
                            placeholder="Поиск"
                            class="p-inputtext-sm"
                        ></p-input-text>
                    </span>
                </div>
            </div>
        </template>
        <template #content>
            <div class="flex" style="height: 100%;">
                <p-tree
                    v-model:selectionKeys="selectionGroup"
                    :value="productsStore.groupsTree"
                    :selectionKeys="selectionGroup"
                    style="width: 500px; height: 100%; margin-right: 1px;"
                    selectionMode="single"
                    scrollHeight="100%"
                    @update:selectionKeys="updateSelectionGroup"
                >
                    <template #default="{node}">
                        <span @contextmenu.prevent="log(node.label)">{{ node.label }}</span>
                    </template>
                </p-tree>
                <p-data-table
                    v-model:contextMenuSelection="contextMenuSelection"
                    v-model:filters="filterObj"
                    :value="productsStore.productsList"
                    tableStyle="border: 1px solid #e4e4e4;"
                    style="width: 100%;"
                    @rowContextmenu="onRowContextMenu"
                >
                    <p-column field="name" header="Наименование" sortable></p-column>
                    <p-column field="producer" header="Производитель" sortable></p-column>
                    <p-column field="price" header="Цена" sortable></p-column>
                    <p-column field="count" header="Остаток" sortable></p-column>
                    <p-column field="vendorCode" header="Артикул"></p-column>
                </p-data-table>
            </div>
        </template>
    </p-card>
    <p-context-menu :model="menuModel" ref="cm" />
    <product-form
        v-model="visibleSidebar"
        :initialProduct="product"
    />
    <group-form-dialog
        v-model="groupFormDialog"
    />
    <p-dialog
        v-model:visible="deleteDialog"
        header="Подтверждение"
    >
        <div class="flex align-items-center">
            <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
            <span>Вы действительно хотите удалить?</span>
        </div>
        <template #footer>
            <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="deleteDialog = false"/>
            <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteProduct"/>
        </template>
    </p-dialog>
</template>
<script>
import GroupFormDialog from '@/components/products/GroupFormDialog.vue';
import ProductForm from '@/components/products/ProductForm.vue';
import { useProductsStore } from '@/store/products';
import { mapStores } from 'pinia';
import { FilterMatchMode } from 'primevue/api';
import * as xlsx from "xlsx";
import fileSaver from "file-saver"

export default {
    name: "ProductsPage",
    components: { ProductForm, GroupFormDialog },
    data() {
        return {
            visibleSidebar: false,
            selectionGroup: null,
            groupFormDialog: false,
            contextMenuSelection: null,
            deleteDialog: false,
            filterObj: {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            },
            menuModel: [
                { label: "Удалить", icon: "pi pi-fw pi-times", command: () => {this.deleteDialog = true} },
                { label: "Изменить", icon: "pi pi-pencil", command: () => this.openEditProduct() },
            ],
            product: null,
        };
    },
    methods: {
        updateSelectionGroup(selectionGroup) {
            const key = Object.keys(selectionGroup)[0];
            this.productsStore.selectedGroup = key;
            this.productsStore.getProductsByGroup();
        },
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        async deleteProduct() {
            await this.productsStore.deleteProducts(this.contextMenuSelection);
            this.productsStore.getProductsByGroup();
            this.deleteDialog = false;
        },
        openEditProduct() {
            this.product = this.contextMenuSelection;
            this.visibleSidebar = true;
        },
        openCreateProduct() {
            this.product = null;
            this.visibleSidebar = true;
        },
        downloadFile(e) {
            this.productsStore.getProductsByGroup();
        },
        uploadFile() {
            const worksheet = xlsx.utils.json_to_sheet(this.productsStore.productsList);
            const workbook = { Sheets: { data: worksheet }, SheetNames: ['data'] };
            const excelBuffer = xlsx.write(workbook, {
                bookType: 'xlsx',
                type: 'array'
            });
            this.saveAsExcelFile(excelBuffer, 'products');
        },
        async saveAsExcelFile(buffer, fileName) {
            let EXCEL_TYPE = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8';
            let EXCEL_EXTENSION = '.xlsx';
            const data = new Blob([buffer], {
                type: EXCEL_TYPE
            });

            fileSaver.saveAs(data, fileName + '_export_' + new Date().getTime() + EXCEL_EXTENSION);
        },
    },
    computed: {
        ...mapStores(useProductsStore),
    },
    async created() {
        await this.productsStore.getGroups();
        this.selectionGroup = {1: true};
        this.productsStore.getProductsByGroup();
    }
};
</script>
<style scoped>
:global(.p-treenode-content) {
    padding: 0 !important;
}
:global(.p-treenode) {
    padding: 0 !important;
}
:global(.p-tree) {
    padding: 0 !important;
}
</style>
<template>
    <div class="card">
        <p-toolbar>
            <template #start>
                <p-button
                    @click="addingDialog = true"
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
                        v-model="filterObj['global'].value"
                        placeholder="Поиск"
                    ></p-input-text>
                    <i
                        v-show="!!filterObj['global'].value"
                        class="pi pi-filter-slash cursor-pointer"
                        @click="initFilter"
                    ></i>
                </span>
            </template>
        </p-toolbar>
        <p-data-table
            :value="warehouseStore.warehouseItemList"
            v-model:selection="selectedItems"
            v-model:filters="filterObj"
            v-model:contextMenuSelection="contextMenuSelection"
            @rowContextmenu="onRowContextMenu"
        >
            <p-column selectionMode="multiple"></p-column>
            <p-column field="code" header="Code" :sortable="true"></p-column>
            <p-column field="count" header="Count" :sortable="true"></p-column>
            <p-column field="name" header="Name" :sortable="true"></p-column>
        </p-data-table>
        <p-context-menu :model="menuModel" ref="cm" />
        <p-dialog
            v-model:visible="addingDialog"
            class="p-fluid"
            header="Информация о товаре"
        >
            <div class="field">
                <label for="name">Название</label>
                <p-input-text
                    id="name"
                    required="true"
                    autofocus
                    v-model="currentItem.name"
                />
            </div>
            <div class="field">
                <label for="name">Количество</label>
                <p-input-text
                    id="name" 
                    required="true"
                    autofocus
                    v-model="currentItem.count"
                />
                <small class="p-error" v-if="submitted && !product.name">Name is required.</small>
            </div>
            <div class="field">
                <label for="range">Дата</label>
                <p-calendar
                    inputId="range"
                    v-model="currentItem.date"
                    selectionMode="range"
                    :manualInput="false"
                    dateFormat="dd.mm.yy"
                    :showIcon="true"
                    @date-select="log"
                />
            </div>
            <template #footer>
                <p-button
                    label="Cancel"
                    icon="pi pi-times"
                    class="p-button-text"
                    @click="addingDialog = false"
                ></p-button>
                <p-button
                    label="Save"
                    icon="pi pi-check"
                    class="p-button-text"
                    @click="save"
                ></p-button>
            </template>
        </p-dialog>

        <p-dialog
            v-model:visible="deleteItemsDialog"
            header="Подтверждение"
        >
            <div class="flex align-items-center">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span>Вы действительно хотите удалить выбранные элементы?</span>
            </div>
            <template #footer>
                <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="deleteItemsDialog = false"/>
                <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteSelectedItems"/>
            </template>
        </p-dialog>
    </div>
</template>

<script>
import { mapStores } from 'pinia';
import { useWarehouseStore } from '../store/warehouse';
import { FilterMatchMode } from 'primevue/api';

export default {
    name: "WarehousePage",

    data() {
        return {
            selectedItems: [],
            contextMenuSelection: null,
            deleteItemsDialog: false, // Удаление выбранных элементов
            deleteItemDialog: false,  // Удаление выбранного элемента, при помощи контекстного меню
            addingDialog: false,
            menuModel: [
                {label: 'Удалить', icon: 'pi pi-fw pi-times', command: () => this.deleteItem()}
            ],
            dates: [new Date(), null],
            currentItem: {
                code: null,
                name: "",
                count: null,
                date: null
            },
            filterObj: null,
        }
    },

    methods: {
        save() {
            if (!this.currentItem.code) {
                this.currentItem.code = this.warehouseStore.warehouseItemList.length;
            }
            this.warehouseStore.addWarehouseItem(this.currentItem);
            this.currentItem = {
                code: null,
                name: "",
                count: null,
                date: null
            };

            this.addingDialog = false;
        },
        deleteItem() {
            this.warehouseStore.deleteWarehouseItem(this.contextMenuSelection);
            this.deleteItemDialog = false;
        },
        deleteSelectedItems() {
            this.selectedItems.forEach(item => {
                this.warehouseStore.deleteWarehouseItem(item);
            });
            this.deleteItemsDialog = false;
        },
        initFilter() {
            this.filterObj = {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            };
        },
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        
    },

    computed: {
        ...mapStores(useWarehouseStore),
    },

    created() {
        this.initFilter();
    },
}
</script>


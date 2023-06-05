<template>
    <p-card class="p-2 flex-grow-1">
        <template #header>
            <div class="flex align-items-center justify-content-between">
                <div class="flex align-items-center">
                    <div class="text-6xl font-bold mr-4">Услуги</div>
                    <p-button
                        @click="openCreateService"
                        label="Услугу"
                        icon="pi pi-plus"
                        style="height: 40px; margin-right: 10px;"
                    />
                    <p-button
                        @click="groupFormDialog = true"
                        label="Группу"
                        icon="pi pi-plus"
                        style="height: 40px;"
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
                    :value="servicesStore.groupsTree"
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
                    :value="servicesStore.servicesList"
                    tableStyle="border: 1px solid #e4e4e4;"
                    style="width: 100%;"
                    @rowContextmenu="onRowContextMenu"
                >
                    <p-column field="name" header="Наименование" sortable></p-column>
                    <p-column field="price" header="Цена" sortable></p-column>
                </p-data-table>
            </div>
        </template>
    </p-card>
    <p-context-menu :model="menuModel" ref="cm" />
    <services-form
        v-model="visibleSidebar"
        :initialService="service"
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
            <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteService"/>
        </template>
    </p-dialog>
</template>
<script>
import GroupFormDialog from '@/components/services/GroupFormDialog.vue';
import ServicesForm from '@/components/services/ServicesForm.vue';
import { useServicesStore } from '@/store/services';
import { mapStores } from 'pinia';
import { FilterMatchMode } from 'primevue/api';

export default {
    name: "ServicesPage",
    components: { ServicesForm, GroupFormDialog },
    data() {
        return {
            visibleSidebar: false,
            selectionGroup: null,
            groupFormDialog: false,
            contextMenuSelection: null,
            filterObj: {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            },
            menuModel: [
                { label: "Удалить", icon: "pi pi-fw pi-times", command: () => {this.deleteDialog = true} },
                { label: "Изменить", icon: "pi pi-pencil", command: () => this.openEditService() },
            ],
            service: null,
            deleteDialog: false,
        };
    },
    methods: {
        updateSelectionGroup(selectionGroup) {
            const key = Object.keys(selectionGroup)[0];
            this.servicesStore.selectedGroup = key;
            this.servicesStore.getServicesByGroup();
        },
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        async deleteService() {
            await this.servicesStore.deleteService(this.contextMenuSelection);
            this.servicesStore.getServicesByGroup();
            this.deleteDialog = false;
        },
        openEditService() {
            this.service = this.contextMenuSelection;
            this.visibleSidebar = true;
        },
        openCreateService() {
            this.service = null;
            this.visibleSidebar = true;
        }
    },
    computed: {
        ...mapStores(useServicesStore),
    },
    async created() {
        await this.servicesStore.getGroups();
        this.selectionGroup = {1: true};
        this.servicesStore.getServicesByGroup();
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
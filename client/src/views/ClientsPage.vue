<template>
    <div class="card">
        <p-toolbar>
            <template #start>
                <div class="text-6xl font-bold mr-4">Клиенты</div>
                <p-button
                    @click="visibleSidebar = true"
                    label="Добавить"
                    icon="pi pi-plus"
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
            :value="clientsStore.clients"
            v-model:filters="filterObj"
            v-model:contextMenuSelection="contextMenuSelection"
            @rowContextmenu="onRowContextMenu"
        >
            <p-column field="fullName" header="ФИО" :sortable="true"></p-column>
            <p-column field="phone" header="Телефон" :sortable="true"></p-column>
            <p-column field="birthday" header="Дата рождения" :sortable="true"></p-column>
            <p-column field="cars" header="Автомобили">
                <template #body="{data}">
                    <p-chip v-for="car in data.cars" class="p-3 mr-2">
                        <div>
                            {{ car.brand + ' ' + car.model }} <br>
                            Номер: {{ car.number }}
                        </div>
                    </p-chip>
                </template>
            </p-column>
        </p-data-table>
        <p-context-menu :model="menuModel" ref="cm" />
        <p-dialog
            v-model:visible="deleteItemDialog"
            header="Подтверждение"
        >
            <div class="flex align-items-center">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span>Вы действительно хотите удалить сотрудника?</span>
            </div>
            <template #footer>
                <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="deleteItemDialog = false"/>
                <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteItem"/>
            </template>
        </p-dialog>
        <p-sidebar
            v-model:visible="visibleSidebar"
            :baseZIndex="10000"
            position="right"
            class="p-sidebar-md"
            @hide="closeClientForm"
        >
            <template #header>
                <h3 class="pl-3">Информация о клиенте</h3>
            </template>
            <client-form
                :initialClient="client"
                @close="closeClientForm"
            ></client-form>
        </p-sidebar>
    </div>
</template>

<script>
import { mapStores } from 'pinia';
import { useClientsStore } from '../store/clients';
import { FilterMatchMode } from 'primevue/api';
import ClientForm from '@/components/client/ClientForm.vue';

export default {
    name: "ClientsPage",
    components: { ClientForm },
    data() {
        return {
            contextMenuSelection: null,
            deleteItemDialog: false,
            menuModel: [
                { label: "Удалить", icon: "pi pi-fw pi-times", command: () => this.deleteItem() },
                { label: "Изменить", icon: "pi pi-pencil", command: () => this.openEditItem() },
            ],
            filterObj: null,
            visibleSidebar: false,
            client: null,
        };
    },
    methods: {
        closeClientForm() {
            this.visibleSidebar = false;
            this.client = null;
        },
        deleteItem() {
            this.clientsStore.deleteClient(this.contextMenuSelection);
            this.deleteItemDialog = false;
        },
        initFilter() {
            this.filterObj = {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            };
        },
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        openEditItem() {
            this.client = this.contextMenuSelection;
            this.visibleSidebar = true;
        },
    },
    computed: {
        ...mapStores(useClientsStore),
    },
    created() {
        this.initFilter();
        this.clientsStore.getClients();
    },
}
</script>



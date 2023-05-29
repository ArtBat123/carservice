<template>
    <div class="card">
        <p-toolbar>
            <template #start>
                <div class="text-6xl font-bold mr-4">Сотрудники</div>
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
                        class="p-inputtext-sm"
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
            :value="employeesStore.employees"
            v-model:filters="filterObj"
            v-model:contextMenuSelection="contextMenuSelection"
            @rowContextmenu="onRowContextMenu"
        >
            <template #header>
                <div style="text-align:left">
                    <p-multi-select
                        v-model="selectedColumns"
                        class="p-inputtext-sm"
                        :options="columns"
                        optionLabel="header"
                        placeholder="Выбрать столбцы"
                        :maxSelectedLabels="3"
                        selectedItemsLabel="{0} столбцов выбрано"
                    />
                </div>
            </template>
            <p-column
                v-for="col in selectedColumns"
                :field="col.field"
                :header="col.header"
                :sortable="true"
            >
                <template v-if="col.field === 'password'" #body="{data}">
                    <div class="flex align-items-center justify-content-between">
                        <span v-if="data.showPassword">{{ data.password }}</span>
                        <strong v-else>*******</strong>
                        <p-button
                            icon="pi pi-eye"
                            class="p-button-rounded p-button-text p-button-lg mr-2"
                            style="width: 40px; height: 40px"
                            @click="data.showPassword = !data.showPassword"
                        ></p-button>
                    </div>
                </template>
            </p-column>
        </p-data-table>
        <p-context-menu :model="menuModel" ref="cm" />
        <p-dialog
            v-model:visible="showDeleteDialog"
            header="Подтверждение"
        >
            <div class="flex align-items-center">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span>Вы действительно хотите удалить выбранных сотрудников?</span>
            </div>
            <template #footer>
                <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="showDeleteDialog = false"/>
                <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteEmployee"/>
            </template>
        </p-dialog>
        <p-sidebar
            v-model:visible="visibleSidebar"
            :baseZIndex="10000"
            position="right"
            class="p-sidebar-md"
            @hide="closeEmployeeForm"
        >
            <template #header>
                <h3 class="pl-3">Информация о клиенте</h3>
            </template>
            <employee-form
                :initial-employee="employee"
                @close="closeEmployeeForm"
            />
        </p-sidebar>
    </div>
</template>

<script>
import { mapStores } from 'pinia';
import { FilterMatchMode } from 'primevue/api';
import EmployeeForm from '@/components/employees/EmployeeForm.vue';
import { useEmployeesStore } from '@/store/employees';

export default {
    name: "EmployeesPage",

    components: {
        EmployeeForm,
    },
    data() {
        return {
            contextMenuSelection: null,
            showDeleteDialog: false,
            menuModel: [
                { label: "Удалить", icon: "pi pi-fw pi-times", command: () => this.openDeleteDialog() },
                { label: "Изменить", icon: "pi pi-pencil", command: () => this.openEditEmployee() },
            ],
            employee: null,
            filterObj: null,
            visibleSidebar: false,
            columns: [],
            selectedColumns: [],
        };
    },
    methods: {
        openDeleteDialog() {
            this.showDeleteDialog = true;
        },
        deleteEmployee() {
            this.employeesStore.deleteEmployee(this.contextMenuSelection);
            this.showDeleteDialog = false;
        },
        initFilter() {
            this.filterObj = {
                global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            };
        },
        onRowContextMenu(event) {
            this.$refs.cm.show(event.originalEvent);
        },
        openEditEmployee() {
            this.employee = this.contextMenuSelection;
            this.visibleSidebar = true;
        },
        closeEmployeeForm() {
            this.employee = null;
            this.visibleSidebar = false;
        }
    },
    computed: {
        ...mapStores(useEmployeesStore),
    },
    created() {
        this.initFilter();
        this.employeesStore.getEmployees();
        this.employeesStore.getPositions();
        this.columns = [
            { field: "fullName", header: "ФИО" },
            { field: "phone", header: "Телефон" },
            { field: "position.name", header: "Должность" },
            { field: "birthday", header: "Дата рождения" },
            { field: "login", header: "Логин" },
            { field: "password", header: "Пароль" },
            { field: "address", header: "Адрес" },
            { field: "employmentDate", header: "Дата устройства"},
        ],
        this.selectedColumns = this.columns;
    },
}
</script>
<style scoped>
:deep(.p-accordion-header-link) {
    background-color: var(--primary-50) !important;
    padding: 1rem;
}
:deep(.p-accordion-tab) {
    margin-bottom: 1rem;
    border: 1px solid var(--primary-200) !important;
}
</style>


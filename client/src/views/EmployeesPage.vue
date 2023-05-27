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
            :value="clientsStore.clients"
            v-model:selection="selectedItems"
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
            <p-column selectionMode="multiple"></p-column>
            <p-column
                v-for="col in selectedColumns"
                :field="col.field"
                :header="col.header"
                :sortable="true"
            >
                <template v-if="col.field === 'password'" #body="slotProps">
                    <div class="flex align-items-center">
                        <strong>*******</strong>
                        <p-button
                            icon="pi pi-eye"
                            class="p-button-rounded p-button-text p-button-lg mr-2"
                            style="width: 40px; height: 40px"
                        ></p-button>
                    </div>
                </template>
            </p-column>
        </p-data-table>
        <p-context-menu :model="menuModel" ref="cm" />
        <p-dialog
            v-model:visible="deleteItemsDialog"
            header="Подтверждение"
        >
            <div class="flex align-items-center">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span>Вы действительно хотите удалить выбранных сотрудников?</span>
            </div>
            <template #footer>
                <p-button label="Нет" icon="pi pi-times" class="p-button-text" @click="deleteItemsDialog = false"/>
                <p-button label="Да" icon="pi pi-check" class="p-button-text" @click="deleteSelectedItems"/>
            </template>
        </p-dialog>
        <p-sidebar
            v-model:visible="visibleSidebar"
            :baseZIndex="10000"
            position="right"
            class="p-sidebar-md"
        >
            <template #header>
                <h3 class="pl-3">Информация о клиенте</h3>
            </template>
            <div class="p-fluid">
                <div class="field">
                    <label for="lastName">Фамилия</label>
                    <p-input-text
                        id="lastName"
                        required="true"
                        autofocus
                        v-model="currentItem.lastName"
                    />
                </div>
                <div class="field">
                    <label for="firstName">Имя</label>
                    <p-input-text
                        id="firstName" 
                        required="true"
                        autofocus
                        v-model="currentItem.firstName"
                    />
                    <small class="p-error" v-if="submitted && !product.name">Name is required.</small>
                </div>
                <div class="field">
                    <label for="middleName">Отчество</label>
                    <p-input-text
                        id="middleName" 
                        required="true"
                        autofocus
                        v-model="currentItem.middleName"
                    />
                </div>
                <div class="field">
                    <label for="phone">Номер телефона</label>
                    <p-input-mask
                        date="phone"
                        v-model="currentItem.phone"
                        mask="+7(999)999-99-99"
                        placeholder="+7(918)000-00-00"
                    />
                </div>
                <div class="field">
                    <label for="birthday">Дата рождения</label>
                    <p-input-mask
                        date="birthday"
                        v-model="currentItem.birthday"
                        slotChar="dd.mm.yyyy"
                        mask="99.99.9999"
                        placeholder="dd.mm.yyyy"
                    />
                </div>
            </div>
            <div class="mb-2 flex align-items-center">
                <div>Автомобили</div>
                <p-button
                    v-if="!isVisibleAddingCar"
                    icon="pi pi-plus"
                    class="p-button-rounded p-button-text"
                    v-tooltip="'Добавить автомобиль'"
                    @click="isVisibleAddingCar = true"
                />
            </div>
            <div
                v-if="isVisibleAddingCar"
                style="border: 2px dashed var(--primary-200);"
                class="p-2 mb-2 flex"
            >
                <div class="flex flex-wrap gap-1">
                    <p-input-text
                        v-model="car.brand"
                        placeholder="Производиетель"
                    />
                    <p-input-text
                        v-model="car.model"
                        placeholder="Модель"
                    />
                    <p-input-text
                        v-model="car.number"
                        placeholder="Госномер"
                    />
                    <p-input-text
                        v-model="car.vin"
                        placeholder="VIN"
                    />
                </div>
                <div class="flex flex-column justify-content-between">
                    <p-button
                        icon="pi pi-plus"
                        class="p-button-rounded p-button-text"
                        v-tooltip.left="'Добавить автомобиль'"
                        @click="addCar"
                    ></p-button>
                    <p-button
                        icon="pi pi-trash"
                        class="p-button-rounded p-button-text"
                        v-tooltip.left="'Сбросить'"
                        @click="closeAddingCar"
                    ></p-button>
                </div>
            </div>
            <p-accordion>
                <p-accordion-tab
                    v-for="car in currentItem.cars"
                    :header="car.brand + car.model"
                    headerClass="accordion-tab-header"
                >
                    <div class="text-500 flex">
                        <div style="width: 150px;">Госномер:</div>
                        <div>{{ car.number }}</div>
                    </div>
                    <div class="text-500 flex">
                        <div style="width: 150px;">VIN:</div>
                        <div>{{ car.vin }}</div>
                    </div>
                </p-accordion-tab> 
            </p-accordion>
            <div>
                <p-button
                    label="Закрыть"
                    icon="pi pi-times"
                    class="p-button-text"
                    @click="visibleSidebar = false"
                ></p-button>
                <p-button
                    label="Сохранить"
                    icon="pi pi-check"
                    class="p-button-text"
                    @click="save"
                ></p-button>
            </div>
        </p-sidebar>
    </div>
</template>

<script>
import { mapStores } from 'pinia';
import { useClientsStore } from '../store/clients';
import { FilterMatchMode } from 'primevue/api';
import { toRaw } from 'vue';

export default {
    name: "EmployeesPage",

    data() {
        return {
            selectedItems: [],
            contextMenuSelection: null,
            deleteItemsDialog: false, // Удаление выбранных элементов
            deleteItemDialog: false,  // Удаление выбранного элемента, при помощи контекстного меню
            addingDialog: false,
            menuModel: [
                {label: 'Удалить', icon: 'pi pi-fw pi-times', command: () => this.deleteItem()},
                {label: 'Изменить', icon: 'pi pi-pencil', command: () => this.openEditItem()},
            ],
            dates: [new Date(), null],
            currentItem: {
                code: null,
                firstName: "",
                lastName: "",
                middleName: "",
                phone: null,
                birthday: "",
                cars: [],
                addedCars: [],
            },
            filterObj: null,
            visibleSidebar: false,
            isVisibleAddingCar: false,
            car: {},
            columns: [],
            selectedColumns: [],
        }
    },

    methods: {
        save() {
            this.clientsStore.saveClient(toRaw(this.currentItem));
            this.currentItem = {
                code: null,
                firstName: "",
                lastName: "",
                middleName: "",
                phone: null,
                birthday: "",
                cars: [],
                addedCars: [],
            };

            this.addingDialog = false;
            this.visibleSidebar = false;
        },
        deleteItem() {
            this.clientsStore.deleteClient(this.contextMenuSelection);
            this.deleteItemDialog = false;
        },
        deleteSelectedItems() {
            this.selectedItems.forEach(item => {
                this.clientsStore.deleteClient(item);
            });
            this.selectedItems = [];
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
        openEditItem() {
            this.visibleSidebar = true;
            this.currentItem = structuredClone(toRaw(this.contextMenuSelection));
            let phone = this.currentItem.phone.toString();
            this.currentItem.phone = `+7(${phone[1]}${phone[2]}${phone[3]})${phone[4]}${phone[5]}${phone[6]}-${phone[7]}${phone[8]}-${phone[9]}${phone[10]}`;
        },
        addCar() {
            const car = {code: null, ...this.car};
            this.currentItem.cars.push(car);
            if (this.currentItem.addedCars) {
                this.currentItem.addedCars.push(car);
            } else {
                this.currentItem.addedCars = [car];
            }
            this.closeAddingCar();
        },
        closeAddingCar() {
            this.car = {};
            this.isVisibleAddingCar = false;
        },
    },

    computed: {
        ...mapStores(useClientsStore),
    },

    created() {
        this.initFilter();
        this.columns = [
            {field: 'fullName', header: 'ФИО'},
            {field: 'phone',    header: 'Телефон'},
            {field: 'position', header: 'Должность'},
            {field: 'birthday', header: 'Дата рождения'},
            {field: 'login',    header: 'Логин'},
            {field: 'password', header: 'Пароль'},
            {field: 'adress',   header: 'Адрес'},
        ],
        this.selectedColumns = this.columns;
        this.clientsStore.clients = [
            {
                fullName: 'Петров Петр Петрович',
                phone: '79183855532',
                position: 'Администратор',
                birthday: '02.12.2001',
                login: 'petrov01',
                password: 'petrov01',
                adress: 'Краснодар, ул.Стасова д.10 кв. 112',
            },
            {
                fullName: 'Иванов Петр Петрович',
                phone: '79183855535',
                position: 'Администратор',
                birthday: '02.12.2001',
                login: 'petrov02',
                password: 'petrov02',
                adress: 'Краснодар, ул.Стасова д.10 кв. 113',
            },
            {
                fullName: 'Батрак Петр Петрович',
                phone: '79183855536',
                position: 'Мастер',
                birthday: '02.12.2001',
                login: 'petrov03',
                password: 'petrov03',
                adress: 'Краснодар, ул.Стасова д.10 кв. 111',
            },
            {
                fullName: 'Захаров Петр Петрович',
                phone: '79183855537',
                position: 'Мастер',
                birthday: '02.12.2001',
                login: 'petrov07',
                password: 'petrov07',
                adress: 'Краснодар, ул.Стасова д.10 кв. 117',
            }
        ]
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


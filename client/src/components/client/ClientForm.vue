<template>
    <div class="p-fluid">
        <div class="field">
            <div>Фамилия</div>
            <p-input-text
                autofocus
                v-model="client.lastName"
            />
        </div>
        <div class="field">
            <div>Имя</div>
            <p-input-text
                autofocus
                v-model="client.firstName"
            />
        </div>
        <div class="field">
            <div>Отчество</div>
            <p-input-text
                autofocus
                v-model="client.middleName"
            />
        </div>
        <div class="field">
            <div>Номер телефона</div>
            <p-input-mask
                date="phone"
                v-model="client.phone"
                mask="+7(999)999-99-99"
                placeholder="+7(918)000-00-00"
            />
        </div>
        <div class="field">
            <div>Дата рождения</div>
            <p-input-mask
                date="birthday"
                v-model="client.birthday"
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
            v-for="car in [...client.cars, ...addedCars]"
        >
            <template #header>
                <span>{{ car.brand + ' ' + car.model }}</span>
                <p-button
                    icon="pi pi-trash"
                    class="p-button-rounded p-button-text"
                    @click.stop="deleteCar(car)"
                ></p-button>
            </template>
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
            @click="$emit('close')"
        ></p-button>
        <p-button
            label="Сохранить"
            icon="pi pi-check"
            class="p-button-text"
            @click="saveClient"
        ></p-button>
    </div>
</template>
<script>
import Client from '@/model/Client';
import { useClientsStore } from '@/store/clients';
import { mapStores } from 'pinia';

export default {
    name: 'ClientForm',
    emits: ['close'],
    props: {
        initialClient: Object,
    },
    data() {
        return {
            client: new Client(),
            isVisibleAddingCar: false,
            car: {},
            addedCars: [],
            deletedCarsCode: [],
        };
    },
    methods: {
        async saveClient() {
            this.client.cars.push(...this.addedCars);
            this.client.addedCars = this.addedCars;
            this.client.deletedCarsCode = this.deletedCarsCode;
            await this.clientsStore.saveClient(this.client);
            this.addedCars = [],
            this.$emit('close');
        },
        closeAddingCar() {
            this.car = {};
            this.isVisibleAddingCar = false;
        },
        addCar() {
            this.addedCars.push({code: null, ...this.car});
            this.car = {};
            this.isVisibleAddingCar = false;
        },
        deleteCar(car) {
            if (car.code) {
                this.deletedCarsCode.push(car.code);
                this.client.cars = this.client.cars.filter(item => item.code !== car.code);
            } else {
                this.addedCars = this.addedCars.filter(item => item != car);
            }
        }
    },
    computed: {
        ...mapStores(useClientsStore),
    },
    created() {
        if (this.initialClient !== null) {
            this.client = new Client(this.initialClient);
        }
    }
};
</script>
<style scoped>
:deep(.p-accordion-header-link.p-accordion-header-action) {
    background-color: var(--primary-50) !important;
    padding: 14px;
}
:deep(.p-accordion-tab) {
    margin-bottom: 1rem;
    border: 1px solid var(--primary-200) !important;
}
</style>
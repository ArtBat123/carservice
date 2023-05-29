<template>
    <div class="p-fluid">
        <div class="field">
            <label>Фамилия</label>
            <p-input-text
                autofocus
                v-model="employee.lastName"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Имя</label>
            <p-input-text
                autofocus
                v-model="employee.firstName"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Отчество</label>
            <p-input-text
                autofocus
                v-model="employee.middleName"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Номер телефона</label>
            <p-input-mask
                v-model="employee.phone"
                mask="+7(999)999-99-99"
                placeholder="+7(918)000-00-00"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Логин</label>
            <p-input-text
                v-model="employee.login"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Должность</label>
            <p-dropdown
                v-model="employee.position"
                :options="employeesStore.positions"
                optionLabel="name"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Пароль</label>
            <p-password
                v-model="employee.password"
                toggle-mask 
                :feedback="false"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Дата рождения</label>
            <p-input-mask
                v-model="employee.birthday"
                slotChar="dd.mm.yyyy"
                mask="99.99.9999"
                placeholder="dd.mm.yyyy"
                class="p-inputtext-sm"
            />
        </div>
        <div class="field">
            <label>Адрес</label>
            <p-input-text
                v-model="employee.address"
                class="p-inputtext-sm"
            />
        </div>
    </div>
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
            @click="saveEmployee"
        ></p-button>
    </div>
</template>
<script>
import Employee from '@/model/Employee';
import { useEmployeesStore } from '@/store/employees';
import { mapStores } from 'pinia';

export default {
    name: 'EmployeeForm',
    props: {
        initialEmployee: Object,
    },
    emits: ['close'],
    data() {
        return {
            employee: new Employee(),
        };
    },
    methods: {
        saveEmployee() {
            console.log(this.employee);
            this.employeesStore.saveEmployee(this.employee);
            this.$emit('close');
        }
    },
    computed: {
        ...mapStores(useEmployeesStore),
    },
    created() {
        if (this.initialEmployee !== null) {
            this.employee = new Employee(this.initialEmployee);
        }
    }
};
</script>
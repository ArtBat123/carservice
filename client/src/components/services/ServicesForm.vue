<template>
    <p-sidebar
        :visible="modelValue"
        :baseZIndex="10000"
        position="right"
        class="p-sidebar-md"
        @update:visible="$emit('update:modelValue', e)"
        @hide="closeServicesForm"
    >
        <template #header>
            <h3 class="pl-3">Информация о услуге</h3>
        </template>
        <div class="p-fluid">
            <div class="field">
                <div>Наименование</div>
                <p-input-text
                    v-model="service.name"
                    autofocus
                />
            </div>
            <div class="field">
                <div>Группа</div>
                <p-tree-select 
                    v-model="service.serviceGroup"
                    :options="servicesStore.groupsTree"
                    scrollHeight="300px"
                />
            </div>
            <div class="field">
                <div>Цена</div>
                <p-input-number
                    v-model="service.price"
                    autofocus
                    suffix="₽"
                />
            </div>
            <div class="field">
                <div>Описание</div>
                <p-textarea
                    v-model="service.description"
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
                @click="saveService"
            />
        </div>
    </p-sidebar>
</template>
<script>
import { useServicesStore } from '@/store/services';
import { mapStores } from 'pinia';
import Service from "@/model/Service";
export default {
    name: 'ServicesForm',
    emits: ['update:modelValue'],
    props: {
        modelValue: Boolean,
        initialService: Object,
    },
    data() {
        return {
            service: new Service(),
        };
    },
    methods: {
        async saveService() {
            const service = {...this.service};
            service.serviceGroup = Number(Object.keys(service.serviceGroup)[0]);
            await this.servicesStore.saveService(service);
            this.$emit('update:modelValue', false);
            this.service = new Service();
            this.servicesStore.getServicesByGroup()
        },
        closeServicesForm() {
            this.service = new Service();
        }
    },
    watch: {
        initialService(newVal) {
            if (newVal) {
                this.service = new Service(newVal);
                const serviceGroup = {};
                serviceGroup[newVal.serviceGroupCode] = true
                this.service.serviceGroup = serviceGroup;
            } else {
                this.service = new Service();
            }
        }
    },
    computed: {
        ...mapStores(useServicesStore),
    },
};
</script>
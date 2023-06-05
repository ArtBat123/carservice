<template>
    <p-dialog
        :visible="modelValue"
        modal
        header="Группа"
        :style="{ width: '500px' }"
        @update:visible="$emit('update:modelValue', e)"
        @hide="clearForm"
    >
        <div
            style="display: flex; flex-direction: column;"
        >
            <p-input-text
                v-model="groupName"
                autofocus
                placeholder="Наименование группы"
                style="margin-bottom: 10px;"
            />
            <p-tree-select 
                v-model="selectedParentGroup"
                :options="productsStore.groupsTree"
                placeholder="Родительская группа"
                scrollHeight="300px"
            />
            <p-textarea
                v-model="description"
                style="margin-top: 10px;"
                placeholder="Описание группы"
            ></p-textarea> 
        </div>
        <div class="mt-4">
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
                @click="saveGroup"
            />
        </div>
    </p-dialog>
</template>
<script>
import { useProductsStore } from '@/store/products';
import { mapStores } from 'pinia';

export default {
    name: 'GroupFormDialog',
    emits: ['update:modelValue'],
    props: {
        modelValue: Boolean,
    },
    data() {
        return {
            selectedParentGroup: null,
            groupName: null,
            description: null,
        }
    },
    methods: {
        clearForm() {
            this.selectedParentGroup = null;
            this.groupName = null;
            this.description = null;
        },
        async saveGroup() {
            const parentGroup = Object.keys(this.selectedParentGroup)[0];
            const group = {
                parentGroup,
                name: this.groupName,
                description: this.description,
            };
            await this.productsStore.saveGroup(group);
            this.$emit('update:modelValue', false);
            await this.productsStore.getGroups();
        }
    },
    computed: {
        ...mapStores(useProductsStore)
    },
};
</script>
<style scoped>
</style>
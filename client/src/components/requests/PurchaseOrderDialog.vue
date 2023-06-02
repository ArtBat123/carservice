<template>
    <p-dialog
        :visible="modelValue"
        :closable="true"
        modal
        :style="{ width: '50vw', height: '80vh' }"
        @update:visible="$emit('update:modelValue', e)"
    >
        <p-tab-view style="height: 100%;">
            <p-tab-panel header="Основное">
                
            </p-tab-panel>
            <p-tab-panel header="Услуги">
                
            </p-tab-panel>
            <p-tab-panel header="Товары">
                
            </p-tab-panel>
            <p-tab-panel header="Акт осмотра">
                
            </p-tab-panel>
        </p-tab-view>
    </p-dialog>
</template>
<script>
export default {
    name: 'PurchaseOrderDialog',
    props: {
        modelValue: Boolean,
    },
    emits: ['update:modelValue'],
    data() {
        return {

        };
    },
};
</script>
<template>
    <p-sidebar
        v-model:visible="visibleMenu"
        :show-close-icon="false"
    >
        <template #header>
            <router-link to="/">
                <p-image
                    src="/src/assets/images/car-logo.png"
                    height="30"
                    style="filter: contrast(50%) sepia(100%) hue-rotate(190deg) brightness(0.8) saturate(500%);"
                >
                </p-image>
            </router-link>
        </template>
        <p-divider class="mt-0 mb-3"></p-divider>
        <p-panel-menu :model="items"></p-panel-menu>
    </p-sidebar>
</template>
<script>
import { mapWritableState } from 'pinia';
import { useLayoutStore } from '@/store/layout';
import menuItems from './menuItems.js';

export default {
    name: 'AppSidebar',
    data: () => ({
        items: menuItems,
    }),
    computed: {
        ...mapWritableState(useLayoutStore, ['visibleMenu']),
    },
};
</script>
<style scoped lang="scss">
:global(.p-sidebar .p-sidebar-header) {
    padding: 10px;
}
.p-panelmenu :deep(.p-panelmenu-panel) {
    box-shadow: none;
}
.p-panelmenu :deep(.p-panelmenu-content) {
    background: transparent;
}
.p-panelmenu :deep(.p-panelmenu-header .p-panelmenu-header-content) {
    background: transparent;
}
.p-panelmenu
    :deep(.p-panelmenu-header:not(.p-disabled).p-highlight
        .p-panelmenu-header-content) {
    background: transparent;
}
.p-panelmenu
    :deep(.p-panelmenu-header
        .p-panelmenu-header-content
        .p-panelmenu-header-action) {
    padding: 13px;
}
</style>

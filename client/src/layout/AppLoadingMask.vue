<template>
    <p-sidebar
        v-model:visible="getIsLoading"
        position="full"
        :show-close-icon="false"
        :modal="false"
        class="bg-black-alpha-30 align-items-center justify-content-center"
    >
        <p-progress-bar
            class="w-30rem"
            mode="indeterminate"
        ></p-progress-bar>
    </p-sidebar>
</template>

<script>
import { useLayoutStore } from '@/store/layout';
import { mapState } from 'pinia';
export default {
    name: 'AppLoadingMask',
    computed: {
        ...mapState(useLayoutStore, ['getIsLoading']),
    },
};
</script>

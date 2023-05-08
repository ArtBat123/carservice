<template>
    <router-view></router-view>
</template>
<script>
import ThemeSrv from '@/services/ThemeSrv.js';
import { useAppSettingsStore } from '@/store/appSettings';

export default {
    beforeCreate() {
        useAppSettingsStore().getAppSettings();
        ThemeSrv.loadTheme();
    },
}
</script>
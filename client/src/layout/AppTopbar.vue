<template>
    <p-toolbar class="p-0 px-3">
        <template #start>
            <div class="flex">
                <router-link to="/">
                    <p-image
                        src="/src/assets/images/car-logo.png"
                        alt="logo"
                        height="35"
                        style="filter: contrast(50%) sepia(100%) hue-rotate(190deg) brightness(0.8) saturate(500%);"
                    ></p-image>
                </router-link>
            </div>
            <p-button
                icon="pi pi-bars"
                class="p-button-rounded p-button-text p-button-plain p-button-lg ml-2"
                @click="visibleMenu = !visibleMenu"
            ></p-button>
        </template>

        <template #end>
            <p-button
                icon="mdi mdi-theme-light-dark"
                class="p-button-rounded p-button-text p-button-lg mr-2"
                style="width: 40px; height: 40px"
                @click="chooseTheme"
            ></p-button>
            <p-avatar
                icon="pi pi-user"
                class="mr-2"
                shape="circle"
            >
            </p-avatar>
            <span>Artem</span>
        </template>
    </p-toolbar>
</template>
<script>
import ThemeSrv from '@/services/ThemeSrv.js';
import { mapWritableState } from 'pinia';
import { useLayoutStore } from '@/store/layout';

export default {
    name: 'AppTopbar',
    components: {},
    data: () => ({
        // srcLogo: new URL('@/assets/images/logo_gavr.png', import.meta.url),
    }),
    methods: {
        chooseTheme() {
            ThemeSrv.changeTheme();
        },
    },
    computed: {
        ...mapWritableState(useLayoutStore, ['visibleMenu']),
    },
};
</script>

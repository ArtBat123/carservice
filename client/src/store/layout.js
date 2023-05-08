import { defineStore } from 'pinia';

export const useLayoutStore = defineStore('layout', {
    state: () => ({
        isLoading: 0,
        visibleMenu: true,
    }),

    getters: {
        getIsLoading(state) {
            return !!state.isLoading;
        },
    },

    actions: {
        setIsLoading(flag) {
            flag ? this.isLoading++ : this.isLoading--;
            if (this.isLoading < 0) this.isLoading = 0;
        },
    },
});
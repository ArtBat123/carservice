import ReqExec from "@/services/ReqExec";
import { defineStore } from "pinia";

export const useAppSettingsStore = defineStore('appStore', {
    state: () => ({
        appSettingsList: [],
    }),

    actions: {
        async getAppSettings() {
            this.appSettingsList = await ReqExec.get('rpc/web_app_setting_api/get_settings');
        },
    }
});

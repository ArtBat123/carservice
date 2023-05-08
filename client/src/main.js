import { createApp } from 'vue';
import { createPinia } from 'pinia';

import App from './App.vue';
import router from './router'
import regPrimeVue from './vendor/primevue.js';

import '@/styles/main.scss'
import 'primevue/resources/primevue.min.css';
import 'primeflex/primeflex.css';
import 'primeicons/primeicons.css';
import '@/assets/css/materialdesignicons.min.css';

const app = createApp(App);
app.use(createPinia());
app.use(router);
regPrimeVue(app);
app.mount('#app');

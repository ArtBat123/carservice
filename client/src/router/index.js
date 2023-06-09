import { createRouter, createWebHashHistory } from 'vue-router';
import HomePage from '@/views/HomePage.vue';
import AppLayout from '@/layout/AppLayout.vue';
import { useLayoutStore } from '@/store/layout';

const HomeRouteItem = {
    path: '/',
    name: 'home',
    component: HomePage,
};

const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/:catchAll(.*)',
            redirect: '/',
        },
        {
            path: '/',
            component: AppLayout,
            children: [
                HomeRouteItem,
                {
                    path: '/warehouse',
                    name: 'warehouse',
                    component: () => import('@/views/WarehousePage.vue'),
                },
                {
                    path: '/products-and-categories',
                    name: 'productsAndCategories',
                    component: () => import('@/views/ProductsAndCategories.vue'),
                },
                {
                    path: '/orders',
                    name: 'orders',
                    component: () => import('@/views/OrdersPage.vue'),
                },
                {
                    path: '/clients',
                    name: 'clients',
                    component: () => import('@/views/ClientsPage.vue'),
                },
                {
                    path: '/auth',
                    name: 'auth',
                    component: () => import('@/views/AuthPage.vue'),
                },
                {
                    path: '/employees',
                    name: 'employees',
                    component: () => import('@/views/EmployeesPage.vue'),
                },
                {
                    path: '/settings',
                    name: 'settings',
                    component: () => import('@/views/SettingsPage.vue'),
                },
                {
                    path: '/services',
                    name: 'services',
                    component: () => import('@/views/ServicesPage.vue'),
                },
                {
                    path: '/products',
                    name: 'products',
                    component: () => import('@/views/ProductsPage.vue'),
                },
            ]
        }
    ]
});

router.afterEach((to) => {
    const layoutStore = useLayoutStore();
    // Скрыть меню, если не домашняя страница
    layoutStore.visibleMenu = to.name === HomeRouteItem.name;
});

export default router;
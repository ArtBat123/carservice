export default [
    {
        key: 'orders',
        label: 'Заявки',
        icon: 'pi pi-phone',
        to: '/orders'
    },
    {
        key: 'menuItemTables',
        label: 'Склад',
        icon: 'pi pi-box',
        to: '/products'
    },
    {
        key: 'menuItemTables',
        label: 'Справочники',
        icon: 'pi pi-book',
        items: [
            {
                label: 'Клиенты',
                to: '/clients',
            },
            {
                label: 'Сотрудники',
                to: '/employees'
            },
            {
                label: 'Услуги',
                to: '/services'
            }
        ],
    },
    {
        key: 'settings',
        label: 'Параметры',
        icon: 'pi pi-cog',
        to: '/settings'
    }
];

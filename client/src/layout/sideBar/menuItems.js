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
        items: [
            {
                label: 'Остатки',
                to: '/warehouse',
            },
            {
                label: 'Инвентаризации',
                to: '/fileupload',
            },
            {
                label: 'Оприходования',
                to: '/excel',
            },
            {
                label: 'Товары и категории',
                to: '/products-and-categories',
            },
        ],
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
        ],
    },
];

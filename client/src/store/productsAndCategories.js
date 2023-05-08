import { defineStore } from 'pinia';
import { flatForProperty } from '../utils/flatForProperty'

export const useProductsAndCategoriesStore = defineStore('productsAndCategories', {
    state: () => ({
        categoriesList: [],
        productsList: [],
    }),

    getters: {
        categoriesChoosing() {
            return flatForProperty(this.categoriesList, 'children');
        }
    },

    actions: {
        addCategory(item) {
            let categories = flatForProperty(this.categoriesList, 'children');
            let parentCategory = categories.find(category => item.parentCategoryKey == category.key);

            const newCategory = {
                key: parentCategory.key + 10,
                data: {
                    сategory: item.name,
                    quantity: 0,
                }
            };

            if (parentCategory.children)
                parentCategory.children.push(newCategory);
            else
                parentCategory.children = [newCategory];
        },

        addProduct(item) {
            let newProduct = {
                ...item,
                id: this.productsList.length + 1
            }
            this.productsList.push(newProduct);
        },

        getProducts() {
            this.productsList = [
                {
                    id: 1,
                    vendorСode: 'ads',
                    code: 1,
                    barcode: 12,
                    name: 'asddas'
                },
                {
                    id: 2,
                    vendorСode: 'ads',
                    code: 1,
                    barcode: 12,
                    name: 'asddas'
                }
            ];
        }
    },
});
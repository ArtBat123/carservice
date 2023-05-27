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
                    vendorСode: '643−2-BLK',
                    name: 'Летние шины PIRELLI CINTURATO P7',
                    count: 21
                },
                {
                    id: 2,
                    vendorСode: '443−2-BLK',
                    name: 'Летние шины KUMHO ES31',
                    count: 21
                }
            ];
        }
    },
});
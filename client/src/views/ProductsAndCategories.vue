<template>
    <div class="card">
        <p-splitter class="mb-5">
            <p-splitter-panel>
                <categories-panel></categories-panel>
            </p-splitter-panel>
            <p-splitter-panel>
                <products-panel></products-panel>
            </p-splitter-panel>
        </p-splitter>
    </div>
</template>

<script>
import CategoriesPanel from "@/components/productsAndCategories/CategoriesPanel.vue";
import ProductsPanel from "@/components/productsAndCategories/ProductsPanel.vue";


export default {
    name: "ProductsAndCategories",

    components: {
        CategoriesPanel,
        ProductsPanel
    },
}
</script>


export default class WarehouseItem {
    
    code;
    name;
    count;
    priceSale;
    priceBuy;

    constructor(item) {
        this.code = item?.code ?? null;
        this.name = item?.name ?? null;
        this.count = item?.count ?? null;
        this.priceSale = item?.priceSale ?? null;
        this.priceBuy = item?.priceBuy ?? null;
    }
}
export default class Product {
    
    code;
    name;
    producer;
    productGroup;
    price;
    description;
    count;
    vendorCode;

    constructor(item) {
        this.code           = item?.code          ?? null;
        this.name           = item?.name          ?? null;
        this.producer       = item?.producer      ?? null;
        this.productGroup   = item?.productGroup  ?? null;
        this.price          = item?.price         ?? null;
        this.description    = item?.description   ?? null;
        this.count          = item?.count         ?? 0;
        this.vendorCode     = item?.vendorCode    ?? null;
    }
}
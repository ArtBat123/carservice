export default class Service {
    
    code;
    name;
    serviceGroup;
    price;
    description;

    constructor(item) {
        this.code           = item?.code          ?? null;
        this.name           = item?.name          ?? null;
        this.serviceGroup   = item?.serviceGroup  ?? null;
        this.price          = item?.price         ?? null;
        this.description    = item?.description   ?? null;
    }
}
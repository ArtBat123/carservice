export default class Client {
    
    code;
    firstName;
    lastName;
    middleName;
    birthday;
    phone;
    createDate;
    cars;

    constructor(item) {
        this.code           = item?.code           ?? null;
        this.firstName      = item?.firstName      ?? null;
        this.lastName       = item?.lastName       ?? null;
        this.middleName     = item?.middleName     ?? null;
        this.fullName       = `${this.lastName} ${this.firstName} ${this.middleName}`;
        this.birthday       = item?.birthday       ?? null;
        this.phone          = item?.phone          ?? null;
        this.createDate     = item?.createDate     ?? null;
        this.cars           = item?.cars           ?? [];
    }
}
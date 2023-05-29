export default class Employee {
    
    code;
    firstName;
    lastName;
    middleName;
    birthday;
    phone;
    employmentDate;
    dismissalDate;
    login;
    password;
    address;
    position;
    salary;
    fullName;
    showPassword;

    constructor(item) {
        this.code           = item?.code           ?? null;
        this.firstName      = item?.firstName      ?? null;
        this.lastName       = item?.lastName       ?? null;
        this.middleName     = item?.middleName     ?? null;
        this.fullName       = `${this.lastName} ${this.firstName} ${this.middleName}`;
        this.birthday       = item?.birthday       ?? null;
        this.phone          = item?.phone          ?? null;
        this.employmentDate = item?.employmentDate ?? null;
        this.dismissalDate  = item?.dismissalDate  ?? null;
        this.login          = item?.login          ?? null;
        this.password       = item?.password       ?? null;
        this.position       = item?.position       ?? null;
        this.address        = item?.address        ?? null;
        this.showPassword   = false;
    }
}
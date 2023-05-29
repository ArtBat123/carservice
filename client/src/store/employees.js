import { defineStore } from 'pinia';
import ReqExec from '@/services/ReqExec';
import Employee from '@/model/Employee';
import { parsPhoneNumber } from '@/utils/utils';
import { dateToDayString } from '@/utils/DateUtils';

export const useEmployeesStore = defineStore('employees', {
    state: () => ({
        /**
         * @type {Array.<Employee>}
         */
        employees: [],
        positions: [],
    }),

    getters: {
        
    },

    actions: {
        async getEmployees() {
            const response = await ReqExec.get('rpc/web_employee_api/get_employees');
            this.employees = response.map(item => new Employee(item));
        },
        async getPositions() {
            this.positions = await ReqExec.get('rpc/web_employee_api/get_positions');
        },
        async saveEmployee(data) {
            const employee = new Employee(data);
            employee.phone = parsPhoneNumber(data.phone);
            const response = await ReqExec.post('rpc/web_employee_api/save_employee', employee);
            if (data.code) {
                const foundEmployeeIndex = this.employees.findIndex(item => item.code === data.code);
                this.employees[foundEmployeeIndex] = employee;
            } else {
                employee.code = response.code;
                employee.employmentDate = dateToDayString(new Date());
                this.employees.push(employee);
            }
        },
        async deleteEmployee(employee) {
            await ReqExec.delete('rpc/web_employee_api/delete_employee', {code: employee.code});
            this.employees = this.employees.filter(item => item.code !== employee.code);
        }
    },
});
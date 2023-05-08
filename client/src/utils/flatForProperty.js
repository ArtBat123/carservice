export function flatForProperty(array, propertyArray) {
    return array.reduce((acc, val) => {
        acc.push(val);
        if (val[propertyArray]) {
            acc = acc.concat(flatForProperty(val[propertyArray], propertyArray))
        }
        return acc;
    }, []) 
}

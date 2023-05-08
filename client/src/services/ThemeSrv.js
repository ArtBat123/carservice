import StorageSrv from './StorageSrv.js';
/**
 * Служба для работы с темой приложения
 * Запоминает выбранную тему с использование StorageSrv
 *
 */
const themeWhiteUrl = new URL(
    'primevue/resources/themes/md-light-indigo/theme.css',
    import.meta.url
).href;
const themeDarkUrl = new URL(
    'primevue/resources/themes/md-dark-indigo/theme.css',
    import.meta.url
).href;

const THEME_KEY = 'CURRENT_THEME';

class ThemeSrv {
    isDark;
    constructor() {
        this.isDark = StorageSrv.get(THEME_KEY) ?? false;
    }
    /**
     * Меняет тему
     */
    changeTheme() {
        this.isDark = !this.isDark;
        StorageSrv.set(THEME_KEY, this.isDark);
        this.loadTheme();
    }
    /**
     * Загружает выбранную тему
     */
    loadTheme() {
        const elementId = 'theme-css';
        const linkElement = document.getElementById(elementId);
        const cloneLinkElement = linkElement.cloneNode(true);
        const newThemeUrl = this.isDark ? themeDarkUrl : themeWhiteUrl;
        cloneLinkElement.setAttribute('id', elementId + '-clone');
        cloneLinkElement.setAttribute('href', newThemeUrl);
        cloneLinkElement.addEventListener('load', () => {
            linkElement.remove();
            cloneLinkElement.setAttribute('id', elementId);
        });
        linkElement.parentNode.insertBefore(
            cloneLinkElement,
            linkElement.nextSibling
        );
    }
}

export default new ThemeSrv();

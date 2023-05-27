<template>
    <div class="flex justify-content-center align-items-center h-full">
        <p-card style="width: 50%; height: 50%; padding: 50px;" class="flex flex-column align-items-center justify-content-center">
            <template #title>
                <div class="flex justify-content-center">Вход в систему</div>
            </template>
            <template #content>
                <div class="flex flex-column align-items-center justify-content-center">
                    <div style="width: 500px;">
                        <p-input-text
                            style="width: 100%;"
                            v-model="login"
                            type="text"
                            placeholder="Логин"
                        />
                    </div>
                    <div style="width: 500px; margin-top: 10px;">
                        <p-password
                            v-model="password"
                            style="width: 100%;"
                            :inputStyle="{width: '100%'}"
                            :feedback="false"
                            placeholder="Пароль"
                        />
                    </div>
                </div>
            </template>
        </p-card>
    </div>
</template>
<script>
export default {
    name: 'AuthPage',
    data() {
        return {
            password: null,
            login: null,
        }
    },
};
</script>
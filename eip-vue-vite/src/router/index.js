import {createRouter, createWebHashHistory} from "vue-router";
import {empStore} from "../stores/employee.js";
import {mallStore} from "../stores/mallStore.js";

const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/',
            component: () => import('@/views/Index.vue'),
            name: 'index',
            meta: {requiresAuth: true},
            children: [
                {
                    path: '/manage/attendance',
                    component: () => import('@/views/clocktime/manageviews/AttendanceStatus.vue'),
                    name: 'attendance',
                },
                {
                    path: '/manage/clocktime',
                    component: () => import('@/views/clocktime/manageviews/ClocktimeStatus.vue'),
                    name: 'clockTime',
                },
                {
                    path: '/user/attendance',
                    component: () => import('@/views/clocktime/userviews/UserAttendanceStatus.vue'),
                    name: 'userAttendance',
                },
                {
                    path: '/user/clocktime',
                    component: () => import('@/views/clocktime/userviews/UserClocktimeStatus.vue'),
                    name: 'userClockTime',
                }
            ]
        },
        {
            path: '/login',
            component: () => import('@/views/Login.vue'),
            name: 'login',
        },
        {
            path: '/forget',
            component: () => import('@/views/ForgetPassword.vue'),
            name: 'forget',
        },
        {
            path: '/new-password',
            component: () => import('@/views/NewPassword.vue'),
            name: 'new-password'
        },
        {
            path: '/mall/manage',
            component: () => import('@/views/mallviews/manageviews/MallManage.vue'),
            name: 'mall-manage',
            children: [
                {
                    path: '/mall/manage/product',
                    component: () => import('@/views/mallviews/manageviews/Products.vue'),
                    name: 'product'
                },
                {
                    path: '/mall/manage/product/save',
                    component: () => import('@/views/mallviews/manageviews/ProductForm.vue'),
                    name: 'product-save'
                },
                {
                    path: '/mall/manage/order',
                    component:()=>import('@/views/mallviews/manageviews/OrderManage.vue'),
                    name:'mall-manage-order'
                }
            ]
        },
        {
            path: '/mall',
            component: () => import('@/views/mallviews/userviews/MallIndex.vue'),
            children: [
                {
                    path: '/mall/order',
                    component: () => import('../views/mallviews/userviews/UserOrder.vue'),
                    name: 'mall-order'
                },
            ]
        },
        {
            path: '/order/create',
            component: () => import('../views/mallviews/userviews/CreateOrder.vue'),
            name: 'create-order'
        },

    ]
})

router.beforeEach((to, form, next) => {
    const store = empStore();
    if (to.matched.some(record => record.meta.requiresAuth)) {
        const isLogin = store.isLogin;
        if (isLogin || sessionStorage.getItem('isLogin')) {
            next();
        } else {
            next({name: 'login'})
        }
    } else {
        next();
    }
})
router.beforeEach((to, from) => {
    const mall = mallStore();
    if (from.path === '/mall/order') {
        mall.setChangeOrderPage(false)
    }
})
export default router;
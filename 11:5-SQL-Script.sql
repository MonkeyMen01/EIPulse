#合併專用 code 11/5 OK
create table if not exists dept
(
    dept_id     int auto_increment
        primary key,
    dept_name   varchar(255) not null,
    dept_office varchar(255) not null
);

create table if not exists form_status
(
    status_id   int auto_increment
        primary key,
    Description varchar(255) null
);

create table if not exists form_type
(
    Type_id   int auto_increment
        primary key,
    Type_name varchar(255) null
);

create table if not exists leave_type
(
    id     int auto_increment
        primary key,
    days   int           null,
    type   varchar(20)   not null,
    status int default 1 null,
    remark varchar(200)  null
);

create table if not exists office_regions
(
    regions_id   int auto_increment
        primary key,
    latitude     double      not null,
    longitude    double      not null,
    regions_name varchar(20) not null
);

create table if not exists overtime_type
(
    id   int auto_increment
        primary key,
    type varchar(10) not null
);

create table if not exists permission
(
    permission_id        int auto_increment
        primary key,
    permission_name      varchar(50)  not null,
    permission_statement varchar(255) not null
);

create table if not exists product_type
(
    type_id   int auto_increment
        primary key,
    type_name varchar(30) not null
);

create table if not exists sub_type
(
    sub_type_id     int auto_increment
        primary key,
    product_type_id int         not null,
    sub_name        varchar(20) not null,
    constraint sub_type_product_type_type_id_fk
        foreign key (product_type_id) references product_type (type_id)
);

create table if not exists product
(
    product_id     int auto_increment
        primary key,
    product_name   varchar(30)                        not null,
    sub_type_id    int                                not null,
    description    varchar(50)                        null,
    price          int                                not null,
    stock_quantity int                                not null,
    image_url      varchar(255)                       null,
    created_at     datetime default CURRENT_TIMESTAMP null,
    updated_at     datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    status         varchar(20)                        not null,
    constraint product_sub_type_sub_type_id_fk
        foreign key (sub_type_id) references sub_type (sub_type_id)
);

create table if not exists title
(
    title_id   int auto_increment
        primary key,
    title_name varchar(50) not null,
    dept_id    int         not null,
    constraint title_dept_dept_id_fk
        foreign key (dept_id) references dept (dept_id)
);

create table if not exists employee
(
    emp_id     int auto_increment
        primary key,
    emp_name   varchar(50)                        not null,
    birth      date                               not null,
    password   varchar(255)                       not null,
    email      varchar(100)                       not null,
    emp_line_id varchar(255)                     null,
    id_number  varchar(50)                        not null,
    gender     varchar(10)                        not null,
    phone      varchar(20)                        not null,
    tel        varchar(50)                        null,
    photo_url  varchar(255)                       null,
    address    varchar(100)                       not null,
    title_id   int                                not null,
    hire_date  date                               null,
    leave_date date                               null,
    edit_date  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    emp_state  varchar(50)                        not null,
    constraint employee_title_title_id_fk
        foreign key (title_id) references title (title_id)
)auto_increment=1000;

create table if not exists attendance
(
    attendance_id    int auto_increment
        primary key,
    date             date                 not null,
    emp_id           int                  not null,
    total_hours      decimal(4, 2)        not null,
    is_late          tinyint(1) default 0 not null,
    is_early_leave   tinyint(1) default 0 not null,
    is_hours_not_met tinyint(1) default 0 not null,
    is_over_time     tinyint(1) default 0 not null,
    constraint attendance_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists cart
(
    cart_id    int auto_increment
        primary key,
    emp_id     int                                not null,
    created_at datetime default CURRENT_TIMESTAMP null,
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint shopping_cart_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists cart_item
(
    cart_item_id int auto_increment
        primary key,
    cart_id      int                                not null,
    product_id   int                                not null,
    quantity     int                                not null,
    created_at   datetime default CURRENT_TIMESTAMP null,
    updated_at   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint cart_item_product_product_id_fk
        foreign key (product_id) references product (product_id),
    constraint cart_item_shopping_cart_cart_id_fk
        foreign key (cart_id) references cart (cart_id)
);

create table if not exists clock_time
(
    clock_time_id int auto_increment
        primary key,
    emp_id        int         not null,
    time          datetime    not null,
    type          varchar(10) not null,
    regions_id    int         null,
    constraint clock_time_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id),
    constraint clock_time_office_regions_regions_id_fk
        foreign key (regions_id) references office_regions (regions_id)
);

create table if not exists form_record
(
    form_id          int auto_increment
        primary key,
    emp_id           int         null,
    type_id          int         null,
    end_date         datetime(6) null,
    start_date       datetime(6) null,
    status_id        int         null,
    termination_date datetime(6) null,
    constraint form_record_ibfk_1
        foreign key (type_id) references form_type (Type_id),
    constraint form_record_ibfk_2
        foreign key (emp_id) references employee (emp_id),
    constraint form_record_ibfk_3
        foreign key (status_id) references form_status (status_id)
);

create table if not exists apply_leave
(
    form_id    int          not null
        primary key,
    type       int          not null,
    reason     varchar(200) null,
    days       int          not null,
    hours      int          not null,
    start_time datetime     not null,
    file       longblob     null,
    constraint apply_leave_ibfk_1
        foreign key (form_id) references form_record (form_id),
    constraint apply_leave_ibfk_2
        foreign key (type) references leave_type (id)
);

create index type
    on apply_leave (type);

create table if not exists apply_overtime
(
    form_id    int          not null
        primary key,
    type       int          not null,
    reason     varchar(200) null,
    date       date         not null,
    start_time time         not null,
    end_time   time         not null,
    file       longblob     null,
    constraint apply_overtime_ibfk_1
        foreign key (form_id) references form_record (form_id),
    constraint apply_overtime_ibfk_2
        foreign key (type) references overtime_type (id)
);

create index type
    on apply_overtime (type);

create table if not exists form_eventlog
(
    event_id   int auto_increment
        primary key,
    form_id    int         null,
    end_date   datetime(6) null,
    start_date datetime(6) null,
    head_count int         null,
    sequence   int         null,
    status_id  int         null,
    constraint form_eventlog_ibfk_1
        foreign key (status_id) references form_status (status_id),
    constraint form_eventlog_ibfk_2
        foreign key (form_id) references form_record (form_id)
);

create table if not exists form_audit_eventlog
(
    event_id    int auto_increment
        primary key,
    eventLog_id int          null,
    auditor     int          null,
    message     varchar(255) null,
    end_date    datetime(6)  null,
    status_id   int          null,
    constraint form_audit_eventlog_ibfk_1
        foreign key (status_id) references form_status (status_id),
    constraint form_audit_eventlog_ibfk_2
        foreign key (auditor) references employee (emp_id),
    constraint form_audit_eventlog_ibfk_3
        foreign key (eventLog_id) references form_eventlog (event_id)
);

create index auditor
    on form_audit_eventlog (auditor);

create index eventLog_id
    on form_audit_eventlog (eventLog_id);

create index status_id
    on form_audit_eventlog (status_id);

create index form_id
    on form_eventlog (form_id);

create index status_id
    on form_eventlog (status_id);

create index emp_id
    on form_record (emp_id);

create index status_id
    on form_record (status_id);

create index type_id
    on form_record (type_id);

create table if not exists `order`
(
    order_id    int auto_increment
        primary key,
    emp_id      int                                not null,
    total_price int                                null,
    status      varchar(10)                        null,
    created_at  datetime default CURRENT_TIMESTAMP null,
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint order_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists order_item
(
    order_item_id int auto_increment
        primary key,
    order_id      int not null,
    product_id    int not null,
    quantity      int not null,
    total_price   int not null,
    constraint order_item_order_order_id_fk
        foreign key (order_id) references `order` (order_id),
    constraint order_item_product_product_id_fk
        foreign key (product_id) references product (product_id)
);

create table if not exists permission_info
(
    id            int auto_increment
        primary key,
    emp_id        int not null,
    permission_id int not null,
    constraint permission_info_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id),
    constraint permission_info_permission_permission_id_fk
        foreign key (permission_id) references permission (permission_id)
);

create table if not exists permission_move
(
    id                     int auto_increment
        primary key,
    emp_id                 int                                not null,
    before_permission_name varchar(50)                        not null,
    after_permission_name  varchar(50)                        not null,
    reason                 varchar(255)                       not null,
    effect_date            date                               null,
    approver               varchar(50)                        null,
    edit_date              datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint permission_move_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists resign_record
(
    resign_id     int auto_increment
        primary key,
    emp_id        int                                not null,
    reason        varchar(255)                       not null,
    leave_date    date                               null,
    approver      varchar(50)                        null,
    edit_date     datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    quit          tinyint(1)                         null,
    transfer_form tinyint(1)                         null,
    constraint emp_id
        unique (emp_id),
    constraint resign_record_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists title_move
(
    id               int auto_increment
        primary key,
    emp_id           int                                not null,
    before_dept_info varchar(255)                       not null,
    after_dept_info  varchar(255)                       not null,
    reason           varchar(50)                        not null,
    effect_date      date                               null,
    approver         varchar(20)                        null,
    edit_date        datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint title_move_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);


insert into dept ( dept_name, dept_office)
values  ( '人事管理', 'A01'),
        ( '公關部', 'B02'),
        ( '行銷部', 'C03'),
        ( '財務部', 'D04'),
        ( '研發部', 'E05'),
        ( '客服部', 'F06'),
        ( '採購部', 'G07'),
        ( '生產部', 'H08'),
        ( '品質保證部', 'I09'),
        ( '物流部', 'J10');

insert into form_status ( Description)
values  ( '審核中'),
        ( '已批准'),
        ( '已拒絕'),
        ( '待處理'),
        ( '已關閉'),
        ( '已撤回');

insert into form_type ( Type_name)
values  ( '請假'),
        ( '加班'),
        ( '離職'),
        ( '出差');

insert into leave_type ( days, type, status, remark)
values  ( 3, '半年特休', 1, '半年3天'),
        ( 4, '一年特休', 1, '滿一年多四天'),
        ( 3, '半薪病假', 1, '超過3天都為事假'),
        ( 12, '生理假', 2, '人家是女生耶'),
        ( 30, '事假', 1, ''),
        ( 7, '婚假', 1, ''),
        ( 7, '喪假', 1, ''),
        ( 30, '產假', 2, '人家是女生耶');

insert into office_regions ( latitude, longitude, regions_name)
values
    ( 22.993460934548654, 120.22674896027664, '路易莎東安店'),
    ( 22.99494490872267, 120.21791221990024, '路易莎勝利店'),
    ( 22.99944417097877, 120.21594456761729, '成大唯農分公司'),
    ( 23.008144102678692, 120.21331863796566, '台南公園總圖'),
    ( 23.02741940760638, 120.23923950479475, '台南新總圖');

insert into overtime_type ( type)
values  ( '平日'),
        ( '休息日'),
        ( '國定假日或特別休假'),
        ( '例假');

insert into permission ( permission_name, permission_statement)
values  ( '計時人員', '允許讀取個人資料'),
        ( '正職人員', '允許讀取個人資料'),
        ( '部門主管', '允許簽核資料'),
        ( '人事經理', '允許管理員工資料'),
        ( '系統測試員', '允許管理系統設定'),
        ( '超級管理員', '允許管理系統設定');

insert product_type ( type_name)
values  ( '票券');

insert into sub_type ( product_type_id, sub_name)
values  ( 1, '電影票'),
        ( 1, '餐券'),
        ( 1, '商品卡'),
        ( 1, '旅遊券');

insert into product ( product_name, sub_type_id, description, price, stock_quantity, image_url,status)
values  ( '西提牛排套餐券', 2, '適用於西提', 710, 16, 'https://i1.momoshop.com.tw/1692455303/goodsimg/0011/276/551/11276551_R.jpg', '上架'),
        ( '7-11 500元禮品卡', 3, '適用全台7-11', 450, 20, 'https://img.sopower.com.tw/image/20200722/20200722132116_95880.jpg',  '上架'),
        ( '威秀影城電影票', 1, '適用威秀影城', 270, 20, 'https://shoplineimg.com/5cc3db30527c4b0001a30cf0/5d99afc7916861001a6fec00/800x.webp?source_format=jpg', '下架'),
        ( '漢來海港平日晚餐券', 2, '適用於南部漢來海港', 1020, 20, 'https://cs-a.ecimg.tw/items/DBCRNFA900GI4W7/000001_1689756008.jpg', '上架'),
        ( '全家 500元禮品卡', 3, '適用全台全家', 450, 3, 'https://mall.iopenmall.tw/website/uploads_product/website_12985/P1298504213225_3_37090503.jpeg?hash=99663','上架'),
        ( '秀泰影城電影票', 1, '適用秀泰影城', 270, 10, 'https://shoplineimg.com/5a14d0ee72fdc03c82001454/613acabf9065d2002916d325/800x.webp?source_format=jpg', '上架'),
        ( '7-11 1000元禮品卡', 3, '適用全台7-11', 900, 7, 'https://www.cocorolife.tw/images/product/thumb/270030/20221230070753.jpg','上架'),
        ( '國賓電影票', 1, '適用國賓影城', 270, 10, 'https://media.ticketxpress.com.tw/Images/a08a5db9-2b51-42b6-a956-90acc8232dad.jpg','上架'),
        ( '饗食天堂餐券', 2, '適用饗食天堂', 1050, 10, 'https://picdn.gomaji.com/products/o/476/335476/335476_1_48.jpg','上架');

insert into title ( title_name, dept_id)
values  ( '人事經理', 1),
        ( '人事系統測試助理', 1),
        ( '超級管理員', 1),
        ( '公關經理', 2),
        ( '公關助理', 2),
        ( '公關專員', 2),
        ( '行銷經理', 3),
        ( '行銷助理', 3),
        ( '行銷專員', 3),
        ( '財務經理', 4);

insert into employee ( emp_name, birth, password, email, id_number, gender, phone, tel, photo_url, address, title_id, hire_date, leave_date,  emp_state)
values  ( '王小明', '1990-01-01', '100', 'wang@example.com', 'A123456789', '男', '0912345678', '02-12345678', null, '台北市', 1, '2022-01-01', null,  '在職'),
        ( '李小花', '1991-02-02', '100', 'li@example.com', 'A987654321', '女', '0912345678', null, null, '台北市', 2, '2022-01-02', null,  '在職'),
        ( '張三', '1992-03-03', '', 'zhang@example.com', 'B123456789', '男', '0912345678', null, null, '新北市', 3, '2022-01-03', null, '在職'),
        ( '李四', '1993-04-04', '', 'li4@example.com', 'B987654321', '女', '0912345678', '02-12345678', null, '新北市', 4, '2022-01-04', null,'在職'),
        ( '王五', '1994-05-05', '', 'wang5@example.com', 'C123456789', '男', '0912345678', null, null, '桃園市', 5, '2022-01-05', null, '在職'),
        ( '趙六', '1995-06-06', '', 'zhao@example.com', 'C987654321', '女', '0912345678', '03-12345678', null, '桃園市', 6, '2022-01-06', null,'在職'),
        ( '孫七', '1996-07-07', '', 'sun@example.com', 'D123456789', '男', '0912345678', null, null, '台中市', 7, '2022-01-07', null,'在職'),
        ( '周八', '1997-08-08', '', 'zhou@example.com', 'D987654321', '女', '0912345678', '04-12345678', null, '台中市', 8, '2022-01-08', null, '在職'),
        ( '吳九', '1998-09-09', '', 'wu@example.com', 'E123456789', '男', '0912345678', null, null, '台南市', 9, '2022-01-09', null, '在職'),
        ( '郭十', '1999-10-10', '', 'guo@example.com', 'E987654321', '女', '0912345678', '05-12345678', null, '台南市', 10, '2022-01-10', null,'在職'),
        ( '王十一', '1990-09-21', '', 'wang11@example.com', 'K123456789', '男', '0912345678', null, null, '台北市', 1, '2022-01-21', null,'在職'),
        ( '陳彥宇', '1991-11-22', '100', 'd0981843347@gmail.com', 'L123456789', '女', '0912345678', null, null, '台北市', 2, '2022-01-22', null,'在職'),
        ( '吳承員', '1992-11-23', '100', 'zhang13@example.com', 'L123456789', '男', '0912345678', null, null, '新北市', 3, '2022-01-23', null, '在職'),
        ( '汪映君	', '1993-11-24', '100', 'ygkhoph@gmail.com', 'B123456789', '女', '0912345678', '02-12345678', null, '新北市', 4, '2022-01-24', null,'在職'),
        ( '凃懿珈	', '1994-11-25', '100', 'hellojia0111@gmail.com', 'C123456789', '男', '0912345678', null, null, '桃園市', 5, '2022-01-25', null,'在職'),
        ( '蕭旭凱	', '1995-11-26', '100', 'Kyle2542736@gmail.com', 'C987654321', '女', '0912345678', '03-12345678', null, '桃園市', 6, '2022-01-26', null,'在職'),
        ( '嚴裕凱	', '1996-11-27', '100', 'u06m4d93@gmail.com', 'D123456789', '男', '0912345678', null, null, '台中市', 7, '2022-01-27', null,'在職'),
        ( '測試用員工', '1997-11-28', '100', 'zhou18@example.com', 'D987654321', '女', '0912345678', '04-12345678', null, '台中市', 8, '2022-01-28', null,'在職'),
        ( '吳十九', '1998-11-29', '', 'wu19@example.com', 'E123456789', '男', '0912345678', null, null, '台南市', 9, '2022-01-29', null, '在職'),
        ( '郭二十', '1999-11-30', '', 'guo20@example.com', 'O987654321', '女', '0912345678', '05-12345678', null, '台南市', 10, '2022-01-30', null, '在職');


insert into permission_info ( emp_id, permission_id)
values  ( 1001, 6),
        ( 1002, 6),
        ( 1003, 1),
        ( 1004, 1),
        ( 1005, 1),
        ( 1006, 1),
        ( 1007, 1),
        ( 1008, 1),
        ( 1009, 1),
        ( 1010, 1),
        ( 1011, 1),
        ( 1012, 6),
        ( 1013, 6),
        ( 1014, 6),
        ( 1015, 6),
        ( 1016, 6),
        ( 1017, 6),
        ( 1018, 1);

insert into permission_move ( emp_id, before_permission_name, after_permission_name, reason, effect_date, approver)
values  (1001, '允許管理員工資料', '允許簽核資料', '升職為部門主管', '2022-10-01', '人事經理'),
        ( 1002, '允許讀取個人資料', '允許管理系統設定', '轉職為人事系統測試助理', '2022-09-15', '人事經理'),
        ( 1003, '允許讀取個人資料', '允許管理系統設定', '升職超級管理員', '2022-08-20', '行銷經理'),
        ( 1004, '允許讀取個人資料', '允許管理員工資料', '轉職為人事專員', '2022-07-10', '人事經理'),
        ( 1005, '允許讀取個人資料', '允許簽核資料', '轉職為研發經理', '2022-06-05', '研發經理'),
        ( 1006, '允許讀取個人資料', '允許簽核資料', '升職為部門主管', '2022-05-01', '客服經理'),
        ( 1007, '允許讀取個人資料', '允許管理員工資料', '轉職為人事專員', '2022-04-15', '人事經理'),
        ( 1008, '允許讀取個人資料', '允許讀取個人資料', '轉職為生產專員', '2022-03-20', '研發經理'),
        ( 1009, '允許讀取個人資料', '允許簽核資料', '升職為部門主管', '2022-02-10', '品保經理'),
        (1010, '允許讀取個人資料', '允許管理員工資料', '轉職為人事專員', '2022-01-05', '人事經理');


CREATE TABLE emp_salary_info
(
    emp_id                       INT           NOT NULL PRIMARY KEY,
    basic_salary                 INT           NOT NULL,
    labor_insurance_grade        INT           NOT NULL,
    labor_volunteer_pension_rate DECIMAL(5, 2) NOT NULL,
    health_insurance_grade       INT           NOT NULL,
    family_dependants_num        INT           NOT NULL,
    welfare_benefits_deduction   VARCHAR(5)    NOT NULL,
    CONSTRAINT emp_salary_info_ibfk_1
        FOREIGN KEY (emp_id) REFERENCES employee (emp_id)
);

INSERT INTO emp_salary_info (`emp_id`, `basic_salary`, `labor_insurance_grade`, `labor_volunteer_pension_rate`, `health_insurance_grade`, `family_dependants_num`, `welfare_benefits_deduction`)
VALUES
    (1012, 27000, 26400, 0, 26400, 0, '0'),
    (1013, 30000, 30300, 0.06, 30300, 1, '1'),
    (1014, 55000, 45800, 0.06, 57800, 2, '1'),
    (1015, 28000, 28800, 0, 28800, 0, '1'),
    (1016, 32000, 33000, 0, 33000, 0, '1');

create table if not exists salary_history
(
    id              int auto_increment
        primary key,
    emp_id          int                                not null,
    original_salary int                                null,
    adjust_salary   int                                null,
    remark          varchar(50)                        null,
    adjusted_date   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint SalaryHistory_employee_emp_id_fk
        foreign key (emp_id) references employee (emp_id)
);

INSERT INTO salary_history (`emp_id`, `original_salary`, `adjust_salary`, `remark`)
VALUES
    (1012, 25250, 26000, '年度調薪'),
    (1013, 26000, 27000, '老闆開心'),
    (1014, 29000, 30000, '年度調薪'),
    (1015, 45000, 55000, '年度調薪'),
    (1016, 29000, 32000, '年度調薪');

CREATE TABLE subject_type
(
    subject_id     INT AUTO_INCREMENT PRIMARY KEY,
    subject_name   VARCHAR(30) NOT NULL,
    calculate_type VARCHAR(10) NOT NULL,
    frequency      VARCHAR(10) NOT NULL,
    amount_default INT NULL,
    status         VARCHAR(10) NOT NULL
)auto_increment=1000;

INSERT INTO subject_type (`subject_name`, `calculate_type`, `frequency`, `amount_default`, `status`)
VALUES
    ('基本薪資', 'P', '1', NULL, '1'),  -- 1000
    ('伙食津貼', 'P', '1', '2400', '1'), -- 1001
    ('加班費', 'P', '1', NULL, '1'),     -- 1002
    ('年終獎金', 'P', '0', NULL, '1'),    -- 1003
    ('勞保費', 'M', '1', NULL, '1'),     -- 1004
    ('健保費', 'M', '1', NULL, '1'),     -- 1005
    ('勞退自提退休金', 'M', '1', NULL, '1'), -- 1006
    ('福利金', 'M', '1', NULL, '1'),     -- 1007
    ('扣薪假', 'M', '1', NULL, '1');     -- 1008

create table if not exists salary_month_record
(
    id           int auto_increment
        primary key,
    sl_year      int                                not null,
    sl_month     int                                not null,
    emp_id       int                                not null,
    add_sum      int                                not null,
    dedu_sum     int                                not null,
    net_salary   int                                not null,
    created_date datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint salary_month_record_ibfk_1
        foreign key (emp_id) references employee (emp_id)
);

create table if not exists salary_detail
(
    id           int auto_increment
        primary key,
    emp_id       int                                not null,
    subject_id   int                                not null,
    amount       int                                not null,
    created_date datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    record_id    int                                not null,
    constraint salary_detail_ibfk_1
        foreign key (emp_id) references employee (emp_id),
    constraint salary_detail_ibfk_2
        foreign key (subject_id) references subject_type (subject_id),
    constraint salary_detail_ibfk_3
        foreign key (record_id) references salary_month_record (id)
);

INSERT INTO salary_month_record (`sl_year`, `sl_month`, `emp_id`, `add_sum`, `dedu_sum`, `net_salary`)
VALUES
    (2023, 2, 1012, 35000, 1225, 33775),
    (2023, 2, 1013, 37500, 1348, 36152 );

INSERT INTO salary_detail ( `emp_id`, `subject_id`, `amount`,  `record_id`)
VALUES
    ( 1012, 1001, 27000,  1), -- 薪資
    ( 1012, 1002, 3000, 1), -- 加班費
    ( 1012, 1003, 5000,  1), -- 年終獎金
    ( 1012, 1004, 662, 1),  -- 勞保費
    ( 1012, 1005, 428, 1),  -- 健保費
    ( 1012, 1007, 135,  1),  -- 福利金
    ( 1013, 1001, 30000,2), -- 薪資
    ( 1013, 1002, 2000,  2), -- 加班費
    ( 1013, 1003, 5500, 2), -- 年終獎金
    ( 1013, 1004, 728, 2),  -- 勞保費
    ( 1013, 1005, 470,  2),  -- 健保費
    ( 1013, 1007, 150, 2);  -- 福利金


create table chats
(
    chats_id   int auto_increment
        primary key,
    Created_at datetime(6)  null,
    Emp_id     varchar(255) null,
    File       varchar(255) null,
    Message    varchar(255) null,
    Room_id    int          null,
    user_ip    varchar(255) null
);

create table message_entity
(
    message_id int auto_increment
        primary key,
    chat       varchar(255) null,
    Created_at datetime(6)  null,
    file       varchar(255) null,
    receiver   int          null,
    sender     int          null,
    user1      int          null,
    user2      int          null
);

create table apply_resignation
(
    file          varchar(255) null,
    leave_date    date         null,
    quit          bit          null,
    reason        varchar(255) not null,
    transfer_form bit          null,
    form_id       int          not null
        primary key,
    constraint FKgsu7ecqqp4lk59t57f7npw6sn
        foreign key (form_id) references form_record (form_id)
);
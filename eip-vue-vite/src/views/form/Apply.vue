
<template>
  <div class="card text-center div1">
    <div class="a1">
      <label>表單名稱</label>
      <select v-model="form.name" @change="fileClear">
        <option value="加班">加班申請</option>
        <option value="請假">請假申請</option>
        <option value="離職">離職申請</option>
      </select>
      <div v-if="form.name === '請假'">
        <select
          v-model="form.type"
          placeholder="請選擇請假類別"
          @change="getRemaining(form.type)"
        >
          <option value="-1">請選擇請假類別</option>
          <option value="1">半年特休</option>
          <option value="2">一年特休</option>
          <option value="3">半薪病假</option>
          <option value="4">生理假</option>
          <option value="5">事假</option>
          <option value="6">婚假</option>
          <option value="7">喪假</option>
          <option value="8">產假</option>
        </select>
        <span v-if="form.type >= 1"
          >目前還可以請 : {{ Math.floor(remainingDays / 24) }} 天
          {{ remainingDays % 24 }} 小時</span
        ><br />

        <label for="startDateTime">開始日期時間：</label>
        <input type="date" v-model="startDate" @change="dayCount" /><input
          type="time"
          v-model="startTime"
          @change="dayCount"
          step="3600000"
        />
        <label for="endDateTime">結束日期時間：</label>
        <input type="date" v-model="endDate" @change="dayCount" /><input
          type="time"
          v-model="endTime"
          @change="dayCount"
        />
        <span v-if="difference != ''">
          共:{{ difference.days }}天{{ difference.hours }}小時
        </span>
        <label>請假原因</label>
        <textarea rows="5" v-model="form.reason" placeholder="請填寫請假原因"></textarea>
      </div>
      <div v-if="form.name === '加班'">
        <label>加班日期</label>
        <input type="date" v-model="date" />
        <label>加班時段</label>
        <input type="time" v-model="startDateTime" />
        到
        <input type="time" v-model="endDateTime" />
        <select v-model="form.type" placeholder="請選擇加班日別">
          <option value="-1">請選擇加班類別</option>
          <option value="1">平日</option>
          <option value="2">休息日</option>
          <option value="3">國定假日或特別休假</option>
          <option value="4">例假</option>
        </select>
        <label>加班理由</label>
        <textarea rows="5" v-model="form.reason" placeholder="請填寫加班理由"></textarea>
      </div>
      <div v-if="form.name === '離職'">
        <label>離職日期</label>
        <input type="date" v-model="date" />
        <label>離職原因</label>
        <textarea rows="5" v-model="form.reason"></textarea><br />
        是否需要申請<br />
        離職證明書:<input type="checkbox" v-model="file.file1" />
        勞健保轉出單:<input type="checkbox" v-model="file.file2" />
      </div>
      <br />附檔:
      <input
        type="file"
        @change="fileChange"
        multiple
        :accept="fileType"
        ref="fileInput"
      />
      <label>審核者ID
      <select v-model="aduit">
        <option value="" disabled>請選擇審核人</option>
        <option v-for="deptEmp in sameDeptEmp" :value="deptEmp.empId">
          {{deptEmp.empName}}
        </option>
      </select></label>
      <button @click="applyForm">提交</button>
      <button @click="onReset">重置</button>
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import {ref, reactive, watch, onMounted} from "vue";
import Swal from "sweetalert2";
import {empStore} from "../../stores/employee.js";
let toDay = new Date();
let formattedDate = toDay.toISOString().split('T')[0]; // 這將給你 "2023-10-20" 這樣的格式
const forms = ref([]);
const emp = empStore();
const user = ref(emp.empId);
const sameDeptEmp=reactive({});
const aduit = ref("");
const startDate = ref(formattedDate);
const endDate = ref(formattedDate);
const startTime = ref("");
const endTime = ref("");
const updateTime = (value, target) => {
  const newHour = value.split(":")[0];
  target.value = `${newHour}:00`;
};

watch(startTime, (newValue) => updateTime(newValue, startTime));
watch(endTime, (newValue) => updateTime(newValue, endTime));

const date = ref(formattedDate);

//檔案部分
const file = ref({
  file1: false,
  file2: false,
});
const fileInput = ref(null);
const fileType = ref(
  ".txt, .doc, .docx, .pdf, .jpg, .jpeg, .png, .gif, .xlsx, .csv"
);

const fileChange = (e) => {
  const selectedFiles = e.target.files;
  const maxSizeInBytes = 1024 * 1024 * 5; // 5MB
  // 檢查每個選擇的文件
  file.value = [];
  for (let i = 0; i < selectedFiles.length; i++) {
    if (selectedFiles[i].size > maxSizeInBytes) {
      Swal.fire({
        icon: "error",
        title: "檔案超過大小",
        text: `${selectedFiles[i].name}超過5MB`,
      });
      fileInput.value.value = "";
      return;
    } else {
      // 如果文件大小符合要求，添加到陣列
      file.value.push(selectedFiles[i]);
    }
  }
};
const fileClear = () => {
  fileInput.value.value = "";
  file.value = [];
};
function getFileName(files) {
  const fileNames = [];
  files.forEach((file) => {
    fileNames.push(file.name);
  });
  return fileNames.join(",");
}



//資料設定
const form = reactive({
  name: "加班",
  date: "",
  time: "",
  reason: "",
  type: "-1",
});
const datas = reactive({
  typeId: "",
  days: "",
  hours: "",
  reason: "",
  file: "",
  startime: "",
  endTime: "",
});
const URL = import.meta.env.VITE_API_JAVAURL;

//算剩餘天數
const remainingDays = ref("");
const getRemaining = async (id) => {
  if (user.value == "") {
    return;
  }
  const URLAPI = `${URL}form/findRemainingLeaveDays?typeId=${id}&empId=${user.value}`;
  const response = await axios.get(URLAPI);
  if (response.data == "") {
    switch (parseInt(id)) {
      case 1:
        remainingDays.value = 3 * 24;
        break;
      case 2:
        remainingDays.value = 4 * 24;
        break;
      case 3:
        remainingDays.value = 3 * 24;
        break;
      case 4:
        remainingDays.value = 12 * 24;
        break;
      case 5:
        remainingDays.value = 30 * 24;
        break;
      case 6:
        remainingDays.value = 7 * 24;
        break;
      case 7:
        remainingDays.value = 7 * 24;
        break;
      case 8:
        remainingDays.value = 30 * 24;
        break;
    }
  } else if (response.data < 0) {
    remainingDays.value = "本月已無天數";
  } else remainingDays.value = response.data;
};

// 計算天數
const difference = ref({ hours: 0, days: 0 });
const startDateTime = ref();
const endDateTime = ref();
const dayCount = () => {
  startDateTime.value = startDate.value + " " + startTime.value;
  endDateTime.value = endDate.value + " " + endTime.value;
  if (
    startTime.value != "" &&
    startDate.value != "" &&
    endTime.value != "" &&
    endDate.value != ""
  )
    difference.value = calculateTimeDifference(
      startDateTime.value,
      endDateTime.value
    );
};
//送出
const applyForm = async () => {
  let applyType = "";
  const formData = new FormData();
  if (file.value) {
    file.value.forEach((fileItem) => {
      formData.append("files", fileItem);
    });
  }
  if (form.name == "請假") {
    let dateTime = difference.value.days * 24 + difference.value.hours;
    if (
      dateTime > remainingDays.value ||
      remainingDays.value == "本月已無天數"
    ) {
      Swal.fire({
        icon: "error",
        title: "天數異常",
        text: "已超過可請的天數",
      });
      return;
    }
    applyType = "applyForLeave";
    datas.value = {
      typeId: form.type,
      days: dateTime / 24,
      hours: dateTime % 24,
      file: getFileName(file.value),
      reason: form.reason,
      startTime: startDateTime.value.replace(" ", "T") + ":00",
    };
    console.log(datas.value);
  } else if (form.name == "加班") {
    applyType = "applyForOvertime";
    datas.value = {
      typeId: form.type,
      reason: form.reason,
      date: date.value,
      file: getFileName(file.value),
      startTime: startDateTime.value + ":00",
      endTime: endDateTime.value + ":00",
    };
    evaluate();
    console.log(getFileName(file.value));
  } else if (form.name == "離職") {
    applyType = "applyResign";
    datas.value = {
      reason: form.reason,
      leaveDate: date.value,
      quit: file.value.file1,
      transferForm: file.value.file2,
    };
  }
  const json = JSON.stringify(datas.value);
  const blob = new Blob([json], {
    type: "application/json",
  });
  formData.append("data", blob);
  console.log(formData);

  const URLAPI = `${URL}form/${applyType}?empId=${user.value}&audit=${aduit.value}`;

  const response = await axios.post(URLAPI, formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  });
  datas.value = {
    typeId: "",
    days: "",
    hours: "",
    file: "",
    reason: "",
    startTime: "",
    endTime: "",
  };
  if ((response.data == false) & (form.name == "離職")) {
    Swal.fire({
      icon: "error",
      title: "錯誤",
      text: "你的離職單已通過,或者正在審核中",
    });
  } else if (response.status == 200)
    Swal.fire({
      title: "成功",
      text: "送出成功！",
      icon: "success",
    });
  if (form.name == "請假") getRemaining(form.type);
  // console.log(response);
};

const evaluate = () => {
  if (form.name == "加班") {
  } else {
  }

  const start = new Date(`1970-01-01T${datas.value.startTime}`);
  const end = new Date(`1970-01-01T${datas.value.endTime}`);
  if (start > end) {
    console.log(554);
  }
};

//計算
function calculateTimeDifference(startDateTime, endDateTime) {
  const sestartDate = new Date(startDateTime);
  const seendDate = new Date(endDateTime);

  const daysDiff = Math.ceil((seendDate - sestartDate) / (1000 * 60 * 60 * 24));
  // daysDiff = 5
  let totalHours = 0;
  // 迴圈計算每天的時數
  for (let i = 0; i < daysDiff; i++) {
    // 獲取當天日期
    const day = new Date(sestartDate.getTime() + i * 1000 * 60 * 60 * 24);
    // 定義當天的工作時間範圍
    let startHour = 8; // 開始時間
    let startMinute = 0;
    let endHour = 17; // 結束時間
    let endMinute = 0;
    const startWork = 8;
    const endWork = 17;
    console.log(day.getDay);
    // 略過周末
    if (day.getDay() === 0 || day.getDay() === 6) {
      continue;
    } else if (daysDiff == 1) {
      if (sestartDate.getHours() < startWork) startHour = startWork;
      else startHour = sestartDate.getHours();
      if (seendDate.getHours() > endWork) endHour = endWork;
      else endHour = seendDate.getHours();
    } else if (i == 0) {
      if (sestartDate.getHours() < startWork) startHour = startWork;
      else startHour = sestartDate.getHours();
      endHour = endWork;
    } else if (i == daysDiff - 1) {
      startHour = startWork;
      if (seendDate.getHours() > endWork) endHour = endWork;
      else endHour = seendDate.getHours();
    }
    // 建立開始和結束時間日期物件
    const start = new Date(
      day.getFullYear(),
      day.getMonth(),
      day.getDate(),
      startHour,
      startMinute
    );
    const end = new Date(
      day.getFullYear(),
      day.getMonth(),
      day.getDate(),
      endHour,
      endMinute
    );
    // 計算當天工作時數
    let dayHours = (end - start) / (1000 * 60 * 60);
    // 累加時數
    if (startHour <= 12 && endHour >= 13) {
      dayHours--;
    }
    if (dayHours > 0) {
      totalHours += dayHours;
    }
  }
  console.log(totalHours);
  if (totalHours <= 0) {
    Swal.fire({
      icon: "error",
      title: "時數異常",
      text: "請重新選擇時間",
    });
    startDateTime.value = "";
    endDateTime.value = "";
    return { days: "--", hours: "--" };
  }
  return { days: parseInt(totalHours / 24), hours: totalHours % 24 };
}

onMounted(()=>{
  axios.get(`http://localhost:8090/eipulse/employee/dept/${emp.empId}`).then((res)=>{
    Object.assign(sameDeptEmp,res.data);
  })
})
</script>
<style scoped>
.a1 {
  max-width: 100%;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input,
select,
textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type="date"] {
  appearance: none; /* 清除默认样式 */
}

div {
  display: inline-block;
  margin-right: 10px;
}

.line {
  padding: 0 10px;
}

button {
  display: inline-block;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  background: #007bff;
  color: #fff;
  cursor: pointer;
}

button:hover {
  background: #0062cc;
}
</style>

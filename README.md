# 鸿蒙HarmonyOS-HTTP网络请求使用

## 一、场景介绍
应用通过HTTP发起一个数据请求，支持常见的GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT方法。
## 二、接口说明
#### 1、说明：
* HTTP数据请求功能主要由http模块提供。
* 使用该功能需要申请ohos.permission.INTERNET权限。在 src/main/module.json5 中添加网络权限配置：
```
"requestPermissions": [
  {
    "name": "ohos.permission.INTERNET"
  }
]
```
问题：预览器可以网络请求，模拟器无法网络请求

#### 2、涉及的接口如下表，具体的接口说明请参考API文档：
###### 1、createHttp：
* 通过http.createHttp创建一个HTTP请求，里面包括发起请求、中断请求、订阅/取消订阅HTTP Response Header事件。每一个HttpRequest对象对应一个HTTP请求。如需发起多个HTTP请求，须为每个HTTP请求创建对应HttpRequest对象。
* 当该请求使用完毕时，须调用destroy方法主动销毁HttpRequest对象。
###### 2、request：
* request(url: string, callback: AsyncCallback<HttpResponse>): void。
* 根据URL地址，发起HTTP网络请求，使用callback方式作为异步方法。
* 此接口仅支持数据大小为5M以内的数据接收。若url包含中文或其他语言，需先调用encodeURL(url)编码，再发起请求。
* 需要权限：ohos.permission.INTERNET

#### 3、request接口开发步骤
* 从@kit.NetworkKit中导入http命名空间。
* 调用createHttp()方法，创建一个HttpRequest对象。
* 调用该对象的on()方法，订阅http响应头事件，此接口会比request请求先返回。可以根据业务需要订阅此消息。
* 调用该对象的request()方法，传入http请求的url地址和可选参数，发起网络请求。
* 按照实际业务需要，解析返回结果。
* 调用该对象的off()方法，取消订阅http响应头事件。
* 当该请求使用完毕时，调用destroy()方法主动销毁。
```
// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 每一个httpRequest对应一个HTTP请求任务，不可复用
let httpRequest = http.createHttp();
// 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
// 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
httpRequest.on('headersReceive', (header) => {
  console.info('header: ' + JSON.stringify(header));
});
httpRequest.request(
  // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
  "EXAMPLE_URL",
  {
    method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
    // 开发者根据自身业务需要添加header字段
    header: {
      'Content-Type': 'application/json'
    },
    // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
    extraData: "data to send",
    expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
    usingCache: true, // 可选，默认为true
    priority: 1, // 可选，默认为1
    connectTimeout: 60000, // 可选，默认为60000ms
    readTimeout: 60000, // 可选，默认为60000ms
    usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    usingProxy: false, // 可选，默认不使用网络代理，自API 10开始支持该属性
    caPath:'/path/to/cacert.pem', // 可选，默认使用系统预制证书，自API 10开始支持该属性
    clientCert: { // 可选，默认不使用客户端证书，自API 11开始支持该属性
      certPath: '/path/to/client.pem', // 默认不使用客户端证书，自API 11开始支持该属性
      keyPath: '/path/to/client.key', // 若证书包含Key信息，传入空字符串，自API 11开始支持该属性
      certType: http.CertType.PEM, // 可选，默认使用PEM，自API 11开始支持该属性
      keyPassword: "passwordToKey" // 可选，输入key文件的密码，自API 11开始支持该属性
    },
    multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效，自API 11开始支持该属性
      {
        name: "Part1", // 数据名，自API 11开始支持该属性
        contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
        data: 'Example data', // 可选，数据内容，自API 11开始支持该属性
        remoteFileName: 'example.txt' // 可选，自API 11开始支持该属性
      }, {
        name: "Part2", // 数据名，自API 11开始支持该属性
        contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
        // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt
        filePath: `${getContext(this).filesDir}/fileName.txt`, // 可选，传入文件路径，自API 11开始支持该属性
        remoteFileName: 'fileName.txt' // 可选，自API 11开始支持该属性
      }
    ]
  }, (err: BusinessError, data: http.HttpResponse) => {
    if (!err) {
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.info('Result:' + JSON.stringify(data.result));
      console.info('code:' + JSON.stringify(data.responseCode));
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('header:' + JSON.stringify(data.header));
      console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    } else {
      console.error('error:' + JSON.stringify(err));
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    }
  }
);
```

## 三、使用案例
#### 1、导入头文件
```
import http from '@ohos.net.http'
```
或者导入
```
import { http } from '@kit.NetworkKit';
```
NetworkKit 中：
```
import connection from '@ohos.net.connection';
import ethernet from '@ohos.net.ethernet';
import http from '@ohos.net.http';
import mdns from '@ohos.net.mdns';
import policy from '@ohos.net.policy';
import sharing from '@ohos.net.sharing';
import socket from '@ohos.net.socket';
import statistics from '@ohos.net.statistics';
import vpn from '@ohos.net.vpn';
import webSocket from '@ohos.net.webSocket';
import vpnExtension from '@ohos.net.vpnExtension';
import networkSecurity from '@ohos.net.networkSecurity';
import VpnExtensionAbility, { VpnExtensionContext } from '@ohos.app.ability.VpnExtensionAbility';
export { connection, ethernet, http, mdns, policy, sharing, webSocket, socket, statistics, vpn, vpnExtension, networkSecurity, VpnExtensionAbility, VpnExtensionContext };
```

#### 2、post请求
```
export function postRequest(url:string, param:Object, success:(str:string)=>void, fail:(error:Error)=>void) {
  let httpRequest = http.createHttp()
  let reponseResult = httpRequest.request(url, {
    method: http.RequestMethod.POST,
    readTimeout:60000,
    connectTimeout:60000,
    header: header,
    extraData: param,
    expectDataType:http.HttpDataType.STRING
  }, (error, data) => {
    if (!error) {
      success(data.result.toString())
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    } else {
      fail(error)
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    }
  })
}
```

#### 3、get请求
```
export function getRequest(url:string, param:Object, success:(str:string)=>void, fail:(error:Error)=>void) {
  let httpRequest = http.createHttp()
  let reponseResult = httpRequest.request(url, {
    method: http.RequestMethod.GET,
    readTimeout:60000,
    connectTimeout:60000,
    header: header,
    extraData: param,
    expectDataType:http.HttpDataType.STRING
  }, (error, data) => {
    if (!error) {
      success(data.result.toString())
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    } else {
      fail(error)
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    }
  })
}
```

#### 4、调用
```
// 请求首页数据
loadHomeRequestData() {
  let param: Record<string, string> = {
    "tabType": "0",
    "courseStrategyStatus": "1",
    "scene": "001",
    "client_type": "1",
    "v": "7.75.50",
    "localCity": ""
  }
  postRequest('https://app.saasp.vdyoo.com/backstage/xes/homepage/v2/courseGroupList', param, (jsonStr: string) => {
    console.info('wxqtodo first net Result:' + jsonStr);
    this.homeCourseData = JSON.parse(jsonStr)
    if (this.homeCourseData.data) {
      // 获取长期班数据
      this.longCourseArray = this.getLongCourseData(this.homeCourseData.data)
      console.log('wxqtodo first net longCourseArray:', this.longCourseArray)
      this.longCourseArray.forEach((groupModel, index) => {
        console.log('wxqtodo groupName = ' + index  + groupModel.groupName)
        groupModel.courseCards?.forEach((courseModel, index) => {
          console.log('wxqtodo courseModel = ' + index + courseModel.courseTitle)
        })
      })
    }
  }, (error: Error) => {
    console.log('wxqtodo first request error:' + error)
  })
}
```
#### 5、效果展示
<img width="218" alt="" src="https://github.com/user-attachments/assets/ace66dbb-ba15-4cec-b36a-f18352b883e6">

## 四、三方库网络使用（@abner/net）
#### 1、Terminal中输入导入命令：
```
ohpm install @abner/net
```
输出结果：
```
<git> ohpm install @abner/net
ohpm INFO: MetaDataFetcher fetching meta info of package '@abner/net' from https://ohpm.openharmony.cn/ohpm/
ohpm INFO: fetch meta info of package '@abner/net' success https://ohpm.openharmony.cn/ohpm/@abner/net
install completed in 0s 119ms
```
项目中展示：

<img width="218" alt="" src="https://github.com/user-attachments/assets/ee36bbf1-fd97-4205-9cbf-2c0768e94f7a">

oh-package.json5中导入信息：
```
"dependencies": {
  "@abner/net": "^1.1.2"
}
```
oh-package-lock.json5 中导入信息：
```
"packages": {
  "@abner/net@1.1.2": {
    "name": "@abner/net",
    "version": "1.1.2",
    "integrity": "sha512-CZpVGnMsVGdjePI+eQL9rPV0nDsVIrSJW/r3vlnLggjnmjMhX9ryDfSD4ufSqzs0d+zF89nd3lAc7cdA+/bCWQ==",
    "resolved": "https://ohpm.openharmony.cn/ohpm/@abner/net/-/net-1.1.2.har",
    "registryType": "ohpm"
  }
}
```
OHPM（OpenHarmony Package Manager）由OpenHarmony三方库中心仓网站、命令行工具、OpenHarmony三方库中心仓仓库三个部分组成。
#### 2、导入头文件：
```
import { Net, NetError } from '@abner/net'
```
#### 3、获取请求结果的三种方式：
使用三方网络框架Net进行网络请求，可以通过以下三只方式获取数据进行使用：
* request：对获取的数据封装成需要的model类型，只返回需要的data对象，不会携带外层的code、message等其他参数。
* requestObject：对获取的数据封装成需要的model类型，会返回的整个json对应的对象，也就是包含了code，message等字段。
* requestString：就是普通的返回请求回来的json字符串。

#### 4、post请求
* requestString方法：获取请求返回的json字符串
```
Net.post(url).setParams(param).setHeaders(header).requestString((data) => {
  success(data.toString())
}, (error) => {
  fail(error)
})
```
* requestObject：返回整个数据model  LeduAppHomeData，包含了code，message等
```
Net.post(url).setParams(param).setHeaders(header).requestObject<LeduAppHomeData>((data) => {
  success(data)
}, (error) => {
  fail(error)
})
```
* request：返回需要的datas数据model LeduAppHPCourseGroupModel
```
Net.post(url).setParams(param).setHeaders(header).requestObject<LeduAppHPCourseGroupModel
>((data) => {
  success(data)
}, (error) => {
  fail(error)
})
```

#### 5、get请求
* requestString方法：获取请求返回的json字符串
```
// get
Net.get(url).setParams(param).setHeaders(header).requestString((data) => {
  success(data.toString())
}, (error) => {
  fail(error)
})
```
* requestObject 和 request 同 post

#### 6、项目中使用（以requestObject为例）
* EntryAbility 中初始化网络信息
```
Net.getInstance().init({
  // "https://test-app.saasp.vdyoo.com"
  baseUrl:"https://app.saasp.vdyoo.com", // 设置全局baseurl
  resultTag:["data"], // 接口返回数据data层参数，比如data,items等等
  connectTimeout:60000, // 设置连接超时
  readTimeout:60000 // 设置读取超时
})
```
* 数据请求
```
// 请求首页数据
loadHomeRequestData() {
  console.log('wxqtodo home loadHomeRequestData')
  // 获取首页数据
  let param: Record<string, string> = {
    "tabType": "0",
    "courseStrategyStatus": "1",
    "scene": "001",
    "client_type": "1",
    "v": "7.75.50",
    "localCity": ""
  }
  let url:string = '/backstage/xes/homepage/v2/courseGroupList'
  Net.post(url).setParams(param).setHeaders(header).requestObject<LeduAppHomeData>((data) => {
    console.info('wxqtodo second net Result:' + data);
    this.homeCourseData = data
    if (this.homeCourseData.data) {
      // 获取长期班数据
      this.longCourseArray = this.getLongCourseData(this.homeCourseData.data)
      console.log('wxqtodo second net longCourseArray:', this.longCourseArray)
      this.longCourseArray.forEach((groupModel, index) => {
        console.log('wxqtodo second groupName = ' + index  + groupModel.groupName)
        groupModel.courseCards?.forEach((courseModel, index) => {
          console.log('wxqtodo second courseModel = ' + index + courseModel.courseTitle)
        })
      })
    }
  }, (error) => {

  })
}
```
#### 7、效果展示
<img width="218" alt="" src="https://github.com/user-attachments/assets/562c9a2c-089f-4a63-9f9c-475328af9f6e">

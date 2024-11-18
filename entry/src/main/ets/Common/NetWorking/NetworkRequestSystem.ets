// 使用系统网络框架 @ohos.net.http 进行网络请求，对获取的json需要手动解析后使用。

// import http from '@ohos.net.http'
import { http } from '@kit.NetworkKit';
import { JSON } from '@kit.ArkTS';

let isTest:boolean = false

let header:Record<string, string> = {
  'session_id': '18',
  'nationalTabSelectCity': '0311',
  'client_type': '2',
  'ansid': '19ABC74F290449EF99DD092F32DB4241',
  'local_city': '010',
  'client-traceid': 'C465214C5A0A4134BCB08D8885CBE03A',
  // ['stu_id', '--'],
  'distinct_id': 'UgvchiLC2XxIeOpUiTZ52ub4KaPBDWQ0k5ShBO037NVVJleQEQFMK1tLMrtvPXge',
  'dn': 'ffCvhWd0SADqoSU8UalubQ==',
  'accessid': 'a32445edf4dd4d74bb468848b730c349',
  'area': '010',
  'seq_id': '531',
  'algorithm': 'HmacSHA1',
  'scene_source': '1',
  'ui': 'A1rek06koT0ITtTwLZKOpDap0XlwPyCx+FcQ69/DrzzL3BO+4nUpO8+6CZKIIMqh',
  'client_id': 'sim_522101',
  'Authorization': 'TouristBearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzM0QkE0Mi01QzhGLTRBNDYtODdBQS03RjY5NjMyODgwMDUifQ.sDQ2bbg40E2MKBVs5r3aiQayhE6fNZgJP0Rm0SDuo-aUTbufUZxnNUmvM4R3hcZJtlLlyK1sNG46-v0O0VrYew',
  'homeSelectCity': '010',
  'gradeId': '9',
  'dv': 'UgvchiLC2XxIeOpUiTZ52ub4KaPBDWQ0k5ShBO037NVVJleQEQFMK1tLMrtvPXge',
  'tabStrategy': '0',
  'v': '7.75.20',
  'onlyv': '3R05QkgYsfpMWMBllEMjiQ==',
  'selectedGradeId': '9',
  // ['timestamp', '1725614444428'],
  'Content-Type': 'application/json',
  'Accept-Language': 'zh-CN',
  'User-Agent': 'SaasApp/1 CFNetwork/1399 Darwin/22.1.0',
  'Accept': '*/*',
  'sign': '54164ae1215a67e158eda721e607a0dd1d2b51fb',
  'Connection': 'keep-alive'
};

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
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.info('Networking ====================================');
      console.info('Networking Url:' + url);
      console.info('Networking Result 类型:' + typeof data.result);
      // console.info('Result 类型:' + typeof JSON.stringify(data.result));
      console.info('Networking Result:' + data.result);
      console.info('Networking code:' + data.responseCode);
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('Networking header:' + JSON.stringify(data.header));
      console.info('Networking cookies:' + data.cookies); // 8+
      console.info('Networking ====================================');
    } else {
      fail(error)
      console.info('Networking error:' + JSON.stringify(error));
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    }
  })
}

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
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.info('Url:' + url);
      console.info('Result:' + data.result);
      console.info('code:' + data.responseCode);
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('header:' + JSON.stringify(data.header));
      console.info('cookies:' + data.cookies); // 8+
    } else {
      fail(error)
      console.info('error:' + JSON.stringify(error));
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    }
  })
}

export function getFullUrl(url: string): string {
  if (isTest) {
    return "https://test-app.saasp.vdyoo.com" + url
  }
  return "https://app.saasp.vdyoo.com" + url
}


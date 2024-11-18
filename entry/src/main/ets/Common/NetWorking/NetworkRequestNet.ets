// 使用三方网络框架Net进行网络请求，可以通过以下三只方式获取数据进行使用：
// 1、request：对获取的数据封装成需要的model类型，只返回需要的data对象，不会携带外层的code、message等其他参数。
// 2、requestObject：对获取的数据封装成需要的model类型，会返回的整个json对应的对象，也就是包含了code，message等字段。
// 3、requestString：就是普通的返回请求回来的json字符串。

import { Net, NetError } from '@abner/net'

export let header:Record<string, string> = {
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
  'gradeId': '8',
  'dv': 'UgvchiLC2XxIeOpUiTZ52ub4KaPBDWQ0k5ShBO037NVVJleQEQFMK1tLMrtvPXge',
  'tabStrategy': '0',
  'v': '7.75.50',
  'onlyv': '3R05QkgYsfpMWMBllEMjiQ==',
  'selectedGradeId': '8',
  // ['timestamp', '1725614444428'],
  'Content-Type': 'application/json',
  'Accept-Language': 'zh-CN',
  'User-Agent': 'SaasApp/1 CFNetwork/1399 Darwin/22.1.0',
  'Accept': '*/*',
  'sign': '54164ae1215a67e158eda721e607a0dd1d2b51fb',
  'Connection': 'keep-alive'
};

// requestString方法：获取请求返回的json字符串
// post
export function postRequest(url:string, param:Object, success:(str:string)=>void, fail:(error:NetError)=>void) {
  Net.post(url).setParams(param).setHeaders(header).requestString((data) => {
    success(data.toString())
  }, (error) => {
    fail(error)
  })
}

// get
export function getRequest(url:string, param:Object, success:(str:string)=>void, fail:(error:NetError)=>void) {
  Net.get(url).setParams(param).setHeaders(header).requestString((data) => {
    success(data.toString())
  }, (error) => {
    fail(error)
  })
}
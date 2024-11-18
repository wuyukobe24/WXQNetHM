import {WXQColor} from '@wxqos/wxqcolor'
import { postRequest } from '../../../Common/NetWorking/NetworkRequestSystem';
import { LeduAppCoursePackageGroupModel, LeduAppHomeData,
  LeduAppHPCourseGroupModel, LeduAppCoursePackageModel } from '../Model/CoursePackageModel';
import { LongCardItemPage } from '../View/LongCardItemPage';

@Entry
@Component
export struct NetFirstController {
  @State message: string = '系统网络请求';
  @State bgColor: string = ''
  @State homeCourseData:LeduAppHomeData = new LeduAppHomeData()
  // 长期班数据
  @State longCourseArray:Array<LeduAppCoursePackageGroupModel> = Array<LeduAppCoursePackageGroupModel>()

  aboutToAppear() {

  }

  @Builder
  LongHeader(title:string){
    Text(title)
      .fontSize(22)
      .fontWeight(600)
      .fontColor(WXQColor.textMajorColor)
      .margin({
        left:20,
        right:20,
        top:title ? 16 : 0,
        bottom:title ? 16 : 0
      })
  }

  // 页面入口
  build() {
    RelativeContainer() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .textAlign(TextAlign.Center)
        Button('点击请求数据')
          .width('100%')
          .height(48)
          .width('50%')
          .fontSize(16)
          .backgroundColor('#FF4B4B')
          .margin({
            top:20,
          })
          .onClick((event: ClickEvent) => {
            console.log('点击请求数据')
            this.loadHomeRequestData()
            this.bgColor = '#ffc0cb'
          })

        // 课程列表
        List() {
          // 长期班
          ForEach(this.longCourseArray, (item:LeduAppCoursePackageGroupModel, index) => {
            ListItemGroup({ header:this.LongHeader(item.groupName) }) {
              ForEach(item.courseCards, (model:LeduAppCoursePackageModel, index) => {
                ListItem() {
                  LongCardItemPage({
                    packageModel: model
                  })
                    .height(135)
                    .backgroundColor(Color.White)
                    .borderRadius(8)
                    .margin({
                      left:10,
                      right:10,
                      top:5,
                      bottom:5
                    })
                }
              })
            }
            .divider({
              strokeWidth:1,
              color:WXQColor.lineColor
            })
          })
        }
        .width('100%')
        .height('80%')
        .backgroundColor(this.bgColor)
        .margin({
          top:20
        })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(WXQColor.backgroundColor)
  }

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

  // 长期班课数据
  getLongCourseData(allGroupModel:LeduAppHPCourseGroupModel):Array<LeduAppCoursePackageGroupModel> {
    let result:Array<LeduAppCoursePackageGroupModel> = Array<LeduAppCoursePackageGroupModel>()
    let courseGroups:Array<LeduAppCoursePackageGroupModel> = allGroupModel?.courseGroups as Array<LeduAppCoursePackageGroupModel>
    if (courseGroups) {
      courseGroups.forEach((groupModel) => {
        if (groupModel.groupType == 2) {
          result.push(groupModel)
        }
      })
    }
    return result
  }

}
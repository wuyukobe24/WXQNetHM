import { LeduAppCoursePackageModel } from '../Model/CoursePackageModel'
import { WXQColor } from '@wxqos/wxqcolor'

@Entry
@Component
export struct LongCardItemPage {
  @State packageModel: LeduAppCoursePackageModel = new LeduAppCoursePackageModel();

  build() {
    RelativeContainer() {
      Column() {
        Column() {
          Text(this.packageModel.cardName)
            .width('100%')
            .fontColor(WXQColor.textMajorColor)
            .fontSize(18)
            .fontWeight(600)
            .lineHeight(25)
            .padding({
              top:16,
              left:10,
              right:10
            })
          Text(this.packageModel.earliestClassTime)
            .width('100%')
            .height(18)
            .fontColor(WXQColor.textHintColor)
            .fontSize(13)
            .padding({
              top:4,
              left:10,
              right:10,
            })
        }
        .justifyContent(FlexAlign.Start)
        Text('¥ ' + this.packageModel.priceRange)
          .width('100%')
          .height(40)
          .fontColor(WXQColor.firstColor)
          .fontSize(20)
          .fontWeight(700)
          .textAlign(TextAlign.End)
          .padding({
            left:20,
            right:20,
            // bottom:10,
          })
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .height('100%')
    .width('100%')
  }
}


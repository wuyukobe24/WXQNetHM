import {NetFirstController} from "../Net/Controller/NetFirstController"
import {NetSecondController} from "../Net/Controller/NetSecondController"

@Entry
@Component
struct TabsPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController()

  @Builder TabBuilder(title:string, targetIndex:number, normalImg:string, selectedImg:string) {
    Column() {
      Image(this.currentIndex == targetIndex ? selectedImg : normalImg)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(10)
        .margin({top:5})
        .fontColor(this.currentIndex == targetIndex ? '#FF4B4B' : '#565D66')
    }
    .backgroundColor('#ffffff')
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .onClick(()=>{
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  build() {
    RelativeContainer() {
      Column() {
        Tabs({barPosition:BarPosition.End, controller:this.tabsController, index:0}) {
          TabContent() {
            NetFirstController()
          }.tabBar(this.TabBuilder('网络1', 0, 'Images/tabbar/tabbarHome_0@3x.png','Images/tabbar/tabbarHome_25@3x.png'))
          TabContent() {
            NetSecondController()
          }.tabBar(this.TabBuilder('网络2', 1, 'Images/tabbar/tabbarNation_0@3x.png','Images/tabbar/tabbarNation_25@3x.png'))
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}
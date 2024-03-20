import { SearchView } from '../../../../../commonModule/src/main/ets/components/SearchView'
import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { ToastUtils } from '../../../../../commonModule/src/main/ets/utils/ToastUtils'
import { InterviewListView } from './InterviewListView'
/*
 * @desc:面经
 * @author:hxy
 * @date:2024/2/17
 */
class TabItem {
  name: string
  value?: number
  onAreaChange?: (area: Area) => void
}

@Preview
@Component
export struct InterviewPage {
  @State
  left: number = 16
  @State
  sort: number | undefined = 30

  build() {
    Column() {
      Row({ space: dp(16) }) {
        Image($r('app.media.ic_interview_text'))
          .width(54)
          .height(20)
        SearchView({ val: '', bg: 'rgba(246, 247, 249, 0.5)', color: '#333333' })
          .layoutWeight(1)
          .onClick(() => {
            ToastUtils.showToast("搜索")
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .height(64)

      Scroll() {
        Row({ space: 10 }) {
          this.HotFirmItem($r('app.media.ic_company_hw'), 1.5)
          this.HotFirmItem($r('app.media.ic_company_wr'), 2.9)
          this.HotFirmItem($r('app.media.ic_company_gg'), 3.1)
          this.HotFirmItem($r('app.media.ic_company_zj'), 5.3)
          this.HotFirmItem($r('app.media.ic_company_wy'), 3.6)
        }
      }
      .width('100%')
      .height(160)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .padding(10)
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor('#f5f5f5')

      Row() {
        Row() {
          this.tabBuilder({
            name: '推荐', value: 30,
            onAreaChange: (area) => {
              this.setLineLeft(area)
            }
          })
          this.tabBuilder({ name: '最新' })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .height(40)
        .border({
          width: { bottom: dp(0.5) },
          color: $r('app.color.common_gray_border')
        })

        Text()
          .width(16)
          .height(2)
          .backgroundColor($r('app.color.black'))
          .position({ x: this.left, y: 38 })
          .animation({
            duration: 300
          })
      }

      InterviewListView({ sort: this.sort })
    }
    .height('100%')
    .width('100%')
  }

  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - 16) / 2
  }

  @Builder
  tabBuilder(tab: TabItem) {
    Text(tab.name)
      .fontSize(14)
      .padding(10)
      .fontColor(this.sort == tab.value ? $r('app.color.black') : $r('app.color.common_gray_01'))
      .animation({
        duration: 300
      })
      .onClick((e) => {
        this.setLineLeft(e.target.area)
        this.sort = tab.value
      })
      .onAreaChange((_o, n) => tab.onAreaChange && tab.onAreaChange(n))
  }

  @Builder
  HotFirmItem(res: Resource, count: number) {
    Column({ space: dp(15) }) {
      Image(res)
        .width(36)
        .aspectRatio(1)
        .margin({ top: 20 })
        .objectFit(ImageFit.Contain)
      Text() {
        Span('热门指数')
        Span(`${count}K`)
          .fontColor($r('app.color.common_green'))
      }
      .fontSize(dp(13))

      Button({ type: ButtonType.Normal }) {
        Text('查看')
          .fontSize(14)
      }
      .backgroundColor($r('app.color.common_gray_bg'))
      .padding(0)
      .height(30)
      .width(80)
      .borderRadius(8)
    }
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .height(140)
    .width(100)
  }
}
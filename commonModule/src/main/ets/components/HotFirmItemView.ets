/**
 * @desc:热门企业
* @author:hxy
 * @time:2024/3/19
 */
import { dp } from '../utils/DispalyUtils'
@Component
export struct HotFirmItemView {
  @Prop
  count: number
  @Link
  res : ResourceStr


  build() {
    Column({ space: dp(15) }) {
      Image(this.res)
        .width(36)
        .aspectRatio(1)
        .margin({ top: 20 })
        .objectFit(ImageFit.Contain)
      Text() {
        Span('热门指数')
        Span(`${this.count}K`)
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
import { BasicConstant } from '../constants/Constants'
import { dp } from '../utils/DispalyUtils'
/**
 * @desc:搜索框
* @author:hxy
 * @time:2024/2/18
 */
@Component
export struct SearchView {
  @Prop
  val: string
  @State
  readonlyMode: boolean = true
  ph: string = ''
  bg: ResourceStr = ''
  color: string = ''
  onSubmit: () => void = () => {
  }
  onChange: (val: string) => void = (val: string) => {
  }

  build() {
    Row() {
      if (this.readonlyMode) {
        Row({ space: BasicConstant.SPACE_SM }) {
          Image($r("app.media.ic_common_search"))
            .width($r('app.float.hd_search_icon_size'))
            .aspectRatio(1)
            .fillColor(this.color || $r('app.color.common_gray_02'))
          Text(this.ph || $r('app.string.search_placeholder'))
            .fontColor(this.color || $r('app.color.common_gray_02'))
            .fontSize($r('app.float.common_font14'))
        }
        .height($r('app.float.hd_search_height'))
        .width('100%')
        .backgroundColor(this.bg || $r('app.color.common_gray_border'))
        .borderRadius($r('app.float.hd_search_radius'))
        .justifyContent(FlexAlign.Center)
      } else {
        Search({
          placeholder: this.ph || '搜索题目',
          value: this.val
        })
          .textFont({ size: $r('app.float.common_font14') })
          .width('100%')
          .padding(0)
          .margin(0)
          .backgroundColor(this.bg || $r('app.color.common_gray_border'))
          .placeholderColor($r('app.color.common_gray_02'))
          .placeholderFont({ size: $r('app.float.common_font14') })
          .height($r('app.float.hd_search_height'))
          .onSubmit(() => {
            this.onSubmit && this.onSubmit()
          })
          .onChange((val) => {
            this.onChange && this.onChange(val)
          })
      }
    }
  }
}
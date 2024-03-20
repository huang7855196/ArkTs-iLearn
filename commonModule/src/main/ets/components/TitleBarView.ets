/**
 * @desc:统一标题栏
* @author:hxy
 * @time:2024/3/19
 */
import router from '@ohos.router'
import { dp } from '../utils/DispalyUtils'

@Component
export struct TitleBarView {
  rightIcon: ResourceStr = $r('app.media.ic_home_more')
  @Prop
  showRightIcon: boolean
  @Prop
  title: string
  @BuilderParam
  menuBuilder: () => void = this.mMenuBuilder

  @Builder
  mMenuBuilder() {
    Menu() {
      MenuItem({ content: '取消点赞' })
      MenuItem({ content: '收藏' })
      MenuItem({ content: '分享' })
    }
    .width(dp(108))
  }

  @Builder
  defaultTitleBuilder() {
  }

  @BuilderParam
  titleBuilder: () => void = this.defaultTitleBuilder

  @Builder
  default() {

  }

  build() {
    Row() {
      Image($r('app.media.ic_common_back'))
        .size({ width: dp(24), height: dp(24) })
        .onClick(() => router.back())
        .fillColor($r('app.color.black'))

      Stack() {
        if (this.title) {
          Text(this.title)
            .fontWeight(600)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        } else if (this.titleBuilder) {
          this.titleBuilder()
        }
      }
      .layoutWeight(1)

      if (this.showRightIcon) {
        Image(this.rightIcon)
          .width(dp(24))
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .bindMenu(this.menuBuilder)

      } else {
        Blank()
          .width(dp(24))
      }
    }
    .height(dp(56))
    .padding({ left: dp(16), right: dp(16) })
  }
}
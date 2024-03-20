import router from '@ohos.router'
import { USER_KEY } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { UserModel } from '../../../../../commonModule/src/main/ets/models/UserModel'
import { dp, formatTime } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { ToastUtils } from '../../../../../commonModule/src/main/ets/utils/ToastUtils'
import { ClockView } from '../../../../../commonModule/src/main/ets/components/ClockView'
/*
 * @desc:我的
 * @author:hxy
 * @date:2024/2/17
 */
@Preview
@Component
export struct MinePage {
  @StorageProp(USER_KEY)
  @Watch('updateUser')
  userJson: string = '{}'
  @State
  user: UserModel = JSON.parse(this.userJson)
  @StorageProp('colorMode')
  colorMode: number = 1

  updateUser() {
    this.user = JSON.parse(this.userJson)
  }

  build() {
    Column({ space: dp(15) }) {
      Row() {
        Image(this.user.avatar || '/images/avatar.png')
          .width(dp(55))
          .aspectRatio(1)
          .borderRadius(dp(30))
        Column() {
          if (this.user.token) {
            Text(this.user.nickName || this.user.username)
              .fontSize(dp(18))
              .fontWeight(FontWeight.Bold)
            Row() {
              Text('编辑资料')
                .fontSize(dp(12))
                .fontColor($r('app.color.gray'))
              Image($r('app.media.icon_edit'))
                .width(dp(12))
                .aspectRatio(1)
                .fillColor($r('app.color.gray'))
            }
            .onClick(() => {
              router.pushUrl({
                url: 'pages/ProfilePage'
              })
            })
          } else {
            Text('立即登录')
              .fontSize(dp(18))
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/LoginPage'
                })
              })
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .padding({ left: dp(12) })

        ClockView({ clockCount: this.user.clockinNumbers || 0 })
      }
      .width('100%')
      .height(dp(80))
      .alignItems(VerticalAlign.Center)

      GridRow({ columns: 4 }) {
        GridCol() {
          this.GridItemView($r('app.media.icon_my_history'), '历史记录')
        }

        GridCol() {
          this.GridItemView($r('app.media.icon_my_favo'), '我的收藏')
        }

        GridCol() {
          this.GridItemView($r('app.media.icon_my_zan'), '我的点赞')
        }

        GridCol() {
          Column() {
            this.GridItemView($r('app.media.icon_my_time'), '累计学时')
            Row() {
              Text(formatTime(this.user.totalTime))
                .fontColor('#C3C3C5')
                .fontSize(dp(11))
              Image($r('app.media.icon_my_arrow'))
                .fillColor('#C3C3C5')
                .width(dp(13))
                .height(dp(13))
            }
            .margin({ top: dp(3) })
          }
        }
      }
      .backgroundColor('#fff')
      .borderRadius(dp(8))
      .padding(dp(15))

      List() {
        ListItem() {
          this.ListItemView($r('app.media.ic_mine_notes'), '开发常用词')
        }

        ListItem() {
          this.ListItemView($r('app.media.ic_mine_ai'), '面通AI')
        }

        ListItem() {
          this.ListItemView($r('app.media.ic_mine_invite'), '推荐分享')
        }

        ListItem() {
          this.ListItemView($r('app.media.ic_mine_file'), '已经反馈')
        }

        ListItem() {
          this.ListItemView($r('app.media.ic_mine_info'), '关于我们')
        }

        ListItem() {
          this.ListItemView($r('app.media.ic_mine_setting'), '设置', async () => {
              ToastUtils.showToast("设置")
          })
        }
      }
      .borderRadius(dp(8))
      .backgroundColor('#fff')
      .divider({ strokeWidth: 0.5, color: $r('app.color.gray_bg') })
    }
    .linearGradient({
      colors: [[this.colorMode === 1 ? '#FFB071' : '#ff8533', 0], [$r('app.color.common_gray_bg'), 0.3], [$r('app.color.common_gray_bg'), 1]]
    })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.gray_bg'))
    .padding(dp(15))
  }

  @Builder
  ListItemView(img: Resource, title: string, callback?: () => {}) {
    Row() {
      Image(img)
        .width(dp(20))
        .aspectRatio(1)
      Text(title)
        .fontSize(dp(15))
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .padding({ left: dp(5) })
      Image($r('app.media.icon_my_arrow'))
        .fillColor('#C3C3C5')
        .width(dp(18))
        .height(dp(18))
    }
    .width('100%')
    .height(dp(44))
    .padding({ left: dp(15), right: dp(15) })
    .onClick(callback)
  }

  @Builder
  GridItemView(icon: Resource, title: string) {
    Column() {
      Image(icon)
        .width(dp(30))
        .aspectRatio(1)
        .objectFit(ImageFit.Fill)
      Text(title)
        .fontColor($r('app.color.gray'))
        .fontSize(dp(13))
    }
  }
}
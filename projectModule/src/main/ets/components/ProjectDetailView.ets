import router from '@ohos.router'
import { ProjectItemModel } from '../models/ProjectItemModel'
import { SearchView } from '../../../../../commonModule/src/main/ets/components/SearchView'
import { AuthorUtils } from '../../../../../commonModule/src/main/ets/utils/AuthorUtils'
import { BasicConstant } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { HomeTypeView } from '../../../../../commonModule/src/main/ets/components/HomeTypeView'
import window from '@ohos.window'
/**
 * @desc:项目详情页
* @author:hxy
 * @time:2024/3/19
 */
@Component
export struct ProjectDetailView {
  @State
  item: ProjectItemModel = {} as ProjectItemModel
  // 0 默认 21 降序 20 升序
  @State
  sort: number = 0
  // 可选排序
  sortArr: number[] = [0, 21, 20]

  aboutToAppear() {
    const params = router.getParams() as ProjectItemModel
    if (params) {
      this.item = params
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.project_bg'))
          .width('100%')
          .height(dp(236))
          .opacity(0.2)
        Column() {
          Row() {
            Image($r('app.media.ic_common_back'))
              .size({ width: dp(24), height: dp(24) })
              .fillColor($r('app.color.common_gray_01'))
              .onClick(() => router.back())
            Blank()
            SearchView({ val: '', bg: 'rgba(246, 247, 249, 0.5)', color: '#333333' })
              .width(dp(120))
              .onClick(() => {
                interface Params {
                  type: number
                  questionBankType: 9 | 10
                }

                AuthorUtils.pushUrl({
                  url: 'pages/SearchPage',
                  params: ({ questionBankType: 10, type: this.item.id }) as Params
                })
              })
          }
          .height(56)
          .width('100%')
          .padding({ left: dp(16), right: dp(16) })

          Row({ space: BasicConstant.SPACE_LG }) {
            Image(this.item.icon)
              .width(dp(86))
              .height(dp(114))
              .sharedTransition(this.item.id.toString(), { duration: 300 })
            Column({ space: BasicConstant.SPACE_LG }) {
              Text(this.item.name)
                .fontWeight(500)
                .fontColor(Color.White)
              Text(this.item.describeInfo)
                .fontSize($r('app.float.common_font14'))
                .fontColor(Color.White)
              Blank()
              Text('学习进度：10%')
                .fontColor($r('app.color.common_gray_01'))
                .fontSize($r('app.float.common_font14'))
            }
            .layoutWeight(1)
            .height(dp(114))
            .alignItems(HorizontalAlign.Start)
          }
          .padding({ top: dp(20), left: dp(16), right: dp(16) })
          .alignItems(VerticalAlign.Top)
          .width('100%')
        }
      }
      .width('100%')
      .height(dp(210))

      Column() {
        Row({ space: BasicConstant.SPACE_MD }) {
          Text('问题列表')
            .fontWeight(500)
          Blank()
          Row() {
            Text('浏览量')
              .fontSize($r('app.float.common_font14'))
              .fontColor(this.sort > 0 ? $r('app.color.common_main_color') : $r('app.color.black'))
            // Column() {
            //   Image($r('sys.media.ohos_ic_public_arrow_up'))
            //     .size({ width: 16, height: 6 })
            //     .fillColor(this.sort === 20 ? $r('app.color.common_main_color') : $r('app.color.black'))
            //   Image($r('sys.media.ohos_ic_public_arrow_down'))
            //     .size({ width: 16, height: 6 })
            //     .fillColor(this.sort === 21 ? $r('app.color.common_main_color') : $r('app.color.black'))
            // }
            // .alignItems(HorizontalAlign.Start)
          }
          .onClick(() => {
            const index = this.sortArr.findIndex(i => i === this.sort)
            this.sort = this.sortArr[(index + 1) % this.sortArr.length]
          })
        }
        .height(44)
        .width('100%')
        .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16') })
        .border({
          width: { bottom: dp(0.3) },
          color: $r('app.color.common_gray_border')
        })

        Column() {
          HomeTypeView({
            currentPosition: -1,
            type: this.item.id,
            sort: this.sort
          })
        }
        .layoutWeight(1)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .width('100%')
      .borderRadius({ topLeft: 16, topRight: 16 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#5D2B05')
  }
}
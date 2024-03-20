/*
 * @desc:首页
 * @author:hxy
 * @date:2024/2/17
 */
import emitter from '@ohos.events.emitter'
import { BasicConstant, TYPE_LIST, USER_KEY } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { QuestionTypeModel } from '../../../../../commonModule/src/main/ets/models/QuestionTypeModel'
import { UserModel } from '../../../../../commonModule/src/main/ets/models/UserModel'
import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { LOGIN_EVENT } from '../../../../../entry/src/main/ets/event/event'
import { BannerView } from '../view/BannerView'
import { HomeTypeView } from '../../../../../commonModule/src/main/ets/components/HomeTypeView'
import { SkeletonView } from '../../../../../commonModule/src/main/ets/components/SkeletonView'
import { HotQuestionView } from '../../../../../commonModule/src/main/ets/components/HotQuestionView'
import { ClockView } from '../../../../../commonModule/src/main/ets/components/ClockView'
import { SearchView } from '../../../../../commonModule/src/main/ets/components/SearchView'
import { HomeViewModel } from '../viewmodel/HomeViewModel'
import { HomeDayQuestionComp } from './HomeDayQuestionComp'

@Component
export struct HomePage {
  @State
  mData: QuestionTypeModel[] = []
  @State
  isLoading: boolean = false
  @StorageProp(USER_KEY)
  @Watch('updateUser')
  userJson: string = '{}'
  @State
  user: UserModel = JSON.parse(this.userJson)
  @State
  currentPosition: number = 0
  mViewModel: HomeViewModel = new HomeViewModel()

  updateUser() {
    this.user = JSON.parse(this.userJson)
  }

  aboutToAppear() {
    this.getQuestionList()
    emitter.on(LOGIN_EVENT, () => {
      this.getQuestionList()
    })
  }

  async getQuestionList() {
    this.isLoading = true
    this.mViewModel.getQuestionTypeList()
      .then((res) => {
        this.mData = res.data
        this.isLoading = false
      })
      .catch((e) => {
        setTimeout(() => {
          this.mData = JSON.parse(TYPE_LIST) as QuestionTypeModel[]
          this.isLoading = false
        }, 2000)
      })
  }

  build() {
    Column() {
      Row({ space: dp(15) }) {
        SearchView({ val: '', bg: 'rgba(246, 247, 249, 0.5)', color: '#333333' })
        ClockView({ clockCount: this.user.clockinNumbers || 0 })
      }
      .padding(dp(15))
      .width('100%')
      .height(dp(50))

      BannerView()
      HomeDayQuestionComp()

      Text('热门题库')
        .width('100%')
        .fontWeight(500)
        .padding({ left: BasicConstant.SPACE_LG, bottom: BasicConstant.SPACE_MD })
      Scroll() {
        Row({ space: BasicConstant.SPACE_MD }) {
          HotQuestionView({ linearColor: 0, title: '鸿蒙NEXT', subTitle: '面通热门题单' })
          HotQuestionView({ linearColor: 1, title: '企业题库', subTitle: '2000+ 企业面试题' })
          HotQuestionView({ linearColor: 2, title: '程序员面试经典', subTitle: '独家授权' })
          HotQuestionView({ linearColor: 3, title: '前端题单', subTitle: '面通热门题单' })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16, bottom: 12 })
      .edgeEffect(EdgeEffect.Spring)

      if (this.isLoading) {
        this.SkeletonBuilder()
      } else {
        Tabs() {
          ForEach(this.mData, (item: QuestionTypeModel, index) => {
            TabContent() {
              HomeTypeView({
                mViewModel: this.mViewModel,
                currentPosition: this.currentPosition,
                type: item.id ?? 0,
                index: index
              })
            }.tabBar(this.QuestionTabBar(item, index))
          })
        }
        .barMode(BarMode.Scrollable)
        .padding({ left: dp(15) })
        .onChange(index => this.currentPosition = index)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SkeletonBuilder() {
    Column() {
      Row({ space: dp(15) }) {
        SkeletonView()
        SkeletonView({ widthValue: dp(60) })
        SkeletonView({ widthValue: dp(80) })
      }
      .width('100%')
      .margin({ bottom: dp(15) })

      List({ space: dp(15) }) {
        ForEach([1, 2, 3, 4, 5, 6, 7], () => {
          ListItem() {
            Column({ space: dp(15) }) {
              Row({ space: dp(15) }) {
                SkeletonView({ widthValue: dp(30) })
                SkeletonView({ widthValue: '100%' }).layoutWeight(1)
              }

              Row({ space: dp(15) }) {
                SkeletonView({ widthValue: dp(50) })
                SkeletonView({ widthValue: dp(50) })
                SkeletonView({ widthValue: dp(50) })
              }
              .width('100%')
            }
            .padding({ top: dp(10), bottom: dp(10) })
          }
        })
      }
      .divider({ strokeWidth: 0.5, color: $r('app.color.gray_bg') })
    }
    .width('100%')
    .padding(dp(15))
    .layoutWeight(1)
  }

  @Builder
  QuestionTabBar(item: QuestionTypeModel, index: number) {
    Row() {
      Text(item.name)
        .fontSize(dp(18))
        .fontColor(this.currentPosition === index ? $r('app.color.black') : $r('app.color.gray'))
      if (item.displayNewestFlag === 1) {
        Image($r('app.media.new'))
          .width(dp(34))
          .height(dp(14))
          .padding({ left: dp(5) })
      }
    }
    .padding({ right: 15 })
  }
}
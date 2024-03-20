/*
 * @desc:首页统计打卡天数的view
 * @author:hxy
 * @date:2024/2/17
 */
import { USER_KEY } from '../constants/Constants'
import { UserModel } from '../models/UserModel'
import { AuthorUtils } from '../utils/AuthorUtils'
import { dp } from '../utils/DispalyUtils'
import { HttpUtils } from '../utils/HttpUtils'

@Component
export struct ClockView {
  @Prop
  clockCount: number
  @StorageProp(USER_KEY)
  @Watch('updateUser')
  userJson: string = '{}'
  @State
  user: UserModel = JSON.parse(this.userJson)

  updateUser() {
    this.user = JSON.parse(this.userJson)
  }

  aboutToAppear() {
    if (this.user.token) {
      HttpUtils.get<UserModel>('userInfo')
        .then(res => {
          const { nickName, clockinNumbers, totalTime, avatar } = res.data
          AuthorUtils.setUser({
            ...this.user,
            nickName,
            clockinNumbers,
            totalTime,
            avatar
          })
        })
        .catch((e) => {

        })
    }
  }

  build() {
    Stack() {
      Image(this.clockCount > 0 ? $r('app.media.clocked') : $r('app.media.unclock'))
        .objectFit(ImageFit.Fill)
      if (this.clockCount > 0) {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
          Text() {
            Span(this.clockCount.toString())
              .fontWeight(600)
              .fontSize(12)
            Span(' 天')
              .fontSize(10)
          }
        }
        .width('50')
      } else {
        Text('打卡')
          .width(dp(50))
          .textAlign(TextAlign.Center)
          .fontSize(dp(18))
          .fontWeight(500)
          .fontColor('#333C4F')
          .margin({ left: 20 })
      }
    }
    .width(dp(78))
    .height(dp(28))
  }
}
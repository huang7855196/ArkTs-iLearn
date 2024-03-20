/**
 * @desc:登录页内容
 * @author:hxy
 * @time:2024/2/18
 */
import { dp } from '../utils/DispalyUtils'
import { HttpUtils } from '../utils/HttpUtils'
import { ToastUtils } from '../utils/ToastUtils'
import emitter from '@ohos.events.emitter'
import router from '@ohos.router'
import { LOGIN_EVENT } from '../../../../../entry/src/main/ets/event/event'
import { PASSWORD, USER_MODEL, USER_NAME } from '../constants/Constants'
import { UserModel } from '../models/UserModel'
import { AuthorUtils } from '../utils/AuthorUtils'
@Component
export struct LoginComp {
  @State
  username: string = 'xiaofeiyang'
  @State
  password: string = 'xiaofeiyang123'
  @State
  isAgree: boolean = false
  @State
  loading: boolean = false

  build() {
    Navigation() {
      Column() {
        Image($r('app.media.icon'))
          .width(dp(120))
          .aspectRatio(1)
        Text("面试宝典")
          .fontSize(dp(28))
        Text('搞定企业面试真题，就用面试宝典')
          .fontSize(dp(14))
          .fontColor($r('app.color.gray'))
          .margin({ top: dp(14) })

        Column() {
          TextInput({ placeholder: '请输入用户名', text: this.username })
            .customStyle()
            .onChange(val => this.username = val)
          TextInput({ placeholder: '请输入密码', text: this.password })
            .customStyle()
            .type(InputType.Password)
            .onChange(val => this.password = val)
          Row() {
            Checkbox()
              .selectedColor('#fa711d')
              .width(dp(14))
              .aspectRatio(1)
              .select(this.isAgree)
              .onChange((val) => {
                this.isAgree = val
              })
            Row({ space: dp(4) }) {
              Text('已阅读并同意')
                .fontSize(dp(14))
                .fontColor($r('app.color.gray'))
              Text('用户协议')
                .fontSize(dp(14))
                .onClick(() => {

                })
              Text('和')
                .fontSize(dp(14))
                .fontColor($r('app.color.gray'))
              Text('隐私政策')
                .fontSize(dp(14))
                .onClick(() => {

                })
            }
          }
          .width('100%')

          Button({ type: ButtonType.Normal }) {
            Row() {
              if (this.loading) {
                LoadingProgress()
                  .color('#ffffff')
                  .width(dp(24))
                  .height(dp(24))
                  .margin({ right: dp(10) })
              }
              Text('立即登录').fontColor('#ffffff')
            }
          }
          .borderRadius(dp(4))
          .backgroundColor('transparent')
          .linearGradient({
            direction: GradientDirection.Right,
            colors: [['#fc9c1c', 0], ['#fa711d', 1]]
          })
          .stateEffect(false)
          .width('100%')
          .height(dp(44))
          .margin({ top: dp(24) })
          .onClick(() => {
            this.doLogin()
          })
        }
        .padding(dp(30))

        Text('其他登录方式')
          .fontSize(dp(14))
          .fontColor($r('app.color.gray'))
          .padding({ top: dp(70), bottom: dp(100) })
          .onClick(() => {
            ToastUtils.showToast("其他方式登录")
          })

      }
      .width('100%')
      .aspectRatio(1)
      .padding({ top: dp(70) })
    }
    .titleMode(NavigationTitleMode.Mini)
  }
  //执行登录操作
  doLogin() {
    if (!this.username) {
      ToastUtils.showToast("用户名不能为空")
      return
    }
    if (!this.password) {
      ToastUtils.showToast("密码不能为空")
      return
    }
    if (!this.isAgree) {
      ToastUtils.showToast("请勾选我已阅读和同意")
      return
    }
    this.loading = true
    HttpUtils.post<UserModel>('login', {
      username: USER_NAME,
      password: PASSWORD
    }).then((res) => {
      this.loading = false
      AuthorUtils.setUser(res.data)
      emitter.emit(LOGIN_EVENT)
      const params = router.getParams()
      if (params && params['return_url']) {
        const url = params['return_url']
        delete params['return_url']
        router.replaceUrl({
          url: url,
          params: params
        })
      } else {
        router.back()
      }
      ToastUtils.showToast("登录成功")
    }).catch((e) => {
      try {
        this.loading = false
        const user = JSON.parse(USER_MODEL) as UserModel
        AuthorUtils.setUser(user)
        emitter.emit(LOGIN_EVENT)
        const params = router.getParams()
        if (params && params['return_url']) {
          const url = params['return_url']
          delete params['return_url']
          router.replaceUrl({
            url: url,
            params: params
          })
        } else {
          router.back()
        }
        ToastUtils.showToast("登录成功")
      } catch (e) {
        ToastUtils.showToast(e)
      }
    })
  }
}

//拓展TextInput的属性，实现共用
@Extend(TextInput) function customStyle() {
  .height(dp(44))
  .borderRadius(dp(2))
  .backgroundColor('#ffffff')
  .border({ width: { bottom: 0.5 }, color: '#e4e4e4' })
  .padding({ left: 0 })
  .placeholderColor('#C3C3C5')
  .caretColor('#fa711d')
}

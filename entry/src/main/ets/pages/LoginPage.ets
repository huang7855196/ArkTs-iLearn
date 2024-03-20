import { LoginComp } from "../../../../../commonModule/src/main/ets/components/LoginComp"
/**
 * @desc:登录页
* @author:hxy
 * @time:2024/2/18
 */
@Entry
@Component
struct LoginPage {
  build() {
    Stack() {
      LoginComp()
    }
    .width('100%')
    .height('100%')
  }
}
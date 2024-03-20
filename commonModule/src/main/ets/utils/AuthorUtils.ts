import router from '@ohos.router'
import { PASS_LIST, USER_KEY } from '../constants/Constants'
import { UserModel } from '../models/UserModel'
import { ToastUtils } from './ToastUtils'
/*
 * @desc:用户信息工具类
 * @author:hxy
 * @date:2024/2/17
 */
export class AuthorUtils {
  static initLocalUser() {
    PersistentStorage.PersistProp(USER_KEY, '{}')
  }

  static setUser(user: UserModel) {
    const result = AppStorage.Set(USER_KEY, JSON.stringify(user))
    ToastUtils.showToast(`${result}`)
  }

  static getUser() {
    const user = AppStorage.Get<string>(USER_KEY) || "{}"
    return JSON.parse(user) as UserModel
  }

  static delUser() {
    AppStorage.Set(USER_KEY, '{}')
  }

  static pushUrl(options: router.RouterOptions) {
    const user = this.getUser()
    if (PASS_LIST.concat(options.url) && !user.token) {
      router.pushUrl({
        url: 'pages/LoginPage',
        params: {
          ...options.params,
          return_url: options.url
        }
      }, router.RouterMode.Single)
      return false
    }
    router.pushUrl(options)
  }
}
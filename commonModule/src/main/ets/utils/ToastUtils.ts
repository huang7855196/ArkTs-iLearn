import promptAction from '@ohos.promptAction'

/*
 * @desc:toast工具
 * @author:hxy
 * @date:2024/2/17
 */
export class ToastUtils {
  static showToast(message: string) {
    promptAction.showToast({ message: message })
  }
}
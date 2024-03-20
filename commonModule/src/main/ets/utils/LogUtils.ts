
import hilog from '@ohos.hilog'
const DO_MAIN = 0X22
const TAG = "it"
/*
 * @desc:日志工具
 * @author:hxy
 * @date:2024/2/17
 */
export class LogUtils {
  static i(msg: string) {
    hilog.info(DO_MAIN, TAG, msg)
  }

  static w(msg: string) {
    hilog.warn(DO_MAIN, TAG, msg)
  }

  static d(msg: string) {
    hilog.debug(DO_MAIN, TAG, msg)
  }

  static e(msg: string) {
    hilog.error(DO_MAIN, TAG, msg)
  }

  static f(msg: string) {
    hilog.fatal(DO_MAIN, TAG, msg)
  }
}
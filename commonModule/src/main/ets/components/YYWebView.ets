import webview from '@ohos.web.webview'
import { LogUtils } from '../utils/LogUtils'

@Component
export struct YYWebView {
  src: ResourceStr = $rawfile('detail.html')
  onLoad: () => void = () => {
  }
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    Web({ src: this.src, controller: this.controller })
      .javaScriptAccess(true)
      .onPageEnd(() => {
        this.onLoad()
      })
      .onErrorReceive(event => {
        LogUtils.e(event!.error.getErrorInfo())
      })
      .layoutWeight(1)
  }
}
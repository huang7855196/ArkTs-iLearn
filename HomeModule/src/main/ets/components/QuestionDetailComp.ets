import { TagView } from '../../../../../commonModule/src/main/ets/components/TagView'
import { TitleBarView } from '../../../../../commonModule/src/main/ets/components/TitleBarView'
import { DetailParams, QuestionDetail } from '../../../../../commonModule/src/main/ets/models/QuestionItemModel'
import router from '@ohos.router'
import { HomeViewModel } from '../viewmodel/HomeViewModel'
import webview from '@ohos.web.webview'
import { ToastUtils } from '../../../../../commonModule/src/main/ets/utils/ToastUtils'

/**
 * @desc:问题详情页
* @author:hxy
 * @time:2024/3/19
 */
@Component
export struct QuestionDetailComp {
  @State
  item: QuestionDetail = {} as QuestionDetail
  @State
  list: QuestionDetail[] = []
  @State
  index: number = 0
  mViewModel: HomeViewModel = new HomeViewModel()
  controller: webview.WebviewController = new webview.WebviewController()

  aboutToAppear() {
    const params = router.getParams() as DetailParams
    if (params) {
      this.item = params.item as QuestionDetail
      this.list = params.list as QuestionDetail[]
      this.index = this.list.findIndex(item => item.id === this.item.id)
      this.getData()
    }
  }

  getData() {
    this.mViewModel.getQuestionDetail(this.item.id)
      .then(res => {
        this.item = res.data
        this.list[this.index] = res.data

      })
      .catch(e => {

      })
  }

  build() {
    Column() {
      TitleBarView({ title: "试题详情", showRightIcon: false })
      this.TitleBuilder("题目")
      Text(this.item.stem.trim())
        .width('100%')
        .padding(15)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row() {
        ForEach(this.item.stage, (tag: string) => {
          TagView({ text: tag })
            .margin({ right: 5 })
        })
        Blank()
        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .width('100%')
      .padding({ bottom: 15, left: 15, right: 15 })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))

      this.TitleBuilder('答案：')

      Web({ src: $rawfile('detail.html'), controller: this.controller })
        .javaScriptAccess(true)
        .onPageEnd(() => {
          this.controller.runJavaScript(`writeContent(\`${this.item.answer || ''}\`)`)
        })
        .layoutWeight(1)

      Row({ space: 50 }) {
        Row() {
          Text(' 上一题')
            .fontColor(this.index <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.prev()
        })

        Row() {
          Text('下一题 ')
            .fontColor(this.index >= this.list.length - 1 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.next()
        })
      }
      .height(44)
      .width('100%')
      .justifyContent(FlexAlign.Center)

    }
  }

  prev() {
    if (this.index <= 0) {
      ToastUtils.showToast("已经是第一题了")
      return
    }
    this.index--
    this.toggleData()
  }

  next() {
    if (this.index >= this.list.length - 1) {
      ToastUtils.showToast("已经是最后一题了")
      return
    }
    this.index++
    this.toggleData()
  }

  async toggleData() {
    // 切换
    const newItem = this.list[this.index]
    this.item.id = newItem.id
    if (!newItem.answer) {
      await this.getData()
    } else {
      this.item = newItem
      this.controller.runJavaScript(`writeContent(\`${this.item.answer || ''}\`)`)
    }
  }

  @Builder
  TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor('#121826')
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag === 0 ? '点赞' : '取消点赞' })
        .onClick(() => {
          this.opt(1, this.item.likeFlag === 1 ? 0 : 1)
        })
      MenuItem({ content: this.item.collectFlag === 0 ? '收藏' : '取消收藏' })
        .onClick(() => {
          this.opt(2, this.item.collectFlag === 1 ? 0 : 1)
        })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
    }
    .width(108)
  }
  /**
   * 操作:点赞、收藏
   * @param type = 1 | 2
   */
  async opt(optType: 1 | 2, flag: 0 | 1) {
    // try {
    //   let data: OptPrams = {
    //     id: this.item.id,
    //     type: 0,
    //     optType
    //   }
    //   await hdHttp.post<null>(flag === 1 ? 'question/opt' : 'question/unOpt', data)
    //   if (optType === 1) {
    //     this.item.likeFlag = flag
    //     return promptAction.showToast({ message: flag === 1 ? '点赞成功' : '取消点赞' })
    //   }
    //   if (optType === 2) {
    //     this.item.collectFlag = flag
    //     return promptAction.showToast({ message: flag === 1 ? '收藏成功' : '取消收藏' })
    //   }
    // } catch (err) {
    //   logger.error(err.message)
    //   promptAction.showToast({ message: '操作失败' })
    // }
  }
}
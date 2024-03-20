/*
 * @desc:首页里面问题列表
 * @author:hxy
 * @date:2024/2/17
 */
import { LazyDataSource } from '../utils/LazyDataSource'
import { dp } from '../utils/DispalyUtils'
import { LogUtils } from '../utils/LogUtils'
import { TagView } from './TagView'
import { QueryQuestionListParams, QuestionItemModel } from '../models/QuestionItemModel'
import { HomeViewModel } from '../../../../../HomeModule/src/main/ets/viewmodel/HomeViewModel'
import { DetailParams } from '../models/QuestionItemModel'
import { AuthorUtils } from '../utils/AuthorUtils'

@Component
export struct HomeTypeView {
  @Prop
  @Watch('initQuestionList')
  currentPosition: number
  @Prop
  type: number
  index: number = -1
  @State
  finished: boolean = false
  @State
  loading: boolean = false
  @Prop
  @Watch('reLoad')
  sort: number
  questionListDataSource = new LazyDataSource<QuestionItemModel>()
  mViewModel: HomeViewModel = new HomeViewModel()
  params: QueryQuestionListParams = {
    questionBankType: 10,
    page: 1,
    type: this.type,
    sort: this.sort
  }

  reLoad() {
    this.questionListDataSource.cleanData()
    this.initQuestionList()
  }

  aboutToAppear() {
    this.initQuestionList()
  }

  initQuestionList() {
    if (this.currentPosition == this.index && this.questionListDataSource.totalCount() == 0) {
      this.getQuestionList()
    }
  }
  //获取列表数据
  async getQuestionList() {
    if (this.loading || this.finished) return
    this.loading = true
    this.mViewModel.getQuestionList(this.params)
      .then((res) => {
        this.loading = false
        res.data.rows.forEach((item, index) => {
          this.questionListDataSource.pushData(item)
        })
        if (res.data.total == this.questionListDataSource.totalCount()) {
          this.finished = true
        } else {
          this.params.page++
        }
      })
      .catch((e) => {
        LogUtils.e(`${e}`)
      })
  }

  @Builder
  LoadingBuilder() {
    if (this.finished) {
      Row() {
        Text('没有更多了~')
          .fontColor($r('app.color.gray'))
          .fontSize(dp(14))
      }
      .width('100%')
      .height(dp(50))
      .justifyContent(FlexAlign.Center)
    } else {
      if (this.loading) {
        Row() {
          LoadingProgress()
            .width(dp(24))
            .margin({ right: dp(5) })
          Text('加载中...')
            .fontColor($r('app.color.gray'))
            .fontSize(dp(14))
        }
        .width('100%')
        .height(dp(50))
        .justifyContent(FlexAlign.Center)
      }
    }
  }

  build() {
    List() {
      LazyForEach(this.questionListDataSource, (item: QuestionItemModel, index: number) => {
        ListItem() {
          this.HomeTypeItem(item)
        }
      })
      ListItem() {
        this.LoadingBuilder()
      }
    }
    .divider({
      strokeWidth: 0.5,
      color: $r('app.color.gray_bg')
    })
    .height('100%')
    .width('100%')
    .padding({ left: dp(14), right: dp(14) })
    .onScrollIndex((start, end) => {
      LogUtils.i(`end = ${end}`)
      //加载到倒数第三条的时候提前加载下一页
      if (end === this.questionListDataSource.totalCount() - 3) {
        this.getQuestionList()
      }
    })
    // .onReachEnd(() => {
    //   this.getQuestionList()
    // })
  }

  @Builder
  HomeTypeItem(itemModel: QuestionItemModel) {
    Column() {
      Row() {
        TagView({ difficulty: itemModel.difficulty })
        Text(itemModel.stem)
          .fontSize(dp(15))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }.width('100%')

      Row() {
        this.TextBuilder(`点赞 ${itemModel.likeCount}`)
        this.SplitBuilder()
        this.TextBuilder(`浏览 ${itemModel.views}`)
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .height(dp(80))
    .width('100%')
    .margin({ top: 10 })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      const params: DetailParams = { item: itemModel, list: this.questionListDataSource.getDatas() }
      AuthorUtils.pushUrl({
        url: 'pages/QuestionDetailPage',
        params: params
      })
    })
  }

  @Builder
  SplitBuilder() {
    Text('|')
      .width(dp(30))
      .textAlign(TextAlign.Center)
      .fontColor('#C3C3C5')
      .fontSize(dp(12))
  }

  @Builder
  TextBuilder(text: string) {
    Text(text)
      .fontColor('#C3C3C5')
      .fontSize(dp(12))
  }
}
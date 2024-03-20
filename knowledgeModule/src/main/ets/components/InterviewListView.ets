import { BasicConstant } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { TagView } from '../../../../../commonModule/src/main/ets/components/TagView'
import { LazyDataSource } from '../../../../../commonModule/src/main/ets/utils/LazyDataSource'
import { InterviewItemModel } from '../model/InterviewItemModel'
import { InterviewViewModel } from '../viewmodel/InterviewViewModel'
import { AuthorUtils } from '../../../../../commonModule/src/main/ets/utils/AuthorUtils'

/**
 * @desc:面经列表
* @author:hxy
 * @time:2024/3/18
 */
@Component
export struct InterviewListView {
  mViewModel: InterviewViewModel = new InterviewViewModel()
  mDataSource = new LazyDataSource()
  @State
  page: number = 1
  @State
  keyword: string = ''
  @Prop
  @Watch('onUpdate')
  sort: number

  onUpdate() {
    this.page = 1
    this.getInterviewList()
  }

  aboutToAppear() {
    this.getInterviewList()
  }

  getInterviewList() {
    this.mViewModel.getInterviewList({
      questionBankType: 9,
      page: this.page,
      sort: this.sort,
      keyword: this.keyword
    })
      .then((res) => {
        res.data.rows.forEach(item => {
          this.mDataSource.pushData(item)
        })
      })
      .catch(e => {

      })
  }

  build() {
    List() {
      LazyForEach(this.mDataSource, (item: InterviewItemModel, index: number) => {
        ListItem() {
          this.InterviewItemView(item)
        }
      })
    }
  }
  //列表item
  @Builder
  InterviewItemView(item: InterviewItemModel) {
    Column({ space: 12 }) {
      Row() {
        Image(item.creatorAvatar)
          .width(dp(36))
          .aspectRatio(1)
        Column() {
          Text(item.stem)
            .fontWeight(600)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor($r('app.color.black'))
          Text() {
            Span(item.creatorName)
            Span(' · ')
            Span(item.createdAt)
          }
          .fontSize(dp(10))
          .fontColor('#bdbdbd')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .padding({ left: dp(8) })

        Image($r('app.media.ic_interview_more'))
          .width(dp(20))
          .aspectRatio(1)
          .alignSelf(ItemAlign.Start)
          .bindMenu(this.menuBuilder())
      }
      .width('100%')

      Text(item.content)
        .fontSize(dp(14))
        .fontColor($r('app.color.common_gray_03'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .lineHeight(20)
        .width('100%')

      Row({ space: BasicConstant.SPACE_SM }) {
        ForEach(['大厂', '面经'], (tag: string) => {
          TagView({ text: tag })
        })
      }
      .width('100%')

      Text() {
        Span('点赞 ' + item.likeCount)
        Span(' · ')
        Span('浏览 ' + item.views)
        if (item.likeFlag === 1) {
          Span(' · ')
          Span('已点赞')
        }
      }
      .width('100%')
      .fontSize(dp(12))
      .fontColor('#bdbdbd')
    }
    .padding(dp(15))
    .onClick(() => {
      AuthorUtils.pushUrl({ url: 'pages/InterviewDetailPage', params: item })
    })
  }

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: '屏蔽' }).width(dp(64))
      MenuItem({ content: '举报' }).width(dp(64))
    }
  }
}
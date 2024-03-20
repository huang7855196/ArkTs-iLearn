import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { ProjectViewModel } from '../viewmodel/ProjectViewModel'
import { LazyDataSource } from '../../../../../commonModule/src/main/ets/utils/LazyDataSource'
import { ProjectItemModel, ProjectTag } from '../models/ProjectItemModel'
import router from '@ohos.router'
import { BasicConstant } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { TagView } from '../../../../../commonModule/src/main/ets/components/TagView'
/*
 * @desc:项目
 * @author:hxy
 * @date:2024/2/17
 */

@Component
export struct ProjectComp {
  mViewModel: ProjectViewModel = new ProjectViewModel()
  projectListDataSource = new LazyDataSource<ProjectItemModel>()

  aboutToAppear() {
    this.mViewModel.getProjectList()
      .then((res) => {
        res.data.forEach((item) => {
          this.projectListDataSource.pushData(item)
        })
      })
      .catch((e) => {

      })
  }

  @Builder
  ProjectItemBuilder(item: ProjectItemModel) {
    Row() {
      Image(item.icon)
        .width(dp(60))
        .height(dp(80))
        .sharedTransition(item.id.toString(), { duration: 300 })
      Column({ space: BasicConstant.SPACE_SM }) {
        Text(item.name)
          .fontWeight(500)
        Text(item.describeInfo)
          .fontSize(dp(12))
          .fontColor($r('app.color.common_gray_02'))
        Blank()
        Row({ space: 4 }) {
          ForEach(item.tags, (tag: ProjectTag) => {
            TagView({ text: tag.tagName })
          })
        }
      }
      .layoutWeight(1)
      .height(80)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: dp(8) })
    }
    .padding({
      top: dp(16),
      bottom: dp(16)
    })
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      router.pushUrl({ url: 'pages/ProjectDetailPage', params: item })
    })
  }

  build() {
    Column() {
      Text($r('app.string.project'))
        .height(dp(44))
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontWeight(500)
        .border({
          width: { bottom: dp(0.5) },
          color: $r('app.color.common_gray_border')
        })
      List() {
        LazyForEach(this.projectListDataSource, (item: ProjectItemModel, index: number) => {
          ListItem() {
            this.ProjectItemBuilder(item)
          }
        })
      }.divider({
        strokeWidth: dp(0.5),
        color: $r('app.color.common_gray_02')
      })
      .padding({
        left: dp(16),
        right: dp(16)
      })
    }
    .width('100%')
    .height('100%')
  }
}
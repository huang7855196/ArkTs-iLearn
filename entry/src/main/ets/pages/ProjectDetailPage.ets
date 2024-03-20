import { ProjectDetailView } from '../../../../../projectModule/src/main/ets/components/ProjectDetailView'

@Entry
@Component
struct ProjectDetailPage {
  @State message: string = 'ProjectDetailPage'

  build() {
    Row() {
      ProjectDetailView()
    }
    .height('100%')
  }
}
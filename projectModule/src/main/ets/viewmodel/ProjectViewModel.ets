import { HttpUtils } from '../../../../../commonModule/src/main/ets/utils/HttpUtils'
import { ProjectItemModel } from '../models/ProjectItemModel'

export class ProjectViewModel {
  getProjectList() {
    return HttpUtils.get<ProjectItemModel[]>('question/type', { type: 'items' })
  }
}
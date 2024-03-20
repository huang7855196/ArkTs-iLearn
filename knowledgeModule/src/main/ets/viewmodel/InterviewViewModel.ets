import { HttpUtils } from '../../../../../commonModule/src/main/ets/utils/HttpUtils'
import { InterviewItem, InterviewItemModel, InterviewListParams } from '../model/InterviewItemModel'

export class InterviewViewModel {
  getInterviewList(params: InterviewListParams) {
    return HttpUtils.get<{
      total: number
      pageTotal: number
      rows: InterviewItemModel[]
    }>('question/list', params)
  }

  getInterviewDetail(id: string) {
    return HttpUtils.get<InterviewItem>(`question/${id}`)
  }
}
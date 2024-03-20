/**
 * @desc:首页控制类
* @author:hxy
 * @time:2024/2/18
 */
import { QuestionTypeModel } from '../../../..'
import {
  QueryQuestionListParams,
  QuestionDetail,
  QuestionItemModel
} from '../../../../../commonModule/src/main/ets/models/QuestionItemModel'
import { HttpUtils } from '../../../../../commonModule/src/main/ets/utils/HttpUtils'

export class HomeViewModel {
  //获取首页type列表
  getQuestionTypeList() {
    return HttpUtils.get<QuestionTypeModel[]>('question/type')
  }
  //获取首页列表数据
  getQuestionList(params: QueryQuestionListParams) {
    return HttpUtils.get<{
      total: number
      pageTotal: number
      rows: QuestionItemModel[]
    }>('question/list', params)
  }

  getQuestionDetail(id: string) {
    return HttpUtils.get<QuestionDetail>(`question/${id}`)
  }
}
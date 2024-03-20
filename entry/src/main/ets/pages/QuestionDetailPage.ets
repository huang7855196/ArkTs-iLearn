/*
 * @desc:问题详情页
 * @author:hxy
 * @date:2024/2/18
 */
import { QuestionDetailComp } from '../../../../../HomeModule/src/main/ets/components/QuestionDetailComp'

@Entry
@Component
struct QuestionDetailPage {
  build() {
    Column() {
      QuestionDetailComp()
    }
    .height('100%')
  }
}
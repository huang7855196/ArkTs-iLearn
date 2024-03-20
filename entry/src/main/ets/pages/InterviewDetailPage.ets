import { InterviewDetailComp } from '../../../../../knowledgeModule/src/main/ets/components/InterviewDetailComp'
/**
 * @desc:面经详情页
* @author:hxy
 * @time:2024/3/19
 */
@Entry
@Component
struct InterviewDetailPage {
  @State message: string = 'Hello World'

  build() {
    Stack() {
      InterviewDetailComp()
    }
    .height('100%')
  }
}
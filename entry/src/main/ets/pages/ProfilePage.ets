/**
 * @desc:资料编辑页
* @author:hxy
 * @time:2024/3/19
 */
import { ProfileComp } from '../../../../../mineModule/src/main/ets/components/ProfileComp'
@Entry
@Component
struct ProfilePage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      ProfileComp()
    }
    .height('100%')
  }
}
import { UserModel } from '../../../../../commonModule/src/main/ets/models/UserModel'
import { HttpUtils } from '../../../../../commonModule/src/main/ets/utils/HttpUtils'

export class MineViewModel {
  updateNickName(nickName: string) {
    return HttpUtils.post<null>('userInfo/profile', {
      nickName: nickName
    } as UserModel)
  }
}
/*
 * @desc:用户信息实体
 * @author:hxy
 * @date:2024/3/17
 */
export class UserModel {
  id: string
  username: string
  avatar: string
  token: string
  refreshToken: string
  nickName?: string
  totalTime?: number
  clockinNumbers?: number
}
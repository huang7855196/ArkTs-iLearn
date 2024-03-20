import { LoadingDialog } from '../../../../../commonModule/src/main/ets/components/LoadingDialog'
import { TitleBarView } from '../../../../../commonModule/src/main/ets/components/TitleBarView'
import { BaseURL, USER_KEY } from '../../../../../commonModule/src/main/ets/constants/Constants'
import { UserModel } from '../../../../../commonModule/src/main/ets/models/UserModel'
import { AuthorUtils } from '../../../../../commonModule/src/main/ets/utils/AuthorUtils'
import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
import { ToastUtils } from '../../../../../commonModule/src/main/ets/utils/ToastUtils'
import { MineViewModel } from '../viewmodel/MineViewModel'
import picker from '@ohos.file.picker'
import fileIo from '@ohos.file.fs'
import request from '@ohos.request'
import { LogUtils } from '../../../../../commonModule/src/main/ets/utils/LogUtils'
import { HttpUtils } from '../../../../../commonModule/src/main/ets/utils/HttpUtils'
/**
 * @desc:信息编辑页
* @author:hxy
 * @time:2024/3/19
 */
@Component
export struct ProfileComp {
  @StorageProp(USER_KEY)
  userJson: string = '{}'
  @State
  user: UserModel = JSON.parse(this.userJson)
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: '更新中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  mViewModel: MineViewModel = new MineViewModel()

  build() {
    Column() {
      TitleBarView({ title: '编辑资料', showRightIcon: false })
        .border({
          width: dp(0.5),
          color: $r('app.color.common_gray_bg')
        })
      Row() {
        Text('头像')
        Image(this.user.avatar || $r('app.media.ic_mine_avatar'))
          .alt($r('app.media.ic_mine_avatar'))
          .width(40)
          .aspectRatio(1)
          .borderRadius(20)
          .border({ width: $r('app.float.common_border_width'), color: $r('app.color.common_gray_border') })
          .onClick(() => {
            this.updateAvatar()
          })
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .border({
        width: dp(0.5),
        color: $r('app.color.common_gray_bg')
      })

      Row() {
        Text('昵称')
        TextInput({ text: this.user.nickName })
          .fontColor($r('app.color.common_gray_03'))
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .padding(0)
          .height(dp(60))
          .backgroundColor($r('app.color.white'))
          .borderRadius(0)
          .onChange((value) => this.user.nickName = value)
          .onSubmit(() => {
            this.updateNickName()
          })
          .height(dp(60))
      }
      .width('100%')
      .height(dp(60))
    }
    .padding({ left: dp(16), right: dp(16) })
    .width('100%')
    .height('100%')
  }

  updateAvatar() {
    const photoSelectOptions = new picker.PhotoSelectOptions
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.VIDEO_TYPE
    photoSelectOptions.maxSelectNumber = 1
    const photoPicker = new picker.PhotoViewPicker
    photoPicker.select(photoSelectOptions)
      .then(res => {
        const photoUri = res.photoUris[0]
        // 2. 存储到沙箱中
        const context = getContext(this)
        const fileType = 'jpg'
        const fileName = Date.now() + '.' + fileType
        const copyFilePath = context.cacheDir + '/' + fileName
        const file = fileIo.openSync(photoUri, fileIo.OpenMode.READ_ONLY)
        fileIo.copyFileSync(file.fd, copyFilePath)
        const config: request.UploadConfig = {
          url: BaseURL + 'userInfo/avatar',
          method: 'POST',
          header: {
            'Accept': '*/*',
            'Authorization': `Bearer ${this.user.token}`,
            'Content-Type': 'multipart/form-data'
          },
          files: [
            { name: 'file', uri: `internal://cache/` + fileName, type: fileType, filename: fileName }
          ],
          data: []
        }
        // 4. 开始上传
        this.dialog.open()
        request.uploadFile(context, config, (err, data) => {
          if (err) return LogUtils.e(err.message)
          data.on('complete', () => {
            // 5. 更新头像
            HttpUtils.get<UserModel>('userInfo').then(res => {
              this.user.avatar = res.data.avatar
              AuthorUtils.setUser(this.user)
              ToastUtils.showToast('更新头像成功')
              this.dialog.close()
            })
          })
        })


      })
      .catch(e => {
        ToastUtils.showToast(`${e}`)
      })
  }
  //更新昵称
  updateNickName() {
    this.dialog.open()
    this.mViewModel.updateNickName(this.user.nickName)
      .then(res => {
        ToastUtils.showToast('更新昵称成功')
        AuthorUtils.setUser(this.user)
        this.dialog.close()
      })
      .catch(e => {
        this.dialog.close()
      })
  }
}
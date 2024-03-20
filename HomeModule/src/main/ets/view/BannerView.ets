import { dp } from '../../../../../commonModule/src/main/ets/utils/DispalyUtils'
/*
 * @desc:广告
 * @author:hxy
 * @date:2024/2/17
 */
@Component
export struct BannerView {
  build() {
    Swiper() {
      Flex() {
        Image('/images/banner_ai.png')
          .objectFit(ImageFit.Fill)
      }
      .padding({ left: dp(15), right: dp(15) })

      Flex() {
        Image('/images/banner_pj.png')
          .objectFit(ImageFit.Fill)
      }
      .padding({ left: dp(15), right: dp(15) })

      Flex() {
        Image('/images/banner_qa.png')
          .objectFit(ImageFit.Fill)
      }
      .padding({ left: dp(15), right: dp(15) })
    }
    .autoPlay(true)
    .indicator(false)
    .aspectRatio(2.8)

  }
}
import { dp } from '../utils/DispalyUtils'
@Component
export struct TagView {
  text: string = ''
  difficulty: number = 1


  build() {
    Stack() {
      Text(this.getTag(this.difficulty).text)
        .fontColor(this.getTag(this.difficulty).color)
        .fontSize(dp(10))
        .width(dp(34))
        .height(dp(18))
        .backgroundColor($r('app.color.gray_bg'))
        .borderRadius(dp(2))
        .textAlign(TextAlign.Center)
        .margin({ right: 7 })
    }
  }

  getTag(difficulty: number) {
    if (difficulty === 3 || difficulty === 4) {
      return { text: '一般', color: $r('app.color.blue') }
    } else if (difficulty === 5) {
      return { text: '困难', color: $r('app.color.orange') }
    }
    return { text: '简单', color: $r('app.color.green') }
  }
}
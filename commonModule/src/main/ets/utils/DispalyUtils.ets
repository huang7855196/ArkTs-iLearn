import display from '@ohos.display'

// 设计稿宽度
const designWidth = 375
// 物理像素
const devicePhysics = display.getDefaultDisplaySync().width

export const dp = (originSize: number) => {
  const size = px2vp(devicePhysics) / designWidth * originSize
  return size || originSize
}

export const formatTime = (time: number = 0, hasUnit: boolean = true) => {
  // 一小时内容显示  xxx 分钟
  // 一小时以上显示  xxx 小时  支持一位小数
  if (time < 3600) {
    return String(Math.floor(time / 60)) + (hasUnit ? '分钟' : '')
  } else {
    return String(Math.floor(time / 3600 * 10) / 10) + (hasUnit ? '小时' : '')
  }
}


import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { AuthorUtils } from '../../../../../commonModule/src/main/ets/utils/AuthorUtils';
import { LogUtils } from '../../../../../commonModule/src/main/ets/utils/LogUtils'

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    LogUtils.i('Ability onCreate');
  }

  onDestroy() {
    LogUtils.i('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    LogUtils.i('Ability onWindowStageCreate');

    windowStage.loadContent('pages/MainPage');

  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    LogUtils.i('Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    LogUtils.i('Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    LogUtils.i('Ability onBackground');
  }
}

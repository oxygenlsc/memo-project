import { intl } from '@kit.LocalizationKit';

export class DateUtil {
  static getFormatTimeStr(timestamp: number) {
    const date = new Date(timestamp);
    let dateFormat3 = new intl.DateTimeFormat('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
    let formattedDate3 = dateFormat3.format(date);
    return formattedDate3;
  }

  /* 获取当前时间戳 */
  static getTimeStamp(): number {
    const timeStamp = (new Date()).getTime();
    return timeStamp;
  }
}
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


  // 获取“今天”、“昨天”、“过去一周”、“过去一月”、“几几年”
  static getChineseDay(timestamp: number): string {
    // 一天的毫秒数
    const MS_PER_DAY = 1000 * 60 * 60 * 24;
    const currentTimestamp = Date.now(); // 当前时间戳
    const currentDate = new Date(currentTimestamp);
    const targetDate = new Date(timestamp);

    // 获取日期部分
    const currentYear = currentDate.getFullYear();
    const currentMonth = currentDate.getMonth();
    const currentDay = currentDate.getDate();

    const targetYear = targetDate.getFullYear();
    const targetMonth = targetDate.getMonth();
    const targetDay = targetDate.getDate();

    // 获取小时、分钟和秒
    const currentHours = currentDate.getHours();
    const targetHours = targetDate.getHours();

    // 计算日期差
    const differenceInDays = Math.floor((currentDate.getTime() - targetDate.getTime()) / MS_PER_DAY);

    // 判断今天
    if (currentYear === targetYear && currentMonth === targetMonth && currentDay === targetDay) {
      return "今天";
    }

    // 判断昨天：时间戳的日期是昨天，且目标时间在前一天晚上
    if (
      currentYear === targetYear &&
        currentMonth === targetMonth &&
        currentDay === targetDay + 1 &&
        targetHours >= 0 &&
        targetHours <= 23
    ) {
      return "昨天";
    }

    // 判断前天
    if (
      currentYear === targetYear &&
        currentMonth === targetMonth &&
        currentDay === targetDay + 2 &&
        targetHours >= 0 &&
        targetHours <= 23
    ) {
      return "前天";
    }

    // 判断过去一周
    if (differenceInDays <= 7 && differenceInDays > 2) {
      return "过去一周";
    }

    // 判断过去一个月
    if (differenceInDays <= 30 && differenceInDays > 7) {
      return "过去一月";
    }
    // 返回几几月
    if (currentYear === targetYear) {
      return `${targetMonth + 1}月`;
    }
    // 返回年份
    return `${targetYear}年`;
  }



}
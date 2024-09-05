import text from '@ohos.graphics.text';

import  CommonHeader  from './components/common-header'
import CommonFooter from './components/common-footer'
import  MemoList from  './components/memo-list'
import { DataBaseUtil } from '../utils/dataBaseStore'


@Entry
@Preview
@Component
struct Index {
  async aboutToAppear() {
    const instance = DataBaseUtil.getStore()
    if(instance) {
      const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS MEMO (ID INTEGER PRIMARY KEY AUTOINCREMENT, CREATE_DATE TEXT NOT NULL, DEL_DATE TEXT, IS_DEL INT, CONTENT TEXT NOT NULL  )';
      console.log(instance.Store?.version+'')
      if (instance.Store?.version === 0) {
        instance.Store.executeSql(SQL_CREATE_TABLE); // 创建数据表
        // 设置数据库的版本，入参为大于0的整数
        instance.Store.version = 1;
        console.log(instance.Store.version+'')
        console.log('实例创建')
      }
    }

 }
  build() {
    Flex({ direction: FlexDirection.Column }){
      CommonHeader()
      MemoList()
      CommonFooter()
    }
    .height('100%')
    .backgroundColor($r('app.color.bgColor'))

    // .backgroundColor($('app.'))
  }
   renderList = ()=>{

  }
}
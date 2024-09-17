import text from '@ohos.graphics.text';

import  CommonHeader  from './components/common-header'
import CommonFooter from './components/common-footer'
import  MemoList from  './components/memo-list'
import { DataBaseUtil } from '../utils/dataBaseStore'
import { relationalStore } from '@kit.ArkData';
import { DateUtil } from '../utils/DateUtil'
import { emitter } from '@kit.BasicServicesKit';

interface memoInterface {
  CREATE_DATE:string,
  CONTENT: string,
}

interface GeneratedObjectLiteralInterface_1 {
  imgUrl?: ResourceStr;
  id: number;
  time: string;
  toDo: string;
  dayType:string;
  up: number
}
interface toDoGroup {
  date: string,
  toDoArr: toDo[]
}
interface toDo {
  time: string,
  toDo: string,
  id:number,
  imgUrl?: ResourceStr;
  up: number
}
@Entry
@Preview
@Component
struct Index {
  @State initMemoList : Array<toDoGroup> = []
  @State ListTotal: number = 0
  aboutToAppear(): void {
    // 监听指定ID为1的事件
    emitter.on({ eventId: 1 }, (event) => {
      // 如果事件携带数据，则调用子组件方法处理数据
      if (event) {
        this.getMemoList();
      }
    });
  }
  async onPageShow() {
    this.getMemoList()

 }

 async getMemoList() {
   const instance =  DataBaseUtil.getStore()
   console.log('进入0')
   if(instance&&instance.Store) {
     const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS MEMO (ID INTEGER PRIMARY KEY AUTOINCREMENT, CREATE_DATE TEXT NOT NULL, DEL_DATE TEXT, IS_DEL INT NOT NULL, IS_UP INT NOT NULL,CONTENT TEXT NOT NULL  )';
     console.log(instance.Store?.version+'')
     if (instance.Store?.version === 0) {
       instance.Store.executeSql(SQL_CREATE_TABLE); // 创建数据表
       // 设置数据库的版本，入参为大于0的整数
       instance.Store.version = 1;
       console.log(instance.Store.version+'')
       console.log('实例创建')
     }
     try {
       const tempInitMemoResult :Array<GeneratedObjectLiteralInterface_1> = []
       let predicates = new relationalStore.RdbPredicates("MEMO");
       predicates.equalTo("IS_DEL",0);
       const resultSet =  await instance.Store.query(predicates)
       while (resultSet.goToNextRow()) {
         const content = resultSet.getString(resultSet.getColumnIndex("CONTENT"));
         const createDate = resultSet.getString(resultSet.getColumnIndex("CREATE_DATE"));
         const id = resultSet.getLong(resultSet.getColumnIndex("ID"));
         const up = resultSet.getLong(resultSet.getColumnIndex("IS_UP"));
         const memoData:  Array<RichEditorImageSpanResult| RichEditorTextSpanResult> = JSON.parse(content)
         const textSpan =  memoData.filter(el=>{
           return  (el as RichEditorTextSpanResult).value&&(el as RichEditorTextSpanResult).value!='\n'
         }).map(item=>{
           return (item as RichEditorTextSpanResult)?.value.replace(/\s+/g, '')
         }).join('')
         const imageSpan = memoData.find(el=>{
           return  (el as RichEditorImageSpanResult)?.imageStyle
         })
         console.log(JSON.stringify((imageSpan as RichEditorImageSpanResult)?.valueResourceStr))
         const obj: GeneratedObjectLiteralInterface_1 = {
           imgUrl:(imageSpan as RichEditorImageSpanResult)?.valueResourceStr ,
           id,
           up,
           dayType: up===1? '置顶': DateUtil.getChineseDay(Number(createDate)),
           time: DateUtil.getFormatTimeStr(Number(createDate)),
           toDo: textSpan
         }
         tempInitMemoResult.push(obj)
       }
       // 释放数据集的内存，若不释放可能会引起fd泄露与内存泄露
       resultSet.close();
       this.ListTotal = tempInitMemoResult.length
       this.initMemoList = this.dealDataBaseDataTOListData(tempInitMemoResult)
     }catch (e) {
       console.log(e)
     }

   }
 }

  dealDataBaseDataTOListData(inputData:Array<GeneratedObjectLiteralInterface_1>) {
    const result:Array<toDoGroup> = [];
    // 按照 dayType 归类
    inputData.forEach(item => {
      // 找到已有的同日期的对象
      let existingDayType = result.find(entry => (entry.date === item.dayType));
      // 如果没有对应的日期类型，创建一个新的
      if (!existingDayType) {
        existingDayType = {
          date: item.dayType,
          toDoArr: []
        };
        result.push(existingDayType);
      }

      existingDayType.toDoArr.push({
        time: item.time,
        toDo: item.toDo,
        id: item.id,
        imgUrl:item.imgUrl,
        up:item.up
      });

      // 添加时间和toDo到toDoArr

    });
    const up = result.filter(entry => (entry.date === '置顶'));
    const notUp =  result.filter(entry => (entry.date !== '置顶')).reverse();
    return [...up, ...notUp]
  }
  build() {
    Flex({ direction: FlexDirection.Column }){
      CommonHeader()
      MemoList({initMemoList:this.initMemoList})
      CommonFooter({
        ListTotal:this.ListTotal
      })
    }
    .height('100%')
    .backgroundColor($r('app.color.bgColor'))
  }
   renderList = ()=>{

  }
}
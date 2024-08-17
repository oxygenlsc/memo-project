import text from '@ohos.graphics.text';

import  CommonHeader  from './components/common-header'
import CommonFooter from './components/common-footer'
import  MemoList from  './components/memo-list'



@Entry
@Preview
@Component
struct Index {

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
import text from '@ohos.graphics.text';

import  CommonHeader  from './components/common-header'
import  MemoList from  './components/memo-list'

@Preview
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column(){
      CommonHeader()
      MemoList()
    }
    .height('100%')
    .backgroundColor($r('app.color.bgColor'))
    // .backgroundColor($('app.'))
  }
}
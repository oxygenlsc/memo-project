import router from '@ohos.router';


@Component
export default  struct  CommonFooter {
  build() {
    Column(){
      Divider()
      Row(){
        Text('144个备忘录')
          .fontSize(14)
        Image($r('app.media.edit'))
          .width(25)
          .height(25)
      }
      .padding({
        bottom:10
      })
      .height(60)
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/memoEdit'
        })
      })
    }
  }
}
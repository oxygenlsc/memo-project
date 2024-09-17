import router from '@ohos.router';


@Component
export default  struct  CommonFooter {
  @Prop ListTotal:number
  build() {
    Column(){
      Divider()
      Row(){
        Text(`${this.ListTotal}个备忘录`)
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
          url: 'pages/memoEdit',
          params: { id: -1}
        })
      })
    }
  }
}
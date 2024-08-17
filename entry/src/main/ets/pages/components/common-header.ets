@Component
export default struct CommonHeader {
   build() {
     Row(){
       Text('备忘录')
         .margin({ top: '0.00vp', right: '0vp', bottom: '0.00vp', left: '16vp' })
         .fontSize(26)
         .fontWeight(FontWeight.Bold)
       Text('...')
         .backgroundColor($r('app.color.bgColor'))
         .borderColor($r('app.color.baseColor'))
         .borderWidth(3)
         .fontColor($r('app.color.baseColor'))
         .fontWeight(FontWeight.Bold)
         .fontSize(20)
         .width(30)
         .height(30)
         .borderRadius(50)
         .textAlign(TextAlign.Center)
         .lineHeight('5')
         .margin({ top: '0.00vp', right: '20vp', bottom: '0.00vp', left: '0.00vp' })
     }
     .width('100.00%')
     .height(50)
     .justifyContent(FlexAlign.SpaceBetween)
     .margin({ top: '16.00vp', right: '0vp', bottom: '16.00vp', left: '0.00vp' })
   }
}
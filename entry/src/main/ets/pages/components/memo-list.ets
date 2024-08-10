@Component
export default struct MemoList {
  build() {
    List({ space: 20, initialIndex: 0 }){
      ListItem(){
        Text('123')
      }
      ListItem(){
        Text('addddddddd').fontSize(26)
      }
      ListItem(){
        Text('123')
      }
    }
    .margin({ top: '0vp', right: '16.00vp', bottom: '0vp', left: '16.00vp' })
    .height('90%')
  }
}
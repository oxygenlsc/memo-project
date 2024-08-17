interface toDo {
  time: string,
  toDo: string
}
interface toDoGroup {
  date: string,
  toDoArr: toDo[]
}

@Component
export default struct MemoList {
  @State numbersArr: toDoGroup[] = [
    {
    date: "今天",
    toDoArr:[
      {
        time: '2022-1-1',
        toDo: '吃饭ddddaaaaaaa上的就爱看撒旦记录卡按实际的卡了'
      },
      {
        time: '2022-1-1',
        toDo: '吃饭'
      }
    ]
     },
    {
      date: "昨天",
      toDoArr: [
        {
          time: '2022-1-2',
          toDo: '吃饭111'
        }
      ]
    },
    {
      date: "昨天",
      toDoArr: [
        {
          time: '2022-1-2',
          toDo: '吃饭111'
        }
      ]
    },
    {
      date: "昨天",
      toDoArr: [
        {
          time: '2022-1-2',
          toDo: '吃饭111'
        }
      ]
    },
    {
      date: "昨天",
      toDoArr: [
        {
          time: '2022-1-2',
          toDo: '吃饭111'
        }
      ]
    },
    {
      date: "昨天",
      toDoArr: [
        {
          time: '2022-1-2',
          toDo: '吃饭111'
        }
      ]
    }

  ]

  build() {

    List({ space: 0, initialIndex: 0 }) {
      ForEach(this.numbersArr, (item: toDoGroup, index) => {
        ListItem() {
          Column() {
            Text(item.date)
              .width('100%')
              .margin({ bottom: 16 })
              .fontSize(20)
              .fontWeight('bolder')

            Column() {
              ForEach(item.toDoArr,(el:toDo,i)=>{
                Column() {
                  Text(el.toDo)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .maxLines(1)
                    .margin({
                      bottom: 6
                    })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(el.time)
                    .fontSize(12)
                    .fontColor("#df6c9b69")
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ bottom: `${i===item.toDoArr.length-1?0:8}` })
                if(i!==item.toDoArr.length-1){
                  Divider().strokeWidth(1)
                    .color('#F1F3F5')
                    .margin({ bottom: `8` })
                }
              })
            }
            .alignItems(HorizontalAlign.Start)
            .backgroundColor("#fff")
            .width('100%')
            .padding({
              top: 12,
              left: 16,
              right: 16,
              bottom: 12
            })
            .margin({ bottom: 16 })
            .align(Alignment.Start)
            .borderRadius(8)
            .shadow(ShadowStyle.OUTER_DEFAULT_XS)
          }.align(Alignment.Start)
        }
      })
    }
    .padding({ right: 16, left: 16 })
    .height('90%')
  }
}
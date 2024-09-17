import { router } from '@kit.ArkUI'
import { relationalStore } from '@kit.ArkData';

import { DataBaseUtil } from '../../utils/dataBaseStore'
import { emitter } from '@kit.BasicServicesKit';

const instance = DataBaseUtil.getStore()
interface toDo {
  time: string,
  toDo: string,
  id: number,
  up: number,
  imgUrl?: ResourceStr;
}

interface toDoGroup {
  date: string,
  toDoArr: toDo[]
}
class ListItemModifier implements AttributeModifier<RowAttribute> {
  mrLeft: number = 0
  applyNormalAttribute(instance: RowAttribute): void {
      instance.margin({
        left: this.mrLeft
      })
    }
}

@Component
export default struct MemoList {
  @Prop  initMemoList: toDoGroup[]
  // @Prop getMemoList:function
  @State modifier: ListItemModifier = new ListItemModifier()
  @State curListId: number = 0
  @State curX: number = 0
  build() {

    List({ space: 0, initialIndex: 0 }) {
      ForEach(this.initMemoList, (item: toDoGroup, index) => {
        ListItem() {
          Column() {
            Text(item.date)
              .width('100%')
              .margin({ bottom: 16 })
              .fontSize(20)
              .fontWeight('bolder')

            Column() {
              ForEach(item.toDoArr, (el: toDo, i) => {
                Row() {
                  Row() {
                    Column() {
                      Text(el.toDo)
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .maxLines(1)
                        .margin({
                          bottom: 6
                        })
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                        .width('100%')
                      Text(el.time)
                        .fontSize(12)
                        .fontColor("#df6c9b69")
                    }
                    .width('100%')
                    .alignItems(HorizontalAlign.Start)
                    .margin({ bottom: `${i === item.toDoArr.length - 1 ? 0 : 8}` })
                    .width(`${el.imgUrl ? '80%' : '100%'}`)
                    Image(el.imgUrl)
                      .width(50)
                      .height(50)
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                  .onClick(()=>{
                    if(this.modifier.mrLeft!==0&&this.curListId===el.id)return
                        router.pushUrl({
                          url: 'pages/memoEdit',
                          params: { id: el.id }
                        })
                  })
                  .padding({
                    top:6,
                    left: 16,
                    right: 16,
                  })
                  Row() {
                if(el.up===1) {
                  Text('取消置顶')
                    .height('100%')
                    .width(70)
                    .backgroundColor($r('app.color.baseColor'))
                    .textAlign(TextAlign.Center)
                    .fontColor("#fff")
                    .fontWeight(FontWeight.Bold)
                    .onClick(()=>{
                      try {
                        const id = el.id
                        if(instance){
                          let predicates = new relationalStore.RdbPredicates("MEMO");
                          predicates.equalTo("ID", id);
                          (instance.Store as relationalStore.RdbStore).update({
                            'IS_UP': 0,
                          }, predicates, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE, (err, rows) => {
                            if (err) {
                              console.error(`Updated failed, code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            emitter.emit(
                              { eventId: 1, priority: emitter.EventPriority.IMMEDIATE },
                            );
                        if(this.modifier){
                          this.modifier.mrLeft = 0
                        }
                            console.info(`Updated row count: ${rows}`);
                          })
                        }
                      } catch (e) {
                        console.log(e)
                      }

                    })
                }else {
                  Text('置顶')
                    .height('100%')
                    .width(70)
                    .backgroundColor($r('app.color.baseColor'))
                    .textAlign(TextAlign.Center)
                    .fontColor("#fff")
                    .fontWeight(FontWeight.Bold)
                    .onClick(()=>{
                      try {
                        const id = el.id
                        if(instance){
                          let predicates = new relationalStore.RdbPredicates("MEMO");
                          predicates.equalTo("ID", id);
                          (instance.Store as relationalStore.RdbStore).update({
                            'IS_UP': 1,
                          }, predicates, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE, (err, rows) => {
                            if (err) {
                              console.error(`Updated failed, code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            emitter.emit(
                              { eventId: 1, priority: emitter.EventPriority.IMMEDIATE },
                            );
                            // this.modifier.mrLeft = 0
                            if(this.modifier){
                              this.modifier.mrLeft = 0
                            }
                            console.info(`Updated row count: ${rows}`);
                          })
                        }
                      } catch (e) {
                        console.log(e)
                      }

                    })
                }
                    Text('删除')
                      .height('100%')
                      .width(70)
                      .backgroundColor('red')
                      .textAlign(TextAlign.Center)
                      .fontColor("#fff")
                      .fontWeight(FontWeight.Bold)
                      .onClick(()=>{
                        try {
                          const id = el.id
                          if(instance){
                            let predicates = new relationalStore.RdbPredicates("MEMO");
                            predicates.equalTo("ID", id);
                            (instance.Store as relationalStore.RdbStore).update({
                              'IS_DEL': 1,
                            }, predicates, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE, (err, rows) => {
                              if (err) {
                                console.error(`Updated failed, code is ${err.code},message is ${err.message}`);
                                return;
                              }
                              emitter.emit(
                                { eventId: 1, priority: emitter.EventPriority.IMMEDIATE },
                              );
                              if(this.modifier){
                                this.modifier.mrLeft = 0
                              }
                              console.info(`Updated row count: ${rows}`);
                            })
                          }
                        } catch (e) {
                          console.log(e)
                        }
                      })
                  }
                  .height('100%')
                }
                .width('100%')
                .height(60)
                .attributeModifier(this.curListId == el.id? this.modifier: null)
                .animation({
                  duration: 400,
                  curve: Curve.Smooth,
                  iterations: 1,
                  playMode: PlayMode.Normal
                })
                .borderRadius(6)
                .onTouch((e)=>{
                  const move = Math.floor(e.touches[0].x - this.curX)
                  if(e.type === TouchType.Down) {
                    this.curListId = el.id
                    this.curX = e.touches[0].x
                  }
                  if(e.type === TouchType.Move) {
                    let left = move
                    if(left<-136){
                      left = -136
                    }
                    if(left>0) {
                      left =  0
                    }
                    this.modifier.mrLeft = left
                  }
                  if(e.type === TouchType.Up){
                    let left = move
                   if(left<-80&&left>-136){
                     this.modifier.mrLeft = -136
                   }else if(left<0&&left>-80) {
                     this.modifier.mrLeft = 0
                   }
                  }
                })

                if (i !== item.toDoArr.length - 1) {
                  Divider().strokeWidth(1)
                    .color('#F1F3F5')
                }
              })
            }
            .alignItems(HorizontalAlign.Start)
            .backgroundColor("#fff")
            .width('100%')
            .margin({ bottom: 16 })
            .align(Alignment.Start)
            .borderRadius(8)
            .clip(true)
            .shadow(ShadowStyle.OUTER_DEFAULT_XS)
          }.align(Alignment.Start)
        }
      })
    }
    .padding({ right: 16, left: 16 })
    .height('90%')
  }
}
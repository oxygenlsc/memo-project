import { router, SegmentButton, SegmentButtonItemTuple, SegmentButtonOptions, window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { camera, cameraPicker } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import { relationalStore } from '@kit.ArkData';
import { DataBaseUtil } from '../utils/dataBaseStore'
import { DateUtil } from '../utils/DateUtil'

const instance = DataBaseUtil.getStore()
const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
const controller: RichEditorController = new RichEditorController();
const options: RichEditorOptions = { controller: controller };
let WindowWidth = 1
let context = getContext(this) as common.Context;



@CustomDialog
@Component
struct FontCustomDialog {
  DialogController?: CustomDialogController
  @Link titleX: number
  @Link titleY: number
  @Link titleW: number
  @Link titleH: number
  @Link curTitleIndex: number
  @State multiplySelectCapsuleOptions: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [{ text: 'B' }, { text: '斜体' }] as SegmentButtonItemTuple,
    multiply: true,
    selectedBackgroundColor: '#89E33A',
    fontSize: 18,
    selectedFontSize: 18
  })
  @State TextSelectCapsuleOptions: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [{ text: 'Normal' }, { text: '上划线' }, { text: '中划线' }, { text: '下划线' }] as SegmentButtonItemTuple,
    selectedBackgroundColor: '#89E33A',
    fontSize: 18,
    selectedFontSize: 18
  })
  @Link @Watch('onTextLineInfoChange') TextLineSelectCapsuleSelectedIndexes: number[]
  @Link @Watch('onInfoChange') multiplySelectCapsuleSelectedIndexes: number[]
  @Link richEditorTextStyle: RichEditorTextStyle
  @Link ColorTips: ResourceColor
  @Link SliderValue: number
  fontColorArr: ColorStop[] = [
    {
      color: '#000',
      offset: 0.1
    },
    {
      color: '#f8ac0c',
      offset: 0.2
    },
    {
      color: '#f44e14',
      offset: 0.3
    },
    {
      color: '#ec5c9a',
      offset: 0.4
    },
    {
      color: '#a354f1',
      offset: 0.5
    },
    {
      color: '#5d59f8',
      offset: 0.6
    },
    {
      color: '#2483f9',
      offset: 0.7
    },
    {
      color: '#61bae4',
      offset: 0.8
    },
    {
      color: '#7fd33d',
      offset: 0.9
    },
    {
      color: '#9c9ca6',
      offset: 1
    }
  ]

  onInfoChange() {
    let isBold = this.multiplySelectCapsuleSelectedIndexes.find(el => el === 0)
    let isItalic = this.multiplySelectCapsuleSelectedIndexes.find(el => el === 1)
    this.richEditorTextStyle.fontWeight = isBold === 0 ? FontWeight.Bold : FontWeight.Normal
    this.richEditorTextStyle.fontStyle = isItalic === 1 ? FontStyle.Italic : FontStyle.Normal
    controller.setTypingStyle(this.richEditorTextStyle)
  }

  onTextLineInfoChange() {
    let isTopLine = this.TextLineSelectCapsuleSelectedIndexes.find(el => el === 1)
    let isMiddleLine = this.TextLineSelectCapsuleSelectedIndexes.find(el => el === 2)
    let isUnderline = this.TextLineSelectCapsuleSelectedIndexes.find(el => el === 3)
    if (isTopLine === 1) {
      this.richEditorTextStyle.decoration = {
        type: TextDecorationType.Overline,
      }
    } else if (isMiddleLine === 2) {
      this.richEditorTextStyle.decoration = {
        type: TextDecorationType.LineThrough,
      }
    } else if (isUnderline === 3) {
      this.richEditorTextStyle.decoration = {
        type: TextDecorationType.Underline,
      }
    } else {
      this.richEditorTextStyle.decoration = {
        type: TextDecorationType.None,
      }
    }
    controller.setTypingStyle(this.richEditorTextStyle)
  }

  HandleClickTitle = (e: ClickEvent, i: number, size: number) => {
    this.titleX = Number(e.target.area.position.x)
    this.titleY = Number(e.target.area.position.y)
    this.titleW = Number(e.target.area.width)
    this.titleH = Number(e.target.area.height)
    this.curTitleIndex = i
    this.richEditorTextStyle.fontSize = size
    if (i === 4) {
      this.richEditorTextStyle.fontWeight = FontWeight.Normal
      this.multiplySelectCapsuleSelectedIndexes = this.multiplySelectCapsuleSelectedIndexes.filter(el => {
        return el !== 0
      })
    } else {
      this.richEditorTextStyle.fontWeight = FontWeight.Bold
      this.multiplySelectCapsuleSelectedIndexes = Array.from(new Set([0, ...this.multiplySelectCapsuleSelectedIndexes]))
    }
    controller.setTypingStyle(this.richEditorTextStyle)
  }

  build() {
    Column() {
      Row() {
        Text('格式')
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.close'))
          .width(26)
          .height(26)
          .onClick(() => {
            this.DialogController?.close()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('')
          .width(this.titleW + 8)
          .height(this.titleH + 8)
          .backgroundColor($r('app.color.baseColor'))
          .position({
            y: this.titleY - 5,
            x: this.titleX - 4
          })
          .borderRadius(4)
          .animation({
            duration: 200,
            curve: Curve.EaseInOut,
            iterations: 1, // 设置-1表示动画无限循环
            playMode: PlayMode.Normal,
            expectedFrameRateRange: {
              min: 20,
              max: 120,
              expected: 90,
            }
          })
        Text('标题')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .lineHeight(26)
          .fontColor(`${this.curTitleIndex === 1 ? '#fff' : '#000'}`)
          .onClick((e) => this.HandleClickTitle(e, 1, 26))
        Text('小标题')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .lineHeight(22)
          .fontColor(`${this.curTitleIndex === 2 ? '#fff' : '#000'}`)
          .onClick((e) => this.HandleClickTitle(e, 2, 22))
        Text('副标题')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .lineHeight(18)
          .fontColor(`${this.curTitleIndex === 3 ? '#fff' : '#000'}`)
          .onClick((e) => this.HandleClickTitle(e, 3, 18))
        Text('正文')
          .fontSize(16)
          .fontWeight(FontWeight.Normal)
          .lineHeight(16)
          .fontColor(`${this.curTitleIndex === 4 ? '#fff' : '#000'}`)
          .onClick((e) => this.HandleClickTitle(e, 4, 16))
      }
      .width('100%')
      .margin({
        top: 16
      })
      .justifyContent(FlexAlign.SpaceAround)

      SegmentButton({
        options: this.TextSelectCapsuleOptions,
        selectedIndexes: $TextLineSelectCapsuleSelectedIndexes
      })
        .margin(12)
        .borderRadius(6)
      SegmentButton({
        options: this.multiplySelectCapsuleOptions,
        selectedIndexes: $multiplySelectCapsuleSelectedIndexes
      })
        .margin(12)
        .borderRadius(6)
      Slider({ style: SliderStyle.OutSet, value: this.SliderValue })
        .selectedColor('transparent')
        .trackThickness(10)
        .trackColor(new LinearGradient(this.fontColorArr))
        .blockSize({ width: '100px', height: '100px' })
        .blockColor(this.ColorTips)
        .blockStyle({ type: SliderBlockType.SHAPE, shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' }) })
        .onChange(async (value) => {
          this.SliderValue = value
          const index = Math.floor(value / 10)
          const curColorInfo = this.fontColorArr[index]
          this.ColorTips = curColorInfo.color
          this.richEditorTextStyle.fontColor = curColorInfo.color
          controller.setTypingStyle(this.richEditorTextStyle)
        })
    }
    .padding(16)
  }
}

interface queryInterface {
  id: number;
}

@Entry
@Component
struct MemoEdit {
  private start: number = -1;
  private end: number = -1;
  @State scrollHeight: number = 0;
  @State keyHeight: number = 0;
  @State context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State filesDir: string = this.context.filesDir;
  @State titleX: number = 0
  @State titleY: number = 0
  @State titleW: number = 0
  @State titleH: number = 0
  @State curTitleIndex: number = 0
  @State multiplySelectCapsuleSelectedIndexes: number[] = []
  @State TextLineSelectCapsuleSelectedIndexes: number[] = [0]
  @State richEditorTextStyle: RichEditorTextStyle = {}
  @State ColorTips: ResourceColor = '#000'
  @State SliderValue: number = 0
  queryId: number = -1
  dialogControllerTwo: CustomDialogController | null = new CustomDialogController({
    builder: FontCustomDialog({
      titleX: $titleX,
      titleY: $titleY,
      titleW: $titleW,
      titleH: $titleH,
      curTitleIndex: $curTitleIndex,
      multiplySelectCapsuleSelectedIndexes: $multiplySelectCapsuleSelectedIndexes,
      richEditorTextStyle: $richEditorTextStyle,
      TextLineSelectCapsuleSelectedIndexes: $TextLineSelectCapsuleSelectedIndexes,
      ColorTips: $ColorTips,
      SliderValue: $SliderValue
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    cornerRadius: 8,
  })

  async aboutToAppear() {
    const params = router.getParams() as (queryInterface)
    this.queryId = params.id
    this.initMemoData()
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 设置窗口的布局为沉浸式布局
      currentWindow.setWindowLayoutFullScreen(true);
      let property = currentWindow.getWindowProperties();
      console.log('property', JSON.stringify(property))
      WindowWidth = px2vp(property.windowRect.width)
      // 初始化窗口高度
      let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      this.scrollHeight = px2vp(property.windowRect.height - avoidArea.bottomRect.height);
      // 监听软键盘的隐藏和显示
      currentWindow.on('avoidAreaChange', data => {
        if (data.type == window.AvoidAreaType.TYPE_KEYBOARD) {
          this.keyHeight = px2vp(data.area.bottomRect.height);
          this.scrollHeight =
            px2vp(currentWindow.getWindowProperties().windowRect.height - data.area.bottomRect.height);
          return;
        }
      })
    })
  }

  async initMemoData() {
    if(instance && instance.Store) {
      let predicates = new relationalStore.RdbPredicates("MEMO");
      predicates.equalTo("ID",this.queryId);
      const resultSet =  await instance.Store.query(predicates)
      while (resultSet.goToNextRow()) {

        const content = resultSet.getString(resultSet.getColumnIndex("CONTENT"));
        const memoData:  Array<RichEditorImageSpanResult| RichEditorTextSpanResult> = JSON.parse(content)
        memoData.forEach((item)=>{
          console.dir(item)
          console.log('item')
          if(typeof(item as RichEditorImageSpanResult)['imageStyle'] != 'undefined'){
             const imgSrc =  (item as RichEditorImageSpanResult).valueResourceStr;
             const imageStyle = (item as RichEditorImageSpanResult).imageStyle
            imageStyle.size = [px2vp(imageStyle.size[0]),px2vp(imageStyle.size[1])]
            controller.addImageSpan(imgSrc, {
              imageStyle,
            })
          } else {
            const value =  (item as RichEditorTextSpanResult).value
            const style = (item as RichEditorTextSpanResult).textStyle
            // richEditor中 获取的和设置的字体粗细是要转换的 有规则的
            // 参考 https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-basic-components-richeditor-V5#richeditortextstyleresult
            const fontWeight = style.fontWeight === 9? FontWeight.Bold: FontWeight.Normal
            style.fontWeight = fontWeight
            controller.addTextSpan(value,
              {
                style,
              }
            )
            }
        })
      }
    // 释放数据集的内存，若不释放可能会引起fd泄露与内存泄露
    resultSet.close();
    }
  }
  async saveBufferToFileManager(imgBuffer: ArrayBuffer, targetUrl: string) {
    const file = fs.openSync(targetUrl,
      fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    await fs.write(file.fd, imgBuffer);
    await fs.close(file.fd);
  }

  // 获取图片uri
  private async getImgUris(): Promise<Array<string>> {
    let uris: Array<string> = [];
    try {
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
      photoSelectOptions.maxSelectNumber = 5; // 选择媒体文件的最大数目
      const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
      const photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoViewPicker.select(photoSelectOptions)
      uris = photoSelectResult.photoUris;
    } catch (err) {
      console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    }
    return uris
  }

  private async takePicture() {
    const uris = await this.getImgUris()
    uris.forEach((async (el) => {
      const file = fs.openSync(el, fs.OpenMode.READ_ONLY);
      let photoSize = fs.statSync(file.fd).size;
      console.info('Photo Size: ' + photoSize);
      let buffer = new ArrayBuffer(photoSize);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);
      const targetUrl = this.filesDir + `/${DateUtil.getTimeStamp()}.png`
      console.log(targetUrl, 'targetUrl')
      await this.saveBufferToFileManager(buffer, targetUrl)
      let imageSource = image.createImageSource(buffer.slice(0, buffer.byteLength))
      const info = await imageSource.getImageInfo()
      // let createPixelMap: image.PixelMap = await imageSource.createPixelMap({
      //   desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      // })
      await imageSource.release()
      controller.addImageSpan(`file://${targetUrl}`, {
        imageStyle: {
          size: [
            WindowWidth > info.size.width ? px2vp(info.size.width) : (WindowWidth - 32),
            WindowWidth > info.size.width ? px2vp(info.size.height) :
              ((WindowWidth / px2vp(info.size.width)) * px2vp(info.size.height)) - 32
          ],
          verticalAlign: ImageSpanAlignment.TOP,
          objectFit: ImageFit.Contain
        }
      })
    }))
  }

  // 拍照功能
  private async takePhoto() {

  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(30)
          .height(20)
          .onClick(() => {
            router.back()
          })
        Text('完成')
          .fontWeight(FontWeight.Bolder)
          .fontColor($r('app.color.baseColor'))
          .width(40)
          .height(20)
          .visibility(this.keyHeight === 0 ? Visibility.Hidden : Visibility.Visible)
          .onClick(async (e) => {
            if(this.queryId === -1) {
              try {
                if (instance) {
                  const submitData = await controller.getSpans({
                    start: this.start,
                    end: this.end
                  })


                  controller.stopEditing()
                  const id = await instance.Store?.insert('MEMO', {
                    CREATE_DATE: DateUtil.getTimeStamp(),
                    CONTENT: JSON.stringify(submitData),
                    IS_DEL: 0,
                    IS_UP:0
                  }
                  )
                  this.queryId = id || -1
                  console.log(id+'id')

                }
              } catch (e) {
                console.log(e)
              }
            }
            else  {
              try {
                if(instance) {
                  const submitData = await controller.getSpans({
                    start: this.start,
                    end: this.end
                  })
                  console.dir(submitData)
                  console.log('submitData')
                  controller.stopEditing()
                  let predicates = new relationalStore.RdbPredicates("MEMO");
                  predicates.equalTo("ID", this.queryId);
                  (instance.Store as relationalStore.RdbStore).update({
                    'CONTENT': JSON.stringify(submitData),
                  }, predicates, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE, (err, rows) => {
                    if (err) {
                      console.error(`Updated failed, code is ${err.code},message is ${err.message}`);
                      return;
                    }
                    console.info(`Updated row count: ${rows}`);
                  })
                }
              } catch (e) {
                console.log(e)
              }

            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(30)
      .padding({ left: 8, right: 10 })
      .zIndex(10)

      RichEditor(options)
        .id('richEditor')
        .caretColor($r('app.color.baseColor'))
        .height(this.scrollHeight - 80)
        .padding({ bottom: 60 })
        .selectedBackgroundColor($r('app.color.baseColor'))

      Row() {
        Text('Aa')
          .margin({ right: 16 })
          .fontSize(18)
          .fontColor('#ff707070')
          .onClick(() => {
            if (this.dialogControllerTwo != null) {
              this.dialogControllerTwo.open()
            }
            console.log('123')
          })
        Image($r('app.media.picture'))
          .width(26)
          .height(26)
          .margin({ right: 16 })
          .onClick(() => {
            this.takePicture()
          })
        // Image($r('app.media.camera'))
        //   .width(26)
        //   .height(26)
        //   .onClick(async () => {
        //     promptAction.showToast({ message: '待开发需要在真机上调试' })
        //     try {
        //       let pickerProfile: cameraPicker.PickerProfile = {
        //         cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
        //       };
        //       let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(context,
        //         [cameraPicker.PickerMediaType.PHOTO], pickerProfile);
        //       console.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
        //     } catch (error) {
        //       let err = error as BusinessError;
        //       console.error(`the pick call failed. error code: ${err.code}`);
        //     }
        //   })

      }
      .justifyContent(FlexAlign.End)
      .height(50)
      .width('100%')
      .padding(16)
      .backgroundColor("#e5e5e5")
      .visibility(this.keyHeight === 0 ? Visibility.Hidden : Visibility.Visible)
      .position({ bottom: 0 })
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .height(this.scrollHeight)
    .width('100%')
    .padding({ top: 40, bottom: 0 })
    .backgroundColor($r('app.color.bgColor'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
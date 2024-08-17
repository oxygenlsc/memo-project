import { LengthMetrics, window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';

const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
const controller: RichEditorStyledStringController = new RichEditorStyledStringController();
const options: RichEditorStyledStringOptions = { controller: controller };
let WindowWidth = 1





class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
  async onDataPrepared(data: ArrayBuffer) {
    if (data === undefined) {
      console.error('Error occurred when preparing data');
      return;
    }
    let imageSource = image.createImageSource(data.slice(0, data.byteLength))
    const info = await imageSource.getImageInfo()
    let createPixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })
    await imageSource.release()
    let imageStyledString = new MutableStyledString(new ImageAttachment({
      value: createPixelMap,
      size: { width: WindowWidth> info.size.width?info.size.width: (WindowWidth-32),height:WindowWidth> info.size.width?info.size.height: (WindowWidth/info.size.width)*info.size.height },
      layoutStyle: { borderRadius: LengthMetrics.vp(0) },
      verticalAlign: ImageSpanAlignment.TOP,
      objectFit: ImageFit.Contain
    }))
    const richEditorStyledString = controller.getStyledString();
    richEditorStyledString.appendStyledString(imageStyledString);
    // // 使插入图片后的属性字符串展示在组件上
    controller.setStyledString(richEditorStyledString);
    controller.setCaretOffset(richEditorStyledString.length);
  }
}

@Entry
@Component
struct MemoEdit {
  private start: number = -1;
  private end: number = -1;
  @State message: string = "[-1, -1]"
  @State content: string = ""
  @State scrollHeight: number = 0;
  @State keyHeight: number = 0;
  richEditorStyledString: MutableStyledString = new MutableStyledString("");

  async aboutToAppear() {
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 设置窗口的布局为沉浸式布局
      currentWindow.setWindowLayoutFullScreen(true);
      let property = currentWindow.getWindowProperties();
      console.log('property',JSON.stringify(property))
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

  // 根据uri获取图片
  private async getImgDataByUri(uri: string) {
    const context = getContext(this);
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri.toString());
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.TITLE],
      predicates: predicates
    };

    try {
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
        await phAccessHelper.getAssets(fetchOptions);
      let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      console.info('getAssets photoAsset.uri : ' + photoAsset.uri);
      // 获取属性值，以标题为例；对于非默认查询的属性，get前需要在fetchColumns中添加对应列名
      // console.info('WIDTH : ' + photoAsset.get(photoAccessHelper.PhotoKeys.TITLE));
      // console.info('HEIGHT : ' + photoAsset.get(photoAccessHelper.PhotoKeys.HEIGHT));
      // 请求图片资源数据
      let requestOptions: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
      }
      const handler = new MediaDataHandler()
      await photoAccessHelper.MediaAssetManager.requestImageData(context, photoAsset, requestOptions, handler);
      fetchResult.close();
    } catch (err) {
      console.error('getAssets failed with err: ' + err);
    }
  }

  private async takePicture() {
    const uris = await this.getImgUris()
    uris.forEach((el => {
      this.getImgDataByUri(el)
    }))
  }

  build() {
    Column() {
      RichEditor(options)
        .height('100%')
        .padding({ bottom: 60 })
      Row() {
        Text(Math.floor(this.keyHeight) + '')
        Text('__')
        Text(Math.floor(this.scrollHeight) + '')
        Image($r('app.media.xj'))
          .width(30)
          .height(30)
          .onClick(() => {
            this.takePicture()
          })
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
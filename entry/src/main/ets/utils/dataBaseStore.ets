import { relationalStore } from '@kit.ArkData'; // 导入模块
import { common } from '@kit.AbilityKit';



export class DataBaseUtil {
  Store: relationalStore.RdbStore | undefined
  private static instance: DataBaseUtil | null

   constructor(context:common.Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'memo.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'memoDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      this.Store = store;
    })
  }

  public static init(context: common.Context): DataBaseUtil {
    if (DataBaseUtil.instance == null) {
      DataBaseUtil.instance = new DataBaseUtil(context)
    }
    return DataBaseUtil.instance
  }
  public static getStore(): DataBaseUtil| null {
    if (DataBaseUtil.instance != null) {
      return DataBaseUtil.instance
    }
    return null
  }
}
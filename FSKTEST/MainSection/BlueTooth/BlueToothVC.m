//
//  BlueToothVC.m
//  FSKTEST
//
//  Created by kent on 2017/10/27.
//  Copyright © 2017年 kent. All rights reserved.
//

#import "BlueToothVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothVC ()<CBCentralManagerDelegate,CBPeripheralDelegate>



@property (nonatomic,strong)CBCentralManager * centralManager;

@property (nonatomic,strong)CBPeripheral     * peripheral;
@property (nonatomic,strong)NSMutableArray *itemArray;


@end

@implementation BlueToothVC

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView.tableHeaderView = [self tableHeaderView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_centralManager stopScan];
        _centralManager = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    });

    
    //初始化蓝牙 central manager
    
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) options:nil];
    
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerRestoredStateScanOptionsKey:@(NO)}];
    
}

- (UIView *)tableHeaderView{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    UILabel *title = [[UILabel alloc]init];
    [header addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header);
    }];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.text = @"蓝牙列表";
    return header;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_centralManager stopScan];
    _centralManager = nil;
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:{
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            [MBProgressHUD showTips:@"不支持蓝牙"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
            
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
            [MBProgressHUD showTips:@"蓝牙未开启"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            [self.centralManager scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                                        options:dic]; // dict,条件
            
            
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //    if([peripheral.name  isEqualToString:BLE_SERVICE_NAME]){
    //        [self connect:peripheral];
    //    }
    //    s);
    NSLog(@"%@-- peripheral.name:%@",peripheral,peripheral.name);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (![self.itemArray containsObject:peripheral.name] && ![peripheral.name isEqualToString:@""] && peripheral.name.length>0) {
            [self.itemArray addObject:peripheral.name];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_centralManager stopScan];
        _centralManager = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    });


    //    peripheral 外设
    //advertisementData // 外设携带的数据
    //RSSI // 外设发出的蓝牙信号强度
//    UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"cancle", nil];
//    [alet show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.itemArray.count == 0) {
        UILabel *emptyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        emptyLab.text = @"暂时没有获取到数据";
        emptyLab.textAlignment = NSTextAlignmentCenter;
        emptyLab.textColor = [UIColor lightGrayColor];
        return emptyLab;
    }else{
        return [[UIView alloc]init];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.centralManager stopScan];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.itemArray.count == 0) {
        return kScreenH;
    }else{
        return 20.0;
    }
}



//返回列表中总共该会有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    return 1;
}
//该方法返回值决定表格中指定分区应该包含多少个元素
//这里我只使用了一个分区，如果是需要多个分区的情况可以分别根据section来指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    return self.itemArray.count;
}

//最重要的部分，该方法的返回值决定各个表格行的控件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //必备。为表格行分配一个静态字符串作为标识符，使用重用机制。如果是自定义表格且表格高度动态变化的话最好取消重用机制。
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    // 自定义表格部分。如果只使用默认形式则只需要如下指定UITableViewCell格式，默认表格行的三个属性为textLabel、detailTextLabel、image
    // 分别对应UITableViewCell显示的标题、纤细的内容以及左边图标，如果使用自定义表格则指定相应的类进行初始化。
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        
    }
    //根据表格行好indexPath.row对表格行内容进行设定
    NSUInteger rowNum = indexPath.row;
    cell.textLabel.text = @"蓝牙名称：";
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = [self.itemArray objectAtIndex:rowNum];
    return cell;
}


- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

#pragma mark -测试
#if 0
//
//  ViewController.m
//  BlueTooth
//
//  Created by JackXu on 15/6/9.
//  Copyright (c) 2015年 BFMobile. All rights reserved.
//

#import "ViewController.h"
#define MyDeviceName @"HMSoft"
@interface ViewController ()

@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (weak, nonatomic) IBOutlet UITextField *editText;
@property (weak, nonatomic) IBOutlet UILabel *resultText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

//检查App的设备BLE是否可用 （ensure that Bluetooth low energy is supported and available to use on the central device）
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            //discover what peripheral devices are available for your app to connect to
            //第一个参数为CBUUID的数组，需要搜索特点服务的蓝牙设备，只要每搜索到一个符合条件的蓝牙设备都会调用didDiscoverPeripheral代理方法
            [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //找到需要的蓝牙设备，停止搜素，保存数据
    if([peripheral.name isEqualToString:MyDeviceName]){
        _discoveredPeripheral = peripheral;
        [_centralMgr connectPeripheral:peripheral options:nil];
    }
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //Before you begin interacting with the peripheral, you should set the peripheral’s delegate to ensure that it receives the appropriate callbacks（设置代理）
    [_discoveredPeripheral setDelegate:self];
    //discover all of the services that a peripheral offers,搜索服务,回调didDiscoverServices
    [_discoveredPeripheral discoverServices:nil];
}

//连接失败，就会得到回调：
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //此时连接发生错误
    NSLog(@"connected periphheral failed");
}

//获取服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    
    for (CBService *s in peripheral.services)
    {
        NSLog(@"Service found with UUID : %@", s.UUID);
        //Discovering all of the characteristics of a service,回调didDiscoverCharacteristicsForService
        [s.peripheral discoverCharacteristics:nil forService:s];
    }
}

//获取特征后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics)
    {
        NSLog(@"c.properties:%lu",(unsigned long)c.properties) ;
        //Subscribing to a Characteristic’s Value 订阅
        [peripheral setNotifyValue:YES forCharacteristic:c];
        // read the characteristic’s value，回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:c];
        _writeCharacteristic = c;
    }
    
}

//订阅的特征值有新的数据时回调
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
    
    [peripheral readValueForCharacteristic:characteristic];
    
}

// 获取到特征的值时回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    _resultText.text = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark 写数据
-(void)writeChar:(NSData *)data
{
    //回调didWriteValueForCharacteristic
    [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark 写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
}

#pragma mark 发送按钮点击事件
- (IBAction)sendClick:(id)sender {
    // 字符串转Data
    NSData *data =[_editText.text dataUsingEncoding:NSUTF8StringEncoding];
    [self writeChar:data];
}
@end
#endif


@end

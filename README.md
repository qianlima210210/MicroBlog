
--设置app启动图时，出现警告：An iPhone Retina (4-inch) launch image for iOS 7.0 and later is required.
因为app是从9.0开始支持的，所以启动图必须包含4英寸的图以供SE使用。点击LaunchImage，选择右边的iOS7.0 and Later，中间出现2x和Retina4设置，只需要提供Retina4的640 × 1136图即可，至于2x的640x960就pass了。编译，警告over。


--extension中添加额外的方法；子类中重写父类已有方法;子类的extension中重写父类extension已有方法;

应用名本地化
1、清空PROJECT---Localizations下所有项
2、工程目录下的“工程名文件夹下”创建文件夹，命名为en.lproj
3、添加InfoPlist.strings文件，去除当前引用
4、将InfoPlist.strings放入en.lproj文件内，添加InfoPlist.strings到工程
5、你会发现PROJECT---Localizations下有English语言了
6、点击加号添加其他语言，展开InfoPlist.strings，有对应项，PROJECT---Localizations下也有对应项
7、为每种语言编写CFBundleDisplayName = "WeiBo";

应用内字符串的本地化
1、添加Localizable.strings文件
2、点击它，点击右边的Localize...
3、选择English，点击Localize
4、点击Localizable.strings，将其他语言勾选上
5、为每种语言编写"TestKey" = "test";
6、应用内使用NSLocalizedString("TestKey", comment: "")获取字符串


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
重写override func pushViewController(_ viewController: UIViewController, animated: Bool)时应注意的地方：

override func pushViewController(_ viewController: UIViewController, animated: Bool) {
if viewControllers.count > 0 {
viewController.hidesBottomBarWhenPushed = true
}
super.pushViewController(viewController, animated: animated)
}

hidesBottomBarWhenPushed的设置一定放在pushViewController之前


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
CocoaPods 0.36-beta后增加了对iOS 8框架以及Swift语言所编写的库的支持。使用use_frameworks!,则cocoapods 使用了frameworks 来取代static libraries 方式。
这样的话，我们不需要在Bridging文件引入头文件,只需要在Swift文件中import 相应的库,就像我们 import UIKit类似,这种方式支持iOS 8以上的系统.我们只需要支持iOS8以上的系统。


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
UIViewController自己来定制statusBar的前景颜色（黑色或白色）,涉及的接口如下：

- (UIStatusBarStyle)preferredStatusBarStyle;
- (UIViewController *)childViewControllerForStatusBarStyle;
- (void)setNeedsStatusBarAppearanceUpdate

- (UIStatusBarStyle)preferredStatusBarStyle:
在你自己的UIViewController里重写此方法，返回你需要的值(UIStatusBarStyleDefault 或者 UIStatusBarStyleLightContent)；
注意：
这里如果你只是简单的return一个固定的值，那么该UIViewController显示的时候，程序就会马上调用该方法，来改变statusBar的前景部分；
如果UIViewController已经显示，你可能还要更改statusBar的前景色，那么，你首先需要调用下面的setNeedsStatusBarAppearanceUpdate方法(这个方法会通知系统去调用当前UIViewController的preferredStatusBarStyle方法)， 这个和UIView的setNeedsDisplay原理差不多(调用UIView对象的setNeedsDisplay方法后，系统会在下次页面刷新时，调用重绘该view，系统最快能1秒刷新60次页面，具体要看程序设置)。

- (UIViewController *)childViewControllerForStatusBarStyle:
这个接口也很重要，默认返回值为nil。当我们调用setNeedsStatusBarAppearanceUpdate时，系统会调用application.window的rootViewController的preferredStatusBarStyle方法，我们程序里一般都是用UINavigationController做root，如果是这种情况，那我们自己的UIViewController里的preferredStatusBarStyle根本不会被调用；这种情况下childViewControllerForStatusBarStyle就派上用场了，我们要子类化一个UINavigationController，在这个子类里面重写childViewControllerForStatusBarStyle方法，如下：

- (UIViewController *)childViewControllerForStatusBarStyle{
return self.topViewController;
}
上面代码的意思就是说，不要调用我自己(就是UINavigationController)的preferredStatusBarStyle方法，而是去调用navigationController.topViewController的preferredStatusBarStyle方法，这样写的话，就能保证当前显示的UIViewController的preferredStatusBarStyle方法能影响statusBar的前景部分。

另外，有时我们的当前显示的UIViewController可能有多个childViewController，重写当前UIViewController的childViewControllerForStatusBarStyle方法，让childViewController的preferredStatusBarStyle生效(当前UIViewController的preferredStatusBarStyle就不会被调用了)。

简单来说，只要UIViewController重写的的childViewControllerForStatusBarStyle方法返回值不是nil，那么，UIViewController的preferredStatusBarStyle方法就不会被系统调用，系统会调用childViewControllerForStatusBarStyle方法返回的UIViewController的preferredStatusBarStyle方法。

- (void)setNeedsStatusBarAppearanceUpdate:
让系统去调用application.window的rootViewController的preferredStatusBarStyle方法,如果rootViewController的childViewControllerForStatusBarStyle返回值不为nil，
则参考上面的讲解。

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
对于导航栏，基类仅仅提供newNavigationBar空的UIView，每个视图控制拥有的导航栏，自己添加;后期如果发现有公共的可以在基类中统一设置；

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
消除系统日志：if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
in your Xcode:
Click on your active scheme name right next to the Stop button
Click on Edit Scheme....
in Run (Debug)-->select the Arguments tab
in Environment Variables click +
add variable: OS_ACTIVITY_MODE = disable


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
自动布局，水平居中+垂直居中

//添加游客视图上的内容视图
let contentOfVisitorView = ContentOfVisitorView()
contentOfVisitorView.setAllCtlSize(noteText: "欢迎使用博客，写点有意思的东西看，关注你所感兴趣得东西。赶紧注册登录吧！")
//为contentOfVisitorView及其父视图visitorView添加约束
contentOfVisitorView.translatesAutoresizingMaskIntoConstraints = false
visitorView.addSubview(contentOfVisitorView)

let layout_contentOfVisitorView = ["contentOfVisitorView":contentOfVisitorView,"visitorView":visitorView]
let constraintsY = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[contentOfVisitorView]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: layout_contentOfVisitorView)
let constraintsX = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[contentOfVisitorView]-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: layout_contentOfVisitorView)

visitorView.addConstraints(constraintsX)
visitorView.addConstraints(constraintsY)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
App Key：1069040971
App Secret：dced87f388fc65cf3eb6861e0614be24
access token:2.002SUK3C_5a2KB590f93dd00DxZ3yD

access_token目前OAuth1.0为永久有效；OAuth2.0对于未审核应用有效期为24小时，对于已审核应用有效期最低为7天，不同的应用级别有效期不同

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
类名.self获取的是实例类型，即OC中的isa(一个类用结构体类型描述自己)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
1.AnyObject

本身就是一个接口,而且所有的class都隐式的实现了这个接口，这也限制了AnyObject是只适用于Class类型的原因。
AnyObject有什么用呢?
有过Objective-C开发经验的人肯定知道id, 它可以表示任意类的实例, 编译器不会对向声明为 id 的变量进行类型检查.而 Swift为了与 Cocoa 架构进行协作开发，就将原来的id用 AnyObject 来进行替代。

2.Any
既然AnyObject是只适用于Class类型 ，那swift中的所有基本类型怎么办，这个时候呢Any就帮上忙了。Any不仅仅能够容括class类型 ，说得更直白一点, 就是所有的类型都可以用Any表示, 包括基本数据类型, enum, struct, func(方法)等等.

3.AnyClass：
属于AnyObject.Type的别名：typealias AnyClass = AnyObject .Type
表示任意类的元类型，任意类的类型都隐式遵守这个协议.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIXME: 记录需要修改bug的相关说明
//TODO:  记录待办事项的相关说明
// MARK:- 对下面代码的相关说明,带分割线
// MARK: 对下面代码的相关说明,不带分割线

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
set get这两个针对计算属性
willSet didSet这两个针对存储属性

存储型属性：用于存储一个常量或变量。
计算型属性：不直接存储值，而是通过get、set方法来取值或赋值。同时还可以对其他的属性进行操作。
类型型属性：定义在类上的属性，用static 来修饰属性，需要用类名来调用该属性。

class Rectangle {
// 存储型属性
var origin: Point = Point()
var size: Size = Size()

// 计算型属性：（1）必须用var（2）属性的类型不可以省略 （3）如果要想修改属性的值，必须写setter方法，否则只有一个getter方法
var center: Point {

get {
let centerX = origin.x + size.width/2
let centerY = origin.y + size.height/2
return Point(x: centerX, y: centerY)
}
// 如果不写newCenter，可以直接用newValue
set(newCenter) {
origin.x = newCenter.x - size.width/2
origin.y = newCenter.y - size.height/2
}
}

// 如果只是这样写，代表的是只有get方法,是不可以给area赋值的
var area: Double {
return size.width * size.height
}

　　// 类型型属性
　　static var biggestWidth: Double = 0
　　
　　init(origin: Point, size: Size) {
　　self.origin = origin
　　self.size = size
　　}
　　}
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　数组的map:通过提供的闭包，闭包中对每一个数组元素进行处理，并返回处理结果；map的的最终结果是处理后的结果集；
　　数组的filter:通过提供的闭包，闭包中对每一个数组元素进行判断处理，并返回true/false；map的的最终结果是过滤后的结果集；
　　数组的reduce:通过提供的闭包，闭包中对每一个数组元素进行判断处理，并返回拼接结果；map的的最终结果是拼接的最后结果；
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　
　　OC是通过KVC对属性赋值，通过动态派发调用函数
　　Swift类型的成员或者方法在编译时就已经决定，而运行时便不再需要经过一次查找，而可以直接使用。
　　添加@objc修饰符并不意味着这个方法或者属性会变成动态派发，Swift依然可能会将其优化为静态调用。如果你需要和Objective-C里动态调用时相同的运行时特性的话，你需要使用的修饰符是dynamic。一般情况下在做App开发时应该用不上，但是在施展一些像动态替换方法或者运行时再决定实现这样的 "黑魔法" 的时候，我们就需要用到dynamic修饰符了。
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　HttpEngine.httpEngine.getUID { (value, error) in
　　if error == nil {
　　guard let dic = value else{
　　return
　　}
　　
　　print(dic)
　　
　　}else{
　　
　　}
　　}
　　
　　//swift默认是不具备使用OC中KVC机制的；通过添加@objc修饰符，方能具备；
　　//注意key名一定和类中的成员变量名（OC中叫属性名）一样。
　　//setValuesForKeys的实现原理是：使用字典条目的key和字典条目的value作为参数，通过对象调用-setValue:forKey:，
　　//所以一旦，key名类中的成员变量名不一样，就会触发value(forUndefinedKey）的调用，此方法会抛出异常。
　　class Person : NSObject{
　　@objc var age: Int = 0
　　@objc var name: String?
　　@objc private var address: String?
　　
　　override init() {
　　super.init()
　　}
　　
　　func test() -> Void {
　　print("\(age) , \(String(describing: name)) , \(String(describing: address))")
　　}
　　}
　　
　　let dic: [String:Any] = ["age":10, "name":"apple", "address":"shanghai"]
　　
　　let person = Person()
　　person.setValuesForKeys(dic)
　　person.test()
　　
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　小红点的使用
　　selectedBtn?.badgeOffset = CGPoint(x: -btnWidth / 2 + 30 / 2, y: 8)
　　selectedBtn?.showBadge(withValue: 6)
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　微博登录授权返回的token，在第一次获取后就拥有了expires_in；即使再次登录授权，token值是不变的，但是expires_in是减少的。
　　eg:
　　<WeiBo.UserAccount: 0x6000000ac240> {
　　access_token = "2.00sf7gUD_5a2KB4311ca15a6JVlJvD";
　　expiresDate = 2018-02-10 19:00:00 +0000;
　　expires_in = 112336;
　　uid = "3201800892"
　　}
　　
　　<WeiBo.UserAccount: 0x6000000b9e00> {
　　access_token = "2.00sf7gUD_5a2KB4311ca15a6JVlJvD";
　　expiresDate = 2018-02-10 18:59:59 +0000;
　　expires_in = 112153;
　　uid = "3201800892"
　　}
　　
　　<WeiBo.UserAccount: 0x6000000a6360> {
　　access_token = "2.00sf7gUD_5a2KB4311ca15a6JVlJvD";
　　expiresDate = 2018-02-10 18:59:59 +0000;
　　expires_in = 111398;
　　uid = "3201800892"
　　}
　　
　　最简单在class前加@objcMembers，你的swift类就拥有runtime功能了
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　OOM(Out Of Memory)
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　听云：
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　获取视同私有库
　　https://github.com/nst/iOS-Runtime-Headers
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　在处理登录授权成功后，显示已登录内容，中发现：如果将tableView和刷新控件封装成一个类，将访客视图封装成一个类，这两个类在BaseViewController中使用，能解耦很多。（时间紧张就不修改了）
　　removeVisitorView()
　　addTableView()
　　？？？？？？
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　UIViewController方法：
　　loadView被调用时机：调用视图控制器属性view的getter方法时，如果此时view为nil,则loadView会被调用
　　loadView作用：loadView创建视图控制器属性view
　　方法默认实现：即[super loadView]里到底做了哪些工作？
　　1、先查找与视图控制器相关联的xib文件，通过加载xib文件来创建UIViewController的view
　　1.1、如果在初始化UIViewController指定了xib文件名，就会根据传入的xib文件名加载对应的xib文件
　　eg: [[MJViewController alloc] initWithNibName:@"MJViewController" bundle:nil];
　　
　　1.2、如果没有明显地传xib文件名，就会加载跟MJViewController类名相同的xib文件
　　eg:[[MJViewController alloc] init]; // 加载MJViewController.xib
　　
　　2、如果没有找到相关联的xib文件，就会创建一个空白的UIView，然后赋值给UIViewController的view属性，大致如下
　　self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
　　
　　正确使用这个方法:
　　因为有时候，我们自己想自定义试图控制器的view，所以就需要重写loadView方法，并且不需要调用[super loadView]，因为在第2点里面已经提到：
　　若没有xib文件，[super loadView]默认会创建一个空白的UIView。
　　我们既然要通过代码来自定义UIView，那么就没必要事先创建一个空白的UIView，以节省不必要的开销。
　　正确的做法应该是这样：
　　- (void)loadView {
　　self.view = [[[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
　　}
　　不需要调用[super loadView]，你调用了也不会出错，只是造成了一些不必要的开销。
　　总结一句话，苹果设计这个方法就是给我们自定义UIViewController的view用的
　　
　　
　　viewDidLoad被调用时机：不管是通过xib创建view还是通过重写loadView创建view，在创建完view后，都会调用viewDidLoad
　　viewDidLoad作用：一般我们会在这里做界面上的初始化操作，比如往view中添加一些子视图、从数据库或者网络加载模型数据装配到子视图中。例如：
　　- (void)viewDidLoad{
　　[super viewDidLoad];
　　
　　// 添加一个按钮
　　UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
　　[button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
　　[self.view addSubview:button];
　　}
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　static class 的区别
　　
　　Swift中表示 “类型范围作用域” 这一概念有两个不同的关键字，它们分别是static和class。这两个关键字确实都表达了这个意思，但是在其他一些语言，包括Objective-C中，我们并不会特别地区分类变量/类方法和静态变量/静态函数。但是在Swift中，这两个关键字却是不能用混的。
　　
　　static关键字
　　
　　在非class的类型上下文中，我们统一使用static来描述类型作用域。这包括在enum和struct中表述类型方法和类型属性时。在这两个值类型中，我们可以在类型范围内声明并使用存储属性，计算属性和方法。static适用的场景有这些
　　
　　
　　struct Point {
　　let x: Double
　　let y: Double
　　// 存储属性
　　static let zero = Point(x: 0, y: 0)
　　// 计算属性
　　static var ones: [Point] {
　　return [Point(x: 1, y: 1),
　　Point(x: -1, y: 1),
　　Point(x: 1, y: -1),
　　Point(x: -1, y: -1)]
　　}
　　// 类型方法
　　static func add(p1: Point, p2: Point) -> Point {
　　return Point(x: p1.x + p2.x, y: p1.y + p2.y)
　　}
　　}
　　
　　enum的情况与这个十分类似，就不再列举了
　　
　　
　　class关键字
　　
　　class关键字相比起来就明白许多，是专门用在class类型的上下文中的，可以用来修饰类方法以及类的计算属性。要特别注意class中现在是不能出现存储类属性的，我们如果写类似这样的代码的话：
　　
　　class MyClass {
　　class var bar: Bar?
　　}
　　编译时会得到一个错误：
　　
　　class variables not yet supported
　　这主要是因为在Objective-C中就没有类变量这个概念，为了运行时的统一和兼容，暂时不太方便添加这个特性。Apple表示今后将会考虑在某个升级版本中实装class类型的类存储变量，现在的话，我们只能在class中用class关键字声明方法和计算属性。
　　
　　
　　static和class总结
　　
　　类可以使用关键字static class 修饰方法,但是结构体、枚举只能使用关键字static修饰
　　
　　// 定义类
　　class StudentC{
　　static var des:String = "学生的类"
　　var name:String!
　　func getName()->String{
　　return name
　　}
　　
　　class func describe()->String{
　　return des
　　}
　　
　　static func getClassDescribe()->String{
　　return des
　　}
　　}
　　
　　// 定义结构体
　　struct StudentS{
　　static var des:String = "学生的结构体"
　　var name:String
　　static func describe()->String{
　　return "这是一个定义学生的类"
　　}
　　}
　　
　　有一个比较特殊的是protocol。在Swift中class、struct和enum都是可以实现protocol的。那么如果我们想在protocol里定义一个类型域上的方法或者计算属性的话，应该用哪个关键字呢？答案是使用class进行定义，但是在实现时还是按照上面的规则：在class里使用class关键字，而在struct或enum中仍然使用static——虽然在protocol中定义时使用的是class：
　　
　　
　　protocol MyProtocol {
　　class func foo() -> String
　　}
　　struct MyStruct: MyProtocol {
　　static func foo() -> String {
　　return "MyStruct"
　　}
　　}
　　enum MyEnum: MyProtocol {
　　static func foo() -> String {
　　return "MyEnum"
　　}
　　}
　　class MyClass: MyProtocol {
　　class func foo() -> String {
　　return "MyClass"
　　}
　　}
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　上移动画
　　override func didMoveToWindow() {
　　super.didMoveToWindow()
　　//更新自动布局：因为程序运行到didMoveToWindow时，自动布局的约束还未更新成坐标位置，所以需要使用layoutIfNeeded立即更新成坐标位置
　　layoutIfNeeded()
　　
　　self.bottomConstraintOfView.constant = (kScreenHeight() - 120) / 2
　　UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
　　//更新自动布局
　　self.layoutIfNeeded()
　　}) { (_) in
　　
　　}
　　}
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　awakeFromNib从文件加载视图就会调用，这个时候对类引用已生效，但是frame还是约束。
　　didMoveToWindow：视图已加载到Window,frame还是约束
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
　　都知道，这个回调要求返回的是UITableViewCell的高度，但是内容是放在其contentView上的，contentView高度默认比UITableViewCell高度小0.63。我们动态计算的高度是内容区的高度，
　　要额外加上这0.63，才是真正UITableViewCell的高度，否则contentView会自动少0.63，对于文本UILabel来说就会显示不全。
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　//为第三方库(YYModel)指定属性类型
　　class func modelContainerPropertyGenericClass() ->[String:AnyClass] {
　　return ["pic_urls":WBThumbnailPic.self]
　　}
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　界面布局，为了维护布局约束，代码布局比xib中布局虽要写的多些，但是后期可维护性要高。想想看，xib中一个控件上超过4个以上的约束的感觉。
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　派发组的简单演示：
　　func test() {
　　//创建派发组
　　let dispatchGroup = DispatchGroup()
　　//创建并发队列
　　let dispatchQueue = DispatchQueue(label: "", attributes: .concurrent)
　　//将异步派发任务绑定到派发组
　　dispatchQueue.async(group: dispatchGroup) {
　　print("\(Thread.current)---AAAAAA")
　　}
　　
　　dispatchQueue.async(group: dispatchGroup) {
　　print("\(Thread.current)---BBBBBB")
　　}
　　
　　//派发组监听所有任务的完成
　　dispatchGroup.notify(queue: DispatchQueue.main) {
　　print("\(Thread.current)---something")
　　}
　　}
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　//创建标签，并设置属性
　　let label = UILabel()
　　label.backgroundColor = UIColor.yellow
　　label.textColor = UIColor.black
　　label.numberOfLines = 0
　　label.font = UIFont.systemFont(ofSize: 20)
　　
　　//动态计算字符串高度，形成最终实际frame
　　let text = "您好啊Do any additionae您好啊Do any additionae您好啊Do any additionae"
　　
　　let size = CGSize(width: 300, height: 1000)
　　let  height = text.heightOfString(size: size, font: label.font, lineSpacing: 15)
　　label.frame = CGRect(x: 10, y: 300, width: 300, height: height)
　　
　　
　　//创建属性文本，并赋值给标签。
　　let attributeText = NSMutableAttributedString(string: text)
　　
　　let paragraphStyle = NSMutableParagraphStyle()
　　paragraphStyle.lineSpacing = 15.0
　　attributeText.addAttributes([NSAttributedStringKey.paragraphStyle:paragraphStyle, NSAttributedStringKey.font:label.font],
　　range: NSRange(location: 0, length: text.count))
　　
　　label.attributedText = attributeText
　　view.addSubview(label)
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　layoutSubviews:
　　The default implementation of this method does nothing on iOS 5.1 and earlier. Otherwise, the default implementation uses any constraints you have set to determine the size and position of any subviews.
　　Subclasses can override this method as needed to perform more precise layout of their subviews. You should override this method only if the autoresizing and constraint-based behaviors of the subviews do not offer the behavior you want. You can use your implementation to set the frame rectangles of your subviews directly.
　　You should not call this method directly. If you want to force a layout update, call the setNeedsLayout() method instead to do so prior to the next drawing update. If you want to update the layout of your views immediately, call the layoutIfNeeded() method.
　　
　　此方法用来重新定义子元素的位置和大小。子类重写此方法，用来实现UI元素的更精确布局。不能主动调用该方法，如果要让布局重新刷新，那么就调用setNeedsLayout，即setNeedsLayout方法会触发调用layoutSubViews方法（在下一个屏幕刷新点）；如果你想立即刷星，可调用layoutIfNeeded。
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　BYButton使用片段:
　　
　　func constraint() {
　　let btn = BYButton()
　　
　　//设置必要属性
　　btn.isAdjustTitleLabelAndImageView = true
　　btn.setImage(#imageLiteral(resourceName: "common_icon_arrowup"), for: .normal)
　　btn.setTitle("呵呵", for: .normal)
　　btn.setTitleColor(UIColor.blue, for: .normal)
　　btn.addTarget(self, action: #selector(constraintClicked), for: .touchUpInside)
　　//设置可选属性
　　btn.backgroundColor = UIColor.yellow
　　
　　btn.translatesAutoresizingMaskIntoConstraints = false
　　view.addSubview(btn)
　　
　　let left = NSLayoutConstraint(item: btn, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 30.0)
　　let top = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 100.0)
　　
　　let width = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120)
　　let height = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
　　
　　btn.addConstraints([width, height])
　　view.addConstraints([left, top])
　　}
　　
　　@objc func constraintClicked() {
　　print("constraintClicked")
　　}
　　
　　func autoResing() {
　　let btn = BYButton(frame: CGRect(x: 30, y: 100, width: 90, height: 50))
　　//设置必要属性
　　btn.setImage(#imageLiteral(resourceName: "common_icon_arrowup"), for: .normal)
　　btn.setTitle("呵呵", for: .normal)
　　btn.setTitleColor(UIColor.blue, for: .normal)
　　btn.addTarget(self, action: #selector(autoResingClicked), for: .touchUpInside)
　　//设置可选属性
　　btn.backgroundColor = UIColor.yellow
　　
　　view.addSubview(btn)
　　
　　}
　　
　　@objc func autoResingClicked() {
　　print("autoResing")
　　}
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　常用的UIGestureRecognizerState有：
　　
　　Possible：可能手势事件
　　
　　Began：开始手势事件
　　
　　Ended：结束手势事件
　　
　　Changed：手势位置发生变化
　　
　　Failed：无法识别的手势
　　
　　Cancelled:取消手势事件
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　/// TextAttachment测试
　　func testTextAttachment(label: UILabel)  {
　　let attributeString = NSMutableAttributedString(string: "开始吧")
　　
　　//设置Attachment
　　let attachment = NSTextAttachment()
　　//使用一张图片作为Attachment数据
　　attachment.image = #imageLiteral(resourceName: "common_icon_arrowup")
　　//这里bounds的x值并不会产生影响
　　attachment.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
　　
　　let attrStr = NSAttributedString(attachment: attachment)
　　attributeString.append(attrStr)
　　
　　label.attributedText = attributeString
　　}
　　
　　/// NSMutableAttributedString的简单演示
　　func setAttributeTextSimpleShow2(label: UILabel) -> Void {
　　//创建NSMutableAttributedString对象
　　let attributeString = NSMutableAttributedString()
　　
　　//设置文本字体
　　let str0 = "设置文本字体"
　　let dicAttr0 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]
　　let attr0 = NSAttributedString(string: str0, attributes: dicAttr0)
　　attributeString.append(attr0)
　　
　　//设置文本颜色
　　let str1 = "\n设置文本颜色\n"
　　let dicAttr1 = [NSAttributedStringKey.foregroundColor : UIColor.purple]
　　let attr1 = NSAttributedString(string: str1, attributes: dicAttr1)
　　attributeString.append(attr1)
　　
　　//设置文本背景颜色
　　let str2 = "设置文本背景颜色"
　　let dicAttr2 = [NSAttributedStringKey.backgroundColor : UIColor.cyan]
　　let attr2 = NSAttributedString(string: str2, attributes: dicAttr2)
　　attributeString.append(attr2)
　　
　　/*
　　注：NSLigatureAttributeName设置连体属性，取值为NSNumber对象（整数），1表示使用默认的连体字符，0表示不使用，2表示使用所有连体符号（iOS不支持2）。
　　而且并非所有的字符之间都有组合符合。如 fly ，f和l会连起来。
　　*/
　　//设置连体属性
　　let str3 = "而且NSAttributedStringKeyand123ABC"
　　let dicAttr3 = [NSAttributedStringKey.font : UIFont.init(name: "futura", size: 14) ?? UIFont.systemFont(ofSize: 14),
　　NSAttributedStringKey.ligature : NSNumber.init(value: 1)]
　　let attr3 = NSAttributedString(string: str3, attributes: dicAttr3 )
　　attributeString.append(attr3)
　　
　　/*!
　　注：NSKernAttributeName用来设置字符之间的间距，取值为NSNumber对象（整数），负值间距变窄，正值间距变宽
　　*/
　　let str4 = "\n设置字符之间的间距"
　　let dicAttr4 = [NSAttributedStringKey.kern : NSNumber.init(value: 4)]
　　let attr4 = NSAttributedString(string: str4, attributes: dicAttr4)
　　attributeString.append(attr4)
　　
　　/*!
　　注：NSStrikethroughStyleAttributeName设置删除线，取值为NSNumber对象，枚举NSUnderlineStyle中的值。
　　NSStrikethroughColorAttributeName设置删除线的颜色。并可以将Style和Pattern相互 取与 获取不同的效果
　　*/
　　let str51 = "\n设置删除线为细的单实线，颜色为红色"
　　let dicAttr51 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue),
　　NSAttributedStringKey.strikethroughColor : UIColor.red]
　　let attr51 = NSAttributedString(string: str51, attributes: dicAttr51)
　　attributeString.append(attr51)
　　
　　let str52 = "\n设置删除线为粗的单实线，颜色为红色"
　　let dicAttr52 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleThick.rawValue),
　　NSAttributedStringKey.strikethroughColor : UIColor.red]
　　let attr52 = NSAttributedString(string: str52, attributes: dicAttr52)
　　attributeString.append(attr52)
　　
　　let str53 = "\n设置删除线为细的双实线，颜色为红色"
　　let dicAttr53 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleDouble.rawValue),
　　NSAttributedStringKey.strikethroughColor : UIColor.red]
　　let attr53 = NSAttributedString(string: str53, attributes: dicAttr53)
　　attributeString.append(attr53)
　　
　　let str54 = "\n设置删除线为细的单虚线，颜色为红色"
　　let dicAttr54 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternDot.rawValue),
　　NSAttributedStringKey.strikethroughColor : UIColor.red]
　　let attr54 = NSAttributedString(string: str54, attributes: dicAttr54)
　　attributeString.append(attr54)
　　
　　/*!
　　NSStrokeWidthAttributeName 设置笔画的宽度，取值为NSNumber对象（整数），负值填充效果，正值是中空效果。
　　NSStrokeColorAttributeName 设置填充部分颜色，取值为UIColor对象。
　　设置中间部分颜色可以使用 NSForegroundColorAttributeName 属性来进行
　　*/
　　let str6 = "\n设置笔画的宽度和填充颜色"
　　let dicAttr6 = [NSAttributedStringKey.strokeWidth : NSNumber.init(value: 2),
　　NSAttributedStringKey.strokeColor : UIColor.blue]
　　let attr6 = NSAttributedString(string: str6, attributes: dicAttr6)
　　attributeString.append(attr6)
　　
　　//设置阴影，取值为NSShadow对象
　　let str7 = "\n设置阴影，取值为NSShadow对象"
　　let shadow = NSShadow()
　　shadow.shadowColor = UIColor.red
　　shadow.shadowBlurRadius = 1.0
　　shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
　　let dicAttr7 = [NSAttributedStringKey.shadow : shadow]
　　let attr7 = NSAttributedString(string: str7, attributes: dicAttr7)
　　attributeString.append(attr7)
　　
　　//设置文本特殊效果，取值为NSString类型，目前只有一个可用效果  NSTextEffectLetterpressStyle（凸版印刷效果）
　　let str8 = "\n设置文本特殊效果"
　　let dicAttr8 = [NSAttributedStringKey.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle.rawValue]
　　let attr8 = NSAttributedString(string: str8, attributes: dicAttr8)
　　attributeString.append(attr8)
　　
　　//设置文本附件，取值为NSTextAttachment对象，常用于文字的图文混排
　　let str9 = "\n图1文混排文字的图文混排文字的图文混排"
　　let attr90 = NSAttributedString(string: str9)
　　attributeString.append(attr90)
　　
　　let textAttachment = NSTextAttachment()
　　textAttachment.image = #imageLiteral(resourceName: "common_icon_arrowup")
　　textAttachment.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
　　let attr91 = NSAttributedString(attachment: textAttachment)
　　attributeString.append(attr91)
　　
　　/*!
　　添加下划线 NSUnderlineStyleAttributeName。设置下划线的颜色 NSUnderlineColorAttributeName，对象为 UIColor。使用方式同删除线一样。
　　*/
　　//添加下划线
　　let str10 = "\n添加下划线"
　　let dicAttr10 = [NSAttributedStringKey.underlineStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue),
　　NSAttributedStringKey.underlineColor : UIColor.red]
　　let attr10 = NSAttributedString(string: str10, attributes: dicAttr10)
　　attributeString.append(attr10)
　　
　　/*!
　　NSBaselineOffsetAttributeName 设置基线偏移值。取值为NSNumber （float），正值上偏，负值下偏
　　*/
　　//设置基线偏移值 NSBaselineOffsetAttributeName
　　let str11 = "\n设置基线偏移值"
　　let dicAttr11 = [NSAttributedStringKey.baselineOffset : NSNumber.init(value: 0),
　　NSAttributedStringKey.backgroundColor : UIColor.blue]
　　let attr11 = NSAttributedString(string: str11, attributes: dicAttr11)
　　attributeString.append(attr11)
　　
　　/*!
　　NSObliquenessAttributeName 设置字体倾斜度，取值为 NSNumber（float），正值右倾，负值左倾
　　*/
　　//设置字体倾斜度 NSObliquenessAttributeName
　　let str12 = "\n设置字体倾斜度"
　　let dicAttr12 = [NSAttributedStringKey.obliqueness : NSNumber.init(value: 0.5)]
　　let attr12 = NSAttributedString(string: str12, attributes: dicAttr12)
　　attributeString.append(attr12)
　　
　　/*!
　　NSExpansionAttributeName 设置字体的横向拉伸，取值为NSNumber （float），正值拉伸 ，负值压缩
　　*/
　　//设置字体的横向拉伸 NSExpansionAttributeName
　　let str13 = "\n设置字体的横向拉伸"
　　let dicAttr13 = [NSAttributedStringKey.expansion : NSNumber.init(value: 0.5)]
　　let attr13 = NSAttributedString(string: str13, attributes: dicAttr13)
　　attributeString.append(attr13)
　　
　　/*!
　　NSWritingDirectionAttributeName 设置文字的书写方向，取值为以下组合
　　@[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)]
　　@[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
　　@[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]
　　@[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)]
　　
　　???NSWritingDirectionEmbedding和NSWritingDirectionOverride有什么不同
　　*/
　　//设置文字的书写方向 NSWritingDirectionAttributeName
　　let str14 = "\n设置文字书写方向\n";
　　let dictAttr14 = [NSAttributedStringKey.writingDirection:
　　[NSNumber.init(value: NSWritingDirection.leftToRight.rawValue|NSWritingDirectionFormatType.embedding.rawValue)]]
　　let attr14 = NSAttributedString(string: str14, attributes: dictAttr14)
　　attributeString.append(attr14)
　　
　　/*
　　NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为NSNumber对象（整数），0表示横排文本，1表示竖排文本
　　The value 0 indicates horizontal text. The value 1 indicates vertical text. In iOS, horizontal text is always used and specifying a different value is undefined.
　　*/
　　//设置文字排版方向 NSVerticalGlyphFormAttributeName
　　let str15 = "设置文字排版方向\n";
　　let dictAttr15 = [NSAttributedStringKey.verticalGlyphForm : NSNumber.init(value: 1)]
　　let attr15 = NSAttributedString(string: str15, attributes: dictAttr15)
　　attributeString.append(attr15)
　　
　　//设置段落样式
　　let paragrapStyle = NSMutableParagraphStyle()
　　
　　//行间距
　　paragrapStyle.lineSpacing = 0
　　
　　//段落间距
　　paragrapStyle.paragraphSpacing = 0
　　
　　//对齐方式
　　paragrapStyle.alignment = .left
　　
　　//指定段落开始的缩进像素
　　paragrapStyle.firstLineHeadIndent = 0
　　
　　//调整全部文字的缩进像素
　　paragrapStyle.headIndent = 0
　　
　　//添加段落属性
　　attributeString.addAttribute(.paragraphStyle,
　　value: paragrapStyle,
　　range: NSRange.init(location: 0, length: attributeString.length))
　　
　　label.attributedText = attributeString
　　}
　　
　　/// NSMutableAttributedString的简单演示
　　func setAttributeTextSimpleShow1(label: UILabel, text: String) -> Void {
　　//创建NSMutableAttributedString对象
　　let attrStr = NSMutableAttributedString(string: text)
　　
　　//设置文字字体和影响范围
　　attrStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(0, 5))
　　
　　//设置文字颜色和影响范围
　　attrStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(5, 5))
　　
　　//设置文字背景颜色和影响范围
　　attrStr.addAttribute(.backgroundColor, value: UIColor.yellow, range: NSMakeRange(5, 10))
　　
　　//设置文字下划线和影响范围
　　attrStr.addAttribute(.underlineStyle, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(10, 10))
　　
　　label.attributedText = attrStr
　　}
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　从第三方bundle中获取资源
　　let bundlepath = Bundle.main.path(forResource: "HMEmoticon", ofType: "bundle")
　　let bundle = Bundle.init(path: bundlepath!)
　　let img_path = bundle?.path(forResource: "compose_emotion_delete_highlighted@2x", ofType: "png")
　　let image = UIImage.init(contentsOfFile: img_path!)
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　XCODE sourceTree文件状态变化
　　'A' 新增
　　'D' 删除
　　'M' 修改
　　'R' 替代
　　'C' 冲突
　　'I' 忽略
　　'?' 未受控
　　'!' 丢失，一般是将受控文件直接删除导致
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　@escaping @noescape
　　如果函数闭包参数是在这个函数结束前内被调用，就是非逃逸的即noescape；
　　如果函数闭包参数是在函数执行完后才被调用，即，调用的地方超过了这函数的范围，叫逃逸闭包。
　　默认是@noescape
　　
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　奇怪，设置isEnabled是否可用，必须放置在后面，才生效
　　self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
　　rightButton.isEnabled = false
　　//////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　iOS Swift用Alamofire图片和其他参数一起上传
　　https://www.jianshu.com/p/d519f743ce8d
　　/////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　去掉UITextView的pading和Margin的方法:
　　textView.textContainer.lineFragmentPadding = 0.0
　　textView.textContainerInset = UIEdgeInsets.zero
　　
　　内容永不调整（默认automatic你会发现bound被视图控制器调整了）
　　textView.contentInsetAdjustmentBehavior = .never
　　/////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　//十六进制字符串
　　let code = "0x1f6b9"
　　
　　//将十六进制字符串转成十进制数值
　　let scanner = Scanner(string: code)
　　var result: UInt32 = 0
　　scanner.scanHexInt32(&result)
　　
　　//使用十进制数值，生成utf8字符
　　if let  scalar = UnicodeScalar(result) {
　　let c = Character(scalar)
　　let emotion = String.init(c)
　　print(emotion)
　　}
　　/////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　问题是pod install完成后还是提示：解决Swift中出现 No such module 'YYModel'
　　解决办法是在build phases中的link binary with libraries中先删除pods_xxx.framework，再重新添加一次就好了
　　/////////////////////////////////////////////////////////////////////////////////////////////////////////////
　　
　　--导航栏及标签栏图片及文字设置
　　-(void)addRootViewController{
　　//单独设置标题，也可以统一设置标题
　　[[UINavigationBar appearance]setBarTintColor:UIColor.redColor];
　　[[UINavigationBar appearance]setTintColor:UIColor.yellowColor];
　　[UINavigationBar appearance].titleTextAttributes =  @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
　　
　　//单独设置标题，也可以统一设置标题
　　//    self.navigationController.navigationBar.titleTextAttributes=
　　//    @{NSForegroundColorAttributeName:[UIColor blackColor],
　　//      NSFontAttributeName:[UIFont systemFontOfSize:16]};
　　
　　//tab0
　　ContactViewController *vc0 = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:[NSBundle mainBundle]];
　　UINavigationController *nav0 = [[UINavigationController alloc]initWithRootViewController:vc0];
　　
　　UIImage *image0 = [[UIImage imageNamed:@"tab_home_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　UIImage *selectedImage0 = [[UIImage imageNamed:@"tab_home_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　nav0.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"好友" image:image0 selectedImage:selectedImage0];
　　
　　//tab1
　　RecentlyViewController *vc1 = [[RecentlyViewController alloc]initWithNibName:@"RecentlyViewController" bundle:nil];
　　UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
　　
　　UIImage *image1 = [[UIImage imageNamed:@"tab_marketing_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　UIImage *selectedImage1 = [[UIImage imageNamed:@"tab_marketing_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"最近" image:image1 selectedImage:selectedImage1];
　　
　　//tab2
　　MeViewController *vc2 = [[MeViewController alloc]initWithNibName:@"MeViewController" bundle:[NSBundle mainBundle]];
　　UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
　　
　　UIImage *image2 = [[UIImage imageNamed:@"tab_mine_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　UIImage *selectedImage2 = [[UIImage imageNamed:@"tab_mine_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
　　nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:image2 selectedImage:selectedImage2];
　　
　　UITabBarController *tabBarController = [[UITabBarController alloc]init];
　　tabBarController.viewControllers = @[nav0, nav1, nav2];
　　
　　//一、如果只是设置选中状态的字体颜色，使用 tintColor  就可以达到效果
　　//tabBarController.tabBar.tintColor = [UIColor orangeColor];
　　
　　//二、但如果要将未选中状态和选中状态下的颜色都改变，可以使用 setTitleTextAttributes:<#(nullable NSDictionary<NSString *,id> *)#> forState:<#(UIControlState)#> 达到效果
　　[nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
　　[nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
　　
　　//或者
　　//[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
　　//[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
　　
　　
　　_window.rootViewController = tabBarController;
　　}

--在控制器的viewDidLoad中打印navigationController有时为nil，那是因为在push或present控制器之前，你调用了控制器的view，并对其属性做了修改，从而触发viewDidLoad提前调用。

--UINavigationBar我们对其frame设置（0， 0， screemWidth, 状态栏高度+系统导航栏高度），很明显我们变更了UINavigationBar高度，导致系统导航栏高度下方是透明的，若要其正常显示需要分别对其子视图_UIBarBackground和_UINavigationBarContentView调整frame:

class MQLNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            print("UINavigationBar subview-- \(stringFromClass)")
            if stringFromClass.contains("BarBackground") {
                subview.frame = self.bounds
            } else if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.cz_screenWidth(), height: self.bounds.height - UIApplication.shared.statusBarFrame.height)
            }
        }
    }

}

---在工程目录下执行pod install后，生成xxx.xcworkspace工程文件，用sourceTree提交,发现xxx.xcworkspace工程文件提不上去，原因是被gitignore过滤了，sourceTree有两处设置了过滤：
1、全局忽略列表
2、仓库指定忽略列表
从这两个地方，去掉IDEWorkspaceChecks.plist和contents.xcworkspacedata



　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　
　　


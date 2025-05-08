# mql4-template

نت رو گشتم یه تمپلیت اماده نبود برای ساختن اکسپرت(متا۴)
توی هر پروژه یا باید از پروژه های قبلی کپی میکردی یا از اول مینویشتی این وسط چیزی رو هم عوض میکردی نمیدونستی از کودوم بالاخره باید کپی بگیری

یه جیزی میخواستم که این مشکلو حل کنه و تمرکزمون روی منطق ربات نباشه 

یه تمیلیتی ساختم با این ویژگی هایی که تقریبا توی همه پروژه ها نیاز میشه 

۵تا کتابخونه داریم:
trade-tools-strategy-order-array

که توی هر قسمت فایلهایی با پسوند .test هستش مثلا:
logger.test.mq4
اینارو ساختم برای تست و فهمیدن نحوه استفاده از کتابخونه 
در اخر هم یه بات ساده که با ۲تا مووینگ ترید میکنه با استفاده از این کتابخونه ها برای نمونه ساختم تا نحوه استفادشون نوشته باشم که اسمش:
ma-bot.mq4

این تمپلیت الان ورژن ۲.۱ هستش و بار اول هستش که نوشته میشه پس قطعا ممکنه نیاز به اپدیت هم باشه و ورژنهای جدید که اومد همینجا میفرستم
پروژه رو بصورت oop نوشتم و سعی کنم بصورت بهینه بالا بیاد طوری که از کپی استفاده نکردم فقط رفرنس و پوینتر 
اگه پوینتری گلوبالی میسازید توی OnDeinit حتما حذفش کنید تا حافظه ازاد بشه و اگه ارایه میسازید که داینامیک هستش از reserve_size استفاده کنید تا بهینه باشه و همین ارایه روهم توی OnDeinit ریسایز کنید به 0 

مشکلی-باگی-... چیزی بود ممنون میشم بگید🌹



## MQL4 Expert Advisor Template

I searched around but couldn’t find a proper template for building an Expert Advisor (EA) in MetaTrader 4 (MT4). In most projects, you either had to copy from older ones or start from scratch. The problem was, once you started modifying things, it became unclear what to copy from where.

So, I created a clean, structured template to solve that problem and help shift the focus away from boilerplate setup and more toward EA logic.

### Features

This template includes components that are commonly needed in most EA projects. It follows an object-oriented programming (OOP) approach, with performance in mind. There's **no copy-pasting** involved—everything is designed around references and pointers.

#### Included Libraries

The template includes 5 libraries bundled under:

```
trade-tools-strategy-order-array
```

Each section includes `.test` files (e.g., `logger.test.mq4`) to help understand how to use the corresponding libraries.

#### Example Bot

A simple bot is included as an example:
`ma-bot.mq4`
It trades using two moving averages and showcases how to use the libraries together in a real scenario.

If you find any bugs or issues, I’d really appreciate the feedback! 🌹


#### Structure

```
.
├── libs
│   ├── array
│   │   ├── array-tools.mqh
│   │   ├── array-tools.test.ex4
│   │   └── array-tools.test.mq4
│   ├── order
│   │   ├── lot-calculator.test.ex4
│   │   ├── MarketOrderManager.mqh
│   │   ├── OrderManagerConstants.mqh
│   │   ├── OrderManager.mqh
│   │   ├── PendingOrderManager.mqh
│   │   ├── TradeUtils.mqh
│   │   ├── TradeUtils.test.ex4
│   │   ├── TradeUtils.test.mq4
│   │   └── TradingSystem.mqh
│   ├── strategy
│   │   ├── strategy1.mqh
│   │   └── strategy-abstract.mqh
│   ├── tools
│   │   ├── comment-info.mqh
│   │   ├── defines.mqh
│   │   ├── logger.mqh
│   │   ├── logger.test.ex4
│   │   ├── logger.test.mq4
│   │   ├── time-handler.mqh
│   │   ├── time-handler.test.ex4
│   │   └── time-handler.test.mq4
│   └── trade
│       ├── trade-history.mqh
│       ├── trade-history.test.ex4
│       ├── trade-history.test.mq4
│       └── trade-manager.mqh
├── ma-bot.ex4
└── ma-bot.mq4

```


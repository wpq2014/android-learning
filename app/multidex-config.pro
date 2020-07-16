#请确保神策 Android SDK 的代码都指定到主 DEX 中
#-keep class com.sensorsdata.analytics.android.sdk.data.SensorsDataContentProvider { *; }
##-keep class com.sensorsdata.analytics.android.** { *; }
#
## 确保MainActivity在主dex中，bugly #6884统计到ActivityNotFoundException
#-keep class com.dankegongyu.customer.business.main.MainActivity { *; }
#-keep class com.dankegongyu.customer.business.guide.GuideActivity { *; }
#
## https://github.com/Tencent/tinker/issues/1258
#-keep public class com.tencent.tinker.entry.TinkerApplicationInlineFence {
#    <init>(...);
#    void attachBaseContext(com.tencent.tinker.loader.app.TinkerApplication, android.content.Context);
#}
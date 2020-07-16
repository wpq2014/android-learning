# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile



#-------------------------- 3.js WebView相关 start ------------------------
# refs : https://www.zhihu.com/question/31316646

-dontwarn android.webkit.WebView
-keep public class android.webkit.**

# 保留javascript相关的属性
-keepattributes *JavascriptInterface*
-keep class android.webkit.JavascriptInterface {*;}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# https://www.zhihu.com/question/31316646/answer/51481410
-keepclassmembers class * extends android.webkit.WebChromClient {
    public void openFileChooser(...);
}

-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}

#-------------------------- 3.js WebView相关 end ------------------------


#-------------------------- 4.反射相关的类和方法 start ----------------------

#-dontwarn com.jaydenxiao.common.commonutils.**
#-keep class com.jaydenxiao.common.commonutils.** { *; }

#-------------------------- 4.反射相关的类和方法 end ------------------------


#--------------------------------------- 基本不用动区域 start----------------------------------------

#----------------------------- 基本指令区 start ------------------------------

#-dontoptimize # 开启这个下面的配置无效
# 指定混淆时采用的算法，后面的参数是一个过滤器，这个过滤器是谷歌推荐的算法，一般不改变, https://blog.csdn.net/adark0915/article/details/55045453
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*,!code/allocation/variable
# 代码混淆压缩比，在0和7之间，默认为5，一般不需要改
-optimizationpasses 5

# 混淆时不使用大小写混合，混淆后的类名为小写
-dontusemixedcaseclassnames

# 指定不去忽略非公共库的类和类的成员
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers

# 不做预校验，preverify是proguard的四个步骤之一，Android不需要preverify，去掉这一步能够加快混淆速度。
-dontpreverify

# 有了verbose这句话，混淆后就会生成映射文件，包含有类名->混淆后类名的映射关系，然后使用printmapping指定映射文件的名称
-verbose
-printmapping proguardMapping.txt

# 保护代码中的Annotation不被混淆，这在JSON实体映射时非常重要，比如fastJson，还有@JavascriptInterface
-keepattributes *Annotation*

# 避免混淆泛型，这在JSON实体映射时非常重要，比如fastJson
-keepattributes Signature

# 抛出异常时保留代码行号
-keepattributes SourceFile
-keepattributes LineNumberTable

# 避免混淆内部类、匿名类
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# 异常
-keepattributes Exceptions

# 其他
-ignorewarnings
#-dontshrink

#----------------------------- 基本指令区 end ------------------------------


#----------------------------- 默认保留区 start ------------------------------

# AndroidX
-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
#-keep public class * extends androidx.** // 先不要这个
-keep interface androidx.** {*;}
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**

# 保留了继承自Activity、Application这些类的子类，因为这些子类，都有可能被外部调用
# 保留四大组件，自定义的Application等这些类不被混淆
-keep public class * extends android.app.Application
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.Fragment
-keep public class * extends androidx.fragment.app.Fragment
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService
-keep public class * extends android.app.backup.BackupAgentHelper
-keep class android.support.** {*;}
-keep class android.support.v4.app.NotificationCompat { *; }
-keep class android.support.v4.app.NotificationCompat$Builder { *; }

# 保留在Activity中的方法参数是view的方法，从而我们在layout里面编写onClick就不会被影响
-keepclassmembers class * extends android.app.Activity {
    public void * (android.view.View);
}

# 保持枚举enum类不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保持自定义控件不被混淆
-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# 保留Parcelable序列化类不被混淆
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}
-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
-keepclasseswithmembers class * implements android.os.Parcelable {*;}

# 保留Serializable序列化类不被混淆
-keep class * implements java.io.Serializable {*;}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 对于R（资源）下的所有类及其方法，都不能被混淆
-keep class **.R$* {
    *;
}

# 对于带有回调函数XXEvent的，不能被混淆
-keepclassmembers class * {
    void * (**Event);
}

# 保留本地native方法不被混淆
-keepclassmembers class * {
    native <methods>;
}
# 保留R下面的资源
-keep class **.R$* {
    *;
}

# 其他
-dontwarn android.support.v4.**
-keep public class javax.**
-keep public class android.support.v4.content.FileProvider {*;}
-keep public class androidx.core.content.FileProvider {*;}

# keep
-dontwarn android.support.annotation.Keep
-keep @android.support.annotation.Keep class * {*;}
-keep,allowobfuscation @interface androidx.annotation.Keep
-keep @androidx.annotation.Keep class **
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# 去掉Log日志
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** e(...);
    public static *** w(...);
}

#----------------------------- 默认保留区 end ------------------------------

#--------------------------------------- 基本不用动区域 end----------------------------------------
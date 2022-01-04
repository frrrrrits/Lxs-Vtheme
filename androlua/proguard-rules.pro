-dontwarn okio.**
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.ParametersAreNonnullByDefault

-keep class com.google.android.material.** { *; }
-dontwarn com.google.android.material.**

-keep,allowoptimization class okhttp3.** { public protected *; }
-keep class com.androlua.** { *; }
-keep class com.luajava.** { *; }

-keep class android.**{*;}
-keep class androidx.**{*;}
-keep class com.**{*;}
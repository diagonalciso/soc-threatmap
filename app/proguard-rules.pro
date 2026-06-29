# WebView JS bridge methods must survive shrinking (none enabled in release, but keep safe).
-keepclassmembers class eu.cisodiagonal.attackmap.** {
    @android.webkit.JavascriptInterface <methods>;
}

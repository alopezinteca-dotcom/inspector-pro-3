pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    // ✅ Cargar path del SDK de Flutter
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val path = properties.getProperty("flutter.sdk")
        require(path != null) { "flutter.sdk not set in local.properties" }
        path
    }

    // ✅ ENLAZAR GRADLE DE FLUTTER (CLAVE ABSOLUTA)
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    // ✅ ESTE SÍ VA AQUÍ, y SOLO este
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // ✅ AGP y Kotlin declarados SOLO PARA QUE EXISTAN, pero sin aplicar
    id("com.android.application") version "8.6.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
}

// ✅ Registrar el módulo app
include(":app")

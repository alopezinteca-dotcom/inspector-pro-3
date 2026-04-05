pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // ❌ NO pongas: id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
}

include(":app")

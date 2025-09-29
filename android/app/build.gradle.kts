import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.trigon.trigon_scouting_app_2025"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.trigon.scoutingapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        minSdk = flutter.minSdkVersion
    }

    // Load key.properties if it exists
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        create("release") {
            // Only assign properties if file exists
            print("Keystore file exists: ${keystorePropertiesFile.exists()}")
            if (keystorePropertiesFile.exists()) {
                (keystoreProperties.getProperty("keyAlias") ?: "").takeIf { it.isNotEmpty() }?.let { keyAlias = it }
                (keystoreProperties.getProperty("keyPassword") ?: "").takeIf { it.isNotEmpty() }
                    ?.let { keyPassword = it }
                keystoreProperties.getProperty("storeFile")?.takeIf { it.isNotEmpty() }?.let { storeFile = file(it) }
                (keystoreProperties.getProperty("storePassword") ?: "").takeIf { it.isNotEmpty() }
                    ?.let { storePassword = it }
            } else {
                print("Keystore properties file not found, skipping signing config.")
                storeFile = null
            }
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            if (keystorePropertiesFile.exists()) signingConfig = signingConfigs.getByName("release")
        }
        create("pr") {
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = true
            signingConfig = null
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}

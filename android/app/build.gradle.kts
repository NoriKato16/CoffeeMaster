plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")     
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "cl.kato.Coffee_Master"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "cl.kato.Coffee_Master"
        minSdk = flutter.minSdkVersion      
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        // requerido por flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
 
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

}

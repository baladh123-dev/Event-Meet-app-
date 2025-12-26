import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "EventMeetapp.event.meet.EventMeet"

    // ✅ Correct place for compileSdk
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "EventMeetapp.event.meet.EventMeet"

        // ✅ FIXED (was 23 → now 24)
        minSdk = 24

        // ✅ Proper target SDK
        targetSdk = 36

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val props = project.properties

            storeFile = file(props["RELEASE_STORE_FILE"] as String)
            storePassword = props["RELEASE_STORE_PASSWORD"] as String
            keyAlias = props["RELEASE_KEY_ALIAS"] as String
            keyPassword = props["RELEASE_KEY_PASSWORD"] as String
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                File("proguard-rules.pro")
            )
        }
    }
}

dependencies {
    // ✅ Firebase BOM (recommended)
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
    implementation("com.google.firebase:firebase-analytics")

    // ✅ Required for Java 8+ APIs on lower devices
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

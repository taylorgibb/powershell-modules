Deploy gibbels-algorithms {
    By PSGalleryModule {
        FromSource gibbels-common
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
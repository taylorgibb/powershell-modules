Deploy gibbels-algorithms {
    By PSGalleryModule {
        FromSource gibbels-algorithms
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
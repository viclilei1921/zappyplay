bool isVideo(String ext) =>
    ['.mp4', '.mkv', '.avi', '.mov', '.flv', '.wmv'].contains(ext);

bool isImage(String ext) =>
    ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext);

bool isAudio(String ext) =>
    ['.mp3', '.aac', '.wav', '.flac', '.ogg', '.m4a'].contains(ext);

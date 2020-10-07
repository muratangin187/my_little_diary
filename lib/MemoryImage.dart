class MemoryImageObject{
  final int id;
  final int memoryId;
  final String path;
  MemoryImageObject({this.id, this.memoryId, this.path});

  Map<String, dynamic> toMap() {
    if(id != null){
      return {
        'id': id,
        'memoryId': memoryId,
        'path': path,
      };
    }else{
      return {
        'memoryId': memoryId,
        'path': path,
      };
    }
  }

}
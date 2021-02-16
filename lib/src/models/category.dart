class Category {
  final String id;
  final String name;
  final String image;

  Category.fromJSON(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'] ?? '',
        this.image = parsedJson['image'] ?? '';

  @override
  String toString(){
    return this.name;
  }

  Map<String,dynamic> toJSON()=>{'_id':this.id,'name':this.name,'image':this.image};


}
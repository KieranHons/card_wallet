class CardModel {
  late String? _title;
  late String? _image;
  late String? _barcode;

  CardModel(this._title, this._image, this._barcode);

  CardModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _image = json['image'];
    _barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() => {
    "title": _title,
    "image": _image,
    "barcode": _barcode
  };

  String? get title => _title;

  String? get image => _image;

  String? get barcode => _barcode;
}

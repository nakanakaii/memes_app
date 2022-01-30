// ignore_for_file: non_constant_identifier_names

class Memes {
  String? id;
  String? name;
  String? url;
  int? width;
  int? heigt;
  int? box_count;

  Memes({
    this.id,
    this.name,
    this.url,
    this.width,
    this.heigt,
    this.box_count,
  });

  factory Memes.fromJson(Map<String, dynamic> json) => Memes(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        width: json["width"],
        heigt: json["heigt"],
        box_count: json["box_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "width": width,
        "heigt": heigt,
        "box_count": box_count,
      };
}

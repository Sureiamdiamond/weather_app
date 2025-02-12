import 'package:test_app/feature/domain/entities/condition_entity.dart';

class ConditionModel extends ConditionEntity {
  ConditionModel({text, icon, code})
      : super(text: text, icon: icon, code: code);

  ConditionModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    icon = json['icon'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = text;
    data['icon'] = icon;
    data['code'] = code;
    return data;
  }
}

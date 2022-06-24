class TextFieldModel {
  String? elementType;
  ElementConfig? elementConfig;
  Help? help;
  String? value;
  Validation? validation;
  bool? valid;
  bool? onchange;

  TextFieldModel({this.elementType, this.elementConfig, this.help, this.value, this.validation, this.valid, this.onchange});

  TextFieldModel.fromJson(Map<String, dynamic> json) {
    elementType = json['elementType'];
    elementConfig = json['elementConfig'] != null ? new ElementConfig.fromJson(json['elementConfig']) : null;
    help = json['help'] != null ? new Help.fromJson(json['help']) : null;
    value = json['value'];
    validation = json['validation'] != null ? new Validation.fromJson(json['validation']) : null;
    valid = json['valid'];
    onchange = json['onchange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['elementType'] = this.elementType;
    if (this.elementConfig != null) {
      data['elementConfig'] = this.elementConfig!.toJson();
    }
    if (this.help != null) {
      data['help'] = this.help!.toJson();
    }
    data['value'] = this.value;
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    data['valid'] = this.valid;
    data['onchange'] = this.onchange;
    return data;
  }
}

class ElementConfig {
  String? type;
  String? name;
  String? label;
  String? placeholder;
  String? classProperty;
  bool? resetIcon;
  String? nextName;

  ElementConfig({this.type, this.name, this.label, this.placeholder, this.classProperty, this.resetIcon,this.nextName});

  ElementConfig.fromJson(Map<String, dynamic> json) {
  type = json['type'];
  name = json['name'];
  label = json['label'];
  placeholder = json['placeholder'];
  classProperty = json['class'];
  resetIcon = json['resetIcon'];
  nextName = json['nextName'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['type'] = this.type;
  data['name'] = this.name;
  data['label'] = this.label;
  data['placeholder'] = this.placeholder;
  data['class'] = this.classProperty;
  data['resetIcon'] = this.resetIcon;
  data['nextName'] = this.nextName;
  return data;
  }
}

class Help {
  String? text;
  String? placement;

  Help({this.text, this.placement});

  Help.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    placement = json['placement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['placement'] = this.placement;
    return data;
  }
}

class Validation {
  bool? required;
  int? minLength;
  int? maxLength;
  String? rejex;
  bool? isReadOnly;
  bool? isDisabled;
  ErrorMessage? errorMessage;

  Validation({this.required, this.minLength, this.maxLength, this.rejex, this.isReadOnly, this.isDisabled,this.errorMessage});

  Validation.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    rejex = json['rejex'];
    isReadOnly = json['isReadOnly'];
    isDisabled = json['isDisabled'];
    errorMessage = json['errorMessage'] != null ? ErrorMessage.fromJson(json['errorMessage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['required'] = this.required;
    data['minLength'] = this.minLength;
    data['maxLength'] = this.maxLength;
    data['rejex'] = this.rejex;
    data['isReadOnly'] = this.isReadOnly;
    data['isDisabled'] = this.isDisabled;
    if (this.errorMessage != null) {
      data['errorMessage'] = this.errorMessage!.toJson();
    }
    return data;
  }
}

class ErrorMessage {
  String? required;
  String? minLength;
  String? maxLength;
  String? rejex;

  ErrorMessage({this.required, this.minLength, this.maxLength, this.rejex});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    rejex = json['rejex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['required'] = this.required;
    data['minLength'] = this.minLength;
    data['maxLength'] = this.maxLength;
    data['rejex'] = this.rejex;
    return data;
  }
}
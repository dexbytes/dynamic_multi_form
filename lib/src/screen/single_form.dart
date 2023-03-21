part of dynamic_json_form;

class SingleForm extends StatefulWidget {
  final List<dynamic> formFieldList;
  final int index;
  final Function(int,Map<String,dynamic>)? nextPageButtonClick;
  final Function(int,Map<String,dynamic>)? finalSubmitCallBack;
  final Function(Widget)? nextPageButton;
  final Function(Widget)? priPageButton;
  const SingleForm({Key? key,this.formFieldList = const [],this.nextPageButtonClick,this.finalSubmitCallBack,this.nextPageButton,this.priPageButton,this.index = 0}) : super(key: key);

  @override
  State<SingleForm> createState() => _SingleFormState(index: index);
}

class _SingleFormState extends State<SingleForm> {
  //We will include the entered values in the map from field on submit click
  Map<String,dynamic> formSubmitData = <String,dynamic>{};
  Map<String,dynamic> autoValidateFieldList = <String,bool>{};
  List<String> fieldsForValidate = [];
  var _formKey;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final StreamController<bool> _fieldStreamControl = StreamController<bool>.broadcast();

  Stream get onAutoValidateChanged => _fieldStreamControl.stream;
  Stream get onVariableChanged => DataRefreshStream.instance.getFormFieldsStream.stream;

  _SingleFormState({int index = 0}) {
    _formKey = GlobalKey<FormState>(debugLabel: "$index");
    autovalidateMode = _autoValidate();

  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: onVariableChanged,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          return Form(
              key: _formKey,autovalidateMode: autovalidateMode,
           child :  formFieldList(formFieldList: widget.formFieldList));


        });
  }

  //Get form value
  Map<String,dynamic>?  getFormData(){
    setState(() {
      autovalidateMode = _autoValidate(checkValidOnSubmit :true);
    });
    if(_formKey.currentState!.validate()){
      return formSubmitData;
    }
    return null;
  }

  _autoValidate({bool checkValidOnSubmit = false}){
    /*if(checkValidOnChange){
      return AutovalidateMode.onUserInteraction;
    }
    else */
    if(checkValidOnSubmit) {
      if(fieldsForValidate.isNotEmpty){
        fieldsForValidate.map((e){
          if(formSubmitData.containsKey(e)){
            if(formSubmitData[e] == null || formSubmitData[e] == ''){
              setState(() {
                autoValidateFieldList[e] = true;
              });
              _fieldStreamControl.sink.add( autoValidateFieldList[e]);
            }
          }
        }).toList();
      }
      return AutovalidateMode.onUserInteraction;
    }
    return AutovalidateMode.disabled;

  }


  //Check Form field value
  bool validateFields(){
    setState(() {
      autovalidateMode = _autoValidate(checkValidOnSubmit :true);
    });
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //widget.finalSubmitCallBack?.call(formSubmitData);

      return true;
    }
    return false;
  }
  //Filter form field according type from json and return view
  Widget _getFormField({required Map<String,dynamic> data, Map<String,dynamic>? nextData}){

    String nextFieldKey = "";
    String currentElementKey = "";
    String currentElementType = "";
    bool isCurrentFieldRequired = false;

    if(data.containsKey("elementType") && data["elementType"].isNotEmpty)
    {
      currentElementType = data["elementType"].toString().toLowerCase();
      currentElementKey = data["elementConfig"]['name'];
    }
    if(data.containsKey("validation") && data["validation"] != null)
    {
      isCurrentFieldRequired = data["validation"]['required']??false;
    }

    if(nextData!=null && nextData.isNotEmpty && nextData.containsKey("elementType") && nextData["elementType"].isNotEmpty){
      String nextElementType = "";
      nextElementType = nextData["elementType"].toString().toLowerCase();
      if(nextElementType!=currentElementType){
        nextElementType = "";
      }
      else{
        nextFieldKey = nextData["elementConfig"]['name'];
      }
    }
    if(currentElementType.isNotEmpty){
      autoValidateFieldList[currentElementKey] = false;
      if (currentElementType != "input" && isCurrentFieldRequired) {
        fieldsForValidate.add(currentElementKey);
      }
      switch(currentElementType) {
        case "input":
          responseParser.setFieldFocusNode = currentElementKey;
          if (nextFieldKey.isNotEmpty) {
            responseParser.setFieldFocusNode = nextFieldKey;
          }
          //Open mobile field
          if (data.containsKey("elementConfig") &&
              data["elementConfig"].containsKey("type") &&
              data["elementConfig"]["type"].toString().toLowerCase() == "tel") {
            return TextFieldCountryPickerView(jsonData: data,
                onChangeValue: (String fieldKey, Map<String, String> value) {
                  formSubmitData[fieldKey] = value;
                },
                nextFieldKey: nextFieldKey);
          }
          return TextFieldView(
              jsonData: data, onChangeValue: (String fieldKey, String value) {
            formSubmitData[fieldKey] = value;
          }, nextFieldKey: nextFieldKey);

        case "select":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                return DropDown(jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue: (String fieldKey, List<String> value) {
                      formSubmitData[fieldKey] = value;
                    });
              });

        case "radio":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                return RadioButton(jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue: (String fieldKey, String value) {
                      formSubmitData[fieldKey] = value;
                    });
              });

        case "checkbox":
          return StreamBuilder(
              stream: onAutoValidateChanged,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                return CheckBoxWidget(jsonData: data,
                    autoValidate: snapshot.hasData,
                    onChangeValue: (String fieldKey, List<String> value){
                      formSubmitData[fieldKey] = value;
                    });  });

        case "button":
          {
             /* widget.nextPageButton?.call(FormButtonWidget(jsonData: data,
                  onChangeValue: (String fieldKey, List<String> value){
                    print(">>Submit 1 >> ${responseParser.getTotalFormsCount}");
                    if(responseParser.getTotalFormsCount> responseParser.getCurrentFormNumber){
                      if(validateFields()){
                        var data =  getFormData();
                        if(data!.isNotEmpty){
                          setState(() {
                            responseParser.setCurrentFormNumber = responseParser.getCurrentFormNumber+1;
                          });
                        }
                      }
                      widget.nextPageButtonClick?.call(responseParser.getCurrentFormNumber);
                      print(">>Submit 2 >> ${responseParser.getCurrentFormNumber}");
                    }
                    else {
                      if(validateFields()){
                        var data =  getFormData();
                        if(data!.isNotEmpty){
                          // widget.finalSubmitCallBack?.call(formSubmitData);
                        }
                      }
                    }
                    // formSubmitData[fieldKey] = value;
                  }));
              widget.priPageButton?.call( responseParser.getCurrentFormNumber>0?FormButtonWidget(jsonData: data,
                  onChangeValue: (String fieldKey, List<String> value){
                    print(">>Pre 1 >> ${responseParser.getCurrentFormNumber}");
                    if(responseParser.getCurrentFormNumber>0){
                      print(">>Pre 2 >> ${responseParser.getCurrentFormNumber}");
                      setState(() {
                        responseParser.setCurrentFormNumber = responseParser.getCurrentFormNumber - 1;
                      });
                      widget.nextPageButtonClick?.call(responseParser.getCurrentFormNumber);
                      print(">>Pre 3 >> ${responseParser.getCurrentFormNumber}");
                    }
                    else {

                    }
                    // formSubmitData[fieldKey] = value;
                  }):const SizedBox(height: 0,width: 0,));
*/
            return StreamBuilder(
                stream: onAutoValidateChanged,
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshot) {
                  return
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        responseParser.getCurrentFormNumber > 0 ?
                        FormButtonWidget(label:"Preview",jsonData: data,
                            onChangeValue: (String fieldKey,
                                List<String> value) {
                              print(">>Pre 1 >> ${responseParser
                                  .getCurrentFormNumber}");
                              if (responseParser.getCurrentFormNumber > 0) {
                                print(">>Pre 2 >> ${responseParser
                                    .getCurrentFormNumber}");
                                setState(() {
                                  responseParser.setCurrentFormNumber =
                                      responseParser.getCurrentFormNumber - 1;
                                });
                                widget.nextPageButtonClick?.call(
                                    responseParser.getCurrentFormNumber,formSubmitData);
                                print(">>Pre 3 >> ${responseParser
                                    .getCurrentFormNumber}");
                              }
                              else {

                              }
                              // formSubmitData[fieldKey] = value;
                            }) : const SizedBox(height: 0, width: 0,),
                        FormButtonWidget(jsonData: data,
                            onChangeValue: (String fieldKey,
                                List<String> value) {
                              print(">>Submit 1 >> ${responseParser
                                  .getTotalFormsCount}");
                              if (responseParser.getTotalFormsCount-1 >
                                  responseParser.getCurrentFormNumber) {
                                if (validateFields()) {
                                  var data = getFormData();
                                  if (data!.isNotEmpty) {
                                    setState(() {
                                      responseParser.setCurrentFormNumber =
                                          responseParser.getCurrentFormNumber +
                                              1;
                                    });
                                  }
                                }
                                widget.nextPageButtonClick?.call(
                                    responseParser.getCurrentFormNumber,formSubmitData);
                                print(">>Submit 2 >> ${responseParser
                                    .getCurrentFormNumber}");
                              }
                              else {
                                if (validateFields()) {
                                  var data = getFormData();
                                  if (data!.isNotEmpty) {
                                     widget.finalSubmitCallBack?.call(responseParser.getCurrentFormNumber,formSubmitData);
                                  }
                                }
                              }
                              // formSubmitData[fieldKey] = value;
                            })
                      ],);
                });
          }
      }
    }
    return Container();
  }

  Widget formFieldList({required List<dynamic> formFieldList}){
    int nextItemIndex = 1;
    responseParser.clearFieldFocusNode();
    return
      Column(children: formFieldList.map((element) {
      Map<String,dynamic> data = element;
      Map<String,dynamic> nextData = {};

      if(nextItemIndex<formFieldList.length){
        nextData = formFieldList[nextItemIndex];
        nextItemIndex = nextItemIndex+1;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getFormField(data: data,nextData:nextData),
          const SizedBox(height: 20,width: 10)
        ],
      );
    }).toList());
  }
}
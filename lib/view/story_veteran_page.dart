import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/config.dart';
import 'package:veterans/view/veteran_page/back_button.dart';

import '../main.dart';
import 'main_app_bar.dart';

class StoryVeteranPage extends StatefulWidget {
  @override
  _StoryVeteranPageState createState() => _StoryVeteranPageState();
}

class _StoryVeteranPageState extends State<StoryVeteranPage> {
  final _formKey = GlobalKey<FormState>();
  String _veteranInfo, _email, _phone;

  @override
  Widget build(BuildContext context) {
   return AppFrame(
      mainAppBar: MainAppBar(
        backButton: BackButtonAppbar(context: context),
        title: Text(
          'Расскажите о ветеране',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                onSaved: (veteranInfo) => _veteranInfo = veteranInfo,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                maxLines: 15,
                maxLength: 1000,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText:
                    'Перечислите данные о ветеране, которые вы готовы нам сообщить'),
              ),
              TextFormField(
                  validator: (email) => EmailValidator.validate(email)
                      ? null
                      : "Неверный адрес почты",
                  onSaved: (email) => _email = email,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: 'Ваша почта',
                    hintText: "e.g abc@gmail.com",
                  )),
              TextFormField(
                  validator: validateMobile,
                  onSaved: (phone) => _phone = phone,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  maxLength: 40,
                  decoration: InputDecoration(
                      labelText: 'Ваш телефон', hintText: '+79855310868'))
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(
            const IconData(MyApp.codePoint, fontFamily: 'send'),
            color: Colors.white,
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              await _emailLaunchUri(
                  path: '${Config.email}',
                  subject: '${Config.subject}',
                  body: 'Телефон: ${_phone} <br>'
                      'Почта: ${_email} <br>'
                      'Инфо о ветеране: <br>'
                      ' ${_veteranInfo}');
              toastMessage("Отлично! Скоро мы сяжемся с вами!", context);
            }
          },
        ),
      ),
    );
  }

  String validateMobile(String value) {
    String pattern =
        r'(^(\+7|7|8)?[\s\-]?\(?[489][0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Пожалуйста введите номер телефона';
    } else if (!regExp.hasMatch(value)) {
      return 'Пожалуйста введите валидный номер телефона';
    }
    return null;
  }

  void toastMessage(String message, BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
    ));
  }

  _emailLaunchUri({String path, String subject, String body}) async {
    final MailOptions mailOptions = MailOptions(
      body: body,
      subject: subject,
      recipients: ['$path'], //кому
      isHTML: true,
//      bccRecipients: ['other@example.com'], // скрытая
//      ccRecipients: ['third@example.com'], // копия
    );
    await FlutterMailer.send(mailOptions);
  }
}

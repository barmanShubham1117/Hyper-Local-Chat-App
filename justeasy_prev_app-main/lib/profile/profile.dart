import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:justeasy/widgets/form.dart';
import 'package:path/path.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';


final ValueNotifier<String> imageNotifier = ValueNotifier(AssetController.dummyProfile);

class Profile extends StatelessWidget {
   Profile({ Key? key }) : super(key: key);
final TextEditingController nameController = TextEditingController();
final TextEditingController nickController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController unameController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController statusController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController socialNameController = TextEditingController();
final TextEditingController socialLinkController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool afterLogin = false;
bool atFirst = true;
bool network = false;
bool back = true;

final ValueNotifier<int> socialImageNotifier = ValueNotifier(0);
final ValueNotifier<bool> shareNotifier = ValueNotifier(false);
final ValueNotifier<int> socialCount = ValueNotifier(3);
List<ValueNotifier<bool>> socialNotifiers = [];
List<Social> socials = [];

 void pickDate(BuildContext context) {
    DatePicker.showDatePicker(context, onConfirm: (v) {
      dobController.text = "${v.day}/${v.month}/${v.year}";
    });
  }

final ImagePicker _picker = ImagePicker();

void doNext(context){
      var args = {
       'name' : nameController.text, 
       'nick_name' : nickController.text, 
       'user_name' : unameController.text,
       'date_of_birth':dobController.text,
       'status':statusController.text,
       'location':locationController.text,
       'authenticated':afterLogin.toString(),
      //  'image':imageNotifier.value != AssetController.dummyProfile ? imageNotifier.value : '',
      };
      print("called");
      ProfileController.updateProfile(context, _formKey, args, (imageNotifier.value != AssetController.dummyProfile ? imageNotifier.value : ''));
    }
void logout(BuildContext context){
  AuthController.logout(context);
}
  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant = Constants(context);
    User user = DataManager.user;
    if(atFirst){
      nameController.text = user.name;
      nickController.text = user.nickName;
      emailController.text = user.email;
      unameController.text = user.userName;
      dobController.text = user.dateOfBirth;
      statusController.text = user.status;
      locationController.text = user.location;
      imageNotifier.value = (user.image == '' ? AssetController.dummyProfile : "${AppConfig.mainUrl}/${user.image}");
      Console.log("loggin notifier");
      Console.log(imageNotifier.value);
      afterLogin = constant.passedData['afterLogin'];
      network = imageNotifier.value != AssetController.dummyProfile;
      atFirst = false;
    }
    if(afterLogin){
      // ProfileController.captureImage(imageNotifier,network);
      back = false;
      afterLogin = false;
    }
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor:AppColors.primaryBG,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                width: constant.screenWidth,
                // height: constant.screenHeight * 0.06,
                // color: AppColors.primaryText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    Buttons.backButton(context,visible:back),
                   Padding(
                     padding: EdgeInsets.only(top:2.h),
                     child:  Text(
                      'Set up your Profile',
                      style: GoogleFonts.epilogue(
                      textStyle:  TextStyle(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.normal, 
                        fontSize: 20.sp)
                       ),
                    ),
                   ),
                    IconButton(onPressed: (){
                      logout(context);
                    }, icon: const Icon(Icons.logout))
                  ],
                ),
              ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 90.h),
                      padding: EdgeInsets.only(top: 100.h),
                      // height: constant.screenHeight * 0.71,
                      width: constant.screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.formBG,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          topRight: Radius.circular(20.w),
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                user.name,
                                style:GoogleFonts.epilogue(
                                  textStyle: TextStyle(
                                   color: AppColors.secondaryText,
                                   fontWeight: FontWeight.bold, 
                                   fontSize: 18.sp)
                                  ),
                              )
                            ),
                            SizedBox(
                              width: constant.screenWidth,
                              height: constant.screenHeight * 0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:EdgeInsets.only(left: constant.screenWidth * 0.03),
                                    width: constant.screenWidth * 0.28,
                                    child: Text(
                                      user.user_id,
                                      style:AppTextStyle.profileID(constant),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      // @To-Do:add copy function
                                      Clipboard.setData(ClipboardData(text:user.user_id));
                                    },
                                    icon: Icon(Icons.copy,color: AppColors.secondaryText,size: constant.screenHeight * 0.025,),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: constant.screenWidth,
                            //   height: constant.screenHeight * 0.01,
                            // ),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.only(left:constant.screenWidth * 0.08, right:constant.screenWidth * 0.08),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTitle("Enter your details", constant),
                                    FormControl.inputPlain(
                                      controller: nameController,
                                      context: context, 
                                      placeholder: 'Name', 
                                      constant: constant, 
                                      type: TextInputType.text, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'Name is mandatory' : 'Please enter a valid name(min:3).' ;
                                        }
                                      },
                                    ),
                                    FormControl.inputPlain(
                                      controller: nickController,
                                      context: context, 
                                      placeholder: 'Nick name', 
                                      constant: constant, 
                                      type: TextInputType.text, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'Nick Name is mandatory' : 'Please enter a valid nick name(min:3).' ;
                                        }
                                      },
                                    ),
                                    FormControl.inputPlain(
                                      controller: unameController,
                                      context: context, 
                                      placeholder: 'User name', 
                                      constant: constant, 
                                      type: TextInputType.text, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'User Name is mandatory' : 'Please enter a valid user name(min:3).' ;
                                        }
                                      },
                                    ),
                                    InkWell(
                                      onTap:(){
                                        pickDate(context);
                                      },
                                      child: FormControl.inputPlain(
                                        controller: dobController,
                                        context: context, 
                                        placeholder: 'Date of birth', 
                                        constant: constant, 
                                        enabled: false,
                                        type: TextInputType.datetime, 
                                        validator: (value){
                                          if(FormControl.emptyValidator(value)){
                                            return null;
                                          }else{
                                            return !FormControl.emptyValidator(value) ? 'User Name is mandatory' : 'Please enter a valid user name(min:3).' ;
                                          }
                                        },
                                      ),
                                    ),
                                    getTitle("Enter your email", constant),
                                    FormControl.inputPlain(
                                      controller: emailController,
                                      context: context, 
                                      placeholder: 'Email', 
                                      constant: constant, 
                                      enabled:false,
                                      type: TextInputType.emailAddress, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value) && FormControl.emailValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'Email is mandatory' : 'Please enter a valid email' ;
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: constant.screenWidth * 0.05),
                                      child: Text(
                                        'Add your email address to receive notifications about your activity.',
                                        style:constant.textTheme.bodyText2,
                                      ),
                                    ),
                                    getTitle("Enter your status", constant, clearBottom:true),
                                    Container(
                                      margin: EdgeInsets.only(bottom: constant.screenHeight * 0.006),
                                      child: Text(
                                        '(Status will expire every 2 hours)',
                                        style:constant.textTheme.bodyText2,
                                      ),
                                    ),
                                    FormControl.inputPlain(
                                      controller: statusController,
                                      context: context, 
                                      placeholder: 'looking for...', 
                                      constant: constant, 
                                      type: TextInputType.text, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'Status is mandatory' : 'Please enter a valid status' ;
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: constant.screenWidth * 0.05,bottom: constant.screenHeight * 0.02,right:constant.screenHeight * 0.02),
                                      child: Text(
                                        'Hint: Business/ Lunch/ Coffee/ In-Person Convo/ Drinks or Indoor / Outdoor Games etc',
                                        style:constant.textTheme.bodyText2,
                                      ),
                                    ),
                                     getTitle("Your location", constant),
                                    // Container(
                                    //   margin: EdgeInsets.only(bottom: constant.screenHeight * 0.006, cle),
                                    //   child: Text(
                                    //     '(location will expire every 2 hours)',
                                    //     style:constant.textTheme.bodyText2,
                                    //   ),
                                    // ),
                                    FormControl.inputPlain(
                                      controller: locationController,
                                      context: context, 
                                      placeholder: 'I am @', 
                                      constant: constant, 
                                      type: TextInputType.text, 
                                      validator: (value){
                                        if(FormControl.emptyValidator(value)){
                                          return null;
                                        }else{
                                          return !FormControl.emptyValidator(value) ? 'Location is mandatory' : 'Please enter a valid location' ;
                                        }
                                      },
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top:20),
                                      // child: Text(
                                      //   'Hint: Business/ Lunch/ Coffee/ In-Person Convo/ Drinks or Indoor / Outdoor Games etc',
                                      //   style:constant.textTheme.bodyText2,
                                      // ),
                                    ),
                                    getTitle("Add links to your social media profiles.", constant, clearBottom:true),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: constant.screenHeight * 0.02,right:constant.screenHeight * 0.02),
                                      child: Text(
                                        'These Links will not be shown on your profile. You can share them manually',
                                        style:constant.textTheme.bodyText2,
                                      ),
                                    ), 

                                    ValueListenableBuilder(
                                        valueListenable: socialCount,
                                        builder: (context, value, child){
                                          return FutureBuilder(
                                            future: ProfileController.getSocials(context),
                                            builder: (context, snapshot){
                                              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                                socials = snapshot.data as List<Social>;
                                                socialCount.value = socials.length;
                                              }
                                              return snapshot.connectionState == ConnectionState.done
                                              ? ListBody(
                                                children: List.generate(socials.length,(index){
                                                  socialNotifiers.add(ValueNotifier<bool>(false));
                                                  return socials[index].render(constant,socialNotifiers[index]);
                                                }),
                                              )
                                              : ListBody(
                                                children:[
                                                  // getSocial('Phone number', AssetController.customIcon, constant, skew:-45 * math.pi /180),
                                                  // getSocial('Whatsapp', AssetController.whatsappIcon, constant, shared:true),
                                                  // getSocial('Linkedin', AssetController.linkedinIcon, constant),
                                                  // getSocial('Linkedin', AssetController.linkedinIcon, constant),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        // child:Column(
                                        //   children: [
                                        //     getSocial('Phone number', AssetController.customIcon, constant, skew:-45 * math.pi /180),
                                        //     getSocial('Whatsapp', AssetController.whatsappIcon, constant, shared:true),
                                        //     getSocial('Linkedin', AssetController.linkedinIcon, constant),
                                        //   ],
                                        // ),
                                      ),

                                    InkWell(
                                      onTap: (){
                                        var dialog ;
                                        showDialog(context: context, builder: (context){
                                          dialog = context;
                                          Constants dialogcons = Constants(context);
                                          return AlertDialog(
                                            title:Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children:[
                                                Text(
                                                  'Add Social links to your profile.',
                                                  style: constant.textTheme.bodyText2,
                                                ),
                                                InkWell(onTap: (){
                                                  Navigator.pop(context);
                                                }, child: Icon(Icons.close,size:15.w))
                                              ],
                                            ),
                                            actions: [
                                              InkWell(
                                                onTap: ()async{
                                                  await ProfileController.addSocial(context, socialNameController.text, socialLinkController.text, socialImageNotifier.value, socialCount);
                                                  // Navigator.pop(dialog);
                                                },
                                                child: Container(
                                                  padding:EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.buttonColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Center(
                                                    child:Text(
                                                      'Save',
                                                      style:constant.textTheme.button,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            content : Container(
                                              width: constant.screenWidth,
                                              height: constant.screenHeight * 0.1,
                                              color:AppColors.secondaryBG,
                                              child:Column(
                                                children:[
                                                  Row(
                                                children: [
                                                  Container(
                                                    width: constant.screenWidth * 0.15,
                                                    height: constant.screenHeight * 0.05,
                                                    child: ValueListenableBuilder(
                                                      valueListenable: socialImageNotifier,
                                                      builder:(context, value, child){
                                                        return DropdownButton(
                                                          value:socialImageNotifier.value,
                                                          onChanged:(v){
                                                            socialImageNotifier.value = int.parse(v.toString());
                                                          },
                                                          items: List.generate(AssetController.socialList.length, (index) => DropdownMenuItem(
                                                              value: index,
                                                              child: Image.asset(
                                                                AssetController.socialList[index],
                                                                height:constant.screenHeight * 0.04,
                                                              ),
                                                            ),)
                                                        );
                                                      } ,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: constant.screenWidth * 0.5,
                                                    height: constant.screenHeight * 0.05,
                                                    child:FormControl.inputPlain(
                                                      context: context, 
                                                      placeholder: 'Enter name', 
                                                      constant: constant, 
                                                      validator: FormControl.emptyValidator, 
                                                      controller: socialNameController),
                                                  ),
                                                      
                                                ]),
                                                Container(
                                                width: constant.screenWidth * 0.5,
                                                height: constant.screenHeight * 0.05,
                                                margin: EdgeInsets.only(left: constant.screenWidth * 0.13),
                                                child:FormControl.inputPlain(
                                                  context: context, 
                                                  placeholder: 'Enter social link', 
                                                  constant: constant, 
                                                  validator: FormControl.emptyValidator, 
                                                  controller: socialLinkController),
                                                ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        width:constant.screenWidth,
                                        height: constant.screenHeight * 0.06,
                                        margin:EdgeInsets.only(bottom: constant.screenHeight * 0.01,),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryBG,
                                          borderRadius:BorderRadius.circular(constant.screenWidth * 0.015),
                                        ),
                                        child:Center(
                                          child: Text(
                                            'ADD MORE +',
                                            style: GoogleFonts.roboto(
                                              fontSize:16.sp,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF555555)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    Padding(
                                      padding: EdgeInsets.only(left: constant.screenWidth * 0.1,bottom: constant.screenHeight * 0.02,right:constant.screenHeight * 0.02),
                                      // child: Text(
                                      //   'Hint: Business/ Lunch/ Coffee/ In-Person Convo/ Drinks or Indoor / Outdoor Games etc',
                                      //   style:constant.textTheme.bodyText2,
                                      // ),
                                    ),
                                    Center(
                                      child:InkWell(
                                          onTap: (){
                                            doNext(context);
                                          },
                                          child: Container(
                                            width: constant.screenHeight * 0.3,
                                            padding: EdgeInsets.only(
                                              // left: constant.screenWidth * 0.1, 
                                              // right: constant.screenWidth * 0.1,
                                              top: constant.screenWidth * 0.035,
                                              bottom: constant.screenWidth * 0.035,
                                              ),
                                            decoration: BoxDecoration(
                                              color: AppColors.buttonColor ,
                                              borderRadius: BorderRadius.circular(constant.screenWidth * 0.035),
                                            ),
                                            child: Text(
                                              'Save Profile',

                                              style: constant.textTheme.button,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ),
                                     
                                  ],
                                ),
                              ),
                            ),
                             SizedBox(
                              height: constant.screenHeight * 0.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: constant.screenWidth * 0.5,
                            height: constant.screenWidth * 0.5,
                            decoration:const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x70000000),
                                  spreadRadius: 2,
                                  offset: Offset(5,4),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(constant.screenHeight),
                              child: ValueListenableBuilder(
                                valueListenable: imageNotifier,
                                 builder: (context,child,value){
                                   return AssetController.avatarImage(imageNotifier, network);
                                 }
                                ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 5,
                            child: Container(
                              width:40.w,
                              height: 40.w,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryBG,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x90000000),
                                    spreadRadius: 1,
                                    offset: Offset(0,2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child:IconButton(onPressed: (){
                                network = false;
                                ProfileController.captureImage(imageNotifier,network);
                              }, icon: const Icon(Icons.edit)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        
          ),
        ),
    );
  }

  Widget getTitle(String title, Constants constant,{bool clearBottom = false}){
    return Container(
      margin: EdgeInsets.only(bottom: constant.screenHeight * ( clearBottom ? 0.005 : 0.02), top:constant.screenHeight * 0.02),
      child:Text(
        title,
        style:AppTextStyle.profileSubHeading(context),
      ),
    );
  }
}
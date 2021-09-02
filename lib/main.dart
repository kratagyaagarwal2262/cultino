import 'package:camera/camera.dart';
import 'package:cultino/api_request.dart';
import 'package:flutter/material.dart';
import 'package:cultino/Other_Mandi.dart';
import 'package:email_validator/email_validator.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MaterialApp(
    title: 'Flutter Demo',
    routes:{
      'something':(context) => Mandi(),
    },
    theme: ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Colors.green[900],
      accentColor: Colors.green[400],
      brightness: Brightness.light,
      textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic,color: Colors.green[900])
      ),
    ),
    home: HomePage(camera: firstCamera,),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;
  @override
  _HomePageState createState() => _HomePageState();
}

// This enum Singing Character value are there to save or store teh value of
// Male and female which  the user is going to select using the Radio Widget
enum SingingCharacter { Male, Female }

class _HomePageState extends State<HomePage> {
  String _character = "Male";
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  var name;
  var email;
  var _counter = 0 ;
  var test;
  final _controller  = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Request instance = Request();
  @override
  void initState() {

    cameraController =CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = cameraController.initialize();
    super.initState();
  }
  @override
  void dispose() {

    _controller.dispose();
    cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("Counter = $_counter");
    print("Test = $test");
    return Scaffold(
      appBar: AppBar(
        title: Text("CULTINO AGROTECH PVT LTD."),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.fromLTRB(30.0,0.0, 30.0,0.0),
                child: TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                  onChanged: (value){
                    name = value;
                  },
                ),
              ),
              SizedBox(height: 30.0,),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30.0,0.0, 30.0,0.0),
                  child: TextFormField(
                    controller: _controller,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        labelText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    ),
                    onChanged: (value){
                      email = value;
                    },
                    validator: (value) => value!= null && !EmailValidator.validate(value)?"Invalid Email": null,
                    onSaved: (value) => email = value,
                  ),
                ),
              ),
              ListTile(
                title: const Text("Male",style: TextStyle(fontSize: 28.0, fontStyle: FontStyle.italic,color: Colors.lightGreen)),
                focusColor: Theme.of(context).accentColor,
                leading: Radio<String>(
                  groupValue: _character,
                  value:"Male",
                  onChanged: (value){
                    setState(() {
                      _character = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Female",style:TextStyle(fontSize: 28.0, fontStyle: FontStyle.italic,color: Colors.lightGreen)),
                focusColor: Theme.of(context).accentColor,
                leading: Radio<String>(
                  groupValue: _character,
                  value: "Female",
                  onChanged: (value ){
                    setState(() {
                      _character = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Submit Button
                  Container(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      hoverColor: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState!.validate())
                       {
                         setState(() {
                           _counter++;
                           test =  1 ;
                           information();
                         });
                       }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      padding: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                  ),

                  // Fetch Button
                  Container(
                    child: MaterialButton(
                      hoverColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).accentColor,
                      onPressed: (){
                        instance.api();
                        Navigator.of(context).pushNamed('something');
                      },
                      child: Text("Fetch",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      padding: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                  ),
                  // Button to take a photo
                  Container(
                    child: MaterialButton(
                      hoverColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        photo();
                       /* await _initializeControllerFuture;
                        final image = await cameraController.takePicture();*/
                        },
                      child: Text("Take a Photo",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      padding: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              information(),
            ],
          ),
      ),
    );
  }
  Widget information(){
    if(_counter!=0)
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Name = $name",style: Theme.of(context).textTheme.bodyText1,),
          Text("Email = $email",style: Theme.of(context).textTheme.bodyText1,),
          Text("Gender = $_character",style: Theme.of(context).textTheme.bodyText1,),
        ],
      ),
    );
    else
      return Container(
        // Empty container so there won't be any value or any widget associated
        // SO this widget won't show anything until Submit is Pressed
      );
  }
 Future<void> photo(){
   return showDialog<void>(
     context: context,
     barrierDismissible: false, // user must tap button!
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('AlertDialog Title'),
         content: FutureBuilder<void>(
           future: _initializeControllerFuture,
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.done) {
               // If the Future is complete, display the preview.
               return CameraPreview(cameraController);
             } else {
               // Otherwise, display a loading indicator.
               return const Center(child: CircularProgressIndicator());
             }
           },
         ),
         actions: <Widget>[
           TextButton(
             child: const Text('Take Photo'),
             onPressed: ()async {
               await _initializeControllerFuture;
               final image = await cameraController.takePicture();
               print(image);
               Navigator.of(context).pop();
             },
           ),
         ],
       );
     },
   );
 }
}



import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Services/tempValues.dart';
import 'package:weatherapp/Services/weatherServices.dart';
import 'package:weatherapp/modelClass/weatherModel.dart';
import '../../Services/flutterToast.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 final _weatherService=WeatherService("3b2e83fb45d8c2d43d114fc4e47789ff");
 WeatherClass? weatherClass;
 bool loading=false;
 TextEditingController locationController=TextEditingController();

 String getWeatherAnimation(String mainCondition){
   switch(mainCondition.toLowerCase()){
     case 'clouds':
     case 'mist':
     case 'smoke':
     case 'haze':
     case 'dust':
     case 'fog':
       return 'assets/clouds.json';
     case 'rain':
     case 'drizzle':
     case 'shower rain':
       return 'assets/rain.json';
     case 'thunderstorm':
       return 'assets/thunder.json';
     case 'clear':
       return 'assets/sunny.json';
     default:
       return 'assets/sunny.json';
   }
 }
 _fetchWeather()async{
   setState(() {
     loading=false;
   });
   String cityName;
   if(locationController.text.isEmpty) {
      cityName=await _weatherService.getCurrentCity();
   }else{
      cityName=locationController.text.trim();
   }
   try{
     final weather=await _weatherService.getWeather(cityName);
     setState(() {
       weatherClass=weather;
       loading=true;
     });
   }
   catch(e){
     ToastPrintData.flutterToast(e.toString());
   }
 }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body:TempValues.showWeather?Center(
        child: !loading?const CircularProgressIndicator(color: Colors.white,):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,right: 15,),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              setState(() {
                                locationController.clear();
                                TempValues.showWeather=false;
                              });
                            },child: Container(padding:const EdgeInsets.only(left: 15,top: 8.0,bottom: 8.0,right: 8.0),child: const Icon(Icons.arrow_back,size: 20,color: Colors.blue,weight: 5.0,))),
                        const Text('Weather app',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey,),
                  SizedBox(
                    height: 200,
                      child: Lottie.asset(getWeatherAnimation(weatherClass?.weather[0].main??""))),
                   Center(child: Text('${weatherClass?.main?.tempMin?.round()}℃',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 45))),
                  const SizedBox(height: 10,),
                   Center(child: Text('${weatherClass?.weather[0].main}')),
                  const SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined,size: 18),
                      Text(' ${weatherClass?.name??""}'),
                    ],
                  ),
                 const SizedBox(height: 10,),
                  const Divider(color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Container(child:  Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thermostat),
                            const SizedBox(width: 5,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${weatherClass?.main?.feelsLike?.round()??""}℃',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                                const Text('Feels Like',style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        )),)),
                        const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            indent: 0.0,
                            endIndent: 0.0,
                            color: Colors.grey,
                            width: 10,
                            thickness: 1,
                          ),
                        ),
                        Expanded(child: Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop),
                            const SizedBox(width: 5,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${weatherClass?.main?.humidity?.round()??""}%',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                                const Text('Humidity',style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
                    child: Text('Weather app',style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
                  ),
                  const Divider(color: Colors.grey,),
                  Padding(
                    padding:  const EdgeInsets.only(top: 10,left: 15,right: 15),
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        autofocus: false,
                          textAlign: TextAlign.center,
                        controller: locationController,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value){
                          if(value.isNotEmpty)
                         {
                           _fetchWeather();
                           setState(() {
                             TempValues.showWeather=true;
                           });
                         }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter city name',
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.only(top: 10,left: 5),
                          border:OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,left: 15,right: 15),
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey,height: 1)),
                        const Text(' OR ',style: TextStyle(fontSize: 10,color: Colors.grey)),
                        Expanded(child: Container(color: Colors.grey,height: 1)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 20),
                    child: InkWell(
                      onTap: (){
                        locationController.clear();
                        _fetchWeather();
                        setState(() {
                          TempValues.showWeather=true;
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue
                        ),
                        child: const Center(child: Text('Get Device Location',style: TextStyle(color: Colors.white,fontSize: 13),)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

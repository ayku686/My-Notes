// This page we have created so that we can understand bloc and state management better.
// This page ahs nothing to do with our notes app and we are not going to use this anywhere
//So in this page we are going to create a stateful widget which has a increment and a decrement
//button which on pressed increments or decrements the previous value by the new value.
//Now a bloc has two very important things,
// 1.Event
// 2.State
//An event goes into a bloc and a state comes out of it
// So now we will make a counter-state clas which takes care of the state of the class
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocDemo extends StatefulWidget {
  const BlocDemo({Key? key}) : super(key: key);

  @override
  State<BlocDemo> createState() => _BlocDemoState();
}

class _BlocDemoState extends State<BlocDemo> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Understanding Bloc"),
            backgroundColor: Colors.blueGrey,
          ),
          //A BLocConsumer combines Bloc Listener and a BLocBuilder to that both can work simultaneously.
          //Here we need BlocConsumer so that on the press of every plus and minus button we want to clear the text field(which is a side effect which requires a listener (BlocListener))
          //and also we need to build our UI simultaneously for which we a need a BlocBuilder
          body: BlocConsumer<CounterBloc,CounterState>(
              listener: (context, state){
                _controller.clear();//clears the invalid input message on listening a valid input
              },
              builder: (context, state){
                final invalidValue = (state is CounterStateInvalid) ? state.invalidValue : '';
                return Column(
                  children: [
                    Text('Current value is ${state.value}'),
                    //Here we have made this Visibility widget which will appear only if there is an invalid input
                    Visibility(
                        visible: state is CounterStateInvalid,
                        child: Text('Invalid input: $invalidValue'),
                    ),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a number'
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              context
                                  .read<CounterBloc>()
                                  .add(IncrementEvent(_controller.text));
                            },
                            child: const Text('+',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28
                              ))
                        ),
                        ElevatedButton(
                            onPressed: (){
                              context
                                  .read<CounterBloc>()
                                  .add(DecrementEvent(_controller.text));
                            },
                            child: const Text('-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28
                                ))
                        )
                      ],
                    )
                  ],
                );
              },
          ),
        )
    );
  }
}

//state of the block
@immutable
abstract class CounterState{
  final int value;
  const CounterState(this.value);
}//Now our page can have two states: A valid state and an invalid state
//Now since our page consists of a text box which receives an integer. Now if a user tries to
// enter something other than an integer(eg String), our page should not read that and show that the state is not valid
//Now if our state is valid the CounterStateValid constructor will call the constructor
// of the main class with this integer value
class CounterStateValid extends CounterState{
  const CounterStateValid(int value) : super(value);
}
//Now if our state is invalid the string passed to it the constructor of this class must call
// the constructor of the main class with previous value(value of previous valid state)
class CounterStateInvalid extends CounterState{
  final String invalidValue;
  const CounterStateInvalid({
    required int previousValue,
    required this.invalidValue}) : super(previousValue);
}


//Event
@immutable
abstract class CounterEvent{
  final String value;
  const CounterEvent(this.value);
}
//Now we create two events one for increment and other for decrement
//Super.value calls the constructor of the super class with String value as an argument
class IncrementEvent extends CounterEvent{
  const IncrementEvent(String value): super(value);
}

class DecrementEvent extends CounterEvent{
  const DecrementEvent(String value): super(value);
}
//Now comes our main part The counter bloc
//Here we can ee that in our bloc class it takes event and current state as input and emits a new state as output
class CounterBloc extends Bloc<CounterEvent,CounterState>{
  CounterBloc() : super(const CounterStateValid(0)){
    // If we pass CounterBloc() : super(CounterStateInvalid( previousValue: 0, invalidValue: 'hi')) it shows the invalid text also on the screen
    on<IncrementEvent>((event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null){
          emit(CounterStateInvalid(
              previousValue: state.value,//The previous value is always stored inside state.value where state is our current state
              invalidValue: event.value));
        }
        else{
          emit(CounterStateValid(state.value + integer));//Here since integer has a valid value it should emit a new state
        }

    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            previousValue: state.value,
            //The previous value is always stored inside state.value where state is our current state
            invalidValue: event.value));
      }
      else {
        emit(CounterStateValid(state.value -
            integer)); //Here since integer has a valid value it should emit a new state
      }
    });
  }
}

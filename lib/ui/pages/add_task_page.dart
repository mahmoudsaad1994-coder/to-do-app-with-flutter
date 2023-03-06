import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputField(
                title: 'Title',
                widget: _buildTextField(
                  context,
                  controller: _titleController,
                  hint: 'Write title here',
                ),
              ),
              InputField(
                title: 'Note',
                widget: _buildTextField(
                  context,
                  controller: _noteController,
                  hint: 'what\'s your reminder !!',
                ),
              ),
              InputField(
                title: 'Date',
                widget: _buildTextField(
                  context,
                  hint: DateFormat.yMd().format(_selectedDate),
                  iconWidget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () => _getDateFromUser(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      widget: _buildTextField(
                        context,
                        hint: _startTime,
                        iconWidget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: const Icon(
                            Icons.access_alarms_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => _getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      widget: _buildTextField(
                        context,
                        hint: _endTime,
                        iconWidget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: const Icon(
                            Icons.access_alarms_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => _getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                widget: DropdownButtonFormField<int>(
                  value: _selectedRemind,
                  items: remindList
                      .map((label) => DropdownMenuItem(
                            child: Center(child: Text(' $label minutes early')),
                            value: label,
                          ))
                      .toList(),
                  hint: const Text('5 minutes early'),
                  onChanged: (value) {
                    setState(() {
                      _selectedRemind = value!;
                      print('$_selectedRemind');
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                  iconSize: 30,
                ),
              ),
              InputField(
                title: 'Repeat',
                widget: DropdownButtonFormField(
                  hint: Text(_selectedRepeat),
                  items: repeatList
                      .map((label) => DropdownMenuItem<String>(
                            child: Center(child: Text(' $label ')),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                      print(_selectedRepeat);
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                  iconSize: 30,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                    lable: 'Create Task',
                    onTap: () {
                      _validateDate();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTextField(BuildContext context,
      {TextEditingController? controller,
      required String hint,
      Widget? iconWidget,
      Function? onTap}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            autofocus: false,
            readOnly: iconWidget != null ? true : false,
            style: subTitleStyle,
            cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: subTitleStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.backgroundColor,
                  width: 0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.backgroundColor,
                  width: 0,
                ),
              ),
            ),
            onTap: iconWidget != null ? () => onTap!() : () {},
          ),
        ),
        iconWidget ?? Container(),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('New Reminder', style: headingStyle),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/task.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All Fields are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.white : darkHeaderClr,
          colorText: Get.isDarkMode ? pinkClr : Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('######## SOMETHING BAD HAPPENED ########');
    }
  }

  _addTasksToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      print('$value');
    } catch (e) {
      print('Error');
    }
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null)
      setState(() => _selectedDate = _pickedDate);
    else
      print('It\'s null or something wrong');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime)
      setState(() => _startTime = _formattedTime);
    else if (!isStartTime)
      setState(() => _endTime = _formattedTime);
    else
      print('Time canceld or something is wrong');
  }
}

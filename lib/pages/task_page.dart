import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:calendar_app/widgets/dialogs/confirm_discard_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<FocusNode> _keyboardNodes = [];
  List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TaskProvider>();

      setState(() {
        _taskList.clear();
        _controllers.clear();
        _focusNodes.clear();
        _keyboardNodes.clear();

        _taskList = provider.taskList.map((t) => t.copy()).toList();

        for (final task in _taskList) {
          _controllers.add(TextEditingController(text: task.title));
          _focusNodes.add(FocusNode());
          _keyboardNodes.add(FocusNode());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool shouldPop = await _showConfirmDiscardDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              _taskList = provider.taskList;

              final bool shouldPop = await _showConfirmDiscardDialog() ?? false;

              if (context.mounted && shouldPop) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text('Edit Tasks'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<TaskProvider>().editAllTasks(_taskList);
                Navigator.pop(context);
              },
              icon: Icon(Icons.check_rounded),
            ),
            SizedBox(width: 12),
          ],
        ),
        body: _taskList.isEmpty
          ? GestureDetector(
            onTap: () {
              if (_taskList.isEmpty) {
                setState(() => _addTask(-1));
                if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
              }
            },
            child: Center(child: Text('Tap to add a task')),
          )
          : ListView.builder(
            itemCount: _taskList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _taskList[index].isComplete = !_taskList[index].isComplete;
                        });
                      },
                      icon: Icon(
                        _taskList[index].isComplete
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_rounded,
                        color: _taskList[index].isComplete
                          ? Colors.grey
                          : Colors.black,
                      ),
                    ),
                    Expanded(
                      child: KeyboardListener(
                        focusNode: _keyboardNodes[index],
                        onKeyEvent: (KeyEvent event) {
                          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                            if (_controllers[index].text.isEmpty) {
                              if (index > 0) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _focusNodes[index - 1].requestFocus();
                                  Future.delayed(Duration.zero, () {
                                    _controllers[index - 1].selection = TextSelection.collapsed(
                                      offset: _controllers[index - 1].text.length,
                                    );
                                  });
                                });
                              }
                              setState(() {
                                _controllers.removeAt(index);
                                _focusNodes.removeAt(index);
                                _keyboardNodes.removeAt(index);
                                _taskList.removeAt(index);
                              });
                            }
                          }
                        },
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          onChanged: (value) {
                            _taskList[index].title = value;
                          },
                          onSubmitted: (value) {
                            _taskList[index].title = value;
                            if (value.isEmpty || value == '') {
                              provider.removeTaskAt(index);
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                _addTask(index);
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (index >= 0 && index < _focusNodes.length && index < _controllers.length) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                              });
                            }
                          },
                          style: TextStyle(
                            color: _taskList[index].isComplete
                              ? Colors.grey
                              : Colors.black,
                            decoration: _taskList[index].isComplete
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                            decorationColor: Colors.grey,
                            decorationThickness: 1.8
                          ),
                          decoration: InputDecoration(border: UnderlineInputBorder(borderSide: BorderSide.none)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }

  void _addTask(int index) {
    _taskList.insert(index + 1, Task(title: '', day: DateTime.now()));
    _controllers.insert(index + 1, TextEditingController());
    _focusNodes.insert(index + 1, FocusNode());
    _keyboardNodes.insert(index + 1, FocusNode());
  }

  Future<bool?> _showConfirmDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ConfirmDiscardDialog()
    );
  }
}
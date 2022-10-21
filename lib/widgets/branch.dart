import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing/providers/notifier_provider.dart';
import 'package:testing/models/task.dart';
////////////////////////////////////////////////////////////////////////////////
class Branch extends StatefulWidget {
  final MaterialColor theme;
  const Branch({super.key, required this.theme});

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var taskNotifier = NotifierProvider.of(context).taskNotifier;

    onPressed() {
      showDialog(
        context: context,
        builder: (context) {
          final textController = TextEditingController();
          return AlertDialog(
            title: const Text('Создать задачу'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Введите название задачи'),
                maxLength: 40,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                validator: _validator,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              _createCancelButton(context),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      taskNotifier.addTask(textController.text);
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text('Ок'),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: _createAppBar(),
      body: _createList(),
      backgroundColor: widget.theme[100],

      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createList() {
    var nc = NotifierProvider.of(context);
    var taskNotifier = nc.taskNotifier;
    var appBarNotifier = nc.appBarNotifier;
    var list = taskNotifier.tasks;

    List<Task> viewedList = [];
    List<int> origIdx = [];
    for (int i = 0; i != list.length; ++i) {
      if (!(appBarNotifier.isUnchecked && list[i].isChecked || appBarNotifier.isOnlyFavorite && !list[i].isFav)) {
        viewedList.add(list[i]);
        origIdx.add(i);
      }
    }

    if (viewedList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset('lib/images/todolist_background.png', scale: 2.5),
                Image.asset('lib/images/todolist.png', scale: 2.5),
              ],
            ),
          const Text(
            'На данный\nмомент задачи\nотсутсвуют',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )]));
    }
    else {
      return ListView.builder(
      itemCount: viewedList.length,
      itemBuilder: (ctx, idx) {
        var task = viewedList[idx];

        var listItem = ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              leading: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  onChanged: (_) => setState(() {
                    taskNotifier.changeCheckAt(origIdx[idx]);
                  }),
                  activeColor: widget.theme[400],
                  value: task.isChecked,
                ),
              ),
              title: Text(task.title),
              trailing: IconButton(
                onPressed: () => setState(() {
                  taskNotifier.changeFavAt(origIdx[idx]);
                }),
                icon: Transform.scale(scale: 1.5, child: Icon(task.isFav ? Icons.star_sharp : Icons.star_outline)),
                color: (task.isFav ? Colors.amber : Colors.black54),
              ),
            ),
          ),
        );

        return Dismissible(
          key: ObjectKey(task),
          background: Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) => setState(() {
            taskNotifier.removeTaskAt(origIdx[idx]);
          }),
          direction: DismissDirection.endToStart,
          child: listItem,
        );
      },
    );
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Название не может быть пустым';
    }

    if (value.length > 40) {
      return 'Слишком длинное название';
    }

    return null;
  }

  AppBar _createAppBar() {
    var notifier = NotifierProvider.of(context).appBarNotifier;
    var taskNotifier = NotifierProvider.of(context).taskNotifier;
    var titleNotifier = NotifierProvider.of(context).titleNotifier;
    var theme = widget.theme[400];

    var options = [
      _createMenuItem(
          notifier.isUnchecked
              ? 'Показать выполненные'
              : 'Скрыть выполненные',
          () => setState(() => notifier.toggleUnchecked()),
          notifier.isUnchecked
              ? Icon(Icons.check_circle_outline, color: theme)
              : Icon(Icons.check_circle, color: theme),
      ),
      _createMenuItem(
          notifier.isOnlyFavorite
              ? 'Показать все'
              : 'Только избранные',
          () => setState(() => notifier.toggleOnlyFavorite()),
          notifier.isOnlyFavorite
              ? Icon(Icons.star_border, color: theme)
              : Icon(Icons.star, color: theme),
      ),
      _createMenuItem(
          'Сортировать',
          null,
          Icon(Icons.sort, color: theme)
      ),
      _createMenuItem(
        'Удалить выполненные',
        () {
          Future.delayed(
            const Duration(seconds: 0),
                () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Подтвердите удаление'),
                  content: const Text('Удалить выполненные задачи? Это действие необратимо.'),
                  actions: [
                    _createCancelButton(context),
                    TextButton(
                      onPressed: () {
                        Future.delayed(const Duration(seconds: 0), () {
                          taskNotifier.removeAllChecked();
                          setState(() {});
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Подтвердить'),
                    )
                  ],
                );
              },
            ),
          );
        },
        Icon(Icons.delete_outline, color: theme),
      ),
      _createMenuItem('Выбрать тему', null, Icon(Icons.style_outlined, color: theme)),
      _createMenuItem(
        'Редактировать ветку',
            () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final textController = TextEditingController();
                textController.text = titleNotifier.title;

                return AlertDialog(
                  title: const Text("Редактировать ветку"),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: "Введите название ветки",
                      ),
                      maxLength: 40,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      validator: _validator,
                    ),
                  ),
                  actions: [
                    _createCancelButton(context),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            titleNotifier.setTitle(textController.text);
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text("Ок"),
                    )
                  ],
                );
              },
          );
        },
        Icon(Icons.mode_edit_outlined, color: theme),
      ),
    ];

    return AppBar(
      title: Text(NotifierProvider.of(context).titleNotifier.title),
      actions: [PopupMenuButton(itemBuilder: (_) => options)],
    );
  }

  PopupMenuItem _createMenuItem(String title, void Function()? onTap, Icon icon) {
    return PopupMenuItem(
      onTap: onTap,
      child: ListTile(
        leading: icon,
        title: Text(title),
      ),
    );
  }

  TextButton _createCancelButton(context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Отмена"),
    );
  }
}
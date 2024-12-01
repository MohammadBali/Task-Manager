class TodosModel
{
  List<TodoModel?> todos=[];

  PaginationModel? pagination;

  TodosModel.fromJson(Map<String,dynamic>json)
  {
    if(json['todos']!=null)
    {
      json['todos'].forEach((todo)
      {
        todos.add(TodoModel.fromJson(todo));
      });
    }

      pagination = PaginationModel.fromJson(json);

  }

  /// Adds pagination
  void addPagination(Map<String,dynamic> json)
  {
      pagination = PaginationModel.fromJson(json);

  }

  /// Adds Todos
  void addTodos(Map<String,dynamic> json)
  {
    if(json['todos']!=null)
    {
      json['todos'].forEach((todo)
      {
        TodoModel myTodo = TodoModel.fromJson(todo);

        //Checks for no duplicate values
        if(isFound(myTodo.id) == false)
        {
          todos.add(TodoModel.fromJson(todo));
        }

      });
    }

  }

  ///Adds Todos coming from Local DB
  void addTodosFromDB(Map<String,dynamic>todo)
  {
    TodoModel myTodo = TodoModel.fromJson(todo);

    //Checks for no duplicate values
    if(isFound(myTodo.id) == false)
    {
      todos.add(myTodo);
    }

  }

  ///Checks if to-do exists
  bool isFound(int? id)
  {
    for(var todo in todos ?? [])
    {
      if(todo.id == id)
      {
        return true;
      }
    }

    return false;
  }

}

class TodoModel
{
  int? id;
  String? todo;
  bool? completed;
  int? userId;

  TodoModel.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    todo =json['todo'];

    try
    {
      completed = json['completed'];
    }
    catch (e)
    {
      completed = bool.tryParse(json['completed']);
    }

    if(json['userId']!=null)
    {
      userId=json['userId'];
    }
  }

  @override
  String toString() {
    return 'TodoModel:\n'
        'id: $id\n'
        'todo: $todo\n'
        'completed: $completed\n'
        'userId: $userId\n';
  }
}

class PaginationModel
{
  num? total;
  num? skip;
  num? limit;

  PaginationModel.fromJson(Map<String,dynamic>json)
  {
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
}
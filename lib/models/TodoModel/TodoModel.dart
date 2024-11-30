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
        todos.add(TodoModel.fromJson(todo));
      });
    }

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
    completed = json['completed'];

    if(json['userId']!=null)
    {
      userId=json['userId'];
    }
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
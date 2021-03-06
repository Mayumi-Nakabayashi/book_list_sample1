import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../add_book/add_book_page.dart';
import '../domain/book.dart';
import '../edit_book/edit_book_page.dart';
import 'book_list_model.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('本一覧'),
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return const CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                    (book) => Slidable (

                      // Specify a key if the Slidable is dismissible.
                      key: const ValueKey(0),

                      // The start action pane is the one at the left or the top side.


                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              //　画面遷移
                              final bool? added = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookPage(),
                                ),
                              );

                              if (added != null && added) {
                                const snackBar = SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('本を編集しました'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              model.fetchBookList();
                            },
                            flex: 2,
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編集',
                          ),

                          SlidableAction(
                            onPressed: (context) {

                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: '削除',
                          ),

                        ],
                      ),

                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      ),
                    ),
                  )
                  .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                //　画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBookPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('本を追加しました'),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                }
                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}
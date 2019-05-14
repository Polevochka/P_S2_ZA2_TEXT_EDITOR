unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{Глобальные переменные}
// Спецификация файла - его полное имя, которое ВИДНО ВО ВСЕХ процедурах
var sf: string;

{ TForm1 }

{Особые действия при открытии}
procedure TForm1.FormCreate(Sender: TObject);
begin
  sf := '';   // Никакого файла мы ещё не открывали
  // Каталоги для сохраненияи и открытия по умочанию (Папка проекта)
  OpenDialog1.InitialDir:='';
  SaveDialog1.InitialDir:='';
end;

{Создать}
procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Memo1.Clear;  // Очищаем текстовый редактор, что равносильно изменению в Memo1
  Memo1.Modified:= False;  // Но мы же ничего не поменяли, надо это указать
  sf:='';                  // А у файла нет ещё имени
  Form1.Caption:= 'Form1'; // Заголовок окна
end;

{Открыть}
procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  // Перед тем как открыть новый файл, нодо проверить вдруг есть несохранённые
  // изменения в старом - УЖЕ открытом(новом пустом) файле
  If Memo1.Modified then
    case MessageDlg('Текст был изменён' + #13 + 'Сохранить его?',
                    mtConfirmation,[mbYes, mbNo, mbCancel],0) of
      mrYes   : MenuItem5Click(self); // Да -> сохраняем старый файл
      mrNo    : ;
      mrCancel: Exit;
    end;

  // Если диалог открытия файла завершился нормально,
  // То есть его не закрыли и не нажали cancel
  // То есть юзер выбрал нужный ему файл и нажал ОК
  If openDialog1.Execute then
    begin
      sf:=OpenDialog1.FileName;     // Извлекаем имя файла из этого диалога
      Memo1.Lines.LoadFromFile(sf); // Выводим его в Memo1
      Memo1.Modified:=False;  // Что равносильно его изменению, но мы же не изменяли файл
      Form1.Caption:='Form1 ' + sf; // В заголовок окна выводим имя файла
    end;

end;

{Закрыть}
procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  // Стандартных диалог сохранения файла
  // Если Memo1 было изменено
  if Memo1.Modified then
      // Стандартное окно Сообщения
      case MessageDlg('Данные о студентах были изменены' + #13 + 'Сохранить их?',
                      mtConfirmation,[mbYes, mbNo, mbCancel],0) of
        mrYes: MenuItem5Click(self); // Сохраняем файл
        mrNo:;                    // Ничего не делаем
        mrCancel: Exit; // Выходим из окна сообщения, и возвращаемся к редактированию текста(действия ниже выполняться не будут)
      end;

  // Если мы не вишли через 'Cancel', то совершаем стандартные действия
  Memo1.Clear;  // Очищаем окно редактора
  Memo1.Modified:= False;
  sf:='';
  Form1.Caption:= 'Form1';

end;

{Сохранить как}
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  // Если диалог сохранения прошёл хорошо
  if SaveDialog1.Execute then
    begin
      sf:= SaveDialog1.FileName; // Извлекаем имя файла
      Memo1.Lines.SaveToFile(sf); // Cохраняем содержимое редактора в файл с именем sf

      Memo1.Modified := False; // Содержимое в редакторе соответсвует файлу на диске
      Form1.Caption:= 'Form1 ' + sf; // Устанавливаем заголовок приложения с именем файла
    end;

end;

{Сохранить}
procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  // Исли имя файла не задано, то вызываем Окно 'сохранить как'
  if sf = '' then MenuItem6Click(self)
  else  // Иначе, то есть имя файла уже установлено
    begin
      Memo1.Lines.SaveToFile(sf); // Сразу сохраняем его на диск
      Memo1.Modified:= False;  // Содержание устанавливаем не изменённым, тк сохранили всё на диск
    end;

end;

{Выход}
procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  // Сообщение: Сохранить ли изменённый файл
  if Memo1.Modified then
    case MessageDlg('Файл был изменён' + #13 + 'Сохранить его?',
                    mtConfirmation,[mbYes, mbNo, mbCancel],0) of
      mrYes   : MenuItem5Click(self); // Да -> сохраняем открытый файл
      mrNo    : ;
      mrCancel: Exit;
    end;
  // Закрываем приложение
  close;
end;

// Обработка

{Получаем сумму баллов из строки одного студента s}
function SummPoints(s: string): integer;
var o1, o2, o3: integer; // оценки студента
begin
  // По условию задачи баллы находятся в конце строки s и занимают 6 символов
  // на каждую оценку из этих 6 символов отводится по 2 символа
  // например s = '1 Pushkin      RKT2-21 3 4 5'
  // вот мы хотим получить первую оценку
  // номер её позиции 5 с конца строки
  // ' 3 4 5'
  //   54321
  // чтобы получить этот индкс надо вычесть из длины строки на один символ меньше 5
  // length(s)-4
  // И да заметьте формулу чтобы получить i-ый c конца строки символ надо вычесть из
  // строки (i-1)
  // length(s) -(i-1) = length(s) - i + 1
  // Вспомните формулу для обхода обратной диагонали в матрице
  // i = n-i+1
  // В матрицах если бы i = 1 - первоя стока, то нужно было получить 1-ый
  // с конца строки столбец, здесь то же самое только строки
  o1 := StrToInt(copy(s, length(s)-4, 1)); // 5-а позиция с конца 1 символ
  o2 := StrToInt(copy(s, length(s)-2, 1));
  o3 := StrToInt(copy(s, length(s), 1));

  // Присваиваем сумму оценок(это и есть сумма балов одного студентв)
  // функции - это то что вернёт функция после своей работы
  SummPoints:= o1 + o2 + o3;
end;

{Сортировка при выводе}
procedure TForm1.MenuItem9Click(Sender: TObject);
var f: textfile; // файл со строками студентов
    s: string; // строка представляющая одно студента
    i: integer; // для обхода студентов в редакторе
    // индекс студента в Memo1, у которого больше всех число баллов (в окне редактора)
    i_best: integer;

begin
  // считаем что юзер УЖЕ открыл файл студентов в редакторе
  // и sf(имя файла) не пустая переменная

  // Очищаем файл и открываем его НА запись
  AssignFile(f, sf);
  Rewrite(f);

  // Будем искать студента с наибольшим числом баллов(в редакторе)
  // Потом записывать его в файл
  // И потом удалям этого студента из окна редактора
  // чтобы уже опять искать другого студента с наибольшим числом баллов
  // Обходим строки редактора

  // Следовательно будем уменьшать число строк редактора
  // легче всего будет сделать цикл на проверку количество строк в Memo1
  // А внутри этого цикла производить все действия и в конечном итоге удалять
  // по одной строке
  while (Memo1.Lines.Count > 0) do
  begin
    // сначала будем считать что Лучший студент(с наибольшим числом баллов)
    // это первый
    // логично ведь мы ещё не просмотрели других студентов
    s := Memo1.Lines[0];
    i_best:= 0; // индекс студента с наибольшим числом баллов
    for i:= 1 to Memo1.Lines.Count-1 do
      // Если нашли студента у которого число баллов больше
      if SummPoints(s) < SummPoints(Memo1.Lines[i]) then
      begin
        // Изменяем лучшего студента
        s:= Memo1.Lines[i];
        // изменяем индекс лучшего студента
        i_best:= i;
      end;

    // здесь внутренный цикл for отработал - нашли нужного студента
    // Запишем его в файл
    writeln(f,s);

    // Нужно удалить записанного сутдента из текстового редактора
    // так как у него больше всех баллов чтобы, и если ещё раз произвести
    // поиск лучшего студента - опять получится он
    // мы сохранили его идекс
    // В Memo1 есть очень полезный метод Delete
    // Удаляем строку с индексом лучшего студента
    Memo1.Lines.Delete(i_best);
  end;

  // Цикл while закончился - значит удалили всех студентов из текстового редактора
  // - значит всех записали в текстовый файл -> надо этот файл закрыть
  CloseFile(f);

  // Тепрь для больше юзабельности нашей обработки
  // выведим изменённый файл в окно редактора
  Memo1.Lines.LoadFromFile(sf);

  // Мы изменяли Memo1 - но сейчас строки в редакторе соответствуют файлу на диске
  Memo1.Modified := False;

end;

{Обработка 2}
procedure TForm1.MenuItem10Click(Sender: TObject);
begin

end;


end.


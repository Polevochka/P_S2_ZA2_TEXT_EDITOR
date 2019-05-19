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

{Извлекаем Фамилию из строки студента}
function GetName(s: string): string;
// вспомогательная переменная - в неё будем записывать фамилию
var studName: string;
begin
  // По условию задачи фамилия студента в строке студента
  // расположена начиная с 4 позиции и занимает 12 символов
  // Извлекаем фамилию
  studName := copy(s, 4, 12);

  // Присваиваем имени функции полученную нами фамилию
  // это и есть - то что возвращает функция
  GetName := studName;
end;

{Сортировка}
procedure TForm1.MenuItem9Click(Sender: TObject);
var i, j: integer;
    i_min: integer; // индекс 'минимального' студента(фамилия меньше всех)
    s_min, s: string; // cстроки студентов, что будем менят
begin
  // Здесь мы считаем, что юзер уже открыл файл на редактирование
  // и переменная sf(имя файла) - не пустая

  // Используем менаджер контекста, чтобы меньше писать Memo1
  // каждый раз обращаясь к её отрибутам
  With Memo1 do
    // Теперь обойдём строки и отсортируем их методом нахождения минимального элемента
    // Не забываем что строки нумеруются с 0
    for i:= 0 to Lines.Count-2 do
    begin
      // Запоминаем индекс текущего студента
      i_min := i;
      // и сохраняем студента в переменную
      s_min:= Lines[i_min];

      // Ищем минимального студента(если такой есть), что НИЖЕ текущего
      for j:=i+1 to Lines.Count-1 do
      begin

        // Получаем строку следующего студента
        s := Lines[j];

        // Если фамилию следующего студента МЕНЬШЕ
        // фамили ТЕКУЩЕГО 'минимально' студента
        if (GetName(s) < GetName(s_min)) then
        begin
          // Запоминаем индекс этого 'меньшего' студента
          i_min:= j;
          // И сохраняем этого минимального студента в переменную
          // то есть теперь ОН является минимальным студентом
          s_min := Lines[i_min];
        end;
      end;

      // Мы прошли всех студентов что ниже ТЕКУЩЕГО i-го
      // Мы нашли какого-то стодента у которого фамилия МЕНЬШЕ
      // чем у текущего

      // Теперь их надо поменять местами
      // если студента с меньшей фамилией НЕ нашлось то ничего не поменяется

      // Текущего студента сгоняем на место где стоял минимальный студент
      // то есть запихиваем его куда-то дальше текущей i-ой позиции
      Lines[i_min] := Lines[i];
      // На текущем месте должен быть студент с меньшей фамилией
      Lines[i] := s_min;

      // Переходим к другим студентам ниже
    end;

  {
    как действует алгоритм
        curent - текуший студен
        s_min - минимальный студент

        допустим они вот так расположены

        s1 s2 curent s3 s4 s5 s6 s_min s7 s8 s9 ...

        В врехнем циклы c i - мы обходим все элементы
        и сейчас мы на позиции студента curent

        После окончания ВНУТРЕННЕГО цикла с j, где мы обходим студентов что
        ПСОЛЕ curent то есть это - s3 s4 s5 s6 s_min s7 s8 s9 ...

        мы находим что после curent где-то в массиве стцдентов
        есть студент у которого фамилия
           а) - меньше чем у current
           б) - меньше чем у всех остальных студентов ниже curent
                                         s3 s4 s5 s6 s7 s8 s9 ...


        // Мы меняем местами студента curent и s_min
        тепрь наши строки в Memo1 выглядят так

        s1 s2 s_min s3 s4 s5 s6 curent s7 s8 s9 ...

        // И так обходя студента за студентов в ВЕРХНЕМ цикле
        // мы всех студентом с минимальныи фамилиями отправляем в верх
   }

  // В задании сказано сохранить изменения в файл
  // Для этого достаточно вызвать Обработчик форму {Сохранить}
  // self - как бы показывает что именно к нашей форме Form1 относятся эти действия
MenuItem5Click(self);
end;

{Обработка 2}
procedure TForm1.MenuItem10Click(Sender: TObject);
begin

end;


end.


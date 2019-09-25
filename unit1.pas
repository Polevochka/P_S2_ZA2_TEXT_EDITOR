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

{Получить средний балл студента s}
function GetAve(s: string): real;
var o1, o2, o3: integer; // оценик студента
begin

  // По условию задачи оценки студента занимают
  // последние 6 символов строки s с информацией о студенте
  // например: '1 Bulgakov     SM4-21  3 3 3'
  // Под оценки выделено 6 символов - ' 3 3 3'
  // Чтобы получить первую оценку надо получить символы,
  // выделенные под 1-ую оценку
  // Чтобы получить индекс 6 с конца символа надо из длины строки выесть 5
  // Здесь такая же формула как и в матрицах
  // формула побочной диагонали a[i, n-i+1]
  // здесь также только вместо n - длина строки
  // Чтобы получить индекс i-го с конца символа строки
  // надо вычесть из длиный строки i и прибавить 1
  // то есть   'length(s) - i + 1'    - i-ый с конца символ

  // Получаем оценки этого студента
  o1 := StrToInt(copy(s, 24, 2));
  o2 := StrToInt(copy(s, 26, 2));
  o3 := StrToInt(copy(s, 28, 2));

  // То что мы присваиваем имени функции - то и вернёт функция после своей работы
  // средний балл студента
  GetAve:= (o1 + o2 + o3)/3;
end;

{Добавить средние баллы}
procedure TForm1.MenuItem9Click(Sender: TObject);
var f: textfile;     // текстовый файл для считывания студентов
    gr_f: textfile;  // текстовый файл со студентами ОПРЕДЕЛЁННОЙ группы
    ave_str: string; // строковое представление среднего балла
    userGroup: String; // группа вводимая пользователем
    curGroup: String;  // текущее имя группы студента в файле
    s: string; // переменная для считывания студентов
    nameGroupFile: string;

begin

  // Получаем название группы от пользователя
  userGroup:= inputbox('Ввод значений', 'Введите имя группы', '');

  // Здесь мы считаем, что юзер уже открыл файл на редактирование
  // и переменная sf(имя файла) - не пустая
  // Открываем файл со студентами на ЧТЕНИЕ
  AssignFile(f, sf);
  Reset(f);

  // Открываем файл студентов из группы userGroup на ЗАПИСЬ
  // Название файла - имя группы и расширение
  nameGroupFile := userGroup + '.txt';
  AssignFile(gr_f, nameGroupFile);
  Rewrite(gr_f);

  // добавляем к названию группы пробеллы
  // в файле по группу отводится 8 символом из строки студента
  // поэтому для верного поска группы студента в его строке нужно
  // увеличить длину строки userGroup вводимой строки пользователя
  // до нужной длины
  while(length(userGroup) < 8) do
    userGroup := userGroup + ' ';

  // Считываем всех студентов по одному из ИСХОДНОГО файла f
  // а в файл нашей группы будем записывать только тех студентов
  // у которых группа совпадет с группой userGroup
  while(not EOF(f)) do
  begin
    // считываем одного студента
    readln(f, s);

    // получаем ия группы студента
    curGroup := copy(s, 17, 8);

    // если его группа совпадает с нашей
    if (curGroup = userGroup) then
    begin
      // находим его средний балл в строковом виде
      // 2 в конце - число знаков после запятой
      ave_str := FloatToStrF(GetAve(s), fffixed, 1, 2);

      // записываем в файл нашей группы студента с его средним баллом
      writeln(gr_f, s + ' ' + ave_str);
    end;

  end;
  // прочитали весь файл надо его закрыть
  closefile(f);

  // в файл gr_f - мы записали всех возможных студентов
  // поэтому его тоже закрываем
  closefile(gr_f);

  // Загружаем в Memo файл студентов из группы userGroup
  sf := nameGroupFile;
  Memo1.Lines.LoadFromFile(sf);
  Memo1.Lines.LoadFromFile(sf); // Выводим его в Memo1
  Memo1.Modified:=False;  // Что равносильно его изменению, но мы же не изменяли файл
  Form1.Caption:='Form1 ' + sf; // В заголовок окна выводим имя файла

end;

{Вставит студента s в j-ую строку}
procedure InsertStud(s: string; r: integer);
var i: integer;
begin

  // Если в Memo1 нет строк
  if (Form1.Memo1.Lines.Count = 0) then
  begin
    //то добавляем строку в конец
    Form1.Memo1.Append(s);
    // Досрочно выходим из функции - нам дальше делать нечего
    Exit;
  end;

  // используем менаджер контекста чтобы меньше писать Form1.Memo1
  with Form1.Memo1 do
  begin

    // сдвигаем все студентов ниже j-ой строки на одну позицию вниз
    for i:= Lines.Count-1 downto r do
      Lines[i+1] := Lines[i];

    // Допустим r = 4
    // Было: s0 s1 s2 s3 s4 s5 s6
    //Стало: s0 s1 s2 s3 s4 s4 s5 s6
    //                   ^
    //                   |
    // Теперь можно как раз записать нашего студент на 4-ую позицию
    Lines[r] := s;

    // Стало: s0 s1 s2 s3 s s4 s5 s6
  end;
end;

{Упорядочить строки по СредБаллу}
procedure TForm1.MenuItem10Click(Sender: TObject);
var f: textfile; // файл со строками студентов
    s: string; // cтрока студентов, что будем записывать в файл
    i_ins: integer; // индекс вставки студента
    i: integer;
    ave_str: string; // средний балл студента
begin
  // Здесь мы считаем, что юзер уже открыл файл на редактирование
  // и переменная sf(имя файла) - не пустая

  // Открываем файл со студентами на ЧТЕНИЕ
  AssignFile(f, sf);
  Reset(f);

  // Перед записью в Memo1 очищаем его
  Memo1.Clear;

  // Обходим всех студентов в файле
  While(not EOF(F)) do
  begin
    // Считываем одно студента из файла
    readln(f, s);

    // и находим место куда вставить нашего студента
    // По убыванию среднего файла
    // Сначала считаем что у нашего студента самой большой средний балл
    // то есть его нужно вставить в нулевую строчку
    // если появятся студенты с большим баллом - мы изменим индекс вставки
    i_ins := 0;

    // Теперь обходим всех студентов в Memo1
    for i:= 0 to Memo1.Lines.Count-1 do
    begin
      // Если у студента в Memo1 средний балл больше - то
      if (GetAve(Memo1.Lines[i]) > GetAve(s)) then
        // нужно вставить студента s ПОСЛЕ этого студента
        i_ins:= i+1;

      // Отдельно рассмотри случай, когда средние баллы одинаковы
      if (GetAve(Memo1.Lines[i]) = GetAve(s)) then
      begin
        // В этом случае надо вставлять студентов по УВЕЛИЧЕНИЮ номера
        // По условию номер студента храниться в первых двух символах
        // строк. Copy(str, 1, 2); - как раз и получает эти два первых символа

        // если у ВСТАВЛЯЕМОГО студента номер БОЛЬШЕ чем у студента в таблице
        if (StrToInt(Copy(s, 1, 2)) > StrToInt(Copy(Memo1.Lines[i], 1, 2))) then
          // нужно вставить студента s ПОСЛЕ этого студента
          i_ins := i+1
        // Иначе - то есть у студента в таблице номер больше
        else
          // Нужно вставить студента s НА место студента в таблице
          i_ins := i;
      end;
    end;

    // Обошли всех студентов Memo1  и нашли куда вставлять нашего - i_ins

    // Вставляем студента в строку i_ins
    InsertStud(s, i_ins);
  end;
  // Прочитали весь файл со студентами - надо его закрыть
  CloseFile(f);

  // добавляем средние баллы к строке каждого студента
  // если в его строке уже есть средние баллы то просто не добавляем их
  // Чтобы меньше писать Memo1.Lines используем with
  with Memo1 do
  begin
    for i:=0 to Lines.Count-1 do
    begin
      // если длина строки студента больше 29 то средние баллы у него уже есть
      // поэтому ищем только тех студентов у которых длина строки = 29
      if (length(Lines[i]) = 29) then
      begin
        // находим средний балл студента в строковом виде
        // 2 в конце - число знаков после запятой
        ave_str := FloatToStrF(GetAve(Lines[i]), fffixed, 1, 2);

        // добавляем его к строке студента
        Lines[i] := Lines[i] + ' ' + ave_str;
      end;
    end;
  end;
end;

end.


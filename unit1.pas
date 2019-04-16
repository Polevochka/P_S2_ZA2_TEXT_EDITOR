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

// Наши собственные типы данных, используемые в приложении
Type

  // тип для отдельно взятого студента
  Stud = Record
    No       : integer;     // Номер (его ID)
    Name     : string[12];  // Имя
    Gr       : string[8];   // Группа
    o1,o2,o3 : integer;     // Оценки
  end;

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

{Средний балл группы}
procedure TForm1.MenuItem9Click(Sender: TObject);
var mainGr: string; // Имя 'основной группы' - вводимой пользователем
    f: textfile;    // файловая переменная файла со студентами
    s: string;      // ОДНА строка файла (информация об одном студенте)
    fileGr: string;     // Название группы студента из файла
    o1,o2,o3: integer; // оценки ОДНОГО студента
    ave: real;  // (от англ. average) - среднее арифметическое - СРЕДНИЙ БАЛЛ
    ave_str: string; // Строковое представление среднего балла
    summPoints: integer; // сумма всеех баллов 'основной' группы
    countStuds: integer; // число студентов в данной группе
begin
  // считаем что файл уже открыть и sf - имя файла - НЕ пустая переменная

  // Открываем файл студентов на чтение
  AssignFile(f, sf);
  Reset(f);

  // Получаем имя группы от пользователя
  mainGr := inputbox('Ввод значений', 'Введите Название группы', 'RKT4-21');

  // Пользователь может ввести название группы НЕ длиной 8 символов
  // в то время как в файле все группы - это строки длиной 8 символов(включая пробелы)
  // поэтому нужно длину строки группы увеличить до тех пор пока она не станет = 8 символов
  // То есть тупо добавляем пробелы до нужной длины
  While (length(mainGr) < 8) do
  begin
    mainGr := mainGr + ' ';
  end;

  // Сначала сумма балов для ЭТОЙ группы  = 0
  // дальше мы будем увеличивать это число баллами студентов
  // найденных в файле, с учотом того, что имя их группы совпадает с 'основной'
  summPoints := 0;

  // Количество студентов в этой группе тоже изначально = 0
  // Позже обходя файл мы будем увеличивать их число, находя студентов
  // c ТАКИМ же названием группы, которую ввёл пользователь
  countStuds := 0;

  // Теперь обходим файл с информацией о студентах
  while (not EOF(f)) do
  begin
    // Считываем одну строку(одного студента) из файла
    readln(f, s);

    // Получаем имя группы этого студента
    // под неё выделяется 8 символов начиная с 17-го
    fileGr := copy(s, 17, 8);

    // Если группа та же, что ВВЁЛ пользователь, то
    if (mainGr = fileGr) then
    begin
      // Увеличиваем число студентов в нашей группе
      countStuds := countStuds + 1;
      // Извлекаем оценки студента из этой группы

      // По заданию баллы студента занимают последние 6 символов строки s
      // например ' 3 4 5'
      // Например  1-ая оценка начинается с 6 позиции с конца и занимает 2 символа
      // Здесь как с побочной диагональю в матрице, вспомните формулу a[i, n-i+1]
      // чтобы получить индекс i-го символа c конца строки, нодо из длины строки
      // вычесть число i и позже прибавить 1
      // то есть такая формула
      // индекс i-го элемента с конца = length(s) - i + 1;
      // Чтобы нам получить позицию 6 с конца надо
      // вычесть из длины строки 6 и прибавить 1
      // length(s) - 6 + 1 = length(s) - 5
      // То есть в этоге просто вычитаем 5

      // 1-ая оценка начинается 6 c конца символа(length(s)-5) и занимает 2 символа
      o1 := StrToInt(copy(s, length(s)-5, 2));
      // 2-ая оценка начинается 4 c конца символа(length(s)-3) и занимает 2 символа
      o2 := StrToInt(copy(s, length(s)-3, 2));
      // 3-ая оценка начинается 2 c конца символа(length(s)-1) и занимает 2 символа
      o3 := StrToInt(copy(s, length(s)-1, 2));

      // Заметьте StrToInt не обращает внимания на пробелы

      // Полученные оценку суммируем к баллам всей группы
      summPoints := summPoints + o1 + o2 + o3;
    end;

  end;
  // Прочитали весь файл, не забываем его закрыть
  CloseFile(f);

  // если прочитав весь файл мы НЕ НАШЛИ хотя бы одного студента, то
  // summPoints и countStuds будут равны нулю
  // тогда надо сообщить пользователю, что такой группы нет
  if (countStuds = 0) then
  begin
    // Сообщаем об этом
    ShowMessage('Такой группы ' + mainGr +' нет в файле:' + #13 + sf);
    Exit; // досрочно выходим из процедуры обработки
  end;

  // если мы здесь, то нашлись студенты

  // Среднее балл группы - это сумма всех баллов, делённое на их количество
  // дополнительно умножаем число студентов группы на 3, тк у каждого студента
  // по 3 оценки
  ave := summPoints / (countStuds * 3);

  // Теперь преобразуем средний балл в строку
  // 3 в конце - число знаков после запятой
  ave_str := FloatToStrF(ave, fffixed, 1, 3);

  // Предварительно очищаем Memo1
  Memo1.Clear;

  // Добавляем в Мемо название группы и средний балл по ней
  Memo1.Lines.Append(mainGr +':  ' + ave_str);

  Memo1.Modified := False; // мы изменяли Memo1 - но сам файл нет
end;

{Должники}
procedure TForm1.MenuItem10Click(Sender: TObject);
var f: textfile;    // файловая переменная файла со студентами
    s: string;      // ОДНА строка файла (информация об одном студенте)
    nameStud: string; // фамилия студента
    o1,o2,o3: integer; // оценки ОДНОГО студента
    // строка которая может содержаться в фамилии студента из файла - вводит пользователь
    strInName: string;
    isHaveInName: boolean; // логическая переменная есть ли strInName в фамилии студента

begin
  // считаем что файл уже открыть и sf - имя файла - НЕ пустая переменная

  // Открываем файл студентов на чтение
  AssignFile(f, sf);
  Reset(f);

  // Получаем строку которая может содержаться в фамилии студента
  strInName := inputbox('Ввод значений', 'Введите строку, которая может быть' + #13 + 'в фамилии студента', '');

  // очищаем окно редактора перед записью в него
  Memo1.Clear;

  // Теперь обходим файл с информацией о студентах
  while (not EOF(f)) do
  begin
    // Считываем одну строку(одного студента) из файла
    readln(f, s);
    // Извлекаем фамилию студента
    // под неё выделяется пространство 12 символов начиная с 4-ой позиции
    nameStud := copy(s, 4, 12);

    // Получаем оценки этого студента
    o1 := StrToInt(copy(s, length(s)-5, 2));
    o2 := StrToInt(copy(s, length(s)-3, 2));
    o3 := StrToInt(copy(s, length(s)-1, 2));

    // функция pos(sub_s, s) - возвращает индекс первого хождения подстроки sub_s в строке s
    // если такой подстроки нет в строке, то возвращает 0

    // если подстрока есть в строке s или strInName - пустая строка - то нужно проверять оценки
    // этого студента. Если хотябы одна оценка = 2 то
    if ((pos(strInName, nameStud) <> 0) or (strInName = '')) and ((o1 = 2) or (o2 = 2) or (o3 = 2)) then
    begin
      // Добавляем студента в Memo1
      Memo1.Lines.Append(s);
    end;


  end;
  // Прочитали весь файл, не забываем его закрыть
  CloseFile(f);
  Memo1.Modified := False; // мы изменяли Memo1 - но сам файл нет

end;


end.


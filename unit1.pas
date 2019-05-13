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

{Список групп}
procedure TForm1.MenuItem9Click(Sender: TObject);
var f: textfile; // исходный файл
    gr_f: textfile; // файл с группами - куда будем записывать группы
    s: string; // строка с информацией о студенте
    // имя группы - из исходного файла
    // то есть из ИСХОДНОГО файла мы будем считыват строку с информацией о студенте
    // из этой строки вычлениваем на звание группы - записываем в переменную ish_group
    ish_group: string;
    // Имя группы считываемой из файла групп
    // в файле групп имена групп должны быть уникальными - то есть не повторяться
    // для этого заводим эту переменную
    // Вот получили новое имя группы - надо проверить есть оно в файле групп
    // тогда надо как то организовать считывание групп из файла групп
    // используем - эту переменную
    gr_group: string;
    // Логическая переменная - сообщающая нам есть ли такая группа в файле групп
    // такая группа УЖЕ ЕСТЬ в файле групп - true
    // такой группы НЕТ в файле групп - false
    isFoundGroup: boolean;
begin
  // Здесь считаем что пользователь УЖЕ открыл файл со студентами в редакторе
  // то есть переменная sf - имя файла - НЕ пустая

  // Открываем ИСХОДНЫЙ файл на чтение
  AssignFile(f, sf);
  Reset(f);

  // Открываем файл групп на запись
  AssignFile(gr_f, 'Groups.txt');
  Rewrite(gr_f);

  // Считываем из ИСХОДНОГО файла со студентами cтроку одного студента
  readln(f, s);
  // получаем имя группы
  // Имя группы начинатся с 17 символа и занимает 8 символов
  ish_group := copy(s, 17, 8);
  // записываем эту группу в файл с группами
  writeln(gr_f, ish_group);
  // Закрываем файл групп
  closeFile(gr_f);

  // в коде выше мы записали одну группу в файл и закрыли его
  // сделано для того чтобы при проверки нахождения группы в файле групп
  // там бы находиль какая-то группа - с которой можно сравнивать

  // Дальше обходим остальных студентов из ИСХОДНОГО файла и добавляем новые группы
  // в файл групп если такие имеются
  while(not EOF(f)) do
  begin
    readln(f, s); // считываем одного студента из ИСХОДНОГОфайла
    // получаем имя группы
    // Имя группы начинатся с 17 символа и занимает 8 символов
    ish_group := copy(s, 17, 8);

    // Теперь проверяем есть ли такая группа в рабочем файле(ГРУПП)
    // Открываем файл групп на чтение
    Reset(gr_f);
    // По умолчанию считаем, что такой группы в рабочем файле групп НЕТ
    isFoundGroup := False;
    // обходим файл групп и ищем там группу
    while (not EOF(gr_f)) do
    begin
      readln(gr_f, gr_group);
      // если имена групп
      //    из файла групп
      //        и
      //    из исходного файла
      // совпадают то
      if (gr_group = ish_group) then
      begin
        isFoundGroup := True; // Значит такое имя группы УЖЕ есть файле групп
        // досрочно выходим из цикла - ведь мы нашли уже то что искали нет смысла
        // проверять файл дальше
        break;
      end;
    end;
    // Весь файл обошли -> надо его закрыть
    closeFile(gr_f);

    // если мы НЕ нашли группу с именем ish_group в файле групп - то это НОВАЯ группа,
    // которую нужно добавить в файл групп
    if (not isFoundGroup) then
    begin
      // Открываем файл групп на добавление в конец
      Append(gr_f);
      // дописываем НОВУЮ группу в конец
      writeln(gr_f, ish_group);
      // Закрываем файл групп - чтобы потом ещё раз прочитать
      CloseFile(gr_f);
    end;

  end;
  // Мы прочитали весь файл со студентами (с именем sf)
  // надо его закрыть
  CloseFile(f);

  // вот здесь мы уже создали И заполнили файл групп
  // осталось только вывести этот файл в окно редактора

  // Отображаем файл групп в Memo1
  Memo1.Lines.LoadFromFile('Groups.txt');

  // мы изменяли Memo1 , но сам файл sf меняли
  Memo1.Modified := False;

end;

{Выбор по фамилии}
procedure TForm1.MenuItem10Click(Sender: TObject);
// та фамилия - которую вводит ПОЛЬЗОВАТЕЛЬ,
// то есть студента с такой фамилией мы ищем в файле
var PosStudName: string;
    f: textfile; // файл со студентами
    s: string; // строка с информацией об одном студенте
    FileStudName: string; // имя этого студента(будем вычленивать имя студента из строки s)
begin

  // Получаем фамилю студента от пользователя
  PosStudName := inputbox('Ввод данных', 'Введите фамилию студента', '');

  // по условию задачи под фамилию студента отводится ровно 12 символов
  // если имя меньше по размеру - то в конце ставятся пробелы
  // так фамилию студентов представлены в файле
  // но когда пользователь вводит фамилию (inputbox) - пробелы - не добавляются

  // Добавляем пробелы в конец строки PosStudName,
  // до тех пор пока её длина не станет равной 12
  // это нужно чтобы более точно сравнивать фамилии
  // например если пользователь введёт фамилию 'Putin'
  // в файле на фамилию отводится 12 символов
  // если такая фамилия есть в файле то она
  // будет 'Putin       ' - с пробелами в конце
  // если мы будем сравнивать это две строки
  // 'Putin' и 'Putin       ' - то обнаружим что ОНИ НЕ РАВНЫ
  // Поэтому длину первой стоки надо привести к 12 - прибавляя пробелы в её конец
  while(length(PosStudName) < 12) do
    PosStudName := PosStudName + ' ';


  // Дальше мы будем выводить в окно редактора студентов с фамилиями как PosStudName
  // Поэтому нужно очистить Memo1
  Memo1.Clear;

  // Здесь считаем что пользователь УЖЕ открыл файл со студентами в редакторе
  // то есть переменная sf - имя файла - НЕ пустая

  // Открываем ИСХОДНЫЙ файл на чтение
  AssignFile(f, sf);
  Reset(f);

  // Обходим этот файл
  while (not EOF(f)) do
  begin
    // считываем из файла одного студента из файла
    readln(f, s);
    // получаем его фамилию
    // По условия фамилия студента начинается  с 4 символа в строке s
    // и занимает 12 символов
    FileStudName := copy (s, 4, 12);

    // если полученная фамилия совпадает с оригиналом, введённым пользователем
    if (FileStudName = PosStudName) then
      // Добавляем студентов в Memo1
      Memo1.Append(s);

  end;
  // Обошли весь файл студентов -> надо его закрыть
  CloseFile(f);

  // мы изменяли Memo1 - но НЕ изменяли файл
  Memo1.Modified := False;

end;



end.


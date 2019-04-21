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

{Логическая функция - отличник ли переданный студент s}
// Возвращает True - если Да отличник
// возвращает False - если НЕТ - НЕ все пятёрки
function IsBestStud(s : string): boolean;
var o1, o2, o3: integer; // оценки Этого студента
begin
  // Нужно извлечь из строки студента его оценки
  // по условию задачи оценки хранятся в конце стрки и занимают 6 символов
  // Например ' 3 4 5'
  // Присмотримся к оценке 3 - она 5 с конца чтобы получить её индекс надо
  // из длины строки вычесть 5 и прибавить 1, то есть
  // index_3 = length(s) - 5 + 1 = length(s) - 4
  // То есть почти такая же формула как при обходе ПОБОЧНОЙ диагонали в матрицах
  // a[i, n-i+1]

  // Просто копируем эти оценки и преобразуем их в целые числа
  o1 := StrToInt(copy(s, length(s)-4, 1)); // 4 позиция с конца 1 символ
  o2 := StrToInt(copy(s, length(s)-2, 1));
  o3 := StrToInt(copy(s, length(s), 1));

  // Студент является отличником только тогда, когда ОДНОВРЕМЕННО у него ВСЕ 5
  // Присваиваем имени функции - значение логического выражения - то что
  // вернёт функция
  IsBestStud := (o1 = 5) and (o2 = 5) and (o3 = 5);
end;


{Число отличников по группам}
procedure TForm1.MenuItem9Click(Sender: TObject);
var f: textfile; // файловая переменная для чтения из файла
    gr_f: textfile; // файл с группами
    s: string; // строка с информацией о студенте
    OrigGr: string; // имя группы - из исходного файла
    GrGr: string; // имя группы из файла групп
    isHaveGroup: boolean; // Логическая переменная - сообщающая нам есть ли такая группа в файле групп
    countBest: integer; // число отличников в группе
begin
  // Считаем что юзер открыл файл в редакторе - то есть sf - не пустая

  // Открываем на чтение ИСХОДНЫЙ файл
  AssignFile(f, sf);
  Reset(f);

  // Cначала нужно узнать какие вообще группы есть в файле
  // Создадим отдельный рабочий файл - куда будем записывать группы

  // Открываем рабочий файл на запись
  AssignFile(gr_f, 'GroupsFile.txt');
  Rewrite(gr_f);

  // Считываем из ИСХОДНОГО файла со студентами cтроку одного студента
  readln(f, s);
  // получаем имя группы
  // Имя группы начинатся с 17 символа и занимает 8 символов
  OrigGr := copy(s, 17, 8);
  // записываем эту группу в рабочий файл
  writeln(gr_f, OrigGr);
  // Закрываем файл групп
  closeFile(gr_f);

  // Дальше обходим остальных студентов из ИСХОДНОГО файла и добавляем новые группы
  // в файл групп если такие имеются
  while(not EOF(f)) do
  begin
    readln(f, s); // считываем одного студента из ИСХОДНОГОфайла
    // получаем имя группы
    // Имя группы начинатся с 17 символа и занимает 8 символов
    OrigGr := copy(s, 17, 8);

    // Теперь проверяем есть ли такая группа в рабочем файле(ГРУПП)
    // Открываем файл групп на чтение
    Reset(gr_f);
    // По умолчанию считаем, что такой группы в рабочем файле групп нет
    isHaveGroup := False;
    // обходим файл групп и ищем там группу
    while (not EOF(gr_f)) do
    begin
      readln(gr_f, GrGr); // считали одну группу из файла групп
      // Если Группа из файла групп = группе из файла студентов
      if (GrGr = OrigGr) then
      begin
        isHaveGroup := True; // Значит такое имя группы есть файле групп
        // досрочно выходим из цикла - ведь мы нашли уже то что искали нет смысла
        // проверять файл дальше
        break;
      end;
    end;
    // Весь файл групп обошли -> надо его закрыть
    closeFile(gr_f);

    // если такой группы нет в РАБОЧЕМ файле (ГРУПП) то
    if (not isHaveGroup) then
    begin
      // Открываем рабочий файл на добавление в конец
      Append(gr_f);
      // дописываем НОВУЮ группу в конец
      writeln(gr_f, OrigGr);
      // Закрываем файл групп - чтобы потом ещё раз прочитать
      CloseFile(gr_f);
    end;

  end;
  // Обошли весь файл со студетами - надо его закрыть
  CloseFile(f);


  // Теперь будем выводить в мемо1 -
  //1 <группу>
  //2 строки самих отличников
  //3 <число отличников в группе>
  //4 разделительную строку - чтобы отделять красивенько группы

  // Сначала надо очитстить Memo1
  Memo1.Clear;

  // Открываем на ЧТЕНИЕ файл групп - ведь в нём будем искать уникальные группы
  Reset(gr_f);

  // Обходим файл групп - и ищем студентов из этой группы - отличников
  while(not EOF(gr_f)) do
  begin
    // Считываем одну группу из файл групп
    readln(gr_f, GrGr);

    // Добавляем имя этой группы в Memo1
    Memo1.Lines.Append(GrGr);

    // Считаем по умолчанию, что в группе GrGr - пока 0 отличников
    // Если они появятся мы просто увеличим значение переменной
    countBest := 0;

    // Открываем на ЧТЕНИ файл студентов - ведь в неём будем искать отличников
    Reset(f);

    // ищем в файле со студентами студентов с такойже группы
    While(not EOF(f)) do
    begin
      // Считываем одного студента
      readln(f, s);

      // получаем имя группы
      // Имя группы начинатся с 17 символа и занимает 8 символов
      OrigGr := copy(s, 17, 8);

      // Если этот студент из нашей группы и является отличником то
      if (OrigGr = GrGr) and (isBestStud(s)) then
      begin
        // Увеличивыем число отличников
        countBest := countBest + 1;
        // Записываем данного студента в мемо1
        Memo1.Lines.Append(s);
      end;
    end;
    // Обошли файл студентов - надо его закрыть
    CloseFile(f);

    // После того как мы прошли файл студентов - обошли всех студентв
    // значит мы ужнали сколько студентов отличников группе
    // записываем число отличников в Memo1 (предварительно преобразовав число в строку)
    Memo1.Lines.Append('Число отличников:  ' + IntToStr(countBest));

    // Добавляем разделительную строку - чтобы разделять группы
    Memo1.Lines.Append('--------------------------------------------------------');
  end;
  // Обошли файл групп надо закрыть его
  CloseFile(gr_f);

  // Файл групп - это временный файл - он нам не понадобиться в работе приложения
  // Лучше будет его удалить
  DeleteFile('GroupsFile.txt');

  // Мы изменяли мемо - но сам файл со студентами не меняли
  Memo1.Modified := False;
end;

{Добавить строку}
procedure TForm1.MenuItem10Click(Sender: TObject);
var StudName: string; // имя студента
    Gr: string; // имя группы
    s_o1, s_o2, s_o3: string; // оценки студента в строковом представлении
    s: string; // студент получившейся
    f: textfile; // файловая переменная для записи в файл студентов
begin
  // Считаем что юзер УЖЕ открыл файл в редакторе - то есть sf

  // Получаем имя студента
  StudName := Inputbox('Заполнение полей', 'Введите имя студента', '');
  // Получаем группу студента
  Gr := Inputbox('Заполнение полей', 'Введите группу', 'RKT2-21');

  // Вводим его оценки - по одной
  s_o1 := Inputbox('Заполнение полей', 'Введите o1', '5');
  s_o2 := Inputbox('Заполнение полей', 'Введите o2', '5');
  s_o3 := Inputbox('Заполнение полей', 'Введите o3', '5');

  // Сначлалазапишем в результирующего студентоа его номер
  // нам известно сколько уже студентов есть в файле
  // это Memo1.Lines.Count
  // Тогда его номер является это значение + 1
  s := IntToStr(Memo1.Lines.Count+1);
  // если его номер - это однозначное число - то нужно поставить пробел перд ним
  if (length(s) = 1) then
    s:= ' ' + s;

  // Теперь добавляем пробел перед фамилией студента
  s := s + ' ';

  // Добавляем фамилию студента
  s := s + StudName;
  // на фамилию уходит 12 символов + 3 символа(номер и пробел)
  // если длина строки < 15 до добавляем пробелы до тех пор пока она не станет
  // нужной длины
  while( length(s) < 15) do
    s:= s + ' ';

  // Добавляем пробел разделяющий имя и группу
  s := s + ' ';

  // Добавляем группу
  s := s + Gr;

  // На группу выделяется 8 символов, следовательно сейчас длина строки должна быть
  // равной 15 + 1 + 8 = 24
  // добавляем нужные пробелы
  While(length(s) < 24) do
    s := s + ' ';

  // Оценик занимат последние 6 символов(правое выравнивание)
  s := s + ' '+s_o1 +  ' '+s_o2 +  ' '+s_o2;

  // Всё мы получии студента - теперь его можно записывать в конец файла
  // Открываем файл студентов на запись в конец
  AssignFile(f, sf);
  Append(f);

  // Запишем в конец нашего студента
  Writeln(f, s);

  // Не забываем в конце закрыть файл
  CloseFile(f);

  // Теперь просто загрузим изменённый файл в окно реадоктора
  Memo1.Lines.LoadFromFile(sf);

  // Файл уже изменён и сохранён на диск
  Memo1.Modified := False;
end;


end.


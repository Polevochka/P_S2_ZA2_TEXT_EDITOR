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
  // тип для отдельно взятого студена
  Stud = Record
    No       : integer;     // Номер (его ID)
    Name     : string[12];  // Имя
    Gr       : string[8];   // Группа
    o1,o2,o3 : integer;     // Оценки
  end;

  // Тип группы(для первого задания из обработки)
  Group= Record
    Name : string[8];  // Название группы
    Summ : integer;    // Сколько СУММАРНО баллов набрали студенты из ЭТОЙ группы
    Count: integer;    // Количесвто студентов в ЭТОЙ групппе
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

{Удаляем пробелы в строке (в любом месте строки)}
procedure DelSpace(var s: string);
var i_space: integer; // Индекс пробела в строке
begin
  // Находим пробел в строке
  i_space := pos(' ', s);
  // Пока в строке есть пробелы удаляем их ПО одному
  // если pos вернёт 0 то пробела нет
  while i_space <> 0 do
  begin
    delete(s, i_space, 1);
    i_space := pos(' ', s);
  end;

end;

{Средние балы по группам}
procedure TForm1.MenuItem9Click(Sender: TObject);
// Всего групп в списке предполагается не больше 10, если ,наоборот,
// то меняем их число ЗДЕСЬ
var MasGr : array [1..10] of Group; // Массив групп
    NameGr: string;   // Имя группы
    n: integer;       // Число групп в файле
    stud_str: string; // информация о студенте в одной строке
    i: integer;
    i_gr: integer;// Индекс группы в массие групп
    stud_summ: integer; // Сумма оценок ОДНОГО студента
    res: string; // Результат работы для каждой группы

begin

  // Так как мы не начали даже ещё обходить файл, то и число групп в нём
  // по умолчанию равно 0
  n := 0;

  // Обходм строки текстового редактора
  for i:=0 to Memo1.Lines.Count-1 do
  begin
    // получаем одного студента в виде строки
    stud_str := Memo1.Lines[i];

    {Извлекаем название группы}
    // перед названием группы стоят:
    //   Номер строки - 2 символа
    //                  1 пробел
    //   Фамилия        12
    //                  1 пробел
    // ИТОГО : 16 символов
    // ПЕРЫЙ СИМВОЛ ИМЕНИ ГРУППЫ: 17
    // ДЛИНА ИМЕНИ ГРУППЫ: 8 символов
    // Копируем с 17 позиции в строке 8 символов - НАША ГРУППА
    NameGr := copy(stud_str, 17, 8);
    // Удаляем лишние пробелы в строке - чтобы можно было сравнивать имена групп
    DelSpace(NameGr);

    {Получаем сумму оценок ОДНОГО студента}
    // Оценки - это последние 6 символов для удобства укоротим строку студента
    // Оставим только оценки
    // так как оценки имеют вид ' 3 5 2' - правое выравнивание
    // чтобы попасть на перву оценку надо от конца отсчитать 4, попадём на тройку
    // и останется 5 символов '3 5 2'
    stud_str := copy(stud_str, length(stud_str)-4, 5);
    // удаляем пробелы в строке, чтобы получилось '352' - каждая оценка на один символ
    DelSpace(stud_str);
    // Наконец получаем сумму оценок
    stud_summ := StrToInt(stud_str[1]) + StrToInt(stud_str[2]) + StrToInt(stud_str[3]);

    // ищем эту группу c Именем NameGr в нашем массиве
    // Начинаем с начала массива
    i_gr:=1;
    // идём до тех пор пока не найдём группу c таким именем
    // или не выйдем за количество групп в массиве - то есть такая группа
    // нам ещё не попадалась -> увеличиваем число групп в массиве
    while(i_gr <= n) do
    begin
      if (MasGr[i_gr].Name = NameGr) then break; // Выходим из цикла
      i_gr := i_gr + 1;
    end;

    // Мы вышли из цикла -> мы нашли группу с таким же именем
    // или не нашли вообще такой группы

    // если не нашли такой группы (i_gr > n) - добавляем её
    if (i_gr > n) then
    begin
      // i_gr = n + 1 - то есть увеличиваем число групп в массиве
      n:= i_gr;
      // Не забываем что нужно указать имя добавляемой группы
      MasGr[i_gr].Name := NameGr;
      // По умолчанию в группе 0 человек
      MasGr[i_gr].Count := 0;
      // Так же сумма балов
      MasGr[i_gr].Summ := 0;
    end;

    // мы нашли группу изменяем её значение
    // Увеличиваем число студентов в ней
    MasGr[i_gr].Count := MasGr[i_gr].Count + 1;
    // Увеличиваем сумму баллов
    MasGr[i_gr].Summ := MasGr[i_gr].Summ + stud_summ;

  end;

  // Обошли все строки файла и узнали информацию по каждой группе

  // очищаем окно редактора
  Memo1.Clear;

  // Оходим все найденные группы и выводим каждую
  for i_gr:=1 to n do
  begin
    // Создаём строковое представление каждой группы - чтобы вывести их
    res := '';
    // Добавляем Имя Группы
    res := res + MasGr[i_gr].Name;
    // Среднеий бал по группе - это сумма всех оценок делить на их число
    // MasGr[i_gr].Summ - сумма всех оценок
    // MasGr[i_gr].Count*3 - число всех оценок (3 тк у каждого студента 3 оценки)
    // FloatToStrF(float_number, fffixed, 1, 3); 3 в конце - число знаков после запятой
    res := res + ':   ' + FloatToStrF(MasGr[i_gr].Summ / (MasGr[i_gr].Count*3), fffixed, 1, 3);

    // Наконец добавляем данную строку в редактор
    Memo1.Lines.Append(res);
  end;
  // мы выводили кое-что в мемо1, но сам файл не трогали
  Memo1.Modified := False;

end;

{Удалить строку}
procedure TForm1.MenuItem10Click(Sender: TObject);
var OrigNameStud: string; // Фамилия студента
    OrigNameGr: string;   // Название группы ВВОДИММЫЕ ПОЛЬЗОВАТЕЛЕМ(ОРИГИНАЛЬНЫЕ)
    // ВРЕМЕННЫЕ - используемые для считывания из файла
    s: string; // строка студента
    tmpNameStud: string; // имя студента
    tmpNameGr: string;   // название группы
    f: textfile; // файл с ИСХОДНЫМИ студентами
    rab_f: textfile; // рабочий файл, куда будем записывать студентов с обработкой
    name_rab_f: string; // имя рабочего файла
begin
  // Пролучаем название группы и имя студента через inputbox
  OrigNameGr := inputbox('Ввод информации', 'Введите Название группы', 'IU7-21');
  OrigNameStud := inputbox('Ввод информации', 'Введите фамилию студента', 'Sidorov');

  // юзер может ввести данные о студенте с пробелами
  // Лучше будет удалить эти пробелы
  DelSpace(OrigNameGr);
  DelSpace(OrigNameStud);

  // считаем что мы открыли файл и sf(имя файла) не пустая
  AssignFile(f, sf); // связываем файл на диске и файловую переменную
  Reset(f); // открываем его на чтение

  // Делаем имя РАБОЧЕГО файла уникальным, чтобы он не совпадал с другими
  // имя старого файла sf состоит из
  //    * самого имени файла и
  //    * 4 символов - на точку и расширение файла '.txt'
  // сначала просто скопируем имя файла БЕЗ РАСШИРЕНИЯ(и точки)
  name_rab_f := copy(sf, 1, length(sf)-4);
  // Добавим что-нибудь чтобы наш РАБОЧИЙ файл отличался от старого(+ расширение)
  name_rab_f := name_rab_f + '_RAB_.txt';
  // открываем новый(РАБОЧИЙ) файл на ЗАПИСЬ
  AssignFile(rab_f, name_rab_f);
  Rewrite(rab_f);
  // В него будем записывать студентов, у которых {фамилия ИЛИ группа} не совпадают
  // c ОРИГИНАЛЬНЫМИ - действительно ведь нам не нужны студенты у которых такая фамилия
  // и такая группа

  // обходим ИСХОДНЫЙ файл
  while(not EOF(f)) do
  begin
    readln(f, s); // считываем строку студента
    // Извлекаем из строки ФАМИЛИЮ студента
    // под неё выделяется пространство 12 символов начиная с 4-ого
    tmpNameStud := copy(s, 4, 12);
    DelSpace(tmpNameStud); // Фамилия может занимать не польностью 12 символов

    // Извлекаем из строки ГРУППУ студента
    // под неё выделяется 8 символов начиная с 17-го
    tmpNameGr := copy(s, 17, 8);
    DelSpace(tmpNameGr); // Так же как и с фамилией(не все символы из 8 есть фамилия)

    // Данное условие не будет выполняться если
    // ОДНОВРЕМЕННО Фамилия И Группа совпадают с оригиналами
    // действительно ведь может быть студент с такой фамилией, НО с другой группой,
    // а такого студента мы ДОЛЖНЫ записать в файл
    if (OrigNameStud <> tmpNameStud) or (OrigNameGr <> tmpNameGr) then
      writeln(rab_f, s); // записываем такого студента в РАБОЧИЙ файл
  end;

  // после завершения цикла мы собрали РАБОЧИЙ файл БЕЗ студента(ов) из
  // указанной группы и с указанной фамилией пользователем

  // сначала надо закрыть оба файла
  closefile(f); // закрываем исходный
  closefile(rab_f); // закрываем рабочий - уже обработанный файл

  // удаляем СТАРЫЙ(исходный) файл - он нам больше не нужен
  DeleteFile(sf);

  // изменим имя нового(рабочего) файла, на имя СТАРОГО
  RenameFile(name_rab_f, sf);

  // Теперь изменения надо загрузить в мемо
  // sf мы никак не меняли вот и загрузим его используя имя ИСХОДНОГО файла
  // выводим ИЗМЕНЁННЫЙ ИСХОДНЫЙ файл в Memo1
  Memo1.Lines.LoadFromFile(sf);
  Memo1.Modified := False;

end;


end.


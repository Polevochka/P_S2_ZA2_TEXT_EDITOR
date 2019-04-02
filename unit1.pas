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

{Обратить порядок}
procedure TForm1.MenuItem9Click(Sender: TObject);
var f: textfile; // файловая переменная для взаимодействия с ним
    i: integer;
begin

  // Предполагается, что мы уже загрузили файл в окно редактора
  // А значит переменная sf имеет уже какое-то значение
  // связываем переменную f и файл на диске
  AssignFile(f, sf);
  // Очищаем файл
  Rewrite(f);

  // Обходим строки редактора с конца
  for i:= Memo1.Lines.count-1 downto 0 do
  begin
    // И записываем их по одной в наш файл
    // Для этого используем writeLN - чтобы переходить на следующие строчки
    writeln(f, Memo1.Lines[i]);
  end;

// В конце не забываем закрыть файл
CloseFile(f);

// Теперь чтобы увидеть изменения, надо открыть файл через редактор
// Так давайте это и сообщим пользователю
ShowMessage('Файл успешно инвертирован. Чтобы увидеть изменения' + #13 + 'откройте занаво файл: ' + #13 + sf);
end;

// СОБСТВЕННАЯ логическая функция
// match - глагол - соответствовать
{Соответствует ли строка маске}
function match_mask(maska: string; s: string): boolean;
// переменная, куда будем записывать результат - её значение возвращет функция
var res: boolean;
    i_m: integer; // индекс символа в МАСКЕ
    i_s: integer; // индекс символа в СТРОКЕ
    i_star: integer; // Индекс звёздочки в МАСКЕ
    i_s_after: integer; // индекс ПЕРВОГО символа строки = символу маски после *
begin
  i_m := 1;
  i_s := 1;
  i_star := 0;
  i_s_after := 0;
  res:= False; // цикл может иногда отработать и не дать значение переменной
  // Обходим символы маски
  while(i_m <= Length(maska)) do
  begin
    // 1-ый случай символ = '*'
    if (maska[i_m] = '*') then
    begin
      // Запоминнаем где у нас расположена звёздочка в маске
      i_star := i_m;

      // если мы дошли до сюда, то есть всё это время строка была верна маске
      // и * расположена в конце маски то можно завершать цикл, потому что
      // даже если в строке s есть символы, то * их как бы их убирает
      // она обозначает 0 или бесконечно много символов
      // Маска заканчивается * и мы дошли до сюда, то дальше смотреть
      // строку s не нужно, она полность СООТВЕТСВУЕТ МАСКЕ
      if (i_m = Length(maska)) then
      begin
        res := True; // Говорим что строка соответствует маске
        break;       // выходим из цикла
      end;

      // Звёздочка не в конце МАСКИ
      // Тогда нужно узнать какой символ в маске идёт за звёздочкой
      i_m := i_m + 1; // переходим на один символ вперёд в МАСКЕ
      // Дальше перебираем строку s до тех пор пока символы
      // в маске и в строке не совпадут или строка закончится
      while(i_s <= Length(s)) and (s[i_s] <> maska[i_m]) do
        i_s := i_s + 1;

      // мы вышли из цикла, следовательно нашли или не нашли такой символ

      // если строка закончилась, то мы символа не нашли
      // а значит строка s  НЕ СООТВЕТСТВУЕТ маске
      if (i_s > Length(s)) then
      begin
        res:= False;  // строка не по маске
        break;        // выходим из цикла
      end;

      // Сохраняем индекс символа = символу маски
      // вдруг мы нашли не тот символ
      // в строке ещё может быть много символов = символу маски
      // если этот не подойдёт, мы просто занаво будем искать этот символ
      // но поиск уже вести после этого - ПЛОХОГО символа
      // а не с начала строки, ведь мы так опять попадём на этот символ
      i_s_after := i_s;
    end
    else
    // если мы здесь то символ маски не равен '*'
    // 2-ой случай
    begin
      // Тогда символы маски должны быть равными символам в строке
      // Если это так, то
      if(maska[i_m] = s[i_s]) then
      begin
        // Проверяем вдруг мы дошли до конца строки
        // и до конца маски
        // значит СТРОКА ПОЛНОСТЬЮ соответствует МАСКЕ
        if (i_s = Length(s)) and (i_m = Length(maska)) then
        begin
          res := True; // говорим, что соответствует
          break;       // и выходим из цикла перебора символов маски
        end;

        // если мы не дошли до конца маски и строки
        // то переходим к следующим символам в этих строках
        i_s := i_s + 1;
        i_m := i_m + 1;



        if (i_m > Length(maska)) and (i_s <= Length(s)) and (i_star <> 0) then
        begin
          // возвращаемся к звёздочке в маске
          i_m := i_star;
          // индекс в маске ставим после ЛОЖНО найденного символа
          i_s:= i_s_after + 1;
          // Дальше опять возвращаемся в БОЛЬШОЙ цикл перебора символов маски
        end;

        // после этого опять начинается БОЛЬШОЙ цикл while
        // перебора символов маски
      end
      else
      begin
        // Здесь символы маски и строки не равны,и причом символ маски не равен '*'
        // Поэтому возможны два варианта
        // 1-ый : строка не соответствует маске
        // 2-ой : при передыдущем переборе звёздочки, когда мы пропускали символы
        //        мы не до конца проверели строку, вдруг там есть ЕЩЁ ОДИН СИМВОЛ,
        //        стоящий * в маске

        // Сначала проверим второй вариант
        // то есть до этого была звёздочка
        if (i_star <> 0) then
        begin
          // возвращаемся к звёздочке в маске
          i_m := i_star;
          // индекс в маске ставим после ЛОЖНО найденного символа
          i_s:= i_s_after + 1;
          // Дальше опять возвращаемся в БОЛЬШОЙ цикл перебора символов маски
        end
        else
        // Если звёздочки не было, то строка НЕ СООТВЕТствует маске
        begin
          res:= False;   // Говорим, что не соответствует
          break;         // выходим из цикла - дальше проверять не имеет смысла
        end;

      end;

    end;

  end;

  // то что возвращает функция
  match_mask := res;
end;

{удаляем пробелы в конце строки}
// В фамили студента в конце могут быть пробелы
// var s - так как меняем строку s
Procedure DelSpace(var s: string);
var st: string;
    i: integer;
begin
  // Будем делать просто собирать новую строку
  st := '';
  // Перебирая символы старой
  for i:=1 to length(s) do
    // Исключая символы пробела
    if (s[i] <> ' ') then
    begin
      st := st + s[i]
    end;

  // st - строка без пробелов в конце
  s := st;
end;

{Выбор по маске}
procedure TForm1.MenuItem10Click(Sender: TObject);
var MaskNameStud: string; // Маска фамилии студента
    NameStud: string;  // Фамилия стдента в файле
    str_stud: string; // строка с информацией о студенте
    f: textfile;
begin
  // Предполагаем, что мы уже открыли в редакторе файл
  // то есть sf - известно

  // открываем файл с записями о студентах
  AssignFile(f, sf);
  Reset(f);

  // Получаем маску фамилии
  MaskNameStud := inputbox('Ввод маски', 'Можно использовать "*"', '');

  // Очищаем Memo1 для записи туда строк
  Memo1.clear;

  // Считываем записи из файла до его конца
  while(not EOF(f)) do
  begin
    // Считали одного студента
    readln(f, str_stud);

    // Фамилия студента расположена с 4 символа в строке
    // и занимает 12 символов
    NameStud := copy(str_stud, 4, 12);
    // Удаляем лишние пробелы если они есть в фамилии студента
    DelSpace(NameStud);

    // если фамилиия студнта соответствует маске то выводим его в мемо
    if match_mask(MaskNameStud, NameStud) then
        Memo1.Lines.Append(str_stud);
  end;

  // Мы изменили мемо но сам файл не меняли
  Memo1.Modified := False;

// В конце всегда закрываем файл
closeFile(f);

end;


end.


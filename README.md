# Лабораторная работа №1
## Начало работы с MySQL и MySQL Workbench

### Цель работы

Познакомиться с MySQL Workbench, научиться создавать базу данных и таблицы, добавлять и изменять данные, а также делать связь между таблицами.

Для работы использовались MySQL Server, MySQL Workbench и Docker.

---

## Задание 1

В MySQL Workbench есть несколько основных разделов.

### Management

- **Server Status** — показывает информацию о сервере.
- **Client Connections** — показывает активные подключения.
- **Users and Privileges** — работа с пользователями и их правами.
- **Status and System Variables** — параметры работы MySQL.
- **Data Export** — экспорт данных.
- **Data Import/Restore** — импорт и восстановление данных.

### Instance

- **Startup / Shutdown** — запуск и остановка сервера.
- **Server Logs** — просмотр логов.
- **Options File** — настройки MySQL.

### Performance

- **Dashboard** — информация о нагрузке.
- **Performance Reports** — отчёты о работе сервера.
- **Performance Schema Setup** — настройка сбора информации о производительности.

Для проверки работы сервера был выполнен запрос:

```sql
SHOW DATABASES;
```

![Проверка работы MySQL](img/01_show_databases.png)

---

## Задание 2

Была создана база данных `simpledb`.

Параметры:

- Character Set — `utf8`
- Collation — `utf8_general_ci`

![Создание simpledb](img/02_simpledb_settings.png)

---

## Задание 3

Была создана таблица `users` с полями `id`, `name` и `email`.

![Таблица users](img/03_users_structure.png)

Запрос создания таблицы:

```sql
CREATE TABLE `simpledb`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
);
```

![SQL создания таблицы](img/04_create_users_sql.png)

---

## Задание 4

В таблицу были добавлены три записи.

```sql
INSERT INTO `simpledb`.`users` (`name`, `email`)
VALUES ('Anna', 'anna@mail.ru');

INSERT INTO `simpledb`.`users` (`name`, `email`)
VALUES ('Ivan', 'ivan@mail.ru');

INSERT INTO `simpledb`.`users` (`name`, `email`)
VALUES ('Maria', 'maria@mail.ru');
```

![Добавление записей](img/05_insert_users_sql.png)

После этого был изменён email у Anna.

```sql
UPDATE `simpledb`.`users`
SET `email` = 'anna.petrov@mail.ru'
WHERE (`id` = '1');
```

![Изменение записи](img/06_update_user_sql.png)

---

## Задание 5

В таблицу `users` были добавлены дополнительные поля:

- `gender`
- `bday`
- `postal_code`
- `rating`
- `created`

Поле `created` имеет тип `TIMESTAMP` и автоматически получает текущие дату и время.

Поля `gender`, `bday`, `postal_code` и `rating` можно оставить пустыми, потому что пользователь может не указывать эту информацию.

```sql
ALTER TABLE `simpledb`.`users`
ADD COLUMN `gender` ENUM('M', 'F') NULL AFTER `email`,
ADD COLUMN `bday` DATE NULL AFTER `gender`,
ADD COLUMN `postal_code` VARCHAR(10) NULL AFTER `bday`,
ADD COLUMN `rating` FLOAT NULL AFTER `postal_code`,
ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() AFTER `rating`;
```

![Изменение структуры users](img/07_alter_users_sql.png)

---

## Задание 6

Были добавлены новые пользователи.

```sql
INSERT INTO `simpledb`.`users`
(`name`, `email`, `postal_code`, `gender`, `bday`, `rating`)
VALUES
('Ekaterina', 'ekaterina.petrova@outlook.com', '145789', 'F', '2000-02-11', '1.123');

INSERT INTO `simpledb`.`users`
(`name`, `email`, `postal_code`, `gender`, `bday`, `rating`)
VALUES
('Paul', 'paul@superpochta.ru', '123789', 'M', '1998-08-12', '1');
```

После этого данные были проверены:

```sql
SELECT * FROM simpledb.users;
```

![Данные users](img/08_users_result.png)

---

## Задание 7

Таблица `users` была экспортирована в SQL-файл.

![Экспорт users](img/09_users_export.png)

В полученном файле используются запросы `INSERT INTO`, которые добавляют записи в таблицу.

---

## Задание 8

Была создана таблица `resume`.

Поля таблицы:

- `resumeid`
- `userid`
- `title`
- `skills`
- `created`

Также был создан внешний ключ между `resume.userid` и `users.id`.

```sql
CREATE TABLE `simpledb`.`resume` (
  `resumeid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `skills` TEXT NULL,
  `created` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`resumeid`),
  INDEX `fk_resume_users_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_resume_users`
    FOREIGN KEY (`userid`)
    REFERENCES `simpledb`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
```

![Создание resume](img/10_create_resume_sql.png)

---

## Задание 9

В таблицу `resume` были добавлены несколько записей.

![Добавление резюме](img/11_insert_resume_sql.png)

У одного пользователя может быть 0 или несколько резюме.

После этого была сделана попытка добавить резюме с `userid = 999`.

```sql
INSERT INTO simpledb.resume
(userid, title, skills)
VALUES
(999, 'Test Resume', 'SQL');
```

Запрос завершился ошибкой, потому что пользователя с таким id нет в таблице `users`.

![Ошибка внешнего ключа](img/12_foreign_key_error.png)

Таблица `resume` также была экспортирована в SQL-файл.

![Экспорт resume](img/13_resume_export.png)

---

## Задание 10

Сначала был изменён id пользователя с `5` на `50`.

```sql
UPDATE `simpledb`.`users`
SET `id` = '50'
WHERE (`id` = '5');
```

![Изменение id](img/14_update_cascade_sql.png)

После этого `userid` в связанной записи таблицы `resume` тоже изменился на `50`.

![ON UPDATE CASCADE](img/15_update_cascade_result.png)

Затем был удалён пользователь с `id = 1`. После удаления связанные с ним резюме тоже удалились автоматически.

![ON DELETE CASCADE](img/16_delete_cascade_result.png)

---

## Вывод

В ходе лабораторной работы я научилась создавать базы данных и таблицы в MySQL Workbench, добавлять и изменять данные, выполнять SQL-запросы и экспортировать данные. Также я создала связь между двумя таблицами и проверила работу `ON UPDATE CASCADE` и `ON DELETE CASCADE`.

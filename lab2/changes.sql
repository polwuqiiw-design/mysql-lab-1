-- Дополнения к исходной модели task2_model.sql.
-- Выполнять только ОДИН РАЗ на новой схеме, созданной из исходного экспорта.
-- На текущей учебной базе поля уже добавлены: повторный запуск даст ошибку Duplicate column.
USE online_store;
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
ALTER TABLE shops ADD COLUMN working_hours VARCHAR(50);
ALTER TABLE products ADD COLUMN stock INT DEFAULT 0;
ALTER TABLE orders ADD COLUMN status VARCHAR(30) DEFAULT 'Новый';
ALTER TABLE deliveries ADD COLUMN delivery_method VARCHAR(50);
ALTER TABLE product_type ADD COLUMN description VARCHAR(255);
ALTER TABLE settings ADD COLUMN description VARCHAR(255);

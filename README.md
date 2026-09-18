# README

- Страница рецепта с описанием, временем приготовления, ингредиентами и шагами.
- Админ-панель: создание и удаление рецептов.
- Хранение ингредиентов отдельно от рецептов с указанием количества.
- Начальные данные: категории и готовая подборка рецептов.

## Стек

- Ruby 3.4
- Rails 8.1
- SQLite
- Puma

## Быстрый старт

### Требования

- Ruby версии из файла `.ruby-version`.
- Bundler.
- SQLite 3.

### Установка и запуск

```bash
git clone https://github.com/Piggerss/travel_aggregator.git
cd travel_aggregator
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

После запуска откройте [http://127.0.0.1:3000](http://127.0.0.1:3000).

`bin/rails db:prepare` создаёт базу и применяет миграции. Команда `bin/rails db:seed` добавляет категории и демонстрационные рецепты; её можно запускать повторно.

## Админ-панель

Админ-панель доступна по адресу [http://127.0.0.1:3000/admin/recipes](http://127.0.0.1:3000/admin/recipes).

Для локальной разработки используются учётные данные по умолчанию:

```text
Логин: admin
Пароль: admin
```

В другом окружении задайте собственные значения перед запуском:

```bash
export ADMIN_LOGIN="your-login"
export ADMIN_PASSWORD="your-password"
bin/dev
```

В PowerShell:

```powershell
$env:ADMIN_LOGIN = "your-login"
$env:ADMIN_PASSWORD = "your-password"
bin/dev
```

При добавлении рецепта ингредиенты вводятся по одному на строку в формате:

```text
Творог — 500 г
Яйцо — 2 шт.
Мука — 100 г
```

## Изображения

Демонстрационные изображения находятся в `public/images/recipes/` и доступны по путям вида `/images/recipes/vegetable-soup.png`.

Поле «Ссылка на фото» в админке хранит URL: внешняя картинка загружается браузером посетителя, а файл на сервер не скачивается.

## Полезные команды

```bash
# Запуск сервера
bin/dev

# Статус миграций
bin/rails db:migrate:status

# Запуск тестов
bin/rails test

# Проверка качества кода
bin/rubocop

# Проверка безопасности зависимостей
bin/bundler-audit check --update
```

## Маршруты

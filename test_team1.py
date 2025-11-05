# test_team1.py - скрипт для тестирования окружения первой команды
import numpy as np
import sklearn
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score
import dash
from dash import html

print("=" * 50)
print("Тестирование окружения первой команды")
print("=" * 50)

# Проверка версий
print(f"Python version: {np.__version__}")
print(f"NumPy version: {np.__version__}")
print(f"scikit-learn version: {sklearn.__version__}")
print(f"Dash version: {dash.__version__}")

# Пример из документации scikit-learn
print("\nЗапуск примера из документации scikit-learn...")

# Загрузка датасета
diabetes = datasets.load_diabetes()
X = diabetes.data[:, np.newaxis, 2]
y = diabetes.target

# Разделение данных на тренировочные и тестовые
X_train = X[:-20]
X_test = X[-20:]
y_train = y[:-20]
y_test = y[-20:]

# Создание линейной регрессии
regr = linear_model.LinearRegression()
regr.fit(X_train, y_train)
y_pred = regr.predict(X_test)

# Вывод результатов
print(f"Коэффициенты: {regr.coef_}")
print(f"Среднеквадратичная ошибка: {mean_squared_error(y_test, y_pred):.2f}")
print(f"Коэффициент детерминации R^2: {r2_score(y_test, y_pred):.2f}")

# Тестирование Dash (простая проверка что модуль импортируется)
print("\nТестирование импорта Dash компонентов...")
print(f"HTML компоненты импортированы успешно: {html.Div is not None}")

print("\n✅ Окружение первой команды работает корректно!")
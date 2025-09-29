
# 📅 Apple Calendar Premium (Flutter)

Este proyecto es una réplica de un calendario semanal estilo **Apple Calendar**, hecho con **Flutter**.  
La aplicación permite visualizar eventos por día y hora, mostrando un diseño moderno con animaciones y colores personalizados.

---

## 🚀 Características

- 📌 Vista semanal de actividades.  
- 🎨 Estilo visual similar al calendario de iOS.  
- 📂 Eventos organizados por categorías (clases, examen, almuerzo, tareas, etc.).  
- 🖼️ Cada evento tiene su **emoji**, color y título.  
- ✨ Animaciones suaves en la carga de eventos y en la barra lateral.  
- 📑 Al tocar un evento se abre un **diálogo con detalles** (nombre, hora y calendario al que pertenece).  

---

## 🛠️ Tecnologías usadas

- **Flutter** (framework principal).  
- **Material Design + Cupertino Widgets** para el estilo.  
- **Dart** como lenguaje de programación.  

---

## 📂 Estructura principal del código

- `MyApp`: Widget principal que configura el tema.  
- `CalendarApp`: Contiene la vista del calendario y maneja los estados.  
- `CalendarData`: Clase para manejar la información de cada calendario (emoji, color, visibilidad).  
- `Event`: Clase que define cada evento (hora, título, emoji, etc.).  
- `_showEventDetails`: Muestra un diálogo con más información del evento seleccionado.  
- `getEventsForDayAndHour`: Retorna los eventos de un día y hora específicos.  

---

## 📅 Ejemplo de eventos

- 🚌 Autobús a las 8:00  
- 📚 Clases a las 9:00  
- 🎯 Examen a las 11:00  
- 🍔 Almuerzo con amigos a las 12:00  
- 👨‍👩‍👧‍👦 Tiempo con la familia a las 19:00  

---

## ▶️ Ejecución

1. Clonar este repositorio o copiar los archivos.  
2. Tener instalado **Flutter SDK** y un emulador o dispositivo físico.  
3. Ejecutar en consola:

```bash
flutter pub get
flutter run
````

---

## 📌 Notas

* El calendario está **pre-cargado** con eventos de ejemplo.
* Los eventos se pueden visualizar por día y por hora.
* El diseño está inspirado en el calendario de Apple, pero **hecho totalmente en Flutter**.

---



¿Quieres que te lo arme también en **formato PDF** bonito (con títulos, tablas y colores) para que lo presentes directamente como tarea?
```

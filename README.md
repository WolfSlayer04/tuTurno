# Tu Turno

Aplicación móvil Flutter de **filas virtuales** para restaurantes en **Mérida, Yucatán**.

> **Eslogan:** Tu tiempo vale más que esperar.

Tu Turno no es una app de reservaciones tradicionales: el usuario se incorpora a una fila existente, consulta su posición y tiempo estimado, y aprovecha el tiempo mientras llega su turno.

---

## Características

- Bienvenida, login y registro (demo: cualquier correo/contraseña)
- Inicio con restaurantes cercanos, categorías y menor tiempo de espera
- **Explorar con mapa** (OpenStreetMap) + 60 restaurantes reales de Mérida
- Detalle de restaurante, promociones y unirse a la fila
- Confirmación de turno con selector de personas
- **Mi turno** con posición, estimado dinámico y progreso de fila
- Mapa de ruta a pie (OSRM) con pasos y apertura en Google Maps
- Notificaciones, promociones, perfil e historial de turnos
- Datos dinámicos: tiempos de espera y avance de fila simulados en vivo

---

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) 3.35+ (Dart 3.9+)
- Android Studio / VS Code / Cursor
- Emulador Android, dispositivo físico, Chrome o Windows

```bash
flutter doctor
```

---

## Cómo ejecutar

```bash
git clone https://github.com/WolfSlayer04/tuTurno.git
cd tuTurno
flutter pub get
flutter run
```

Dispositivos útiles:

```bash
flutter run -d chrome      # Web
flutter run -d windows     # Desktop
flutter run                # Emulador / teléfono conectado
```

### Login demo

Cualquier correo y contraseña permiten entrar. El nombre del perfil se arma a partir del correo.

---

## Flujo principal

```
Bienvenida → Registro / Login → Inicio
  → Detalle del restaurante → Confirmar turno → Mi turno
```

Navegación inferior:

| Tab | Contenido |
|-----|-----------|
| **Inicio** | Saludo, búsqueda, categorías, cerca de ti, menor espera |
| **Explorar** | Mapa con todos los restaurantes, filtros por zona, lista y ruta |
| **Mi turno** | Turno activo, progreso, cómo llegar, cancelar |
| **Perfil** | Actividad, historial, configuración, cerrar sesión |

---

## Pantallas

1. **Bienvenida / Splash** — marca, eslogan y CTA
2. **Login / Registro** — autenticación demo
3. **Inicio** — explorar restaurantes cercanos
4. **Detalle** — disponibilidad, promos, unirse a la fila, mapa
5. **Confirmar turno** — personas + confirmación
6. **Mi turno** — posición, estimado dinámico, cancelar
7. **Notificaciones** — turnos y promociones
8. **Promociones** — ofertas de restaurantes
9. **Perfil** — actividad y ajustes
10. **Historial** — atendidos / cancelados / no presentados
11. **Mapa de ruta** — camino a pie con instrucciones
12. **Explorar mapa** — todos los locales en Mérida

---

## Identidad visual

| Token | Valor |
|-------|--------|
| Azul petróleo | `#123B50` |
| Turquesa | `#19B5A5` |
| Verde menta | `#D9F5ED` |
| Fondo | `#F4F6F8` / `#F2F6F8` |
| Alerta | `#FF9F43` |
| Tipografía | Inter (cuerpo) · Poppins (títulos) |

UI redondeada, sombras suaves y componentes reutilizables.

---

## Datos y mapa

- **60 restaurantes reales** repartidos en Centro, Montejo, Altabrisa, García Ginerés, Norte y Sur
- Coordenadas GPS, distancia desde Plaza Grande, horarios y descripciones
- Catálogo generado en `lib/data/restaurants_catalog.dart`
- Script regenerable: `python tools/gen_restaurants.py`
- Mapas: **flutter_map** + OpenStreetMap
- Rutas a pie: API pública **OSRM**
- Origen demo del usuario: Plaza Grande (`20.9671, -89.6237`)

### Colores de marcadores (Explorar)

| Color | Significado |
|-------|-------------|
| Turquesa | ≤ 15 min de espera |
| Naranja | ≤ 30 min |
| Rojo | > 30 min |

---

## Estructura del proyecto

```
lib/
  main.dart                 # Entrada + Provider
  theme/                    # Colores, tipografía, radios, sombras
  models/                   # Restaurant, Turn, Promotion, Notification
  data/                     # MockData + catálogo de 60 restaurantes
  state/app_state.dart      # Estado global y simulación dinámica
  services/route_service.dart
  widgets/                  # Botones, cards, badges, bottom nav...
  screens/                  # Todas las pantallas
tools/
  gen_restaurants.py        # Genera el catálogo
```

---

## Dependencias principales

| Paquete | Uso |
|---------|-----|
| `provider` | Estado global |
| `google_fonts` | Inter / Poppins |
| `flutter_map` + `latlong2` | Mapas |
| `http` | Rutas OSRM |
| `url_launcher` | Abrir Google Maps |

---

## Estados de un turno

1. Esperando  
2. Próximo  
3. Llamado  
4. Atendido  
5. Cancelado  
6. No presentado  

En **Mi turno** hay chips demo para simular cambios de estado. La fila también avanza sola cada pocos segundos.

---

## Notas técnicas

- Proyecto Android + iOS (`com.tuturno.tu_turno`)
- Internet requerido para tiles del mapa, rutas e imágenes
- Sin backend: datos y filas son dinámicos en memoria (demo)
- Pensado como prototipo comercial listo para evolucionar a API real

---

## Comandos útiles

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Regenerar catálogo de restaurantes:

```bash
python tools/gen_restaurants.py
```

---

## Autor / repo

- Repositorio: [https://github.com/WolfSlayer04/tuTurno](https://github.com/WolfSlayer04/tuTurno)
- Producto: **Tu Turno** — filas virtuales para restaurantes en Mérida, Yucatán

---

## Licencia

Proyecto académico / demo. Úsalo y adáptalo libremente para aprendizaje o portafolio.

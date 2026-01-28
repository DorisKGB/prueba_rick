# Rick & Morty Character Explorer

Aplicación Flutter que permite explorar y buscar personajes de la serie Rick & Morty utilizando la [Rick and Morty API](https://rickandmortyapi.com/).

## Tabla de Contenidos

- [Cómo Ejecutar la Aplicación](#cómo-ejecutar-la-aplicación)
- [Estructura del Código](#estructura-del-código)
- [Implementación de Cancelación de Requests](#implementación-de-cancelación-de-requests)
- [Supuestos y Decisiones de Diseño](#supuestos-y-decisiones-de-diseño)
- [Características](#características)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)

---

## Cómo Ejecutar la Aplicación

### Prerrequisitos

- Flutter SDK 3.10.4 o superior
- Dart SDK 3.10.4 o superior
- Un IDE (VS Code, Android Studio, IntelliJ IDEA)
- Emulador o dispositivo físico

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/DorisKGB/prueba_rick.git
   cd prueba_rick
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   
   La aplicación está configurada para ejecutarse con VS Code usando el archivo `.vscode/launch.json`:
   
   - Abre el proyecto en VS Code
   - Selecciona el dispositivo/emulador deseado
   - Presiona `F5` o ve a `Run > Start Debugging`   

4. **Ejecutar pruebas unitarias**
   ```bash
   flutter test
   ```

---

## Estructura del Código

La aplicación sigue los principios de **Clean Architecture** con una separación clara de responsabilidades en capas:

```
lib/
├── application/          # Capa de Aplicación (Lógica de Negocio)
│   ├── base/            # Clases base abstractas
│   ├── manager/         # Managers que orquestan casos de uso
│   ├── repository/      # Interfaces de repositorios
│   ├── use_cases/       # Casos de uso específicos
│   └── utils/           # Utilidades (Debouncer)
│
├── core/                # Capa de Dominio
│   ├── entities/        # Entidades del dominio (ECharacter, EPage)
│   ├── enum/            # Enumeraciones (Status, Gender)
│   └── utils/           # Utilidades del dominio
│
├── infraestructure/     # Capa de Infraestructura
│   ├── local/           # Fuentes de datos locales
│   └── remote/          # Fuentes de datos remotas (API)
│       ├── api/         # Cliente HTTP (Dio)
│       └── mappers/     # Transformadores de datos
│
└── presentation/        # Capa de Presentación
    ├── bloc_application/ # BLoC de aplicación
    ├── pages/           # Páginas y widgets
    │   └── home/
    │       ├── bloc/    # BLoC específico de Home
    │       └── widget/  # Widgets reutilizables
    ├── router/          # Configuración de rutas (GoRouter)
    └── utils/           # Utilidades de UI (theme, extensions)
```

### Flujo de Datos

```
UI (View) → BLoC → Manager → Use Case → Repository → API
                ↓
            RxDart Streams
                ↓
            UI actualizada
```

### Componentes Clave

#### 1. **BLoC (Business Logic Component)**
- Utiliza `BlocBase` de la librería `bpstate`
- Maneja el estado con `RxDart` (`BehaviorSubject`)
- Ejemplo: `BHome` gestiona el estado de la página principal

#### 2. **Manager**
- Orquesta múltiples casos de uso
- Ejemplo: `MCharacter` coordina búsqueda y obtención de personajes

#### 3. **Use Cases**
- Implementan lógica de negocio específica
- Ejemplos:
  - `UCSearchCharacter`: Búsqueda con debounce
  - `UCGetCharacters`: Obtención inicial
  - `UCGetCharactersPage`: Paginación

#### 4. **Repository**
- Abstracción de fuentes de datos
- `RCharacterImp` implementa llamadas a la API

---

## Implementación de Cancelación de Requests

La aplicación implementa **cancelación automática de requests** mediante un patrón de **Debouncer** personalizado:

### Clase Debouncer

```dart
class Debouncer<T> {
  final Duration duration;
  Timer? _timer;
  Completer<T>? _completer;

  Future<T> run(Future<T> Function() action, {Duration? duration}) {
    _timer?.cancel();  // ⚡ Cancela el timer anterior
    
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<T>();
    }

    _timer = Timer(duration ?? this.duration, () async {
      final result = await action();
      if (!_completer!.isCompleted) {
        _completer!.complete(result);
      }
    });

    return _completer!.future;
  }
}
```

### Cómo Funciona

1. **Cancelación de Timer**: Cuando el usuario escribe en el campo de búsqueda, cada nueva entrada cancela el timer anterior mediante `_timer?.cancel()`

2. **Delay de 500ms**: Solo se ejecuta la búsqueda si el usuario deja de escribir por 500ms

3. **Prevención de Requests Duplicados**: Si un request está en progreso y llega uno nuevo, el timer se cancela y se reinicia

### Uso en UCSearchCharacter

```dart
class UCSearchCharacter extends UseCase<ECharacter, EPage<ECharacter>> {
  final Debouncer<EPage<ECharacter>> _debouncer = 
      Debouncer(duration: const Duration(milliseconds: 500));

  @override
  Future<EPage<ECharacter>> execute(ECharacter param) async {
    return _debouncer.run(
      () => _rlCharacter.searchCharacter(param), 
      duration: Duration(milliseconds: 500)
    );
  }
}
```

### Beneficios

- **Reduce carga del servidor**: Evita requests innecesarios
- **Mejora rendimiento**: Menos procesamiento de datos
- **Mejor UX**: Respuesta más fluida sin lag
- **Ahorro de recursos**: Menos consumo de red y batería

---

## Supuestos y Decisiones de Diseño

### Supuestos

1. **Conectividad**: La app asume conexión a internet activa
2. **API Disponible**: Se asume que la Rick and Morty API está operativa
3. **Datos Válidos**: La API retorna datos en el formato esperado
4. **Límite de Paginación**: Se respeta el límite de la API (20 items por página)

### Decisiones de Diseño

#### 1. **Arquitectura Clean**
- **Razón**: Separación de responsabilidades, testabilidad, mantenibilidad
- **Tradeoff**: Mayor complejidad inicial vs escalabilidad a largo plazo

#### 2. **BLoC con RxDart**
- **Razón**: Gestión de estado reactiva y predecible
- **Tradeoff**: Curva de aprendizaje vs control total del flujo de datos

#### 3. **Debouncer Personalizado**
- **Razón**: Control fino sobre cancelación de requests
- **Tradeoff**: Implementación custom vs usar librerías de terceros (más control, menos dependencias)

#### 4. **Dio para HTTP**
- **Razón**: Interceptors, manejo de errores robusto, cancelación de requests
- **Tradeoff**: Librería más pesada vs más funcionalidades

#### 5. **GoRouter para Navegación**
- **Razón**: Navegación declarativa, deep linking, type-safe
- **Tradeoff**: Configuración inicial vs flexibilidad

#### 6. **Paginación Infinita**
- **Razón**: Mejor UX para grandes listas
- **Tradeoff**: Mayor complejidad en gestión de estado vs mejor experiencia

#### 7. **Diseño Material Personalizado**
- **Razón**: Identidad visual profesional y moderna
- **Tradeoff**: Más tiempo de desarrollo vs mejor impresión visual

#### 8. **Sin Caché Local**
- **Razón**: Datos siempre actualizados desde la API
- **Tradeoff**: Requiere conexión vs datos offline

### Optimizaciones Implementadas

- **Debounce en búsqueda**: 500ms de delay
- **Lazy loading**: Carga de más personajes al hacer scroll
- **Error handling**: Manejo robusto de errores de red
- **Loading states**: Indicadores visuales claros
- **Pull to refresh**: Actualización manual de datos

---

## Características

- **Búsqueda en tiempo real** con debounce
- **Filtros múltiples**: Status, Gender, Species, Type
- **Scroll infinito** con paginación
- **Pull to refresh**
- **Diseño responsive** y moderno
- **UI profesional** con badges de estado
- **Optimización de requests** con cancelación automática
- **Pruebas unitarias** completas

---

## Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Flutter | 3.10.4+ | Framework UI |
| Dart | 3.10.4+ | Lenguaje |
| bpstate | latest | BLoC pattern |
| RxDart | 0.28.0 | Programación reactiva |
| Dio | 5.7.0 | Cliente HTTP |
| GoRouter | 14.6.3 | Navegación |
| Mocktail | 1.0.4 | Testing (mocks) |

---

## Notas Adicionales

### Testing

La aplicación incluye pruebas unitarias para:
- Managers (`MCharacter`)
- Use Cases (`UCSearchCharacter`, `UCGetCharacters`)
- Repositories (`RCharacterImp`)

### API Utilizada

- **Base URL**: `https://rickandmortyapi.com/api`
- **Endpoints**:
  - `GET /character` - Lista de personajes
  - `GET /character?name=...&status=...` - Búsqueda con filtros

### Mejoras Futuras

- Modo offline
- Favoritos
- Compartir personajes
- Soporte multi-idioma

# Aplicación Flutter: Harry Potter (Patrón MVC)

## Introducción

Esta aplicación Flutter es un proyecto educativo que implementa una arquitectura **Modelo-Vista-Controlador (MVC)** para consumir la API gratuita de Harry Potter disponible en [HP API](https://hp-api.onrender.com/). La aplicación permite al usuario explorar personajes, estudiantes, staff, hechizos y detalles de cada uno, con una interfaz de usuario limpia y organizada.

---

## Estructura del Proyecto

El proyecto sigue la arquitectura **MVC** con las siguientes carpetas principales:
```
lib/
├── main.dart
├── models/        # Define las clases modelo, como `Character` y `Spell`
├── views/         # Incluye todas las pantallas, como login, home y detalles
├── controllers/   # Gestiona la lógica de negocio y el estado
├── services/      # Realiza las llamadas a la API
└── routes/        # Define las rutas de navegación centralizadas
```

**Ejemplo de carpetas:**
```text
lib/
├── models/
│   ├── character.dart
│   └── spell.dart
├── views/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── characters/
│       ├── all_characters_screen.dart
│       └── character_detail_screen.dart
├── controllers/
│   ├── character_controller.dart
│   └── spell_controller.dart
├── services/
│   └── harry_potter_api_service.dart
└── routes/
    └── routes.dart
```

---

## Puntos Relevantes del Proyecto

### 1. **Pantalla de Inicio (Splash Screen)**

La pantalla de inicio utiliza una animación sencilla y navega automáticamente al login después de unos segundos.

```dart name=lib/views/splash_screen.dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Navegar al login después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/6/6e/Harry_Potter_wordmark.svg',
              height: 150,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Captura del Código:**
![Splash Screen](assets/screenshots/splash_screen.png)

---

### 2. **Pantalla de Login**

La pantalla de login utiliza un formulario para validar un usuario y contraseña ficticia. Si la autenticación es exitosa, redirige al usuario a la pantalla principal.

```dart name=lib/views/login_screen.dart
ElevatedButton(
  onPressed: authController.isLoading
      ? null
      : () async {
          if (_formKey.currentState!.validate()) {
            final success = await authController.login(
              _usernameController.text,
              _passwordController.text,
            );
            if (success) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          }
        },
  child: authController.isLoading
      ? CircularProgressIndicator()
      : Text('INICIAR SESIÓN'),
),
```

**Captura del Código:**
![Login Screen](assets/screenshots/login_screen.png)

---

### 3. **Pantalla Principal (Home)**

La pantalla principal muestra diferentes opciones para explorar personajes, estudiantes, staff, casas y hechizos.

```dart name=lib/views/home_screen.dart
Expanded(
  child: GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    children: [
      _buildCategoryCard(context, 'Todos los personajes', Icons.people, AppRoutes.allCharacters),
      _buildCategoryCard(context, 'Estudiantes', Icons.school, AppRoutes.students),
      _buildCategoryCard(context, 'Staff', Icons.work, AppRoutes.staff),
      _buildCategoryCard(context, 'Casas', Icons.home, AppRoutes.houseCharacters),
      _buildCategoryCard(context, 'Hechizos', Icons.auto_fix_high, AppRoutes.spells),
    ],
  ),
),
```

**Captura del Código:**
![Home Screen](assets/screenshots/home_screen.png)

---

### 4. **Consumo de la API**

El archivo `harry_potter_api_service.dart` contiene todas las peticiones HTTP como obtener personajes o hechizos.

```dart name=lib/services/harry_potter_api_service.dart
Future<List<Character>> getAllCharacters() async {
  final response = await http.get(Uri.parse('$baseUrl/characters'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Character.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load characters');
  }
}
```

**Captura del Código:**
![API Service](assets/screenshots/api_service.png)

---

### 5. **Controlador de Personajes**

El controlador de personajes maneja la lógica de negocio y el estado de los personajes.

```dart name=lib/controllers/character_controller.dart
class CharacterController extends ChangeNotifier {
  final HarryPotterApiService _apiService = HarryPotterApiService();
  List<Character> _characters = [];
  bool _isLoading = false;

  Future<void> fetchAllCharacters() async {
    _isLoading = true;
    notifyListeners();
    try {
      _characters = await _apiService.getAllCharacters();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Captura del Código:**
![Character Controller](assets/screenshots/character_controller.png)

---

### 6. **Pantalla de Personajes**

La pantalla de personajes utiliza un `ListView` para mostrar personajes obtenidos de la API.

```dart name=lib/views/characters/all_characters_screen.dart
ListView.builder(
  itemCount: controller.characters.length,
  itemBuilder: (context, index) {
    final character = controller.characters[index];
    return ListTile(
      title: Text(character.name),
      subtitle: Text(character.house),
      leading: Image.network(character.image, fit: BoxFit.cover),
    );
  },
),
```

**Captura del Código:**
![All Characters Screen](assets/screenshots/all_characters_screen.png)

---

## Configuración e Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/harry_potter_app.git
   cd harry_potter_app
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

---

## Conclusión

Este proyecto ejemplifica cómo implementar una arquitectura **MVC** en Flutter y consumir una API externa. Los principales aprendizajes incluyen:

- Separar la lógica de negocio (controladores) de la interfaz de usuario (vistas).
- Gestionar el estado de manera eficiente con `Provider`.
- Manejar errores y mostrar mensajes significativos al usuario.

**Posibles mejoras futuras:**

- Integrar una base de datos local para poner en caché los datos.
- Implementar más funcionalidades como búsquedas avanzadas.
- Mejorar el diseño visual con animaciones.

¡Espero que este proyecto te sea útil para aprender Flutter y patrones de diseño como MVC!

---

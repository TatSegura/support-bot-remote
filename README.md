# Support Bot Remote – Módulo Web (JSP/Servlets)

**Aprendiz:** Tatiana Segura  

## Descripción
Módulo web de autenticación con pantalla de bienvenida para el proyecto **Support Bot Remote**.  
Incluye validación visual de credenciales, mensajes de error en la misma vista, diseño responsivo y modo claro/oscuro con efecto glassmorphism.

## Tecnologías
- Java EE (JSP/Servlets)
- Bootstrap 5, Animate.css
- HTML5, CSS3, JavaScript
- Git/GitHub (versionamiento)

## Cómo ejecutar
1. Abrir el proyecto en **NetBeans** con **Tomcat/GlassFish/Payara** configurado.  
2. Ejecutar y abrir: `http://localhost:8080/sbr/index.html`  
3. Prueba (simulada en JS): **usuario:** `admin` / **contraseña:** `1234`.

## Estructura relevante
- `Web Pages/index.html` → Pantalla de login (UI + modo oscuro).
- `Web Pages/js/support.js` → Validación simulada y redirección a `welcome.jsp`.
- `Web Pages/login.jsp` → Alternativa JSP si se conecta a Servlet.
- `Web Pages/welcome.jsp` → Pantalla de bienvenida (fondo `img/welcofondo.png`).
- `Web Pages/img/` → Recursos gráficos.
- `docs/` → Casos de uso, diagrama de clases, historias de usuario, prototipos, informe técnico.

## Estándares aplicados
- Java en CamelCase, comentarios Javadoc.
- HTML semántico e indentado.
- CSS claro y consistente.
- JS con `const/let`, funciones pequeñas, mensajes claros.
- Commits descriptivos en Git.

## Roadmap (futuro)
- Integrar `LoginServlet` + BD para validación real.
- Gestión de sesión y módulos (tickets, usuarios, reportes).

## Repositorio
El enlace al repositorio se encuentra en `REPO_URL.txt`.

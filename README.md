# Reto QA BackEnd – ServeRest | Karate DSL + Java

Suite de pruebas de la API de usuarios de [ServeRest](https://serverest.dev/), implementada con **Karate DSL 1.5.1**, **Java 17**, **JUnit 5** y **Maven**.

## Requisitos
- JDK 17 o superior (recomendado 17 o 21).
- Maven 3.9+ o Maven integrado en IntelliJ IDEA.
- IntelliJ IDEA Community o Ultimate, acceso a internet para descargar dependencias.

## Importar en IntelliJ IDEA
1. Extraer este ZIP.
2. Abrir IntelliJ → **File > Open** → seleccionar la carpeta `Reto_Karate_ServeRest` o `pom.xml`.
3. Elegir **Open as Project**, confiar en el proyecto y esperar a **Load Maven Changes**.
4. En **File > Project Structure > Project SDK**, seleccionar JDK 17 o 21.
5. Ejecutar `src/test/java/com/qa/serverest/UsuariosTest.java` con el icono verde, o ejecutar Maven `test`.

## Ejecutar desde terminal
```bash
mvn clean test
```
Servidor configurable:
```bash
mvn clean test -DbaseUrl=http://localhost:3000
```
El valor predeterminado es `https://serverest.dev`. Para trabajar sin interferencia de otros usuarios se recomienda ServeRest local (`npx serverest@latest`) y pasar `-DbaseUrl=http://localhost:3000`.

## Ejecutar un solo feature
Desde IntelliJ: clic derecho en el feature (requiere soporte de Gherkin/Karate para ejecutar directamente) o usar el runner Java y filtrar por tags. Por terminal:
```bash
mvn test -Dkarate.options="classpath:features/02-post-usuarios.feature"
```

## Reportes
Después de ejecutar, consultar `target/karate-reports/karate-summary.html`, además de los reportes JUnit en `target/surefire-reports/`.

## Organización
```
src/test/java/com/qa/serverest/UsuariosTest.java  # runner JUnit 5
src/test/java/karate-config.js                   # URL, timeouts, esquemas y helper
src/test/resources/features/                     # cinco endpoints, 13 casos
src/test/resources/helpers/                      # fábrica de datos y precondiciones
src/test/resources/schemas/                      # contratos JSON
```

## Cobertura
| ID | Endpoint | Caso | Esperado |
|---|---|---|---|
| TC_01 | GET /usuarios | Listado + esquema | 200 |
| TC_02 | GET /usuarios | Filtro por correo existente | 200 |
| TC_03 | GET /usuarios | Correo inexistente | 200, lista vacía |
| TC_04 | POST /usuarios | Alta válida + persistencia | 201 |
| TC_05 | POST /usuarios | Correo duplicado | 400 |
| TC_06 | POST /usuarios | Datos inválidos (4 variantes) | 400 |
| TC_07 | GET /usuarios/{_id} | Consulta válida | 200 |
| TC_08 | GET /usuarios/{_id} | ID inexistente | 400 |
| TC_09 | PUT /usuarios/{_id} | Actualización válida | 200 |
| TC_10 | PUT /usuarios/{_id} | Correo duplicado | 400 |
| TC_11 | PUT /usuarios/{_id} | ID inexistente crea registro | 201 |
| TC_12 | DELETE /usuarios/{_id} | Baja válida + verificación | 200 / 400 |
| TC_13 | DELETE /usuarios/{_id} | ID inexistente | 200 |

## Datos y aislamiento
- `random-user.js` genera correo y nombre únicos con UUID para cada prueba.
- Los escenarios que crean usuarios invocan el helper `delete-user.feature` al finalizar.
- No se depende de usuarios preexistentes; las pruebas son independientes.
- **Limitación:** si una aserción falla antes del paso de limpieza, puede quedar un usuario temporal. En un pipeline se recomienda entorno local efímero y reiniciarlo al finalizar.
- Evitar pruebas masivas o paralelismo agresivo contra la instancia pública de ServeRest.
- El servicio público reinicia sus datos diariamente; otros usuarios pueden modificar su estado.

## Contratos
`user.json`, `create.json` y `message.json` verifican tipos y campos obligatorios. Los mensajes y códigos se ajustan a las respuestas de ServeRest, que pueden diferir de convenciones REST genéricas (p. ej. `GET` de ID inexistente retorna 400; `PUT` de ID inexistente crea registro).

## Publicar en GitHub
1. Crear un repositorio vacío en tu cuenta de GitHub.
2. Ejecutar desde la carpeta del proyecto:
```bash
git init
git add .
git commit -m "test: automatizar CRUD de usuarios ServeRest con Karate"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/RETO_KARATE_SERVEREST.git
git push -u origin main
```
3. Sustituir `TU_USUARIO` por tu usuario real. **El enlace al repositorio se obtiene después de publicar; no está incluido porque no se ha subido el código a GitHub.**

## Referencias
- Reto de Automatización QA – BackEnd (documento adjunto).
- [ServeRest](https://serverest.dev/)
- [Karate](https://docs.karatelabs.io/)

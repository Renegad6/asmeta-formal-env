# ASMETA Formal Modeling Environment (Docker)

Este repositorio contiene un entorno completo para modelado formal basado en:

- Eclipse + ASMETA (instalación automática)
- NuSMV (CTL/LTL model checking)
- Spin (verificación Promela)
- Z3 (SMT solving)
- Graphviz (visualización de grafos)
- Java 17 + Maven
- Scripts para construir y ejecutar el contenedor

El objetivo es ofrecer un entorno reproducible, portable y profesional para modelado formal.

## 🚀 Cómo usarlo

### Construir la imagen
```bash
./scripts/build.sh


Insertar un dato:

{
  "nombre": "Ana Gómez",
  "edad": 21,
  "carrera": "Ingeniería de Sistemas",
  "activo": true,
  "materias": [
    "Bases de Datos",
    "Lógica Computacional"
  ]
}

![Evidencia 1](image-1.png)


Insertar Varios datos:

[
  {
    "nombre": "Carlos Pérez",
    "edad": 23,
    "carrera": "Ingeniería Electrónica",
    "activo": true,
    "materias": ["Arquitectura de Computadores", "Física"]
  },
  {
    "nombre": "María Rodríguez",
    "edad": 20,
    "carrera": "Ingeniería de Sistemas",
    "activo": false,
    "beca": true
  },
  {
    "nombre": "Lucía Torres",
    "edad": 25,
    "carrera": "Ingeniería Industrial",
    "activo": true,
    "materias": ["Investigación de Operaciones", "Cálculo"]
  }
]

![Evidencia 2](image.png)


Consultas basicas inciales:

{ "nombre": "Carlos Pérez" }

![Evidencia 3](image-2.png)



Buscar por carrera usando $in:

{"carrera": {"$in": ["Ingeniería de Sistemas", "Ingeniería Industrial"]}}

![Evidencia 4](image-3.png)


Buscar usando $and (por ejemplo: carrera y estado activo)

{"carrera": "Ingeniería de Sistemas", "activo": true}

![Evidencia 5](image-4.png)


Buscar usando rangos ($gte y $lte)

{"edad": {"$gte": 20, "$lte": 23}}

![Evidencia 6](image-5.png)


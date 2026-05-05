"""
TO-DO
1) Analizar la estructura de herencia compuesta por las clases Evento, Reunión y Examen.
Extenderla con una clase derivada (de algunas de las anteriores, no necesariamente de Evento) que agregue al menos un atributo y al menos un método (puede ser sobrecarga o redefinición).

2) Completar la implementación de la clase Materia, agregando los métodos new, init, getters y setters.
Crear una nueva materia y mostrarla por consola, para verificar su funcionamiento.

3) Luego de realizar (2), modifique la clase Examen para que el atributo 'materia', en lugar de ser un string, sea un objeto instancia de clase Materia.
Actualice los métodos de clase Examen según considere necesario.
HINT: Recuerde en qué consisten los chequeos de tipos en Smalltalk.

4) En clase Agenda, implemente un método obtenerProximoEvento que devuelve el proximo evento registrado en la agenda.
HINT: Evento tiene un método 'anterior', que compara dos eventos según su fecha.

5) Al final del archivo hemos creado una agenda. Registre al menos 3 eventos en ella. Verifique el correcto funcionamiento a partir de lo que muestra por pantalla.

PISTAS GENERALES:	1- Recordar que todo en Smalltalk es un mensaje a un objeto.
					2- A lo largo del programa, puede encontrar loops y condicionales que pueden servir de modelo.
"""


"""
Clase Dia
Representa una fecha usando tres enteros: número de día, número de mes y número de año.
"""
Object subclass: Dia [
    |numero mes anio|
	
	"Constructor de Dia, recibe número de día, mes y año"
    Dia class >> dia: d mes: m anio: a [
        |r|
        r := super new.
        r init: d mes: m anio: a.
        ^r
    ]
	"Constructor de Dia. La fecha es la fecha actual"
    Dia class >> actual [
        |r td actualDay actualMonth actualYear|
        r := super new.
        td := Date today.
        actualDay := td dayOfMonth.
        actualMonth := td monthIndex.
        actualYear := td year.
        r init: actualDay mes: actualMonth anio: actualYear.
        ^r
    ]
    
    init: d mes: m anio: a [
        numero := d.
        mes := m.
        anio := a
    ] 
        
    "getters y setters" 
    setNumero: num [ numero := num ]
        
    setMes: m [ mes := m]
    
    setAnio: a [ anio := a]
    
    getNumero [^numero]
    
    getMes [^mes]
    
    getAnio [^anio]
    
    "Determina si el objeto dia que recibe el mensaje es anterior al dia pasado por parámetro."
    menorQue: d [
        
        ((anio < d getAnio) or: [
                ((anio == d getAnio and: [mes < d getMes]) or: [
                        (anio == d getAnio and: [mes == d getMes and: [numero < d getNumero]])
                    ])
            ]) ifTrue: [^ true] ifFalse: [^ false]
        
    ]
    
    "Muestra día por pantalla"
    printOn: stream [
        numero printOn: stream.
        stream nextPutAll: '-'.
        mes printOn: stream.
        stream nextPutAll: '-'.
        anio printOn: stream.
    ]
        
 ]
 
 """
 Clase Materia
 Una materia consta de dos atributos, un nombre y el nombre del profesor que la dicta.
 Ambos atributos son strings.
 """
 Object subclass: Materia [
    |nombre profesor|

    "Constructor de Materia, recibe nombre y profesor"
    Materia class >> nombre: n profesor: p [
        |r|
        r := super new.
        r init: n profesor: p.
        ^r
    ]

    init: n profesor: p [
        nombre := n.
        profesor := p.
    ]

    "getters y setters"
    getNombre [ ^nombre ]

    setNombre: n [ nombre := n ]

    getProfesor [ ^profesor ]

    setProfesor: p [ profesor := p ]

    "Muestra materia por pantalla"
    printOn: stream [
        stream nextPutAll: 'Materia '.
        nombre printOn: stream.
        stream nextPutAll: ', a cargo de '.
        profesor printOn: stream
    ]
]
 
 """
 Clase Agenda
 La agenda consiste en una serie de eventos
 """
 Object subclass: Agenda [
    |eventos|
    
	"Constructor de Agenda"
    Agenda class >> new [^(super new init)]
    
    init [
        eventos := OrderedCollection new.
    ] 
       
	"Agrega evento e a la agenda" 
    agregarNuevoEvento: e [ eventos addLast: e]
    
	"Devuelve la cantidad de eventos"
    cantidadEventos [^eventos size]

    "Devuelve el próximo evento (el de fecha más cercana)"
    obtenerProximoEvento [
        |proximo|
        proximo := eventos first.
        eventos do: [:e |
            (e anterior: proximo) ifTrue: [ proximo := e ]
        ].
        ^proximo
    ]
    
    printOn: stream [
        stream nextPutAll: '===== TU AGENDA ====='.
        stream nextPut: Character nl.
        stream nextPutAll: 'Tienes '.
        self cantidadEventos printOn: stream.
        stream nextPutAll: ' eventos agendados.'.

        (self cantidadEventos > 0)
            ifTrue: [
                stream nextPut: Character nl.
                stream nextPutAll: 'Tu próximo evento es: '.
                stream nextPut: Character nl.
                stream nextPutAll: '  -> '.
                self obtenerProximoEvento printOn: stream.
            ].

        "Muestra los eventos de la agenda"
        (self cantidadEventos > 0)
            ifTrue: [
                stream nextPut: Character nl.
                stream nextPutAll: '---------------------'.
                stream nextPut: Character nl.
                stream nextPutAll: 'Todos tus eventos:'.
                eventos do: [:i |
                    stream nextPut: Character nl.
                    stream nextPutAll: '  * '.
                    i printOn: stream.
                ].
                stream nextPut: Character nl.
                stream nextPutAll: '====================='.
            ].
    ]
 ]

 """
 Clase Evento
 Un evento tiene un identificador autogenerado, una fecha en que ocurre el evento y un atributo
 de tipo boolean para indicar si el evento ya ocurrió o no.
 """
 Object subclass: Evento [
    |identificador fecha|
    
	"Constructor de Evento, recibe una fecha (objeto instancia de clase Dia)."
    Evento class >> fecha: fechaEvento [
        |r|
        r := super new.
        r init: fechaEvento.
        ^r
    ]
    
    init: fechaEvento[
        identificador := Time now.
        fecha := fechaEvento.
    ]
    
    "getters y setters"
    getDia [^fecha]
    
    setDia: d [ fecha := d]
    
    ocurrido [
        |pasado fechaActual|
        fechaActual := Dia actual.
        pasado := (fecha menorQue: fechaActual) ifTrue: [true] ifFalse: [false].
        ^ pasado.
    ]
    
	"Determina si el evento 'evento' es anterior al evento que recibe el mensaje"
    anterior: evento [
        ^(fecha menorQue: (evento getDia))
    ]
    
    "Muestra Evento por pantalla"
    printOn: stream [
        (self ocurrido) ifTrue: [
            stream nextPutAll: '(PASADO) '.    
            ].
            
        fecha printOn: stream.
        stream nextPutAll: ' => '.
  
        ]
]

"""
Clase Reunión, extensión de Evento.
Además de los atributos de un Evento, tiene una hora (string), lugar (string) y una lista de participantes.
Cada participante se espera que sea un string, simplemente el nombre.
"""
Evento subclass: Reunion [
    |participantes hora lugar|
    
	"Constructor de Reunion"
    Reunion class >> hora: h lugar: l fecha: fechaReunion[
        |r|
        r := super fecha: fechaReunion.
        r init: h lugar: l.
        ^r
    ]
    
    init: h lugar: l [
        participantes := OrderedCollection new.
        hora := h.
        lugar := l.
        ]
    
    "getters y setters"
    getHora [^hora]
    
    getLugar [^lugar]
    
    setHora: e [ hora := e]
    
    setLugar: l [ lugar := l]
    
	"Agrega un participante e a la reunión"
    agregarParticipante: e [participantes add: e]
    
	"Devuelve la cantidad de participantes registrados en la reunión"
    getCantidadParticipantes [^participantes size]
    
    "Muestra el Evento por pantalla"
    printOn: stream [
        |i|
        
        super printOn: stream.
        stream nextPutAll: 'Tienes una reunión a la hora '.
        hora printOn: stream.
        stream nextPutAll: ' en '.
        lugar printOn: stream.
        
        (participantes size > 0) ifTrue: [
            stream nextPutAll: ' con '.
            participantes first printOn: stream.
            i := 2.
            [(i <= (participantes size))] whileTrue: [
                    stream nextPutAll: ', '.
                    (participantes at: i) printOn: stream.
                    i := i + 1.
                ].
            stream nextPutAll: '.'.
        ].
    ]
]

"""
Clase Asado, extensión de Reunión.
Además de los atributos de una Reunión, tiene un menú (colección de strings con los platos a preparar).
"""
Reunion subclass: Asado [
    |menu|

    "Constructor de Asado"
    Asado class >> hora: h lugar: l fecha: fechaAsado [
        |r|
        r := super hora: h lugar: l fecha: fechaAsado.
        r initMenu.
        ^r
    ]

    initMenu [
        menu := OrderedCollection new.
    ]

    "Agrega un plato al menú del asado"
    agregarAlMenu: plato [ menu add: plato ]

    "Devuelve la cantidad de platos en el menú"
    getCantidadPlatos [ ^menu size ]

    "Muestra el Asado por pantalla"
    printOn: stream [
        super printOn: stream.
        stream nextPutAll: ' (¡Es un asado!'.
        (menu size > 0) ifTrue: [
            stream nextPutAll: ' Menu: '.
            menu do: [:plato | plato printOn: stream]
                separatedBy: [stream nextPutAll: ', '].
        ].
        stream nextPutAll: ')'.
    ]
]

"""
Clase Examen, extensión de Evento.
Además de los atributos de un Evento, tiene una hora (string), lugar (string) y una materia (objeto instancia de clase Materia).
"""
Evento subclass: Examen [
    |materia hora lugar|
    
	"Constructor de clase Examen"
    Examen class >> materia: m hora: h lugar: l fecha: fechaExamen [
        |r|
        r := super fecha: fechaExamen.
        r init: m hora: h lugar: l.
        ^r
    ]
    
    init: m hora: h lugar: l [
        materia := m.
        hora := h.
        lugar := l.
    ]
        
    "getters y setters"  
    getMateria [^materia]
    
    setMateria: m [ materia := m]
    
    getHora [^hora]
    
    setHora: e [ hora := e]
    
    getLugar [^lugar]
    
    setLugar: l [ lugar := l]
    
    "Muestra el Evento por pantalla"
    printOn: stream [
        super printOn: stream.
        stream nextPutAll: 'Tienes un examen de '.
        materia getNombre printOn: stream.
        stream nextPutAll: ' a la hora '.
        hora printOn: stream.
        stream nextPutAll: ' en '.
        lugar printOn: stream.
        stream nextPutAll: '.'.
    ]
]

"=============================================================================="
"Ejemplo"
"La agenda tiene tres exámenes registrados, y dos reuniones. Una de las reuniones tiene dos participantes asociados."

agenda := Agenda new.

"Verificación TO-DO 2: crear una materia y mostrarla por consola"
|mat|
mat := Materia nombre: 'Lenguajes de Programación' profesor: 'Dr. Smith'.
mat printNl.
"Verificación TO-DO 3: el examen ahora recibe un objeto Materia"
|examen|
examen := Examen
    materia: mat
    hora: '10:00'
    lugar: 'Aula 5'
    fecha: (Dia dia: 20 mes: 6 anio: 2026).
examen printNl.

"Verificación TO-DO 4 y 5: registrar eventos en la agenda y verificar el próximo"
|reunion1 reunion2 mat2 examen2|
reunion1 := Reunion hora: '09:00' lugar: 'Sala A' fecha: (Dia dia: 15 mes: 7 anio: 2026).
reunion1 agregarParticipante: 'Ana'.
reunion1 agregarParticipante: 'Carlos'.

reunion2 := Reunion hora: '14:00' lugar: 'Sala B' fecha: (Dia dia: 3 mes: 6 anio: 2026).

mat2 := Materia nombre: 'Algoritmos' profesor: 'Dra. Lopez'.
examen2 := Examen materia: mat2 hora: '08:00' lugar: 'Aula 10' fecha: (Dia dia: 10 mes: 6 anio: 2026).

agenda agregarNuevoEvento: reunion1.
agenda agregarNuevoEvento: reunion2.
agenda agregarNuevoEvento: examen2.
agenda agregarNuevoEvento: examen.

agenda printNl.
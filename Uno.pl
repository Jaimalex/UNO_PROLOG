% Juego del Uno para dos jugadores
% Autor: Jaimalex
% Fecha: 19/12/2023
% Lenguaje de programación usado: Prolog

baraja([[rojo,0], [rojo,1], [rojo,2], [rojo,3], [rojo,4],
        [rojo,5], [rojo,6], [rojo,7], [rojo,8], [rojo,9],
        [amarillo,0], [amarillo,1], [amarillo,2], [amarillo,3], [amarillo,4],
        [amarillo,5], [amarillo,6], [amarillo,7], [amarillo,8], [amarillo,9],
        [verde,0], [verde,1], [verde,2], [verde,3], [verde,4], 
        [verde,5], [verde,6], [verde,7], [verde,8], [verde,9],
        [azul,0], [azul,1], [azul,2], [azul,3], [azul,4], 
        [azul,5], [azul,6], [azul,7], [azul,8], [azul,9],
        [cambio, color],[cambio, color],[cambio, color],[cambio, color],
        [rojo, mas2], [verde, mas2], [azul, mas2], [amarillo, mas2],
        [rojo, mas4], [verde, mas4], [azul, mas4], [amarillo, mas4],
        [rojo, prohibido], [verde, prohibido], [azul, prohibido], [amarillo, prohibido]
        ]).

% Barajar la baraja de cartas
barajar(Barajada):-
    baraja(Baraja),
    random_permutation(Baraja, Barajada).

% Repartir cartas a dos jugadores
repartir_cartas(ManoJugador1, ManoJugador2, Centro, Mazo):-
    barajar(Barajada), % Baraja las cartas
    repartir_cartas_aux(5, Barajada, ManoJugador1, ManoJugador2, Centro, Mazo).

% Repartir cartas auxiliar
% Caso base: los dos jugadores no tienen cartas y el contador esta en 0.
repartir_cartas_aux(0, [Carta1|RestoCartas], [], [], Centro, Mazo):-
    Centro = Carta1,
    Mazo = RestoCartas. 
repartir_cartas_aux(NumeroJugador, [Carta1, Carta2 | RestoCartas], [Carta1 | RestoManoJugador1], 
                    [Carta2 | RestoManoJugador2], Centro, Mazo):-
    NumeroJugador > 0,
    NuevoNumeroJugador is NumeroJugador-1,
    repartir_cartas_aux(NuevoNumeroJugador, RestoCartas, RestoManoJugador1, RestoManoJugador2, 
                        Centro, Mazo).

% Regla para agregar una carta a la mano del jugador
agregar_carta(_,[],_,_,_):-
    write('Se terminaron las cartas para poder pedir'), nl, 
    write('Si ya no puedes hacer ningun movimiento escribe: paso'),nl, 
    false.

agregar_carta(0, RestoCartas, ManoJugador, Mazo, ManoResultado):-
    Mazo = RestoCartas,
    ManoResultado = ManoJugador.

agregar_carta(NumeroJugador, [Carta1|RestoCartas], ManoJugador, Mazo, ManoResultado):-
    NumeroJugador > 0,
    NuevoNumeroJugador is NumeroJugador-1,
	append([Carta1], ManoJugador, JugadorSuma),
    agregar_carta(NuevoNumeroJugador, RestoCartas, JugadorSuma, Mazo, ManoResultado).

% Regla para ver si se puede jugar esa carta.
puede_jugar(Carta, [Color, NumeroOAccion]):- 
    Carta = [Color, _] ; Carta = [_, NumeroOAccion] ;
    [Color, NumeroOAccion] = [cambio, color]; 

eliminar_carta(_, [], []).
eliminar_carta(Carta, [Carta|RestoCartas], RestoCartas).
eliminar_carta(Carta, [OtraCarta|RestoCartas], [OtraCarta|NuevaMano]) :-
    Carta \= OtraCarta,
    eliminar_carta(Carta, RestoCartas, NuevaMano).

tiene_carta(Carta, ManoJugador):-
    (not(member(Carta,ManoJugador)), Carta \= 'pidocarta', Carta \= 'paso'),    
    write("¡No tienes esa carta!"), nl.

mas_carta(Carta, Mazo, ManoJugador, NuevoMazo, ManoResultado):-
    Carta == 'pidocarta',
    agregar_carta(1, Mazo, ManoJugador, NuevoMazo, ManoResultado),
    write("Se agrego una carta a tu mano"), nl.

masDos_carta(Carta, Contrincante, ContrincanteNuevoMazo, Mazo, NuevoMazo):-
    Carta = [_, mas2],
    agregar_carta(2, Mazo, Contrincante, NuevoMazo, ContrincanteNuevoMazo),
    write('Se le sumaron dos cartas al contrincante'), nl.

masCuatro_carta(Carta, Contrincante, ContrincanteNuevoMazo, Mazo, NuevoMazo, NuevaCarta):-
    Carta = [_, mas4],
    agregar_carta(4, Mazo, Contrincante, NuevoMazo, ContrincanteNuevoMazo),
    write('Se le sumaron cuatro cartas al contrincante'), nl,
    write('Introduce el color al cual cambiar (ejemplo: rojo): '), nl, read(Nuevocolor),
    NuevaCarta = [Nuevocolor,cambioColor].

prohibido(Carta, Centro):-
    Carta = [_, prohibido],
    puede_jugar(Carta, Centro),
    write('Prohibido jugado'), nl.

cambio_color(Carta, NuevaCarta):-
    Carta = [_, color],
    write('Introduce el color al cual cambiar (ejemplo: rojo) '), nl, read(Nuevocolor),
    NuevaCarta = [Nuevocolor,cambioColor].
    
cambio_turno(NumeroJugador, NuevoTurno):-
    ( NumeroJugador = 2,
     NuevoTurno = 1);
    ( NumeroJugador = 1,
      NuevoTurno = 2).

mismo_turno(NumeroJugador, NuevoTurno):-
    ( NumeroJugador = 2,
     NuevoTurno = 2);
    ( NumeroJugador = 1,
      NuevoTurno = 1).

% Predicado para el turno de un jugador
% Caso base de turno para terminar el programa
turno(_,[],[],_,[],_):-
    write('Reiniciando juego'), nl,
    iniciar_juego.

turno(_,_,_,_,_,2):-
    write('Ya no quedan mas movimientos'), nl,
    write('Reiniciando juego'), nl,
    iniciar_juego.

turno(NumeroJugador,_,[],_,_,_):-
    write('Se termino el Juego, gano el jugador '), 
    cambio_turno(NumeroJugador, NuevoTurno),
    write(NuevoTurno), nl,
    turno(NuevoTurno,[],[],_,[],_).

turno(NumeroJugador,[],_,_,_,_):-
    write('Se termino el Juego, gano el jugador '), 
	mismo_turno(NumeroJugador, NuevoTurno),
    write(NuevoTurno), nl,
    turno(NumeroJugador,[],[],_,[],_).

turno(NumeroJugador, ManoJugador, ManoContrincante, Centro, Mazo, ContadorPasos):-
    % write('\e[H\e[2J'),
    write("Jugador "), write(NumeroJugador), nl,
    write('Cartas en tu mano: '), write(ManoJugador), nl,
    write('Carta en el centro: '), write(Centro),  nl,
   	write('Ingresa la carta a jugar (ejemplo: [rojo,1]) '), read(Carta), nl,
    (
        (
        tiene_carta(Carta, ManoJugador),
        turno(NumeroJugador, ManoJugador, ManoContrincante, Centro, Mazo, ContadorPasos)
        );
        
        (
        mas_carta(Carta, Mazo, ManoJugador, NuevoMazo, ManoResultado),
        turno(NumeroJugador, ManoResultado, ManoContrincante, Centro, NuevoMazo, ContadorPasos)
        );
        
        (   
        puede_jugar(Carta, Centro),
        masDos_carta(Carta, ManoContrincante, NuevaManoContrincante, Mazo, NuevoMazo),
        eliminar_carta(Carta, ManoJugador, NuevaManoJugador),
        cambio_turno(NumeroJugador, NuevoTurno),
        turno(NuevoTurno, NuevaManoContrincante, NuevaManoJugador, Carta, NuevoMazo, ContadorPasos)
        );

        (   
        puede_jugar(Carta, Centro),
        masCuatro_carta(Carta, ManoContrincante, NuevaManoContrincante, Mazo, NuevoMazo, NuevaCarta),
        eliminar_carta(Carta, ManoJugador, NuevaManoJugador),
        cambio_turno(NumeroJugador, NuevoTurno),
        turno(NuevoTurno, NuevaManoContrincante, NuevaManoJugador, NuevaCarta, NuevoMazo, ContadorPasos)
        );
        
        (   
        Mazo = [],
        Carta == 'paso',
        NuevoContadorPasos is ContadorPasos + 1,
        cambio_turno(NumeroJugador, NuevoTurno),
        turno(NuevoTurno, ManoContrincante, ManoJugador, Centro, Mazo, NuevoContadorPasos)
        );

        (
        prohibido(Carta, Centro),
        eliminar_carta(Carta, ManoJugador, NuevaManoJugador),
        turno(NumeroJugador, NuevaManoJugador, ManoContrincante, Carta, Mazo, ContadorPasos)
        );
        
        (
        cambio_color(Carta, NuevaCarta),
        eliminar_carta(Carta, ManoJugador, NuevaManoJugador),
        cambio_turno(NumeroJugador, NuevoTurno),
        turno(NuevoTurno, ManoContrincante, NuevaManoJugador, NuevaCarta, Mazo, ContadorPasos)
        );
        
        puede_jugar(Carta, Centro);
        
        (
        not(puede_jugar(Carta, Centro)),
        write("Esa carta no se puede poner, pon otra!"), nl,
        turno(NumeroJugador, ManoJugador, ManoContrincante, Centro, Mazo, ContadorPasos)
        )
    ),
    
    % shell('clear'),
    eliminar_carta(Carta, ManoJugador, NuevaManoJugador),
    cambio_turno(NumeroJugador, NuevoTurno),
    turno(NuevoTurno, ManoContrincante, NuevaManoJugador, Carta, Mazo, 0).

iniciar_juego:-
    repartir_cartas(ManoJugador1, ManoJugador2, Centro, Mazo),
    turno(1, ManoJugador1, ManoJugador2, Centro, Mazo, 0).
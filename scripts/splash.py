#!/bin/python
import time, sys, random

if len(sys.argv) < 3:
    print(f"Uso: splash.py <delay> <aleatório[s/n]>")
    sys.exit(1)
delay = float(sys.argv[1])
rando = str(sys.argv[2])
frases = []
frases.append("Casas e riquezas herdam-se dos pais,\\nmas a esposa prudente vem do Senhor.\\n-Provérbios 19:14")
frases.append("O preço da grandiosidade é a responsabilidade\\n-Winston Churchill")
frases.append("O pecado parece liberdade até você tentar parar")
frases.append("A verdadeira viagem de descoberta não consiste em procurar nova paisagens, mas ter novos olhos\\n-Proverbio Chinês")
frases.append("Antes da morte qualquer derrota é psicológica")
frases.append("Nas grandes batalhas da vida, o primeiro passo para a vitória é sempre o desejo de vencer\\n-Mahatma Gandhi")
frases.append("Those who don't start today don't deserve a tommorow")
frases.append("Eis que o temor do senhor é a sabedoria, e apartar-se do mal é a inteligência\\n-Jó 28:28")
frases.append("Those who cannot conceive friendship\\nas a substantive love but only as a disguise\\nor elaboration of eros betray the fact that\\nthey have never had a friend.")
frases.append("Qualquer coisa que fizer será insignificante , mas é importante que faça, pois ninguem o fará por você\\n-Mahatma Gandhi")
frases.append("When freedom is outlawed, only outlaws will be free!")
frases.append("Todo trabalho árduo traz proveito, mas o só falar leva à pobreza\\n-Provérbios 14:23")
frases.append("Seja caloroso ao demonstrar reconhecimento e pródigo nos elogios")
frases.append("Detesto quem me rouda a solidão sem em troca me oferecer a verddeira companhia\\n-Friedrich Nietzsche")
frases.append("tudo que você escolhe não mudar você aceita ter")
frases.append("A massa mantem a marca, a marca mantem a mídia e a mídia controla a massa\\n-George Orwell")
frases.append("The society that separates its scholars from its warriors will\\nhave its thinking done by cowards and its fighting by fools -Thucydides")
frases.append("Na muita sabedoria, há muito enfado; e o que aumenta em ciência aumenta em trabalho\\n-Eclesiaste 1:18")
frases.append("Pois Deus amou tanto o mundo, que entregou o seu filho único,\\npara que todo o que nele crê não pereça, mas tenha vida eterna.\\n-João 3:16")
frases.append("Quem tem um porquê enfrenta qualquer como\\n-Friedrich Nietzsche")
def splash(dly,rdm):
    while rdm == "s" or rdm == "S":
        escolhida = random.choice(frases)
        indice = frases.index(escolhida)
        print (f'{{"text":"{escolhida}","tooltip":"{indice}",}}')
        time.sleep(dly)
    while rdm == "n" or rdm == "N":
        for x in range(len(frases)):
            print (f'{{"text":"{frases[x]}","tooltip":"{x}",}}')
            time.sleep(dly)
splash(delay, rando)



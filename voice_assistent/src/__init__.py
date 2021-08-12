#Importing libraries internal
import datetime

#Importing libraries external
import pyAudio
import speech_recognition as sr
import pyttsx3 
import wikipedia
import pywhatkit

#Calling libraries
audio = sr.Recognizer()
maquina = pyttsx3.init()

#Coding
def executa_comando():
    try:
        with sr.Microfone() as source:
            print('Ouvindo...')
            voz = audio.listen(source)
            comando = audio.recognize_google(voz, language='pt-BR')
            comando = comando.lower()

            if 'val' in comando:
                print(comando)
                #maquina.say('Olá, eu sou a VAL! Como posso ajudar?')
                comando = comando.replace('val', '')
                maquina.say(comando)
                maquina.runAndWait()
    except:
        print('Microfone não está funcionando bem!')

    return comando

def comando_voz_usuario():
    comando = executa_comando()
    if 'horas' in comando:
        hora = datetime.datetime.now().strftime('%H:%M')
        maquina.say('Agora são ' + hora)
        maquina.runAndWait()
    elif 'procure por' in comando:
        procurar = comando.replace('procure por', '')
        wikipidia.set_lang('pt')
        resultado = wikipidia.summary(procurar, 2)
        print(resultado)
        maquina.say(resultado)
        maquina.runAndWait()
    elif 'toque' in comando:
        musica = comando.replace('toque', '')
        resultado = pywhatkit.playonyt(musica)
        maquina.say('Tocando a música...')
        maquina.runAndWait()

comando_voz_usuario()
usuario()

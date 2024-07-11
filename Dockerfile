#Para criar um conteiner usamos o comando:
    # docker build -t api-journey:v1 .
    # :v1 é uma tag que definimos
    # o . é a localização do dockfile

#listar todas as imagens docker image ls

#Listar todos os processos docker ps
#Listar o que aconteceu com os processos docker ps -a
 
#Ver logs doscker log [Container ID]

#executar a imagem docker run -d -p 8080:8080 api-journey:v2
FROM golang:1.22.4-alpine as builder

# Ao executar, tudo daqui pra baixo ficara na pasta journey (como se fosse /app)
WORKDIR /journey

#Esse go.mod go.sum  são arquivos de dependência, como yarn, então fazemos uma cópia para a pasta raiz (/journey)
COPY go.mod go.sum ./

RUN go mod download && go mod verify

#Estou pegando todos os arquivos de minha aplicação e jogando para a minha raiz
# o '.' está se referindo a raiz do projeto
#Copiar de A para B
COPY . .

# RUN go build —o /bin/journey ./cmd/journey/journey.go

WORKDIR /journey/cmd/journey
RUN go build -o /bin/journey .

# O código todo não nos interessa, pois o que de fato nos importa é o binário. Então, precisamos isolar essas dependencias, por isso usamos o scratch, ele serve como se fosse um novo conteiner que reutiliza o que ja foi feito
FROM scratch

WORKDIR /journey

copy --from=builder /bin/journey .

EXPOSE 8080
ENTRYPOINT [ "./journey" ]




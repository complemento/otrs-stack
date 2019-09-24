# OTRS com ITSM

Configuração básica do OTRS com o pacote ITSM

# Pré-requisitos

* arquivos deste repositório
* docker instalado
* docker-compose instalado

# Comandos para iniciar uma instância nova
```
docker-compose pull
docker-compose up
```

## Usando make
```
make up
```
Você pode usar ainda outros parâmetros. Consulte o comando `make help`


# Primeiro acesso

O ambiente será configurado e funcionará na porta 80
* Endereço: http://localhost/otrs/index.pl
* Usuário: root@localhost
* Senha: otrs

# Repositório

A imagem base está em https://hub.docker.com/ligero/otrs-itsm

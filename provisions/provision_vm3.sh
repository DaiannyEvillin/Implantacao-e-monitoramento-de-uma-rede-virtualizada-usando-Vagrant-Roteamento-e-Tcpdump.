#!/bin/bash

echo "Iniciando o hardening básico e configurações necessárias..."

# Hardening básico e atualizações
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install ufw -y

# Configuração do UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw --force enable
sudo ufw status

# Configuração de Roteamento Estático
echo "Configurando roteamento estático..."

# Adicionando uma rota estática para alcançar a sub-rede da VM2 através do roteador (VM1)
sudo ip route add 192.168.50.0/24 via 192.168.60.1

echo "Roteamento estático configurado."

# Instalação do Tcpdump para Análise de Tráfego
echo "Instalando Tcpdump..."

sudo apt-get install tcpdump -y
sudo apt-get install traceroute -y

echo "Tcpdump instalado."

# Verificações de Conectividade
echo "Verificando conectividade com VM1 e VM2..."

# Ping para o roteador (VM1)
ping -c 4 192.168.60.1

# Ping para o Host 1 (VM2)
ping -c 4 192.168.50.10

echo "Verificações de conectividade concluídas."

# Instruções para Análise de Tráfego
echo "Para capturar pacotes com o Tcpdump, você pode usar um comando como:"
echo "sudo tcpdump -i eth1 -w /vagrant/captura_vm3.pcap"

echo "Configuração concluída."

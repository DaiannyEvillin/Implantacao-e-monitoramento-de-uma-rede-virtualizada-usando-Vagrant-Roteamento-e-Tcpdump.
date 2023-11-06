#!/bin/bash

# 1. Atualização do Sistema
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. Instalar o Tcpdump para análise de tráfego
sudo apt-get install tcpdump -y

# 2.1 Instalar o Traceroute para análise de rotas
sudo apt-get install traceroute -y

# 3. Habilitar o Encaminhamento de IP
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 4. Configurar as interfaces de rede
# A interface eth1 conecta-se à sub-rede 192.168.50.0/24
# A interface eth2 conecta-se à sub-rede 192.168.60.0/24
sudo ip addr add 192.168.50.1/24 dev eth1
sudo ip addr add 192.168.60.1/24 dev eth2
sudo ip link set eth1 up
sudo ip link set eth2 up

# 5. Configurar as Rotas Estáticas
# Neste caso, não é necessário configurar rotas estáticas no roteador
# pois ele já conhece as sub-redes diretamente conectadas

# 6. Configuração do Firewall (UFW)
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH e tráfego de encaminhamento
sudo ufw allow ssh
sudo ufw allow from 192.168.50.0/24 to 192.168.60.0/24
sudo ufw allow from 192.168.60.0/24 to 192.168.50.0/24

# Ativar UFW
sudo ufw --force enable
sudo ufw status

# 7. Criar o diretório /etc/iptables se não existir
sudo mkdir -p /etc/iptables

# 8. Configurar NAT
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# 9. Salvar as configurações do iptables
sudo sh -c 'iptables-save > /etc/iptables/rules.v4'

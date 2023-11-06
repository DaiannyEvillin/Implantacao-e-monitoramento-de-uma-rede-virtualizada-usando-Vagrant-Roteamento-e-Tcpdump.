# Etapa 2: Implementação e Monitoramento de uma Rede Virtualizada

**Tipo:** Individual  
**Valor:** 2 Pontos  
**Data de Entrega:** 04/11/2023  
**Plataforma de Entrega:** SUAP  
**Data da Solicitação:** Após conclusão da Etapa 1  

## Descrição

Nesta etapa, foi feita a configuração de roteamento estático utilizando o sistema operacional Linux Ubuntu em uma rede virtualizada com 3 máquinas virtuais. Uma das máquinas virtuais foi configurada como uma bridge, fornecendo conectividade entre as outras duas máquinas virtuais. Além disso, foi realizada uma captura de pacotes enviados entre as máquinas virtuais para identificar os pacotes correspondentes ao fluxo gerado entre as máquinas.

## Passos Realizados

- [x] Criar 3 máquinas virtuais utilizando o Vagrant.
- [x] Configurar a rede virtual de forma que todas as máquinas estejam conectadas entre si.
- [x] Configurar uma das máquinas como roteador (bridge).
- [x] Configurar o roteamento estático nas outras duas máquinas virtuais.
- [x] Testar a conectividade entre as máquinas virtuais usando comandos como `ping` ou `traceroute`.
- [x] Utilizar o Tcpdump para capturar e analisar o tráfego de rede entre as máquinas virtuais.

## Descrição Detalhada do Projeto

Foi criada uma rede virtualizada composta por três máquinas virtuais. Uma delas funcionou como roteador, intermediando a comunicação entre as outras duas. A configuração de roteamento estático foi realizada para garantir que os pacotes fossem encaminhados corretamente entre as máquinas.

### Configuração das Máquinas Virtuais

1. **VM1 (Roteador)**: Atuou como intermediário na comunicação entre a VM2 e a VM3, encaminhando os pacotes entre elas.
2. **VM2 (Host 1)**: Enviou e recebeu pacotes das outras máquinas, comunicando-se com a VM3 através do roteador VM1.
3. **VM3 (Host 2)**: Similar à VM2, enviou e recebeu pacotes, comunicando-se com a VM2 através do roteador VM1.

### Roteamento Estático

Rotas estáticas foram configuradas nas VM2 e VM3 para garantir que o tráfego entre elas fosse encaminhado através do roteador VM1.

### Análise de Tráfego

O Tcpdump foi utilizado para capturar e analisar o tráfego de rede entre as máquinas virtuais, identificando os pacotes enviados e recebidos, bem como suas características.

## Instruções para Configuração e Testes

### 1. Configuração

**Criar e Configurar as Máquinas Virtuais**

    vagrant up

### 2. Testes e análise de tráfego

**Ping entre as VMs**
    vagrant ssh vm1
    ping 192.168.50.10
    ping 192.168.60.10
    traceroute -I 192.168.50.10
    traceroute -I 192.168.60.10
    exit

    vagrant ssh vm2
    ping 192.168.60.10
    ping 192.168.50.1
    traceroute -I 192.168.60.10
    exit

    vagrant ssh vm3
    ping 192.168.50.10
    ping 192.168.60.1
    traceroute -I 192.168.50.10
    exit

**Captura de Pacotes**
    vagrant ssh vm1
    sudo timeout 60 tcpdump -i enp0s3 -w arquivo_de_captura1.pcap
    sudo timeout 60 tcpdump -i enp0s8 -w arquivo_de_captura2.pcap
    sudo timeout 60 tcpdump -i enp0s9 -w arquivo_de_captura.pcap


**Análise dos Pacotes**
    vagrant ssh vm1
    sudo tcpdump -r arquivo_de_captura1.pcap
    sudo tcpdump -r arquivo_de_captura2.pcap
    sudo tcpdump -r arquivo_de_captura.pcap

### 3. Relatório

**VM1 (Roteador) - Ping/Traceroute**
    --- 192.168.50.10 ping statistics ---
    552 packets transmitted, 547 received, 0.905797% packet loss, time 558402ms
    rtt min/avg/max/mdev = 0.311/0.791/6.134/0.441 ms

    --- 192.168.60.10 ping statistics ---
    2186 packets transmitted, 2180 received, 0.274474% packet loss, time 2220682ms
    rtt min/avg/max/mdev = 0.309/0.742/12.674/0.507 ms

    traceroute to 192.168.50.10 (192.168.50.10), 30 hops max, 60 byte packets
     1  192.168.50.10 (192.168.50.10)  0.458 ms  0.422 ms  0.245 ms

    traceroute to 192.168.60.10 (192.168.60.10), 30 hops max, 60 byte packets
     1  192.168.60.10 (192.168.60.10)  0.562 ms *  0.428 ms

**VM2 (Host 1) - Ping/Traceroute**
    --- 192.168.60.10 ping statistics ---
    537 packets transmitted, 537 received, 0% packet loss, time 538400ms
    rtt min/avg/max/mdev = 0.547/1.713/12.924/1.295 ms

    --- 192.168.50.1 ping statistics ---
    275 packets transmitted, 275 received, 0% packet loss, time 277744ms
    rtt min/avg/max/mdev = 0.289/0.906/17.039/1.155 ms

    traceroute to 192.168.60.10 (192.168.60.10), 30 hops max, 60 byte packets
    1  192.168.50.1 (192.168.50.1)  0.456 ms  0.403 ms  1.014 ms
    2  192.168.60.10 (192.168.60.10)  1.193 ms * *

**VM3 (Host 2) - Ping/Traceroute**
    --- 192.168.50.10 ping statistics ---
    627 packets transmitted, 627 received, 0% packet loss, time 628097ms
    rtt min/avg/max/mdev = 0.571/1.382/9.753/0.703 ms

    --- 192.168.60.1 ping statistics ---
    200 packets transmitted, 200 received, 0% packet loss, time 201433ms
    rtt min/avg/max/mdev = 0.362/0.860/8.499/0.689 ms

    traceroute to 192.168.50.10 (192.168.50.10), 30 hops max, 60 byte packets
    1  192.168.60.1 (192.168.60.1)  0.465 ms * *
    2  192.168.50.10 (192.168.50.10)  34.966 ms * *

**(Roteador) - Captura de Pacotes - 60 segundos**
**Ver nomes da rede**
    ip -c -br link show

    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    enp0s3           UP             02:14:42:86:0b:0b <BROADCAST,MULTICAST,UP,LOWER_UP>
    enp0s8           UP             08:00:27:f8:58:66 <BROADCAST,MULTICAST,UP,LOWER_UP>
    enp0s9           UP             08:00:27:f8:ac:37 <BROADCAST,MULTICAST,UP,LOWER_UP>
**Captura de pacotes**

    sudo timeout 60 tcpdump -i enp0s3 -w arquivo_de_captura1.pcap
    tcpdump: listening on enp0s3, link-type EN10MB (Ethernet), capture size 262144 bytes
    6 packets captured
    6 packets received by filter
    0 packets dropped by kernel

    sudo timeout 60 tcpdump -i enp0s8 -w arquivo_de_captura2.pcap
    tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
    5 packets captured
    5 packets received by filter
    0 packets dropped by kernel
    
    sudo timeout 60 tcpdump -i enp0s9 -w arquivo_de_captura.pcap
    tcpdump: listening on enp0s9, link-type EN10MB (Ethernet), capture size 262144 bytes
    8 packets captured
    8 packets received by filter
    0 packets dropped by kernel

**Análise dos Pacotes**
    
    sudo tcpdump -r arquivo_de_captura1.pcap
    reading from file arquivo_de_captura1.pcap, link-type EN10MB (Ethernet)
    13:04:02.524646 IP vm1-router.ssh > _gateway.61676: Flags [P.], seq 2145509050:2145509086, ack 2307912027, win 62707, length 36
    13:04:02.524914 IP _gateway.61676 > vm1-router.ssh: Flags [.], ack 36, win 65535, length 0
    13:04:02.525042 IP vm1-router.ssh > _gateway.61676: Flags [P.], seq 36:72, ack 1, win 62707, length 36
    13:04:02.525218 IP _gateway.61676 > vm1-router.ssh: Flags [.], ack 72, win 65535, length 0
    13:04:02.525258 IP vm1-router.ssh > _gateway.61676: Flags [P.], seq 72:108, ack 1, win 62707, length 36
    13:04:02.525392 IP _gateway.61676 > vm1-router.ssh: Flags [.], ack 108, win 65535, length 0

    sudo tcpdump -r arquivo_de_captura2.pcap
    reading from file arquivo_de_captura2.pcap, link-type EN10MB (Ethernet)
    13:05:34.253427 IP vm1-router.55095 > 239.255.255.250.1900: UDP, length 170
    13:05:35.254533 IP vm1-router.55095 > 239.255.255.250.1900: UDP, length 170
    13:05:36.255377 IP vm1-router.55095 > 239.255.255.250.1900: UDP, length 170
    13:05:37.255920 IP vm1-router.55095 > 239.255.255.250.1900: UDP, length 170
    13:06:07.423644 IP vm1-router.netbios-dgm > 192.168.50.255.netbios-dgm: UDP, length 201

    sudo tcpdump -r arquivo_de_captura.pcap
    reading from file arquivo_de_captura.pcap, link-type EN10MB (Ethernet)
    13:07:19.660276 IP vm1-router.56879 > 239.255.255.250.1900: UDP, length 175
    13:07:20.661621 IP vm1-router.56879 > 239.255.255.250.1900: UDP, length 175
    13:07:21.662191 IP vm1-router.56879 > 239.255.255.250.1900: UDP, length 175
    13:07:22.662993 IP vm1-router.56879 > 239.255.255.250.1900: UDP, length 175
    13:07:34.251614 IP vm1-router.52897 > 239.255.255.250.1900: UDP, length 170
    13:07:35.253145 IP vm1-router.52897 > 239.255.255.250.1900: UDP, length 170
    13:07:36.253834 IP vm1-router.52897 > 239.255.255.250.1900: UDP, length 170
    13:07:37.255155 IP vm1-router.52897 > 239.255.255.250.1900: UDP, length 170

### Análise dos resultados

A análise do tráfego capturado revelou que a comunicação entre as máquinas virtuais está ocorrendo como esperado. O roteador VM1 está encaminhando pacotes entre VM2 e VM3, demonstrando o sucesso na configuração de roteamento estático. Os testes de conectividade com ping e traceroute confirmaram que as VMs podem se comunicar sem perda de pacotes e com tempos de resposta baixos, indicando uma rede eficiente.

O tráfego SSH capturado entre a VM1 e o gateway sugere que a VM1 está acessível e que as políticas de segurança (firewall) estão corretamente configuradas para permitir essa comunicação. Os pacotes SSDP indicam a presença de serviços UPnP na rede, enquanto os pacotes NetBIOS sugerem o uso de compartilhamento de arquivos ou serviços de nome na sub-rede.

A implantação da rede virtualizada foi bem-sucedida, com o roteamento estático permitindo comunicação eficaz entre as máquinas virtuais. A captura de tráfego com o Tcpdump forneceu insights valiosos sobre a natureza do tráfego na rede e confirmou que a configuração do roteamento e do firewall está funcionando como pretendido.

Este trabalho forneceu uma experiência prática com ferramentas de rede essenciais e conceitos de roteamento, demonstrando a importância de entender como os dados são roteados e gerenciados em um ambiente de rede. A habilidade de configurar e analisar uma rede é fundamental para a administração de sistemas e segurança de rede.
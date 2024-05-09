1 pragma solidity ^0.4.21;
2 
3 contract DoacaoEvento {
4     address public responsavel;
5     enum StatusDoacao{ABERTO, FECHADO, SACADO}
6     StatusDoacao public statusDoacao;
7     address public ong;
8     
9     Doador[] public doadores;  
10     
11     event LogDoacaoRecebida(address doador, uint256 value);
12     event LogSaqueEfetuado(uint dataHora);
13     event LogOngInformada(address doador);
14      
15     struct Doador {
16         address doador;
17         uint256 valor;
18         uint256 dataHora;
19     }
20     
21     function DoacaoEvento() public {
22         responsavel = msg.sender;
23         statusDoacao = StatusDoacao.ABERTO;
24     }
25     
26     modifier apenasResponsavel() {
27         require(msg.sender == responsavel);
28         _;
29     }
30 
31     function informarOng(address _ong) public apenasResponsavel {
32         emit LogOngInformada(_ong);
33         ong = _ong;
34     }
35     
36     function fecharDoacoes() public apenasResponsavel {
37         require(statusDoacao == StatusDoacao.ABERTO);
38         statusDoacao = StatusDoacao.FECHADO;
39     }
40     
41     function abrirDoacoes() public apenasResponsavel {
42         statusDoacao = StatusDoacao.ABERTO;
43     }  
44     
45     function sacarDoacoes() public {
46         require(msg.sender == ong && address(this).balance > 0 && statusDoacao == StatusDoacao.FECHADO);
47         statusDoacao = StatusDoacao.SACADO;
48         emit LogSaqueEfetuado(block.timestamp);
49         msg.sender.transfer(address(this).balance);
50     }
51     
52     // função callback
53     function() public payable {
54         require(msg.value > 0 && statusDoacao == StatusDoacao.ABERTO);
55         emit LogDoacaoRecebida(msg.sender, msg.value);
56         Doador memory d = Doador(msg.sender, msg.value, block.timestamp);
57         doadores.push(d);
58     }
59 }
1 pragma solidity ^0.4.0;
2 contract ProvaSegura {
3 
4     struct Prova {
5         bool existe;
6         uint block_number;
7         string numero;
8         string data_hora;
9         string coordenadas;
10     }
11 
12     mapping(bytes32 => Prova) public provas;
13     address public admin;
14 
15     function ProvaSegura() public {
16         admin = msg.sender;
17     }
18     
19     function TrocarAdmin(address _admin) public {
20         require(msg.sender == admin);
21         admin = _admin;
22     }
23 
24     function GuardaProva(string _hash, string _numero, string _data_hora, string _coordenadas) public {
25         require(msg.sender == admin);
26         bytes32 hash = sha256(_hash);
27         require(!provas[hash].existe);
28         provas[hash].existe = true;
29         provas[hash].block_number = block.number;
30         provas[hash].numero = _numero;
31         provas[hash].data_hora = _data_hora;
32         provas[hash].coordenadas = _coordenadas;
33     }
34 
35     function ConsultaProva(string _hash) public constant returns (uint, string, string, string) {
36         bytes32 hash = sha256(_hash);
37         require(provas[hash].existe);
38         return (provas[hash].block_number, provas[hash].numero, provas[hash].data_hora, provas[hash].coordenadas);
39     }
40 }
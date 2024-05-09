1 pragma solidity ^0.4.0;
2 contract RegistroBlockchain {
3 
4     struct Registro {
5         bool existe;
6         uint block_number;
7     }
8 
9     mapping(bytes32 => Registro) public registros;
10     address public admin;
11 
12     function RegistroBlockchain() public {
13         admin = msg.sender;
14     }
15     
16     function TrocarAdmin(address _admin) public {
17         require(msg.sender == admin);
18         admin = _admin;
19     }
20 
21     function GuardaRegistro(string _hash) public {
22         require(msg.sender == admin);
23         bytes32 hash = sha256(_hash);
24         require(!registros[hash].existe);
25         registros[hash].existe = true;
26         registros[hash].block_number = block.number;
27     }
28 
29     function ConsultaRegistro(string _hash) public constant returns (uint) {
30         bytes32 hash = sha256(_hash);
31         require(registros[hash].existe);
32         return (registros[hash].block_number);
33     }
34 }
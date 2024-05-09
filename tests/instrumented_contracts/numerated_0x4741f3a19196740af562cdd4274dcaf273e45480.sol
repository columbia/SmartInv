1 pragma solidity ^0.4.21;
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
12     constructor() public {
13         admin = msg.sender;
14     }
15     
16     function TrocarAdmin(address _admin) public {
17         require(msg.sender == admin);
18         admin = _admin;
19     }
20 
21     function GuardaRegistro(bytes32 hash) public {
22         require(msg.sender == admin);
23         if (!registros[hash].existe) {
24             registros[hash].existe = true;
25             registros[hash].block_number = block.number;
26         }
27     }
28 
29     function ConsultaRegistro(bytes32 hash) public constant returns (uint) {
30         require(registros[hash].existe);
31         return (registros[hash].block_number);
32     }
33 }
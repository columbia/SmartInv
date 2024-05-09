1 pragma solidity ^0.4.18;
2 
3 contract Registra1000 {
4 
5    struct Arquivo {
6        bytes shacode;
7    }
8 
9    bytes[] arquivos;
10    
11    function Registra() public {
12        arquivos.length = 1;
13    }
14 
15    function setArquivo(bytes shacode) public {
16        arquivos.push(shacode);
17    }
18    
19  
20 }
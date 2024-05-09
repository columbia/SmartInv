1 // SPDX-License-Identifier: MIT
2 
3 // Faucet contract
4 // Para no tener que dar uno a uno los tokens, tenemos este contrato de "faucet"
5 //
6 // ¿Qué es un Faucet? es una forma muy común de distribuir nuevos Tokens.
7 //
8 // Consiste en un contrato (que _suele_ tener una página web asociada)
9 // que distribuye los tokens a quien los solicita.
10 // Así el que crea el token no tiene que pagar por distribuir los tokens,
11 // y sólo los interesados 'pagan' a los mineros de la red por el coste de la transacción.
12 
13 pragma solidity >=0.7.0;
14 
15 
16 interface iERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27  
28 contract Faucet {
29 
30    // Vamos a hacer un Faucet_muy_ sencillo:
31    //   - No podemos saber de qué país es cada dirección así que:
32    //   - Cada dirección de Ethereum debe poder participar en el Airdrop.
33    //   - A cada dirección que lo solicite le transferimos 1000 unidades del tocken.
34    //   - Sólo se puede participar en el airdrop una sola vez. 
35    //   - Si hay algún problema, la transacción _falla_
36    
37    // Primero necesitamos la dirección del contrato del Token
38    
39    address public immutable token;
40    address public _root;
41 
42    // También necesitamos una lista de direcciones.
43    // Un "mapping" direccion -> a un 0 o 1 bastaría...
44    // .. pero ese tipo de dato no existe en este lenguaje)
45    // .. así que hay que construirlo a mano.
46 
47    // este es un bitmap (hay formas más eficientes de hacerlo, pero esta nos sirve)   
48    mapping (address => uint256) public claimed;
49    uint256 public immutable claimAmount;
50 
51    event Claimed(address _by, address _to, uint256 _value);
52    
53    // Cantidad solicitada por cada dirección
54    function ClaimedAmount(address index) public view returns (uint256) {
55        return claimed[index];
56    }
57       
58    function _setClaimed(address index) private {
59        require(claimed[index] == 0);
60        claimed[index] += claimAmount;  // No puede desbordar
61    }
62    
63    // Esta funcion es la que permite reclamar los tokens.
64    // No hace falta ser el dueño de la dirección para solicitarlo.
65    // De todos modos... ¿quién puede querer enviar tokens a otro?
66    // Hmm.. ¿puede haber alguna implicación legal de eso?
67    
68    function Claim(address index) public returns (uint256) {
69       // hmm... ¿dejamos que lo haga un smart contract?
70       require(msg.sender == tx.origin, "Only humans");
71 
72       require(ClaimedAmount(index) == 0 && index != address(0));
73 
74       _setClaimed(index);
75       // Hacemos la transferencia y revertimos operacion si da algún error
76       require(iERC20(token).transfer(index, claimAmount), "Airdrop: error transferencia");
77       emit Claimed(msg.sender, index, claimAmount);
78       return claimAmount;
79    }
80 
81    // Cuando acabe el tiempo del airdrop se pueden recuperar
82    // a menos que haya alguna logica en el token que no lo permita...
83 
84    // Se permite que Recovertokens lo llame un contrato por motivos fiscales.
85    // Si se llama a Recovertokens desde una direccion "normal" de Ethereum
86    // hacienda nos puede obligar a tributar por tener los tokens durante unos segundos.
87 
88    function Recovertokens() public returns (bool) {
89       require(tx.origin == _root || msg.sender == _root , "tx.origin is not root");
90       uint256 allbalance = iERC20(token).balanceOf(address(this));
91       return iERC20(token).transfer(_root, allbalance);
92    }
93 
94    // SetRoot permite cambiar el superusuario del contrato
95    // es decir, la dirección a la que se permite reclamar
96    // todos los tokens. Se puede llamar desde un contrato!
97 
98    event NewRootEvent(address);
99 
100    function SetRoot(address newroot) public {
101       require(msg.sender == _root); // sender 
102       address oldroot = _root;
103       emit NewRootEvent(newroot);
104       _root = newroot;
105    } 
106    
107    // Necesitamos construir el contrato (instanciar)
108    // Constructor
109 
110    constructor(address tokenaddr, uint256 claim_by_addr) {
111        token = tokenaddr;
112        claimAmount = claim_by_addr;
113        _root = tx.origin;  // La persona (humana?) que crea el contrato.
114    }
115 
116 }
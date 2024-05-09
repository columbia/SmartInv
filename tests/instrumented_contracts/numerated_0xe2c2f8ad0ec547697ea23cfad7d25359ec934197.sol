1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) public onlyOwner {
13         owner = newOwner;
14     }
15 }
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
18 
19 contract TokenMomos is owned{
20 
21     string public name = "Momocoin";
22     string public symbol = "MOMO";
23     uint8 public decimals = 18;
24 
25     mapping (address => uint256) public balanceOf;
26     mapping (address => mapping (address => uint256)) public allowance;
27     
28     uint256 public totalSupply;
29 
30     bytes32 public currentChallenge;  
31     uint256 public timeOfLastProof;                             
32     uint256 public difficulty = 10**32;   
33     
34     // Esto genera un evento público en el blockchain que notificará a los clientes
35     event Transfer(address indexed from, address indexed to, uint256 value); //Va de ley, no quitar
36     
37     // Esto genera un evento público en el blockchain que notificará a los clientes
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value); //Va de ley, no quitar
39 
40     // Esto notifica a los clientes sobre la cantidad quemada
41     event Burn(address indexed from, uint256 value);
42     
43     constructor(uint256 momos) public {
44         totalSupply = momos * 10 ** uint256(decimals);  // Actualizar el suministro total con la cantidad decimal
45         balanceOf[msg.sender] = totalSupply;            // Dale al creador todos los tokens iniciales
46         timeOfLastProof = now;
47     }
48 
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Impedir la transferencia a la dirección 0x0.
51         require(_to != 0x0);
52         // Verifica si el remitente tiene suficiente
53         require(balanceOf[_from] >= _value);
54          // Verificar desbordamientos
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         // Guarda esto para una afirmación en el futuro
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58          // Resta del remitente
59         balanceOf[_from] -= _value;
60         // Agregue lo mismo al destinatario
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63          // Los asertos se usan para usar análisis estáticos para encontrar errores en su código. Nunca deberían fallar
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         _transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function approve(address _spender, uint256 _value) public returns (bool success) {
80         allowance[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 
93     function burn(uint256 _value) public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);   // Verifica si el remitente tiene suficiente
95         balanceOf[msg.sender] -= _value;            // Resta del remitente
96         totalSupply -= _value;                      // Actualiza totalSupply
97         emit Burn(msg.sender, _value);
98         return true;
99     }
100 
101     function burnFrom(address _from, uint256 _value) public returns (bool success) {
102         require(balanceOf[_from] >= _value);                // Verifica si el saldo objetivo es suficiente
103         require(_value <= allowance[_from][msg.sender]);    // Verifique la asignación
104         balanceOf[_from] -= _value;                         // Resta del saldo objetivo
105         allowance[_from][msg.sender] -= _value;             // Resta del subsidio del remitente
106         totalSupply -= _value;                              // Actualizar totalSupply
107         emit Burn(_from, _value);
108         return true;
109     }
110 
111     function () external {
112         revert();     // Previene el envío accidental de éter
113     }
114     
115     function giveBlockReward() public {
116         balanceOf[block.coinbase] += 1;
117     }
118 
119     function proofOfWork(uint256 nonce) public{
120         bytes8 n = bytes8(keccak256(abi.encodePacked(nonce, currentChallenge)));    
121         require(n >= bytes8(difficulty));                   
122         uint256 timeSinceLastProof = (now - timeOfLastProof);  
123         require(timeSinceLastProof >=  5 seconds);         
124         balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  
125         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; 
126         timeOfLastProof = now;                              
127         currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1)));  
128     }
129 }
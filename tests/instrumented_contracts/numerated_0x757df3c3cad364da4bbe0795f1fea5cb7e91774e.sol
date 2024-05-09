1 /**
2      *-------------------------------------
3      * --OWNED BY LIBRA PEOPLE COMPANY Plc
4      *-------------------------------------
5      * --ERC20 STANDARD TOKEN
6      * --ETHEREUM BLOCKCHAIN
7      * --Name: RobinCoin
8      * --Symbol: RBN
9      * --Total Supply: 1000000000,00..RBN
10      * --Decimal: 18
11      * ------------------------------------
12      * --Created by Luigi Di Benedetto Brescia(IT)
13      */
14 
15 pragma solidity ^0.4.16;
16 
17 contract owned {
18     address public owner;
19 
20     function owned() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function transferOwnership(address newOwner) onlyOwner public {
30         owner = newOwner;
31     }
32 }
33 
34 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
35 
36 contract RobincoinERC20 {
37     string public name;
38     string public symbol;
39     uint8 public decimals = 18;
40     uint256 public totalSupply;
41 
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Burn(address indexed from, uint256 value);
48 
49     /**
50      * Costruttore
51      *
52      * Inizializzo nel costruttore i dati del token.
53      */
54     function RobincoinERC20(
55         uint256 initialSupply,
56         string tokenName,
57         string tokenSymbol
58     ) public {
59         totalSupply = initialSupply * 10 ** uint256(decimals);
60         balanceOf[msg.sender] = totalSupply;  
61         name = tokenName;
62         symbol = tokenSymbol;
63     }
64 
65 
66     function _transfer(address _from, address _to, uint _value) internal {
67         require(_to != 0x0);
68         require(balanceOf[_from] >= _value);
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         balanceOf[_from] -= _value;
72         balanceOf[_to] += _value;
73         emit Transfer(_from, _to, _value); //emit per evitare di confondersi con un motodo(indica che è un evento)
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77 
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
96         public
97         returns (bool success) {
98         tokenRecipient spender = tokenRecipient(_spender);
99         if (approve(_spender, _value)) {
100             spender.receiveApproval(msg.sender, _value, this, _extraData);
101             return true;
102         }
103     }
104 
105     function burn(uint256 _value) public returns (bool success) {
106         require(balanceOf[msg.sender] >= _value);  
107         balanceOf[msg.sender] -= _value; 
108         totalSupply -= _value;
109         emit Burn(msg.sender, _value);
110         return true;
111     }
112 
113 
114     function burnFrom(address _from, uint256 _value) public returns (bool success) {
115         require(balanceOf[_from] >= _value);                
116         require(_value <= allowance[_from][msg.sender]);    
117         balanceOf[_from] -= _value;                         
118         allowance[_from][msg.sender] -= _value;             
119         totalSupply -= _value;                              // Aggiorno
120         emit Burn(_from, _value);
121         return true;
122     }
123 }
124 
125 /******************************************/
126 /*       FUNZIONI AGGIUNTIVE              */
127 /******************************************/
128 
129 contract Robincoin is owned, RobincoinERC20 {
130 
131     mapping (address => bool) public frozenAccount;
132 
133     event FrozenFunds(address target, bool frozen); //notifico il "congelamento"
134 
135     function Robincoin(
136         uint256 initialSupply,
137         string tokenName,
138         string tokenSymbol
139     ) RobincoinERC20(initialSupply, tokenName, tokenSymbol) public {}
140 
141     function _transfer(address _from, address _to, uint _value) internal {
142         require (_to != 0x0);                               
143         require (balanceOf[_from] >= _value);               
144         require (balanceOf[_to] + _value > balanceOf[_to]); 
145         require(!frozenAccount[_from]);                     
146         require(!frozenAccount[_to]);                       
147         balanceOf[_from] -= _value;                         
148         balanceOf[_to] += _value;                           
149         emit Transfer(_from, _to, _value);
150     }
151 
152     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
153         balanceOf[target] += mintedAmount;
154         totalSupply += mintedAmount;
155         emit Transfer(0, this, mintedAmount);
156         emit Transfer(this, target, mintedAmount);
157     }
158 
159     function freezeAccount(address target, bool freeze) onlyOwner public {
160         frozenAccount[target] = freeze;
161         emit FrozenFunds(target, freeze);
162     }
163 
164 }
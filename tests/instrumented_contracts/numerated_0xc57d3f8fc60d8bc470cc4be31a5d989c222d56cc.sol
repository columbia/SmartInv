1 /**
2      *-------------------------------------
3      * -- Scam coin - modified by Sanko as a mark of Cain for scams.
4      * -- This token will be sent to proven scammers to mark them
5      * -- FUCK YOU SCAMMERS
6      *-------------------------------------
7      * --ERC20 STANDARD TOKEN
8      * --ETHEREUM BLOCKCHAIN
9      * --Name: SCAM
10      * --Symbol: BEWARE:THIS IS A SCAM CONTRACT
11      * --Total Supply: 1000000000,00..SCAM
12      * --Decimal: 18
13      * ------------------------------------
14      * --Created by Luigi Di Benedetto Brescia(IT) copied by Sanko.
15      */
16 
17 pragma solidity ^0.4.16;
18 
19 contract owned {
20     address public owner;
21 
22     function owned() public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address newOwner) onlyOwner public {
32         owner = newOwner;
33     }
34 }
35 
36 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
37 
38 contract SCAMERC20 {
39     string public name = "SCAM";
40     string public symbol = "BEWARE:THIS IS A SCAM CONTRACT";
41     uint8 public decimals = 18;
42     uint256 public totalSupply = 1000000000;
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Burn(address indexed from, uint256 value);
50 
51     /**
52      * Costruttore
53      *
54      * Inizializzo nel costruttore i dati del token.
55      */
56     function SCAMERC20 () public {
57 
58     }
59 
60 
61     function _transfer(address _from, address _to, uint _value) internal {
62         require(_to != 0x0);
63         require(balanceOf[_from] >= _value);
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         balanceOf[_from] -= _value;
67         balanceOf[_to] += _value;
68         emit Transfer(_from, _to, _value); //emit per evitare di confondersi con un motodo(indica che è un evento)
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72 
73     function transfer(address _to, uint256 _value) public {
74         _transfer(msg.sender, _to, _value);
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
91         public
92         returns (bool success) {
93         tokenRecipient spender = tokenRecipient(_spender);
94         if (approve(_spender, _value)) {
95             spender.receiveApproval(msg.sender, _value, this, _extraData);
96             return true;
97         }
98     }
99 
100     function burn(uint256 _value) public returns (bool success) {
101         require(balanceOf[msg.sender] >= _value);  
102         balanceOf[msg.sender] -= _value; 
103         totalSupply -= _value;
104         emit Burn(msg.sender, _value);
105         return true;
106     }
107 
108 
109     function burnFrom(address _from, uint256 _value) public returns (bool success) {
110         require(balanceOf[_from] >= _value);                
111         require(_value <= allowance[_from][msg.sender]);    
112         balanceOf[_from] -= _value;                         
113         allowance[_from][msg.sender] -= _value;             
114         totalSupply -= _value;                              // Aggiorno
115         emit Burn(_from, _value);
116         return true;
117     }
118 }
119 
120 /******************************************/
121 /*       FUNZIONI AGGIUNTIVE              */
122 /******************************************/
123 
124 contract SCAM is owned, SCAMERC20 {
125 
126     mapping (address => bool) public frozenAccount;
127 
128     event FrozenFunds(address target, bool frozen); //notifico il "congelamento"
129 
130     function SCAM(
131     ) SCAMERC20() public {}
132 
133     function _transfer(address _from, address _to, uint _value) internal {
134         require (_to != 0x0);                               
135         require (balanceOf[_from] >= _value);               
136         require (balanceOf[_to] + _value > balanceOf[_to]); 
137         require(!frozenAccount[_from]);                     
138         require(!frozenAccount[_to]);                       
139         balanceOf[_from] -= _value;                         
140         balanceOf[_to] += _value;                           
141         emit Transfer(_from, _to, _value);
142     }
143 
144     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
145         balanceOf[target] += mintedAmount;
146         totalSupply += mintedAmount;
147         emit Transfer(0, this, mintedAmount);
148         emit Transfer(this, target, mintedAmount);
149     }
150 
151     function freezeAccount(address target, bool freeze) onlyOwner public {
152         frozenAccount[target] = freeze;
153         emit FrozenFunds(target, freeze);
154     }
155 
156 }
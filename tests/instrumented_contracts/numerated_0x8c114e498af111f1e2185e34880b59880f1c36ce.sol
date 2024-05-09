1 pragma solidity ^0.4.13;
2 /*I will fastelly  create your own cryptocurrency
3  (token on the most safe Ethereum blockchain) 
4 fully supported by Ethereum ecosystem and cryptocurrency exchanges,
5 write and deploy smartcontracts inside the ETH blockchain ,
6 then I verify your's coin open-source code with the etherscan Explorer.
7 After  I create the  GitHub brunch for you and
8 also add your coin to EtherDelta exchange . 
9 The full price is 0.33 ETH or ~60$
10 
11 After you  send 0.33 ETH to this smartcontract you are receiving 3.3 RomanLanskoj coins (JOB)
12 This means you already paid me for the job and I will create the coin for you
13 
14 if you use myetherwallet.com
15 open <<add custom token>>
16 Address is this smarcontract's address
17 Token Symbol is "RomanLanskoj"
18 the number of decimals is "2"
19 
20 */
21 contract owned {
22     address public owner;
23 
24     function owned() {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         if (msg.sender != owner) throw;
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner {
34         owner = newOwner;
35     }
36 }
37 
38 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
39 
40 contract token {
41     /* Public variables of the token */
42     string public standard = 'Token 1.0';
43     string public name;
44     string public symbol;
45     uint8 public decimals;
46     uint256 public totalSupply;                         // Set the symbol for display purposes
47        
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     /* This generates a public event on the blockchain that will notify clients */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     function token(
56         uint256 initialSupply,
57         string name,
58         uint8 decimals,
59         string symbol
60         )
61         {
62         balanceOf[msg.sender] = 33000;              
63         totalSupply = initialSupply;
64         name = "RomanLanskoj";                                 
65         symbol = "JOB";                               
66         decimals = 2;                
67         }
68         
69 
70     /* Send coins */
71     function transfer(address _to, uint256 _value) {
72         if (balanceOf[msg.sender] < _value) throw;           
73         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
74         balanceOf[msg.sender] -= _value;                     
75         balanceOf[_to] += _value;                            
76         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
77     }
78 
79 
80     function approve(address _spender, uint256 _value)
81         returns (bool success) {
82         allowance[msg.sender][_spender] = _value;
83         return true;
84     }
85 
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
87         returns (bool success) {    
88         tokenRecipient spender = tokenRecipient(_spender);
89         if (approve(_spender, _value)) {
90             spender.receiveApproval(msg.sender, _value, this, _extraData);
91             return true;
92         }
93     }
94 
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         if (balanceOf[_from] < _value) throw;                 
98         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
99         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
100         balanceOf[_from] -= _value;                          // Subtract from the sender
101         balanceOf[_to] += _value;                            // Add the same to the recipient
102         allowance[_from][msg.sender] -= _value;
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107 
108     function () {
109         throw;     // Prevents accidental sending of ether
110     }
111 }
112 
113 contract MyOffer is owned, token {
114 
115 uint256 public sellPrice;
116 uint256 public buyPrice;
117   function MyOffer (
118          uint256 initialSupply,
119         string name,
120         uint8 decimals,
121         string symbol
122     ) token (initialSupply, name, decimals, symbol) {
123         initialSupply = 75000;
124     }
125 
126 
127     mapping (address => bool) public frozenAccount;
128 
129     event FrozenFunds(address target, bool frozen);
130 
131     /* Send coins */
132     function transfer(address _to, uint256 _value) {
133         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
134         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
135         if (frozenAccount[msg.sender]) throw;                
136         balanceOf[msg.sender] -= _value;                     
137         balanceOf[_to] += _value;                            
138         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
139     }
140 
141 
142     /* A contract attempts to get the coins */
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
144         if (frozenAccount[_from]) throw;                                    
145         if (balanceOf[_from] < _value) throw;                 
146         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
147         if (_value > allowance[_from][msg.sender]) throw;   
148         balanceOf[_from] -= _value;                          
149         balanceOf[_to] += _value;                            
150         allowance[_from][msg.sender] -= _value;
151         Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     function mintToken(address target, uint256 mintedAmount) onlyOwner {
156         balanceOf[target] += mintedAmount;
157         totalSupply += mintedAmount;
158         Transfer(0, this, mintedAmount);
159         Transfer(this, target, mintedAmount);
160     }
161 
162     function freezeAccount(address target, bool freeze) onlyOwner {
163         frozenAccount[target] = freeze;
164         FrozenFunds(target, freeze);
165     }
166 
167   
168 
169     function buy(uint256 amount, uint256 buyPrice) payable {
170         amount = msg.value / buyPrice;                
171         if (balanceOf[this] < amount) throw;               
172         balanceOf[msg.sender] += amount;                   
173         balanceOf[this] -= amount;      
174         buyPrice = 10000;                       
175         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
176     }
177 
178     function sell(uint256 amount, uint sellPrice) {
179         if (balanceOf[msg.sender] < amount ) throw;        
180         balanceOf[this] += amount;                         
181         balanceOf[msg.sender] -= amount;     
182        sellPrice = 10;          
183         if (!msg.sender.send(amount * sellPrice)) {        
184             throw;                                         
185         } else {
186             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
187         }         
188   
189     }
190 }
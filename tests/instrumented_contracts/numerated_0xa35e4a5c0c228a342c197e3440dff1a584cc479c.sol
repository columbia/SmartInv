1 //ERC20 Token
2 pragma solidity ^0.4.2;
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
21 
22 contract token {
23     /* Public variables of the token */
24     string public standard = "SGNL 1.0";
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public totalSupply;
29 
30     /* This creates an array with all balances */
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     /*************************************************/
35     mapping(address=>uint256) public indexes;
36     mapping(uint256=>address) public addresses;
37     uint256 public lastIndex = 0;
38     /*************************************************/
39 
40     /* This generates a public event on the blockchain that will notify clients */
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     /* Initializes contract with initial supply tokens to the creator of the contract */
44     function token(
45         uint256 initialSupply,
46         string tokenName,
47         uint8 decimalUnits,
48         string tokenSymbol
49         ) {
50         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         totalSupply = initialSupply;                        // Update total supply
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         decimals = decimalUnits;                            // Amount of decimals for display purposes
55         /*****************************************/
56         addresses[1] = msg.sender;
57         indexes[msg.sender] = 1;
58         lastIndex = 1;
59         /*****************************************/
60     }
61 
62     /* Send coins */
63     function transfer(address _to, uint256 _value) {
64         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
65         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
66         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
67         balanceOf[_to] += _value;                            // Add the same to the recipient
68         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
69     }
70 
71     /* Allow another contract to spend some tokens in your behalf */
72     function approve(address _spender, uint256 _value)
73         returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         return true;
76     }
77 
78     /* Approve and then communicate the approved contract in a single tx */
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
80         returns (bool success) {
81         tokenRecipient spender = tokenRecipient(_spender);
82         if (approve(_spender, _value)) {
83             spender.receiveApproval(msg.sender, _value, this, _extraData);
84             return true;
85         }
86     }
87 
88     /* A contract attempts _ to get the coins */
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
91         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
92         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
93         balanceOf[_from] -= _value;                          // Subtract from the sender
94         balanceOf[_to] += _value;                            // Add the same to the recipient
95         allowance[_from][msg.sender] -= _value;
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /* This unnamed function is called whenever someone tries to send ether to it */
101     function () {
102         throw;     // Prevents accidental sending of ether
103     }
104 }
105 
106 contract SGNL is owned, token {
107 
108     uint256 public sellPrice;
109     uint256 public buyPrice;
110 
111     mapping(address=>bool) public frozenAccount;
112 
113 
114 
115     /* This generates a public event on the blockchain that will notify clients */
116     event FrozenFunds(address target, bool frozen);
117 
118     /* Initializes contract with initial supply tokens to the creator of the contract */
119     uint256 public constant initialSupply = 60000000 * 10**16;
120     uint8 public constant decimalUnits = 16;
121     string public tokenName = "Signal";
122     string public tokenSymbol = "SGNL";
123     function SGNL() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
124      /* Send coins */
125     function transfer(address _to, uint256 _value) {
126         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
127         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
128         if (frozenAccount[msg.sender]) throw;                // Check if frozen
129         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
130         balanceOf[_to] += _value;                            // Add the same to the recipient
131         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
132         if(_value > 0){
133             if(balanceOf[msg.sender] == 0){
134                 addresses[indexes[msg.sender]] = addresses[lastIndex];
135                 indexes[addresses[lastIndex]] = indexes[msg.sender];
136                 indexes[msg.sender] = 0;
137                 delete addresses[lastIndex];
138                 lastIndex--;
139             }
140             if(indexes[_to]==0){
141                 lastIndex++;
142                 addresses[lastIndex] = _to;
143                 indexes[_to] = lastIndex;
144             }
145         }
146     }
147 
148     function getAddresses() constant returns (address[]){
149         address[] memory addrs = new address[](lastIndex);
150         for(uint i = 0; i < lastIndex; i++){
151             addrs[i] = addresses[i+1];
152         }
153         return addrs;
154     }
155 
156     function distributeTokens(uint _amount) onlyOwner returns (uint) {
157         if(balanceOf[owner] < _amount) throw;
158         uint distributed = 0;
159 
160         for(uint i = 0; i < lastIndex; i++){
161             address holder = addresses[i+1];
162             uint reward = _amount * balanceOf[holder] / totalSupply;
163             balanceOf[holder] += reward;
164             distributed += reward;
165         }
166 
167         balanceOf[owner] -= distributed;
168         return distributed;
169     }
170 
171 
172     /* A contract attempts to get the coins */
173     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
174         if (frozenAccount[_from]) throw;                        // Check if frozen
175         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
176         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
177         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
178         balanceOf[_from] -= _value;                          // Subtract from the sender
179         balanceOf[_to] += _value;                            // Add the same to the recipient
180         allowance[_from][msg.sender] -= _value;
181         Transfer(_from, _to, _value);
182         return true;
183     }
184 
185     function mintToken(address target, uint256 mintedAmount) onlyOwner {
186         balanceOf[target] += mintedAmount;
187         totalSupply += mintedAmount;
188         Transfer(0, this, mintedAmount);
189         Transfer(this, target, mintedAmount);
190     }
191 
192     function freezeAccount(address target, bool freeze) onlyOwner {
193         frozenAccount[target] = freeze;
194         FrozenFunds(target, freeze);
195     }
196 
197     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
198         sellPrice = newSellPrice;
199         buyPrice = newBuyPrice;
200     }
201 
202     function buy() payable {
203         uint amount = msg.value / buyPrice;                // calculates the amount
204         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
205         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
206         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
207         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
208     }
209 
210     function sell(uint256 amount) {
211         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
212         balanceOf[this] += amount;                         // adds the amount to owner's balance
213         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
214         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
215             throw;                                         // to do this last to avoid recursion attacks
216         } else {
217             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
218         }
219     }
220 }
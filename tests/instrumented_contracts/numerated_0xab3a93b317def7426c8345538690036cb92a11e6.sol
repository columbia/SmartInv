1 //ERC20 Token
2 pragma solidity ^0.4.17;
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
24     string public standard = "T10 1.0";
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
106 contract CCindexToken is owned, token {
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
119     uint256 public constant initialSupply = 40000000 * 10**18;
120     uint8 public constant decimalUnits = 18;
121     string public tokenName = "CCindex10";
122     string public tokenSymbol = "T10";
123     function CCindexToken() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
124      /* Send coins */
125     function transfer(address _to, uint256 _value) {
126         // if(!canHolderTransfer()) throw;
127         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
128         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
129         if (frozenAccount[msg.sender]) throw;                // Check if frozen
130         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
131         balanceOf[_to] += _value;                            // Add the same to the recipient
132         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
133         if(_value > 0){
134             if(balanceOf[msg.sender] == 0){
135                 addresses[indexes[msg.sender]] = addresses[lastIndex];
136                 indexes[addresses[lastIndex]] = indexes[msg.sender];
137                 indexes[msg.sender] = 0;
138                 delete addresses[lastIndex];
139                 lastIndex--;
140             }
141             if(indexes[_to]==0){
142                 lastIndex++;
143                 addresses[lastIndex] = _to;
144                 indexes[_to] = lastIndex;
145             }
146         }
147     }
148 
149     function getAddresses() constant returns (address[]){
150         address[] memory addrs = new address[](lastIndex);
151         for(uint i = 0; i < lastIndex; i++){
152             addrs[i] = addresses[i+1];
153         }
154         return addrs;
155     }
156 
157     function distributeTokens(uint startIndex,uint endIndex) onlyOwner returns (uint) {
158         // if(balanceOf[owner] < _amount) throw;
159         uint distributed = 0;
160         require(startIndex < endIndex);
161 
162         for(uint i = startIndex; i < lastIndex; i++){
163             address holder = addresses[i+1];
164             uint reward = balanceOf[holder] * 3 / 100;
165             balanceOf[holder] += reward;
166             distributed += reward;
167             Transfer(0, holder, reward);
168         }
169 
170         // balanceOf[owner] -= distributed;
171         totalSupply += distributed;
172         return distributed;
173     }
174 
175     /************************************************************************/
176 
177     /************************************************************************/
178 
179     /* A contract attempts to get the coins */
180     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
181         if (frozenAccount[_from]) throw;                        // Check if frozen
182         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
183         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
184         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
185         balanceOf[_from] -= _value;                          // Subtract from the sender
186         balanceOf[_to] += _value;                            // Add the same to the recipient
187         allowance[_from][msg.sender] -= _value;
188         Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     function mintToken(address target, uint256 mintedAmount) onlyOwner {
193         balanceOf[target] += mintedAmount;
194         totalSupply += mintedAmount;
195         Transfer(0, this, mintedAmount);
196         Transfer(this, target, mintedAmount);
197     }
198 
199     function freezeAccount(address target, bool freeze) onlyOwner {
200         frozenAccount[target] = freeze;
201         FrozenFunds(target, freeze);
202     }
203 
204     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
205         sellPrice = newSellPrice;
206         buyPrice = newBuyPrice;
207     }
208 
209     function buy() payable {
210         uint amount = msg.value / buyPrice;                // calculates the amount
211         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
212         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
213         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
214         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
215     }
216 
217     function sell(uint256 amount) {
218         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
219         balanceOf[this] += amount;                         // adds the amount to owner's balance
220         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
221         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
222             throw;                                         // to do this last to avoid recursion attacks
223         } else {
224             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
225         }
226     }
227 }
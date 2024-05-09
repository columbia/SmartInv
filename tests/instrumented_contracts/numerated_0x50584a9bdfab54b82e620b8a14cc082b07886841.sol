1 pragma solidity ^0.4.17;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract token {
22     /* Public variables of the token */
23     string public standard = "PVE 1.0";
24     string public name;
25     string public symbol;
26     uint8 public decimals;
27     uint256 public totalSupply;
28 
29     /* This creates an array with all balances */
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /*************************************************/
34     mapping(address=>uint256) public indexes;
35     mapping(uint256=>address) public addresses;
36     uint256 public lastIndex = 0;
37     /*************************************************/
38 
39     /* This generates a public event on the blockchain that will notify clients */
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     /* Initializes contract with initial supply tokens to the creator of the contract */
43     function token(
44         uint256 initialSupply,
45         string tokenName,
46         uint8 decimalUnits,
47         string tokenSymbol
48         ) {
49         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
50         totalSupply = initialSupply;                        // Update total supply
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53         decimals = decimalUnits;                            // Amount of decimals for display purposes
54         /*****************************************/
55         addresses[1] = msg.sender;
56         indexes[msg.sender] = 1;
57         lastIndex = 1;
58         /*****************************************/
59     }
60 
61     /* Send coins */
62     function transfer(address _to, uint256 _value) {
63         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
64         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
65         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
66         balanceOf[_to] += _value;                            // Add the same to the recipient
67         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
68     }
69 
70     /* Allow another contract to spend some tokens in your behalf */
71     function approve(address _spender, uint256 _value)
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         return true;
75     }
76 
77     /* Approve and then communicate the approved contract in a single tx */
78     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
79         returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86 
87     /* A contract attempts _ to get the coins */
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
90         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
91         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
92         balanceOf[_from] -= _value;                          // Subtract from the sender
93         balanceOf[_to] += _value;                            // Add the same to the recipient
94         allowance[_from][msg.sender] -= _value;
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /* This unnamed function is called whenever someone tries to send ether to it */
100     function () {
101         throw;     // Prevents accidental sending of ether
102     }
103 }
104 
105 contract ProvidenceCasinoToken is owned, token {
106 
107     uint256 public sellPrice;
108     uint256 public buyPrice;
109 
110     mapping(address=>bool) public frozenAccount;
111 
112     /* This generates a public event on the blockchain that will notify clients */
113     event FrozenFunds(address target, bool frozen);
114 
115     /* Initializes contract with initial supply tokens to the creator of the contract */
116     uint256 public constant initialSupply = 200000000 * 10**18;
117     uint8 public constant decimalUnits = 18;
118     string public tokenName = "Providence Crypto Casino";
119     string public tokenSymbol = "PVE";
120     function ProvidenceCasinoToken() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
121      /* Send coins */
122     function transfer(address _to, uint256 _value) {
123         if(!canHolderTransfer()) throw;
124         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
125         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
126         if (frozenAccount[msg.sender]) throw;                // Check if frozen
127         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
128         balanceOf[_to] += _value;                            // Add the same to the recipient
129         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
130         if(_value > 0){
131             if(balanceOf[msg.sender] == 0){
132                 addresses[indexes[msg.sender]] = addresses[lastIndex];
133                 indexes[addresses[lastIndex]] = indexes[msg.sender];
134                 indexes[msg.sender] = 0;
135                 delete addresses[lastIndex];
136                 lastIndex--;
137             }
138             if(indexes[_to]==0){
139                 lastIndex++;
140                 addresses[lastIndex] = _to;
141                 indexes[_to] = lastIndex;
142             }
143         }
144     }
145 
146     function getAddresses() constant returns (address[]){
147         address[] memory addrs = new address[](lastIndex);
148         for(uint i = 0; i < lastIndex; i++){
149             addrs[i] = addresses[i+1];
150         }
151         return addrs;
152     }
153 
154     function distributeTokens(uint _amount) onlyOwner returns (uint) {
155         if(balanceOf[owner] < _amount) throw;
156         uint distributed = 0;
157 
158         for(uint i = 0; i < lastIndex; i++){
159             address holder = addresses[i+1];
160             uint reward = (_amount * balanceOf[holder] / totalSupply);
161             balanceOf[holder] += reward;
162             distributed += reward;
163             Transfer(owner, holder, reward);
164         }
165 
166         balanceOf[owner] -= distributed;
167         return distributed;
168     }
169 
170     /************************************************************************/
171     bool public locked = true;
172     address public icoAddress;
173     function unlockTransfer() onlyOwner {
174         locked = false;
175     }
176 
177     function lockTransfer() onlyOwner {
178         locked = true;
179     }
180 
181     function canHolderTransfer() constant returns (bool){
182         return !locked || msg.sender == owner || msg.sender == icoAddress;
183     }
184     function setIcoAddress(address _icoAddress) onlyOwner {
185         icoAddress = _icoAddress;
186     }
187 
188     /************************************************************************/
189 
190     /* A contract attempts to get the coins */
191     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
192         if (frozenAccount[_from]) throw;                        // Check if frozen
193         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
194         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
195         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
196         balanceOf[_from] -= _value;                          // Subtract from the sender
197         balanceOf[_to] += _value;                            // Add the same to the recipient
198         allowance[_from][msg.sender] -= _value;
199         Transfer(_from, _to, _value);
200         return true;
201     }
202     
203     function mintToken(address target, uint256 mintedAmount) onlyOwner {
204         balanceOf[target] += mintedAmount;
205         totalSupply += mintedAmount;
206         Transfer(0, this, mintedAmount);
207         Transfer(this, target, mintedAmount);
208     }
209 
210 
211     function freeze(address target, bool freeze) onlyOwner {
212         frozenAccount[target] = freeze;
213         FrozenFunds(target, freeze);
214     }
215 
216     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
217         sellPrice = newSellPrice;
218         buyPrice = newBuyPrice;
219     }
220 
221     function buy() payable {
222         uint amount = msg.value / buyPrice;                // calculates the amount
223         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
224         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
225         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
226         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
227     }
228 
229     function sell(uint256 amount) {
230         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
231         balanceOf[this] += amount;                         // adds the amount to owner's balance
232         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
233         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
234             throw;                                         // to do this last to avoid recursion attacks
235         } else {
236             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
237         }
238     }
239 }
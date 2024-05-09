1 pragma solidity ^0.4.18;
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
23     string public standard = "SBND";
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
105 contract SmartBondsToken is owned, token {
106 
107     uint256 public sellPrice;
108     uint256 public buyPrice;
109 
110     mapping(address=>bool) public frozenAccount;
111 
112     /* This generates a public event on the blockchain that will notify clients */
113     event FrozenFunds(address target, bool frozen);
114     event Burn(address indexed burner, uint256 value);
115 
116     /* Initializes contract with initial supply tokens to the creator of the contract */
117     uint256 public constant initialSupply = 1000000 * 10**18;
118     uint8 public constant decimalUnits = 18;
119     string public tokenName = "SmartBonds";
120     string public tokenSymbol = "SBND";
121     function SmartBondsToken() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
122      /* Send coins */
123     function transfer(address _to, uint256 _value) {
124         if(!canHolderTransfer()) throw;
125         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
126         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
127         if (frozenAccount[msg.sender]) throw;                // Check if frozen
128         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
129         balanceOf[_to] += _value;                            // Add the same to the recipient
130         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
131         if(_value > 0){
132             if(balanceOf[msg.sender] == 0){
133                 addresses[indexes[msg.sender]] = addresses[lastIndex];
134                 indexes[addresses[lastIndex]] = indexes[msg.sender];
135                 indexes[msg.sender] = 0;
136                 delete addresses[lastIndex];
137                 lastIndex--;
138             }
139             if(indexes[_to]==0){
140                 lastIndex++;
141                 addresses[lastIndex] = _to;
142                 indexes[_to] = lastIndex;
143             }
144         }
145     }
146 
147     function getAddresses() constant returns (address[]){
148         address[] memory addrs = new address[](lastIndex);
149         for(uint i = 0; i < lastIndex; i++){
150             addrs[i] = addresses[i+1];
151         }
152         return addrs;
153     }
154 
155     function distributeTokens(uint _amount) onlyOwner returns (uint) {
156         if(balanceOf[owner] < _amount) throw;
157         uint distributed = 0;
158 
159         for(uint i = 0; i < lastIndex; i++){
160             address holder = addresses[i+1];
161             uint reward = (_amount * balanceOf[holder] / totalSupply);
162             balanceOf[holder] += reward;
163             distributed += reward;
164             Transfer(owner, holder, reward);
165         }
166 
167         balanceOf[owner] -= distributed;
168         return distributed;
169     }
170 
171     /************************************************************************/
172     bool public locked = true;
173     address public icoAddress;
174     function unlockTransfer() onlyOwner {
175         locked = false;
176     }
177 
178     function lockTransfer() onlyOwner {
179         locked = true;
180     }
181 
182     function canHolderTransfer() constant returns (bool){
183         return !locked || msg.sender == owner || msg.sender == icoAddress;
184     }
185     function setIcoAddress(address _icoAddress) onlyOwner {
186         icoAddress = _icoAddress;
187     }
188 
189     /************************************************************************/
190 
191     /* A contract attempts to get the coins */
192     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
193         if (frozenAccount[_from]) throw;                        // Check if frozen
194         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
195         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
196         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
197         balanceOf[_from] -= _value;                          // Subtract from the sender
198         balanceOf[_to] += _value;                            // Add the same to the recipient
199         allowance[_from][msg.sender] -= _value;
200         Transfer(_from, _to, _value);
201         return true;
202     }
203     
204     function mintToken(address target, uint256 mintedAmount) onlyOwner {
205         balanceOf[target] += mintedAmount;
206         totalSupply += mintedAmount;
207         Transfer(0, this, mintedAmount);
208         Transfer(this, target, mintedAmount);
209     }
210 
211     /**
212    * @dev Burns a specific amount of tokens.
213    * @param _value The amount of token to be burned.
214    */
215   function burn(uint256 _value) onlyOwner {
216     _burn(msg.sender, _value);
217   }
218 
219   /**
220    * @dev Burns a specific amount of tokens from the target address and decrements allowance
221    * @param _from address The address which you want to send tokens from
222    * @param _value uint256 The amount of token to be burned
223    */
224   function burnFrom(address _from, uint256 _value) onlyOwner {
225     require(_value <= allowance[_from][msg.sender]);
226     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
227     // this function needs to emit an event with the updated approval.
228     if (allowance[_from][msg.sender] > (allowance[_from][msg.sender] - _value)) throw;
229     allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
230     _burn(_from, _value);
231   }
232 
233   function _burn(address _who, uint256 _value) onlyOwner {
234     require(_value <= balanceOf[_who]);
235     // no need to require value <= totalSupply, since that would imply the
236     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238     balanceOf[_who] -= _value;
239     totalSupply -= _value;
240     emit Burn(_who, _value);
241     emit Transfer(_who, address(0), _value);
242   }
243 
244     function freeze(address target, bool freeze) onlyOwner {
245         frozenAccount[target] = freeze;
246         FrozenFunds(target, freeze);
247     }
248 
249     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
250         sellPrice = newSellPrice;
251         buyPrice = newBuyPrice;
252     }
253 
254     function buy() payable {
255         uint amount = msg.value / buyPrice;                // calculates the amount
256         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
257         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
258         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
259         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
260     }
261 
262     function sell(uint256 amount) {
263         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
264         balanceOf[this] += amount;                         // adds the amount to owner's balance
265         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
266         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
267             throw;                                         // to do this last to avoid recursion attacks
268         } else {
269             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
270         }
271     }
272 }
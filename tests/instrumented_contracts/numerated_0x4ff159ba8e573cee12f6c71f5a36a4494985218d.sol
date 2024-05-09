1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract owned {
31     address public owner;
32 
33     function owned() {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         if (msg.sender != owner) throw;
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner {
43         owner = newOwner;
44     }
45 }
46 
47 
48 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
49 
50 contract token {
51     /* Public variables of the token */
52     string public standard = "Viacash Token";
53     string public name;
54     string public symbol;
55     uint8 public decimals;
56     uint256 public totalSupply;
57 
58     /* This creates an array with all balances */
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     /* This generates a public event on the blockchain that will notify clients */
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     /* Initializes contract with initial supply tokens to the creator of the contract */
66     function token(
67         uint256 initialSupply,
68         string tokenName,
69         uint8 decimalUnits,
70         string tokenSymbol
71         ) {
72         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
73         totalSupply = initialSupply;                        // Update total supply
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77     }
78 
79     /* Send coins */
80     function transfer(address _to, uint256 _value) {
81         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
82         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
83         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
84         balanceOf[_to] += _value;                            // Add the same to the recipient
85         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
86     }
87 
88     /* Allow another contract to spend some tokens in your behalf */
89     function approve(address _spender, uint256 _value)
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /* Approve and then communicate the approved contract in a single tx */
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
97         returns (bool success) {
98         tokenRecipient spender = tokenRecipient(_spender);
99         if (approve(_spender, _value)) {
100             spender.receiveApproval(msg.sender, _value, this, _extraData);
101             return true;
102         }
103     }
104 
105     /* A contract attempts _ to get the coins */
106     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
107         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
108         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
109         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
110         balanceOf[_from] -= _value;                          // Subtract from the sender
111         balanceOf[_to] += _value;                            // Add the same to the recipient
112         allowance[_from][msg.sender] -= _value;
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /* This unnamed function is called whenever someone tries to send ether to it */
118     function () {
119         throw;     // Prevents accidental sending of ether
120     }
121 }
122 
123 contract ViacashToken is owned, token {
124 
125     uint256 public sellPrice;
126     uint256 public buyPrice;
127 
128     mapping(address=>bool) public frozenAccount;
129 
130 
131     /* This generates a public event on the blockchain that will notify clients */
132     event FrozenFunds(address target, bool frozen);
133 
134     /* Initializes contract with initial supply tokens to the creator of the contract */
135     uint256 public constant initialSupply = 12000000000 * 10**18;
136     uint8 public constant decimalUnits = 18;
137     string public tokenName = "ViacashToken";
138     string public tokenSymbol = "Viacash";
139     function ViacashToken() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
140      /* Send coins */
141     function transfer(address _to, uint256 _value) {
142         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
143         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
144         if (frozenAccount[msg.sender]) throw;                // Check if frozen
145         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
146         balanceOf[_to] += _value;                            // Add the same to the recipient
147         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
148     }
149 
150 
151     /* A contract attempts to get the coins */
152     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
153         if (frozenAccount[_from]) throw;                        // Check if frozen
154         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
155         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
156         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
157         balanceOf[_from] -= _value;                          // Subtract from the sender
158         balanceOf[_to] += _value;                            // Add the same to the recipient
159         allowance[_from][msg.sender] -= _value;
160         Transfer(_from, _to, _value);
161         return true;
162     }
163 
164     function mintToken(address target, uint256 mintedAmount) onlyOwner {
165         balanceOf[target] += mintedAmount;
166         totalSupply += mintedAmount;
167         Transfer(0, this, mintedAmount);
168         Transfer(this, target, mintedAmount);
169     }
170 
171     function freezeAccount(address target, bool freeze) onlyOwner {
172         frozenAccount[target] = freeze;
173         FrozenFunds(target, freeze);
174     }
175 
176     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
177         sellPrice = newSellPrice;
178         buyPrice = newBuyPrice;
179     }
180 
181     function buy() payable {
182         uint amount = msg.value / buyPrice;                // calculates the amount
183         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
184         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
185         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
186         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
187     }
188 
189     function sell(uint256 amount) {
190         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
191         balanceOf[this] += amount;                         // adds the amount to owner's balance
192         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
193         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
194             throw;                                         // to do this last to avoid recursion attacks
195         } else {
196             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
197         }
198     }
199 }
200 
201 contract Ownable {
202   address public owner;
203   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   constructor() public{
209     owner = msg.sender;
210   }
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(msg.sender == owner);
216     _;
217   }
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) onlyOwner public {
223     require(newOwner != address(0));
224     emit OwnershipTransferred(owner, newOwner);
225     owner = newOwner;
226   }
227 }
228 
229 /**
230  * @title Crowdsale
231  * @dev Crowdsale is a base contract for managing a token crowdsale.
232  * Crowdsales have a start and end timestamps, where investors can make
233  * token purchases and the crowdsale will assign them tokens based
234  * on a token per ETH rate. Funds collected are forwarded to a wallet
235  * as they arrive.
236  */
237 contract Crowdsale is Ownable {
238   using SafeMath for uint256;
239 
240   // The token being sold
241   token myToken;
242   
243   // address where funds are collected
244   address public wallet;
245   
246   // rate => tokens per ether
247   uint256 public rate = 10000000 ; 
248 
249   // amount of raised money in wei
250   uint256 public weiRaised;
251 
252   /**
253    * event for token purchase logging
254    * @param beneficiary who got the tokens
255    * @param value weis paid for purchase
256    * @param amount amount of tokens purchased
257    */
258   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
259 
260 
261   constructor(address tokenContractAddress, address _walletAddress) public{
262     wallet = _walletAddress;
263     myToken = token(tokenContractAddress);
264   }
265 
266   // fallback function can be used to buy tokens
267   function () payable public{
268     buyTokens(msg.sender);
269   }
270 
271   function getBalance() public constant returns(uint256){
272       return myToken.balanceOf(this);
273   }    
274 
275   // low level token purchase function
276   function buyTokens(address beneficiary) public payable {
277     require(beneficiary != 0x0);
278     require(msg.value >= 10000000000000000);// min contribution 0.01ETH
279     require(msg.value <= 1000000000000000000);// max contribution 1ETH
280 
281     uint256 weiAmount = msg.value;
282 
283     // calculate token amount to be created
284     uint256 tokens = weiAmount.mul(rate).div(100);
285 
286     // update state
287     weiRaised = weiRaised.add(weiAmount);
288 
289     myToken.transfer(beneficiary, tokens);
290 
291     emit TokenPurchase(beneficiary, weiAmount, tokens);
292   }
293 
294   // to change rate
295   function updateRate(uint256 new_rate) onlyOwner public{
296     rate = new_rate;
297   }
298 
299 
300   // send ether to the fund collection wallet
301   // override to create custom fund forwarding mechanisms
302   function forwardFunds() onlyOwner public {
303     wallet.transfer(address(this).balance);
304   }
305 
306   function transferBackTo(uint256 tokens, address beneficiary) onlyOwner public returns (bool){
307     myToken.transfer(beneficiary, tokens);
308     return true;
309   }
310 
311 }
1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) onlyOwner public {
62     if (newOwner != address(0)) {
63       owner = newOwner;
64     }
65   }
66 
67 }
68 
69 
70 /**
71  * @title tokenRecipient
72  * @dev An interface capable of calling `receiveApproval`, which is used by `approveAndCall` to notify the contract from this interface
73  */
74 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
75 
76 
77 /**
78  * @title TokenERC20
79  * @author Jun-You Liu, Ping Chen
80  * @dev A simple ERC20 standard token with burnable function
81  */
82 contract TokenERC20 {
83   using SafeMath for uint256;
84 
85   uint256 public totalSupply;
86   bool public transferable;
87 
88   // This creates an array with all balances
89   mapping(address => uint256) public balances;
90   mapping(address => mapping(address => uint256)) public allowed;
91 
92   // This notifies clients about the amount burnt
93   event Burn(address indexed from, uint256 value);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 
97   function balanceOf(address _owner) view public returns(uint256) {
98     return balances[_owner];
99   }
100 
101   function allowance(address _owner, address _spender) view public returns(uint256) {
102     return allowed[_owner][_spender];
103   }
104 
105   /**
106    * @dev Basic transfer of all transfer-related functions
107    * @param _from The address of sender
108    * @param _to The address of recipient
109    * @param _value The amount sender want to transfer to recipient
110    */
111   function _transfer(address _from, address _to, uint _value) internal {
112   	require(transferable);
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer( _from, _to, _value);
116   }
117 
118   /**
119    * @notice Transfer tokens
120    * @dev Send `_value` tokens to `_to` from your account
121    * @param _to The address of the recipient
122    * @param _value The amount to send
123    * @return True if the transfer is done without error
124    */
125   function transfer(address _to, uint256 _value) public returns(bool) {
126     _transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @notice Transfer tokens from other address
132    * @dev Send `_value` tokens to `_to` on behalf of `_from`
133    * @param _from The address of the sender
134    * @param _to The address of the recipient
135    * @param _value The amount to send
136    * @return True if the transfer is done without error
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     _transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @notice Set allowance for other address
146    * @dev Allows `_spender` to spend no more than `_value` tokens on your behalf
147    * @param _spender The address authorized to spend
148    * @param _value the max amount they can spend
149    * @return True if the approval is done without error
150    */
151   function approve(address _spender, uint256 _value) public returns(bool) {
152     // Avoid the front-running attack
153     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154     allowed[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @notice Set allowance for other address and notify
161    * @dev Allows contract `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
162    * @param _spender The contract address authorized to spend
163    * @param _value the max amount they can spend
164    * @param _extraData some extra information to send to the approved contract
165    * @return True if it is done without error
166    */
167   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
168     tokenRecipient spender = tokenRecipient(_spender);
169     if (approve(_spender, _value)) {
170       spender.receiveApproval(msg.sender, _value, this, _extraData);
171       return true;
172     }
173     return false;
174   }
175 
176   /**
177    * @notice Destroy tokens
178    * @dev Remove `_value` tokens from the system irreversibly
179    * @param _value The amount of money will be burned
180    * @return True if `_value` is burned successfully
181    */
182   function burn(uint256 _value) public returns(bool) {
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     totalSupply = totalSupply.sub(_value);
185     emit Burn(msg.sender, _value);
186     return true;
187   }
188 
189   /**
190    * @notice Destroy tokens from other account
191    * @dev Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192    * @param _from The address of the sender
193    * @param _value The amount of money will be burned
194    * @return True if `_value` is burned successfully
195    */
196   function burnFrom(address _from, uint256 _value) public returns(bool) {
197     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198     balances[_from] = balances[_from].sub(_value);
199     totalSupply = totalSupply.sub(_value);
200     emit Burn(_from, _value);
201     return true;
202   }
203 }
204 
205 
206 /**
207  * @title AIgathaToken
208  * @author Jun-You Liu, Ping Chen, (auditors Hans Lin, Luka Chen)
209  * @dev The AIgatha Token which is comply with burnable erc20 standard, referred to Cobinhood token contract: https://etherscan.io/address/0xb2f7eb1f2c37645be61d73953035360e768d81e6#code
210  */
211 contract AIgathaToken is TokenERC20, Ownable {
212   using SafeMath for uint256;
213 
214   // Token Info.
215   string public constant name = "AIgatha Token";
216   string public constant symbol = "ATH";
217   uint8 public constant decimals = 18;
218 
219   // Sales period.
220   uint256 public startDate;
221   uint256 public endDate;
222 
223   // Token Cap for each rounds
224   uint256 public saleCap;
225 
226   // Address where funds are collected.
227   address public wallet;
228 
229   // Amount of raised money in wei.
230   uint256 public weiRaised;
231 
232   // Threshold of sold amount
233   uint256 public threshold;
234 
235   // Whether in the extended period
236   bool public extended;
237 
238   // Event
239   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
240   event PreICOTokenPushed(address indexed buyer, uint256 amount);
241   event UserIDChanged(address owner, bytes32 user_id);
242 
243   /**
244    * @dev Constructor of Aigatha Token
245    * @param _wallet The address where funds are collected
246    * @param _saleCap The token cap in public round
247    * @param _totalSupply The total amount of token
248    * @param _threshold The percentage of selling amount need to achieve at least e.g. 40% -> _threshold = 40
249    * @param _start The start date in seconds
250    * @param _end The end date in seconds
251    */
252   function AIgathaToken(address _wallet, uint256 _saleCap, uint256 _totalSupply, uint256 _threshold, uint256 _start, uint256 _end) public {
253     wallet = _wallet;
254     saleCap = _saleCap * (10 ** uint256(decimals));
255     totalSupply = _totalSupply * (10 ** uint256(decimals));
256     startDate = _start;
257     endDate = _end;
258 
259     threshold = _threshold * totalSupply / 2 / 100;
260     balances[0xbeef] = saleCap;
261     balances[wallet] = totalSupply.sub(saleCap);
262   }
263 
264   function supply() internal view returns (uint256) {
265     return balances[0xbeef];
266   }
267 
268   function saleActive() public view returns (bool) {
269     return (now >= startDate &&
270             now <= endDate && supply() > 0);
271   }
272 
273   function extendSaleTime() onlyOwner public {
274     require(!saleActive());
275     require(!extended);
276     require((saleCap-supply()) < threshold); //check
277     extended = true;
278     endDate += 60 days;
279   }
280 
281   /**
282    * @dev Get the rate of exchange according to the purchase date
283    * @param at The date converted into seconds
284    * @return The corresponding rate
285    */
286   function getRateAt(uint256 at) public view returns (uint256) {
287     if (at < startDate) {
288       return 0;
289     }
290     else if (at < (startDate + 15 days)) { //check
291       return 10500;
292     }
293     else {
294       return 10000;
295     }
296   }
297 
298   /**
299    * @dev Fallback function can be used to buy tokens
300    */
301   function () payable public{
302     buyTokens(msg.sender, msg.value);
303   }
304 
305   /**
306    * @dev For pushing pre-ICO records
307    * @param buyer The address of buyer in pre-ICO
308    * @param amount The amount of token bought
309    */
310   function push(address buyer, uint256 amount) onlyOwner public {
311     require(balances[wallet] >= amount);
312     balances[wallet] = balances[wallet].sub(amount);
313     balances[buyer] = balances[buyer].add(amount);
314     emit PreICOTokenPushed(buyer, amount);
315   }
316 
317   /**
318    * @dev Buy tokens
319    * @param sender The address of buyer
320    * @param value The amount of token bought
321    */
322   function buyTokens(address sender, uint256 value) internal {
323     require(saleActive());
324 
325     uint256 weiAmount = value;
326     uint256 updatedWeiRaised = weiRaised.add(weiAmount);
327 
328     // Calculate token amount to be purchased
329     uint256 actualRate = getRateAt(now);
330     uint256 amount = weiAmount.mul(actualRate);
331 
332     // We have enough token to sale
333     require(supply() >= amount);
334 
335     // Transfer
336     balances[0xbeef] = balances[0xbeef].sub(amount);
337     balances[sender] = balances[sender].add(amount);
338     emit TokenPurchase(sender, weiAmount, amount);
339 
340     // Update state.
341     weiRaised = updatedWeiRaised;
342   }
343 
344   /**
345    * @dev Withdraw all ether in this contract back to the wallet
346    */
347   function withdraw() onlyOwner public {
348     wallet.transfer(address(this).balance);
349   }
350 
351   /**
352    * @dev Collect all the remain token which is unsold after the selling period and make this token can be tranferred
353    */
354   function finalize() onlyOwner public {
355     require(!saleActive());
356     balances[wallet] = balances[wallet].add(balances[0xbeef]);
357     balances[0xbeef] = 0;
358     transferable = true;
359   }
360 }
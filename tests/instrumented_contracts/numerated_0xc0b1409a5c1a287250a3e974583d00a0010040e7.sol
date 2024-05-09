1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 contract ERC20 {
37   uint256 _totalSupply;
38   function totalSupply() constant returns (uint256 totalSupply);
39   function balanceOf(address _owner) constant returns (uint balance);
40   function transfer(address _to, uint _value) returns (bool success);
41   function transferFrom(address _from, address _to, uint _value) returns (bool success);
42   function approve(address _spender, uint _value) returns (bool success);
43   function allowance(address _owner, address _spender) constant returns (uint remaining);
44   event Transfer(address indexed _from, address indexed _to, uint _value);
45   event Approval(address indexed _owner, address indexed _spender, uint _value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20 {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   // Owner of account approves the transfer of an amount to another account
58   mapping(address => mapping (address => uint256)) allowed;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) returns (bool success) {
66     if (balances[msg.sender] >= _value
67     && _value > 0
68     && balances[_to] + _value > balances[_to]) {
69       balances[msg.sender] -= _value;
70       balances[_to] += _value;
71       Transfer(msg.sender, _to, _value);
72       return true;
73     } else {
74       return false;
75     }
76   }
77 
78   // Send _value amount of tokens from address _from to address _to
79   // The transferFrom method is used for a withdraw workflow, allowing contracts to send
80   // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
81   // fees in sub-currencies; the command should fail unless the _from account has
82   // deliberately authorized the sender of the message via some mechanism; we propose
83   // these standardized APIs for approval:
84   function transferFrom(address _from,address _to, uint256 _amount) returns (bool success) {
85     if (balances[_from] >= _amount
86     && allowed[_from][msg.sender] >= _amount
87     && _amount > 0
88     && balances[_to] + _amount > balances[_to]) {
89       balances[_from] -= _amount;
90       allowed[_from][msg.sender] -= _amount;
91       balances[_to] += _amount;
92       return true;
93     } else {
94       return false;
95     }
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) constant returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107   function totalSupply() constant returns (uint256 totalSupply) {
108     totalSupply = _totalSupply;
109   }
110 
111 }
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amout of tokens to be transfered
131    */
132   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
133     var _allowance = allowed[_from][msg.sender];
134 
135     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136     // require (_value <= _allowance);
137 
138     balances[_to] = balances[_to].add(_value);
139     balances[_from] = balances[_from].sub(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) returns (bool success) {
151     allowed[msg.sender][_spender] = _value;
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifing the amount of tokens still avaible for the spender.
160    */
161   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
162     return allowed[_owner][_spender];
163   }
164 
165 }
166 
167 /**
168  * @title Ownable
169  * @dev The Ownable contract has an owner address, and provides basic authorization control
170  * functions, this simplifies the implementation of "user permissions".
171  */
172 contract Ownable {
173   address public owner;
174 
175 
176   /**
177    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
178    * account.
179    */
180   function Ownable() {
181     owner = msg.sender;
182   }
183 
184 
185   /**
186    * @dev Throws if called by any account other than the owner.
187    */
188   // Functions with this modifier can only be executed by the owner
189 
190   modifier onlyOwner() {
191     if (msg.sender != owner) {
192       revert();
193     }
194     _;
195   }
196 
197 
198   /**
199    * @dev Allows the current owner to transfer control of the contract to a newOwner.
200    * @param newOwner The address to transfer ownership to.
201    */
202   function transferOwnership(address newOwner) onlyOwner {
203     if (newOwner != address(0)) {
204       owner = newOwner;
205     }
206   }
207 
208 }
209 
210 
211 
212 /**
213  * @title Mintable token
214  * @dev Simple ERC20 Token example, with mintable token creation
215  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
216  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
217  */
218 
219 contract MintableToken is StandardToken, Ownable {
220   event Mint(address indexed to, uint256 amount);
221   event MintFinished();
222 
223   bool public mintingFinished = false;
224 
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will recieve the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
238     _totalSupply = _totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     Mint(_to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() onlyOwner returns (bool) {
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 }
254 
255 contract NatCoin is MintableToken {
256   string public constant name = "NATCOIN";
257   string public constant symbol = "NTC";
258   uint256 public constant decimals = 18;
259 }
260 
261 /**
262  * @title Crowdsale
263  * @dev Crowdsale is a base contract for managing a token crowdsale.
264  * Crowdsales have a start and end block, where investors can make
265  * token purchases and the crowdsale will assign them tokens based
266  * on a token per ETH rate. Funds collected are forwarded to a wallet
267  * as they arrive.
268  */
269 contract Crowdsale {
270   using SafeMath for uint256;
271 
272   // The token being sold
273   MintableToken public token;
274 
275   // start and end block where investments are allowed (both inclusive)
276   uint256 public startBlock;
277   uint256 public endBlock;
278 
279   // address where funds are collected
280   address public wallet;
281 
282   // how many token units a buyer gets per wei
283   uint256 public rate;
284 
285   // amount of raised money in wei
286   uint256 public weiRaised;
287 
288   /**
289    * event for token purchase logging
290    * @param purchaser who paid for the tokens
291    * @param beneficiary who got the tokens
292    * @param value weis paid for purchase
293    * @param amount amount of tokens purchased
294    */
295   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
296 
297 
298   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
299     require(_startBlock >= block.number);
300     require(_endBlock >= _startBlock);
301     require(_rate > 0);
302     require(_wallet != 0x0);
303 
304     token = createTokenContract();
305     startBlock = _startBlock;
306     endBlock = _endBlock;
307     rate = _rate;
308     wallet = _wallet;
309   }
310 
311   // creates the token to be sold.
312   // override this method to have crowdsale of a specific mintable token.
313   function createTokenContract() internal returns (MintableToken) {
314     return new MintableToken();
315   }
316 
317 
318   // fallback function can be used to buy tokens
319   function () payable {
320     buyTokens(msg.sender);
321   }
322 
323   // low level token purchase function
324   function buyTokens(address beneficiary) payable {
325     require(beneficiary != 0x0);
326     require(validPurchase());
327 
328     uint256 weiAmount = msg.value;
329 
330     // calculate token amount to be created
331     uint256 tokens = weiAmount.mul(rate);
332 
333     // update state
334     weiRaised = weiRaised.add(weiAmount);
335 
336     token.mint(beneficiary, tokens);
337     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
338 
339     forwardFunds();
340   }
341 
342   // send ether to the fund collection wallet
343   // override to create custom fund forwarding mechanisms
344   function forwardFunds() internal {
345     wallet.transfer(msg.value);
346   }
347 
348   // @return true if the transaction can buy tokens
349   function validPurchase() internal constant returns (bool) {
350     uint256 current = block.number;
351     bool withinPeriod = current >= startBlock && current <= endBlock;
352     bool nonZeroPurchase = msg.value != 0;
353     return withinPeriod && nonZeroPurchase;
354   }
355 
356   // @return true if crowdsale event has ended
357   function hasEnded() public constant returns (bool) {
358     return block.number > endBlock;
359   }
360 
361 
362 }
363 
364 
365 contract NatCoinCrowdsale is Crowdsale, Ownable {
366 
367   uint256 public icoSupply;
368   uint256 public reserveSupply;
369   uint256 public paymentSupply;
370   uint256 public coreSupply;
371   uint256 public reveralSupply;
372 
373   uint256 public usedIcoSupply;
374   uint256 public usedReserveSupply;
375   uint256 public usedPaymentSupply;
376   uint256 public usedCoreSupply;
377   uint256 public usedReveralSupply;
378 
379   function getIcoSupply() public returns(uint256) { return icoSupply; }
380   function getReserveSupply() public returns(uint256) { return reserveSupply; }
381   function getPaymentSupply() public returns(uint256) { return paymentSupply; }
382   function getCoreSupply() public returns(uint256) { return coreSupply; }
383   function getReveralSupply() public returns(uint256) { return reveralSupply; }
384 
385   function getUsedReserveSupply() public returns(uint256) { return usedReserveSupply; }
386   function getUsedPaymentSupply() public returns(uint256) { return usedPaymentSupply; }
387   function getUsedCoreSupply() public returns(uint256) { return usedCoreSupply; }
388   function getUsedReveralSupply() public returns(uint256) { return usedReveralSupply; }
389 
390   NatCoin natcoinTokenContract;
391 
392   function NatCoinCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) Crowdsale(_startBlock, _endBlock, _rate, _wallet) {
393     icoSupply =      5000000 * 10**17;
394     reserveSupply =  8000000 * 10**17;
395     paymentSupply = 11000000 * 10**17;
396     coreSupply =    10500000 * 10**17;
397     reveralSupply =   500000 * 10**17;
398   }
399 
400   // creates the token to be sold.
401   // override this method to have crowdsale of a specific MintableToken token.
402   function createTokenContract() internal returns (MintableToken) {
403     return new NatCoin();
404   }
405 
406   function claimReservedTokens(address _to, uint256 _amount) payable onlyOwner {
407     if (_amount > reserveSupply - usedReserveSupply) revert();
408     token.mint(_to, _amount);
409     reserveSupply += _amount;
410   }
411 
412   function claimPaymentTokens(address _to, uint256 _amount) payable onlyOwner {
413     if (_amount > paymentSupply - usedPaymentSupply) revert();
414     token.mint(_to, _amount);
415     paymentSupply += _amount;
416   }
417 
418   function claimCoreTokens(address _to, uint256 _amount) payable onlyOwner {
419     if (_amount > coreSupply - usedCoreSupply) revert();
420     natcoinTokenContract.mint(_to, _amount);
421     coreSupply += _amount;
422   }
423 
424   function claimReveralTokens(address _to, uint256 _amount) payable onlyOwner {
425     if (_amount > reveralSupply - usedReveralSupply) revert();
426     natcoinTokenContract.mint(_to, _amount);
427     reveralSupply += _amount;
428   }
429 
430 }
1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     Transfer(address(0), _to, _amount);
281     return true;
282   }
283 
284   /**
285    * @dev Function to stop minting new tokens.
286    * @return True if the operation was successful.
287    */
288   function finishMinting() onlyOwner canMint public returns (bool) {
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 }
294 
295 
296 /**
297  * @title Crowdsale
298  * @dev Crowdsale is a base contract for managing a token crowdsale.
299  * Crowdsales have a start and end timestamps, where investors can make
300  * token purchases and the crowdsale will assign them tokens based
301  * on a token per ETH rate. Funds collected are forwarded to a wallet
302  * as they arrive. The contract requires a MintableToken that will be
303  * minted as contributions arrive, note that the crowdsale contract
304  * must be owner of the token in order to be able to mint it.
305  */
306 contract Crowdsale {
307   using SafeMath for uint256;
308 
309   // The token being sold
310   MintableToken public token;
311 
312   // start and end timestamps where investments are allowed (both inclusive)
313   uint256 public startTime;
314   uint256 public endTime;
315 
316   // address where funds are collected
317   address public wallet;
318 
319   // how many token units a buyer gets per wei
320   uint256 public rate;
321 
322   // amount of raised money in wei
323   uint256 public weiRaised;
324 
325   /**
326    * event for token purchase logging
327    * @param purchaser who paid for the tokens
328    * @param beneficiary who got the tokens
329    * @param value weis paid for purchase
330    * @param amount amount of tokens purchased
331    */
332   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
333 
334 
335   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
336     require(_startTime >= now);
337     require(_endTime >= _startTime);
338     require(_rate > 0);
339     require(_wallet != address(0));
340     require(_token != address(0));
341 
342     startTime = _startTime;
343     endTime = _endTime;
344     rate = _rate;
345     wallet = _wallet;
346     token = _token;
347   }
348 
349   // fallback function can be used to buy tokens
350   function () external payable {
351     buyTokens(msg.sender);
352   }
353 
354   // low level token purchase function
355   function buyTokens(address beneficiary) public payable {
356     require(beneficiary != address(0));
357     require(validPurchase());
358 
359     uint256 weiAmount = msg.value;
360 
361     // calculate token amount to be created
362     uint256 tokens = getTokenAmount(weiAmount);
363 
364     // update state
365     weiRaised = weiRaised.add(weiAmount);
366 
367     token.mint(beneficiary, tokens);
368     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
369 
370     forwardFunds();
371   }
372 
373   // @return true if crowdsale event has ended
374   function hasEnded() public view returns (bool) {
375     return now > endTime;
376   }
377 
378   // Override this method to have a way to add business logic to your crowdsale when buying
379   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
380     return weiAmount.mul(rate);
381   }
382 
383   // send ether to the fund collection wallet
384   // override to create custom fund forwarding mechanisms
385   function forwardFunds() internal {
386     wallet.transfer(msg.value);
387   }
388 
389   // @return true if the transaction can buy tokens
390   function validPurchase() internal view returns (bool) {
391     bool withinPeriod = now >= startTime && now <= endTime;
392     bool nonZeroPurchase = msg.value != 0;
393     return withinPeriod && nonZeroPurchase;
394   }
395 
396 }
397 
398 /**
399  * @title CappedCrowdsale
400  * @dev Extension of Crowdsale with a max amount of funds raised
401  */
402 contract CappedCrowdsale is Crowdsale {
403   using SafeMath for uint256;
404 
405   uint256 public cap;
406 
407   function CappedCrowdsale(uint256 _cap) public {
408     require(_cap > 0);
409     cap = _cap;
410   }
411 
412   // overriding Crowdsale#hasEnded to add cap logic
413   // @return true if crowdsale event has ended
414   function hasEnded() public view returns (bool) {
415     bool capReached = weiRaised >= cap;
416     return capReached || super.hasEnded();
417   }
418 
419   // overriding Crowdsale#validPurchase to add extra cap logic
420   // @return true if investors can buy at the moment
421   function validPurchase() internal view returns (bool) {
422     bool withinCap = weiRaised.add(msg.value) <= cap;
423     return withinCap && super.validPurchase();
424   }
425 
426 }
427 
428 
429 /**
430  * @title Capped token
431  * @dev Mintable token with a token cap.
432  */
433 contract CappedToken is MintableToken {
434 
435   uint256 public cap;
436 
437   function CappedToken(uint256 _cap) public {
438     require(_cap > 0);
439     cap = _cap;
440   }
441 
442   /**
443    * @dev Function to mint tokens
444    * @param _to The address that will receive the minted tokens.
445    * @param _amount The amount of tokens to mint.
446    * @return A boolean that indicates if the operation was successful.
447    */
448   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
449     require(totalSupply_.add(_amount) <= cap);
450 
451     return super.mint(_to, _amount);
452   }
453 
454 }
455 
456 /**
457  * @title SafeERC20
458  * @dev Wrappers around ERC20 operations that throw on failure.
459  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
460  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
461  */
462 library SafeERC20 {
463   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
464     assert(token.transfer(to, value));
465   }
466 
467   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
468     assert(token.transferFrom(from, to, value));
469   }
470 
471   function safeApprove(ERC20 token, address spender, uint256 value) internal {
472     assert(token.approve(spender, value));
473   }
474 }
475 
476 contract YHWH is MintableToken {
477   string public name = "Yahweh";
478   string public symbol = "YHWH";
479   uint8 public decimals = 18;
480 }
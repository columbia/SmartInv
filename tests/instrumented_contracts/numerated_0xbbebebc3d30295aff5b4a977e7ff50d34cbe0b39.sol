1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70   /**
71   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 /**
87  * @title Crowdsale
88  * @dev Crowdsale is a base contract for managing a token crowdsale.
89  * Crowdsales have a start and end timestamps, where investors can make
90  * token purchases and the crowdsale will assign them tokens based
91  * on a token per ETH rate. Funds collected are forwarded to a wallet
92  * as they arrive.
93  */
94 contract Crowdsale {
95   using SafeMath for uint256;
96   // The token being sold
97   MintableToken public token;
98   // start and end timestamps where investments are allowed (both inclusive)
99   uint256 public startTime;
100   uint256 public endTime;
101   // address where funds are collected
102   address public wallet;
103   // how many token units a buyer gets per wei
104   uint256 public rate;
105   // amount of raised money in wei
106   uint256 public weiRaised;
107   /**
108    * event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
116     require(_startTime >= now);
117     require(_endTime >= _startTime);
118     require(_rate > 0);
119     require(_wallet != address(0));
120     token = createTokenContract();
121     startTime = _startTime;
122     endTime = _endTime;
123     rate = _rate;
124     wallet = _wallet;
125   }
126   // fallback function can be used to buy tokens
127   function () external payable {
128     buyTokens(msg.sender);
129   }
130   // low level token purchase function
131   function buyTokens(address beneficiary) public payable {
132     require(beneficiary != address(0));
133     require(validPurchase());
134     uint256 weiAmount = msg.value;
135     // calculate token amount to be created
136     uint256 tokens = getTokenAmount(weiAmount);
137     // update state
138     weiRaised = weiRaised.add(weiAmount);
139     token.mint(beneficiary, tokens);
140     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141     forwardFunds();
142   }
143   // @return true if crowdsale event has ended
144   function hasEnded() public view returns (bool) {
145     return now > endTime;
146   }
147   // creates the token to be sold.
148   // override this method to have crowdsale of a specific mintable token.
149   function createTokenContract() internal returns (MintableToken) {
150     return new MintableToken();
151   }
152   // Override this method to have a way to add business logic to your crowdsale when buying
153   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
154     return weiAmount.mul(rate);
155   }
156   // send ether to the fund collection wallet
157   // override to create custom fund forwarding mechanisms
158   function forwardFunds() internal {
159     wallet.transfer(msg.value);
160   }
161   // @return true if the transaction can buy tokens
162   function validPurchase() internal view returns (bool) {
163     bool withinPeriod = now >= startTime && now <= endTime;
164     bool nonZeroPurchase = msg.value != 0;
165     return withinPeriod && nonZeroPurchase;
166   }
167 }
168 /**
169  * @title CappedCrowdsale
170  * @dev Extension of Crowdsale with a max amount of funds raised
171  */
172 contract CappedCrowdsale is Crowdsale {
173   using SafeMath for uint256;
174   uint256 public cap;
175   function CappedCrowdsale(uint256 _cap) public {
176     require(_cap > 0);
177     cap = _cap;
178   }
179   // overriding Crowdsale#hasEnded to add cap logic
180   // @return true if crowdsale event has ended
181   function hasEnded() public view returns (bool) {
182     bool capReached = weiRaised >= cap;
183     return capReached || super.hasEnded();
184   }
185   // overriding Crowdsale#validPurchase to add extra cap logic
186   // @return true if investors can buy at the moment
187   function validPurchase() internal view returns (bool) {
188     bool withinCap = weiRaised.add(msg.value) <= cap;
189     return withinCap && super.validPurchase();
190   }
191 }
192 /**
193  * @title FinalizableCrowdsale
194  * @dev Extension of Crowdsale where an owner can do extra work
195  * after finishing.
196  */
197 contract FinalizableCrowdsale is Crowdsale, Ownable {
198   using SafeMath for uint256;
199   bool public isFinalized = false;
200   event Finalized();
201   /**
202    * @dev Must be called after crowdsale ends, to do some extra finalization
203    * work. Calls the contract's finalization function.
204    */
205   function finalize() onlyOwner public {
206     require(!isFinalized);
207     require(hasEnded());
208     finalization();
209     Finalized();
210     isFinalized = true;
211   }
212   /**
213    * @dev Can be overridden to add finalization logic. The overriding function
214    * should call super.finalization() to ensure the chain of finalization is
215    * executed entirely.
216    */
217   function finalization() internal {
218   }
219 }
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225   event Pause();
226   event Unpause();
227   bool public paused = false;
228   /**
229    * @dev Modifier to make a function callable only when the contract is not paused.
230    */
231   modifier whenNotPaused() {
232     require(!paused);
233     _;
234   }
235   /**
236    * @dev Modifier to make a function callable only when the contract is paused.
237    */
238   modifier whenPaused() {
239     require(paused);
240     _;
241   }
242   /**
243    * @dev called by the owner to pause, triggers stopped state
244    */
245   function pause() onlyOwner whenNotPaused public {
246     paused = true;
247     Pause();
248   }
249   /**
250    * @dev called by the owner to unpause, returns to normal state
251    */
252   function unpause() onlyOwner whenPaused public {
253     paused = false;
254     Unpause();
255   }
256 }
257 /**
258  * @title Basic token
259  * @dev Basic version of StandardToken, with no allowances.
260  */
261 contract BasicToken is ERC20Basic {
262   using SafeMath for uint256;
263   mapping(address => uint256) balances;
264   uint256 totalSupply_;
265   /**
266   * @dev total number of tokens in existence
267   */
268   function totalSupply() public view returns (uint256) {
269     return totalSupply_;
270   }
271   /**
272   * @dev transfer token for a specified address
273   * @param _to The address to transfer to.
274   * @param _value The amount to be transferred.
275   */
276   function transfer(address _to, uint256 _value) public returns (bool) {
277     require(_to != address(0));
278     require(_value <= balances[msg.sender]);
279     // SafeMath.sub will throw if there is not enough balance.
280     balances[msg.sender] = balances[msg.sender].sub(_value);
281     balances[_to] = balances[_to].add(_value);
282     Transfer(msg.sender, _to, _value);
283     return true;
284   }
285   /**
286   * @dev Gets the balance of the specified address.
287   * @param _owner The address to query the the balance of.
288   * @return An uint256 representing the amount owned by the passed address.
289   */
290   function balanceOf(address _owner) public view returns (uint256 balance) {
291     return balances[_owner];
292   }
293 }
294 /**
295  * @title ERC20 interface
296  * @dev see https://github.com/ethereum/EIPs/issues/20
297  */
298 contract ERC20 is ERC20Basic {
299   function allowance(address owner, address spender) public view returns (uint256);
300   function transferFrom(address from, address to, uint256 value) public returns (bool);
301   function approve(address spender, uint256 value) public returns (bool);
302   event Approval(address indexed owner, address indexed spender, uint256 value);
303 }
304 /**
305  * @title Standard ERC20 token
306  *
307  * @dev Implementation of the basic standard token.
308  * @dev https://github.com/ethereum/EIPs/issues/20
309  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
310  */
311 contract StandardToken is ERC20, BasicToken {
312   mapping (address => mapping (address => uint256)) internal allowed;
313   /**
314    * @dev Transfer tokens from one address to another
315    * @param _from address The address which you want to send tokens from
316    * @param _to address The address which you want to transfer to
317    * @param _value uint256 the amount of tokens to be transferred
318    */
319   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
320     require(_to != address(0));
321     require(_value <= balances[_from]);
322     require(_value <= allowed[_from][msg.sender]);
323     balances[_from] = balances[_from].sub(_value);
324     balances[_to] = balances[_to].add(_value);
325     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
326     Transfer(_from, _to, _value);
327     return true;
328   }
329   /**
330    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
331    *
332    * Beware that changing an allowance with this method brings the risk that someone may use both the old
333    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
334    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
335    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336    * @param _spender The address which will spend the funds.
337    * @param _value The amount of tokens to be spent.
338    */
339   function approve(address _spender, uint256 _value) public returns (bool) {
340     allowed[msg.sender][_spender] = _value;
341     Approval(msg.sender, _spender, _value);
342     return true;
343   }
344   /**
345    * @dev Function to check the amount of tokens that an owner allowed to a spender.
346    * @param _owner address The address which owns the funds.
347    * @param _spender address The address which will spend the funds.
348    * @return A uint256 specifying the amount of tokens still available for the spender.
349    */
350   function allowance(address _owner, address _spender) public view returns (uint256) {
351     return allowed[_owner][_spender];
352   }
353   /**
354    * @dev Increase the amount of tokens that an owner allowed to a spender.
355    *
356    * approve should be called when allowed[_spender] == 0. To increment
357    * allowed value is better to use this function to avoid 2 calls (and wait until
358    * the first transaction is mined)
359    * From MonolithDAO Token.sol
360    * @param _spender The address which will spend the funds.
361    * @param _addedValue The amount of tokens to increase the allowance by.
362    */
363   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
364     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
365     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
366     return true;
367   }
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
379     uint oldValue = allowed[msg.sender][_spender];
380     if (_subtractedValue > oldValue) {
381       allowed[msg.sender][_spender] = 0;
382     } else {
383       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
384     }
385     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 }
389 /**
390  * @title Mintable token
391  * @dev Simple ERC20 Token example, with mintable token creation
392  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
393  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
394  */
395 contract MintableToken is StandardToken, Ownable {
396   event Mint(address indexed to, uint256 amount);
397   event MintFinished();
398   bool public mintingFinished = false;
399   modifier canMint() {
400     require(!mintingFinished);
401     _;
402   }
403   /**
404    * @dev Function to mint tokens
405    * @param _to The address that will receive the minted tokens.
406    * @param _amount The amount of tokens to mint.
407    * @return A boolean that indicates if the operation was successful.
408    */
409   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
410     totalSupply_ = totalSupply_.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     Mint(_to, _amount);
413     Transfer(address(0), _to, _amount);
414     return true;
415   }
416   /**
417    * @dev Function to stop minting new tokens.
418    * @return True if the operation was successful.
419    */
420   function finishMinting() onlyOwner canMint public returns (bool) {
421     mintingFinished = true;
422     MintFinished();
423     return true;
424   }
425 }
426 /**
427  * @title Burnable Token
428  * @dev Token that can be irreversibly burned (destroyed).
429  */
430 contract BurnableToken is BasicToken {
431   event Burn(address indexed burner, uint256 value);
432   /**
433    * @dev Burns a specific amount of tokens.
434    * @param _value The amount of token to be burned.
435    */
436   function burn(uint256 _value) public {
437     require(_value <= balances[msg.sender]);
438     // no need to require value <= totalSupply, since that would imply the
439     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
440     address burner = msg.sender;
441     balances[burner] = balances[burner].sub(_value);
442     totalSupply_ = totalSupply_.sub(_value);
443     Burn(burner, _value);
444   }
445 }
446 contract MIKETANGOBRAVO18 is MintableToken, BurnableToken {
447 	string public constant name = "MIKETANGOBRAVO18";
448 	string public constant symbol = "MTB18";
449 	uint public constant decimals = 18;
450     function() public {}
451 }
452 contract MIKETANGOBRAVO18Crowdsale is CappedCrowdsale, FinalizableCrowdsale, Pausable {
453   uint256 public rate;
454   uint256 public totalTokenCapToCreate;
455   address public fundWallet;
456   function MIKETANGOBRAVO18Crowdsale (
457   	uint256 _startTime,
458   	uint256 _endTime,
459   	uint256 _rate,
460     address _fundWallet,
461     uint256 _totalCapInEthToRaise,
462     uint256 _totalTokenCapToCreate,
463     uint256 _initialTokenFundBalance
464   	) public
465     Crowdsale(_startTime, _endTime, _rate, _fundWallet)
466     CappedCrowdsale(_totalCapInEthToRaise)
467     FinalizableCrowdsale() {
468       rate = _rate;
469       fundWallet = _fundWallet;
470       totalTokenCapToCreate = _totalTokenCapToCreate;
471       token.mint(fundWallet, _initialTokenFundBalance);
472     }
473   function createTokenContract() internal returns (MintableToken) {
474     return new MIKETANGOBRAVO18();
475   }
476   // overriding CappedCrowdsale#validPurchase
477   // @return true if investors can buy at the moment
478   function validPurchase() internal view returns (bool) {
479     bool withinTokenCap = token.totalSupply().add(msg.value.mul(rate)) <= totalTokenCapToCreate;
480     bool nonZeroPurchase = msg.value != 0;
481     return super.validPurchase() && withinTokenCap && nonZeroPurchase;
482   }
483   // overriding CappedCrowdsale#hasEnded
484   // @return true if crowdsale event has ended
485   function hasEnded() public view returns (bool) {
486     uint256 threshold = totalTokenCapToCreate.div(100).mul(99);
487     bool thresholdReached = token.totalSupply() >= threshold;
488     return super.hasEnded() || thresholdReached;
489   }
490   // overriding FinalizableCrowdsale#finalization
491   // - To store remaining MTB18 tokens.
492   function finalization() internal {
493     uint256 remaining = totalTokenCapToCreate.sub(token.totalSupply());
494     if (remaining > 0) {
495       token.mint(fundWallet, remaining);
496     }
497     // change Token owner to fundWallet Fund.
498     token.transferOwnership(fundWallet);
499     super.finalization();
500   }
501   function remaining() public returns (uint256) {
502     return totalTokenCapToCreate.sub(token.totalSupply());
503   }
504   // overriding Crowdsale#buyTokens
505   function buyTokens(address beneficiary) public payable {
506     require(!paused);
507     require(beneficiary != address(0));
508     require(validPurchase());
509     uint256 weiAmount = msg.value;
510     // calculate token amount to be created
511     uint256 tokens = weiAmount.mul(rate);
512     // update state
513     weiRaised = weiRaised.add(weiAmount);
514     token.mint(beneficiary, tokens);
515     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
516     forwardFunds();
517   }
518 }
1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title Crowdsale
74  * @dev Crowdsale is a base contract for managing a token crowdsale,
75  * allowing investors to purchase tokens with ether. This contract implements
76  * such functionality in its most fundamental form and can be extended to provide additional
77  * functionality and/or custom behavior.
78  * The external interface represents the basic interface for purchasing tokens, and conform
79  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
80  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
81  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
82  * behavior.
83  */
84 
85 contract Crowdsale {
86   using SafeMath for uint256;
87 
88   // The token being sold
89   ERC20 public token;
90 
91   // Address where funds are collected
92   address public wallet;
93 
94   // How many token units a buyer gets per wei
95   uint256 public rate;
96 
97   // Amount of wei raised
98   uint256 public weiRaised;
99 
100   /**
101    * Event for token purchase logging
102    * @param purchaser who paid for the tokens
103    * @param beneficiary who got the tokens
104    * @param value weis paid for purchase
105    * @param amount amount of tokens purchased
106    */
107   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
108 
109   /**
110    * @param _rate Number of token units a buyer gets per wei
111    * @param _wallet Address where collected funds will be forwarded to
112    * @param _token Address of the token being sold
113    */
114   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
115     require(_rate > 0);
116     require(_wallet != address(0));
117     require(_token != address(0));
118 
119     rate = _rate;
120     wallet = _wallet;
121     token = _token;
122   }
123 
124   // -----------------------------------------
125   // Crowdsale external interface
126   // -----------------------------------------
127 
128   /**
129    * @dev fallback function ***DO NOT OVERRIDE***
130    */
131   function () external payable {
132     buyTokens(msg.sender);
133   }
134 
135   /**
136    * @dev low level token purchase ***DO NOT OVERRIDE***
137    * @param _beneficiary Address performing the token purchase
138    */
139   function buyTokens(address _beneficiary) public payable {
140 
141     uint256 weiAmount = msg.value;
142     _preValidatePurchase(_beneficiary, weiAmount);
143 
144     // calculate token amount to be created
145     uint256 tokens = _getTokenAmount(weiAmount);
146 
147     // update state
148     weiRaised = weiRaised.add(weiAmount);
149 
150     _processPurchase(_beneficiary, tokens);
151     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
152 
153     _updatePurchasingState(_beneficiary, weiAmount);
154 
155     _forwardFunds();
156     _postValidatePurchase(_beneficiary, weiAmount);
157   }
158 
159   // -----------------------------------------
160   // Internal interface (extensible)
161   // -----------------------------------------
162 
163   /**
164    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
165    * @param _beneficiary Address performing the token purchase
166    * @param _weiAmount Value in wei involved in the purchase
167    */
168   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
169     require(_beneficiary != address(0));
170     require(_weiAmount != 0);
171   }
172 
173   /**
174    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
175    * @param _beneficiary Address performing the token purchase
176    * @param _weiAmount Value in wei involved in the purchase
177    */
178   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
179     // optional override
180   }
181 
182   /**
183    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
184    * @param _beneficiary Address performing the token purchase
185    * @param _tokenAmount Number of tokens to be emitted
186    */
187   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
188     token.transfer(_beneficiary, _tokenAmount);
189   }
190 
191   /**
192    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
193    * @param _beneficiary Address receiving the tokens
194    * @param _tokenAmount Number of tokens to be purchased
195    */
196   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
197     _deliverTokens(_beneficiary, _tokenAmount);
198   }
199 
200   /**
201    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
202    * @param _beneficiary Address receiving the tokens
203    * @param _weiAmount Value in wei involved in the purchase
204    */
205   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
206     // optional override
207   }
208 
209   /**
210    * @dev Override to extend the way in which ether is converted to tokens.
211    * @param _weiAmount Value in wei to be converted into tokens
212    * @return Number of tokens that can be purchased with the specified _weiAmount
213    */
214   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
215     return _weiAmount.mul(rate);
216   }
217 
218   /**
219    * @dev Determines how ETH is stored/forwarded on purchases.
220    */
221   function _forwardFunds() internal {
222     wallet.transfer(msg.value);
223   }
224 }
225 
226 /**
227  * @title Basic token
228  * @dev Basic version of StandardToken, with no allowances.
229  */
230 contract BasicToken is ERC20Basic {
231   using SafeMath for uint256;
232 
233   mapping(address => uint256) balances;
234 
235   uint256 totalSupply_;
236 
237   /**
238   * @dev total number of tokens in existence
239   */
240   function totalSupply() public view returns (uint256) {
241     return totalSupply_;
242   }
243 
244   /**
245   * @dev transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249   function transfer(address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[msg.sender]);
252 
253     // SafeMath.sub will throw if there is not enough balance.
254     balances[msg.sender] = balances[msg.sender].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     Transfer(msg.sender, _to, _value);
257     return true;
258   }
259 
260   /**
261   * @dev Gets the balance of the specified address.
262   * @param _owner The address to query the the balance of.
263   * @return An uint256 representing the amount owned by the passed address.
264   */
265   function balanceOf(address _owner) public view returns (uint256 balance) {
266     return balances[_owner];
267   }
268 
269 }
270 
271 /**
272  * @title Standard ERC20 token
273  *
274  * @dev Implementation of the basic standard token.
275  * @dev https://github.com/ethereum/EIPs/issues/20
276  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
277  */
278 contract StandardToken is ERC20, BasicToken {
279 
280   mapping (address => mapping (address => uint256)) internal allowed;
281 
282 
283   /**
284    * @dev Transfer tokens from one address to another
285    * @param _from address The address which you want to send tokens from
286    * @param _to address The address which you want to transfer to
287    * @param _value uint256 the amount of tokens to be transferred
288    */
289   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
290     require(_to != address(0));
291     require(_value <= balances[_from]);
292     require(_value <= allowed[_from][msg.sender]);
293 
294     balances[_from] = balances[_from].sub(_value);
295     balances[_to] = balances[_to].add(_value);
296     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
297     Transfer(_from, _to, _value);
298     return true;
299   }
300 
301   /**
302    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
303    *
304    * Beware that changing an allowance with this method brings the risk that someone may use both the old
305    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
306    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
307    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308    * @param _spender The address which will spend the funds.
309    * @param _value The amount of tokens to be spent.
310    */
311   function approve(address _spender, uint256 _value) public returns (bool) {
312     allowed[msg.sender][_spender] = _value;
313     Approval(msg.sender, _spender, _value);
314     return true;
315   }
316 
317   /**
318    * @dev Function to check the amount of tokens that an owner allowed to a spender.
319    * @param _owner address The address which owns the funds.
320    * @param _spender address The address which will spend the funds.
321    * @return A uint256 specifying the amount of tokens still available for the spender.
322    */
323   function allowance(address _owner, address _spender) public view returns (uint256) {
324     return allowed[_owner][_spender];
325   }
326 
327   /**
328    * @dev Increase the amount of tokens that an owner allowed to a spender.
329    *
330    * approve should be called when allowed[_spender] == 0. To increment
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _addedValue The amount of tokens to increase the allowance by.
336    */
337   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
338     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
339     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343   /**
344    * @dev Decrease the amount of tokens that an owner allowed to a spender.
345    *
346    * approve should be called when allowed[_spender] == 0. To decrement
347    * allowed value is better to use this function to avoid 2 calls (and wait until
348    * the first transaction is mined)
349    * From MonolithDAO Token.sol
350    * @param _spender The address which will spend the funds.
351    * @param _subtractedValue The amount of tokens to decrease the allowance by.
352    */
353   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
354     uint oldValue = allowed[msg.sender][_spender];
355     if (_subtractedValue > oldValue) {
356       allowed[msg.sender][_spender] = 0;
357     } else {
358       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
359     }
360     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364 }
365 
366 /**
367  * @title Ownable
368  * @dev The Ownable contract has an owner address, and provides basic authorization control
369  * functions, this simplifies the implementation of "user permissions".
370  */
371 contract Ownable {
372   address public owner;
373 
374 
375   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377 
378   /**
379    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
380    * account.
381    */
382   function Ownable() public {
383     owner = msg.sender;
384   }
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Allows the current owner to transfer control of the contract to a newOwner.
396    * @param newOwner The address to transfer ownership to.
397    */
398   function transferOwnership(address newOwner) public onlyOwner {
399     require(newOwner != address(0));
400     OwnershipTransferred(owner, newOwner);
401     owner = newOwner;
402   }
403 
404 }
405 
406 /**
407  * @title Mintable token
408  * @dev Simple ERC20 Token example, with mintable token creation
409  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
410  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
411  */
412 contract MintableToken is StandardToken, Ownable {
413   event Mint(address indexed to, uint256 amount);
414   event MintFinished();
415 
416   bool public mintingFinished = false;
417 
418 
419   modifier canMint() {
420     require(!mintingFinished);
421     _;
422   }
423 
424   /**
425    * @dev Function to mint tokens
426    * @param _to The address that will receive the minted tokens.
427    * @param _amount The amount of tokens to mint.
428    * @return A boolean that indicates if the operation was successful.
429    */
430   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
431     totalSupply_ = totalSupply_.add(_amount);
432     balances[_to] = balances[_to].add(_amount);
433     Mint(_to, _amount);
434     Transfer(address(0), _to, _amount);
435     return true;
436   }
437 
438   /**
439    * @dev Function to stop minting new tokens.
440    * @return True if the operation was successful.
441    */
442   function finishMinting() onlyOwner canMint public returns (bool) {
443     mintingFinished = true;
444     MintFinished();
445     return true;
446   }
447 }
448 
449 /**
450  * @title Capped token
451  * @dev Mintable token with a token cap.
452  */
453 contract CappedToken is MintableToken {
454 
455   uint256 public cap;
456 
457   function CappedToken(uint256 _cap) public {
458     require(_cap > 0);
459     cap = _cap;
460   }
461 
462   /**
463    * @dev Function to mint tokens
464    * @param _to The address that will receive the minted tokens.
465    * @param _amount The amount of tokens to mint.
466    * @return A boolean that indicates if the operation was successful.
467    */
468   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
469     require(totalSupply_.add(_amount) <= cap);
470 
471     return super.mint(_to, _amount);
472   }
473 
474 }
475 
476 contract DetailedERC20 is ERC20 {
477   string public name;
478   string public symbol;
479   uint8 public decimals;
480 
481   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
482     name = _name;
483     symbol = _symbol;
484     decimals = _decimals;
485   }
486 }
487 
488 /**
489  * @title Burnable Token
490  * @dev Token that can be irreversibly burned (destroyed).
491  */
492 contract BurnableToken is BasicToken {
493 
494   event Burn(address indexed burner, uint256 value);
495 
496   /**
497    * @dev Burns a specific amount of tokens.
498    * @param _value The amount of token to be burned.
499    */
500   function burn(uint256 _value) public {
501     require(_value <= balances[msg.sender]);
502     // no need to require value <= totalSupply, since that would imply the
503     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
504 
505     address burner = msg.sender;
506     balances[burner] = balances[burner].sub(_value);
507     totalSupply_ = totalSupply_.sub(_value);
508     Burn(burner, _value);
509     Transfer(burner, address(0), _value);
510   }
511 }
512 
513 
514 
515 contract CNYXToken is CappedToken, BurnableToken, DetailedERC20 {
516 
517     uint8 constant DECIMALS = 18;
518     uint  constant TOTALTOKEN = 10 ** (10 + uint(DECIMALS));
519     string constant NAME = "CNY Exchange";
520     string constant SYM = "CNYX";
521 
522     constructor() DetailedERC20 (NAME, SYM, DECIMALS) CappedToken(TOTALTOKEN) public {}
523 
524 }
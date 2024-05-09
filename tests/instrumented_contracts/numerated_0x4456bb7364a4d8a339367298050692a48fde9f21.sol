1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
310 
311 /**
312  * @title Capped token
313  * @dev Mintable token with a token cap.
314  */
315 contract CappedToken is MintableToken {
316 
317   uint256 public cap;
318 
319   function CappedToken(uint256 _cap) public {
320     require(_cap > 0);
321     cap = _cap;
322   }
323 
324   /**
325    * @dev Function to mint tokens
326    * @param _to The address that will receive the minted tokens.
327    * @param _amount The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
331     require(totalSupply_.add(_amount) <= cap);
332 
333     return super.mint(_to, _amount);
334   }
335 
336 }
337 
338 // File: contracts/SelfieYoGoldToken/SGTCoin.sol
339 
340 contract SGTCoin is CappedToken {
341     string public constant name = "SelfieYo Gold Token";
342     string public constant symbol = "SGT";
343     uint8 public constant decimals = 18;
344 
345     // solhint-disable-next-line no-empty-blocks
346     function SGTCoin(uint256 _cap) public CappedToken(_cap) {}
347 }
348 
349 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
350 
351 /**
352  * @title Crowdsale
353  * @dev Crowdsale is a base contract for managing a token crowdsale,
354  * allowing investors to purchase tokens with ether. This contract implements
355  * such functionality in its most fundamental form and can be extended to provide additional
356  * functionality and/or custom behavior.
357  * The external interface represents the basic interface for purchasing tokens, and conform
358  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
359  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
360  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
361  * behavior.
362  */
363 
364 contract Crowdsale {
365   using SafeMath for uint256;
366 
367   // The token being sold
368   ERC20 public token;
369 
370   // Address where funds are collected
371   address public wallet;
372 
373   // How many token units a buyer gets per wei
374   uint256 public rate;
375 
376   // Amount of wei raised
377   uint256 public weiRaised;
378 
379   /**
380    * Event for token purchase logging
381    * @param purchaser who paid for the tokens
382    * @param beneficiary who got the tokens
383    * @param value weis paid for purchase
384    * @param amount amount of tokens purchased
385    */
386   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
387 
388   /**
389    * @param _rate Number of token units a buyer gets per wei
390    * @param _wallet Address where collected funds will be forwarded to
391    * @param _token Address of the token being sold
392    */
393   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
394     require(_rate > 0);
395     require(_wallet != address(0));
396     require(_token != address(0));
397 
398     rate = _rate;
399     wallet = _wallet;
400     token = _token;
401   }
402 
403   // -----------------------------------------
404   // Crowdsale external interface
405   // -----------------------------------------
406 
407   /**
408    * @dev fallback function ***DO NOT OVERRIDE***
409    */
410   function () external payable {
411     buyTokens(msg.sender);
412   }
413 
414   /**
415    * @dev low level token purchase ***DO NOT OVERRIDE***
416    * @param _beneficiary Address performing the token purchase
417    */
418   function buyTokens(address _beneficiary) public payable {
419 
420     uint256 weiAmount = msg.value;
421     _preValidatePurchase(_beneficiary, weiAmount);
422 
423     // calculate token amount to be created
424     uint256 tokens = _getTokenAmount(weiAmount);
425 
426     // update state
427     weiRaised = weiRaised.add(weiAmount);
428 
429     _processPurchase(_beneficiary, tokens);
430     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
431 
432     _updatePurchasingState(_beneficiary, weiAmount);
433 
434     _forwardFunds();
435     _postValidatePurchase(_beneficiary, weiAmount);
436   }
437 
438   // -----------------------------------------
439   // Internal interface (extensible)
440   // -----------------------------------------
441 
442   /**
443    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
444    * @param _beneficiary Address performing the token purchase
445    * @param _weiAmount Value in wei involved in the purchase
446    */
447   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
448     require(_beneficiary != address(0));
449     require(_weiAmount != 0);
450   }
451 
452   /**
453    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
454    * @param _beneficiary Address performing the token purchase
455    * @param _weiAmount Value in wei involved in the purchase
456    */
457   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
458     // optional override
459   }
460 
461   /**
462    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
463    * @param _beneficiary Address performing the token purchase
464    * @param _tokenAmount Number of tokens to be emitted
465    */
466   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
467     token.transfer(_beneficiary, _tokenAmount);
468   }
469 
470   /**
471    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
472    * @param _beneficiary Address receiving the tokens
473    * @param _tokenAmount Number of tokens to be purchased
474    */
475   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
476     _deliverTokens(_beneficiary, _tokenAmount);
477   }
478 
479   /**
480    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
481    * @param _beneficiary Address receiving the tokens
482    * @param _weiAmount Value in wei involved in the purchase
483    */
484   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
485     // optional override
486   }
487 
488   /**
489    * @dev Override to extend the way in which ether is converted to tokens.
490    * @param _weiAmount Value in wei to be converted into tokens
491    * @return Number of tokens that can be purchased with the specified _weiAmount
492    */
493   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
494     return _weiAmount.mul(rate);
495   }
496 
497   /**
498    * @dev Determines how ETH is stored/forwarded on purchases.
499    */
500   function _forwardFunds() internal {
501     wallet.transfer(msg.value);
502   }
503 }
504 
505 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
506 
507 /**
508  * @title CappedCrowdsale
509  * @dev Crowdsale with a limit for total contributions.
510  */
511 contract CappedCrowdsale is Crowdsale {
512   using SafeMath for uint256;
513 
514   uint256 public cap;
515 
516   /**
517    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
518    * @param _cap Max amount of wei to be contributed
519    */
520   function CappedCrowdsale(uint256 _cap) public {
521     require(_cap > 0);
522     cap = _cap;
523   }
524 
525   /**
526    * @dev Checks whether the cap has been reached. 
527    * @return Whether the cap was reached
528    */
529   function capReached() public view returns (bool) {
530     return weiRaised >= cap;
531   }
532 
533   /**
534    * @dev Extend parent behavior requiring purchase to respect the funding cap.
535    * @param _beneficiary Token purchaser
536    * @param _weiAmount Amount of wei contributed
537    */
538   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
539     super._preValidatePurchase(_beneficiary, _weiAmount);
540     require(weiRaised.add(_weiAmount) <= cap);
541   }
542 
543 }
544 
545 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
546 
547 /**
548  * @title WhitelistedCrowdsale
549  * @dev Crowdsale in which only whitelisted users can contribute.
550  */
551 contract WhitelistedCrowdsale is Crowdsale, Ownable {
552 
553   mapping(address => bool) public whitelist;
554 
555   /**
556    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
557    */
558   modifier isWhitelisted(address _beneficiary) {
559     require(whitelist[_beneficiary]);
560     _;
561   }
562 
563   /**
564    * @dev Adds single address to whitelist.
565    * @param _beneficiary Address to be added to the whitelist
566    */
567   function addToWhitelist(address _beneficiary) external onlyOwner {
568     whitelist[_beneficiary] = true;
569   }
570 
571   /**
572    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
573    * @param _beneficiaries Addresses to be added to the whitelist
574    */
575   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
576     for (uint256 i = 0; i < _beneficiaries.length; i++) {
577       whitelist[_beneficiaries[i]] = true;
578     }
579   }
580 
581   /**
582    * @dev Removes single address from whitelist.
583    * @param _beneficiary Address to be removed to the whitelist
584    */
585   function removeFromWhitelist(address _beneficiary) external onlyOwner {
586     whitelist[_beneficiary] = false;
587   }
588 
589   /**
590    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
591    * @param _beneficiary Token beneficiary
592    * @param _weiAmount Amount of wei contributed
593    */
594   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
595     super._preValidatePurchase(_beneficiary, _weiAmount);
596   }
597 
598 }
599 
600 // File: contracts/SelfieYoGoldToken/SGTCoinCrowdsale.sol
601 
602 contract SGTCoinCrowdsale is WhitelistedCrowdsale, CappedCrowdsale {
603     SGTCoin public token;
604 
605     function SGTCoinCrowdsale (
606         uint256 _rate,
607         address _wallet,
608         SGTCoin _token,
609         uint256 _cap
610     ) public
611     CappedCrowdsale(_cap)
612     Crowdsale(_rate, _wallet, _token) {
613         token = _token;
614     }
615 
616     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
617         token.mint(_beneficiary, _tokenAmount);
618     }
619 }
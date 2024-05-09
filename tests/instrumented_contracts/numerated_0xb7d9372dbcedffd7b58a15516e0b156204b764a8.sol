1 /* ===============================================
2  * Flattened with Solidifier by Coinage
3  * 
4  * https://solidifier.coina.ge
5  * ===============================================
6 */
7 
8 
9 pragma solidity 0.4.24;
10 
11 
12 /**
13  * @title ERC20Basic
14  * @dev Simpler version of ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/179
16  */
17 contract ERC20Basic {
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender)
31     public view returns (uint256);
32 
33   function transferFrom(address from, address to, uint256 value)
34     public returns (bool);
35 
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (a == 0) {
59       return 0;
60     }
61 
62     c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return a / b;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89     c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 /**
97  * @title Crowdsale
98  * @dev Crowdsale is a base contract for managing a token crowdsale,
99  * allowing investors to purchase tokens with ether. This contract implements
100  * such functionality in its most fundamental form and can be extended to provide additional
101  * functionality and/or custom behavior.
102  * The external interface represents the basic interface for purchasing tokens, and conform
103  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
104  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
105  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
106  * behavior.
107  */
108 contract Crowdsale {
109   using SafeMath for uint256;
110 
111   // The token being sold
112   ERC20 public token;
113 
114   // Address where funds are collected
115   address public wallet;
116 
117   // How many token units a buyer gets per wei.
118   // The rate is the conversion between wei and the smallest and indivisible token unit.
119   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
120   // 1 wei will give you 1 unit, or 0.001 TOK.
121   uint256 public rate;
122 
123   // Amount of wei raised
124   uint256 public weiRaised;
125 
126   /**
127    * Event for token purchase logging
128    * @param purchaser who paid for the tokens
129    * @param beneficiary who got the tokens
130    * @param value weis paid for purchase
131    * @param amount amount of tokens purchased
132    */
133   event TokenPurchase(
134     address indexed purchaser,
135     address indexed beneficiary,
136     uint256 value,
137     uint256 amount
138   );
139 
140   /**
141    * @param _rate Number of token units a buyer gets per wei
142    * @param _wallet Address where collected funds will be forwarded to
143    * @param _token Address of the token being sold
144    */
145   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
146     require(_rate > 0);
147     require(_wallet != address(0));
148     require(_token != address(0));
149 
150     rate = _rate;
151     wallet = _wallet;
152     token = _token;
153   }
154 
155   // -----------------------------------------
156   // Crowdsale external interface
157   // -----------------------------------------
158 
159   /**
160    * @dev fallback function ***DO NOT OVERRIDE***
161    */
162   function () external payable {
163     buyTokens(msg.sender);
164   }
165 
166   /**
167    * @dev low level token purchase ***DO NOT OVERRIDE***
168    * @param _beneficiary Address performing the token purchase
169    */
170   function buyTokens(address _beneficiary) public payable {
171 
172     uint256 weiAmount = msg.value;
173     _preValidatePurchase(_beneficiary, weiAmount);
174 
175     // calculate token amount to be created
176     uint256 tokens = _getTokenAmount(weiAmount);
177 
178     // update state
179     weiRaised = weiRaised.add(weiAmount);
180 
181     _processPurchase(_beneficiary, tokens);
182     emit TokenPurchase(
183       msg.sender,
184       _beneficiary,
185       weiAmount,
186       tokens
187     );
188 
189     _updatePurchasingState(_beneficiary, weiAmount);
190 
191     _forwardFunds();
192     _postValidatePurchase(_beneficiary, weiAmount);
193   }
194 
195   // -----------------------------------------
196   // Internal interface (extensible)
197   // -----------------------------------------
198 
199   /**
200    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
201    * @param _beneficiary Address performing the token purchase
202    * @param _weiAmount Value in wei involved in the purchase
203    */
204   function _preValidatePurchase(
205     address _beneficiary,
206     uint256 _weiAmount
207   )
208     internal
209   {
210     require(_beneficiary != address(0));
211     require(_weiAmount != 0);
212   }
213 
214   /**
215    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
216    * @param _beneficiary Address performing the token purchase
217    * @param _weiAmount Value in wei involved in the purchase
218    */
219   function _postValidatePurchase(
220     address _beneficiary,
221     uint256 _weiAmount
222   )
223     internal
224   {
225     // optional override
226   }
227 
228   /**
229    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
230    * @param _beneficiary Address performing the token purchase
231    * @param _tokenAmount Number of tokens to be emitted
232    */
233   function _deliverTokens(
234     address _beneficiary,
235     uint256 _tokenAmount
236   )
237     internal
238   {
239     token.transfer(_beneficiary, _tokenAmount);
240   }
241 
242   /**
243    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
244    * @param _beneficiary Address receiving the tokens
245    * @param _tokenAmount Number of tokens to be purchased
246    */
247   function _processPurchase(
248     address _beneficiary,
249     uint256 _tokenAmount
250   )
251     internal
252   {
253     _deliverTokens(_beneficiary, _tokenAmount);
254   }
255 
256   /**
257    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
258    * @param _beneficiary Address receiving the tokens
259    * @param _weiAmount Value in wei involved in the purchase
260    */
261   function _updatePurchasingState(
262     address _beneficiary,
263     uint256 _weiAmount
264   )
265     internal
266   {
267     // optional override
268   }
269 
270   /**
271    * @dev Override to extend the way in which ether is converted to tokens.
272    * @param _weiAmount Value in wei to be converted into tokens
273    * @return Number of tokens that can be purchased with the specified _weiAmount
274    */
275   function _getTokenAmount(uint256 _weiAmount)
276     internal view returns (uint256)
277   {
278     return _weiAmount.mul(rate);
279   }
280 
281   /**
282    * @dev Determines how ETH is stored/forwarded on purchases.
283    */
284   function _forwardFunds() internal {
285     wallet.transfer(msg.value);
286   }
287 }
288 
289 
290 /**
291  * @title Ownable
292  * @dev The Ownable contract has an owner address, and provides basic authorization control
293  * functions, this simplifies the implementation of "user permissions".
294  */
295 contract Ownable {
296   address public owner;
297 
298 
299   event OwnershipRenounced(address indexed previousOwner);
300   event OwnershipTransferred(
301     address indexed previousOwner,
302     address indexed newOwner
303   );
304 
305 
306   /**
307    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
308    * account.
309    */
310   constructor() public {
311     owner = msg.sender;
312   }
313 
314   /**
315    * @dev Throws if called by any account other than the owner.
316    */
317   modifier onlyOwner() {
318     require(msg.sender == owner);
319     _;
320   }
321 
322   /**
323    * @dev Allows the current owner to relinquish control of the contract.
324    */
325   function renounceOwnership() public onlyOwner {
326     emit OwnershipRenounced(owner);
327     owner = address(0);
328   }
329 
330   /**
331    * @dev Allows the current owner to transfer control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function transferOwnership(address _newOwner) public onlyOwner {
335     _transferOwnership(_newOwner);
336   }
337 
338   /**
339    * @dev Transfers control of the contract to a newOwner.
340    * @param _newOwner The address to transfer ownership to.
341    */
342   function _transferOwnership(address _newOwner) internal {
343     require(_newOwner != address(0));
344     emit OwnershipTransferred(owner, _newOwner);
345     owner = _newOwner;
346   }
347 }
348 
349 
350 /**
351  * @title Basic token
352  * @dev Basic version of StandardToken, with no allowances.
353  */
354 contract BasicToken is ERC20Basic {
355   using SafeMath for uint256;
356 
357   mapping(address => uint256) balances;
358 
359   uint256 totalSupply_;
360 
361   /**
362   * @dev total number of tokens in existence
363   */
364   function totalSupply() public view returns (uint256) {
365     return totalSupply_;
366   }
367 
368   /**
369   * @dev transfer token for a specified address
370   * @param _to The address to transfer to.
371   * @param _value The amount to be transferred.
372   */
373   function transfer(address _to, uint256 _value) public returns (bool) {
374     require(_to != address(0));
375     require(_value <= balances[msg.sender]);
376 
377     balances[msg.sender] = balances[msg.sender].sub(_value);
378     balances[_to] = balances[_to].add(_value);
379     emit Transfer(msg.sender, _to, _value);
380     return true;
381   }
382 
383   /**
384   * @dev Gets the balance of the specified address.
385   * @param _owner The address to query the the balance of.
386   * @return An uint256 representing the amount owned by the passed address.
387   */
388   function balanceOf(address _owner) public view returns (uint256) {
389     return balances[_owner];
390   }
391 
392 }
393 
394 
395 /**
396  * @title Burnable Token
397  * @dev Token that can be irreversibly burned (destroyed).
398  */
399 contract BurnableToken is BasicToken {
400 
401   event Burn(address indexed burner, uint256 value);
402 
403   /**
404    * @dev Burns a specific amount of tokens.
405    * @param _value The amount of token to be burned.
406    */
407   function burn(uint256 _value) public {
408     _burn(msg.sender, _value);
409   }
410 
411   function _burn(address _who, uint256 _value) internal {
412     require(_value <= balances[_who]);
413     // no need to require value <= totalSupply, since that would imply the
414     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
415 
416     balances[_who] = balances[_who].sub(_value);
417     totalSupply_ = totalSupply_.sub(_value);
418     emit Burn(_who, _value);
419     emit Transfer(_who, address(0), _value);
420   }
421 }
422 
423 
424 /**
425  * @title Standard ERC20 token
426  *
427  * @dev Implementation of the basic standard token.
428  * @dev https://github.com/ethereum/EIPs/issues/20
429  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
430  */
431 contract StandardToken is ERC20, BasicToken {
432 
433   mapping (address => mapping (address => uint256)) internal allowed;
434 
435 
436   /**
437    * @dev Transfer tokens from one address to another
438    * @param _from address The address which you want to send tokens from
439    * @param _to address The address which you want to transfer to
440    * @param _value uint256 the amount of tokens to be transferred
441    */
442   function transferFrom(
443     address _from,
444     address _to,
445     uint256 _value
446   )
447     public
448     returns (bool)
449   {
450     require(_to != address(0));
451     require(_value <= balances[_from]);
452     require(_value <= allowed[_from][msg.sender]);
453 
454     balances[_from] = balances[_from].sub(_value);
455     balances[_to] = balances[_to].add(_value);
456     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
457     emit Transfer(_from, _to, _value);
458     return true;
459   }
460 
461   /**
462    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
463    *
464    * Beware that changing an allowance with this method brings the risk that someone may use both the old
465    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
466    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
467    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
468    * @param _spender The address which will spend the funds.
469    * @param _value The amount of tokens to be spent.
470    */
471   function approve(address _spender, uint256 _value) public returns (bool) {
472     allowed[msg.sender][_spender] = _value;
473     emit Approval(msg.sender, _spender, _value);
474     return true;
475   }
476 
477   /**
478    * @dev Function to check the amount of tokens that an owner allowed to a spender.
479    * @param _owner address The address which owns the funds.
480    * @param _spender address The address which will spend the funds.
481    * @return A uint256 specifying the amount of tokens still available for the spender.
482    */
483   function allowance(
484     address _owner,
485     address _spender
486    )
487     public
488     view
489     returns (uint256)
490   {
491     return allowed[_owner][_spender];
492   }
493 
494   /**
495    * @dev Increase the amount of tokens that an owner allowed to a spender.
496    *
497    * approve should be called when allowed[_spender] == 0. To increment
498    * allowed value is better to use this function to avoid 2 calls (and wait until
499    * the first transaction is mined)
500    * From MonolithDAO Token.sol
501    * @param _spender The address which will spend the funds.
502    * @param _addedValue The amount of tokens to increase the allowance by.
503    */
504   function increaseApproval(
505     address _spender,
506     uint _addedValue
507   )
508     public
509     returns (bool)
510   {
511     allowed[msg.sender][_spender] = (
512       allowed[msg.sender][_spender].add(_addedValue));
513     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
514     return true;
515   }
516 
517   /**
518    * @dev Decrease the amount of tokens that an owner allowed to a spender.
519    *
520    * approve should be called when allowed[_spender] == 0. To decrement
521    * allowed value is better to use this function to avoid 2 calls (and wait until
522    * the first transaction is mined)
523    * From MonolithDAO Token.sol
524    * @param _spender The address which will spend the funds.
525    * @param _subtractedValue The amount of tokens to decrease the allowance by.
526    */
527   function decreaseApproval(
528     address _spender,
529     uint _subtractedValue
530   )
531     public
532     returns (bool)
533   {
534     uint oldValue = allowed[msg.sender][_spender];
535     if (_subtractedValue > oldValue) {
536       allowed[msg.sender][_spender] = 0;
537     } else {
538       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
539     }
540     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
541     return true;
542   }
543 
544 }
545 
546 
547 /**
548  * @title Standard Burnable Token
549  * @dev Adds burnFrom method to ERC20 implementations
550  */
551 contract StandardBurnableToken is BurnableToken, StandardToken {
552 
553   /**
554    * @dev Burns a specific amount of tokens from the target address and decrements allowance
555    * @param _from address The address which you want to send tokens from
556    * @param _value uint256 The amount of token to be burned
557    */
558   function burnFrom(address _from, uint256 _value) public {
559     require(_value <= allowed[_from][msg.sender]);
560     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
561     // this function needs to emit an event with the updated approval.
562     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
563     _burn(_from, _value);
564   }
565 }
566 
567 
568 contract ExposureToken is StandardBurnableToken {
569     string public constant name = "Exposure";
570     string public constant symbol = "EXPO";
571     uint8 public constant decimals = 18;
572 
573     constructor() public 
574     {
575         // 1 BILLION EXPOSURE
576         totalSupply_ = 1000000000 ether;
577         
578         // Owner starts with all of the Exposure.
579         balances[msg.sender] = totalSupply_;
580         emit Transfer(0, msg.sender, totalSupply_);
581     }
582 }
583 
584 
585 contract ExposureCrowdSale is Crowdsale, Ownable {
586     constructor(uint256 rate_, address wallet_, ExposureToken token_) public 
587         Crowdsale(rate_, wallet_, token_)
588     {
589     }
590 
591     /**
592     * @dev Allows the owner to withdraw any Exposure in the crowdsale contract
593     * @param _amount Exposure to withdraw
594     */
595     function withdraw(uint256 _amount)
596         onlyOwner
597         external
598     {
599         token.transfer(owner, _amount);
600     }
601 
602     /**
603     * @dev Allows the owner to change the funds wallet address
604     * @param _wallet The new funds wallet address
605     */
606     function updateWallet(address _wallet)
607         onlyOwner
608         external
609     {
610         wallet = _wallet;
611     }
612 
613     /**
614     * @dev Allows the owner to change the exchange rate
615     * @param _rate The new rate of the crowdsale
616     */
617     function updateRate(uint256 _rate)
618         onlyOwner
619         external
620     {
621         rate = _rate;
622     }
623 
624     /**
625     * @dev Allows a participant to ensure they receive a specfic rate when purchasing to prevent front-running by the owner
626     * @param _beneficiary The recipient of all that sweet sweet Exposure.
627     * @param _guaranteedRate The rate the recipient wants to ensure they receive.
628     */
629     function buyTokensAtRate(address _beneficiary, uint256 _guaranteedRate)
630         external
631         payable
632     {
633         // Ensure the rate we're providing is the one the user asks for or revert the transaction.
634         require(rate == _guaranteedRate);
635 
636         // Ok, we're good to execute the buy.
637         return buyTokens(_beneficiary);
638     }
639 }
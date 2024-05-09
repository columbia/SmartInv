1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Crowdsale {
11   using SafeMath for uint256;
12 
13   // The token being sold
14   ERC20 public token;
15 
16   // Address where funds are collected
17   address public wallet;
18 
19   // How many token units a buyer gets per wei
20   uint256 public rate;
21 
22   // Amount of wei raised
23   uint256 public weiRaised;
24 
25   /**
26    * Event for token purchase logging
27    * @param purchaser who paid for the tokens
28    * @param beneficiary who got the tokens
29    * @param value weis paid for purchase
30    * @param amount amount of tokens purchased
31    */
32   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
33 
34   /**
35    * @param _rate Number of token units a buyer gets per wei
36    * @param _wallet Address where collected funds will be forwarded to
37    * @param _token Address of the token being sold
38    */
39   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
40     require(_rate > 0);
41     require(_wallet != address(0));
42     require(_token != address(0));
43 
44     rate = _rate;
45     wallet = _wallet;
46     token = _token;
47   }
48 
49   // -----------------------------------------
50   // Crowdsale external interface
51   // -----------------------------------------
52 
53   /**
54    * @dev fallback function ***DO NOT OVERRIDE***
55    */
56   function () external payable {
57     buyTokens(msg.sender);
58   }
59 
60   /**
61    * @dev low level token purchase ***DO NOT OVERRIDE***
62    * @param _beneficiary Address performing the token purchase
63    */
64   function buyTokens(address _beneficiary) public payable {
65 
66     uint256 weiAmount = msg.value;
67     _preValidatePurchase(_beneficiary, weiAmount);
68 
69     // calculate token amount to be created
70     uint256 tokens = _getTokenAmount(weiAmount);
71 
72     // update state
73     weiRaised = weiRaised.add(weiAmount);
74 
75     _processPurchase(_beneficiary, tokens);
76     emit TokenPurchase(
77       msg.sender,
78       _beneficiary,
79       weiAmount,
80       tokens
81     );
82 
83     _updatePurchasingState(_beneficiary, weiAmount);
84 
85     _forwardFunds();
86     _postValidatePurchase(_beneficiary, weiAmount);
87   }
88 
89   // -----------------------------------------
90   // Internal interface (extensible)
91   // -----------------------------------------
92 
93   /**
94    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
95    * @param _beneficiary Address performing the token purchase
96    * @param _weiAmount Value in wei involved in the purchase
97    */
98   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
99     require(_beneficiary != address(0));
100     require(_weiAmount != 0);
101   }
102 
103   /**
104    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
105    * @param _beneficiary Address performing the token purchase
106    * @param _weiAmount Value in wei involved in the purchase
107    */
108   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
109     // optional override
110   }
111 
112   /**
113    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
114    * @param _beneficiary Address performing the token purchase
115    * @param _tokenAmount Number of tokens to be emitted
116    */
117   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
118     token.transfer(_beneficiary, _tokenAmount);
119   }
120 
121   /**
122    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
123    * @param _beneficiary Address receiving the tokens
124    * @param _tokenAmount Number of tokens to be purchased
125    */
126   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
127     _deliverTokens(_beneficiary, _tokenAmount);
128   }
129 
130   /**
131    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
132    * @param _beneficiary Address receiving the tokens
133    * @param _weiAmount Value in wei involved in the purchase
134    */
135   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
136     // optional override
137   }
138 
139   /**
140    * @dev Override to extend the way in which ether is converted to tokens.
141    * @param _weiAmount Value in wei to be converted into tokens
142    * @return Number of tokens that can be purchased with the specified _weiAmount
143    */
144   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
145     return _weiAmount.mul(rate);
146   }
147 
148   /**
149    * @dev Determines how ETH is stored/forwarded on purchases.
150    */
151   function _forwardFunds() internal {
152     wallet.transfer(msg.value);
153   }
154 }
155 
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender) public view returns (uint256);
158   function transferFrom(address from, address to, uint256 value) public returns (bool);
159   function approve(address spender, uint256 value) public returns (bool);
160   event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 contract ERC827 is ERC20 {
164   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
165   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
166   function transferFromAndCall(
167     address _from,
168     address _to,
169     uint256 _value,
170     bytes _data
171   )
172     public
173     payable
174     returns (bool);
175 }
176 
177 library SafeMath {
178 
179   /**
180   * @dev Multiplies two numbers, throws on overflow.
181   */
182   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
183     if (a == 0) {
184       return 0;
185     }
186     c = a * b;
187     assert(c / a == b);
188     return c;
189   }
190 
191   /**
192   * @dev Integer division of two numbers, truncating the quotient.
193   */
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     // assert(b > 0); // Solidity automatically throws when dividing by 0
196     // uint256 c = a / b;
197     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198     return a / b;
199   }
200 
201   /**
202   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
203   */
204   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205     assert(b <= a);
206     return a - b;
207   }
208 
209   /**
210   * @dev Adds two numbers, throws on overflow.
211   */
212   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
213     c = a + b;
214     assert(c >= a);
215     return c;
216   }
217 }
218 
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   function Ownable() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     emit OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 contract CappedCrowdsale is Crowdsale {
255   using SafeMath for uint256;
256 
257   uint256 public cap;
258 
259   /**
260    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
261    * @param _cap Max amount of wei to be contributed
262    */
263   function CappedCrowdsale(uint256 _cap) public {
264     require(_cap > 0);
265     cap = _cap;
266   }
267 
268   /**
269    * @dev Checks whether the cap has been reached. 
270    * @return Whether the cap was reached
271    */
272   function capReached() public view returns (bool) {
273     return weiRaised >= cap;
274   }
275 
276   /**
277    * @dev Extend parent behavior requiring purchase to respect the funding cap.
278    * @param _beneficiary Token purchaser
279    * @param _weiAmount Amount of wei contributed
280    */
281   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
282     super._preValidatePurchase(_beneficiary, _weiAmount);
283     require(weiRaised.add(_weiAmount) <= cap);
284   }
285 
286 }
287 
288 contract Certifier {
289     event Confirmed(address indexed who);
290     event Revoked(address indexed who);
291     function certified(address) public constant returns (bool);
292     function get(address, string) public constant returns (bytes32);
293     function getAddress(address, string) public constant returns (address);
294     function getUint(address, string) public constant returns (uint);
295 }
296 
297 contract Certifiable is Ownable {
298     Certifier public certifier;
299     event CertifierChanged(address indexed newCertifier);
300 
301     constructor(address _certifier) public {
302         certifier = Certifier(_certifier);
303     }
304 
305     function updateCertifier(address _address) public onlyOwner returns (bool success) {
306         require(_address != address(0));
307         emit CertifierChanged(_address);
308         certifier = Certifier(_address);
309         return true;
310     }
311 }
312 
313 contract KYCToken is Certifiable {
314     mapping(address => bool) public kycPending;
315     mapping(address => bool) public managers;
316 
317     event ManagerAdded(address indexed newManager);
318     event ManagerRemoved(address indexed removedManager);
319 
320     modifier onlyManager() {
321         require(managers[msg.sender] == true);
322         _;
323     }
324 
325     modifier isKnownCustomer(address _address) {
326         require(!kycPending[_address] || certifier.certified(_address));
327         if (kycPending[_address]) {
328             kycPending[_address] = false;
329         }
330         _;
331     }
332 
333     constructor(address _certifier) public Certifiable(_certifier)
334     {
335 
336     }
337 
338     function addManager(address _address) external onlyOwner {
339         managers[_address] = true;
340         emit ManagerAdded(_address);
341     }
342 
343     function removeManager(address _address) external onlyOwner {
344         managers[_address] = false;
345         emit ManagerRemoved(_address);
346     }
347 
348 }
349 
350 contract AllowanceCrowdsale is Crowdsale {
351   using SafeMath for uint256;
352 
353   address public tokenWallet;
354 
355   /**
356    * @dev Constructor, takes token wallet address. 
357    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
358    */
359   function AllowanceCrowdsale(address _tokenWallet) public {
360     require(_tokenWallet != address(0));
361     tokenWallet = _tokenWallet;
362   }
363 
364   /**
365    * @dev Checks the amount of tokens left in the allowance.
366    * @return Amount of tokens left in the allowance
367    */
368   function remainingTokens() public view returns (uint256) {
369     return token.allowance(tokenWallet, this);
370   }
371 
372   /**
373    * @dev Overrides parent behavior by transferring tokens from wallet.
374    * @param _beneficiary Token purchaser
375    * @param _tokenAmount Amount of tokens purchased
376    */
377   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
378     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
379   }
380 }
381 
382 contract BasicToken is ERC20Basic {
383   using SafeMath for uint256;
384 
385   mapping(address => uint256) balances;
386 
387   uint256 totalSupply_;
388 
389   /**
390   * @dev total number of tokens in existence
391   */
392   function totalSupply() public view returns (uint256) {
393     return totalSupply_;
394   }
395 
396   /**
397   * @dev transfer token for a specified address
398   * @param _to The address to transfer to.
399   * @param _value The amount to be transferred.
400   */
401   function transfer(address _to, uint256 _value) public returns (bool) {
402     require(_to != address(0));
403     require(_value <= balances[msg.sender]);
404 
405     balances[msg.sender] = balances[msg.sender].sub(_value);
406     balances[_to] = balances[_to].add(_value);
407     emit Transfer(msg.sender, _to, _value);
408     return true;
409   }
410 
411   /**
412   * @dev Gets the balance of the specified address.
413   * @param _owner The address to query the the balance of.
414   * @return An uint256 representing the amount owned by the passed address.
415   */
416   function balanceOf(address _owner) public view returns (uint256) {
417     return balances[_owner];
418   }
419 
420 }
421 
422 contract BurnableToken is BasicToken {
423 
424   event Burn(address indexed burner, uint256 value);
425 
426   /**
427    * @dev Burns a specific amount of tokens.
428    * @param _value The amount of token to be burned.
429    */
430   function burn(uint256 _value) public {
431     _burn(msg.sender, _value);
432   }
433 
434   function _burn(address _who, uint256 _value) internal {
435     require(_value <= balances[_who]);
436     // no need to require value <= totalSupply, since that would imply the
437     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
438 
439     balances[_who] = balances[_who].sub(_value);
440     totalSupply_ = totalSupply_.sub(_value);
441     emit Burn(_who, _value);
442     emit Transfer(_who, address(0), _value);
443   }
444 }
445 
446 contract StandardToken is ERC20, BasicToken {
447 
448   mapping (address => mapping (address => uint256)) internal allowed;
449 
450 
451   /**
452    * @dev Transfer tokens from one address to another
453    * @param _from address The address which you want to send tokens from
454    * @param _to address The address which you want to transfer to
455    * @param _value uint256 the amount of tokens to be transferred
456    */
457   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
458     require(_to != address(0));
459     require(_value <= balances[_from]);
460     require(_value <= allowed[_from][msg.sender]);
461 
462     balances[_from] = balances[_from].sub(_value);
463     balances[_to] = balances[_to].add(_value);
464     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
465     emit Transfer(_from, _to, _value);
466     return true;
467   }
468 
469   /**
470    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
471    *
472    * Beware that changing an allowance with this method brings the risk that someone may use both the old
473    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
474    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
475    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
476    * @param _spender The address which will spend the funds.
477    * @param _value The amount of tokens to be spent.
478    */
479   function approve(address _spender, uint256 _value) public returns (bool) {
480     allowed[msg.sender][_spender] = _value;
481     emit Approval(msg.sender, _spender, _value);
482     return true;
483   }
484 
485   /**
486    * @dev Function to check the amount of tokens that an owner allowed to a spender.
487    * @param _owner address The address which owns the funds.
488    * @param _spender address The address which will spend the funds.
489    * @return A uint256 specifying the amount of tokens still available for the spender.
490    */
491   function allowance(address _owner, address _spender) public view returns (uint256) {
492     return allowed[_owner][_spender];
493   }
494 
495   /**
496    * @dev Increase the amount of tokens that an owner allowed to a spender.
497    *
498    * approve should be called when allowed[_spender] == 0. To increment
499    * allowed value is better to use this function to avoid 2 calls (and wait until
500    * the first transaction is mined)
501    * From MonolithDAO Token.sol
502    * @param _spender The address which will spend the funds.
503    * @param _addedValue The amount of tokens to increase the allowance by.
504    */
505   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
506     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
507     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
508     return true;
509   }
510 
511   /**
512    * @dev Decrease the amount of tokens that an owner allowed to a spender.
513    *
514    * approve should be called when allowed[_spender] == 0. To decrement
515    * allowed value is better to use this function to avoid 2 calls (and wait until
516    * the first transaction is mined)
517    * From MonolithDAO Token.sol
518    * @param _spender The address which will spend the funds.
519    * @param _subtractedValue The amount of tokens to decrease the allowance by.
520    */
521   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
522     uint oldValue = allowed[msg.sender][_spender];
523     if (_subtractedValue > oldValue) {
524       allowed[msg.sender][_spender] = 0;
525     } else {
526       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
527     }
528     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
529     return true;
530   }
531 
532 }
533 
534 contract ERC827Token is ERC827, StandardToken {
535 
536   /**
537    * @dev Addition to ERC20 token methods. It allows to
538    * @dev approve the transfer of value and execute a call with the sent data.
539    *
540    * @dev Beware that changing an allowance with this method brings the risk that
541    * @dev someone may use both the old and the new allowance by unfortunate
542    * @dev transaction ordering. One possible solution to mitigate this race condition
543    * @dev is to first reduce the spender's allowance to 0 and set the desired value
544    * @dev afterwards:
545    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
546    *
547    * @param _spender The address that will spend the funds.
548    * @param _value The amount of tokens to be spent.
549    * @param _data ABI-encoded contract call to call `_to` address.
550    *
551    * @return true if the call function was executed successfully
552    */
553   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
554     require(_spender != address(this));
555 
556     super.approve(_spender, _value);
557 
558     // solium-disable-next-line security/no-call-value
559     require(_spender.call.value(msg.value)(_data));
560 
561     return true;
562   }
563 
564   /**
565    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
566    * @dev address and execute a call with the sent data on the same transaction
567    *
568    * @param _to address The address which you want to transfer to
569    * @param _value uint256 the amout of tokens to be transfered
570    * @param _data ABI-encoded contract call to call `_to` address.
571    *
572    * @return true if the call function was executed successfully
573    */
574   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
575     require(_to != address(this));
576 
577     super.transfer(_to, _value);
578 
579     // solium-disable-next-line security/no-call-value
580     require(_to.call.value(msg.value)(_data));
581     return true;
582   }
583 
584   /**
585    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
586    * @dev another and make a contract call on the same transaction
587    *
588    * @param _from The address which you want to send tokens from
589    * @param _to The address which you want to transfer to
590    * @param _value The amout of tokens to be transferred
591    * @param _data ABI-encoded contract call to call `_to` address.
592    *
593    * @return true if the call function was executed successfully
594    */
595   function transferFromAndCall(
596     address _from,
597     address _to,
598     uint256 _value,
599     bytes _data
600   )
601     public payable returns (bool)
602   {
603     require(_to != address(this));
604 
605     super.transferFrom(_from, _to, _value);
606 
607     // solium-disable-next-line security/no-call-value
608     require(_to.call.value(msg.value)(_data));
609     return true;
610   }
611 
612   /**
613    * @dev Addition to StandardToken methods. Increase the amount of tokens that
614    * @dev an owner allowed to a spender and execute a call with the sent data.
615    *
616    * @dev approve should be called when allowed[_spender] == 0. To increment
617    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
618    * @dev the first transaction is mined)
619    * @dev From MonolithDAO Token.sol
620    *
621    * @param _spender The address which will spend the funds.
622    * @param _addedValue The amount of tokens to increase the allowance by.
623    * @param _data ABI-encoded contract call to call `_spender` address.
624    */
625   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
626     require(_spender != address(this));
627 
628     super.increaseApproval(_spender, _addedValue);
629 
630     // solium-disable-next-line security/no-call-value
631     require(_spender.call.value(msg.value)(_data));
632 
633     return true;
634   }
635 
636   /**
637    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
638    * @dev an owner allowed to a spender and execute a call with the sent data.
639    *
640    * @dev approve should be called when allowed[_spender] == 0. To decrement
641    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
642    * @dev the first transaction is mined)
643    * @dev From MonolithDAO Token.sol
644    *
645    * @param _spender The address which will spend the funds.
646    * @param _subtractedValue The amount of tokens to decrease the allowance by.
647    * @param _data ABI-encoded contract call to call `_spender` address.
648    */
649   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
650     require(_spender != address(this));
651 
652     super.decreaseApproval(_spender, _subtractedValue);
653 
654     // solium-disable-next-line security/no-call-value
655     require(_spender.call.value(msg.value)(_data));
656 
657     return true;
658   }
659 
660 }
661 
662 contract TimedCrowdsale is Crowdsale {
663   using SafeMath for uint256;
664 
665   uint256 public openingTime;
666   uint256 public closingTime;
667 
668   /**
669    * @dev Reverts if not in crowdsale time range.
670    */
671   modifier onlyWhileOpen {
672     // solium-disable-next-line security/no-block-members
673     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
674     _;
675   }
676 
677   /**
678    * @dev Constructor, takes crowdsale opening and closing times.
679    * @param _openingTime Crowdsale opening time
680    * @param _closingTime Crowdsale closing time
681    */
682   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
683     // solium-disable-next-line security/no-block-members
684     require(_openingTime >= block.timestamp);
685     require(_closingTime >= _openingTime);
686 
687     openingTime = _openingTime;
688     closingTime = _closingTime;
689   }
690 
691   /**
692    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
693    * @return Whether crowdsale period has elapsed
694    */
695   function hasClosed() public view returns (bool) {
696     // solium-disable-next-line security/no-block-members
697     return block.timestamp > closingTime;
698   }
699 
700   /**
701    * @dev Extend parent behavior requiring to be within contributing period
702    * @param _beneficiary Token purchaser
703    * @param _weiAmount Amount of wei contributed
704    */
705   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
706     super._preValidatePurchase(_beneficiary, _weiAmount);
707   }
708 
709 }
710 
711 contract EDUCrowdsale is AllowanceCrowdsale, CappedCrowdsale, TimedCrowdsale, Ownable, Certifiable {
712     using SafeMath for uint256;
713 
714     uint256 constant FIFTY_ETH = 50 * (10 ** 18);
715     uint256 constant HUNDRED_AND_FIFTY_ETH = 150 * (10 ** 18);
716     uint256 constant TWO_HUNDRED_AND_FIFTY_ETH = 250 * (10 ** 18);
717 
718     EDUToken public token;
719     event TokenWalletChanged(address indexed newTokenWallet);
720     event WalletChanged(address indexed newWallet);
721 
722     constructor(
723         address _wallet,
724         EDUToken _token,
725         address _tokenWallet,
726         uint256 _cap,
727         uint256 _openingTime,
728         uint256 _closingTime,
729         address _certifier
730     ) public
731       Crowdsale(getCurrentRate(), _wallet, _token)
732       AllowanceCrowdsale(_tokenWallet)
733       CappedCrowdsale(_cap)
734       TimedCrowdsale(_openingTime, _closingTime)
735       Certifiable(_certifier)
736     {
737         token = _token;
738     }
739 
740     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
741         if (certifier.certified(_beneficiary)) {
742             token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
743         } else {
744             token.delayedTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
745         }
746     }
747 
748     /**
749      * @dev Returns the rate of tokens per wei at the present time.
750      * Note that, as price _increases_ with time, the rate _decreases_.
751      * @return The number of tokens a buyer gets per wei at a given time
752      */
753     function getCurrentRate() public view returns (uint256) {
754         if (block.timestamp < 1528156799) {         // 4th of June 2018 23:59:59 GTC
755             return 1050;
756         } else if (block.timestamp < 1528718400) {  // 11th of June 2018 12:00:00 GTC
757             return 940;
758         } else if (block.timestamp < 1529323200) {  // 18th of June 2018 12:00:00 GTC
759             return 865;
760         } else if (block.timestamp < 1529928000) {  // 25th of June 2018 12:00:00 GTC
761             return 790;
762         } else {
763             return 750;
764         }
765     }
766 
767     /**
768      * @dev Overrides parent method taking into account variable rate.
769      * @param _weiAmount The value in wei to be converted into tokens
770      * @return The number of tokens _weiAmount wei will buy at present time
771      */
772     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256)
773     {
774         uint256 currentRate = getCurrentRate();
775         uint256 volumeBonus = _getVolumeBonus(currentRate, _weiAmount);
776         return currentRate.mul(_weiAmount).add(volumeBonus);
777     }
778 
779     function _getVolumeBonus(uint256 _currentRate, uint256 _weiAmount) internal view returns (uint256) {
780         if (_weiAmount >= FIFTY_ETH) {
781             if (_weiAmount >= HUNDRED_AND_FIFTY_ETH) {
782                 if (_weiAmount >= TWO_HUNDRED_AND_FIFTY_ETH) {
783                     return _currentRate.mul(_weiAmount).mul(15).div(100);
784                 }
785                 return _currentRate.mul(_weiAmount).mul(10).div(100);
786             }
787             return _currentRate.mul(_weiAmount).mul(5).div(100);
788         }
789         return 0;
790     }
791 
792     function changeTokenWallet(address _tokenWallet) external onlyOwner {
793         require(_tokenWallet != address(0x0));
794         tokenWallet = _tokenWallet;
795         emit TokenWalletChanged(_tokenWallet);
796     }
797 
798     function changeWallet(address _wallet) external onlyOwner {
799         require(_wallet != address(0x0));
800         wallet = _wallet;
801         emit WalletChanged(_wallet);
802     }
803 
804 }
805 
806 contract EDUToken is BurnableToken, KYCToken, ERC827Token {
807     using SafeMath for uint256;
808 
809     string public constant name = "EDU Token";
810     string public constant symbol = "EDU";
811     uint8 public constant decimals = 18;
812 
813     uint256 public constant INITIAL_SUPPLY = 48000000 * (10 ** uint256(decimals));
814 
815     constructor(address _certifier) public KYCToken(_certifier) {
816         totalSupply_ = INITIAL_SUPPLY;
817         balances[msg.sender] = INITIAL_SUPPLY;
818         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
819     }
820 
821     function transfer(address _to, uint256 _value) public isKnownCustomer(msg.sender) returns (bool) {
822         return super.transfer(_to, _value);
823     }
824 
825     function transferFrom(address _from, address _to, uint256 _value) public isKnownCustomer(_from) returns (bool) {
826         return super.transferFrom(_from, _to, _value);
827     }
828 
829     function approve(address _spender, uint256 _value) public isKnownCustomer(_spender) returns (bool) {
830         return super.approve(_spender, _value);
831     }
832 
833     function increaseApproval(address _spender, uint _addedValue) public isKnownCustomer(_spender) returns (bool success) {
834         return super.increaseApproval(_spender, _addedValue);
835     }
836 
837     function decreaseApproval(address _spender, uint _subtractedValue) public isKnownCustomer(_spender) returns (bool success) {
838         return super.decreaseApproval(_spender, _subtractedValue);
839     }
840 
841     function delayedTransferFrom(address _tokenWallet, address _to, uint256 _value) public onlyManager returns (bool) {
842         transferFrom(_tokenWallet, _to, _value);
843         kycPending[_to] = true;
844     }
845 
846 }
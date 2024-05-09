1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Certifiable is Ownable {
81     Certifier public certifier;
82     event CertifierChanged(address indexed newCertifier);
83 
84     constructor(address _certifier) public {
85         certifier = Certifier(_certifier);
86     }
87 
88     function updateCertifier(address _address) public onlyOwner returns (bool success) {
89         require(_address != address(0));
90         emit CertifierChanged(_address);
91         certifier = Certifier(_address);
92         return true;
93     }
94 }
95 
96 contract KYCToken is Certifiable {
97     mapping(address => bool) public kycPending;
98     mapping(address => bool) public managers;
99 
100     event ManagerAdded(address indexed newManager);
101     event ManagerRemoved(address indexed removedManager);
102 
103     modifier onlyManager() {
104         require(managers[msg.sender] == true);
105         _;
106     }
107 
108     modifier isKnownCustomer(address _address) {
109         require(!kycPending[_address] || certifier.certified(_address));
110         if (kycPending[_address]) {
111             kycPending[_address] = false;
112         }
113         _;
114     }
115 
116     constructor(address _certifier) public Certifiable(_certifier)
117     {
118 
119     }
120 
121     function addManager(address _address) external onlyOwner {
122         managers[_address] = true;
123         emit ManagerAdded(_address);
124     }
125 
126     function removeManager(address _address) external onlyOwner {
127         managers[_address] = false;
128         emit ManagerRemoved(_address);
129     }
130 
131 }
132 
133 contract Certifier {
134     event Confirmed(address indexed who);
135     event Revoked(address indexed who);
136     function certified(address) public constant returns (bool);
137     function get(address, string) public constant returns (bytes32);
138     function getAddress(address, string) public constant returns (address);
139     function getUint(address, string) public constant returns (uint);
140 }
141 
142 contract Crowdsale {
143   using SafeMath for uint256;
144 
145   // The token being sold
146   ERC20 public token;
147 
148   // Address where funds are collected
149   address public wallet;
150 
151   // How many token units a buyer gets per wei
152   uint256 public rate;
153 
154   // Amount of wei raised
155   uint256 public weiRaised;
156 
157   /**
158    * Event for token purchase logging
159    * @param purchaser who paid for the tokens
160    * @param beneficiary who got the tokens
161    * @param value weis paid for purchase
162    * @param amount amount of tokens purchased
163    */
164   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
165 
166   /**
167    * @param _rate Number of token units a buyer gets per wei
168    * @param _wallet Address where collected funds will be forwarded to
169    * @param _token Address of the token being sold
170    */
171   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
172     require(_rate > 0);
173     require(_wallet != address(0));
174     require(_token != address(0));
175 
176     rate = _rate;
177     wallet = _wallet;
178     token = _token;
179   }
180 
181   // -----------------------------------------
182   // Crowdsale external interface
183   // -----------------------------------------
184 
185   /**
186    * @dev fallback function ***DO NOT OVERRIDE***
187    */
188   function () external payable {
189     buyTokens(msg.sender);
190   }
191 
192   /**
193    * @dev low level token purchase ***DO NOT OVERRIDE***
194    * @param _beneficiary Address performing the token purchase
195    */
196   function buyTokens(address _beneficiary) public payable {
197 
198     uint256 weiAmount = msg.value;
199     _preValidatePurchase(_beneficiary, weiAmount);
200 
201     // calculate token amount to be created
202     uint256 tokens = _getTokenAmount(weiAmount);
203 
204     // update state
205     weiRaised = weiRaised.add(weiAmount);
206 
207     _processPurchase(_beneficiary, tokens);
208     emit TokenPurchase(
209       msg.sender,
210       _beneficiary,
211       weiAmount,
212       tokens
213     );
214 
215     _updatePurchasingState(_beneficiary, weiAmount);
216 
217     _forwardFunds();
218     _postValidatePurchase(_beneficiary, weiAmount);
219   }
220 
221   // -----------------------------------------
222   // Internal interface (extensible)
223   // -----------------------------------------
224 
225   /**
226    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
227    * @param _beneficiary Address performing the token purchase
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
231     require(_beneficiary != address(0));
232     require(_weiAmount != 0);
233   }
234 
235   /**
236    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
237    * @param _beneficiary Address performing the token purchase
238    * @param _weiAmount Value in wei involved in the purchase
239    */
240   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
241     // optional override
242   }
243 
244   /**
245    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
246    * @param _beneficiary Address performing the token purchase
247    * @param _tokenAmount Number of tokens to be emitted
248    */
249   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
250     token.transfer(_beneficiary, _tokenAmount);
251   }
252 
253   /**
254    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
255    * @param _beneficiary Address receiving the tokens
256    * @param _tokenAmount Number of tokens to be purchased
257    */
258   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
259     _deliverTokens(_beneficiary, _tokenAmount);
260   }
261 
262   /**
263    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
264    * @param _beneficiary Address receiving the tokens
265    * @param _weiAmount Value in wei involved in the purchase
266    */
267   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
268     // optional override
269   }
270 
271   /**
272    * @dev Override to extend the way in which ether is converted to tokens.
273    * @param _weiAmount Value in wei to be converted into tokens
274    * @return Number of tokens that can be purchased with the specified _weiAmount
275    */
276   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
277     return _weiAmount.mul(rate);
278   }
279 
280   /**
281    * @dev Determines how ETH is stored/forwarded on purchases.
282    */
283   function _forwardFunds() internal {
284     wallet.transfer(msg.value);
285   }
286 }
287 
288 contract TimedCrowdsale is Crowdsale {
289   using SafeMath for uint256;
290 
291   uint256 public openingTime;
292   uint256 public closingTime;
293 
294   /**
295    * @dev Reverts if not in crowdsale time range.
296    */
297   modifier onlyWhileOpen {
298     // solium-disable-next-line security/no-block-members
299     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
300     _;
301   }
302 
303   /**
304    * @dev Constructor, takes crowdsale opening and closing times.
305    * @param _openingTime Crowdsale opening time
306    * @param _closingTime Crowdsale closing time
307    */
308   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
309     // solium-disable-next-line security/no-block-members
310     require(_openingTime >= block.timestamp);
311     require(_closingTime >= _openingTime);
312 
313     openingTime = _openingTime;
314     closingTime = _closingTime;
315   }
316 
317   /**
318    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
319    * @return Whether crowdsale period has elapsed
320    */
321   function hasClosed() public view returns (bool) {
322     // solium-disable-next-line security/no-block-members
323     return block.timestamp > closingTime;
324   }
325 
326   /**
327    * @dev Extend parent behavior requiring to be within contributing period
328    * @param _beneficiary Token purchaser
329    * @param _weiAmount Amount of wei contributed
330    */
331   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
332     super._preValidatePurchase(_beneficiary, _weiAmount);
333   }
334 
335 }
336 
337 contract AllowanceCrowdsale is Crowdsale {
338   using SafeMath for uint256;
339 
340   address public tokenWallet;
341 
342   /**
343    * @dev Constructor, takes token wallet address. 
344    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
345    */
346   function AllowanceCrowdsale(address _tokenWallet) public {
347     require(_tokenWallet != address(0));
348     tokenWallet = _tokenWallet;
349   }
350 
351   /**
352    * @dev Checks the amount of tokens left in the allowance.
353    * @return Amount of tokens left in the allowance
354    */
355   function remainingTokens() public view returns (uint256) {
356     return token.allowance(tokenWallet, this);
357   }
358 
359   /**
360    * @dev Overrides parent behavior by transferring tokens from wallet.
361    * @param _beneficiary Token purchaser
362    * @param _tokenAmount Amount of tokens purchased
363    */
364   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
365     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
366   }
367 }
368 
369 contract ERC20Basic {
370   function totalSupply() public view returns (uint256);
371   function balanceOf(address who) public view returns (uint256);
372   function transfer(address to, uint256 value) public returns (bool);
373   event Transfer(address indexed from, address indexed to, uint256 value);
374 }
375 
376 contract ERC20 is ERC20Basic {
377   function allowance(address owner, address spender) public view returns (uint256);
378   function transferFrom(address from, address to, uint256 value) public returns (bool);
379   function approve(address spender, uint256 value) public returns (bool);
380   event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 contract ERC827 is ERC20 {
384   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
385   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
386   function transferFromAndCall(
387     address _from,
388     address _to,
389     uint256 _value,
390     bytes _data
391   )
392     public
393     payable
394     returns (bool);
395 }
396 
397 contract BasicToken is ERC20Basic {
398   using SafeMath for uint256;
399 
400   mapping(address => uint256) balances;
401 
402   uint256 totalSupply_;
403 
404   /**
405   * @dev total number of tokens in existence
406   */
407   function totalSupply() public view returns (uint256) {
408     return totalSupply_;
409   }
410 
411   /**
412   * @dev transfer token for a specified address
413   * @param _to The address to transfer to.
414   * @param _value The amount to be transferred.
415   */
416   function transfer(address _to, uint256 _value) public returns (bool) {
417     require(_to != address(0));
418     require(_value <= balances[msg.sender]);
419 
420     balances[msg.sender] = balances[msg.sender].sub(_value);
421     balances[_to] = balances[_to].add(_value);
422     emit Transfer(msg.sender, _to, _value);
423     return true;
424   }
425 
426   /**
427   * @dev Gets the balance of the specified address.
428   * @param _owner The address to query the the balance of.
429   * @return An uint256 representing the amount owned by the passed address.
430   */
431   function balanceOf(address _owner) public view returns (uint256) {
432     return balances[_owner];
433   }
434 
435 }
436 
437 contract StandardToken is ERC20, BasicToken {
438 
439   mapping (address => mapping (address => uint256)) internal allowed;
440 
441 
442   /**
443    * @dev Transfer tokens from one address to another
444    * @param _from address The address which you want to send tokens from
445    * @param _to address The address which you want to transfer to
446    * @param _value uint256 the amount of tokens to be transferred
447    */
448   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
449     require(_to != address(0));
450     require(_value <= balances[_from]);
451     require(_value <= allowed[_from][msg.sender]);
452 
453     balances[_from] = balances[_from].sub(_value);
454     balances[_to] = balances[_to].add(_value);
455     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
456     emit Transfer(_from, _to, _value);
457     return true;
458   }
459 
460   /**
461    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
462    *
463    * Beware that changing an allowance with this method brings the risk that someone may use both the old
464    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
465    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
466    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
467    * @param _spender The address which will spend the funds.
468    * @param _value The amount of tokens to be spent.
469    */
470   function approve(address _spender, uint256 _value) public returns (bool) {
471     allowed[msg.sender][_spender] = _value;
472     emit Approval(msg.sender, _spender, _value);
473     return true;
474   }
475 
476   /**
477    * @dev Function to check the amount of tokens that an owner allowed to a spender.
478    * @param _owner address The address which owns the funds.
479    * @param _spender address The address which will spend the funds.
480    * @return A uint256 specifying the amount of tokens still available for the spender.
481    */
482   function allowance(address _owner, address _spender) public view returns (uint256) {
483     return allowed[_owner][_spender];
484   }
485 
486   /**
487    * @dev Increase the amount of tokens that an owner allowed to a spender.
488    *
489    * approve should be called when allowed[_spender] == 0. To increment
490    * allowed value is better to use this function to avoid 2 calls (and wait until
491    * the first transaction is mined)
492    * From MonolithDAO Token.sol
493    * @param _spender The address which will spend the funds.
494    * @param _addedValue The amount of tokens to increase the allowance by.
495    */
496   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
497     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
498     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
499     return true;
500   }
501 
502   /**
503    * @dev Decrease the amount of tokens that an owner allowed to a spender.
504    *
505    * approve should be called when allowed[_spender] == 0. To decrement
506    * allowed value is better to use this function to avoid 2 calls (and wait until
507    * the first transaction is mined)
508    * From MonolithDAO Token.sol
509    * @param _spender The address which will spend the funds.
510    * @param _subtractedValue The amount of tokens to decrease the allowance by.
511    */
512   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
513     uint oldValue = allowed[msg.sender][_spender];
514     if (_subtractedValue > oldValue) {
515       allowed[msg.sender][_spender] = 0;
516     } else {
517       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
518     }
519     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
520     return true;
521   }
522 
523 }
524 
525 contract ERC827Token is ERC827, StandardToken {
526 
527   /**
528    * @dev Addition to ERC20 token methods. It allows to
529    * @dev approve the transfer of value and execute a call with the sent data.
530    *
531    * @dev Beware that changing an allowance with this method brings the risk that
532    * @dev someone may use both the old and the new allowance by unfortunate
533    * @dev transaction ordering. One possible solution to mitigate this race condition
534    * @dev is to first reduce the spender's allowance to 0 and set the desired value
535    * @dev afterwards:
536    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
537    *
538    * @param _spender The address that will spend the funds.
539    * @param _value The amount of tokens to be spent.
540    * @param _data ABI-encoded contract call to call `_to` address.
541    *
542    * @return true if the call function was executed successfully
543    */
544   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
545     require(_spender != address(this));
546 
547     super.approve(_spender, _value);
548 
549     // solium-disable-next-line security/no-call-value
550     require(_spender.call.value(msg.value)(_data));
551 
552     return true;
553   }
554 
555   /**
556    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
557    * @dev address and execute a call with the sent data on the same transaction
558    *
559    * @param _to address The address which you want to transfer to
560    * @param _value uint256 the amout of tokens to be transfered
561    * @param _data ABI-encoded contract call to call `_to` address.
562    *
563    * @return true if the call function was executed successfully
564    */
565   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
566     require(_to != address(this));
567 
568     super.transfer(_to, _value);
569 
570     // solium-disable-next-line security/no-call-value
571     require(_to.call.value(msg.value)(_data));
572     return true;
573   }
574 
575   /**
576    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
577    * @dev another and make a contract call on the same transaction
578    *
579    * @param _from The address which you want to send tokens from
580    * @param _to The address which you want to transfer to
581    * @param _value The amout of tokens to be transferred
582    * @param _data ABI-encoded contract call to call `_to` address.
583    *
584    * @return true if the call function was executed successfully
585    */
586   function transferFromAndCall(
587     address _from,
588     address _to,
589     uint256 _value,
590     bytes _data
591   )
592     public payable returns (bool)
593   {
594     require(_to != address(this));
595 
596     super.transferFrom(_from, _to, _value);
597 
598     // solium-disable-next-line security/no-call-value
599     require(_to.call.value(msg.value)(_data));
600     return true;
601   }
602 
603   /**
604    * @dev Addition to StandardToken methods. Increase the amount of tokens that
605    * @dev an owner allowed to a spender and execute a call with the sent data.
606    *
607    * @dev approve should be called when allowed[_spender] == 0. To increment
608    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
609    * @dev the first transaction is mined)
610    * @dev From MonolithDAO Token.sol
611    *
612    * @param _spender The address which will spend the funds.
613    * @param _addedValue The amount of tokens to increase the allowance by.
614    * @param _data ABI-encoded contract call to call `_spender` address.
615    */
616   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
617     require(_spender != address(this));
618 
619     super.increaseApproval(_spender, _addedValue);
620 
621     // solium-disable-next-line security/no-call-value
622     require(_spender.call.value(msg.value)(_data));
623 
624     return true;
625   }
626 
627   /**
628    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
629    * @dev an owner allowed to a spender and execute a call with the sent data.
630    *
631    * @dev approve should be called when allowed[_spender] == 0. To decrement
632    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
633    * @dev the first transaction is mined)
634    * @dev From MonolithDAO Token.sol
635    *
636    * @param _spender The address which will spend the funds.
637    * @param _subtractedValue The amount of tokens to decrease the allowance by.
638    * @param _data ABI-encoded contract call to call `_spender` address.
639    */
640   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
641     require(_spender != address(this));
642 
643     super.decreaseApproval(_spender, _subtractedValue);
644 
645     // solium-disable-next-line security/no-call-value
646     require(_spender.call.value(msg.value)(_data));
647 
648     return true;
649   }
650 
651 }
652 
653 contract BurnableToken is BasicToken {
654 
655   event Burn(address indexed burner, uint256 value);
656 
657   /**
658    * @dev Burns a specific amount of tokens.
659    * @param _value The amount of token to be burned.
660    */
661   function burn(uint256 _value) public {
662     _burn(msg.sender, _value);
663   }
664 
665   function _burn(address _who, uint256 _value) internal {
666     require(_value <= balances[_who]);
667     // no need to require value <= totalSupply, since that would imply the
668     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
669 
670     balances[_who] = balances[_who].sub(_value);
671     totalSupply_ = totalSupply_.sub(_value);
672     emit Burn(_who, _value);
673     emit Transfer(_who, address(0), _value);
674   }
675 }
676 
677 contract EDUToken is BurnableToken, KYCToken, ERC827Token {
678     using SafeMath for uint256;
679 
680     string public constant name = "EDU Token";
681     string public constant symbol = "EDU";
682     uint8 public constant decimals = 18;
683 
684     uint256 public constant INITIAL_SUPPLY = 48000000 * (10 ** uint256(decimals));
685 
686     constructor(address _certifier) public KYCToken(_certifier) {
687         totalSupply_ = INITIAL_SUPPLY;
688         balances[msg.sender] = INITIAL_SUPPLY;
689         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
690     }
691 
692     function transfer(address _to, uint256 _value) public isKnownCustomer(msg.sender) returns (bool) {
693         return super.transfer(_to, _value);
694     }
695 
696     function transferFrom(address _from, address _to, uint256 _value) public isKnownCustomer(_from) returns (bool) {
697         return super.transferFrom(_from, _to, _value);
698     }
699 
700     function approve(address _spender, uint256 _value) public isKnownCustomer(_spender) returns (bool) {
701         return super.approve(_spender, _value);
702     }
703 
704     function increaseApproval(address _spender, uint _addedValue) public isKnownCustomer(_spender) returns (bool success) {
705         return super.increaseApproval(_spender, _addedValue);
706     }
707 
708     function decreaseApproval(address _spender, uint _subtractedValue) public isKnownCustomer(_spender) returns (bool success) {
709         return super.decreaseApproval(_spender, _subtractedValue);
710     }
711 
712     function delayedTransferFrom(address _tokenWallet, address _to, uint256 _value) public onlyManager returns (bool) {
713         transferFrom(_tokenWallet, _to, _value);
714         kycPending[_to] = true;
715     }
716 
717 }
718 
719 contract CappedCrowdsale is Crowdsale {
720   using SafeMath for uint256;
721 
722   uint256 public cap;
723 
724   /**
725    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
726    * @param _cap Max amount of wei to be contributed
727    */
728   function CappedCrowdsale(uint256 _cap) public {
729     require(_cap > 0);
730     cap = _cap;
731   }
732 
733   /**
734    * @dev Checks whether the cap has been reached. 
735    * @return Whether the cap was reached
736    */
737   function capReached() public view returns (bool) {
738     return weiRaised >= cap;
739   }
740 
741   /**
742    * @dev Extend parent behavior requiring purchase to respect the funding cap.
743    * @param _beneficiary Token purchaser
744    * @param _weiAmount Amount of wei contributed
745    */
746   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
747     super._preValidatePurchase(_beneficiary, _weiAmount);
748     require(weiRaised.add(_weiAmount) <= cap);
749   }
750 
751 }
752 
753 contract EDUCrowdsale is AllowanceCrowdsale, CappedCrowdsale, TimedCrowdsale, Ownable, Certifiable {
754     using SafeMath for uint256;
755 
756     uint256 constant FIFTY_ETH = 50 * (10 ** 18);
757     uint256 constant HUNDRED_AND_FIFTY_ETH = 150 * (10 ** 18);
758     uint256 constant TWO_HUNDRED_AND_FIFTY_ETH = 250 * (10 ** 18);
759     uint256 constant TEN_ETH = 10 * (10 ** 18);
760 
761     EDUToken public token;
762     event TokenWalletChanged(address indexed newTokenWallet);
763     event WalletChanged(address indexed newWallet);
764 
765     constructor(
766         address _wallet,
767         EDUToken _token,
768         address _tokenWallet,
769         uint256 _cap,
770         uint256 _openingTime,
771         uint256 _closingTime,
772         address _certifier
773     ) public
774       Crowdsale(getCurrentRate(), _wallet, _token)
775       AllowanceCrowdsale(_tokenWallet)
776       CappedCrowdsale(_cap)
777       TimedCrowdsale(_openingTime, _closingTime)
778       Certifiable(_certifier)
779     {
780         token = _token;
781     }
782 
783     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
784         if (certifier.certified(_beneficiary)) {
785             token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
786         } else {
787             token.delayedTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
788         }
789     }
790 
791     /**
792      * @dev Returns the rate of tokens per wei at the present time.
793      * Note that, as price _increases_ with time, the rate _decreases_.
794      * @return The number of tokens a buyer gets per wei at a given time
795      */
796     function getCurrentRate() public view returns (uint256) {
797         if (block.timestamp < 1528156799) {         // 4th of June 2018 23:59:59 GTC
798             return 1050;
799         } else if (block.timestamp < 1528718400) {  // 11th of June 2018 12:00:00 GTC
800             return 940;
801         } else if (block.timestamp < 1529323200) {  // 18th of June 2018 12:00:00 GTC
802             return 865;
803         } else if (block.timestamp < 1529928000) {  // 25th of June 2018 12:00:00 GTC
804             return 790;
805         } else {
806             return 750;
807         }
808     }
809 
810     /**
811      * @dev Overrides parent method taking into account variable rate.
812      * @param _weiAmount The value in wei to be converted into tokens
813      * @return The number of tokens _weiAmount wei will buy at present time
814      */
815     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256)
816     {
817         uint256 currentRate = getCurrentRate();
818         uint256 volumeBonus = _getVolumeBonus(currentRate, _weiAmount);
819         return currentRate.mul(_weiAmount).add(volumeBonus);
820     }
821 
822     function _getVolumeBonus(uint256 _currentRate, uint256 _weiAmount) internal view returns (uint256) {
823         if (_weiAmount >= TEN_ETH) {
824             return _currentRate.mul(_weiAmount).mul(20).div(100);
825         }
826         return 0;
827     }
828 
829     function changeTokenWallet(address _tokenWallet) external onlyOwner {
830         require(_tokenWallet != address(0x0));
831         tokenWallet = _tokenWallet;
832         emit TokenWalletChanged(_tokenWallet);
833     }
834 
835     function changeWallet(address _wallet) external onlyOwner {
836         require(_wallet != address(0x0));
837         wallet = _wallet;
838         emit WalletChanged(_wallet);
839     }
840 
841 }
1 pragma solidity ^ 0.4 .24;
2 
3 library SafeMath {
4 
5   /**
6    * @dev Multiplies two numbers, reverts on overflow.
7    */
8   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24    */
25   function div(uint256 a, uint256 b) internal pure returns(uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35    */
36   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44    * @dev Adds two numbers, reverts on overflow.
45    */
46   function add(uint256 a, uint256 b) internal pure returns(uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55    * reverts when dividing by zero.
56    */
57   function mod(uint256 a, uint256 b) internal pure returns(uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 contract Ownable {
64   address private _owner;
65 
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() internal {
76     _owner = msg.sender;
77     emit OwnershipTransferred(address(0), _owner);
78   }
79 
80   /**
81    * @return the address of the owner.
82    */
83   function owner() public view returns(address) {
84     return _owner;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(isOwner());
92     _;
93   }
94 
95   /**
96    * @return true if `msg.sender` is the owner of the contract.
97    */
98   function isOwner() public view returns(bool) {
99     return msg.sender == _owner;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipTransferred(_owner, address(0));
110     _owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     _transferOwnership(newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address newOwner) internal {
126     require(newOwner != address(0));
127     emit OwnershipTransferred(_owner, newOwner);
128     _owner = newOwner;
129   }
130 }
131 
132 interface IERC20 {
133   function totalSupply() external view returns(uint256);
134 
135   function balanceOf(address who) external view returns(uint256);
136 
137   function allowance(address owner, address spender)
138   external view returns(uint256);
139 
140   function transfer(address to, uint256 value) external returns(bool);
141 
142   function approve(address spender, uint256 value)
143   external returns(bool);
144 
145   function transferFrom(address from, address to, uint256 value)
146   external returns(bool);
147 
148   event Transfer(
149     address indexed from,
150     address indexed to,
151     uint256 value
152   );
153 
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 contract ERC20 is IERC20 {
162   using SafeMath
163   for uint256;
164 
165   mapping(address => uint256) private _balances;
166 
167   mapping(address => mapping(address => uint256)) private _allowed;
168 
169   uint256 private _totalSupply;
170 
171   /**
172    * @dev Total number of tokens in existence
173    */
174   function totalSupply() public view returns(uint256) {
175     return _totalSupply;
176   }
177 
178   /**
179    * @dev Gets the balance of the specified address.
180    * @param owner The address to query the balance of.
181    * @return An uint256 representing the amount owned by the passed address.
182    */
183   function balanceOf(address owner) public view returns(uint256) {
184     return _balances[owner];
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param owner address The address which owns the funds.
190    * @param spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address owner,
195     address spender
196   )
197   public
198   view
199   returns(uint256) {
200     return _allowed[owner][spender];
201   }
202 
203   /**
204    * @dev Transfer token for a specified address
205    * @param to The address to transfer to.
206    * @param value The amount to be transferred.
207    */
208   function transfer(address to, uint256 value) public returns(bool) {
209     _transfer(msg.sender, to, value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param spender The address which will spend the funds.
220    * @param value The amount of tokens to be spent.
221    */
222   function approve(address spender, uint256 value) public returns(bool) {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = value;
226     emit Approval(msg.sender, spender, value);
227     return true;
228   }
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param from address The address which you want to send tokens from
233    * @param to address The address which you want to transfer to
234    * @param value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(
237     address from,
238     address to,
239     uint256 value
240   )
241   public
242   returns(bool) {
243     require(value <= _allowed[from][msg.sender]);
244 
245     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
246     _transfer(from, to, value);
247     return true;
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    * approve should be called when allowed_[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param spender The address which will spend the funds.
257    * @param addedValue The amount of tokens to increase the allowance by.
258    */
259   function increaseAllowance(
260     address spender,
261     uint256 addedValue
262   )
263   public
264   returns(bool) {
265     require(spender != address(0));
266 
267     _allowed[msg.sender][spender] = (
268       _allowed[msg.sender][spender].add(addedValue));
269     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed_[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param spender The address which will spend the funds.
280    * @param subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseAllowance(
283     address spender,
284     uint256 subtractedValue
285   )
286   public
287   returns(bool) {
288     require(spender != address(0));
289 
290     _allowed[msg.sender][spender] = (
291       _allowed[msg.sender][spender].sub(subtractedValue));
292     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
293     return true;
294   }
295 
296   /**
297    * @dev Transfer token for a specified addresses
298    * @param from The address to transfer from.
299    * @param to The address to transfer to.
300    * @param value The amount to be transferred.
301    */
302   function _transfer(address from, address to, uint256 value) internal {
303     require(value <= _balances[from]);
304     require(to != address(0));
305 
306     _balances[from] = _balances[from].sub(value);
307     _balances[to] = _balances[to].add(value);
308     emit Transfer(from, to, value);
309   }
310 
311   /**
312    * @dev Internal function that mints an amount of the token and assigns it to
313    * an account. This encapsulates the modification of balances such that the
314    * proper events are emitted.
315    * @param account The account that will receive the created tokens.
316    * @param value The amount that will be created.
317    */
318   function _mint(address account, uint256 value) internal {
319     require(account != 0);
320     _totalSupply = _totalSupply.add(value);
321     _balances[account] = _balances[account].add(value);
322     emit Transfer(address(0), account, value);
323   }
324 
325   /**
326    * @dev Internal function that burns an amount of the token of a given
327    * account.
328    * @param account The account whose tokens will be burnt.
329    * @param value The amount that will be burnt.
330    */
331   function _burn(address account, uint256 value) internal {
332     require(account != 0);
333     require(value <= _balances[account]);
334 
335     _totalSupply = _totalSupply.sub(value);
336     _balances[account] = _balances[account].sub(value);
337     emit Transfer(account, address(0), value);
338   }
339 
340   /**
341    * @dev Internal function that burns an amount of the token of a given
342    * account, deducting from the sender's allowance for said account. Uses the
343    * internal burn function.
344    * @param account The account whose tokens will be burnt.
345    * @param value The amount that will be burnt.
346    */
347   function _burnFrom(address account, uint256 value) internal {
348     require(value <= _allowed[account][msg.sender]);
349 
350     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
351     // this function needs to emit an event with the updated approval.
352     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
353       value);
354     _burn(account, value);
355   }
356 }
357 
358 contract ERC20Detailed is IERC20 {
359   string private _name;
360   string private _symbol;
361   uint8 private _decimals;
362 
363   constructor(string name, string symbol, uint8 decimals) public {
364     _name = name;
365     _symbol = symbol;
366     _decimals = decimals;
367   }
368 
369   /**
370    * @return the name of the token.
371    */
372   function name() public view returns(string) {
373     return _name;
374   }
375 
376   /**
377    * @return the symbol of the token.
378    */
379   function symbol() public view returns(string) {
380     return _symbol;
381   }
382 
383   /**
384    * @return the number of decimals of the token.
385    */
386   function decimals() public view returns(uint8) {
387     return _decimals;
388   }
389 }
390 
391 library SafeERC20 {
392 
393   using SafeMath
394   for uint256;
395 
396   function safeTransfer(
397     IERC20 token,
398     address to,
399     uint256 value
400   )
401   internal {
402     require(token.transfer(to, value));
403   }
404 
405   function safeTransferFrom(
406     IERC20 token,
407     address from,
408     address to,
409     uint256 value
410   )
411   internal {
412     require(token.transferFrom(from, to, value));
413   }
414 
415   function safeApprove(
416     IERC20 token,
417     address spender,
418     uint256 value
419   )
420   internal {
421     // safeApprove should only be called when setting an initial allowance, 
422     // or when resetting it to zero. To increase and decrease it, use 
423     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
425     require(token.approve(spender, value));
426   }
427 
428   function safeIncreaseAllowance(
429     IERC20 token,
430     address spender,
431     uint256 value
432   )
433   internal {
434     uint256 newAllowance = token.allowance(address(this), spender).add(value);
435     require(token.approve(spender, newAllowance));
436   }
437 
438   function safeDecreaseAllowance(
439     IERC20 token,
440     address spender,
441     uint256 value
442   )
443   internal {
444     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
445     require(token.approve(spender, newAllowance));
446   }
447 }
448 
449 contract ReentrancyGuard {
450 
451   /// @dev counter to allow mutex lock with only one SSTORE operation
452   uint256 private _guardCounter;
453 
454   constructor() internal {
455     // The counter starts at one to prevent changing it from zero to a non-zero
456     // value, which is a more expensive operation.
457     _guardCounter = 1;
458   }
459 
460   /**
461    * @dev Prevents a contract from calling itself, directly or indirectly.
462    * Calling a `nonReentrant` function from another `nonReentrant`
463    * function is not supported. It is possible to prevent this from happening
464    * by making the `nonReentrant` function external, and make it call a
465    * `private` function that does the actual work.
466    */
467   modifier nonReentrant() {
468     _guardCounter += 1;
469     uint256 localCounter = _guardCounter;
470     _;
471     require(localCounter == _guardCounter);
472   }
473 
474 }
475 
476 contract FlychatToken is ERC20, ERC20Detailed, ReentrancyGuard, Ownable {
477   using SafeMath
478   for uint256;
479   using SafeERC20
480   for IERC20;
481 
482   // The token being sold
483   IERC20 private _token;
484 
485   // Address where funds are collected
486   address private _wallet;
487 
488   // How many token units a buyer gets per wei.
489   // The rate is the conversion between wei and the smallest and indivisible token unit.
490   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
491   // 1 wei will give you 1 unit, or 0.001 TOK.
492   uint256 private _rate;
493 
494   // Amount of wei raised
495   uint256 private _weiRaised;
496 
497   /**
498    * Event for token purchase logging
499    * @param purchaser who paid for the tokens
500    * @param beneficiary who got the tokens
501    * @param value weis paid for purchase
502    * @param amount amount of tokens purchased
503    */
504   event TokensPurchased(
505     address indexed purchaser,
506     address indexed beneficiary,
507     uint256 value,
508     uint256 amount
509   );
510   uint256 public constant INITIAL_SUPPLY = 6000000000 * (10 ** uint256(decimals()));
511   uint256 public constant INITIAL_SUPPLY2 = 14000000000 * (10 ** uint256(decimals()));
512   uint256 public rate = 10000000;
513 
514   enum CrowdsaleStage {
515     presale,
516     ico
517   }
518   CrowdsaleStage public stage = CrowdsaleStage.presale;
519 
520   bool public allowbuy = false;
521   bool public endbuy = false;
522   uint256 public preallocation = 2400000000 * (10 ** uint256(18));
523   uint256 public icoallocation = 9600000000 * (10 ** uint256(18));
524   uint256 public minbuy = 10000000000000000;
525   uint256 public availableonpresale = preallocation;
526   uint256 public availableonico = icoallocation;
527 
528   constructor(address wallet) public
529   ERC20Detailed("FlychatToken", "FLY", 18) {
530     require(rate > 0);
531     require(wallet != address(0));
532 
533     _rate = rate;
534     _wallet = wallet;
535     _token = this;
536 
537     _mint(msg.sender, INITIAL_SUPPLY);
538     _mint(this, INITIAL_SUPPLY2);
539   }
540 
541   function setallowbuy(bool status) public onlyOwner {
542     allowbuy = status;
543   }
544 
545   function setendbuy(bool status) public onlyOwner {
546     endbuy = status;
547   }
548 
549   function setstage(uint8 _stage) public onlyOwner {
550     setCrowdsaleStage(_stage);
551   }
552 
553   function setCrowdsaleStage(uint8 _stage) internal {
554     require(_stage > uint8(stage) && _stage < 2);
555 
556     if (uint8(CrowdsaleStage.presale) == _stage) {
557       stage = CrowdsaleStage.presale;
558     } else {
559       stage = CrowdsaleStage.ico;
560     }
561   }
562 
563 
564   // -----------------------------------------
565   // Crowdsale external interface
566   // -----------------------------------------
567 
568   /**
569    * @dev fallback function ***DO NOT OVERRIDE***
570    * Note that other contracts will transfer fund with a base gas stipend
571    * of 2300, which is not enough to call buyTokens. Consider calling
572    * buyTokens directly when purchasing tokens from a contract.
573    */
574   function () external payable {
575     buyTokens(msg.sender);
576   }
577 
578   /**
579    * @return the token being sold.
580    */
581   function token() public view returns(IERC20) {
582     return _token;
583   }
584 
585   /**
586    * @return the address where funds are collected.
587    */
588   function wallet() public view returns(address) {
589     return _wallet;
590   }
591 
592   /**
593    * @return the number of token units a buyer gets per wei.
594    */
595   function rate() public view returns(uint256) {
596     return _rate;
597   }
598 
599   /**
600    * @return the amount of wei raised.
601    */
602   function weiRaised() public view returns(uint256) {
603     return _weiRaised;
604   }
605 
606   /**
607    * @dev low level token purchase ***DO NOT OVERRIDE***
608    * This function has a non-reentrancy guard, so it shouldn't be called by
609    * another `nonReentrant` function.
610    * @param beneficiary Recipient of the token purchase
611    */
612   function buyTokens(address beneficiary) public nonReentrant payable {
613 
614     uint256 weiAmount = msg.value;
615     _preValidatePurchase(beneficiary, weiAmount);
616 
617     // calculate token amount to be created
618     uint256 tokens = _getTokenAmount(weiAmount);
619     uint256 tottokens;
620 
621     // update bonus
622     if (stage == CrowdsaleStage.presale) {
623       if (availableonpresale >= tokens) {
624         availableonpresale = availableonpresale - tokens;
625         tottokens = tokens + (tokens.mul(15).div(100));
626       } else {
627         uint256 xtoken = availableonpresale;
628         availableonpresale = availableonpresale - xtoken;
629         uint256 ytoken = tokens - availableonpresale;
630         availableonico = availableonico - ytoken;
631         tottokens = tokens + (xtoken.mul(15).div(100)) + (ytoken.mul(10).div(100));
632         setCrowdsaleStage(1);
633       }
634     } else {
635       require(availableonico >= tokens);
636       availableonico = availableonico - tokens;
637       tottokens = tokens + (tokens.mul(10).div(100));
638       if (availableonico <= 0) {
639         endbuy = true;
640       }
641     }
642 
643     // update state
644     _weiRaised = _weiRaised.add(weiAmount);
645 
646     _processPurchase(beneficiary, tottokens);
647     emit TokensPurchased(
648       msg.sender,
649       beneficiary,
650       weiAmount,
651       tokens
652     );
653 
654     _updatePurchasingState(beneficiary, weiAmount);
655 
656     _forwardFunds();
657     _postValidatePurchase(beneficiary, weiAmount);
658   }
659 
660   // -----------------------------------------
661   // Internal interface (extensible)
662   // -----------------------------------------
663 
664   /**
665    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
666    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
667    *   super._preValidatePurchase(beneficiary, weiAmount);
668    *   require(weiRaised().add(weiAmount) <= cap);
669    * @param beneficiary Address performing the token purchase
670    * @param weiAmount Value in wei involved in the purchase
671    */
672   function _preValidatePurchase(
673     address beneficiary,
674     uint256 weiAmount
675   )
676   internal
677   view {
678     require(beneficiary != address(0));
679     require(weiAmount != 0);
680     require(allowbuy);
681     require(!endbuy);
682     require(weiAmount >= minbuy);
683   }
684 
685   /**
686    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
687    * @param beneficiary Address performing the token purchase
688    * @param weiAmount Value in wei involved in the purchase
689    */
690   function _postValidatePurchase(
691     address beneficiary,
692     uint256 weiAmount
693   )
694   internal
695   view {
696     // optional override
697   }
698 
699   /**
700    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
701    * @param beneficiary Address performing the token purchase
702    * @param tokenAmount Number of tokens to be emitted
703    */
704   function _deliverTokens(
705     address beneficiary,
706     uint256 tokenAmount
707   )
708   internal {
709     _token.safeTransfer(beneficiary, tokenAmount);
710   }
711 
712   /**
713    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
714    * @param beneficiary Address receiving the tokens
715    * @param tokenAmount Number of tokens to be purchased
716    */
717   function _processPurchase(
718     address beneficiary,
719     uint256 tokenAmount
720   )
721   internal {
722     _deliverTokens(beneficiary, tokenAmount);
723   }
724 
725   /**
726    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
727    * @param beneficiary Address receiving the tokens
728    * @param weiAmount Value in wei involved in the purchase
729    */
730   function _updatePurchasingState(
731     address beneficiary,
732     uint256 weiAmount
733   )
734   internal {
735     // optional override
736   }
737 
738   /**
739    * @dev Override to extend the way in which ether is converted to tokens.
740    * @param weiAmount Value in wei to be converted into tokens
741    * @return Number of tokens that can be purchased with the specified _weiAmount
742    */
743   function _getTokenAmount(uint256 weiAmount)
744   internal view returns(uint256) {
745     return weiAmount.mul(_rate);
746   }
747 
748   /**
749    * @dev Determines how ETH is stored/forwarded on purchases.
750    */
751   function _forwardFunds() internal {
752     _wallet.transfer(msg.value);
753   }
754 
755   function sendBack() public onlyOwner {
756     _deliverTokens(owner(), balanceOf(this));
757   }
758 }
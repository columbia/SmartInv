1 pragma solidity 0.5.6;
2 
3 /** 
4  * xether.io - is a gambling ecosystem, which makes a difference by caring about its users.
5  * It’s our passion for perfection, as well as finding and creating neat solutions,
6  * that keeps us driven towards our goals.
7 */
8 
9 /**
10  * @title ERC20Detailed token
11  * @dev The decimals are only for visualization purposes.
12  * All the operations are done using the smallest and indivisible token unit,
13  * just as on Ethereum all the operations are done in wei.
14  */
15 contract ERC20Detailed {
16   string private _name;
17   string private _symbol;
18   uint8 private _decimals;
19 
20   constructor (string memory name, string memory symbol, uint8 decimals) public {
21       _name = name;
22       _symbol = symbol;
23       _decimals = decimals;
24   }
25 
26   /**
27    * @return the name of the token.
28    */
29   function name() public view returns (string memory) {
30       return _name;
31   }
32 
33   /**
34    * @return the symbol of the token.
35    */
36   function symbol() public view returns (string memory) {
37       return _symbol;
38   }
39 
40   /**
41    * @return the number of decimals of the token.
42    */
43   function decimals() public view returns (uint8) {
44       return _decimals;
45   }
46 }
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that revert on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, reverts on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     uint256 c = a * b;
66     require(c / a == b);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b > 0); // Solidity only automatically asserts when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b <= a);
87     uint256 c = a - b;
88 
89     return c;
90   }
91 
92   /**
93   * @dev Adds two numbers, reverts on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     require(c >= a);
98 
99     return c;
100   }
101 
102   /**
103   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
104   * reverts when dividing by zero.
105   */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0);
108     return a % b;
109   }
110 }
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
117  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract ERC20 {
120   using SafeMath for uint256;
121 
122   mapping (address => uint256) private _balances;
123   mapping (address => mapping (address => uint256)) private _allowed;
124   uint256 private _totalSupply;
125 
126   event Transfer(address indexed from, address indexed to, uint256 value);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 
129   /**
130    * @dev Total number of tokens in existence
131    */
132   function totalSupply() public view returns (uint256) {
133       return _totalSupply;
134   }
135 
136   /**
137    * @dev Gets the balance of the specified address.
138    * @param owner The address to query the balance of.
139    * @return A uint256 representing the amount owned by the passed address.
140    */
141   function balanceOf(address owner) public view returns (uint256) {
142       return _balances[owner];
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param owner address The address which owns the funds.
148    * @param spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address owner, address spender) public view returns (uint256) {
152       return _allowed[owner][spender];
153   }
154 
155   /**
156    * @dev Transfer token to a specified address
157    * @param to The address to transfer to.
158    * @param value The amount to be transferred.
159    */
160   function transfer(address to, uint256 value) public returns (bool) {
161       _transfer(msg.sender, to, value);
162       return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175       _approve(msg.sender, spender, value);
176       return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another.
181    * Note that while this function emits an Approval event, this is not required as per the specification,
182    * and other compliant implementations may not emit the event.
183    * @param from address The address which you want to send tokens from
184    * @param to address The address which you want to transfer to
185    * @param value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address from, address to, uint256 value) public returns (bool) {
188       _transfer(from, to, value);
189       _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
190       return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when _allowed[msg.sender][spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * Emits an Approval event.
200    * @param spender The address which will spend the funds.
201    * @param addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204       _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
205       return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * Emits an Approval event.
215    * @param spender The address which will spend the funds.
216    * @param subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219       _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
220       return true;
221   }
222 
223   /**
224    * @dev Transfer token for a specified addresses
225    * @param from The address to transfer from.
226    * @param to The address to transfer to.
227    * @param value The amount to be transferred.
228    */
229   function _transfer(address from, address to, uint256 value) internal {
230       require(to != address(0));
231 
232       _balances[from] = _balances[from].sub(value);
233       _balances[to] = _balances[to].add(value);
234       emit Transfer(from, to, value);
235   }
236 
237   /**
238    * @dev Internal function that mints an amount of the token and assigns it to
239    * an account. This encapsulates the modification of balances such that the
240    * proper events are emitted.
241    * @param account The account that will receive the created tokens.
242    * @param value The amount that will be created.
243    */
244   function _mint(address account, uint256 value) internal {
245       require(account != address(0));
246 
247       _totalSupply = _totalSupply.add(value);
248       _balances[account] = _balances[account].add(value);
249       emit Transfer(address(0), account, value);
250   }
251 
252   /**
253    * @dev Internal function that burns an amount of the token of a given
254    * account.
255    * @param account The account whose tokens will be burnt.
256    * @param value The amount that will be burnt.
257    */
258   function _burn(address account, uint256 value) internal {
259       require(account != address(0));
260 
261       _totalSupply = _totalSupply.sub(value);
262       _balances[account] = _balances[account].sub(value);
263       emit Transfer(account, address(0), value);
264   }
265 
266   /**
267    * @dev Approve an address to spend another addresses' tokens.
268    * @param owner The address that owns the tokens.
269    * @param spender The address that will spend the tokens.
270    * @param value The number of tokens that can be spent.
271    */
272   function _approve(address owner, address spender, uint256 value) internal {
273       require(spender != address(0));
274       require(owner != address(0));
275 
276       _allowed[owner][spender] = value;
277       emit Approval(owner, spender, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account, deducting from the sender's allowance for said account. Uses the
283    * internal burn function.
284    * Emits an Approval event (reflecting the reduced allowance).
285    * @param account The account whose tokens will be burnt.
286    * @param value The amount that will be burnt.
287    */
288   function _burnFrom(address account, uint256 value) internal {
289       _burn(account, value);
290       _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
291   }
292 }
293 
294 /**
295  * @title Burnable Token
296  * @dev Token that can be irreversibly burned (destroyed).
297  */
298 contract ERC20Burnable is ERC20 {
299 
300   /**
301    * @dev Burns a specific amount of tokens.
302    * @param value The amount of token to be burned.
303    */
304   function burn(uint256 value) public {
305     _burn(msg.sender, value);
306   }
307 
308   /**
309    * @dev Burns a specific amount of tokens from the target address and decrements allowance
310    * @param from address The address which you want to send tokens from
311    * @param value uint256 The amount of token to be burned
312    */
313   function burnFrom(address from, uint256 value) public {
314     _burnFrom(from, value);
315   }
316 }
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323 contract Ownable {
324   address private _owner;
325 
326   event OwnershipTransferred(
327     address indexed previousOwner,
328     address indexed newOwner
329   );
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() internal {
336     _owner = msg.sender;
337     emit OwnershipTransferred(address(0), _owner);
338   }
339 
340   /**
341    * @return the address of the owner.
342    */
343   function owner() public view returns(address) {
344     return _owner;
345   }
346 
347   /**
348    * @dev Throws if called by any account other than the owner.
349    */
350   modifier onlyOwner() {
351     require(isOwner());
352     _;
353   }
354 
355   /**
356    * @return true if `msg.sender` is the owner of the contract.
357    */
358   function isOwner() public view returns(bool) {
359     return msg.sender == _owner;
360   }
361 
362   /**
363    * @dev Allows the current owner to relinquish control of the contract.
364    * @notice Renouncing to ownership will leave the contract without an owner.
365    * It will not be possible to call the functions with the `onlyOwner`
366    * modifier anymore.
367    */
368   function renounceOwnership() public onlyOwner {
369     emit OwnershipTransferred(_owner, address(0));
370     _owner = address(0);
371   }
372 
373   /**
374    * @dev Allows the current owner to transfer control of the contract to a newOwner.
375    * @param newOwner The address to transfer ownership to.
376    */
377   function transferOwnership(address newOwner) public onlyOwner {
378     _transferOwnership(newOwner);
379   }
380 
381   /**
382    * @dev Transfers control of the contract to a newOwner.
383    * @param newOwner The address to transfer ownership to.
384    */
385   function _transferOwnership(address newOwner) internal {
386     require(newOwner != address(0));
387     emit OwnershipTransferred(_owner, newOwner);
388     _owner = newOwner;
389   }
390 }
391 
392 library Percent {
393   // Solidity automatically throws when dividing by 0
394   struct percent {
395     uint num;
396     uint den;
397   }
398 
399   // storage
400   function mul(percent storage p, uint a) internal view returns (uint) {
401     if (a == 0) {
402       return 0;
403     }
404     return a*p.num/p.den;
405   }
406 
407   function div(percent storage p, uint a) internal view returns (uint) {
408     return a/p.num*p.den;
409   }
410 
411   function sub(percent storage p, uint a) internal view returns (uint) {
412     uint b = mul(p, a);
413     if (b >= a) {
414       return 0;
415     }
416     return a - b;
417   }
418 
419   function add(percent storage p, uint a) internal view returns (uint) {
420     return a + mul(p, a);
421   }
422 
423   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
424     return Percent.percent(p.num, p.den);
425   }
426 
427   // memory
428   function mmul(percent memory p, uint a) internal pure returns (uint) {
429     if (a == 0) {
430       return 0;
431     }
432     return a*p.num/p.den;
433   }
434 
435   function mdiv(percent memory p, uint a) internal pure returns (uint) {
436     return a/p.num*p.den;
437   }
438 
439   function msub(percent memory p, uint a) internal pure returns (uint) {
440     uint b = mmul(p, a);
441     if (b >= a) {
442       return 0;
443     }
444     return a - b;
445   }
446 
447   function madd(percent memory p, uint a) internal pure returns (uint) {
448     return a + mmul(p, a);
449   }
450 }
451 
452 /**
453 * @title XetherToken is a basic ERC20 Token
454 */
455 contract XetherToken is ERC20Detailed("XetherEcosystemToken", "XEET", 18), ERC20Burnable, Ownable {
456   /**
457   * Modifiers
458   */
459   modifier onlyParticipant {
460     require(showMyTokens() > 0);
461     _;
462   }
463 
464   modifier hasDividends {
465     require(showMyDividends(true) > 0);
466     _;
467   }
468 
469   /**
470   * Events
471   */
472   event onTokenBuy(
473     address indexed customerAddress,
474     uint256 incomeEth,
475     uint256 tokensCreated,
476     address indexed ref,
477     uint timestamp,
478     uint256 startPrice,
479     uint256 newPrice
480   );
481 
482   event onTokenSell(
483     address indexed customerAddress,
484     uint256 tokensBurned,
485     uint256 earnedEth,
486     uint timestamp,
487     uint256 startPrice,
488     uint256 newPrice
489   );
490 
491   event onReinvestment(
492     address indexed customerAddress,
493     uint256 reinvestEth,
494     uint256 tokensCreated
495   );
496 
497   event onWithdraw(
498     address indexed customerAddress,
499     uint256 withdrawEth
500   );
501 
502   event Transfer(
503     address indexed from,
504     address indexed to,
505     uint256 tokens
506   );
507 
508   using Percent for Percent.percent;
509   using SafeMath for *;
510 
511   /**
512   * @dev percents
513   */
514   Percent.percent private inBonus_p  = Percent.percent(10, 100);           //   10/100  *100% = 10%
515   Percent.percent private outBonus_p  = Percent.percent(4, 100);           //   4/100  *100% = 4%
516   Percent.percent private refBonus_p = Percent.percent(30, 100);           //   30/100  *100% = 30%
517   Percent.percent private transferBonus_p = Percent.percent(1, 100);       //   1/100  *100% = 1%
518 
519   /**
520   * @dev initial variables
521   */
522   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
523   address public marketingAddress = DUMMY_ADDRESS;
524   uint256 constant internal tokenPriceInitial = 0.00005 ether;
525   uint256 constant internal tokenPriceIncremental = 0.0000000001 ether;
526   uint256 internal profitPerToken = 0;
527   uint256 internal decimalShift = 1e18;
528   uint256 internal currentTotalDividends = 0;
529 
530   mapping(address => int256) internal payoutsTo;
531   mapping(address => uint256) internal refBalance;
532   mapping(address => address) internal referrals;
533 
534   uint256 public actualTokenPrice = tokenPriceInitial;
535   uint256 public refMinBalanceReq = 50e18;
536 
537   /**
538   * @dev Event to notify if transfer successful or failed
539   * after account approval verified
540   */
541   event TransferSuccessful(address indexed from_, address indexed to_, uint256 amount_);
542   event TransferFailed(address indexed from_, address indexed to_, uint256 amount_);
543   event debug(uint256 div1, uint256 div2);
544 
545   /**
546   * @dev fallback function, buy tokens
547   */
548   function() payable external {
549     buyTokens(msg.sender, msg.value, referrals[msg.sender]);
550   }
551 
552   /**
553   * Public
554   */
555   function setMarketingAddress(address newMarketingAddress) external onlyOwner {
556     marketingAddress = newMarketingAddress;
557   }
558 
559   function ecosystemDividends() payable external {
560     uint dividends = msg.value;
561     uint256 toMarketingAmount = inBonus_p.mul(dividends);
562     uint256 toShareAmount = SafeMath.sub(dividends, toMarketingAmount);
563 
564     buyTokens(marketingAddress, toMarketingAmount, address(0));
565     profitPerToken = profitPerToken.add(toShareAmount.mul(decimalShift).div(totalSupply()));
566   }
567 
568   /**
569   * @dev main function to get/buy tokens
570   * @param _ref address of referal
571   */
572   function buy(address _ref) public payable returns (uint256) {
573     referrals[msg.sender] = _ref;
574     buyTokens(msg.sender, msg.value, _ref);
575   }
576 
577   /**
578   * @dev main function to sell tokens
579   * @param _inRawTokens address of referal
580   */
581   function sell(uint256 _inRawTokens) onlyParticipant public {
582     sellTokens(_inRawTokens);
583   }
584 
585   /**
586   * @dev function to withdraw balance
587   */
588   function withdraw() hasDividends public {
589     address payable _customerAddress = msg.sender;
590     uint256 _dividends = showMyDividends(false);
591 
592     payoutsTo[_customerAddress] += (int256) (_dividends);
593     _dividends = _dividends.add(refBalance[_customerAddress]);
594     refBalance[_customerAddress] = 0;
595 
596     _customerAddress.transfer(_dividends);
597 
598     emit onWithdraw(_customerAddress, _dividends);
599   }
600 
601   /**
602   * @dev function to withdraw balance
603   */
604   function withdraw(address customerAddress) internal {
605     uint256 _dividends = dividendsOf(customerAddress);
606 
607     payoutsTo[customerAddress] += (int256) (_dividends);
608     _dividends = _dividends.add(refBalance[customerAddress]);
609     refBalance[customerAddress] = 0;
610 
611     if (_dividends > 0) {
612       address payable _customerAddress = address(uint160(customerAddress));
613       _customerAddress.transfer(_dividends);
614 
615       emit onWithdraw(customerAddress, _dividends);
616     }
617   }
618 
619   function transfer(address to, uint256 value) public returns (bool) {
620     address _customerAddress = msg.sender;
621     require(value <= balanceOf(_customerAddress));
622     require(to != address(0));
623 
624     if (showMyDividends(true) > 0) {
625       withdraw();
626     }
627 
628     uint256 _tokenFee = transferBonus_p.mul(value);
629     uint256 _taxedTokens = value.sub(_tokenFee);
630     uint256 _dividends = tokensToEth(_tokenFee);
631 
632     _transfer(_customerAddress, to, _taxedTokens);
633     _burn(_customerAddress, _tokenFee);
634 
635     payoutsTo[_customerAddress] -= (int256) (profitPerToken.mul(value).div(decimalShift));
636     payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens).div(decimalShift));
637     profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));
638 
639     emit TransferSuccessful(_customerAddress, to, value);
640 
641     return true;
642   }
643 
644   function transferFrom(address from, address to, uint256 value)
645     public
646     returns (bool)
647   {
648     uint256 _tokenFee = transferBonus_p.mul(value);
649     uint256 _taxedTokens = value.sub(_tokenFee);
650     uint256 _dividends = tokensToEth(_tokenFee);
651 
652     withdraw(from);
653 
654     ERC20.transferFrom(from, to, _taxedTokens);
655     _burn(from, _tokenFee);
656 
657     payoutsTo[from] -= (int256) (profitPerToken.mul(value).div(decimalShift));
658     payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens).div(decimalShift));
659     profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));
660 
661     emit TransferSuccessful(from, to, value);
662 
663     return true;
664   }
665 
666   /**
667   * @dev function to sell all tokens and withdraw balance
668   */
669   function exit() public {
670     address _customerAddress = msg.sender;
671     uint256 _tokens = balanceOf(_customerAddress);
672 
673     if (_tokens > 0) sell(_tokens);
674 
675     withdraw();
676   }
677 
678   /**
679   * @dev function to reinvest of dividends
680   */
681   function reinvest() onlyParticipant public {
682     uint256 _dividends = showMyDividends(false);
683     address _customerAddress = msg.sender;
684 
685     payoutsTo[_customerAddress] += (int256) (_dividends);
686     _dividends = _dividends.add(refBalance[_customerAddress]);
687     refBalance[_customerAddress] = 0;
688 
689     uint256 _tokens = buyTokens(_customerAddress, _dividends, address(0));
690 
691     emit onReinvestment(_customerAddress, _dividends, _tokens);
692   }
693 
694   /**
695   * @dev show actual tokens price
696   */
697   function getActualTokenPrice() public view returns (uint256) {
698     return actualTokenPrice;
699   }
700 
701   /**
702   * @dev show owner dividents
703   * @param _includeReferralBonus true/false
704   */
705   function showMyDividends(bool _includeReferralBonus) public view returns (uint256) {
706     address _customerAddress = msg.sender;
707     return _includeReferralBonus ? dividendsOf(_customerAddress).add(refBalance[_customerAddress]) : dividendsOf(_customerAddress) ;
708   }
709 
710   /**
711   * @dev show owner tokens
712   */
713   function showMyTokens() public view returns (uint256) {
714       address _customerAddress = msg.sender;
715       return balanceOf(_customerAddress);
716   }
717 
718   /**
719   * @dev show address dividents
720   * @param _customerAddress address to show dividends for
721   */
722   function dividendsOf(address _customerAddress) public view returns (uint256) {
723     return (uint256) ((int256) (profitPerToken.mul(balanceOf(_customerAddress)).div(decimalShift)) - payoutsTo[_customerAddress]);
724   }
725 
726   /**
727  * @dev function to show ether/tokens ratio
728  * @param _eth eth amount
729  */
730  function showEthToTokens(uint256 _eth) public view returns (uint256 _tokensReceived, uint256 _newTokenPrice) {
731    uint256 b = actualTokenPrice.mul(2).sub(tokenPriceIncremental);
732    uint256 c = _eth.mul(2);
733    uint256 d = SafeMath.add(b**2, tokenPriceIncremental.mul(4).mul(c));
734 
735    // d = b**2 + 4 * a * c;
736    // (-b + Math.sqrt(d)) / (2*a)
737    _tokensReceived = SafeMath.div(sqrt(d).sub(b).mul(decimalShift), tokenPriceIncremental.mul(2));
738    _newTokenPrice = actualTokenPrice.add(tokenPriceIncremental.mul(_tokensReceived).div(decimalShift));
739  }
740 
741  /**
742  * @dev function to show tokens/ether ratio
743  * @param _tokens tokens amount
744  */
745  function showTokensToEth(uint256 _tokens) public view returns (uint256 _eth, uint256 _newTokenPrice) {
746    // (2 * a1 - delta * (n - 1)) / 2 * n
747    _eth = SafeMath.sub(actualTokenPrice.mul(2), tokenPriceIncremental.mul(_tokens.sub(1e18)).div(decimalShift)).div(2).mul(_tokens).div(decimalShift);
748    _newTokenPrice = actualTokenPrice.sub(tokenPriceIncremental.mul(_tokens).div(decimalShift));
749  }
750 
751  function sqrt(uint x) pure private returns (uint y) {
752     uint z = (x + 1) / 2;
753     y = x;
754     while (z < y) {
755         y = z;
756         z = (x / z + z) / 2;
757     }
758  }
759 
760   /**
761   * Internals
762   */
763 
764   /**
765   * @dev function to buy tokens, calculate bonus, dividends, fees
766   * @param _inRawEth eth amount
767   * @param _ref address of referal
768   */
769   function buyTokens(address customerAddress, uint256 _inRawEth, address _ref) internal returns (uint256) {
770       uint256 _dividends = inBonus_p.mul(_inRawEth);
771       uint256 _inEth = _inRawEth.sub(_dividends);
772       uint256 _tokens = 0;
773       uint256 startPrice = actualTokenPrice;
774 
775       if (_ref != address(0) && _ref != customerAddress && balanceOf(_ref) >= refMinBalanceReq) {
776         uint256 _refBonus = refBonus_p.mul(_dividends);
777         _dividends = _dividends.sub(_refBonus);
778         refBalance[_ref] = refBalance[_ref].add(_refBonus);
779       }
780 
781       uint256 _totalTokensSupply = totalSupply();
782 
783       if (_totalTokensSupply > 0) {
784         _tokens = ethToTokens(_inEth);
785         require(_tokens > 0);
786         profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(_totalTokensSupply));
787         _totalTokensSupply = _totalTokensSupply.add(_tokens);
788       } else {
789         // initial protect
790         if (!isOwner()) {
791             address(uint160(owner())).transfer(msg.value);
792             return 0;
793         }
794 
795         _totalTokensSupply = ethToTokens(_inRawEth);
796         _tokens = _totalTokensSupply;
797       }
798 
799       _mint(customerAddress, _tokens);
800       payoutsTo[customerAddress] += (int256) (profitPerToken.mul(_tokens).div(decimalShift));
801 
802       emit onTokenBuy(customerAddress, _inEth, _tokens, _ref, now, startPrice, actualTokenPrice);
803 
804       return _tokens;
805   }
806 
807   /**
808   * @dev function to sell tokens, calculate dividends, fees
809   * @param _inRawTokens eth amount
810   */
811   function sellTokens(uint256 _inRawTokens) internal returns (uint256) {
812     address _customerAddress = msg.sender;
813     require(_inRawTokens <= balanceOf(_customerAddress));
814     uint256 _tokens = _inRawTokens;
815     uint256 _eth = 0;
816     uint256 startPrice = actualTokenPrice;
817 
818     _eth = tokensToEth(_tokens);
819     _burn(_customerAddress, _tokens);
820 
821     uint256 _dividends = outBonus_p.mul(_eth);
822     uint256 _ethTaxed = _eth.sub(_dividends);
823     int256 unlockPayout = (int256) (_ethTaxed.add((profitPerToken.mul(_tokens)).div(decimalShift)));
824 
825     payoutsTo[_customerAddress] -= unlockPayout;
826     profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));
827 
828     emit onTokenSell(_customerAddress, _tokens, _eth, now, startPrice, actualTokenPrice);
829   }
830 
831   /**
832   * @dev function to calculate ether/tokens ratio
833   * @param _eth eth amount
834   */
835   function ethToTokens(uint256 _eth) internal returns (uint256 _tokensReceived) {
836     uint256 _newTokenPrice;
837     (_tokensReceived, _newTokenPrice) = showEthToTokens(_eth);
838     actualTokenPrice = _newTokenPrice;
839   }
840 
841   /**
842   * @dev function to calculate tokens/ether ratio
843   * @param _tokens tokens amount
844   */
845   function tokensToEth(uint256 _tokens) internal returns (uint256 _eth) {
846     uint256 _newTokenPrice;
847     (_eth, _newTokenPrice) = showTokensToEth(_tokens);
848     actualTokenPrice = _newTokenPrice;
849   }
850 }
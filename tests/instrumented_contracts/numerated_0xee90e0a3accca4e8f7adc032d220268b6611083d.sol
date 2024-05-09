1 pragma solidity 0.5.5;
2 
3 // * xether.io - is a gambling ecosystem, which makes a difference by caring about its users.
4 // It’s our passion for perfection, as well as finding and creating neat solutions,
5 // that keeps us driven towards our goals.
6 //
7 // * Uses hybrid commit-reveal + block hash random number generation that is immune
8 //   to tampering by players, house and miners. Apart from being fully transparent,
9 //   this also allows arbitrarily high bets.
10 
11 /**
12  * @title ERC20Detailed token
13  * @dev The decimals are only for visualization purposes.
14  * All the operations are done using the smallest and indivisible token unit,
15  * just as on Ethereum all the operations are done in wei.
16  */
17 contract ERC20Detailed{
18   string private _name;
19   string private _symbol;
20   uint8 private _decimals;
21 
22   constructor (string memory name, string memory symbol, uint8 decimals) public {
23       _name = name;
24       _symbol = symbol;
25       _decimals = decimals;
26   }
27 
28   /**
29    * @return the name of the token.
30    */
31   function name() public view returns (string memory) {
32       return _name;
33   }
34 
35   /**
36    * @return the symbol of the token.
37    */
38   function symbol() public view returns (string memory) {
39       return _symbol;
40   }
41 
42   /**
43    * @return the number of decimals of the token.
44    */
45   function decimals() public view returns (uint8) {
46       return _decimals;
47   }
48 }
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that revert on error
53  */
54 library SafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, reverts on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61     // benefit is lost if 'b' is also tested.
62     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63     if (a == 0) {
64       return 0;
65     }
66 
67     uint256 c = a * b;
68     require(c / a == b);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b > 0); // Solidity only automatically asserts when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b <= a);
89     uint256 c = a - b;
90 
91     return c;
92   }
93 
94   /**
95   * @dev Adds two numbers, reverts on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     require(c >= a);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
106   * reverts when dividing by zero.
107   */
108   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b != 0);
110     return a % b;
111   }
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
119  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract ERC20 {
122   using SafeMath for uint256;
123 
124   mapping (address => uint256) private _balances;
125   mapping (address => mapping (address => uint256)) private _allowed;
126   uint256 private _totalSupply;
127 
128   event Transfer(address indexed from, address indexed to, uint256 value);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131   /**
132    * @dev Total number of tokens in existence
133    */
134   function totalSupply() public view returns (uint256) {
135       return _totalSupply;
136   }
137 
138   /**
139    * @dev Gets the balance of the specified address.
140    * @param owner The address to query the balance of.
141    * @return A uint256 representing the amount owned by the passed address.
142    */
143   function balanceOf(address owner) public view returns (uint256) {
144       return _balances[owner];
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param owner address The address which owns the funds.
150    * @param spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address owner, address spender) public view returns (uint256) {
154       return _allowed[owner][spender];
155   }
156 
157   /**
158    * @dev Transfer token to a specified address
159    * @param to The address to transfer to.
160    * @param value The amount to be transferred.
161    */
162   function transfer(address to, uint256 value) public returns (bool) {
163       _transfer(msg.sender, to, value);
164       return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param spender The address which will spend the funds.
174    * @param value The amount of tokens to be spent.
175    */
176   function approve(address spender, uint256 value) public returns (bool) {
177       _approve(msg.sender, spender, value);
178       return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another.
183    * Note that while this function emits an Approval event, this is not required as per the specification,
184    * and other compliant implementations may not emit the event.
185    * @param from address The address which you want to send tokens from
186    * @param to address The address which you want to transfer to
187    * @param value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address from, address to, uint256 value) public returns (bool) {
190       _transfer(from, to, value);
191       _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
192       return true;
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when _allowed[msg.sender][spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * Emits an Approval event.
202    * @param spender The address which will spend the funds.
203    * @param addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
206       _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
207       return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * Emits an Approval event.
217    * @param spender The address which will spend the funds.
218    * @param subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
221       _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
222       return true;
223   }
224 
225   /**
226    * @dev Transfer token for a specified addresses
227    * @param from The address to transfer from.
228    * @param to The address to transfer to.
229    * @param value The amount to be transferred.
230    */
231   function _transfer(address from, address to, uint256 value) internal {
232       require(to != address(0));
233 
234       _balances[from] = _balances[from].sub(value);
235       _balances[to] = _balances[to].add(value);
236       emit Transfer(from, to, value);
237   }
238 
239   /**
240    * @dev Internal function that mints an amount of the token and assigns it to
241    * an account. This encapsulates the modification of balances such that the
242    * proper events are emitted.
243    * @param account The account that will receive the created tokens.
244    * @param value The amount that will be created.
245    */
246   function _mint(address account, uint256 value) internal {
247       require(account != address(0));
248 
249       _totalSupply = _totalSupply.add(value);
250       _balances[account] = _balances[account].add(value);
251       emit Transfer(address(0), account, value);
252   }
253 
254   /**
255    * @dev Internal function that burns an amount of the token of a given
256    * account.
257    * @param account The account whose tokens will be burnt.
258    * @param value The amount that will be burnt.
259    */
260   function _burn(address account, uint256 value) internal {
261       require(account != address(0));
262 
263       _totalSupply = _totalSupply.sub(value);
264       _balances[account] = _balances[account].sub(value);
265       emit Transfer(account, address(0), value);
266   }
267 
268   /**
269    * @dev Approve an address to spend another addresses' tokens.
270    * @param owner The address that owns the tokens.
271    * @param spender The address that will spend the tokens.
272    * @param value The number of tokens that can be spent.
273    */
274   function _approve(address owner, address spender, uint256 value) internal {
275       require(spender != address(0));
276       require(owner != address(0));
277 
278       _allowed[owner][spender] = value;
279       emit Approval(owner, spender, value);
280   }
281 
282   /**
283    * @dev Internal function that burns an amount of the token of a given
284    * account, deducting from the sender's allowance for said account. Uses the
285    * internal burn function.
286    * Emits an Approval event (reflecting the reduced allowance).
287    * @param account The account whose tokens will be burnt.
288    * @param value The amount that will be burnt.
289    */
290   function _burnFrom(address account, uint256 value) internal {
291       _burn(account, value);
292       _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
293   }
294 }
295 
296 /**
297  * @title Burnable Token
298  * @dev Token that can be irreversibly burned (destroyed).
299  */
300 contract ERC20Burnable is ERC20 {
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param value The amount of token to be burned.
305    */
306   function burn(uint256 value) public {
307     _burn(msg.sender, value);
308   }
309 
310   /**
311    * @dev Burns a specific amount of tokens from the target address and decrements allowance
312    * @param from address The address which you want to send tokens from
313    * @param value uint256 The amount of token to be burned
314    */
315   function burnFrom(address from, uint256 value) public {
316     _burnFrom(from, value);
317   }
318 }
319 
320 /**
321  * @title Ownable
322  * @dev The Ownable contract has an owner address, and provides basic authorization control
323  * functions, this simplifies the implementation of "user permissions".
324  */
325 contract Ownable {
326   address private _owner;
327 
328   event OwnershipTransferred(
329     address indexed previousOwner,
330     address indexed newOwner
331   );
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() internal {
338     _owner = msg.sender;
339     emit OwnershipTransferred(address(0), _owner);
340   }
341 
342   /**
343    * @return the address of the owner.
344    */
345   function owner() public view returns(address) {
346     return _owner;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(isOwner());
354     _;
355   }
356 
357   /**
358    * @return true if `msg.sender` is the owner of the contract.
359    */
360   function isOwner() public view returns(bool) {
361     return msg.sender == _owner;
362   }
363 
364   /**
365    * @dev Allows the current owner to relinquish control of the contract.
366    * @notice Renouncing to ownership will leave the contract without an owner.
367    * It will not be possible to call the functions with the `onlyOwner`
368    * modifier anymore.
369    */
370   function renounceOwnership() public onlyOwner {
371     emit OwnershipTransferred(_owner, address(0));
372     _owner = address(0);
373   }
374 
375   /**
376    * @dev Allows the current owner to transfer control of the contract to a newOwner.
377    * @param newOwner The address to transfer ownership to.
378    */
379   function transferOwnership(address newOwner) public onlyOwner {
380     _transferOwnership(newOwner);
381   }
382 
383   /**
384    * @dev Transfers control of the contract to a newOwner.
385    * @param newOwner The address to transfer ownership to.
386    */
387   function _transferOwnership(address newOwner) internal {
388     require(newOwner != address(0));
389     emit OwnershipTransferred(_owner, newOwner);
390     _owner = newOwner;
391   }
392 }
393 
394 library Percent {
395   // Solidity automatically throws when dividing by 0
396   struct percent {
397     uint num;
398     uint den;
399   }
400 
401   // storage
402   function mul(percent storage p, uint a) internal view returns (uint) {
403     if (a == 0) {
404       return 0;
405     }
406     return a*p.num/p.den;
407   }
408 
409   function div(percent storage p, uint a) internal view returns (uint) {
410     return a/p.num*p.den;
411   }
412 
413   function sub(percent storage p, uint a) internal view returns (uint) {
414     uint b = mul(p, a);
415     if (b >= a) {
416       return 0;
417     }
418     return a - b;
419   }
420 
421   function add(percent storage p, uint a) internal view returns (uint) {
422     return a + mul(p, a);
423   }
424 
425   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
426     return Percent.percent(p.num, p.den);
427   }
428 
429   // memory
430   function mmul(percent memory p, uint a) internal pure returns (uint) {
431     if (a == 0) {
432       return 0;
433     }
434     return a*p.num/p.den;
435   }
436 
437   function mdiv(percent memory p, uint a) internal pure returns (uint) {
438     return a/p.num*p.den;
439   }
440 
441   function msub(percent memory p, uint a) internal pure returns (uint) {
442     uint b = mmul(p, a);
443     if (b >= a) {
444       return 0;
445     }
446     return a - b;
447   }
448 
449   function madd(percent memory p, uint a) internal pure returns (uint) {
450     return a + mmul(p, a);
451   }
452 }
453 
454 /**
455 * @title XetherToken is a basic ERC20 Token
456 */
457 contract XetherToken is ERC20Detailed("XetherEcosystemToken", "XEET", 18), ERC20Burnable, Ownable {
458   /**
459   * Modifiers
460   */
461   modifier onlyParticipant {
462     require(showMyTokens() > 0);
463     _;
464   }
465 
466   modifier hasDividends {
467     require(showMyDividends(true) > 0);
468     _;
469   }
470 
471   /**
472   * Events
473   */
474   event onTokenBuy(
475     address indexed customerAddress,
476     uint256 incomeEth,
477     uint256 tokensCreated,
478     address indexed ref,
479     uint timestamp,
480     uint256 startPrice,
481     uint256 newPrice
482   );
483 
484   event onTokenSell(
485     address indexed customerAddress,
486     uint256 tokensBurned,
487     uint256 earnedEth,
488     uint timestamp,
489     uint256 startPrice,
490     uint256 newPrice
491   );
492 
493   event onReinvestment(
494     address indexed customerAddress,
495     uint256 reinvestEth,
496     uint256 tokensCreated
497   );
498 
499   event onWithdraw(
500     address indexed customerAddress,
501     uint256 withdrawEth
502   );
503 
504   event Transfer(
505     address indexed from,
506     address indexed to,
507     uint256 tokens
508   );
509 
510   using Percent for Percent.percent;
511   using SafeMath for *;
512 
513   /**
514   * @dev percents
515   */
516   Percent.percent private inBonus_p  = Percent.percent(10, 100);           //   10/100  *100% = 10%
517   Percent.percent private outBonus_p  = Percent.percent(4, 100);           //   4/100  *100% = 4%
518   Percent.percent private refBonus_p = Percent.percent(30, 100);           //   30/100  *100% = 30%
519   Percent.percent private transferBonus_p = Percent.percent(1, 100);       //   1/100  *100% = 1%
520 
521   /**
522   * @dev initial variables
523   */
524   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
525   address public marketingAddress = DUMMY_ADDRESS;
526   uint256 constant internal tokenPriceInitial = 0.00005 ether;
527   uint256 constant internal tokenPriceIncremental = 0.0000000001 ether;
528   uint256 internal profitPerToken = 0;
529   uint256 internal decimalShift = 1e18;
530   uint256 internal currentTotalDividends = 0;
531 
532   mapping(address => int256) internal payoutsTo;
533   mapping(address => uint256) internal refBalance;
534   mapping(address => address) internal referrals;
535 
536   uint256 public actualTokenPrice = tokenPriceInitial;
537   uint256 public refMinBalanceReq = 50e18;
538 
539   /**
540   * @dev Event to notify if transfer successful or failed
541   * after account approval verified
542   */
543   event TransferSuccessful(address indexed from_, address indexed to_, uint256 amount_);
544   event TransferFailed(address indexed from_, address indexed to_, uint256 amount_);
545   
546   /**
547   * @dev fallback function, buy tokens
548   */
549   function() payable external {
550     buyTokens(msg.sender, msg.value, referrals[msg.sender]);
551   }
552 
553   /**
554   * Public
555   */
556   function setMarketingAddress(address newMarketingAddress) external onlyOwner {
557     marketingAddress = newMarketingAddress;
558   }
559 
560   function ecosystemDividends() payable external {
561     uint dividends = msg.value;
562     uint256 toMarketingAmount = inBonus_p.mul(dividends);
563     uint256 toShareAmount = SafeMath.sub(dividends, toMarketingAmount);
564 
565     buyTokens(marketingAddress, toMarketingAmount, address(0));
566     profitPerToken = profitPerToken.add(toShareAmount.mul(decimalShift).div(totalSupply()));
567   }
568 
569   /**
570   * @dev main function to get/buy tokens
571   * @param _ref address of referal
572   */
573   function buy(address _ref) public payable returns (uint256) {
574     referrals[msg.sender] = _ref;
575     buyTokens(msg.sender, msg.value, _ref);
576   }
577 
578   /**
579   * @dev main function to get/buy tokens
580   * @param _inRawTokens address of referal
581   */
582   function sell(uint256 _inRawTokens) onlyParticipant public {
583     sellTokens(_inRawTokens);
584   }
585 
586   /**
587   * @dev function to withdraw balance
588   */
589   function withdraw() hasDividends public {
590     address payable _customerAddress = msg.sender;
591     uint256 _dividends = showMyDividends(false);
592 
593     payoutsTo[_customerAddress] += (int256) (_dividends);
594     _dividends = _dividends.add(refBalance[_customerAddress]);
595     refBalance[_customerAddress] = 0;
596 
597     _customerAddress.transfer(_dividends);
598 
599     emit onWithdraw(_customerAddress, _dividends);
600   }
601 
602   function transfer(address to, uint256 value) public returns (bool) {
603     address _customerAddress = msg.sender;
604     require(value <= balanceOf(_customerAddress));
605     require(to != address(0));
606 
607     if (showMyDividends(true) > 0) {
608       withdraw();
609     }
610 
611     uint256 _tokenFee = transferBonus_p.mul(value);
612     uint256 _taxedTokens = value.sub(_tokenFee);
613     uint256 _dividends = 0;
614     _dividends = tokensToEth(_tokenFee);
615 
616     _transfer(msg.sender, to, _taxedTokens);
617 
618     payoutsTo[_customerAddress] -= (int256) (profitPerToken.mul(value));
619     payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens));
620     profitPerToken = profitPerToken.add(_dividends.div(totalSupply()));
621 
622     emit TransferSuccessful(_customerAddress, to, value);
623 
624     return true;
625   }
626 
627   function transferFrom(address from, address to, uint256 value)
628     public
629     returns (bool)
630   {
631     uint256 _tokenFee = transferBonus_p.mul(value);
632     uint256 _taxedTokens = value.sub(_tokenFee);
633     uint256 _dividends = 0;
634 
635     ERC20.transferFrom(from, to, _taxedTokens);
636 
637     _dividends = tokensToEth(_tokenFee);
638     if (showMyDividends(true) > 0) {
639       withdraw();
640     }
641 
642     payoutsTo[from] -= (int256) (profitPerToken.mul(value));
643     payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens));
644     profitPerToken = profitPerToken.add(_dividends.div(totalSupply()));
645 
646     emit TransferSuccessful(from, to, value);
647 
648     return true;
649   }
650 
651   /**
652   * @dev function to sell all tokens and withdraw balance
653   */
654   function exit() public {
655     address _customerAddress = msg.sender;
656     uint256 _tokens = balanceOf(_customerAddress);
657 
658     if (_tokens > 0) sell(_tokens);
659 
660     withdraw();
661   }
662 
663   /**
664   * @dev function to reinvest of dividends
665   */
666   function reinvest() onlyParticipant public {
667     uint256 _dividends = showMyDividends(false);
668     address _customerAddress = msg.sender;
669 
670     payoutsTo[_customerAddress] += (int256) (_dividends);
671     _dividends = _dividends.add(refBalance[_customerAddress]);
672     refBalance[_customerAddress] = 0;
673 
674     uint256 _tokens = buyTokens(_customerAddress, _dividends, address(0));
675 
676     emit onReinvestment(_customerAddress, _dividends, _tokens);
677   }
678 
679   /**
680   * @dev show actual tokens price
681   */
682   function getActualTokenPrice() public view returns (uint256) {
683     return actualTokenPrice;
684   }
685 
686   /**
687   * @dev show owner dividents
688   * @param _includeReferralBonus true/false
689   */
690   function showMyDividends(bool _includeReferralBonus) public view returns (uint256) {
691     address _customerAddress = msg.sender;
692     return _includeReferralBonus ? dividendsOf(_customerAddress).add(refBalance[_customerAddress]) : dividendsOf(_customerAddress) ;
693   }
694 
695   /**
696   * @dev show owner tokens
697   */
698   function showMyTokens() public view returns (uint256) {
699       address _customerAddress = msg.sender;
700       return balanceOf(_customerAddress);
701   }
702 
703   /**
704   * @dev show address dividents
705   * @param _customerAddress address to show dividends for
706   */
707   function dividendsOf(address _customerAddress) public view returns (uint256) {
708     return (uint256) ((int256) (profitPerToken.mul(balanceOf(_customerAddress)).div(decimalShift)) - payoutsTo[_customerAddress]);
709   }
710 
711   /**
712  * @dev function to show ether/tokens ratio
713  * @param _eth eth amount
714  */
715  function showEthToTokens(uint256 _eth) public view returns (uint256 _tokensReceived, uint256 _newTokenPrice) {
716    uint256 b = actualTokenPrice.mul(2).sub(tokenPriceIncremental);
717    uint256 c = _eth.mul(2);
718    uint256 d = SafeMath.add(b**2, tokenPriceIncremental.mul(4).mul(c));
719 
720    // d = b**2 + 4 * a * c;
721    // (-b + Math.sqrt(d)) / (2*a)
722    _tokensReceived = SafeMath.div(sqrt(d).sub(b).mul(decimalShift), tokenPriceIncremental.mul(2));
723    _newTokenPrice = actualTokenPrice.add(SafeMath.mul(_tokensReceived.div(1e18), tokenPriceIncremental));
724  }
725 
726  /**
727  * @dev function to show tokens/ether ratio
728  * @param _tokens tokens amount
729  */
730  function showTokensToEth(uint256 _tokens) public view returns (uint256 _eth, uint256 _newTokenPrice) {
731    // (2 * a1 - delta * (n - 1)) / 2 * n
732    _eth = SafeMath.sub(actualTokenPrice.mul(2), tokenPriceIncremental.mul(_tokens.sub(1e18)).div(decimalShift)).div(2).mul(_tokens).div(decimalShift);
733    _newTokenPrice = actualTokenPrice.sub(SafeMath.mul(_tokens.div(1e18), tokenPriceIncremental));
734  }
735 
736  function sqrt(uint x) pure private returns (uint y) {
737     uint z = (x + 1) / 2;
738     y = x;
739     while (z < y) {
740         y = z;
741         z = (x / z + z) / 2;
742     }
743  }
744 
745   /**
746   * Internals
747   */
748 
749   /**
750   * @dev function to buy tokens, calculate bonus, dividends, fees
751   * @param _inRawEth eth amount
752   * @param _ref address of referal
753   */
754   function buyTokens(address customerAddress, uint256 _inRawEth, address _ref) internal returns (uint256) {
755       address _customerAddress = customerAddress;
756       uint256 _dividends = inBonus_p.mul(_inRawEth);
757       uint256 _inEth = _inRawEth.sub(_dividends);
758       uint256 _tokens = 0;
759       uint256 startPrice = actualTokenPrice;
760 
761       _tokens = ethToTokens(_inEth);
762 
763       require(_tokens > 0);
764 
765       if (_ref != address(0) && _ref != _customerAddress && balanceOf(_ref) >= refMinBalanceReq) {
766         uint256 _refBonus = refBonus_p.mul(_dividends);
767         _dividends = _dividends.sub(_refBonus);
768         refBalance[_ref] = refBalance[_ref].add(_refBonus);
769       }
770 
771       uint256 _totalTokensSupply = totalSupply();
772 
773       if (_totalTokensSupply > 0) {
774         profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(_totalTokensSupply));
775         _totalTokensSupply = _totalTokensSupply.add(_tokens);
776       } else {
777         _totalTokensSupply = _tokens;
778       }
779 
780       _mint(_customerAddress, _tokens);
781       payoutsTo[_customerAddress] += (int256) (profitPerToken.mul(_tokens).div(decimalShift));
782 
783       emit onTokenBuy(_customerAddress, _inEth, _tokens, _ref, now, startPrice, actualTokenPrice);
784 
785       return _tokens;
786   }
787 
788   /**
789   * @dev function to buy tokens, calculate bonus, dividends, fees
790   * @param _inRawTokens eth amount
791   */
792   function sellTokens(uint256 _inRawTokens) internal returns (uint256) {
793     address _customerAddress = msg.sender;
794     require(_inRawTokens <= balanceOf(_customerAddress));
795     uint256 _tokens = _inRawTokens;
796     uint256 _eth = 0;
797     uint256 startPrice = actualTokenPrice;
798 
799     _eth = tokensToEth(_tokens);
800     _burn(_customerAddress, _tokens);
801 
802     uint256 _dividends = outBonus_p.mul(_eth);
803     uint256 _ethTaxed = _eth.sub(_dividends);
804     int256 unlockPayout = (int256) (_ethTaxed.add((profitPerToken.mul(_tokens)).div(decimalShift)));
805 
806     payoutsTo[_customerAddress] -= unlockPayout;
807     profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));
808 
809     emit onTokenSell(_customerAddress, _tokens, _eth, now, startPrice, actualTokenPrice);
810   }
811 
812   /**
813   * @dev function to calculate ether/tokens ratio
814   * @param _eth eth amount
815   */
816   function ethToTokens(uint256 _eth) internal returns (uint256 _tokensReceived) {
817     uint256 _newTokenPrice;
818     (_tokensReceived, _newTokenPrice) = showEthToTokens(_eth);
819     actualTokenPrice = _newTokenPrice;
820   }
821 
822   /**
823   * @dev function to calculate tokens/ether ratio
824   * @param _tokens tokens amount
825   */
826   function tokensToEth(uint256 _tokens) internal returns (uint256 _eth) {
827     uint256 _newTokenPrice;
828     (_eth, _newTokenPrice) = showTokensToEth(_tokens);
829     actualTokenPrice = _newTokenPrice;
830   }
831 }
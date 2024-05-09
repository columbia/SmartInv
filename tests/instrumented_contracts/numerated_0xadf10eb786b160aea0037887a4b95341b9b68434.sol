1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address private _owner;
78 
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() internal {
89     _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipTransferred(_owner, address(0));
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 interface IERC20 {
152   function totalSupply() external view returns (uint256);
153 
154   function balanceOf(address who) external view returns (uint256);
155 
156   function allowance(address owner, address spender)
157     external view returns (uint256);
158 
159   function transfer(address to, uint256 value) external returns (bool);
160 
161   function approve(address spender, uint256 value)
162     external returns (bool);
163 
164   function transferFrom(address from, address to, uint256 value)
165     external returns (bool);
166 
167   event Transfer(
168     address indexed from,
169     address indexed to,
170     uint256 value
171   );
172 
173   event Approval(
174     address indexed owner,
175     address indexed spender,
176     uint256 value
177   );
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract ERC20 is IERC20 {
190   using SafeMath for uint256;
191 
192   mapping (address => uint256) private _balances;
193 
194   mapping (address => mapping (address => uint256)) private _allowed;
195 
196   uint256 private _totalSupply;
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address owner,
222     address spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return _allowed[owner][spender];
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function transfer(address to, uint256 value) public returns (bool) {
237     _transfer(msg.sender, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param spender The address which will spend the funds.
248    * @param value The amount of tokens to be spent.
249    */
250   function approve(address spender, uint256 value) public returns (bool) {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = value;
254     emit Approval(msg.sender, spender, value);
255     return true;
256   }
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param from address The address which you want to send tokens from
261    * @param to address The address which you want to transfer to
262    * @param value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(
289     address spender,
290     uint256 addedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].add(addedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param spender The address which will spend the funds.
310    * @param subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseAllowance(
313     address spender,
314     uint256 subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     require(spender != address(0));
320 
321     _allowed[msg.sender][spender] = (
322       _allowed[msg.sender][spender].sub(subtractedValue));
323     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324     return true;
325   }
326 
327   /**
328   * @dev Transfer token for a specified addresses
329   * @param from The address to transfer from.
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function _transfer(address from, address to, uint256 value) internal {
334     require(value <= _balances[from]);
335     require(to != address(0));
336 
337     _balances[from] = _balances[from].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(from, to, value);
340   }
341 
342   /**
343    * @dev Internal function that mints an amount of the token and assigns it to
344    * an account. This encapsulates the modification of balances such that the
345    * proper events are emitted.
346    * @param account The account that will receive the created tokens.
347    * @param value The amount that will be created.
348    */
349   function _mint(address account, uint256 value) internal {
350     require(account != 0);
351     _totalSupply = _totalSupply.add(value);
352     _balances[account] = _balances[account].add(value);
353     emit Transfer(address(0), account, value);
354   }
355 
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burn(address account, uint256 value) internal {
363     require(account != 0);
364     require(value <= _balances[account]);
365 
366     _totalSupply = _totalSupply.sub(value);
367     _balances[account] = _balances[account].sub(value);
368     emit Transfer(account, address(0), value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account, deducting from the sender's allowance for said account. Uses the
374    * internal burn function.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burnFrom(address account, uint256 value) internal {
379     require(value <= _allowed[account][msg.sender]);
380 
381     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
382     // this function needs to emit an event with the updated approval.
383     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
384       value);
385     _burn(account, value);
386   }
387 }
388 
389 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
390 
391 /**
392  * @title Burnable Token
393  * @dev Token that can be irreversibly burned (destroyed).
394  */
395 contract ERC20Burnable is ERC20 {
396 
397   /**
398    * @dev Burns a specific amount of tokens.
399    * @param value The amount of token to be burned.
400    */
401   function burn(uint256 value) public {
402     _burn(msg.sender, value);
403   }
404 
405   /**
406    * @dev Burns a specific amount of tokens from the target address and decrements allowance
407    * @param from address The address which you want to send tokens from
408    * @param value uint256 The amount of token to be burned
409    */
410   function burnFrom(address from, uint256 value) public {
411     _burnFrom(from, value);
412   }
413 }
414 
415 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
416 
417 /**
418  * @title Helps contracts guard against reentrancy attacks.
419  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
420  * @dev If you mark a function `nonReentrant`, you should also
421  * mark it `external`.
422  */
423 contract ReentrancyGuard {
424 
425   /// @dev counter to allow mutex lock with only one SSTORE operation
426   uint256 private _guardCounter;
427 
428   constructor() internal {
429     // The counter starts at one to prevent changing it from zero to a non-zero
430     // value, which is a more expensive operation.
431     _guardCounter = 1;
432   }
433 
434   /**
435    * @dev Prevents a contract from calling itself, directly or indirectly.
436    * Calling a `nonReentrant` function from another `nonReentrant`
437    * function is not supported. It is possible to prevent this from happening
438    * by making the `nonReentrant` function external, and make it call a
439    * `private` function that does the actual work.
440    */
441   modifier nonReentrant() {
442     _guardCounter += 1;
443     uint256 localCounter = _guardCounter;
444     _;
445     require(localCounter == _guardCounter);
446   }
447 
448 }
449 
450 // File: contracts/LTOTokenSale.sol
451 
452 /**
453  * @title ERC20 LTO Network token
454  * @dev see https://github.com/legalthings/tokensale
455  */
456 contract LTOTokenSale is Ownable, ReentrancyGuard {
457 
458   using SafeMath for uint256;
459 
460   uint256 constant minimumAmount = 0.1 ether;     // Minimum amount of ether to transfer
461   uint256 constant maximumCapAmount = 40 ether;  // Maximium amount of ether you can send with being caplisted
462   uint256 constant ethDecimals = 1 ether;         // Amount used to divide ether with to calculate proportion
463   uint256 constant ltoEthDiffDecimals = 10**10;   // Amount used to get the number of desired decimals, so  convert from 18 to 8
464   uint256 constant bonusRateDivision = 10000;     // Amount used to divide the amount so the bonus can be calculated
465 
466   ERC20Burnable public token;
467   address public receiverAddr;
468   uint256 public totalSaleAmount;
469   uint256 public totalWannaBuyAmount;
470   uint256 public startTime;
471   uint256 public bonusEndTime;
472   uint256 public bonusPercentage;
473   uint256 public bonusDecreaseRate;
474   uint256 public endTime;
475   uint256 public userWithdrawalStartTime;
476   uint256 public clearStartTime;
477   uint256 public withdrawn;
478   uint256 public proportion = 1 ether;
479   uint256 public globalAmount;
480   uint256 public rate;
481   uint256 public nrOfTransactions = 0;
482 
483   address public capListAddress;
484   mapping (address => bool) public capFreeAddresses;
485 
486   struct PurchaserInfo {
487     bool withdrew;
488     bool recorded;
489     uint256 received;     // Received ether
490     uint256 accounted;    // Received ether + bonus
491     uint256 unreceived;   // Ether stuck because failed withdraw
492   }
493 
494   struct Purchase {
495     uint256 received;     // Received ether
496     uint256 used;         // Received ether multiplied by the proportion
497     uint256 tokens;       // To receive tokens
498   }
499   mapping(address => PurchaserInfo) public purchaserMapping;
500   address[] public purchaserList;
501 
502   modifier onlyOpenTime {
503     require(isStarted());
504     require(!isEnded());
505     _;
506   }
507 
508   modifier onlyAutoWithdrawalTime {
509     require(isEnded());
510     _;
511   }
512 
513   modifier onlyUserWithdrawalTime {
514     require(isUserWithdrawalTime());
515     _;
516   }
517 
518   modifier purchasersAllWithdrawn {
519     require(withdrawn==purchaserList.length);
520     _;
521   }
522 
523   modifier onlyClearTime {
524     require(isClearTime());
525     _;
526   }
527 
528   modifier onlyCapListAddress {
529     require(msg.sender == capListAddress);
530     _;
531   }
532 
533   constructor(address _receiverAddr, ERC20Burnable _token, uint256 _totalSaleAmount, address _capListAddress) public {
534     require(_receiverAddr != address(0));
535     require(_token != address(0));
536     require(_capListAddress != address(0));
537     require(_totalSaleAmount > 0);
538 
539     receiverAddr = _receiverAddr;
540     token = _token;
541     totalSaleAmount = _totalSaleAmount;
542     capListAddress = _capListAddress;
543   }
544 
545   function isStarted() public view returns(bool) {
546     return 0 < startTime && startTime <= now && endTime != 0;
547   }
548 
549   function isEnded() public view returns(bool) {
550     return 0 < endTime && now > endTime;
551   }
552 
553   function isUserWithdrawalTime() public view returns(bool) {
554     return 0 < userWithdrawalStartTime && now > userWithdrawalStartTime;
555   }
556 
557   function isClearTime() public view returns(bool) {
558     return 0 < clearStartTime && now > clearStartTime;
559   }
560 
561   function isBonusPeriod() public view returns(bool) {
562     return now >= startTime && now <= bonusEndTime;
563   }
564 
565   function startSale(uint256 _startTime, uint256 _rate, uint256 duration,
566     uint256 bonusDuration, uint256 _bonusPercentage, uint256 _bonusDecreaseRate,
567     uint256 userWithdrawalDelaySec, uint256 clearDelaySec) public onlyOwner {
568     require(endTime == 0);
569     require(_startTime > 0);
570     require(_rate > 0);
571     require(duration > 0);
572     require(token.balanceOf(this) == totalSaleAmount);
573 
574     rate = _rate;
575     bonusPercentage = _bonusPercentage;
576     bonusDecreaseRate = _bonusDecreaseRate;
577     startTime = _startTime;
578     bonusEndTime = startTime.add(bonusDuration);
579     endTime = startTime.add(duration);
580     userWithdrawalStartTime = endTime.add(userWithdrawalDelaySec);
581     clearStartTime = endTime.add(clearDelaySec);
582   }
583 
584   function getPurchaserCount() public view returns(uint256) {
585     return purchaserList.length;
586   }
587 
588   function _calcProportion() internal {
589     assert(totalSaleAmount > 0);
590 
591     if (totalSaleAmount >= totalWannaBuyAmount) {
592       proportion = ethDecimals;
593       return;
594     }
595     proportion = totalSaleAmount.mul(ethDecimals).div(totalWannaBuyAmount);
596   }
597 
598   function getSaleInfo(address purchaser) internal view returns (Purchase p) {
599     PurchaserInfo storage pi = purchaserMapping[purchaser];
600     return Purchase(
601       pi.received,
602       pi.received.mul(proportion).div(ethDecimals),
603       pi.accounted.mul(proportion).div(ethDecimals).mul(rate).div(ltoEthDiffDecimals)
604     );
605   }
606 
607   function getPublicSaleInfo(address purchaser) public view returns (uint256, uint256, uint256) {
608     Purchase memory purchase = getSaleInfo(purchaser);
609     return (purchase.received, purchase.used, purchase.tokens);
610   }
611 
612   function () payable public {
613     buy();
614   }
615 
616   function buy() payable public onlyOpenTime {
617     require(msg.value >= minimumAmount);
618 
619     uint256 amount = msg.value;
620     PurchaserInfo storage pi = purchaserMapping[msg.sender];
621     if (!pi.recorded) {
622       pi.recorded = true;
623       purchaserList.push(msg.sender);
624     }
625     uint256 totalAmount = pi.received.add(amount);
626     if (totalAmount > maximumCapAmount && !isCapFree(msg.sender)) {
627       uint256 recap = totalAmount.sub(maximumCapAmount);
628       amount = amount.sub(recap);
629       if (amount <= 0) {
630         revert();
631       } else {
632         msg.sender.transfer(recap);
633       }
634     }
635     pi.received = pi.received.add(amount);
636 
637     globalAmount = globalAmount.add(amount);
638     if (isBonusPeriod() && bonusDecreaseRate.mul(nrOfTransactions) < bonusPercentage) {
639       uint256 percentage = bonusPercentage.sub(bonusDecreaseRate.mul(nrOfTransactions));
640       uint256 bonus = amount.div(bonusRateDivision).mul(percentage);
641       amount = amount.add(bonus);
642     }
643     pi.accounted = pi.accounted.add(amount);
644     totalWannaBuyAmount = totalWannaBuyAmount.add(amount.mul(rate).div(ltoEthDiffDecimals));
645     _calcProportion();
646     nrOfTransactions = nrOfTransactions.add(1);
647   }
648 
649   function _withdrawal(address purchaser) internal {
650     require(purchaser != 0x0);
651     PurchaserInfo storage pi = purchaserMapping[purchaser];
652     if (pi.withdrew || !pi.recorded) {
653       return;
654     }
655     pi.withdrew = true;
656     withdrawn = withdrawn.add(1);
657     Purchase memory purchase = getSaleInfo(purchaser);
658     if (purchase.used > 0 && purchase.tokens > 0) {
659       receiverAddr.transfer(purchase.used);
660       require(token.transfer(purchaser, purchase.tokens));
661 
662       uint256 unused = purchase.received.sub(purchase.used);
663       if (unused > 0) {
664         if (!purchaser.send(unused)) {
665           pi.unreceived = unused;
666         }
667       }
668     } else {
669       assert(false);
670     }
671     return;
672   }
673 
674   function withdrawal() public onlyUserWithdrawalTime {
675     _withdrawal(msg.sender);
676   }
677 
678   function withdrawalFor(uint256 index, uint256 stop) public onlyAutoWithdrawalTime onlyOwner {
679     for (; index < stop; index++) {
680       _withdrawal(purchaserList[index]);
681     }
682   }
683 
684   function clear(uint256 tokenAmount, uint256 etherAmount) public purchasersAllWithdrawn onlyClearTime onlyOwner {
685     if (tokenAmount > 0) {
686       token.burn(tokenAmount);
687     }
688     if (etherAmount > 0) {
689       receiverAddr.transfer(etherAmount);
690     }
691   }
692 
693   function withdrawFailed(address alternativeAddress) public onlyUserWithdrawalTime nonReentrant {
694     require(alternativeAddress != 0x0);
695     PurchaserInfo storage pi = purchaserMapping[msg.sender];
696 
697     require(pi.recorded);
698     require(pi.unreceived > 0);
699     if (alternativeAddress.send(pi.unreceived)) {
700       pi.unreceived = 0;
701     }
702   }
703 
704   function addCapFreeAddress(address capFreeAddress) public onlyCapListAddress {
705     require(capFreeAddress != address(0));
706 
707     capFreeAddresses[capFreeAddress] = true;
708   }
709 
710   function removeCapFreeAddress(address capFreeAddress) public onlyCapListAddress {
711     require(capFreeAddress != address(0));
712 
713     capFreeAddresses[capFreeAddress] = false;
714   }
715 
716   function isCapFree(address capFreeAddress) internal view returns (bool) {
717     return (capFreeAddresses[capFreeAddress]);
718   }
719 
720   function currentBonus() public view returns(uint256) {
721     return bonusPercentage.sub(bonusDecreaseRate.mul(nrOfTransactions));
722   }
723 }
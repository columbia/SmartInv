1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: @openzeppelin/contracts/ownership/Ownable.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be aplied to your functions to restrict their use to
431  * the owner.
432  */
433 contract Ownable {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor () internal {
442         _owner = msg.sender;
443         emit OwnershipTransferred(address(0), _owner);
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         require(isOwner(), "Ownable: caller is not the owner");
458         _;
459     }
460 
461     /**
462      * @dev Returns true if the caller is the current owner.
463      */
464     function isOwner() public view returns (bool) {
465         return msg.sender == _owner;
466     }
467 
468     /**
469      * @dev Leaves the contract without owner. It will not be possible to call
470      * `onlyOwner` functions anymore. Can only be called by the current owner.
471      *
472      * > Note: Renouncing ownership will leave the contract without an owner,
473      * thereby removing any functionality that is only available to the owner.
474      */
475     function renounceOwnership() public onlyOwner {
476         emit OwnershipTransferred(_owner, address(0));
477         _owner = address(0);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Can only be called by the current owner.
483      */
484     function transferOwnership(address newOwner) public onlyOwner {
485         _transferOwnership(newOwner);
486     }
487 
488     /**
489      * @dev Transfers ownership of the contract to a new account (`newOwner`).
490      */
491     function _transferOwnership(address newOwner) internal {
492         require(newOwner != address(0), "Ownable: new owner is the zero address");
493         emit OwnershipTransferred(_owner, newOwner);
494         _owner = newOwner;
495     }
496 }
497 
498 // File: contracts/TownToken.sol
499 
500 pragma solidity ^0.5.0;
501 
502 
503 
504 interface TownInterface {
505     function checkProposal(address proposal) external returns (bool);
506     function voteOn(address externalToken, uint256 amount) external returns (bool);
507 }
508 
509 
510 contract TownToken is ERC20, Ownable {
511     using SafeMath for uint256;
512 
513     string public constant name = "Workchain";
514     string public constant symbol = "WORK";
515     uint8 public constant decimals = 18;
516 
517     bool public initiated;
518 
519     address[] private _holders;
520 
521     TownInterface _town;
522 
523     constructor () public {
524         initiated = false;
525     }
526 
527     function getHoldersCount() external view returns (uint256) {
528         return _holders.length;
529     }
530 
531     function getHolderByIndex(uint256 index) external view returns (address) {
532         return _holders[index];
533     }
534 
535     function init (uint256 totalSupply, address townContract) public onlyOwner {
536         require(initiated == false, "contract already initiated");
537         _town = TownInterface(townContract);
538         _mint(townContract, totalSupply);
539         initiated = true;
540     }
541 
542     function transfer(address recipient, uint256 amount) public returns (bool) {
543         if (msg.sender != address(_town)) {
544             if (_town.checkProposal(recipient) == true) {
545                 super.transfer(address(_town), amount);
546                 return _town.voteOn(recipient, amount);
547             }
548             // check 223 ERC and call voteOn function
549         }
550 
551         if (recipient != address(_town)) {
552             bool found = false;
553             for (uint i = 0; i < _holders.length; ++i) {    // find recipient address in holders list
554                 if (_holders[i] == recipient) {
555                     found = true;
556                     break;
557                 }
558             }
559             if (found == false) {                           // if recipient not found, we push new address
560                 _holders.push(recipient);
561             }
562         }
563 
564         if (balanceOf(address(msg.sender)) == amount && msg.sender != address(_town)) { // remove address with 0 balance from holders
565             uint i = 0;
566             for (; i < _holders.length; ++i) {
567                 if (_holders[i] == address(msg.sender)) {
568                     break;
569                 }
570             }
571 
572             if (i < (_holders.length - 1)) {
573                 _holders[i] = _holders[_holders.length - 1];
574                 delete _holders[_holders.length - 1];
575                 _holders.length--;
576             }
577         }
578 
579         return super.transfer(recipient, amount);
580     }
581 }
582 
583 // File: contracts/ExternalTokenTemplate.sol
584 
585 pragma solidity ^0.5.0;
586 
587 
588 
589 contract ExternalTokenTemplate is ERC20 {
590     using SafeMath for uint256;
591 
592     string public constant name = "Some Other Token";
593     string public constant symbol = "SOTk";
594     uint8 public constant decimals = 18;
595 
596     constructor (uint256 totalSupply) public {
597         _mint(msg.sender, totalSupply);
598     }
599 }
600 
601 // File: contracts/Town.sol
602 
603 pragma solidity ^0.5.0;
604 
605 
606 
607 
608 contract Town is TownInterface {
609     using SafeMath for uint256;
610 
611     uint256 private _distributionPeriod;
612     uint256 private _distributionPeriodsNumber;
613     uint256 private _startRate;
614     uint256 private _minTokenGetAmount;
615     uint256 private _durationOfMinTokenGetAmount;
616     uint256 private _maxTokenGetAmount;
617     uint256 private _minExternalTokensAmount;
618     uint256 private _minSignAmount;
619     uint256 private _lastDistributionsDate;
620 
621     uint256 private _transactionsCount;
622     uint256 private _getHoldersCount;
623 
624     struct ExternalTokenDistributionsInfo {
625         address _official;
626         uint256 _distributionAmount;
627         uint256 _distributionsCount;
628     }
629 
630     struct ExternalToken {
631         ExternalTokenDistributionsInfo[] _entities;
632         uint256 _weight;
633     }
634 
635     struct TransactionsInfo {
636         uint256 _rate;
637         uint256 _amount;
638     }
639 
640     struct TownTokenRequest {
641         address _address;
642         TransactionsInfo _info;
643     }
644 
645     struct RemunerationsInfo {
646         address payable _address;
647         uint256 _priority;
648         uint256 _amount;
649     }
650 
651     struct RemunerationsOfficialsInfo {
652         uint256 _amount;
653         uint256 _decayTimestamp;
654     }
655 
656     TownToken private _token;
657 
658     mapping (address => TransactionsInfo[]) private _historyTransactions;
659 
660     TownTokenRequest[] private _queueTownTokenRequests;
661 
662     RemunerationsInfo[] private _remunerationsQueue;
663 
664     mapping (address => ExternalToken) private _externalTokens;
665     address[] private _externalTokensAddresses;
666 
667     mapping (address => mapping (address => uint256)) private _townHoldersLedger;
668     mapping (address => address[]) private _ledgerExternalTokensAddresses;
669 
670     mapping (address => RemunerationsOfficialsInfo) private _officialsLedger;
671 
672     address[] private _externalTokensWithWight;
673 
674     modifier onlyTownTokenSmartContract {
675         require(msg.sender == address(_token), "only town token smart contract can call this function");
676         _;
677     }
678 
679     constructor (
680         uint256 distributionPeriod,
681         uint256 distributionPeriodsNumber,
682         uint256 startRate,
683         uint256 minTokenGetAmount,
684         uint256 durationOfMinTokenGetAmount,
685         uint256 maxTokenGetAmount,
686         uint256 minExternalTokensAmount,
687         address tokenAddress) public {
688         require(distributionPeriod > 0, "distributionPeriod wrong");
689         require(distributionPeriodsNumber > 0, "distributionPeriodsNumber wrong");
690         require(minTokenGetAmount > 0, "minTokenGetAmount wrong");
691         require(durationOfMinTokenGetAmount > 0, "durationOfMinTokenGetAmount wrong");
692         require(maxTokenGetAmount > 0, "maxTokenGetAmount wrong");
693         require(minExternalTokensAmount > 0, "minExternalTokensAmount wrong");
694 
695         _distributionPeriod = distributionPeriod * 1 days;
696         _distributionPeriodsNumber = distributionPeriodsNumber;
697         _startRate = startRate;
698 
699         _token = TownToken(tokenAddress);
700 
701         _transactionsCount = 0;
702         _minTokenGetAmount = minTokenGetAmount;
703         _durationOfMinTokenGetAmount = durationOfMinTokenGetAmount;
704         _maxTokenGetAmount = maxTokenGetAmount;
705         _minExternalTokensAmount = minExternalTokensAmount;
706         _lastDistributionsDate = (now.div(86400).add(1)).mul(86400);
707         _minSignAmount = 10000000000000;
708     }
709 
710     function () external payable {
711         if (msg.value <= _minSignAmount) {
712             if (_officialsLedger[msg.sender]._amount > 0) {
713                 claimFunds(msg.sender);
714             }
715             if (_ledgerExternalTokensAddresses[msg.sender].length > 0) {
716                 claimExternalTokens(msg.sender);
717             }
718             return;
719         }
720         uint256 tokenAmount = IWantTakeTokensToAmount(msg.value);
721         require(_transactionsCount > _durationOfMinTokenGetAmount || tokenAmount > _minTokenGetAmount, "insufficient amount");
722 
723         getTownTokens(msg.sender);
724     }
725 
726     function token() external view returns (IERC20) {
727         return _token;
728     }
729 
730     function distributionPeriod() external view returns (uint256) {
731         return _distributionPeriod;
732     }
733 
734     function distributionPeriodsNumber() external view returns (uint256) {
735         return _distributionPeriodsNumber;
736     }
737 
738     function startRate() external view returns (uint256) {
739         return _startRate;
740     }
741 
742     function minTokenGetAmount() external view returns (uint256) {
743         return _minTokenGetAmount;
744     }
745 
746     function durationOfMinTokenGetAmount() external view returns (uint256) {
747         return _durationOfMinTokenGetAmount;
748     }
749 
750     function maxTokenGetAmount() external view returns (uint256) {
751         return _maxTokenGetAmount;
752     }
753 
754     function minExternalTokensAmount() external view returns (uint256) {
755         return _minExternalTokensAmount;
756     }
757 
758     function lastDistributionsDate() external view returns (uint256) {
759         return _lastDistributionsDate;
760     }
761 
762     function transactionsCount() external view returns (uint256) {
763         return _transactionsCount;
764     }
765 
766     function getCurrentRate() external view returns (uint256) {
767         return currentRate();
768     }
769 
770     function getLengthRemunerationQueue() external view returns (uint256) {
771         return _remunerationsQueue.length;
772     }
773 
774     function getMinSignAmount() external view returns (uint256) {
775         return _minSignAmount;
776     }
777 
778     function getRemunerationQueue(uint256 index) external view returns (address, uint256, uint256) {
779         return (_remunerationsQueue[index]._address, _remunerationsQueue[index]._priority, _remunerationsQueue[index]._amount);
780     }
781 
782     function getLengthQueueTownTokenRequests() external view returns (uint256) {
783         return _queueTownTokenRequests.length;
784     }
785 
786     function getQueueTownTokenRequests(uint256 index) external  view returns (address, uint256, uint256) {
787         TownTokenRequest memory tokenRequest = _queueTownTokenRequests[index];
788         return (tokenRequest._address, tokenRequest._info._rate, tokenRequest._info._amount);
789     }
790 
791     function getMyTownTokens() external view returns (uint256, uint256) {
792         uint256 amount = 0;
793         uint256 tokenAmount = 0;
794         for (uint256 i = 0; i < _historyTransactions[msg.sender].length; ++i) {
795             amount = amount.add(_historyTransactions[msg.sender][i]._amount.mul(_historyTransactions[msg.sender][i]._rate).div(10 ** 18));
796             tokenAmount = tokenAmount.add(_historyTransactions[msg.sender][i]._amount);
797         }
798         return (amount, tokenAmount);
799     }
800 
801     function checkProposal(address proposal) external returns (bool) {
802         if (_externalTokens[proposal]._entities.length > 0) {
803             return true;
804         }
805         return false;
806     }
807 
808     function sendExternalTokens(address official, address externalToken) external returns (bool) {
809         ERC20 tokenERC20 = ERC20(externalToken);
810         uint256 balance = tokenERC20.allowance(official, address(this));
811         require(tokenERC20.balanceOf(official) >= balance, "Official should have external tokens for approved");
812         require(balance > 0, "External tokens must be approved for town smart contract");
813         tokenERC20.transferFrom(official, address(this), balance);
814 
815         ExternalTokenDistributionsInfo memory tokenInfo;
816         tokenInfo._official = official;
817         tokenInfo._distributionsCount = _distributionPeriodsNumber;
818         tokenInfo._distributionAmount = balance.div(_distributionPeriodsNumber);
819 
820         ExternalToken storage tokenObj = _externalTokens[externalToken];
821 
822         if (tokenObj._entities.length == 0) {
823             _externalTokensAddresses.push(externalToken);
824         }
825 
826         tokenObj._entities.push(tokenInfo);
827 
828         return true;
829     }
830 
831     function remuneration(uint256 tokensAmount) external returns (bool) {
832         require(_token.balanceOf(msg.sender) >= tokensAmount, "Town tokens not found");
833         require(_token.allowance(msg.sender, address(this)) >= tokensAmount, "Town tokens must be approved for town smart contract");
834 
835         uint256 debt = 0;
836         uint256 restOfTokens = tokensAmount;
837         uint256 executedRequestCount = 0;
838         for (uint256 i = 0; i < _queueTownTokenRequests.length; ++i) {
839             address user = _queueTownTokenRequests[i]._address;
840             uint256 rate = _queueTownTokenRequests[i]._info._rate;
841             uint256 amount = _queueTownTokenRequests[i]._info._amount;
842             if (restOfTokens > amount) {
843                 _token.transferFrom(msg.sender, user, amount);
844                 restOfTokens = restOfTokens.sub(amount);
845                 debt = debt.add(amount.mul(rate).div(10 ** 18));
846                 executedRequestCount++;
847             } else {
848                 break;
849             }
850         }
851 
852         if (restOfTokens > 0) {
853             _token.transferFrom(msg.sender, address(this), restOfTokens);
854         }
855 
856         if (executedRequestCount > 0) {
857             for (uint256 i = executedRequestCount; i < _queueTownTokenRequests.length; ++i) {
858                 _queueTownTokenRequests[i - executedRequestCount] = _queueTownTokenRequests[i];
859             }
860 
861             for (uint256 i = 0; i < executedRequestCount; ++i) {
862                 delete _queueTownTokenRequests[_queueTownTokenRequests.length - 1];
863                 _queueTownTokenRequests.length--;
864             }
865         }
866 
867         if (_historyTransactions[msg.sender].length > 0) {
868             for (uint256 i = _historyTransactions[msg.sender].length - 1; ; --i) {
869                 uint256 rate = _historyTransactions[msg.sender][i]._rate;
870                 uint256 amount = _historyTransactions[msg.sender][i]._amount;
871                 delete _historyTransactions[msg.sender][i];
872                 _historyTransactions[msg.sender].length--;
873 
874                 if (restOfTokens < amount) {
875                     TransactionsInfo memory info = TransactionsInfo(rate, amount.sub(restOfTokens));
876                     _historyTransactions[msg.sender].push(info);
877 
878                     debt = debt.add(restOfTokens.mul(rate).div(10 ** 18));
879                     break;
880                 }
881 
882                 debt = debt.add(amount.mul(rate).div(10 ** 18));
883                 restOfTokens = restOfTokens.sub(amount);
884 
885                 if (i == 0) break;
886             }
887         }
888 
889         if (debt > address(this).balance) {
890             msg.sender.transfer(address(this).balance);
891 
892             RemunerationsInfo memory info = RemunerationsInfo(msg.sender, 2, debt.sub(address(this).balance));
893             _remunerationsQueue.push(info);
894         } else {
895             msg.sender.transfer(debt);
896         }
897 
898         return true;
899     }
900 
901     function distributionSnapshot() external returns (bool) {
902         require(now > (_lastDistributionsDate + _distributionPeriod), "distribution time has not yet arrived");
903 
904         uint256 sumWeight = 0;
905         address[] memory tempArray;
906         _externalTokensWithWight = tempArray;
907         for (uint256 i = 0; i < _externalTokensAddresses.length; ++i) {
908             ExternalToken memory externalToken = _externalTokens[_externalTokensAddresses[i]];
909             if (externalToken._weight > 0) {
910                 uint256 sumExternalTokens = 0;
911                 for (uint256 j = 0; j < externalToken._entities.length; ++j) {
912                     if (externalToken._entities[j]._distributionsCount > 0) {
913                         ExternalTokenDistributionsInfo memory info = externalToken._entities[j];
914                         sumExternalTokens = sumExternalTokens.add(info._distributionAmount.mul(info._distributionsCount));
915                     }
916                 }
917                 if (sumExternalTokens > _minExternalTokensAmount) {
918                     sumWeight = sumWeight.add(externalToken._weight);
919                     _externalTokensWithWight.push(_externalTokensAddresses[i]);
920                 } else {
921                     externalToken._weight = 0;
922                 }
923             }
924         }
925 
926         uint256 fullBalance = address(this).balance;
927         for (uint256 i = 0; i < _externalTokensWithWight.length; ++i) {
928             ExternalToken memory externalToken = _externalTokens[_externalTokensWithWight[i]];
929             uint256 sumExternalTokens = 0;
930             for (uint256 j = 0; j < externalToken._entities.length; ++j) {
931                 sumExternalTokens = sumExternalTokens.add(externalToken._entities[j]._distributionAmount);
932             }
933             uint256 externalTokenCost = fullBalance.mul(externalToken._weight).div(sumWeight);
934             for (uint256 j = 0; j < externalToken._entities.length; ++j) {
935                 address official = externalToken._entities[j]._official;
936                 uint256 tokensAmount = externalToken._entities[j]._distributionAmount;
937                 uint256 amount = externalTokenCost.mul(tokensAmount).div(sumExternalTokens);
938                 uint256 decayTimestamp = (now - _lastDistributionsDate).div(_distributionPeriod).mul(_distributionPeriod).add(_lastDistributionsDate).add(_distributionPeriod);
939                 _officialsLedger[official] = RemunerationsOfficialsInfo(amount, decayTimestamp);
940             }
941         }
942 
943         uint256 sumHoldersTokens = _token.totalSupply().sub(_token.balanceOf(address(this)));
944 
945         if (sumHoldersTokens != 0) {
946             for (uint256 i = 0; i < _token.getHoldersCount(); ++i) {
947                 address holder = _token.getHolderByIndex(i);
948                 uint256 balance = _token.balanceOf(holder);
949                 for (uint256 j = 0; j < _externalTokensAddresses.length; ++j) {
950                     address externalTokenAddress = _externalTokensAddresses[j];
951                     ExternalToken memory externalToken = _externalTokens[externalTokenAddress];
952                     for (uint256 k = 0; k < externalToken._entities.length; ++k) {
953                         if (holder != address(this) && externalToken._entities[k]._distributionsCount > 0) {
954                             uint256 percent = balance.mul(externalToken._entities[k]._distributionAmount).div(sumHoldersTokens);
955                             if (percent > (10 ** 4)) {
956                                 address[] memory externalTokensForHolder = _ledgerExternalTokensAddresses[holder];
957                                 bool found = false;
958                                 for (uint256 h = 0; h < externalTokensForHolder.length; ++h) {
959                                     if (externalTokensForHolder[h] == externalTokenAddress) {
960                                         found = true;
961                                         break;
962                                     }
963                                 }
964                                 if (found == false) {
965                                     _ledgerExternalTokensAddresses[holder].push(externalTokenAddress);
966                                 }
967 
968                                 _townHoldersLedger[holder][externalTokenAddress] = _townHoldersLedger[holder][externalTokenAddress].add(percent);
969                             }
970                         }
971                     }
972                 }
973             }
974 
975             for (uint256 j = 0; j < _externalTokensAddresses.length; ++j) {
976                 ExternalTokenDistributionsInfo[] memory tempEntities = _externalTokens[_externalTokensAddresses[j]]._entities;
977 
978                 for (uint256 k = 0; k < tempEntities.length; ++k) {
979                     delete _externalTokens[_externalTokensAddresses[j]]._entities[k];
980                 }
981                 _externalTokens[_externalTokensAddresses[j]]._entities.length = 0;
982 
983                 for (uint256 k = 0; k < tempEntities.length; ++k) {
984                     tempEntities[k]._distributionsCount--;
985                     if (tempEntities[k]._distributionsCount > 0) {
986                         _externalTokens[_externalTokensAddresses[j]]._entities.push(tempEntities[k]);
987                     }
988                 }
989             }
990         }
991 
992         for (uint256 i = 0; i < _externalTokensAddresses.length; ++i) {
993             if (_externalTokens[_externalTokensAddresses[i]]._weight > 0) {
994                 _externalTokens[_externalTokensAddresses[i]]._weight = 0;
995             }
996         }
997 
998         _lastDistributionsDate = _lastDistributionsDate.add(_distributionPeriod);
999         return true;
1000     }
1001 
1002     function voteOn(address externalToken, uint256 amount) external onlyTownTokenSmartContract returns (bool) {
1003         require(_externalTokens[externalToken]._entities.length > 0, "external token address not found");
1004         require(now < (_lastDistributionsDate + _distributionPeriod), "need call distributionSnapshot function");
1005 
1006         _externalTokens[externalToken]._weight = _externalTokens[externalToken]._weight.add(amount);
1007         return true;
1008     }
1009 
1010     function claimExternalTokens(address holder) public returns (bool) {
1011         address[] memory externalTokensForHolder = _ledgerExternalTokensAddresses[holder];
1012         if (externalTokensForHolder.length > 0) {
1013             for (uint256 i = externalTokensForHolder.length - 1; ; --i) {
1014                 ERC20(externalTokensForHolder[i]).transfer(holder, _townHoldersLedger[holder][externalTokensForHolder[i]]);
1015                 delete _townHoldersLedger[holder][externalTokensForHolder[i]];
1016                 delete _ledgerExternalTokensAddresses[holder][i];
1017                 _ledgerExternalTokensAddresses[holder].length--;
1018 
1019                 if (i == 0) break;
1020             }
1021         }
1022 
1023         return true;
1024     }
1025 
1026     function claimFunds(address payable official) public returns (bool) {
1027         require(_officialsLedger[official]._amount != 0, "official address not found in ledger");
1028 
1029         if (now >= _officialsLedger[official]._decayTimestamp) {
1030             RemunerationsOfficialsInfo memory info = RemunerationsOfficialsInfo(0, 0);
1031             _officialsLedger[official] = info;
1032             return false;
1033         }
1034 
1035         uint256 amount = _officialsLedger[official]._amount;
1036         if (address(this).balance >= amount) {
1037             official.transfer(amount);
1038         } else {
1039             RemunerationsInfo memory info = RemunerationsInfo(official, 1, amount);
1040             _remunerationsQueue.push(info);
1041         }
1042         RemunerationsOfficialsInfo memory info = RemunerationsOfficialsInfo(0, 0);
1043         _officialsLedger[official] = info;
1044 
1045         return true;
1046     }
1047 
1048     function IWantTakeTokensToAmount(uint256 amount) public view returns (uint256) {
1049         return amount.mul(10 ** 18).div(currentRate());
1050     }
1051 
1052     function getTownTokens(address holder) public payable returns (bool) {
1053         require(holder != address(0), "holder address cannot be null");
1054 
1055         uint256 amount = msg.value;
1056         uint256 tokenAmount = IWantTakeTokensToAmount(amount);
1057         uint256 rate = currentRate();
1058         if (_transactionsCount < _durationOfMinTokenGetAmount && tokenAmount < _minTokenGetAmount) {
1059             return false;
1060         }
1061         if (tokenAmount >= _maxTokenGetAmount) {
1062             tokenAmount = _maxTokenGetAmount;
1063             uint256 change = amount.sub(_maxTokenGetAmount.mul(rate).div(10 ** 18));
1064             msg.sender.transfer(change);
1065             amount = amount.sub(change);
1066         }
1067 
1068         if (_token.balanceOf(address(this)) >= tokenAmount) {
1069             TransactionsInfo memory transactionsHistory = TransactionsInfo(rate, tokenAmount);
1070             _token.transfer(holder, tokenAmount);
1071             _historyTransactions[holder].push(transactionsHistory);
1072             _transactionsCount = _transactionsCount.add(1);
1073         } else {
1074             if (_token.balanceOf(address(this)) > 0) {
1075                 uint256 tokenBalance = _token.balanceOf(address(this));
1076                 _token.transfer(holder, tokenBalance);
1077                 TransactionsInfo memory transactionsHistory = TransactionsInfo(rate, tokenBalance);
1078                 _historyTransactions[holder].push(transactionsHistory);
1079                 tokenAmount = tokenAmount.sub(tokenBalance);
1080             }
1081 
1082             TransactionsInfo memory transactionsInfo = TransactionsInfo(rate, tokenAmount);
1083             TownTokenRequest memory tokenRequest = TownTokenRequest(holder, transactionsInfo);
1084             _queueTownTokenRequests.push(tokenRequest);
1085         }
1086 
1087         for (uint256 i = 0; i < _remunerationsQueue.length; ++i) {
1088             if (_remunerationsQueue[i]._priority == 1) {
1089                 if (_remunerationsQueue[i]._amount > amount) {
1090                     _remunerationsQueue[i]._address.transfer(_remunerationsQueue[i]._amount);
1091                     amount = amount.sub(_remunerationsQueue[i]._amount);
1092 
1093                     delete _remunerationsQueue[i];
1094                     for (uint j = i + 1; j < _remunerationsQueue.length; ++j) {
1095                         _remunerationsQueue[j - 1] = _remunerationsQueue[j];
1096                     }
1097                     _remunerationsQueue.length--;
1098                 } else {
1099                     _remunerationsQueue[i]._address.transfer(amount);
1100                     _remunerationsQueue[i]._amount = _remunerationsQueue[i]._amount.sub(amount);
1101                     break;
1102                 }
1103             }
1104         }
1105 
1106         for (uint256 i = 0; i < _remunerationsQueue.length; ++i) {
1107             if (_remunerationsQueue[i]._amount > amount) {
1108                 _remunerationsQueue[i]._address.transfer(_remunerationsQueue[i]._amount);
1109                 amount = amount.sub(_remunerationsQueue[i]._amount);
1110 
1111                 delete _remunerationsQueue[i];
1112                 for (uint j = i + 1; j < _remunerationsQueue.length; ++j) {
1113                     _remunerationsQueue[j - 1] = _remunerationsQueue[j];
1114                 }
1115                 _remunerationsQueue.length--;
1116             } else {
1117                 _remunerationsQueue[i]._address.transfer(amount);
1118                 _remunerationsQueue[i]._amount = _remunerationsQueue[i]._amount.sub(amount);
1119                 break;
1120             }
1121         }
1122 
1123         return true;
1124     }
1125 
1126     function currentRate() internal view returns (uint256) {
1127         return _startRate.mul((now - 1579392000).div(604800));
1128     }
1129 }
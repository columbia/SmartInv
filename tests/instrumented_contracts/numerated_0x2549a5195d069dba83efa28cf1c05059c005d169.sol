1 // File contracts/base/inheritance/Storage.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity 0.5.16;
5 
6 contract Storage {
7 
8   address public governance;
9   address public controller;
10 
11   constructor() public {
12     governance = msg.sender;
13   }
14 
15   modifier onlyGovernance() {
16     require(isGovernance(msg.sender), "Not governance");
17     _;
18   }
19 
20   function setGovernance(address _governance) public onlyGovernance {
21     require(_governance != address(0), "new governance shouldn't be empty");
22     governance = _governance;
23   }
24 
25   function setController(address _controller) public onlyGovernance {
26     require(_controller != address(0), "new controller shouldn't be empty");
27     controller = _controller;
28   }
29 
30   function isGovernance(address account) public view returns (bool) {
31     return account == governance;
32   }
33 
34   function isController(address account) public view returns (bool) {
35     return account == controller;
36   }
37 }
38 
39 
40 // File contracts/base/inheritance/Governable.sol
41 
42 pragma solidity 0.5.16;
43 
44 contract Governable {
45 
46   Storage public store;
47 
48   constructor(address _store) public {
49     require(_store != address(0), "new storage shouldn't be empty");
50     store = Storage(_store);
51   }
52 
53   modifier onlyGovernance() {
54     require(store.isGovernance(msg.sender), "Not governance");
55     _;
56   }
57 
58   function setStorage(address _store) public onlyGovernance {
59     require(_store != address(0), "new storage shouldn't be empty");
60     store = Storage(_store);
61   }
62 
63   function governance() public view returns (address) {
64     return store.governance();
65   }
66 }
67 
68 
69 // File contracts/base/inheritance/Controllable.sol
70 
71 pragma solidity 0.5.16;
72 
73 contract Controllable is Governable {
74 
75   constructor(address _storage) Governable(_storage) public {
76   }
77 
78   modifier onlyController() {
79     require(store.isController(msg.sender), "Not a controller");
80     _;
81   }
82 
83   modifier onlyControllerOrGovernance(){
84     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
85       "The caller must be controller or governance");
86     _;
87   }
88 
89   function controller() public view returns (address) {
90     return store.controller();
91   }
92 }
93 
94 
95 // File contracts/base/interface/IController.sol
96 
97 pragma solidity 0.5.16;
98 
99 interface IController {
100 
101     event SharePriceChangeLog(
102       address indexed vault,
103       address indexed strategy,
104       uint256 oldSharePrice,
105       uint256 newSharePrice,
106       uint256 timestamp
107     );
108 
109     // [Grey list]
110     // An EOA can safely interact with the system no matter what.
111     // If you're using Metamask, you're using an EOA.
112     // Only smart contracts may be affected by this grey list.
113     //
114     // This contract will not be able to ban any EOA from the system
115     // even if an EOA is being added to the greyList, he/she will still be able
116     // to interact with the whole system as if nothing happened.
117     // Only smart contracts will be affected by being added to the greyList.
118     // This grey list is only used in Vault.sol, see the code there for reference
119     function greyList(address _target) external view returns(bool);
120 
121     function addVaultAndStrategy(address _vault, address _strategy) external;
122     function doHardWork(address _vault) external;
123 
124     function salvage(address _token, uint256 amount) external;
125     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
126 
127     function notifyFee(address _underlying, uint256 fee) external;
128     function profitSharingNumerator() external view returns (uint256);
129     function profitSharingDenominator() external view returns (uint256);
130 
131     function feeRewardForwarder() external view returns(address);
132     function setFeeRewardForwarder(address _value) external;
133 
134     function addHardWorker(address _worker) external;
135     function addToWhitelist(address _target) external;
136 }
137 
138 
139 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v2.5.1
140 
141 pragma solidity ^0.5.0;
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
145  * the optional functions; to access them see {ERC20Detailed}.
146  */
147 interface IERC20 {
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint256);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint256);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `recipient`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address recipient, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `sender` to `recipient` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Emitted when `value` tokens are moved from one account (`from`) to
205      * another (`to`).
206      *
207      * Note that `value` may be zero.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     /**
212      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
213      * a call to {approve}. `value` is the new allowance.
214      */
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 
219 // File @openzeppelin/contracts/GSN/Context.sol@v2.5.1
220 
221 pragma solidity ^0.5.0;
222 
223 /*
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with GSN meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 contract Context {
234     // Empty internal constructor, to prevent people from mistakenly deploying
235     // an instance of this contract, which should be used via inheritance.
236     constructor () internal { }
237     // solhint-disable-previous-line no-empty-blocks
238 
239     function _msgSender() internal view returns (address payable) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view returns (bytes memory) {
244         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
245         return msg.data;
246     }
247 }
248 
249 
250 // File @openzeppelin/contracts/math/SafeMath.sol@v2.5.1
251 
252 pragma solidity ^0.5.0;
253 
254 /**
255  * @dev Wrappers over Solidity's arithmetic operations with added overflow
256  * checks.
257  *
258  * Arithmetic operations in Solidity wrap on overflow. This can easily result
259  * in bugs, because programmers usually assume that an overflow raises an
260  * error, which is the standard behavior in high level programming languages.
261  * `SafeMath` restores this intuition by reverting the transaction when an
262  * operation overflows.
263  *
264  * Using this library instead of the unchecked operations eliminates an entire
265  * class of bugs, so it's recommended to use it always.
266  */
267 library SafeMath {
268     /**
269      * @dev Returns the addition of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `+` operator.
273      *
274      * Requirements:
275      * - Addition cannot overflow.
276      */
277     function add(uint256 a, uint256 b) internal pure returns (uint256) {
278         uint256 c = a + b;
279         require(c >= a, "SafeMath: addition overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting on
286      * overflow (when the result is negative).
287      *
288      * Counterpart to Solidity's `-` operator.
289      *
290      * Requirements:
291      * - Subtraction cannot overflow.
292      */
293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294         return sub(a, b, "SafeMath: subtraction overflow");
295     }
296 
297     /**
298      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
299      * overflow (when the result is negative).
300      *
301      * Counterpart to Solidity's `-` operator.
302      *
303      * Requirements:
304      * - Subtraction cannot overflow.
305      *
306      * _Available since v2.4.0._
307      */
308     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         require(b <= a, errorMessage);
310         uint256 c = a - b;
311 
312         return c;
313     }
314 
315     /**
316      * @dev Returns the multiplication of two unsigned integers, reverting on
317      * overflow.
318      *
319      * Counterpart to Solidity's `*` operator.
320      *
321      * Requirements:
322      * - Multiplication cannot overflow.
323      */
324     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
325         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
326         // benefit is lost if 'b' is also tested.
327         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
328         if (a == 0) {
329             return 0;
330         }
331 
332         uint256 c = a * b;
333         require(c / a == b, "SafeMath: multiplication overflow");
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers. Reverts on
340      * division by zero. The result is rounded towards zero.
341      *
342      * Counterpart to Solidity's `/` operator. Note: this function uses a
343      * `revert` opcode (which leaves remaining gas untouched) while Solidity
344      * uses an invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b) internal pure returns (uint256) {
350         return div(a, b, "SafeMath: division by zero");
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator. Note: this function uses a
358      * `revert` opcode (which leaves remaining gas untouched) while Solidity
359      * uses an invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      * - The divisor cannot be zero.
363      *
364      * _Available since v2.4.0._
365      */
366     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         // Solidity only automatically asserts when dividing by 0
368         require(b > 0, errorMessage);
369         uint256 c = a / b;
370         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
371 
372         return c;
373     }
374 
375     /**
376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
377      * Reverts when dividing by zero.
378      *
379      * Counterpart to Solidity's `%` operator. This function uses a `revert`
380      * opcode (which leaves remaining gas untouched) while Solidity uses an
381      * invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      * - The divisor cannot be zero.
385      */
386     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
387         return mod(a, b, "SafeMath: modulo by zero");
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * Reverts with custom message when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      * - The divisor cannot be zero.
400      *
401      * _Available since v2.4.0._
402      */
403     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
404         require(b != 0, errorMessage);
405         return a % b;
406     }
407 }
408 
409 
410 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v2.5.1
411 
412 pragma solidity ^0.5.0;
413 
414 
415 
416 /**
417  * @dev Implementation of the {IERC20} interface.
418  *
419  * This implementation is agnostic to the way tokens are created. This means
420  * that a supply mechanism has to be added in a derived contract using {_mint}.
421  * For a generic mechanism see {ERC20Mintable}.
422  *
423  * TIP: For a detailed writeup see our guide
424  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
425  * to implement supply mechanisms].
426  *
427  * We have followed general OpenZeppelin guidelines: functions revert instead
428  * of returning `false` on failure. This behavior is nonetheless conventional
429  * and does not conflict with the expectations of ERC20 applications.
430  *
431  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
432  * This allows applications to reconstruct the allowance for all accounts just
433  * by listening to said events. Other implementations of the EIP may not emit
434  * these events, as it isn't required by the specification.
435  *
436  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
437  * functions have been added to mitigate the well-known issues around setting
438  * allowances. See {IERC20-approve}.
439  */
440 contract ERC20 is Context, IERC20 {
441     using SafeMath for uint256;
442 
443     mapping (address => uint256) private _balances;
444 
445     mapping (address => mapping (address => uint256)) private _allowances;
446 
447     uint256 private _totalSupply;
448 
449     /**
450      * @dev See {IERC20-totalSupply}.
451      */
452     function totalSupply() public view returns (uint256) {
453         return _totalSupply;
454     }
455 
456     /**
457      * @dev See {IERC20-balanceOf}.
458      */
459     function balanceOf(address account) public view returns (uint256) {
460         return _balances[account];
461     }
462 
463     /**
464      * @dev See {IERC20-transfer}.
465      *
466      * Requirements:
467      *
468      * - `recipient` cannot be the zero address.
469      * - the caller must have a balance of at least `amount`.
470      */
471     function transfer(address recipient, uint256 amount) public returns (bool) {
472         _transfer(_msgSender(), recipient, amount);
473         return true;
474     }
475 
476     /**
477      * @dev See {IERC20-allowance}.
478      */
479     function allowance(address owner, address spender) public view returns (uint256) {
480         return _allowances[owner][spender];
481     }
482 
483     /**
484      * @dev See {IERC20-approve}.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      */
490     function approve(address spender, uint256 amount) public returns (bool) {
491         _approve(_msgSender(), spender, amount);
492         return true;
493     }
494 
495     /**
496      * @dev See {IERC20-transferFrom}.
497      *
498      * Emits an {Approval} event indicating the updated allowance. This is not
499      * required by the EIP. See the note at the beginning of {ERC20};
500      *
501      * Requirements:
502      * - `sender` and `recipient` cannot be the zero address.
503      * - `sender` must have a balance of at least `amount`.
504      * - the caller must have allowance for `sender`'s tokens of at least
505      * `amount`.
506      */
507     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
508         _transfer(sender, recipient, amount);
509         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
510         return true;
511     }
512 
513     /**
514      * @dev Atomically increases the allowance granted to `spender` by the caller.
515      *
516      * This is an alternative to {approve} that can be used as a mitigation for
517      * problems described in {IERC20-approve}.
518      *
519      * Emits an {Approval} event indicating the updated allowance.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
527         return true;
528     }
529 
530     /**
531      * @dev Atomically decreases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      * - `spender` must have allowance for the caller of at least
542      * `subtractedValue`.
543      */
544     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
546         return true;
547     }
548 
549     /**
550      * @dev Moves tokens `amount` from `sender` to `recipient`.
551      *
552      * This is internal function is equivalent to {transfer}, and can be used to
553      * e.g. implement automatic token fees, slashing mechanisms, etc.
554      *
555      * Emits a {Transfer} event.
556      *
557      * Requirements:
558      *
559      * - `sender` cannot be the zero address.
560      * - `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      */
563     function _transfer(address sender, address recipient, uint256 amount) internal {
564         require(sender != address(0), "ERC20: transfer from the zero address");
565         require(recipient != address(0), "ERC20: transfer to the zero address");
566 
567         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
568         _balances[recipient] = _balances[recipient].add(amount);
569         emit Transfer(sender, recipient, amount);
570     }
571 
572     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
573      * the total supply.
574      *
575      * Emits a {Transfer} event with `from` set to the zero address.
576      *
577      * Requirements
578      *
579      * - `to` cannot be the zero address.
580      */
581     function _mint(address account, uint256 amount) internal {
582         require(account != address(0), "ERC20: mint to the zero address");
583 
584         _totalSupply = _totalSupply.add(amount);
585         _balances[account] = _balances[account].add(amount);
586         emit Transfer(address(0), account, amount);
587     }
588 
589     /**
590      * @dev Destroys `amount` tokens from `account`, reducing the
591      * total supply.
592      *
593      * Emits a {Transfer} event with `to` set to the zero address.
594      *
595      * Requirements
596      *
597      * - `account` cannot be the zero address.
598      * - `account` must have at least `amount` tokens.
599      */
600     function _burn(address account, uint256 amount) internal {
601         require(account != address(0), "ERC20: burn from the zero address");
602 
603         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
604         _totalSupply = _totalSupply.sub(amount);
605         emit Transfer(account, address(0), amount);
606     }
607 
608     /**
609      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
610      *
611      * This is internal function is equivalent to `approve`, and can be used to
612      * e.g. set automatic allowances for certain subsystems, etc.
613      *
614      * Emits an {Approval} event.
615      *
616      * Requirements:
617      *
618      * - `owner` cannot be the zero address.
619      * - `spender` cannot be the zero address.
620      */
621     function _approve(address owner, address spender, uint256 amount) internal {
622         require(owner != address(0), "ERC20: approve from the zero address");
623         require(spender != address(0), "ERC20: approve to the zero address");
624 
625         _allowances[owner][spender] = amount;
626         emit Approval(owner, spender, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
631      * from the caller's allowance.
632      *
633      * See {_burn} and {_approve}.
634      */
635     function _burnFrom(address account, uint256 amount) internal {
636         _burn(account, amount);
637         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
638     }
639 }
640 
641 
642 // File @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol@v2.5.1
643 
644 pragma solidity ^0.5.0;
645 
646 /**
647  * @dev Optional functions from the ERC20 standard.
648  */
649 contract ERC20Detailed is IERC20 {
650     string private _name;
651     string private _symbol;
652     uint8 private _decimals;
653 
654     /**
655      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
656      * these values are immutable: they can only be set once during
657      * construction.
658      */
659     constructor (string memory name, string memory symbol, uint8 decimals) public {
660         _name = name;
661         _symbol = symbol;
662         _decimals = decimals;
663     }
664 
665     /**
666      * @dev Returns the name of the token.
667      */
668     function name() public view returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the symbol of the token, usually a shorter version of the
674      * name.
675      */
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the number of decimals used to get its user representation.
682      * For example, if `decimals` equals `2`, a balance of `505` tokens should
683      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
684      *
685      * Tokens usually opt for a value of 18, imitating the relationship between
686      * Ether and Wei.
687      *
688      * NOTE: This information is only used for _display_ purposes: it in
689      * no way affects any of the arithmetic of the contract, including
690      * {IERC20-balanceOf} and {IERC20-transfer}.
691      */
692     function decimals() public view returns (uint8) {
693         return _decimals;
694     }
695 }
696 
697 
698 // File @openzeppelin/contracts/utils/Address.sol@v2.5.1
699 
700 pragma solidity ^0.5.5;
701 
702 /**
703  * @dev Collection of functions related to the address type
704  */
705 library Address {
706     /**
707      * @dev Returns true if `account` is a contract.
708      *
709      * [IMPORTANT]
710      * ====
711      * It is unsafe to assume that an address for which this function returns
712      * false is an externally-owned account (EOA) and not a contract.
713      *
714      * Among others, `isContract` will return false for the following
715      * types of addresses:
716      *
717      *  - an externally-owned account
718      *  - a contract in construction
719      *  - an address where a contract will be created
720      *  - an address where a contract lived, but was destroyed
721      * ====
722      */
723     function isContract(address account) internal view returns (bool) {
724         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
725         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
726         // for accounts without code, i.e. `keccak256('')`
727         bytes32 codehash;
728         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
729         // solhint-disable-next-line no-inline-assembly
730         assembly { codehash := extcodehash(account) }
731         return (codehash != accountHash && codehash != 0x0);
732     }
733 
734     /**
735      * @dev Converts an `address` into `address payable`. Note that this is
736      * simply a type cast: the actual underlying value is not changed.
737      *
738      * _Available since v2.4.0._
739      */
740     function toPayable(address account) internal pure returns (address payable) {
741         return address(uint160(account));
742     }
743 
744     /**
745      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
746      * `recipient`, forwarding all available gas and reverting on errors.
747      *
748      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
749      * of certain opcodes, possibly making contracts go over the 2300 gas limit
750      * imposed by `transfer`, making them unable to receive funds via
751      * `transfer`. {sendValue} removes this limitation.
752      *
753      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
754      *
755      * IMPORTANT: because control is transferred to `recipient`, care must be
756      * taken to not create reentrancy vulnerabilities. Consider using
757      * {ReentrancyGuard} or the
758      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
759      *
760      * _Available since v2.4.0._
761      */
762     function sendValue(address payable recipient, uint256 amount) internal {
763         require(address(this).balance >= amount, "Address: insufficient balance");
764 
765         // solhint-disable-next-line avoid-call-value
766         (bool success, ) = recipient.call.value(amount)("");
767         require(success, "Address: unable to send value, recipient may have reverted");
768     }
769 }
770 
771 
772 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v2.5.1
773 
774 pragma solidity ^0.5.0;
775 
776 
777 
778 /**
779  * @title SafeERC20
780  * @dev Wrappers around ERC20 operations that throw on failure (when the token
781  * contract returns false). Tokens that return no value (and instead revert or
782  * throw on failure) are also supported, non-reverting calls are assumed to be
783  * successful.
784  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
785  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
786  */
787 library SafeERC20 {
788     using SafeMath for uint256;
789     using Address for address;
790 
791     function safeTransfer(IERC20 token, address to, uint256 value) internal {
792         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
793     }
794 
795     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
796         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
797     }
798 
799     function safeApprove(IERC20 token, address spender, uint256 value) internal {
800         // safeApprove should only be called when setting an initial allowance,
801         // or when resetting it to zero. To increase and decrease it, use
802         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
803         // solhint-disable-next-line max-line-length
804         require((value == 0) || (token.allowance(address(this), spender) == 0),
805             "SafeERC20: approve from non-zero to non-zero allowance"
806         );
807         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
808     }
809 
810     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
811         uint256 newAllowance = token.allowance(address(this), spender).add(value);
812         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
813     }
814 
815     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
816         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
817         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
818     }
819 
820     /**
821      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
822      * on the return value: the return value is optional (but if data is returned, it must not be false).
823      * @param token The token targeted by the call.
824      * @param data The call data (encoded using abi.encode or one of its variants).
825      */
826     function callOptionalReturn(IERC20 token, bytes memory data) private {
827         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
828         // we're implementing it ourselves.
829 
830         // A Solidity high level call has three parts:
831         //  1. The target address is checked to verify it contains contract code
832         //  2. The call itself is made, and success asserted
833         //  3. The return value is decoded, which in turn checks the size of the returned data.
834         // solhint-disable-next-line max-line-length
835         require(address(token).isContract(), "SafeERC20: call to non-contract");
836 
837         // solhint-disable-next-line avoid-low-level-calls
838         (bool success, bytes memory returndata) = address(token).call(data);
839         require(success, "SafeERC20: low-level call failed");
840 
841         if (returndata.length > 0) { // Return data is optional
842             // solhint-disable-next-line max-line-length
843             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
844         }
845     }
846 }
847 
848 
849 // File @openzeppelin/contracts/math/Math.sol@v2.5.1
850 
851 pragma solidity ^0.5.0;
852 
853 /**
854  * @dev Standard math utilities missing in the Solidity language.
855  */
856 library Math {
857     /**
858      * @dev Returns the largest of two numbers.
859      */
860     function max(uint256 a, uint256 b) internal pure returns (uint256) {
861         return a >= b ? a : b;
862     }
863 
864     /**
865      * @dev Returns the smallest of two numbers.
866      */
867     function min(uint256 a, uint256 b) internal pure returns (uint256) {
868         return a < b ? a : b;
869     }
870 
871     /**
872      * @dev Returns the average of two numbers. The result is rounded towards
873      * zero.
874      */
875     function average(uint256 a, uint256 b) internal pure returns (uint256) {
876         // (a + b) / 2 can overflow, so we distribute
877         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
878     }
879 }
880 
881 
882 // File @openzeppelin/contracts/ownership/Ownable.sol@v2.5.1
883 
884 pragma solidity ^0.5.0;
885 
886 /**
887  * @dev Contract module which provides a basic access control mechanism, where
888  * there is an account (an owner) that can be granted exclusive access to
889  * specific functions.
890  *
891  * This module is used through inheritance. It will make available the modifier
892  * `onlyOwner`, which can be applied to your functions to restrict their use to
893  * the owner.
894  */
895 contract Ownable is Context {
896     address private _owner;
897 
898     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
899 
900     /**
901      * @dev Initializes the contract setting the deployer as the initial owner.
902      */
903     constructor () internal {
904         address msgSender = _msgSender();
905         _owner = msgSender;
906         emit OwnershipTransferred(address(0), msgSender);
907     }
908 
909     /**
910      * @dev Returns the address of the current owner.
911      */
912     function owner() public view returns (address) {
913         return _owner;
914     }
915 
916     /**
917      * @dev Throws if called by any account other than the owner.
918      */
919     modifier onlyOwner() {
920         require(isOwner(), "Ownable: caller is not the owner");
921         _;
922     }
923 
924     /**
925      * @dev Returns true if the caller is the current owner.
926      */
927     function isOwner() public view returns (bool) {
928         return _msgSender() == _owner;
929     }
930 
931     /**
932      * @dev Leaves the contract without owner. It will not be possible to call
933      * `onlyOwner` functions anymore. Can only be called by the current owner.
934      *
935      * NOTE: Renouncing ownership will leave the contract without an owner,
936      * thereby removing any functionality that is only available to the owner.
937      */
938     function renounceOwnership() public onlyOwner {
939         emit OwnershipTransferred(_owner, address(0));
940         _owner = address(0);
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public onlyOwner {
948         _transferOwnership(newOwner);
949     }
950 
951     /**
952      * @dev Transfers ownership of the contract to a new account (`newOwner`).
953      */
954     function _transferOwnership(address newOwner) internal {
955         require(newOwner != address(0), "Ownable: new owner is the zero address");
956         emit OwnershipTransferred(_owner, newOwner);
957         _owner = newOwner;
958     }
959 }
960 
961 
962 // File contracts/base/PotPool.sol
963 
964 pragma solidity 0.5.16;
965 
966 
967 
968 
969 
970 
971 
972 
973 
974 
975 
976 contract IRewardDistributionRecipient is Ownable {
977 
978     mapping (address => bool) public rewardDistribution;
979 
980     constructor(address[] memory _rewardDistributions) public {
981         // NotifyHelper
982         rewardDistribution[0xE20c31e3d08027F5AfACe84A3A46B7b3B165053c] = true;
983 
984         // FeeRewardForwarderV6
985         rewardDistribution[0x153C544f72329c1ba521DDf5086cf2fA98C86676] = true;
986 
987         // Community Multisig
988         rewardDistribution[0xF49440C1F012d041802b25A73e5B0B9166a75c02] = true;
989 
990         for(uint256 i = 0; i < _rewardDistributions.length; i++) {
991           rewardDistribution[_rewardDistributions[i]] = true;
992         }
993     }
994 
995     function notifyTargetRewardAmount(address rewardToken, uint256 reward) external;
996     function notifyRewardAmount(uint256 reward) external;
997 
998     modifier onlyRewardDistribution() {
999         require(rewardDistribution[_msgSender()], "Caller is not reward distribution");
1000         _;
1001     }
1002 
1003     function setRewardDistribution(address[] calldata _newRewardDistribution, bool _flag)
1004         external
1005         onlyOwner
1006     {
1007         for(uint256 i = 0; i < _newRewardDistribution.length; i++){
1008           rewardDistribution[_newRewardDistribution[i]] = _flag;
1009         }
1010     }
1011 }
1012 
1013 contract PotPool is IRewardDistributionRecipient, Controllable, ERC20, ERC20Detailed {
1014 
1015     using Address for address;
1016     using SafeERC20 for IERC20;
1017     using SafeMath for uint256;
1018 
1019     address public lpToken;
1020     uint256 public duration; // making it not a constant is less gas efficient, but portable
1021 
1022     bool public greyListEnabled = false; // if greylisted at the controller, then cannot deposit anyway
1023 
1024     mapping(address => uint256) public stakedBalanceOf;
1025 
1026     mapping (address => bool) smartContractStakers;
1027     address[] public rewardTokens;
1028     mapping(address => uint256) public periodFinishForToken;
1029     mapping(address => uint256) public rewardRateForToken;
1030     mapping(address => uint256) public lastUpdateTimeForToken;
1031     mapping(address => uint256) public rewardPerTokenStoredForToken;
1032     mapping(address => mapping(address => uint256)) public userRewardPerTokenPaidForToken;
1033     mapping(address => mapping(address => uint256)) public rewardsForToken;
1034 
1035     event RewardAdded(address rewardToken, uint256 reward);
1036     event Staked(address indexed user, uint256 amount);
1037     event Withdrawn(address indexed user, uint256 amount);
1038     event RewardPaid(address indexed user, address rewardToken, uint256 reward);
1039     event RewardDenied(address indexed user, address rewardToken, uint256 reward);
1040     event SmartContractRecorded(address indexed smartContractAddress, address indexed smartContractInitiator);
1041 
1042     modifier onlyGovernanceOrRewardDistribution() {
1043       require(msg.sender == governance() || rewardDistribution[msg.sender], "Not governance nor reward distribution");
1044       _;
1045     }
1046 
1047     modifier updateRewards(address account) {
1048       for(uint256 i = 0; i < rewardTokens.length; i++ ){
1049         address rt = rewardTokens[i];
1050         rewardPerTokenStoredForToken[rt] = rewardPerToken(rt);
1051         lastUpdateTimeForToken[rt] = lastTimeRewardApplicable(rt);
1052         if (account != address(0)) {
1053             rewardsForToken[rt][account] = earned(rt, account);
1054             userRewardPerTokenPaidForToken[rt][account] = rewardPerTokenStoredForToken[rt];
1055         }
1056       }
1057       _;
1058     }
1059 
1060     modifier updateReward(address account, address rt){
1061       rewardPerTokenStoredForToken[rt] = rewardPerToken(rt);
1062       lastUpdateTimeForToken[rt] = lastTimeRewardApplicable(rt);
1063       if (account != address(0)) {
1064           rewardsForToken[rt][account] = earned(rt, account);
1065           userRewardPerTokenPaidForToken[rt][account] = rewardPerTokenStoredForToken[rt];
1066       }
1067       _;
1068     }
1069 
1070     /** View functions to respect old interface */
1071     function rewardToken() public view returns(address) {
1072       return rewardTokens[0];
1073     }
1074 
1075     function rewardPerToken() public view returns(uint256) {
1076       return rewardPerToken(rewardTokens[0]);
1077     }
1078 
1079     function periodFinish() public view returns(uint256) {
1080       return periodFinishForToken[rewardTokens[0]];
1081     }
1082 
1083     function rewardRate() public view returns(uint256) {
1084       return rewardRateForToken[rewardTokens[0]];
1085     }
1086 
1087     function lastUpdateTime() public view returns(uint256) {
1088       return lastUpdateTimeForToken[rewardTokens[0]];
1089     }
1090 
1091     function rewardPerTokenStored() public view returns(uint256) {
1092       return rewardPerTokenStoredForToken[rewardTokens[0]];
1093     }
1094 
1095     function userRewardPerTokenPaid(address user) public view returns(uint256) {
1096       return userRewardPerTokenPaidForToken[rewardTokens[0]][user];
1097     }
1098 
1099     function rewards(address user) public view returns(uint256) {
1100       return rewardsForToken[rewardTokens[0]][user];
1101     }
1102 
1103     // [Hardwork] setting the reward, lpToken, duration, and rewardDistribution for each pool
1104     constructor(
1105         address[] memory _rewardTokens,
1106         address _lpToken,
1107         uint256 _duration,
1108         address[] memory _rewardDistribution,
1109         address _storage,
1110         string memory _name,
1111         string memory _symbol,
1112         uint8 _decimals
1113       ) public
1114       ERC20Detailed(_name, _symbol, _decimals)
1115       IRewardDistributionRecipient(_rewardDistribution)
1116       Controllable(_storage) // only used for referencing the grey list
1117     {
1118         require(_decimals == ERC20Detailed(_lpToken).decimals(), "decimals has to be aligned with the lpToken");
1119         require(_rewardTokens.length != 0, "should initialize with at least 1 rewardToken");
1120         rewardTokens = _rewardTokens;
1121         lpToken = _lpToken;
1122         duration = _duration;
1123     }
1124 
1125     function lastTimeRewardApplicable(uint256 i) public view returns (uint256) {
1126         return lastTimeRewardApplicable(rewardTokens[i]);
1127     }
1128 
1129     function lastTimeRewardApplicable(address rt) public view returns (uint256) {
1130         return Math.min(block.timestamp, periodFinishForToken[rt]);
1131     }
1132 
1133     function lastTimeRewardApplicable() public view returns (uint256) {
1134         return lastTimeRewardApplicable(rewardTokens[0]);
1135     }
1136 
1137     function rewardPerToken(uint256 i) public view returns (uint256) {
1138         return rewardPerToken(rewardTokens[i]);
1139     }
1140 
1141     function rewardPerToken(address rt) public view returns (uint256) {
1142         if (totalSupply() == 0) {
1143             return rewardPerTokenStoredForToken[rt];
1144         }
1145         return
1146             rewardPerTokenStoredForToken[rt].add(
1147                 lastTimeRewardApplicable(rt)
1148                     .sub(lastUpdateTimeForToken[rt])
1149                     .mul(rewardRateForToken[rt])
1150                     .mul(1e18)
1151                     .div(totalSupply())
1152             );
1153     }
1154 
1155     function earned(uint256 i, address account) public view returns (uint256) {
1156         return earned(rewardTokens[i], account);
1157     }
1158 
1159     function earned(address account) public view returns (uint256) {
1160         return earned(rewardTokens[0], account);
1161     }
1162 
1163     function earned(address rt, address account) public view returns (uint256) {
1164         return
1165             stakedBalanceOf[account]
1166                 .mul(rewardPerToken(rt).sub(userRewardPerTokenPaidForToken[rt][account]))
1167                 .div(1e18)
1168                 .add(rewardsForToken[rt][account]);
1169     }
1170 
1171     function stake(uint256 amount) public updateRewards(msg.sender) {
1172         require(amount > 0, "Cannot stake 0");
1173         recordSmartContract();
1174         super._mint(msg.sender, amount); // ERC20 is used as a staking receipt
1175         stakedBalanceOf[msg.sender] = stakedBalanceOf[msg.sender].add(amount);
1176         IERC20(lpToken).safeTransferFrom(msg.sender, address(this), amount);
1177         emit Staked(msg.sender, amount);
1178     }
1179 
1180     function withdraw(uint256 amount) public updateRewards(msg.sender) {
1181         require(amount > 0, "Cannot withdraw 0");
1182         super._burn(msg.sender, amount);
1183         stakedBalanceOf[msg.sender] = stakedBalanceOf[msg.sender].sub(amount);
1184         IERC20(lpToken).safeTransfer(msg.sender, amount);
1185         emit Withdrawn(msg.sender, amount);
1186     }
1187 
1188     function exit() external {
1189         withdraw(Math.min(stakedBalanceOf[msg.sender], balanceOf(msg.sender)));
1190         getAllRewards();
1191     }
1192 
1193     /// A push mechanism for accounts that have not claimed their rewards for a long time.
1194     /// The implementation is semantically analogous to getReward(), but uses a push pattern
1195     /// instead of pull pattern.
1196     function pushAllRewards(address recipient) public updateRewards(recipient) onlyGovernance {
1197       bool rewardPayout = !(smartContractStakers[recipient] && greyListEnabled && IController(controller()).greyList(recipient));
1198       for(uint256 i = 0 ; i < rewardTokens.length; i++ ){
1199         uint256 reward = earned(rewardTokens[i], recipient);
1200         if (reward > 0) {
1201             rewardsForToken[rewardTokens[i]][recipient] = 0;
1202             // If it is a normal user and not smart contract,
1203             // then the requirement will pass
1204             // If it is a smart contract, then
1205             // make sure that it is not on our greyList.
1206             if (rewardPayout) {
1207                 IERC20(rewardTokens[i]).safeTransfer(recipient, reward);
1208                 emit RewardPaid(recipient, rewardTokens[i], reward);
1209             } else {
1210                 emit RewardDenied(recipient, rewardTokens[i], reward);
1211             }
1212         }
1213       }
1214     }
1215 
1216     function getAllRewards() public updateRewards(msg.sender) {
1217       recordSmartContract();
1218       bool rewardPayout = !(smartContractStakers[msg.sender] && greyListEnabled && IController(controller()).greyList(msg.sender));
1219       for(uint256 i = 0 ; i < rewardTokens.length; i++ ){
1220         _getRewardAction(rewardTokens[i], rewardPayout);
1221       }
1222     }
1223 
1224     function getReward(address rt) public updateReward(msg.sender, rt) {
1225       recordSmartContract();
1226       _getRewardAction(
1227         rt,
1228         // don't payout if it is a grey listed smart contract
1229         !(smartContractStakers[msg.sender] && greyListEnabled && IController(controller()).greyList(msg.sender))
1230       );
1231     }
1232 
1233     function getReward() public {
1234       getReward(rewardTokens[0]);
1235     }
1236 
1237     function _getRewardAction(address rt, bool rewardPayout) internal {
1238       uint256 reward = earned(rt, msg.sender);
1239       if (reward > 0 && IERC20(rt).balanceOf(address(this)) >= reward ) {
1240           rewardsForToken[rt][msg.sender] = 0;
1241           // If it is a normal user and not smart contract,
1242           // then the requirement will pass
1243           // If it is a smart contract, then
1244           // make sure that it is not on our greyList.
1245           if (rewardPayout) {
1246               IERC20(rt).safeTransfer(msg.sender, reward);
1247               emit RewardPaid(msg.sender, rt, reward);
1248           } else {
1249               emit RewardDenied(msg.sender, rt, reward);
1250           }
1251       }
1252     }
1253 
1254     function setGreyListEnabled(bool _value) public onlyGovernance {
1255       greyListEnabled = _value;
1256     }
1257 
1258     function addRewardToken(address rt) public onlyGovernanceOrRewardDistribution {
1259       require(getRewardTokenIndex(rt) == uint256(-1), "Reward token already exists");
1260       rewardTokens.push(rt);
1261     }
1262 
1263     function removeRewardToken(address rt) public onlyGovernance {
1264       uint256 i = getRewardTokenIndex(rt);
1265       require(i != uint256(-1), "Reward token does not exists");
1266       require(periodFinishForToken[rewardTokens[i]] < block.timestamp, "Can only remove when the reward period has passed");
1267       require(rewardTokens.length > 1, "Cannot remove the last reward token");
1268       uint256 lastIndex = rewardTokens.length - 1;
1269 
1270       // swap
1271       rewardTokens[i] = rewardTokens[lastIndex];
1272 
1273       // delete last element
1274       rewardTokens.length--;
1275     }
1276 
1277     // If the return value is MAX_UINT256, it means that
1278     // the specified reward token is not in the list
1279     function getRewardTokenIndex(address rt) public view returns(uint256) {
1280       for(uint i = 0 ; i < rewardTokens.length ; i++){
1281         if(rewardTokens[i] == rt)
1282           return i;
1283       }
1284       return uint256(-1);
1285     }
1286 
1287     function notifyTargetRewardAmount(address _rewardToken, uint256 reward)
1288         public
1289         onlyRewardDistribution
1290         updateRewards(address(0))
1291     {
1292         // overflow fix according to https://sips.synthetix.io/sips/sip-77
1293         require(reward < uint(-1) / 1e18, "the notified reward cannot invoke multiplication overflow");
1294 
1295         uint256 i = getRewardTokenIndex(_rewardToken);
1296         require(i != uint256(-1), "rewardTokenIndex not found");
1297 
1298         if (block.timestamp >= periodFinishForToken[_rewardToken]) {
1299             rewardRateForToken[_rewardToken] = reward.div(duration);
1300         } else {
1301             uint256 remaining = periodFinishForToken[_rewardToken].sub(block.timestamp);
1302             uint256 leftover = remaining.mul(rewardRateForToken[_rewardToken]);
1303             rewardRateForToken[_rewardToken] = reward.add(leftover).div(duration);
1304         }
1305         lastUpdateTimeForToken[_rewardToken] = block.timestamp;
1306         periodFinishForToken[_rewardToken] = block.timestamp.add(duration);
1307         emit RewardAdded(_rewardToken, reward);
1308     }
1309 
1310     function notifyRewardAmount(uint256 reward)
1311         external
1312         onlyRewardDistribution
1313         updateRewards(address(0))
1314     {
1315       notifyTargetRewardAmount(rewardTokens[0], reward);
1316     }
1317 
1318     function rewardTokensLength() public view returns(uint256){
1319       return rewardTokens.length;
1320     }
1321 
1322     // Harvest Smart Contract recording
1323     function recordSmartContract() internal {
1324       if( tx.origin != msg.sender ) {
1325         smartContractStakers[msg.sender] = true;
1326         emit SmartContractRecorded(msg.sender, tx.origin);
1327       }
1328     }
1329 
1330 }
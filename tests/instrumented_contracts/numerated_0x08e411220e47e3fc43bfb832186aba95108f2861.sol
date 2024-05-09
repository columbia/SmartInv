1 // File: node_modules\openzeppelin-solidity\contracts\GSN\Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 /**
507  * @dev Optional functions from the ERC20 standard.
508  */
509 contract ERC20Detailed is IERC20 {
510     string private _name;
511     string private _symbol;
512     uint8 private _decimals;
513 
514     /**
515      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
516      * these values are immutable: they can only be set once during
517      * construction.
518      */
519     constructor (string memory name, string memory symbol, uint8 decimals) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = decimals;
523     }
524 
525     /**
526      * @dev Returns the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev Returns the symbol of the token, usually a shorter version of the
534      * name.
535      */
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev Returns the number of decimals used to get its user representation.
542      * For example, if `decimals` equals `2`, a balance of `505` tokens should
543      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
544      *
545      * Tokens usually opt for a value of 18, imitating the relationship between
546      * Ether and Wei.
547      *
548      * NOTE: This information is only used for _display_ purposes: it in
549      * no way affects any of the arithmetic of the contract, including
550      * {IERC20-balanceOf} and {IERC20-transfer}.
551      */
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 }
556 
557 // File: node_modules\openzeppelin-solidity\contracts\utils\ReentrancyGuard.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @dev Contract module that helps prevent reentrant calls to a function.
563  *
564  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
565  * available, which can be applied to functions to make sure there are no nested
566  * (reentrant) calls to them.
567  *
568  * Note that because there is a single `nonReentrant` guard, functions marked as
569  * `nonReentrant` may not call one another. This can be worked around by making
570  * those functions `private`, and then adding `external` `nonReentrant` entry
571  * points to them.
572  *
573  * TIP: If you would like to learn more about reentrancy and alternative ways
574  * to protect against it, check out our blog post
575  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
576  *
577  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
578  * metering changes introduced in the Istanbul hardfork.
579  */
580 contract ReentrancyGuard {
581     bool private _notEntered;
582 
583     constructor () internal {
584         // Storing an initial non-zero value makes deployment a bit more
585         // expensive, but in exchange the refund on every call to nonReentrant
586         // will be lower in amount. Since refunds are capped to a percetange of
587         // the total transaction's gas, it is best to keep them low in cases
588         // like this one, to increase the likelihood of the full refund coming
589         // into effect.
590         _notEntered = true;
591     }
592 
593     /**
594      * @dev Prevents a contract from calling itself, directly or indirectly.
595      * Calling a `nonReentrant` function from another `nonReentrant`
596      * function is not supported. It is possible to prevent this from happening
597      * by making the `nonReentrant` function external, and make it call a
598      * `private` function that does the actual work.
599      */
600     modifier nonReentrant() {
601         // On the first call to nonReentrant, _notEntered will be true
602         require(_notEntered, "ReentrancyGuard: reentrant call");
603 
604         // Any calls to nonReentrant after this point will fail
605         _notEntered = false;
606 
607         _;
608 
609         // By storing the original value once again, a refund is triggered (see
610         // https://eips.ethereum.org/EIPS/eip-2200)
611         _notEntered = true;
612     }
613 }
614 
615 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
616 
617 pragma solidity ^0.5.5;
618 
619 /**
620  * @dev Collection of functions related to the address type
621  */
622 library Address {
623     /**
624      * @dev Returns true if `account` is a contract.
625      *
626      * [IMPORTANT]
627      * ====
628      * It is unsafe to assume that an address for which this function returns
629      * false is an externally-owned account (EOA) and not a contract.
630      *
631      * Among others, `isContract` will return false for the following
632      * types of addresses:
633      *
634      *  - an externally-owned account
635      *  - a contract in construction
636      *  - an address where a contract will be created
637      *  - an address where a contract lived, but was destroyed
638      * ====
639      */
640     function isContract(address account) internal view returns (bool) {
641         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
642         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
643         // for accounts without code, i.e. `keccak256('')`
644         bytes32 codehash;
645         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
646         // solhint-disable-next-line no-inline-assembly
647         assembly { codehash := extcodehash(account) }
648         return (codehash != accountHash && codehash != 0x0);
649     }
650 
651     /**
652      * @dev Converts an `address` into `address payable`. Note that this is
653      * simply a type cast: the actual underlying value is not changed.
654      *
655      * _Available since v2.4.0._
656      */
657     function toPayable(address account) internal pure returns (address payable) {
658         return address(uint160(account));
659     }
660 
661     /**
662      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
663      * `recipient`, forwarding all available gas and reverting on errors.
664      *
665      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
666      * of certain opcodes, possibly making contracts go over the 2300 gas limit
667      * imposed by `transfer`, making them unable to receive funds via
668      * `transfer`. {sendValue} removes this limitation.
669      *
670      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
671      *
672      * IMPORTANT: because control is transferred to `recipient`, care must be
673      * taken to not create reentrancy vulnerabilities. Consider using
674      * {ReentrancyGuard} or the
675      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
676      *
677      * _Available since v2.4.0._
678      */
679     function sendValue(address payable recipient, uint256 amount) internal {
680         require(address(this).balance >= amount, "Address: insufficient balance");
681 
682         // solhint-disable-next-line avoid-call-value
683         (bool success, ) = recipient.call.value(amount)("");
684         require(success, "Address: unable to send value, recipient may have reverted");
685     }
686 }
687 
688 // File: contracts\Eclipseum.sol
689 
690 pragma solidity =0.5.17;
691 
692 /// @title The Eclipseum ERC20 Smart Contract
693 contract Eclipseum is ERC20, ERC20Detailed, ReentrancyGuard {
694     using SafeMath for uint256;
695     using Address for address payable;
696 
697     struct SoftSellEclAmountsToReceive {
698         uint256 ethFromEclPool;
699         uint256 ethFromDaiPool;
700         uint256 daiFromDaiPool;
701     }
702 
703     IERC20 public daiInterface;
704     bool public launched;
705     uint256 public ethBalanceOfEclPool;
706     uint256 public ethVolumeOfEclPool;
707     uint256 public ethVolumeOfDaiPool;
708 
709     event LogBuyEcl(
710         address indexed userAddress,
711         uint256 ethSpent,
712         uint256 eclReceived
713     );
714     event LogSellEcl(
715         address indexed userAddress,
716         uint256 eclSold,
717         uint256 ethReceived
718     );
719     event LogSoftSellEcl(
720         address indexed userAddress,
721         uint256 eclSold,
722         uint256 ethReceived,
723         uint256 daiReceived
724     );
725     event LogBuyDai(
726         address indexed userAddress,
727         uint256 ethSpent,
728         uint256 daiReceived
729     );
730     event LogSellDai(
731         address indexed userAddress,
732         uint256 daiSold,
733         uint256 ethReceived
734     );
735 
736     modifier requireLaunched() {
737         require(launched, "Contract must be launched to invoke this function.");
738         _;
739     }
740 
741     /// @notice Must be called with at least 0.02 ETH.
742     /// @notice Mints 100,000 ECL into the contract account
743     constructor(address _daiAddress)
744         public
745         payable
746         ERC20Detailed("Eclipseum", "ECL", 18)
747     {
748         require(
749             msg.value >= 0.02 ether,
750             "Must call constructor with at least 0.02 Ether."
751         );
752 
753         _mint(address(this), 1e5 * (10**18));
754         daiInterface = IERC20(_daiAddress);
755     }
756 
757     /// @notice This function is called once after deployment to launch the contract.
758     /// @notice Some amount of DAI must be transferred to the contract for launch to succeed.
759     /// @notice Once launched, the transaction functions may be invoked.
760     function launch() external {
761         require(!launched, "Contract has already been launched.");
762         require(
763             daiInterface.balanceOf(address(this)) > 0,
764             "DAI pool balance must be greater than zero to launch contract."
765         );
766 
767         ethBalanceOfEclPool = 0.01 ether;
768         launched = true;
769     }
770 
771     /// @notice Enables a user to buy ECL with ETH from the ECL liquidity pool.
772     /// @param minEclToReceive The minimum amount of ECL the user is willing to receive.
773     /// @param deadline Epoch time deadline that the transaction must complete before, otherwise reverts.
774     function buyEcl(uint256 minEclToReceive, uint256 deadline)
775         external
776         payable
777         nonReentrant
778         requireLaunched
779     {
780         require(
781             deadline >= block.timestamp,
782             "Transaction deadline has elapsed."
783         );
784         require(msg.value > 0, "Value of ETH sent must be greater than zero.");
785 
786         uint256 ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPool().sub(msg.value);
787         uint256 eclBalanceOfEclPoolLocal = eclBalanceOfEclPool();
788         uint256 eclToReceive = applyTransactionFee(
789             calcBOut(ethBalanceOfEclPool, eclBalanceOfEclPoolLocal, msg.value)
790         );
791         uint256 eclToMint = eclToReceive.mul(7).div(6).add(1);
792         uint256 ethTransferToDaiPool = calcEthTransferForBuyEcl(
793             ethBalanceOfEclPool,
794             ethBalanceOfDaiPoolLocal,
795             msg.value
796         );
797 
798         require(
799             eclToReceive >= minEclToReceive,
800             "Unable to send the minimum quantity of ECL to receive."
801         );
802 
803         ethBalanceOfEclPool = ethBalanceOfEclPool.add(msg.value).sub(
804             ethTransferToDaiPool
805         );
806         ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPoolLocal.add(
807             ethTransferToDaiPool
808         );
809         eclBalanceOfEclPoolLocal = eclBalanceOfEclPoolLocal
810             .sub(eclToReceive)
811             .add(eclToMint);
812         ethVolumeOfEclPool += msg.value;
813 
814         emit LogBuyEcl(msg.sender, msg.value, eclToReceive);
815 
816         _transfer(address(this), msg.sender, eclToReceive);
817         _mint(address(this), eclToMint);
818 
819         assert(ethBalanceOfDaiPoolLocal == ethBalanceOfDaiPool());
820         assert(eclBalanceOfEclPoolLocal == eclBalanceOfEclPool());
821         assert(ethBalanceOfEclPool > 0);
822         assert(ethBalanceOfDaiPool() > 0);
823         assert(eclBalanceOfEclPool() > 0);
824         assert(daiBalanceOfDaiPool() > 0);
825     }
826 
827     /// @notice Enables a user to sell ECL for ETH to the ECL liquidity pool.
828     /// @param eclSold The amount of ECL the user is selling.
829     /// @param minEthToReceive The minimum amount of ETH the user is willing to receive.
830     /// @param deadline Epoch time deadline that the transaction must complete before.
831     function sellEcl(
832         uint256 eclSold,
833         uint256 minEthToReceive,
834         uint256 deadline
835     ) external nonReentrant requireLaunched {
836         require(
837             deadline >= block.timestamp,
838             "Transaction deadline has elapsed."
839         );
840         require(eclSold > 0, "Value of ECL sold must be greater than zero.");
841         require(
842             eclSold <= balanceOf(address(msg.sender)),
843             "ECL sold must be less than or equal to ECL balance."
844         );
845 
846         uint256 ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPool();
847         uint256 eclBalanceOfEclPoolLocal = eclBalanceOfEclPool();
848         uint256 eclToBurn = eclSold.mul(7).div(6);
849         uint256 ethToReceive = applyTransactionFee(
850             calcBOut(eclBalanceOfEclPoolLocal, ethBalanceOfEclPool, eclSold)
851         );
852 
853         require(
854             ethToReceive >= minEthToReceive,
855             "Unable to send the minimum quantity of ETH to receive."
856         );
857 
858         ethBalanceOfEclPool = ethBalanceOfEclPool.sub(ethToReceive);
859         eclBalanceOfEclPoolLocal = eclBalanceOfEclPoolLocal.add(eclSold).sub(
860             eclToBurn
861         );
862         ethVolumeOfEclPool += ethToReceive;
863 
864         emit LogSellEcl(msg.sender, eclSold, ethToReceive);
865 
866         _transfer(address(msg.sender), address(this), eclSold);
867         _burn(address(this), eclToBurn);
868         msg.sender.sendValue(ethToReceive);
869 
870         assert(ethBalanceOfDaiPoolLocal == ethBalanceOfDaiPool());
871         assert(eclBalanceOfEclPoolLocal == eclBalanceOfEclPool());
872         assert(ethBalanceOfEclPool > 0);
873         assert(ethBalanceOfDaiPool() > 0);
874         assert(eclBalanceOfEclPool() > 0);
875         assert(daiBalanceOfDaiPool() > 0);
876     }
877 
878     /// @notice Enables a user to sell ECL for ETH and DAI to the ECL liquidity pool.
879     /// @param eclSold The amount of ECL the user is selling.
880     /// @param minEthToReceive The minimum amount of ETH the user is willing to receive.
881     /// @param minDaiToReceive The minimum amount of DAI the user is willing to receive.
882     /// @param deadline Epoch time deadline that the transaction must complete before.
883     function softSellEcl(
884         uint256 eclSold,
885         uint256 minEthToReceive,
886         uint256 minDaiToReceive,
887         uint256 deadline
888     ) external nonReentrant requireLaunched {
889         require(
890             deadline >= block.timestamp,
891             "Transaction deadline has elapsed."
892         );
893         require(eclSold > 0, "Value of ECL sold must be greater than zero.");
894         require(
895             eclSold <= balanceOf(address(msg.sender)),
896             "ECL sold must be less than or equal to ECL balance."
897         );
898 
899         uint256 ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPool();
900         uint256 circulatingSupplyLocal = circulatingSupply();
901         uint256 eclBalanceOfEclPoolLocal = eclBalanceOfEclPool();
902         uint256 daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPool();
903         uint256 eclToBurn = applyTransactionFee(
904             eclSold.mul(eclBalanceOfEclPoolLocal).div(circulatingSupplyLocal)
905         )
906             .add(eclSold);
907         SoftSellEclAmountsToReceive memory amountsToReceive;
908         amountsToReceive.ethFromEclPool = applyTransactionFee(
909             eclSold.mul(ethBalanceOfEclPool).div(circulatingSupplyLocal)
910         );
911         amountsToReceive.ethFromDaiPool = applyTransactionFee(
912             eclSold.mul(ethBalanceOfDaiPoolLocal).div(circulatingSupplyLocal)
913         );
914         amountsToReceive.daiFromDaiPool = applyTransactionFee(
915             eclSold.mul(daiBalanceOfDaiPoolLocal).div(circulatingSupplyLocal)
916         );
917 
918         require(
919             amountsToReceive.ethFromEclPool.add(
920                 amountsToReceive.ethFromDaiPool
921             ) >= minEthToReceive,
922             "Unable to send the minimum quantity of ETH to receive."
923         );
924         require(
925             amountsToReceive.daiFromDaiPool >= minDaiToReceive,
926             "Unable to send the minimum quantity of DAI to receive."
927         );
928 
929         ethBalanceOfEclPool = ethBalanceOfEclPool.sub(
930             amountsToReceive.ethFromEclPool
931         );
932         ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPoolLocal.sub(
933             amountsToReceive.ethFromDaiPool
934         );
935         daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPoolLocal.sub(
936             amountsToReceive.daiFromDaiPool
937         );
938         eclBalanceOfEclPoolLocal = eclBalanceOfEclPoolLocal.add(eclSold).sub(
939             eclToBurn
940         );
941         ethVolumeOfEclPool += amountsToReceive.ethFromEclPool;
942         ethVolumeOfDaiPool += amountsToReceive.ethFromDaiPool;
943 
944         emit LogSoftSellEcl(
945             msg.sender,
946             eclSold,
947             amountsToReceive.ethFromEclPool.add(
948                 amountsToReceive.ethFromDaiPool
949             ),
950             amountsToReceive.daiFromDaiPool
951         );
952 
953         _transfer(address(msg.sender), address(this), eclSold);
954         _burn(address(this), eclToBurn);
955         require(
956             daiInterface.transfer(msg.sender, amountsToReceive.daiFromDaiPool),
957             "DAI Transfer failed."
958         );
959         msg.sender.sendValue(
960             amountsToReceive.ethFromEclPool.add(amountsToReceive.ethFromDaiPool)
961         );
962 
963         assert(
964             ethBalanceOfEclPool.add(ethBalanceOfDaiPoolLocal) ==
965                 address(this).balance
966         );
967         assert(eclBalanceOfEclPoolLocal == eclBalanceOfEclPool());
968         assert(daiBalanceOfDaiPoolLocal == daiBalanceOfDaiPool());
969         assert(ethBalanceOfDaiPoolLocal == ethBalanceOfDaiPool());
970         assert(ethBalanceOfEclPool > 0);
971         assert(ethBalanceOfDaiPool() > 0);
972         assert(eclBalanceOfEclPool() > 0);
973         assert(daiBalanceOfDaiPool() > 0);
974     }
975 
976     /// @notice Enables a user to buy DAI with ETH from the DAI liquidity pool.
977     /// @param minDaiToReceive The minimum amount of DAI the user is willing to receive.
978     /// @param deadline Epoch time deadline that the transaction must complete before.
979     function buyDai(uint256 minDaiToReceive, uint256 deadline)
980         external
981         payable
982         nonReentrant
983         requireLaunched
984     {
985         require(
986             deadline >= block.timestamp,
987             "Transaction deadline has elapsed."
988         );
989         require(msg.value > 0, "Value of ETH sent must be greater than zero.");
990 
991         uint256 ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPool().sub(msg.value);
992         uint256 daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPool();
993         uint256 daiToReceive = applyTransactionFee(
994             calcBOut(
995                 ethBalanceOfDaiPoolLocal,
996                 daiBalanceOfDaiPoolLocal,
997                 msg.value
998             )
999         );
1000         uint256 ethTransferToEclPool = msg.value.mul(15).div(10000);
1001 
1002         require(
1003             daiToReceive >= minDaiToReceive,
1004             "Unable to send the minimum quantity of DAI to receive."
1005         );
1006 
1007         ethBalanceOfEclPool = ethBalanceOfEclPool.add(ethTransferToEclPool);
1008         ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPoolLocal.add(msg.value).sub(
1009             ethTransferToEclPool
1010         );
1011         daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPoolLocal.sub(daiToReceive);
1012         ethVolumeOfDaiPool += msg.value;
1013 
1014         emit LogBuyDai(msg.sender, msg.value, daiToReceive);
1015 
1016         require(
1017             daiInterface.transfer(address(msg.sender), daiToReceive),
1018             "DAI Transfer failed."
1019         );
1020 
1021         assert(ethBalanceOfDaiPoolLocal == ethBalanceOfDaiPool());
1022         assert(daiBalanceOfDaiPoolLocal == daiBalanceOfDaiPool());
1023         assert(ethBalanceOfEclPool > 0);
1024         assert(ethBalanceOfDaiPool() > 0);
1025         assert(eclBalanceOfEclPool() > 0);
1026         assert(daiBalanceOfDaiPool() > 0);
1027     }
1028 
1029     /// @notice Enables a user to sell DAI for ETH to the DAI liquidity pool.
1030     /// @param daiSold The amount of DAI the user is selling.
1031     /// @param minEthToReceive The minimum amount of ETH the user is willing to receive.
1032     /// @param deadline Epoch time deadline that the transaction must complete before.
1033     function sellDai(
1034         uint256 daiSold,
1035         uint256 minEthToReceive,
1036         uint256 deadline
1037     ) external nonReentrant requireLaunched {
1038         require(
1039             deadline >= block.timestamp,
1040             "Transaction deadline has elapsed."
1041         );
1042         require(daiSold > 0, "Value of DAI sold must be greater than zero.");
1043         require(
1044             daiSold <= daiInterface.balanceOf(address(msg.sender)),
1045             "DAI sold must be less than or equal to DAI balance."
1046         );
1047         require(
1048             daiSold <=
1049                 daiInterface.allowance(address(msg.sender), address(this)),
1050             "DAI sold exceeds allowance."
1051         );
1052 
1053         uint256 ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPool();
1054         uint256 daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPool();
1055         uint256 ethToReceiveBeforeFee = calcBOut(
1056             daiBalanceOfDaiPoolLocal,
1057             ethBalanceOfDaiPoolLocal,
1058             daiSold
1059         );
1060         uint256 ethToReceive = applyTransactionFee(ethToReceiveBeforeFee);
1061         uint256 ethTransferToEclPool = ethToReceiveBeforeFee
1062             .sub(ethToReceive)
1063             .div(2);
1064 
1065         require(
1066             ethToReceive >= minEthToReceive,
1067             "Unable to send the minimum quantity of ETH to receive."
1068         );
1069 
1070         ethBalanceOfEclPool = ethBalanceOfEclPool.add(ethTransferToEclPool);
1071         ethBalanceOfDaiPoolLocal = ethBalanceOfDaiPoolLocal
1072             .sub(ethToReceive)
1073             .sub(ethTransferToEclPool);
1074         daiBalanceOfDaiPoolLocal = daiBalanceOfDaiPoolLocal.add(daiSold);
1075         ethVolumeOfDaiPool += ethToReceive;
1076 
1077         emit LogSellDai(msg.sender, daiSold, ethToReceive);
1078 
1079         require(
1080             daiInterface.transferFrom(
1081                 address(msg.sender),
1082                 address(this),
1083                 daiSold
1084             ),
1085             "DAI Transfer failed."
1086         );
1087         msg.sender.sendValue(ethToReceive);
1088 
1089         assert(ethBalanceOfDaiPoolLocal == ethBalanceOfDaiPool());
1090         assert(daiBalanceOfDaiPoolLocal == daiBalanceOfDaiPool());
1091         assert(ethBalanceOfEclPool > 0);
1092         assert(ethBalanceOfDaiPool() > 0);
1093         assert(eclBalanceOfEclPool() > 0);
1094         assert(daiBalanceOfDaiPool() > 0);
1095     }
1096 
1097     /// @notice Calculates amount of asset B for user to receive using constant product market maker algorithm.
1098     /// @dev A value of one is subtracted in the _bToReceive calculation such that rounding
1099     /// @dev errors favour the pool over the user.
1100     /// @param aBalance The balance of asset A in the liquidity pool.
1101     /// @param bBalance The balance of asset B in the liquidity pool.
1102     /// @param aSent The quantity of asset A sent by the user to the liquidity pool.
1103     /// @return bToReceive The quantity of asset B the user would receive before transaction fee is applied.
1104     function calcBOut(
1105         uint256 aBalance,
1106         uint256 bBalance,
1107         uint256 aSent
1108     ) public pure returns (uint256) {
1109         uint256 denominator = aBalance.add(aSent);
1110         uint256 fraction = aBalance.mul(bBalance).div(denominator);
1111         uint256 bToReceive = bBalance.sub(fraction).sub(1);
1112 
1113         assert(bToReceive < bBalance);
1114 
1115         return bToReceive;
1116     }
1117 
1118     /// @notice Calculates the amount of ETH to transfer from the ECL pool to the DAI pool for the buyEcl function.
1119     /// @param ethBalanceOfEclPoolLocal The balance of ETH in the ECL liquidity pool.
1120     /// @param ethBalanceOfDaiPoolLocal The balance of ETH in the DAI liquidity pool.
1121     /// @param ethSent The quantity of ETH sent by the user in the buyEcl function.
1122     /// @return ethTransferToDaiPool The quantity of ETH to transfer from the ECL pool to the DAI pool.
1123     function calcEthTransferForBuyEcl(
1124         uint256 ethBalanceOfEclPoolLocal,
1125         uint256 ethBalanceOfDaiPoolLocal,
1126         uint256 ethSent
1127     ) public pure returns (uint256) {
1128         uint256 ethTransferToDaiPool;
1129 
1130         if (
1131             ethBalanceOfEclPoolLocal >=
1132             ethSent.mul(4).div(6).add(ethBalanceOfDaiPoolLocal)
1133         ) {
1134             ethTransferToDaiPool = ethSent.mul(5).div(6);
1135         } else if (
1136             ethSent.add(ethBalanceOfEclPoolLocal) <= ethBalanceOfDaiPoolLocal
1137         ) {
1138             ethTransferToDaiPool = 0;
1139         } else {
1140             ethTransferToDaiPool = ethSent
1141                 .add(ethBalanceOfEclPoolLocal)
1142                 .sub(ethBalanceOfDaiPoolLocal)
1143                 .div(2);
1144         }
1145 
1146         assert(ethTransferToDaiPool <= ethSent.mul(5).div(6));
1147 
1148         return ethTransferToDaiPool;
1149     }
1150 
1151     /// @notice Calculates the amount for the user to receive with a 0.3% transaction fee applied.
1152     /// @param amountBeforeFee The amount the user will receive before transaction fee is applied.
1153     /// @return amountAfterFee The amount the user will receive with transaction fee applied.
1154     function applyTransactionFee(uint256 amountBeforeFee)
1155         public
1156         pure
1157         returns (uint256)
1158     {
1159         uint256 amountAfterFee = amountBeforeFee.mul(997).div(1000);
1160         return amountAfterFee;
1161     }
1162 
1163     /// @notice Returns the ECL balance of the ECL pool.
1164     function eclBalanceOfEclPool()
1165         public
1166         view
1167         requireLaunched
1168         returns (uint256)
1169     {
1170         return balanceOf(address(this));
1171     }
1172 
1173     /// @notice Returns the ETH balance of the DAI pool.
1174     function ethBalanceOfDaiPool()
1175         public
1176         view
1177         requireLaunched
1178         returns (uint256)
1179     {
1180         return address(this).balance.sub(ethBalanceOfEclPool);
1181     }
1182 
1183     /// @notice Returns the DAI balance of the DAI pool.
1184     function daiBalanceOfDaiPool()
1185         public
1186         view
1187         requireLaunched
1188         returns (uint256)
1189     {
1190         return daiInterface.balanceOf(address(this));
1191     }
1192 
1193     /// @notice Returns the circulating supply of ECL.
1194     function circulatingSupply() public view requireLaunched returns (uint256) {
1195         return totalSupply().sub(eclBalanceOfEclPool());
1196     }
1197 }
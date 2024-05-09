1 /**
2  *                                                                        .o8
3                                                                          "888
4 oooo oooo    ooo oooo d8b  .oooo.   oo.ooooo.  oo.ooooo.   .ooooo.   .oooo888
5  `88. `88.  .8'  `888""8P `P  )88b   888' `88b  888' `88b d88' `88b d88' `888
6   `88..]88..8'    888      .oP"888   888   888  888   888 888ooo888 888   888
7    `888'`888'     888     d8(  888   888   888  888   888 888    .o 888   888
8     `8'  `8'     d888b    `Y888""8o  888bod8P'  888bod8P' `Y8bod8P' `Y8bod88P"
9                                      888        888
10                                     o888o      o888o
11 
12 ooooo      ooo ooooooo  ooooo ooo        ooooo
13 `888b.     `8'  `8888    d8'  `88.       .888'
14  8 `88b.    8     Y888..8P     888b     d'888
15  8   `88b.  8      `8888'      8 Y88. .P  888
16  8     `88b.8     .8PY888.     8  `888'   888
17  8       `888    d8'  `888b    8    Y     888
18 o8o        `8  o888o  o88888o o8o        o888o
19 */
20 // Made by https://peppersec.com
21 
22 pragma solidity 0.5.17;
23 
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 contract Context {
35     // Empty internal constructor, to prevent people from mistakenly deploying
36     // an instance of this contract, which should be used via inheritance.
37     constructor () internal { }
38     // solhint-disable-previous-line no-empty-blocks
39 
40     function _msgSender() internal view returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
51 
52 pragma solidity ^0.5.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
56  * the optional functions; to access them see {ERC20Detailed}.
57  */
58 interface IERC20 {
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by `account`.
66      */
67     function balanceOf(address account) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transfer(address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `sender` to `recipient` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 // File: @openzeppelin/contracts/math/SafeMath.sol
130 
131 pragma solidity ^0.5.0;
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations with added overflow
135  * checks.
136  *
137  * Arithmetic operations in Solidity wrap on overflow. This can easily result
138  * in bugs, because programmers usually assume that an overflow raises an
139  * error, which is the standard behavior in high level programming languages.
140  * `SafeMath` restores this intuition by reverting the transaction when an
141  * operation overflows.
142  *
143  * Using this library instead of the unchecked operations eliminates an entire
144  * class of bugs, so it's recommended to use it always.
145  */
146 library SafeMath {
147     /**
148      * @dev Returns the addition of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `+` operator.
152      *
153      * Requirements:
154      * - Addition cannot overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a, "SafeMath: addition overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      * - Subtraction cannot overflow.
184      *
185      * _Available since v2.4.0._
186      */
187     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b <= a, errorMessage);
189         uint256 c = a - b;
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      * - Multiplication cannot overflow.
202      */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
205         // benefit is lost if 'b' is also tested.
206         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
207         if (a == 0) {
208             return 0;
209         }
210 
211         uint256 c = a * b;
212         require(c / a == b, "SafeMath: multiplication overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         return div(a, b, "SafeMath: division by zero");
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      *
243      * _Available since v2.4.0._
244      */
245     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         // Solidity only automatically asserts when dividing by 0
247         require(b > 0, errorMessage);
248         uint256 c = a / b;
249         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts with custom message when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b != 0, errorMessage);
284         return a % b;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
289 
290 pragma solidity ^0.5.0;
291 
292 
293 
294 
295 /**
296  * @dev Implementation of the {IERC20} interface.
297  *
298  * This implementation is agnostic to the way tokens are created. This means
299  * that a supply mechanism has to be added in a derived contract using {_mint}.
300  * For a generic mechanism see {ERC20Mintable}.
301  *
302  * TIP: For a detailed writeup see our guide
303  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
304  * to implement supply mechanisms].
305  *
306  * We have followed general OpenZeppelin guidelines: functions revert instead
307  * of returning `false` on failure. This behavior is nonetheless conventional
308  * and does not conflict with the expectations of ERC20 applications.
309  *
310  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
311  * This allows applications to reconstruct the allowance for all accounts just
312  * by listening to said events. Other implementations of the EIP may not emit
313  * these events, as it isn't required by the specification.
314  *
315  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
316  * functions have been added to mitigate the well-known issues around setting
317  * allowances. See {IERC20-approve}.
318  */
319 contract ERC20 is Context, IERC20 {
320     using SafeMath for uint256;
321 
322     mapping (address => uint256) private _balances;
323 
324     mapping (address => mapping (address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20};
379      *
380      * Requirements:
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      * - the caller must have allowance for `sender`'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
387         _transfer(sender, recipient, amount);
388         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
425         return true;
426     }
427 
428     /**
429      * @dev Moves tokens `amount` from `sender` to `recipient`.
430      *
431      * This is internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(address sender, address recipient, uint256 amount) internal {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
447         _balances[recipient] = _balances[recipient].add(amount);
448         emit Transfer(sender, recipient, amount);
449     }
450 
451     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
452      * the total supply.
453      *
454      * Emits a {Transfer} event with `from` set to the zero address.
455      *
456      * Requirements
457      *
458      * - `to` cannot be the zero address.
459      */
460     function _mint(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: mint to the zero address");
462 
463         _totalSupply = _totalSupply.add(amount);
464         _balances[account] = _balances[account].add(amount);
465         emit Transfer(address(0), account, amount);
466     }
467 
468     /**
469      * @dev Destroys `amount` tokens from `account`, reducing the
470      * total supply.
471      *
472      * Emits a {Transfer} event with `to` set to the zero address.
473      *
474      * Requirements
475      *
476      * - `account` cannot be the zero address.
477      * - `account` must have at least `amount` tokens.
478      */
479     function _burn(address account, uint256 amount) internal {
480         require(account != address(0), "ERC20: burn from the zero address");
481 
482         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
483         _totalSupply = _totalSupply.sub(amount);
484         emit Transfer(account, address(0), amount);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
489      *
490      * This is internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(address owner, address spender, uint256 amount) internal {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = amount;
505         emit Approval(owner, spender, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
510      * from the caller's allowance.
511      *
512      * See {_burn} and {_approve}.
513      */
514     function _burnFrom(address account, uint256 amount) internal {
515         _burn(account, amount);
516         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
521 
522 pragma solidity ^0.5.0;
523 
524 
525 /**
526  * @dev Optional functions from the ERC20 standard.
527  */
528 contract ERC20Detailed is IERC20 {
529     string private _name;
530     string private _symbol;
531     uint8 private _decimals;
532 
533     /**
534      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
535      * these values are immutable: they can only be set once during
536      * construction.
537      */
538     constructor (string memory name, string memory symbol, uint8 decimals) public {
539         _name = name;
540         _symbol = symbol;
541         _decimals = decimals;
542     }
543 
544     /**
545      * @dev Returns the name of the token.
546      */
547     function name() public view returns (string memory) {
548         return _name;
549     }
550 
551     /**
552      * @dev Returns the symbol of the token, usually a shorter version of the
553      * name.
554      */
555     function symbol() public view returns (string memory) {
556         return _symbol;
557     }
558 
559     /**
560      * @dev Returns the number of decimals used to get its user representation.
561      * For example, if `decimals` equals `2`, a balance of `505` tokens should
562      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
563      *
564      * Tokens usually opt for a value of 18, imitating the relationship between
565      * Ether and Wei.
566      *
567      * NOTE: This information is only used for _display_ purposes: it in
568      * no way affects any of the arithmetic of the contract, including
569      * {IERC20-balanceOf} and {IERC20-transfer}.
570      */
571     function decimals() public view returns (uint8) {
572         return _decimals;
573     }
574 }
575 
576 // File: @openzeppelin/contracts/math/Math.sol
577 
578 pragma solidity ^0.5.0;
579 
580 /**
581  * @dev Standard math utilities missing in the Solidity language.
582  */
583 library Math {
584     /**
585      * @dev Returns the largest of two numbers.
586      */
587     function max(uint256 a, uint256 b) internal pure returns (uint256) {
588         return a >= b ? a : b;
589     }
590 
591     /**
592      * @dev Returns the smallest of two numbers.
593      */
594     function min(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a < b ? a : b;
596     }
597 
598     /**
599      * @dev Returns the average of two numbers. The result is rounded towards
600      * zero.
601      */
602     function average(uint256 a, uint256 b) internal pure returns (uint256) {
603         // (a + b) / 2 can overflow, so we distribute
604         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/utils/Address.sol
609 
610 pragma solidity ^0.5.5;
611 
612 /**
613  * @dev Collection of functions related to the address type
614  */
615 library Address {
616     /**
617      * @dev Returns true if `account` is a contract.
618      *
619      * [IMPORTANT]
620      * ====
621      * It is unsafe to assume that an address for which this function returns
622      * false is an externally-owned account (EOA) and not a contract.
623      *
624      * Among others, `isContract` will return false for the following
625      * types of addresses:
626      *
627      *  - an externally-owned account
628      *  - a contract in construction
629      *  - an address where a contract will be created
630      *  - an address where a contract lived, but was destroyed
631      * ====
632      */
633     function isContract(address account) internal view returns (bool) {
634         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
635         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
636         // for accounts without code, i.e. `keccak256('')`
637         bytes32 codehash;
638         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
639         // solhint-disable-next-line no-inline-assembly
640         assembly { codehash := extcodehash(account) }
641         return (codehash != accountHash && codehash != 0x0);
642     }
643 
644     /**
645      * @dev Converts an `address` into `address payable`. Note that this is
646      * simply a type cast: the actual underlying value is not changed.
647      *
648      * _Available since v2.4.0._
649      */
650     function toPayable(address account) internal pure returns (address payable) {
651         return address(uint160(account));
652     }
653 
654     /**
655      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
656      * `recipient`, forwarding all available gas and reverting on errors.
657      *
658      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
659      * of certain opcodes, possibly making contracts go over the 2300 gas limit
660      * imposed by `transfer`, making them unable to receive funds via
661      * `transfer`. {sendValue} removes this limitation.
662      *
663      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
664      *
665      * IMPORTANT: because control is transferred to `recipient`, care must be
666      * taken to not create reentrancy vulnerabilities. Consider using
667      * {ReentrancyGuard} or the
668      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
669      *
670      * _Available since v2.4.0._
671      */
672     function sendValue(address payable recipient, uint256 amount) internal {
673         require(address(this).balance >= amount, "Address: insufficient balance");
674 
675         // solhint-disable-next-line avoid-call-value
676         (bool success, ) = recipient.call.value(amount)("");
677         require(success, "Address: unable to send value, recipient may have reverted");
678     }
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
682 
683 pragma solidity ^0.5.0;
684 
685 
686 
687 
688 /**
689  * @title SafeERC20
690  * @dev Wrappers around ERC20 operations that throw on failure (when the token
691  * contract returns false). Tokens that return no value (and instead revert or
692  * throw on failure) are also supported, non-reverting calls are assumed to be
693  * successful.
694  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
695  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
696  */
697 library SafeERC20 {
698     using SafeMath for uint256;
699     using Address for address;
700 
701     function safeTransfer(IERC20 token, address to, uint256 value) internal {
702         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
703     }
704 
705     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
706         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
707     }
708 
709     function safeApprove(IERC20 token, address spender, uint256 value) internal {
710         // safeApprove should only be called when setting an initial allowance,
711         // or when resetting it to zero. To increase and decrease it, use
712         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
713         // solhint-disable-next-line max-line-length
714         require((value == 0) || (token.allowance(address(this), spender) == 0),
715             "SafeERC20: approve from non-zero to non-zero allowance"
716         );
717         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
718     }
719 
720     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
721         uint256 newAllowance = token.allowance(address(this), spender).add(value);
722         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
723     }
724 
725     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
726         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
727         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
728     }
729 
730     /**
731      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
732      * on the return value: the return value is optional (but if data is returned, it must not be false).
733      * @param token The token targeted by the call.
734      * @param data The call data (encoded using abi.encode or one of its variants).
735      */
736     function callOptionalReturn(IERC20 token, bytes memory data) private {
737         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
738         // we're implementing it ourselves.
739 
740         // A Solidity high level call has three parts:
741         //  1. The target address is checked to verify it contains contract code
742         //  2. The call itself is made, and success asserted
743         //  3. The return value is decoded, which in turn checks the size of the returned data.
744         // solhint-disable-next-line max-line-length
745         require(address(token).isContract(), "SafeERC20: call to non-contract");
746 
747         // solhint-disable-next-line avoid-low-level-calls
748         (bool success, bytes memory returndata) = address(token).call(data);
749         require(success, "SafeERC20: low-level call failed");
750 
751         if (returndata.length > 0) { // Return data is optional
752             // solhint-disable-next-line max-line-length
753             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
754         }
755     }
756 }
757 
758 // File: contracts/INXM.sol
759 
760 pragma solidity 0.5.17;
761 
762 
763 contract INXM is IERC20 {
764     function whiteListed(address owner) external view returns (bool);
765     function isLockedForMV(address owner) external view returns (uint256);
766 }
767 
768 // File: contracts/ECDSA.sol
769 
770 pragma solidity ^0.5.0;
771 
772 // A copy from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/files
773 
774 /**
775  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
776  *
777  * These functions can be used to verify that a message was signed by the holder
778  * of the private keys of a given address.
779  */
780 library ECDSA {
781     /**
782      * @dev Returns the address that signed a hashed message (`hash`) with
783      * `signature`. This address can then be used for verification purposes.
784      *
785      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
786      * this function rejects them by requiring the `s` value to be in the lower
787      * half order, and the `v` value to be either 27 or 28.
788      *
789      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
790      * verification to be secure: it is possible to craft signatures that
791      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
792      * this is by receiving a hash of the original message (which may otherwise
793      * be too long), and then calling {toEthSignedMessageHash} on it.
794      */
795     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
796         // Check the signature length
797         if (signature.length != 65) {
798             revert("ECDSA: invalid signature length");
799         }
800 
801         // Divide the signature in r, s and v variables
802         bytes32 r;
803         bytes32 s;
804         uint8 v;
805 
806         // ecrecover takes the signature parameters, and the only way to get them
807         // currently is to use assembly.
808         // solhint-disable-next-line no-inline-assembly
809         assembly {
810             r := mload(add(signature, 0x20))
811             s := mload(add(signature, 0x40))
812             v := byte(0, mload(add(signature, 0x60)))
813         }
814 
815         return recover(hash, v, r, s);
816     }
817 
818     /**
819      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
820      * `r` and `s` signature fields separately.
821      */
822     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
823         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
824         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
825         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
826         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
827         //
828         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
829         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
830         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
831         // these malleable signatures as well.
832         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
833             revert("ECDSA: invalid signature 's' value");
834         }
835 
836         if (v != 27 && v != 28) {
837             revert("ECDSA: invalid signature 'v' value");
838         }
839 
840         // If the signature is valid (and not malleable), return the signer address
841         address signer = ecrecover(hash, v, r, s);
842         require(signer != address(0), "ECDSA: invalid signature");
843 
844         return signer;
845     }
846 
847     /**
848      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
849      * replicates the behavior of the
850      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
851      * JSON-RPC method.
852      *
853      * See {recover}.
854      */
855     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
856         // 32 is the length in bytes of hash,
857         // enforced by the type signature above
858         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
859     }
860 }
861 
862 // File: contracts/ERC20Permit.sol
863 
864 pragma solidity ^0.5.0;
865 
866 // Adapted copy from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/files
867 
868 
869 
870 
871 
872 /**
873  * @dev Extension of {ERC20} that allows token holders to use their tokens
874  * without sending any transactions by setting {IERC20-allowance} with a
875  * signature using the {permit} method, and then spend them via
876  * {IERC20-transferFrom}.
877  *
878  * The {permit} signature mechanism conforms to the {IERC2612Permit} interface.
879  */
880 contract ERC20Permit is ERC20, ERC20Detailed {
881     mapping(address => uint256) private _nonces;
882 
883     bytes32 private constant _PERMIT_TYPEHASH = keccak256(
884         "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
885     );
886 
887     // Mapping of ChainID to domain separators. This is a very gas efficient way
888     // to not recalculate the domain separator on every call, while still
889     // automatically detecting ChainID changes.
890     mapping(uint256 => bytes32) private _domainSeparators;
891 
892     constructor() internal {
893         _updateDomainSeparator();
894     }
895 
896     /**
897      * @dev See {IERC2612Permit-permit}.
898      *
899      * If https://eips.ethereum.org/EIPS/eip-1344[ChainID] ever changes, the
900      * EIP712 Domain Separator is automatically recalculated.
901      */
902     function permit(
903         address owner,
904         address spender,
905         uint256 amount,
906         uint256 deadline,
907         uint8 v,
908         bytes32 r,
909         bytes32 s
910     ) public {
911         require(blockTimestamp() <= deadline, "ERC20Permit: expired deadline");
912 
913         bytes32 hashStruct = keccak256(
914             abi.encode(_PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner], deadline)
915         );
916 
917         bytes32 hash = keccak256(abi.encodePacked(uint16(0x1901), _domainSeparator(), hashStruct));
918 
919         address signer = ECDSA.recover(hash, v, r, s);
920         require(signer == owner, "ERC20Permit: invalid signature");
921 
922         _nonces[owner]++;
923         _approve(owner, spender, amount);
924     }
925 
926     /**
927      * @dev See {IERC2612Permit-nonces}.
928      */
929     function nonces(address owner) public view returns (uint256) {
930         return _nonces[owner];
931     }
932 
933     function _updateDomainSeparator() private returns (bytes32) {
934         uint256 _chainID = chainID();
935 
936         bytes32 newDomainSeparator = keccak256(
937             abi.encode(
938                 keccak256(
939                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
940                 ),
941                 keccak256(bytes(name())),
942                 keccak256(bytes("1")), // Version
943                 _chainID,
944                 address(this)
945             )
946         );
947 
948         _domainSeparators[_chainID] = newDomainSeparator;
949 
950         return newDomainSeparator;
951     }
952 
953     // Returns the domain separator, updating it if chainID changes
954     function _domainSeparator() private returns (bytes32) {
955         bytes32 domainSeparator = _domainSeparators[chainID()];
956         if (domainSeparator != 0x00) {
957             return domainSeparator;
958         } else {
959             return _updateDomainSeparator();
960         }
961     }
962 
963     function chainID() public view returns (uint256 _chainID) {
964         assembly {
965             _chainID := chainid()
966         }
967     }
968 
969     function blockTimestamp() public view returns (uint256) {
970         return block.timestamp;
971     }
972 }
973 
974 // File: contracts/wNXM.sol
975 
976 pragma solidity 0.5.17;
977 
978 contract wNXM is ERC20, ERC20Detailed, ERC20Permit {
979     using SafeERC20 for ERC20;
980     using SafeMath for uint256;
981 
982     INXM public NXM;
983 
984     modifier notwNXM(address recipient) {
985         require(recipient != address(this), "wNXM: can not send to self");
986         _;
987     }
988 
989     constructor(INXM _nxm) public ERC20Detailed("Wrapped NXM", "wNXM", 18) {
990         NXM = _nxm;
991     }
992 
993     function _transfer(address sender, address recipient, uint256 amount)
994         internal
995         notwNXM(recipient)
996     {
997         super._transfer(sender, recipient, amount);
998     }
999 
1000     function wrap(uint256 _amount) external {
1001         require(NXM.transferFrom(msg.sender, address(this), _amount), "wNXM: transferFrom failed");
1002         _mint(msg.sender, _amount);
1003     }
1004 
1005     function unwrap(uint256 _amount) external {
1006         unwrapTo(msg.sender, _amount);
1007     }
1008 
1009     function unwrapTo(address _to, uint256 _amount) public notwNXM(_to) {
1010         _burn(msg.sender, _amount);
1011         require(NXM.transfer(_to, _amount), "wNXM: transfer failed");
1012     }
1013 
1014     function canWrap(address _owner, uint256 _amount)
1015         external
1016         view
1017         returns (bool success, string memory reason)
1018     {
1019         if (NXM.allowance(_owner, address(this)) < _amount) {
1020             return (false, "insufficient allowance");
1021         }
1022 
1023         if (NXM.balanceOf(_owner) < _amount) {
1024             return (false, "insufficient NXM balance");
1025         }
1026 
1027         if (NXM.isLockedForMV(_owner) > now) {
1028             return (false, "NXM balance lockedForMv");
1029         }
1030 
1031         if (!NXM.whiteListed(address(this))) {
1032             return (false, "wNXM is not whitelisted");
1033         }
1034 
1035         return (true, "");
1036     }
1037 
1038     function canUnwrap(address _owner, address _recipient, uint256 _amount)
1039         external
1040         view
1041         returns (bool success, string memory reason)
1042     {
1043         if (balanceOf(_owner) < _amount) {
1044             return (false, "insufficient wNXM balance");
1045         }
1046 
1047         if (!NXM.whiteListed(_recipient)) {
1048             return (false, "recipient is not whitelisted");
1049         }
1050 
1051         if (NXM.isLockedForMV(address(this)) > now) {
1052             return (false, "wNXM is lockedForMv");
1053         }
1054 
1055         return (true, "");
1056     }
1057 
1058     /// @dev Method to claim junk and accidentally sent tokens
1059     function claimTokens(ERC20 _token, address payable _to, uint256 _balance) external {
1060         require(_to != address(0), "wNXM: can not send to zero address");
1061 
1062         if (_token == ERC20(address(NXM))) {
1063             uint256 surplusBalance = _token.balanceOf(address(this)).sub(totalSupply());
1064             require(surplusBalance > 0, "wNXM: there is no accidentally sent NXM");
1065             uint256 balance = _balance == 0 ? surplusBalance : Math.min(surplusBalance, _balance);
1066             _token.safeTransfer(_to, balance);
1067         } else if (_token == ERC20(0)) {
1068             // for Ether
1069             uint256 totalBalance = address(this).balance;
1070             uint256 balance = _balance == 0 ? totalBalance : Math.min(totalBalance, _balance);
1071             _to.transfer(balance);
1072         } else {
1073             // any other erc20
1074             uint256 totalBalance = _token.balanceOf(address(this));
1075             uint256 balance = _balance == 0 ? totalBalance : Math.min(totalBalance, _balance);
1076             require(balance > 0, "wNXM: trying to send 0 balance");
1077             _token.safeTransfer(_to, balance);
1078         }
1079     }
1080 }
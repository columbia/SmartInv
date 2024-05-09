1 // Built by INU lovers, for INU lovers. 
2 //
3 // Website: https://www.kishutoken.net
4 // Telegram: https://t.me/kishutoken
5 //
6 //
7 
8 pragma solidity ^0.6.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/access/Ownable.sol
32 
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
102 
103 // SPDX-License-Identifier: MIT
104 
105 pragma solidity ^0.6.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 // File: @openzeppelin/contracts/math/SafeMath.sol
182 
183 // SPDX-License-Identifier: MIT
184 
185 pragma solidity ^0.6.0;
186 
187 /**
188  * @dev Wrappers over Solidity's arithmetic operations with added overflow
189  * checks.
190  *
191  * Arithmetic operations in Solidity wrap on overflow. This can easily result
192  * in bugs, because programmers usually assume that an overflow raises an
193  * error, which is the standard behavior in high level programming languages.
194  * `SafeMath` restores this intuition by reverting the transaction when an
195  * operation overflows.
196  *
197  * Using this library instead of the unchecked operations eliminates an entire
198  * class of bugs, so it's recommended to use it always.
199  */
200 library SafeMath {
201     /**
202      * @dev Returns the addition of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `+` operator.
206      *
207      * Requirements:
208      *
209      * - Addition cannot overflow.
210      */
211     function add(uint256 a, uint256 b) internal pure returns (uint256) {
212         uint256 c = a + b;
213         require(c >= a, "SafeMath: addition overflow");
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b <= a, errorMessage);
244         uint256 c = a - b;
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the multiplication of two unsigned integers, reverting on
251      * overflow.
252      *
253      * Counterpart to Solidity's `*` operator.
254      *
255      * Requirements:
256      *
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
261         // benefit is lost if 'b' is also tested.
262         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
263         if (a == 0) {
264             return 0;
265         }
266 
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function div(uint256 a, uint256 b) internal pure returns (uint256) {
286         return div(a, b, "SafeMath: division by zero");
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b > 0, errorMessage);
303         uint256 c = a / b;
304         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
311      * Reverts when dividing by zero.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return mod(a, b, "SafeMath: modulo by zero");
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts with custom message when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b != 0, errorMessage);
339         return a % b;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/utils/Address.sol
344 
345 // SPDX-License-Identifier: MIT
346 
347 pragma solidity ^0.6.2;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies in extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { size := extcodesize(account) }
378         return size > 0;
379     }
380 
381     /**
382      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383      * `recipient`, forwarding all available gas and reverting on errors.
384      *
385      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386      * of certain opcodes, possibly making contracts go over the 2300 gas limit
387      * imposed by `transfer`, making them unable to receive funds via
388      * `transfer`. {sendValue} removes this limitation.
389      *
390      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391      *
392      * IMPORTANT: because control is transferred to `recipient`, care must be
393      * taken to not create reentrancy vulnerabilities. Consider using
394      * {ReentrancyGuard} or the
395      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396      */
397     function sendValue(address payable recipient, uint256 amount) internal {
398         require(address(this).balance >= amount, "Address: insufficient balance");
399 
400         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
401         (bool success, ) = recipient.call{ value: amount }("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain`call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
424       return functionCall(target, data, "Address: low-level call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
429      * `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         return _functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         return _functionCallWithValue(target, data, value, errorMessage);
461     }
462 
463     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
464         require(isContract(target), "Address: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 // solhint-disable-next-line no-inline-assembly
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 // File: contracts/ERC20.sol
488 
489 // SPDX-License-Identifier: MIT
490 
491 pragma solidity ^0.6.0;
492 
493 
494 
495 
496 
497 /**
498  * @dev Implementation of the {IERC20} interface.
499  *
500  * This implementation is agnostic to the way tokens are created. This means
501  * that a supply mechanism has to be added in a derived contract using {_mint}.
502  * For a generic mechanism see {ERC20PresetMinterPauser}.
503  *
504  * TIP: For a detailed writeup see our guide
505  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
506  * to implement supply mechanisms].
507  *
508  * We have followed general OpenZeppelin guidelines: functions revert instead
509  * of returning `false` on failure. This behavior is nonetheless conventional
510  * and does not conflict with the expectations of ERC20 applications.
511  *
512  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
513  * This allows applications to reconstruct the allowance for all accounts just
514  * by listening to said events. Other implementations of the EIP may not emit
515  * these events, as it isn't required by the specification.
516  *
517  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
518  * functions have been added to mitigate the well-known issues around setting
519  * allowances. See {IERC20-approve}.
520  */
521 contract ERC20 is Context, IERC20 {
522     using SafeMath for uint256;
523     using Address for address;
524 
525     mapping (address => uint256) private _balances;
526 
527     mapping (address => mapping (address => uint256)) internal _allowances;
528 
529     uint256 private _totalSupply;
530 
531     string private _name;
532     string private _symbol;
533     uint8 private _decimals;
534 
535     /**
536      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
537      * a default value of 18.
538      *
539      * To select a different value for {decimals}, use {_setupDecimals}.
540      *
541      * All three of these values are immutable: they can only be set once during
542      * construction.
543      */
544     constructor (string memory name, string memory symbol) public {
545         _name = name;
546         _symbol = symbol;
547         _decimals = 18;
548     }
549 
550     /**
551      * @dev Returns the name of the token.
552      */
553     function name() public view returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev Returns the symbol of the token, usually a shorter version of the
559      * name.
560      */
561     function symbol() public view returns (string memory) {
562         return _symbol;
563     }
564 
565     /**
566      * @dev Returns the number of decimals used to get its user representation.
567      * For example, if `decimals` equals `2`, a balance of `505` tokens should
568      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
569      *
570      * Tokens usually opt for a value of 18, imitating the relationship between
571      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
572      * called.
573      *
574      * NOTE: This information is only used for _display_ purposes: it in
575      * no way affects any of the arithmetic of the contract, including
576      * {IERC20-balanceOf} and {IERC20-transfer}.
577      */
578     function decimals() public view returns (uint8) {
579         return _decimals;
580     }
581 
582     /**
583      * @dev See {IERC20-totalSupply}.
584      */
585     function totalSupply() public view override returns (uint256) {
586         return _totalSupply;
587     }
588 
589     /**
590      * @dev See {IERC20-balanceOf}.
591      */
592     function balanceOf(address account) public view override returns (uint256) {
593         return _balances[account];
594     }
595 
596     /**
597      * @dev See {IERC20-transfer}.
598      *
599      * Requirements:
600      *
601      * - `recipient` cannot be the zero address.
602      * - the caller must have a balance of at least `amount`.
603      */
604     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
605         _transfer(_msgSender(), recipient, amount);
606         return true;
607     }
608 
609     /**
610      * @dev See {IERC20-allowance}.
611      */
612     function allowance(address owner, address spender) public view virtual override returns (uint256) {
613         return _allowances[owner][spender];
614     }
615 
616     /**
617      * @dev See {IERC20-approve}.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      */
623     function approve(address spender, uint256 amount) public virtual override returns (bool) {
624         _approve(_msgSender(), spender, amount);
625         return true;
626     }
627 
628     /**
629      * @dev See {IERC20-transferFrom}.
630      *
631      * Emits an {Approval} event indicating the updated allowance. This is not
632      * required by the EIP. See the note at the beginning of {ERC20};
633      *
634      * Requirements:
635      * - `sender` and `recipient` cannot be the zero address.
636      * - `sender` must have a balance of at least `amount`.
637      * - the caller must have allowance for ``sender``'s tokens of at least
638      * `amount`.
639      */
640     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
641         _transfer(sender, recipient, amount);
642         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
643         return true;
644     }
645 
646     /**
647      * @dev Atomically increases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
659         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
660         return true;
661     }
662 
663     /**
664      * @dev Atomically decreases the allowance granted to `spender` by the caller.
665      *
666      * This is an alternative to {approve} that can be used as a mitigation for
667      * problems described in {IERC20-approve}.
668      *
669      * Emits an {Approval} event indicating the updated allowance.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      * - `spender` must have allowance for the caller of at least
675      * `subtractedValue`.
676      */
677     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
678         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
679         return true;
680     }
681 
682     /**
683      * @dev Moves tokens `amount` from `sender` to `recipient`.
684      *
685      * This is internal function is equivalent to {transfer}, and can be used to
686      * e.g. implement automatic token fees, slashing mechanisms, etc.
687      *
688      * Emits a {Transfer} event.
689      *
690      * Requirements:
691      *
692      * - `sender` cannot be the zero address.
693      * - `recipient` cannot be the zero address.
694      * - `sender` must have a balance of at least `amount`.
695      */
696     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
697         require(sender != address(0), "ERC20: transfer from the zero address");
698         require(recipient != address(0), "ERC20: transfer to the zero address");
699 
700         _beforeTokenTransfer(sender, recipient, amount);
701 
702         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
703         _balances[recipient] = _balances[recipient].add(amount);
704         emit Transfer(sender, recipient, amount);
705     }
706 
707     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
708      * the total supply.
709      *
710      * Emits a {Transfer} event with `from` set to the zero address.
711      *
712      * Requirements
713      *
714      * - `to` cannot be the zero address.
715      */
716     function _mint(address account, uint256 amount) internal virtual {
717         require(account != address(0), "ERC20: mint to the zero address");
718 
719         _beforeTokenTransfer(address(0), account, amount);
720 
721         _totalSupply = _totalSupply.add(amount);
722         _balances[account] = _balances[account].add(amount);
723         emit Transfer(address(0), account, amount);
724     }
725 
726     /**
727      * @dev Destroys `amount` tokens from `account`, reducing the
728      * total supply.
729      *
730      * Emits a {Transfer} event with `to` set to the zero address.
731      *
732      * Requirements
733      *
734      * - `account` cannot be the zero address.
735      * - `account` must have at least `amount` tokens.
736      */
737     function _burn(address account, uint256 amount) internal virtual {
738         require(account != address(0), "ERC20: burn from the zero address");
739 
740         _beforeTokenTransfer(account, address(0), amount);
741 
742         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
743         _totalSupply = _totalSupply.sub(amount);
744         emit Transfer(account, address(0), amount);
745     }
746 
747     /**
748      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
749      *
750      * This internal function is equivalent to `approve`, and can be used to
751      * e.g. set automatic allowances for certain subsystems, etc.
752      *
753      * Emits an {Approval} event.
754      *
755      * Requirements:
756      *
757      * - `owner` cannot be the zero address.
758      * - `spender` cannot be the zero address.
759      */
760     function _approve(address owner, address spender, uint256 amount) internal virtual {
761         require(owner != address(0), "ERC20: approve from the zero address");
762         require(spender != address(0), "ERC20: approve to the zero address");
763 
764         _allowances[owner][spender] = amount;
765         emit Approval(owner, spender, amount);
766     }
767 
768     /**
769      * @dev Sets {decimals} to a value other than the default one of 18.
770      *
771      * WARNING: This function should only be called from the constructor. Most
772      * applications that interact with token contracts will not expect
773      * {decimals} to ever change, and may work incorrectly if it does.
774      */
775     function _setupDecimals(uint8 decimals_) internal {
776         _decimals = decimals_;
777     }
778 
779     /**
780      * @dev Hook that is called before any transfer of tokens. This includes
781      * minting and burning.
782      *
783      * Calling conditions:
784      *
785      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
786      * will be to transferred to `to`.
787      * - when `from` is zero, `amount` tokens will be minted for `to`.
788      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
789      * - `from` and `to` are never both zero.
790      *
791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
792      */
793     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
794 }
795 
796 pragma solidity ^0.6.2;
797 
798 contract KISHU is ERC20, Ownable {
799   constructor() public ERC20("KISHU", "KISHU INU") { 
800     _mint(msg.sender, 69000000000000000000000000000000);
801   }
802 
803   // Transfer Fee
804   event TransferFeeChanged(uint256 newFee);
805   event FeeRecipientChange(address account);
806   event AddFeeException(address account);
807   event RemoveFeeException(address account);
808 
809   bool private activeFee;
810   uint256 public transferFee; 
811   address public feeRecipient; 
812 
813   // Exception to transfer fees, for example for Uniswap contracts.
814   mapping (address => bool) public feeException;
815 
816   function addFeeException(address account) public onlyOwner {
817     feeException[account] = true;
818     emit AddFeeException(account);
819   }
820 
821   function removeFeeException(address account) public onlyOwner {
822     feeException[account] = false;
823     emit RemoveFeeException(account);
824   }
825 
826   function setTransferFee(uint256 fee) public onlyOwner {
827     require(fee <= 4500, "Invalid");
828     if (fee == 0) {
829       activeFee = false;
830     } else {
831       activeFee = true;
832     }
833     transferFee = fee;
834     emit TransferFeeChanged(fee);
835   }
836 
837   function setTransferFeeRecipient(address account) public onlyOwner {
838     feeRecipient = account;
839     emit FeeRecipientChange(account);
840   }
841 
842   // Transfer recipient recives amount - fee
843   function transfer(address recipient, uint256 amount) public override returns (bool) {
844     if (activeFee && feeException[_msgSender()] == false) {
845       uint256 fee = transferFee.mul(amount).div(10000);
846       uint amountLessFee = amount.sub(fee);
847       _transfer(_msgSender(), recipient, amountLessFee);
848       _transfer(_msgSender(), feeRecipient, fee);
849     } else {
850       _transfer(_msgSender(), recipient, amount);
851     }
852     return true;
853   }
854 
855   // TransferFrom recipient recives amount, sender's account is debited amount + fee
856   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
857     if (activeFee && feeException[recipient] == false) {
858       uint256 fee = transferFee.mul(amount).div(10000);
859       _transfer(sender, feeRecipient, fee);
860     }
861     _transfer(sender, recipient, amount);
862     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
863     return true;
864   }
865 
866 }
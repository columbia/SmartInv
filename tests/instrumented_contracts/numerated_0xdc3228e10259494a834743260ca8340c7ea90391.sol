1 
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
100 
101 
102 
103 pragma solidity ^0.6.0;
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(address recipient, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. This is
131      * zero by default.
132      *
133      * This value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * Note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 // File: @openzeppelin/contracts/math/SafeMath.sol
180 
181 
182 
183 pragma solidity ^0.6.0;
184 
185 /**
186  * @dev Wrappers over Solidity's arithmetic operations with added overflow
187  * checks.
188  *
189  * Arithmetic operations in Solidity wrap on overflow. This can easily result
190  * in bugs, because programmers usually assume that an overflow raises an
191  * error, which is the standard behavior in high level programming languages.
192  * `SafeMath` restores this intuition by reverting the transaction when an
193  * operation overflows.
194  *
195  * Using this library instead of the unchecked operations eliminates an entire
196  * class of bugs, so it's recommended to use it always.
197  */
198 library SafeMath {
199     /**
200      * @dev Returns the addition of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `+` operator.
204      *
205      * Requirements:
206      *
207      * - Addition cannot overflow.
208      */
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         require(c >= a, "SafeMath: addition overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      *
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b <= a, errorMessage);
242         uint256 c = a - b;
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         return div(a, b, "SafeMath: division by zero");
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return mod(a, b, "SafeMath: modulo by zero");
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts with custom message when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b != 0, errorMessage);
337         return a % b;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Address.sol
342 
343 
344 
345 pragma solidity ^0.6.2;
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [IMPORTANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
370         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
371         // for accounts without code, i.e. `keccak256('')`
372         bytes32 codehash;
373         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { codehash := extcodehash(account) }
376         return (codehash != accountHash && codehash != 0x0);
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422       return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         return _functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         return _functionCallWithValue(target, data, value, errorMessage);
459     }
460 
461     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
462         require(isContract(target), "Address: call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
486 
487 
488 
489 pragma solidity ^0.6.0;
490 
491 
492 
493 
494 
495 /**
496  * @dev Implementation of the {IERC20} interface.
497  *
498  * This implementation is agnostic to the way tokens are created. This means
499  * that a supply mechanism has to be added in a derived contract using {_mint}.
500  * For a generic mechanism see {ERC20PresetMinterPauser}.
501  *
502  * TIP: For a detailed writeup see our guide
503  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
504  * to implement supply mechanisms].
505  *
506  * We have followed general OpenZeppelin guidelines: functions revert instead
507  * of returning `false` on failure. This behavior is nonetheless conventional
508  * and does not conflict with the expectations of ERC20 applications.
509  *
510  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
511  * This allows applications to reconstruct the allowance for all accounts just
512  * by listening to said events. Other implementations of the EIP may not emit
513  * these events, as it isn't required by the specification.
514  *
515  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
516  * functions have been added to mitigate the well-known issues around setting
517  * allowances. See {IERC20-approve}.
518  */
519 contract ERC20 is Context, IERC20 {
520     using SafeMath for uint256;
521     using Address for address;
522 
523     mapping (address => uint256) private _balances;
524 
525     mapping (address => mapping (address => uint256)) private _allowances;
526 
527     uint256 private _totalSupply;
528 
529     string private _name;
530     string private _symbol;
531     uint8 private _decimals;
532 
533     /**
534      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
535      * a default value of 18.
536      *
537      * To select a different value for {decimals}, use {_setupDecimals}.
538      *
539      * All three of these values are immutable: they can only be set once during
540      * construction.
541      */
542     constructor (string memory name, string memory symbol) public {
543         _name = name;
544         _symbol = symbol;
545         _decimals = 18;
546     }
547 
548     /**
549      * @dev Returns the name of the token.
550      */
551     function name() public view returns (string memory) {
552         return _name;
553     }
554 
555     /**
556      * @dev Returns the symbol of the token, usually a shorter version of the
557      * name.
558      */
559     function symbol() public view returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev Returns the number of decimals used to get its user representation.
565      * For example, if `decimals` equals `2`, a balance of `505` tokens should
566      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
567      *
568      * Tokens usually opt for a value of 18, imitating the relationship between
569      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
570      * called.
571      *
572      * NOTE: This information is only used for _display_ purposes: it in
573      * no way affects any of the arithmetic of the contract, including
574      * {IERC20-balanceOf} and {IERC20-transfer}.
575      */
576     function decimals() public view returns (uint8) {
577         return _decimals;
578     }
579 
580     /**
581      * @dev See {IERC20-totalSupply}.
582      */
583     function totalSupply() public view override returns (uint256) {
584         return _totalSupply;
585     }
586 
587     /**
588      * @dev See {IERC20-balanceOf}.
589      */
590     function balanceOf(address account) public view override returns (uint256) {
591         return _balances[account];
592     }
593 
594     /**
595      * @dev See {IERC20-transfer}.
596      *
597      * Requirements:
598      *
599      * - `recipient` cannot be the zero address.
600      * - the caller must have a balance of at least `amount`.
601      */
602     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
603         _transfer(_msgSender(), recipient, amount);
604         return true;
605     }
606 
607     /**
608      * @dev See {IERC20-allowance}.
609      */
610     function allowance(address owner, address spender) public view virtual override returns (uint256) {
611         return _allowances[owner][spender];
612     }
613 
614     /**
615      * @dev See {IERC20-approve}.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      */
621     function approve(address spender, uint256 amount) public virtual override returns (bool) {
622         _approve(_msgSender(), spender, amount);
623         return true;
624     }
625 
626     /**
627      * @dev See {IERC20-transferFrom}.
628      *
629      * Emits an {Approval} event indicating the updated allowance. This is not
630      * required by the EIP. See the note at the beginning of {ERC20};
631      *
632      * Requirements:
633      * - `sender` and `recipient` cannot be the zero address.
634      * - `sender` must have a balance of at least `amount`.
635      * - the caller must have allowance for ``sender``'s tokens of at least
636      * `amount`.
637      */
638     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
639         _transfer(sender, recipient, amount);
640         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
641         return true;
642     }
643 
644     /**
645      * @dev Atomically increases the allowance granted to `spender` by the caller.
646      *
647      * This is an alternative to {approve} that can be used as a mitigation for
648      * problems described in {IERC20-approve}.
649      *
650      * Emits an {Approval} event indicating the updated allowance.
651      *
652      * Requirements:
653      *
654      * - `spender` cannot be the zero address.
655      */
656     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
657         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
658         return true;
659     }
660 
661     /**
662      * @dev Atomically decreases the allowance granted to `spender` by the caller.
663      *
664      * This is an alternative to {approve} that can be used as a mitigation for
665      * problems described in {IERC20-approve}.
666      *
667      * Emits an {Approval} event indicating the updated allowance.
668      *
669      * Requirements:
670      *
671      * - `spender` cannot be the zero address.
672      * - `spender` must have allowance for the caller of at least
673      * `subtractedValue`.
674      */
675     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
676         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
677         return true;
678     }
679 
680     /**
681      * @dev Moves tokens `amount` from `sender` to `recipient`.
682      *
683      * This is internal function is equivalent to {transfer}, and can be used to
684      * e.g. implement automatic token fees, slashing mechanisms, etc.
685      *
686      * Emits a {Transfer} event.
687      *
688      * Requirements:
689      *
690      * - `sender` cannot be the zero address.
691      * - `recipient` cannot be the zero address.
692      * - `sender` must have a balance of at least `amount`.
693      */
694     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
695         require(sender != address(0), "ERC20: transfer from the zero address");
696         require(recipient != address(0), "ERC20: transfer to the zero address");
697 
698         _beforeTokenTransfer(sender, recipient, amount);
699 
700         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
701         _balances[recipient] = _balances[recipient].add(amount);
702         emit Transfer(sender, recipient, amount);
703     }
704 
705     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
706      * the total supply.
707      *
708      * Emits a {Transfer} event with `from` set to the zero address.
709      *
710      * Requirements
711      *
712      * - `to` cannot be the zero address.
713      */
714     function _mint(address account, uint256 amount) internal virtual {
715         require(account != address(0), "ERC20: mint to the zero address");
716 
717         _beforeTokenTransfer(address(0), account, amount);
718 
719         _totalSupply = _totalSupply.add(amount);
720         _balances[account] = _balances[account].add(amount);
721         emit Transfer(address(0), account, amount);
722     }
723 
724     /**
725      * @dev Destroys `amount` tokens from `account`, reducing the
726      * total supply.
727      *
728      * Emits a {Transfer} event with `to` set to the zero address.
729      *
730      * Requirements
731      *
732      * - `account` cannot be the zero address.
733      * - `account` must have at least `amount` tokens.
734      */
735     function _burn(address account, uint256 amount) internal virtual {
736         require(account != address(0), "ERC20: burn from the zero address");
737 
738         _beforeTokenTransfer(account, address(0), amount);
739 
740         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
741         _totalSupply = _totalSupply.sub(amount);
742         emit Transfer(account, address(0), amount);
743     }
744 
745     /**
746      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
747      *
748      * This is internal function is equivalent to `approve`, and can be used to
749      * e.g. set automatic allowances for certain subsystems, etc.
750      *
751      * Emits an {Approval} event.
752      *
753      * Requirements:
754      *
755      * - `owner` cannot be the zero address.
756      * - `spender` cannot be the zero address.
757      */
758     function _approve(address owner, address spender, uint256 amount) internal virtual {
759         require(owner != address(0), "ERC20: approve from the zero address");
760         require(spender != address(0), "ERC20: approve to the zero address");
761 
762         _allowances[owner][spender] = amount;
763         emit Approval(owner, spender, amount);
764     }
765 
766     /**
767      * @dev Sets {decimals} to a value other than the default one of 18.
768      *
769      * WARNING: This function should only be called from the constructor. Most
770      * applications that interact with token contracts will not expect
771      * {decimals} to ever change, and may work incorrectly if it does.
772      */
773     function _setupDecimals(uint8 decimals_) internal {
774         _decimals = decimals_;
775     }
776 
777     /**
778      * @dev Hook that is called before any transfer of tokens. This includes
779      * minting and burning.
780      *
781      * Calling conditions:
782      *
783      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
784      * will be to transferred to `to`.
785      * - when `from` is zero, `amount` tokens will be minted for `to`.
786      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
787      * - `from` and `to` are never both zero.
788      *
789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
790      */
791     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
792 }
793 
794 // File: @openzeppelin/contracts/utils/Pausable.sol
795 
796 
797 
798 pragma solidity ^0.6.0;
799 
800 
801 /**
802  * @dev Contract module which allows children to implement an emergency stop
803  * mechanism that can be triggered by an authorized account.
804  *
805  * This module is used through inheritance. It will make available the
806  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
807  * the functions of your contract. Note that they will not be pausable by
808  * simply including this module, only once the modifiers are put in place.
809  */
810 contract Pausable is Context {
811     /**
812      * @dev Emitted when the pause is triggered by `account`.
813      */
814     event Paused(address account);
815 
816     /**
817      * @dev Emitted when the pause is lifted by `account`.
818      */
819     event Unpaused(address account);
820 
821     bool private _paused;
822 
823     /**
824      * @dev Initializes the contract in unpaused state.
825      */
826     constructor () internal {
827         _paused = false;
828     }
829 
830     /**
831      * @dev Returns true if the contract is paused, and false otherwise.
832      */
833     function paused() public view returns (bool) {
834         return _paused;
835     }
836 
837     /**
838      * @dev Modifier to make a function callable only when the contract is not paused.
839      *
840      * Requirements:
841      *
842      * - The contract must not be paused.
843      */
844     modifier whenNotPaused() {
845         require(!_paused, "Pausable: paused");
846         _;
847     }
848 
849     /**
850      * @dev Modifier to make a function callable only when the contract is paused.
851      *
852      * Requirements:
853      *
854      * - The contract must be paused.
855      */
856     modifier whenPaused() {
857         require(_paused, "Pausable: not paused");
858         _;
859     }
860 
861     /**
862      * @dev Triggers stopped state.
863      *
864      * Requirements:
865      *
866      * - The contract must not be paused.
867      */
868     function _pause() internal virtual whenNotPaused {
869         _paused = true;
870         emit Paused(_msgSender());
871     }
872 
873     /**
874      * @dev Returns to normal state.
875      *
876      * Requirements:
877      *
878      * - The contract must be paused.
879      */
880     function _unpause() internal virtual whenPaused {
881         _paused = false;
882         emit Unpaused(_msgSender());
883     }
884 }
885 
886 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
887 
888 
889 
890 pragma solidity ^0.6.0;
891 
892 
893 
894 /**
895  * @dev ERC20 token with pausable token transfers, minting and burning.
896  *
897  * Useful for scenarios such as preventing trades until the end of an evaluation
898  * period, or having an emergency switch for freezing all token transfers in the
899  * event of a large bug.
900  */
901 abstract contract ERC20Pausable is ERC20, Pausable {
902     /**
903      * @dev See {ERC20-_beforeTokenTransfer}.
904      *
905      * Requirements:
906      *
907      * - the contract must not be paused.
908      */
909     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
910         super._beforeTokenTransfer(from, to, amount);
911 
912         require(!paused(), "ERC20Pausable: token transfer while paused");
913     }
914 }
915 
916 // File: contracts/MarcoToken.sol
917 
918 
919 pragma solidity >=0.4.25 <0.7.0;
920 
921 
922 
923 contract MarcoToken is Ownable, ERC20Pausable {
924     constructor() public ERC20("Marco Token", "MRC") {
925         _mint(msg.sender, 99000000000000000000000000000);
926     }
927 
928     function mint(address to, uint256 amount) public onlyOwner {
929         _mint(to, amount);
930     }
931 
932     function burn(address from, uint256 amount) public onlyOwner {
933         _burn(from, amount);
934     }
935 
936     function pause() public onlyOwner {
937         _pause();
938     }
939 
940     function unpause() public onlyOwner {
941         _unpause();
942     }
943 }

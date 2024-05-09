1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 interface IUniswapV2Factory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function feeTo() external view returns (address);
8     function feeToSetter() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }
19 
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
44         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
45         // for accounts without code, i.e. `keccak256('')`
46         bytes32 codehash;
47         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
48         // solhint-disable-next-line no-inline-assembly
49         assembly { codehash := extcodehash(account) }
50         return (codehash != accountHash && codehash != 0x0);
51     }
52 
53     /**
54      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
55      * `recipient`, forwarding all available gas and reverting on errors.
56      *
57      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
58      * of certain opcodes, possibly making contracts go over the 2300 gas limit
59      * imposed by `transfer`, making them unable to receive funds via
60      * `transfer`. {sendValue} removes this limitation.
61      *
62      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
63      *
64      * IMPORTANT: because control is transferred to `recipient`, care must be
65      * taken to not create reentrancy vulnerabilities. Consider using
66      * {ReentrancyGuard} or the
67      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
68      */
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
73         (bool success, ) = recipient.call{ value: amount }("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     /**
78      * @dev Performs a Solidity function call using a low level `call`. A
79      * plain`call` is an unsafe replacement for a function call: use this
80      * function instead.
81      *
82      * If `target` reverts with a revert reason, it is bubbled up by this
83      * function (like regular Solidity function calls).
84      *
85      * Returns the raw returned data. To convert to the expected return value,
86      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
87      *
88      * Requirements:
89      *
90      * - `target` must be a contract.
91      * - calling `target` with `data` must not revert.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106         return _functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         return _functionCallWithValue(target, data, value, errorMessage);
133     }
134 
135     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143             // Look for revert reason and bubble it up if present
144             if (returndata.length > 0) {
145                 // The easiest way to bubble the revert reason is using memory via assembly
146 
147                 // solhint-disable-next-line no-inline-assembly
148                 assembly {
149                     let returndata_size := mload(returndata)
150                     revert(add(32, returndata), returndata_size)
151                 }
152             } else {
153                 revert(errorMessage);
154             }
155         }
156     }
157 }
158 
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor () {
202         address msgSender = _msgSender();
203         _owner = msgSender;
204         emit OwnershipTransferred(address(0), msgSender);
205     }
206 
207     /**
208      * @dev Returns the address of the current owner.
209      */
210     function owner() public view returns (address) {
211         return _owner;
212     }
213 
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     modifier onlyOwner() {
218         require(_owner == _msgSender(), "Ownable: caller is not the owner");
219         _;
220     }
221 
222     /**
223      * @dev Leaves the contract without owner. It will not be possible to call
224      * `onlyOwner` functions anymore. Can only be called by the current owner.
225      *
226      * NOTE: Renouncing ownership will leave the contract without an owner,
227      * thereby removing any functionality that is only available to the owner.
228      */
229     function renounceOwnership() public virtual onlyOwner {
230         emit OwnershipTransferred(_owner, address(0));
231         _owner = address(0);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         emit OwnershipTransferred(_owner, newOwner);
241         _owner = newOwner;
242     }
243 }
244 
245 
246 /**
247  * @dev Wrappers over Solidity's arithmetic operations with added overflow
248  * checks.
249  *
250  * Arithmetic operations in Solidity wrap on overflow. This can easily result
251  * in bugs, because programmers usually assume that an overflow raises an
252  * error, which is the standard behavior in high level programming languages.
253  * `SafeMath` restores this intuition by reverting the transaction when an
254  * operation overflows.
255  *
256  * Using this library instead of the unchecked operations eliminates an entire
257  * class of bugs, so it's recommended to use it always.
258  */
259 library SafeMath {
260     /**
261      * @dev Returns the addition of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `+` operator.
265      *
266      * Requirements:
267      *
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         uint256 c = a + b;
272         require(c >= a, "SafeMath: addition overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting on
279      * overflow (when the result is negative).
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      *
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return sub(a, b, "SafeMath: subtraction overflow");
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         uint256 c = a - b;
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the multiplication of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `*` operator.
313      *
314      * Requirements:
315      *
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
345         return div(a, b, "SafeMath: division by zero");
346     }
347 
348     /**
349      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
350      * division by zero. The result is rounded towards zero.
351      *
352      * Counterpart to Solidity's `/` operator. Note: this function uses a
353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
354      * uses an invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b > 0, errorMessage);
362         uint256 c = a / b;
363         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
364 
365         return c;
366     }
367 
368     /**
369      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
370      * Reverts when dividing by zero.
371      *
372      * Counterpart to Solidity's `%` operator. This function uses a `revert`
373      * opcode (which leaves remaining gas untouched) while Solidity uses an
374      * invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
381         return mod(a, b, "SafeMath: modulo by zero");
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * Reverts with custom message when dividing by zero.
387      *
388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
389      * opcode (which leaves remaining gas untouched) while Solidity uses an
390      * invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
397         require(b != 0, errorMessage);
398         return a % b;
399     }
400 }
401 
402 
403 /**
404  * @dev Interface of the ERC20 standard as defined in the EIP.
405  */
406 interface IERC20 {
407     /**
408      * @dev Returns the amount of tokens in existence.
409      */
410     function totalSupply() external view returns (uint256);
411 
412     /**
413      * @dev Returns the amount of tokens owned by `account`.
414      */
415     function balanceOf(address account) external view returns (uint256);
416 
417     /**
418      * @dev Moves `amount` tokens from the caller's account to `recipient`.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transfer(address recipient, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Returns the remaining number of tokens that `spender` will be
428      * allowed to spend on behalf of `owner` through {transferFrom}. This is
429      * zero by default.
430      *
431      * This value changes when {approve} or {transferFrom} are called.
432      */
433     function allowance(address owner, address spender) external view returns (uint256);
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * IMPORTANT: Beware that changing an allowance with this method brings the risk
441      * that someone may use both the old and the new allowance by unfortunate
442      * transaction ordering. One possible solution to mitigate this race
443      * condition is to first reduce the spender's allowance to 0 and set the
444      * desired value afterwards:
445      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
446      *
447      * Emits an {Approval} event.
448      */
449     function approve(address spender, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Moves `amount` tokens from `sender` to `recipient` using the
453      * allowance mechanism. `amount` is then deducted from the caller's
454      * allowance.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Emitted when `value` tokens are moved from one account (`from`) to
464      * another (`to`).
465      *
466      * Note that `value` may be zero.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 value);
469 
470     /**
471      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
472      * a call to {approve}. `value` is the new allowance.
473      */
474     event Approval(address indexed owner, address indexed spender, uint256 value);
475 }
476 
477 /**
478  * @dev Implementation of the {IERC20} interface.
479  *
480  * This implementation is agnostic to the way tokens are created. This means
481  * that a supply mechanism has to be added in a derived contract using {_mint}.
482  * For a generic mechanism see {ERC20PresetMinterPauser}.
483  *
484  * TIP: For a detailed writeup see our guide
485  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
486  * to implement supply mechanisms].
487  *
488  * We have followed general OpenZeppelin guidelines: functions revert instead
489  * of returning `false` on failure. This behavior is nonetheless conventional
490  * and does not conflict with the expectations of ERC20 applications.
491  *
492  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
493  * This allows applications to reconstruct the allowance for all accounts just
494  * by listening to said events. Other implementations of the EIP may not emit
495  * these events, as it isn't required by the specification.
496  *
497  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
498  * functions have been added to mitigate the well-known issues around setting
499  * allowances. See {IERC20-approve}.
500  */
501 contract ERC20 is Context, IERC20 {
502     using SafeMath for uint256;
503 
504     mapping (address => uint256) private _balances;
505 
506     mapping (address => mapping (address => uint256)) private _allowances;
507 
508     uint256 private _totalSupply;
509 
510     string private _name;
511     string private _symbol;
512     uint8 private _decimals;
513 
514     /**
515      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
516      * a default value of 18.
517      *
518      * To select a different value for {decimals}, use {_setupDecimals}.
519      *
520      * All three of these values are immutable: they can only be set once during
521      * construction.
522      */
523     constructor (string memory name_, string memory symbol_) {
524         _name = name_;
525         _symbol = symbol_;
526         _decimals = 18;
527     }
528 
529     /**
530      * @dev Returns the name of the token.
531      */
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     /**
537      * @dev Returns the symbol of the token, usually a shorter version of the
538      * name.
539      */
540     function symbol() public view returns (string memory) {
541         return _symbol;
542     }
543 
544     /**
545      * @dev Returns the number of decimals used to get its user representation.
546      * For example, if `decimals` equals `2`, a balance of `505` tokens should
547      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
548      *
549      * Tokens usually opt for a value of 18, imitating the relationship between
550      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
551      * called.
552      *
553      * NOTE: This information is only used for _display_ purposes: it in
554      * no way affects any of the arithmetic of the contract, including
555      * {IERC20-balanceOf} and {IERC20-transfer}.
556      */
557     function decimals() public view returns (uint8) {
558         return _decimals;
559     }
560 
561     /**
562      * @dev See {IERC20-totalSupply}.
563      */
564     function totalSupply() public view override returns (uint256) {
565         return _totalSupply;
566     }
567 
568     /**
569      * @dev See {IERC20-balanceOf}.
570      */
571     function balanceOf(address account) public view override returns (uint256) {
572         return _balances[account];
573     }
574 
575     /**
576      * @dev See {IERC20-transfer}.
577      *
578      * Requirements:
579      *
580      * - `recipient` cannot be the zero address.
581      * - the caller must have a balance of at least `amount`.
582      */
583     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
584         _transfer(_msgSender(), recipient, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-allowance}.
590      */
591     function allowance(address owner, address spender) public view virtual override returns (uint256) {
592         return _allowances[owner][spender];
593     }
594 
595     /**
596      * @dev See {IERC20-approve}.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function approve(address spender, uint256 amount) public virtual override returns (bool) {
603         _approve(_msgSender(), spender, amount);
604         return true;
605     }
606 
607     /**
608      * @dev See {IERC20-transferFrom}.
609      *
610      * Emits an {Approval} event indicating the updated allowance. This is not
611      * required by the EIP. See the note at the beginning of {ERC20}.
612      *
613      * Requirements:
614      *
615      * - `sender` and `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      * - the caller must have allowance for ``sender``'s tokens of at least
618      * `amount`.
619      */
620     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
621         _transfer(sender, recipient, amount);
622         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
623         return true;
624     }
625 
626     /**
627      * @dev Atomically increases the allowance granted to `spender` by the caller.
628      *
629      * This is an alternative to {approve} that can be used as a mitigation for
630      * problems described in {IERC20-approve}.
631      *
632      * Emits an {Approval} event indicating the updated allowance.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      */
638     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
639         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
640         return true;
641     }
642 
643     /**
644      * @dev Atomically decreases the allowance granted to `spender` by the caller.
645      *
646      * This is an alternative to {approve} that can be used as a mitigation for
647      * problems described in {IERC20-approve}.
648      *
649      * Emits an {Approval} event indicating the updated allowance.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      * - `spender` must have allowance for the caller of at least
655      * `subtractedValue`.
656      */
657     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
658         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
659         return true;
660     }
661 
662     /**
663      * @dev Moves tokens `amount` from `sender` to `recipient`.
664      *
665      * This is internal function is equivalent to {transfer}, and can be used to
666      * e.g. implement automatic token fees, slashing mechanisms, etc.
667      *
668      * Emits a {Transfer} event.
669      *
670      * Requirements:
671      *
672      * - `sender` cannot be the zero address.
673      * - `recipient` cannot be the zero address.
674      * - `sender` must have a balance of at least `amount`.
675      */
676     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
677         require(sender != address(0), "ERC20: transfer from the zero address");
678         require(recipient != address(0), "ERC20: transfer to the zero address");
679 
680         _beforeTokenTransfer(sender, recipient, amount);
681 
682         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
683         _balances[recipient] = _balances[recipient].add(amount);
684         emit Transfer(sender, recipient, amount);
685     }
686 
687     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
688      * the total supply.
689      *
690      * Emits a {Transfer} event with `from` set to the zero address.
691      *
692      * Requirements:
693      *
694      * - `to` cannot be the zero address.
695      */
696     function _mint(address account, uint256 amount) internal virtual {
697         require(account != address(0), "ERC20: mint to the zero address");
698 
699         _beforeTokenTransfer(address(0), account, amount);
700 
701         _totalSupply = _totalSupply.add(amount);
702         _balances[account] = _balances[account].add(amount);
703         emit Transfer(address(0), account, amount);
704     }
705 
706     /**
707      * @dev Destroys `amount` tokens from `account`, reducing the
708      * total supply.
709      *
710      * Emits a {Transfer} event with `to` set to the zero address.
711      *
712      * Requirements:
713      *
714      * - `account` cannot be the zero address.
715      * - `account` must have at least `amount` tokens.
716      */
717     function _burn(address account, uint256 amount) internal virtual {
718         require(account != address(0), "ERC20: burn from the zero address");
719 
720         _beforeTokenTransfer(account, address(0), amount);
721 
722         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
723         _totalSupply = _totalSupply.sub(amount);
724         emit Transfer(account, address(0), amount);
725     }
726 
727     /**
728      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
729      *
730      * This internal function is equivalent to `approve`, and can be used to
731      * e.g. set automatic allowances for certain subsystems, etc.
732      *
733      * Emits an {Approval} event.
734      *
735      * Requirements:
736      *
737      * - `owner` cannot be the zero address.
738      * - `spender` cannot be the zero address.
739      */
740     function _approve(address owner, address spender, uint256 amount) internal virtual {
741         require(owner != address(0), "ERC20: approve from the zero address");
742         require(spender != address(0), "ERC20: approve to the zero address");
743 
744         _allowances[owner][spender] = amount;
745         emit Approval(owner, spender, amount);
746     }
747 
748     /**
749      * @dev Sets {decimals} to a value other than the default one of 18.
750      *
751      * WARNING: This function should only be called from the constructor. Most
752      * applications that interact with token contracts will not expect
753      * {decimals} to ever change, and may work incorrectly if it does.
754      */
755     function _setupDecimals(uint8 decimals_) internal {
756         _decimals = decimals_;
757     }
758 
759     /**
760      * @dev Hook that is called before any transfer of tokens. This includes
761      * minting and burning.
762      *
763      * Calling conditions:
764      *
765      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
766      * will be to transferred to `to`.
767      * - when `from` is zero, `amount` tokens will be minted for `to`.
768      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
769      * - `from` and `to` are never both zero.
770      *
771      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
772      */
773     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
774 }
775 
776 
777 
778 /// @title DIV token rewards buyers from specific addresses (AMMs such as uniswap) by minting purchase rewards immediately, and burns a percentage of all on chain transactions.
779 /// @author Nijitoki Labs; in collaboration with CommunityToken.io; original ver. by KrippTorofu @ RiotOfTheBlock
780 ///   NOTES: This version includes uniswap router registration, to prevent owner from setting mint addresses that are not UniswapV2Pairs.  
781 ///   No tax/burn limits have been added to this token.
782 ///   Until the Ownership is rescinded, owner can modify the parameters of the contract (tax, interest, whitelisted addresses, uniswap pairs).
783 ///   Minting is disabled, except for the interest generating address, which is now behind a uniswap router check.
784 contract DIVToken2 is ERC20, Ownable {
785     using SafeMath for uint256;
786     using SafeMath for uint32;
787 
788     uint32 internal _burnRatePerTransferThousandth = 10;    // default of 1%, can go as low as 0.1%, or set to 0 to disable
789     uint32 internal _interestRatePerBuyThousandth = 20;         // default of 2%, can go as low as 0.1%, or set to 0 to disable
790     
791     address internal constant uniswapV2FactoryAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
792     
793     mapping(address => bool) internal _burnWhitelistTo;
794     mapping(address => bool) internal _burnWhitelistFrom;
795     mapping(address => bool) internal _UniswapAddresses;
796     
797     /// @notice Transfers from IUniswapV2Pair at address `addr` now will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
798     /// @param addr Address of an IUniswapV2Pair Contract
799     event UniswapAddressAdded(address indexed addr);
800     /// @notice IUniswapV2Pair at address `addr` now will stop minting
801     event UniswapAddressRemoved(address indexed addr);
802     /// @notice The address `addr` is now whitelisted, any funds sent to it will not incur a burn. 
803     /// @param addr Address of Contract / EOA to whitelist
804     event AddedToWhitelistTo(address indexed addr);
805     /// @notice The address `addr` is removed from whitelist, any funds sent to it will now incur a burn of `_burnRatePerTransferThousandth`/1000 DIV tokens as normal. 
806     /// @param addr Address of Contract / EOA to whitelist
807     event RemovedFromWhitelistTo(address indexed addr);
808     /// @notice The address `addr` is now whitelisted, any funds sent FROM this address will not incur a burn. 
809     /// @param addr Address of Contract / EOA to whitelist
810     event AddedToWhitelistFrom(address indexed addr);
811     /// @notice The address `addr` is removed from whitelist, any funds sent FROM this address will now incur a burn of `_burnRatePerTransferThousandth`/1000 DIV tokens as normal. 
812     /// @param addr Address of Contract / EOA to whitelist
813     event RemovedFromWhitelistFrom(address indexed addr);
814     /// @notice The Burn rate has been changed to `newRate`/1000 per 1 DIV token on every transaction 
815     event BurnRateChanged(uint32 newRate);
816     /// @notice The Buy Interest rate has been changed to `newRate`/1000 per 1 DIV token on every transaction
817     event InterestRateChanged(uint32 newRate);
818     
819     constructor(address tokenOwnerWallet) ERC20("DIV Token 2", "DIV2") {
820         _mint(tokenOwnerWallet, 500000000000000000000000);
821     }
822     
823     /// @notice Changes the burn rate on transfers in thousandths
824     /// @param value Set this value in thousandths. Max of 50.  i.e. 10 = 1%, 1 = 0.1%, 0 = burns are disabled.
825     function setBurnRatePerThousandth(uint32 value) external onlyOwner {
826         // enforce a Max of 50 = 5%. 
827         _burnRatePerTransferThousandth = value;
828         validateContractParameters();
829         emit BurnRateChanged(value);
830     }
831 
832     /// @notice Changes the interest rate for purchases in thousandths
833     /// @param value Set this value in thousandths. Max of 50. i.e. 10 = 1%, 1 = 0.1%, 0 = interest is disabled.
834     function setInterestRatePerThousandth(uint32 value) external onlyOwner {
835         _interestRatePerBuyThousandth = value;
836         validateContractParameters();
837         emit InterestRateChanged(value);
838     }
839 
840     /// @notice Address `addr` will no longer incur the `_burnRatePerTransferThousandth`/1000 burn on Transfers
841     /// @param addr Address to whitelist / dewhitelist 
842     /// @param whitelisted True to add to whitelist, false to remove.
843     function setBurnWhitelistToAddress (address addr, bool whitelisted) external onlyOwner {
844         if(whitelisted) {
845             _burnWhitelistTo[addr] = whitelisted;
846             emit AddedToWhitelistTo(addr);
847         } else {
848             delete _burnWhitelistTo[addr];
849             emit RemovedFromWhitelistTo(addr);
850         }
851     }
852 
853     /// @notice Address `addr` will no longer incur the `_burnRatePerTransferThousandth`/1000 burn on Transfers from it.
854     /// @param addr Address to whitelist / dewhitelist 
855     /// @param whitelisted True to add to whitelist, false to remove.
856     function setBurnWhitelistFromAddress (address addr, bool whitelisted) external onlyOwner {
857         if(whitelisted) {
858             _burnWhitelistFrom[addr] = whitelisted;
859             emit AddedToWhitelistFrom(addr);
860         } else {
861             delete _burnWhitelistFrom[addr];
862             emit RemovedFromWhitelistFrom(addr);
863         }
864     }
865 
866     /// @notice Will query uniswapV2Factory to find a pair.  Pair now will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
867     /// @dev This will only work with the existing uniswapV2Factory and will require a new token overall if UniswapV3 comes out...etc.
868     /// @dev Hardcoding the factory pair in contract ensures someone can't create a fake uniswapV2Factory that would return a hardcoded EOA.
869     /// @param erc20token address of the ACTUAL ERC20 liquidity token, e.g. to mint on buys against WETH, pass in the WETH ERC20 address, not the uniswap LP Address.
870     /// @param generateInterest True to begin generating interest, false to remove.  
871     function enableInterestForToken (address erc20token, bool generateInterest) external onlyOwner {
872         // returns 0x0 if pair doesn't exist.
873         address uniswapV2Pair = IUniswapV2Factory(uniswapV2FactoryAddress).getPair(address(this), erc20token);
874         require(uniswapV2Pair != 0x0000000000000000000000000000000000000000, "EnableInterest: No valid pair exists for erc20token");
875         
876         if(generateInterest) {
877             _UniswapAddresses[uniswapV2Pair] = generateInterest;
878             emit UniswapAddressAdded(uniswapV2Pair);
879         } else {
880             delete _UniswapAddresses[uniswapV2Pair];
881             emit UniswapAddressRemoved(uniswapV2Pair);
882         }
883     }
884 
885     /// @notice This function can be used by Contract Owner to disperse tokens bypassing incurring penalties or interest.  The tokens will be sent from the Owner Address Balance.
886     /// @param dests Array of recipients
887     /// @param values Array of values. Ensure the values are in wei. i.e. you must multiply the amount of DIV tokens to be sent by 10**18.
888     function airdrop(address[] calldata dests, uint256[] calldata values) external onlyOwner returns (uint256) {
889         uint256 i = 0;
890         while (i < dests.length) {
891             ERC20._transfer(_msgSender(), dests[i], values[i]);
892             i += 1;
893         }
894         return(i);
895     }
896 
897     /// @notice Returns the burn rate on transfers in thousandths
898     function getBurnRatePerThousandth() external view returns (uint32) {  
899        return _burnRatePerTransferThousandth;
900     }
901     
902     /// @notice Returns the interest rate for purchases in thousandths
903     function getInterestRate() external view returns (uint32) {  
904        return _interestRatePerBuyThousandth;
905     }
906     
907     /// @notice If true, Address `addr` will not incur `_burnRatePerTransferThousandth`/1000 burn for any Transfers to it.
908     /// @param addr Address to check
909     /// @dev it is not trivial to return a mapping without incurring further storage costs
910     function isAddressWhitelistedTo(address addr) external view returns (bool) {
911         return _burnWhitelistTo[addr];
912     }
913     
914     /// @notice If true, Address `addr` will not incur `_burnRatePerTransferThousandth`/1000 burn for any Transfers from it.
915     /// @param addr Address to check
916     /// @dev it is not trivial to return a mapping without incurring further storage costs
917     function isAddressWhitelistedFrom(address addr) external view returns (bool) {
918         return _burnWhitelistFrom[addr];
919     }
920     
921     /// @notice If true, transfers from IUniswapV2Pair at address `addr` will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
922     /// @param addr Address to check
923     /// @dev it is not trivial to return a mapping without incurring further storage costs
924     function checkInterestGenerationForAddress(address addr) external view returns (bool) {
925         return _UniswapAddresses[addr];
926     }
927     
928     /**
929         @notice ERC20 transfer function overridden to add `_burnRatePerTransferThousandth`/1000 burn on transfers as well as `_interestRatePerBuyThousandth`/1000 interest for AMM purchases. 
930         @param amount amount in wei
931         
932         Burn rate is applied independently of the interest.
933         No reentrancy check required, since these functions are not transferring ether and only modifying internal balances.
934      */
935     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
936         // FROM uniswap address, mint interest tokens
937         // Constraint: Anyone in burn whitelist cannot receive interest, to reduce owner abuse possibility.  
938         // This means whitelisting uniswap for any reason will also turn off interest.
939         if(_UniswapAddresses[sender] && 
940             _interestRatePerBuyThousandth > 0 &&
941             !_burnWhitelistTo[recipient] && 
942             !_burnWhitelistFrom[sender]) {
943             super._mint(recipient, amount.mul(_interestRatePerBuyThousandth).div(1000));
944             // no need to adjust amount
945         }
946 
947         // Apply burn
948         if(!_burnWhitelistTo[recipient] && !_burnWhitelistFrom[sender] && _burnRatePerTransferThousandth>0) {
949             uint256 burnAmount = amount.mul(_burnRatePerTransferThousandth).div(1000);
950             super._burn(sender, burnAmount);
951 
952             // reduce the amount to be sent
953             amount = amount.sub(burnAmount);
954         }
955         
956         // Send the modified amount to recipient
957         super._transfer(sender, recipient, amount);
958     }
959 
960     /// @notice After modifying contract parameters, call this function to run internal consistency checks.
961     function validateContractParameters() internal view {
962         // These upper bounds have been added per community request
963         require(_burnRatePerTransferThousandth <= 50, "Error: Burn cannot be larger than 5%");
964         require(_interestRatePerBuyThousandth <= 50, "Error: Interest cannot be larger than 5%");
965         
966         // This is to avoid an owner accident/misuse, if uniswap can reward a larger amount than a single buy+sell, 
967         // that would allow anyone to drain the Uniswap pool with a flash loan.
968         // Since Uniswap fees are not considered, all Uniswap transactions are ultimately deflationary.
969         require(_interestRatePerBuyThousandth <= _burnRatePerTransferThousandth.mul(2), "Error: Interest cannot exceed 2*Burn");
970     }
971 }
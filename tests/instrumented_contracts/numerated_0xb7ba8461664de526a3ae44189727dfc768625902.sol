1 pragma solidity 0.6.6;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // SPDX-License-Identifier: MIT
162 /*
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with GSN meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address payable) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes memory) {
178         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
179         return msg.data;
180     }
181 }
182 
183 // SPDX-License-Identifier: MIT
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor () internal {
205         address msgSender = _msgSender();
206         _owner = msgSender;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     /**
226      * @dev Leaves the contract without owner. It will not be possible to call
227      * `onlyOwner` functions anymore. Can only be called by the current owner.
228      *
229      * NOTE: Renouncing ownership will leave the contract without an owner,
230      * thereby removing any functionality that is only available to the owner.
231      */
232     function renounceOwnership() public virtual onlyOwner {
233         emit OwnershipTransferred(_owner, address(0));
234         _owner = address(0);
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 }
247 
248 // SPDX-License-Identifier: MIT
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257 
258     /**
259      * @dev Returns the amount of tokens owned by `account`.
260      */
261     function balanceOf(address account) external view returns (uint256);
262 
263     /**
264      * @dev Moves `amount` tokens from the caller's account to `recipient`.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transfer(address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Returns the remaining number of tokens that `spender` will be
274      * allowed to spend on behalf of `owner` through {transferFrom}. This is
275      * zero by default.
276      *
277      * This value changes when {approve} or {transferFrom} are called.
278      */
279     function allowance(address owner, address spender) external view returns (uint256);
280 
281     /**
282      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * IMPORTANT: Beware that changing an allowance with this method brings the risk
287      * that someone may use both the old and the new allowance by unfortunate
288      * transaction ordering. One possible solution to mitigate this race
289      * condition is to first reduce the spender's allowance to 0 and set the
290      * desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address spender, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Moves `amount` tokens from `sender` to `recipient` using the
299      * allowance mechanism. `amount` is then deducted from the caller's
300      * allowance.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * Emits a {Transfer} event.
305      */
306     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Emitted when `value` tokens are moved from one account (`from`) to
310      * another (`to`).
311      *
312      * Note that `value` may be zero.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 value);
315 
316     /**
317      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
318      * a call to {approve}. `value` is the new allowance.
319      */
320     event Approval(address indexed owner, address indexed spender, uint256 value);
321 }
322 
323 // SPDX-License-Identifier: MIT
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * [IMPORTANT]
332      * ====
333      * It is unsafe to assume that an address for which this function returns
334      * false is an externally-owned account (EOA) and not a contract.
335      *
336      * Among others, `isContract` will return false for the following
337      * types of addresses:
338      *
339      *  - an externally-owned account
340      *  - a contract in construction
341      *  - an address where a contract will be created
342      *  - an address where a contract lived, but was destroyed
343      * ====
344      */
345     function isContract(address account) internal view returns (bool) {
346         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
347         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
348         // for accounts without code, i.e. `keccak256('')`
349         bytes32 codehash;
350         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
351         // solhint-disable-next-line no-inline-assembly
352         assembly { codehash := extcodehash(account) }
353         return (codehash != accountHash && codehash != 0x0);
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381      * @dev Performs a Solidity function call using a low level `call`. A
382      * plain`call` is an unsafe replacement for a function call: use this
383      * function instead.
384      *
385      * If `target` reverts with a revert reason, it is bubbled up by this
386      * function (like regular Solidity function calls).
387      *
388      * Returns the raw returned data. To convert to the expected return value,
389      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390      *
391      * Requirements:
392      *
393      * - `target` must be a contract.
394      * - calling `target` with `data` must not revert.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399       return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404      * `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         return _functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         return _functionCallWithValue(target, data, value, errorMessage);
436     }
437 
438     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
439         require(isContract(target), "Address: call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 // solhint-disable-next-line no-inline-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // SPDX-License-Identifier: MIT
463 /**
464  * @dev Implementation of the {IERC20} interface.
465  *
466  * This implementation is agnostic to the way tokens are created. This means
467  * that a supply mechanism has to be added in a derived contract using {_mint}.
468  * For a generic mechanism see {ERC20PresetMinterPauser}.
469  *
470  * TIP: For a detailed writeup see our guide
471  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
472  * to implement supply mechanisms].
473  *
474  * We have followed general OpenZeppelin guidelines: functions revert instead
475  * of returning `false` on failure. This behavior is nonetheless conventional
476  * and does not conflict with the expectations of ERC20 applications.
477  *
478  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
479  * This allows applications to reconstruct the allowance for all accounts just
480  * by listening to said events. Other implementations of the EIP may not emit
481  * these events, as it isn't required by the specification.
482  *
483  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
484  * functions have been added to mitigate the well-known issues around setting
485  * allowances. See {IERC20-approve}.
486  */
487 contract ERC20 is Context, IERC20 {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     mapping (address => uint256) private _balances;
492 
493     mapping (address => mapping (address => uint256)) private _allowances;
494 
495     uint256 private _totalSupply;
496 
497     string private _name;
498     string private _symbol;
499     uint256 private _decimals;
500 
501     /**
502      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
503      * a default value of 18.
504      *
505      * To select a different value for {decimals}, use {_setupDecimals}.
506      *
507      * All three of these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor (string memory name, string memory symbol) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = 18;
514     }
515 
516     /**
517      * @dev Returns the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev Returns the symbol of the token, usually a shorter version of the
525      * name.
526      */
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev Returns the number of decimals used to get its user representation.
533      * For example, if `decimals` equals `2`, a balance of `505` tokens should
534      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
535      *
536      * Tokens usually opt for a value of 18, imitating the relationship between
537      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
538      * called.
539      *
540      * NOTE: This information is only used for _display_ purposes: it in
541      * no way affects any of the arithmetic of the contract, including
542      * {IERC20-balanceOf} and {IERC20-transfer}.
543      */
544     function decimals() public view returns (uint256) {
545         return _decimals;
546     }
547 
548     /**
549      * @dev See {IERC20-totalSupply}.
550      */
551     function totalSupply() public virtual view override returns (uint256) {
552         return _totalSupply;
553     }
554 
555     /**
556      * @dev See {IERC20-balanceOf}.
557      */
558     function balanceOf(address account) public virtual view override returns (uint256) {
559         return _balances[account];
560     }
561 
562     /**
563      * @dev See {IERC20-transfer}.
564      *
565      * Requirements:
566      *
567      * - `recipient` cannot be the zero address.
568      * - the caller must have a balance of at least `amount`.
569      */
570     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
571         _transfer(_msgSender(), recipient, amount);
572         return true;
573     }
574 
575     /**
576      * @dev See {IERC20-allowance}.
577      */
578     function allowance(address owner, address spender) public view virtual override returns (uint256) {
579         return _allowances[owner][spender];
580     }
581 
582     /**
583      * @dev See {IERC20-approve}.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      */
589     function approve(address spender, uint256 amount) public virtual override returns (bool) {
590         _approve(_msgSender(), spender, amount);
591         return true;
592     }
593 
594     /**
595      * @dev See {IERC20-transferFrom}.
596      *
597      * Emits an {Approval} event indicating the updated allowance. This is not
598      * required by the EIP. See the note at the beginning of {ERC20};
599      *
600      * Requirements:
601      * - `sender` and `recipient` cannot be the zero address.
602      * - `sender` must have a balance of at least `amount`.
603      * - the caller must have allowance for ``sender``'s tokens of at least
604      * `amount`.
605      */
606     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
607         _transfer(sender, recipient, amount);
608         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
609         return true;
610     }
611 
612     /**
613      * @dev Atomically increases the allowance granted to `spender` by the caller.
614      *
615      * This is an alternative to {approve} that can be used as a mitigation for
616      * problems described in {IERC20-approve}.
617      *
618      * Emits an {Approval} event indicating the updated allowance.
619      *
620      * Requirements:
621      *
622      * - `spender` cannot be the zero address.
623      */
624     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
625         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
626         return true;
627     }
628 
629     /**
630      * @dev Atomically decreases the allowance granted to `spender` by the caller.
631      *
632      * This is an alternative to {approve} that can be used as a mitigation for
633      * problems described in {IERC20-approve}.
634      *
635      * Emits an {Approval} event indicating the updated allowance.
636      *
637      * Requirements:
638      *
639      * - `spender` cannot be the zero address.
640      * - `spender` must have allowance for the caller of at least
641      * `subtractedValue`.
642      */
643     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
644         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
645         return true;
646     }
647 
648     /**
649      * @dev Moves tokens `amount` from `sender` to `recipient`.
650      *
651      * This is internal function is equivalent to {transfer}, and can be used to
652      * e.g. implement automatic token fees, slashing mechanisms, etc.
653      *
654      * Emits a {Transfer} event.
655      *
656      * Requirements:
657      *
658      * - `sender` cannot be the zero address.
659      * - `recipient` cannot be the zero address.
660      * - `sender` must have a balance of at least `amount`.
661      */
662     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
663         require(sender != address(0), "ERC20: transfer from the zero address");
664         require(recipient != address(0), "ERC20: transfer to the zero address");
665 
666         _beforeTokenTransfer(sender, recipient, amount);
667 
668         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
669         _balances[recipient] = _balances[recipient].add(amount);
670         emit Transfer(sender, recipient, amount);
671     }
672 
673     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
674      * the total supply.
675      *
676      * Emits a {Transfer} event with `from` set to the zero address.
677      *
678      * Requirements
679      *
680      * - `to` cannot be the zero address.
681      */
682     function _mint(address account, uint256 amount) internal virtual {
683         require(account != address(0), "ERC20: mint to the zero address");
684 
685         _beforeTokenTransfer(address(0), account, amount);
686 
687         _totalSupply = _totalSupply.add(amount);
688         _balances[account] = _balances[account].add(amount);
689         emit Transfer(address(0), account, amount);
690     }
691 
692     /**
693      * @dev Destroys `amount` tokens from `account`, reducing the
694      * total supply.
695      *
696      * Emits a {Transfer} event with `to` set to the zero address.
697      *
698      * Requirements
699      *
700      * - `account` cannot be the zero address.
701      * - `account` must have at least `amount` tokens.
702      */
703     function _burn(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: burn from the zero address");
705 
706         _beforeTokenTransfer(account, address(0), amount);
707 
708         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
709         _totalSupply = _totalSupply.sub(amount);
710         emit Transfer(account, address(0), amount);
711     }
712 
713     /**
714      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
715      *
716      * This is internal function is equivalent to `approve`, and can be used to
717      * e.g. set automatic allowances for certain subsystems, etc.
718      *
719      * Emits an {Approval} event.
720      *
721      * Requirements:
722      *
723      * - `owner` cannot be the zero address.
724      * - `spender` cannot be the zero address.
725      */
726     function _approve(address owner, address spender, uint256 amount) internal virtual {
727         require(owner != address(0), "ERC20: approve from the zero address");
728         require(spender != address(0), "ERC20: approve to the zero address");
729 
730         _allowances[owner][spender] = amount;
731         emit Approval(owner, spender, amount);
732     }
733 
734     /**
735      * @dev Sets {decimals} to a value other than the default one of 18.
736      *
737      * WARNING: This function should only be called from the constructor. Most
738      * applications that interact with token contracts will not expect
739      * {decimals} to ever change, and may work incorrectly if it does.
740      */
741     function _setupDecimals(uint256 decimals_) internal {
742         _decimals = decimals_;
743     }
744 
745     /**
746      * @dev Hook that is called before any transfer of tokens. This includes
747      * minting and burning.
748      *
749      * Calling conditions:
750      *
751      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
752      * will be to transferred to `to`.
753      * - when `from` is zero, `amount` tokens will be minted for `to`.
754      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
755      * - `from` and `to` are never both zero.
756      *
757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
758      */
759     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
760 }
761 
762 /*
763 MIT License
764 
765 Copyright (c) 2018 requestnetwork
766 Copyright (c) 2018 Fragments, Inc.
767 
768 Permission is hereby granted, free of charge, to any person obtaining a copy
769 of this software and associated documentation files (the "Software"), to deal
770 in the Software without restriction, including without limitation the rights
771 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
772 copies of the Software, and to permit persons to whom the Software is
773 furnished to do so, subject to the following conditions:
774 
775 The above copyright notice and this permission notice shall be included in all
776 copies or substantial portions of the Software.
777 
778 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
779 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
780 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
781 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
782 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
783 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
784 SOFTWARE.
785 */
786 /**
787  * @title SafeMathInt
788  * @dev Math operations for int256 with overflow safety checks.
789  */
790 library SafeMathInt {
791     int256 private constant MIN_INT256 = int256(1) << 255;
792     int256 private constant MAX_INT256 = ~(int256(1) << 255);
793 
794     /**
795      * @dev Multiplies two int256 variables and fails on overflow.
796      */
797     function mul(int256 a, int256 b)
798         internal
799         pure
800         returns (int256)
801     {
802         int256 c = a * b;
803 
804         // Detect overflow when multiplying MIN_INT256 with -1
805         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
806         require((b == 0) || (c / b == a));
807         return c;
808     }
809 
810     /**
811      * @dev Division of two int256 variables and fails on overflow.
812      */
813     function div(int256 a, int256 b)
814         internal
815         pure
816         returns (int256)
817     {
818         // Prevent overflow when dividing MIN_INT256 by -1
819         require(b != -1 || a != MIN_INT256);
820 
821         // Solidity already throws when dividing by 0.
822         return a / b;
823     }
824 
825     /**
826      * @dev Subtracts two int256 variables and fails on overflow.
827      */
828     function sub(int256 a, int256 b)
829         internal
830         pure
831         returns (int256)
832     {
833         int256 c = a - b;
834         require((b >= 0 && c <= a) || (b < 0 && c > a));
835         return c;
836     }
837 
838     /**
839      * @dev Adds two int256 variables and fails on overflow.
840      */
841     function add(int256 a, int256 b)
842         internal
843         pure
844         returns (int256)
845     {
846         int256 c = a + b;
847         require((b >= 0 && c >= a) || (b < 0 && c < a));
848         return c;
849     }
850 
851     /**
852      * @dev Converts to absolute value, and fails on overflow.
853      */
854     function abs(int256 a)
855         internal
856         pure
857         returns (int256)
858     {
859         require(a != MIN_INT256);
860         return a < 0 ? -a : a;
861     }
862 }
863 
864 /*
865  __     __              _                 _                  _ 
866  \ \   / /             | |               | |                | |
867   \ \_/ / __ ___  _ __ | |_ __  _ __ ___ | |_ ___   ___ ___ | |
868    \   / '_ ` _ \| '_ \| | '_ \| '__/ _ \| __/ _ \ / __/ _ \| |
869     | || | | | | | |_) | | |_) | | | (_) | || (_) | (_| (_) | |
870     |_||_| |_| |_| .__/|_| .__/|_|  \___/ \__\___/ \___\___/|_|
871                  | |     | |                                   
872                  |_|     |_|
873 
874   credit to our big brother Ampleforth.                                                  
875 */
876 /**
877  * @title uFragments ERC20 token
878  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
879  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
880  *      combining tokens proportionally across all wallets.
881  *
882  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
883  *      We support splitting the currency in expansion and combining the currency on contraction by
884  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
885  */
886 contract UFragments is ERC20, Ownable {
887     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
888     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
889     // order to minimize this risk, we adhere to the following guidelines:
890     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
891     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
892     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
893     //    multiplying by the inverse rate, you should divide by the normal rate)
894     // 2) Gon balances converted into Fragments are always rounded down (truncated).
895     //
896     // We make the following guarantees:
897     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
898     //   be decreased by precisely x Fragments, and B's external balance will be precisely
899     //   increased by x Fragments.
900     //
901     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
902     // This is because, for any conversion function 'f()' that has non-zero rounding error,
903     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
904     using SafeMath for uint256;
905     using SafeMathInt for int256;
906 
907     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
908     event LogMonetaryPolicyUpdated(address monetaryPolicy);
909 
910     // Used for authentication
911     address public monetaryPolicy;
912 
913     modifier onlyMonetaryPolicy() {
914         require(msg.sender == monetaryPolicy);
915         _;
916     }
917 
918     modifier validRecipient(address to) {
919         require(to != address(0x0));
920         require(to != address(this));
921         _;
922     }
923 
924     uint256 private constant DECIMALS = 9;
925     uint256 private constant MAX_UINT256 = ~uint256(0);
926     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 11 * 10**5 * 10**DECIMALS;
927 
928     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
929     // Use the highest value that fits in a uint256 for max granularity.
930     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
931 
932     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
933     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
934 
935     uint256 private _totalSupply;
936     uint256 private _gonsPerFragment;
937     mapping(address => uint256) private _gonBalances;
938 
939     // This is denominated in Fragments, because the gons-fragments conversion might change before
940     // it's fully paid.
941     mapping (address => mapping (address => uint256)) private _allowedFragments;
942 
943 
944     constructor() 
945     ERC20("YMPL", "YMPL")
946     public {
947         ERC20._setupDecimals(DECIMALS);
948         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
949         _gonBalances[msg.sender] = TOTAL_GONS;
950         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
951 
952         emit Transfer(address(0x0), msg.sender, _totalSupply);
953     }
954 
955 
956     /**
957      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
958      */
959     function setMonetaryPolicy(address monetaryPolicy_)
960         external
961         onlyOwner
962     {
963         monetaryPolicy = monetaryPolicy_;
964         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
965     }
966 
967     /**
968      * @dev Notifies Fragments contract about a new rebase cycle.
969      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
970      * @return The total number of fragments after the supply adjustment.
971      */
972     function rebase(uint256 epoch, int256 supplyDelta)
973         external
974         onlyMonetaryPolicy
975         returns (uint256)
976     {
977         if (supplyDelta == 0) {
978             emit LogRebase(epoch, _totalSupply);
979             return _totalSupply;
980         }
981 
982         if (supplyDelta < 0) {
983             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
984         } else {
985             _totalSupply = _totalSupply.add(uint256(supplyDelta));
986         }
987 
988         if (_totalSupply > MAX_SUPPLY) {
989             _totalSupply = MAX_SUPPLY;
990         }
991 
992         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
993 
994         // From this point forward, _gonsPerFragment is taken as the source of truth.
995         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
996         // conversion rate.
997         // This means our applied supplyDelta can deviate from the requested supplyDelta,
998         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
999         //
1000         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
1001         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
1002         // ever increased, it must be re-included.
1003         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
1004 
1005         emit LogRebase(epoch, _totalSupply);
1006         return _totalSupply;
1007     }
1008 
1009     /**
1010      * @return The total number of fragments.
1011      */
1012     function totalSupply()
1013         public
1014         view
1015         override
1016         returns (uint256)
1017     {
1018         return _totalSupply;
1019     }
1020 
1021     /**
1022      * @param who The address to query.
1023      * @return The balance of the specified address.
1024      */
1025     function balanceOf(address who)
1026         public
1027         view
1028         override
1029         returns (uint256)
1030     {
1031         return _gonBalances[who].div(_gonsPerFragment);
1032     }
1033 
1034     /**
1035      * @dev Transfer tokens to a specified address.
1036      * @param to The address to transfer to.
1037      * @param value The amount to be transferred.
1038      * @return True on success, false otherwise.
1039      */
1040     function transfer(address to, uint256 value)
1041         public
1042         validRecipient(to)
1043         override
1044         returns (bool)
1045     {
1046         uint256 gonValue = value.mul(_gonsPerFragment);
1047         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
1048         _gonBalances[to] = _gonBalances[to].add(gonValue);
1049         emit Transfer(msg.sender, to, value);
1050         return true;
1051     }
1052 
1053     /**
1054      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1055      * @param owner_ The address which owns the funds.
1056      * @param spender The address which will spend the funds.
1057      * @return The number of tokens still available for the spender.
1058      */
1059     function allowance(address owner_, address spender)
1060         public
1061         view
1062         override
1063         returns (uint256)
1064     {
1065         return _allowedFragments[owner_][spender];
1066     }
1067 
1068     /**
1069      * @dev Transfer tokens from one address to another.
1070      * @param from The address you want to send tokens from.
1071      * @param to The address you want to transfer to.
1072      * @param value The amount of tokens to be transferred.
1073      */
1074     function transferFrom(address from, address to, uint256 value)
1075         public
1076         validRecipient(to)
1077         override
1078         returns (bool)
1079     {
1080         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
1081 
1082         uint256 gonValue = value.mul(_gonsPerFragment);
1083         _gonBalances[from] = _gonBalances[from].sub(gonValue);
1084         _gonBalances[to] = _gonBalances[to].add(gonValue);
1085         emit Transfer(from, to, value);
1086 
1087         return true;
1088     }
1089 
1090     /**
1091      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1092      * msg.sender. This method is included for ERC20 compatibility.
1093      * increaseAllowance and decreaseAllowance should be used instead.
1094      * Changing an allowance with this method brings the risk that someone may transfer both
1095      * the old and the new allowance - if they are both greater than zero - if a transfer
1096      * transaction is mined before the later approve() call is mined.
1097      *
1098      * @param spender The address which will spend the funds.
1099      * @param value The amount of tokens to be spent.
1100      */
1101     function approve(address spender, uint256 value)
1102         public
1103         override
1104         returns (bool)
1105     {
1106         _allowedFragments[msg.sender][spender] = value;
1107         emit Approval(msg.sender, spender, value);
1108         return true;
1109     }
1110 
1111     /**
1112      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1113      * This method should be used instead of approve() to avoid the double approval vulnerability
1114      * described above.
1115      * @param spender The address which will spend the funds.
1116      * @param addedValue The amount of tokens to increase the allowance by.
1117      */
1118     function increaseAllowance(address spender, uint256 addedValue)
1119         public
1120         override
1121         returns (bool)
1122     {
1123         _allowedFragments[msg.sender][spender] =
1124             _allowedFragments[msg.sender][spender].add(addedValue);
1125         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
1126         return true;
1127     }
1128 
1129     /**
1130      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1131      *
1132      * @param spender The address which will spend the funds.
1133      * @param subtractedValue The amount of tokens to decrease the allowance by.
1134      */
1135     function decreaseAllowance(address spender, uint256 subtractedValue)
1136         public
1137         override
1138         returns (bool)
1139     {
1140         uint256 oldValue = _allowedFragments[msg.sender][spender];
1141         if (subtractedValue >= oldValue) {
1142             _allowedFragments[msg.sender][spender] = 0;
1143         } else {
1144             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
1145         }
1146         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
1147         return true;
1148     }
1149 }
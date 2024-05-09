1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.12;
6 
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
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // File: @openzeppelin/contracts/math/SafeMath.sol
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies in extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         uint256 size;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { size := extcodesize(account) }
294         return size > 0;
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         return _functionCallWithValue(target, data, value, errorMessage);
377     }
378 
379     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
380         require(isContract(target), "Address: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
404 
405 
406 
407 /**
408  * @dev Implementation of the {IERC20} interface.
409  *
410  * This implementation is agnostic to the way tokens are created. This means
411  * that a supply mechanism has to be added in a derived contract using {_mint}.
412  * For a generic mechanism see {ERC20PresetMinterPauser}.
413  *
414  * TIP: For a detailed writeup see our guide
415  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
416  * to implement supply mechanisms].
417  *
418  * We have followed general OpenZeppelin guidelines: functions revert instead
419  * of returning `false` on failure. This behavior is nonetheless conventional
420  * and does not conflict with the expectations of ERC20 applications.
421  *
422  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
423  * This allows applications to reconstruct the allowance for all accounts just
424  * by listening to said events. Other implementations of the EIP may not emit
425  * these events, as it isn't required by the specification.
426  *
427  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
428  * functions have been added to mitigate the well-known issues around setting
429  * allowances. See {IERC20-approve}.
430  */
431 contract ERC20 is Context, IERC20 {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     mapping (address => uint256) private _balances;
436 
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     uint256 private _totalSupply;
440 
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444 
445     /**
446      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
447      * a default value of 18.
448      *
449      * To select a different value for {decimals}, use {_setupDecimals}.
450      *
451      * All three of these values are immutable: they can only be set once during
452      * construction.
453      */
454     constructor (string memory name, string memory symbol) public {
455         _name = name;
456         _symbol = symbol;
457         _decimals = 18;
458     }
459 
460     /**
461      * @dev Returns the name of the token.
462      */
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev Returns the symbol of the token, usually a shorter version of the
469      * name.
470      */
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
482      * called.
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals() public view returns (uint8) {
489         return _decimals;
490     }
491 
492     /**
493      * @dev See {IERC20-totalSupply}.
494      */
495     function totalSupply() public view override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     /**
500      * @dev See {IERC20-balanceOf}.
501      */
502     function balanceOf(address account) public view override returns (uint256) {
503         return _balances[account];
504     }
505 
506     /**
507      * @dev See {IERC20-transfer}.
508      *
509      * Requirements:
510      *
511      * - `recipient` cannot be the zero address.
512      * - the caller must have a balance of at least `amount`.
513      */
514     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
515         _transfer(_msgSender(), recipient, amount);
516         return true;
517     }
518 
519     /**
520      * @dev See {IERC20-allowance}.
521      */
522     function allowance(address owner, address spender) public view virtual override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     /**
527      * @dev See {IERC20-approve}.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      */
533     function approve(address spender, uint256 amount) public virtual override returns (bool) {
534         _approve(_msgSender(), spender, amount);
535         return true;
536     }
537 
538     /**
539      * @dev See {IERC20-transferFrom}.
540      *
541      * Emits an {Approval} event indicating the updated allowance. This is not
542      * required by the EIP. See the note at the beginning of {ERC20};
543      *
544      * Requirements:
545      * - `sender` and `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      * - the caller must have allowance for ``sender``'s tokens of at least
548      * `amount`.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(sender, recipient, amount);
552         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically decreases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      * - `spender` must have allowance for the caller of at least
585      * `subtractedValue`.
586      */
587     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
589         return true;
590     }
591 
592     /**
593      * @dev Moves tokens `amount` from `sender` to `recipient`.
594      *
595      * This is internal function is equivalent to {transfer}, and can be used to
596      * e.g. implement automatic token fees, slashing mechanisms, etc.
597      *
598      * Emits a {Transfer} event.
599      *
600      * Requirements:
601      *
602      * - `sender` cannot be the zero address.
603      * - `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      */
606     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
607         require(sender != address(0), "ERC20: transfer from the zero address");
608         require(recipient != address(0), "ERC20: transfer to the zero address");
609 
610         _beforeTokenTransfer(sender, recipient, amount);
611 
612         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
613         _balances[recipient] = _balances[recipient].add(amount);
614         emit Transfer(sender, recipient, amount);
615     }
616 
617     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618      * the total supply.
619      *
620      * Emits a {Transfer} event with `from` set to the zero address.
621      *
622      * Requirements
623      *
624      * - `to` cannot be the zero address.
625      */
626     function _mint(address account, uint256 amount) internal virtual {
627         require(account != address(0), "ERC20: mint to the zero address");
628 
629         _beforeTokenTransfer(address(0), account, amount);
630 
631         _totalSupply = _totalSupply.add(amount);
632         _balances[account] = _balances[account].add(amount);
633         emit Transfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _beforeTokenTransfer(account, address(0), amount);
651 
652         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
653         _totalSupply = _totalSupply.sub(amount);
654         emit Transfer(account, address(0), amount);
655     }
656 
657     /**
658      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
659      *
660      * This internal function is equivalent to `approve`, and can be used to
661      * e.g. set automatic allowances for certain subsystems, etc.
662      *
663      * Emits an {Approval} event.
664      *
665      * Requirements:
666      *
667      * - `owner` cannot be the zero address.
668      * - `spender` cannot be the zero address.
669      */
670     function _approve(address owner, address spender, uint256 amount) internal virtual {
671         require(owner != address(0), "ERC20: approve from the zero address");
672         require(spender != address(0), "ERC20: approve to the zero address");
673 
674         _allowances[owner][spender] = amount;
675         emit Approval(owner, spender, amount);
676     }
677 
678     /**
679      * @dev Sets {decimals} to a value other than the default one of 18.
680      *
681      * WARNING: This function should only be called from the constructor. Most
682      * applications that interact with token contracts will not expect
683      * {decimals} to ever change, and may work incorrectly if it does.
684      */
685     function _setupDecimals(uint8 decimals_) internal {
686         _decimals = decimals_;
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be to transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
704 }
705 
706 // File: @openzeppelin/contracts/access/Ownable.sol
707 
708 /**
709  * @dev Contract module which provides a basic access control mechanism, where
710  * there is an account (an owner) that can be granted exclusive access to
711  * specific functions.
712  *
713  * By default, the owner account will be the one that deploys the contract. This
714  * can later be changed with {transferOwnership}.
715  *
716  * This module is used through inheritance. It will make available the modifier
717  * `onlyOwner`, which can be applied to your functions to restrict their use to
718  * the owner.
719  */
720 contract Ownable is Context {
721     address private _owner;
722 
723     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
724 
725     /**
726      * @dev Initializes the contract setting the deployer as the initial owner.
727      */
728     constructor () internal {
729         address msgSender = _msgSender();
730         _owner = msgSender;
731         emit OwnershipTransferred(address(0), msgSender);
732     }
733 
734     /**
735      * @dev Returns the address of the current owner.
736      */
737     function owner() public view returns (address) {
738         return _owner;
739     }
740 
741     /**
742      * @dev Throws if called by any account other than the owner.
743      */
744     modifier onlyOwner() {
745         require(_owner == _msgSender(), "Ownable: caller is not the owner");
746         _;
747     }
748 
749     /**
750      * @dev Leaves the contract without owner. It will not be possible to call
751      * `onlyOwner` functions anymore. Can only be called by the current owner.
752      *
753      * NOTE: Renouncing ownership will leave the contract without an owner,
754      * thereby removing any functionality that is only available to the owner.
755      */
756     function renounceOwnership() public virtual onlyOwner {
757         emit OwnershipTransferred(_owner, address(0));
758         _owner = address(0);
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
763      * Can only be called by the current owner.
764      */
765     function transferOwnership(address newOwner) public virtual onlyOwner {
766         require(newOwner != address(0), "Ownable: new owner is the zero address");
767         emit OwnershipTransferred(_owner, newOwner);
768         _owner = newOwner;
769     }
770 }
771 
772 // File: contracts/VENIToken.sol
773 
774 // VENIToken with Governance.
775 contract VENIToken is ERC20("VENI", "VENI"), Ownable {
776     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (VENIAdmin).
777     function mint(address _to, uint256 _amount) public onlyOwner {
778         _mint(_to, _amount);
779         _moveDelegates(address(0), _delegates[_to], _amount);
780     }
781 
782     // Copied and modified from YAM code:
783     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
784     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
785     // Which is copied and modified from COMPOUND:
786     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
787 
788     /// @notice A record of each accounts delegate
789     mapping (address => address) internal _delegates;
790 
791     /// @notice A checkpoint for marking number of votes from a given block
792     struct Checkpoint {
793         uint32 fromBlock;
794         uint256 votes;
795     }
796 
797     /// @notice A record of votes checkpoints for each account, by index
798     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
799 
800     /// @notice The number of checkpoints for each account
801     mapping (address => uint32) public numCheckpoints;
802 
803     /// @notice The EIP-712 typehash for the contract's domain
804     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
805 
806     /// @notice The EIP-712 typehash for the delegation struct used by the contract
807     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
808 
809     /// @notice A record of states for signing / validating signatures
810     mapping (address => uint) public nonces;
811 
812     /// @notice An event thats emitted when an account changes its delegate
813     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
814 
815     /// @notice An event thats emitted when a delegate account's vote balance changes
816     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
817 
818     /**
819      * @notice Delegate votes from `msg.sender` to `delegatee`
820      * @param delegator The address to get delegatee for
821      */
822     function delegates(address delegator)
823     external
824     view
825     returns (address)
826     {
827         return _delegates[delegator];
828     }
829 
830     /**
831      * @notice Delegate votes from `msg.sender` to `delegatee`
832      * @param delegatee The address to delegate votes to
833      */
834     function delegate(address delegatee) external {
835         return _delegate(msg.sender, delegatee);
836     }
837 
838     /**
839      * @notice Delegates votes from signatory to `delegatee`
840      * @param delegatee The address to delegate votes to
841      * @param nonce The contract state required to match the signature
842      * @param expiry The time at which to expire the signature
843      * @param v The recovery byte of the signature
844      * @param r Half of the ECDSA signature pair
845      * @param s Half of the ECDSA signature pair
846      */
847     function delegateBySig(
848         address delegatee,
849         uint nonce,
850         uint expiry,
851         uint8 v,
852         bytes32 r,
853         bytes32 s
854     )
855     external
856     {
857         bytes32 domainSeparator = keccak256(
858             abi.encode(
859                 DOMAIN_TYPEHASH,
860                 keccak256(bytes(name())),
861                 getChainId(),
862                 address(this)
863             )
864         );
865 
866         bytes32 structHash = keccak256(
867             abi.encode(
868                 DELEGATION_TYPEHASH,
869                 delegatee,
870                 nonce,
871                 expiry
872             )
873         );
874 
875         bytes32 digest = keccak256(
876             abi.encodePacked(
877                 "\x19\x01",
878                 domainSeparator,
879                 structHash
880             )
881         );
882 
883         address signatory = ecrecover(digest, v, r, s);
884         require(signatory != address(0), "VENI::delegateBySig: invalid signature");
885         require(nonce == nonces[signatory]++, "VENI::delegateBySig: invalid nonce");
886         require(now <= expiry, "VENI::delegateBySig: signature expired");
887         return _delegate(signatory, delegatee);
888     }
889 
890     /**
891      * @notice Gets the current votes balance for `account`
892      * @param account The address to get votes balance
893      * @return The number of current votes for `account`
894      */
895     function getCurrentVotes(address account)
896     external
897     view
898     returns (uint256)
899     {
900         uint32 nCheckpoints = numCheckpoints[account];
901         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
902     }
903 
904     /**
905      * @notice Determine the prior number of votes for an account as of a block number
906      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
907      * @param account The address of the account to check
908      * @param blockNumber The block number to get the vote balance at
909      * @return The number of votes the account had as of the given block
910      */
911     function getPriorVotes(address account, uint blockNumber)
912     external
913     view
914     returns (uint256)
915     {
916         require(blockNumber < block.number, "VENI::getPriorVotes: not yet determined");
917 
918         uint32 nCheckpoints = numCheckpoints[account];
919         if (nCheckpoints == 0) {
920             return 0;
921         }
922 
923         // First check most recent balance
924         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
925             return checkpoints[account][nCheckpoints - 1].votes;
926         }
927 
928         // Next check implicit zero balance
929         if (checkpoints[account][0].fromBlock > blockNumber) {
930             return 0;
931         }
932 
933         uint32 lower = 0;
934         uint32 upper = nCheckpoints - 1;
935         while (upper > lower) {
936             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
937             Checkpoint memory cp = checkpoints[account][center];
938             if (cp.fromBlock == blockNumber) {
939                 return cp.votes;
940             } else if (cp.fromBlock < blockNumber) {
941                 lower = center;
942             } else {
943                 upper = center - 1;
944             }
945         }
946         return checkpoints[account][lower].votes;
947     }
948 
949     function _delegate(address delegator, address delegatee)
950     internal
951     {
952         address currentDelegate = _delegates[delegator];
953         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying VENIs (not scaled);
954         _delegates[delegator] = delegatee;
955 
956         emit DelegateChanged(delegator, currentDelegate, delegatee);
957 
958         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
959     }
960 
961     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
962         if (srcRep != dstRep && amount > 0) {
963             if (srcRep != address(0)) {
964                 // decrease old representative
965                 uint32 srcRepNum = numCheckpoints[srcRep];
966                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
967                 uint256 srcRepNew = srcRepOld.sub(amount);
968                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
969             }
970 
971             if (dstRep != address(0)) {
972                 // increase new representative
973                 uint32 dstRepNum = numCheckpoints[dstRep];
974                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
975                 uint256 dstRepNew = dstRepOld.add(amount);
976                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
977             }
978         }
979     }
980 
981     function _writeCheckpoint(
982         address delegatee,
983         uint32 nCheckpoints,
984         uint256 oldVotes,
985         uint256 newVotes
986     )
987     internal
988     {
989         uint32 blockNumber = safe32(block.number, "VENI::_writeCheckpoint: block number exceeds 32 bits");
990 
991         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
992             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
993         } else {
994             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
995             numCheckpoints[delegatee] = nCheckpoints + 1;
996         }
997 
998         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
999     }
1000 
1001     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1002         require(n < 2**32, errorMessage);
1003         return uint32(n);
1004     }
1005 
1006     function getChainId() internal pure returns (uint) {
1007         uint256 chainId;
1008         assembly { chainId := chainid() }
1009         return chainId;
1010     }
1011 }
1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.12;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
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
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies in extcodesize, which returns 0 for contracts in
290         // construction, since the code is only stored at the end of the
291         // constructor execution.
292 
293         uint256 size;
294         // solhint-disable-next-line no-inline-assembly
295         assembly { size := extcodesize(account) }
296         return size > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
319         (bool success, ) = recipient.call{ value: amount }("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain`call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342       return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
352         return _functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but also transferring `value` wei to `target`.
358      *
359      * Requirements:
360      *
361      * - the calling contract must have an ETH balance of at least `value`.
362      * - the called Solidity function must be `payable`.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         return _functionCallWithValue(target, data, value, errorMessage);
379     }
380 
381     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
382         require(isContract(target), "Address: call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
406 
407 
408 
409 
410 
411 
412 /**
413  * @dev Implementation of the {IERC20} interface.
414  *
415  * This implementation is agnostic to the way tokens are created. This means
416  * that a supply mechanism has to be added in a derived contract using {_mint}.
417  * For a generic mechanism see {ERC20PresetMinterPauser}.
418  *
419  * TIP: For a detailed writeup see our guide
420  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
421  * to implement supply mechanisms].
422  *
423  * We have followed general OpenZeppelin guidelines: functions revert instead
424  * of returning `false` on failure. This behavior is nonetheless conventional
425  * and does not conflict with the expectations of ERC20 applications.
426  *
427  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
428  * This allows applications to reconstruct the allowance for all accounts just
429  * by listening to said events. Other implementations of the EIP may not emit
430  * these events, as it isn't required by the specification.
431  *
432  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
433  * functions have been added to mitigate the well-known issues around setting
434  * allowances. See {IERC20-approve}.
435  */
436 contract ERC20 is Context, IERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     mapping (address => uint256) private _balances;
441 
442     mapping (address => mapping (address => uint256)) private _allowances;
443 
444     uint256 private _totalSupply;
445 
446     string private _name;
447     string private _symbol;
448     uint8 private _decimals;
449 
450     /**
451      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
452      * a default value of 18.
453      *
454      * To select a different value for {decimals}, use {_setupDecimals}.
455      *
456      * All three of these values are immutable: they can only be set once during
457      * construction.
458      */
459     constructor (string memory name, string memory symbol) public {
460         _name = name;
461         _symbol = symbol;
462         _decimals = 18;
463     }
464 
465     /**
466      * @dev Returns the name of the token.
467      */
468     function name() public view returns (string memory) {
469         return _name;
470     }
471 
472     /**
473      * @dev Returns the symbol of the token, usually a shorter version of the
474      * name.
475      */
476     function symbol() public view returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @dev Returns the number of decimals used to get its user representation.
482      * For example, if `decimals` equals `2`, a balance of `505` tokens should
483      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
484      *
485      * Tokens usually opt for a value of 18, imitating the relationship between
486      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
487      * called.
488      *
489      * NOTE: This information is only used for _display_ purposes: it in
490      * no way affects any of the arithmetic of the contract, including
491      * {IERC20-balanceOf} and {IERC20-transfer}.
492      */
493     function decimals() public view returns (uint8) {
494         return _decimals;
495     }
496 
497     /**
498      * @dev See {IERC20-totalSupply}.
499      */
500     function totalSupply() public view override returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     function balanceOf(address account) public view override returns (uint256) {
508         return _balances[account];
509     }
510 
511     /**
512      * @dev See {IERC20-transfer}.
513      *
514      * Requirements:
515      *
516      * - `recipient` cannot be the zero address.
517      * - the caller must have a balance of at least `amount`.
518      */
519     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-allowance}.
526      */
527     function allowance(address owner, address spender) public view virtual override returns (uint256) {
528         return _allowances[owner][spender];
529     }
530 
531     /**
532      * @dev See {IERC20-approve}.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public virtual override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20};
548      *
549      * Requirements:
550      * - `sender` and `recipient` cannot be the zero address.
551      * - `sender` must have a balance of at least `amount`.
552      * - the caller must have allowance for ``sender``'s tokens of at least
553      * `amount`.
554      */
555     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     /**
562      * @dev Atomically increases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically decreases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      * - `spender` must have allowance for the caller of at least
590      * `subtractedValue`.
591      */
592     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
594         return true;
595     }
596 
597     /**
598      * @dev Moves tokens `amount` from `sender` to `recipient`.
599      *
600      * This is internal function is equivalent to {transfer}, and can be used to
601      * e.g. implement automatic token fees, slashing mechanisms, etc.
602      *
603      * Emits a {Transfer} event.
604      *
605      * Requirements:
606      *
607      * - `sender` cannot be the zero address.
608      * - `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      */
611     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
614 
615         _beforeTokenTransfer(sender, recipient, amount);
616 
617         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
618         _balances[recipient] = _balances[recipient].add(amount);
619         emit Transfer(sender, recipient, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements
628      *
629      * - `to` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _beforeTokenTransfer(address(0), account, amount);
635 
636         _totalSupply = _totalSupply.add(amount);
637         _balances[account] = _balances[account].add(amount);
638         emit Transfer(address(0), account, amount);
639     }
640 
641     /**
642      * @dev Destroys `amount` tokens from `account`, reducing the
643      * total supply.
644      *
645      * Emits a {Transfer} event with `to` set to the zero address.
646      *
647      * Requirements
648      *
649      * - `account` cannot be the zero address.
650      * - `account` must have at least `amount` tokens.
651      */
652     function _burn(address account, uint256 amount) internal virtual {
653         require(account != address(0), "ERC20: burn from the zero address");
654 
655         _beforeTokenTransfer(account, address(0), amount);
656 
657         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
658         _totalSupply = _totalSupply.sub(amount);
659         emit Transfer(account, address(0), amount);
660     }
661 
662     /**
663      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
664      *
665      * This internal function is equivalent to `approve`, and can be used to
666      * e.g. set automatic allowances for certain subsystems, etc.
667      *
668      * Emits an {Approval} event.
669      *
670      * Requirements:
671      *
672      * - `owner` cannot be the zero address.
673      * - `spender` cannot be the zero address.
674      */
675     function _approve(address owner, address spender, uint256 amount) internal virtual {
676         require(owner != address(0), "ERC20: approve from the zero address");
677         require(spender != address(0), "ERC20: approve to the zero address");
678 
679         _allowances[owner][spender] = amount;
680         emit Approval(owner, spender, amount);
681     }
682 
683     /**
684      * @dev Sets {decimals} to a value other than the default one of 18.
685      *
686      * WARNING: This function should only be called from the constructor. Most
687      * applications that interact with token contracts will not expect
688      * {decimals} to ever change, and may work incorrectly if it does.
689      */
690     function _setupDecimals(uint8 decimals_) internal {
691         _decimals = decimals_;
692     }
693 
694     /**
695      * @dev Hook that is called before any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * will be to transferred to `to`.
702      * - when `from` is zero, `amount` tokens will be minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
709 }
710 
711 // File: @openzeppelin/contracts/access/Ownable.sol
712 
713 
714 /**
715  * @dev Contract module which provides a basic access control mechanism, where
716  * there is an account (an owner) that can be granted exclusive access to
717  * specific functions.
718  *
719  * By default, the owner account will be the one that deploys the contract. This
720  * can later be changed with {transferOwnership}.
721  *
722  * This module is used through inheritance. It will make available the modifier
723  * `onlyOwner`, which can be applied to your functions to restrict their use to
724  * the owner.
725  */
726 contract Ownable is Context {
727     address private _owner;
728 
729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731     /**
732      * @dev Initializes the contract setting the deployer as the initial owner.
733      */
734     constructor () internal {
735         address msgSender = _msgSender();
736         _owner = msgSender;
737         emit OwnershipTransferred(address(0), msgSender);
738     }
739 
740     /**
741      * @dev Returns the address of the current owner.
742      */
743     function owner() public view returns (address) {
744         return _owner;
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     modifier onlyOwner() {
751         require(_owner == _msgSender(), "Ownable: caller is not the owner");
752         _;
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public virtual onlyOwner {
763         emit OwnershipTransferred(_owner, address(0));
764         _owner = address(0);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         emit OwnershipTransferred(_owner, newOwner);
774         _owner = newOwner;
775     }
776 }
777 
778 
779 
780 
781 
782 // SteakToken with Governance.
783 contract SteakToken is ERC20("Steaks.finance", "STEAK"), Ownable {
784     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
785     function mint(address _to, uint256 _amount) public onlyOwner {
786         _mint(_to, _amount);
787         _moveDelegates(address(0), _delegates[_to], _amount);
788     }
789 
790     // Copied and modified from YAM code:
791     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
792     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
793     // Which is copied and modified from COMPOUND:
794     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
795 
796     /// @notice A record of each accounts delegate
797     mapping (address => address) internal _delegates;
798 
799     /// @notice A checkpoint for marking number of votes from a given block
800     struct Checkpoint {
801         uint32 fromBlock;
802         uint256 votes;
803     }
804 
805     /// @notice A record of votes checkpoints for each account, by index
806     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
807 
808     /// @notice The number of checkpoints for each account
809     mapping (address => uint32) public numCheckpoints;
810 
811     /// @notice The EIP-712 typehash for the contract's domain
812     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
813 
814     /// @notice The EIP-712 typehash for the delegation struct used by the contract
815     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
816 
817     /// @notice A record of states for signing / validating signatures
818     mapping (address => uint) public nonces;
819 
820       /// @notice An event thats emitted when an account changes its delegate
821     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
822 
823     /// @notice An event thats emitted when a delegate account's vote balance changes
824     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
825 
826     /**
827      * @notice Delegate votes from `msg.sender` to `delegatee`
828      * @param delegator The address to get delegatee for
829      */
830     function delegates(address delegator)
831         external
832         view
833         returns (address)
834     {
835         return _delegates[delegator];
836     }
837 
838    /**
839     * @notice Delegate votes from `msg.sender` to `delegatee`
840     * @param delegatee The address to delegate votes to
841     */
842     function delegate(address delegatee) external {
843         return _delegate(msg.sender, delegatee);
844     }
845 
846     /**
847      * @notice Delegates votes from signatory to `delegatee`
848      * @param delegatee The address to delegate votes to
849      * @param nonce The contract state required to match the signature
850      * @param expiry The time at which to expire the signature
851      * @param v The recovery byte of the signature
852      * @param r Half of the ECDSA signature pair
853      * @param s Half of the ECDSA signature pair
854      */
855     function delegateBySig(
856         address delegatee,
857         uint nonce,
858         uint expiry,
859         uint8 v,
860         bytes32 r,
861         bytes32 s
862     )
863         external
864     {
865         bytes32 domainSeparator = keccak256(
866             abi.encode(
867                 DOMAIN_TYPEHASH,
868                 keccak256(bytes(name())),
869                 getChainId(),
870                 address(this)
871             )
872         );
873 
874         bytes32 structHash = keccak256(
875             abi.encode(
876                 DELEGATION_TYPEHASH,
877                 delegatee,
878                 nonce,
879                 expiry
880             )
881         );
882 
883         bytes32 digest = keccak256(
884             abi.encodePacked(
885                 "\x19\x01",
886                 domainSeparator,
887                 structHash
888             )
889         );
890 
891         address signatory = ecrecover(digest, v, r, s);
892         require(signatory != address(0), "STEAK::delegateBySig: invalid signature");
893         require(nonce == nonces[signatory]++, "STEAK::delegateBySig: invalid nonce");
894         require(now <= expiry, "STEAK::delegateBySig: signature expired");
895         return _delegate(signatory, delegatee);
896     }
897 
898     /**
899      * @notice Gets the current votes balance for `account`
900      * @param account The address to get votes balance
901      * @return The number of current votes for `account`
902      */
903     function getCurrentVotes(address account)
904         external
905         view
906         returns (uint256)
907     {
908         uint32 nCheckpoints = numCheckpoints[account];
909         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
910     }
911 
912     /**
913      * @notice Determine the prior number of votes for an account as of a block number
914      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
915      * @param account The address of the account to check
916      * @param blockNumber The block number to get the vote balance at
917      * @return The number of votes the account had as of the given block
918      */
919     function getPriorVotes(address account, uint blockNumber)
920         external
921         view
922         returns (uint256)
923     {
924         require(blockNumber < block.number, "STEAK::getPriorVotes: not yet determined");
925 
926         uint32 nCheckpoints = numCheckpoints[account];
927         if (nCheckpoints == 0) {
928             return 0;
929         }
930 
931         // First check most recent balance
932         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
933             return checkpoints[account][nCheckpoints - 1].votes;
934         }
935 
936         // Next check implicit zero balance
937         if (checkpoints[account][0].fromBlock > blockNumber) {
938             return 0;
939         }
940 
941         uint32 lower = 0;
942         uint32 upper = nCheckpoints - 1;
943         while (upper > lower) {
944             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
945             Checkpoint memory cp = checkpoints[account][center];
946             if (cp.fromBlock == blockNumber) {
947                 return cp.votes;
948             } else if (cp.fromBlock < blockNumber) {
949                 lower = center;
950             } else {
951                 upper = center - 1;
952             }
953         }
954         return checkpoints[account][lower].votes;
955     }
956 
957     function _delegate(address delegator, address delegatee)
958         internal
959     {
960         address currentDelegate = _delegates[delegator];
961         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying STEAK (not scaled);
962         _delegates[delegator] = delegatee;
963 
964         emit DelegateChanged(delegator, currentDelegate, delegatee);
965 
966         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
967     }
968 
969     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
970         if (srcRep != dstRep && amount > 0) {
971             if (srcRep != address(0)) {
972                 // decrease old representative
973                 uint32 srcRepNum = numCheckpoints[srcRep];
974                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
975                 uint256 srcRepNew = srcRepOld.sub(amount);
976                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
977             }
978 
979             if (dstRep != address(0)) {
980                 // increase new representative
981                 uint32 dstRepNum = numCheckpoints[dstRep];
982                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
983                 uint256 dstRepNew = dstRepOld.add(amount);
984                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
985             }
986         }
987     }
988 
989     function _writeCheckpoint(
990         address delegatee,
991         uint32 nCheckpoints,
992         uint256 oldVotes,
993         uint256 newVotes
994     )
995         internal
996     {
997         uint32 blockNumber = safe32(block.number, "STEAK::_writeCheckpoint: block number exceeds 32 bits");
998 
999         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1000             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1001         } else {
1002             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1003             numCheckpoints[delegatee] = nCheckpoints + 1;
1004         }
1005 
1006         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1007     }
1008 
1009     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1010         require(n < 2**32, errorMessage);
1011         return uint32(n);
1012     }
1013 
1014     function getChainId() internal pure returns (uint) {
1015         uint256 chainId;
1016         assembly { chainId := chainid() }
1017         return chainId;
1018     }
1019 }
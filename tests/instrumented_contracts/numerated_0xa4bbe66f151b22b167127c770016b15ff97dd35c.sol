1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 pragma solidity ^0.6.0;
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
264 pragma solidity ^0.6.2;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies in extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { size := extcodesize(account) }
295         return size > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 /**
405  * @dev Implementation of the {IERC20} interface.
406  *
407  * This implementation is agnostic to the way tokens are created. This means
408  * that a supply mechanism has to be added in a derived contract using {_mint}.
409  * For a generic mechanism see {ERC20PresetMinterPauser}.
410  *
411  * TIP: For a detailed writeup see our guide
412  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
413  * to implement supply mechanisms].
414  *
415  * We have followed general OpenZeppelin guidelines: functions revert instead
416  * of returning `false` on failure. This behavior is nonetheless conventional
417  * and does not conflict with the expectations of ERC20 applications.
418  *
419  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
420  * This allows applications to reconstruct the allowance for all accounts just
421  * by listening to said events. Other implementations of the EIP may not emit
422  * these events, as it isn't required by the specification.
423  *
424  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
425  * functions have been added to mitigate the well-known issues around setting
426  * allowances. See {IERC20-approve}.
427  */
428 contract ERC20 is Context, IERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     mapping (address => uint256) private _balances;
433 
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     uint256 private _totalSupply;
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
444      * a default value of 18.
445      *
446      * To select a different value for {decimals}, use {_setupDecimals}.
447      *
448      * All three of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor (string memory name, string memory symbol) public {
452         _name = name;
453         _symbol = symbol;
454         _decimals = 18;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
479      * called.
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20};
540      *
541      * Requirements:
542      * - `sender` and `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      * - the caller must have allowance for ``sender``'s tokens of at least
545      * `amount`.
546      */
547     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     /**
554      * @dev Atomically increases the allowance granted to `spender` by the caller.
555      *
556      * This is an alternative to {approve} that can be used as a mitigation for
557      * problems described in {IERC20-approve}.
558      *
559      * Emits an {Approval} event indicating the updated allowance.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      */
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically decreases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      * - `spender` must have allowance for the caller of at least
582      * `subtractedValue`.
583      */
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     /**
590      * @dev Moves tokens `amount` from `sender` to `recipient`.
591      *
592      * This is internal function is equivalent to {transfer}, and can be used to
593      * e.g. implement automatic token fees, slashing mechanisms, etc.
594      *
595      * Emits a {Transfer} event.
596      *
597      * Requirements:
598      *
599      * - `sender` cannot be the zero address.
600      * - `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      */
603     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
604         require(sender != address(0), "ERC20: transfer from the zero address");
605         require(recipient != address(0), "ERC20: transfer to the zero address");
606 
607         _beforeTokenTransfer(sender, recipient, amount);
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _beforeTokenTransfer(address(0), account, amount);
627 
628         _totalSupply = _totalSupply.add(amount);
629         _balances[account] = _balances[account].add(amount);
630         emit Transfer(address(0), account, amount);
631     }
632 
633     /**
634      * @dev Destroys `amount` tokens from `account`, reducing the
635      * total supply.
636      *
637      * Emits a {Transfer} event with `to` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `account` cannot be the zero address.
642      * - `account` must have at least `amount` tokens.
643      */
644     function _burn(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: burn from the zero address");
646 
647         _beforeTokenTransfer(account, address(0), amount);
648 
649         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650         _totalSupply = _totalSupply.sub(amount);
651         emit Transfer(account, address(0), amount);
652     }
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
656      *
657      * This internal function is equivalent to `approve`, and can be used to
658      * e.g. set automatic allowances for certain subsystems, etc.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `owner` cannot be the zero address.
665      * - `spender` cannot be the zero address.
666      */
667     function _approve(address owner, address spender, uint256 amount) internal virtual {
668         require(owner != address(0), "ERC20: approve from the zero address");
669         require(spender != address(0), "ERC20: approve to the zero address");
670 
671         _allowances[owner][spender] = amount;
672         emit Approval(owner, spender, amount);
673     }
674 
675     /**
676      * @dev Sets {decimals} to a value other than the default one of 18.
677      *
678      * WARNING: This function should only be called from the constructor. Most
679      * applications that interact with token contracts will not expect
680      * {decimals} to ever change, and may work incorrectly if it does.
681      */
682     function _setupDecimals(uint8 decimals_) internal {
683         _decimals = decimals_;
684     }
685 
686     /**
687      * @dev Hook that is called before any transfer of tokens. This includes
688      * minting and burning.
689      *
690      * Calling conditions:
691      *
692      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
693      * will be to transferred to `to`.
694      * - when `from` is zero, `amount` tokens will be minted for `to`.
695      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
696      * - `from` and `to` are never both zero.
697      *
698      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
699      */
700     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
701 }
702 
703 pragma solidity ^0.6.0;
704 
705 
706 pragma solidity ^0.6.0;
707 
708 
709 /**
710  * @dev Contract module which provides a basic access control mechanism, where
711  * there is an account (an owner) that can be granted exclusive access to
712  * specific functions.
713  *
714  * By default, the owner account will be the one that deploys the contract. This
715  * can later be changed with {transferOwnership}.
716  *
717  * This module is used through inheritance. It will make available the modifier
718  * `onlyOwner`, which can be applied to your functions to restrict their use to
719  * the owner.
720  */
721 contract Ownable is Context {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor () internal {
730         address msgSender = _msgSender();
731         _owner = msgSender;
732         emit OwnershipTransferred(address(0), msgSender);
733     }
734 
735     /**
736      * @dev Returns the address of the current owner.
737      */
738     function owner() public view returns (address) {
739         return _owner;
740     }
741 
742     /**
743      * @dev Throws if called by any account other than the owner.
744      */
745     modifier onlyOwner() {
746         require(_owner == _msgSender(), "Ownable: caller is not the owner");
747         _;
748     }
749 
750     /**
751      * @dev Leaves the contract without owner. It will not be possible to call
752      * `onlyOwner` functions anymore. Can only be called by the current owner.
753      *
754      * NOTE: Renouncing ownership will leave the contract without an owner,
755      * thereby removing any functionality that is only available to the owner.
756      */
757     function renounceOwnership() public virtual onlyOwner {
758         emit OwnershipTransferred(_owner, address(0));
759         _owner = address(0);
760     }
761 
762     /**
763      * @dev Transfers ownership of the contract to a new account (`newOwner`).
764      * Can only be called by the current owner.
765      */
766     function transferOwnership(address newOwner) public virtual onlyOwner {
767         require(newOwner != address(0), "Ownable: new owner is the zero address");
768         emit OwnershipTransferred(_owner, newOwner);
769         _owner = newOwner;
770     }
771 }
772 
773 // UmbriaToken with Governance.
774 contract UmbriaToken is ERC20("UmbriaToken", "UMBR"), Ownable {
775     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
776     function mint(address _to, uint256 _amount) public onlyOwner {
777         _mint(_to, _amount);
778         _moveDelegates(address(0), _delegates[_to], _amount);
779     }
780 
781     // Copied and modified from YAM code:
782     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
783     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
784     // Which is copied and modified from COMPOUND:
785     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
786 
787     /// @notice A record of each accounts delegate
788     mapping(address => address) internal _delegates;
789 
790     /// @notice A checkpoint for marking number of votes from a given block
791     struct Checkpoint {
792         uint32 fromBlock;
793         uint256 votes;
794     }
795 
796     /// @notice A record of votes checkpoints for each account, by index
797     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
798 
799     /// @notice The number of checkpoints for each account
800     mapping(address => uint32) public numCheckpoints;
801 
802     /// @notice The EIP-712 typehash for the contract's domain
803     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
804         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
805     );
806 
807     /// @notice The EIP-712 typehash for the delegation struct used by the contract
808     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
809         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
810     );
811 
812     /// @notice A record of states for signing / validating signatures
813     mapping(address => uint256) public nonces;
814 
815     /// @notice An event thats emitted when an account changes its delegate
816     event DelegateChanged(
817         address indexed delegator,
818         address indexed fromDelegate,
819         address indexed toDelegate
820     );
821 
822     /// @notice An event thats emitted when a delegate account's vote balance changes
823     event DelegateVotesChanged(
824         address indexed delegate,
825         uint256 previousBalance,
826         uint256 newBalance
827     );
828 
829     /**
830      * @notice Delegate votes from `msg.sender` to `delegatee`
831      * @param delegator The address to get delegatee for
832      */
833     function delegates(address delegator) external view returns (address) {
834         return _delegates[delegator];
835     }
836 
837     /**
838      * @notice Delegate votes from `msg.sender` to `delegatee`
839      * @param delegatee The address to delegate votes to
840      */
841     function delegate(address delegatee) external {
842         return _delegate(msg.sender, delegatee);
843     }
844 
845     /**
846      * @notice Delegates votes from signatory to `delegatee`
847      * @param delegatee The address to delegate votes to
848      * @param nonce The contract state required to match the signature
849      * @param expiry The time at which to expire the signature
850      * @param v The recovery byte of the signature
851      * @param r Half of the ECDSA signature pair
852      * @param s Half of the ECDSA signature pair
853      */
854     function delegateBySig(
855         address delegatee,
856         uint256 nonce,
857         uint256 expiry,
858         uint8 v,
859         bytes32 r,
860         bytes32 s
861     ) external {
862         bytes32 domainSeparator = keccak256(
863             abi.encode(
864                 DOMAIN_TYPEHASH,
865                 keccak256(bytes(name())),
866                 getChainId(),
867                 address(this)
868             )
869         );
870 
871         bytes32 structHash = keccak256(
872             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
873         );
874 
875         bytes32 digest = keccak256(
876             abi.encodePacked("\x19\x01", domainSeparator, structHash)
877         );
878 
879         address signatory = ecrecover(digest, v, r, s);
880         require(
881             signatory != address(0),
882             "UMBRIA::delegateBySig: invalid signature"
883         );
884         require(
885             nonce == nonces[signatory]++,
886             "UMBRIA::delegateBySig: invalid nonce"
887         );
888         require(now <= expiry, "UMBRIA::delegateBySig: signature expired");
889         return _delegate(signatory, delegatee);
890     }
891 
892     /**
893      * @notice Gets the current votes balance for `account`
894      * @param account The address to get votes balance
895      * @return The number of current votes for `account`
896      */
897     function getCurrentVotes(address account) external view returns (uint256) {
898         uint32 nCheckpoints = numCheckpoints[account];
899         return
900             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
901     }
902 
903     /**
904      * @notice Determine the prior number of votes for an account as of a block number
905      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
906      * @param account The address of the account to check
907      * @param blockNumber The block number to get the vote balance at
908      * @return The number of votes the account had as of the given block
909      */
910     function getPriorVotes(address account, uint256 blockNumber)
911         external
912         view
913         returns (uint256)
914     {
915         require(
916             blockNumber < block.number,
917             "UMBRIA::getPriorVotes: not yet determined"
918         );
919 
920         uint32 nCheckpoints = numCheckpoints[account];
921         if (nCheckpoints == 0) {
922             return 0;
923         }
924 
925         // First check most recent balance
926         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
927             return checkpoints[account][nCheckpoints - 1].votes;
928         }
929 
930         // Next check implicit zero balance
931         if (checkpoints[account][0].fromBlock > blockNumber) {
932             return 0;
933         }
934 
935         uint32 lower = 0;
936         uint32 upper = nCheckpoints - 1;
937         while (upper > lower) {
938             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
939             Checkpoint memory cp = checkpoints[account][center];
940             if (cp.fromBlock == blockNumber) {
941                 return cp.votes;
942             } else if (cp.fromBlock < blockNumber) {
943                 lower = center;
944             } else {
945                 upper = center - 1;
946             }
947         }
948         return checkpoints[account][lower].votes;
949     }
950 
951     function _delegate(address delegator, address delegatee) internal {
952         address currentDelegate = _delegates[delegator];
953         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying UMBRIAs (not scaled);
954         _delegates[delegator] = delegatee;
955 
956         emit DelegateChanged(delegator, currentDelegate, delegatee);
957 
958         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
959     }
960 
961     function _moveDelegates(
962         address srcRep,
963         address dstRep,
964         uint256 amount
965     ) internal {
966         if (srcRep != dstRep && amount > 0) {
967             if (srcRep != address(0)) {
968                 // decrease old representative
969                 uint32 srcRepNum = numCheckpoints[srcRep];
970                 uint256 srcRepOld = srcRepNum > 0
971                     ? checkpoints[srcRep][srcRepNum - 1].votes
972                     : 0;
973                 uint256 srcRepNew = srcRepOld.sub(amount);
974                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
975             }
976 
977             if (dstRep != address(0)) {
978                 // increase new representative
979                 uint32 dstRepNum = numCheckpoints[dstRep];
980                 uint256 dstRepOld = dstRepNum > 0
981                     ? checkpoints[dstRep][dstRepNum - 1].votes
982                     : 0;
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
994     ) internal {
995         uint32 blockNumber = safe32(
996             block.number,
997             "UMBRIA::_writeCheckpoint: block number exceeds 32 bits"
998         );
999 
1000         if (
1001             nCheckpoints > 0 &&
1002             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1003         ) {
1004             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1005         } else {
1006             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1007                 blockNumber,
1008                 newVotes
1009             );
1010             numCheckpoints[delegatee] = nCheckpoints + 1;
1011         }
1012 
1013         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1014     }
1015 
1016     function safe32(uint256 n, string memory errorMessage)
1017         internal
1018         pure
1019         returns (uint32)
1020     {
1021         require(n < 2**32, errorMessage);
1022         return uint32(n);
1023     }
1024 
1025     function getChainId() internal pure returns (uint256) {
1026         uint256 chainId;
1027         assembly {
1028             chainId := chainid()
1029         }
1030         return chainId;
1031     }
1032 }
1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
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
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Address.sol
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
403 
404 
405 /**
406  * @dev Implementation of the {IERC20} interface.
407  *
408  * This implementation is agnostic to the way tokens are created. This means
409  * that a supply mechanism has to be added in a derived contract using {_mint}.
410  * For a generic mechanism see {ERC20PresetMinterPauser}.
411  *
412  * TIP: For a detailed writeup see our guide
413  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
414  * to implement supply mechanisms].
415  *
416  * We have followed general OpenZeppelin guidelines: functions revert instead
417  * of returning `false` on failure. This behavior is nonetheless conventional
418  * and does not conflict with the expectations of ERC20 applications.
419  *
420  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
421  * This allows applications to reconstruct the allowance for all accounts just
422  * by listening to said events. Other implementations of the EIP may not emit
423  * these events, as it isn't required by the specification.
424  *
425  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
426  * functions have been added to mitigate the well-known issues around setting
427  * allowances. See {IERC20-approve}.
428  */
429 contract ERC20 is Context, IERC20 {
430     using SafeMath for uint256;
431     using Address for address;
432 
433     mapping (address => uint256) private _balances;
434 
435     mapping (address => mapping (address => uint256)) private _allowances;
436 
437     uint256 private _totalSupply;
438 
439     string private _name;
440     string private _symbol;
441     uint8 private _decimals;
442 
443     /**
444      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
445      * a default value of 18.
446      *
447      * To select a different value for {decimals}, use {_setupDecimals}.
448      *
449      * All three of these values are immutable: they can only be set once during
450      * construction.
451      */
452     constructor (string memory name, string memory symbol) public {
453         _name = name;
454         _symbol = symbol;
455         _decimals = 18;
456     }
457 
458     /**
459      * @dev Returns the name of the token.
460      */
461     function name() public view returns (string memory) {
462         return _name;
463     }
464 
465     /**
466      * @dev Returns the symbol of the token, usually a shorter version of the
467      * name.
468      */
469     function symbol() public view returns (string memory) {
470         return _symbol;
471     }
472 
473     /**
474      * @dev Returns the number of decimals used to get its user representation.
475      * For example, if `decimals` equals `2`, a balance of `505` tokens should
476      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
477      *
478      * Tokens usually opt for a value of 18, imitating the relationship between
479      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
480      * called.
481      *
482      * NOTE: This information is only used for _display_ purposes: it in
483      * no way affects any of the arithmetic of the contract, including
484      * {IERC20-balanceOf} and {IERC20-transfer}.
485      */
486     function decimals() public view returns (uint8) {
487         return _decimals;
488     }
489 
490     /**
491      * @dev See {IERC20-totalSupply}.
492      */
493     function totalSupply() public view override returns (uint256) {
494         return _totalSupply;
495     }
496 
497     /**
498      * @dev See {IERC20-balanceOf}.
499      */
500     function balanceOf(address account) public view override returns (uint256) {
501         return _balances[account];
502     }
503 
504     /**
505      * @dev See {IERC20-transfer}.
506      *
507      * Requirements:
508      *
509      * - `recipient` cannot be the zero address.
510      * - the caller must have a balance of at least `amount`.
511      */
512     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     /**
518      * @dev See {IERC20-allowance}.
519      */
520     function allowance(address owner, address spender) public view virtual override returns (uint256) {
521         return _allowances[owner][spender];
522     }
523 
524     /**
525      * @dev See {IERC20-approve}.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      */
531     function approve(address spender, uint256 amount) public virtual override returns (bool) {
532         _approve(_msgSender(), spender, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See {IERC20-transferFrom}.
538      *
539      * Emits an {Approval} event indicating the updated allowance. This is not
540      * required by the EIP. See the note at the beginning of {ERC20};
541      *
542      * Requirements:
543      * - `sender` and `recipient` cannot be the zero address.
544      * - `sender` must have a balance of at least `amount`.
545      * - the caller must have allowance for ``sender``'s tokens of at least
546      * `amount`.
547      */
548     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(sender, recipient, amount);
550         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
551         return true;
552     }
553 
554     /**
555      * @dev Atomically increases the allowance granted to `spender` by the caller.
556      *
557      * This is an alternative to {approve} that can be used as a mitigation for
558      * problems described in {IERC20-approve}.
559      *
560      * Emits an {Approval} event indicating the updated allowance.
561      *
562      * Requirements:
563      *
564      * - `spender` cannot be the zero address.
565      */
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     /**
572      * @dev Atomically decreases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      * - `spender` must have allowance for the caller of at least
583      * `subtractedValue`.
584      */
585     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
587         return true;
588     }
589 
590     /**
591      * @dev Moves tokens `amount` from `sender` to `recipient`.
592      *
593      * This is internal function is equivalent to {transfer}, and can be used to
594      * e.g. implement automatic token fees, slashing mechanisms, etc.
595      *
596      * Emits a {Transfer} event.
597      *
598      * Requirements:
599      *
600      * - `sender` cannot be the zero address.
601      * - `recipient` cannot be the zero address.
602      * - `sender` must have a balance of at least `amount`.
603      */
604     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
605         require(sender != address(0), "ERC20: transfer from the zero address");
606         require(recipient != address(0), "ERC20: transfer to the zero address");
607 
608         _beforeTokenTransfer(sender, recipient, amount);
609 
610         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
611         _balances[recipient] = _balances[recipient].add(amount);
612         emit Transfer(sender, recipient, amount);
613     }
614 
615     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
616      * the total supply.
617      *
618      * Emits a {Transfer} event with `from` set to the zero address.
619      *
620      * Requirements
621      *
622      * - `to` cannot be the zero address.
623      */
624     function _mint(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: mint to the zero address");
626 
627         _beforeTokenTransfer(address(0), account, amount);
628 
629         _totalSupply = _totalSupply.add(amount);
630         _balances[account] = _balances[account].add(amount);
631         emit Transfer(address(0), account, amount);
632     }
633 
634     /**
635      * @dev Destroys `amount` tokens from `account`, reducing the
636      * total supply.
637      *
638      * Emits a {Transfer} event with `to` set to the zero address.
639      *
640      * Requirements
641      *
642      * - `account` cannot be the zero address.
643      * - `account` must have at least `amount` tokens.
644      */
645     function _burn(address account, uint256 amount) internal virtual {
646         require(account != address(0), "ERC20: burn from the zero address");
647 
648         _beforeTokenTransfer(account, address(0), amount);
649 
650         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
651         _totalSupply = _totalSupply.sub(amount);
652         emit Transfer(account, address(0), amount);
653     }
654 
655     /**
656      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
657      *
658      * This is internal function is equivalent to `approve`, and can be used to
659      * e.g. set automatic allowances for certain subsystems, etc.
660      *
661      * Emits an {Approval} event.
662      *
663      * Requirements:
664      *
665      * - `owner` cannot be the zero address.
666      * - `spender` cannot be the zero address.
667      */
668     function _approve(address owner, address spender, uint256 amount) internal virtual {
669         require(owner != address(0), "ERC20: approve from the zero address");
670         require(spender != address(0), "ERC20: approve to the zero address");
671 
672         _allowances[owner][spender] = amount;
673         emit Approval(owner, spender, amount);
674     }
675 
676     /**
677      * @dev Sets {decimals} to a value other than the default one of 18.
678      *
679      * WARNING: This function should only be called from the constructor. Most
680      * applications that interact with token contracts will not expect
681      * {decimals} to ever change, and may work incorrectly if it does.
682      */
683     function _setupDecimals(uint8 decimals_) internal {
684         _decimals = decimals_;
685     }
686 
687     /**
688      * @dev Hook that is called before any transfer of tokens. This includes
689      * minting and burning.
690      *
691      * Calling conditions:
692      *
693      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
694      * will be to transferred to `to`.
695      * - when `from` is zero, `amount` tokens will be minted for `to`.
696      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
697      * - `from` and `to` are never both zero.
698      *
699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
700      */
701     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
702 }
703 
704 // File: @openzeppelin/contracts/access/Ownable.sol
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * By default, the owner account will be the one that deploys the contract. This
712  * can later be changed with {transferOwnership}.
713  *
714  * This module is used through inheritance. It will make available the modifier
715  * `onlyOwner`, which can be applied to your functions to restrict their use to
716  * the owner.
717  */
718 contract Ownable is Context {
719     address private _owner;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor () internal {
727         address msgSender = _msgSender();
728         _owner = msgSender;
729         emit OwnershipTransferred(address(0), msgSender);
730     }
731 
732     /**
733      * @dev Returns the address of the current owner.
734      */
735     function owner() public view returns (address) {
736         return _owner;
737     }
738 
739     /**
740      * @dev Throws if called by any account other than the owner.
741      */
742     modifier onlyOwner() {
743         require(_owner == _msgSender(), "Ownable: caller is not the owner");
744         _;
745     }
746 
747     /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * `onlyOwner` functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public virtual onlyOwner {
755         emit OwnershipTransferred(_owner, address(0));
756         _owner = address(0);
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         emit OwnershipTransferred(_owner, newOwner);
766         _owner = newOwner;
767     }
768 }
769 
770 // File: contracts/tokens/SodaToken.sol
771 
772 // This token is owned by ../strategies/CreateSoda.sol
773 contract SodaToken is ERC20("SodaToken", "SODA"), Ownable {
774 
775     /// @notice Creates `_amount` token to `_to`.
776     /// Must only be called by the owner (CreateSoda).
777     /// CreateSoda gurantees the maximum supply of SODA is 330,000,000
778     function mint(address _to, uint256 _amount) public onlyOwner {
779         _mint(_to, _amount);
780         _moveDelegates(address(0), _delegates[_to], _amount);
781     }
782 
783     // transfers delegate authority when sending a token.
784     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
785     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
786         super._transfer(sender, recipient, amount);
787         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
788     }
789 
790     /// @notice A record of each accounts delegate
791     mapping (address => address) internal _delegates;
792 
793     /// @notice A checkpoint for marking number of votes from a given block
794     struct Checkpoint {
795         uint32 fromBlock;
796         uint256 votes;
797     }
798 
799     /// @notice A record of votes checkpoints for each account, by index
800     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
801 
802     /// @notice The number of checkpoints for each account
803     mapping (address => uint32) public numCheckpoints;
804 
805     /// @notice The EIP-712 typehash for the contract's domain
806     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
807 
808     /// @notice The EIP-712 typehash for the delegation struct used by the contract
809     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
810 
811     /// @notice A record of states for signing / validating signatures
812     mapping (address => uint) public nonces;
813 
814       /// @notice An event thats emitted when an account changes its delegate
815     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
816 
817     /// @notice An event thats emitted when a delegate account's vote balance changes
818     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
819 
820     /**
821      * @notice Delegate votes from `msg.sender` to `delegatee`
822      * @param delegator The address to get delegatee for
823      */
824     function delegates(address delegator)
825         external
826         view
827         returns (address)
828     {
829         return _delegates[delegator];
830     }
831 
832    /**
833     * @notice Delegate votes from `msg.sender` to `delegatee`
834     * @param delegatee The address to delegate votes to
835     */
836     function delegate(address delegatee) external {
837         return _delegate(msg.sender, delegatee);
838     }
839 
840     /**
841      * @notice Delegates votes from signatory to `delegatee`
842      * @param delegatee The address to delegate votes to
843      * @param nonce The contract state required to match the signature
844      * @param expiry The time at which to expire the signature
845      * @param v The recovery byte of the signature
846      * @param r Half of the ECDSA signature pair
847      * @param s Half of the ECDSA signature pair
848      */
849     function delegateBySig(
850         address delegatee,
851         uint nonce,
852         uint expiry,
853         uint8 v,
854         bytes32 r,
855         bytes32 s
856     )
857         external
858     {
859         bytes32 domainSeparator = keccak256(
860             abi.encode(
861                 DOMAIN_TYPEHASH,
862                 keccak256(bytes(name())),
863                 getChainId(),
864                 address(this)
865             )
866         );
867 
868         bytes32 structHash = keccak256(
869             abi.encode(
870                 DELEGATION_TYPEHASH,
871                 delegatee,
872                 nonce,
873                 expiry
874             )
875         );
876 
877         bytes32 digest = keccak256(
878             abi.encodePacked(
879                 "\x19\x01",
880                 domainSeparator,
881                 structHash
882             )
883         );
884 
885         address signatory = ecrecover(digest, v, r, s);
886         require(signatory != address(0), "SODA::delegateBySig: invalid signature");
887         require(nonce == nonces[signatory]++, "SODA::delegateBySig: invalid nonce");
888         require(now <= expiry, "SODA::delegateBySig: signature expired");
889         return _delegate(signatory, delegatee);
890     }
891 
892     /**
893      * @notice Gets the current votes balance for `account`
894      * @param account The address to get votes balance
895      * @return The number of current votes for `account`
896      */
897     function getCurrentVotes(address account)
898         external
899         view
900         returns (uint256)
901     {
902         uint32 nCheckpoints = numCheckpoints[account];
903         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
904     }
905 
906     /**
907      * @notice Determine the prior number of votes for an account as of a block number
908      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
909      * @param account The address of the account to check
910      * @param blockNumber The block number to get the vote balance at
911      * @return The number of votes the account had as of the given block
912      */
913     function getPriorVotes(address account, uint blockNumber)
914         external
915         view
916         returns (uint256)
917     {
918         require(blockNumber < block.number, "SODA::getPriorVotes: not yet determined");
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
951     function _delegate(address delegator, address delegatee)
952         internal
953     {
954         address currentDelegate = _delegates[delegator];
955         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SODAs (not scaled);
956         _delegates[delegator] = delegatee;
957 
958         emit DelegateChanged(delegator, currentDelegate, delegatee);
959 
960         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
961     }
962 
963     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
964         if (srcRep != dstRep && amount > 0) {
965             if (srcRep != address(0)) {
966                 // decrease old representative
967                 uint32 srcRepNum = numCheckpoints[srcRep];
968                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
969                 uint256 srcRepNew = srcRepOld.sub(amount);
970                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
971             }
972 
973             if (dstRep != address(0)) {
974                 // increase new representative
975                 uint32 dstRepNum = numCheckpoints[dstRep];
976                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
977                 uint256 dstRepNew = dstRepOld.add(amount);
978                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
979             }
980         }
981     }
982 
983     function _writeCheckpoint(
984         address delegatee,
985         uint32 nCheckpoints,
986         uint256 oldVotes,
987         uint256 newVotes
988     )
989         internal
990     {
991         uint32 blockNumber = safe32(block.number, "SODA::_writeCheckpoint: block number exceeds 32 bits");
992 
993         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
994             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
995         } else {
996             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
997             numCheckpoints[delegatee] = nCheckpoints + 1;
998         }
999 
1000         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1001     }
1002 
1003     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1004         require(n < 2**32, errorMessage);
1005         return uint32(n);
1006     }
1007 
1008     function getChainId() internal pure returns (uint) {
1009         uint256 chainId;
1010         assembly { chainId := chainid() }
1011         return chainId;
1012     }
1013 }
1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.4.22 <0.8.0;
7 
8 // File: @openzeppelin/contracts/GSN/Context.sol
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
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
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
289         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
290         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
291         // for accounts without code, i.e. `keccak256('')`
292         bytes32 codehash;
293         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
294         // solhint-disable-next-line no-inline-assembly
295         assembly { codehash := extcodehash(account) }
296         return (codehash != accountHash && codehash != 0x0);
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
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20PresetMinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin guidelines: functions revert instead
420  * of returning `false` on failure. This behavior is nonetheless conventional
421  * and does not conflict with the expectations of ERC20 applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20 is Context, IERC20 {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     mapping (address => uint256) private _balances;
437 
438     mapping (address => mapping (address => uint256)) private _allowances;
439 
440     uint256 private _totalSupply;
441 
442     string private _name;
443     string private _symbol;
444     uint8 private _decimals;
445 
446     /**
447      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
448      * a default value of 18.
449      *
450      * To select a different value for {decimals}, use {_setupDecimals}.
451      *
452      * All three of these values are immutable: they can only be set once during
453      * construction.
454      */
455     constructor (string memory name, string memory symbol) public {
456         _name = name;
457         _symbol = symbol;
458         _decimals = 18;
459     }
460 
461     /**
462      * @dev Returns the name of the token.
463      */
464     function name() public view returns (string memory) {
465         return _name;
466     }
467 
468     /**
469      * @dev Returns the symbol of the token, usually a shorter version of the
470      * name.
471      */
472     function symbol() public view returns (string memory) {
473         return _symbol;
474     }
475 
476     /**
477      * @dev Returns the number of decimals used to get its user representation.
478      * For example, if `decimals` equals `2`, a balance of `505` tokens should
479      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
480      *
481      * Tokens usually opt for a value of 18, imitating the relationship between
482      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
483      * called.
484      *
485      * NOTE: This information is only used for _display_ purposes: it in
486      * no way affects any of the arithmetic of the contract, including
487      * {IERC20-balanceOf} and {IERC20-transfer}.
488      */
489     function decimals() public view returns (uint8) {
490         return _decimals;
491     }
492 
493     /**
494      * @dev See {IERC20-totalSupply}.
495      */
496     function totalSupply() public virtual view override returns (uint256) {
497         return _totalSupply;
498     }
499 
500     /**
501      * @dev See {IERC20-balanceOf}.
502      */
503     function balanceOf(address account) public virtual view override returns (uint256) {
504         return _balances[account];
505     }
506 
507     /**
508      * @dev See {IERC20-transfer}.
509      *
510      * Requirements:
511      *
512      * - `recipient` cannot be the zero address.
513      * - the caller must have a balance of at least `amount`.
514      */
515     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
516         _transfer(_msgSender(), recipient, amount);
517         return true;
518     }
519 
520     /**
521      * @dev See {IERC20-allowance}.
522      */
523     function allowance(address owner, address spender) public view virtual override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     /**
528      * @dev See {IERC20-approve}.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function approve(address spender, uint256 amount) public virtual override returns (bool) {
535         _approve(_msgSender(), spender, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-transferFrom}.
541      *
542      * Emits an {Approval} event indicating the updated allowance. This is not
543      * required by the EIP. See the note at the beginning of {ERC20};
544      *
545      * Requirements:
546      * - `sender` and `recipient` cannot be the zero address.
547      * - `sender` must have a balance of at least `amount`.
548      * - the caller must have allowance for ``sender``'s tokens of at least
549      * `amount`.
550      */
551     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
552         _transfer(sender, recipient, amount);
553         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
554         return true;
555     }
556 
557     /**
558      * @dev Atomically increases the allowance granted to `spender` by the caller.
559      *
560      * This is an alternative to {approve} that can be used as a mitigation for
561      * problems described in {IERC20-approve}.
562      *
563      * Emits an {Approval} event indicating the updated allowance.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
570         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically decreases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      * - `spender` must have allowance for the caller of at least
586      * `subtractedValue`.
587      */
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
590         return true;
591     }
592 
593     /**
594      * @dev Moves tokens `amount` from `sender` to `recipient`.
595      *
596      * This is internal function is equivalent to {transfer}, and can be used to
597      * e.g. implement automatic token fees, slashing mechanisms, etc.
598      *
599      * Emits a {Transfer} event.
600      *
601      * Requirements:
602      *
603      * - `sender` cannot be the zero address.
604      * - `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      */
607     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
608         require(sender != address(0), "ERC20: transfer from the zero address");
609         require(recipient != address(0), "ERC20: transfer to the zero address");
610 
611         _beforeTokenTransfer(sender, recipient, amount);
612 
613         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
614         _balances[recipient] = _balances[recipient].add(amount);
615         emit Transfer(sender, recipient, amount);
616     }
617 
618     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
619      * the total supply.
620      *
621      * Emits a {Transfer} event with `from` set to the zero address.
622      *
623      * Requirements
624      *
625      * - `to` cannot be the zero address.
626      */
627     function _mint(address account, uint256 amount) internal virtual {
628         require(account != address(0), "ERC20: mint to the zero address");
629 
630         _beforeTokenTransfer(address(0), account, amount);
631 
632         _totalSupply = _totalSupply.add(amount);
633         _balances[account] = _balances[account].add(amount);
634         emit Transfer(address(0), account, amount);
635     }
636 
637     /**
638      * @dev Destroys `amount` tokens from `account`, reducing the
639      * total supply.
640      *
641      * Emits a {Transfer} event with `to` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `account` cannot be the zero address.
646      * - `account` must have at least `amount` tokens.
647      */
648     function _burn(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: burn from the zero address");
650 
651         _beforeTokenTransfer(account, address(0), amount);
652 
653         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
654         _totalSupply = _totalSupply.sub(amount);
655         emit Transfer(account, address(0), amount);
656     }
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
660      *
661      * This is internal function is equivalent to `approve`, and can be used to
662      * e.g. set automatic allowances for certain subsystems, etc.
663      *
664      * Emits an {Approval} event.
665      *
666      * Requirements:
667      *
668      * - `owner` cannot be the zero address.
669      * - `spender` cannot be the zero address.
670      */
671     function _approve(address owner, address spender, uint256 amount) internal virtual {
672         require(owner != address(0), "ERC20: approve from the zero address");
673         require(spender != address(0), "ERC20: approve to the zero address");
674 
675         _allowances[owner][spender] = amount;
676         emit Approval(owner, spender, amount);
677     }
678 
679     /**
680      * @dev Sets {decimals} to a value other than the default one of 18.
681      *
682      * WARNING: This function should only be called from the constructor. Most
683      * applications that interact with token contracts will not expect
684      * {decimals} to ever change, and may work incorrectly if it does.
685      */
686     function _setupDecimals(uint8 decimals_) internal {
687         _decimals = decimals_;
688     }
689 
690     /**
691      * @dev Hook that is called before any transfer of tokens. This includes
692      * minting and burning.
693      *
694      * Calling conditions:
695      *
696      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
697      * will be to transferred to `to`.
698      * - when `from` is zero, `amount` tokens will be minted for `to`.
699      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
700      * - `from` and `to` are never both zero.
701      *
702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
703      */
704     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
705 }
706 
707 // File: contracts/CLT.sol
708 
709 /// @title CLT - ERC20 token. DeFi Token
710 /// @notice Increase residual value through token destory when transfer
711 contract CLT is ERC20 {
712   using SafeMath for uint256;
713   mapping (address => uint256) private _balances;
714   mapping (address => mapping (address => uint256)) private _allowed;
715 
716   string constant tokenName = "CLT";
717   string constant tokenSymbol = "CLT";
718   uint8  constant tokenDecimals = 18;
719   uint256 _totalSupply = 101010101010101010101010102;
720   uint256 public basePercent = 100;
721 
722   constructor() public payable ERC20(tokenName, tokenSymbol) {
723     _setupDecimals(tokenDecimals);
724     _issue(msg.sender, _totalSupply);
725   }
726 
727   /// @notice Returns total token supply
728   function totalSupply() public view override returns (uint256) {
729     return _totalSupply;
730   }
731 
732   /// @notice Returns user balance
733   function balanceOf(address owner) public view override returns (uint256) {
734     return _balances[owner];
735   }
736 
737   /// @notice Returns number of tokens that the owner has allowed the spender to withdraw
738   function allowance(address owner, address spender) public view virtual override returns (uint256) {
739     return _allowed[owner][spender];
740   }
741 
742   /// @notice Returns value of calculate the quantity to destory during transfer
743   function cut(uint256 value) public view returns (uint256)  {
744     uint256 c = value.add(basePercent);
745     uint256 d = c.sub(1);
746     uint256 roundValue = d.div(basePercent).mul(basePercent);
747     uint256 cutValue = roundValue.mul(basePercent).div(10000);
748     return cutValue;
749   }
750 
751   /// @notice From owner address sends value to address.
752   function transfer(address to, uint256 value) public virtual override returns (bool) {
753     require(value <= _balances[msg.sender]);
754     require(to != address(0));
755 
756     uint256 tokensToBurn = cut(value);
757     uint256 tokensToTransfer = value.sub(tokensToBurn);
758 
759     _balances[msg.sender] = _balances[msg.sender].sub(value);
760     _balances[to] = _balances[to].add(tokensToTransfer);
761 
762     _totalSupply = _totalSupply.sub(tokensToBurn);
763 
764     emit Transfer(msg.sender, to, tokensToTransfer);
765     emit Transfer(msg.sender, address(0), tokensToBurn);
766     return true;
767   }
768 
769   /// @notice Give Spender the right to withdraw as much tokens as value
770   function approve(address spender, uint256 value) public virtual override returns (bool) {
771     require(spender != address(0));
772     _allowed[msg.sender][spender] = value;
773     emit Approval(msg.sender, spender, value);
774     return true;
775   }
776 
777   /** @notice From address sends value to address.
778               However, this function can only be performed by a spender 
779               who is entitled to withdraw through the aprove function. 
780   */
781   function transferFrom(address from, address to, uint256 value) public virtual override returns (bool) {
782     require(value <= _balances[from]);
783     require(value <= _allowed[from][msg.sender]);
784     require(to != address(0));
785 
786     _balances[from] = _balances[from].sub(value);
787 
788     uint256 tokensToBurn = cut(value);
789     uint256 tokensToTransfer = value.sub(tokensToBurn);
790 
791     _balances[to] = _balances[to].add(tokensToTransfer);
792     _totalSupply = _totalSupply.sub(tokensToBurn);
793 
794     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
795 
796     emit Transfer(from, to, tokensToTransfer);
797     emit Transfer(from, address(0), tokensToBurn);
798 
799     return true;
800   }
801 
802   /// @notice Add the value of the privilege granted through the allowance function
803   function upAllowance(address spender, uint256 addedValue) public returns (bool) {
804     require(spender != address(0));
805     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
806     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
807     return true;
808   }
809 
810   /// @notice Subtract the value of the privilege granted through the allowance function
811   function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
812     require(spender != address(0));
813     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
814     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
815     return true;
816   }
817 
818   /// @notice Issue token from 0x address
819   function _issue(address account, uint256 amount) internal {
820     require(amount != 0);
821     _balances[account] = _balances[account].add(amount);
822     emit Transfer(address(0), account, amount);
823   }
824 
825   /// @notice Returns _destory function
826   function destroy(uint256 amount) external {
827     _destroy(msg.sender, amount);
828   }
829 
830   /// @notice Destroy the token by transferring it to the 0x address.
831   function _destroy(address account, uint256 amount) internal {
832     require(amount != 0);
833     require(amount <= _balances[account]);
834     _totalSupply = _totalSupply.sub(amount);
835     _balances[account] = _balances[account].sub(amount);
836     emit Transfer(account, address(0), amount);
837   }
838 
839   /** @notice From address sends value 0x address.
840               However, this function can only be performed by a spender 
841               who is entitled to withdraw through the aprove function. 
842   */
843   function destroyFrom(address account, uint256 amount) external {
844     require(amount <= _allowed[account][msg.sender]);
845     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
846     _destroy(account, amount);
847   }
848 }
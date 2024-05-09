1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 pragma solidity ^0.6.2;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
409 
410 pragma solidity ^0.6.0;
411 
412 
413 
414 
415 
416 /**
417  * @dev Implementation of the {IERC20} interface.
418  *
419  * This implementation is agnostic to the way tokens are created. This means
420  * that a supply mechanism has to be added in a derived contract using {_mint}.
421  * For a generic mechanism see {ERC20PresetMinterPauser}.
422  *
423  * TIP: For a detailed writeup see our guide
424  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
425  * to implement supply mechanisms].
426  *
427  * We have followed general OpenZeppelin guidelines: functions revert instead
428  * of returning `false` on failure. This behavior is nonetheless conventional
429  * and does not conflict with the expectations of ERC20 applications.
430  *
431  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
432  * This allows applications to reconstruct the allowance for all accounts just
433  * by listening to said events. Other implementations of the EIP may not emit
434  * these events, as it isn't required by the specification.
435  *
436  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
437  * functions have been added to mitigate the well-known issues around setting
438  * allowances. See {IERC20-approve}.
439  */
440 contract ERC20 is Context, IERC20 {
441     using SafeMath for uint256;
442     using Address for address;
443 
444     mapping (address => uint256) private _balances;
445 
446     mapping (address => mapping (address => uint256)) private _allowances;
447 
448     uint256 private _totalSupply;
449 
450     string private _name;
451     string private _symbol;
452     uint8 private _decimals;
453 
454     /**
455      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
456      * a default value of 18.
457      *
458      * To select a different value for {decimals}, use {_setupDecimals}.
459      *
460      * All three of these values are immutable: they can only be set once during
461      * construction.
462      */
463     constructor (string memory name, string memory symbol) public {
464         _name = name;
465         _symbol = symbol;
466         _decimals = 18;
467     }
468 
469     /**
470      * @dev Returns the name of the token.
471      */
472     function name() public view returns (string memory) {
473         return _name;
474     }
475 
476     /**
477      * @dev Returns the symbol of the token, usually a shorter version of the
478      * name.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @dev Returns the number of decimals used to get its user representation.
486      * For example, if `decimals` equals `2`, a balance of `505` tokens should
487      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
488      *
489      * Tokens usually opt for a value of 18, imitating the relationship between
490      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
491      * called.
492      *
493      * NOTE: This information is only used for _display_ purposes: it in
494      * no way affects any of the arithmetic of the contract, including
495      * {IERC20-balanceOf} and {IERC20-transfer}.
496      */
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     /**
502      * @dev See {IERC20-totalSupply}.
503      */
504     function totalSupply() public view override returns (uint256) {
505         return _totalSupply;
506     }
507 
508     /**
509      * @dev See {IERC20-balanceOf}.
510      */
511     function balanceOf(address account) public view override returns (uint256) {
512         return _balances[account];
513     }
514 
515     /**
516      * @dev See {IERC20-transfer}.
517      *
518      * Requirements:
519      *
520      * - `recipient` cannot be the zero address.
521      * - the caller must have a balance of at least `amount`.
522      */
523     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
524         _transfer(_msgSender(), recipient, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-allowance}.
530      */
531     function allowance(address owner, address spender) public view virtual override returns (uint256) {
532         return _allowances[owner][spender];
533     }
534 
535     /**
536      * @dev See {IERC20-approve}.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function approve(address spender, uint256 amount) public virtual override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-transferFrom}.
549      *
550      * Emits an {Approval} event indicating the updated allowance. This is not
551      * required by the EIP. See the note at the beginning of {ERC20};
552      *
553      * Requirements:
554      * - `sender` and `recipient` cannot be the zero address.
555      * - `sender` must have a balance of at least `amount`.
556      * - the caller must have allowance for ``sender``'s tokens of at least
557      * `amount`.
558      */
559     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
560         _transfer(sender, recipient, amount);
561         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
562         return true;
563     }
564 
565     /**
566      * @dev Atomically increases the allowance granted to `spender` by the caller.
567      *
568      * This is an alternative to {approve} that can be used as a mitigation for
569      * problems described in {IERC20-approve}.
570      *
571      * Emits an {Approval} event indicating the updated allowance.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      */
577     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
579         return true;
580     }
581 
582     /**
583      * @dev Atomically decreases the allowance granted to `spender` by the caller.
584      *
585      * This is an alternative to {approve} that can be used as a mitigation for
586      * problems described in {IERC20-approve}.
587      *
588      * Emits an {Approval} event indicating the updated allowance.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      * - `spender` must have allowance for the caller of at least
594      * `subtractedValue`.
595      */
596     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
597         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
598         return true;
599     }
600 
601     /**
602      * @dev Moves tokens `amount` from `sender` to `recipient`.
603      *
604      * This is internal function is equivalent to {transfer}, and can be used to
605      * e.g. implement automatic token fees, slashing mechanisms, etc.
606      *
607      * Emits a {Transfer} event.
608      *
609      * Requirements:
610      *
611      * - `sender` cannot be the zero address.
612      * - `recipient` cannot be the zero address.
613      * - `sender` must have a balance of at least `amount`.
614      */
615     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
616         require(sender != address(0), "ERC20: transfer from the zero address");
617         require(recipient != address(0), "ERC20: transfer to the zero address");
618 
619         _beforeTokenTransfer(sender, recipient, amount);
620 
621         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
622         _balances[recipient] = _balances[recipient].add(amount);
623         emit Transfer(sender, recipient, amount);
624     }
625 
626     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
627      * the total supply.
628      *
629      * Emits a {Transfer} event with `from` set to the zero address.
630      *
631      * Requirements
632      *
633      * - `to` cannot be the zero address.
634      */
635     function _mint(address account, uint256 amount) internal virtual {
636         require(account != address(0), "ERC20: mint to the zero address");
637 
638         _beforeTokenTransfer(address(0), account, amount);
639 
640         _totalSupply = _totalSupply.add(amount);
641         _balances[account] = _balances[account].add(amount);
642         emit Transfer(address(0), account, amount);
643     }
644 
645     /**
646      * @dev Destroys `amount` tokens from `account`, reducing the
647      * total supply.
648      *
649      * Emits a {Transfer} event with `to` set to the zero address.
650      *
651      * Requirements
652      *
653      * - `account` cannot be the zero address.
654      * - `account` must have at least `amount` tokens.
655      */
656     function _burn(address account, uint256 amount) internal virtual {
657         require(account != address(0), "ERC20: burn from the zero address");
658 
659         _beforeTokenTransfer(account, address(0), amount);
660 
661         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
662         _totalSupply = _totalSupply.sub(amount);
663         emit Transfer(account, address(0), amount);
664     }
665 
666     /**
667      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
668      *
669      * This is internal function is equivalent to `approve`, and can be used to
670      * e.g. set automatic allowances for certain subsystems, etc.
671      *
672      * Emits an {Approval} event.
673      *
674      * Requirements:
675      *
676      * - `owner` cannot be the zero address.
677      * - `spender` cannot be the zero address.
678      */
679     function _approve(address owner, address spender, uint256 amount) internal virtual {
680         require(owner != address(0), "ERC20: approve from the zero address");
681         require(spender != address(0), "ERC20: approve to the zero address");
682 
683         _allowances[owner][spender] = amount;
684         emit Approval(owner, spender, amount);
685     }
686 
687     /**
688      * @dev Sets {decimals} to a value other than the default one of 18.
689      *
690      * WARNING: This function should only be called from the constructor. Most
691      * applications that interact with token contracts will not expect
692      * {decimals} to ever change, and may work incorrectly if it does.
693      */
694     function _setupDecimals(uint8 decimals_) internal {
695         _decimals = decimals_;
696     }
697 
698     /**
699      * @dev Hook that is called before any transfer of tokens. This includes
700      * minting and burning.
701      *
702      * Calling conditions:
703      *
704      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
705      * will be to transferred to `to`.
706      * - when `from` is zero, `amount` tokens will be minted for `to`.
707      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
708      * - `from` and `to` are never both zero.
709      *
710      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
711      */
712     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
713 }
714 
715 // File: @openzeppelin/contracts/access/Ownable.sol
716 
717 pragma solidity ^0.6.0;
718 
719 /**
720  * @dev Contract module which provides a basic access control mechanism, where
721  * there is an account (an owner) that can be granted exclusive access to
722  * specific functions.
723  *
724  * By default, the owner account will be the one that deploys the contract. This
725  * can later be changed with {transferOwnership}.
726  *
727  * This module is used through inheritance. It will make available the modifier
728  * `onlyOwner`, which can be applied to your functions to restrict their use to
729  * the owner.
730  */
731 contract Ownable is Context {
732     address private _owner;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     /**
737      * @dev Initializes the contract setting the deployer as the initial owner.
738      */
739     constructor () internal {
740         address msgSender = _msgSender();
741         _owner = msgSender;
742         emit OwnershipTransferred(address(0), msgSender);
743     }
744 
745     /**
746      * @dev Returns the address of the current owner.
747      */
748     function owner() public view returns (address) {
749         return _owner;
750     }
751 
752     /**
753      * @dev Throws if called by any account other than the owner.
754      */
755     modifier onlyOwner() {
756         require(_owner == _msgSender(), "Ownable: caller is not the owner");
757         _;
758     }
759 
760     /**
761      * @dev Leaves the contract without owner. It will not be possible to call
762      * `onlyOwner` functions anymore. Can only be called by the current owner.
763      *
764      * NOTE: Renouncing ownership will leave the contract without an owner,
765      * thereby removing any functionality that is only available to the owner.
766      */
767     function renounceOwnership() public virtual onlyOwner {
768         emit OwnershipTransferred(_owner, address(0));
769         _owner = address(0);
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (`newOwner`).
774      * Can only be called by the current owner.
775      */
776     function transferOwnership(address newOwner) public virtual onlyOwner {
777         require(newOwner != address(0), "Ownable: new owner is the zero address");
778         emit OwnershipTransferred(_owner, newOwner);
779         _owner = newOwner;
780     }
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
784 
785 pragma solidity ^0.6.0;
786 
787 
788 
789 
790 /**
791  * @title SafeERC20
792  * @dev Wrappers around ERC20 operations that throw on failure (when the token
793  * contract returns false). Tokens that return no value (and instead revert or
794  * throw on failure) are also supported, non-reverting calls are assumed to be
795  * successful.
796  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
797  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
798  */
799 library SafeERC20 {
800     using SafeMath for uint256;
801     using Address for address;
802 
803     function safeTransfer(IERC20 token, address to, uint256 value) internal {
804         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
805     }
806 
807     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
808         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
809     }
810 
811     /**
812      * @dev Deprecated. This function has issues similar to the ones found in
813      * {IERC20-approve}, and its usage is discouraged.
814      *
815      * Whenever possible, use {safeIncreaseAllowance} and
816      * {safeDecreaseAllowance} instead.
817      */
818     function safeApprove(IERC20 token, address spender, uint256 value) internal {
819         // safeApprove should only be called when setting an initial allowance,
820         // or when resetting it to zero. To increase and decrease it, use
821         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
822         // solhint-disable-next-line max-line-length
823         require((value == 0) || (token.allowance(address(this), spender) == 0),
824             "SafeERC20: approve from non-zero to non-zero allowance"
825         );
826         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
827     }
828 
829     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
830         uint256 newAllowance = token.allowance(address(this), spender).add(value);
831         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
832     }
833 
834     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
835         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
836         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
837     }
838 
839     /**
840      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
841      * on the return value: the return value is optional (but if data is returned, it must not be false).
842      * @param token The token targeted by the call.
843      * @param data The call data (encoded using abi.encode or one of its variants).
844      */
845     function _callOptionalReturn(IERC20 token, bytes memory data) private {
846         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
847         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
848         // the target address contains contract code and also asserts for success in the low-level call.
849 
850         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
851         if (returndata.length > 0) { // Return data is optional
852             // solhint-disable-next-line max-line-length
853             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
854         }
855     }
856 }
857 
858 // File: contracts/MasterChef.sol
859 
860 pragma solidity 0.6.12;
861 
862 
863 
864 
865 
866 
867 // MasterChef is the master of JFI distribution. He can distribute JFI and he is a fair guy.
868 //
869 // Have fun reading it. Hopefully it's bug-free. God bless.
870 contract MasterChef is Ownable {
871     using SafeMath for uint256;
872     using SafeERC20 for IERC20;
873 
874     uint256 public constant ONE_MONTH_BLOCK = 172800; // 30 days
875     uint256 public constant DISTRIBUTE_FACTOR = 100;  // factor
876     uint256 public constant MONTH_BLOCK_FACTOR = 17280000; // month with factor
877 
878 
879     // Info of each user.
880     struct UserInfo {
881         uint256 amount;     // How many LP tokens / tokens the user has provided.
882         uint256 rewardDebt; // Reward debt. See explanation below.
883         //
884         // We do some fancy math here. Basically, any point in time, the amount of JFIs
885         // entitled to a user but is pending to be distributed is:
886         //
887         //   pending reward = (user.amount * pool.accJFIPerShare) - user.rewardDebt
888         //
889         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
890         //   1. The pool's `accJFIPerShare` (and `lastRewardBlock`) gets updated.
891         //   2. User receives the pending reward sent to his/her address.
892         //   3. User's `amount` gets updated.
893         //   4. User's `rewardDebt` gets updated.
894     }
895 
896     // Info of each pool.
897     struct PoolInfo {
898         IERC20 lpToken;           // Address of LP token / token contract.
899         uint256 distPoint;        // How many distribution points assigned to this pool. JFIs to distribute per block.
900         uint256 lastRewardBlock;  // Last block number that JFI distribution occurs.
901         uint256 accJFIPerShare;   // Accumulated JFI per share, times 1e12. See below.
902         uint256 leftJFI;          // left JFI this loop will distribute
903     }
904 
905     IERC20 public jfi;
906 
907     // Info of each pool.
908     PoolInfo[] public poolInfo;
909     // Info of each user that stakes LP tokens / tokens.
910     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
911     // Total distribution points. Must be the sum of all distribution points in all pools.
912     uint256 public totalDistPoint = 0;
913     // The block number when JFI mining starts.
914     uint256 public startBlock;
915     // total left JFIs for mining
916     uint256 public totalLeftJFI;
917     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
918     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
919     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
920 
921     constructor(
922         IERC20 _jfi,
923         uint256 _startBlock,
924         uint256 _totalJFI
925     ) public {
926         jfi = _jfi;
927         startBlock = _startBlock;
928         totalLeftJFI = _totalJFI;
929     }
930 
931     function poolLength() external view returns (uint256) {
932         return poolInfo.length;
933     }
934 
935     // Add a new lp / token to the pool. Can only be called by the owner.
936     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
937     function add(uint256 _distPoint, IERC20 _lpToken) public onlyOwner {
938         massUpdatePools();
939         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
940         totalDistPoint = totalDistPoint.add(_distPoint);
941         poolInfo.push(PoolInfo({
942             lpToken: _lpToken,
943             distPoint: _distPoint,
944             lastRewardBlock: lastRewardBlock,
945             accJFIPerShare: 0,
946             leftJFI: 0
947             }));
948         updatePoolsJfiLeftInternal();
949     }
950 
951     // need update left JFIs for all pools
952     function updatePoolsJfiLeftInternal() internal {
953         uint256 length = poolInfo.length;
954         for (uint256 pid = 0; pid < length; ++pid) {
955             poolInfo[pid].leftJFI = totalLeftJFI.mul(poolInfo[pid].distPoint).div(totalDistPoint);
956         }
957     }
958 
959     // Update the given pool's JFI distribution point. Can only be called by the owner.
960     function set(uint256 _pid, uint256 _distPoint, bool _withUpdate) public onlyOwner {
961         if (_withUpdate) {
962             massUpdatePools();
963         }
964         totalDistPoint = totalDistPoint.sub(poolInfo[_pid].distPoint).add(_distPoint);
965         poolInfo[_pid].distPoint = _distPoint;
966         updatePoolsJfiLeftInternal();
967     }
968 
969     // Return reward over the given _from to _to block.
970     // make sure updated every month
971     function viewRewardJFI(uint256 _from, uint256 _to, uint256 _poolsLeftJFI) public view returns (uint256) {
972         uint _endIndex = (_to.sub(startBlock)).div(ONE_MONTH_BLOCK);
973         uint _startIndex = (_from.sub(startBlock)).div(ONE_MONTH_BLOCK);
974         if (_startIndex == _endIndex) {
975             uint256 di = _to.sub(_from);
976             return di.mul(_poolsLeftJFI).div(MONTH_BLOCK_FACTOR);
977         } else {
978             uint256 _middle = _endIndex.mul(ONE_MONTH_BLOCK).add(startBlock);
979             uint256 _out = _middle.sub(_from).mul(_poolsLeftJFI).div(MONTH_BLOCK_FACTOR);
980             if (_to > _middle) {
981                 uint256 _month_jfi = _poolsLeftJFI.div(DISTRIBUTE_FACTOR);
982                 uint256 _nextJFIs = _poolsLeftJFI.sub(_month_jfi);
983                 uint256 _outNxt = _to.sub(_middle).mul(_nextJFIs).div(MONTH_BLOCK_FACTOR);
984                 _out = _out.add(_outNxt);
985             }
986             return _out;
987         }
988     }
989     // the same as viewRewardJFI just update pools left jfi
990     function getRewardJFI(uint256 _pid, uint256 _from, uint256 _to, uint256 _poolsLeftJFI) internal returns (uint256) {
991         if (_from >= _to) {
992             return 0;
993         }
994         uint _endIndex = (_to.sub(startBlock)).div(ONE_MONTH_BLOCK);
995         uint _startIndex = (_from.sub(startBlock)).div(ONE_MONTH_BLOCK);
996         if (_startIndex == _endIndex) {
997             return _to.sub(_from).mul(_poolsLeftJFI).div(MONTH_BLOCK_FACTOR);
998         } else {
999             uint256 _middle = _endIndex.mul(ONE_MONTH_BLOCK).add(startBlock);
1000             //last loop
1001             uint256 _out = _middle.sub(_from).mul(_poolsLeftJFI).div(MONTH_BLOCK_FACTOR);
1002             uint256 _month_jfi = _poolsLeftJFI.div(DISTRIBUTE_FACTOR);
1003             uint256 _nextJFIs = _poolsLeftJFI.sub(_month_jfi);
1004             if (_to > _middle) {
1005                 uint256 _outNxt = _to.sub(_middle).mul(_nextJFIs).div(MONTH_BLOCK_FACTOR);
1006                 _out = _out.add(_outNxt);
1007             }
1008             poolInfo[_pid].leftJFI = _nextJFIs;
1009             totalLeftJFI = totalLeftJFI.sub(_month_jfi);
1010             return _out;
1011         }
1012     }
1013 
1014     // View function to see pending JFIs on frontend.
1015     function pendingJFI(uint256 _pid, address _user) external view returns (uint256) {
1016         PoolInfo storage pool = poolInfo[_pid];
1017         UserInfo storage user = userInfo[_pid][_user];
1018         uint256 accJFIPerShare = pool.accJFIPerShare;
1019         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1020         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1021             uint256 jfiReward = viewRewardJFI(pool.lastRewardBlock, block.number, pool.leftJFI);
1022             accJFIPerShare = accJFIPerShare.add(jfiReward.mul(1e12).div(lpSupply));
1023         }
1024         return user.amount.mul(accJFIPerShare).div(1e12).sub(user.rewardDebt);
1025     }
1026 
1027     // Update reward vairables for all pools. Be careful of gas spending!
1028     function massUpdatePools() public {
1029         uint256 length = poolInfo.length;
1030         for (uint256 pid = 0; pid < length; ++pid) {
1031             updatePool(pid);
1032         }
1033     }
1034 
1035     // Update reward variables of the given pool to be up-to-date.
1036     function updatePool(uint256 _pid) public {
1037         PoolInfo storage pool = poolInfo[_pid];
1038         if (block.number <= pool.lastRewardBlock) {
1039             return;
1040         }
1041         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1042         if (lpSupply == 0) {
1043             pool.lastRewardBlock = block.number;
1044             return;
1045         }
1046         uint256 jfiReward = getRewardJFI(_pid, pool.lastRewardBlock, block.number, pool.leftJFI);
1047 //        totalLeftJFI = totalLeftJFI.sub(jfiReward);
1048         pool.accJFIPerShare = pool.accJFIPerShare.add(jfiReward.mul(1e12).div(lpSupply));
1049         pool.lastRewardBlock = block.number;
1050     }
1051 
1052     // Deposit LP tokens to MasterChef for JFI Distribution.
1053     function deposit(uint256 _pid, uint256 _amount) public {
1054         PoolInfo storage pool = poolInfo[_pid];
1055         UserInfo storage user = userInfo[_pid][msg.sender];
1056         updatePool(_pid);
1057         if (user.amount > 0) {
1058             uint256 pending = user.amount.mul(pool.accJFIPerShare).div(1e12).sub(user.rewardDebt);
1059             safeJFITransfer(msg.sender, pending);
1060         }
1061         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1062         user.amount = user.amount.add(_amount);
1063         user.rewardDebt = user.amount.mul(pool.accJFIPerShare).div(1e12);
1064         emit Deposit(msg.sender, _pid, _amount);
1065     }
1066 
1067     // Withdraw LP tokens / token from MasterChef.
1068     function withdraw(uint256 _pid, uint256 _amount) public {
1069         PoolInfo storage pool = poolInfo[_pid];
1070         UserInfo storage user = userInfo[_pid][msg.sender];
1071         require(user.amount >= _amount, "withdraw: not good");
1072         updatePool(_pid);
1073         uint256 pending = user.amount.mul(pool.accJFIPerShare).div(1e12).sub(user.rewardDebt);
1074         safeJFITransfer(msg.sender, pending);
1075         user.amount = user.amount.sub(_amount);
1076         user.rewardDebt = user.amount.mul(pool.accJFIPerShare).div(1e12);
1077         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1078         emit Withdraw(msg.sender, _pid, _amount);
1079     }
1080 
1081     // Withdraw without caring about rewards. EMERGENCY ONLY.
1082     function emergencyWithdraw(uint256 _pid) public {
1083         PoolInfo storage pool = poolInfo[_pid];
1084         UserInfo storage user = userInfo[_pid][msg.sender];
1085         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1086         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1087         user.amount = 0;
1088         user.rewardDebt = 0;
1089     }
1090 
1091     // Safe jfi transfer function, just in case if rounding error causes pool to not have enough JFIS.
1092     function safeJFITransfer(address _to, uint256 _amount) internal {
1093         jfi.transferFrom(owner(),_to, _amount);
1094     }
1095 }
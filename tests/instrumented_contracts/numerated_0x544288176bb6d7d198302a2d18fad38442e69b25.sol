1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 pragma solidity ^0.7.0;
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
106 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
107 
108 pragma solidity ^0.7.0;
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
266 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
267 
268 pragma solidity ^0.7.0;
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
408 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
409 
410 pragma solidity ^0.7.0;
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
463     constructor (string memory name_, string memory symbol_) {
464         _name = name_;
465         _symbol = symbol_;
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
667      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
668      *
669      * This internal function is equivalent to `approve`, and can be used to
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
715 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
716 
717 pragma solidity ^0.7.0;
718 
719 /**
720  * @dev Library for managing
721  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
722  * types.
723  *
724  * Sets have the following properties:
725  *
726  * - Elements are added, removed, and checked for existence in constant time
727  * (O(1)).
728  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
729  *
730  * ```
731  * contract Example {
732  *     // Add the library methods
733  *     using EnumerableSet for EnumerableSet.AddressSet;
734  *
735  *     // Declare a set state variable
736  *     EnumerableSet.AddressSet private mySet;
737  * }
738  * ```
739  *
740  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
741  * (`UintSet`) are supported.
742  */
743 library EnumerableSet {
744     // To implement this library for multiple types with as little code
745     // repetition as possible, we write it in terms of a generic Set type with
746     // bytes32 values.
747     // The Set implementation uses private functions, and user-facing
748     // implementations (such as AddressSet) are just wrappers around the
749     // underlying Set.
750     // This means that we can only create new EnumerableSets for types that fit
751     // in bytes32.
752 
753     struct Set {
754         // Storage of set values
755         bytes32[] _values;
756 
757         // Position of the value in the `values` array, plus 1 because index 0
758         // means a value is not in the set.
759         mapping (bytes32 => uint256) _indexes;
760     }
761 
762     /**
763      * @dev Add a value to a set. O(1).
764      *
765      * Returns true if the value was added to the set, that is if it was not
766      * already present.
767      */
768     function _add(Set storage set, bytes32 value) private returns (bool) {
769         if (!_contains(set, value)) {
770             set._values.push(value);
771             // The value is stored at length-1, but we add 1 to all indexes
772             // and use 0 as a sentinel value
773             set._indexes[value] = set._values.length;
774             return true;
775         } else {
776             return false;
777         }
778     }
779 
780     /**
781      * @dev Removes a value from a set. O(1).
782      *
783      * Returns true if the value was removed from the set, that is if it was
784      * present.
785      */
786     function _remove(Set storage set, bytes32 value) private returns (bool) {
787         // We read and store the value's index to prevent multiple reads from the same storage slot
788         uint256 valueIndex = set._indexes[value];
789 
790         if (valueIndex != 0) { // Equivalent to contains(set, value)
791             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
792             // the array, and then remove the last element (sometimes called as 'swap and pop').
793             // This modifies the order of the array, as noted in {at}.
794 
795             uint256 toDeleteIndex = valueIndex - 1;
796             uint256 lastIndex = set._values.length - 1;
797 
798             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
799             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
800 
801             bytes32 lastvalue = set._values[lastIndex];
802 
803             // Move the last value to the index where the value to delete is
804             set._values[toDeleteIndex] = lastvalue;
805             // Update the index for the moved value
806             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
807 
808             // Delete the slot where the moved value was stored
809             set._values.pop();
810 
811             // Delete the index for the deleted slot
812             delete set._indexes[value];
813 
814             return true;
815         } else {
816             return false;
817         }
818     }
819 
820     /**
821      * @dev Returns true if the value is in the set. O(1).
822      */
823     function _contains(Set storage set, bytes32 value) private view returns (bool) {
824         return set._indexes[value] != 0;
825     }
826 
827     /**
828      * @dev Returns the number of values on the set. O(1).
829      */
830     function _length(Set storage set) private view returns (uint256) {
831         return set._values.length;
832     }
833 
834    /**
835     * @dev Returns the value stored at position `index` in the set. O(1).
836     *
837     * Note that there are no guarantees on the ordering of values inside the
838     * array, and it may change when more values are added or removed.
839     *
840     * Requirements:
841     *
842     * - `index` must be strictly less than {length}.
843     */
844     function _at(Set storage set, uint256 index) private view returns (bytes32) {
845         require(set._values.length > index, "EnumerableSet: index out of bounds");
846         return set._values[index];
847     }
848 
849     // AddressSet
850 
851     struct AddressSet {
852         Set _inner;
853     }
854 
855     /**
856      * @dev Add a value to a set. O(1).
857      *
858      * Returns true if the value was added to the set, that is if it was not
859      * already present.
860      */
861     function add(AddressSet storage set, address value) internal returns (bool) {
862         return _add(set._inner, bytes32(uint256(value)));
863     }
864 
865     /**
866      * @dev Removes a value from a set. O(1).
867      *
868      * Returns true if the value was removed from the set, that is if it was
869      * present.
870      */
871     function remove(AddressSet storage set, address value) internal returns (bool) {
872         return _remove(set._inner, bytes32(uint256(value)));
873     }
874 
875     /**
876      * @dev Returns true if the value is in the set. O(1).
877      */
878     function contains(AddressSet storage set, address value) internal view returns (bool) {
879         return _contains(set._inner, bytes32(uint256(value)));
880     }
881 
882     /**
883      * @dev Returns the number of values in the set. O(1).
884      */
885     function length(AddressSet storage set) internal view returns (uint256) {
886         return _length(set._inner);
887     }
888 
889    /**
890     * @dev Returns the value stored at position `index` in the set. O(1).
891     *
892     * Note that there are no guarantees on the ordering of values inside the
893     * array, and it may change when more values are added or removed.
894     *
895     * Requirements:
896     *
897     * - `index` must be strictly less than {length}.
898     */
899     function at(AddressSet storage set, uint256 index) internal view returns (address) {
900         return address(uint256(_at(set._inner, index)));
901     }
902 
903 
904     // UintSet
905 
906     struct UintSet {
907         Set _inner;
908     }
909 
910     /**
911      * @dev Add a value to a set. O(1).
912      *
913      * Returns true if the value was added to the set, that is if it was not
914      * already present.
915      */
916     function add(UintSet storage set, uint256 value) internal returns (bool) {
917         return _add(set._inner, bytes32(value));
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function remove(UintSet storage set, uint256 value) internal returns (bool) {
927         return _remove(set._inner, bytes32(value));
928     }
929 
930     /**
931      * @dev Returns true if the value is in the set. O(1).
932      */
933     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
934         return _contains(set._inner, bytes32(value));
935     }
936 
937     /**
938      * @dev Returns the number of values on the set. O(1).
939      */
940     function length(UintSet storage set) internal view returns (uint256) {
941         return _length(set._inner);
942     }
943 
944    /**
945     * @dev Returns the value stored at position `index` in the set. O(1).
946     *
947     * Note that there are no guarantees on the ordering of values inside the
948     * array, and it may change when more values are added or removed.
949     *
950     * Requirements:
951     *
952     * - `index` must be strictly less than {length}.
953     */
954     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
955         return uint256(_at(set._inner, index));
956     }
957 }
958 
959 // File: @openzeppelin\contracts\access\AccessControl.sol
960 
961 pragma solidity ^0.7.0;
962 
963 
964 
965 
966 /**
967  * @dev Contract module that allows children to implement role-based access
968  * control mechanisms.
969  *
970  * Roles are referred to by their `bytes32` identifier. These should be exposed
971  * in the external API and be unique. The best way to achieve this is by
972  * using `public constant` hash digests:
973  *
974  * ```
975  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
976  * ```
977  *
978  * Roles can be used to represent a set of permissions. To restrict access to a
979  * function call, use {hasRole}:
980  *
981  * ```
982  * function foo() public {
983  *     require(hasRole(MY_ROLE, msg.sender));
984  *     ...
985  * }
986  * ```
987  *
988  * Roles can be granted and revoked dynamically via the {grantRole} and
989  * {revokeRole} functions. Each role has an associated admin role, and only
990  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
991  *
992  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
993  * that only accounts with this role will be able to grant or revoke other
994  * roles. More complex role relationships can be created by using
995  * {_setRoleAdmin}.
996  *
997  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
998  * grant and revoke this role. Extra precautions should be taken to secure
999  * accounts that have been granted it.
1000  */
1001 abstract contract AccessControl is Context {
1002     using EnumerableSet for EnumerableSet.AddressSet;
1003     using Address for address;
1004 
1005     struct RoleData {
1006         EnumerableSet.AddressSet members;
1007         bytes32 adminRole;
1008     }
1009 
1010     mapping (bytes32 => RoleData) private _roles;
1011 
1012     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1013 
1014     /**
1015      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1016      *
1017      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1018      * {RoleAdminChanged} not being emitted signaling this.
1019      *
1020      * _Available since v3.1._
1021      */
1022     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1023 
1024     /**
1025      * @dev Emitted when `account` is granted `role`.
1026      *
1027      * `sender` is the account that originated the contract call, an admin role
1028      * bearer except when using {_setupRole}.
1029      */
1030     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1031 
1032     /**
1033      * @dev Emitted when `account` is revoked `role`.
1034      *
1035      * `sender` is the account that originated the contract call:
1036      *   - if using `revokeRole`, it is the admin role bearer
1037      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1038      */
1039     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1040 
1041     /**
1042      * @dev Returns `true` if `account` has been granted `role`.
1043      */
1044     function hasRole(bytes32 role, address account) public view returns (bool) {
1045         return _roles[role].members.contains(account);
1046     }
1047 
1048     /**
1049      * @dev Returns the number of accounts that have `role`. Can be used
1050      * together with {getRoleMember} to enumerate all bearers of a role.
1051      */
1052     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1053         return _roles[role].members.length();
1054     }
1055 
1056     /**
1057      * @dev Returns one of the accounts that have `role`. `index` must be a
1058      * value between 0 and {getRoleMemberCount}, non-inclusive.
1059      *
1060      * Role bearers are not sorted in any particular way, and their ordering may
1061      * change at any point.
1062      *
1063      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1064      * you perform all queries on the same block. See the following
1065      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1066      * for more information.
1067      */
1068     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1069         return _roles[role].members.at(index);
1070     }
1071 
1072     /**
1073      * @dev Returns the admin role that controls `role`. See {grantRole} and
1074      * {revokeRole}.
1075      *
1076      * To change a role's admin, use {_setRoleAdmin}.
1077      */
1078     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1079         return _roles[role].adminRole;
1080     }
1081 
1082     /**
1083      * @dev Grants `role` to `account`.
1084      *
1085      * If `account` had not been already granted `role`, emits a {RoleGranted}
1086      * event.
1087      *
1088      * Requirements:
1089      *
1090      * - the caller must have ``role``'s admin role.
1091      */
1092     function grantRole(bytes32 role, address account) public virtual {
1093         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1094 
1095         _grantRole(role, account);
1096     }
1097 
1098     /**
1099      * @dev Revokes `role` from `account`.
1100      *
1101      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1102      *
1103      * Requirements:
1104      *
1105      * - the caller must have ``role``'s admin role.
1106      */
1107     function revokeRole(bytes32 role, address account) public virtual {
1108         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1109 
1110         _revokeRole(role, account);
1111     }
1112 
1113     /**
1114      * @dev Revokes `role` from the calling account.
1115      *
1116      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1117      * purpose is to provide a mechanism for accounts to lose their privileges
1118      * if they are compromised (such as when a trusted device is misplaced).
1119      *
1120      * If the calling account had been granted `role`, emits a {RoleRevoked}
1121      * event.
1122      *
1123      * Requirements:
1124      *
1125      * - the caller must be `account`.
1126      */
1127     function renounceRole(bytes32 role, address account) public virtual {
1128         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1129 
1130         _revokeRole(role, account);
1131     }
1132 
1133     /**
1134      * @dev Grants `role` to `account`.
1135      *
1136      * If `account` had not been already granted `role`, emits a {RoleGranted}
1137      * event. Note that unlike {grantRole}, this function doesn't perform any
1138      * checks on the calling account.
1139      *
1140      * [WARNING]
1141      * ====
1142      * This function should only be called from the constructor when setting
1143      * up the initial roles for the system.
1144      *
1145      * Using this function in any other way is effectively circumventing the admin
1146      * system imposed by {AccessControl}.
1147      * ====
1148      */
1149     function _setupRole(bytes32 role, address account) internal virtual {
1150         _grantRole(role, account);
1151     }
1152 
1153     /**
1154      * @dev Sets `adminRole` as ``role``'s admin role.
1155      *
1156      * Emits a {RoleAdminChanged} event.
1157      */
1158     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1159         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1160         _roles[role].adminRole = adminRole;
1161     }
1162 
1163     function _grantRole(bytes32 role, address account) private {
1164         if (_roles[role].members.add(account)) {
1165             emit RoleGranted(role, account, _msgSender());
1166         }
1167     }
1168 
1169     function _revokeRole(bytes32 role, address account) private {
1170         if (_roles[role].members.remove(account)) {
1171             emit RoleRevoked(role, account, _msgSender());
1172         }
1173     }
1174 }
1175 
1176 // File: contracts\GFarmToken.sol
1177 
1178 pragma solidity 0.7.5;
1179 
1180 
1181 
1182 contract GFarmToken is ERC20, AccessControl {
1183 
1184     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1185     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1186 
1187     constructor() ERC20("Gains", "GFARM") {
1188         // Set roles to dev => set roles for GFarm & GFarmTrading contracts => renounce roles
1189         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1190         _setupRole(MINTER_ROLE, msg.sender);
1191         _setupRole(BURNER_ROLE, msg.sender);
1192     }
1193 
1194     // Mint GFARM tokens (only GFarm & GFarmTrading contracts)
1195     function mint(address to, uint amount) external {
1196         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1197         _mint(to, amount);
1198     }
1199 
1200     // Burn GFARM tokens (only GFarmTrading contract)
1201     function burn(address from, uint amount) external {
1202         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
1203         _burn(from, amount);
1204     }
1205 }
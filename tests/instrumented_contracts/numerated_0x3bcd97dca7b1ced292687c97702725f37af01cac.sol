1 pragma solidity ^0.6.7;
2 
3 
4 // SPDX-License-Identifier: MIT
5 interface IController {
6     function jars(address) external view returns (address);
7 
8     function rewards() external view returns (address);
9 
10     function devfund() external view returns (address);
11 
12     function treasury() external view returns (address);
13 
14     function balanceOf(address) external view returns (uint256);
15 
16     function withdraw(address, uint256) external;
17 
18     function earn(address, uint256) external;
19 }
20 
21 /**
22  * @dev Wrappers over Solidity's arithmetic operations with added overflow
23  * checks.
24  *
25  * Arithmetic operations in Solidity wrap on overflow. This can easily result
26  * in bugs, because programmers usually assume that an overflow raises an
27  * error, which is the standard behavior in high level programming languages.
28  * `SafeMath` restores this intuition by reverting the transaction when an
29  * operation overflows.
30  *
31  * Using this library instead of the unchecked operations eliminates an entire
32  * class of bugs, so it's recommended to use it always.
33  */
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting on
37      * overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      *
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `*` operator.
88      *
89      * Requirements:
90      *
91      * - Multiplication cannot overflow.
92      */
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95         // benefit is lost if 'b' is also tested.
96         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
97         if (a == 0) {
98             return 0;
99         }
100 
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts on
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
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return mod(a, b, "SafeMath: modulo by zero");
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts with custom message when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b != 0, errorMessage);
173         return a % b;
174     }
175 }
176 
177 // SPDX-License-Identifier: MIT
178 /*
179  * @dev Provides information about the current execution context, including the
180  * sender of the transaction and its data. While these are generally available
181  * via msg.sender and msg.data, they should not be accessed in such a direct
182  * manner, since when dealing with GSN meta-transactions the account sending and
183  * paying for execution may not be the actual sender (as far as an application
184  * is concerned).
185  *
186  * This contract is only required for intermediate, library-like contracts.
187  */
188 abstract contract Context {
189     function _msgSender() internal view virtual returns (address payable) {
190         return msg.sender;
191     }
192 
193     function _msgData() internal view virtual returns (bytes memory) {
194         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
195         return msg.data;
196     }
197 }
198 
199 // File: contracts/GSN/Context.sol
200 // SPDX-License-Identifier: MIT
201 // File: contracts/token/ERC20/IERC20.sol
202 /**
203  * @dev Interface of the ERC20 standard as defined in the EIP.
204  */
205 interface IERC20 {
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `recipient`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Moves `amount` tokens from `sender` to `recipient` using the
252      * allowance mechanism. `amount` is then deducted from the caller's
253      * allowance.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Emitted when `value` tokens are moved from one account (`from`) to
263      * another (`to`).
264      *
265      * Note that `value` may be zero.
266      */
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     /**
270      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
271      * a call to {approve}. `value` is the new allowance.
272      */
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 // File: contracts/utils/Address.sol
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { size := extcodesize(account) }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: contracts/token/ERC20/ERC20.sol
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
715 /**
716  * @title SafeERC20
717  * @dev Wrappers around ERC20 operations that throw on failure (when the token
718  * contract returns false). Tokens that return no value (and instead revert or
719  * throw on failure) are also supported, non-reverting calls are assumed to be
720  * successful.
721  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
722  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
723  */
724 library SafeERC20 {
725     using SafeMath for uint256;
726     using Address for address;
727 
728     function safeTransfer(IERC20 token, address to, uint256 value) internal {
729         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
730     }
731 
732     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
733         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
734     }
735 
736     /**
737      * @dev Deprecated. This function has issues similar to the ones found in
738      * {IERC20-approve}, and its usage is discouraged.
739      *
740      * Whenever possible, use {safeIncreaseAllowance} and
741      * {safeDecreaseAllowance} instead.
742      */
743     function safeApprove(IERC20 token, address spender, uint256 value) internal {
744         // safeApprove should only be called when setting an initial allowance,
745         // or when resetting it to zero. To increase and decrease it, use
746         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
747         // solhint-disable-next-line max-line-length
748         require((value == 0) || (token.allowance(address(this), spender) == 0),
749             "SafeERC20: approve from non-zero to non-zero allowance"
750         );
751         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
752     }
753 
754     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
755         uint256 newAllowance = token.allowance(address(this), spender).add(value);
756         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
757     }
758 
759     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
760         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
761         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
762     }
763 
764     /**
765      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
766      * on the return value: the return value is optional (but if data is returned, it must not be false).
767      * @param token The token targeted by the call.
768      * @param data The call data (encoded using abi.encode or one of its variants).
769      */
770     function _callOptionalReturn(IERC20 token, bytes memory data) private {
771         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
772         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
773         // the target address contains contract code and also asserts for success in the low-level call.
774 
775         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
776         if (returndata.length > 0) { // Return data is optional
777             // solhint-disable-next-line max-line-length
778             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
779         }
780     }
781 }
782 
783 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
784 contract PickleJar is ERC20 {
785     using SafeERC20 for IERC20;
786     using Address for address;
787     using SafeMath for uint256;
788 
789     IERC20 public token;
790 
791     uint256 public min = 9500;
792     uint256 public constant max = 10000;
793 
794     address public governance;
795     address public timelock;
796     address public controller;
797 
798     constructor(address _token, address _governance, address _timelock, address _controller)
799         public
800         ERC20(
801             string(abi.encodePacked("pickling ", ERC20(_token).name())),
802             string(abi.encodePacked("p", ERC20(_token).symbol()))
803         )
804     {
805         _setupDecimals(ERC20(_token).decimals());
806         token = IERC20(_token);
807         governance = _governance;
808         timelock = _timelock;
809         controller = _controller;
810     }
811 
812     function balance() public view returns (uint256) {
813         return
814             token.balanceOf(address(this)).add(
815                 IController(controller).balanceOf(address(token))
816             );
817     }
818 
819     function setMin(uint256 _min) external {
820         require(msg.sender == governance, "!governance");
821         require(_min <= max, "numerator cannot be greater than denominator");
822         min = _min;
823     }
824 
825     function setGovernance(address _governance) public {
826         require(msg.sender == governance, "!governance");
827         governance = _governance;
828     }
829 
830     function setTimelock(address _timelock) public {
831         require(msg.sender == timelock, "!timelock");
832         timelock = _timelock;
833     }
834 
835     function setController(address _controller) public {
836         require(msg.sender == timelock, "!timelock");
837         controller = _controller;
838     }
839 
840     // Custom logic in here for how much the jars allows to be borrowed
841     // Sets minimum required on-hand to keep small withdrawals cheap
842     function available() public view returns (uint256) {
843         return token.balanceOf(address(this)).mul(min).div(max);
844     }
845 
846     function earn() public {
847         uint256 _bal = available();
848         token.safeTransfer(controller, _bal);
849         IController(controller).earn(address(token), _bal);
850     }
851 
852     function depositAll() external {
853         deposit(token.balanceOf(msg.sender));
854     }
855 
856     function deposit(uint256 _amount) public {
857         uint256 _pool = balance();
858         uint256 _before = token.balanceOf(address(this));
859         token.safeTransferFrom(msg.sender, address(this), _amount);
860         uint256 _after = token.balanceOf(address(this));
861         _amount = _after.sub(_before); // Additional check for deflationary tokens
862         uint256 shares = 0;
863         if (totalSupply() == 0) {
864             shares = _amount;
865         } else {
866             shares = (_amount.mul(totalSupply())).div(_pool);
867         }
868         _mint(msg.sender, shares);
869     }
870 
871     function withdrawAll() external {
872         withdraw(balanceOf(msg.sender));
873     }
874 
875     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
876     function harvest(address reserve, uint256 amount) external {
877         require(msg.sender == controller, "!controller");
878         require(reserve != address(token), "token");
879         IERC20(reserve).safeTransfer(controller, amount);
880     }
881 
882     // No rebalance implementation for lower fees and faster swaps
883     function withdraw(uint256 _shares) public {
884         uint256 r = (balance().mul(_shares)).div(totalSupply());
885         _burn(msg.sender, _shares);
886 
887         // Check balance
888         uint256 b = token.balanceOf(address(this));
889         if (b < r) {
890             uint256 _withdraw = r.sub(b);
891             IController(controller).withdraw(address(token), _withdraw);
892             uint256 _after = token.balanceOf(address(this));
893             uint256 _diff = _after.sub(b);
894             if (_diff < _withdraw) {
895                 r = b.add(_diff);
896             }
897         }
898 
899         token.safeTransfer(msg.sender, r);
900     }
901 
902     function getRatio() public view returns (uint256) {
903         return balance().mul(1e18).div(totalSupply());
904     }
905 }
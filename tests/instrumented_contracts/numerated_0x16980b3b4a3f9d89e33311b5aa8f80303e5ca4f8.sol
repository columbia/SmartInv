1 pragma solidity 0.6.2;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // SPDX-License-Identifier: MIT
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // SPDX-License-Identifier: MIT
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 // SPDX-License-Identifier: MIT
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies in extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // SPDX-License-Identifier: MIT
398 /**
399  * @dev Implementation of the {IERC20} interface.
400  *
401  * This implementation is agnostic to the way tokens are created. This means
402  * that a supply mechanism has to be added in a derived contract using {_mint}.
403  * For a generic mechanism see {ERC20PresetMinterPauser}.
404  *
405  * TIP: For a detailed writeup see our guide
406  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
407  * to implement supply mechanisms].
408  *
409  * We have followed general OpenZeppelin guidelines: functions revert instead
410  * of returning `false` on failure. This behavior is nonetheless conventional
411  * and does not conflict with the expectations of ERC20 applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20 {
423     using SafeMath for uint256;
424     using Address for address;
425 
426     mapping (address => uint256) private _balances;
427 
428     mapping (address => mapping (address => uint256)) private _allowances;
429 
430     uint256 private _totalSupply;
431 
432     string private _name;
433     string private _symbol;
434     uint8 private _decimals;
435 
436     /**
437      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
438      * a default value of 18.
439      *
440      * To select a different value for {decimals}, use {_setupDecimals}.
441      *
442      * All three of these values are immutable: they can only be set once during
443      * construction.
444      */
445     constructor (string memory name, string memory symbol) public {
446         _name = name;
447         _symbol = symbol;
448         _decimals = 18;
449     }
450 
451     /**
452      * @dev Returns the name of the token.
453      */
454     function name() public view returns (string memory) {
455         return _name;
456     }
457 
458     /**
459      * @dev Returns the symbol of the token, usually a shorter version of the
460      * name.
461      */
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     /**
467      * @dev Returns the number of decimals used to get its user representation.
468      * For example, if `decimals` equals `2`, a balance of `505` tokens should
469      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
470      *
471      * Tokens usually opt for a value of 18, imitating the relationship between
472      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
473      * called.
474      *
475      * NOTE: This information is only used for _display_ purposes: it in
476      * no way affects any of the arithmetic of the contract, including
477      * {IERC20-balanceOf} and {IERC20-transfer}.
478      */
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 
483     /**
484      * @dev See {IERC20-totalSupply}.
485      */
486     function totalSupply() public view override returns (uint256) {
487         return _totalSupply;
488     }
489 
490     /**
491      * @dev See {IERC20-balanceOf}.
492      */
493     function balanceOf(address account) public view override returns (uint256) {
494         return _balances[account];
495     }
496 
497     /**
498      * @dev See {IERC20-transfer}.
499      *
500      * Requirements:
501      *
502      * - `recipient` cannot be the zero address.
503      * - the caller must have a balance of at least `amount`.
504      */
505     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
506         _transfer(_msgSender(), recipient, amount);
507         return true;
508     }
509 
510     /**
511      * @dev See {IERC20-allowance}.
512      */
513     function allowance(address owner, address spender) public view virtual override returns (uint256) {
514         return _allowances[owner][spender];
515     }
516 
517     /**
518      * @dev See {IERC20-approve}.
519      *
520      * Requirements:
521      *
522      * - `spender` cannot be the zero address.
523      */
524     function approve(address spender, uint256 amount) public virtual override returns (bool) {
525         _approve(_msgSender(), spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20};
534      *
535      * Requirements:
536      * - `sender` and `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      * - the caller must have allowance for ``sender``'s tokens of at least
539      * `amount`.
540      */
541     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(sender, recipient, amount);
543         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
544         return true;
545     }
546 
547     /**
548      * @dev Atomically increases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      */
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically decreases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      * - `spender` must have allowance for the caller of at least
576      * `subtractedValue`.
577      */
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     /**
584      * @dev Moves tokens `amount` from `sender` to `recipient`.
585      *
586      * This is internal function is equivalent to {transfer}, and can be used to
587      * e.g. implement automatic token fees, slashing mechanisms, etc.
588      *
589      * Emits a {Transfer} event.
590      *
591      * Requirements:
592      *
593      * - `sender` cannot be the zero address.
594      * - `recipient` cannot be the zero address.
595      * - `sender` must have a balance of at least `amount`.
596      */
597     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600 
601         _beforeTokenTransfer(sender, recipient, amount);
602 
603         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
604         _balances[recipient] = _balances[recipient].add(amount);
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
609      * the total supply.
610      *
611      * Emits a {Transfer} event with `from` set to the zero address.
612      *
613      * Requirements
614      *
615      * - `to` cannot be the zero address.
616      */
617     function _mint(address account, uint256 amount) internal virtual {
618         require(account != address(0), "ERC20: mint to the zero address");
619 
620         _beforeTokenTransfer(address(0), account, amount);
621 
622         _totalSupply = _totalSupply.add(amount);
623         _balances[account] = _balances[account].add(amount);
624         emit Transfer(address(0), account, amount);
625     }
626 
627     /**
628      * @dev Destroys `amount` tokens from `account`, reducing the
629      * total supply.
630      *
631      * Emits a {Transfer} event with `to` set to the zero address.
632      *
633      * Requirements
634      *
635      * - `account` cannot be the zero address.
636      * - `account` must have at least `amount` tokens.
637      */
638     function _burn(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: burn from the zero address");
640 
641         _beforeTokenTransfer(account, address(0), amount);
642 
643         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
644         _totalSupply = _totalSupply.sub(amount);
645         emit Transfer(account, address(0), amount);
646     }
647 
648     /**
649      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
650      *
651      * This internal function is equivalent to `approve`, and can be used to
652      * e.g. set automatic allowances for certain subsystems, etc.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `owner` cannot be the zero address.
659      * - `spender` cannot be the zero address.
660      */
661     function _approve(address owner, address spender, uint256 amount) internal virtual {
662         require(owner != address(0), "ERC20: approve from the zero address");
663         require(spender != address(0), "ERC20: approve to the zero address");
664 
665         _allowances[owner][spender] = amount;
666         emit Approval(owner, spender, amount);
667     }
668 
669     /**
670      * @dev Sets {decimals} to a value other than the default one of 18.
671      *
672      * WARNING: This function should only be called from the constructor. Most
673      * applications that interact with token contracts will not expect
674      * {decimals} to ever change, and may work incorrectly if it does.
675      */
676     function _setupDecimals(uint8 decimals_) internal {
677         _decimals = decimals_;
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be to transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
695 }
696 
697 // SPDX-License-Identifier: MIT
698 /**
699  * @dev Contract module which provides a basic access control mechanism, where
700  * there is an account (an owner) that can be granted exclusive access to
701  * specific functions.
702  *
703  * By default, the owner account will be the one that deploys the contract. This
704  * can later be changed with {transferOwnership}.
705  *
706  * This module is used through inheritance. It will make available the modifier
707  * `onlyOwner`, which can be applied to your functions to restrict their use to
708  * the owner.
709  */
710 contract Ownable is Context {
711     address private _owner;
712 
713     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
714 
715     /**
716      * @dev Initializes the contract setting the deployer as the initial owner.
717      */
718     constructor () internal {
719         address msgSender = _msgSender();
720         _owner = msgSender;
721         emit OwnershipTransferred(address(0), msgSender);
722     }
723 
724     /**
725      * @dev Returns the address of the current owner.
726      */
727     function owner() public view returns (address) {
728         return _owner;
729     }
730 
731     /**
732      * @dev Throws if called by any account other than the owner.
733      */
734     modifier onlyOwner() {
735         require(_owner == _msgSender(), "Ownable: caller is not the owner");
736         _;
737     }
738 
739     /**
740      * @dev Leaves the contract without owner. It will not be possible to call
741      * `onlyOwner` functions anymore. Can only be called by the current owner.
742      *
743      * NOTE: Renouncing ownership will leave the contract without an owner,
744      * thereby removing any functionality that is only available to the owner.
745      */
746     function renounceOwnership() public virtual onlyOwner {
747         emit OwnershipTransferred(_owner, address(0));
748         _owner = address(0);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Can only be called by the current owner.
754      */
755     function transferOwnership(address newOwner) public virtual onlyOwner {
756         require(newOwner != address(0), "Ownable: new owner is the zero address");
757         emit OwnershipTransferred(_owner, newOwner);
758         _owner = newOwner;
759     }
760 }
761 
762 /**
763  * @title KiraToken
764  * @dev Simple ERC20 Token with freezing and whitelist feature.
765  */
766 contract KiraToken is ERC20, Ownable {
767     using SafeMath for uint256;
768 
769     // modify token name
770     string public constant NAME = 'KIRA Network';
771     // modify token symbol
772     string public constant SYMBOL = 'KEX';
773     // modify token decimals
774     uint8 public constant DECIMALS = 6;
775     // modify initial token supply
776     uint256 public constant INITIAL_SUPPLY = 300000000 * (10**uint256(DECIMALS)); // 300,000,000 tokens
777 
778     // indicate if the token is freezed or not
779     bool public freezed;
780 
781     struct WhitelistInfo {
782         // if account has allow deposit permission then it should be possible to deposit tokens to that account
783         // as long as accounts depositing have allow_transfer permission
784         bool allow_deposit;
785         // if account has allow transfer permission then that account should be able to transfer tokens to other
786         // accounts with allow_deposit permission
787         bool allow_transfer;
788         // deposit to the account should be possible even if account depositing has no permission to transfer
789         bool allow_unconditional_deposit;
790         // transfer from the account should be possible to any account even if the destination account has no
791         // deposit permission
792         bool allow_unconditional_transfer;
793     }
794 
795     // represents if the address is blacklisted with the contract. Blacklist takes priority before all other permissions like whitelist
796     mapping(address => bool) private _blacklist;
797 
798     // represents if the address is whitelisted or not
799     mapping(address => WhitelistInfo) private _whitelist;
800 
801     // Events
802     event WhitelistConfigured(
803         address[] addrs,
804         bool allow_deposit,
805         bool allow_transfer,
806         bool allow_unconditional_deposit,
807         bool allow_unconditional_transfer
808     );
809     event AddedToBlacklist(address[] addrs);
810     event RemovedFromBlacklist(address[] addrs);
811 
812     /**
813      * @dev Constructor that gives msg.sender all of existing tokens.
814      */
815     constructor() public Ownable() ERC20(NAME, SYMBOL) {
816         _setupDecimals(DECIMALS);
817         _mint(msg.sender, INITIAL_SUPPLY);
818         emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
819         freezed = true;
820 
821         // owner's whitelist
822         _whitelist[msg.sender].allow_deposit = true;
823         _whitelist[msg.sender].allow_transfer = true;
824         _whitelist[msg.sender].allow_unconditional_deposit = true;
825         _whitelist[msg.sender].allow_unconditional_transfer = true;
826     }
827 
828     /**
829      * @dev freeze and unfreeze functions
830      */
831     function freeze() external onlyOwner {
832         require(freezed == false, 'KEX: already freezed');
833         freezed = true;
834     }
835 
836     function unfreeze() external onlyOwner {
837         require(freezed == true, 'KEX: already unfreezed');
838         freezed = false;
839     }
840 
841     /**
842      * @dev configure whitelist to an address
843      * @param addrs the addresses to be whitelisted
844      * @param allow_deposit boolean variable to indicate if deposit is allowed
845      * @param allow_transfer boolean variable to indicate if transfer is allowed
846      * @param allow_unconditional_deposit boolean variable to indicate if unconditional deposit is allowed
847      * @param allow_unconditional_transfer boolean variable to indicate if unconditional transfer is allowed
848      */
849     function whitelist(
850         address[] calldata addrs,
851         bool allow_deposit,
852         bool allow_transfer,
853         bool allow_unconditional_deposit,
854         bool allow_unconditional_transfer
855     ) external onlyOwner returns (bool) {
856         for (uint256 i = 0; i < addrs.length; i++) {
857             address addr = addrs[i];
858             require(addr != address(0), 'KEX: address should not be zero');
859 
860             _whitelist[addr].allow_deposit = allow_deposit;
861             _whitelist[addr].allow_transfer = allow_transfer;
862             _whitelist[addr].allow_unconditional_deposit = allow_unconditional_deposit;
863             _whitelist[addr].allow_unconditional_transfer = allow_unconditional_transfer;
864         }
865 
866         emit WhitelistConfigured(addrs, allow_deposit, allow_transfer, allow_unconditional_deposit, allow_unconditional_transfer);
867 
868         return true;
869     }
870 
871     /**
872      * @dev add addresses to blacklist
873      */
874     function addToBlacklist(address[] calldata addrs) external onlyOwner returns (bool) {
875         for (uint256 i = 0; i < addrs.length; i++) {
876             address addr = addrs[i];
877             require(addr != address(0), 'KEX: address should not be zero');
878 
879             _blacklist[addr] = true;
880         }
881 
882         emit AddedToBlacklist(addrs);
883 
884         return true;
885     }
886 
887     /**
888      * @dev remove addresses from blacklist
889      */
890     function removeFromBlacklist(address[] calldata addrs) external onlyOwner returns (bool) {
891         for (uint256 i = 0; i < addrs.length; i++) {
892             address addr = addrs[i];
893             require(addr != address(0), 'KEX: address should not be zero');
894 
895             _blacklist[addr] = false;
896         }
897 
898         emit RemovedFromBlacklist(addrs);
899 
900         return true;
901     }
902 
903     function multiTransfer(address[] calldata addrs, uint256 amount) external returns (bool) {
904         require(amount > 0, 'KEX: amount should not be zero');
905         require(balanceOf(msg.sender) >= amount.mul(addrs.length), 'KEX: amount should be less than the balance of the sender');
906 
907         for (uint256 i = 0; i < addrs.length; i++) {
908             address addr = addrs[i];
909             require(addr != msg.sender, 'KEX: address should not be sender');
910             require(addr != address(0), 'KEX: address should not be zero');
911 
912             transfer(addr, amount);
913         }
914 
915         return true;
916     }
917 
918     /**
919      * @dev Returns if the address is whitelisted or not.
920      */
921     function whitelisted(address addr)
922         public
923         view
924         returns (
925             bool,
926             bool,
927             bool,
928             bool
929         )
930     {
931         return (
932             _whitelist[addr].allow_deposit,
933             _whitelist[addr].allow_transfer,
934             _whitelist[addr].allow_unconditional_deposit,
935             _whitelist[addr].allow_unconditional_transfer
936         );
937     }
938 
939     /**
940      * @dev Returns if the address is on the blacklist or not.
941      */
942     function blacklisted(address addr) public view returns (bool) {
943         return _blacklist[addr];
944     }
945 
946     /**
947      * @dev Hook before transfer
948      * check from and to are whitelisted when the token is freezed
949      */
950     function _beforeTokenTransfer(
951         address from,
952         address to,
953         uint256 amount
954     ) internal virtual override {
955         super._beforeTokenTransfer(from, to, amount);
956         require(!_blacklist[from], 'KEX: sender is blacklisted.');
957         require(!_blacklist[to], 'KEX: receiver is blacklisted.');
958         require(
959             !freezed ||
960                 _whitelist[from].allow_unconditional_transfer ||
961                 _whitelist[to].allow_unconditional_deposit ||
962                 (_whitelist[from].allow_transfer && _whitelist[to].allow_deposit),
963             'KEX: token transfer while freezed and not whitelisted.'
964         );
965     }
966 }
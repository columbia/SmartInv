1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/Address.sol
2 
3 pragma solidity ^0.6.2;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol
144 
145 pragma solidity ^0.6.0;
146 
147 /**
148  * @dev Wrappers over Solidity's arithmetic operations with added overflow
149  * checks.
150  *
151  * Arithmetic operations in Solidity wrap on overflow. This can easily result
152  * in bugs, because programmers usually assume that an overflow raises an
153  * error, which is the standard behavior in high level programming languages.
154  * `SafeMath` restores this intuition by reverting the transaction when an
155  * operation overflows.
156  *
157  * Using this library instead of the unchecked operations eliminates an entire
158  * class of bugs, so it's recommended to use it always.
159  */
160 library SafeMath {
161     /**
162      * @dev Returns the addition of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `+` operator.
166      *
167      * Requirements:
168      *
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a, "SafeMath: addition overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         return sub(a, b, "SafeMath: subtraction overflow");
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b <= a, errorMessage);
204         uint256 c = a - b;
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      *
217      * - Multiplication cannot overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
221         // benefit is lost if 'b' is also tested.
222         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
223         if (a == 0) {
224             return 0;
225         }
226 
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers. Reverts on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         return div(a, b, "SafeMath: division by zero");
247     }
248 
249     /**
250      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
251      * division by zero. The result is rounded towards zero.
252      *
253      * Counterpart to Solidity's `/` operator. Note: this function uses a
254      * `revert` opcode (which leaves remaining gas untouched) while Solidity
255      * uses an invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b > 0, errorMessage);
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         return mod(a, b, "SafeMath: modulo by zero");
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts with custom message when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol
304 
305 pragma solidity ^0.6.0;
306 
307 /**
308  * @dev Interface of the ERC20 standard as defined in the EIP.
309  */
310 interface IERC20 {
311     /**
312      * @dev Returns the amount of tokens in existence.
313      */
314     function totalSupply() external view returns (uint256);
315 
316     /**
317      * @dev Returns the amount of tokens owned by `account`.
318      */
319     function balanceOf(address account) external view returns (uint256);
320 
321     /**
322      * @dev Moves `amount` tokens from the caller's account to `recipient`.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transfer(address recipient, uint256 amount) external returns (bool);
329 
330     /**
331      * @dev Returns the remaining number of tokens that `spender` will be
332      * allowed to spend on behalf of `owner` through {transferFrom}. This is
333      * zero by default.
334      *
335      * This value changes when {approve} or {transferFrom} are called.
336      */
337     function allowance(address owner, address spender) external view returns (uint256);
338 
339     /**
340      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * IMPORTANT: Beware that changing an allowance with this method brings the risk
345      * that someone may use both the old and the new allowance by unfortunate
346      * transaction ordering. One possible solution to mitigate this race
347      * condition is to first reduce the spender's allowance to 0 and set the
348      * desired value afterwards:
349      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350      *
351      * Emits an {Approval} event.
352      */
353     function approve(address spender, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Moves `amount` tokens from `sender` to `recipient` using the
357      * allowance mechanism. `amount` is then deducted from the caller's
358      * allowance.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Emitted when `value` tokens are moved from one account (`from`) to
368      * another (`to`).
369      *
370      * Note that `value` may be zero.
371      */
372     event Transfer(address indexed from, address indexed to, uint256 value);
373 
374     /**
375      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
376      * a call to {approve}. `value` is the new allowance.
377      */
378     event Approval(address indexed owner, address indexed spender, uint256 value);
379 }
380 
381 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/GSN/Context.sol
382 
383 pragma solidity ^0.6.0;
384 
385 /*
386  * @dev Provides information about the current execution context, including the
387  * sender of the transaction and its data. While these are generally available
388  * via msg.sender and msg.data, they should not be accessed in such a direct
389  * manner, since when dealing with GSN meta-transactions the account sending and
390  * paying for execution may not be the actual sender (as far as an application
391  * is concerned).
392  *
393  * This contract is only required for intermediate, library-like contracts.
394  */
395 abstract contract Context {
396     function _msgSender() internal view virtual returns (address payable) {
397         return msg.sender;
398     }
399 
400     function _msgData() internal view virtual returns (bytes memory) {
401         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
402         return msg.data;
403     }
404 }
405 
406 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol
407 
408 pragma solidity ^0.6.0;
409 
410 /**
411  * @dev Implementation of the {IERC20} interface.
412  *
413  * This implementation is agnostic to the way tokens are created. This means
414  * that a supply mechanism has to be added in a derived contract using {_mint}.
415  * For a generic mechanism see {ERC20PresetMinterPauser}.
416  *
417  * TIP: For a detailed writeup see our guide
418  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
419  * to implement supply mechanisms].
420  *
421  * We have followed general OpenZeppelin guidelines: functions revert instead
422  * of returning `false` on failure. This behavior is nonetheless conventional
423  * and does not conflict with the expectations of ERC20 applications.
424  *
425  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
426  * This allows applications to reconstruct the allowance for all accounts just
427  * by listening to said events. Other implementations of the EIP may not emit
428  * these events, as it isn't required by the specification.
429  *
430  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
431  * functions have been added to mitigate the well-known issues around setting
432  * allowances. See {IERC20-approve}.
433  */
434 contract ERC20 is Context, IERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     mapping (address => uint256) private _balances;
439 
440     mapping (address => mapping (address => uint256)) private _allowances;
441 
442     uint256 private _totalSupply;
443 
444     string private _name;
445     string private _symbol;
446     uint8 private _decimals;
447 
448     /**
449      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
450      * a default value of 18.
451      *
452      * To select a different value for {decimals}, use {_setupDecimals}.
453      *
454      * All three of these values are immutable: they can only be set once during
455      * construction.
456      */
457     constructor (string memory name, string memory symbol) public {
458         _name = name;
459         _symbol = symbol;
460         _decimals = 18;
461     }
462 
463     /**
464      * @dev Returns the name of the token.
465      */
466     function name() public view returns (string memory) {
467         return _name;
468     }
469 
470     /**
471      * @dev Returns the symbol of the token, usually a shorter version of the
472      * name.
473      */
474     function symbol() public view returns (string memory) {
475         return _symbol;
476     }
477 
478     /**
479      * @dev Returns the number of decimals used to get its user representation.
480      * For example, if `decimals` equals `2`, a balance of `505` tokens should
481      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
482      *
483      * Tokens usually opt for a value of 18, imitating the relationship between
484      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
485      * called.
486      *
487      * NOTE: This information is only used for _display_ purposes: it in
488      * no way affects any of the arithmetic of the contract, including
489      * {IERC20-balanceOf} and {IERC20-transfer}.
490      */
491     function decimals() public view returns (uint8) {
492         return _decimals;
493     }
494 
495     /**
496      * @dev See {IERC20-totalSupply}.
497      */
498     function totalSupply() public view override returns (uint256) {
499         return _totalSupply;
500     }
501 
502     /**
503      * @dev See {IERC20-balanceOf}.
504      */
505     function balanceOf(address account) public view override returns (uint256) {
506         return _balances[account];
507     }
508 
509     /**
510      * @dev See {IERC20-transfer}.
511      *
512      * Requirements:
513      *
514      * - `recipient` cannot be the zero address.
515      * - the caller must have a balance of at least `amount`.
516      */
517     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-allowance}.
524      */
525     function allowance(address owner, address spender) public view virtual override returns (uint256) {
526         return _allowances[owner][spender];
527     }
528 
529     /**
530      * @dev See {IERC20-approve}.
531      *
532      * Requirements:
533      *
534      * - `spender` cannot be the zero address.
535      */
536     function approve(address spender, uint256 amount) public virtual override returns (bool) {
537         _approve(_msgSender(), spender, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-transferFrom}.
543      *
544      * Emits an {Approval} event indicating the updated allowance. This is not
545      * required by the EIP. See the note at the beginning of {ERC20};
546      *
547      * Requirements:
548      * - `sender` and `recipient` cannot be the zero address.
549      * - `sender` must have a balance of at least `amount`.
550      * - the caller must have allowance for ``sender``'s tokens of at least
551      * `amount`.
552      */
553     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
554         _transfer(sender, recipient, amount);
555         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556         return true;
557     }
558 
559     /**
560      * @dev Atomically increases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573         return true;
574     }
575 
576     /**
577      * @dev Atomically decreases the allowance granted to `spender` by the caller.
578      *
579      * This is an alternative to {approve} that can be used as a mitigation for
580      * problems described in {IERC20-approve}.
581      *
582      * Emits an {Approval} event indicating the updated allowance.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      * - `spender` must have allowance for the caller of at least
588      * `subtractedValue`.
589      */
590     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
592         return true;
593     }
594 
595     /**
596      * @dev Moves tokens `amount` from `sender` to `recipient`.
597      *
598      * This is internal function is equivalent to {transfer}, and can be used to
599      * e.g. implement automatic token fees, slashing mechanisms, etc.
600      *
601      * Emits a {Transfer} event.
602      *
603      * Requirements:
604      *
605      * - `sender` cannot be the zero address.
606      * - `recipient` cannot be the zero address.
607      * - `sender` must have a balance of at least `amount`.
608      */
609     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
610         require(sender != address(0), "ERC20: transfer from the zero address");
611         require(recipient != address(0), "ERC20: transfer to the zero address");
612 
613         _beforeTokenTransfer(sender, recipient, amount);
614 
615         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
616         _balances[recipient] = _balances[recipient].add(amount);
617         emit Transfer(sender, recipient, amount);
618     }
619 
620     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
621      * the total supply.
622      *
623      * Emits a {Transfer} event with `from` set to the zero address.
624      *
625      * Requirements
626      *
627      * - `to` cannot be the zero address.
628      */
629     function _mint(address account, uint256 amount) internal virtual {
630         require(account != address(0), "ERC20: mint to the zero address");
631 
632         _beforeTokenTransfer(address(0), account, amount);
633 
634         _totalSupply = _totalSupply.add(amount);
635         _balances[account] = _balances[account].add(amount);
636         emit Transfer(address(0), account, amount);
637     }
638 
639     /**
640      * @dev Destroys `amount` tokens from `account`, reducing the
641      * total supply.
642      *
643      * Emits a {Transfer} event with `to` set to the zero address.
644      *
645      * Requirements
646      *
647      * - `account` cannot be the zero address.
648      * - `account` must have at least `amount` tokens.
649      */
650     function _burn(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: burn from the zero address");
652 
653         _beforeTokenTransfer(account, address(0), amount);
654 
655         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
656         _totalSupply = _totalSupply.sub(amount);
657         emit Transfer(account, address(0), amount);
658     }
659 
660     /**
661      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
662      *
663      * This is internal function is equivalent to `approve`, and can be used to
664      * e.g. set automatic allowances for certain subsystems, etc.
665      *
666      * Emits an {Approval} event.
667      *
668      * Requirements:
669      *
670      * - `owner` cannot be the zero address.
671      * - `spender` cannot be the zero address.
672      */
673     function _approve(address owner, address spender, uint256 amount) internal virtual {
674         require(owner != address(0), "ERC20: approve from the zero address");
675         require(spender != address(0), "ERC20: approve to the zero address");
676 
677         _allowances[owner][spender] = amount;
678         emit Approval(owner, spender, amount);
679     }
680 
681     /**
682      * @dev Sets {decimals} to a value other than the default one of 18.
683      *
684      * WARNING: This function should only be called from the constructor. Most
685      * applications that interact with token contracts will not expect
686      * {decimals} to ever change, and may work incorrectly if it does.
687      */
688     function _setupDecimals(uint8 decimals_) internal {
689         _decimals = decimals_;
690     }
691 
692     /**
693      * @dev Hook that is called before any transfer of tokens. This includes
694      * minting and burning.
695      *
696      * Calling conditions:
697      *
698      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
699      * will be to transferred to `to`.
700      * - when `from` is zero, `amount` tokens will be minted for `to`.
701      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
702      * - `from` and `to` are never both zero.
703      *
704      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
705      */
706     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
707 }
708 
709 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20Burnable.sol
710 
711 pragma solidity ^0.6.0;
712 
713 /**
714  * @dev Extension of {ERC20} that allows token holders to destroy both their own
715  * tokens and those that they have an allowance for, in a way that can be
716  * recognized off-chain (via event analysis).
717  */
718 abstract contract ERC20Burnable is Context, ERC20 {
719     /**
720      * @dev Destroys `amount` tokens from the caller.
721      *
722      * See {ERC20-_burn}.
723      */
724     function burn(uint256 amount) public virtual {
725         _burn(_msgSender(), amount);
726     }
727 
728     /**
729      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
730      * allowance.
731      *
732      * See {ERC20-_burn} and {ERC20-allowance}.
733      *
734      * Requirements:
735      *
736      * - the caller must have allowance for ``accounts``'s tokens of at least
737      * `amount`.
738      */
739     function burnFrom(address account, uint256 amount) public virtual {
740         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
741 
742         _approve(account, _msgSender(), decreasedAllowance);
743         _burn(account, amount);
744     }
745 }
746 
747 /*
748  * Robonomics Network Exodust.
749  * (c) Robonomics Team <research@robonomics.network>
750  *
751  * SPDX-License-Identifier: MIT
752  */
753 
754 pragma solidity ^0.6.0;
755 
756 contract Exodus is Context {
757     ERC20Burnable public xrt = ERC20Burnable(0x7dE91B204C1C737bcEe6F000AAA6569Cf7061cb7);
758     
759     /**
760      * @dev Migration event for given account.
761      * @param sender Ethereum account address.
762      * @param amount XRT token amount.
763      * @param account_id Parachain account address.
764      */
765     event Migration(address indexed sender, uint256 indexed amount, bytes32 indexed account_id);
766     
767     /**
768      * @dev Run exodus process.
769      * @param _amount XRT token amount.
770      * @param _account_id Parachain account address.
771      */
772     function run(uint256 _amount, bytes32 _account_id) external {
773         xrt.burnFrom(_msgSender(), _amount);
774         emit Migration(_msgSender(), _amount, _account_id);
775     }
776 }
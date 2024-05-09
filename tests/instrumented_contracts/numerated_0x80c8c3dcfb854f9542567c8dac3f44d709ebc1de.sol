1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-03
3 */
4 
5 pragma solidity ^0.6.0;
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 
30 pragma solidity ^0.6.0;
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
108 pragma solidity ^0.6.0;
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
267 
268 pragma solidity ^0.6.2;
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
408 
409 
410 pragma solidity ^0.6.0;
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20PresetMinterPauser}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _balances;
440 
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     uint256 private _totalSupply;
444 
445     string private _name;
446     string private _symbol;
447     uint8 private _decimals;
448 
449     /**
450      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
451      * a default value of 18.
452      *
453      * To select a different value for {decimals}, use {_setupDecimals}.
454      *
455      * All three of these values are immutable: they can only be set once during
456      * construction.
457      */
458     constructor (string memory name, string memory symbol) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = 18;
462     }
463 
464     /**
465      * @dev Returns the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @dev Returns the symbol of the token, usually a shorter version of the
473      * name.
474      */
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     /**
480      * @dev Returns the number of decimals used to get its user representation.
481      * For example, if `decimals` equals `2`, a balance of `505` tokens should
482      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
483      *
484      * Tokens usually opt for a value of 18, imitating the relationship between
485      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
486      * called.
487      *
488      * NOTE: This information is only used for _display_ purposes: it in
489      * no way affects any of the arithmetic of the contract, including
490      * {IERC20-balanceOf} and {IERC20-transfer}.
491      */
492     function decimals() public view returns (uint8) {
493         return _decimals;
494     }
495 
496     /**
497      * @dev See {IERC20-totalSupply}.
498      */
499     function totalSupply() public view override returns (uint256) {
500         return _totalSupply;
501     }
502 
503     /**
504      * @dev See {IERC20-balanceOf}.
505      */
506     function balanceOf(address account) public view override returns (uint256) {
507         return _balances[account];
508     }
509 
510     /**
511      * @dev See {IERC20-transfer}.
512      *
513      * Requirements:
514      *
515      * - `recipient` cannot be the zero address.
516      * - the caller must have a balance of at least `amount`.
517      */
518     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-allowance}.
525      */
526     function allowance(address owner, address spender) public view virtual override returns (uint256) {
527         return _allowances[owner][spender];
528     }
529 
530     /**
531      * @dev See {IERC20-approve}.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      */
537     function approve(address spender, uint256 amount) public virtual override returns (bool) {
538         _approve(_msgSender(), spender, amount);
539         return true;
540     }
541 
542     /**
543      * @dev See {IERC20-transferFrom}.
544      *
545      * Emits an {Approval} event indicating the updated allowance. This is not
546      * required by the EIP. See the note at the beginning of {ERC20};
547      *
548      * Requirements:
549      * - `sender` and `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      * - the caller must have allowance for ``sender``'s tokens of at least
552      * `amount`.
553      */
554     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(sender, recipient, amount);
556         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
557         return true;
558     }
559 
560     /**
561      * @dev Atomically increases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically decreases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      * - `spender` must have allowance for the caller of at least
589      * `subtractedValue`.
590      */
591     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
592         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
593         return true;
594     }
595 
596     /**
597      * @dev Moves tokens `amount` from `sender` to `recipient`.
598      *
599      * This is internal function is equivalent to {transfer}, and can be used to
600      * e.g. implement automatic token fees, slashing mechanisms, etc.
601      *
602      * Emits a {Transfer} event.
603      *
604      * Requirements:
605      *
606      * - `sender` cannot be the zero address.
607      * - `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      */
610     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
611         require(sender != address(0), "ERC20: transfer from the zero address");
612         require(recipient != address(0), "ERC20: transfer to the zero address");
613 
614         _beforeTokenTransfer(sender, recipient, amount);
615 
616         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
617         _balances[recipient] = _balances[recipient].add(amount);
618         emit Transfer(sender, recipient, amount);
619     }
620 
621     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
622      * the total supply.
623      *
624      * Emits a {Transfer} event with `from` set to the zero address.
625      *
626      * Requirements
627      *
628      * - `to` cannot be the zero address.
629      */
630     function _mint(address account, uint256 amount) internal virtual {
631         require(account != address(0), "ERC20: mint to the zero address");
632 
633         _beforeTokenTransfer(address(0), account, amount);
634 
635         _totalSupply = _totalSupply.add(amount);
636         _balances[account] = _balances[account].add(amount);
637         emit Transfer(address(0), account, amount);
638     }
639 
640     /**
641      * @dev Destroys `amount` tokens from `account`, reducing the
642      * total supply.
643      *
644      * Emits a {Transfer} event with `to` set to the zero address.
645      *
646      * Requirements
647      *
648      * - `account` cannot be the zero address.
649      * - `account` must have at least `amount` tokens.
650      */
651     function _burn(address account, uint256 amount) internal virtual {
652         require(account != address(0), "ERC20: burn from the zero address");
653 
654         _beforeTokenTransfer(account, address(0), amount);
655 
656         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
657         _totalSupply = _totalSupply.sub(amount);
658         emit Transfer(account, address(0), amount);
659     }
660 
661     /**
662      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
663      *
664      * This is internal function is equivalent to `approve`, and can be used to
665      * e.g. set automatic allowances for certain subsystems, etc.
666      *
667      * Emits an {Approval} event.
668      *
669      * Requirements:
670      *
671      * - `owner` cannot be the zero address.
672      * - `spender` cannot be the zero address.
673      */
674     function _approve(address owner, address spender, uint256 amount) internal virtual {
675         require(owner != address(0), "ERC20: approve from the zero address");
676         require(spender != address(0), "ERC20: approve to the zero address");
677 
678         _allowances[owner][spender] = amount;
679         emit Approval(owner, spender, amount);
680     }
681 
682     /**
683      * @dev Sets {decimals} to a value other than the default one of 18.
684      *
685      * WARNING: This function should only be called from the constructor. Most
686      * applications that interact with token contracts will not expect
687      * {decimals} to ever change, and may work incorrectly if it does.
688      */
689     function _setupDecimals(uint8 decimals_) internal {
690         _decimals = decimals_;
691     }
692 
693     /**
694      * @dev Hook that is called before any transfer of tokens. This includes
695      * minting and burning.
696      *
697      * Calling conditions:
698      *
699      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
700      * will be to transferred to `to`.
701      * - when `from` is zero, `amount` tokens will be minted for `to`.
702      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
703      * - `from` and `to` are never both zero.
704      *
705      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
706      */
707     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
708 }
709 
710 // File: @openzeppelin/contracts/access/Ownable.sol
711 
712 
713 pragma solidity ^0.6.0;
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
778 // File: contracts/MilkyWayToken.sol
779 
780 pragma solidity 0.6.12;
781 contract GovernanceContract is Ownable {
782 
783     mapping(address => bool) public governanceContracts;
784 
785     event GovernanceContractAdded(address addr);
786     event GovernanceContractRemoved(address addr);
787 
788     modifier onlyGovernanceContracts() {
789         require(governanceContracts[msg.sender]);
790         _;
791     }
792 
793 
794     function addAddressToGovernanceContract(address addr) onlyOwner public returns(bool success) {
795         if (!governanceContracts[addr]) {
796             governanceContracts[addr] = true;
797             emit GovernanceContractAdded(addr);
798             success = true;
799         }
800     }
801 
802 
803     function removeAddressFromGovernanceContract(address addr) onlyOwner public returns(bool success) {
804         if (governanceContracts[addr]) {
805             governanceContracts[addr] = false;
806             emit GovernanceContractRemoved(addr);
807             success = true;
808         }
809     }
810 }
811 
812 pragma solidity 0.6.12;
813 // MilkyWayToken with Governance.
814 contract MilkyWayToken is ERC20("MilkyWay Token by SpaceSwap v2", "MILK2"), GovernanceContract {
815 
816     uint256 private _totalBurned;
817 
818     /**
819      * @dev See {IERC20-totalSupply}.
820      */
821     function totalBurned() public view returns (uint256) {
822         return _totalBurned;
823     }
824 
825 
826     /// @notice Creates `_amount` token to `_to`. Must only be called by the  Governance Contracts
827     function mint(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
828         _mint(_to, _amount);
829         _moveDelegates(address(0), _delegates[_to], _amount);
830         return true;
831     }
832 
833     /// @notice Creates `_amount` token to `_to`. Must only be called by the Governance Contracts
834     function burn(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
835         _burn(_to, _amount);
836         _totalBurned = _totalBurned.add(_amount);
837         _moveDelegates(_delegates[_to], address(0), _amount);
838         return true;
839     }
840 
841     // Copied and modified from YAM code:
842     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
843     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
844     // Which is copied and modified from COMPOUND:
845     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
846 
847     // @notice A record of each accounts delegate
848     mapping (address => address) internal _delegates;
849 
850     /// @notice A checkpoint for marking number of votes from a given block
851     struct Checkpoint {
852         uint32 fromBlock;
853         uint256 votes;
854     }
855 
856     /// @notice A record of votes checkpoints for each account, by index
857     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
858 
859     /// @notice The number of checkpoints for each account
860     mapping (address => uint32) public numCheckpoints;
861 
862     /// @notice The EIP-712 typehash for the contract's domain
863     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
864 
865     /// @notice The EIP-712 typehash for the delegation struct used by the contract
866     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
867 
868     /// @notice A record of states for signing / validating signatures
869     mapping (address => uint) public nonces;
870 
871     /// @notice An event thats emitted when an account changes its delegate
872     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
873 
874     /// @notice An event thats emitted when a delegate account's vote balance changes
875     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
876 
877     /**
878      * @notice Delegate votes from `msg.sender` to `delegatee`
879      * @param delegator The address to get delegatee for
880      */
881     function delegates(address delegator)
882     external
883     view
884     returns (address)
885     {
886         return _delegates[delegator];
887     }
888 
889     /**
890      * @notice Delegate votes from `msg.sender` to `delegatee`
891      * @param delegatee The address to delegate votes to
892      */
893     function delegate(address delegatee) external {
894         return _delegate(msg.sender, delegatee);
895     }
896 
897     /**
898      * @notice Delegates votes from signatory to `delegatee`
899      * @param delegatee The address to delegate votes to
900      * @param nonce The contract state required to match the signature
901      * @param expiry The time at which to expire the signature
902      * @param v The recovery byte of the signature
903      * @param r Half of the ECDSA signature pair
904      * @param s Half of the ECDSA signature pair
905      */
906     function delegateBySig(
907         address delegatee,
908         uint nonce,
909         uint expiry,
910         uint8 v,
911         bytes32 r,
912         bytes32 s
913     )
914     external
915     {
916         bytes32 domainSeparator = keccak256(
917             abi.encode(
918                 DOMAIN_TYPEHASH,
919                 keccak256(bytes(name())),
920                 getChainId(),
921                 address(this)
922             )
923         );
924 
925         bytes32 structHash = keccak256(
926             abi.encode(
927                 DELEGATION_TYPEHASH,
928                 delegatee,
929                 nonce,
930                 expiry
931             )
932         );
933 
934         bytes32 digest = keccak256(
935             abi.encodePacked(
936                 "\x19\x01",
937                 domainSeparator,
938                 structHash
939             )
940         );
941 
942         address signatory = ecrecover(digest, v, r, s);
943         require(signatory != address(0), "MILKYWAY::delegateBySig: invalid signature");
944         require(nonce == nonces[signatory]++, "MILKYWAY::delegateBySig: invalid nonce");
945         require(now <= expiry, "MILKYWAY::delegateBySig: signature expired");
946         return _delegate(signatory, delegatee);
947     }
948 
949     /**
950      * @notice Gets the current votes balance for `account`
951      * @param account The address to get votes balance
952      * @return The number of current votes for `account`
953      */
954     function getCurrentVotes(address account)
955     external
956     view
957     returns (uint256)
958     {
959         uint32 nCheckpoints = numCheckpoints[account];
960         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
961     }
962 
963     /**
964      * @notice Determine the prior number of votes for an account as of a block number
965      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
966      * @param account The address of the account to check
967      * @param blockNumber The block number to get the vote balance at
968      * @return The number of votes the account had as of the given block
969      */
970     function getPriorVotes(address account, uint blockNumber)
971     external
972     view
973     returns (uint256)
974     {
975         require(blockNumber < block.number, "MILKYWAY::getPriorVotes: not yet determined");
976 
977         uint32 nCheckpoints = numCheckpoints[account];
978         if (nCheckpoints == 0) {
979             return 0;
980         }
981 
982         // First check most recent balance
983         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
984             return checkpoints[account][nCheckpoints - 1].votes;
985         }
986 
987         // Next check implicit zero balance
988         if (checkpoints[account][0].fromBlock > blockNumber) {
989             return 0;
990         }
991 
992         uint32 lower = 0;
993         uint32 upper = nCheckpoints - 1;
994         while (upper > lower) {
995             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
996             Checkpoint memory cp = checkpoints[account][center];
997             if (cp.fromBlock == blockNumber) {
998                 return cp.votes;
999             } else if (cp.fromBlock < blockNumber) {
1000                 lower = center;
1001             } else {
1002                 upper = center - 1;
1003             }
1004         }
1005         return checkpoints[account][lower].votes;
1006     }
1007 
1008     function _delegate(address delegator, address delegatee) internal {
1009         address currentDelegate = _delegates[delegator];
1010         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MILKYWAYs (not scaled);
1011         _delegates[delegator] = delegatee;
1012 
1013         emit DelegateChanged(delegator, currentDelegate, delegatee);
1014 
1015         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1016     }
1017 
1018     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1019         if (srcRep != dstRep && amount > 0) {
1020             if (srcRep != address(0)) {
1021                 // decrease old representative
1022                 uint32 srcRepNum = numCheckpoints[srcRep];
1023                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1024                 uint256 srcRepNew = srcRepOld.sub(amount);
1025                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1026             }
1027 
1028             if (dstRep != address(0)) {
1029                 // increase new representative
1030                 uint32 dstRepNum = numCheckpoints[dstRep];
1031                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1032                 uint256 dstRepNew = dstRepOld.add(amount);
1033                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1034             }
1035         }
1036     }
1037 
1038     function _writeCheckpoint(
1039         address delegatee,
1040         uint32 nCheckpoints,
1041         uint256 oldVotes,
1042         uint256 newVotes
1043     )
1044     internal
1045     {
1046         uint32 blockNumber = safe32(block.number, "MILKYWAY::_writeCheckpoint: block number exceeds 32 bits");
1047 
1048         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1049             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1050         } else {
1051             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1052             numCheckpoints[delegatee] = nCheckpoints + 1;
1053         }
1054 
1055         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1056     }
1057 
1058     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1059         require(n < 2**32, errorMessage);
1060         return uint32(n);
1061     }
1062 
1063     function getChainId() internal pure returns (uint) {
1064         uint256 chainId;
1065         assembly { chainId := chainid() }
1066         return chainId;
1067     }
1068 }
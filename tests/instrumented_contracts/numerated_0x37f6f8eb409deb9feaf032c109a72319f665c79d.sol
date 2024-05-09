1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/utils/Address.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.7.0;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
29         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
30         // for accounts without code, i.e. `keccak256('')`
31         bytes32 codehash;
32         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
33         // solhint-disable-next-line no-inline-assembly
34         assembly { codehash := extcodehash(account) }
35         return (codehash != accountHash && codehash != 0x0);
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
58         (bool success, ) = recipient.call{ value: amount }("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain`call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81       return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
96      * but also transferring `value` wei to `target`.
97      *
98      * Requirements:
99      *
100      * - the calling contract must have an ETH balance of at least `value`.
101      * - the called Solidity function must be `payable`.
102      *
103      * _Available since v3.1._
104      */
105     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
111      * with `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         return _functionCallWithValue(target, data, value, errorMessage);
118     }
119 
120     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
121         require(isContract(target), "Address: call to non-contract");
122 
123         // solhint-disable-next-line avoid-low-level-calls
124         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
125         if (success) {
126             return returndata;
127         } else {
128             // Look for revert reason and bubble it up if present
129             if (returndata.length > 0) {
130                 // The easiest way to bubble the revert reason is using memory via assembly
131 
132                 // solhint-disable-next-line no-inline-assembly
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/math/SafeMath.sol
145 
146 pragma solidity ^0.7.0;
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a, "SafeMath: addition overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting on
181      * overflow (when the result is negative).
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         return sub(a, b, "SafeMath: subtraction overflow");
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b <= a, errorMessage);
205         uint256 c = a - b;
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the multiplication of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `*` operator.
215      *
216      * Requirements:
217      *
218      * - Multiplication cannot overflow.
219      */
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
222         // benefit is lost if 'b' is also tested.
223         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
224         if (a == 0) {
225             return 0;
226         }
227 
228         uint256 c = a * b;
229         require(c / a == b, "SafeMath: multiplication overflow");
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers. Reverts on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         return div(a, b, "SafeMath: division by zero");
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b > 0, errorMessage);
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         return mod(a, b, "SafeMath: modulo by zero");
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts with custom message when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b != 0, errorMessage);
300         return a % b;
301     }
302 }
303 
304 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/token/ERC20/IERC20.sol
305 
306 pragma solidity ^0.7.0;
307 
308 /**
309  * @dev Interface of the ERC20 standard as defined in the EIP.
310  */
311 interface IERC20 {
312     /**
313      * @dev Returns the amount of tokens in existence.
314      */
315     function totalSupply() external view returns (uint256);
316 
317     /**
318      * @dev Returns the amount of tokens owned by `account`.
319      */
320     function balanceOf(address account) external view returns (uint256);
321 
322     /**
323      * @dev Moves `amount` tokens from the caller's account to `recipient`.
324      *
325      * Returns a boolean value indicating whether the operation succeeded.
326      *
327      * Emits a {Transfer} event.
328      */
329     function transfer(address recipient, uint256 amount) external returns (bool);
330 
331     /**
332      * @dev Returns the remaining number of tokens that `spender` will be
333      * allowed to spend on behalf of `owner` through {transferFrom}. This is
334      * zero by default.
335      *
336      * This value changes when {approve} or {transferFrom} are called.
337      */
338     function allowance(address owner, address spender) external view returns (uint256);
339 
340     /**
341      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
342      *
343      * Returns a boolean value indicating whether the operation succeeded.
344      *
345      * IMPORTANT: Beware that changing an allowance with this method brings the risk
346      * that someone may use both the old and the new allowance by unfortunate
347      * transaction ordering. One possible solution to mitigate this race
348      * condition is to first reduce the spender's allowance to 0 and set the
349      * desired value afterwards:
350      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351      *
352      * Emits an {Approval} event.
353      */
354     function approve(address spender, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Moves `amount` tokens from `sender` to `recipient` using the
358      * allowance mechanism. `amount` is then deducted from the caller's
359      * allowance.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Emitted when `value` tokens are moved from one account (`from`) to
369      * another (`to`).
370      *
371      * Note that `value` may be zero.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     /**
376      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
377      * a call to {approve}. `value` is the new allowance.
378      */
379     event Approval(address indexed owner, address indexed spender, uint256 value);
380 }
381 
382 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/GSN/Context.sol
383 
384 pragma solidity ^0.7.0;
385 
386 /*
387  * @dev Provides information about the current execution context, including the
388  * sender of the transaction and its data. While these are generally available
389  * via msg.sender and msg.data, they should not be accessed in such a direct
390  * manner, since when dealing with GSN meta-transactions the account sending and
391  * paying for execution may not be the actual sender (as far as an application
392  * is concerned).
393  *
394  * This contract is only required for intermediate, library-like contracts.
395  */
396 abstract contract Context {
397     function _msgSender() internal view virtual returns (address payable) {
398         return msg.sender;
399     }
400 
401     function _msgData() internal view virtual returns (bytes memory) {
402         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
403         return msg.data;
404     }
405 }
406 
407 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/token/ERC20/ERC20.sol
408 
409 pragma solidity ^0.7.0;
410 
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
458     constructor (string memory name_, string memory symbol_) {
459         _name = name_;
460         _symbol = symbol_;
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
662      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
663      *
664      * This internal function is equivalent to `approve`, and can be used to
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
710 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.2-solc-0.7/contracts/token/ERC20/ERC20Burnable.sol
711 
712 pragma solidity ^0.7.0;
713 
714 /**
715  * @dev Extension of {ERC20} that allows token holders to destroy both their own
716  * tokens and those that they have an allowance for, in a way that can be
717  * recognized off-chain (via event analysis).
718  */
719 abstract contract ERC20Burnable is Context, ERC20 {
720     using SafeMath for uint256;
721 
722     /**
723      * @dev Destroys `amount` tokens from the caller.
724      *
725      * See {ERC20-_burn}.
726      */
727     function burn(uint256 amount) public virtual {
728         _burn(_msgSender(), amount);
729     }
730 
731     /**
732      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
733      * allowance.
734      *
735      * See {ERC20-_burn} and {ERC20-allowance}.
736      *
737      * Requirements:
738      *
739      * - the caller must have allowance for ``accounts``'s tokens of at least
740      * `amount`.
741      */
742     function burnFrom(address account, uint256 amount) public virtual {
743         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
744 
745         _approve(account, _msgSender(), decreasedAllowance);
746         _burn(account, amount);
747     }
748 }
749 
750 // File: browser/TSTScoin.sol
751 
752 pragma solidity ^0.7.0;
753 
754 // ----------------------------------------------------------------------------
755 // ERC20 token - GCR
756 //
757 // Symbol        : GCR
758 // Name          : Gold Coin Reserve
759 // Total supply  : 3000000000000000000000000
760 // Decimals      : 18 (default)
761 // Owner Account : msg.sender
762 //
763 // ----------------------------------------------------------------------------
764 contract GCRToken is ERC20, ERC20Burnable {
765 
766     constructor() ERC20("Gold Coin Reserve", "GCR") {
767         _mint(msg.sender, 3000000 * (10 ** uint256(decimals())));
768     }
769 
770 }
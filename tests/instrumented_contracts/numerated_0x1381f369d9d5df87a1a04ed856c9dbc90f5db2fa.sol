1 /*                                    
2   .g8"""bgd `7MMF'  `7MMF'      db      `7MM"""Yb.                             
3 .dP'     `M   MM      MM       ;MM:       MM    `Yb.                           
4 dM'       `   MM      MM      ,V^MM.      MM     `Mb                           
5 MM            MMmmmmmmMM     ,M  `MM      MM      MM                           
6 MM.           MM      MM     AbmmmqMA     MM     ,MP                           
7 `Mb.     ,'   MM      MM    A'     VML    MM    ,dP'                           
8   `"bmmmd'  .JMML.  .JMML..AMA.   .AMMA..JMMmmmdP'                             
9                                                                                
10 `7MM"""YMM `7MMF'`7MN.   `7MF'     db      `7MN.   `7MF' .g8"""bgd `7MM"""YMM  
11   MM    `7   MM    MMN.    M      ;MM:       MMN.    M .dP'     `M   MM    `7  
12   MM   d     MM    M YMb   M     ,V^MM.      M YMb   M dM'       `   MM   d    
13   MM""MM     MM    M  `MN. M    ,M  `MM      M  `MN. M MM            MMmmMM    
14   MM   Y     MM    M   `MM.M    AbmmmqMA     M   `MM.M MM.           MM   Y  , 
15   MM         MM    M     YMM   A'     VML    M     YMM `Mb.     ,'   MM     ,M 
16 .JMML.     .JMML..JML.    YM .AMA.   .AMMA..JML.    YM   `"bmmmd'  .JMMmmmmMMM 
17 */
18 // File: @openzeppelin/contracts/GSN/Context.sol
19 
20 
21 pragma solidity ^0.6.0;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
45 
46 
47 pragma solidity ^0.6.0;
48 
49 /**
50  * @dev Interface of the ERC20 standard as defined in the EIP.
51  */
52 interface IERC20 {
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 // File: @openzeppelin/contracts/math/SafeMath.sol
124 
125 
126 pragma solidity ^0.6.0;
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b <= a, errorMessage);
185         uint256 c = a - b;
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return div(a, b, "SafeMath: division by zero");
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b > 0, errorMessage);
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b != 0, errorMessage);
280         return a % b;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/Address.sol
285 
286 
287 pragma solidity ^0.6.2;
288 
289 /**
290  * @dev Collection of functions related to the address type
291  */
292 library Address {
293     /**
294      * @dev Returns true if `account` is a contract.
295      *
296      * [IMPORTANT]
297      * ====
298      * It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      *
301      * Among others, `isContract` will return false for the following
302      * types of addresses:
303      *
304      *  - an externally-owned account
305      *  - a contract in construction
306      *  - an address where a contract will be created
307      *  - an address where a contract lived, but was destroyed
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // This method relies in extcodesize, which returns 0 for contracts in
312         // construction, since the code is only stored at the end of the
313         // constructor execution.
314 
315         uint256 size;
316         // solhint-disable-next-line no-inline-assembly
317         assembly { size := extcodesize(account) }
318         return size > 0;
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{ value: amount }("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain`call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364       return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
374         return _functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         return _functionCallWithValue(target, data, value, errorMessage);
401     }
402 
403     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
404         require(isContract(target), "Address: call to non-contract");
405 
406         // solhint-disable-next-line avoid-low-level-calls
407         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 // solhint-disable-next-line no-inline-assembly
416                 assembly {
417                     let returndata_size := mload(returndata)
418                     revert(add(32, returndata), returndata_size)
419                 }
420             } else {
421                 revert(errorMessage);
422             }
423         }
424     }
425 }
426 
427 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
428 
429 
430 pragma solidity ^0.6.0;
431 
432 
433 
434 
435 
436 /**
437  * @dev Implementation of the {IERC20} interface.
438  *
439  * This implementation is agnostic to the way tokens are created. This means
440  * that a supply mechanism has to be added in a derived contract using {_mint}.
441  * For a generic mechanism see {ERC20PresetMinterPauser}.
442  *
443  * TIP: For a detailed writeup see our guide
444  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
445  * to implement supply mechanisms].
446  *
447  * We have followed general OpenZeppelin guidelines: functions revert instead
448  * of returning `false` on failure. This behavior is nonetheless conventional
449  * and does not conflict with the expectations of ERC20 applications.
450  *
451  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
452  * This allows applications to reconstruct the allowance for all accounts just
453  * by listening to said events. Other implementations of the EIP may not emit
454  * these events, as it isn't required by the specification.
455  *
456  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
457  * functions have been added to mitigate the well-known issues around setting
458  * allowances. See {IERC20-approve}.
459  */
460 contract ERC20 is Context, IERC20 {
461     using SafeMath for uint256;
462     using Address for address;
463 
464     mapping (address => uint256) private _balances;
465 
466     mapping (address => mapping (address => uint256)) private _allowances;
467 
468     uint256 private _totalSupply;
469 
470     string private _name;
471     string private _symbol;
472     uint8 private _decimals;
473 
474     /**
475      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
476      * a default value of 18.
477      *
478      * To select a different value for {decimals}, use {_setupDecimals}.
479      *
480      * All three of these values are immutable: they can only be set once during
481      * construction.
482      */
483     constructor (string memory name, string memory symbol) public {
484         _name = name;
485         _symbol = symbol;
486         _decimals = 18;
487     }
488 
489     /**
490      * @dev Returns the name of the token.
491      */
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     /**
497      * @dev Returns the symbol of the token, usually a shorter version of the
498      * name.
499      */
500     function symbol() public view returns (string memory) {
501         return _symbol;
502     }
503 
504     /**
505      * @dev Returns the number of decimals used to get its user representation.
506      * For example, if `decimals` equals `2`, a balance of `505` tokens should
507      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
508      *
509      * Tokens usually opt for a value of 18, imitating the relationship between
510      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
511      * called.
512      *
513      * NOTE: This information is only used for _display_ purposes: it in
514      * no way affects any of the arithmetic of the contract, including
515      * {IERC20-balanceOf} and {IERC20-transfer}.
516      */
517     function decimals() public view returns (uint8) {
518         return _decimals;
519     }
520 
521     /**
522      * @dev See {IERC20-totalSupply}.
523      */
524     function totalSupply() public view override returns (uint256) {
525         return _totalSupply;
526     }
527 
528     /**
529      * @dev See {IERC20-balanceOf}.
530      */
531     function balanceOf(address account) public view override returns (uint256) {
532         return _balances[account];
533     }
534 
535     /**
536      * @dev See {IERC20-transfer}.
537      *
538      * Requirements:
539      *
540      * - `recipient` cannot be the zero address.
541      * - the caller must have a balance of at least `amount`.
542      */
543     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(_msgSender(), recipient, amount);
545         return true;
546     }
547 
548     /**
549      * @dev See {IERC20-allowance}.
550      */
551     function allowance(address owner, address spender) public view virtual override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     /**
556      * @dev See {IERC20-approve}.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function approve(address spender, uint256 amount) public virtual override returns (bool) {
563         _approve(_msgSender(), spender, amount);
564         return true;
565     }
566 
567     /**
568      * @dev See {IERC20-transferFrom}.
569      *
570      * Emits an {Approval} event indicating the updated allowance. This is not
571      * required by the EIP. See the note at the beginning of {ERC20};
572      *
573      * Requirements:
574      * - `sender` and `recipient` cannot be the zero address.
575      * - `sender` must have a balance of at least `amount`.
576      * - the caller must have allowance for ``sender``'s tokens of at least
577      * `amount`.
578      */
579     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
580         _transfer(sender, recipient, amount);
581         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically increases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      */
597     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
599         return true;
600     }
601 
602     /**
603      * @dev Atomically decreases the allowance granted to `spender` by the caller.
604      *
605      * This is an alternative to {approve} that can be used as a mitigation for
606      * problems described in {IERC20-approve}.
607      *
608      * Emits an {Approval} event indicating the updated allowance.
609      *
610      * Requirements:
611      *
612      * - `spender` cannot be the zero address.
613      * - `spender` must have allowance for the caller of at least
614      * `subtractedValue`.
615      */
616     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
617         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
618         return true;
619     }
620 
621     /**
622      * @dev Moves tokens `amount` from `sender` to `recipient`.
623      *
624      * This is internal function is equivalent to {transfer}, and can be used to
625      * e.g. implement automatic token fees, slashing mechanisms, etc.
626      *
627      * Emits a {Transfer} event.
628      *
629      * Requirements:
630      *
631      * - `sender` cannot be the zero address.
632      * - `recipient` cannot be the zero address.
633      * - `sender` must have a balance of at least `amount`.
634      */
635     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
636         require(sender != address(0), "ERC20: transfer from the zero address");
637         require(recipient != address(0), "ERC20: transfer to the zero address");
638 
639         _beforeTokenTransfer(sender, recipient, amount);
640 
641         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
642         _balances[recipient] = _balances[recipient].add(amount);
643         emit Transfer(sender, recipient, amount);
644     }
645 
646     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
647      * the total supply.
648      *
649      * Emits a {Transfer} event with `from` set to the zero address.
650      *
651      * Requirements
652      *
653      * - `to` cannot be the zero address.
654      */
655     function _mint(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: mint to the zero address");
657 
658         _beforeTokenTransfer(address(0), account, amount);
659 
660         _totalSupply = _totalSupply.add(amount);
661         _balances[account] = _balances[account].add(amount);
662         emit Transfer(address(0), account, amount);
663     }
664 
665     /**
666      * @dev Destroys `amount` tokens from `account`, reducing the
667      * total supply.
668      *
669      * Emits a {Transfer} event with `to` set to the zero address.
670      *
671      * Requirements
672      *
673      * - `account` cannot be the zero address.
674      * - `account` must have at least `amount` tokens.
675      */
676     function _burn(address account, uint256 amount) internal virtual {
677         require(account != address(0), "ERC20: burn from the zero address");
678 
679         _beforeTokenTransfer(account, address(0), amount);
680 
681         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
682         _totalSupply = _totalSupply.sub(amount);
683         emit Transfer(account, address(0), amount);
684     }
685 
686     /**
687      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
688      *
689      * This internal function is equivalent to `approve`, and can be used to
690      * e.g. set automatic allowances for certain subsystems, etc.
691      *
692      * Emits an {Approval} event.
693      *
694      * Requirements:
695      *
696      * - `owner` cannot be the zero address.
697      * - `spender` cannot be the zero address.
698      */
699     function _approve(address owner, address spender, uint256 amount) internal virtual {
700         require(owner != address(0), "ERC20: approve from the zero address");
701         require(spender != address(0), "ERC20: approve to the zero address");
702 
703         _allowances[owner][spender] = amount;
704         emit Approval(owner, spender, amount);
705     }
706 
707     /**
708      * @dev Sets {decimals} to a value other than the default one of 18.
709      *
710      * WARNING: This function should only be called from the constructor. Most
711      * applications that interact with token contracts will not expect
712      * {decimals} to ever change, and may work incorrectly if it does.
713      */
714     function _setupDecimals(uint8 decimals_) internal {
715         _decimals = decimals_;
716     }
717 
718     /**
719      * @dev Hook that is called before any transfer of tokens. This includes
720      * minting and burning.
721      *
722      * Calling conditions:
723      *
724      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
725      * will be to transferred to `to`.
726      * - when `from` is zero, `amount` tokens will be minted for `to`.
727      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
728      * - `from` and `to` are never both zero.
729      *
730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
731      */
732     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
736 
737 
738 pragma solidity ^0.6.0;
739 
740 
741 
742 
743 /**
744  * @title SafeERC20
745  * @dev Wrappers around ERC20 operations that throw on failure (when the token
746  * contract returns false). Tokens that return no value (and instead revert or
747  * throw on failure) are also supported, non-reverting calls are assumed to be
748  * successful.
749  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
750  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
751  */
752 library SafeERC20 {
753     using SafeMath for uint256;
754     using Address for address;
755 
756     function safeTransfer(IERC20 token, address to, uint256 value) internal {
757         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
758     }
759 
760     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
761         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
762     }
763 
764     /**
765      * @dev Deprecated. This function has issues similar to the ones found in
766      * {IERC20-approve}, and its usage is discouraged.
767      *
768      * Whenever possible, use {safeIncreaseAllowance} and
769      * {safeDecreaseAllowance} instead.
770      */
771     function safeApprove(IERC20 token, address spender, uint256 value) internal {
772         // safeApprove should only be called when setting an initial allowance,
773         // or when resetting it to zero. To increase and decrease it, use
774         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
775         // solhint-disable-next-line max-line-length
776         require((value == 0) || (token.allowance(address(this), spender) == 0),
777             "SafeERC20: approve from non-zero to non-zero allowance"
778         );
779         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
780     }
781 
782     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
783         uint256 newAllowance = token.allowance(address(this), spender).add(value);
784         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
785     }
786 
787     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
788         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
789         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
790     }
791 
792     /**
793      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
794      * on the return value: the return value is optional (but if data is returned, it must not be false).
795      * @param token The token targeted by the call.
796      * @param data The call data (encoded using abi.encode or one of its variants).
797      */
798     function _callOptionalReturn(IERC20 token, bytes memory data) private {
799         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
800         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
801         // the target address contains contract code and also asserts for success in the low-level call.
802 
803         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
804         if (returndata.length > 0) { // Return data is optional
805             // solhint-disable-next-line max-line-length
806             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
807         }
808     }
809 }
810 
811 // File: contracts/VirginToken.sol
812 
813 pragma solidity ^0.6.0;
814 
815 
816 
817 
818 contract VirginToken is ERC20 {
819     
820     using SafeERC20 for IERC20;
821     using SafeMath for uint256;
822  
823     
824     address owner;
825     address private fundVotingAddress;
826     IERC20 private mangas;
827     bool private isSendingFunds;
828     bool private isPreventToggleFund;
829     uint256 private lastBlockSent;
830 
831     modifier _onlyOwner() {
832         require(msg.sender == owner);
833         _;
834     }
835     
836     constructor() public payable ERC20("VIRGIN TOKEN", "VRGN") {
837         owner = msg.sender;
838         uint256 supply = 33000;
839         _mint(msg.sender, supply.mul(10 ** 18));
840         lastBlockSent = block.number;
841         isPreventToggleFund = true;
842         isSendingFunds = false;
843     }
844     
845    function setManGasAddress(address mangasAddress) public _onlyOwner {
846        mangas = IERC20(mangasAddress);
847    }    
848 
849    function setLastBlockSent(uint256 _lastBlockSent) public _onlyOwner {
850        lastBlockSent = _lastBlockSent;
851    }
852     
853    function setFundingAddress(address fundingContract) public _onlyOwner {
854        fundVotingAddress = fundingContract;
855    }
856 
857    function preventToggleFund() public _onlyOwner {
858         isPreventToggleFund = false;
859    }
860    
861    function toggleFundingBool() public _onlyOwner {
862        require(isPreventToggleFund == true, "isPreventToggleFund is not true");
863        isSendingFunds = !isSendingFunds;
864    }
865    
866    function getFundingPoolAmount() public view returns(uint256) {
867        mangas.balanceOf(owner);
868    }
869    
870    function triggerTransferOnlyOwner(uint256 amount) public _onlyOwner {
871        require((block.number - lastBlockSent) > 21600, "Too early to transfer");
872        mangas.safeTransfer(fundVotingAddress, amount);
873    }
874     
875 
876    function triggerTransfer(uint256 amount) public {
877        require(isSendingFunds == true, "isSendingFunds is not true");
878        require((block.number - lastBlockSent) > 21600, "Too early to transfer");
879        mangas.safeTransfer(fundVotingAddress, amount);
880    }
881     
882 }
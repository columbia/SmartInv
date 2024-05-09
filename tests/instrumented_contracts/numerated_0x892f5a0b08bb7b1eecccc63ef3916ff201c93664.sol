1 /*
2 
3 @@@@@@@   @@@        @@@@@@    @@@@@@   @@@@@@@   @@@ @@@  
4 @@@@@@@@  @@@       @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  
5 @@!  @@@  @@!       @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@  
6 !@   @!@  !@!       !@!  @!@  !@!  @!@  !@!  @!@  !@! @!!  
7 @!@!@!@   @!!       @!@  !@!  @!@  !@!  @!@  !@!   !@!@!   
8 !!!@!!!!  !!!       !@!  !!!  !@!  !!!  !@!  !!!    @!!!   
9 !!:  !!!  !!:       !!:  !!!  !!:  !!!  !!:  !!!    !!:    
10 :!:  !:!   :!:      :!:  !:!  :!:  !:!  :!:  !:!    :!:    
11  :: ::::   :: ::::  ::::: ::  ::::: ::   :::: ::     ::    
12 :: : ::   : :: : :   : :  :    : :  :   :: :  :      :
13 
14 Website: bloodyfi.org
15 
16 BLOODY, a deflationary elastic experiment that clots if it 
17 doesn't circulate
18 
19 How does clotting work?
20 
21 Whenever the BLOODY transfer volume increases, everyone's 
22 BLOODY balance gets a little bit bigger, whenever the BLOODY 
23 transfer volume decreases, everyone's BLOODY balance gets a 
24 little bit smaller.
25 
26 How is it deflationary?
27 
28 Whenever there's a BLOODY transfer, it spills. The faster it
29 circulates, the higher the spill rate.
30 
31 How often are rebases?
32 
33 Rebases are hourly. After a rebase, transfers are frozen for 
34 5 minutes.
35 
36 How are BLOODY liquidity provider incentivized?
37 
38 - Half the spills are redistributed to BLOODY-ETH, BLOODY-ROT 
39 and BLOODY-NICE liquidity providers (up to 6% of ANY transfer).
40 - A BLOODY-ROT pool will be added to Rottenswap on Halloween.
41 
42 How is BLOODY initially distributed?
43 
44 BLOODY cannot be minted, it is ditributed once on Halloween 2020 
45 to ROT holders with a balance above 7,500. The snapshot block 
46 (11106871) was chosen at random 
47 https://twitter.com/TheTimTempleton/status/1320722096578727937
48 
49 Are contracts audited?
50 
51 BLOODY is written 100% from scratch, not tested nor audited. 
52 It is not secure, use at your own risk.
53 
54 What does it BLOODY do?
55 
56 Nothing, it is an experiment with no purpose.
57 
58 */
59 
60 // File: @openzeppelin/contracts/GSN/Context.sol
61 
62 // SPDX-License-Identifier: MIT
63 
64 pragma solidity ^0.6.0;
65 
66 /*
67  * @dev Provides information about the current execution context, including the
68  * sender of the transaction and its data. While these are generally available
69  * via msg.sender and msg.data, they should not be accessed in such a direct
70  * manner, since when dealing with GSN meta-transactions the account sending and
71  * paying for execution may not be the actual sender (as far as an application
72  * is concerned).
73  *
74  * This contract is only required for intermediate, library-like contracts.
75  */
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address payable) {
78         return msg.sender;
79     }
80 
81     function _msgData() internal view virtual returns (bytes memory) {
82         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
88 
89 // SPDX-License-Identifier: MIT
90 
91 pragma solidity ^0.6.0;
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: @openzeppelin/contracts/math/SafeMath.sol
168 
169 // SPDX-License-Identifier: MIT
170 
171 pragma solidity ^0.6.0;
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return sub(a, b, "SafeMath: subtraction overflow");
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b <= a, errorMessage);
230         uint256 c = a - b;
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return mod(a, b, "SafeMath: modulo by zero");
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts with custom message when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b != 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/Address.sol
330 
331 // SPDX-License-Identifier: MIT
332 
333 pragma solidity ^0.6.2;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      */
356     function isContract(address account) internal view returns (bool) {
357         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
358         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
359         // for accounts without code, i.e. `keccak256('')`
360         bytes32 codehash;
361         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
362         // solhint-disable-next-line no-inline-assembly
363         assembly { codehash := extcodehash(account) }
364         return (codehash != accountHash && codehash != 0x0);
365     }
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
387         (bool success, ) = recipient.call{ value: amount }("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain`call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410       return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
420         return _functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         return _functionCallWithValue(target, data, value, errorMessage);
447     }
448 
449     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
450         require(isContract(target), "Address: call to non-contract");
451 
452         // solhint-disable-next-line avoid-low-level-calls
453         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
454         if (success) {
455             return returndata;
456         } else {
457             // Look for revert reason and bubble it up if present
458             if (returndata.length > 0) {
459                 // The easiest way to bubble the revert reason is using memory via assembly
460 
461                 // solhint-disable-next-line no-inline-assembly
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: contracts/ERC20.sol
474 
475 // SPDX-License-Identifier: MIT
476 
477 pragma solidity ^0.6.0;
478 
479 
480 
481 
482 
483 /**
484  * @dev Implementation of the {IERC20} interface.
485  *
486  * This implementation is agnostic to the way tokens are created. This means
487  * that a supply mechanism has to be added in a derived contract using {_mint}.
488  * For a generic mechanism see {ERC20PresetMinterPauser}.
489  *
490  * TIP: For a detailed writeup see our guide
491  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
492  * to implement supply mechanisms].
493  *
494  * We have followed general OpenZeppelin guidelines: functions revert instead
495  * of returning `false` on failure. This behavior is nonetheless conventional
496  * and does not conflict with the expectations of ERC20 applications.
497  *
498  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
499  * This allows applications to reconstruct the allowance for all accounts just
500  * by listening to said events. Other implementations of the EIP may not emit
501  * these events, as it isn't required by the specification.
502  *
503  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
504  * functions have been added to mitigate the well-known issues around setting
505  * allowances. See {IERC20-approve}.
506  */
507 contract ERC20 is Context, IERC20 {
508     using SafeMath for uint256;
509     using Address for address;
510 
511     mapping (address => uint256) private _balances;
512 
513     mapping (address => mapping (address => uint256)) private _allowances;
514 
515     uint256 private _totalSupply;
516 
517     string private _name;
518     string private _symbol;
519     uint8 private _decimals;
520 
521     /**
522      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
523      * a default value of 18.
524      *
525      * To select a different value for {decimals}, use {_setupDecimals}.
526      *
527      * All three of these values are immutable: they can only be set once during
528      * construction.
529      */
530     constructor (string memory name, string memory symbol) public {
531         _name = name;
532         _symbol = symbol;
533         _decimals = 18;
534     }
535 
536     /**
537      * @dev Returns the name of the token.
538      */
539     function name() public view returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @dev Returns the symbol of the token, usually a shorter version of the
545      * name.
546      */
547     function symbol() public view returns (string memory) {
548         return _symbol;
549     }
550 
551     /**
552      * @dev Returns the number of decimals used to get its user representation.
553      * For example, if `decimals` equals `2`, a balance of `505` tokens should
554      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
555      *
556      * Tokens usually opt for a value of 18, imitating the relationship between
557      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
558      * called.
559      *
560      * NOTE: This information is only used for _display_ purposes: it in
561      * no way affects any of the arithmetic of the contract, including
562      * {IERC20-balanceOf} and {IERC20-transfer}.
563      */
564     function decimals() public view returns (uint8) {
565         return _decimals;
566     }
567 
568     /**
569      * @dev See {IERC20-totalSupply}.
570      */
571     function totalSupply() public view override returns (uint256) {
572         return _totalSupply;
573     }
574 
575     /**
576      * @dev See {IERC20-balanceOf}.
577      */
578     // EDIT: make balanceOf virtual so it can be overridden
579     function balanceOf(address account) public view virtual override returns (uint256) {
580         return _balances[account];
581     }
582     // function balanceOf(address account) public view override returns (uint256) {
583     //     return _balances[account];
584     // }
585 
586     /**
587      * @dev See {IERC20-transfer}.
588      *
589      * Requirements:
590      *
591      * - `recipient` cannot be the zero address.
592      * - the caller must have a balance of at least `amount`.
593      */
594     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
595         _transfer(_msgSender(), recipient, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-allowance}.
601      */
602     function allowance(address owner, address spender) public view virtual override returns (uint256) {
603         return _allowances[owner][spender];
604     }
605 
606     /**
607      * @dev See {IERC20-approve}.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      */
613     function approve(address spender, uint256 amount) public virtual override returns (bool) {
614         _approve(_msgSender(), spender, amount);
615         return true;
616     }
617 
618     /**
619      * @dev See {IERC20-transferFrom}.
620      *
621      * Emits an {Approval} event indicating the updated allowance. This is not
622      * required by the EIP. See the note at the beginning of {ERC20};
623      *
624      * Requirements:
625      * - `sender` and `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      * - the caller must have allowance for ``sender``'s tokens of at least
628      * `amount`.
629      */
630     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
631         _transfer(sender, recipient, amount);
632         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
633         return true;
634     }
635 
636     /**
637      * @dev Atomically increases the allowance granted to `spender` by the caller.
638      *
639      * This is an alternative to {approve} that can be used as a mitigation for
640      * problems described in {IERC20-approve}.
641      *
642      * Emits an {Approval} event indicating the updated allowance.
643      *
644      * Requirements:
645      *
646      * - `spender` cannot be the zero address.
647      */
648     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
649         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
650         return true;
651     }
652 
653     /**
654      * @dev Atomically decreases the allowance granted to `spender` by the caller.
655      *
656      * This is an alternative to {approve} that can be used as a mitigation for
657      * problems described in {IERC20-approve}.
658      *
659      * Emits an {Approval} event indicating the updated allowance.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      * - `spender` must have allowance for the caller of at least
665      * `subtractedValue`.
666      */
667     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
668         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
669         return true;
670     }
671 
672     /**
673      * @dev Moves tokens `amount` from `sender` to `recipient`.
674      *
675      * This is internal function is equivalent to {transfer}, and can be used to
676      * e.g. implement automatic token fees, slashing mechanisms, etc.
677      *
678      * Emits a {Transfer} event.
679      *
680      * Requirements:
681      *
682      * - `sender` cannot be the zero address.
683      * - `recipient` cannot be the zero address.
684      * - `sender` must have a balance of at least `amount`.
685      */
686     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
687         require(sender != address(0), "ERC20: transfer from the zero address");
688         require(recipient != address(0), "ERC20: transfer to the zero address");
689 
690         // _beforeTokenTransfer(sender, recipient, amount);
691 
692         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
693         _balances[recipient] = _balances[recipient].add(amount);
694         emit Transfer(sender, recipient, amount);
695     }
696 
697     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
698      * the total supply.
699      *
700      * Emits a {Transfer} event with `from` set to the zero address.
701      *
702      * Requirements
703      *
704      * - `to` cannot be the zero address.
705      */
706     function _mint(address account, uint256 amount) internal virtual {
707         // require(account != address(0), "ERC20: mint to the zero address");
708 
709         // _beforeTokenTransfer(address(0), account, amount);
710 
711         _totalSupply = _totalSupply.add(amount);
712         _balances[account] = _balances[account].add(amount);
713         emit Transfer(address(0), account, amount);
714     }
715 
716     /**
717      * @dev Destroys `amount` tokens from `account`, reducing the
718      * total supply.
719      *
720      * Emits a {Transfer} event with `to` set to the zero address.
721      *
722      * Requirements
723      *
724      * - `account` cannot be the zero address.
725      * - `account` must have at least `amount` tokens.
726      */
727     function _burn(address account, uint256 amount) internal virtual {
728         // require(account != address(0), "ERC20: burn from the zero address");
729 
730         // _beforeTokenTransfer(account, address(0), amount);
731 
732         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
733         _totalSupply = _totalSupply.sub(amount);
734         emit Transfer(account, address(0), amount);
735     }
736 
737     /**
738      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
739      *
740      * This is internal function is equivalent to `approve`, and can be used to
741      * e.g. set automatic allowances for certain subsystems, etc.
742      *
743      * Emits an {Approval} event.
744      *
745      * Requirements:
746      *
747      * - `owner` cannot be the zero address.
748      * - `spender` cannot be the zero address.
749      */
750     function _approve(address owner, address spender, uint256 amount) internal virtual {
751         require(owner != address(0), "ERC20: approve from the zero address");
752         require(spender != address(0), "ERC20: approve to the zero address");
753 
754         _allowances[owner][spender] = amount;
755         emit Approval(owner, spender, amount);
756     }
757 
758     /**
759      * @dev Sets {decimals} to a value other than the default one of 18.
760      *
761      * WARNING: This function should only be called from the constructor. Most
762      * applications that interact with token contracts will not expect
763      * {decimals} to ever change, and may work incorrectly if it does.
764      */
765     function _setupDecimals(uint8 decimals_) internal {
766         _decimals = decimals_;
767     }
768 
769     /**
770      * @dev Hook that is called before any transfer of tokens. This includes
771      * minting and burning.
772      *
773      * Calling conditions:
774      *
775      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
776      * will be to transferred to `to`.
777      * - when `from` is zero, `amount` tokens will be minted for `to`.
778      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
779      * - `from` and `to` are never both zero.
780      *
781      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
782      */
783     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
784 }
785 
786 // File: contracts/ERC20TransferBurn.sol
787 
788 pragma solidity ^0.6.2;
789 
790 
791 contract ERC20TransferBurn is ERC20 {
792     using SafeMath for uint256;
793 
794     constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}
795 
796     // the amount of burn during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
797     uint256 private _burnDivisor = 100;
798 
799     function burnDivisor() public view virtual returns (uint256) {
800         return _burnDivisor;
801     }
802 
803     function _setBurnDivisor(uint256 burnDivisor) internal virtual {
804         require(burnDivisor > 0, "_setBurnDivisor burnDivisor must be bigger than 0");
805         _burnDivisor = burnDivisor;
806     }
807 
808     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
809         // calculate burn amount
810         uint256 burnAmount = amount.div(_burnDivisor);
811         // burn burn amount
812         burn(msg.sender, burnAmount);
813         // transfer amount minus burn amount
814         return super.transfer(recipient, amount.sub(burnAmount));
815     }
816 
817     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
818         // calculate burn amount
819         uint256 burnAmount = amount.div(_burnDivisor);
820         // burn burn amount
821         burn(sender, burnAmount);
822         // transfer amount minus burn amount
823         return super.transferFrom(sender, recipient, amount.sub(burnAmount));
824     }
825 
826     // keep track of total supply burned (for fun only, serves no purpose)
827     uint256 private _totalSupplyBurned;
828 
829     function totalSupplyBurned() public view virtual returns (uint256) {
830         return _totalSupplyBurned;
831     }
832 
833     function burn(address account, uint256 amount) private {
834         _burn(account, amount);
835         // keep track of total supply burned
836         _totalSupplyBurned = _totalSupplyBurned.add(amount);
837     }
838 }
839 
840 // File: contracts/ERC20ElasticTransferBurn.sol
841 
842 // ERC20Elastic is duplicated in ERC20Elastic.sol and ERC20ElasticTransferBurn.sol
843 // because I don't know how to not duplicate it
844 
845 pragma solidity ^0.6.0;
846 
847 
848 contract ERC20ElasticTransferBurn is ERC20TransferBurn {
849     using SafeMath for uint256;
850 
851     constructor (string memory name, string memory symbol) ERC20TransferBurn(name, symbol) public {}
852 
853     uint256 private _elasticMultiplier = 100;
854 
855     function elasticMultiplier() public view virtual returns (uint256) {
856         return _elasticMultiplier;
857     }
858 
859     function _setElasticMultiplier(uint256 elasticMultiplier) internal virtual {
860         require(elasticMultiplier > 0, "_setElasticMultiplier elasticMultiplier must be bigger than 0");
861         _elasticMultiplier = elasticMultiplier;
862     }
863 
864     function balanceOf(address account) public view virtual override returns (uint256) {
865         return super.balanceOf(account).mul(_elasticMultiplier);
866     }
867 
868     // don't override totalSupply to cause more madness and confusion
869     function totalSupplyElastic() public view virtual returns (uint256) {
870         return super.totalSupply().mul(_elasticMultiplier);
871     }
872 
873     function balanceOfRaw(address account) public view virtual returns (uint256) {
874         return super.balanceOf(account);
875     }
876 
877     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
878         return super.transfer(recipient, amount.div(_elasticMultiplier));
879     }
880 
881     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
882         return super.transferFrom(sender, recipient, amount.div(_elasticMultiplier));
883     }
884 }
885 
886 // File: @openzeppelin/contracts/access/Ownable.sol
887 
888 // SPDX-License-Identifier: MIT
889 
890 pragma solidity ^0.6.0;
891 
892 /**
893  * @dev Contract module which provides a basic access control mechanism, where
894  * there is an account (an owner) that can be granted exclusive access to
895  * specific functions.
896  *
897  * By default, the owner account will be the one that deploys the contract. This
898  * can later be changed with {transferOwnership}.
899  *
900  * This module is used through inheritance. It will make available the modifier
901  * `onlyOwner`, which can be applied to your functions to restrict their use to
902  * the owner.
903  */
904 contract Ownable is Context {
905     address private _owner;
906 
907     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
908 
909     /**
910      * @dev Initializes the contract setting the deployer as the initial owner.
911      */
912     constructor () internal {
913         address msgSender = _msgSender();
914         _owner = msgSender;
915         emit OwnershipTransferred(address(0), msgSender);
916     }
917 
918     /**
919      * @dev Returns the address of the current owner.
920      */
921     function owner() public view returns (address) {
922         return _owner;
923     }
924 
925     /**
926      * @dev Throws if called by any account other than the owner.
927      */
928     modifier onlyOwner() {
929         require(_owner == _msgSender(), "Ownable: caller is not the owner");
930         _;
931     }
932 
933     /**
934      * @dev Leaves the contract without owner. It will not be possible to call
935      * `onlyOwner` functions anymore. Can only be called by the current owner.
936      *
937      * NOTE: Renouncing ownership will leave the contract without an owner,
938      * thereby removing any functionality that is only available to the owner.
939      */
940     function renounceOwnership() public virtual onlyOwner {
941         emit OwnershipTransferred(_owner, address(0));
942         _owner = address(0);
943     }
944 
945     /**
946      * @dev Transfers ownership of the contract to a new account (`newOwner`).
947      * Can only be called by the current owner.
948      */
949     function transferOwnership(address newOwner) public virtual onlyOwner {
950         require(newOwner != address(0), "Ownable: new owner is the zero address");
951         emit OwnershipTransferred(_owner, newOwner);
952         _owner = newOwner;
953     }
954 }
955 
956 // File: contracts/BloodyToken.sol
957 
958 pragma solidity ^0.6.2;
959 
960 
961 
962 contract BloodyToken is ERC20ElasticTransferBurn("BloodyToken", "BLOODY"), Ownable {
963     using SafeMath for uint256;
964 
965     // store how many transfers have occurred every hour
966     // to calculate the burn divisor
967     uint256 public transferVolumeNowBucket;
968     uint256 public transferVolume1HourAgoBucket;
969 
970     // store the now timestamp to know when it has expired
971     uint256 public transferVolumeNowBucketTimestamp;
972 
973     constructor() public {
974         // set to arbitrary initial values
975         _setBurnDivisor(100);
976         _setElasticMultiplier(10);
977 
978         // freeze transfers for 5 minutes after rebase
979         // to mitigate users transferring wrong amounts
980         transferAfterRebaseFreezeTime = 5 minutes;
981 
982         transferVolumeNowBucketTimestamp = getTransferVolumeNowBucketTimestamp();
983     }
984 
985     function getTransferVolumeNowBucketTimestamp() public view returns (uint256) {
986         // 3600 seconds per hour
987         // round the timestamp bucket every hour
988         return block.timestamp - (block.timestamp % 3600);
989     }
990 
991     event Rebase(
992         uint256 indexed transferVolumeNowBucketTimestamp, uint256 burnDivisor, uint256 elasticMultiplier, 
993         uint256 transferVolume1HourAgoBucket, uint256 transferVolume2HoursAgoBucket
994     );
995 
996     uint256 public lastRebaseTimestamp;
997     uint256 public transferAfterRebaseFreezeTime;
998 
999     function rebase() public {
1000         // time is still in current bucket, does not need updating
1001         require(requiresRebase() == true, "someone else called rebase already");
1002 
1003         // update volume buckets
1004         // shift buckets 1 spot
1005         uint256 transferVolume2HoursAgoBucket = transferVolume1HourAgoBucket;
1006         transferVolume1HourAgoBucket = transferVolumeNowBucket;
1007         transferVolumeNowBucket = 0;
1008 
1009         // store new timestamp
1010         transferVolumeNowBucketTimestamp = getTransferVolumeNowBucketTimestamp();
1011 
1012         // mint half the burn to the uniswap pairs
1013         // make sure to sync the uniswap pairs after
1014         uint256 uniswapPairReward = transferVolume1HourAgoBucket.div(burnDivisor()).div(2);
1015         mintToUniswapPairs(uniswapPairReward);
1016 
1017         // rebase supply and burn rate
1018         uint256 newBurnDivisor = calculateBurnDivisor(burnDivisor(), transferVolume1HourAgoBucket, transferVolume2HoursAgoBucket);
1019         // arbitrarily set elastic modifier to 10x the burn rate (10 * 100 / burnDivisor)
1020         // if bloody circulates, spill rate increases, but clotting decreases
1021         // if volume increases, burn rate increases (burn divisor decreases), supply increases
1022         uint256 newElasticMultiplier = uint256(1000).div(newBurnDivisor);
1023         _setBurnDivisor(newBurnDivisor);
1024         _setElasticMultiplier(newElasticMultiplier);
1025         emit Rebase(transferVolumeNowBucketTimestamp, newBurnDivisor, newElasticMultiplier, transferVolume1HourAgoBucket, transferVolume2HoursAgoBucket);
1026 
1027         // if uniswap pairs are not synced loss of
1028         // funds will occur after rebase or reward minting
1029         syncUniswapPairs();
1030 
1031         // set to false until next rebase
1032         setRequiresRebase(false);
1033         lastRebaseTimestamp = block.timestamp;
1034     }
1035 
1036     uint256 public constant minBurnPercent = 1;
1037     uint256 public constant maxBurnPercent = 12;
1038     // they are inversely correlated
1039     uint256 public constant minBurnDivisor = 100 / maxBurnPercent;
1040     uint256 public constant maxBurnDivisor = 100 / minBurnPercent;
1041 
1042     // if bloody circulates, spill rate increases, but clotting decreases
1043     // if volume decreases, burn rate decreases (burn divisor increases), supply decreases
1044     // if supply decreases, price goes up, which stimulates more volume, which in turn
1045     // increases burn
1046     // if volume increases, burn rate increases (burn divisor decreases), supply increases
1047     function calculateBurnDivisor(uint256 _previousBurnDivisor, uint256 _transferVolume1HourAgoBucket, uint256 _transferVolume2HoursAgoBucket) public view returns (uint256) {
1048         // convert burn divisor to burn percent using division precision
1049         int256 divisionPrecision = 10000;
1050         int256 preciseMinBurnPercent = int256(minBurnPercent) * divisionPrecision;
1051         int256 preciseMaxBurnPercent = int256(maxBurnPercent) * divisionPrecision;
1052         // don't divide by 0
1053         if (_previousBurnDivisor == 0) {
1054             return minBurnDivisor;
1055         }
1056         int256 precisePreviousBurnPercent = (100 * divisionPrecision) / int256(_previousBurnDivisor);
1057 
1058         // no update needed
1059         if (_transferVolume1HourAgoBucket == _transferVolume2HoursAgoBucket) {
1060             // never return burn divisor above or below max
1061             if (precisePreviousBurnPercent < preciseMinBurnPercent) {
1062                 return maxBurnDivisor;
1063             }
1064             else if (precisePreviousBurnPercent > preciseMaxBurnPercent) {
1065                 return minBurnDivisor;
1066             }
1067             else {
1068                 return _previousBurnDivisor;
1069             }
1070         }
1071 
1072         bool volumeHasIncreased = _transferVolume1HourAgoBucket > _transferVolume2HoursAgoBucket;
1073 
1074         // check for min / max already reached
1075         if (volumeHasIncreased) {
1076             // volume has increased but 
1077             // burn percent is already max (burn divisor is already min)
1078             if (precisePreviousBurnPercent >= preciseMaxBurnPercent) {
1079                 return minBurnDivisor;
1080             }
1081         }
1082         // volume has decreased
1083         else {
1084             // volume has decreased but 
1085             // burn percent is already min (burn divisor is already max)
1086             if (precisePreviousBurnPercent <= preciseMinBurnPercent) {
1087                 return maxBurnDivisor;
1088             }
1089         }
1090 
1091         // find the transfer volume difference ratio between the 2 hour buckets
1092         int256 transferVolumeRatio;
1093         if (_transferVolume1HourAgoBucket == 0) {
1094             transferVolumeRatio = -int256(_transferVolume2HoursAgoBucket + 1);
1095         }
1096         else if (_transferVolume2HoursAgoBucket == 0) {
1097             transferVolumeRatio = int256(_transferVolume1HourAgoBucket + 1);
1098         }
1099         else if (volumeHasIncreased) {
1100             transferVolumeRatio = int256(_transferVolume1HourAgoBucket / _transferVolume2HoursAgoBucket);
1101         }
1102         else {
1103             transferVolumeRatio = -int256(_transferVolume2HoursAgoBucket / _transferVolume1HourAgoBucket);
1104         }
1105 
1106         // find the burn percent modifier and the new burn percent
1107         // round division to 10000
1108         int256 preciseNewBurnPercent = calculateBurnPercentFromTransferVolumeRatio(
1109             precisePreviousBurnPercent,
1110             transferVolumeRatio * divisionPrecision, 
1111             preciseMinBurnPercent, 
1112             preciseMaxBurnPercent
1113         );
1114 
1115         // convert the burn percent back to burn divisor, without forgetting division precision
1116         return uint256((100 * divisionPrecision) / preciseNewBurnPercent);
1117     }
1118 
1119     function calculateBurnPercentFromTransferVolumeRatio(int256 _previousBurnPercent, int256 _transferVolumeRatio, int256 _minBurnPercent, int256 _maxBurnPercent) public pure returns (int256) {
1120         // this is a pure function, don't use globals min and max
1121         // because might use division precision
1122 
1123         // previous burn percent should never be bigger or smaller than max or min
1124         // but if the exception occurs it messes up the curve
1125         if (_previousBurnPercent < _minBurnPercent) {
1126             _previousBurnPercent = _minBurnPercent;
1127         }
1128         else if (_previousBurnPercent > _maxBurnPercent) {
1129             _previousBurnPercent = _maxBurnPercent;
1130         }
1131 
1132         // attempt to find burn divisor curve
1133         int256 burnPercentModifier = _transferVolumeRatio;
1134         int8 maxAttempt = 5;
1135         while (true) {
1136             int256 newBurnPercent = _previousBurnPercent + burnPercentModifier;
1137             // found burn divisor curve
1138             if (newBurnPercent < _maxBurnPercent && newBurnPercent > _minBurnPercent) {
1139                 return _previousBurnPercent + burnPercentModifier;
1140             }
1141 
1142             // curve formula brings too little change to burn divisor, not worth it
1143             if (maxAttempt-- == 0) {
1144                 // instead of returning the value very close to the min or max
1145                 // return min or max instead to avoid wasting gas
1146                 if (_transferVolumeRatio > 0) {
1147                     // if _transferVolumeRatio is positive, burn should increase
1148                     return _maxBurnPercent;
1149                 }
1150                 else {
1151                     // bigger than max would give min
1152                     return _minBurnPercent;
1153                 }
1154             }
1155 
1156             // divide by 2 until burnPercent + burnPercentModifier
1157             // fit between min and max to find the perfect curve
1158             burnPercentModifier = burnPercentModifier / 2;
1159         }
1160     }
1161 
1162     function transfer(address recipient, uint256 amount) public override returns (bool) {
1163         // if time for rebase, freeze all transfers until someone calls rebase
1164         require(requiresRebase() == false, "transfers are frozen until someone calls rebase");
1165         require(transfersAreFrozenAfterRebase() == false, "transfers are frozen for a few minutes after rebase");
1166         super.transfer(recipient, amount);
1167         updateTransferVolume(amount);
1168         return true;
1169     }
1170 
1171     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1172         // if time for rebase, freeze all transfers until someone calls rebase
1173         require(requiresRebase() == false, "transfers are frozen until someone calls rebase");
1174         require(transfersAreFrozenAfterRebase() == false, "transfers are frozen for a few minutes after rebase");
1175         super.transferFrom(sender, recipient, amount);
1176         updateTransferVolume(amount);
1177         return true;
1178     }
1179 
1180     function updateTransferVolume(uint256 volume) internal virtual {
1181         // keep track of transfer volume on each transfer
1182         // store the volume without elastic multiplier to know the real volume
1183         transferVolumeNowBucket = transferVolumeNowBucket.add(volume.div(elasticMultiplier()));
1184 
1185         // if 1 hour has passed, requires new rebase
1186         if (transferVolumeNowBucketTimestamp != getTransferVolumeNowBucketTimestamp()) {
1187             setRequiresRebase(true);
1188         }
1189     }
1190 
1191     function transfersAreFrozenAfterRebase() public view returns (bool) {
1192         // use < and not <= to always stop transfers that occur on the same block as a rebase
1193         // even if transferAfterRebaseFreezeTime is set to 0
1194         if (lastRebaseTimestamp + transferAfterRebaseFreezeTime < block.timestamp) {
1195             return false;
1196         }
1197         return true;
1198     }
1199 
1200     // if should rebase, freeze all transfers until someone calls rebase
1201     bool private _requiresRebase = false;
1202     // only require rebase on the next block
1203     uint256 private lastSetRequiresRebaseTimestamp;
1204 
1205     function requiresRebase() public view returns (bool) {
1206         if (_requiresRebase) {
1207             if (lastSetRequiresRebaseTimestamp < block.timestamp) {
1208                 return true;
1209             }
1210         }
1211         return false;
1212     }
1213 
1214     function setRequiresRebase (bool value) internal {
1215         _requiresRebase = value;
1216         lastSetRequiresRebaseTimestamp = block.timestamp;
1217     }
1218 
1219     // mint half the burn to the uniswap pair to incentivize liquidity
1220     // swapping or providing liquidity on any other pairs will cause
1221     // loss of funds after every rebase
1222     address public bloodyEthUniswapPair;
1223     address public bloodyNiceUniswapPair;
1224     address public bloodyRotUniswapPair;
1225 
1226     // called by owner after contract is deployed to set
1227     // the uniswap pair which receives half the burn to incentivize liquidity
1228     // then contract ownership is transfered to
1229     // address 0x0000000000000000000000000000000000000000 and can never be called again
1230     function setUniswapPairs(address _bloodyEthUniswapPair, address _bloodyNiceUniswapPair, address _bloodyRotUniswapPair) public virtual onlyOwner {
1231         bloodyEthUniswapPair = _bloodyEthUniswapPair;
1232         bloodyNiceUniswapPair = _bloodyNiceUniswapPair;
1233         bloodyRotUniswapPair = _bloodyRotUniswapPair;
1234     }
1235 
1236     // mint half the burn to the uniswap pairs
1237     // make sure to sync the uniswap pairs after
1238     // reward is half of the burn split into 3 pairs
1239     function mintToUniswapPairs(uint256 uniswapPairRewardAmount) internal {
1240         if (uniswapPairRewardAmount == 0) {
1241             return;
1242         }
1243         // reward is half of the burn split into 3 pairs
1244         uint256 amountPerPair = uniswapPairRewardAmount.div(3);
1245         if (uniswapPairRewardAmount == 0) {
1246             return;
1247         }
1248         if (bloodyEthUniswapPair != address(0)) {
1249             _mint(bloodyEthUniswapPair, amountPerPair);
1250         }
1251         if (bloodyNiceUniswapPair != address(0)) {
1252             _mint(bloodyNiceUniswapPair, amountPerPair);
1253         }
1254         if (bloodyRotUniswapPair != address(0)) {
1255             _mint(bloodyRotUniswapPair, amountPerPair);
1256         }
1257     }
1258 
1259     // if uniswap pairs are not synced loss of
1260     // funds will occur after rebase or reward minting
1261     function syncUniswapPairs() internal {
1262         if (bloodyEthUniswapPair != address(0)) {
1263             IUniswapV2Pair(bloodyEthUniswapPair).sync();
1264         }
1265         if (bloodyNiceUniswapPair != address(0)) {
1266             IUniswapV2Pair(bloodyNiceUniswapPair).sync();
1267         }
1268         if (bloodyRotUniswapPair != address(0)) {
1269             IUniswapV2Pair(bloodyRotUniswapPair).sync();
1270         }
1271     }
1272 
1273     // called by owner after contract is deployed to airdrop
1274     // tokens to inital holders, then contract ownership is transfered to
1275     // address 0x0000000000000000000000000000000000000000 and can never be called again
1276     function airdrop(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
1277         for (uint i = 0; i < recipients.length; i++) {
1278             _mint(recipients[i], amounts[i]);
1279         }
1280     }
1281 
1282     // util external function for website
1283     function totalSupplyBurnedElastic() external view returns (uint256) {
1284         return totalSupplyBurned().mul(elasticMultiplier());
1285     }
1286 
1287     // util external function for website
1288     // half the burn is minted to the uniswap pools
1289     // might not be accurate if uniswap pools aren't set yet
1290     function totalSupplyBurnedMinusRewards() public view returns (uint256) {
1291         return totalSupplyBurned().div(2);
1292     }
1293 
1294     // util external function for website
1295     function timeUntilNextRebase() external view returns (uint256) {
1296         uint256 rebaseTime = transferVolumeNowBucketTimestamp + 3600;
1297         if (rebaseTime <= block.timestamp) {
1298             return 0;
1299         }
1300         return rebaseTime - block.timestamp;
1301     }
1302 
1303     // util external function for website
1304     function nextRebaseTimestamp() external view returns (uint256) {
1305         return transferVolumeNowBucketTimestamp + 3600;
1306     }
1307 
1308     // util external function for website
1309     function transfersAreFrozen() external view returns (bool) {
1310         if (transfersAreFrozenAfterRebase() || requiresRebase()) {
1311             return true;
1312         }
1313         return false;
1314     }
1315 
1316     // util external function for website
1317     function transfersAreFrozenRequiresRebase() external view returns (bool) {
1318         return requiresRebase();
1319     }
1320 
1321     // util external function for website
1322     function timeUntilNextTransferAfterRebaseUnfreeze() external view virtual returns (uint256) {
1323         uint256 unfreezeTime = lastRebaseTimestamp + transferAfterRebaseFreezeTime;
1324         if (unfreezeTime <= block.timestamp) {
1325             return 0;
1326         }
1327         return unfreezeTime - block.timestamp;
1328     }
1329 
1330     // util external function for website
1331     function nextTransferAfterRebaseUnfreezeTimestamp() external view virtual returns (uint256) {
1332         return lastRebaseTimestamp + transferAfterRebaseFreezeTime;
1333     }
1334 
1335     // util external function for website
1336     function balanceInUniswapPair(address user, address uniswapPair) public view returns (uint256) {
1337         if (uniswapPair == address(0)) {
1338             return 0;
1339         }
1340         uint256 pairBloodyBalance = balanceOf(uniswapPair);
1341         if (pairBloodyBalance == 0) {
1342             return 0;
1343         }
1344         uint256 userLpBalance = IUniswapV2Pair(uniswapPair).balanceOf(user);
1345         if (userLpBalance == 0) {
1346             return 0;
1347         }
1348         uint256 lpTotalSupply = IUniswapV2Pair(uniswapPair).totalSupply();
1349         uint256 divisionPrecision = 1e12;
1350         uint256 userLpTotalOwnershipRatio = userLpBalance.mul(divisionPrecision).div(lpTotalSupply);
1351         return pairBloodyBalance.mul(userLpTotalOwnershipRatio).div(divisionPrecision);
1352     }
1353 
1354     // util external function for website
1355     function balanceInUniswapPairs(address user) public view returns (uint256) {
1356         return balanceInUniswapPair(user, bloodyEthUniswapPair)
1357             .add(balanceInUniswapPair(user, bloodyNiceUniswapPair))
1358             .add(balanceInUniswapPair(user, bloodyRotUniswapPair));
1359     }
1360 
1361     // util external function for website
1362     function balanceIncludingUniswapPairs(address user) external view returns (uint256) {
1363         return balanceOf(user).add(balanceInUniswapPairs(user));
1364     }
1365 }
1366 
1367 interface IUniswapV2Pair {
1368     function sync() external;
1369     function balanceOf(address owner) external view returns (uint);
1370     function totalSupply() external view returns (uint);
1371 }
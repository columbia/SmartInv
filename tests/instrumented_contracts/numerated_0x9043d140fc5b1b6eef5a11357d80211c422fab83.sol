1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.1;
3 
4 // File: contracts/lending/LendingInterface.sol
5 
6 interface LendingInterface {
7     function depositEth() external payable;
8 
9     function depositErc20(address tokenAddress, uint256 amount) external;
10 
11     function borrow(address tokenAddress, uint256 amount) external;
12 
13     function withdraw(address tokenAddress, uint256 amount) external;
14 
15     function repayEth() external payable;
16 
17     function repayErc20(address tokenAddress, uint256 amount) external;
18 
19     function forceLiquidate(address token, address account) external;
20 
21     function getStakingAddress() external view returns (address);
22 
23     function getTaxTokenAddress() external view returns (address);
24 
25     function getInterest() external view returns (uint256);
26 
27     function getTvl(address tokenAddress) external view returns (uint256);
28 
29     function getTotalLending(address tokenAddress) external view returns (uint256);
30 
31     function getTotalBorrowing(address tokenAddress) external view returns (uint256);
32 
33     function getTokenInfo(address tokenAddress)
34         external
35         view
36         returns (uint256 totalLendAmount, uint256 totalBorrowAmount);
37 
38     function getLenderAccount(address tokenAddress, address userAddress)
39         external
40         view
41         returns (uint256);
42 
43     function getBorrowerAccount(address tokenAddress, address userAddress)
44         external
45         view
46         returns (uint256);
47 
48     function getRemainingCredit(address tokenAddress, address userAddress)
49         external
50         view
51         returns (uint256);
52 
53     function getAccountInfo(address tokenAddress, address userAddress)
54         external
55         view
56         returns (
57             uint256 lendAccount,
58             uint256 borrowAccount,
59             uint256 remainingCredit
60         );
61 }
62 
63 // File: @openzeppelin/contracts/GSN/Context.sol
64 
65 /*
66  * @dev Provides information about the current execution context, including the
67  * sender of the transaction and its data. While these are generally available
68  * via msg.sender and msg.data, they should not be accessed in such a direct
69  * manner, since when dealing with GSN meta-transactions the account sending and
70  * paying for execution may not be the actual sender (as far as an application
71  * is concerned).
72  *
73  * This contract is only required for intermediate, library-like contracts.
74  */
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address payable) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
87 
88 /**
89  * @dev Interface of the ERC20 standard as defined in the EIP.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: @openzeppelin/contracts/math/SafeMath.sol
163 
164 /**
165  * @dev Wrappers over Solidity's arithmetic operations with added overflow
166  * checks.
167  *
168  * Arithmetic operations in Solidity wrap on overflow. This can easily result
169  * in bugs, because programmers usually assume that an overflow raises an
170  * error, which is the standard behavior in high level programming languages.
171  * `SafeMath` restores this intuition by reverting the transaction when an
172  * operation overflows.
173  *
174  * Using this library instead of the unchecked operations eliminates an entire
175  * class of bugs, so it's recommended to use it always.
176  */
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return sub(a, b, "SafeMath: subtraction overflow");
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b <= a, errorMessage);
221         uint256 c = a - b;
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
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
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return div(a, b, "SafeMath: division by zero");
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b > 0, errorMessage);
280         uint256 c = a / b;
281         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return mod(a, b, "SafeMath: modulo by zero");
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts with custom message when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b != 0, errorMessage);
316         return a % b;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/Address.sol
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
345         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
346         // for accounts without code, i.e. `keccak256('')`
347         bytes32 codehash;
348         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
349         // solhint-disable-next-line no-inline-assembly
350         assembly { codehash := extcodehash(account) }
351         return (codehash != accountHash && codehash != 0x0);
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(address(this).balance >= amount, "Address: insufficient balance");
372 
373         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
374         (bool success, ) = recipient.call{ value: amount }("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain`call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397       return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
407         return _functionCallWithValue(target, data, 0, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but also transferring `value` wei to `target`.
413      *
414      * Requirements:
415      *
416      * - the calling contract must have an ETH balance of at least `value`.
417      * - the called Solidity function must be `payable`.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         return _functionCallWithValue(target, data, value, errorMessage);
434     }
435 
436     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 // solhint-disable-next-line no-inline-assembly
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
461 
462 
463 
464 
465 
466 /**
467  * @dev Implementation of the {IERC20} interface.
468  *
469  * This implementation is agnostic to the way tokens are created. This means
470  * that a supply mechanism has to be added in a derived contract using {_mint}.
471  * For a generic mechanism see {ERC20PresetMinterPauser}.
472  *
473  * TIP: For a detailed writeup see our guide
474  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
475  * to implement supply mechanisms].
476  *
477  * We have followed general OpenZeppelin guidelines: functions revert instead
478  * of returning `false` on failure. This behavior is nonetheless conventional
479  * and does not conflict with the expectations of ERC20 applications.
480  *
481  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
482  * This allows applications to reconstruct the allowance for all accounts just
483  * by listening to said events. Other implementations of the EIP may not emit
484  * these events, as it isn't required by the specification.
485  *
486  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
487  * functions have been added to mitigate the well-known issues around setting
488  * allowances. See {IERC20-approve}.
489  */
490 contract ERC20 is Context, IERC20 {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     mapping (address => uint256) private _balances;
495 
496     mapping (address => mapping (address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     string private _name;
501     string private _symbol;
502     uint8 private _decimals;
503 
504     /**
505      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
506      * a default value of 18.
507      *
508      * To select a different value for {decimals}, use {_setupDecimals}.
509      *
510      * All three of these values are immutable: they can only be set once during
511      * construction.
512      */
513     constructor (string memory name_, string memory symbol_) {
514         _name = name_;
515         _symbol = symbol_;
516         _decimals = 18;
517     }
518 
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() public view returns (string memory) {
523         return _name;
524     }
525 
526     /**
527      * @dev Returns the symbol of the token, usually a shorter version of the
528      * name.
529      */
530     function symbol() public view returns (string memory) {
531         return _symbol;
532     }
533 
534     /**
535      * @dev Returns the number of decimals used to get its user representation.
536      * For example, if `decimals` equals `2`, a balance of `505` tokens should
537      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
538      *
539      * Tokens usually opt for a value of 18, imitating the relationship between
540      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
541      * called.
542      *
543      * NOTE: This information is only used for _display_ purposes: it in
544      * no way affects any of the arithmetic of the contract, including
545      * {IERC20-balanceOf} and {IERC20-transfer}.
546      */
547     function decimals() public view returns (uint8) {
548         return _decimals;
549     }
550 
551     /**
552      * @dev See {IERC20-totalSupply}.
553      */
554     function totalSupply() public view override returns (uint256) {
555         return _totalSupply;
556     }
557 
558     /**
559      * @dev See {IERC20-balanceOf}.
560      */
561     function balanceOf(address account) public view override returns (uint256) {
562         return _balances[account];
563     }
564 
565     /**
566      * @dev See {IERC20-transfer}.
567      *
568      * Requirements:
569      *
570      * - `recipient` cannot be the zero address.
571      * - the caller must have a balance of at least `amount`.
572      */
573     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
574         _transfer(_msgSender(), recipient, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-allowance}.
580      */
581     function allowance(address owner, address spender) public view virtual override returns (uint256) {
582         return _allowances[owner][spender];
583     }
584 
585     /**
586      * @dev See {IERC20-approve}.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      */
592     function approve(address spender, uint256 amount) public virtual override returns (bool) {
593         _approve(_msgSender(), spender, amount);
594         return true;
595     }
596 
597     /**
598      * @dev See {IERC20-transferFrom}.
599      *
600      * Emits an {Approval} event indicating the updated allowance. This is not
601      * required by the EIP. See the note at the beginning of {ERC20};
602      *
603      * Requirements:
604      * - `sender` and `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      * - the caller must have allowance for ``sender``'s tokens of at least
607      * `amount`.
608      */
609     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
610         _transfer(sender, recipient, amount);
611         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
612         return true;
613     }
614 
615     /**
616      * @dev Atomically increases the allowance granted to `spender` by the caller.
617      *
618      * This is an alternative to {approve} that can be used as a mitigation for
619      * problems described in {IERC20-approve}.
620      *
621      * Emits an {Approval} event indicating the updated allowance.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
628         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
629         return true;
630     }
631 
632     /**
633      * @dev Atomically decreases the allowance granted to `spender` by the caller.
634      *
635      * This is an alternative to {approve} that can be used as a mitigation for
636      * problems described in {IERC20-approve}.
637      *
638      * Emits an {Approval} event indicating the updated allowance.
639      *
640      * Requirements:
641      *
642      * - `spender` cannot be the zero address.
643      * - `spender` must have allowance for the caller of at least
644      * `subtractedValue`.
645      */
646     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
647         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
648         return true;
649     }
650 
651     /**
652      * @dev Moves tokens `amount` from `sender` to `recipient`.
653      *
654      * This is internal function is equivalent to {transfer}, and can be used to
655      * e.g. implement automatic token fees, slashing mechanisms, etc.
656      *
657      * Emits a {Transfer} event.
658      *
659      * Requirements:
660      *
661      * - `sender` cannot be the zero address.
662      * - `recipient` cannot be the zero address.
663      * - `sender` must have a balance of at least `amount`.
664      */
665     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
666         require(sender != address(0), "ERC20: transfer from the zero address");
667         require(recipient != address(0), "ERC20: transfer to the zero address");
668 
669         _beforeTokenTransfer(sender, recipient, amount);
670 
671         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
672         _balances[recipient] = _balances[recipient].add(amount);
673         emit Transfer(sender, recipient, amount);
674     }
675 
676     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
677      * the total supply.
678      *
679      * Emits a {Transfer} event with `from` set to the zero address.
680      *
681      * Requirements
682      *
683      * - `to` cannot be the zero address.
684      */
685     function _mint(address account, uint256 amount) internal virtual {
686         require(account != address(0), "ERC20: mint to the zero address");
687 
688         _beforeTokenTransfer(address(0), account, amount);
689 
690         _totalSupply = _totalSupply.add(amount);
691         _balances[account] = _balances[account].add(amount);
692         emit Transfer(address(0), account, amount);
693     }
694 
695     /**
696      * @dev Destroys `amount` tokens from `account`, reducing the
697      * total supply.
698      *
699      * Emits a {Transfer} event with `to` set to the zero address.
700      *
701      * Requirements
702      *
703      * - `account` cannot be the zero address.
704      * - `account` must have at least `amount` tokens.
705      */
706     function _burn(address account, uint256 amount) internal virtual {
707         require(account != address(0), "ERC20: burn from the zero address");
708 
709         _beforeTokenTransfer(account, address(0), amount);
710 
711         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
712         _totalSupply = _totalSupply.sub(amount);
713         emit Transfer(account, address(0), amount);
714     }
715 
716     /**
717      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
718      *
719      * This internal function is equivalent to `approve`, and can be used to
720      * e.g. set automatic allowances for certain subsystems, etc.
721      *
722      * Emits an {Approval} event.
723      *
724      * Requirements:
725      *
726      * - `owner` cannot be the zero address.
727      * - `spender` cannot be the zero address.
728      */
729     function _approve(address owner, address spender, uint256 amount) internal virtual {
730         require(owner != address(0), "ERC20: approve from the zero address");
731         require(spender != address(0), "ERC20: approve to the zero address");
732 
733         _allowances[owner][spender] = amount;
734         emit Approval(owner, spender, amount);
735     }
736 
737     /**
738      * @dev Sets {decimals} to a value other than the default one of 18.
739      *
740      * WARNING: This function should only be called from the constructor. Most
741      * applications that interact with token contracts will not expect
742      * {decimals} to ever change, and may work incorrectly if it does.
743      */
744     function _setupDecimals(uint8 decimals_) internal {
745         _decimals = decimals_;
746     }
747 
748     /**
749      * @dev Hook that is called before any transfer of tokens. This includes
750      * minting and burning.
751      *
752      * Calling conditions:
753      *
754      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
755      * will be to transferred to `to`.
756      * - when `from` is zero, `amount` tokens will be minted for `to`.
757      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
758      * - `from` and `to` are never both zero.
759      *
760      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
761      */
762     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
766 
767 
768 
769 
770 /**
771  * @title SafeERC20
772  * @dev Wrappers around ERC20 operations that throw on failure (when the token
773  * contract returns false). Tokens that return no value (and instead revert or
774  * throw on failure) are also supported, non-reverting calls are assumed to be
775  * successful.
776  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
777  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
778  */
779 library SafeERC20 {
780     using SafeMath for uint256;
781     using Address for address;
782 
783     function safeTransfer(IERC20 token, address to, uint256 value) internal {
784         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
785     }
786 
787     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
788         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
789     }
790 
791     /**
792      * @dev Deprecated. This function has issues similar to the ones found in
793      * {IERC20-approve}, and its usage is discouraged.
794      *
795      * Whenever possible, use {safeIncreaseAllowance} and
796      * {safeDecreaseAllowance} instead.
797      */
798     function safeApprove(IERC20 token, address spender, uint256 value) internal {
799         // safeApprove should only be called when setting an initial allowance,
800         // or when resetting it to zero. To increase and decrease it, use
801         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
802         // solhint-disable-next-line max-line-length
803         require((value == 0) || (token.allowance(address(this), spender) == 0),
804             "SafeERC20: approve from non-zero to non-zero allowance"
805         );
806         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
807     }
808 
809     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
810         uint256 newAllowance = token.allowance(address(this), spender).add(value);
811         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
812     }
813 
814     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
815         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
816         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
817     }
818 
819     /**
820      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
821      * on the return value: the return value is optional (but if data is returned, it must not be false).
822      * @param token The token targeted by the call.
823      * @param data The call data (encoded using abi.encode or one of its variants).
824      */
825     function _callOptionalReturn(IERC20 token, bytes memory data) private {
826         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
827         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
828         // the target address contains contract code and also asserts for success in the low-level call.
829 
830         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
831         if (returndata.length > 0) { // Return data is optional
832             // solhint-disable-next-line max-line-length
833             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
834         }
835     }
836 }
837 
838 // File: contracts/token/TaxTokenInterface.sol
839 
840 
841 interface TaxTokenInterface is IERC20 {
842     function mintToken(
843         address,
844         uint256,
845         address
846     ) external;
847 
848     function registerWhitelist(address, address) external;
849 
850     function unregisterWhitelist(address) external;
851 
852     function updateLendingAddress(address) external;
853 
854     function updateIncentiveAddresses(address[] memory, uint256[] memory) external;
855 
856     function updateGovernanceAddress(address) external;
857 
858     function mintDeveloperFund() external;
859 
860     function mintIncentiveFund() external;
861 
862     function getGovernanceAddress() external view returns (address);
863 
864     function getDeveloperAddress() external view returns (address);
865 
866     function getLendingAddress() external view returns (address);
867 
868     function getFunds() external view returns (uint256 developerFund, uint256 incentiveFund);
869 
870     function getConfigs()
871         external
872         view
873         returns (
874             uint256 maxTotalSupply,
875             uint256 halvingStartLendValue,
876             uint256 halvingDecayRateE8,
877             uint256 developerFundRateE8,
878             uint256 incentiveFundRateE8
879         );
880 
881     function getIncentiveFundAddresses()
882         external
883         view
884         returns (
885             address[] memory incentiveFundAddresses,
886             uint256[] memory incentiveFundAllocationE8
887         );
888 
889     function getMintUnit() external view returns (uint256);
890 
891     function getOracleAddress(address) external view returns (address);
892 
893     function name() external view returns (string memory);
894 
895     function symbol() external view returns (string memory);
896 
897     function decimals() external view returns (uint8);
898 }
899 
900 // File: contracts/util/TransferETH.sol
901 
902 contract TransferETH {
903     receive() external payable {}
904 
905     /**
906      * @notice transfer `amount` ETH to the `recipient` account with emitting log
907      */
908     function _transferETH(
909         address payable recipient,
910         uint256 amount,
911         string memory errorMessage
912     ) internal {
913         (bool success, ) = recipient.call{value: amount}("");
914         require(success, errorMessage);
915     }
916 
917     function _transferETH(address payable recipient, uint256 amount) internal {
918         _transferETH(recipient, amount, "Transfer amount exceeds balance");
919     }
920 }
921 
922 // File: contracts/lending/Lending.sol
923 
924 
925 
926 
927 
928 
929 
930 contract Lending is LendingInterface, TransferETH {
931     using SafeMath for uint256;
932     using SafeERC20 for ERC20;
933 
934     /* ========== CONSTANT VARIABLES ========== */
935 
936     address internal constant ETH_ADDRESS = address(0);
937     uint256 internal constant COLLATERAL_RATIO = 100; // minimum collateral ratio is 100%.
938     TaxTokenInterface internal immutable _taxTokenContract;
939     address internal immutable _stakingAddress;
940     uint256 internal immutable _interestE3; // 0.0% - 100.0%
941 
942     /* ========== STATE VARIABLES ========== */
943 
944     mapping(bytes32 => uint256) internal _lenderAccount; // keccak(tokenAddress, userAddress) => amount
945     mapping(bytes32 => uint256) internal _borrowerAccount; // keccak(tokenAddress, userAddress) => amount
946     mapping(bytes32 => uint256) internal _remainingCredit; // keccak(tokenAddress, userAddress) => amount
947     mapping(address => uint256) internal _totalLending; // tokenAddress => amount
948     mapping(address => uint256) internal _totalBorrowing; // tokenAddress => amount
949 
950     /* ========== CONSTRUCTOR ========== */
951 
952     constructor(
953         address taxTokenAddress,
954         address stakingAddress,
955         uint256 interestE3
956     ) {
957         _taxTokenContract = TaxTokenInterface(taxTokenAddress);
958         _stakingAddress = stakingAddress;
959         _interestE3 = interestE3;
960     }
961 
962     /* ========== MUTATIVE FUNCTIONS ========== */
963 
964     /**
965      * @notice Deposit(lend) collateral in ETH.
966      * As users can potentially be borrowers as well, the function charges the upfront interest fee.
967      * Users can rececive the upfront interest fee in tax token.
968      */
969     function depositEth() external payable override {
970         uint256 feeRate = _deposit(msg.sender, ETH_ADDRESS, msg.value);
971         _transferETH(payable(_stakingAddress), feeRate);
972     }
973 
974     /**
975      * @notice Deposit(lend) collateral in any erc20 token.
976      * As users can potentially be borrowers as well, the function charges the upfront interest fee.
977      * Iff the erc20 token is whitelisted in the tax token, users can rececive the upfront interest fee in tax token.
978      */
979     function depositErc20(address tokenAddress, uint256 amount) external override {
980         ERC20(tokenAddress).safeTransferFrom(msg.sender, address(this), amount);
981         uint256 feeRate = _deposit(msg.sender, tokenAddress, amount);
982         ERC20(tokenAddress).safeTransfer(_stakingAddress, feeRate);
983     }
984 
985     /**
986      * @notice Borrow up to the amount of remaining credit.
987      */
988     function borrow(address tokenAddress, uint256 amount) external override {
989         _borrow(msg.sender, tokenAddress, amount);
990         if (tokenAddress == ETH_ADDRESS) {
991             _transferETH(msg.sender, amount);
992         } else {
993             ERC20(tokenAddress).safeTransfer(msg.sender, amount);
994         }
995     }
996 
997     /**
998      * @notice Withdraw the deposited (lended) collateral up to the amount of remaining credit.
999      */
1000     function withdraw(address tokenAddress, uint256 amount) external override {
1001         _withdraw(msg.sender, tokenAddress, amount);
1002         if (tokenAddress == ETH_ADDRESS) {
1003             _transferETH(msg.sender, amount);
1004         } else {
1005             ERC20(tokenAddress).safeTransfer(msg.sender, amount);
1006         }
1007     }
1008 
1009     function repayEth() external payable override {
1010         _repay(msg.sender, ETH_ADDRESS, msg.value);
1011     }
1012 
1013     /**
1014      * @notice Repay the borrowing erc20 token up to the amount of borrowing.
1015      */
1016     function repayErc20(address tokenAddress, uint256 amount) external override {
1017         ERC20(tokenAddress).safeTransferFrom(msg.sender, address(this), amount);
1018         _repay(msg.sender, tokenAddress, amount);
1019     }
1020 
1021     /**
1022      * @notice Force liquidate if the user doesn't have enough collateral.
1023      */
1024     function forceLiquidate(address token, address userAddress) external override {
1025         bytes32 account = keccak256(abi.encode(token, userAddress));
1026         require(
1027             _borrowerAccount[account] > _lenderAccount[account].mul(COLLATERAL_RATIO.div(100)),
1028             "enough collateral"
1029         );
1030         _totalLending[token] -= _lenderAccount[account];
1031         _totalBorrowing[token] -= _borrowerAccount[account];
1032         _borrowerAccount[account] = 0;
1033         _lenderAccount[account] = 0;
1034         _remainingCredit[account] = 0;
1035     }
1036 
1037     /* ========== INTERNAL FUNCTIONS ========== */
1038 
1039     function _deposit(
1040         address lender,
1041         address tokenAddress,
1042         uint256 amount
1043     ) internal returns (uint256 feeRate) {
1044         require(amount != 0, "cannot deposit zero amount");
1045         feeRate = amount.mul(_interestE3).div(1000);
1046         _totalLending[tokenAddress] = _totalLending[tokenAddress].add(amount).sub(feeRate);
1047         bytes32 account = keccak256(abi.encode(tokenAddress, lender));
1048         _lenderAccount[account] = _lenderAccount[account].add(amount).sub(feeRate);
1049         _remainingCredit[account] = _remainingCredit[account].add(amount).sub(feeRate);
1050         _taxTokenContract.mintToken(tokenAddress, amount, lender);
1051     }
1052 
1053     function _borrow(
1054         address lender,
1055         address tokenAddress,
1056         uint256 amount
1057     ) internal {
1058         bytes32 account = keccak256(abi.encode(tokenAddress, lender));
1059         require(amount != 0, "should borrow positive amount");
1060         require(amount <= _remainingCredit[account], "too much borrow");
1061         _totalBorrowing[tokenAddress] = _totalBorrowing[tokenAddress].add(amount);
1062         _remainingCredit[account] = _remainingCredit[account].sub(amount);
1063         _borrowerAccount[account] = _borrowerAccount[account].add(amount);
1064     }
1065 
1066     function _withdraw(
1067         address lender,
1068         address tokenAddress,
1069         uint256 amount
1070     ) internal {
1071         bytes32 account = keccak256(abi.encode(tokenAddress, lender));
1072         require(amount != 0, "should withdraw positive amount");
1073         require(amount <= _remainingCredit[account], "too much withdraw");
1074         _totalLending[tokenAddress] = _totalLending[tokenAddress].sub(amount);
1075         _remainingCredit[account] = _remainingCredit[account].sub(amount);
1076         _lenderAccount[account] = _lenderAccount[account].sub(amount);
1077     }
1078 
1079     function _repay(
1080         address lender,
1081         address tokenAddress,
1082         uint256 amount
1083     ) internal {
1084         bytes32 account = keccak256(abi.encode(tokenAddress, lender));
1085         require(amount != 0, "should repay positive amount");
1086         require(amount <= _borrowerAccount[account], "too much repay");
1087         _totalBorrowing[tokenAddress] = _totalBorrowing[tokenAddress].sub(amount);
1088         _remainingCredit[account] = _remainingCredit[account].add(amount);
1089         _borrowerAccount[account] = _borrowerAccount[account].sub(amount);
1090     }
1091 
1092     /* ========== CALL FUNCTIONS ========== */
1093 
1094     /**
1095      * @return staking contract address
1096      */
1097     function getStakingAddress() external view override returns (address) {
1098         return _stakingAddress;
1099     }
1100 
1101     /**
1102      * @return tax token address
1103      */
1104     function getTaxTokenAddress() external view override returns (address) {
1105         return address(_taxTokenContract);
1106     }
1107 
1108     /**
1109      * @return interest fee charged when deposit
1110      */
1111     function getInterest() external view override returns (uint256) {
1112         return _interestE3;
1113     }
1114 
1115     /**
1116      * @return total value locked of the token
1117      */
1118     function getTvl(address tokenAddress) external view override returns (uint256) {
1119         return _totalLending[tokenAddress];
1120     }
1121 
1122     /**
1123      * @return total lending amount of the token
1124      */
1125     function getTotalLending(address tokenAddress) external view override returns (uint256) {
1126         return _totalLending[tokenAddress];
1127     }
1128 
1129     /**
1130      * @return total borrowing amount of the token
1131      */
1132     function getTotalBorrowing(address tokenAddress) external view override returns (uint256) {
1133         return _totalBorrowing[tokenAddress];
1134     }
1135 
1136     /**
1137      * @notice Get token info
1138      */
1139     function getTokenInfo(address tokenAddress)
1140         external
1141         view
1142         override
1143         returns (uint256 totalLendAmount, uint256 totalBorrowAmount)
1144     {
1145         totalLendAmount = _totalLending[tokenAddress];
1146         totalBorrowAmount = _totalBorrowing[tokenAddress];
1147     }
1148 
1149     /**
1150      * @return total lending amount of the token belonging to the user
1151      */
1152     function getLenderAccount(address tokenAddress, address userAddress)
1153         external
1154         view
1155         override
1156         returns (uint256)
1157     {
1158         bytes32 account = keccak256(abi.encode(tokenAddress, userAddress));
1159         return _lenderAccount[account];
1160     }
1161 
1162     /**
1163      * @return total borrowing amount of the token belonging to the user
1164      */
1165     function getBorrowerAccount(address tokenAddress, address userAddress)
1166         external
1167         view
1168         override
1169         returns (uint256)
1170     {
1171         bytes32 account = keccak256(abi.encode(tokenAddress, userAddress));
1172         return _borrowerAccount[account];
1173     }
1174 
1175     /**
1176      * @return remaining credit amount of the token belonging to the user
1177      */
1178     function getRemainingCredit(address tokenAddress, address userAddress)
1179         external
1180         view
1181         override
1182         returns (uint256)
1183     {
1184         bytes32 account = keccak256(abi.encode(tokenAddress, userAddress));
1185         return _remainingCredit[account];
1186     }
1187 
1188     /**
1189      * @notice Get account info of the token belonging to the user
1190      */
1191     function getAccountInfo(address tokenAddress, address userAddress)
1192         external
1193         view
1194         override
1195         returns (
1196             uint256 lendAccount,
1197             uint256 borrowAccount,
1198             uint256 remainingCredit
1199         )
1200     {
1201         bytes32 account = keccak256(abi.encode(tokenAddress, userAddress));
1202         lendAccount = _lenderAccount[account];
1203         borrowAccount = _borrowerAccount[account];
1204         remainingCredit = _remainingCredit[account];
1205     }
1206 }
1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * Token was generated for FREE using https://vittominacori.github.io/erc20-generator/
5  *
6  * Smart Contract Source Code: https://github.com/vittominacori/erc20-generator
7  * Smart Contract Test Builds: https://travis-ci.com/github/vittominacori/erc20-generator
8  * Web Site Source Code: https://github.com/vittominacori/erc20-generator/tree/dapp
9  *
10  * Detailed Info: https://medium.com/@vittominacori/create-an-erc20-token-in-less-than-a-minute-2a8751c4d6f4
11  *
12  * Note: "Contract Source Code Verified (Similar Match)" means that this Token is similar to other tokens deployed
13  *  using the same generator. It is not an issue. It means that you won't need to verify your source code because of
14  *  it is already verified.
15  *
16  * Disclaimer: GENERATOR'S AUTHOR IS FREE OF ANY LIABILITY REGARDING THE TOKEN AND THE USE THAT IS MADE OF IT.
17  *  The following code is provided under MIT License. Anyone can use it as per their needs.
18  *  The generator's purpose is to make people able to tokenize their ideas without coding or paying for it.
19  *  Source code is well tested and continuously updated to reduce risk of bugs and introduce language optimizations.
20  *  Anyway the purchase of tokens involves a high degree of risk. Before acquiring tokens, it is recommended to
21  *  carefully weighs all the information and risks detailed in Token owner's Conditions.
22  */
23 
24 // File: @openzeppelin/contracts/GSN/Context.sol
25 
26 pragma solidity ^0.7.0;
27 
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
50 
51 
52 
53 pragma solidity ^0.7.0;
54 
55 /**
56  * @dev Interface of the ERC20 standard as defined in the EIP.
57  */
58 interface IERC20 {
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by `account`.
66      */
67     function balanceOf(address account) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transfer(address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `sender` to `recipient` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 // File: @openzeppelin/contracts/math/SafeMath.sol
130 
131 
132 
133 pragma solidity ^0.7.0;
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return sub(a, b, "SafeMath: subtraction overflow");
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b <= a, errorMessage);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209         // benefit is lost if 'b' is also tested.
210         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
211         if (a == 0) {
212             return 0;
213         }
214 
215         uint256 c = a * b;
216         require(c / a == b, "SafeMath: multiplication overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return div(a, b, "SafeMath: division by zero");
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b > 0, errorMessage);
251         uint256 c = a / b;
252         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         return mod(a, b, "SafeMath: modulo by zero");
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * Reverts with custom message when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/Address.sol
292 
293 
294 
295 pragma solidity ^0.7.0;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
436 
437 
438 
439 pragma solidity ^0.7.0;
440 
441 
442 
443 
444 
445 /**
446  * @dev Implementation of the {IERC20} interface.
447  *
448  * This implementation is agnostic to the way tokens are created. This means
449  * that a supply mechanism has to be added in a derived contract using {_mint}.
450  * For a generic mechanism see {ERC20PresetMinterPauser}.
451  *
452  * TIP: For a detailed writeup see our guide
453  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
454  * to implement supply mechanisms].
455  *
456  * We have followed general OpenZeppelin guidelines: functions revert instead
457  * of returning `false` on failure. This behavior is nonetheless conventional
458  * and does not conflict with the expectations of ERC20 applications.
459  *
460  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
461  * This allows applications to reconstruct the allowance for all accounts just
462  * by listening to said events. Other implementations of the EIP may not emit
463  * these events, as it isn't required by the specification.
464  *
465  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
466  * functions have been added to mitigate the well-known issues around setting
467  * allowances. See {IERC20-approve}.
468  */
469 contract ERC20 is Context, IERC20 {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     mapping (address => uint256) private _balances;
474 
475     mapping (address => mapping (address => uint256)) private _allowances;
476 
477     uint256 private _totalSupply;
478 
479     string private _name;
480     string private _symbol;
481     uint8 private _decimals;
482 
483     /**
484      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
485      * a default value of 18.
486      *
487      * To select a different value for {decimals}, use {_setupDecimals}.
488      *
489      * All three of these values are immutable: they can only be set once during
490      * construction.
491      */
492     constructor (string memory name_, string memory symbol_) {
493         _name = name_;
494         _symbol = symbol_;
495         _decimals = 18;
496     }
497 
498     /**
499      * @dev Returns the name of the token.
500      */
501     function name() public view returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @dev Returns the symbol of the token, usually a shorter version of the
507      * name.
508      */
509     function symbol() public view returns (string memory) {
510         return _symbol;
511     }
512 
513     /**
514      * @dev Returns the number of decimals used to get its user representation.
515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
516      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
517      *
518      * Tokens usually opt for a value of 18, imitating the relationship between
519      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
520      * called.
521      *
522      * NOTE: This information is only used for _display_ purposes: it in
523      * no way affects any of the arithmetic of the contract, including
524      * {IERC20-balanceOf} and {IERC20-transfer}.
525      */
526     function decimals() public view returns (uint8) {
527         return _decimals;
528     }
529 
530     /**
531      * @dev See {IERC20-totalSupply}.
532      */
533     function totalSupply() public view override returns (uint256) {
534         return _totalSupply;
535     }
536 
537     /**
538      * @dev See {IERC20-balanceOf}.
539      */
540     function balanceOf(address account) public view override returns (uint256) {
541         return _balances[account];
542     }
543 
544     /**
545      * @dev See {IERC20-transfer}.
546      *
547      * Requirements:
548      *
549      * - `recipient` cannot be the zero address.
550      * - the caller must have a balance of at least `amount`.
551      */
552     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
553         _transfer(_msgSender(), recipient, amount);
554         return true;
555     }
556 
557     /**
558      * @dev See {IERC20-allowance}.
559      */
560     function allowance(address owner, address spender) public view virtual override returns (uint256) {
561         return _allowances[owner][spender];
562     }
563 
564     /**
565      * @dev See {IERC20-approve}.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function approve(address spender, uint256 amount) public virtual override returns (bool) {
572         _approve(_msgSender(), spender, amount);
573         return true;
574     }
575 
576     /**
577      * @dev See {IERC20-transferFrom}.
578      *
579      * Emits an {Approval} event indicating the updated allowance. This is not
580      * required by the EIP. See the note at the beginning of {ERC20};
581      *
582      * Requirements:
583      * - `sender` and `recipient` cannot be the zero address.
584      * - `sender` must have a balance of at least `amount`.
585      * - the caller must have allowance for ``sender``'s tokens of at least
586      * `amount`.
587      */
588     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
589         _transfer(sender, recipient, amount);
590         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically increases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically decreases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      * - `spender` must have allowance for the caller of at least
623      * `subtractedValue`.
624      */
625     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
626         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
627         return true;
628     }
629 
630     /**
631      * @dev Moves tokens `amount` from `sender` to `recipient`.
632      *
633      * This is internal function is equivalent to {transfer}, and can be used to
634      * e.g. implement automatic token fees, slashing mechanisms, etc.
635      *
636      * Emits a {Transfer} event.
637      *
638      * Requirements:
639      *
640      * - `sender` cannot be the zero address.
641      * - `recipient` cannot be the zero address.
642      * - `sender` must have a balance of at least `amount`.
643      */
644     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
645         require(sender != address(0), "ERC20: transfer from the zero address");
646         require(recipient != address(0), "ERC20: transfer to the zero address");
647 
648         _beforeTokenTransfer(sender, recipient, amount);
649 
650         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
651         _balances[recipient] = _balances[recipient].add(amount);
652         emit Transfer(sender, recipient, amount);
653     }
654 
655     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
656      * the total supply.
657      *
658      * Emits a {Transfer} event with `from` set to the zero address.
659      *
660      * Requirements
661      *
662      * - `to` cannot be the zero address.
663      */
664     function _mint(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: mint to the zero address");
666 
667         _beforeTokenTransfer(address(0), account, amount);
668 
669         _totalSupply = _totalSupply.add(amount);
670         _balances[account] = _balances[account].add(amount);
671         emit Transfer(address(0), account, amount);
672     }
673 
674     /**
675      * @dev Destroys `amount` tokens from `account`, reducing the
676      * total supply.
677      *
678      * Emits a {Transfer} event with `to` set to the zero address.
679      *
680      * Requirements
681      *
682      * - `account` cannot be the zero address.
683      * - `account` must have at least `amount` tokens.
684      */
685     function _burn(address account, uint256 amount) internal virtual {
686         require(account != address(0), "ERC20: burn from the zero address");
687 
688         _beforeTokenTransfer(account, address(0), amount);
689 
690         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
691         _totalSupply = _totalSupply.sub(amount);
692         emit Transfer(account, address(0), amount);
693     }
694 
695     /**
696      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
697      *
698      * This internal function is equivalent to `approve`, and can be used to
699      * e.g. set automatic allowances for certain subsystems, etc.
700      *
701      * Emits an {Approval} event.
702      *
703      * Requirements:
704      *
705      * - `owner` cannot be the zero address.
706      * - `spender` cannot be the zero address.
707      */
708     function _approve(address owner, address spender, uint256 amount) internal virtual {
709         require(owner != address(0), "ERC20: approve from the zero address");
710         require(spender != address(0), "ERC20: approve to the zero address");
711 
712         _allowances[owner][spender] = amount;
713         emit Approval(owner, spender, amount);
714     }
715 
716     /**
717      * @dev Sets {decimals} to a value other than the default one of 18.
718      *
719      * WARNING: This function should only be called from the constructor. Most
720      * applications that interact with token contracts will not expect
721      * {decimals} to ever change, and may work incorrectly if it does.
722      */
723     function _setupDecimals(uint8 decimals_) internal {
724         _decimals = decimals_;
725     }
726 
727     /**
728      * @dev Hook that is called before any transfer of tokens. This includes
729      * minting and burning.
730      *
731      * Calling conditions:
732      *
733      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
734      * will be to transferred to `to`.
735      * - when `from` is zero, `amount` tokens will be minted for `to`.
736      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
737      * - `from` and `to` are never both zero.
738      *
739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
740      */
741     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
742 }
743 
744 // File: @openzeppelin/contracts/access/Ownable.sol
745 
746 
747 
748 pragma solidity ^0.7.0;
749 
750 /**
751  * @dev Contract module which provides a basic access control mechanism, where
752  * there is an account (an owner) that can be granted exclusive access to
753  * specific functions.
754  *
755  * By default, the owner account will be the one that deploys the contract. This
756  * can later be changed with {transferOwnership}.
757  *
758  * This module is used through inheritance. It will make available the modifier
759  * `onlyOwner`, which can be applied to your functions to restrict their use to
760  * the owner.
761  */
762 abstract contract Ownable is Context {
763     address private _owner;
764 
765     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
766 
767     /**
768      * @dev Initializes the contract setting the deployer as the initial owner.
769      */
770     constructor () {
771         address msgSender = _msgSender();
772         _owner = msgSender;
773         emit OwnershipTransferred(address(0), msgSender);
774     }
775 
776     /**
777      * @dev Returns the address of the current owner.
778      */
779     function owner() public view returns (address) {
780         return _owner;
781     }
782 
783     /**
784      * @dev Throws if called by any account other than the owner.
785      */
786     modifier onlyOwner() {
787         require(_owner == _msgSender(), "Ownable: caller is not the owner");
788         _;
789     }
790 
791     /**
792      * @dev Leaves the contract without owner. It will not be possible to call
793      * `onlyOwner` functions anymore. Can only be called by the current owner.
794      *
795      * NOTE: Renouncing ownership will leave the contract without an owner,
796      * thereby removing any functionality that is only available to the owner.
797      */
798     function renounceOwnership() public virtual onlyOwner {
799         emit OwnershipTransferred(_owner, address(0));
800         _owner = address(0);
801     }
802 
803     /**
804      * @dev Transfers ownership of the contract to a new account (`newOwner`).
805      * Can only be called by the current owner.
806      */
807     function transferOwnership(address newOwner) public virtual onlyOwner {
808         require(newOwner != address(0), "Ownable: new owner is the zero address");
809         emit OwnershipTransferred(_owner, newOwner);
810         _owner = newOwner;
811     }
812 }
813 
814 // File: eth-token-recover/contracts/TokenRecover.sol
815 
816 
817 
818 pragma solidity ^0.7.0;
819 
820 
821 
822 /**
823  * @title TokenRecover
824  * @author Vittorio Minacori (https://github.com/vittominacori)
825  * @dev Allow to recover any ERC20 sent into the contract for error
826  */
827 contract TokenRecover is Ownable {
828 
829     /**
830      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
831      * @param tokenAddress The token contract address
832      * @param tokenAmount Number of tokens to be sent
833      */
834     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
835         IERC20(tokenAddress).transfer(owner(), tokenAmount);
836     }
837 }
838 
839 // File: contracts/service/ServiceReceiver.sol
840 
841 
842 
843 pragma solidity ^0.7.0;
844 
845 
846 /**
847  * @title ServiceReceiver
848  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
849  * @dev Implementation of the ServiceReceiver
850  */
851 contract ServiceReceiver is TokenRecover {
852 
853     mapping (bytes32 => uint256) private _prices;
854 
855     event Created(string serviceName, address indexed serviceAddress);
856 
857     function pay(string memory serviceName) public payable {
858         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
859 
860         emit Created(serviceName, _msgSender());
861     }
862 
863     function getPrice(string memory serviceName) public view returns (uint256) {
864         return _prices[_toBytes32(serviceName)];
865     }
866 
867     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
868         _prices[_toBytes32(serviceName)] = amount;
869     }
870 
871     function withdraw(uint256 amount) public onlyOwner {
872         payable(owner()).transfer(amount);
873     }
874 
875     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
876         return keccak256(abi.encode(serviceName));
877     }
878 }
879 
880 // File: contracts/service/ServicePayer.sol
881 
882 
883 
884 pragma solidity ^0.7.0;
885 
886 
887 /**
888  * @title ServicePayer
889  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
890  * @dev Implementation of the ServicePayer
891  */
892 contract ServicePayer {
893 
894     constructor (address payable receiver, string memory serviceName) payable {
895         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
896     }
897 }
898 
899 // File: contracts/utils/GeneratorCopyright.sol
900 
901 
902 
903 pragma solidity ^0.7.0;
904 
905 /**
906  * @title GeneratorCopyright
907  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
908  * @dev Implementation of the GeneratorCopyright
909  */
910 contract GeneratorCopyright {
911 
912     string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
913     string private constant _VERSION = "v4.0.0";
914 
915     /**
916      * @dev Returns the token generator tool.
917      */
918     function generator() public pure returns (string memory) {
919         return _GENERATOR;
920     }
921 
922     /**
923      * @dev Returns the token generator version.
924      */
925     function version() public pure returns (string memory) {
926         return _VERSION;
927     }
928 }
929 
930 // File: contracts/token/ERC20/SimpleERC20.sol
931 
932 
933 
934 pragma solidity ^0.7.0;
935 
936 
937 
938 
939 /**
940  * @title SimpleERC20
941  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
942  * @dev Implementation of the SimpleERC20
943  */
944 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright {
945 
946     constructor (
947         string memory name,
948         string memory symbol,
949         uint256 initialBalance,
950         address payable feeReceiver
951     ) ERC20(name, symbol) ServicePayer(feeReceiver, "SimpleERC20") payable {
952         require(initialBalance > 0, "SimpleERC20: supply cannot be zero");
953 
954         _mint(_msgSender(), initialBalance);
955     }
956 }
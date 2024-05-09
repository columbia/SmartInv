1 // File: contracts/interfaces/ISaffronBase.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.1;
6 
7 interface ISaffronBase {
8   enum Tranche {S, AA, A}
9   enum LPTokenType {dsec, principal}
10 
11   // Store values (balances, dsec, vdsec) with TrancheUint256
12   struct TrancheUint256 {
13     uint256 S;
14     uint256 AA;
15     uint256 A;
16   }
17 
18   struct epoch_params {
19     uint256 start_date;       // Time when the platform launched
20     uint256 duration;         // Duration of epoch
21   }
22 }
23 
24 // File: contracts/interfaces/ISaffronStrategy.sol
25 
26 
27 pragma solidity ^0.7.1;
28 
29 
30 interface ISaffronStrategy is ISaffronBase{
31   function deploy_all_capital() external;
32   function select_adapter_for_liquidity_removal() external returns(address);
33   function add_adapter(address adapter_address) external;
34   function add_pool(address pool_address) external;
35   function delete_adapters() external;
36   function set_governance(address to) external;
37   function get_adapter_address(uint256 adapter_index) external view returns(address);
38 }
39 
40 // File: contracts/interfaces/ISaffronPool.sol
41 
42 
43 pragma solidity ^0.7.1;
44 
45 interface ISaffronPool is ISaffronBase {
46   function add_liquidity(uint256 amount, Tranche tranche) external;
47   function remove_liquidity(address v1_dsec_token_address, uint256 dsec_amount, address v1_principal_token_address, uint256 principal_amount) external;
48   function get_base_asset_address() external view returns(address);
49   function hourly_strategy(address adapter_address) external;
50   function wind_down_epoch(uint256 epoch, uint256 amount_sfi) external;
51   function set_governance(address to) external;
52   function get_epoch_cycle_params() external view returns (uint256, uint256);
53   function shutdown() external;
54 }
55 
56 // File: contracts/interfaces/ISaffronAdapter.sol
57 
58 
59 pragma solidity ^0.7.1;
60 
61 interface ISaffronAdapter is ISaffronBase {
62     function deploy_capital(uint256 amount) external;
63     function return_capital(uint256 base_asset_amount, address to) external;
64     function approve_transfer(address addr,uint256 amount) external;
65     function get_base_asset_address() external view returns(address);
66     function set_base_asset(address addr) external;
67     function get_holdings() external returns(uint256);
68     function get_interest(uint256 principal) external returns(uint256);
69     function set_governance(address to) external;
70 }
71 
72 // File: contracts/lib/SafeMath.sol
73 
74 
75 pragma solidity ^0.7.1;
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: contracts/lib/IERC20.sol
234 
235 
236 pragma solidity ^0.7.1;
237 
238 /**
239  * @dev Interface of the ERC20 standard as defined in the EIP.
240  */
241 interface IERC20 {
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `recipient`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Returns the remaining number of tokens that `spender` will be
263      * allowed to spend on behalf of `owner` through {transferFrom}. This is
264      * zero by default.
265      *
266      * This value changes when {approve} or {transferFrom} are called.
267      */
268     function allowance(address owner, address spender) external view returns (uint256);
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * IMPORTANT: Beware that changing an allowance with this method brings the risk
276      * that someone may use both the old and the new allowance by unfortunate
277      * transaction ordering. One possible solution to mitigate this race
278      * condition is to first reduce the spender's allowance to 0 and set the
279      * desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address spender, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Moves `amount` tokens from `sender` to `recipient` using the
288      * allowance mechanism. `amount` is then deducted from the caller's
289      * allowance.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 // File: contracts/lib/Context.sol
313 
314 
315 pragma solidity ^0.7.1;
316 
317 /*
318  * @dev Provides information about the current execution context, including the
319  * sender of the transaction and its data. While these are generally available
320  * via msg.sender and msg.data, they should not be accessed in such a direct
321  * manner, since when dealing with GSN meta-transactions the account sending and
322  * paying for execution may not be the actual sender (as far as an application
323  * is concerned).
324  *
325  * This contract is only required for intermediate, library-like contracts.
326  */
327 abstract contract Context {
328     function _msgSender() internal view virtual returns (address payable) {
329         return msg.sender;
330     }
331 
332     function _msgData() internal view virtual returns (bytes memory) {
333         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
334         return msg.data;
335     }
336 }
337 
338 // File: contracts/lib/Address.sol
339 
340 
341 pragma solidity ^0.7.1;
342 
343 /**
344  * @dev Collection of functions related to the address type
345  */
346 library Address {
347     /**
348      * @dev Returns true if `account` is a contract.
349      *
350      * [IMPORTANT]
351      * ====
352      * It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      *
355      * Among others, `isContract` will return false for the following
356      * types of addresses:
357      *
358      *  - an externally-owned account
359      *  - a contract in construction
360      *  - an address where a contract will be created
361      *  - an address where a contract lived, but was destroyed
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies on extcodesize, which returns 0 for contracts in
366         // construction, since the code is only stored at the end of the
367         // constructor execution.
368 
369         uint256 size;
370         // solhint-disable-next-line no-inline-assembly
371         assembly { size := extcodesize(account) }
372         return size > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
395         (bool success, ) = recipient.call{ value: amount }("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 
399     /**
400      * @dev Performs a Solidity function call using a low level `call`. A
401      * plain`call` is an unsafe replacement for a function call: use this
402      * function instead.
403      *
404      * If `target` reverts with a revert reason, it is bubbled up by this
405      * function (like regular Solidity function calls).
406      *
407      * Returns the raw returned data. To convert to the expected return value,
408      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
409      *
410      * Requirements:
411      *
412      * - `target` must be a contract.
413      * - calling `target` with `data` must not revert.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
453         require(address(this).balance >= value, "Address: insufficient balance for call");
454         require(isContract(target), "Address: call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.call{ value: value }(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.3._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.3._
500      */
501     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
502         require(isContract(target), "Address: delegate call to non-contract");
503 
504         // solhint-disable-next-line avoid-low-level-calls
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 // solhint-disable-next-line no-inline-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: contracts/lib/ERC20.sol
530 
531 
532 pragma solidity ^0.7.1;
533 
534 
535 
536 
537 
538 /**
539  * @dev Implementation of the {IERC20} interface.
540  *
541  * This implementation is agnostic to the way tokens are created. This means
542  * that a supply mechanism has to be added in a derived contract using {_mint}.
543  * For a generic mechanism see {ERC20PresetMinterPauser}.
544  *
545  * TIP: For a detailed writeup see our guide
546  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
547  * to implement supply mechanisms].
548  *
549  * We have followed general OpenZeppelin guidelines: functions revert instead
550  * of returning `false` on failure. This behavior is nonetheless conventional
551  * and does not conflict with the expectations of ERC20 applications.
552  *
553  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
554  * This allows applications to reconstruct the allowance for all accounts just
555  * by listening to said events. Other implementations of the EIP may not emit
556  * these events, as it isn't required by the specification.
557  *
558  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
559  * functions have been added to mitigate the well-known issues around setting
560  * allowances. See {IERC20-approve}.
561  */
562 contract ERC20 is Context, IERC20 {
563     using SafeMath for uint256;
564     using Address for address;
565 
566     mapping (address => uint256) private _balances;
567 
568     mapping (address => mapping (address => uint256)) private _allowances;
569 
570     uint256 private _totalSupply;
571 
572     string private _name;
573     string private _symbol;
574     uint8 private _decimals;
575 
576     /**
577      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
578      * a default value of 18.
579      *
580      * To select a different value for {decimals}, use {_setupDecimals}.
581      *
582      * All three of these values are immutable: they can only be set once during
583      * construction.
584      */
585     constructor (string memory name_, string memory symbol_) {
586         _name = name_;
587         _symbol = symbol_;
588         _decimals = 18;
589     }
590 
591     /**
592      * @dev Returns the name of the token.
593      */
594     function name() public view returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev Returns the symbol of the token, usually a shorter version of the
600      * name.
601      */
602     function symbol() public view returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev Returns the number of decimals used to get its user representation.
608      * For example, if `decimals` equals `2`, a balance of `505` tokens should
609      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
610      *
611      * Tokens usually opt for a value of 18, imitating the relationship between
612      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
613      * called.
614      *
615      * NOTE: This information is only used for _display_ purposes: it in
616      * no way affects any of the arithmetic of the contract, including
617      * {IERC20-balanceOf} and {IERC20-transfer}.
618      */
619     function decimals() public view returns (uint8) {
620         return _decimals;
621     }
622 
623     /**
624      * @dev See {IERC20-totalSupply}.
625      */
626     function totalSupply() public view override returns (uint256) {
627         return _totalSupply;
628     }
629 
630     /**
631      * @dev See {IERC20-balanceOf}.
632      */
633     function balanceOf(address account) public view override returns (uint256) {
634         return _balances[account];
635     }
636 
637     /**
638      * @dev See {IERC20-transfer}.
639      *
640      * Requirements:
641      *
642      * - `recipient` cannot be the zero address.
643      * - the caller must have a balance of at least `amount`.
644      */
645     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
646         _transfer(_msgSender(), recipient, amount);
647         return true;
648     }
649 
650     /**
651      * @dev See {IERC20-allowance}.
652      */
653     function allowance(address owner, address spender) public view virtual override returns (uint256) {
654         return _allowances[owner][spender];
655     }
656 
657     /**
658      * @dev See {IERC20-approve}.
659      *
660      * Requirements:
661      *
662      * - `spender` cannot be the zero address.
663      */
664     function approve(address spender, uint256 amount) public virtual override returns (bool) {
665         _approve(_msgSender(), spender, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-transferFrom}.
671      *
672      * Emits an {Approval} event indicating the updated allowance. This is not
673      * required by the EIP. See the note at the beginning of {ERC20};
674      *
675      * Requirements:
676      * - `sender` and `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      * - the caller must have allowance for ``sender``'s tokens of at least
679      * `amount`.
680      */
681     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
682         _transfer(sender, recipient, amount);
683         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
684         return true;
685     }
686 
687     /**
688      * @dev Atomically increases the allowance granted to `spender` by the caller.
689      *
690      * This is an alternative to {approve} that can be used as a mitigation for
691      * problems described in {IERC20-approve}.
692      *
693      * Emits an {Approval} event indicating the updated allowance.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
700         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
701         return true;
702     }
703 
704     /**
705      * @dev Atomically decreases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      * - `spender` must have allowance for the caller of at least
716      * `subtractedValue`.
717      */
718     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
720         return true;
721     }
722 
723     /**
724      * @dev Moves tokens `amount` from `sender` to `recipient`.
725      *
726      * This is internal function is equivalent to {transfer}, and can be used to
727      * e.g. implement automatic token fees, slashing mechanisms, etc.
728      *
729      * Emits a {Transfer} event.
730      *
731      * Requirements:
732      *
733      * - `sender` cannot be the zero address.
734      * - `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      */
737     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
738         require(sender != address(0), "ERC20: transfer from the zero address");
739         require(recipient != address(0), "ERC20: transfer to the zero address");
740 
741         _beforeTokenTransfer(sender, recipient, amount);
742 
743         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
744         _balances[recipient] = _balances[recipient].add(amount);
745         emit Transfer(sender, recipient, amount);
746     }
747 
748     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
749      * the total supply.
750      *
751      * Emits a {Transfer} event with `from` set to the zero address.
752      *
753      * Requirements
754      *
755      * - `to` cannot be the zero address.
756      */
757     function _mint(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: mint to the zero address");
759 
760         _beforeTokenTransfer(address(0), account, amount);
761 
762         _totalSupply = _totalSupply.add(amount);
763         _balances[account] = _balances[account].add(amount);
764         emit Transfer(address(0), account, amount);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens from `account`, reducing the
769      * total supply.
770      *
771      * Emits a {Transfer} event with `to` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `account` cannot be the zero address.
776      * - `account` must have at least `amount` tokens.
777      */
778     function _burn(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: burn from the zero address");
780 
781         _beforeTokenTransfer(account, address(0), amount);
782 
783         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
784         _totalSupply = _totalSupply.sub(amount);
785         emit Transfer(account, address(0), amount);
786     }
787 
788     /**
789      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
790      *
791      * This is internal function is equivalent to `approve`, and can be used to
792      * e.g. set automatic allowances for certain subsystems, etc.
793      *
794      * Emits an {Approval} event.
795      *
796      * Requirements:
797      *
798      * - `owner` cannot be the zero address.
799      * - `spender` cannot be the zero address.
800      */
801     function _approve(address owner, address spender, uint256 amount) internal virtual {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     /**
810      * @dev Sets {decimals} to a value other than the default one of 18.
811      *
812      * WARNING: This function should only be called from the constructor. Most
813      * applications that interact with token contracts will not expect
814      * {decimals} to ever change, and may work incorrectly if it does.
815      */
816     function _setupDecimals(uint8 decimals_) internal {
817         _decimals = decimals_;
818     }
819 
820     /**
821      * @dev Hook that is called before any transfer of tokens. This includes
822      * minting and burning.
823      *
824      * Calling conditions:
825      *
826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * will be to transferred to `to`.
828      * - when `from` is zero, `amount` tokens will be minted for `to`.
829      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
830      * - `from` and `to` are never both zero.
831      *
832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
833      */
834     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
835 }
836 
837 // File: contracts/lib/SafeERC20.sol
838 
839 
840 pragma solidity ^0.7.1;
841 
842 
843 
844 
845 /**
846  * @title SafeERC20
847  * @dev Wrappers around ERC20 operations that throw on failure (when the token
848  * contract returns false). Tokens that return no value (and instead revert or
849  * throw on failure) are also supported, non-reverting calls are assumed to be
850  * successful.
851  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
852  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
853  */
854 library SafeERC20 {
855   using SafeMath for uint256;
856   using Address for address;
857 
858   function safeTransfer(IERC20 token, address to, uint256 value) internal {
859     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
860   }
861 
862   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
863     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
864   }
865 
866   /**
867    * @dev Deprecated. This function has issues similar to the ones found in
868    * {IERC20-approve}, and its usage is discouraged.
869    *
870    * Whenever possible, use {safeIncreaseAllowance} and
871    * {safeDecreaseAllowance} instead.
872    */
873   function safeApprove(IERC20 token, address spender, uint256 value) internal {
874     // safeApprove should only be called when setting an initial allowance,
875     // or when resetting it to zero. To increase and decrease it, use
876     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
877     // solhint-disable-next-line max-line-length
878     require((value == 0) || (token.allowance(address(this), spender) == 0),
879       "SafeERC20: approve from non-zero to non-zero allowance"
880     );
881     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
882   }
883 
884   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
885     uint256 newAllowance = token.allowance(address(this), spender).add(value);
886     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
887   }
888 
889   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
890     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
891     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
892   }
893 
894   /**
895    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
896    * on the return value: the return value is optional (but if data is returned, it must not be false).
897    * @param token The token targeted by the call.
898    * @param data The call data (encoded using abi.encode or one of its variants).
899    */
900   function _callOptionalReturn(IERC20 token, bytes memory data) private {
901     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
902     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
903     // the target address contains contract code and also asserts for success in the low-level call.
904 
905     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
906     if (returndata.length > 0) { // Return data is optional
907       // solhint-disable-next-line max-line-length
908       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
909     }
910   }
911 }
912 
913 // File: contracts/SFI.sol
914 
915 
916 pragma solidity ^0.7.1;
917 
918 
919 
920 contract SFI is ERC20 {
921   using SafeERC20 for IERC20;
922 
923   address public governance;
924   address public SFI_minter;
925   uint256 public MAX_TOKENS = 100000 ether;
926 
927   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
928     // Initial governance is Saffron Deployer
929     governance = msg.sender;
930   }
931 
932   function mint_SFI(address to, uint256 amount) public {
933     require(msg.sender == SFI_minter, "must be SFI_minter");
934     require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
935     _mint(to, amount);
936   }
937 
938   function set_minter(address to) external {
939     require(msg.sender == governance, "must be governance");
940     SFI_minter = to;
941   }
942 
943   function set_governance(address to) external {
944     require(msg.sender == governance, "must be governance");
945     governance = to;
946   }
947 
948   event ErcSwept(address who, address to, address token, uint256 amount);
949   function erc_sweep(address _token, address _to) public {
950     require(msg.sender == governance, "must be governance");
951 
952     IERC20 tkn = IERC20(_token);
953     uint256 tBal = tkn.balanceOf(address(this));
954     tkn.safeTransfer(_to, tBal);
955 
956     emit ErcSwept(msg.sender, _to, _token, tBal);
957   }
958 }
959 
960 // File: contracts/SaffronLPBalanceToken.sol
961 
962 
963 pragma solidity ^0.7.1;
964 
965 
966 contract SaffronLPBalanceToken is ERC20 {
967   address public pool_address;
968 
969   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
970     // Set pool_address to saffron pool that created token
971     pool_address = msg.sender;
972   }
973 
974   // Allow creating new tranche tokens
975   function mint(address to, uint256 amount) public {
976     require(msg.sender == pool_address, "must be pool");
977     _mint(to, amount);
978   }
979 
980   function burn(address account, uint256 amount) public {
981     require(msg.sender == pool_address, "must be pool");
982     _burn(account, amount);
983   }
984 
985   function set_governance(address to) external {
986     require(msg.sender == pool_address, "must be pool");
987     pool_address = to;
988   }
989 }
990 
991 // File: contracts/SaffronPool.sol
992 
993 
994 pragma solidity ^0.7.1;
995 
996 
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 contract SaffronPool is ISaffronPool {
1006   using SafeMath for uint256;
1007   using SafeERC20 for IERC20;
1008 
1009   address public governance;           // Governance (v3: add off-chain/on-chain governance)
1010   address public base_asset_address;   // Base asset managed by the pool (DAI, USDT, YFI...)
1011   address public SFI_address;          // SFI token
1012   uint256 public pool_principal;       // Current principal balance (added minus removed)
1013   uint256 public pool_interest;        // Current interest balance (redeemable by dsec tokens)
1014   uint256 public tranche_A_multiplier; // Current yield multiplier for tranche A
1015   uint256 public SFI_ratio;            // Ratio of base asset to SFI necessary to join tranche A
1016 
1017   bool public _shutdown = false;       // v0, v1: shutdown the pool after the final capital deploy to prevent burning funds
1018 
1019   /**** ADAPTERS ****/
1020   address public best_adapter_address;              // Current best adapter selected by strategy
1021   uint256 public adapter_total_principal;           // v0, v1: only one adapter
1022   ISaffronAdapter[] private adapters;               // v2: list of adapters
1023   mapping(address=>uint256) private adapter_index;  // v1: adapter contract address lookup for array indexes
1024 
1025   /**** STRATEGY ****/
1026   address public strategy;
1027 
1028   /**** EPOCHS ****/
1029   epoch_params public epoch_cycle = epoch_params({
1030     start_date: 1604239200,   // 11/01/2020 @ 2:00pm (UTC)
1031     duration:   14 days       // 1210000 seconds
1032   });
1033 
1034   /**** EPOCH INDEXED STORAGE ****/
1035   uint256[] public epoch_principal;               // Total principal owned by the pool (all tranches)
1036   mapping(uint256=>bool) public epoch_wound_down; // True if epoch has been wound down already (governance)
1037 
1038   /**** EPOCH-TRANCHE INDEXED STORAGE ****/
1039   // Array of arrays, example: tranche_SFI_earned[epoch][Tranche.S]
1040   address[3][] public dsec_token_addresses;         // Address for each dsec token
1041   address[3][] public principal_token_addresses;    // Address for each principal token
1042   uint256[3][] public tranche_total_dsec;           // Total dsec (tokens + vdsec)
1043   uint256[3][] public tranche_total_principal;      // Total outstanding principal tokens
1044   uint256[3][] public tranche_total_utilized;       // Total utilized balance in each tranche
1045   uint256[3][] public tranche_total_unutilized;     // Total unutilized balance in each tranche
1046   uint256[3][] public tranche_S_virtual_utilized;   // Total utilized virtual balance taken from tranche S (first index unused)
1047   uint256[3][] public tranche_S_virtual_unutilized; // Total unutilized virtual balance taken from tranche S (first index unused)
1048   uint256[3][] public tranche_interest_earned;      // Interest earned (calculated at wind_down_epoch)
1049   uint256[3][] public tranche_SFI_earned;           // Total SFI earned (minted at wind_down_epoch)
1050 
1051   /**** SFI GENERATION ****/
1052   // v0: pool generates SFI based on subsidy schedule
1053   // v1: pool is distributed SFI generated by the strategy contract
1054   // v1: pools each get an amount of SFI generated depending on the total liquidity added within each interval
1055   TrancheUint256 public TRANCHE_SFI_MULTIPLIER = TrancheUint256({
1056     S:   95000,
1057     AA:  0,
1058     A:   5000
1059   });
1060 
1061   /**** TRANCHE BALANCES ****/
1062   // (v0 & v1: epochs are hard-forks)
1063   // (v2: epoch rollover implemented)
1064   // TrancheUint256 private eternal_unutilized_balances; // Unutilized balance (in base assets) for each tranche (assets held in this pool + assets held in platforms)
1065   // TrancheUint256 private eternal_utilized_balances;   // Balance for each tranche that is not held within this pool but instead held on a platform via an adapter
1066 
1067   /**** SAFFRON LP TOKENS ****/
1068   // If we just have a token address then we can look up epoch and tranche balance tokens using a mapping(address=>SaffronLPdsecInfo)
1069   // LP tokens are dsec (redeemable for interest+SFI) and principal (redeemable for base asset) tokens
1070   struct SaffronLPTokenInfo {
1071     bool        exists;
1072     uint256     epoch;
1073     Tranche     tranche;
1074     LPTokenType token_type;
1075   }
1076   mapping(address=>SaffronLPTokenInfo) private saffron_LP_token_info;
1077 
1078   constructor(address _strategy, address _base_asset, address _SFI_address) {
1079     governance = msg.sender;
1080     base_asset_address = _base_asset;
1081     strategy = _strategy;
1082     SFI_address = _SFI_address;
1083     tranche_A_multiplier = 10; // v1: start enhanced yield at 10X
1084     SFI_ratio = 1000;          // v1: constant ratio
1085   }
1086 
1087   function new_epoch(uint256 epoch, address[] memory saffron_LP_dsec_token_addresses, address[] memory saffron_LP_principal_token_addresses) public {
1088     require(tranche_total_principal.length == epoch, "improper new epoch");
1089 
1090     epoch_principal.push(0);
1091     tranche_total_dsec.push([0,0,0]);
1092     tranche_total_principal.push([0,0,0]);
1093     tranche_total_utilized.push([0,0,0]);
1094     tranche_total_unutilized.push([0,0,0]);
1095     tranche_S_virtual_utilized.push([0,0,0]);
1096     tranche_S_virtual_unutilized.push([0,0,0]);
1097     tranche_interest_earned.push([0,0,0]);
1098     tranche_SFI_earned.push([0,0,0]);
1099 
1100     dsec_token_addresses.push([       // Address for each dsec token
1101       saffron_LP_dsec_token_addresses[uint256(Tranche.S)],
1102       saffron_LP_dsec_token_addresses[uint256(Tranche.AA)],
1103       saffron_LP_dsec_token_addresses[uint256(Tranche.A)]
1104     ]);
1105 
1106     principal_token_addresses.push([  // Address for each principal token
1107       saffron_LP_principal_token_addresses[uint256(Tranche.S)],
1108       saffron_LP_principal_token_addresses[uint256(Tranche.AA)],
1109       saffron_LP_principal_token_addresses[uint256(Tranche.A)]
1110     ]);
1111 
1112     // Token info for looking up epoch and tranche of dsec tokens by token contract address
1113     saffron_LP_token_info[saffron_LP_dsec_token_addresses[uint256(Tranche.S)]] = SaffronLPTokenInfo({
1114       exists: true,
1115       epoch: epoch,
1116       tranche: Tranche.S,
1117       token_type: LPTokenType.dsec
1118     });
1119 
1120     saffron_LP_token_info[saffron_LP_dsec_token_addresses[uint256(Tranche.AA)]] = SaffronLPTokenInfo({
1121       exists: true,
1122       epoch: epoch,
1123       tranche: Tranche.AA,
1124       token_type: LPTokenType.dsec
1125     });
1126 
1127     saffron_LP_token_info[saffron_LP_dsec_token_addresses[uint256(Tranche.A)]] = SaffronLPTokenInfo({
1128       exists: true,
1129       epoch: epoch,
1130       tranche: Tranche.A,
1131       token_type: LPTokenType.dsec
1132     });
1133 
1134     // for looking up epoch and tranche of PRINCIPAL tokens by token contract address
1135     saffron_LP_token_info[saffron_LP_principal_token_addresses[uint256(Tranche.S)]] = SaffronLPTokenInfo({
1136       exists: true,
1137       epoch: epoch,
1138       tranche: Tranche.S,
1139       token_type: LPTokenType.principal
1140     });
1141 
1142     saffron_LP_token_info[saffron_LP_principal_token_addresses[uint256(Tranche.AA)]] = SaffronLPTokenInfo({
1143       exists: true,
1144       epoch: epoch,
1145       tranche: Tranche.AA,
1146       token_type: LPTokenType.principal
1147     });
1148 
1149     saffron_LP_token_info[saffron_LP_principal_token_addresses[uint256(Tranche.A)]] = SaffronLPTokenInfo({
1150       exists: true,
1151       epoch: epoch,
1152       tranche: Tranche.A,
1153       token_type: LPTokenType.principal
1154     });
1155   }
1156 
1157   struct BalanceVars {
1158     // Tranche balance
1159     uint256 deposit;  // User deposit
1160     uint256 capacity; // Capacity for user's intended tranche
1161     uint256 change;   // Change from deposit - capacity
1162 
1163     // S tranche specific vars
1164     uint256 consumed; // Total consumed
1165     uint256 utilized_consumed;
1166     uint256 unutilized_consumed;
1167     uint256 available_utilized;
1168     uint256 available_unutilized;
1169   }
1170   event TrancheBalance(uint256 tranche, uint256 amount, uint256 deposit, uint256 capacity, uint256 change, uint256 consumed, uint256 utilized_consumed, uint256 unutilized_consumed, uint256 available_utilized, uint256 available_unutilized);
1171   event DsecGeneration(uint256 time_remaining, uint256 amount, uint256 dsec, address dsec_address, uint256 epoch, uint256 tranche, address user_address, address principal_token_addr);
1172   event AddLiquidity(uint256 new_pool_principal, uint256 new_epoch_principal, uint256 new_eternal_balance, uint256 new_tranche_principal, uint256 new_tranche_dsec);
1173   // LP user adds liquidity to the pool
1174   // Pre-requisite (front-end): have user approve transfer on front-end to base asset using our contract address
1175   function add_liquidity(uint256 amount, Tranche tranche) external override {
1176     require(!_shutdown, "pool shutdown");
1177     require(tranche == Tranche.S || tranche == Tranche.A, "v1: can't add_liquidity into AA tranche");
1178     uint256 epoch = get_current_epoch();
1179     require(amount != 0, "can't add 0");
1180     require(epoch == 1, "v1: must be epoch 1 only"); // v1: can't add liquidity after epoch 0
1181     BalanceVars memory bv = BalanceVars({
1182       deposit: 0, 
1183       capacity: 0,
1184       change: 0,  
1185       consumed: 0,
1186       utilized_consumed: 0,
1187       unutilized_consumed: 0,
1188       available_utilized: 0,
1189       available_unutilized: 0
1190     });
1191     (bv.available_utilized, bv.available_unutilized) = get_available_S_balances();
1192 
1193     if (tranche == Tranche.S) {
1194       tranche_total_unutilized[epoch][uint256(Tranche.S)] = tranche_total_unutilized[epoch][uint256(Tranche.S)].add(amount);
1195       bv.deposit = amount;
1196     }
1197     // if (tranche == Tranche.AA) {} // v1: AA tranche disabled (S tranche is effectively AA)
1198     if (tranche == Tranche.A) {
1199       // Find capacity for S tranche to facilitate a deposit into A. Deposit is min(principal, capacity): restricted by the user's capital or S tranche capacity
1200       bv.capacity = (bv.available_utilized.add(bv.available_unutilized)).div(tranche_A_multiplier); 
1201       bv.deposit  = (amount < bv.capacity) ? amount : bv.capacity;
1202       bv.consumed = bv.deposit.mul(tranche_A_multiplier);
1203       if (bv.consumed <= bv.available_utilized) {
1204         // Take capacity from tranche S utilized first and give virtual utilized balance to AA
1205         bv.utilized_consumed = bv.consumed;
1206       } else {
1207         // Take capacity from tranche S utilized and tranche S unutilized and give virtual utilized/unutilized balances to AA
1208         bv.utilized_consumed = bv.available_utilized;
1209         bv.unutilized_consumed = bv.consumed.sub(bv.utilized_consumed);
1210         tranche_S_virtual_unutilized[epoch][uint256(Tranche.AA)] = tranche_S_virtual_unutilized[epoch][uint256(Tranche.AA)].add(bv.unutilized_consumed);
1211       }
1212       tranche_S_virtual_utilized[epoch][uint256(Tranche.AA)] = tranche_S_virtual_utilized[epoch][uint256(Tranche.AA)].add(bv.utilized_consumed);
1213       if (bv.deposit < amount) bv.change = amount.sub(bv.deposit);
1214     }
1215 
1216     // Calculate the dsec for deposited DAI
1217     uint256 dsec = bv.deposit.mul(get_seconds_until_epoch_end(epoch));
1218 
1219     // Update pool principal eternal and epoch state
1220     pool_principal = pool_principal.add(bv.deposit);                 // Add DAI to principal totals
1221     epoch_principal[epoch] = epoch_principal[epoch].add(bv.deposit); // Add DAI total balance for epoch
1222 
1223     // Update dsec and principal balance state
1224     tranche_total_dsec[epoch][uint256(tranche)] = tranche_total_dsec[epoch][uint256(tranche)].add(dsec);
1225     tranche_total_principal[epoch][uint256(tranche)] = tranche_total_principal[epoch][uint256(tranche)].add(bv.deposit);
1226 
1227     // Transfer DAI from LP to pool
1228     IERC20(base_asset_address).safeTransferFrom(msg.sender, address(this), bv.deposit);
1229     if (tranche == Tranche.A) IERC20(SFI_address).safeTransferFrom(msg.sender, address(this), bv.deposit / SFI_ratio);
1230 
1231     // Mint Saffron LP epoch 1 tranche dsec tokens and transfer them to sender
1232     SaffronLPBalanceToken(dsec_token_addresses[epoch][uint256(tranche)]).mint(msg.sender, dsec);
1233 
1234     // Mint Saffron LP epoch 1 tranche principal tokens and transfer them to sender
1235     SaffronLPBalanceToken(principal_token_addresses[epoch][uint256(tranche)]).mint(msg.sender, bv.deposit);
1236 
1237     emit TrancheBalance(uint256(tranche), bv.deposit, bv.deposit, bv.capacity, bv.change, bv.consumed, bv.utilized_consumed, bv.unutilized_consumed, bv.available_utilized, bv.available_unutilized);
1238     emit DsecGeneration(get_seconds_until_epoch_end(epoch), bv.deposit, dsec, dsec_token_addresses[epoch][uint256(tranche)], epoch, uint256(tranche), msg.sender, principal_token_addresses[epoch][uint256(tranche)]);
1239     emit AddLiquidity(pool_principal, epoch_principal[epoch], 0, tranche_total_principal[epoch][uint256(tranche)], tranche_total_dsec[epoch][uint256(tranche)]);
1240   }
1241 
1242 
1243   event WindDownEpochSFI(uint256 previous_epoch, uint256 S_SFI, uint256 AA_SFI, uint256 A_SFI);
1244   event WindDownEpochState(uint256 epoch, uint256 tranche_S_interest, uint256 tranche_AA_interest, uint256 tranche_A_interest, uint256 tranche_SFI_earnings_S, uint256 tranche_SFI_earnings_AA, uint256 tranche_SFI_earnings_A);
1245   struct WindDownVars {
1246     uint256 previous_epoch;
1247     uint256 epoch_interest;
1248     uint256 epoch_dsec;
1249     uint256 tranche_A_interest_ratio;
1250     uint256 tranche_A_interest;
1251     uint256 tranche_S_interest;
1252   }
1253 
1254   function wind_down_epoch(uint256 epoch, uint256 amount_sfi) public override {
1255     require(msg.sender == strategy, "must be strategy");
1256     require(!epoch_wound_down[epoch], "epoch already wound down");
1257     uint256 current_epoch = get_current_epoch();
1258     require(epoch < current_epoch, "cannot wind down future epoch");
1259     WindDownVars memory wind_down = WindDownVars({
1260       previous_epoch: 0,
1261       epoch_interest: 0,
1262       epoch_dsec: 0,
1263       tranche_A_interest_ratio: 0,
1264       tranche_A_interest: 0,
1265       tranche_S_interest: 0
1266     });
1267     wind_down.previous_epoch = current_epoch - 1;
1268     require(block.timestamp >= get_epoch_end(wind_down.previous_epoch), "can't call before epoch ended");
1269 
1270     // Calculate SFI earnings per tranche
1271     tranche_SFI_earned[epoch][uint256(Tranche.S)]  = TRANCHE_SFI_MULTIPLIER.S.mul(amount_sfi).div(100000);
1272     tranche_SFI_earned[epoch][uint256(Tranche.AA)] = TRANCHE_SFI_MULTIPLIER.AA.mul(amount_sfi).div(100000);
1273     tranche_SFI_earned[epoch][uint256(Tranche.A)]  = TRANCHE_SFI_MULTIPLIER.A.mul(amount_sfi).div(100000);
1274 
1275     emit WindDownEpochSFI(wind_down.previous_epoch, tranche_SFI_earned[epoch][uint256(Tranche.S)], tranche_SFI_earned[epoch][uint256(Tranche.AA)], tranche_SFI_earned[epoch][uint256(Tranche.A)]);
1276     // Calculate interest earnings per tranche
1277     // Wind down will calculate interest and SFI earned by each tranche for the epoch which has ended
1278     // Liquidity cannot be removed until wind_down_epoch is called and epoch_wound_down[epoch] is set to true
1279 
1280     // Calculate pool_interest
1281     // v0, v1: we only have one adapter
1282 
1283     ISaffronAdapter adapter = ISaffronAdapter(best_adapter_address);
1284     wind_down.epoch_interest = adapter.get_interest(adapter_total_principal);
1285     pool_interest = pool_interest.add(wind_down.epoch_interest);
1286 
1287     // Total dsec
1288     // TODO: assert (dsec.totalSupply == epoch_dsec)
1289     wind_down.epoch_dsec = tranche_total_dsec[epoch][uint256(Tranche.S)].add(tranche_total_dsec[epoch][uint256(Tranche.A)]);
1290     wind_down.tranche_A_interest_ratio = tranche_total_dsec[epoch][uint256(Tranche.A)].mul(1 ether).div(wind_down.epoch_dsec);
1291 
1292     // Calculate tranche share of interest
1293     wind_down.tranche_A_interest = (wind_down.epoch_interest.mul(wind_down.tranche_A_interest_ratio).div(1 ether)).mul(tranche_A_multiplier);
1294     wind_down.tranche_S_interest = wind_down.epoch_interest.sub(wind_down.tranche_A_interest);
1295 
1296     // Update state for remove_liquidity
1297     tranche_interest_earned[epoch][uint256(Tranche.S)]  = wind_down.tranche_S_interest;
1298     tranche_interest_earned[epoch][uint256(Tranche.AA)] = 0;
1299     tranche_interest_earned[epoch][uint256(Tranche.A)]  = wind_down.tranche_A_interest;
1300 
1301     // Distribute SFI earnings to S tranche based on S tranche % share of dsec via vdsec
1302     emit WindDownEpochState(epoch, wind_down.tranche_S_interest, 0, wind_down.tranche_A_interest, uint256(tranche_SFI_earned[epoch][uint256(Tranche.S)]), uint256(tranche_SFI_earned[epoch][uint256(Tranche.AA)]), uint256(tranche_SFI_earned[epoch][uint256(Tranche.A)]));
1303     epoch_wound_down[epoch] = true;
1304     delete wind_down;
1305   }
1306 
1307   event RemoveLiquidityDsec(uint256 dsec_percent, uint256 interest_owned, uint256 SFI_owned);
1308   event RemoveLiquidityPrincipal(uint256 principal);
1309   function remove_liquidity(address dsec_token_address, uint256 dsec_amount, address principal_token_address, uint256 principal_amount) external override {
1310     require(dsec_amount > 0 || principal_amount > 0, "can't remove 0");
1311     ISaffronAdapter best_adapter = ISaffronAdapter(best_adapter_address);
1312     uint256 interest_owned;
1313     uint256 SFI_earn;
1314     uint256 SFI_return;
1315     uint256 dsec_percent;
1316 
1317     // Update state for removal via dsec token
1318     if (dsec_token_address != address(0x0) && dsec_amount > 0) {
1319       // Get info about the v1 dsec token from its address and check that it exists
1320       SaffronLPTokenInfo memory token_info = saffron_LP_token_info[dsec_token_address];
1321       require(token_info.exists, "balance token lookup failed");
1322       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(dsec_token_address);
1323       require(sbt.balanceOf(msg.sender) >= dsec_amount, "insufficient dsec balance");
1324 
1325       // Token epoch must be a past epoch
1326       uint256 token_epoch = token_info.epoch;
1327       require(token_info.token_type == LPTokenType.dsec, "bad dsec address");
1328       require(token_epoch == 1, "v1: bal token epoch must be 1");
1329       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1330       uint256 tranche_dsec = tranche_total_dsec[token_epoch][uint256(token_info.tranche)];
1331 
1332       // Dsec gives user claim over a tranche's earned SFI and interest
1333       dsec_percent = (tranche_dsec == 0) ? 0 : dsec_amount.mul(1 ether).div(tranche_dsec);
1334       interest_owned = tranche_interest_earned[token_epoch][uint256(token_info.tranche)].mul(dsec_percent) / 1 ether;
1335       SFI_earn = tranche_SFI_earned[token_epoch][uint256(token_info.tranche)].mul(dsec_percent) / 1 ether;
1336 
1337       tranche_interest_earned[token_epoch][uint256(token_info.tranche)] = tranche_interest_earned[token_epoch][uint256(token_info.tranche)].sub(interest_owned);
1338       tranche_SFI_earned[token_epoch][uint256(token_info.tranche)] = tranche_SFI_earned[token_epoch][uint256(token_info.tranche)].sub(SFI_earn);
1339       tranche_total_dsec[token_epoch][uint256(token_info.tranche)] = tranche_total_dsec[token_epoch][uint256(token_info.tranche)].sub(dsec_amount);
1340       pool_interest = pool_interest.sub(interest_owned);
1341     }
1342 
1343     // Update state for removal via principal token
1344     if (principal_token_address != address(0x0) && principal_amount > 0) {
1345       // Get info about the v1 dsec token from its address and check that it exists
1346       SaffronLPTokenInfo memory token_info = saffron_LP_token_info[principal_token_address];
1347       require(token_info.exists, "balance token info lookup failed");
1348       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(principal_token_address);
1349       require(sbt.balanceOf(msg.sender) >= principal_amount, "insufficient principal balance");
1350 
1351       // Token epoch must be a past epoch
1352       uint256 token_epoch = token_info.epoch;
1353       require(token_info.token_type == LPTokenType.principal, "bad balance token address");
1354       require(token_epoch == 1, "v1: bal token epoch must be 1");
1355       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1356 
1357       tranche_total_principal[token_epoch][uint256(token_info.tranche)] = tranche_total_principal[token_epoch][uint256(token_info.tranche)].sub(principal_amount);
1358       epoch_principal[token_epoch] = epoch_principal[token_epoch].sub(principal_amount);
1359       pool_principal = pool_principal.sub(principal_amount);
1360       adapter_total_principal = adapter_total_principal.sub(principal_amount);
1361       if (token_info.tranche == Tranche.A) SFI_return = principal_amount / SFI_ratio;
1362     }
1363 
1364     // Transfer
1365     if (dsec_token_address != address(0x0) && dsec_amount > 0) {
1366       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(dsec_token_address);
1367       require(sbt.balanceOf(msg.sender) >= dsec_amount, "insufficient dsec balance");
1368       sbt.burn(msg.sender, dsec_amount);
1369       best_adapter.return_capital(interest_owned, msg.sender);
1370       IERC20(SFI_address).safeTransfer(msg.sender, SFI_earn);
1371       emit RemoveLiquidityDsec(dsec_percent, interest_owned, SFI_earn);
1372     }
1373     if (principal_token_address != address(0x0) && principal_amount > 0) {
1374       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(principal_token_address);
1375       require(sbt.balanceOf(msg.sender) >= principal_amount, "insufficient principal balance");
1376       sbt.burn(msg.sender, principal_amount);
1377       best_adapter.return_capital(principal_amount, msg.sender);
1378       IERC20(SFI_address).safeTransfer(msg.sender, SFI_return);
1379       emit RemoveLiquidityPrincipal(principal_amount);
1380     }
1381 
1382     require((dsec_token_address != address(0x0) && dsec_amount > 0) || (principal_token_address != address(0x0) && principal_amount > 0), "no action performed");
1383   }
1384 
1385   // Strategy contract calls this to deploy capital to platforms
1386   event StrategicDeploy(address adapter_address, uint256 amount, uint256 epoch);
1387   function hourly_strategy(address adapter_address) external override {
1388     require(msg.sender == strategy, "must be strategy");
1389     require(!_shutdown, "pool shutdown");
1390     uint256 epoch = get_current_epoch();
1391     best_adapter_address = adapter_address;
1392     ISaffronAdapter best_adapter = ISaffronAdapter(adapter_address);
1393     uint256 amount = IERC20(base_asset_address).balanceOf(address(this));
1394 
1395     // Update utilized/unutilized epoch-tranche state
1396     tranche_total_utilized[epoch][uint256(Tranche.S)] = tranche_total_utilized[epoch][uint256(Tranche.S)].add(tranche_total_unutilized[epoch][uint256(Tranche.S)]);
1397     tranche_total_utilized[epoch][uint256(Tranche.A)] = tranche_total_utilized[epoch][uint256(Tranche.A)].add(tranche_total_unutilized[epoch][uint256(Tranche.A)]);
1398     tranche_S_virtual_utilized[epoch][uint256(Tranche.AA)] = tranche_S_virtual_utilized[epoch][uint256(Tranche.AA)].add(tranche_S_virtual_unutilized[epoch][uint256(Tranche.AA)]);
1399 
1400     tranche_total_unutilized[epoch][uint256(Tranche.S)] = 0;
1401     tranche_total_unutilized[epoch][uint256(Tranche.A)] = 0;
1402     tranche_S_virtual_unutilized[epoch][uint256(Tranche.AA)] = 0;
1403 
1404     // Add principal to adapter total
1405     adapter_total_principal = adapter_total_principal.add(amount);
1406     emit StrategicDeploy(adapter_address, amount, epoch);
1407 
1408     // Move base assets to adapter and deploy
1409     IERC20(base_asset_address).safeTransfer(adapter_address, amount);
1410     best_adapter.deploy_capital(amount);
1411   }
1412 
1413   function shutdown() external override {
1414     require(msg.sender == strategy, "must be strategy");
1415     require(block.timestamp > get_epoch_end(1) - 1 days, "trying to shutdown too early");
1416     _shutdown = true;
1417   }
1418 
1419   /*** GOVERNANCE ***/
1420   function set_governance(address to) external override {
1421     require(msg.sender == governance, "must be governance");
1422     governance = to;
1423   }
1424 
1425   function set_best_adapter(address to) external {
1426     require(msg.sender == governance, "must be governance");
1427     best_adapter_address = to;
1428   }
1429 
1430   /*** TIME UTILITY FUNCTIONS ***/
1431   function get_epoch_end(uint256 epoch) public view returns (uint256) {
1432     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration));
1433   }
1434 
1435   function get_current_epoch() public view returns (uint256) {
1436     require(block.timestamp > epoch_cycle.start_date, "before epoch 0");
1437     return (block.timestamp - epoch_cycle.start_date) / epoch_cycle.duration;
1438   }
1439 
1440   function get_seconds_until_epoch_end(uint256 epoch) public view returns (uint256) {
1441     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration)).sub(block.timestamp);
1442   }
1443 
1444   /*** GETTERS ***/
1445   function get_available_S_balances() public view returns(uint256, uint256) {
1446     uint256 epoch = get_current_epoch();
1447     uint256 AA_A_utilized = tranche_S_virtual_utilized[epoch][uint256(Tranche.A)].add(tranche_S_virtual_utilized[epoch][uint256(Tranche.AA)]);
1448     uint256 AA_A_unutilized = tranche_S_virtual_unutilized[epoch][uint256(Tranche.A)].add(tranche_S_virtual_unutilized[epoch][uint256(Tranche.AA)]);
1449     uint256 S_utilized = tranche_total_utilized[epoch][uint256(Tranche.S)];
1450     uint256 S_unutilized = tranche_total_unutilized[epoch][uint256(Tranche.S)];
1451     return ((S_utilized > AA_A_utilized ? S_utilized - AA_A_utilized : 0), (S_unutilized > AA_A_unutilized ? S_unutilized - AA_A_unutilized : 0));
1452   }
1453   
1454   function get_epoch_cycle_params() external view override returns (uint256, uint256) {
1455     return (epoch_cycle.start_date, epoch_cycle.duration);
1456   }
1457 
1458   function get_base_asset_address() external view override returns(address) {
1459     return base_asset_address;
1460   }
1461 
1462   //***** ADAPTER FUNCTIONS *****//
1463   // Delete adapters (v0: for v0 wind-down)
1464   function delete_adapters() external {
1465     require(msg.sender == governance, "must be governance");
1466     require(block.timestamp > epoch_cycle.start_date + 5 weeks, "too soon");
1467     delete adapters;
1468   }
1469 
1470   event ErcSwept(address who, address to, address token, uint256 amount);
1471   function erc_sweep(address _token, address _to) public {
1472     require(msg.sender == governance, "must be governance");
1473     require(_token != base_asset_address && _token != SFI_address, "cannot sweep pool assets");
1474 
1475     IERC20 tkn = IERC20(_token);
1476     uint256 tBal = tkn.balanceOf(address(this));
1477     tkn.safeTransfer(_to, tBal);
1478 
1479     emit ErcSwept(msg.sender, _to, _token, tBal);
1480   }
1481 
1482   event Swept(address who, address to, uint256 sfiBal, uint256 baseBal);
1483   function sweep(address _to) public {
1484     require(msg.sender == governance, "must be governance");
1485     require(block.timestamp > epoch_cycle.start_date + 12 weeks, "v1: must be completed");
1486 
1487     IERC20 tkn = IERC20(address(SFI_address));
1488     uint256 sfiBal = tkn.balanceOf(address(this));
1489     tkn.safeTransfer(_to, sfiBal);
1490 
1491     IERC20 base = IERC20(address(base_asset_address));
1492     uint256 baseBal = base.balanceOf(address(this));
1493     base.safeTransfer(_to, baseBal);
1494 
1495     emit Swept(msg.sender, _to, sfiBal, baseBal);
1496   }
1497 }
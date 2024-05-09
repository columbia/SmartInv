1 // File: contracts/interfaces/ISaffronBase.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.7.1;
5 
6 interface ISaffronBase {
7   enum Tranche {S, AA, A, SAA, SA}
8   enum LPTokenType {dsec, principal}
9 
10   // Store values (balances, dsec, vdsec) with TrancheUint256
11   struct TrancheUint256 {
12     uint256 S;
13     uint256 AA;
14     uint256 A;
15     uint256 SAA;
16     uint256 SA;
17   }
18 }
19 
20 // File: contracts/interfaces/ISaffronStrategy.sol
21 
22 pragma solidity ^0.7.1;
23 
24 interface ISaffronStrategy {
25   function deploy_all_capital() external;
26   function select_adapter_for_liquidity_removal() external returns(address);
27   function add_adapter(address adapter_address) external;
28   function add_pool(address pool_address) external;
29   function delete_adapters() external;
30   function set_governance(address to) external;
31   function get_adapter_address(uint256 adapter_index) external view returns(address);
32 }
33 
34 // File: contracts/interfaces/ISaffronPool.sol
35 
36 pragma solidity ^0.7.1;
37 
38 interface ISaffronPool is ISaffronBase {
39   function add_liquidity(uint256 amount, Tranche tranche) external;
40   function remove_liquidity(address v1_dsec_token_address, uint256 dsec_amount, address v1_principal_token_address, uint256 principal_amount) external;
41   function hourly_strategy(address adapter_address) external;
42   function get_governance() external view returns(address);
43   function get_base_asset_address() external view returns(address);
44   function get_strategy_address() external view returns(address);
45   function delete_adapters() external;
46   function set_governance(address to) external;
47   function get_epoch_cycle_params() external view returns (uint256, uint256);
48   function shutdown() external;
49 }
50 
51 // File: contracts/interfaces/ISaffronAdapter.sol
52 
53 pragma solidity ^0.7.1;
54 
55 interface ISaffronAdapter is ISaffronBase {
56     function deploy_capital(uint256 amount) external;
57     function return_capital(uint256 base_asset_amount, address to) external;
58     function approve_transfer(address addr,uint256 amount) external;
59     function get_base_asset_address() external view returns(address);
60     function set_base_asset(address addr) external;
61     function get_holdings() external returns(uint256);
62     function get_interest(uint256 principal) external returns(uint256);
63     function set_governance(address to) external;
64 }
65 
66 // File: contracts/lib/SafeMath.sol
67 
68 pragma solidity ^0.7.1;
69 
70 /**
71  * @dev Wrappers over Solidity's arithmetic operations with added overflow
72  * checks.
73  *
74  * Arithmetic operations in Solidity wrap on overflow. This can easily result
75  * in bugs, because programmers usually assume that an overflow raises an
76  * error, which is the standard behavior in high level programming languages.
77  * `SafeMath` restores this intuition by reverting the transaction when an
78  * operation overflows.
79  *
80  * Using this library instead of the unchecked operations eliminates an entire
81  * class of bugs, so it's recommended to use it always.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a, "SafeMath: addition overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b <= a, errorMessage);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         return div(a, b, "SafeMath: division by zero");
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b > 0, errorMessage);
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * Reverts when dividing by zero.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 // File: contracts/lib/IERC20.sol
227 
228 pragma solidity ^0.7.1;
229 
230 /**
231  * @dev Interface of the ERC20 standard as defined in the EIP.
232  */
233 interface IERC20 {
234     /**
235      * @dev Returns the amount of tokens in existence.
236      */
237     function totalSupply() external view returns (uint256);
238 
239     /**
240      * @dev Returns the amount of tokens owned by `account`.
241      */
242     function balanceOf(address account) external view returns (uint256);
243 
244     /**
245      * @dev Moves `amount` tokens from the caller's account to `recipient`.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a {Transfer} event.
250      */
251     function transfer(address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Returns the remaining number of tokens that `spender` will be
255      * allowed to spend on behalf of `owner` through {transferFrom}. This is
256      * zero by default.
257      *
258      * This value changes when {approve} or {transferFrom} are called.
259      */
260     function allowance(address owner, address spender) external view returns (uint256);
261 
262     /**
263      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * IMPORTANT: Beware that changing an allowance with this method brings the risk
268      * that someone may use both the old and the new allowance by unfortunate
269      * transaction ordering. One possible solution to mitigate this race
270      * condition is to first reduce the spender's allowance to 0 and set the
271      * desired value afterwards:
272      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address spender, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Moves `amount` tokens from `sender` to `recipient` using the
280      * allowance mechanism. `amount` is then deducted from the caller's
281      * allowance.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Emitted when `value` tokens are moved from one account (`from`) to
291      * another (`to`).
292      *
293      * Note that `value` may be zero.
294      */
295     event Transfer(address indexed from, address indexed to, uint256 value);
296 
297     /**
298      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
299      * a call to {approve}. `value` is the new allowance.
300      */
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 }
303 
304 // File: contracts/lib/Context.sol
305 
306 pragma solidity ^0.7.1;
307 
308 /*
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with GSN meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319     function _msgSender() internal view virtual returns (address payable) {
320         return msg.sender;
321     }
322 
323     function _msgData() internal view virtual returns (bytes memory) {
324         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
325         return msg.data;
326     }
327 }
328 
329 // File: contracts/lib/Address.sol
330 
331 pragma solidity ^0.7.1;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         // solhint-disable-next-line no-inline-assembly
361         assembly { size := extcodesize(account) }
362         return size > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
385         (bool success, ) = recipient.call{ value: amount }("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain`call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but also transferring `value` wei to `target`.
424      *
425      * Requirements:
426      *
427      * - the calling contract must have an ETH balance of at least `value`.
428      * - the called Solidity function must be `payable`.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{ value: value }(data);
448         return _verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.staticcall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.3._
480      */
481     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.3._
490      */
491     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         // solhint-disable-next-line avoid-low-level-calls
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return _verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 // solhint-disable-next-line no-inline-assembly
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // File: contracts/lib/ERC20.sol
520 
521 pragma solidity ^0.7.1;
522 
523 
524 
525 
526 
527 /**
528  * @dev Implementation of the {IERC20} interface.
529  *
530  * This implementation is agnostic to the way tokens are created. This means
531  * that a supply mechanism has to be added in a derived contract using {_mint}.
532  * For a generic mechanism see {ERC20PresetMinterPauser}.
533  *
534  * TIP: For a detailed writeup see our guide
535  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
536  * to implement supply mechanisms].
537  *
538  * We have followed general OpenZeppelin guidelines: functions revert instead
539  * of returning `false` on failure. This behavior is nonetheless conventional
540  * and does not conflict with the expectations of ERC20 applications.
541  *
542  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
543  * This allows applications to reconstruct the allowance for all accounts just
544  * by listening to said events. Other implementations of the EIP may not emit
545  * these events, as it isn't required by the specification.
546  *
547  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
548  * functions have been added to mitigate the well-known issues around setting
549  * allowances. See {IERC20-approve}.
550  */
551 contract ERC20 is Context, IERC20 {
552     using SafeMath for uint256;
553     using Address for address;
554 
555     mapping (address => uint256) private _balances;
556 
557     mapping (address => mapping (address => uint256)) private _allowances;
558 
559     uint256 private _totalSupply;
560 
561     string private _name;
562     string private _symbol;
563     uint8 private _decimals;
564 
565     /**
566      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
567      * a default value of 18.
568      *
569      * To select a different value for {decimals}, use {_setupDecimals}.
570      *
571      * All three of these values are immutable: they can only be set once during
572      * construction.
573      */
574     constructor (string memory name_, string memory symbol_) {
575         _name = name_;
576         _symbol = symbol_;
577         _decimals = 18;
578     }
579 
580     /**
581      * @dev Returns the name of the token.
582      */
583     function name() public view returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the symbol of the token, usually a shorter version of the
589      * name.
590      */
591     function symbol() public view returns (string memory) {
592         return _symbol;
593     }
594 
595     /**
596      * @dev Returns the number of decimals used to get its user representation.
597      * For example, if `decimals` equals `2`, a balance of `505` tokens should
598      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
599      *
600      * Tokens usually opt for a value of 18, imitating the relationship between
601      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
602      * called.
603      *
604      * NOTE: This information is only used for _display_ purposes: it in
605      * no way affects any of the arithmetic of the contract, including
606      * {IERC20-balanceOf} and {IERC20-transfer}.
607      */
608     function decimals() public view returns (uint8) {
609         return _decimals;
610     }
611 
612     /**
613      * @dev See {IERC20-totalSupply}.
614      */
615     function totalSupply() public view override returns (uint256) {
616         return _totalSupply;
617     }
618 
619     /**
620      * @dev See {IERC20-balanceOf}.
621      */
622     function balanceOf(address account) public view override returns (uint256) {
623         return _balances[account];
624     }
625 
626     /**
627      * @dev See {IERC20-transfer}.
628      *
629      * Requirements:
630      *
631      * - `recipient` cannot be the zero address.
632      * - the caller must have a balance of at least `amount`.
633      */
634     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
635         _transfer(_msgSender(), recipient, amount);
636         return true;
637     }
638 
639     /**
640      * @dev See {IERC20-allowance}.
641      */
642     function allowance(address owner, address spender) public view virtual override returns (uint256) {
643         return _allowances[owner][spender];
644     }
645 
646     /**
647      * @dev See {IERC20-approve}.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      */
653     function approve(address spender, uint256 amount) public virtual override returns (bool) {
654         _approve(_msgSender(), spender, amount);
655         return true;
656     }
657 
658     /**
659      * @dev See {IERC20-transferFrom}.
660      *
661      * Emits an {Approval} event indicating the updated allowance. This is not
662      * required by the EIP. See the note at the beginning of {ERC20};
663      *
664      * Requirements:
665      * - `sender` and `recipient` cannot be the zero address.
666      * - `sender` must have a balance of at least `amount`.
667      * - the caller must have allowance for ``sender``'s tokens of at least
668      * `amount`.
669      */
670     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
671         _transfer(sender, recipient, amount);
672         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
673         return true;
674     }
675 
676     /**
677      * @dev Atomically increases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
689         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
690         return true;
691     }
692 
693     /**
694      * @dev Atomically decreases the allowance granted to `spender` by the caller.
695      *
696      * This is an alternative to {approve} that can be used as a mitigation for
697      * problems described in {IERC20-approve}.
698      *
699      * Emits an {Approval} event indicating the updated allowance.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      * - `spender` must have allowance for the caller of at least
705      * `subtractedValue`.
706      */
707     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
708         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
709         return true;
710     }
711 
712     /**
713      * @dev Moves tokens `amount` from `sender` to `recipient`.
714      *
715      * This is internal function is equivalent to {transfer}, and can be used to
716      * e.g. implement automatic token fees, slashing mechanisms, etc.
717      *
718      * Emits a {Transfer} event.
719      *
720      * Requirements:
721      *
722      * - `sender` cannot be the zero address.
723      * - `recipient` cannot be the zero address.
724      * - `sender` must have a balance of at least `amount`.
725      */
726     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
727         require(sender != address(0), "ERC20: transfer from the zero address");
728         require(recipient != address(0), "ERC20: transfer to the zero address");
729 
730         _beforeTokenTransfer(sender, recipient, amount);
731 
732         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
733         _balances[recipient] = _balances[recipient].add(amount);
734         emit Transfer(sender, recipient, amount);
735     }
736 
737     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
738      * the total supply.
739      *
740      * Emits a {Transfer} event with `from` set to the zero address.
741      *
742      * Requirements
743      *
744      * - `to` cannot be the zero address.
745      */
746     function _mint(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: mint to the zero address");
748 
749         _beforeTokenTransfer(address(0), account, amount);
750 
751         _totalSupply = _totalSupply.add(amount);
752         _balances[account] = _balances[account].add(amount);
753         emit Transfer(address(0), account, amount);
754     }
755 
756     /**
757      * @dev Destroys `amount` tokens from `account`, reducing the
758      * total supply.
759      *
760      * Emits a {Transfer} event with `to` set to the zero address.
761      *
762      * Requirements
763      *
764      * - `account` cannot be the zero address.
765      * - `account` must have at least `amount` tokens.
766      */
767     function _burn(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: burn from the zero address");
769 
770         _beforeTokenTransfer(account, address(0), amount);
771 
772         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
773         _totalSupply = _totalSupply.sub(amount);
774         emit Transfer(account, address(0), amount);
775     }
776 
777     /**
778      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
779      *
780      * This is internal function is equivalent to `approve`, and can be used to
781      * e.g. set automatic allowances for certain subsystems, etc.
782      *
783      * Emits an {Approval} event.
784      *
785      * Requirements:
786      *
787      * - `owner` cannot be the zero address.
788      * - `spender` cannot be the zero address.
789      */
790     function _approve(address owner, address spender, uint256 amount) internal virtual {
791         require(owner != address(0), "ERC20: approve from the zero address");
792         require(spender != address(0), "ERC20: approve to the zero address");
793 
794         _allowances[owner][spender] = amount;
795         emit Approval(owner, spender, amount);
796     }
797 
798     /**
799      * @dev Sets {decimals} to a value other than the default one of 18.
800      *
801      * WARNING: This function should only be called from the constructor. Most
802      * applications that interact with token contracts will not expect
803      * {decimals} to ever change, and may work incorrectly if it does.
804      */
805     function _setupDecimals(uint8 decimals_) internal {
806         _decimals = decimals_;
807     }
808 
809     /**
810      * @dev Hook that is called before any transfer of tokens. This includes
811      * minting and burning.
812      *
813      * Calling conditions:
814      *
815      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
816      * will be to transferred to `to`.
817      * - when `from` is zero, `amount` tokens will be minted for `to`.
818      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
819      * - `from` and `to` are never both zero.
820      *
821      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
822      */
823     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
824 }
825 
826 // File: contracts/lib/SafeERC20.sol
827 
828 pragma solidity ^0.7.1;
829 
830 
831 
832 
833 /**
834  * @title SafeERC20
835  * @dev Wrappers around ERC20 operations that throw on failure (when the token
836  * contract returns false). Tokens that return no value (and instead revert or
837  * throw on failure) are also supported, non-reverting calls are assumed to be
838  * successful.
839  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
840  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
841  */
842 library SafeERC20 {
843   using SafeMath for uint256;
844   using Address for address;
845 
846   function safeTransfer(IERC20 token, address to, uint256 value) internal {
847     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
848   }
849 
850   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
851     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
852   }
853 
854   /**
855    * @dev Deprecated. This function has issues similar to the ones found in
856    * {IERC20-approve}, and its usage is discouraged.
857    *
858    * Whenever possible, use {safeIncreaseAllowance} and
859    * {safeDecreaseAllowance} instead.
860    */
861   function safeApprove(IERC20 token, address spender, uint256 value) internal {
862     // safeApprove should only be called when setting an initial allowance,
863     // or when resetting it to zero. To increase and decrease it, use
864     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
865     // solhint-disable-next-line max-line-length
866     require((value == 0) || (token.allowance(address(this), spender) == 0),
867       "SafeERC20: approve from non-zero to non-zero allowance"
868     );
869     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
870   }
871 
872   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
873     uint256 newAllowance = token.allowance(address(this), spender).add(value);
874     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
875   }
876 
877   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
878     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
879     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
880   }
881 
882   /**
883    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
884    * on the return value: the return value is optional (but if data is returned, it must not be false).
885    * @param token The token targeted by the call.
886    * @param data The call data (encoded using abi.encode or one of its variants).
887    */
888   function _callOptionalReturn(IERC20 token, bytes memory data) private {
889     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
890     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
891     // the target address contains contract code and also asserts for success in the low-level call.
892 
893     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
894     if (returndata.length > 0) { // Return data is optional
895       // solhint-disable-next-line max-line-length
896       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
897     }
898   }
899 }
900 
901 // File: contracts/SFI.sol
902 
903 
904 pragma solidity ^0.7.1;
905 
906 
907 
908 contract SFI is ERC20 {
909   using SafeERC20 for IERC20;
910 
911   address public governance;
912   address public SFI_minter;
913   uint256 public MAX_TOKENS = 100000 ether;
914 
915   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
916     // Initial governance is Saffron Deployer
917     governance = msg.sender;
918   }
919 
920   function mint_SFI(address to, uint256 amount) public {
921     require(msg.sender == SFI_minter, "must be SFI_minter");
922     require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
923     _mint(to, amount);
924   }
925 
926   function set_minter(address to) external {
927     require(msg.sender == governance, "must be governance");
928     SFI_minter = to;
929   }
930 
931   function set_governance(address to) external {
932     require(msg.sender == governance, "must be governance");
933     governance = to;
934   }
935 
936   event ErcSwept(address who, address to, address token, uint256 amount);
937   function erc_sweep(address _token, address _to) public {
938     require(msg.sender == governance, "must be governance");
939 
940     IERC20 tkn = IERC20(_token);
941     uint256 tBal = tkn.balanceOf(address(this));
942     tkn.safeTransfer(_to, tBal);
943 
944     emit ErcSwept(msg.sender, _to, _token, tBal);
945   }
946 }
947 
948 // File: contracts/SaffronLPBalanceToken.sol
949 
950 pragma solidity ^0.7.1;
951 
952 
953 contract SaffronLPBalanceToken is ERC20 {
954   address public pool_address;
955 
956   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
957     // Set pool_address to saffron pool that created token
958     pool_address = msg.sender;
959   }
960 
961   // Allow creating new tranche tokens
962   function mint(address to, uint256 amount) public {
963     require(msg.sender == pool_address, "must be pool");
964     _mint(to, amount);
965   }
966 
967   function burn(address account, uint256 amount) public {
968     require(msg.sender == pool_address, "must be pool");
969     _burn(account, amount);
970   }
971 
972   function set_governance(address to) external {
973     require(msg.sender == pool_address, "must be pool");
974     pool_address = to;
975   }
976 }
977 
978 // File: contracts/SaffronPool.sol
979 
980 pragma solidity ^0.7.1;
981 
982 
983 
984 
985 
986 
987 
988 
989 
990 
991 
992 contract SaffronPool is ISaffronPool {
993   using SafeMath for uint256;
994   using SafeERC20 for IERC20;
995 
996   address public governance;           // Governance (v3: add off-chain/on-chain governance)
997   address public base_asset_address;   // Base asset managed by the pool (DAI, USDT, YFI...)
998   address public SFI_address;          // SFI token
999   address public team_address;         // Team SFI address
1000   uint256 public pool_principal;       // Current principal balance (added minus removed)
1001   uint256 public pool_interest;        // Current interest balance (redeemable by dsec tokens)
1002   uint256 public tranche_A_multiplier; // Current yield multiplier for tranche A
1003 
1004   bool public _shutdown = false; // v0 shutdown the pool after the final capital deploy to prevent burning funds
1005 
1006   /**** ADAPTERS ****/
1007   address public best_adapter_address;              // Current best adapter selected by strategy
1008   uint256 public adapter_total_principal;           // v0: only one adapter
1009   ISaffronAdapter[] private adapters;               // v1: list of adapters
1010   mapping(address=>uint256) private adapter_index;  // v1: adapter contract address lookup for array indexes
1011 
1012   /**** STRATEGY ****/
1013   ISaffronStrategy private strategy;
1014 
1015   /**** EPOCHS ****/
1016   struct epoch_params {
1017     uint256 start_date;       // Time when the activity cycle begins (set to blocktime at contract deployment)
1018     uint256 duration;         // Duration of epoch
1019   }
1020 
1021   epoch_params public epoch_cycle = epoch_params({
1022     start_date: 1604239200, // 11/01/2020 @ 2:00pm (UTC)
1023     duration: 2 weeks       // 1210000 seconds
1024   });
1025 
1026   /**** EPOCH INDEXED STORAGE ****/
1027   uint256[] public epoch_principal;               // Total principal owned by the pool (all tranches)
1028   mapping(uint256=>bool) public epoch_wound_down; // True if epoch has been wound down already (governance)
1029 
1030   /**** EPOCH-TRANCHE INDEXED STORAGE ****/
1031   // Array of arrays, example: tranche_SFI_earned[epoch][Tranche.S]
1032   address[3][] public dsec_token_addresses;      // Address for each dsec token
1033   address[3][] public principal_token_addresses; // Address for each principal token
1034   uint256[5][] public tranche_total_dsec;        // Total dsec (tokens + vdsec)
1035   uint256[5][] public tranche_total_principal;   // Total outstanding principal tokens
1036   uint256[3][] public tranche_total_vdsec_AA;    // Total AA vdsec
1037   uint256[3][] public tranche_total_vdsec_A;     // Total A vdsec
1038   uint256[5][] public tranche_interest_earned;   // Interest earned (calculated at wind_down_epoch)
1039   uint256[5][] public tranche_SFI_earned;        // Total SFI earned (minted at wind_down_epoch)
1040 
1041   /**** SFI GENERATION ****/
1042   // v0: pool generates SFI based on subsidy schedule
1043   // v1: pool is distributed SFI generated by the strategy contract
1044   // v1: pools each get an amount of SFI generated depending on the total liquidity added within each interval
1045   TrancheUint256 public TRANCHE_SFI_MULTIPLIER = TrancheUint256({
1046     S:   10,
1047     AA:  80,
1048     A:   10,
1049     SAA: 0,
1050     SA:  0
1051   });
1052 
1053   /**** TRANCHE BALANCES ****/
1054   // (v0: S, AA, and A only)
1055   // (v1: SAA and SA added)
1056   TrancheUint256 private eternal_unutilized_balances; // Unutilized balance (in base assets) for each tranche (assets held in this pool + assets held in platforms)
1057   TrancheUint256 private eternal_utilized_balances;   // Balance for each tranche that is not held within this pool but instead held on a platform via an adapter
1058 
1059   /**** SAFFRON V1 DSEC TOKENS ****/
1060   // If we just have a token address then we can look up epoch and tranche balance tokens using a mapping(address=>SaffronV1dsecInfo)
1061   struct SaffronV1TokenInfo {
1062     bool        exists;
1063     uint256     epoch;
1064     Tranche     tranche;
1065     LPTokenType token_type;
1066   }
1067   mapping(address=>SaffronV1TokenInfo) private saffron_v1_token_info;
1068 
1069   constructor(address _strategy, address _base_asset, address _SFI_address, address _team_address) {
1070     governance = msg.sender;
1071     base_asset_address = _base_asset;
1072     strategy = ISaffronStrategy(_strategy);
1073     SFI_address = _SFI_address;
1074     tranche_A_multiplier = 3;
1075     team_address = _team_address;
1076   }
1077 
1078   function new_epoch(uint256 epoch, address[] memory saffron_v1_dsec_token_addresses, address[] memory saffron_v1_principal_token_addresses) public {
1079     require(tranche_total_principal.length == epoch, "improper new epoch");
1080 
1081     epoch_principal.push(0);
1082     tranche_total_dsec.push([0,0,0,0,0]);
1083     tranche_total_principal.push([0,0,0,0,0]);
1084     tranche_total_vdsec_AA.push([0,0,0]);
1085     tranche_total_vdsec_A.push([0,0,0]);
1086     tranche_interest_earned.push([0,0,0,0,0]);
1087     tranche_SFI_earned.push([0,0,0,0,0]);
1088 
1089     dsec_token_addresses.push([       // Address for each dsec token
1090       saffron_v1_dsec_token_addresses[uint256(Tranche.S)],
1091       saffron_v1_dsec_token_addresses[uint256(Tranche.AA)],
1092       saffron_v1_dsec_token_addresses[uint256(Tranche.A)]
1093     ]);
1094 
1095     principal_token_addresses.push([  // Address for each principal token
1096       saffron_v1_principal_token_addresses[uint256(Tranche.S)],
1097       saffron_v1_principal_token_addresses[uint256(Tranche.AA)],
1098       saffron_v1_principal_token_addresses[uint256(Tranche.A)]
1099     ]);
1100 
1101     // Token info for looking up epoch and tranche of dsec tokens by token contract address
1102     saffron_v1_token_info[saffron_v1_dsec_token_addresses[uint256(Tranche.S)]] = SaffronV1TokenInfo({
1103       exists: true,
1104       epoch: epoch,
1105       tranche: Tranche.S,
1106       token_type: LPTokenType.dsec
1107     });
1108 
1109     saffron_v1_token_info[saffron_v1_dsec_token_addresses[uint256(Tranche.AA)]] = SaffronV1TokenInfo({
1110       exists: true,
1111       epoch: epoch,
1112       tranche: Tranche.AA,
1113       token_type: LPTokenType.dsec
1114     });
1115 
1116     saffron_v1_token_info[saffron_v1_dsec_token_addresses[uint256(Tranche.A)]] = SaffronV1TokenInfo({
1117       exists: true,
1118       epoch: epoch,
1119       tranche: Tranche.A,
1120       token_type: LPTokenType.dsec
1121     });
1122 
1123     // for looking up epoch and tranche of PRINCIPAL tokens by token contract address
1124     saffron_v1_token_info[saffron_v1_principal_token_addresses[uint256(Tranche.S)]] = SaffronV1TokenInfo({
1125       exists: true,
1126       epoch: epoch,
1127       tranche: Tranche.S,
1128       token_type: LPTokenType.principal
1129     });
1130 
1131     saffron_v1_token_info[saffron_v1_principal_token_addresses[uint256(Tranche.AA)]] = SaffronV1TokenInfo({
1132       exists: true,
1133       epoch: epoch,
1134       tranche: Tranche.AA,
1135       token_type: LPTokenType.principal
1136     });
1137 
1138     saffron_v1_token_info[saffron_v1_principal_token_addresses[uint256(Tranche.A)]] = SaffronV1TokenInfo({
1139       exists: true,
1140       epoch: epoch,
1141       tranche: Tranche.A,
1142       token_type: LPTokenType.principal
1143     });
1144   }
1145 
1146   event DsecGeneration(uint256 time_remaining, uint256 amount, uint256 dsec, address dsec_address, uint256 epoch, uint256 tranche, address user_address, address principal_token_addr);
1147   event AddLiquidity(uint256 new_pool_principal, uint256 new_epoch_principal, uint256 new_eternal_balance, uint256 new_tranche_principal, uint256 new_tranche_dsec);
1148   // LP user adds liquidity to the pool
1149   // Pre-requisite (front-end): have user approve transfer on front-end to base asset using our contract address
1150   function add_liquidity(uint256 amount, Tranche tranche) external override {
1151     require(!_shutdown, "pool shutdown");
1152     require(tranche == Tranche.S, "tranche S only"); // v0: can't add to any tranche other than the S tranche
1153     uint256 epoch = get_current_epoch();
1154 
1155     require(amount != 0, "can't add 0");
1156     //require(epoch_wound_down[epoch-1], "previous epoch must be wound down"); // v0: no epoch -1
1157     require(epoch == 0, "v0: must be epoch 0 only"); // v0: can't add liquidity after epoch 0
1158 
1159     // Calculate the dsec for this amount of DAI
1160     // Tranche S dsec owners own proportional vdsec awarded to the S tranche when base assets in S are moved to the A or AA tranches
1161     // Tranche S earns SFI rewards for A and AA based on vdsec as well
1162     uint256 dsec = amount.mul(get_seconds_until_epoch_end(epoch));
1163 
1164     pool_principal = pool_principal.add(amount);                 // Add DAI to principal totals
1165     epoch_principal[epoch] = epoch_principal[epoch].add(amount); // Add DAI total balance for epoch
1166     if (tranche == Tranche.S) eternal_unutilized_balances.S = eternal_unutilized_balances.S.add(amount); // Add to eternal balance of S tranche
1167 
1168     // Update state
1169     tranche_total_dsec[epoch][uint256(tranche)] = tranche_total_dsec[epoch][uint256(tranche)].add(dsec);
1170     tranche_total_principal[epoch][uint256(tranche)] = tranche_total_principal[epoch][uint256(tranche)].add(amount);
1171 
1172     // Transfer DAI from LP to pool
1173     IERC20(base_asset_address).safeTransferFrom(msg.sender, address(this), amount);
1174 
1175     // Mint Saffron V1 epoch 0 S dsec tokens and transfer them to sender
1176     SaffronLPBalanceToken(dsec_token_addresses[epoch][uint256(tranche)]).mint(msg.sender, dsec);
1177 
1178     // Mint Saffron V1 epoch 0 S principal tokens and transfer them to sender
1179     SaffronLPBalanceToken(principal_token_addresses[epoch][uint256(tranche)]).mint(msg.sender, amount);
1180 
1181     emit DsecGeneration(get_seconds_until_epoch_end(epoch), amount, dsec, dsec_token_addresses[epoch][uint256(tranche)], epoch, uint256(tranche), msg.sender, principal_token_addresses[epoch][uint256(tranche)]);
1182     emit AddLiquidity(pool_principal, epoch_principal[epoch], eternal_unutilized_balances.S, tranche_total_principal[epoch][uint256(tranche)], tranche_total_dsec[epoch][uint256(tranche)]);
1183   }
1184 
1185 
1186   event WindDownEpochSFI(uint256 previous_epoch, uint256 S_SFI, uint256 AA_SFI, uint256 A_SFI);
1187   event WindDownEpochState(uint256 epoch, uint256 tranche_S_interest, uint256 tranche_AA_interest, uint256 tranche_A_interest, uint256 tranche_SFI_earnings_S, uint256 tranche_SFI_earnings_AA, uint256 tranche_SFI_earnings_A);
1188   event WindDownEpochInterest(uint256 adapter_holdings, uint256 adapter_total_principal, uint256 epoch_interest_rate, uint256 epoch_principal, uint256 epoch_interest, uint256 tranche_A_interest, uint256 tranche_AA_interest);
1189   struct WindDownVars {
1190     uint256 previous_epoch;
1191     uint256 SFI_rewards;
1192     uint256 epoch_interest;
1193     uint256 tranche_AA_interest;
1194     uint256 tranche_A_interest;
1195     uint256 tranche_S_share_of_AA_interest;
1196     uint256 tranche_S_share_of_A_interest;
1197     uint256 tranche_S_interest;
1198   }
1199   function wind_down_epoch(uint256 epoch) public {
1200     require(!epoch_wound_down[epoch], "epoch already wound down");
1201     uint256 current_epoch = get_current_epoch();
1202     require(epoch < current_epoch, "cannot wind down future epoch");
1203     WindDownVars memory wind_down = WindDownVars({
1204       previous_epoch: 0,
1205       SFI_rewards: 0,
1206       epoch_interest: 0,
1207       tranche_AA_interest: 0,
1208       tranche_A_interest: 0,
1209       tranche_S_share_of_AA_interest: 0,
1210       tranche_S_share_of_A_interest: 0,
1211       tranche_S_interest: 0
1212     });
1213     wind_down.previous_epoch = current_epoch - 1;
1214     require(block.timestamp >= get_epoch_end(wind_down.previous_epoch), "can't call before epoch ended");
1215 
1216     // Calculate SFI earnings per tranche
1217     wind_down.SFI_rewards = (30000 * 1 ether) >> epoch; // v1: add plateau for ongoing generation
1218     TrancheUint256 memory tranche_SFI_earnings = TrancheUint256({
1219       S:   TRANCHE_SFI_MULTIPLIER.S  * wind_down.SFI_rewards / 100,
1220       AA:  TRANCHE_SFI_MULTIPLIER.AA * wind_down.SFI_rewards / 100,
1221       A:   TRANCHE_SFI_MULTIPLIER.A  * wind_down.SFI_rewards / 100,
1222       SAA: 0, SA: 0
1223     });
1224 
1225     emit WindDownEpochSFI(wind_down.previous_epoch, tranche_SFI_earnings.S, tranche_SFI_earnings.AA, tranche_SFI_earnings.A);
1226     // Calculate interest earnings per tranche
1227     // Wind down will calculate interest and SFI earned by each tranche for the epoch which has ended
1228     // Liquidity cannot be removed until wind_down_epoch is called and epoch_wound_down[epoch] is set to true
1229 
1230     // Calculate pool_interest
1231     // v0: we only have one adapter
1232     ISaffronAdapter adapter = ISaffronAdapter(best_adapter_address);
1233     wind_down.epoch_interest = adapter.get_interest(adapter_total_principal);
1234     pool_interest = pool_interest.add(wind_down.epoch_interest);
1235 
1236     // Calculate tranche share of interest
1237     wind_down.tranche_A_interest  = wind_down.epoch_interest.mul(tranche_A_multiplier.mul(1 ether)/(tranche_A_multiplier + 1)) / 1 ether;
1238     wind_down.tranche_AA_interest = wind_down.epoch_interest - wind_down.tranche_A_interest;
1239     emit WindDownEpochInterest(adapter.get_holdings(), adapter_total_principal, (((wind_down.epoch_interest.add(epoch_principal[epoch])).mul(1 ether)).div(epoch_principal[epoch])), epoch_principal[epoch], wind_down.epoch_interest, wind_down.tranche_A_interest, wind_down.tranche_AA_interest);
1240 
1241     // Calculate how much of AA and A interest is owned by the S tranche and subtract from AA and A
1242     wind_down.tranche_S_share_of_AA_interest = (tranche_total_vdsec_AA[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.AA)])).mul(wind_down.tranche_AA_interest);
1243     wind_down.tranche_S_share_of_A_interest  = (tranche_total_vdsec_A[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.A)])).mul(wind_down.tranche_A_interest);
1244     wind_down.tranche_S_interest  = wind_down.tranche_S_share_of_AA_interest.add(wind_down.tranche_S_share_of_A_interest);
1245     wind_down.tranche_AA_interest = wind_down.tranche_AA_interest.sub(wind_down.tranche_S_share_of_AA_interest);
1246     wind_down.tranche_A_interest  = wind_down.tranche_A_interest.sub(wind_down.tranche_S_share_of_A_interest);
1247 
1248     // Update state for remove_liquidity
1249     tranche_interest_earned[epoch][uint256(Tranche.S)]  = wind_down.tranche_S_interest;  // v0: Tranche S owns all interest
1250     tranche_interest_earned[epoch][uint256(Tranche.AA)] = wind_down.tranche_AA_interest; // v0: Should always be 0
1251     tranche_interest_earned[epoch][uint256(Tranche.A)]  = wind_down.tranche_A_interest;  // v0: Should always be 0
1252 
1253     emit WindDownEpochState(epoch, wind_down.tranche_S_interest, wind_down.tranche_AA_interest, wind_down.tranche_A_interest, uint256(tranche_SFI_earnings.S), uint256(tranche_SFI_earnings.AA), uint256(tranche_SFI_earnings.A));
1254 
1255     tranche_SFI_earned[epoch][uint256(Tranche.S)]  = tranche_SFI_earnings.S.add(tranche_total_vdsec_AA[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.AA)]).mul(tranche_SFI_earnings.AA)).add(tranche_total_vdsec_A[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.A)]).mul(tranche_SFI_earnings.A));
1256     tranche_SFI_earned[epoch][uint256(Tranche.AA)] = tranche_SFI_earnings.AA.sub(tranche_total_vdsec_AA[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.AA)]).mul(tranche_SFI_earnings.AA));
1257     tranche_SFI_earned[epoch][uint256(Tranche.A)]  = tranche_SFI_earnings.A.sub(tranche_total_vdsec_A[epoch][uint256(Tranche.S)].div(tranche_total_dsec[epoch][uint256(Tranche.A)]).mul(tranche_SFI_earnings.A));
1258 
1259     // Distribute SFI earnings to S tranche based on S tranche % share of dsec via vdsec
1260     emit WindDownEpochState(epoch, wind_down.tranche_S_interest, wind_down.tranche_AA_interest, wind_down.tranche_A_interest, uint256(tranche_SFI_earned[epoch][uint256(Tranche.S)]), uint256(tranche_SFI_earned[epoch][uint256(Tranche.AA)]), uint256(tranche_SFI_earned[epoch][uint256(Tranche.A)]));
1261     epoch_wound_down[epoch] = true;
1262 
1263     // Mint SFI
1264     SFI(SFI_address).mint_SFI(address(this), wind_down.SFI_rewards);
1265     delete wind_down;
1266 
1267     uint256 team_sfi = (10000 * 1 ether) >> epoch; // v1: add plateau for ongoing generation
1268     SFI(SFI_address).mint_SFI(team_address, team_sfi);
1269   }
1270 
1271   event RemoveLiquidityDsec(uint256 dsec_percent, uint256 interest_owned, uint256 SFI_owned);
1272   event RemoveLiquidityPrincipal(uint256 principal);
1273   function remove_liquidity(address v1_dsec_token_address, uint256 dsec_amount, address v1_principal_token_address, uint256 principal_amount) external override {
1274     require(dsec_amount > 0 || principal_amount > 0, "can't remove 0");
1275     ISaffronAdapter best_adapter = ISaffronAdapter(best_adapter_address);
1276     uint256 interest_owned;
1277     uint256 SFI_owned;
1278     uint256 dsec_percent;
1279 
1280     // Update state for removal via dsec token
1281     if (v1_dsec_token_address != address(0x0) && dsec_amount > 0) {
1282       // Get info about the v1 dsec token from its address and check that it exists
1283       SaffronV1TokenInfo memory sv1_info = saffron_v1_token_info[v1_dsec_token_address];
1284       require(sv1_info.exists, "balance token lookup failed");
1285       require(sv1_info.tranche == Tranche.S, "v0: tranche must be S");
1286 
1287       // Token epoch must be a past epoch
1288       uint256 token_epoch = sv1_info.epoch;
1289       require(sv1_info.token_type == LPTokenType.dsec, "bad dsec address");
1290       require(token_epoch == 0, "v0: bal token epoch must be 1");
1291       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1292 
1293       // Dsec gives user claim over a tranche's earned SFI and interest
1294       dsec_percent = dsec_amount.mul(1 ether).div(tranche_total_dsec[token_epoch][uint256(Tranche.S)]);
1295       interest_owned = tranche_interest_earned[token_epoch][uint256(Tranche.S)].mul(dsec_percent) / 1 ether;
1296       SFI_owned = tranche_SFI_earned[token_epoch][uint256(Tranche.S)].mul(dsec_percent) / 1 ether;
1297 
1298       tranche_interest_earned[token_epoch][uint256(Tranche.S)] = tranche_interest_earned[token_epoch][uint256(Tranche.S)].sub(interest_owned);
1299       tranche_SFI_earned[token_epoch][uint256(Tranche.S)] = tranche_SFI_earned[token_epoch][uint256(Tranche.S)].sub(SFI_owned);
1300       tranche_total_dsec[token_epoch][uint256(Tranche.S)] = tranche_total_dsec[token_epoch][uint256(Tranche.S)].sub(dsec_amount);
1301       pool_interest = pool_interest.sub(interest_owned);
1302     }
1303 
1304     // Update state for removal via principal token
1305     if (v1_principal_token_address != address(0x0) && principal_amount > 0) {
1306       // Get info about the v1 dsec token from its address and check that it exists
1307       SaffronV1TokenInfo memory sv1_info = saffron_v1_token_info[v1_principal_token_address];
1308       require(sv1_info.exists, "balance token info lookup failed");
1309       require(sv1_info.tranche == Tranche.S, "v0: tranche must be S");
1310 
1311       // Token epoch must be a past epoch
1312       uint256 token_epoch = sv1_info.epoch;
1313       require(sv1_info.token_type == LPTokenType.principal, "bad balance token address");
1314       require(token_epoch == 0, "v0: bal token epoch must be 1");
1315       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1316 
1317       tranche_total_principal[token_epoch][uint256(Tranche.S)] = tranche_total_principal[token_epoch][uint256(Tranche.S)].sub(principal_amount);
1318       epoch_principal[token_epoch] = epoch_principal[token_epoch].sub(principal_amount);
1319       pool_principal = pool_principal.sub(principal_amount);
1320       adapter_total_principal = adapter_total_principal.sub(principal_amount);
1321     }
1322 
1323     // Transfer
1324     if (v1_dsec_token_address != address(0x0) && dsec_amount > 0) {
1325       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(v1_dsec_token_address);
1326       require(sbt.balanceOf(msg.sender) >= dsec_amount, "insufficient dsec balance");
1327       sbt.burn(msg.sender, dsec_amount);
1328       best_adapter.return_capital(interest_owned, msg.sender);
1329       IERC20(SFI_address).safeTransfer(msg.sender, SFI_owned);
1330       emit RemoveLiquidityDsec(dsec_percent, interest_owned, SFI_owned);
1331     }
1332     if (v1_principal_token_address != address(0x0) && principal_amount > 0) {
1333       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(v1_principal_token_address);
1334       require(sbt.balanceOf(msg.sender) >= principal_amount, "insufficient principal balance");
1335       sbt.burn(msg.sender, principal_amount);
1336       best_adapter.return_capital(principal_amount, msg.sender);
1337       emit RemoveLiquidityPrincipal(principal_amount);
1338     }
1339 
1340     require((v1_dsec_token_address != address(0x0) && dsec_amount > 0) || (v1_principal_token_address != address(0x0) && principal_amount > 0), "no action performed");
1341   }
1342 
1343   // Strategy contract calls this to deploy capital to platforms
1344   event StrategicDeploy(address adapter_address, uint256 amount, uint256 epoch);
1345   function hourly_strategy(address adapter_address) external override {
1346     require(msg.sender == address(strategy), "must be strategy");
1347     require(!_shutdown, "pool shutdown");
1348     uint256 epoch = get_current_epoch();
1349     best_adapter_address = adapter_address;
1350     ISaffronAdapter best_adapter = ISaffronAdapter(adapter_address);
1351     uint256 amount = IERC20(base_asset_address).balanceOf(address(this));
1352 
1353     // Get amount to add from S tranche to add to A and AA
1354     uint256 new_A_amount = eternal_unutilized_balances.S / (tranche_A_multiplier+1);
1355     // new_AA_amount is roughly 10x new_A_amount
1356     uint256 new_AA_amount = eternal_unutilized_balances.S - new_A_amount;
1357 
1358     // Store new balances (S tranche is wiped out into AA and A tranches)
1359     eternal_unutilized_balances.S = 0;
1360     eternal_utilized_balances.AA = eternal_utilized_balances.AA.add(new_AA_amount);
1361     eternal_utilized_balances.A = eternal_utilized_balances.A.add(new_A_amount);
1362 
1363     // Record vdsec for tranche S and new dsec for tranche AA and A
1364     tranche_total_vdsec_AA[epoch][uint256(Tranche.S)] = tranche_total_vdsec_AA[epoch][uint256(Tranche.S)].add(get_seconds_until_epoch_end(epoch).mul(new_AA_amount)); // Total AA vdsec owned by tranche S
1365     tranche_total_vdsec_A[epoch][uint256(Tranche.S)]  = tranche_total_vdsec_A[epoch][uint256(Tranche.S)].add(get_seconds_until_epoch_end(epoch).mul(new_A_amount));   // Total A vdsec owned by tranche S
1366 
1367     tranche_total_dsec[epoch][uint256(Tranche.AA)] = tranche_total_dsec[epoch][uint256(Tranche.AA)].add(get_seconds_until_epoch_end(epoch).mul(new_AA_amount)); // Total dsec for tranche AA
1368     tranche_total_dsec[epoch][uint256(Tranche.A)]  = tranche_total_dsec[epoch][uint256(Tranche.A)].add(get_seconds_until_epoch_end(epoch).mul(new_A_amount));   // Total dsec for tranche A
1369 
1370     tranche_total_principal[epoch][uint256(Tranche.AA)] = tranche_total_principal[epoch][uint256(Tranche.AA)].add(new_AA_amount); // Add total principal for AA
1371     tranche_total_principal[epoch][uint256(Tranche.A)]  = tranche_total_principal[epoch][uint256(Tranche.A)].add(new_A_amount);   // Add total principal for A
1372 
1373     emit StrategicDeploy(adapter_address, amount, epoch);
1374 
1375     // Add principal to adapter total
1376     adapter_total_principal = adapter_total_principal.add(amount);
1377     // Move base assets to adapter and deploy
1378     IERC20(base_asset_address).safeTransfer(adapter_address, amount);
1379     best_adapter.deploy_capital(amount);
1380   }
1381 
1382   function shutdown() external override {
1383     require(msg.sender == address(strategy), "must be strategy");
1384     require(block.timestamp > get_epoch_end(0) - 1 days, "trying to shutdown too early");
1385     _shutdown = true;
1386   }
1387 
1388   /*** GOVERNANCE ***/
1389   function set_governance(address to) external override {
1390     require(msg.sender == governance, "must be governance");
1391     governance = to;
1392   }
1393 
1394   /*** TIME UTILITY FUNCTIONS ***/
1395   function get_epoch_end(uint256 epoch) public view returns (uint256) {
1396     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration));
1397   }
1398 
1399   function get_current_epoch() public view returns (uint256) {
1400     require(block.timestamp > epoch_cycle.start_date, "before epoch 0");
1401     return (block.timestamp - epoch_cycle.start_date) / epoch_cycle.duration;
1402   }
1403 
1404   function get_seconds_until_epoch_end(uint256 epoch) public view returns (uint256) {
1405     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration)).sub(block.timestamp);
1406   }
1407 
1408   /*** GETTERS ***/
1409   function get_epoch_cycle_params() external view override returns (uint256, uint256) {
1410     return (epoch_cycle.start_date, epoch_cycle.duration);
1411   }
1412 
1413   function get_base_asset_address() external override view returns (address) {
1414     return base_asset_address;
1415   }
1416 
1417   function get_governance() external override view returns (address) {
1418     return governance;
1419   }
1420 
1421   function get_strategy_address() external override view returns (address) {
1422     return address(strategy);
1423   }
1424 
1425   //***** ADAPTER FUNCTIONS *****//
1426   // Delete adapters (v0: for v0 wind-down)
1427   function delete_adapters() external override {
1428     require(msg.sender == governance, "must be governance");
1429     delete adapters;
1430   }
1431 
1432   event ErcSwept(address who, address to, address token, uint256 amount);
1433   function erc_sweep(address _token, address _to) public {
1434     require(msg.sender == governance, "must be governance");
1435     require(_token != base_asset_address, "cannot sweep pool assets");
1436 
1437     IERC20 tkn = IERC20(_token);
1438     uint256 tBal = tkn.balanceOf(address(this));
1439     tkn.safeTransfer(_to, tBal);
1440 
1441     emit ErcSwept(msg.sender, _to, _token, tBal);
1442   }
1443 }
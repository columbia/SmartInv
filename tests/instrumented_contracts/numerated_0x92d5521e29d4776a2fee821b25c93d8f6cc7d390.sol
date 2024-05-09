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
24 // File: contracts/interfaces/ISaffronPool.sol
25 
26 
27 pragma solidity ^0.7.1;
28 
29 interface ISaffronPool is ISaffronBase {
30   function add_liquidity(uint256 amount, Tranche tranche) external;
31   function remove_liquidity(address v1_dsec_token_address, uint256 dsec_amount, address v1_principal_token_address, uint256 principal_amount) external;
32   function get_base_asset_address() external view returns(address);
33   function hourly_strategy(address adapter_address) external;
34   function wind_down_epoch(uint256 epoch, uint256 amount_sfi) external;
35   function set_governance(address to) external;
36   function get_epoch_cycle_params() external view returns (uint256, uint256);
37   function shutdown() external;
38 }
39 
40 // File: contracts/lib/SafeMath.sol
41 
42 
43 pragma solidity ^0.7.1;
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      *
67      * - Addition cannot overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b > 0, errorMessage);
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         return mod(a, b, "SafeMath: modulo by zero");
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts with custom message when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b != 0, errorMessage);
197         return a % b;
198     }
199 }
200 
201 // File: contracts/lib/IERC20.sol
202 
203 
204 pragma solidity ^0.7.1;
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `recipient`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `sender` to `recipient` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Emitted when `value` tokens are moved from one account (`from`) to
267      * another (`to`).
268      *
269      * Note that `value` may be zero.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     /**
274      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
275      * a call to {approve}. `value` is the new allowance.
276      */
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 // File: contracts/lib/Context.sol
281 
282 
283 pragma solidity ^0.7.1;
284 
285 /*
286  * @dev Provides information about the current execution context, including the
287  * sender of the transaction and its data. While these are generally available
288  * via msg.sender and msg.data, they should not be accessed in such a direct
289  * manner, since when dealing with GSN meta-transactions the account sending and
290  * paying for execution may not be the actual sender (as far as an application
291  * is concerned).
292  *
293  * This contract is only required for intermediate, library-like contracts.
294  */
295 abstract contract Context {
296     function _msgSender() internal view virtual returns (address payable) {
297         return msg.sender;
298     }
299 
300     function _msgData() internal view virtual returns (bytes memory) {
301         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
302         return msg.data;
303     }
304 }
305 
306 // File: contracts/lib/Address.sol
307 
308 
309 pragma solidity ^0.7.1;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         // solhint-disable-next-line no-inline-assembly
339         assembly { size := extcodesize(account) }
340         return size > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
363         (bool success, ) = recipient.call{ value: amount }("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain`call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         require(isContract(target), "Address: call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.call{ value: value }(data);
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         // solhint-disable-next-line avoid-low-level-calls
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return _verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.3._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.3._
468      */
469     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
470         require(isContract(target), "Address: delegate call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
478         if (success) {
479             return returndata;
480         } else {
481             // Look for revert reason and bubble it up if present
482             if (returndata.length > 0) {
483                 // The easiest way to bubble the revert reason is using memory via assembly
484 
485                 // solhint-disable-next-line no-inline-assembly
486                 assembly {
487                     let returndata_size := mload(returndata)
488                     revert(add(32, returndata), returndata_size)
489                 }
490             } else {
491                 revert(errorMessage);
492             }
493         }
494     }
495 }
496 
497 // File: contracts/lib/ERC20.sol
498 
499 
500 pragma solidity ^0.7.1;
501 
502 
503 
504 
505 
506 /**
507  * @dev Implementation of the {IERC20} interface.
508  *
509  * This implementation is agnostic to the way tokens are created. This means
510  * that a supply mechanism has to be added in a derived contract using {_mint}.
511  * For a generic mechanism see {ERC20PresetMinterPauser}.
512  *
513  * TIP: For a detailed writeup see our guide
514  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
515  * to implement supply mechanisms].
516  *
517  * We have followed general OpenZeppelin guidelines: functions revert instead
518  * of returning `false` on failure. This behavior is nonetheless conventional
519  * and does not conflict with the expectations of ERC20 applications.
520  *
521  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
522  * This allows applications to reconstruct the allowance for all accounts just
523  * by listening to said events. Other implementations of the EIP may not emit
524  * these events, as it isn't required by the specification.
525  *
526  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
527  * functions have been added to mitigate the well-known issues around setting
528  * allowances. See {IERC20-approve}.
529  */
530 contract ERC20 is Context, IERC20 {
531     using SafeMath for uint256;
532     using Address for address;
533 
534     mapping (address => uint256) private _balances;
535 
536     mapping (address => mapping (address => uint256)) private _allowances;
537 
538     uint256 private _totalSupply;
539 
540     string private _name;
541     string private _symbol;
542     uint8 private _decimals;
543 
544     /**
545      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
546      * a default value of 18.
547      *
548      * To select a different value for {decimals}, use {_setupDecimals}.
549      *
550      * All three of these values are immutable: they can only be set once during
551      * construction.
552      */
553     constructor (string memory name_, string memory symbol_) {
554         _name = name_;
555         _symbol = symbol_;
556         _decimals = 18;
557     }
558 
559     /**
560      * @dev Returns the name of the token.
561      */
562     function name() public view returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev Returns the symbol of the token, usually a shorter version of the
568      * name.
569      */
570     function symbol() public view returns (string memory) {
571         return _symbol;
572     }
573 
574     /**
575      * @dev Returns the number of decimals used to get its user representation.
576      * For example, if `decimals` equals `2`, a balance of `505` tokens should
577      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
578      *
579      * Tokens usually opt for a value of 18, imitating the relationship between
580      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
581      * called.
582      *
583      * NOTE: This information is only used for _display_ purposes: it in
584      * no way affects any of the arithmetic of the contract, including
585      * {IERC20-balanceOf} and {IERC20-transfer}.
586      */
587     function decimals() public view returns (uint8) {
588         return _decimals;
589     }
590 
591     /**
592      * @dev See {IERC20-totalSupply}.
593      */
594     function totalSupply() public view override returns (uint256) {
595         return _totalSupply;
596     }
597 
598     /**
599      * @dev See {IERC20-balanceOf}.
600      */
601     function balanceOf(address account) public view override returns (uint256) {
602         return _balances[account];
603     }
604 
605     /**
606      * @dev See {IERC20-transfer}.
607      *
608      * Requirements:
609      *
610      * - `recipient` cannot be the zero address.
611      * - the caller must have a balance of at least `amount`.
612      */
613     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
614         _transfer(_msgSender(), recipient, amount);
615         return true;
616     }
617 
618     /**
619      * @dev See {IERC20-allowance}.
620      */
621     function allowance(address owner, address spender) public view virtual override returns (uint256) {
622         return _allowances[owner][spender];
623     }
624 
625     /**
626      * @dev See {IERC20-approve}.
627      *
628      * Requirements:
629      *
630      * - `spender` cannot be the zero address.
631      */
632     function approve(address spender, uint256 amount) public virtual override returns (bool) {
633         _approve(_msgSender(), spender, amount);
634         return true;
635     }
636 
637     /**
638      * @dev See {IERC20-transferFrom}.
639      *
640      * Emits an {Approval} event indicating the updated allowance. This is not
641      * required by the EIP. See the note at the beginning of {ERC20};
642      *
643      * Requirements:
644      * - `sender` and `recipient` cannot be the zero address.
645      * - `sender` must have a balance of at least `amount`.
646      * - the caller must have allowance for ``sender``'s tokens of at least
647      * `amount`.
648      */
649     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
650         _transfer(sender, recipient, amount);
651         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
652         return true;
653     }
654 
655     /**
656      * @dev Atomically increases the allowance granted to `spender` by the caller.
657      *
658      * This is an alternative to {approve} that can be used as a mitigation for
659      * problems described in {IERC20-approve}.
660      *
661      * Emits an {Approval} event indicating the updated allowance.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      */
667     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
668         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
669         return true;
670     }
671 
672     /**
673      * @dev Atomically decreases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      * - `spender` must have allowance for the caller of at least
684      * `subtractedValue`.
685      */
686     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
687         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
688         return true;
689     }
690 
691     /**
692      * @dev Moves tokens `amount` from `sender` to `recipient`.
693      *
694      * This is internal function is equivalent to {transfer}, and can be used to
695      * e.g. implement automatic token fees, slashing mechanisms, etc.
696      *
697      * Emits a {Transfer} event.
698      *
699      * Requirements:
700      *
701      * - `sender` cannot be the zero address.
702      * - `recipient` cannot be the zero address.
703      * - `sender` must have a balance of at least `amount`.
704      */
705     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
706         require(sender != address(0), "ERC20: transfer from the zero address");
707         require(recipient != address(0), "ERC20: transfer to the zero address");
708 
709         _beforeTokenTransfer(sender, recipient, amount);
710 
711         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
712         _balances[recipient] = _balances[recipient].add(amount);
713         emit Transfer(sender, recipient, amount);
714     }
715 
716     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
717      * the total supply.
718      *
719      * Emits a {Transfer} event with `from` set to the zero address.
720      *
721      * Requirements
722      *
723      * - `to` cannot be the zero address.
724      */
725     function _mint(address account, uint256 amount) internal virtual {
726         require(account != address(0), "ERC20: mint to the zero address");
727 
728         _beforeTokenTransfer(address(0), account, amount);
729 
730         _totalSupply = _totalSupply.add(amount);
731         _balances[account] = _balances[account].add(amount);
732         emit Transfer(address(0), account, amount);
733     }
734 
735     /**
736      * @dev Destroys `amount` tokens from `account`, reducing the
737      * total supply.
738      *
739      * Emits a {Transfer} event with `to` set to the zero address.
740      *
741      * Requirements
742      *
743      * - `account` cannot be the zero address.
744      * - `account` must have at least `amount` tokens.
745      */
746     function _burn(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: burn from the zero address");
748 
749         _beforeTokenTransfer(account, address(0), amount);
750 
751         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
752         _totalSupply = _totalSupply.sub(amount);
753         emit Transfer(account, address(0), amount);
754     }
755 
756     /**
757      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
758      *
759      * This is internal function is equivalent to `approve`, and can be used to
760      * e.g. set automatic allowances for certain subsystems, etc.
761      *
762      * Emits an {Approval} event.
763      *
764      * Requirements:
765      *
766      * - `owner` cannot be the zero address.
767      * - `spender` cannot be the zero address.
768      */
769     function _approve(address owner, address spender, uint256 amount) internal virtual {
770         require(owner != address(0), "ERC20: approve from the zero address");
771         require(spender != address(0), "ERC20: approve to the zero address");
772 
773         _allowances[owner][spender] = amount;
774         emit Approval(owner, spender, amount);
775     }
776 
777     /**
778      * @dev Sets {decimals} to a value other than the default one of 18.
779      *
780      * WARNING: This function should only be called from the constructor. Most
781      * applications that interact with token contracts will not expect
782      * {decimals} to ever change, and may work incorrectly if it does.
783      */
784     function _setupDecimals(uint8 decimals_) internal {
785         _decimals = decimals_;
786     }
787 
788     /**
789      * @dev Hook that is called before any transfer of tokens. This includes
790      * minting and burning.
791      *
792      * Calling conditions:
793      *
794      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
795      * will be to transferred to `to`.
796      * - when `from` is zero, `amount` tokens will be minted for `to`.
797      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
798      * - `from` and `to` are never both zero.
799      *
800      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
801      */
802     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
803 }
804 
805 // File: contracts/lib/SafeERC20.sol
806 
807 
808 pragma solidity ^0.7.1;
809 
810 
811 
812 
813 /**
814  * @title SafeERC20
815  * @dev Wrappers around ERC20 operations that throw on failure (when the token
816  * contract returns false). Tokens that return no value (and instead revert or
817  * throw on failure) are also supported, non-reverting calls are assumed to be
818  * successful.
819  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
820  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
821  */
822 library SafeERC20 {
823   using SafeMath for uint256;
824   using Address for address;
825 
826   function safeTransfer(IERC20 token, address to, uint256 value) internal {
827     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
828   }
829 
830   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
831     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
832   }
833 
834   /**
835    * @dev Deprecated. This function has issues similar to the ones found in
836    * {IERC20-approve}, and its usage is discouraged.
837    *
838    * Whenever possible, use {safeIncreaseAllowance} and
839    * {safeDecreaseAllowance} instead.
840    */
841   function safeApprove(IERC20 token, address spender, uint256 value) internal {
842     // safeApprove should only be called when setting an initial allowance,
843     // or when resetting it to zero. To increase and decrease it, use
844     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
845     // solhint-disable-next-line max-line-length
846     require((value == 0) || (token.allowance(address(this), spender) == 0),
847       "SafeERC20: approve from non-zero to non-zero allowance"
848     );
849     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
850   }
851 
852   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
853     uint256 newAllowance = token.allowance(address(this), spender).add(value);
854     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
855   }
856 
857   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
858     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
859     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
860   }
861 
862   /**
863    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
864    * on the return value: the return value is optional (but if data is returned, it must not be false).
865    * @param token The token targeted by the call.
866    * @param data The call data (encoded using abi.encode or one of its variants).
867    */
868   function _callOptionalReturn(IERC20 token, bytes memory data) private {
869     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
870     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
871     // the target address contains contract code and also asserts for success in the low-level call.
872 
873     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
874     if (returndata.length > 0) { // Return data is optional
875       // solhint-disable-next-line max-line-length
876       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
877     }
878   }
879 }
880 
881 // File: contracts/SFI.sol
882 
883 
884 pragma solidity ^0.7.1;
885 
886 
887 
888 contract SFI is ERC20 {
889   using SafeERC20 for IERC20;
890 
891   address public governance;
892   address public SFI_minter;
893   uint256 public MAX_TOKENS = 100000 ether;
894 
895   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
896     // Initial governance is Saffron Deployer
897     governance = msg.sender;
898   }
899 
900   function mint_SFI(address to, uint256 amount) public {
901     require(msg.sender == SFI_minter, "must be SFI_minter");
902     require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
903     _mint(to, amount);
904   }
905 
906   function set_minter(address to) external {
907     require(msg.sender == governance, "must be governance");
908     SFI_minter = to;
909   }
910 
911   function set_governance(address to) external {
912     require(msg.sender == governance, "must be governance");
913     governance = to;
914   }
915 
916   event ErcSwept(address who, address to, address token, uint256 amount);
917   function erc_sweep(address _token, address _to) public {
918     require(msg.sender == governance, "must be governance");
919 
920     IERC20 tkn = IERC20(_token);
921     uint256 tBal = tkn.balanceOf(address(this));
922     tkn.safeTransfer(_to, tBal);
923 
924     emit ErcSwept(msg.sender, _to, _token, tBal);
925   }
926 }
927 
928 // File: contracts/SaffronLPBalanceToken.sol
929 
930 
931 pragma solidity ^0.7.1;
932 
933 
934 contract SaffronLPBalanceToken is ERC20 {
935   address public pool_address;
936 
937   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
938     // Set pool_address to saffron pool that created token
939     pool_address = msg.sender;
940   }
941 
942   // Allow creating new tranche tokens
943   function mint(address to, uint256 amount) public {
944     require(msg.sender == pool_address, "must be pool");
945     _mint(to, amount);
946   }
947 
948   function burn(address account, uint256 amount) public {
949     require(msg.sender == pool_address, "must be pool");
950     _burn(account, amount);
951   }
952 
953   function set_governance(address to) external {
954     require(msg.sender == pool_address, "must be pool");
955     pool_address = to;
956   }
957 }
958 
959 // File: contracts/SaffronERC20StakingPool.sol
960 
961 
962 pragma solidity ^0.7.1;
963 
964 
965 
966 
967 
968 
969 
970 
971 contract SaffronERC20StakingPool is ISaffronPool {
972   using SafeMath for uint256;
973   using SafeERC20 for IERC20;
974 
975   address public governance;           // Governance (v3: add off-chain/on-chain governance)
976   address public base_asset_address;   // Base asset managed by the pool (DAI, USDT, YFI...)
977   address public SFI_address;          // SFI token
978   uint256 public pool_principal;       // Current principal balance (added minus removed)
979 
980   bool public _shutdown = false;       // v0, v1: shutdown the pool after the final capital deploy to prevent burning funds
981 
982   /**** STRATEGY ****/
983   address public strategy;
984 
985   /**** EPOCHS ****/
986   epoch_params public epoch_cycle = epoch_params({
987     start_date: 1604239200,   // 11/01/2020 @ 2:00pm (UTC)
988     duration:   14 days       // 1210000 seconds
989   });
990 
991   mapping(uint256=>bool) public epoch_wound_down; // True if epoch has been wound down already (governance)
992 
993   /**** EPOCH INDEXED STORAGE ****/
994   uint256[] public epoch_principal;           // Total principal owned by the pool (all tranches)
995   uint256[] public total_dsec;                // Total dsec (tokens + vdsec)
996   uint256[] public SFI_earned;                // Total SFI earned (minted at wind_down_epoch)
997   address[] public dsec_token_addresses;      // Address for each dsec token
998   address[] public principal_token_addresses; // Address for each principal token
999 
1000   /**** SAFFRON LP TOKENS ****/
1001   // If we just have a token address then we can look up epoch and tranche balance tokens using a mapping(address=>SaffronV1dsecInfo)
1002   // LP tokens are dsec (redeemable for interest+SFI) and principal (redeemable for base asset) tokens
1003   struct SaffronLPTokenInfo {
1004     bool        exists;
1005     uint256     epoch;
1006     LPTokenType token_type;
1007   }
1008 
1009   mapping(address=>SaffronLPTokenInfo) public saffron_LP_token_info;
1010 
1011   constructor(address _strategy, address _base_asset, address _SFI_address, bool epoch_cycle_reset) {
1012     governance = msg.sender;
1013     base_asset_address = _base_asset;
1014     SFI_address = _SFI_address;
1015     strategy = _strategy;
1016     epoch_cycle.duration = (epoch_cycle_reset ? 20 minutes : 14 days); // Make testing previous epochs easier
1017     epoch_cycle.start_date = (epoch_cycle_reset ? (block.timestamp) - (2 * epoch_cycle.duration) : 1604239200); // Make testing previous epochs easier
1018   }
1019 
1020   function new_epoch(uint256 epoch, address saffron_LP_dsec_token_address, address saffron_LP_principal_token_address) public {
1021     require(epoch_principal.length == epoch, "improper new epoch");
1022     require(msg.sender == governance, "must be governance");
1023 
1024     epoch_principal.push(0);
1025     total_dsec.push(0);
1026     SFI_earned.push(0);
1027 
1028     dsec_token_addresses.push(saffron_LP_dsec_token_address);
1029     principal_token_addresses.push(saffron_LP_principal_token_address);
1030 
1031     // Token info for looking up epoch and tranche of dsec tokens by token contract address
1032     saffron_LP_token_info[saffron_LP_dsec_token_address] = SaffronLPTokenInfo({
1033       exists: true,
1034       epoch: epoch,
1035       token_type: LPTokenType.dsec
1036     });
1037 
1038     // Token info for looking up epoch and tranche of PRINCIPAL tokens by token contract address
1039     saffron_LP_token_info[saffron_LP_principal_token_address] = SaffronLPTokenInfo({
1040       exists: true,
1041       epoch: epoch,
1042       token_type: LPTokenType.principal
1043     });
1044   }
1045 
1046   event DsecGeneration(uint256 time_remaining, uint256 amount, uint256 dsec, address dsec_address, uint256 epoch, uint256 tranche, address user_address, address principal_token_addr);
1047   event AddLiquidity(uint256 new_pool_principal, uint256 new_epoch_principal, uint256 new_total_dsec);
1048   // LP user adds liquidity to the pool
1049   // Pre-requisite (front-end): have user approve transfer on front-end to base asset using our contract address
1050   function add_liquidity(uint256 amount, Tranche tranche) external override {
1051     require(!_shutdown, "pool shutdown");
1052     require(tranche == Tranche.S, "ERC20 pool has no tranches");
1053     uint256 epoch = get_current_epoch();
1054     require(amount != 0, "can't add 0");
1055     require(epoch == 2, "v1.2: must be epoch 2 only");
1056 
1057     // Calculate the dsec for deposited base_asset tokens
1058     uint256 dsec = amount.mul(get_seconds_until_epoch_end(epoch));
1059 
1060     // Update pool principal eternal and epoch state
1061     pool_principal = pool_principal.add(amount);                 // Add base_asset token amount to pool principal total 
1062     epoch_principal[epoch] = epoch_principal[epoch].add(amount); // Add base_asset token amount to principal epoch total
1063 
1064     // Update dsec and principal balance state
1065     total_dsec[epoch] = total_dsec[epoch].add(dsec);
1066 
1067     // Transfer base_asset tokens from LP to pool
1068     IERC20(base_asset_address).safeTransferFrom(msg.sender, address(this), amount);
1069 
1070     // Mint Saffron LP epoch 1 <base_asset_name> dsec tokens and transfer them to sender
1071     SaffronLPBalanceToken(dsec_token_addresses[epoch]).mint(msg.sender, dsec);
1072 
1073     // Mint Saffron LP epoch 1 <base_asset_name> principal tokens and transfer them to sender
1074     SaffronLPBalanceToken(principal_token_addresses[epoch]).mint(msg.sender, amount);
1075 
1076     emit DsecGeneration(get_seconds_until_epoch_end(epoch), amount, dsec, dsec_token_addresses[epoch], epoch, uint256(tranche), msg.sender, principal_token_addresses[epoch]);
1077     emit AddLiquidity(pool_principal, epoch_principal[epoch], total_dsec[epoch]);
1078   }
1079 
1080 
1081   event WindDownEpochState(uint256 previous_epoch, uint256 SFI_earned, uint256 epoch_dsec);
1082   function wind_down_epoch(uint256 epoch, uint256 amount_sfi) public override {
1083     require(msg.sender == address(strategy), "must be strategy");
1084     require(!epoch_wound_down[epoch], "epoch already wound down");
1085     uint256 current_epoch = get_current_epoch();
1086     require(epoch < current_epoch, "cannot wind down future epoch");
1087 
1088     uint256 previous_epoch = current_epoch - 1;
1089     require(block.timestamp >= get_epoch_end(previous_epoch), "can't call before epoch ended");
1090 
1091     SFI_earned[epoch] = amount_sfi;
1092 
1093     // Total dsec
1094     uint256 epoch_dsec = total_dsec[epoch];
1095     epoch_wound_down[epoch] = true;
1096     emit WindDownEpochState(previous_epoch, SFI_earned[epoch], epoch_dsec);
1097   }
1098 
1099   event RemoveLiquidityDsec(uint256 dsec_percent, uint256 SFI_owned);
1100   event RemoveLiquidityPrincipal(uint256 principal);
1101   function remove_liquidity(address dsec_token_address, uint256 dsec_amount, address principal_token_address, uint256 principal_amount) external override {
1102     require(dsec_amount > 0 || principal_amount > 0, "can't remove 0");
1103     uint256 SFI_owned;
1104     uint256 dsec_percent;
1105 
1106     // Update state for removal via dsec token
1107     if (dsec_token_address != address(0x0) && dsec_amount > 0) {
1108       // Get info about the v1 dsec token from its address and check that it exists
1109       SaffronLPTokenInfo memory token_info = saffron_LP_token_info[dsec_token_address];
1110       require(token_info.exists, "balance token lookup failed");
1111       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(dsec_token_address);
1112       require(sbt.balanceOf(msg.sender) >= dsec_amount, "insufficient dsec balance");
1113 
1114       // Token epoch must be a past epoch
1115       uint256 token_epoch = token_info.epoch;
1116       require(token_info.token_type == LPTokenType.dsec, "bad dsec address");
1117       require(token_epoch == 2, "v2: bal token epoch must be 2");
1118       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1119 
1120       // Dsec gives user claim over a tranche's earned SFI and interest
1121       dsec_percent = dsec_amount.mul(1 ether).div(total_dsec[token_epoch]);
1122       SFI_owned = SFI_earned[token_epoch].mul(dsec_percent) / 1 ether;
1123       SFI_earned[token_epoch] = SFI_earned[token_epoch].sub(SFI_owned);
1124       total_dsec[token_epoch] = total_dsec[token_epoch].sub(dsec_amount);
1125     }
1126 
1127     // Update state for removal via principal token
1128     if (principal_token_address != address(0x0) && principal_amount > 0) {
1129       // Get info about the v1 dsec token from its address and check that it exists
1130       SaffronLPTokenInfo memory token_info = saffron_LP_token_info[principal_token_address];
1131       require(token_info.exists, "balance token info lookup failed");
1132       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(principal_token_address);
1133       require(sbt.balanceOf(msg.sender) >= principal_amount, "insufficient principal balance");
1134 
1135       // Token epoch must be a past epoch
1136       uint256 token_epoch = token_info.epoch;
1137       require(token_info.token_type == LPTokenType.principal, "bad balance token address");
1138       require(token_epoch == 2, "v2: bal token epoch must be 2");
1139       require(epoch_wound_down[token_epoch], "can't remove from wound up epoch");
1140 
1141       epoch_principal[token_epoch] = epoch_principal[token_epoch].sub(principal_amount);
1142       pool_principal = pool_principal.sub(principal_amount);
1143     }
1144 
1145     // Transfer
1146     if (dsec_token_address != address(0x0) && dsec_amount > 0) {
1147       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(dsec_token_address);
1148       require(sbt.balanceOf(msg.sender) >= dsec_amount, "insufficient dsec balance");
1149       sbt.burn(msg.sender, dsec_amount);
1150       IERC20(SFI_address).safeTransfer(msg.sender, SFI_owned);
1151       emit RemoveLiquidityDsec(dsec_percent, SFI_owned);
1152     }
1153     if (principal_token_address != address(0x0) && principal_amount > 0) {
1154       SaffronLPBalanceToken sbt = SaffronLPBalanceToken(principal_token_address);
1155       require(sbt.balanceOf(msg.sender) >= principal_amount, "insufficient principal balance");
1156       sbt.burn(msg.sender, principal_amount);
1157       IERC20(base_asset_address).safeTransfer(msg.sender, principal_amount);
1158       emit RemoveLiquidityPrincipal(principal_amount);
1159     }
1160 
1161     require((dsec_token_address != address(0x0) && dsec_amount > 0) || (principal_token_address != address(0x0) && principal_amount > 0), "no action performed");
1162   }
1163 
1164   function hourly_strategy(address) external pure override {
1165     return;
1166   }
1167 
1168   function shutdown() external override {
1169     require(msg.sender == strategy, "must be strategy");
1170     require(block.timestamp > get_epoch_end(1) - 1 days, "trying to shutdown too early");
1171     _shutdown = true;
1172   }
1173 
1174   /*** GOVERNANCE ***/
1175   function set_governance(address to) external override {
1176     require(msg.sender == governance, "must be governance");
1177     governance = to;
1178   }
1179 
1180   function set_base_asset_address(address to) public {
1181     require(msg.sender == governance, "must be governance");
1182     base_asset_address = to;
1183   }
1184 
1185   /*** TIME UTILITY FUNCTIONS ***/
1186   function get_epoch_end(uint256 epoch) public view returns (uint256) {
1187     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration));
1188   }
1189 
1190   function get_current_epoch() public view returns (uint256) {
1191     require(block.timestamp > epoch_cycle.start_date, "before epoch 0");
1192     return (block.timestamp - epoch_cycle.start_date) / epoch_cycle.duration;
1193   }
1194 
1195   function get_seconds_until_epoch_end(uint256 epoch) public view returns (uint256) {
1196     return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration)).sub(block.timestamp);
1197   }
1198 
1199   /*** GETTERS ***/
1200   function get_epoch_cycle_params() external view override returns (uint256, uint256) {
1201     return (epoch_cycle.start_date, epoch_cycle.duration);
1202   }
1203 
1204   function get_base_asset_address() external view override returns(address) {
1205     return base_asset_address;
1206   }
1207 
1208   event ErcSwept(address who, address to, address token, uint256 amount);
1209   function erc_sweep(address _token, address _to) public {
1210     require(msg.sender == governance, "must be governance");
1211     require(_token != base_asset_address, "cannot sweep pool assets");
1212 
1213     IERC20 tkn = IERC20(_token);
1214     uint256 tBal = tkn.balanceOf(address(this));
1215     tkn.safeTransfer(_to, tBal);
1216 
1217     emit ErcSwept(msg.sender, _to, _token, tBal);
1218   }
1219 }
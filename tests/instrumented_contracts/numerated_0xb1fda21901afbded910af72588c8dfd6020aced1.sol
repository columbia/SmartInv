1 pragma solidity ^0.6.0;
2 
3 
4 // 
5 /**
6  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
7  * checks.
8  *
9  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
10  * easily result in undesired exploitation or bugs, since developers usually
11  * assume that overflows raise errors. `SafeCast` restores this intuition by
12  * reverting the transaction when such an operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  *
17  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
18  * all math on `uint256` and `int256` and then downcasting.
19  */
20 library SafeCast {
21 
22     /**
23      * @dev Returns the downcasted uint128 from uint256, reverting on
24      * overflow (when the input is greater than largest uint128).
25      *
26      * Counterpart to Solidity's `uint128` operator.
27      *
28      * Requirements:
29      *
30      * - input must fit into 128 bits
31      */
32     function toUint128(uint256 value) internal pure returns (uint128) {
33         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
34         return uint128(value);
35     }
36 
37     /**
38      * @dev Returns the downcasted uint64 from uint256, reverting on
39      * overflow (when the input is greater than largest uint64).
40      *
41      * Counterpart to Solidity's `uint64` operator.
42      *
43      * Requirements:
44      *
45      * - input must fit into 64 bits
46      */
47     function toUint64(uint256 value) internal pure returns (uint64) {
48         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
49         return uint64(value);
50     }
51 
52     /**
53      * @dev Returns the downcasted uint32 from uint256, reverting on
54      * overflow (when the input is greater than largest uint32).
55      *
56      * Counterpart to Solidity's `uint32` operator.
57      *
58      * Requirements:
59      *
60      * - input must fit into 32 bits
61      */
62     function toUint32(uint256 value) internal pure returns (uint32) {
63         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
64         return uint32(value);
65     }
66 
67     /**
68      * @dev Returns the downcasted uint16 from uint256, reverting on
69      * overflow (when the input is greater than largest uint16).
70      *
71      * Counterpart to Solidity's `uint16` operator.
72      *
73      * Requirements:
74      *
75      * - input must fit into 16 bits
76      */
77     function toUint16(uint256 value) internal pure returns (uint16) {
78         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
79         return uint16(value);
80     }
81 
82     /**
83      * @dev Returns the downcasted uint8 from uint256, reverting on
84      * overflow (when the input is greater than largest uint8).
85      *
86      * Counterpart to Solidity's `uint8` operator.
87      *
88      * Requirements:
89      *
90      * - input must fit into 8 bits.
91      */
92     function toUint8(uint256 value) internal pure returns (uint8) {
93         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
94         return uint8(value);
95     }
96 
97     /**
98      * @dev Converts a signed int256 into an unsigned uint256.
99      *
100      * Requirements:
101      *
102      * - input must be greater than or equal to 0.
103      */
104     function toUint256(int256 value) internal pure returns (uint256) {
105         require(value >= 0, "SafeCast: value must be positive");
106         return uint256(value);
107     }
108 
109     /**
110      * @dev Returns the downcasted int128 from int256, reverting on
111      * overflow (when the input is less than smallest int128 or
112      * greater than largest int128).
113      *
114      * Counterpart to Solidity's `int128` operator.
115      *
116      * Requirements:
117      *
118      * - input must fit into 128 bits
119      *
120      * _Available since v3.1._
121      */
122     function toInt128(int256 value) internal pure returns (int128) {
123         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
124         return int128(value);
125     }
126 
127     /**
128      * @dev Returns the downcasted int64 from int256, reverting on
129      * overflow (when the input is less than smallest int64 or
130      * greater than largest int64).
131      *
132      * Counterpart to Solidity's `int64` operator.
133      *
134      * Requirements:
135      *
136      * - input must fit into 64 bits
137      *
138      * _Available since v3.1._
139      */
140     function toInt64(int256 value) internal pure returns (int64) {
141         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
142         return int64(value);
143     }
144 
145     /**
146      * @dev Returns the downcasted int32 from int256, reverting on
147      * overflow (when the input is less than smallest int32 or
148      * greater than largest int32).
149      *
150      * Counterpart to Solidity's `int32` operator.
151      *
152      * Requirements:
153      *
154      * - input must fit into 32 bits
155      *
156      * _Available since v3.1._
157      */
158     function toInt32(int256 value) internal pure returns (int32) {
159         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
160         return int32(value);
161     }
162 
163     /**
164      * @dev Returns the downcasted int16 from int256, reverting on
165      * overflow (when the input is less than smallest int16 or
166      * greater than largest int16).
167      *
168      * Counterpart to Solidity's `int16` operator.
169      *
170      * Requirements:
171      *
172      * - input must fit into 16 bits
173      *
174      * _Available since v3.1._
175      */
176     function toInt16(int256 value) internal pure returns (int16) {
177         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
178         return int16(value);
179     }
180 
181     /**
182      * @dev Returns the downcasted int8 from int256, reverting on
183      * overflow (when the input is less than smallest int8 or
184      * greater than largest int8).
185      *
186      * Counterpart to Solidity's `int8` operator.
187      *
188      * Requirements:
189      *
190      * - input must fit into 8 bits.
191      *
192      * _Available since v3.1._
193      */
194     function toInt8(int256 value) internal pure returns (int8) {
195         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
196         return int8(value);
197     }
198 
199     /**
200      * @dev Converts an unsigned uint256 into a signed int256.
201      *
202      * Requirements:
203      *
204      * - input must be less than or equal to maxInt256.
205      */
206     function toInt256(uint256 value) internal pure returns (int256) {
207         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
208         return int256(value);
209     }
210 }
211 
212 // 
213 /**
214  * @dev Interface of the ERC20 standard as defined in the EIP.
215  */
216 interface IERC20 {
217     /**
218      * @dev Returns the amount of tokens in existence.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns the amount of tokens owned by `account`.
224      */
225     function balanceOf(address account) external view returns (uint256);
226 
227     /**
228      * @dev Moves `amount` tokens from the caller's account to `recipient`.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transfer(address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Returns the remaining number of tokens that `spender` will be
238      * allowed to spend on behalf of `owner` through {transferFrom}. This is
239      * zero by default.
240      *
241      * This value changes when {approve} or {transferFrom} are called.
242      */
243     function allowance(address owner, address spender) external view returns (uint256);
244 
245     /**
246      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * IMPORTANT: Beware that changing an allowance with this method brings the risk
251      * that someone may use both the old and the new allowance by unfortunate
252      * transaction ordering. One possible solution to mitigate this race
253      * condition is to first reduce the spender's allowance to 0 and set the
254      * desired value afterwards:
255      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      *
257      * Emits an {Approval} event.
258      */
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Moves `amount` tokens from `sender` to `recipient` using the
263      * allowance mechanism. `amount` is then deducted from the caller's
264      * allowance.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Emitted when `value` tokens are moved from one account (`from`) to
274      * another (`to`).
275      *
276      * Note that `value` may be zero.
277      */
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 
280     /**
281      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
282      * a call to {approve}. `value` is the new allowance.
283      */
284     event Approval(address indexed owner, address indexed spender, uint256 value);
285 }
286 
287 // 
288 /*
289  * @dev Provides information about the current execution context, including the
290  * sender of the transaction and its data. While these are generally available
291  * via msg.sender and msg.data, they should not be accessed in such a direct
292  * manner, since when dealing with GSN meta-transactions the account sending and
293  * paying for execution may not be the actual sender (as far as an application
294  * is concerned).
295  *
296  * This contract is only required for intermediate, library-like contracts.
297  */
298 abstract contract Context {
299     function _msgSender() internal view virtual returns (address payable) {
300         return msg.sender;
301     }
302 
303     function _msgData() internal view virtual returns (bytes memory) {
304         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
305         return msg.data;
306     }
307 }
308 
309 // 
310 /**
311  * @dev Wrappers over Solidity's arithmetic operations with added overflow
312  * checks.
313  *
314  * Arithmetic operations in Solidity wrap on overflow. This can easily result
315  * in bugs, because programmers usually assume that an overflow raises an
316  * error, which is the standard behavior in high level programming languages.
317  * `SafeMath` restores this intuition by reverting the transaction when an
318  * operation overflows.
319  *
320  * Using this library instead of the unchecked operations eliminates an entire
321  * class of bugs, so it's recommended to use it always.
322  */
323 library SafeMath {
324     /**
325      * @dev Returns the addition of two unsigned integers, reverting on
326      * overflow.
327      *
328      * Counterpart to Solidity's `+` operator.
329      *
330      * Requirements:
331      *
332      * - Addition cannot overflow.
333      */
334     function add(uint256 a, uint256 b) internal pure returns (uint256) {
335         uint256 c = a + b;
336         require(c >= a, "SafeMath: addition overflow");
337 
338         return c;
339     }
340 
341     /**
342      * @dev Returns the subtraction of two unsigned integers, reverting on
343      * overflow (when the result is negative).
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
352         return sub(a, b, "SafeMath: subtraction overflow");
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
357      * overflow (when the result is negative).
358      *
359      * Counterpart to Solidity's `-` operator.
360      *
361      * Requirements:
362      *
363      * - Subtraction cannot overflow.
364      */
365     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
366         require(b <= a, errorMessage);
367         uint256 c = a - b;
368 
369         return c;
370     }
371 
372     /**
373      * @dev Returns the multiplication of two unsigned integers, reverting on
374      * overflow.
375      *
376      * Counterpart to Solidity's `*` operator.
377      *
378      * Requirements:
379      *
380      * - Multiplication cannot overflow.
381      */
382     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
383         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
384         // benefit is lost if 'b' is also tested.
385         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
386         if (a == 0) {
387             return 0;
388         }
389 
390         uint256 c = a * b;
391         require(c / a == b, "SafeMath: multiplication overflow");
392 
393         return c;
394     }
395 
396     /**
397      * @dev Returns the integer division of two unsigned integers. Reverts on
398      * division by zero. The result is rounded towards zero.
399      *
400      * Counterpart to Solidity's `/` operator. Note: this function uses a
401      * `revert` opcode (which leaves remaining gas untouched) while Solidity
402      * uses an invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(uint256 a, uint256 b) internal pure returns (uint256) {
409         return div(a, b, "SafeMath: division by zero");
410     }
411 
412     /**
413      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
414      * division by zero. The result is rounded towards zero.
415      *
416      * Counterpart to Solidity's `/` operator. Note: this function uses a
417      * `revert` opcode (which leaves remaining gas untouched) while Solidity
418      * uses an invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
425         require(b > 0, errorMessage);
426         uint256 c = a / b;
427         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
428 
429         return c;
430     }
431 
432     /**
433      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
434      * Reverts when dividing by zero.
435      *
436      * Counterpart to Solidity's `%` operator. This function uses a `revert`
437      * opcode (which leaves remaining gas untouched) while Solidity uses an
438      * invalid opcode to revert (consuming all remaining gas).
439      *
440      * Requirements:
441      *
442      * - The divisor cannot be zero.
443      */
444     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
445         return mod(a, b, "SafeMath: modulo by zero");
446     }
447 
448     /**
449      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
450      * Reverts with custom message when dividing by zero.
451      *
452      * Counterpart to Solidity's `%` operator. This function uses a `revert`
453      * opcode (which leaves remaining gas untouched) while Solidity uses an
454      * invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
461         require(b != 0, errorMessage);
462         return a % b;
463     }
464 }
465 
466 // 
467 /**
468  * @dev Collection of functions related to the address type
469  */
470 library Address {
471     /**
472      * @dev Returns true if `account` is a contract.
473      *
474      * [IMPORTANT]
475      * ====
476      * It is unsafe to assume that an address for which this function returns
477      * false is an externally-owned account (EOA) and not a contract.
478      *
479      * Among others, `isContract` will return false for the following
480      * types of addresses:
481      *
482      *  - an externally-owned account
483      *  - a contract in construction
484      *  - an address where a contract will be created
485      *  - an address where a contract lived, but was destroyed
486      * ====
487      */
488     function isContract(address account) internal view returns (bool) {
489         // This method relies in extcodesize, which returns 0 for contracts in
490         // construction, since the code is only stored at the end of the
491         // constructor execution.
492 
493         uint256 size;
494         // solhint-disable-next-line no-inline-assembly
495         assembly { size := extcodesize(account) }
496         return size > 0;
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      */
515     function sendValue(address payable recipient, uint256 amount) internal {
516         require(address(this).balance >= amount, "Address: insufficient balance");
517 
518         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
519         (bool success, ) = recipient.call{ value: amount }("");
520         require(success, "Address: unable to send value, recipient may have reverted");
521     }
522 
523     /**
524      * @dev Performs a Solidity function call using a low level `call`. A
525      * plain`call` is an unsafe replacement for a function call: use this
526      * function instead.
527      *
528      * If `target` reverts with a revert reason, it is bubbled up by this
529      * function (like regular Solidity function calls).
530      *
531      * Returns the raw returned data. To convert to the expected return value,
532      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
533      *
534      * Requirements:
535      *
536      * - `target` must be a contract.
537      * - calling `target` with `data` must not revert.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
542       return functionCall(target, data, "Address: low-level call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
547      * `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
552         return _functionCallWithValue(target, data, 0, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but also transferring `value` wei to `target`.
558      *
559      * Requirements:
560      *
561      * - the calling contract must have an ETH balance of at least `value`.
562      * - the called Solidity function must be `payable`.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
572      * with `errorMessage` as a fallback revert reason when `target` reverts.
573      *
574      * _Available since v3.1._
575      */
576     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
577         require(address(this).balance >= value, "Address: insufficient balance for call");
578         return _functionCallWithValue(target, data, value, errorMessage);
579     }
580 
581     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
582         require(isContract(target), "Address: call to non-contract");
583 
584         // solhint-disable-next-line avoid-low-level-calls
585         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 // solhint-disable-next-line no-inline-assembly
594                 assembly {
595                     let returndata_size := mload(returndata)
596                     revert(add(32, returndata), returndata_size)
597                 }
598             } else {
599                 revert(errorMessage);
600             }
601         }
602     }
603 }
604 
605 // 
606 /**
607  * @dev Implementation of the {IERC20} interface.
608  *
609  * This implementation is agnostic to the way tokens are created. This means
610  * that a supply mechanism has to be added in a derived contract using {_mint}.
611  * For a generic mechanism see {ERC20PresetMinterPauser}.
612  *
613  * TIP: For a detailed writeup see our guide
614  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
615  * to implement supply mechanisms].
616  *
617  * We have followed general OpenZeppelin guidelines: functions revert instead
618  * of returning `false` on failure. This behavior is nonetheless conventional
619  * and does not conflict with the expectations of ERC20 applications.
620  *
621  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
622  * This allows applications to reconstruct the allowance for all accounts just
623  * by listening to said events. Other implementations of the EIP may not emit
624  * these events, as it isn't required by the specification.
625  *
626  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
627  * functions have been added to mitigate the well-known issues around setting
628  * allowances. See {IERC20-approve}.
629  */
630 contract ERC20 is Context, IERC20 {
631     using SafeMath for uint256;
632     using Address for address;
633 
634     mapping (address => uint256) private _balances;
635 
636     mapping (address => mapping (address => uint256)) private _allowances;
637 
638     uint256 private _totalSupply;
639 
640     string private _name;
641     string private _symbol;
642     uint8 private _decimals;
643 
644     /**
645      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
646      * a default value of 18.
647      *
648      * To select a different value for {decimals}, use {_setupDecimals}.
649      *
650      * All three of these values are immutable: they can only be set once during
651      * construction.
652      */
653     constructor (string memory name, string memory symbol) public {
654         _name = name;
655         _symbol = symbol;
656         _decimals = 18;
657     }
658 
659     /**
660      * @dev Returns the name of the token.
661      */
662     function name() public view returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev Returns the symbol of the token, usually a shorter version of the
668      * name.
669      */
670     function symbol() public view returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev Returns the number of decimals used to get its user representation.
676      * For example, if `decimals` equals `2`, a balance of `505` tokens should
677      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
678      *
679      * Tokens usually opt for a value of 18, imitating the relationship between
680      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
681      * called.
682      *
683      * NOTE: This information is only used for _display_ purposes: it in
684      * no way affects any of the arithmetic of the contract, including
685      * {IERC20-balanceOf} and {IERC20-transfer}.
686      */
687     function decimals() public view returns (uint8) {
688         return _decimals;
689     }
690 
691     /**
692      * @dev See {IERC20-totalSupply}.
693      */
694     function totalSupply() public view override returns (uint256) {
695         return _totalSupply;
696     }
697 
698     /**
699      * @dev See {IERC20-balanceOf}.
700      */
701     function balanceOf(address account) public view override returns (uint256) {
702         return _balances[account];
703     }
704 
705     /**
706      * @dev See {IERC20-transfer}.
707      *
708      * Requirements:
709      *
710      * - `recipient` cannot be the zero address.
711      * - the caller must have a balance of at least `amount`.
712      */
713     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
714         _transfer(_msgSender(), recipient, amount);
715         return true;
716     }
717 
718     /**
719      * @dev See {IERC20-allowance}.
720      */
721     function allowance(address owner, address spender) public view virtual override returns (uint256) {
722         return _allowances[owner][spender];
723     }
724 
725     /**
726      * @dev See {IERC20-approve}.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      */
732     function approve(address spender, uint256 amount) public virtual override returns (bool) {
733         _approve(_msgSender(), spender, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-transferFrom}.
739      *
740      * Emits an {Approval} event indicating the updated allowance. This is not
741      * required by the EIP. See the note at the beginning of {ERC20};
742      *
743      * Requirements:
744      * - `sender` and `recipient` cannot be the zero address.
745      * - `sender` must have a balance of at least `amount`.
746      * - the caller must have allowance for ``sender``'s tokens of at least
747      * `amount`.
748      */
749     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
750         _transfer(sender, recipient, amount);
751         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
752         return true;
753     }
754 
755     /**
756      * @dev Atomically increases the allowance granted to `spender` by the caller.
757      *
758      * This is an alternative to {approve} that can be used as a mitigation for
759      * problems described in {IERC20-approve}.
760      *
761      * Emits an {Approval} event indicating the updated allowance.
762      *
763      * Requirements:
764      *
765      * - `spender` cannot be the zero address.
766      */
767     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
768         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
769         return true;
770     }
771 
772     /**
773      * @dev Atomically decreases the allowance granted to `spender` by the caller.
774      *
775      * This is an alternative to {approve} that can be used as a mitigation for
776      * problems described in {IERC20-approve}.
777      *
778      * Emits an {Approval} event indicating the updated allowance.
779      *
780      * Requirements:
781      *
782      * - `spender` cannot be the zero address.
783      * - `spender` must have allowance for the caller of at least
784      * `subtractedValue`.
785      */
786     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
787         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
788         return true;
789     }
790 
791     /**
792      * @dev Moves tokens `amount` from `sender` to `recipient`.
793      *
794      * This is internal function is equivalent to {transfer}, and can be used to
795      * e.g. implement automatic token fees, slashing mechanisms, etc.
796      *
797      * Emits a {Transfer} event.
798      *
799      * Requirements:
800      *
801      * - `sender` cannot be the zero address.
802      * - `recipient` cannot be the zero address.
803      * - `sender` must have a balance of at least `amount`.
804      */
805     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
806         require(sender != address(0), "ERC20: transfer from the zero address");
807         require(recipient != address(0), "ERC20: transfer to the zero address");
808 
809         _beforeTokenTransfer(sender, recipient, amount);
810 
811         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
812         _balances[recipient] = _balances[recipient].add(amount);
813         emit Transfer(sender, recipient, amount);
814     }
815 
816     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
817      * the total supply.
818      *
819      * Emits a {Transfer} event with `from` set to the zero address.
820      *
821      * Requirements
822      *
823      * - `to` cannot be the zero address.
824      */
825     function _mint(address account, uint256 amount) internal virtual {
826         require(account != address(0), "ERC20: mint to the zero address");
827 
828         _beforeTokenTransfer(address(0), account, amount);
829 
830         _totalSupply = _totalSupply.add(amount);
831         _balances[account] = _balances[account].add(amount);
832         emit Transfer(address(0), account, amount);
833     }
834 
835     /**
836      * @dev Destroys `amount` tokens from `account`, reducing the
837      * total supply.
838      *
839      * Emits a {Transfer} event with `to` set to the zero address.
840      *
841      * Requirements
842      *
843      * - `account` cannot be the zero address.
844      * - `account` must have at least `amount` tokens.
845      */
846     function _burn(address account, uint256 amount) internal virtual {
847         require(account != address(0), "ERC20: burn from the zero address");
848 
849         _beforeTokenTransfer(account, address(0), amount);
850 
851         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
852         _totalSupply = _totalSupply.sub(amount);
853         emit Transfer(account, address(0), amount);
854     }
855 
856     /**
857      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
858      *
859      * This internal function is equivalent to `approve`, and can be used to
860      * e.g. set automatic allowances for certain subsystems, etc.
861      *
862      * Emits an {Approval} event.
863      *
864      * Requirements:
865      *
866      * - `owner` cannot be the zero address.
867      * - `spender` cannot be the zero address.
868      */
869     function _approve(address owner, address spender, uint256 amount) internal virtual {
870         require(owner != address(0), "ERC20: approve from the zero address");
871         require(spender != address(0), "ERC20: approve to the zero address");
872 
873         _allowances[owner][spender] = amount;
874         emit Approval(owner, spender, amount);
875     }
876 
877     /**
878      * @dev Sets {decimals} to a value other than the default one of 18.
879      *
880      * WARNING: This function should only be called from the constructor. Most
881      * applications that interact with token contracts will not expect
882      * {decimals} to ever change, and may work incorrectly if it does.
883      */
884     function _setupDecimals(uint8 decimals_) internal {
885         _decimals = decimals_;
886     }
887 
888     /**
889      * @dev Hook that is called before any transfer of tokens. This includes
890      * minting and burning.
891      *
892      * Calling conditions:
893      *
894      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
895      * will be to transferred to `to`.
896      * - when `from` is zero, `amount` tokens will be minted for `to`.
897      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
898      * - `from` and `to` are never both zero.
899      *
900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
901      */
902     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
903 }
904 
905 // 
906 /**
907  * @dev Contract module which provides a basic access control mechanism, where
908  * there is an account (an owner) that can be granted exclusive access to
909  * specific functions.
910  *
911  * By default, the owner account will be the one that deploys the contract. This
912  * can later be changed with {transferOwnership}.
913  *
914  * This module is used through inheritance. It will make available the modifier
915  * `onlyOwner`, which can be applied to your functions to restrict their use to
916  * the owner.
917  */
918 contract Ownable is Context {
919     address private _owner;
920 
921     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
922 
923     /**
924      * @dev Initializes the contract setting the deployer as the initial owner.
925      */
926     constructor () internal {
927         address msgSender = _msgSender();
928         _owner = msgSender;
929         emit OwnershipTransferred(address(0), msgSender);
930     }
931 
932     /**
933      * @dev Returns the address of the current owner.
934      */
935     function owner() public view returns (address) {
936         return _owner;
937     }
938 
939     /**
940      * @dev Throws if called by any account other than the owner.
941      */
942     modifier onlyOwner() {
943         require(_owner == _msgSender(), "Ownable: caller is not the owner");
944         _;
945     }
946 
947     /**
948      * @dev Leaves the contract without owner. It will not be possible to call
949      * `onlyOwner` functions anymore. Can only be called by the current owner.
950      *
951      * NOTE: Renouncing ownership will leave the contract without an owner,
952      * thereby removing any functionality that is only available to the owner.
953      */
954     function renounceOwnership() public virtual onlyOwner {
955         emit OwnershipTransferred(_owner, address(0));
956         _owner = address(0);
957     }
958 
959     /**
960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
961      * Can only be called by the current owner.
962      */
963     function transferOwnership(address newOwner) public virtual onlyOwner {
964         require(newOwner != address(0), "Ownable: new owner is the zero address");
965         emit OwnershipTransferred(_owner, newOwner);
966         _owner = newOwner;
967     }
968 }
969 
970 interface IUniswapV2Pair {
971     function sync() external;
972 }
973 
974 interface IUniswapV2Factory {
975     function createPair(address tokenA, address tokenB) external returns (address pair);
976 }
977 
978 interface IUniswapV2Router01 {
979     function WETH() external pure returns (address);
980 }
981 
982 contract ATH is IERC20, Ownable {    
983     using SafeCast for int256;
984     using SafeMath for uint256;
985     using Address for address;
986     
987     uint256 private _epoch;
988     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
989 
990     mapping (address => uint256) private _rOwned;
991     mapping (address => uint256) private _tOwned;
992     mapping (address => mapping (address => uint256)) private _allowances;
993 
994     mapping (address => bool) private _isExcluded;
995     address[] private _excluded;
996 	
997     uint256 private constant DECIMALS = 9;
998     uint256 private constant RATE_PRECISION = 10 ** DECIMALS;
999 
1000     string private _name = "athbase.finance";
1001     string private _symbol = "ATH";
1002     uint8 private _decimals = uint8(DECIMALS);
1003 	uint256 private _totalSupply;
1004    
1005     uint256 private constant MAX = ~uint256(0);
1006     uint256 private _rTotal;
1007     uint256 private _tFeeTotal;
1008     
1009     uint256 public _tFeePercent;
1010     uint256 public _tFeeTimestamp;
1011     
1012     address public _rebaser;
1013     
1014     uint256 public _limitExpiresTimestamp;
1015     uint256 public _limitTransferAmount;
1016     uint256 public _limitMaxBalance;
1017     uint256 public _limitSellFeePercent;
1018     
1019     uint256 public _limitTimestamp;
1020 
1021     IUniswapV2Factory public constant uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); 
1022 
1023     IUniswapV2Router01 public constant uniswapRouter = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
1024 
1025     address public uniswapPair; 
1026 
1027     constructor(uint256 initialSupply)
1028     public
1029     Ownable()
1030     {
1031         _totalSupply = initialSupply;
1032         _rTotal = (MAX - (MAX % _totalSupply));
1033         
1034         _rebaser = _msgSender();
1035         
1036         _tFeePercent = 500; // 5.00%
1037         _tFeeTimestamp = now;
1038 
1039         _rOwned[_msgSender()] = _rTotal;
1040         emit Transfer(address(0), _msgSender(), _totalSupply);
1041         
1042         excludeAccount(_msgSender());
1043     }
1044 
1045     function setUniswapPair() external onlyOwner {
1046         require(uniswapPair == address(0), "already initialized");
1047         uniswapPair = uniswapFactory.createPair(uniswapRouter.WETH(), address(this));
1048     }
1049 
1050     function name() public view returns (string memory) {
1051         return _name;
1052     }
1053 
1054     function symbol() public view returns (string memory) {
1055         return _symbol;
1056     }
1057 
1058     function decimals() public view returns (uint8) {
1059         return _decimals;
1060     }    
1061     
1062     function setRebaser(address rebaser) external onlyOwner() {
1063         _rebaser = rebaser;
1064     }
1065     
1066     function setTransferFeePercent(uint256 tFeePercent) external onlyOwner() {
1067         require(now >= (_tFeeTimestamp + 12 hours), "Transfer fee changes timelocked for 12 hours");
1068 
1069         _tFeePercent = tFeePercent;
1070         
1071         _tFeeTimestamp = now;
1072     }
1073     
1074     function setLimit(uint256 expiresTimestamp, uint256 transferAmount, uint256 maxBalance, uint256 sellFeePercent) external onlyOwner() {
1075         require(_limitTimestamp == 0, "Limit changes not allowed");
1076         
1077         _limitExpiresTimestamp = expiresTimestamp;
1078         _limitTransferAmount = transferAmount;
1079         _limitMaxBalance = maxBalance;
1080         _limitSellFeePercent = sellFeePercent;
1081 
1082         _limitTimestamp = now;
1083     }
1084     
1085     function totalSupply() public view override returns (uint256) {
1086         return _totalSupply;
1087     }
1088     
1089     function rebase(int256 supplyDelta)
1090         external
1091         returns (uint256)
1092     {
1093         require(_msgSender() == owner() || _msgSender() == _rebaser, "Sender not authorized");
1094         
1095         _epoch = _epoch.add(1);
1096 		
1097         if (supplyDelta == 0) {
1098             emit LogRebase(_epoch, _totalSupply);
1099             return _totalSupply;
1100         }
1101         
1102         uint256 uSupplyDelta = (supplyDelta < 0 ? -supplyDelta : supplyDelta).toUint256();
1103         uint256 rate = uSupplyDelta.mul(RATE_PRECISION).div(_totalSupply);
1104         uint256 multiplier;
1105         
1106         if (supplyDelta < 0) {
1107             multiplier = RATE_PRECISION.sub(rate);
1108         } else {
1109             multiplier = RATE_PRECISION.add(rate);
1110         }
1111         
1112         if (supplyDelta < 0) {
1113             _totalSupply = _totalSupply.sub(uSupplyDelta);
1114         } else {
1115             _totalSupply = _totalSupply.add(uSupplyDelta);
1116         }
1117         
1118         if (_totalSupply > MAX) {
1119             _totalSupply = MAX;
1120         }
1121         
1122         for (uint256 i = 0; i < _excluded.length; i++) {
1123             if(_tOwned[_excluded[i]] > 0) {
1124                 _tOwned[_excluded[i]] = _tOwned[_excluded[i]].mul(multiplier).div(RATE_PRECISION);
1125             }
1126         }
1127     
1128         // Sync the pair so uniswap is aware of the new supply
1129 		IUniswapV2Pair(uniswapPair).sync();
1130 
1131         emit LogRebase(_epoch, _totalSupply);
1132 
1133         return _totalSupply;
1134     }
1135     
1136     function balanceOf(address account) public view override returns (uint256) {
1137         if (_isExcluded[account]) return _tOwned[account];
1138         return tokenFromRefraction(_rOwned[account]);
1139     }
1140 
1141     function transfer(address recipient, uint256 amount) public override returns (bool) {
1142         _transfer(_msgSender(), recipient, amount);
1143         return true;
1144     }
1145 
1146     function allowance(address owner, address spender) public view override returns (uint256) {
1147         return _allowances[owner][spender];
1148     }
1149 
1150     function approve(address spender, uint256 amount) public override returns (bool) {
1151         _approve(_msgSender(), spender, amount);
1152         return true;
1153     }
1154 
1155     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1156         _transfer(sender, recipient, amount);
1157         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1158         return true;
1159     }
1160 
1161     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1162         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1163         return true;
1164     }
1165 
1166     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1168         return true;
1169     }
1170 
1171     function isExcluded(address account) public view returns (bool) {
1172         return _isExcluded[account];
1173     }
1174 
1175     function totalFees() public view returns (uint256) {
1176         return _tFeeTotal;
1177     }
1178 
1179     function refract(uint256 tAmount) public {
1180         address sender = _msgSender();
1181         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1182         (uint256 rAmount,,,,) = _getValues(tAmount, _tFeePercent);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _rTotal = _rTotal.sub(rAmount);
1185         _tFeeTotal = _tFeeTotal.add(tAmount);
1186     }
1187 
1188     function refractionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1189         require(tAmount <= _totalSupply, "Amount must be less than supply");
1190         if (!deductTransferFee) {
1191             (uint256 rAmount,,,,) = _getValues(tAmount, _tFeePercent);
1192             return rAmount;
1193         } else {
1194             (,uint256 rTransferAmount,,,) = _getValues(tAmount, _tFeePercent);
1195             return rTransferAmount;
1196         }
1197     }
1198 
1199     function tokenFromRefraction(uint256 rAmount) public view returns(uint256) {
1200         require(rAmount <= _rTotal, "Amount must be less than total refractions");
1201         uint256 currentRate =  _getRate();
1202         return rAmount.div(currentRate);
1203     }
1204 
1205     function excludeAccount(address account) public onlyOwner() {
1206         require(!_isExcluded[account], "Account is already excluded");
1207         if(_rOwned[account] > 0) {
1208             _tOwned[account] = tokenFromRefraction(_rOwned[account]);
1209         }
1210         _isExcluded[account] = true;
1211         _excluded.push(account);
1212     }
1213 
1214     function includeAccount(address account) public onlyOwner() {
1215         require(_isExcluded[account], "Account is already excluded");
1216         for (uint256 i = 0; i < _excluded.length; i++) {
1217             if (_excluded[i] == account) {
1218                 _excluded[i] = _excluded[_excluded.length - 1];
1219                 _tOwned[account] = 0;
1220                 _isExcluded[account] = false;
1221                 _excluded.pop();
1222                 break;
1223             }
1224         }
1225     }
1226 
1227     function _approve(address owner, address spender, uint256 amount) internal {
1228         require(owner != address(0), "ERC20: approve from the zero address");
1229         require(spender != address(0), "ERC20: approve to the zero address");
1230 
1231         _allowances[owner][spender] = amount;
1232         emit Approval(owner, spender, amount);
1233     }
1234 
1235     function _transfer(address sender, address recipient, uint256 amount) internal {
1236         require(sender != address(0), "ERC20: transfer from the zero address");
1237         require(recipient != address(0), "ERC20: transfer to the zero address");
1238         require(amount > 0, "Transfer amount must be greater than zero");
1239         
1240         if(_isExcluded[sender] && !_isExcluded[recipient])
1241         {
1242             if(_limitExpiresTimestamp >= now) {
1243                 require(amount <= _limitTransferAmount, "Initial Uniswap listing - amount exceeds transfer limit");
1244                 require(balanceOf(recipient).add(amount) <= _limitMaxBalance, "Initial Uniswap listing - max balance limit");
1245             }
1246             _transferFromExcluded(sender, recipient, amount, _tFeePercent);            
1247         } 
1248         else if (!_isExcluded[sender] && _isExcluded[recipient]) 
1249         {            
1250             if (_limitExpiresTimestamp >= now) {
1251                 _transferToExcluded(sender, recipient, amount, _limitSellFeePercent);
1252             } else {
1253                 _transferToExcluded(sender, recipient, amount, _tFeePercent);
1254             }
1255 
1256         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1257             require(_limitExpiresTimestamp < now, "Initial Uniswap listing - Wallet to Wallet transfers temporarily disabled");
1258             _transferStandard(sender, recipient, amount, _tFeePercent);
1259             
1260         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1261             _transferBothExcluded(sender, recipient, amount, 0);            
1262         } else {
1263             require(_limitExpiresTimestamp < now, "Initial Uniswap listing - Wallet to Wallet transfers temporarily disabled");
1264             _transferStandard(sender, recipient, amount, _tFeePercent);            
1265         }
1266     }
1267     
1268     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1269         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1270         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1271         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
1272         _refractFee(rFee, tFee);
1273         emit Transfer(sender, recipient, tTransferAmount);
1274     }
1275 
1276     function _transferToExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1277         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1278         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1279         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1280         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1281         _refractFee(rFee, tFee);
1282         emit Transfer(sender, recipient, tTransferAmount);
1283     }
1284 
1285     function _transferFromExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1286         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1287         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1288         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1289         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1290         _refractFee(rFee, tFee);
1291         emit Transfer(sender, recipient, tTransferAmount);
1292     }
1293 
1294     function _transferBothExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1295         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1296         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1297         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1298         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1299         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1300         _refractFee(rFee, tFee);
1301         emit Transfer(sender, recipient, tTransferAmount);
1302     }
1303 
1304     function _refractFee(uint256 rFee, uint256 tFee) private {
1305         _rTotal = _rTotal.sub(rFee);
1306         _tFeeTotal = _tFeeTotal.add(tFee);
1307     }
1308 
1309     function _getValues(uint256 tAmount, uint256 tFeePercent) private view returns (uint256, uint256, uint256, uint256, uint256) {
1310         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, tFeePercent);
1311         uint256 currentRate =  _getRate();
1312         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1313         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1314     }
1315 
1316     function _getTValues(uint256 tAmount, uint256 tFeePercent) private pure returns (uint256, uint256) {
1317         uint256 tFee = tAmount.mul(tFeePercent).div(10000);
1318         uint256 tTransferAmount = tAmount.sub(tFee);
1319         return (tTransferAmount, tFee);
1320     }
1321 
1322     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1323         uint256 rAmount = tAmount.mul(currentRate);
1324         uint256 rFee = tFee.mul(currentRate);
1325         uint256 rTransferAmount = rAmount.sub(rFee);
1326         return (rAmount, rTransferAmount, rFee);
1327     }
1328 
1329     function _getRate() private view returns(uint256) {
1330         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1331         return rSupply.div(tSupply);
1332     }
1333 
1334     function _getCurrentSupply() private view returns(uint256, uint256) {
1335         uint256 rSupply = _rTotal;
1336         uint256 tSupply = _totalSupply;      
1337         for (uint256 i = 0; i < _excluded.length; i++) {
1338             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _totalSupply);
1339             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1340             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1341         }
1342         if (rSupply < _rTotal.div(_totalSupply)) return (_rTotal, _totalSupply);
1343         return (rSupply, tSupply);
1344     }
1345 }
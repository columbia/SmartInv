1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/OpenZeppelin/utils/Context.sol
4 
5 pragma solidity 0.6.12;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 // File contracts/OpenZeppelin/GSN/Context.sol
30 
31 pragma solidity 0.6.12;
32 
33 
34 // File contracts/OpenZeppelin/math/SafeMath.sol
35 
36 pragma solidity 0.6.12;
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations with added overflow
40  * checks.
41  *
42  * Arithmetic operations in Solidity wrap on overflow. This can easily result
43  * in bugs, because programmers usually assume that an overflow raises an
44  * error, which is the standard behavior in high level programming languages.
45  * `SafeMath` restores this intuition by reverting the transaction when an
46  * operation overflows.
47  *
48  * Using this library instead of the unchecked operations eliminates an entire
49  * class of bugs, so it's recommended to use it always.
50  */
51 library SafeMath {
52     /**
53      * @dev Returns the addition of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         uint256 c = a + b;
59         if (c < a) return (false, 0);
60         return (true, c);
61     }
62 
63     /**
64      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         if (b > a) return (false, 0);
70         return (true, a - b);
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) return (true, 0);
83         uint256 c = a * b;
84         if (c / a != b) return (false, 0);
85         return (true, c);
86     }
87 
88     /**
89      * @dev Returns the division of two unsigned integers, with a division by zero flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         if (b == 0) return (false, 0);
95         return (true, a / b);
96     }
97 
98     /**
99      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
100      *
101      * _Available since v3.4._
102      */
103     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         if (b == 0) return (false, 0);
105         return (true, a % b);
106     }
107 
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b <= a, "SafeMath: subtraction overflow");
136         return a - b;
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
150         if (a == 0) return 0;
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers, reverting on
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
169         require(b > 0, "SafeMath: division by zero");
170         return a / b;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * reverting when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b > 0, "SafeMath: modulo by zero");
187         return a % b;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
192      * overflow (when the result is negative).
193      *
194      * CAUTION: This function is deprecated because it requires allocating memory for the error
195      * message unnecessarily. For custom revert reasons use {trySub}.
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b <= a, errorMessage);
205         return a - b;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {tryDiv}.
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
225         return a / b;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b > 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 
250 // File contracts/OpenZeppelin/utils/Address.sol
251 
252 pragma solidity 0.6.12;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { size := extcodesize(account) }
283         return size > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: value }(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return _verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
421         if (success) {
422             return returndata;
423         } else {
424             // Look for revert reason and bubble it up if present
425             if (returndata.length > 0) {
426                 // The easiest way to bubble the revert reason is using memory via assembly
427 
428                 // solhint-disable-next-line no-inline-assembly
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 
441 // File contracts/interfaces/IERC20.sol
442 
443 pragma solidity 0.6.12;
444 
445 interface IERC20 {
446     function totalSupply() external view returns (uint256);
447     function balanceOf(address account) external view returns (uint256);
448     function allowance(address owner, address spender) external view returns (uint256);
449     function approve(address spender, uint256 amount) external returns (bool);
450     function name() external view returns (string memory);
451     function symbol() external view returns (string memory);
452     function decimals() external view returns (uint8);
453 
454     event Transfer(address indexed from, address indexed to, uint256 value);
455     event Approval(address indexed owner, address indexed spender, uint256 value);
456 
457     function permit(
458         address owner,
459         address spender,
460         uint256 value,
461         uint256 deadline,
462         uint8 v,
463         bytes32 r,
464         bytes32 s
465     ) external;
466 }
467 
468 
469 // File contracts/Tokens/ERC20.sol
470 
471 pragma solidity 0.6.12;
472 
473 
474 
475 
476 /**
477  * @dev Implementation of the {IERC20} interface.
478  *
479  * This implementation is agnostic to the way tokens are created. This means
480  * that a supply mechanism has to be added in a derived contract using {_mint}.
481  * For a generic mechanism see {ERC20PresetMinterPauser}.
482  *
483  * TIP: For a detailed writeup see our guide
484  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
485  * to implement supply mechanisms].
486  *
487  * We have followed general OpenZeppelin guidelines: functions revert instead
488  * of returning `false` on failure. This behavior is nonetheless conventional
489  * and does not conflict with the expectations of ERC20 applications.
490  *
491  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
492  * This allows applications to reconstruct the allowance for all accounts just
493  * by listening to said events. Other implementations of the EIP may not emit
494  * these events, as it isn't required by the specification.
495  *
496  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
497  * functions have been added to mitigate the well-known issues around setting
498  * allowances. See {IERC20-approve}.
499  */
500 
501 contract ERC20 is IERC20, Context {
502     using SafeMath for uint256;
503     using Address for address;
504     bytes32 public DOMAIN_SEPARATOR;
505 
506     mapping (address => uint256) private _balances;
507     mapping(address => uint256) public nonces;
508 
509     mapping (address => mapping (address => uint256)) private _allowances;
510 
511     uint256 private _totalSupply;
512 
513     string private _name;
514     string private _symbol;
515     uint8 private _decimals;
516     bool private _initialized;
517 
518     /**
519      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
520      * a default value of 18.
521      *
522      * To select a different value for {decimals}, use {_setupDecimals}.
523      *
524      * All three of these values are immutable: they can only be set once during
525      * construction.
526      */
527     function _initERC20(string memory name_, string memory symbol_) internal {
528         require(!_initialized, "ERC20: token has already been initialized!");
529         _name = name_;
530         _symbol = symbol_;
531         _decimals = 18;
532         uint256 chainId;
533         assembly {
534             chainId := chainid()
535         }
536         DOMAIN_SEPARATOR = keccak256(abi.encode(keccak256("EIP712Domain(uint256 chainId,address verifyingContract)"), chainId, address(this)));
537  
538         _initialized = true;
539     }
540 
541     /**
542      * @dev Returns the name of the token.
543      */
544     function name() public view override returns (string memory) {
545         return _name;
546     }
547 
548     /**
549      * @dev Returns the symbol of the token, usually a shorter version of the
550      * name.
551      */
552     function symbol() public view override returns (string memory) {
553         return _symbol;
554     }
555 
556     /**
557      * @dev Returns the number of decimals used to get its user representation.
558      * For example, if `decimals` equals `2`, a balance of `505` tokens should
559      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
560      *
561      * Tokens usually opt for a value of 18, imitating the relationship between
562      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
563      * called.
564      *
565      * NOTE: This information is only used for _display_ purposes: it in
566      * no way affects any of the arithmetic of the contract, including
567      * {IERC20-balanceOf} and {IERC20-transfer}.
568      */
569     function decimals() public view override returns (uint8) {
570         return _decimals;
571     }
572 
573     /**
574      * @dev See {IERC20-totalSupply}.
575      */
576     function totalSupply() public view override returns (uint256) {
577         return _totalSupply;
578     }
579 
580     /**
581      * @dev See {IERC20-balanceOf}.
582      */
583     function balanceOf(address account) public view override returns (uint256) {
584         return _balances[account];
585     }
586 
587     /**
588      * @dev See {IERC20-transfer}.
589      *
590      * Requirements:
591      *
592      * - `recipient` cannot be the zero address.
593      * - the caller must have a balance of at least `amount`.
594      */
595     function transfer(address recipient, uint256 amount) public virtual returns (bool) {
596         _transfer(_msgSender(), recipient, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-allowance}.
602      */
603     function allowance(address owner, address spender) public view virtual override returns (uint256) {
604         return _allowances[owner][spender];
605     }
606 
607     /**
608      * @dev See {IERC20-approve}.
609      *
610      * Requirements:
611      *
612      * - `spender` cannot be the zero address.
613      */
614     function approve(address spender, uint256 amount) public virtual override returns (bool) {
615         _approve(_msgSender(), spender, amount);
616         return true;
617     }
618 
619   // See https://eips.ethereum.org/EIPS/eip-191
620     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
621     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
622     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
623 
624     /// @notice Approves `value` from `owner_` to be spend by `spender`.
625     /// @param owner_ Address of the owner.
626     /// @param spender The address of the spender that gets approved to draw from `owner_`.
627     /// @param value The maximum collective amount that `spender` can draw.
628     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
629     function permit(
630         address owner_,
631         address spender,
632         uint256 value,
633         uint256 deadline,
634         uint8 v,
635         bytes32 r,
636         bytes32 s
637     ) external override {
638         require(owner_ != address(0), "ERC20: Owner cannot be 0");
639         require(block.timestamp < deadline, "ERC20: Expired");
640         bytes32 digest =
641             keccak256(
642                 abi.encodePacked(
643                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
644                     DOMAIN_SEPARATOR,
645                     keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))
646                 )
647             );
648         address recoveredAddress = ecrecover(digest, v, r, s);
649         require(recoveredAddress == owner_, "ERC20: Invalid Signature");
650         _approve(_msgSender(), spender, value);
651 
652     }
653 
654     /**
655      * @dev See {IERC20-transferFrom}.
656      *
657      * Emits an {Approval} event indicating the updated allowance. This is not
658      * required by the EIP. See the note at the beginning of {ERC20};
659      *
660      * Requirements:
661      * - `sender` and `recipient` cannot be the zero address.
662      * - `sender` must have a balance of at least `amount`.
663      * - the caller must have allowance for ``sender``'s tokens of at least
664      * `amount`.
665      */
666     function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
667         _transfer(sender, recipient, amount);
668         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
669         return true;
670     }
671 
672     /**
673      * @dev Atomically increases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      */
684     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
685         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
686         return true;
687     }
688 
689     /**
690      * @dev Atomically decreases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      * - `spender` must have allowance for the caller of at least
701      * `subtractedValue`.
702      */
703     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
704         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
705         return true;
706     }
707 
708     /**
709      * @dev Moves tokens `amount` from `sender` to `recipient`.
710      *
711      * This is internal function is equivalent to {transfer}, and can be used to
712      * e.g. implement automatic token fees, slashing mechanisms, etc.
713      *
714      * Emits a {Transfer} event.
715      *
716      * Requirements:
717      *
718      * - `sender` cannot be the zero address.
719      * - `recipient` cannot be the zero address.
720      * - `sender` must have a balance of at least `amount`.
721      */
722     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
723         require(sender != address(0), "ERC20: transfer from the zero address");
724         require(recipient != address(0), "ERC20: transfer to the zero address");
725 
726         _beforeTokenTransfer(sender, recipient, amount);
727 
728         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
729         _balances[recipient] = _balances[recipient].add(amount);
730         emit Transfer(sender, recipient, amount);
731     }
732 
733     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
734      * the total supply.
735      *
736      * Emits a {Transfer} event with `from` set to the zero address.
737      *
738      * Requirements
739      *
740      * - `to` cannot be the zero address.
741      */
742     function _mint(address account, uint256 amount) internal virtual {
743         require(account != address(0), "ERC20: mint to the zero address");
744 
745         _beforeTokenTransfer(address(0), account, amount);
746 
747         _totalSupply = _totalSupply.add(amount);
748         _balances[account] = _balances[account].add(amount);
749         emit Transfer(address(0), account, amount);
750     }
751 
752     /**
753      * @dev Destroys `amount` tokens from `account`, reducing the
754      * total supply.
755      *
756      * Emits a {Transfer} event with `to` set to the zero address.
757      *
758      * Requirements
759      *
760      * - `account` cannot be the zero address.
761      * - `account` must have at least `amount` tokens.
762      */
763     function _burn(address account, uint256 amount) internal virtual {
764         require(account != address(0), "ERC20: burn from the zero address");
765 
766         _beforeTokenTransfer(account, address(0), amount);
767 
768         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
769         _totalSupply = _totalSupply.sub(amount);
770         emit Transfer(account, address(0), amount);
771     }
772 
773     /**
774      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
775      *
776      * This internal function is equivalent to `approve`, and can be used to
777      * e.g. set automatic allowances for certain subsystems, etc.
778      *
779      * Emits an {Approval} event.
780      *
781      * Requirements:
782      *
783      * - `owner` cannot be the zero address.
784      * - `spender` cannot be the zero address.
785      */
786     function _approve(address owner, address spender, uint256 amount) internal virtual {
787         require(owner != address(0), "ERC20: approve from the zero address");
788         require(spender != address(0), "ERC20: approve to the zero address");
789 
790         _allowances[owner][spender] = amount;
791         emit Approval(owner, spender, amount);
792     }
793 
794     /**
795      * @dev Sets {decimals} to a value other than the default one of 18.
796      *
797      * WARNING: This function should only be called from the constructor. Most
798      * applications that interact with token contracts will not expect
799      * {decimals} to ever change, and may work incorrectly if it does.
800      */
801     function _setupDecimals(uint8 decimals_) internal {
802         _decimals = decimals_;
803     }
804 
805     /**
806      * @dev Hook that is called before any transfer of tokens. This includes
807      * minting and burning.
808      *
809      * Calling conditions:
810      *
811      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
812      * will be to transferred to `to`.
813      * - when `from` is zero, `amount` tokens will be minted for `to`.
814      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
815      * - `from` and `to` are never both zero.
816      *
817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
818      */
819     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
820 }
821 
822 
823 // File contracts/interfaces/IMisoToken.sol
824 
825 pragma solidity 0.6.12;
826 
827 interface IMisoToken {
828     function init(bytes calldata data) external payable;
829     function initToken( bytes calldata data ) external;
830     function tokenTemplate() external view returns (uint256);
831 
832 }
833 
834 
835 // File contracts/OpenZeppelin/utils/EnumerableSet.sol
836 
837 pragma solidity 0.6.12;
838 
839 /**
840  * @dev Library for managing
841  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
842  * types.
843  *
844  * Sets have the following properties:
845  *
846  * - Elements are added, removed, and checked for existence in constant time
847  * (O(1)).
848  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
849  *
850  * ```
851  * contract Example {
852  *     // Add the library methods
853  *     using EnumerableSet for EnumerableSet.AddressSet;
854  *
855  *     // Declare a set state variable
856  *     EnumerableSet.AddressSet private mySet;
857  * }
858  * ```
859  *
860  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
861  * and `uint256` (`UintSet`) are supported.
862  */
863 library EnumerableSet {
864     // To implement this library for multiple types with as little code
865     // repetition as possible, we write it in terms of a generic Set type with
866     // bytes32 values.
867     // The Set implementation uses private functions, and user-facing
868     // implementations (such as AddressSet) are just wrappers around the
869     // underlying Set.
870     // This means that we can only create new EnumerableSets for types that fit
871     // in bytes32.
872 
873     struct Set {
874         // Storage of set values
875         bytes32[] _values;
876 
877         // Position of the value in the `values` array, plus 1 because index 0
878         // means a value is not in the set.
879         mapping (bytes32 => uint256) _indexes;
880     }
881 
882     /**
883      * @dev Add a value to a set. O(1).
884      *
885      * Returns true if the value was added to the set, that is if it was not
886      * already present.
887      */
888     function _add(Set storage set, bytes32 value) private returns (bool) {
889         if (!_contains(set, value)) {
890             set._values.push(value);
891             // The value is stored at length-1, but we add 1 to all indexes
892             // and use 0 as a sentinel value
893             set._indexes[value] = set._values.length;
894             return true;
895         } else {
896             return false;
897         }
898     }
899 
900     /**
901      * @dev Removes a value from a set. O(1).
902      *
903      * Returns true if the value was removed from the set, that is if it was
904      * present.
905      */
906     function _remove(Set storage set, bytes32 value) private returns (bool) {
907         // We read and store the value's index to prevent multiple reads from the same storage slot
908         uint256 valueIndex = set._indexes[value];
909 
910         if (valueIndex != 0) { // Equivalent to contains(set, value)
911             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
912             // the array, and then remove the last element (sometimes called as 'swap and pop').
913             // This modifies the order of the array, as noted in {at}.
914 
915             uint256 toDeleteIndex = valueIndex - 1;
916             uint256 lastIndex = set._values.length - 1;
917 
918             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
919             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
920 
921             bytes32 lastvalue = set._values[lastIndex];
922 
923             // Move the last value to the index where the value to delete is
924             set._values[toDeleteIndex] = lastvalue;
925             // Update the index for the moved value
926             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
927 
928             // Delete the slot where the moved value was stored
929             set._values.pop();
930 
931             // Delete the index for the deleted slot
932             delete set._indexes[value];
933 
934             return true;
935         } else {
936             return false;
937         }
938     }
939 
940     /**
941      * @dev Returns true if the value is in the set. O(1).
942      */
943     function _contains(Set storage set, bytes32 value) private view returns (bool) {
944         return set._indexes[value] != 0;
945     }
946 
947     /**
948      * @dev Returns the number of values on the set. O(1).
949      */
950     function _length(Set storage set) private view returns (uint256) {
951         return set._values.length;
952     }
953 
954    /**
955     * @dev Returns the value stored at position `index` in the set. O(1).
956     *
957     * Note that there are no guarantees on the ordering of values inside the
958     * array, and it may change when more values are added or removed.
959     *
960     * Requirements:
961     *
962     * - `index` must be strictly less than {length}.
963     */
964     function _at(Set storage set, uint256 index) private view returns (bytes32) {
965         require(set._values.length > index, "EnumerableSet: index out of bounds");
966         return set._values[index];
967     }
968 
969     // Bytes32Set
970 
971     struct Bytes32Set {
972         Set _inner;
973     }
974 
975     /**
976      * @dev Add a value to a set. O(1).
977      *
978      * Returns true if the value was added to the set, that is if it was not
979      * already present.
980      */
981     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
982         return _add(set._inner, value);
983     }
984 
985     /**
986      * @dev Removes a value from a set. O(1).
987      *
988      * Returns true if the value was removed from the set, that is if it was
989      * present.
990      */
991     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
992         return _remove(set._inner, value);
993     }
994 
995     /**
996      * @dev Returns true if the value is in the set. O(1).
997      */
998     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
999         return _contains(set._inner, value);
1000     }
1001 
1002     /**
1003      * @dev Returns the number of values in the set. O(1).
1004      */
1005     function length(Bytes32Set storage set) internal view returns (uint256) {
1006         return _length(set._inner);
1007     }
1008 
1009    /**
1010     * @dev Returns the value stored at position `index` in the set. O(1).
1011     *
1012     * Note that there are no guarantees on the ordering of values inside the
1013     * array, and it may change when more values are added or removed.
1014     *
1015     * Requirements:
1016     *
1017     * - `index` must be strictly less than {length}.
1018     */
1019     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1020         return _at(set._inner, index);
1021     }
1022 
1023     // AddressSet
1024 
1025     struct AddressSet {
1026         Set _inner;
1027     }
1028 
1029     /**
1030      * @dev Add a value to a set. O(1).
1031      *
1032      * Returns true if the value was added to the set, that is if it was not
1033      * already present.
1034      */
1035     function add(AddressSet storage set, address value) internal returns (bool) {
1036         return _add(set._inner, bytes32(uint256(uint160(value))));
1037     }
1038 
1039     /**
1040      * @dev Removes a value from a set. O(1).
1041      *
1042      * Returns true if the value was removed from the set, that is if it was
1043      * present.
1044      */
1045     function remove(AddressSet storage set, address value) internal returns (bool) {
1046         return _remove(set._inner, bytes32(uint256(uint160(value))));
1047     }
1048 
1049     /**
1050      * @dev Returns true if the value is in the set. O(1).
1051      */
1052     function contains(AddressSet storage set, address value) internal view returns (bool) {
1053         return _contains(set._inner, bytes32(uint256(uint160(value))));
1054     }
1055 
1056     /**
1057      * @dev Returns the number of values in the set. O(1).
1058      */
1059     function length(AddressSet storage set) internal view returns (uint256) {
1060         return _length(set._inner);
1061     }
1062 
1063    /**
1064     * @dev Returns the value stored at position `index` in the set. O(1).
1065     *
1066     * Note that there are no guarantees on the ordering of values inside the
1067     * array, and it may change when more values are added or removed.
1068     *
1069     * Requirements:
1070     *
1071     * - `index` must be strictly less than {length}.
1072     */
1073     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1074         return address(uint160(uint256(_at(set._inner, index))));
1075     }
1076 
1077 
1078     // UintSet
1079 
1080     struct UintSet {
1081         Set _inner;
1082     }
1083 
1084     /**
1085      * @dev Add a value to a set. O(1).
1086      *
1087      * Returns true if the value was added to the set, that is if it was not
1088      * already present.
1089      */
1090     function add(UintSet storage set, uint256 value) internal returns (bool) {
1091         return _add(set._inner, bytes32(value));
1092     }
1093 
1094     /**
1095      * @dev Removes a value from a set. O(1).
1096      *
1097      * Returns true if the value was removed from the set, that is if it was
1098      * present.
1099      */
1100     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1101         return _remove(set._inner, bytes32(value));
1102     }
1103 
1104     /**
1105      * @dev Returns true if the value is in the set. O(1).
1106      */
1107     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1108         return _contains(set._inner, bytes32(value));
1109     }
1110 
1111     /**
1112      * @dev Returns the number of values on the set. O(1).
1113      */
1114     function length(UintSet storage set) internal view returns (uint256) {
1115         return _length(set._inner);
1116     }
1117 
1118    /**
1119     * @dev Returns the value stored at position `index` in the set. O(1).
1120     *
1121     * Note that there are no guarantees on the ordering of values inside the
1122     * array, and it may change when more values are added or removed.
1123     *
1124     * Requirements:
1125     *
1126     * - `index` must be strictly less than {length}.
1127     */
1128     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1129         return uint256(_at(set._inner, index));
1130     }
1131 }
1132 
1133 
1134 // File contracts/OpenZeppelin/access/AccessControl.sol
1135 
1136 pragma solidity 0.6.12;
1137 
1138 
1139 
1140 /**
1141  * @dev Contract module that allows children to implement role-based access
1142  * control mechanisms.
1143  *
1144  * Roles are referred to by their `bytes32` identifier. These should be exposed
1145  * in the external API and be unique. The best way to achieve this is by
1146  * using `public constant` hash digests:
1147  *
1148  * ```
1149  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1150  * ```
1151  *
1152  * Roles can be used to represent a set of permissions. To restrict access to a
1153  * function call, use {hasRole}:
1154  *
1155  * ```
1156  * function foo() public {
1157  *     require(hasRole(MY_ROLE, msg.sender));
1158  *     ...
1159  * }
1160  * ```
1161  *
1162  * Roles can be granted and revoked dynamically via the {grantRole} and
1163  * {revokeRole} functions. Each role has an associated admin role, and only
1164  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1165  *
1166  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1167  * that only accounts with this role will be able to grant or revoke other
1168  * roles. More complex role relationships can be created by using
1169  * {_setRoleAdmin}.
1170  *
1171  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1172  * grant and revoke this role. Extra precautions should be taken to secure
1173  * accounts that have been granted it.
1174  */
1175 abstract contract AccessControl is Context {
1176     using EnumerableSet for EnumerableSet.AddressSet;
1177     using Address for address;
1178 
1179     struct RoleData {
1180         EnumerableSet.AddressSet members;
1181         bytes32 adminRole;
1182     }
1183 
1184     mapping (bytes32 => RoleData) private _roles;
1185 
1186     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1187 
1188     /**
1189      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1190      *
1191      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1192      * {RoleAdminChanged} not being emitted signaling this.
1193      *
1194      * _Available since v3.1._
1195      */
1196     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1197 
1198     /**
1199      * @dev Emitted when `account` is granted `role`.
1200      *
1201      * `sender` is the account that originated the contract call, an admin role
1202      * bearer except when using {_setupRole}.
1203      */
1204     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1205 
1206     /**
1207      * @dev Emitted when `account` is revoked `role`.
1208      *
1209      * `sender` is the account that originated the contract call:
1210      *   - if using `revokeRole`, it is the admin role bearer
1211      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1212      */
1213     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1214 
1215     /**
1216      * @dev Returns `true` if `account` has been granted `role`.
1217      */
1218     function hasRole(bytes32 role, address account) public view returns (bool) {
1219         return _roles[role].members.contains(account);
1220     }
1221 
1222     /**
1223      * @dev Returns the number of accounts that have `role`. Can be used
1224      * together with {getRoleMember} to enumerate all bearers of a role.
1225      */
1226     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1227         return _roles[role].members.length();
1228     }
1229 
1230     /**
1231      * @dev Returns one of the accounts that have `role`. `index` must be a
1232      * value between 0 and {getRoleMemberCount}, non-inclusive.
1233      *
1234      * Role bearers are not sorted in any particular way, and their ordering may
1235      * change at any point.
1236      *
1237      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1238      * you perform all queries on the same block. See the following
1239      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1240      * for more information.
1241      */
1242     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1243         return _roles[role].members.at(index);
1244     }
1245 
1246     /**
1247      * @dev Returns the admin role that controls `role`. See {grantRole} and
1248      * {revokeRole}.
1249      *
1250      * To change a role's admin, use {_setRoleAdmin}.
1251      */
1252     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1253         return _roles[role].adminRole;
1254     }
1255 
1256     /**
1257      * @dev Grants `role` to `account`.
1258      *
1259      * If `account` had not been already granted `role`, emits a {RoleGranted}
1260      * event.
1261      *
1262      * Requirements:
1263      *
1264      * - the caller must have ``role``'s admin role.
1265      */
1266     function grantRole(bytes32 role, address account) public virtual {
1267         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1268 
1269         _grantRole(role, account);
1270     }
1271 
1272     /**
1273      * @dev Revokes `role` from `account`.
1274      *
1275      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1276      *
1277      * Requirements:
1278      *
1279      * - the caller must have ``role``'s admin role.
1280      */
1281     function revokeRole(bytes32 role, address account) public virtual {
1282         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1283 
1284         _revokeRole(role, account);
1285     }
1286 
1287     /**
1288      * @dev Revokes `role` from the calling account.
1289      *
1290      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1291      * purpose is to provide a mechanism for accounts to lose their privileges
1292      * if they are compromised (such as when a trusted device is misplaced).
1293      *
1294      * If the calling account had been granted `role`, emits a {RoleRevoked}
1295      * event.
1296      *
1297      * Requirements:
1298      *
1299      * - the caller must be `account`.
1300      */
1301     function renounceRole(bytes32 role, address account) public virtual {
1302         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1303 
1304         _revokeRole(role, account);
1305     }
1306 
1307     /**
1308      * @dev Grants `role` to `account`.
1309      *
1310      * If `account` had not been already granted `role`, emits a {RoleGranted}
1311      * event. Note that unlike {grantRole}, this function doesn't perform any
1312      * checks on the calling account.
1313      *
1314      * [WARNING]
1315      * ====
1316      * This function should only be called from the constructor when setting
1317      * up the initial roles for the system.
1318      *
1319      * Using this function in any other way is effectively circumventing the admin
1320      * system imposed by {AccessControl}.
1321      * ====
1322      */
1323     function _setupRole(bytes32 role, address account) internal virtual {
1324         _grantRole(role, account);
1325     }
1326 
1327     /**
1328      * @dev Sets `adminRole` as ``role``'s admin role.
1329      *
1330      * Emits a {RoleAdminChanged} event.
1331      */
1332     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1333         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1334         _roles[role].adminRole = adminRole;
1335     }
1336 
1337     function _grantRole(bytes32 role, address account) private {
1338         if (_roles[role].members.add(account)) {
1339             emit RoleGranted(role, account, _msgSender());
1340         }
1341     }
1342 
1343     function _revokeRole(bytes32 role, address account) private {
1344         if (_roles[role].members.remove(account)) {
1345             emit RoleRevoked(role, account, _msgSender());
1346         }
1347     }
1348 }
1349 
1350 
1351 // File contracts/Tokens/SushiToken.sol
1352 
1353 pragma solidity 0.6.12;
1354 
1355 
1356 
1357 // ---------------------------------------------------------------------
1358 //
1359 // SushiToken with Governance.
1360 //
1361 // From the MISO Token Factory
1362 // Made for Sushi.com 
1363 // 
1364 // Enjoy. (c) Chef Gonpachi 2021 
1365 // <https://github.com/chefgonpachi/MISO/>
1366 //
1367 // ---------------------------------------------------------------------
1368 // SPDX-License-Identifier: GPL-3.0                        
1369 // ---------------------------------------------------------------------
1370 
1371 contract SushiToken is IMisoToken, AccessControl, ERC20 {
1372 
1373     /// @notice Miso template id for the token factory.
1374     /// @dev For different token types, this must be incremented.
1375     uint256 public constant override tokenTemplate = 3;
1376 
1377     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1378 
1379     function initToken(string memory _name, string memory _symbol, address _owner, uint256 _initialSupply) public {
1380         _initERC20(_name, _symbol);
1381         _setupRole(DEFAULT_ADMIN_ROLE, _owner);
1382         _setupRole(MINTER_ROLE, _owner);
1383         _mint(msg.sender, _initialSupply);
1384 
1385     }
1386 
1387     function init(bytes calldata _data) external override payable {}
1388 
1389     function initToken(
1390         bytes calldata _data
1391     ) public override {
1392         (string memory _name,
1393         string memory _symbol,
1394         address _owner,
1395         uint256 _initialSupply) = abi.decode(_data, (string, string, address, uint256));
1396 
1397         initToken(_name,_symbol,_owner,_initialSupply);
1398     }
1399 
1400    /** 
1401      * @dev Generates init data for Token Factory
1402      * @param _name - Token name
1403      * @param _symbol - Token symbol
1404      * @param _owner - Contract owner
1405      * @param _initialSupply Amount of tokens minted on creation
1406   */
1407     function getInitData(
1408         string calldata _name,
1409         string calldata _symbol,
1410         address _owner,
1411         uint256 _initialSupply
1412     )
1413         external
1414         pure
1415         returns (bytes memory _data)
1416     {
1417         return abi.encode(_name, _symbol, _owner, _initialSupply);
1418     }
1419 
1420 
1421     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1422     function mint(address _to, uint256 _amount) public  {
1423         require(hasRole(MINTER_ROLE, _msgSender()), "SushiToken: must have minter role to mint");
1424         _mint(_to, _amount);
1425         _moveDelegates(address(0), _delegates[_to], _amount);
1426     }
1427 
1428     // Copied and modified from YAM code:
1429     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1430     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1431     // Which is copied and modified from COMPOUND:
1432     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1433 
1434     /// @notice A record of each accounts delegate
1435     mapping (address => address) internal _delegates;
1436 
1437     /// @notice A checkpoint for marking number of votes from a given block
1438     struct Checkpoint {
1439         uint32 fromBlock;
1440         uint256 votes;
1441     }
1442 
1443     /// @notice A record of votes checkpoints for each account, by index
1444     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1445 
1446     /// @notice The number of checkpoints for each account
1447     mapping (address => uint32) public numCheckpoints;
1448 
1449     /// @notice The EIP-712 typehash for the contract's domain
1450     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1451 
1452     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1453     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1454 
1455     /// @notice A record of states for signing / validating signatures
1456     mapping (address => uint) public sigNonces;
1457 
1458       /// @notice An event thats emitted when an account changes its delegate
1459     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1460 
1461     /// @notice An event thats emitted when a delegate account's vote balance changes
1462     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1463 
1464     /**
1465      * @notice Delegate votes from `msg.sender` to `delegatee`
1466      * @param delegator The address to get delegatee for
1467      */
1468     function delegates(address delegator)
1469         external
1470         view
1471         returns (address)
1472     {
1473         return _delegates[delegator];
1474     }
1475 
1476    /**
1477     * @notice Delegate votes from `msg.sender` to `delegatee`
1478     * @param delegatee The address to delegate votes to
1479     */
1480     function delegate(address delegatee) external {
1481         return _delegate(msg.sender, delegatee);
1482     }
1483 
1484     /**
1485      * @notice Delegates votes from signatory to `delegatee`
1486      * @param delegatee The address to delegate votes to
1487      * @param nonce The contract state required to match the signature
1488      * @param expiry The time at which to expire the signature
1489      * @param v The recovery byte of the signature
1490      * @param r Half of the ECDSA signature pair
1491      * @param s Half of the ECDSA signature pair
1492      */
1493     function delegateBySig(
1494         address delegatee,
1495         uint nonce,
1496         uint expiry,
1497         uint8 v,
1498         bytes32 r,
1499         bytes32 s
1500     )
1501         external
1502     {
1503         bytes32 domainSeparator = keccak256(
1504             abi.encode(
1505                 DOMAIN_TYPEHASH,
1506                 keccak256(bytes(name())),
1507                 getChainId(),
1508                 address(this)
1509             )
1510         );
1511 
1512         bytes32 structHash = keccak256(
1513             abi.encode(
1514                 DELEGATION_TYPEHASH,
1515                 delegatee,
1516                 nonce,
1517                 expiry
1518             )
1519         );
1520 
1521         bytes32 digest = keccak256(
1522             abi.encodePacked(
1523                 "\x19\x01",
1524                 domainSeparator,
1525                 structHash
1526             )
1527         );
1528 
1529         address signatory = ecrecover(digest, v, r, s);
1530         require(signatory != address(0), "SUSHI::delegateBySig: invalid signature");
1531         require(nonce == sigNonces[signatory]++, "SUSHI::delegateBySig: invalid nonce");
1532         require(now <= expiry, "SUSHI::delegateBySig: signature expired");
1533         return _delegate(signatory, delegatee);
1534     }
1535 
1536     /**
1537      * @notice Gets the current votes balance for `account`
1538      * @param account The address to get votes balance
1539      * @return The number of current votes for `account`
1540      */
1541     function getCurrentVotes(address account)
1542         external
1543         view
1544         returns (uint256)
1545     {
1546         uint32 nCheckpoints = numCheckpoints[account];
1547         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1548     }
1549 
1550     /**
1551      * @notice Determine the prior number of votes for an account as of a block number
1552      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1553      * @param account The address of the account to check
1554      * @param blockNumber The block number to get the vote balance at
1555      * @return The number of votes the account had as of the given block
1556      */
1557     function getPriorVotes(address account, uint blockNumber)
1558         external
1559         view
1560         returns (uint256)
1561     {
1562         require(blockNumber < block.number, "SUSHI::getPriorVotes: not yet determined");
1563 
1564         uint32 nCheckpoints = numCheckpoints[account];
1565         if (nCheckpoints == 0) {
1566             return 0;
1567         }
1568 
1569         // First check most recent balance
1570         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1571             return checkpoints[account][nCheckpoints - 1].votes;
1572         }
1573 
1574         // Next check implicit zero balance
1575         if (checkpoints[account][0].fromBlock > blockNumber) {
1576             return 0;
1577         }
1578 
1579         uint32 lower = 0;
1580         uint32 upper = nCheckpoints - 1;
1581         while (upper > lower) {
1582             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1583             Checkpoint memory cp = checkpoints[account][center];
1584             if (cp.fromBlock == blockNumber) {
1585                 return cp.votes;
1586             } else if (cp.fromBlock < blockNumber) {
1587                 lower = center;
1588             } else {
1589                 upper = center - 1;
1590             }
1591         }
1592         return checkpoints[account][lower].votes;
1593     }
1594 
1595     function _delegate(address delegator, address delegatee)
1596         internal
1597     {
1598         address currentDelegate = _delegates[delegator];
1599         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
1600         _delegates[delegator] = delegatee;
1601 
1602         emit DelegateChanged(delegator, currentDelegate, delegatee);
1603 
1604         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1605     }
1606 
1607     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1608         if (srcRep != dstRep && amount > 0) {
1609             if (srcRep != address(0)) {
1610                 // decrease old representative
1611                 uint32 srcRepNum = numCheckpoints[srcRep];
1612                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1613                 uint256 srcRepNew = srcRepOld.sub(amount);
1614                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1615             }
1616 
1617             if (dstRep != address(0)) {
1618                 // increase new representative
1619                 uint32 dstRepNum = numCheckpoints[dstRep];
1620                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1621                 uint256 dstRepNew = dstRepOld.add(amount);
1622                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1623             }
1624         }
1625     }
1626 
1627     function _writeCheckpoint(
1628         address delegatee,
1629         uint32 nCheckpoints,
1630         uint256 oldVotes,
1631         uint256 newVotes
1632     )
1633         internal
1634     {
1635         uint32 blockNumber = safe32(block.number, "SUSHI::_writeCheckpoint: block number exceeds 32 bits");
1636 
1637         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1638             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1639         } else {
1640             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1641             numCheckpoints[delegatee] = nCheckpoints + 1;
1642         }
1643 
1644         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1645     }
1646 
1647     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1648         require(n < 2**32, errorMessage);
1649         return uint32(n);
1650     }
1651 
1652     function getChainId() internal pure returns (uint) {
1653         uint256 chainId;
1654         assembly { chainId := chainid() }
1655         return chainId;
1656     }
1657 }
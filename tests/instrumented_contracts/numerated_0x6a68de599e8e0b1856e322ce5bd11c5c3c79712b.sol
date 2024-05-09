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
835 // File contracts/Tokens/FixedToken.sol
836 
837 pragma solidity 0.6.12;
838 
839 
840 // ---------------------------------------------------------------------
841 //
842 // From the MISO Token Factory
843 //
844 // Made for Sushi.com 
845 // 
846 // Enjoy. (c) Chef Gonpachi 2021 
847 // <https://github.com/chefgonpachi/MISO/>
848 //
849 // ---------------------------------------------------------------------
850 // SPDX-License-Identifier: GPL-3.0                        
851 // ---------------------------------------------------------------------
852 
853 contract FixedToken is ERC20, IMisoToken {
854 
855     /// @notice Miso template id for the token factory.
856     /// @dev For different token types, this must be incremented.
857     uint256 public constant override tokenTemplate = 1;
858     
859     /// @dev First set the token variables. This can only be done once
860     function initToken(string memory _name, string memory _symbol, address _owner, uint256 _initialSupply) public  {
861         _initERC20(_name, _symbol);
862         _mint(msg.sender, _initialSupply);
863     }
864     function init(bytes calldata _data) external override payable {}
865 
866    function initToken(
867         bytes calldata _data
868     ) public override {
869         (string memory _name,
870         string memory _symbol,
871         address _owner,
872         uint256 _initialSupply) = abi.decode(_data, (string, string, address, uint256));
873 
874         initToken(_name,_symbol,_owner,_initialSupply);
875     }
876 
877    /** 
878      * @dev Generates init data for Farm Factory
879      * @param _name - Token name
880      * @param _symbol - Token symbol
881      * @param _owner - Contract owner
882      * @param _initialSupply Amount of tokens minted on creation
883   */
884     function getInitData(
885         string calldata _name,
886         string calldata _symbol,
887         address _owner,
888         uint256 _initialSupply
889     )
890         external
891         pure
892         returns (bytes memory _data)
893     {
894         return abi.encode(_name, _symbol, _owner, _initialSupply);
895     }
896 
897 
898 }
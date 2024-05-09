1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if `account` is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, `isContract` will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      */
47     function isContract(address account) internal view returns (bool) {
48         // This method relies on extcodesize, which returns 0 for contracts in
49         // construction, since the code is only stored at the end of the
50         // constructor execution.
51 
52         uint256 size;
53         // solhint-disable-next-line no-inline-assembly
54         assembly {
55             size := extcodesize(account)
56         }
57         return size > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62      * `recipient`, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by `transfer`, making them unable to receive funds via
67      * `transfer`. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to `recipient`, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
80         (bool success, ) = recipient.call{value: amount}("");
81         require(success, "Address: unable to send value, recipient may have reverted");
82     }
83 
84     /**
85      * @dev Performs a Solidity function call using a low level `call`. A
86      * plain`call` is an unsafe replacement for a function call: use this
87      * function instead.
88      *
89      * If `target` reverts with a revert reason, it is bubbled up by this
90      * function (like regular Solidity function calls).
91      *
92      * Returns the raw returned data. To convert to the expected return value,
93      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
94      *
95      * Requirements:
96      *
97      * - `target` must be a contract.
98      * - calling `target` with `data` must not revert.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
108      * `errorMessage` as a fallback revert reason when `target` reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
122      * but also transferring `value` wei to `target`.
123      *
124      * Requirements:
125      *
126      * - the calling contract must have an ETH balance of at least `value`.
127      * - the called Solidity function must be `payable`.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
141      * with `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         // solhint-disable-next-line avoid-low-level-calls
155         (bool success, bytes memory returndata) = target.call{value: value}(data);
156         return _verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
166         return functionStaticCall(target, data, "Address: low-level static call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
171      * but performing a static call.
172      *
173      * _Available since v3.3._
174      */
175     function functionStaticCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal view returns (bytes memory) {
180         require(isContract(target), "Address: static call to non-contract");
181 
182         // solhint-disable-next-line avoid-low-level-calls
183         (bool success, bytes memory returndata) = target.staticcall(data);
184         return _verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     function _verifyCallResult(
188         bool success,
189         bytes memory returndata,
190         string memory errorMessage
191     ) private pure returns (bytes memory) {
192         if (success) {
193             return returndata;
194         } else {
195             // Look for revert reason and bubble it up if present
196             if (returndata.length > 0) {
197                 // The easiest way to bubble the revert reason is using memory via assembly
198 
199                 // solhint-disable-next-line no-inline-assembly
200                 assembly {
201                     let returndata_size := mload(returndata)
202                     revert(add(32, returndata), returndata_size)
203                 }
204             } else {
205                 revert(errorMessage);
206             }
207         }
208     }
209 }
210 
211 // a facade for prices fetch from oracles
212 interface LnPrices {
213     // get price for a currency
214     function getPrice(bytes32 currencyName) external view returns (uint);
215 
216     // get price and updated time for a currency
217     function getPriceAndUpdatedTime(bytes32 currencyName) external view returns (uint price, uint time);
218 
219     // is the price is stale
220     function isStale(bytes32 currencyName) external view returns (bool);
221 
222     // the defined stale time
223     function stalePeriod() external view returns (uint);
224 
225     // exchange amount of source currenty for some dest currency, also get source and dest curreny price
226     function exchange(
227         bytes32 sourceName,
228         uint sourceAmount,
229         bytes32 destName
230     ) external view returns (uint);
231 
232     // exchange amount of source currenty for some dest currency
233     function exchangeAndPrices(
234         bytes32 sourceName,
235         uint sourceAmount,
236         bytes32 destName
237     )
238         external
239         view
240         returns (
241             uint value,
242             uint sourcePrice,
243             uint destPrice
244         );
245 
246     // price names
247     function LUSD() external view returns (bytes32);
248 
249     function LINA() external view returns (bytes32);
250 }
251 
252 abstract contract LnBasePrices is LnPrices {
253     // const name
254     bytes32 public constant override LINA = "LINA";
255     bytes32 public constant override LUSD = "lUSD";
256 }
257 
258 contract LnAdmin {
259     address public admin;
260     address public candidate;
261 
262     constructor(address _admin) public {
263         require(_admin != address(0), "admin address cannot be 0");
264         admin = _admin;
265         emit AdminChanged(address(0), _admin);
266     }
267 
268     function setCandidate(address _candidate) external onlyAdmin {
269         address old = candidate;
270         candidate = _candidate;
271         emit CandidateChanged(old, candidate);
272     }
273 
274     function becomeAdmin() external {
275         require(msg.sender == candidate, "Only candidate can become admin");
276         address old = admin;
277         admin = candidate;
278         emit AdminChanged(old, admin);
279     }
280 
281     modifier onlyAdmin {
282         require((msg.sender == admin), "Only the contract admin can perform this action");
283         _;
284     }
285 
286     event CandidateChanged(address oldCandidate, address newCandidate);
287     event AdminChanged(address oldAdmin, address newAdmin);
288 }
289 
290 interface IERC20 {
291     function name() external view returns (string memory);
292 
293     function symbol() external view returns (string memory);
294 
295     function decimals() external view returns (uint8);
296 
297     function totalSupply() external view returns (uint);
298 
299     function balanceOf(address owner) external view returns (uint);
300 
301     function allowance(address owner, address spender) external view returns (uint);
302 
303     function transfer(address to, uint value) external returns (bool);
304 
305     function approve(address spender, uint value) external returns (bool);
306 
307     function transferFrom(
308         address from,
309         address to,
310         uint value
311     ) external returns (bool);
312 
313     event Transfer(address indexed from, address indexed to, uint value);
314 
315     event Approval(address indexed owner, address indexed spender, uint value);
316 }
317 
318 // solhint-disable-next-line compiler-version
319 
320 /**
321  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
322  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
323  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
324  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
325  *
326  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
327  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
328  *
329  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
330  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
331  */
332 abstract contract Initializable {
333     /**
334      * @dev Indicates that the contract has been initialized.
335      */
336     bool private _initialized;
337 
338     /**
339      * @dev Indicates that the contract is in the process of being initialized.
340      */
341     bool private _initializing;
342 
343     /**
344      * @dev Modifier to protect an initializer function from being invoked twice.
345      */
346     modifier initializer() {
347         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
348 
349         bool isTopLevelCall = !_initializing;
350         if (isTopLevelCall) {
351             _initializing = true;
352             _initialized = true;
353         }
354 
355         _;
356 
357         if (isTopLevelCall) {
358             _initializing = false;
359         }
360     }
361 
362     /// @dev Returns true if and only if the function is running in the constructor
363     function _isConstructor() private view returns (bool) {
364         // extcodesize checks the size of the code stored in an address, and
365         // address returns the current address. Since the code is still not
366         // deployed when running a constructor, any checks on its code size will
367         // yield zero, making it an effective way to detect if a contract is
368         // under construction or not.
369         address self = address(this);
370         uint256 cs;
371         // solhint-disable-next-line no-inline-assembly
372         assembly {
373             cs := extcodesize(self)
374         }
375         return cs == 0;
376     }
377 }
378 
379 /*
380  * @dev Provides information about the current execution context, including the
381  * sender of the transaction and its data. While these are generally available
382  * via msg.sender and msg.data, they should not be accessed in such a direct
383  * manner, since when dealing with GSN meta-transactions the account sending and
384  * paying for execution may not be the actual sender (as far as an application
385  * is concerned).
386  *
387  * This contract is only required for intermediate, library-like contracts.
388  */
389 abstract contract ContextUpgradeable is Initializable {
390     function __Context_init() internal initializer {
391         __Context_init_unchained();
392     }
393 
394     function __Context_init_unchained() internal initializer {}
395 
396     function _msgSender() internal view virtual returns (address payable) {
397         return msg.sender;
398     }
399 
400     function _msgData() internal view virtual returns (bytes memory) {
401         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
402         return msg.data;
403     }
404 
405     uint256[50] private __gap;
406 }
407 
408 contract LnConfig is LnAdmin {
409     mapping(bytes32 => uint) internal mUintConfig;
410 
411     constructor(address _admin) public LnAdmin(_admin) {}
412 
413     //some configue keys
414     bytes32 public constant BUILD_RATIO = "BuildRatio"; // percent, base 10e18
415 
416     function getUint(bytes32 key) external view returns (uint) {
417         return mUintConfig[key];
418     }
419 
420     function setUint(bytes32 key, uint value) external onlyAdmin {
421         mUintConfig[key] = value;
422         emit SetUintConfig(key, value);
423     }
424 
425     function deleteUint(bytes32 key) external onlyAdmin {
426         delete mUintConfig[key];
427         emit SetUintConfig(key, 0);
428     }
429 
430     function batchSet(bytes32[] calldata names, uint[] calldata values) external onlyAdmin {
431         require(names.length == values.length, "Input lengths must match");
432 
433         for (uint i = 0; i < names.length; i++) {
434             mUintConfig[names[i]] = values[i];
435             emit SetUintConfig(names[i], values[i]);
436         }
437     }
438 
439     event SetUintConfig(bytes32 key, uint value);
440 }
441 
442 /**
443  * @title LnAdminUpgradeable
444  *
445  * @dev This is an upgradeable version of `LnAdmin` by replacing the constructor with
446  * an initializer and reserving storage slots.
447  */
448 contract LnAdminUpgradeable is Initializable {
449     event CandidateChanged(address oldCandidate, address newCandidate);
450     event AdminChanged(address oldAdmin, address newAdmin);
451 
452     address public admin;
453     address public candidate;
454 
455     function __LnAdminUpgradeable_init(address _admin) public initializer {
456         require(_admin != address(0), "LnAdminUpgradeable: zero address");
457         admin = _admin;
458         emit AdminChanged(address(0), _admin);
459     }
460 
461     function setCandidate(address _candidate) external onlyAdmin {
462         address old = candidate;
463         candidate = _candidate;
464         emit CandidateChanged(old, candidate);
465     }
466 
467     function becomeAdmin() external {
468         require(msg.sender == candidate, "LnAdminUpgradeable: only candidate can become admin");
469         address old = admin;
470         admin = candidate;
471         emit AdminChanged(old, admin);
472     }
473 
474     modifier onlyAdmin {
475         require((msg.sender == admin), "LnAdminUpgradeable: only the contract admin can perform this action");
476         _;
477     }
478 
479     // Reserved storage space to allow for layout changes in the future.
480     uint256[48] private __gap;
481 }
482 
483 interface IAsset {
484     function keyName() external view returns (bytes32);
485 }
486 
487 library SafeDecimalMath {
488     using SafeMath for uint;
489 
490     uint8 public constant decimals = 18;
491     uint8 public constant highPrecisionDecimals = 27;
492 
493     uint public constant UNIT = 10**uint(decimals);
494 
495     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
496     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
497 
498     function unit() external pure returns (uint) {
499         return UNIT;
500     }
501 
502     function preciseUnit() external pure returns (uint) {
503         return PRECISE_UNIT;
504     }
505 
506     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
507         return x.mul(y) / UNIT;
508     }
509 
510     function _multiplyDecimalRound(
511         uint x,
512         uint y,
513         uint precisionUnit
514     ) private pure returns (uint) {
515         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
516 
517         if (quotientTimesTen % 10 >= 5) {
518             quotientTimesTen += 10;
519         }
520 
521         return quotientTimesTen / 10;
522     }
523 
524     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
525         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
526     }
527 
528     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
529         return _multiplyDecimalRound(x, y, UNIT);
530     }
531 
532     function divideDecimal(uint x, uint y) internal pure returns (uint) {
533         return x.mul(UNIT).div(y);
534     }
535 
536     function _divideDecimalRound(
537         uint x,
538         uint y,
539         uint precisionUnit
540     ) private pure returns (uint) {
541         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
542 
543         if (resultTimesTen % 10 >= 5) {
544             resultTimesTen += 10;
545         }
546 
547         return resultTimesTen / 10;
548     }
549 
550     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
551         return _divideDecimalRound(x, y, UNIT);
552     }
553 
554     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
555         return _divideDecimalRound(x, y, PRECISE_UNIT);
556     }
557 
558     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
559         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
560     }
561 
562     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
563         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
564 
565         if (quotientTimesTen % 10 >= 5) {
566             quotientTimesTen += 10;
567         }
568 
569         return quotientTimesTen / 10;
570     }
571 }
572 
573 /**
574  * @dev Wrappers over Solidity's arithmetic operations with added overflow
575  * checks.
576  *
577  * Arithmetic operations in Solidity wrap on overflow. This can easily result
578  * in bugs, because programmers usually assume that an overflow raises an
579  * error, which is the standard behavior in high level programming languages.
580  * `SafeMath` restores this intuition by reverting the transaction when an
581  * operation overflows.
582  *
583  * Using this library instead of the unchecked operations eliminates an entire
584  * class of bugs, so it's recommended to use it always.
585  */
586 library SafeMath {
587     /**
588      * @dev Returns the addition of two unsigned integers, reverting on
589      * overflow.
590      *
591      * Counterpart to Solidity's `+` operator.
592      *
593      * Requirements:
594      *
595      * - Addition cannot overflow.
596      */
597     function add(uint256 a, uint256 b) internal pure returns (uint256) {
598         uint256 c = a + b;
599         require(c >= a, "SafeMath: addition overflow");
600 
601         return c;
602     }
603 
604     /**
605      * @dev Returns the subtraction of two unsigned integers, reverting on
606      * overflow (when the result is negative).
607      *
608      * Counterpart to Solidity's `-` operator.
609      *
610      * Requirements:
611      *
612      * - Subtraction cannot overflow.
613      */
614     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
615         return sub(a, b, "SafeMath: subtraction overflow");
616     }
617 
618     /**
619      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
620      * overflow (when the result is negative).
621      *
622      * Counterpart to Solidity's `-` operator.
623      *
624      * Requirements:
625      *
626      * - Subtraction cannot overflow.
627      */
628     function sub(
629         uint256 a,
630         uint256 b,
631         string memory errorMessage
632     ) internal pure returns (uint256) {
633         require(b <= a, errorMessage);
634         uint256 c = a - b;
635 
636         return c;
637     }
638 
639     /**
640      * @dev Returns the multiplication of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `*` operator.
644      *
645      * Requirements:
646      *
647      * - Multiplication cannot overflow.
648      */
649     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
650         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
651         // benefit is lost if 'b' is also tested.
652         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
653         if (a == 0) {
654             return 0;
655         }
656 
657         uint256 c = a * b;
658         require(c / a == b, "SafeMath: multiplication overflow");
659 
660         return c;
661     }
662 
663     /**
664      * @dev Returns the integer division of two unsigned integers. Reverts on
665      * division by zero. The result is rounded towards zero.
666      *
667      * Counterpart to Solidity's `/` operator. Note: this function uses a
668      * `revert` opcode (which leaves remaining gas untouched) while Solidity
669      * uses an invalid opcode to revert (consuming all remaining gas).
670      *
671      * Requirements:
672      *
673      * - The divisor cannot be zero.
674      */
675     function div(uint256 a, uint256 b) internal pure returns (uint256) {
676         return div(a, b, "SafeMath: division by zero");
677     }
678 
679     /**
680      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
681      * division by zero. The result is rounded towards zero.
682      *
683      * Counterpart to Solidity's `/` operator. Note: this function uses a
684      * `revert` opcode (which leaves remaining gas untouched) while Solidity
685      * uses an invalid opcode to revert (consuming all remaining gas).
686      *
687      * Requirements:
688      *
689      * - The divisor cannot be zero.
690      */
691     function div(
692         uint256 a,
693         uint256 b,
694         string memory errorMessage
695     ) internal pure returns (uint256) {
696         require(b > 0, errorMessage);
697         uint256 c = a / b;
698         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
699 
700         return c;
701     }
702 
703     /**
704      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
705      * Reverts when dividing by zero.
706      *
707      * Counterpart to Solidity's `%` operator. This function uses a `revert`
708      * opcode (which leaves remaining gas untouched) while Solidity uses an
709      * invalid opcode to revert (consuming all remaining gas).
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
716         return mod(a, b, "SafeMath: modulo by zero");
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * Reverts with custom message when dividing by zero.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(
732         uint256 a,
733         uint256 b,
734         string memory errorMessage
735     ) internal pure returns (uint256) {
736         require(b != 0, errorMessage);
737         return a % b;
738     }
739 }
740 
741 /**
742  * @dev Contract module which allows children to implement an emergency stop
743  * mechanism that can be triggered by an authorized account.
744  *
745  * This module is used through inheritance. It will make available the
746  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
747  * the functions of your contract. Note that they will not be pausable by
748  * simply including this module, only once the modifiers are put in place.
749  */
750 abstract contract Pausable is Context {
751     /**
752      * @dev Emitted when the pause is triggered by `account`.
753      */
754     event Paused(address account);
755 
756     /**
757      * @dev Emitted when the pause is lifted by `account`.
758      */
759     event Unpaused(address account);
760 
761     bool private _paused;
762 
763     /**
764      * @dev Initializes the contract in unpaused state.
765      */
766     constructor() internal {
767         _paused = false;
768     }
769 
770     /**
771      * @dev Returns true if the contract is paused, and false otherwise.
772      */
773     function paused() public view returns (bool) {
774         return _paused;
775     }
776 
777     /**
778      * @dev Modifier to make a function callable only when the contract is not paused.
779      *
780      * Requirements:
781      *
782      * - The contract must not be paused.
783      */
784     modifier whenNotPaused() {
785         require(!_paused, "Pausable: paused");
786         _;
787     }
788 
789     /**
790      * @dev Modifier to make a function callable only when the contract is paused.
791      *
792      * Requirements:
793      *
794      * - The contract must be paused.
795      */
796     modifier whenPaused() {
797         require(_paused, "Pausable: not paused");
798         _;
799     }
800 
801     /**
802      * @dev Triggers stopped state.
803      *
804      * Requirements:
805      *
806      * - The contract must not be paused.
807      */
808     function _pause() internal virtual whenNotPaused {
809         _paused = true;
810         emit Paused(_msgSender());
811     }
812 
813     /**
814      * @dev Returns to normal state.
815      *
816      * Requirements:
817      *
818      * - The contract must be paused.
819      */
820     function _unpause() internal virtual whenPaused {
821         _paused = false;
822         emit Unpaused(_msgSender());
823     }
824 }
825 
826 contract LnAddressStorage is LnAdmin {
827     mapping(bytes32 => address) public mAddrs;
828 
829     constructor(address _admin) public LnAdmin(_admin) {}
830 
831     function updateAll(bytes32[] calldata names, address[] calldata destinations) external onlyAdmin {
832         require(names.length == destinations.length, "Input lengths must match");
833 
834         for (uint i = 0; i < names.length; i++) {
835             mAddrs[names[i]] = destinations[i];
836             emit StorageAddressUpdated(names[i], destinations[i]);
837         }
838     }
839 
840     function update(bytes32 name, address dest) external onlyAdmin {
841         require(name != "", "name can not be empty");
842         require(dest != address(0), "address cannot be 0");
843         mAddrs[name] = dest;
844         emit StorageAddressUpdated(name, dest);
845     }
846 
847     function getAddress(bytes32 name) external view returns (address) {
848         return mAddrs[name];
849     }
850 
851     function getAddressWithRequire(bytes32 name, string calldata reason) external view returns (address) {
852         address _foundAddress = mAddrs[name];
853         require(_foundAddress != address(0), reason);
854         return _foundAddress;
855     }
856 
857     event StorageAddressUpdated(bytes32 name, address addr);
858 }
859 
860 interface LnAddressCache {
861     function updateAddressCache(LnAddressStorage _addressStorage) external;
862 
863     event CachedAddressUpdated(bytes32 name, address addr);
864 }
865 
866 contract testAddressCache is LnAddressCache, LnAdmin {
867     address public addr1;
868     address public addr2;
869 
870     constructor(address _admin) public LnAdmin(_admin) {}
871 
872     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
873         addr1 = LnAddressStorage(_addressStorage).getAddressWithRequire("a", "");
874         addr2 = LnAddressStorage(_addressStorage).getAddressWithRequire("b", "");
875         emit CachedAddressUpdated("a", addr1);
876         emit CachedAddressUpdated("b", addr2);
877     }
878 }
879 
880 /**
881  * @dev Interface of the ERC20 standard as defined in the EIP.
882  */
883 interface IERC20Upgradeable {
884     /**
885      * @dev Returns the amount of tokens in existence.
886      */
887     function totalSupply() external view returns (uint256);
888 
889     /**
890      * @dev Returns the amount of tokens owned by `account`.
891      */
892     function balanceOf(address account) external view returns (uint256);
893 
894     /**
895      * @dev Moves `amount` tokens from the caller's account to `recipient`.
896      *
897      * Returns a boolean value indicating whether the operation succeeded.
898      *
899      * Emits a {Transfer} event.
900      */
901     function transfer(address recipient, uint256 amount) external returns (bool);
902 
903     /**
904      * @dev Returns the remaining number of tokens that `spender` will be
905      * allowed to spend on behalf of `owner` through {transferFrom}. This is
906      * zero by default.
907      *
908      * This value changes when {approve} or {transferFrom} are called.
909      */
910     function allowance(address owner, address spender) external view returns (uint256);
911 
912     /**
913      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
914      *
915      * Returns a boolean value indicating whether the operation succeeded.
916      *
917      * IMPORTANT: Beware that changing an allowance with this method brings the risk
918      * that someone may use both the old and the new allowance by unfortunate
919      * transaction ordering. One possible solution to mitigate this race
920      * condition is to first reduce the spender's allowance to 0 and set the
921      * desired value afterwards:
922      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
923      *
924      * Emits an {Approval} event.
925      */
926     function approve(address spender, uint256 amount) external returns (bool);
927 
928     /**
929      * @dev Moves `amount` tokens from `sender` to `recipient` using the
930      * allowance mechanism. `amount` is then deducted from the caller's
931      * allowance.
932      *
933      * Returns a boolean value indicating whether the operation succeeded.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address sender,
939         address recipient,
940         uint256 amount
941     ) external returns (bool);
942 
943     /**
944      * @dev Emitted when `value` tokens are moved from one account (`from`) to
945      * another (`to`).
946      *
947      * Note that `value` may be zero.
948      */
949     event Transfer(address indexed from, address indexed to, uint256 value);
950 
951     /**
952      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
953      * a call to {approve}. `value` is the new allowance.
954      */
955     event Approval(address indexed owner, address indexed spender, uint256 value);
956 }
957 
958 /**
959  * @dev Wrappers over Solidity's arithmetic operations with added overflow
960  * checks.
961  *
962  * Arithmetic operations in Solidity wrap on overflow. This can easily result
963  * in bugs, because programmers usually assume that an overflow raises an
964  * error, which is the standard behavior in high level programming languages.
965  * `SafeMath` restores this intuition by reverting the transaction when an
966  * operation overflows.
967  *
968  * Using this library instead of the unchecked operations eliminates an entire
969  * class of bugs, so it's recommended to use it always.
970  */
971 library SafeMathUpgradeable {
972     /**
973      * @dev Returns the addition of two unsigned integers, reverting on
974      * overflow.
975      *
976      * Counterpart to Solidity's `+` operator.
977      *
978      * Requirements:
979      *
980      * - Addition cannot overflow.
981      */
982     function add(uint256 a, uint256 b) internal pure returns (uint256) {
983         uint256 c = a + b;
984         require(c >= a, "SafeMath: addition overflow");
985 
986         return c;
987     }
988 
989     /**
990      * @dev Returns the subtraction of two unsigned integers, reverting on
991      * overflow (when the result is negative).
992      *
993      * Counterpart to Solidity's `-` operator.
994      *
995      * Requirements:
996      *
997      * - Subtraction cannot overflow.
998      */
999     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1000         return sub(a, b, "SafeMath: subtraction overflow");
1001     }
1002 
1003     /**
1004      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1005      * overflow (when the result is negative).
1006      *
1007      * Counterpart to Solidity's `-` operator.
1008      *
1009      * Requirements:
1010      *
1011      * - Subtraction cannot overflow.
1012      */
1013     function sub(
1014         uint256 a,
1015         uint256 b,
1016         string memory errorMessage
1017     ) internal pure returns (uint256) {
1018         require(b <= a, errorMessage);
1019         uint256 c = a - b;
1020 
1021         return c;
1022     }
1023 
1024     /**
1025      * @dev Returns the multiplication of two unsigned integers, reverting on
1026      * overflow.
1027      *
1028      * Counterpart to Solidity's `*` operator.
1029      *
1030      * Requirements:
1031      *
1032      * - Multiplication cannot overflow.
1033      */
1034     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1035         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1036         // benefit is lost if 'b' is also tested.
1037         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1038         if (a == 0) {
1039             return 0;
1040         }
1041 
1042         uint256 c = a * b;
1043         require(c / a == b, "SafeMath: multiplication overflow");
1044 
1045         return c;
1046     }
1047 
1048     /**
1049      * @dev Returns the integer division of two unsigned integers. Reverts on
1050      * division by zero. The result is rounded towards zero.
1051      *
1052      * Counterpart to Solidity's `/` operator. Note: this function uses a
1053      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1054      * uses an invalid opcode to revert (consuming all remaining gas).
1055      *
1056      * Requirements:
1057      *
1058      * - The divisor cannot be zero.
1059      */
1060     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1061         return div(a, b, "SafeMath: division by zero");
1062     }
1063 
1064     /**
1065      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1066      * division by zero. The result is rounded towards zero.
1067      *
1068      * Counterpart to Solidity's `/` operator. Note: this function uses a
1069      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1070      * uses an invalid opcode to revert (consuming all remaining gas).
1071      *
1072      * Requirements:
1073      *
1074      * - The divisor cannot be zero.
1075      */
1076     function div(
1077         uint256 a,
1078         uint256 b,
1079         string memory errorMessage
1080     ) internal pure returns (uint256) {
1081         require(b > 0, errorMessage);
1082         uint256 c = a / b;
1083         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1084 
1085         return c;
1086     }
1087 
1088     /**
1089      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1090      * Reverts when dividing by zero.
1091      *
1092      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1093      * opcode (which leaves remaining gas untouched) while Solidity uses an
1094      * invalid opcode to revert (consuming all remaining gas).
1095      *
1096      * Requirements:
1097      *
1098      * - The divisor cannot be zero.
1099      */
1100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1101         return mod(a, b, "SafeMath: modulo by zero");
1102     }
1103 
1104     /**
1105      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1106      * Reverts with custom message when dividing by zero.
1107      *
1108      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1109      * opcode (which leaves remaining gas untouched) while Solidity uses an
1110      * invalid opcode to revert (consuming all remaining gas).
1111      *
1112      * Requirements:
1113      *
1114      * - The divisor cannot be zero.
1115      */
1116     function mod(
1117         uint256 a,
1118         uint256 b,
1119         string memory errorMessage
1120     ) internal pure returns (uint256) {
1121         require(b != 0, errorMessage);
1122         return a % b;
1123     }
1124 }
1125 
1126 /**
1127  * @dev Implementation of the {IERC20} interface.
1128  *
1129  * This implementation is agnostic to the way tokens are created. This means
1130  * that a supply mechanism has to be added in a derived contract using {_mint}.
1131  * For a generic mechanism see {ERC20PresetMinterPauser}.
1132  *
1133  * TIP: For a detailed writeup see our guide
1134  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1135  * to implement supply mechanisms].
1136  *
1137  * We have followed general OpenZeppelin guidelines: functions revert instead
1138  * of returning `false` on failure. This behavior is nonetheless conventional
1139  * and does not conflict with the expectations of ERC20 applications.
1140  *
1141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1142  * This allows applications to reconstruct the allowance for all accounts just
1143  * by listening to said events. Other implementations of the EIP may not emit
1144  * these events, as it isn't required by the specification.
1145  *
1146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1147  * functions have been added to mitigate the well-known issues around setting
1148  * allowances. See {IERC20-approve}.
1149  */
1150 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable {
1151     using SafeMathUpgradeable for uint256;
1152 
1153     mapping(address => uint256) private _balances;
1154 
1155     mapping(address => mapping(address => uint256)) private _allowances;
1156 
1157     uint256 private _totalSupply;
1158 
1159     string private _name;
1160     string private _symbol;
1161     uint8 private _decimals;
1162 
1163     /**
1164      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1165      * a default value of 18.
1166      *
1167      * To select a different value for {decimals}, use {_setupDecimals}.
1168      *
1169      * All three of these values are immutable: they can only be set once during
1170      * construction.
1171      */
1172     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
1173         __Context_init_unchained();
1174         __ERC20_init_unchained(name_, symbol_);
1175     }
1176 
1177     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
1178         _name = name_;
1179         _symbol = symbol_;
1180         _decimals = 18;
1181     }
1182 
1183     /**
1184      * @dev Returns the name of the token.
1185      */
1186     function name() public view returns (string memory) {
1187         return _name;
1188     }
1189 
1190     /**
1191      * @dev Returns the symbol of the token, usually a shorter version of the
1192      * name.
1193      */
1194     function symbol() public view returns (string memory) {
1195         return _symbol;
1196     }
1197 
1198     /**
1199      * @dev Returns the number of decimals used to get its user representation.
1200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1201      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1202      *
1203      * Tokens usually opt for a value of 18, imitating the relationship between
1204      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1205      * called.
1206      *
1207      * NOTE: This information is only used for _display_ purposes: it in
1208      * no way affects any of the arithmetic of the contract, including
1209      * {IERC20-balanceOf} and {IERC20-transfer}.
1210      */
1211     function decimals() public view returns (uint8) {
1212         return _decimals;
1213     }
1214 
1215     /**
1216      * @dev See {IERC20-totalSupply}.
1217      */
1218     function totalSupply() public view override returns (uint256) {
1219         return _totalSupply;
1220     }
1221 
1222     /**
1223      * @dev See {IERC20-balanceOf}.
1224      */
1225     function balanceOf(address account) public view override returns (uint256) {
1226         return _balances[account];
1227     }
1228 
1229     /**
1230      * @dev See {IERC20-transfer}.
1231      *
1232      * Requirements:
1233      *
1234      * - `recipient` cannot be the zero address.
1235      * - the caller must have a balance of at least `amount`.
1236      */
1237     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1238         _transfer(_msgSender(), recipient, amount);
1239         return true;
1240     }
1241 
1242     /**
1243      * @dev See {IERC20-allowance}.
1244      */
1245     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1246         return _allowances[owner][spender];
1247     }
1248 
1249     /**
1250      * @dev See {IERC20-approve}.
1251      *
1252      * Requirements:
1253      *
1254      * - `spender` cannot be the zero address.
1255      */
1256     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1257         _approve(_msgSender(), spender, amount);
1258         return true;
1259     }
1260 
1261     /**
1262      * @dev See {IERC20-transferFrom}.
1263      *
1264      * Emits an {Approval} event indicating the updated allowance. This is not
1265      * required by the EIP. See the note at the beginning of {ERC20}.
1266      *
1267      * Requirements:
1268      *
1269      * - `sender` and `recipient` cannot be the zero address.
1270      * - `sender` must have a balance of at least `amount`.
1271      * - the caller must have allowance for ``sender``'s tokens of at least
1272      * `amount`.
1273      */
1274     function transferFrom(
1275         address sender,
1276         address recipient,
1277         uint256 amount
1278     ) public virtual override returns (bool) {
1279         _transfer(sender, recipient, amount);
1280         _approve(
1281             sender,
1282             _msgSender(),
1283             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
1284         );
1285         return true;
1286     }
1287 
1288     /**
1289      * @dev Atomically increases the allowance granted to `spender` by the caller.
1290      *
1291      * This is an alternative to {approve} that can be used as a mitigation for
1292      * problems described in {IERC20-approve}.
1293      *
1294      * Emits an {Approval} event indicating the updated allowance.
1295      *
1296      * Requirements:
1297      *
1298      * - `spender` cannot be the zero address.
1299      */
1300     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1302         return true;
1303     }
1304 
1305     /**
1306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1307      *
1308      * This is an alternative to {approve} that can be used as a mitigation for
1309      * problems described in {IERC20-approve}.
1310      *
1311      * Emits an {Approval} event indicating the updated allowance.
1312      *
1313      * Requirements:
1314      *
1315      * - `spender` cannot be the zero address.
1316      * - `spender` must have allowance for the caller of at least
1317      * `subtractedValue`.
1318      */
1319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1320         _approve(
1321             _msgSender(),
1322             spender,
1323             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
1324         );
1325         return true;
1326     }
1327 
1328     /**
1329      * @dev Moves tokens `amount` from `sender` to `recipient`.
1330      *
1331      * This is internal function is equivalent to {transfer}, and can be used to
1332      * e.g. implement automatic token fees, slashing mechanisms, etc.
1333      *
1334      * Emits a {Transfer} event.
1335      *
1336      * Requirements:
1337      *
1338      * - `sender` cannot be the zero address.
1339      * - `recipient` cannot be the zero address.
1340      * - `sender` must have a balance of at least `amount`.
1341      */
1342     function _transfer(
1343         address sender,
1344         address recipient,
1345         uint256 amount
1346     ) internal virtual {
1347         require(sender != address(0), "ERC20: transfer from the zero address");
1348         require(recipient != address(0), "ERC20: transfer to the zero address");
1349 
1350         _beforeTokenTransfer(sender, recipient, amount);
1351 
1352         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1353         _balances[recipient] = _balances[recipient].add(amount);
1354         emit Transfer(sender, recipient, amount);
1355     }
1356 
1357     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1358      * the total supply.
1359      *
1360      * Emits a {Transfer} event with `from` set to the zero address.
1361      *
1362      * Requirements:
1363      *
1364      * - `to` cannot be the zero address.
1365      */
1366     function _mint(address account, uint256 amount) internal virtual {
1367         require(account != address(0), "ERC20: mint to the zero address");
1368 
1369         _beforeTokenTransfer(address(0), account, amount);
1370 
1371         _totalSupply = _totalSupply.add(amount);
1372         _balances[account] = _balances[account].add(amount);
1373         emit Transfer(address(0), account, amount);
1374     }
1375 
1376     /**
1377      * @dev Destroys `amount` tokens from `account`, reducing the
1378      * total supply.
1379      *
1380      * Emits a {Transfer} event with `to` set to the zero address.
1381      *
1382      * Requirements:
1383      *
1384      * - `account` cannot be the zero address.
1385      * - `account` must have at least `amount` tokens.
1386      */
1387     function _burn(address account, uint256 amount) internal virtual {
1388         require(account != address(0), "ERC20: burn from the zero address");
1389 
1390         _beforeTokenTransfer(account, address(0), amount);
1391 
1392         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1393         _totalSupply = _totalSupply.sub(amount);
1394         emit Transfer(account, address(0), amount);
1395     }
1396 
1397     /**
1398      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1399      *
1400      * This internal function is equivalent to `approve`, and can be used to
1401      * e.g. set automatic allowances for certain subsystems, etc.
1402      *
1403      * Emits an {Approval} event.
1404      *
1405      * Requirements:
1406      *
1407      * - `owner` cannot be the zero address.
1408      * - `spender` cannot be the zero address.
1409      */
1410     function _approve(
1411         address owner,
1412         address spender,
1413         uint256 amount
1414     ) internal virtual {
1415         require(owner != address(0), "ERC20: approve from the zero address");
1416         require(spender != address(0), "ERC20: approve to the zero address");
1417 
1418         _allowances[owner][spender] = amount;
1419         emit Approval(owner, spender, amount);
1420     }
1421 
1422     /**
1423      * @dev Sets {decimals} to a value other than the default one of 18.
1424      *
1425      * WARNING: This function should only be called from the constructor. Most
1426      * applications that interact with token contracts will not expect
1427      * {decimals} to ever change, and may work incorrectly if it does.
1428      */
1429     function _setupDecimals(uint8 decimals_) internal {
1430         _decimals = decimals_;
1431     }
1432 
1433     /**
1434      * @dev Hook that is called before any transfer of tokens. This includes
1435      * minting and burning.
1436      *
1437      * Calling conditions:
1438      *
1439      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1440      * will be to transferred to `to`.
1441      * - when `from` is zero, `amount` tokens will be minted for `to`.
1442      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1443      * - `from` and `to` are never both zero.
1444      *
1445      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1446      */
1447     function _beforeTokenTransfer(
1448         address from,
1449         address to,
1450         uint256 amount
1451     ) internal virtual {}
1452 
1453     uint256[44] private __gap;
1454 }
1455 
1456 /**
1457  * @dev Library for managing
1458  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1459  * types.
1460  *
1461  * Sets have the following properties:
1462  *
1463  * - Elements are added, removed, and checked for existence in constant time
1464  * (O(1)).
1465  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1466  *
1467  * ```
1468  * contract Example {
1469  *     // Add the library methods
1470  *     using EnumerableSet for EnumerableSet.AddressSet;
1471  *
1472  *     // Declare a set state variable
1473  *     EnumerableSet.AddressSet private mySet;
1474  * }
1475  * ```
1476  *
1477  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1478  * and `uint256` (`UintSet`) are supported.
1479  */
1480 library EnumerableSet {
1481     // To implement this library for multiple types with as little code
1482     // repetition as possible, we write it in terms of a generic Set type with
1483     // bytes32 values.
1484     // The Set implementation uses private functions, and user-facing
1485     // implementations (such as AddressSet) are just wrappers around the
1486     // underlying Set.
1487     // This means that we can only create new EnumerableSets for types that fit
1488     // in bytes32.
1489 
1490     struct Set {
1491         // Storage of set values
1492         bytes32[] _values;
1493         // Position of the value in the `values` array, plus 1 because index 0
1494         // means a value is not in the set.
1495         mapping(bytes32 => uint256) _indexes;
1496     }
1497 
1498     /**
1499      * @dev Add a value to a set. O(1).
1500      *
1501      * Returns true if the value was added to the set, that is if it was not
1502      * already present.
1503      */
1504     function _add(Set storage set, bytes32 value) private returns (bool) {
1505         if (!_contains(set, value)) {
1506             set._values.push(value);
1507             // The value is stored at length-1, but we add 1 to all indexes
1508             // and use 0 as a sentinel value
1509             set._indexes[value] = set._values.length;
1510             return true;
1511         } else {
1512             return false;
1513         }
1514     }
1515 
1516     /**
1517      * @dev Removes a value from a set. O(1).
1518      *
1519      * Returns true if the value was removed from the set, that is if it was
1520      * present.
1521      */
1522     function _remove(Set storage set, bytes32 value) private returns (bool) {
1523         // We read and store the value's index to prevent multiple reads from the same storage slot
1524         uint256 valueIndex = set._indexes[value];
1525 
1526         if (valueIndex != 0) {
1527             // Equivalent to contains(set, value)
1528             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1529             // the array, and then remove the last element (sometimes called as 'swap and pop').
1530             // This modifies the order of the array, as noted in {at}.
1531 
1532             uint256 toDeleteIndex = valueIndex - 1;
1533             uint256 lastIndex = set._values.length - 1;
1534 
1535             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1536             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1537 
1538             bytes32 lastvalue = set._values[lastIndex];
1539 
1540             // Move the last value to the index where the value to delete is
1541             set._values[toDeleteIndex] = lastvalue;
1542             // Update the index for the moved value
1543             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1544 
1545             // Delete the slot where the moved value was stored
1546             set._values.pop();
1547 
1548             // Delete the index for the deleted slot
1549             delete set._indexes[value];
1550 
1551             return true;
1552         } else {
1553             return false;
1554         }
1555     }
1556 
1557     /**
1558      * @dev Returns true if the value is in the set. O(1).
1559      */
1560     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1561         return set._indexes[value] != 0;
1562     }
1563 
1564     /**
1565      * @dev Returns the number of values on the set. O(1).
1566      */
1567     function _length(Set storage set) private view returns (uint256) {
1568         return set._values.length;
1569     }
1570 
1571     /**
1572      * @dev Returns the value stored at position `index` in the set. O(1).
1573      *
1574      * Note that there are no guarantees on the ordering of values inside the
1575      * array, and it may change when more values are added or removed.
1576      *
1577      * Requirements:
1578      *
1579      * - `index` must be strictly less than {length}.
1580      */
1581     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1582         require(set._values.length > index, "EnumerableSet: index out of bounds");
1583         return set._values[index];
1584     }
1585 
1586     // Bytes32Set
1587 
1588     struct Bytes32Set {
1589         Set _inner;
1590     }
1591 
1592     /**
1593      * @dev Add a value to a set. O(1).
1594      *
1595      * Returns true if the value was added to the set, that is if it was not
1596      * already present.
1597      */
1598     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1599         return _add(set._inner, value);
1600     }
1601 
1602     /**
1603      * @dev Removes a value from a set. O(1).
1604      *
1605      * Returns true if the value was removed from the set, that is if it was
1606      * present.
1607      */
1608     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1609         return _remove(set._inner, value);
1610     }
1611 
1612     /**
1613      * @dev Returns true if the value is in the set. O(1).
1614      */
1615     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1616         return _contains(set._inner, value);
1617     }
1618 
1619     /**
1620      * @dev Returns the number of values in the set. O(1).
1621      */
1622     function length(Bytes32Set storage set) internal view returns (uint256) {
1623         return _length(set._inner);
1624     }
1625 
1626     /**
1627      * @dev Returns the value stored at position `index` in the set. O(1).
1628      *
1629      * Note that there are no guarantees on the ordering of values inside the
1630      * array, and it may change when more values are added or removed.
1631      *
1632      * Requirements:
1633      *
1634      * - `index` must be strictly less than {length}.
1635      */
1636     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1637         return _at(set._inner, index);
1638     }
1639 
1640     // AddressSet
1641 
1642     struct AddressSet {
1643         Set _inner;
1644     }
1645 
1646     /**
1647      * @dev Add a value to a set. O(1).
1648      *
1649      * Returns true if the value was added to the set, that is if it was not
1650      * already present.
1651      */
1652     function add(AddressSet storage set, address value) internal returns (bool) {
1653         return _add(set._inner, bytes32(uint256(value)));
1654     }
1655 
1656     /**
1657      * @dev Removes a value from a set. O(1).
1658      *
1659      * Returns true if the value was removed from the set, that is if it was
1660      * present.
1661      */
1662     function remove(AddressSet storage set, address value) internal returns (bool) {
1663         return _remove(set._inner, bytes32(uint256(value)));
1664     }
1665 
1666     /**
1667      * @dev Returns true if the value is in the set. O(1).
1668      */
1669     function contains(AddressSet storage set, address value) internal view returns (bool) {
1670         return _contains(set._inner, bytes32(uint256(value)));
1671     }
1672 
1673     /**
1674      * @dev Returns the number of values in the set. O(1).
1675      */
1676     function length(AddressSet storage set) internal view returns (uint256) {
1677         return _length(set._inner);
1678     }
1679 
1680     /**
1681      * @dev Returns the value stored at position `index` in the set. O(1).
1682      *
1683      * Note that there are no guarantees on the ordering of values inside the
1684      * array, and it may change when more values are added or removed.
1685      *
1686      * Requirements:
1687      *
1688      * - `index` must be strictly less than {length}.
1689      */
1690     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1691         return address(uint256(_at(set._inner, index)));
1692     }
1693 
1694     // UintSet
1695 
1696     struct UintSet {
1697         Set _inner;
1698     }
1699 
1700     /**
1701      * @dev Add a value to a set. O(1).
1702      *
1703      * Returns true if the value was added to the set, that is if it was not
1704      * already present.
1705      */
1706     function add(UintSet storage set, uint256 value) internal returns (bool) {
1707         return _add(set._inner, bytes32(value));
1708     }
1709 
1710     /**
1711      * @dev Removes a value from a set. O(1).
1712      *
1713      * Returns true if the value was removed from the set, that is if it was
1714      * present.
1715      */
1716     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1717         return _remove(set._inner, bytes32(value));
1718     }
1719 
1720     /**
1721      * @dev Returns true if the value is in the set. O(1).
1722      */
1723     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1724         return _contains(set._inner, bytes32(value));
1725     }
1726 
1727     /**
1728      * @dev Returns the number of values on the set. O(1).
1729      */
1730     function length(UintSet storage set) internal view returns (uint256) {
1731         return _length(set._inner);
1732     }
1733 
1734     /**
1735      * @dev Returns the value stored at position `index` in the set. O(1).
1736      *
1737      * Note that there are no guarantees on the ordering of values inside the
1738      * array, and it may change when more values are added or removed.
1739      *
1740      * Requirements:
1741      *
1742      * - `index` must be strictly less than {length}.
1743      */
1744     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1745         return uint256(_at(set._inner, index));
1746     }
1747 }
1748 
1749 /**
1750  * @dev Contract module that allows children to implement role-based access
1751  * control mechanisms.
1752  *
1753  * Roles are referred to by their `bytes32` identifier. These should be exposed
1754  * in the external API and be unique. The best way to achieve this is by
1755  * using `public constant` hash digests:
1756  *
1757  * ```
1758  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1759  * ```
1760  *
1761  * Roles can be used to represent a set of permissions. To restrict access to a
1762  * function call, use {hasRole}:
1763  *
1764  * ```
1765  * function foo() public {
1766  *     require(hasRole(MY_ROLE, msg.sender));
1767  *     ...
1768  * }
1769  * ```
1770  *
1771  * Roles can be granted and revoked dynamically via the {grantRole} and
1772  * {revokeRole} functions. Each role has an associated admin role, and only
1773  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1774  *
1775  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1776  * that only accounts with this role will be able to grant or revoke other
1777  * roles. More complex role relationships can be created by using
1778  * {_setRoleAdmin}.
1779  *
1780  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1781  * grant and revoke this role. Extra precautions should be taken to secure
1782  * accounts that have been granted it.
1783  */
1784 abstract contract AccessControl is Context {
1785     using EnumerableSet for EnumerableSet.AddressSet;
1786     using Address for address;
1787 
1788     struct RoleData {
1789         EnumerableSet.AddressSet members;
1790         bytes32 adminRole;
1791     }
1792 
1793     mapping(bytes32 => RoleData) private _roles;
1794 
1795     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1796 
1797     /**
1798      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1799      *
1800      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1801      * {RoleAdminChanged} not being emitted signaling this.
1802      *
1803      * _Available since v3.1._
1804      */
1805     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1806 
1807     /**
1808      * @dev Emitted when `account` is granted `role`.
1809      *
1810      * `sender` is the account that originated the contract call, an admin role
1811      * bearer except when using {_setupRole}.
1812      */
1813     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1814 
1815     /**
1816      * @dev Emitted when `account` is revoked `role`.
1817      *
1818      * `sender` is the account that originated the contract call:
1819      *   - if using `revokeRole`, it is the admin role bearer
1820      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1821      */
1822     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1823 
1824     /**
1825      * @dev Returns `true` if `account` has been granted `role`.
1826      */
1827     function hasRole(bytes32 role, address account) public view returns (bool) {
1828         return _roles[role].members.contains(account);
1829     }
1830 
1831     /**
1832      * @dev Returns the number of accounts that have `role`. Can be used
1833      * together with {getRoleMember} to enumerate all bearers of a role.
1834      */
1835     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1836         return _roles[role].members.length();
1837     }
1838 
1839     /**
1840      * @dev Returns one of the accounts that have `role`. `index` must be a
1841      * value between 0 and {getRoleMemberCount}, non-inclusive.
1842      *
1843      * Role bearers are not sorted in any particular way, and their ordering may
1844      * change at any point.
1845      *
1846      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1847      * you perform all queries on the same block. See the following
1848      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1849      * for more information.
1850      */
1851     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1852         return _roles[role].members.at(index);
1853     }
1854 
1855     /**
1856      * @dev Returns the admin role that controls `role`. See {grantRole} and
1857      * {revokeRole}.
1858      *
1859      * To change a role's admin, use {_setRoleAdmin}.
1860      */
1861     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1862         return _roles[role].adminRole;
1863     }
1864 
1865     /**
1866      * @dev Grants `role` to `account`.
1867      *
1868      * If `account` had not been already granted `role`, emits a {RoleGranted}
1869      * event.
1870      *
1871      * Requirements:
1872      *
1873      * - the caller must have ``role``'s admin role.
1874      */
1875     function grantRole(bytes32 role, address account) public virtual {
1876         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1877 
1878         _grantRole(role, account);
1879     }
1880 
1881     /**
1882      * @dev Revokes `role` from `account`.
1883      *
1884      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1885      *
1886      * Requirements:
1887      *
1888      * - the caller must have ``role``'s admin role.
1889      */
1890     function revokeRole(bytes32 role, address account) public virtual {
1891         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1892 
1893         _revokeRole(role, account);
1894     }
1895 
1896     /**
1897      * @dev Revokes `role` from the calling account.
1898      *
1899      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1900      * purpose is to provide a mechanism for accounts to lose their privileges
1901      * if they are compromised (such as when a trusted device is misplaced).
1902      *
1903      * If the calling account had been granted `role`, emits a {RoleRevoked}
1904      * event.
1905      *
1906      * Requirements:
1907      *
1908      * - the caller must be `account`.
1909      */
1910     function renounceRole(bytes32 role, address account) public virtual {
1911         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1912 
1913         _revokeRole(role, account);
1914     }
1915 
1916     /**
1917      * @dev Grants `role` to `account`.
1918      *
1919      * If `account` had not been already granted `role`, emits a {RoleGranted}
1920      * event. Note that unlike {grantRole}, this function doesn't perform any
1921      * checks on the calling account.
1922      *
1923      * [WARNING]
1924      * ====
1925      * This function should only be called from the constructor when setting
1926      * up the initial roles for the system.
1927      *
1928      * Using this function in any other way is effectively circumventing the admin
1929      * system imposed by {AccessControl}.
1930      * ====
1931      */
1932     function _setupRole(bytes32 role, address account) internal virtual {
1933         _grantRole(role, account);
1934     }
1935 
1936     /**
1937      * @dev Sets `adminRole` as ``role``'s admin role.
1938      *
1939      * Emits a {RoleAdminChanged} event.
1940      */
1941     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1942         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1943         _roles[role].adminRole = adminRole;
1944     }
1945 
1946     function _grantRole(bytes32 role, address account) private {
1947         if (_roles[role].members.add(account)) {
1948             emit RoleGranted(role, account, _msgSender());
1949         }
1950     }
1951 
1952     function _revokeRole(bytes32 role, address account) private {
1953         if (_roles[role].members.remove(account)) {
1954             emit RoleRevoked(role, account, _msgSender());
1955         }
1956     }
1957 }
1958 
1959 // example:
1960 //LnAccessControl accessCtrl = LnAccessControl(addressStorage.getAddress("LnAccessControl"));
1961 //require(accessCtrl.hasRole(accessCtrl.DEBT_SYSTEM(), _address), "Need debt system access role");
1962 
1963 // contract access control
1964 contract LnAccessControl is AccessControl {
1965     using Address for address;
1966 
1967     // -------------------------------------------------------
1968     // role type
1969     bytes32 public constant ISSUE_ASSET_ROLE = ("ISSUE_ASSET"); //keccak256
1970     bytes32 public constant BURN_ASSET_ROLE = ("BURN_ASSET");
1971 
1972     bytes32 public constant DEBT_SYSTEM = ("LnDebtSystem");
1973 
1974     // -------------------------------------------------------
1975     constructor(address admin) public {
1976         _setupRole(DEFAULT_ADMIN_ROLE, admin);
1977     }
1978 
1979     function IsAdmin(address _address) public view returns (bool) {
1980         return hasRole(DEFAULT_ADMIN_ROLE, _address);
1981     }
1982 
1983     function SetAdmin(address _address) public returns (bool) {
1984         require(IsAdmin(msg.sender), "Only admin");
1985 
1986         _setupRole(DEFAULT_ADMIN_ROLE, _address);
1987     }
1988 
1989     // -------------------------------------------------------
1990     // this func need admin role. grantRole and revokeRole need admin role
1991     function SetRoles(
1992         bytes32 roleType,
1993         address[] calldata addresses,
1994         bool[] calldata setTo
1995     ) external {
1996         require(IsAdmin(msg.sender), "Only admin");
1997 
1998         _setRoles(roleType, addresses, setTo);
1999     }
2000 
2001     function _setRoles(
2002         bytes32 roleType,
2003         address[] calldata addresses,
2004         bool[] calldata setTo
2005     ) private {
2006         require(addresses.length == setTo.length, "parameter address length not eq");
2007 
2008         for (uint256 i = 0; i < addresses.length; i++) {
2009             //require(addresses[i].isContract(), "Role address need contract only");
2010             if (setTo[i]) {
2011                 grantRole(roleType, addresses[i]);
2012             } else {
2013                 revokeRole(roleType, addresses[i]);
2014             }
2015         }
2016     }
2017 
2018     // function SetRoles(bytes32 roleType, address[] calldata addresses, bool[] calldata setTo) public {
2019     //     _setRoles(roleType, addresses, setTo);
2020     // }
2021 
2022     // Issue burn
2023     function SetIssueAssetRole(address[] calldata issuer, bool[] calldata setTo) public {
2024         _setRoles(ISSUE_ASSET_ROLE, issuer, setTo);
2025     }
2026 
2027     function SetBurnAssetRole(address[] calldata burner, bool[] calldata setTo) public {
2028         _setRoles(BURN_ASSET_ROLE, burner, setTo);
2029     }
2030 
2031     //
2032     function SetDebtSystemRole(address[] calldata _address, bool[] calldata _setTo) public {
2033         _setRoles(DEBT_SYSTEM, _address, _setTo);
2034     }
2035 }
2036 
2037 /**
2038  * @title LnAssetUpgradeable
2039  *
2040  * @dev This is an upgradeable version of `LnAsset`.
2041  */
2042 contract LnAssetUpgradeable is ERC20Upgradeable, LnAdminUpgradeable, IAsset, LnAddressCache {
2043     bytes32 mKeyName;
2044     LnAccessControl accessCtrl;
2045 
2046     modifier onlyIssueAssetRole(address _address) {
2047         require(accessCtrl.hasRole(accessCtrl.ISSUE_ASSET_ROLE(), _address), "Need issue access role");
2048         _;
2049     }
2050     modifier onlyBurnAssetRole(address _address) {
2051         require(accessCtrl.hasRole(accessCtrl.BURN_ASSET_ROLE(), _address), "Need burn access role");
2052         _;
2053     }
2054 
2055     function __LnAssetUpgradeable_init(
2056         bytes32 _key,
2057         string memory _name,
2058         string memory _symbol,
2059         address _admin
2060     ) public initializer {
2061         __ERC20_init(_name, _symbol);
2062         __LnAdminUpgradeable_init(_admin);
2063 
2064         mKeyName = _key;
2065     }
2066 
2067     function keyName() external view override returns (bytes32) {
2068         return mKeyName;
2069     }
2070 
2071     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
2072         accessCtrl = LnAccessControl(
2073             _addressStorage.getAddressWithRequire("LnAccessControl", "LnAccessControl address not valid")
2074         );
2075 
2076         emit CachedAddressUpdated("LnAccessControl", address(accessCtrl));
2077     }
2078 
2079     function mint(address account, uint256 amount) external onlyIssueAssetRole(msg.sender) {
2080         _mint(account, amount);
2081     }
2082 
2083     function burn(address account, uint amount) external onlyBurnAssetRole(msg.sender) {
2084         _burn(account, amount);
2085     }
2086 
2087     // Reserved storage space to allow for layout changes in the future.
2088     uint256[48] private __gap;
2089 }
2090 
2091 contract LnAssetSystem is LnAddressStorage {
2092     using SafeMath for uint;
2093     using SafeDecimalMath for uint;
2094 
2095     IAsset[] public mAssetList; // 合约地址数组
2096     mapping(address => bytes32) public mAddress2Names; // 地址到名称的映射
2097 
2098     constructor(address _admin) public LnAddressStorage(_admin) {}
2099 
2100     function addAsset(IAsset asset) external onlyAdmin {
2101         bytes32 name = asset.keyName();
2102 
2103         require(mAddrs[name] == address(0), "Asset already exists");
2104         require(mAddress2Names[address(asset)] == bytes32(0), "Asset address already exists");
2105 
2106         mAssetList.push(asset);
2107         mAddrs[name] = address(asset);
2108         mAddress2Names[address(asset)] = name;
2109 
2110         emit AssetAdded(name, address(asset));
2111     }
2112 
2113     function removeAsset(bytes32 name) external onlyAdmin {
2114         address assetToRemove = address(mAddrs[name]);
2115 
2116         require(assetToRemove != address(0), "asset does not exist");
2117 
2118         // Remove from list
2119         for (uint i = 0; i < mAssetList.length; i++) {
2120             if (address(mAssetList[i]) == assetToRemove) {
2121                 delete mAssetList[i];
2122                 mAssetList[i] = mAssetList[mAssetList.length - 1];
2123                 mAssetList.pop();
2124                 break;
2125             }
2126         }
2127 
2128         // And remove it from the assets mapping
2129         delete mAddress2Names[assetToRemove];
2130         delete mAddrs[name];
2131 
2132         emit AssetRemoved(name, assetToRemove);
2133     }
2134 
2135     function assetNumber() external view returns (uint) {
2136         return mAssetList.length;
2137     }
2138 
2139     // check exchange rate invalid condition ? invalid just fail.
2140     function totalAssetsInUsd() public view returns (uint256 rTotal) {
2141         require(mAddrs["LnPrices"] != address(0), "LnPrices address cannot access");
2142         LnPrices priceGetter = LnPrices(mAddrs["LnPrices"]); //getAddress
2143         for (uint256 i = 0; i < mAssetList.length; i++) {
2144             uint256 exchangeRate = priceGetter.getPrice(mAssetList[i].keyName());
2145             rTotal = rTotal.add(LnAssetUpgradeable(address(mAssetList[i])).totalSupply().multiplyDecimal(exchangeRate));
2146         }
2147     }
2148 
2149     function getAssetAddresses() external view returns (address[] memory) {
2150         address[] memory addr = new address[](mAssetList.length);
2151         for (uint256 i = 0; i < mAssetList.length; i++) {
2152             addr[i] = address(mAssetList[i]);
2153         }
2154         return addr;
2155     }
2156 
2157     event AssetAdded(bytes32 name, address asset);
2158     event AssetRemoved(bytes32 name, address asset);
2159 }
2160 
2161 // Reward Distributor
2162 contract LnRewardLocker is LnAdminUpgradeable {
2163     using SafeMath for uint256;
2164 
2165     struct RewardData {
2166         uint64 lockToTime;
2167         uint256 amount;
2168     }
2169 
2170     mapping(address => RewardData[]) public userRewards; // RewardData[0] is claimable
2171     mapping(address => uint256) public balanceOf;
2172     uint256 public totalNeedToReward;
2173 
2174     uint256 public constant maxRewardArrayLen = 100;
2175 
2176     address feeSysAddr;
2177     IERC20 public linaToken;
2178 
2179     function __LnRewardLocker_init(address _admin, address linaAddress) public initializer {
2180         __LnAdminUpgradeable_init(_admin);
2181 
2182         linaToken = IERC20(linaAddress);
2183     }
2184 
2185     function setLinaAddress(address _token) external onlyAdmin {
2186         linaToken = IERC20(_token);
2187     }
2188 
2189     function Init(address _feeSysAddr) external onlyAdmin {
2190         feeSysAddr = _feeSysAddr;
2191     }
2192 
2193     modifier onlyFeeSys() {
2194         require((msg.sender == feeSysAddr), "Only Fee System call");
2195         _;
2196     }
2197 
2198     function appendReward(
2199         address _user,
2200         uint256 _amount,
2201         uint64 _lockTo
2202     ) external onlyFeeSys {
2203         if (userRewards[_user].length >= maxRewardArrayLen) {
2204             Slimming(_user);
2205         }
2206 
2207         require(userRewards[_user].length <= maxRewardArrayLen, "user array out of");
2208         // init cliamable
2209         if (userRewards[_user].length == 0) {
2210             RewardData memory data = RewardData({lockToTime: 0, amount: 0});
2211             userRewards[_user].push(data);
2212         }
2213 
2214         // append new reward
2215         RewardData memory data = RewardData({lockToTime: _lockTo, amount: _amount});
2216         userRewards[_user].push(data);
2217 
2218         balanceOf[_user] = balanceOf[_user].add(_amount);
2219         totalNeedToReward = totalNeedToReward.add(_amount);
2220 
2221         emit AppendReward(_user, _amount, _lockTo);
2222     }
2223 
2224     // move claimable to RewardData[0]
2225     function Slimming(address _user) public {
2226         require(userRewards[_user].length > 1, "not data to slimming");
2227         RewardData storage claimable = userRewards[_user][0];
2228         for (uint256 i = 1; i < userRewards[_user].length; ) {
2229             if (now >= userRewards[_user][i].lockToTime) {
2230                 claimable.amount = claimable.amount.add(userRewards[_user][i].amount);
2231 
2232                 //swap last to current position
2233                 uint256 len = userRewards[_user].length;
2234                 userRewards[_user][i].lockToTime = userRewards[_user][len - 1].lockToTime;
2235                 userRewards[_user][i].amount = userRewards[_user][len - 1].amount;
2236                 userRewards[_user].pop(); // delete last one
2237             } else {
2238                 i++;
2239             }
2240         }
2241     }
2242 
2243     // if lock lina is collateral, claimable need calc to fix target ratio
2244     function ClaimMaxable() public {
2245         address user = msg.sender;
2246         Slimming(user);
2247         _claim(user, userRewards[user][0].amount);
2248     }
2249 
2250     function _claim(address _user, uint256 _amount) internal {
2251         userRewards[_user][0].amount = userRewards[_user][0].amount.sub(_amount);
2252 
2253         balanceOf[_user] = balanceOf[_user].sub(_amount);
2254         totalNeedToReward = totalNeedToReward.sub(_amount);
2255 
2256         linaToken.transfer(_user, _amount);
2257         emit ClaimLog(_user, _amount);
2258     }
2259 
2260     function Claim(uint256 _amount) public {
2261         address user = msg.sender;
2262         Slimming(user);
2263         require(_amount <= userRewards[user][0].amount, "Claim amount invalid");
2264         _claim(user, _amount);
2265     }
2266 
2267     event AppendReward(address user, uint256 amount, uint64 lockTo);
2268     event ClaimLog(address user, uint256 amount);
2269 
2270     // Reserved storage space to allow for layout changes in the future.
2271     uint256[45] private __gap;
2272 }
2273 
2274 contract LnFeeSystem is LnAdminUpgradeable, LnAddressCache {
2275     using SafeMath for uint256;
2276     using SafeDecimalMath for uint256;
2277 
2278     address public constant FEE_DUMMY_ADDRESS = address(0x2048);
2279 
2280     struct UserDebtData {
2281         uint256 PeriodID; // Period id
2282         uint256 debtProportion;
2283         uint256 debtFactor; // PRECISE_UNIT
2284     }
2285 
2286     struct RewardPeriod {
2287         uint256 id; // Period id
2288         uint256 startingDebtFactor;
2289         uint256 startTime;
2290         uint256 feesToDistribute; // 要分配的费用
2291         uint256 feesClaimed; // 已领取的费用
2292         uint256 rewardsToDistribute; // 要分配的奖励
2293         uint256 rewardsClaimed; // 已领取的奖励
2294     }
2295 
2296     RewardPeriod public curRewardPeriod;
2297     RewardPeriod public preRewardPeriod;
2298     uint256 public OnePeriodSecs;
2299     uint64 public LockTime;
2300 
2301     mapping(address => uint256) public userLastClaimedId;
2302 
2303     mapping(address => UserDebtData[2]) public userPeriodDebt; // one for current period, one for pre period
2304 
2305     //
2306     LnDebtSystem public debtSystem;
2307     LnCollateralSystem public collateralSystem;
2308     LnRewardLocker public rewardLocker;
2309     LnAssetSystem mAssets;
2310 
2311     address public exchangeSystemAddress;
2312     address public rewardDistributer;
2313 
2314     function __LnFeeSystem_init(address _admin) public initializer {
2315         __LnAdminUpgradeable_init(_admin);
2316 
2317         OnePeriodSecs = 1 weeks;
2318         LockTime = uint64(52 weeks);
2319     }
2320 
2321     // Note: before start run need call this func to init.
2322     function Init(address _exchangeSystem, address _rewardDistri) public onlyAdmin {
2323         exchangeSystemAddress = _exchangeSystem;
2324         rewardDistributer = _rewardDistri;
2325     }
2326 
2327     //set period data, maybe copy from old contract
2328     function SetPeriodData(
2329         int16 index, // 0 current 1 pre
2330         uint256 id,
2331         uint256 startingDebtFactor,
2332         uint256 startTime,
2333         uint256 feesToDistribute,
2334         uint256 feesClaimed,
2335         uint256 rewardsToDistribute,
2336         uint256 rewardsClaimed
2337     ) public onlyAdmin {
2338         RewardPeriod storage toset = index == 0 ? curRewardPeriod : preRewardPeriod;
2339         toset.id = id;
2340         toset.startingDebtFactor = startingDebtFactor;
2341         toset.startTime = startTime;
2342         toset.feesToDistribute = feesToDistribute;
2343         toset.feesClaimed = feesClaimed;
2344         toset.rewardsToDistribute = rewardsToDistribute;
2345         toset.rewardsClaimed = rewardsClaimed;
2346     }
2347 
2348     function setExchangeSystemAddress(address _address) public onlyAdmin {
2349         exchangeSystemAddress = _address;
2350     }
2351 
2352     modifier onlyExchanger {
2353         require((msg.sender == exchangeSystemAddress), "Only Exchange System call");
2354         _;
2355     }
2356 
2357     modifier onlyDistributer {
2358         require((msg.sender == rewardDistributer), "Only Reward Distributer call");
2359         _;
2360     }
2361 
2362     function addExchangeFee(uint feeUsd) public onlyExchanger {
2363         curRewardPeriod.feesToDistribute = curRewardPeriod.feesToDistribute.add(feeUsd);
2364         emit ExchangeFee(feeUsd);
2365     }
2366 
2367     // TODO: call by contract or auto distribute?
2368     function addCollateralRewards(uint reward) public onlyDistributer {
2369         curRewardPeriod.rewardsToDistribute = curRewardPeriod.rewardsToDistribute.add(reward);
2370         emit RewardCollateral(reward);
2371     }
2372 
2373     event ExchangeFee(uint feeUsd);
2374     event RewardCollateral(uint reward);
2375     event FeesClaimed(address user, uint lUSDAmount, uint linaRewards);
2376 
2377     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
2378         debtSystem = LnDebtSystem(_addressStorage.getAddressWithRequire("LnDebtSystem", "LnDebtSystem address not valid"));
2379         address payable collateralAddress =
2380             payable(_addressStorage.getAddressWithRequire("LnCollateralSystem", "LnCollateralSystem address not valid"));
2381         collateralSystem = LnCollateralSystem(collateralAddress);
2382         rewardLocker = LnRewardLocker(
2383             _addressStorage.getAddressWithRequire("LnRewardLocker", "LnRewardLocker address not valid")
2384         );
2385         mAssets = LnAssetSystem(_addressStorage.getAddressWithRequire("LnAssetSystem", "LnAssetSystem address not valid"));
2386 
2387         // as Init func. record LnExchangeSystem address
2388         exchangeSystemAddress = _addressStorage.getAddressWithRequire(
2389             "LnExchangeSystem",
2390             "LnExchangeSystem address not valid"
2391         );
2392 
2393         emit CachedAddressUpdated("LnDebtSystem", address(debtSystem));
2394         emit CachedAddressUpdated("LnCollateralSystem", address(collateralSystem));
2395         emit CachedAddressUpdated("LnRewardLocker", address(rewardLocker));
2396         emit CachedAddressUpdated("LnAssetSystem", address(mAssets));
2397         emit CachedAddressUpdated("LnExchangeSystem", address(exchangeSystemAddress));
2398     }
2399 
2400     function switchPeriod() public {
2401         require(now >= curRewardPeriod.startTime + OnePeriodSecs, "It's not time to switch");
2402 
2403         preRewardPeriod.id = curRewardPeriod.id;
2404         preRewardPeriod.startingDebtFactor = curRewardPeriod.startingDebtFactor;
2405         preRewardPeriod.startTime = curRewardPeriod.startTime;
2406         preRewardPeriod.feesToDistribute = curRewardPeriod.feesToDistribute.add(
2407             preRewardPeriod.feesToDistribute.sub(preRewardPeriod.feesClaimed)
2408         );
2409         preRewardPeriod.feesClaimed = 0;
2410         preRewardPeriod.rewardsToDistribute = curRewardPeriod.rewardsToDistribute.add(
2411             preRewardPeriod.rewardsToDistribute.sub(preRewardPeriod.rewardsClaimed)
2412         );
2413         preRewardPeriod.rewardsClaimed = 0;
2414 
2415         curRewardPeriod.id = curRewardPeriod.id + 1;
2416         curRewardPeriod.startingDebtFactor = debtSystem.LastSystemDebtFactor();
2417         curRewardPeriod.startTime = now;
2418         curRewardPeriod.feesToDistribute = 0;
2419         curRewardPeriod.feesClaimed = 0;
2420         curRewardPeriod.rewardsToDistribute = 0;
2421         curRewardPeriod.rewardsClaimed = 0;
2422     }
2423 
2424     function feePeriodDuration() external view returns (uint) {
2425         return OnePeriodSecs;
2426     }
2427 
2428     function recentFeePeriods(uint index)
2429         external
2430         view
2431         returns (
2432             uint256 id,
2433             uint256 startingDebtFactor,
2434             uint256 startTime,
2435             uint256 feesToDistribute,
2436             uint256 feesClaimed,
2437             uint256 rewardsToDistribute,
2438             uint256 rewardsClaimed
2439         )
2440     {
2441         if (index > 1) {
2442             return (0, 0, 0, 0, 0, 0, 0);
2443         }
2444         RewardPeriod memory rewardPd;
2445         if (index == 0) {
2446             rewardPd = curRewardPeriod;
2447         } else {
2448             rewardPd = preRewardPeriod;
2449         }
2450         return (
2451             rewardPd.id,
2452             rewardPd.startingDebtFactor,
2453             rewardPd.startTime,
2454             rewardPd.feesToDistribute,
2455             rewardPd.feesClaimed,
2456             rewardPd.rewardsToDistribute,
2457             rewardPd.rewardsClaimed
2458         );
2459     }
2460 
2461     modifier onlyDebtSystem() {
2462         require(msg.sender == address(debtSystem), "Only Debt system call");
2463         _;
2464     }
2465 
2466     // build record
2467     function RecordUserDebt(
2468         address user,
2469         uint256 debtProportion,
2470         uint256 debtFactor
2471     ) public onlyDebtSystem {
2472         uint256 curId = curRewardPeriod.id;
2473         uint256 minPos = 0;
2474         if (userPeriodDebt[user][0].PeriodID > userPeriodDebt[user][1].PeriodID) {
2475             minPos = 1;
2476         }
2477         uint256 pos = minPos;
2478         for (uint64 i = 0; i < userPeriodDebt[user].length; i++) {
2479             if (userPeriodDebt[user][i].PeriodID == curId) {
2480                 pos = i;
2481                 break;
2482             }
2483         }
2484         userPeriodDebt[user][pos].PeriodID = curId;
2485         userPeriodDebt[user][pos].debtProportion = debtProportion;
2486         userPeriodDebt[user][pos].debtFactor = debtFactor;
2487     }
2488 
2489     function isFeesClaimable(address account) public view returns (bool feesClaimable) {
2490         if (collateralSystem.IsSatisfyTargetRatio(account) == false) {
2491             return false;
2492         }
2493 
2494         if (userLastClaimedId[account] == preRewardPeriod.id) {
2495             return false;
2496         }
2497 
2498         // TODO: other condition?
2499         return true;
2500     }
2501 
2502     // total fee and total reward
2503     function feesAvailable(address user) public view returns (uint, uint) {
2504         if (preRewardPeriod.feesToDistribute == 0 && preRewardPeriod.rewardsToDistribute == 0) {
2505             return (0, 0);
2506         }
2507         uint256 debtFactor = 0;
2508         uint256 debtProportion = 0;
2509         uint256 pid = 0; //get last period factor
2510         for (uint64 i = 0; i < userPeriodDebt[user].length; i++) {
2511             if (userPeriodDebt[user][i].PeriodID < curRewardPeriod.id && userPeriodDebt[user][i].PeriodID > pid) {
2512                 pid = curRewardPeriod.id;
2513                 debtFactor = userPeriodDebt[user][i].debtFactor;
2514                 debtProportion = userPeriodDebt[user][i].debtProportion;
2515             }
2516         }
2517         //
2518         //if (debtProportion == 0) {
2519         //    (debtProportion, debtFactor) = debtSystem.userDebtState(user);
2520         //}
2521 
2522         if (debtProportion == 0) {
2523             return (0, 0);
2524         }
2525 
2526         uint256 lastPeriodDebtFactor = curRewardPeriod.startingDebtFactor;
2527         uint256 userDebtProportion =
2528             lastPeriodDebtFactor.divideDecimalRoundPrecise(debtFactor).multiplyDecimalRoundPrecise(debtProportion);
2529 
2530         uint256 fee =
2531             preRewardPeriod
2532                 .feesToDistribute
2533                 .decimalToPreciseDecimal()
2534                 .multiplyDecimalRoundPrecise(userDebtProportion)
2535                 .preciseDecimalToDecimal();
2536 
2537         uint256 reward =
2538             preRewardPeriod
2539                 .rewardsToDistribute
2540                 .decimalToPreciseDecimal()
2541                 .multiplyDecimalRoundPrecise(userDebtProportion)
2542                 .preciseDecimalToDecimal();
2543         return (fee, reward);
2544     }
2545 
2546     // claim fee and reward.
2547     function claimFees() external returns (bool) {
2548         address user = msg.sender;
2549         require(isFeesClaimable(user), "User is not claimable");
2550 
2551         userLastClaimedId[user] = preRewardPeriod.id;
2552         // fee reward: mint lusd
2553         // : rewardLocker.appendReward(use, reward, now + 1 years);
2554         (uint256 fee, uint256 reward) = feesAvailable(user);
2555         require(fee > 0 || reward > 0, "Nothing to claim");
2556 
2557         if (fee > 0) {
2558             LnAssetUpgradeable lusd =
2559                 LnAssetUpgradeable(mAssets.getAddressWithRequire("lUSD", "get lUSD asset address fail"));
2560             lusd.burn(FEE_DUMMY_ADDRESS, fee);
2561             lusd.mint(user, fee);
2562         }
2563 
2564         if (reward > 0) {
2565             uint64 totime = uint64(now + LockTime);
2566             rewardLocker.appendReward(user, reward, totime);
2567         }
2568         emit FeesClaimed(user, fee, reward);
2569         return true;
2570     }
2571 
2572     // Reserved storage space to allow for layout changes in the future.
2573     uint256[38] private __gap;
2574 }
2575 
2576 contract LnFeeSystemTest is LnFeeSystem {
2577     function __LnFeeSystemTest_init(address _admin) public initializer {
2578         __LnFeeSystem_init(_admin);
2579 
2580         OnePeriodSecs = 6 hours;
2581         LockTime = 1 hours;
2582     }
2583 }
2584 
2585 contract LnDebtSystem is LnAdminUpgradeable, LnAddressCache {
2586     using SafeMath for uint;
2587     using SafeDecimalMath for uint;
2588     using Address for address;
2589 
2590     // -------------------------------------------------------
2591     // need set before system running value.
2592     LnAccessControl private accessCtrl;
2593     LnAssetSystem private assetSys;
2594     LnFeeSystem public feeSystem;
2595     // -------------------------------------------------------
2596     struct DebtData {
2597         uint256 debtProportion;
2598         uint256 debtFactor; // PRECISE_UNIT
2599     }
2600     mapping(address => DebtData) public userDebtState;
2601 
2602     //use mapping to store array data
2603     mapping(uint256 => uint256) public lastDebtFactors; // PRECISE_UNIT Note: 能直接记 factor 的记 factor, 不能记的就用index查
2604     uint256 public debtCurrentIndex; // length of array. this index of array no value
2605     // follow var use to manage array size.
2606     uint256 public lastCloseAt; // close at array index
2607     uint256 public lastDeletTo; // delete to array index, lastDeletTo < lastCloseAt
2608     uint256 public constant MAX_DEL_PER_TIME = 50;
2609 
2610     //
2611 
2612     // -------------------------------------------------------
2613     function __LnDebtSystem_init(address _admin) public initializer {
2614         __LnAdminUpgradeable_init(_admin);
2615     }
2616 
2617     event UpdateAddressStorage(address oldAddr, address newAddr);
2618     event UpdateUserDebtLog(address addr, uint256 debtProportion, uint256 debtFactor);
2619     event PushDebtLog(uint256 index, uint256 newFactor);
2620 
2621     // ------------------ system config ----------------------
2622     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
2623         accessCtrl = LnAccessControl(
2624             _addressStorage.getAddressWithRequire("LnAccessControl", "LnAccessControl address not valid")
2625         );
2626         assetSys = LnAssetSystem(_addressStorage.getAddressWithRequire("LnAssetSystem", "LnAssetSystem address not valid"));
2627         feeSystem = LnFeeSystem(_addressStorage.getAddressWithRequire("LnFeeSystem", "LnFeeSystem address not valid"));
2628 
2629         emit CachedAddressUpdated("LnAccessControl", address(accessCtrl));
2630         emit CachedAddressUpdated("LnAssetSystem", address(assetSys));
2631         emit CachedAddressUpdated("LnFeeSystem", address(feeSystem));
2632     }
2633 
2634     // -----------------------------------------------
2635     modifier OnlyDebtSystemRole(address _address) {
2636         require(accessCtrl.hasRole(accessCtrl.DEBT_SYSTEM(), _address), "Need debt system access role");
2637         _;
2638     }
2639 
2640     function SetLastCloseFeePeriodAt(uint256 index) external OnlyDebtSystemRole(msg.sender) {
2641         require(index >= lastCloseAt, "Close index can not return to pass");
2642         require(index <= debtCurrentIndex, "Can not close at future index");
2643         lastCloseAt = index;
2644     }
2645 
2646     function _pushDebtFactor(uint256 _factor) private {
2647         if (debtCurrentIndex == 0 || lastDebtFactors[debtCurrentIndex - 1] == 0) {
2648             // init or all debt has be cleared, new set value will be one unit
2649             lastDebtFactors[debtCurrentIndex] = SafeDecimalMath.preciseUnit();
2650         } else {
2651             lastDebtFactors[debtCurrentIndex] = lastDebtFactors[debtCurrentIndex - 1].multiplyDecimalRoundPrecise(_factor);
2652         }
2653         emit PushDebtLog(debtCurrentIndex, lastDebtFactors[debtCurrentIndex]);
2654 
2655         debtCurrentIndex = debtCurrentIndex.add(1);
2656 
2657         // delete out of date data
2658         if (lastDeletTo < lastCloseAt) {
2659             // safe check
2660             uint256 delNum = lastCloseAt - lastDeletTo;
2661             delNum = (delNum > MAX_DEL_PER_TIME) ? MAX_DEL_PER_TIME : delNum; // not delete all in one call, for saving someone fee.
2662             for (uint256 i = lastDeletTo; i < delNum; i++) {
2663                 delete lastDebtFactors[i];
2664             }
2665             lastDeletTo = lastDeletTo.add(delNum);
2666         }
2667     }
2668 
2669     function PushDebtFactor(uint256 _factor) external OnlyDebtSystemRole(msg.sender) {
2670         _pushDebtFactor(_factor);
2671     }
2672 
2673     function _updateUserDebt(address _user, uint256 _debtProportion) private {
2674         userDebtState[_user].debtProportion = _debtProportion;
2675         userDebtState[_user].debtFactor = _lastSystemDebtFactor();
2676         emit UpdateUserDebtLog(_user, _debtProportion, userDebtState[_user].debtFactor);
2677 
2678         feeSystem.RecordUserDebt(_user, userDebtState[_user].debtProportion, userDebtState[_user].debtFactor);
2679     }
2680 
2681     // need update lastDebtFactors first
2682     function UpdateUserDebt(address _user, uint256 _debtProportion) external OnlyDebtSystemRole(msg.sender) {
2683         _updateUserDebt(_user, _debtProportion);
2684     }
2685 
2686     function UpdateDebt(
2687         address _user,
2688         uint256 _debtProportion,
2689         uint256 _factor
2690     ) external OnlyDebtSystemRole(msg.sender) {
2691         _pushDebtFactor(_factor);
2692         _updateUserDebt(_user, _debtProportion);
2693     }
2694 
2695     function GetUserDebtData(address _user) external view returns (uint256 debtProportion, uint256 debtFactor) {
2696         debtProportion = userDebtState[_user].debtProportion;
2697         debtFactor = userDebtState[_user].debtFactor;
2698     }
2699 
2700     function _lastSystemDebtFactor() private view returns (uint256) {
2701         if (debtCurrentIndex == 0) {
2702             return SafeDecimalMath.preciseUnit();
2703         }
2704         return lastDebtFactors[debtCurrentIndex - 1];
2705     }
2706 
2707     function LastSystemDebtFactor() external view returns (uint256) {
2708         return _lastSystemDebtFactor();
2709     }
2710 
2711     function GetUserCurrentDebtProportion(address _user) public view returns (uint256) {
2712         uint256 debtProportion = userDebtState[_user].debtProportion;
2713         uint256 debtFactor = userDebtState[_user].debtFactor;
2714 
2715         if (debtProportion == 0) {
2716             return 0;
2717         }
2718 
2719         uint256 currentUserDebtProportion =
2720             _lastSystemDebtFactor().divideDecimalRoundPrecise(debtFactor).multiplyDecimalRoundPrecise(debtProportion);
2721         return currentUserDebtProportion;
2722     }
2723 
2724     /**
2725      *
2726      *@return [0] the debt balance of user. [1] system total asset in usd.
2727      */
2728     function GetUserDebtBalanceInUsd(address _user) external view returns (uint256, uint256) {
2729         uint256 totalAssetSupplyInUsd = assetSys.totalAssetsInUsd();
2730 
2731         uint256 debtProportion = userDebtState[_user].debtProportion;
2732         uint256 debtFactor = userDebtState[_user].debtFactor;
2733 
2734         if (debtProportion == 0) {
2735             return (0, totalAssetSupplyInUsd);
2736         }
2737 
2738         uint256 currentUserDebtProportion =
2739             _lastSystemDebtFactor().divideDecimalRoundPrecise(debtFactor).multiplyDecimalRoundPrecise(debtProportion);
2740         uint256 userDebtBalance =
2741             totalAssetSupplyInUsd
2742                 .decimalToPreciseDecimal()
2743                 .multiplyDecimalRoundPrecise(currentUserDebtProportion)
2744                 .preciseDecimalToDecimal();
2745 
2746         return (userDebtBalance, totalAssetSupplyInUsd);
2747     }
2748 
2749     // Reserved storage space to allow for layout changes in the future.
2750     uint256[42] private __gap;
2751 }
2752 
2753 /**
2754  * @dev Contract module which allows children to implement an emergency stop
2755  * mechanism that can be triggered by an authorized account.
2756  *
2757  * This module is used through inheritance. It will make available the
2758  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2759  * the functions of your contract. Note that they will not be pausable by
2760  * simply including this module, only once the modifiers are put in place.
2761  */
2762 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
2763     /**
2764      * @dev Emitted when the pause is triggered by `account`.
2765      */
2766     event Paused(address account);
2767 
2768     /**
2769      * @dev Emitted when the pause is lifted by `account`.
2770      */
2771     event Unpaused(address account);
2772 
2773     bool private _paused;
2774 
2775     /**
2776      * @dev Initializes the contract in unpaused state.
2777      */
2778     function __Pausable_init() internal initializer {
2779         __Context_init_unchained();
2780         __Pausable_init_unchained();
2781     }
2782 
2783     function __Pausable_init_unchained() internal initializer {
2784         _paused = false;
2785     }
2786 
2787     /**
2788      * @dev Returns true if the contract is paused, and false otherwise.
2789      */
2790     function paused() public view returns (bool) {
2791         return _paused;
2792     }
2793 
2794     /**
2795      * @dev Modifier to make a function callable only when the contract is not paused.
2796      *
2797      * Requirements:
2798      *
2799      * - The contract must not be paused.
2800      */
2801     modifier whenNotPaused() {
2802         require(!_paused, "Pausable: paused");
2803         _;
2804     }
2805 
2806     /**
2807      * @dev Modifier to make a function callable only when the contract is paused.
2808      *
2809      * Requirements:
2810      *
2811      * - The contract must be paused.
2812      */
2813     modifier whenPaused() {
2814         require(_paused, "Pausable: not paused");
2815         _;
2816     }
2817 
2818     /**
2819      * @dev Triggers stopped state.
2820      *
2821      * Requirements:
2822      *
2823      * - The contract must not be paused.
2824      */
2825     function _pause() internal virtual whenNotPaused {
2826         _paused = true;
2827         emit Paused(_msgSender());
2828     }
2829 
2830     /**
2831      * @dev Returns to normal state.
2832      *
2833      * Requirements:
2834      *
2835      * - The contract must be paused.
2836      */
2837     function _unpause() internal virtual whenPaused {
2838         _paused = false;
2839         emit Unpaused(_msgSender());
2840     }
2841 
2842     uint256[49] private __gap;
2843 }
2844 
2845 /**
2846  * @dev Collection of functions related to the address type
2847  */
2848 library AddressUpgradeable {
2849     /**
2850      * @dev Returns true if `account` is a contract.
2851      *
2852      * [IMPORTANT]
2853      * ====
2854      * It is unsafe to assume that an address for which this function returns
2855      * false is an externally-owned account (EOA) and not a contract.
2856      *
2857      * Among others, `isContract` will return false for the following
2858      * types of addresses:
2859      *
2860      *  - an externally-owned account
2861      *  - a contract in construction
2862      *  - an address where a contract will be created
2863      *  - an address where a contract lived, but was destroyed
2864      * ====
2865      */
2866     function isContract(address account) internal view returns (bool) {
2867         // This method relies on extcodesize, which returns 0 for contracts in
2868         // construction, since the code is only stored at the end of the
2869         // constructor execution.
2870 
2871         uint256 size;
2872         // solhint-disable-next-line no-inline-assembly
2873         assembly {
2874             size := extcodesize(account)
2875         }
2876         return size > 0;
2877     }
2878 
2879     /**
2880      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2881      * `recipient`, forwarding all available gas and reverting on errors.
2882      *
2883      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2884      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2885      * imposed by `transfer`, making them unable to receive funds via
2886      * `transfer`. {sendValue} removes this limitation.
2887      *
2888      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2889      *
2890      * IMPORTANT: because control is transferred to `recipient`, care must be
2891      * taken to not create reentrancy vulnerabilities. Consider using
2892      * {ReentrancyGuard} or the
2893      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2894      */
2895     function sendValue(address payable recipient, uint256 amount) internal {
2896         require(address(this).balance >= amount, "Address: insufficient balance");
2897 
2898         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
2899         (bool success, ) = recipient.call{value: amount}("");
2900         require(success, "Address: unable to send value, recipient may have reverted");
2901     }
2902 
2903     /**
2904      * @dev Performs a Solidity function call using a low level `call`. A
2905      * plain`call` is an unsafe replacement for a function call: use this
2906      * function instead.
2907      *
2908      * If `target` reverts with a revert reason, it is bubbled up by this
2909      * function (like regular Solidity function calls).
2910      *
2911      * Returns the raw returned data. To convert to the expected return value,
2912      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2913      *
2914      * Requirements:
2915      *
2916      * - `target` must be a contract.
2917      * - calling `target` with `data` must not revert.
2918      *
2919      * _Available since v3.1._
2920      */
2921     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2922         return functionCall(target, data, "Address: low-level call failed");
2923     }
2924 
2925     /**
2926      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2927      * `errorMessage` as a fallback revert reason when `target` reverts.
2928      *
2929      * _Available since v3.1._
2930      */
2931     function functionCall(
2932         address target,
2933         bytes memory data,
2934         string memory errorMessage
2935     ) internal returns (bytes memory) {
2936         return functionCallWithValue(target, data, 0, errorMessage);
2937     }
2938 
2939     /**
2940      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2941      * but also transferring `value` wei to `target`.
2942      *
2943      * Requirements:
2944      *
2945      * - the calling contract must have an ETH balance of at least `value`.
2946      * - the called Solidity function must be `payable`.
2947      *
2948      * _Available since v3.1._
2949      */
2950     function functionCallWithValue(
2951         address target,
2952         bytes memory data,
2953         uint256 value
2954     ) internal returns (bytes memory) {
2955         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2956     }
2957 
2958     /**
2959      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2960      * with `errorMessage` as a fallback revert reason when `target` reverts.
2961      *
2962      * _Available since v3.1._
2963      */
2964     function functionCallWithValue(
2965         address target,
2966         bytes memory data,
2967         uint256 value,
2968         string memory errorMessage
2969     ) internal returns (bytes memory) {
2970         require(address(this).balance >= value, "Address: insufficient balance for call");
2971         require(isContract(target), "Address: call to non-contract");
2972 
2973         // solhint-disable-next-line avoid-low-level-calls
2974         (bool success, bytes memory returndata) = target.call{value: value}(data);
2975         return _verifyCallResult(success, returndata, errorMessage);
2976     }
2977 
2978     /**
2979      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2980      * but performing a static call.
2981      *
2982      * _Available since v3.3._
2983      */
2984     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2985         return functionStaticCall(target, data, "Address: low-level static call failed");
2986     }
2987 
2988     /**
2989      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2990      * but performing a static call.
2991      *
2992      * _Available since v3.3._
2993      */
2994     function functionStaticCall(
2995         address target,
2996         bytes memory data,
2997         string memory errorMessage
2998     ) internal view returns (bytes memory) {
2999         require(isContract(target), "Address: static call to non-contract");
3000 
3001         // solhint-disable-next-line avoid-low-level-calls
3002         (bool success, bytes memory returndata) = target.staticcall(data);
3003         return _verifyCallResult(success, returndata, errorMessage);
3004     }
3005 
3006     function _verifyCallResult(
3007         bool success,
3008         bytes memory returndata,
3009         string memory errorMessage
3010     ) private pure returns (bytes memory) {
3011         if (success) {
3012             return returndata;
3013         } else {
3014             // Look for revert reason and bubble it up if present
3015             if (returndata.length > 0) {
3016                 // The easiest way to bubble the revert reason is using memory via assembly
3017 
3018                 // solhint-disable-next-line no-inline-assembly
3019                 assembly {
3020                     let returndata_size := mload(returndata)
3021                     revert(add(32, returndata), returndata_size)
3022                 }
3023             } else {
3024                 revert(errorMessage);
3025             }
3026         }
3027     }
3028 }
3029 
3030 // 单纯抵押进来
3031 // 赎回时需要 债务率良好才能赎回， 赎回部分能保持债务率高于目标债务率
3032 contract LnCollateralSystem is LnAdminUpgradeable, PausableUpgradeable, LnAddressCache {
3033     using SafeMath for uint;
3034     using SafeDecimalMath for uint;
3035     using AddressUpgradeable for address;
3036 
3037     // -------------------------------------------------------
3038     // need set before system running value.
3039     LnPrices public priceGetter;
3040     LnDebtSystem public debtSystem;
3041     LnBuildBurnSystem public buildBurnSystem;
3042     LnConfig public mConfig;
3043     LnRewardLocker public mRewardLocker;
3044 
3045     bytes32 public constant Currency_ETH = "ETH";
3046     bytes32 public constant Currency_LINA = "LINA";
3047 
3048     // -------------------------------------------------------
3049     uint256 public uniqueId; // use log
3050 
3051     struct TokenInfo {
3052         address tokenAddr;
3053         uint256 minCollateral; // min collateral amount.
3054         uint256 totalCollateral;
3055         bool bClose; // TODO : 为了防止价格波动，另外再加个折扣价?
3056     }
3057 
3058     mapping(bytes32 => TokenInfo) public tokenInfos;
3059     bytes32[] public tokenSymbol; // keys of tokenInfos, use to iteration
3060 
3061     struct CollateralData {
3062         uint256 collateral; // total collateral
3063     }
3064 
3065     // [user] => ([token=> collateraldata])
3066     mapping(address => mapping(bytes32 => CollateralData)) public userCollateralData;
3067 
3068     // -------------------------------------------------------
3069     function __LnCollateralSystem_init(address _admin) public initializer {
3070         __LnAdminUpgradeable_init(_admin);
3071     }
3072 
3073     function setPaused(bool _paused) external onlyAdmin {
3074         if (_paused) {
3075             _pause();
3076         } else {
3077             _unpause();
3078         }
3079     }
3080 
3081     // ------------------ system config ----------------------
3082     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
3083         priceGetter = LnPrices(_addressStorage.getAddressWithRequire("LnPrices", "LnPrices address not valid"));
3084         debtSystem = LnDebtSystem(_addressStorage.getAddressWithRequire("LnDebtSystem", "LnDebtSystem address not valid"));
3085         buildBurnSystem = LnBuildBurnSystem(
3086             _addressStorage.getAddressWithRequire("LnBuildBurnSystem", "LnBuildBurnSystem address not valid")
3087         );
3088         mConfig = LnConfig(_addressStorage.getAddressWithRequire("LnConfig", "LnConfig address not valid"));
3089         mRewardLocker = LnRewardLocker(
3090             _addressStorage.getAddressWithRequire("LnRewardLocker", "LnRewardLocker address not valid")
3091         );
3092 
3093         emit CachedAddressUpdated("LnPrices", address(priceGetter));
3094         emit CachedAddressUpdated("LnDebtSystem", address(debtSystem));
3095         emit CachedAddressUpdated("LnBuildBurnSystem", address(buildBurnSystem));
3096         emit CachedAddressUpdated("LnConfig", address(mConfig));
3097         emit CachedAddressUpdated("LnRewardLocker", address(mRewardLocker));
3098     }
3099 
3100     function updateTokenInfo(
3101         bytes32 _currency,
3102         address _tokenAddr,
3103         uint256 _minCollateral,
3104         bool _close
3105     ) private returns (bool) {
3106         require(_currency[0] != 0, "symbol cannot empty");
3107         require(_currency != Currency_ETH, "ETH is used by system");
3108         require(_tokenAddr != address(0), "token address cannot zero");
3109         require(_tokenAddr.isContract(), "token address is not a contract");
3110 
3111         if (tokenInfos[_currency].tokenAddr == address(0)) {
3112             // new token
3113             tokenSymbol.push(_currency);
3114         }
3115 
3116         uint256 totalCollateral = tokenInfos[_currency].totalCollateral;
3117         tokenInfos[_currency] = TokenInfo({
3118             tokenAddr: _tokenAddr,
3119             minCollateral: _minCollateral,
3120             totalCollateral: totalCollateral,
3121             bClose: _close
3122         });
3123         emit UpdateTokenSetting(_currency, _tokenAddr, _minCollateral, _close);
3124         return true;
3125     }
3126 
3127     // delete token info? need to handle it's staking data.
3128 
3129     function UpdateTokenInfo(
3130         bytes32 _currency,
3131         address _tokenAddr,
3132         uint256 _minCollateral,
3133         bool _close
3134     ) external onlyAdmin returns (bool) {
3135         return updateTokenInfo(_currency, _tokenAddr, _minCollateral, _close);
3136     }
3137 
3138     function UpdateTokenInfos(
3139         bytes32[] calldata _symbols,
3140         address[] calldata _tokenAddrs,
3141         uint256[] calldata _minCollateral,
3142         bool[] calldata _closes
3143     ) external onlyAdmin returns (bool) {
3144         require(_symbols.length == _tokenAddrs.length, "length of array not eq");
3145         require(_symbols.length == _minCollateral.length, "length of array not eq");
3146         require(_symbols.length == _closes.length, "length of array not eq");
3147 
3148         for (uint256 i = 0; i < _symbols.length; i++) {
3149             updateTokenInfo(_symbols[i], _tokenAddrs[i], _minCollateral[i], _closes[i]);
3150         }
3151 
3152         return true;
3153     }
3154 
3155     // ------------------------------------------------------------------------
3156     function GetSystemTotalCollateralInUsd() public view returns (uint256 rTotal) {
3157         for (uint256 i = 0; i < tokenSymbol.length; i++) {
3158             bytes32 currency = tokenSymbol[i];
3159             if (tokenInfos[currency].totalCollateral > 0) {
3160                 // this check for avoid calling getPrice when collateral is zero
3161                 if (Currency_LINA == currency) {
3162                     uint256 totallina = tokenInfos[currency].totalCollateral.add(mRewardLocker.totalNeedToReward());
3163                     rTotal = rTotal.add(totallina.multiplyDecimal(priceGetter.getPrice(currency)));
3164                 } else {
3165                     rTotal = rTotal.add(
3166                         tokenInfos[currency].totalCollateral.multiplyDecimal(priceGetter.getPrice(currency))
3167                     );
3168                 }
3169             }
3170         }
3171 
3172         if (address(this).balance > 0) {
3173             rTotal = rTotal.add(address(this).balance.multiplyDecimal(priceGetter.getPrice(Currency_ETH)));
3174         }
3175     }
3176 
3177     function GetUserTotalCollateralInUsd(address _user) public view returns (uint256 rTotal) {
3178         for (uint256 i = 0; i < tokenSymbol.length; i++) {
3179             bytes32 currency = tokenSymbol[i];
3180             if (userCollateralData[_user][currency].collateral > 0) {
3181                 if (Currency_LINA == currency) {
3182                     uint256 totallina = userCollateralData[_user][currency].collateral.add(mRewardLocker.balanceOf(_user));
3183                     rTotal = rTotal.add(totallina.multiplyDecimal(priceGetter.getPrice(currency)));
3184                 } else {
3185                     rTotal = rTotal.add(
3186                         userCollateralData[_user][currency].collateral.multiplyDecimal(priceGetter.getPrice(currency))
3187                     );
3188                 }
3189             }
3190         }
3191 
3192         if (userCollateralData[_user][Currency_ETH].collateral > 0) {
3193             rTotal = rTotal.add(
3194                 userCollateralData[_user][Currency_ETH].collateral.multiplyDecimal(priceGetter.getPrice(Currency_ETH))
3195             );
3196         }
3197     }
3198 
3199     function GetUserCollateral(address _user, bytes32 _currency) external view returns (uint256) {
3200         if (Currency_LINA != _currency) {
3201             return userCollateralData[_user][_currency].collateral;
3202         }
3203         return mRewardLocker.balanceOf(_user).add(userCollateralData[_user][_currency].collateral);
3204     }
3205 
3206     // NOTE: LINA collateral not include reward in locker
3207     function GetUserCollaterals(address _user) external view returns (bytes32[] memory, uint256[] memory) {
3208         bytes32[] memory rCurrency = new bytes32[](tokenSymbol.length + 1);
3209         uint256[] memory rAmount = new uint256[](tokenSymbol.length + 1);
3210         uint256 retSize = 0;
3211         for (uint256 i = 0; i < tokenSymbol.length; i++) {
3212             bytes32 currency = tokenSymbol[i];
3213             if (userCollateralData[_user][currency].collateral > 0) {
3214                 rCurrency[retSize] = currency;
3215                 rAmount[retSize] = userCollateralData[_user][currency].collateral;
3216                 retSize++;
3217             }
3218         }
3219         if (userCollateralData[_user][Currency_ETH].collateral > 0) {
3220             rCurrency[retSize] = Currency_ETH;
3221             rAmount[retSize] = userCollateralData[_user][Currency_ETH].collateral;
3222             retSize++;
3223         }
3224 
3225         return (rCurrency, rAmount);
3226     }
3227 
3228     // need approve
3229     function Collateral(bytes32 _currency, uint256 _amount) external whenNotPaused returns (bool) {
3230         require(tokenInfos[_currency].tokenAddr.isContract(), "Invalid token symbol");
3231         TokenInfo storage tokeninfo = tokenInfos[_currency];
3232         require(_amount > tokeninfo.minCollateral, "Collateral amount too small");
3233         require(tokeninfo.bClose == false, "This token is closed");
3234 
3235         address user = msg.sender;
3236 
3237         IERC20 erc20 = IERC20(tokenInfos[_currency].tokenAddr);
3238         require(erc20.balanceOf(user) >= _amount, "insufficient balance");
3239         require(erc20.allowance(user, address(this)) >= _amount, "insufficient allowance, need approve more amount");
3240 
3241         erc20.transferFrom(user, address(this), _amount);
3242 
3243         userCollateralData[user][_currency].collateral = userCollateralData[user][_currency].collateral.add(_amount);
3244         tokeninfo.totalCollateral = tokeninfo.totalCollateral.add(_amount);
3245 
3246         emit CollateralLog(user, _currency, _amount, userCollateralData[user][_currency].collateral);
3247         return true;
3248     }
3249 
3250     function IsSatisfyTargetRatio(address _user) public view returns (bool) {
3251         (uint256 debtBalance, ) = debtSystem.GetUserDebtBalanceInUsd(_user);
3252         if (debtBalance == 0) {
3253             return true;
3254         }
3255 
3256         uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3257         uint256 totalCollateralInUsd = GetUserTotalCollateralInUsd(_user);
3258         if (totalCollateralInUsd == 0) {
3259             return false;
3260         }
3261         uint256 myratio = debtBalance.divideDecimal(totalCollateralInUsd);
3262         return myratio <= buildRatio;
3263     }
3264 
3265     // 满足最低抵押率的情况下可最大赎回的资产 TODO: return multi value
3266     function MaxRedeemableInUsd(address _user) public view returns (uint256) {
3267         uint256 totalCollateralInUsd = GetUserTotalCollateralInUsd(_user);
3268 
3269         (uint256 debtBalance, ) = debtSystem.GetUserDebtBalanceInUsd(_user);
3270         if (debtBalance == 0) {
3271             return totalCollateralInUsd;
3272         }
3273 
3274         uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3275         uint256 minCollateral = debtBalance.divideDecimal(buildRatio);
3276         if (totalCollateralInUsd < minCollateral) {
3277             return 0;
3278         }
3279 
3280         return totalCollateralInUsd.sub(minCollateral);
3281     }
3282 
3283     function MaxRedeemable(address user, bytes32 _currency) public view returns (uint256) {
3284         uint256 maxRedeemableInUsd = MaxRedeemableInUsd(user);
3285         uint256 maxRedeem = maxRedeemableInUsd.divideDecimal(priceGetter.getPrice(_currency));
3286         if (maxRedeem > userCollateralData[user][_currency].collateral) {
3287             maxRedeem = userCollateralData[user][_currency].collateral;
3288         }
3289         if (Currency_LINA != _currency) {
3290             return maxRedeem;
3291         }
3292         uint256 lockedLina = mRewardLocker.balanceOf(user);
3293         if (maxRedeem <= lockedLina) {
3294             return 0;
3295         }
3296         return maxRedeem.sub(lockedLina);
3297     }
3298 
3299     function RedeemMax(bytes32 _currency) external whenNotPaused {
3300         address user = msg.sender;
3301         uint256 maxRedeem = MaxRedeemable(user, _currency);
3302         _Redeem(user, _currency, maxRedeem);
3303     }
3304 
3305     function _Redeem(
3306         address user,
3307         bytes32 _currency,
3308         uint256 _amount
3309     ) internal {
3310         require(_amount <= userCollateralData[user][_currency].collateral, "Can not redeem more than collateral");
3311         require(_amount > 0, "Redeem amount need larger than zero");
3312 
3313         uint256 maxRedeemableInUsd = MaxRedeemableInUsd(user);
3314         uint256 maxRedeem = maxRedeemableInUsd.divideDecimal(priceGetter.getPrice(_currency));
3315         require(_amount <= maxRedeem, "Because lower collateral ratio, can not redeem too much");
3316 
3317         userCollateralData[user][_currency].collateral = userCollateralData[user][_currency].collateral.sub(_amount);
3318 
3319         TokenInfo storage tokeninfo = tokenInfos[_currency];
3320         tokeninfo.totalCollateral = tokeninfo.totalCollateral.sub(_amount);
3321 
3322         IERC20(tokenInfos[_currency].tokenAddr).transfer(user, _amount);
3323 
3324         emit RedeemCollateral(user, _currency, _amount, userCollateralData[user][_currency].collateral);
3325     }
3326 
3327     // 1. After redeem, collateral ratio need bigger than target ratio.
3328     // 2. Cannot redeem more than collateral.
3329     function Redeem(bytes32 _currency, uint256 _amount) public whenNotPaused returns (bool) {
3330         address user = msg.sender;
3331         _Redeem(user, _currency, _amount);
3332         return true;
3333     }
3334 
3335     receive() external payable whenNotPaused {
3336         address user = msg.sender;
3337         uint256 ethAmount = msg.value;
3338         _CollateralEth(user, ethAmount);
3339     }
3340 
3341     function _CollateralEth(address user, uint256 ethAmount) internal {
3342         require(ethAmount > 0, "ETH amount need more than zero");
3343 
3344         userCollateralData[user][Currency_ETH].collateral = userCollateralData[user][Currency_ETH].collateral.add(ethAmount);
3345 
3346         emit CollateralLog(user, Currency_ETH, ethAmount, userCollateralData[user][Currency_ETH].collateral);
3347     }
3348 
3349     // payable eth receive,
3350     function CollateralEth() external payable whenNotPaused returns (bool) {
3351         address user = msg.sender;
3352         uint256 ethAmount = msg.value;
3353         _CollateralEth(user, ethAmount);
3354         return true;
3355     }
3356 
3357     function RedeemETH(uint256 _amount) external whenNotPaused returns (bool) {
3358         address payable user = msg.sender;
3359         require(_amount <= userCollateralData[user][Currency_ETH].collateral, "Can not redeem more than collateral");
3360         require(_amount > 0, "Redeem amount need larger than zero");
3361 
3362         uint256 maxRedeemableInUsd = MaxRedeemableInUsd(user);
3363 
3364         uint256 maxRedeem = maxRedeemableInUsd.divideDecimal(priceGetter.getPrice(Currency_ETH));
3365         require(_amount <= maxRedeem, "Because lower collateral ratio, can not redeem too much");
3366 
3367         userCollateralData[user][Currency_ETH].collateral = userCollateralData[user][Currency_ETH].collateral.sub(_amount);
3368         user.transfer(_amount);
3369 
3370         emit RedeemCollateral(user, Currency_ETH, _amount, userCollateralData[user][Currency_ETH].collateral);
3371         return true;
3372     }
3373 
3374     event UpdateTokenSetting(bytes32 symbol, address tokenAddr, uint256 minCollateral, bool close);
3375     event CollateralLog(address user, bytes32 _currency, uint256 _amount, uint256 _userTotal);
3376     event RedeemCollateral(address user, bytes32 _currency, uint256 _amount, uint256 _userTotal);
3377 
3378     // Reserved storage space to allow for layout changes in the future.
3379     uint256[41] private __gap;
3380 }
3381 
3382 // 根据 LnCollateralSystem 的抵押资产计算相关抵押率，buildable lusd
3383 contract LnBuildBurnSystem is LnAdmin, Pausable, LnAddressCache {
3384     using SafeMath for uint;
3385     using SafeDecimalMath for uint;
3386     using Address for address;
3387 
3388     // -------------------------------------------------------
3389     // need set before system running value.
3390     LnAssetUpgradeable private lUSDToken; // this contract need
3391 
3392     LnDebtSystem private debtSystem;
3393     LnAssetSystem private assetSys;
3394     LnPrices private priceGetter;
3395     LnCollateralSystem private collaterSys;
3396     LnConfig private mConfig;
3397 
3398     // -------------------------------------------------------
3399     constructor(address admin, address _lUSDTokenAddr) public LnAdmin(admin) {
3400         lUSDToken = LnAssetUpgradeable(_lUSDTokenAddr);
3401     }
3402 
3403     function setPaused(bool _paused) external onlyAdmin {
3404         if (_paused) {
3405             _pause();
3406         } else {
3407             _unpause();
3408         }
3409     }
3410 
3411     function updateAddressCache(LnAddressStorage _addressStorage) public override onlyAdmin {
3412         priceGetter = LnPrices(_addressStorage.getAddressWithRequire("LnPrices", "LnPrices address not valid"));
3413         debtSystem = LnDebtSystem(_addressStorage.getAddressWithRequire("LnDebtSystem", "LnDebtSystem address not valid"));
3414         assetSys = LnAssetSystem(_addressStorage.getAddressWithRequire("LnAssetSystem", "LnAssetSystem address not valid"));
3415         address payable collateralAddress =
3416             payable(_addressStorage.getAddressWithRequire("LnCollateralSystem", "LnCollateralSystem address not valid"));
3417         collaterSys = LnCollateralSystem(collateralAddress);
3418         mConfig = LnConfig(_addressStorage.getAddressWithRequire("LnConfig", "LnConfig address not valid"));
3419 
3420         emit CachedAddressUpdated("LnPrices", address(priceGetter));
3421         emit CachedAddressUpdated("LnDebtSystem", address(debtSystem));
3422         emit CachedAddressUpdated("LnAssetSystem", address(assetSys));
3423         emit CachedAddressUpdated("LnCollateralSystem", address(collaterSys));
3424         emit CachedAddressUpdated("LnConfig", address(mConfig));
3425     }
3426 
3427     function SetLusdTokenAddress(address _address) public onlyAdmin {
3428         emit UpdateLusdToken(address(lUSDToken), _address);
3429         lUSDToken = LnAssetUpgradeable(_address);
3430     }
3431 
3432     event UpdateLusdToken(address oldAddr, address newAddr);
3433 
3434     function MaxCanBuildAsset(address user) public view returns (uint256) {
3435         uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3436         uint256 maxCanBuild = collaterSys.MaxRedeemableInUsd(user).mul(buildRatio).div(SafeDecimalMath.unit());
3437         return maxCanBuild;
3438     }
3439 
3440     // build lusd
3441     function BuildAsset(uint256 amount) public whenNotPaused returns (bool) {
3442         address user = msg.sender;
3443         uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3444         uint256 maxCanBuild = collaterSys.MaxRedeemableInUsd(user).multiplyDecimal(buildRatio);
3445         require(amount <= maxCanBuild, "Build amount too big, you need more collateral");
3446 
3447         // calc debt
3448         (uint256 oldUserDebtBalance, uint256 totalAssetSupplyInUsd) = debtSystem.GetUserDebtBalanceInUsd(user);
3449 
3450         uint256 newTotalAssetSupply = totalAssetSupplyInUsd.add(amount);
3451         // update debt data
3452         uint256 buildDebtProportion = amount.divideDecimalRoundPrecise(newTotalAssetSupply); // debtPercentage
3453         uint oldTotalProportion = SafeDecimalMath.preciseUnit().sub(buildDebtProportion); //
3454 
3455         uint256 newUserDebtProportion = buildDebtProportion;
3456         if (oldUserDebtBalance > 0) {
3457             newUserDebtProportion = oldUserDebtBalance.add(amount).divideDecimalRoundPrecise(newTotalAssetSupply);
3458         }
3459 
3460         // update debt
3461         debtSystem.UpdateDebt(user, newUserDebtProportion, oldTotalProportion);
3462 
3463         // mint asset
3464         lUSDToken.mint(user, amount);
3465 
3466         return true;
3467     }
3468 
3469     function BuildMaxAsset() external whenNotPaused {
3470         address user = msg.sender;
3471         uint256 max = MaxCanBuildAsset(user);
3472         BuildAsset(max);
3473     }
3474 
3475     function _burnAsset(address user, uint256 amount) internal {
3476         //uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3477         require(amount > 0, "amount need > 0");
3478         // calc debt
3479         (uint256 oldUserDebtBalance, uint256 totalAssetSupplyInUsd) = debtSystem.GetUserDebtBalanceInUsd(user);
3480         require(oldUserDebtBalance > 0, "no debt, no burn");
3481         uint256 burnAmount = oldUserDebtBalance < amount ? oldUserDebtBalance : amount;
3482         // burn asset
3483         lUSDToken.burn(user, burnAmount);
3484 
3485         uint newTotalDebtIssued = totalAssetSupplyInUsd.sub(burnAmount);
3486 
3487         uint oldTotalProportion = 0;
3488         if (newTotalDebtIssued > 0) {
3489             uint debtPercentage = burnAmount.divideDecimalRoundPrecise(newTotalDebtIssued);
3490             oldTotalProportion = SafeDecimalMath.preciseUnit().add(debtPercentage);
3491         }
3492 
3493         uint256 newUserDebtProportion = 0;
3494         if (oldUserDebtBalance > burnAmount) {
3495             uint newDebt = oldUserDebtBalance.sub(burnAmount);
3496             newUserDebtProportion = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3497         }
3498 
3499         // update debt
3500         debtSystem.UpdateDebt(user, newUserDebtProportion, oldTotalProportion);
3501     }
3502 
3503     // burn
3504     function BurnAsset(uint256 amount) external whenNotPaused returns (bool) {
3505         address user = msg.sender;
3506         _burnAsset(user, amount);
3507         return true;
3508     }
3509 
3510     //所有
3511     // function MaxAssetToTarget(address user) external view returns(uint256) {
3512     //     uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3513     //     uint256 totalCollateral = collaterSys.GetUserTotalCollateralInUsd(user);
3514     // }
3515 
3516     // burn to target ratio
3517     function BurnAssetToTarget() external whenNotPaused returns (bool) {
3518         address user = msg.sender;
3519 
3520         uint256 buildRatio = mConfig.getUint(mConfig.BUILD_RATIO());
3521         uint256 totalCollateral = collaterSys.GetUserTotalCollateralInUsd(user);
3522         uint256 maxBuildAssetToTarget = totalCollateral.multiplyDecimal(buildRatio);
3523         (uint256 debtAsset, ) = debtSystem.GetUserDebtBalanceInUsd(user);
3524         require(debtAsset > maxBuildAssetToTarget, "You maybe want build to target");
3525 
3526         uint256 needBurn = debtAsset.sub(maxBuildAssetToTarget);
3527         uint balance = lUSDToken.balanceOf(user); // burn as many as possible
3528         if (balance < needBurn) {
3529             needBurn = balance;
3530         }
3531         _burnAsset(user, needBurn);
3532         return true;
3533     }
3534 }
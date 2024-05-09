1 // SPDX-License-Identifier: Unlicensed
2 /**
3  * @dev Interface of the ERC20 standard as defined in the EIP.
4  */
5 interface IERC20Upgradeable {
6     /**a
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library AddressUpgradeable {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         // solhint-disable-next-line no-inline-assembly
104         assembly { size := extcodesize(account) }
105         return size > 0;
106     }
107 
108     /**
109      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
110      * `recipient`, forwarding all available gas and reverting on errors.
111      *
112      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
113      * of certain opcodes, possibly making contracts go over the 2300 gas limit
114      * imposed by `transfer`, making them unable to receive funds via
115      * `transfer`. {sendValue} removes this limitation.
116      *
117      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
118      *
119      * IMPORTANT: because control is transferred to `recipient`, care must be
120      * taken to not create reentrancy vulnerabilities. Consider using
121      * {ReentrancyGuard} or the
122      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
123      */
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
128         (bool success, ) = recipient.call{ value: amount }("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain`call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151       return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but also transferring `value` wei to `target`.
167      *
168      * Requirements:
169      *
170      * - the calling contract must have an ETH balance of at least `value`.
171      * - the called Solidity function must be `payable`.
172      *
173      * _Available since v3.1._
174      */
175     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
181      * with `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
186         require(address(this).balance >= value, "Address: insufficient balance for call");
187         require(isContract(target), "Address: call to non-contract");
188 
189         // solhint-disable-next-line avoid-low-level-calls
190         (bool success, bytes memory returndata) = target.call{ value: value }(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but performing a static call.
197      *
198      * _Available since v3.3._
199      */
200     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
201         return functionStaticCall(target, data, "Address: low-level static call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
211         require(isContract(target), "Address: static call to non-contract");
212 
213         // solhint-disable-next-line avoid-low-level-calls
214         (bool success, bytes memory returndata) = target.staticcall(data);
215         return _verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             // Look for revert reason and bubble it up if present
223             if (returndata.length > 0) {
224                 // The easiest way to bubble the revert reason is using memory via assembly
225 
226                 // solhint-disable-next-line no-inline-assembly
227                 assembly {
228                     let returndata_size := mload(returndata)
229                     revert(add(32, returndata), returndata_size)
230                 }
231             } else {
232                 revert(errorMessage);
233             }
234         }
235     }
236 }
237 
238 /**
239  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
240  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
241  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
242  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
243  *
244  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
245  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
246  *
247  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
248  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
249  */
250 abstract contract Initializable {
251 
252     /**
253      * @dev Indicates that the contract has been initialized.
254      */
255     bool private _initialized;
256 
257     /**
258      * @dev Indicates that the contract is in the process of being initialized.
259      */
260     bool private _initializing;
261 
262     /**
263      * @dev Modifier to protect an initializer function from being invoked twice.
264      */
265     modifier initializer() {
266         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
267 
268         bool isTopLevelCall = !_initializing;
269         if (isTopLevelCall) {
270             _initializing = true;
271             _initialized = true;
272         }
273 
274         _;
275 
276         if (isTopLevelCall) {
277             _initializing = false;
278         }
279     }
280 
281     /// @dev Returns true if and only if the function is running in the constructor
282     function _isConstructor() private view returns (bool) {
283         return !AddressUpgradeable.isContract(address(this));
284     }
285 }
286 
287 /*
288  * @dev Provides information about the current execution context, including the
289  * sender of the transaction and its data. While these are generally available
290  * via msg.sender and msg.data, they should not be accessed in such a direct
291  * manner, since when dealing with GSN meta-transactions the account sending and
292  * paying for execution may not be the actual sender (as far as an application
293  * is concerned).
294  *
295  * This contract is only required for intermediate, library-like contracts.
296  */
297 abstract contract ContextUpgradeable is Initializable {
298     function __Context_init() internal initializer {
299         __Context_init_unchained();
300     }
301 
302     function __Context_init_unchained() internal initializer {
303     }
304     function _msgSender() internal view virtual returns (address payable) {
305         return payable(msg.sender);
306     }
307 
308     function _msgData() internal view virtual returns (bytes memory) {
309         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
310         return msg.data;
311     }
312     uint256[50] private __gap;
313 }
314 
315 /**
316  * @dev Contract module which provides a basic access control mechanism, where
317  * there is an account (an owner) that can be granted exclusive access to
318  * specific functions.
319  *
320  * By default, the owner account will be the one that deploys the contract. This
321  * can later be changed with {transferOwnership}.
322  *
323  * This module is used through inheritance. It will make available the modifier
324  * `onlyOwner`, which can be applied to your functions to restrict their use to
325  * the owner.
326  */
327 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
328     address private _owner;
329 
330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
331 
332     /**
333      * @dev Initializes the contract setting the deployer as the initial owner.
334      */
335     function __Ownable_init() internal initializer {
336         __Context_init_unchained();
337         __Ownable_init_unchained();
338     }
339 
340     function __Ownable_init_unchained() internal initializer {
341         address msgSender = _msgSender();
342         _owner = msgSender;
343         emit OwnershipTransferred(address(0), msgSender);
344     }
345 
346     /**
347      * @dev Returns the address of the current owner.
348      */
349     function owner() public view virtual returns (address) {
350         return _owner;
351     }
352 
353     /**
354      * @dev Throws if called by any account other than the owner.
355      */
356     modifier onlyOwner() {
357         require(owner() == _msgSender(), "Ownable: caller is not the owner");
358         _;
359     }
360 
361     /**
362      * @dev Leaves the contract without owner. It will not be possible to call
363      * `onlyOwner` functions anymore. Can only be called by the current owner.
364      *
365      * NOTE: Renouncing ownership will leave the contract without an owner,
366      * thereby removing any functionality that is only available to the owner.
367      */
368     function renounceOwnership() public virtual onlyOwner {
369         emit OwnershipTransferred(_owner, address(0));
370         _owner = address(0);
371     }
372 
373     /**
374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
375      * Can only be called by the current owner.
376      */
377     function transferOwnership(address newOwner) public virtual onlyOwner {
378         require(newOwner != address(0), "Ownable: new owner is the zero address");
379         emit OwnershipTransferred(_owner, newOwner);
380         _owner = newOwner;
381     }
382     uint256[49] private __gap;
383 }
384 
385 /**
386  * @dev Wrappers over Solidity's arithmetic operations with added overflow
387  * checks.
388  *
389  * Arithmetic operations in Solidity wrap on overflow. This can easily result
390  * in bugs, because programmers usually assume that an overflow raises an
391  * error, which is the standard behavior in high level programming languages.
392  * `SafeMath` restores this intuition by reverting the transaction when an
393  * operation overflows.
394  *
395  * Using this library instead of the unchecked operations eliminates an entire
396  * class of bugs, so it's recommended to use it always.
397  */
398 library SafeMath {
399     /**
400      * @dev Returns the addition of two unsigned integers, with an overflow flag.
401      *
402      * _Available since v3.4._
403      */
404     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
405         uint256 c = a + b;
406         if (c < a) return (false, 0);
407         return (true, c);
408     }
409 
410     /**
411      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
412      *
413      * _Available since v3.4._
414      */
415     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
416         if (b > a) return (false, 0);
417         return (true, a - b);
418     }
419 
420     /**
421      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
422      *
423      * _Available since v3.4._
424      */
425     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
426         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
427         // benefit is lost if 'b' is also tested.
428         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
429         if (a == 0) return (true, 0);
430         uint256 c = a * b;
431         if (c / a != b) return (false, 0);
432         return (true, c);
433     }
434 
435     /**
436      * @dev Returns the division of two unsigned integers, with a division by zero flag.
437      *
438      * _Available since v3.4._
439      */
440     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
441         if (b == 0) return (false, 0);
442         return (true, a / b);
443     }
444 
445     /**
446      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
447      *
448      * _Available since v3.4._
449      */
450     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
451         if (b == 0) return (false, 0);
452         return (true, a % b);
453     }
454 
455     /**
456      * @dev Returns the addition of two unsigned integers, reverting on
457      * overflow.
458      *
459      * Counterpart to Solidity's `+` operator.
460      *
461      * Requirements:
462      *
463      * - Addition cannot overflow.
464      */
465     function add(uint256 a, uint256 b) internal pure returns (uint256) {
466         uint256 c = a + b;
467         require(c >= a, "SafeMath: addition overflow");
468         return c;
469     }
470 
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting on
473      * overflow (when the result is negative).
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
482         require(b <= a, "SafeMath: subtraction overflow");
483         return a - b;
484     }
485 
486     /**
487      * @dev Returns the multiplication of two unsigned integers, reverting on
488      * overflow.
489      *
490      * Counterpart to Solidity's `*` operator.
491      *
492      * Requirements:
493      *
494      * - Multiplication cannot overflow.
495      */
496     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
497         if (a == 0) return 0;
498         uint256 c = a * b;
499         require(c / a == b, "SafeMath: multiplication overflow");
500         return c;
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers, reverting on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      *
513      * - The divisor cannot be zero.
514      */
515     function div(uint256 a, uint256 b) internal pure returns (uint256) {
516         require(b > 0, "SafeMath: division by zero");
517         return a / b;
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * reverting when dividing by zero.
523      *
524      * Counterpart to Solidity's `%` operator. This function uses a `revert`
525      * opcode (which leaves remaining gas untouched) while Solidity uses an
526      * invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
533         require(b > 0, "SafeMath: modulo by zero");
534         return a % b;
535     }
536 
537     /**
538      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
539      * overflow (when the result is negative).
540      *
541      * CAUTION: This function is deprecated because it requires allocating memory for the error
542      * message unnecessarily. For custom revert reasons use {trySub}.
543      *
544      * Counterpart to Solidity's `-` operator.
545      *
546      * Requirements:
547      *
548      * - Subtraction cannot overflow.
549      */
550     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
551         require(b <= a, errorMessage);
552         return a - b;
553     }
554 
555     /**
556      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * CAUTION: This function is deprecated because it requires allocating memory for the error
560      * message unnecessarily. For custom revert reasons use {tryDiv}.
561      *
562      * Counterpart to Solidity's `/` operator. Note: this function uses a
563      * `revert` opcode (which leaves remaining gas untouched) while Solidity
564      * uses an invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
571         require(b > 0, errorMessage);
572         return a / b;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * reverting with custom message when dividing by zero.
578      *
579      * CAUTION: This function is deprecated because it requires allocating memory for the error
580      * message unnecessarily. For custom revert reasons use {tryMod}.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
591         require(b > 0, errorMessage);
592         return a % b;
593     }
594 }
595 
596 /**
597  * @dev Collection of functions related to the address type
598  */
599 library Address {
600     /**
601      * @dev Returns true if `account` is a contract.
602      *
603      * [IMPORTANT]
604      * ====
605      * It is unsafe to assume that an address for which this function returns
606      * false is an externally-owned account (EOA) and not a contract.
607      *
608      * Among others, `isContract` will return false for the following
609      * types of addresses:
610      *
611      *  - an externally-owned account
612      *  - a contract in construction
613      *  - an address where a contract will be created
614      *  - an address where a contract lived, but was destroyed
615      * ====
616      */
617     function isContract(address account) internal view returns (bool) {
618         // This method relies on extcodesize, which returns 0 for contracts in
619         // construction, since the code is only stored at the end of the
620         // constructor execution.
621 
622         uint256 size;
623         // solhint-disable-next-line no-inline-assembly
624         assembly { size := extcodesize(account) }
625         return size > 0;
626     }
627 
628     /**
629      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
630      * `recipient`, forwarding all available gas and reverting on errors.
631      *
632      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
633      * of certain opcodes, possibly making contracts go over the 2300 gas limit
634      * imposed by `transfer`, making them unable to receive funds via
635      * `transfer`. {sendValue} removes this limitation.
636      *
637      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
638      *
639      * IMPORTANT: because control is transferred to `recipient`, care must be
640      * taken to not create reentrancy vulnerabilities. Consider using
641      * {ReentrancyGuard} or the
642      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
643      */
644     function sendValue(address payable recipient, uint256 amount) internal {
645         require(address(this).balance >= amount, "Address: insufficient balance");
646 
647         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
648         (bool success, ) = recipient.call{ value: amount }("");
649         require(success, "Address: unable to send value, recipient may have reverted");
650     }
651 
652     /**
653      * @dev Performs a Solidity function call using a low level `call`. A
654      * plain`call` is an unsafe replacement for a function call: use this
655      * function instead.
656      *
657      * If `target` reverts with a revert reason, it is bubbled up by this
658      * function (like regular Solidity function calls).
659      *
660      * Returns the raw returned data. To convert to the expected return value,
661      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
662      *
663      * Requirements:
664      *
665      * - `target` must be a contract.
666      * - calling `target` with `data` must not revert.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
671       return functionCall(target, data, "Address: low-level call failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
676      * `errorMessage` as a fallback revert reason when `target` reverts.
677      *
678      * _Available since v3.1._
679      */
680     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
681         return functionCallWithValue(target, data, 0, errorMessage);
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
686      * but also transferring `value` wei to `target`.
687      *
688      * Requirements:
689      *
690      * - the calling contract must have an ETH balance of at least `value`.
691      * - the called Solidity function must be `payable`.
692      *
693      * _Available since v3.1._
694      */
695     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
701      * with `errorMessage` as a fallback revert reason when `target` reverts.
702      *
703      * _Available since v3.1._
704      */
705     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
706         require(address(this).balance >= value, "Address: insufficient balance for call");
707         require(isContract(target), "Address: call to non-contract");
708 
709         // solhint-disable-next-line avoid-low-level-calls
710         (bool success, bytes memory returndata) = target.call{ value: value }(data);
711         return _verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but performing a static call.
717      *
718      * _Available since v3.3._
719      */
720     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
721         return functionStaticCall(target, data, "Address: low-level static call failed");
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
726      * but performing a static call.
727      *
728      * _Available since v3.3._
729      */
730     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
731         require(isContract(target), "Address: static call to non-contract");
732 
733         // solhint-disable-next-line avoid-low-level-calls
734         (bool success, bytes memory returndata) = target.staticcall(data);
735         return _verifyCallResult(success, returndata, errorMessage);
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
740      * but performing a delegate call.
741      *
742      * _Available since v3.4._
743      */
744     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
745         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
750      * but performing a delegate call.
751      *
752      * _Available since v3.4._
753      */
754     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
755         require(isContract(target), "Address: delegate call to non-contract");
756 
757         // solhint-disable-next-line avoid-low-level-calls
758         (bool success, bytes memory returndata) = target.delegatecall(data);
759         return _verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
763         if (success) {
764             return returndata;
765         } else {
766             // Look for revert reason and bubble it up if present
767             if (returndata.length > 0) {
768                 // The easiest way to bubble the revert reason is using memory via assembly
769 
770                 // solhint-disable-next-line no-inline-assembly
771                 assembly {
772                     let returndata_size := mload(returndata)
773                     revert(add(32, returndata), returndata_size)
774                 }
775             } else {
776                 revert(errorMessage);
777             }
778         }
779     }
780 }
781 
782 interface IUniswapV2Factory {
783     event PairCreated(
784         address indexed token0,
785         address indexed token1,
786         address pair,
787         uint256
788     );
789 
790     function feeTo() external view returns (address);
791 
792     function feeToSetter() external view returns (address);
793 
794     function getPair(address tokenA, address tokenB)
795         external
796         view
797         returns (address pair);
798 
799     function allPairs(uint256) external view returns (address pair);
800 
801     function allPairsLength() external view returns (uint256);
802 
803     function createPair(address tokenA, address tokenB)
804         external
805         returns (address pair);
806 
807     function setFeeTo(address) external;
808 
809     function setFeeToSetter(address) external;
810 }
811 
812 interface IUniswapV2Router01 {
813     function factory() external pure returns (address);
814 
815     function WETH() external pure returns (address);
816 
817     function addLiquidity(
818         address tokenA,
819         address tokenB,
820         uint256 amountADesired,
821         uint256 amountBDesired,
822         uint256 amountAMin,
823         uint256 amountBMin,
824         address to,
825         uint256 deadline
826     )
827         external
828         returns (
829             uint256 amountA,
830             uint256 amountB,
831             uint256 liquidity
832         );
833 
834     function addLiquidityETH(
835         address token,
836         uint256 amountTokenDesired,
837         uint256 amountTokenMin,
838         uint256 amountETHMin,
839         address to,
840         uint256 deadline
841     )
842         external
843         payable
844         returns (
845             uint256 amountToken,
846             uint256 amountETH,
847             uint256 liquidity
848         );
849 
850     function removeLiquidity(
851         address tokenA,
852         address tokenB,
853         uint256 liquidity,
854         uint256 amountAMin,
855         uint256 amountBMin,
856         address to,
857         uint256 deadline
858     ) external returns (uint256 amountA, uint256 amountB);
859 
860     function removeLiquidityETH(
861         address token,
862         uint256 liquidity,
863         uint256 amountTokenMin,
864         uint256 amountETHMin,
865         address to,
866         uint256 deadline
867     ) external returns (uint256 amountToken, uint256 amountETH);
868 
869     function removeLiquidityWithPermit(
870         address tokenA,
871         address tokenB,
872         uint256 liquidity,
873         uint256 amountAMin,
874         uint256 amountBMin,
875         address to,
876         uint256 deadline,
877         bool approveMax,
878         uint8 v,
879         bytes32 r,
880         bytes32 s
881     ) external returns (uint256 amountA, uint256 amountB);
882 
883     function removeLiquidityETHWithPermit(
884         address token,
885         uint256 liquidity,
886         uint256 amountTokenMin,
887         uint256 amountETHMin,
888         address to,
889         uint256 deadline,
890         bool approveMax,
891         uint8 v,
892         bytes32 r,
893         bytes32 s
894     ) external returns (uint256 amountToken, uint256 amountETH);
895 
896     function swapExactTokensForTokens(
897         uint256 amountIn,
898         uint256 amountOutMin,
899         address[] calldata path,
900         address to,
901         uint256 deadline
902     ) external returns (uint256[] memory amounts);
903 
904     function swapTokensForExactTokens(
905         uint256 amountOut,
906         uint256 amountInMax,
907         address[] calldata path,
908         address to,
909         uint256 deadline
910     ) external returns (uint256[] memory amounts);
911 
912     function swapExactETHForTokens(
913         uint256 amountOutMin,
914         address[] calldata path,
915         address to,
916         uint256 deadline
917     ) external payable returns (uint256[] memory amounts);
918 
919     function swapTokensForExactETH(
920         uint256 amountOut,
921         uint256 amountInMax,
922         address[] calldata path,
923         address to,
924         uint256 deadline
925     ) external returns (uint256[] memory amounts);
926 
927     function swapExactTokensForETH(
928         uint256 amountIn,
929         uint256 amountOutMin,
930         address[] calldata path,
931         address to,
932         uint256 deadline
933     ) external returns (uint256[] memory amounts);
934 
935     function swapETHForExactTokens(
936         uint256 amountOut,
937         address[] calldata path,
938         address to,
939         uint256 deadline
940     ) external payable returns (uint256[] memory amounts);
941 
942     function quote(
943         uint256 amountA,
944         uint256 reserveA,
945         uint256 reserveB
946     ) external pure returns (uint256 amountB);
947 
948     function getAmountOut(
949         uint256 amountIn,
950         uint256 reserveIn,
951         uint256 reserveOut
952     ) external pure returns (uint256 amountOut);
953 
954     function getAmountIn(
955         uint256 amountOut,
956         uint256 reserveIn,
957         uint256 reserveOut
958     ) external pure returns (uint256 amountIn);
959 
960     function getAmountsOut(uint256 amountIn, address[] calldata path)
961         external
962         view
963         returns (uint256[] memory amounts);
964 
965     function getAmountsIn(uint256 amountOut, address[] calldata path)
966         external
967         view
968         returns (uint256[] memory amounts);
969 }
970 
971 interface IUniswapV2Router02 is IUniswapV2Router01 {
972     function removeLiquidityETHSupportingFeeOnTransferTokens(
973         address token,
974         uint256 liquidity,
975         uint256 amountTokenMin,
976         uint256 amountETHMin,
977         address to,
978         uint256 deadline
979     ) external returns (uint256 amountETH);
980 
981     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
982         address token,
983         uint256 liquidity,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline,
988         bool approveMax,
989         uint8 v,
990         bytes32 r,
991         bytes32 s
992     ) external returns (uint256 amountETH);
993 
994     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
995         uint256 amountIn,
996         uint256 amountOutMin,
997         address[] calldata path,
998         address to,
999         uint256 deadline
1000     ) external;
1001 
1002     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external payable;
1008 
1009     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1010         uint256 amountIn,
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external;
1016 }
1017 
1018 interface IUniswapV2Pair {
1019     event Approval(address indexed owner, address indexed spender, uint value);
1020     event Transfer(address indexed from, address indexed to, uint value);
1021 
1022     function name() external pure returns (string memory);
1023     function symbol() external pure returns (string memory);
1024     function decimals() external pure returns (uint8);
1025     function totalSupply() external view returns (uint);
1026     function balanceOf(address owner) external view returns (uint);
1027     function allowance(address owner, address spender) external view returns (uint);
1028 
1029     function approve(address spender, uint value) external returns (bool);
1030     function transfer(address to, uint value) external returns (bool);
1031     function transferFrom(address from, address to, uint value) external returns (bool);
1032 
1033     function DOMAIN_SEPARATOR() external view returns (bytes32);
1034     function PERMIT_TYPEHASH() external pure returns (bytes32);
1035     function nonces(address owner) external view returns (uint);
1036 
1037     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1038 
1039     event Mint(address indexed sender, uint amount0, uint amount1);
1040     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1041     event Swap(
1042         address indexed sender,
1043         uint amount0In,
1044         uint amount1In,
1045         uint amount0Out,
1046         uint amount1Out,
1047         address indexed to
1048     );
1049     event Sync(uint112 reserve0, uint112 reserve1);
1050 
1051     function MINIMUM_LIQUIDITY() external pure returns (uint);
1052     function factory() external view returns (address);
1053     function token0() external view returns (address);
1054     function token1() external view returns (address);
1055     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1056     function price0CumulativeLast() external view returns (uint);
1057     function price1CumulativeLast() external view returns (uint);
1058     function kLast() external view returns (uint);
1059 
1060     function mint(address to) external returns (uint liquidity);
1061     function burn(address to) external returns (uint amount0, uint amount1);
1062     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1063     function skim(address to) external;
1064     function sync() external;
1065 
1066     function initialize(address, address) external;
1067 }
1068 
1069 pragma solidity ^0.8.9;
1070 
1071 contract Ridge is IERC20Upgradeable, OwnableUpgradeable {
1072     using SafeMath for uint256;
1073     using Address for address;
1074 
1075     mapping (address => uint256) private _rOwned;
1076     mapping (address => uint256) private _tOwned;
1077     mapping (address => mapping (address => uint256)) private _allowances;
1078     mapping (address => bool) private _isExcludedFromFee;
1079     mapping (address => bool) private _isExcludedFromMaxTx;
1080     mapping (address => bool) private _isExcluded;
1081     address[] private _excluded;
1082     uint256 private constant MAX = ~uint256(0);
1083     uint256 private _tTotal;
1084     uint256 private _rTotal;
1085     uint256 private _tFeeTotal;
1086     string private _name;
1087     string private _symbol;
1088     uint8 private _decimals;
1089     uint256 public _maxTxAmount;
1090     uint256 public _taxFee;
1091     uint256 private _previousTaxFee = _taxFee;
1092     uint256 public _liquidityFee;
1093     uint256 private _previousLiquidityFee = _liquidityFee;
1094     uint256 public _charityFee;
1095     uint256 private _previousCharityFee = _charityFee;
1096     uint256 public _marketingFee;
1097     uint256 private _previousMarketingFee = _marketingFee;
1098     address public _charityAddress;
1099     address public _marketingAddress;
1100     address public uniswapV2Pair;
1101     IUniswapV2Router02 public uniswapV2Router;
1102     
1103     bool inSwapAndLiquify;
1104     bool public swapAndLiquifyEnabled = false;
1105     uint256 private numTokensSellToAddToLiquidity;
1106 
1107     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1108     event SwapAndLiquifyEnabledUpdated(bool enabled);
1109     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
1110     
1111     modifier lockTheSwap {
1112         inSwapAndLiquify = true;
1113         _;
1114         inSwapAndLiquify = false;
1115     }
1116     
1117     function initialize () external initializer {
1118         string memory name_ = "Ridge" ;                             
1119         string memory symbol_ = "RIDGE";
1120         uint256 totalSupply_ = 1000000000000* 10**9;                                // 1000000000000 -> 1 trillion
1121         address owner_ = 0x0638eaA4FcCbe1b3fCd532D03162D39F9698ac49;                // Owner address.
1122         address router_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;              // Uniswap Router
1123         address charityAddress_ = 0x8D4FEAA1a03F2136B8C9C9dd736171214a86753d;       // Charity wallet addresss.
1124         address marketingAddress_ = 0xA60b690237F39997681bd3551998c47F7747fCc6;     // Marketing wallet address.
1125         uint16 taxFeeBps_ = 100;                                                    // Tax fee.
1126         uint16 liquidityFeeBps_ = 400;                                              // Liquidity fee.
1127         uint16 charityFeeBps_ = 100;                                                // Charity fee.
1128         uint16 marketingFeeBps_ = 600;                                              // Mrketing fee.
1129         uint16 maxTxBps_ = 400;                                                     // Max transaction.
1130 
1131         require(taxFeeBps_ >= 0 && taxFeeBps_ <= 10**4, "Invalid tax fee.");
1132         require(liquidityFeeBps_ >= 0 && liquidityFeeBps_ <= 10**4, "Invalid liquidity fee.");
1133         require(charityFeeBps_ >= 0 && charityFeeBps_ <= 10**4, "Invalid charity fee.");
1134         require(marketingFeeBps_ >= 0 && marketingFeeBps_ <= 10**4, "Invalit marketing fee.");
1135         require(maxTxBps_ > 0 && maxTxBps_ <= 10**4, "Invalid max tx amount.");
1136         require(taxFeeBps_ + liquidityFeeBps_ + charityFeeBps_  + marketingFeeBps_ <= 10**4, "Total fee is over 100% of transfer amount.");
1137 
1138         OwnableUpgradeable.__Ownable_init();
1139         transferOwnership(owner_); 
1140 
1141         _name = name_;
1142         _symbol = symbol_;
1143         _decimals = 9;
1144         _tTotal = totalSupply_;
1145         _rTotal = (MAX - (MAX % _tTotal));
1146         _taxFee = taxFeeBps_;
1147         _previousTaxFee = _taxFee;
1148         _liquidityFee = liquidityFeeBps_;
1149         _previousLiquidityFee = _liquidityFee;
1150         _charityAddress = charityAddress_;
1151         _charityFee = charityFeeBps_;
1152         _previousCharityFee = _charityFee;
1153         _marketingAddress = marketingAddress_;
1154         _marketingFee = marketingFeeBps_;
1155         _previousMarketingFee = _marketingFee;
1156 
1157         _maxTxAmount = totalSupply_.mul(maxTxBps_).div(10**4);
1158         numTokensSellToAddToLiquidity = totalSupply_.mul(5).div(10**4); // 0.05%
1159         
1160         _rOwned[owner()] = _rTotal;
1161         
1162         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
1163          // Create a uniswap pair for this new token.
1164         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1165         uniswapV2Router = _uniswapV2Router;
1166         
1167         // Exclude Owner and this contract from fee.
1168         _isExcludedFromFee[owner()] = true;
1169         _isExcludedFromFee[address(this)] = true;
1170 
1171         // Exclude Owner, Dead, Contract, Marketing, Charity from max TX amount.
1172         _isExcludedFromMaxTx[address(this)] = true;
1173         _isExcludedFromMaxTx[address(0xdead)] = true;
1174         _isExcludedFromMaxTx[address(0)] = true;
1175         _isExcludedFromMaxTx[address(_marketingAddress)] = true;
1176         _isExcludedFromMaxTx[address(_charityAddress)] = true;
1177         
1178         emit Transfer(address(0), owner(), _tTotal);
1179     }
1180 
1181     function name() public view returns (string memory) {
1182         return _name;
1183     }
1184 
1185     function symbol() public view returns (string memory) {
1186         return _symbol;
1187     }
1188 
1189     function decimals() public view returns (uint8) {
1190         return _decimals;
1191     }
1192 
1193     function totalSupply() public view override returns (uint256) {
1194         return _tTotal;
1195     }
1196 
1197     function balanceOf(address account) public view override returns (uint256) {
1198         if (_isExcluded[account]) return _tOwned[account];
1199         return tokenFromReflection(_rOwned[account]);
1200     }
1201 
1202     function transfer(address recipient, uint256 amount) public override returns (bool) {
1203         _transfer(_msgSender(), recipient, amount);
1204         return true;
1205     }
1206 
1207     function allowance(address owner, address spender) public view override returns (uint256) {
1208         return _allowances[owner][spender];
1209     }
1210 
1211     function approve(address spender, uint256 amount) public override returns (bool) {
1212         _approve(_msgSender(), spender, amount);
1213         return true;
1214     }
1215 
1216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1217         _transfer(sender, recipient, amount);
1218         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1219         return true;
1220     }
1221 
1222     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1223         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1224         return true;
1225     }
1226 
1227     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1228         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1229         return true;
1230     }
1231 
1232     function isExcludedFromReward(address account) public view returns (bool) {
1233         return _isExcluded[account];
1234     }
1235 
1236     function totalFees() public view returns (uint256) {
1237         return _tFeeTotal;
1238     }
1239 
1240     function deliver(uint256 tAmount) public {
1241         address sender = _msgSender();
1242         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1243         
1244         (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1245         (uint256 rAmount,,) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1246         
1247         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1248         _rTotal = _rTotal.sub(rAmount);
1249         _tFeeTotal = _tFeeTotal.add(tAmount);
1250     }
1251 
1252     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1253         require(tAmount <= _tTotal, "Amount must be less than supply");
1254         if (!deductTransferFee) {
1255             (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1256             (uint256 rAmount,,) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1257             return rAmount;
1258         } else {
1259             (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1260             (,uint256 rTransferAmount,) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1261             return rTransferAmount;
1262         }
1263     }
1264 
1265     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1266         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1267         uint256 currentRate =  _getRate();
1268         return rAmount.div(currentRate);
1269     }
1270 
1271     function excludeFromReward(address account) public onlyOwner() {
1272         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.'); // TODO: check this one up
1273         require(!_isExcluded[account], "Account is already excluded");
1274         if(_rOwned[account] > 0) {
1275             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1276         }
1277         _isExcluded[account] = true;
1278         _excluded.push(account);
1279     }
1280 
1281     function includeInReward(address account) external onlyOwner() {
1282         require(_isExcluded[account], "Account is already excluded");
1283         for (uint256 i = 0; i < _excluded.length; i++) {
1284             if (_excluded[i] == account) {
1285                 _excluded[i] = _excluded[_excluded.length - 1];
1286                 _tOwned[account] = 0;
1287                 _isExcluded[account] = false;
1288                 _excluded.pop();
1289                 break;
1290             }
1291         }
1292     }
1293 
1294     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1295         (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1296         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tCharity).sub(tMarketing);
1297         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1298         
1299         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1300         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1301         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1302         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1303         _takeLiquidity(tLiquidity);
1304         _takeCharityFee(tCharity);
1305         _takeMarketingFee(tMarketing);
1306         _reflectFee(rFee, tFee);
1307         emit Transfer(sender, recipient, tTransferAmount);
1308     }
1309     
1310     function excludeFromFee(address account) public onlyOwner {
1311         _isExcludedFromFee[account] = true;
1312     }
1313     
1314     function includeInFee(address account) public onlyOwner {
1315         _isExcludedFromFee[account] = false;
1316     }
1317 
1318     function setExcludeFromMaxTx(address account, bool exclude) public onlyOwner { 
1319         _isExcludedFromMaxTx[account] = exclude;
1320     }
1321 
1322     function isExcludedFromMaxTx(address account) public view returns (bool) {
1323         return _isExcludedFromMaxTx[account];
1324     }
1325     
1326     function setTaxFeePercent(uint256 taxFeeBps) external onlyOwner() {
1327         require(taxFeeBps >= 0 && taxFeeBps <= 10**4, "Invalid bps");
1328         _taxFee = taxFeeBps;
1329     }
1330     
1331     function setLiquidityFeePercent(uint256 liquidityFeeBps) external onlyOwner() {
1332         require(liquidityFeeBps >= 0 && liquidityFeeBps <= 10**4, "Invalid bps");
1333         _liquidityFee = liquidityFeeBps;
1334     }
1335 
1336     function setCharityFeePercent(uint256 charityFeeBps) external onlyOwner() {
1337         require(charityFeeBps >= 0 && charityFeeBps <= 10**4, "Invalid bps");
1338         _charityFee = charityFeeBps;
1339     }
1340     
1341     function setMarketingFeePercent(uint256 marketingFeeBps) external onlyOwner() {
1342         require(marketingFeeBps >= 0 && marketingFeeBps <= 10**4, "Invalid bps");
1343         _marketingFee = marketingFeeBps;
1344     }
1345 
1346     function setMaxTxPercent(uint256 maxTxBps) external onlyOwner() {
1347         require(maxTxBps >= 0 && maxTxBps <= 10**4, "Invalid bps");
1348         _maxTxAmount = _tTotal.mul(maxTxBps).div(10**4);
1349     }
1350 
1351     function setMarketingWallet(address account) external onlyOwner() {
1352         if (account == address(0)) {
1353             require(_marketingFee == 0, "Cant set both marketing address to address 0 while markeing percent more than 0.");
1354         }
1355         _marketingAddress = account;
1356     }
1357 
1358     function setCharityWallet(address account) external onlyOwner() {
1359         if (account == address(0)) {
1360             require(_charityFee == 0, "Cant set both charity address to address 0 while charity percent more than 0.");
1361         }
1362         _charityAddress = account;
1363     }
1364 
1365     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1366         swapAndLiquifyEnabled = _enabled;
1367         emit SwapAndLiquifyEnabledUpdated(_enabled);
1368     }
1369     
1370      // To recieve ETH from uniswapV2Router when swaping.
1371     receive() external payable {}
1372 
1373     function _reflectFee(uint256 rFee, uint256 tFee) private {
1374         _rTotal = _rTotal.sub(rFee);
1375         _tFeeTotal = _tFeeTotal.add(tFee);
1376     }
1377 
1378     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1379         uint256 tFee = calculateTaxFee(tAmount);
1380         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1381         uint256 tCharityFee = calculateCharityFee(tAmount);
1382         uint256 tMarketingFee = calculateMarketingFee(tAmount);
1383         return (tFee, tLiquidity, tCharityFee, tMarketingFee);
1384     }
1385 
1386     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1387         uint256 rAmount = tAmount.mul(currentRate);
1388         uint256 rFee = tFee.mul(currentRate);
1389         uint256 rLiquidity = tLiquidity.mul(currentRate);
1390         uint256 rCharity = tCharity.mul(currentRate);
1391         uint256 rMarketing = tMarketing.mul(currentRate);
1392         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rCharity).sub(rMarketing);
1393         return (rAmount, rTransferAmount, rFee);
1394     }
1395 
1396     function _getRate() private view returns(uint256) {
1397         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1398         return rSupply.div(tSupply);
1399     }
1400 
1401     function _getCurrentSupply() private view returns(uint256, uint256) {
1402         uint256 rSupply = _rTotal;
1403         uint256 tSupply = _tTotal;      
1404         for (uint256 i = 0; i < _excluded.length; i++) {
1405             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1406             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1407             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1408         }
1409         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1410         return (rSupply, tSupply);
1411     }
1412     
1413     function _takeLiquidity(uint256 tLiquidity) private {
1414         uint256 currentRate =  _getRate();
1415         uint256 rLiquidity = tLiquidity.mul(currentRate);
1416         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1417         if(_isExcluded[address(this)])
1418             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1419     }
1420 
1421     function _takeCharityFee(uint256 tCharity) private {
1422         if (tCharity > 0 ) {
1423             uint256 currentRate =  _getRate();
1424             uint256 rCharity = tCharity.mul(currentRate);
1425             _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
1426             if (_isExcluded[_charityAddress])
1427                 _tOwned[_charityAddress] = _tOwned[_charityAddress].add(tCharity);
1428             emit Transfer(_msgSender(), _charityAddress, tCharity);
1429         }
1430     }
1431 
1432     function _takeMarketingFee(uint256 tMarketing) private {
1433         if(tMarketing > 0){
1434             uint256 currentRate = _getRate();
1435             uint256 rMarketing = tMarketing.mul(currentRate);
1436             _rOwned[_marketingAddress] = _rOwned[_marketingAddress].add(rMarketing);
1437 
1438             if(_isExcluded[_marketingAddress])
1439                 _tOwned[_marketingAddress] = _tOwned[_marketingAddress].add(tMarketing);
1440 
1441             emit Transfer(_msgSender(), _marketingAddress, tMarketing);
1442         }
1443     }
1444     
1445     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1446         return _amount.mul(_taxFee).div(10**4);
1447     }
1448 
1449     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1450         return _amount.mul(_liquidityFee).div(10**4);
1451     }
1452 
1453     function calculateCharityFee(uint256 _amount) private view returns (uint256) {
1454         if (_charityAddress == address(0)) return 0;
1455         return _amount.mul(_charityFee).div(10**4);
1456     }
1457 
1458     function calculateMarketingFee(uint256 _amount) private view returns (uint256){
1459         if(_marketingAddress == address(0)) return 0;
1460         return _amount.mul(_marketingFee).div(10**4);
1461     }
1462     
1463     function removeAllFee() private {
1464         if(_taxFee == 0 && _liquidityFee == 0 && _charityFee == 0 && _marketingFee == 0) return;
1465         
1466         _previousTaxFee = _taxFee;
1467         _previousLiquidityFee = _liquidityFee;
1468         _previousCharityFee = _charityFee;
1469         _previousMarketingFee = _marketingFee;
1470         
1471         _taxFee = 0;
1472         _liquidityFee = 0;
1473         _charityFee = 0;
1474         _marketingFee = 0;
1475     }
1476     
1477     function restoreAllFee() private {
1478         _taxFee = _previousTaxFee;
1479         _liquidityFee = _previousLiquidityFee;
1480         _charityFee = _previousCharityFee;
1481         _marketingFee = _previousMarketingFee;
1482     }
1483     
1484     function isExcludedFromFee(address account) public view returns(bool) {
1485         return _isExcludedFromFee[account];
1486     }
1487 
1488     function _approve(address owner, address spender, uint256 amount) private {
1489         require(owner != address(0), "ERC20: approve from the zero address");
1490         require(spender != address(0), "ERC20: approve to the zero address");
1491 
1492         _allowances[owner][spender] = amount;
1493         emit Approval(owner, spender, amount);
1494     }
1495 
1496     function _transfer(address from, address to, uint256 amount) private {
1497         require(from != address(0), "ERC20: transfer from the zero address");
1498         require(to != address(0), "ERC20: transfer to the zero address");
1499         require(amount > 0, "Transfer amount must be greater than zero");
1500 
1501         if (from != owner() && to != owner()) {
1502             if (!_isExcludedFromMaxTx[from] && !_isExcludedFromMaxTx[to]) {
1503                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1504             }
1505         }
1506 
1507         // Is the token balance of this contract address over the min number of
1508         // tokens that we need to initiate a swap + liquidity lock?
1509         // Don't get caught in a circular liquidity event.
1510         // Don't swap & liquify if sender is uniswap pair.
1511         uint256 contractTokenBalance = balanceOf(address(this));
1512         
1513         if(contractTokenBalance >= _maxTxAmount)
1514         {
1515             contractTokenBalance = _maxTxAmount;
1516         }
1517         
1518         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1519         if (
1520             overMinTokenBalance &&
1521             !inSwapAndLiquify &&
1522             from != uniswapV2Pair &&
1523             swapAndLiquifyEnabled
1524         ) {
1525             contractTokenBalance = numTokensSellToAddToLiquidity;
1526             // Add liquidity.
1527             swapAndLiquify(contractTokenBalance);
1528         }
1529         
1530         bool takeFee = true;
1531         
1532         // If any account belongs to _isExcludedFromFee account, remove the fee.
1533         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1534             takeFee = false;
1535         }
1536         
1537         // Transfer amount, it will take tax, burn, liquidity, marketing, charity fee.
1538         _tokenTransfer(from,to,amount,takeFee);
1539     }
1540 
1541     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1542         // Split the contract balance into halves.
1543         uint256 half = contractTokenBalance.div(2);
1544         uint256 otherHalf = contractTokenBalance.sub(half);
1545 
1546         // Capture the contract's current ETH balance.
1547         // Include only swap created ETH and exclude manually transfered ETH.
1548         uint256 initialBalance = address(this).balance;
1549 
1550         // Swap tokens for ETH.
1551         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1552 
1553         // How much ETH did we just swap into?
1554         uint256 newBalance = address(this).balance.sub(initialBalance);
1555 
1556         // Add liquidity to uniswap.
1557         addLiquidity(otherHalf, newBalance);
1558         
1559         emit SwapAndLiquify(half, newBalance, otherHalf);
1560     }
1561 
1562     function swapTokensForEth(uint256 tokenAmount) private {
1563         // Generate the uniswap pair path of token -> weth
1564         address[] memory path = new address[](2);
1565         path[0] = address(this);
1566         path[1] = uniswapV2Router.WETH();
1567 
1568         _approve(address(this), address(uniswapV2Router), tokenAmount);
1569 
1570         // Do the swap.
1571         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1572             tokenAmount,
1573             0, // Accept any amount of ETH.
1574             path,
1575             address(this),
1576             block.timestamp
1577         );
1578     }
1579 
1580     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1581         // Approve token transfer.
1582         _approve(address(this), address(uniswapV2Router), tokenAmount);
1583 
1584         // Add the liquidity.
1585         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1586             address(this),
1587             tokenAmount,
1588             0, // Slippage is unavoidable.
1589             0, // Slippage is unavoidable.
1590             owner(),
1591             block.timestamp
1592         );
1593     }
1594 
1595     // This method is responsible for taking all fee, if takeFee is set to true.
1596     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1597         if(!takeFee)
1598             removeAllFee();
1599         
1600         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1601             _transferFromExcluded(sender, recipient, amount);
1602         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1603             _transferToExcluded(sender, recipient, amount);
1604         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1605             _transferStandard(sender, recipient, amount);
1606         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1607             _transferBothExcluded(sender, recipient, amount);
1608         } else {
1609             _transferStandard(sender, recipient, amount);
1610         }
1611         
1612         if(!takeFee)
1613             restoreAllFee();
1614     }
1615 
1616     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1617         (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1618         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tCharity).sub(tMarketing);
1619         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1620         
1621         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1622         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1623         _takeLiquidity(tLiquidity);
1624         _takeCharityFee(tCharity);
1625         _takeMarketingFee(tMarketing);
1626         _reflectFee(rFee, tFee);
1627         emit Transfer(sender, recipient, tTransferAmount);
1628     }
1629 
1630     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1631         (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1632         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tCharity).sub(tMarketing);
1633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1634         
1635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1636         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1638         _takeLiquidity(tLiquidity);
1639         _takeCharityFee(tCharity);
1640         _takeMarketingFee(tMarketing);
1641         _reflectFee(rFee, tFee);
1642         emit Transfer(sender, recipient, tTransferAmount);
1643     }
1644 
1645     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1646         (uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 tMarketing) = _getTValues(tAmount);
1647         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tCharity).sub(tMarketing);
1648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tCharity, tMarketing, _getRate());
1649 
1650         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1651         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1652         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1653         _takeLiquidity(tLiquidity);
1654         _takeCharityFee(tCharity);
1655         _takeMarketingFee(tMarketing);
1656         _reflectFee(rFee, tFee);
1657         emit Transfer(sender, recipient, tTransferAmount);
1658     }
1659 }
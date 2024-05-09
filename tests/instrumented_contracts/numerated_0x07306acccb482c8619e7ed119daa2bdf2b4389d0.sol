1 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library AddressUpgradeable {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
150         if (success) {
151             return returndata;
152         } else {
153             // Look for revert reason and bubble it up if present
154             if (returndata.length > 0) {
155                 // The easiest way to bubble the revert reason is using memory via assembly
156 
157                 // solhint-disable-next-line no-inline-assembly
158                 assembly {
159                     let returndata_size := mload(returndata)
160                     revert(add(32, returndata), returndata_size)
161                 }
162             } else {
163                 revert(errorMessage);
164             }
165         }
166     }
167 }
168 
169 // File: @openzeppelin/contracts-upgradeable/proxy/Initializable.sol
170 
171 
172 
173 // solhint-disable-next-line compiler-version
174 pragma solidity >=0.4.24 <0.8.0;
175 
176 
177 /**
178  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
179  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
180  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
181  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
182  *
183  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
184  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
185  *
186  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
187  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
188  */
189 abstract contract Initializable {
190 
191     /**
192      * @dev Indicates that the contract has been initialized.
193      */
194     bool private _initialized;
195 
196     /**
197      * @dev Indicates that the contract is in the process of being initialized.
198      */
199     bool private _initializing;
200 
201     /**
202      * @dev Modifier to protect an initializer function from being invoked twice.
203      */
204     modifier initializer() {
205         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
206 
207         bool isTopLevelCall = !_initializing;
208         if (isTopLevelCall) {
209             _initializing = true;
210             _initialized = true;
211         }
212 
213         _;
214 
215         if (isTopLevelCall) {
216             _initializing = false;
217         }
218     }
219 
220     /// @dev Returns true if and only if the function is running in the constructor
221     function _isConstructor() private view returns (bool) {
222         return !AddressUpgradeable.isContract(address(this));
223     }
224 }
225 
226 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
227 
228 
229 
230 pragma solidity >=0.6.0 <0.8.0;
231 
232 
233 /*
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with GSN meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract ContextUpgradeable is Initializable {
244     function __Context_init() internal initializer {
245         __Context_init_unchained();
246     }
247 
248     function __Context_init_unchained() internal initializer {
249     }
250     function _msgSender() internal view virtual returns (address payable) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258     uint256[50] private __gap;
259 }
260 
261 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
262 
263 
264 
265 pragma solidity >=0.6.0 <0.8.0;
266 
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     function __Ownable_init() internal initializer {
289         __Context_init_unchained();
290         __Ownable_init_unchained();
291     }
292 
293     function __Ownable_init_unchained() internal initializer {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public virtual onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335     uint256[49] private __gap;
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
339 
340 
341 
342 pragma solidity >=0.6.0 <0.8.0;
343 
344 /**
345  * @dev Interface of the ERC20 standard as defined in the EIP.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `recipient`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through {transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when {approve} or {transferFrom} are called.
373      */
374     function allowance(address owner, address spender) external view returns (uint256);
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * IMPORTANT: Beware that changing an allowance with this method brings the risk
382      * that someone may use both the old and the new allowance by unfortunate
383      * transaction ordering. One possible solution to mitigate this race
384      * condition is to first reduce the spender's allowance to 0 and set the
385      * desired value afterwards:
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address spender, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Moves `amount` tokens from `sender` to `recipient` using the
394      * allowance mechanism. `amount` is then deducted from the caller's
395      * allowance.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Emitted when `value` tokens are moved from one account (`from`) to
405      * another (`to`).
406      *
407      * Note that `value` may be zero.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 value);
410 
411     /**
412      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
413      * a call to {approve}. `value` is the new allowance.
414      */
415     event Approval(address indexed owner, address indexed spender, uint256 value);
416 }
417 
418 // File: @openzeppelin/contracts/math/SafeMath.sol
419 
420 
421 
422 pragma solidity >=0.6.0 <0.8.0;
423 
424 /**
425  * @dev Wrappers over Solidity's arithmetic operations with added overflow
426  * checks.
427  *
428  * Arithmetic operations in Solidity wrap on overflow. This can easily result
429  * in bugs, because programmers usually assume that an overflow raises an
430  * error, which is the standard behavior in high level programming languages.
431  * `SafeMath` restores this intuition by reverting the transaction when an
432  * operation overflows.
433  *
434  * Using this library instead of the unchecked operations eliminates an entire
435  * class of bugs, so it's recommended to use it always.
436  */
437 library SafeMath {
438     /**
439      * @dev Returns the addition of two unsigned integers, reverting on
440      * overflow.
441      *
442      * Counterpart to Solidity's `+` operator.
443      *
444      * Requirements:
445      *
446      * - Addition cannot overflow.
447      */
448     function add(uint256 a, uint256 b) internal pure returns (uint256) {
449         uint256 c = a + b;
450         require(c >= a, "SafeMath: addition overflow");
451 
452         return c;
453     }
454 
455     /**
456      * @dev Returns the subtraction of two unsigned integers, reverting on
457      * overflow (when the result is negative).
458      *
459      * Counterpart to Solidity's `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
466         return sub(a, b, "SafeMath: subtraction overflow");
467     }
468 
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
471      * overflow (when the result is negative).
472      *
473      * Counterpart to Solidity's `-` operator.
474      *
475      * Requirements:
476      *
477      * - Subtraction cannot overflow.
478      */
479     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         require(b <= a, errorMessage);
481         uint256 c = a - b;
482 
483         return c;
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
497         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
498         // benefit is lost if 'b' is also tested.
499         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
500         if (a == 0) {
501             return 0;
502         }
503 
504         uint256 c = a * b;
505         require(c / a == b, "SafeMath: multiplication overflow");
506 
507         return c;
508     }
509 
510     /**
511      * @dev Returns the integer division of two unsigned integers. Reverts on
512      * division by zero. The result is rounded towards zero.
513      *
514      * Counterpart to Solidity's `/` operator. Note: this function uses a
515      * `revert` opcode (which leaves remaining gas untouched) while Solidity
516      * uses an invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         return div(a, b, "SafeMath: division by zero");
524     }
525 
526     /**
527      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
528      * division by zero. The result is rounded towards zero.
529      *
530      * Counterpart to Solidity's `/` operator. Note: this function uses a
531      * `revert` opcode (which leaves remaining gas untouched) while Solidity
532      * uses an invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         require(b > 0, errorMessage);
540         uint256 c = a / b;
541         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
542 
543         return c;
544     }
545 
546     /**
547      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
548      * Reverts when dividing by zero.
549      *
550      * Counterpart to Solidity's `%` operator. This function uses a `revert`
551      * opcode (which leaves remaining gas untouched) while Solidity uses an
552      * invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
559         return mod(a, b, "SafeMath: modulo by zero");
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * Reverts with custom message when dividing by zero.
565      *
566      * Counterpart to Solidity's `%` operator. This function uses a `revert`
567      * opcode (which leaves remaining gas untouched) while Solidity uses an
568      * invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
575         require(b != 0, errorMessage);
576         return a % b;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/utils/Address.sol
581 
582 
583 
584 pragma solidity >=0.6.2 <0.8.0;
585 
586 /**
587  * @dev Collection of functions related to the address type
588  */
589 library Address {
590     /**
591      * @dev Returns true if `account` is a contract.
592      *
593      * [IMPORTANT]
594      * ====
595      * It is unsafe to assume that an address for which this function returns
596      * false is an externally-owned account (EOA) and not a contract.
597      *
598      * Among others, `isContract` will return false for the following
599      * types of addresses:
600      *
601      *  - an externally-owned account
602      *  - a contract in construction
603      *  - an address where a contract will be created
604      *  - an address where a contract lived, but was destroyed
605      * ====
606      */
607     function isContract(address account) internal view returns (bool) {
608         // This method relies on extcodesize, which returns 0 for contracts in
609         // construction, since the code is only stored at the end of the
610         // constructor execution.
611 
612         uint256 size;
613         // solhint-disable-next-line no-inline-assembly
614         assembly { size := extcodesize(account) }
615         return size > 0;
616     }
617 
618     /**
619      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
620      * `recipient`, forwarding all available gas and reverting on errors.
621      *
622      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
623      * of certain opcodes, possibly making contracts go over the 2300 gas limit
624      * imposed by `transfer`, making them unable to receive funds via
625      * `transfer`. {sendValue} removes this limitation.
626      *
627      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
628      *
629      * IMPORTANT: because control is transferred to `recipient`, care must be
630      * taken to not create reentrancy vulnerabilities. Consider using
631      * {ReentrancyGuard} or the
632      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
633      */
634     function sendValue(address payable recipient, uint256 amount) internal {
635         require(address(this).balance >= amount, "Address: insufficient balance");
636 
637         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
638         (bool success, ) = recipient.call{ value: amount }("");
639         require(success, "Address: unable to send value, recipient may have reverted");
640     }
641 
642     /**
643      * @dev Performs a Solidity function call using a low level `call`. A
644      * plain`call` is an unsafe replacement for a function call: use this
645      * function instead.
646      *
647      * If `target` reverts with a revert reason, it is bubbled up by this
648      * function (like regular Solidity function calls).
649      *
650      * Returns the raw returned data. To convert to the expected return value,
651      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
652      *
653      * Requirements:
654      *
655      * - `target` must be a contract.
656      * - calling `target` with `data` must not revert.
657      *
658      * _Available since v3.1._
659      */
660     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
661       return functionCall(target, data, "Address: low-level call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
666      * `errorMessage` as a fallback revert reason when `target` reverts.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
671         return functionCallWithValue(target, data, 0, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but also transferring `value` wei to `target`.
677      *
678      * Requirements:
679      *
680      * - the calling contract must have an ETH balance of at least `value`.
681      * - the called Solidity function must be `payable`.
682      *
683      * _Available since v3.1._
684      */
685     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
686         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
691      * with `errorMessage` as a fallback revert reason when `target` reverts.
692      *
693      * _Available since v3.1._
694      */
695     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
696         require(address(this).balance >= value, "Address: insufficient balance for call");
697         require(isContract(target), "Address: call to non-contract");
698 
699         // solhint-disable-next-line avoid-low-level-calls
700         (bool success, bytes memory returndata) = target.call{ value: value }(data);
701         return _verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
706      * but performing a static call.
707      *
708      * _Available since v3.3._
709      */
710     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
711         return functionStaticCall(target, data, "Address: low-level static call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
716      * but performing a static call.
717      *
718      * _Available since v3.3._
719      */
720     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
721         require(isContract(target), "Address: static call to non-contract");
722 
723         // solhint-disable-next-line avoid-low-level-calls
724         (bool success, bytes memory returndata) = target.staticcall(data);
725         return _verifyCallResult(success, returndata, errorMessage);
726     }
727 
728     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
729         if (success) {
730             return returndata;
731         } else {
732             // Look for revert reason and bubble it up if present
733             if (returndata.length > 0) {
734                 // The easiest way to bubble the revert reason is using memory via assembly
735 
736                 // solhint-disable-next-line no-inline-assembly
737                 assembly {
738                     let returndata_size := mload(returndata)
739                     revert(add(32, returndata), returndata_size)
740                 }
741             } else {
742                 revert(errorMessage);
743             }
744         }
745     }
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
749 
750 
751 
752 pragma solidity >=0.6.0 <0.8.0;
753 
754 
755 
756 
757 /**
758  * @title SafeERC20
759  * @dev Wrappers around ERC20 operations that throw on failure (when the token
760  * contract returns false). Tokens that return no value (and instead revert or
761  * throw on failure) are also supported, non-reverting calls are assumed to be
762  * successful.
763  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
764  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
765  */
766 library SafeERC20 {
767     using SafeMath for uint256;
768     using Address for address;
769 
770     function safeTransfer(IERC20 token, address to, uint256 value) internal {
771         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
772     }
773 
774     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
775         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
776     }
777 
778     /**
779      * @dev Deprecated. This function has issues similar to the ones found in
780      * {IERC20-approve}, and its usage is discouraged.
781      *
782      * Whenever possible, use {safeIncreaseAllowance} and
783      * {safeDecreaseAllowance} instead.
784      */
785     function safeApprove(IERC20 token, address spender, uint256 value) internal {
786         // safeApprove should only be called when setting an initial allowance,
787         // or when resetting it to zero. To increase and decrease it, use
788         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
789         // solhint-disable-next-line max-line-length
790         require((value == 0) || (token.allowance(address(this), spender) == 0),
791             "SafeERC20: approve from non-zero to non-zero allowance"
792         );
793         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
794     }
795 
796     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
797         uint256 newAllowance = token.allowance(address(this), spender).add(value);
798         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
799     }
800 
801     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
802         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
803         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
804     }
805 
806     /**
807      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
808      * on the return value: the return value is optional (but if data is returned, it must not be false).
809      * @param token The token targeted by the call.
810      * @param data The call data (encoded using abi.encode or one of its variants).
811      */
812     function _callOptionalReturn(IERC20 token, bytes memory data) private {
813         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
814         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
815         // the target address contains contract code and also asserts for success in the low-level call.
816 
817         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
818         if (returndata.length > 0) { // Return data is optional
819             // solhint-disable-next-line max-line-length
820             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
821         }
822     }
823 }
824 
825 // File: contracts/interfaces/IUnicFarm.sol
826 
827 
828 pragma solidity 0.6.12;
829 
830 
831 interface IUnicFarm {
832     //struct PoolInfo {
833         //IERC20 lpToken; // Address of LP token contract.
834         //uint256 allocPoint; // How many allocation points assigned to this pool. UNICs to distribute per block.
835         //uint256 lastRewardBlock; // Last block number that UNICs distribution occurs.
836         //uint256 accUnicPerShare; // Accumulated UNICs per share, times 1e12. See below.
837         //address uToken;
838     //}
839 
840     function pendingUnic(uint256 _pid, address _user) external view returns (uint256);
841 
842     function deposit(uint256 _pid, uint256 _amount) external;
843 
844     function poolInfo(uint256 _pid) external view returns (IERC20, uint256, uint256, uint256, address);
845 
846     function poolLength() external view returns (uint256);
847 
848     function withdraw(uint256 _pid, uint256 _amount) external;
849 }
850 
851 // File: contracts/interfaces/IUnicGallery.sol
852 
853 
854 // solhint-disable
855 pragma solidity 0.6.12;
856 
857 interface IUnicGallery {
858     function enter(uint256 _amount) external;
859 }
860 
861 // File: contracts/UniclyXUnicVault.sol
862 
863 
864 pragma solidity 0.6.12;
865 
866 
867 
868 
869 
870 
871 
872 contract UniclyXUnicVault is OwnableUpgradeable {
873     using SafeMath for uint256;
874     using SafeERC20 for IERC20;
875 
876     address public constant XUNIC = address(0xA62fB0c2Fb3C7b27797dC04e1fEA06C0a2Db919a);
877     address public constant UNIC = address(0x94E0BAb2F6Ab1F19F4750E42d7349f2740513aD5);
878     address public constant UNIC_MASTERCHEF = address(0x4A25E4DF835B605A5848d2DB450fA600d96ee818);
879 
880     // Info of each user.
881     struct UserInfo {
882         uint256 amount; // How many LP tokens the user has provided.
883         uint256 rewardDebt; // How much to remove when calculating user shares
884     }
885 
886     // Info of each pool.
887     struct PoolInfo {
888         uint256 totalLPTokens; // The total LP tokens staked (we must keep this, see readme file)
889         uint256 accXUNICPerShare; //Accumulated UNICs per share, times 1e12
890     }
891 
892     // Info of each user that stakes LP tokens.
893     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
894 
895     // Info of each pool.
896     mapping(uint256 => PoolInfo) public poolInfo;
897 
898     // Gas optimization for approving tokens to unic chef
899     mapping(address => bool) public haveApprovedToken;
900 
901     address public devaddr;
902     // For better precision
903     uint256 public devFeeDenominator = 1000;
904     // For gas optimization, do not update every pool in do hard work, only the ones that haven't been updated for ~12 hours
905     uint256 public  minBlocksToUpdatePoolInDoHardWork = 3600;
906 
907     // Events
908     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
909     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
910     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
911     event UpdatePool(uint256 pid);
912     event Dev(address devaddr);
913     event DoHardWork(uint256 numberOfUpdatedPools);
914 
915     function initialize(address _devaddr) external initializer {
916         __Ownable_init();
917         devaddr = _devaddr;
918         IERC20(UNIC).approve(XUNIC, uint256(~0));
919     }
920 
921     // Withdraw LP tokens from MasterChef.
922     function withdraw(uint256 _pid, uint256 _amount) public {
923         PoolInfo storage pool = poolInfo[_pid];
924         UserInfo storage user = userInfo[_pid][msg.sender];
925         require(user.amount >= _amount, "withdraw: not good");
926         updatePool(_pid);
927         uint256 pending = (pool.accXUNICPerShare.mul(user.amount).div(1e12)).sub(user.rewardDebt);
928         if (pending > 0) {
929             safexUNICTransfer(msg.sender, pending);
930         }
931         if (_amount > 0) {
932             user.amount = user.amount.sub(_amount);
933             pool.totalLPTokens = pool.totalLPTokens.sub(_amount);
934             IUnicFarm(UNIC_MASTERCHEF).withdraw(_pid, _amount);
935             (IERC20 lpToken,,,,) = IUnicFarm(UNIC_MASTERCHEF).poolInfo(_pid);
936             lpToken.safeTransfer(address(msg.sender), _amount);
937         }
938         user.rewardDebt = user.amount.mul(pool.accXUNICPerShare).div(1e12);
939         emit Withdraw(msg.sender, _pid, _amount);
940     }
941 
942     // Deposit LP tokens to MasterChef for unics allocation.
943     function deposit(uint256 _pid, uint256 _amount) public {
944         depositFor(_pid, _amount, msg.sender);
945     }
946 
947     // Deposit LP tokens for someone else than msg.sender, mainly for zap functionality
948     function depositFor(uint256 _pid, uint256 _amount, address _user) public {
949         PoolInfo storage pool = poolInfo[_pid];
950         UserInfo storage user = userInfo[_pid][_user];
951         updatePool(_pid);
952         if (user.amount > 0) {
953             uint256 pending = (pool.accXUNICPerShare.mul(user.amount).div(1e12)).sub(user.rewardDebt);
954             if (pending > 0) {
955                 safexUNICTransfer(_user, pending);
956             }
957         }
958         if (_amount > 0) {
959             (IERC20 lpToken,,,,) = IUnicFarm(UNIC_MASTERCHEF).poolInfo(_pid);
960             lpToken.safeTransferFrom(
961                 address(msg.sender),
962                 address(this),
963                 _amount
964             );
965             if (!haveApprovedToken[address(lpToken)]) {
966                 lpToken.approve(UNIC_MASTERCHEF, uint256(~0));
967                 haveApprovedToken[address(lpToken)] = true;
968             }
969             IUnicFarm(UNIC_MASTERCHEF).deposit(_pid, _amount);
970             user.amount = user.amount.add(_amount);
971             pool.totalLPTokens = pool.totalLPTokens.add(_amount);
972         }
973         user.rewardDebt = user.amount.mul(pool.accXUNICPerShare).div(1e12);
974         emit Deposit(_user, _pid, _amount);
975     }
976 
977     function doHardWork() public {
978         uint256 numberOfUpdatedPools = 0;
979         for (uint256 _pid = 0; _pid < IUnicFarm(UNIC_MASTERCHEF).poolLength(); _pid++) {
980             if (poolInfo[_pid].totalLPTokens > 0) {
981                 (,,uint256 lastRewardBlock,,) = IUnicFarm(UNIC_MASTERCHEF).poolInfo(_pid);
982                 if (block.number - minBlocksToUpdatePoolInDoHardWork > lastRewardBlock) {
983                     numberOfUpdatedPools = numberOfUpdatedPools.add(1);
984                     updatePool(_pid);
985                 }
986             }
987         }
988         emit DoHardWork(numberOfUpdatedPools);
989     }
990 
991     function updatePool(uint256 _pid) public {
992         PoolInfo storage pool = poolInfo[_pid];
993 
994         uint256 prevXUNICBalance = IERC20(XUNIC).balanceOf(address(this));
995         IUnicFarm(UNIC_MASTERCHEF).deposit(_pid, 0);
996         uint256 UNICBalance = IERC20(UNIC).balanceOf(address(this));
997         if (UNICBalance > 0 && pool.totalLPTokens > 0) {
998             IUnicGallery(XUNIC).enter(UNICBalance);
999             uint256 addedXUNICs = IERC20(XUNIC).balanceOf(address(this)).sub(prevXUNICBalance);
1000             uint256 devAmount = addedXUNICs.mul(100).div(devFeeDenominator); // For better precision
1001             IERC20(XUNIC).transfer(devaddr, devAmount);
1002             addedXUNICs = addedXUNICs.sub(devAmount);
1003             pool.accXUNICPerShare = pool.accXUNICPerShare.add(addedXUNICs.mul(1e12).div(pool.totalLPTokens));
1004         }
1005 
1006         emit UpdatePool(_pid);
1007     }
1008 
1009     // Withdraw without caring about rewards. EMERGENCY ONLY.
1010     function emergencyWithdraw(uint256 _pid) external {
1011         PoolInfo storage pool = poolInfo[_pid];
1012         UserInfo storage user = userInfo[_pid][msg.sender];
1013         uint256 amount = user.amount;
1014         user.amount = 0;
1015         user.rewardDebt = 0;
1016         pool.totalLPTokens = pool.totalLPTokens.sub(amount);
1017         IUnicFarm(UNIC_MASTERCHEF).withdraw(_pid, amount);
1018         (IERC20 lpToken,,,,) = IUnicFarm(UNIC_MASTERCHEF).poolInfo(_pid);
1019         lpToken.safeTransfer(address(msg.sender), amount);
1020         if (pool.totalLPTokens > 0) {
1021             // In case there are still users in that pool, we are using the claimed UNICs from `withdraw` to add to the share
1022             // In case there aren't anymore users in that pool, the next pool that will get updated will receive the claimed UNICs
1023             updatePool(_pid);
1024         }
1025         emit EmergencyWithdraw(msg.sender, _pid, amount);
1026     }
1027 
1028     // salvage purpose only for when stupid people send tokens here
1029     function withdrawToken(address tokenToWithdraw, uint256 amount) external onlyOwner {
1030         require(tokenToWithdraw != XUNIC, "Can't salvage xunic");
1031         IERC20(tokenToWithdraw).transfer(msg.sender, amount);
1032     }
1033 
1034     // Safe unic transfer function, just in case if rounding error causes pool to not have enough xUNICs.
1035     function safexUNICTransfer(address _to, uint256 _amount) internal {
1036         uint256 xUNICBal = IERC20(XUNIC).balanceOf(address(this));
1037         if (_amount > xUNICBal) {
1038             IERC20(XUNIC).transfer(_to, xUNICBal);
1039         } else {
1040             IERC20(XUNIC).transfer(_to, _amount);
1041         }
1042     }
1043 
1044     // Update dev address by the previous dev.
1045     function dev(address _devaddr) public {
1046         require(msg.sender == devaddr, "dev: wut?");
1047         devaddr = _devaddr;
1048 
1049         emit Dev(_devaddr);
1050     }
1051 
1052     // ------------- VIEW --------------
1053 
1054     // Current rate of xUNIC
1055     function getxUNICRate() public view returns (uint256) {
1056         uint256 xUNICBalance = IERC20(UNIC).balanceOf(XUNIC);
1057         uint256 xUNICSupply = IERC20(XUNIC).totalSupply();
1058 
1059         return xUNICBalance.mul(1e18).div(xUNICSupply);
1060     }
1061 
1062     function pendingxUNICs(uint256 _pid, address _user) public view returns (uint256) {
1063         PoolInfo memory pool = poolInfo[_pid];
1064         UserInfo memory user = userInfo[_pid][_user];
1065 
1066         // for frontend
1067         uint256 notClaimedUNICs = IUnicFarm(UNIC_MASTERCHEF).pendingUnic(_pid, address(this));
1068         if (notClaimedUNICs > 0) {
1069             uint256 xUNICRate = getxUNICRate();
1070             uint256 accXUNICPerShare = pool.accXUNICPerShare.add(notClaimedUNICs.mul(1e18).div(xUNICRate).mul(1e12).div(pool.totalLPTokens));
1071             return (accXUNICPerShare.mul(user.amount).div(1e12)).sub(user.rewardDebt);
1072         }
1073         uint256 pendingXUNICs = (pool.accXUNICPerShare.mul(user.amount).div(1e12)).sub(user.rewardDebt);
1074         return pendingXUNICs;
1075     }
1076 
1077 }
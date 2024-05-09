1 pragma experimental ABIEncoderV2;
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 // SPDX-License-Identifier: MIT
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17   function _msgSender() internal view virtual returns (address payable) {
18     return msg.sender;
19   }
20 
21   function _msgData() internal view virtual returns (bytes memory) {
22     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23     return msg.data;
24   }
25 }
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43   address private _owner;
44   event OwnershipTransferred(
45     address indexed previousOwner,
46     address indexed newOwner
47   );
48 
49   /**
50    * @dev Initializes the contract setting the deployer as the initial owner.
51    */
52   constructor() internal {
53     address msgSender = _msgSender();
54     _owner = msgSender;
55     emit OwnershipTransferred(address(0), msgSender);
56   }
57 
58   /**
59    * @dev Returns the address of the current owner.
60    */
61   function owner() public view returns (address) {
62     return _owner;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(_owner == _msgSender(), "Ownable: caller is not the owner");
70     _;
71   }
72 
73   /**
74    * @dev Leaves the contract without owner. It will not be possible to call
75    * `onlyOwner` functions anymore. Can only be called by the current owner.
76    *
77    * NOTE: Renouncing ownership will leave the contract without an owner,
78    * thereby removing any functionality that is only available to the owner.
79    */
80   function renounceOwnership() public virtual onlyOwner {
81     emit OwnershipTransferred(_owner, address(0));
82     _owner = address(0);
83   }
84 
85   /**
86    * @dev Transfers ownership of the contract to a new account (`newOwner`).
87    * Can only be called by the current owner.
88    */
89   function transferOwnership(address newOwner) public virtual onlyOwner {
90     require(newOwner != address(0), "Ownable: new owner is the zero address");
91     emit OwnershipTransferred(_owner, newOwner);
92     _owner = newOwner;
93   }
94 }
95 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
96 
97 pragma solidity >=0.6.0 <0.8.0;
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP.
101  */
102 interface IERC20 {
103   /**
104    * @dev Returns the amount of tokens in existence.
105    */
106   function totalSupply() external view returns (uint256);
107 
108   /**
109    * @dev Returns the amount of tokens owned by `account`.
110    */
111   function balanceOf(address account) external view returns (uint256);
112 
113   /**
114    * @dev Moves `amount` tokens from the caller's account to `recipient`.
115    *
116    * Returns a boolean value indicating whether the operation succeeded.
117    *
118    * Emits a {Transfer} event.
119    */
120   function transfer(address recipient, uint256 amount) external returns (bool);
121 
122   /**
123    * @dev Returns the remaining number of tokens that `spender` will be
124    * allowed to spend on behalf of `owner` through {transferFrom}. This is
125    * zero by default.
126    *
127    * This value changes when {approve} or {transferFrom} are called.
128    */
129   function allowance(address owner, address spender)
130     external
131     view
132     returns (uint256);
133 
134   /**
135    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136    *
137    * Returns a boolean value indicating whether the operation succeeded.
138    *
139    * IMPORTANT: Beware that changing an allowance with this method brings the risk
140    * that someone may use both the old and the new allowance by unfortunate
141    * transaction ordering. One possible solution to mitigate this race
142    * condition is to first reduce the spender's allowance to 0 and set the
143    * desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    *
146    * Emits an {Approval} event.
147    */
148   function approve(address spender, uint256 amount) external returns (bool);
149 
150   /**
151    * @dev Moves `amount` tokens from `sender` to `recipient` using the
152    * allowance mechanism. `amount` is then deducted from the caller's
153    * allowance.
154    *
155    * Returns a boolean value indicating whether the operation succeeded.
156    *
157    * Emits a {Transfer} event.
158    */
159   function transferFrom(
160     address sender,
161     address recipient,
162     uint256 amount
163   ) external returns (bool);
164 
165   /**
166    * @dev Emitted when `value` tokens are moved from one account (`from`) to
167    * another (`to`).
168    *
169    * Note that `value` may be zero.
170    */
171   event Transfer(address indexed from, address indexed to, uint256 value);
172   /**
173    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174    * a call to {approve}. `value` is the new allowance.
175    */
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 pragma solidity >=0.6.0 <0.8.0;
181 
182 /**
183  * @dev Wrappers over Solidity's arithmetic operations with added overflow
184  * checks.
185  *
186  * Arithmetic operations in Solidity wrap on overflow. This can easily result
187  * in bugs, because programmers usually assume that an overflow raises an
188  * error, which is the standard behavior in high level programming languages.
189  * `SafeMath` restores this intuition by reverting the transaction when an
190  * operation overflows.
191  *
192  * Using this library instead of the unchecked operations eliminates an entire
193  * class of bugs, so it's recommended to use it always.
194  */
195 library SafeMath {
196   /**
197    * @dev Returns the addition of two unsigned integers, reverting on
198    * overflow.
199    *
200    * Counterpart to Solidity's `+` operator.
201    *
202    * Requirements:
203    *
204    * - Addition cannot overflow.
205    */
206   function add(uint256 a, uint256 b) internal pure returns (uint256) {
207     uint256 c = a + b;
208     require(c >= a, "SafeMath: addition overflow");
209     return c;
210   }
211 
212   /**
213    * @dev Returns the subtraction of two unsigned integers, reverting on
214    * overflow (when the result is negative).
215    *
216    * Counterpart to Solidity's `-` operator.
217    *
218    * Requirements:
219    *
220    * - Subtraction cannot overflow.
221    */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     return sub(a, b, "SafeMath: subtraction overflow");
224   }
225 
226   /**
227    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228    * overflow (when the result is negative).
229    *
230    * Counterpart to Solidity's `-` operator.
231    *
232    * Requirements:
233    *
234    * - Subtraction cannot overflow.
235    */
236   function sub(
237     uint256 a,
238     uint256 b,
239     string memory errorMessage
240   ) internal pure returns (uint256) {
241     require(b <= a, errorMessage);
242     uint256 c = a - b;
243     return c;
244   }
245 
246   /**
247    * @dev Returns the multiplication of two unsigned integers, reverting on
248    * overflow.
249    *
250    * Counterpart to Solidity's `*` operator.
251    *
252    * Requirements:
253    *
254    * - Multiplication cannot overflow.
255    */
256   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258     // benefit is lost if 'b' is also tested.
259     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260     if (a == 0) {
261       return 0;
262     }
263     uint256 c = a * b;
264     require(c / a == b, "SafeMath: multiplication overflow");
265     return c;
266   }
267 
268   /**
269    * @dev Returns the integer division of two unsigned integers. Reverts on
270    * division by zero. The result is rounded towards zero.
271    *
272    * Counterpart to Solidity's `/` operator. Note: this function uses a
273    * `revert` opcode (which leaves remaining gas untouched) while Solidity
274    * uses an invalid opcode to revert (consuming all remaining gas).
275    *
276    * Requirements:
277    *
278    * - The divisor cannot be zero.
279    */
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     return div(a, b, "SafeMath: division by zero");
282   }
283 
284   /**
285    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
286    * division by zero. The result is rounded towards zero.
287    *
288    * Counterpart to Solidity's `/` operator. Note: this function uses a
289    * `revert` opcode (which leaves remaining gas untouched) while Solidity
290    * uses an invalid opcode to revert (consuming all remaining gas).
291    *
292    * Requirements:
293    *
294    * - The divisor cannot be zero.
295    */
296   function div(
297     uint256 a,
298     uint256 b,
299     string memory errorMessage
300   ) internal pure returns (uint256) {
301     require(b > 0, errorMessage);
302     uint256 c = a / b;
303     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
304     return c;
305   }
306 
307   /**
308    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309    * Reverts when dividing by zero.
310    *
311    * Counterpart to Solidity's `%` operator. This function uses a `revert`
312    * opcode (which leaves remaining gas untouched) while Solidity uses an
313    * invalid opcode to revert (consuming all remaining gas).
314    *
315    * Requirements:
316    *
317    * - The divisor cannot be zero.
318    */
319   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320     return mod(a, b, "SafeMath: modulo by zero");
321   }
322 
323   /**
324    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325    * Reverts with custom message when dividing by zero.
326    *
327    * Counterpart to Solidity's `%` operator. This function uses a `revert`
328    * opcode (which leaves remaining gas untouched) while Solidity uses an
329    * invalid opcode to revert (consuming all remaining gas).
330    *
331    * Requirements:
332    *
333    * - The divisor cannot be zero.
334    */
335   function mod(
336     uint256 a,
337     uint256 b,
338     string memory errorMessage
339   ) internal pure returns (uint256) {
340     require(b != 0, errorMessage);
341     return a % b;
342   }
343 }
344 // File: @openzeppelin/contracts/utils/Address.sol
345 
346 pragma solidity >=0.6.2 <0.8.0;
347 
348 /**
349  * @dev Collection of functions related to the address type
350  */
351 library Address {
352   /**
353    * @dev Returns true if `account` is a contract.
354    *
355    * [IMPORTANT]
356    * ====
357    * It is unsafe to assume that an address for which this function returns
358    * false is an externally-owned account (EOA) and not a contract.
359    *
360    * Among others, `isContract` will return false for the following
361    * types of addresses:
362    *
363    *  - an externally-owned account
364    *  - a contract in construction
365    *  - an address where a contract will be created
366    *  - an address where a contract lived, but was destroyed
367    * ====
368    */
369   function isContract(address account) internal view returns (bool) {
370     // This method relies on extcodesize, which returns 0 for contracts in
371     // construction, since the code is only stored at the end of the
372     // constructor execution.
373     uint256 size;
374     // solhint-disable-next-line no-inline-assembly
375     assembly {
376       size := extcodesize(account)
377     }
378     return size > 0;
379   }
380 
381   /**
382    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383    * `recipient`, forwarding all available gas and reverting on errors.
384    *
385    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386    * of certain opcodes, possibly making contracts go over the 2300 gas limit
387    * imposed by `transfer`, making them unable to receive funds via
388    * `transfer`. {sendValue} removes this limitation.
389    *
390    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391    *
392    * IMPORTANT: because control is transferred to `recipient`, care must be
393    * taken to not create reentrancy vulnerabilities. Consider using
394    * {ReentrancyGuard} or the
395    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396    */
397   function sendValue(address payable recipient, uint256 amount) internal {
398     require(address(this).balance >= amount, "Address: insufficient balance");
399     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
400     (bool success, ) = recipient.call{value: amount}("");
401     require(
402       success,
403       "Address: unable to send value, recipient may have reverted"
404     );
405   }
406 
407   /**
408    * @dev Performs a Solidity function call using a low level `call`. A
409    * plain`call` is an unsafe replacement for a function call: use this
410    * function instead.
411    *
412    * If `target` reverts with a revert reason, it is bubbled up by this
413    * function (like regular Solidity function calls).
414    *
415    * Returns the raw returned data. To convert to the expected return value,
416    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
417    *
418    * Requirements:
419    *
420    * - `target` must be a contract.
421    * - calling `target` with `data` must not revert.
422    *
423    * _Available since v3.1._
424    */
425   function functionCall(address target, bytes memory data)
426     internal
427     returns (bytes memory)
428   {
429     return functionCall(target, data, "Address: low-level call failed");
430   }
431 
432   /**
433    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434    * `errorMessage` as a fallback revert reason when `target` reverts.
435    *
436    * _Available since v3.1._
437    */
438   function functionCall(
439     address target,
440     bytes memory data,
441     string memory errorMessage
442   ) internal returns (bytes memory) {
443     return functionCallWithValue(target, data, 0, errorMessage);
444   }
445 
446   /**
447    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448    * but also transferring `value` wei to `target`.
449    *
450    * Requirements:
451    *
452    * - the calling contract must have an ETH balance of at least `value`.
453    * - the called Solidity function must be `payable`.
454    *
455    * _Available since v3.1._
456    */
457   function functionCallWithValue(
458     address target,
459     bytes memory data,
460     uint256 value
461   ) internal returns (bytes memory) {
462     return
463       functionCallWithValue(
464         target,
465         data,
466         value,
467         "Address: low-level call with value failed"
468       );
469   }
470 
471   /**
472    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473    * with `errorMessage` as a fallback revert reason when `target` reverts.
474    *
475    * _Available since v3.1._
476    */
477   function functionCallWithValue(
478     address target,
479     bytes memory data,
480     uint256 value,
481     string memory errorMessage
482   ) internal returns (bytes memory) {
483     require(
484       address(this).balance >= value,
485       "Address: insufficient balance for call"
486     );
487     require(isContract(target), "Address: call to non-contract");
488     // solhint-disable-next-line avoid-low-level-calls
489     (bool success, bytes memory returndata) = target.call{value: value}(data);
490     return _verifyCallResult(success, returndata, errorMessage);
491   }
492 
493   /**
494    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495    * but performing a static call.
496    *
497    * _Available since v3.3._
498    */
499   function functionStaticCall(address target, bytes memory data)
500     internal
501     view
502     returns (bytes memory)
503   {
504     return
505       functionStaticCall(target, data, "Address: low-level static call failed");
506   }
507 
508   /**
509    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510    * but performing a static call.
511    *
512    * _Available since v3.3._
513    */
514   function functionStaticCall(
515     address target,
516     bytes memory data,
517     string memory errorMessage
518   ) internal view returns (bytes memory) {
519     require(isContract(target), "Address: static call to non-contract");
520     // solhint-disable-next-line avoid-low-level-calls
521     (bool success, bytes memory returndata) = target.staticcall(data);
522     return _verifyCallResult(success, returndata, errorMessage);
523   }
524 
525   function _verifyCallResult(
526     bool success,
527     bytes memory returndata,
528     string memory errorMessage
529   ) private pure returns (bytes memory) {
530     if (success) {
531       return returndata;
532     } else {
533       // Look for revert reason and bubble it up if present
534       if (returndata.length > 0) {
535         // The easiest way to bubble the revert reason is using memory via assembly
536         // solhint-disable-next-line no-inline-assembly
537         assembly {
538           let returndata_size := mload(returndata)
539           revert(add(32, returndata), returndata_size)
540         }
541       } else {
542         revert(errorMessage);
543       }
544     }
545   }
546 }
547 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
548 
549 pragma solidity >=0.6.0 <0.8.0;
550 
551 /**
552  * @title SafeERC20
553  * @dev Wrappers around ERC20 operations that throw on failure (when the token
554  * contract returns false). Tokens that return no value (and instead revert or
555  * throw on failure) are also supported, non-reverting calls are assumed to be
556  * successful.
557  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
558  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
559  */
560 library SafeERC20 {
561   using SafeMath for uint256;
562   using Address for address;
563 
564   function safeTransfer(
565     IERC20 token,
566     address to,
567     uint256 value
568   ) internal {
569     _callOptionalReturn(
570       token,
571       abi.encodeWithSelector(token.transfer.selector, to, value)
572     );
573   }
574 
575   function safeTransferFrom(
576     IERC20 token,
577     address from,
578     address to,
579     uint256 value
580   ) internal {
581     _callOptionalReturn(
582       token,
583       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
584     );
585   }
586 
587   /**
588    * @dev Deprecated. This function has issues similar to the ones found in
589    * {IERC20-approve}, and its usage is discouraged.
590    *
591    * Whenever possible, use {safeIncreaseAllowance} and
592    * {safeDecreaseAllowance} instead.
593    */
594   function safeApprove(
595     IERC20 token,
596     address spender,
597     uint256 value
598   ) internal {
599     // safeApprove should only be called when setting an initial allowance,
600     // or when resetting it to zero. To increase and decrease it, use
601     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
602     // solhint-disable-next-line max-line-length
603     require(
604       (value == 0) || (token.allowance(address(this), spender) == 0),
605       "SafeERC20: approve from non-zero to non-zero allowance"
606     );
607     _callOptionalReturn(
608       token,
609       abi.encodeWithSelector(token.approve.selector, spender, value)
610     );
611   }
612 
613   function safeIncreaseAllowance(
614     IERC20 token,
615     address spender,
616     uint256 value
617   ) internal {
618     uint256 newAllowance = token.allowance(address(this), spender).add(value);
619     _callOptionalReturn(
620       token,
621       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
622     );
623   }
624 
625   function safeDecreaseAllowance(
626     IERC20 token,
627     address spender,
628     uint256 value
629   ) internal {
630     uint256 newAllowance =
631       token.allowance(address(this), spender).sub(
632         value,
633         "SafeERC20: decreased allowance below zero"
634       );
635     _callOptionalReturn(
636       token,
637       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
638     );
639   }
640 
641   /**
642    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
643    * on the return value: the return value is optional (but if data is returned, it must not be false).
644    * @param token The token targeted by the call.
645    * @param data The call data (encoded using abi.encode or one of its variants).
646    */
647   function _callOptionalReturn(IERC20 token, bytes memory data) private {
648     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
649     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
650     // the target address contains contract code and also asserts for success in the low-level call.
651     bytes memory returndata =
652       address(token).functionCall(data, "SafeERC20: low-level call failed");
653     if (returndata.length > 0) {
654       // Return data is optional
655       // solhint-disable-next-line max-line-length
656       require(
657         abi.decode(returndata, (bool)),
658         "SafeERC20: ERC20 operation did not succeed"
659       );
660     }
661   }
662 }
663 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
664 
665 pragma solidity >=0.6.0 <0.8.0;
666 
667 /**
668  * @dev These functions deal with verification of Merkle trees (hash trees),
669  */
670 library MerkleProof {
671   /**
672    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
673    * defined by `root`. For this, a `proof` must be provided, containing
674    * sibling hashes on the branch from the leaf to the root of the tree. Each
675    * pair of leaves and each pair of pre-images are assumed to be sorted.
676    */
677   function verify(
678     bytes32[] memory proof,
679     bytes32 root,
680     bytes32 leaf
681   ) internal pure returns (bool) {
682     bytes32 computedHash = leaf;
683     for (uint256 i = 0; i < proof.length; i++) {
684       bytes32 proofElement = proof[i];
685       if (computedHash <= proofElement) {
686         // Hash(current computed hash + current element of the proof)
687         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
688       } else {
689         // Hash(current element of the proof + current computed hash)
690         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
691       }
692     }
693     // Check if the computed hash (root) is equal to the provided root
694     return computedHash == root;
695   }
696 }
697 
698 // File: contracts/Pool.sol
699 /*
700   Copyright 2020 Swap Holdings Ltd.
701   Licensed under the Apache License, Version 2.0 (the "License");
702   you may not use this file except in compliance with the License.
703   You may obtain a copy of the License at
704     http://www.apache.org/licenses/LICENSE-2.0
705   Unless required by applicable law or agreed to in writing, software
706   distributed under the License is distributed on an "AS IS" BASIS,
707   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
708   See the License for the specific language governing permissions and
709   limitations under the License.
710 */
711 /**
712  * @title Pool: Claim Tokens Based on a Pricing Function
713  */
714 contract Pool is Ownable {
715   using SafeERC20 for IERC20;
716   using SafeMath for uint256;
717   uint256 internal constant MAX_PERCENTAGE = 100;
718   uint256 internal constant MAX_SCALE = 77;
719   // Larger the scale, lower the output for a claim
720   uint256 public scale;
721   // Max percentage for a claim with infinite score
722   uint256 public max;
723   // Mapping of tree root to boolean to enable claims
724   mapping(bytes32 => bool) public roots;
725   // Mapping of tree root to account to mark as claimed
726   mapping(bytes32 => mapping(address => bool)) public claimed;
727   /**
728    * @notice Events
729    */
730   event Enable(bytes32 root);
731   event Withdraw(
732     bytes32[] roots,
733     address account,
734     IERC20 token,
735     uint256 amount
736   );
737   event SetScale(uint256 scale);
738   event SetMax(uint256 max);
739   event DrainTo(IERC20[] tokens, address dest);
740   /**
741    * @notice Structs
742    */
743   struct Claim {
744     bytes32 root;
745     uint256 score;
746     bytes32[] proof;
747   }
748 
749   /**
750    * @notice Constructor
751    * @param _scale uint256
752    * @param _max uint256
753    */
754   constructor(uint256 _scale, uint256 _max) public {
755     require(_max <= MAX_PERCENTAGE, "MAX_TOO_HIGH");
756     require(_scale <= MAX_SCALE, "SCALE_TOO_HIGH");
757     scale = _scale;
758     max = _max;
759   }
760 
761   /**
762    * @notice Enables claims for a merkle tree of a set of scores
763    * @param root bytes32
764    */
765   function enable(bytes32 root) external onlyOwner {
766     require(roots[root] == false, "ROOT_EXISTS");
767     roots[root] = true;
768     emit Enable(root);
769   }
770 
771   /**
772    * @notice Withdraw tokens from the pool using claims
773    * @param claims Claim[]
774    * @param token IERC20
775    */
776   function withdraw(Claim[] memory claims, IERC20 token) external {
777     require(claims.length > 0, "CLAIMS_MUST_BE_PROVIDED");
778     uint256 totalScore = 0;
779     bytes32[] memory rootList = new bytes32[](claims.length);
780     Claim memory claim;
781     for (uint256 i = 0; i < claims.length; i++) {
782       claim = claims[i];
783       require(roots[claim.root], "ROOT_NOT_ENABLED");
784       require(!claimed[claim.root][msg.sender], "CLAIM_ALREADY_MADE");
785       require(
786         verify(msg.sender, claim.root, claim.score, claim.proof),
787         "PROOF_INVALID"
788       );
789       totalScore = totalScore.add(claim.score);
790       claimed[claim.root][msg.sender] = true;
791       rootList[i] = claim.root;
792     }
793     uint256 amount = calculate(totalScore, token);
794     token.safeTransfer(msg.sender, amount);
795     emit Withdraw(rootList, msg.sender, token, amount);
796   }
797 
798   /**
799    * @notice Calculate output amount for an input score
800    * @param score uint256
801    * @param token IERC20
802    */
803   function calculate(uint256 score, IERC20 token)
804     public
805     view
806     returns (uint256 amount)
807   {
808     uint256 balance = token.balanceOf(address(this));
809     uint256 divisor = (uint256(10)**scale).add(score);
810     return max.mul(score).mul(balance).div(divisor).div(100);
811   }
812 
813   /**
814    * @notice Calculate output amount for an input score
815    * @param score uint256
816    * @param tokens IERC20[]
817    */
818   function calculateMultiple(uint256 score, IERC20[] calldata tokens)
819     external
820     view
821     returns (uint256[] memory outputAmounts)
822   {
823     outputAmounts = new uint256[](tokens.length);
824     for (uint256 i = 0; i < tokens.length; i++) {
825       uint256 output = calculate(score, tokens[i]);
826       outputAmounts[i] = output;
827     }
828   }
829 
830   /**
831    * @notice Verify a claim proof
832    * @param participant address
833    * @param root bytes32
834    * @param score uint256
835    * @param proof bytes32[]
836    */
837   function verify(
838     address participant,
839     bytes32 root,
840     uint256 score,
841     bytes32[] memory proof
842   ) public view returns (bool valid) {
843     bytes32 leaf = keccak256(abi.encodePacked(participant, score));
844     return MerkleProof.verify(proof, root, leaf);
845   }
846 
847   /**
848    * @notice Set scale
849    * @dev Only owner
850    */
851   function setScale(uint256 _scale) external onlyOwner {
852     require(_scale <= MAX_SCALE, "SCALE_TOO_HIGH");
853     scale = _scale;
854     emit SetScale(scale);
855   }
856 
857   /**
858    * @notice Set max
859    * @dev Only owner
860    */
861   function setMax(uint256 _max) external onlyOwner {
862     require(_max <= MAX_PERCENTAGE, "MAX_TOO_HIGH");
863     max = _max;
864     emit SetMax(max);
865   }
866 
867   /**
868    * @notice Admin function to migrate funds
869    * @dev Only owner
870    * @param tokens IERC20[]
871    * @param dest address
872    */
873   function drainTo(IERC20[] calldata tokens, address dest) external onlyOwner {
874     for (uint256 i = 0; i < tokens.length; i++) {
875       uint256 bal = tokens[i].balanceOf(address(this));
876       tokens[i].safeTransfer(dest, bal);
877     }
878     emit DrainTo(tokens, dest);
879   }
880 }
881 
882 // File: contracts/Imports.sol
883 // import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";
884 // import "@gnosis.pm/mock-contract/contracts/MockContract.sol";
885 contract Imports {
886 
887 }

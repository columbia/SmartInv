1 pragma solidity 0.5.12;
2 pragma experimental ABIEncoderV2;
3 // File: @airswap/types/contracts/Types.sol
4 /*
5   Copyright 2019 Swap Holdings Ltd.
6   Licensed under the Apache License, Version 2.0 (the "License");
7   you may not use this file except in compliance with the License.
8   You may obtain a copy of the License at
9     http://www.apache.org/licenses/LICENSE-2.0
10   Unless required by applicable law or agreed to in writing, software
11   distributed under the License is distributed on an "AS IS" BASIS,
12   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13   See the License for the specific language governing permissions and
14   limitations under the License.
15 */
16 /**
17   * @title Types: Library of Swap Protocol Types and Hashes
18   */
19 library Types {
20   bytes constant internal EIP191_HEADER = "\x19\x01";
21   struct Order {
22     uint256 nonce;                // Unique per order and should be sequential
23     uint256 expiry;               // Expiry in seconds since 1 January 1970
24     Party signer;                 // Party to the trade that sets terms
25     Party sender;                 // Party to the trade that accepts terms
26     Party affiliate;              // Party compensated for facilitating (optional)
27     Signature signature;          // Signature of the order
28   }
29   struct Party {
30     bytes4 kind;                  // Interface ID of the token
31     address wallet;               // Wallet address of the party
32     address token;                // Contract address of the token
33     uint256 amount;               // Amount for ERC-20 or ERC-1155
34     uint256 id;                   // ID for ERC-721 or ERC-1155
35   }
36   struct Signature {
37     address signatory;            // Address of the wallet used to sign
38     address validator;            // Address of the intended swap contract
39     bytes1 version;               // EIP-191 signature version
40     uint8 v;                      // `v` value of an ECDSA signature
41     bytes32 r;                    // `r` value of an ECDSA signature
42     bytes32 s;                    // `s` value of an ECDSA signature
43   }
44   bytes32 constant internal DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
45     "EIP712Domain(",
46     "string name,",
47     "string version,",
48     "address verifyingContract",
49     ")"
50   ));
51   bytes32 constant internal ORDER_TYPEHASH = keccak256(abi.encodePacked(
52     "Order(",
53     "uint256 nonce,",
54     "uint256 expiry,",
55     "Party signer,",
56     "Party sender,",
57     "Party affiliate",
58     ")",
59     "Party(",
60     "bytes4 kind,",
61     "address wallet,",
62     "address token,",
63     "uint256 amount,",
64     "uint256 id",
65     ")"
66   ));
67   bytes32 constant internal PARTY_TYPEHASH = keccak256(abi.encodePacked(
68     "Party(",
69     "bytes4 kind,",
70     "address wallet,",
71     "address token,",
72     "uint256 amount,",
73     "uint256 id",
74     ")"
75   ));
76   /**
77     * @notice Hash an order into bytes32
78     * @dev EIP-191 header and domain separator included
79     * @param order Order The order to be hashed
80     * @param domainSeparator bytes32
81     * @return bytes32 A keccak256 abi.encodePacked value
82     */
83   function hashOrder(
84     Order calldata order,
85     bytes32 domainSeparator
86   ) external pure returns (bytes32) {
87     return keccak256(abi.encodePacked(
88       EIP191_HEADER,
89       domainSeparator,
90       keccak256(abi.encode(
91         ORDER_TYPEHASH,
92         order.nonce,
93         order.expiry,
94         keccak256(abi.encode(
95           PARTY_TYPEHASH,
96           order.signer.kind,
97           order.signer.wallet,
98           order.signer.token,
99           order.signer.amount,
100           order.signer.id
101         )),
102         keccak256(abi.encode(
103           PARTY_TYPEHASH,
104           order.sender.kind,
105           order.sender.wallet,
106           order.sender.token,
107           order.sender.amount,
108           order.sender.id
109         )),
110         keccak256(abi.encode(
111           PARTY_TYPEHASH,
112           order.affiliate.kind,
113           order.affiliate.wallet,
114           order.affiliate.token,
115           order.affiliate.amount,
116           order.affiliate.id
117         ))
118       ))
119     ));
120   }
121   /**
122     * @notice Hash domain parameters into bytes32
123     * @dev Used for signature validation (EIP-712)
124     * @param name bytes
125     * @param version bytes
126     * @param verifyingContract address
127     * @return bytes32 returns a keccak256 abi.encodePacked value
128     */
129   function hashDomain(
130     bytes calldata name,
131     bytes calldata version,
132     address verifyingContract
133   ) external pure returns (bytes32) {
134     return keccak256(abi.encode(
135       DOMAIN_TYPEHASH,
136       keccak256(name),
137       keccak256(version),
138       verifyingContract
139     ));
140   }
141 }
142 // File: @airswap/delegate/contracts/interfaces/IDelegate.sol
143 /*
144   Copyright 2019 Swap Holdings Ltd.
145   Licensed under the Apache License, Version 2.0 (the "License");
146   you may not use this file except in compliance with the License.
147   You may obtain a copy of the License at
148     http://www.apache.org/licenses/LICENSE-2.0
149   Unless required by applicable law or agreed to in writing, software
150   distributed under the License is distributed on an "AS IS" BASIS,
151   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
152   See the License for the specific language governing permissions and
153   limitations under the License.
154 */
155 interface IDelegate {
156   struct Rule {
157     uint256 maxSenderAmount;      // The maximum amount of ERC-20 token the delegate would send
158     uint256 priceCoef;            // Number to be multiplied by 10^(-priceExp) - the price coefficient
159     uint256 priceExp;             // Indicates location of the decimal priceCoef * 10^(-priceExp)
160   }
161   event SetRule(
162     address indexed owner,
163     address indexed senderToken,
164     address indexed signerToken,
165     uint256 maxSenderAmount,
166     uint256 priceCoef,
167     uint256 priceExp
168   );
169   event UnsetRule(
170     address indexed owner,
171     address indexed senderToken,
172     address indexed signerToken
173   );
174   event ProvideOrder(
175     address indexed owner,
176     address tradeWallet,
177     address indexed senderToken,
178     address indexed signerToken,
179     uint256 senderAmount,
180     uint256 priceCoef,
181     uint256 priceExp
182   );
183   function setRule(
184     address senderToken,
185     address signerToken,
186     uint256 maxSenderAmount,
187     uint256 priceCoef,
188     uint256 priceExp
189   ) external;
190   function unsetRule(
191     address senderToken,
192     address signerToken
193   ) external;
194   function provideOrder(
195     Types.Order calldata order
196   ) external;
197   function rules(address, address) external view returns (Rule memory);
198   function getSignerSideQuote(
199     uint256 senderAmount,
200     address senderToken,
201     address signerToken
202   ) external view returns (
203     uint256 signerAmount
204   );
205   function getSenderSideQuote(
206     uint256 signerAmount,
207     address signerToken,
208     address senderToken
209   ) external view returns (
210     uint256 senderAmount
211   );
212   function getMaxQuote(
213     address senderToken,
214     address signerToken
215   ) external view returns (
216     uint256 senderAmount,
217     uint256 signerAmount
218   );
219   function owner()
220     external view returns (address);
221   function tradeWallet()
222     external view returns (address);
223 }
224 // File: @airswap/indexer/contracts/interfaces/IIndexer.sol
225 /*
226   Copyright 2019 Swap Holdings Ltd.
227   Licensed under the Apache License, Version 2.0 (the "License");
228   you may not use this file except in compliance with the License.
229   You may obtain a copy of the License at
230     http://www.apache.org/licenses/LICENSE-2.0
231   Unless required by applicable law or agreed to in writing, software
232   distributed under the License is distributed on an "AS IS" BASIS,
233   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
234   See the License for the specific language governing permissions and
235   limitations under the License.
236 */
237 interface IIndexer {
238   event CreateIndex(
239     address indexed signerToken,
240     address indexed senderToken,
241     bytes2 protocol,
242     address indexAddress
243   );
244   event Stake(
245     address indexed staker,
246     address indexed signerToken,
247     address indexed senderToken,
248     bytes2 protocol,
249     uint256 stakeAmount
250   );
251   event Unstake(
252     address indexed staker,
253     address indexed signerToken,
254     address indexed senderToken,
255     bytes2 protocol,
256     uint256 stakeAmount
257   );
258   event AddTokenToBlacklist(
259     address token
260   );
261   event RemoveTokenFromBlacklist(
262     address token
263   );
264   function setLocatorWhitelist(
265     bytes2 protocol,
266     address newLocatorWhitelist
267   ) external;
268   function createIndex(
269     address signerToken,
270     address senderToken,
271     bytes2 protocol
272   ) external returns (address);
273   function addTokenToBlacklist(
274     address token
275   ) external;
276   function removeTokenFromBlacklist(
277     address token
278   ) external;
279   function setIntent(
280     address signerToken,
281     address senderToken,
282     bytes2 protocol,
283     uint256 stakingAmount,
284     bytes32 locator
285   ) external;
286   function unsetIntent(
287     address signerToken,
288     address senderToken,
289     bytes2 protocol
290   ) external;
291   function stakingToken() external view returns (address);
292   function indexes(address, address, bytes2) external view returns (address);
293   function tokenBlacklist(address) external view returns (bool);
294   function getStakedAmount(
295     address user,
296     address signerToken,
297     address senderToken,
298     bytes2 protocol
299   ) external view returns (uint256);
300   function getLocators(
301     address signerToken,
302     address senderToken,
303     bytes2 protocol,
304     address cursor,
305     uint256 limit
306   ) external view returns (
307     bytes32[] memory,
308     uint256[] memory,
309     address
310   );
311 }
312 // File: @airswap/swap/contracts/interfaces/ISwap.sol
313 /*
314   Copyright 2019 Swap Holdings Ltd.
315   Licensed under the Apache License, Version 2.0 (the "License");
316   you may not use this file except in compliance with the License.
317   You may obtain a copy of the License at
318     http://www.apache.org/licenses/LICENSE-2.0
319   Unless required by applicable law or agreed to in writing, software
320   distributed under the License is distributed on an "AS IS" BASIS,
321   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
322   See the License for the specific language governing permissions and
323   limitations under the License.
324 */
325 interface ISwap {
326   event Swap(
327     uint256 indexed nonce,
328     uint256 timestamp,
329     address indexed signerWallet,
330     uint256 signerAmount,
331     uint256 signerId,
332     address signerToken,
333     address indexed senderWallet,
334     uint256 senderAmount,
335     uint256 senderId,
336     address senderToken,
337     address affiliateWallet,
338     uint256 affiliateAmount,
339     uint256 affiliateId,
340     address affiliateToken
341   );
342   event Cancel(
343     uint256 indexed nonce,
344     address indexed signerWallet
345   );
346   event CancelUpTo(
347     uint256 indexed nonce,
348     address indexed signerWallet
349   );
350   event AuthorizeSender(
351     address indexed authorizerAddress,
352     address indexed authorizedSender
353   );
354   event AuthorizeSigner(
355     address indexed authorizerAddress,
356     address indexed authorizedSigner
357   );
358   event RevokeSender(
359     address indexed authorizerAddress,
360     address indexed revokedSender
361   );
362   event RevokeSigner(
363     address indexed authorizerAddress,
364     address indexed revokedSigner
365   );
366   /**
367     * @notice Atomic Token Swap
368     * @param order Types.Order
369     */
370   function swap(
371     Types.Order calldata order
372   ) external;
373   /**
374     * @notice Cancel one or more open orders by nonce
375     * @param nonces uint256[]
376     */
377   function cancel(
378     uint256[] calldata nonces
379   ) external;
380   /**
381     * @notice Cancels all orders below a nonce value
382     * @dev These orders can be made active by reducing the minimum nonce
383     * @param minimumNonce uint256
384     */
385   function cancelUpTo(
386     uint256 minimumNonce
387   ) external;
388   /**
389     * @notice Authorize a delegated sender
390     * @param authorizedSender address
391     */
392   function authorizeSender(
393     address authorizedSender
394   ) external;
395   /**
396     * @notice Authorize a delegated signer
397     * @param authorizedSigner address
398     */
399   function authorizeSigner(
400     address authorizedSigner
401   ) external;
402   /**
403     * @notice Revoke an authorization
404     * @param authorizedSender address
405     */
406   function revokeSender(
407     address authorizedSender
408   ) external;
409   /**
410     * @notice Revoke an authorization
411     * @param authorizedSigner address
412     */
413   function revokeSigner(
414     address authorizedSigner
415   ) external;
416   function senderAuthorizations(address, address) external view returns (bool);
417   function signerAuthorizations(address, address) external view returns (bool);
418   function signerNonceStatus(address, uint256) external view returns (byte);
419   function signerMinimumNonce(address) external view returns (uint256);
420 }
421 // File: openzeppelin-solidity/contracts/GSN/Context.sol
422 /*
423  * @dev Provides information about the current execution context, including the
424  * sender of the transaction and its data. While these are generally available
425  * via msg.sender and msg.data, they should not be accessed in such a direct
426  * manner, since when dealing with GSN meta-transactions the account sending and
427  * paying for execution may not be the actual sender (as far as an application
428  * is concerned).
429  *
430  * This contract is only required for intermediate, library-like contracts.
431  */
432 contract Context {
433     // Empty internal constructor, to prevent people from mistakenly deploying
434     // an instance of this contract, which should be used via inheritance.
435     constructor () internal { }
436     // solhint-disable-previous-line no-empty-blocks
437     function _msgSender() internal view returns (address payable) {
438         return msg.sender;
439     }
440     function _msgData() internal view returns (bytes memory) {
441         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
442         return msg.data;
443     }
444 }
445 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
446 /**
447  * @dev Contract module which provides a basic access control mechanism, where
448  * there is an account (an owner) that can be granted exclusive access to
449  * specific functions.
450  *
451  * This module is used through inheritance. It will make available the modifier
452  * `onlyOwner`, which can be applied to your functions to restrict their use to
453  * the owner.
454  */
455 contract Ownable is Context {
456     address private _owner;
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458     /**
459      * @dev Initializes the contract setting the deployer as the initial owner.
460      */
461     constructor () internal {
462         _owner = _msgSender();
463         emit OwnershipTransferred(address(0), _owner);
464     }
465     /**
466      * @dev Returns the address of the current owner.
467      */
468     function owner() public view returns (address) {
469         return _owner;
470     }
471     /**
472      * @dev Throws if called by any account other than the owner.
473      */
474     modifier onlyOwner() {
475         require(isOwner(), "Ownable: caller is not the owner");
476         _;
477     }
478     /**
479      * @dev Returns true if the caller is the current owner.
480      */
481     function isOwner() public view returns (bool) {
482         return _msgSender() == _owner;
483     }
484     /**
485      * @dev Leaves the contract without owner. It will not be possible to call
486      * `onlyOwner` functions anymore. Can only be called by the current owner.
487      *
488      * NOTE: Renouncing ownership will leave the contract without an owner,
489      * thereby removing any functionality that is only available to the owner.
490      */
491     function renounceOwnership() public onlyOwner {
492         emit OwnershipTransferred(_owner, address(0));
493         _owner = address(0);
494     }
495     /**
496      * @dev Transfers ownership of the contract to a new account (`newOwner`).
497      * Can only be called by the current owner.
498      */
499     function transferOwnership(address newOwner) public onlyOwner {
500         _transferOwnership(newOwner);
501     }
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      */
505     function _transferOwnership(address newOwner) internal {
506         require(newOwner != address(0), "Ownable: new owner is the zero address");
507         emit OwnershipTransferred(_owner, newOwner);
508         _owner = newOwner;
509     }
510 }
511 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
512 /**
513  * @dev Wrappers over Solidity's arithmetic operations with added overflow
514  * checks.
515  *
516  * Arithmetic operations in Solidity wrap on overflow. This can easily result
517  * in bugs, because programmers usually assume that an overflow raises an
518  * error, which is the standard behavior in high level programming languages.
519  * `SafeMath` restores this intuition by reverting the transaction when an
520  * operation overflows.
521  *
522  * Using this library instead of the unchecked operations eliminates an entire
523  * class of bugs, so it's recommended to use it always.
524  */
525 library SafeMath {
526     /**
527      * @dev Returns the addition of two unsigned integers, reverting on
528      * overflow.
529      *
530      * Counterpart to Solidity's `+` operator.
531      *
532      * Requirements:
533      * - Addition cannot overflow.
534      */
535     function add(uint256 a, uint256 b) internal pure returns (uint256) {
536         uint256 c = a + b;
537         require(c >= a, "SafeMath: addition overflow");
538         return c;
539     }
540     /**
541      * @dev Returns the subtraction of two unsigned integers, reverting on
542      * overflow (when the result is negative).
543      *
544      * Counterpart to Solidity's `-` operator.
545      *
546      * Requirements:
547      * - Subtraction cannot overflow.
548      */
549     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
550         return sub(a, b, "SafeMath: subtraction overflow");
551     }
552     /**
553      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
554      * overflow (when the result is negative).
555      *
556      * Counterpart to Solidity's `-` operator.
557      *
558      * Requirements:
559      * - Subtraction cannot overflow.
560      *
561      * _Available since v2.4.0._
562      */
563     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b <= a, errorMessage);
565         uint256 c = a - b;
566         return c;
567     }
568     /**
569      * @dev Returns the multiplication of two unsigned integers, reverting on
570      * overflow.
571      *
572      * Counterpart to Solidity's `*` operator.
573      *
574      * Requirements:
575      * - Multiplication cannot overflow.
576      */
577     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
578         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
579         // benefit is lost if 'b' is also tested.
580         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
581         if (a == 0) {
582             return 0;
583         }
584         uint256 c = a * b;
585         require(c / a == b, "SafeMath: multiplication overflow");
586         return c;
587     }
588     /**
589      * @dev Returns the integer division of two unsigned integers. Reverts on
590      * division by zero. The result is rounded towards zero.
591      *
592      * Counterpart to Solidity's `/` operator. Note: this function uses a
593      * `revert` opcode (which leaves remaining gas untouched) while Solidity
594      * uses an invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      * - The divisor cannot be zero.
598      */
599     function div(uint256 a, uint256 b) internal pure returns (uint256) {
600         return div(a, b, "SafeMath: division by zero");
601     }
602     /**
603      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
604      * division by zero. The result is rounded towards zero.
605      *
606      * Counterpart to Solidity's `/` operator. Note: this function uses a
607      * `revert` opcode (which leaves remaining gas untouched) while Solidity
608      * uses an invalid opcode to revert (consuming all remaining gas).
609      *
610      * Requirements:
611      * - The divisor cannot be zero.
612      *
613      * _Available since v2.4.0._
614      */
615     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
616         // Solidity only automatically asserts when dividing by 0
617         require(b > 0, errorMessage);
618         uint256 c = a / b;
619         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
620         return c;
621     }
622     /**
623      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
624      * Reverts when dividing by zero.
625      *
626      * Counterpart to Solidity's `%` operator. This function uses a `revert`
627      * opcode (which leaves remaining gas untouched) while Solidity uses an
628      * invalid opcode to revert (consuming all remaining gas).
629      *
630      * Requirements:
631      * - The divisor cannot be zero.
632      */
633     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
634         return mod(a, b, "SafeMath: modulo by zero");
635     }
636     /**
637      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
638      * Reverts with custom message when dividing by zero.
639      *
640      * Counterpart to Solidity's `%` operator. This function uses a `revert`
641      * opcode (which leaves remaining gas untouched) while Solidity uses an
642      * invalid opcode to revert (consuming all remaining gas).
643      *
644      * Requirements:
645      * - The divisor cannot be zero.
646      *
647      * _Available since v2.4.0._
648      */
649     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b != 0, errorMessage);
651         return a % b;
652     }
653 }
654 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
655 /**
656  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
657  * the optional functions; to access them see {ERC20Detailed}.
658  */
659 interface IERC20 {
660     /**
661      * @dev Returns the amount of tokens in existence.
662      */
663     function totalSupply() external view returns (uint256);
664     /**
665      * @dev Returns the amount of tokens owned by `account`.
666      */
667     function balanceOf(address account) external view returns (uint256);
668     /**
669      * @dev Moves `amount` tokens from the caller's account to `recipient`.
670      *
671      * Returns a boolean value indicating whether the operation succeeded.
672      *
673      * Emits a {Transfer} event.
674      */
675     function transfer(address recipient, uint256 amount) external returns (bool);
676     /**
677      * @dev Returns the remaining number of tokens that `spender` will be
678      * allowed to spend on behalf of `owner` through {transferFrom}. This is
679      * zero by default.
680      *
681      * This value changes when {approve} or {transferFrom} are called.
682      */
683     function allowance(address owner, address spender) external view returns (uint256);
684     /**
685      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
686      *
687      * Returns a boolean value indicating whether the operation succeeded.
688      *
689      * IMPORTANT: Beware that changing an allowance with this method brings the risk
690      * that someone may use both the old and the new allowance by unfortunate
691      * transaction ordering. One possible solution to mitigate this race
692      * condition is to first reduce the spender's allowance to 0 and set the
693      * desired value afterwards:
694      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
695      *
696      * Emits an {Approval} event.
697      */
698     function approve(address spender, uint256 amount) external returns (bool);
699     /**
700      * @dev Moves `amount` tokens from `sender` to `recipient` using the
701      * allowance mechanism. `amount` is then deducted from the caller's
702      * allowance.
703      *
704      * Returns a boolean value indicating whether the operation succeeded.
705      *
706      * Emits a {Transfer} event.
707      */
708     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
709     /**
710      * @dev Emitted when `value` tokens are moved from one account (`from`) to
711      * another (`to`).
712      *
713      * Note that `value` may be zero.
714      */
715     event Transfer(address indexed from, address indexed to, uint256 value);
716     /**
717      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
718      * a call to {approve}. `value` is the new allowance.
719      */
720     event Approval(address indexed owner, address indexed spender, uint256 value);
721 }
722 // File: @airswap/delegate/contracts/Delegate.sol
723 /*
724   Copyright 2019 Swap Holdings Ltd.
725   Licensed under the Apache License, Version 2.0 (the "License");
726   you may not use this file except in compliance with the License.
727   You may obtain a copy of the License at
728     http://www.apache.org/licenses/LICENSE-2.0
729   Unless required by applicable law or agreed to in writing, software
730   distributed under the License is distributed on an "AS IS" BASIS,
731   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
732   See the License for the specific language governing permissions and
733   limitations under the License.
734 */
735 /**
736   * @title Delegate: Deployable Trading Rules for the AirSwap Network
737   * @notice Supports fungible tokens (ERC-20)
738   * @dev inherits IDelegate, Ownable uses SafeMath library
739   */
740 contract Delegate is IDelegate, Ownable {
741   using SafeMath for uint256;
742   // The Swap contract to be used to settle trades
743   ISwap public swapContract;
744   // The Indexer to stake intent to trade on
745   IIndexer public indexer;
746   // Maximum integer for token transfer approval
747   uint256 constant internal MAX_INT =  2**256 - 1;
748   // Address holding tokens that will be trading through this delegate
749   address public tradeWallet;
750   // Mapping of senderToken to signerToken for rule lookup
751   mapping (address => mapping (address => Rule)) public rules;
752   // ERC-20 (fungible token) interface identifier (ERC-165)
753   bytes4 constant internal ERC20_INTERFACE_ID = 0x36372b07;
754   // The protocol identifier for setting intents on an Index
755   bytes2 public protocol;
756   /**
757     * @notice Contract Constructor
758     * @dev owner defaults to msg.sender if delegateContractOwner is provided as address(0)
759     * @param delegateSwap address Swap contract the delegate will deploy with
760     * @param delegateIndexer address Indexer contract the delegate will deploy with
761     * @param delegateContractOwner address Owner of the delegate
762     * @param delegateTradeWallet address Wallet the delegate will trade from
763     * @param delegateProtocol bytes2 The protocol identifier for Delegate contracts
764     */
765   constructor(
766     ISwap delegateSwap,
767     IIndexer delegateIndexer,
768     address delegateContractOwner,
769     address delegateTradeWallet,
770     bytes2 delegateProtocol
771   ) public {
772     swapContract = delegateSwap;
773     indexer = delegateIndexer;
774     protocol = delegateProtocol;
775     // If no delegate owner is provided, the deploying address is the owner.
776     if (delegateContractOwner != address(0)) {
777       transferOwnership(delegateContractOwner);
778     }
779     // If no trade wallet is provided, the owner's wallet is the trade wallet.
780     if (delegateTradeWallet != address(0)) {
781       tradeWallet = delegateTradeWallet;
782     } else {
783       tradeWallet = owner();
784     }
785     // Ensure that the indexer can pull funds from delegate account.
786     require(
787       IERC20(indexer.stakingToken())
788       .approve(address(indexer), MAX_INT), "STAKING_APPROVAL_FAILED"
789     );
790   }
791   /**
792     * @notice Set a Trading Rule
793     * @dev only callable by the owner of the contract
794     * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
795     * @param senderToken address Address of an ERC-20 token the delegate would send
796     * @param signerToken address Address of an ERC-20 token the consumer would send
797     * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
798     * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
799     * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
800     */
801   function setRule(
802     address senderToken,
803     address signerToken,
804     uint256 maxSenderAmount,
805     uint256 priceCoef,
806     uint256 priceExp
807   ) external onlyOwner {
808     _setRule(
809       senderToken,
810       signerToken,
811       maxSenderAmount,
812       priceCoef,
813       priceExp
814     );
815   }
816   /**
817     * @notice Unset a Trading Rule
818     * @dev only callable by the owner of the contract, removes from a mapping
819     * @param senderToken address Address of an ERC-20 token the delegate would send
820     * @param signerToken address Address of an ERC-20 token the consumer would send
821     */
822   function unsetRule(
823     address senderToken,
824     address signerToken
825   ) external onlyOwner {
826     _unsetRule(
827       senderToken,
828       signerToken
829     );
830   }
831   /**
832     * @notice sets a rule on the delegate and an intent on the indexer
833     * @dev only callable by owner
834     * @dev delegate needs to be given allowance from msg.sender for the newStakeAmount
835     * @dev swap needs to be given permission to move funds from the delegate
836     * @param senderToken address Token the delgeate will send
837     * @param signerToken address Token the delegate will receive
838     * @param rule Rule Rule to set on a delegate
839     * @param newStakeAmount uint256 Amount to stake for an intent
840     */
841   function setRuleAndIntent(
842     address senderToken,
843     address signerToken,
844     Rule calldata rule,
845     uint256 newStakeAmount
846   ) external onlyOwner {
847     _setRule(
848       senderToken,
849       signerToken,
850       rule.maxSenderAmount,
851       rule.priceCoef,
852       rule.priceExp
853     );
854     // get currentAmount staked or 0 if never staked
855     uint256 oldStakeAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
856     if (oldStakeAmount == newStakeAmount && oldStakeAmount > 0) {
857       return; // forgo trying to reset intent with non-zero same stake amount
858     } else if (oldStakeAmount < newStakeAmount) {
859       // transfer only the difference from the sender to the Delegate.
860       require(
861         IERC20(indexer.stakingToken())
862         .transferFrom(msg.sender, address(this), newStakeAmount - oldStakeAmount), "STAKING_TRANSFER_FAILED"
863       );
864     }
865     indexer.setIntent(
866       signerToken,
867       senderToken,
868       protocol,
869       newStakeAmount,
870       bytes32(uint256(address(this)) << 96) //NOTE: this will pad 0's to the right
871     );
872     if (oldStakeAmount > newStakeAmount) {
873       // return excess stake back
874       require(
875         IERC20(indexer.stakingToken())
876         .transfer(msg.sender, oldStakeAmount - newStakeAmount), "STAKING_RETURN_FAILED"
877       );
878     }
879   }
880   /**
881     * @notice unsets a rule on the delegate and removes an intent on the indexer
882     * @dev only callable by owner
883     * @param senderToken address Maker token in the token pair for rules and intents
884     * @param signerToken address Taker token  in the token pair for rules and intents
885     */
886   function unsetRuleAndIntent(
887     address senderToken,
888     address signerToken
889   ) external onlyOwner {
890     _unsetRule(senderToken, signerToken);
891     // Query the indexer for the amount staked.
892     uint256 stakedAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
893     indexer.unsetIntent(signerToken, senderToken, protocol);
894     // Upon unstaking, the Delegate will be given the staking amount.
895     // This is returned to the msg.sender.
896     if (stakedAmount > 0) {
897       require(
898         IERC20(indexer.stakingToken())
899           .transfer(msg.sender, stakedAmount),"STAKING_RETURN_FAILED"
900       );
901     }
902   }
903   /**
904     * @notice Provide an Order
905     * @dev Rules get reset with new maxSenderAmount
906     * @param order Types.Order Order a user wants to submit to Swap.
907     */
908   function provideOrder(
909     Types.Order calldata order
910   ) external {
911     Rule memory rule = rules[order.sender.token][order.signer.token];
912     require(order.signature.v != 0,
913       "SIGNATURE_MUST_BE_SENT");
914     // Ensure the order is for the trade wallet.
915     require(order.sender.wallet == tradeWallet,
916       "INVALID_SENDER_WALLET");
917     // Ensure the tokens are valid ERC20 tokens.
918     require(order.signer.kind == ERC20_INTERFACE_ID,
919       "SIGNER_KIND_MUST_BE_ERC20");
920     require(order.sender.kind == ERC20_INTERFACE_ID,
921       "SENDER_KIND_MUST_BE_ERC20");
922     // Ensure that a rule exists.
923     require(rule.maxSenderAmount != 0,
924       "TOKEN_PAIR_INACTIVE");
925     // Ensure the order does not exceed the maximum amount.
926     require(order.sender.amount <= rule.maxSenderAmount,
927       "AMOUNT_EXCEEDS_MAX");
928     // Ensure the order is priced according to the rule.
929     require(order.sender.amount <= _calculateSenderAmount(order.signer.amount, rule.priceCoef, rule.priceExp),
930       "PRICE_INVALID");
931     // Overwrite the rule with a decremented maxSenderAmount.
932     rules[order.sender.token][order.signer.token] = Rule({
933       maxSenderAmount: (rule.maxSenderAmount).sub(order.sender.amount),
934       priceCoef: rule.priceCoef,
935       priceExp: rule.priceExp
936     });
937     // Perform the swap.
938     swapContract.swap(order);
939     emit ProvideOrder(
940       owner(),
941       tradeWallet,
942       order.sender.token,
943       order.signer.token,
944       order.sender.amount,
945       rule.priceCoef,
946       rule.priceExp
947     );
948   }
949   /**
950     * @notice Set a new trade wallet
951     * @param newTradeWallet address Address of the new trade wallet
952     */
953   function setTradeWallet(address newTradeWallet) external onlyOwner {
954     require(newTradeWallet != address(0), "TRADE_WALLET_REQUIRED");
955     tradeWallet = newTradeWallet;
956   }
957   /**
958     * @notice Get a Signer-Side Quote from the Delegate
959     * @param senderAmount uint256 Amount of ERC-20 token the delegate would send
960     * @param senderToken address Address of an ERC-20 token the delegate would send
961     * @param signerToken address Address of an ERC-20 token the consumer would send
962     * @return uint256 signerAmount Amount of ERC-20 token the consumer would send
963     */
964   function getSignerSideQuote(
965     uint256 senderAmount,
966     address senderToken,
967     address signerToken
968   ) external view returns (
969     uint256 signerAmount
970   ) {
971     Rule memory rule = rules[senderToken][signerToken];
972     // Ensure that a rule exists.
973     if(rule.maxSenderAmount > 0) {
974       // Ensure the senderAmount does not exceed maximum for the rule.
975       if(senderAmount <= rule.maxSenderAmount) {
976         signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
977         // Return the quote.
978         return signerAmount;
979       }
980     }
981     return 0;
982   }
983   /**
984     * @notice Get a Sender-Side Quote from the Delegate
985     * @param signerAmount uint256 Amount of ERC-20 token the consumer would send
986     * @param signerToken address Address of an ERC-20 token the consumer would send
987     * @param senderToken address Address of an ERC-20 token the delegate would send
988     * @return uint256 senderAmount Amount of ERC-20 token the delegate would send
989     */
990   function getSenderSideQuote(
991     uint256 signerAmount,
992     address signerToken,
993     address senderToken
994   ) external view returns (
995     uint256 senderAmount
996   ) {
997     Rule memory rule = rules[senderToken][signerToken];
998     // Ensure that a rule exists.
999     if(rule.maxSenderAmount > 0) {
1000       // Calculate the senderAmount.
1001       senderAmount = _calculateSenderAmount(signerAmount, rule.priceCoef, rule.priceExp);
1002       // Ensure the senderAmount does not exceed the maximum trade amount.
1003       if(senderAmount <= rule.maxSenderAmount) {
1004         return senderAmount;
1005       }
1006     }
1007     return 0;
1008   }
1009   /**
1010     * @notice Get a Maximum Quote from the Delegate
1011     * @param senderToken address Address of an ERC-20 token the delegate would send
1012     * @param signerToken address Address of an ERC-20 token the consumer would send
1013     * @return uint256 senderAmount Amount the delegate would send
1014     * @return uint256 signerAmount Amount the consumer would send
1015     */
1016   function getMaxQuote(
1017     address senderToken,
1018     address signerToken
1019   ) external view returns (
1020     uint256 senderAmount,
1021     uint256 signerAmount
1022   ) {
1023     Rule memory rule = rules[senderToken][signerToken];
1024     senderAmount = rule.maxSenderAmount;
1025     // Ensure that a rule exists.
1026     if (senderAmount > 0) {
1027       // calculate the signerAmount
1028       signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
1029       // Return the maxSenderAmount and calculated signerAmount.
1030       return (
1031         senderAmount,
1032         signerAmount
1033       );
1034     }
1035     return (0, 0);
1036   }
1037   /**
1038     * @notice Set a Trading Rule
1039     * @dev only callable by the owner of the contract
1040     * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
1041     * @param senderToken address Address of an ERC-20 token the delegate would send
1042     * @param signerToken address Address of an ERC-20 token the consumer would send
1043     * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
1044     * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
1045     * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
1046     */
1047   function _setRule(
1048     address senderToken,
1049     address signerToken,
1050     uint256 maxSenderAmount,
1051     uint256 priceCoef,
1052     uint256 priceExp
1053   ) internal {
1054     require(priceCoef > 0, "INVALID_PRICE_COEF");
1055     rules[senderToken][signerToken] = Rule({
1056       maxSenderAmount: maxSenderAmount,
1057       priceCoef: priceCoef,
1058       priceExp: priceExp
1059     });
1060     emit SetRule(
1061       owner(),
1062       senderToken,
1063       signerToken,
1064       maxSenderAmount,
1065       priceCoef,
1066       priceExp
1067     );
1068   }
1069   /**
1070     * @notice Unset a Trading Rule
1071     * @param senderToken address Address of an ERC-20 token the delegate would send
1072     * @param signerToken address Address of an ERC-20 token the consumer would send
1073     */
1074   function _unsetRule(
1075     address senderToken,
1076     address signerToken
1077   ) internal {
1078     // using non-zero rule.priceCoef for rule existence check
1079     if (rules[senderToken][signerToken].priceCoef > 0) {
1080       // Delete the rule.
1081       delete rules[senderToken][signerToken];
1082       emit UnsetRule(
1083         owner(),
1084         senderToken,
1085         signerToken
1086     );
1087     }
1088   }
1089   /**
1090     * @notice Calculate the signer amount for a given sender amount and price
1091     * @param senderAmount uint256 The amount the delegate would send in the swap
1092     * @param priceCoef uint256 Coefficient of the token price defined in the rule
1093     * @param priceExp uint256 Exponent of the token price defined in the rule
1094     */
1095   function _calculateSignerAmount(
1096     uint256 senderAmount,
1097     uint256 priceCoef,
1098     uint256 priceExp
1099   ) internal pure returns (
1100     uint256 signerAmount
1101   ) {
1102     // Calculate the signer amount using the price formula
1103     uint256 multiplier = senderAmount.mul(priceCoef);
1104     signerAmount = multiplier.div(10 ** priceExp);
1105     // If the div rounded down, round up
1106     if (multiplier.mod(10 ** priceExp) > 0) {
1107       signerAmount++;
1108     }
1109   }
1110   /**
1111     * @notice Calculate the sender amount for a given signer amount and price
1112     * @param signerAmount uint256 The amount the signer would send in the swap
1113     * @param priceCoef uint256 Coefficient of the token price defined in the rule
1114     * @param priceExp uint256 Exponent of the token price defined in the rule
1115     */
1116   function _calculateSenderAmount(
1117     uint256 signerAmount,
1118     uint256 priceCoef,
1119     uint256 priceExp
1120   ) internal pure returns (
1121     uint256 senderAmount
1122   ) {
1123     // Calculate the sender anount using the price formula
1124     senderAmount = signerAmount
1125       .mul(10 ** priceExp)
1126       .div(priceCoef);
1127   }
1128 }
1129 // File: @airswap/delegate/contracts/interfaces/IDelegateFactory.sol
1130 /*
1131   Copyright 2019 Swap Holdings Ltd.
1132   Licensed under the Apache License, Version 2.0 (the "License");
1133   you may not use this file except in compliance with the License.
1134   You may obtain a copy of the License at
1135     http://www.apache.org/licenses/LICENSE-2.0
1136   Unless required by applicable law or agreed to in writing, software
1137   distributed under the License is distributed on an "AS IS" BASIS,
1138   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1139   See the License for the specific language governing permissions and
1140   limitations under the License.
1141 */
1142 interface IDelegateFactory {
1143   event CreateDelegate(
1144     address indexed delegateContract,
1145     address swapContract,
1146     address indexerContract,
1147     address indexed delegateContractOwner,
1148     address delegateTradeWallet
1149   );
1150   /**
1151     * @notice Deploy a trusted delegate contract
1152     * @param delegateTradeWallet the wallet the delegate will trade from
1153     * @return delegateContractAddress address of the delegate contract created
1154     */
1155   function createDelegate(
1156     address delegateTradeWallet
1157   ) external returns (address delegateContractAddress);
1158 }
1159 // File: @airswap/indexer/contracts/interfaces/ILocatorWhitelist.sol
1160 /*
1161   Copyright 2019 Swap Holdings Ltd.
1162   Licensed under the Apache License, Version 2.0 (the "License");
1163   you may not use this file except in compliance with the License.
1164   You may obtain a copy of the License at
1165     http://www.apache.org/licenses/LICENSE-2.0
1166   Unless required by applicable law or agreed to in writing, software
1167   distributed under the License is distributed on an "AS IS" BASIS,
1168   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1169   See the License for the specific language governing permissions and
1170   limitations under the License.
1171 */
1172 interface ILocatorWhitelist {
1173   function has(
1174     bytes32 locator
1175   ) external view returns (bool);
1176 }
1177 // File: @airswap/delegate/contracts/DelegateFactory.sol
1178 /*
1179   Copyright 2019 Swap Holdings Ltd.
1180   Licensed under the Apache License, Version 2.0 (the "License");
1181   you may not use this file except in compliance with the License.
1182   You may obtain a copy of the License at
1183     http://www.apache.org/licenses/LICENSE-2.0
1184   Unless required by applicable law or agreed to in writing, software
1185   distributed under the License is distributed on an "AS IS" BASIS,
1186   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1187   See the License for the specific language governing permissions and
1188   limitations under the License.
1189 */
1190 contract DelegateFactory is IDelegateFactory, ILocatorWhitelist {
1191   // Mapping specifying whether an address was deployed by this factory
1192   mapping(address => bool) internal _deployedAddresses;
1193   // The swap and indexer contracts to use in the deployment of Delegates
1194   ISwap public swapContract;
1195   IIndexer public indexerContract;
1196   bytes2 public protocol;
1197   /**
1198     * @notice Create a new Delegate contract
1199     * @dev swapContract is unable to be changed after the factory sets it
1200     * @param factorySwapContract address Swap contract the delegate will deploy with
1201     * @param factoryIndexerContract address Indexer contract the delegate will deploy with
1202     * @param factoryProtocol bytes2 Protocol type of the delegates the factory deploys
1203     */
1204   constructor(
1205     ISwap factorySwapContract,
1206     IIndexer factoryIndexerContract,
1207     bytes2 factoryProtocol
1208   ) public {
1209     swapContract = factorySwapContract;
1210     indexerContract = factoryIndexerContract;
1211     protocol = factoryProtocol;
1212   }
1213   /**
1214     * @param delegateTradeWallet address Wallet the delegate will trade from
1215     * @return address delegateContractAddress Address of the delegate contract created
1216     */
1217   function createDelegate(
1218     address delegateTradeWallet
1219   ) external returns (address delegateContractAddress) {
1220     delegateContractAddress = address(
1221       new Delegate(swapContract, indexerContract, msg.sender, delegateTradeWallet, protocol)
1222     );
1223     _deployedAddresses[delegateContractAddress] = true;
1224     emit CreateDelegate(
1225       delegateContractAddress,
1226       address(swapContract),
1227       address(indexerContract),
1228       msg.sender,
1229       delegateTradeWallet
1230     );
1231     return delegateContractAddress;
1232   }
1233   /**
1234     * @notice To check whether a locator was deployed
1235     * @dev Implements ILocatorWhitelist.has
1236     * @param locator bytes32 Locator of the delegate in question
1237     * @return bool True if the delegate was deployed by this contract
1238     */
1239   function has(bytes32 locator) external view returns (bool) {
1240     return _deployedAddresses[address(bytes20(locator))];
1241   }
1242 }
1243 // File: @airswap/indexer/contracts/Index.sol
1244 /*
1245   Copyright 2019 Swap Holdings Ltd.
1246   Licensed under the Apache License, Version 2.0 (the "License");
1247   you may not use this file except in compliance with the License.
1248   You may obtain a copy of the License at
1249     http://www.apache.org/licenses/LICENSE-2.0
1250   Unless required by applicable law or agreed to in writing, software
1251   distributed under the License is distributed on an "AS IS" BASIS,
1252   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1253   See the License for the specific language governing permissions and
1254   limitations under the License.
1255 */
1256 /**
1257   * @title Index: A List of Locators
1258   * @notice The Locators are sorted in reverse order based on the score
1259   * meaning that the first element in the list has the largest score
1260   * and final element has the smallest
1261   * @dev A mapping is used to mimic a circular linked list structure
1262   * where every mapping Entry contains a pointer to the next
1263   * and the previous
1264   */
1265 contract Index is Ownable {
1266   // The number of entries in the index
1267   uint256 public length;
1268   // Identifier to use for the head of the list
1269   address constant internal HEAD = address(uint160(2**160-1));
1270   // Mapping of an identifier to its entry
1271   mapping(address => Entry) public entries;
1272   /**
1273     * @notice Index Entry
1274     * @param score uint256
1275     * @param locator bytes32
1276     * @param prev address Previous address in the linked list
1277     * @param next address Next address in the linked list
1278     */
1279   struct Entry {
1280     bytes32 locator;
1281     uint256 score;
1282     address prev;
1283     address next;
1284   }
1285   /**
1286     * @notice Contract Events
1287     */
1288   event SetLocator(
1289     address indexed identifier,
1290     uint256 score,
1291     bytes32 indexed locator
1292   );
1293   event UnsetLocator(
1294     address indexed identifier
1295   );
1296   /**
1297     * @notice Contract Constructor
1298     */
1299   constructor() public {
1300     // Create initial entry.
1301     entries[HEAD] = Entry(bytes32(0), 0, HEAD, HEAD);
1302   }
1303   /**
1304     * @notice Set a Locator
1305     * @param identifier address On-chain address identifying the owner of a locator
1306     * @param score uint256 Score for the locator being set
1307     * @param locator bytes32 Locator
1308     */
1309   function setLocator(
1310     address identifier,
1311     uint256 score,
1312     bytes32 locator
1313   ) external onlyOwner {
1314     // Ensure the entry does not already exist.
1315     require(!_hasEntry(identifier), "ENTRY_ALREADY_EXISTS");
1316     _setLocator(identifier, score, locator);
1317     // Increment the index length.
1318     length = length + 1;
1319     emit SetLocator(identifier, score, locator);
1320   }
1321   /**
1322     * @notice Unset a Locator
1323     * @param identifier address On-chain address identifying the owner of a locator
1324     */
1325   function unsetLocator(
1326     address identifier
1327   ) external onlyOwner {
1328     _unsetLocator(identifier);
1329     // Decrement the index length.
1330     length = length - 1;
1331     emit UnsetLocator(identifier);
1332   }
1333   /**
1334     * @notice Update a Locator
1335     * @dev score and/or locator do not need to be different from old values
1336     * @param identifier address On-chain address identifying the owner of a locator
1337     * @param score uint256 Score for the locator being set
1338     * @param locator bytes32 Locator
1339     */
1340   function updateLocator(
1341     address identifier,
1342     uint256 score,
1343     bytes32 locator
1344   ) external onlyOwner {
1345     // Don't need to update length as it is not used in set/unset logic
1346     _unsetLocator(identifier);
1347     _setLocator(identifier, score, locator);
1348     emit SetLocator(identifier, score, locator);
1349   }
1350   /**
1351     * @notice Get a Score
1352     * @param identifier address On-chain address identifying the owner of a locator
1353     * @return uint256 Score corresponding to the identifier
1354     */
1355   function getScore(
1356     address identifier
1357   ) external view returns (uint256) {
1358     return entries[identifier].score;
1359   }
1360     /**
1361     * @notice Get a Locator
1362     * @param identifier address On-chain address identifying the owner of a locator
1363     * @return bytes32 Locator information
1364     */
1365   function getLocator(
1366     address identifier
1367   ) external view returns (bytes32) {
1368     return entries[identifier].locator;
1369   }
1370   /**
1371     * @notice Get a Range of Locators
1372     * @dev start value of 0x0 starts at the head
1373     * @param cursor address Cursor to start with
1374     * @param limit uint256 Maximum number of locators to return
1375     * @return bytes32[] List of locators
1376     * @return uint256[] List of scores corresponding to locators
1377     * @return address The next cursor to provide for pagination
1378     */
1379   function getLocators(
1380     address cursor,
1381     uint256 limit
1382   ) external view returns (
1383     bytes32[] memory locators,
1384     uint256[] memory scores,
1385     address nextCursor
1386   ) {
1387     address identifier;
1388     // If a valid cursor is provided, start there.
1389     if (cursor != address(0) && cursor != HEAD) {
1390       // Check that the provided cursor exists.
1391       if (!_hasEntry(cursor)) {
1392         return (new bytes32[](0), new uint256[](0), address(0));
1393       }
1394       // Set the starting identifier to the provided cursor.
1395       identifier = cursor;
1396     } else {
1397       identifier = entries[HEAD].next;
1398     }
1399     // Although it's not known how many entries are between `cursor` and the end
1400     // We know that it is no more than `length`
1401     uint256 size = (length < limit) ? length : limit;
1402     locators = new bytes32[](size);
1403     scores = new uint256[](size);
1404     // Iterate over the list until the end or size.
1405     uint256 i;
1406     while (i < size && identifier != HEAD) {
1407       locators[i] = entries[identifier].locator;
1408       scores[i] = entries[identifier].score;
1409       i = i + 1;
1410       identifier = entries[identifier].next;
1411     }
1412     return (locators, scores, identifier);
1413   }
1414   /**
1415     * @notice Internal function to set a Locator
1416     * @param identifier address On-chain address identifying the owner of a locator
1417     * @param score uint256 Score for the locator being set
1418     * @param locator bytes32 Locator
1419     */
1420   function _setLocator(
1421     address identifier,
1422     uint256 score,
1423     bytes32 locator
1424   ) internal {
1425     // Disallow locator set to 0x0 to ensure list integrity.
1426     require(locator != bytes32(0), "LOCATOR_MUST_BE_SENT");
1427     // Find the first entry with a lower score.
1428     address nextEntry = _getEntryLowerThan(score);
1429     // Link the new entry between previous and next.
1430     address prevEntry = entries[nextEntry].prev;
1431     entries[prevEntry].next = identifier;
1432     entries[nextEntry].prev = identifier;
1433     entries[identifier] = Entry(locator, score, prevEntry, nextEntry);
1434   }
1435   /**
1436     * @notice Internal function to unset a Locator
1437     * @param identifier address On-chain address identifying the owner of a locator
1438     */
1439   function _unsetLocator(
1440     address identifier
1441   ) internal {
1442     // Ensure the entry exists.
1443     require(_hasEntry(identifier), "ENTRY_DOES_NOT_EXIST");
1444     // Link the previous and next entries together.
1445     address prevUser = entries[identifier].prev;
1446     address nextUser = entries[identifier].next;
1447     entries[prevUser].next = nextUser;
1448     entries[nextUser].prev = prevUser;
1449     // Delete entry from the index.
1450     delete entries[identifier];
1451   }
1452   /**
1453     * @notice Check if the Index has an Entry
1454     * @param identifier address On-chain address identifying the owner of a locator
1455     * @return bool True if the identifier corresponds to an Entry in the list
1456     */
1457   function _hasEntry(
1458     address identifier
1459   ) internal view returns (bool) {
1460     return entries[identifier].locator != bytes32(0);
1461   }
1462   /**
1463     * @notice Returns the largest scoring Entry Lower than a Score
1464     * @param score uint256 Score in question
1465     * @return address Identifier of the largest score lower than score
1466     */
1467   function _getEntryLowerThan(
1468     uint256 score
1469   ) internal view returns (address) {
1470     address identifier = entries[HEAD].next;
1471     // Head indicates last because the list is circular.
1472     if (score == 0) {
1473       return HEAD;
1474     }
1475     // Iterate until a lower score is found.
1476     while (score <= entries[identifier].score) {
1477       identifier = entries[identifier].next;
1478     }
1479     return identifier;
1480   }
1481 }
1482 // File: @airswap/indexer/contracts/Indexer.sol
1483 /*
1484   Copyright 2019 Swap Holdings Ltd.
1485   Licensed under the Apache License, Version 2.0 (the "License");
1486   you may not use this file except in compliance with the License.
1487   You may obtain a copy of the License at
1488     http://www.apache.org/licenses/LICENSE-2.0
1489   Unless required by applicable law or agreed to in writing, software
1490   distributed under the License is distributed on an "AS IS" BASIS,
1491   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1492   See the License for the specific language governing permissions and
1493   limitations under the License.
1494 */
1495 /**
1496   * @title Indexer: A Collection of Index contracts by Token Pair
1497   */
1498 contract Indexer is IIndexer, Ownable {
1499   // Token to be used for staking (ERC-20)
1500   IERC20 public stakingToken;
1501   // Mapping of signer token to sender token to protocol type to index
1502   mapping (address => mapping (address => mapping (bytes2 => Index))) public indexes;
1503   // The whitelist contract for checking whether a peer is whitelisted per peer type
1504   mapping (bytes2 => address) public locatorWhitelists;
1505   // Mapping of token address to boolean
1506   mapping (address => bool) public tokenBlacklist;
1507   /**
1508     * @notice Contract Constructor
1509     * @param indexerStakingToken address
1510     */
1511   constructor(
1512     address indexerStakingToken
1513   ) public {
1514     stakingToken = IERC20(indexerStakingToken);
1515   }
1516   /**
1517     * @notice Modifier to check an index exists
1518     */
1519   modifier indexExists(address signerToken, address senderToken, bytes2 protocol) {
1520     require(indexes[signerToken][senderToken][protocol] != Index(0),
1521       "INDEX_DOES_NOT_EXIST");
1522     _;
1523   }
1524   /**
1525     * @notice Set the address of an ILocatorWhitelist to use
1526     * @dev Allows removal of locatorWhitelist by passing 0x0
1527     * @param newLocatorWhitelist address Locator whitelist
1528     */
1529   function setLocatorWhitelist(
1530     bytes2 protocol,
1531     address newLocatorWhitelist
1532   ) external onlyOwner {
1533     locatorWhitelists[protocol] = newLocatorWhitelist;
1534   }
1535   /**
1536     * @notice Create an Index (List of Locators for a Token Pair)
1537     * @dev Deploys a new Index contract and stores the address. If the Index already
1538     * @dev exists, returns its address, and does not emit a CreateIndex event
1539     * @param signerToken address Signer token for the Index
1540     * @param senderToken address Sender token for the Index
1541     */
1542   function createIndex(
1543     address signerToken,
1544     address senderToken,
1545     bytes2 protocol
1546   ) external returns (address) {
1547     // If the Index does not exist, create it.
1548     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1549       // Create a new Index contract for the token pair.
1550       indexes[signerToken][senderToken][protocol] = new Index();
1551       emit CreateIndex(signerToken, senderToken, protocol, address(indexes[signerToken][senderToken][protocol]));
1552     }
1553     // Return the address of the Index contract.
1554     return address(indexes[signerToken][senderToken][protocol]);
1555   }
1556   /**
1557     * @notice Add a Token to the Blacklist
1558     * @param token address Token to blacklist
1559     */
1560   function addTokenToBlacklist(
1561     address token
1562   ) external onlyOwner {
1563     if (!tokenBlacklist[token]) {
1564       tokenBlacklist[token] = true;
1565       emit AddTokenToBlacklist(token);
1566     }
1567   }
1568   /**
1569     * @notice Remove a Token from the Blacklist
1570     * @param token address Token to remove from the blacklist
1571     */
1572   function removeTokenFromBlacklist(
1573     address token
1574   ) external onlyOwner {
1575     if (tokenBlacklist[token]) {
1576       tokenBlacklist[token] = false;
1577       emit RemoveTokenFromBlacklist(token);
1578     }
1579   }
1580   /**
1581     * @notice Set an Intent to Trade
1582     * @dev Requires approval to transfer staking token for sender
1583     *
1584     * @param signerToken address Signer token of the Index being staked
1585     * @param senderToken address Sender token of the Index being staked
1586     * @param stakingAmount uint256 Amount being staked
1587     * @param locator bytes32 Locator of the staker
1588     */
1589   function setIntent(
1590     address signerToken,
1591     address senderToken,
1592     bytes2 protocol,
1593     uint256 stakingAmount,
1594     bytes32 locator
1595   ) external indexExists(signerToken, senderToken, protocol) {
1596     // If whitelist set, ensure the locator is valid.
1597     if (locatorWhitelists[protocol] != address(0)) {
1598       require(ILocatorWhitelist(locatorWhitelists[protocol]).has(locator),
1599       "LOCATOR_NOT_WHITELISTED");
1600     }
1601     // Ensure neither of the tokens are blacklisted.
1602     require(!tokenBlacklist[signerToken] && !tokenBlacklist[senderToken],
1603       "PAIR_IS_BLACKLISTED");
1604     bool notPreviouslySet = (indexes[signerToken][senderToken][protocol].getLocator(msg.sender) == bytes32(0));
1605     if (notPreviouslySet) {
1606       // Only transfer for staking if stakingAmount is set.
1607       if (stakingAmount > 0) {
1608         // Transfer the stakingAmount for staking.
1609         require(stakingToken.transferFrom(msg.sender, address(this), stakingAmount),
1610           "UNABLE_TO_STAKE");
1611       }
1612       // Set the locator on the index.
1613       indexes[signerToken][senderToken][protocol].setLocator(msg.sender, stakingAmount, locator);
1614       emit Stake(msg.sender, signerToken, senderToken, protocol, stakingAmount);
1615     } else {
1616       uint256 oldStake = indexes[signerToken][senderToken][protocol].getScore(msg.sender);
1617       _updateIntent(msg.sender, signerToken, senderToken, protocol, stakingAmount, locator, oldStake);
1618     }
1619   }
1620   /**
1621     * @notice Unset an Intent to Trade
1622     * @dev Users are allowed to unstake from blacklisted indexes
1623     *
1624     * @param signerToken address Signer token of the Index being unstaked
1625     * @param senderToken address Sender token of the Index being staked
1626     */
1627   function unsetIntent(
1628     address signerToken,
1629     address senderToken,
1630     bytes2 protocol
1631   ) external {
1632     _unsetIntent(msg.sender, signerToken, senderToken, protocol);
1633   }
1634   /**
1635     * @notice Get the locators of those trading a token pair
1636     * @dev Users are allowed to unstake from blacklisted indexes
1637     *
1638     * @param signerToken address Signer token of the trading pair
1639     * @param senderToken address Sender token of the trading pair
1640     * @param cursor address Address to start from
1641     * @param limit uint256 Total number of locators to return
1642     * @return bytes32[] List of locators
1643     * @return uint256[] List of scores corresponding to locators
1644     * @return address The next cursor to provide for pagination
1645     */
1646   function getLocators(
1647     address signerToken,
1648     address senderToken,
1649     bytes2 protocol,
1650     address cursor,
1651     uint256 limit
1652   ) external view returns (
1653     bytes32[] memory locators,
1654     uint256[] memory scores,
1655     address nextCursor
1656   ) {
1657     // Ensure neither token is blacklisted.
1658     if (tokenBlacklist[signerToken] || tokenBlacklist[senderToken]) {
1659       return (new bytes32[](0), new uint256[](0), address(0));
1660     }
1661     // Ensure the index exists.
1662     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1663       return (new bytes32[](0), new uint256[](0), address(0));
1664     }
1665     return indexes[signerToken][senderToken][protocol].getLocators(cursor, limit);
1666   }
1667   /**
1668     * @notice Gets the Stake Amount for a User
1669     * @param user address User who staked
1670     * @param signerToken address Signer token the user staked on
1671     * @param senderToken address Sender token the user staked on
1672     * @return uint256 Amount the user staked
1673     */
1674   function getStakedAmount(
1675     address user,
1676     address signerToken,
1677     address senderToken,
1678     bytes2 protocol
1679   ) public view returns (uint256 stakedAmount) {
1680     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1681       return 0;
1682     }
1683     // Return the score, equivalent to the stake amount.
1684     return indexes[signerToken][senderToken][protocol].getScore(user);
1685   }
1686   function _updateIntent(
1687     address user,
1688     address signerToken,
1689     address senderToken,
1690     bytes2 protocol,
1691     uint256 newAmount,
1692     bytes32 newLocator,
1693     uint256 oldAmount
1694   ) internal {
1695     // If the new stake is bigger, collect the difference.
1696     if (oldAmount < newAmount) {
1697       // Note: SafeMath not required due to the inequality check above
1698       require(stakingToken.transferFrom(user, address(this), newAmount - oldAmount),
1699         "UNABLE_TO_STAKE");
1700     }
1701     // If the old stake is bigger, return the excess.
1702     if (newAmount < oldAmount) {
1703       // Note: SafeMath not required due to the inequality check above
1704       require(stakingToken.transfer(user, oldAmount - newAmount));
1705     }
1706     // Update their intent.
1707     indexes[signerToken][senderToken][protocol].updateLocator(user, newAmount, newLocator);
1708     emit Stake(user, signerToken, senderToken, protocol, newAmount);
1709   }
1710   /**
1711     * @notice Unset intents and return staked tokens
1712     * @param user address Address of the user who staked
1713     * @param signerToken address Signer token of the trading pair
1714     * @param senderToken address Sender token of the trading pair
1715     */
1716   function _unsetIntent(
1717     address user,
1718     address signerToken,
1719     address senderToken,
1720     bytes2 protocol
1721   ) internal indexExists(signerToken, senderToken, protocol) {
1722      // Get the score for the user.
1723     uint256 score = indexes[signerToken][senderToken][protocol].getScore(user);
1724     // Unset the locator on the index.
1725     indexes[signerToken][senderToken][protocol].unsetLocator(user);
1726     if (score > 0) {
1727       // Return the staked tokens. Reverts on failure.
1728       require(stakingToken.transfer(user, score));
1729     }
1730     emit Unstake(user, signerToken, senderToken, protocol, score);
1731   }
1732 }
1733 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
1734 /**
1735  * @dev Interface of the ERC165 standard, as defined in the
1736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1737  *
1738  * Implementers can declare support of contract interfaces, which can then be
1739  * queried by others ({ERC165Checker}).
1740  *
1741  * For an implementation, see {ERC165}.
1742  */
1743 interface IERC165 {
1744     /**
1745      * @dev Returns true if this contract implements the interface defined by
1746      * `interfaceId`. See the corresponding
1747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1748      * to learn more about how these ids are created.
1749      *
1750      * This function call must use less than 30 000 gas.
1751      */
1752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1753 }
1754 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
1755 /**
1756  * @dev Required interface of an ERC721 compliant contract.
1757  */
1758 contract IERC721 is IERC165 {
1759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1761     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1762     /**
1763      * @dev Returns the number of NFTs in `owner`'s account.
1764      */
1765     function balanceOf(address owner) public view returns (uint256 balance);
1766     /**
1767      * @dev Returns the owner of the NFT specified by `tokenId`.
1768      */
1769     function ownerOf(uint256 tokenId) public view returns (address owner);
1770     /**
1771      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1772      * another (`to`).
1773      *
1774      *
1775      *
1776      * Requirements:
1777      * - `from`, `to` cannot be zero.
1778      * - `tokenId` must be owned by `from`.
1779      * - If the caller is not `from`, it must be have been allowed to move this
1780      * NFT by either {approve} or {setApprovalForAll}.
1781      */
1782     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1783     /**
1784      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1785      * another (`to`).
1786      *
1787      * Requirements:
1788      * - If the caller is not `from`, it must be approved to move this NFT by
1789      * either {approve} or {setApprovalForAll}.
1790      */
1791     function transferFrom(address from, address to, uint256 tokenId) public;
1792     function approve(address to, uint256 tokenId) public;
1793     function getApproved(uint256 tokenId) public view returns (address operator);
1794     function setApprovalForAll(address operator, bool _approved) public;
1795     function isApprovedForAll(address owner, address operator) public view returns (bool);
1796     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1797 }
1798 // File: openzeppelin-solidity/contracts/utils/Address.sol
1799 /**
1800  * @dev Collection of functions related to the address type
1801  */
1802 library Address {
1803     /**
1804      * @dev Returns true if `account` is a contract.
1805      *
1806      * This test is non-exhaustive, and there may be false-negatives: during the
1807      * execution of a contract's constructor, its address will be reported as
1808      * not containing a contract.
1809      *
1810      * IMPORTANT: It is unsafe to assume that an address for which this
1811      * function returns false is an externally-owned account (EOA) and not a
1812      * contract.
1813      */
1814     function isContract(address account) internal view returns (bool) {
1815         // This method relies in extcodesize, which returns 0 for contracts in
1816         // construction, since the code is only stored at the end of the
1817         // constructor execution.
1818         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1819         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1820         // for accounts without code, i.e. `keccak256('')`
1821         bytes32 codehash;
1822         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1823         // solhint-disable-next-line no-inline-assembly
1824         assembly { codehash := extcodehash(account) }
1825         return (codehash != 0x0 && codehash != accountHash);
1826     }
1827     /**
1828      * @dev Converts an `address` into `address payable`. Note that this is
1829      * simply a type cast: the actual underlying value is not changed.
1830      *
1831      * _Available since v2.4.0._
1832      */
1833     function toPayable(address account) internal pure returns (address payable) {
1834         return address(uint160(account));
1835     }
1836     /**
1837      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1838      * `recipient`, forwarding all available gas and reverting on errors.
1839      *
1840      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1841      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1842      * imposed by `transfer`, making them unable to receive funds via
1843      * `transfer`. {sendValue} removes this limitation.
1844      *
1845      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1846      *
1847      * IMPORTANT: because control is transferred to `recipient`, care must be
1848      * taken to not create reentrancy vulnerabilities. Consider using
1849      * {ReentrancyGuard} or the
1850      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1851      *
1852      * _Available since v2.4.0._
1853      */
1854     function sendValue(address payable recipient, uint256 amount) internal {
1855         require(address(this).balance >= amount, "Address: insufficient balance");
1856         // solhint-disable-next-line avoid-call-value
1857         (bool success, ) = recipient.call.value(amount)("");
1858         require(success, "Address: unable to send value, recipient may have reverted");
1859     }
1860 }
1861 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1862 /**
1863  * @title SafeERC20
1864  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1865  * contract returns false). Tokens that return no value (and instead revert or
1866  * throw on failure) are also supported, non-reverting calls are assumed to be
1867  * successful.
1868  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1869  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1870  */
1871 library SafeERC20 {
1872     using SafeMath for uint256;
1873     using Address for address;
1874     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1875         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1876     }
1877     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1878         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1879     }
1880     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1881         // safeApprove should only be called when setting an initial allowance,
1882         // or when resetting it to zero. To increase and decrease it, use
1883         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1884         // solhint-disable-next-line max-line-length
1885         require((value == 0) || (token.allowance(address(this), spender) == 0),
1886             "SafeERC20: approve from non-zero to non-zero allowance"
1887         );
1888         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1889     }
1890     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1891         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1892         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1893     }
1894     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1895         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1896         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1897     }
1898     /**
1899      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1900      * on the return value: the return value is optional (but if data is returned, it must not be false).
1901      * @param token The token targeted by the call.
1902      * @param data The call data (encoded using abi.encode or one of its variants).
1903      */
1904     function callOptionalReturn(IERC20 token, bytes memory data) private {
1905         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1906         // we're implementing it ourselves.
1907         // A Solidity high level call has three parts:
1908         //  1. The target address is checked to verify it contains contract code
1909         //  2. The call itself is made, and success asserted
1910         //  3. The return value is decoded, which in turn checks the size of the returned data.
1911         // solhint-disable-next-line max-line-length
1912         require(address(token).isContract(), "SafeERC20: call to non-contract");
1913         // solhint-disable-next-line avoid-low-level-calls
1914         (bool success, bytes memory returndata) = address(token).call(data);
1915         require(success, "SafeERC20: low-level call failed");
1916         if (returndata.length > 0) { // Return data is optional
1917             // solhint-disable-next-line max-line-length
1918             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1919         }
1920     }
1921 }
1922 // File: @airswap/swap/contracts/Swap.sol
1923 /*
1924   Copyright 2019 Swap Holdings Ltd.
1925   Licensed under the Apache License, Version 2.0 (the "License");
1926   you may not use this file except in compliance with the License.
1927   You may obtain a copy of the License at
1928     http://www.apache.org/licenses/LICENSE-2.0
1929   Unless required by applicable law or agreed to in writing, software
1930   distributed under the License is distributed on an "AS IS" BASIS,
1931   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1932   See the License for the specific language governing permissions and
1933   limitations under the License.
1934 */
1935 /**
1936   * @title Swap: The Atomic Swap used on the AirSwap Network
1937   */
1938 contract Swap is ISwap {
1939   using SafeMath for uint256;
1940   using SafeERC20 for IERC20;
1941   // Domain and version for use in signatures (EIP-712)
1942   bytes constant internal DOMAIN_NAME = "SWAP";
1943   bytes constant internal DOMAIN_VERSION = "2";
1944   // Unique domain identifier for use in signatures (EIP-712)
1945   bytes32 private _domainSeparator;
1946   // Possible nonce statuses
1947   byte constant internal AVAILABLE = 0x00;
1948   byte constant internal UNAVAILABLE = 0x01;
1949   // ERC-721 (non-fungible token) interface identifier (EIP-165)
1950   bytes4 constant internal ERC721_INTERFACE_ID = 0x80ac58cd;
1951   // Mapping of sender address to a delegated sender address and bool
1952   mapping (address => mapping (address => bool)) public senderAuthorizations;
1953   // Mapping of signer address to a delegated signer and bool
1954   mapping (address => mapping (address => bool)) public signerAuthorizations;
1955   // Mapping of signers to nonces with value AVAILABLE (0x00) or UNAVAILABLE (0x01)
1956   mapping (address => mapping (uint256 => byte)) public signerNonceStatus;
1957   // Mapping of signer addresses to an optionally set minimum valid nonce
1958   mapping (address => uint256) public signerMinimumNonce;
1959   /**
1960     * @notice Contract Constructor
1961     * @dev Sets domain for signature validation (EIP-712)
1962     */
1963   constructor() public {
1964     _domainSeparator = Types.hashDomain(
1965       DOMAIN_NAME,
1966       DOMAIN_VERSION,
1967       address(this)
1968     );
1969   }
1970   /**
1971     * @notice Atomic Token Swap
1972     * @param order Types.Order Order to settle
1973     */
1974   function swap(
1975     Types.Order calldata order
1976   ) external {
1977     // Ensure the order is not expired.
1978     require(order.expiry > block.timestamp,
1979       "ORDER_EXPIRED");
1980     // Ensure the nonce is AVAILABLE (0x00).
1981     require(signerNonceStatus[order.signer.wallet][order.nonce] == AVAILABLE,
1982       "ORDER_TAKEN_OR_CANCELLED");
1983     // Ensure the order nonce is above the minimum.
1984     require(order.nonce >= signerMinimumNonce[order.signer.wallet],
1985       "NONCE_TOO_LOW");
1986     // Mark the nonce UNAVAILABLE (0x01).
1987     signerNonceStatus[order.signer.wallet][order.nonce] = UNAVAILABLE;
1988     // Validate the sender side of the trade.
1989     address finalSenderWallet;
1990     if (order.sender.wallet == address(0)) {
1991       /**
1992         * Sender is not specified. The msg.sender of the transaction becomes
1993         * the sender of the order.
1994         */
1995       finalSenderWallet = msg.sender;
1996     } else {
1997       /**
1998         * Sender is specified. If the msg.sender is not the specified sender,
1999         * this determines whether the msg.sender is an authorized sender.
2000         */
2001       require(isSenderAuthorized(order.sender.wallet, msg.sender),
2002           "SENDER_UNAUTHORIZED");
2003       // The msg.sender is authorized.
2004       finalSenderWallet = order.sender.wallet;
2005     }
2006     // Validate the signer side of the trade.
2007     if (order.signature.v == 0) {
2008       /**
2009         * Signature is not provided. The signer may have authorized the
2010         * msg.sender to swap on its behalf, which does not require a signature.
2011         */
2012       require(isSignerAuthorized(order.signer.wallet, msg.sender),
2013         "SIGNER_UNAUTHORIZED");
2014     } else {
2015       /**
2016         * The signature is provided. Determine whether the signer is
2017         * authorized and if so validate the signature itself.
2018         */
2019       require(isSignerAuthorized(order.signer.wallet, order.signature.signatory),
2020         "SIGNER_UNAUTHORIZED");
2021       // Ensure the signature is valid.
2022       require(isValid(order, _domainSeparator),
2023         "SIGNATURE_INVALID");
2024     }
2025     // Transfer token from sender to signer.
2026     transferToken(
2027       finalSenderWallet,
2028       order.signer.wallet,
2029       order.sender.amount,
2030       order.sender.id,
2031       order.sender.token,
2032       order.sender.kind
2033     );
2034     // Transfer token from signer to sender.
2035     transferToken(
2036       order.signer.wallet,
2037       finalSenderWallet,
2038       order.signer.amount,
2039       order.signer.id,
2040       order.signer.token,
2041       order.signer.kind
2042     );
2043     // Transfer token from signer to affiliate if specified.
2044     if (order.affiliate.token != address(0)) {
2045       transferToken(
2046         order.signer.wallet,
2047         order.affiliate.wallet,
2048         order.affiliate.amount,
2049         order.affiliate.id,
2050         order.affiliate.token,
2051         order.affiliate.kind
2052       );
2053     }
2054     emit Swap(
2055       order.nonce,
2056       block.timestamp,
2057       order.signer.wallet,
2058       order.signer.amount,
2059       order.signer.id,
2060       order.signer.token,
2061       finalSenderWallet,
2062       order.sender.amount,
2063       order.sender.id,
2064       order.sender.token,
2065       order.affiliate.wallet,
2066       order.affiliate.amount,
2067       order.affiliate.id,
2068       order.affiliate.token
2069     );
2070   }
2071   /**
2072     * @notice Cancel one or more open orders by nonce
2073     * @dev Cancelled nonces are marked UNAVAILABLE (0x01)
2074     * @dev Emits a Cancel event
2075     * @dev Out of gas may occur in arrays of length > 400
2076     * @param nonces uint256[] List of nonces to cancel
2077     */
2078   function cancel(
2079     uint256[] calldata nonces
2080   ) external {
2081     for (uint256 i = 0; i < nonces.length; i++) {
2082       if (signerNonceStatus[msg.sender][nonces[i]] == AVAILABLE) {
2083         signerNonceStatus[msg.sender][nonces[i]] = UNAVAILABLE;
2084         emit Cancel(nonces[i], msg.sender);
2085       }
2086     }
2087   }
2088   /**
2089     * @notice Cancels all orders below a nonce value
2090     * @dev Emits a CancelUpTo event
2091     * @param minimumNonce uint256 Minimum valid nonce
2092     */
2093   function cancelUpTo(
2094     uint256 minimumNonce
2095   ) external {
2096     signerMinimumNonce[msg.sender] = minimumNonce;
2097     emit CancelUpTo(minimumNonce, msg.sender);
2098   }
2099   /**
2100     * @notice Authorize a delegated sender
2101     * @dev Emits an AuthorizeSender event
2102     * @param authorizedSender address Address to authorize
2103     */
2104   function authorizeSender(
2105     address authorizedSender
2106   ) external {
2107     require(msg.sender != authorizedSender, "INVALID_AUTH_SENDER");
2108     if (!senderAuthorizations[msg.sender][authorizedSender]) {
2109       senderAuthorizations[msg.sender][authorizedSender] = true;
2110       emit AuthorizeSender(msg.sender, authorizedSender);
2111     }
2112   }
2113   /**
2114     * @notice Authorize a delegated signer
2115     * @dev Emits an AuthorizeSigner event
2116     * @param authorizedSigner address Address to authorize
2117     */
2118   function authorizeSigner(
2119     address authorizedSigner
2120   ) external {
2121     require(msg.sender != authorizedSigner, "INVALID_AUTH_SIGNER");
2122     if (!signerAuthorizations[msg.sender][authorizedSigner]) {
2123       signerAuthorizations[msg.sender][authorizedSigner] = true;
2124       emit AuthorizeSigner(msg.sender, authorizedSigner);
2125     }
2126   }
2127   /**
2128     * @notice Revoke an authorized sender
2129     * @dev Emits a RevokeSender event
2130     * @param authorizedSender address Address to revoke
2131     */
2132   function revokeSender(
2133     address authorizedSender
2134   ) external {
2135     if (senderAuthorizations[msg.sender][authorizedSender]) {
2136       delete senderAuthorizations[msg.sender][authorizedSender];
2137       emit RevokeSender(msg.sender, authorizedSender);
2138     }
2139   }
2140   /**
2141     * @notice Revoke an authorized signer
2142     * @dev Emits a RevokeSigner event
2143     * @param authorizedSigner address Address to revoke
2144     */
2145   function revokeSigner(
2146     address authorizedSigner
2147   ) external {
2148     if (signerAuthorizations[msg.sender][authorizedSigner]) {
2149       delete signerAuthorizations[msg.sender][authorizedSigner];
2150       emit RevokeSigner(msg.sender, authorizedSigner);
2151     }
2152   }
2153   /**
2154     * @notice Determine whether a sender delegate is authorized
2155     * @param authorizer address Address doing the authorization
2156     * @param delegate address Address being authorized
2157     * @return bool True if a delegate is authorized to send
2158     */
2159   function isSenderAuthorized(
2160     address authorizer,
2161     address delegate
2162   ) internal view returns (bool) {
2163     return ((authorizer == delegate) ||
2164       senderAuthorizations[authorizer][delegate]);
2165   }
2166   /**
2167     * @notice Determine whether a signer delegate is authorized
2168     * @param authorizer address Address doing the authorization
2169     * @param delegate address Address being authorized
2170     * @return bool True if a delegate is authorized to sign
2171     */
2172   function isSignerAuthorized(
2173     address authorizer,
2174     address delegate
2175   ) internal view returns (bool) {
2176     return ((authorizer == delegate) ||
2177       signerAuthorizations[authorizer][delegate]);
2178   }
2179   /**
2180     * @notice Validate signature using an EIP-712 typed data hash
2181     * @param order Types.Order Order to validate
2182     * @param domainSeparator bytes32 Domain identifier used in signatures (EIP-712)
2183     * @return bool True if order has a valid signature
2184     */
2185   function isValid(
2186     Types.Order memory order,
2187     bytes32 domainSeparator
2188   ) internal pure returns (bool) {
2189     if (order.signature.version == byte(0x01)) {
2190       return order.signature.signatory == ecrecover(
2191         Types.hashOrder(
2192           order,
2193           domainSeparator
2194         ),
2195         order.signature.v,
2196         order.signature.r,
2197         order.signature.s
2198       );
2199     }
2200     if (order.signature.version == byte(0x45)) {
2201       return order.signature.signatory == ecrecover(
2202         keccak256(
2203           abi.encodePacked(
2204             "\x19Ethereum Signed Message:\n32",
2205             Types.hashOrder(order, domainSeparator)
2206           )
2207         ),
2208         order.signature.v,
2209         order.signature.r,
2210         order.signature.s
2211       );
2212     }
2213     return false;
2214   }
2215   /**
2216     * @notice Perform an ERC-20 or ERC-721 token transfer
2217     * @dev Transfer type specified by the bytes4 kind param
2218     * @dev ERC721: uses transferFrom for transfer
2219     * @dev ERC20: Takes into account non-standard ERC-20 tokens.
2220     * @param from address Wallet address to transfer from
2221     * @param to address Wallet address to transfer to
2222     * @param amount uint256 Amount for ERC-20
2223     * @param id token ID for ERC-721
2224     * @param token address Contract address of token
2225     * @param kind bytes4 EIP-165 interface ID of the token
2226     */
2227   function transferToken(
2228       address from,
2229       address to,
2230       uint256 amount,
2231       uint256 id,
2232       address token,
2233       bytes4 kind
2234   ) internal {
2235     // Ensure the transfer is not to self.
2236     require(from != to, "INVALID_SELF_TRANSFER");
2237     if (kind == ERC721_INTERFACE_ID) {
2238       require(amount == 0, "NO_AMOUNT_FIELD_IN_ERC721");
2239       // Attempt to transfer an ERC-721 token.
2240       IERC721(token).transferFrom(from, to, id);
2241     } else {
2242       require(id == 0, "NO_ID_FIELD_IN_ERC20");
2243       // Attempt to transfer an ERC-20 token, underlying SafeERC20 calls require.
2244       IERC20(token).safeTransferFrom(from, to, amount);
2245     }
2246   }
2247 }
2248 // File: @airswap/tokens/contracts/interfaces/IWETH.sol
2249 interface IWETH {
2250   function deposit() external payable;
2251   function withdraw(uint256) external;
2252   function totalSupply() external view returns (uint256);
2253   function balanceOf(address account) external view returns (uint256);
2254   function transfer(address recipient, uint256 amount) external returns (bool);
2255   function allowance(address owner, address spender) external view returns (uint256);
2256   function approve(address spender, uint256 amount) external returns (bool);
2257   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2258   event Transfer(address indexed from, address indexed to, uint256 value);
2259   event Approval(address indexed owner, address indexed spender, uint256 value);
2260 }
2261 // File: @airswap/wrapper/contracts/Wrapper.sol
2262 /*
2263   Copyright 2019 Swap Holdings Ltd.
2264   Licensed under the Apache License, Version 2.0 (the "License");
2265   you may not use this file except in compliance with the License.
2266   You may obtain a copy of the License at
2267     http://www.apache.org/licenses/LICENSE-2.0
2268   Unless required by applicable law or agreed to in writing, software
2269   distributed under the License is distributed on an "AS IS" BASIS,
2270   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2271   See the License for the specific language governing permissions and
2272   limitations under the License.
2273 */
2274 /**
2275   * @title Wrapper: Send and receive ether for WETH trades
2276   */
2277 contract Wrapper {
2278   // The Swap contract to settle trades
2279   ISwap public swapContract;
2280   // The WETH contract to wrap ether
2281   IWETH public wethContract;
2282   /**
2283     * @notice Contract Constructor
2284     * @param wrapperSwapContract address
2285     * @param wrapperWethContract address
2286     */
2287   constructor(
2288     address wrapperSwapContract,
2289     address wrapperWethContract
2290   ) public {
2291     swapContract = ISwap(wrapperSwapContract);
2292     wethContract = IWETH(wrapperWethContract);
2293   }
2294   /**
2295     * @notice Required when withdrawing from WETH
2296     * @dev During unwraps, WETH.withdraw transfers ether to msg.sender (this contract)
2297     */
2298   function() external payable {
2299     // Ensure the message sender is the WETH contract.
2300     if(msg.sender != address(wethContract)) {
2301       revert("DO_NOT_SEND_ETHER");
2302     }
2303   }
2304   /**
2305     * @notice Send an Order to be forwarded to Swap
2306     * @dev Sender must authorize this contract on the swapContract
2307     * @dev Sender must approve this contract on the wethContract
2308     * @param order Types.Order The Order
2309     */
2310   function swap(
2311     Types.Order calldata order
2312   ) external payable {
2313     // Ensure msg.sender is sender wallet.
2314     require(order.sender.wallet == msg.sender,
2315       "MSG_SENDER_MUST_BE_ORDER_SENDER");
2316     // Ensure that the signature is present.
2317     // The signature will be explicitly checked in Swap.
2318     require(order.signature.v != 0,
2319       "SIGNATURE_MUST_BE_SENT");
2320     // Wraps ETH to WETH when the sender provides ETH and the order is WETH
2321     _wrapEther(order.sender);
2322     // Perform the swap.
2323     swapContract.swap(order);
2324     // Unwraps WETH to ETH when the sender receives WETH
2325     _unwrapEther(order.sender.wallet, order.signer.token, order.signer.amount);
2326   }
2327   /**
2328     * @notice Send an Order to be forwarded to a Delegate
2329     * @dev Sender must authorize the Delegate contract on the swapContract
2330     * @dev Sender must approve this contract on the wethContract
2331     * @dev Delegate's tradeWallet must be order.sender - checked in Delegate
2332     * @param order Types.Order The Order
2333     * @param delegate IDelegate The Delegate to provide the order to
2334     */
2335   function provideDelegateOrder(
2336     Types.Order calldata order,
2337     IDelegate delegate
2338   ) external payable {
2339     // Ensure that the signature is present.
2340     // The signature will be explicitly checked in Swap.
2341     require(order.signature.v != 0,
2342       "SIGNATURE_MUST_BE_SENT");
2343     // Wraps ETH to WETH when the signer provides ETH and the order is WETH
2344     _wrapEther(order.signer);
2345     // Provide the order to the Delegate.
2346     delegate.provideOrder(order);
2347     // Unwraps WETH to ETH when the signer receives WETH
2348     _unwrapEther(order.signer.wallet, order.sender.token, order.sender.amount);
2349   }
2350   /**
2351     * @notice Wraps ETH to WETH when a trade requires it
2352     * @param party Types.Party The side of the trade that may need wrapping
2353     */
2354   function _wrapEther(Types.Party memory party) internal {
2355     // Check whether ether needs wrapping
2356     if (party.token == address(wethContract)) {
2357       // Ensure message value is param.
2358       require(party.amount == msg.value,
2359         "VALUE_MUST_BE_SENT");
2360       // Wrap (deposit) the ether.
2361       wethContract.deposit.value(msg.value)();
2362       // Transfer the WETH from the wrapper to party.
2363       // Return value not checked - WETH throws on error and does not return false
2364       wethContract.transfer(party.wallet, party.amount);
2365     } else {
2366       // Ensure no unexpected ether is sent.
2367       require(msg.value == 0,
2368         "VALUE_MUST_BE_ZERO");
2369     }
2370   }
2371   /**
2372     * @notice Unwraps WETH to ETH when a trade requires it
2373     * @dev The unwrapping only succeeds if recipientWallet has approved transferFrom
2374     * @param recipientWallet address The trade recipient, who may have received WETH
2375     * @param receivingToken address The token address the recipient received
2376     * @param amount uint256 The amount of token the recipient received
2377     */
2378   function _unwrapEther(address recipientWallet, address receivingToken, uint256 amount) internal {
2379     // Check whether ether needs unwrapping
2380     if (receivingToken == address(wethContract)) {
2381       // Transfer weth from the recipient to the wrapper.
2382       wethContract.transferFrom(recipientWallet, address(this), amount);
2383       // Unwrap (withdraw) the ether.
2384       wethContract.withdraw(amount);
2385       // Transfer ether to the recipient.
2386       // solium-disable-next-line security/no-call-value
2387       (bool success, ) = recipientWallet.call.value(amount)("");
2388       require(success, "ETH_RETURN_FAILED");
2389     }
2390   }
2391 }
2392 // File: contracts/Imports.sol
2393 //Import all the contracts desired to be deployed
2394 contract Imports {}

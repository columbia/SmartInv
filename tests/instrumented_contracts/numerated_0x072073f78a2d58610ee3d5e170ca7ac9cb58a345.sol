1 pragma solidity 0.5.12;
2 pragma experimental ABIEncoderV2;
3 // File: @airswap/types/contracts/Types.sol
4 /*
5   Copyright 2020 Swap Holdings Ltd.
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
144   Copyright 2020 Swap Holdings Ltd.
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
226   Copyright 2020 Swap Holdings Ltd.
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
312 // File: @airswap/transfers/contracts/interfaces/ITransferHandler.sol
313 /*
314   Copyright 2020 Swap Holdings Ltd.
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
325 /**
326   * @title ITransferHandler: interface for token transfers
327   */
328 interface ITransferHandler {
329  /**
330   * @notice Function to wrap token transfer for different token types
331   * @param from address Wallet address to transfer from
332   * @param to address Wallet address to transfer to
333   * @param amount uint256 Amount for ERC-20
334   * @param id token ID for ERC-721
335   * @param token address Contract address of token
336   * @return bool on success of the token transfer
337   */
338   function transferTokens(
339     address from,
340     address to,
341     uint256 amount,
342     uint256 id,
343     address token
344   ) external returns (bool);
345 }
346 // File: openzeppelin-solidity/contracts/GSN/Context.sol
347 /*
348  * @dev Provides information about the current execution context, including the
349  * sender of the transaction and its data. While these are generally available
350  * via msg.sender and msg.data, they should not be accessed in such a direct
351  * manner, since when dealing with GSN meta-transactions the account sending and
352  * paying for execution may not be the actual sender (as far as an application
353  * is concerned).
354  *
355  * This contract is only required for intermediate, library-like contracts.
356  */
357 contract Context {
358     // Empty internal constructor, to prevent people from mistakenly deploying
359     // an instance of this contract, which should be used via inheritance.
360     constructor () internal { }
361     // solhint-disable-previous-line no-empty-blocks
362     function _msgSender() internal view returns (address payable) {
363         return msg.sender;
364     }
365     function _msgData() internal view returns (bytes memory) {
366         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
367         return msg.data;
368     }
369 }
370 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
371 /**
372  * @dev Contract module which provides a basic access control mechanism, where
373  * there is an account (an owner) that can be granted exclusive access to
374  * specific functions.
375  *
376  * This module is used through inheritance. It will make available the modifier
377  * `onlyOwner`, which can be applied to your functions to restrict their use to
378  * the owner.
379  */
380 contract Ownable is Context {
381     address private _owner;
382     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
383     /**
384      * @dev Initializes the contract setting the deployer as the initial owner.
385      */
386     constructor () internal {
387         _owner = _msgSender();
388         emit OwnershipTransferred(address(0), _owner);
389     }
390     /**
391      * @dev Returns the address of the current owner.
392      */
393     function owner() public view returns (address) {
394         return _owner;
395     }
396     /**
397      * @dev Throws if called by any account other than the owner.
398      */
399     modifier onlyOwner() {
400         require(isOwner(), "Ownable: caller is not the owner");
401         _;
402     }
403     /**
404      * @dev Returns true if the caller is the current owner.
405      */
406     function isOwner() public view returns (bool) {
407         return _msgSender() == _owner;
408     }
409     /**
410      * @dev Leaves the contract without owner. It will not be possible to call
411      * `onlyOwner` functions anymore. Can only be called by the current owner.
412      *
413      * NOTE: Renouncing ownership will leave the contract without an owner,
414      * thereby removing any functionality that is only available to the owner.
415      */
416     function renounceOwnership() public onlyOwner {
417         emit OwnershipTransferred(_owner, address(0));
418         _owner = address(0);
419     }
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Can only be called by the current owner.
423      */
424     function transferOwnership(address newOwner) public onlyOwner {
425         _transferOwnership(newOwner);
426     }
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      */
430     function _transferOwnership(address newOwner) internal {
431         require(newOwner != address(0), "Ownable: new owner is the zero address");
432         emit OwnershipTransferred(_owner, newOwner);
433         _owner = newOwner;
434     }
435 }
436 // File: @airswap/transfers/contracts/TransferHandlerRegistry.sol
437 /*
438   Copyright 2020 Swap Holdings Ltd.
439   Licensed under the Apache License, Version 2.0 (the "License");
440   you may not use this file except in compliance with the License.
441   You may obtain a copy of the License at
442     http://www.apache.org/licenses/LICENSE-2.0
443   Unless required by applicable law or agreed to in writing, software
444   distributed under the License is distributed on an "AS IS" BASIS,
445   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
446   See the License for the specific language governing permissions and
447   limitations under the License.
448 */
449 /**
450   * @title TransferHandlerRegistry: holds registry of contract to
451   * facilitate token transfers
452   */
453 contract TransferHandlerRegistry is Ownable {
454   event AddTransferHandler(
455     bytes4 kind,
456     address contractAddress
457   );
458   // Mapping of bytes4 to contract interface type
459   mapping (bytes4 => ITransferHandler) public transferHandlers;
460   /**
461   * @notice Adds handler to mapping
462   * @param kind bytes4 Key value that defines a token type
463   * @param transferHandler ITransferHandler
464   */
465   function addTransferHandler(bytes4 kind, ITransferHandler transferHandler)
466     external onlyOwner {
467       require(address(transferHandlers[kind]) == address(0), "HANDLER_EXISTS_FOR_KIND");
468       transferHandlers[kind] = transferHandler;
469       emit AddTransferHandler(kind, address(transferHandler));
470     }
471 }
472 // File: @airswap/swap/contracts/interfaces/ISwap.sol
473 /*
474   Copyright 2020 Swap Holdings Ltd.
475   Licensed under the Apache License, Version 2.0 (the "License");
476   you may not use this file except in compliance with the License.
477   You may obtain a copy of the License at
478     http://www.apache.org/licenses/LICENSE-2.0
479   Unless required by applicable law or agreed to in writing, software
480   distributed under the License is distributed on an "AS IS" BASIS,
481   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
482   See the License for the specific language governing permissions and
483   limitations under the License.
484 */
485 interface ISwap {
486   event Swap(
487     uint256 indexed nonce,
488     uint256 timestamp,
489     address indexed signerWallet,
490     uint256 signerAmount,
491     uint256 signerId,
492     address signerToken,
493     address indexed senderWallet,
494     uint256 senderAmount,
495     uint256 senderId,
496     address senderToken,
497     address affiliateWallet,
498     uint256 affiliateAmount,
499     uint256 affiliateId,
500     address affiliateToken
501   );
502   event Cancel(
503     uint256 indexed nonce,
504     address indexed signerWallet
505   );
506   event CancelUpTo(
507     uint256 indexed nonce,
508     address indexed signerWallet
509   );
510   event AuthorizeSender(
511     address indexed authorizerAddress,
512     address indexed authorizedSender
513   );
514   event AuthorizeSigner(
515     address indexed authorizerAddress,
516     address indexed authorizedSigner
517   );
518   event RevokeSender(
519     address indexed authorizerAddress,
520     address indexed revokedSender
521   );
522   event RevokeSigner(
523     address indexed authorizerAddress,
524     address indexed revokedSigner
525   );
526   /**
527     * @notice Atomic Token Swap
528     * @param order Types.Order
529     */
530   function swap(
531     Types.Order calldata order
532   ) external;
533   /**
534     * @notice Cancel one or more open orders by nonce
535     * @param nonces uint256[]
536     */
537   function cancel(
538     uint256[] calldata nonces
539   ) external;
540   /**
541     * @notice Cancels all orders below a nonce value
542     * @dev These orders can be made active by reducing the minimum nonce
543     * @param minimumNonce uint256
544     */
545   function cancelUpTo(
546     uint256 minimumNonce
547   ) external;
548   /**
549     * @notice Authorize a delegated sender
550     * @param authorizedSender address
551     */
552   function authorizeSender(
553     address authorizedSender
554   ) external;
555   /**
556     * @notice Authorize a delegated signer
557     * @param authorizedSigner address
558     */
559   function authorizeSigner(
560     address authorizedSigner
561   ) external;
562   /**
563     * @notice Revoke an authorization
564     * @param authorizedSender address
565     */
566   function revokeSender(
567     address authorizedSender
568   ) external;
569   /**
570     * @notice Revoke an authorization
571     * @param authorizedSigner address
572     */
573   function revokeSigner(
574     address authorizedSigner
575   ) external;
576   function senderAuthorizations(address, address) external view returns (bool);
577   function signerAuthorizations(address, address) external view returns (bool);
578   function signerNonceStatus(address, uint256) external view returns (byte);
579   function signerMinimumNonce(address) external view returns (uint256);
580   function registry() external view returns (TransferHandlerRegistry);
581 }
582 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
583 /**
584  * @dev Wrappers over Solidity's arithmetic operations with added overflow
585  * checks.
586  *
587  * Arithmetic operations in Solidity wrap on overflow. This can easily result
588  * in bugs, because programmers usually assume that an overflow raises an
589  * error, which is the standard behavior in high level programming languages.
590  * `SafeMath` restores this intuition by reverting the transaction when an
591  * operation overflows.
592  *
593  * Using this library instead of the unchecked operations eliminates an entire
594  * class of bugs, so it's recommended to use it always.
595  */
596 library SafeMath {
597     /**
598      * @dev Returns the addition of two unsigned integers, reverting on
599      * overflow.
600      *
601      * Counterpart to Solidity's `+` operator.
602      *
603      * Requirements:
604      * - Addition cannot overflow.
605      */
606     function add(uint256 a, uint256 b) internal pure returns (uint256) {
607         uint256 c = a + b;
608         require(c >= a, "SafeMath: addition overflow");
609         return c;
610     }
611     /**
612      * @dev Returns the subtraction of two unsigned integers, reverting on
613      * overflow (when the result is negative).
614      *
615      * Counterpart to Solidity's `-` operator.
616      *
617      * Requirements:
618      * - Subtraction cannot overflow.
619      */
620     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
621         return sub(a, b, "SafeMath: subtraction overflow");
622     }
623     /**
624      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
625      * overflow (when the result is negative).
626      *
627      * Counterpart to Solidity's `-` operator.
628      *
629      * Requirements:
630      * - Subtraction cannot overflow.
631      *
632      * _Available since v2.4.0._
633      */
634     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
635         require(b <= a, errorMessage);
636         uint256 c = a - b;
637         return c;
638     }
639     /**
640      * @dev Returns the multiplication of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `*` operator.
644      *
645      * Requirements:
646      * - Multiplication cannot overflow.
647      */
648     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
649         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
650         // benefit is lost if 'b' is also tested.
651         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
652         if (a == 0) {
653             return 0;
654         }
655         uint256 c = a * b;
656         require(c / a == b, "SafeMath: multiplication overflow");
657         return c;
658     }
659     /**
660      * @dev Returns the integer division of two unsigned integers. Reverts on
661      * division by zero. The result is rounded towards zero.
662      *
663      * Counterpart to Solidity's `/` operator. Note: this function uses a
664      * `revert` opcode (which leaves remaining gas untouched) while Solidity
665      * uses an invalid opcode to revert (consuming all remaining gas).
666      *
667      * Requirements:
668      * - The divisor cannot be zero.
669      */
670     function div(uint256 a, uint256 b) internal pure returns (uint256) {
671         return div(a, b, "SafeMath: division by zero");
672     }
673     /**
674      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
675      * division by zero. The result is rounded towards zero.
676      *
677      * Counterpart to Solidity's `/` operator. Note: this function uses a
678      * `revert` opcode (which leaves remaining gas untouched) while Solidity
679      * uses an invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      * - The divisor cannot be zero.
683      *
684      * _Available since v2.4.0._
685      */
686     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
687         // Solidity only automatically asserts when dividing by 0
688         require(b > 0, errorMessage);
689         uint256 c = a / b;
690         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
691         return c;
692     }
693     /**
694      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
695      * Reverts when dividing by zero.
696      *
697      * Counterpart to Solidity's `%` operator. This function uses a `revert`
698      * opcode (which leaves remaining gas untouched) while Solidity uses an
699      * invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      * - The divisor cannot be zero.
703      */
704     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
705         return mod(a, b, "SafeMath: modulo by zero");
706     }
707     /**
708      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
709      * Reverts with custom message when dividing by zero.
710      *
711      * Counterpart to Solidity's `%` operator. This function uses a `revert`
712      * opcode (which leaves remaining gas untouched) while Solidity uses an
713      * invalid opcode to revert (consuming all remaining gas).
714      *
715      * Requirements:
716      * - The divisor cannot be zero.
717      *
718      * _Available since v2.4.0._
719      */
720     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
721         require(b != 0, errorMessage);
722         return a % b;
723     }
724 }
725 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
726 /**
727  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
728  * the optional functions; to access them see {ERC20Detailed}.
729  */
730 interface IERC20 {
731     /**
732      * @dev Returns the amount of tokens in existence.
733      */
734     function totalSupply() external view returns (uint256);
735     /**
736      * @dev Returns the amount of tokens owned by `account`.
737      */
738     function balanceOf(address account) external view returns (uint256);
739     /**
740      * @dev Moves `amount` tokens from the caller's account to `recipient`.
741      *
742      * Returns a boolean value indicating whether the operation succeeded.
743      *
744      * Emits a {Transfer} event.
745      */
746     function transfer(address recipient, uint256 amount) external returns (bool);
747     /**
748      * @dev Returns the remaining number of tokens that `spender` will be
749      * allowed to spend on behalf of `owner` through {transferFrom}. This is
750      * zero by default.
751      *
752      * This value changes when {approve} or {transferFrom} are called.
753      */
754     function allowance(address owner, address spender) external view returns (uint256);
755     /**
756      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
757      *
758      * Returns a boolean value indicating whether the operation succeeded.
759      *
760      * IMPORTANT: Beware that changing an allowance with this method brings the risk
761      * that someone may use both the old and the new allowance by unfortunate
762      * transaction ordering. One possible solution to mitigate this race
763      * condition is to first reduce the spender's allowance to 0 and set the
764      * desired value afterwards:
765      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
766      *
767      * Emits an {Approval} event.
768      */
769     function approve(address spender, uint256 amount) external returns (bool);
770     /**
771      * @dev Moves `amount` tokens from `sender` to `recipient` using the
772      * allowance mechanism. `amount` is then deducted from the caller's
773      * allowance.
774      *
775      * Returns a boolean value indicating whether the operation succeeded.
776      *
777      * Emits a {Transfer} event.
778      */
779     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
780     /**
781      * @dev Emitted when `value` tokens are moved from one account (`from`) to
782      * another (`to`).
783      *
784      * Note that `value` may be zero.
785      */
786     event Transfer(address indexed from, address indexed to, uint256 value);
787     /**
788      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
789      * a call to {approve}. `value` is the new allowance.
790      */
791     event Approval(address indexed owner, address indexed spender, uint256 value);
792 }
793 // File: contracts/Delegate.sol
794 /*
795   Copyright 2020 Swap Holdings Ltd.
796   Licensed under the Apache License, Version 2.0 (the "License");
797   you may not use this file except in compliance with the License.
798   You may obtain a copy of the License at
799     http://www.apache.org/licenses/LICENSE-2.0
800   Unless required by applicable law or agreed to in writing, software
801   distributed under the License is distributed on an "AS IS" BASIS,
802   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
803   See the License for the specific language governing permissions and
804   limitations under the License.
805 */
806 /**
807   * @title Delegate: Deployable Trading Rules for the AirSwap Network
808   * @notice Supports fungible tokens (ERC-20)
809   * @dev inherits IDelegate, Ownable uses SafeMath library
810   */
811 contract Delegate is IDelegate, Ownable {
812   using SafeMath for uint256;
813   // The Swap contract to be used to settle trades
814   ISwap public swapContract;
815   // The Indexer to stake intent to trade on
816   IIndexer public indexer;
817   // Maximum integer for token transfer approval
818   uint256 constant internal MAX_INT =  2**256 - 1;
819   // Address holding tokens that will be trading through this delegate
820   address public tradeWallet;
821   // Mapping of senderToken to signerToken for rule lookup
822   mapping (address => mapping (address => Rule)) public rules;
823   // ERC-20 (fungible token) interface identifier (ERC-165)
824   bytes4 constant internal ERC20_INTERFACE_ID = 0x36372b07;
825   // The protocol identifier for setting intents on an Index
826   bytes2 public protocol;
827   /**
828     * @notice Contract Constructor
829     * @dev owner defaults to msg.sender if delegateContractOwner is provided as address(0)
830     * @param delegateSwap address Swap contract the delegate will deploy with
831     * @param delegateIndexer address Indexer contract the delegate will deploy with
832     * @param delegateContractOwner address Owner of the delegate
833     * @param delegateTradeWallet address Wallet the delegate will trade from
834     * @param delegateProtocol bytes2 The protocol identifier for Delegate contracts
835     */
836   constructor(
837     ISwap delegateSwap,
838     IIndexer delegateIndexer,
839     address delegateContractOwner,
840     address delegateTradeWallet,
841     bytes2 delegateProtocol
842   ) public {
843     swapContract = delegateSwap;
844     indexer = delegateIndexer;
845     protocol = delegateProtocol;
846     // If no delegate owner is provided, the deploying address is the owner.
847     if (delegateContractOwner != address(0)) {
848       transferOwnership(delegateContractOwner);
849     }
850     // If no trade wallet is provided, the owner's wallet is the trade wallet.
851     if (delegateTradeWallet != address(0)) {
852       tradeWallet = delegateTradeWallet;
853     } else {
854       tradeWallet = owner();
855     }
856     // Ensure that the indexer can pull funds from delegate account.
857     require(
858       IERC20(indexer.stakingToken())
859       .approve(address(indexer), MAX_INT), "STAKING_APPROVAL_FAILED"
860     );
861   }
862   /**
863     * @notice Set a Trading Rule
864     * @dev only callable by the owner of the contract
865     * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
866     * @param senderToken address Address of an ERC-20 token the delegate would send
867     * @param signerToken address Address of an ERC-20 token the consumer would send
868     * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
869     * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
870     * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
871     */
872   function setRule(
873     address senderToken,
874     address signerToken,
875     uint256 maxSenderAmount,
876     uint256 priceCoef,
877     uint256 priceExp
878   ) external onlyOwner {
879     _setRule(
880       senderToken,
881       signerToken,
882       maxSenderAmount,
883       priceCoef,
884       priceExp
885     );
886   }
887   /**
888     * @notice Unset a Trading Rule
889     * @dev only callable by the owner of the contract, removes from a mapping
890     * @param senderToken address Address of an ERC-20 token the delegate would send
891     * @param signerToken address Address of an ERC-20 token the consumer would send
892     */
893   function unsetRule(
894     address senderToken,
895     address signerToken
896   ) external onlyOwner {
897     _unsetRule(
898       senderToken,
899       signerToken
900     );
901   }
902   /**
903     * @notice sets a rule on the delegate and an intent on the indexer
904     * @dev only callable by owner
905     * @dev delegate needs to be given allowance from msg.sender for the newStakeAmount
906     * @dev swap needs to be given permission to move funds from the delegate
907     * @param senderToken address Token the delgeate will send
908     * @param signerToken address Token the delegate will receive
909     * @param rule Rule Rule to set on a delegate
910     * @param newStakeAmount uint256 Amount to stake for an intent
911     */
912   function setRuleAndIntent(
913     address senderToken,
914     address signerToken,
915     Rule calldata rule,
916     uint256 newStakeAmount
917   ) external onlyOwner {
918     _setRule(
919       senderToken,
920       signerToken,
921       rule.maxSenderAmount,
922       rule.priceCoef,
923       rule.priceExp
924     );
925     // get currentAmount staked or 0 if never staked
926     uint256 oldStakeAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
927     if (oldStakeAmount == newStakeAmount && oldStakeAmount > 0) {
928       return; // forgo trying to reset intent with non-zero same stake amount
929     } else if (oldStakeAmount < newStakeAmount) {
930       // transfer only the difference from the sender to the Delegate.
931       require(
932         IERC20(indexer.stakingToken())
933         .transferFrom(msg.sender, address(this), newStakeAmount - oldStakeAmount), "STAKING_TRANSFER_FAILED"
934       );
935     }
936     indexer.setIntent(
937       signerToken,
938       senderToken,
939       protocol,
940       newStakeAmount,
941       bytes32(uint256(address(this)) << 96) //NOTE: this will pad 0's to the right
942     );
943     if (oldStakeAmount > newStakeAmount) {
944       // return excess stake back
945       require(
946         IERC20(indexer.stakingToken())
947         .transfer(msg.sender, oldStakeAmount - newStakeAmount), "STAKING_RETURN_FAILED"
948       );
949     }
950   }
951   /**
952     * @notice unsets a rule on the delegate and removes an intent on the indexer
953     * @dev only callable by owner
954     * @param senderToken address Maker token in the token pair for rules and intents
955     * @param signerToken address Taker token  in the token pair for rules and intents
956     */
957   function unsetRuleAndIntent(
958     address senderToken,
959     address signerToken
960   ) external onlyOwner {
961     _unsetRule(senderToken, signerToken);
962     // Query the indexer for the amount staked.
963     uint256 stakedAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
964     indexer.unsetIntent(signerToken, senderToken, protocol);
965     // Upon unstaking, the Delegate will be given the staking amount.
966     // This is returned to the msg.sender.
967     if (stakedAmount > 0) {
968       require(
969         IERC20(indexer.stakingToken())
970           .transfer(msg.sender, stakedAmount),"STAKING_RETURN_FAILED"
971       );
972     }
973   }
974   /**
975     * @notice Provide an Order
976     * @dev Rules get reset with new maxSenderAmount
977     * @param order Types.Order Order a user wants to submit to Swap.
978     */
979   function provideOrder(
980     Types.Order calldata order
981   ) external {
982     Rule memory rule = rules[order.sender.token][order.signer.token];
983     require(order.signature.v != 0,
984       "SIGNATURE_MUST_BE_SENT");
985     // Ensure the order is for the trade wallet.
986     require(order.sender.wallet == tradeWallet,
987       "SENDER_WALLET_INVALID");
988     // Ensure the tokens are valid ERC20 tokens.
989     require(order.signer.kind == ERC20_INTERFACE_ID,
990       "SIGNER_KIND_MUST_BE_ERC20");
991     require(order.sender.kind == ERC20_INTERFACE_ID,
992       "SENDER_KIND_MUST_BE_ERC20");
993     // Ensure that a rule exists.
994     require(rule.maxSenderAmount != 0,
995       "TOKEN_PAIR_INACTIVE");
996     // Ensure the order does not exceed the maximum amount.
997     require(order.sender.amount <= rule.maxSenderAmount,
998       "AMOUNT_EXCEEDS_MAX");
999     // Ensure the order is priced according to the rule.
1000     require(order.sender.amount <= _calculateSenderAmount(order.signer.amount, rule.priceCoef, rule.priceExp),
1001       "PRICE_INVALID");
1002     // Overwrite the rule with a decremented maxSenderAmount.
1003     rules[order.sender.token][order.signer.token] = Rule({
1004       maxSenderAmount: (rule.maxSenderAmount).sub(order.sender.amount),
1005       priceCoef: rule.priceCoef,
1006       priceExp: rule.priceExp
1007     });
1008     // Perform the swap.
1009     swapContract.swap(order);
1010     emit ProvideOrder(
1011       owner(),
1012       tradeWallet,
1013       order.sender.token,
1014       order.signer.token,
1015       order.sender.amount,
1016       rule.priceCoef,
1017       rule.priceExp
1018     );
1019   }
1020   /**
1021     * @notice Set a new trade wallet
1022     * @param newTradeWallet address Address of the new trade wallet
1023     */
1024   function setTradeWallet(address newTradeWallet) external onlyOwner {
1025     require(newTradeWallet != address(0), "TRADE_WALLET_REQUIRED");
1026     tradeWallet = newTradeWallet;
1027   }
1028   /**
1029     * @notice Get a Signer-Side Quote from the Delegate
1030     * @param senderAmount uint256 Amount of ERC-20 token the delegate would send
1031     * @param senderToken address Address of an ERC-20 token the delegate would send
1032     * @param signerToken address Address of an ERC-20 token the consumer would send
1033     * @return uint256 signerAmount Amount of ERC-20 token the consumer would send
1034     */
1035   function getSignerSideQuote(
1036     uint256 senderAmount,
1037     address senderToken,
1038     address signerToken
1039   ) external view returns (
1040     uint256 signerAmount
1041   ) {
1042     Rule memory rule = rules[senderToken][signerToken];
1043     // Ensure that a rule exists.
1044     if(rule.maxSenderAmount > 0) {
1045       // Ensure the senderAmount does not exceed maximum for the rule.
1046       if(senderAmount <= rule.maxSenderAmount) {
1047         signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
1048         // Return the quote.
1049         return signerAmount;
1050       }
1051     }
1052     return 0;
1053   }
1054   /**
1055     * @notice Get a Sender-Side Quote from the Delegate
1056     * @param signerAmount uint256 Amount of ERC-20 token the consumer would send
1057     * @param signerToken address Address of an ERC-20 token the consumer would send
1058     * @param senderToken address Address of an ERC-20 token the delegate would send
1059     * @return uint256 senderAmount Amount of ERC-20 token the delegate would send
1060     */
1061   function getSenderSideQuote(
1062     uint256 signerAmount,
1063     address signerToken,
1064     address senderToken
1065   ) external view returns (
1066     uint256 senderAmount
1067   ) {
1068     Rule memory rule = rules[senderToken][signerToken];
1069     // Ensure that a rule exists.
1070     if(rule.maxSenderAmount > 0) {
1071       // Calculate the senderAmount.
1072       senderAmount = _calculateSenderAmount(signerAmount, rule.priceCoef, rule.priceExp);
1073       // Ensure the senderAmount does not exceed the maximum trade amount.
1074       if(senderAmount <= rule.maxSenderAmount) {
1075         return senderAmount;
1076       }
1077     }
1078     return 0;
1079   }
1080   /**
1081     * @notice Get a Maximum Quote from the Delegate
1082     * @param senderToken address Address of an ERC-20 token the delegate would send
1083     * @param signerToken address Address of an ERC-20 token the consumer would send
1084     * @return uint256 senderAmount Amount the delegate would send
1085     * @return uint256 signerAmount Amount the consumer would send
1086     */
1087   function getMaxQuote(
1088     address senderToken,
1089     address signerToken
1090   ) external view returns (
1091     uint256 senderAmount,
1092     uint256 signerAmount
1093   ) {
1094     Rule memory rule = rules[senderToken][signerToken];
1095     senderAmount = rule.maxSenderAmount;
1096     // Ensure that a rule exists.
1097     if (senderAmount > 0) {
1098       // calculate the signerAmount
1099       signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
1100       // Return the maxSenderAmount and calculated signerAmount.
1101       return (
1102         senderAmount,
1103         signerAmount
1104       );
1105     }
1106     return (0, 0);
1107   }
1108   /**
1109     * @notice Set a Trading Rule
1110     * @dev only callable by the owner of the contract
1111     * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
1112     * @param senderToken address Address of an ERC-20 token the delegate would send
1113     * @param signerToken address Address of an ERC-20 token the consumer would send
1114     * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
1115     * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
1116     * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
1117     */
1118   function _setRule(
1119     address senderToken,
1120     address signerToken,
1121     uint256 maxSenderAmount,
1122     uint256 priceCoef,
1123     uint256 priceExp
1124   ) internal {
1125     require(priceCoef > 0, "PRICE_COEF_INVALID");
1126     rules[senderToken][signerToken] = Rule({
1127       maxSenderAmount: maxSenderAmount,
1128       priceCoef: priceCoef,
1129       priceExp: priceExp
1130     });
1131     emit SetRule(
1132       owner(),
1133       senderToken,
1134       signerToken,
1135       maxSenderAmount,
1136       priceCoef,
1137       priceExp
1138     );
1139   }
1140   /**
1141     * @notice Unset a Trading Rule
1142     * @param senderToken address Address of an ERC-20 token the delegate would send
1143     * @param signerToken address Address of an ERC-20 token the consumer would send
1144     */
1145   function _unsetRule(
1146     address senderToken,
1147     address signerToken
1148   ) internal {
1149     // using non-zero rule.priceCoef for rule existence check
1150     if (rules[senderToken][signerToken].priceCoef > 0) {
1151       // Delete the rule.
1152       delete rules[senderToken][signerToken];
1153       emit UnsetRule(
1154         owner(),
1155         senderToken,
1156         signerToken
1157     );
1158     }
1159   }
1160   /**
1161     * @notice Calculate the signer amount for a given sender amount and price
1162     * @param senderAmount uint256 The amount the delegate would send in the swap
1163     * @param priceCoef uint256 Coefficient of the token price defined in the rule
1164     * @param priceExp uint256 Exponent of the token price defined in the rule
1165     */
1166   function _calculateSignerAmount(
1167     uint256 senderAmount,
1168     uint256 priceCoef,
1169     uint256 priceExp
1170   ) internal pure returns (
1171     uint256 signerAmount
1172   ) {
1173     // Calculate the signer amount using the price formula
1174     uint256 multiplier = senderAmount.mul(priceCoef);
1175     signerAmount = multiplier.div(10 ** priceExp);
1176     // If the div rounded down, round up
1177     if (multiplier.mod(10 ** priceExp) > 0) {
1178       signerAmount++;
1179     }
1180   }
1181   /**
1182     * @notice Calculate the sender amount for a given signer amount and price
1183     * @param signerAmount uint256 The amount the signer would send in the swap
1184     * @param priceCoef uint256 Coefficient of the token price defined in the rule
1185     * @param priceExp uint256 Exponent of the token price defined in the rule
1186     */
1187   function _calculateSenderAmount(
1188     uint256 signerAmount,
1189     uint256 priceCoef,
1190     uint256 priceExp
1191   ) internal pure returns (
1192     uint256 senderAmount
1193   ) {
1194     // Calculate the sender anount using the price formula
1195     senderAmount = signerAmount
1196       .mul(10 ** priceExp)
1197       .div(priceCoef);
1198   }
1199 }
1200 // File: contracts/interfaces/IDelegateFactory.sol
1201 /*
1202   Copyright 2020 Swap Holdings Ltd.
1203   Licensed under the Apache License, Version 2.0 (the "License");
1204   you may not use this file except in compliance with the License.
1205   You may obtain a copy of the License at
1206     http://www.apache.org/licenses/LICENSE-2.0
1207   Unless required by applicable law or agreed to in writing, software
1208   distributed under the License is distributed on an "AS IS" BASIS,
1209   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1210   See the License for the specific language governing permissions and
1211   limitations under the License.
1212 */
1213 interface IDelegateFactory {
1214   event CreateDelegate(
1215     address indexed delegateContract,
1216     address swapContract,
1217     address indexerContract,
1218     address indexed delegateContractOwner,
1219     address delegateTradeWallet
1220   );
1221   /**
1222     * @notice Deploy a trusted delegate contract
1223     * @param delegateTradeWallet the wallet the delegate will trade from
1224     * @return delegateContractAddress address of the delegate contract created
1225     */
1226   function createDelegate(
1227     address delegateTradeWallet
1228   ) external returns (address delegateContractAddress);
1229 }
1230 // File: @airswap/indexer/contracts/interfaces/ILocatorWhitelist.sol
1231 /*
1232   Copyright 2020 Swap Holdings Ltd.
1233   Licensed under the Apache License, Version 2.0 (the "License");
1234   you may not use this file except in compliance with the License.
1235   You may obtain a copy of the License at
1236     http://www.apache.org/licenses/LICENSE-2.0
1237   Unless required by applicable law or agreed to in writing, software
1238   distributed under the License is distributed on an "AS IS" BASIS,
1239   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1240   See the License for the specific language governing permissions and
1241   limitations under the License.
1242 */
1243 interface ILocatorWhitelist {
1244   function has(
1245     bytes32 locator
1246   ) external view returns (bool);
1247 }
1248 // File: contracts/DelegateFactory.sol
1249 /*
1250   Copyright 2020 Swap Holdings Ltd.
1251   Licensed under the Apache License, Version 2.0 (the "License");
1252   you may not use this file except in compliance with the License.
1253   You may obtain a copy of the License at
1254     http://www.apache.org/licenses/LICENSE-2.0
1255   Unless required by applicable law or agreed to in writing, software
1256   distributed under the License is distributed on an "AS IS" BASIS,
1257   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1258   See the License for the specific language governing permissions and
1259   limitations under the License.
1260 */
1261 contract DelegateFactory is IDelegateFactory, ILocatorWhitelist {
1262   // Mapping specifying whether an address was deployed by this factory
1263   mapping(address => bool) internal _deployedAddresses;
1264   // The swap and indexer contracts to use in the deployment of Delegates
1265   ISwap public swapContract;
1266   IIndexer public indexerContract;
1267   bytes2 public protocol;
1268   /**
1269     * @notice Create a new Delegate contract
1270     * @dev swapContract is unable to be changed after the factory sets it
1271     * @param factorySwapContract address Swap contract the delegate will deploy with
1272     * @param factoryIndexerContract address Indexer contract the delegate will deploy with
1273     * @param factoryProtocol bytes2 Protocol type of the delegates the factory deploys
1274     */
1275   constructor(
1276     ISwap factorySwapContract,
1277     IIndexer factoryIndexerContract,
1278     bytes2 factoryProtocol
1279   ) public {
1280     swapContract = factorySwapContract;
1281     indexerContract = factoryIndexerContract;
1282     protocol = factoryProtocol;
1283   }
1284   /**
1285     * @param delegateTradeWallet address Wallet the delegate will trade from
1286     * @return address delegateContractAddress Address of the delegate contract created
1287     */
1288   function createDelegate(
1289     address delegateTradeWallet
1290   ) external returns (address delegateContractAddress) {
1291     delegateContractAddress = address(
1292       new Delegate(swapContract, indexerContract, msg.sender, delegateTradeWallet, protocol)
1293     );
1294     _deployedAddresses[delegateContractAddress] = true;
1295     emit CreateDelegate(
1296       delegateContractAddress,
1297       address(swapContract),
1298       address(indexerContract),
1299       msg.sender,
1300       delegateTradeWallet
1301     );
1302     return delegateContractAddress;
1303   }
1304   /**
1305     * @notice To check whether a locator was deployed
1306     * @dev Implements ILocatorWhitelist.has
1307     * @param locator bytes32 Locator of the delegate in question
1308     * @return bool True if the delegate was deployed by this contract
1309     */
1310   function has(bytes32 locator) external view returns (bool) {
1311     return _deployedAddresses[address(bytes20(locator))];
1312   }
1313 }

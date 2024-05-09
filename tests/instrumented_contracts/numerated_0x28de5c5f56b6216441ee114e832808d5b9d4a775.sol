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
793 // File: @airswap/delegate/contracts/Delegate.sol
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
1200 // File: @airswap/delegate/contracts/interfaces/IDelegateFactory.sol
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
1248 // File: @airswap/delegate/contracts/DelegateFactory.sol
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
1314 // File: @airswap/indexer/contracts/Index.sol
1315 /*
1316   Copyright 2020 Swap Holdings Ltd.
1317   Licensed under the Apache License, Version 2.0 (the "License");
1318   you may not use this file except in compliance with the License.
1319   You may obtain a copy of the License at
1320     http://www.apache.org/licenses/LICENSE-2.0
1321   Unless required by applicable law or agreed to in writing, software
1322   distributed under the License is distributed on an "AS IS" BASIS,
1323   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1324   See the License for the specific language governing permissions and
1325   limitations under the License.
1326 */
1327 /**
1328   * @title Index: A List of Locators
1329   * @notice The Locators are sorted in reverse order based on the score
1330   * meaning that the first element in the list has the largest score
1331   * and final element has the smallest
1332   * @dev A mapping is used to mimic a circular linked list structure
1333   * where every mapping Entry contains a pointer to the next
1334   * and the previous
1335   */
1336 contract Index is Ownable {
1337   // The number of entries in the index
1338   uint256 public length;
1339   // Identifier to use for the head of the list
1340   address constant internal HEAD = address(uint160(2**160-1));
1341   // Mapping of an identifier to its entry
1342   mapping(address => Entry) public entries;
1343   /**
1344     * @notice Index Entry
1345     * @param score uint256
1346     * @param locator bytes32
1347     * @param prev address Previous address in the linked list
1348     * @param next address Next address in the linked list
1349     */
1350   struct Entry {
1351     bytes32 locator;
1352     uint256 score;
1353     address prev;
1354     address next;
1355   }
1356   /**
1357     * @notice Contract Events
1358     */
1359   event SetLocator(
1360     address indexed identifier,
1361     uint256 score,
1362     bytes32 indexed locator
1363   );
1364   event UnsetLocator(
1365     address indexed identifier
1366   );
1367   /**
1368     * @notice Contract Constructor
1369     */
1370   constructor() public {
1371     // Create initial entry.
1372     entries[HEAD] = Entry(bytes32(0), 0, HEAD, HEAD);
1373   }
1374   /**
1375     * @notice Set a Locator
1376     * @param identifier address On-chain address identifying the owner of a locator
1377     * @param score uint256 Score for the locator being set
1378     * @param locator bytes32 Locator
1379     */
1380   function setLocator(
1381     address identifier,
1382     uint256 score,
1383     bytes32 locator
1384   ) external onlyOwner {
1385     // Ensure the entry does not already exist.
1386     require(!_hasEntry(identifier), "ENTRY_ALREADY_EXISTS");
1387     _setLocator(identifier, score, locator);
1388     // Increment the index length.
1389     length = length + 1;
1390     emit SetLocator(identifier, score, locator);
1391   }
1392   /**
1393     * @notice Unset a Locator
1394     * @param identifier address On-chain address identifying the owner of a locator
1395     */
1396   function unsetLocator(
1397     address identifier
1398   ) external onlyOwner {
1399     _unsetLocator(identifier);
1400     // Decrement the index length.
1401     length = length - 1;
1402     emit UnsetLocator(identifier);
1403   }
1404   /**
1405     * @notice Update a Locator
1406     * @dev score and/or locator do not need to be different from old values
1407     * @param identifier address On-chain address identifying the owner of a locator
1408     * @param score uint256 Score for the locator being set
1409     * @param locator bytes32 Locator
1410     */
1411   function updateLocator(
1412     address identifier,
1413     uint256 score,
1414     bytes32 locator
1415   ) external onlyOwner {
1416     // Don't need to update length as it is not used in set/unset logic
1417     _unsetLocator(identifier);
1418     _setLocator(identifier, score, locator);
1419     emit SetLocator(identifier, score, locator);
1420   }
1421   /**
1422     * @notice Get a Score
1423     * @param identifier address On-chain address identifying the owner of a locator
1424     * @return uint256 Score corresponding to the identifier
1425     */
1426   function getScore(
1427     address identifier
1428   ) external view returns (uint256) {
1429     return entries[identifier].score;
1430   }
1431     /**
1432     * @notice Get a Locator
1433     * @param identifier address On-chain address identifying the owner of a locator
1434     * @return bytes32 Locator information
1435     */
1436   function getLocator(
1437     address identifier
1438   ) external view returns (bytes32) {
1439     return entries[identifier].locator;
1440   }
1441   /**
1442     * @notice Get a Range of Locators
1443     * @dev start value of 0x0 starts at the head
1444     * @param cursor address Cursor to start with
1445     * @param limit uint256 Maximum number of locators to return
1446     * @return bytes32[] List of locators
1447     * @return uint256[] List of scores corresponding to locators
1448     * @return address The next cursor to provide for pagination
1449     */
1450   function getLocators(
1451     address cursor,
1452     uint256 limit
1453   ) external view returns (
1454     bytes32[] memory locators,
1455     uint256[] memory scores,
1456     address nextCursor
1457   ) {
1458     address identifier;
1459     // If a valid cursor is provided, start there.
1460     if (cursor != address(0) && cursor != HEAD) {
1461       // Check that the provided cursor exists.
1462       if (!_hasEntry(cursor)) {
1463         return (new bytes32[](0), new uint256[](0), address(0));
1464       }
1465       // Set the starting identifier to the provided cursor.
1466       identifier = cursor;
1467     } else {
1468       identifier = entries[HEAD].next;
1469     }
1470     // Although it's not known how many entries are between `cursor` and the end
1471     // We know that it is no more than `length`
1472     uint256 size = (length < limit) ? length : limit;
1473     locators = new bytes32[](size);
1474     scores = new uint256[](size);
1475     // Iterate over the list until the end or size.
1476     uint256 i;
1477     while (i < size && identifier != HEAD) {
1478       locators[i] = entries[identifier].locator;
1479       scores[i] = entries[identifier].score;
1480       i = i + 1;
1481       identifier = entries[identifier].next;
1482     }
1483     return (locators, scores, identifier);
1484   }
1485   /**
1486     * @notice Internal function to set a Locator
1487     * @param identifier address On-chain address identifying the owner of a locator
1488     * @param score uint256 Score for the locator being set
1489     * @param locator bytes32 Locator
1490     */
1491   function _setLocator(
1492     address identifier,
1493     uint256 score,
1494     bytes32 locator
1495   ) internal {
1496     // Disallow locator set to 0x0 to ensure list integrity.
1497     require(locator != bytes32(0), "LOCATOR_MUST_BE_SENT");
1498     // Find the first entry with a lower score.
1499     address nextEntry = _getEntryLowerThan(score);
1500     // Link the new entry between previous and next.
1501     address prevEntry = entries[nextEntry].prev;
1502     entries[prevEntry].next = identifier;
1503     entries[nextEntry].prev = identifier;
1504     entries[identifier] = Entry(locator, score, prevEntry, nextEntry);
1505   }
1506   /**
1507     * @notice Internal function to unset a Locator
1508     * @param identifier address On-chain address identifying the owner of a locator
1509     */
1510   function _unsetLocator(
1511     address identifier
1512   ) internal {
1513     // Ensure the entry exists.
1514     require(_hasEntry(identifier), "ENTRY_DOES_NOT_EXIST");
1515     // Link the previous and next entries together.
1516     address prevUser = entries[identifier].prev;
1517     address nextUser = entries[identifier].next;
1518     entries[prevUser].next = nextUser;
1519     entries[nextUser].prev = prevUser;
1520     // Delete entry from the index.
1521     delete entries[identifier];
1522   }
1523   /**
1524     * @notice Check if the Index has an Entry
1525     * @param identifier address On-chain address identifying the owner of a locator
1526     * @return bool True if the identifier corresponds to an Entry in the list
1527     */
1528   function _hasEntry(
1529     address identifier
1530   ) internal view returns (bool) {
1531     return entries[identifier].locator != bytes32(0);
1532   }
1533   /**
1534     * @notice Returns the largest scoring Entry Lower than a Score
1535     * @param score uint256 Score in question
1536     * @return address Identifier of the largest score lower than score
1537     */
1538   function _getEntryLowerThan(
1539     uint256 score
1540   ) internal view returns (address) {
1541     address identifier = entries[HEAD].next;
1542     // Head indicates last because the list is circular.
1543     if (score == 0) {
1544       return HEAD;
1545     }
1546     // Iterate until a lower score is found.
1547     while (score <= entries[identifier].score) {
1548       identifier = entries[identifier].next;
1549     }
1550     return identifier;
1551   }
1552 }
1553 // File: @airswap/indexer/contracts/Indexer.sol
1554 /*
1555   Copyright 2020 Swap Holdings Ltd.
1556   Licensed under the Apache License, Version 2.0 (the "License");
1557   you may not use this file except in compliance with the License.
1558   You may obtain a copy of the License at
1559     http://www.apache.org/licenses/LICENSE-2.0
1560   Unless required by applicable law or agreed to in writing, software
1561   distributed under the License is distributed on an "AS IS" BASIS,
1562   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1563   See the License for the specific language governing permissions and
1564   limitations under the License.
1565 */
1566 /**
1567   * @title Indexer: A Collection of Index contracts by Token Pair
1568   */
1569 contract Indexer is IIndexer, Ownable {
1570   // Token to be used for staking (ERC-20)
1571   IERC20 public stakingToken;
1572   // Mapping of signer token to sender token to protocol type to index
1573   mapping (address => mapping (address => mapping (bytes2 => Index))) public indexes;
1574   // The whitelist contract for checking whether a peer is whitelisted per peer type
1575   mapping (bytes2 => address) public locatorWhitelists;
1576   // Mapping of token address to boolean
1577   mapping (address => bool) public tokenBlacklist;
1578   /**
1579     * @notice Contract Constructor
1580     * @param indexerStakingToken address
1581     */
1582   constructor(
1583     address indexerStakingToken
1584   ) public {
1585     stakingToken = IERC20(indexerStakingToken);
1586   }
1587   /**
1588     * @notice Modifier to check an index exists
1589     */
1590   modifier indexExists(address signerToken, address senderToken, bytes2 protocol) {
1591     require(indexes[signerToken][senderToken][protocol] != Index(0),
1592       "INDEX_DOES_NOT_EXIST");
1593     _;
1594   }
1595   /**
1596     * @notice Set the address of an ILocatorWhitelist to use
1597     * @dev Allows removal of locatorWhitelist by passing 0x0
1598     * @param protocol bytes2 Protocol type for locators
1599     * @param newLocatorWhitelist address Locator whitelist
1600     */
1601   function setLocatorWhitelist(
1602     bytes2 protocol,
1603     address newLocatorWhitelist
1604   ) external onlyOwner {
1605     locatorWhitelists[protocol] = newLocatorWhitelist;
1606   }
1607   /**
1608     * @notice Create an Index (List of Locators for a Token Pair)
1609     * @dev Deploys a new Index contract and stores the address. If the Index already
1610     * @dev exists, returns its address, and does not emit a CreateIndex event
1611     * @param signerToken address Signer token for the Index
1612     * @param senderToken address Sender token for the Index
1613     * @param protocol bytes2 Protocol type for locators in Index
1614     */
1615   function createIndex(
1616     address signerToken,
1617     address senderToken,
1618     bytes2 protocol
1619   ) external returns (address) {
1620     // If the Index does not exist, create it.
1621     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1622       // Create a new Index contract for the token pair.
1623       indexes[signerToken][senderToken][protocol] = new Index();
1624       emit CreateIndex(signerToken, senderToken, protocol, address(indexes[signerToken][senderToken][protocol]));
1625     }
1626     // Return the address of the Index contract.
1627     return address(indexes[signerToken][senderToken][protocol]);
1628   }
1629   /**
1630     * @notice Add a Token to the Blacklist
1631     * @param token address Token to blacklist
1632     */
1633   function addTokenToBlacklist(
1634     address token
1635   ) external onlyOwner {
1636     if (!tokenBlacklist[token]) {
1637       tokenBlacklist[token] = true;
1638       emit AddTokenToBlacklist(token);
1639     }
1640   }
1641   /**
1642     * @notice Remove a Token from the Blacklist
1643     * @param token address Token to remove from the blacklist
1644     */
1645   function removeTokenFromBlacklist(
1646     address token
1647   ) external onlyOwner {
1648     if (tokenBlacklist[token]) {
1649       tokenBlacklist[token] = false;
1650       emit RemoveTokenFromBlacklist(token);
1651     }
1652   }
1653   /**
1654     * @notice Set an Intent to Trade
1655     * @dev Requires approval to transfer staking token for sender
1656     *
1657     * @param signerToken address Signer token of the Index being staked
1658     * @param senderToken address Sender token of the Index being staked
1659     * @param protocol bytes2 Protocol type for locator in Intent
1660     * @param stakingAmount uint256 Amount being staked
1661     * @param locator bytes32 Locator of the staker
1662     */
1663   function setIntent(
1664     address signerToken,
1665     address senderToken,
1666     bytes2 protocol,
1667     uint256 stakingAmount,
1668     bytes32 locator
1669   ) external indexExists(signerToken, senderToken, protocol) {
1670     // If whitelist set, ensure the locator is valid.
1671     if (locatorWhitelists[protocol] != address(0)) {
1672       require(ILocatorWhitelist(locatorWhitelists[protocol]).has(locator),
1673       "LOCATOR_NOT_WHITELISTED");
1674     }
1675     // Ensure neither of the tokens are blacklisted.
1676     require(!tokenBlacklist[signerToken] && !tokenBlacklist[senderToken],
1677       "PAIR_IS_BLACKLISTED");
1678     bool notPreviouslySet = (indexes[signerToken][senderToken][protocol].getLocator(msg.sender) == bytes32(0));
1679     if (notPreviouslySet) {
1680       // Only transfer for staking if stakingAmount is set.
1681       if (stakingAmount > 0) {
1682         // Transfer the stakingAmount for staking.
1683         require(stakingToken.transferFrom(msg.sender, address(this), stakingAmount),
1684           "STAKING_FAILED");
1685       }
1686       // Set the locator on the index.
1687       indexes[signerToken][senderToken][protocol].setLocator(msg.sender, stakingAmount, locator);
1688       emit Stake(msg.sender, signerToken, senderToken, protocol, stakingAmount);
1689     } else {
1690       uint256 oldStake = indexes[signerToken][senderToken][protocol].getScore(msg.sender);
1691       _updateIntent(msg.sender, signerToken, senderToken, protocol, stakingAmount, locator, oldStake);
1692     }
1693   }
1694   /**
1695     * @notice Unset an Intent to Trade
1696     * @dev Users are allowed to unstake from blacklisted indexes
1697     *
1698     * @param signerToken address Signer token of the Index being unstaked
1699     * @param senderToken address Sender token of the Index being staked
1700     * @param protocol bytes2 Protocol type for locators in Intent
1701     */
1702   function unsetIntent(
1703     address signerToken,
1704     address senderToken,
1705     bytes2 protocol
1706   ) external {
1707     _unsetIntent(msg.sender, signerToken, senderToken, protocol);
1708   }
1709   /**
1710     * @notice Get the locators of those trading a token pair
1711     * @dev Users are allowed to unstake from blacklisted indexes
1712     *
1713     * @param signerToken address Signer token of the trading pair
1714     * @param senderToken address Sender token of the trading pair
1715     * @param protocol bytes2 Protocol type for locators in Intent
1716     * @param cursor address Address to start from
1717     * @param limit uint256 Total number of locators to return
1718     * @return bytes32[] List of locators
1719     * @return uint256[] List of scores corresponding to locators
1720     * @return address The next cursor to provide for pagination
1721     */
1722   function getLocators(
1723     address signerToken,
1724     address senderToken,
1725     bytes2 protocol,
1726     address cursor,
1727     uint256 limit
1728   ) external view returns (
1729     bytes32[] memory locators,
1730     uint256[] memory scores,
1731     address nextCursor
1732   ) {
1733     // Ensure neither token is blacklisted.
1734     if (tokenBlacklist[signerToken] || tokenBlacklist[senderToken]) {
1735       return (new bytes32[](0), new uint256[](0), address(0));
1736     }
1737     // Ensure the index exists.
1738     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1739       return (new bytes32[](0), new uint256[](0), address(0));
1740     }
1741     return indexes[signerToken][senderToken][protocol].getLocators(cursor, limit);
1742   }
1743   /**
1744     * @notice Gets the Stake Amount for a User
1745     * @param user address User who staked
1746     * @param signerToken address Signer token the user staked on
1747     * @param senderToken address Sender token the user staked on
1748     * @param protocol bytes2 Protocol type for locators in Intent
1749     * @return uint256 Amount the user staked
1750     */
1751   function getStakedAmount(
1752     address user,
1753     address signerToken,
1754     address senderToken,
1755     bytes2 protocol
1756   ) public view returns (uint256 stakedAmount) {
1757     if (indexes[signerToken][senderToken][protocol] == Index(0)) {
1758       return 0;
1759     }
1760     // Return the score, equivalent to the stake amount.
1761     return indexes[signerToken][senderToken][protocol].getScore(user);
1762   }
1763   function _updateIntent(
1764     address user,
1765     address signerToken,
1766     address senderToken,
1767     bytes2 protocol,
1768     uint256 newAmount,
1769     bytes32 newLocator,
1770     uint256 oldAmount
1771   ) internal {
1772     // If the new stake is bigger, collect the difference.
1773     if (oldAmount < newAmount) {
1774       // Note: SafeMath not required due to the inequality check above
1775       require(stakingToken.transferFrom(user, address(this), newAmount - oldAmount),
1776         "STAKING_FAILED");
1777     }
1778     // If the old stake is bigger, return the excess.
1779     if (newAmount < oldAmount) {
1780       // Note: SafeMath not required due to the inequality check above
1781       require(stakingToken.transfer(user, oldAmount - newAmount));
1782     }
1783     // Update their intent.
1784     indexes[signerToken][senderToken][protocol].updateLocator(user, newAmount, newLocator);
1785     emit Stake(user, signerToken, senderToken, protocol, newAmount);
1786   }
1787   /**
1788     * @notice Unset intents and return staked tokens
1789     * @param user address Address of the user who staked
1790     * @param signerToken address Signer token of the trading pair
1791     * @param senderToken address Sender token of the trading pair
1792     * @param protocol bytes2 Protocol type for locators in Intent
1793     */
1794   function _unsetIntent(
1795     address user,
1796     address signerToken,
1797     address senderToken,
1798     bytes2 protocol
1799   ) internal indexExists(signerToken, senderToken, protocol) {
1800      // Get the score for the user.
1801     uint256 score = indexes[signerToken][senderToken][protocol].getScore(user);
1802     // Unset the locator on the index.
1803     indexes[signerToken][senderToken][protocol].unsetLocator(user);
1804     if (score > 0) {
1805       // Return the staked tokens. Reverts on failure.
1806       require(stakingToken.transfer(user, score));
1807     }
1808     emit Unstake(user, signerToken, senderToken, protocol, score);
1809   }
1810 }
1811 // File: @airswap/swap/contracts/Swap.sol
1812 /*
1813   Copyright 2020 Swap Holdings Ltd.
1814   Licensed under the Apache License, Version 2.0 (the "License");
1815   you may not use this file except in compliance with the License.
1816   You may obtain a copy of the License at
1817     http://www.apache.org/licenses/LICENSE-2.0
1818   Unless required by applicable law or agreed to in writing, software
1819   distributed under the License is distributed on an "AS IS" BASIS,
1820   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1821   See the License for the specific language governing permissions and
1822   limitations under the License.
1823 */
1824 /**
1825   * @title Swap: The Atomic Swap used on the AirSwap Network
1826   */
1827 contract Swap is ISwap {
1828   // Domain and version for use in signatures (EIP-712)
1829   bytes constant internal DOMAIN_NAME = "SWAP";
1830   bytes constant internal DOMAIN_VERSION = "2";
1831   // Unique domain identifier for use in signatures (EIP-712)
1832   bytes32 private _domainSeparator;
1833   // Possible nonce statuses
1834   byte constant internal AVAILABLE = 0x00;
1835   byte constant internal UNAVAILABLE = 0x01;
1836   // Mapping of sender address to a delegated sender address and bool
1837   mapping (address => mapping (address => bool)) public senderAuthorizations;
1838   // Mapping of signer address to a delegated signer and bool
1839   mapping (address => mapping (address => bool)) public signerAuthorizations;
1840   // Mapping of signers to nonces with value AVAILABLE (0x00) or UNAVAILABLE (0x01)
1841   mapping (address => mapping (uint256 => byte)) public signerNonceStatus;
1842   // Mapping of signer addresses to an optionally set minimum valid nonce
1843   mapping (address => uint256) public signerMinimumNonce;
1844   // A registry storing a transfer handler for different token kinds
1845   TransferHandlerRegistry public registry;
1846   /**
1847     * @notice Contract Constructor
1848     * @dev Sets domain for signature validation (EIP-712)
1849     * @param swapRegistry TransferHandlerRegistry
1850     */
1851   constructor(TransferHandlerRegistry swapRegistry) public {
1852     _domainSeparator = Types.hashDomain(
1853       DOMAIN_NAME,
1854       DOMAIN_VERSION,
1855       address(this)
1856     );
1857     registry = swapRegistry;
1858   }
1859   /**
1860     * @notice Atomic Token Swap
1861     * @param order Types.Order Order to settle
1862     */
1863   function swap(
1864     Types.Order calldata order
1865   ) external {
1866     // Ensure the order is not expired.
1867     require(order.expiry > block.timestamp,
1868       "ORDER_EXPIRED");
1869     // Ensure the nonce is AVAILABLE (0x00).
1870     require(signerNonceStatus[order.signer.wallet][order.nonce] == AVAILABLE,
1871       "ORDER_TAKEN_OR_CANCELLED");
1872     // Ensure the order nonce is above the minimum.
1873     require(order.nonce >= signerMinimumNonce[order.signer.wallet],
1874       "NONCE_TOO_LOW");
1875     // Mark the nonce UNAVAILABLE (0x01).
1876     signerNonceStatus[order.signer.wallet][order.nonce] = UNAVAILABLE;
1877     // Validate the sender side of the trade.
1878     address finalSenderWallet;
1879     if (order.sender.wallet == address(0)) {
1880       /**
1881         * Sender is not specified. The msg.sender of the transaction becomes
1882         * the sender of the order.
1883         */
1884       finalSenderWallet = msg.sender;
1885     } else {
1886       /**
1887         * Sender is specified. If the msg.sender is not the specified sender,
1888         * this determines whether the msg.sender is an authorized sender.
1889         */
1890       require(isSenderAuthorized(order.sender.wallet, msg.sender),
1891           "SENDER_UNAUTHORIZED");
1892       // The msg.sender is authorized.
1893       finalSenderWallet = order.sender.wallet;
1894     }
1895     // Validate the signer side of the trade.
1896     if (order.signature.v == 0) {
1897       /**
1898         * Signature is not provided. The signer may have authorized the
1899         * msg.sender to swap on its behalf, which does not require a signature.
1900         */
1901       require(isSignerAuthorized(order.signer.wallet, msg.sender),
1902         "SIGNER_UNAUTHORIZED");
1903     } else {
1904       /**
1905         * The signature is provided. Determine whether the signer is
1906         * authorized and if so validate the signature itself.
1907         */
1908       require(isSignerAuthorized(order.signer.wallet, order.signature.signatory),
1909         "SIGNER_UNAUTHORIZED");
1910       // Ensure the signature is valid.
1911       require(isValid(order, _domainSeparator),
1912         "SIGNATURE_INVALID");
1913     }
1914     // Transfer token from sender to signer.
1915     transferToken(
1916       finalSenderWallet,
1917       order.signer.wallet,
1918       order.sender.amount,
1919       order.sender.id,
1920       order.sender.token,
1921       order.sender.kind
1922     );
1923     // Transfer token from signer to sender.
1924     transferToken(
1925       order.signer.wallet,
1926       finalSenderWallet,
1927       order.signer.amount,
1928       order.signer.id,
1929       order.signer.token,
1930       order.signer.kind
1931     );
1932     // Transfer token from signer to affiliate if specified.
1933     if (order.affiliate.token != address(0)) {
1934       transferToken(
1935         order.signer.wallet,
1936         order.affiliate.wallet,
1937         order.affiliate.amount,
1938         order.affiliate.id,
1939         order.affiliate.token,
1940         order.affiliate.kind
1941       );
1942     }
1943     emit Swap(
1944       order.nonce,
1945       block.timestamp,
1946       order.signer.wallet,
1947       order.signer.amount,
1948       order.signer.id,
1949       order.signer.token,
1950       finalSenderWallet,
1951       order.sender.amount,
1952       order.sender.id,
1953       order.sender.token,
1954       order.affiliate.wallet,
1955       order.affiliate.amount,
1956       order.affiliate.id,
1957       order.affiliate.token
1958     );
1959   }
1960   /**
1961     * @notice Cancel one or more open orders by nonce
1962     * @dev Cancelled nonces are marked UNAVAILABLE (0x01)
1963     * @dev Emits a Cancel event
1964     * @dev Out of gas may occur in arrays of length > 400
1965     * @param nonces uint256[] List of nonces to cancel
1966     */
1967   function cancel(
1968     uint256[] calldata nonces
1969   ) external {
1970     for (uint256 i = 0; i < nonces.length; i++) {
1971       if (signerNonceStatus[msg.sender][nonces[i]] == AVAILABLE) {
1972         signerNonceStatus[msg.sender][nonces[i]] = UNAVAILABLE;
1973         emit Cancel(nonces[i], msg.sender);
1974       }
1975     }
1976   }
1977   /**
1978     * @notice Cancels all orders below a nonce value
1979     * @dev Emits a CancelUpTo event
1980     * @param minimumNonce uint256 Minimum valid nonce
1981     */
1982   function cancelUpTo(
1983     uint256 minimumNonce
1984   ) external {
1985     signerMinimumNonce[msg.sender] = minimumNonce;
1986     emit CancelUpTo(minimumNonce, msg.sender);
1987   }
1988   /**
1989     * @notice Authorize a delegated sender
1990     * @dev Emits an AuthorizeSender event
1991     * @param authorizedSender address Address to authorize
1992     */
1993   function authorizeSender(
1994     address authorizedSender
1995   ) external {
1996     require(msg.sender != authorizedSender, "SELF_AUTH_INVALID");
1997     if (!senderAuthorizations[msg.sender][authorizedSender]) {
1998       senderAuthorizations[msg.sender][authorizedSender] = true;
1999       emit AuthorizeSender(msg.sender, authorizedSender);
2000     }
2001   }
2002   /**
2003     * @notice Authorize a delegated signer
2004     * @dev Emits an AuthorizeSigner event
2005     * @param authorizedSigner address Address to authorize
2006     */
2007   function authorizeSigner(
2008     address authorizedSigner
2009   ) external {
2010     require(msg.sender != authorizedSigner, "SELF_AUTH_INVALID");
2011     if (!signerAuthorizations[msg.sender][authorizedSigner]) {
2012       signerAuthorizations[msg.sender][authorizedSigner] = true;
2013       emit AuthorizeSigner(msg.sender, authorizedSigner);
2014     }
2015   }
2016   /**
2017     * @notice Revoke an authorized sender
2018     * @dev Emits a RevokeSender event
2019     * @param authorizedSender address Address to revoke
2020     */
2021   function revokeSender(
2022     address authorizedSender
2023   ) external {
2024     if (senderAuthorizations[msg.sender][authorizedSender]) {
2025       delete senderAuthorizations[msg.sender][authorizedSender];
2026       emit RevokeSender(msg.sender, authorizedSender);
2027     }
2028   }
2029   /**
2030     * @notice Revoke an authorized signer
2031     * @dev Emits a RevokeSigner event
2032     * @param authorizedSigner address Address to revoke
2033     */
2034   function revokeSigner(
2035     address authorizedSigner
2036   ) external {
2037     if (signerAuthorizations[msg.sender][authorizedSigner]) {
2038       delete signerAuthorizations[msg.sender][authorizedSigner];
2039       emit RevokeSigner(msg.sender, authorizedSigner);
2040     }
2041   }
2042   /**
2043     * @notice Determine whether a sender delegate is authorized
2044     * @param authorizer address Address doing the authorization
2045     * @param delegate address Address being authorized
2046     * @return bool True if a delegate is authorized to send
2047     */
2048   function isSenderAuthorized(
2049     address authorizer,
2050     address delegate
2051   ) internal view returns (bool) {
2052     return ((authorizer == delegate) ||
2053       senderAuthorizations[authorizer][delegate]);
2054   }
2055   /**
2056     * @notice Determine whether a signer delegate is authorized
2057     * @param authorizer address Address doing the authorization
2058     * @param delegate address Address being authorized
2059     * @return bool True if a delegate is authorized to sign
2060     */
2061   function isSignerAuthorized(
2062     address authorizer,
2063     address delegate
2064   ) internal view returns (bool) {
2065     return ((authorizer == delegate) ||
2066       signerAuthorizations[authorizer][delegate]);
2067   }
2068   /**
2069     * @notice Validate signature using an EIP-712 typed data hash
2070     * @param order Types.Order Order to validate
2071     * @param domainSeparator bytes32 Domain identifier used in signatures (EIP-712)
2072     * @return bool True if order has a valid signature
2073     */
2074   function isValid(
2075     Types.Order memory order,
2076     bytes32 domainSeparator
2077   ) internal pure returns (bool) {
2078     if (order.signature.version == byte(0x01)) {
2079       return order.signature.signatory == ecrecover(
2080         Types.hashOrder(
2081           order,
2082           domainSeparator
2083         ),
2084         order.signature.v,
2085         order.signature.r,
2086         order.signature.s
2087       );
2088     }
2089     if (order.signature.version == byte(0x45)) {
2090       return order.signature.signatory == ecrecover(
2091         keccak256(
2092           abi.encodePacked(
2093             "\x19Ethereum Signed Message:\n32",
2094             Types.hashOrder(order, domainSeparator)
2095           )
2096         ),
2097         order.signature.v,
2098         order.signature.r,
2099         order.signature.s
2100       );
2101     }
2102     return false;
2103   }
2104   /**
2105     * @notice Perform token transfer for tokens in registry
2106     * @dev Transfer type specified by the bytes4 kind param
2107     * @dev ERC721: uses transferFrom for transfer
2108     * @dev ERC20: Takes into account non-standard ERC-20 tokens.
2109     * @param from address Wallet address to transfer from
2110     * @param to address Wallet address to transfer to
2111     * @param amount uint256 Amount for ERC-20
2112     * @param id token ID for ERC-721
2113     * @param token address Contract address of token
2114     * @param kind bytes4 EIP-165 interface ID of the token
2115     */
2116   function transferToken(
2117       address from,
2118       address to,
2119       uint256 amount,
2120       uint256 id,
2121       address token,
2122       bytes4 kind
2123   ) internal {
2124     // Ensure the transfer is not to self.
2125     require(from != to, "SELF_TRANSFER_INVALID");
2126     ITransferHandler transferHandler = registry.transferHandlers(kind);
2127     require(address(transferHandler) != address(0), "TOKEN_KIND_UNKNOWN");
2128     // delegatecall required to pass msg.sender as Swap contract to handle the
2129     // token transfer in the calling contract
2130     (bool success, bytes memory data) = address(transferHandler).
2131       delegatecall(abi.encodeWithSelector(
2132         transferHandler.transferTokens.selector,
2133         from,
2134         to,
2135         amount,
2136         id,
2137         token
2138     ));
2139     require(success && abi.decode(data, (bool)), "TRANSFER_FAILED");
2140   }
2141 }
2142 // File: @airswap/tokens/contracts/interfaces/IWETH.sol
2143 interface IWETH {
2144   function deposit() external payable;
2145   function withdraw(uint256) external;
2146   function totalSupply() external view returns (uint256);
2147   function balanceOf(address account) external view returns (uint256);
2148   function transfer(address recipient, uint256 amount) external returns (bool);
2149   function allowance(address owner, address spender) external view returns (uint256);
2150   function approve(address spender, uint256 amount) external returns (bool);
2151   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2152   event Transfer(address indexed from, address indexed to, uint256 value);
2153   event Approval(address indexed owner, address indexed spender, uint256 value);
2154 }
2155 // File: @airswap/wrapper/contracts/Wrapper.sol
2156 /*
2157   Copyright 2020 Swap Holdings Ltd.
2158   Licensed under the Apache License, Version 2.0 (the "License");
2159   you may not use this file except in compliance with the License.
2160   You may obtain a copy of the License at
2161     http://www.apache.org/licenses/LICENSE-2.0
2162   Unless required by applicable law or agreed to in writing, software
2163   distributed under the License is distributed on an "AS IS" BASIS,
2164   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2165   See the License for the specific language governing permissions and
2166   limitations under the License.
2167 */
2168 /**
2169   * @title Wrapper: Send and receive ether for WETH trades
2170   */
2171 contract Wrapper {
2172   // The Swap contract to settle trades
2173   ISwap public swapContract;
2174   // The WETH contract to wrap ether
2175   IWETH public wethContract;
2176   /**
2177     * @notice Contract Constructor
2178     * @param wrapperSwapContract address
2179     * @param wrapperWethContract address
2180     */
2181   constructor(
2182     address wrapperSwapContract,
2183     address wrapperWethContract
2184   ) public {
2185     swapContract = ISwap(wrapperSwapContract);
2186     wethContract = IWETH(wrapperWethContract);
2187   }
2188   /**
2189     * @notice Required when withdrawing from WETH
2190     * @dev During unwraps, WETH.withdraw transfers ether to msg.sender (this contract)
2191     */
2192   function() external payable {
2193     // Ensure the message sender is the WETH contract.
2194     if(msg.sender != address(wethContract)) {
2195       revert("DO_NOT_SEND_ETHER");
2196     }
2197   }
2198   /**
2199     * @notice Send an Order to be forwarded to Swap
2200     * @dev Sender must authorize this contract on the swapContract
2201     * @dev Sender must approve this contract on the wethContract
2202     * @param order Types.Order The Order
2203     */
2204   function swap(
2205     Types.Order calldata order
2206   ) external payable {
2207     // Ensure msg.sender is sender wallet.
2208     require(order.sender.wallet == msg.sender,
2209       "MSG_SENDER_MUST_BE_ORDER_SENDER");
2210     // Ensure that the signature is present.
2211     // The signature will be explicitly checked in Swap.
2212     require(order.signature.v != 0,
2213       "SIGNATURE_MUST_BE_SENT");
2214     // Wraps ETH to WETH when the sender provides ETH and the order is WETH
2215     _wrapEther(order.sender);
2216     // Perform the swap.
2217     swapContract.swap(order);
2218     // Unwraps WETH to ETH when the sender receives WETH
2219     _unwrapEther(order.sender.wallet, order.signer.token, order.signer.amount);
2220   }
2221   /**
2222     * @notice Send an Order to be forwarded to a Delegate
2223     * @dev Sender must authorize the Delegate contract on the swapContract
2224     * @dev Sender must approve this contract on the wethContract
2225     * @dev Delegate's tradeWallet must be order.sender - checked in Delegate
2226     * @param order Types.Order The Order
2227     * @param delegate IDelegate The Delegate to provide the order to
2228     */
2229   function provideDelegateOrder(
2230     Types.Order calldata order,
2231     IDelegate delegate
2232   ) external payable {
2233     // Ensure that the signature is present.
2234     // The signature will be explicitly checked in Swap.
2235     require(order.signature.v != 0,
2236       "SIGNATURE_MUST_BE_SENT");
2237     // Wraps ETH to WETH when the signer provides ETH and the order is WETH
2238     _wrapEther(order.signer);
2239     // Provide the order to the Delegate.
2240     delegate.provideOrder(order);
2241     // Unwraps WETH to ETH when the signer receives WETH
2242     _unwrapEther(order.signer.wallet, order.sender.token, order.sender.amount);
2243   }
2244   /**
2245     * @notice Wraps ETH to WETH when a trade requires it
2246     * @param party Types.Party The side of the trade that may need wrapping
2247     */
2248   function _wrapEther(Types.Party memory party) internal {
2249     // Check whether ether needs wrapping
2250     if (party.token == address(wethContract)) {
2251       // Ensure message value is param.
2252       require(party.amount == msg.value,
2253         "VALUE_MUST_BE_SENT");
2254       // Wrap (deposit) the ether.
2255       wethContract.deposit.value(msg.value)();
2256       // Transfer the WETH from the wrapper to party.
2257       // Return value not checked - WETH throws on error and does not return false
2258       wethContract.transfer(party.wallet, party.amount);
2259     } else {
2260       // Ensure no unexpected ether is sent.
2261       require(msg.value == 0,
2262         "VALUE_MUST_BE_ZERO");
2263     }
2264   }
2265   /**
2266     * @notice Unwraps WETH to ETH when a trade requires it
2267     * @dev The unwrapping only succeeds if recipientWallet has approved transferFrom
2268     * @param recipientWallet address The trade recipient, who may have received WETH
2269     * @param receivingToken address The token address the recipient received
2270     * @param amount uint256 The amount of token the recipient received
2271     */
2272   function _unwrapEther(address recipientWallet, address receivingToken, uint256 amount) internal {
2273     // Check whether ether needs unwrapping
2274     if (receivingToken == address(wethContract)) {
2275       // Transfer weth from the recipient to the wrapper.
2276       wethContract.transferFrom(recipientWallet, address(this), amount);
2277       // Unwrap (withdraw) the ether.
2278       wethContract.withdraw(amount);
2279       // Transfer ether to the recipient.
2280       // solium-disable-next-line security/no-call-value
2281       (bool success, ) = recipientWallet.call.value(amount)("");
2282       require(success, "ETH_RETURN_FAILED");
2283     }
2284   }
2285 }
2286 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
2287 /**
2288  * @dev Interface of the ERC165 standard, as defined in the
2289  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2290  *
2291  * Implementers can declare support of contract interfaces, which can then be
2292  * queried by others ({ERC165Checker}).
2293  *
2294  * For an implementation, see {ERC165}.
2295  */
2296 interface IERC165 {
2297     /**
2298      * @dev Returns true if this contract implements the interface defined by
2299      * `interfaceId`. See the corresponding
2300      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2301      * to learn more about how these ids are created.
2302      *
2303      * This function call must use less than 30 000 gas.
2304      */
2305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2306 }
2307 // File: @airswap/tokens/contracts/interfaces/IERC1155.sol
2308 /**
2309  *
2310  * Copied from OpenZeppelin ERC1155 feature branch from (20642cca30fa18fb167df6db1889b558742d189a)
2311  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/feature-erc1155/contracts/token/ERC1155/ERC1155.sol
2312  */
2313 /**
2314     @title ERC-1155 Multi Token Standard basic interface
2315     @dev See https://eips.ethereum.org/EIPS/eip-1155
2316  */
2317 contract IERC1155 is IERC165 {
2318     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
2319     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
2320     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
2321     event URI(string value, uint256 indexed id);
2322     function balanceOf(address account, uint256 id) public view returns (uint256);
2323     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view returns (uint256[] memory);
2324     function setApprovalForAll(address operator, bool approved) external;
2325     function isApprovedForAll(address account, address operator) external view returns (bool);
2326     function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external;
2327     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external;
2328 }
2329 // File: @airswap/transfers/contracts/handlers/ERC1155TransferHandler.sol
2330 /*
2331   Copyright 2020 Swap Holdings Ltd.
2332   Licensed under the Apache License, Version 2.0 (the "License");
2333   you may not use this file except in compliance with the License.
2334   You may obtain a copy of the License at
2335     http://www.apache.org/licenses/LICENSE-2.0
2336   Unless required by applicable law or agreed to in writing, software
2337   distributed under the License is distributed on an "AS IS" BASIS,
2338   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2339   See the License for the specific language governing permissions and
2340   limitations under the License.
2341 */
2342 contract ERC1155TransferHandler is ITransferHandler {
2343  /**
2344   * @notice Function to wrap safeTransferFrom for ERC1155
2345   * @param from address Wallet address to transfer from
2346   * @param to address Wallet address to transfer to
2347   * @param amount uint256 Amount for ERC-1155
2348   * @param id uint256 token ID for ERC-1155
2349   * @param token address Contract address of token
2350   * @return bool on success of the token transfer
2351   */
2352   function transferTokens(
2353     address from,
2354     address to,
2355     uint256 amount,
2356     uint256 id,
2357     address token
2358   ) external returns (bool) {
2359     IERC1155(token).safeTransferFrom(
2360       from,
2361       to,
2362       id,
2363       amount,
2364       "" // bytes are empty
2365     );
2366     return true;
2367   }
2368 }
2369 // File: openzeppelin-solidity/contracts/utils/Address.sol
2370 /**
2371  * @dev Collection of functions related to the address type
2372  */
2373 library Address {
2374     /**
2375      * @dev Returns true if `account` is a contract.
2376      *
2377      * This test is non-exhaustive, and there may be false-negatives: during the
2378      * execution of a contract's constructor, its address will be reported as
2379      * not containing a contract.
2380      *
2381      * IMPORTANT: It is unsafe to assume that an address for which this
2382      * function returns false is an externally-owned account (EOA) and not a
2383      * contract.
2384      */
2385     function isContract(address account) internal view returns (bool) {
2386         // This method relies in extcodesize, which returns 0 for contracts in
2387         // construction, since the code is only stored at the end of the
2388         // constructor execution.
2389         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
2390         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
2391         // for accounts without code, i.e. `keccak256('')`
2392         bytes32 codehash;
2393         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
2394         // solhint-disable-next-line no-inline-assembly
2395         assembly { codehash := extcodehash(account) }
2396         return (codehash != 0x0 && codehash != accountHash);
2397     }
2398     /**
2399      * @dev Converts an `address` into `address payable`. Note that this is
2400      * simply a type cast: the actual underlying value is not changed.
2401      *
2402      * _Available since v2.4.0._
2403      */
2404     function toPayable(address account) internal pure returns (address payable) {
2405         return address(uint160(account));
2406     }
2407     /**
2408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2409      * `recipient`, forwarding all available gas and reverting on errors.
2410      *
2411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2413      * imposed by `transfer`, making them unable to receive funds via
2414      * `transfer`. {sendValue} removes this limitation.
2415      *
2416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2417      *
2418      * IMPORTANT: because control is transferred to `recipient`, care must be
2419      * taken to not create reentrancy vulnerabilities. Consider using
2420      * {ReentrancyGuard} or the
2421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2422      *
2423      * _Available since v2.4.0._
2424      */
2425     function sendValue(address payable recipient, uint256 amount) internal {
2426         require(address(this).balance >= amount, "Address: insufficient balance");
2427         // solhint-disable-next-line avoid-call-value
2428         (bool success, ) = recipient.call.value(amount)("");
2429         require(success, "Address: unable to send value, recipient may have reverted");
2430     }
2431 }
2432 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
2433 /**
2434  * @title SafeERC20
2435  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2436  * contract returns false). Tokens that return no value (and instead revert or
2437  * throw on failure) are also supported, non-reverting calls are assumed to be
2438  * successful.
2439  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
2440  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2441  */
2442 library SafeERC20 {
2443     using SafeMath for uint256;
2444     using Address for address;
2445     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2446         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2447     }
2448     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2449         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2450     }
2451     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2452         // safeApprove should only be called when setting an initial allowance,
2453         // or when resetting it to zero. To increase and decrease it, use
2454         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2455         // solhint-disable-next-line max-line-length
2456         require((value == 0) || (token.allowance(address(this), spender) == 0),
2457             "SafeERC20: approve from non-zero to non-zero allowance"
2458         );
2459         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2460     }
2461     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2462         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2463         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2464     }
2465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2468     }
2469     /**
2470      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2471      * on the return value: the return value is optional (but if data is returned, it must not be false).
2472      * @param token The token targeted by the call.
2473      * @param data The call data (encoded using abi.encode or one of its variants).
2474      */
2475     function callOptionalReturn(IERC20 token, bytes memory data) private {
2476         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2477         // we're implementing it ourselves.
2478         // A Solidity high level call has three parts:
2479         //  1. The target address is checked to verify it contains contract code
2480         //  2. The call itself is made, and success asserted
2481         //  3. The return value is decoded, which in turn checks the size of the returned data.
2482         // solhint-disable-next-line max-line-length
2483         require(address(token).isContract(), "SafeERC20: call to non-contract");
2484         // solhint-disable-next-line avoid-low-level-calls
2485         (bool success, bytes memory returndata) = address(token).call(data);
2486         require(success, "SafeERC20: low-level call failed");
2487         if (returndata.length > 0) { // Return data is optional
2488             // solhint-disable-next-line max-line-length
2489             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2490         }
2491     }
2492 }
2493 // File: @airswap/transfers/contracts/handlers/ERC20TransferHandler.sol
2494 /*
2495   Copyright 2020 Swap Holdings Ltd.
2496   Licensed under the Apache License, Version 2.0 (the "License");
2497   you may not use this file except in compliance with the License.
2498   You may obtain a copy of the License at
2499     http://www.apache.org/licenses/LICENSE-2.0
2500   Unless required by applicable law or agreed to in writing, software
2501   distributed under the License is distributed on an "AS IS" BASIS,
2502   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2503   See the License for the specific language governing permissions and
2504   limitations under the License.
2505 */
2506 contract ERC20TransferHandler is ITransferHandler {
2507   using SafeERC20 for IERC20;
2508  /**
2509   * @notice Function to wrap safeTransferFrom for ERC20
2510   * @param from address Wallet address to transfer from
2511   * @param to address Wallet address to transfer to
2512   * @param amount uint256 Amount for ERC-20
2513   * @param id uint256 ID, must be 0 for this contract
2514   * @param token address Contract address of token
2515   * @return bool on success of the token transfer
2516   */
2517   function transferTokens(
2518     address from,
2519     address to,
2520     uint256 amount,
2521     uint256 id,
2522     address token
2523   ) external returns (bool) {
2524     require(id == 0, "ID_INVALID");
2525     IERC20(token).safeTransferFrom(from, to, amount);
2526     return true;
2527   }
2528 }
2529 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
2530 /**
2531  * @dev Required interface of an ERC721 compliant contract.
2532  */
2533 contract IERC721 is IERC165 {
2534     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2537     /**
2538      * @dev Returns the number of NFTs in `owner`'s account.
2539      */
2540     function balanceOf(address owner) public view returns (uint256 balance);
2541     /**
2542      * @dev Returns the owner of the NFT specified by `tokenId`.
2543      */
2544     function ownerOf(uint256 tokenId) public view returns (address owner);
2545     /**
2546      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
2547      * another (`to`).
2548      *
2549      *
2550      *
2551      * Requirements:
2552      * - `from`, `to` cannot be zero.
2553      * - `tokenId` must be owned by `from`.
2554      * - If the caller is not `from`, it must be have been allowed to move this
2555      * NFT by either {approve} or {setApprovalForAll}.
2556      */
2557     function safeTransferFrom(address from, address to, uint256 tokenId) public;
2558     /**
2559      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
2560      * another (`to`).
2561      *
2562      * Requirements:
2563      * - If the caller is not `from`, it must be approved to move this NFT by
2564      * either {approve} or {setApprovalForAll}.
2565      */
2566     function transferFrom(address from, address to, uint256 tokenId) public;
2567     function approve(address to, uint256 tokenId) public;
2568     function getApproved(uint256 tokenId) public view returns (address operator);
2569     function setApprovalForAll(address operator, bool _approved) public;
2570     function isApprovedForAll(address owner, address operator) public view returns (bool);
2571     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
2572 }
2573 // File: @airswap/transfers/contracts/handlers/ERC721TransferHandler.sol
2574 /*
2575   Copyright 2020 Swap Holdings Ltd.
2576   Licensed under the Apache License, Version 2.0 (the "License");
2577   you may not use this file except in compliance with the License.
2578   You may obtain a copy of the License at
2579     http://www.apache.org/licenses/LICENSE-2.0
2580   Unless required by applicable law or agreed to in writing, software
2581   distributed under the License is distributed on an "AS IS" BASIS,
2582   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2583   See the License for the specific language governing permissions and
2584   limitations under the License.
2585 */
2586 contract ERC721TransferHandler is ITransferHandler {
2587  /**
2588   * @notice Function to wrap safeTransferFrom for ERC721
2589   * @param from address Wallet address to transfer from
2590   * @param to address Wallet address to transfer to
2591   * @param amount uint256, must be 0 for this contract
2592   * @param id uint256 ID for ERC721
2593   * @param token address Contract address of token
2594   * @return bool on success of the token transfer
2595   */
2596   function transferTokens(
2597     address from,
2598     address to,
2599     uint256 amount,
2600     uint256 id,
2601     address token)
2602   external returns (bool) {
2603     require(amount == 0, "AMOUNT_INVALID");
2604     IERC721(token).safeTransferFrom(from, to, id);
2605     return true;
2606   }
2607 }
2608 // File: @airswap/transfers/contracts/interfaces/IKittyCoreTokenTransfer.sol
2609 /*
2610   Copyright 2020 Swap Holdings Ltd.
2611   Licensed under the Apache License, Version 2.0 (the "License");
2612   you may not use this file except in compliance with the License.
2613   You may obtain a copy of the License at
2614     http://www.apache.org/licenses/LICENSE-2.0
2615   Unless required by applicable law or agreed to in writing, software
2616   distributed under the License is distributed on an "AS IS" BASIS,
2617   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2618   See the License for the specific language governing permissions and
2619   limitations under the License.
2620 */
2621 /**
2622  * @title IKittyCoreTokenTransfer
2623  * @dev transferFrom function from KittyCore
2624  */
2625 contract IKittyCoreTokenTransfer {
2626   function transferFrom(address from, address to, uint256 tokenId) external;
2627 }
2628 // File: @airswap/transfers/contracts/handlers/KittyCoreTransferHandler.sol
2629 /*
2630   Copyright 2020 Swap Holdings Ltd.
2631   Licensed under the Apache License, Version 2.0 (the "License");
2632   you may not use this file except in compliance with the License.
2633   You may obtain a copy of the License at
2634     http://www.apache.org/licenses/LICENSE-2.0
2635   Unless required by applicable law or agreed to in writing, software
2636   distributed under the License is distributed on an "AS IS" BASIS,
2637   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2638   See the License for the specific language governing permissions and
2639   limitations under the License.
2640 */
2641 contract KittyCoreTransferHandler is ITransferHandler {
2642  /**
2643   * @notice Function to wrap transferFrom for CKitty
2644   * @param from address Wallet address to transfer from
2645   * @param to address Wallet address to transfer to
2646   * @param amount uint256, must be 0 for this contract
2647   * @param id uint256 ID for ERC721
2648   * @param token address Contract address of token
2649   * @return bool on success of the token transfer
2650   */
2651   function transferTokens(
2652     address from,
2653     address to,
2654     uint256 amount,
2655     uint256 id,
2656     address token
2657   ) external returns (bool) {
2658     require(amount == 0, "AMOUNT_INVALID");
2659     IKittyCoreTokenTransfer(token).transferFrom(from, to, id);
2660     return true;
2661   }
2662 }
2663 // File: contracts/Imports.sol
2664 //Import all the contracts desired to be deployed
2665 contract Imports {}

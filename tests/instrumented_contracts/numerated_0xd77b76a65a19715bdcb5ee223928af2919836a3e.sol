1 // File: contracts/zeppelin/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/zeppelin/token/ERC20/ERC20Detailed.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 /**
86  * @dev Optional functions from the ERC20 standard.
87  */
88 contract ERC20Detailed is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     /**
94      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
95      * these values are immutable: they can only be set once during
96      * construction.
97      */
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     /**
112      * @dev Returns the symbol of the token, usually a shorter version of the
113      * name.
114      */
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118 
119     /**
120      * @dev Returns the number of decimals used to get its user representation.
121      * For example, if `decimals` equals `2`, a balance of `505` tokens should
122      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
123      *
124      * Tokens usually opt for a value of 18, imitating the relationship between
125      * Ether and Wei.
126      *
127      * NOTE: This information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * {IERC20-balanceOf} and {IERC20-transfer}.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: contracts/IBridge.sol
137 
138 pragma solidity ^0.5.0;
139 
140 
141 interface IBridge {
142     function version() external pure returns (string memory);
143 
144     //function getFeePercentage() external view returns(uint);
145 
146     //function calcMaxWithdraw() external view returns (uint);
147 
148     /**
149      * ERC-20 tokens approve and transferFrom pattern
150      * See https://eips.ethereum.org/EIPS/eip-20#transferfrom
151      */
152     function receiveTokens(address tokenToUse, uint256 amount) external returns(bool);
153 
154     /**
155      * ERC-20 tokens approve and transferFrom pattern
156      * See https://eips.ethereum.org/EIPS/eip-20#transferfrom
157      */
158     function receiveTokensAt(
159         address tokenToUse,
160         uint256 amount,
161         address receiver,
162         bytes calldata extraData
163     ) external returns(bool);
164 
165     /**
166      * ERC-777 tokensReceived hook allows to send tokens to a contract and notify it in a single transaction
167      * See https://eips.ethereum.org/EIPS/eip-777#motivation for details
168      */
169     function tokensReceived (
170         address operator,
171         address from,
172         address to,
173         uint amount,
174         bytes calldata userData,
175         bytes calldata operatorData
176     ) external;
177 
178     /**
179      * Accepts the transaction from the other chain that was voted and sent by the federation contract
180      */
181     function acceptTransfer(
182         address originalTokenAddress,
183         address receiver,
184         uint256 amount,
185         string calldata symbol,
186         bytes32 blockHash,
187         bytes32 transactionHash,
188         uint32 logIndex,
189         uint8 decimals,
190         uint256 granularity
191     ) external returns(bool);
192 
193     function acceptTransferAt(
194         address originalTokenAddress,
195         address receiver,
196         uint256 amount,
197         string calldata symbol,
198         bytes32 blockHash,
199         bytes32 transactionHash,
200         uint32 logIndex,
201         uint8 decimals,
202         uint256 granularity,
203         bytes calldata userData
204     ) external returns(bool);
205 
206     function receiveEthAt(address _receiver, bytes calldata _extraData) external payable;
207 
208     function setRevokeTransaction(bytes32 _revokeTransactionID) external;
209     function setErc777Converter(address _erc777Converter) external;
210     //function getErc777Converter() external view returns(address erc777Addr);
211 
212     event Cross(address indexed _tokenAddress, address indexed _to, uint256 _amount, string _symbol, bytes _userData,
213         uint8 _decimals, uint256 _granularity);
214     event NewSideToken(address indexed _newSideTokenAddress, address indexed _originalTokenAddress, string _newSymbol, uint256 _granularity);
215     event AcceptedCrossTransfer(address indexed _tokenAddress, address indexed _to, uint256 _amount, uint8 _decimals, uint256 _granularity,
216         uint256 _formattedAmount, uint8 _calculatedDecimals, uint256 _calculatedGranularity, bytes _userData);
217     //event FeePercentageChanged(uint256 _amount);
218     event ErrorTokenReceiver(bytes _errorData);
219     //event AllowTokenChanged(address _newAllowToken);
220     //event PrefixUpdated(bool _isPrefix, string _prefix);
221 
222 }
223 
224 // File: contracts/zeppelin/GSN/Context.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /*
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with GSN meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 contract Context {
239     // Empty internal constructor, to prevent people from mistakenly deploying
240     // an instance of this contract, which should be used via inheritance.
241     constructor () internal { }
242     // solhint-disable-previous-line no-empty-blocks
243 
244     function _msgSender() internal view returns (address payable) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view returns (bytes memory) {
249         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
250         return msg.data;
251     }
252 }
253 
254 // File: contracts/zeppelin/ownership/Ownable.sol
255 
256 pragma solidity ^0.5.0;
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         _owner = _msgSender();
277         emit OwnershipTransferred(address(0), _owner);
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(isOwner(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Returns true if the caller is the current owner.
297      */
298     function isOwner() public view returns (bool) {
299         return _msgSender() == _owner;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public onlyOwner {
319         _transferOwnership(newOwner);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      */
325     function _transferOwnership(address newOwner) internal {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331 
332 // File: contracts/zeppelin/cryptography/ECDSA.sol
333 
334 pragma solidity ^0.5.2;
335 
336 /**
337  * @title Elliptic curve signature operations
338  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
339  * TODO Remove this library once solidity supports passing a signature to ecrecover.
340  * See https://github.com/ethereum/solidity/issues/864
341  */
342 
343 library ECDSA {
344     /**
345      * @dev Recover signer address from a message by using their signature
346      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
347      * @param signature bytes signature, the signature is generated using web3.eth.sign()
348      */
349     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
350         // Check the signature length
351         if (signature.length != 65) {
352             return (address(0));
353         }
354 
355         // Divide the signature in r, s and v variables
356         bytes32 r;
357         bytes32 s;
358         uint8 v;
359 
360         // ecrecover takes the signature parameters, and the only way to get them
361         // currently is to use assembly.
362         // solhint-disable-next-line no-inline-assembly
363         assembly {
364             r := mload(add(signature, 0x20))
365             s := mload(add(signature, 0x40))
366             v := byte(0, mload(add(signature, 0x60)))
367         }
368 
369         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
370         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
371         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
372         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
373         //
374         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
375         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
376         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
377         // these malleable signatures as well.
378         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
379             return address(0);
380         }
381 
382         if (v != 27 && v != 28) {
383             return address(0);
384         }
385 
386         // If the signature is valid (and not malleable), return the signer address
387         return ecrecover(hash, v, r, s);
388     }
389 
390     /**
391      * toEthSignedMessageHash
392      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
393      * and hash the result
394      */
395     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
396         // 32 is the length in bytes of hash,
397         // enforced by the type signature above
398         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
399     }
400 }
401 
402 // File: contracts/Federation.sol
403 
404 pragma solidity ^0.5.0;
405 pragma experimental ABIEncoderV2;
406 
407 
408 
409 
410 contract Federation is Ownable {
411     struct SignatureInfo {
412         bytes signature;
413         uint256 deadline;
414     }
415 
416     uint256 public constant MAX_MEMBER_COUNT = 50;
417     address private constant NULL_ADDRESS = address(0);
418 
419     IBridge public bridge;
420     address[] public members;
421     uint256 public required;
422 
423     bytes32 private constant NULL_HASH = bytes32(0);
424     bool public initStageDone;
425 
426     mapping(address => bool) public isMember;
427     mapping(bytes32 => mapping(address => bool)) public votes;
428     mapping(bytes32 => bool) public processed;
429     // solium-disable-next-line max-len
430     event Voted(
431         address indexed sender,
432         bytes32 indexed transactionId,
433         address originalTokenAddress,
434         address receiver,
435         uint256 amount,
436         string symbol,
437         bytes32 blockHash,
438         bytes32 indexed transactionHash,
439         uint32 logIndex,
440         uint8 decimals,
441         uint256 granularity,
442         bytes userData
443     );
444     event Signed(bytes32 indexed transactionId, address validator);
445     event Executed(bytes32 indexed transactionId);
446     event MemberAddition(address indexed member);
447     event MemberRemoval(address indexed member);
448     event RequirementChange(uint256 required);
449     event BridgeChanged(address bridge);
450     event RevokeTxAndVote(bytes32 tx_revoked);
451     event StoreFormerFederationExecutedTx(bytes32[] tx_stored);
452 
453     modifier onlyMember() {
454         require(isMember[_msgSender()], "Federation: Caller not a Federator");
455         _;
456     }
457 
458     modifier validRequirement(uint256 membersCount, uint256 _required) {
459         // solium-disable-next-line max-len
460         require(
461             _required <= membersCount && _required != 0 && membersCount != 0,
462             "Federation: Invalid requirements"
463         );
464         _;
465     }
466 
467     constructor(address[] memory _members, uint256 _required)
468         public
469         validRequirement(_members.length, _required)
470     {
471         require(_members.length <= MAX_MEMBER_COUNT, "Federation: Members larger than max allowed");
472         members = _members;
473         for (uint256 i = 0; i < _members.length; i++) {
474             require(
475                 !isMember[_members[i]] && _members[i] != NULL_ADDRESS,
476                 "Federation: Invalid members"
477             );
478             isMember[_members[i]] = true;
479             // members.push(_members[i]);
480 
481             emit MemberAddition(_members[i]);
482         }
483         required = _required;
484         emit RequirementChange(required);
485     }
486 
487     function setBridge(address _bridge) external onlyOwner {
488         require(_bridge != NULL_ADDRESS, "Federation: Empty bridge");
489         bridge = IBridge(_bridge);
490         emit BridgeChanged(_bridge);
491     }
492 
493     function voteTransaction(
494         address originalTokenAddress,
495         address receiver,
496         uint256 amount,
497         string calldata symbol,
498         bytes32 blockHash,
499         bytes32 transactionHash,
500         uint32 logIndex,
501         uint8 decimals,
502         uint256 granularity
503     ) external returns (bool) {
504         return
505             _voteTransaction(
506                 originalTokenAddress,
507                 receiver,
508                 amount,
509                 symbol,
510                 blockHash,
511                 transactionHash,
512                 logIndex,
513                 decimals,
514                 granularity,
515                 ""
516             );
517     }
518 
519     function voteTransactionAt(
520         address originalTokenAddress,
521         address receiver,
522         uint256 amount,
523         string memory symbol,
524         bytes32 blockHash,
525         bytes32 transactionHash,
526         uint32 logIndex,
527         uint8 decimals,
528         uint256 granularity,
529         bytes memory userData
530     ) public returns (bool) {
531         return
532             _voteTransaction(
533                 originalTokenAddress,
534                 receiver,
535                 amount,
536                 symbol,
537                 blockHash,
538                 transactionHash,
539                 logIndex,
540                 decimals,
541                 granularity,
542                 userData
543             );
544     }
545 
546     function _voteTransaction(
547         address originalTokenAddress,
548         address receiver,
549         uint256 amount,
550         string memory symbol,
551         bytes32 blockHash,
552         bytes32 transactionHash,
553         uint32 logIndex,
554         uint8 decimals,
555         uint256 granularity,
556         bytes memory userData
557     ) internal onlyMember returns (bool) {
558         // solium-disable-next-line max-len
559         require(
560             initStageDone == true,
561             "Federation: Cannot process TX while initStageDone == false"
562         );
563 
564         bytes32 transactionId = getTransactionId(
565             originalTokenAddress,
566             receiver,
567             amount,
568             symbol,
569             blockHash,
570             transactionHash,
571             logIndex,
572             decimals,
573             granularity
574         );
575         if (processed[transactionId]) return true;
576 
577         // Bug fix //
578         // UserData is not included in transactionId hash.
579         // In order to keep backward competability, since transctions that were already processed are marked as processed[transactionId],
580         // We keep the transactionId and adding transactionIdU (that includes userData hashing)
581         // Assuming  processed[transactionId) == false from this line
582         // Depreciating transactionId for unprocessed transaction.
583         // Using transactionIdU instead.
584         // This should be updated in Federator BE as well.
585         // Function processTransaction() created to solve EVM stack to deep error
586         if (
587             processTransaction(
588                 originalTokenAddress,
589                 receiver,
590                 amount,
591                 symbol,
592                 blockHash,
593                 transactionHash,
594                 logIndex,
595                 decimals,
596                 granularity,
597                 userData
598             )
599         ) {
600             // No need to update processed[transactionId], since it is used only for backward competability
601             // processed[transactionId] = true;
602             return true;
603         }
604         return true;
605     }
606 
607     function processTransaction(
608         address originalTokenAddress,
609         address receiver,
610         uint256 amount,
611         string memory symbol,
612         bytes32 blockHash,
613         bytes32 transactionHash,
614         uint32 logIndex,
615         uint8 decimals,
616         uint256 granularity,
617         bytes memory userData
618     ) internal returns (bool) {
619         bytes32 transactionIdU = getTransactionIdU(
620             originalTokenAddress,
621             receiver,
622             amount,
623             symbol,
624             blockHash,
625             transactionHash,
626             logIndex,
627             decimals,
628             granularity,
629             userData
630         );
631 
632         if (processed[transactionIdU]) return true;
633 
634         if (votes[transactionIdU][_msgSender()]) return true;
635 
636         votes[transactionIdU][_msgSender()] = true;
637         // solium-disable-next-line max-len
638         emit Voted(
639             _msgSender(),
640             transactionIdU,
641             originalTokenAddress,
642             receiver,
643             amount,
644             symbol,
645             blockHash,
646             transactionHash,
647             logIndex,
648             decimals,
649             granularity,
650             userData
651         );
652 
653         uint256 transactionCount = getTransactionCount(transactionIdU);
654         if (transactionCount >= required && transactionCount >= members.length / 2 + 1) {
655             processed[transactionIdU] = true;
656             bool acceptTransfer = bridge.acceptTransferAt(
657                 originalTokenAddress,
658                 receiver,
659                 amount,
660                 symbol,
661                 blockHash,
662                 transactionHash,
663                 logIndex,
664                 decimals,
665                 granularity,
666                 userData
667             );
668             require(acceptTransfer, "Federation: Bridge acceptTransfer error");
669             emit Executed(transactionIdU);
670             return true;
671         }
672     }
673 
674     function executeTransaction(
675         address originalTokenAddress,
676         address receiver,
677         uint256 amount,
678         string memory symbol,
679         bytes32 blockHash,
680         bytes32 transactionHash,
681         uint32 logIndex,
682         uint8 decimals,
683         uint256 granularity,
684         SignatureInfo[] memory signaturesInfos
685     ) public returns (bool) {
686         return
687             _executeTransaction(
688                 originalTokenAddress,
689                 receiver,
690                 amount,
691                 symbol,
692                 blockHash,
693                 transactionHash,
694                 logIndex,
695                 decimals,
696                 granularity,
697                 "",
698                 signaturesInfos
699             );
700     }
701 
702     function executeTransactionAt(
703         address originalTokenAddress,
704         address receiver,
705         uint256 amount,
706         string memory symbol,
707         bytes32 blockHash,
708         bytes32 transactionHash,
709         uint32 logIndex,
710         uint8 decimals,
711         uint256 granularity,
712         bytes memory userData,
713         SignatureInfo[] memory signaturesInfos
714     ) public returns (bool) {
715         return
716             _executeTransaction(
717                 originalTokenAddress,
718                 receiver,
719                 amount,
720                 symbol,
721                 blockHash,
722                 transactionHash,
723                 logIndex,
724                 decimals,
725                 granularity,
726                 userData,
727                 signaturesInfos
728             );
729     }
730 
731     function _executeTransaction(
732         address originalTokenAddress,
733         address receiver,
734         uint256 amount,
735         string memory symbol,
736         bytes32 blockHash,
737         bytes32 transactionHash,
738         uint32 logIndex,
739         uint8 decimals,
740         uint256 granularity,
741         bytes memory userData,
742         SignatureInfo[] memory signaturesInfos
743     ) internal onlyMember returns (bool) {
744         // solium-disable-next-line max-len
745         require(
746             initStageDone == true,
747             "Federation: Cannot process TX while initStageDone == false"
748         );
749 
750         bytes32 transactionId = getTransactionId(
751             originalTokenAddress,
752             receiver,
753             amount,
754             symbol,
755             blockHash,
756             transactionHash,
757             logIndex,
758             decimals,
759             granularity
760         );
761         if (processed[transactionId]) return true;
762 
763         // Bug fix //
764         // UserData is not included in transactionId hash.
765         // In order to keep backward competability, since transctions that were already processed are marked as processed[transactionId],
766         // We keep the transactionId and adding transactionIdU (that includes userData hashing)
767         // Assuming  processed[transactionId) == false from this line
768         // Depreciating transactionId for unprocessed transaction.
769         // Using transactionIdU instead.
770         // This should be updated in Federator BE as well.
771         // Function processTransaction() created to solve EVM stack to deep error
772         if (
773             processSignedTransaction(
774                 originalTokenAddress,
775                 receiver,
776                 amount,
777                 symbol,
778                 blockHash,
779                 transactionHash,
780                 logIndex,
781                 decimals,
782                 granularity,
783                 userData,
784                 signaturesInfos
785             )
786         ) {
787             // No need to update processed[transactionId], since it is used only for backward competability
788             // processed[transactionId] = true;
789             return true;
790         }
791         return true;
792     }
793 
794     function processSignedTransaction(
795         address originalTokenAddress,
796         address receiver,
797         uint256 amount,
798         string memory symbol,
799         bytes32 blockHash,
800         bytes32 transactionHash,
801         uint32 logIndex,
802         uint8 decimals,
803         uint256 granularity,
804         bytes memory userData,
805         SignatureInfo[] memory signaturesInfos
806     ) internal returns (bool) {
807         bytes32 transactionIdU = getTransactionIdU(
808             originalTokenAddress,
809             receiver,
810             amount,
811             symbol,
812             blockHash,
813             transactionHash,
814             logIndex,
815             decimals,
816             granularity,
817             userData
818         );
819         if (processed[transactionIdU]) return true;
820 
821         // Sender implicitly accepts
822         votes[transactionIdU][_msgSender()] = true;
823         uint256 memberValidations = 1;
824         emit Signed(transactionIdU, _msgSender());
825 
826         for (uint256 i; i < signaturesInfos.length; i += 1) {
827             require(
828                 signaturesInfos[i].deadline > block.timestamp,
829                 "Some signature is not valid anymore"
830             );
831 
832             uint256 chainId;
833             assembly {
834                 chainId := chainid()
835             }
836             bytes32 hash = keccak256(
837                 abi.encodePacked(
838                     "\x19Ethereum Signed Message:\n116",
839                     abi.encodePacked(
840                         transactionIdU,
841                         chainId,
842                         address(this),
843                         signaturesInfos[i].deadline
844                     )
845                 )
846             );
847             address signer = ECDSA.recover(hash, signaturesInfos[i].signature);
848 
849             require(isMember[signer], "Signature doesn't match any member");
850             if (!votes[transactionIdU][signer]) {
851                 votes[transactionIdU][signer] = true;
852                 memberValidations += 1;
853                 emit Signed(transactionIdU, signer);
854             }
855         }
856 
857         require(
858             memberValidations >= required && memberValidations >= members.length / 2 + 1,
859             "Not enough validations"
860         );
861 
862         processed[transactionIdU] = true;
863 
864         releaseTokensOnBridge(
865             transactionIdU,
866             originalTokenAddress,
867             receiver,
868             amount,
869             symbol,
870             blockHash,
871             transactionHash,
872             logIndex,
873             decimals,
874             granularity,
875             userData
876         );
877         emit Executed(transactionIdU);
878 
879         return true;
880     }
881 
882     function releaseTokensOnBridge(
883         bytes32 transactionIdU,
884         address originalTokenAddress,
885         address receiver,
886         uint256 amount,
887         string memory symbol,
888         bytes32 blockHash,
889         bytes32 transactionHash,
890         uint32 logIndex,
891         uint8 decimals,
892         uint256 granularity,
893         bytes memory userData
894     ) private {
895         emit Voted(
896             _msgSender(),
897             transactionIdU,
898             originalTokenAddress,
899             receiver,
900             amount,
901             symbol,
902             blockHash,
903             transactionHash,
904             logIndex,
905             decimals,
906             granularity,
907             userData
908         );
909         bool acceptTransfer = bridge.acceptTransferAt(
910             originalTokenAddress,
911             receiver,
912             amount,
913             symbol,
914             blockHash,
915             transactionHash,
916             logIndex,
917             decimals,
918             granularity,
919             userData
920         );
921         require(acceptTransfer, "Federation: Bridge acceptTransfer error");
922     }
923 
924     function getTransactionCount(bytes32 transactionId) public view returns (uint256) {
925         uint256 count = 0;
926         for (uint256 i = 0; i < members.length; i++) {
927             if (votes[transactionId][members[i]]) count += 1;
928         }
929         return count;
930     }
931 
932     function hasVoted(bytes32 transactionId) external view returns (bool) {
933         return votes[transactionId][_msgSender()];
934     }
935 
936     function transactionWasProcessed(bytes32 transactionId) external view returns (bool) {
937         return processed[transactionId];
938     }
939 
940     function getTransactionId(
941         address originalTokenAddress,
942         address receiver,
943         uint256 amount,
944         string memory symbol,
945         bytes32 blockHash,
946         bytes32 transactionHash,
947         uint32 logIndex,
948         uint8 decimals,
949         uint256 granularity
950     ) public pure returns (bytes32) {
951         // solium-disable-next-line max-len
952         return
953             keccak256(
954                 abi.encodePacked(
955                     originalTokenAddress,
956                     receiver,
957                     amount,
958                     symbol,
959                     blockHash,
960                     transactionHash,
961                     logIndex,
962                     decimals,
963                     granularity
964                 )
965             );
966     }
967 
968     function getTransactionIdU(
969         address originalTokenAddress,
970         address receiver,
971         uint256 amount,
972         string memory symbol,
973         bytes32 blockHash,
974         bytes32 transactionHash,
975         uint32 logIndex,
976         uint8 decimals,
977         uint256 granularity,
978         bytes memory userData
979     ) public pure returns (bytes32) {
980         // solium-disable-next-line max-len
981         return
982             keccak256(
983                 abi.encodePacked(
984                     originalTokenAddress,
985                     receiver,
986                     amount,
987                     symbol,
988                     blockHash,
989                     transactionHash,
990                     logIndex,
991                     decimals,
992                     granularity,
993                     userData
994                 )
995             );
996     }
997 
998     function addMember(address _newMember) external onlyOwner {
999         require(_newMember != NULL_ADDRESS, "Federation: Empty member");
1000         require(!isMember[_newMember], "Federation: Member already exists");
1001         require(members.length < MAX_MEMBER_COUNT, "Federation: Max members reached");
1002 
1003         isMember[_newMember] = true;
1004         members.push(_newMember);
1005         emit MemberAddition(_newMember);
1006     }
1007 
1008     function removeMember(address _oldMember) external onlyOwner {
1009         require(_oldMember != NULL_ADDRESS, "Federation: Empty member");
1010         require(isMember[_oldMember], "Federation: Member doesn't exists");
1011         require(members.length > 1, "Federation: Can't remove all the members");
1012         require(
1013             members.length - 1 >= required,
1014             "Federation: Can't have less than required members"
1015         );
1016 
1017         isMember[_oldMember] = false;
1018         for (uint256 i = 0; i < members.length - 1; i++) {
1019             if (members[i] == _oldMember) {
1020                 members[i] = members[members.length - 1];
1021                 break;
1022             }
1023         }
1024         members.length -= 1;
1025         emit MemberRemoval(_oldMember);
1026     }
1027 
1028     function getMembers() external view returns (address[] memory) {
1029         return members;
1030     }
1031 
1032     function changeRequirement(uint256 _required)
1033         external
1034         onlyOwner
1035         validRequirement(members.length, _required)
1036     {
1037         require(_required >= 2, "Federation: Requires at least 2");
1038         required = _required;
1039         emit RequirementChange(_required);
1040     }
1041 
1042     // Revoke state of txID (from true to false), to enable multiSig release of stucked txID on the bridge
1043     // setRevokeTransaction() should be called on the bridge as well to enable revoke of txID
1044     function setRevokeTransactionAndVote(bytes32 _revokeTransactionID) external onlyOwner {
1045         require(
1046             _revokeTransactionID != NULL_HASH,
1047             "Federation: _revokeTransactionID cannot be NULL"
1048         );
1049         require(
1050             processed[_revokeTransactionID] == true,
1051             "Federation: cannot revoke unprocessed TX"
1052         );
1053         processed[_revokeTransactionID] = false;
1054         for (uint256 i = 0; i < members.length; i++) {
1055             votes[_revokeTransactionID][members[i]] = false;
1056         }
1057         emit RevokeTxAndVote(_revokeTransactionID);
1058     }
1059 
1060     // Store former Federation contract version processed[] state
1061     // Can be used only at deployment stage. Cannot _voteTransaction txID while this stage is active (initStageDone is false)
1062     function initStoreOldFederation(bytes32[] calldata _TransactionIDs) external onlyOwner {
1063         require(
1064             initStageDone == false,
1065             "Federation: initStoreOldFederation enabled only during deployment setup Stage"
1066         );
1067         for (uint256 i = 0; i < _TransactionIDs.length; i++) {
1068             require(
1069                 _TransactionIDs[i] != NULL_HASH,
1070                 "Federation: _storeTransactionID cannot be NULL"
1071             );
1072             processed[_TransactionIDs[i]] = true;
1073         }
1074         emit StoreFormerFederationExecutedTx(_TransactionIDs);
1075     }
1076 
1077     // Finish stage of store of former Federation contract version
1078     // Must be set to true before _voteTransaction is called
1079     function endDeploymentSetup() external onlyOwner {
1080         initStageDone = true;
1081     }
1082 }
1 pragma solidity >=0.6.0 <0.7.0;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 interface ERC20Token {
7 
8     /**
9      * @notice send `_value` token to `_to` from `msg.sender`
10      * @param _to The address of the recipient
11      * @param _value The amount of token to be transferred
12      * @return success Whether the transfer was successful or not
13      */
14     function transfer(address _to, uint256 _value) external returns (bool success);
15 
16     /**
17      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
18      * @param _spender The address of the account able to transfer the tokens
19      * @param _value The amount of tokens to be approved for transfer
20      * @return success Whether the approval was successful or not
21      */
22     function approve(address _spender, uint256 _value) external returns (bool success);
23 
24     /**
25      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26      * @param _from The address of the sender
27      * @param _to The address of the recipient
28      * @param _value The amount of token to be transferred
29      * @return success Whether the transfer was successful or not
30      */
31     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
32 
33     /**
34      * @param _owner The address from which the balance will be retrieved
35      * @return balance The balance
36      */
37     function balanceOf(address _owner) external view returns (uint256 balance);
38 
39     /**
40      * @param _owner The address of the account owning tokens
41      * @param _spender The address of the account able to transfer the tokens
42      * @return remaining Amount of remaining tokens allowed to spent
43      */
44     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
45 
46     /**
47      * @notice return total supply of tokens
48      */
49     function totalSupply() external view returns (uint256 supply);
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 contract ReentrancyGuard {
56 
57     bool internal reentranceLock = false;
58 
59     /**
60      * @dev Use this modifier on functions susceptible to reentrancy attacks
61      */
62     modifier reentrancyGuard() {
63         require(!reentranceLock, "Reentrant call detected!");
64         reentranceLock = true; // No no no, you naughty naughty!
65         _;
66         reentranceLock = false;
67     }
68 }
69 pragma experimental ABIEncoderV2;
70 
71 
72 
73 
74 
75 /**
76  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
77  * @notice interface for StickerMarket
78  */
79 interface StickerMarket {
80 
81     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
82     event MarketState(State state);
83     event RegisterFee(uint256 value);
84     event BurnRate(uint256 value);
85 
86     enum State { Invalid, Open, BuyOnly, Controlled, Closed }
87 
88     function state() external view returns(State);
89     function snt() external view returns (address);
90     function stickerPack() external view returns (address);
91     function stickerType() external view returns (address);
92 
93     /**
94      * @dev Mints NFT StickerPack in `_destination` account, and Transfers SNT using user allowance
95      * emit NonfungibleToken.Transfer(`address(0)`, `_destination`, `tokenId`)
96      * @notice buy a pack from market pack owner, including a StickerPack's token in `_destination` account with same metadata of `_packId`
97      * @param _packId id of market pack
98      * @param _destination owner of token being brought
99      * @param _price agreed price
100      * @return tokenId generated StickerPack token
101      */
102     function buyToken(
103         uint256 _packId,
104         address _destination,
105         uint256 _price
106     )
107         external
108         returns (uint256 tokenId);
109 
110     /**
111      * @dev emits StickerMarket.Register(`packId`, `_urlHash`, `_price`, `_contenthash`)
112      * @notice Registers to sell a sticker pack
113      * @param _price cost in wei to users minting this pack
114      * @param _donate value between 0-10000 representing percentage of `_price` that is donated to StickerMarket at every buy
115      * @param _category listing category
116      * @param _owner address of the beneficiary of buys
117      * @param _contenthash EIP1577 pack contenthash for listings
118      * @param _fee Fee msg.sender agrees to pay for this registration
119      * @return packId Market position of Sticker Pack data.
120      */
121     function registerPack(
122         uint256 _price,
123         uint256 _donate,
124         bytes4[] calldata _category,
125         address _owner,
126         bytes calldata _contenthash,
127         uint256 _fee
128     )
129         external
130         returns(uint256 packId);
131 
132 }
133 
134 
135 
136 /**
137  * @dev ERC-721 non-fungible token standard. 
138  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
139  */
140 interface ERC721
141 {
142 
143   /**
144    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
145    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
146    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
147    * transfer, the approved address for that NFT (if any) is reset to none.
148    */
149   event Transfer(
150     address indexed from,
151     address indexed to,
152     uint256 indexed value
153   );
154 
155   /**
156    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
157    * address indicates there is no approved address. When a Transfer event emits, this also
158    * indicates that the approved address for that NFT (if any) is reset to none.
159    */
160   event Approval(
161     address indexed _owner,
162     address indexed _approved,
163     uint256 indexed _tokenId
164   );
165 
166   /**
167    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
168    * all NFTs of the owner.
169    */
170   event ApprovalForAll(
171     address indexed _owner,
172     address indexed _operator,
173     bool _approved
174   );
175 
176   /**
177    * @dev Transfers the ownership of an NFT from one address to another address.
178    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
179    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
180    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
181    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
182    * `onERC721Received` on `_to` and throws if the return value is not 
183    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
184    * @param _from The current owner of the NFT.
185    * @param _to The new owner.
186    * @param _tokenId The NFT to transfer.
187    * @param _data Additional data with no specified format, sent in call to `_to`.
188    */
189   function safeTransferFrom(
190     address _from,
191     address _to,
192     uint256 _tokenId,
193     bytes calldata _data
194   )
195     external;
196 
197   /**
198    * @dev Transfers the ownership of an NFT from one address to another address.
199    * @notice This works identically to the other function with an extra data parameter, except this
200    * function just sets data to ""
201    * @param _from The current owner of the NFT.
202    * @param _to The new owner.
203    * @param _tokenId The NFT to transfer.
204    */
205   function safeTransferFrom(
206     address _from,
207     address _to,
208     uint256 _tokenId
209   )
210     external;
211 
212   /**
213    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
214    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
215    * address. Throws if `_tokenId` is not a valid NFT.
216    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
217    * they mayb be permanently lost.
218    * @param _from The current owner of the NFT.
219    * @param _to The new owner.
220    * @param _tokenId The NFT to transfer.
221    */
222   function transferFrom(
223     address _from,
224     address _to,
225     uint256 _tokenId
226   )
227     external;
228 
229   /**
230    * @dev Set or reaffirm the approved address for an NFT.
231    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
232    * the current NFT owner, or an authorized operator of the current owner.
233    * @param _approved The new approved NFT controller.
234    * @param _tokenId The NFT to approve.
235    */
236   function approve(
237     address _approved,
238     uint256 _tokenId
239   )
240     external;
241 
242   /**
243    * @dev Enables or disables approval for a third party ("operator") to manage all of
244    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
245    * @notice The contract MUST allow multiple operators per owner.
246    * @param _operator Address to add to the set of authorized operators.
247    * @param _approved True if the operators is approved, false to revoke approval.
248    */
249   function setApprovalForAll(
250     address _operator,
251     bool _approved
252   )
253     external;
254 
255   /**
256    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
257    * considered invalid, and this function throws for queries about the zero address.
258    * @param _owner Address for whom to query the balance.
259    * @return Balance of _owner.
260    */
261   function balanceOf(
262     address _owner
263   )
264     external
265     view
266     returns (uint256);
267 
268   /**
269    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
270    * invalid, and queries about them do throw.
271    * @param _tokenId The identifier for an NFT.
272    * @return Address of _tokenId owner.
273    */
274   function ownerOf(
275     uint256 _tokenId
276   )
277     external
278     view
279     returns (address);
280     
281   /**
282    * @dev Get the approved address for a single NFT.
283    * @notice Throws if `_tokenId` is not a valid NFT.
284    * @param _tokenId The NFT to find the approved address for.
285    * @return Address that _tokenId is approved for. 
286    */
287   function getApproved(
288     uint256 _tokenId
289   )
290     external
291     view
292     returns (address);
293 
294   /**
295    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
296    * @param _owner The address that owns the NFTs.
297    * @param _operator The address that acts on behalf of the owner.
298    * @return True if approved for all, false otherwise.
299    */
300   function isApprovedForAll(
301     address _owner,
302     address _operator
303   )
304     external
305     view
306     returns (bool);
307 
308 }
309 
310 
311 
312 /**
313  * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
314  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
315  */
316 interface ERC721Enumerable
317 {
318 
319   /**
320    * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
321    * assigned and queryable owner not equal to the zero address.
322    * @return Total supply of NFTs.
323    */
324   function totalSupply()
325     external
326     view
327     returns (uint256);
328 
329   /**
330    * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
331    * @param _index A counter less than `totalSupply()`.
332    * @return Token id.
333    */
334   function tokenByIndex(
335     uint256 _index
336   )
337     external
338     view
339     returns (uint256);
340 
341   /**
342    * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
343    * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
344    * representing invalid NFTs.
345    * @param _owner An address where we are interested in NFTs owned by them.
346    * @param _index A counter less than `balanceOf(_owner)`.
347    * @return Token id.
348    */
349   function tokenOfOwnerByIndex(
350     address _owner,
351     uint256 _index
352   )
353     external
354     view
355     returns (uint256);
356 
357 }
358 
359 
360 /**
361  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
362  * @notice interface for StickerType
363  */
364 /* interface */ abstract contract StickerType is ERC721, ERC721Enumerable { // Interfaces can't inherit
365 
366     /**
367      * @notice controller can generate packs at will
368      * @param _price cost in wei to users minting with _urlHash metadata
369      * @param _donate optional amount of `_price` that is donated to StickerMarket at every buy
370      * @param _category listing category
371      * @param _owner address of the beneficiary of buys
372      * @param _contenthash EIP1577 pack contenthash for listings
373      * @return packId Market position of Sticker Pack data.
374      */
375     function generatePack(
376         uint256 _price,
377         uint256 _donate,
378         bytes4[] calldata _category,
379         address _owner,
380         bytes calldata _contenthash
381     )
382         external
383         virtual
384         returns(uint256 packId);
385 
386     /**
387      * @notice removes all market data about a marketed pack, can only be called by market controller
388      * @param _packId position to be deleted
389      * @param _limit limit of categories to cleanup
390      */
391     function purgePack(uint256 _packId, uint256 _limit)
392         external
393         virtual;
394 
395     /**
396      * @notice changes contenthash of `_packId`, can only be called by controller
397      * @param _packId which market position is being altered
398      * @param _contenthash new contenthash
399      */
400     function setPackContenthash(uint256 _packId, bytes calldata _contenthash)
401         external
402         virtual;
403 
404     /**
405      * @notice This method can be used by the controller to extract mistakenly
406      *  sent tokens to this contract.
407      * @param _token The address of the token contract that you want to recover
408      *  set to 0 in case you want to extract ether.
409      */
410     function claimTokens(address _token)
411         external
412         virtual;
413 
414     /**
415      * @notice changes price of `_packId`, can only be called when market is open
416      * @param _packId pack id changing price settings
417      * @param _price cost in wei to users minting this pack
418      * @param _donate value between 0-10000 representing percentage of `_price` that is donated to StickerMarket at every buy
419      */
420     function setPackPrice(uint256 _packId, uint256 _price, uint256 _donate)
421         external
422         virtual;
423 
424     /**
425      * @notice add caregory in `_packId`, can only be called when market is open
426      * @param _packId pack adding category
427      * @param _category category to list
428      */
429     function addPackCategory(uint256 _packId, bytes4 _category)
430         external
431         virtual;
432 
433     /**
434      * @notice remove caregory in `_packId`, can only be called when market is open
435      * @param _packId pack removing category
436      * @param _category category to unlist
437      */
438     function removePackCategory(uint256 _packId, bytes4 _category)
439         external
440         virtual;
441 
442     /**
443      * @notice Changes if pack is enabled for sell
444      * @param _packId position edit
445      * @param _mintable true to enable sell
446      */
447     function setPackState(uint256 _packId, bool _mintable)
448         external
449         virtual;
450 
451     /**
452      * @notice read available market ids in a category (might be slow)
453      * @param _category listing category
454      * @return availableIds array of market id registered
455      */
456     function getAvailablePacks(bytes4 _category)
457         external
458         virtual
459         view
460         returns (uint256[] memory availableIds);
461 
462     /**
463      * @notice count total packs in a category
464      * @param _category listing category
465      * @return size total number of packs in category
466      */
467     function getCategoryLength(bytes4 _category)
468         external
469         virtual
470         view
471         returns (uint256 size);
472 
473     /**
474      * @notice read a packId in the category list at a specific index
475      * @param _category listing category
476      * @param _index index
477      * @return packId on index
478      */
479     function getCategoryPack(bytes4 _category, uint256 _index)
480         external
481         virtual
482         view
483         returns (uint256 packId);
484 
485     /**
486      * @notice returns all data from pack in market
487      * @param _packId pack id being queried
488      * @return category list of categories registered to this packType
489      * @return owner authorship holder
490      * @return mintable new pack can be generated (rare tool)
491      * @return timestamp registration timestamp
492      * @return price current price
493      * @return contenthash EIP1577 encoded hash
494      */
495     function getPackData(uint256 _packId)
496         external
497         virtual
498         view
499         returns (
500             bytes4[] memory category,
501             address owner,
502             bool mintable,
503             uint256 timestamp,
504             uint256 price,
505             bytes memory contenthash
506         );
507 
508     /**
509      * @notice returns all data from pack in market
510      * @param _packId pack id being queried
511      * @return category list of categories registered to this packType
512      * @return timestamp registration timestamp
513      * @return contenthash EIP1577 encoded hash
514      */
515     function getPackSummary(uint256 _packId)
516         external
517         virtual
518         view
519         returns (
520             bytes4[] memory category,
521             uint256 timestamp,
522             bytes memory contenthash
523         );
524 
525     /**
526      * @notice returns payment data for migrated contract
527      * @param _packId pack id being queried
528      * @return owner authorship holder
529      * @return mintable new pack can be generated (rare tool)
530      * @return price current price
531      * @return donate informational value between 0-10000 representing percentage of `price` that is donated to StickerMarket at every buy
532      */
533     function getPaymentData(uint256 _packId)
534         external
535         virtual
536         view
537         returns (
538             address owner,
539             bool mintable,
540             uint256 price,
541             uint256 donate
542         );
543    
544 }
545 
546 
547 
548 
549 /**
550  * @title SafeERC20
551  * @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
552  * and https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
553  */
554 contract SafeTransfer {
555     
556     function _safeTransfer(ERC20Token token, address to, uint256 value) internal {
557         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
558     }
559 
560     function _safeTransferFrom(ERC20Token token, address from, address to, uint256 value) internal {
561         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
562     }
563     
564     /**
565      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
566      * on the return value: the return value is optional (but if data is returned, it must not be false).
567      * @param token The token targeted by the call.
568      * @param data The call data (encoded using abi.encode or one of its variants).
569      */
570     function _callOptionalReturn(ERC20Token token, bytes memory data) private {
571         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
572         // we're implementing it ourselves.
573 
574         // A Solidity high level call has three parts:
575         //  1. The target address is checked to verify it contains contract code
576         //  2. The call itself is made, and success asserted
577         //  3. The return value is decoded, which in turn checks the size of the returned data.
578         // solhint-disable-next-line max-line-length
579         require(_isContract(address(token)), "SafeTransfer: call to non-contract");
580 
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success, bytes memory returndata) = address(token).call(data);
583         require(success, "SafeTransfer: low-level call failed");
584 
585         if (returndata.length > 0) { // Return data is optional
586             // solhint-disable-next-line max-line-length
587             require(abi.decode(returndata, (bool)), "SafeTransfer: ERC20 operation did not succeed");
588         }
589     }
590 
591     /**
592      * @dev Returns true if `account` is a contract.
593      *
594      * [IMPORTANT]
595      * ====
596      * It is unsafe to assume that an address for which this function returns
597      * false is an externally-owned account (EOA) and not a contract.
598      *
599      * Among others, `isContract` will return false for the following
600      * types of addresses:
601      *
602      *  - an externally-owned account
603      *  - a contract in construction
604      *  - an address where a contract will be created
605      *  - an address where a contract lived, but was destroyed
606      * ====
607      */
608     function _isContract(address account) internal view returns (bool) {
609         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
610         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
611         // for accounts without code, i.e. `keccak256('')`
612         bytes32 codehash;
613         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
614         // solhint-disable-next-line no-inline-assembly
615         assembly { codehash := extcodehash(account) }
616         return (codehash != accountHash && codehash != 0x0);
617     }
618 }
619 
620 
621 
622 
623 
624 
625 
626 /**
627  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
628  * @notice Owner's backdoor withdrawal logic, used for code reuse.
629  */
630 contract TokenWithdrawer is SafeTransfer {
631     /**
632      * @dev Withdraw all balance of each `_tokens` into `_destination`.
633      * @param _tokens address of ERC20 token, or zero for withdrawing ETH.
634      * @param _destination receiver of token
635      */
636     function withdrawTokens(
637         address[] memory _tokens,
638         address payable _destination
639     )
640         internal
641     {
642         uint len = _tokens.length;
643         for(uint i = 0; i < len; i++){
644             withdrawToken(_tokens[i], _destination);
645         }
646     }
647 
648     /**
649      * @dev Withdraw all balance of `_token` into `_destination`.
650      * @param _token address of ERC20 token, or zero for withdrawing ETH.
651      * @param _destination receiver of token
652      */
653     function withdrawToken(address _token, address payable _destination)
654         internal
655     {
656         uint256 balance;
657         if (_token == address(0)) {
658             balance = address(this).balance;
659             (bool success, ) = _destination.call.value(balance)("");
660             require(success, "Transfer failed");
661         } else {
662             ERC20Token token = ERC20Token(_token);
663             balance = token.balanceOf(address(this));
664             _safeTransfer(token, _destination, balance);
665         }
666     }
667 }
668 
669 
670 /// @title Starterpack Distributor
671 /// @notice Attempts to deliver 1 and only 1 starterpack containing ETH, ERC20 Tokens and NFT Stickerpacks to an eligible recipient
672 /// @dev The contract assumes Signer has verified an In-App Purchase Receipt
673 contract SimplifiedDistributor is SafeTransfer, ReentrancyGuard, TokenWithdrawer {
674     address payable public owner;  // Contract deployer can modify parameters
675     address public signer; // Signer can only distribute Starterpacks
676 
677     // Defines the Starterpack parameters
678     struct Pack {
679         uint256 ethAmount; // The Amount of ETH to transfer to the recipient
680         address[] tokens; // Array of ERC20 Contract Addresses
681         uint256[] tokenAmounts; // Array of ERC20 amounts corresponding to cells in tokens[]
682     }
683 
684     Pack public defaultPack;
685 
686     ERC20Token public sntToken;
687 
688     bool public pause = true;
689     
690     event RequireApproval(address attribution);
691     
692     mapping(address => uint) public pendingAttributionCnt;
693     mapping(address => uint) public attributionCnt;
694     
695     struct Attribution {
696         bool enabled;
697         uint256 ethAmount; // The Amount of ETH to transfer to the referrer
698         address[] tokens; // Array of ERC20 Contract Addresses
699         uint256[] tokenAmounts; // Array of ERC20 amounts corresponding to cells in tokens[]
700         uint limit;
701     }
702     
703     mapping(address => Attribution) defaultAttributionSettings;
704     mapping(address => Attribution) promoAttributionSettings;
705 
706     // Modifiers --------------------------------------------------------------------------------------------
707 
708     // Functions only Owner can call
709     modifier onlyOwner {
710         require(msg.sender == owner, "Unauthorized");
711         _;
712     }
713 
714     // Logic ------------------------------------------------------------------------------------------------
715 
716     /// @notice Check if an address is eligible for a starterpack
717     /// @dev will return false if a transaction of distributePack for _recipient has been successfully executed
718     ///      RETURNING TRUE BECAUSE ELIGIBILITY WILL BE HANDLED BY THE BACKEND
719     /// @param _recipient The address to be checked for eligibility
720     function eligible(address _recipient) public view returns (bool){
721         return true;
722     }
723 
724     /// @notice Get the starter pack configuration
725     /// @return stickerMarket address Stickermarket contract address
726     /// @return ethAmount uint256 ETH amount in wei that will be sent to a recipient
727     /// @return tokens address[] List of tokens that will be sent to a recipient
728     /// @return tokenAmounts uint[] Amount of tokens that will be sent to a recipient
729     /// @return stickerPackIds uint[] List of sticker packs to send to a recipient
730     function getDefaultPack() external view returns(address stickerMarket, uint256 ethAmount, address[] memory tokens, uint[] memory tokenAmounts, uint[] memory stickerPackIds) {
731         ethAmount = defaultPack.ethAmount;
732         tokens = defaultPack.tokens;
733         tokenAmounts = defaultPack.tokenAmounts;
734     }
735 
736     /// @notice Get the promo pack configuration
737     /// @return stickerMarket address Stickermarket contract address
738     /// @return ethAmount uint256 ETH amount in wei that will be sent to a recipient
739     /// @return tokens address[] List of tokens that will be sent to a recipient
740     /// @return tokenAmounts uint[] Amount of tokens that will be sent to a recipient
741     /// @return stickerPackIds uint[] List of sticker packs to send to a recipient
742     /// @return available uint number of promo packs available
743     function getPromoPack() external view returns(address stickerMarket, uint256 ethAmount, address[] memory tokens, uint[] memory tokenAmounts, uint[] memory stickerPackIds, uint256 available) {
744         // Removed the promo pack functionality, so returning default values (to not affect the ABI)
745     }
746 
747     event Distributed(address indexed recipient, address indexed attribution);
748 
749     /// @notice Distributes a starterpack to an eligible address. Either a promo pack or a default will be distributed depending on availability
750     /// @dev Can only be called by signer, assumes signer has validated an IAP receipt, owner can block calling by pausing.
751     /// @param _recipient A payable address that is sent a starterpack after being checked for eligibility
752     /// @param _attribution A payable address who referred the starterpack purchaser 
753     function distributePack(address payable _recipient, address payable _attribution) external reentrancyGuard {
754         require(!pause, "Paused");
755         require(msg.sender == signer, "Unauthorized");
756         require(_recipient != _attribution, "Recipient should be different from Attribution address");
757 
758         Pack memory pack = defaultPack;
759 
760         // Transfer Tokens
761         // Iterate over tokens[] and transfer the an amount corresponding to the i cell in tokenAmounts[]
762         for (uint256 i = 0; i < pack.tokens.length; i++) {
763             ERC20Token token = ERC20Token(pack.tokens[i]);
764             uint256 amount = pack.tokenAmounts[i];
765             require(token.transfer(_recipient, amount), "ERC20 operation did not succeed");
766         }
767 
768         // Transfer ETH
769         // .transfer bad post Istanbul fork :|
770         (bool success, ) = _recipient.call.value(pack.ethAmount)("");
771         require(success, "ETH Transfer failed");
772 
773         emit Distributed(_recipient, _attribution);
774 
775         if (_attribution == address(0)) return;
776         
777         pendingAttributionCnt[_attribution] += 1;
778     }
779 
780     function withdrawAttributions() external {
781         require(!pause, "Paused");
782         
783         uint pendingAttributions = pendingAttributionCnt[msg.sender];
784         uint attributionsPaid = attributionCnt[msg.sender];
785 
786         if (pendingAttributions == 0) return;
787 
788         Attribution memory attr = defaultAttributionSettings[msg.sender];
789         if (!attr.enabled) {
790            attr = defaultAttributionSettings[address(0)];
791         }
792 
793         uint totalETHToPay;
794         uint totalSNTToPay;
795         uint attributionsToPay;
796         if((attributionsPaid + pendingAttributions) > attr.limit){
797             emit RequireApproval(msg.sender);
798             if(attributionsPaid < attr.limit){
799                 attributionsToPay = attr.limit - attributionsPaid;
800             } else {
801                 attributionsToPay = 0;
802             }
803             attributionsPaid += attributionsToPay;
804             pendingAttributions -= attributionsToPay;
805         } else {
806             attributionsToPay = pendingAttributions;
807             attributionsPaid += attributionsToPay;
808             pendingAttributions = 0;
809         }
810 
811         totalETHToPay += attributionsToPay * attr.ethAmount;
812 
813         for (uint256 i = 0; i < attr.tokens.length; i++) {
814             if(attr.tokens[i] == address(sntToken)){
815                 totalSNTToPay += attributionsToPay * attr.tokenAmounts[i];
816             } else {
817                 ERC20Token token = ERC20Token(attr.tokens[i]);
818                 uint256 amount = attributionsToPay * attr.tokenAmounts[i];
819                 _safeTransfer(token, msg.sender, amount);
820             }
821         }
822 
823         pendingAttributionCnt[msg.sender] = pendingAttributions;
824         attributionCnt[msg.sender] = attributionsPaid;
825 
826         if (totalETHToPay != 0){
827             
828             (bool success, ) = msg.sender.call.value(totalETHToPay)("");
829             require(success, "ETH Transfer failed");
830         }
831 
832         if (totalSNTToPay != 0){
833             ERC20Token token = ERC20Token(sntToken);
834             _safeTransfer(token, msg.sender, totalSNTToPay);
835         }
836     }
837     
838 
839     /// @notice Get rewards for specific referrer
840     /// @param _account The address to obtain the attribution config
841     /// @param _isPromo Indicates if the configuration for a promo should be returned or not
842     /// @return ethAmount Amount of ETH in wei
843     /// @return tokenLen Number of tokens configured as part of the reward
844     /// @return maxThreshold If isPromo == true: Number of promo bonuses still available for that address else: Max number of attributions to pay before requiring approval
845     /// @return attribCount Number of referrals
846     function getReferralReward(address _account, bool _isPromo) public view returns (uint ethAmount, uint tokenLen, uint maxThreshold, uint attribCount) {
847         require(_isPromo != true);
848         Attribution memory attr = defaultAttributionSettings[_account];
849         if (!attr.enabled) {
850             attr = defaultAttributionSettings[address(0)];
851         }
852         
853         ethAmount = attr.ethAmount;
854         maxThreshold = attr.limit;
855         attribCount = attributionCnt[_account];
856         tokenLen = attr.tokens.length;
857     }
858 
859     /// @notice Get token rewards for specific address
860     /// @param _account The address to obtain the attribution's token config
861     /// @param _isPromo Indicates if the configuration for a promo should be returned or not
862     /// @param _idx Index of token array in the attribution used to obtain the token config
863     /// @return token ERC20 contract address
864     /// @return tokenAmount Amount of token configured in the attribution
865     function getReferralRewardTokens(address _account, bool _isPromo, uint _idx) public view returns (address token, uint tokenAmount) {
866         require(_isPromo != true);
867         Attribution memory attr = defaultAttributionSettings[_account];
868         if (!attr.enabled) {
869             attr = defaultAttributionSettings[address(0)];
870         }
871         
872         token = attr.tokens[_idx];
873         tokenAmount = attr.tokenAmounts[_idx];
874     }
875     
876     fallback() external payable  {
877      // ...
878     }
879     
880     // Admin ------------------------------------------------------------------------------------------------
881 
882     /// @notice Allows the Owner to allow or prohibit Signer from calling distributePack().
883     /// @dev setPause must be called before Signer can call distributePack()
884     function setPause(bool _pause) external onlyOwner {
885         pause = _pause;
886     }
887 
888     /// @notice Set a starter pack configuration
889     /// @dev The Owner can change the default starterpack contents
890     /// @param _newPack starter pack configuration
891     function changeStarterPack(Pack memory _newPack) public onlyOwner {
892         require(_newPack.tokens.length == _newPack.tokenAmounts.length, "Mismatch with Tokens & Amounts");
893 
894         for (uint256 i = 0; i < _newPack.tokens.length; i++) {
895             require(_newPack.tokenAmounts[i] > 0, "Amounts must be non-zero");
896         }
897 
898         defaultPack = _newPack;
899     }
900 
901     /// @notice Safety function allowing the owner to immediately pause starterpack distribution and withdraw all balances in the the contract
902     function withdraw(address[] calldata _tokens) external onlyOwner {
903         pause = true;
904         withdrawTokens(_tokens, owner);
905     }
906 
907     /// @notice Changes the Signer of the contract
908     /// @param _newSigner The new Signer of the contract
909     function changeSigner(address _newSigner) public onlyOwner {
910         require(_newSigner != address(0), "zero_address not allowed");
911         signer = _newSigner;
912     }
913 
914     /// @notice Changes the owner of the contract
915     /// @param _newOwner The new owner of the contract
916     function changeOwner(address payable _newOwner) external onlyOwner {
917         require(_newOwner != address(0), "zero_address not allowed");
918         owner = _newOwner;
919     }
920     
921     /// @notice Set default/custom payout and threshold for referrals
922     /// @param _isPromo indicates if this attribution config is a promo or default config
923     /// @param _ethAmount Payout for referrals
924     /// @param _thresholds Max number of referrals allowed beforee requiring approval
925     /// @param _assignedTo Use a valid address here to set custom settings. To set the default payout and threshold, use address(0);
926     function setPayoutAndThreshold(
927         bool _isPromo,
928         uint256 _ethAmount,
929         address[] calldata _tokens,
930         uint256[] calldata _tokenAmounts,
931         uint256[] calldata _thresholds,
932         address[] calldata _assignedTo
933     ) external onlyOwner {
934         require(_isPromo != true);
935 
936         require(_thresholds.length == _assignedTo.length, "Array length mismatch");
937         require(_tokens.length == _tokenAmounts.length, "Array length mismatch");
938         
939         for (uint256 i = 0; i < _thresholds.length; i++) {
940             bool enabled = _assignedTo[i] != address(0);
941             
942             Attribution memory attr = Attribution({
943                 enabled: enabled,
944                 ethAmount: _ethAmount,
945                 limit: _thresholds[i],
946                 tokens: _tokens,
947                 tokenAmounts: _tokenAmounts
948             });
949             
950             defaultAttributionSettings[_assignedTo[i]] = attr;
951         }
952     }
953     
954     /// @notice Remove attribution configuration for addresses
955     /// @param _assignedTo Array of addresses with an attribution configured
956     /// @param _isPromo Indicates if the configuration to delete is the promo or default
957     function removePayoutAndThreshold(address[] calldata _assignedTo, bool _isPromo) external onlyOwner {
958         for (uint256 i = 0; i < _assignedTo.length; i++) {
959             delete defaultAttributionSettings[_assignedTo[i]];
960         }
961     }
962 
963     /// @notice Set SNT address
964     function setSntToken(address _sntToken) external onlyOwner {
965         sntToken = ERC20Token(_sntToken);
966     }
967 
968     /// @param _signer allows the contract deployer(owner) to define the signer on construction
969     /// @param _sntToken SNT token address
970     constructor(address _signer, address _sntToken) public {
971         require(_signer != address(0), "zero_address not allowed");
972         owner = msg.sender;
973         signer = _signer;
974         sntToken = ERC20Token(_sntToken);
975     }
976 }
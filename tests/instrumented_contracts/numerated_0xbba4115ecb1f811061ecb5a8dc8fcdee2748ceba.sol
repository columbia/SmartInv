1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 /**
5 @title Voting Escrow
6 @author Curve Finance
7 @license MIT
8 @notice Votes have a weight depending on time, so that users are
9 committed to the future of (whatever they are voting for)
10 @dev Vote weight decays linearly over time. Lock time cannot be
11 more than `MAXTIME` (4 years).
12 
13 # Voting escrow to have time-weighted votes
14 # Votes have a weight depending on time, so that users are committed
15 # to the future of (whatever they are voting for).
16 # The weight in this implementation is linear, and lock cannot be more than maxtime:
17 # w ^
18 # 1 +        /
19 #   |      /
20 #   |    /
21 #   |  /
22 #   |/
23 # 0 +--------+------> time
24 #       maxtime (4 years?)
25 */
26 
27 /// [MIT License]
28 /// @title Base64
29 /// @notice Provides a function for encoding some bytes in base64
30 /// @author Brecht Devos <brecht@loopring.org>
31 library Base64 {
32     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
33 
34     /// @notice Encodes some bytes to the base64 representation
35     function encode(bytes memory data) internal pure returns (string memory) {
36         uint len = data.length;
37         if (len == 0) return "";
38 
39         // multiply by 4/3 rounded up
40         uint encodedLen = 4 * ((len + 2) / 3);
41 
42         // Add some extra buffer at the end
43         bytes memory result = new bytes(encodedLen + 32);
44 
45         bytes memory table = TABLE;
46 
47         assembly {
48             let tablePtr := add(table, 1)
49             let resultPtr := add(result, 32)
50 
51             for {
52                 let i := 0
53             } lt(i, len) {
54 
55             } {
56                 i := add(i, 3)
57                 let input := and(mload(add(data, i)), 0xffffff)
58 
59                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
60                 out := shl(8, out)
61                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
62                 out := shl(8, out)
63                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
64                 out := shl(8, out)
65                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
66                 out := shl(224, out)
67 
68                 mstore(resultPtr, out)
69 
70                 resultPtr := add(resultPtr, 4)
71             }
72 
73             switch mod(len, 3)
74             case 1 {
75                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
76             }
77             case 2 {
78                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
79             }
80 
81             mstore(result, encodedLen)
82         }
83 
84         return string(result);
85     }
86 }
87 
88 /**
89 * @dev Interface of the ERC165 standard, as defined in the
90 * https://eips.ethereum.org/EIPS/eip-165[EIP].
91 *
92 * Implementers can declare support of contract interfaces, which can then be
93 * queried by others ({ERC165Checker}).
94 *
95 * For an implementation, see {ERC165}.
96 */
97 interface IERC165 {
98     /**
99     * @dev Returns true if this contract implements the interface defined by
100     * `interfaceId`. See the corresponding
101     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
102     * to learn more about how these ids are created.
103     *
104     * This function call must use less than 30 000 gas.
105     */
106     function supportsInterface(bytes4 interfaceId) external view returns (bool);
107 }
108 
109 /**
110 * @dev Required interface of an ERC721 compliant contract.
111 */
112 interface IERC721 is IERC165 {
113     /**
114     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
115     */
116     event Transfer(address indexed from, address indexed to, uint indexed tokenId);
117 
118     /**
119     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
120     */
121     event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
122 
123     /**
124     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
125     */
126     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
127 
128     /**
129     * @dev Returns the number of tokens in ``owner``'s account.
130     */
131     function balanceOf(address owner) external view returns (uint balance);
132 
133     /**
134     * @dev Returns the owner of the `tokenId` token.
135     *
136     * Requirements:
137     *
138     * - `tokenId` must exist.
139     */
140     function ownerOf(uint tokenId) external view returns (address owner);
141 
142     /**
143     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
144     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
145     *
146     * Requirements:
147     *
148     * - `from` cannot be the zero address.
149     * - `to` cannot be the zero address.
150     * - `tokenId` token must exist and be owned by `from`.
151     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
152     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153     *
154     * Emits a {Transfer} event.
155     */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint tokenId
160     ) external;
161 
162     /**
163     * @dev Transfers `tokenId` token from `from` to `to`.
164     *
165     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
166     *
167     * Requirements:
168     *
169     * - `from` cannot be the zero address.
170     * - `to` cannot be the zero address.
171     * - `tokenId` token must be owned by `from`.
172     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173     *
174     * Emits a {Transfer} event.
175     */
176     function transferFrom(
177         address from,
178         address to,
179         uint tokenId
180     ) external;
181 
182     /**
183     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
184     * The approval is cleared when the token is transferred.
185     *
186     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
187     *
188     * Requirements:
189     *
190     * - The caller must own the token or be an approved operator.
191     * - `tokenId` must exist.
192     *
193     * Emits an {Approval} event.
194     */
195     function approve(address to, uint tokenId) external;
196 
197     /**
198     * @dev Returns the account approved for `tokenId` token.
199     *
200     * Requirements:
201     *
202     * - `tokenId` must exist.
203     */
204     function getApproved(uint tokenId) external view returns (address operator);
205 
206     /**
207     * @dev Approve or remove `operator` as an operator for the caller.
208     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
209     *
210     * Requirements:
211     *
212     * - The `operator` cannot be the caller.
213     *
214     * Emits an {ApprovalForAll} event.
215     */
216     function setApprovalForAll(address operator, bool _approved) external;
217 
218     /**
219     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
220     *
221     * See {setApprovalForAll}
222     */
223     function isApprovedForAll(address owner, address operator) external view returns (bool);
224 
225     /**
226     * @dev Safely transfers `tokenId` token from `from` to `to`.
227     *
228     * Requirements:
229     *
230     * - `from` cannot be the zero address.
231     * - `to` cannot be the zero address.
232     * - `tokenId` token must exist and be owned by `from`.
233     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
234     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
235     *
236     * Emits a {Transfer} event.
237     */
238     function safeTransferFrom(
239         address from,
240         address to,
241         uint tokenId,
242         bytes calldata data
243     ) external;
244 }
245 
246 /**
247 * @title ERC721 token receiver interface
248 * @dev Interface for any contract that wants to support safeTransfers
249 * from ERC721 asset contracts.
250 */
251 interface IERC721Receiver {
252     /**
253     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254     * by `operator` from `from`, this function is called.
255     *
256     * It must return its Solidity selector to confirm the token transfer.
257     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258     *
259     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
260     */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 /**
270 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
271 * @dev See https://eips.ethereum.org/EIPS/eip-721
272 */
273 interface IERC721Metadata is IERC721 {
274     /**
275     * @dev Returns the token collection name.
276     */
277     function name() external view returns (string memory);
278 
279     /**
280     * @dev Returns the token collection symbol.
281     */
282     function symbol() external view returns (string memory);
283 
284     /**
285     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286     */
287     function tokenURI(uint tokenId) external view returns (string memory);
288 }
289 
290 /**
291 * @dev Interface of the ERC20 standard as defined in the EIP.
292 */
293 interface IERC20 {
294     /**
295     * @dev Moves `amount` tokens from the caller's account to `recipient`.
296     *
297     * Returns a boolean value indicating whether the operation succeeded.
298     *
299     * Emits a {Transfer} event.
300     */
301     function transfer(address recipient, uint amount) external returns (bool);
302 
303     /**
304     * @dev Moves `amount` tokens from `sender` to `recipient` using the
305     * allowance mechanism. `amount` is then deducted from the caller's
306     * allowance.
307     *
308     * Returns a boolean value indicating whether the operation succeeded.
309     *
310     * Emits a {Transfer} event.
311     */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint amount
316     ) external returns (bool);
317 }
318 
319 struct Point {
320     int128 bias;
321     int128 slope; // # -dweight / dt
322     uint ts;
323     uint blk; // block
324 }
325 /* We cannot really do block numbers per se b/c slope is per time, not per block
326 * and per block could be fairly bad b/c Ethereum changes blocktimes.
327 * What we can do is to extrapolate ***At functions */
328 
329 struct LockedBalance {
330     int128 amount;
331     uint end;
332 }
333 
334 contract ve is IERC721, IERC721Metadata {
335     enum DepositType {
336         DEPOSIT_FOR_TYPE,
337         CREATE_LOCK_TYPE,
338         INCREASE_LOCK_AMOUNT,
339         INCREASE_UNLOCK_TIME,
340         MERGE_TYPE
341     }
342 
343     event Deposit(
344         address indexed provider,
345         uint tokenId,
346         uint value,
347         uint indexed locktime,
348         DepositType deposit_type,
349         uint ts
350     );
351     event Withdraw(address indexed provider, uint tokenId, uint value, uint ts);
352     event Supply(uint prevSupply, uint supply);
353 
354     uint internal constant WEEK = 1 weeks;
355     uint internal constant MAXTIME = 4 * 365 * 86400;
356     int128 internal constant iMAXTIME = 4 * 365 * 86400;
357     uint internal constant MULTIPLIER = 1 ether;
358 
359     address immutable public token;
360     uint public supply;
361     uint public nftSupply;
362     mapping(uint => LockedBalance) public locked;
363 
364     mapping(uint => uint) public ownership_change;
365 
366     uint public epoch;
367     mapping(uint => Point) public point_history; // epoch -> unsigned point
368     mapping(uint => Point[1000000000]) public user_point_history; // user -> Point[user_epoch]
369 
370     mapping(uint => uint) public user_point_epoch;
371     mapping(uint => int128) public slope_changes; // time -> signed slope change
372 
373     mapping(uint => uint) public attachments;
374     mapping(uint => bool) public voted;
375     address public voter;
376 
377     string constant public name = "veMULTI NFT";
378     string constant public symbol = "veMULTI";
379     string constant public version = "1.0.0";
380     uint8 constant public decimals = 18;
381 
382     /// @dev Current count of token
383     uint internal tokenId;
384 
385     /// @dev Mapping from NFT ID to the address that owns it.
386     mapping(uint => address) internal idToOwner;
387 
388     /// @dev Mapping from NFT ID to approved address.
389     mapping(uint => address) internal idToApprovals;
390 
391     /// @dev Mapping from owner address to count of his tokens.
392     mapping(address => uint) internal ownerToNFTokenCount;
393 
394     /// @dev Mapping from owner address to mapping of index to tokenIds
395     mapping(address => mapping(uint => uint)) internal ownerToNFTokenIdList;
396 
397     /// @dev Mapping from NFT ID to index of owner
398     mapping(uint => uint) internal tokenToOwnerIndex;
399 
400     /// @dev Mapping from owner address to mapping of operator addresses.
401     mapping(address => mapping(address => bool)) internal ownerToOperators;
402 
403     /// @dev Mapping of interface id to bool about whether or not it's supported
404     mapping(bytes4 => bool) internal supportedInterfaces;
405 
406     /// @dev ERC165 interface ID of ERC165
407     bytes4 internal constant ERC165_INTERFACE_ID = 0x01ffc9a7;
408 
409     /// @dev ERC165 interface ID of ERC721
410     bytes4 internal constant ERC721_INTERFACE_ID = 0x80ac58cd;
411 
412     /// @dev ERC165 interface ID of ERC721Metadata
413     bytes4 internal constant ERC721_METADATA_INTERFACE_ID = 0x5b5e139f;
414 
415     /// @dev reentrancy guard
416     uint8 internal constant _not_entered = 1;
417     uint8 internal constant _entered = 2;
418     uint8 internal _entered_state = 1;
419     modifier nonreentrant() {
420         require(_entered_state == _not_entered);
421         _entered_state = _entered;
422         _;
423         _entered_state = _not_entered;
424     }
425 
426     /// @notice Contract constructor
427     /// @param token_addr `ERC20CRV` token address
428     constructor(
429         address token_addr
430     ) {
431         token = token_addr;
432         voter = msg.sender;
433         point_history[0].blk = block.number;
434         point_history[0].ts = block.timestamp;
435 
436         supportedInterfaces[ERC165_INTERFACE_ID] = true;
437         supportedInterfaces[ERC721_INTERFACE_ID] = true;
438         supportedInterfaces[ERC721_METADATA_INTERFACE_ID] = true;
439 
440         // mint-ish
441         emit Transfer(address(0), address(this), tokenId);
442         // burn-ish
443         emit Transfer(address(this), address(0), tokenId);
444     }
445 
446     /// @dev Interface identification is specified in ERC-165.
447     /// @param _interfaceID Id of the interface
448     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
449         return supportedInterfaces[_interfaceID];
450     }
451 
452     /// @notice Get the most recently recorded rate of voting power decrease for `_tokenId`
453     /// @param _tokenId token of the NFT
454     /// @return Value of the slope
455     function get_last_user_slope(uint _tokenId) external view returns (int128) {
456         uint uepoch = user_point_epoch[_tokenId];
457         return user_point_history[_tokenId][uepoch].slope;
458     }
459 
460     /// @notice Get the timestamp for checkpoint `_idx` for `_tokenId`
461     /// @param _tokenId token of the NFT
462     /// @param _idx User epoch number
463     /// @return Epoch time of the checkpoint
464     function user_point_history__ts(uint _tokenId, uint _idx) external view returns (uint) {
465         return user_point_history[_tokenId][_idx].ts;
466     }
467 
468     /// @notice Get timestamp when `_tokenId`'s lock finishes
469     /// @param _tokenId User NFT
470     /// @return Epoch time of the lock end
471     function locked__end(uint _tokenId) external view returns (uint) {
472         return locked[_tokenId].end;
473     }
474 
475     /// @dev Returns the number of NFTs owned by `_owner`.
476     ///      Throws if `_owner` is the zero address. NFTs assigned to the zero address are considered invalid.
477     /// @param _owner Address for whom to query the balance.
478     function _balance(address _owner) internal view returns (uint) {
479         return ownerToNFTokenCount[_owner];
480     }
481 
482     /// @dev Returns the number of NFTs owned by `_owner`.
483     ///      Throws if `_owner` is the zero address. NFTs assigned to the zero address are considered invalid.
484     /// @param _owner Address for whom to query the balance.
485     function balanceOf(address _owner) external view returns (uint) {
486         return _balance(_owner);
487     }
488 
489     function totalNFTSupply() external view returns (uint) {
490         return nftSupply;
491     }
492 
493     /// @dev Returns the address of the owner of the NFT.
494     /// @param _tokenId The identifier for an NFT.
495     function ownerOf(uint _tokenId) public view returns (address) {
496         address owner = idToOwner[_tokenId];
497         require(owner != address(0), "VE NFT: owner query for nonexistent token");
498         return owner;
499     }
500 
501     /// @dev Get the approved address for a single NFT.
502     /// @param _tokenId ID of the NFT to query the approval of.
503     function getApproved(uint _tokenId) external view returns (address) {
504         return idToApprovals[_tokenId];
505     }
506 
507     /// @dev Checks if `_operator` is an approved operator for `_owner`.
508     /// @param _owner The address that owns the NFTs.
509     /// @param _operator The address that acts on behalf of the owner.
510     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
511         return (ownerToOperators[_owner])[_operator];
512     }
513 
514     /// @dev  Get token by index
515     function tokenOfOwnerByIndex(address _owner, uint _tokenIndex) external view returns (uint) {
516         return ownerToNFTokenIdList[_owner][_tokenIndex];
517     }
518 
519     /// @dev Returns whether the given spender can transfer a given token ID
520     /// @param _spender address of the spender to query
521     /// @param _tokenId uint ID of the token to be transferred
522     /// @return bool whether the msg.sender is approved for the given token ID, is an operator of the owner, or is the owner of the token
523     function _isApprovedOrOwner(address _spender, uint _tokenId) internal view returns (bool) {
524         address owner = idToOwner[_tokenId];
525         bool spenderIsOwner = owner == _spender;
526         bool spenderIsApproved = _spender == idToApprovals[_tokenId];
527         bool spenderIsApprovedForAll = (ownerToOperators[owner])[_spender];
528         return spenderIsOwner || spenderIsApproved || spenderIsApprovedForAll;
529     }
530 
531     function isApprovedOrOwner(address _spender, uint _tokenId) external view returns (bool) {
532         return _isApprovedOrOwner(_spender, _tokenId);
533     }
534 
535     /// @dev Add a NFT to an index mapping to a given address
536     /// @param _to address of the receiver
537     /// @param _tokenId uint ID Of the token to be added
538     function _addTokenToOwnerList(address _to, uint _tokenId) internal {
539         uint current_count = _balance(_to);
540 
541         ownerToNFTokenIdList[_to][current_count] = _tokenId;
542         tokenToOwnerIndex[_tokenId] = current_count;
543     }
544 
545     /// @dev Remove a NFT from an index mapping to a given address
546     /// @param _from address of the sender
547     /// @param _tokenId uint ID Of the token to be removed
548     function _removeTokenFromOwnerList(address _from, uint _tokenId) internal {
549         // Delete
550         uint current_count = _balance(_from)-1;
551         uint current_index = tokenToOwnerIndex[_tokenId];
552 
553         if (current_count == current_index) {
554             // update ownerToNFTokenIdList
555             ownerToNFTokenIdList[_from][current_count] = 0;
556             // update tokenToOwnerIndex
557             tokenToOwnerIndex[_tokenId] = 0;
558         } else {
559             uint lastTokenId = ownerToNFTokenIdList[_from][current_count];
560 
561             // Add
562             // update ownerToNFTokenIdList
563             ownerToNFTokenIdList[_from][current_index] = lastTokenId;
564             // update tokenToOwnerIndex
565             tokenToOwnerIndex[lastTokenId] = current_index;
566 
567             // Delete
568             // update ownerToNFTokenIdList
569             ownerToNFTokenIdList[_from][current_count] = 0;
570             // update tokenToOwnerIndex
571             tokenToOwnerIndex[_tokenId] = 0;
572         }
573     }
574 
575     /// @dev Add a NFT to a given address
576     ///      Throws if `_tokenId` is owned by someone.
577     function _addTokenTo(address _to, uint _tokenId) internal {
578         // Throws if `_tokenId` is owned by someone
579         assert(idToOwner[_tokenId] == address(0));
580         // Change the owner
581         idToOwner[_tokenId] = _to;
582         // Update owner token index tracking
583         _addTokenToOwnerList(_to, _tokenId);
584         // Change count tracking
585         ownerToNFTokenCount[_to] += 1;
586     }
587 
588     /// @dev Remove a NFT from a given address
589     ///      Throws if `_from` is not the current owner.
590     function _removeTokenFrom(address _from, uint _tokenId) internal {
591         // Throws if `_from` is not the current owner
592         assert(idToOwner[_tokenId] == _from);
593         // Change the owner
594         idToOwner[_tokenId] = address(0);
595         // Update owner token index tracking
596         _removeTokenFromOwnerList(_from, _tokenId);
597         // Change count tracking
598         ownerToNFTokenCount[_from] -= 1;
599     }
600 
601     /// @dev Clear an approval of a given address
602     ///      Throws if `_owner` is not the current owner.
603     function _clearApproval(address _owner, uint _tokenId) internal {
604         // Throws if `_owner` is not the current owner
605         assert(idToOwner[_tokenId] == _owner);
606         if (idToApprovals[_tokenId] != address(0)) {
607             // Reset approvals
608             idToApprovals[_tokenId] = address(0);
609         }
610     }
611 
612     /// @dev Exeute transfer of a NFT.
613     ///      Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
614     ///      address for this NFT. (NOTE: `msg.sender` not allowed in internal function so pass `_sender`.)
615     ///      Throws if `_to` is the zero address.
616     ///      Throws if `_from` is not the current owner.
617     ///      Throws if `_tokenId` is not a valid NFT.
618     function _transferFrom(
619         address _from,
620         address _to,
621         uint _tokenId,
622         address _sender
623     ) internal {
624         require(attachments[_tokenId] == 0 && !voted[_tokenId], "attached");
625         // Check requirements
626         require(_isApprovedOrOwner(_sender, _tokenId));
627         // Clear approval. Throws if `_from` is not the current owner
628         _clearApproval(_from, _tokenId);
629         // Remove NFT. Throws if `_tokenId` is not a valid NFT
630         _removeTokenFrom(_from, _tokenId);
631         // Add NFT
632         _addTokenTo(_to, _tokenId);
633         // Set the block of ownership transfer (for Flash NFT protection)
634         ownership_change[_tokenId] = block.number;
635         // Log the transfer
636         emit Transfer(_from, _to, _tokenId);
637     }
638 
639     /* TRANSFER FUNCTIONS */
640     /// @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved address for this NFT.
641     ///      Throws if `_from` is not the current owner.
642     ///      Throws if `_to` is the zero address.
643     ///      Throws if `_tokenId` is not a valid NFT.
644     /// @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
645     ///        they maybe be permanently lost.
646     /// @param _from The current owner of the NFT.
647     /// @param _to The new owner.
648     /// @param _tokenId The NFT to transfer.
649     function transferFrom(
650         address _from,
651         address _to,
652         uint _tokenId
653     ) external {
654         _transferFrom(_from, _to, _tokenId, msg.sender);
655     }
656 
657     function _isContract(address account) internal view returns (bool) {
658         // This method relies on extcodesize, which returns 0 for contracts in
659         // construction, since the code is only stored at the end of the
660         // constructor execution.
661         uint size;
662         assembly {
663             size := extcodesize(account)
664         }
665         return size > 0;
666     }
667 
668     /// @dev Transfers the ownership of an NFT from one address to another address.
669     ///      Throws unless `msg.sender` is the current owner, an authorized operator, or the
670     ///      approved address for this NFT.
671     ///      Throws if `_from` is not the current owner.
672     ///      Throws if `_to` is the zero address.
673     ///      Throws if `_tokenId` is not a valid NFT.
674     ///      If `_to` is a smart contract, it calls `onERC721Received` on `_to` and throws if
675     ///      the return value is not `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`.
676     /// @param _from The current owner of the NFT.
677     /// @param _to The new owner.
678     /// @param _tokenId The NFT to transfer.
679     /// @param _data Additional data with no specified format, sent in call to `_to`.
680     function safeTransferFrom(
681         address _from,
682         address _to,
683         uint _tokenId,
684         bytes memory _data
685     ) public {
686         _transferFrom(_from, _to, _tokenId, msg.sender);
687 
688         if (_isContract(_to)) {
689             // Throws if transfer destination is a contract which does not implement 'onERC721Received'
690             try IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) returns (bytes4 retval) {
691                 require(retval == IERC721Receiver.onERC721Received.selector, "ERC721: transfer to non ERC721Receiver implementer");
692             } catch (
693                 bytes memory reason
694             ) {
695                 if (reason.length == 0) {
696                     revert('ERC721: transfer to non ERC721Receiver implementer');
697                 } else {
698                     assembly {
699                         revert(add(32, reason), mload(reason))
700                     }
701                 }
702             }
703         }
704     }
705 
706     /// @dev Transfers the ownership of an NFT from one address to another address.
707     ///      Throws unless `msg.sender` is the current owner, an authorized operator, or the
708     ///      approved address for this NFT.
709     ///      Throws if `_from` is not the current owner.
710     ///      Throws if `_to` is the zero address.
711     ///      Throws if `_tokenId` is not a valid NFT.
712     ///      If `_to` is a smart contract, it calls `onERC721Received` on `_to` and throws if
713     ///      the return value is not `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`.
714     /// @param _from The current owner of the NFT.
715     /// @param _to The new owner.
716     /// @param _tokenId The NFT to transfer.
717     function safeTransferFrom(
718         address _from,
719         address _to,
720         uint _tokenId
721     ) external {
722         safeTransferFrom(_from, _to, _tokenId, '');
723     }
724 
725     /// @dev Set or reaffirm the approved address for an NFT. The zero address indicates there is no approved address.
726     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized operator of the current owner.
727     ///      Throws if `_tokenId` is not a valid NFT. (NOTE: This is not written the EIP)
728     ///      Throws if `_approved` is the current owner. (NOTE: This is not written the EIP)
729     /// @param _approved Address to be approved for the given NFT ID.
730     /// @param _tokenId ID of the token to be approved.
731     function approve(address _approved, uint _tokenId) public {
732         address owner = idToOwner[_tokenId];
733         // Throws if `_tokenId` is not a valid NFT
734         require(owner != address(0));
735         // Throws if `_approved` is the current owner
736         require(_approved != owner);
737         // Check requirements
738         bool senderIsOwner = (idToOwner[_tokenId] == msg.sender);
739         bool senderIsApprovedForAll = (ownerToOperators[owner])[msg.sender];
740         require(senderIsOwner || senderIsApprovedForAll);
741         // Set the approval
742         idToApprovals[_tokenId] = _approved;
743         emit Approval(owner, _approved, _tokenId);
744     }
745 
746     /// @dev Enables or disables approval for a third party ("operator") to manage all of
747     ///      `msg.sender`'s assets. It also emits the ApprovalForAll event.
748     ///      Throws if `_operator` is the `msg.sender`. (NOTE: This is not written the EIP)
749     /// @notice This works even if sender doesn't own any tokens at the time.
750     /// @param _operator Address to add to the set of authorized operators.
751     /// @param _approved True if the operators is approved, false to revoke approval.
752     function setApprovalForAll(address _operator, bool _approved) external {
753         // Throws if `_operator` is the `msg.sender`
754         assert(_operator != msg.sender);
755         ownerToOperators[msg.sender][_operator] = _approved;
756         emit ApprovalForAll(msg.sender, _operator, _approved);
757     }
758 
759     /// @dev Function to mint tokens
760     ///      Throws if `_to` is zero address.
761     ///      Throws if `_tokenId` is owned by someone.
762     /// @param _to The address that will receive the minted tokens.
763     /// @param _tokenId The token id to mint.
764     /// @return A boolean that indicates if the operation was successful.
765     function _mint(address _to, uint _tokenId) internal returns (bool) {
766         // Throws if `_to` is zero address
767         assert(_to != address(0));
768         // Add NFT. Throws if `_tokenId` is owned by someone
769         _addTokenTo(_to, _tokenId);
770         nftSupply++;
771         emit Transfer(address(0), _to, _tokenId);
772         return true;
773     }
774 
775     /// @notice Record global and per-user data to checkpoint
776     /// @param _tokenId NFT token ID. No user checkpoint if 0
777     /// @param old_locked Pevious locked amount / end lock time for the user
778     /// @param new_locked New locked amount / end lock time for the user
779     function _checkpoint(
780         uint _tokenId,
781         LockedBalance memory old_locked,
782         LockedBalance memory new_locked
783     ) internal {
784         Point memory u_old;
785         Point memory u_new;
786         int128 old_dslope = 0;
787         int128 new_dslope = 0;
788         uint _epoch = epoch;
789 
790         if (_tokenId != 0) {
791             // Calculate slopes and biases
792             // Kept at zero when they have to
793             if (old_locked.end > block.timestamp && old_locked.amount > 0) {
794                 u_old.slope = old_locked.amount / iMAXTIME;
795                 u_old.bias = u_old.slope * int128(int256(old_locked.end - block.timestamp));
796             }
797             if (new_locked.end > block.timestamp && new_locked.amount > 0) {
798                 u_new.slope = new_locked.amount / iMAXTIME;
799                 u_new.bias = u_new.slope * int128(int256(new_locked.end - block.timestamp));
800             }
801 
802             // Read values of scheduled changes in the slope
803             // old_locked.end can be in the past and in the future
804             // new_locked.end can ONLY by in the FUTURE unless everything expired: than zeros
805             old_dslope = slope_changes[old_locked.end];
806             if (new_locked.end != 0) {
807                 if (new_locked.end == old_locked.end) {
808                     new_dslope = old_dslope;
809                 } else {
810                     new_dslope = slope_changes[new_locked.end];
811                 }
812             }
813         }
814 
815         Point memory last_point = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number});
816         if (_epoch > 0) {
817             last_point = point_history[_epoch];
818         }
819         uint last_checkpoint = last_point.ts;
820         // initial_last_point is used for extrapolation to calculate block number
821         // (approximately, for *At methods) and save them
822         // as we cannot figure that out exactly from inside the contract
823         Point memory initial_last_point = last_point;
824         uint block_slope = 0; // dblock/dt
825         if (block.timestamp > last_point.ts) {
826             block_slope = (MULTIPLIER * (block.number - last_point.blk)) / (block.timestamp - last_point.ts);
827         }
828         // If last point is already recorded in this block, slope=0
829         // But that's ok b/c we know the block in such case
830 
831         // Go over weeks to fill history and calculate what the current point is
832         {
833             uint t_i = (last_checkpoint / WEEK) * WEEK;
834             for (uint i = 0; i < 255; ++i) {
835                 // Hopefully it won't happen that this won't get used in 5 years!
836                 // If it does, users will be able to withdraw but vote weight will be broken
837                 t_i += WEEK;
838                 int128 d_slope = 0;
839                 if (t_i > block.timestamp) {
840                     t_i = block.timestamp;
841                 } else {
842                     d_slope = slope_changes[t_i];
843                 }
844                 last_point.bias -= last_point.slope * int128(int256(t_i - last_checkpoint));
845                 last_point.slope += d_slope;
846                 if (last_point.bias < 0) {
847                     // This can happen
848                     last_point.bias = 0;
849                 }
850                 if (last_point.slope < 0) {
851                     // This cannot happen - just in case
852                     last_point.slope = 0;
853                 }
854                 last_checkpoint = t_i;
855                 last_point.ts = t_i;
856                 last_point.blk = initial_last_point.blk + (block_slope * (t_i - initial_last_point.ts)) / MULTIPLIER;
857                 _epoch += 1;
858                 if (t_i == block.timestamp) {
859                     last_point.blk = block.number;
860                     break;
861                 } else {
862                     point_history[_epoch] = last_point;
863                 }
864             }
865         }
866 
867         epoch = _epoch;
868         // Now point_history is filled until t=now
869 
870         if (_tokenId != 0) {
871             // If last point was in this block, the slope change has been applied already
872             // But in such case we have 0 slope(s)
873             last_point.slope += (u_new.slope - u_old.slope);
874             last_point.bias += (u_new.bias - u_old.bias);
875             if (last_point.slope < 0) {
876                 last_point.slope = 0;
877             }
878             if (last_point.bias < 0) {
879                 last_point.bias = 0;
880             }
881         }
882 
883         // Record the changed point into history
884         point_history[_epoch] = last_point;
885 
886         if (_tokenId != 0) {
887             // Schedule the slope changes (slope is going down)
888             // We subtract new_user_slope from [new_locked.end]
889             // and add old_user_slope to [old_locked.end]
890             if (old_locked.end > block.timestamp) {
891                 // old_dslope was <something> - u_old.slope, so we cancel that
892                 old_dslope += u_old.slope;
893                 if (new_locked.end == old_locked.end) {
894                     old_dslope -= u_new.slope; // It was a new deposit, not extension
895                 }
896                 slope_changes[old_locked.end] = old_dslope;
897             }
898 
899             if (new_locked.end > block.timestamp) {
900                 if (new_locked.end > old_locked.end) {
901                     new_dslope -= u_new.slope; // old slope disappeared at this point
902                     slope_changes[new_locked.end] = new_dslope;
903                 }
904                 // else: we recorded it already in old_dslope
905             }
906             // Now handle user history
907             uint user_epoch = user_point_epoch[_tokenId] + 1;
908 
909             user_point_epoch[_tokenId] = user_epoch;
910             u_new.ts = block.timestamp;
911             u_new.blk = block.number;
912             user_point_history[_tokenId][user_epoch] = u_new;
913         }
914     }
915 
916     /// @notice Deposit and lock tokens for a user
917     /// @param _tokenId NFT that holds lock
918     /// @param _value Amount to deposit
919     /// @param unlock_time New time when to unlock the tokens, or 0 if unchanged
920     /// @param locked_balance Previous locked amount / timestamp
921     /// @param deposit_type The type of deposit
922     function _deposit_for(
923         uint _tokenId,
924         uint _value,
925         uint unlock_time,
926         LockedBalance memory locked_balance,
927         DepositType deposit_type
928     ) internal {
929         LockedBalance memory _locked = locked_balance;
930         uint supply_before = supply;
931 
932         supply = supply_before + _value;
933         LockedBalance memory old_locked;
934         (old_locked.amount, old_locked.end) = (_locked.amount, _locked.end);
935         // Adding to existing lock, or if a lock is expired - creating a new one
936         _locked.amount += int128(int256(_value));
937         if (unlock_time != 0) {
938             _locked.end = unlock_time;
939         }
940         locked[_tokenId] = _locked;
941 
942         // Possibilities:
943         // Both old_locked.end could be current or expired (>/< block.timestamp)
944         // value == 0 (extend lock) or value > 0 (add to lock or extend lock)
945         // _locked.end > block.timestamp (always)
946         _checkpoint(_tokenId, old_locked, _locked);
947 
948         address from = msg.sender;
949         if (_value != 0 && deposit_type != DepositType.MERGE_TYPE) {
950             assert(IERC20(token).transferFrom(from, address(this), _value));
951         }
952 
953         emit Deposit(from, _tokenId, _value, _locked.end, deposit_type, block.timestamp);
954         emit Supply(supply_before, supply_before + _value);
955     }
956 
957     function setVoter(address _voter) external {
958         require(msg.sender == voter);
959         voter = _voter;
960     }
961 
962     function voting(uint _tokenId) external {
963         require(msg.sender == voter);
964         voted[_tokenId] = true;
965     }
966 
967     function abstain(uint _tokenId) external {
968         require(msg.sender == voter);
969         voted[_tokenId] = false;
970     }
971 
972     function attach(uint _tokenId) external {
973         require(msg.sender == voter);
974         attachments[_tokenId] = attachments[_tokenId]+1;
975     }
976 
977     function detach(uint _tokenId) external {
978         require(msg.sender == voter);
979         attachments[_tokenId] = attachments[_tokenId]-1;
980     }
981 
982     function merge(uint _from, uint _to) external {
983         require(attachments[_from] == 0 && !voted[_from], "attached");
984         require(_from != _to);
985         require(_isApprovedOrOwner(msg.sender, _from));
986         require(_isApprovedOrOwner(msg.sender, _to));
987 
988         LockedBalance memory _locked0 = locked[_from];
989         LockedBalance memory _locked1 = locked[_to];
990         uint value0 = uint(int256(_locked0.amount));
991         uint end = _locked0.end >= _locked1.end ? _locked0.end : _locked1.end;
992 
993         locked[_from] = LockedBalance(0, 0);
994         _checkpoint(_from, _locked0, LockedBalance(0, 0));
995         _burn(_from);
996         _deposit_for(_to, value0, end, _locked1, DepositType.MERGE_TYPE);
997     }
998 
999     function block_number() external view returns (uint) {
1000         return block.number;
1001     }
1002 
1003     /// @notice Record global data to checkpoint
1004     function checkpoint() external {
1005         _checkpoint(0, LockedBalance(0, 0), LockedBalance(0, 0));
1006     }
1007 
1008     /// @notice Deposit `_value` tokens for `_tokenId` and add to the lock
1009     /// @dev Anyone (even a smart contract) can deposit for someone else, but
1010     ///      cannot extend their locktime and deposit for a brand new user
1011     /// @param _tokenId lock NFT
1012     /// @param _value Amount to add to user's lock
1013     function deposit_for(uint _tokenId, uint _value) external nonreentrant {
1014         LockedBalance memory _locked = locked[_tokenId];
1015 
1016         require(_value > 0); // dev: need non-zero value
1017         require(_locked.amount > 0, 'No existing lock found');
1018         require(_locked.end > block.timestamp, 'Cannot add to expired lock. Withdraw');
1019         _deposit_for(_tokenId, _value, 0, _locked, DepositType.DEPOSIT_FOR_TYPE);
1020     }
1021 
1022     /// @notice Deposit `_value` tokens for `_to` and lock for `_lock_duration`
1023     /// @param _value Amount to deposit
1024     /// @param _lock_duration Number of seconds to lock tokens for (rounded down to nearest week)
1025     /// @param _to Address to deposit
1026     function _create_lock(uint _value, uint _lock_duration, address _to) internal returns (uint) {
1027         uint unlock_time = (block.timestamp + _lock_duration) / WEEK * WEEK; // Locktime is rounded down to weeks
1028 
1029         require(_value > 0); // dev: need non-zero value
1030         require(unlock_time > block.timestamp, 'Can only lock until time in the future');
1031         require(unlock_time <= block.timestamp + MAXTIME, 'Voting lock can be 4 years max');
1032 
1033         ++tokenId;
1034         uint _tokenId = tokenId;
1035         _mint(_to, _tokenId);
1036 
1037         _deposit_for(_tokenId, _value, unlock_time, locked[_tokenId], DepositType.CREATE_LOCK_TYPE);
1038         return _tokenId;
1039     }
1040 
1041     /// @notice Deposit `_value` tokens for `_to` and lock for `_lock_duration`
1042     /// @param _value Amount to deposit
1043     /// @param _lock_duration Number of seconds to lock tokens for (rounded down to nearest week)
1044     /// @param _to Address to deposit
1045     function create_lock_for(uint _value, uint _lock_duration, address _to) external nonreentrant returns (uint) {
1046         return _create_lock(_value, _lock_duration, _to);
1047     }
1048 
1049     /// @notice Deposit `_value` tokens for `msg.sender` and lock for `_lock_duration`
1050     /// @param _value Amount to deposit
1051     /// @param _lock_duration Number of seconds to lock tokens for (rounded down to nearest week)
1052     function create_lock(uint _value, uint _lock_duration) external nonreentrant returns (uint) {
1053         return _create_lock(_value, _lock_duration, msg.sender);
1054     }
1055 
1056     /// @notice Deposit `_value` additional tokens for `_tokenId` without modifying the unlock time
1057     /// @param _value Amount of tokens to deposit and add to the lock
1058     function increase_amount(uint _tokenId, uint _value) external nonreentrant {
1059         assert(_isApprovedOrOwner(msg.sender, _tokenId));
1060 
1061         LockedBalance memory _locked = locked[_tokenId];
1062 
1063         assert(_value > 0); // dev: need non-zero value
1064         require(_locked.amount > 0, 'No existing lock found');
1065         require(_locked.end > block.timestamp, 'Cannot add to expired lock. Withdraw');
1066 
1067         _deposit_for(_tokenId, _value, 0, _locked, DepositType.INCREASE_LOCK_AMOUNT);
1068     }
1069 
1070     /// @notice Extend the unlock time for `_tokenId`
1071     /// @param _lock_duration New number of seconds until tokens unlock
1072     function increase_unlock_time(uint _tokenId, uint _lock_duration) external nonreentrant {
1073         assert(_isApprovedOrOwner(msg.sender, _tokenId));
1074 
1075         LockedBalance memory _locked = locked[_tokenId];
1076         uint unlock_time = (block.timestamp + _lock_duration) / WEEK * WEEK; // Locktime is rounded down to weeks
1077 
1078         require(_locked.end > block.timestamp, 'Lock expired');
1079         require(_locked.amount > 0, 'Nothing is locked');
1080         require(unlock_time > _locked.end, 'Can only increase lock duration');
1081         require(unlock_time <= block.timestamp + MAXTIME, 'Voting lock can be 4 years max');
1082 
1083         _deposit_for(_tokenId, 0, unlock_time, _locked, DepositType.INCREASE_UNLOCK_TIME);
1084     }
1085 
1086     /// @notice Withdraw all tokens for `_tokenId`
1087     /// @dev Only possible if the lock has expired
1088     function withdraw(uint _tokenId) external nonreentrant {
1089         assert(_isApprovedOrOwner(msg.sender, _tokenId));
1090         require(attachments[_tokenId] == 0 && !voted[_tokenId], "attached");
1091 
1092         LockedBalance memory _locked = locked[_tokenId];
1093         require(block.timestamp >= _locked.end, "The lock didn't expire");
1094         uint value = uint(int256(_locked.amount));
1095 
1096         locked[_tokenId] = LockedBalance(0,0);
1097         uint supply_before = supply;
1098         supply = supply_before - value;
1099 
1100         // old_locked can have either expired <= timestamp or zero end
1101         // _locked has only 0 end
1102         // Both can have >= 0 amount
1103         _checkpoint(_tokenId, _locked, LockedBalance(0,0));
1104 
1105         address owner = ownerOf(_tokenId);
1106         // Burn the NFT
1107         _burn(_tokenId);
1108 
1109         assert(IERC20(token).transfer(owner, value));
1110 
1111         emit Withdraw(msg.sender, _tokenId, value, block.timestamp);
1112         emit Supply(supply_before, supply_before - value);
1113     }
1114 
1115     // The following ERC20/minime-compatible methods are not real balanceOf and supply!
1116     // They measure the weights for the purpose of voting, so they don't represent
1117     // real coins.
1118 
1119     /// @notice Binary search to estimate timestamp for block number
1120     /// @param _block Block to find
1121     /// @param max_epoch Don't go beyond this epoch
1122     /// @return Approximate timestamp for block
1123     function _find_block_epoch(uint _block, uint max_epoch) internal view returns (uint) {
1124         // Binary search
1125         uint _min = 0;
1126         uint _max = max_epoch;
1127         for (uint i = 0; i < 128; ++i) {
1128             // Will be always enough for 128-bit numbers
1129             if (_min >= _max) {
1130                 break;
1131             }
1132             uint _mid = (_min + _max + 1) / 2;
1133             if (point_history[_mid].blk <= _block) {
1134                 _min = _mid;
1135             } else {
1136                 _max = _mid - 1;
1137             }
1138         }
1139         return _min;
1140     }
1141 
1142     /// @notice Get the current voting power for `_tokenId`
1143     /// @dev Adheres to the ERC20 `balanceOf` interface for Aragon compatibility
1144     /// @param _tokenId NFT for lock
1145     /// @param _t Epoch time to return voting power at
1146     /// @return User voting power
1147     function _balanceOfNFT(uint _tokenId, uint _t) internal view returns (uint) {
1148         uint _epoch = user_point_epoch[_tokenId];
1149         if (_epoch == 0) {
1150             return 0;
1151         } else {
1152             Point memory last_point = user_point_history[_tokenId][_epoch];
1153             last_point.bias -= last_point.slope * int128(int256(_t) - int256(last_point.ts));
1154             if (last_point.bias < 0) {
1155                 last_point.bias = 0;
1156             }
1157             return uint(int256(last_point.bias));
1158         }
1159     }
1160 
1161     /// @dev Returns current token URI metadata
1162     /// @param _tokenId Token ID to fetch URI for.
1163     function tokenURI(uint _tokenId) external view returns (string memory) {
1164         require(idToOwner[_tokenId] != address(0), "Query for nonexistent token");
1165         LockedBalance memory _locked = locked[_tokenId];
1166         return
1167         _tokenURI(
1168             _tokenId,
1169             _balanceOfNFT(_tokenId, block.timestamp),
1170             _locked.end,
1171             uint(int256(_locked.amount))
1172         );
1173     }
1174 
1175     function balanceOfNFT(uint _tokenId) external view returns (uint) {
1176         if (ownership_change[_tokenId] == block.number) return 0;
1177         return _balanceOfNFT(_tokenId, block.timestamp);
1178     }
1179 
1180     function balanceOfNFTAt(uint _tokenId, uint _t) external view returns (uint) {
1181         return _balanceOfNFT(_tokenId, _t);
1182     }
1183 
1184     /// @notice Measure voting power of `_tokenId` at block height `_block`
1185     /// @dev Adheres to MiniMe `balanceOfAt` interface: https://github.com/Giveth/minime
1186     /// @param _tokenId User's wallet NFT
1187     /// @param _block Block to calculate the voting power at
1188     /// @return Voting power
1189     function _balanceOfAtNFT(uint _tokenId, uint _block) internal view returns (uint) {
1190         // Copying and pasting totalSupply code because Vyper cannot pass by
1191         // reference yet
1192         assert(_block <= block.number);
1193 
1194         // Binary search
1195         uint _min = 0;
1196         uint _max = user_point_epoch[_tokenId];
1197         for (uint i = 0; i < 128; ++i) {
1198             // Will be always enough for 128-bit numbers
1199             if (_min >= _max) {
1200                 break;
1201             }
1202             uint _mid = (_min + _max + 1) / 2;
1203             if (user_point_history[_tokenId][_mid].blk <= _block) {
1204                 _min = _mid;
1205             } else {
1206                 _max = _mid - 1;
1207             }
1208         }
1209 
1210         Point memory upoint = user_point_history[_tokenId][_min];
1211 
1212         uint max_epoch = epoch;
1213         uint _epoch = _find_block_epoch(_block, max_epoch);
1214         Point memory point_0 = point_history[_epoch];
1215         uint d_block = 0;
1216         uint d_t = 0;
1217         if (_epoch < max_epoch) {
1218             Point memory point_1 = point_history[_epoch + 1];
1219             d_block = point_1.blk - point_0.blk;
1220             d_t = point_1.ts - point_0.ts;
1221         } else {
1222             d_block = block.number - point_0.blk;
1223             d_t = block.timestamp - point_0.ts;
1224         }
1225         uint block_time = point_0.ts;
1226         if (d_block != 0) {
1227             block_time += (d_t * (_block - point_0.blk)) / d_block;
1228         }
1229 
1230         upoint.bias -= upoint.slope * int128(int256(block_time - upoint.ts));
1231         if (upoint.bias >= 0) {
1232             return uint(uint128(upoint.bias));
1233         } else {
1234             return 0;
1235         }
1236     }
1237 
1238     function balanceOfAtNFT(uint _tokenId, uint _block) external view returns (uint) {
1239         return _balanceOfAtNFT(_tokenId, _block);
1240     }
1241 
1242     /// @notice Calculate total voting power at some point in the past
1243     /// @param point The point (bias/slope) to start search from
1244     /// @param t Time to calculate the total voting power at
1245     /// @return Total voting power at that time
1246     function _supply_at(Point memory point, uint t) internal view returns (uint) {
1247         Point memory last_point = point;
1248         uint t_i = (last_point.ts / WEEK) * WEEK;
1249         for (uint i = 0; i < 255; ++i) {
1250             t_i += WEEK;
1251             int128 d_slope = 0;
1252             if (t_i > t) {
1253                 t_i = t;
1254             } else {
1255                 d_slope = slope_changes[t_i];
1256             }
1257             last_point.bias -= last_point.slope * int128(int256(t_i - last_point.ts));
1258             if (t_i == t) {
1259                 break;
1260             }
1261             last_point.slope += d_slope;
1262             last_point.ts = t_i;
1263         }
1264 
1265         if (last_point.bias < 0) {
1266             last_point.bias = 0;
1267         }
1268         return uint(uint128(last_point.bias));
1269     }
1270 
1271     /// @notice Calculate total voting power
1272     /// @dev Adheres to the ERC20 `totalSupply` interface for Aragon compatibility
1273     /// @return Total voting power
1274     function totalSupplyAtT(uint t) public view returns (uint) {
1275         uint _epoch = epoch;
1276         Point memory last_point = point_history[_epoch];
1277         return _supply_at(last_point, t);
1278     }
1279 
1280     function totalSupply() external view returns (uint) {
1281         return totalSupplyAtT(block.timestamp);
1282     }
1283 
1284     /// @notice Calculate total voting power at some point in the past
1285     /// @param _block Block to calculate the total voting power at
1286     /// @return Total voting power at `_block`
1287     function totalSupplyAt(uint _block) external view returns (uint) {
1288         assert(_block <= block.number);
1289         uint _epoch = epoch;
1290         uint target_epoch = _find_block_epoch(_block, _epoch);
1291 
1292         Point memory point = point_history[target_epoch];
1293         uint dt = 0;
1294         if (target_epoch < _epoch) {
1295             Point memory point_next = point_history[target_epoch + 1];
1296             if (point.blk != point_next.blk) {
1297                 dt = ((_block - point.blk) * (point_next.ts - point.ts)) / (point_next.blk - point.blk);
1298             }
1299         } else {
1300             if (point.blk != block.number) {
1301                 dt = ((_block - point.blk) * (block.timestamp - point.ts)) / (block.number - point.blk);
1302             }
1303         }
1304         // Now dt contains info on how far are we beyond point
1305         return _supply_at(point, point.ts + dt);
1306     }
1307 
1308     function _tokenURI(uint _tokenId, uint _balanceOf, uint _locked_end, uint _value) internal pure returns (string memory output) {
1309         output = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1310         output = string(abi.encodePacked(output, "token ", toString(_tokenId), '</text><text x="10" y="40" class="base">'));
1311         output = string(abi.encodePacked(output, "balanceOf ", toString(_balanceOf), '</text><text x="10" y="60" class="base">'));
1312         output = string(abi.encodePacked(output, "locked_end ", toString(_locked_end), '</text><text x="10" y="80" class="base">'));
1313         output = string(abi.encodePacked(output, "value ", toString(_value), '</text></svg>'));
1314 
1315         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "lock #', toString(_tokenId), '", "description": "veMULTI NFT", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1316         output = string(abi.encodePacked('data:application/json;base64,', json));
1317     }
1318 
1319     function toString(uint value) internal pure returns (string memory) {
1320         // Inspired by OraclizeAPI's implementation - MIT license
1321         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1322 
1323         if (value == 0) {
1324             return "0";
1325         }
1326         uint temp = value;
1327         uint digits;
1328         while (temp != 0) {
1329             digits++;
1330             temp /= 10;
1331         }
1332         bytes memory buffer = new bytes(digits);
1333         while (value != 0) {
1334             digits -= 1;
1335             buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
1336             value /= 10;
1337         }
1338         return string(buffer);
1339     }
1340 
1341     function _burn(uint _tokenId) internal {
1342         require(_isApprovedOrOwner(msg.sender, _tokenId), "caller is not owner nor approved");
1343 
1344         address owner = ownerOf(_tokenId);
1345 
1346         // Clear approval
1347         _clearApproval(owner, _tokenId);
1348         // Remove token
1349         _removeTokenFrom(owner, _tokenId);
1350         nftSupply--;
1351         emit Transfer(owner, address(0), _tokenId);
1352     }
1353 }
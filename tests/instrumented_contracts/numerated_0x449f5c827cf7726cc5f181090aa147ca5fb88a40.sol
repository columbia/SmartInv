1 pragma solidity ^0.4.19;
2 
3 /// @title ERC-721 Non-Fungible Token Standard
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
5 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
6 interface ERC721 /* is ERC165 */ {
7     /// @dev This emits when ownership of any NFT changes by any mechanism.
8     ///  This event emits when NFTs are created (`from` == 0) and destroyed
9     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
10     ///  may be created and assigned without emitting Transfer. At the time of
11     ///  any transfer, the approved address for that NFT (if any) is reset to none.
12     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
13 
14     /// @dev This emits when the approved address for an NFT is changed or
15     ///  reaffirmed. The zero address indicates there is no approved address.
16     ///  When a Transfer event emits, this also indicates that the approved
17     ///  address for that NFT (if any) is reset to none.
18     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
19 
20     /// @dev This emits when an operator is enabled or disabled for an owner.
21     ///  The operator can manage all NFTs of the owner.
22     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
23 
24     /// @notice Count all NFTs assigned to an owner
25     /// @dev NFTs assigned to the zero address are considered invalid, and this
26     ///  function throws for queries about the zero address.
27     /// @param _owner An address for whom to query the balance
28     /// @return The number of NFTs owned by `_owner`, possibly zero
29     function balanceOf(address _owner) external view returns (uint256);
30 
31     /// @notice Find the owner of an NFT
32     /// @param _tokenId The identifier for an NFT
33     /// @dev NFTs assigned to zero address are considered invalid, and queries
34     ///  about them do throw.
35     /// @return The address of the owner of the NFT
36     function ownerOf(uint256 _tokenId) external view returns (address);
37 
38     /// @notice Transfers the ownership of an NFT from one address to another address
39     /// @dev Throws unless `msg.sender` is the current owner, an authorized
40     ///  operator, or the approved address for this NFT. Throws if `_from` is
41     ///  not the current owner. Throws if `_to` is the zero address. Throws if
42     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
43     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
44     ///  `onERC721Received` on `_to` and throws if the return value is not
45     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
46     /// @param _from The current owner of the NFT
47     /// @param _to The new owner
48     /// @param _tokenId The NFT to transfer
49     /// @param data Additional data with no specified format, sent in call to `_to`
50     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
51 
52     /// @notice Transfers the ownership of an NFT from one address to another address
53     /// @dev This works identically to the other function with an extra data parameter,
54     ///  except this function just sets data to ""
55     /// @param _from The current owner of the NFT
56     /// @param _to The new owner
57     /// @param _tokenId The NFT to transfer
58     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
59 
60     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
61     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
62     ///  THEY MAY BE PERMANENTLY LOST
63     /// @dev Throws unless `msg.sender` is the current owner, an authorized
64     ///  operator, or the approved address for this NFT. Throws if `_from` is
65     ///  not the current owner. Throws if `_to` is the zero address. Throws if
66     ///  `_tokenId` is not a valid NFT.
67     /// @param _from The current owner of the NFT
68     /// @param _to The new owner
69     /// @param _tokenId The NFT to transfer
70     function transferFrom(address _from, address _to, uint256 _tokenId) external;
71 
72     /// @notice Set or reaffirm the approved address for an NFT
73     /// @dev The zero address indicates there is no approved address.
74     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
75     ///  operator of the current owner.
76     /// @param _approved The new approved NFT controller
77     /// @param _tokenId The NFT to approve
78     function approve(address _approved, uint256 _tokenId) external;
79 
80     /// @notice Enable or disable approval for a third party ("operator") to manage
81     ///  all your assets.
82     /// @dev Throws unless `msg.sender` is the current NFT owner.
83     /// @dev Emits the ApprovalForAll event
84     /// @param _operator Address to add to the set of authorized operators.
85     /// @param _approved True if the operators is approved, false to revoke approval
86     function setApprovalForAll(address _operator, bool _approved) external;
87 
88     /// @notice Get the approved address for a single NFT
89     /// @dev Throws if `_tokenId` is not a valid NFT
90     /// @param _tokenId The NFT to find the approved address for
91     /// @return The approved address for this NFT, or the zero address if there is none
92     function getApproved(uint256 _tokenId) external view returns (address);
93 
94     /// @notice Query if an address is an authorized operator for another address
95     /// @param _owner The address that owns the NFTs
96     /// @param _operator The address that acts on behalf of the owner
97     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
98     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
99 }
100 
101 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
102 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
103 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63
104 interface ERC721Enumerable /* is ERC721 */ {
105   /// @notice Count NFTs tracked by this contract
106   /// @return A count of valid NFTs tracked by this contract, where each one of
107   ///  them has an assigned and queryable owner not equal to the zero address
108   function totalSupply() external view returns (uint256);
109 
110   /// @notice Enumerate valid NFTs
111   /// @dev Throws if `_index` >= `totalSupply()`.
112   /// @param _index A counter less than `totalSupply()`
113   /// @return The token identifier for the `_index`th NFT,
114   ///  (sort order not specified)
115   function tokenByIndex(uint256 _index) external view returns (uint256);
116 
117   /// @notice Enumerate NFTs assigned to an owner
118   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
119   ///  `_owner` is the zero address, representing invalid NFTs.
120   /// @param _owner An address where we are interested in NFTs owned by them
121   /// @param _index A counter less than `balanceOf(_owner)`
122   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
123   ///   (sort order not specified)
124   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
125 }
126 
127 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
128 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
129 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
130 interface ERC721Metadata /* is ERC721 */ {
131     /// @notice A descriptive name for a collection of NFTs in this contract
132     function name() external pure returns (string _name);
133 
134     /// @notice An abbreviated name for NFTs in this contract
135     function symbol() external pure returns (string _symbol);
136 
137     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
138     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
139     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
140     ///  Metadata JSON Schema".
141     function tokenURI(uint256 _tokenId) external view returns (string);
142 }
143 
144 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
145 interface ERC721TokenReceiver {
146     /// @notice Handle the receipt of an NFT
147     /// @dev The ERC721 smart contract calls this function on the recipient
148     ///  after a `transfer`. This function MAY throw to revert and reject the
149     ///  transfer. This function MUST use 50,000 gas or less. Return of other
150     ///  than the magic value MUST result in the transaction being reverted.
151     ///  Note: the contract address is always the message sender.
152     /// @param _from The sending address 
153     /// @param _tokenId The NFT identifier which is being transferred
154     /// @param data Additional data with no specified format
155     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
156     ///  unless throwing
157     function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
158 }
159 
160 contract Ownable {
161     address private owner;
162 
163     event LogOwnerChange(address _owner);
164 
165     // Modify method to only allow calls from the owner of the contract.
166     modifier onlyOwner() {
167         require(msg.sender == owner);
168         _;
169     }
170 
171     function Ownable() public {
172         owner = msg.sender;
173     }
174 
175     /**
176      * Replace the contract owner with a new owner.
177      *
178      * Parameters
179      * ----------
180      * _owner : address
181      *     The address to replace the current owner with.
182      */
183     function replaceOwner(address _owner) external onlyOwner {
184         owner = _owner;
185 
186         LogOwnerChange(_owner);
187     }
188 }
189 
190 contract Controllable is Ownable {
191     // Mapping of a contract address to its position in the list of active
192     // contracts. This allows an O(1) look-up of the contract address compared
193     // to a linear search within an array.
194     mapping(address => uint256) private contractIndices;
195 
196     // The list of contracts that are allowed to call the contract-restricted
197     // methods of contracts that extend this `Controllable` contract.
198     address[] private contracts;
199 
200     /**
201      * Modify method to only allow calls from active contract addresses.
202      *
203      * Notes
204      * -----
205      * The zero address is considered an inactive address, as it is impossible
206      * for users to send a call from that address.
207      */
208     modifier onlyActiveContracts() {
209         require(contractIndices[msg.sender] != 0);
210         _;
211     }
212 
213     function Controllable() public Ownable() {
214         // The zeroth index of the list of active contracts is occupied by the
215         // zero address to ensure that an index of zero can be used to indicate
216         // that the contract address is inactive.
217         contracts.push(address(0));
218     }
219 
220     /**
221      * Add a contract address to the list of active contracts.
222      *
223      * Parameters
224      * ----------
225      * _address : address
226      *     The contract address to add to the list of active contracts.
227      */
228     function activateContract(address _address) external onlyOwner {
229         require(contractIndices[_address] == 0);
230 
231         contracts.push(_address);
232 
233         // The index of the newly added contract is equal to the length of the
234         // array of active contracts minus one, as Solidity is a zero-based
235         // language.
236         contractIndices[_address] = contracts.length - 1;
237     }
238 
239     /**
240      * Remove a contract address from the list of active contracts.
241      *
242      * Parameters
243      * ----------
244      * _address : address
245      *     The contract address to remove from the list of active contracts.
246      */
247     function deactivateContract(address _address) external onlyOwner {
248         require(contractIndices[_address] != 0);
249 
250         // Get the last contract in the array of active contracts. This address
251         // will be used to overwrite the address that will be removed.
252         address lastActiveContract = contracts[contracts.length - 1];
253 
254         // Overwrite the address that is to be removed with the value of the
255         // last contract in the list. There is a possibility that these are the
256         // same values, in which case nothing happens.
257         contracts[contractIndices[_address]] = lastActiveContract;
258 
259         // Reduce the contracts array size by one, as the last contract address
260         // will have been successfully moved.
261         contracts.length--;
262 
263         // Set the address mapping to zero, effectively rendering the contract
264         // banned from calling this contract.
265         contractIndices[_address] = 0;
266     }
267 
268     /**
269      * Get the list of active contracts for this contract.
270      *
271      * Returns
272      * -------
273      * address[]
274      *     The list of contract addresses that are allowed to call the
275      *     contract-restricted methods of this contract.
276      */
277     function getActiveContracts() external view returns (address[]) {
278         return contracts;
279     }
280 }
281 
282 library Tools {
283     /**
284      * Concatenate two strings.
285      *
286      * Parameters
287      * ----------
288      * stringLeft : string
289      *     A string to concatenate with another string. This is the left part.
290      * stringRight : string
291      *     A string to concatenate with another string. This is the right part.
292      *
293      * Returns
294      * -------
295      * string
296      *     The resulting string from concatenating the two given strings.
297      */
298     function concatenate(
299         string stringLeft,
300         string stringRight
301     )
302         internal
303         pure
304         returns (string)
305     {
306         // Get byte representations of both strings to allow for one-by-one
307         // character iteration.
308         bytes memory stringLeftBytes = bytes(stringLeft);
309         bytes memory stringRightBytes = bytes(stringRight);
310 
311         // Initialize new string holder with the appropriate number of bytes to
312         // hold the concatenated string.
313         string memory resultString = new string(
314             stringLeftBytes.length + stringRightBytes.length
315         );
316 
317         // Get a bytes representation of the result string to allow for direct
318         // modification.
319         bytes memory resultBytes = bytes(resultString);
320 
321         // Initialize a number to hold the current index of the result string
322         // to assign a character to.
323         uint k = 0;
324 
325         // First loop over the left string, and afterwards over the right
326         // string to assign each character to its proper location in the new
327         // string.
328         for (uint i = 0; i < stringLeftBytes.length; i++) {
329             resultBytes[k++] = stringLeftBytes[i];
330         }
331 
332         for (i = 0; i < stringRightBytes.length; i++) {
333             resultBytes[k++] = stringRightBytes[i];
334         }
335 
336         return string(resultBytes);
337     }
338 
339     /**
340      * Convert 256-bit unsigned integer into a 32 bytes structure.
341      *
342      * Parameters
343      * ----------
344      * value : uint256
345      *     The unsigned integer to convert to bytes32.
346      *
347      * Returns
348      * -------
349      * bytes32
350      *     The bytes32 representation of the given unsigned integer.
351      */
352     function uint256ToBytes32(uint256 value) internal pure returns (bytes32) {
353         if (value == 0) {
354             return '0';
355         }
356 
357         bytes32 resultBytes;
358 
359         while (value > 0) {
360             resultBytes = bytes32(uint(resultBytes) / (2 ** 8));
361             resultBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
362             value /= 10;
363         }
364 
365         return resultBytes;
366     }
367 
368     /**
369      * Convert bytes32 data structure into a string.
370      *
371      * Parameters
372      * ----------
373      * data : bytes32
374      *     The bytes to convert to a string.
375      *
376      * Returns
377      * -------
378      * string
379      *     The string representation of given bytes.
380      *
381      * Notes
382      * -----
383      * This method is right-padded with zero bytes.
384      */
385     function bytes32ToString(bytes32 data) internal pure returns (string) {
386         bytes memory bytesString = new bytes(32);
387 
388         for (uint i = 0; i < 32; i++) {
389             bytes1 char = bytes1(bytes32(uint256(data) * 2 ** (8 * i)));
390 
391             if (char != 0) {
392                 bytesString[i] = char;
393             }
394         }
395 
396         return string(bytesString);
397     }
398 }
399 
400 /**
401  * Partial interface of former ownership contract.
402  *
403  * This interface is used to perform the migration of tokens, from the former
404  * ownership contract to the current version. The inclusion of the entire
405  * contract is too bulky, hence the partial interface.
406  */
407 interface PartialOwnership {
408     function ownerOf(uint256 _tokenId) external view returns (address);
409     function totalSupply() external view returns (uint256);
410 }
411 
412 /**
413  * Ethergotchi Ownership Contract
414  *
415  * This contract governs the "non-fungible tokens" (NFTs) that represent the
416  * various Ethergotchi owned by players within Aethia.
417  *
418  * The NFTs are implemented according to the standard described in EIP-721 as
419  * it was on March 19th, 2018.
420  *
421  * In addition to the mentioned specification, a method was added to create new
422  * tokens: `add(uint256 _tokenId, address _owner)`. This method can *only* be
423  * called by activated Aethia game contracts.
424  *
425  * For more information on Aethia and/or Ethergotchi, visit the following
426  * website: https://aethia.co
427  */
428 contract EthergotchiOwnershipV2 is
429     Controllable,
430     ERC721,
431     ERC721Enumerable,
432     ERC721Metadata
433 {
434     // Direct mapping to keep track of token owners.
435     mapping(uint256 => address) private ownerByTokenId;
436 
437     // Mapping that keeps track of all tokens owned by a specific address. This
438     // allows for iteration by owner, and is implemented to be able to comply
439     // with the enumeration methods described in the ERC721Enumerable interface.
440     mapping(address => uint256[]) private tokenIdsByOwner;
441 
442     // Mapping that keeps track of a token"s position in an owner"s list of
443     // tokens. This allows for constant time look-ups within the list, instead
444     // of needing to iterate the list of tokens.
445     mapping(uint256 => uint256) private ownerTokenIndexByTokenId;
446 
447     // Mapping that keeps track of addresses that are approved to make a
448     // transfer of a token. Approval can only be given to a single address, but
449     // can be overridden for modification or retraction purposes.
450     mapping(uint256 => address) private approvedTransfers;
451 
452     // Mapping that keeps track of operators that are allowed to perform
453     // actions on behalf of another address. An address is allowed to set more
454     // than one operator. Operators can perform all actions on behalf on an
455     // address, *except* for setting a different operator.
456     mapping(address => mapping(address => bool)) private operators;
457 
458     // Total number of tokens governed by this contract. This allows for the
459     // enumeration of all tokens, provided that tokens are created with their
460     // identifiers being numbers, incremented by one.
461     uint256 private totalTokens;
462 
463     // The ERC-165 identifier of the ERC-165 interface. This contract
464     // implements the `supportsInterface` method to check whether other types
465     // of standard interfaces are supported.
466     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = bytes4(
467         keccak256("supportsInterface(bytes4)")
468     );
469 
470     // The ERC-165 identifier of the ERC-721 interface. This contract
471     // implements all methods of the ERC-721 Enumerable interface, and uses
472     // this identifier to supply the correct answer to a call to
473     // `supportsInterface`.
474     bytes4 private constant INTERFACE_SIGNATURE_ERC721 = bytes4(
475         keccak256("balanceOf(address)") ^
476         keccak256("ownerOf(uint256)") ^
477         keccak256("safeTransferFrom(address,address,uint256,bytes)") ^
478         keccak256("safeTransferFrom(address,address,uint256)") ^
479         keccak256("transferFrom(address,address,uint256)") ^
480         keccak256("approve(address,uint256)") ^
481         keccak256("setApprovalForAll(address,bool)") ^
482         keccak256("getApproved(uint256)") ^
483         keccak256("isApprovedForAll(address,address)")
484     );
485 
486     // The ERC-165 identifier of the ERC-721 Enumerable interface. This
487     // contract implements all methods of the ERC-721 Enumerable interface, and
488     // uses this identifier to supply the correct answer to a call to
489     // `supportsInterface`.
490     bytes4 private constant INTERFACE_SIGNATURE_ERC721_ENUMERABLE = bytes4(
491         keccak256("totalSupply()") ^
492         keccak256("tokenByIndex(uint256)") ^
493         keccak256("tokenOfOwnerByIndex(address,uint256)")
494     );
495 
496     // The ERC-165 identifier of the ERC-721 Metadata interface. This contract
497     // implements all methods of the ERC-721 Metadata interface, and uses the
498     // identifier to supply the correct answer to a `supportsInterface` call.
499     bytes4 private constant INTERFACE_SIGNATURE_ERC721_METADATA = bytes4(
500         keccak256("name()") ^
501         keccak256("symbol()") ^
502         keccak256("tokenURI(uint256)")
503     );
504 
505     // The ERC-165 identifier of the ERC-721 Token Receiver interface. This
506     // is not implemented by this contract, but is used to identify the
507     // response given by the receiving contracts, if the `safeTransferFrom`
508     // method is used.
509     bytes4 private constant INTERFACE_SIGNATURE_ERC721_TOKEN_RECEIVER = bytes4(
510         keccak256("onERC721Received(address,uint256,bytes)")
511     );
512 
513     event Transfer(
514         address indexed _from,
515         address indexed _to,
516         uint256 _tokenId
517     );
518 
519     event Approval(
520         address indexed _owner,
521         address indexed _approved,
522         uint256 _tokenId
523     );
524 
525     event ApprovalForAll(
526         address indexed _owner,
527         address indexed _operator,
528         bool _approved
529     );
530 
531     /**
532      * Modify method to only allow calls if the token is valid.
533      *
534      * Notice
535      * ------
536      * Ethergotchi are valid if they are owned by an address that is not the
537      * zero address.
538      */
539     modifier onlyValidToken(uint256 _tokenId) {
540         require(ownerByTokenId[_tokenId] != address(0));
541         _;
542     }
543 
544     /**
545      * Modify method to only allow transfers from authorized callers.
546      *
547      * Notice
548      * ------
549      * This method also adds a few checks against common transfer beneficiary
550      * mistakes to prevent a subset of unintended transfers that cannot be
551      * reverted.
552      */
553     modifier onlyValidTransfers(address _from, address _to, uint256 _tokenId) {
554         // Get owner of the token. This is used to check against various cases
555         // where the caller is allowed to transfer the token.
556         address tokenOwner = ownerByTokenId[_tokenId];
557 
558         // Check whether the caller is allowed to transfer the token with given
559         // identifier. The caller is allowed to perform the transfer in any of
560         // the following cases:
561         //  1. the caller is the owner of the token;
562         //  2. the caller is approved by the owner of the token to transfer
563         //     that specific token; or
564         //  3. the caller is approved as operator by the owner of the token, in
565         //     which case the caller is approved to perform any action on
566         //     behalf of the owner.
567         require(
568             msg.sender == tokenOwner ||
569             msg.sender == approvedTransfers[_tokenId] ||
570             operators[tokenOwner][msg.sender]
571         );
572 
573         // Check against accidental transfers to the common "wrong" addresses.
574         // This includes the zero address, this ownership contract address, and
575         // "non-transfers" where the same address is filled in for both `_from`
576         // and `_to`.
577         require(
578             _to != address(0) &&
579             _to != address(this) &&
580             _to != _from
581         );
582 
583         _;
584     }
585 
586     /**
587      * Ethergotchi ownership contract constructor
588      *
589      * At the time of contract construction, an Ethergotchi is artificially
590      * constructed to ensure that Ethergotchi are numbered starting from one.
591      */
592     function EthergotchiOwnershipV2(
593         address _formerContract
594     )
595         public
596         Controllable()
597     {
598         ownerByTokenId[0] = address(0);
599         tokenIdsByOwner[address(0)].push(0);
600         ownerTokenIndexByTokenId[0] = 0;
601 
602         // The migration index is initialized to 1 as the zeroth token need not
603         // be migrated; it is already created during the construction of this
604         // contract.
605         migrationIndex = 1;
606         formerContract = PartialOwnership(_formerContract);
607     }
608 
609     /**
610      * Add new token into circulation.
611      *
612      * Parameters
613      * ----------
614      * _tokenId : uint256
615      *     The identifier of the token to add into circulation.
616      * _owner : address
617      *     The address of the owner who receives the newly added token.
618      *
619      * Notice
620      * ------
621      * This method can only be called by active game contracts. Game contracts
622      * are added and modified manually. These additions and modifications
623      * always trigger an event for audit purposes.
624      */
625     function add(
626         uint256 _tokenId,
627         address _owner
628     )
629         external
630         onlyActiveContracts
631     {
632         // Safety checks to prevent contracts from calling this method without
633         // setting the proper arguments.
634         require(_tokenId != 0 && _owner != address(0));
635 
636         _add(_tokenId, _owner);
637 
638         // As per the standard, transfers of newly created tokens should always
639         // originate from the zero address.
640         Transfer(address(0), _owner, _tokenId);
641     }
642 
643     /**
644      * Check whether contract supports given interface.
645      *
646      * Parameters
647      * ----------
648      * interfaceID : bytes4
649      *     The four-bytes representation of an interface of which to check
650      *     whether this contract supports it.
651      *
652      * Returns
653      * -------
654      * bool
655      *     True if given interface is supported, else False.
656      *
657      * Notice
658      * ------
659      * It is expected that the `bytes4` values of interfaces are generated by
660      * calling XOR on all function signatures of the interface.
661      *
662      * Technically more interfaces are supported, as some interfaces may be
663      * subsets of the supported interfaces. This check is only to be used to
664      * verify whether "standard interfaces" are supported.
665      */
666     function supportsInterface(
667         bytes4 interfaceID
668     )
669         external
670         view
671         returns (bool)
672     {
673         return (
674             interfaceID == INTERFACE_SIGNATURE_ERC165 ||
675             interfaceID == INTERFACE_SIGNATURE_ERC721 ||
676             interfaceID == INTERFACE_SIGNATURE_ERC721_METADATA ||
677             interfaceID == INTERFACE_SIGNATURE_ERC721_ENUMERABLE
678         );
679     }
680 
681     /**
682      * Get the name of the token this contract governs ownership of.
683      *
684      * Notice
685      * ------
686      * This is the collective name of the token. Individual tokens may be named
687      * differently by their owners.
688      */
689     function name() external pure returns (string) {
690         return "Ethergotchi";
691     }
692 
693     /**
694      * Get the symbol of the token this contract governs ownership of.
695      *
696      * Notice
697      * ------
698      * This symbol has been explicitly changed to `ETHERGOTCHI` from `GOTCHI`
699      * in the `PHOENIX` patch of Aethia to prevent confusion with older tokens.
700      */
701     function symbol() external pure returns (string) {
702         return "ETHERGOTCHI";
703     }
704 
705     /**
706      * Get the URI pointing to a JSON file with metadata for a given token.
707      *
708      * Parameters
709      * ----------
710      * _tokenId : uint256
711      *     The identifier of the token to get the URI for.
712      *
713      * Returns
714      * -------
715      * string
716      *     The URI pointing to a JSON file with metadata for the token with
717      *     given identifier.
718      *
719      * Notice
720      * ------
721      * This method returns a string that may contain more than one null-byte,
722      * because the conversion method is not ideal.
723      */
724     function tokenURI(uint256 _tokenId) external view returns (string) {
725         bytes32 tokenIdBytes = Tools.uint256ToBytes32(_tokenId);
726 
727         return Tools.concatenate(
728             "https://aethia.co/ethergotchi/",
729             Tools.bytes32ToString(tokenIdBytes)
730         );
731     }
732 
733     /**
734      * Get the number of tokens assigned to given owner.
735      *
736      * Parameters
737      * ----------
738      * _owner : address
739      *     The address of the owner of which to get the number of owned tokens
740      *     of.
741      *
742      * Returns
743      * -------
744      * uint256
745      *     The number of tokens owned by given owner.
746      *
747      * Notice
748      * ------
749      * Tokens owned by the zero address are considered invalid, as described in
750      * the EIP 721 standard, and queries regarding the zero address will result
751      * in the transaction being rejected.
752      */
753     function balanceOf(address _owner) external view returns (uint256) {
754         require(_owner != address(0));
755 
756         return tokenIdsByOwner[_owner].length;
757     }
758 
759     /**
760      * Get the address of the owner of given token.
761      *
762      * Parameters
763      * ----------
764      * _tokenId : uint256
765      *     The identifier of the token of which to get the owner"s address.
766      *
767      * Returns
768      * -------
769      * address
770      *     The address of the owner of given token.
771      *
772      * Notice
773      * ------
774      * Tokens owned by the zero address are considered invalid, as described in
775      * the EIP 721 standard, and queries regarding the zero address will result
776      * in the transaction being rejected.
777      */
778     function ownerOf(uint256 _tokenId) external view returns (address) {
779         // Store the owner in a temporary variable to avoid having to do the
780         // lookup twice.
781         address _owner = ownerByTokenId[_tokenId];
782 
783         require(_owner != address(0));
784 
785         return _owner;
786     }
787 
788     /**
789      * Transfer the ownership of given token from one address to another.
790      *
791      * Parameters
792      * ----------
793      * _from : address
794      *     The benefactor address to transfer the given token from.
795      * _to : address
796      *     The beneficiary address to transfer the given token to.
797      * _tokenId : uint256
798      *     The identifier of the token to transfer.
799      * data : bytes
800      *     Non-specified data to send along the transfer towards the `to`
801      *     address that can be processed.
802      *
803      * Notice
804      * ------
805      * This method performs a check to determine whether the receiving party is
806      * a smart contract by calling the `_isContract` method. This works until
807      * the `Serenity` update of Ethereum is deployed.
808      */
809     function safeTransferFrom(
810         address _from,
811         address _to,
812         uint256 _tokenId,
813         bytes data
814     )
815         external
816         onlyValidToken(_tokenId)
817     {
818         // Call the internal `_safeTransferFrom` method to avoid duplicating
819         // the transfer code.
820         _safeTransferFrom(_from, _to, _tokenId, data);
821     }
822 
823     /**
824      * Transfer the ownership of given token from one address to another.
825      *
826      * Parameters
827      * ----------
828      * _from : address
829      *     The benefactor address to transfer the given token from.
830      * _to : address
831      *     The beneficiary address to transfer the given token to.
832      * _tokenId : uint256
833      *     The identifier of the token to transfer.
834      *
835      * Notice
836      * ------
837      * This method does exactly the same as calling the `safeTransferFrom`
838      * method with the `data` parameter set to an empty bytes value:
839      *  `safeTransferFrom(_from, _to, _tokenId, "")`
840      */
841     function safeTransferFrom(
842         address _from,
843         address _to,
844         uint256 _tokenId
845     )
846         external
847         onlyValidToken(_tokenId)
848     {
849         // Call the internal `_safeTransferFrom` method to avoid duplicating
850         // the transfer code.
851         _safeTransferFrom(_from, _to, _tokenId, "");
852     }
853 
854     /**
855      * Transfer the ownership of given token from one address to another.
856      *
857      * Parameters
858      * ----------
859      * _from : address
860      *     The benefactor address to transfer the given token from.
861      * _to : address
862      *     The beneficiary address to transfer the given token to.
863      * _tokenId : uint256
864      *     The identifier of the token to transfer.
865      *
866      * Notice
867      * ------
868      * This method performs a few rudimentary checks to determine whether the
869      * receiving party can actually receive the token. However, it is still up
870      * to the caller to ensure this is actually the case.
871      */
872     function transferFrom(
873         address _from,
874         address _to,
875         uint256 _tokenId
876     )
877         external
878         onlyValidToken(_tokenId)
879         onlyValidTransfers(_from, _to, _tokenId)
880     {
881         _transfer(_to, _tokenId);
882     }
883 
884     /**
885      * Approve the given address for the transfer of the given token.
886      *
887      * Parameters
888      * ----------
889      * _approved : address
890      *     The address to approve. Approval allows the address to transfer the
891      *     given token to a different address.
892      * _tokenId : uint256
893      *     The identifier of the token to give transfer approval for.
894      *
895      * Notice
896      * ------
897      * There is no specific method to revoke approvals, but the approval is
898      * removed after the transfer has been completed. Additionally the owner
899      * or operator may call the method with the zero address as `_approved` to
900      * effectively revoke the approval.
901      */
902     function approve(address _approved, uint256 _tokenId) external {
903         address _owner = ownerByTokenId[_tokenId];
904 
905         // Approval can only be given by the owner or an operator approved by
906         // the owner.
907         require(msg.sender == _owner || operators[_owner][msg.sender]);
908 
909         // Set address as approved for transfer. It can be the case that the
910         // address was already set (e.g. this method was called twice in a row)
911         // in which case this does not change anything.
912         approvedTransfers[_tokenId] = _approved;
913 
914         Approval(msg.sender, _approved, _tokenId);
915     }
916 
917     /**
918      * Set approval for a third-party to manage all tokens of the caller.
919      *
920      * Parameters
921      * ----------
922      * _operator : address
923      *     The address to set the operator status for.
924      * _approved : bool
925      *     The operator status. True if the given address should be allowed to
926      *     act on behalf of the caller, else False.
927      *
928      * Notice
929      * ------
930      * There is no duplicate checking done out of simplicity. Callers are thus
931      * able to set the same address as operator a multitude of times, even if
932      * it does not change the actual state of the system.
933      */
934     function setApprovalForAll(address _operator, bool _approved) external {
935         operators[msg.sender][_operator] = _approved;
936 
937         ApprovalForAll(msg.sender, _operator, _approved);
938     }
939 
940     /**
941      * Get approved address for given token.
942      *
943      * Parameters
944      * ----------
945      * _tokenId : uint256
946      *     The identifier of the token of which to get the approved address of.
947      *
948      * Returns
949      * -------
950      * address
951      *     The address that is allowed to initiate a transfer of the given
952      *     token.
953      *
954      * Notice
955      * ------
956      * Technically this method could be implemented without the method modifier
957      * as the network guarantees that the address mapping is initiated with all
958      * addresses set to the zero address. The requirement is implemented to
959      * comply with the standard as described in EIP-721.
960      */
961     function getApproved(
962         uint256 _tokenId
963     )
964         external
965         view
966         onlyValidToken(_tokenId)
967         returns (address)
968     {
969         return approvedTransfers[_tokenId];
970     }
971 
972     /**
973      * Check whether an address is an authorized operator of another address.
974      *
975      * Parameters
976      * ----------
977      * _owner : address
978      *     The address of which to check whether it has approved the other
979      *     address to act as operator.
980      * _operator : address
981      *     The address of which to check whether it has been approved to act
982      *     as operator on behalf of `_owner`.
983      *
984      * Returns
985      * -------
986      * bool
987      *     True if `_operator` is approved for all actions on behalf of
988      *     `_owner`.
989      *
990      * Notice
991      * ------
992      * This method cannot fail, as the Ethereum network guarantees that all
993      * address mappings exist and are set to the zero address by default.
994      */
995     function isApprovedForAll(
996         address _owner,
997         address _operator
998     )
999         external
1000         view
1001         returns (bool)
1002     {
1003         return operators[_owner][_operator];
1004     }
1005 
1006     /**
1007      * Get the total number of tokens currently in circulation.
1008      *
1009      * Returns
1010      * -------
1011      * uint256
1012      *     The total number of tokens currently in circulation.
1013      */
1014     function totalSupply() external view returns (uint256) {
1015         return totalTokens;
1016     }
1017 
1018     /**
1019      * Get token identifier by index.
1020      *
1021      * Parameters
1022      * ----------
1023      * _index : uint256
1024      *     The index of the token to get the identifier of.
1025      *
1026      * Returns
1027      * -------
1028      * uint256
1029      *     The identifier of the token at given index.
1030      *
1031      * Notice
1032      * ------
1033      * Ethergotchi tokens are incrementally numbered starting from zero, and
1034      * always go up by one. The index of the token is thus equivalent to its
1035      * identifier.
1036      */
1037     function tokenByIndex(uint256 _index) external view returns (uint256) {
1038         require(_index < totalTokens);
1039 
1040         return _index;
1041     }
1042 
1043     /**
1044      * Get token of owner by index.
1045      *
1046      * Parameters
1047      * ----------
1048      * _owner : address
1049      *     The address of the owner of which to get the token of.
1050      * _index : uint256
1051      *     The index of the token in the given owner"s list of token.
1052      *
1053      * Returns
1054      * -------
1055      * uint256
1056      *     The identifier of the token at given index of an owner"s list of
1057      *     tokens.
1058      */
1059     function tokenOfOwnerByIndex(
1060         address _owner,
1061         uint256 _index
1062     )
1063         external
1064         view
1065         returns (uint256)
1066     {
1067         require(_index < tokenIdsByOwner[_owner].length);
1068 
1069         return tokenIdsByOwner[_owner][_index];
1070     }
1071 
1072     /**
1073      * Check whether given address is a smart contract.
1074      *
1075      * Parameters
1076      * ----------
1077      * _address : address
1078      *     The address of which to check whether it is a contract.
1079      *
1080      * Returns
1081      * -------
1082      * bool
1083      *     True if given address is a contract, else False.
1084      *
1085      * Notice
1086      * ------
1087      * This method works as long as the `Serenity` update of Ethereum has not
1088      * been deployed. At the time of writing, contracts cannot set their code
1089      * size to zero, nor can "normal" addresses set their code size to anything
1090      * non-zero. With `Serenity` the idea will be that each and every address
1091      * is an contract, effectively rendering this method.
1092      */
1093     function _isContract(address _address) internal view returns (bool) {
1094         uint size;
1095 
1096         assembly {
1097             size := extcodesize(_address)
1098         }
1099 
1100         return size > 0;
1101     }
1102 
1103     /**
1104      * Transfer the ownership of given token from one address to another.
1105      *
1106      * Parameters
1107      * ----------
1108      * _from : address
1109      *     The benefactor address to transfer the given token from.
1110      * _to : address
1111      *     The beneficiary address to transfer the given token to.
1112      * _tokenId : uint256
1113      *     The identifier of the token to transfer.
1114      * data : bytes
1115      *     Non-specified data to send along the transfer towards the `to`
1116      *     address that can be processed.
1117      *
1118      * Notice
1119      * ------
1120      * This method performs a check to determine whether the receiving party is
1121      * a smart contract by calling the `_isContract` method. This works until
1122      * the `Serenity` update of Ethereum is deployed.
1123      */
1124     function _safeTransferFrom(
1125         address _from, 
1126         address _to, 
1127         uint256 _tokenId,
1128         bytes data
1129     )
1130         internal
1131         onlyValidTransfers(_from, _to, _tokenId)
1132     {
1133         // Call the method that performs the actual transfer. All common cases
1134         // of "wrong" transfers have already been checked at this point. The
1135         // internal transfer method does no checking.
1136         _transfer(_to, _tokenId);
1137 
1138         // Check whether the receiving party is a contract, and if so, call
1139         // the `onERC721Received` method as defined in the ERC-721 standard.
1140         if (_isContract(_to)) {
1141 
1142             // Assume the receiving party has implemented ERC721TokenReceiver,
1143             // as otherwise the "unsafe" `transferFrom` method should have been
1144             // called instead.
1145             ERC721TokenReceiver _receiver = ERC721TokenReceiver(_to);
1146 
1147             // The response returned by `onERC721Received` of the receiving
1148             // contract"s `on *must* be equal to the magic number defined by
1149             // the ERC-165 signature of `ERC721TokenReceiver`. If this is not
1150             // the case, the transaction will be reverted.
1151             require(
1152                 _receiver.onERC721Received(
1153                     address(this),
1154                     _tokenId,
1155                     data
1156                 ) == INTERFACE_SIGNATURE_ERC721_TOKEN_RECEIVER
1157             );
1158         }
1159     }
1160 
1161     /**
1162      * Transfer token to new owner.
1163      *
1164      * Parameters
1165      * ----------
1166      * _to : address
1167      *     The address of the owner-to-be of given token.
1168      * _tokenId : _tokenId
1169      *     The identifier of the token that is to be transferred.
1170      *
1171      * Notice
1172      * ------
1173      * This method performs no safety checks as it can only be called within
1174      * the controlled environment of this contract.
1175      */
1176     function _transfer(address _to, uint256 _tokenId) internal {
1177         // Get current owner of the token. It is technically possible that the
1178         // owner is the same address as the address to which the token is to be
1179         // sent to. In this case the token will be moved to the end of the list
1180         // of tokens owned by this address.
1181         address _from = ownerByTokenId[_tokenId];
1182 
1183         // There are two possible scenarios for transfers when it comes to the
1184         // removal of the token from the side that currently owns the token:
1185         //  1: the owner has two or more tokens; or
1186         //  2: the owner has one token.
1187         if (tokenIdsByOwner[_from].length > 1) {
1188 
1189             // Get the index of the token that has to be removed from the list
1190             // of tokens owned by the current owner.
1191             uint256 tokenIndexToDelete = ownerTokenIndexByTokenId[_tokenId];
1192 
1193             // To keep the list of tokens without gaps, and thus reducing the
1194             // gas cost associated with interacting with the list, the last
1195             // token in the owner"s list of tokens is moved to fill the gap
1196             // created by removing the token.
1197             uint256 tokenIndexToMove = tokenIdsByOwner[_from].length - 1;
1198 
1199             // Overwrite the token that is to be removed with the token that
1200             // was at the end of the list. It is possible that both are one and
1201             // the same, in which case nothing happens.
1202             tokenIdsByOwner[_from][tokenIndexToDelete] =
1203                 tokenIdsByOwner[_from][tokenIndexToMove];
1204         }
1205 
1206         // Remove the last item in the list of tokens owned by the current
1207         // owner. This item has either already been copied to the location of
1208         // the token that is to be transferred, or is the only token of this
1209         // owner in which case the list of tokens owned by this owner is now
1210         // empty.
1211         tokenIdsByOwner[_from].length--;
1212 
1213         // Add the token to the list of tokens owned by `_to`. Items are always
1214         // added to the very end of the list. This makes the token index of the
1215         // new token within the owner"s list of tokens equal to the length of
1216         // the list minus one as Solidity is a zero-based language. This token
1217         // index is then set for this token identifier.
1218         tokenIdsByOwner[_to].push(_tokenId);
1219         ownerTokenIndexByTokenId[_tokenId] = tokenIdsByOwner[_to].length - 1;
1220 
1221         // Set the direct ownership information of the token to the new owner
1222         // after all other ownership-related mappings have been updated to make
1223         // sure the "side" data is correct.
1224         ownerByTokenId[_tokenId] = _to;
1225 
1226         // Remove the approved address of this token. It may be the case there
1227         // was no approved address, in which case nothing changes.
1228         approvedTransfers[_tokenId] = address(0);
1229 
1230         // Log the transfer event onto the blockchain to leave behind an audit
1231         // trail of all transfers that have taken place.
1232         Transfer(_from, _to, _tokenId);
1233     }
1234 
1235     /**
1236      * Add new token into circulation.
1237      *
1238      * Parameters
1239      * ----------
1240      * _tokenId : uint256
1241      *     The identifier of the token to add into circulation.
1242      * _owner : address
1243      *     The address of the owner who receives the newly added token.
1244      */
1245     function _add(uint256 _tokenId, address _owner) internal {
1246         // Ensure the token does not already exist, and prevent duplicate calls
1247         // using the same identifier.
1248         require(ownerByTokenId[_tokenId] == address(0));
1249 
1250         // Update the direct ownership mapping, by setting the owner of the
1251         // token identifier to `_owner`, and adding the token to the list of
1252         // tokens owned by `_owner`. Arrays are always initialized to empty
1253         // versions of of their specific type, thus ensuring that the `push`
1254         // method will not fail.
1255         ownerByTokenId[_tokenId] = _owner;
1256         tokenIdsByOwner[_owner].push(_tokenId);
1257 
1258         // Update the mapping that keeps track of a token"s index within the
1259         // list of tokens owned by each owner. At the time of addition a token
1260         // is always added to the end of the list, and will thus always equal
1261         // the number of tokens already in the list, minus one, because the
1262         // arrays within Solidity are zero-based.
1263         ownerTokenIndexByTokenId[_tokenId] = tokenIdsByOwner[_owner].length - 1;
1264 
1265         totalTokens += 1;
1266     }
1267 
1268     /*********************************************/
1269     /** MIGRATION state variables and functions **/
1270     /*********************************************/
1271 
1272     // This number is used to keep track of how many tokens have been migrated.
1273     // The number cannot exceed the number of tokens that were assigned to
1274     // owners in the previous Ownership contract.
1275     uint256 public migrationIndex;
1276 
1277     // The previous token ownership contract.
1278     PartialOwnership private formerContract;
1279 
1280     /**
1281      * Migrate data from the former Ethergotchi ownership contract.
1282      *
1283      * Parameters
1284      * ----------
1285      * _count : uint256
1286      *     The number of tokens to migrate in a single transaction.
1287      *
1288      * Notice
1289      * ------
1290      * This method is limited in use to ensure no 'malicious' calls are made.
1291      * Additionally, this method writes to a contract state variable to keep
1292      * track of how many tokens have been migrated.
1293      */
1294     function migrate(uint256 _count) external onlyOwner {
1295         // Ensure that the migrate function can *only* be called in a specific
1296         // time period. This period ranges from Saturday, March 24th, 00:00:00
1297         // UTC until Sunday, March 25th, 23:59:59 UTC.
1298         require(1521849600 <= now && now <= 1522022399);
1299 
1300         // Get the maximum number of tokens handed out by the previous
1301         // ownership contract.
1302         uint256 formerTokenCount = formerContract.totalSupply();
1303 
1304         // The index to stop the migration at for this transaction.
1305         uint256 endIndex = migrationIndex + _count;
1306 
1307         // It is possible that the final transaction has a higher end index
1308         // than there are a number of tokens. In this case, the end index is
1309         // reduced to ensure no non-existent tokens are migrated.
1310         if (endIndex >= formerTokenCount) {
1311             endIndex = formerTokenCount;
1312         }
1313 
1314         // Loop through the token identifiers to migrate in this transaction.
1315         // Token identifiers are equivalent to their 'index', as identifiers
1316         // start at zero (with the zeroth token being owned by the zero
1317         // address), and are incremented by one for each new token.
1318         for (uint256 i = migrationIndex; i < endIndex; i++) {
1319             address tokenOwner;
1320 
1321             // There was a malicious account that acquired over 400 eggs via
1322             // referral codes, which breaks the terms of use. The acquired egg
1323             // numbers ranged from identifier 1247 up until 1688, excluding
1324             // 1296, 1297, 1479, 1492, 1550, 1551, and 1555. This was found by
1325             // looking at activity on the pick-up contract, and tracing it back
1326             // to the following address:
1327             //  `0c7a911ac29ea1e3b1d438f98f8bc053131dcaf52`
1328             if (_isExcluded(i)) {
1329                 tokenOwner = address(0);
1330             } else {
1331                 tokenOwner = formerContract.ownerOf(i);
1332             }
1333 
1334             // Assign the token to the same address that owned it in the
1335             // previous ownership contract.
1336             _add(i, tokenOwner);
1337 
1338             // Log the token transfer. In this case where the token is 'newly'
1339             // created, but actually transferred from a previous contract, the
1340             // `_from` address is set to the previous contract address, to
1341             // signify a migration.
1342             Transfer(address(formerContract), tokenOwner, i);
1343         }
1344 
1345         // Set the new migration index to where the current transaction ended
1346         // its migration.
1347         migrationIndex = endIndex;
1348     }
1349 
1350     /**
1351      * Check if Ethergotchi should be excluded from migration.
1352      *
1353      * Parameters
1354      * ----------
1355      * _gotchiId : uint256
1356      *     The identifier of the Ethergotchi of which to check the exclusion
1357      *     status.
1358      *
1359      * Returns
1360      * -------
1361      * bool
1362      *     True if the Ethergotchi should be excluded from the migration, else
1363      *     False.
1364      */
1365     function _isExcluded(uint256 _gotchiId) internal pure returns (bool) {
1366         return
1367             1247 <= _gotchiId && _gotchiId <= 1688 &&
1368             _gotchiId != 1296 &&
1369             _gotchiId != 1297 &&
1370             _gotchiId != 1479 &&
1371             _gotchiId != 1492 &&
1372             _gotchiId != 1550 &&
1373             _gotchiId != 1551 &&
1374             _gotchiId != 1555;
1375     }
1376 }
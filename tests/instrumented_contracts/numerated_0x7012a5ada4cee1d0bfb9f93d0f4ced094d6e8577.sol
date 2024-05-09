1 pragma solidity ^0.4.24;
2 
3 /// @title ERC-721 Non-Fungible Token Standard
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
5 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
6 interface ERC721 /* is ERC165 */ {
7     /// @dev This emits when ownership of any NFT changes by any mechanism.
8     ///  This event emits when NFTs are created (`from` == 0) and destroyed
9     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
10     ///  may be created and assigned without emitting Transfer. At the time of
11     ///  any transfer, the approved address for that NFT (if any) is reset to none.
12     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
13 
14     /// @dev This emits when the approved address for an NFT is changed or
15     ///  reaffirmed. The zero address indicates there is no approved address.
16     ///  When a Transfer event emits, this also indicates that the approved
17     ///  address for that NFT (if any) is reset to none.
18     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
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
32     /// @dev NFTs assigned to zero address are considered invalid, and queries
33     ///  about them do throw.
34     /// @param _tokenId The identifier for an NFT
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
45     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
46     /// @param _from The current owner of the NFT
47     /// @param _to The new owner
48     /// @param _tokenId The NFT to transfer
49     /// @param data Additional data with no specified format, sent in call to `_to`
50     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
51 
52     /// @notice Transfers the ownership of an NFT from one address to another address
53     /// @dev This works identically to the other function with an extra data parameter,
54     ///  except this function just sets data to "".
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
72     /// @notice Change or reaffirm the approved address for an NFT
73     /// @dev The zero address indicates there is no approved address.
74     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
75     ///  operator of the current owner.
76     /// @param _approved The new approved NFT controller
77     /// @param _tokenId The NFT to approve
78     function approve(address _approved, uint256 _tokenId) external;
79 
80     /// @notice Enable or disable approval for a third party ("operator") to manage
81     ///  all of `msg.sender`'s assets
82     /// @dev Emits the ApprovalForAll event. The contract MUST allow
83     ///  multiple operators per owner.
84     /// @param _operator Address to add to the set of authorized operators
85     /// @param _approved True if the operator is approved, false to revoke approval
86     function setApprovalForAll(address _operator, bool _approved) external;
87 
88     /// @notice Get the approved address for a single NFT
89     /// @dev Throws if `_tokenId` is not a valid NFT.
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
101 interface ERC165 {
102     /// @notice Query if a contract implements an interface
103     /// @param interfaceID The interface identifier, as specified in ERC-165
104     /// @dev Interface identification is specified in ERC-165. This function
105     ///  uses less than 30,000 gas.
106     /// @return `true` if the contract implements `interfaceID` and
107     ///  `interfaceID` is not 0xffffffff, `false` otherwise
108     function supportsInterface(bytes4 interfaceID) external view returns (bool);
109 }
110 
111 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
112 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
113 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
114 interface ERC721Enumerable /* is ERC721 */ {
115     /// @notice Count NFTs tracked by this contract
116     /// @return A count of valid NFTs tracked by this contract, where each one of
117     ///  them has an assigned and queryable owner not equal to the zero address
118     function totalSupply() external view returns (uint256);
119 
120     /// @notice Enumerate valid NFTs
121     /// @dev Throws if `_index` >= `totalSupply()`.
122     /// @param _index A counter less than `totalSupply()`
123     /// @return The token identifier for the `_index`th NFT,
124     ///  (sort order not specified)
125     function tokenByIndex(uint256 _index) external view returns (uint256);
126 
127     /// @notice Enumerate NFTs assigned to an owner
128     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
129     ///  `_owner` is the zero address, representing invalid NFTs.
130     /// @param _owner An address where we are interested in NFTs owned by them
131     /// @param _index A counter less than `balanceOf(_owner)`
132     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
133     ///   (sort order not specified)
134     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
135 }
136 
137 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
138 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
139 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
140 interface ERC721Metadata /* is ERC721 */ {
141     /// @notice A descriptive name for a collection of NFTs in this contract
142     function name() external view returns (string _name);
143 
144     /// @notice An abbreviated name for NFTs in this contract
145     function symbol() external view returns (string _symbol);
146 
147     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
148     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
149     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
150     ///  Metadata JSON Schema".
151     function tokenURI(uint256 _tokenId) external view returns (string);
152 }
153 
154 
155 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
156 interface ERC721TokenReceiver {
157     /// @notice Handle the receipt of an NFT
158     /// @dev The ERC721 smart contract calls this function on the recipient
159     ///  after a `transfer`. This function MAY throw to revert and reject the
160     ///  transfer. Return of other than the magic value MUST result in the
161     ///  transaction being reverted.
162     ///  Note: the contract address is always the message sender.
163     /// @param _operator The address which called `safeTransferFrom` function
164     /// @param _from The address which previously owned the token
165     /// @param _tokenId The NFT identifier which is being transferred
166     /// @param _data Additional data with no specified format
167     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
168     ///  unless throwing
169     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
170 }
171 
172 /**
173  * @dev Implementation of standard for detect smart contract interfaces.
174  */
175 contract SupportsInterface {
176     /**
177      * @dev Mapping of supported intefraces.
178      * @notice You must not set element 0xffffffff to true.
179      */
180     mapping(bytes4 => bool) internal supportedInterfaces;
181 
182     /**
183      * @dev Contract constructor.
184      */
185     constructor()
186     public
187     {
188         supportedInterfaces[0x01ffc9a7] = true; // ERC165
189     }
190 
191     /**
192      * @dev Function to check which interfaces are suported by this contract.
193      * @param _interfaceID Id of the interface.
194      */
195     function supportsInterface(
196         bytes4 _interfaceID
197     )
198     external
199     view
200     returns (bool)
201     {
202         return supportedInterfaces[_interfaceID];
203     }
204 
205 }
206 
207 /**
208  * @dev Utility library of inline functions on addresses.
209  */
210 library AddressUtils {
211 
212     /**
213      * @dev Returns whether the target address is a contract.
214      * @param _addr Address to check.
215      */
216     function isContract(
217         address _addr
218     )
219     internal
220     view
221     returns (bool)
222     {
223         uint256 size;
224 
225         /**
226          * XXX Currently there is no better way to check if there is a contract in an address than to
227          * check the size of the code at that address.
228          * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
229          * TODO: Check this again before the Serenity release, because all addresses will be
230          * contracts then.
231          */
232         assembly { size := extcodesize(_addr) } // solium-disable-line security/no-inline-assembly
233         return size > 0;
234     }
235 
236 }
237 
238 /**
239  * @dev Implementation of ERC-721 non-fungible token standard specifically for WeTrust Spring.
240  */
241 contract NFToken is ERC721, SupportsInterface, ERC721Metadata, ERC721Enumerable {
242     using AddressUtils for address;
243 
244     ///////////////////////////
245     // Constants
246     //////////////////////////
247 
248     /**
249      * @dev Magic value of a smart contract that can recieve NFT.
250      * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
251      */
252     bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
253 
254     //////////////////////////
255     // Events
256     //////////////////////////
257 
258     /**
259      * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
260      * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
261      * number of NFTs may be created and assigned without emitting Transfer. At the time of any
262      * transfer, the approved address for that NFT (if any) is reset to none.
263      * @param _from Sender of NFT (if address is zero address it indicates token creation).
264      * @param _to Receiver of NFT (if address is zero address it indicates token destruction).
265      * @param _tokenId The NFT that got transfered.
266      */
267     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
268 
269     /**
270      * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
271      * address indicates there is no approved address. When a Transfer event emits, this also
272      * indicates that the approved address for that NFT (if any) is reset to none.
273      * @param _owner Owner of NFT.
274      * @param _approved Address that we are approving.
275      * @param _tokenId NFT which we are approving.
276      */
277     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
278 
279     /**
280      * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
281      * all NFTs of the owner.
282      * @param _owner Owner of NFT.
283      * @param _operator Address to which we are setting operator rights.
284      * @param _approved Status of operator rights(true if operator rights are given and false if
285      * revoked).
286      */
287     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
288 
289     ////////////////////////////////
290     // Modifiers
291     ///////////////////////////////
292 
293     /**
294      * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
295      * @param _tokenId ID of the NFT to validate.
296      */
297     modifier canOperate(uint256 _tokenId) {
298         address tokenOwner = nft[_tokenId].owner;
299         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], "Sender is not an authorized operator of this token");
300         _;
301     }
302 
303     /**
304      * @dev Guarantees that the msg.sender is allowed to transfer NFT.
305      * @param _tokenId ID of the NFT to transfer.
306      */
307     modifier canTransfer(uint256 _tokenId) {
308         address tokenOwner = nft[_tokenId].owner;
309         require(
310             tokenOwner == msg.sender ||
311             getApproved(_tokenId) == msg.sender || ownerToOperators[tokenOwner][msg.sender],
312             "Sender does not have permission to transfer this Token");
313 
314         _;
315     }
316 
317     /**
318      * @dev Check to make sure the address is not zero address
319      * @param toTest The Address to make sure it's not zero address
320      */
321     modifier onlyNonZeroAddress(address toTest) {
322         require(toTest != address(0), "Address must be non zero address");
323         _;
324     }
325 
326     /**
327      * @dev Guarantees that no owner exists for the nft
328      * @param nftId NFT to test
329      */
330     modifier noOwnerExists(uint256 nftId) {
331         require(nft[nftId].owner == address(0), "Owner must not exist for this token");
332         _;
333     }
334 
335     /**
336      * @dev Guarantees that an owner exists for the nft
337      * @param nftId NFT to test
338      */
339     modifier ownerExists(uint256 nftId) {
340         require(nft[nftId].owner != address(0), "Owner must exist for this token");
341         _;
342     }
343 
344     ///////////////////////////
345     // Storage Variable
346     //////////////////////////
347 
348     /**
349      * @dev name of the NFT
350      */
351     string nftName = "WeTrust Nifty";
352 
353     /**
354      * @dev NFT symbol
355      */
356     string nftSymbol = "SPRN";
357 
358     /**
359      * @dev hostname to be used as base for tokenURI
360      */
361     string public hostname = "https://spring.wetrust.io/shiba/";
362 
363     /**
364      * @dev A mapping from NFT ID to the address that owns it.
365      */
366     mapping (uint256 => NFT) public nft;
367 
368     /**
369      * @dev List of NFTs
370      */
371     uint256[] nftList;
372 
373     /**
374     * @dev Mapping from owner address to count of his tokens.
375     */
376     mapping (address => uint256[]) internal ownerToTokenList;
377 
378     /**
379      * @dev Mapping from owner address to mapping of operator addresses.
380      */
381     mapping (address => mapping (address => bool)) internal ownerToOperators;
382 
383     struct NFT {
384         address owner;
385         address approval;
386         bytes32 traits;
387         uint16 edition;
388         bytes4 nftType;
389         bytes32 recipientId;
390         uint256 createdAt;
391     }
392 
393     ////////////////////////////////
394     // Public Functions
395     ///////////////////////////////
396 
397     /**
398      * @dev Contract constructor.
399      */
400     constructor() public {
401         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
402         supportedInterfaces[0x5b5e139f] = true; // ERC721MetaData
403         supportedInterfaces[0x80ac58cd] = true; // ERC721
404     }
405 
406     /**
407      * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
408      * considered invalid, and this function throws for queries about the zero address.
409      * @param _owner Address for whom to query the balance.
410      */
411     function balanceOf(address _owner) onlyNonZeroAddress(_owner) public view returns (uint256) {
412         return ownerToTokenList[_owner].length;
413     }
414 
415     /**
416      * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
417      * invalid, and queries about them do throw.
418      * @param _tokenId The identifier for an NFT.
419      */
420     function ownerOf(uint256 _tokenId) ownerExists(_tokenId) external view returns (address _owner) {
421         return nft[_tokenId].owner;
422     }
423 
424     /**
425      * @dev Transfers the ownership of an NFT from one address to another address.
426      * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
427      * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
428      * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
429      * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
430      * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
431      * @param _from The current owner of the NFT.
432      * @param _to The new owner.
433      * @param _tokenId The NFT to transfer.
434      * @param _data Additional data with no specified format, sent in call to `_to`.
435      */
436     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
437         _safeTransferFrom(_from, _to, _tokenId, _data);
438     }
439 
440     /**
441      * @dev Transfers the ownership of an NFT from one address to another address.
442      * @notice This works identically to the other function with an extra data parameter, except this
443      * function just sets data to ""
444      * @param _from The current owner of the NFT.
445      * @param _to The new owner.
446      * @param _tokenId The NFT to transfer.
447      */
448     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
449         _safeTransferFrom(_from, _to, _tokenId, "");
450     }
451 
452     /**
453      * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
454      * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
455      * address. Throws if `_tokenId` is not a valid NFT.
456      * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
457      * they maybe be permanently lost.
458      * @param _from The current owner of the NFT.
459      * @param _to The new owner.
460      * @param _tokenId The NFT to transfer.
461      */
462     function transferFrom(address _from, address _to, uint256 _tokenId)
463         onlyNonZeroAddress(_to)
464         canTransfer(_tokenId)
465         ownerExists(_tokenId)
466         external
467     {
468 
469         address tokenOwner = nft[_tokenId].owner;
470         require(tokenOwner == _from, "from address must be owner of tokenId");
471 
472         _transfer(_to, _tokenId);
473     }
474 
475     /**
476      * @dev Set or reaffirm the approved address for an NFT.
477      * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
478      * the current NFT owner, or an authorized operator of the current owner.
479      * @param _approved Address to be approved for the given NFT ID.
480      * @param _tokenId ID of the token to be approved.
481      */
482     function approve(address _approved, uint256 _tokenId)
483         canOperate(_tokenId)
484         ownerExists(_tokenId)
485         external
486     {
487 
488         address tokenOwner = nft[_tokenId].owner;
489         require(_approved != tokenOwner, "approved address cannot be owner of the token");
490 
491         nft[_tokenId].approval = _approved;
492         emit Approval(tokenOwner, _approved, _tokenId);
493     }
494 
495     /**
496      * @dev Enables or disables approval for a third party ("operator") to manage all of
497      * `msg.sender`'s assets. It also emits the ApprovalForAll event.
498      * @notice This works even if sender doesn't own any tokens at the time.
499      * @param _operator Address to add to the set of authorized operators.
500      * @param _approved True if the operators is approved, false to revoke approval.
501      */
502     function setApprovalForAll(address _operator, bool _approved)
503         onlyNonZeroAddress(_operator)
504         external
505     {
506 
507         ownerToOperators[msg.sender][_operator] = _approved;
508         emit ApprovalForAll(msg.sender, _operator, _approved);
509     }
510 
511     /**
512      * @dev Get the approved address for a single NFT.
513      * @notice Throws if `_tokenId` is not a valid NFT.
514      * @param _tokenId ID of the NFT to query the approval of.
515      */
516     function getApproved(uint256 _tokenId)
517         ownerExists(_tokenId)
518         public view returns (address)
519     {
520 
521         return nft[_tokenId].approval;
522     }
523 
524     /**
525      * @dev Checks if `_operator` is an approved operator for `_owner`.
526      * @param _owner The address that owns the NFTs.
527      * @param _operator The address that acts on behalf of the owner.
528      */
529     function isApprovedForAll(address _owner, address _operator)
530         onlyNonZeroAddress(_owner)
531         onlyNonZeroAddress(_operator)
532         external view returns (bool)
533     {
534 
535         return ownerToOperators[_owner][_operator];
536     }
537 
538     /**
539      * @dev return token list of owned by the owner
540      * @param owner The address that owns the NFTs.
541      */
542     function getOwnedTokenList(address owner) view public returns(uint256[] tokenList) {
543         return ownerToTokenList[owner];
544     }
545 
546     /// @notice A descriptive name for a collection of NFTs in this contract
547     function name() external view returns (string _name) {
548         return nftName;
549     }
550 
551     /// @notice An abbreviated name for NFTs in this contract
552     function symbol() external view returns (string _symbol) {
553         return nftSymbol;
554     }
555 
556     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
557     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
558     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
559     ///  Metadata JSON Schema".
560     function tokenURI(uint256 _tokenId) external view returns (string) {
561         return appendUintToString(hostname, _tokenId);
562     }
563 
564     /// @notice Count NFTs tracked by this contract
565     /// @return A count of valid NFTs tracked by this contract, where each one of
566     ///  them has an assigned and queryable owner not equal to the zero address
567     function totalSupply() external view returns (uint256) {
568         return nftList.length;
569     }
570 
571     /// @notice Enumerate valid NFTs
572     /// @dev Throws if `_index` >= `totalSupply()`.
573     /// @param _index A counter less than `totalSupply()`
574     /// @return The token identifier for the `_index`th NFT,
575     ///  (sort order not specified)
576     function tokenByIndex(uint256 _index) external view returns (uint256) {
577         require(_index < nftList.length, "index out of range");
578         return nftList[_index];
579     }
580 
581     /// @notice Enumerate NFTs assigned to an owner
582     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
583     ///  `_owner` is the zero address, representing invalid NFTs.
584     /// @param _owner An address where we are interested in NFTs owned by them
585     /// @param _index A counter less than `balanceOf(_owner)`
586     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
587     ///   (sort order not specified)
588     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
589         require(_index < balanceOf(_owner), "index out of range");
590         return ownerToTokenList[_owner][_index];
591     }
592 
593     /////////////////////////////
594     // Private Functions
595     ////////////////////////////
596 
597     /**
598      * @dev append uint to the end of string
599      * @param inStr input string
600      * @param v uint value v
601      * credit goes to : https://ethereum.stackexchange.com/questions/10811/solidity-concatenate-uint-into-a-string
602      */
603 
604     function appendUintToString(string inStr, uint v) pure internal returns (string str) {
605         uint maxlength = 100;
606         bytes memory reversed = new bytes(maxlength);
607         uint i = 0;
608         while (v != 0) {
609             uint remainder = v % 10;
610             v = v / 10;
611             reversed[i++] = byte(48 + remainder);
612         }
613         bytes memory inStrb = bytes(inStr);
614         bytes memory s = new bytes(inStrb.length + i);
615         uint j;
616         for (j = 0; j < inStrb.length; j++) {
617             s[j] = inStrb[j];
618         }
619         for (j = 0; j < i; j++) {
620             s[j + inStrb.length] = reversed[i - 1 - j];
621         }
622         str = string(s);
623     }
624 
625     /**
626      * @dev Actually preforms the transfer.
627      * @notice Does NO checks.
628      * @param _to Address of a new owner.
629      * @param _tokenId The NFT that is being transferred.
630      */
631     function _transfer(address _to, uint256 _tokenId) private {
632         address from = nft[_tokenId].owner;
633         clearApproval(_tokenId);
634 
635         removeNFToken(from, _tokenId);
636         addNFToken(_to, _tokenId);
637 
638         emit Transfer(from, _to, _tokenId);
639     }
640 
641     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)
642         onlyNonZeroAddress(_to)
643         canTransfer(_tokenId)
644         ownerExists(_tokenId)
645         internal
646     {
647         address tokenOwner = nft[_tokenId].owner;
648         require(tokenOwner == _from, "from address must be owner of tokenId");
649 
650         _transfer(_to, _tokenId);
651 
652         if (_to.isContract()) {
653             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
654             require(retval == MAGIC_ON_ERC721_RECEIVED, "reciever contract did not return the correct return value");
655         }
656     }
657 
658     /**
659      * @dev Clears the current approval of a given NFT ID.
660      * @param _tokenId ID of the NFT to be transferred.
661      */
662     function clearApproval(uint256 _tokenId) private {
663         if(nft[_tokenId].approval != address(0))
664         {
665             delete nft[_tokenId].approval;
666         }
667     }
668 
669     /**
670      * @dev Removes a NFT from owner.
671      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
672      * @param _from Address from wich we want to remove the NFT.
673      * @param _tokenId Which NFT we want to remove.
674      */
675     function removeNFToken(address _from, uint256 _tokenId) internal {
676         require(nft[_tokenId].owner == _from, "from address must be owner of tokenId");
677         uint256[] storage tokenList = ownerToTokenList[_from];
678         assert(tokenList.length > 0);
679 
680         for (uint256 i = 0; i < tokenList.length; i++) {
681             if (tokenList[i] == _tokenId) {
682                 tokenList[i] = tokenList[tokenList.length - 1];
683                 delete tokenList[tokenList.length - 1];
684                 tokenList.length--;
685                 break;
686             }
687         }
688         delete nft[_tokenId].owner;
689     }
690 
691     /**
692      * @dev Assignes a new NFT to owner.
693      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
694      * @param _to Address to wich we want to add the NFT.
695      * @param _tokenId Which NFT we want to add.
696      */
697     function addNFToken(address _to, uint256 _tokenId)
698         noOwnerExists(_tokenId)
699         internal
700     {
701         nft[_tokenId].owner = _to;
702         ownerToTokenList[_to].push(_tokenId);
703     }
704 
705 }
706 
707 
708 //@dev Implemention of NFT for WeTrust Spring
709 contract SpringNFT is NFToken{
710 
711 
712     //////////////////////////////
713     // Events
714     /////////////////////////////
715     event RecipientUpdate(bytes32 indexed recipientId, bytes32 updateId);
716 
717     //////////////////////////////
718     // Modifiers
719     /////////////////////////////
720 
721     /**
722      * @dev Guarrentees that recipient Exists
723      * @param id receipientId to check
724      */
725     modifier recipientExists(bytes32 id) {
726         require(recipients[id].exists, "Recipient Must exist");
727         _;
728     }
729 
730     /**
731      * @dev Guarrentees that recipient does not Exists
732      * @param id receipientId to check
733      */
734     modifier recipientDoesNotExists(bytes32 id) {
735         require(!recipients[id].exists, "Recipient Must not exists");
736         _;
737     }
738 
739     /**
740      * @dev Guarrentees that msg.sender is wetrust owned signer address
741      */
742     modifier onlyByWeTrustSigner() {
743         require(msg.sender == wetrustSigner, "sender must be from WeTrust Signer Address");
744         _;
745     }
746 
747     /**
748      * @dev Guarrentees that msg.sender is wetrust owned manager address
749      */
750     modifier onlyByWeTrustManager() {
751         require(msg.sender == wetrustManager, "sender must be from WeTrust Manager Address");
752         _;
753     }
754 
755     /**
756      * @dev Guarrentees that msg.sender is either wetrust recipient
757      * @param id receipientId to check
758      */
759     modifier onlyByWeTrustOrRecipient(bytes32 id) {
760         require(msg.sender == wetrustSigner || msg.sender == recipients[id].owner, "sender must be from WeTrust or Recipient's owner address");
761         _;
762     }
763 
764     /**
765      * @dev Guarrentees that contract is not in paused state
766      */
767     modifier onlyWhenNotPaused() {
768         require(!paused, "contract is currently in paused state");
769         _;
770     }
771 
772     //////////////////////////////
773     // Storage Variables
774     /////////////////////////////
775 
776     /**
777      * @dev wetrust controlled address that is used to create new NFTs
778      */
779     address public wetrustSigner;
780 
781     /**
782      *@dev wetrust controlled address that is used to switch the signer address
783      */
784     address public wetrustManager;
785 
786     /**
787      * @dev if paused is true, suspend most of contract's functionality
788      */
789     bool public paused;
790 
791     /**
792      * @dev mapping of recipients from WeTrust Spring platform
793      */
794     mapping(bytes32 => Recipient) public recipients;
795     /**
796      * @dev mapping to a list of updates made by recipients
797      */
798     mapping(bytes32 => Update[]) public recipientUpdates;
799 
800     /**
801      * @dev Stores the Artist signed Message who created the NFT
802      */
803     mapping (uint256 => bytes) public nftArtistSignature;
804 
805     struct Update {
806         bytes32 id;
807         uint256 createdAt;
808     }
809 
810     struct Recipient {
811         string name;
812         string url;
813         address owner;
814         uint256 nftCount;
815         bool exists;
816     }
817 
818     //////////////////////////////
819     // Public functions
820     /////////////////////////////
821 
822     /**
823      * @dev contract constructor
824      */
825     constructor (address signer, address manager) NFToken() public {
826         wetrustSigner = signer;
827         wetrustManager = manager;
828     }
829 
830     /**
831      * @dev Create a new NFT
832      * @param tokenId create new NFT with this tokenId
833      * @param receiver the owner of the new NFT
834      * @param recipientId The issuer of the NFT
835      * @param traits NFT Traits
836      * @param nftType Type of the NFT
837      */
838 
839     function createNFT(
840         uint256 tokenId,
841         address receiver,
842         bytes32 recipientId,
843         bytes32 traits,
844         bytes4 nftType)
845         noOwnerExists(tokenId)
846         onlyByWeTrustSigner
847         onlyWhenNotPaused public
848     {
849         mint(tokenId, receiver, recipientId, traits, nftType);
850     }
851 
852     /**
853      * @dev Allows anyone to redeem a token by providing a signed Message from Spring platform
854      * @param signedMessage A signed Message containing the NFT parameter from Spring platform
855      * The Signed Message must be concatenated in the following format
856      * - address to (the smart contract address)
857      * - uint256 tokenId
858      * - bytes4 nftType
859      * - bytes32 traits
860      * - bytes32 recipientId
861      * - bytes32 r of Signature
862      * - bytes32 s of Signature
863      * - uint8 v of Signature
864      */
865     function redeemToken(bytes signedMessage) onlyWhenNotPaused public {
866         address to;
867         uint256 tokenId;
868         bytes4 nftType;
869         bytes32 traits;
870         bytes32 recipientId;
871         bytes32 r;
872         bytes32 s;
873         byte vInByte;
874         uint8 v;
875         string memory prefix = "\x19Ethereum Signed Message:\n32";
876 
877         assembly {
878             to := mload(add(signedMessage, 32))
879             tokenId := mload(add(signedMessage, 64))
880             nftType := mload(add(signedMessage, 96)) // first 32 bytes are data padding
881             traits := mload(add(signedMessage, 100))
882             recipientId := mload(add(signedMessage, 132))
883             r := mload(add(signedMessage, 164))
884             s := mload(add(signedMessage, 196))
885             vInByte := mload(add(signedMessage, 228))
886         }
887         require(to == address(this), "This signed Message is not meant for this smart contract");
888         v = uint8(vInByte);
889         if (v < 27) {
890             v += 27;
891         }
892 
893         require(nft[tokenId].owner == address(0), "This token has been redeemed already");
894         bytes32 msgHash = createRedeemMessageHash(tokenId, nftType, traits, recipientId);
895         bytes32 preFixedMsgHash = keccak256(
896             abi.encodePacked(
897                 prefix,
898                 msgHash
899             ));
900 
901         address signer = ecrecover(preFixedMsgHash, v, r, s);
902 
903         require(signer == wetrustSigner, "WeTrust did not authorized this redeem script");
904         return mint(tokenId, msg.sender, recipientId, traits, nftType);
905     }
906 
907     /**
908      * @dev Add a new reciepient of WeTrust Spring
909      * @param recipientId Unique identifier of receipient
910      * @param name of the Recipient
911      * @param url link to the recipient's website
912      * @param owner Address owned by the recipient
913      */
914     function addRecipient(bytes32 recipientId, string name, string url, address owner)
915         onlyByWeTrustSigner
916         onlyWhenNotPaused
917         recipientDoesNotExists(recipientId)
918         public
919     {
920         require(bytes(name).length > 0, "name must not be empty string"); // no empty string
921 
922         recipients[recipientId].name = name;
923         recipients[recipientId].url = url;
924         recipients[recipientId].owner = owner;
925         recipients[recipientId].exists = true;
926     }
927 
928     /**
929      * @dev Add an link to the update the recipient had made
930      * @param recipientId The issuer of the update
931      * @param updateId unique id of the update
932      */
933     function addRecipientUpdate(bytes32 recipientId, bytes32 updateId)
934         onlyWhenNotPaused
935         recipientExists(recipientId)
936         onlyByWeTrustOrRecipient(recipientId)
937         public
938     {
939         recipientUpdates[recipientId].push(Update(updateId, now));
940         emit RecipientUpdate(recipientId, updateId);
941     }
942 
943     /**
944      * @dev Change recipient information
945      * @param recipientId to change
946      * @param name new name of the recipient
947      * @param url new link of the recipient
948      * @param owner new address owned by the recipient
949      */
950     function updateRecipientInfo(bytes32 recipientId, string name, string url, address owner)
951         onlyByWeTrustSigner
952         onlyWhenNotPaused
953         recipientExists(recipientId)
954         public
955     {
956         require(bytes(name).length > 0, "name must not be empty string"); // no empty string
957 
958         recipients[recipientId].name = name;
959         recipients[recipientId].url = url;
960         recipients[recipientId].owner = owner;
961     }
962 
963     /**
964      * @dev add a artist signed message for a particular NFT
965      * @param nftId NFT to add the signature to
966      * @param artistSignature Artist Signed Message
967      */
968     function addArtistSignature(uint256 nftId, bytes artistSignature) onlyByWeTrustSigner onlyWhenNotPaused public {
969         require(nftArtistSignature[nftId].length == 0, "Artist Signature already exist for this token"); // make sure no prior signature exists
970 
971         nftArtistSignature[nftId] = artistSignature;
972     }
973 
974     /**
975      * @dev Set whether or not the contract is paused
976      * @param _paused status to put the contract in
977      */
978     function setPaused(bool _paused) onlyByWeTrustManager public {
979         paused = _paused;
980     }
981 
982     /**
983      * @dev Transfer the WeTrust signer of NFT contract to a new address
984      * @param newAddress new WeTrust owned address
985      */
986     function changeWeTrustSigner(address newAddress) onlyWhenNotPaused onlyByWeTrustManager public {
987         wetrustSigner = newAddress;
988     }
989 
990     /**
991      * @dev Returns the number of updates recipients had made
992      * @param recipientId receipientId to check
993      */
994     function getUpdateCount(bytes32 recipientId) view public returns(uint256 count) {
995         return recipientUpdates[recipientId].length;
996     }
997 
998     /**
999      * @dev returns the message hash to be signed for redeem token
1000      * @param tokenId id of the token to be created
1001      * @param nftType Type of NFT to be created
1002      * @param traits Traits of NFT to be created
1003      * @param recipientId Issuer of the NFT
1004      */
1005     function createRedeemMessageHash(
1006         uint256 tokenId,
1007         bytes4 nftType,
1008         bytes32 traits,
1009         bytes32 recipientId)
1010         view public returns(bytes32 msgHash)
1011     {
1012         return keccak256(
1013             abi.encodePacked(
1014                 address(this),
1015                 tokenId,
1016                 nftType,
1017                 traits,
1018                 recipientId
1019             ));
1020     }
1021 
1022     /**
1023      * @dev Determines the edition of the NFT
1024      *      formula used to determine edition Size given the edition Number:
1025      *      f(x) = min(300x + 100, 5000)
1026      * using equation: g(x) = 150x^2 - 50x + 1 if x <= 16
1027      * else g(x) = 5000(x-16) - g(16)
1028      * maxEdition = 5000
1029      * @param nextNFTcount to determine edition for
1030      */
1031     function determineEdition(uint256 nextNFTcount) pure public returns (uint16 edition) {
1032         uint256 output;
1033         uint256 valueWhenXisSixteen = 37601; // g(16)
1034         if (nextNFTcount < valueWhenXisSixteen) {
1035             output = (sqrt(2500 + (600 * (nextNFTcount - 1))) + 50) / 300;
1036         } else {
1037             output = ((nextNFTcount - valueWhenXisSixteen) / 5000) + 16;
1038         }
1039 
1040         if (output > 5000) {
1041             output = 5000;
1042         }
1043 
1044         edition = uint16(output); // we don't have to worry about casting because output will always be less than or equal to 5000
1045     }
1046 
1047     /**
1048      * @dev set new host name for this nft contract
1049      * @param newHostName new host name to use
1050      */
1051     function setNFTContractInfo(string newHostName, string newName, string newSymbol) onlyByWeTrustManager external {
1052         hostname = newHostName;
1053         nftName = newName;
1054         nftSymbol = newSymbol;
1055     }
1056     //////////////////////////
1057     // Private Functions
1058     /////////////////////////
1059 
1060     /**
1061      * @dev Find the Square root of a number
1062      * @param x input
1063      * Credit goes to: https://ethereum.stackexchange.com/questions/2910/can-i-square-root-in-solidity
1064      */
1065 
1066     function sqrt(uint x) pure internal returns (uint y) {
1067         uint z = (x + 1) / 2;
1068         y = x;
1069         while (z < y) {
1070             y = z;
1071             z = (x / z + z) / 2;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Add the new NFT to the storage
1077      * @param receiver the owner of the new NFT
1078      * @param recipientId The issuer of the NFT
1079      * @param traits NFT Traits
1080      * @param nftType Type of the NFT
1081      */
1082     function mint(uint256 tokenId, address receiver, bytes32 recipientId, bytes32 traits, bytes4 nftType)
1083         recipientExists(recipientId)
1084         internal
1085     {
1086         nft[tokenId].owner = receiver;
1087         nft[tokenId].traits = traits;
1088         nft[tokenId].recipientId = recipientId;
1089         nft[tokenId].nftType = nftType;
1090         nft[tokenId].createdAt = now;
1091         nft[tokenId].edition = determineEdition(recipients[recipientId].nftCount + 1);
1092 
1093         recipients[recipientId].nftCount++;
1094         ownerToTokenList[receiver].push(tokenId);
1095 
1096         nftList.push(tokenId);
1097 
1098         emit Transfer(address(0), receiver, tokenId);
1099     }
1100 }
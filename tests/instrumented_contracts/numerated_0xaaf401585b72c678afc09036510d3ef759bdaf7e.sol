1 // Author: Nick Mudge <nick@perfectabstractions.com>
2 // Perfect Abstractions LLC
3 
4 pragma solidity 0.4.24;
5 
6 interface ERC721TokenReceiver {
7 
8 
9     /// @notice Handle the receipt of an NFT
10     /// @dev The ERC721 smart contract calls this function on the recipient
11     ///  after a `safetransfer`. This function MAY throw to revert and reject the
12     ///  transfer. This function MUST use 50,000 gas or less. Return of other
13     ///  than the magic value MUST result in the transaction being reverted.
14     ///  Note: the contract address is always the message sender.
15     /// @param _from The sending address
16     /// @param _tokenId The NFT identifier which is being transfered
17     /// @param _data Additional data with no specified format
18     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
19     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns (bytes4);
20 }
21 
22 /**
23  * @title ERC721 Non-Fungible Token Standard basic interface
24  * @dev see https://github.com/ethereum/eips/issues/721
25  */
26 interface ERC721 {
27     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
28     event Approval(address indexed _tokenOwner, address indexed _approved, uint256 indexed _tokenId);
29     event ApprovalForAll(address indexed _tokenOwner, address indexed _operator, bool _approved);
30 
31     function balanceOf(address _tokenOwner) external view returns (uint256 _balance);
32 
33     function ownerOf(uint256 _tokenId) external view returns (address _tokenOwner);
34 
35     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external;
36 
37     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
38 
39     function transferFrom(address _from, address _to, uint256 _tokenId) external;
40 
41     function approve(address _to, uint256 _tokenId) external;
42 
43     function setApprovalForAll(address _operator, bool _approved) external;
44 
45     function getApproved(uint256 _tokenId) external view returns (address _operator);
46 
47     function isApprovedForAll(address _tokenOwner, address _operator) external view returns (bool);
48 }
49 
50 interface ERC20AndERC223 {
51     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
52     function transfer(address to, uint value) external returns (bool success);
53     function transfer(address to, uint value, bytes data) external returns (bool success);
54 }
55 
56 
57 interface ERC998ERC721BottomUp {
58     function transferToParent(address _from, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) external;
59 
60 }
61 
62 contract AbstractMokens {
63     address public owner;
64 
65     struct Moken {
66         string name;
67         uint256 data;
68         uint256 parentTokenId;
69     }
70 
71     //tokenId to moken
72     mapping(uint256 => Moken) internal mokens;
73     uint256 internal mokensLength = 0;
74 
75     // tokenId => token API URL
76     string public defaultURIStart = "https://api.mokens.io/moken/";
77     string public defaultURIEnd = ".json";
78 
79     // the block number Mokens is deployed in
80     uint256 public blockNum;
81 
82     // index to era
83     mapping(uint256 => bytes32) internal eras;
84     uint256 internal eraLength = 0;
85     // era to index+1
86     mapping(bytes32 => uint256) internal eraIndex;
87 
88     uint256 public mintPriceOffset = 0 szabo;
89     uint256 public mintStepPrice = 500 szabo;
90     uint256 public mintPriceBuffer = 5000 szabo;
91 
92     /// @dev Magic value to be returned upon successful reception of an NFT
93     bytes4 constant ERC721_RECEIVED_NEW = 0x150b7a02;
94     bytes4 constant ERC721_RECEIVED_OLD = 0xf0b9e5ba;
95     bytes32 constant ERC998_MAGIC_VALUE = 0xcd740db5;
96 
97     uint256 constant UINT16_MASK = 0x000000000000000000000000000000000000000000000000000000000000ffff;
98     uint256 constant MOKEN_LINK_HASH_MASK = 0xffffffffffffffff000000000000000000000000000000000000000000000000;
99     uint256 constant MOKEN_DATA_MASK = 0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff;
100     uint256 constant MAX_MOKENS = 4294967296;
101     uint256 constant MAX_OWNER_MOKENS = 65536;
102 
103     // root token owner address => (tokenId => approved address)
104     mapping(address => mapping(uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
105 
106     // token owner => (operator address => bool)
107     mapping(address => mapping(address => bool)) internal tokenOwnerToOperators;
108 
109     // Mapping from owner to list of owned token IDs
110     mapping(address => uint32[]) internal ownedTokens;
111 
112     // child address => child tokenId => tokenId+1
113     mapping(address => mapping(uint256 => uint256)) internal childTokenOwner;
114 
115     // tokenId => (child address => array of child tokens)
116     mapping(uint256 => mapping(address => uint256[])) internal childTokens;
117 
118     // tokenId => (child address => (child token => child index)
119     mapping(uint256 => mapping(address => mapping(uint256 => uint256))) internal childTokenIndex;
120 
121     // tokenId => (child address => contract index)
122     mapping(uint256 => mapping(address => uint256)) internal childContractIndex;
123 
124     // tokenId => child contract
125     mapping(uint256 => address[]) internal childContracts;
126 
127     // tokenId => token contract
128     mapping(uint256 => address[]) internal erc20Contracts;
129 
130     // tokenId => (token contract => balance)
131     mapping(uint256 => mapping(address => uint256)) internal erc20Balances;
132 
133     // parent address => (parent tokenId => array of child tokenIds)
134     mapping(address => mapping(uint256 => uint32[])) internal parentToChildTokenIds;
135 
136     // tokenId => position in childTokens array
137     mapping(uint256 => uint256) internal tokenIdToChildTokenIdsIndex;
138 
139     address[] internal mintContracts;
140     mapping(address => uint256) internal mintContractIndex;
141 
142     //moken name to tokenId+1
143     mapping(string => uint256) internal tokenByName_;
144 
145     // tokenId => (token contract => token contract index)
146     mapping(uint256 => mapping(address => uint256)) erc20ContractIndex;
147 
148     // contract that contains other functions needed
149     address public delegate;
150 
151     mapping(bytes4 => bool) internal supportedInterfaces;
152 
153 
154     // Events
155     // ERC721
156     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
157     event Approval(address indexed _tokenOwner, address indexed _approved, uint256 indexed _tokenId);
158     event ApprovalForAll(address indexed _tokenOwner, address indexed _operator, bool _approved);
159     //ERC998ERC721TopDown
160     event ReceivedChild(address indexed _from, uint256 indexed _tokenId, address indexed _childContract, uint256 _childTokenId);
161     event TransferChild(uint256 indexed tokenId, address indexed _to, address indexed _childContract, uint256 _childTokenId);
162     //ERC998ERC20TopDown
163     event ReceivedERC20(address indexed _from, uint256 indexed _tokenId, address indexed _erc20Contract, uint256 _value);
164     event TransferERC20(uint256 indexed _tokenId, address indexed _to, address indexed _erc20Contract, uint256 _value);
165 
166     function isContract(address addr) internal view returns (bool) {
167         uint256 size;
168         assembly {size := extcodesize(addr)}
169         return size > 0;
170     }
171 
172     modifier onlyOwner() {
173         require(msg.sender == owner, "Must be the contract owner.");
174         _;
175     }
176 
177     /*
178     function getSize() external view returns (uint256) {
179         uint256 size;
180         address addr = address(this);
181         assembly {size := extcodesize(addr)}
182         return size;
183     }
184     */
185 
186     // Use Cases handled:
187     // Case 1: Token owner is this contract and token
188     // Case 2: Token owner is this contract and top-down composable.
189     // Case 3: Token owner is top-down composable
190     // Case 4: Token owner is an unknown contract
191     // Case 5: Token owner is a user
192     // Case 6: Token owner is a bottom-up composable
193     // Case 7: Token owner is ERC721 token owned by top-down token
194     // Case 8: Token owner is ERC721 token owned by unknown contract
195     // Case 9: Token owner is ERC721 token owned by user
196     function rootOwnerOf(uint256 _tokenId) public view returns (bytes32 rootOwner) {
197         address rootOwnerAddress = address(mokens[_tokenId].data);
198         require(rootOwnerAddress != address(0), "tokenId not found.");
199         uint256 parentTokenId;
200         bool isParent;
201 
202         while (rootOwnerAddress == address(this)) {
203             parentTokenId = mokens[_tokenId].parentTokenId;
204             isParent = parentTokenId > 0;
205             if(isParent) {
206                 // Case 1: Token owner is this contract and token
207                 _tokenId = parentTokenId - 1;
208             }
209             else {
210                 // Case 2: Token owner is this contract and top-down composable.
211                 _tokenId = childTokenOwner[rootOwnerAddress][_tokenId]-1;
212             }
213             rootOwnerAddress = address(mokens[_tokenId].data);
214         }
215 
216         parentTokenId = mokens[_tokenId].parentTokenId;
217         isParent = parentTokenId > 0;
218         if(isParent) {
219             parentTokenId--;
220         }
221 
222         bytes memory calldata;
223         bool callSuccess;
224 
225         if (isParent == false) {
226 
227             // success if this token is owned by a top-down token
228             // 0xed81cdda == rootOwnerOfChild(address,uint256)
229             calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
230             assembly {
231                 callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
232                 if callSuccess {
233                     rootOwner := mload(calldata)
234                 }
235             }
236             if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
237                 // Case 3: Token owner is top-down composable
238                 return rootOwner;
239             }
240             else {
241                 // Case 4: Token owner is an unknown contract
242                 // Or
243                 // Case 5: Token owner is a user
244                 return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
245             }
246         }
247         else {
248 
249             // 0x43a61a8e == rootOwnerOf(uint256)
250             calldata = abi.encodeWithSelector(0x43a61a8e, parentTokenId);
251             assembly {
252                 callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
253                 if callSuccess {
254                     rootOwner := mload(calldata)
255                 }
256             }
257             if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
258                 // Case 6: Token owner is a bottom-up composable
259                 // Or
260                 // Case 2: Token owner is top-down composable
261                 return rootOwner;
262             }
263             else {
264                 // token owner is ERC721
265                 address childContract = rootOwnerAddress;
266                 //0x6352211e == "ownerOf(uint256)"
267                 calldata = abi.encodeWithSelector(0x6352211e, parentTokenId);
268                 assembly {
269                     callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
270                     if callSuccess {
271                         rootOwnerAddress := mload(calldata)
272                     }
273                 }
274                 require(callSuccess, "Call to ownerOf failed");
275 
276                 // 0xed81cdda == rootOwnerOfChild(address,uint256)
277                 calldata = abi.encodeWithSelector(0xed81cdda, childContract, parentTokenId);
278                 assembly {
279                     callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
280                     if callSuccess {
281                         rootOwner := mload(calldata)
282                     }
283                 }
284                 if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
285                     // Case 7: Token owner is ERC721 token owned by top-down token
286                     return rootOwner;
287                 }
288                 else {
289                     // Case 8: Token owner is ERC721 token owned by unknown contract
290                     // Or
291                     // Case 9: Token owner is ERC721 token owned by user
292                     return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
293                 }
294             }
295         }
296     }
297 
298     // returns the owner at the top of the tree of composables
299     function rootOwnerOfChild(address _childContract, uint256 _childTokenId) public view returns (bytes32 rootOwner) {
300         uint256 tokenId;
301         if (_childContract != address(0)) {
302             tokenId = childTokenOwner[_childContract][_childTokenId];
303             require(tokenId != 0, "Child token does not exist");
304             tokenId--;
305         }
306         else {
307             tokenId = _childTokenId;
308         }
309         return rootOwnerOf(tokenId);
310     }
311 
312 
313     function childApproved(address _from, uint256 _tokenId) internal {
314         address approvedAddress = rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
315         if(msg.sender != _from) {
316             bytes32 tokenOwner;
317             bool callSuccess;
318             // 0xeadb80b8 == ownerOfChild(address,uint256)
319             bytes memory calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
320             assembly {
321                 callSuccess := staticcall(gas, _from, add(calldata, 0x20), mload(calldata), calldata, 0x20)
322                 if callSuccess {
323                     tokenOwner := mload(calldata)
324                 }
325             }
326             if(callSuccess == true) {
327                 require(tokenOwner >> 224 != ERC998_MAGIC_VALUE, "Token is child of top down composable");
328             }
329             require(tokenOwnerToOperators[_from][msg.sender] || approvedAddress == msg.sender, "msg.sender not _from/operator/approved.");
330         }
331         if (approvedAddress != address(0)) {
332             delete rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
333             emit Approval(_from, address(0), _tokenId);
334         }
335     }
336 
337     function _transferFrom(uint256 data, address _to, uint256 _tokenId) internal {
338         address _from = address(data);
339         //removing the tokenId
340         // 1. We replace _tokenId in ownedTokens[_from] with the last token id
341         //    in ownedTokens[_from]
342         uint256 lastTokenIndex = ownedTokens[_from].length - 1;
343         uint256 lastTokenId = ownedTokens[_from][lastTokenIndex];
344         if (lastTokenId != _tokenId) {
345             uint256 tokenIndex = data >> 160 & UINT16_MASK;
346             ownedTokens[_from][tokenIndex] = uint32(lastTokenId);
347             // 2. We set lastTokeId to point to its new position in ownedTokens[_from]
348             mokens[lastTokenId].data = mokens[lastTokenId].data & 0xffffffffffffffffffff0000ffffffffffffffffffffffffffffffffffffffff | tokenIndex << 160;
349         }
350         // 3. We remove lastTokenId from the end of ownedTokens[_from]
351         ownedTokens[_from].length--;
352 
353         //adding the tokenId
354         uint256 ownedTokensIndex = ownedTokens[_to].length;
355         // prevents 16 bit overflow
356         require(ownedTokensIndex < MAX_OWNER_MOKENS, "A token owner address cannot possess more than 65,536 mokens.");
357         mokens[_tokenId].data = data & 0xffffffffffffffffffff00000000000000000000000000000000000000000000 | ownedTokensIndex << 160 | uint256(_to);
358         ownedTokens[_to].push(uint32(_tokenId));
359 
360         emit Transfer(_from, _to, _tokenId);
361     }
362 
363 }
364 
365 // Author: Nick Mudge <nick@perfectabstractions.com>
366 // Perfect Abstractions LLC
367 
368 contract Mokens is AbstractMokens {
369 
370     constructor(address _delegate) public {
371         delegate = _delegate;
372         blockNum = block.number;
373         owner = msg.sender;
374         bytes32 startingEra = "Genesis";
375         bytes memory calldata = abi.encodeWithSignature("startNextEra(bytes32)", startingEra);
376         bool callSuccess;
377         assembly {
378             callSuccess := delegatecall(gas, _delegate, add(calldata, 0x20), mload(calldata), 0, 0)
379         }
380         require(callSuccess);
381 
382         //ERC165
383         supportedInterfaces[0x01ffc9a7] = true;
384         //ERC721
385         supportedInterfaces[0x80ac58cd] = true;
386         //ERC721Metadata
387         supportedInterfaces[0x5b5e139f] = true;
388         //ERC721Enumerable
389         supportedInterfaces[0x780e9d63] = true;
390         //onERC721Received new
391         supportedInterfaces[0x150b7a02] = true;
392         //onERC721Received old
393         supportedInterfaces[0xf0b9e5ba] = true;
394         //ERC998ERC721TopDown
395         supportedInterfaces[0x1efdf36a] = true;
396         //ERC998ERC721TopDownEnumerable
397         supportedInterfaces[0xa344afe4] = true;
398         //ERC998ERC20TopDown
399         supportedInterfaces[0x7294ffed] = true;
400         //ERC998ERC20TopDownEnumerable
401         supportedInterfaces[0xc5fd96cd] = true;
402         //ERC998ERC721BottomUp
403         supportedInterfaces[0xa1b23002] = true;
404         //ERC998ERC721BottomUpEnumerable
405         supportedInterfaces[0x8318b539] = true;
406     }
407 
408 
409     /******************************************************************************/
410     /******************************************************************************/
411     /******************************************************************************/
412     /* ERC165Impl ***********************************************************/
413     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
414         return supportedInterfaces[_interfaceID];
415     }
416 
417 
418     /******************************************************************************/
419     /******************************************************************************/
420     /******************************************************************************/
421     /* ERC721Impl  & ERC998 Authentication ****************************************/
422 
423     function balanceOf(address _tokenOwner) external view returns (uint256 totalMokensOwned) {
424         require(_tokenOwner != address(0), "Moken owner cannot be the 0 address.");
425         return ownedTokens[_tokenOwner].length;
426     }
427 
428     function ownerOf(uint256 _tokenId) external view returns (address tokenOwner) {
429         tokenOwner = address(mokens[_tokenId].data);
430         require(tokenOwner != address(0), "The tokenId does not exist.");
431         return tokenOwner;
432     }
433 
434     function approve(address _approved, uint256 _tokenId) external {
435         address rootOwner = address(rootOwnerOf(_tokenId));
436         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender], "Must be rootOwner or operator.");
437         rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] = _approved;
438         emit Approval(rootOwner, _approved, _tokenId);
439     }
440 
441     function getApproved(uint256 _tokenId) external view returns (address approvedAddress) {
442         address rootOwner = address(rootOwnerOf(_tokenId));
443         return rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
444     }
445 
446 
447     function setApprovalForAll(address _operator, bool _approved) external {
448         require(_operator != address(0), "Operator cannot be 0 address.");
449         tokenOwnerToOperators[msg.sender][_operator] = _approved;
450         emit ApprovalForAll(msg.sender, _operator, _approved);
451     }
452 
453     function isApprovedForAll(address _tokenOwner, address _operator) external view returns (bool approved) {
454         return tokenOwnerToOperators[_tokenOwner][_operator];
455     }
456 
457     function transferFrom(address _from, address _to, uint256 _tokenId) external {
458         require(_from != address(0), "_from cannot be the 0 address.");
459         require(_to != address(0), "_to cannot be the 0 address.");
460         uint256 data = mokens[_tokenId].data;
461         require(address(data) == _from, "The tokenId is not owned by _from.");
462         require(_to != address(this), "Cannot transfer to this contract.");
463         require(mokens[_tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
464         childApproved(_from, _tokenId);
465         _transferFrom(data, _to, _tokenId);
466     }
467 
468     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
469         require(_from != address(0), "_from cannot be the 0 address.");
470         require(_to != address(0), "_to cannot be the 0 address.");
471         uint256 data = mokens[_tokenId].data;
472         require(address(data) == _from, "The tokenId is not owned by _from.");
473         require(mokens[_tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
474         childApproved(_from, _tokenId);
475         _transferFrom(data, _to, _tokenId);
476         if (isContract(_to)) {
477             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, "");
478             require(retval == ERC721_RECEIVED_NEW, "_to contract cannot receive ERC721 tokens.");
479         }
480 
481     }
482 
483     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
484         require(_from != address(0), "_from cannot be the 0 address.");
485         require(_to != address(0), "_to cannot be the 0 address.");
486         uint256 data = mokens[_tokenId].data;
487         require(address(data) == _from, "The tokenId is not owned by _from.");
488         require(mokens[_tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
489         childApproved(_from, _tokenId);
490         _transferFrom(data, _to, _tokenId);
491 
492         if (_to == address(this)) {
493             require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the token to.");
494             uint256 toTokenId;
495             assembly {toTokenId := calldataload(164)}
496             if (_data.length < 32) {
497                 toTokenId = toTokenId >> 256 - _data.length * 8;
498             }
499             receiveChild(_from, toTokenId, _to, _tokenId);
500         }
501         else {
502             if (isContract(_to)) {
503                 bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
504                 require(retval == ERC721_RECEIVED_NEW, "_to contract cannot receive ERC721 tokens.");
505             }
506         }
507 
508     }
509 
510 
511 
512 
513     /******************************************************************************/
514     /******************************************************************************/
515     /******************************************************************************/
516     /* ERC721EnumerableImpl **************************************************/
517 
518     function exists(uint256 _tokenId) external view returns (bool) {
519         return _tokenId < mokensLength;
520     }
521 
522     function tokenOfOwnerByIndex(address _tokenOwner, uint256 _index) external view returns (uint256 tokenId) {
523         require(_index < ownedTokens[_tokenOwner].length, "_tokenOwner does not own a moken at this index.");
524         return ownedTokens[_tokenOwner][_index];
525     }
526 
527     function totalSupply() external view returns (uint256 totalMokens) {
528         return mokensLength;
529     }
530 
531     function tokenByIndex(uint256 _index) external view returns (uint256 tokenId) {
532         require(_index < mokensLength, "A tokenId at index does not exist.");
533         return _index;
534     }
535     /******************************************************************************/
536     /******************************************************************************/
537     /******************************************************************************/
538     /* ERC721MetadataImpl **************************************************/
539 
540     function name() external pure returns (string) {
541         return "Mokens";
542     }
543 
544     function symbol() external pure returns (string) {
545         return "MKN";
546     }
547 
548     /******************************************************************************/
549     /******************************************************************************/
550     /******************************************************************************/
551     /* Eras  **************************************************/
552 
553 
554     function eraByIndex(uint256 _index) external view returns (bytes32 era) {
555         require(_index < eraLength, "No era at this index.");
556         return eras[_index];
557     }
558 
559 
560     function eraByName(bytes32 _eraName) external view returns (uint256 indexOfEra) {
561         uint256 index = eraIndex[_eraName];
562         require(index != 0, "No era exists with this name.");
563         return index - 1;
564     }
565 
566     function currentEra() external view returns (bytes32 era) {
567         return eras[eraLength - 1];
568     }
569 
570     function currentEraIndex() external view returns (uint256 indexOfEra) {
571         return eraLength - 1;
572     }
573 
574     function eraExists(bytes32 _eraName) external view returns (bool) {
575         return eraIndex[_eraName] != 0;
576     }
577 
578     function totalEras() external view returns (uint256 totalEras_) {
579         return eraLength;
580     }
581 
582     /******************************************************************************/
583     /******************************************************************************/
584     /******************************************************************************/
585     /* Minting  **************************************************/
586     event Mint(
587         address indexed mintContract,
588         address indexed owner,
589         bytes32 indexed era,
590         string mokenName,
591         bytes32 data,
592         uint256 tokenId,
593         bytes32 currencyName,
594         uint256 price
595     );
596 
597 
598     event MintPriceChange(
599         uint256 mintPrice
600     );
601 
602     function mintData() external view returns (uint256 mokensLength_, uint256 mintStepPrice_, uint256 mintPriceOffset_) {
603         return (mokensLength, mintStepPrice, mintPriceOffset);
604     }
605 
606     function mintPrice() external view returns (uint256) {
607         return (mokensLength * mintStepPrice) - mintPriceOffset;
608     }
609 
610 
611     function mint(address _tokenOwner, string _mokenName, bytes32 _linkHash) external payable returns (uint256 tokenId) {
612 
613         require(_tokenOwner != address(0), "Owner cannot be the 0 address.");
614 
615         tokenId = mokensLength++;
616         // prevents 32 bit overflow
617         require(tokenId < MAX_MOKENS, "Only 4,294,967,296 mokens can be created.");
618         uint256 mintStepPrice_ = mintStepPrice;
619         uint256 mintPriceBuffer_ = mintPriceBuffer;
620 
621         //Was enough ether passed in?
622         uint256 currentMintPrice = (tokenId * mintStepPrice_) - mintPriceOffset;
623         uint256 pricePaid = currentMintPrice;
624         if (msg.value < currentMintPrice) {
625             require(mintPriceBuffer_ > currentMintPrice || msg.value > currentMintPrice - mintPriceBuffer_, "Paid ether is lower than mint price.");
626             pricePaid = msg.value;
627         }
628 
629         string memory lowerMokenName = validateAndLower(_mokenName);
630         require(tokenByName_[lowerMokenName] == 0, "Moken name already exists.");
631 
632         uint256 eraIndex_ = eraLength - 1;
633         uint256 ownedTokensIndex = ownedTokens[_tokenOwner].length;
634         // prevents 16 bit overflow
635         require(ownedTokensIndex < MAX_OWNER_MOKENS, "An single owner address cannot possess more than 65,536 mokens.");
636 
637         // adding the current era index, ownedTokenIndex and owner address to data
638         // this saves gas for each mint.
639         uint256 data = uint256(_linkHash) & MOKEN_LINK_HASH_MASK | eraIndex_ << 176 | ownedTokensIndex << 160 | uint160(_tokenOwner);
640 
641         // create moken
642         mokens[tokenId].name = _mokenName;
643         mokens[tokenId].data = data;
644         tokenByName_[lowerMokenName] = tokenId + 1;
645 
646         //add moken to the specific owner
647         ownedTokens[_tokenOwner].push(uint32(tokenId));
648 
649         //emit events
650         emit Transfer(address(0), _tokenOwner, tokenId);
651         emit Mint(this, _tokenOwner, eras[eraIndex_], _mokenName, bytes32(data), tokenId, "Ether", pricePaid);
652         emit MintPriceChange(currentMintPrice + mintStepPrice_);
653 
654         //send minter the change if any
655         if (msg.value > currentMintPrice) {
656             msg.sender.transfer(msg.value - currentMintPrice);
657         }
658 
659         return tokenId;
660     }
661 
662     function isMintContract(address _contract) public view returns (bool) {
663         return mintContractIndex[_contract] != 0;
664     }
665 
666     function totalMintContracts() external view returns (uint256 totalMintContracts_) {
667         return mintContracts.length;
668     }
669 
670     function mintContractByIndex(uint256 index) external view returns (address contract_) {
671         require(index < mintContracts.length, "Contract index does not exist.");
672         return mintContracts[index];
673     }
674 
675     // enables third-party contracts to mint mokens.
676     // enables the ability to accept other currency/tokens for payment.
677     function contractMint(address _tokenOwner, string _mokenName, bytes32 _linkHash, bytes32 _currencyName, uint256 _pricePaid) external returns (uint256 tokenId) {
678 
679         require(_tokenOwner != address(0), "Token owner cannot be the 0 address.");
680         require(isMintContract(msg.sender), "Not an approved mint contract.");
681 
682         tokenId = mokensLength++;
683         uint256 mokensLength_ = tokenId + 1;
684         // prevents 32 bit overflow
685         require(tokenId < MAX_MOKENS, "Only 4,294,967,296 mokens can be created.");
686 
687         string memory lowerMokenName = validateAndLower(_mokenName);
688         require(tokenByName_[lowerMokenName] == 0, "Moken name already exists.");
689 
690         uint256 eraIndex_ = eraLength - 1;
691         uint256 ownedTokensIndex = ownedTokens[_tokenOwner].length;
692         // prevents 16 bit overflow
693         require(ownedTokensIndex < MAX_OWNER_MOKENS, "An single token owner address cannot possess more than 65,536 mokens.");
694 
695         // adding the current era index, ownedTokenIndex and owner address to data
696         // this saves gas for each mint.
697         uint256 data = uint256(_linkHash) & MOKEN_LINK_HASH_MASK | eraIndex_ << 176 | ownedTokensIndex << 160 | uint160(_tokenOwner);
698 
699         // create moken
700         mokens[tokenId].name = _mokenName;
701         mokens[tokenId].data = data;
702         tokenByName_[lowerMokenName] = mokensLength_;
703 
704         //add moken to the specific owner
705         ownedTokens[_tokenOwner].push(uint32(tokenId));
706 
707         emit Transfer(address(0), _tokenOwner, tokenId);
708         emit Mint(msg.sender, _tokenOwner, eras[eraIndex_], _mokenName, bytes32(data), tokenId, _currencyName, _pricePaid);
709         emit MintPriceChange((mokensLength_ * mintStepPrice) - mintPriceOffset);
710 
711         return tokenId;
712     }
713 
714 
715     function validateAndLower(string _s) private pure returns (string mokenName) {
716         assembly {
717         // get length of _s
718             let len := mload(_s)
719         // get position of _s
720             let p := add(_s, 0x20)
721         // _s cannot be 0 characters
722             if eq(len, 0) {
723                 revert(0, 0)
724             }
725         // _s cannot be more than 100 characters
726             if gt(len, 100) {
727                 revert(0, 0)
728             }
729         // get first character
730             let b := byte(0, mload(add(_s, 0x20)))
731         // first character cannot be whitespace/unprintable
732             if lt(b, 0x21) {
733                 revert(0, 0)
734             }
735         // get last character
736             b := byte(0, mload(add(p, sub(len, 1))))
737         // last character cannot be whitespace/unprintable
738             if lt(b, 0x21) {
739                 revert(0, 0)
740             }
741         // loop through _s and lowercase uppercase characters
742             for {let end := add(p, len)}
743             lt(p, end)
744             {p := add(p, 1)}
745             {
746                 b := byte(0, mload(p))
747                 if lt(b, 0x5b) {
748                     if gt(b, 0x40) {
749                         mstore8(p, add(b, 32))
750                     }
751                 }
752             }
753         }
754         return _s;
755     }
756 
757     /******************************************************************************/
758     /******************************************************************************/
759     /******************************************************************************/
760     /* Mokens  **************************************************/
761 
762     function mokenNameExists(string _mokenName) external view returns (bool) {
763         return tokenByName_[validateAndLower(_mokenName)] != 0;
764     }
765 
766     function mokenId(string _mokenName) external view returns (uint256 tokenId) {
767         tokenId = tokenByName_[validateAndLower(_mokenName)];
768         require(tokenId != 0, "No moken exists with this name.");
769         return tokenId - 1;
770     }
771 
772     function mokenData(uint256 _tokenId) external view returns (bytes32 data) {
773         data = bytes32(mokens[_tokenId].data);
774         require(data != 0, "The tokenId does not exist.");
775         return data;
776     }
777 
778     function eraFromMokenData(bytes32 _data) public view returns (bytes32 era) {
779         return eras[uint256(_data) >> 176 & UINT16_MASK];
780     }
781 
782     function eraFromMokenData(uint256 _data) public view returns (bytes32 era) {
783         return eras[_data >> 176 & UINT16_MASK];
784     }
785 
786     function mokenEra(uint256 _tokenId) external view returns (bytes32 era) {
787         uint256 data = mokens[_tokenId].data;
788         require(data != 0, "The tokenId does not exist.");
789         return eraFromMokenData(data);
790     }
791 
792     function moken(uint256 _tokenId) external view
793     returns (string memory mokenName, bytes32 era, bytes32 data, address tokenOwner) {
794         data = bytes32(mokens[_tokenId].data);
795         require(data != 0, "The tokenId does not exist.");
796         return (
797         mokens[_tokenId].name,
798         eraFromMokenData(data),
799         data,
800         address(data)
801         );
802     }
803 
804     function mokenBytes32(uint256 _tokenId) external view
805     returns (bytes32 mokenNameBytes32, bytes32 era, bytes32 data, address tokenOwner) {
806         data = bytes32(mokens[_tokenId].data);
807         require(data != 0, "The tokenId does not exist.");
808         bytes memory mokenNameBytes = bytes(mokens[_tokenId].name);
809         require(mokenNameBytes.length != 0, "The tokenId does not exist.");
810         assembly {
811             mokenNameBytes32 := mload(add(mokenNameBytes, 32))
812         }
813         return (
814         mokenNameBytes32,
815         eraFromMokenData(data),
816         data,
817         address(data)
818         );
819     }
820 
821 
822     function mokenNoName(uint256 _tokenId) external view
823     returns (bytes32 era, bytes32 data, address tokenOwner) {
824         data = bytes32(mokens[_tokenId].data);
825         require(data != 0, "The tokenId does not exist.");
826         return (
827         eraFromMokenData(data),
828         data,
829         address(data)
830         );
831     }
832 
833     function mokenName(uint256 _tokenId) external view returns (string memory mokenName_) {
834         mokenName_ = mokens[_tokenId].name;
835         require(bytes(mokenName_).length != 0, "The tokenId does not exist.");
836         return mokenName_;
837     }
838 
839     function mokenNameBytes32(uint256 _tokenId) external view returns (bytes32 mokenNameBytes32_) {
840         bytes memory mokenNameBytes = bytes(mokens[_tokenId].name);
841         require(mokenNameBytes.length != 0, "The tokenId does not exist.");
842         assembly {
843             mokenNameBytes32_ := mload(add(mokenNameBytes, 32))
844         }
845         return mokenNameBytes32_;
846     }
847 
848 
849     function() external {
850         bytes memory data = msg.data;
851         assembly {
852             let result := delegatecall(gas, sload(delegate_slot), add(data, 0x20), mload(data), 0, 0)
853             let size := returndatasize
854             let ptr := mload(0x40)
855             returndatacopy(ptr, 0, size)
856             switch result
857             case 0 {revert(ptr, size)}
858             default {return (ptr, size)}
859         }
860     }
861 
862     // functions added here to reduce gas cost
863 
864     //////////////////////////////////////////////////////////
865     //ERC721 top down
866 
867     function receiveChild(address _from, uint256 _toTokenId, address _childContract, uint256 _childTokenId) internal {
868         require(address(mokens[_toTokenId].data) != address(0), "_tokenId does not exist.");
869         require(childTokenOwner[_childContract][_childTokenId] == 0, "Child token already received.");
870         uint256 childTokensLength = childTokens[_toTokenId][_childContract].length;
871         if (childTokensLength == 0) {
872             childContractIndex[_toTokenId][_childContract] = childContracts[_toTokenId].length;
873             childContracts[_toTokenId].push(_childContract);
874         }
875         childTokenIndex[_toTokenId][_childContract][_childTokenId] = childTokensLength;
876         childTokens[_toTokenId][_childContract].push(_childTokenId);
877         childTokenOwner[_childContract][_childTokenId] = _toTokenId + 1;
878         emit ReceivedChild(_from, _toTokenId, _childContract, _childTokenId);
879     }
880 
881     // this contract has to be approved first in _childContract
882     function getChild(address _from, uint256 _toTokenId, address _childContract, uint256 _childTokenId) external {
883         receiveChild(_from, _toTokenId, _childContract, _childTokenId);
884         require(_from == msg.sender ||
885         ERC721(_childContract).getApproved(_childTokenId) == msg.sender ||
886         ERC721(_childContract).isApprovedForAll(_from, msg.sender), "msg.sender is not owner/operator/approved for child token.");
887         ERC721(_childContract).transferFrom(_from, this, _childTokenId);
888     }
889 
890     function onERC721Received(address _from, uint256 _childTokenId, bytes _data) external returns (bytes4) {
891         require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
892         // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
893         uint256 toTokenId;
894         assembly {toTokenId := calldataload(132)}
895         if (_data.length < 32) {
896             toTokenId = toTokenId >> 256 - _data.length * 8;
897         }
898         receiveChild(_from, toTokenId, msg.sender, _childTokenId);
899         require(ERC721(msg.sender).ownerOf(_childTokenId) != address(0), "Child token not owned.");
900         return ERC721_RECEIVED_OLD;
901     }
902 
903 
904     function onERC721Received(address _operator, address _from, uint256 _childTokenId, bytes _data) external returns (bytes4) {
905         require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the child token to.");
906         // convert up to 32 bytes of_data to uint256, owner nft tokenId passed as uint in bytes
907         uint256 toTokenId;
908         assembly {toTokenId := calldataload(164)}
909         if (_data.length < 32) {
910             toTokenId = toTokenId >> 256 - _data.length * 8;
911         }
912         receiveChild(_from, toTokenId, msg.sender, _childTokenId);
913         require(ERC721(msg.sender).ownerOf(_childTokenId) != address(0), "Child token not owned.");
914         return ERC721_RECEIVED_NEW;
915     }
916 
917     function ownerOfChild(address _childContract, uint256 _childTokenId) external view returns (bytes32 parentTokenOwner, uint256 parentTokenId) {
918         parentTokenId = childTokenOwner[_childContract][_childTokenId];
919         require(parentTokenId != 0, "ERC721 token is not a child in this contract.");
920         parentTokenId--;
921         return (ERC998_MAGIC_VALUE << 224 | bytes32(address(mokens[parentTokenId].data)), parentTokenId);
922     }
923 
924     function childExists(address _childContract, uint256 _childTokenId) external view returns (bool) {
925         return childTokenOwner[_childContract][_childTokenId] != 0;
926     }
927 
928     function totalChildContracts(uint256 _tokenId) external view returns (uint256) {
929         return childContracts[_tokenId].length;
930     }
931 
932     function childContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address childContract) {
933         require(_index < childContracts[_tokenId].length, "Contract address does not exist for this token and index.");
934         return childContracts[_tokenId][_index];
935     }
936 
937     function totalChildTokens(uint256 _tokenId, address _childContract) external view returns (uint256) {
938         return childTokens[_tokenId][_childContract].length;
939     }
940 
941     function childTokenByIndex(uint256 _tokenId, address _childContract, uint256 _index) external view returns (uint256 childTokenId) {
942         require(_index < childTokens[_tokenId][_childContract].length, "Token does not own a child token at contract address and index.");
943         return childTokens[_tokenId][_childContract][_index];
944     }
945 
946 
947     //////////////////////////////////////////////////////////
948     //ERC20 top down
949     function balanceOfERC20(uint256 _tokenId, address _erc20Contract) external view returns (uint256) {
950         return erc20Balances[_tokenId][_erc20Contract];
951     }
952 
953     function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address) {
954         require(_index < erc20Contracts[_tokenId].length, "Contract address does not exist for this token and index.");
955         return erc20Contracts[_tokenId][_index];
956     }
957 
958     function totalERC20Contracts(uint256 _tokenId) external view returns (uint256) {
959         return erc20Contracts[_tokenId].length;
960     }
961 
962     //////////////////////////////////////////////////////////
963     //ERC721 bottom up
964 
965     function tokenOwnerOf(uint256 _tokenId) external view returns (bytes32 tokenOwner, uint256 parentTokenId, bool isParent) {
966         address tokenOwnerAddress = address(mokens[_tokenId].data);
967         require(tokenOwnerAddress != address(0), "tokenId not found.");
968         parentTokenId = mokens[_tokenId].parentTokenId;
969         isParent = parentTokenId > 0;
970         if (isParent) {
971             parentTokenId--;
972         }
973         return (ERC998_MAGIC_VALUE << 224 | bytes32(tokenOwnerAddress), parentTokenId, isParent);
974     }
975 
976 
977     function totalChildTokens(address _parentContract, uint256 _parentTokenId) public view returns (uint256) {
978         return parentToChildTokenIds[_parentContract][_parentTokenId].length;
979     }
980 
981     function childTokenByIndex(address _parentContract, uint256 _parentTokenId, uint256 _index) public view returns (uint256) {
982         require(parentToChildTokenIds[_parentContract][_parentTokenId].length > _index, "Child not found at index.");
983         return parentToChildTokenIds[_parentContract][_parentTokenId][_index];
984     }
985 }
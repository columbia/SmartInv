1 pragma solidity =0.8.0;
2 
3 // SPDX-License-Identifier: SimPL-2.0
4 
5 interface IERC165 {
6     /// @notice Query if a contract implements an interface
7     /// @param interfaceID The interface identifier, as specified in ERC-165
8     /// @dev Interface identification is specified in ERC-165. This function
9     ///  uses less than 30,000 gas.
10     /// @return `true` if the contract implements `interfaceID` and
11     ///  `interfaceID` is not 0xffffffff, `false` otherwise
12     function supportsInterface(bytes4 interfaceID) external view returns(bool);
13 }
14 
15 /// @title ERC-721 Non-Fungible Token Standard
16 /// @dev See https://eips.ethereum.org/EIPS/eip-721
17 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
18 interface IERC721 /* is ERC165 */ {
19     /// @dev This emits when ownership of any NFT changes by any mechanism.
20     ///  This event emits when NFTs are created (`from` == 0) and destroyed
21     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
22     ///  may be created and assigned without emitting Transfer. At the time of
23     ///  any transfer, the approved address for that NFT (if any) is reset to none.
24     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
25 
26     /// @dev This emits when the approved address for an NFT is changed or
27     ///  reaffirmed. The zero address indicates there is no approved address.
28     ///  When a Transfer event emits, this also indicates that the approved
29     ///  address for that NFT (if any) is reset to none.
30     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
31 
32     /// @dev This emits when an operator is enabled or disabled for an owner.
33     ///  The operator can manage all NFTs of the owner.
34     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
35 
36     /// @notice Count all NFTs assigned to an owner
37     /// @dev NFTs assigned to the zero address are considered invalid, and this
38     ///  function throws for queries about the zero address.
39     /// @param _owner An address for whom to query the balance
40     /// @return The number of NFTs owned by `_owner`, possibly zero
41     function balanceOf(address _owner) external view returns(uint256);
42 
43     /// @notice Find the owner of an NFT
44     /// @dev NFTs assigned to zero address are considered invalid, and queries
45     ///  about them do throw.
46     /// @param _tokenId The identifier for an NFT
47     /// @return The address of the owner of the NFT
48     function ownerOf(uint256 _tokenId) external view returns(address);
49 
50     /// @notice Transfers the ownership of an NFT from one address to another address
51     /// @dev Throws unless `msg.sender` is the current owner, an authorized
52     ///  operator, or the approved address for this NFT. Throws if `_from` is
53     ///  not the current owner. Throws if `_to` is the zero address. Throws if
54     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
55     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
56     ///  `onERC721Received` on `_to` and throws if the return value is not
57     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
58     /// @param _from The current owner of the NFT
59     /// @param _to The new owner
60     /// @param _tokenId The NFT to transfer
61     /// @param data Additional data with no specified format, sent in call to `_to`
62     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
63 
64     /// @notice Transfers the ownership of an NFT from one address to another address
65     /// @dev This works identically to the other function with an extra data parameter,
66     ///  except this function just sets data to "".
67     /// @param _from The current owner of the NFT
68     /// @param _to The new owner
69     /// @param _tokenId The NFT to transfer
70     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
71 
72     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
73     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
74     ///  THEY MAY BE PERMANENTLY LOST
75     /// @dev Throws unless `msg.sender` is the current owner, an authorized
76     ///  operator, or the approved address for this NFT. Throws if `_from` is
77     ///  not the current owner. Throws if `_to` is the zero address. Throws if
78     ///  `_tokenId` is not a valid NFT.
79     /// @param _from The current owner of the NFT
80     /// @param _to The new owner
81     /// @param _tokenId The NFT to transfer
82     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
83 
84     /// @notice Change or reaffirm the approved address for an NFT
85     /// @dev The zero address indicates there is no approved address.
86     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
87     ///  operator of the current owner.
88     /// @param _approved The new approved NFT controller
89     /// @param _tokenId The NFT to approve
90     function approve(address _approved, uint256 _tokenId) external payable;
91 
92     /// @notice Enable or disable approval for a third party ("operator") to manage
93     ///  all of `msg.sender`'s assets
94     /// @dev Emits the ApprovalForAll event. The contract MUST allow
95     ///  multiple operators per owner.
96     /// @param _operator Address to add to the set of authorized operators
97     /// @param _approved True if the operator is approved, false to revoke approval
98     function setApprovalForAll(address _operator, bool _approved) external;
99 
100     /// @notice Get the approved address for a single NFT
101     /// @dev Throws if `_tokenId` is not a valid NFT.
102     /// @param _tokenId The NFT to find the approved address for
103     /// @return The approved address for this NFT, or the zero address if there is none
104     function getApproved(uint256 _tokenId) external view returns(address);
105 
106     /// @notice Query if an address is an authorized operator for another address
107     /// @param _owner The address that owns the NFTs
108     /// @param _operator The address that acts on behalf of the owner
109     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
110     function isApprovedForAll(address _owner, address _operator) external view returns(bool);
111 }
112 
113 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
114 /// @dev See https://eips.ethereum.org/EIPS/eip-721
115 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
116 interface IERC721Metadata /* is ERC721 */ {
117     /// @notice A descriptive name for a collection of NFTs in this contract
118     function name() external view returns (string memory);
119     
120     /// @notice An abbreviated name for NFTs in this contract
121     function symbol() external view returns (string memory);
122     
123     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
124     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
125     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
126     ///  Metadata JSON Schema".
127     /// {"name":"","description":"","image":""}
128     function tokenURI(uint256 _tokenId) external view returns (string memory);
129 }
130 
131 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
132 interface IERC721TokenReceiver {
133     /// @notice Handle the receipt of an NFT
134     /// @dev The ERC721 smart contract calls this function on the recipient
135     ///  after a `transfer`. This function MAY throw to revert and reject the
136     ///  transfer. Return of other than the magic value MUST result in the
137     ///  transaction being reverted.
138     ///  Note: the contract address is always the message sender.
139     /// @param _operator The address which called `safeTransferFrom` function
140     /// @param _from The address which previously owned the token
141     /// @param _tokenId The NFT identifier which is being transferred
142     /// @param _data Additional data with no specified format
143     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
144     ///  unless throwing
145     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
146 }
147 
148 interface IERC721TokenReceiverEx is IERC721TokenReceiver {
149     // bytes4(keccak256("onERC721ExReceived(address,address,uint256[],bytes)")) = 0x0f7b88e3
150     function onERC721ExReceived(address operator, address from,
151         uint256[] memory tokenIds, bytes memory data)
152         external returns(bytes4);
153 }
154 
155 /**
156  * Utility library of inline functions on addresses
157  */
158 library Address {
159 
160     /**
161      * Returns whether the target address is a contract
162      * @dev This function will return false if invoked during the constructor of a contract,
163      * as the code is not actually created until after the constructor finishes.
164      * @param account address of the account to check
165      * @return whether the target address is a contract
166      */
167     function isContract(address account) internal view returns(bool) {
168         uint256 size;
169         // XXX Currently there is no better way to check if there is a contract in an address
170         // than to check the size of the code at that address.
171         // See https://ethereum.stackexchange.com/a/14016/36603
172         // for more details about how this works.
173         // TODO Check this again before the Serenity release, because all addresses will be
174         // contracts then.
175         // solium-disable-next-line security/no-inline-assembly
176         assembly { size := extcodesize(account) }
177         return size > 0;
178     }
179 }
180 
181 
182 library Bytes {
183     bytes internal constant BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
184     
185     function base64Encode(bytes memory bs) internal pure returns(string memory) {
186         uint256 remain = bs.length % 3;
187         uint256 length = bs.length / 3 * 4;
188         bytes memory result = new bytes(length + (remain != 0 ? 4 : 0) + (3 - remain) % 3);
189         
190         uint256 i = 0;
191         uint256 j = 0;
192         while (i < length) {
193             result[i++] = BASE64_CHARS[uint8(bs[j] >> 2)];
194             result[i++] = BASE64_CHARS[uint8((bs[j] & 0x03) << 4 | bs[j + 1] >> 4)];
195             result[i++] = BASE64_CHARS[uint8((bs[j + 1] & 0x0f) << 2 | bs[j + 2] >> 6)];
196             result[i++] = BASE64_CHARS[uint8(bs[j + 2] & 0x3f)];
197             
198             j += 3;
199         }
200         
201         if (remain != 0) {
202             result[i++] = BASE64_CHARS[uint8(bs[j] >> 2)];
203             
204             if (remain == 2) {
205                 result[i++] = BASE64_CHARS[uint8((bs[j] & 0x03) << 4 | bs[j + 1] >> 4)];
206                 result[i++] = BASE64_CHARS[uint8((bs[j + 1] & 0x0f) << 2)];
207                 result[i++] = BASE64_CHARS[0];
208                 result[i++] = 0x3d;
209             } else {
210                 result[i++] = BASE64_CHARS[uint8((bs[j] & 0x03) << 4)];
211                 result[i++] = BASE64_CHARS[0];
212                 result[i++] = BASE64_CHARS[0];
213                 result[i++] = 0x3d;
214                 result[i++] = 0x3d;
215             }
216         }
217         
218         return string(result);
219     }
220     
221     function concat(bytes memory a, bytes memory b)
222         internal pure returns(bytes memory) {
223         
224         uint256 al = a.length;
225         uint256 bl = b.length;
226         
227         bytes memory c = new bytes(al + bl);
228         
229         for (uint256 i = 0; i < al; ++i) {
230             c[i] = a[i];
231         }
232         
233         for (uint256 i = 0; i < bl; ++i) {
234             c[al + i] = b[i];
235         }
236         
237         return c;
238     }
239 }
240 
241 library String {
242     function equals(string memory a, string memory b)
243         internal pure returns(bool) {
244         
245         bytes memory ba = bytes(a);
246         bytes memory bb = bytes(b);
247         
248         uint256 la = ba.length;
249         uint256 lb = bb.length;
250         
251         for (uint256 i = 0; i < la && i < lb; ++i) {
252             if (ba[i] != bb[i]) {
253                 return false;
254             }
255         }
256         
257         return la == lb;
258     }
259     
260     function concat(string memory a, string memory b)
261         internal pure returns(string memory) {
262         
263         bytes memory ba = bytes(a);
264         bytes memory bb = bytes(b);
265         bytes memory bc = new bytes(ba.length + bb.length);
266         
267         uint256 bal = ba.length;
268         uint256 bbl = bb.length;
269         uint256 k = 0;
270         
271         for (uint256 i = 0; i < bal; ++i) {
272             bc[k++] = ba[i];
273         }
274         
275         for (uint256 i = 0; i < bbl; ++i) {
276             bc[k++] = bb[i];
277         }
278         
279         return string(bc);
280     }
281 }
282 
283 library UInteger {
284     function toString(uint256 a, uint256 radix)
285         internal pure returns(string memory) {
286         
287         if (a == 0) {
288             return "0";
289         }
290         
291         uint256 length = 0;
292         for (uint256 n = a; n != 0; n /= radix) {
293             ++length;
294         }
295         
296         bytes memory bs = new bytes(length);
297         
298         while (a != 0) {
299             uint256 b = a % radix;
300             a /= radix;
301             
302             if (b < 10) {
303                 bs[--length] = bytes1(uint8(b + 48));
304             } else {
305                 bs[--length] = bytes1(uint8(b + 87));
306             }
307         }
308         
309         return string(bs);
310     }
311     
312     function toString(uint256 a) internal pure returns(string memory) {
313         return UInteger.toString(a, 10);
314     }
315     
316     function max(uint256 a, uint256 b) internal pure returns(uint256) {
317         return a > b ? a : b;
318     }
319     
320     function min(uint256 a, uint256 b) internal pure returns(uint256) {
321         return a < b ? a : b;
322     }
323     
324     function shiftLeft(uint256 n, uint256 bits, uint256 shift)
325         internal pure returns(uint256) {
326         
327         require(n < (1 << bits), "shiftLeft overflow");
328         
329         return n << shift;
330     }
331     
332     function toDecBytes(uint256 n) internal pure returns(bytes memory) {
333         if (n == 0) {
334             return bytes("0");
335         }
336         
337         uint256 length = 0;
338         for (uint256 m = n; m > 0; m /= 10) {
339             ++length;
340         }
341         
342         bytes memory bs = new bytes(length);
343         
344         while (n > 0) {
345             uint256 m = n % 10;
346             n /= 10;
347             
348             bs[--length] = bytes1(uint8(m + 48));
349         }
350         
351         return bs;
352     }
353 }
354 
355 library Util {
356     bytes4 internal constant ERC721_RECEIVER_RETURN = 0x150b7a02;
357     bytes4 internal constant ERC721_RECEIVER_EX_RETURN = 0x0f7b88e3;
358 }
359 
360 abstract contract ContractOwner {
361     address immutable public contractOwner = msg.sender;
362     
363     modifier onlyContractOwner {
364         require(msg.sender == contractOwner, "only contract owner");
365         _;
366     }
367 }
368 
369 abstract contract ERC721 is IERC165, IERC721, IERC721Metadata {
370     using Address for address;
371     
372     /*
373      * bytes4(keccak256("supportsInterface(bytes4)")) == 0x01ffc9a7
374      */
375     bytes4 private constant INTERFACE_ID_ERC165 = 0x01ffc9a7;
376     
377     /*
378      *     bytes4(keccak256("balanceOf(address)")) == 0x70a08231
379      *     bytes4(keccak256("ownerOf(uint256)")) == 0x6352211e
380      *     bytes4(keccak256("approve(address,uint256)")) == 0x095ea7b3
381      *     bytes4(keccak256("getApproved(uint256)")) == 0x081812fc
382      *     bytes4(keccak256("setApprovalForAll(address,bool)")) == 0xa22cb465
383      *     bytes4(keccak256("isApprovedForAll(address,address)")) == 0xe985e9c5
384      *     bytes4(keccak256("transferFrom(address,address,uint256)")) == 0x23b872dd
385      *     bytes4(keccak256("safeTransferFrom(address,address,uint256)")) == 0x42842e0e
386      *     bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) == 0xb88d4fde
387      *
388      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
389      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
390      */
391     bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
392     
393     bytes4 private constant INTERFACE_ID_ERC721Metadata = 0x5b5e139f;
394     
395     string public override name;
396     string public override symbol;
397     
398     mapping(address => uint256[]) internal ownerTokens;
399     mapping(uint256 => uint256) internal tokenIndexs;
400     mapping(uint256 => address) internal tokenOwners;
401     
402     mapping(uint256 => address) internal tokenApprovals;
403     mapping(address => mapping(address => bool)) internal approvalForAlls;
404     
405     constructor(string memory _name, string memory _symbol) {
406         name = _name;
407         symbol = _symbol;
408     }
409     
410     function balanceOf(address owner) external view override returns(uint256) {
411         require(owner != address(0), "owner is zero address");
412         return ownerTokens[owner].length;
413     }
414     
415     // [startIndex, endIndex)
416     function tokensOf(address owner, uint256 startIndex, uint256 endIndex)
417         external view returns(uint256[] memory) {
418         
419         require(owner != address(0), "owner is zero address");
420         
421         uint256[] storage tokens = ownerTokens[owner];
422         if (endIndex == 0) {
423             endIndex = tokens.length;
424         }
425         
426         uint256[] memory result = new uint256[](endIndex - startIndex);
427         for (uint256 i = startIndex; i < endIndex; ++i) {
428             result[i - startIndex] = tokens[i];
429         }
430         
431         return result;
432     }
433     
434     function ownerOf(uint256 tokenId)
435         external view override returns(address) {
436         
437         address owner = tokenOwners[tokenId];
438         require(owner != address(0), "nobody own the token");
439         return owner;
440     }
441     
442     function safeTransferFrom(address from, address to, uint256 tokenId)
443             external payable override {
444         
445         safeTransferFrom(from, to, tokenId, "");
446     }
447     
448     function safeTransferFrom(address from, address to, uint256 tokenId,
449         bytes memory data) public payable override {
450         
451         _transferFrom(from, to, tokenId);
452         
453         if (to.isContract()) {
454             require(IERC721TokenReceiver(to)
455                 .onERC721Received(msg.sender, from, tokenId, data)
456                 == Util.ERC721_RECEIVER_RETURN,
457                 "onERC721Received() return invalid");
458         }
459     }
460     
461     function transferFrom(address from, address to, uint256 tokenId)
462         external payable override {
463         
464         _transferFrom(from, to, tokenId);
465     }
466     
467     function _transferFrom(address from, address to, uint256 tokenId)
468         internal {
469         
470         require(from != address(0), "from is zero address");
471         require(to != address(0), "to is zero address");
472         
473         require(from == tokenOwners[tokenId], "from must be owner");
474         
475         require(msg.sender == from
476             || msg.sender == tokenApprovals[tokenId]
477             || approvalForAlls[from][msg.sender],
478             "sender must be owner or approvaled");
479         
480         if (tokenApprovals[tokenId] != address(0)) {
481             delete tokenApprovals[tokenId];
482         }
483         
484         _removeTokenFrom(from, tokenId);
485         _addTokenTo(to, tokenId);
486         
487         emit Transfer(from, to, tokenId);
488     }
489     
490     // ensure everything is ok before call it
491     function _removeTokenFrom(address from, uint256 tokenId) internal {
492         uint256 index = tokenIndexs[tokenId];
493         
494         uint256[] storage tokens = ownerTokens[from];
495         uint256 indexLast = tokens.length - 1;
496         
497         // save gas
498         // if (index != indexLast) {
499             uint256 tokenIdLast = tokens[indexLast];
500             tokens[index] = tokenIdLast;
501             tokenIndexs[tokenIdLast] = index;
502         // }
503         
504         tokens.pop();
505         
506         // delete tokenIndexs[tokenId]; // save gas
507         delete tokenOwners[tokenId];
508     }
509     
510     // ensure everything is ok before call it
511     function _addTokenTo(address to, uint256 tokenId) internal {
512         uint256[] storage tokens = ownerTokens[to];
513         tokenIndexs[tokenId] = tokens.length;
514         tokens.push(tokenId);
515         
516         tokenOwners[tokenId] = to;
517     }
518     
519     function approve(address to, uint256 tokenId)
520         external payable override {
521         
522         address owner = tokenOwners[tokenId];
523         
524         require(msg.sender == owner
525             || approvalForAlls[owner][msg.sender],
526             "sender must be owner or approved for all"
527         );
528         
529         tokenApprovals[tokenId] = to;
530         emit Approval(owner, to, tokenId);
531     }
532     
533     function setApprovalForAll(address to, bool approved) external override {
534         approvalForAlls[msg.sender][to] = approved;
535         emit ApprovalForAll(msg.sender, to, approved);
536     }
537     
538     function getApproved(uint256 tokenId)
539         external view override returns(address) {
540         
541         require(tokenOwners[tokenId] != address(0),
542             "nobody own then token");
543         
544         return tokenApprovals[tokenId];
545     }
546     
547     function isApprovedForAll(address owner, address operator)
548         external view override returns(bool) {
549         
550         return approvalForAlls[owner][operator];
551     }
552     
553     function supportsInterface(bytes4 interfaceID)
554         external pure override returns(bool) {
555         
556         return interfaceID == INTERFACE_ID_ERC165
557             || interfaceID == INTERFACE_ID_ERC721
558             || interfaceID == INTERFACE_ID_ERC721Metadata;
559     }
560 }
561 
562 abstract contract ERC721Ex is ERC721 {
563     using Address for address;
564     using String for string;
565     using UInteger for uint256;
566     
567     uint256 public totalSupply = 0;
568     
569     string public uriPrefix;
570     
571     function _mint(address to, uint256 tokenId) internal {
572         _addTokenTo(to, tokenId);
573         
574         ++totalSupply;
575         
576         emit Transfer(address(0), to, tokenId);
577     }
578     
579     function _burn(uint256 tokenId) internal {
580         address owner = tokenOwners[tokenId];
581         _removeTokenFrom(owner, tokenId);
582         
583         if (tokenApprovals[tokenId] != address(0)) {
584             delete tokenApprovals[tokenId];
585         }
586         
587         emit Transfer(owner, address(0), tokenId);
588     }
589     
590     function safeBatchTransferFrom(address from, address to,
591         uint256[] memory tokenIds) external {
592         
593         safeBatchTransferFrom(from, to, tokenIds, "");
594     }
595     
596     function safeBatchTransferFrom(address from, address to,
597         uint256[] memory tokenIds, bytes memory data) public {
598         
599         batchTransferFrom(from, to, tokenIds);
600         
601         if (to.isContract()) {
602             require(IERC721TokenReceiverEx(to)
603                 .onERC721ExReceived(msg.sender, from, tokenIds, data)
604                 == Util.ERC721_RECEIVER_EX_RETURN,
605                 "onERC721ExReceived() return invalid");
606         }
607     }
608     
609     function batchTransferFrom(address from, address to,
610         uint256[] memory tokenIds) public {
611         
612         require(from != address(0), "from is zero address");
613         require(to != address(0), "to is zero address");
614         
615         address sender = msg.sender;
616         bool approval = from == sender || approvalForAlls[from][sender];
617         
618         for (uint256 i = 0; i < tokenIds.length; ++i) {
619             uint256 tokenId = tokenIds[i];
620 			
621             require(from == tokenOwners[tokenId], "from must be owner");
622             require(approval || sender == tokenApprovals[tokenId],
623                 "sender must be owner or approvaled");
624             
625             if (tokenApprovals[tokenId] != address(0)) {
626                 delete tokenApprovals[tokenId];
627             }
628             
629             _removeTokenFrom(from, tokenId);
630             _addTokenTo(to, tokenId);
631             
632             emit Transfer(from, to, tokenId);
633         }
634     }
635     
636     function tokenURI(uint256 cardId)
637         external view override returns(string memory) {
638         
639         return uriPrefix.concat(cardId.toString());
640     }
641 }
642 
643 contract Card is ERC721Ex, ContractOwner {
644     mapping(address => bool) public whiteList;
645     
646     constructor(string memory _name, string memory _symbol)
647         ERC721(_name, _symbol) {
648     }
649     
650     function setUriPrefix(string memory prefix) external onlyContractOwner {
651         uriPrefix = prefix;
652     }
653     
654     function setWhiteList(address account, bool enable) external onlyContractOwner {
655         whiteList[account] = enable;
656     }
657     
658     function mint(address to) external {
659         require(whiteList[msg.sender], "not in whiteList");
660         
661         _mint(to, totalSupply + 1);
662     }
663 }
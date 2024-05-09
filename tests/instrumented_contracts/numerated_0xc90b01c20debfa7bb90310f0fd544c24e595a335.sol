1 pragma solidity ^0.5.0;
2 
3 pragma solidity ^0.5.0;
4 
5 /// @title ERC-721 Non-Fungible Token Standard
6 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
8 interface ERC721Proxy /*is ERC165*/ {
9 
10     /// @notice Query if a contract implements an interface
11     /// @param interfaceID The interface identifier, as specified in ERC-165
12     /// @dev Interface identification is specified in ERC-165. This function
13     ///  uses less than 30,000 gas.
14     /// @return `true` if the contract implements `interfaceID` and
15     ///  `interfaceID` is not 0xffffffff, `false` otherwise
16     function supportsInterface(bytes4 interfaceID) external view returns (bool);
17 
18     /// @dev This emits when ownership of any NFT changes by any mechanism.
19     ///  This event emits when NFTs are created (`from` == 0) and destroyed
20     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
21     ///  may be created and assigned without emitting Transfer. At the time of
22     ///  any transfer, the approved address for that NFT (if any) is reset to none.
23     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
24 
25     /// @dev This emits when the approved address for an NFT is changed or
26     ///  reaffirmed. The zero address indicates there is no approved address.
27     ///  When a Transfer event emits, this also indicates that the approved
28     ///  address for that NFT (if any) is reset to none.
29     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
30 
31     /// @dev This emits when an operator is enabled or disabled for an owner.
32     ///  The operator can manage all NFTs of the owner.
33     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
34 
35     /// @notice Count all NFTs assigned to an owner
36     /// @dev NFTs assigned to the zero address are considered invalid, and this
37     ///  function throws for queries about the zero address.
38     /// @param _owner An address for whom to query the balance
39     /// @return The number of NFTs owned by `_owner`, possibly zero
40     function balanceOf(address _owner) external view returns (uint256);
41 
42     /// @notice Find the owner of an NFT
43     /// @param _tokenId The identifier for an NFT
44     /// @dev NFTs assigned to zero address are considered invalid, and queries
45     ///  about them do throw.
46     /// @return The address of the owner of the NFT
47     function ownerOf(uint256 _tokenId) external view returns (address);
48 
49     /// @notice Transfers the ownership of an NFT from one address to another address
50     /// @dev Throws unless `msg.sender` is the current owner, an authorized
51     ///  operator, or the approved address for this NFT. Throws if `_from` is
52     ///  not the current owner. Throws if `_to` is the zero address. Throws if
53     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
54     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
55     ///  `onERC721Received` on `_to` and throws if the return value is not
56     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
57     /// @param _from The current owner of the NFT
58     /// @param _to The new owner
59     /// @param _tokenId The NFT to transfer
60     /// @param data Additional data with no specified format, sent in call to `_to`
61     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;
62 
63     /// @notice Transfers the ownership of an NFT from one address to another address
64     /// @dev This works identically to the other function with an extra data parameter,
65     ///  except this function just sets data to ""
66     /// @param _from The current owner of the NFT
67     /// @param _to The new owner
68     /// @param _tokenId The NFT to transfer
69     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
70 
71     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
72     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
73     ///  THEY MAY BE PERMANENTLY LOST
74     /// @dev Throws unless `msg.sender` is the current owner, an authorized
75     ///  operator, or the approved address for this NFT. Throws if `_from` is
76     ///  not the current owner. Throws if `_to` is the zero address. Throws if
77     ///  `_tokenId` is not a valid NFT.
78     /// @param _from The current owner of the NFT
79     /// @param _to The new owner
80     /// @param _tokenId The NFT to transfer
81     function transferFrom(address _from, address _to, uint256 _tokenId) external;
82 
83     /// @notice Set or reaffirm the approved address for an NFT
84     /// @dev The zero address indicates there is no approved address.
85     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
86     ///  operator of the current owner.
87     /// @param _approved The new approved NFT controller
88     /// @param _tokenId The NFT to approve
89     function approve(address _approved, uint256 _tokenId) external;
90 
91     /// @notice Enable or disable approval for a third party ("operator") to manage
92     ///  all your asset.
93     /// @dev Emits the ApprovalForAll event
94     /// @param _operator Address to add to the set of authorized operators.
95     /// @param _approved True if the operators is approved, false to revoke approval
96     function setApprovalForAll(address _operator, bool _approved) external;
97 
98     /// @notice Get the approved address for a single NFT
99     /// @dev Throws if `_tokenId` is not a valid NFT
100     /// @param _tokenId The NFT to find the approved address for
101     /// @return The approved address for this NFT, or the zero address if there is none
102     function getApproved(uint256 _tokenId) external view returns (address);
103 
104     /// @notice Query if an address is an authorized operator for another address
105     /// @param _owner The address that owns the NFTs
106     /// @param _operator The address that acts on behalf of the owner
107     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
108     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
109 
110 
111     /// @notice A descriptive name for a collection of NFTs in this contract
112     function name() external view returns (string memory _name);
113 
114     /// @notice An abbreviated name for NFTs in this contract
115     function symbol() external view returns (string memory _symbol);
116 
117 
118     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
119     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
120     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
121     ///  Metadata JSON Schema".
122     function tokenURI(uint256 _tokenId) external view returns (string memory);
123 
124     /// @notice Count NFTs tracked by this contract
125     /// @return A count of valid NFTs tracked by this contract, where each one of
126     ///  them has an assigned and queryable owner not equal to the zero address
127     function totalSupply() external view returns (uint256);
128 
129     /// @notice Enumerate valid NFTs
130     /// @dev Throws if `_index` >= `totalSupply()`.
131     /// @param _index A counter less than `totalSupply()`
132     /// @return The token identifier for the `_index`th NFT,
133     ///  (sort order not specified)
134     function tokenByIndex(uint256 _index) external view returns (uint256);
135 
136     /// @notice Enumerate NFTs assigned to an owner
137     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
138     ///  `_owner` is the zero address, representing invalid NFTs.
139     /// @param _owner An address where we are interested in NFTs owned by them
140     /// @param _index A counter less than `balanceOf(_owner)`
141     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
142     ///   (sort order not specified)
143     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
144 
145     /// @notice Transfers a Token to another address. When transferring to a smart
146     ///  contract, ensure that it is aware of ERC-721, otherwise the Token may be lost forever.
147     /// @param _to The address of the recipient, can be a user or contract.
148     /// @param _tokenId The ID of the Token to transfer.
149     function transfer(address _to, uint256 _tokenId) external;
150 
151     function onTransfer(address _from, address _to, uint256 _nftIndex) external;
152 }
153 
154 pragma solidity ^0.5.0;
155 
156 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
157 /// @author https://BlockChainArchitect.io
158 interface UriProviderInterface
159 {
160     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
161     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
162     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
163     ///  Metadata JSON Schema".
164     function tokenURI(uint256 _tokenId) external view returns (string memory infoUrl);
165 }
166 
167 pragma solidity ^0.5.0;
168 
169 interface BlockchainCutiesERC1155Interface
170 {
171     function mintNonFungibleSingleShort(uint128 _type, address _to) external;
172     function mintNonFungibleSingle(uint256 _type, address _to) external;
173     function mintNonFungibleShort(uint128 _type, address[] calldata _to) external;
174     function mintNonFungible(uint256 _type, address[] calldata _to) external;
175     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;
176     function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;
177     function isNonFungible(uint256 _id) external pure returns(bool);
178     function ownerOf(uint256 _id) external view returns (address);
179     function totalSupplyNonFungible(uint256 _type) view external returns (uint256);
180     function totalSupplyNonFungibleShort(uint128 _type) view external returns (uint256);
181 
182     /**
183         @notice A distinct Uniform Resource Identifier (URI) for a given token.
184         @dev URIs are defined in RFC 3986.
185         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
186         @return URI string
187     */
188     function uri(uint256 _id) external view returns (string memory);
189     function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
190     function proxyTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) external;
191     /**
192         @notice Get the balance of an account's Tokens.
193         @param _owner  The address of the token holder
194         @param _id     ID of the Token
195         @return        The _owner's balance of the Token type requested
196      */
197     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
198     /**
199         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
200         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
201         MUST revert if `_to` is the zero address.
202         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
203         MUST revert on any other error.
204         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
205         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
206         @param _from    Source address
207         @param _to      Target address
208         @param _id      ID of the token type
209         @param _value   Transfer amount
210         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
211     */
212     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
213 }
214 
215 pragma solidity ^0.5.0;
216 
217 contract Operators
218 {
219     mapping (address=>bool) ownerAddress;
220     mapping (address=>bool) operatorAddress;
221 
222     constructor() public
223     {
224         ownerAddress[msg.sender] = true;
225     }
226 
227     modifier onlyOwner()
228     {
229         require(ownerAddress[msg.sender]);
230         _;
231     }
232 
233     function isOwner(address _addr) public view returns (bool) {
234         return ownerAddress[_addr];
235     }
236 
237     function addOwner(address _newOwner) external onlyOwner {
238         require(_newOwner != address(0));
239 
240         ownerAddress[_newOwner] = true;
241     }
242 
243     function removeOwner(address _oldOwner) external onlyOwner {
244         delete(ownerAddress[_oldOwner]);
245     }
246 
247     modifier onlyOperator() {
248         require(isOperator(msg.sender));
249         _;
250     }
251 
252     function isOperator(address _addr) public view returns (bool) {
253         return operatorAddress[_addr] || ownerAddress[_addr];
254     }
255 
256     function addOperator(address _newOperator) external onlyOwner {
257         require(_newOperator != address(0));
258 
259         operatorAddress[_newOperator] = true;
260     }
261 
262     function removeOperator(address _oldOperator) external onlyOwner {
263         delete(operatorAddress[_oldOperator]);
264     }
265 }
266 
267 
268 contract Proxy721_1155 is ERC721Proxy, Operators {
269 
270     BlockchainCutiesERC1155Interface public erc1155;
271     UriProviderInterface public uriProvider;
272     uint256 public nftType;
273     string public nftName;
274     string public nftSymbol;
275     bool public canSetup = true;
276 
277     // The top bit is a flag to tell if this is a NFI.
278     uint256 constant public TYPE_NF_BIT = 1 << 255;
279 
280     modifier canBeStoredIn128Bits(uint256 _value)
281     {
282         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
283         _;
284     }
285 
286     function setup(
287         BlockchainCutiesERC1155Interface _erc1155,
288         UriProviderInterface _uriProvider,
289         uint256 _nftType,
290         string calldata _nftSymbol,
291         string calldata _nftName) external onlyOwner canBeStoredIn128Bits(_nftType)
292     {
293         require(canSetup);
294         erc1155 = _erc1155;
295         uriProvider = _uriProvider;
296         nftType = (_nftType << 128) | TYPE_NF_BIT;
297         nftSymbol = _nftSymbol;
298         nftName = _nftName;
299     }
300 
301     function disableSetup() external onlyOwner
302     {
303         canSetup = false;
304     }
305 
306     /// @notice A descriptive name for a collection of NFTs in this contract
307     function name() external view returns (string memory)
308     {
309         return nftName;
310     }
311 
312     /// @notice An abbreviated name for NFTs in this contract
313     function symbol() external view returns (string memory)
314     {
315         return nftSymbol;
316     }
317 
318     /// @notice Count all NFTs assigned to an owner
319     /// @dev NFTs assigned to the zero address are considered invalid, and this
320     ///  function throws for queries about the zero address.
321     /// @param _owner An address for whom to query the balance
322     /// @return The number of NFTs owned by `_owner`, possibly zero
323     function balanceOf(address _owner) external view returns (uint256 balance)
324     {
325         require(_owner != address(0x0));
326         balance = 0;
327         uint total = erc1155.totalSupplyNonFungible(nftType);
328         for (uint index = 1; index <= total; index++)
329         {
330             if (_ownerOf(index) == _owner)
331             {
332                 balance++;
333             }
334         }
335     }
336 
337     /// @notice Find the owner of an NFT
338     /// @param _tokenIndex The index for an NFT with type nftType
339     /// @dev NFTs assigned to zero address are considered invalid, and queries
340     ///  about them do throw.
341     /// @return The address of the owner of the NFT
342     function ownerOf(uint256 _tokenIndex) external view returns (address)
343     {
344         return _ownerOf(_tokenIndex);
345     }
346 
347     function _ownerOf(uint256 _tokenIndex) internal view returns (address)
348     {
349         return erc1155.ownerOf(_indexToId(_tokenIndex));
350     }
351 
352     function _indexToId(uint256 _tokenIndex) internal view canBeStoredIn128Bits(_tokenIndex) returns (uint256)
353     {
354         return nftType | _tokenIndex;
355     }
356 
357     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
358     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
359     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
360     ///  Metadata JSON Schema".
361     function tokenURI(uint256 _tokenIndex) external view canBeStoredIn128Bits(_tokenIndex) returns (string memory)
362     {
363         return uriProvider.tokenURI(_tokenIndex);
364     }
365 
366     /// @notice Count NFTs tracked by this contract
367     /// @return A count of valid NFTs tracked by this contract, where each one of
368     ///  them has an assigned and queryable owner not equal to the zero address
369     function totalSupply() external view returns (uint256)
370     {
371         return _totalSupply();
372     }
373 
374     function _totalSupply() internal view returns (uint256)
375     {
376         return erc1155.totalSupplyNonFungible(nftType);
377     }
378 
379     /// @notice Enumerate valid NFTs
380     /// @dev Throws if `_index` >= `totalSupply()`.
381     /// @param _index A counter less than `totalSupply()`
382     /// @return The token identifier for the `_index`th NFT,
383     ///  (sort order not specified)
384     function tokenByIndex(uint256 _index) external view returns (uint256)
385     {
386         require(_index < _totalSupply());
387         return _index - 1;
388     }
389 
390     /// @notice Enumerate NFTs assigned to an owner
391     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
392     ///  `_owner` is the zero address, representing invalid NFTs.
393     /// @param _owner An address where we are interested in NFTs owned by them
394     /// @param _index A counter less than `balanceOf(_owner)`
395     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
396     ///   (sort order not specified)
397     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenIndex)
398     {
399         require(_owner != address(0x0));
400         uint40 count = 0;
401         for (uint40 i = 1; i <= _totalSupply(); ++i) {
402             if (_ownerOf(i) == _owner) {
403                 if (count == _index) {
404                     return i;
405                 } else {
406                     count++;
407                 }
408             }
409         }
410         revert();
411     }
412 
413     /// @notice Transfers a Token to another address. When transferring to a smart
414     ///  contract, ensure that it is aware of ERC-721,
415     /// otherwise the Token may be lost forever.
416     /// @param _to The address of the recipient, can be a user or contract.
417     /// @param _tokenIndex The ID of the Token to transfer.
418     function transfer(address _to, uint256 _tokenIndex) external
419     {
420         _transfer(msg.sender, _to, _tokenIndex, "");
421     }
422 
423     function _transfer(address _from, address _to, uint256 _tokenIndex, bytes memory data) internal
424     {
425         erc1155.proxyTransfer721(_from, _to, _indexToId(_tokenIndex), data);
426     }
427 
428     function onTransfer(address _from, address _to, uint256 _nftIndex) external {
429         require(msg.sender == address(erc1155));
430         emit Transfer(_from, _to, _nftIndex);
431     }
432 
433     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata =
434         bytes4(keccak256('name()')) ^
435         bytes4(keccak256('symbol()')) ^
436         bytes4(keccak256('tokenURI(uint256)'));
437 
438     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Enumerable =
439         bytes4(keccak256('totalSupply()')) ^
440         bytes4(keccak256('tokenByIndex(uint256)')) ^
441         bytes4(keccak256('tokenOfOwnerByIndex(address, uint256)'));
442 
443     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
444         return
445         interfaceID == 0x6466353c ||
446         interfaceID == 0x80ac58cd || // ERC721
447         interfaceID == INTERFACE_SIGNATURE_ERC721Metadata ||
448         interfaceID == INTERFACE_SIGNATURE_ERC721Enumerable ||
449         interfaceID == bytes4(keccak256('supportsInterface(bytes4)'));
450     }
451 
452     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external {
453         _transfer(_from, _to, _tokenId, data);
454     }
455 
456     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
457         _transfer(_from, _to, _tokenId, "");
458     }
459 
460     function transferFrom(address _from, address _to, uint256 _tokenId) external {
461         _transfer(_from, _to, _tokenId, "");
462     }
463 
464     function approve(address, uint256) external {
465         revert();
466     }
467 
468     function setApprovalForAll(address, bool) external {
469         revert();
470     }
471 
472     function getApproved(uint256) external view returns (address) {
473         return address(0x0);
474     }
475 
476     function isApprovedForAll(address, address) external view returns (bool) {
477         return false;
478     }
479 }
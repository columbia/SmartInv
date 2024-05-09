1 // File: BossQueens.sol
2 
3 
4 // File: contracts/PixelKingdomsQuest.sol
5 
6 // pixel kingdoms is not a game
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 pragma solidity ^0.8.0;
10 abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}
11 function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
12 
13 // File: @openzeppelin/contracts/utils/Counters.sol
14 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
15 pragma solidity ^0.8.0;
16 library Counters {struct Counter {uint256 _value;}
17 function current(Counter storage counter) internal view returns (uint256) {return counter._value;}
18 function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
19 function decrement(Counter storage counter) internal {uint256 value = counter._value; require(value > 0, "Counter: decrement overflow"); unchecked {counter._value = value - 1;}}
20 function reset(Counter storage counter) internal {counter._value = 0;}}
21 
22 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
23 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
24 abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); constructor() {_transferOwnership(_msgSender());}
25 function owner() public view virtual returns (address) {return _owner;}
26 modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner");_;}
27 function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
28 function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");_transferOwnership(newOwner);}
29 function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
30 
31 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
32 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
33 library Strings {bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 function toString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0";} uint256 temp = value; uint256 digits;
35 while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits); 
36 while (value != 0) { digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
37 function toHexString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0;
38 while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
39 function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
40 bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x"; for (uint256 i = 2 * length + 1; i > 1; --i) { buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;}
41 require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
44 interface IERC165 {function supportsInterface(bytes4 interfaceId) external view returns (bool);}
45 
46 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
47 interface IERC721 is IERC165 {
48 event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49 event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 function balanceOf(address owner) external view returns (uint256 balance);
52 function ownerOf(uint256 tokenId) external view returns (address owner);
53 function safeTransferFrom(address from, address to, uint256 tokenId) external;
54 function transferFrom(address from, address to, uint256 tokenId) external;
55 function approve(address to, uint256 tokenId) external;
56 function getApproved(uint256 tokenId) external view returns (address operator);
57 function setApprovalForAll(address operator, bool _approved) external;
58 function isApprovedForAll(address owner, address operator) external view returns (bool);
59 function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;}
60 
61 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
62 interface IERC721Receiver {function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
63 
64 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
65 interface IERC721Metadata is IERC721 {
66 function name() external view returns (string memory);
67 function symbol() external view returns (string memory);
68 function tokenURI(uint256 tokenId) external view returns (string memory);}
69 
70 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
71 interface IERC721Enumerable is IERC721 {
72 function totalSupply() external view returns (uint256);
73 function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
74 function tokenByIndex(uint256 index) external view returns (uint256);}
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
77 library Address {
78 function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
79 function sendValue(address payable recipient, uint256 amount) internal {
80 require(address(this).balance >= amount, "Address: insufficient balance"); (bool success, ) = recipient.call{value: amount}("");
81 require(success, "Address: unable to send value, recipient may have reverted");}
82 function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
83 function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
84 function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
85 function functionCallWithValue(address target, bytes memory data, uint256 value,string memory errorMessage) internal returns (bytes memory) {
86 require(address(this).balance >= value, "Address: insufficient balance for call");
87 require(isContract(target), "Address: call to non-contract");(bool success, bytes memory returndata) = target.call{value: value}(data); return verifyCallResult(success, returndata, errorMessage);}
88 function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}
89 function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
90 require(isContract(target), "Address: static call to non-contract");(bool success, bytes memory returndata) = target.staticcall(data); return verifyCallResult(success, returndata, errorMessage);}
91 function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
92 function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93 require(isContract(target), "Address: delegate call to non-contract");(bool success, bytes memory returndata) = target.delegatecall(data); return verifyCallResult(success, returndata, errorMessage);}
94 function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
95 if (success) {return returndata;} else {if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}} else {revert(errorMessage);}}}}
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
98 abstract contract ERC165 is IERC165 {
99 function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == type(IERC165).interfaceId;}}
100 
101 // File contracts/ERC721A.sol
102 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
103 using Address for address;
104 using Strings for uint256;
105 struct TokenOwnership {address addr; uint64 startTimestamp;}
106 struct AddressData {uint128 balance; uint128 numberMinted;}
107 uint256 internal currentIndex = 0;
108 string private _name;
109 string private _symbol;
110 mapping(uint256 => TokenOwnership) internal _ownerships;
111 mapping(address => AddressData) private _addressData;
112 mapping(uint256 => address) private _tokenApprovals;
113 mapping(address => mapping(address => bool)) private _operatorApprovals;
114 constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
115 function totalSupply() public view override returns (uint256) {return currentIndex;}
116 function tokenByIndex(uint256 index) public view override returns (uint256) {require(index < totalSupply(), 'ERC721A: global index out of bounds');return index;}
117 function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
118 require(index < balanceOf(owner), 'ERC721A: owner index out of bounds'); uint256 numMintedSoFar = totalSupply(); uint256 tokenIdsIdx = 0; address currOwnershipAddr = address(0);
119     for (uint256 i = 0; i < numMintedSoFar; i++) {TokenOwnership memory ownership = _ownerships[i]; if (ownership.addr != address(0)) {currOwnershipAddr = ownership.addr;}
120     if (currOwnershipAddr == owner) {if (tokenIdsIdx == index) {return i;} tokenIdsIdx++;}} revert('ERC721A: unable to get token of owner by index');}
121 function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {return
122     interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);}
123 function balanceOf(address owner) public view override returns (uint256) {require(owner != address(0), 'ERC721A: balance query for the zero address'); return uint256(_addressData[owner].balance);}
124 function _numberMinted(address owner) internal view returns (uint256) {require(owner != address(0), 'ERC721A: number minted query for the zero address'); return uint256(_addressData[owner].numberMinted);}
125 function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
126     for (uint256 curr = tokenId; ; curr--) {TokenOwnership memory ownership = _ownerships[curr]; if (ownership.addr != address(0)) {return ownership;}} revert('ERC721A: unable to determine the owner of token');}
127 function ownerOf(uint256 tokenId) public view override returns (address) {return ownershipOf(tokenId).addr;}
128 function name() public view virtual override returns (string memory) {return _name;}
129 function symbol() public view virtual override returns (string memory) {return _symbol;}
130 function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token'); string memory baseURI = _baseURI();
131     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';}
132 function _baseURI() internal view virtual returns (string memory) {return '';}
133 function approve(address to, uint256 tokenId) public override {address owner = ERC721A.ownerOf(tokenId);
134     require(to != owner, 'ERC721A: approval to current owner');
135     require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721A: approve caller is not owner nor approved for all'); _approve(to, tokenId, owner);}
136 function getApproved(uint256 tokenId) public view override returns (address) {require(_exists(tokenId), 'ERC721A: approved query for nonexistent token'); return _tokenApprovals[tokenId];}
137 function setApprovalForAll(address operator, bool approved) public override {require(operator != _msgSender(), 'ERC721A: approve to caller');
138     _operatorApprovals[_msgSender()][operator] = approved; emit ApprovalForAll(_msgSender(), operator, approved);}
139 function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
140 function transferFrom(address from, address to, uint256 tokenId) public override {_transfer(from, to, tokenId);}
141 function safeTransferFrom(address from, address to, uint256 tokenId) public override {safeTransferFrom(from, to, tokenId, '');}
142 function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override {_transfer(from, to, tokenId);
143     require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721A: transfer to non ERC721Receiver implementer');}
144 function _exists(uint256 tokenId) internal view returns (bool) {return tokenId < currentIndex;}
145 function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
146 function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = currentIndex;
147     require(to != address(0), 'ERC721A: mint to the zero address');
148     require(!_exists(startTokenId), 'ERC721A: token already minted');
149     require(quantity > 0, 'ERC721A: quantity must be greater 0'); _beforeTokenTransfers(address(0), to, startTokenId, quantity); AddressData memory addressData = _addressData[to];
150     _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity));
151     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
152     uint256 updatedIndex = startTokenId;
153     for (uint256 i = 0; i < quantity; i++) {emit Transfer(address(0), to, updatedIndex); 
154     require(_checkOnERC721Received(address(0), to, updatedIndex, _data), 'ERC721A: transfer to non ERC721Receiver implementer');updatedIndex++;} currentIndex = updatedIndex; _afterTokenTransfers(address(0), to, startTokenId, quantity);}
155 function _transfer(address from, address to, uint256 tokenId) private {TokenOwnership memory prevOwnership = ownershipOf(tokenId); 
156 bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
157     require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
158     require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
159     require(to != address(0), 'ERC721A: transfer to the zero address'); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr);
160     unchecked {_addressData[from].balance -= 1; _addressData[to].balance += 1;} _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
161     uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) {if (_exists(nextTokenId)) {_ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);}}
162     emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
163 function _approve(address to, uint256 tokenId, address owner) private {_tokenApprovals[tokenId] = to; emit Approval(owner, to, tokenId);}
164 function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
165     if (to.isContract()) {try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {return retval == IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
166     if (reason.length == 0) {revert('ERC721A: transfer to non ERC721Receiver implementer');} else {assembly {revert(add(32, reason), mload(reason))}}}} else {return true;}}
167 function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
168 function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}}
169 
170 contract PixelKingdomsQuest is ERC721A, Ownable {using Strings for uint256; using Counters for Counters.Counter; Counters.Counter private supply;
171 string public uriPrefix = ""; string public uriSuffix = ".json"; string public hiddenMetadataUri;
172 address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
173 uint256 public maxPerTxFree = 8;
174 uint256 public maxPerWallet = 24;
175 uint256 public maxPerTx = 8;
176 uint256 public freeMaxSupply = 300;
177 uint256 public maxSupply = 600;
178 uint256 public price = 0.002 ether;
179 bool public paused = false; bool public revealed = false; mapping(address => uint256) public addressMinted;
180 constructor() ERC721A("Pixel Kingdoms Quest", "PIXEL QUESST") {setHiddenMetadataUri("ipfs://bafkreicz37dg4uviwz5lvpxlx4fi3dnyxdge2nd5qe3mlrliwq7hxdlevm");}
181 function mint(uint256 _amount) external payable {address _caller = _msgSender(); require(!paused, "Paused"); require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
182     require(_amount > 0, "No 0 mints"); require(tx.origin == _caller, "No contracts"); require(addressMinted[msg.sender] + _amount <= maxPerWallet, "Exceeds max per wallet");
183     if(freeMaxSupply >= totalSupply()){require(maxPerTxFree >= _amount , "Excess max per free tx");}  else{require(maxPerTx >= _amount , "Excess max per paid tx"); require(_amount * price == msg.value, "Invalid funds provided");} addressMinted[msg.sender] += _amount; _safeMint(_caller, _amount);}
184 function withdraw() external onlyOwner {uint256 balance = address(this).balance; (bool success, ) = _msgSender().call{value: balance}(""); require(success, "Failed to send");}
185 function setPrice(uint256 _price) public onlyOwner {price = _price;}
186 function setMaxSupply(uint256 _maxSupply) public onlyOwner {maxSupply = _maxSupply;}
187 function pause(bool _state) external onlyOwner {paused = _state;}
188 function setRevealed(bool _state) public onlyOwner {revealed = _state;}
189 function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
190 function setUriPrefix(string memory _uriPrefix) public onlyOwner {uriPrefix = _uriPrefix;}
191 function setUriSuffix(string memory _uriSuffix) public onlyOwner {uriSuffix = _uriSuffix;}
192 function _baseURI() internal view virtual override returns (string memory) {return uriPrefix;}
193 function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
194     if (revealed == false) {return hiddenMetadataUri;} string memory currentbaseURI = _baseURI(); return bytes(currentbaseURI).length > 0 ? string(abi.encodePacked(currentbaseURI, _tokenId.toString(), uriSuffix)) : "";}
195 function isApprovedForAll(address owner, address operator) override public view returns (bool)
196     {ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress); if (address(proxyRegistry.proxies(owner)) == operator) {return true;} return super.isApprovedForAll(owner, operator);}}
197 contract OwnableDelegateProxy { } contract ProxyRegistry {mapping(address => OwnableDelegateProxy) public proxies;}
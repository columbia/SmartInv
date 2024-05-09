1 // MEOW
2 // SPDX-License-Identifier: MIT
3 // File: contracts/wanderingcats.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5     pragma solidity ^0.8.0;
6     abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}
7     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
8 // File: @openzeppelin/contracts/utils/Counters.sol
9 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
10     pragma solidity ^0.8.0;
11     library Counters {struct Counter {uint256 _value;}
12     function current(Counter storage counter) internal view returns (uint256) {return counter._value;}
13     function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
14     function decrement(Counter storage counter) internal {uint256 value = counter._value; require(value > 0, "Counter: decrement overflow"); unchecked {counter._value = value - 1;}}
15     function reset(Counter storage counter) internal {counter._value = 0;}}
16 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
17 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
18     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); constructor() {_transferOwnership(_msgSender());}
19     function owner() public view virtual returns (address) {return _owner;}
20     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner");_;}
21     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
22     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");_transferOwnership(newOwner);}
23     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
24 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26     library Strings {bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27     function toString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0";} uint256 temp = value; uint256 digits;
28     while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits); 
29     while (value != 0) { digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
30     function toHexString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0;
31     while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
32     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
33     bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x"; for (uint256 i = 2 * length + 1; i > 1; --i) { buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;}
34     require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
35 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
36     interface IERC165 {function supportsInterface(bytes4 interfaceId) external view returns (bool);}
37 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
38     interface IERC721 is IERC165 {
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42     function balanceOf(address owner) external view returns (uint256 balance);
43     function ownerOf(uint256 tokenId) external view returns (address owner);
44     function safeTransferFrom(address from, address to, uint256 tokenId) external;
45     function transferFrom(address from, address to, uint256 tokenId) external;
46     function approve(address to, uint256 tokenId) external;
47     function getApproved(uint256 tokenId) external view returns (address operator);
48     function setApprovalForAll(address operator, bool _approved) external;
49     function isApprovedForAll(address owner, address operator) external view returns (bool);
50     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;}
51 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
52     interface IERC721Receiver {function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
53 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
54     interface IERC721Metadata is IERC721 {
55     function name() external view returns (string memory);
56     function symbol() external view returns (string memory);
57     function tokenURI(uint256 tokenId) external view returns (string memory);}
58 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
59     interface IERC721Enumerable is IERC721 {
60     function totalSupply() external view returns (uint256);
61     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
62     function tokenByIndex(uint256 index) external view returns (uint256);}
63 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
64     library Address {
65     function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
66     function sendValue(address payable recipient, uint256 amount) internal {
67     require(address(this).balance >= amount, "Address: insufficient balance"); (bool success, ) = recipient.call{value: amount}("");
68     require(success, "Address: unable to send value, recipient may have reverted");}
69     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
70     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
71     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
72     function functionCallWithValue(address target, bytes memory data, uint256 value,string memory errorMessage) internal returns (bytes memory) {
73     require(address(this).balance >= value, "Address: insufficient balance for call");
74     require(isContract(target), "Address: call to non-contract");(bool success, bytes memory returndata) = target.call{value: value}(data); return verifyCallResult(success, returndata, errorMessage);}
75     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}
76     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
77     require(isContract(target), "Address: static call to non-contract");(bool success, bytes memory returndata) = target.staticcall(data); return verifyCallResult(success, returndata, errorMessage);}
78     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
79     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
80     require(isContract(target), "Address: delegate call to non-contract");(bool success, bytes memory returndata) = target.delegatecall(data); return verifyCallResult(success, returndata, errorMessage);}
81     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
82     if (success) {return returndata;} else {if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}} else {revert(errorMessage);}}}}
83 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
84     abstract contract ERC165 is IERC165 {
85     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == type(IERC165).interfaceId;}}
86 // File contracts/ERC721A.sol
87     contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
88     using Address for address;
89     using Strings for uint256;
90     struct TokenOwnership {address addr; uint64 startTimestamp;}
91     struct AddressData {uint128 balance; uint128 numberMinted;}
92     uint256 internal currentIndex = 0;
93     string private _name;
94     string private _symbol;
95     mapping(uint256 => TokenOwnership) internal _ownerships;
96     mapping(address => AddressData) private _addressData;
97     mapping(uint256 => address) private _tokenApprovals;
98     mapping(address => mapping(address => bool)) private _operatorApprovals;
99     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
100     function totalSupply() public view override returns (uint256) {return currentIndex;}
101     function tokenByIndex(uint256 index) public view override returns (uint256) {require(index < totalSupply(), 'ERC721A: global index out of bounds');return index;}
102     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
103     require(index < balanceOf(owner), 'ERC721A: owner index out of bounds'); uint256 numMintedSoFar = totalSupply(); uint256 tokenIdsIdx = 0; address currOwnershipAddr = address(0);
104         for (uint256 i = 0; i < numMintedSoFar; i++) {TokenOwnership memory ownership = _ownerships[i]; if (ownership.addr != address(0)) {currOwnershipAddr = ownership.addr;}
105         if (currOwnershipAddr == owner) {if (tokenIdsIdx == index) {return i;} tokenIdsIdx++;}} revert('ERC721A: unable to get token of owner by index');}
106     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {return
107         interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);}
108     function balanceOf(address owner) public view override returns (uint256) {require(owner != address(0), 'ERC721A: balance query for the zero address'); return uint256(_addressData[owner].balance);}
109     function _numberMinted(address owner) internal view returns (uint256) {require(owner != address(0), 'ERC721A: number minted query for the zero address'); return uint256(_addressData[owner].numberMinted);}
110     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
111         for (uint256 curr = tokenId; ; curr--) {TokenOwnership memory ownership = _ownerships[curr]; if (ownership.addr != address(0)) {return ownership;}} revert('ERC721A: unable to determine the owner of token');}
112     function ownerOf(uint256 tokenId) public view override returns (address) {return ownershipOf(tokenId).addr;}
113     function name() public view virtual override returns (string memory) {return _name;}
114     function symbol() public view virtual override returns (string memory) {return _symbol;}
115     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token'); string memory baseURI = _baseURI();
116         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';}
117     function _baseURI() internal view virtual returns (string memory) {return '';}
118     function approve(address to, uint256 tokenId) public override {address owner = ERC721A.ownerOf(tokenId);
119         require(to != owner, 'ERC721A: approval to current owner');
120         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721A: approve caller is not owner nor approved for all'); _approve(to, tokenId, owner);}
121     function getApproved(uint256 tokenId) public view override returns (address) {require(_exists(tokenId), 'ERC721A: approved query for nonexistent token'); return _tokenApprovals[tokenId];}
122     function setApprovalForAll(address operator, bool approved) public override {require(operator != _msgSender(), 'ERC721A: approve to caller');
123         _operatorApprovals[_msgSender()][operator] = approved; emit ApprovalForAll(_msgSender(), operator, approved);}
124     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
125     function transferFrom(address from, address to, uint256 tokenId) public override {_transfer(from, to, tokenId);}
126     function safeTransferFrom(address from, address to, uint256 tokenId) public override {safeTransferFrom(from, to, tokenId, '');}
127     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override {_transfer(from, to, tokenId);
128         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721A: transfer to non ERC721Receiver implementer');}
129     function _exists(uint256 tokenId) internal view returns (bool) {return tokenId < currentIndex;}
130     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
131     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = currentIndex;
132         require(to != address(0), 'ERC721A: mint to the zero address');
133         require(!_exists(startTokenId), 'ERC721A: token already minted');
134         require(quantity > 0, 'ERC721A: quantity must be greater 0'); _beforeTokenTransfers(address(0), to, startTokenId, quantity); AddressData memory addressData = _addressData[to];
135         _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity));
136         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
137         uint256 updatedIndex = startTokenId;
138         for (uint256 i = 0; i < quantity; i++) {emit Transfer(address(0), to, updatedIndex); 
139         require(_checkOnERC721Received(address(0), to, updatedIndex, _data), 'ERC721A: transfer to non ERC721Receiver implementer');updatedIndex++;} currentIndex = updatedIndex; _afterTokenTransfers(address(0), to, startTokenId, quantity);}
140     function _transfer(address from, address to, uint256 tokenId) private {TokenOwnership memory prevOwnership = ownershipOf(tokenId); 
141     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
142         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
143         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
144         require(to != address(0), 'ERC721A: transfer to the zero address'); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr);
145         unchecked {_addressData[from].balance -= 1; _addressData[to].balance += 1;} _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
146         uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) {if (_exists(nextTokenId)) {_ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);}}
147         emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
148     function _approve(address to, uint256 tokenId, address owner) private {_tokenApprovals[tokenId] = to; emit Approval(owner, to, tokenId);}
149     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
150         if (to.isContract()) {try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {return retval == IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
151         if (reason.length == 0) {revert('ERC721A: transfer to non ERC721Receiver implementer');} else {assembly {revert(add(32, reason), mload(reason))}}}} else {return true;}}
152     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
153     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}}
154 
155     contract WanderingCats is ERC721A, Ownable {using Strings for uint256; using Counters for Counters.Counter; Counters.Counter private supply;
156     string public uriPrefix = "ipfs://QmRr6csDG2X9E1aQ6YgVH4uxRdphJRamL5XV2VB1eg56UB/"; string public uriSuffix = ".json"; string public hiddenMetadataUri;
157     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
158     uint256 public maxPerTxFree = 1;
159     uint256 public maxPerWallet = 8;
160     uint256 public maxPerTx = 2;
161     uint256 public freeMaxSupply = 1;
162     uint256 public maxSupply = 1001;
163     uint256 public price = 0.002 ether;
164     bool public paused = false; bool public revealed = true; mapping(address => uint256) public addressMinted;
165     constructor() ERC721A("WanderingCats", "WC") {setHiddenMetadataUri("ipfs:///hidden.json");}
166     function mint(uint256 _amount) external payable {address _caller = _msgSender(); require(!paused, "Paused"); require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
167         require(_amount > 0, "No 0 mints"); require(tx.origin == _caller, "No contracts"); require(addressMinted[msg.sender] + _amount <= maxPerWallet, "Exceeds max per wallet");
168         if(freeMaxSupply >= totalSupply()){require(maxPerTxFree >= _amount , "Excess max per free tx");}  else{require(maxPerTx >= _amount , "Excess max per paid tx"); require(_amount * price == msg.value, "Invalid funds provided");} addressMinted[msg.sender] += _amount; _safeMint(_caller, _amount);}
169     function withdraw() external onlyOwner {uint256 balance = address(this).balance; (bool success, ) = _msgSender().call{value: balance}(""); require(success, "Failed to send");}
170     function setPrice(uint256 _price) public onlyOwner {price = _price;}
171     function setMaxSupply(uint256 _maxSupply) public onlyOwner {maxSupply = _maxSupply;}
172     function pause(bool _state) external onlyOwner {paused = _state;}
173     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
174     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
175     function setUriPrefix(string memory _uriPrefix) public onlyOwner {uriPrefix = _uriPrefix;}
176     function setUriSuffix(string memory _uriSuffix) public onlyOwner {uriSuffix = _uriSuffix;}
177     function _baseURI() internal view virtual override returns (string memory) {return uriPrefix;}
178     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
179         if (revealed == false) {return hiddenMetadataUri;} string memory currentbaseURI = _baseURI(); return bytes(currentbaseURI).length > 0 ? string(abi.encodePacked(currentbaseURI, _tokenId.toString(), uriSuffix)) : "";}
180     function isApprovedForAll(address owner, address operator) override public view returns (bool)
181         {ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress); if (address(proxyRegistry.proxies(owner)) == operator) {return true;} return super.isApprovedForAll(owner, operator);}}
182     contract OwnableDelegateProxy { } contract ProxyRegistry {mapping(address => OwnableDelegateProxy) public proxies;}
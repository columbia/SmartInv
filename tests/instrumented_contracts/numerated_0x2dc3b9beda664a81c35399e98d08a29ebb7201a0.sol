1 // SPDX-License-Identifier: MIT
2 // File: contracts/grit.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4     pragma solidity ^0.8.0;
5     abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}
6     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
7 // File: @openzeppelin/contracts/utils/Counters.sol
8 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
9     pragma solidity ^0.8.0;
10     library Counters {struct Counter {uint256 _value;}
11     function current(Counter storage counter) internal view returns (uint256) {return counter._value;}
12     function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
13     function decrement(Counter storage counter) internal {uint256 value = counter._value; require(value > 0, "Counter: decrement overflow"); unchecked {counter._value = value - 1;}}
14     function reset(Counter storage counter) internal {counter._value = 0;}}
15 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
16 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
17     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); constructor() {_transferOwnership(_msgSender());}
18     function owner() public view virtual returns (address) {return _owner;}
19     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner");_;}
20     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
21     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");_transferOwnership(newOwner);}
22     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
23 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
24 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
25     library Strings {bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26     function toString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0";} uint256 temp = value; uint256 digits;
27     while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits); 
28     while (value != 0) { digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
29     function toHexString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0;
30     while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
31     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
32     bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x"; for (uint256 i = 2 * length + 1; i > 1; --i) { buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;}
33     require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
34 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
35     interface IERC165 {function supportsInterface(bytes4 interfaceId) external view returns (bool);}
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37     interface IERC721 is IERC165 {
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
41     function balanceOf(address owner) external view returns (uint256 balance);
42     function ownerOf(uint256 tokenId) external view returns (address owner);
43     function safeTransferFrom(address from, address to, uint256 tokenId) external;
44     function transferFrom(address from, address to, uint256 tokenId) external;
45     function approve(address to, uint256 tokenId) external;
46     function getApproved(uint256 tokenId) external view returns (address operator);
47     function setApprovalForAll(address operator, bool _approved) external;
48     function isApprovedForAll(address owner, address operator) external view returns (bool);
49     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;}
50 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
51     interface IERC721Receiver {function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
52 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
53     interface IERC721Metadata is IERC721 {
54     function name() external view returns (string memory);
55     function symbol() external view returns (string memory);
56     function tokenURI(uint256 tokenId) external view returns (string memory);}
57 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
58     interface IERC721Enumerable is IERC721 {
59     function totalSupply() external view returns (uint256);
60     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
61     function tokenByIndex(uint256 index) external view returns (uint256);}
62 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
63     library Address {
64     function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
65     function sendValue(address payable recipient, uint256 amount) internal {
66     require(address(this).balance >= amount, "Address: insufficient balance"); (bool success, ) = recipient.call{value: amount}("");
67     require(success, "Address: unable to send value, recipient may have reverted");}
68     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
69     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
70     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
71     function functionCallWithValue(address target, bytes memory data, uint256 value,string memory errorMessage) internal returns (bytes memory) {
72     require(address(this).balance >= value, "Address: insufficient balance for call");
73     require(isContract(target), "Address: call to non-contract");(bool success, bytes memory returndata) = target.call{value: value}(data); return verifyCallResult(success, returndata, errorMessage);}
74     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}
75     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
76     require(isContract(target), "Address: static call to non-contract");(bool success, bytes memory returndata) = target.staticcall(data); return verifyCallResult(success, returndata, errorMessage);}
77     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
78     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
79     require(isContract(target), "Address: delegate call to non-contract");(bool success, bytes memory returndata) = target.delegatecall(data); return verifyCallResult(success, returndata, errorMessage);}
80     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
81     if (success) {return returndata;} else {if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}} else {revert(errorMessage);}}}}
82 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
83     abstract contract ERC165 is IERC165 {
84     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == type(IERC165).interfaceId;}}
85 // File contracts/ERC721A.sol
86     contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
87     using Address for address;
88     using Strings for uint256;
89     struct TokenOwnership {address addr; uint64 startTimestamp;}
90     struct AddressData {uint128 balance; uint128 numberMinted;}
91     uint256 internal currentIndex = 0;
92     string private _name;
93     string private _symbol;
94     mapping(uint256 => TokenOwnership) internal _ownerships;
95     mapping(address => AddressData) private _addressData;
96     mapping(uint256 => address) private _tokenApprovals;
97     mapping(address => mapping(address => bool)) private _operatorApprovals;
98     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
99     function totalSupply() public view override returns (uint256) {return currentIndex;}
100     function tokenByIndex(uint256 index) public view override returns (uint256) {require(index < totalSupply(), 'ERC721A: global index out of bounds');return index;}
101     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
102     require(index < balanceOf(owner), 'ERC721A: owner index out of bounds'); uint256 numMintedSoFar = totalSupply(); uint256 tokenIdsIdx = 0; address currOwnershipAddr = address(0);
103         for (uint256 i = 0; i < numMintedSoFar; i++) {TokenOwnership memory ownership = _ownerships[i]; if (ownership.addr != address(0)) {currOwnershipAddr = ownership.addr;}
104         if (currOwnershipAddr == owner) {if (tokenIdsIdx == index) {return i;} tokenIdsIdx++;}} revert('ERC721A: unable to get token of owner by index');}
105     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {return
106         interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);}
107     function balanceOf(address owner) public view override returns (uint256) {require(owner != address(0), 'ERC721A: balance query for the zero address'); return uint256(_addressData[owner].balance);}
108     function _numberMinted(address owner) internal view returns (uint256) {require(owner != address(0), 'ERC721A: number minted query for the zero address'); return uint256(_addressData[owner].numberMinted);}
109     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
110         for (uint256 curr = tokenId; ; curr--) {TokenOwnership memory ownership = _ownerships[curr]; if (ownership.addr != address(0)) {return ownership;}} revert('ERC721A: unable to determine the owner of token');}
111     function ownerOf(uint256 tokenId) public view override returns (address) {return ownershipOf(tokenId).addr;}
112     function name() public view virtual override returns (string memory) {return _name;}
113     function symbol() public view virtual override returns (string memory) {return _symbol;}
114     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token'); string memory baseURI = _baseURI();
115         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';}
116     function _baseURI() internal view virtual returns (string memory) {return '';}
117     function approve(address to, uint256 tokenId) public override {address owner = ERC721A.ownerOf(tokenId);
118         require(to != owner, 'ERC721A: approval to current owner');
119         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721A: approve caller is not owner nor approved for all'); _approve(to, tokenId, owner);}
120     function getApproved(uint256 tokenId) public view override returns (address) {require(_exists(tokenId), 'ERC721A: approved query for nonexistent token'); return _tokenApprovals[tokenId];}
121     function setApprovalForAll(address operator, bool approved) public override {require(operator != _msgSender(), 'ERC721A: approve to caller');
122         _operatorApprovals[_msgSender()][operator] = approved; emit ApprovalForAll(_msgSender(), operator, approved);}
123     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
124     function transferFrom(address from, address to, uint256 tokenId) public override {_transfer(from, to, tokenId);}
125     function safeTransferFrom(address from, address to, uint256 tokenId) public override {safeTransferFrom(from, to, tokenId, '');}
126     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override {_transfer(from, to, tokenId);
127         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721A: transfer to non ERC721Receiver implementer');}
128     function _exists(uint256 tokenId) internal view returns (bool) {return tokenId < currentIndex;}
129     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
130     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = currentIndex;
131         require(to != address(0), 'ERC721A: mint to the zero address');
132         require(!_exists(startTokenId), 'ERC721A: token already minted');
133         require(quantity > 0, 'ERC721A: quantity must be greater 0'); _beforeTokenTransfers(address(0), to, startTokenId, quantity); AddressData memory addressData = _addressData[to];
134         _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity));
135         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
136         uint256 updatedIndex = startTokenId;
137         for (uint256 i = 0; i < quantity; i++) {emit Transfer(address(0), to, updatedIndex); 
138         require(_checkOnERC721Received(address(0), to, updatedIndex, _data), 'ERC721A: transfer to non ERC721Receiver implementer');updatedIndex++;} currentIndex = updatedIndex; _afterTokenTransfers(address(0), to, startTokenId, quantity);}
139     function _transfer(address from, address to, uint256 tokenId) private {TokenOwnership memory prevOwnership = ownershipOf(tokenId); 
140     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
141         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
142         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
143         require(to != address(0), 'ERC721A: transfer to the zero address'); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr);
144         unchecked {_addressData[from].balance -= 1; _addressData[to].balance += 1;} _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
145         uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) {if (_exists(nextTokenId)) {_ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);}}
146         emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
147     function _approve(address to, uint256 tokenId, address owner) private {_tokenApprovals[tokenId] = to; emit Approval(owner, to, tokenId);}
148     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
149         if (to.isContract()) {try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {return retval == IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
150         if (reason.length == 0) {revert('ERC721A: transfer to non ERC721Receiver implementer');} else {assembly {revert(add(32, reason), mload(reason))}}}} else {return true;}}
151     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
152     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}}
153 
154     contract Grit is ERC721A, Ownable {using Strings for uint256; using Counters for Counters.Counter; Counters.Counter private supply;
155     string public uriPrefix = "ipfs://QmZUdmJH2NZAU6Kun8fUGydTFg6ZqWJcc4NE5oTn1hB264/"; string public uriSuffix = ".json"; string public hiddenMetadataUri;
156     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
157     uint256 public maxPerTxFree = 1;
158     uint256 public maxPerWallet = 8;
159     uint256 public maxPerTx = 2;
160     uint256 public freeMaxSupply = 1;
161     uint256 public maxSupply = 1111;
162     uint256 public price = 0.003 ether;
163     bool public paused = false; bool public revealed = true; mapping(address => uint256) public addressMinted;
164     constructor() ERC721A("Grit", "GRIT") {setHiddenMetadataUri("ipfs:///hidden.json");}
165     function mint(uint256 _amount) external payable {address _caller = _msgSender(); require(!paused, "Paused"); require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
166         require(_amount > 0, "No 0 mints"); require(tx.origin == _caller, "No contracts"); require(addressMinted[msg.sender] + _amount <= maxPerWallet, "Exceeds max per wallet");
167         if(freeMaxSupply >= totalSupply()){require(maxPerTxFree >= _amount , "Excess max per free tx");}  else{require(maxPerTx >= _amount , "Excess max per paid tx"); require(_amount * price == msg.value, "Invalid funds provided");} addressMinted[msg.sender] += _amount; _safeMint(_caller, _amount);}
168     function withdraw() external onlyOwner {uint256 balance = address(this).balance; (bool success, ) = _msgSender().call{value: balance}(""); require(success, "Failed to send");}
169     function setPrice(uint256 _price) public onlyOwner {price = _price;}
170     function setMaxSupply(uint256 _maxSupply) public onlyOwner {maxSupply = _maxSupply;}
171     function pause(bool _state) external onlyOwner {paused = _state;}
172     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
173     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
174     function setUriPrefix(string memory _uriPrefix) public onlyOwner {uriPrefix = _uriPrefix;}
175     function setUriSuffix(string memory _uriSuffix) public onlyOwner {uriSuffix = _uriSuffix;}
176     function _baseURI() internal view virtual override returns (string memory) {return uriPrefix;}
177     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
178         if (revealed == false) {return hiddenMetadataUri;} string memory currentbaseURI = _baseURI(); return bytes(currentbaseURI).length > 0 ? string(abi.encodePacked(currentbaseURI, _tokenId.toString(), uriSuffix)) : "";}
179     function isApprovedForAll(address owner, address operator) override public view returns (bool)
180         {ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress); if (address(proxyRegistry.proxies(owner)) == operator) {return true;} return super.isApprovedForAll(owner, operator);}}
181     contract OwnableDelegateProxy { } contract ProxyRegistry {mapping(address => OwnableDelegateProxy) public proxies;}
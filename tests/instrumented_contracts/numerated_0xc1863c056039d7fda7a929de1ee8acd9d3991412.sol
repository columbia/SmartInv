1 // SPDX-License-Identifier: MIT
2 
3 // HISS HISS
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6     pragma solidity ^0.8.0;
7     abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}
8     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
9 
10 // File: @openzeppelin/contracts/utils/Counters.sol
11 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
12     pragma solidity ^0.8.0;
13     library Counters {struct Counter {uint256 _value;}
14     function current(Counter storage counter) internal view returns (uint256) {return counter._value;}
15     function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
16     function decrement(Counter storage counter) internal {uint256 value = counter._value; require(value > 0, "Counter: decrement overflow"); unchecked {counter._value = value - 1;}}
17     function reset(Counter storage counter) internal {counter._value = 0;}}
18 
19 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
20 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
21     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); constructor() {_transferOwnership(_msgSender());}
22     function owner() public view virtual returns (address) {return _owner;}
23     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner");_;}
24     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
25     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");_transferOwnership(newOwner);}
26     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
27 
28 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
29 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
30     library Strings {bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31     function toString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0";} uint256 temp = value; uint256 digits;
32     while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits); 
33     while (value != 0) { digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
34     function toHexString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0;
35     while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
36     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
37     bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x"; for (uint256 i = 2 * length + 1; i > 1; --i) { buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;}
38     require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
39 
40 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
41     interface IERC165 {function supportsInterface(bytes4 interfaceId) external view returns (bool);}
42 
43 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
44     interface IERC721 is IERC165 {
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48     function balanceOf(address owner) external view returns (uint256 balance);
49     function ownerOf(uint256 tokenId) external view returns (address owner);
50     function safeTransferFrom(address from, address to, uint256 tokenId) external;
51     function transferFrom(address from, address to, uint256 tokenId) external;
52     function approve(address to, uint256 tokenId) external;
53     function getApproved(uint256 tokenId) external view returns (address operator);
54     function setApprovalForAll(address operator, bool _approved) external;
55     function isApprovedForAll(address owner, address operator) external view returns (bool);
56     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;}
57     
58 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
59     interface IERC721Receiver {function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
60 
61 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
62     interface IERC721Metadata is IERC721 {
63     function name() external view returns (string memory);
64     function symbol() external view returns (string memory);
65     function tokenURI(uint256 tokenId) external view returns (string memory);}
66 
67 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
68     interface IERC721Enumerable is IERC721 {
69     function totalSupply() external view returns (uint256);
70     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
71     function tokenByIndex(uint256 index) external view returns (uint256);}
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
74     library Address {
75     function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
76     function sendValue(address payable recipient, uint256 amount) internal {
77     require(address(this).balance >= amount, "Address: insufficient balance"); (bool success, ) = recipient.call{value: amount}("");
78     require(success, "Address: unable to send value, recipient may have reverted");}
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
80     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
81     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
82     function functionCallWithValue(address target, bytes memory data, uint256 value,string memory errorMessage) internal returns (bytes memory) {
83     require(address(this).balance >= value, "Address: insufficient balance for call");
84     require(isContract(target), "Address: call to non-contract");(bool success, bytes memory returndata) = target.call{value: value}(data); return verifyCallResult(success, returndata, errorMessage);}
85     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}
86     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
87     require(isContract(target), "Address: static call to non-contract");(bool success, bytes memory returndata) = target.staticcall(data); return verifyCallResult(success, returndata, errorMessage);}
88     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
89     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90     require(isContract(target), "Address: delegate call to non-contract");(bool success, bytes memory returndata) = target.delegatecall(data); return verifyCallResult(success, returndata, errorMessage);}
91     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
92     if (success) {return returndata;} else {if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}} else {revert(errorMessage);}}}}
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
95     abstract contract ERC165 is IERC165 {
96     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == type(IERC165).interfaceId;}}
97     
98 // File contracts/ERC721A.sol
99     contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
100     using Address for address;
101     using Strings for uint256;
102     struct TokenOwnership {address addr; uint64 startTimestamp;}
103     struct AddressData {uint128 balance; uint128 numberMinted;}
104     uint256 internal currentIndex = 0;
105     string private _name;
106     string private _symbol;
107     mapping(uint256 => TokenOwnership) internal _ownerships;
108     mapping(address => AddressData) private _addressData;
109     mapping(uint256 => address) private _tokenApprovals;
110     mapping(address => mapping(address => bool)) private _operatorApprovals;
111     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
112     function totalSupply() public view override returns (uint256) {return currentIndex;}
113     function tokenByIndex(uint256 index) public view override returns (uint256) {require(index < totalSupply(), 'ERC721A: global index out of bounds');return index;}
114     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
115     require(index < balanceOf(owner), 'ERC721A: owner index out of bounds'); uint256 numMintedSoFar = totalSupply(); uint256 tokenIdsIdx = 0; address currOwnershipAddr = address(0);
116         for (uint256 i = 0; i < numMintedSoFar; i++) {TokenOwnership memory ownership = _ownerships[i]; if (ownership.addr != address(0)) {currOwnershipAddr = ownership.addr;}
117         if (currOwnershipAddr == owner) {if (tokenIdsIdx == index) {return i;} tokenIdsIdx++;}} revert('ERC721A: unable to get token of owner by index');}
118     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {return
119         interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);}
120     function balanceOf(address owner) public view override returns (uint256) {require(owner != address(0), 'ERC721A: balance query for the zero address'); return uint256(_addressData[owner].balance);}
121     function _numberMinted(address owner) internal view returns (uint256) {require(owner != address(0), 'ERC721A: number minted query for the zero address'); return uint256(_addressData[owner].numberMinted);}
122     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
123         for (uint256 curr = tokenId; ; curr--) {TokenOwnership memory ownership = _ownerships[curr]; if (ownership.addr != address(0)) {return ownership;}} revert('ERC721A: unable to determine the owner of token');}
124     function ownerOf(uint256 tokenId) public view override returns (address) {return ownershipOf(tokenId).addr;}
125     function name() public view virtual override returns (string memory) {return _name;}
126     function symbol() public view virtual override returns (string memory) {return _symbol;}
127     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token'); string memory baseURI = _baseURI();
128         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';}
129     function _baseURI() internal view virtual returns (string memory) {return '';}
130     function approve(address to, uint256 tokenId) public override {address owner = ERC721A.ownerOf(tokenId);
131         require(to != owner, 'ERC721A: approval to current owner');
132         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721A: approve caller is not owner nor approved for all'); _approve(to, tokenId, owner);}
133     function getApproved(uint256 tokenId) public view override returns (address) {require(_exists(tokenId), 'ERC721A: approved query for nonexistent token'); return _tokenApprovals[tokenId];}
134     function setApprovalForAll(address operator, bool approved) public override {require(operator != _msgSender(), 'ERC721A: approve to caller');
135         _operatorApprovals[_msgSender()][operator] = approved; emit ApprovalForAll(_msgSender(), operator, approved);}
136     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
137     function transferFrom(address from, address to, uint256 tokenId) public override {_transfer(from, to, tokenId);}
138     function safeTransferFrom(address from, address to, uint256 tokenId) public override {safeTransferFrom(from, to, tokenId, '');}
139     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override {_transfer(from, to, tokenId);
140         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721A: transfer to non ERC721Receiver implementer');}
141     function _exists(uint256 tokenId) internal view returns (bool) {return tokenId < currentIndex;}
142     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
143     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = currentIndex;
144         require(to != address(0), 'ERC721A: mint to the zero address');
145         require(!_exists(startTokenId), 'ERC721A: token already minted');
146         require(quantity > 0, 'ERC721A: quantity must be greater 0'); _beforeTokenTransfers(address(0), to, startTokenId, quantity); AddressData memory addressData = _addressData[to];
147         _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity));
148         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
149         uint256 updatedIndex = startTokenId;
150         for (uint256 i = 0; i < quantity; i++) {emit Transfer(address(0), to, updatedIndex); 
151         require(_checkOnERC721Received(address(0), to, updatedIndex, _data), 'ERC721A: transfer to non ERC721Receiver implementer');updatedIndex++;} currentIndex = updatedIndex; _afterTokenTransfers(address(0), to, startTokenId, quantity);}
152     function _transfer(address from, address to, uint256 tokenId) private {TokenOwnership memory prevOwnership = ownershipOf(tokenId); 
153     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
154         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
155         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
156         require(to != address(0), 'ERC721A: transfer to the zero address'); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr);
157         unchecked {_addressData[from].balance -= 1; _addressData[to].balance += 1;} _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
158         uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) {if (_exists(nextTokenId)) {_ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);}}
159         emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
160     function _approve(address to, uint256 tokenId, address owner) private {_tokenApprovals[tokenId] = to; emit Approval(owner, to, tokenId);}
161     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
162         if (to.isContract()) {try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {return retval == IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
163         if (reason.length == 0) {revert('ERC721A: transfer to non ERC721Receiver implementer');} else {assembly {revert(add(32, reason), mload(reason))}}}} else {return true;}}
164     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
165     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}}
166 
167     contract MoonSnake is ERC721A, Ownable {using Strings for uint256; using Counters for Counters.Counter; Counters.Counter private supply;
168     string public uriPrefix = "ipfs://QmWviEDoAAaBGZcyaVrz8o9XdT2raMhFqospY4DpfhYDMf/"; string public uriSuffix = ".json"; string public hiddenMetadataUri;
169     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
170     uint256 public maxPerTxFree = 2;
171     uint256 public maxPerWallet = 8;
172     uint256 public maxPerTx = 2;
173     uint256 public freeMaxSupply = 444;
174     uint256 public maxSupply = 888;
175     uint256 public price = 0.005 ether;
176     bool public paused = false; bool public revealed = true; mapping(address => uint256) public addressMinted;
177     constructor() ERC721A("MoonSnake", "MS") {setHiddenMetadataUri("ipfs:///hidden.json");}
178     function mint(uint256 _amount) external payable {address _caller = _msgSender(); require(!paused, "Paused"); require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
179         require(_amount > 0, "No 0 mints"); require(tx.origin == _caller, "No contracts"); require(addressMinted[msg.sender] + _amount <= maxPerWallet, "Exceeds max per wallet");
180         if(freeMaxSupply >= totalSupply()){require(maxPerTxFree >= _amount , "Excess max per free tx");}  else{require(maxPerTx >= _amount , "Excess max per paid tx"); require(_amount * price == msg.value, "Invalid funds provided");} addressMinted[msg.sender] += _amount; _safeMint(_caller, _amount);}
181     function withdraw() external onlyOwner {uint256 balance = address(this).balance; (bool success, ) = _msgSender().call{value: balance}(""); require(success, "Failed to send");}
182     function setPrice(uint256 _price) public onlyOwner {price = _price;}
183     function setMaxSupply(uint256 _maxSupply) public onlyOwner {maxSupply = _maxSupply;}
184     function pause(bool _state) external onlyOwner {paused = _state;}
185     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
186     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
187     function setUriPrefix(string memory _uriPrefix) public onlyOwner {uriPrefix = _uriPrefix;}
188     function setUriSuffix(string memory _uriSuffix) public onlyOwner {uriSuffix = _uriSuffix;}
189     function _baseURI() internal view virtual override returns (string memory) {return uriPrefix;}
190     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
191         if (revealed == false) {return hiddenMetadataUri;} string memory currentbaseURI = _baseURI(); return bytes(currentbaseURI).length > 0 ? string(abi.encodePacked(currentbaseURI, _tokenId.toString(), uriSuffix)) : "";}
192     function isApprovedForAll(address owner, address operator) override public view returns (bool)
193         {ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress); if (address(proxyRegistry.proxies(owner)) == operator) {return true;} return super.isApprovedForAll(owner, operator);}}
194     contract OwnableDelegateProxy { } contract ProxyRegistry {mapping(address => OwnableDelegateProxy) public proxies;}
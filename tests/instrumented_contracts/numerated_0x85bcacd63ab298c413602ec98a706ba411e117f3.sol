1 //  ███▄    █  ██▓  ▄████  ██░ ██ ▄▄▄█████▓ ███▄ ▄███▓ ▄▄▄       ██▀███  ▓█████   ██████ 
2 //  ██ ▀█   █ ▓██▒ ██▒ ▀█▒▓██░ ██▒▓  ██▒ ▓▒▓██▒▀█▀ ██▒▒████▄    ▓██ ▒ ██▒▓█   ▀ ▒██    ▒ 
3 // ▓██  ▀█ ██▒▒██▒▒██░▄▄▄░▒██▀▀██░▒ ▓██░ ▒░▓██    ▓██░▒██  ▀█▄  ▓██ ░▄█ ▒▒███   ░ ▓██▄   
4 // ██▒  ▐▌██▒░██░░▓█  ██▓░▓█ ░██ ░ ▓██▓ ░ ▒██    ▒██ ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄   ▒   ██▒
5 // ▒██░   ▓██░░██░░▒▓███▀▒░▓█▒░██▓  ▒██▒ ░ ▒██▒   ░██▒ ▓█   ▓██▒░██▓ ▒██▒░▒████▒▒██████▒▒
6 // ░ ▒░   ▒ ▒ ░▓   ░▒   ▒  ▒ ░░▒░▒  ▒ ░░   ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░▒ ▒▓▒ ▒ ░
7 // ░ ░░   ░ ▒░ ▒ ░  ░   ░  ▒ ░▒░ ░    ░    ░  ░      ░  ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░░ ░▒  ░ ░
8 //    ░   ░ ░  ▒ ░░ ░   ░  ░  ░░ ░  ░      ░      ░     ░   ▒     ░░   ░    ░   ░  ░  ░  
9 //         ░  ░        ░  ░  ░  ░                ░         ░  ░   ░        ░  ░      ░  
10 
11 // SPDX-License-Identifier: MIT
12 // File: contracts/nightmaresbyhan.sol
13 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
14     pragma solidity ^0.8.0;
15     abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}
16     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
17 // File: @openzeppelin/contracts/utils/Counters.sol
18 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
19     pragma solidity ^0.8.0;
20     library Counters {struct Counter {uint256 _value;}
21     function current(Counter storage counter) internal view returns (uint256) {return counter._value;}
22     function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
23     function decrement(Counter storage counter) internal {uint256 value = counter._value; require(value > 0, "Counter: decrement overflow"); unchecked {counter._value = value - 1;}}
24     function reset(Counter storage counter) internal {counter._value = 0;}}
25 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
26 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
27     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); constructor() {_transferOwnership(_msgSender());}
28     function owner() public view virtual returns (address) {return _owner;}
29     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner");_;}
30     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
31     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");_transferOwnership(newOwner);}
32     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
33 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
34 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
35     library Strings {bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36     function toString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0";} uint256 temp = value; uint256 digits;
37     while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits); 
38     while (value != 0) { digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
39     function toHexString(uint256 value) internal pure returns (string memory) {if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0;
40     while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
41     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
42     bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x"; for (uint256 i = 2 * length + 1; i > 1; --i) { buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;}
43     require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
44 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
45     interface IERC165 {function supportsInterface(bytes4 interfaceId) external view returns (bool);}
46 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
47     interface IERC721 is IERC165 {
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51     function balanceOf(address owner) external view returns (uint256 balance);
52     function ownerOf(uint256 tokenId) external view returns (address owner);
53     function safeTransferFrom(address from, address to, uint256 tokenId) external;
54     function transferFrom(address from, address to, uint256 tokenId) external;
55     function approve(address to, uint256 tokenId) external;
56     function getApproved(uint256 tokenId) external view returns (address operator);
57     function setApprovalForAll(address operator, bool _approved) external;
58     function isApprovedForAll(address owner, address operator) external view returns (bool);
59     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;}
60 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
61     interface IERC721Receiver {function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
62 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
63     interface IERC721Metadata is IERC721 {
64     function name() external view returns (string memory);
65     function symbol() external view returns (string memory);
66     function tokenURI(uint256 tokenId) external view returns (string memory);}
67 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
68     interface IERC721Enumerable is IERC721 {
69     function totalSupply() external view returns (uint256);
70     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
71     function tokenByIndex(uint256 index) external view returns (uint256);}
72 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
73     library Address {
74     function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
75     function sendValue(address payable recipient, uint256 amount) internal {
76     require(address(this).balance >= amount, "Address: insufficient balance"); (bool success, ) = recipient.call{value: amount}("");
77     require(success, "Address: unable to send value, recipient may have reverted");}
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
79     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
80     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
81     function functionCallWithValue(address target, bytes memory data, uint256 value,string memory errorMessage) internal returns (bytes memory) {
82     require(address(this).balance >= value, "Address: insufficient balance for call");
83     require(isContract(target), "Address: call to non-contract");(bool success, bytes memory returndata) = target.call{value: value}(data); return verifyCallResult(success, returndata, errorMessage);}
84     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}
85     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
86     require(isContract(target), "Address: static call to non-contract");(bool success, bytes memory returndata) = target.staticcall(data); return verifyCallResult(success, returndata, errorMessage);}
87     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
88     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89     require(isContract(target), "Address: delegate call to non-contract");(bool success, bytes memory returndata) = target.delegatecall(data); return verifyCallResult(success, returndata, errorMessage);}
90     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
91     if (success) {return returndata;} else {if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}} else {revert(errorMessage);}}}}
92 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
93     abstract contract ERC165 is IERC165 {
94     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == type(IERC165).interfaceId;}}
95 // File contracts/ERC721A.sol
96     contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
97     using Address for address;
98     using Strings for uint256;
99     struct TokenOwnership {address addr; uint64 startTimestamp;}
100     struct AddressData {uint128 balance; uint128 numberMinted;}
101     uint256 internal currentIndex = 0;
102     string private _name;
103     string private _symbol;
104     mapping(uint256 => TokenOwnership) internal _ownerships;
105     mapping(address => AddressData) private _addressData;
106     mapping(uint256 => address) private _tokenApprovals;
107     mapping(address => mapping(address => bool)) private _operatorApprovals;
108     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
109     function totalSupply() public view override returns (uint256) {return currentIndex;}
110     function tokenByIndex(uint256 index) public view override returns (uint256) {require(index < totalSupply(), 'ERC721A: global index out of bounds');return index;}
111     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
112     require(index < balanceOf(owner), 'ERC721A: owner index out of bounds'); uint256 numMintedSoFar = totalSupply(); uint256 tokenIdsIdx = 0; address currOwnershipAddr = address(0);
113         for (uint256 i = 0; i < numMintedSoFar; i++) {TokenOwnership memory ownership = _ownerships[i]; if (ownership.addr != address(0)) {currOwnershipAddr = ownership.addr;}
114         if (currOwnershipAddr == owner) {if (tokenIdsIdx == index) {return i;} tokenIdsIdx++;}} revert('ERC721A: unable to get token of owner by index');}
115     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {return
116         interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);}
117     function balanceOf(address owner) public view override returns (uint256) {require(owner != address(0), 'ERC721A: balance query for the zero address'); return uint256(_addressData[owner].balance);}
118     function _numberMinted(address owner) internal view returns (uint256) {require(owner != address(0), 'ERC721A: number minted query for the zero address'); return uint256(_addressData[owner].numberMinted);}
119     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
120         for (uint256 curr = tokenId; ; curr--) {TokenOwnership memory ownership = _ownerships[curr]; if (ownership.addr != address(0)) {return ownership;}} revert('ERC721A: unable to determine the owner of token');}
121     function ownerOf(uint256 tokenId) public view override returns (address) {return ownershipOf(tokenId).addr;}
122     function name() public view virtual override returns (string memory) {return _name;}
123     function symbol() public view virtual override returns (string memory) {return _symbol;}
124     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token'); string memory baseURI = _baseURI();
125         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';}
126     function _baseURI() internal view virtual returns (string memory) {return '';}
127     function approve(address to, uint256 tokenId) public override {address owner = ERC721A.ownerOf(tokenId);
128         require(to != owner, 'ERC721A: approval to current owner');
129         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721A: approve caller is not owner nor approved for all'); _approve(to, tokenId, owner);}
130     function getApproved(uint256 tokenId) public view override returns (address) {require(_exists(tokenId), 'ERC721A: approved query for nonexistent token'); return _tokenApprovals[tokenId];}
131     function setApprovalForAll(address operator, bool approved) public override {require(operator != _msgSender(), 'ERC721A: approve to caller');
132         _operatorApprovals[_msgSender()][operator] = approved; emit ApprovalForAll(_msgSender(), operator, approved);}
133     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
134     function transferFrom(address from, address to, uint256 tokenId) public override {_transfer(from, to, tokenId);}
135     function safeTransferFrom(address from, address to, uint256 tokenId) public override {safeTransferFrom(from, to, tokenId, '');}
136     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override {_transfer(from, to, tokenId);
137         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721A: transfer to non ERC721Receiver implementer');}
138     function _exists(uint256 tokenId) internal view returns (bool) {return tokenId < currentIndex;}
139     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
140     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = currentIndex;
141         require(to != address(0), 'ERC721A: mint to the zero address');
142         require(!_exists(startTokenId), 'ERC721A: token already minted');
143         require(quantity > 0, 'ERC721A: quantity must be greater 0'); _beforeTokenTransfers(address(0), to, startTokenId, quantity); AddressData memory addressData = _addressData[to];
144         _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity));
145         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
146         uint256 updatedIndex = startTokenId;
147         for (uint256 i = 0; i < quantity; i++) {emit Transfer(address(0), to, updatedIndex); 
148         require(_checkOnERC721Received(address(0), to, updatedIndex, _data), 'ERC721A: transfer to non ERC721Receiver implementer');updatedIndex++;} currentIndex = updatedIndex; _afterTokenTransfers(address(0), to, startTokenId, quantity);}
149     function _transfer(address from, address to, uint256 tokenId) private {TokenOwnership memory prevOwnership = ownershipOf(tokenId); 
150     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
151         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
152         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
153         require(to != address(0), 'ERC721A: transfer to the zero address'); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr);
154         unchecked {_addressData[from].balance -= 1; _addressData[to].balance += 1;} _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
155         uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) {if (_exists(nextTokenId)) {_ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);}}
156         emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
157     function _approve(address to, uint256 tokenId, address owner) private {_tokenApprovals[tokenId] = to; emit Approval(owner, to, tokenId);}
158     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
159         if (to.isContract()) {try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {return retval == IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
160         if (reason.length == 0) {revert('ERC721A: transfer to non ERC721Receiver implementer');} else {assembly {revert(add(32, reason), mload(reason))}}}} else {return true;}}
161     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
162     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}}
163 
164     contract NightmaresByHan is ERC721A, Ownable {using Strings for uint256; using Counters for Counters.Counter; Counters.Counter private supply;
165     string public uriPrefix = "ipfs://QmXctrARDX29wD7DF3wKLdMxfiDKJC7Z45ebJ4f8tA5scp/"; string public uriSuffix = ".json"; string public hiddenMetadataUri;
166     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
167     uint256 public maxPerTxFree = 1;
168     uint256 public maxPerWallet = 4;
169     uint256 public maxPerTx = 2;
170     uint256 public freeMaxSupply = 1;
171     uint256 public maxSupply = 1111;
172     uint256 public price = 0.002 ether;
173     bool public paused = false; bool public revealed = true; mapping(address => uint256) public addressMinted;
174     constructor() ERC721A("NightmaresByHan", "FEAR") {setHiddenMetadataUri("ipfs:///hidden.json");}
175     function mint(uint256 _amount) external payable {address _caller = _msgSender(); require(!paused, "Paused"); require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
176         require(_amount > 0, "No 0 mints"); require(tx.origin == _caller, "No contracts"); require(addressMinted[msg.sender] + _amount <= maxPerWallet, "Exceeds max per wallet");
177         if(freeMaxSupply >= totalSupply()){require(maxPerTxFree >= _amount , "Excess max per free tx");}  else{require(maxPerTx >= _amount , "Excess max per paid tx"); require(_amount * price == msg.value, "Invalid funds provided");} addressMinted[msg.sender] += _amount; _safeMint(_caller, _amount);}
178     function withdraw() external onlyOwner {uint256 balance = address(this).balance; (bool success, ) = _msgSender().call{value: balance}(""); require(success, "Failed to send");}
179     function setPrice(uint256 _price) public onlyOwner {price = _price;}
180     function setMaxSupply(uint256 _maxSupply) public onlyOwner {maxSupply = _maxSupply;}
181     function pause(bool _state) external onlyOwner {paused = _state;}
182     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
183     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
184     function setUriPrefix(string memory _uriPrefix) public onlyOwner {uriPrefix = _uriPrefix;}
185     function setUriSuffix(string memory _uriSuffix) public onlyOwner {uriSuffix = _uriSuffix;}
186     function _baseURI() internal view virtual override returns (string memory) {return uriPrefix;}
187     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
188         if (revealed == false) {return hiddenMetadataUri;} string memory currentbaseURI = _baseURI(); return bytes(currentbaseURI).length > 0 ? string(abi.encodePacked(currentbaseURI, _tokenId.toString(), uriSuffix)) : "";}
189     function isApprovedForAll(address owner, address operator) override public view returns (bool)
190         {ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress); if (address(proxyRegistry.proxies(owner)) == operator) {return true;} return super.isApprovedForAll(owner, operator);}}
191     contract OwnableDelegateProxy { } contract ProxyRegistry {mapping(address => OwnableDelegateProxy) public proxies;}
1 // SPDX-License-Identifier: MIT
2 
3     pragma solidity ^0.8.0;
4     abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {return msg.sender;}
6     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
7 
8 // File: @openzeppelin/contracts/access/Ownable.sol
9 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
10     pragma solidity ^0.8.0;
11     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12     constructor() {_transferOwnership(_msgSender());}
13     function owner() public view virtual returns (address) {return _owner;}
14     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner"); _;}
15     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
16     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
17     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
18 
19 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
20 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
21     library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23     function toString(uint256 value) internal pure returns (string memory) {
24         if (value == 0) {return "0";} uint256 temp = value; uint256 digits; while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits);
25         while (value != 0) {digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
26     function toHexString(uint256 value) internal pure returns (string memory) {
27         if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0; while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
28     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x";
29         for (uint256 i = 2 * length + 1; i > 1; --i) {buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;} require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
30 
31 // File: erc721a/contracts/IERC721A.sol
32 // ERC721A Contracts v4.0.0
33     pragma solidity ^0.8.4;
34     interface IERC721A {error ApprovalCallerNotOwnerNorApproved();
35     error ApprovalQueryForNonexistentToken();
36     error ApproveToCaller();
37     error ApprovalToCurrentOwner();
38     error BalanceQueryForZeroAddress();
39     error MintToZeroAddress();
40     error MintZeroQuantity();
41     error OwnerQueryForNonexistentToken();
42     error TransferCallerNotOwnerNorApproved();
43     error TransferFromIncorrectOwner();
44     error TransferToNonERC721ReceiverImplementer();
45     error TransferToZeroAddress();
46     error URIQueryForNonexistentToken();
47     struct TokenOwnership {address addr; uint64 startTimestamp; bool burned;}
48     function totalSupply() external view returns (uint256);
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53     function balanceOf(address owner) external view returns (uint256 balance);
54     function ownerOf(uint256 tokenId) external view returns (address owner);
55     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
56     function safeTransferFrom(address from, address to, uint256 tokenId) external;
57     function transferFrom(address from, address to, uint256 tokenId) external;
58     function approve(address to, uint256 tokenId) external;
59     function setApprovalForAll(address operator, bool _approved) external;
60     function getApproved(uint256 tokenId) external view returns (address operator);
61     function isApprovedForAll(address owner, address operator) external view returns (bool);
62     function name() external view returns (string memory);
63     function symbol() external view returns (string memory);
64     function tokenURI(uint256 tokenId) external view returns (string memory);}
65 
66 // File: erc721a/contracts/ERC721A.sol
67 // ERC721A Contracts v4.0.0
68     pragma solidity ^0.8.4; interface ERC721A__IERC721Receiver {
69     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
70 
71     contract ERC721A is IERC721A {
72     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
73     uint256 private constant BITPOS_NUMBER_MINTED = 64;
74     uint256 private constant BITPOS_NUMBER_BURNED = 128;
75     uint256 private constant BITPOS_AUX = 192;
76     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
77     uint256 private constant BITPOS_START_TIMESTAMP = 160;
78     uint256 private constant BITMASK_BURNED = 1 << 224;
79     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
80     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
81     uint256 private _currentIndex;
82     uint256 private _burnCounter;
83     string private _name;
84     string private _symbol;
85     mapping(uint256 => uint256) private _packedOwnerships;
86     mapping(address => uint256) private _packedAddressData;
87     mapping(uint256 => address) private _tokenApprovals;
88     mapping(address => mapping(address => bool)) private _operatorApprovals;
89     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_; _currentIndex = _startTokenId();}
90     function _startTokenId() internal view virtual returns (uint256) {return 1;}
91     function _nextTokenId() internal view returns (uint256) {return _currentIndex;}
92     function totalSupply() public view override returns (uint256) {unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
93     function _totalMinted() internal view returns (uint256) {unchecked {return _currentIndex - _startTokenId();}}
94     function _totalBurned() internal view returns (uint256) {return _burnCounter;}
95     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
96     function balanceOf(address owner) public view override returns (uint256) {if (owner == address(0)) revert BalanceQueryForZeroAddress(); return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
97     function _numberMinted(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
98     function _numberBurned(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
99     function _getAux(address owner) internal view returns (uint64) {return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
100     function _setAux(address owner, uint64 aux) internal {uint256 packed = _packedAddressData[owner]; uint256 auxCasted; assembly {auxCasted := aux}
101         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);_packedAddressData[owner] = packed;}
102     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {uint256 curr = tokenId; unchecked {
103         if (_startTokenId() <= curr) 
104         if (curr < _currentIndex) {uint256 packed = _packedOwnerships[curr]; 
105         if (packed & BITMASK_BURNED == 0) {while (packed == 0) {packed = _packedOwnerships[--curr];} return packed; }}} revert OwnerQueryForNonexistentToken();}
106     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
107         ownership.addr = address(uint160(packed)); ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP); ownership.burned = packed & BITMASK_BURNED != 0;}
108     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnerships[index]);}
109     function _initializeOwnershipAt(uint256 index) internal {if (_packedOwnerships[index] == 0) {_packedOwnerships[index] = _packedOwnershipOf(index);}}
110     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnershipOf(tokenId));}
111     function ownerOf(uint256 tokenId) public view override returns (address) {return address(uint160(_packedOwnershipOf(tokenId)));}
112     function name() public view virtual override returns (string memory) {return _name;}
113     function symbol() public view virtual override returns (string memory) {return _symbol;}
114     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
115         if (!_exists(tokenId)) revert URIQueryForNonexistentToken(); string memory baseURI = _baseURI(); return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
116     function _baseURI() internal view virtual returns (string memory) {return '';}
117     function _addressToUint256(address value) private pure returns (uint256 result) {assembly {result := value}}
118     function _boolToUint256(bool value) private pure returns (uint256 result) {assembly {result := value}}
119     function approve(address to, uint256 tokenId) public override {address owner = address(uint160(_packedOwnershipOf(tokenId)));
120         if (to == owner) revert ApprovalToCurrentOwner();
121         if (_msgSenderERC721A() != owner)
122         if (!isApprovedForAll(owner, _msgSenderERC721A())) {revert ApprovalCallerNotOwnerNorApproved();}_tokenApprovals[tokenId] = to;emit Approval(owner, to, tokenId);}
123     function getApproved(uint256 tokenId) public view override returns (address) {if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken(); return _tokenApprovals[tokenId];}
124     function setApprovalForAll(address operator, bool approved) public virtual override {
125         if (operator == _msgSenderERC721A()) revert ApproveToCaller(); _operatorApprovals[_msgSenderERC721A()][operator] = approved; emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
126     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
127     function transferFrom(address from, address to, uint256 tokenId) public virtual override {_transfer(from, to, tokenId);}
128     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {safeTransferFrom(from, to, tokenId, '');}
129     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {_transfer(from, to, tokenId);
130         if (to.code.length != 0)
131         if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {revert TransferToNonERC721ReceiverImplementer();}}
132     function _exists(uint256 tokenId) internal view returns (bool) {return
133             _startTokenId() <= tokenId &&
134             tokenId < _currentIndex &&
135             _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
136     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
137     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = _currentIndex;
138         if (to == address(0)) revert MintToZeroAddress();
139         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1); _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED); uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
140         if (to.code.length != 0) {do {emit Transfer(address(0), to, updatedIndex);
141         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {revert TransferToNonERC721ReceiverImplementer();}} while (updatedIndex < end);
142         if (_currentIndex != startTokenId) revert();} else {do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);} _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
143     function _mint(address to, uint256 quantity) internal {uint256 startTokenId = _currentIndex;
144         if (to == address(0)) revert MintToZeroAddress();
145         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
146             _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
147             uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
148             do {emit Transfer(address(0), to, updatedIndex++); } while (updatedIndex < end); _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
149     function _transfer(address from, address to, uint256 tokenId) private {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
150         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner(); bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
151         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
152         if (to == address(0)) revert TransferToZeroAddress(); _beforeTokenTransfers(from, to, tokenId, 1); delete _tokenApprovals[tokenId];
153         unchecked { --_packedAddressData[from]; ++_packedAddressData[to]; _packedOwnerships[tokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_NEXT_INITIALIZED;
154         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
155         if (_packedOwnerships[nextTokenId] == 0) {
156         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
157     function _burn(uint256 tokenId) internal virtual {_burn(tokenId, false);}
158     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId); address from = address(uint160(prevOwnershipPacked));
159         if (approvalCheck) {bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
160         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();} _beforeTokenTransfers(from, address(0), tokenId, 1); delete _tokenApprovals[tokenId];
161             unchecked {_packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1; _packedOwnerships[tokenId] = _addressToUint256(from) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_BURNED |  BITMASK_NEXT_INITIALIZED;
162         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
163         if (_packedOwnerships[nextTokenId] == 0) {
164         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, address(0), tokenId); _afterTokenTransfers(from, address(0), tokenId, 1); unchecked {_burnCounter++;}}
165     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
166         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
167         if (reason.length == 0) {revert TransferToNonERC721ReceiverImplementer();} else {assembly {revert(add(32, reason), mload(reason))}}}}
168     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
169     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
170     function _msgSenderERC721A() internal view virtual returns (address) {return msg.sender;}
171     function _toString(uint256 value) internal pure returns (string memory ptr) {assembly {ptr := add(mload(0x40), 128) mstore(0x40, ptr) let end := ptr
172         for {let temp := value ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10))) temp := div(temp, 10)} temp {temp := div(temp, 10)} 
173             {ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10)))} let length := sub(end, ptr) ptr := sub(ptr, 32) mstore(ptr, length)}}}
174 
175     pragma solidity ^0.8.13;
176     contract PepePunks is Ownable, ERC721A {
177     uint256 public maxSupply                    = 1000;
178     uint256 public maxFreeSupply                = 500;
179     uint256 public maxPerTxDuringMint           = 10;
180     uint256 public maxPerAddressDuringMint      = 10;
181     uint256 public maxPerAddressDuringFreeMint  = 1;
182     uint256 public price                        = 0.005 ether;
183     bool    public saleIsActive                 = true;
184     bool    public revealed                     = true;
185 
186     address constant internal TEAM_ADDRESS = 0x62c461bd6Da1D05C40e33357D631D647F0a3d573;
187     string public baseURI = "https://ipfs.io/ipfs/QmNdqhL7Y6BDesecDvBTMr1sGAArz8Jo5BMBv3PvqvEshy/";
188     string public constant baseExtension = "/metadata.json";
189     string public hiddenMetadataUri;
190     mapping(address => uint256) public freeMintedAmount;
191     mapping(address => uint256) public mintedAmount;
192     constructor() ERC721A("Pepe Punk", "Pepe Punk") {_safeMint(msg.sender, 50); setHiddenMetadataUri("");}
193     
194     modifier mintCompliance() {require(saleIsActive, "Sale is not active yet."); require(tx.origin == msg.sender, "Wrong Caller"); _;}
195     function mint(uint256 _quantity) external payable mintCompliance() {require (msg.value >= price * _quantity, "Insufficient Funds");
196         require(maxSupply >= totalSupply() + _quantity, "Exceeds max supply."); uint256 _mintedAmount = mintedAmount[msg.sender];
197         require(_mintedAmount + _quantity <= maxPerAddressDuringMint, "Exceeds max mints per address!");
198         require(_quantity > 0 && _quantity <= maxPerTxDuringMint, "Invalid mint amount."); mintedAmount[msg.sender] = _mintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
199     function freeMint(uint256 _quantity) external mintCompliance() {
200         require(maxFreeSupply >= totalSupply() + _quantity, "Exceeds max supply."); uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
201         require(_freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint, "Exceeds max free mints per address!"); freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
202     function setPrice(uint256 _price) external onlyOwner {price = _price;}
203     function setMaxPerTx(uint256 _amount) external onlyOwner {maxPerTxDuringMint = _amount;}
204     function setMaxPerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringMint = _amount;}
205     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringFreeMint = _amount;}
206     function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
207         require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");_safeMint(_wallet, _num);}
208     function flipSale() public onlyOwner {saleIsActive = !saleIsActive;}
209     function setMaxSupply(uint256 newSupply) public onlyOwner {maxSupply = newSupply;}
210     function cutMaxSupply(uint256 _amount) public onlyOwner {require(maxSupply - _amount >= totalSupply(), "Supply cannot fall below minted tokens."); maxSupply -= _amount;}
211     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
212     function setBaseURI(string memory baseURI_) external onlyOwner {baseURI = baseURI_;}
213     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
214     function _baseURI() internal view virtual override returns (string memory) {return baseURI;}
215     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
216         {require(_exists(_tokenId), "Token does not exist."); if (revealed == false) {return hiddenMetadataUri;} 
217         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseExtension)) : "";}
218     function withdrawBalance() external payable onlyOwner {(bool success, ) = payable(TEAM_ADDRESS).call{value: address(this).balance} (""); require(success, "transfer failed.");}}
1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5     pragma solidity ^0.8.0;
6     abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {return msg.sender;}
8     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
9 
10 // File: @openzeppelin/contracts/access/Ownable.sol
11 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
12     pragma solidity ^0.8.0;
13     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14     constructor() {_transferOwnership(_msgSender());}
15     function owner() public view virtual returns (address) {return _owner;}
16     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner"); _;}
17     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
18     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
19     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
20 
21 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
22 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
23     library Strings {
24     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
25     function toString(uint256 value) internal pure returns (string memory) {
26         if (value == 0) {return "0";} uint256 temp = value; uint256 digits; while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits);
27         while (value != 0) {digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
28     function toHexString(uint256 value) internal pure returns (string memory) {
29         if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0; while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
30     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x";
31         for (uint256 i = 2 * length + 1; i > 1; --i) {buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;} require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
32 
33 // File: erc721a/contracts/IERC721A.sol
34 // ERC721A Contracts v4.0.0
35     pragma solidity ^0.8.4;
36     interface IERC721A {error ApprovalCallerNotOwnerNorApproved();
37     error ApprovalQueryForNonexistentToken();
38     error ApproveToCaller();
39     error ApprovalToCurrentOwner();
40     error BalanceQueryForZeroAddress();
41     error MintToZeroAddress();
42     error MintZeroQuantity();
43     error OwnerQueryForNonexistentToken();
44     error TransferCallerNotOwnerNorApproved();
45     error TransferFromIncorrectOwner();
46     error TransferToNonERC721ReceiverImplementer();
47     error TransferToZeroAddress();
48     error URIQueryForNonexistentToken();
49     struct TokenOwnership {address addr; uint64 startTimestamp; bool burned;}
50     function totalSupply() external view returns (uint256);
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55     function balanceOf(address owner) external view returns (uint256 balance);
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
58     function safeTransferFrom(address from, address to, uint256 tokenId) external;
59     function transferFrom(address from, address to, uint256 tokenId) external;
60     function approve(address to, uint256 tokenId) external;
61     function setApprovalForAll(address operator, bool _approved) external;
62     function getApproved(uint256 tokenId) external view returns (address operator);
63     function isApprovedForAll(address owner, address operator) external view returns (bool);
64     function name() external view returns (string memory);
65     function symbol() external view returns (string memory);
66     function tokenURI(uint256 tokenId) external view returns (string memory);}
67 
68 // File: erc721a/contracts/ERC721A.sol
69 // ERC721A Contracts v4.0.0
70     pragma solidity ^0.8.4; interface ERC721A__IERC721Receiver {
71     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
72 
73     contract ERC721A is IERC721A {
74     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
75     uint256 private constant BITPOS_NUMBER_MINTED = 64;
76     uint256 private constant BITPOS_NUMBER_BURNED = 128;
77     uint256 private constant BITPOS_AUX = 192;
78     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
79     uint256 private constant BITPOS_START_TIMESTAMP = 160;
80     uint256 private constant BITMASK_BURNED = 1 << 224;
81     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
82     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
83     uint256 private _currentIndex;
84     uint256 private _burnCounter;
85     string private _name;
86     string private _symbol;
87     mapping(uint256 => uint256) private _packedOwnerships;
88     mapping(address => uint256) private _packedAddressData;
89     mapping(uint256 => address) private _tokenApprovals;
90     mapping(address => mapping(address => bool)) private _operatorApprovals;
91     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_; _currentIndex = _startTokenId();}
92     function _startTokenId() internal view virtual returns (uint256) {return 0;}
93     function _nextTokenId() internal view returns (uint256) {return _currentIndex;}
94     function totalSupply() public view override returns (uint256) {unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
95     function _totalMinted() internal view returns (uint256) {unchecked {return _currentIndex - _startTokenId();}}
96     function _totalBurned() internal view returns (uint256) {return _burnCounter;}
97     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
98     function balanceOf(address owner) public view override returns (uint256) {if (owner == address(0)) revert BalanceQueryForZeroAddress(); return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
99     function _numberMinted(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
100     function _numberBurned(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
101     function _getAux(address owner) internal view returns (uint64) {return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
102     function _setAux(address owner, uint64 aux) internal {uint256 packed = _packedAddressData[owner]; uint256 auxCasted; assembly {auxCasted := aux}
103         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);_packedAddressData[owner] = packed;}
104     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {uint256 curr = tokenId; unchecked {
105         if (_startTokenId() <= curr) 
106         if (curr < _currentIndex) {uint256 packed = _packedOwnerships[curr]; 
107         if (packed & BITMASK_BURNED == 0) {while (packed == 0) {packed = _packedOwnerships[--curr];} return packed; }}} revert OwnerQueryForNonexistentToken();}
108     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
109         ownership.addr = address(uint160(packed)); ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP); ownership.burned = packed & BITMASK_BURNED != 0;}
110     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnerships[index]);}
111     function _initializeOwnershipAt(uint256 index) internal {if (_packedOwnerships[index] == 0) {_packedOwnerships[index] = _packedOwnershipOf(index);}}
112     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnershipOf(tokenId));}
113     function ownerOf(uint256 tokenId) public view override returns (address) {return address(uint160(_packedOwnershipOf(tokenId)));}
114     function name() public view virtual override returns (string memory) {return _name;}
115     function symbol() public view virtual override returns (string memory) {return _symbol;}
116     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
117         if (!_exists(tokenId)) revert URIQueryForNonexistentToken(); string memory baseURI = _baseURI(); return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
118     function _baseURI() internal view virtual returns (string memory) {return '';}
119     function _addressToUint256(address value) private pure returns (uint256 result) {assembly {result := value}}
120     function _boolToUint256(bool value) private pure returns (uint256 result) {assembly {result := value}}
121     function approve(address to, uint256 tokenId) public override {address owner = address(uint160(_packedOwnershipOf(tokenId)));
122         if (to == owner) revert ApprovalToCurrentOwner();
123         if (_msgSenderERC721A() != owner)
124         if (!isApprovedForAll(owner, _msgSenderERC721A())) {revert ApprovalCallerNotOwnerNorApproved();}_tokenApprovals[tokenId] = to;emit Approval(owner, to, tokenId);}
125     function getApproved(uint256 tokenId) public view override returns (address) {if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken(); return _tokenApprovals[tokenId];}
126     function setApprovalForAll(address operator, bool approved) public virtual override {
127         if (operator == _msgSenderERC721A()) revert ApproveToCaller(); _operatorApprovals[_msgSenderERC721A()][operator] = approved; emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
128     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
129     function transferFrom(address from, address to, uint256 tokenId) public virtual override {_transfer(from, to, tokenId);}
130     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {safeTransferFrom(from, to, tokenId, '');}
131     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {_transfer(from, to, tokenId);
132         if (to.code.length != 0)
133         if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {revert TransferToNonERC721ReceiverImplementer();}}
134     function _exists(uint256 tokenId) internal view returns (bool) {return
135             _startTokenId() <= tokenId &&
136             tokenId < _currentIndex &&
137             _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
138     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
139     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = _currentIndex;
140         if (to == address(0)) revert MintToZeroAddress();
141         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1); _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED); uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
142         if (to.code.length != 0) {do {emit Transfer(address(0), to, updatedIndex);
143         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {revert TransferToNonERC721ReceiverImplementer();}} while (updatedIndex < end);
144         if (_currentIndex != startTokenId) revert();} else {do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);} _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
145     function _mint(address to, uint256 quantity) internal {uint256 startTokenId = _currentIndex;
146         if (to == address(0)) revert MintToZeroAddress();
147         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
148             _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
149             uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
150             do {emit Transfer(address(0), to, updatedIndex++); } while (updatedIndex < end); _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
151     function _transfer(address from, address to, uint256 tokenId) private {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
152         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner(); bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
153         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
154         if (to == address(0)) revert TransferToZeroAddress(); _beforeTokenTransfers(from, to, tokenId, 1); delete _tokenApprovals[tokenId];
155         unchecked { --_packedAddressData[from]; ++_packedAddressData[to]; _packedOwnerships[tokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_NEXT_INITIALIZED;
156         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
157         if (_packedOwnerships[nextTokenId] == 0) {
158         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
159     function _burn(uint256 tokenId) internal virtual {_burn(tokenId, false);}
160     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId); address from = address(uint160(prevOwnershipPacked));
161         if (approvalCheck) {bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
162         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();} _beforeTokenTransfers(from, address(0), tokenId, 1); delete _tokenApprovals[tokenId];
163             unchecked {_packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1; _packedOwnerships[tokenId] = _addressToUint256(from) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_BURNED |  BITMASK_NEXT_INITIALIZED;
164         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
165         if (_packedOwnerships[nextTokenId] == 0) {
166         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, address(0), tokenId); _afterTokenTransfers(from, address(0), tokenId, 1); unchecked {_burnCounter++;}}
167     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
168         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
169         if (reason.length == 0) {revert TransferToNonERC721ReceiverImplementer();} else {assembly {revert(add(32, reason), mload(reason))}}}}
170     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
171     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
172     function _msgSenderERC721A() internal view virtual returns (address) {return msg.sender;}
173     function _toString(uint256 value) internal pure returns (string memory ptr) {assembly {ptr := add(mload(0x40), 128) mstore(0x40, ptr) let end := ptr
174         for {let temp := value ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10))) temp := div(temp, 10)} temp {temp := div(temp, 10)} 
175             {ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10)))} let length := sub(end, ptr) ptr := sub(ptr, 32) mstore(ptr, length)}}}
176 
177 // File: nft.sol
178 
179     pragma solidity ^0.8.13;
180     contract LegendaryHyenas is Ownable, ERC721A {
181     uint256 public maxSupply                    = 555;
182     uint256 public maxFreeSupply                = 222;
183     uint256 public maxPerTxDuringMint           = 10;
184     uint256 public maxPerAddressDuringMint      = 20;
185     uint256 public maxPerAddressDuringFreeMint  = 1;
186     uint256 public price                        = 0.004 ether;
187     bool    public saleIsActive                 = true;
188 
189     address constant internal TEAM_ADDRESS = 0xD171f980bB0E6822a6fc2737469cFe2004c951bc;
190     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmNX8Fk55B2yMsMz1sqvrzzQuzwLSJhibv9BssrKQENXzF/";
191     string public constant baseExtension = ".json";
192     mapping(address => uint256) public freeMintedAmount;
193     mapping(address => uint256) public mintedAmount;
194 
195     constructor() ERC721A("LegendaryHyenas", "HYENA") {_safeMint(msg.sender, 1);}
196     modifier mintCompliance() {require(saleIsActive, "Sale is not active yet."); require(tx.origin == msg.sender, "Wrong Caller"); _;}
197     function mint(uint256 _quantity) external payable mintCompliance() {require (msg.value >= price * _quantity, "GDZ: Insufficient Fund.");
198         require(maxSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _mintedAmount = mintedAmount[msg.sender];
199         require(_mintedAmount + _quantity <= maxPerAddressDuringMint, "GDZ: Exceeds max mints per address!");
200         require(_quantity > 0 && _quantity <= maxPerTxDuringMint, "Invalid mint amount."); mintedAmount[msg.sender] = _mintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
201     function freeMint(uint256 _quantity) external mintCompliance() {
202         require(maxFreeSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
203         require(_freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint, "GDZ: Exceeds max free mints per address!"); freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
204     function setPrice(uint256 _price) external onlyOwner {price = _price;}
205     function setMaxPerTx(uint256 _amount) external onlyOwner {maxPerTxDuringMint = _amount;}
206     function setMaxPerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringMint = _amount;}
207     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringFreeMint = _amount;}
208     function flipSale() public onlyOwner {saleIsActive = !saleIsActive;}
209     function setMaxSupply(uint256 newSupply) public onlyOwner {maxSupply = newSupply;}
210     function cutMaxSupply(uint256 _amount) public onlyOwner {require(maxSupply - _amount >= totalSupply(), "Supply cannot fall below minted tokens."); maxSupply -= _amount;}
211     function setBaseURI(string memory baseURI_) external onlyOwner {baseURI = baseURI_;}
212     function _baseURI() internal view virtual override returns (string memory) {return baseURI;}
213     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
214         require(_exists(_tokenId), "Token does not exist."); return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseExtension)) : "";}
215     function withdrawBalance() external payable onlyOwner {(bool success, ) = payable(TEAM_ADDRESS).call{value: address(this).balance} (""); require(success, "transfer failed.");}}
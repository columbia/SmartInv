1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/degenmoments.sol
4 // File: @openzeppelin/contracts/utils/Context.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6     pragma solidity ^0.8.0;
7     abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {return msg.sender;}
9     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
10 
11 // File: @openzeppelin/contracts/access/Ownable.sol
12 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
13     pragma solidity ^0.8.0;
14     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15     constructor() {_transferOwnership(_msgSender());}
16     function owner() public view virtual returns (address) {return _owner;}
17     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner"); _;}
18     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
19     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
20     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
21 
22 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24     library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26     function toString(uint256 value) internal pure returns (string memory) {
27         if (value == 0) {return "0";} uint256 temp = value; uint256 digits; while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits);
28         while (value != 0) {digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
29     function toHexString(uint256 value) internal pure returns (string memory) {
30         if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0; while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
31     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x";
32         for (uint256 i = 2 * length + 1; i > 1; --i) {buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;} require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
33 
34 // File: erc721a/contracts/IERC721A.sol
35 // ERC721A Contracts v4.0.0
36     pragma solidity ^0.8.4;
37     interface IERC721A {error ApprovalCallerNotOwnerNorApproved();
38     error ApprovalQueryForNonexistentToken();
39     error ApproveToCaller();
40     error ApprovalToCurrentOwner();
41     error BalanceQueryForZeroAddress();
42     error MintToZeroAddress();
43     error MintZeroQuantity();
44     error OwnerQueryForNonexistentToken();
45     error TransferCallerNotOwnerNorApproved();
46     error TransferFromIncorrectOwner();
47     error TransferToNonERC721ReceiverImplementer();
48     error TransferToZeroAddress();
49     error URIQueryForNonexistentToken();
50     struct TokenOwnership {address addr; uint64 startTimestamp; bool burned;}
51     function totalSupply() external view returns (uint256);
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
54     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56     function balanceOf(address owner) external view returns (uint256 balance);
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
59     function safeTransferFrom(address from, address to, uint256 tokenId) external;
60     function transferFrom(address from, address to, uint256 tokenId) external;
61     function approve(address to, uint256 tokenId) external;
62     function setApprovalForAll(address operator, bool _approved) external;
63     function getApproved(uint256 tokenId) external view returns (address operator);
64     function isApprovedForAll(address owner, address operator) external view returns (bool);
65     function name() external view returns (string memory);
66     function symbol() external view returns (string memory);
67     function tokenURI(uint256 tokenId) external view returns (string memory);}
68 
69 // File: erc721a/contracts/ERC721A.sol
70 // ERC721A Contracts v4.0.0
71     pragma solidity ^0.8.4; interface ERC721A__IERC721Receiver {
72     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
73 
74     contract ERC721A is IERC721A {
75     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
76     uint256 private constant BITPOS_NUMBER_MINTED = 64;
77     uint256 private constant BITPOS_NUMBER_BURNED = 128;
78     uint256 private constant BITPOS_AUX = 192;
79     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
80     uint256 private constant BITPOS_START_TIMESTAMP = 160;
81     uint256 private constant BITMASK_BURNED = 1 << 224;
82     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
83     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
84     uint256 private _currentIndex;
85     uint256 private _burnCounter;
86     string private _name;
87     string private _symbol;
88     mapping(uint256 => uint256) private _packedOwnerships;
89     mapping(address => uint256) private _packedAddressData;
90     mapping(uint256 => address) private _tokenApprovals;
91     mapping(address => mapping(address => bool)) private _operatorApprovals;
92     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_; _currentIndex = _startTokenId();}
93     function _startTokenId() internal view virtual returns (uint256) {return 0;}
94     function _nextTokenId() internal view returns (uint256) {return _currentIndex;}
95     function totalSupply() public view override returns (uint256) {unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
96     function _totalMinted() internal view returns (uint256) {unchecked {return _currentIndex - _startTokenId();}}
97     function _totalBurned() internal view returns (uint256) {return _burnCounter;}
98     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
99     function balanceOf(address owner) public view override returns (uint256) {if (owner == address(0)) revert BalanceQueryForZeroAddress(); return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
100     function _numberMinted(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
101     function _numberBurned(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
102     function _getAux(address owner) internal view returns (uint64) {return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
103     function _setAux(address owner, uint64 aux) internal {uint256 packed = _packedAddressData[owner]; uint256 auxCasted; assembly {auxCasted := aux}
104         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);_packedAddressData[owner] = packed;}
105     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {uint256 curr = tokenId; unchecked {
106         if (_startTokenId() <= curr) 
107         if (curr < _currentIndex) {uint256 packed = _packedOwnerships[curr]; 
108         if (packed & BITMASK_BURNED == 0) {while (packed == 0) {packed = _packedOwnerships[--curr];} return packed; }}} revert OwnerQueryForNonexistentToken();}
109     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
110         ownership.addr = address(uint160(packed)); ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP); ownership.burned = packed & BITMASK_BURNED != 0;}
111     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnerships[index]);}
112     function _initializeOwnershipAt(uint256 index) internal {if (_packedOwnerships[index] == 0) {_packedOwnerships[index] = _packedOwnershipOf(index);}}
113     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnershipOf(tokenId));}
114     function ownerOf(uint256 tokenId) public view override returns (address) {return address(uint160(_packedOwnershipOf(tokenId)));}
115     function name() public view virtual override returns (string memory) {return _name;}
116     function symbol() public view virtual override returns (string memory) {return _symbol;}
117     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
118         if (!_exists(tokenId)) revert URIQueryForNonexistentToken(); string memory baseURI = _baseURI(); return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
119     function _baseURI() internal view virtual returns (string memory) {return '';}
120     function _addressToUint256(address value) private pure returns (uint256 result) {assembly {result := value}}
121     function _boolToUint256(bool value) private pure returns (uint256 result) {assembly {result := value}}
122     function approve(address to, uint256 tokenId) public override {address owner = address(uint160(_packedOwnershipOf(tokenId)));
123         if (to == owner) revert ApprovalToCurrentOwner();
124         if (_msgSenderERC721A() != owner)
125         if (!isApprovedForAll(owner, _msgSenderERC721A())) {revert ApprovalCallerNotOwnerNorApproved();}_tokenApprovals[tokenId] = to;emit Approval(owner, to, tokenId);}
126     function getApproved(uint256 tokenId) public view override returns (address) {if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken(); return _tokenApprovals[tokenId];}
127     function setApprovalForAll(address operator, bool approved) public virtual override {
128         if (operator == _msgSenderERC721A()) revert ApproveToCaller(); _operatorApprovals[_msgSenderERC721A()][operator] = approved; emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
129     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
130     function transferFrom(address from, address to, uint256 tokenId) public virtual override {_transfer(from, to, tokenId);}
131     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {safeTransferFrom(from, to, tokenId, '');}
132     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {_transfer(from, to, tokenId);
133         if (to.code.length != 0)
134         if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {revert TransferToNonERC721ReceiverImplementer();}}
135     function _exists(uint256 tokenId) internal view returns (bool) {return
136             _startTokenId() <= tokenId &&
137             tokenId < _currentIndex &&
138             _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
139     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
140     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = _currentIndex;
141         if (to == address(0)) revert MintToZeroAddress();
142         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1); _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED); uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
143         if (to.code.length != 0) {do {emit Transfer(address(0), to, updatedIndex);
144         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {revert TransferToNonERC721ReceiverImplementer();}} while (updatedIndex < end);
145         if (_currentIndex != startTokenId) revert();} else {do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);} _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
146     function _mint(address to, uint256 quantity) internal {uint256 startTokenId = _currentIndex;
147         if (to == address(0)) revert MintToZeroAddress();
148         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
149             _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
150             uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
151             do {emit Transfer(address(0), to, updatedIndex++); } while (updatedIndex < end); _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
152     function _transfer(address from, address to, uint256 tokenId) private {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
153         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner(); bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
154         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
155         if (to == address(0)) revert TransferToZeroAddress(); _beforeTokenTransfers(from, to, tokenId, 1); delete _tokenApprovals[tokenId];
156         unchecked { --_packedAddressData[from]; ++_packedAddressData[to]; _packedOwnerships[tokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_NEXT_INITIALIZED;
157         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
158         if (_packedOwnerships[nextTokenId] == 0) {
159         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
160     function _burn(uint256 tokenId) internal virtual {_burn(tokenId, false);}
161     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId); address from = address(uint160(prevOwnershipPacked));
162         if (approvalCheck) {bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();} _beforeTokenTransfers(from, address(0), tokenId, 1); delete _tokenApprovals[tokenId];
164             unchecked {_packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1; _packedOwnerships[tokenId] = _addressToUint256(from) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_BURNED |  BITMASK_NEXT_INITIALIZED;
165         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
166         if (_packedOwnerships[nextTokenId] == 0) {
167         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, address(0), tokenId); _afterTokenTransfers(from, address(0), tokenId, 1); unchecked {_burnCounter++;}}
168     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
169         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
170         if (reason.length == 0) {revert TransferToNonERC721ReceiverImplementer();} else {assembly {revert(add(32, reason), mload(reason))}}}}
171     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
172     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
173     function _msgSenderERC721A() internal view virtual returns (address) {return msg.sender;}
174     function _toString(uint256 value) internal pure returns (string memory ptr) {assembly {ptr := add(mload(0x40), 128) mstore(0x40, ptr) let end := ptr
175         for {let temp := value ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10))) temp := div(temp, 10)} temp {temp := div(temp, 10)} 
176             {ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10)))} let length := sub(end, ptr) ptr := sub(ptr, 32) mstore(ptr, length)}}}
177 
178 
179 
180     pragma solidity ^0.8.13;
181     contract DegenMoments is Ownable, ERC721A {
182     uint256 public maxSupply                    = 1111;
183     uint256 public maxFreeSupply                = 1111;
184     uint256 public maxPerTxDuringMint           = 1;
185     uint256 public maxPerAddressDuringMint      = 1;
186     uint256 public maxPerAddressDuringFreeMint  = 1;
187     uint256 public price                        = 0 ether;
188     bool    public saleIsActive                 = true;
189 
190     address constant internal TEAM_ADDRESS = 0xc953C2275CBdBD07940E8f12B09256164C1dCCCC;
191     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmbPPL6tajaMGYszT6akdVZVGjj9GMgYsMryfCgsyyP66j/";
192     string public constant baseExtension = ".json";
193     mapping(address => uint256) public freeMintedAmount;
194     mapping(address => uint256) public mintedAmount;
195 
196     constructor() ERC721A("DegenMoments", "DEGEN") {_safeMint(msg.sender, 1);}
197     modifier mintCompliance() {require(saleIsActive, "Sale is not active yet."); require(tx.origin == msg.sender, "Wrong Caller"); _;}
198     function mint(uint256 _quantity) external payable mintCompliance() {require (msg.value >= price * _quantity, "GDZ: Insufficient Fund.");
199         require(maxSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _mintedAmount = mintedAmount[msg.sender];
200         require(_mintedAmount + _quantity <= maxPerAddressDuringMint, "GDZ: Exceeds max mints per address!");
201         require(_quantity > 0 && _quantity <= maxPerTxDuringMint, "Invalid mint amount."); mintedAmount[msg.sender] = _mintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
202     function freeMint(uint256 _quantity) external mintCompliance() {
203         require(maxFreeSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
204         require(_freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint, "GDZ: Exceeds max free mints per address!"); freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
205     function setPrice(uint256 _price) external onlyOwner {price = _price;}
206     function setMaxPerTx(uint256 _amount) external onlyOwner {maxPerTxDuringMint = _amount;}
207     function setMaxPerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringMint = _amount;}
208     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringFreeMint = _amount;}
209     function flipSale() public onlyOwner {saleIsActive = !saleIsActive;}
210     function setMaxSupply(uint256 newSupply) public onlyOwner {maxSupply = newSupply;}
211     function cutMaxSupply(uint256 _amount) public onlyOwner {require(maxSupply - _amount >= totalSupply(), "Supply cannot fall below minted tokens."); maxSupply -= _amount;}
212     function setBaseURI(string memory baseURI_) external onlyOwner {baseURI = baseURI_;}
213     function _baseURI() internal view virtual override returns (string memory) {return baseURI;}
214     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
215         require(_exists(_tokenId), "Token does not exist."); return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseExtension)) : "";}
216     function withdrawBalance() external payable onlyOwner {(bool success, ) = payable(TEAM_ADDRESS).call{value: address(this).balance} (""); require(success, "transfer failed.");}}
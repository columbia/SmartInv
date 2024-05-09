1 // 尸丂ㄚ⼕廾龱
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: contracts/psychonft.sol
6 // File: @openzeppelin/contracts/utils/Context.sol
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8     pragma solidity ^0.8.0;
9     abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {return msg.sender;}
11     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
12 
13 // File: @openzeppelin/contracts/access/Ownable.sol
14 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
15     pragma solidity ^0.8.0;
16     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17     constructor() {_transferOwnership(_msgSender());}
18     function owner() public view virtual returns (address) {return _owner;}
19     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner"); _;}
20     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
21     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
22     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
23 
24 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26     library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28     function toString(uint256 value) internal pure returns (string memory) {
29         if (value == 0) {return "0";} uint256 temp = value; uint256 digits; while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits);
30         while (value != 0) {digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
31     function toHexString(uint256 value) internal pure returns (string memory) {
32         if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0; while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
33     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x";
34         for (uint256 i = 2 * length + 1; i > 1; --i) {buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;} require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
35 
36 // File: erc721a/contracts/IERC721A.sol
37 // ERC721A Contracts v4.0.0
38     pragma solidity ^0.8.4;
39     interface IERC721A {error ApprovalCallerNotOwnerNorApproved();
40     error ApprovalQueryForNonexistentToken();
41     error ApproveToCaller();
42     error ApprovalToCurrentOwner();
43     error BalanceQueryForZeroAddress();
44     error MintToZeroAddress();
45     error MintZeroQuantity();
46     error OwnerQueryForNonexistentToken();
47     error TransferCallerNotOwnerNorApproved();
48     error TransferFromIncorrectOwner();
49     error TransferToNonERC721ReceiverImplementer();
50     error TransferToZeroAddress();
51     error URIQueryForNonexistentToken();
52     struct TokenOwnership {address addr; uint64 startTimestamp; bool burned;}
53     function totalSupply() external view returns (uint256);
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58     function balanceOf(address owner) external view returns (uint256 balance);
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
61     function safeTransferFrom(address from, address to, uint256 tokenId) external;
62     function transferFrom(address from, address to, uint256 tokenId) external;
63     function approve(address to, uint256 tokenId) external;
64     function setApprovalForAll(address operator, bool _approved) external;
65     function getApproved(uint256 tokenId) external view returns (address operator);
66     function isApprovedForAll(address owner, address operator) external view returns (bool);
67     function name() external view returns (string memory);
68     function symbol() external view returns (string memory);
69     function tokenURI(uint256 tokenId) external view returns (string memory);}
70 
71 // File: erc721a/contracts/ERC721A.sol
72 // ERC721A Contracts v4.0.0
73     pragma solidity ^0.8.4; interface ERC721A__IERC721Receiver {
74     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
75 
76     contract ERC721A is IERC721A {
77     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
78     uint256 private constant BITPOS_NUMBER_MINTED = 64;
79     uint256 private constant BITPOS_NUMBER_BURNED = 128;
80     uint256 private constant BITPOS_AUX = 192;
81     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
82     uint256 private constant BITPOS_START_TIMESTAMP = 160;
83     uint256 private constant BITMASK_BURNED = 1 << 224;
84     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
85     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
86     uint256 private _currentIndex;
87     uint256 private _burnCounter;
88     string private _name;
89     string private _symbol;
90     mapping(uint256 => uint256) private _packedOwnerships;
91     mapping(address => uint256) private _packedAddressData;
92     mapping(uint256 => address) private _tokenApprovals;
93     mapping(address => mapping(address => bool)) private _operatorApprovals;
94     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_; _currentIndex = _startTokenId();}
95     function _startTokenId() internal view virtual returns (uint256) {return 1;}
96     function _nextTokenId() internal view returns (uint256) {return _currentIndex;}
97     function totalSupply() public view override returns (uint256) {unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
98     function _totalMinted() internal view returns (uint256) {unchecked {return _currentIndex - _startTokenId();}}
99     function _totalBurned() internal view returns (uint256) {return _burnCounter;}
100     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
101     function balanceOf(address owner) public view override returns (uint256) {if (owner == address(0)) revert BalanceQueryForZeroAddress(); return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
102     function _numberMinted(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
103     function _numberBurned(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
104     function _getAux(address owner) internal view returns (uint64) {return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
105     function _setAux(address owner, uint64 aux) internal {uint256 packed = _packedAddressData[owner]; uint256 auxCasted; assembly {auxCasted := aux}
106         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);_packedAddressData[owner] = packed;}
107     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {uint256 curr = tokenId; unchecked {
108         if (_startTokenId() <= curr) 
109         if (curr < _currentIndex) {uint256 packed = _packedOwnerships[curr]; 
110         if (packed & BITMASK_BURNED == 0) {while (packed == 0) {packed = _packedOwnerships[--curr];} return packed; }}} revert OwnerQueryForNonexistentToken();}
111     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
112         ownership.addr = address(uint160(packed)); ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP); ownership.burned = packed & BITMASK_BURNED != 0;}
113     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnerships[index]);}
114     function _initializeOwnershipAt(uint256 index) internal {if (_packedOwnerships[index] == 0) {_packedOwnerships[index] = _packedOwnershipOf(index);}}
115     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnershipOf(tokenId));}
116     function ownerOf(uint256 tokenId) public view override returns (address) {return address(uint160(_packedOwnershipOf(tokenId)));}
117     function name() public view virtual override returns (string memory) {return _name;}
118     function symbol() public view virtual override returns (string memory) {return _symbol;}
119     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
120         if (!_exists(tokenId)) revert URIQueryForNonexistentToken(); string memory baseURI = _baseURI(); return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
121     function _baseURI() internal view virtual returns (string memory) {return '';}
122     function _addressToUint256(address value) private pure returns (uint256 result) {assembly {result := value}}
123     function _boolToUint256(bool value) private pure returns (uint256 result) {assembly {result := value}}
124     function approve(address to, uint256 tokenId) public override {address owner = address(uint160(_packedOwnershipOf(tokenId)));
125         if (to == owner) revert ApprovalToCurrentOwner();
126         if (_msgSenderERC721A() != owner)
127         if (!isApprovedForAll(owner, _msgSenderERC721A())) {revert ApprovalCallerNotOwnerNorApproved();}_tokenApprovals[tokenId] = to;emit Approval(owner, to, tokenId);}
128     function getApproved(uint256 tokenId) public view override returns (address) {if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken(); return _tokenApprovals[tokenId];}
129     function setApprovalForAll(address operator, bool approved) public virtual override {
130         if (operator == _msgSenderERC721A()) revert ApproveToCaller(); _operatorApprovals[_msgSenderERC721A()][operator] = approved; emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
131     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
132     function transferFrom(address from, address to, uint256 tokenId) public virtual override {_transfer(from, to, tokenId);}
133     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {safeTransferFrom(from, to, tokenId, '');}
134     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {_transfer(from, to, tokenId);
135         if (to.code.length != 0)
136         if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {revert TransferToNonERC721ReceiverImplementer();}}
137     function _exists(uint256 tokenId) internal view returns (bool) {return
138             _startTokenId() <= tokenId &&
139             tokenId < _currentIndex &&
140             _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
141     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
142     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = _currentIndex;
143         if (to == address(0)) revert MintToZeroAddress();
144         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1); _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED); uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
145         if (to.code.length != 0) {do {emit Transfer(address(0), to, updatedIndex);
146         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {revert TransferToNonERC721ReceiverImplementer();}} while (updatedIndex < end);
147         if (_currentIndex != startTokenId) revert();} else {do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);} _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
148     function _mint(address to, uint256 quantity) internal {uint256 startTokenId = _currentIndex;
149         if (to == address(0)) revert MintToZeroAddress();
150         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
151             _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
152             uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
153             do {emit Transfer(address(0), to, updatedIndex++); } while (updatedIndex < end); _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
154     function _transfer(address from, address to, uint256 tokenId) private {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
155         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner(); bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
156         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
157         if (to == address(0)) revert TransferToZeroAddress(); _beforeTokenTransfers(from, to, tokenId, 1); delete _tokenApprovals[tokenId];
158         unchecked { --_packedAddressData[from]; ++_packedAddressData[to]; _packedOwnerships[tokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_NEXT_INITIALIZED;
159         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
160         if (_packedOwnerships[nextTokenId] == 0) {
161         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
162     function _burn(uint256 tokenId) internal virtual {_burn(tokenId, false);}
163     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId); address from = address(uint160(prevOwnershipPacked));
164         if (approvalCheck) {bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
165         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();} _beforeTokenTransfers(from, address(0), tokenId, 1); delete _tokenApprovals[tokenId];
166             unchecked {_packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1; _packedOwnerships[tokenId] = _addressToUint256(from) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_BURNED |  BITMASK_NEXT_INITIALIZED;
167         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
168         if (_packedOwnerships[nextTokenId] == 0) {
169         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, address(0), tokenId); _afterTokenTransfers(from, address(0), tokenId, 1); unchecked {_burnCounter++;}}
170     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
171         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
172         if (reason.length == 0) {revert TransferToNonERC721ReceiverImplementer();} else {assembly {revert(add(32, reason), mload(reason))}}}}
173     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
174     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
175     function _msgSenderERC721A() internal view virtual returns (address) {return msg.sender;}
176     function _toString(uint256 value) internal pure returns (string memory ptr) {assembly {ptr := add(mload(0x40), 128) mstore(0x40, ptr) let end := ptr
177         for {let temp := value ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10))) temp := div(temp, 10)} temp {temp := div(temp, 10)} 
178             {ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10)))} let length := sub(end, ptr) ptr := sub(ptr, 32) mstore(ptr, length)}}}
179 
180     pragma solidity ^0.8.13;
181     contract PSYCHO is Ownable, ERC721A {
182     uint256 public maxSupply                    = 8888;
183     uint256 public maxFreeSupply                = 8888;
184     uint256 public maxPerTxDuringMint           = 20;
185     uint256 public maxPerAddressDuringMint      = 21;
186     uint256 public maxPerAddressDuringFreeMint  = 1;
187     uint256 public price                        = 0.003 ether;
188     bool    public saleIsActive                 = true;
189     bool    public revealed                     = false;
190 
191     address constant internal TEAM_ADDRESS = 0x06C8033719b4fa22DE97d4632b4120D2F429c538;
192     string public baseURI = "";
193     string public constant baseExtension = "";
194     string public hiddenMetadataUri;
195     mapping(address => uint256) public freeMintedAmount;
196     mapping(address => uint256) public mintedAmount;
197     constructor() ERC721A("PSYCHO", "PSYCHO") {_safeMint(msg.sender, 1); setHiddenMetadataUri("https://gateway.pinata.cloud/ipfs/QmcJ9dJMmgNiUD9oSASjgxhbuqam7y2WVSxDKLuX3GFyz5");}
198     
199     modifier mintCompliance() {require(saleIsActive, "Sale is not active yet."); require(tx.origin == msg.sender, "Wrong Caller"); _;}
200     function mint(uint256 _quantity) external payable mintCompliance() {require (msg.value >= price * _quantity, "GDZ: Insufficient Fund.");
201         require(maxSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _mintedAmount = mintedAmount[msg.sender];
202         require(_mintedAmount + _quantity <= maxPerAddressDuringMint, "GDZ: Exceeds max mints per address!");
203         require(_quantity > 0 && _quantity <= maxPerTxDuringMint, "Invalid mint amount."); mintedAmount[msg.sender] = _mintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
204     function freeMint(uint256 _quantity) external mintCompliance() {
205         require(maxFreeSupply >= totalSupply() + _quantity, "GDZ: Exceeds max supply."); uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
206         require(_freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint, "GDZ: Exceeds max free mints per address!"); freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
207     function setPrice(uint256 _price) external onlyOwner {price = _price;}
208     function setMaxPerTx(uint256 _amount) external onlyOwner {maxPerTxDuringMint = _amount;}
209     function setMaxPerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringMint = _amount;}
210     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringFreeMint = _amount;}
211     function flipSale() public onlyOwner {saleIsActive = !saleIsActive;}
212     function setMaxSupply(uint256 newSupply) public onlyOwner {maxSupply = newSupply;}
213     function cutMaxSupply(uint256 _amount) public onlyOwner {require(maxSupply - _amount >= totalSupply(), "Supply cannot fall below minted tokens."); maxSupply -= _amount;}
214     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
215     function setBaseURI(string memory baseURI_) external onlyOwner {baseURI = baseURI_;}
216     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
217     function _baseURI() internal view virtual override returns (string memory) {return baseURI;}
218     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
219         {require(_exists(_tokenId), "Token does not exist."); if (revealed == false) {return hiddenMetadataUri;} 
220         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseExtension)) : "";}
221     function withdrawBalance() external payable onlyOwner {(bool success, ) = payable(TEAM_ADDRESS).call{value: address(this).balance} (""); require(success, "transfer failed.");}}
1 // SPDX-License-Identifier: MIT
2     
3     abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {return msg.sender;}
5     function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}
6 
7 // File: @openzeppelin/contracts/access/Ownable.sol
8 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
9     pragma solidity ^0.8.0;
10     abstract contract Ownable is Context {address private _owner; event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11     constructor() {_transferOwnership(_msgSender());}
12     function owner() public view virtual returns (address) {return _owner;}
13     modifier onlyOwner() {require(owner() == _msgSender(), "Ownable: caller is not the owner"); _;}
14     function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}
15     function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner);}
16     function _transferOwnership(address newOwner) internal virtual {address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner);}}
17 
18 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
19 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
20     library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22     function toString(uint256 value) internal pure returns (string memory) {
23         if (value == 0) {return "0";} uint256 temp = value; uint256 digits; while (temp != 0) {digits++; temp /= 10;} bytes memory buffer = new bytes(digits);
24         while (value != 0) {digits -= 1; buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); value /= 10;} return string(buffer);}
25     function toHexString(uint256 value) internal pure returns (string memory) {
26         if (value == 0) {return "0x00";} uint256 temp = value; uint256 length = 0; while (temp != 0) {length++; temp >>= 8;} return toHexString(value, length);}
27     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {bytes memory buffer = new bytes(2 * length + 2); buffer[0] = "0"; buffer[1] = "x";
28         for (uint256 i = 2 * length + 1; i > 1; --i) {buffer[i] = _HEX_SYMBOLS[value & 0xf]; value >>= 4;} require(value == 0, "Strings: hex length insufficient"); return string(buffer);}}
29 
30 // File: erc721a/contracts/IERC721A.sol
31 // ERC721A Contracts v4.0.0
32     pragma solidity ^0.8.4;
33     interface IERC721A {error ApprovalCallerNotOwnerNorApproved();
34     error ApprovalQueryForNonexistentToken();
35     error ApproveToCaller();
36     error ApprovalToCurrentOwner();
37     error BalanceQueryForZeroAddress();
38     error MintToZeroAddress();
39     error MintZeroQuantity();
40     error OwnerQueryForNonexistentToken();
41     error TransferCallerNotOwnerNorApproved();
42     error TransferFromIncorrectOwner();
43     error TransferToNonERC721ReceiverImplementer();
44     error TransferToZeroAddress();
45     error URIQueryForNonexistentToken();
46     struct TokenOwnership {address addr; uint64 startTimestamp; bool burned;}
47     function totalSupply() external view returns (uint256);
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52     function balanceOf(address owner) external view returns (uint256 balance);
53     function ownerOf(uint256 tokenId) external view returns (address owner);
54     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
55     function safeTransferFrom(address from, address to, uint256 tokenId) external;
56     function transferFrom(address from, address to, uint256 tokenId) external;
57     function approve(address to, uint256 tokenId) external;
58     function setApprovalForAll(address operator, bool _approved) external;
59     function getApproved(uint256 tokenId) external view returns (address operator);
60     function isApprovedForAll(address owner, address operator) external view returns (bool);
61     function name() external view returns (string memory);
62     function symbol() external view returns (string memory);
63     function tokenURI(uint256 tokenId) external view returns (string memory);}
64 
65 // File: erc721a/contracts/ERC721A.sol
66 // ERC721A Contracts v4.0.0
67     pragma solidity ^0.8.4; interface ERC721A__IERC721Receiver {
68     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
69 
70     contract ERC721A is IERC721A {
71     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
72     uint256 private constant BITPOS_NUMBER_MINTED = 64;
73     uint256 private constant BITPOS_NUMBER_BURNED = 128;
74     uint256 private constant BITPOS_AUX = 192;
75     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
76     uint256 private constant BITPOS_START_TIMESTAMP = 160;
77     uint256 private constant BITMASK_BURNED = 1 << 224;
78     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
79     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
80     uint256 private _currentIndex;
81     uint256 private _burnCounter;
82     string private _name;
83     string private _symbol;
84     mapping(uint256 => uint256) private _packedOwnerships;
85     mapping(address => uint256) private _packedAddressData;
86     mapping(uint256 => address) private _tokenApprovals;
87     mapping(address => mapping(address => bool)) private _operatorApprovals;
88     constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_; _currentIndex = _startTokenId();}
89     function _startTokenId() internal view virtual returns (uint256) {return 1;}
90     function _nextTokenId() internal view returns (uint256) {return _currentIndex;}
91     function totalSupply() public view override returns (uint256) {unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
92     function _totalMinted() internal view returns (uint256) {unchecked {return _currentIndex - _startTokenId();}}
93     function _totalBurned() internal view returns (uint256) {return _burnCounter;}
94     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
95     function balanceOf(address owner) public view override returns (uint256) {if (owner == address(0)) revert BalanceQueryForZeroAddress(); return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
96     function _numberMinted(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
97     function _numberBurned(address owner) internal view returns (uint256) {return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
98     function _getAux(address owner) internal view returns (uint64) {return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
99     function _setAux(address owner, uint64 aux) internal {uint256 packed = _packedAddressData[owner]; uint256 auxCasted; assembly {auxCasted := aux}
100         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);_packedAddressData[owner] = packed;}
101     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {uint256 curr = tokenId; unchecked {
102         if (_startTokenId() <= curr) 
103         if (curr < _currentIndex) {uint256 packed = _packedOwnerships[curr]; 
104         if (packed & BITMASK_BURNED == 0) {while (packed == 0) {packed = _packedOwnerships[--curr];} return packed; }}} revert OwnerQueryForNonexistentToken();}
105     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
106         ownership.addr = address(uint160(packed)); ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP); ownership.burned = packed & BITMASK_BURNED != 0;}
107     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnerships[index]);}
108     function _initializeOwnershipAt(uint256 index) internal {if (_packedOwnerships[index] == 0) {_packedOwnerships[index] = _packedOwnershipOf(index);}}
109     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {return _unpackedOwnership(_packedOwnershipOf(tokenId));}
110     function ownerOf(uint256 tokenId) public view override returns (address) {return address(uint160(_packedOwnershipOf(tokenId)));}
111     function name() public view virtual override returns (string memory) {return _name;}
112     function symbol() public view virtual override returns (string memory) {return _symbol;}
113     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
114         if (!_exists(tokenId)) revert URIQueryForNonexistentToken(); string memory baseURI = _baseURI(); return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
115     function _baseURI() internal view virtual returns (string memory) {return '';}
116     function _addressToUint256(address value) private pure returns (uint256 result) {assembly {result := value}}
117     function _boolToUint256(bool value) private pure returns (uint256 result) {assembly {result := value}}
118     function approve(address to, uint256 tokenId) public override {address owner = address(uint160(_packedOwnershipOf(tokenId)));
119         if (to == owner) revert ApprovalToCurrentOwner();
120         if (_msgSenderERC721A() != owner)
121         if (!isApprovedForAll(owner, _msgSenderERC721A())) {revert ApprovalCallerNotOwnerNorApproved();}_tokenApprovals[tokenId] = to;emit Approval(owner, to, tokenId);}
122     function getApproved(uint256 tokenId) public view override returns (address) {if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken(); return _tokenApprovals[tokenId];}
123     function setApprovalForAll(address operator, bool approved) public virtual override {
124         if (operator == _msgSenderERC721A()) revert ApproveToCaller(); _operatorApprovals[_msgSenderERC721A()][operator] = approved; emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
125     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return _operatorApprovals[owner][operator];}
126     function transferFrom(address from, address to, uint256 tokenId) public virtual override {_transfer(from, to, tokenId);}
127     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {safeTransferFrom(from, to, tokenId, '');}
128     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {_transfer(from, to, tokenId);
129         if (to.code.length != 0)
130         if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {revert TransferToNonERC721ReceiverImplementer();}}
131     function _exists(uint256 tokenId) internal view returns (bool) {return
132             _startTokenId() <= tokenId &&
133             tokenId < _currentIndex &&
134             _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
135     function _safeMint(address to, uint256 quantity) internal {_safeMint(to, quantity, '');}
136     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {uint256 startTokenId = _currentIndex;
137         if (to == address(0)) revert MintToZeroAddress();
138         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1); _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED); uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
139         if (to.code.length != 0) {do {emit Transfer(address(0), to, updatedIndex);
140         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {revert TransferToNonERC721ReceiverImplementer();}} while (updatedIndex < end);
141         if (_currentIndex != startTokenId) revert();} else {do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);} _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
142     function _mint(address to, uint256 quantity) internal {uint256 startTokenId = _currentIndex;
143         if (to == address(0)) revert MintToZeroAddress();
144         if (quantity == 0) revert MintZeroQuantity(); _beforeTokenTransfers(address(0), to, startTokenId, quantity); unchecked {_packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
145             _packedOwnerships[startTokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
146             uint256 updatedIndex = startTokenId; uint256 end = updatedIndex + quantity;
147             do {emit Transfer(address(0), to, updatedIndex++); } while (updatedIndex < end); _currentIndex = updatedIndex;} _afterTokenTransfers(address(0), to, startTokenId, quantity);}
148     function _transfer(address from, address to, uint256 tokenId) private {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
149         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner(); bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
151         if (to == address(0)) revert TransferToZeroAddress(); _beforeTokenTransfers(from, to, tokenId, 1); delete _tokenApprovals[tokenId];
152         unchecked { --_packedAddressData[from]; ++_packedAddressData[to]; _packedOwnerships[tokenId] = _addressToUint256(to) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_NEXT_INITIALIZED;
153         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
154         if (_packedOwnerships[nextTokenId] == 0) {
155         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1);}
156     function _burn(uint256 tokenId) internal virtual {_burn(tokenId, false);}
157     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId); address from = address(uint160(prevOwnershipPacked));
158         if (approvalCheck) {bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();} _beforeTokenTransfers(from, address(0), tokenId, 1); delete _tokenApprovals[tokenId];
160             unchecked {_packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1; _packedOwnerships[tokenId] = _addressToUint256(from) | (block.timestamp << BITPOS_START_TIMESTAMP) | BITMASK_BURNED |  BITMASK_NEXT_INITIALIZED;
161         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {uint256 nextTokenId = tokenId + 1;
162         if (_packedOwnerships[nextTokenId] == 0) {
163         if (nextTokenId != _currentIndex) {_packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}} emit Transfer(from, address(0), tokenId); _afterTokenTransfers(from, address(0), tokenId, 1); unchecked {_burnCounter++;}}
164     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
165         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} catch (bytes memory reason) {
166         if (reason.length == 0) {revert TransferToNonERC721ReceiverImplementer();} else {assembly {revert(add(32, reason), mload(reason))}}}}
167     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
168     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
169     function _msgSenderERC721A() internal view virtual returns (address) {return msg.sender;}
170     function _toString(uint256 value) internal pure returns (string memory ptr) {assembly {ptr := add(mload(0x40), 128) mstore(0x40, ptr) let end := ptr
171         for {let temp := value ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10))) temp := div(temp, 10)} temp {temp := div(temp, 10)} 
172             {ptr := sub(ptr, 1) mstore8(ptr, add(48, mod(temp, 10)))} let length := sub(end, ptr) ptr := sub(ptr, 32) mstore(ptr, length)}}}
173 
174     pragma solidity ^0.8.13;
175     contract RektDegenz is Ownable, ERC721A {
176     uint256 public maxSupply                    = 4444;
177     uint256 public maxFreeSupply                = 4444;
178     uint256 public maxPerTxDuringMint           = 10;
179     uint256 public maxPerAddressDuringMint      = 11;
180     uint256 public maxPerAddressDuringFreeMint  = 1;
181     uint256 public price                        = 0.004 ether;
182     bool    public saleIsActive                 = false;
183     bool    public revealed                     = true;
184 
185     address constant internal TEAM_ADDRESS = 0xda746371650254b292Ad7c457733ea999B5653a1;
186     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmZFPGs9dqjTFWfEpCa1BFEweRdyTqsbi8mGC9WzDowkpW/";
187     string public constant baseExtension = ".json";
188     string public hiddenMetadataUri;
189     mapping(address => uint256) public freeMintedAmount;
190     mapping(address => uint256) public mintedAmount;
191     constructor() ERC721A("Rekt Degenz", "Clive") {_safeMint(msg.sender, 50); setHiddenMetadataUri("");}
192 
193         function airdrop(address[] memory _wallets) external onlyOwner{
194         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
195         for(uint i = 0; i < _wallets.length; i++)
196             _safeMint(_wallets[i], 1);
197 
198     }
199    function airdropToWallet(address _wallet, uint256 _num) external onlyOwner{
200                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
201             _safeMint(_wallet, _num);
202     }
203     
204     modifier mintCompliance() {require(saleIsActive, "Sale is not active yet."); require(tx.origin == msg.sender, "Wrong Caller"); _;}
205     function mint(uint256 _quantity) external payable mintCompliance() {require (msg.value >= price * _quantity, "Insufficient Funds");
206         require(maxSupply >= totalSupply() + _quantity, "Exceeds max supply."); uint256 _mintedAmount = mintedAmount[msg.sender];
207         require(_mintedAmount + _quantity <= maxPerAddressDuringMint, "Exceeds max mints per address!");
208         require(_quantity > 0 && _quantity <= maxPerTxDuringMint, "Invalid mint amount."); mintedAmount[msg.sender] = _mintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
209     function freeMint(uint256 _quantity) external mintCompliance() {
210         require(maxFreeSupply >= totalSupply() + _quantity, "Exceeds max supply."); uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
211         require(_freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint, "Exceeds max free mints per address!"); freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity; _safeMint(msg.sender, _quantity);}
212     function setPrice(uint256 _price) external onlyOwner {price = _price;}
213     function setMaxPerTx(uint256 _amount) external onlyOwner {maxPerTxDuringMint = _amount;}
214     function setMaxPerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringMint = _amount;}
215     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {maxPerAddressDuringFreeMint = _amount;}
216     function flipSale() public onlyOwner {saleIsActive = !saleIsActive;}
217     function setMaxSupply(uint256 newSupply) public onlyOwner {maxSupply = newSupply;}
218     function cutMaxSupply(uint256 _amount) public onlyOwner {require(maxSupply - _amount >= totalSupply(), "Supply cannot fall below minted tokens."); maxSupply -= _amount;}
219     function setRevealed(bool _state) public onlyOwner {revealed = _state;}
220     function setBaseURI(string memory baseURI_) external onlyOwner {baseURI = baseURI_;}
221     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {hiddenMetadataUri = _hiddenMetadataUri;}
222     function _baseURI() internal view virtual override returns (string memory) {return baseURI;}
223     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
224         {require(_exists(_tokenId), "Token does not exist."); if (revealed == false) {return hiddenMetadataUri;} 
225         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseExtension)) : "";}
226     function withdrawBalance() external payable onlyOwner {(bool success, ) = payable(TEAM_ADDRESS).call{value: address(this).balance} (""); require(success, "transfer failed.");}}
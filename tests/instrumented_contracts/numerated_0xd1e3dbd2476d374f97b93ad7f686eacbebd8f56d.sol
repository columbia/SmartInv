1 // File: contracts/roles/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 library Roles {
6     struct Role {
7         mapping (address => bool) bearer;
8     }
9 
10     function add(Role storage role, address account) internal {
11         require(!has(role, account), "role already has the account");
12         role.bearer[account] = true;
13     }
14 
15     function remove(Role storage role, address account) internal {
16         require(has(role, account), "role dosen't have the account");
17         role.bearer[account] = false;
18     }
19 
20     function has(Role storage role, address account) internal view returns (bool) {
21         return role.bearer[account];
22     }
23 }
24 
25 // File: contracts/erc/ERC165.sol
26 
27 pragma solidity ^0.5.0;
28 
29 interface IERC165 {
30     function supportsInterface(bytes4 interfaceID) external view returns (bool);
31 }
32 
33 /// @title ERC-165 Standard Interface Detection
34 /// @dev See https://eips.ethereum.org/EIPS/eip-165
35 contract ERC165 is IERC165 {
36     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
37     mapping(bytes4 => bool) private _supportedInterfaces;
38 
39     constructor () internal {
40         _registerInterface(_INTERFACE_ID_ERC165);
41     }
42 
43     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
44         return _supportedInterfaces[interfaceId];
45     }
46 
47     function _registerInterface(bytes4 interfaceId) internal {
48         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
49         _supportedInterfaces[interfaceId] = true;
50     }
51 }
52 
53 // File: contracts/erc/ERC173.sol
54 
55 pragma solidity ^0.5.0;
56 
57 
58 /// @title ERC-173 Contract Ownership Standard
59 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
60 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
61 interface IERC173 /* is ERC165 */ {
62     /// @dev This emits when ownership of a contract changes.
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /// @notice Get the address of the owner
66     /// @return The address of the owner.
67     function owner() external view returns (address);
68 
69     /// @notice Set the address of the new owner of the contract
70     /// @param _newOwner The address of the new owner of the contract
71     function transferOwnership(address _newOwner) external;
72 }
73 
74 contract ERC173 is IERC173, ERC165  {
75     address private _owner;
76 
77     constructor() public {
78         _registerInterface(0x7f5828d0);
79         _transferOwnership(msg.sender);
80     }
81 
82     modifier onlyOwner() {
83         require(msg.sender == owner(), "Must be owner");
84         _;
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     function transferOwnership(address _newOwner) public onlyOwner() {
92         _transferOwnership(_newOwner);
93     }
94 
95     function _transferOwnership(address _newOwner) internal {
96         address previousOwner = owner();
97 	_owner = _newOwner;
98         emit OwnershipTransferred(previousOwner, _newOwner);
99     }
100 }
101 
102 // File: contracts/roles/Operatable.sol
103 
104 pragma solidity ^0.5.0;
105 
106 
107 
108 contract Operatable is ERC173 {
109     using Roles for Roles.Role;
110 
111     event OperatorAdded(address indexed account);
112     event OperatorRemoved(address indexed account);
113 
114     event Paused(address account);
115     event Unpaused(address account);
116 
117     bool private _paused;
118     Roles.Role private operators;
119 
120     constructor() public {
121         operators.add(msg.sender);
122         _paused = false;
123     }
124 
125     modifier onlyOperator() {
126         require(isOperator(msg.sender), "Must be operator");
127         _;
128     }
129 
130     modifier whenNotPaused() {
131         require(!_paused, "Pausable: paused");
132         _;
133     }
134 
135     modifier whenPaused() {
136         require(_paused, "Pausable: not paused");
137         _;
138     }
139 
140     function transferOwnership(address _newOwner) public onlyOperator() {
141         _transferOwnership(_newOwner);
142     }
143 
144     function isOperator(address account) public view returns (bool) {
145         return operators.has(account);
146     }
147 
148     function addOperator(address account) public onlyOperator() {
149         operators.add(account);
150         emit OperatorAdded(account);
151     }
152 
153     function removeOperator(address account) public onlyOperator() {
154         operators.remove(account);
155         emit OperatorRemoved(account);
156     }
157 
158     function paused() public view returns (bool) {
159         return _paused;
160     }
161 
162     function pause() public onlyOperator() whenNotPaused() {
163         _paused = true;
164         emit Paused(msg.sender);
165     }
166 
167     function unpause() public onlyOperator() whenPaused() {
168         _paused = false;
169         emit Unpaused(msg.sender);
170     }
171 
172 }
173 
174 // File: contracts/interfaces/IERC721TokenReceiver.sol
175 
176 pragma solidity ^0.5.0;
177 
178 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
179 interface IERC721TokenReceiver {
180     /// @notice Handle the receipt of an NFT
181     /// @dev The ERC721 smart contract calls this function on the recipient
182     ///  after a `transfer`. This function MAY throw to revert and reject the
183     ///  transfer. Return of other than the magic value MUST result in the
184     ///  transaction being reverted.
185     ///  Note: the contract address is always the message sender.
186     /// @param _operator The address which called `safeTransferFrom` function
187     /// @param _from The address which previously owned the token
188     /// @param _tokenId The NFT identifier which is being transferred
189     /// @param _data Additional data with no specified format
190     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
191     ///  unless throwing
192     function onERC721Received(
193         address _operator,
194         address _from,
195         uint256 _tokenId,
196         bytes calldata _data
197     )
198         external
199         returns(bytes4);
200 }
201 
202 // File: contracts/erc/ERC721Holder.sol
203 
204 pragma solidity ^0.5.0;
205 
206 
207 contract ERC721Holder is IERC721TokenReceiver {
208     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
209         return this.onERC721Received.selector;
210     }
211 }
212 
213 // File: contracts/IERC721Gateway.sol
214 
215 pragma solidity ^0.5.0;
216 
217 interface AssetContract {
218     function balanceOf(address _owner) external view returns (uint256);
219     function ownerOf(uint256 _tokenId) external view returns (address);
220     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
221     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
222     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
223     function approve(address _approved, uint256 _tokenId) external payable;
224     function setApprovalForAll(address _operator, bool _approved) external;
225     function getApproved(uint256 _tokenId) external view returns (address);
226     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
227 
228     function isAlreadyMinted(uint256 _tokenId) external view returns (bool);
229     function mintCardAsset(address _to, uint256 _tokenId) external;
230 }
231 
232 interface IERC721Gateway {
233     event Deposit(address indexed owner, uint256 tokenId);
234     event Withdraw(address indexed owner, uint256 tokenId, uint256 supportEther, bytes32 eventHash);
235     function isTransactedEventHash(bytes32 _eventHash) external view returns (bool);
236     function setTransactedEventHash(bytes32 _eventHash, bool _desired) external;
237     function deposit(uint256 _tokenId) external;
238     function bulkDeposit(uint256[] calldata _tokenIds) external;
239     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) external payable;
240     function bulkWithdraw(address payable[] calldata _tos, uint256[] calldata _tokenIds, uint256[] calldata _supportEther, bytes32[] calldata _eventHashes) external payable;
241 }
242 
243 // File: contracts/SPLCardGateway.sol
244 
245 pragma solidity ^0.5.0;
246 
247 
248 
249 
250 contract SPLCardGateway is IERC721Gateway, Operatable, ERC721Holder {
251     AssetContract public assetContract;
252 
253     mapping(bytes32 => bool) private eventHashTransacted;
254 
255     constructor(address _assetContract) public {
256         assetContract = AssetContract(_assetContract);
257     }
258 
259     function isTransactedEventHash(bytes32 _eventHash) public view returns (bool) {
260         return eventHashTransacted[_eventHash];
261     }
262 
263     function setTransactedEventHash(bytes32 _eventHash, bool _desired) public onlyOperator() {
264         eventHashTransacted[_eventHash] = _desired;
265     }
266 
267     function deposit(uint256 _tokenId) public whenNotPaused() {
268         address owner = assetContract.ownerOf(_tokenId);
269         require(owner == msg.sender, "msg.sender must be _tokenId owner");
270         assetContract.safeTransferFrom(msg.sender, address(this), _tokenId);
271         emit Deposit(owner, _tokenId);
272     }
273 
274     function bulkDeposit(uint256[] calldata _tokenIds) external {
275         for (uint256 i = 0; i < _tokenIds.length; i++) {
276             deposit(_tokenIds[i]);
277         }
278     }
279 
280     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) public payable whenNotPaused() onlyOperator() {
281         require(!isTransactedEventHash(_eventHash), "_eventHash is already transacted");
282 
283         if (assetContract.isAlreadyMinted(_tokenId)) {
284             assetContract.safeTransferFrom(address(this), _to, _tokenId);
285         } else {
286             assetContract.mintCardAsset(_to, _tokenId);
287         }
288         setTransactedEventHash(_eventHash, true);
289 
290         if (_supportEther != 0) {
291           _to.transfer(_supportEther);
292         }
293         emit Withdraw(msg.sender, _tokenId, _supportEther, _eventHash);
294     }
295 
296     function bulkWithdraw(
297         address payable[] calldata _tos,
298         uint256[] calldata _tokenIds,
299         uint256[] calldata _supportEthers,
300         bytes32[] calldata _eventHashes
301     ) external payable {
302         require(_tokenIds.length == _tos.length && _tokenIds.length == _supportEthers.length && _tokenIds.length == _eventHashes.length, "invalid length");
303         for (uint256 i = 0; i < _tokenIds.length; i++) {
304             withdraw(_tos[i], _tokenIds[i], _supportEthers[i], _eventHashes[i]);
305         }
306     }
307 }
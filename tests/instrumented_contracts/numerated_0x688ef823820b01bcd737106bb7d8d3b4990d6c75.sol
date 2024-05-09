1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.5.17;
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     function add(Role storage role, address account) internal {
10         require(!has(role, account), "role already has the account");
11         role.bearer[account] = true;
12     }
13 
14     function remove(Role storage role, address account) internal {
15         require(has(role, account), "role dosen't have the account");
16         role.bearer[account] = false;
17     }
18 
19     function has(Role storage role, address account) internal view returns (bool) {
20         return role.bearer[account];
21     }
22 }
23 
24 interface IERC721TokenReceiver {
25     /// @notice Handle the receipt of an NFT
26     /// @dev The ERC721 smart contract calls this function on the recipient
27     ///  after a `transfer`. This function MAY throw to revert and reject the
28     ///  transfer. Return of other than the magic value MUST result in the
29     ///  transaction being reverted.
30     ///  Note: the contract address is always the message sender.
31     /// @param _operator The address which called `safeTransferFrom` function
32     /// @param _from The address which previously owned the token
33     /// @param _tokenId The NFT identifier which is being transferred
34     /// @param _data Additional data with no specified format
35     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
36     ///  unless throwing
37     function onERC721Received(
38         address _operator,
39         address _from,
40         uint256 _tokenId,
41         bytes calldata _data
42     )
43         external
44         returns(bytes4);
45 }
46 
47 interface IERC165 {
48     function supportsInterface(bytes4 interfaceID) external view returns (bool);
49 }
50 
51 /// @title ERC-165 Standard Interface Detection
52 /// @dev See https://eips.ethereum.org/EIPS/eip-165
53 contract ERC165 is IERC165 {
54     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
55     mapping(bytes4 => bool) private _supportedInterfaces;
56 
57     constructor () internal {
58         _registerInterface(_INTERFACE_ID_ERC165);
59     }
60 
61     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
62         return _supportedInterfaces[interfaceId];
63     }
64 
65     function _registerInterface(bytes4 interfaceId) internal {
66         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
67         _supportedInterfaces[interfaceId] = true;
68     }
69 }
70 
71 interface AssetContract {
72     function balanceOf(address _owner) external view returns (uint256);
73     function ownerOf(uint256 _tokenId) external view returns (address);
74     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
75     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
76     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
77     function approve(address _approved, uint256 _tokenId) external payable;
78     function setApprovalForAll(address _operator, bool _approved) external;
79     function getApproved(uint256 _tokenId) external view returns (address);
80     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
81 
82     function exist(uint256 _tokenId) external view returns (bool);
83     function mint(address _to, uint256 _tokenId) external;
84 }
85 
86 interface IERC721Gateway {
87     event Deposit(address indexed owner, uint256 tokenId);
88     event Withdraw(address indexed owner, uint256 tokenId, uint256 supportEther, bytes32 eventHash);
89     function isTransactedEventHash(bytes32 _eventHash) external view returns (bool);
90     function setTransactedEventHash(bytes32 _eventHash, bool _desired) external;
91     function deposit(uint256 _tokenId) external;
92     function bulkDeposit(uint256[] calldata _tokenIds) external;
93     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) external payable;
94     function bulkWithdraw(address payable[] calldata _tos, uint256[] calldata _tokenIds, uint256[] calldata _supportEther, bytes32[] calldata _eventHashes) external payable;
95 }
96 contract ERC721Holder is IERC721TokenReceiver {
97     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
98         return this.onERC721Received.selector;
99     }
100 }
101 
102 interface IERC173 /* is ERC165 */ {
103     /// @dev This emits when ownership of a contract changes.
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /// @notice Get the address of the owner
107     /// @return The address of the owner.
108     function owner() external view returns (address);
109 
110     /// @notice Set the address of the new owner of the contract
111     /// @param _newOwner The address of the new owner of the contract
112     function transferOwnership(address _newOwner) external;
113 }
114 
115 contract ERC173 is IERC173, ERC165  {
116     address private _owner;
117 
118     constructor() public {
119         _registerInterface(0x7f5828d0);
120         _transferOwnership(msg.sender);
121     }
122 
123     modifier onlyOwner() {
124         require(msg.sender == owner(), "Must be owner");
125         _;
126     }
127 
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     function transferOwnership(address _newOwner) public onlyOwner() {
133         _transferOwnership(_newOwner);
134     }
135 
136     function _transferOwnership(address _newOwner) internal {
137         address previousOwner = owner();
138 	_owner = _newOwner;
139         emit OwnershipTransferred(previousOwner, _newOwner);
140     }
141 }
142 
143 contract Operatable is ERC173 {
144     using Roles for Roles.Role;
145 
146     event OperatorAdded(address indexed account);
147     event OperatorRemoved(address indexed account);
148 
149     event Paused(address account);
150     event Unpaused(address account);
151 
152     bool private _paused;
153     Roles.Role private operators;
154 
155     constructor() public {
156         operators.add(msg.sender);
157         _paused = false;
158     }
159 
160     modifier onlyOperator() {
161         require(isOperator(msg.sender), "Must be operator");
162         _;
163     }
164 
165     modifier whenNotPaused() {
166         require(!_paused, "Pausable: paused");
167         _;
168     }
169 
170     modifier whenPaused() {
171         require(_paused, "Pausable: not paused");
172         _;
173     }
174 
175     function transferOwnership(address _newOwner) public onlyOperator() {
176         _transferOwnership(_newOwner);
177     }
178 
179     function isOperator(address account) public view returns (bool) {
180         return operators.has(account);
181     }
182 
183     function addOperator(address account) public onlyOperator() {
184         operators.add(account);
185         emit OperatorAdded(account);
186     }
187 
188     function removeOperator(address account) public onlyOperator() {
189         operators.remove(account);
190         emit OperatorRemoved(account);
191     }
192 
193     function paused() public view returns (bool) {
194         return _paused;
195     }
196 
197     function pause() public onlyOperator() whenNotPaused() {
198         _paused = true;
199         emit Paused(msg.sender);
200     }
201 
202     function unpause() public onlyOperator() whenPaused() {
203         _paused = false;
204         emit Unpaused(msg.sender);
205     }
206 
207     function withdrawEther() public onlyOperator() {
208         msg.sender.transfer(address(this).balance);
209     }
210 
211 }
212 
213 contract BFHLandTerritoryGateway is IERC721Gateway, Operatable, ERC721Holder {
214     AssetContract public assetContract;
215 
216     mapping(bytes32 => bool) private eventHashTransacted;
217 
218     constructor(address _assetContract) public {
219         assetContract = AssetContract(_assetContract);
220     }
221 
222     function isTransactedEventHash(bytes32 _eventHash) public view returns (bool) {
223         return eventHashTransacted[_eventHash];
224     }
225 
226     function setTransactedEventHash(bytes32 _eventHash, bool _desired) public onlyOperator() {
227         eventHashTransacted[_eventHash] = _desired;
228     }
229 
230     function deposit(uint256 _tokenId) public whenNotPaused() {
231         address owner = assetContract.ownerOf(_tokenId);
232         require(owner == msg.sender, "msg.sender must be _tokenId owner");
233         assetContract.safeTransferFrom(owner, address(this), _tokenId);
234         emit Deposit(owner, _tokenId);
235     }
236 
237     function bulkDeposit(uint256[] calldata _tokenIds) external {
238         for (uint256 i = 0; i < _tokenIds.length; i++) {
239             deposit(_tokenIds[i]);
240         }
241     }
242 
243     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) public payable whenNotPaused() onlyOperator() {
244         require(!isTransactedEventHash(_eventHash), "_eventHash is already transacted");
245 
246         if (assetContract.exist(_tokenId)) {
247             assetContract.safeTransferFrom(address(this), _to, _tokenId);
248         } else {
249             assetContract.mint(_to, _tokenId);
250         }
251         setTransactedEventHash(_eventHash, true);
252 
253         _to.transfer(_supportEther);
254         emit Withdraw(msg.sender, _tokenId, _supportEther, _eventHash);
255     }
256 
257     function bulkWithdraw(
258         address payable[] calldata _tos,
259         uint256[] calldata _tokenIds,
260         uint256[] calldata _supportEthers,
261         bytes32[] calldata _eventHashes
262     ) external payable {
263         require(_tokenIds.length == _tos.length && _tokenIds.length == _supportEthers.length && _tokenIds.length == _eventHashes.length, "invalid length");
264         for (uint256 i = 0; i < _tokenIds.length; i++) {
265             withdraw(_tos[i], _tokenIds[i], _supportEthers[i], _eventHashes[i]);
266         }
267     }
268 }
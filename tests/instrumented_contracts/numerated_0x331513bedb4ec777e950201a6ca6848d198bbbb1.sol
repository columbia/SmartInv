1 pragma solidity 0.5.17;
2 interface IERC165 {
3     function supportsInterface(bytes4 interfaceID) external view returns (bool);
4 }
5 
6 /// @title ERC-165 Standard Interface Detection
7 /// @dev See https://eips.ethereum.org/EIPS/eip-165
8 contract ERC165 is IERC165 {
9     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
10     mapping(bytes4 => bool) private _supportedInterfaces;
11 
12     constructor () internal {
13         _registerInterface(_INTERFACE_ID_ERC165);
14     }
15 
16     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
17         return _supportedInterfaces[interfaceId];
18     }
19 
20     function _registerInterface(bytes4 interfaceId) internal {
21         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
22         _supportedInterfaces[interfaceId] = true;
23     }
24 }
25 
26 interface AssetContract {
27     function balanceOf(address _owner) external view returns (uint256);
28     function ownerOf(uint256 _tokenId) external view returns (address);
29     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
30     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
31     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
32     function approve(address _approved, uint256 _tokenId) external payable;
33     function setApprovalForAll(address _operator, bool _approved) external;
34     function getApproved(uint256 _tokenId) external view returns (address);
35     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
36 
37     function exist(uint256 _tokenId) external view returns (bool);
38     function mint(address _to, uint256 _tokenId) external;
39 }
40 
41 interface IERC721Gateway {
42     event Deposit(address indexed owner, uint256 tokenId);
43     event Withdraw(address indexed owner, uint256 tokenId, uint256 supportEther, bytes32 eventHash);
44     function isTransactedEventHash(bytes32 _eventHash) external view returns (bool);
45     function setTransactedEventHash(bytes32 _eventHash, bool _desired) external;
46     function deposit(uint256 _tokenId) external;
47     function bulkDeposit(uint256[] calldata _tokenIds) external;
48     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) external payable;
49     function bulkWithdraw(address payable[] calldata _tos, uint256[] calldata _tokenIds, uint256[] calldata _supportEther, bytes32[] calldata _eventHashes) external payable;
50 }
51 library Roles {
52     struct Role {
53         mapping (address => bool) bearer;
54     }
55 
56     function add(Role storage role, address account) internal {
57         require(!has(role, account), "role already has the account");
58         role.bearer[account] = true;
59     }
60 
61     function remove(Role storage role, address account) internal {
62         require(has(role, account), "role dosen't have the account");
63         role.bearer[account] = false;
64     }
65 
66     function has(Role storage role, address account) internal view returns (bool) {
67         return role.bearer[account];
68     }
69 }
70 
71 interface IERC721TokenReceiver {
72     /// @notice Handle the receipt of an NFT
73     /// @dev The ERC721 smart contract calls this function on the recipient
74     ///  after a `transfer`. This function MAY throw to revert and reject the
75     ///  transfer. Return of other than the magic value MUST result in the
76     ///  transaction being reverted.
77     ///  Note: the contract address is always the message sender.
78     /// @param _operator The address which called `safeTransferFrom` function
79     /// @param _from The address which previously owned the token
80     /// @param _tokenId The NFT identifier which is being transferred
81     /// @param _data Additional data with no specified format
82     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
83     ///  unless throwing
84     function onERC721Received(
85         address _operator,
86         address _from,
87         uint256 _tokenId,
88         bytes calldata _data
89     )
90         external
91         returns(bytes4);
92 }
93 
94 interface IERC173 /* is ERC165 */ {
95     /// @dev This emits when ownership of a contract changes.
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /// @notice Get the address of the owner
99     /// @return The address of the owner.
100     function owner() external view returns (address);
101 
102     /// @notice Set the address of the new owner of the contract
103     /// @param _newOwner The address of the new owner of the contract
104     function transferOwnership(address _newOwner) external;
105 }
106 
107 contract ERC173 is IERC173, ERC165  {
108     address private _owner;
109 
110     constructor() public {
111         _registerInterface(0x7f5828d0);
112         _transferOwnership(msg.sender);
113     }
114 
115     modifier onlyOwner() {
116         require(msg.sender == owner(), "Must be owner");
117         _;
118     }
119 
120     function owner() public view returns (address) {
121         return _owner;
122     }
123 
124     function transferOwnership(address _newOwner) public onlyOwner() {
125         _transferOwnership(_newOwner);
126     }
127 
128     function _transferOwnership(address _newOwner) internal {
129         address previousOwner = owner();
130 	_owner = _newOwner;
131         emit OwnershipTransferred(previousOwner, _newOwner);
132     }
133 }
134 
135 contract Operatable is ERC173 {
136     using Roles for Roles.Role;
137 
138     event OperatorAdded(address indexed account);
139     event OperatorRemoved(address indexed account);
140 
141     event Paused(address account);
142     event Unpaused(address account);
143 
144     bool private _paused;
145     Roles.Role private operators;
146 
147     constructor() public {
148         operators.add(msg.sender);
149         _paused = false;
150     }
151 
152     modifier onlyOperator() {
153         require(isOperator(msg.sender), "Must be operator");
154         _;
155     }
156 
157     modifier whenNotPaused() {
158         require(!_paused, "Pausable: paused");
159         _;
160     }
161 
162     modifier whenPaused() {
163         require(_paused, "Pausable: not paused");
164         _;
165     }
166 
167     function transferOwnership(address _newOwner) public onlyOperator() {
168         _transferOwnership(_newOwner);
169     }
170 
171     function isOperator(address account) public view returns (bool) {
172         return operators.has(account);
173     }
174 
175     function addOperator(address account) public onlyOperator() {
176         operators.add(account);
177         emit OperatorAdded(account);
178     }
179 
180     function removeOperator(address account) public onlyOperator() {
181         operators.remove(account);
182         emit OperatorRemoved(account);
183     }
184 
185     function paused() public view returns (bool) {
186         return _paused;
187     }
188 
189     function pause() public onlyOperator() whenNotPaused() {
190         _paused = true;
191         emit Paused(msg.sender);
192     }
193 
194     function unpause() public onlyOperator() whenPaused() {
195         _paused = false;
196         emit Unpaused(msg.sender);
197     }
198 
199 }
200 
201 contract ERC721Holder is IERC721TokenReceiver {
202     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
203         return this.onERC721Received.selector;
204     }
205 }
206 
207 contract CJOArtsGateway is IERC721Gateway, Operatable, ERC721Holder {
208     AssetContract public assetContract;
209 
210     mapping(bytes32 => bool) private eventHashTransacted;
211 
212     constructor(address _assetContract) public {
213         assetContract = AssetContract(_assetContract);
214     }
215 
216     function isTransactedEventHash(bytes32 _eventHash) public view returns (bool) {
217         return eventHashTransacted[_eventHash];
218     }
219 
220     function setTransactedEventHash(bytes32 _eventHash, bool _desired) public onlyOperator() {
221         eventHashTransacted[_eventHash] = _desired;
222     }
223 
224     function deposit(uint256 _tokenId) public whenNotPaused() {
225         address owner = assetContract.ownerOf(_tokenId);
226         require(owner == msg.sender, "msg.sender must be _tokenId owner");
227         assetContract.safeTransferFrom(owner, address(this), _tokenId);
228         emit Deposit(owner, _tokenId);
229     }
230 
231     function bulkDeposit(uint256[] calldata _tokenIds) external {
232         for (uint256 i = 0; i < _tokenIds.length; i++) {
233             deposit(_tokenIds[i]);
234         }
235     }
236 
237     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) public payable whenNotPaused() onlyOperator() {
238         require(!isTransactedEventHash(_eventHash), "_eventHash is already transacted");
239 
240         if (assetContract.exist(_tokenId)) {
241             assetContract.safeTransferFrom(address(this), _to, _tokenId);
242         } else {
243             assetContract.mint(_to, _tokenId);
244         }
245         setTransactedEventHash(_eventHash, true);
246 
247         _to.transfer(_supportEther);
248         emit Withdraw(msg.sender, _tokenId, _supportEther, _eventHash);
249     }
250 
251     function bulkWithdraw(
252         address payable[] calldata _tos,
253         uint256[] calldata _tokenIds,
254         uint256[] calldata _supportEthers,
255         bytes32[] calldata _eventHashes
256     ) external payable {
257         require(_tokenIds.length == _tos.length && _tokenIds.length == _supportEthers.length && _tokenIds.length == _eventHashes.length, "invalid length");
258         for (uint256 i = 0; i < _tokenIds.length; i++) {
259             withdraw(_tos[i], _tokenIds[i], _supportEthers[i], _eventHashes[i]);
260         }
261     }
262 }
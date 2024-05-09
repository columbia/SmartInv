1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-20
3 */
4 
5 pragma solidity 0.5.17;
6 interface IERC165 {
7     function supportsInterface(bytes4 interfaceID) external view returns (bool);
8 }
9 
10 /// @title ERC-165 Standard Interface Detection
11 /// @dev See https://eips.ethereum.org/EIPS/eip-165
12 contract ERC165 is IERC165 {
13     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
14     mapping(bytes4 => bool) private _supportedInterfaces;
15 
16     constructor () internal {
17         _registerInterface(_INTERFACE_ID_ERC165);
18     }
19 
20     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
21         return _supportedInterfaces[interfaceId];
22     }
23 
24     function _registerInterface(bytes4 interfaceId) internal {
25         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
26         _supportedInterfaces[interfaceId] = true;
27     }
28 }
29 
30 interface AssetContract {
31     function balanceOf(address _owner) external view returns (uint256);
32     function ownerOf(uint256 _tokenId) external view returns (address);
33     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
34     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
35     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
36     function approve(address _approved, uint256 _tokenId) external payable;
37     function setApprovalForAll(address _operator, bool _approved) external;
38     function getApproved(uint256 _tokenId) external view returns (address);
39     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
40 
41     function exist(uint256 _tokenId) external view returns (bool);
42     function mint(address _to, uint256 _tokenId) external;
43 }
44 
45 interface IERC721Gateway {
46     event Deposit(address indexed owner, uint256 tokenId);
47     event Withdraw(address indexed owner, uint256 tokenId, uint256 supportEther, bytes32 eventHash);
48     function isTransactedEventHash(bytes32 _eventHash) external view returns (bool);
49     function setTransactedEventHash(bytes32 _eventHash, bool _desired) external;
50     function deposit(uint256 _tokenId) external;
51     function bulkDeposit(uint256[] calldata _tokenIds) external;
52     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) external payable;
53     function bulkWithdraw(address payable[] calldata _tos, uint256[] calldata _tokenIds, uint256[] calldata _supportEther, bytes32[] calldata _eventHashes) external payable;
54 }
55 library Roles {
56     struct Role {
57         mapping (address => bool) bearer;
58     }
59 
60     function add(Role storage role, address account) internal {
61         require(!has(role, account), "role already has the account");
62         role.bearer[account] = true;
63     }
64 
65     function remove(Role storage role, address account) internal {
66         require(has(role, account), "role dosen't have the account");
67         role.bearer[account] = false;
68     }
69 
70     function has(Role storage role, address account) internal view returns (bool) {
71         return role.bearer[account];
72     }
73 }
74 
75 interface IERC721TokenReceiver {
76     /// @notice Handle the receipt of an NFT
77     /// @dev The ERC721 smart contract calls this function on the recipient
78     ///  after a `transfer`. This function MAY throw to revert and reject the
79     ///  transfer. Return of other than the magic value MUST result in the
80     ///  transaction being reverted.
81     ///  Note: the contract address is always the message sender.
82     /// @param _operator The address which called `safeTransferFrom` function
83     /// @param _from The address which previously owned the token
84     /// @param _tokenId The NFT identifier which is being transferred
85     /// @param _data Additional data with no specified format
86     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
87     ///  unless throwing
88     function onERC721Received(
89         address _operator,
90         address _from,
91         uint256 _tokenId,
92         bytes calldata _data
93     )
94         external
95         returns(bytes4);
96 }
97 
98 interface IERC173 /* is ERC165 */ {
99     /// @dev This emits when ownership of a contract changes.
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     /// @notice Get the address of the owner
103     /// @return The address of the owner.
104     function owner() external view returns (address);
105 
106     /// @notice Set the address of the new owner of the contract
107     /// @param _newOwner The address of the new owner of the contract
108     function transferOwnership(address _newOwner) external;
109 }
110 
111 contract ERC173 is IERC173, ERC165  {
112     address private _owner;
113 
114     constructor() public {
115         _registerInterface(0x7f5828d0);
116         _transferOwnership(msg.sender);
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == owner(), "Must be owner");
121         _;
122     }
123 
124     function owner() public view returns (address) {
125         return _owner;
126     }
127 
128     function transferOwnership(address _newOwner) public onlyOwner() {
129         _transferOwnership(_newOwner);
130     }
131 
132     function _transferOwnership(address _newOwner) internal {
133         address previousOwner = owner();
134 	_owner = _newOwner;
135         emit OwnershipTransferred(previousOwner, _newOwner);
136     }
137 }
138 
139 contract Operatable is ERC173 {
140     using Roles for Roles.Role;
141 
142     event OperatorAdded(address indexed account);
143     event OperatorRemoved(address indexed account);
144 
145     event Paused(address account);
146     event Unpaused(address account);
147 
148     bool private _paused;
149     Roles.Role private operators;
150 
151     constructor() public {
152         operators.add(msg.sender);
153         _paused = false;
154     }
155 
156     modifier onlyOperator() {
157         require(isOperator(msg.sender), "Must be operator");
158         _;
159     }
160 
161     modifier whenNotPaused() {
162         require(!_paused, "Pausable: paused");
163         _;
164     }
165 
166     modifier whenPaused() {
167         require(_paused, "Pausable: not paused");
168         _;
169     }
170 
171     function transferOwnership(address _newOwner) public onlyOperator() {
172         _transferOwnership(_newOwner);
173     }
174 
175     function isOperator(address account) public view returns (bool) {
176         return operators.has(account);
177     }
178 
179     function addOperator(address account) public onlyOperator() {
180         operators.add(account);
181         emit OperatorAdded(account);
182     }
183 
184     function removeOperator(address account) public onlyOperator() {
185         operators.remove(account);
186         emit OperatorRemoved(account);
187     }
188 
189     function paused() public view returns (bool) {
190         return _paused;
191     }
192 
193     function pause() public onlyOperator() whenNotPaused() {
194         _paused = true;
195         emit Paused(msg.sender);
196     }
197 
198     function unpause() public onlyOperator() whenPaused() {
199         _paused = false;
200         emit Unpaused(msg.sender);
201     }
202 
203 }
204 
205 contract ERC721Holder is IERC721TokenReceiver {
206     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
207         return this.onERC721Received.selector;
208     }
209 }
210 
211 contract CJOFighterGateway is IERC721Gateway, Operatable, ERC721Holder {
212     AssetContract public assetContract;
213 
214     mapping(bytes32 => bool) private eventHashTransacted;
215 
216     constructor(address _assetContract) public {
217         assetContract = AssetContract(_assetContract);
218     }
219 
220     function isTransactedEventHash(bytes32 _eventHash) public view returns (bool) {
221         return eventHashTransacted[_eventHash];
222     }
223 
224     function setTransactedEventHash(bytes32 _eventHash, bool _desired) public onlyOperator() {
225         eventHashTransacted[_eventHash] = _desired;
226     }
227 
228     function deposit(uint256 _tokenId) public whenNotPaused() {
229         address owner = assetContract.ownerOf(_tokenId);
230         require(owner == msg.sender, "msg.sender must be _tokenId owner");
231         assetContract.safeTransferFrom(owner, address(this), _tokenId);
232         emit Deposit(owner, _tokenId);
233     }
234 
235     function bulkDeposit(uint256[] calldata _tokenIds) external {
236         for (uint256 i = 0; i < _tokenIds.length; i++) {
237             deposit(_tokenIds[i]);
238         }
239     }
240 
241     function withdraw(address payable _to, uint256 _tokenId, uint256 _supportEther, bytes32 _eventHash) public payable whenNotPaused() onlyOperator() {
242         require(!isTransactedEventHash(_eventHash), "_eventHash is already transacted");
243 
244         if (assetContract.exist(_tokenId)) {
245             assetContract.safeTransferFrom(address(this), _to, _tokenId);
246         } else {
247             assetContract.mint(_to, _tokenId);
248         }
249         setTransactedEventHash(_eventHash, true);
250 
251         _to.transfer(_supportEther);
252         emit Withdraw(msg.sender, _tokenId, _supportEther, _eventHash);
253     }
254 
255     function bulkWithdraw(
256         address payable[] calldata _tos,
257         uint256[] calldata _tokenIds,
258         uint256[] calldata _supportEthers,
259         bytes32[] calldata _eventHashes
260     ) external payable {
261         require(_tokenIds.length == _tos.length && _tokenIds.length == _supportEthers.length && _tokenIds.length == _eventHashes.length, "invalid length");
262         for (uint256 i = 0; i < _tokenIds.length; i++) {
263             withdraw(_tos[i], _tokenIds[i], _supportEthers[i], _eventHashes[i]);
264         }
265     }
266 }
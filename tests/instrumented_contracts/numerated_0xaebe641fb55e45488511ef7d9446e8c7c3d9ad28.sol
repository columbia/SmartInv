1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.5.16;
3 
4 interface IERC721Converter /* is IERC721TokenReceiver */{
5     function draftAliceToken(uint256 _aliceTokenId, uint256 _bobTokenId) external;
6     function draftBobToken(uint256 _BobTokenId, uint256 _aliceTokenId) external;
7     function getAliceTokenID(uint256 _bobTokenId) external view returns(uint256);
8     function getBobTokenID(uint256 _aliceTokenId) external view returns(uint256);
9     function convertFromAliceToBob(uint256 _tokenId) external;
10     function convertFromBobToAlice(uint256 _tokenId) external;
11 }
12 
13 library Roles {
14     struct Role {
15         mapping (address => bool) bearer;
16     }
17 
18     function add(Role storage role, address account) internal {
19         require(!has(role, account), "role already has the account");
20         role.bearer[account] = true;
21     }
22 
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "role dosen't have the account");
25         role.bearer[account] = false;
26     }
27 
28     function has(Role storage role, address account) internal view returns (bool) {
29         return role.bearer[account];
30     }
31 }
32 
33 interface IERC721TokenReceiver {
34     /// @notice Handle the receipt of an NFT
35     /// @dev The ERC721 smart contract calls this function on the recipient
36     ///  after a `transfer`. This function MAY throw to revert and reject the
37     ///  transfer. Return of other than the magic value MUST result in the
38     ///  transaction being reverted.
39     ///  Note: the contract address is always the message sender.
40     /// @param _operator The address which called `safeTransferFrom` function
41     /// @param _from The address which previously owned the token
42     /// @param _tokenId The NFT identifier which is being transferred
43     /// @param _data Additional data with no specified format
44     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
45     ///  unless throwing
46     function onERC721Received(
47         address _operator,
48         address _from,
49         uint256 _tokenId,
50         bytes calldata _data
51     )
52         external
53         returns(bytes4);
54 }
55 
56 interface IERC165 {
57     function supportsInterface(bytes4 interfaceID) external view returns (bool);
58 }
59 
60 /// @title ERC-165 Standard Interface Detection
61 /// @dev See https://eips.ethereum.org/EIPS/eip-165
62 contract ERC165 is IERC165 {
63     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
64     mapping(bytes4 => bool) private _supportedInterfaces;
65 
66     constructor () internal {
67         _registerInterface(_INTERFACE_ID_ERC165);
68     }
69 
70     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
71         return _supportedInterfaces[interfaceId];
72     }
73 
74     function _registerInterface(bytes4 interfaceId) internal {
75         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
76         _supportedInterfaces[interfaceId] = true;
77     }
78 }
79 
80 contract ERC721Holder is IERC721TokenReceiver {
81     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
82         return this.onERC721Received.selector;
83     }
84 }
85 
86 interface IERC173 /* is ERC165 */ {
87     /// @dev This emits when ownership of a contract changes.
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /// @notice Get the address of the owner
91     /// @return The address of the owner.
92     function owner() external view returns (address);
93 
94     /// @notice Set the address of the new owner of the contract
95     /// @param _newOwner The address of the new owner of the contract
96     function transferOwnership(address _newOwner) external;
97 }
98 
99 contract ERC173 is IERC173, ERC165  {
100     address private _owner;
101 
102     constructor() public {
103         _registerInterface(0x7f5828d0);
104         _transferOwnership(msg.sender);
105     }
106 
107     modifier onlyOwner() {
108         require(msg.sender == owner(), "Must be owner");
109         _;
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     function transferOwnership(address _newOwner) public onlyOwner() {
117         _transferOwnership(_newOwner);
118     }
119 
120     function _transferOwnership(address _newOwner) internal {
121         address previousOwner = owner();
122 	_owner = _newOwner;
123         emit OwnershipTransferred(previousOwner, _newOwner);
124     }
125 }
126 
127 contract Operatable is ERC173 {
128     using Roles for Roles.Role;
129 
130     event OperatorAdded(address indexed account);
131     event OperatorRemoved(address indexed account);
132 
133     event Paused(address account);
134     event Unpaused(address account);
135 
136     bool private _paused;
137     Roles.Role private operators;
138 
139     constructor() public {
140         operators.add(msg.sender);
141         _paused = false;
142     }
143 
144     modifier onlyOperator() {
145         require(isOperator(msg.sender), "Must be operator");
146         _;
147     }
148 
149     modifier whenNotPaused() {
150         require(!_paused, "Pausable: paused");
151         _;
152     }
153 
154     modifier whenPaused() {
155         require(_paused, "Pausable: not paused");
156         _;
157     }
158 
159     function transferOwnership(address _newOwner) public onlyOperator() {
160         _transferOwnership(_newOwner);
161     }
162 
163     function isOperator(address account) public view returns (bool) {
164         return operators.has(account);
165     }
166 
167     function addOperator(address account) public onlyOperator() {
168         operators.add(account);
169         emit OperatorAdded(account);
170     }
171 
172     function removeOperator(address account) public onlyOperator() {
173         operators.remove(account);
174         emit OperatorRemoved(account);
175     }
176 
177     function paused() public view returns (bool) {
178         return _paused;
179     }
180 
181     function pause() public onlyOperator() whenNotPaused() {
182         _paused = true;
183         emit Paused(msg.sender);
184     }
185 
186     function unpause() public onlyOperator() whenPaused() {
187         _paused = false;
188         emit Unpaused(msg.sender);
189     }
190 
191     function withdrawEther() public onlyOperator() {
192         msg.sender.transfer(address(this).balance);
193     }
194 
195 }
196 
197 interface IMCHHero {
198     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
199 }
200 
201 interface IERC721Mintable {
202     function exist(uint256 _tokenId) external view returns (bool);
203     function mint(address _owner, uint256 _tokenId) external;
204     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
205 }
206 
207 contract ERC721ConverterWithMCHHero is IERC721Converter, ERC721Holder, Operatable {
208     IMCHHero public Alice;
209     IERC721Mintable public Bob;
210 
211     mapping (uint256 => uint256) private _idMapAliceToBob;
212     mapping (uint256 => uint256) private _idMapBobToAlice;
213 
214     constructor() public {}
215 
216     function updateAlice(address _newAlice) external onlyOperator() {
217         Alice = IMCHHero(_newAlice);
218     }
219 
220     function updateBob(address _newBob) external onlyOperator() {
221         Bob = IERC721Mintable(_newBob);
222     }
223 
224     function draftAliceTokens(uint256[] memory _aliceTokenIds, uint256[] memory _bobTokenIds) public onlyOperator() {
225         require(_aliceTokenIds.length == _bobTokenIds.length);
226         for (uint256 i = 0; i < _aliceTokenIds.length; i++) {
227             draftAliceToken(_aliceTokenIds[i], _bobTokenIds[i]);
228         }
229     }
230 
231     function draftBobTokens(uint256[] memory _bobTokenIds, uint256[] memory _aliceTokenIds) public onlyOperator() {
232         require(_aliceTokenIds.length == _bobTokenIds.length);
233         for (uint256 i = 0; i < _aliceTokenIds.length; i++) {
234             draftBobToken(_bobTokenIds[i], _aliceTokenIds[i]);
235         }
236     }
237 
238     function draftAliceToken(uint256 _aliceTokenId, uint256 _bobTokenId) public onlyOperator() {
239         require(_idMapAliceToBob[_aliceTokenId] == 0, "_aliceTokenId is already assignd");
240         require(_idMapBobToAlice[_bobTokenId] == 0, "_bobTokenId is already assignd");
241 
242         _idMapAliceToBob[_aliceTokenId] = _bobTokenId;
243         _idMapBobToAlice[_bobTokenId] = _aliceTokenId;
244     }
245 
246     function draftBobToken(uint256 _bobTokenId, uint256 _aliceTokenId) public onlyOperator() {
247         require(_idMapBobToAlice[_bobTokenId] == 0, "_bobTokenId is already assignd");
248         require(_idMapAliceToBob[_aliceTokenId] == 0, "_aliceTokenId is already assignd");
249 
250         _idMapBobToAlice[_bobTokenId] = _aliceTokenId;
251         _idMapAliceToBob[_aliceTokenId] = _bobTokenId;
252     }
253 
254     function getBobTokenID(uint256 _aliceTokenId) public view returns(uint256) {
255         return _idMapAliceToBob[_aliceTokenId];
256     }
257 
258     function getAliceTokenID(uint256 _bobTokenId) public view returns(uint256) {
259         return _idMapBobToAlice[_bobTokenId];
260     }
261 
262     function convertFromAliceToBob(uint256 _tokenId) public whenNotPaused() {
263         Alice.safeTransferFrom(msg.sender, address(this), _tokenId);
264 
265         uint256 convertTo = getBobTokenID(_tokenId);
266         if (Bob.exist(convertTo)) {
267             Bob.safeTransferFrom(address(this), msg.sender, convertTo);
268         } else {
269             Bob.mint(msg.sender, convertTo);
270         }
271     }
272 
273     function convertFromBobToAlice(uint256 _tokenId) public whenNotPaused() {
274         Bob.safeTransferFrom(msg.sender, address(this), _tokenId);
275 
276         uint256 convertTo = getAliceTokenID(_tokenId);
277         Alice.safeTransferFrom(address(this), msg.sender, convertTo);
278     }
279 }
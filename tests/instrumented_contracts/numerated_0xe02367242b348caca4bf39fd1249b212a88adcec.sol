1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.5.16;
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
24 interface IERC165 {
25     function supportsInterface(bytes4 interfaceID) external view returns (bool);
26 }
27 
28 /// @title ERC-165 Standard Interface Detection
29 /// @dev See https://eips.ethereum.org/EIPS/eip-165
30 contract ERC165 is IERC165 {
31     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
32     mapping(bytes4 => bool) private _supportedInterfaces;
33 
34     constructor () internal {
35         _registerInterface(_INTERFACE_ID_ERC165);
36     }
37 
38     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
39         return _supportedInterfaces[interfaceId];
40     }
41 
42     function _registerInterface(bytes4 interfaceId) internal {
43         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
44         _supportedInterfaces[interfaceId] = true;
45     }
46 }
47 
48 library ECDSA {
49     /**
50      * @dev Returns the address that signed a hashed message (`hash`) with
51      * `signature`. This address can then be used for verification purposes.
52      *
53      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
54      * this function rejects them by requiring the `s` value to be in the lower
55      * half order, and the `v` value to be either 27 or 28.
56      *
57      * NOTE: This call _does not revert_ if the signature is invalid, or
58      * if the signer is otherwise unable to be retrieved. In those scenarios,
59      * the zero address is returned.
60      *
61      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
62      * verification to be secure: it is possible to craft signatures that
63      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
64      * this is by receiving a hash of the original message (which may otherwise
65      * be too long), and then calling {toEthSignedMessageHash} on it.
66      */
67     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
68         // Check the signature length
69         if (signature.length != 65) {
70             return (address(0));
71         }
72 
73         // Divide the signature in r, s and v variables
74         bytes32 r;
75         bytes32 s;
76         uint8 v;
77 
78         // ecrecover takes the signature parameters, and the only way to get them
79         // currently is to use assembly.
80         // solhint-disable-next-line no-inline-assembly
81         assembly {
82             r := mload(add(signature, 0x20))
83             s := mload(add(signature, 0x40))
84             v := byte(0, mload(add(signature, 0x60)))
85         }
86 
87         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
88         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
89         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
90         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
91         //
92         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
93         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
94         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
95         // these malleable signatures as well.
96         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
97             return address(0);
98         }
99 
100         if (v != 27 && v != 28) {
101             return address(0);
102         }
103 
104         // If the signature is valid (and not malleable), return the signer address
105         return ecrecover(hash, v, r, s);
106     }
107 
108     /**
109      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
110      * replicates the behavior of the
111      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
112      * JSON-RPC method.
113      *
114      * See {recover}.
115      */
116     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
117         // 32 is the length in bytes of hash,
118         // enforced by the type signature above
119         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
120     }
121 }
122 
123 interface IERC173 /* is ERC165 */ {
124     /// @dev This emits when ownership of a contract changes.
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /// @notice Get the address of the owner
128     /// @return The address of the owner.
129     function owner() external view returns (address);
130 
131     /// @notice Set the address of the new owner of the contract
132     /// @param _newOwner The address of the new owner of the contract
133     function transferOwnership(address _newOwner) external;
134 }
135 
136 contract ERC173 is IERC173, ERC165  {
137     address private _owner;
138 
139     constructor() public {
140         _registerInterface(0x7f5828d0);
141         _transferOwnership(msg.sender);
142     }
143 
144     modifier onlyOwner() {
145         require(msg.sender == owner(), "Must be owner");
146         _;
147     }
148 
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     function transferOwnership(address _newOwner) public onlyOwner() {
154         _transferOwnership(_newOwner);
155     }
156 
157     function _transferOwnership(address _newOwner) internal {
158         address previousOwner = owner();
159 	_owner = _newOwner;
160         emit OwnershipTransferred(previousOwner, _newOwner);
161     }
162 }
163 
164 contract Operatable is ERC173 {
165     using Roles for Roles.Role;
166 
167     event OperatorAdded(address indexed account);
168     event OperatorRemoved(address indexed account);
169 
170     event Paused(address account);
171     event Unpaused(address account);
172 
173     bool private _paused;
174     Roles.Role private operators;
175 
176     constructor() public {
177         operators.add(msg.sender);
178         _paused = false;
179     }
180 
181     modifier onlyOperator() {
182         require(isOperator(msg.sender), "Must be operator");
183         _;
184     }
185 
186     modifier whenNotPaused() {
187         require(!_paused, "Pausable: paused");
188         _;
189     }
190 
191     modifier whenPaused() {
192         require(_paused, "Pausable: not paused");
193         _;
194     }
195 
196     function transferOwnership(address _newOwner) public onlyOperator() {
197         _transferOwnership(_newOwner);
198     }
199 
200     function isOperator(address account) public view returns (bool) {
201         return operators.has(account);
202     }
203 
204     function addOperator(address account) public onlyOperator() {
205         operators.add(account);
206         emit OperatorAdded(account);
207     }
208 
209     function removeOperator(address account) public onlyOperator() {
210         operators.remove(account);
211         emit OperatorRemoved(account);
212     }
213 
214     function paused() public view returns (bool) {
215         return _paused;
216     }
217 
218     function pause() public onlyOperator() whenNotPaused() {
219         _paused = true;
220         emit Paused(msg.sender);
221     }
222 
223     function unpause() public onlyOperator() whenPaused() {
224         _paused = false;
225         emit Unpaused(msg.sender);
226     }
227 
228     function withdrawEther() public onlyOperator() {
229         msg.sender.transfer(address(this).balance);
230     }
231 
232 }
233 
234 contract BFHPrimeV1 is Operatable {
235 
236     address public validator;
237     mapping (address => uint256) public lastSignedBlock;
238     uint256 ableToBuyAfterRange;
239     uint256 sigExpireBlock;
240 
241     event BuyPrimeRight(
242         address indexed buyer,
243         uint256 signedAt
244     );
245 
246     constructor(address _varidator) public {
247         setValidater(_varidator);
248         setBlockRanges(20000, 10000);
249     }
250 
251     function setValidater(address _varidator) public onlyOperator() {
252         validator = _varidator;
253     }
254 
255     function setBlockRanges(uint256 _ableToBuyAfterRange, uint256 _sigExpireBlock) public onlyOperator() {
256         ableToBuyAfterRange = _ableToBuyAfterRange;
257         sigExpireBlock = _sigExpireBlock;
258     }
259 
260     function isApplicableNow() public view returns (bool) {
261         isApplicable(msg.sender, block.number, block.number);
262     }
263 
264     function isApplicable(address _buyer, uint256 _blockNum, uint256 _currentBlock) public view returns (bool) {
265         if (lastSignedBlock[_buyer] != 0) {
266             if (_blockNum < lastSignedBlock[_buyer] + ableToBuyAfterRange) {
267                 return false;
268             }
269         }
270 
271         if (_blockNum >= _currentBlock + sigExpireBlock) {
272             return false;
273         }
274         return true;
275     }
276 
277     function buyPrimeRight(bytes calldata _signature, bytes32 _hash, uint256 _blockNum) external payable whenNotPaused() {
278         require(isApplicable(msg.sender, _blockNum, block.number), "block num error");
279         require(validateSig(msg.sender, _hash, _blockNum, msg.value, _signature), "invalid signature");
280         lastSignedBlock[msg.sender] = _blockNum;
281         emit BuyPrimeRight(msg.sender, _blockNum);
282     }
283 
284     function validateSig(address _from, bytes32 _hash, uint256 _blockNum, uint256 _priceWei, bytes memory _signature) public view returns (bool) {
285         require(validator != address(0));
286         address signer = recover(ethSignedMessageHash(encodeData(_from, _hash, _blockNum, _priceWei)), _signature);
287         return (signer == validator);
288     }
289 
290     function encodeData(address _from, bytes32 _hash, uint256 _blockNum, uint256 _priceWei) public pure returns (bytes32) {
291         return keccak256(abi.encode(
292                                 _from,
293                                 _hash,
294                                 _blockNum,
295                                 _priceWei
296                                 )
297                      );
298     }
299 
300     function ethSignedMessageHash(bytes32 _data) public pure returns (bytes32) {
301         return ECDSA.toEthSignedMessageHash(_data);
302     }
303 
304     function recover(bytes32 _data, bytes memory _signature) public pure returns (address) {
305         return ECDSA.recover(_data, _signature);
306     }
307 }
1 // Copyright (c) 2018-2020 double jump.tokyo
2 pragma solidity 0.5.17;
3 
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceID) external view returns (bool);
6 }
7 
8 /// @title ERC-165 Standard Interface Detection
9 /// @dev See https://eips.ethereum.org/EIPS/eip-165
10 contract ERC165 is IERC165 {
11     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
12     mapping(bytes4 => bool) private _supportedInterfaces;
13 
14     constructor () internal {
15         _registerInterface(_INTERFACE_ID_ERC165);
16     }
17 
18     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
19         return _supportedInterfaces[interfaceId];
20     }
21 
22     function _registerInterface(bytes4 interfaceId) internal {
23         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
24         _supportedInterfaces[interfaceId] = true;
25     }
26 }
27 
28 library ECDSA {
29     /**
30      * @dev Returns the address that signed a hashed message (`hash`) with
31      * `signature`. This address can then be used for verification purposes.
32      *
33      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
34      * this function rejects them by requiring the `s` value to be in the lower
35      * half order, and the `v` value to be either 27 or 28.
36      *
37      * NOTE: This call _does not revert_ if the signature is invalid, or
38      * if the signer is otherwise unable to be retrieved. In those scenarios,
39      * the zero address is returned.
40      *
41      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
42      * verification to be secure: it is possible to craft signatures that
43      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
44      * this is by receiving a hash of the original message (which may otherwise
45      * be too long), and then calling {toEthSignedMessageHash} on it.
46      */
47     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
48         // Check the signature length
49         if (signature.length != 65) {
50             return (address(0));
51         }
52 
53         // Divide the signature in r, s and v variables
54         bytes32 r;
55         bytes32 s;
56         uint8 v;
57 
58         // ecrecover takes the signature parameters, and the only way to get them
59         // currently is to use assembly.
60         // solhint-disable-next-line no-inline-assembly
61         assembly {
62             r := mload(add(signature, 0x20))
63             s := mload(add(signature, 0x40))
64             v := byte(0, mload(add(signature, 0x60)))
65         }
66 
67         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
68         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
69         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
70         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
71         //
72         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
73         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
74         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
75         // these malleable signatures as well.
76         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
77             return address(0);
78         }
79 
80         if (v != 27 && v != 28) {
81             return address(0);
82         }
83 
84         // If the signature is valid (and not malleable), return the signer address
85         return ecrecover(hash, v, r, s);
86     }
87 
88     /**
89      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
90      * replicates the behavior of the
91      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
92      * JSON-RPC method.
93      *
94      * See {recover}.
95      */
96     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
97         // 32 is the length in bytes of hash,
98         // enforced by the type signature above
99         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
100     }
101 }
102 
103 library Roles {
104     struct Role {
105         mapping (address => bool) bearer;
106     }
107 
108     function add(Role storage role, address account) internal {
109         require(!has(role, account), "role already has the account");
110         role.bearer[account] = true;
111     }
112 
113     function remove(Role storage role, address account) internal {
114         require(has(role, account), "role dosen't have the account");
115         role.bearer[account] = false;
116     }
117 
118     function has(Role storage role, address account) internal view returns (bool) {
119         return role.bearer[account];
120     }
121 }
122 
123 contract Withdrawable {
124     using Roles for Roles.Role;
125 
126     event WithdrawerAdded(address indexed account);
127     event WithdrawerRemoved(address indexed account);
128 
129     Roles.Role private withdrawers;
130 
131     constructor() public {
132         withdrawers.add(msg.sender);
133     }
134 
135     modifier onlyWithdrawer() {
136         require(isWithdrawer(msg.sender), "Must be withdrawer");
137         _;
138     }
139 
140     function isWithdrawer(address account) public view returns (bool) {
141         return withdrawers.has(account);
142     }
143 
144     function addWithdrawer(address account) public onlyWithdrawer() {
145         withdrawers.add(account);
146         emit WithdrawerAdded(account);
147     }
148 
149     function removeWithdrawer(address account) public onlyWithdrawer() {
150         withdrawers.remove(account);
151         emit WithdrawerRemoved(account);
152     }
153 
154     function withdrawEther() public onlyWithdrawer() {
155         msg.sender.transfer(address(this).balance);
156     }
157 
158 }
159 
160 interface IERC173 /* is ERC165 */ {
161     /// @dev This emits when ownership of a contract changes.
162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164     /// @notice Get the address of the owner
165     /// @return The address of the owner.
166     function owner() external view returns (address);
167 
168     /// @notice Set the address of the new owner of the contract
169     /// @param _newOwner The address of the new owner of the contract
170     function transferOwnership(address _newOwner) external;
171 }
172 
173 contract ERC173 is IERC173, ERC165  {
174     address private _owner;
175 
176     constructor() public {
177         _registerInterface(0x7f5828d0);
178         _transferOwnership(msg.sender);
179     }
180 
181     modifier onlyOwner() {
182         require(msg.sender == owner(), "Must be owner");
183         _;
184     }
185 
186     function owner() public view returns (address) {
187         return _owner;
188     }
189 
190     function transferOwnership(address _newOwner) public onlyOwner() {
191         _transferOwnership(_newOwner);
192     }
193 
194     function _transferOwnership(address _newOwner) internal {
195         address previousOwner = owner();
196 	_owner = _newOwner;
197         emit OwnershipTransferred(previousOwner, _newOwner);
198     }
199 }
200 
201 contract Operatable is ERC173 {
202     using Roles for Roles.Role;
203 
204     event OperatorAdded(address indexed account);
205     event OperatorRemoved(address indexed account);
206 
207     event Paused(address account);
208     event Unpaused(address account);
209 
210     bool private _paused;
211     Roles.Role private operators;
212 
213     constructor() public {
214         operators.add(msg.sender);
215         _paused = false;
216     }
217 
218     modifier onlyOperator() {
219         require(isOperator(msg.sender), "Must be operator");
220         _;
221     }
222 
223     modifier whenNotPaused() {
224         require(!_paused, "Pausable: paused");
225         _;
226     }
227 
228     modifier whenPaused() {
229         require(_paused, "Pausable: not paused");
230         _;
231     }
232 
233     function transferOwnership(address _newOwner) public onlyOperator() {
234         _transferOwnership(_newOwner);
235     }
236 
237     function isOperator(address account) public view returns (bool) {
238         return operators.has(account);
239     }
240 
241     function addOperator(address account) public onlyOperator() {
242         operators.add(account);
243         emit OperatorAdded(account);
244     }
245 
246     function removeOperator(address account) public onlyOperator() {
247         operators.remove(account);
248         emit OperatorRemoved(account);
249     }
250 
251     function paused() public view returns (bool) {
252         return _paused;
253     }
254 
255     function pause() public onlyOperator() whenNotPaused() {
256         _paused = true;
257         emit Paused(msg.sender);
258     }
259 
260     function unpause() public onlyOperator() whenPaused() {
261         _paused = false;
262         emit Unpaused(msg.sender);
263     }
264 
265 }
266 
267 contract MCHPrimeV2 is Operatable,Withdrawable {
268 
269     address public validator;
270     mapping (address => uint256) public lastSignedBlock;
271     uint256 ableToBuyAfterRange;
272     uint256 sigExpireBlock;
273 
274     event BuyPrimeRight(
275         address indexed buyer,
276         uint256 signedBlock,
277         int64 signedAt
278     );
279 
280     constructor(address _varidator) public {
281         setValidater(_varidator);
282         setBlockRanges(20000, 10000);
283     }
284 
285     function setValidater(address _varidator) public onlyOperator() {
286         validator = _varidator;
287     }
288 
289     function setBlockRanges(uint256 _ableToBuyAfterRange, uint256 _sigExpireBlock) public onlyOperator() {
290         ableToBuyAfterRange = _ableToBuyAfterRange;
291         sigExpireBlock = _sigExpireBlock;
292     }
293 
294     function isApplicableNow() public view returns (bool) {
295         isApplicable(msg.sender, block.number, block.number);
296     }
297 
298     function isApplicable(address _buyer, uint256 _blockNum, uint256 _currentBlock) public view returns (bool) {
299         if (lastSignedBlock[_buyer] != 0) {
300             if (_blockNum < lastSignedBlock[_buyer] + ableToBuyAfterRange) {
301                 return false;
302             }
303         }
304 
305         if (_blockNum >= _currentBlock + sigExpireBlock) {
306             return false;
307         }
308         return true;
309     }
310 
311     function buyPrimeRight(bytes calldata _signature, uint256 _blockNum, int64 _signedAt) external payable whenNotPaused() {
312         require(isApplicable(msg.sender, _blockNum, block.number), "block num error");
313         require(validateSig(msg.sender, _blockNum, _signedAt, msg.value, _signature), "invalid signature");
314         lastSignedBlock[msg.sender] = _blockNum;
315         emit BuyPrimeRight(msg.sender, _blockNum, _signedAt);
316     }
317 
318     function validateSig(address _from, uint256 _blockNum, int64 _signedAt, uint256 _priceWei, bytes memory _signature) internal view returns (bool) {
319         require(validator != address(0));
320         address signer = recover(ethSignedMessageHash(encodeData(_from, _blockNum, _signedAt, _priceWei)), _signature);
321         return (signer == validator);
322     }
323 
324     function encodeData(address _from, uint256 _blockNum, int64 _signedAt, uint256 _priceWei) internal pure returns (bytes32) {
325         return keccak256(abi.encode(
326                                 _from,
327                                 _blockNum,
328                                 _signedAt,
329                                 _priceWei
330                                 )
331                      );
332     }
333 
334     function ethSignedMessageHash(bytes32 _data) internal pure returns (bytes32) {
335         return ECDSA.toEthSignedMessageHash(_data);
336     }
337 
338     function recover(bytes32 _data, bytes memory _signature) internal pure returns (address) {
339         return ECDSA.recover(_data, _signature);
340     }
341 }
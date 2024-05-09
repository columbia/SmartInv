1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.5.16;
3 
4 library ECDSA {
5     /**
6      * @dev Returns the address that signed a hashed message (`hash`) with
7      * `signature`. This address can then be used for verification purposes.
8      *
9      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
10      * this function rejects them by requiring the `s` value to be in the lower
11      * half order, and the `v` value to be either 27 or 28.
12      *
13      * NOTE: This call _does not revert_ if the signature is invalid, or
14      * if the signer is otherwise unable to be retrieved. In those scenarios,
15      * the zero address is returned.
16      *
17      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
18      * verification to be secure: it is possible to craft signatures that
19      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
20      * this is by receiving a hash of the original message (which may otherwise
21      * be too long), and then calling {toEthSignedMessageHash} on it.
22      */
23     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
24         // Check the signature length
25         if (signature.length != 65) {
26             return (address(0));
27         }
28 
29         // Divide the signature in r, s and v variables
30         bytes32 r;
31         bytes32 s;
32         uint8 v;
33 
34         // ecrecover takes the signature parameters, and the only way to get them
35         // currently is to use assembly.
36         // solhint-disable-next-line no-inline-assembly
37         assembly {
38             r := mload(add(signature, 0x20))
39             s := mload(add(signature, 0x40))
40             v := byte(0, mload(add(signature, 0x60)))
41         }
42 
43         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
44         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
45         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
46         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
47         //
48         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
49         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
50         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
51         // these malleable signatures as well.
52         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
53             return address(0);
54         }
55 
56         if (v != 27 && v != 28) {
57             return address(0);
58         }
59 
60         // If the signature is valid (and not malleable), return the signer address
61         return ecrecover(hash, v, r, s);
62     }
63 
64     /**
65      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
66      * replicates the behavior of the
67      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
68      * JSON-RPC method.
69      *
70      * See {recover}.
71      */
72     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
73         // 32 is the length in bytes of hash,
74         // enforced by the type signature above
75         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
76     }
77 }
78 
79 library Roles {
80     struct Role {
81         mapping (address => bool) bearer;
82     }
83 
84     function add(Role storage role, address account) internal {
85         require(!has(role, account), "role already has the account");
86         role.bearer[account] = true;
87     }
88 
89     function remove(Role storage role, address account) internal {
90         require(has(role, account), "role dosen't have the account");
91         role.bearer[account] = false;
92     }
93 
94     function has(Role storage role, address account) internal view returns (bool) {
95         return role.bearer[account];
96     }
97 }
98 
99 interface IERC165 {
100     function supportsInterface(bytes4 interfaceID) external view returns (bool);
101 }
102 
103 /// @title ERC-165 Standard Interface Detection
104 /// @dev See https://eips.ethereum.org/EIPS/eip-165
105 contract ERC165 is IERC165 {
106     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
107     mapping(bytes4 => bool) private _supportedInterfaces;
108 
109     constructor () internal {
110         _registerInterface(_INTERFACE_ID_ERC165);
111     }
112 
113     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
114         return _supportedInterfaces[interfaceId];
115     }
116 
117     function _registerInterface(bytes4 interfaceId) internal {
118         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
119         _supportedInterfaces[interfaceId] = true;
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
234 contract BFHDailyActionV1 is Operatable {
235 
236     address public validator;
237     mapping(address => int64) public lastActionDateAddress;
238     mapping(bytes32 => int64) public lastActionDateHash;
239 
240     event Action(address indexed user, int64 at);
241 
242     constructor(address _varidator) public {
243         setValidater(_varidator);
244     }
245 
246     function setValidater(address _varidator) public onlyOperator() {
247         validator = _varidator;
248     }
249 
250     function isApplicable(address _sender, bytes32 _hash, int64 _time) public view returns (bool) {
251         if (_hash == bytes32(0)) {
252             return false;
253         }
254         int64 day = _time / 86400;
255         if (lastActionDateAddress[_sender] >= day) {
256             return false;
257         }
258         if (lastActionDateHash[_hash] >= day) {
259             return false;
260         }
261         return true;
262     }
263 
264     function action(bytes calldata _signature, bytes32 _hash, int64 _time) external whenNotPaused() {
265         require(isApplicable(msg.sender, _hash, _time), "already transacted");
266         require(validateSig(msg.sender, _hash, _time, _signature), "invalid signature");
267         int64 day = _time / 86400;
268         lastActionDateAddress[msg.sender] = day;
269         lastActionDateHash[_hash] = day;
270         emit Action(msg.sender, _time);
271   }
272 
273   function validateSig(address _from, bytes32 _hash, int64 _time, bytes memory _signature) public view returns (bool) {
274     require(validator != address(0));
275     address signer = recover(ethSignedMessageHash(encodeData(_from, _hash, _time)), _signature);
276     return (signer == validator);
277   }
278 
279   function encodeData(address _from, bytes32 _hash, int64 _time) public pure returns (bytes32) {
280     return keccak256(abi.encode(
281                                 _from,
282                                 _hash,
283                                 _time
284                                 )
285                      );
286   }
287 
288   function ethSignedMessageHash(bytes32 _data) public pure returns (bytes32) {
289     return ECDSA.toEthSignedMessageHash(_data);
290   }
291 
292   function recover(bytes32 _data, bytes memory _signature) public pure returns (address) {
293     return ECDSA.recover(_data, _signature);
294   }
295 }
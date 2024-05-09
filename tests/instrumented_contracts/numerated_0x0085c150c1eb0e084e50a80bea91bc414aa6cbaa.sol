1 pragma solidity 0.5.7;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/rmanzoku/src/github.com/doublejumptokyo/mch-experimental/contracts/MetaMarking.sol
6 // flattened :  Friday, 12-Apr-19 07:50:40 UTC
7 library ECDSA {
8     /**
9      * @dev Recover signer address from a message by using their signature
10      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
11      * @param signature bytes signature, the signature is generated using web3.eth.sign()
12      */
13     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
14         // Check the signature length
15         if (signature.length != 65) {
16             return (address(0));
17         }
18 
19         // Divide the signature in r, s and v variables
20         bytes32 r;
21         bytes32 s;
22         uint8 v;
23 
24         // ecrecover takes the signature parameters, and the only way to get them
25         // currently is to use assembly.
26         // solhint-disable-next-line no-inline-assembly
27         assembly {
28             r := mload(add(signature, 0x20))
29             s := mload(add(signature, 0x40))
30             v := byte(0, mload(add(signature, 0x60)))
31         }
32 
33         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
34         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
35         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
36         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
37         //
38         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
39         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
40         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
41         // these malleable signatures as well.
42         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
43             return address(0);
44         }
45 
46         if (v != 27 && v != 28) {
47             return address(0);
48         }
49 
50         // If the signature is valid (and not malleable), return the signer address
51         return ecrecover(hash, v, r, s);
52     }
53 
54     /**
55      * toEthSignedMessageHash
56      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
57      * and hash the result
58      */
59     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
60         // 32 is the length in bytes of hash,
61         // enforced by the type signature above
62         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
63     }
64 }
65 
66 library Roles {
67     struct Role {
68         mapping (address => bool) bearer;
69     }
70 
71     /**
72      * @dev give an account access to this role
73      */
74     function add(Role storage role, address account) internal {
75         require(account != address(0));
76         require(!has(role, account));
77 
78         role.bearer[account] = true;
79     }
80 
81     /**
82      * @dev remove an account's access to this role
83      */
84     function remove(Role storage role, address account) internal {
85         require(account != address(0));
86         require(has(role, account));
87 
88         role.bearer[account] = false;
89     }
90 
91     /**
92      * @dev check if an account has this role
93      * @return bool
94      */
95     function has(Role storage role, address account) internal view returns (bool) {
96         require(account != address(0));
97         return role.bearer[account];
98     }
99 }
100 
101 contract OperatorRole {
102     using Roles for Roles.Role;
103 
104     event OperatorAdded(address indexed account);
105     event OperatorRemoved(address indexed account);
106 
107     Roles.Role private operators;
108 
109     constructor() public {
110         operators.add(msg.sender);
111     }
112 
113     modifier onlyOperator() {
114         require(isOperator(msg.sender));
115         _;
116     }
117     
118     function isOperator(address account) public view returns (bool) {
119         return operators.has(account);
120     }
121 
122     function addOperator(address account) public onlyOperator() {
123         operators.add(account);
124         emit OperatorAdded(account);
125     }
126 
127     function removeOperator(address account) public onlyOperator() {
128         operators.remove(account);
129         emit OperatorRemoved(account);
130     }
131 
132 }
133 contract MCHMetaMarking is OperatorRole {
134 
135   mapping(address => uint256) public nonces;
136 
137   struct Mark {
138     bool isExist;
139     int64 markAt;
140     uint32 uid;
141     int64 primeUntil;
142     uint8 landType;
143   }
144 
145   event Marking(
146              address indexed from,
147              int64 markAt,
148              uint32 uid,
149              int64 primeUntil,
150              uint8 landType
151              );
152 
153   mapping(uint8 => address[]) public addressesByLandType;
154   mapping(address => Mark) public latestMarkByAddress;
155 
156   constructor() public {
157     addOperator(address(0x51C36baAa8b0e6CF45e2E1A77E84E3c0D1713F97));
158   }
159 
160   function encodeData(address _from, int64 _markAt, uint32 _uid, int64 _primeUntil,
161                       uint8 _landType, uint256 _nonce, address _relayer) public view returns (bytes32) {
162     return keccak256(abi.encode(
163                                       address(this),
164                                       _from,
165                                       _markAt,
166                                       _uid,
167                                       _primeUntil,
168                                       _landType,
169                                       _nonce,
170                                       _relayer
171                                       )
172                      );
173   }
174 
175   function ethSignedMessageHash(bytes32 _data) public pure returns (bytes32) {
176     return ECDSA.toEthSignedMessageHash(_data);
177   }
178 
179   function recover(bytes32 _data, bytes memory _sig) public pure returns (address) {
180     bytes32 data = ECDSA.toEthSignedMessageHash(_data);
181     return ECDSA.recover(data, _sig);
182   }
183 
184   function executeMarkMetaTx(address _from, int64 _markAt, uint32 _uid, int64 _primeUntil,
185                              uint8 _landType, uint256 _nonce, bytes calldata _sig) external onlyOperator() {
186     require(nonces[_from]+1 == _nonce, "nonces[_from]+1 != _nonce");
187     bytes32 encodedData = encodeData(_from, _markAt, _uid, _primeUntil, _landType, _nonce, msg.sender);
188     address signer = recover(encodedData, _sig);
189     require(signer == _from, "signer != _from");
190 
191     _mark(_from, _markAt, _uid, _primeUntil, _landType);
192     nonces[_from]++;
193   }
194 
195   function forceMark(address _user, int64 _markAt, uint32 _uid, int64 _primeUntil, uint8 _landType) external onlyOperator() {
196     _mark(_user, _markAt, _uid, _primeUntil, _landType);
197   }
198 
199   function _mark(address _user, int64 _markAt, uint32 _uid, int64 _primeUntil, uint8 _landType) private {
200 
201     if (!latestMarkByAddress[_user].isExist) {
202       latestMarkByAddress[_user] = Mark(
203                                         true,
204                                         _markAt,
205                                         _uid,
206                                         _primeUntil,
207                                         _landType
208                                         );
209       addressesByLandType[_landType].push(_user);
210       return;
211     }
212 
213     uint8 currentLandType = latestMarkByAddress[_user].landType;
214     if (currentLandType != _landType) {
215       uint256 i;
216       for (i = 0; i < addressesByLandType[_landType].length; i++) {
217 	if (addressesByLandType[_landType][i] != _user) {
218 	  break;
219 	}
220       }
221 
222       delete addressesByLandType[currentLandType][i];
223       addressesByLandType[_landType].push(_user);
224     }
225 
226     latestMarkByAddress[_user].markAt = _markAt;
227     latestMarkByAddress[_user].uid = _uid;
228     latestMarkByAddress[_user].primeUntil = _primeUntil;
229     latestMarkByAddress[_user].landType = _landType;
230 
231     emit Marking(_user, _markAt, _uid, _primeUntil, _landType);
232   }
233 
234   function getAddressesByLandType(uint8 _landType, int64 _validSince) public view returns (address[] memory){
235     if (addressesByLandType[_landType].length == 0) {
236       return new address[](0);
237     }
238 
239     uint256 cnt;
240     for (uint256 i = 0; i < addressesByLandType[_landType].length; i++) {
241       address addr = addressesByLandType[_landType][i];
242       if (addr == address(0x0)) {
243         continue;
244       }
245 
246       if (latestMarkByAddress[addr].markAt >= _validSince) {
247         cnt++;
248       }
249     }
250 
251     address[] memory ret = new address[](cnt);
252     uint256 idx = 0;
253     for (uint256 i = 0; i < addressesByLandType[_landType].length; i++) {
254       address addr = addressesByLandType[_landType][i];
255       if (addr == address(0x0)) {
256         continue;
257       }
258 
259       if (latestMarkByAddress[addr].markAt >= _validSince) {
260         ret[idx] = addr;
261         idx++;
262       }
263     }
264 
265     return ret;
266   }
267 
268   function meta_nonce(address _from) external view returns (uint256 nonce) {
269     return nonces[_from];
270   }
271 
272   function kill() external onlyOperator() {
273     selfdestruct(msg.sender);
274   }
275 }
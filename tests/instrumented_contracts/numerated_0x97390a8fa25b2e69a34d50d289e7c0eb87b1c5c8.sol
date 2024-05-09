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
123 library Uint256 {
124 
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "addition overflow");
128         return c;
129     }
130 
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(a >= b, "subtraction overflow");
133         return a - b;
134     }
135 
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         if (a == 0) {
138             return 0;
139         }
140         uint256 c = a * b;
141         require(c / a == b, "multiplication overflow");
142         return c;
143     }
144 
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         require(b != 0, "division by 0");
147         return a / b;
148     }
149 
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         require(b != 0, "modulo by 0");
152         return a % b;
153     }
154 
155     function toString(uint256 a) internal pure returns (string memory) {
156         bytes32 retBytes32;
157         uint256 len = 0;
158         if (a == 0) {
159             retBytes32 = "0";
160             len++;
161         } else {
162             uint256 value = a;
163             while (value > 0) {
164                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
165                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
166                 value /= 10;
167                 len++;
168             }
169         }
170 
171         bytes memory ret = new bytes(len);
172         uint256 i;
173 
174         for (i = 0; i < len; i++) {
175             ret[i] = retBytes32[i];
176         }
177         return string(ret);
178     }
179 }
180 
181 interface IERC173 /* is ERC165 */ {
182     /// @dev This emits when ownership of a contract changes.
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /// @notice Get the address of the owner
186     /// @return The address of the owner.
187     function owner() external view returns (address);
188 
189     /// @notice Set the address of the new owner of the contract
190     /// @param _newOwner The address of the new owner of the contract
191     function transferOwnership(address _newOwner) external;
192 }
193 
194 contract ERC173 is IERC173, ERC165  {
195     address private _owner;
196 
197     constructor() public {
198         _registerInterface(0x7f5828d0);
199         _transferOwnership(msg.sender);
200     }
201 
202     modifier onlyOwner() {
203         require(msg.sender == owner(), "Must be owner");
204         _;
205     }
206 
207     function owner() public view returns (address) {
208         return _owner;
209     }
210 
211     function transferOwnership(address _newOwner) public onlyOwner() {
212         _transferOwnership(_newOwner);
213     }
214 
215     function _transferOwnership(address _newOwner) internal {
216         address previousOwner = owner();
217 	_owner = _newOwner;
218         emit OwnershipTransferred(previousOwner, _newOwner);
219     }
220 }
221 
222 contract Operatable is ERC173 {
223     using Roles for Roles.Role;
224 
225     event OperatorAdded(address indexed account);
226     event OperatorRemoved(address indexed account);
227 
228     event Paused(address account);
229     event Unpaused(address account);
230 
231     bool private _paused;
232     Roles.Role private operators;
233 
234     constructor() public {
235         operators.add(msg.sender);
236         _paused = false;
237     }
238 
239     modifier onlyOperator() {
240         require(isOperator(msg.sender), "Must be operator");
241         _;
242     }
243 
244     modifier whenNotPaused() {
245         require(!_paused, "Pausable: paused");
246         _;
247     }
248 
249     modifier whenPaused() {
250         require(_paused, "Pausable: not paused");
251         _;
252     }
253 
254     function transferOwnership(address _newOwner) public onlyOperator() {
255         _transferOwnership(_newOwner);
256     }
257 
258     function isOperator(address account) public view returns (bool) {
259         return operators.has(account);
260     }
261 
262     function addOperator(address account) public onlyOperator() {
263         operators.add(account);
264         emit OperatorAdded(account);
265     }
266 
267     function removeOperator(address account) public onlyOperator() {
268         operators.remove(account);
269         emit OperatorRemoved(account);
270     }
271 
272     function paused() public view returns (bool) {
273         return _paused;
274     }
275 
276     function pause() public onlyOperator() whenNotPaused() {
277         _paused = true;
278         emit Paused(msg.sender);
279     }
280 
281     function unpause() public onlyOperator() whenPaused() {
282         _paused = false;
283         emit Unpaused(msg.sender);
284     }
285 
286     function withdrawEther() public onlyOperator() {
287         msg.sender.transfer(address(this).balance);
288     }
289 
290 }
291 
292 contract BFHZELGatewayV1 is Operatable {
293     using Uint256 for uint256;
294     struct Campaign {
295         uint256 since;
296         uint256 until;
297         uint8 purchaseType;
298         uint8 subPurchaseType;
299     }
300 
301     uint8 constant PURCHASE_NORMAL = 0;
302     uint8 constant PURCHASE_ETH_BACK = 1;
303     uint8 constant PURCHASE_ZELUP20 = 2;
304     uint8 constant PURCHASE_REGULAR = 3;
305     uint8 constant PURCHASE_ETH_BACK_ZELUP20 = 4;
306 
307     Campaign public campaign;
308 
309     mapping(uint256 => bool) public payableOptions;
310     address public validater;
311 
312     uint256 constant BASE = 10000;
313     uint256 private nonce;
314     uint16 public chanceDenom;
315     uint256 public ethBackBasisPoint;
316     bytes private salt;
317 
318     event Sold(
319         address indexed user,
320         address indexed referrer,
321         uint8 purchaseType,
322         uint256 grossValue,
323         uint256 referralValue,
324         uint256 netValue
325     );
326 
327     event CampaignUpdated(
328         uint256 since,
329         uint256 until,
330         uint8 purchaseType,
331         uint8 subPurchaseType
332     );
333 
334     constructor(
335         address _validater
336     ) public payable {
337         setValidater(_validater);
338         setCampaign(0, 0, 0, 0);
339         updateEthBackPercentege(5000);
340         updateChance(25);
341         salt = bytes("Ohph0eeNEeT6weic");
342 
343         nonce = 222;
344 
345         payableOptions[0.03 ether] = true;
346         payableOptions[0.05 ether] = true;
347         payableOptions[0.1 ether] = true;
348         payableOptions[0.5 ether] = true;
349         payableOptions[1 ether] = true;
350         payableOptions[5 ether] = true;
351         payableOptions[10 ether] = true;
352     }
353 
354     function setValidater(address _varidater) public onlyOperator() {
355         validater = _varidater;
356     }
357 
358     function setPayableOption(uint256 _option, bool desired) external onlyOperator() {
359         payableOptions[_option] = desired;
360     }
361 
362     function setCampaign(
363         uint256 _since,
364         uint256 _until,
365         uint8 _purchaseType,
366         uint8 _subPurchaseType
367     )
368         public
369         onlyOperator()
370     {
371         campaign = Campaign(_since, _until, _purchaseType, _subPurchaseType);
372         emit CampaignUpdated(_since, _until, _purchaseType, _subPurchaseType);
373     }
374 
375     function updateChance(uint16 _newchanceDenom) public onlyOperator() {
376         chanceDenom = _newchanceDenom;
377     }
378 
379     function updateEthBackPercentege(uint256 _ethBackBasisPoint) public onlyOperator() {
380         ethBackBasisPoint = _ethBackBasisPoint;
381     }
382 
383 
384     function buyZEL(
385         address payable _referrer,
386         uint256 _referralBasisPoint,
387         bytes calldata _signature
388     )
389         external
390         payable
391         whenNotPaused()
392     {
393         require(_referralBasisPoint + ethBackBasisPoint <= BASE, "Invalid basis points");
394         require(payableOptions[msg.value], "Invalid msg.value");
395         require(validateSig(encodeData(msg.sender, _referrer, _referralBasisPoint), _signature), "Invalid signature");
396 
397         (uint8 purchaseType, uint8 subPurchaseType) = getPurchaseType(block.number);
398         uint256 netValue = msg.value;
399         uint256 referralValue = 0;
400 
401         if (purchaseType == PURCHASE_ETH_BACK || purchaseType == PURCHASE_ETH_BACK_ZELUP20) {
402             if (getRandom(chanceDenom, nonce, msg.sender) == 0) {
403                 uint256 ethBackValue = _ethBack(msg.sender, ethBackBasisPoint);
404                 netValue = netValue.sub(ethBackValue);
405             } else {
406                 purchaseType = subPurchaseType;
407                 referralValue = _referrerBack(_referrer, _referralBasisPoint);
408             }
409             nonce++;
410         } else {
411             referralValue = _referrerBack(_referrer, _referralBasisPoint);
412         }
413 
414         netValue = netValue.sub(referralValue);
415 
416         emit Sold(
417             msg.sender,
418             _referrer,
419             purchaseType,
420             msg.value,
421             referralValue,
422             netValue
423         );
424     }
425 
426     function getPurchaseType(uint256 _block) public view returns (uint8, uint8) {
427         if(campaign.until < _block) {
428             return (0, 0);
429         }
430         if(campaign.since > _block) {
431             return (0, 0);
432         }
433         return (campaign.purchaseType, campaign.subPurchaseType);
434     }
435 
436     function getRandom(uint16 max, uint256 _nonce, address _sender) internal view returns (uint16) {
437         return uint16(
438             bytes2(
439                 keccak256(
440                     abi.encodePacked(
441                         blockhash(block.number-1),
442                         _sender,
443                         _nonce,
444                         salt
445                     )
446                 )
447             )
448         ) % max;
449     }
450 
451     function _ethBack(address payable _buyer, uint256 _ethBackBasisPoint) internal returns (uint256) {
452         uint256 ethBackValue = msg.value.mul(_ethBackBasisPoint).div(BASE);
453         _buyer.transfer(ethBackValue);
454         return ethBackValue;
455     }
456 
457     function _referrerBack(address payable _referrer, uint256 _referralBasisPoint) internal returns (uint256) {
458         if(_referrer == address(0x0) || _referrer == msg.sender) {
459             return 0;
460         }
461         uint256 referralValue = msg.value.mul(_referralBasisPoint).div(BASE);
462         _referrer.transfer(referralValue);
463         return referralValue;
464     }
465 
466     function encodeData(address _sender, address _referrer, uint256 _referralBasisPoint) public pure returns (bytes32) {
467         return keccak256(
468             abi.encode(
469                 _sender,
470                 _referrer,
471                 _referralBasisPoint
472             )
473         );
474     }
475 
476     function validateSig(bytes32 _message, bytes memory _signature) public view returns (bool) {
477         require(validater != address(0), "validater must be setted");
478         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
479         return (signer == validater);
480     }
481 }
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
181 contract Withdrawable {
182     using Roles for Roles.Role;
183 
184     event WithdrawerAdded(address indexed account);
185     event WithdrawerRemoved(address indexed account);
186 
187     Roles.Role private withdrawers;
188 
189     constructor() public {
190         withdrawers.add(msg.sender);
191     }
192 
193     modifier onlyWithdrawer() {
194         require(isWithdrawer(msg.sender), "Must be withdrawer");
195         _;
196     }
197 
198     function isWithdrawer(address account) public view returns (bool) {
199         return withdrawers.has(account);
200     }
201 
202     function addWithdrawer(address account) public onlyWithdrawer() {
203         withdrawers.add(account);
204         emit WithdrawerAdded(account);
205     }
206 
207     function removeWithdrawer(address account) public onlyWithdrawer() {
208         withdrawers.remove(account);
209         emit WithdrawerRemoved(account);
210     }
211 
212     function withdrawEther() public onlyWithdrawer() {
213         msg.sender.transfer(address(this).balance);
214     }
215 
216 }
217 
218 interface IERC173 /* is ERC165 */ {
219     /// @dev This emits when ownership of a contract changes.
220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222     /// @notice Get the address of the owner
223     /// @return The address of the owner.
224     function owner() external view returns (address);
225 
226     /// @notice Set the address of the new owner of the contract
227     /// @param _newOwner The address of the new owner of the contract
228     function transferOwnership(address _newOwner) external;
229 }
230 
231 contract ERC173 is IERC173, ERC165  {
232     address private _owner;
233 
234     constructor() public {
235         _registerInterface(0x7f5828d0);
236         _transferOwnership(msg.sender);
237     }
238 
239     modifier onlyOwner() {
240         require(msg.sender == owner(), "Must be owner");
241         _;
242     }
243 
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     function transferOwnership(address _newOwner) public onlyOwner() {
249         _transferOwnership(_newOwner);
250     }
251 
252     function _transferOwnership(address _newOwner) internal {
253         address previousOwner = owner();
254 	_owner = _newOwner;
255         emit OwnershipTransferred(previousOwner, _newOwner);
256     }
257 }
258 
259 contract Operatable is ERC173 {
260     using Roles for Roles.Role;
261 
262     event OperatorAdded(address indexed account);
263     event OperatorRemoved(address indexed account);
264 
265     event Paused(address account);
266     event Unpaused(address account);
267 
268     bool private _paused;
269     Roles.Role private operators;
270 
271     constructor() public {
272         operators.add(msg.sender);
273         _paused = false;
274     }
275 
276     modifier onlyOperator() {
277         require(isOperator(msg.sender), "Must be operator");
278         _;
279     }
280 
281     modifier whenNotPaused() {
282         require(!_paused, "Pausable: paused");
283         _;
284     }
285 
286     modifier whenPaused() {
287         require(_paused, "Pausable: not paused");
288         _;
289     }
290 
291     function transferOwnership(address _newOwner) public onlyOperator() {
292         _transferOwnership(_newOwner);
293     }
294 
295     function isOperator(address account) public view returns (bool) {
296         return operators.has(account);
297     }
298 
299     function addOperator(address account) public onlyOperator() {
300         operators.add(account);
301         emit OperatorAdded(account);
302     }
303 
304     function removeOperator(address account) public onlyOperator() {
305         operators.remove(account);
306         emit OperatorRemoved(account);
307     }
308 
309     function paused() public view returns (bool) {
310         return _paused;
311     }
312 
313     function pause() public onlyOperator() whenNotPaused() {
314         _paused = true;
315         emit Paused(msg.sender);
316     }
317 
318     function unpause() public onlyOperator() whenPaused() {
319         _paused = false;
320         emit Unpaused(msg.sender);
321     }
322 
323 }
324 
325 contract BFHZELGatewayV3 is Operatable, Withdrawable {
326     using Uint256 for uint256;
327     struct Campaign {
328         uint8 purchaseType;
329         uint8 subPurchaseType;
330         uint8 proxyPurchaseType;
331     }
332 
333     uint8 constant PURCHASE_NORMAL = 0;
334     uint8 constant PURCHASE_ETH_BACK = 1;
335     uint8 constant PURCHASE_UP20 = 2;
336     uint8 constant PURCHASE_REGULAR = 3;
337     uint8 constant PURCHASE_ETH_BACK_UP20 = 4;
338     uint8 constant PURCHASE_UP10 = 5;
339 
340     Campaign public campaign;
341 
342     address public validater;
343 
344     uint256 constant BASE = 10000;
345     uint256 private nonce;
346     uint16 public chanceDenom;
347     uint256 public ethBackBasisPoint;
348     bytes private salt;
349     mapping(bytes32 => uint256) public hashTransactedAt;
350 
351     event Sold(
352         address indexed user,
353         address indexed referrer,
354         uint8 purchaseType,
355         uint32 usCent,
356         uint256 grossValue,
357         uint256 referralValue,
358         uint256 netValue
359     );
360 
361     event CampaignUpdated(
362         uint8 purchaseType,
363         uint8 subPurchaseType,
364         uint8 proxyPurchaseType
365     );
366 
367     constructor(
368         address _validater
369     ) public payable {
370         setValidater(_validater);
371         setCampaign(0, 0, 0);
372         updateEthBackPercentege(5000);
373         updateChance(25);
374         salt = bytes("ulooNg6veiv2Mieg");
375 
376         nonce = 489;
377     }
378 
379     function setValidater(address _varidater) public onlyOperator() {
380         validater = _varidater;
381     }
382 
383     function setCampaign(
384         uint8 _purchaseType,
385         uint8 _subPurchaseType,
386         uint8 _proxyPurchaseType
387     )
388         public
389         onlyOperator()
390     {
391         campaign = Campaign(_purchaseType, _subPurchaseType, _proxyPurchaseType);
392         emit CampaignUpdated(_purchaseType, _subPurchaseType, _proxyPurchaseType);
393     }
394 
395     function updateChance(uint16 _newchanceDenom) public onlyOperator() {
396         chanceDenom = _newchanceDenom;
397     }
398 
399     function updateEthBackPercentege(uint256 _ethBackBasisPoint) public onlyOperator() {
400         ethBackBasisPoint = _ethBackBasisPoint;
401     }
402 
403     function buy(
404         address payable _user,
405         address payable _referrer,
406         uint256 _referralBasisPoint,
407         uint32 _usCent,
408         bytes memory _signature,
409         bytes32 _hash
410     )
411         public
412         payable
413         whenNotPaused()
414     {
415         require(_referralBasisPoint + ethBackBasisPoint <= BASE, "Invalid basis points");
416         require(validateSig(encodeData(_user, _referrer, _referralBasisPoint, _usCent, msg.value), _signature), "Invalid signature");
417         if (_hash != bytes32(0)) {
418             recordHash(_hash);
419         }
420         uint8 purchaseType = campaign.proxyPurchaseType;
421         uint256 netValue = msg.value;
422         uint256 referralValue = _referrerBack(_referrer, _referralBasisPoint);
423         netValue = netValue.sub(referralValue);
424 
425         emit Sold(
426             _user,
427             _referrer,
428             purchaseType,
429             _usCent,
430             msg.value,
431             referralValue,
432             netValue
433         );
434     }
435     
436     function buyZEL(
437         address payable _referrer,
438         uint256 _referralBasisPoint,
439         uint32 _usCent,
440         bytes memory _signature
441     )
442         public
443         payable
444     {
445         require(_referralBasisPoint + ethBackBasisPoint <= BASE, "Invalid basis points");
446         require(validateSig(encodeData(msg.sender, _referrer, _referralBasisPoint, _usCent, msg.value), _signature), "Invalid signature");
447 
448         uint8 purchaseType = campaign.purchaseType;
449         uint256 netValue = msg.value;
450         uint256 referralValue = 0;
451 
452         if (purchaseType == PURCHASE_ETH_BACK || purchaseType == PURCHASE_ETH_BACK_UP20) {
453             if (getRandom(chanceDenom, nonce, msg.sender) == 0) {
454                 uint256 ethBackValue = _ethBack(msg.sender, ethBackBasisPoint);
455                 netValue = netValue.sub(ethBackValue);
456             } else {
457                 purchaseType = campaign.subPurchaseType;
458                 referralValue = _referrerBack(_referrer, _referralBasisPoint);
459             }
460             nonce++;
461         } else {
462             referralValue = _referrerBack(_referrer, _referralBasisPoint);
463         }
464 
465         netValue = netValue.sub(referralValue);
466 
467         emit Sold(
468             msg.sender,
469             _referrer,
470             purchaseType,
471             _usCent,
472             msg.value,
473             referralValue,
474             netValue
475         );
476     }
477 
478     function recordHash(bytes32 _hash) internal {
479         require(hashTransactedAt[_hash] == 0, "The hash is already transacted");
480         hashTransactedAt[_hash] = block.number;
481     }
482 
483     function getRandom(uint16 max, uint256 _nonce, address _sender) public view returns (uint16) {
484         return uint16(
485             bytes2(
486                 keccak256(
487                     abi.encodePacked(
488                         blockhash(block.number-1),
489                         _sender,
490                         _nonce,
491                         salt
492                     )
493                 )
494             )
495         ) % max;
496     }
497 
498     function _ethBack(address payable _buyer, uint256 _ethBackBasisPoint) internal returns (uint256) {
499         uint256 ethBackValue = msg.value.mul(_ethBackBasisPoint).div(BASE);
500         _buyer.transfer(ethBackValue);
501         return ethBackValue;
502     }
503 
504     function _referrerBack(address payable _referrer, uint256 _referralBasisPoint) internal returns (uint256) {
505         if(_referrer == address(0x0) || _referrer == msg.sender) {
506             return 0;
507         }
508         uint256 referralValue = msg.value.mul(_referralBasisPoint).div(BASE);
509         _referrer.transfer(referralValue);
510         return referralValue;
511     }
512 
513     function encodeData(address _user, address _referrer, uint256 _referralBasisPoint, uint32 _usCent, uint256 _value) public pure returns (bytes32) {
514         return keccak256(
515             abi.encode(
516                 _user,
517                 _referrer,
518                 _referralBasisPoint,
519                 _usCent,
520                 _value
521             )
522         );
523     }
524 
525     function validateSig(bytes32 _message, bytes memory _signature) public view returns (bool) {
526         require(validater != address(0), "validater must be set");
527         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
528         return (signer == validater);
529     }
530     
531     function recover(bytes32 _message, bytes memory _signature) public pure returns (address) {
532         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
533         return signer;
534     }
535 }
1 pragma solidity 0.5.17;
2 library ECDSA {
3     /**
4      * @dev Returns the address that signed a hashed message (`hash`) with
5      * `signature`. This address can then be used for verification purposes.
6      *
7      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
8      * this function rejects them by requiring the `s` value to be in the lower
9      * half order, and the `v` value to be either 27 or 28.
10      *
11      * NOTE: This call _does not revert_ if the signature is invalid, or
12      * if the signer is otherwise unable to be retrieved. In those scenarios,
13      * the zero address is returned.
14      *
15      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
16      * verification to be secure: it is possible to craft signatures that
17      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
18      * this is by receiving a hash of the original message (which may otherwise
19      * be too long), and then calling {toEthSignedMessageHash} on it.
20      */
21     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
22         // Check the signature length
23         if (signature.length != 65) {
24             return (address(0));
25         }
26 
27         // Divide the signature in r, s and v variables
28         bytes32 r;
29         bytes32 s;
30         uint8 v;
31 
32         // ecrecover takes the signature parameters, and the only way to get them
33         // currently is to use assembly.
34         // solhint-disable-next-line no-inline-assembly
35         assembly {
36             r := mload(add(signature, 0x20))
37             s := mload(add(signature, 0x40))
38             v := byte(0, mload(add(signature, 0x60)))
39         }
40 
41         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
42         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
43         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
44         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
45         //
46         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
47         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
48         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
49         // these malleable signatures as well.
50         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
51             return address(0);
52         }
53 
54         if (v != 27 && v != 28) {
55             return address(0);
56         }
57 
58         // If the signature is valid (and not malleable), return the signer address
59         return ecrecover(hash, v, r, s);
60     }
61 
62     /**
63      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
64      * replicates the behavior of the
65      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
66      * JSON-RPC method.
67      *
68      * See {recover}.
69      */
70     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
71         // 32 is the length in bytes of hash,
72         // enforced by the type signature above
73         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
74     }
75 }
76 
77 library Uint256 {
78 
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "addition overflow");
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(a >= b, "subtraction overflow");
87         return a - b;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94         uint256 c = a * b;
95         require(c / a == b, "multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0, "division by 0");
101         return a / b;
102     }
103 
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "modulo by 0");
106         return a % b;
107     }
108 
109     function toString(uint256 a) internal pure returns (string memory) {
110         bytes32 retBytes32;
111         uint256 len = 0;
112         if (a == 0) {
113             retBytes32 = "0";
114             len++;
115         } else {
116             uint256 value = a;
117             while (value > 0) {
118                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
119                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
120                 value /= 10;
121                 len++;
122             }
123         }
124 
125         bytes memory ret = new bytes(len);
126         uint256 i;
127 
128         for (i = 0; i < len; i++) {
129             ret[i] = retBytes32[i];
130         }
131         return string(ret);
132     }
133 }
134 
135 library Roles {
136     struct Role {
137         mapping (address => bool) bearer;
138     }
139 
140     function add(Role storage role, address account) internal {
141         require(!has(role, account), "role already has the account");
142         role.bearer[account] = true;
143     }
144 
145     function remove(Role storage role, address account) internal {
146         require(has(role, account), "role dosen't have the account");
147         role.bearer[account] = false;
148     }
149 
150     function has(Role storage role, address account) internal view returns (bool) {
151         return role.bearer[account];
152     }
153 }
154 
155 interface IERC165 {
156     function supportsInterface(bytes4 interfaceID) external view returns (bool);
157 }
158 
159 /// @title ERC-165 Standard Interface Detection
160 /// @dev See https://eips.ethereum.org/EIPS/eip-165
161 contract ERC165 is IERC165 {
162     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
163     mapping(bytes4 => bool) private _supportedInterfaces;
164 
165     constructor () internal {
166         _registerInterface(_INTERFACE_ID_ERC165);
167     }
168 
169     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
170         return _supportedInterfaces[interfaceId];
171     }
172 
173     function _registerInterface(bytes4 interfaceId) internal {
174         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
175         _supportedInterfaces[interfaceId] = true;
176     }
177 }
178 
179 contract Withdrawable {
180     using Roles for Roles.Role;
181 
182     event WithdrawerAdded(address indexed account);
183     event WithdrawerRemoved(address indexed account);
184 
185     Roles.Role private withdrawers;
186 
187     constructor() public {
188         withdrawers.add(msg.sender);
189     }
190 
191     modifier onlyWithdrawer() {
192         require(isWithdrawer(msg.sender), "Must be withdrawer");
193         _;
194     }
195 
196     function isWithdrawer(address account) public view returns (bool) {
197         return withdrawers.has(account);
198     }
199 
200     function addWithdrawer(address account) public onlyWithdrawer() {
201         withdrawers.add(account);
202         emit WithdrawerAdded(account);
203     }
204 
205     function removeWithdrawer(address account) public onlyWithdrawer() {
206         withdrawers.remove(account);
207         emit WithdrawerRemoved(account);
208     }
209 
210     function withdrawEther() public onlyWithdrawer() {
211         msg.sender.transfer(address(this).balance);
212     }
213 
214 }
215 
216 interface IERC173 /* is ERC165 */ {
217     /// @dev This emits when ownership of a contract changes.
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /// @notice Get the address of the owner
221     /// @return The address of the owner.
222     function owner() external view returns (address);
223 
224     /// @notice Set the address of the new owner of the contract
225     /// @param _newOwner The address of the new owner of the contract
226     function transferOwnership(address _newOwner) external;
227 }
228 
229 contract ERC173 is IERC173, ERC165  {
230     address private _owner;
231 
232     constructor() public {
233         _registerInterface(0x7f5828d0);
234         _transferOwnership(msg.sender);
235     }
236 
237     modifier onlyOwner() {
238         require(msg.sender == owner(), "Must be owner");
239         _;
240     }
241 
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     function transferOwnership(address _newOwner) public onlyOwner() {
247         _transferOwnership(_newOwner);
248     }
249 
250     function _transferOwnership(address _newOwner) internal {
251         address previousOwner = owner();
252 	_owner = _newOwner;
253         emit OwnershipTransferred(previousOwner, _newOwner);
254     }
255 }
256 
257 contract Operatable is ERC173 {
258     using Roles for Roles.Role;
259 
260     event OperatorAdded(address indexed account);
261     event OperatorRemoved(address indexed account);
262 
263     event Paused(address account);
264     event Unpaused(address account);
265 
266     bool private _paused;
267     Roles.Role private operators;
268 
269     constructor() public {
270         operators.add(msg.sender);
271         _paused = false;
272     }
273 
274     modifier onlyOperator() {
275         require(isOperator(msg.sender), "Must be operator");
276         _;
277     }
278 
279     modifier whenNotPaused() {
280         require(!_paused, "Pausable: paused");
281         _;
282     }
283 
284     modifier whenPaused() {
285         require(_paused, "Pausable: not paused");
286         _;
287     }
288 
289     function transferOwnership(address _newOwner) public onlyOperator() {
290         _transferOwnership(_newOwner);
291     }
292 
293     function isOperator(address account) public view returns (bool) {
294         return operators.has(account);
295     }
296 
297     function addOperator(address account) public onlyOperator() {
298         operators.add(account);
299         emit OperatorAdded(account);
300     }
301 
302     function removeOperator(address account) public onlyOperator() {
303         operators.remove(account);
304         emit OperatorRemoved(account);
305     }
306 
307     function paused() public view returns (bool) {
308         return _paused;
309     }
310 
311     function pause() public onlyOperator() whenNotPaused() {
312         _paused = true;
313         emit Paused(msg.sender);
314     }
315 
316     function unpause() public onlyOperator() whenPaused() {
317         _paused = false;
318         emit Unpaused(msg.sender);
319     }
320 
321 }
322 
323 interface LandSectorAsset {
324     function getTotalVolume(uint16 _landType) external view returns (uint256);
325 }
326 
327 interface MCHLandPool {
328     function addEthToLandPool(uint16 _landType, address _purchaseBy) external payable;
329 }
330 
331 interface IngameMoney {
332     function hashTransactedAt(bytes32 _hash) external view returns(uint256);
333     function buy(address payable _user, address payable _referrer, uint256 _referralBasisPoint, bytes calldata _signature, bytes32 _hash)
334         external
335         payable;
336 }
337 
338 contract MCHGUMGatewayV11 is Operatable, Withdrawable {
339     using Uint256 for uint256;
340     struct Campaign {
341         uint8 purchaseType;
342         uint8 subPurchaseType;
343         uint8 proxyPurchaseType;
344     }
345 
346     uint8 constant PURCHASE_NORMAL = 0;
347     uint8 constant PURCHASE_ETH_BACK = 1;
348     uint8 constant PURCHASE_UP20 = 2;
349     uint8 constant PURCHASE_REGULAR = 3;
350     uint8 constant PURCHASE_ETH_BACK_UP20 = 4;
351 
352     Campaign public campaign;
353 
354     mapping(uint256 => bool) public payableOptions;
355     address public validater;
356 
357     LandSectorAsset public landSectorAsset;
358     MCHLandPool public landPool;
359     uint256 public landBasisPoint;
360 
361     uint256 constant BASE = 10000;
362     uint256 private nonce;
363     uint16 public chanceDenom;
364     uint256 public ethBackBasisPoint;
365     bytes private salt;
366     mapping(bytes32 => uint256) public hashTransactedAt;
367 
368     event Sold(
369         address indexed user,
370         address indexed referrer,
371         uint8 purchaseType,
372         uint256 grossValue,
373         uint256 referralValue,
374         uint256 landValue,
375         uint256 netValue,
376         uint16 indexed landType
377     );
378 
379     event CampaignUpdated(
380         uint8 purchaseType,
381         uint8 subPurchaseType,
382         uint8 proxyPurchaseType
383     );
384 
385     event LandBasisPointUpdated(
386         uint256 landBasisPoint
387     );
388 
389     constructor(
390         address _validater,
391         address _landSectorAssetAddress,
392         address payable _landPoolAddress
393     ) public payable {
394         setValidater(_validater);
395         setLandSectorAssetAddress(_landSectorAssetAddress);
396         setLandPoolAddress(_landPoolAddress);
397         setCampaign(0, 0, 0);
398         updateLandBasisPoint(3000);
399         updateEthBackBasisPoint(5000);
400         updateChance(25);
401         salt = bytes("iiNg4uJulaa4Yoh7");
402 
403         nonce = 222;
404 
405         // payableOptions[0] = true;
406         payableOptions[0.03 ether] = true;
407         payableOptions[0.05 ether] = true;
408         payableOptions[0.1 ether] = true;
409         payableOptions[0.5 ether] = true;
410         payableOptions[1 ether] = true;
411         payableOptions[5 ether] = true;
412         payableOptions[10 ether] = true;
413     }
414 
415     function setValidater(address _varidater) public onlyOperator() {
416         validater = _varidater;
417     }
418 
419     function setPayableOption(uint256 _option, bool desired) external onlyOperator() {
420         payableOptions[_option] = desired;
421     }
422 
423     function setCampaign(
424         uint8 _purchaseType,
425         uint8 _subPurchaseType,
426         uint8 _proxyPurchaseType
427     )
428         public
429         onlyOperator()
430     {
431         campaign = Campaign(_purchaseType, _subPurchaseType, _proxyPurchaseType);
432         emit CampaignUpdated(_purchaseType, _subPurchaseType, _proxyPurchaseType);
433     }
434 
435     function setLandSectorAssetAddress(address _landSectorAssetAddress) public onlyOwner() {
436         landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
437     }
438 
439     function setLandPoolAddress(address payable _landPoolAddress) public onlyOwner() {
440         landPool = MCHLandPool(_landPoolAddress);
441     }
442 
443     function updateLandBasisPoint(uint256 _newLandBasisPoint) public onlyOwner() {
444         landBasisPoint = _newLandBasisPoint;
445         emit LandBasisPointUpdated(
446             landBasisPoint
447         );
448     }
449 
450     function updateChance(uint16 _newchanceDenom) public onlyOperator() {
451         chanceDenom = _newchanceDenom;
452     }
453 
454     function updateEthBackBasisPoint(uint256 _ethBackBasisPoint) public onlyOperator() {
455         ethBackBasisPoint = _ethBackBasisPoint;
456     }
457 
458     function buy(
459         address payable _user,
460         address payable _referrer,
461         uint256 _referralBasisPoint,
462         uint16 _landType,
463         bytes memory _signature,
464         bytes32 _hash
465     )
466         public
467         payable
468         whenNotPaused()
469     {
470         require(_referralBasisPoint + ethBackBasisPoint + landBasisPoint <= BASE, "Invalid basis points");
471         require(payableOptions[msg.value], "Invalid msg.value");
472         require(validateSig(encodeData(_user, _referrer, _referralBasisPoint, _landType), _signature), "Invalid signature");
473         if (_hash != bytes32(0)) {
474             recordHash(_hash);
475         }
476         uint8 purchaseType = campaign.proxyPurchaseType;
477         uint256 netValue = msg.value;
478         uint256 referralValue = _referrerBack(_referrer, _referralBasisPoint);
479         uint256 landValue = _landPoolBack(_landType);
480         netValue = msg.value.sub(referralValue).sub(landValue);
481 
482         emit Sold(
483             _user,
484             _referrer,
485             purchaseType,
486             msg.value,
487             referralValue,
488             landValue,
489             netValue,
490             _landType
491         );
492     }
493 
494     function buyGUM(
495         address payable _referrer,
496         uint256 _referralBasisPoint,
497         uint16 _landType,
498         bytes memory _signature
499     )
500         public
501         payable
502     {
503         require(_referralBasisPoint + ethBackBasisPoint + landBasisPoint <= BASE, "Invalid basis points");
504         require(payableOptions[msg.value], "Invalid msg.value");
505         require(validateSig(encodeData(msg.sender, _referrer, _referralBasisPoint, _landType), _signature), "Invalid signature");
506 
507         uint8 purchaseType = campaign.purchaseType;
508         uint256 netValue = msg.value;
509         uint256 referralValue = 0;
510         uint256 landValue = 0;
511 
512         if (purchaseType == PURCHASE_ETH_BACK || purchaseType == PURCHASE_ETH_BACK_UP20) {
513             if (getRandom(chanceDenom, nonce, msg.sender) == 0) {
514                 uint256 ethBackValue = _ethBack(msg.sender, ethBackBasisPoint);
515                 netValue = netValue.sub(ethBackValue);
516             } else {
517                 purchaseType = campaign.subPurchaseType;
518                 referralValue = _referrerBack(_referrer, _referralBasisPoint);
519                 landValue = _landPoolBack(_landType);
520                 netValue = msg.value.sub(referralValue).sub(landValue);
521             }
522             nonce++;
523         } else {
524             referralValue = _referrerBack(_referrer, _referralBasisPoint);
525             landValue = _landPoolBack(_landType);
526             netValue = msg.value.sub(referralValue).sub(landValue);
527         }
528 
529         emit Sold(
530             msg.sender,
531             _referrer,
532             purchaseType,
533             msg.value,
534             referralValue,
535             landValue,
536             netValue,
537             _landType
538         );
539     }
540 
541     function recordHash(bytes32 _hash) internal {
542         require(hashTransactedAt[_hash] == 0, "The hash is already transacted");
543         hashTransactedAt[_hash] = block.number;
544     }
545 
546     function getRandom(uint16 max, uint256 _nonce, address _sender) public view returns (uint16) {
547         return uint16(
548             bytes2(
549                 keccak256(
550                     abi.encodePacked(
551                         blockhash(block.number-1),
552                         _sender,
553                         _nonce,
554                         salt
555                     )
556                 )
557             )
558         ) % max;
559     }
560 
561     function _ethBack(address payable _buyer, uint256 _ethBackBasisPoint) internal returns (uint256) {
562         uint256 ethBackValue = msg.value.mul(_ethBackBasisPoint).div(BASE);
563         _buyer.transfer(ethBackValue);
564         return ethBackValue;
565     }
566 
567     function _landPoolBack(uint16 _landType) internal returns (uint256) {
568         if(_landType == 0) {
569             return 0;
570         }
571         require(landSectorAsset.getTotalVolume(_landType) != 0, "Invalid _landType");
572 
573         uint256 landValue;
574         landValue = msg.value.mul(landBasisPoint).div(BASE);
575         landPool.addEthToLandPool.value(landValue)(_landType, msg.sender);
576         return landValue;
577     }
578 
579     function _referrerBack(address payable _referrer, uint256 _referralBasisPoint) internal returns (uint256) {
580         if(_referrer == address(0x0) || _referrer == msg.sender) {
581             return 0;
582         }
583         uint256 referralValue = msg.value.mul(_referralBasisPoint).div(BASE);
584         _referrer.transfer(referralValue);
585         return referralValue;
586     }
587 
588     function encodeData(address _sender, address _referrer, uint256 _referralBasisPoint, uint16 _landType) public pure returns (bytes32) {
589         return keccak256(abi.encode(
590                             _sender,
591                             _referrer,
592                             _referralBasisPoint,
593                             _landType
594                             )
595                     );
596     }
597 
598     function validateSig(bytes32 _message, bytes memory _signature) public view returns (bool) {
599         require(validater != address(0), "validater must be set");
600         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
601         return (signer == validater);
602     }
603 
604     function recover(bytes32 _message, bytes memory _signature) public pure returns (address) {
605         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
606         return signer;
607     }
608 }
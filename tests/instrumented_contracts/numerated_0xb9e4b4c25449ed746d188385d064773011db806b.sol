1 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
7  *
8  * These functions can be used to verify that a message was signed by the holder
9  * of the private keys of a given address.
10  */
11 library ECDSA {
12     /**
13      * @dev Returns the address that signed a hashed message (`hash`) with
14      * `signature`. This address can then be used for verification purposes.
15      *
16      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
17      * this function rejects them by requiring the `s` value to be in the lower
18      * half order, and the `v` value to be either 27 or 28.
19      *
20      * NOTE: This call _does not revert_ if the signature is invalid, or
21      * if the signer is otherwise unable to be retrieved. In those scenarios,
22      * the zero address is returned.
23      *
24      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
25      * verification to be secure: it is possible to craft signatures that
26      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
27      * this is by receiving a hash of the original message (which may otherwise
28      * be too long), and then calling {toEthSignedMessageHash} on it.
29      */
30     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
31         // Check the signature length
32         if (signature.length != 65) {
33             return (address(0));
34         }
35 
36         // Divide the signature in r, s and v variables
37         bytes32 r;
38         bytes32 s;
39         uint8 v;
40 
41         // ecrecover takes the signature parameters, and the only way to get them
42         // currently is to use assembly.
43         // solhint-disable-next-line no-inline-assembly
44         assembly {
45             r := mload(add(signature, 0x20))
46             s := mload(add(signature, 0x40))
47             v := byte(0, mload(add(signature, 0x60)))
48         }
49 
50         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
51         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
52         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
53         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
54         //
55         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
56         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
57         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
58         // these malleable signatures as well.
59         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
60             return address(0);
61         }
62 
63         if (v != 27 && v != 28) {
64             return address(0);
65         }
66 
67         // If the signature is valid (and not malleable), return the signer address
68         return ecrecover(hash, v, r, s);
69     }
70 
71     /**
72      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
73      * replicates the behavior of the
74      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
75      * JSON-RPC method.
76      *
77      * See {recover}.
78      */
79     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
80         // 32 is the length in bytes of hash,
81         // enforced by the type signature above
82         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
83     }
84 }
85 
86 // File: contracts/roles/Roles.sol
87 
88 pragma solidity ^0.5.0;
89 
90 library Roles {
91     struct Role {
92         mapping (address => bool) bearer;
93     }
94 
95     function add(Role storage role, address account) internal {
96         require(!has(role, account), "role already has the account");
97         role.bearer[account] = true;
98     }
99 
100     function remove(Role storage role, address account) internal {
101         require(has(role, account), "role dosen't have the account");
102         role.bearer[account] = false;
103     }
104 
105     function has(Role storage role, address account) internal view returns (bool) {
106         return role.bearer[account];
107     }
108 }
109 
110 // File: contracts/erc/ERC165.sol
111 
112 pragma solidity ^0.5.0;
113 
114 interface IERC165 {
115     function supportsInterface(bytes4 interfaceID) external view returns (bool);
116 }
117 
118 /// @title ERC-165 Standard Interface Detection
119 /// @dev See https://eips.ethereum.org/EIPS/eip-165
120 contract ERC165 is IERC165 {
121     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
122     mapping(bytes4 => bool) private _supportedInterfaces;
123 
124     constructor () internal {
125         _registerInterface(_INTERFACE_ID_ERC165);
126     }
127 
128     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
129         return _supportedInterfaces[interfaceId];
130     }
131 
132     function _registerInterface(bytes4 interfaceId) internal {
133         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
134         _supportedInterfaces[interfaceId] = true;
135     }
136 }
137 
138 // File: contracts/erc/ERC173.sol
139 
140 pragma solidity ^0.5.0;
141 
142 
143 /// @title ERC-173 Contract Ownership Standard
144 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
145 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
146 interface IERC173 /* is ERC165 */ {
147     /// @dev This emits when ownership of a contract changes.
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     /// @notice Get the address of the owner
151     /// @return The address of the owner.
152     function owner() external view returns (address);
153 
154     /// @notice Set the address of the new owner of the contract
155     /// @param _newOwner The address of the new owner of the contract
156     function transferOwnership(address _newOwner) external;
157 }
158 
159 contract ERC173 is IERC173, ERC165  {
160     address private _owner;
161 
162     constructor() public {
163         _registerInterface(0x7f5828d0);
164         _transferOwnership(msg.sender);
165     }
166 
167     modifier onlyOwner() {
168         require(msg.sender == owner(), "Must be owner");
169         _;
170     }
171 
172     function owner() public view returns (address) {
173         return _owner;
174     }
175 
176     function transferOwnership(address _newOwner) public onlyOwner() {
177         _transferOwnership(_newOwner);
178     }
179 
180     function _transferOwnership(address _newOwner) internal {
181         address previousOwner = owner();
182 	_owner = _newOwner;
183         emit OwnershipTransferred(previousOwner, _newOwner);
184     }
185 }
186 
187 // File: contracts/roles/Operatable.sol
188 
189 pragma solidity ^0.5.0;
190 
191 
192 
193 contract Operatable is ERC173 {
194     using Roles for Roles.Role;
195 
196     event OperatorAdded(address indexed account);
197     event OperatorRemoved(address indexed account);
198 
199     event Paused(address account);
200     event Unpaused(address account);
201 
202     bool private _paused;
203     Roles.Role private operators;
204 
205     constructor() public {
206         operators.add(msg.sender);
207         _paused = false;
208     }
209 
210     modifier onlyOperator() {
211         require(isOperator(msg.sender), "Must be operator");
212         _;
213     }
214 
215     modifier whenNotPaused() {
216         require(!_paused, "Pausable: paused");
217         _;
218     }
219 
220     modifier whenPaused() {
221         require(_paused, "Pausable: not paused");
222         _;
223     }
224 
225     function transferOwnership(address _newOwner) public onlyOperator() {
226         _transferOwnership(_newOwner);
227     }
228 
229     function isOperator(address account) public view returns (bool) {
230         return operators.has(account);
231     }
232 
233     function addOperator(address account) public onlyOperator() {
234         operators.add(account);
235         emit OperatorAdded(account);
236     }
237 
238     function removeOperator(address account) public onlyOperator() {
239         operators.remove(account);
240         emit OperatorRemoved(account);
241     }
242 
243     function paused() public view returns (bool) {
244         return _paused;
245     }
246 
247     function pause() public onlyOperator() whenNotPaused() {
248         _paused = true;
249         emit Paused(msg.sender);
250     }
251 
252     function unpause() public onlyOperator() whenPaused() {
253         _paused = false;
254         emit Unpaused(msg.sender);
255     }
256 
257 }
258 
259 // File: contracts/roles/Withdrawable.sol
260 
261 pragma solidity ^0.5.0;
262 
263 
264 contract Withdrawable {
265     using Roles for Roles.Role;
266 
267     event WithdrawerAdded(address indexed account);
268     event WithdrawerRemoved(address indexed account);
269 
270     Roles.Role private withdrawers;
271 
272     constructor() public {
273         withdrawers.add(msg.sender);
274     }
275 
276     modifier onlyWithdrawer() {
277         require(isWithdrawer(msg.sender), "Must be withdrawer");
278         _;
279     }
280 
281     function isWithdrawer(address account) public view returns (bool) {
282         return withdrawers.has(account);
283     }
284 
285     function addWithdrawer(address account) public onlyWithdrawer() {
286         withdrawers.add(account);
287         emit WithdrawerAdded(account);
288     }
289 
290     function removeWithdrawer(address account) public onlyWithdrawer() {
291         withdrawers.remove(account);
292         emit WithdrawerRemoved(account);
293     }
294 
295     function withdrawEther() public onlyWithdrawer() {
296         msg.sender.transfer(address(this).balance);
297     }
298 
299 }
300 
301 // File: contracts/libraries/Uint256.sol
302 
303 pragma solidity ^0.5.0;
304 
305 library Uint256 {
306 
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         uint256 c = a + b;
309         require(c >= a, "addition overflow");
310         return c;
311     }
312 
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(a >= b, "subtraction overflow");
315         return a - b;
316     }
317 
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         if (a == 0) {
320             return 0;
321         }
322         uint256 c = a * b;
323         require(c / a == b, "multiplication overflow");
324         return c;
325     }
326 
327     function div(uint256 a, uint256 b) internal pure returns (uint256) {
328         require(b != 0, "division by 0");
329         return a / b;
330     }
331 
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         require(b != 0, "modulo by 0");
334         return a % b;
335     }
336 
337     function toString(uint256 a) internal pure returns (string memory) {
338         bytes32 retBytes32;
339         uint256 len = 0;
340         if (a == 0) {
341             retBytes32 = "0";
342             len++;
343         } else {
344             uint256 value = a;
345             while (value > 0) {
346                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
347                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
348                 value /= 10;
349                 len++;
350             }
351         }
352 
353         bytes memory ret = new bytes(len);
354         uint256 i;
355 
356         for (i = 0; i < len; i++) {
357             ret[i] = retBytes32[i];
358         }
359         return string(ret);
360     }
361 }
362 
363 // File: contracts/SPLSPLGatewayV1.sol
364 
365 pragma solidity 0.5.17;
366 
367 
368 
369 
370 
371 interface GuildAsset {
372     function getTotalVolume(uint16 _guildType) external view returns (uint256);
373 }
374 
375 interface SPLGuildPool {
376     function addEthToGuildPool(uint16 _guildType, address _purchaseBy) external payable;
377 }
378 
379 interface IngameMoney {
380     function hashTransactedAt(bytes32 _hash) external view returns(uint256);
381     function buy(address payable _user, address payable _referrer, uint256 _referralBasisPoint, uint16 _guildType, bytes calldata _signature, bytes32 _hash) external payable;
382 }
383 
384 contract SPLSPLGatewayV1 is Operatable, Withdrawable, IngameMoney {
385     using Uint256 for uint256;
386     struct Campaign {
387         uint8 purchaseType;
388         uint8 subPurchaseType;
389         uint8 proxyPurchaseType;
390     }
391 
392     uint8 constant PURCHASE_NORMAL = 0;
393     uint8 constant PURCHASE_ETH_BACK = 1;
394     uint8 constant PURCHASE_UP20 = 2;
395     uint8 constant PURCHASE_REGULAR = 3;
396     uint8 constant PURCHASE_ETH_BACK_UP20 = 4;
397 
398     Campaign public campaign;
399 
400     mapping(uint256 => bool) public payableOptions;
401     address public validater;
402 
403     GuildAsset public guildAsset;
404     SPLGuildPool public guildPool;
405     uint256 public guildBasisPoint;
406 
407     uint256 constant BASE = 10000;
408     uint256 private nonce;
409     uint16 public chanceDenom;
410     uint256 public ethBackBasisPoint;
411     bytes private salt;
412     mapping(bytes32 => uint256) private _hashTransactedAt;
413 
414     event Sold(
415         address indexed user,
416         address indexed referrer,
417         uint8 purchaseType,
418         uint256 grossValue,
419         uint256 referralValue,
420         uint256 guildValue,
421         uint256 netValue,
422         uint16 indexed guildType
423     );
424 
425     event CampaignUpdated(
426         uint8 purchaseType,
427         uint8 subPurchaseType,
428         uint8 proxyPurchaseType
429     );
430 
431     event GuildBasisPointUpdated(
432         uint256 guildBasisPoint
433     );
434 
435     constructor(
436         address _validater,
437         address _guildAssetAddress,
438         address payable _guildPoolAddress
439     ) public payable {
440         setValidater(_validater);
441         setGuildAssetAddress(_guildAssetAddress);
442         setGuildPoolAddress(_guildPoolAddress);
443         setCampaign(0, 0, 0);
444         updateGuildBasisPoint(1500);
445         updateEthBackBasisPoint(5000);
446         updateChance(25);
447         salt = bytes("iiNg4uJulaa4Yoh7");
448 
449         nonce = 222;
450 
451         // payableOptions[0] = true;
452         payableOptions[0.03 ether] = true;
453         payableOptions[0.05 ether] = true;
454         payableOptions[0.1 ether] = true;
455         payableOptions[0.5 ether] = true;
456         payableOptions[1 ether] = true;
457         payableOptions[5 ether] = true;
458         payableOptions[10 ether] = true;
459     }
460 
461     function setValidater(address _varidater) public onlyOperator() {
462         validater = _varidater;
463     }
464 
465     function setPayableOption(uint256 _option, bool desired) external onlyOperator() {
466         payableOptions[_option] = desired;
467     }
468 
469     function setCampaign(
470         uint8 _purchaseType,
471         uint8 _subPurchaseType,
472         uint8 _proxyPurchaseType
473     )
474         public
475         onlyOperator()
476     {
477         campaign = Campaign(_purchaseType, _subPurchaseType, _proxyPurchaseType);
478         emit CampaignUpdated(_purchaseType, _subPurchaseType, _proxyPurchaseType);
479     }
480 
481     function setGuildAssetAddress(address _guildAssetAddress) public onlyOwner() {
482         guildAsset = GuildAsset(_guildAssetAddress);
483     }
484 
485     function setGuildPoolAddress(address payable _guildPoolAddress) public onlyOwner() {
486         guildPool = SPLGuildPool(_guildPoolAddress);
487     }
488 
489     function updateGuildBasisPoint(uint256 _newGuildBasisPoint) public onlyOwner() {
490         guildBasisPoint = _newGuildBasisPoint;
491         emit GuildBasisPointUpdated(
492             guildBasisPoint
493         );
494     }
495 
496     function updateChance(uint16 _newchanceDenom) public onlyOperator() {
497         chanceDenom = _newchanceDenom;
498     }
499 
500     function updateEthBackBasisPoint(uint256 _ethBackBasisPoint) public onlyOperator() {
501         ethBackBasisPoint = _ethBackBasisPoint;
502     }
503 
504     function buy(
505         address payable _user,
506         address payable _referrer,
507         uint256 _referralBasisPoint,
508         uint16 _guildType,
509         bytes memory _signature,
510         bytes32 _hash
511     )
512         public
513         payable
514         whenNotPaused()
515     {
516         require(_referralBasisPoint + ethBackBasisPoint + guildBasisPoint <= BASE, "Invalid basis points");
517         require(payableOptions[msg.value], "Invalid msg.value");
518         require(validateSig(encodeData(_user, _referrer, _referralBasisPoint, _guildType), _signature), "Invalid signature");
519         if (_hash != bytes32(0)) {
520             recordHash(_hash);
521         }
522         uint8 purchaseType = campaign.proxyPurchaseType;
523         uint256 netValue = msg.value;
524         uint256 referralValue = _referrerBack(_referrer, _referralBasisPoint);
525         uint256 guildValue = _guildPoolBack(_guildType);
526         netValue = msg.value.sub(referralValue).sub(guildValue);
527 
528         emit Sold(
529             _user,
530             _referrer,
531             purchaseType,
532             msg.value,
533             referralValue,
534             guildValue,
535             netValue,
536             _guildType
537         );
538     }
539 
540     function buySPL(
541         address payable _referrer,
542         uint256 _referralBasisPoint,
543         uint16 _guildType,
544         bytes memory _signature
545     )
546         public
547         payable
548     {
549         require(_referralBasisPoint + ethBackBasisPoint + guildBasisPoint <= BASE, "Invalid basis points");
550         require(payableOptions[msg.value], "Invalid msg.value");
551         require(validateSig(encodeData(msg.sender, _referrer, _referralBasisPoint, _guildType), _signature), "Invalid signature");
552 
553         uint8 purchaseType = campaign.purchaseType;
554         uint256 netValue = msg.value;
555         uint256 referralValue = 0;
556         uint256 guildValue = 0;
557 
558         if (purchaseType == PURCHASE_ETH_BACK || purchaseType == PURCHASE_ETH_BACK_UP20) {
559             if (getRandom(chanceDenom, nonce, msg.sender) == 0) {
560                 uint256 ethBackValue = _ethBack(msg.sender, ethBackBasisPoint);
561                 netValue = netValue.sub(ethBackValue);
562             } else {
563                 purchaseType = campaign.subPurchaseType;
564                 referralValue = _referrerBack(_referrer, _referralBasisPoint);
565                 guildValue = _guildPoolBack(_guildType);
566                 netValue = msg.value.sub(referralValue).sub(guildValue);
567             }
568             nonce++;
569         } else {
570             referralValue = _referrerBack(_referrer, _referralBasisPoint);
571             guildValue = _guildPoolBack(_guildType);
572             netValue = msg.value.sub(referralValue).sub(guildValue);
573         }
574 
575         emit Sold(
576             msg.sender,
577             _referrer,
578             purchaseType,
579             msg.value,
580             referralValue,
581             guildValue,
582             netValue,
583             _guildType
584         );
585     }
586 
587     function hashTransactedAt(bytes32 _hash) public view returns (uint256) {
588         return _hashTransactedAt[_hash];
589     }
590 
591     function recordHash(bytes32 _hash) internal {
592         require(_hashTransactedAt[_hash] == 0, "The hash is already transacted");
593         _hashTransactedAt[_hash] = block.number;
594     }
595 
596     function getRandom(uint16 max, uint256 _nonce, address _sender) public view returns (uint16) {
597         return uint16(
598             bytes2(
599                 keccak256(
600                     abi.encodePacked(
601                         blockhash(block.number-1),
602                         _sender,
603                         _nonce,
604                         salt
605                     )
606                 )
607             )
608         ) % max;
609     }
610 
611     function _ethBack(address payable _buyer, uint256 _ethBackBasisPoint) internal returns (uint256) {
612         uint256 ethBackValue = msg.value.mul(_ethBackBasisPoint).div(BASE);
613         _buyer.transfer(ethBackValue);
614         return ethBackValue;
615     }
616 
617     function _guildPoolBack(uint16 _guildType) internal returns (uint256) {
618         if(_guildType == 0) {
619             return 0;
620         }
621         require(guildAsset.getTotalVolume(_guildType) != 0, "Invalid _guildType");
622 
623         uint256 guildValue;
624         guildValue = msg.value.mul(guildBasisPoint).div(BASE);
625         guildPool.addEthToGuildPool.value(guildValue)(_guildType, msg.sender);
626         return guildValue;
627     }
628 
629     function _referrerBack(address payable _referrer, uint256 _referralBasisPoint) internal returns (uint256) {
630         if(_referrer == address(0x0) || _referrer == msg.sender) {
631             return 0;
632         }
633         uint256 referralValue = msg.value.mul(_referralBasisPoint).div(BASE);
634         _referrer.transfer(referralValue);
635         return referralValue;
636     }
637 
638     function encodeData(address _sender, address _referrer, uint256 _referralBasisPoint, uint16 _guildType) public pure returns (bytes32) {
639         return keccak256(abi.encode(
640                             _sender,
641                             _referrer,
642                             _referralBasisPoint,
643                             _guildType
644                             )
645                     );
646     }
647 
648     function validateSig(bytes32 _message, bytes memory _signature) public view returns (bool) {
649         require(validater != address(0), "validater must be set");
650         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
651         return (signer == validater);
652     }
653 
654     function recover(bytes32 _message, bytes memory _signature) public pure returns (address) {
655         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
656         return signer;
657     }
658 }
1 pragma solidity ^0.4.24;
2 
3 // File: libs/EC.sol
4 
5 contract EC {
6 
7     uint256 constant public gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
8     uint256 constant public gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
9     uint256 constant public n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
10     uint256 constant public a = 0;
11     uint256 constant public b = 7;
12 
13     function _jAdd(
14         uint256 x1, uint256 z1,
15         uint256 x2, uint256 z2)
16         public 
17         pure
18         returns(uint256 x3, uint256 z3)
19     {
20         (x3, z3) = (
21             addmod(
22                 mulmod(z2, x1, n),
23                 mulmod(x2, z1, n),
24                 n
25             ),
26             mulmod(z1, z2, n)
27         );
28     }
29 
30     function _jSub(
31         uint256 x1, uint256 z1,
32         uint256 x2, uint256 z2)
33         public 
34         pure
35         returns(uint256 x3, uint256 z3)
36     {
37         (x3, z3) = (
38             addmod(
39                 mulmod(z2, x1, n),
40                 mulmod(n - x2, z1, n),
41                 n
42             ),
43             mulmod(z1, z2, n)
44         );
45     }
46 
47     function _jMul(
48         uint256 x1, uint256 z1,
49         uint256 x2, uint256 z2)
50         public 
51         pure
52         returns(uint256 x3, uint256 z3)
53     {
54         (x3, z3) = (
55             mulmod(x1, x2, n),
56             mulmod(z1, z2, n)
57         );
58     }
59 
60     function _jDiv(
61         uint256 x1, uint256 z1,
62         uint256 x2, uint256 z2) 
63         public 
64         pure
65         returns(uint256 x3, uint256 z3)
66     {
67         (x3, z3) = (
68             mulmod(x1, z2, n),
69             mulmod(z1, x2, n)
70         );
71     }
72 
73     function _inverse(uint256 val) public pure
74         returns(uint256 invVal)
75     {
76         uint256 t = 0;
77         uint256 newT = 1;
78         uint256 r = n;
79         uint256 newR = val;
80         uint256 q;
81         while (newR != 0) {
82             q = r / newR;
83 
84             (t, newT) = (newT, addmod(t, (n - mulmod(q, newT, n)), n));
85             (r, newR) = (newR, r - q * newR );
86         }
87 
88         return t;
89     }
90 
91     function _ecAdd(
92         uint256 x1, uint256 y1, uint256 z1,
93         uint256 x2, uint256 y2, uint256 z2) 
94         public 
95         pure
96         returns(uint256 x3, uint256 y3, uint256 z3)
97     {
98         uint256 lx;
99         uint256 lz;
100         uint256 da;
101         uint256 db;
102 
103         if (x1 == 0 && y1 == 0) {
104             return (x2, y2, z2);
105         }
106 
107         if (x2 == 0 && y2 == 0) {
108             return (x1, y1, z1);
109         }
110 
111         if (x1 == x2 && y1 == y2) {
112             (lx, lz) = _jMul(x1, z1, x1, z1);
113             (lx, lz) = _jMul(lx, lz, 3, 1);
114             (lx, lz) = _jAdd(lx, lz, a, 1);
115 
116             (da,db) = _jMul(y1, z1, 2, 1);
117         } else {
118             (lx, lz) = _jSub(y2, z2, y1, z1);
119             (da, db) = _jSub(x2, z2, x1, z1);
120         }
121 
122         (lx, lz) = _jDiv(lx, lz, da, db);
123 
124         (x3, da) = _jMul(lx, lz, lx, lz);
125         (x3, da) = _jSub(x3, da, x1, z1);
126         (x3, da) = _jSub(x3, da, x2, z2);
127 
128         (y3, db) = _jSub(x1, z1, x3, da);
129         (y3, db) = _jMul(y3, db, lx, lz);
130         (y3, db) = _jSub(y3, db, y1, z1);
131 
132         if (da != db) {
133             x3 = mulmod(x3, db, n);
134             y3 = mulmod(y3, da, n);
135             z3 = mulmod(da, db, n);
136         } else {
137             z3 = da;
138         }
139     }
140 
141     function _ecDouble(uint256 x1, uint256 y1, uint256 z1) public pure
142         returns(uint256 x3, uint256 y3, uint256 z3)
143     {
144         (x3, y3, z3) = _ecAdd(x1, y1, z1, x1, y1, z1);
145     }
146 
147     function _ecMul(uint256 d, uint256 x1, uint256 y1, uint256 z1) public pure
148         returns(uint256 x3, uint256 y3, uint256 z3)
149     {
150         uint256 remaining = d;
151         uint256 px = x1;
152         uint256 py = y1;
153         uint256 pz = z1;
154         uint256 acx = 0;
155         uint256 acy = 0;
156         uint256 acz = 1;
157 
158         if (d == 0) {
159             return (0, 0, 1);
160         }
161 
162         while (remaining != 0) {
163             if ((remaining & 1) != 0) {
164                 (acx,acy,acz) = _ecAdd(acx, acy, acz, px, py, pz);
165             }
166             remaining = remaining / 2;
167             (px, py, pz) = _ecDouble(px, py, pz);
168         }
169 
170         (x3, y3, z3) = (acx, acy, acz);
171     }
172 
173     function ecadd(
174         uint256 x1, uint256 y1,
175         uint256 x2, uint256 y2)
176         public
177         pure
178         returns(uint256 x3, uint256 y3)
179     {
180         uint256 z;
181         (x3, y3, z) = _ecAdd(x1, y1, 1, x2, y2, 1);
182         z = _inverse(z);
183         x3 = mulmod(x3, z, n);
184         y3 = mulmod(y3, z, n);
185     }
186 
187     function ecmul(uint256 x1, uint256 y1, uint256 scalar) public pure
188         returns(uint256 x2, uint256 y2)
189     {
190         uint256 z;
191         (x2, y2, z) = _ecMul(scalar, x1, y1, 1);
192         z = _inverse(z);
193         x2 = mulmod(x2, z, n);
194         y2 = mulmod(y2, z, n);
195     }
196 
197     function ecmulVerify(uint256 x1, uint256 y1, uint256 scalar, uint256 qx, uint256 qy) public pure
198         returns(bool)
199     {
200         uint256 m = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
201         address signer = ecrecover(0, y1 % 2 != 0 ? 28 : 27, bytes32(x1), bytes32(mulmod(scalar, x1, m)));
202         address xyAddress = address(uint256(keccak256(abi.encodePacked(qx, qy))) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
203         return xyAddress == signer;
204     }
205 
206     function publicKey(uint256 privKey) public pure
207         returns(uint256 qx, uint256 qy)
208     {
209         return ecmul(gx, gy, privKey);
210     }
211 
212     function publicKeyVerify(uint256 privKey, uint256 x, uint256 y) public pure
213         returns(bool)
214     {
215         return ecmulVerify(gx, gy, privKey, x, y);
216     }
217 
218     function deriveKey(uint256 privKey, uint256 pubX, uint256 pubY) public pure
219         returns(uint256 qx, uint256 qy)
220     {
221         uint256 z;
222         (qx, qy, z) = _ecMul(privKey, pubX, pubY, 1);
223         z = _inverse(z);
224         qx = mulmod(qx, z, n);
225         qy = mulmod(qy, z, n);
226     }
227 }
228 
229 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
230 
231 /**
232  * @title Ownable
233  * @dev The Ownable contract has an owner address, and provides basic authorization control
234  * functions, this simplifies the implementation of "user permissions".
235  */
236 contract Ownable {
237   address public owner;
238 
239 
240   event OwnershipRenounced(address indexed previousOwner);
241   event OwnershipTransferred(
242     address indexed previousOwner,
243     address indexed newOwner
244   );
245 
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   constructor() public {
252     owner = msg.sender;
253   }
254 
255   /**
256    * @dev Throws if called by any account other than the owner.
257    */
258   modifier onlyOwner() {
259     require(msg.sender == owner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to relinquish control of the contract.
265    * @notice Renouncing to ownership will leave the contract without an owner.
266    * It will not be possible to call the functions with the `onlyOwner`
267    * modifier anymore.
268    */
269   function renounceOwnership() public onlyOwner {
270     emit OwnershipRenounced(owner);
271     owner = address(0);
272   }
273 
274   /**
275    * @dev Allows the current owner to transfer control of the contract to a newOwner.
276    * @param _newOwner The address to transfer ownership to.
277    */
278   function transferOwnership(address _newOwner) public onlyOwner {
279     _transferOwnership(_newOwner);
280   }
281 
282   /**
283    * @dev Transfers control of the contract to a newOwner.
284    * @param _newOwner The address to transfer ownership to.
285    */
286   function _transferOwnership(address _newOwner) internal {
287     require(_newOwner != address(0));
288     emit OwnershipTransferred(owner, _newOwner);
289     owner = _newOwner;
290   }
291 }
292 
293 // File: contracts/Upgradable.sol
294 
295 contract IUpgradable {
296     function startUpgrade() public;
297     function endUpgrade() public;
298 }
299 
300 contract Upgradable is Ownable {
301     struct UpgradableState {
302         bool isUpgrading;
303         address prevVersion;
304         address nextVersion;
305     }
306 
307     UpgradableState public upgradableState;
308 
309     event Initialized(address indexed prevVersion);
310     event Upgrading(address indexed nextVersion);
311     event Upgraded(address indexed nextVersion);
312 
313     modifier isLastestVersion {
314         require(!upgradableState.isUpgrading);
315         require(upgradableState.nextVersion == address(0));
316         _;
317     }
318 
319     modifier onlyOwnerOrigin {
320         require(tx.origin == owner);
321         _;
322     }
323 
324     constructor(address _prevVersion) public {
325         if (_prevVersion != address(0)) {
326             require(msg.sender == Ownable(_prevVersion).owner());
327             upgradableState.isUpgrading = true;
328             upgradableState.prevVersion = _prevVersion;
329             IUpgradable(_prevVersion).startUpgrade();
330         } else {
331             emit Initialized(_prevVersion);
332         }
333     }
334 
335     function startUpgrade() public onlyOwnerOrigin {
336         require(msg.sender != owner);
337         require(!upgradableState.isUpgrading);
338         require(upgradableState.nextVersion == 0);
339         upgradableState.isUpgrading = true;
340         upgradableState.nextVersion = msg.sender;
341         emit Upgrading(msg.sender);
342     }
343 
344     //function upgrade(uint index, uint size) public onlyOwner {}
345 
346     function endUpgrade() public onlyOwnerOrigin {
347         require(upgradableState.isUpgrading);
348         upgradableState.isUpgrading = false;
349         if (msg.sender != owner) {
350             require(upgradableState.nextVersion == msg.sender);
351             emit Upgraded(upgradableState.nextVersion);
352         } 
353         else  {
354             if (upgradableState.prevVersion != address(0)) {
355                 Upgradable(upgradableState.prevVersion).endUpgrade();
356             }
357             emit Initialized(upgradableState.prevVersion);
358         }
359     }
360 }
361 
362 // File: contracts/VanityLib.sol
363 
364 contract VanityLib {
365     uint constant m = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
366 
367     function haveCommonPrefixUntilZero(bytes32 a, bytes32 b) public pure returns(bool) {
368         for (uint i = 0; i < 32; i++) {
369             if (a[i] == 0 || b[i] == 0) {
370                 return true;
371             }
372             if (a[i] != b[i]) {
373                 return false;
374             }
375         }
376         return true;
377     }
378     
379     function bytesToBytes32(bytes source) public pure returns(bytes32 result) {
380         assembly {
381             result := mload(add(source, 32))
382         }
383     }
384 
385     /* Converts given number to base58, limited by 32 symbols */
386     function toBase58Checked(uint256 _value, byte appCode) public pure returns(bytes32) {
387         string memory letters = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
388         bytes memory alphabet = bytes(letters);
389         uint8 base = 58;
390         uint8 len = 0;
391         uint256 remainder = 0;
392         bool needBreak = false;
393         bytes memory bytesReversed = bytes(new string(32));
394         
395         for (uint8 i = 0; true; i++) {
396             if (_value < base) {
397                 needBreak = true;
398             }
399             remainder = _value % base;
400             _value = uint256(_value / base);
401             if (len == 32) {
402                 for (uint j = 0; j < len - 1; j++) {
403                     bytesReversed[j] = bytesReversed[j + 1];
404                 }
405                 len--;
406             }
407             bytesReversed[len] = alphabet[remainder];
408             len++;
409             if (needBreak) {
410                 break;
411             }
412         }
413         
414         // Reverse
415         bytes memory result = bytes(new string(32));
416         result[0] = appCode;
417         for (i = 0; i < 31; i++) {
418             result[i + 1] = bytesReversed[len - 1 - i];
419         }
420         
421         return bytesToBytes32(result);
422     }
423 
424     // Create BTC Address: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses#How_to_create_Bitcoin_Address
425     function createBtcAddressHex(uint256 publicXPoint, uint256 publicYPoint) public pure returns(uint256) {
426         bytes20 publicKeyPart = ripemd160(abi.encodePacked(sha256(abi.encodePacked(byte(0x04), publicXPoint, publicYPoint))));
427         bytes32 publicKeyCheckCode = sha256(abi.encodePacked(sha256(abi.encodePacked(byte(0x00), publicKeyPart))));
428         
429         bytes memory publicKey = new bytes(32);
430         for (uint i = 0; i < 7; i++) {
431             publicKey[i] = 0x00;
432         }
433         publicKey[7] = 0x00; // Main Network
434         for (uint j = 0; j < 20; j++) {
435             publicKey[j + 8] = publicKeyPart[j];
436         }
437         publicKey[28] = publicKeyCheckCode[0];
438         publicKey[29] = publicKeyCheckCode[1];
439         publicKey[30] = publicKeyCheckCode[2];
440         publicKey[31] = publicKeyCheckCode[3];
441         
442         return uint256(bytesToBytes32(publicKey));
443     }
444     
445     function createBtcAddress(uint256 publicXPoint, uint256 publicYPoint) public pure returns(bytes32) {
446         return toBase58Checked(createBtcAddressHex(publicXPoint, publicYPoint), "1");
447     }
448 
449     function complexityForBtcAddressPrefix(bytes prefix) public pure returns(uint) {
450         return complexityForBtcAddressPrefixWithLength(prefix, prefix.length);
451     }
452 
453     // https://bitcoin.stackexchange.com/questions/48586
454     function complexityForBtcAddressPrefixWithLength(bytes prefix, uint length) public pure returns(uint) {
455         require(prefix.length >= length);
456         
457         uint8[128] memory unbase58 = [
458             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
459             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
460             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
461             255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 255, 255, 255, 255, 255, 255, 
462             255, 9, 10, 11, 12, 13, 14, 15, 16, 255, 17, 18, 19, 20, 21, 255, 
463             22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 255, 255, 255, 255, 255,
464             255, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 255, 44, 45, 46,
465             47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 255, 255, 255, 255, 255
466         ];
467 
468         uint leadingOnes = countBtcAddressLeadingOnes(prefix, length);
469 
470         uint256 prefixValue = 0;
471         uint256 prefix1 = 1;
472         for (uint i = 0; i < length; i++) {
473             uint index = uint(prefix[i]);
474             require(index != 255);
475             prefixValue = prefixValue * 58 + unbase58[index];
476             prefix1 *= 58;
477         }
478 
479         uint256 top = (uint256(1) << (200 - 8*leadingOnes));
480         uint256 total = 0;
481         uint256 prefixMin = prefixValue;
482         uint256 diff = 0;
483         for (uint digits = 1; prefix1/58 < (1 << 192); digits++) {
484             prefix1 *= 58;
485             prefixMin *= 58;
486             prefixValue = prefixValue * 58 + 57;
487 
488             diff = 0;
489             if (prefixValue >= top) {
490                 diff += prefixValue - top;
491             }
492             if (prefixMin < (top >> 8)) {
493                 diff += (top >> 8) - prefixMin;
494             }
495             
496             if ((58 ** digits) >= diff) {
497                 total += (58 ** digits) - diff;
498             }
499         }
500 
501         if (prefixMin == 0) { // if prefix is contains only ones: 111111
502             total = (58 ** (digits - 1)) - diff;
503         }
504 
505         return (1 << 192) / total;
506     }
507 
508     function countBtcAddressLeadingOnes(bytes prefix, uint length) public pure returns(uint) {
509         uint leadingOnes = 1;
510         for (uint j = 0; j < length && prefix[j] == 49; j++) {
511             leadingOnes = j + 1;
512         }
513         return leadingOnes;
514     }
515 
516     function isValidBicoinAddressPrefix(bytes prefixArg) public pure returns(bool) {
517         if (prefixArg.length < 5) {
518             return false;
519         }
520         if (prefixArg[0] != "1" && prefixArg[0] != "3") {
521             return false;
522         }
523         
524         for (uint i = 0; i < prefixArg.length; i++) {
525             byte ch = prefixArg[i];
526             if (ch == "0" || ch == "O" || ch == "I" || ch == "l") {
527                 return false;
528             }
529             if (!((ch >= "1" && ch <= "9") || (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z"))) {
530                 return false;
531             }
532         }
533 
534         return true;
535     }
536 
537     function isValidPublicKey(uint256 x, uint256 y) public pure returns(bool) {
538         return (mulmod(y, y, m) == addmod(mulmod(x, mulmod(x, x, m), m), 7, m));
539     }
540 
541 }
542 
543 // File: zeppelin-solidity/contracts/math/SafeMath.sol
544 
545 /**
546  * @title SafeMath
547  * @dev Math operations with safety checks that throw on error
548  */
549 library SafeMath {
550 
551   /**
552   * @dev Multiplies two numbers, throws on overflow.
553   */
554   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
555     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
556     // benefit is lost if 'b' is also tested.
557     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
558     if (a == 0) {
559       return 0;
560     }
561 
562     c = a * b;
563     assert(c / a == b);
564     return c;
565   }
566 
567   /**
568   * @dev Integer division of two numbers, truncating the quotient.
569   */
570   function div(uint256 a, uint256 b) internal pure returns (uint256) {
571     // assert(b > 0); // Solidity automatically throws when dividing by 0
572     // uint256 c = a / b;
573     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
574     return a / b;
575   }
576 
577   /**
578   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
579   */
580   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
581     assert(b <= a);
582     return a - b;
583   }
584 
585   /**
586   * @dev Adds two numbers, throws on overflow.
587   */
588   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
589     c = a + b;
590     assert(c >= a);
591     return c;
592   }
593 }
594 
595 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
596 
597 /**
598  * @title ERC20Basic
599  * @dev Simpler version of ERC20 interface
600  * See https://github.com/ethereum/EIPs/issues/179
601  */
602 contract ERC20Basic {
603   function totalSupply() public view returns (uint256);
604   function balanceOf(address who) public view returns (uint256);
605   function transfer(address to, uint256 value) public returns (bool);
606   event Transfer(address indexed from, address indexed to, uint256 value);
607 }
608 
609 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
610 
611 /**
612  * @title ERC20 interface
613  * @dev see https://github.com/ethereum/EIPs/issues/20
614  */
615 contract ERC20 is ERC20Basic {
616   function allowance(address owner, address spender)
617     public view returns (uint256);
618 
619   function transferFrom(address from, address to, uint256 value)
620     public returns (bool);
621 
622   function approve(address spender, uint256 value) public returns (bool);
623   event Approval(
624     address indexed owner,
625     address indexed spender,
626     uint256 value
627   );
628 }
629 
630 // File: contracts/TaskRegister.sol
631 
632 contract TaskRegister is Upgradable, VanityLib {
633     using SafeMath for uint256;
634 
635     enum TaskType {
636         BITCOIN_ADDRESS_PREFIX
637     }
638 
639     struct Task {
640         uint256 taskId; // Upper 128 bits are TaskType
641         address creator;
642         address referrer;
643         uint256 reward;
644         bytes32 data;
645         uint256 requestPublicXPoint;
646         uint256 requestPublicYPoint;
647         uint256 answerPrivateKey;
648     }
649 
650     EC public ec;
651     uint256 public nextTaskId = 1;
652     uint256 public totalReward;
653     uint256 constant public MAX_PERCENT = 1000000;
654     uint256 public serviceFee; // 1% == 10000, 100% == 1000000
655     uint256 public referrerFee; // Calculated from service fee, 50% == 500000
656 
657     Task[] public allTasks;
658     uint256[] public taskIds;
659     uint256[] public completedTaskIds;
660     mapping(uint256 => uint) public indexOfTaskId; // Starting from 1
661     mapping(uint256 => uint) public indexOfActiveTaskId; // Starting from 1
662     mapping(uint256 => uint) public indexOfCompletedTaskId; // Starting from 1
663 
664     event TaskCreated(uint256 indexed taskId);
665     event TaskSolved(uint256 indexed taskId, uint256 minerReward, uint256 referrerReward);
666     event TaskPayed(uint256 indexed taskId, uint256 value);
667 
668     constructor(address _ec, address _prevVersion) public Upgradable(_prevVersion) {
669         ec = EC(_ec);
670     }
671 
672     function allTasksCount() public view returns(uint) {
673         return allTasks.length;
674     }
675 
676     function tasksCount() public view returns(uint) {
677         return taskIds.length;
678     }
679 
680     function tasks(uint i) public view returns(uint256, address, address, uint256, bytes32, uint256, uint256, uint256) {
681         Task storage t = allTasks[indexOfTaskId[taskIds[i]].sub(1)];
682         return (t.taskId, t.creator, t.referrer, t.reward, t.data, t.requestPublicXPoint, t.requestPublicYPoint, t.answerPrivateKey);
683     }
684 
685     function completedTasksCount() public view returns(uint) {
686         return completedTaskIds.length;
687     }
688 
689     function completedTasks(uint i) public view returns(uint256, address, address, uint256, bytes32, uint256, uint256, uint256) {
690         Task storage t = allTasks[indexOfTaskId[completedTaskIds[i]].sub(1)];
691         return (t.taskId, t.creator, t.referrer, t.reward, t.data, t.requestPublicXPoint, t.requestPublicYPoint, t.answerPrivateKey);
692     }
693 
694     function getActiveTasks() external view
695         returns (
696             uint256[] t_taskIds,
697             address[] t_creators,
698             //address[] t_referrers,
699             uint256[] t_rewards,
700             bytes32[] t_datas,
701             uint256[] t_requestPublicXPoints,
702             uint256[] t_requestPublicYPoints,
703             uint256[] t_answerPrivateKeys
704         )
705     {
706         t_taskIds = new uint256[](allTasks.length);
707         t_creators = new address[](allTasks.length);
708         //t_referrers = new address[](allTasks.length);
709         t_rewards = new uint256[](allTasks.length);
710         t_datas = new bytes32[](allTasks.length);
711         t_requestPublicXPoints = new uint256[](allTasks.length);
712         t_requestPublicYPoints = new uint256[](allTasks.length);
713         t_answerPrivateKeys = new uint256[](allTasks.length);
714 
715         for (uint i = 0; i < taskIds.length; i++) {
716             uint index = indexOfActiveTaskId[taskIds[i]];
717             (
718                 t_taskIds[i],
719                 t_creators[i],
720                 //t_referrers[i],
721                 t_rewards[i],
722                 t_datas[i],
723                 t_requestPublicXPoints[i],
724                 t_requestPublicYPoints[i],
725                 t_answerPrivateKeys[i]
726             ) = (
727                 allTasks[index].taskId,
728                 allTasks[index].creator,
729                 //allTasks[index].referrer,
730                 allTasks[index].reward,
731                 allTasks[index].data,
732                 allTasks[index].requestPublicXPoint,
733                 allTasks[index].requestPublicYPoint,
734                 allTasks[index].answerPrivateKey
735             );
736         }
737     }
738 
739     function getCompletedTasks() external view
740         returns (
741             uint256[] t_taskIds,
742             address[] t_creators,
743             //address[] t_referrers,
744             uint256[] t_rewards,
745             bytes32[] t_datas,
746             uint256[] t_requestPublicXPoints,
747             uint256[] t_requestPublicYPoints,
748             uint256[] t_answerPrivateKeys
749         )
750     {
751         t_taskIds = new uint256[](allTasks.length);
752         t_creators = new address[](allTasks.length);
753         //t_referrers = new address[](allTasks.length);
754         t_rewards = new uint256[](allTasks.length);
755         t_datas = new bytes32[](allTasks.length);
756         t_requestPublicXPoints = new uint256[](allTasks.length);
757         t_requestPublicYPoints = new uint256[](allTasks.length);
758         t_answerPrivateKeys = new uint256[](allTasks.length);
759 
760         for (uint i = 0; i < completedTaskIds.length; i++) {
761             uint index = indexOfCompletedTaskId[completedTaskIds[i]];
762             (
763                 t_taskIds[i],
764                 t_creators[i],
765                 //t_referrers[i],
766                 t_rewards[i],
767                 t_datas[i],
768                 t_requestPublicXPoints[i],
769                 t_requestPublicYPoints[i],
770                 t_answerPrivateKeys[i]
771             ) = (
772                 allTasks[index].taskId,
773                 allTasks[index].creator,
774                 //allTasks[index].referrer,
775                 allTasks[index].reward,
776                 allTasks[index].data,
777                 allTasks[index].requestPublicXPoint,
778                 allTasks[index].requestPublicYPoint,
779                 allTasks[index].answerPrivateKey
780             );
781         }
782     }
783 
784     function setServiceFee(uint256 _serviceFee) public onlyOwner {
785         require(_serviceFee <= 20000, "setServiceFee: value should be less than 20000, which means 2% of miner reward");
786         serviceFee = _serviceFee;
787     }
788 
789     function setReferrerFee(uint256 _referrerFee) public onlyOwner {
790         require(_referrerFee <= 500000, "setReferrerFee: value should be less than 500000, which means 50% of service fee");
791         referrerFee = _referrerFee;
792     }
793 
794     function upgrade(uint _size) public onlyOwner {
795         require(upgradableState.isUpgrading);
796         require(upgradableState.prevVersion != 0);
797 
798         // Migrate some vars
799         TaskRegister prev = TaskRegister(upgradableState.prevVersion);
800         nextTaskId = prev.nextTaskId();
801         totalReward = prev.totalReward();
802         serviceFee = prev.serviceFee();
803         referrerFee = prev.referrerFee();
804 
805         uint index = allTasks.length;
806         uint tasksLength = prev.tasksCount();
807         
808         // Migrate tasks
809 
810         for (uint i = index; i < index + _size && i < tasksLength; i++) {
811             allTasks.push(Task((uint(TaskType.BITCOIN_ADDRESS_PREFIX) << 128) | 0,0,0,0,bytes32(0),0,0,0));
812             uint j = prev.indexOfActiveTaskId(prev.taskIds(i));
813             (
814                 allTasks[i].taskId,
815                 allTasks[i].creator,
816                 allTasks[i].referrer,
817                 allTasks[i].reward,
818                 ,//allTasks[i].data,
819                 ,//allTasks[i].requestPublicXPoint,
820                 ,//allTasks[i].requestPublicYPoint,
821                  //allTasks[i].answerPrivateKey
822             ) = prev.allTasks(j);
823             indexOfTaskId[allTasks[i].taskId] = i + 1;
824         }
825 
826         for (i = index; i < index + _size && i < tasksLength; i++) {
827             j = prev.indexOfActiveTaskId(prev.taskIds(i));
828             (
829                 ,//allTasks[i].taskId,
830                 ,//allTasks[i].creator,
831                 ,//allTasks[i].referrer,
832                 ,//allTasks[i].reward,
833                 allTasks[i].data,
834                 allTasks[i].requestPublicXPoint,
835                 allTasks[i].requestPublicYPoint,
836                 allTasks[i].answerPrivateKey
837             ) = prev.allTasks(j);
838         }
839 
840         for (i = index; i < index + _size && i < tasksLength; i++) {
841             uint taskId = prev.taskIds(i);
842             indexOfActiveTaskId[taskId] = taskIds.push(taskId);
843         }
844     }
845 
846     function endUpgrade() public {
847         super.endUpgrade();
848 
849         if (upgradableState.nextVersion != 0) {
850             upgradableState.nextVersion.transfer(address(this).balance);
851         }
852 
853         //_removeAllActiveTasksWithHoles(0, taskIds.length);
854     }
855 
856     function () public payable {
857         require(msg.sender == upgradableState.prevVersion);
858         require(address(this).balance >= totalReward);
859     }
860 
861     function payForTask(uint256 _taskId) public payable isLastestVersion {
862         if (msg.value > 0) {
863             Task storage task = allTasks[indexOfTaskId[_taskId].sub(1)];
864             require(task.answerPrivateKey == 0, "payForTask: you can't pay for the solved task");
865             task.reward = task.reward.add(msg.value);
866             totalReward = totalReward.add(msg.value);
867             emit TaskPayed(_taskId, msg.value);
868         }
869     }
870 
871     function createBitcoinAddressPrefixTask(
872         bytes prefix,
873         uint256 requestPublicXPoint,
874         uint256 requestPublicYPoint,
875         address referrer
876     )
877         public
878         payable
879         isLastestVersion
880     {
881         require(prefix.length > 5);
882         require(prefix[0] == "1");
883         require(prefix[1] != "1"); // Do not support multiple 1s yet
884         require(isValidBicoinAddressPrefix(prefix));
885         require(isValidPublicKey(requestPublicXPoint, requestPublicYPoint));
886 
887         bytes32 data;
888         assembly {
889             data := mload(add(prefix, 32))
890         }
891 
892         uint256 taskId = nextTaskId++;
893         Task memory task = Task({
894             taskId: (uint(TaskType.BITCOIN_ADDRESS_PREFIX) << 128) | taskId,
895             creator: msg.sender,
896             referrer: referrer,
897             reward: 0,
898             data: data,
899             requestPublicXPoint: requestPublicXPoint,
900             requestPublicYPoint: requestPublicYPoint,
901             answerPrivateKey: 0
902         });
903 
904         indexOfTaskId[taskId] = allTasks.push(task); // incremented to avoid 0 index
905         indexOfActiveTaskId[taskId] = taskIds.push(taskId);
906         emit TaskCreated(taskId);
907         payForTask(taskId);
908     }
909 
910     function solveTask(uint _taskId, uint256 _answerPrivateKey, uint256 publicXPoint, uint256 publicYPoint) public isLastestVersion {
911         uint taskIndex = indexOfTaskId[_taskId].sub(1);
912         Task storage task = allTasks[taskIndex];
913         require(task.answerPrivateKey == 0, "solveTask: task is already solved");
914         
915         // Require private key to be part of address to prevent front-running attack
916         require(_answerPrivateKey >> 128 == uint256(msg.sender) >> 32, "solveTask: this solution does not match miner address");
917 
918         if (TaskType(task.taskId >> 128) == TaskType.BITCOIN_ADDRESS_PREFIX) {
919             ///(publicXPoint, publicYPoint) = ec.publicKey(_answerPrivateKey);
920             require(ec.publicKeyVerify(_answerPrivateKey, publicXPoint, publicYPoint));
921             (publicXPoint, publicYPoint) = ec.ecadd(
922                 task.requestPublicXPoint,
923                 task.requestPublicYPoint,
924                 publicXPoint,
925                 publicYPoint
926             );
927 
928             bytes32 btcAddress = createBtcAddress(publicXPoint, publicYPoint);
929             require(haveCommonPrefixUntilZero(task.data, btcAddress), "solveTask: found prefix is not enough");
930 
931             task.answerPrivateKey = _answerPrivateKey;
932         } else {
933             revert();
934         }
935 
936         uint256 taskReard = task.reward;
937         uint256 serviceReward = taskReard.mul(serviceFee).div(MAX_PERCENT); // 1%
938         uint256 minerReward = taskReard - serviceReward; // 99%
939         if (serviceReward != 0 && task.referrer != 0) {
940             uint256 referrerReward = serviceReward.mul(referrerFee).div(MAX_PERCENT); // 50% of service reward
941             task.referrer.transfer(referrerReward);
942             emit TaskSolved(_taskId, minerReward, referrerReward);
943         } else {
944             emit TaskSolved(_taskId, minerReward, 0);
945         }
946         msg.sender.transfer(minerReward);
947         totalReward -= taskReard;
948 
949         _completeTask(_taskId);
950     }
951 
952     function _completeTask(uint _taskId) internal {
953         indexOfCompletedTaskId[_taskId] = completedTaskIds.push(_taskId);
954         uint activeTaskIndex = indexOfActiveTaskId[_taskId].sub(1);
955         delete indexOfActiveTaskId[_taskId];
956 
957         if (activeTaskIndex + 1 < taskIds.length) { // if not latest
958             uint256 lastTaskId = taskIds[taskIds.length - 1];
959             taskIds[activeTaskIndex] = lastTaskId;
960             indexOfActiveTaskId[lastTaskId] = activeTaskIndex + 1;
961         }
962         taskIds.length -= 1;
963     }
964 
965     // function _removeAllActiveTasksWithHoles(uint _from, uint _to) internal {
966     //     for (uint i = _from; i < _to && i < taskIds.length; i++) {
967     //         uint taskId = taskIds[i];
968     //         uint index = indexOfTaskId[taskId].sub(1);
969     //         delete allTasks[index];
970     //         delete indexOfTaskId[taskId];
971     //         delete indexOfActiveTaskId[taskId];
972     //     }
973     //     if (_to >= taskIds.length) {
974     //         taskIds.length = 0;
975     //     }
976     // }
977 
978     function claim(ERC20Basic _token, address _to) public onlyOwner {
979         if (_token == address(0)) {
980             _to.transfer(address(this).balance - totalReward);
981         } else {
982             _token.transfer(_to, _token.balanceOf(this));
983         }
984     }
985 
986 }
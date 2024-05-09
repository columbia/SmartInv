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
367     function lengthOfCommonPrefix(bytes32 a, bytes32 b) public pure returns(uint) {
368         for (uint i = 0; i < 32; i++) {
369             if (a[i] != b[i] || a[i] == 0) {
370                 return i;
371             }
372         }
373         return 0;
374     }
375     
376     function bytesToBytes32(bytes source) public pure returns(bytes32 result) {
377         assembly {
378             result := mload(add(source, 32))
379         }
380     }
381 
382     /* Converts given number to base58, limited by 32 symbols */
383     function toBase58Checked(uint256 _value, byte appCode) public pure returns(bytes32) {
384         string memory letters = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
385         bytes memory alphabet = bytes(letters);
386         uint8 base = 58;
387         uint8 len = 0;
388         uint256 remainder = 0;
389         bool needBreak = false;
390         bytes memory bytesReversed = bytes(new string(32));
391         
392         for (uint8 i = 0; true; i++) {
393             if (_value < base) {
394                 needBreak = true;
395             }
396             remainder = _value % base;
397             _value = uint256(_value / base);
398             if (len == 32) {
399                 for (uint j = 0; j < len - 1; j++) {
400                     bytesReversed[j] = bytesReversed[j + 1];
401                 }
402                 len--;
403             }
404             bytesReversed[len] = alphabet[remainder];
405             len++;
406             if (needBreak) {
407                 break;
408             }
409         }
410         
411         // Reverse
412         bytes memory result = bytes(new string(32));
413         result[0] = appCode;
414         for (i = 0; i < 31; i++) {
415             result[i + 1] = bytesReversed[len - 1 - i];
416         }
417         
418         return bytesToBytes32(result);
419     }
420 
421     // Create BTC Address: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses#How_to_create_Bitcoin_Address
422     function createBtcAddressHex(uint256 publicXPoint, uint256 publicYPoint) public pure returns(uint256) {
423         bytes20 publicKeyPart = ripemd160(abi.encodePacked(sha256(abi.encodePacked(byte(0x04), publicXPoint, publicYPoint))));
424         bytes32 publicKeyCheckCode = sha256(abi.encodePacked(sha256(abi.encodePacked(byte(0x00), publicKeyPart))));
425         
426         bytes memory publicKey = new bytes(32);
427         for (uint i = 0; i < 7; i++) {
428             publicKey[i] = 0x00;
429         }
430         publicKey[7] = 0x00; // Main Network
431         for (uint j = 0; j < 20; j++) {
432             publicKey[j + 8] = publicKeyPart[j];
433         }
434         publicKey[28] = publicKeyCheckCode[0];
435         publicKey[29] = publicKeyCheckCode[1];
436         publicKey[30] = publicKeyCheckCode[2];
437         publicKey[31] = publicKeyCheckCode[3];
438         
439         return uint256(bytesToBytes32(publicKey));
440     }
441     
442     function createBtcAddress(uint256 publicXPoint, uint256 publicYPoint) public pure returns(bytes32) {
443         return toBase58Checked(createBtcAddressHex(publicXPoint, publicYPoint), "1");
444     }
445 
446     function complexityForBtcAddressPrefix(bytes prefix) public pure returns(uint) {
447         return complexityForBtcAddressPrefixWithLength(prefix, prefix.length);
448     }
449 
450     // https://bitcoin.stackexchange.com/questions/48586
451     function complexityForBtcAddressPrefixWithLength(bytes prefix, uint length) public pure returns(uint) {
452         require(prefix.length >= length);
453         
454         uint8[128] memory unbase58 = [
455             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
456             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
457             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
458             255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 255, 255, 255, 255, 255, 255, 
459             255, 9, 10, 11, 12, 13, 14, 15, 16, 255, 17, 18, 19, 20, 21, 255, 
460             22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 255, 255, 255, 255, 255,
461             255, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 255, 44, 45, 46,
462             47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 255, 255, 255, 255, 255
463         ];
464 
465         uint leadingOnes = countBtcAddressLeadingOnes(prefix, length);
466 
467         uint256 prefixValue = 0;
468         uint256 prefix1 = 1;
469         for (uint i = 0; i < length; i++) {
470             uint index = uint(prefix[i]);
471             require(index != 255);
472             prefixValue = prefixValue * 58 + unbase58[index];
473             prefix1 *= 58;
474         }
475 
476         uint256 top = (uint256(1) << (200 - 8*leadingOnes));
477         uint256 total = 0;
478         uint256 prefixMin = prefixValue;
479         uint256 diff = 0;
480         for (uint digits = 1; prefix1/58 < (1 << 192); digits++) {
481             prefix1 *= 58;
482             prefixMin *= 58;
483             prefixValue = prefixValue * 58 + 57;
484 
485             diff = 0;
486             if (prefixValue >= top) {
487                 diff += prefixValue - top;
488             }
489             if (prefixMin < (top >> 8)) {
490                 diff += (top >> 8) - prefixMin;
491             }
492             
493             if ((58 ** digits) >= diff) {
494                 total += (58 ** digits) - diff;
495             }
496         }
497 
498         if (prefixMin == 0) { // if prefix is contains only ones: 111111
499             total = (58 ** (digits - 1)) - diff;
500         }
501 
502         return (1 << 192) / total;
503     }
504 
505     function countBtcAddressLeadingOnes(bytes prefix, uint length) public pure returns(uint) {
506         uint leadingOnes = 1;
507         for (uint j = 0; j < length && prefix[j] == 49; j++) {
508             leadingOnes = j + 1;
509         }
510         return leadingOnes;
511     }
512 
513     function isValidBicoinAddressPrefix(bytes prefixArg) public pure returns(bool) {
514         if (prefixArg.length < 5) {
515             return false;
516         }
517         if (prefixArg[0] != "1" && prefixArg[0] != "3") {
518             return false;
519         }
520         
521         for (uint i = 0; i < prefixArg.length; i++) {
522             byte ch = prefixArg[i];
523             if (ch == "0" || ch == "O" || ch == "I" || ch == "l") {
524                 return false;
525             }
526             if (!((ch >= "1" && ch <= "9") || (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z"))) {
527                 return false;
528             }
529         }
530 
531         return true;
532     }
533 
534     function isValidPublicKey(uint256 x, uint256 y) public pure returns(bool) {
535         return (mulmod(y, y, m) == addmod(mulmod(x, mulmod(x, x, m), m), 7, m));
536     }
537 
538 }
539 
540 // File: zeppelin-solidity/contracts/math/SafeMath.sol
541 
542 /**
543  * @title SafeMath
544  * @dev Math operations with safety checks that throw on error
545  */
546 library SafeMath {
547 
548   /**
549   * @dev Multiplies two numbers, throws on overflow.
550   */
551   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
552     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
553     // benefit is lost if 'b' is also tested.
554     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
555     if (a == 0) {
556       return 0;
557     }
558 
559     c = a * b;
560     assert(c / a == b);
561     return c;
562   }
563 
564   /**
565   * @dev Integer division of two numbers, truncating the quotient.
566   */
567   function div(uint256 a, uint256 b) internal pure returns (uint256) {
568     // assert(b > 0); // Solidity automatically throws when dividing by 0
569     // uint256 c = a / b;
570     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571     return a / b;
572   }
573 
574   /**
575   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
576   */
577   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
578     assert(b <= a);
579     return a - b;
580   }
581 
582   /**
583   * @dev Adds two numbers, throws on overflow.
584   */
585   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
586     c = a + b;
587     assert(c >= a);
588     return c;
589   }
590 }
591 
592 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
593 
594 /**
595  * @title ERC20Basic
596  * @dev Simpler version of ERC20 interface
597  * See https://github.com/ethereum/EIPs/issues/179
598  */
599 contract ERC20Basic {
600   function totalSupply() public view returns (uint256);
601   function balanceOf(address who) public view returns (uint256);
602   function transfer(address to, uint256 value) public returns (bool);
603   event Transfer(address indexed from, address indexed to, uint256 value);
604 }
605 
606 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
607 
608 /**
609  * @title ERC20 interface
610  * @dev see https://github.com/ethereum/EIPs/issues/20
611  */
612 contract ERC20 is ERC20Basic {
613   function allowance(address owner, address spender)
614     public view returns (uint256);
615 
616   function transferFrom(address from, address to, uint256 value)
617     public returns (bool);
618 
619   function approve(address spender, uint256 value) public returns (bool);
620   event Approval(
621     address indexed owner,
622     address indexed spender,
623     uint256 value
624   );
625 }
626 
627 // File: contracts/TaskRegister.sol
628 
629 contract TaskRegister is Upgradable, VanityLib {
630     using SafeMath for uint256;
631 
632     enum TaskType {
633         BITCOIN_ADDRESS_PREFIX
634     }
635 
636     struct Task {
637         TaskType taskType;
638         uint256 taskId;
639         address creator;
640         address referrer;
641         uint256 reward;
642         bytes32 data;
643         uint256 dataLength;
644         uint256 requestPublicXPoint;
645         uint256 requestPublicYPoint;
646         uint256 answerPrivateKey;
647     }
648 
649     EC public ec;
650     uint256 public nextTaskId = 1;
651     uint256 public totalReward;
652     uint256 constant public MAX_PERCENT = 1000000;
653     uint256 public serviceFee; // 1% == 10000, 100% == 1000000
654     uint256 public referrerFee; // Calculated from service fee, 50% == 500000
655     
656     Task[] public tasks;
657     Task[] public completedTasks;
658     mapping(uint256 => uint) public indexOfTaskId; // Starting from 1
659 
660     event TaskCreated(uint256 indexed taskId);
661     event TaskSolved(uint256 indexed taskId, uint256 reward);
662     event TaskPayed(uint256 indexed taskId, uint256 value);
663 
664     constructor(address _ec, address _prevVersion) public Upgradable(_prevVersion) {
665         ec = EC(_ec);
666     }
667 
668     function setServiceFee(uint256 _serviceFee) public onlyOwner {
669         require(_serviceFee <= 20000); // 2% of reward
670         serviceFee = _serviceFee;
671     }
672 
673     function setReferrerFee(uint256 _referrerFee) public onlyOwner {
674         require(_referrerFee <= 500000); // 50% of serviceFee
675         referrerFee = _referrerFee;
676     }
677 
678     function upgrade(uint _size) public onlyOwner {
679         require(upgradableState.isUpgrading);
680         require(upgradableState.prevVersion != 0);
681 
682         // Migrate some vars
683         nextTaskId = TaskRegister(upgradableState.prevVersion).nextTaskId();
684         totalReward = TaskRegister(upgradableState.prevVersion).totalReward();
685         serviceFee = TaskRegister(upgradableState.prevVersion).serviceFee();
686         referrerFee = TaskRegister(upgradableState.prevVersion).referrerFee();
687         
688         uint index = tasks.length;
689         uint tasksCount = TaskRegister(upgradableState.prevVersion).tasksCount();
690 
691         // Migrate tasks
692 
693         for (uint i = index; i < index + _size && i < tasksCount; i++) {
694             tasks.push(Task(TaskType.BITCOIN_ADDRESS_PREFIX,0,0,0,0,bytes32(0),0,0,0,0));
695         }
696 
697         for (uint j = index; j < index + _size && j < tasksCount; j++) {
698             (
699                 tasks[j].taskType,
700                 tasks[j].taskId,
701                 tasks[j].creator,
702                 tasks[j].referrer,
703                 ,//tasks[j].reward,
704                 ,//tasks[j].data,
705                 ,//tasks[j].dataLength, 
706                 ,//tasks[j].requestPublicXPoint, 
707                 ,//tasks[j].requestPublicYPoint,
708                  //tasks[j].answerPrivateKey
709             ) = TaskRegister(upgradableState.prevVersion).tasks(j);
710             indexOfTaskId[tasks[j].taskId] = j + 1;
711         }
712 
713         for (j = index; j < index + _size && j < tasksCount; j++) {
714             (
715                 ,//tasks[j].taskType,
716                 ,//tasks[j].taskId,
717                 ,//tasks[j].creator,
718                 ,//tasks[j].referrer,
719                 tasks[j].reward,
720                 tasks[j].data,
721                 tasks[j].dataLength, 
722                 tasks[j].requestPublicXPoint, 
723                 ,//tasks[j].requestPublicYPoint,
724                  //tasks[j].answerPrivateKey
725             ) = TaskRegister(upgradableState.prevVersion).tasks(j);
726         }
727 
728         for (j = index; j < index + _size && j < tasksCount; j++) {
729             (
730                 ,//tasks[j].taskType,
731                 ,//tasks[j].taskId,
732                 ,//tasks[j].creator,
733                 ,//tasks[j].referrer,
734                 ,//tasks[j].reward,
735                 ,//tasks[j].data,
736                 ,//tasks[j].dataLength, 
737                 ,//tasks[j].requestPublicXPoint, 
738                 tasks[j].requestPublicYPoint,
739                 tasks[j].answerPrivateKey
740             ) = TaskRegister(upgradableState.prevVersion).tasks(j);
741         }
742     }
743     
744     function endUpgrade() public {
745         super.endUpgrade();
746     }
747 
748     function tasksCount() public view returns(uint) {
749         return tasks.length;
750     }
751 
752     function completedTasksCount() public view returns(uint) {
753         return completedTasks.length;
754     }
755 
756     function payForTask(uint256 _taskId) payable public isLastestVersion {
757         if (msg.value > 0) {
758             Task storage task = tasks[safeIndexOfTaskId(_taskId)];
759             task.reward = task.reward.add(msg.value);
760             totalReward = totalReward.add(msg.value);
761             emit TaskPayed(_taskId, msg.value);
762         }
763     }
764 
765     function safeIndexOfTaskId(uint _taskId) public view returns(uint) {
766         return indexOfTaskId[_taskId].sub(1);
767     }
768     
769     function createBitcoinAddressPrefixTask(
770         bytes prefix,
771         uint256 requestPublicXPoint,
772         uint256 requestPublicYPoint,
773         address referrer
774     )
775         payable
776         public
777         isLastestVersion
778     {
779         require(prefix.length > 5);
780         require(prefix[0] == "1");
781         require(prefix[1] != "1"); // Do not support multiple 1s yet
782         require(isValidBicoinAddressPrefix(prefix));
783         require(isValidPublicKey(requestPublicXPoint, requestPublicYPoint));
784 
785         bytes32 data;
786         assembly {
787             data := mload(add(prefix, 32))
788         }
789         
790         Task memory task = Task({
791             taskType: TaskType.BITCOIN_ADDRESS_PREFIX,
792             taskId: nextTaskId++,
793             creator: msg.sender,
794             referrer: referrer,
795             reward: 0,
796             data: data,
797             dataLength: prefix.length,
798             requestPublicXPoint: requestPublicXPoint,
799             requestPublicYPoint: requestPublicYPoint,
800             answerPrivateKey: 0
801         });
802 
803         indexOfTaskId[task.taskId] = tasks.push(task); // incremented to avoid 0 index
804         emit TaskCreated(task.taskId);
805         payForTask(task.taskId);
806     }
807     
808     function solveTask(uint _taskId, uint256 _answerPrivateKey, uint256 publicXPoint, uint256 publicYPoint) public isLastestVersion {
809         uint taskIndex = safeIndexOfTaskId(_taskId);
810         Task storage task = tasks[taskIndex];
811         require(task.answerPrivateKey == 0, "solveTask: task is already solved");
812 
813         // Require private key to be part of address to prevent front-running attack
814         require(_answerPrivateKey >> 128 == uint256(msg.sender) >> 32, "solveTask: this solution does not match miner address");
815 
816         if (task.taskType == TaskType.BITCOIN_ADDRESS_PREFIX) {
817             ///(publicXPoint, publicYPoint) = ec.publicKey(_answerPrivateKey);
818             require(ec.publicKeyVerify(_answerPrivateKey, publicXPoint, publicYPoint));
819             (publicXPoint, publicYPoint) = ec.ecadd(
820                 task.requestPublicXPoint,
821                 task.requestPublicYPoint,
822                 publicXPoint,
823                 publicYPoint
824             );
825 
826             require(isValidPublicKey(publicXPoint, publicYPoint));
827             
828             bytes32 btcAddress = createBtcAddress(publicXPoint, publicYPoint);
829             uint prefixLength = lengthOfCommonPrefix(btcAddress, task.data);
830             require(prefixLength == task.dataLength);
831             
832             task.answerPrivateKey = _answerPrivateKey;
833         } else {
834             revert();
835         }
836 
837         uint256 minerReward = task.reward.mul(MAX_PERCENT - serviceFee).div(MAX_PERCENT); // 1% fee
838         msg.sender.transfer(minerReward);
839         totalReward = totalReward.sub(minerReward);
840 
841         if (task.referrer != 0) {
842             uint256 referrerReward = task.reward.mul(serviceFee).mul(referrerFee).div(MAX_PERCENT).div(MAX_PERCENT); // 50% of service fee
843             task.referrer.transfer(referrerReward);
844             totalReward = totalReward.sub(referrerReward);
845         }
846 
847         _completeTask(_taskId, taskIndex);
848         emit TaskSolved(_taskId, minerReward);
849     }
850 
851     function _completeTask(uint _taskId, uint _index) internal {
852         completedTasks.push(tasks[_index]);
853         if (_index < tasks.length - 1) { // if not latest
854             tasks[_index] = tasks[tasks.length - 1];
855             indexOfTaskId[tasks[_index].taskId] = _index + 1;
856         }
857         tasks.length -= 1;
858         delete indexOfTaskId[_taskId];
859     }
860 
861     function claim(ERC20Basic _token, address _to) public onlyOwner {
862         if (_token == address(0)) {
863             _to.transfer(address(this).balance - totalReward);
864         } else {
865             _token.transfer(_to, _token.balanceOf(this));
866         }
867     }
868 
869 }
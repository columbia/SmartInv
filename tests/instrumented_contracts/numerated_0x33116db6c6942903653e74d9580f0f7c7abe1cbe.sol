1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract VanityLib {
67     uint constant m = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
68 
69     function lengthOfCommonPrefix(bytes a, bytes b) public pure returns(uint) {
70         uint len = (a.length <= b.length) ? a.length : b.length;
71         for (uint i = 0; i < len; i++) {
72             if (a[i] != b[i]) {
73                 return i;
74             }
75         }
76         return len;
77     }
78     
79     function lengthOfCommonPrefix32(bytes32 a, bytes b) public pure returns(uint) {
80         for (uint i = 0; i < b.length; i++) {
81             if (a[i] != b[i]) {
82                 return i;
83             }
84         }
85         return b.length;
86     }
87 
88     function lengthOfCommonPrefix3232(bytes32 a, bytes32 b) public pure returns(uint) {
89         for (uint i = 0; i < 32; i++) {
90             if (a[i] != b[i] || a[i] == 0) {
91                 return i;
92             }
93         }
94         return 0;
95     }
96     
97     function equalBytesToBytes(bytes a, bytes b) public pure returns (bool) {
98         if (a.length != b.length) {
99             return false;
100         }
101         for (uint i = 0; i < a.length; i++) {
102             if (a[i] != b[i]) {
103                 return false;
104             }
105         }
106         return true;
107     }
108     
109     function equalBytes32ToBytes(bytes32 a, bytes b) public pure returns (bool) {
110         for (uint i = 0; i < b.length; i++) {
111             if (a[i] != b[i]) {
112                 return false;
113             }
114         }
115         return true;
116     }
117     
118     function bytesToBytes32(bytes source) public pure returns(bytes32 result) {
119         assembly {
120             result := mload(add(source, 32))
121         }
122     }
123 
124     /* Converts given number to base58, limited by 32 symbols */
125     function toBase58Checked(uint256 _value, byte appCode) public pure returns(bytes32) {
126         string memory letters = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
127         bytes memory alphabet = bytes(letters);
128         uint8 base = 58;
129         uint8 len = 0;
130         uint256 remainder = 0;
131         bool needBreak = false;
132         bytes memory bytesReversed = bytes(new string(32));
133         
134         for (uint8 i = 0; true; i++) {
135             if (_value < base) {
136                 needBreak = true;
137             }
138             remainder = _value % base;
139             _value = uint256(_value / base);
140             if (len == 32) {
141                 for (uint j = 0; j < len - 1; j++) {
142                     bytesReversed[j] = bytesReversed[j + 1];
143                 }
144                 len--;
145             }
146             bytesReversed[len] = alphabet[remainder];
147             len++;
148             if (needBreak) {
149                 break;
150             }
151         }
152         
153         // Reverse
154         bytes memory result = bytes(new string(32));
155         result[0] = appCode;
156         for (i = 0; i < 31; i++) {
157             result[i + 1] = bytesReversed[len - 1 - i];
158         }
159         
160         return bytesToBytes32(result);
161     }
162 
163     // Create BTC Address: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses#How_to_create_Bitcoin_Address
164     function createBtcAddressHex(uint256 publicXPoint, uint256 publicYPoint) public pure returns(uint256) {
165         bytes20 publicKeyPart = ripemd160(sha256(byte(0x04), publicXPoint, publicYPoint));
166         bytes32 publicKeyCheckCode = sha256(sha256(byte(0x00), publicKeyPart));
167         
168         bytes memory publicKey = new bytes(32);
169         for (uint i = 0; i < 7; i++) {
170             publicKey[i] = 0x00;
171         }
172         publicKey[7] = 0x00; // Main Network
173         for (uint j = 0; j < 20; j++) {
174             publicKey[j + 8] = publicKeyPart[j];
175         }
176         publicKey[28] = publicKeyCheckCode[0];
177         publicKey[29] = publicKeyCheckCode[1];
178         publicKey[30] = publicKeyCheckCode[2];
179         publicKey[31] = publicKeyCheckCode[3];
180         
181         return uint256(bytesToBytes32(publicKey));
182     }
183     
184     function createBtcAddress(uint256 publicXPoint, uint256 publicYPoint) public pure returns(bytes32) {
185         return toBase58Checked(createBtcAddressHex(publicXPoint, publicYPoint), "1");
186     }
187 
188     // https://github.com/stonecoldpat/anonymousvoting/blob/master/LocalCrypto.sol
189     function invmod(uint256 a, uint256 p) public pure returns (uint256) {
190         int t1 = 0;
191         int t2 = 1;
192         uint r1 = p;
193         uint r2 = a;
194         uint q;
195         while (r2 != 0) {
196             q = r1 / r2;
197             (t1, t2, r1, r2) = (t2, t1 - int(q) * t2, r2, r1 - q * r2);
198         }
199 
200         return t1 < 0 ? p - uint(-t1) : uint(t1);
201     }
202     
203     // https://github.com/stonecoldpat/anonymousvoting/blob/master/LocalCrypto.sol
204     function submod(uint a, uint b, uint p) public pure returns (uint) {
205         return addmod(a, p - b, p);
206     }
207 
208     // https://en.wikipedia.org/wiki/Elliptic_curve_point_multiplication#Point_addition
209     // https://github.com/bellaj/Blockchain/blob/6bffb47afae6a2a70903a26d215484cf8ff03859/ecdsa_bitcoin.pdf
210     // https://math.stackexchange.com/questions/2198139/elliptic-curve-formulas-for-point-addition
211     function addXY(uint x1, uint y1, uint x2, uint y2) public pure returns(uint x3, uint y3) {
212         uint anti = invmod(submod(x1, x2, m), m);
213         uint alpha = mulmod(submod(y1, y2, m), anti, m);
214         x3 = submod(submod(mulmod(alpha, alpha, m), x1, m), x2, m);
215         y3 = submod(mulmod(alpha, submod(x2, x3, m), m), y2, m);
216         
217         // x3 = bytes32(mul_mod(uint(x3), uint(y3), m)); == 1!!!!
218         
219         // https://github.com/jbaylina/ecsol/blob/master/ec.sol
220         // x3 = addmod(mulmod(y2, x1, m), mulmod(x2, y1, m), m);
221         // y3 = mulmod(y1, y2, m);
222     }
223 
224     function doubleXY(uint x1, uint y1) public pure returns(uint x2, uint y2) {
225         uint anti = invmod(addmod(y1, y1, m), m);
226         uint alpha = mulmod(addmod(addmod(mulmod(x1, x1, m), mulmod(x1, x1, m), m), mulmod(x1, x1, m), m), anti, m);
227         x2 = submod(mulmod(alpha, alpha, m), addmod(x1, x1, m), m);
228         y2 = submod(mulmod(alpha, submod(x1, x2, m), m), y1, m);
229     }
230 
231     function mulXY(uint x1, uint y1, uint privateKey) public pure returns(uint x2, uint y2) {
232         bool addition = false;
233         for (uint i = 0; i < 256; i++) {
234             if (((privateKey >> i) & 1) == 1) {
235                 if (addition) {
236                     (x2, y2) = addXY(x1, y1, x2, y2);
237                 } else {
238                     (x2, y2) = (x1, y1);
239                     addition = true;
240                 }
241             }
242             (x1,y1) = doubleXY(x1, y1);
243         }
244     }
245 
246     function bitcoinPublicKey(uint256 privateKey) public pure returns(uint, uint) {
247         uint256 gx = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
248         uint256 gy = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;
249         return mulXY(gx, gy, privateKey);
250     }
251 
252     function complexityForBtcAddressPrefix(bytes prefix) public pure returns(uint) {
253         return complexityForBtcAddressPrefixWithLength(prefix, prefix.length);
254     }
255 
256     // https://bitcoin.stackexchange.com/questions/48586
257     function complexityForBtcAddressPrefixWithLength(bytes prefix, uint length) public pure returns(uint) {
258         require(prefix.length >= length);
259         
260         uint8[128] memory unbase58 = [
261             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
262             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
263             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
264             255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 255, 255, 255, 255, 255, 255, 
265             255, 9, 10, 11, 12, 13, 14, 15, 16, 255, 17, 18, 19, 20, 21, 255, 
266             22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 255, 255, 255, 255, 255,
267             255, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 255, 44, 45, 46,
268             47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 255, 255, 255, 255, 255
269         ];
270 
271         uint leadingOnes = countBtcAddressLeadingOnes(prefix, length);
272 
273         uint256 prefixValue = 0;
274         uint256 prefix1 = 1;
275         for (uint i = 0; i < length; i++) {
276             uint index = uint(prefix[i]);
277             require(index != 255);
278             prefixValue = prefixValue * 58 + unbase58[index];
279             prefix1 *= 58;
280         }
281 
282         uint256 top = (uint256(1) << (200 - 8*leadingOnes));
283         uint256 total = 0;
284         uint256 prefixMin = prefixValue;
285         uint256 diff = 0;
286         for (uint digits = 1; prefix1/58 < (1 << 192); digits++) {
287             prefix1 *= 58;
288             prefixMin *= 58;
289             prefixValue = prefixValue * 58 + 57;
290 
291             diff = 0;
292             if (prefixValue >= top) {
293                 diff += prefixValue - top;
294             }
295             if (prefixMin < (top >> 8)) {
296                 diff += (top >> 8) - prefixMin;
297             }
298             
299             if ((58 ** digits) >= diff) {
300                 total += (58 ** digits) - diff;
301             }
302         }
303 
304         if (prefixMin == 0) { // if prefix is contains only ones: 111111
305             total = (58 ** (digits - 1)) - diff;
306         }
307 
308         return (1 << 192) / total;
309     }
310 
311     function countBtcAddressLeadingOnes(bytes prefix, uint length) public pure returns(uint) {
312         uint leadingOnes = 1;
313         for (uint j = 0; j < length && prefix[j] == 49; j++) {
314             leadingOnes = j + 1;
315         }
316         return leadingOnes;
317     }
318 
319     function isValidBicoinAddressPrefix(bytes prefixArg) public pure returns(bool) {
320         if (prefixArg.length < 5) {
321             return false;
322         }
323         if (prefixArg[0] != "1" && prefixArg[0] != "3") {
324             return false;
325         }
326         
327         for (uint i = 0; i < prefixArg.length; i++) {
328             byte ch = prefixArg[i];
329             if (ch == "0" || ch == "O" || ch == "I" || ch == "l") {
330                 return false;
331             }
332             if (!((ch >= "1" && ch <= "9") || (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z"))) {
333                 return false;
334             }
335         }
336 
337         return true;
338     }
339 
340     function isValidPublicKey(uint256 x, uint256 y) public pure returns(bool) {
341         return (mulmod(y, y, m) == addmod(mulmod(x, mulmod(x, x, m), m), 7, m));
342     }
343 
344 }
345 
346 contract IUpgradable {
347 
348     function startUpgrade() public;
349     function endUpgrade() public;
350 
351 }
352 
353 contract Upgradable is Ownable {
354 
355     struct UpgradableState {
356         bool isUpgrading;
357         address prevVersion;
358         address nextVersion;
359     }
360 
361     UpgradableState public upgradableState;
362 
363     event Initialized(address indexed prevVersion);
364     event Upgrading(address indexed nextVersion);
365     event Upgraded(address indexed nextVersion);
366 
367     modifier isLastestVersion {
368         require(!upgradableState.isUpgrading);
369         require(upgradableState.nextVersion == address(0));
370         _;
371     }
372 
373     modifier onlyOwnerOrigin {
374         require(tx.origin == owner);
375         _;
376     }
377 
378     function Upgradable(address _prevVersion) public {
379         if (_prevVersion != address(0)) {
380             require(msg.sender == Ownable(_prevVersion).owner());
381             upgradableState.isUpgrading = true;
382             upgradableState.prevVersion = _prevVersion;
383             IUpgradable(_prevVersion).startUpgrade();
384         } else {
385             Initialized(_prevVersion);
386         }
387     }
388 
389     function startUpgrade() public onlyOwnerOrigin {
390         require(msg.sender != owner);
391         require(!upgradableState.isUpgrading);
392         require(upgradableState.nextVersion == 0);
393         upgradableState.isUpgrading = true;
394         upgradableState.nextVersion = msg.sender;
395         Upgrading(msg.sender);
396     }
397 
398     //function upgrade(uint index, uint size) public onlyOwner {}
399 
400     function endUpgrade() public onlyOwnerOrigin {
401         require(upgradableState.isUpgrading);
402         upgradableState.isUpgrading = false;
403         if (msg.sender != owner) {
404             require(upgradableState.nextVersion == msg.sender);
405             Upgraded(upgradableState.nextVersion);
406         } 
407         else  {
408             if (upgradableState.prevVersion != address(0)) {
409                 Upgradable(upgradableState.prevVersion).endUpgrade();
410             }
411             Initialized(upgradableState.prevVersion);
412         }
413     }
414 
415 }
416 
417 contract IEC {
418 
419     function _inverse(uint256 a) public constant 
420         returns(uint256 invA);
421 
422     function _ecAdd(uint256 x1,uint256 y1,uint256 z1,
423                     uint256 x2,uint256 y2,uint256 z2) public constant
424         returns(uint256 x3,uint256 y3,uint256 z3);
425 
426     function _ecDouble(uint256 x1,uint256 y1,uint256 z1) public constant
427         returns(uint256 x3,uint256 y3,uint256 z3);
428 
429     function _ecMul(uint256 d, uint256 x1,uint256 y1,uint256 z1) public constant
430         returns(uint256 x3,uint256 y3,uint256 z3);
431 
432     function publicKey(uint256 privKey) public constant
433         returns(uint256 qx, uint256 qy);
434 
435     function deriveKey(uint256 privKey, uint256 pubX, uint256 pubY) public constant
436         returns(uint256 qx, uint256 qy);
437 
438 }
439 
440 contract TaskRegister is Upgradable, VanityLib {
441 
442     enum TaskType {
443         BITCOIN_ADDRESS_PREFIX
444     }
445 
446     struct Task {
447         TaskType taskType;
448         uint256 taskId;
449         address creator;
450         uint256 reward;
451         bytes32 data;
452         uint256 dataLength;
453         uint256 requestPublicXPoint;
454         uint256 requestPublicYPoint;
455         uint256 answerPrivateKey;
456     }
457 
458     IEC public ec;
459     ERC20 public token;
460     uint256 public nextTaskId = 1;
461     uint256 public totalReward;
462     
463     Task[] public tasks;
464     Task[] public completedTasks;
465     mapping(uint256 => uint) public indexOfTaskId; // Starting from 1
466     event TaskCreated(uint256 indexed taskId);
467     event TaskSolved(uint256 indexed taskId);
468     event TaskPayed(uint256 indexed taskId);
469 
470     function TaskRegister(address _ec, address _token, address _prevVersion) public Upgradable(_prevVersion) {
471         ec = IEC(_ec);
472         token = ERC20(_token);
473     }
474 
475     function upgrade(uint size) public onlyOwner {
476         require(upgradableState.isUpgrading);
477         require(upgradableState.prevVersion != 0);
478 
479         // Migrate some vars
480         nextTaskId = TaskRegister(upgradableState.prevVersion).nextTaskId();
481         totalReward = TaskRegister(upgradableState.prevVersion).totalReward();
482 
483         uint index = tasks.length;
484         uint tasksCount = TaskRegister(upgradableState.prevVersion).tasksCount();
485 
486         // Migrate tasks
487 
488         for (uint i = index; i < index + size && i < tasksCount; i++) {
489             tasks.push(Task(TaskType.BITCOIN_ADDRESS_PREFIX,0,0,0,bytes32(0),0,0,0,0));
490         }
491 
492         for (uint j = index; j < index + size && j < tasksCount; j++) {
493             (
494                 tasks[j].taskType,
495                 tasks[j].taskId,
496                 tasks[j].creator,
497                 tasks[j].reward,
498                 tasks[j].data,
499                 ,//tasks[j].dataLength, 
500                 ,//tasks[j].requestPublicXPoint, 
501                 ,//tasks[j].requestPublicYPoint,
502                  //tasks[j].answerPrivateKey
503             ) = TaskRegister(upgradableState.prevVersion).tasks(j);
504             indexOfTaskId[tasks[j].taskId] = j + 1;
505         }
506 
507         for (uint k = index; k < index + size && k < tasksCount; k++) {
508             (
509                 ,//tasks[k].taskType,
510                 ,//tasks[k].taskId,
511                 ,//tasks[k].creator,
512                 ,//tasks[k].reward,
513                 ,//tasks[k].data,
514                 tasks[k].dataLength, 
515                 tasks[k].requestPublicXPoint, 
516                 tasks[k].requestPublicYPoint,
517                 tasks[k].answerPrivateKey
518             ) = TaskRegister(upgradableState.prevVersion).tasks(k);
519         }
520     }
521     
522     function endUpgrade() public {
523         super.endUpgrade();
524         
525         if (upgradableState.nextVersion != 0) {
526             token.transfer(upgradableState.nextVersion, token.balanceOf(this));
527         }
528     }
529 
530     function tasksCount() public constant returns(uint) {
531         return tasks.length;
532     }
533 
534     function completedTasksCount() public constant returns(uint) {
535         return completedTasks.length;
536     }
537 
538     function payForTask(uint256 taskId, uint256 reward) public isLastestVersion {
539         require(reward > 0);
540         uint index = safeIndexOfTaskId(taskId);
541         token.transferFrom(tx.origin, this, reward);
542         tasks[index].reward += reward;
543         totalReward += reward;
544         TaskPayed(taskId);
545     }
546 
547     function safeIndexOfTaskId(uint taskId) public constant returns(uint) {
548         uint index = indexOfTaskId[taskId];
549         require(index > 0);
550         return index - 1;
551     }
552     
553     function createBitcoinAddressPrefixTask(bytes prefix, uint256 reward, uint256 requestPublicXPoint, uint256 requestPublicYPoint) public isLastestVersion {
554         require(prefix.length > 5);
555         require(prefix[0] == "1");
556         require(prefix[1] != "1"); // Do not support multiple 1s yet
557         require(isValidBicoinAddressPrefix(prefix));
558         require(isValidPublicKey(requestPublicXPoint, requestPublicYPoint));
559         if (reward > 0) {
560             token.transferFrom(tx.origin, this, reward);
561         }
562 
563         bytes32 data;
564         assembly {
565             data := mload(add(prefix, 32))
566         }
567         
568         Task memory task = Task({
569             taskType: TaskType.BITCOIN_ADDRESS_PREFIX,
570             taskId: nextTaskId,
571             creator: tx.origin,
572             reward: reward,
573             data: data,
574             dataLength: prefix.length,
575             requestPublicXPoint: requestPublicXPoint,
576             requestPublicYPoint: requestPublicYPoint,
577             answerPrivateKey: 0
578         });
579         tasks.push(task);
580         indexOfTaskId[nextTaskId] = tasks.length; // incremented to avoid 0 index
581         TaskCreated(nextTaskId);
582         nextTaskId++;
583     }
584     
585     function solveTask(uint taskId, uint256 answerPrivateKey) public isLastestVersion {
586         uint taskIndex = safeIndexOfTaskId(taskId);
587         Task storage task = tasks[taskIndex];
588 
589         // Require private key to be part of address to prevent front-running attack
590         bytes32 answerPrivateKeyBytes = bytes32(answerPrivateKey);
591         bytes32 senderAddressBytes = bytes32(uint256(msg.sender) << 96);
592         for (uint i = 0; i < 16; i++) {
593             require(answerPrivateKeyBytes[i] == senderAddressBytes[i]);
594         }
595 
596         if (task.taskType == TaskType.BITCOIN_ADDRESS_PREFIX) {
597             uint256 answerPublicXPoint;
598             uint256 answerPublicYPoint;
599             uint256 publicXPoint;
600             uint256 publicYPoint;
601             uint256 z;
602             (answerPublicXPoint, answerPublicYPoint) = ec.publicKey(answerPrivateKey);
603             (publicXPoint, publicYPoint, z) = ec._ecAdd(
604                 task.requestPublicXPoint,
605                 task.requestPublicYPoint,
606                 1,
607                 answerPublicXPoint,
608                 answerPublicYPoint,
609                 1
610             );
611 
612             uint256 m = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
613             z = ec._inverse(z);
614             publicXPoint = mulmod(publicXPoint, z, m);
615             publicYPoint = mulmod(publicYPoint, z, m);
616             require(isValidPublicKey(publicXPoint, publicYPoint));
617             
618             bytes32 btcAddress = createBtcAddress(publicXPoint, publicYPoint);
619             uint prefixLength = lengthOfCommonPrefix3232(btcAddress, task.data);
620             require(prefixLength == task.dataLength);
621             
622             task.answerPrivateKey = answerPrivateKey;
623         }
624 
625         token.transfer(msg.sender, task.reward);
626         totalReward -= task.reward;
627 
628         completeTask(taskId, taskIndex);
629         TaskSolved(taskId);
630     }
631 
632     function completeTask(uint taskId, uint index) internal {
633         completedTasks.push(tasks[index]);
634         if (index < tasks.length - 1) { // if not latest
635             tasks[index] = tasks[tasks.length - 1];
636             indexOfTaskId[tasks[index].taskId] = index + 1;
637         }
638         tasks.length -= 1;
639         delete indexOfTaskId[taskId];
640     }
641 
642     function recoverLost(ERC20Basic _token, address loser) public onlyOwner {
643         uint256 amount = _token.balanceOf(this);
644         if (_token == token) {
645             amount -= totalReward;
646         }
647         _token.transfer(loser, _token.balanceOf(this));
648     }
649 
650 }
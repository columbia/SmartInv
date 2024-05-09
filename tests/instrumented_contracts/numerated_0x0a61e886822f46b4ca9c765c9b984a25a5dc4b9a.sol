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
69     function lengthOfCommonPrefix(bytes32 a, bytes32 b) public pure returns(uint) {
70         for (uint i = 0; i < 32; i++) {
71             if (a[i] != b[i] || a[i] == 0) {
72                 return i;
73             }
74         }
75         return 0;
76     }
77     
78     function bytesToBytes32(bytes source) public pure returns(bytes32 result) {
79         assembly {
80             result := mload(add(source, 32))
81         }
82     }
83 
84     /* Converts given number to base58, limited by 32 symbols */
85     function toBase58Checked(uint256 _value, byte appCode) public pure returns(bytes32) {
86         string memory letters = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
87         bytes memory alphabet = bytes(letters);
88         uint8 base = 58;
89         uint8 len = 0;
90         uint256 remainder = 0;
91         bool needBreak = false;
92         bytes memory bytesReversed = bytes(new string(32));
93         
94         for (uint8 i = 0; true; i++) {
95             if (_value < base) {
96                 needBreak = true;
97             }
98             remainder = _value % base;
99             _value = uint256(_value / base);
100             if (len == 32) {
101                 for (uint j = 0; j < len - 1; j++) {
102                     bytesReversed[j] = bytesReversed[j + 1];
103                 }
104                 len--;
105             }
106             bytesReversed[len] = alphabet[remainder];
107             len++;
108             if (needBreak) {
109                 break;
110             }
111         }
112         
113         // Reverse
114         bytes memory result = bytes(new string(32));
115         result[0] = appCode;
116         for (i = 0; i < 31; i++) {
117             result[i + 1] = bytesReversed[len - 1 - i];
118         }
119         
120         return bytesToBytes32(result);
121     }
122 
123     // Create BTC Address: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses#How_to_create_Bitcoin_Address
124     function createBtcAddressHex(uint256 publicXPoint, uint256 publicYPoint) public pure returns(uint256) {
125         bytes20 publicKeyPart = ripemd160(sha256(byte(0x04), publicXPoint, publicYPoint));
126         bytes32 publicKeyCheckCode = sha256(sha256(byte(0x00), publicKeyPart));
127         
128         bytes memory publicKey = new bytes(32);
129         for (uint i = 0; i < 7; i++) {
130             publicKey[i] = 0x00;
131         }
132         publicKey[7] = 0x00; // Main Network
133         for (uint j = 0; j < 20; j++) {
134             publicKey[j + 8] = publicKeyPart[j];
135         }
136         publicKey[28] = publicKeyCheckCode[0];
137         publicKey[29] = publicKeyCheckCode[1];
138         publicKey[30] = publicKeyCheckCode[2];
139         publicKey[31] = publicKeyCheckCode[3];
140         
141         return uint256(bytesToBytes32(publicKey));
142     }
143     
144     function createBtcAddress(uint256 publicXPoint, uint256 publicYPoint) public pure returns(bytes32) {
145         return toBase58Checked(createBtcAddressHex(publicXPoint, publicYPoint), "1");
146     }
147 
148     function complexityForBtcAddressPrefix(bytes prefix) public pure returns(uint) {
149         return complexityForBtcAddressPrefixWithLength(prefix, prefix.length);
150     }
151 
152     // https://bitcoin.stackexchange.com/questions/48586
153     function complexityForBtcAddressPrefixWithLength(bytes prefix, uint length) public pure returns(uint) {
154         require(prefix.length >= length);
155         
156         uint8[128] memory unbase58 = [
157             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
158             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
159             255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 
160             255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 255, 255, 255, 255, 255, 255, 
161             255, 9, 10, 11, 12, 13, 14, 15, 16, 255, 17, 18, 19, 20, 21, 255, 
162             22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 255, 255, 255, 255, 255,
163             255, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 255, 44, 45, 46,
164             47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 255, 255, 255, 255, 255
165         ];
166 
167         uint leadingOnes = countBtcAddressLeadingOnes(prefix, length);
168 
169         uint256 prefixValue = 0;
170         uint256 prefix1 = 1;
171         for (uint i = 0; i < length; i++) {
172             uint index = uint(prefix[i]);
173             require(index != 255);
174             prefixValue = prefixValue * 58 + unbase58[index];
175             prefix1 *= 58;
176         }
177 
178         uint256 top = (uint256(1) << (200 - 8*leadingOnes));
179         uint256 total = 0;
180         uint256 prefixMin = prefixValue;
181         uint256 diff = 0;
182         for (uint digits = 1; prefix1/58 < (1 << 192); digits++) {
183             prefix1 *= 58;
184             prefixMin *= 58;
185             prefixValue = prefixValue * 58 + 57;
186 
187             diff = 0;
188             if (prefixValue >= top) {
189                 diff += prefixValue - top;
190             }
191             if (prefixMin < (top >> 8)) {
192                 diff += (top >> 8) - prefixMin;
193             }
194             
195             if ((58 ** digits) >= diff) {
196                 total += (58 ** digits) - diff;
197             }
198         }
199 
200         if (prefixMin == 0) { // if prefix is contains only ones: 111111
201             total = (58 ** (digits - 1)) - diff;
202         }
203 
204         return (1 << 192) / total;
205     }
206 
207     function countBtcAddressLeadingOnes(bytes prefix, uint length) public pure returns(uint) {
208         uint leadingOnes = 1;
209         for (uint j = 0; j < length && prefix[j] == 49; j++) {
210             leadingOnes = j + 1;
211         }
212         return leadingOnes;
213     }
214 
215     function isValidBicoinAddressPrefix(bytes prefixArg) public pure returns(bool) {
216         if (prefixArg.length < 5) {
217             return false;
218         }
219         if (prefixArg[0] != "1" && prefixArg[0] != "3") {
220             return false;
221         }
222         
223         for (uint i = 0; i < prefixArg.length; i++) {
224             byte ch = prefixArg[i];
225             if (ch == "0" || ch == "O" || ch == "I" || ch == "l") {
226                 return false;
227             }
228             if (!((ch >= "1" && ch <= "9") || (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z"))) {
229                 return false;
230             }
231         }
232 
233         return true;
234     }
235 
236     function isValidPublicKey(uint256 x, uint256 y) public pure returns(bool) {
237         return (mulmod(y, y, m) == addmod(mulmod(x, mulmod(x, x, m), m), 7, m));
238     }
239 
240 }
241 
242 contract IUpgradable {
243 
244     function startUpgrade() public;
245     function endUpgrade() public;
246 
247 }
248 
249 contract Upgradable is Ownable {
250 
251     struct UpgradableState {
252         bool isUpgrading;
253         address prevVersion;
254         address nextVersion;
255     }
256 
257     UpgradableState public upgradableState;
258 
259     event Initialized(address indexed prevVersion);
260     event Upgrading(address indexed nextVersion);
261     event Upgraded(address indexed nextVersion);
262 
263     modifier isLastestVersion {
264         require(!upgradableState.isUpgrading);
265         require(upgradableState.nextVersion == address(0));
266         _;
267     }
268 
269     modifier onlyOwnerOrigin {
270         require(tx.origin == owner);
271         _;
272     }
273 
274     function Upgradable(address _prevVersion) public {
275         if (_prevVersion != address(0)) {
276             require(msg.sender == Ownable(_prevVersion).owner());
277             upgradableState.isUpgrading = true;
278             upgradableState.prevVersion = _prevVersion;
279             IUpgradable(_prevVersion).startUpgrade();
280         } else {
281             Initialized(_prevVersion);
282         }
283     }
284 
285     function startUpgrade() public onlyOwnerOrigin {
286         require(msg.sender != owner);
287         require(!upgradableState.isUpgrading);
288         require(upgradableState.nextVersion == 0);
289         upgradableState.isUpgrading = true;
290         upgradableState.nextVersion = msg.sender;
291         Upgrading(msg.sender);
292     }
293 
294     //function upgrade(uint index, uint size) public onlyOwner {}
295 
296     function endUpgrade() public onlyOwnerOrigin {
297         require(upgradableState.isUpgrading);
298         upgradableState.isUpgrading = false;
299         if (msg.sender != owner) {
300             require(upgradableState.nextVersion == msg.sender);
301             Upgraded(upgradableState.nextVersion);
302         } 
303         else  {
304             if (upgradableState.prevVersion != address(0)) {
305                 Upgradable(upgradableState.prevVersion).endUpgrade();
306             }
307             Initialized(upgradableState.prevVersion);
308         }
309     }
310 
311 }
312 
313 contract IEC {
314 
315     function _inverse(uint256 a) public constant 
316         returns(uint256 invA);
317 
318     function _ecAdd(uint256 x1,uint256 y1,uint256 z1,
319                     uint256 x2,uint256 y2,uint256 z2) public constant
320         returns(uint256 x3,uint256 y3,uint256 z3);
321 
322     function _ecDouble(uint256 x1,uint256 y1,uint256 z1) public constant
323         returns(uint256 x3,uint256 y3,uint256 z3);
324 
325     function _ecMul(uint256 d, uint256 x1,uint256 y1,uint256 z1) public constant
326         returns(uint256 x3,uint256 y3,uint256 z3);
327 
328     function publicKey(uint256 privKey) public constant
329         returns(uint256 qx, uint256 qy);
330 
331     function deriveKey(uint256 privKey, uint256 pubX, uint256 pubY) public constant
332         returns(uint256 qx, uint256 qy);
333 
334 }
335 
336 contract TaskRegister is Upgradable, VanityLib {
337 
338     enum TaskType {
339         BITCOIN_ADDRESS_PREFIX
340     }
341 
342     struct Task {
343         TaskType taskType;
344         uint256 taskId;
345         address creator;
346         uint256 reward;
347         bytes32 data;
348         uint256 dataLength;
349         uint256 requestPublicXPoint;
350         uint256 requestPublicYPoint;
351         uint256 answerPrivateKey;
352     }
353 
354     IEC public ec;
355     ERC20 public token;
356     uint256 public nextTaskId = 1;
357     uint256 public totalReward;
358     
359     Task[] public tasks;
360     Task[] public completedTasks;
361     mapping(uint256 => uint) public indexOfTaskId; // Starting from 1
362     event TaskCreated(uint256 indexed taskId);
363     event TaskSolved(uint256 indexed taskId);
364     event TaskPayed(uint256 indexed taskId);
365 
366     function TaskRegister(address _ec, address _token, address _prevVersion) public Upgradable(_prevVersion) {
367         ec = IEC(_ec);
368         token = ERC20(_token);
369     }
370 
371     function upgrade(uint size) public onlyOwner {
372         require(upgradableState.isUpgrading);
373         require(upgradableState.prevVersion != 0);
374 
375         // Migrate some vars
376         nextTaskId = TaskRegister(upgradableState.prevVersion).nextTaskId();
377         totalReward = token.balanceOf(upgradableState.prevVersion);//TODO: TaskRegister(upgradableState.prevVersion).totalReward();
378 
379         uint index = tasks.length;
380         uint tasksCount = TaskRegister(upgradableState.prevVersion).tasksCount();
381 
382         // Migrate tasks
383 
384         for (uint i = index; i < index + size && i < tasksCount; i++) {
385             tasks.push(Task(TaskType.BITCOIN_ADDRESS_PREFIX,0,0,0,bytes32(0),0,0,0,0));
386         }
387 
388         for (uint j = index; j < index + size && j < tasksCount; j++) {
389             (
390                 tasks[j].taskType,
391                 tasks[j].taskId,
392                 tasks[j].creator,
393                 tasks[j].reward,
394                 tasks[j].data,
395                 ,//tasks[j].dataLength, 
396                 ,//tasks[j].requestPublicXPoint, 
397                 ,//tasks[j].requestPublicYPoint,
398                  //tasks[j].answerPrivateKey
399             ) = TaskRegister(upgradableState.prevVersion).tasks(j);
400             indexOfTaskId[tasks[j].taskId] = j + 1;
401         }
402 
403         for (uint k = index; k < index + size && k < tasksCount; k++) {
404             (
405                 ,//tasks[k].taskType,
406                 ,//tasks[k].taskId,
407                 ,//tasks[k].creator,
408                 ,//tasks[k].reward,
409                 ,//tasks[k].data,
410                 tasks[k].dataLength, 
411                 tasks[k].requestPublicXPoint, 
412                 tasks[k].requestPublicYPoint,
413                 tasks[k].answerPrivateKey
414             ) = TaskRegister(upgradableState.prevVersion).tasks(k);
415         }
416     }
417     
418     function endUpgrade() public {
419         super.endUpgrade();
420         
421         if (upgradableState.nextVersion != 0) {
422             token.transfer(upgradableState.nextVersion, token.balanceOf(this));
423         }
424     }
425 
426     function tasksCount() public constant returns(uint) {
427         return tasks.length;
428     }
429 
430     function completedTasksCount() public constant returns(uint) {
431         return completedTasks.length;
432     }
433 
434     function payForTask(uint256 taskId, uint256 reward) public isLastestVersion {
435         uint index = safeIndexOfTaskId(taskId);
436         if (reward > 0) {
437             token.transferFrom(tx.origin, this, reward);
438         } else {
439             reward = token.balanceOf(this) - totalReward;
440         }
441         tasks[index].reward += reward;
442         totalReward += reward;
443         TaskPayed(taskId);
444     }
445 
446     function safeIndexOfTaskId(uint taskId) public constant returns(uint) {
447         uint index = indexOfTaskId[taskId];
448         require(index > 0);
449         return index - 1;
450     }
451 
452     // Pass reward == 0 for automatically determine already transferred value
453     function createBitcoinAddressPrefixTask(bytes prefix, uint256 reward, uint256 requestPublicXPoint, uint256 requestPublicYPoint) public isLastestVersion {
454         require(prefix.length > 5);
455         require(prefix[0] == "1");
456         require(prefix[1] != "1"); // Do not support multiple 1s yet
457         require(isValidBicoinAddressPrefix(prefix));
458         require(isValidPublicKey(requestPublicXPoint, requestPublicYPoint));
459         if (reward > 0) {
460             token.transferFrom(tx.origin, this, reward);
461         } else {
462             reward = token.balanceOf(this) - totalReward;
463         }
464         totalReward += reward;
465 
466         bytes32 data;
467         assembly {
468             data := mload(add(prefix, 32))
469         }
470         
471         Task memory task = Task({
472             taskType: TaskType.BITCOIN_ADDRESS_PREFIX,
473             taskId: nextTaskId,
474             creator: tx.origin,
475             reward: reward,
476             data: data,
477             dataLength: prefix.length,
478             requestPublicXPoint: requestPublicXPoint,
479             requestPublicYPoint: requestPublicYPoint,
480             answerPrivateKey: 0
481         });
482         tasks.push(task);
483         indexOfTaskId[nextTaskId] = tasks.length; // incremented to avoid 0 index
484         TaskCreated(nextTaskId);
485         nextTaskId++;
486     }
487     
488     function solveTask(uint taskId, uint256 answerPrivateKey) public isLastestVersion {
489         uint taskIndex = safeIndexOfTaskId(taskId);
490         Task storage task = tasks[taskIndex];
491 
492         // Require private key to be part of address to prevent front-running attack
493         bytes32 answerPrivateKeyBytes = bytes32(answerPrivateKey);
494         bytes32 senderAddressBytes = bytes32(uint256(msg.sender) << 96);
495         for (uint i = 0; i < 16; i++) {
496             require(answerPrivateKeyBytes[i] == senderAddressBytes[i]);
497         }
498 
499         if (task.taskType == TaskType.BITCOIN_ADDRESS_PREFIX) {
500             uint256 answerPublicXPoint;
501             uint256 answerPublicYPoint;
502             uint256 publicXPoint;
503             uint256 publicYPoint;
504             uint256 z;
505             (answerPublicXPoint, answerPublicYPoint) = ec.publicKey(answerPrivateKey);
506             (publicXPoint, publicYPoint, z) = ec._ecAdd(
507                 task.requestPublicXPoint,
508                 task.requestPublicYPoint,
509                 1,
510                 answerPublicXPoint,
511                 answerPublicYPoint,
512                 1
513             );
514 
515             uint256 m = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
516             z = ec._inverse(z);
517             publicXPoint = mulmod(publicXPoint, z, m);
518             publicYPoint = mulmod(publicYPoint, z, m);
519             require(isValidPublicKey(publicXPoint, publicYPoint));
520             
521             bytes32 btcAddress = createBtcAddress(publicXPoint, publicYPoint);
522             uint prefixLength = lengthOfCommonPrefix(btcAddress, task.data);
523             require(prefixLength == task.dataLength);
524             
525             task.answerPrivateKey = answerPrivateKey;
526         }
527 
528         token.transfer(msg.sender, task.reward);
529         totalReward -= task.reward;
530 
531         completeTask(taskId, taskIndex);
532         TaskSolved(taskId);
533     }
534 
535     function completeTask(uint taskId, uint index) internal {
536         completedTasks.push(tasks[index]);
537         if (index < tasks.length - 1) { // if not latest
538             tasks[index] = tasks[tasks.length - 1];
539             indexOfTaskId[tasks[index].taskId] = index + 1;
540         }
541         tasks.length -= 1;
542         delete indexOfTaskId[taskId];
543     }
544 
545     function recoverLost(ERC20Basic _token, address loser) public onlyOwner {
546         uint256 amount = _token.balanceOf(this);
547         if (_token == token) {
548             amount -= totalReward;
549         }
550         _token.transfer(loser, _token.balanceOf(this));
551     }
552 
553 }
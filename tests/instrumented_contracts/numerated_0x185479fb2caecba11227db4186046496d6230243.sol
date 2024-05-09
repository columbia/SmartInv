1 pragma solidity ^0.5.4;
2 
3 /* The MIT License (MIT)
4 
5 Copyright (c) 2016 Smart Contract Solutions, Inc.
6 
7 Permission is hereby granted, free of charge, to any person obtaining
8 a copy of this software and associated documentation files (the
9 "Software"), to deal in the Software without restriction, including
10 without limitation the rights to use, copy, modify, merge, publish,
11 distribute, sublicense, and/or sell copies of the Software, and to
12 permit persons to whom the Software is furnished to do so, subject to
13 the following conditions:
14 
15 The above copyright notice and this permission notice shall be included
16 in all copies or substantial portions of the Software.
17 
18 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
19 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
20 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
21 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
22 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
23 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
24 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32     /**
33     * @dev Multiplies two numbers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
51     */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b > 0); // Solidity only automatically asserts when dividing by 0
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two numbers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 
89     /**
90     * @dev Returns ceil(a / b).
91     */
92     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a / b;
94         if(a % b == 0) {
95             return c;
96         }
97         else {
98             return c + 1;
99         }
100     }
101 }
102 
103 contract BaseLogic {
104 
105     bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
106 
107     mapping (address => uint256) keyNonce;
108     AccountStorage public accountStorage;
109 
110     modifier allowSelfCallsOnly() {
111         require (msg.sender == address(this), "only internal call is allowed");
112         _;
113     }
114 
115     modifier allowAccountCallsOnly(Account _account) {
116         require(msg.sender == address(_account), "caller must be account");
117         _;
118     }
119 
120     event LogicInitialised(address wallet);
121 
122     // *************** Constructor ********************** //
123 
124     constructor(AccountStorage _accountStorage) public {
125         accountStorage = _accountStorage;
126     }
127 
128     // *************** Initialization ********************* //
129 
130     function initAccount(Account _account) external allowAccountCallsOnly(_account){
131         emit LogicInitialised(address(_account));
132     }
133 
134     // *************** Getter ********************** //
135 
136     function getKeyNonce(address _key) external view returns(uint256) {
137         return keyNonce[_key];
138     }
139 
140     // *************** Signature ********************** //
141 
142     function getSignHash(bytes memory _data, uint256 _nonce) internal view returns(bytes32) {
143         // use EIP 191
144         // 0x1900 + this logic address + data + nonce of signing key
145         bytes32 msgHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _data, _nonce));
146         bytes32 prefixedHash = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, msgHash));
147         return prefixedHash;
148     }
149 
150     function verifySig(address _signingKey, bytes memory _signature, bytes32 _signHash) internal pure {
151         require(_signingKey != address(0), "invalid signing key");
152         address recoveredAddr = recover(_signHash, _signature);
153         require(recoveredAddr == _signingKey, "signature verification failed");
154     }
155 
156     /**
157      * @dev Returns the address that signed a hashed message (`hash`) with
158      * `signature`. This address can then be used for verification purposes.
159      *
160      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
161      * this function rejects them by requiring the `s` value to be in the lower
162      * half order, and the `v` value to be either 27 or 28.
163      *
164      * NOTE: This call _does not revert_ if the signature is invalid, or
165      * if the signer is otherwise unable to be retrieved. In those scenarios,
166      * the zero address is returned.
167      *
168      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
169      * verification to be secure: it is possible to craft signatures that
170      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
171      * this is by receiving a hash of the original message (which may otherwise)
172      * be too long), and then calling {toEthSignedMessageHash} on it.
173      */
174     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
175         // Check the signature length
176         if (signature.length != 65) {
177             return (address(0));
178         }
179 
180         // Divide the signature in r, s and v variables
181         bytes32 r;
182         bytes32 s;
183         uint8 v;
184 
185         // ecrecover takes the signature parameters, and the only way to get them
186         // currently is to use assembly.
187         // solhint-disable-next-line no-inline-assembly
188         assembly {
189             r := mload(add(signature, 0x20))
190             s := mload(add(signature, 0x40))
191             v := byte(0, mload(add(signature, 0x60)))
192         }
193 
194         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
195         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
196         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
197         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
198         //
199         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
200         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
201         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
202         // these malleable signatures as well.
203         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
204             return address(0);
205         }
206 
207         if (v != 27 && v != 28) {
208             return address(0);
209         }
210 
211         // If the signature is valid (and not malleable), return the signer address
212         return ecrecover(hash, v, r, s);
213     }
214 
215     /* get signer address from data
216     * @dev Gets an address encoded as the first argument in transaction data
217     * @param b The byte array that should have an address as first argument
218     * @returns a The address retrieved from the array
219     */
220     function getSignerAddress(bytes memory _b) internal pure returns (address _a) {
221         require(_b.length >= 36, "invalid bytes");
222         // solium-disable-next-line security/no-inline-assembly
223         assembly {
224             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
225             _a := and(mask, mload(add(_b, 36)))
226             // b = {length:32}{method sig:4}{address:32}{...}
227             // 36 is the offset of the first parameter of the data, if encoded properly.
228             // 32 bytes for the length of the bytes array, and the first 4 bytes for the function signature.
229             // 32 bytes is the length of the bytes array!!!!
230         }
231     }
232 
233     // get method id, first 4 bytes of data
234     function getMethodId(bytes memory _b) internal pure returns (bytes4 _a) {
235         require(_b.length >= 4, "invalid data");
236         // solium-disable-next-line security/no-inline-assembly
237         assembly {
238             // 32 bytes is the length of the bytes array
239             _a := mload(add(_b, 32))
240         }
241     }
242 
243     function checkKeyStatus(address _account, uint256 _index) internal {
244         // check operation key status
245         if (_index > 0) {
246             require(accountStorage.getKeyStatus(_account, _index) != 1, "frozen key");
247         }
248     }
249 
250     // _nonce is timestamp in microsecond(1/1000000 second)
251     function checkAndUpdateNonce(address _key, uint256 _nonce) internal {
252         require(_nonce > keyNonce[_key], "nonce too small");
253         require(SafeMath.div(_nonce, 1000000) <= now + 86400, "nonce too big"); // 86400=24*3600 seconds
254 
255         keyNonce[_key] = _nonce;
256     }
257 }
258 
259 contract Owned {
260 
261     // The owner
262     address public owner;
263 
264     event OwnerChanged(address indexed _newOwner);
265 
266     /**
267      * @dev Throws if the sender is not the owner.
268      */
269     modifier onlyOwner {
270         require(msg.sender == owner, "Must be owner");
271         _;
272     }
273 
274     constructor() public {
275         owner = msg.sender;
276     }
277 
278     /**
279      * @dev Lets the owner transfer ownership of the contract to a new owner.
280      * @param _newOwner The new owner.
281      */
282     function changeOwner(address _newOwner) external onlyOwner {
283         require(_newOwner != address(0), "Address must not be null");
284         owner = _newOwner;
285         emit OwnerChanged(_newOwner);
286     }
287 }
288 
289 contract LogicManager is Owned {
290 
291     event UpdateLogicSubmitted(address indexed logic, bool value);
292     event UpdateLogicCancelled(address indexed logic);
293     event UpdateLogicDone(address indexed logic, bool value);
294 
295     struct pending {
296         bool value;
297         uint dueTime;
298     }
299 
300     // The authorized logic modules
301     mapping (address => bool) public authorized;
302 
303     /*
304     array
305     index 0: AccountLogic address
306           1: TransferLogic address
307           2: DualsigsLogic address
308           3: DappLogic address
309           4: ...
310      */
311     address[] public authorizedLogics;
312 
313     // updated logics and their due time of becoming effective
314     mapping (address => pending) public pendingLogics;
315 
316     // pending time before updated logics take effect
317     struct pendingTime {
318         uint curPendingTime;
319         uint nextPendingTime;
320         uint dueTime;
321     }
322 
323     pendingTime public pt;
324 
325     // how many authorized logics
326     uint public logicCount;
327 
328     constructor(address[] memory _initialLogics, uint256 _pendingTime) public
329     {
330         for (uint i = 0; i < _initialLogics.length; i++) {
331             address logic = _initialLogics[i];
332             authorized[logic] = true;
333             logicCount += 1;
334         }
335         authorizedLogics = _initialLogics;
336 
337         pt.curPendingTime = _pendingTime;
338         pt.nextPendingTime = _pendingTime;
339         pt.dueTime = now;
340     }
341 
342     function submitUpdatePendingTime(uint _pendingTime) external onlyOwner {
343         pt.nextPendingTime = _pendingTime;
344         pt.dueTime = pt.curPendingTime + now;
345     }
346 
347     function triggerUpdatePendingTime() external {
348         require(pt.dueTime <= now, "too early to trigger updatePendingTime");
349         pt.curPendingTime = pt.nextPendingTime;
350     }
351 
352     function isAuthorized(address _logic) external view returns (bool) {
353         return authorized[_logic];
354     }
355 
356     function getAuthorizedLogics() external view returns (address[] memory) {
357         return authorizedLogics;
358     }
359 
360     function submitUpdate(address _logic, bool _value) external onlyOwner {
361         pending storage p = pendingLogics[_logic];
362         p.value = _value;
363         p.dueTime = now + pt.curPendingTime;
364         emit UpdateLogicSubmitted(_logic, _value);
365     }
366 
367     function cancelUpdate(address _logic) external onlyOwner {
368         delete pendingLogics[_logic];
369         emit UpdateLogicCancelled(_logic);
370     }
371 
372     function triggerUpdateLogic(address _logic) external {
373         pending memory p = pendingLogics[_logic];
374         require(p.dueTime > 0, "pending logic not found");
375         require(p.dueTime <= now, "too early to trigger updateLogic");
376         updateLogic(_logic, p.value);
377         delete pendingLogics[_logic];
378     }
379 
380     function updateLogic(address _logic, bool _value) internal {
381         if (authorized[_logic] != _value) {
382             if(_value) {
383                 logicCount += 1;
384                 authorized[_logic] = true;
385                 authorizedLogics.push(_logic);
386             }
387             else {
388                 logicCount -= 1;
389                 require(logicCount > 0, "must have at least one logic module");
390                 delete authorized[_logic];
391                 removeLogic(_logic);
392             }
393             emit UpdateLogicDone(_logic, _value);
394         }
395     }
396 
397     function removeLogic(address _logic) internal {
398         uint len = authorizedLogics.length;
399         address lastLogic = authorizedLogics[len - 1];
400         if (_logic != lastLogic) {
401             for (uint i = 0; i < len; i++) {
402                  if (_logic == authorizedLogics[i]) {
403                      authorizedLogics[i] = lastLogic;
404                      break;
405                  }
406             }
407         }
408         authorizedLogics.length--;
409     }
410 }
411 
412 
413 contract AccountStorage {
414 
415     modifier allowAccountCallsOnly(Account _account) {
416         require(msg.sender == address(_account), "caller must be account");
417         _;
418     }
419 
420     modifier allowAuthorizedLogicContractsCallsOnly(address payable _account) {
421         require(LogicManager(Account(_account).manager()).isAuthorized(msg.sender), "not an authorized logic");
422         _;
423     }
424 
425     struct KeyItem {
426         address pubKey;
427         uint256 status;
428     }
429 
430     struct BackupAccount {
431         address backup;
432         uint256 effectiveDate;//means not effective until this timestamp
433         uint256 expiryDate;//means effective until this timestamp
434     }
435 
436     struct DelayItem {
437         bytes32 hash;
438         uint256 dueTime;
439     }
440 
441     struct Proposal {
442         bytes32 hash;
443         address[] approval;
444     }
445 
446     // account => quantity of operation keys (index >= 1)
447     mapping (address => uint256) operationKeyCount;
448 
449     // account => index => KeyItem
450     mapping (address => mapping(uint256 => KeyItem)) keyData;
451 
452     // account => index => backup account
453     mapping (address => mapping(uint256 => BackupAccount)) backupData;
454 
455     /* account => actionId => DelayItem
456 
457        delayData applies to these 4 actions:
458        changeAdminKey, changeAllOperationKeys, unfreeze, changeAdminKeyByBackup
459     */
460     mapping (address => mapping(bytes4 => DelayItem)) delayData;
461 
462     // client account => proposer account => proposed actionId => Proposal
463     mapping (address => mapping(address => mapping(bytes4 => Proposal))) proposalData;
464 
465     // *************** keyCount ********************** //
466 
467     function getOperationKeyCount(address _account) external view returns(uint256) {
468         return operationKeyCount[_account];
469     }
470 
471     function increaseKeyCount(address payable _account) external allowAuthorizedLogicContractsCallsOnly(_account) {
472         operationKeyCount[_account] = operationKeyCount[_account] + 1;
473     }
474 
475     // *************** keyData ********************** //
476 
477     function getKeyData(address _account, uint256 _index) public view returns(address) {
478         KeyItem memory item = keyData[_account][_index];
479         return item.pubKey;
480     }
481 
482     function setKeyData(address payable _account, uint256 _index, address _key) external allowAuthorizedLogicContractsCallsOnly(_account) {
483         require(_key != address(0), "invalid _key value");
484         KeyItem storage item = keyData[_account][_index];
485         item.pubKey = _key;
486     }
487 
488     // *************** keyStatus ********************** //
489 
490     function getKeyStatus(address _account, uint256 _index) external view returns(uint256) {
491         KeyItem memory item = keyData[_account][_index];
492         return item.status;
493     }
494 
495     function setKeyStatus(address payable _account, uint256 _index, uint256 _status) external allowAuthorizedLogicContractsCallsOnly(_account) {
496         KeyItem storage item = keyData[_account][_index];
497         item.status = _status;
498     }
499 
500     // *************** backupData ********************** //
501 
502     function getBackupAddress(address _account, uint256 _index) external view returns(address) {
503         BackupAccount memory b = backupData[_account][_index];
504         return b.backup;
505     }
506 
507     function getBackupEffectiveDate(address _account, uint256 _index) external view returns(uint256) {
508         BackupAccount memory b = backupData[_account][_index];
509         return b.effectiveDate;
510     }
511 
512     function getBackupExpiryDate(address _account, uint256 _index) external view returns(uint256) {
513         BackupAccount memory b = backupData[_account][_index];
514         return b.expiryDate;
515     }
516 
517     function setBackup(address payable _account, uint256 _index, address _backup, uint256 _effective, uint256 _expiry)
518         external
519         allowAuthorizedLogicContractsCallsOnly(_account)
520     {
521         BackupAccount storage b = backupData[_account][_index];
522         b.backup = _backup;
523         b.effectiveDate = _effective;
524         b.expiryDate = _expiry;
525     }
526 
527     function setBackupExpiryDate(address payable _account, uint256 _index, uint256 _expiry)
528         external
529         allowAuthorizedLogicContractsCallsOnly(_account)
530     {
531         BackupAccount storage b = backupData[_account][_index];
532         b.expiryDate = _expiry;
533     }
534 
535     function clearBackupData(address payable _account, uint256 _index) external allowAuthorizedLogicContractsCallsOnly(_account) {
536         delete backupData[_account][_index];
537     }
538 
539     // *************** delayData ********************** //
540 
541     function getDelayDataHash(address payable _account, bytes4 _actionId) external view returns(bytes32) {
542         DelayItem memory item = delayData[_account][_actionId];
543         return item.hash;
544     }
545 
546     function getDelayDataDueTime(address payable _account, bytes4 _actionId) external view returns(uint256) {
547         DelayItem memory item = delayData[_account][_actionId];
548         return item.dueTime;
549     }
550 
551     function setDelayData(address payable _account, bytes4 _actionId, bytes32 _hash, uint256 _dueTime) external allowAuthorizedLogicContractsCallsOnly(_account) {
552         DelayItem storage item = delayData[_account][_actionId];
553         item.hash = _hash;
554         item.dueTime = _dueTime;
555     }
556 
557     function clearDelayData(address payable _account, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_account) {
558         delete delayData[_account][_actionId];
559     }
560 
561     // *************** proposalData ********************** //
562 
563     function getProposalDataHash(address _client, address _proposer, bytes4 _actionId) external view returns(bytes32) {
564         Proposal memory p = proposalData[_client][_proposer][_actionId];
565         return p.hash;
566     }
567 
568     function getProposalDataApproval(address _client, address _proposer, bytes4 _actionId) external view returns(address[] memory) {
569         Proposal memory p = proposalData[_client][_proposer][_actionId];
570         return p.approval;
571     }
572 
573     function setProposalData(address payable _client, address _proposer, bytes4 _actionId, bytes32 _hash, address _approvedBackup)
574         external
575         allowAuthorizedLogicContractsCallsOnly(_client)
576     {
577         Proposal storage p = proposalData[_client][_proposer][_actionId];
578         if (p.hash > 0) {
579             if (p.hash == _hash) {
580                 for (uint256 i = 0; i < p.approval.length; i++) {
581                     require(p.approval[i] != _approvedBackup, "backup already exists");
582                 }
583                 p.approval.push(_approvedBackup);
584             } else {
585                 p.hash = _hash;
586                 p.approval.length = 0;
587             }
588         } else {
589             p.hash = _hash;
590             p.approval.push(_approvedBackup);
591         }
592     }
593 
594     function clearProposalData(address payable _client, address _proposer, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_client) {
595         delete proposalData[_client][_proposer][_actionId];
596     }
597 
598 
599     // *************** init ********************** //
600     function initAccount(Account _account, address[] calldata _keys, address[] calldata _backups)
601         external
602         allowAccountCallsOnly(_account)
603     {
604         require(getKeyData(address(_account), 0) == address(0), "AccountStorage: account already initialized!");
605         require(_keys.length > 0, "empty keys array");
606 
607         operationKeyCount[address(_account)] = _keys.length - 1;
608 
609         for (uint256 index = 0; index < _keys.length; index++) {
610             address _key = _keys[index];
611             require(_key != address(0), "_key cannot be 0x0");
612             KeyItem storage item = keyData[address(_account)][index];
613             item.pubKey = _key;
614             item.status = 0;
615         }
616 
617         // avoid backup duplication if _backups.length > 1
618         // normally won't check duplication, in most cases only one initial backup when initialization
619         if (_backups.length > 1) {
620             address[] memory bkps = _backups;
621             for (uint256 i = 0; i < _backups.length; i++) {
622                 for (uint256 j = 0; j < i; j++) {
623                     require(bkps[j] != _backups[i], "duplicate backup");
624                 }
625             }
626         }
627 
628         for (uint256 index = 0; index < _backups.length; index++) {
629             address _backup = _backups[index];
630             require(_backup != address(0), "backup cannot be 0x0");
631             require(_backup != address(_account), "cannot be backup of oneself");
632 
633             backupData[address(_account)][index] = BackupAccount(_backup, now, uint256(-1));
634         }
635     }
636 }
637 
638 contract Account {
639 
640     // The implementation of the proxy
641     address public implementation;
642 
643     // Logic manager
644     address public manager;
645     
646     // The enabled static calls
647     mapping (bytes4 => address) public enabled;
648 
649     event EnabledStaticCall(address indexed module, bytes4 indexed method);
650     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
651     event Received(uint indexed value, address indexed sender, bytes data);
652 
653     event AccountInit(address indexed account);
654     event ManagerChanged(address indexed mgr);
655 
656     modifier allowAuthorizedLogicContractsCallsOnly {
657         require(LogicManager(manager).isAuthorized(msg.sender), "not an authorized logic");
658         _;
659     }
660 
661     function init(address _manager, address _accountStorage, address[] calldata _logics, address[] calldata _keys, address[] calldata _backups)
662         external
663     {
664         require(manager == address(0), "Account: account already initialized");
665         require(_manager != address(0) && _accountStorage != address(0), "Account: address is null");
666         manager = _manager;
667 
668         for (uint i = 0; i < _logics.length; i++) {
669             address logic = _logics[i];
670             require(LogicManager(manager).isAuthorized(logic), "must be authorized logic");
671 
672             BaseLogic(logic).initAccount(this);
673         }
674 
675         AccountStorage(_accountStorage).initAccount(this, _keys, _backups);
676 
677         emit AccountInit(address(this));
678     }
679 
680     function invoke(address _target, uint _value, bytes calldata _data)
681         external
682         allowAuthorizedLogicContractsCallsOnly
683         returns (bytes memory _res)
684     {
685         bool success;
686         // solium-disable-next-line security/no-call-value
687         (success, _res) = _target.call.value(_value)(_data);
688         require(success, "call to target failed");
689         emit Invoked(msg.sender, _target, _value, _data);
690     }
691 
692     /**
693     * @dev Enables a static method by specifying the target module to which the call must be delegated.
694     * @param _module The target module.
695     * @param _method The static method signature.
696     */
697     function enableStaticCall(address _module, bytes4 _method) external allowAuthorizedLogicContractsCallsOnly {
698         enabled[_method] = _module;
699         emit EnabledStaticCall(_module, _method);
700     }
701 
702     function changeManager(address _newMgr) external allowAuthorizedLogicContractsCallsOnly {
703         require(_newMgr != address(0), "address cannot be null");
704         require(_newMgr != manager, "already changed");
705         manager = _newMgr;
706         emit ManagerChanged(_newMgr);
707     }
708 
709      /**
710      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
711      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
712      * to an enabled method, or logs the call otherwise.
713      */
714     function() external payable {
715         if(msg.data.length > 0) {
716             address logic = enabled[msg.sig];
717             if(logic == address(0)) {
718                 emit Received(msg.value, msg.sender, msg.data);
719             }
720             else {
721                 require(LogicManager(manager).isAuthorized(logic), "must be an authorized logic for static call");
722                 // solium-disable-next-line security/no-inline-assembly
723                 assembly {
724                     calldatacopy(0, 0, calldatasize())
725                     let result := staticcall(gas, logic, 0, calldatasize(), 0, 0)
726                     returndatacopy(0, 0, returndatasize())
727                     switch result
728                     case 0 {revert(0, returndatasize())}
729                     default {return (0, returndatasize())}
730                 }
731             }
732         }
733     }
734 }
735 
736 contract AccountProxy {
737 
738     address implementation;
739 
740     event Received(uint indexed value, address indexed sender, bytes data);
741 
742     constructor(address _implementation) public {
743         implementation = _implementation;
744     }
745 
746     function() external payable {
747 
748         if(msg.data.length == 0 && msg.value > 0) {
749             emit Received(msg.value, msg.sender, msg.data);
750         }
751         else {
752             // solium-disable-next-line security/no-inline-assembly
753             assembly {
754                 let target := sload(0)
755                 calldatacopy(0, 0, calldatasize())
756                 let result := delegatecall(gas, target, 0, calldatasize(), 0, 0)
757                 returndatacopy(0, 0, returndatasize())
758                 switch result
759                 case 0 {revert(0, returndatasize())}
760                 default {return (0, returndatasize())}
761             }
762         }
763     }
764 }
765 
766 contract MultiOwned is Owned {
767     mapping (address => bool) public multiOwners;
768 
769     modifier onlyMultiOwners {
770         require(multiOwners[msg.sender] == true, "must be one of owners");
771         _;
772     }
773 
774     event OwnerAdded(address indexed _owner);
775     event OwnerRemoved(address indexed _owner);
776 
777     function addOwner(address _owner) external onlyOwner {
778         require(_owner != address(0), "owner must not be 0x0");
779         if(multiOwners[_owner] == false) {
780             multiOwners[_owner] = true;
781             emit OwnerAdded(_owner);
782         }        
783     }
784 
785     function removeOwner(address _owner) external onlyOwner {
786         require(multiOwners[_owner] == true, "owner not exist");
787         delete multiOwners[_owner];
788         emit OwnerRemoved(_owner);
789     }
790 }
791 
792 contract AccountCreator is MultiOwned {
793 
794     address public logicManager;
795     address public accountStorage;
796     address public accountImpl;
797     // address[] public logics;
798 
799     // *************** Events *************************** //
800     event AccountCreated(address indexed wallet, address[] keys, address[] backups);
801     event Closed(address indexed sender);
802 
803     // *************** Constructor ********************** //
804     // constructor(address _mgr, address _storage, address _accountImpl) public {
805     //     logicManager = _mgr;
806     //     accountStorage = _storage;
807     //     accountImpl = _accountImpl;
808     //     // logics = _logics;
809     // }
810 
811     // *************** External Functions ********************* //
812 
813     function createAccount(address[] calldata _keys, address[] calldata _backups) external onlyMultiOwners {
814         AccountProxy accountProxy = new AccountProxy(accountImpl);
815         Account(address(accountProxy)).init(logicManager, accountStorage, LogicManager(logicManager).getAuthorizedLogics(), _keys, _backups);
816 
817         emit AccountCreated(address(accountProxy), _keys, _backups);
818     }
819 
820     function setAddresses(address _mgr, address _storage, address _accountImpl) external onlyMultiOwners {
821         logicManager = _mgr;
822         accountStorage = _storage;
823         accountImpl = _accountImpl;
824     }
825 
826     // *************** Suicide ********************* //
827     
828     function close() external onlyMultiOwners {
829         selfdestruct(msg.sender);
830         emit Closed(msg.sender);
831     }
832 }
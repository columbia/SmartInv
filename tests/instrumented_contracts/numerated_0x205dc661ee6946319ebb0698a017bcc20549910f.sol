1 pragma solidity ^0.5.4;
2 
3 contract Account {
4 
5     // The implementation of the proxy
6     address public implementation;
7 
8     // Logic manager
9     address public manager;
10     
11     // The enabled static calls
12     mapping (bytes4 => address) public enabled;
13 
14     event EnabledStaticCall(address indexed module, bytes4 indexed method);
15     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
16     event Received(uint indexed value, address indexed sender, bytes data);
17 
18     event AccountInit(address indexed account);
19     event ManagerChanged(address indexed mgr);
20 
21     modifier allowAuthorizedLogicContractsCallsOnly {
22         require(LogicManager(manager).isAuthorized(msg.sender), "not an authorized logic");
23         _;
24     }
25 
26      /**
27      * @dev better to create and init account through AccountCreator.createAccount, which avoids race condition on Account.init
28      */
29     function init(address _manager, address _accountStorage, address[] calldata _logics, address[] calldata _keys, address[] calldata _backups)
30         external
31     {
32         require(manager == address(0), "Account: account already initialized");
33         require(_manager != address(0) && _accountStorage != address(0), "Account: address is null");
34         manager = _manager;
35 
36         for (uint i = 0; i < _logics.length; i++) {
37             address logic = _logics[i];
38             require(LogicManager(manager).isAuthorized(logic), "must be authorized logic");
39 
40             BaseLogic(logic).initAccount(this);
41         }
42 
43         AccountStorage(_accountStorage).initAccount(this, _keys, _backups);
44 
45         emit AccountInit(address(this));
46     }
47 
48     /**
49     * @dev Account calls an external target contract.
50     * @param _target The target contract address.
51     * @param _value ETH value of the call.
52     * @param _data data of the call.
53     */
54     function invoke(address _target, uint _value, bytes calldata _data)
55         external
56         allowAuthorizedLogicContractsCallsOnly
57         returns (bytes memory _res)
58     {
59         bool success;
60         // solium-disable-next-line security/no-call-value
61         (success, _res) = _target.call.value(_value)(_data);
62         require(success, "call to target failed");
63         emit Invoked(msg.sender, _target, _value, _data);
64     }
65 
66     /**
67     * @dev Enables a static method by specifying the target module to which the call must be delegated.
68     * @param _module The target module.
69     * @param _method The static method signature.
70     */
71     function enableStaticCall(address _module, bytes4 _method) external allowAuthorizedLogicContractsCallsOnly {
72         enabled[_method] = _module;
73         emit EnabledStaticCall(_module, _method);
74     }
75 
76     /**
77     * @dev Reserved method to change account's manager. Normally it's unused.
78     * Calling this method requires adding a new authorized logic.
79     * @param _newMgr New logic manager.
80     */
81     function changeManager(address _newMgr) external allowAuthorizedLogicContractsCallsOnly {
82         require(_newMgr != address(0), "address cannot be null");
83         require(_newMgr != manager, "already changed");
84         manager = _newMgr;
85         emit ManagerChanged(_newMgr);
86     }
87 
88      /**
89      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
90      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
91      * to an enabled method, or logs the call otherwise.
92      */
93     function() external payable {
94         if(msg.data.length > 0) {
95             address logic = enabled[msg.sig];
96             if(logic == address(0)) {
97                 emit Received(msg.value, msg.sender, msg.data);
98             }
99             else {
100                 require(LogicManager(manager).isAuthorized(logic), "must be an authorized logic for static call");
101                 // solium-disable-next-line security/no-inline-assembly
102                 assembly {
103                     calldatacopy(0, 0, calldatasize())
104                     let result := staticcall(gas, logic, 0, calldatasize(), 0, 0)
105                     returndatacopy(0, 0, returndatasize())
106                     switch result
107                     case 0 {revert(0, returndatasize())}
108                     default {return (0, returndatasize())}
109                 }
110             }
111         }
112     }
113 }
114 
115 contract Owned {
116 
117     // The owner
118     address public owner;
119 
120     event OwnerChanged(address indexed _newOwner);
121 
122     /**
123      * @dev Throws if the sender is not the owner.
124      */
125     modifier onlyOwner {
126         require(msg.sender == owner, "Must be owner");
127         _;
128     }
129 
130     constructor() public {
131         owner = msg.sender;
132     }
133 
134     /**
135      * @dev Lets the owner transfer ownership of the contract to a new owner.
136      * @param _newOwner The new owner.
137      */
138     function changeOwner(address _newOwner) external onlyOwner {
139         require(_newOwner != address(0), "Address must not be null");
140         owner = _newOwner;
141         emit OwnerChanged(_newOwner);
142     }
143 }
144 
145 contract LogicManager is Owned {
146 
147     event UpdateLogicSubmitted(address indexed logic, bool value);
148     event UpdateLogicCancelled(address indexed logic);
149     event UpdateLogicDone(address indexed logic, bool value);
150 
151     struct pending {
152         bool value; //True: enable a new logic; False: disable an old logic.
153         uint dueTime; //due time of a pending logic
154     }
155 
156     // The authorized logic modules
157     mapping (address => bool) public authorized;
158 
159     /*
160     array
161     index 0: AccountLogic address
162           1: TransferLogic address
163           2: DualsigsLogic address
164           3: DappLogic address
165           4: ...
166      */
167     address[] public authorizedLogics;
168 
169     // updated logics and their due time of becoming effective
170     mapping (address => pending) public pendingLogics;
171 
172     struct pendingTime {
173         uint curPendingTime; //current pending time
174         uint nextPendingTime; //new pending time
175         uint dueTime; //due time of new pending time
176     }
177 
178     pendingTime public pt;
179 
180     // how many authorized logics
181     uint public logicCount;
182 
183     constructor(address[] memory _initialLogics, uint256 _pendingTime) public
184     {
185         for (uint i = 0; i < _initialLogics.length; i++) {
186             address logic = _initialLogics[i];
187             authorized[logic] = true;
188             logicCount += 1;
189         }
190         authorizedLogics = _initialLogics;
191 
192         pt.curPendingTime = _pendingTime;
193         pt.nextPendingTime = _pendingTime;
194         pt.dueTime = now;
195     }
196 
197     /**
198      * @dev Submit a new pending time. Called only by owner.
199      * @param _pendingTime The new pending time.
200      */
201     function submitUpdatePendingTime(uint _pendingTime) external onlyOwner {
202         pt.nextPendingTime = _pendingTime;
203         pt.dueTime = pt.curPendingTime + now;
204     }
205 
206     /**
207      * @dev Trigger updating pending time.
208      */
209     function triggerUpdatePendingTime() external {
210         require(pt.dueTime <= now, "too early to trigger updatePendingTime");
211         pt.curPendingTime = pt.nextPendingTime;
212     }
213 
214     /**
215      * @dev check if a logic contract is authorized.
216      */
217     function isAuthorized(address _logic) external view returns (bool) {
218         return authorized[_logic];
219     }
220 
221     /**
222      * @dev get the authorized logic array.
223      */
224     function getAuthorizedLogics() external view returns (address[] memory) {
225         return authorizedLogics;
226     }
227 
228     /**
229      * @dev Submit a new logic. Called only by owner.
230      * @param _logic The new logic contract address.
231      * @param _value True: enable a new logic; False: disable an old logic.
232      */
233     function submitUpdate(address _logic, bool _value) external onlyOwner {
234         pending storage p = pendingLogics[_logic];
235         p.value = _value;
236         p.dueTime = now + pt.curPendingTime;
237         emit UpdateLogicSubmitted(_logic, _value);
238     }
239 
240     /**
241      * @dev Cancel a logic update. Called only by owner.
242      */
243     function cancelUpdate(address _logic) external onlyOwner {
244         delete pendingLogics[_logic];
245         emit UpdateLogicCancelled(_logic);
246     }
247 
248     /**
249      * @dev Trigger updating a new logic.
250      * @param _logic The logic contract address.
251      */
252     function triggerUpdateLogic(address _logic) external {
253         pending memory p = pendingLogics[_logic];
254         require(p.dueTime > 0, "pending logic not found");
255         require(p.dueTime <= now, "too early to trigger updateLogic");
256         updateLogic(_logic, p.value);
257         delete pendingLogics[_logic];
258     }
259 
260     /**
261      * @dev To update an existing logic, for example authorizedLogics[1],
262      * first a new logic is added to the array end, then copied to authorizedLogics[1],
263      * then the last logic is dropped, done.
264      */
265     function updateLogic(address _logic, bool _value) internal {
266         if (authorized[_logic] != _value) {
267             if(_value) {
268                 logicCount += 1;
269                 authorized[_logic] = true;
270                 authorizedLogics.push(_logic);
271             }
272             else {
273                 logicCount -= 1;
274                 require(logicCount > 0, "must have at least one logic module");
275                 delete authorized[_logic];
276                 removeLogic(_logic);
277             }
278             emit UpdateLogicDone(_logic, _value);
279         }
280     }
281 
282     function removeLogic(address _logic) internal {
283         uint len = authorizedLogics.length;
284         address lastLogic = authorizedLogics[len - 1];
285         if (_logic != lastLogic) {
286             for (uint i = 0; i < len; i++) {
287                  if (_logic == authorizedLogics[i]) {
288                      authorizedLogics[i] = lastLogic;
289                      break;
290                  }
291             }
292         }
293         authorizedLogics.length--;
294     }
295 }
296 
297 
298 contract AccountStorage {
299 
300     modifier allowAccountCallsOnly(Account _account) {
301         require(msg.sender == address(_account), "caller must be account");
302         _;
303     }
304 
305     modifier allowAuthorizedLogicContractsCallsOnly(address payable _account) {
306         require(LogicManager(Account(_account).manager()).isAuthorized(msg.sender), "not an authorized logic");
307         _;
308     }
309 
310     struct KeyItem {
311         address pubKey;
312         uint256 status;
313     }
314 
315     struct BackupAccount {
316         address backup;
317         uint256 effectiveDate;//means not effective until this timestamp
318         uint256 expiryDate;//means effective until this timestamp
319     }
320 
321     struct DelayItem {
322         bytes32 hash;
323         uint256 dueTime;
324     }
325 
326     struct Proposal {
327         bytes32 hash;
328         address[] approval;
329     }
330 
331     // account => quantity of operation keys (index >= 1)
332     mapping (address => uint256) operationKeyCount;
333 
334     // account => index => KeyItem
335     mapping (address => mapping(uint256 => KeyItem)) keyData;
336 
337     // account => index => backup account
338     mapping (address => mapping(uint256 => BackupAccount)) backupData;
339 
340     /* account => actionId => DelayItem
341 
342        delayData applies to these 4 actions:
343        changeAdminKey, changeAllOperationKeys, unfreeze, changeAdminKeyByBackup
344     */
345     mapping (address => mapping(bytes4 => DelayItem)) delayData;
346 
347     // client account => proposer account => proposed actionId => Proposal
348     mapping (address => mapping(address => mapping(bytes4 => Proposal))) proposalData;
349 
350     // *************** keyCount ********************** //
351 
352     function getOperationKeyCount(address _account) external view returns(uint256) {
353         return operationKeyCount[_account];
354     }
355 
356     function increaseKeyCount(address payable _account) external allowAuthorizedLogicContractsCallsOnly(_account) {
357         operationKeyCount[_account] = operationKeyCount[_account] + 1;
358     }
359 
360     // *************** keyData ********************** //
361 
362     function getKeyData(address _account, uint256 _index) public view returns(address) {
363         KeyItem memory item = keyData[_account][_index];
364         return item.pubKey;
365     }
366 
367     function setKeyData(address payable _account, uint256 _index, address _key) external allowAuthorizedLogicContractsCallsOnly(_account) {
368         require(_key != address(0), "invalid _key value");
369         KeyItem storage item = keyData[_account][_index];
370         item.pubKey = _key;
371     }
372 
373     // *************** keyStatus ********************** //
374 
375     function getKeyStatus(address _account, uint256 _index) external view returns(uint256) {
376         KeyItem memory item = keyData[_account][_index];
377         return item.status;
378     }
379 
380     function setKeyStatus(address payable _account, uint256 _index, uint256 _status) external allowAuthorizedLogicContractsCallsOnly(_account) {
381         KeyItem storage item = keyData[_account][_index];
382         item.status = _status;
383     }
384 
385     // *************** backupData ********************** //
386 
387     function getBackupAddress(address _account, uint256 _index) external view returns(address) {
388         BackupAccount memory b = backupData[_account][_index];
389         return b.backup;
390     }
391 
392     function getBackupEffectiveDate(address _account, uint256 _index) external view returns(uint256) {
393         BackupAccount memory b = backupData[_account][_index];
394         return b.effectiveDate;
395     }
396 
397     function getBackupExpiryDate(address _account, uint256 _index) external view returns(uint256) {
398         BackupAccount memory b = backupData[_account][_index];
399         return b.expiryDate;
400     }
401 
402     function setBackup(address payable _account, uint256 _index, address _backup, uint256 _effective, uint256 _expiry)
403         external
404         allowAuthorizedLogicContractsCallsOnly(_account)
405     {
406         BackupAccount storage b = backupData[_account][_index];
407         b.backup = _backup;
408         b.effectiveDate = _effective;
409         b.expiryDate = _expiry;
410     }
411 
412     function setBackupExpiryDate(address payable _account, uint256 _index, uint256 _expiry)
413         external
414         allowAuthorizedLogicContractsCallsOnly(_account)
415     {
416         BackupAccount storage b = backupData[_account][_index];
417         b.expiryDate = _expiry;
418     }
419 
420     function clearBackupData(address payable _account, uint256 _index) external allowAuthorizedLogicContractsCallsOnly(_account) {
421         delete backupData[_account][_index];
422     }
423 
424     // *************** delayData ********************** //
425 
426     function getDelayDataHash(address payable _account, bytes4 _actionId) external view returns(bytes32) {
427         DelayItem memory item = delayData[_account][_actionId];
428         return item.hash;
429     }
430 
431     function getDelayDataDueTime(address payable _account, bytes4 _actionId) external view returns(uint256) {
432         DelayItem memory item = delayData[_account][_actionId];
433         return item.dueTime;
434     }
435 
436     function setDelayData(address payable _account, bytes4 _actionId, bytes32 _hash, uint256 _dueTime) external allowAuthorizedLogicContractsCallsOnly(_account) {
437         DelayItem storage item = delayData[_account][_actionId];
438         item.hash = _hash;
439         item.dueTime = _dueTime;
440     }
441 
442     function clearDelayData(address payable _account, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_account) {
443         delete delayData[_account][_actionId];
444     }
445 
446     // *************** proposalData ********************** //
447 
448     function getProposalDataHash(address _client, address _proposer, bytes4 _actionId) external view returns(bytes32) {
449         Proposal memory p = proposalData[_client][_proposer][_actionId];
450         return p.hash;
451     }
452 
453     function getProposalDataApproval(address _client, address _proposer, bytes4 _actionId) external view returns(address[] memory) {
454         Proposal memory p = proposalData[_client][_proposer][_actionId];
455         return p.approval;
456     }
457 
458     function setProposalData(address payable _client, address _proposer, bytes4 _actionId, bytes32 _hash, address _approvedBackup)
459         external
460         allowAuthorizedLogicContractsCallsOnly(_client)
461     {
462         Proposal storage p = proposalData[_client][_proposer][_actionId];
463         if (p.hash > 0) {
464             if (p.hash == _hash) {
465                 for (uint256 i = 0; i < p.approval.length; i++) {
466                     require(p.approval[i] != _approvedBackup, "backup already exists");
467                 }
468                 p.approval.push(_approvedBackup);
469             } else {
470                 p.hash = _hash;
471                 p.approval.length = 0;
472             }
473         } else {
474             p.hash = _hash;
475             p.approval.push(_approvedBackup);
476         }
477     }
478 
479     function clearProposalData(address payable _client, address _proposer, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_client) {
480         delete proposalData[_client][_proposer][_actionId];
481     }
482 
483 
484     // *************** init ********************** //
485 
486     /**
487      * @dev Write account data into storage.
488      * @param _account The Account.
489      * @param _keys The initial keys.
490      * @param _backups The initial backups.
491      */
492     function initAccount(Account _account, address[] calldata _keys, address[] calldata _backups)
493         external
494         allowAccountCallsOnly(_account)
495     {
496         require(getKeyData(address(_account), 0) == address(0), "AccountStorage: account already initialized!");
497         require(_keys.length > 0, "empty keys array");
498 
499         operationKeyCount[address(_account)] = _keys.length - 1;
500 
501         for (uint256 index = 0; index < _keys.length; index++) {
502             address _key = _keys[index];
503             require(_key != address(0), "_key cannot be 0x0");
504             KeyItem storage item = keyData[address(_account)][index];
505             item.pubKey = _key;
506             item.status = 0;
507         }
508 
509         // avoid backup duplication if _backups.length > 1
510         // normally won't check duplication, in most cases only one initial backup when initialization
511         if (_backups.length > 1) {
512             address[] memory bkps = _backups;
513             for (uint256 i = 0; i < _backups.length; i++) {
514                 for (uint256 j = 0; j < i; j++) {
515                     require(bkps[j] != _backups[i], "duplicate backup");
516                 }
517             }
518         }
519 
520         for (uint256 index = 0; index < _backups.length; index++) {
521             address _backup = _backups[index];
522             require(_backup != address(0), "backup cannot be 0x0");
523             require(_backup != address(_account), "cannot be backup of oneself");
524 
525             backupData[address(_account)][index] = BackupAccount(_backup, now, uint256(-1));
526         }
527     }
528 }
529 
530 /* The MIT License (MIT)
531 
532 Copyright (c) 2016 Smart Contract Solutions, Inc.
533 
534 Permission is hereby granted, free of charge, to any person obtaining
535 a copy of this software and associated documentation files (the
536 "Software"), to deal in the Software without restriction, including
537 without limitation the rights to use, copy, modify, merge, publish,
538 distribute, sublicense, and/or sell copies of the Software, and to
539 permit persons to whom the Software is furnished to do so, subject to
540 the following conditions:
541 
542 The above copyright notice and this permission notice shall be included
543 in all copies or substantial portions of the Software.
544 
545 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
546 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
547 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
548 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
549 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
550 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
551 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
552 
553 /**
554  * @title SafeMath
555  * @dev Math operations with safety checks that throw on error
556  */
557 library SafeMath {
558 
559     /**
560     * @dev Multiplies two numbers, reverts on overflow.
561     */
562     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
563         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
564         // benefit is lost if 'b' is also tested.
565         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
566         if (a == 0) {
567             return 0;
568         }
569 
570         uint256 c = a * b;
571         require(c / a == b);
572 
573         return c;
574     }
575 
576     /**
577     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
578     */
579     function div(uint256 a, uint256 b) internal pure returns (uint256) {
580         require(b > 0); // Solidity only automatically asserts when dividing by 0
581         uint256 c = a / b;
582         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
583 
584         return c;
585     }
586 
587     /**
588     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
589     */
590     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
591         require(b <= a);
592         uint256 c = a - b;
593 
594         return c;
595     }
596 
597     /**
598     * @dev Adds two numbers, reverts on overflow.
599     */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601         uint256 c = a + b;
602         require(c >= a);
603 
604         return c;
605     }
606 
607     /**
608     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
609     * reverts when dividing by zero.
610     */
611     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
612         require(b != 0);
613         return a % b;
614     }
615 
616     /**
617     * @dev Returns ceil(a / b).
618     */
619     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
620         uint256 c = a / b;
621         if(a % b == 0) {
622             return c;
623         }
624         else {
625             return c + 1;
626         }
627     }
628 }
629 
630 
631 contract BaseLogic {
632 
633     bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
634 
635     mapping (address => uint256) keyNonce;
636     AccountStorage public accountStorage;
637 
638     modifier allowSelfCallsOnly() {
639         require (msg.sender == address(this), "only internal call is allowed");
640         _;
641     }
642 
643     modifier allowAccountCallsOnly(Account _account) {
644         require(msg.sender == address(_account), "caller must be account");
645         _;
646     }
647 
648     // *************** Constructor ********************** //
649 
650     constructor(AccountStorage _accountStorage) public {
651         accountStorage = _accountStorage;
652     }
653 
654     // *************** Initialization ********************* //
655 
656     function initAccount(Account _account) external allowAccountCallsOnly(_account){
657     }
658 
659     // *************** Getter ********************** //
660 
661     function getKeyNonce(address _key) external view returns(uint256) {
662         return keyNonce[_key];
663     }
664 
665     // *************** Signature ********************** //
666 
667     function getSignHash(bytes memory _data, uint256 _nonce) internal view returns(bytes32) {
668         // use EIP 191
669         // 0x1900 + this logic address + data + nonce of signing key
670         bytes32 msgHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _data, _nonce));
671         bytes32 prefixedHash = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, msgHash));
672         return prefixedHash;
673     }
674 
675     function verifySig(address _signingKey, bytes memory _signature, bytes32 _signHash) internal pure {
676         require(_signingKey != address(0), "invalid signing key");
677         address recoveredAddr = recover(_signHash, _signature);
678         require(recoveredAddr == _signingKey, "signature verification failed");
679     }
680 
681     /**
682      * @dev Returns the address that signed a hashed message (`hash`) with
683      * `signature`. This address can then be used for verification purposes.
684      *
685      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
686      * this function rejects them by requiring the `s` value to be in the lower
687      * half order, and the `v` value to be either 27 or 28.
688      *
689      * NOTE: This call _does not revert_ if the signature is invalid, or
690      * if the signer is otherwise unable to be retrieved. In those scenarios,
691      * the zero address is returned.
692      *
693      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
694      * verification to be secure: it is possible to craft signatures that
695      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
696      * this is by receiving a hash of the original message (which may otherwise)
697      * be too long), and then calling {toEthSignedMessageHash} on it.
698      */
699     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
700         // Check the signature length
701         if (signature.length != 65) {
702             return (address(0));
703         }
704 
705         // Divide the signature in r, s and v variables
706         bytes32 r;
707         bytes32 s;
708         uint8 v;
709 
710         // ecrecover takes the signature parameters, and the only way to get them
711         // currently is to use assembly.
712         // solhint-disable-next-line no-inline-assembly
713         assembly {
714             r := mload(add(signature, 0x20))
715             s := mload(add(signature, 0x40))
716             v := byte(0, mload(add(signature, 0x60)))
717         }
718 
719         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
720         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
721         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
722         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
723         //
724         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
725         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
726         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
727         // these malleable signatures as well.
728         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
729             return address(0);
730         }
731 
732         if (v != 27 && v != 28) {
733             return address(0);
734         }
735 
736         // If the signature is valid (and not malleable), return the signer address
737         return ecrecover(hash, v, r, s);
738     }
739 
740     /* get signer address from data
741     * @dev Gets an address encoded as the first argument in transaction data
742     * @param b The byte array that should have an address as first argument
743     * @returns a The address retrieved from the array
744     */
745     function getSignerAddress(bytes memory _b) internal pure returns (address _a) {
746         require(_b.length >= 36, "invalid bytes");
747         // solium-disable-next-line security/no-inline-assembly
748         assembly {
749             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
750             _a := and(mask, mload(add(_b, 36)))
751             // b = {length:32}{method sig:4}{address:32}{...}
752             // 36 is the offset of the first parameter of the data, if encoded properly.
753             // 32 bytes for the length of the bytes array, and the first 4 bytes for the function signature.
754             // 32 bytes is the length of the bytes array!!!!
755         }
756     }
757 
758     // get method id, first 4 bytes of data
759     function getMethodId(bytes memory _b) internal pure returns (bytes4 _a) {
760         require(_b.length >= 4, "invalid data");
761         // solium-disable-next-line security/no-inline-assembly
762         assembly {
763             // 32 bytes is the length of the bytes array
764             _a := mload(add(_b, 32))
765         }
766     }
767 
768     function checkKeyStatus(address _account, uint256 _index) internal view {
769         // check operation key status
770         if (_index > 0) {
771             require(accountStorage.getKeyStatus(_account, _index) != 1, "frozen key");
772         }
773     }
774 
775     // _nonce is timestamp in microsecond(1/1000000 second)
776     function checkAndUpdateNonce(address _key, uint256 _nonce) internal {
777         require(_nonce > keyNonce[_key], "nonce too small");
778         require(SafeMath.div(_nonce, 1000000) <= now + 86400, "nonce too big"); // 86400=24*3600 seconds
779 
780         keyNonce[_key] = _nonce;
781     }
782 }
783 
784 contract AccountBaseLogic is BaseLogic {
785 
786     uint256 constant internal DELAY_CHANGE_ADMIN_KEY = 21 days;
787     uint256 constant internal DELAY_CHANGE_OPERATION_KEY = 7 days;
788     uint256 constant internal DELAY_UNFREEZE_KEY = 7 days;
789     uint256 constant internal DELAY_CHANGE_BACKUP = 21 days;
790     uint256 constant internal DELAY_CHANGE_ADMIN_KEY_BY_BACKUP = 30 days;
791 
792     uint256 constant internal MAX_DEFINED_BACKUP_INDEX = 5;
793 
794 	// Equals to bytes4(keccak256("changeAdminKey(address,address)"))
795 	bytes4 internal constant CHANGE_ADMIN_KEY = 0xd595d935;
796 	// Equals to bytes4(keccak256("changeAdminKeyByBackup(address,address)"))
797 	bytes4 internal constant CHANGE_ADMIN_KEY_BY_BACKUP = 0xfdd54ba1;
798 	// Equals to bytes4(keccak256("changeAdminKeyWithoutDelay(address,address)"))
799 	bytes4 internal constant CHANGE_ADMIN_KEY_WITHOUT_DELAY = 0x441d2e50;
800 	// Equals to bytes4(keccak256("changeAllOperationKeysWithoutDelay(address,address[])"))
801 	bytes4 internal constant CHANGE_ALL_OPERATION_KEYS_WITHOUT_DELAY = 0x02064abc;
802 	// Equals to bytes4(keccak256("unfreezeWithoutDelay(address)"))
803 	bytes4 internal constant UNFREEZE_WITHOUT_DELAY = 0x69521650;
804 	// Equals to bytes4(keccak256("changeAllOperationKeys(address,address[])"))
805 	bytes4 internal constant CHANGE_ALL_OPERATION_KEYS = 0xd3b9d4d6;
806 	// Equals to bytes4(keccak256("unfreeze(address)"))
807 	bytes4 internal constant UNFREEZE = 0x45c8b1a6;
808 
809     // *************** Constructor ********************** //
810 
811 	constructor(AccountStorage _accountStorage)
812 		BaseLogic(_accountStorage)
813 		public
814 	{
815 	}
816 
817     // *************** Functions ********************** //
818 
819     /**
820     * @dev Check if a certain account is another's backup.
821     */
822     function checkRelation(address _client, address _backup) internal view {
823         require(_backup != address(0), "backup cannot be 0x0");
824         require(_client != address(0), "client cannot be 0x0");
825         bool isBackup;
826         for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
827             address backup = accountStorage.getBackupAddress(_client, i);
828             uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_client, i);
829             uint256 expiryDate = accountStorage.getBackupExpiryDate(_client, i);
830             // backup match and effective and not expired
831             if (_backup == backup && isEffectiveBackup(effectiveDate, expiryDate)) {
832                 isBackup = true;
833                 break;
834             }
835         }
836         require(isBackup, "backup does not exist in list");
837     }
838 
839     function isEffectiveBackup(uint256 _effectiveDate, uint256 _expiryDate) internal view returns(bool) {
840         return (_effectiveDate <= now) && (_expiryDate > now);
841     }
842 
843     function clearRelatedProposalAfterAdminKeyChanged(address payable _client) internal {
844         //clear any existing proposal proposed by both, proposer is _client
845         accountStorage.clearProposalData(_client, _client, CHANGE_ADMIN_KEY_WITHOUT_DELAY);
846         accountStorage.clearProposalData(_client, _client, CHANGE_ALL_OPERATION_KEYS_WITHOUT_DELAY);
847         accountStorage.clearProposalData(_client, _client, UNFREEZE_WITHOUT_DELAY);
848 
849         //clear any existing proposal proposed by backup, proposer is one of the backups
850         for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
851             address backup = accountStorage.getBackupAddress(_client, i);
852             if (backup != address(0)) {
853                 accountStorage.clearProposalData(_client, backup, CHANGE_ADMIN_KEY_BY_BACKUP);
854             }
855         }
856     }
857 
858 }
859 
860 /**
861 * @title AccountLogic
862 */
863 contract AccountLogic is AccountBaseLogic {
864 
865 	// Equals to bytes4(keccak256("addOperationKey(address,address)"))
866 	bytes4 private constant ADD_OPERATION_KEY = 0x9a7f6101;
867 	// Equals to bytes4(keccak256("proposeAsBackup(address,address,bytes)"))
868 	bytes4 private constant PROPOSE_AS_BACKUP = 0xd470470f;
869 	// Equals to bytes4(keccak256("approveProposal(address,address,address,bytes)"))
870 	bytes4 private constant APPROVE_PROPOSAL = 0x3713f742;
871 
872 
873     event AccountLogicEntered(bytes data, uint256 indexed nonce);
874 	event ChangeAdminKeyTriggered(address indexed account, address pkNew);
875 	event ChangeAllOperationKeysTriggered(address indexed account, address[] pks);
876 	event UnfreezeTriggered(address indexed account);
877 
878 	event ChangeAdminKey(address indexed account, address indexed pkNew);
879 	event AddOperationKey(address indexed account, address indexed pkNew);
880 	event ChangeAllOperationKeys(address indexed account, address[] pks);
881 	event Freeze(address indexed account);
882 	event Unfreeze(address indexed account);
883 	event RemoveBackup(address indexed account, address indexed backup);
884 	event CancelDelay(address indexed account, bytes4 actionId);
885 	event CancelAddBackup(address indexed account, address indexed backup);
886 	event CancelRemoveBackup(address indexed account, address indexed backup);
887 	event ProposeAsBackup(address indexed backup, address indexed client, bytes data);
888 	event ApproveProposal(address indexed backup, address indexed client, address indexed proposer, bytes data);
889 	event CancelProposal(address indexed client, address indexed proposer, bytes4 proposedActionId);
890 
891 	// *************** Constructor ********************** //
892 
893 	constructor(AccountStorage _accountStorage)
894 		AccountBaseLogic(_accountStorage)
895 		public
896 	{
897 	}
898 
899 	// *************** action entry ********************** //
900 
901     /**
902     * @dev Entry method of AccountLogic.
903     * AccountLogic has 12 actions called from 'enter':
904         changeAdminKey, addOperationKey, changeAllOperationKeys, freeze, unfreeze,
905 		removeBackup, cancelDelay, cancelAddBackup, cancelRemoveBackup,
906 		proposeAsBackup, approveProposal, cancelProposal
907     */
908 	function enter(bytes calldata _data, bytes calldata _signature, uint256 _nonce) external {
909 		address account = getSignerAddress(_data);
910 		uint256 keyIndex = getKeyIndex(_data);
911 		checkKeyStatus(account, keyIndex);
912 		address signingKey = accountStorage.getKeyData(account, keyIndex);
913 		checkAndUpdateNonce(signingKey, _nonce);
914 		bytes32 signHash = getSignHash(_data, _nonce);
915 		verifySig(signingKey, _signature, signHash);
916 
917 		// solium-disable-next-line security/no-low-level-calls
918 		(bool success,) = address(this).call(_data);
919 		require(success, "calling self failed");
920 		emit AccountLogicEntered(_data, _nonce);
921 	}
922 
923 	// *************** change admin key ********************** //
924 
925     // called from 'enter'
926 	function changeAdminKey(address payable _account, address _pkNew) external allowSelfCallsOnly {
927 		require(_pkNew != address(0), "0x0 is invalid");
928 		address pk = accountStorage.getKeyData(_account, 0);
929 		require(pk != _pkNew, "identical admin key exists");
930 		require(accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY) == 0, "delay data already exists");
931 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKey', _account, _pkNew));
932 		accountStorage.setDelayData(_account, CHANGE_ADMIN_KEY, hash, now + DELAY_CHANGE_ADMIN_KEY);
933 		emit ChangeAdminKey(_account, _pkNew);
934 	}
935 
936     // called from external
937 	function triggerChangeAdminKey(address payable _account, address _pkNew) external {
938 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKey', _account, _pkNew));
939 		require(hash == accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY), "delay hash unmatch");
940 
941 		uint256 due = accountStorage.getDelayDataDueTime(_account, CHANGE_ADMIN_KEY);
942 		require(due > 0, "delay data not found");
943 		require(due <= now, "too early to trigger changeAdminKey");
944 		accountStorage.setKeyData(_account, 0, _pkNew);
945 		//clear any existing related delay data and proposal
946 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY);
947 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY_BY_BACKUP);
948 		clearRelatedProposalAfterAdminKeyChanged(_account);
949 		emit ChangeAdminKeyTriggered(_account, _pkNew);
950 	}
951 
952 	// *************** add operation key ********************** //
953 
954     // called from 'enter'
955 	function addOperationKey(address payable _account, address _pkNew) external allowSelfCallsOnly {
956 		uint256 index = accountStorage.getOperationKeyCount(_account) + 1;
957 		require(index > 0, "invalid operation key index");
958 		// set a limit to prevent unnecessary trouble
959 		require(index < 20, "index exceeds limit");
960 		require(_pkNew != address(0), "0x0 is invalid");
961 		address pk = accountStorage.getKeyData(_account, index);
962 		require(pk == address(0), "operation key already exists");
963 		accountStorage.setKeyData(_account, index, _pkNew);
964 		accountStorage.increaseKeyCount(_account);
965 		emit AddOperationKey(_account, _pkNew);
966 	}
967 
968 	// *************** change all operation keys ********************** //
969 
970     // called from 'enter'
971 	function changeAllOperationKeys(address payable _account, address[] calldata _pks) external allowSelfCallsOnly {
972 		uint256 keyCount = accountStorage.getOperationKeyCount(_account);
973 		require(_pks.length == keyCount, "invalid number of keys");
974 		require(accountStorage.getDelayDataHash(_account, CHANGE_ALL_OPERATION_KEYS) == 0, "delay data already exists");
975 		address pk;
976 		for (uint256 i = 0; i < keyCount; i++) {
977 			pk = _pks[i];
978 			require(pk != address(0), "0x0 is invalid");
979 		}
980 		bytes32 hash = keccak256(abi.encodePacked('changeAllOperationKeys', _account, _pks));
981 		accountStorage.setDelayData(_account, CHANGE_ALL_OPERATION_KEYS, hash, now + DELAY_CHANGE_OPERATION_KEY);
982 		emit ChangeAllOperationKeys(_account, _pks);
983 	}
984 
985     // called from external
986 	function triggerChangeAllOperationKeys(address payable _account, address[] calldata _pks) external {
987 		bytes32 hash = keccak256(abi.encodePacked('changeAllOperationKeys', _account, _pks));
988 		require(hash == accountStorage.getDelayDataHash(_account, CHANGE_ALL_OPERATION_KEYS), "delay hash unmatch");
989 
990 		uint256 due = accountStorage.getDelayDataDueTime(_account, CHANGE_ALL_OPERATION_KEYS);
991 		require(due > 0, "delay data not found");
992 		require(due <= now, "too early to trigger changeAllOperationKeys");
993 		address pk;
994 		for (uint256 i = 0; i < accountStorage.getOperationKeyCount(_account); i++) {
995 			pk = _pks[i];
996 			accountStorage.setKeyData(_account, i+1, pk);
997 			accountStorage.setKeyStatus(_account, i+1, 0);
998 		}
999 		accountStorage.clearDelayData(_account, CHANGE_ALL_OPERATION_KEYS);
1000 		emit ChangeAllOperationKeysTriggered(_account, _pks);
1001 	}
1002 
1003 	// *************** freeze/unfreeze all operation keys ********************** //
1004 
1005     // called from 'enter'
1006 	function freeze(address payable _account) external allowSelfCallsOnly {
1007 		for (uint256 i = 1; i <= accountStorage.getOperationKeyCount(_account); i++) {
1008 			if (accountStorage.getKeyStatus(_account, i) == 0) {
1009 				accountStorage.setKeyStatus(_account, i, 1);
1010 			}
1011 		}
1012 		emit Freeze(_account);
1013 	}
1014 
1015     // called from 'enter'
1016 	function unfreeze(address payable _account) external allowSelfCallsOnly {
1017 		require(accountStorage.getDelayDataHash(_account, UNFREEZE) == 0, "delay data already exists");
1018 		bytes32 hash = keccak256(abi.encodePacked('unfreeze', _account));
1019 		accountStorage.setDelayData(_account, UNFREEZE, hash, now + DELAY_UNFREEZE_KEY);
1020 		emit Unfreeze(_account);
1021 	}
1022 
1023     // called from external
1024 	function triggerUnfreeze(address payable _account) external {
1025 		bytes32 hash = keccak256(abi.encodePacked('unfreeze', _account));
1026 		require(hash == accountStorage.getDelayDataHash(_account, UNFREEZE), "delay hash unmatch");
1027 
1028 		uint256 due = accountStorage.getDelayDataDueTime(_account, UNFREEZE);
1029 		require(due > 0, "delay data not found");
1030 		require(due <= now, "too early to trigger unfreeze");
1031 
1032 		for (uint256 i = 1; i <= accountStorage.getOperationKeyCount(_account); i++) {
1033 			if (accountStorage.getKeyStatus(_account, i) == 1) {
1034 				accountStorage.setKeyStatus(_account, i, 0);
1035 			}
1036 		}
1037 		accountStorage.clearDelayData(_account, UNFREEZE);
1038 		emit UnfreezeTriggered(_account);
1039 	}
1040 
1041 	// *************** remove backup ********************** //
1042 
1043     // called from 'enter'
1044 	function removeBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1045 		uint256 index = findBackup(_account, _backup);
1046 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1047 
1048 		uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_account, index);
1049 		// should be an effective backup
1050 		require(effectiveDate <= now, "not effective yet");
1051 
1052 		uint256 expiryDate = accountStorage.getBackupExpiryDate(_account, index);
1053 		/*
1054 		 already expired: now > expiryDate;
1055 		 to be expired: now < expiryDate && expiryDate < uint256(-1)
1056 		 */
1057 		require(expiryDate == uint256(-1), "already expired or to be expired");
1058 
1059 		accountStorage.setBackupExpiryDate(_account, index, now + DELAY_CHANGE_BACKUP);
1060 		emit RemoveBackup(_account, _backup);
1061 	}
1062 
1063     // return backupData index(0~5), 6 means not found
1064     // do make sure _backup is not 0x0
1065 	function findBackup(address _account, address _backup) public view returns(uint) {
1066 		uint index = MAX_DEFINED_BACKUP_INDEX + 1;
1067 		if (_backup == address(0)) {
1068 			return index;
1069 		}
1070 		address b;
1071 		for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
1072 			b = accountStorage.getBackupAddress(_account, i);
1073 			if (b == _backup) {
1074 				index = i;
1075 				break;
1076 			}
1077 		}
1078 		return index;
1079 	}
1080 
1081 	// *************** cancel delay action ********************** //
1082 
1083     // called from 'enter'
1084 	function cancelDelay(address payable _account, bytes4 _actionId) external allowSelfCallsOnly {
1085 		accountStorage.clearDelayData(_account, _actionId);
1086 		emit CancelDelay(_account, _actionId);
1087 	}
1088 
1089     // called from 'enter'
1090 	function cancelAddBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1091 		uint256 index = findBackup(_account, _backup);
1092 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1093 		uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_account, index);
1094 		require(effectiveDate > now, "already effective");
1095 		accountStorage.clearBackupData(_account, index);
1096 		emit CancelAddBackup(_account, _backup);
1097 	}
1098 
1099     // called from 'enter'
1100 	function cancelRemoveBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1101 		uint256 index = findBackup(_account, _backup);
1102 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1103 		uint256 expiryDate = accountStorage.getBackupExpiryDate(_account, index);
1104 		require(expiryDate > now, "already expired");
1105 		accountStorage.setBackupExpiryDate(_account, index, uint256(-1));
1106 		emit CancelRemoveBackup(_account, _backup);
1107 	}
1108 
1109 	// *************** propose a proposal by one of the backups ********************** //
1110 
1111     /**
1112     * @dev Propose a proposal. The proposer is one of client's backups.
1113 	* called from 'enter'. _backup's sig is checked in 'enter'.
1114     * @param _backup backup address
1115     * @param _client client address
1116 	* @param _functionData The proposed action data.
1117     */
1118 	function proposeAsBackup(address _backup, address payable _client, bytes calldata _functionData) external allowSelfCallsOnly {
1119 		require(getSignerAddress(_functionData) == _client, "invalid _client");
1120 
1121 		bytes4 proposedActionId = getMethodId(_functionData);
1122 		require(proposedActionId == CHANGE_ADMIN_KEY_BY_BACKUP, "invalid proposal by backup");
1123 		checkRelation(_client, _backup);
1124 		bytes32 functionHash = keccak256(_functionData);
1125 		accountStorage.setProposalData(_client, _backup, proposedActionId, functionHash, _backup);
1126 		emit ProposeAsBackup(_backup, _client, _functionData);
1127 	}
1128 
1129 	// *************** approve/cancel proposal ********************** //
1130 
1131     /**
1132     * @dev Approve a proposal.
1133 	* called from 'enter'. _backup's sig is checked in 'enter'.
1134     * @param _backup backup address
1135     * @param _client client address
1136 	* @param _proposer If 'proposeAsBackup', proposer is backup; if 'proposeByBoth', proposer is client.
1137 	* @param _functionData The proposed action data.
1138     */
1139 	function approveProposal(address _backup, address payable _client, address _proposer, bytes calldata _functionData) external allowSelfCallsOnly {
1140 		require(getSignerAddress(_functionData) == _client, "invalid _client");
1141 
1142 		bytes32 functionHash = keccak256(_functionData);
1143 		require(functionHash != 0, "invalid hash");
1144 		checkRelation(_client, _backup);
1145 		if (_proposer != _client) {
1146 			checkRelation(_client, _proposer);
1147 		}
1148 
1149 		bytes4 proposedActionId = getMethodId(_functionData);
1150 		bytes32 hash = accountStorage.getProposalDataHash(_client, _proposer, proposedActionId);
1151 		require(hash == functionHash, "proposal unmatch");
1152 		accountStorage.setProposalData(_client, _proposer, proposedActionId, functionHash, _backup);
1153 		emit ApproveProposal(_backup, _client, _proposer, _functionData);
1154 	}
1155 
1156     // called from 'enter'
1157 	function cancelProposal(address payable _client, address _proposer, bytes4 _proposedActionId) external allowSelfCallsOnly {
1158 		require(_client != _proposer, "cannot cancel dual signed proposal");
1159 		accountStorage.clearProposalData(_client, _proposer, _proposedActionId);
1160 		emit CancelProposal(_client, _proposer, _proposedActionId);
1161 	}
1162 
1163 	// *************** internal functions ********************** //
1164 
1165     /*
1166     index 0: admin key
1167           1: asset(transfer)
1168           2: adding
1169           3: reserved(dapp)
1170           4: assist
1171      */
1172 	function getKeyIndex(bytes memory _data) internal pure returns (uint256) {
1173 		uint256 index; //index default value is 0, admin key
1174 		bytes4 methodId = getMethodId(_data);
1175 		if (methodId == ADD_OPERATION_KEY) {
1176   			index = 2; //adding key
1177 		} else if (methodId == PROPOSE_AS_BACKUP || methodId == APPROVE_PROPOSAL) {
1178   			index = 4; //assist key
1179 		}
1180 		return index;
1181 	}
1182 
1183 }
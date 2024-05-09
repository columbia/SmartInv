1 pragma solidity ^0.5.4;
2 
3 
4 contract Account {
5 
6     // The implementation of the proxy
7     address public implementation;
8 
9     // Logic manager
10     address public manager;
11     
12     // The enabled static calls
13     mapping (bytes4 => address) public enabled;
14 
15     event EnabledStaticCall(address indexed module, bytes4 indexed method);
16     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
17     event Received(uint indexed value, address indexed sender, bytes data);
18 
19     event AccountInit(address indexed account);
20     event ManagerChanged(address indexed mgr);
21 
22     modifier allowAuthorizedLogicContractsCallsOnly {
23         require(LogicManager(manager).isAuthorized(msg.sender), "not an authorized logic");
24         _;
25     }
26 
27     function init(address _manager, address _accountStorage, address[] calldata _logics, address[] calldata _keys, address[] calldata _backups)
28         external
29     {
30         require(manager == address(0), "Account: account already initialized");
31         require(_manager != address(0) && _accountStorage != address(0), "Account: address is null");
32         manager = _manager;
33 
34         for (uint i = 0; i < _logics.length; i++) {
35             address logic = _logics[i];
36             require(LogicManager(manager).isAuthorized(logic), "must be authorized logic");
37 
38             BaseLogic(logic).initAccount(this);
39         }
40 
41         AccountStorage(_accountStorage).initAccount(this, _keys, _backups);
42 
43         emit AccountInit(address(this));
44     }
45 
46     function invoke(address _target, uint _value, bytes calldata _data)
47         external
48         allowAuthorizedLogicContractsCallsOnly
49         returns (bytes memory _res)
50     {
51         bool success;
52         // solium-disable-next-line security/no-call-value
53         (success, _res) = _target.call.value(_value)(_data);
54         require(success, "call to target failed");
55         emit Invoked(msg.sender, _target, _value, _data);
56     }
57 
58     /**
59     * @dev Enables a static method by specifying the target module to which the call must be delegated.
60     * @param _module The target module.
61     * @param _method The static method signature.
62     */
63     function enableStaticCall(address _module, bytes4 _method) external allowAuthorizedLogicContractsCallsOnly {
64         enabled[_method] = _module;
65         emit EnabledStaticCall(_module, _method);
66     }
67 
68     function changeManager(address _newMgr) external allowAuthorizedLogicContractsCallsOnly {
69         require(_newMgr != address(0), "address cannot be null");
70         require(_newMgr != manager, "already changed");
71         manager = _newMgr;
72         emit ManagerChanged(_newMgr);
73     }
74 
75      /**
76      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
77      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
78      * to an enabled method, or logs the call otherwise.
79      */
80     function() external payable {
81         if(msg.data.length > 0) {
82             address logic = enabled[msg.sig];
83             if(logic == address(0)) {
84                 emit Received(msg.value, msg.sender, msg.data);
85             }
86             else {
87                 require(LogicManager(manager).isAuthorized(logic), "must be an authorized logic for static call");
88                 // solium-disable-next-line security/no-inline-assembly
89                 assembly {
90                     calldatacopy(0, 0, calldatasize())
91                     let result := staticcall(gas, logic, 0, calldatasize(), 0, 0)
92                     returndatacopy(0, 0, returndatasize())
93                     switch result
94                     case 0 {revert(0, returndatasize())}
95                     default {return (0, returndatasize())}
96                 }
97             }
98         }
99     }
100 }
101 
102 
103 contract Owned {
104 
105     // The owner
106     address public owner;
107 
108     event OwnerChanged(address indexed _newOwner);
109 
110     /**
111      * @dev Throws if the sender is not the owner.
112      */
113     modifier onlyOwner {
114         require(msg.sender == owner, "Must be owner");
115         _;
116     }
117 
118     constructor() public {
119         owner = msg.sender;
120     }
121 
122     /**
123      * @dev Lets the owner transfer ownership of the contract to a new owner.
124      * @param _newOwner The new owner.
125      */
126     function changeOwner(address _newOwner) external onlyOwner {
127         require(_newOwner != address(0), "Address must not be null");
128         owner = _newOwner;
129         emit OwnerChanged(_newOwner);
130     }
131 }
132 
133 contract LogicManager is Owned {
134 
135     event UpdateLogicSubmitted(address indexed logic, bool value);
136     event UpdateLogicCancelled(address indexed logic);
137     event UpdateLogicDone(address indexed logic, bool value);
138 
139     struct pending {
140         bool value;
141         uint dueTime;
142     }
143 
144     // The authorized logic modules
145     mapping (address => bool) public authorized;
146 
147     /*
148     array
149     index 0: AccountLogic address
150           1: TransferLogic address
151           2: DualsigsLogic address
152           3: DappLogic address
153           4: ...
154      */
155     address[] public authorizedLogics;
156 
157     // updated logics and their due time of becoming effective
158     mapping (address => pending) public pendingLogics;
159 
160     // pending time before updated logics take effect
161     struct pendingTime {
162         uint curPendingTime;
163         uint nextPendingTime;
164         uint dueTime;
165     }
166 
167     pendingTime public pt;
168 
169     // how many authorized logics
170     uint public logicCount;
171 
172     constructor(address[] memory _initialLogics, uint256 _pendingTime) public
173     {
174         for (uint i = 0; i < _initialLogics.length; i++) {
175             address logic = _initialLogics[i];
176             authorized[logic] = true;
177             logicCount += 1;
178         }
179         authorizedLogics = _initialLogics;
180 
181         pt.curPendingTime = _pendingTime;
182         pt.nextPendingTime = _pendingTime;
183         pt.dueTime = now;
184     }
185 
186     function submitUpdatePendingTime(uint _pendingTime) external onlyOwner {
187         pt.nextPendingTime = _pendingTime;
188         pt.dueTime = pt.curPendingTime + now;
189     }
190 
191     function triggerUpdatePendingTime() external {
192         require(pt.dueTime <= now, "too early to trigger updatePendingTime");
193         pt.curPendingTime = pt.nextPendingTime;
194     }
195 
196     function isAuthorized(address _logic) external view returns (bool) {
197         return authorized[_logic];
198     }
199 
200     function getAuthorizedLogics() external view returns (address[] memory) {
201         return authorizedLogics;
202     }
203 
204     function submitUpdate(address _logic, bool _value) external onlyOwner {
205         pending storage p = pendingLogics[_logic];
206         p.value = _value;
207         p.dueTime = now + pt.curPendingTime;
208         emit UpdateLogicSubmitted(_logic, _value);
209     }
210 
211     function cancelUpdate(address _logic) external onlyOwner {
212         delete pendingLogics[_logic];
213         emit UpdateLogicCancelled(_logic);
214     }
215 
216     function triggerUpdateLogic(address _logic) external {
217         pending memory p = pendingLogics[_logic];
218         require(p.dueTime > 0, "pending logic not found");
219         require(p.dueTime <= now, "too early to trigger updateLogic");
220         updateLogic(_logic, p.value);
221         delete pendingLogics[_logic];
222     }
223 
224     function updateLogic(address _logic, bool _value) internal {
225         if (authorized[_logic] != _value) {
226             if(_value) {
227                 logicCount += 1;
228                 authorized[_logic] = true;
229                 authorizedLogics.push(_logic);
230             }
231             else {
232                 logicCount -= 1;
233                 require(logicCount > 0, "must have at least one logic module");
234                 delete authorized[_logic];
235                 removeLogic(_logic);
236             }
237             emit UpdateLogicDone(_logic, _value);
238         }
239     }
240 
241     function removeLogic(address _logic) internal {
242         uint len = authorizedLogics.length;
243         address lastLogic = authorizedLogics[len - 1];
244         if (_logic != lastLogic) {
245             for (uint i = 0; i < len; i++) {
246                  if (_logic == authorizedLogics[i]) {
247                      authorizedLogics[i] = lastLogic;
248                      break;
249                  }
250             }
251         }
252         authorizedLogics.length--;
253     }
254 }
255 
256 contract AccountStorage {
257 
258     modifier allowAccountCallsOnly(Account _account) {
259         require(msg.sender == address(_account), "caller must be account");
260         _;
261     }
262 
263     modifier allowAuthorizedLogicContractsCallsOnly(address payable _account) {
264         require(LogicManager(Account(_account).manager()).isAuthorized(msg.sender), "not an authorized logic");
265         _;
266     }
267 
268     struct KeyItem {
269         address pubKey;
270         uint256 status;
271     }
272 
273     struct BackupAccount {
274         address backup;
275         uint256 effectiveDate;//means not effective until this timestamp
276         uint256 expiryDate;//means effective until this timestamp
277     }
278 
279     struct DelayItem {
280         bytes32 hash;
281         uint256 dueTime;
282     }
283 
284     struct Proposal {
285         bytes32 hash;
286         address[] approval;
287     }
288 
289     // account => quantity of operation keys (index >= 1)
290     mapping (address => uint256) operationKeyCount;
291 
292     // account => index => KeyItem
293     mapping (address => mapping(uint256 => KeyItem)) keyData;
294 
295     // account => index => backup account
296     mapping (address => mapping(uint256 => BackupAccount)) backupData;
297 
298     /* account => actionId => DelayItem
299 
300        delayData applies to these 4 actions:
301        changeAdminKey, changeAllOperationKeys, unfreeze, changeAdminKeyByBackup
302     */
303     mapping (address => mapping(bytes4 => DelayItem)) delayData;
304 
305     // client account => proposer account => proposed actionId => Proposal
306     mapping (address => mapping(address => mapping(bytes4 => Proposal))) proposalData;
307 
308     // *************** keyCount ********************** //
309 
310     function getOperationKeyCount(address _account) external view returns(uint256) {
311         return operationKeyCount[_account];
312     }
313 
314     function increaseKeyCount(address payable _account) external allowAuthorizedLogicContractsCallsOnly(_account) {
315         operationKeyCount[_account] = operationKeyCount[_account] + 1;
316     }
317 
318     // *************** keyData ********************** //
319 
320     function getKeyData(address _account, uint256 _index) public view returns(address) {
321         KeyItem memory item = keyData[_account][_index];
322         return item.pubKey;
323     }
324 
325     function setKeyData(address payable _account, uint256 _index, address _key) external allowAuthorizedLogicContractsCallsOnly(_account) {
326         require(_key != address(0), "invalid _key value");
327         KeyItem storage item = keyData[_account][_index];
328         item.pubKey = _key;
329     }
330 
331     // *************** keyStatus ********************** //
332 
333     function getKeyStatus(address _account, uint256 _index) external view returns(uint256) {
334         KeyItem memory item = keyData[_account][_index];
335         return item.status;
336     }
337 
338     function setKeyStatus(address payable _account, uint256 _index, uint256 _status) external allowAuthorizedLogicContractsCallsOnly(_account) {
339         KeyItem storage item = keyData[_account][_index];
340         item.status = _status;
341     }
342 
343     // *************** backupData ********************** //
344 
345     function getBackupAddress(address _account, uint256 _index) external view returns(address) {
346         BackupAccount memory b = backupData[_account][_index];
347         return b.backup;
348     }
349 
350     function getBackupEffectiveDate(address _account, uint256 _index) external view returns(uint256) {
351         BackupAccount memory b = backupData[_account][_index];
352         return b.effectiveDate;
353     }
354 
355     function getBackupExpiryDate(address _account, uint256 _index) external view returns(uint256) {
356         BackupAccount memory b = backupData[_account][_index];
357         return b.expiryDate;
358     }
359 
360     function setBackup(address payable _account, uint256 _index, address _backup, uint256 _effective, uint256 _expiry)
361         external
362         allowAuthorizedLogicContractsCallsOnly(_account)
363     {
364         BackupAccount storage b = backupData[_account][_index];
365         b.backup = _backup;
366         b.effectiveDate = _effective;
367         b.expiryDate = _expiry;
368     }
369 
370     function setBackupExpiryDate(address payable _account, uint256 _index, uint256 _expiry)
371         external
372         allowAuthorizedLogicContractsCallsOnly(_account)
373     {
374         BackupAccount storage b = backupData[_account][_index];
375         b.expiryDate = _expiry;
376     }
377 
378     function clearBackupData(address payable _account, uint256 _index) external allowAuthorizedLogicContractsCallsOnly(_account) {
379         delete backupData[_account][_index];
380     }
381 
382     // *************** delayData ********************** //
383 
384     function getDelayDataHash(address payable _account, bytes4 _actionId) external view returns(bytes32) {
385         DelayItem memory item = delayData[_account][_actionId];
386         return item.hash;
387     }
388 
389     function getDelayDataDueTime(address payable _account, bytes4 _actionId) external view returns(uint256) {
390         DelayItem memory item = delayData[_account][_actionId];
391         return item.dueTime;
392     }
393 
394     function setDelayData(address payable _account, bytes4 _actionId, bytes32 _hash, uint256 _dueTime) external allowAuthorizedLogicContractsCallsOnly(_account) {
395         DelayItem storage item = delayData[_account][_actionId];
396         item.hash = _hash;
397         item.dueTime = _dueTime;
398     }
399 
400     function clearDelayData(address payable _account, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_account) {
401         delete delayData[_account][_actionId];
402     }
403 
404     // *************** proposalData ********************** //
405 
406     function getProposalDataHash(address _client, address _proposer, bytes4 _actionId) external view returns(bytes32) {
407         Proposal memory p = proposalData[_client][_proposer][_actionId];
408         return p.hash;
409     }
410 
411     function getProposalDataApproval(address _client, address _proposer, bytes4 _actionId) external view returns(address[] memory) {
412         Proposal memory p = proposalData[_client][_proposer][_actionId];
413         return p.approval;
414     }
415 
416     function setProposalData(address payable _client, address _proposer, bytes4 _actionId, bytes32 _hash, address _approvedBackup)
417         external
418         allowAuthorizedLogicContractsCallsOnly(_client)
419     {
420         Proposal storage p = proposalData[_client][_proposer][_actionId];
421         if (p.hash > 0) {
422             if (p.hash == _hash) {
423                 for (uint256 i = 0; i < p.approval.length; i++) {
424                     require(p.approval[i] != _approvedBackup, "backup already exists");
425                 }
426                 p.approval.push(_approvedBackup);
427             } else {
428                 p.hash = _hash;
429                 p.approval.length = 0;
430             }
431         } else {
432             p.hash = _hash;
433             p.approval.push(_approvedBackup);
434         }
435     }
436 
437     function clearProposalData(address payable _client, address _proposer, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_client) {
438         delete proposalData[_client][_proposer][_actionId];
439     }
440 
441 
442     // *************** init ********************** //
443     function initAccount(Account _account, address[] calldata _keys, address[] calldata _backups)
444         external
445         allowAccountCallsOnly(_account)
446     {
447         require(getKeyData(address(_account), 0) == address(0), "AccountStorage: account already initialized!");
448         require(_keys.length > 0, "empty keys array");
449 
450         operationKeyCount[address(_account)] = _keys.length - 1;
451 
452         for (uint256 index = 0; index < _keys.length; index++) {
453             address _key = _keys[index];
454             require(_key != address(0), "_key cannot be 0x0");
455             KeyItem storage item = keyData[address(_account)][index];
456             item.pubKey = _key;
457             item.status = 0;
458         }
459 
460         // avoid backup duplication if _backups.length > 1
461         // normally won't check duplication, in most cases only one initial backup when initialization
462         if (_backups.length > 1) {
463             address[] memory bkps = _backups;
464             for (uint256 i = 0; i < _backups.length; i++) {
465                 for (uint256 j = 0; j < i; j++) {
466                     require(bkps[j] != _backups[i], "duplicate backup");
467                 }
468             }
469         }
470 
471         for (uint256 index = 0; index < _backups.length; index++) {
472             address _backup = _backups[index];
473             require(_backup != address(0), "backup cannot be 0x0");
474             require(_backup != address(_account), "cannot be backup of oneself");
475 
476             backupData[address(_account)][index] = BackupAccount(_backup, now, uint256(-1));
477         }
478     }
479 }
480 
481 /* The MIT License (MIT)
482 
483 Copyright (c) 2016 Smart Contract Solutions, Inc.
484 
485 Permission is hereby granted, free of charge, to any person obtaining
486 a copy of this software and associated documentation files (the
487 "Software"), to deal in the Software without restriction, including
488 without limitation the rights to use, copy, modify, merge, publish,
489 distribute, sublicense, and/or sell copies of the Software, and to
490 permit persons to whom the Software is furnished to do so, subject to
491 the following conditions:
492 
493 The above copyright notice and this permission notice shall be included
494 in all copies or substantial portions of the Software.
495 
496 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
497 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
498 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
499 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
500 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
501 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
502 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
503 
504 /**
505  * @title SafeMath
506  * @dev Math operations with safety checks that throw on error
507  */
508 library SafeMath {
509 
510     /**
511     * @dev Multiplies two numbers, reverts on overflow.
512     */
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
515         // benefit is lost if 'b' is also tested.
516         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
517         if (a == 0) {
518             return 0;
519         }
520 
521         uint256 c = a * b;
522         require(c / a == b);
523 
524         return c;
525     }
526 
527     /**
528     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
529     */
530     function div(uint256 a, uint256 b) internal pure returns (uint256) {
531         require(b > 0); // Solidity only automatically asserts when dividing by 0
532         uint256 c = a / b;
533         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
534 
535         return c;
536     }
537 
538     /**
539     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
540     */
541     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
542         require(b <= a);
543         uint256 c = a - b;
544 
545         return c;
546     }
547 
548     /**
549     * @dev Adds two numbers, reverts on overflow.
550     */
551     function add(uint256 a, uint256 b) internal pure returns (uint256) {
552         uint256 c = a + b;
553         require(c >= a);
554 
555         return c;
556     }
557 
558     /**
559     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
560     * reverts when dividing by zero.
561     */
562     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
563         require(b != 0);
564         return a % b;
565     }
566 
567     /**
568     * @dev Returns ceil(a / b).
569     */
570     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
571         uint256 c = a / b;
572         if(a % b == 0) {
573             return c;
574         }
575         else {
576             return c + 1;
577         }
578     }
579 }
580 
581 contract BaseLogic {
582 
583     bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
584 
585     mapping (address => uint256) keyNonce;
586     AccountStorage public accountStorage;
587 
588     modifier allowSelfCallsOnly() {
589         require (msg.sender == address(this), "only internal call is allowed");
590         _;
591     }
592 
593     modifier allowAccountCallsOnly(Account _account) {
594         require(msg.sender == address(_account), "caller must be account");
595         _;
596     }
597 
598     event LogicInitialised(address wallet);
599 
600     // *************** Constructor ********************** //
601 
602     constructor(AccountStorage _accountStorage) public {
603         accountStorage = _accountStorage;
604     }
605 
606     // *************** Initialization ********************* //
607 
608     function initAccount(Account _account) external allowAccountCallsOnly(_account){
609         emit LogicInitialised(address(_account));
610     }
611 
612     // *************** Getter ********************** //
613 
614     function getKeyNonce(address _key) external view returns(uint256) {
615         return keyNonce[_key];
616     }
617 
618     // *************** Signature ********************** //
619 
620     function getSignHash(bytes memory _data, uint256 _nonce) internal view returns(bytes32) {
621         // use EIP 191
622         // 0x1900 + this logic address + data + nonce of signing key
623         bytes32 msgHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _data, _nonce));
624         bytes32 prefixedHash = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, msgHash));
625         return prefixedHash;
626     }
627 
628     function verifySig(address _signingKey, bytes memory _signature, bytes32 _signHash) internal pure {
629         require(_signingKey != address(0), "invalid signing key");
630         address recoveredAddr = recover(_signHash, _signature);
631         require(recoveredAddr == _signingKey, "signature verification failed");
632     }
633 
634     /**
635      * @dev Returns the address that signed a hashed message (`hash`) with
636      * `signature`. This address can then be used for verification purposes.
637      *
638      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
639      * this function rejects them by requiring the `s` value to be in the lower
640      * half order, and the `v` value to be either 27 or 28.
641      *
642      * NOTE: This call _does not revert_ if the signature is invalid, or
643      * if the signer is otherwise unable to be retrieved. In those scenarios,
644      * the zero address is returned.
645      *
646      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
647      * verification to be secure: it is possible to craft signatures that
648      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
649      * this is by receiving a hash of the original message (which may otherwise)
650      * be too long), and then calling {toEthSignedMessageHash} on it.
651      */
652     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
653         // Check the signature length
654         if (signature.length != 65) {
655             return (address(0));
656         }
657 
658         // Divide the signature in r, s and v variables
659         bytes32 r;
660         bytes32 s;
661         uint8 v;
662 
663         // ecrecover takes the signature parameters, and the only way to get them
664         // currently is to use assembly.
665         // solhint-disable-next-line no-inline-assembly
666         assembly {
667             r := mload(add(signature, 0x20))
668             s := mload(add(signature, 0x40))
669             v := byte(0, mload(add(signature, 0x60)))
670         }
671 
672         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
673         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
674         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
675         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
676         //
677         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
678         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
679         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
680         // these malleable signatures as well.
681         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
682             return address(0);
683         }
684 
685         if (v != 27 && v != 28) {
686             return address(0);
687         }
688 
689         // If the signature is valid (and not malleable), return the signer address
690         return ecrecover(hash, v, r, s);
691     }
692 
693     /* get signer address from data
694     * @dev Gets an address encoded as the first argument in transaction data
695     * @param b The byte array that should have an address as first argument
696     * @returns a The address retrieved from the array
697     */
698     function getSignerAddress(bytes memory _b) internal pure returns (address _a) {
699         require(_b.length >= 36, "invalid bytes");
700         // solium-disable-next-line security/no-inline-assembly
701         assembly {
702             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
703             _a := and(mask, mload(add(_b, 36)))
704             // b = {length:32}{method sig:4}{address:32}{...}
705             // 36 is the offset of the first parameter of the data, if encoded properly.
706             // 32 bytes for the length of the bytes array, and the first 4 bytes for the function signature.
707             // 32 bytes is the length of the bytes array!!!!
708         }
709     }
710 
711     // get method id, first 4 bytes of data
712     function getMethodId(bytes memory _b) internal pure returns (bytes4 _a) {
713         require(_b.length >= 4, "invalid data");
714         // solium-disable-next-line security/no-inline-assembly
715         assembly {
716             // 32 bytes is the length of the bytes array
717             _a := mload(add(_b, 32))
718         }
719     }
720 
721     function checkKeyStatus(address _account, uint256 _index) internal {
722         // check operation key status
723         if (_index > 0) {
724             require(accountStorage.getKeyStatus(_account, _index) != 1, "frozen key");
725         }
726     }
727 
728     // _nonce is timestamp in microsecond(1/1000000 second)
729     function checkAndUpdateNonce(address _key, uint256 _nonce) internal {
730         require(_nonce > keyNonce[_key], "nonce too small");
731         require(SafeMath.div(_nonce, 1000000) <= now + 86400, "nonce too big"); // 86400=24*3600 seconds
732 
733         keyNonce[_key] = _nonce;
734     }
735 }
736 
737 contract AccountBaseLogic is BaseLogic {
738 
739     uint256 constant internal DELAY_CHANGE_ADMIN_KEY = 21 days;
740     uint256 constant internal DELAY_CHANGE_OPERATION_KEY = 7 days;
741     uint256 constant internal DELAY_UNFREEZE_KEY = 7 days;
742     uint256 constant internal DELAY_CHANGE_BACKUP = 21 days;
743     uint256 constant internal DELAY_CHANGE_ADMIN_KEY_BY_BACKUP = 30 days;
744 
745     uint256 constant internal MAX_DEFINED_BACKUP_INDEX = 5;
746 
747 	// Equals to bytes4(keccak256("changeAdminKey(address,address)"))
748 	bytes4 internal constant CHANGE_ADMIN_KEY = 0xd595d935;
749 	// Equals to bytes4(keccak256("changeAdminKeyByBackup(address,address)"))
750 	bytes4 internal constant CHANGE_ADMIN_KEY_BY_BACKUP = 0xfdd54ba1;
751 	// Equals to bytes4(keccak256("changeAdminKeyWithoutDelay(address,address)"))
752 	bytes4 internal constant CHANGE_ADMIN_KEY_WITHOUT_DELAY = 0x441d2e50;
753 	// Equals to bytes4(keccak256("changeAllOperationKeys(address,address[])"))
754 	bytes4 internal constant CHANGE_ALL_OPERATION_KEYS = 0xd3b9d4d6;
755 	// Equals to bytes4(keccak256("unfreeze(address)"))
756 	bytes4 internal constant UNFREEZE = 0x45c8b1a6;
757 
758     event ProposalExecuted(address indexed client, address indexed proposer, bytes functionData);
759 
760     // *************** Constructor ********************** //
761 
762 	constructor(AccountStorage _accountStorage)
763 		BaseLogic(_accountStorage)
764 		public
765 	{
766 	}
767 
768     // *************** Proposal ********************** //
769 
770     /* ‘executeProposal’ is shared by AccountLogic and DualsigsLogic,
771        proposed actions called from 'executeProposal':
772          AccountLogic: changeAdminKeyByBackup
773          DualsigsLogic: changeAdminKeyWithoutDelay, changeAllOperationKeysWithoutDelay, unfreezeWithoutDelay
774     */
775     function executeProposal(address payable _client, address _proposer, bytes calldata _functionData) external {
776         bytes4 proposedActionId = getMethodId(_functionData);
777         bytes32 functionHash = keccak256(_functionData);
778 
779         checkApproval(_client, _proposer, proposedActionId, functionHash);
780 
781         // call functions with/without delay
782         // solium-disable-next-line security/no-low-level-calls
783         (bool success,) = address(this).call(_functionData);
784         require(success, "executeProposal failed");
785 
786         accountStorage.clearProposalData(_client, _proposer, proposedActionId);
787         emit ProposalExecuted(_client, _proposer, _functionData);
788     }
789 
790     function checkApproval(address _client, address _proposer, bytes4 _proposedActionId, bytes32 _functionHash) internal view {
791         bytes32 hash = accountStorage.getProposalDataHash(_client, _proposer, _proposedActionId);
792         require(hash == _functionHash, "proposal hash unmatch");
793 
794         uint256 backupCount;
795         uint256 approvedCount;
796         address[] memory approved = accountStorage.getProposalDataApproval(_client, _proposer, _proposedActionId);
797         require(approved.length > 0, "no approval");
798 
799         // iterate backup list
800         for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
801             address backup = accountStorage.getBackupAddress(_client, i);
802             uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_client, i);
803             uint256 expiryDate = accountStorage.getBackupExpiryDate(_client, i);
804             if (backup != address(0) && isEffectiveBackup(effectiveDate, expiryDate)) {
805                 // count how many backups in backup list
806                 backupCount += 1;
807                 // iterate approved array
808                 for (uint256 k = 0; k < approved.length; k++) {
809                     if (backup == approved[k]) {
810                        // count how many approved backups still exist in backup list
811                        approvedCount += 1;
812                     }
813                 }
814             }
815         }
816         require(backupCount > 0, "no backup in list");
817         uint256 threshold = SafeMath.ceil(backupCount*6, 10);
818         require(approvedCount >= threshold, "must have 60% approval at least");
819     }
820 
821     function checkRelation(address _client, address _backup) internal view {
822         require(_backup != address(0), "backup cannot be 0x0");
823         require(_client != address(0), "client cannot be 0x0");
824         bool isBackup;
825         for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
826             address backup = accountStorage.getBackupAddress(_client, i);
827             uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_client, i);
828             uint256 expiryDate = accountStorage.getBackupExpiryDate(_client, i);
829             // backup match and effective and not expired
830             if (_backup == backup && isEffectiveBackup(effectiveDate, expiryDate)) {
831                 isBackup = true;
832                 break;
833             }
834         }
835         require(isBackup, "backup does not exist in list");
836     }
837 
838     function isEffectiveBackup(uint256 _effectiveDate, uint256 _expiryDate) internal view returns(bool) {
839         return (_effectiveDate <= now) && (_expiryDate > now);
840     }
841 
842     function clearRelatedProposalAfterAdminKeyChanged(address payable _client) internal {
843         //clear any existing proposal proposed by both, proposer is _client
844         accountStorage.clearProposalData(_client, _client, CHANGE_ADMIN_KEY_WITHOUT_DELAY);
845 
846         //clear any existing proposal proposed by backup, proposer is one of the backups
847         for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
848             address backup = accountStorage.getBackupAddress(_client, i);
849             uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_client, i);
850             uint256 expiryDate = accountStorage.getBackupExpiryDate(_client, i);
851             if (backup != address(0) && isEffectiveBackup(effectiveDate, expiryDate)) {
852                 accountStorage.clearProposalData(_client, backup, CHANGE_ADMIN_KEY_BY_BACKUP);
853             }
854         }
855     }
856 
857 }
858 
859 /**
860 * @title AccountLogic
861 */
862 contract AccountLogic is AccountBaseLogic {
863 
864 	// Equals to bytes4(keccak256("addOperationKey(address,address)"))
865 	bytes4 private constant ADD_OPERATION_KEY = 0x9a7f6101;
866 	// Equals to bytes4(keccak256("proposeAsBackup(address,address,bytes)"))
867 	bytes4 private constant PROPOSE_AS_BACKUP = 0xd470470f;
868 	// Equals to bytes4(keccak256("approveProposal(address,address,address,bytes)"))
869 	bytes4 private constant APPROVE_PROPOSAL = 0x3713f742;
870 
871     event AccountLogicEntered(bytes data, uint256 indexed nonce);
872 	event AccountLogicInitialised(address indexed account);
873 	event ChangeAdminKeyTriggered(address indexed account, address pkNew);
874 	event ChangeAdminKeyByBackupTriggered(address indexed account, address pkNew);
875 	event ChangeAllOperationKeysTriggered(address indexed account, address[] pks);
876 	event UnfreezeTriggered(address indexed account);
877 
878 	// *************** Constructor ********************** //
879 
880 	constructor(AccountStorage _accountStorage)
881 		AccountBaseLogic(_accountStorage)
882 		public
883 	{
884 	}
885 
886     // *************** Initialization ********************* //
887 
888 	function initAccount(Account _account) external allowAccountCallsOnly(_account){
889         emit AccountLogicInitialised(address(_account));
890     }
891 
892 	// *************** action entry ********************** //
893 
894     /* AccountLogic has 12 actions called from 'enter':
895         changeAdminKey, addOperationKey, changeAllOperationKeys, freeze, unfreeze,
896 		removeBackup, cancelDelay, cancelAddBackup, cancelRemoveBackup,
897 		proposeAsBackup, approveProposal, cancelProposal
898 	*/
899 	function enter(bytes calldata _data, bytes calldata _signature, uint256 _nonce) external {
900 		require(getMethodId(_data) != CHANGE_ADMIN_KEY_BY_BACKUP, "invalid data");
901 		address account = getSignerAddress(_data);
902 		uint256 keyIndex = getKeyIndex(_data);
903 		checkKeyStatus(account, keyIndex);
904 		address signingKey = accountStorage.getKeyData(account, keyIndex);
905 		checkAndUpdateNonce(signingKey, _nonce);
906 		bytes32 signHash = getSignHash(_data, _nonce);
907 		verifySig(signingKey, _signature, signHash);
908 
909 		// solium-disable-next-line security/no-low-level-calls
910 		(bool success,) = address(this).call(_data);
911 		require(success, "calling self failed");
912 		emit AccountLogicEntered(_data, _nonce);
913 	}
914 
915 	// *************** change admin key ********************** //
916 
917     // called from 'enter'
918 	function changeAdminKey(address payable _account, address _pkNew) external allowSelfCallsOnly {
919 		require(_pkNew != address(0), "0x0 is invalid");
920 		address pk = accountStorage.getKeyData(_account, 0);
921 		require(pk != _pkNew, "identical admin key exists");
922 		require(accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY) == 0, "delay data already exists");
923 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKey', _account, _pkNew));
924 		accountStorage.setDelayData(_account, CHANGE_ADMIN_KEY, hash, now + DELAY_CHANGE_ADMIN_KEY);
925 	}
926 
927     // called from external
928 	function triggerChangeAdminKey(address payable _account, address _pkNew) external {
929 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKey', _account, _pkNew));
930 		require(hash == accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY), "delay hash unmatch");
931 
932 		uint256 due = accountStorage.getDelayDataDueTime(_account, CHANGE_ADMIN_KEY);
933 		require(due > 0, "delay data not found");
934 		require(due <= now, "too early to trigger changeAdminKey");
935 		accountStorage.setKeyData(_account, 0, _pkNew);
936 		//clear any existing related delay data and proposal
937 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY);
938 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY_BY_BACKUP);
939 		clearRelatedProposalAfterAdminKeyChanged(_account);
940 		emit ChangeAdminKeyTriggered(_account, _pkNew);
941 	}
942 
943 	// *************** change admin key by backup proposal ********************** //
944 
945     // called from 'executeProposal'
946 	function changeAdminKeyByBackup(address payable _account, address _pkNew) external allowSelfCallsOnly {
947 		require(_pkNew != address(0), "0x0 is invalid");
948 		address pk = accountStorage.getKeyData(_account, 0);
949 		require(pk != _pkNew, "identical admin key exists");
950 		require(accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY_BY_BACKUP) == 0, "delay data already exists");
951 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKeyByBackup', _account, _pkNew));
952 		accountStorage.setDelayData(_account, CHANGE_ADMIN_KEY_BY_BACKUP, hash, now + DELAY_CHANGE_ADMIN_KEY_BY_BACKUP);
953 	}
954 
955     // called from external
956 	function triggerChangeAdminKeyByBackup(address payable _account, address _pkNew) external {
957 		bytes32 hash = keccak256(abi.encodePacked('changeAdminKeyByBackup', _account, _pkNew));
958 		require(hash == accountStorage.getDelayDataHash(_account, CHANGE_ADMIN_KEY_BY_BACKUP), "delay hash unmatch");
959 
960 		uint256 due = accountStorage.getDelayDataDueTime(_account, CHANGE_ADMIN_KEY_BY_BACKUP);
961 		require(due > 0, "delay data not found");
962 		require(due <= now, "too early to trigger changeAdminKeyByBackup");
963 		accountStorage.setKeyData(_account, 0, _pkNew);
964 		//clear any existing related delay data and proposal
965 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY_BY_BACKUP);
966 		accountStorage.clearDelayData(_account, CHANGE_ADMIN_KEY);
967 		clearRelatedProposalAfterAdminKeyChanged(_account);
968 		emit ChangeAdminKeyByBackupTriggered(_account, _pkNew);
969 	}
970 
971 	// *************** add operation key ********************** //
972 
973     // called from 'enter'
974 	function addOperationKey(address payable _account, address _pkNew) external allowSelfCallsOnly {
975 		uint256 index = accountStorage.getOperationKeyCount(_account) + 1;
976 		require(index > 0, "invalid operation key index");
977 		// set a limit to prevent unnecessary trouble
978 		require(index < 20, "index exceeds limit");
979 		require(_pkNew != address(0), "0x0 is invalid");
980 		address pk = accountStorage.getKeyData(_account, index);
981 		require(pk == address(0), "operation key already exists");
982 		accountStorage.setKeyData(_account, index, _pkNew);
983 		accountStorage.increaseKeyCount(_account);
984 	}
985 
986 	// *************** change all operation keys ********************** //
987 
988     // called from 'enter'
989 	function changeAllOperationKeys(address payable _account, address[] calldata _pks) external allowSelfCallsOnly {
990 		uint256 keyCount = accountStorage.getOperationKeyCount(_account);
991 		require(_pks.length == keyCount, "invalid number of keys");
992 		require(accountStorage.getDelayDataHash(_account, CHANGE_ALL_OPERATION_KEYS) == 0, "delay data already exists");
993 		address pk;
994 		for (uint256 i = 0; i < keyCount; i++) {
995 			pk = _pks[i];
996 			require(pk != address(0), "0x0 is invalid");
997 		}
998 		bytes32 hash = keccak256(abi.encodePacked('changeAllOperationKeys', _account, _pks));
999 		accountStorage.setDelayData(_account, CHANGE_ALL_OPERATION_KEYS, hash, now + DELAY_CHANGE_OPERATION_KEY);
1000 	}
1001 
1002     // called from external
1003 	function triggerChangeAllOperationKeys(address payable _account, address[] calldata _pks) external {
1004 		bytes32 hash = keccak256(abi.encodePacked('changeAllOperationKeys', _account, _pks));
1005 		require(hash == accountStorage.getDelayDataHash(_account, CHANGE_ALL_OPERATION_KEYS), "delay hash unmatch");
1006 
1007 		uint256 due = accountStorage.getDelayDataDueTime(_account, CHANGE_ALL_OPERATION_KEYS);
1008 		require(due > 0, "delay data not found");
1009 		require(due <= now, "too early to trigger changeAllOperationKeys");
1010 		address pk;
1011 		for (uint256 i = 0; i < accountStorage.getOperationKeyCount(_account); i++) {
1012 			pk = _pks[i];
1013 			accountStorage.setKeyData(_account, i+1, pk);
1014 			accountStorage.setKeyStatus(_account, i+1, 0);
1015 		}
1016 		accountStorage.clearDelayData(_account, CHANGE_ALL_OPERATION_KEYS);
1017 		emit ChangeAllOperationKeysTriggered(_account, _pks);
1018 	}
1019 
1020 	// *************** freeze/unfreeze all operation keys ********************** //
1021 
1022     // called from 'enter'
1023 	function freeze(address payable _account) external allowSelfCallsOnly {
1024 		for (uint256 i = 1; i <= accountStorage.getOperationKeyCount(_account); i++) {
1025 			if (accountStorage.getKeyStatus(_account, i) == 0) {
1026 				accountStorage.setKeyStatus(_account, i, 1);
1027 			}
1028 		}
1029 	}
1030 
1031     // called from 'enter'
1032 	function unfreeze(address payable _account) external allowSelfCallsOnly {
1033 		require(accountStorage.getDelayDataHash(_account, UNFREEZE) == 0, "delay data already exists");
1034 		bytes32 hash = keccak256(abi.encodePacked('unfreeze', _account));
1035 		accountStorage.setDelayData(_account, UNFREEZE, hash, now + DELAY_UNFREEZE_KEY);
1036 	}
1037 
1038     // called from external
1039 	function triggerUnfreeze(address payable _account) external {
1040 		bytes32 hash = keccak256(abi.encodePacked('unfreeze', _account));
1041 		require(hash == accountStorage.getDelayDataHash(_account, UNFREEZE), "delay hash unmatch");
1042 
1043 		uint256 due = accountStorage.getDelayDataDueTime(_account, UNFREEZE);
1044 		require(due > 0, "delay data not found");
1045 		require(due <= now, "too early to trigger unfreeze");
1046 
1047 		for (uint256 i = 1; i <= accountStorage.getOperationKeyCount(_account); i++) {
1048 			if (accountStorage.getKeyStatus(_account, i) == 1) {
1049 				accountStorage.setKeyStatus(_account, i, 0);
1050 			}
1051 		}
1052 		accountStorage.clearDelayData(_account, UNFREEZE);
1053 		emit UnfreezeTriggered(_account);
1054 	}
1055 
1056 	// *************** remove backup ********************** //
1057 
1058     // called from 'enter'
1059 	function removeBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1060 		uint256 index = findBackup(_account, _backup);
1061 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1062 
1063 		accountStorage.setBackupExpiryDate(_account, index, now + DELAY_CHANGE_BACKUP);
1064 	}
1065 
1066     // return backupData index(0~5), 6 means not found
1067     // do make sure _backup is not 0x0
1068 	function findBackup(address _account, address _backup) public view returns(uint) {
1069 		uint index = MAX_DEFINED_BACKUP_INDEX + 1;
1070 		if (_backup == address(0)) {
1071 			return index;
1072 		}
1073 		address b;
1074 		for (uint256 i = 0; i <= MAX_DEFINED_BACKUP_INDEX; i++) {
1075 			b = accountStorage.getBackupAddress(_account, i);
1076 			if (b == _backup) {
1077 				index = i;
1078 				break;
1079 			}
1080 		}
1081 		return index;
1082 	}
1083 
1084 	// *************** cancel delay action ********************** //
1085 
1086     // called from 'enter'
1087 	function cancelDelay(address payable _account, bytes4 _actionId) external allowSelfCallsOnly {
1088 		accountStorage.clearDelayData(_account, _actionId);
1089 	}
1090 
1091     // called from 'enter'
1092 	function cancelAddBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1093 		uint256 index = findBackup(_account, _backup);
1094 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1095 		uint256 effectiveDate = accountStorage.getBackupEffectiveDate(_account, index);
1096 		require(effectiveDate > now, "already effective");
1097 		accountStorage.clearBackupData(_account, index);
1098 	}
1099 
1100     // called from 'enter'
1101 	function cancelRemoveBackup(address payable _account, address _backup) external allowSelfCallsOnly {
1102 		uint256 index = findBackup(_account, _backup);
1103 		require(index <= MAX_DEFINED_BACKUP_INDEX, "backup invalid or not exist");
1104 		uint256 expiryDate = accountStorage.getBackupExpiryDate(_account, index);
1105 		require(expiryDate > now, "already expired");
1106 		accountStorage.setBackupExpiryDate(_account, index, uint256(-1));
1107 	}
1108 
1109 	// *************** propose, approve and cancel proposal ********************** //
1110 
1111     // called from 'enter'
1112 	// proposer is backup in the case of 'proposeAsBackup'
1113 	function proposeAsBackup(address _backup, address payable _client, bytes calldata _functionData) external allowSelfCallsOnly {
1114 		bytes4 proposedActionId = getMethodId(_functionData);
1115 		require(proposedActionId == CHANGE_ADMIN_KEY_BY_BACKUP, "invalid proposal by backup");
1116 		checkRelation(_client, _backup);
1117 		bytes32 functionHash = keccak256(_functionData);
1118 		accountStorage.setProposalData(_client, _backup, proposedActionId, functionHash, _backup);
1119 	}
1120 
1121     // called from 'enter'
1122 	function approveProposal(address _backup, address payable _client, address _proposer, bytes calldata _functionData) external allowSelfCallsOnly {
1123 		bytes32 functionHash = keccak256(_functionData);
1124 		require(functionHash != 0, "invalid hash");
1125 		checkRelation(_client, _backup);
1126 		bytes4 proposedActionId = getMethodId(_functionData);
1127 		bytes32 hash = accountStorage.getProposalDataHash(_client, _proposer, proposedActionId);
1128 		require(hash == functionHash, "proposal unmatch");
1129 		accountStorage.setProposalData(_client, _proposer, proposedActionId, functionHash, _backup);
1130 	}
1131 
1132     // called from 'enter'
1133 	function cancelProposal(address payable _client, address _proposer, bytes4 _proposedActionId) external allowSelfCallsOnly {
1134 		require(_client != _proposer, "cannot cancel dual signed proposal");
1135 		accountStorage.clearProposalData(_client, _proposer, _proposedActionId);
1136 	}
1137 
1138 	// *************** internal functions ********************** //
1139 
1140     /*
1141     index 0: admin key
1142           1: asset(transfer)
1143           2: adding
1144           3: reserved(dapp)
1145           4: assist
1146      */
1147 	function getKeyIndex(bytes memory _data) internal pure returns (uint256) {
1148 		uint256 index; //index default value is 0, admin key
1149 		bytes4 methodId = getMethodId(_data);
1150 		if (methodId == ADD_OPERATION_KEY) {
1151   			index = 2; //adding key
1152 		} else if (methodId == PROPOSE_AS_BACKUP || methodId == APPROVE_PROPOSAL) {
1153   			index = 4; //assist key
1154 		}
1155 		return index;
1156 	}
1157 
1158 }
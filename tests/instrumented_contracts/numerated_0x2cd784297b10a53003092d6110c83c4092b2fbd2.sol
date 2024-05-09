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
26     function init(address _manager, address _accountStorage, address[] calldata _logics, address[] calldata _keys, address[] calldata _backups)
27         external
28     {
29         require(manager == address(0), "Account: account already initialized");
30         require(_manager != address(0) && _accountStorage != address(0), "Account: address is null");
31         manager = _manager;
32 
33         for (uint i = 0; i < _logics.length; i++) {
34             address logic = _logics[i];
35             require(LogicManager(manager).isAuthorized(logic), "must be authorized logic");
36 
37             BaseLogic(logic).initAccount(this);
38         }
39 
40         AccountStorage(_accountStorage).initAccount(this, _keys, _backups);
41 
42         emit AccountInit(address(this));
43     }
44 
45     function invoke(address _target, uint _value, bytes calldata _data)
46         external
47         allowAuthorizedLogicContractsCallsOnly
48         returns (bytes memory _res)
49     {
50         bool success;
51         // solium-disable-next-line security/no-call-value
52         (success, _res) = _target.call.value(_value)(_data);
53         require(success, "call to target failed");
54         emit Invoked(msg.sender, _target, _value, _data);
55     }
56 
57     /**
58     * @dev Enables a static method by specifying the target module to which the call must be delegated.
59     * @param _module The target module.
60     * @param _method The static method signature.
61     */
62     function enableStaticCall(address _module, bytes4 _method) external allowAuthorizedLogicContractsCallsOnly {
63         enabled[_method] = _module;
64         emit EnabledStaticCall(_module, _method);
65     }
66 
67     function changeManager(address _newMgr) external allowAuthorizedLogicContractsCallsOnly {
68         require(_newMgr != address(0), "address cannot be null");
69         require(_newMgr != manager, "already changed");
70         manager = _newMgr;
71         emit ManagerChanged(_newMgr);
72     }
73 
74      /**
75      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
76      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
77      * to an enabled method, or logs the call otherwise.
78      */
79     function() external payable {
80         if(msg.data.length > 0) {
81             address logic = enabled[msg.sig];
82             if(logic == address(0)) {
83                 emit Received(msg.value, msg.sender, msg.data);
84             }
85             else {
86                 require(LogicManager(manager).isAuthorized(logic), "must be an authorized logic for static call");
87                 // solium-disable-next-line security/no-inline-assembly
88                 assembly {
89                     calldatacopy(0, 0, calldatasize())
90                     let result := staticcall(gas, logic, 0, calldatasize(), 0, 0)
91                     returndatacopy(0, 0, returndatasize())
92                     switch result
93                     case 0 {revert(0, returndatasize())}
94                     default {return (0, returndatasize())}
95                 }
96             }
97         }
98     }
99 }
100 
101 contract Owned {
102 
103     // The owner
104     address public owner;
105 
106     event OwnerChanged(address indexed _newOwner);
107 
108     /**
109      * @dev Throws if the sender is not the owner.
110      */
111     modifier onlyOwner {
112         require(msg.sender == owner, "Must be owner");
113         _;
114     }
115 
116     constructor() public {
117         owner = msg.sender;
118     }
119 
120     /**
121      * @dev Lets the owner transfer ownership of the contract to a new owner.
122      * @param _newOwner The new owner.
123      */
124     function changeOwner(address _newOwner) external onlyOwner {
125         require(_newOwner != address(0), "Address must not be null");
126         owner = _newOwner;
127         emit OwnerChanged(_newOwner);
128     }
129 }
130 
131 contract LogicManager is Owned {
132 
133     event UpdateLogicSubmitted(address indexed logic, bool value);
134     event UpdateLogicCancelled(address indexed logic);
135     event UpdateLogicDone(address indexed logic, bool value);
136 
137     struct pending {
138         bool value;
139         uint dueTime;
140     }
141 
142     // The authorized logic modules
143     mapping (address => bool) public authorized;
144 
145     /*
146     array
147     index 0: AccountLogic address
148           1: TransferLogic address
149           2: DualsigsLogic address
150           3: DappLogic address
151           4: ...
152      */
153     address[] public authorizedLogics;
154 
155     // updated logics and their due time of becoming effective
156     mapping (address => pending) public pendingLogics;
157 
158     // pending time before updated logics take effect
159     struct pendingTime {
160         uint curPendingTime;
161         uint nextPendingTime;
162         uint dueTime;
163     }
164 
165     pendingTime public pt;
166 
167     // how many authorized logics
168     uint public logicCount;
169 
170     constructor(address[] memory _initialLogics, uint256 _pendingTime) public
171     {
172         for (uint i = 0; i < _initialLogics.length; i++) {
173             address logic = _initialLogics[i];
174             authorized[logic] = true;
175             logicCount += 1;
176         }
177         authorizedLogics = _initialLogics;
178 
179         pt.curPendingTime = _pendingTime;
180         pt.nextPendingTime = _pendingTime;
181         pt.dueTime = now;
182     }
183 
184     function submitUpdatePendingTime(uint _pendingTime) external onlyOwner {
185         pt.nextPendingTime = _pendingTime;
186         pt.dueTime = pt.curPendingTime + now;
187     }
188 
189     function triggerUpdatePendingTime() external {
190         require(pt.dueTime <= now, "too early to trigger updatePendingTime");
191         pt.curPendingTime = pt.nextPendingTime;
192     }
193 
194     function isAuthorized(address _logic) external view returns (bool) {
195         return authorized[_logic];
196     }
197 
198     function getAuthorizedLogics() external view returns (address[] memory) {
199         return authorizedLogics;
200     }
201 
202     function submitUpdate(address _logic, bool _value) external onlyOwner {
203         pending storage p = pendingLogics[_logic];
204         p.value = _value;
205         p.dueTime = now + pt.curPendingTime;
206         emit UpdateLogicSubmitted(_logic, _value);
207     }
208 
209     function cancelUpdate(address _logic) external onlyOwner {
210         delete pendingLogics[_logic];
211         emit UpdateLogicCancelled(_logic);
212     }
213 
214     function triggerUpdateLogic(address _logic) external {
215         pending memory p = pendingLogics[_logic];
216         require(p.dueTime > 0, "pending logic not found");
217         require(p.dueTime <= now, "too early to trigger updateLogic");
218         updateLogic(_logic, p.value);
219         delete pendingLogics[_logic];
220     }
221 
222     function updateLogic(address _logic, bool _value) internal {
223         if (authorized[_logic] != _value) {
224             if(_value) {
225                 logicCount += 1;
226                 authorized[_logic] = true;
227                 authorizedLogics.push(_logic);
228             }
229             else {
230                 logicCount -= 1;
231                 require(logicCount > 0, "must have at least one logic module");
232                 delete authorized[_logic];
233                 removeLogic(_logic);
234             }
235             emit UpdateLogicDone(_logic, _value);
236         }
237     }
238 
239     function removeLogic(address _logic) internal {
240         uint len = authorizedLogics.length;
241         address lastLogic = authorizedLogics[len - 1];
242         if (_logic != lastLogic) {
243             for (uint i = 0; i < len; i++) {
244                  if (_logic == authorizedLogics[i]) {
245                      authorizedLogics[i] = lastLogic;
246                      break;
247                  }
248             }
249         }
250         authorizedLogics.length--;
251     }
252 }
253 
254 contract AccountStorage {
255 
256     modifier allowAccountCallsOnly(Account _account) {
257         require(msg.sender == address(_account), "caller must be account");
258         _;
259     }
260 
261     modifier allowAuthorizedLogicContractsCallsOnly(address payable _account) {
262         require(LogicManager(Account(_account).manager()).isAuthorized(msg.sender), "not an authorized logic");
263         _;
264     }
265 
266     struct KeyItem {
267         address pubKey;
268         uint256 status;
269     }
270 
271     struct BackupAccount {
272         address backup;
273         uint256 effectiveDate;//means not effective until this timestamp
274         uint256 expiryDate;//means effective until this timestamp
275     }
276 
277     struct DelayItem {
278         bytes32 hash;
279         uint256 dueTime;
280     }
281 
282     struct Proposal {
283         bytes32 hash;
284         address[] approval;
285     }
286 
287     // account => quantity of operation keys (index >= 1)
288     mapping (address => uint256) operationKeyCount;
289 
290     // account => index => KeyItem
291     mapping (address => mapping(uint256 => KeyItem)) keyData;
292 
293     // account => index => backup account
294     mapping (address => mapping(uint256 => BackupAccount)) backupData;
295 
296     /* account => actionId => DelayItem
297 
298        delayData applies to these 4 actions:
299        changeAdminKey, changeAllOperationKeys, unfreeze, changeAdminKeyByBackup
300     */
301     mapping (address => mapping(bytes4 => DelayItem)) delayData;
302 
303     // client account => proposer account => proposed actionId => Proposal
304     mapping (address => mapping(address => mapping(bytes4 => Proposal))) proposalData;
305 
306     // *************** keyCount ********************** //
307 
308     function getOperationKeyCount(address _account) external view returns(uint256) {
309         return operationKeyCount[_account];
310     }
311 
312     function increaseKeyCount(address payable _account) external allowAuthorizedLogicContractsCallsOnly(_account) {
313         operationKeyCount[_account] = operationKeyCount[_account] + 1;
314     }
315 
316     // *************** keyData ********************** //
317 
318     function getKeyData(address _account, uint256 _index) public view returns(address) {
319         KeyItem memory item = keyData[_account][_index];
320         return item.pubKey;
321     }
322 
323     function setKeyData(address payable _account, uint256 _index, address _key) external allowAuthorizedLogicContractsCallsOnly(_account) {
324         require(_key != address(0), "invalid _key value");
325         KeyItem storage item = keyData[_account][_index];
326         item.pubKey = _key;
327     }
328 
329     // *************** keyStatus ********************** //
330 
331     function getKeyStatus(address _account, uint256 _index) external view returns(uint256) {
332         KeyItem memory item = keyData[_account][_index];
333         return item.status;
334     }
335 
336     function setKeyStatus(address payable _account, uint256 _index, uint256 _status) external allowAuthorizedLogicContractsCallsOnly(_account) {
337         KeyItem storage item = keyData[_account][_index];
338         item.status = _status;
339     }
340 
341     // *************** backupData ********************** //
342 
343     function getBackupAddress(address _account, uint256 _index) external view returns(address) {
344         BackupAccount memory b = backupData[_account][_index];
345         return b.backup;
346     }
347 
348     function getBackupEffectiveDate(address _account, uint256 _index) external view returns(uint256) {
349         BackupAccount memory b = backupData[_account][_index];
350         return b.effectiveDate;
351     }
352 
353     function getBackupExpiryDate(address _account, uint256 _index) external view returns(uint256) {
354         BackupAccount memory b = backupData[_account][_index];
355         return b.expiryDate;
356     }
357 
358     function setBackup(address payable _account, uint256 _index, address _backup, uint256 _effective, uint256 _expiry)
359         external
360         allowAuthorizedLogicContractsCallsOnly(_account)
361     {
362         BackupAccount storage b = backupData[_account][_index];
363         b.backup = _backup;
364         b.effectiveDate = _effective;
365         b.expiryDate = _expiry;
366     }
367 
368     function setBackupExpiryDate(address payable _account, uint256 _index, uint256 _expiry)
369         external
370         allowAuthorizedLogicContractsCallsOnly(_account)
371     {
372         BackupAccount storage b = backupData[_account][_index];
373         b.expiryDate = _expiry;
374     }
375 
376     function clearBackupData(address payable _account, uint256 _index) external allowAuthorizedLogicContractsCallsOnly(_account) {
377         delete backupData[_account][_index];
378     }
379 
380     // *************** delayData ********************** //
381 
382     function getDelayDataHash(address payable _account, bytes4 _actionId) external view returns(bytes32) {
383         DelayItem memory item = delayData[_account][_actionId];
384         return item.hash;
385     }
386 
387     function getDelayDataDueTime(address payable _account, bytes4 _actionId) external view returns(uint256) {
388         DelayItem memory item = delayData[_account][_actionId];
389         return item.dueTime;
390     }
391 
392     function setDelayData(address payable _account, bytes4 _actionId, bytes32 _hash, uint256 _dueTime) external allowAuthorizedLogicContractsCallsOnly(_account) {
393         DelayItem storage item = delayData[_account][_actionId];
394         item.hash = _hash;
395         item.dueTime = _dueTime;
396     }
397 
398     function clearDelayData(address payable _account, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_account) {
399         delete delayData[_account][_actionId];
400     }
401 
402     // *************** proposalData ********************** //
403 
404     function getProposalDataHash(address _client, address _proposer, bytes4 _actionId) external view returns(bytes32) {
405         Proposal memory p = proposalData[_client][_proposer][_actionId];
406         return p.hash;
407     }
408 
409     function getProposalDataApproval(address _client, address _proposer, bytes4 _actionId) external view returns(address[] memory) {
410         Proposal memory p = proposalData[_client][_proposer][_actionId];
411         return p.approval;
412     }
413 
414     function setProposalData(address payable _client, address _proposer, bytes4 _actionId, bytes32 _hash, address _approvedBackup)
415         external
416         allowAuthorizedLogicContractsCallsOnly(_client)
417     {
418         Proposal storage p = proposalData[_client][_proposer][_actionId];
419         if (p.hash > 0) {
420             if (p.hash == _hash) {
421                 for (uint256 i = 0; i < p.approval.length; i++) {
422                     require(p.approval[i] != _approvedBackup, "backup already exists");
423                 }
424                 p.approval.push(_approvedBackup);
425             } else {
426                 p.hash = _hash;
427                 p.approval.length = 0;
428             }
429         } else {
430             p.hash = _hash;
431             p.approval.push(_approvedBackup);
432         }
433     }
434 
435     function clearProposalData(address payable _client, address _proposer, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_client) {
436         delete proposalData[_client][_proposer][_actionId];
437     }
438 
439 
440     // *************** init ********************** //
441     function initAccount(Account _account, address[] calldata _keys, address[] calldata _backups)
442         external
443         allowAccountCallsOnly(_account)
444     {
445         require(getKeyData(address(_account), 0) == address(0), "AccountStorage: account already initialized!");
446         require(_keys.length > 0, "empty keys array");
447 
448         operationKeyCount[address(_account)] = _keys.length - 1;
449 
450         for (uint256 index = 0; index < _keys.length; index++) {
451             address _key = _keys[index];
452             require(_key != address(0), "_key cannot be 0x0");
453             KeyItem storage item = keyData[address(_account)][index];
454             item.pubKey = _key;
455             item.status = 0;
456         }
457 
458         // avoid backup duplication if _backups.length > 1
459         // normally won't check duplication, in most cases only one initial backup when initialization
460         if (_backups.length > 1) {
461             address[] memory bkps = _backups;
462             for (uint256 i = 0; i < _backups.length; i++) {
463                 for (uint256 j = 0; j < i; j++) {
464                     require(bkps[j] != _backups[i], "duplicate backup");
465                 }
466             }
467         }
468 
469         for (uint256 index = 0; index < _backups.length; index++) {
470             address _backup = _backups[index];
471             require(_backup != address(0), "backup cannot be 0x0");
472             require(_backup != address(_account), "cannot be backup of oneself");
473 
474             backupData[address(_account)][index] = BackupAccount(_backup, now, uint256(-1));
475         }
476     }
477 }
478 
479 /* The MIT License (MIT)
480 
481 Copyright (c) 2016 Smart Contract Solutions, Inc.
482 
483 Permission is hereby granted, free of charge, to any person obtaining
484 a copy of this software and associated documentation files (the
485 "Software"), to deal in the Software without restriction, including
486 without limitation the rights to use, copy, modify, merge, publish,
487 distribute, sublicense, and/or sell copies of the Software, and to
488 permit persons to whom the Software is furnished to do so, subject to
489 the following conditions:
490 
491 The above copyright notice and this permission notice shall be included
492 in all copies or substantial portions of the Software.
493 
494 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
495 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
496 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
497 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
498 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
499 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
500 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
501 
502 /**
503  * @title SafeMath
504  * @dev Math operations with safety checks that throw on error
505  */
506 library SafeMath {
507 
508     /**
509     * @dev Multiplies two numbers, reverts on overflow.
510     */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
513         // benefit is lost if 'b' is also tested.
514         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
515         if (a == 0) {
516             return 0;
517         }
518 
519         uint256 c = a * b;
520         require(c / a == b);
521 
522         return c;
523     }
524 
525     /**
526     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
527     */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         require(b > 0); // Solidity only automatically asserts when dividing by 0
530         uint256 c = a / b;
531         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
532 
533         return c;
534     }
535 
536     /**
537     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
538     */
539     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
540         require(b <= a);
541         uint256 c = a - b;
542 
543         return c;
544     }
545 
546     /**
547     * @dev Adds two numbers, reverts on overflow.
548     */
549     function add(uint256 a, uint256 b) internal pure returns (uint256) {
550         uint256 c = a + b;
551         require(c >= a);
552 
553         return c;
554     }
555 
556     /**
557     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
558     * reverts when dividing by zero.
559     */
560     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
561         require(b != 0);
562         return a % b;
563     }
564 
565     /**
566     * @dev Returns ceil(a / b).
567     */
568     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
569         uint256 c = a / b;
570         if(a % b == 0) {
571             return c;
572         }
573         else {
574             return c + 1;
575         }
576     }
577 }
578 
579 contract BaseLogic {
580 
581     bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
582 
583     mapping (address => uint256) keyNonce;
584     AccountStorage public accountStorage;
585 
586     modifier allowSelfCallsOnly() {
587         require (msg.sender == address(this), "only internal call is allowed");
588         _;
589     }
590 
591     modifier allowAccountCallsOnly(Account _account) {
592         require(msg.sender == address(_account), "caller must be account");
593         _;
594     }
595 
596     event LogicInitialised(address wallet);
597 
598     // *************** Constructor ********************** //
599 
600     constructor(AccountStorage _accountStorage) public {
601         accountStorage = _accountStorage;
602     }
603 
604     // *************** Initialization ********************* //
605 
606     function initAccount(Account _account) external allowAccountCallsOnly(_account){
607         emit LogicInitialised(address(_account));
608     }
609 
610     // *************** Getter ********************** //
611 
612     function getKeyNonce(address _key) external view returns(uint256) {
613         return keyNonce[_key];
614     }
615 
616     // *************** Signature ********************** //
617 
618     function getSignHash(bytes memory _data, uint256 _nonce) internal view returns(bytes32) {
619         // use EIP 191
620         // 0x1900 + this logic address + data + nonce of signing key
621         bytes32 msgHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _data, _nonce));
622         bytes32 prefixedHash = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, msgHash));
623         return prefixedHash;
624     }
625 
626     function verifySig(address _signingKey, bytes memory _signature, bytes32 _signHash) internal pure {
627         require(_signingKey != address(0), "invalid signing key");
628         address recoveredAddr = recover(_signHash, _signature);
629         require(recoveredAddr == _signingKey, "signature verification failed");
630     }
631 
632     /**
633      * @dev Returns the address that signed a hashed message (`hash`) with
634      * `signature`. This address can then be used for verification purposes.
635      *
636      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
637      * this function rejects them by requiring the `s` value to be in the lower
638      * half order, and the `v` value to be either 27 or 28.
639      *
640      * NOTE: This call _does not revert_ if the signature is invalid, or
641      * if the signer is otherwise unable to be retrieved. In those scenarios,
642      * the zero address is returned.
643      *
644      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
645      * verification to be secure: it is possible to craft signatures that
646      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
647      * this is by receiving a hash of the original message (which may otherwise)
648      * be too long), and then calling {toEthSignedMessageHash} on it.
649      */
650     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
651         // Check the signature length
652         if (signature.length != 65) {
653             return (address(0));
654         }
655 
656         // Divide the signature in r, s and v variables
657         bytes32 r;
658         bytes32 s;
659         uint8 v;
660 
661         // ecrecover takes the signature parameters, and the only way to get them
662         // currently is to use assembly.
663         // solhint-disable-next-line no-inline-assembly
664         assembly {
665             r := mload(add(signature, 0x20))
666             s := mload(add(signature, 0x40))
667             v := byte(0, mload(add(signature, 0x60)))
668         }
669 
670         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
671         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
672         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
673         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
674         //
675         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
676         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
677         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
678         // these malleable signatures as well.
679         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
680             return address(0);
681         }
682 
683         if (v != 27 && v != 28) {
684             return address(0);
685         }
686 
687         // If the signature is valid (and not malleable), return the signer address
688         return ecrecover(hash, v, r, s);
689     }
690 
691     /* get signer address from data
692     * @dev Gets an address encoded as the first argument in transaction data
693     * @param b The byte array that should have an address as first argument
694     * @returns a The address retrieved from the array
695     */
696     function getSignerAddress(bytes memory _b) internal pure returns (address _a) {
697         require(_b.length >= 36, "invalid bytes");
698         // solium-disable-next-line security/no-inline-assembly
699         assembly {
700             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
701             _a := and(mask, mload(add(_b, 36)))
702             // b = {length:32}{method sig:4}{address:32}{...}
703             // 36 is the offset of the first parameter of the data, if encoded properly.
704             // 32 bytes for the length of the bytes array, and the first 4 bytes for the function signature.
705             // 32 bytes is the length of the bytes array!!!!
706         }
707     }
708 
709     // get method id, first 4 bytes of data
710     function getMethodId(bytes memory _b) internal pure returns (bytes4 _a) {
711         require(_b.length >= 4, "invalid data");
712         // solium-disable-next-line security/no-inline-assembly
713         assembly {
714             // 32 bytes is the length of the bytes array
715             _a := mload(add(_b, 32))
716         }
717     }
718 
719     function checkKeyStatus(address _account, uint256 _index) internal {
720         // check operation key status
721         if (_index > 0) {
722             require(accountStorage.getKeyStatus(_account, _index) != 1, "frozen key");
723         }
724     }
725 
726     // _nonce is timestamp in microsecond(1/1000000 second)
727     function checkAndUpdateNonce(address _key, uint256 _nonce) internal {
728         require(_nonce > keyNonce[_key], "nonce too small");
729         require(SafeMath.div(_nonce, 1000000) <= now + 86400, "nonce too big"); // 86400=24*3600 seconds
730 
731         keyNonce[_key] = _nonce;
732     }
733 }
734 
735 contract DappLogic is BaseLogic {
736 
737     /*
738     index 0: admin key
739           1: asset(transfer)
740           2: adding
741           3: reserved(dapp)
742           4: assist
743      */
744     uint constant internal DAPP_KEY_INDEX = 3;
745 
746     // *************** Events *************************** //
747 
748     event DappLogicInitialised(address indexed account);
749     event DappLogicEntered(bytes data, uint256 indexed nonce);
750 
751     // *************** Constructor ********************** //
752     constructor(AccountStorage _accountStorage)
753         BaseLogic(_accountStorage)
754         public
755     {
756     }
757 
758     // *************** Initialization ********************* //
759 
760     function initAccount(Account _account) external allowAccountCallsOnly(_account){
761         emit DappLogicInitialised(address(_account));
762     }
763 
764     // *************** action entry ********************* //
765 
766     function enter(bytes calldata _data, bytes calldata _signature, uint256 _nonce) external {
767         address account = getSignerAddress(_data);
768         checkKeyStatus(account, DAPP_KEY_INDEX);
769 
770         address dappKey = accountStorage.getKeyData(account, DAPP_KEY_INDEX);
771         checkAndUpdateNonce(dappKey, _nonce);
772         bytes32 signHash = getSignHash(_data, _nonce);
773         verifySig(dappKey, _signature, signHash);
774 
775         // solium-disable-next-line security/no-low-level-calls
776         (bool success,) = address(this).call(_data);
777         require(success, "calling self failed");
778         emit DappLogicEntered(_data, _nonce);
779     }
780 
781     // *************** call Dapp ********************* //
782 
783     // called from 'enter'
784     // call other contract from base account
785     function callContract(address payable _account, address payable _target, uint256 _value, bytes calldata _methodData) external allowSelfCallsOnly {
786         // Account(_account).invoke(_target, _value, _methodData);
787         bool success;
788         // solium-disable-next-line security/no-low-level-calls
789         (success,) = _account.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _target, _value, _methodData));
790         require(success, "calling invoke failed");
791     }
792 
793 }
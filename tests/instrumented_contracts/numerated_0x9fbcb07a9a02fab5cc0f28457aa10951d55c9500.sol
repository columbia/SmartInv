1 pragma solidity ^0.5.4;
2 
3 library RLPReader {
4     uint8 constant STRING_SHORT_START = 0x80;
5     uint8 constant STRING_LONG_START  = 0xb8;
6     uint8 constant LIST_SHORT_START   = 0xc0;
7     uint8 constant LIST_LONG_START    = 0xf8;
8     uint8 constant WORD_SIZE = 32;
9 
10     struct RLPItem {
11         uint len;
12         uint memPtr;
13     }
14 
15     struct Iterator {
16         RLPItem item;   // Item that's being iterated over.
17         uint nextPtr;   // Position of the next item in the list.
18     }
19 
20     /*
21     * @dev Returns the next element in the iteration. Reverts if it has not next element.
22     * @param self The iterator.
23     * @return The next element in the iteration.
24     */
25     function next(Iterator memory self) internal pure returns (RLPItem memory) {
26         require(hasNext(self));
27 
28         uint ptr = self.nextPtr;
29         uint itemLength = _itemLength(ptr);
30         self.nextPtr = ptr + itemLength;
31 
32         return RLPItem(itemLength, ptr);
33     }
34 
35     /*
36     * @dev Returns true if the iteration has more elements.
37     * @param self The iterator.
38     * @return true if the iteration has more elements.
39     */
40     function hasNext(Iterator memory self) internal pure returns (bool) {
41         RLPItem memory item = self.item;
42         return self.nextPtr < item.memPtr + item.len;
43     }
44 
45     /*
46     * @param item RLP encoded bytes
47     */
48     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
49         uint memPtr;
50         assembly {
51             memPtr := add(item, 0x20)
52         }
53 
54         return RLPItem(item.length, memPtr);
55     }
56 
57     /*
58     * @dev Create an iterator. Reverts if item is not a list.
59     * @param self The RLP item.
60     * @return An 'Iterator' over the item.
61     */
62     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
63         require(isList(self));
64 
65         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
66         return Iterator(self, ptr);
67     }
68 
69     /*
70     * @param item RLP encoded bytes
71     */
72     function rlpLen(RLPItem memory item) internal pure returns (uint) {
73         return item.len;
74     }
75 
76     /*
77     * @param item RLP encoded bytes
78     */
79     function payloadLen(RLPItem memory item) internal pure returns (uint) {
80         return item.len - _payloadOffset(item.memPtr);
81     }
82 
83     /*
84     * @param item RLP encoded list in bytes
85     */
86     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
87         require(isList(item));
88 
89         uint items = numItems(item);
90         RLPItem[] memory result = new RLPItem[](items);
91 
92         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
93         uint dataLen;
94         for (uint i = 0; i < items; i++) {
95             dataLen = _itemLength(memPtr);
96             result[i] = RLPItem(dataLen, memPtr); 
97             memPtr = memPtr + dataLen;
98         }
99 
100         return result;
101     }
102 
103     // @return indicator whether encoded payload is a list. negate this function call for isData.
104     function isList(RLPItem memory item) internal pure returns (bool) {
105         if (item.len == 0) return false;
106 
107         uint8 byte0;
108         uint memPtr = item.memPtr;
109         assembly {
110             byte0 := byte(0, mload(memPtr))
111         }
112 
113         if (byte0 < LIST_SHORT_START)
114             return false;
115         return true;
116     }
117 
118     /** RLPItem conversions into data types **/
119 
120     // @returns raw rlp encoding in bytes
121     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
122         bytes memory result = new bytes(item.len);
123         if (result.length == 0) return result;
124         
125         uint ptr;
126         assembly {
127             ptr := add(0x20, result)
128         }
129 
130         copy(item.memPtr, ptr, item.len);
131         return result;
132     }
133 
134     // any non-zero byte is considered true
135     function toBoolean(RLPItem memory item) internal pure returns (bool) {
136         require(item.len == 1);
137         uint result;
138         uint memPtr = item.memPtr;
139         assembly {
140             result := byte(0, mload(memPtr))
141         }
142 
143         return result == 0 ? false : true;
144     }
145 
146     function toAddress(RLPItem memory item) internal pure returns (address) {
147         // 1 byte for the length prefix
148         require(item.len == 21);
149 
150         return address(toUint(item));
151     }
152 
153     function toUint(RLPItem memory item) internal pure returns (uint) {
154         require(item.len > 0 && item.len <= 33);
155 
156         uint offset = _payloadOffset(item.memPtr);
157         uint len = item.len - offset;
158 
159         uint result;
160         uint memPtr = item.memPtr + offset;
161         assembly {
162             result := mload(memPtr)
163 
164             // shfit to the correct location if neccesary
165             if lt(len, 32) {
166                 result := div(result, exp(256, sub(32, len)))
167             }
168         }
169 
170         return result;
171     }
172 
173     // enforces 32 byte length
174     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
175         // one byte prefix
176         require(item.len == 33);
177 
178         uint result;
179         uint memPtr = item.memPtr + 1;
180         assembly {
181             result := mload(memPtr)
182         }
183 
184         return result;
185     }
186 
187     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
188         require(item.len > 0);
189 
190         uint offset = _payloadOffset(item.memPtr);
191         uint len = item.len - offset; // data length
192         bytes memory result = new bytes(len);
193 
194         uint destPtr;
195         assembly {
196             destPtr := add(0x20, result)
197         }
198 
199         copy(item.memPtr + offset, destPtr, len);
200         return result;
201     }
202 
203     /*
204     * Private Helpers
205     */
206 
207     // @return number of payload items inside an encoded list.
208     function numItems(RLPItem memory item) private pure returns (uint) {
209         if (item.len == 0) return 0;
210 
211         uint count = 0;
212         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
213         uint endPtr = item.memPtr + item.len;
214         while (currPtr < endPtr) {
215            currPtr = currPtr + _itemLength(currPtr); // skip over an item
216            count++;
217         }
218 
219         return count;
220     }
221 
222     // @return entire rlp item byte length
223     function _itemLength(uint memPtr) private pure returns (uint) {
224         uint itemLen;
225         uint byte0;
226         assembly {
227             byte0 := byte(0, mload(memPtr))
228         }
229 
230         if (byte0 < STRING_SHORT_START)
231             itemLen = 1;
232         
233         else if (byte0 < STRING_LONG_START)
234             itemLen = byte0 - STRING_SHORT_START + 1;
235 
236         else if (byte0 < LIST_SHORT_START) {
237             assembly {
238                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
239                 memPtr := add(memPtr, 1) // skip over the first byte
240                 
241                 /* 32 byte word size */
242                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
243                 itemLen := add(dataLen, add(byteLen, 1))
244             }
245         }
246 
247         else if (byte0 < LIST_LONG_START) {
248             itemLen = byte0 - LIST_SHORT_START + 1;
249         } 
250 
251         else {
252             assembly {
253                 let byteLen := sub(byte0, 0xf7)
254                 memPtr := add(memPtr, 1)
255 
256                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
257                 itemLen := add(dataLen, add(byteLen, 1))
258             }
259         }
260 
261         return itemLen;
262     }
263 
264     // @return number of bytes until the data
265     function _payloadOffset(uint memPtr) private pure returns (uint) {
266         uint byte0;
267         assembly {
268             byte0 := byte(0, mload(memPtr))
269         }
270 
271         if (byte0 < STRING_SHORT_START) 
272             return 0;
273         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
274             return 1;
275         else if (byte0 < LIST_SHORT_START)  // being explicit
276             return byte0 - (STRING_LONG_START - 1) + 1;
277         else
278             return byte0 - (LIST_LONG_START - 1) + 1;
279     }
280 
281     /*
282     * @param src Pointer to source
283     * @param dest Pointer to destination
284     * @param len Amount of memory to copy from the source
285     */
286     function copy(uint src, uint dest, uint len) private pure {
287         if (len == 0) return;
288 
289         // copy as many word sizes as possible
290         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
291             assembly {
292                 mstore(dest, mload(src))
293             }
294 
295             src += WORD_SIZE;
296             dest += WORD_SIZE;
297         }
298 
299         // left over bytes. Mask is used to remove unwanted bytes from the word
300         uint mask = 256 ** (WORD_SIZE - len) - 1;
301         assembly {
302             let srcpart := and(mload(src), not(mask)) // zero out src
303             let destpart := and(mload(dest), mask) // retrieve the bytes
304             mstore(dest, or(destpart, srcpart))
305         }
306     }
307 }
308 
309 contract Account {
310 
311     // The implementation of the proxy
312     address public implementation;
313 
314     // Logic manager
315     address public manager;
316     
317     // The enabled static calls
318     mapping (bytes4 => address) public enabled;
319 
320     event EnabledStaticCall(address indexed module, bytes4 indexed method);
321     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
322     event Received(uint indexed value, address indexed sender, bytes data);
323 
324     event AccountInit(address indexed account);
325     event ManagerChanged(address indexed mgr);
326 
327     modifier allowAuthorizedLogicContractsCallsOnly {
328         require(LogicManager(manager).isAuthorized(msg.sender), "not an authorized logic");
329         _;
330     }
331 
332     function init(address _manager, address _accountStorage, address[] calldata _logics, address[] calldata _keys, address[] calldata _backups)
333         external
334     {
335         require(manager == address(0), "Account: account already initialized");
336         require(_manager != address(0) && _accountStorage != address(0), "Account: address is null");
337         manager = _manager;
338 
339         for (uint i = 0; i < _logics.length; i++) {
340             address logic = _logics[i];
341             require(LogicManager(manager).isAuthorized(logic), "must be authorized logic");
342 
343             BaseLogic(logic).initAccount(this);
344         }
345 
346         AccountStorage(_accountStorage).initAccount(this, _keys, _backups);
347 
348         emit AccountInit(address(this));
349     }
350 
351     function invoke(address _target, uint _value, bytes calldata _data)
352         external
353         allowAuthorizedLogicContractsCallsOnly
354         returns (bytes memory _res)
355     {
356         bool success;
357         // solium-disable-next-line security/no-call-value
358         (success, _res) = _target.call.value(_value)(_data);
359         require(success, "call to target failed");
360         emit Invoked(msg.sender, _target, _value, _data);
361     }
362 
363     /**
364     * @dev Enables a static method by specifying the target module to which the call must be delegated.
365     * @param _module The target module.
366     * @param _method The static method signature.
367     */
368     function enableStaticCall(address _module, bytes4 _method) external allowAuthorizedLogicContractsCallsOnly {
369         enabled[_method] = _module;
370         emit EnabledStaticCall(_module, _method);
371     }
372 
373     function changeManager(address _newMgr) external allowAuthorizedLogicContractsCallsOnly {
374         require(_newMgr != address(0), "address cannot be null");
375         require(_newMgr != manager, "already changed");
376         manager = _newMgr;
377         emit ManagerChanged(_newMgr);
378     }
379 
380      /**
381      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
382      * implement specific static methods. It delegates the static call to a target contract if the data corresponds
383      * to an enabled method, or logs the call otherwise.
384      */
385     function() external payable {
386         if(msg.data.length > 0) {
387             address logic = enabled[msg.sig];
388             if(logic == address(0)) {
389                 emit Received(msg.value, msg.sender, msg.data);
390             }
391             else {
392                 require(LogicManager(manager).isAuthorized(logic), "must be an authorized logic for static call");
393                 // solium-disable-next-line security/no-inline-assembly
394                 assembly {
395                     calldatacopy(0, 0, calldatasize())
396                     let result := staticcall(gas, logic, 0, calldatasize(), 0, 0)
397                     returndatacopy(0, 0, returndatasize())
398                     switch result
399                     case 0 {revert(0, returndatasize())}
400                     default {return (0, returndatasize())}
401                 }
402             }
403         }
404     }
405 }
406 
407 contract Owned {
408 
409     // The owner
410     address public owner;
411 
412     event OwnerChanged(address indexed _newOwner);
413 
414     /**
415      * @dev Throws if the sender is not the owner.
416      */
417     modifier onlyOwner {
418         require(msg.sender == owner, "Must be owner");
419         _;
420     }
421 
422     constructor() public {
423         owner = msg.sender;
424     }
425 
426     /**
427      * @dev Lets the owner transfer ownership of the contract to a new owner.
428      * @param _newOwner The new owner.
429      */
430     function changeOwner(address _newOwner) external onlyOwner {
431         require(_newOwner != address(0), "Address must not be null");
432         owner = _newOwner;
433         emit OwnerChanged(_newOwner);
434     }
435 }
436 
437 contract LogicManager is Owned {
438 
439     event UpdateLogicSubmitted(address indexed logic, bool value);
440     event UpdateLogicCancelled(address indexed logic);
441     event UpdateLogicDone(address indexed logic, bool value);
442 
443     struct pending {
444         bool value;
445         uint dueTime;
446     }
447 
448     // The authorized logic modules
449     mapping (address => bool) public authorized;
450 
451     /*
452     array
453     index 0: AccountLogic address
454           1: TransferLogic address
455           2: DualsigsLogic address
456           3: DappLogic address
457           4: ...
458      */
459     address[] public authorizedLogics;
460 
461     // updated logics and their due time of becoming effective
462     mapping (address => pending) public pendingLogics;
463 
464     // pending time before updated logics take effect
465     struct pendingTime {
466         uint curPendingTime;
467         uint nextPendingTime;
468         uint dueTime;
469     }
470 
471     pendingTime public pt;
472 
473     // how many authorized logics
474     uint public logicCount;
475 
476     constructor(address[] memory _initialLogics, uint256 _pendingTime) public
477     {
478         for (uint i = 0; i < _initialLogics.length; i++) {
479             address logic = _initialLogics[i];
480             authorized[logic] = true;
481             logicCount += 1;
482         }
483         authorizedLogics = _initialLogics;
484 
485         pt.curPendingTime = _pendingTime;
486         pt.nextPendingTime = _pendingTime;
487         pt.dueTime = now;
488     }
489 
490     function submitUpdatePendingTime(uint _pendingTime) external onlyOwner {
491         pt.nextPendingTime = _pendingTime;
492         pt.dueTime = pt.curPendingTime + now;
493     }
494 
495     function triggerUpdatePendingTime() external {
496         require(pt.dueTime <= now, "too early to trigger updatePendingTime");
497         pt.curPendingTime = pt.nextPendingTime;
498     }
499 
500     function isAuthorized(address _logic) external view returns (bool) {
501         return authorized[_logic];
502     }
503 
504     function getAuthorizedLogics() external view returns (address[] memory) {
505         return authorizedLogics;
506     }
507 
508     function submitUpdate(address _logic, bool _value) external onlyOwner {
509         pending storage p = pendingLogics[_logic];
510         p.value = _value;
511         p.dueTime = now + pt.curPendingTime;
512         emit UpdateLogicSubmitted(_logic, _value);
513     }
514 
515     function cancelUpdate(address _logic) external onlyOwner {
516         delete pendingLogics[_logic];
517         emit UpdateLogicCancelled(_logic);
518     }
519 
520     function triggerUpdateLogic(address _logic) external {
521         pending memory p = pendingLogics[_logic];
522         require(p.dueTime > 0, "pending logic not found");
523         require(p.dueTime <= now, "too early to trigger updateLogic");
524         updateLogic(_logic, p.value);
525         delete pendingLogics[_logic];
526     }
527 
528     function updateLogic(address _logic, bool _value) internal {
529         if (authorized[_logic] != _value) {
530             if(_value) {
531                 logicCount += 1;
532                 authorized[_logic] = true;
533                 authorizedLogics.push(_logic);
534             }
535             else {
536                 logicCount -= 1;
537                 require(logicCount > 0, "must have at least one logic module");
538                 delete authorized[_logic];
539                 removeLogic(_logic);
540             }
541             emit UpdateLogicDone(_logic, _value);
542         }
543     }
544 
545     function removeLogic(address _logic) internal {
546         uint len = authorizedLogics.length;
547         address lastLogic = authorizedLogics[len - 1];
548         if (_logic != lastLogic) {
549             for (uint i = 0; i < len; i++) {
550                  if (_logic == authorizedLogics[i]) {
551                      authorizedLogics[i] = lastLogic;
552                      break;
553                  }
554             }
555         }
556         authorizedLogics.length--;
557     }
558 }
559 
560 contract AccountStorage {
561 
562     modifier allowAccountCallsOnly(Account _account) {
563         require(msg.sender == address(_account), "caller must be account");
564         _;
565     }
566 
567     modifier allowAuthorizedLogicContractsCallsOnly(address payable _account) {
568         require(LogicManager(Account(_account).manager()).isAuthorized(msg.sender), "not an authorized logic");
569         _;
570     }
571 
572     struct KeyItem {
573         address pubKey;
574         uint256 status;
575     }
576 
577     struct BackupAccount {
578         address backup;
579         uint256 effectiveDate;//means not effective until this timestamp
580         uint256 expiryDate;//means effective until this timestamp
581     }
582 
583     struct DelayItem {
584         bytes32 hash;
585         uint256 dueTime;
586     }
587 
588     struct Proposal {
589         bytes32 hash;
590         address[] approval;
591     }
592 
593     // account => quantity of operation keys (index >= 1)
594     mapping (address => uint256) operationKeyCount;
595 
596     // account => index => KeyItem
597     mapping (address => mapping(uint256 => KeyItem)) keyData;
598 
599     // account => index => backup account
600     mapping (address => mapping(uint256 => BackupAccount)) backupData;
601 
602     /* account => actionId => DelayItem
603 
604        delayData applies to these 4 actions:
605        changeAdminKey, changeAllOperationKeys, unfreeze, changeAdminKeyByBackup
606     */
607     mapping (address => mapping(bytes4 => DelayItem)) delayData;
608 
609     // client account => proposer account => proposed actionId => Proposal
610     mapping (address => mapping(address => mapping(bytes4 => Proposal))) proposalData;
611 
612     // *************** keyCount ********************** //
613 
614     function getOperationKeyCount(address _account) external view returns(uint256) {
615         return operationKeyCount[_account];
616     }
617 
618     function increaseKeyCount(address payable _account) external allowAuthorizedLogicContractsCallsOnly(_account) {
619         operationKeyCount[_account] = operationKeyCount[_account] + 1;
620     }
621 
622     // *************** keyData ********************** //
623 
624     function getKeyData(address _account, uint256 _index) public view returns(address) {
625         KeyItem memory item = keyData[_account][_index];
626         return item.pubKey;
627     }
628 
629     function setKeyData(address payable _account, uint256 _index, address _key) external allowAuthorizedLogicContractsCallsOnly(_account) {
630         require(_key != address(0), "invalid _key value");
631         KeyItem storage item = keyData[_account][_index];
632         item.pubKey = _key;
633     }
634 
635     // *************** keyStatus ********************** //
636 
637     function getKeyStatus(address _account, uint256 _index) external view returns(uint256) {
638         KeyItem memory item = keyData[_account][_index];
639         return item.status;
640     }
641 
642     function setKeyStatus(address payable _account, uint256 _index, uint256 _status) external allowAuthorizedLogicContractsCallsOnly(_account) {
643         KeyItem storage item = keyData[_account][_index];
644         item.status = _status;
645     }
646 
647     // *************** backupData ********************** //
648 
649     function getBackupAddress(address _account, uint256 _index) external view returns(address) {
650         BackupAccount memory b = backupData[_account][_index];
651         return b.backup;
652     }
653 
654     function getBackupEffectiveDate(address _account, uint256 _index) external view returns(uint256) {
655         BackupAccount memory b = backupData[_account][_index];
656         return b.effectiveDate;
657     }
658 
659     function getBackupExpiryDate(address _account, uint256 _index) external view returns(uint256) {
660         BackupAccount memory b = backupData[_account][_index];
661         return b.expiryDate;
662     }
663 
664     function setBackup(address payable _account, uint256 _index, address _backup, uint256 _effective, uint256 _expiry)
665         external
666         allowAuthorizedLogicContractsCallsOnly(_account)
667     {
668         BackupAccount storage b = backupData[_account][_index];
669         b.backup = _backup;
670         b.effectiveDate = _effective;
671         b.expiryDate = _expiry;
672     }
673 
674     function setBackupExpiryDate(address payable _account, uint256 _index, uint256 _expiry)
675         external
676         allowAuthorizedLogicContractsCallsOnly(_account)
677     {
678         BackupAccount storage b = backupData[_account][_index];
679         b.expiryDate = _expiry;
680     }
681 
682     function clearBackupData(address payable _account, uint256 _index) external allowAuthorizedLogicContractsCallsOnly(_account) {
683         delete backupData[_account][_index];
684     }
685 
686     // *************** delayData ********************** //
687 
688     function getDelayDataHash(address payable _account, bytes4 _actionId) external view returns(bytes32) {
689         DelayItem memory item = delayData[_account][_actionId];
690         return item.hash;
691     }
692 
693     function getDelayDataDueTime(address payable _account, bytes4 _actionId) external view returns(uint256) {
694         DelayItem memory item = delayData[_account][_actionId];
695         return item.dueTime;
696     }
697 
698     function setDelayData(address payable _account, bytes4 _actionId, bytes32 _hash, uint256 _dueTime) external allowAuthorizedLogicContractsCallsOnly(_account) {
699         DelayItem storage item = delayData[_account][_actionId];
700         item.hash = _hash;
701         item.dueTime = _dueTime;
702     }
703 
704     function clearDelayData(address payable _account, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_account) {
705         delete delayData[_account][_actionId];
706     }
707 
708     // *************** proposalData ********************** //
709 
710     function getProposalDataHash(address _client, address _proposer, bytes4 _actionId) external view returns(bytes32) {
711         Proposal memory p = proposalData[_client][_proposer][_actionId];
712         return p.hash;
713     }
714 
715     function getProposalDataApproval(address _client, address _proposer, bytes4 _actionId) external view returns(address[] memory) {
716         Proposal memory p = proposalData[_client][_proposer][_actionId];
717         return p.approval;
718     }
719 
720     function setProposalData(address payable _client, address _proposer, bytes4 _actionId, bytes32 _hash, address _approvedBackup)
721         external
722         allowAuthorizedLogicContractsCallsOnly(_client)
723     {
724         Proposal storage p = proposalData[_client][_proposer][_actionId];
725         if (p.hash > 0) {
726             if (p.hash == _hash) {
727                 for (uint256 i = 0; i < p.approval.length; i++) {
728                     require(p.approval[i] != _approvedBackup, "backup already exists");
729                 }
730                 p.approval.push(_approvedBackup);
731             } else {
732                 p.hash = _hash;
733                 p.approval.length = 0;
734             }
735         } else {
736             p.hash = _hash;
737             p.approval.push(_approvedBackup);
738         }
739     }
740 
741     function clearProposalData(address payable _client, address _proposer, bytes4 _actionId) external allowAuthorizedLogicContractsCallsOnly(_client) {
742         delete proposalData[_client][_proposer][_actionId];
743     }
744 
745 
746     // *************** init ********************** //
747     function initAccount(Account _account, address[] calldata _keys, address[] calldata _backups)
748         external
749         allowAccountCallsOnly(_account)
750     {
751         require(getKeyData(address(_account), 0) == address(0), "AccountStorage: account already initialized!");
752         require(_keys.length > 0, "empty keys array");
753 
754         operationKeyCount[address(_account)] = _keys.length - 1;
755 
756         for (uint256 index = 0; index < _keys.length; index++) {
757             address _key = _keys[index];
758             require(_key != address(0), "_key cannot be 0x0");
759             KeyItem storage item = keyData[address(_account)][index];
760             item.pubKey = _key;
761             item.status = 0;
762         }
763 
764         // avoid backup duplication if _backups.length > 1
765         // normally won't check duplication, in most cases only one initial backup when initialization
766         if (_backups.length > 1) {
767             address[] memory bkps = _backups;
768             for (uint256 i = 0; i < _backups.length; i++) {
769                 for (uint256 j = 0; j < i; j++) {
770                     require(bkps[j] != _backups[i], "duplicate backup");
771                 }
772             }
773         }
774 
775         for (uint256 index = 0; index < _backups.length; index++) {
776             address _backup = _backups[index];
777             require(_backup != address(0), "backup cannot be 0x0");
778             require(_backup != address(_account), "cannot be backup of oneself");
779 
780             backupData[address(_account)][index] = BackupAccount(_backup, now, uint256(-1));
781         }
782     }
783 }
784 
785 /* The MIT License (MIT)
786 
787 Copyright (c) 2016 Smart Contract Solutions, Inc.
788 
789 Permission is hereby granted, free of charge, to any person obtaining
790 a copy of this software and associated documentation files (the
791 "Software"), to deal in the Software without restriction, including
792 without limitation the rights to use, copy, modify, merge, publish,
793 distribute, sublicense, and/or sell copies of the Software, and to
794 permit persons to whom the Software is furnished to do so, subject to
795 the following conditions:
796 
797 The above copyright notice and this permission notice shall be included
798 in all copies or substantial portions of the Software.
799 
800 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
801 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
802 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
803 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
804 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
805 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
806 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
807 
808 /**
809  * @title SafeMath
810  * @dev Math operations with safety checks that throw on error
811  */
812 library SafeMath {
813 
814     /**
815     * @dev Multiplies two numbers, reverts on overflow.
816     */
817     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
818         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
819         // benefit is lost if 'b' is also tested.
820         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
821         if (a == 0) {
822             return 0;
823         }
824 
825         uint256 c = a * b;
826         require(c / a == b);
827 
828         return c;
829     }
830 
831     /**
832     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
833     */
834     function div(uint256 a, uint256 b) internal pure returns (uint256) {
835         require(b > 0); // Solidity only automatically asserts when dividing by 0
836         uint256 c = a / b;
837         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
838 
839         return c;
840     }
841 
842     /**
843     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
844     */
845     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
846         require(b <= a);
847         uint256 c = a - b;
848 
849         return c;
850     }
851 
852     /**
853     * @dev Adds two numbers, reverts on overflow.
854     */
855     function add(uint256 a, uint256 b) internal pure returns (uint256) {
856         uint256 c = a + b;
857         require(c >= a);
858 
859         return c;
860     }
861 
862     /**
863     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
864     * reverts when dividing by zero.
865     */
866     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
867         require(b != 0);
868         return a % b;
869     }
870 
871     /**
872     * @dev Returns ceil(a / b).
873     */
874     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
875         uint256 c = a / b;
876         if(a % b == 0) {
877             return c;
878         }
879         else {
880             return c + 1;
881         }
882     }
883 }
884 
885 contract BaseLogic {
886 
887     bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
888 
889     mapping (address => uint256) keyNonce;
890     AccountStorage public accountStorage;
891 
892     modifier allowSelfCallsOnly() {
893         require (msg.sender == address(this), "only internal call is allowed");
894         _;
895     }
896 
897     modifier allowAccountCallsOnly(Account _account) {
898         require(msg.sender == address(_account), "caller must be account");
899         _;
900     }
901 
902     event LogicInitialised(address wallet);
903 
904     // *************** Constructor ********************** //
905 
906     constructor(AccountStorage _accountStorage) public {
907         accountStorage = _accountStorage;
908     }
909 
910     // *************** Initialization ********************* //
911 
912     function initAccount(Account _account) external allowAccountCallsOnly(_account){
913         emit LogicInitialised(address(_account));
914     }
915 
916     // *************** Getter ********************** //
917 
918     function getKeyNonce(address _key) external view returns(uint256) {
919         return keyNonce[_key];
920     }
921 
922     // *************** Signature ********************** //
923 
924     function getSignHash(bytes memory _data, uint256 _nonce) internal view returns(bytes32) {
925         // use EIP 191
926         // 0x1900 + this logic address + data + nonce of signing key
927         bytes32 msgHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _data, _nonce));
928         bytes32 prefixedHash = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, msgHash));
929         return prefixedHash;
930     }
931 
932     function verifySig(address _signingKey, bytes memory _signature, bytes32 _signHash) internal pure {
933         require(_signingKey != address(0), "invalid signing key");
934         address recoveredAddr = recover(_signHash, _signature);
935         require(recoveredAddr == _signingKey, "signature verification failed");
936     }
937 
938     /**
939      * @dev Returns the address that signed a hashed message (`hash`) with
940      * `signature`. This address can then be used for verification purposes.
941      *
942      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
943      * this function rejects them by requiring the `s` value to be in the lower
944      * half order, and the `v` value to be either 27 or 28.
945      *
946      * NOTE: This call _does not revert_ if the signature is invalid, or
947      * if the signer is otherwise unable to be retrieved. In those scenarios,
948      * the zero address is returned.
949      *
950      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
951      * verification to be secure: it is possible to craft signatures that
952      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
953      * this is by receiving a hash of the original message (which may otherwise)
954      * be too long), and then calling {toEthSignedMessageHash} on it.
955      */
956     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
957         // Check the signature length
958         if (signature.length != 65) {
959             return (address(0));
960         }
961 
962         // Divide the signature in r, s and v variables
963         bytes32 r;
964         bytes32 s;
965         uint8 v;
966 
967         // ecrecover takes the signature parameters, and the only way to get them
968         // currently is to use assembly.
969         // solhint-disable-next-line no-inline-assembly
970         assembly {
971             r := mload(add(signature, 0x20))
972             s := mload(add(signature, 0x40))
973             v := byte(0, mload(add(signature, 0x60)))
974         }
975 
976         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
977         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
978         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
979         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
980         //
981         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
982         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
983         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
984         // these malleable signatures as well.
985         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
986             return address(0);
987         }
988 
989         if (v != 27 && v != 28) {
990             return address(0);
991         }
992 
993         // If the signature is valid (and not malleable), return the signer address
994         return ecrecover(hash, v, r, s);
995     }
996 
997     /* get signer address from data
998     * @dev Gets an address encoded as the first argument in transaction data
999     * @param b The byte array that should have an address as first argument
1000     * @returns a The address retrieved from the array
1001     */
1002     function getSignerAddress(bytes memory _b) internal pure returns (address _a) {
1003         require(_b.length >= 36, "invalid bytes");
1004         // solium-disable-next-line security/no-inline-assembly
1005         assembly {
1006             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
1007             _a := and(mask, mload(add(_b, 36)))
1008             // b = {length:32}{method sig:4}{address:32}{...}
1009             // 36 is the offset of the first parameter of the data, if encoded properly.
1010             // 32 bytes for the length of the bytes array, and the first 4 bytes for the function signature.
1011             // 32 bytes is the length of the bytes array!!!!
1012         }
1013     }
1014 
1015     // get method id, first 4 bytes of data
1016     function getMethodId(bytes memory _b) internal pure returns (bytes4 _a) {
1017         require(_b.length >= 4, "invalid data");
1018         // solium-disable-next-line security/no-inline-assembly
1019         assembly {
1020             // 32 bytes is the length of the bytes array
1021             _a := mload(add(_b, 32))
1022         }
1023     }
1024 
1025     function checkKeyStatus(address _account, uint256 _index) internal {
1026         // check operation key status
1027         if (_index > 0) {
1028             require(accountStorage.getKeyStatus(_account, _index) != 1, "frozen key");
1029         }
1030     }
1031 
1032     // _nonce is timestamp in microsecond(1/1000000 second)
1033     function checkAndUpdateNonce(address _key, uint256 _nonce) internal {
1034         require(_nonce > keyNonce[_key], "nonce too small");
1035         require(SafeMath.div(_nonce, 1000000) <= now + 86400, "nonce too big"); // 86400=24*3600 seconds
1036 
1037         keyNonce[_key] = _nonce;
1038     }
1039 }
1040 
1041 contract DappLogic is BaseLogic {
1042     
1043     using RLPReader for RLPReader.RLPItem;
1044     using RLPReader for bytes;
1045 
1046     /*
1047     index 0: admin key
1048           1: asset(transfer)
1049           2: adding
1050           3: reserved(dapp)
1051           4: assist
1052      */
1053     uint constant internal DAPP_KEY_INDEX = 3;
1054 
1055     // *************** Events *************************** //
1056 
1057     event DappLogicInitialised(address indexed account);
1058     event DappLogicEntered(bytes data, uint256 indexed nonce);
1059 
1060     // *************** Constructor ********************** //
1061     constructor(AccountStorage _accountStorage)
1062         BaseLogic(_accountStorage)
1063         public
1064     {
1065     }
1066 
1067     // *************** Initialization ********************* //
1068 
1069     function initAccount(Account _account) external allowAccountCallsOnly(_account){
1070         emit DappLogicInitialised(address(_account));
1071     }
1072 
1073     // *************** action entry ********************* //
1074 
1075     function enter(bytes calldata _data, bytes calldata _signature, uint256 _nonce) external {
1076         address account = getSignerAddress(_data);
1077         checkKeyStatus(account, DAPP_KEY_INDEX);
1078 
1079         address dappKey = accountStorage.getKeyData(account, DAPP_KEY_INDEX);
1080         checkAndUpdateNonce(dappKey, _nonce);
1081         bytes32 signHash = getSignHash(_data, _nonce);
1082         verifySig(dappKey, _signature, signHash);
1083 
1084         // solium-disable-next-line security/no-low-level-calls
1085         (bool success,) = address(this).call(_data);
1086         require(success, "calling self failed");
1087         emit DappLogicEntered(_data, _nonce);
1088     }
1089 
1090     // *************** call Dapp ********************* //
1091 
1092     // called from 'enter'
1093     // call other contract from base account
1094     function callContract(address payable _account, address payable _target, uint256 _value, bytes calldata _methodData) external allowSelfCallsOnly {
1095         // Account(_account).invoke(_target, _value, _methodData);
1096         bool success;
1097         // solium-disable-next-line security/no-low-level-calls
1098         (success,) = _account.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _target, _value, _methodData));
1099         require(success, "calling invoke failed");
1100     }
1101     
1102     // called from 'enter'
1103     // call serveral other contracts at a time
1104     // rlp encode _methodData array into rlpBytes
1105     function callMultiContract(address payable _account, address[] calldata _targets, uint256[] calldata _values, bytes calldata _rlpBytes) external allowSelfCallsOnly {
1106         RLPReader.RLPItem[] memory ls = _rlpBytes.toRlpItem().toList();
1107 
1108         uint256 len = _targets.length;
1109         require(len == _values.length && len == ls.length, "length mismatch");
1110         for (uint256 i = 0; i < len; i++) {
1111             bool success;
1112             RLPReader.RLPItem memory item = ls[i];
1113             // solium-disable-next-line security/no-low-level-calls
1114             (success,) = _account.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _targets[i], _values[i], bytes(item.toBytes())));
1115             require(success, "calling invoke failed");
1116         }
1117     }
1118 
1119 }
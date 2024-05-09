1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-28
3 */
4 
5 // File: contracts/EToken2Interface.sol
6 
7 pragma solidity 0.5.8;
8 
9 
10 contract RegistryICAPInterface {
11     function parse(bytes32 _icap) public view returns(address, bytes32, bool);
12     function institutions(bytes32 _institution) public view returns(address);
13 }
14 
15 
16 contract EToken2Interface {
17     function registryICAP() public view returns(RegistryICAPInterface);
18     function baseUnit(bytes32 _symbol) public view returns(uint8);
19     function description(bytes32 _symbol) public view returns(string memory);
20     function owner(bytes32 _symbol) public view returns(address);
21     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
22     function totalSupply(bytes32 _symbol) public view returns(uint);
23     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
24     function isLocked(bytes32 _symbol) public view returns(bool);
25 
26     function issueAsset(
27         bytes32 _symbol,
28         uint _value,
29         string memory _name,
30         string memory _description,
31         uint8 _baseUnit,
32         bool _isReissuable)
33     public returns(bool);
34 
35     function reissueAsset(bytes32 _symbol, uint _value) public returns(bool);
36     function revokeAsset(bytes32 _symbol, uint _value) public returns(bool);
37     function setProxy(address _address, bytes32 _symbol) public returns(bool);
38     function lockAsset(bytes32 _symbol) public returns(bool);
39 
40     function proxyTransferFromToICAPWithReference(
41         address _from,
42         bytes32 _icap,
43         uint _value,
44         string memory _reference,
45         address _sender)
46     public returns(bool);
47 
48     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender)
49     public returns(bool);
50     
51     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
52 
53     function proxyTransferFromWithReference(
54         address _from,
55         address _to,
56         uint _value,
57         bytes32 _symbol,
58         string memory _reference,
59         address _sender)
60     public returns(bool);
61 
62     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);
63 }
64 
65 // File: contracts/AssetInterface.sol
66 
67 pragma solidity 0.5.8;
68 
69 
70 contract AssetInterface {
71     function _performTransferWithReference(
72         address _to,
73         uint _value,
74         string memory _reference,
75         address _sender)
76     public returns(bool);
77 
78     function _performTransferToICAPWithReference(
79         bytes32 _icap,
80         uint _value,
81         string memory _reference,
82         address _sender)
83     public returns(bool);
84 
85     function _performApprove(address _spender, uint _value, address _sender)
86     public returns(bool);
87 
88     function _performTransferFromWithReference(
89         address _from,
90         address _to,
91         uint _value,
92         string memory _reference,
93         address _sender)
94     public returns(bool);
95 
96     function _performTransferFromToICAPWithReference(
97         address _from,
98         bytes32 _icap,
99         uint _value,
100         string memory _reference,
101         address _sender)
102     public returns(bool);
103 
104     function _performGeneric(bytes memory, address) public payable {
105         revert();
106     }
107 }
108 
109 // File: contracts/ERC20Interface.sol
110 
111 pragma solidity 0.5.8;
112 
113 
114 contract ERC20Interface {
115     event Transfer(address indexed from, address indexed to, uint256 value);
116     event Approval(address indexed from, address indexed spender, uint256 value);
117 
118     function totalSupply() public view returns(uint256 supply);
119     function balanceOf(address _owner) public view returns(uint256 balance);
120     // solhint-disable-next-line no-simple-event-func-name
121     function transfer(address _to, uint256 _value) public returns(bool success);
122     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
123     function approve(address _spender, uint256 _value) public returns(bool success);
124     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
125 
126     // function symbol() constant returns(string);
127     function decimals() public view returns(uint8);
128     // function name() constant returns(string);
129 }
130 
131 // File: contracts/AssetProxyInterface.sol
132 
133 pragma solidity 0.5.8;
134 
135 
136 
137 contract AssetProxyInterface is ERC20Interface {
138     function _forwardApprove(address _spender, uint _value, address _sender)
139     public returns(bool);
140 
141     function _forwardTransferFromWithReference(
142         address _from,
143         address _to,
144         uint _value,
145         string memory _reference,
146         address _sender)
147     public returns(bool);
148 
149     function _forwardTransferFromToICAPWithReference(
150         address _from,
151         bytes32 _icap,
152         uint _value,
153         string memory _reference,
154         address _sender)
155     public returns(bool);
156 
157     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
158     public returns(bool);
159 
160     function etoken2() external view returns(address); // To be replaced by the implicit getter;
161 
162     // To be replaced by the implicit getter;
163     function etoken2Symbol() external view returns(bytes32);
164 }
165 
166 // File: smart-contracts-common/contracts/Bytes32.sol
167 
168 pragma solidity 0.5.8;
169 
170 
171 contract Bytes32 {
172     function _bytes32(string memory _input) internal pure returns(bytes32 result) {
173         assembly {
174             result := mload(add(_input, 32))
175         }
176     }
177 }
178 
179 // File: smart-contracts-common/contracts/ReturnData.sol
180 
181 pragma solidity 0.5.8;
182 
183 
184 contract ReturnData {
185     function _returnReturnData(bool _success) internal pure {
186         assembly {
187             let returndatastart := 0
188             returndatacopy(returndatastart, 0, returndatasize)
189             switch _success case 0 { revert(returndatastart, returndatasize) }
190                 default { return(returndatastart, returndatasize) }
191         }
192     }
193 
194     function _assemblyCall(address _destination, uint _value, bytes memory _data)
195     internal returns(bool success) {
196         assembly {
197             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
198         }
199     }
200 }
201 
202 // File: contracts/AssetProxy.sol
203 
204 pragma solidity 0.5.8;
205 
206 
207 
208 
209 
210 
211 
212 
213 /**
214  * @title EToken2 Asset Proxy.
215  *
216  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
217  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
218  * Every request that is made by caller first sent to the specific asset implementation
219  * contract, which then calls back to be forwarded onto EToken2.
220  *
221  * Calls flow: Caller ->
222  *             Proxy.func(...) ->
223  *             Asset._performFunc(..., Caller.address) ->
224  *             Proxy._forwardFunc(..., Caller.address) ->
225  *             Platform.proxyFunc(..., symbol, Caller.address)
226  *
227  * Generic call flow: Caller ->
228  *             Proxy.unknownFunc(...) ->
229  *             Asset._performGeneric(..., Caller.address) ->
230  *             Asset.unknownFunc(...)
231  *
232  * Asset implementation contract is mutable, but each user have an option to stick with
233  * old implementation, through explicit decision made in timely manner, if he doesn't agree
234  * with new rules.
235  * Each user have a possibility to upgrade to latest asset contract implementation, without the
236  * possibility to rollback.
237  *
238  * Note: all the non constant functions return false instead of throwing in case if state change
239  * didn't happen yet.
240  */
241 contract CLEIToken is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
242     // Assigned EToken2, immutable.
243     EToken2Interface public etoken2;
244 
245     // Assigned symbol, immutable.
246     bytes32 public etoken2Symbol;
247 
248     // Assigned name, immutable. For UI.
249     string public name;
250     string public symbol;
251 
252     /**
253      * Sets EToken2 address, assigns symbol and name.
254      *
255      * Can be set only once.
256      *
257      * @param _etoken2 EToken2 contract address.
258      * @param _symbol assigned symbol.
259      * @param _name assigned name.
260      *
261      * @return success.
262      */
263     function init(EToken2Interface _etoken2, string memory _symbol, string memory _name)
264         public returns(bool)
265     {
266         if (address(etoken2) != address(0)) {
267             return false;
268         }
269         etoken2 = _etoken2;
270         etoken2Symbol = _bytes32(_symbol);
271         name = _name;
272         symbol = _symbol;
273         return true;
274     }
275 
276     /**
277      * Only EToken2 is allowed to call.
278      */
279     modifier onlyEToken2() {
280         if (msg.sender == address(etoken2)) {
281             _;
282         }
283     }
284 
285     /**
286      * Only current asset owner is allowed to call.
287      */
288     modifier onlyAssetOwner() {
289         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
290             _;
291         }
292     }
293 
294     /**
295      * Returns asset implementation contract for current caller.
296      *
297      * @return asset implementation contract.
298      */
299     function _getAsset() internal view returns(AssetInterface) {
300         return AssetInterface(getVersionFor(msg.sender));
301     }
302 
303     /**
304      * Recovers tokens on proxy contract
305      *
306      * @param _asset type of tokens to recover.
307      * @param _value tokens that will be recovered.
308      * @param _receiver address where to send recovered tokens.
309      *
310      * @return success.
311      */
312     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
313     public onlyAssetOwner() returns(bool) {
314         return _asset.transfer(_receiver, _value);
315     }
316 
317     /**
318      * Returns asset total supply.
319      *
320      * @return asset total supply.
321      */
322     function totalSupply() public view returns(uint) {
323         return etoken2.totalSupply(etoken2Symbol);
324     }
325 
326     /**
327      * Returns asset balance for a particular holder.
328      *
329      * @param _owner holder address.
330      *
331      * @return holder balance.
332      */
333     function balanceOf(address _owner) public view returns(uint) {
334         return etoken2.balanceOf(_owner, etoken2Symbol);
335     }
336 
337     /**
338      * Returns asset allowance from one holder to another.
339      *
340      * @param _from holder that allowed spending.
341      * @param _spender holder that is allowed to spend.
342      *
343      * @return holder to spender allowance.
344      */
345     function allowance(address _from, address _spender) public view returns(uint) {
346         return etoken2.allowance(_from, _spender, etoken2Symbol);
347     }
348 
349     /**
350      * Returns asset decimals.
351      *
352      * @return asset decimals.
353      */
354     function decimals() public view returns(uint8) {
355         return etoken2.baseUnit(etoken2Symbol);
356     }
357 
358     /**
359      * Transfers asset balance from the caller to specified receiver.
360      *
361      * @param _to holder address to give to.
362      * @param _value amount to transfer.
363      *
364      * @return success.
365      */
366     function transfer(address _to, uint _value) public returns(bool) {
367         return transferWithReference(_to, _value, '');
368     }
369 
370     /**
371      * Transfers asset balance from the caller to specified receiver adding specified comment.
372      * Resolves asset implementation contract for the caller and forwards there arguments along with
373      * the caller address.
374      *
375      * @param _to holder address to give to.
376      * @param _value amount to transfer.
377      * @param _reference transfer comment to be included in a EToken2's Transfer event.
378      *
379      * @return success.
380      */
381     function transferWithReference(address _to, uint _value, string memory _reference)
382     public returns(bool) {
383         return _getAsset()._performTransferWithReference(
384             _to, _value, _reference, msg.sender);
385     }
386 
387     /**
388      * Transfers asset balance from the caller to specified ICAP.
389      *
390      * @param _icap recipient ICAP to give to.
391      * @param _value amount to transfer.
392      *
393      * @return success.
394      */
395     function transferToICAP(bytes32 _icap, uint _value) public returns(bool) {
396         return transferToICAPWithReference(_icap, _value, '');
397     }
398 
399     /**
400      * Transfers asset balance from the caller to specified ICAP adding specified comment.
401      * Resolves asset implementation contract for the caller and forwards there arguments along with
402      * the caller address.
403      *
404      * @param _icap recipient ICAP to give to.
405      * @param _value amount to transfer.
406      * @param _reference transfer comment to be included in a EToken2's Transfer event.
407      *
408      * @return success.
409      */
410     function transferToICAPWithReference(
411         bytes32 _icap,
412         uint _value,
413         string memory _reference)
414     public returns(bool) {
415         return _getAsset()._performTransferToICAPWithReference(
416             _icap, _value, _reference, msg.sender);
417     }
418 
419     /**
420      * Prforms allowance transfer of asset balance between holders.
421      *
422      * @param _from holder address to take from.
423      * @param _to holder address to give to.
424      * @param _value amount to transfer.
425      *
426      * @return success.
427      */
428     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
429         return transferFromWithReference(_from, _to, _value, '');
430     }
431 
432     /**
433      * Prforms allowance transfer of asset balance between holders adding specified comment.
434      * Resolves asset implementation contract for the caller and forwards there arguments along with
435      * the caller address.
436      *
437      * @param _from holder address to take from.
438      * @param _to holder address to give to.
439      * @param _value amount to transfer.
440      * @param _reference transfer comment to be included in a EToken2's Transfer event.
441      *
442      * @return success.
443      */
444     function transferFromWithReference(
445         address _from,
446         address _to,
447         uint _value,
448         string memory _reference)
449     public returns(bool) {
450         return _getAsset()._performTransferFromWithReference(
451             _from,
452             _to,
453             _value,
454             _reference,
455             msg.sender
456         );
457     }
458 
459     /**
460      * Performs transfer call on the EToken2 by the name of specified sender.
461      *
462      * Can only be called by asset implementation contract assigned to sender.
463      *
464      * @param _from holder address to take from.
465      * @param _to holder address to give to.
466      * @param _value amount to transfer.
467      * @param _reference transfer comment to be included in a EToken2's Transfer event.
468      * @param _sender initial caller.
469      *
470      * @return success.
471      */
472     function _forwardTransferFromWithReference(
473         address _from,
474         address _to,
475         uint _value,
476         string memory _reference,
477         address _sender)
478     public onlyImplementationFor(_sender) returns(bool) {
479         return etoken2.proxyTransferFromWithReference(
480             _from,
481             _to,
482             _value,
483             etoken2Symbol,
484             _reference,
485             _sender
486         );
487     }
488 
489     /**
490      * Prforms allowance transfer of asset balance between holders.
491      *
492      * @param _from holder address to take from.
493      * @param _icap recipient ICAP address to give to.
494      * @param _value amount to transfer.
495      *
496      * @return success.
497      */
498     function transferFromToICAP(address _from, bytes32 _icap, uint _value)
499     public returns(bool) {
500         return transferFromToICAPWithReference(_from, _icap, _value, '');
501     }
502 
503     /**
504      * Prforms allowance transfer of asset balance between holders adding specified comment.
505      * Resolves asset implementation contract for the caller and forwards there arguments along with
506      * the caller address.
507      *
508      * @param _from holder address to take from.
509      * @param _icap recipient ICAP address to give to.
510      * @param _value amount to transfer.
511      * @param _reference transfer comment to be included in a EToken2's Transfer event.
512      *
513      * @return success.
514      */
515     function transferFromToICAPWithReference(
516         address _from,
517         bytes32 _icap,
518         uint _value,
519         string memory _reference)
520     public returns(bool) {
521         return _getAsset()._performTransferFromToICAPWithReference(
522             _from,
523             _icap,
524             _value,
525             _reference,
526             msg.sender
527         );
528     }
529 
530     /**
531      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
532      *
533      * Can only be called by asset implementation contract assigned to sender.
534      *
535      * @param _from holder address to take from.
536      * @param _icap recipient ICAP address to give to.
537      * @param _value amount to transfer.
538      * @param _reference transfer comment to be included in a EToken2's Transfer event.
539      * @param _sender initial caller.
540      *
541      * @return success.
542      */
543     function _forwardTransferFromToICAPWithReference(
544         address _from,
545         bytes32 _icap,
546         uint _value,
547         string memory _reference,
548         address _sender)
549     public onlyImplementationFor(_sender) returns(bool) {
550         return etoken2.proxyTransferFromToICAPWithReference(
551             _from,
552             _icap,
553             _value,
554             _reference,
555             _sender
556         );
557     }
558 
559     /**
560      * Sets asset spending allowance for a specified spender.
561      * Resolves asset implementation contract for the caller and forwards there arguments along with
562      * the caller address.
563      *
564      * @param _spender holder address to set allowance to.
565      * @param _value amount to allow.
566      *
567      * @return success.
568      */
569     function approve(address _spender, uint _value) public returns(bool) {
570         return _getAsset()._performApprove(_spender, _value, msg.sender);
571     }
572 
573     /**
574      * Performs allowance setting call on the EToken2 by the name of specified sender.
575      *
576      * Can only be called by asset implementation contract assigned to sender.
577      *
578      * @param _spender holder address to set allowance to.
579      * @param _value amount to allow.
580      * @param _sender initial caller.
581      *
582      * @return success.
583      */
584     function _forwardApprove(address _spender, uint _value, address _sender)
585     public onlyImplementationFor(_sender) returns(bool) {
586         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
587     }
588 
589     /**
590      * Emits ERC20 Transfer event on this contract.
591      *
592      * Can only be, and, called by assigned EToken2 when asset transfer happens.
593      */
594     function emitTransfer(address _from, address _to, uint _value) public onlyEToken2() {
595         emit Transfer(_from, _to, _value);
596     }
597 
598     /**
599      * Emits ERC20 Approval event on this contract.
600      *
601      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
602      */
603     function emitApprove(address _from, address _spender, uint _value) public onlyEToken2() {
604         emit Approval(_from, _spender, _value);
605     }
606 
607     /**
608      * Resolves asset implementation contract for the caller and forwards there transaction data,
609      * along with the value. This allows for proxy interface growth.
610      */
611     function () external payable {
612         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
613         _returnReturnData(true);
614     }
615 
616     // Interface functions to allow specifying ICAP addresses as strings.
617     function transferToICAP(string memory _icap, uint _value) public returns(bool) {
618         return transferToICAPWithReference(_icap, _value, '');
619     }
620 
621     function transferToICAPWithReference(string memory _icap, uint _value, string memory _reference)
622     public returns(bool) {
623         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
624     }
625 
626     function transferFromToICAP(address _from, string memory _icap, uint _value)
627         public returns(bool)
628     {
629         return transferFromToICAPWithReference(_from, _icap, _value, '');
630     }
631 
632     function transferFromToICAPWithReference(
633         address _from,
634         string memory _icap,
635         uint _value,
636         string memory _reference)
637     public returns(bool) {
638         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
639     }
640 
641     /**
642      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
643      */
644     event UpgradeProposed(address newVersion);
645     event UpgradePurged(address newVersion);
646     event UpgradeCommited(address newVersion);
647     event OptedOut(address sender, address version);
648     event OptedIn(address sender, address version);
649 
650     // Current asset implementation contract address.
651     address internal latestVersion;
652 
653     // Proposed next asset implementation contract address.
654     address internal pendingVersion;
655 
656     // Upgrade freeze-time start.
657     uint internal pendingVersionTimestamp;
658 
659     // Timespan for users to review the new implementation and make decision.
660     uint internal constant UPGRADE_FREEZE_TIME = 3 days;
661 
662     // Asset implementation contract address that user decided to stick with.
663     // 0x0 means that user uses latest version.
664     mapping(address => address) internal userOptOutVersion;
665 
666     /**
667      * Only asset implementation contract assigned to sender is allowed to call.
668      */
669     modifier onlyImplementationFor(address _sender) {
670         if (getVersionFor(_sender) == msg.sender) {
671             _;
672         }
673     }
674 
675     /**
676      * Returns asset implementation contract address assigned to sender.
677      *
678      * @param _sender sender address.
679      *
680      * @return asset implementation contract address.
681      */
682     function getVersionFor(address _sender) public view returns(address) {
683         return userOptOutVersion[_sender] == address(0) ?
684             latestVersion : userOptOutVersion[_sender];
685     }
686 
687     /**
688      * Returns current asset implementation contract address.
689      *
690      * @return asset implementation contract address.
691      */
692     function getLatestVersion() public view returns(address) {
693         return latestVersion;
694     }
695 
696     /**
697      * Returns proposed next asset implementation contract address.
698      *
699      * @return asset implementation contract address.
700      */
701     function getPendingVersion() public view returns(address) {
702         return pendingVersion;
703     }
704 
705     /**
706      * Returns upgrade freeze-time start.
707      *
708      * @return freeze-time start.
709      */
710     function getPendingVersionTimestamp() public view returns(uint) {
711         return pendingVersionTimestamp;
712     }
713 
714     /**
715      * Propose next asset implementation contract address.
716      *
717      * Can only be called by current asset owner.
718      *
719      * Note: freeze-time should not be applied for the initial setup.
720      *
721      * @param _newVersion asset implementation contract address.
722      *
723      * @return success.
724      */
725     function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {
726         // Should not already be in the upgrading process.
727         if (pendingVersion != address(0)) {
728             return false;
729         }
730         // New version address should be other than 0x0.
731         if (_newVersion == address(0)) {
732             return false;
733         }
734         // Don't apply freeze-time for the initial setup.
735         if (latestVersion == address(0)) {
736             latestVersion = _newVersion;
737             return true;
738         }
739         pendingVersion = _newVersion;
740         // solhint-disable-next-line not-rely-on-time
741         pendingVersionTimestamp = now;
742         emit UpgradeProposed(_newVersion);
743         return true;
744     }
745 
746     /**
747      * Cancel the pending upgrade process.
748      *
749      * Can only be called by current asset owner.
750      *
751      * @return success.
752      */
753     function purgeUpgrade() public onlyAssetOwner() returns(bool) {
754         if (pendingVersion == address(0)) {
755             return false;
756         }
757         emit UpgradePurged(pendingVersion);
758         delete pendingVersion;
759         delete pendingVersionTimestamp;
760         return true;
761     }
762 
763     /**
764      * Finalize an upgrade process setting new asset implementation contract address.
765      *
766      * Can only be called after an upgrade freeze-time.
767      *
768      * @return success.
769      */
770     function commitUpgrade() public returns(bool) {
771         if (pendingVersion == address(0)) {
772             return false;
773         }
774         // solhint-disable-next-line not-rely-on-time
775         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
776             return false;
777         }
778         latestVersion = pendingVersion;
779         delete pendingVersion;
780         delete pendingVersionTimestamp;
781         emit UpgradeCommited(latestVersion);
782         return true;
783     }
784 
785     /**
786      * Disagree with proposed upgrade, and stick with current asset implementation
787      * until further explicit agreement to upgrade.
788      *
789      * @return success.
790      */
791     function optOut() public returns(bool) {
792         if (userOptOutVersion[msg.sender] != address(0)) {
793             return false;
794         }
795         userOptOutVersion[msg.sender] = latestVersion;
796         emit OptedOut(msg.sender, latestVersion);
797         return true;
798     }
799 
800     /**
801      * Implicitly agree to upgrade to current and future asset implementation upgrades,
802      * until further explicit disagreement.
803      *
804      * @return success.
805      */
806     function optIn() public returns(bool) {
807         delete userOptOutVersion[msg.sender];
808         emit OptedIn(msg.sender, latestVersion);
809         return true;
810     }
811 
812     // Backwards compatibility.
813     function multiAsset() public view returns(EToken2Interface) {
814         return etoken2;
815     }
816 }
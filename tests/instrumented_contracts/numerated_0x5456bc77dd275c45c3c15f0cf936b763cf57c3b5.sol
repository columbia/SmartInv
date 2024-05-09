1 
2 // File: contracts/EToken2Interface.sol
3 
4 pragma solidity 0.5.8;
5 
6 
7 contract RegistryICAPInterface {
8     function parse(bytes32 _icap) public view returns(address, bytes32, bool);
9     function institutions(bytes32 _institution) public view returns(address);
10 }
11 
12 
13 contract EToken2Interface {
14     function registryICAP() public view returns(RegistryICAPInterface);
15     function baseUnit(bytes32 _symbol) public view returns(uint8);
16     function description(bytes32 _symbol) public view returns(string memory);
17     function owner(bytes32 _symbol) public view returns(address);
18     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
19     function totalSupply(bytes32 _symbol) public view returns(uint);
20     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
21     function isLocked(bytes32 _symbol) public view returns(bool);
22 
23     function issueAsset(
24         bytes32 _symbol,
25         uint _value,
26         string memory _name,
27         string memory _description,
28         uint8 _baseUnit,
29         bool _isReissuable)
30     public returns(bool);
31 
32     function reissueAsset(bytes32 _symbol, uint _value) public returns(bool);
33     function revokeAsset(bytes32 _symbol, uint _value) public returns(bool);
34     function setProxy(address _address, bytes32 _symbol) public returns(bool);
35     function lockAsset(bytes32 _symbol) public returns(bool);
36 
37     function proxyTransferFromToICAPWithReference(
38         address _from,
39         bytes32 _icap,
40         uint _value,
41         string memory _reference,
42         address _sender)
43     public returns(bool);
44 
45     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender)
46     public returns(bool);
47     
48     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
49 
50     function proxyTransferFromWithReference(
51         address _from,
52         address _to,
53         uint _value,
54         bytes32 _symbol,
55         string memory _reference,
56         address _sender)
57     public returns(bool);
58 
59     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);
60 }
61 
62 // File: contracts/AssetInterface.sol
63 
64 pragma solidity 0.5.8;
65 
66 
67 contract AssetInterface {
68     function _performTransferWithReference(
69         address _to,
70         uint _value,
71         string memory _reference,
72         address _sender)
73     public returns(bool);
74 
75     function _performTransferToICAPWithReference(
76         bytes32 _icap,
77         uint _value,
78         string memory _reference,
79         address _sender)
80     public returns(bool);
81 
82     function _performApprove(address _spender, uint _value, address _sender)
83     public returns(bool);
84 
85     function _performTransferFromWithReference(
86         address _from,
87         address _to,
88         uint _value,
89         string memory _reference,
90         address _sender)
91     public returns(bool);
92 
93     function _performTransferFromToICAPWithReference(
94         address _from,
95         bytes32 _icap,
96         uint _value,
97         string memory _reference,
98         address _sender)
99     public returns(bool);
100 
101     function _performGeneric(bytes memory, address) public payable {
102         revert();
103     }
104 }
105 
106 // File: contracts/ERC20Interface.sol
107 
108 pragma solidity 0.5.8;
109 
110 
111 contract ERC20Interface {
112     event Transfer(address indexed from, address indexed to, uint256 value);
113     event Approval(address indexed from, address indexed spender, uint256 value);
114 
115     function totalSupply() public view returns(uint256 supply);
116     function balanceOf(address _owner) public view returns(uint256 balance);
117     // solhint-disable-next-line no-simple-event-func-name
118     function transfer(address _to, uint256 _value) public returns(bool success);
119     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
120     function approve(address _spender, uint256 _value) public returns(bool success);
121     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
122 
123     // function symbol() constant returns(string);
124     function decimals() public view returns(uint8);
125     // function name() constant returns(string);
126 }
127 
128 // File: contracts/AssetProxyInterface.sol
129 
130 pragma solidity 0.5.8;
131 
132 
133 
134 contract AssetProxyInterface is ERC20Interface {
135     function _forwardApprove(address _spender, uint _value, address _sender)
136     public returns(bool);
137 
138     function _forwardTransferFromWithReference(
139         address _from,
140         address _to,
141         uint _value,
142         string memory _reference,
143         address _sender)
144     public returns(bool);
145 
146     function _forwardTransferFromToICAPWithReference(
147         address _from,
148         bytes32 _icap,
149         uint _value,
150         string memory _reference,
151         address _sender)
152     public returns(bool);
153 
154     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
155     public returns(bool);
156 
157     function etoken2() external view returns(address); // To be replaced by the implicit getter;
158 
159     // To be replaced by the implicit getter;
160     function etoken2Symbol() external view returns(bytes32);
161 }
162 
163 // File: smart-contracts-common/contracts/Bytes32.sol
164 
165 pragma solidity 0.5.8;
166 
167 
168 contract Bytes32 {
169     function _bytes32(string memory _input) internal pure returns(bytes32 result) {
170         assembly {
171             result := mload(add(_input, 32))
172         }
173     }
174 }
175 
176 // File: smart-contracts-common/contracts/ReturnData.sol
177 
178 pragma solidity 0.5.8;
179 
180 
181 contract ReturnData {
182     function _returnReturnData(bool _success) internal pure {
183         assembly {
184             let returndatastart := 0
185             returndatacopy(returndatastart, 0, returndatasize)
186             switch _success case 0 { revert(returndatastart, returndatasize) }
187                 default { return(returndatastart, returndatasize) }
188         }
189     }
190 
191     function _assemblyCall(address _destination, uint _value, bytes memory _data)
192     internal returns(bool success) {
193         assembly {
194             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
195         }
196     }
197 }
198 
199 // File: contracts/AssetProxy.sol
200 
201 pragma solidity 0.5.8;
202 
203 
204 
205 
206 
207 
208 
209 
210 /**
211  * @title EToken2 Asset Proxy.
212  *
213  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
214  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
215  * Every request that is made by caller first sent to the specific asset implementation
216  * contract, which then calls back to be forwarded onto EToken2.
217  *
218  * Calls flow: Caller ->
219  *             Proxy.func(...) ->
220  *             Asset._performFunc(..., Caller.address) ->
221  *             Proxy._forwardFunc(..., Caller.address) ->
222  *             Platform.proxyFunc(..., symbol, Caller.address)
223  *
224  * Generic call flow: Caller ->
225  *             Proxy.unknownFunc(...) ->
226  *             Asset._performGeneric(..., Caller.address) ->
227  *             Asset.unknownFunc(...)
228  *
229  * Asset implementation contract is mutable, but each user have an option to stick with
230  * old implementation, through explicit decision made in timely manner, if he doesn't agree
231  * with new rules.
232  * Each user have a possibility to upgrade to latest asset contract implementation, without the
233  * possibility to rollback.
234  *
235  * Note: all the non constant functions return false instead of throwing in case if state change
236  * didn't happen yet.
237  */
238 contract Anchor is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
239     // Assigned EToken2, immutable.
240     EToken2Interface public etoken2;
241 
242     // Assigned symbol, immutable.
243     bytes32 public etoken2Symbol;
244 
245     // Assigned name, immutable. For UI.
246     string public name;
247     string public symbol;
248 
249     /**
250      * Sets EToken2 address, assigns symbol and name.
251      *
252      * Can be set only once.
253      *
254      * @param _etoken2 EToken2 contract address.
255      * @param _symbol assigned symbol.
256      * @param _name assigned name.
257      *
258      * @return success.
259      */
260     function init(EToken2Interface _etoken2, string memory _symbol, string memory _name)
261         public returns(bool)
262     {
263         if (address(etoken2) != address(0)) {
264             return false;
265         }
266         etoken2 = _etoken2;
267         etoken2Symbol = _bytes32(_symbol);
268         name = _name;
269         symbol = _symbol;
270         return true;
271     }
272 
273     /**
274      * Only EToken2 is allowed to call.
275      */
276     modifier onlyEToken2() {
277         if (msg.sender == address(etoken2)) {
278             _;
279         }
280     }
281 
282     /**
283      * Only current asset owner is allowed to call.
284      */
285     modifier onlyAssetOwner() {
286         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
287             _;
288         }
289     }
290 
291     /**
292      * Returns asset implementation contract for current caller.
293      *
294      * @return asset implementation contract.
295      */
296     function _getAsset() internal view returns(AssetInterface) {
297         return AssetInterface(getVersionFor(msg.sender));
298     }
299 
300     /**
301      * Recovers tokens on proxy contract
302      *
303      * @param _asset type of tokens to recover.
304      * @param _value tokens that will be recovered.
305      * @param _receiver address where to send recovered tokens.
306      *
307      * @return success.
308      */
309     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
310     public onlyAssetOwner() returns(bool) {
311         return _asset.transfer(_receiver, _value);
312     }
313 
314     /**
315      * Returns asset total supply.
316      *
317      * @return asset total supply.
318      */
319     function totalSupply() public view returns(uint) {
320         return etoken2.totalSupply(etoken2Symbol);
321     }
322 
323     /**
324      * Returns asset balance for a particular holder.
325      *
326      * @param _owner holder address.
327      *
328      * @return holder balance.
329      */
330     function balanceOf(address _owner) public view returns(uint) {
331         return etoken2.balanceOf(_owner, etoken2Symbol);
332     }
333 
334     /**
335      * Returns asset allowance from one holder to another.
336      *
337      * @param _from holder that allowed spending.
338      * @param _spender holder that is allowed to spend.
339      *
340      * @return holder to spender allowance.
341      */
342     function allowance(address _from, address _spender) public view returns(uint) {
343         return etoken2.allowance(_from, _spender, etoken2Symbol);
344     }
345 
346     /**
347      * Returns asset decimals.
348      *
349      * @return asset decimals.
350      */
351     function decimals() public view returns(uint8) {
352         return etoken2.baseUnit(etoken2Symbol);
353     }
354 
355     /**
356      * Transfers asset balance from the caller to specified receiver.
357      *
358      * @param _to holder address to give to.
359      * @param _value amount to transfer.
360      *
361      * @return success.
362      */
363     function transfer(address _to, uint _value) public returns(bool) {
364         return transferWithReference(_to, _value, '');
365     }
366 
367     /**
368      * Transfers asset balance from the caller to specified receiver adding specified comment.
369      * Resolves asset implementation contract for the caller and forwards there arguments along with
370      * the caller address.
371      *
372      * @param _to holder address to give to.
373      * @param _value amount to transfer.
374      * @param _reference transfer comment to be included in a EToken2's Transfer event.
375      *
376      * @return success.
377      */
378     function transferWithReference(address _to, uint _value, string memory _reference)
379     public returns(bool) {
380         return _getAsset()._performTransferWithReference(
381             _to, _value, _reference, msg.sender);
382     }
383 
384     /**
385      * Transfers asset balance from the caller to specified ICAP.
386      *
387      * @param _icap recipient ICAP to give to.
388      * @param _value amount to transfer.
389      *
390      * @return success.
391      */
392     function transferToICAP(bytes32 _icap, uint _value) public returns(bool) {
393         return transferToICAPWithReference(_icap, _value, '');
394     }
395 
396     /**
397      * Transfers asset balance from the caller to specified ICAP adding specified comment.
398      * Resolves asset implementation contract for the caller and forwards there arguments along with
399      * the caller address.
400      *
401      * @param _icap recipient ICAP to give to.
402      * @param _value amount to transfer.
403      * @param _reference transfer comment to be included in a EToken2's Transfer event.
404      *
405      * @return success.
406      */
407     function transferToICAPWithReference(
408         bytes32 _icap,
409         uint _value,
410         string memory _reference)
411     public returns(bool) {
412         return _getAsset()._performTransferToICAPWithReference(
413             _icap, _value, _reference, msg.sender);
414     }
415 
416     /**
417      * Prforms allowance transfer of asset balance between holders.
418      *
419      * @param _from holder address to take from.
420      * @param _to holder address to give to.
421      * @param _value amount to transfer.
422      *
423      * @return success.
424      */
425     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
426         return transferFromWithReference(_from, _to, _value, '');
427     }
428 
429     /**
430      * Prforms allowance transfer of asset balance between holders adding specified comment.
431      * Resolves asset implementation contract for the caller and forwards there arguments along with
432      * the caller address.
433      *
434      * @param _from holder address to take from.
435      * @param _to holder address to give to.
436      * @param _value amount to transfer.
437      * @param _reference transfer comment to be included in a EToken2's Transfer event.
438      *
439      * @return success.
440      */
441     function transferFromWithReference(
442         address _from,
443         address _to,
444         uint _value,
445         string memory _reference)
446     public returns(bool) {
447         return _getAsset()._performTransferFromWithReference(
448             _from,
449             _to,
450             _value,
451             _reference,
452             msg.sender
453         );
454     }
455 
456     /**
457      * Performs transfer call on the EToken2 by the name of specified sender.
458      *
459      * Can only be called by asset implementation contract assigned to sender.
460      *
461      * @param _from holder address to take from.
462      * @param _to holder address to give to.
463      * @param _value amount to transfer.
464      * @param _reference transfer comment to be included in a EToken2's Transfer event.
465      * @param _sender initial caller.
466      *
467      * @return success.
468      */
469     function _forwardTransferFromWithReference(
470         address _from,
471         address _to,
472         uint _value,
473         string memory _reference,
474         address _sender)
475     public onlyImplementationFor(_sender) returns(bool) {
476         return etoken2.proxyTransferFromWithReference(
477             _from,
478             _to,
479             _value,
480             etoken2Symbol,
481             _reference,
482             _sender
483         );
484     }
485 
486     /**
487      * Prforms allowance transfer of asset balance between holders.
488      *
489      * @param _from holder address to take from.
490      * @param _icap recipient ICAP address to give to.
491      * @param _value amount to transfer.
492      *
493      * @return success.
494      */
495     function transferFromToICAP(address _from, bytes32 _icap, uint _value)
496     public returns(bool) {
497         return transferFromToICAPWithReference(_from, _icap, _value, '');
498     }
499 
500     /**
501      * Prforms allowance transfer of asset balance between holders adding specified comment.
502      * Resolves asset implementation contract for the caller and forwards there arguments along with
503      * the caller address.
504      *
505      * @param _from holder address to take from.
506      * @param _icap recipient ICAP address to give to.
507      * @param _value amount to transfer.
508      * @param _reference transfer comment to be included in a EToken2's Transfer event.
509      *
510      * @return success.
511      */
512     function transferFromToICAPWithReference(
513         address _from,
514         bytes32 _icap,
515         uint _value,
516         string memory _reference)
517     public returns(bool) {
518         return _getAsset()._performTransferFromToICAPWithReference(
519             _from,
520             _icap,
521             _value,
522             _reference,
523             msg.sender
524         );
525     }
526 
527     /**
528      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
529      *
530      * Can only be called by asset implementation contract assigned to sender.
531      *
532      * @param _from holder address to take from.
533      * @param _icap recipient ICAP address to give to.
534      * @param _value amount to transfer.
535      * @param _reference transfer comment to be included in a EToken2's Transfer event.
536      * @param _sender initial caller.
537      *
538      * @return success.
539      */
540     function _forwardTransferFromToICAPWithReference(
541         address _from,
542         bytes32 _icap,
543         uint _value,
544         string memory _reference,
545         address _sender)
546     public onlyImplementationFor(_sender) returns(bool) {
547         return etoken2.proxyTransferFromToICAPWithReference(
548             _from,
549             _icap,
550             _value,
551             _reference,
552             _sender
553         );
554     }
555 
556     /**
557      * Sets asset spending allowance for a specified spender.
558      * Resolves asset implementation contract for the caller and forwards there arguments along with
559      * the caller address.
560      *
561      * @param _spender holder address to set allowance to.
562      * @param _value amount to allow.
563      *
564      * @return success.
565      */
566     function approve(address _spender, uint _value) public returns(bool) {
567         return _getAsset()._performApprove(_spender, _value, msg.sender);
568     }
569 
570     /**
571      * Performs allowance setting call on the EToken2 by the name of specified sender.
572      *
573      * Can only be called by asset implementation contract assigned to sender.
574      *
575      * @param _spender holder address to set allowance to.
576      * @param _value amount to allow.
577      * @param _sender initial caller.
578      *
579      * @return success.
580      */
581     function _forwardApprove(address _spender, uint _value, address _sender)
582     public onlyImplementationFor(_sender) returns(bool) {
583         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
584     }
585 
586     /**
587      * Emits ERC20 Transfer event on this contract.
588      *
589      * Can only be, and, called by assigned EToken2 when asset transfer happens.
590      */
591     function emitTransfer(address _from, address _to, uint _value) public onlyEToken2() {
592         emit Transfer(_from, _to, _value);
593     }
594 
595     /**
596      * Emits ERC20 Approval event on this contract.
597      *
598      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
599      */
600     function emitApprove(address _from, address _spender, uint _value) public onlyEToken2() {
601         emit Approval(_from, _spender, _value);
602     }
603 
604     /**
605      * Resolves asset implementation contract for the caller and forwards there transaction data,
606      * along with the value. This allows for proxy interface growth.
607      */
608     function () external payable {
609         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
610         _returnReturnData(true);
611     }
612 
613     // Interface functions to allow specifying ICAP addresses as strings.
614     function transferToICAP(string memory _icap, uint _value) public returns(bool) {
615         return transferToICAPWithReference(_icap, _value, '');
616     }
617 
618     function transferToICAPWithReference(string memory _icap, uint _value, string memory _reference)
619     public returns(bool) {
620         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
621     }
622 
623     function transferFromToICAP(address _from, string memory _icap, uint _value)
624         public returns(bool)
625     {
626         return transferFromToICAPWithReference(_from, _icap, _value, '');
627     }
628 
629     function transferFromToICAPWithReference(
630         address _from,
631         string memory _icap,
632         uint _value,
633         string memory _reference)
634     public returns(bool) {
635         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
636     }
637 
638     /**
639      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
640      */
641     event UpgradeProposed(address newVersion);
642     event UpgradePurged(address newVersion);
643     event UpgradeCommited(address newVersion);
644     event OptedOut(address sender, address version);
645     event OptedIn(address sender, address version);
646 
647     // Current asset implementation contract address.
648     address internal latestVersion;
649 
650     // Proposed next asset implementation contract address.
651     address internal pendingVersion;
652 
653     // Upgrade freeze-time start.
654     uint internal pendingVersionTimestamp;
655 
656     // Timespan for users to review the new implementation and make decision.
657     uint internal constant UPGRADE_FREEZE_TIME = 3 days;
658 
659     // Asset implementation contract address that user decided to stick with.
660     // 0x0 means that user uses latest version.
661     mapping(address => address) internal userOptOutVersion;
662 
663     /**
664      * Only asset implementation contract assigned to sender is allowed to call.
665      */
666     modifier onlyImplementationFor(address _sender) {
667         if (getVersionFor(_sender) == msg.sender) {
668             _;
669         }
670     }
671 
672     /**
673      * Returns asset implementation contract address assigned to sender.
674      *
675      * @param _sender sender address.
676      *
677      * @return asset implementation contract address.
678      */
679     function getVersionFor(address _sender) public view returns(address) {
680         return userOptOutVersion[_sender] == address(0) ?
681             latestVersion : userOptOutVersion[_sender];
682     }
683 
684     /**
685      * Returns current asset implementation contract address.
686      *
687      * @return asset implementation contract address.
688      */
689     function getLatestVersion() public view returns(address) {
690         return latestVersion;
691     }
692 
693     /**
694      * Returns proposed next asset implementation contract address.
695      *
696      * @return asset implementation contract address.
697      */
698     function getPendingVersion() public view returns(address) {
699         return pendingVersion;
700     }
701 
702     /**
703      * Returns upgrade freeze-time start.
704      *
705      * @return freeze-time start.
706      */
707     function getPendingVersionTimestamp() public view returns(uint) {
708         return pendingVersionTimestamp;
709     }
710 
711     /**
712      * Propose next asset implementation contract address.
713      *
714      * Can only be called by current asset owner.
715      *
716      * Note: freeze-time should not be applied for the initial setup.
717      *
718      * @param _newVersion asset implementation contract address.
719      *
720      * @return success.
721      */
722     function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {
723         // Should not already be in the upgrading process.
724         if (pendingVersion != address(0)) {
725             return false;
726         }
727         // New version address should be other than 0x0.
728         if (_newVersion == address(0)) {
729             return false;
730         }
731         // Don't apply freeze-time for the initial setup.
732         if (latestVersion == address(0)) {
733             latestVersion = _newVersion;
734             return true;
735         }
736         pendingVersion = _newVersion;
737         // solhint-disable-next-line not-rely-on-time
738         pendingVersionTimestamp = now;
739         emit UpgradeProposed(_newVersion);
740         return true;
741     }
742 
743     /**
744      * Cancel the pending upgrade process.
745      *
746      * Can only be called by current asset owner.
747      *
748      * @return success.
749      */
750     function purgeUpgrade() public onlyAssetOwner() returns(bool) {
751         if (pendingVersion == address(0)) {
752             return false;
753         }
754         emit UpgradePurged(pendingVersion);
755         delete pendingVersion;
756         delete pendingVersionTimestamp;
757         return true;
758     }
759 
760     /**
761      * Finalize an upgrade process setting new asset implementation contract address.
762      *
763      * Can only be called after an upgrade freeze-time.
764      *
765      * @return success.
766      */
767     function commitUpgrade() public returns(bool) {
768         if (pendingVersion == address(0)) {
769             return false;
770         }
771         // solhint-disable-next-line not-rely-on-time
772         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
773             return false;
774         }
775         latestVersion = pendingVersion;
776         delete pendingVersion;
777         delete pendingVersionTimestamp;
778         emit UpgradeCommited(latestVersion);
779         return true;
780     }
781 
782     /**
783      * Disagree with proposed upgrade, and stick with current asset implementation
784      * until further explicit agreement to upgrade.
785      *
786      * @return success.
787      */
788     function optOut() public returns(bool) {
789         if (userOptOutVersion[msg.sender] != address(0)) {
790             return false;
791         }
792         userOptOutVersion[msg.sender] = latestVersion;
793         emit OptedOut(msg.sender, latestVersion);
794         return true;
795     }
796 
797     /**
798      * Implicitly agree to upgrade to current and future asset implementation upgrades,
799      * until further explicit disagreement.
800      *
801      * @return success.
802      */
803     function optIn() public returns(bool) {
804         delete userOptOutVersion[msg.sender];
805         emit OptedIn(msg.sender, latestVersion);
806         return true;
807     }
808 
809     // Backwards compatibility.
810     function multiAsset() public view returns(EToken2Interface) {
811         return etoken2;
812     }
813 }

1 
2 // File: contracts/EToken2Interface.sol
3 
4 pragma solidity 0.4.23;
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
16     function description(bytes32 _symbol) public view returns(string);
17     function owner(bytes32 _symbol) public view returns(address);
18     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
19     function totalSupply(bytes32 _symbol) public view returns(uint);
20     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
21     function isLocked(bytes32 _symbol) public view returns(bool);
22 
23     function issueAsset(
24         bytes32 _symbol,
25         uint _value,
26         string _name,
27         string _description,
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
41         string _reference,
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
55         string _reference,
56         address _sender)
57     public returns(bool);
58 
59     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);
60 }
61 
62 // File: contracts/AssetInterface.sol
63 
64 pragma solidity 0.4.23;
65 
66 
67 contract AssetInterface {
68     function _performTransferWithReference(
69         address _to,
70         uint _value,
71         string _reference,
72         address _sender)
73     public returns(bool);
74 
75     function _performTransferToICAPWithReference(
76         bytes32 _icap,
77         uint _value,
78         string _reference,
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
89         string _reference,
90         address _sender)
91     public returns(bool);
92 
93     function _performTransferFromToICAPWithReference(
94         address _from,
95         bytes32 _icap,
96         uint _value,
97         string _reference,
98         address _sender)
99     public returns(bool);
100 
101     function _performGeneric(bytes, address) public payable {
102         revert();
103     }
104 }
105 
106 // File: contracts/ERC20Interface.sol
107 
108 pragma solidity 0.4.23;
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
130 pragma solidity 0.4.23;
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
142         string _reference,
143         address _sender)
144     public returns(bool);
145 
146     function _forwardTransferFromToICAPWithReference(
147         address _from,
148         bytes32 _icap,
149         uint _value,
150         string _reference,
151         address _sender)
152     public returns(bool);
153 
154     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
155     public returns(bool);
156 
157     // solhint-disable-next-line no-empty-blocks
158     function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
159 
160     // To be replaced by the implicit getter;
161     // solhint-disable-next-line no-empty-blocks
162     function etoken2Symbol() public pure returns(bytes32) {}
163 }
164 
165 // File: contracts/helpers/Bytes32.sol
166 
167 pragma solidity 0.4.23;
168 
169 
170 contract Bytes32 {
171     function _bytes32(string _input) internal pure returns(bytes32 result) {
172         assembly {
173             result := mload(add(_input, 32))
174         }
175     }
176 }
177 
178 // File: contracts/helpers/ReturnData.sol
179 
180 pragma solidity 0.4.23;
181 
182 
183 contract ReturnData {
184     function _returnReturnData(bool _success) internal pure {
185         assembly {
186             let returndatastart := 0
187             returndatacopy(returndatastart, 0, returndatasize)
188             switch _success case 0 { revert(returndatastart, returndatasize) }
189                 default { return(returndatastart, returndatasize) }
190         }
191     }
192 
193     function _assemblyCall(address _destination, uint _value, bytes _data)
194     internal returns(bool success) {
195         assembly {
196             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
197         }
198     }
199 }
200 
201 // File: contracts/AssetProxy.sol
202 
203 pragma solidity 0.4.23;
204 
205 
206 
207 
208 
209 
210 
211 
212 /**
213  * @title EToken2 Asset Proxy.
214  *
215  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
216  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
217  * Every request that is made by caller first sent to the specific asset implementation
218  * contract, which then calls back to be forwarded onto EToken2.
219  *
220  * Calls flow: Caller ->
221  *             Proxy.func(...) ->
222  *             Asset._performFunc(..., Caller.address) ->
223  *             Proxy._forwardFunc(..., Caller.address) ->
224  *             Platform.proxyFunc(..., symbol, Caller.address)
225  *
226  * Generic call flow: Caller ->
227  *             Proxy.unknownFunc(...) ->
228  *             Asset._performGeneric(..., Caller.address) ->
229  *             Asset.unknownFunc(...)
230  *
231  * Asset implementation contract is mutable, but each user have an option to stick with
232  * old implementation, through explicit decision made in timely manner, if he doesn't agree
233  * with new rules.
234  * Each user have a possibility to upgrade to latest asset contract implementation, without the
235  * possibility to rollback.
236  *
237  * Note: all the non constant functions return false instead of throwing in case if state change
238  * didn't happen yet.
239  */
240 contract AssetProxy is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
241     // Assigned EToken2, immutable.
242     EToken2Interface public etoken2;
243 
244     // Assigned symbol, immutable.
245     bytes32 public etoken2Symbol;
246 
247     // Assigned name, immutable. For UI.
248     string public name;
249     string public symbol;
250 
251     /**
252      * Sets EToken2 address, assigns symbol and name.
253      *
254      * Can be set only once.
255      *
256      * @param _etoken2 EToken2 contract address.
257      * @param _symbol assigned symbol.
258      * @param _name assigned name.
259      *
260      * @return success.
261      */
262     function init(EToken2Interface _etoken2, string _symbol, string _name) public returns(bool) {
263         if (address(etoken2) != 0x0) {
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
378     function transferWithReference(address _to, uint _value, string _reference)
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
410         string _reference)
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
445         string _reference)
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
473         string _reference,
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
516         string _reference)
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
544         string _reference,
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
608     function () public payable {
609         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
610         _returnReturnData(true);
611     }
612 
613     // Interface functions to allow specifying ICAP addresses as strings.
614     function transferToICAP(string _icap, uint _value) public returns(bool) {
615         return transferToICAPWithReference(_icap, _value, '');
616     }
617 
618     function transferToICAPWithReference(string _icap, uint _value, string _reference)
619     public returns(bool) {
620         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
621     }
622 
623     function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {
624         return transferFromToICAPWithReference(_from, _icap, _value, '');
625     }
626 
627     function transferFromToICAPWithReference(
628         address _from,
629         string _icap,
630         uint _value,
631         string _reference)
632     public returns(bool) {
633         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
634     }
635 
636     /**
637      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
638      */
639     event UpgradeProposed(address newVersion);
640     event UpgradePurged(address newVersion);
641     event UpgradeCommited(address newVersion);
642     event OptedOut(address sender, address version);
643     event OptedIn(address sender, address version);
644 
645     // Current asset implementation contract address.
646     address internal latestVersion;
647 
648     // Proposed next asset implementation contract address.
649     address internal pendingVersion;
650 
651     // Upgrade freeze-time start.
652     uint internal pendingVersionTimestamp;
653 
654     // Timespan for users to review the new implementation and make decision.
655     uint internal constant UPGRADE_FREEZE_TIME = 3 days;
656 
657     // Asset implementation contract address that user decided to stick with.
658     // 0x0 means that user uses latest version.
659     mapping(address => address) internal userOptOutVersion;
660 
661     /**
662      * Only asset implementation contract assigned to sender is allowed to call.
663      */
664     modifier onlyImplementationFor(address _sender) {
665         if (getVersionFor(_sender) == msg.sender) {
666             _;
667         }
668     }
669 
670     /**
671      * Returns asset implementation contract address assigned to sender.
672      *
673      * @param _sender sender address.
674      *
675      * @return asset implementation contract address.
676      */
677     function getVersionFor(address _sender) public view returns(address) {
678         return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];
679     }
680 
681     /**
682      * Returns current asset implementation contract address.
683      *
684      * @return asset implementation contract address.
685      */
686     function getLatestVersion() public view returns(address) {
687         return latestVersion;
688     }
689 
690     /**
691      * Returns proposed next asset implementation contract address.
692      *
693      * @return asset implementation contract address.
694      */
695     function getPendingVersion() public view returns(address) {
696         return pendingVersion;
697     }
698 
699     /**
700      * Returns upgrade freeze-time start.
701      *
702      * @return freeze-time start.
703      */
704     function getPendingVersionTimestamp() public view returns(uint) {
705         return pendingVersionTimestamp;
706     }
707 
708     /**
709      * Propose next asset implementation contract address.
710      *
711      * Can only be called by current asset owner.
712      *
713      * Note: freeze-time should not be applied for the initial setup.
714      *
715      * @param _newVersion asset implementation contract address.
716      *
717      * @return success.
718      */
719     function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {
720         // Should not already be in the upgrading process.
721         if (pendingVersion != 0x0) {
722             return false;
723         }
724         // New version address should be other than 0x0.
725         if (_newVersion == 0x0) {
726             return false;
727         }
728         // Don't apply freeze-time for the initial setup.
729         if (latestVersion == 0x0) {
730             latestVersion = _newVersion;
731             return true;
732         }
733         pendingVersion = _newVersion;
734         // solhint-disable-next-line not-rely-on-time
735         pendingVersionTimestamp = now;
736         emit UpgradeProposed(_newVersion);
737         return true;
738     }
739 
740     /**
741      * Cancel the pending upgrade process.
742      *
743      * Can only be called by current asset owner.
744      *
745      * @return success.
746      */
747     function purgeUpgrade() public onlyAssetOwner() returns(bool) {
748         if (pendingVersion == 0x0) {
749             return false;
750         }
751         emit UpgradePurged(pendingVersion);
752         delete pendingVersion;
753         delete pendingVersionTimestamp;
754         return true;
755     }
756 
757     /**
758      * Finalize an upgrade process setting new asset implementation contract address.
759      *
760      * Can only be called after an upgrade freeze-time.
761      *
762      * @return success.
763      */
764     function commitUpgrade() public returns(bool) {
765         if (pendingVersion == 0x0) {
766             return false;
767         }
768         // solhint-disable-next-line not-rely-on-time
769         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
770             return false;
771         }
772         latestVersion = pendingVersion;
773         delete pendingVersion;
774         delete pendingVersionTimestamp;
775         emit UpgradeCommited(latestVersion);
776         return true;
777     }
778 
779     /**
780      * Disagree with proposed upgrade, and stick with current asset implementation
781      * until further explicit agreement to upgrade.
782      *
783      * @return success.
784      */
785     function optOut() public returns(bool) {
786         if (userOptOutVersion[msg.sender] != 0x0) {
787             return false;
788         }
789         userOptOutVersion[msg.sender] = latestVersion;
790         emit OptedOut(msg.sender, latestVersion);
791         return true;
792     }
793 
794     /**
795      * Implicitly agree to upgrade to current and future asset implementation upgrades,
796      * until further explicit disagreement.
797      *
798      * @return success.
799      */
800     function optIn() public returns(bool) {
801         delete userOptOutVersion[msg.sender];
802         emit OptedIn(msg.sender, latestVersion);
803         return true;
804     }
805 
806     // Backwards compatibility.
807     function multiAsset() public view returns(EToken2Interface) {
808         return etoken2;
809     }
810 }
811 
812 // File: contracts/AssetProxyWithLock.sol
813 
814 pragma solidity 0.4.23;
815 
816 
817 
818 contract VOLUM is AssetProxy {
819     function change(string _symbol, string _name) public onlyAssetOwner() returns(bool) {
820         if (etoken2.isLocked(etoken2Symbol)) {
821             return false;
822         }
823         name = _name;
824         symbol = _symbol;
825         return true;
826     }
827 }

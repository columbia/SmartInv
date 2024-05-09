1 // File: contracts/EToken2Interface.sol
2 
3 pragma solidity 0.5.8;
4 
5 
6 contract RegistryICAPInterface {
7     function parse(bytes32 _icap) public view returns(address, bytes32, bool);
8     function institutions(bytes32 _institution) public view returns(address);
9 }
10 
11 
12 contract EToken2Interface {
13     function registryICAP() public view returns(RegistryICAPInterface);
14     function baseUnit(bytes32 _symbol) public view returns(uint8);
15     function description(bytes32 _symbol) public view returns(string memory);
16     function owner(bytes32 _symbol) public view returns(address);
17     function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
18     function totalSupply(bytes32 _symbol) public view returns(uint);
19     function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
20     function isLocked(bytes32 _symbol) public view returns(bool);
21 
22     function issueAsset(
23         bytes32 _symbol,
24         uint _value,
25         string memory _name,
26         string memory _description,
27         uint8 _baseUnit,
28         bool _isReissuable)
29     public returns(bool);
30 
31     function reissueAsset(bytes32 _symbol, uint _value) public returns(bool);
32     function revokeAsset(bytes32 _symbol, uint _value) public returns(bool);
33     function setProxy(address _address, bytes32 _symbol) public returns(bool);
34     function lockAsset(bytes32 _symbol) public returns(bool);
35 
36     function proxyTransferFromToICAPWithReference(
37         address _from,
38         bytes32 _icap,
39         uint _value,
40         string memory _reference,
41         address _sender)
42     public returns(bool);
43 
44     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender)
45     public returns(bool);
46     
47     function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
48 
49     function proxyTransferFromWithReference(
50         address _from,
51         address _to,
52         uint _value,
53         bytes32 _symbol,
54         string memory _reference,
55         address _sender)
56     public returns(bool);
57 
58     function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);
59 }
60 
61 // File: contracts/AssetInterface.sol
62 
63 pragma solidity 0.5.8;
64 
65 
66 contract AssetInterface {
67     function _performTransferWithReference(
68         address _to,
69         uint _value,
70         string memory _reference,
71         address _sender)
72     public returns(bool);
73 
74     function _performTransferToICAPWithReference(
75         bytes32 _icap,
76         uint _value,
77         string memory _reference,
78         address _sender)
79     public returns(bool);
80 
81     function _performApprove(address _spender, uint _value, address _sender)
82     public returns(bool);
83 
84     function _performTransferFromWithReference(
85         address _from,
86         address _to,
87         uint _value,
88         string memory _reference,
89         address _sender)
90     public returns(bool);
91 
92     function _performTransferFromToICAPWithReference(
93         address _from,
94         bytes32 _icap,
95         uint _value,
96         string memory _reference,
97         address _sender)
98     public returns(bool);
99 
100     function _performGeneric(bytes memory, address) public payable {
101         revert();
102     }
103 }
104 
105 // File: contracts/ERC20Interface.sol
106 
107 pragma solidity 0.5.8;
108 
109 
110 contract ERC20Interface {
111     event Transfer(address indexed from, address indexed to, uint256 value);
112     event Approval(address indexed from, address indexed spender, uint256 value);
113 
114     function totalSupply() public view returns(uint256 supply);
115     function balanceOf(address _owner) public view returns(uint256 balance);
116     // solhint-disable-next-line no-simple-event-func-name
117     function transfer(address _to, uint256 _value) public returns(bool success);
118     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
119     function approve(address _spender, uint256 _value) public returns(bool success);
120     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
121 
122     // function symbol() constant returns(string);
123     function decimals() public view returns(uint8);
124     // function name() constant returns(string);
125 }
126 
127 // File: contracts/AssetProxyInterface.sol
128 
129 pragma solidity 0.5.8;
130 
131 
132 
133 contract AssetProxyInterface is ERC20Interface {
134     function _forwardApprove(address _spender, uint _value, address _sender)
135     public returns(bool);
136 
137     function _forwardTransferFromWithReference(
138         address _from,
139         address _to,
140         uint _value,
141         string memory _reference,
142         address _sender)
143     public returns(bool);
144 
145     function _forwardTransferFromToICAPWithReference(
146         address _from,
147         bytes32 _icap,
148         uint _value,
149         string memory _reference,
150         address _sender)
151     public returns(bool);
152 
153     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
154     public returns(bool);
155 
156     function etoken2() external view returns(address); // To be replaced by the implicit getter;
157 
158     // To be replaced by the implicit getter;
159     function etoken2Symbol() external view returns(bytes32);
160 }
161 
162 // File: smart-contracts-common/contracts/Bytes32.sol
163 
164 pragma solidity 0.5.8;
165 
166 
167 contract Bytes32 {
168     function _bytes32(string memory _input) internal pure returns(bytes32 result) {
169         assembly {
170             result := mload(add(_input, 32))
171         }
172     }
173 }
174 
175 // File: smart-contracts-common/contracts/ReturnData.sol
176 
177 pragma solidity 0.5.8;
178 
179 
180 contract ReturnData {
181     function _returnReturnData(bool _success) internal pure {
182         assembly {
183             let returndatastart := 0
184             returndatacopy(returndatastart, 0, returndatasize)
185             switch _success case 0 { revert(returndatastart, returndatasize) }
186                 default { return(returndatastart, returndatasize) }
187         }
188     }
189 
190     function _assemblyCall(address _destination, uint _value, bytes memory _data)
191     internal returns(bool success) {
192         assembly {
193             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
194         }
195     }
196 }
197 
198 // File: contracts/AssetProxy.sol
199 
200 pragma solidity 0.5.8;
201 
202 
203 
204 
205 
206 
207 
208 
209 /**
210  * @title EToken2 Asset Proxy.
211  *
212  * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.
213  * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.
214  * Every request that is made by caller first sent to the specific asset implementation
215  * contract, which then calls back to be forwarded onto EToken2.
216  *
217  * Calls flow: Caller ->
218  *             Proxy.func(...) ->
219  *             Asset._performFunc(..., Caller.address) ->
220  *             Proxy._forwardFunc(..., Caller.address) ->
221  *             Platform.proxyFunc(..., symbol, Caller.address)
222  *
223  * Generic call flow: Caller ->
224  *             Proxy.unknownFunc(...) ->
225  *             Asset._performGeneric(..., Caller.address) ->
226  *             Asset.unknownFunc(...)
227  *
228  * Asset implementation contract is mutable, but each user have an option to stick with
229  * old implementation, through explicit decision made in timely manner, if he doesn't agree
230  * with new rules.
231  * Each user have a possibility to upgrade to latest asset contract implementation, without the
232  * possibility to rollback.
233  *
234  * Note: all the non constant functions return false instead of throwing in case if state change
235  * didn't happen yet.
236  */
237 contract AssetProxy is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {
238     // Assigned EToken2, immutable.
239     EToken2Interface public etoken2;
240 
241     // Assigned symbol, immutable.
242     bytes32 public etoken2Symbol;
243 
244     // Assigned name, immutable. For UI.
245     string public name;
246     string public symbol;
247 
248     /**
249      * Sets EToken2 address, assigns symbol and name.
250      *
251      * Can be set only once.
252      *
253      * @param _etoken2 EToken2 contract address.
254      * @param _symbol assigned symbol.
255      * @param _name assigned name.
256      *
257      * @return success.
258      */
259     function init(EToken2Interface _etoken2, string memory _symbol, string memory _name)
260         public returns(bool)
261     {
262         if (address(etoken2) != address(0)) {
263             return false;
264         }
265         etoken2 = _etoken2;
266         etoken2Symbol = _bytes32(_symbol);
267         name = _name;
268         symbol = _symbol;
269         return true;
270     }
271 
272     /**
273      * Only EToken2 is allowed to call.
274      */
275     modifier onlyEToken2() {
276         if (msg.sender == address(etoken2)) {
277             _;
278         }
279     }
280 
281     /**
282      * Only current asset owner is allowed to call.
283      */
284     modifier onlyAssetOwner() {
285         if (etoken2.isOwner(msg.sender, etoken2Symbol)) {
286             _;
287         }
288     }
289 
290     /**
291      * Returns asset implementation contract for current caller.
292      *
293      * @return asset implementation contract.
294      */
295     function _getAsset() internal view returns(AssetInterface) {
296         return AssetInterface(getVersionFor(msg.sender));
297     }
298 
299     /**
300      * Recovers tokens on proxy contract
301      *
302      * @param _asset type of tokens to recover.
303      * @param _value tokens that will be recovered.
304      * @param _receiver address where to send recovered tokens.
305      *
306      * @return success.
307      */
308     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
309     public onlyAssetOwner() returns(bool) {
310         return _asset.transfer(_receiver, _value);
311     }
312 
313     /**
314      * Returns asset total supply.
315      *
316      * @return asset total supply.
317      */
318     function totalSupply() public view returns(uint) {
319         return etoken2.totalSupply(etoken2Symbol);
320     }
321 
322     /**
323      * Returns asset balance for a particular holder.
324      *
325      * @param _owner holder address.
326      *
327      * @return holder balance.
328      */
329     function balanceOf(address _owner) public view returns(uint) {
330         return etoken2.balanceOf(_owner, etoken2Symbol);
331     }
332 
333     /**
334      * Returns asset allowance from one holder to another.
335      *
336      * @param _from holder that allowed spending.
337      * @param _spender holder that is allowed to spend.
338      *
339      * @return holder to spender allowance.
340      */
341     function allowance(address _from, address _spender) public view returns(uint) {
342         return etoken2.allowance(_from, _spender, etoken2Symbol);
343     }
344 
345     /**
346      * Returns asset decimals.
347      *
348      * @return asset decimals.
349      */
350     function decimals() public view returns(uint8) {
351         return etoken2.baseUnit(etoken2Symbol);
352     }
353 
354     /**
355      * Transfers asset balance from the caller to specified receiver.
356      *
357      * @param _to holder address to give to.
358      * @param _value amount to transfer.
359      *
360      * @return success.
361      */
362     function transfer(address _to, uint _value) public returns(bool) {
363         return transferWithReference(_to, _value, '');
364     }
365 
366     /**
367      * Transfers asset balance from the caller to specified receiver adding specified comment.
368      * Resolves asset implementation contract for the caller and forwards there arguments along with
369      * the caller address.
370      *
371      * @param _to holder address to give to.
372      * @param _value amount to transfer.
373      * @param _reference transfer comment to be included in a EToken2's Transfer event.
374      *
375      * @return success.
376      */
377     function transferWithReference(address _to, uint _value, string memory _reference)
378     public returns(bool) {
379         return _getAsset()._performTransferWithReference(
380             _to, _value, _reference, msg.sender);
381     }
382 
383     /**
384      * Transfers asset balance from the caller to specified ICAP.
385      *
386      * @param _icap recipient ICAP to give to.
387      * @param _value amount to transfer.
388      *
389      * @return success.
390      */
391     function transferToICAP(bytes32 _icap, uint _value) public returns(bool) {
392         return transferToICAPWithReference(_icap, _value, '');
393     }
394 
395     /**
396      * Transfers asset balance from the caller to specified ICAP adding specified comment.
397      * Resolves asset implementation contract for the caller and forwards there arguments along with
398      * the caller address.
399      *
400      * @param _icap recipient ICAP to give to.
401      * @param _value amount to transfer.
402      * @param _reference transfer comment to be included in a EToken2's Transfer event.
403      *
404      * @return success.
405      */
406     function transferToICAPWithReference(
407         bytes32 _icap,
408         uint _value,
409         string memory _reference)
410     public returns(bool) {
411         return _getAsset()._performTransferToICAPWithReference(
412             _icap, _value, _reference, msg.sender);
413     }
414 
415     /**
416      * Prforms allowance transfer of asset balance between holders.
417      *
418      * @param _from holder address to take from.
419      * @param _to holder address to give to.
420      * @param _value amount to transfer.
421      *
422      * @return success.
423      */
424     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
425         return transferFromWithReference(_from, _to, _value, '');
426     }
427 
428     /**
429      * Prforms allowance transfer of asset balance between holders adding specified comment.
430      * Resolves asset implementation contract for the caller and forwards there arguments along with
431      * the caller address.
432      *
433      * @param _from holder address to take from.
434      * @param _to holder address to give to.
435      * @param _value amount to transfer.
436      * @param _reference transfer comment to be included in a EToken2's Transfer event.
437      *
438      * @return success.
439      */
440     function transferFromWithReference(
441         address _from,
442         address _to,
443         uint _value,
444         string memory _reference)
445     public returns(bool) {
446         return _getAsset()._performTransferFromWithReference(
447             _from,
448             _to,
449             _value,
450             _reference,
451             msg.sender
452         );
453     }
454 
455     /**
456      * Performs transfer call on the EToken2 by the name of specified sender.
457      *
458      * Can only be called by asset implementation contract assigned to sender.
459      *
460      * @param _from holder address to take from.
461      * @param _to holder address to give to.
462      * @param _value amount to transfer.
463      * @param _reference transfer comment to be included in a EToken2's Transfer event.
464      * @param _sender initial caller.
465      *
466      * @return success.
467      */
468     function _forwardTransferFromWithReference(
469         address _from,
470         address _to,
471         uint _value,
472         string memory _reference,
473         address _sender)
474     public onlyImplementationFor(_sender) returns(bool) {
475         return etoken2.proxyTransferFromWithReference(
476             _from,
477             _to,
478             _value,
479             etoken2Symbol,
480             _reference,
481             _sender
482         );
483     }
484 
485     /**
486      * Prforms allowance transfer of asset balance between holders.
487      *
488      * @param _from holder address to take from.
489      * @param _icap recipient ICAP address to give to.
490      * @param _value amount to transfer.
491      *
492      * @return success.
493      */
494     function transferFromToICAP(address _from, bytes32 _icap, uint _value)
495     public returns(bool) {
496         return transferFromToICAPWithReference(_from, _icap, _value, '');
497     }
498 
499     /**
500      * Prforms allowance transfer of asset balance between holders adding specified comment.
501      * Resolves asset implementation contract for the caller and forwards there arguments along with
502      * the caller address.
503      *
504      * @param _from holder address to take from.
505      * @param _icap recipient ICAP address to give to.
506      * @param _value amount to transfer.
507      * @param _reference transfer comment to be included in a EToken2's Transfer event.
508      *
509      * @return success.
510      */
511     function transferFromToICAPWithReference(
512         address _from,
513         bytes32 _icap,
514         uint _value,
515         string memory _reference)
516     public returns(bool) {
517         return _getAsset()._performTransferFromToICAPWithReference(
518             _from,
519             _icap,
520             _value,
521             _reference,
522             msg.sender
523         );
524     }
525 
526     /**
527      * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.
528      *
529      * Can only be called by asset implementation contract assigned to sender.
530      *
531      * @param _from holder address to take from.
532      * @param _icap recipient ICAP address to give to.
533      * @param _value amount to transfer.
534      * @param _reference transfer comment to be included in a EToken2's Transfer event.
535      * @param _sender initial caller.
536      *
537      * @return success.
538      */
539     function _forwardTransferFromToICAPWithReference(
540         address _from,
541         bytes32 _icap,
542         uint _value,
543         string memory _reference,
544         address _sender)
545     public onlyImplementationFor(_sender) returns(bool) {
546         return etoken2.proxyTransferFromToICAPWithReference(
547             _from,
548             _icap,
549             _value,
550             _reference,
551             _sender
552         );
553     }
554 
555     /**
556      * Sets asset spending allowance for a specified spender.
557      * Resolves asset implementation contract for the caller and forwards there arguments along with
558      * the caller address.
559      *
560      * @param _spender holder address to set allowance to.
561      * @param _value amount to allow.
562      *
563      * @return success.
564      */
565     function approve(address _spender, uint _value) public returns(bool) {
566         return _getAsset()._performApprove(_spender, _value, msg.sender);
567     }
568 
569     /**
570      * Performs allowance setting call on the EToken2 by the name of specified sender.
571      *
572      * Can only be called by asset implementation contract assigned to sender.
573      *
574      * @param _spender holder address to set allowance to.
575      * @param _value amount to allow.
576      * @param _sender initial caller.
577      *
578      * @return success.
579      */
580     function _forwardApprove(address _spender, uint _value, address _sender)
581     public onlyImplementationFor(_sender) returns(bool) {
582         return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);
583     }
584 
585     /**
586      * Emits ERC20 Transfer event on this contract.
587      *
588      * Can only be, and, called by assigned EToken2 when asset transfer happens.
589      */
590     function emitTransfer(address _from, address _to, uint _value) public onlyEToken2() {
591         emit Transfer(_from, _to, _value);
592     }
593 
594     /**
595      * Emits ERC20 Approval event on this contract.
596      *
597      * Can only be, and, called by assigned EToken2 when asset allowance set happens.
598      */
599     function emitApprove(address _from, address _spender, uint _value) public onlyEToken2() {
600         emit Approval(_from, _spender, _value);
601     }
602 
603     /**
604      * Resolves asset implementation contract for the caller and forwards there transaction data,
605      * along with the value. This allows for proxy interface growth.
606      */
607     function () external payable {
608         _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);
609         _returnReturnData(true);
610     }
611 
612     // Interface functions to allow specifying ICAP addresses as strings.
613     function transferToICAP(string memory _icap, uint _value) public returns(bool) {
614         return transferToICAPWithReference(_icap, _value, '');
615     }
616 
617     function transferToICAPWithReference(string memory _icap, uint _value, string memory _reference)
618     public returns(bool) {
619         return transferToICAPWithReference(_bytes32(_icap), _value, _reference);
620     }
621 
622     function transferFromToICAP(address _from, string memory _icap, uint _value)
623         public returns(bool)
624     {
625         return transferFromToICAPWithReference(_from, _icap, _value, '');
626     }
627 
628     function transferFromToICAPWithReference(
629         address _from,
630         string memory _icap,
631         uint _value,
632         string memory _reference)
633     public returns(bool) {
634         return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);
635     }
636 
637     /**
638      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
639      */
640     event UpgradeProposed(address newVersion);
641     event UpgradePurged(address newVersion);
642     event UpgradeCommited(address newVersion);
643     event OptedOut(address sender, address version);
644     event OptedIn(address sender, address version);
645 
646     // Current asset implementation contract address.
647     address internal latestVersion;
648 
649     // Proposed next asset implementation contract address.
650     address internal pendingVersion;
651 
652     // Upgrade freeze-time start.
653     uint internal pendingVersionTimestamp;
654 
655     // Timespan for users to review the new implementation and make decision.
656     uint internal constant UPGRADE_FREEZE_TIME = 3 days;
657 
658     // Asset implementation contract address that user decided to stick with.
659     // 0x0 means that user uses latest version.
660     mapping(address => address) internal userOptOutVersion;
661 
662     /**
663      * Only asset implementation contract assigned to sender is allowed to call.
664      */
665     modifier onlyImplementationFor(address _sender) {
666         if (getVersionFor(_sender) == msg.sender) {
667             _;
668         }
669     }
670 
671     /**
672      * Returns asset implementation contract address assigned to sender.
673      *
674      * @param _sender sender address.
675      *
676      * @return asset implementation contract address.
677      */
678     function getVersionFor(address _sender) public view returns(address) {
679         return userOptOutVersion[_sender] == address(0) ?
680             latestVersion : userOptOutVersion[_sender];
681     }
682 
683     /**
684      * Returns current asset implementation contract address.
685      *
686      * @return asset implementation contract address.
687      */
688     function getLatestVersion() public view returns(address) {
689         return latestVersion;
690     }
691 
692     /**
693      * Returns proposed next asset implementation contract address.
694      *
695      * @return asset implementation contract address.
696      */
697     function getPendingVersion() public view returns(address) {
698         return pendingVersion;
699     }
700 
701     /**
702      * Returns upgrade freeze-time start.
703      *
704      * @return freeze-time start.
705      */
706     function getPendingVersionTimestamp() public view returns(uint) {
707         return pendingVersionTimestamp;
708     }
709 
710     /**
711      * Propose next asset implementation contract address.
712      *
713      * Can only be called by current asset owner.
714      *
715      * Note: freeze-time should not be applied for the initial setup.
716      *
717      * @param _newVersion asset implementation contract address.
718      *
719      * @return success.
720      */
721     function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {
722         // Should not already be in the upgrading process.
723         if (pendingVersion != address(0)) {
724             return false;
725         }
726         // New version address should be other than 0x0.
727         if (_newVersion == address(0)) {
728             return false;
729         }
730         // Don't apply freeze-time for the initial setup.
731         if (latestVersion == address(0)) {
732             latestVersion = _newVersion;
733             return true;
734         }
735         pendingVersion = _newVersion;
736         // solhint-disable-next-line not-rely-on-time
737         pendingVersionTimestamp = now;
738         emit UpgradeProposed(_newVersion);
739         return true;
740     }
741 
742     /**
743      * Cancel the pending upgrade process.
744      *
745      * Can only be called by current asset owner.
746      *
747      * @return success.
748      */
749     function purgeUpgrade() public onlyAssetOwner() returns(bool) {
750         if (pendingVersion == address(0)) {
751             return false;
752         }
753         emit UpgradePurged(pendingVersion);
754         delete pendingVersion;
755         delete pendingVersionTimestamp;
756         return true;
757     }
758 
759     /**
760      * Finalize an upgrade process setting new asset implementation contract address.
761      *
762      * Can only be called after an upgrade freeze-time.
763      *
764      * @return success.
765      */
766     function commitUpgrade() public returns(bool) {
767         if (pendingVersion == address(0)) {
768             return false;
769         }
770         // solhint-disable-next-line not-rely-on-time
771         if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {
772             return false;
773         }
774         latestVersion = pendingVersion;
775         delete pendingVersion;
776         delete pendingVersionTimestamp;
777         emit UpgradeCommited(latestVersion);
778         return true;
779     }
780 
781     /**
782      * Disagree with proposed upgrade, and stick with current asset implementation
783      * until further explicit agreement to upgrade.
784      *
785      * @return success.
786      */
787     function optOut() public returns(bool) {
788         if (userOptOutVersion[msg.sender] != address(0)) {
789             return false;
790         }
791         userOptOutVersion[msg.sender] = latestVersion;
792         emit OptedOut(msg.sender, latestVersion);
793         return true;
794     }
795 
796     /**
797      * Implicitly agree to upgrade to current and future asset implementation upgrades,
798      * until further explicit disagreement.
799      *
800      * @return success.
801      */
802     function optIn() public returns(bool) {
803         delete userOptOutVersion[msg.sender];
804         emit OptedIn(msg.sender, latestVersion);
805         return true;
806     }
807 
808     // Backwards compatibility.
809     function multiAsset() public view returns(EToken2Interface) {
810         return etoken2;
811     }
812 }
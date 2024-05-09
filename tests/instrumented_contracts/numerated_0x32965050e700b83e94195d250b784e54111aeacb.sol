1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Owned contract with safe ownership pass.
35  *
36  * Note: all the non constant functions return false instead of throwing in case if state change
37  * didn't happen yet.
38  */
39 contract Owned {
40     /**
41      * Contract owner address
42      */
43     address public contractOwner;
44 
45     /**
46      * Contract owner address
47      */
48     address public pendingContractOwner;
49 
50     function Owned() {
51         contractOwner = msg.sender;
52     }
53 
54     /**
55     * @dev Owner check modifier
56     */
57     modifier onlyContractOwner() {
58         if (contractOwner == msg.sender) {
59             _;
60         }
61     }
62 
63     /**
64      * @dev Destroy contract and scrub a data
65      * @notice Only owner can call it
66      */
67     function destroy() onlyContractOwner {
68         suicide(msg.sender);
69     }
70 
71     /**
72      * Prepares ownership pass.
73      *
74      * Can only be called by current owner.
75      *
76      * @param _to address of the next owner. 0x0 is not allowed.
77      *
78      * @return success.
79      */
80     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
81         if (_to  == 0x0) {
82             return false;
83         }
84 
85         pendingContractOwner = _to;
86         return true;
87     }
88 
89     /**
90      * Finalize ownership pass.
91      *
92      * Can only be called by pending owner.
93      *
94      * @return success.
95      */
96     function claimContractOwnership() returns(bool) {
97         if (pendingContractOwner != msg.sender) {
98             return false;
99         }
100 
101         contractOwner = pendingContractOwner;
102         delete pendingContractOwner;
103 
104         return true;
105     }
106 }
107 
108 contract ERC20Interface {
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(address indexed from, address indexed spender, uint256 value);
111     string public symbol;
112 
113     function totalSupply() constant returns (uint256 supply);
114     function balanceOf(address _owner) constant returns (uint256 balance);
115     function transfer(address _to, uint256 _value) returns (bool success);
116     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
117     function approve(address _spender, uint256 _value) returns (bool success);
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
119 }
120 
121 /**
122  * @title Generic owned destroyable contract
123  */
124 contract Object is Owned {
125     /**
126     *  Common result code. Means everything is fine.
127     */
128     uint constant OK = 1;
129     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
130 
131     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
132         for(uint i=0;i<tokens.length;i++) {
133             address token = tokens[i];
134             uint balance = ERC20Interface(token).balanceOf(this);
135             if(balance != 0)
136                 ERC20Interface(token).transfer(_to,balance);
137         }
138         return OK;
139     }
140 
141     function checkOnlyContractOwner() internal constant returns(uint) {
142         if (contractOwner == msg.sender) {
143             return OK;
144         }
145 
146         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
147     }
148 }
149 
150 contract OracleMethodAdapter is Object {
151 
152     event OracleAdded(bytes4 _sig, address _oracle);
153     event OracleRemoved(bytes4 _sig, address _oracle);
154 
155     mapping(bytes4 => mapping(address => bool)) public oracles;
156 
157     /// @dev Allow access only for oracle
158     modifier onlyOracle {
159         if (oracles[msg.sig][msg.sender]) {
160             _;
161         }
162     }
163 
164     modifier onlyOracleOrOwner {
165         if (oracles[msg.sig][msg.sender] || msg.sender == contractOwner) {
166             _;
167         }
168     }
169 
170     function addOracles(
171         bytes4[] _signatures, 
172         address[] _oracles
173     ) 
174     onlyContractOwner 
175     external 
176     returns (uint) 
177     {
178         require(_signatures.length == _oracles.length);
179         bytes4 _sig;
180         address _oracle;
181         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
182             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
183             if (_oracle != 0x0 
184                 && _sig != bytes4(0) 
185                 && !oracles[_sig][_oracle]
186             ) {
187                 oracles[_sig][_oracle] = true;
188                 _emitOracleAdded(_sig, _oracle);
189             }
190         }
191         return OK;
192     }
193 
194     function removeOracles(
195         bytes4[] _signatures, 
196         address[] _oracles
197     ) 
198     onlyContractOwner 
199     external 
200     returns (uint) 
201     {
202         require(_signatures.length == _oracles.length);
203         bytes4 _sig;
204         address _oracle;
205         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
206             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
207             if (_oracle != 0x0 
208                 && _sig != bytes4(0) 
209                 && oracles[_sig][_oracle]
210             ) {
211                 delete oracles[_sig][_oracle];
212                 _emitOracleRemoved(_sig, _oracle);
213             }
214         }
215         return OK;
216     }
217 
218     function _emitOracleAdded(bytes4 _sig, address _oracle) internal {
219         OracleAdded(_sig, _oracle);
220     }
221 
222     function _emitOracleRemoved(bytes4 _sig, address _oracle) internal {
223         OracleRemoved(_sig, _oracle);
224     }
225 
226 }
227 
228 /// @title Provides possibility manage holders? country limits and limits for holders.
229 contract DataControllerInterface {
230 
231     /// @notice Checks user is holder.
232     /// @param _address - checking address.
233     /// @return `true` if _address is registered holder, `false` otherwise.
234     function isHolderAddress(address _address) public view returns (bool);
235 
236     function allowance(address _user) public view returns (uint);
237 
238     function changeAllowance(address _holder, uint _value) public returns (uint);
239 }
240 
241 /// @title ServiceController
242 ///
243 /// Base implementation
244 /// Serves for managing service instances
245 contract ServiceControllerInterface {
246 
247     /// @notice Check target address is service
248     /// @param _address target address
249     /// @return `true` when an address is a service, `false` otherwise
250     function isService(address _address) public view returns (bool);
251 }
252 
253 contract ATxAssetInterface {
254 
255     DataControllerInterface public dataController;
256     ServiceControllerInterface public serviceController;
257 
258     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
259     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
260     function __approve(address _spender, uint _value, address _sender) public returns (bool);
261     function __process(bytes /*_data*/, address /*_sender*/) payable public {
262         revert();
263     }
264 }
265 
266 /// @title ServiceAllowance.
267 ///
268 /// Provides a way to delegate operation allowance decision to a service contract
269 contract ServiceAllowance {
270     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
271 }
272 
273 contract ERC20 {
274     event Transfer(address indexed from, address indexed to, uint256 value);
275     event Approval(address indexed from, address indexed spender, uint256 value);
276     string public symbol;
277 
278     function totalSupply() constant returns (uint256 supply);
279     function balanceOf(address _owner) constant returns (uint256 balance);
280     function transfer(address _to, uint256 _value) returns (bool success);
281     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
282     function approve(address _spender, uint256 _value) returns (bool success);
283     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
284 }
285 
286 
287 contract Platform {
288     mapping(bytes32 => address) public proxies;
289     function name(bytes32 _symbol) public view returns (string);
290     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
291     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
292     function totalSupply(bytes32 _symbol) public view returns (uint);
293     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
294     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
295     function baseUnit(bytes32 _symbol) public view returns (uint8);
296     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
297     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
298     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
299     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
300     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
301     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
302     function isReissuable(bytes32 _symbol) public view returns (bool);
303     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
304 }
305 
306 
307 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
308 
309     // Timespan for users to review the new implementation and make decision.
310     uint constant UPGRADE_FREEZE_TIME = 3 days;
311 
312     using SafeMath for uint;
313 
314     /**
315      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
316      */
317     event UpgradeProposal(address newVersion);
318 
319     // Current asset implementation contract address.
320     address latestVersion;
321 
322     // Proposed next asset implementation contract address.
323     address pendingVersion;
324 
325     // Upgrade freeze-time start.
326     uint pendingVersionTimestamp;
327 
328     // Assigned platform, immutable.
329     Platform public platform;
330 
331     // Assigned symbol, immutable.
332     bytes32 public smbl;
333 
334     // Assigned name, immutable.
335     string public name;
336 
337     /**
338      * Only platform is allowed to call.
339      */
340     modifier onlyPlatform() {
341         if (msg.sender == address(platform)) {
342             _;
343         }
344     }
345 
346     /**
347      * Only current asset owner is allowed to call.
348      */
349     modifier onlyAssetOwner() {
350         if (platform.isOwner(msg.sender, smbl)) {
351             _;
352         }
353     }
354 
355     /**
356      * Only asset implementation contract assigned to sender is allowed to call.
357      */
358     modifier onlyAccess(address _sender) {
359         if (getLatestVersion() == msg.sender) {
360             _;
361         }
362     }
363 
364     /**
365      * Resolves asset implementation contract for the caller and forwards there transaction data,
366      * along with the value. This allows for proxy interface growth.
367      */
368     function() public payable {
369         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
370     }
371 
372     /**
373      * Sets platform address, assigns symbol and name.
374      *
375      * Can be set only once.
376      *
377      * @param _platform platform contract address.
378      * @param _symbol assigned symbol.
379      * @param _name assigned name.
380      *
381      * @return success.
382      */
383     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
384         if (address(platform) != 0x0) {
385             return false;
386         }
387         platform = _platform;
388         symbol = _symbol;
389         smbl = stringToBytes32(_symbol);
390         name = _name;
391         return true;
392     }
393 
394     /**
395      * Returns asset total supply.
396      *
397      * @return asset total supply.
398      */
399     function totalSupply() public view returns (uint) {
400         return platform.totalSupply(smbl);
401     }
402 
403     /**
404      * Returns asset balance for a particular holder.
405      *
406      * @param _owner holder address.
407      *
408      * @return holder balance.
409      */
410     function balanceOf(address _owner) public view returns (uint) {
411         return platform.balanceOf(_owner, smbl);
412     }
413 
414     /**
415      * Returns asset allowance from one holder to another.
416      *
417      * @param _from holder that allowed spending.
418      * @param _spender holder that is allowed to spend.
419      *
420      * @return holder to spender allowance.
421      */
422     function allowance(address _from, address _spender) public view returns (uint) {
423         return platform.allowance(_from, _spender, smbl);
424     }
425 
426     /**
427      * Returns asset decimals.
428      *
429      * @return asset decimals.
430      */
431     function decimals() public view returns (uint8) {
432         return platform.baseUnit(smbl);
433     }
434 
435     /**
436      * Transfers asset balance from the caller to specified receiver.
437      *
438      * @param _to holder address to give to.
439      * @param _value amount to transfer.
440      *
441      * @return success.
442      */
443     function transfer(address _to, uint _value) public returns (bool) {
444         if (_to != 0x0) {
445             return _transferWithReference(_to, _value, "");
446         }
447         else {
448             return false;
449         }
450     }
451 
452     /**
453      * Transfers asset balance from the caller to specified receiver adding specified comment.
454      *
455      * @param _to holder address to give to.
456      * @param _value amount to transfer.
457      * @param _reference transfer comment to be included in a platform's Transfer event.
458      *
459      * @return success.
460      */
461     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
462         if (_to != 0x0) {
463             return _transferWithReference(_to, _value, _reference);
464         }
465         else {
466             return false;
467         }
468     }
469 
470     /**
471      * Performs transfer call on the platform by the name of specified sender.
472      *
473      * Can only be called by asset implementation contract assigned to sender.
474      *
475      * @param _to holder address to give to.
476      * @param _value amount to transfer.
477      * @param _reference transfer comment to be included in a platform's Transfer event.
478      * @param _sender initial caller.
479      *
480      * @return success.
481      */
482     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
483         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
484     }
485 
486     /**
487      * Prforms allowance transfer of asset balance between holders.
488      *
489      * @param _from holder address to take from.
490      * @param _to holder address to give to.
491      * @param _value amount to transfer.
492      *
493      * @return success.
494      */
495     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
496         if (_to != 0x0) {
497             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
498         }
499         else {
500             return false;
501         }
502     }
503 
504     /**
505      * Performs allowance transfer call on the platform by the name of specified sender.
506      *
507      * Can only be called by asset implementation contract assigned to sender.
508      *
509      * @param _from holder address to take from.
510      * @param _to holder address to give to.
511      * @param _value amount to transfer.
512      * @param _reference transfer comment to be included in a platform's Transfer event.
513      * @param _sender initial caller.
514      *
515      * @return success.
516      */
517     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
518         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
519     }
520 
521     /**
522      * Sets asset spending allowance for a specified spender.
523      *
524      * @param _spender holder address to set allowance to.
525      * @param _value amount to allow.
526      *
527      * @return success.
528      */
529     function approve(address _spender, uint _value) public returns (bool) {
530         if (_spender != 0x0) {
531             return _getAsset().__approve(_spender, _value, msg.sender);
532         }
533         else {
534             return false;
535         }
536     }
537 
538     /**
539      * Performs allowance setting call on the platform by the name of specified sender.
540      *
541      * Can only be called by asset implementation contract assigned to sender.
542      *
543      * @param _spender holder address to set allowance to.
544      * @param _value amount to allow.
545      * @param _sender initial caller.
546      *
547      * @return success.
548      */
549     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
550         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
551     }
552 
553     /**
554      * Emits ERC20 Transfer event on this contract.
555      *
556      * Can only be, and, called by assigned platform when asset transfer happens.
557      */
558     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
559         Transfer(_from, _to, _value);
560     }
561 
562     /**
563      * Emits ERC20 Approval event on this contract.
564      *
565      * Can only be, and, called by assigned platform when asset allowance set happens.
566      */
567     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
568         Approval(_from, _spender, _value);
569     }
570 
571     /**
572      * Returns current asset implementation contract address.
573      *
574      * @return asset implementation contract address.
575      */
576     function getLatestVersion() public view returns (address) {
577         return latestVersion;
578     }
579 
580     /**
581      * Returns proposed next asset implementation contract address.
582      *
583      * @return asset implementation contract address.
584      */
585     function getPendingVersion() public view returns (address) {
586         return pendingVersion;
587     }
588 
589     /**
590      * Returns upgrade freeze-time start.
591      *
592      * @return freeze-time start.
593      */
594     function getPendingVersionTimestamp() public view returns (uint) {
595         return pendingVersionTimestamp;
596     }
597 
598     /**
599      * Propose next asset implementation contract address.
600      *
601      * Can only be called by current asset owner.
602      *
603      * Note: freeze-time should not be applied for the initial setup.
604      *
605      * @param _newVersion asset implementation contract address.
606      *
607      * @return success.
608      */
609     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
610         // Should not already be in the upgrading process.
611         if (pendingVersion != 0x0) {
612             return false;
613         }
614         // New version address should be other than 0x0.
615         if (_newVersion == 0x0) {
616             return false;
617         }
618         // Don't apply freeze-time for the initial setup.
619         if (latestVersion == 0x0) {
620             latestVersion = _newVersion;
621             return true;
622         }
623         pendingVersion = _newVersion;
624         pendingVersionTimestamp = now;
625         UpgradeProposal(_newVersion);
626         return true;
627     }
628 
629     /**
630      * Cancel the pending upgrade process.
631      *
632      * Can only be called by current asset owner.
633      *
634      * @return success.
635      */
636     function purgeUpgrade() public onlyAssetOwner returns (bool) {
637         if (pendingVersion == 0x0) {
638             return false;
639         }
640         delete pendingVersion;
641         delete pendingVersionTimestamp;
642         return true;
643     }
644 
645     /**
646      * Finalize an upgrade process setting new asset implementation contract address.
647      *
648      * Can only be called after an upgrade freeze-time.
649      *
650      * @return success.
651      */
652     function commitUpgrade() public returns (bool) {
653         if (pendingVersion == 0x0) {
654             return false;
655         }
656         if (pendingVersionTimestamp.add(UPGRADE_FREEZE_TIME) > now) {
657             return false;
658         }
659         latestVersion = pendingVersion;
660         delete pendingVersion;
661         delete pendingVersionTimestamp;
662         return true;
663     }
664 
665     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
666         return true;
667     }
668 
669     /**
670      * Returns asset implementation contract for current caller.
671      *
672      * @return asset implementation contract.
673      */
674     function _getAsset() internal view returns (ATxAssetInterface) {
675         return ATxAssetInterface(getLatestVersion());
676     }
677 
678     /**
679      * Resolves asset implementation contract for the caller and forwards there arguments along with
680      * the caller address.
681      *
682      * @return success.
683      */
684     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
685         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
686     }
687 
688     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
689         assembly {
690             result := mload(add(source, 32))
691         }
692     }
693 }
694 
695 contract DataControllerEmitter {
696 
697     event CountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount);
698     event CountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount);
699 
700     event HolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode);
701     event HolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
702     event HolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
703     event HolderOperationalChanged(bytes32 _externalHolderId, bool _operational);
704 
705     event DayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
706     event MonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
707 
708     event Error(uint _errorCode);
709 
710     function _emitHolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
711         HolderAddressAdded(_externalHolderId, _holderPrototype, _accessIndex);
712     }
713 
714     function _emitHolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
715         HolderAddressRemoved(_externalHolderId, _holderPrototype, _accessIndex);
716     }
717 
718     function _emitHolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode) internal {
719         HolderRegistered(_externalHolderId, _accessIndex, _countryCode);
720     }
721 
722     function _emitHolderOperationalChanged(bytes32 _externalHolderId, bool _operational) internal {
723         HolderOperationalChanged(_externalHolderId, _operational);
724     }
725 
726     function _emitCountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
727         CountryCodeAdded(_countryCode, _countryId, _maxHolderCount);
728     }
729 
730     function _emitCountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
731         CountryCodeChanged(_countryCode, _countryId, _maxHolderCount);
732     }
733 
734     function _emitDayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
735         DayLimitChanged(_externalHolderId, _from, _to);
736     }
737 
738     function _emitMonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
739         MonthLimitChanged(_externalHolderId, _from, _to);
740     }
741 
742     function _emitError(uint _errorCode) internal returns (uint) {
743         Error(_errorCode);
744         return _errorCode;
745     }
746 }
747 
748 contract GroupsAccessManagerEmitter {
749 
750     event UserCreated(address user);
751     event UserDeleted(address user);
752     event GroupCreated(bytes32 groupName);
753     event GroupActivated(bytes32 groupName);
754     event GroupDeactivated(bytes32 groupName);
755     event UserToGroupAdded(address user, bytes32 groupName);
756     event UserFromGroupRemoved(address user, bytes32 groupName);
757 }
758 
759 /// @title Group Access Manager
760 ///
761 /// Base implementation
762 /// This contract serves as group manager
763 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
764 
765     uint constant USER_MANAGER_SCOPE = 111000;
766     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
767     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
768     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
769     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
770     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
771     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
772     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
773     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
774     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
775 
776     using SafeMath for uint;
777 
778     struct Member {
779         address addr;
780         uint groupsCount;
781         mapping(bytes32 => uint) groupName2index;
782         mapping(uint => uint) index2globalIndex;
783     }
784 
785     struct Group {
786         bytes32 name;
787         uint priority;
788         uint membersCount;
789         mapping(address => uint) memberAddress2index;
790         mapping(uint => uint) index2globalIndex;
791     }
792 
793     uint public membersCount;
794     mapping(uint => address) index2memberAddress;
795     mapping(address => uint) memberAddress2index;
796     mapping(address => Member) address2member;
797 
798     uint public groupsCount;
799     mapping(uint => bytes32) index2groupName;
800     mapping(bytes32 => uint) groupName2index;
801     mapping(bytes32 => Group) groupName2group;
802     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
803 
804     function() payable public {
805         revert();
806     }
807 
808     /// @notice Register user
809     /// Can be called only by contract owner
810     ///
811     /// @param _user user address
812     ///
813     /// @return code
814     function registerUser(address _user) external onlyContractOwner returns (uint) {
815         require(_user != 0x0);
816 
817         if (isRegisteredUser(_user)) {
818             return USER_MANAGER_MEMBER_ALREADY_EXIST;
819         }
820 
821         uint _membersCount = membersCount.add(1);
822         membersCount = _membersCount;
823         memberAddress2index[_user] = _membersCount;
824         index2memberAddress[_membersCount] = _user;
825         address2member[_user] = Member(_user, 0);
826 
827         UserCreated(_user);
828         return OK;
829     }
830 
831     /// @notice Discard user registration
832     /// Can be called only by contract owner
833     ///
834     /// @param _user user address
835     ///
836     /// @return code
837     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
838         require(_user != 0x0);
839 
840         uint _memberIndex = memberAddress2index[_user];
841         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
842             return USER_MANAGER_INVALID_INVOCATION;
843         }
844 
845         uint _membersCount = membersCount;
846         delete memberAddress2index[_user];
847         if (_memberIndex != _membersCount) {
848             address _lastUser = index2memberAddress[_membersCount];
849             index2memberAddress[_memberIndex] = _lastUser;
850             memberAddress2index[_lastUser] = _memberIndex;
851         }
852         delete address2member[_user];
853         delete index2memberAddress[_membersCount];
854         delete memberAddress2index[_user];
855         membersCount = _membersCount.sub(1);
856 
857         UserDeleted(_user);
858         return OK;
859     }
860 
861     /// @notice Create group
862     /// Can be called only by contract owner
863     ///
864     /// @param _groupName group name
865     /// @param _priority group priority
866     ///
867     /// @return code
868     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
869         require(_groupName != bytes32(0));
870 
871         if (isGroupExists(_groupName)) {
872             return USER_MANAGER_GROUP_ALREADY_EXIST;
873         }
874 
875         uint _groupsCount = groupsCount.add(1);
876         groupName2index[_groupName] = _groupsCount;
877         index2groupName[_groupsCount] = _groupName;
878         groupName2group[_groupName] = Group(_groupName, _priority, 0);
879         groupsCount = _groupsCount;
880 
881         GroupCreated(_groupName);
882         return OK;
883     }
884 
885     /// @notice Change group status
886     /// Can be called only by contract owner
887     ///
888     /// @param _groupName group name
889     /// @param _blocked block status
890     ///
891     /// @return code
892     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
893         require(isGroupExists(_groupName));
894         groupsBlocked[_groupName] = _blocked;
895         return OK;
896     }
897 
898     /// @notice Add users in group
899     /// Can be called only by contract owner
900     ///
901     /// @param _groupName group name
902     /// @param _users user array
903     ///
904     /// @return code
905     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
906         require(isGroupExists(_groupName));
907 
908         Group storage _group = groupName2group[_groupName];
909         uint _groupMembersCount = _group.membersCount;
910 
911         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
912             address _user = _users[_userIdx];
913             uint _memberIndex = memberAddress2index[_user];
914             require(_memberIndex != 0);
915 
916             if (_group.memberAddress2index[_user] != 0) {
917                 continue;
918             }
919 
920             _groupMembersCount = _groupMembersCount.add(1);
921             _group.memberAddress2index[_user] = _groupMembersCount;
922             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
923 
924             _addGroupToMember(_user, _groupName);
925 
926             UserToGroupAdded(_user, _groupName);
927         }
928         _group.membersCount = _groupMembersCount;
929 
930         return OK;
931     }
932 
933     /// @notice Remove users in group
934     /// Can be called only by contract owner
935     ///
936     /// @param _groupName group name
937     /// @param _users user array
938     ///
939     /// @return code
940     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
941         require(isGroupExists(_groupName));
942 
943         Group storage _group = groupName2group[_groupName];
944         uint _groupMembersCount = _group.membersCount;
945 
946         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
947             address _user = _users[_userIdx];
948             uint _memberIndex = memberAddress2index[_user];
949             uint _groupMemberIndex = _group.memberAddress2index[_user];
950 
951             if (_memberIndex == 0 || _groupMemberIndex == 0) {
952                 continue;
953             }
954 
955             if (_groupMemberIndex != _groupMembersCount) {
956                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
957                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
958                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
959                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
960             }
961             delete _group.memberAddress2index[_user];
962             delete _group.index2globalIndex[_groupMembersCount];
963             _groupMembersCount = _groupMembersCount.sub(1);
964 
965             _removeGroupFromMember(_user, _groupName);
966 
967             UserFromGroupRemoved(_user, _groupName);
968         }
969         _group.membersCount = _groupMembersCount;
970 
971         return OK;
972     }
973 
974     /// @notice Check is user registered
975     ///
976     /// @param _user user address
977     ///
978     /// @return status
979     function isRegisteredUser(address _user) public view returns (bool) {
980         return memberAddress2index[_user] != 0;
981     }
982 
983     /// @notice Check is user in group
984     ///
985     /// @param _groupName user array
986     /// @param _user user array
987     ///
988     /// @return status
989     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
990         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
991     }
992 
993     /// @notice Check is group exist
994     ///
995     /// @param _groupName group name
996     ///
997     /// @return status
998     function isGroupExists(bytes32 _groupName) public view returns (bool) {
999         return groupName2index[_groupName] != 0;
1000     }
1001 
1002     /// @notice Get current group names
1003     ///
1004     /// @return group names
1005     function getGroups() public view returns (bytes32[] _groups) {
1006         uint _groupsCount = groupsCount;
1007         _groups = new bytes32[](_groupsCount);
1008         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
1009             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
1010         }
1011     }
1012 
1013     // PRIVATE
1014 
1015     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
1016         Member storage _member = address2member[_user];
1017         uint _memberGroupsCount = _member.groupsCount;
1018         uint _memberGroupIndex = _member.groupName2index[_groupName];
1019         if (_memberGroupIndex != _memberGroupsCount) {
1020             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
1021             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
1022             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
1023             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
1024         }
1025         delete _member.groupName2index[_groupName];
1026         delete _member.index2globalIndex[_memberGroupsCount];
1027         _member.groupsCount = _memberGroupsCount.sub(1);
1028     }
1029 
1030     function _addGroupToMember(address _user, bytes32 _groupName) private {
1031         Member storage _member = address2member[_user];
1032         uint _memberGroupsCount = _member.groupsCount.add(1);
1033         _member.groupName2index[_groupName] = _memberGroupsCount;
1034         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
1035         _member.groupsCount = _memberGroupsCount;
1036     }
1037 }
1038 
1039 contract PendingManagerEmitter {
1040 
1041     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
1042     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
1043 
1044     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
1045     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1046     event ProtectionTxDone(bytes32 key);
1047     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1048     event ProtectionTxCancelled(bytes32 key);
1049     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1050     event TxDeleted(bytes32 key);
1051 
1052     event Error(uint errorCode);
1053 
1054     function _emitError(uint _errorCode) internal returns (uint) {
1055         Error(_errorCode);
1056         return _errorCode;
1057     }
1058 }
1059 
1060 contract PendingManagerInterface {
1061 
1062     function signIn(address _contract) external returns (uint);
1063     function signOut(address _contract) external returns (uint);
1064 
1065     function addPolicyRule(
1066         bytes4 _sig, 
1067         address _contract, 
1068         bytes32 _groupName, 
1069         uint _acceptLimit, 
1070         uint _declineLimit 
1071         ) 
1072         external returns (uint);
1073         
1074     function removePolicyRule(
1075         bytes4 _sig, 
1076         address _contract, 
1077         bytes32 _groupName
1078         ) 
1079         external returns (uint);
1080 
1081     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
1082     function deleteTx(bytes32 _key) external returns (uint);
1083 
1084     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1085     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1086     function revoke(bytes32 _key) external returns (uint);
1087 
1088     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
1089     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
1090         bytes32[] _groupNames,
1091         uint[] _acceptLimits,
1092         uint[] _declineLimits,
1093         uint _totalAcceptedLimit,
1094         uint _totalDeclinedLimit
1095         );
1096 }
1097 
1098 /// @title PendingManager
1099 ///
1100 /// Base implementation
1101 /// This contract serves as pending manager for transaction status
1102 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
1103 
1104     uint constant NO_RECORDS_WERE_FOUND = 4;
1105     uint constant PENDING_MANAGER_SCOPE = 4000;
1106     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
1107     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
1108     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
1109     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
1110     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
1111     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
1112     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
1113     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
1114     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
1115     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
1116     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
1117 
1118     using SafeMath for uint;
1119 
1120     enum GuardState {
1121         Decline, Confirmed, InProcess
1122     }
1123 
1124     struct Requirements {
1125         bytes32 groupName;
1126         uint acceptLimit;
1127         uint declineLimit;
1128     }
1129 
1130     struct Policy {
1131         uint groupsCount;
1132         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
1133         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
1134         
1135         uint totalAcceptedLimit;
1136         uint totalDeclinedLimit;
1137 
1138         uint securesCount;
1139         mapping(uint => uint) index2txIndex;
1140         mapping(uint => uint) txIndex2index;
1141     }
1142 
1143     struct Vote {
1144         bytes32 groupName;
1145         bool accepted;
1146     }
1147 
1148     struct Guard {
1149         GuardState state;
1150         uint basePolicyIndex;
1151 
1152         uint alreadyAccepted;
1153         uint alreadyDeclined;
1154         
1155         mapping(address => Vote) votes; // member address => vote
1156         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
1157         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
1158     }
1159 
1160     address public accessManager;
1161 
1162     mapping(address => bool) public authorized;
1163 
1164     uint public policiesCount;
1165     mapping(uint => bytes32) index2PolicyId; // index => policy hash
1166     mapping(bytes32 => uint) policyId2Index; // policy hash => index
1167     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
1168 
1169     uint public txCount;
1170     mapping(uint => bytes32) index2txKey;
1171     mapping(bytes32 => uint) txKey2index; // tx key => index
1172     mapping(bytes32 => Guard) txKey2guard;
1173 
1174     /// @dev Execution is allowed only by authorized contract
1175     modifier onlyAuthorized {
1176         if (authorized[msg.sender] || address(this) == msg.sender) {
1177             _;
1178         }
1179     }
1180 
1181     /// @dev Pending Manager's constructor
1182     ///
1183     /// @param _accessManager access manager's address
1184     function PendingManager(address _accessManager) public {
1185         require(_accessManager != 0x0);
1186         accessManager = _accessManager;
1187     }
1188 
1189     function() payable public {
1190         revert();
1191     }
1192 
1193     /// @notice Update access manager address
1194     ///
1195     /// @param _accessManager access manager's address
1196     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
1197         require(_accessManager != 0x0);
1198         accessManager = _accessManager;
1199         return OK;
1200     }
1201 
1202     /// @notice Sign in contract
1203     ///
1204     /// @param _contract contract's address
1205     function signIn(address _contract) external onlyContractOwner returns (uint) {
1206         require(_contract != 0x0);
1207         authorized[_contract] = true;
1208         return OK;
1209     }
1210 
1211     /// @notice Sign out contract
1212     ///
1213     /// @param _contract contract's address
1214     function signOut(address _contract) external onlyContractOwner returns (uint) {
1215         require(_contract != 0x0);
1216         delete authorized[_contract];
1217         return OK;
1218     }
1219 
1220     /// @notice Register new policy rule
1221     /// Can be called only by contract owner
1222     ///
1223     /// @param _sig target method signature
1224     /// @param _contract target contract address
1225     /// @param _groupName group's name
1226     /// @param _acceptLimit accepted vote limit
1227     /// @param _declineLimit decline vote limit
1228     ///
1229     /// @return code
1230     function addPolicyRule(
1231         bytes4 _sig,
1232         address _contract,
1233         bytes32 _groupName,
1234         uint _acceptLimit,
1235         uint _declineLimit
1236     )
1237     onlyContractOwner
1238     external
1239     returns (uint)
1240     {
1241         require(_sig != 0x0);
1242         require(_contract != 0x0);
1243         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1244         require(_acceptLimit != 0);
1245         require(_declineLimit != 0);
1246 
1247         bytes32 _policyHash = keccak256(_sig, _contract);
1248         
1249         if (policyId2Index[_policyHash] == 0) {
1250             uint _policiesCount = policiesCount.add(1);
1251             index2PolicyId[_policiesCount] = _policyHash;
1252             policyId2Index[_policyHash] = _policiesCount;
1253             policiesCount = _policiesCount;
1254         }
1255 
1256         Policy storage _policy = policyId2policy[_policyHash];
1257         uint _policyGroupsCount = _policy.groupsCount;
1258 
1259         if (_policy.groupName2index[_groupName] == 0) {
1260             _policyGroupsCount += 1;
1261             _policy.groupName2index[_groupName] = _policyGroupsCount;
1262             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
1263             _policy.groupsCount = _policyGroupsCount;
1264         }
1265 
1266         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
1267         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
1268         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
1269         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
1270         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
1271         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
1272 
1273         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
1274         return OK;
1275     }
1276 
1277     /// @notice Remove policy rule
1278     /// Can be called only by contract owner
1279     ///
1280     /// @param _groupName group's name
1281     ///
1282     /// @return code
1283     function removePolicyRule(
1284         bytes4 _sig,
1285         address _contract,
1286         bytes32 _groupName
1287     ) 
1288     onlyContractOwner 
1289     external 
1290     returns (uint) 
1291     {
1292         require(_sig != bytes4(0));
1293         require(_contract != 0x0);
1294         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1295 
1296         bytes32 _policyHash = keccak256(_sig, _contract);
1297         Policy storage _policy = policyId2policy[_policyHash];
1298         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
1299 
1300         if (_policyGroupNameIndex == 0) {
1301             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1302         }
1303 
1304         uint _policyGroupsCount = _policy.groupsCount;
1305         if (_policyGroupNameIndex != _policyGroupsCount) {
1306             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
1307             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
1308             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
1309         }
1310 
1311         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
1312         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
1313 
1314         delete _policy.groupName2index[_groupName];
1315         delete _policy.participatedGroups[_policyGroupsCount];
1316         _policy.groupsCount = _policyGroupsCount.sub(1);
1317 
1318         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
1319         return OK;
1320     }
1321 
1322     /// @notice Add transaction
1323     ///
1324     /// @param _key transaction id
1325     ///
1326     /// @return code
1327     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
1328         require(_key != bytes32(0));
1329         require(_sig != bytes4(0));
1330         require(_contract != 0x0);
1331 
1332         bytes32 _policyHash = keccak256(_sig, _contract);
1333         require(isPolicyExist(_policyHash));
1334 
1335         if (isTxExist(_key)) {
1336             return _emitError(PENDING_DUPLICATE_TX);
1337         }
1338 
1339         if (_policyHash == bytes32(0)) {
1340             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
1341         }
1342 
1343         uint _index = txCount.add(1);
1344         txCount = _index;
1345         index2txKey[_index] = _key;
1346         txKey2index[_key] = _index;
1347 
1348         Guard storage _guard = txKey2guard[_key];
1349         _guard.basePolicyIndex = policyId2Index[_policyHash];
1350         _guard.state = GuardState.InProcess;
1351 
1352         Policy storage _policy = policyId2policy[_policyHash];
1353         uint _counter = _policy.securesCount.add(1);
1354         _policy.securesCount = _counter;
1355         _policy.index2txIndex[_counter] = _index;
1356         _policy.txIndex2index[_index] = _counter;
1357 
1358         ProtectionTxAdded(_key, _policyHash, block.number);
1359         return OK;
1360     }
1361 
1362     /// @notice Delete transaction
1363     /// @param _key transaction id
1364     /// @return code
1365     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
1366         require(_key != bytes32(0));
1367 
1368         if (!isTxExist(_key)) {
1369             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1370         }
1371 
1372         uint _txsCount = txCount;
1373         uint _txIndex = txKey2index[_key];
1374         if (_txIndex != _txsCount) {
1375             bytes32 _last = index2txKey[txCount];
1376             index2txKey[_txIndex] = _last;
1377             txKey2index[_last] = _txIndex;
1378         }
1379 
1380         delete txKey2index[_key];
1381         delete index2txKey[_txsCount];
1382         txCount = _txsCount.sub(1);
1383 
1384         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
1385         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
1386         uint _counter = _policy.securesCount;
1387         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
1388         if (_policyTxIndex != _counter) {
1389             uint _movedTxIndex = _policy.index2txIndex[_counter];
1390             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
1391             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
1392         }
1393 
1394         delete _policy.index2txIndex[_counter];
1395         delete _policy.txIndex2index[_txIndex];
1396         _policy.securesCount = _counter.sub(1);
1397 
1398         TxDeleted(_key);
1399         return OK;
1400     }
1401 
1402     /// @notice Accept transaction
1403     /// Can be called only by registered user in GroupsAccessManager
1404     ///
1405     /// @param _key transaction id
1406     ///
1407     /// @return code
1408     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1409         if (!isTxExist(_key)) {
1410             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1411         }
1412 
1413         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1414             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1415         }
1416 
1417         Guard storage _guard = txKey2guard[_key];
1418         if (_guard.state != GuardState.InProcess) {
1419             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1420         }
1421 
1422         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
1423             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1424         }
1425 
1426         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1427         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1428         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
1429         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
1430             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1431         }
1432 
1433         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
1434         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
1435         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
1436         _guard.alreadyAccepted = _alreadyAcceptedCount;
1437 
1438         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
1439 
1440         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
1441             _guard.state = GuardState.Confirmed;
1442             ProtectionTxDone(_key);
1443         }
1444 
1445         return OK;
1446     }
1447 
1448     /// @notice Decline transaction
1449     /// Can be called only by registered user in GroupsAccessManager
1450     ///
1451     /// @param _key transaction id
1452     ///
1453     /// @return code
1454     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1455         if (!isTxExist(_key)) {
1456             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1457         }
1458 
1459         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1460             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1461         }
1462 
1463         Guard storage _guard = txKey2guard[_key];
1464         if (_guard.state != GuardState.InProcess) {
1465             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1466         }
1467 
1468         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
1469             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1470         }
1471 
1472         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1473         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1474         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
1475         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
1476             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1477         }
1478 
1479         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
1480         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
1481         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
1482         _guard.alreadyDeclined = _alreadyDeclinedCount;
1483 
1484 
1485         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
1486 
1487         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
1488             _guard.state = GuardState.Decline;
1489             ProtectionTxCancelled(_key);
1490         }
1491 
1492         return OK;
1493     }
1494 
1495     /// @notice Revoke user votes for transaction
1496     /// Can be called only by contract owner
1497     ///
1498     /// @param _key transaction id
1499     /// @param _user target user address
1500     ///
1501     /// @return code
1502     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
1503         return _revoke(_key, _user);
1504     }
1505 
1506     /// @notice Revoke vote for transaction
1507     /// Can be called only by authorized user
1508     /// @param _key transaction id
1509     /// @return code
1510     function revoke(bytes32 _key) external returns (uint) {
1511         return _revoke(_key, msg.sender);
1512     }
1513 
1514     /// @notice Check transaction status
1515     /// @param _key transaction id
1516     /// @return code
1517     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
1518         require(_key != bytes32(0));
1519 
1520         if (!isTxExist(_key)) {
1521             return NO_RECORDS_WERE_FOUND;
1522         }
1523 
1524         Guard storage _guard = txKey2guard[_key];
1525         return _guard.state == GuardState.InProcess
1526         ? PENDING_MANAGER_IN_PROCESS
1527         : _guard.state == GuardState.Confirmed
1528         ? OK
1529         : PENDING_MANAGER_REJECTED;
1530     }
1531 
1532 
1533     /// @notice Check policy details
1534     ///
1535     /// @return _groupNames group names included in policies
1536     /// @return _acceptLimits accept limit for group
1537     /// @return _declineLimits decline limit for group
1538     function getPolicyDetails(bytes4 _sig, address _contract)
1539     public
1540     view
1541     returns (
1542         bytes32[] _groupNames,
1543         uint[] _acceptLimits,
1544         uint[] _declineLimits,
1545         uint _totalAcceptedLimit,
1546         uint _totalDeclinedLimit
1547     ) {
1548         require(_sig != bytes4(0));
1549         require(_contract != 0x0);
1550         
1551         bytes32 _policyHash = keccak256(_sig, _contract);
1552         uint _policyIdx = policyId2Index[_policyHash];
1553         if (_policyIdx == 0) {
1554             return;
1555         }
1556 
1557         Policy storage _policy = policyId2policy[_policyHash];
1558         uint _policyGroupsCount = _policy.groupsCount;
1559         _groupNames = new bytes32[](_policyGroupsCount);
1560         _acceptLimits = new uint[](_policyGroupsCount);
1561         _declineLimits = new uint[](_policyGroupsCount);
1562 
1563         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1564             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1565             _groupNames[_idx] = _requirements.groupName;
1566             _acceptLimits[_idx] = _requirements.acceptLimit;
1567             _declineLimits[_idx] = _requirements.declineLimit;
1568         }
1569 
1570         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1571     }
1572 
1573     /// @notice Check policy include target group
1574     /// @param _policyHash policy hash (sig, contract address)
1575     /// @param _groupName group id
1576     /// @return bool
1577     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1578         Policy storage _policy = policyId2policy[_policyHash];
1579         return _policy.groupName2index[_groupName] != 0;
1580     }
1581 
1582     /// @notice Check is policy exist
1583     /// @param _policyHash policy hash (sig, contract address)
1584     /// @return bool
1585     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1586         return policyId2Index[_policyHash] != 0;
1587     }
1588 
1589     /// @notice Check is transaction exist
1590     /// @param _key transaction id
1591     /// @return bool
1592     function isTxExist(bytes32 _key) public view returns (bool){
1593         return txKey2index[_key] != 0;
1594     }
1595 
1596     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1597         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1598             _guard.state = GuardState.Decline;
1599         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1600             _guard.state = GuardState.Confirmed;
1601         } else if (_guard.state != GuardState.InProcess) {
1602             _guard.state = GuardState.InProcess;
1603         }
1604     }
1605 
1606     function _revoke(bytes32 _key, address _user) private returns (uint) {
1607         require(_key != bytes32(0));
1608         require(_user != 0x0);
1609 
1610         if (!isTxExist(_key)) {
1611             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1612         }
1613 
1614         Guard storage _guard = txKey2guard[_key];
1615         if (_guard.state != GuardState.InProcess) {
1616             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1617         }
1618 
1619         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1620         if (_votedGroupName == bytes32(0)) {
1621             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1622         }
1623 
1624         bool isAcceptedVote = _guard.votes[_user].accepted;
1625         if (isAcceptedVote) {
1626             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1627             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1628         } else {
1629             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1630             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1631 
1632         }
1633 
1634         delete _guard.votes[_user];
1635 
1636         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1637         return OK;
1638     }
1639 }
1640 
1641 /// @title MultiSigAdapter
1642 ///
1643 /// Abstract implementation
1644 /// This contract serves as transaction signer
1645 contract MultiSigAdapter is Object {
1646 
1647     uint constant MULTISIG_ADDED = 3;
1648     uint constant NO_RECORDS_WERE_FOUND = 4;
1649 
1650     modifier isAuthorized {
1651         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1652             _;
1653         }
1654     }
1655 
1656     /// @notice Get pending address
1657     /// @dev abstract. Needs child implementation
1658     ///
1659     /// @return pending address
1660     function getPendingManager() public view returns (address);
1661 
1662     /// @notice Sign current transaction and add it to transaction pending queue
1663     ///
1664     /// @return code
1665     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1666         bytes32 _txHash = _getKey(_args, _block);
1667         address _manager = getPendingManager();
1668 
1669         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1670         if (_code != NO_RECORDS_WERE_FOUND) {
1671             return _code;
1672         }
1673 
1674         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1675             revert();
1676         }
1677 
1678         return MULTISIG_ADDED;
1679     }
1680 
1681     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1682         bytes32 _txHash = _getKey(_args, _block);
1683         address _manager = getPendingManager();
1684         return PendingManager(_manager).isTxExist(_txHash);
1685     }
1686 
1687     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1688         _block = _block != 0 ? _block : block.number;
1689         _txHash = keccak256(msg.sig, _args, _block);
1690     }
1691 }
1692 
1693 /// @title ServiceController
1694 ///
1695 /// Base implementation
1696 /// Serves for managing service instances
1697 contract ServiceController is MultiSigAdapter {
1698 
1699     uint constant SERVICE_CONTROLLER = 350000;
1700     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1701     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1702     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1703     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1704 
1705     address public profiterole;
1706     address public treasury;
1707     address public pendingManager;
1708     address public proxy;
1709 
1710     mapping(address => bool) public sideServices;
1711     mapping(address => bool) emissionProviders;
1712     mapping(address => bool) burningMans;
1713 
1714     /// @notice Default ServiceController's constructor
1715     ///
1716     /// @param _pendingManager pending manager address
1717     /// @param _proxy ERC20 proxy address
1718     /// @param _profiterole profiterole address
1719     /// @param _treasury treasury address
1720     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1721         require(_pendingManager != 0x0);
1722         require(_proxy != 0x0);
1723         require(_profiterole != 0x0);
1724         require(_treasury != 0x0);
1725         pendingManager = _pendingManager;
1726         proxy = _proxy;
1727         profiterole = _profiterole;
1728         treasury = _treasury;
1729     }
1730 
1731     /// @notice Return pending manager address
1732     ///
1733     /// @return code
1734     function getPendingManager() public view returns (address) {
1735         return pendingManager;
1736     }
1737 
1738     /// @notice Add emission provider
1739     ///
1740     /// @param _provider emission provider address
1741     ///
1742     /// @return code
1743     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1744         if (emissionProviders[_provider]) {
1745             return SERVICE_CONTROLLER_EMISSION_EXIST;
1746         }
1747         _code = _multisig(keccak256(_provider), _block);
1748         if (OK != _code) {
1749             return _code;
1750         }
1751 
1752         emissionProviders[_provider] = true;
1753         return OK;
1754     }
1755 
1756     /// @notice Remove emission provider
1757     ///
1758     /// @param _provider emission provider address
1759     ///
1760     /// @return code
1761     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1762         _code = _multisig(keccak256(_provider), _block);
1763         if (OK != _code) {
1764             return _code;
1765         }
1766 
1767         delete emissionProviders[_provider];
1768         return OK;
1769     }
1770 
1771     /// @notice Add burning man
1772     ///
1773     /// @param _burningMan burning man address
1774     ///
1775     /// @return code
1776     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1777         if (burningMans[_burningMan]) {
1778             return SERVICE_CONTROLLER_BURNING_MAN_EXIST;
1779         }
1780 
1781         _code = _multisig(keccak256(_burningMan), _block);
1782         if (OK != _code) {
1783             return _code;
1784         }
1785 
1786         burningMans[_burningMan] = true;
1787         return OK;
1788     }
1789 
1790     /// @notice Remove burning man
1791     ///
1792     /// @param _burningMan burning man address
1793     ///
1794     /// @return code
1795     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1796         _code = _multisig(keccak256(_burningMan), _block);
1797         if (OK != _code) {
1798             return _code;
1799         }
1800 
1801         delete burningMans[_burningMan];
1802         return OK;
1803     }
1804 
1805     /// @notice Update a profiterole address
1806     ///
1807     /// @param _profiterole profiterole address
1808     ///
1809     /// @return result code of an operation
1810     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1811         _code = _multisig(keccak256(_profiterole), _block);
1812         if (OK != _code) {
1813             return _code;
1814         }
1815 
1816         profiterole = _profiterole;
1817         return OK;
1818     }
1819 
1820     /// @notice Update a treasury address
1821     ///
1822     /// @param _treasury treasury address
1823     ///
1824     /// @return result code of an operation
1825     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1826         _code = _multisig(keccak256(_treasury), _block);
1827         if (OK != _code) {
1828             return _code;
1829         }
1830 
1831         treasury = _treasury;
1832         return OK;
1833     }
1834 
1835     /// @notice Update pending manager address
1836     ///
1837     /// @param _pendingManager pending manager address
1838     ///
1839     /// @return result code of an operation
1840     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1841         _code = _multisig(keccak256(_pendingManager), _block);
1842         if (OK != _code) {
1843             return _code;
1844         }
1845 
1846         pendingManager = _pendingManager;
1847         return OK;
1848     }
1849 
1850     function addSideService(address _service, uint _block) public returns (uint _code) {
1851         if (sideServices[_service]) {
1852             return SERVICE_CONTROLLER_SERVICE_EXIST;
1853         }
1854         _code = _multisig(keccak256(_service), _block);
1855         if (OK != _code) {
1856             return _code;
1857         }
1858 
1859         sideServices[_service] = true;
1860         return OK;
1861     }
1862 
1863     function removeSideService(address _service, uint _block) public returns (uint _code) {
1864         _code = _multisig(keccak256(_service), _block);
1865         if (OK != _code) {
1866             return _code;
1867         }
1868 
1869         delete sideServices[_service];
1870         return OK;
1871     }
1872 
1873     /// @notice Check target address is service
1874     ///
1875     /// @param _address target address
1876     ///
1877     /// @return `true` when an address is a service, `false` otherwise
1878     function isService(address _address) public view returns (bool check) {
1879         return _address == profiterole ||
1880             _address == treasury || 
1881             _address == proxy || 
1882             _address == pendingManager || 
1883             emissionProviders[_address] || 
1884             burningMans[_address] ||
1885             sideServices[_address];
1886     }
1887 }
1888 
1889 /// @title Provides possibility manage holders? country limits and limits for holders.
1890 contract DataController is OracleMethodAdapter, DataControllerEmitter {
1891 
1892     /* CONSTANTS */
1893 
1894     uint constant DATA_CONTROLLER = 109000;
1895     uint constant DATA_CONTROLLER_ERROR = DATA_CONTROLLER + 1;
1896     uint constant DATA_CONTROLLER_CURRENT_WRONG_LIMIT = DATA_CONTROLLER + 2;
1897     uint constant DATA_CONTROLLER_WRONG_ALLOWANCE = DATA_CONTROLLER + 3;
1898     uint constant DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS = DATA_CONTROLLER + 4;
1899 
1900     uint constant MAX_TOKEN_HOLDER_NUMBER = 2 ** 256 - 1;
1901 
1902     using SafeMath for uint;
1903 
1904     /* STRUCTS */
1905 
1906     /// @title HoldersData couldn't be public because of internal structures, so needed to provide getters for different parts of _holderData
1907     struct HoldersData {
1908         uint countryCode;
1909         uint sendLimPerDay;
1910         uint sendLimPerMonth;
1911         bool operational;
1912         bytes text;
1913         uint holderAddressCount;
1914         mapping(uint => address) index2Address;
1915         mapping(address => uint) address2Index;
1916     }
1917 
1918     struct CountryLimits {
1919         uint countryCode;
1920         uint maxTokenHolderNumber;
1921         uint currentTokenHolderNumber;
1922     }
1923 
1924     /* FIELDS */
1925 
1926     address public withdrawal;
1927     address assetAddress;
1928     address public serviceController;
1929 
1930     mapping(address => uint) public allowance;
1931 
1932     // Iterable mapping pattern is used for holders.
1933     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
1934     uint public holdersCount;
1935     mapping(uint => HoldersData) holders;
1936     mapping(address => bytes32) holderAddress2Id;
1937     mapping(bytes32 => uint) public holderIndex;
1938 
1939     // This is an access address mapping. Many addresses may have access to a single holder.
1940     uint public countriesCount;
1941     mapping(uint => CountryLimits) countryLimitsList;
1942     mapping(uint => uint) countryIndex;
1943 
1944     /* MODIFIERS */
1945 
1946     modifier onlyWithdrawal {
1947         if (msg.sender != withdrawal) {
1948             revert();
1949         }
1950         _;
1951     }
1952 
1953     modifier onlyAsset {
1954         if (msg.sender == assetAddress) {
1955             _;
1956         }
1957     }
1958 
1959     modifier onlyContractOwner {
1960         if (msg.sender == contractOwner) {
1961             _;
1962         }
1963     }
1964 
1965     /// @notice Constructor for _holderData controller.
1966     /// @param _serviceController service controller
1967     function DataController(address _serviceController, address _asset) public {
1968         require(_serviceController != 0x0);
1969         require(_asset != 0x0);
1970 
1971         serviceController = _serviceController;
1972         assetAddress = _asset;
1973     }
1974 
1975     function() payable public {
1976         revert();
1977     }
1978 
1979     function setWithdraw(address _withdrawal) onlyContractOwner external returns (uint) {
1980         require(_withdrawal != 0x0);
1981         withdrawal = _withdrawal;
1982         return OK;
1983     }
1984 
1985 
1986     function getPendingManager() public view returns (address) {
1987         return ServiceController(serviceController).getPendingManager();
1988     }
1989 
1990     function getHolderInfo(bytes32 _externalHolderId) public view returns (
1991         uint _countryCode,
1992         uint _limPerDay,
1993         uint _limPerMonth,
1994         bool _operational,
1995         bytes _text
1996     ) {
1997         HoldersData storage _data = holders[holderIndex[_externalHolderId]];
1998         return (_data.countryCode, _data.sendLimPerDay, _data.sendLimPerMonth, _data.operational, _data.text);
1999     }
2000 
2001     function getHolderAddresses(bytes32 _externalHolderId) public view returns (address[] _addresses) {
2002         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2003         uint _addressesCount = _holderData.holderAddressCount;
2004         _addresses = new address[](_addressesCount);
2005         for (uint _holderAddressIdx = 0; _holderAddressIdx < _addressesCount; ++_holderAddressIdx) {
2006             _addresses[_holderAddressIdx] = _holderData.index2Address[_holderAddressIdx + 1];
2007         }
2008     }
2009 
2010     function getHolderCountryCode(bytes32 _externalHolderId) public view returns (uint) {
2011         return holders[holderIndex[_externalHolderId]].countryCode;
2012     }
2013 
2014     function getHolderExternalIdByAddress(address _address) public view returns (bytes32) {
2015         return holderAddress2Id[_address];
2016     }
2017 
2018     /// @notice Checks user is holder.
2019     /// @param _address checking address.
2020     /// @return `true` if _address is registered holder, `false` otherwise.
2021     function isRegisteredAddress(address _address) public view returns (bool) {
2022         return holderIndex[holderAddress2Id[_address]] != 0;
2023     }
2024 
2025     function isHolderOwnAddress(
2026         bytes32 _externalHolderId, 
2027         address _address
2028     ) 
2029     public 
2030     view 
2031     returns (bool) 
2032     {
2033         uint _holderIndex = holderIndex[_externalHolderId];
2034         if (_holderIndex == 0) {
2035             return false;
2036         }
2037         return holders[_holderIndex].address2Index[_address] != 0;
2038     }
2039 
2040     function getCountryInfo(uint _countryCode) 
2041     public 
2042     view 
2043     returns (
2044         uint _maxHolderNumber, 
2045         uint _currentHolderCount
2046     ) {
2047         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2048         return (_data.maxTokenHolderNumber, _data.currentTokenHolderNumber);
2049     }
2050 
2051     function getCountryLimit(uint _countryCode) public view returns (uint limit) {
2052         uint _index = countryIndex[_countryCode];
2053         require(_index != 0);
2054         return countryLimitsList[_index].maxTokenHolderNumber;
2055     }
2056 
2057     function addCountryCode(uint _countryCode) onlyContractOwner public returns (uint) {
2058         var (,_created) = _createCountryId(_countryCode);
2059         if (!_created) {
2060             return _emitError(DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS);
2061         }
2062         return OK;
2063     }
2064 
2065     /// @notice Returns holder id for the specified address, creates it if needed.
2066     /// @param _externalHolderId holder address.
2067     /// @param _countryCode country code.
2068     /// @return error code.
2069     function registerHolder(
2070         bytes32 _externalHolderId, 
2071         address _holderAddress, 
2072         uint _countryCode
2073     ) 
2074     onlyOracleOrOwner 
2075     external 
2076     returns (uint) 
2077     {
2078         require(_holderAddress != 0x0);
2079         require(holderIndex[_externalHolderId] == 0);
2080         uint _holderIndex = holderIndex[holderAddress2Id[_holderAddress]];
2081         require(_holderIndex == 0);
2082 
2083         _createCountryId(_countryCode);
2084         _holderIndex = holdersCount.add(1);
2085         holdersCount = _holderIndex;
2086 
2087         HoldersData storage _holderData = holders[_holderIndex];
2088         _holderData.countryCode = _countryCode;
2089         _holderData.operational = true;
2090         _holderData.sendLimPerDay = MAX_TOKEN_HOLDER_NUMBER;
2091         _holderData.sendLimPerMonth = MAX_TOKEN_HOLDER_NUMBER;
2092         uint _firstAddressIndex = 1;
2093         _holderData.holderAddressCount = _firstAddressIndex;
2094         _holderData.address2Index[_holderAddress] = _firstAddressIndex;
2095         _holderData.index2Address[_firstAddressIndex] = _holderAddress;
2096         holderIndex[_externalHolderId] = _holderIndex;
2097         holderAddress2Id[_holderAddress] = _externalHolderId;
2098 
2099         _emitHolderRegistered(_externalHolderId, _holderIndex, _countryCode);
2100         return OK;
2101     }
2102 
2103     /// @notice Adds new address equivalent to holder.
2104     /// @param _externalHolderId external holder identifier.
2105     /// @param _newAddress adding address.
2106     /// @return error code.
2107     function addHolderAddress(
2108         bytes32 _externalHolderId, 
2109         address _newAddress
2110     ) 
2111     onlyOracleOrOwner 
2112     external 
2113     returns (uint) 
2114     {
2115         uint _holderIndex = holderIndex[_externalHolderId];
2116         require(_holderIndex != 0);
2117 
2118         uint _newAddressId = holderIndex[holderAddress2Id[_newAddress]];
2119         require(_newAddressId == 0);
2120 
2121         HoldersData storage _holderData = holders[_holderIndex];
2122 
2123         if (_holderData.address2Index[_newAddress] == 0) {
2124             _holderData.holderAddressCount = _holderData.holderAddressCount.add(1);
2125             _holderData.address2Index[_newAddress] = _holderData.holderAddressCount;
2126             _holderData.index2Address[_holderData.holderAddressCount] = _newAddress;
2127         }
2128 
2129         holderAddress2Id[_newAddress] = _externalHolderId;
2130 
2131         _emitHolderAddressAdded(_externalHolderId, _newAddress, _holderIndex);
2132         return OK;
2133     }
2134 
2135     /// @notice Remove an address owned by a holder.
2136     /// @param _externalHolderId external holder identifier.
2137     /// @param _address removing address.
2138     /// @return error code.
2139     function removeHolderAddress(
2140         bytes32 _externalHolderId, 
2141         address _address
2142     ) 
2143     onlyOracleOrOwner 
2144     external 
2145     returns (uint) 
2146     {
2147         uint _holderIndex = holderIndex[_externalHolderId];
2148         require(_holderIndex != 0);
2149 
2150         HoldersData storage _holderData = holders[_holderIndex];
2151 
2152         uint _tempIndex = _holderData.address2Index[_address];
2153         require(_tempIndex != 0);
2154 
2155         address _lastAddress = _holderData.index2Address[_holderData.holderAddressCount];
2156         _holderData.address2Index[_lastAddress] = _tempIndex;
2157         _holderData.index2Address[_tempIndex] = _lastAddress;
2158         delete _holderData.address2Index[_address];
2159         _holderData.holderAddressCount = _holderData.holderAddressCount.sub(1);
2160 
2161         delete holderAddress2Id[_address];
2162 
2163         _emitHolderAddressRemoved(_externalHolderId, _address, _holderIndex);
2164         return OK;
2165     }
2166 
2167     /// @notice Change operational status for holder.
2168     /// Can be accessed by contract owner or oracle only.
2169     ///
2170     /// @param _externalHolderId external holder identifier.
2171     /// @param _operational operational status.
2172     ///
2173     /// @return result code.
2174     function changeOperational(
2175         bytes32 _externalHolderId, 
2176         bool _operational
2177     ) 
2178     onlyOracleOrOwner 
2179     external 
2180     returns (uint) 
2181     {
2182         uint _holderIndex = holderIndex[_externalHolderId];
2183         require(_holderIndex != 0);
2184 
2185         holders[_holderIndex].operational = _operational;
2186 
2187         _emitHolderOperationalChanged(_externalHolderId, _operational);
2188         return OK;
2189     }
2190 
2191     /// @notice Changes text for holder.
2192     /// Can be accessed by contract owner or oracle only.
2193     ///
2194     /// @param _externalHolderId external holder identifier.
2195     /// @param _text changing text.
2196     ///
2197     /// @return result code.
2198     function updateTextForHolder(
2199         bytes32 _externalHolderId, 
2200         bytes _text
2201     ) 
2202     onlyOracleOrOwner 
2203     external 
2204     returns (uint) 
2205     {
2206         uint _holderIndex = holderIndex[_externalHolderId];
2207         require(_holderIndex != 0);
2208 
2209         holders[_holderIndex].text = _text;
2210         return OK;
2211     }
2212 
2213     /// @notice Updates limit per day for holder.
2214     ///
2215     /// Can be accessed by contract owner only.
2216     ///
2217     /// @param _externalHolderId external holder identifier.
2218     /// @param _limit limit value.
2219     ///
2220     /// @return result code.
2221     function updateLimitPerDay(
2222         bytes32 _externalHolderId, 
2223         uint _limit
2224     ) 
2225     onlyOracleOrOwner 
2226     external 
2227     returns (uint) 
2228     {
2229         uint _holderIndex = holderIndex[_externalHolderId];
2230         require(_holderIndex != 0);
2231 
2232         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2233         holders[_holderIndex].sendLimPerDay = _limit;
2234 
2235         _emitDayLimitChanged(_externalHolderId, _currentLimit, _limit);
2236         return OK;
2237     }
2238 
2239     /// @notice Updates limit per month for holder.
2240     /// Can be accessed by contract owner or oracle only.
2241     ///
2242     /// @param _externalHolderId external holder identifier.
2243     /// @param _limit limit value.
2244     ///
2245     /// @return result code.
2246     function updateLimitPerMonth(
2247         bytes32 _externalHolderId, 
2248         uint _limit
2249     ) 
2250     onlyOracleOrOwner 
2251     external 
2252     returns (uint) 
2253     {
2254         uint _holderIndex = holderIndex[_externalHolderId];
2255         require(_holderIndex != 0);
2256 
2257         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2258         holders[_holderIndex].sendLimPerMonth = _limit;
2259 
2260         _emitMonthLimitChanged(_externalHolderId, _currentLimit, _limit);
2261         return OK;
2262     }
2263 
2264     /// @notice Change country limits.
2265     /// Can be accessed by contract owner or oracle only.
2266     ///
2267     /// @param _countryCode country code.
2268     /// @param _limit limit value.
2269     ///
2270     /// @return result code.
2271     function changeCountryLimit(
2272         uint _countryCode, 
2273         uint _limit
2274     ) 
2275     onlyOracleOrOwner 
2276     external 
2277     returns (uint) 
2278     {
2279         uint _countryIndex = countryIndex[_countryCode];
2280         require(_countryIndex != 0);
2281 
2282         uint _currentTokenHolderNumber = countryLimitsList[_countryIndex].currentTokenHolderNumber;
2283         if (_currentTokenHolderNumber > _limit) {
2284             return DATA_CONTROLLER_CURRENT_WRONG_LIMIT;
2285         }
2286 
2287         countryLimitsList[_countryIndex].maxTokenHolderNumber = _limit;
2288         
2289         _emitCountryCodeChanged(_countryIndex, _countryCode, _limit);
2290         return OK;
2291     }
2292 
2293     function withdrawFrom(
2294         address _holderAddress, 
2295         uint _value
2296     ) 
2297     onlyAsset 
2298     public 
2299     returns (uint) 
2300     {
2301         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2302         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2303         _holderData.sendLimPerDay = _holderData.sendLimPerDay.sub(_value);
2304         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.sub(_value);
2305         return OK;
2306     }
2307 
2308     function depositTo(
2309         address _holderAddress, 
2310         uint _value
2311     ) 
2312     onlyAsset 
2313     public 
2314     returns (uint) 
2315     {
2316         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2317         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2318         _holderData.sendLimPerDay = _holderData.sendLimPerDay.add(_value);
2319         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.add(_value);
2320         return OK;
2321     }
2322 
2323     function updateCountryHoldersCount(
2324         uint _countryCode, 
2325         uint _updatedHolderCount
2326     ) 
2327     public 
2328     onlyAsset 
2329     returns (uint) 
2330     {
2331         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2332         assert(_data.maxTokenHolderNumber >= _updatedHolderCount);
2333         _data.currentTokenHolderNumber = _updatedHolderCount;
2334         return OK;
2335     }
2336 
2337     function changeAllowance(address _from, uint _value) public onlyWithdrawal returns (uint) {
2338         ServiceController _serviceController = ServiceController(serviceController);
2339         ATxAssetProxy token = ATxAssetProxy(_serviceController.proxy());
2340         if (token.balanceOf(_from) < _value) {
2341             return DATA_CONTROLLER_WRONG_ALLOWANCE;
2342         }
2343         allowance[_from] = _value;
2344         return OK;
2345     }
2346 
2347     function _createCountryId(uint _countryCode) internal returns (uint, bool _created) {
2348         uint countryId = countryIndex[_countryCode];
2349         if (countryId == 0) {
2350             uint _countriesCount = countriesCount;
2351             countryId = _countriesCount.add(1);
2352             countriesCount = countryId;
2353             CountryLimits storage limits = countryLimitsList[countryId];
2354             limits.countryCode = _countryCode;
2355             limits.maxTokenHolderNumber = MAX_TOKEN_HOLDER_NUMBER;
2356 
2357             countryIndex[_countryCode] = countryId;
2358             _emitCountryCodeAdded(countryIndex[_countryCode], _countryCode, MAX_TOKEN_HOLDER_NUMBER);
2359 
2360             _created = true;
2361         }
2362 
2363         return (countryId, _created);
2364     }
2365 }
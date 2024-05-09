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
170     function addOracles(bytes4[] _signatures, address[] _oracles) onlyContractOwner external returns (uint) {
171         require(_signatures.length == _oracles.length);
172         bytes4 _sig;
173         address _oracle;
174         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
175             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
176             if (!oracles[_sig][_oracle]) {
177                 oracles[_sig][_oracle] = true;
178                 _emitOracleAdded(_sig, _oracle);
179             }
180         }
181         return OK;
182     }
183 
184     function removeOracles(bytes4[] _signatures, address[] _oracles) onlyContractOwner external returns (uint) {
185         require(_signatures.length == _oracles.length);
186         bytes4 _sig;
187         address _oracle;
188         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
189             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
190             if (oracles[_sig][_oracle]) {
191                 delete oracles[_sig][_oracle];
192                 _emitOracleRemoved(_sig, _oracle);
193             }
194         }
195         return OK;
196     }
197 
198     function _emitOracleAdded(bytes4 _sig, address _oracle) internal {
199         OracleAdded(_sig, _oracle);
200     }
201 
202     function _emitOracleRemoved(bytes4 _sig, address _oracle) internal {
203         OracleRemoved(_sig, _oracle);
204     }
205 
206 }
207 
208 /// @title Provides possibility manage holders? country limits and limits for holders.
209 contract DataControllerInterface {
210 
211     /// @notice Checks user is holder.
212     /// @param _address - checking address.
213     /// @return `true` if _address is registered holder, `false` otherwise.
214     function isHolderAddress(address _address) public view returns (bool);
215 
216     function allowance(address _user) public view returns (uint);
217 
218     function changeAllowance(address _holder, uint _value) public returns (uint);
219 }
220 
221 /// @title ServiceController
222 ///
223 /// Base implementation
224 /// Serves for managing service instances
225 contract ServiceControllerInterface {
226 
227     /// @notice Check target address is service
228     /// @param _address target address
229     /// @return `true` when an address is a service, `false` otherwise
230     function isService(address _address) public view returns (bool);
231 }
232 
233 contract ATxAssetInterface {
234 
235     DataControllerInterface public dataController;
236     ServiceControllerInterface public serviceController;
237 
238     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
239     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
240     function __approve(address _spender, uint _value, address _sender) public returns (bool);
241     function __process(bytes /*_data*/, address /*_sender*/) payable public {
242         revert();
243     }
244 }
245 
246 /// @title ServiceAllowance.
247 ///
248 /// Provides a way to delegate operation allowance decision to a service contract
249 contract ServiceAllowance {
250     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
251 }
252 
253 contract ERC20 {
254     event Transfer(address indexed from, address indexed to, uint256 value);
255     event Approval(address indexed from, address indexed spender, uint256 value);
256     string public symbol;
257 
258     function totalSupply() constant returns (uint256 supply);
259     function balanceOf(address _owner) constant returns (uint256 balance);
260     function transfer(address _to, uint256 _value) returns (bool success);
261     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
262     function approve(address _spender, uint256 _value) returns (bool success);
263     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
264 }
265 
266 
267 
268 contract Platform {
269     mapping(bytes32 => address) public proxies;
270     function name(bytes32 _symbol) public view returns (string);
271     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
272     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
273     function totalSupply(bytes32 _symbol) public view returns (uint);
274     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
275     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
276     function baseUnit(bytes32 _symbol) public view returns (uint8);
277     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
278     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
279     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
280     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
281     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
282     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
283     function isReissuable(bytes32 _symbol) public view returns (bool);
284     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
285 }
286 
287 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
288 
289     // Timespan for users to review the new implementation and make decision.
290     uint constant UPGRADE_FREEZE_TIME = 3 days;
291 
292     using SafeMath for uint;
293 
294     /**
295      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
296      */
297     event UpgradeProposal(address newVersion);
298 
299     // Current asset implementation contract address.
300     address latestVersion;
301 
302     // Proposed next asset implementation contract address.
303     address pendingVersion;
304 
305     // Upgrade freeze-time start.
306     uint pendingVersionTimestamp;
307 
308     // Assigned platform, immutable.
309     Platform public platform;
310 
311     // Assigned symbol, immutable.
312     bytes32 public smbl;
313 
314     // Assigned name, immutable.
315     string public name;
316 
317     /**
318      * Only platform is allowed to call.
319      */
320     modifier onlyPlatform() {
321         if (msg.sender == address(platform)) {
322             _;
323         }
324     }
325 
326     /**
327      * Only current asset owner is allowed to call.
328      */
329     modifier onlyAssetOwner() {
330         if (platform.isOwner(msg.sender, smbl)) {
331             _;
332         }
333     }
334 
335     /**
336      * Only asset implementation contract assigned to sender is allowed to call.
337      */
338     modifier onlyAccess(address _sender) {
339         if (getLatestVersion() == msg.sender) {
340             _;
341         }
342     }
343 
344     /**
345      * Resolves asset implementation contract for the caller and forwards there transaction data,
346      * along with the value. This allows for proxy interface growth.
347      */
348     function() public payable {
349         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
350     }
351 
352     /**
353      * Sets platform address, assigns symbol and name.
354      *
355      * Can be set only once.
356      *
357      * @param _platform platform contract address.
358      * @param _symbol assigned symbol.
359      * @param _name assigned name.
360      *
361      * @return success.
362      */
363     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
364         if (address(platform) != 0x0) {
365             return false;
366         }
367         platform = _platform;
368         symbol = _symbol;
369         smbl = stringToBytes32(_symbol);
370         name = _name;
371         return true;
372     }
373 
374     /**
375      * Returns asset total supply.
376      *
377      * @return asset total supply.
378      */
379     function totalSupply() public view returns (uint) {
380         return platform.totalSupply(smbl);
381     }
382 
383     /**
384      * Returns asset balance for a particular holder.
385      *
386      * @param _owner holder address.
387      *
388      * @return holder balance.
389      */
390     function balanceOf(address _owner) public view returns (uint) {
391         return platform.balanceOf(_owner, smbl);
392     }
393 
394     /**
395      * Returns asset allowance from one holder to another.
396      *
397      * @param _from holder that allowed spending.
398      * @param _spender holder that is allowed to spend.
399      *
400      * @return holder to spender allowance.
401      */
402     function allowance(address _from, address _spender) public view returns (uint) {
403         return platform.allowance(_from, _spender, smbl);
404     }
405 
406     /**
407      * Returns asset decimals.
408      *
409      * @return asset decimals.
410      */
411     function decimals() public view returns (uint8) {
412         return platform.baseUnit(smbl);
413     }
414 
415     /**
416      * Transfers asset balance from the caller to specified receiver.
417      *
418      * @param _to holder address to give to.
419      * @param _value amount to transfer.
420      *
421      * @return success.
422      */
423     function transfer(address _to, uint _value) public returns (bool) {
424         if (_to != 0x0) {
425             return _transferWithReference(_to, _value, "");
426         }
427         else {
428             return false;
429         }
430     }
431 
432     /**
433      * Transfers asset balance from the caller to specified receiver adding specified comment.
434      *
435      * @param _to holder address to give to.
436      * @param _value amount to transfer.
437      * @param _reference transfer comment to be included in a platform's Transfer event.
438      *
439      * @return success.
440      */
441     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
442         if (_to != 0x0) {
443             return _transferWithReference(_to, _value, _reference);
444         }
445         else {
446             return false;
447         }
448     }
449 
450     /**
451      * Performs transfer call on the platform by the name of specified sender.
452      *
453      * Can only be called by asset implementation contract assigned to sender.
454      *
455      * @param _to holder address to give to.
456      * @param _value amount to transfer.
457      * @param _reference transfer comment to be included in a platform's Transfer event.
458      * @param _sender initial caller.
459      *
460      * @return success.
461      */
462     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
463         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
464     }
465 
466     /**
467      * Prforms allowance transfer of asset balance between holders.
468      *
469      * @param _from holder address to take from.
470      * @param _to holder address to give to.
471      * @param _value amount to transfer.
472      *
473      * @return success.
474      */
475     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
476         if (_to != 0x0) {
477             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
478         }
479         else {
480             return false;
481         }
482     }
483 
484     /**
485      * Performs allowance transfer call on the platform by the name of specified sender.
486      *
487      * Can only be called by asset implementation contract assigned to sender.
488      *
489      * @param _from holder address to take from.
490      * @param _to holder address to give to.
491      * @param _value amount to transfer.
492      * @param _reference transfer comment to be included in a platform's Transfer event.
493      * @param _sender initial caller.
494      *
495      * @return success.
496      */
497     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
498         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
499     }
500 
501     /**
502      * Sets asset spending allowance for a specified spender.
503      *
504      * @param _spender holder address to set allowance to.
505      * @param _value amount to allow.
506      *
507      * @return success.
508      */
509     function approve(address _spender, uint _value) public returns (bool) {
510         if (_spender != 0x0) {
511             return _getAsset().__approve(_spender, _value, msg.sender);
512         }
513         else {
514             return false;
515         }
516     }
517 
518     /**
519      * Performs allowance setting call on the platform by the name of specified sender.
520      *
521      * Can only be called by asset implementation contract assigned to sender.
522      *
523      * @param _spender holder address to set allowance to.
524      * @param _value amount to allow.
525      * @param _sender initial caller.
526      *
527      * @return success.
528      */
529     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
530         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
531     }
532 
533     /**
534      * Emits ERC20 Transfer event on this contract.
535      *
536      * Can only be, and, called by assigned platform when asset transfer happens.
537      */
538     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
539         Transfer(_from, _to, _value);
540     }
541 
542     /**
543      * Emits ERC20 Approval event on this contract.
544      *
545      * Can only be, and, called by assigned platform when asset allowance set happens.
546      */
547     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
548         Approval(_from, _spender, _value);
549     }
550 
551     /**
552      * Returns current asset implementation contract address.
553      *
554      * @return asset implementation contract address.
555      */
556     function getLatestVersion() public view returns (address) {
557         return latestVersion;
558     }
559 
560     /**
561      * Returns proposed next asset implementation contract address.
562      *
563      * @return asset implementation contract address.
564      */
565     function getPendingVersion() public view returns (address) {
566         return pendingVersion;
567     }
568 
569     /**
570      * Returns upgrade freeze-time start.
571      *
572      * @return freeze-time start.
573      */
574     function getPendingVersionTimestamp() public view returns (uint) {
575         return pendingVersionTimestamp;
576     }
577 
578     /**
579      * Propose next asset implementation contract address.
580      *
581      * Can only be called by current asset owner.
582      *
583      * Note: freeze-time should not be applied for the initial setup.
584      *
585      * @param _newVersion asset implementation contract address.
586      *
587      * @return success.
588      */
589     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
590         // Should not already be in the upgrading process.
591         if (pendingVersion != 0x0) {
592             return false;
593         }
594         // New version address should be other than 0x0.
595         if (_newVersion == 0x0) {
596             return false;
597         }
598         // Don't apply freeze-time for the initial setup.
599         if (latestVersion == 0x0) {
600             latestVersion = _newVersion;
601             return true;
602         }
603         pendingVersion = _newVersion;
604         pendingVersionTimestamp = now;
605         UpgradeProposal(_newVersion);
606         return true;
607     }
608 
609     /**
610      * Cancel the pending upgrade process.
611      *
612      * Can only be called by current asset owner.
613      *
614      * @return success.
615      */
616     function purgeUpgrade() public onlyAssetOwner returns (bool) {
617         if (pendingVersion == 0x0) {
618             return false;
619         }
620         delete pendingVersion;
621         delete pendingVersionTimestamp;
622         return true;
623     }
624 
625     /**
626      * Finalize an upgrade process setting new asset implementation contract address.
627      *
628      * Can only be called after an upgrade freeze-time.
629      *
630      * @return success.
631      */
632     function commitUpgrade() public returns (bool) {
633         if (pendingVersion == 0x0) {
634             return false;
635         }
636         if (pendingVersionTimestamp.add(UPGRADE_FREEZE_TIME) > now) {
637             return false;
638         }
639         latestVersion = pendingVersion;
640         delete pendingVersion;
641         delete pendingVersionTimestamp;
642         return true;
643     }
644 
645     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
646         return true;
647     }
648 
649     /**
650      * Returns asset implementation contract for current caller.
651      *
652      * @return asset implementation contract.
653      */
654     function _getAsset() internal view returns (ATxAssetInterface) {
655         return ATxAssetInterface(getLatestVersion());
656     }
657 
658     /**
659      * Resolves asset implementation contract for the caller and forwards there arguments along with
660      * the caller address.
661      *
662      * @return success.
663      */
664     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
665         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
666     }
667 
668     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
669         assembly {
670             result := mload(add(source, 32))
671         }
672     }
673 }
674 
675 contract DataControllerEmitter {
676 
677     event CountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount);
678     event CountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount);
679 
680     event HolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode);
681     event HolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
682     event HolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
683     event HolderOperationalChanged(bytes32 _externalHolderId, bool _operational);
684 
685     event DayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
686     event MonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
687 
688     event Error(uint _errorCode);
689 
690     function _emitHolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
691         HolderAddressAdded(_externalHolderId, _holderPrototype, _accessIndex);
692     }
693 
694     function _emitHolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
695         HolderAddressRemoved(_externalHolderId, _holderPrototype, _accessIndex);
696     }
697 
698     function _emitHolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode) internal {
699         HolderRegistered(_externalHolderId, _accessIndex, _countryCode);
700     }
701 
702     function _emitHolderOperationalChanged(bytes32 _externalHolderId, bool _operational) internal {
703         HolderOperationalChanged(_externalHolderId, _operational);
704     }
705 
706     function _emitCountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
707         CountryCodeAdded(_countryCode, _countryId, _maxHolderCount);
708     }
709 
710     function _emitCountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
711         CountryCodeChanged(_countryCode, _countryId, _maxHolderCount);
712     }
713 
714     function _emitDayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
715         DayLimitChanged(_externalHolderId, _from, _to);
716     }
717 
718     function _emitMonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
719         MonthLimitChanged(_externalHolderId, _from, _to);
720     }
721 
722     function _emitError(uint _errorCode) internal returns (uint) {
723         Error(_errorCode);
724         return _errorCode;
725     }
726 }
727 
728 contract GroupsAccessManagerEmitter {
729 
730     event UserCreated(address user);
731     event UserDeleted(address user);
732     event GroupCreated(bytes32 groupName);
733     event GroupActivated(bytes32 groupName);
734     event GroupDeactivated(bytes32 groupName);
735     event UserToGroupAdded(address user, bytes32 groupName);
736     event UserFromGroupRemoved(address user, bytes32 groupName);
737 }
738 
739 /// @title Group Access Manager
740 ///
741 /// Base implementation
742 /// This contract serves as group manager
743 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
744 
745     uint constant USER_MANAGER_SCOPE = 111000;
746     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
747     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
748     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
749     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
750     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
751     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
752     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
753     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
754     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
755 
756     using SafeMath for uint;
757 
758     struct Member {
759         address addr;
760         uint groupsCount;
761         mapping(bytes32 => uint) groupName2index;
762         mapping(uint => uint) index2globalIndex;
763     }
764 
765     struct Group {
766         bytes32 name;
767         uint priority;
768         uint membersCount;
769         mapping(address => uint) memberAddress2index;
770         mapping(uint => uint) index2globalIndex;
771     }
772 
773     uint public membersCount;
774     mapping(uint => address) index2memberAddress;
775     mapping(address => uint) memberAddress2index;
776     mapping(address => Member) address2member;
777 
778     uint public groupsCount;
779     mapping(uint => bytes32) index2groupName;
780     mapping(bytes32 => uint) groupName2index;
781     mapping(bytes32 => Group) groupName2group;
782     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
783 
784     function() payable public {
785         revert();
786     }
787 
788     /// @notice Register user
789     /// Can be called only by contract owner
790     ///
791     /// @param _user user address
792     ///
793     /// @return code
794     function registerUser(address _user) external onlyContractOwner returns (uint) {
795         require(_user != 0x0);
796 
797         if (isRegisteredUser(_user)) {
798             return USER_MANAGER_MEMBER_ALREADY_EXIST;
799         }
800 
801         uint _membersCount = membersCount.add(1);
802         membersCount = _membersCount;
803         memberAddress2index[_user] = _membersCount;
804         index2memberAddress[_membersCount] = _user;
805         address2member[_user] = Member(_user, 0);
806 
807         UserCreated(_user);
808         return OK;
809     }
810 
811     /// @notice Discard user registration
812     /// Can be called only by contract owner
813     ///
814     /// @param _user user address
815     ///
816     /// @return code
817     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
818         require(_user != 0x0);
819 
820         uint _memberIndex = memberAddress2index[_user];
821         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
822             return USER_MANAGER_INVALID_INVOCATION;
823         }
824 
825         uint _membersCount = membersCount;
826         delete memberAddress2index[_user];
827         if (_memberIndex != _membersCount) {
828             address _lastUser = index2memberAddress[_membersCount];
829             index2memberAddress[_memberIndex] = _lastUser;
830             memberAddress2index[_lastUser] = _memberIndex;
831         }
832         delete address2member[_user];
833         delete index2memberAddress[_membersCount];
834         delete memberAddress2index[_user];
835         membersCount = _membersCount.sub(1);
836 
837         UserDeleted(_user);
838         return OK;
839     }
840 
841     /// @notice Create group
842     /// Can be called only by contract owner
843     ///
844     /// @param _groupName group name
845     /// @param _priority group priority
846     ///
847     /// @return code
848     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
849         require(_groupName != bytes32(0));
850 
851         if (isGroupExists(_groupName)) {
852             return USER_MANAGER_GROUP_ALREADY_EXIST;
853         }
854 
855         uint _groupsCount = groupsCount.add(1);
856         groupName2index[_groupName] = _groupsCount;
857         index2groupName[_groupsCount] = _groupName;
858         groupName2group[_groupName] = Group(_groupName, _priority, 0);
859         groupsCount = _groupsCount;
860 
861         GroupCreated(_groupName);
862         return OK;
863     }
864 
865     /// @notice Change group status
866     /// Can be called only by contract owner
867     ///
868     /// @param _groupName group name
869     /// @param _blocked block status
870     ///
871     /// @return code
872     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
873         require(isGroupExists(_groupName));
874         groupsBlocked[_groupName] = _blocked;
875         return OK;
876     }
877 
878     /// @notice Add users in group
879     /// Can be called only by contract owner
880     ///
881     /// @param _groupName group name
882     /// @param _users user array
883     ///
884     /// @return code
885     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
886         require(isGroupExists(_groupName));
887 
888         Group storage _group = groupName2group[_groupName];
889         uint _groupMembersCount = _group.membersCount;
890 
891         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
892             address _user = _users[_userIdx];
893             uint _memberIndex = memberAddress2index[_user];
894             require(_memberIndex != 0);
895 
896             if (_group.memberAddress2index[_user] != 0) {
897                 continue;
898             }
899 
900             _groupMembersCount = _groupMembersCount.add(1);
901             _group.memberAddress2index[_user] = _groupMembersCount;
902             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
903 
904             _addGroupToMember(_user, _groupName);
905 
906             UserToGroupAdded(_user, _groupName);
907         }
908         _group.membersCount = _groupMembersCount;
909 
910         return OK;
911     }
912 
913     /// @notice Remove users in group
914     /// Can be called only by contract owner
915     ///
916     /// @param _groupName group name
917     /// @param _users user array
918     ///
919     /// @return code
920     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
921         require(isGroupExists(_groupName));
922 
923         Group storage _group = groupName2group[_groupName];
924         uint _groupMembersCount = _group.membersCount;
925 
926         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
927             address _user = _users[_userIdx];
928             uint _memberIndex = memberAddress2index[_user];
929             uint _groupMemberIndex = _group.memberAddress2index[_user];
930 
931             if (_memberIndex == 0 || _groupMemberIndex == 0) {
932                 continue;
933             }
934 
935             if (_groupMemberIndex != _groupMembersCount) {
936                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
937                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
938                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
939                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
940             }
941             delete _group.memberAddress2index[_user];
942             delete _group.index2globalIndex[_groupMembersCount];
943             _groupMembersCount = _groupMembersCount.sub(1);
944 
945             _removeGroupFromMember(_user, _groupName);
946 
947             UserFromGroupRemoved(_user, _groupName);
948         }
949         _group.membersCount = _groupMembersCount;
950 
951         return OK;
952     }
953 
954     /// @notice Check is user registered
955     ///
956     /// @param _user user address
957     ///
958     /// @return status
959     function isRegisteredUser(address _user) public view returns (bool) {
960         return memberAddress2index[_user] != 0;
961     }
962 
963     /// @notice Check is user in group
964     ///
965     /// @param _groupName user array
966     /// @param _user user array
967     ///
968     /// @return status
969     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
970         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
971     }
972 
973     /// @notice Check is group exist
974     ///
975     /// @param _groupName group name
976     ///
977     /// @return status
978     function isGroupExists(bytes32 _groupName) public view returns (bool) {
979         return groupName2index[_groupName] != 0;
980     }
981 
982     /// @notice Get current group names
983     ///
984     /// @return group names
985     function getGroups() public view returns (bytes32[] _groups) {
986         uint _groupsCount = groupsCount;
987         _groups = new bytes32[](_groupsCount);
988         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
989             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
990         }
991     }
992 
993     // PRIVATE
994 
995     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
996         Member storage _member = address2member[_user];
997         uint _memberGroupsCount = _member.groupsCount;
998         uint _memberGroupIndex = _member.groupName2index[_groupName];
999         if (_memberGroupIndex != _memberGroupsCount) {
1000             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
1001             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
1002             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
1003             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
1004         }
1005         delete _member.groupName2index[_groupName];
1006         delete _member.index2globalIndex[_memberGroupsCount];
1007         _member.groupsCount = _memberGroupsCount.sub(1);
1008     }
1009 
1010     function _addGroupToMember(address _user, bytes32 _groupName) private {
1011         Member storage _member = address2member[_user];
1012         uint _memberGroupsCount = _member.groupsCount.add(1);
1013         _member.groupName2index[_groupName] = _memberGroupsCount;
1014         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
1015         _member.groupsCount = _memberGroupsCount;
1016     }
1017 }
1018 
1019 contract PendingManagerEmitter {
1020 
1021     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
1022     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
1023 
1024     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
1025     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1026     event ProtectionTxDone(bytes32 key);
1027     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1028     event ProtectionTxCancelled(bytes32 key);
1029     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
1030     event TxDeleted(bytes32 key);
1031 
1032     event Error(uint errorCode);
1033 
1034     function _emitError(uint _errorCode) internal returns (uint) {
1035         Error(_errorCode);
1036         return _errorCode;
1037     }
1038 }
1039 
1040 contract PendingManagerInterface {
1041 
1042     function signIn(address _contract) external returns (uint);
1043     function signOut(address _contract) external returns (uint);
1044 
1045     function addPolicyRule(
1046         bytes4 _sig, 
1047         address _contract, 
1048         bytes32 _groupName, 
1049         uint _acceptLimit, 
1050         uint _declineLimit 
1051         ) 
1052         external returns (uint);
1053         
1054     function removePolicyRule(
1055         bytes4 _sig, 
1056         address _contract, 
1057         bytes32 _groupName
1058         ) 
1059         external returns (uint);
1060 
1061     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
1062     function deleteTx(bytes32 _key) external returns (uint);
1063 
1064     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1065     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1066     function revoke(bytes32 _key) external returns (uint);
1067 
1068     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
1069     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
1070         bytes32[] _groupNames,
1071         uint[] _acceptLimits,
1072         uint[] _declineLimits,
1073         uint _totalAcceptedLimit,
1074         uint _totalDeclinedLimit
1075         );
1076 }
1077 
1078 /// @title PendingManager
1079 ///
1080 /// Base implementation
1081 /// This contract serves as pending manager for transaction status
1082 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
1083 
1084     uint constant NO_RECORDS_WERE_FOUND = 4;
1085     uint constant PENDING_MANAGER_SCOPE = 4000;
1086     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
1087     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
1088     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
1089     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
1090     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
1091     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
1092     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
1093     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
1094     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
1095     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
1096     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
1097 
1098     using SafeMath for uint;
1099 
1100     enum GuardState {
1101         Decline, Confirmed, InProcess
1102     }
1103 
1104     struct Requirements {
1105         bytes32 groupName;
1106         uint acceptLimit;
1107         uint declineLimit;
1108     }
1109 
1110     struct Policy {
1111         uint groupsCount;
1112         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
1113         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
1114         
1115         uint totalAcceptedLimit;
1116         uint totalDeclinedLimit;
1117 
1118         uint securesCount;
1119         mapping(uint => uint) index2txIndex;
1120         mapping(uint => uint) txIndex2index;
1121     }
1122 
1123     struct Vote {
1124         bytes32 groupName;
1125         bool accepted;
1126     }
1127 
1128     struct Guard {
1129         GuardState state;
1130         uint basePolicyIndex;
1131 
1132         uint alreadyAccepted;
1133         uint alreadyDeclined;
1134         
1135         mapping(address => Vote) votes; // member address => vote
1136         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
1137         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
1138     }
1139 
1140     address public accessManager;
1141 
1142     mapping(address => bool) public authorized;
1143 
1144     uint public policiesCount;
1145     mapping(uint => bytes32) index2PolicyId; // index => policy hash
1146     mapping(bytes32 => uint) policyId2Index; // policy hash => index
1147     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
1148 
1149     uint public txCount;
1150     mapping(uint => bytes32) index2txKey;
1151     mapping(bytes32 => uint) txKey2index; // tx key => index
1152     mapping(bytes32 => Guard) txKey2guard;
1153 
1154     /// @dev Execution is allowed only by authorized contract
1155     modifier onlyAuthorized {
1156         if (authorized[msg.sender] || address(this) == msg.sender) {
1157             _;
1158         }
1159     }
1160 
1161     /// @dev Pending Manager's constructor
1162     ///
1163     /// @param _accessManager access manager's address
1164     function PendingManager(address _accessManager) public {
1165         require(_accessManager != 0x0);
1166         accessManager = _accessManager;
1167     }
1168 
1169     function() payable public {
1170         revert();
1171     }
1172 
1173     /// @notice Update access manager address
1174     ///
1175     /// @param _accessManager access manager's address
1176     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
1177         require(_accessManager != 0x0);
1178         accessManager = _accessManager;
1179         return OK;
1180     }
1181 
1182     /// @notice Sign in contract
1183     ///
1184     /// @param _contract contract's address
1185     function signIn(address _contract) external onlyContractOwner returns (uint) {
1186         require(_contract != 0x0);
1187         authorized[_contract] = true;
1188         return OK;
1189     }
1190 
1191     /// @notice Sign out contract
1192     ///
1193     /// @param _contract contract's address
1194     function signOut(address _contract) external onlyContractOwner returns (uint) {
1195         require(_contract != 0x0);
1196         delete authorized[_contract];
1197         return OK;
1198     }
1199 
1200     /// @notice Register new policy rule
1201     /// Can be called only by contract owner
1202     ///
1203     /// @param _sig target method signature
1204     /// @param _contract target contract address
1205     /// @param _groupName group's name
1206     /// @param _acceptLimit accepted vote limit
1207     /// @param _declineLimit decline vote limit
1208     ///
1209     /// @return code
1210     function addPolicyRule(
1211         bytes4 _sig,
1212         address _contract,
1213         bytes32 _groupName,
1214         uint _acceptLimit,
1215         uint _declineLimit
1216     )
1217     onlyContractOwner
1218     external
1219     returns (uint)
1220     {
1221         require(_sig != 0x0);
1222         require(_contract != 0x0);
1223         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1224         require(_acceptLimit != 0);
1225         require(_declineLimit != 0);
1226 
1227         bytes32 _policyHash = keccak256(_sig, _contract);
1228         
1229         if (policyId2Index[_policyHash] == 0) {
1230             uint _policiesCount = policiesCount.add(1);
1231             index2PolicyId[_policiesCount] = _policyHash;
1232             policyId2Index[_policyHash] = _policiesCount;
1233             policiesCount = _policiesCount;
1234         }
1235 
1236         Policy storage _policy = policyId2policy[_policyHash];
1237         uint _policyGroupsCount = _policy.groupsCount;
1238 
1239         if (_policy.groupName2index[_groupName] == 0) {
1240             _policyGroupsCount += 1;
1241             _policy.groupName2index[_groupName] = _policyGroupsCount;
1242             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
1243             _policy.groupsCount = _policyGroupsCount;
1244         }
1245 
1246         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
1247         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
1248         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
1249         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
1250         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
1251         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
1252 
1253         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
1254         return OK;
1255     }
1256 
1257     /// @notice Remove policy rule
1258     /// Can be called only by contract owner
1259     ///
1260     /// @param _groupName group's name
1261     ///
1262     /// @return code
1263     function removePolicyRule(
1264         bytes4 _sig,
1265         address _contract,
1266         bytes32 _groupName
1267     ) 
1268     onlyContractOwner 
1269     external 
1270     returns (uint) 
1271     {
1272         require(_sig != bytes4(0));
1273         require(_contract != 0x0);
1274         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1275 
1276         bytes32 _policyHash = keccak256(_sig, _contract);
1277         Policy storage _policy = policyId2policy[_policyHash];
1278         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
1279 
1280         if (_policyGroupNameIndex == 0) {
1281             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1282         }
1283 
1284         uint _policyGroupsCount = _policy.groupsCount;
1285         if (_policyGroupNameIndex != _policyGroupsCount) {
1286             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
1287             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
1288             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
1289         }
1290 
1291         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
1292         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
1293 
1294         delete _policy.groupName2index[_groupName];
1295         delete _policy.participatedGroups[_policyGroupsCount];
1296         _policy.groupsCount = _policyGroupsCount.sub(1);
1297 
1298         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
1299         return OK;
1300     }
1301 
1302     /// @notice Add transaction
1303     ///
1304     /// @param _key transaction id
1305     ///
1306     /// @return code
1307     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
1308         require(_key != bytes32(0));
1309         require(_sig != bytes4(0));
1310         require(_contract != 0x0);
1311 
1312         bytes32 _policyHash = keccak256(_sig, _contract);
1313         require(isPolicyExist(_policyHash));
1314 
1315         if (isTxExist(_key)) {
1316             return _emitError(PENDING_DUPLICATE_TX);
1317         }
1318 
1319         if (_policyHash == bytes32(0)) {
1320             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
1321         }
1322 
1323         uint _index = txCount.add(1);
1324         txCount = _index;
1325         index2txKey[_index] = _key;
1326         txKey2index[_key] = _index;
1327 
1328         Guard storage _guard = txKey2guard[_key];
1329         _guard.basePolicyIndex = policyId2Index[_policyHash];
1330         _guard.state = GuardState.InProcess;
1331 
1332         Policy storage _policy = policyId2policy[_policyHash];
1333         uint _counter = _policy.securesCount.add(1);
1334         _policy.securesCount = _counter;
1335         _policy.index2txIndex[_counter] = _index;
1336         _policy.txIndex2index[_index] = _counter;
1337 
1338         ProtectionTxAdded(_key, _policyHash, block.number);
1339         return OK;
1340     }
1341 
1342     /// @notice Delete transaction
1343     /// @param _key transaction id
1344     /// @return code
1345     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
1346         require(_key != bytes32(0));
1347 
1348         if (!isTxExist(_key)) {
1349             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1350         }
1351 
1352         uint _txsCount = txCount;
1353         uint _txIndex = txKey2index[_key];
1354         if (_txIndex != _txsCount) {
1355             bytes32 _last = index2txKey[txCount];
1356             index2txKey[_txIndex] = _last;
1357             txKey2index[_last] = _txIndex;
1358         }
1359 
1360         delete txKey2index[_key];
1361         delete index2txKey[_txsCount];
1362         txCount = _txsCount.sub(1);
1363 
1364         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
1365         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
1366         uint _counter = _policy.securesCount;
1367         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
1368         if (_policyTxIndex != _counter) {
1369             uint _movedTxIndex = _policy.index2txIndex[_counter];
1370             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
1371             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
1372         }
1373 
1374         delete _policy.index2txIndex[_counter];
1375         delete _policy.txIndex2index[_txIndex];
1376         _policy.securesCount = _counter.sub(1);
1377 
1378         TxDeleted(_key);
1379         return OK;
1380     }
1381 
1382     /// @notice Accept transaction
1383     /// Can be called only by registered user in GroupsAccessManager
1384     ///
1385     /// @param _key transaction id
1386     ///
1387     /// @return code
1388     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1389         if (!isTxExist(_key)) {
1390             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1391         }
1392 
1393         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1394             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1395         }
1396 
1397         Guard storage _guard = txKey2guard[_key];
1398         if (_guard.state != GuardState.InProcess) {
1399             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1400         }
1401 
1402         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
1403             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1404         }
1405 
1406         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1407         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1408         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
1409         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
1410             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1411         }
1412 
1413         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
1414         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
1415         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
1416         _guard.alreadyAccepted = _alreadyAcceptedCount;
1417 
1418         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
1419 
1420         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
1421             _guard.state = GuardState.Confirmed;
1422             ProtectionTxDone(_key);
1423         }
1424 
1425         return OK;
1426     }
1427 
1428     /// @notice Decline transaction
1429     /// Can be called only by registered user in GroupsAccessManager
1430     ///
1431     /// @param _key transaction id
1432     ///
1433     /// @return code
1434     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1435         if (!isTxExist(_key)) {
1436             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1437         }
1438 
1439         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1440             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1441         }
1442 
1443         Guard storage _guard = txKey2guard[_key];
1444         if (_guard.state != GuardState.InProcess) {
1445             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1446         }
1447 
1448         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
1449             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1450         }
1451 
1452         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1453         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1454         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
1455         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
1456             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1457         }
1458 
1459         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
1460         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
1461         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
1462         _guard.alreadyDeclined = _alreadyDeclinedCount;
1463 
1464 
1465         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
1466 
1467         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
1468             _guard.state = GuardState.Decline;
1469             ProtectionTxCancelled(_key);
1470         }
1471 
1472         return OK;
1473     }
1474 
1475     /// @notice Revoke user votes for transaction
1476     /// Can be called only by contract owner
1477     ///
1478     /// @param _key transaction id
1479     /// @param _user target user address
1480     ///
1481     /// @return code
1482     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
1483         return _revoke(_key, _user);
1484     }
1485 
1486     /// @notice Revoke vote for transaction
1487     /// Can be called only by authorized user
1488     /// @param _key transaction id
1489     /// @return code
1490     function revoke(bytes32 _key) external returns (uint) {
1491         return _revoke(_key, msg.sender);
1492     }
1493 
1494     /// @notice Check transaction status
1495     /// @param _key transaction id
1496     /// @return code
1497     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
1498         require(_key != bytes32(0));
1499 
1500         if (!isTxExist(_key)) {
1501             return NO_RECORDS_WERE_FOUND;
1502         }
1503 
1504         Guard storage _guard = txKey2guard[_key];
1505         return _guard.state == GuardState.InProcess
1506         ? PENDING_MANAGER_IN_PROCESS
1507         : _guard.state == GuardState.Confirmed
1508         ? OK
1509         : PENDING_MANAGER_REJECTED;
1510     }
1511 
1512 
1513     /// @notice Check policy details
1514     ///
1515     /// @return _groupNames group names included in policies
1516     /// @return _acceptLimits accept limit for group
1517     /// @return _declineLimits decline limit for group
1518     function getPolicyDetails(bytes4 _sig, address _contract)
1519     public
1520     view
1521     returns (
1522         bytes32[] _groupNames,
1523         uint[] _acceptLimits,
1524         uint[] _declineLimits,
1525         uint _totalAcceptedLimit,
1526         uint _totalDeclinedLimit
1527     ) {
1528         require(_sig != bytes4(0));
1529         require(_contract != 0x0);
1530         
1531         bytes32 _policyHash = keccak256(_sig, _contract);
1532         uint _policyIdx = policyId2Index[_policyHash];
1533         if (_policyIdx == 0) {
1534             return;
1535         }
1536 
1537         Policy storage _policy = policyId2policy[_policyHash];
1538         uint _policyGroupsCount = _policy.groupsCount;
1539         _groupNames = new bytes32[](_policyGroupsCount);
1540         _acceptLimits = new uint[](_policyGroupsCount);
1541         _declineLimits = new uint[](_policyGroupsCount);
1542 
1543         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1544             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1545             _groupNames[_idx] = _requirements.groupName;
1546             _acceptLimits[_idx] = _requirements.acceptLimit;
1547             _declineLimits[_idx] = _requirements.declineLimit;
1548         }
1549 
1550         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1551     }
1552 
1553     /// @notice Check policy include target group
1554     /// @param _policyHash policy hash (sig, contract address)
1555     /// @param _groupName group id
1556     /// @return bool
1557     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1558         Policy storage _policy = policyId2policy[_policyHash];
1559         return _policy.groupName2index[_groupName] != 0;
1560     }
1561 
1562     /// @notice Check is policy exist
1563     /// @param _policyHash policy hash (sig, contract address)
1564     /// @return bool
1565     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1566         return policyId2Index[_policyHash] != 0;
1567     }
1568 
1569     /// @notice Check is transaction exist
1570     /// @param _key transaction id
1571     /// @return bool
1572     function isTxExist(bytes32 _key) public view returns (bool){
1573         return txKey2index[_key] != 0;
1574     }
1575 
1576     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1577         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1578             _guard.state = GuardState.Decline;
1579         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1580             _guard.state = GuardState.Confirmed;
1581         } else if (_guard.state != GuardState.InProcess) {
1582             _guard.state = GuardState.InProcess;
1583         }
1584     }
1585 
1586     function _revoke(bytes32 _key, address _user) private returns (uint) {
1587         require(_key != bytes32(0));
1588         require(_user != 0x0);
1589 
1590         if (!isTxExist(_key)) {
1591             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1592         }
1593 
1594         Guard storage _guard = txKey2guard[_key];
1595         if (_guard.state != GuardState.InProcess) {
1596             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1597         }
1598 
1599         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1600         if (_votedGroupName == bytes32(0)) {
1601             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1602         }
1603 
1604         bool isAcceptedVote = _guard.votes[_user].accepted;
1605         if (isAcceptedVote) {
1606             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1607             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1608         } else {
1609             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1610             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1611 
1612         }
1613 
1614         delete _guard.votes[_user];
1615 
1616         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1617         return OK;
1618     }
1619 }
1620 
1621 /// @title MultiSigAdapter
1622 ///
1623 /// Abstract implementation
1624 /// This contract serves as transaction signer
1625 contract MultiSigAdapter is Object {
1626 
1627     uint constant MULTISIG_ADDED = 3;
1628     uint constant NO_RECORDS_WERE_FOUND = 4;
1629 
1630     modifier isAuthorized {
1631         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1632             _;
1633         }
1634     }
1635 
1636     /// @notice Get pending address
1637     /// @dev abstract. Needs child implementation
1638     ///
1639     /// @return pending address
1640     function getPendingManager() public view returns (address);
1641 
1642     /// @notice Sign current transaction and add it to transaction pending queue
1643     ///
1644     /// @return code
1645     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1646         bytes32 _txHash = _getKey(_args, _block);
1647         address _manager = getPendingManager();
1648 
1649         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1650         if (_code != NO_RECORDS_WERE_FOUND) {
1651             return _code;
1652         }
1653 
1654         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1655             revert();
1656         }
1657 
1658         return MULTISIG_ADDED;
1659     }
1660 
1661     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1662         bytes32 _txHash = _getKey(_args, _block);
1663         address _manager = getPendingManager();
1664         return PendingManager(_manager).isTxExist(_txHash);
1665     }
1666 
1667     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1668         _block = _block != 0 ? _block : block.number;
1669         _txHash = keccak256(msg.sig, _args, _block);
1670     }
1671 }
1672 
1673 /// @title ServiceController
1674 ///
1675 /// Base implementation
1676 /// Serves for managing service instances
1677 contract ServiceController is MultiSigAdapter {
1678 
1679     uint constant SERVICE_CONTROLLER = 350000;
1680     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1681     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1682     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1683     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1684 
1685     address public profiterole;
1686     address public treasury;
1687     address public pendingManager;
1688     address public proxy;
1689 
1690     mapping(address => bool) public sideServices;
1691     mapping(address => bool) emissionProviders;
1692     mapping(address => bool) burningMans;
1693 
1694     /// @notice Default ServiceController's constructor
1695     ///
1696     /// @param _pendingManager pending manager address
1697     /// @param _proxy ERC20 proxy address
1698     /// @param _profiterole profiterole address
1699     /// @param _treasury treasury address
1700     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1701         require(_pendingManager != 0x0);
1702         require(_proxy != 0x0);
1703         require(_profiterole != 0x0);
1704         require(_treasury != 0x0);
1705         pendingManager = _pendingManager;
1706         proxy = _proxy;
1707         profiterole = _profiterole;
1708         treasury = _treasury;
1709     }
1710 
1711     /// @notice Return pending manager address
1712     ///
1713     /// @return code
1714     function getPendingManager() public view returns (address) {
1715         return pendingManager;
1716     }
1717 
1718     /// @notice Add emission provider
1719     ///
1720     /// @param _provider emission provider address
1721     ///
1722     /// @return code
1723     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1724         if (emissionProviders[_provider]) {
1725             return SERVICE_CONTROLLER_EMISSION_EXIST;
1726         }
1727         _code = _multisig(keccak256(_provider), _block);
1728         if (OK != _code) {
1729             return _code;
1730         }
1731 
1732         emissionProviders[_provider] = true;
1733         return OK;
1734     }
1735 
1736     /// @notice Remove emission provider
1737     ///
1738     /// @param _provider emission provider address
1739     ///
1740     /// @return code
1741     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1742         _code = _multisig(keccak256(_provider), _block);
1743         if (OK != _code) {
1744             return _code;
1745         }
1746 
1747         delete emissionProviders[_provider];
1748         return OK;
1749     }
1750 
1751     /// @notice Add burning man
1752     ///
1753     /// @param _burningMan burning man address
1754     ///
1755     /// @return code
1756     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1757         if (burningMans[_burningMan]) {
1758             return SERVICE_CONTROLLER_BURNING_MAN_EXIST;
1759         }
1760 
1761         _code = _multisig(keccak256(_burningMan), _block);
1762         if (OK != _code) {
1763             return _code;
1764         }
1765 
1766         burningMans[_burningMan] = true;
1767         return OK;
1768     }
1769 
1770     /// @notice Remove burning man
1771     ///
1772     /// @param _burningMan burning man address
1773     ///
1774     /// @return code
1775     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1776         _code = _multisig(keccak256(_burningMan), _block);
1777         if (OK != _code) {
1778             return _code;
1779         }
1780 
1781         delete burningMans[_burningMan];
1782         return OK;
1783     }
1784 
1785     /// @notice Update a profiterole address
1786     ///
1787     /// @param _profiterole profiterole address
1788     ///
1789     /// @return result code of an operation
1790     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1791         _code = _multisig(keccak256(_profiterole), _block);
1792         if (OK != _code) {
1793             return _code;
1794         }
1795 
1796         profiterole = _profiterole;
1797         return OK;
1798     }
1799 
1800     /// @notice Update a treasury address
1801     ///
1802     /// @param _treasury treasury address
1803     ///
1804     /// @return result code of an operation
1805     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1806         _code = _multisig(keccak256(_treasury), _block);
1807         if (OK != _code) {
1808             return _code;
1809         }
1810 
1811         treasury = _treasury;
1812         return OK;
1813     }
1814 
1815     /// @notice Update pending manager address
1816     ///
1817     /// @param _pendingManager pending manager address
1818     ///
1819     /// @return result code of an operation
1820     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1821         _code = _multisig(keccak256(_pendingManager), _block);
1822         if (OK != _code) {
1823             return _code;
1824         }
1825 
1826         pendingManager = _pendingManager;
1827         return OK;
1828     }
1829 
1830     function addSideService(address _service, uint _block) public returns (uint _code) {
1831         if (sideServices[_service]) {
1832             return SERVICE_CONTROLLER_SERVICE_EXIST;
1833         }
1834         _code = _multisig(keccak256(_service), _block);
1835         if (OK != _code) {
1836             return _code;
1837         }
1838 
1839         sideServices[_service] = true;
1840         return OK;
1841     }
1842 
1843     function removeSideService(address _service, uint _block) public returns (uint _code) {
1844         _code = _multisig(keccak256(_service), _block);
1845         if (OK != _code) {
1846             return _code;
1847         }
1848 
1849         delete sideServices[_service];
1850         return OK;
1851     }
1852 
1853     /// @notice Check target address is service
1854     ///
1855     /// @param _address target address
1856     ///
1857     /// @return `true` when an address is a service, `false` otherwise
1858     function isService(address _address) public view returns (bool check) {
1859         return _address == profiterole ||
1860             _address == treasury || 
1861             _address == proxy || 
1862             _address == pendingManager || 
1863             emissionProviders[_address] || 
1864             burningMans[_address] ||
1865             sideServices[_address];
1866     }
1867 }
1868 
1869 /// @title Provides possibility manage holders? country limits and limits for holders.
1870 contract DataController is OracleMethodAdapter, DataControllerEmitter {
1871 
1872     /* CONSTANTS */
1873 
1874     uint constant DATA_CONTROLLER = 109000;
1875     uint constant DATA_CONTROLLER_ERROR = DATA_CONTROLLER + 1;
1876     uint constant DATA_CONTROLLER_CURRENT_WRONG_LIMIT = DATA_CONTROLLER + 2;
1877     uint constant DATA_CONTROLLER_WRONG_ALLOWANCE = DATA_CONTROLLER + 3;
1878     uint constant DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS = DATA_CONTROLLER + 4;
1879 
1880     uint constant MAX_TOKEN_HOLDER_NUMBER = 2 ** 256 - 1;
1881 
1882     using SafeMath for uint;
1883 
1884     /* STRUCTS */
1885 
1886     /// @title HoldersData couldn't be public because of internal structures, so needed to provide getters for different parts of _holderData
1887     struct HoldersData {
1888         uint countryCode;
1889         uint sendLimPerDay;
1890         uint sendLimPerMonth;
1891         bool operational;
1892         bytes text;
1893         uint holderAddressCount;
1894         mapping(uint => address) index2Address;
1895         mapping(address => uint) address2Index;
1896     }
1897 
1898     struct CountryLimits {
1899         uint countryCode;
1900         uint maxTokenHolderNumber;
1901         uint currentTokenHolderNumber;
1902     }
1903 
1904     /* FIELDS */
1905 
1906     address public withdrawal;
1907     address assetAddress;
1908     address public serviceController;
1909 
1910     mapping(address => uint) public allowance;
1911 
1912     // Iterable mapping pattern is used for holders.
1913     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
1914     uint public holdersCount;
1915     mapping(uint => HoldersData) holders;
1916     mapping(address => bytes32) holderAddress2Id;
1917     mapping(bytes32 => uint) public holderIndex;
1918 
1919     // This is an access address mapping. Many addresses may have access to a single holder.
1920     uint public countriesCount;
1921     mapping(uint => CountryLimits) countryLimitsList;
1922     mapping(uint => uint) countryIndex;
1923 
1924     /* MODIFIERS */
1925 
1926     modifier onlyWithdrawal {
1927         if (msg.sender != withdrawal) {
1928             revert();
1929         }
1930         _;
1931     }
1932 
1933     modifier onlyAsset {
1934         if (msg.sender == assetAddress) {
1935             _;
1936         }
1937     }
1938 
1939     modifier onlyContractOwner {
1940         if (msg.sender == contractOwner) {
1941             _;
1942         }
1943     }
1944 
1945     /// @notice Constructor for _holderData controller.
1946     /// @param _serviceController service controller
1947     function DataController(address _serviceController, address _asset) public {
1948         require(_serviceController != 0x0);
1949         require(_asset != 0x0);
1950 
1951         serviceController = _serviceController;
1952         assetAddress = _asset;
1953     }
1954 
1955     function() payable public {
1956         revert();
1957     }
1958 
1959     function setWithdraw(address _withdrawal) onlyContractOwner external returns (uint) {
1960         require(_withdrawal != 0x0);
1961         withdrawal = _withdrawal;
1962         return OK;
1963     }
1964 
1965 
1966     function getPendingManager() public view returns (address) {
1967         return ServiceController(serviceController).getPendingManager();
1968     }
1969 
1970     function getHolderInfo(bytes32 _externalHolderId) public view returns (
1971         uint _countryCode,
1972         uint _limPerDay,
1973         uint _limPerMonth,
1974         bool _operational,
1975         bytes _text
1976     ) {
1977         HoldersData storage _data = holders[holderIndex[_externalHolderId]];
1978         return (_data.countryCode, _data.sendLimPerDay, _data.sendLimPerMonth, _data.operational, _data.text);
1979     }
1980 
1981     function getHolderAddresses(bytes32 _externalHolderId) public view returns (address[] _addresses) {
1982         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
1983         uint _addressesCount = _holderData.holderAddressCount;
1984         _addresses = new address[](_addressesCount);
1985         for (uint _holderAddressIdx = 0; _holderAddressIdx < _addressesCount; ++_holderAddressIdx) {
1986             _addresses[_holderAddressIdx] = _holderData.index2Address[_holderAddressIdx + 1];
1987         }
1988     }
1989 
1990     function getHolderCountryCode(bytes32 _externalHolderId) public view returns (uint) {
1991         return holders[holderIndex[_externalHolderId]].countryCode;
1992     }
1993 
1994     function getHolderExternalIdByAddress(address _address) public view returns (bytes32) {
1995         return holderAddress2Id[_address];
1996     }
1997 
1998     /// @notice Checks user is holder.
1999     /// @param _address checking address.
2000     /// @return `true` if _address is registered holder, `false` otherwise.
2001     function isRegisteredAddress(address _address) public view returns (bool) {
2002         return holderIndex[holderAddress2Id[_address]] != 0;
2003     }
2004 
2005     function isHolderOwnAddress(bytes32 _externalHolderId, address _address) public view returns (bool) {
2006         uint _holderIndex = holderIndex[_externalHolderId];
2007         if (_holderIndex == 0) {
2008             return false;
2009         }
2010         return holders[_holderIndex].address2Index[_address] != 0;
2011     }
2012 
2013     function getCountryInfo(uint _countryCode) public view returns (uint _maxHolderNumber, uint _currentHolderCount) {
2014         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2015         return (_data.maxTokenHolderNumber, _data.currentTokenHolderNumber);
2016     }
2017 
2018     function getCountryLimit(uint _countryCode) public view returns (uint limit) {
2019         uint _index = countryIndex[_countryCode];
2020         require(_index != 0);
2021         return countryLimitsList[_index].maxTokenHolderNumber;
2022     }
2023 
2024     function addCountryCode(uint _countryCode) onlyContractOwner public returns (uint) {
2025         var (,_created) = _createCountryId(_countryCode);
2026         if (!_created) {
2027             return _emitError(DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS);
2028         }
2029         return OK;
2030     }
2031 
2032     /// @notice Returns holder id for the specified address, creates it if needed.
2033     /// @param _externalHolderId holder address.
2034     /// @param _countryCode country code.
2035     /// @return error code.
2036     function registerHolder(bytes32 _externalHolderId, address _holderAddress, uint _countryCode) onlyOracleOrOwner external returns (uint) {
2037         require(_holderAddress != 0x0);
2038         uint _holderIndex = holderIndex[holderAddress2Id[_holderAddress]];
2039         require(_holderIndex == 0);
2040 
2041         _createCountryId(_countryCode);
2042         _holderIndex = holdersCount.add(1);
2043         holdersCount = _holderIndex;
2044 
2045         HoldersData storage _holderData = holders[_holderIndex];
2046         _holderData.countryCode = _countryCode;
2047         _holderData.operational = true;
2048         _holderData.sendLimPerDay = MAX_TOKEN_HOLDER_NUMBER;
2049         _holderData.sendLimPerMonth = MAX_TOKEN_HOLDER_NUMBER;
2050         uint _firstAddressIndex = 1;
2051         _holderData.holderAddressCount = _firstAddressIndex;
2052         _holderData.address2Index[_holderAddress] = _firstAddressIndex;
2053         _holderData.index2Address[_firstAddressIndex] = _holderAddress;
2054         holderIndex[_externalHolderId] = _holderIndex;
2055         holderAddress2Id[_holderAddress] = _externalHolderId;
2056 
2057         _emitHolderRegistered(_externalHolderId, _holderIndex, _countryCode);
2058         return OK;
2059     }
2060 
2061     /// @notice Adds new address equivalent to holder.
2062     /// @param _externalHolderId external holder identifier.
2063     /// @param _newAddress adding address.
2064     /// @return error code.
2065     function addHolderAddress(bytes32 _externalHolderId, address _newAddress) onlyOracleOrOwner external returns (uint) {
2066         uint _holderIndex = holderIndex[_externalHolderId];
2067         require(_holderIndex != 0);
2068 
2069         uint _newAddressId = holderIndex[holderAddress2Id[_newAddress]];
2070         require(_newAddressId == 0);
2071 
2072         HoldersData storage _holderData = holders[_holderIndex];
2073 
2074         if (_holderData.address2Index[_newAddress] == 0) {
2075             _holderData.holderAddressCount = _holderData.holderAddressCount.add(1);
2076             _holderData.address2Index[_newAddress] = _holderData.holderAddressCount;
2077             _holderData.index2Address[_holderData.holderAddressCount] = _newAddress;
2078         }
2079 
2080         holderAddress2Id[_newAddress] = _externalHolderId;
2081 
2082         _emitHolderAddressAdded(_externalHolderId, _newAddress, _holderIndex);
2083         return OK;
2084     }
2085 
2086     /// @notice Remove an address owned by a holder.
2087     /// @param _externalHolderId external holder identifier.
2088     /// @param _address removing address.
2089     /// @return error code.
2090     function removeHolderAddress(bytes32 _externalHolderId, address _address) onlyOracleOrOwner external returns (uint) {
2091         uint _holderIndex = holderIndex[_externalHolderId];
2092         require(_holderIndex != 0);
2093 
2094         HoldersData storage _holderData = holders[_holderIndex];
2095 
2096         uint _tempIndex = _holderData.address2Index[_address];
2097         require(_tempIndex != 0);
2098 
2099         address _lastAddress = _holderData.index2Address[_holderData.holderAddressCount];
2100         _holderData.address2Index[_lastAddress] = _tempIndex;
2101         _holderData.index2Address[_tempIndex] = _lastAddress;
2102         delete _holderData.address2Index[_address];
2103         _holderData.holderAddressCount = _holderData.holderAddressCount.sub(1);
2104 
2105         delete holderAddress2Id[_address];
2106 
2107         _emitHolderAddressRemoved(_externalHolderId, _address, _holderIndex);
2108         return OK;
2109     }
2110 
2111     /// @notice Change operational status for holder.
2112     /// Can be accessed by contract owner or oracle only.
2113     ///
2114     /// @param _externalHolderId external holder identifier.
2115     /// @param _operational operational status.
2116     ///
2117     /// @return result code.
2118     function changeOperational(bytes32 _externalHolderId, bool _operational) onlyOracleOrOwner external returns (uint) {
2119         uint _holderIndex = holderIndex[_externalHolderId];
2120         require(_holderIndex != 0);
2121 
2122         holders[_holderIndex].operational = _operational;
2123 
2124         _emitHolderOperationalChanged(_externalHolderId, _operational);
2125         return OK;
2126     }
2127 
2128     /// @notice Changes text for holder.
2129     /// Can be accessed by contract owner or oracle only.
2130     ///
2131     /// @param _externalHolderId external holder identifier.
2132     /// @param _text changing text.
2133     ///
2134     /// @return result code.
2135     function updateTextForHolder(bytes32 _externalHolderId, bytes _text) onlyOracleOrOwner external returns (uint) {
2136         uint _holderIndex = holderIndex[_externalHolderId];
2137         require(_holderIndex != 0);
2138 
2139         holders[_holderIndex].text = _text;
2140         return OK;
2141     }
2142 
2143     /// @notice Updates limit per day for holder.
2144     ///
2145     /// Can be accessed by contract owner only.
2146     ///
2147     /// @param _externalHolderId external holder identifier.
2148     /// @param _limit limit value.
2149     ///
2150     /// @return result code.
2151     function updateLimitPerDay(bytes32 _externalHolderId, uint _limit) onlyOracleOrOwner external returns (uint) {
2152         uint _holderIndex = holderIndex[_externalHolderId];
2153         require(_holderIndex != 0);
2154 
2155         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2156         holders[_holderIndex].sendLimPerDay = _limit;
2157 
2158         _emitDayLimitChanged(_externalHolderId, _currentLimit, _limit);
2159         return OK;
2160     }
2161 
2162     /// @notice Updates limit per month for holder.
2163     /// Can be accessed by contract owner or oracle only.
2164     ///
2165     /// @param _externalHolderId external holder identifier.
2166     /// @param _limit limit value.
2167     ///
2168     /// @return result code.
2169     function updateLimitPerMonth(bytes32 _externalHolderId, uint _limit) onlyOracleOrOwner external returns (uint) {
2170         uint _holderIndex = holderIndex[_externalHolderId];
2171         require(_holderIndex != 0);
2172 
2173         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2174         holders[_holderIndex].sendLimPerMonth = _limit;
2175 
2176         _emitMonthLimitChanged(_externalHolderId, _currentLimit, _limit);
2177         return OK;
2178     }
2179 
2180     /// @notice Change country limits.
2181     /// Can be accessed by contract owner or oracle only.
2182     ///
2183     /// @param _countryCode country code.
2184     /// @param _limit limit value.
2185     ///
2186     /// @return result code.
2187     function changeCountryLimit(uint _countryCode, uint _limit) onlyOracleOrOwner external returns (uint) {
2188         uint _countryIndex = countryIndex[_countryCode];
2189         require(_countryIndex != 0);
2190 
2191         uint _currentTokenHolderNumber = countryLimitsList[_countryIndex].currentTokenHolderNumber;
2192         if (_currentTokenHolderNumber > _limit) {
2193             return DATA_CONTROLLER_CURRENT_WRONG_LIMIT;
2194         }
2195 
2196         countryLimitsList[_countryIndex].maxTokenHolderNumber = _limit;
2197         
2198         _emitCountryCodeChanged(_countryIndex, _countryCode, _limit);
2199         return OK;
2200     }
2201 
2202     function withdrawFrom(address _holderAddress, uint _value) public onlyAsset returns (uint) {
2203         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2204         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2205         _holderData.sendLimPerDay = _holderData.sendLimPerDay.sub(_value);
2206         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.sub(_value);
2207         return OK;
2208     }
2209 
2210     function depositTo(address _holderAddress, uint _value) public onlyAsset returns (uint) {
2211         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2212         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2213         _holderData.sendLimPerDay = _holderData.sendLimPerDay.add(_value);
2214         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.add(_value);
2215         return OK;
2216     }
2217 
2218     function updateCountryHoldersCount(uint _countryCode, uint _updatedHolderCount) public onlyAsset returns (uint) {
2219         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2220         assert(_data.maxTokenHolderNumber >= _updatedHolderCount);
2221         _data.currentTokenHolderNumber = _updatedHolderCount;
2222         return OK;
2223     }
2224 
2225     function changeAllowance(address _from, uint _value) public onlyWithdrawal returns (uint) {
2226         ServiceController _serviceController = ServiceController(serviceController);
2227         ATxAssetProxy token = ATxAssetProxy(_serviceController.proxy());
2228         if (token.balanceOf(_from) < _value) {
2229             return DATA_CONTROLLER_WRONG_ALLOWANCE;
2230         }
2231         allowance[_from] = _value;
2232         return OK;
2233     }
2234 
2235     function _createCountryId(uint _countryCode) internal returns (uint, bool _created) {
2236         uint countryId = countryIndex[_countryCode];
2237         if (countryId == 0) {
2238             uint _countriesCount = countriesCount;
2239             countryId = _countriesCount.add(1);
2240             countriesCount = countryId;
2241             CountryLimits storage limits = countryLimitsList[countryId];
2242             limits.countryCode = _countryCode;
2243             limits.maxTokenHolderNumber = MAX_TOKEN_HOLDER_NUMBER;
2244 
2245             countryIndex[_countryCode] = countryId;
2246             _emitCountryCodeAdded(countryIndex[_countryCode], _countryCode, MAX_TOKEN_HOLDER_NUMBER);
2247 
2248             _created = true;
2249         }
2250 
2251         return (countryId, _created);
2252     }
2253 }
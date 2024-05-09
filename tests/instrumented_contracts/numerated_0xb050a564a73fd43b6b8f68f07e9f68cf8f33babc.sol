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
286 contract Platform {
287     mapping(bytes32 => address) public proxies;
288     function name(bytes32 _symbol) public view returns (string);
289     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
290     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
291     function totalSupply(bytes32 _symbol) public view returns (uint);
292     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
293     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
294     function baseUnit(bytes32 _symbol) public view returns (uint8);
295     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
296     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
297     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
298     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
299     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
300     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
301     function isReissuable(bytes32 _symbol) public view returns (bool);
302     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
303 }
304 
305 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
306 
307     using SafeMath for uint;
308 
309     /**
310      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
311      */
312     event UpgradeProposal(address newVersion);
313 
314     // Current asset implementation contract address.
315     address latestVersion;
316 
317     // Assigned platform, immutable.
318     Platform public platform;
319 
320     // Assigned symbol, immutable.
321     bytes32 public smbl;
322 
323     // Assigned name, immutable.
324     string public name;
325 
326     /**
327      * Only platform is allowed to call.
328      */
329     modifier onlyPlatform() {
330         if (msg.sender == address(platform)) {
331             _;
332         }
333     }
334 
335     /**
336      * Only current asset owner is allowed to call.
337      */
338     modifier onlyAssetOwner() {
339         if (platform.isOwner(msg.sender, smbl)) {
340             _;
341         }
342     }
343 
344     /**
345      * Only asset implementation contract assigned to sender is allowed to call.
346      */
347     modifier onlyAccess(address _sender) {
348         if (getLatestVersion() == msg.sender) {
349             _;
350         }
351     }
352 
353     /**
354      * Resolves asset implementation contract for the caller and forwards there transaction data,
355      * along with the value. This allows for proxy interface growth.
356      */
357     function() public payable {
358         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
359     }
360 
361     /**
362      * Sets platform address, assigns symbol and name.
363      *
364      * Can be set only once.
365      *
366      * @param _platform platform contract address.
367      * @param _symbol assigned symbol.
368      * @param _name assigned name.
369      *
370      * @return success.
371      */
372     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
373         if (address(platform) != 0x0) {
374             return false;
375         }
376         platform = _platform;
377         symbol = _symbol;
378         smbl = stringToBytes32(_symbol);
379         name = _name;
380         return true;
381     }
382 
383     /**
384      * Returns asset total supply.
385      *
386      * @return asset total supply.
387      */
388     function totalSupply() public view returns (uint) {
389         return platform.totalSupply(smbl);
390     }
391 
392     /**
393      * Returns asset balance for a particular holder.
394      *
395      * @param _owner holder address.
396      *
397      * @return holder balance.
398      */
399     function balanceOf(address _owner) public view returns (uint) {
400         return platform.balanceOf(_owner, smbl);
401     }
402 
403     /**
404      * Returns asset allowance from one holder to another.
405      *
406      * @param _from holder that allowed spending.
407      * @param _spender holder that is allowed to spend.
408      *
409      * @return holder to spender allowance.
410      */
411     function allowance(address _from, address _spender) public view returns (uint) {
412         return platform.allowance(_from, _spender, smbl);
413     }
414 
415     /**
416      * Returns asset decimals.
417      *
418      * @return asset decimals.
419      */
420     function decimals() public view returns (uint8) {
421         return platform.baseUnit(smbl);
422     }
423 
424     /**
425      * Transfers asset balance from the caller to specified receiver.
426      *
427      * @param _to holder address to give to.
428      * @param _value amount to transfer.
429      *
430      * @return success.
431      */
432     function transfer(address _to, uint _value) public returns (bool) {
433         if (_to != 0x0) {
434             return _transferWithReference(_to, _value, "");
435         }
436         else {
437             return false;
438         }
439     }
440 
441     /**
442      * Transfers asset balance from the caller to specified receiver adding specified comment.
443      *
444      * @param _to holder address to give to.
445      * @param _value amount to transfer.
446      * @param _reference transfer comment to be included in a platform's Transfer event.
447      *
448      * @return success.
449      */
450     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
451         if (_to != 0x0) {
452             return _transferWithReference(_to, _value, _reference);
453         }
454         else {
455             return false;
456         }
457     }
458 
459     /**
460      * Performs transfer call on the platform by the name of specified sender.
461      *
462      * Can only be called by asset implementation contract assigned to sender.
463      *
464      * @param _to holder address to give to.
465      * @param _value amount to transfer.
466      * @param _reference transfer comment to be included in a platform's Transfer event.
467      * @param _sender initial caller.
468      *
469      * @return success.
470      */
471     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
472         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
473     }
474 
475     /**
476      * Prforms allowance transfer of asset balance between holders.
477      *
478      * @param _from holder address to take from.
479      * @param _to holder address to give to.
480      * @param _value amount to transfer.
481      *
482      * @return success.
483      */
484     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
485         if (_to != 0x0) {
486             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
487         }
488         else {
489             return false;
490         }
491     }
492 
493     /**
494      * Performs allowance transfer call on the platform by the name of specified sender.
495      *
496      * Can only be called by asset implementation contract assigned to sender.
497      *
498      * @param _from holder address to take from.
499      * @param _to holder address to give to.
500      * @param _value amount to transfer.
501      * @param _reference transfer comment to be included in a platform's Transfer event.
502      * @param _sender initial caller.
503      *
504      * @return success.
505      */
506     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
507         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
508     }
509 
510     /**
511      * Sets asset spending allowance for a specified spender.
512      *
513      * @param _spender holder address to set allowance to.
514      * @param _value amount to allow.
515      *
516      * @return success.
517      */
518     function approve(address _spender, uint _value) public returns (bool) {
519         if (_spender != 0x0) {
520             return _getAsset().__approve(_spender, _value, msg.sender);
521         }
522         else {
523             return false;
524         }
525     }
526 
527     /**
528      * Performs allowance setting call on the platform by the name of specified sender.
529      *
530      * Can only be called by asset implementation contract assigned to sender.
531      *
532      * @param _spender holder address to set allowance to.
533      * @param _value amount to allow.
534      * @param _sender initial caller.
535      *
536      * @return success.
537      */
538     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
539         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
540     }
541 
542     /**
543      * Emits ERC20 Transfer event on this contract.
544      *
545      * Can only be, and, called by assigned platform when asset transfer happens.
546      */
547     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
548         Transfer(_from, _to, _value);
549     }
550 
551     /**
552      * Emits ERC20 Approval event on this contract.
553      *
554      * Can only be, and, called by assigned platform when asset allowance set happens.
555      */
556     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
557         Approval(_from, _spender, _value);
558     }
559 
560     /**
561      * Returns current asset implementation contract address.
562      *
563      * @return asset implementation contract address.
564      */
565     function getLatestVersion() public view returns (address) {
566         return latestVersion;
567     }
568 
569     /**
570      * Propose next asset implementation contract address.
571      *
572      * Can only be called by current asset owner.
573      *
574      * Note: freeze-time should not be applied for the initial setup.
575      *
576      * @param _newVersion asset implementation contract address.
577      *
578      * @return success.
579      */
580     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
581         // New version address should be other than 0x0.
582         if (_newVersion == 0x0) {
583             return false;
584         }
585         
586         latestVersion = _newVersion;
587 
588         UpgradeProposal(_newVersion); 
589         return true;
590     }
591 
592     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
593         return true;
594     }
595 
596     /**
597      * Returns asset implementation contract for current caller.
598      *
599      * @return asset implementation contract.
600      */
601     function _getAsset() internal view returns (ATxAssetInterface) {
602         return ATxAssetInterface(getLatestVersion());
603     }
604 
605     /**
606      * Resolves asset implementation contract for the caller and forwards there arguments along with
607      * the caller address.
608      *
609      * @return success.
610      */
611     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
612         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
613     }
614 
615     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
616         assembly {
617             result := mload(add(source, 32))
618         }
619     }
620 }
621 
622 contract DataControllerEmitter {
623 
624     event CountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount);
625     event CountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount);
626 
627     event HolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode);
628     event HolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
629     event HolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
630     event HolderOperationalChanged(bytes32 _externalHolderId, bool _operational);
631 
632     event DayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
633     event MonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
634 
635     event Error(uint _errorCode);
636 
637     function _emitHolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
638         HolderAddressAdded(_externalHolderId, _holderPrototype, _accessIndex);
639     }
640 
641     function _emitHolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
642         HolderAddressRemoved(_externalHolderId, _holderPrototype, _accessIndex);
643     }
644 
645     function _emitHolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode) internal {
646         HolderRegistered(_externalHolderId, _accessIndex, _countryCode);
647     }
648 
649     function _emitHolderOperationalChanged(bytes32 _externalHolderId, bool _operational) internal {
650         HolderOperationalChanged(_externalHolderId, _operational);
651     }
652 
653     function _emitCountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
654         CountryCodeAdded(_countryCode, _countryId, _maxHolderCount);
655     }
656 
657     function _emitCountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
658         CountryCodeChanged(_countryCode, _countryId, _maxHolderCount);
659     }
660 
661     function _emitDayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
662         DayLimitChanged(_externalHolderId, _from, _to);
663     }
664 
665     function _emitMonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
666         MonthLimitChanged(_externalHolderId, _from, _to);
667     }
668 
669     function _emitError(uint _errorCode) internal returns (uint) {
670         Error(_errorCode);
671         return _errorCode;
672     }
673 }
674 
675 contract GroupsAccessManagerEmitter {
676 
677     event UserCreated(address user);
678     event UserDeleted(address user);
679     event GroupCreated(bytes32 groupName);
680     event GroupActivated(bytes32 groupName);
681     event GroupDeactivated(bytes32 groupName);
682     event UserToGroupAdded(address user, bytes32 groupName);
683     event UserFromGroupRemoved(address user, bytes32 groupName);
684 }
685 
686 /// @title Group Access Manager
687 ///
688 /// Base implementation
689 /// This contract serves as group manager
690 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
691 
692     uint constant USER_MANAGER_SCOPE = 111000;
693     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
694     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
695     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
696     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
697     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
698     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
699     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
700     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
701     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
702 
703     using SafeMath for uint;
704 
705     struct Member {
706         address addr;
707         uint groupsCount;
708         mapping(bytes32 => uint) groupName2index;
709         mapping(uint => uint) index2globalIndex;
710     }
711 
712     struct Group {
713         bytes32 name;
714         uint priority;
715         uint membersCount;
716         mapping(address => uint) memberAddress2index;
717         mapping(uint => uint) index2globalIndex;
718     }
719 
720     uint public membersCount;
721     mapping(uint => address) index2memberAddress;
722     mapping(address => uint) memberAddress2index;
723     mapping(address => Member) address2member;
724 
725     uint public groupsCount;
726     mapping(uint => bytes32) index2groupName;
727     mapping(bytes32 => uint) groupName2index;
728     mapping(bytes32 => Group) groupName2group;
729     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
730 
731     function() payable public {
732         revert();
733     }
734 
735     /// @notice Register user
736     /// Can be called only by contract owner
737     ///
738     /// @param _user user address
739     ///
740     /// @return code
741     function registerUser(address _user) external onlyContractOwner returns (uint) {
742         require(_user != 0x0);
743 
744         if (isRegisteredUser(_user)) {
745             return USER_MANAGER_MEMBER_ALREADY_EXIST;
746         }
747 
748         uint _membersCount = membersCount.add(1);
749         membersCount = _membersCount;
750         memberAddress2index[_user] = _membersCount;
751         index2memberAddress[_membersCount] = _user;
752         address2member[_user] = Member(_user, 0);
753 
754         UserCreated(_user);
755         return OK;
756     }
757 
758     /// @notice Discard user registration
759     /// Can be called only by contract owner
760     ///
761     /// @param _user user address
762     ///
763     /// @return code
764     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
765         require(_user != 0x0);
766 
767         uint _memberIndex = memberAddress2index[_user];
768         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
769             return USER_MANAGER_INVALID_INVOCATION;
770         }
771 
772         uint _membersCount = membersCount;
773         delete memberAddress2index[_user];
774         if (_memberIndex != _membersCount) {
775             address _lastUser = index2memberAddress[_membersCount];
776             index2memberAddress[_memberIndex] = _lastUser;
777             memberAddress2index[_lastUser] = _memberIndex;
778         }
779         delete address2member[_user];
780         delete index2memberAddress[_membersCount];
781         delete memberAddress2index[_user];
782         membersCount = _membersCount.sub(1);
783 
784         UserDeleted(_user);
785         return OK;
786     }
787 
788     /// @notice Create group
789     /// Can be called only by contract owner
790     ///
791     /// @param _groupName group name
792     /// @param _priority group priority
793     ///
794     /// @return code
795     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
796         require(_groupName != bytes32(0));
797 
798         if (isGroupExists(_groupName)) {
799             return USER_MANAGER_GROUP_ALREADY_EXIST;
800         }
801 
802         uint _groupsCount = groupsCount.add(1);
803         groupName2index[_groupName] = _groupsCount;
804         index2groupName[_groupsCount] = _groupName;
805         groupName2group[_groupName] = Group(_groupName, _priority, 0);
806         groupsCount = _groupsCount;
807 
808         GroupCreated(_groupName);
809         return OK;
810     }
811 
812     /// @notice Change group status
813     /// Can be called only by contract owner
814     ///
815     /// @param _groupName group name
816     /// @param _blocked block status
817     ///
818     /// @return code
819     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
820         require(isGroupExists(_groupName));
821         groupsBlocked[_groupName] = _blocked;
822         return OK;
823     }
824 
825     /// @notice Add users in group
826     /// Can be called only by contract owner
827     ///
828     /// @param _groupName group name
829     /// @param _users user array
830     ///
831     /// @return code
832     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
833         require(isGroupExists(_groupName));
834 
835         Group storage _group = groupName2group[_groupName];
836         uint _groupMembersCount = _group.membersCount;
837 
838         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
839             address _user = _users[_userIdx];
840             uint _memberIndex = memberAddress2index[_user];
841             require(_memberIndex != 0);
842 
843             if (_group.memberAddress2index[_user] != 0) {
844                 continue;
845             }
846 
847             _groupMembersCount = _groupMembersCount.add(1);
848             _group.memberAddress2index[_user] = _groupMembersCount;
849             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
850 
851             _addGroupToMember(_user, _groupName);
852 
853             UserToGroupAdded(_user, _groupName);
854         }
855         _group.membersCount = _groupMembersCount;
856 
857         return OK;
858     }
859 
860     /// @notice Remove users in group
861     /// Can be called only by contract owner
862     ///
863     /// @param _groupName group name
864     /// @param _users user array
865     ///
866     /// @return code
867     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
868         require(isGroupExists(_groupName));
869 
870         Group storage _group = groupName2group[_groupName];
871         uint _groupMembersCount = _group.membersCount;
872 
873         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
874             address _user = _users[_userIdx];
875             uint _memberIndex = memberAddress2index[_user];
876             uint _groupMemberIndex = _group.memberAddress2index[_user];
877 
878             if (_memberIndex == 0 || _groupMemberIndex == 0) {
879                 continue;
880             }
881 
882             if (_groupMemberIndex != _groupMembersCount) {
883                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
884                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
885                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
886                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
887             }
888             delete _group.memberAddress2index[_user];
889             delete _group.index2globalIndex[_groupMembersCount];
890             _groupMembersCount = _groupMembersCount.sub(1);
891 
892             _removeGroupFromMember(_user, _groupName);
893 
894             UserFromGroupRemoved(_user, _groupName);
895         }
896         _group.membersCount = _groupMembersCount;
897 
898         return OK;
899     }
900 
901     /// @notice Check is user registered
902     ///
903     /// @param _user user address
904     ///
905     /// @return status
906     function isRegisteredUser(address _user) public view returns (bool) {
907         return memberAddress2index[_user] != 0;
908     }
909 
910     /// @notice Check is user in group
911     ///
912     /// @param _groupName user array
913     /// @param _user user array
914     ///
915     /// @return status
916     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
917         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
918     }
919 
920     /// @notice Check is group exist
921     ///
922     /// @param _groupName group name
923     ///
924     /// @return status
925     function isGroupExists(bytes32 _groupName) public view returns (bool) {
926         return groupName2index[_groupName] != 0;
927     }
928 
929     /// @notice Get current group names
930     ///
931     /// @return group names
932     function getGroups() public view returns (bytes32[] _groups) {
933         uint _groupsCount = groupsCount;
934         _groups = new bytes32[](_groupsCount);
935         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
936             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
937         }
938     }
939 
940     // PRIVATE
941 
942     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
943         Member storage _member = address2member[_user];
944         uint _memberGroupsCount = _member.groupsCount;
945         uint _memberGroupIndex = _member.groupName2index[_groupName];
946         if (_memberGroupIndex != _memberGroupsCount) {
947             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
948             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
949             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
950             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
951         }
952         delete _member.groupName2index[_groupName];
953         delete _member.index2globalIndex[_memberGroupsCount];
954         _member.groupsCount = _memberGroupsCount.sub(1);
955     }
956 
957     function _addGroupToMember(address _user, bytes32 _groupName) private {
958         Member storage _member = address2member[_user];
959         uint _memberGroupsCount = _member.groupsCount.add(1);
960         _member.groupName2index[_groupName] = _memberGroupsCount;
961         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
962         _member.groupsCount = _memberGroupsCount;
963     }
964 }
965 
966 contract PendingManagerEmitter {
967 
968     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
969     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
970 
971     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
972     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
973     event ProtectionTxDone(bytes32 key);
974     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
975     event ProtectionTxCancelled(bytes32 key);
976     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
977     event TxDeleted(bytes32 key);
978 
979     event Error(uint errorCode);
980 
981     function _emitError(uint _errorCode) internal returns (uint) {
982         Error(_errorCode);
983         return _errorCode;
984     }
985 }
986 
987 contract PendingManagerInterface {
988 
989     function signIn(address _contract) external returns (uint);
990     function signOut(address _contract) external returns (uint);
991 
992     function addPolicyRule(
993         bytes4 _sig, 
994         address _contract, 
995         bytes32 _groupName, 
996         uint _acceptLimit, 
997         uint _declineLimit 
998         ) 
999         external returns (uint);
1000         
1001     function removePolicyRule(
1002         bytes4 _sig, 
1003         address _contract, 
1004         bytes32 _groupName
1005         ) 
1006         external returns (uint);
1007 
1008     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
1009     function deleteTx(bytes32 _key) external returns (uint);
1010 
1011     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1012     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
1013     function revoke(bytes32 _key) external returns (uint);
1014 
1015     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
1016     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
1017         bytes32[] _groupNames,
1018         uint[] _acceptLimits,
1019         uint[] _declineLimits,
1020         uint _totalAcceptedLimit,
1021         uint _totalDeclinedLimit
1022         );
1023 }
1024 
1025 /// @title PendingManager
1026 ///
1027 /// Base implementation
1028 /// This contract serves as pending manager for transaction status
1029 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
1030 
1031     uint constant NO_RECORDS_WERE_FOUND = 4;
1032     uint constant PENDING_MANAGER_SCOPE = 4000;
1033     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
1034     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
1035     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
1036     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
1037     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
1038     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
1039     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
1040     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
1041     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
1042     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
1043     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
1044 
1045     using SafeMath for uint;
1046 
1047     enum GuardState {
1048         Decline, Confirmed, InProcess
1049     }
1050 
1051     struct Requirements {
1052         bytes32 groupName;
1053         uint acceptLimit;
1054         uint declineLimit;
1055     }
1056 
1057     struct Policy {
1058         uint groupsCount;
1059         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
1060         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
1061         
1062         uint totalAcceptedLimit;
1063         uint totalDeclinedLimit;
1064 
1065         uint securesCount;
1066         mapping(uint => uint) index2txIndex;
1067         mapping(uint => uint) txIndex2index;
1068     }
1069 
1070     struct Vote {
1071         bytes32 groupName;
1072         bool accepted;
1073     }
1074 
1075     struct Guard {
1076         GuardState state;
1077         uint basePolicyIndex;
1078 
1079         uint alreadyAccepted;
1080         uint alreadyDeclined;
1081         
1082         mapping(address => Vote) votes; // member address => vote
1083         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
1084         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
1085     }
1086 
1087     address public accessManager;
1088 
1089     mapping(address => bool) public authorized;
1090 
1091     uint public policiesCount;
1092     mapping(uint => bytes32) index2PolicyId; // index => policy hash
1093     mapping(bytes32 => uint) policyId2Index; // policy hash => index
1094     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
1095 
1096     uint public txCount;
1097     mapping(uint => bytes32) index2txKey;
1098     mapping(bytes32 => uint) txKey2index; // tx key => index
1099     mapping(bytes32 => Guard) txKey2guard;
1100 
1101     /// @dev Execution is allowed only by authorized contract
1102     modifier onlyAuthorized {
1103         if (authorized[msg.sender] || address(this) == msg.sender) {
1104             _;
1105         }
1106     }
1107 
1108     /// @dev Pending Manager's constructor
1109     ///
1110     /// @param _accessManager access manager's address
1111     function PendingManager(address _accessManager) public {
1112         require(_accessManager != 0x0);
1113         accessManager = _accessManager;
1114     }
1115 
1116     function() payable public {
1117         revert();
1118     }
1119 
1120     /// @notice Update access manager address
1121     ///
1122     /// @param _accessManager access manager's address
1123     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
1124         require(_accessManager != 0x0);
1125         accessManager = _accessManager;
1126         return OK;
1127     }
1128 
1129     /// @notice Sign in contract
1130     ///
1131     /// @param _contract contract's address
1132     function signIn(address _contract) external onlyContractOwner returns (uint) {
1133         require(_contract != 0x0);
1134         authorized[_contract] = true;
1135         return OK;
1136     }
1137 
1138     /// @notice Sign out contract
1139     ///
1140     /// @param _contract contract's address
1141     function signOut(address _contract) external onlyContractOwner returns (uint) {
1142         require(_contract != 0x0);
1143         delete authorized[_contract];
1144         return OK;
1145     }
1146 
1147     /// @notice Register new policy rule
1148     /// Can be called only by contract owner
1149     ///
1150     /// @param _sig target method signature
1151     /// @param _contract target contract address
1152     /// @param _groupName group's name
1153     /// @param _acceptLimit accepted vote limit
1154     /// @param _declineLimit decline vote limit
1155     ///
1156     /// @return code
1157     function addPolicyRule(
1158         bytes4 _sig,
1159         address _contract,
1160         bytes32 _groupName,
1161         uint _acceptLimit,
1162         uint _declineLimit
1163     )
1164     onlyContractOwner
1165     external
1166     returns (uint)
1167     {
1168         require(_sig != 0x0);
1169         require(_contract != 0x0);
1170         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1171         require(_acceptLimit != 0);
1172         require(_declineLimit != 0);
1173 
1174         bytes32 _policyHash = keccak256(_sig, _contract);
1175         
1176         if (policyId2Index[_policyHash] == 0) {
1177             uint _policiesCount = policiesCount.add(1);
1178             index2PolicyId[_policiesCount] = _policyHash;
1179             policyId2Index[_policyHash] = _policiesCount;
1180             policiesCount = _policiesCount;
1181         }
1182 
1183         Policy storage _policy = policyId2policy[_policyHash];
1184         uint _policyGroupsCount = _policy.groupsCount;
1185 
1186         if (_policy.groupName2index[_groupName] == 0) {
1187             _policyGroupsCount += 1;
1188             _policy.groupName2index[_groupName] = _policyGroupsCount;
1189             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
1190             _policy.groupsCount = _policyGroupsCount;
1191         }
1192 
1193         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
1194         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
1195         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
1196         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
1197         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
1198         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
1199 
1200         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
1201         return OK;
1202     }
1203 
1204     /// @notice Remove policy rule
1205     /// Can be called only by contract owner
1206     ///
1207     /// @param _groupName group's name
1208     ///
1209     /// @return code
1210     function removePolicyRule(
1211         bytes4 _sig,
1212         address _contract,
1213         bytes32 _groupName
1214     ) 
1215     onlyContractOwner 
1216     external 
1217     returns (uint) 
1218     {
1219         require(_sig != bytes4(0));
1220         require(_contract != 0x0);
1221         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
1222 
1223         bytes32 _policyHash = keccak256(_sig, _contract);
1224         Policy storage _policy = policyId2policy[_policyHash];
1225         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
1226 
1227         if (_policyGroupNameIndex == 0) {
1228             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1229         }
1230 
1231         uint _policyGroupsCount = _policy.groupsCount;
1232         if (_policyGroupNameIndex != _policyGroupsCount) {
1233             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
1234             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
1235             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
1236         }
1237 
1238         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
1239         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
1240 
1241         delete _policy.groupName2index[_groupName];
1242         delete _policy.participatedGroups[_policyGroupsCount];
1243         _policy.groupsCount = _policyGroupsCount.sub(1);
1244 
1245         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
1246         return OK;
1247     }
1248 
1249     /// @notice Add transaction
1250     ///
1251     /// @param _key transaction id
1252     ///
1253     /// @return code
1254     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
1255         require(_key != bytes32(0));
1256         require(_sig != bytes4(0));
1257         require(_contract != 0x0);
1258 
1259         bytes32 _policyHash = keccak256(_sig, _contract);
1260         require(isPolicyExist(_policyHash));
1261 
1262         if (isTxExist(_key)) {
1263             return _emitError(PENDING_DUPLICATE_TX);
1264         }
1265 
1266         if (_policyHash == bytes32(0)) {
1267             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
1268         }
1269 
1270         uint _index = txCount.add(1);
1271         txCount = _index;
1272         index2txKey[_index] = _key;
1273         txKey2index[_key] = _index;
1274 
1275         Guard storage _guard = txKey2guard[_key];
1276         _guard.basePolicyIndex = policyId2Index[_policyHash];
1277         _guard.state = GuardState.InProcess;
1278 
1279         Policy storage _policy = policyId2policy[_policyHash];
1280         uint _counter = _policy.securesCount.add(1);
1281         _policy.securesCount = _counter;
1282         _policy.index2txIndex[_counter] = _index;
1283         _policy.txIndex2index[_index] = _counter;
1284 
1285         ProtectionTxAdded(_key, _policyHash, block.number);
1286         return OK;
1287     }
1288 
1289     /// @notice Delete transaction
1290     /// @param _key transaction id
1291     /// @return code
1292     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
1293         require(_key != bytes32(0));
1294 
1295         if (!isTxExist(_key)) {
1296             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1297         }
1298 
1299         uint _txsCount = txCount;
1300         uint _txIndex = txKey2index[_key];
1301         if (_txIndex != _txsCount) {
1302             bytes32 _last = index2txKey[txCount];
1303             index2txKey[_txIndex] = _last;
1304             txKey2index[_last] = _txIndex;
1305         }
1306 
1307         delete txKey2index[_key];
1308         delete index2txKey[_txsCount];
1309         txCount = _txsCount.sub(1);
1310 
1311         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
1312         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
1313         uint _counter = _policy.securesCount;
1314         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
1315         if (_policyTxIndex != _counter) {
1316             uint _movedTxIndex = _policy.index2txIndex[_counter];
1317             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
1318             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
1319         }
1320 
1321         delete _policy.index2txIndex[_counter];
1322         delete _policy.txIndex2index[_txIndex];
1323         _policy.securesCount = _counter.sub(1);
1324 
1325         TxDeleted(_key);
1326         return OK;
1327     }
1328 
1329     /// @notice Accept transaction
1330     /// Can be called only by registered user in GroupsAccessManager
1331     ///
1332     /// @param _key transaction id
1333     ///
1334     /// @return code
1335     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1336         if (!isTxExist(_key)) {
1337             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1338         }
1339 
1340         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1341             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1342         }
1343 
1344         Guard storage _guard = txKey2guard[_key];
1345         if (_guard.state != GuardState.InProcess) {
1346             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1347         }
1348 
1349         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
1350             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1351         }
1352 
1353         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1354         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1355         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
1356         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
1357             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1358         }
1359 
1360         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
1361         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
1362         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
1363         _guard.alreadyAccepted = _alreadyAcceptedCount;
1364 
1365         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
1366 
1367         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
1368             _guard.state = GuardState.Confirmed;
1369             ProtectionTxDone(_key);
1370         }
1371 
1372         return OK;
1373     }
1374 
1375     /// @notice Decline transaction
1376     /// Can be called only by registered user in GroupsAccessManager
1377     ///
1378     /// @param _key transaction id
1379     ///
1380     /// @return code
1381     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1382         if (!isTxExist(_key)) {
1383             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1384         }
1385 
1386         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1387             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1388         }
1389 
1390         Guard storage _guard = txKey2guard[_key];
1391         if (_guard.state != GuardState.InProcess) {
1392             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1393         }
1394 
1395         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
1396             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1397         }
1398 
1399         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1400         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1401         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
1402         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
1403             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1404         }
1405 
1406         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
1407         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
1408         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
1409         _guard.alreadyDeclined = _alreadyDeclinedCount;
1410 
1411 
1412         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
1413 
1414         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
1415             _guard.state = GuardState.Decline;
1416             ProtectionTxCancelled(_key);
1417         }
1418 
1419         return OK;
1420     }
1421 
1422     /// @notice Revoke user votes for transaction
1423     /// Can be called only by contract owner
1424     ///
1425     /// @param _key transaction id
1426     /// @param _user target user address
1427     ///
1428     /// @return code
1429     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
1430         return _revoke(_key, _user);
1431     }
1432 
1433     /// @notice Revoke vote for transaction
1434     /// Can be called only by authorized user
1435     /// @param _key transaction id
1436     /// @return code
1437     function revoke(bytes32 _key) external returns (uint) {
1438         return _revoke(_key, msg.sender);
1439     }
1440 
1441     /// @notice Check transaction status
1442     /// @param _key transaction id
1443     /// @return code
1444     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
1445         require(_key != bytes32(0));
1446 
1447         if (!isTxExist(_key)) {
1448             return NO_RECORDS_WERE_FOUND;
1449         }
1450 
1451         Guard storage _guard = txKey2guard[_key];
1452         return _guard.state == GuardState.InProcess
1453         ? PENDING_MANAGER_IN_PROCESS
1454         : _guard.state == GuardState.Confirmed
1455         ? OK
1456         : PENDING_MANAGER_REJECTED;
1457     }
1458 
1459 
1460     /// @notice Check policy details
1461     ///
1462     /// @return _groupNames group names included in policies
1463     /// @return _acceptLimits accept limit for group
1464     /// @return _declineLimits decline limit for group
1465     function getPolicyDetails(bytes4 _sig, address _contract)
1466     public
1467     view
1468     returns (
1469         bytes32[] _groupNames,
1470         uint[] _acceptLimits,
1471         uint[] _declineLimits,
1472         uint _totalAcceptedLimit,
1473         uint _totalDeclinedLimit
1474     ) {
1475         require(_sig != bytes4(0));
1476         require(_contract != 0x0);
1477         
1478         bytes32 _policyHash = keccak256(_sig, _contract);
1479         uint _policyIdx = policyId2Index[_policyHash];
1480         if (_policyIdx == 0) {
1481             return;
1482         }
1483 
1484         Policy storage _policy = policyId2policy[_policyHash];
1485         uint _policyGroupsCount = _policy.groupsCount;
1486         _groupNames = new bytes32[](_policyGroupsCount);
1487         _acceptLimits = new uint[](_policyGroupsCount);
1488         _declineLimits = new uint[](_policyGroupsCount);
1489 
1490         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1491             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1492             _groupNames[_idx] = _requirements.groupName;
1493             _acceptLimits[_idx] = _requirements.acceptLimit;
1494             _declineLimits[_idx] = _requirements.declineLimit;
1495         }
1496 
1497         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1498     }
1499 
1500     /// @notice Check policy include target group
1501     /// @param _policyHash policy hash (sig, contract address)
1502     /// @param _groupName group id
1503     /// @return bool
1504     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1505         Policy storage _policy = policyId2policy[_policyHash];
1506         return _policy.groupName2index[_groupName] != 0;
1507     }
1508 
1509     /// @notice Check is policy exist
1510     /// @param _policyHash policy hash (sig, contract address)
1511     /// @return bool
1512     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1513         return policyId2Index[_policyHash] != 0;
1514     }
1515 
1516     /// @notice Check is transaction exist
1517     /// @param _key transaction id
1518     /// @return bool
1519     function isTxExist(bytes32 _key) public view returns (bool){
1520         return txKey2index[_key] != 0;
1521     }
1522 
1523     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1524         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1525             _guard.state = GuardState.Decline;
1526         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1527             _guard.state = GuardState.Confirmed;
1528         } else if (_guard.state != GuardState.InProcess) {
1529             _guard.state = GuardState.InProcess;
1530         }
1531     }
1532 
1533     function _revoke(bytes32 _key, address _user) private returns (uint) {
1534         require(_key != bytes32(0));
1535         require(_user != 0x0);
1536 
1537         if (!isTxExist(_key)) {
1538             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1539         }
1540 
1541         Guard storage _guard = txKey2guard[_key];
1542         if (_guard.state != GuardState.InProcess) {
1543             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1544         }
1545 
1546         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1547         if (_votedGroupName == bytes32(0)) {
1548             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1549         }
1550 
1551         bool isAcceptedVote = _guard.votes[_user].accepted;
1552         if (isAcceptedVote) {
1553             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1554             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1555         } else {
1556             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1557             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1558 
1559         }
1560 
1561         delete _guard.votes[_user];
1562 
1563         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1564         return OK;
1565     }
1566 }
1567 
1568 /// @title MultiSigAdapter
1569 ///
1570 /// Abstract implementation
1571 /// This contract serves as transaction signer
1572 contract MultiSigAdapter is Object {
1573 
1574     uint constant MULTISIG_ADDED = 3;
1575     uint constant NO_RECORDS_WERE_FOUND = 4;
1576 
1577     modifier isAuthorized {
1578         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1579             _;
1580         }
1581     }
1582 
1583     /// @notice Get pending address
1584     /// @dev abstract. Needs child implementation
1585     ///
1586     /// @return pending address
1587     function getPendingManager() public view returns (address);
1588 
1589     /// @notice Sign current transaction and add it to transaction pending queue
1590     ///
1591     /// @return code
1592     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1593         bytes32 _txHash = _getKey(_args, _block);
1594         address _manager = getPendingManager();
1595 
1596         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1597         if (_code != NO_RECORDS_WERE_FOUND) {
1598             return _code;
1599         }
1600 
1601         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1602             revert();
1603         }
1604 
1605         return MULTISIG_ADDED;
1606     }
1607 
1608     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1609         bytes32 _txHash = _getKey(_args, _block);
1610         address _manager = getPendingManager();
1611         return PendingManager(_manager).isTxExist(_txHash);
1612     }
1613 
1614     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1615         _block = _block != 0 ? _block : block.number;
1616         _txHash = keccak256(msg.sig, _args, _block);
1617     }
1618 }
1619 
1620 /// @title ServiceController
1621 ///
1622 /// Base implementation
1623 /// Serves for managing service instances
1624 contract ServiceController is MultiSigAdapter {
1625 
1626     event Error(uint _errorCode);
1627 
1628     uint constant SERVICE_CONTROLLER = 350000;
1629     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1630     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1631     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1632     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1633 
1634     address public profiterole;
1635     address public treasury;
1636     address public pendingManager;
1637     address public proxy;
1638 
1639     uint public sideServicesCount;
1640     mapping(uint => address) public index2sideService;
1641     mapping(address => uint) public sideService2index;
1642     mapping(address => bool) public sideServices;
1643 
1644     uint public emissionProvidersCount;
1645     mapping(uint => address) public index2emissionProvider;
1646     mapping(address => uint) public emissionProvider2index;
1647     mapping(address => bool) public emissionProviders;
1648 
1649     uint public burningMansCount;
1650     mapping(uint => address) public index2burningMan;
1651     mapping(address => uint) public burningMan2index;
1652     mapping(address => bool) public burningMans;
1653 
1654     /// @notice Default ServiceController's constructor
1655     ///
1656     /// @param _pendingManager pending manager address
1657     /// @param _proxy ERC20 proxy address
1658     /// @param _profiterole profiterole address
1659     /// @param _treasury treasury address
1660     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1661         require(_pendingManager != 0x0);
1662         require(_proxy != 0x0);
1663         require(_profiterole != 0x0);
1664         require(_treasury != 0x0);
1665         pendingManager = _pendingManager;
1666         proxy = _proxy;
1667         profiterole = _profiterole;
1668         treasury = _treasury;
1669     }
1670 
1671     /// @notice Return pending manager address
1672     ///
1673     /// @return code
1674     function getPendingManager() public view returns (address) {
1675         return pendingManager;
1676     }
1677 
1678     /// @notice Add emission provider
1679     ///
1680     /// @param _provider emission provider address
1681     ///
1682     /// @return code
1683     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1684         if (emissionProviders[_provider]) {
1685             return _emitError(SERVICE_CONTROLLER_EMISSION_EXIST);
1686         }
1687         _code = _multisig(keccak256(_provider), _block);
1688         if (OK != _code) {
1689             return _code;
1690         }
1691 
1692         emissionProviders[_provider] = true;
1693         uint _count = emissionProvidersCount + 1;
1694         index2emissionProvider[_count] = _provider;
1695         emissionProvider2index[_provider] = _count;
1696         emissionProvidersCount = _count;
1697 
1698         return OK;
1699     }
1700 
1701     /// @notice Remove emission provider
1702     ///
1703     /// @param _provider emission provider address
1704     ///
1705     /// @return code
1706     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1707         _code = _multisig(keccak256(_provider), _block);
1708         if (OK != _code) {
1709             return _code;
1710         }
1711 
1712         uint _idx = emissionProvider2index[_provider];
1713         uint _lastIdx = emissionProvidersCount;
1714         if (_idx != 0) {
1715             if (_idx != _lastIdx) {
1716                 address _lastEmissionProvider = index2emissionProvider[_lastIdx];
1717                 index2emissionProvider[_idx] = _lastEmissionProvider;
1718                 emissionProvider2index[_lastEmissionProvider] = _idx;
1719             }
1720 
1721             delete emissionProvider2index[_provider];
1722             delete index2emissionProvider[_lastIdx];
1723             delete emissionProviders[_provider];
1724             emissionProvidersCount = _lastIdx - 1;
1725         }
1726 
1727         return OK;
1728     }
1729 
1730     /// @notice Add burning man
1731     ///
1732     /// @param _burningMan burning man address
1733     ///
1734     /// @return code
1735     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1736         if (burningMans[_burningMan]) {
1737             return _emitError(SERVICE_CONTROLLER_BURNING_MAN_EXIST);
1738         }
1739 
1740         _code = _multisig(keccak256(_burningMan), _block);
1741         if (OK != _code) {
1742             return _code;
1743         }
1744 
1745         burningMans[_burningMan] = true;
1746         uint _count = burningMansCount + 1;
1747         index2burningMan[_count] = _burningMan;
1748         burningMan2index[_burningMan] = _count;
1749         burningMansCount = _count;
1750 
1751         return OK;
1752     }
1753 
1754     /// @notice Remove burning man
1755     ///
1756     /// @param _burningMan burning man address
1757     ///
1758     /// @return code
1759     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1760         _code = _multisig(keccak256(_burningMan), _block);
1761         if (OK != _code) {
1762             return _code;
1763         }
1764 
1765         uint _idx = burningMan2index[_burningMan];
1766         uint _lastIdx = burningMansCount;
1767         if (_idx != 0) {
1768             if (_idx != _lastIdx) {
1769                 address _lastBurningMan = index2burningMan[_lastIdx];
1770                 index2burningMan[_idx] = _lastBurningMan;
1771                 burningMan2index[_lastBurningMan] = _idx;
1772             }
1773             
1774             delete burningMan2index[_burningMan];
1775             delete index2burningMan[_lastIdx];
1776             delete burningMans[_burningMan];
1777             burningMansCount = _lastIdx - 1;
1778         }
1779 
1780         return OK;
1781     }
1782 
1783     /// @notice Update a profiterole address
1784     ///
1785     /// @param _profiterole profiterole address
1786     ///
1787     /// @return result code of an operation
1788     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1789         _code = _multisig(keccak256(_profiterole), _block);
1790         if (OK != _code) {
1791             return _code;
1792         }
1793 
1794         profiterole = _profiterole;
1795         return OK;
1796     }
1797 
1798     /// @notice Update a treasury address
1799     ///
1800     /// @param _treasury treasury address
1801     ///
1802     /// @return result code of an operation
1803     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1804         _code = _multisig(keccak256(_treasury), _block);
1805         if (OK != _code) {
1806             return _code;
1807         }
1808 
1809         treasury = _treasury;
1810         return OK;
1811     }
1812 
1813     /// @notice Update pending manager address
1814     ///
1815     /// @param _pendingManager pending manager address
1816     ///
1817     /// @return result code of an operation
1818     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1819         _code = _multisig(keccak256(_pendingManager), _block);
1820         if (OK != _code) {
1821             return _code;
1822         }
1823 
1824         pendingManager = _pendingManager;
1825         return OK;
1826     }
1827 
1828     function addSideService(address _service, uint _block) public returns (uint _code) {
1829         if (sideServices[_service]) {
1830             return SERVICE_CONTROLLER_SERVICE_EXIST;
1831         }
1832         _code = _multisig(keccak256(_service), _block);
1833         if (OK != _code) {
1834             return _code;
1835         }
1836 
1837         sideServices[_service] = true;
1838         uint _count = sideServicesCount + 1;
1839         index2sideService[_count] = _service;
1840         sideService2index[_service] = _count;
1841         sideServicesCount = _count;
1842 
1843         return OK;
1844     }
1845 
1846     function removeSideService(address _service, uint _block) public returns (uint _code) {
1847         _code = _multisig(keccak256(_service), _block);
1848         if (OK != _code) {
1849             return _code;
1850         }
1851 
1852         uint _idx = sideService2index[_service];
1853         uint _lastIdx = sideServicesCount;
1854         if (_idx != 0) {
1855             if (_idx != _lastIdx) {
1856                 address _lastSideService = index2sideService[_lastIdx];
1857                 index2sideService[_idx] = _lastSideService;
1858                 sideService2index[_lastSideService] = _idx;
1859             }
1860             
1861             delete sideService2index[_service];
1862             delete index2sideService[_lastIdx];
1863             delete sideServices[_service];
1864             sideServicesCount = _lastIdx - 1;
1865         }
1866 
1867         return OK;
1868     }
1869 
1870     function getEmissionProviders()
1871     public
1872     view
1873     returns (address[] _emissionProviders)
1874     {
1875         _emissionProviders = new address[](emissionProvidersCount);
1876         for (uint _idx = 0; _idx < _emissionProviders.length; ++_idx) {
1877             _emissionProviders[_idx] = index2emissionProvider[_idx + 1];
1878         }
1879     }
1880 
1881     function getBurningMans()
1882     public
1883     view
1884     returns (address[] _burningMans)
1885     {
1886         _burningMans = new address[](burningMansCount);
1887         for (uint _idx = 0; _idx < _burningMans.length; ++_idx) {
1888             _burningMans[_idx] = index2burningMan[_idx + 1];
1889         }
1890     }
1891 
1892     function getSideServices()
1893     public
1894     view
1895     returns (address[] _sideServices)
1896     {
1897         _sideServices = new address[](sideServicesCount);
1898         for (uint _idx = 0; _idx < _sideServices.length; ++_idx) {
1899             _sideServices[_idx] = index2sideService[_idx + 1];
1900         }
1901     }
1902 
1903     /// @notice Check target address is service
1904     ///
1905     /// @param _address target address
1906     ///
1907     /// @return `true` when an address is a service, `false` otherwise
1908     function isService(address _address) public view returns (bool check) {
1909         return _address == profiterole ||
1910             _address == treasury || 
1911             _address == proxy || 
1912             _address == pendingManager || 
1913             emissionProviders[_address] || 
1914             burningMans[_address] ||
1915             sideServices[_address];
1916     }
1917 
1918     function _emitError(uint _errorCode) internal returns (uint) {
1919         Error(_errorCode);
1920         return _errorCode;
1921     }
1922 }
1923 
1924 /// @title Provides possibility manage holders? country limits and limits for holders.
1925 contract DataController is OracleMethodAdapter, DataControllerEmitter {
1926 
1927     /* CONSTANTS */
1928 
1929     uint constant DATA_CONTROLLER = 109000;
1930     uint constant DATA_CONTROLLER_ERROR = DATA_CONTROLLER + 1;
1931     uint constant DATA_CONTROLLER_CURRENT_WRONG_LIMIT = DATA_CONTROLLER + 2;
1932     uint constant DATA_CONTROLLER_WRONG_ALLOWANCE = DATA_CONTROLLER + 3;
1933     uint constant DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS = DATA_CONTROLLER + 4;
1934 
1935     uint constant MAX_TOKEN_HOLDER_NUMBER = 2 ** 256 - 1;
1936 
1937     using SafeMath for uint;
1938 
1939     /* STRUCTS */
1940 
1941     /// @title HoldersData couldn't be public because of internal structures, so needed to provide getters for different parts of _holderData
1942     struct HoldersData {
1943         uint countryCode;
1944         uint sendLimPerDay;
1945         uint sendLimPerMonth;
1946         bool operational;
1947         bytes text;
1948         uint holderAddressCount;
1949         mapping(uint => address) index2Address;
1950         mapping(address => uint) address2Index;
1951     }
1952 
1953     struct CountryLimits {
1954         uint countryCode;
1955         uint maxTokenHolderNumber;
1956         uint currentTokenHolderNumber;
1957     }
1958 
1959     /* FIELDS */
1960 
1961     address public withdrawal;
1962     address assetAddress;
1963     address public serviceController;
1964 
1965     mapping(address => uint) public allowance;
1966 
1967     // Iterable mapping pattern is used for holders.
1968     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
1969     uint public holdersCount;
1970     mapping(uint => HoldersData) holders;
1971     mapping(address => bytes32) holderAddress2Id;
1972     mapping(bytes32 => uint) public holderIndex;
1973 
1974     // This is an access address mapping. Many addresses may have access to a single holder.
1975     uint public countriesCount;
1976     mapping(uint => CountryLimits) countryLimitsList;
1977     mapping(uint => uint) countryIndex;
1978 
1979     /* MODIFIERS */
1980 
1981     modifier onlyWithdrawal {
1982         if (msg.sender != withdrawal) {
1983             revert();
1984         }
1985         _;
1986     }
1987 
1988     modifier onlyAsset {
1989         if (msg.sender == _getATxToken().getLatestVersion()) {
1990             _;
1991         }
1992     }
1993 
1994     modifier onlyContractOwner {
1995         if (msg.sender == contractOwner) {
1996             _;
1997         }
1998     }
1999 
2000     /// @notice Constructor for _holderData controller.
2001     /// @param _serviceController service controller
2002     function DataController(address _serviceController) public {
2003         require(_serviceController != 0x0);
2004 
2005         serviceController = _serviceController;
2006     }
2007 
2008     function() payable public {
2009         revert();
2010     }
2011 
2012     function setWithdraw(address _withdrawal) onlyContractOwner external returns (uint) {
2013         require(_withdrawal != 0x0);
2014         withdrawal = _withdrawal;
2015         return OK;
2016     }
2017 
2018     function setServiceController(address _serviceController) 
2019     onlyContractOwner
2020     external
2021     returns (uint)
2022     {
2023         require(_serviceController != 0x0);
2024         
2025         serviceController = _serviceController;
2026         return OK;
2027     }
2028 
2029 
2030     function getPendingManager() public view returns (address) {
2031         return ServiceController(serviceController).getPendingManager();
2032     }
2033 
2034     function getHolderInfo(bytes32 _externalHolderId) public view returns (
2035         uint _countryCode,
2036         uint _limPerDay,
2037         uint _limPerMonth,
2038         bool _operational,
2039         bytes _text
2040     ) {
2041         HoldersData storage _data = holders[holderIndex[_externalHolderId]];
2042         return (_data.countryCode, _data.sendLimPerDay, _data.sendLimPerMonth, _data.operational, _data.text);
2043     }
2044 
2045     function getHolderAddresses(bytes32 _externalHolderId) public view returns (address[] _addresses) {
2046         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2047         uint _addressesCount = _holderData.holderAddressCount;
2048         _addresses = new address[](_addressesCount);
2049         for (uint _holderAddressIdx = 0; _holderAddressIdx < _addressesCount; ++_holderAddressIdx) {
2050             _addresses[_holderAddressIdx] = _holderData.index2Address[_holderAddressIdx + 1];
2051         }
2052     }
2053 
2054     function getHolderCountryCode(bytes32 _externalHolderId) public view returns (uint) {
2055         return holders[holderIndex[_externalHolderId]].countryCode;
2056     }
2057 
2058     function getHolderExternalIdByAddress(address _address) public view returns (bytes32) {
2059         return holderAddress2Id[_address];
2060     }
2061 
2062     /// @notice Checks user is holder.
2063     /// @param _address checking address.
2064     /// @return `true` if _address is registered holder, `false` otherwise.
2065     function isRegisteredAddress(address _address) public view returns (bool) {
2066         return holderIndex[holderAddress2Id[_address]] != 0;
2067     }
2068 
2069     function isHolderOwnAddress(
2070         bytes32 _externalHolderId, 
2071         address _address
2072     ) 
2073     public 
2074     view 
2075     returns (bool) 
2076     {
2077         uint _holderIndex = holderIndex[_externalHolderId];
2078         if (_holderIndex == 0) {
2079             return false;
2080         }
2081         return holders[_holderIndex].address2Index[_address] != 0;
2082     }
2083 
2084     function getCountryInfo(uint _countryCode) 
2085     public 
2086     view 
2087     returns (
2088         uint _maxHolderNumber, 
2089         uint _currentHolderCount
2090     ) {
2091         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2092         return (_data.maxTokenHolderNumber, _data.currentTokenHolderNumber);
2093     }
2094 
2095     function getCountryLimit(uint _countryCode) public view returns (uint limit) {
2096         uint _index = countryIndex[_countryCode];
2097         require(_index != 0);
2098         return countryLimitsList[_index].maxTokenHolderNumber;
2099     }
2100 
2101     function addCountryCode(uint _countryCode) onlyContractOwner public returns (uint) {
2102         var (,_created) = _createCountryId(_countryCode);
2103         if (!_created) {
2104             return _emitError(DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS);
2105         }
2106         return OK;
2107     }
2108 
2109     /// @notice Returns holder id for the specified address, creates it if needed.
2110     /// @param _externalHolderId holder address.
2111     /// @param _countryCode country code.
2112     /// @return error code.
2113     function registerHolder(
2114         bytes32 _externalHolderId, 
2115         address _holderAddress, 
2116         uint _countryCode
2117     ) 
2118     onlyOracleOrOwner 
2119     external 
2120     returns (uint) 
2121     {
2122         require(_holderAddress != 0x0);
2123         require(holderIndex[_externalHolderId] == 0);
2124         uint _holderIndex = holderIndex[holderAddress2Id[_holderAddress]];
2125         require(_holderIndex == 0);
2126 
2127         _createCountryId(_countryCode);
2128         _holderIndex = holdersCount.add(1);
2129         holdersCount = _holderIndex;
2130 
2131         HoldersData storage _holderData = holders[_holderIndex];
2132         _holderData.countryCode = _countryCode;
2133         _holderData.operational = true;
2134         _holderData.sendLimPerDay = MAX_TOKEN_HOLDER_NUMBER;
2135         _holderData.sendLimPerMonth = MAX_TOKEN_HOLDER_NUMBER;
2136         uint _firstAddressIndex = 1;
2137         _holderData.holderAddressCount = _firstAddressIndex;
2138         _holderData.address2Index[_holderAddress] = _firstAddressIndex;
2139         _holderData.index2Address[_firstAddressIndex] = _holderAddress;
2140         holderIndex[_externalHolderId] = _holderIndex;
2141         holderAddress2Id[_holderAddress] = _externalHolderId;
2142 
2143         _emitHolderRegistered(_externalHolderId, _holderIndex, _countryCode);
2144         return OK;
2145     }
2146 
2147     /// @notice Adds new address equivalent to holder.
2148     /// @param _externalHolderId external holder identifier.
2149     /// @param _newAddress adding address.
2150     /// @return error code.
2151     function addHolderAddress(
2152         bytes32 _externalHolderId, 
2153         address _newAddress
2154     ) 
2155     onlyOracleOrOwner 
2156     external 
2157     returns (uint) 
2158     {
2159         uint _holderIndex = holderIndex[_externalHolderId];
2160         require(_holderIndex != 0);
2161 
2162         uint _newAddressId = holderIndex[holderAddress2Id[_newAddress]];
2163         require(_newAddressId == 0);
2164 
2165         HoldersData storage _holderData = holders[_holderIndex];
2166 
2167         if (_holderData.address2Index[_newAddress] == 0) {
2168             _holderData.holderAddressCount = _holderData.holderAddressCount.add(1);
2169             _holderData.address2Index[_newAddress] = _holderData.holderAddressCount;
2170             _holderData.index2Address[_holderData.holderAddressCount] = _newAddress;
2171         }
2172 
2173         holderAddress2Id[_newAddress] = _externalHolderId;
2174 
2175         _emitHolderAddressAdded(_externalHolderId, _newAddress, _holderIndex);
2176         return OK;
2177     }
2178 
2179     /// @notice Remove an address owned by a holder.
2180     /// @param _externalHolderId external holder identifier.
2181     /// @param _address removing address.
2182     /// @return error code.
2183     function removeHolderAddress(
2184         bytes32 _externalHolderId, 
2185         address _address
2186     ) 
2187     onlyOracleOrOwner 
2188     external 
2189     returns (uint) 
2190     {
2191         uint _holderIndex = holderIndex[_externalHolderId];
2192         require(_holderIndex != 0);
2193 
2194         HoldersData storage _holderData = holders[_holderIndex];
2195 
2196         uint _tempIndex = _holderData.address2Index[_address];
2197         require(_tempIndex != 0);
2198 
2199         address _lastAddress = _holderData.index2Address[_holderData.holderAddressCount];
2200         _holderData.address2Index[_lastAddress] = _tempIndex;
2201         _holderData.index2Address[_tempIndex] = _lastAddress;
2202         delete _holderData.address2Index[_address];
2203         _holderData.holderAddressCount = _holderData.holderAddressCount.sub(1);
2204 
2205         delete holderAddress2Id[_address];
2206 
2207         _emitHolderAddressRemoved(_externalHolderId, _address, _holderIndex);
2208         return OK;
2209     }
2210 
2211     /// @notice Change operational status for holder.
2212     /// Can be accessed by contract owner or oracle only.
2213     ///
2214     /// @param _externalHolderId external holder identifier.
2215     /// @param _operational operational status.
2216     ///
2217     /// @return result code.
2218     function changeOperational(
2219         bytes32 _externalHolderId, 
2220         bool _operational
2221     ) 
2222     onlyOracleOrOwner 
2223     external 
2224     returns (uint) 
2225     {
2226         uint _holderIndex = holderIndex[_externalHolderId];
2227         require(_holderIndex != 0);
2228 
2229         holders[_holderIndex].operational = _operational;
2230 
2231         _emitHolderOperationalChanged(_externalHolderId, _operational);
2232         return OK;
2233     }
2234 
2235     /// @notice Changes text for holder.
2236     /// Can be accessed by contract owner or oracle only.
2237     ///
2238     /// @param _externalHolderId external holder identifier.
2239     /// @param _text changing text.
2240     ///
2241     /// @return result code.
2242     function updateTextForHolder(
2243         bytes32 _externalHolderId, 
2244         bytes _text
2245     ) 
2246     onlyOracleOrOwner 
2247     external 
2248     returns (uint) 
2249     {
2250         uint _holderIndex = holderIndex[_externalHolderId];
2251         require(_holderIndex != 0);
2252 
2253         holders[_holderIndex].text = _text;
2254         return OK;
2255     }
2256 
2257     /// @notice Updates limit per day for holder.
2258     ///
2259     /// Can be accessed by contract owner only.
2260     ///
2261     /// @param _externalHolderId external holder identifier.
2262     /// @param _limit limit value.
2263     ///
2264     /// @return result code.
2265     function updateLimitPerDay(
2266         bytes32 _externalHolderId, 
2267         uint _limit
2268     ) 
2269     onlyOracleOrOwner 
2270     external 
2271     returns (uint) 
2272     {
2273         uint _holderIndex = holderIndex[_externalHolderId];
2274         require(_holderIndex != 0);
2275 
2276         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2277         holders[_holderIndex].sendLimPerDay = _limit;
2278 
2279         _emitDayLimitChanged(_externalHolderId, _currentLimit, _limit);
2280         return OK;
2281     }
2282 
2283     /// @notice Updates limit per month for holder.
2284     /// Can be accessed by contract owner or oracle only.
2285     ///
2286     /// @param _externalHolderId external holder identifier.
2287     /// @param _limit limit value.
2288     ///
2289     /// @return result code.
2290     function updateLimitPerMonth(
2291         bytes32 _externalHolderId, 
2292         uint _limit
2293     ) 
2294     onlyOracleOrOwner 
2295     external 
2296     returns (uint) 
2297     {
2298         uint _holderIndex = holderIndex[_externalHolderId];
2299         require(_holderIndex != 0);
2300 
2301         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2302         holders[_holderIndex].sendLimPerMonth = _limit;
2303 
2304         _emitMonthLimitChanged(_externalHolderId, _currentLimit, _limit);
2305         return OK;
2306     }
2307 
2308     /// @notice Change country limits.
2309     /// Can be accessed by contract owner or oracle only.
2310     ///
2311     /// @param _countryCode country code.
2312     /// @param _limit limit value.
2313     ///
2314     /// @return result code.
2315     function changeCountryLimit(
2316         uint _countryCode, 
2317         uint _limit
2318     ) 
2319     onlyOracleOrOwner 
2320     external 
2321     returns (uint) 
2322     {
2323         uint _countryIndex = countryIndex[_countryCode];
2324         require(_countryIndex != 0);
2325 
2326         uint _currentTokenHolderNumber = countryLimitsList[_countryIndex].currentTokenHolderNumber;
2327         if (_currentTokenHolderNumber > _limit) {
2328             return _emitError(DATA_CONTROLLER_CURRENT_WRONG_LIMIT);
2329         }
2330 
2331         countryLimitsList[_countryIndex].maxTokenHolderNumber = _limit;
2332         
2333         _emitCountryCodeChanged(_countryIndex, _countryCode, _limit);
2334         return OK;
2335     }
2336 
2337     function withdrawFrom(
2338         address _holderAddress, 
2339         uint _value
2340     ) 
2341     onlyAsset 
2342     public 
2343     returns (uint) 
2344     {
2345         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2346         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2347         _holderData.sendLimPerDay = _holderData.sendLimPerDay.sub(_value);
2348         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.sub(_value);
2349         return OK;
2350     }
2351 
2352     function depositTo(
2353         address _holderAddress, 
2354         uint _value
2355     ) 
2356     onlyAsset 
2357     public 
2358     returns (uint) 
2359     {
2360         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2361         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2362         _holderData.sendLimPerDay = _holderData.sendLimPerDay.add(_value);
2363         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.add(_value);
2364         return OK;
2365     }
2366 
2367     function updateCountryHoldersCount(
2368         uint _countryCode, 
2369         uint _updatedHolderCount
2370     ) 
2371     public 
2372     onlyAsset 
2373     returns (uint) 
2374     {
2375         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2376         assert(_data.maxTokenHolderNumber >= _updatedHolderCount);
2377         _data.currentTokenHolderNumber = _updatedHolderCount;
2378         return OK;
2379     }
2380 
2381     function changeAllowance(address _from, uint _value) public onlyWithdrawal returns (uint) {
2382         ATxAssetProxy token = _getATxToken();
2383         if (token.balanceOf(_from) < _value) {
2384             return _emitError(DATA_CONTROLLER_WRONG_ALLOWANCE);
2385         }
2386         allowance[_from] = _value;
2387         return OK;
2388     }
2389 
2390     function _createCountryId(uint _countryCode) internal returns (uint, bool _created) {
2391         uint countryId = countryIndex[_countryCode];
2392         if (countryId == 0) {
2393             uint _countriesCount = countriesCount;
2394             countryId = _countriesCount.add(1);
2395             countriesCount = countryId;
2396             CountryLimits storage limits = countryLimitsList[countryId];
2397             limits.countryCode = _countryCode;
2398             limits.maxTokenHolderNumber = MAX_TOKEN_HOLDER_NUMBER;
2399 
2400             countryIndex[_countryCode] = countryId;
2401             _emitCountryCodeAdded(countryIndex[_countryCode], _countryCode, MAX_TOKEN_HOLDER_NUMBER);
2402 
2403             _created = true;
2404         }
2405 
2406         return (countryId, _created);
2407     }
2408 
2409     function _getATxToken() private view returns (ATxAssetProxy) {
2410         ServiceController _serviceController = ServiceController(serviceController);
2411         return ATxAssetProxy(_serviceController.proxy());
2412     }
2413 }
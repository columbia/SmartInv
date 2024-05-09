1 pragma solidity >=0.5.4<0.6.0;
2 
3 contract ERC20Detailed {
4   string private _name;
5   string private _symbol;
6   uint8 private _decimals;
7 
8   constructor(string memory name, string memory symbol, uint8 decimals) public {
9     _name = name;
10     _symbol = symbol;
11     _decimals = decimals;
12   }
13 
14   function name() public view returns (string memory) {
15     return _name;
16   }
17 
18   function symbol() public view returns (string memory) {
19     return _symbol;
20   }
21 
22   function decimals() public view returns (uint8) {
23     return _decimals;
24   }
25 }
26 
27 
28 interface IERC20 {
29   function transfer(address to, uint256 value) external returns (bool);
30 
31   function approve(address spender, uint256 value) external returns (bool);
32 
33   function transferFrom(address from, address to, uint256 value) external returns (bool);
34 
35   function totalSupply() external view returns (uint256);
36 
37   function balanceOf(address who) external view returns (uint256);
38 
39   function allowance(address owner, address spender) external view returns (uint256);
40 
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract ERC20 is IERC20 {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) private _balances;
50 
51   mapping(address => mapping(address => uint256)) private _allowed;
52 
53   uint256 private _totalSupply;
54 
55   function totalSupply() public view returns (uint256) {
56     return _totalSupply;
57   }
58 
59   function balanceOf(address owner) public view returns (uint256) {
60     return _balances[owner];
61   }
62 
63   function allowance(address owner, address spender) public view returns (uint256) {
64     return _allowed[owner][spender];
65   }
66 
67   function transfer(address to, uint256 value) public returns (bool) {
68     _transfer(msg.sender, to, value);
69     return true;
70   }
71 
72   function approve(address spender, uint256 value) public returns (bool) {
73     _approve(msg.sender, spender, value);
74     return true;
75   }
76 
77   function transferFrom(address from, address to, uint256 value) public returns (bool) {
78     _transfer(from, to, value);
79     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
80     return true;
81   }
82 
83   function _transfer(address from, address to, uint256 value) internal {
84     require(to != address(0));
85 
86     _balances[from] = _balances[from].sub(value);
87     _balances[to] = _balances[to].add(value);
88     emit Transfer(from, to, value);
89   }
90 
91   function _mint(address account, uint256 value) internal {
92     require(account != address(0));
93 
94     _totalSupply = _totalSupply.add(value);
95     _balances[account] = _balances[account].add(value);
96     emit Transfer(address(0), account, value);
97   }
98 
99   function _burn(address account, uint256 value) internal {
100     require(account != address(0));
101 
102     _totalSupply = _totalSupply.sub(value);
103     _balances[account] = _balances[account].sub(value);
104     emit Transfer(account, address(0), value);
105   }
106 
107   function _approve(address owner, address spender, uint256 value) internal {
108     require(spender != address(0));
109     require(owner != address(0));
110 
111     _allowed[owner][spender] = value;
112     emit Approval(owner, spender, value);
113   }
114 }
115 
116 
117 contract Ownable {
118   address private _owner;
119 
120   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122   constructor() internal {
123     _owner = msg.sender;
124     emit OwnershipTransferred(address(0), _owner);
125   }
126 
127   function owner() public view returns (address) {
128     return _owner;
129   }
130 
131   modifier onlyOwner() {
132     require(isOwner());
133     _;
134   }
135 
136   function isOwner() public view returns (bool) {
137     return msg.sender == _owner;
138   }
139 
140   function transferOwnership(address newOwner) public onlyOwner {
141     _transferOwnership(newOwner);
142   }
143 
144   function _transferOwnership(address newOwner) internal {
145     require(newOwner != address(0));
146     emit OwnershipTransferred(_owner, newOwner);
147     _owner = newOwner;
148   }
149 }
150 
151 library MultiSigAction {
152   struct Action {
153     uint8 actionType;
154     address callbackAddress;
155     string callbackSig;
156     bytes callbackData;
157     uint8 quorum;
158     address requestedBy;
159     address rejectedBy;
160     mapping(address => bool) approvedBy;
161     uint8 numOfApprovals;
162     bool rejected;
163     bool failed;
164   }
165 
166   function init(
167     Action storage _self,
168     uint8 _actionType,
169     address _callbackAddress,
170     string memory _callbackSig,
171     bytes memory _callbackData,
172     uint8 _quorum
173   ) internal {
174     _self.actionType = _actionType;
175     _self.callbackAddress = _callbackAddress;
176     _self.callbackSig = _callbackSig;
177     _self.callbackData = _callbackData;
178     _self.quorum = _quorum;
179     _self.requestedBy = msg.sender;
180   }
181 
182   function approve(Action storage _self) internal {
183     require(!_self.rejected, "CANNOT_APPROVE_REJECTED");
184     require(!_self.failed, "CANNOT_APPROVE_FAILED");
185     require(!_self.approvedBy[msg.sender], "CANNOT_APPROVE_AGAIN");
186     require(!isCompleted(_self), "CANNOT_APPROVE_COMPLETED");
187 
188     _self.approvedBy[msg.sender] = true;
189     _self.numOfApprovals++;
190   }
191 
192   function reject(Action storage _self) internal {
193     require(!_self.approvedBy[msg.sender], "CANNOT_REJECT_APPROVED");
194     require(!_self.failed, "CANNOT_REJECT_FAILED");
195     require(!_self.rejected, "CANNOT_REJECT_REJECTED");
196     require(!isCompleted(_self), "CANNOT_REJECT_COMPLETED");
197 
198     _self.rejectedBy = msg.sender;
199     _self.rejected = true;
200   }
201 
202   function complete(Action storage _self) internal {
203     require(!_self.rejected, "CANNOT_COMPLETE_REJECTED");
204     require(!_self.failed, "CANNOT_COMPLETE_FAILED");
205     require(isCompleted(_self), "CANNNOT_COMPLETE_AGAIN");
206 
207     // solium-disable-next-line security/no-low-level-calls
208     (bool _success, ) = _self.callbackAddress.call(
209       abi.encodePacked(bytes4(keccak256(bytes(_self.callbackSig))), _self.callbackData)
210     );
211 
212     if (!_success) {
213       _self.failed = true;
214     }
215   }
216 
217   function isCompleted(Action storage _self) internal view returns (bool) {
218     return _self.numOfApprovals >= _self.quorum && !_self.failed;
219   }
220 }
221 
222 
223 library SafeMath {
224   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225     require(b <= a);
226     uint256 c = a - b;
227 
228     return c;
229   }
230 
231   function add(uint256 a, uint256 b) internal pure returns (uint256) {
232     uint256 c = a + b;
233     require(c >= a);
234 
235     return c;
236   }
237 }
238 
239 contract ERC20Extended is Ownable, ERC20, ERC20Detailed {
240   constructor(string memory _name, string memory _symbol, uint8 _decimals)
241     public
242     ERC20Detailed(_name, _symbol, _decimals)
243   {}
244 
245   function burn(uint256 _value) public onlyOwner returns (bool) {
246     _burn(msg.sender, _value);
247     return true;
248   }
249 
250   function mint(address _to, uint256 _value) public onlyOwner returns (bool) {
251     _mint(_to, _value);
252 
253     return true;
254   }
255 }
256 
257 contract MultiSigAdministration {
258   event TenantRegistered(
259     address indexed tenant,
260     address[] creators,
261     address[] admins,
262     uint8 quorum
263   );
264   event ActionInitiated(address indexed tenant, uint256 indexed id, address initiatedBy);
265   event ActionApproved(address indexed tenant, uint256 indexed id, address approvedBy);
266   event ActionRejected(address indexed tenant, uint256 indexed id, address rejectedBy);
267   event ActionCompleted(address indexed tenant, uint256 indexed id);
268   event ActionFailed(address indexed tenant, uint256 indexed id);
269 
270   using MultiSigAction for MultiSigAction.Action;
271 
272   enum AdminAction {ADD_ADMIN, REMOVE_ADMIN, CHANGE_QUORUM, ADD_CREATOR, REMOVE_CREATOR}
273   uint8 private constant OTHER_ACTION = uint8(AdminAction.REMOVE_CREATOR) + 1;
274 
275   mapping(address => uint256) public numOfActions;
276   mapping(address => mapping(address => bool)) public isAdmin;
277   mapping(address => uint8) public numOfAdmins;
278   mapping(address => mapping(address => bool)) public isCreator;
279   mapping(address => uint8) public quorums;
280   mapping(address => bool) public isRegistered;
281   mapping(address => uint256) public minValidActionId;
282 
283   mapping(address => mapping(uint256 => MultiSigAction.Action)) private actions;
284 
285   modifier onlyAdminOf(address _tenant) {
286     require(isAdmin[_tenant][msg.sender], "ONLY_ADMIN_OF_TENANT");
287 
288     _;
289   }
290 
291   modifier onlyAdminOrCreatorOf(address _tenant) {
292     require(
293       isAdmin[_tenant][msg.sender] || isCreator[_tenant][msg.sender],
294       "ONLY_ADMIN_OR_CREATOR_OF_TENANT"
295     );
296 
297     _;
298   }
299 
300   modifier onlyRegistered(address _tenant) {
301     require(isRegistered[_tenant], "ONLY_REGISTERED_TENANT");
302 
303     _;
304   }
305 
306   modifier onlyMe() {
307     require(msg.sender == address(this), "ONLY_INTERNAL");
308 
309     _;
310   }
311 
312   modifier onlyExistingAction(address _tenant, uint256 _id) {
313     require(_id <= numOfActions[_tenant], "ONLY_EXISTING_ACTION");
314     require(_id > 0, "ONLY_EXISTING_ACTION");
315 
316     _;
317   }
318 
319   constructor() public {}
320 
321   /* Public Functions - Start */
322   function register(
323     address _tenant,
324     address[] memory _creators,
325     address[] memory _admins,
326     uint8 _quorum
327   ) public returns (bool success) {
328     require(
329       msg.sender == _tenant || msg.sender == Ownable(_tenant).owner(),
330       "ONLY_TENANT_OR_TENANT_OWNER"
331     );
332 
333     return _register(_tenant, _creators, _admins, _quorum);
334   }
335 
336   function initiateAdminAction(
337     address _tenant,
338     AdminAction _adminAction,
339     bytes memory _callbackData
340   ) public onlyRegistered(_tenant) onlyAdminOf(_tenant) returns (uint256 id) {
341     string memory _callbackSig = _getAdminActionCallbackSig(_adminAction);
342 
343     uint256 _id = _initiateAction(
344       uint8(_adminAction),
345       _tenant,
346       address(this),
347       _callbackSig,
348       abi.encodePacked(abi.encode(_tenant), _callbackData)
349     );
350     _approveAction(_tenant, _id);
351 
352     return _id;
353   }
354 
355   function initiateAction(address _tenant, string memory _callbackSig, bytes memory _callbackData)
356     public
357     onlyRegistered(_tenant)
358     onlyAdminOrCreatorOf(_tenant)
359     returns (uint256 id)
360   {
361     uint256 _id = _initiateAction(OTHER_ACTION, _tenant, _tenant, _callbackSig, _callbackData);
362 
363     if (isAdmin[_tenant][msg.sender]) {
364       _approveAction(_tenant, _id);
365     }
366 
367     return _id;
368   }
369 
370   function approveAction(address _tenant, uint256 _id)
371     public
372     onlyRegistered(_tenant)
373     onlyAdminOf(_tenant)
374     onlyExistingAction(_tenant, _id)
375     returns (bool success)
376   {
377     return _approveAction(_tenant, _id);
378   }
379 
380   function rejectAction(address _tenant, uint256 _id)
381     public
382     onlyRegistered(_tenant)
383     onlyAdminOrCreatorOf(_tenant)
384     onlyExistingAction(_tenant, _id)
385     returns (bool success)
386   {
387     return _rejectAction(_tenant, _id);
388   }
389 
390   function addAdmin(address _tenant, address _admin, bool _increaseQuorum) public onlyMe {
391     minValidActionId[_tenant] = numOfActions[_tenant] + 1;
392     _addAdmin(_tenant, _admin);
393 
394     if (_increaseQuorum) {
395       uint8 _quorum = quorums[_tenant];
396       uint8 _newQuorum = _quorum + 1;
397       require(_newQuorum > _quorum, "OVERFLOW");
398 
399       _changeQuorum(_tenant, _newQuorum);
400     }
401   }
402 
403   function removeAdmin(address _tenant, address _admin, bool _decreaseQuorum) public onlyMe {
404     uint8 _quorum = quorums[_tenant];
405 
406     if (_decreaseQuorum && _quorum > 1) {
407       _changeQuorum(_tenant, _quorum - 1);
408     }
409 
410     minValidActionId[_tenant] = numOfActions[_tenant] + 1;
411     _removeAdmin(_tenant, _admin);
412   }
413 
414   function changeQuorum(address _tenant, uint8 _quorum) public onlyMe {
415     minValidActionId[_tenant] = numOfActions[_tenant] + 1;
416     _changeQuorum(_tenant, _quorum);
417   }
418 
419   function addCreator(address _tenant, address _creator) public onlyMe {
420     _addCreator(_tenant, _creator);
421   }
422 
423   function removeCreator(address _tenant, address _creator) public onlyMe {
424     _removeCreator(_tenant, _creator);
425   }
426 
427   function getAction(address _tenant, uint256 _id)
428     public
429     view
430     returns (
431     bool isAdminAction,
432     string memory callbackSig,
433     bytes memory callbackData,
434     uint8 quorum,
435     address requestedBy,
436     address rejectedBy,
437     uint8 numOfApprovals,
438     bool rejected,
439     bool failed,
440     bool completed,
441     bool valid
442   )
443   {
444     MultiSigAction.Action storage _action = _getAction(_tenant, _id);
445 
446     isAdminAction = _action.callbackAddress == address(this);
447     callbackSig = _action.callbackSig;
448     callbackData = _action.callbackData;
449     quorum = _action.quorum;
450     requestedBy = _action.requestedBy;
451     rejectedBy = _action.rejectedBy;
452     numOfApprovals = _action.numOfApprovals;
453     rejected = _action.rejected;
454     failed = _action.failed;
455     completed = _action.isCompleted();
456     valid = _isActionValid(_tenant, _id);
457   }
458 
459   function hasApprovedBy(address _tenant, uint256 _id, address _admin)
460     public
461     view
462     returns (bool approvedBy)
463   {
464     approvedBy = _getAction(_tenant, _id).approvedBy[_admin];
465   }
466   /* Public Functions - End */
467 
468   /* Private Functions - Start */
469   function _getAction(address _tenant, uint256 _id)
470     private
471     view
472     returns (MultiSigAction.Action storage)
473   {
474     return actions[_tenant][_id];
475   }
476 
477   function _isActionValid(address _tenant, uint256 _id) private view returns (bool) {
478     return _id >= minValidActionId[_tenant];
479   }
480 
481   function _getAdminActionCallbackSig(AdminAction _adminAction)
482     private
483     pure
484     returns (string memory)
485   {
486     if (_adminAction == AdminAction.ADD_ADMIN) {
487       return "addAdmin(address,address,bool)";
488     }
489 
490     if (_adminAction == AdminAction.REMOVE_ADMIN) {
491       return "removeAdmin(address,address,bool)";
492     }
493 
494     if (_adminAction == AdminAction.CHANGE_QUORUM) {
495       return "changeQuorum(address,uint8)";
496     }
497 
498     if (_adminAction == AdminAction.ADD_CREATOR) {
499       return "addCreator(address,address)";
500     }
501 
502     return "removeCreator(address,address)";
503   }
504 
505   function _addCreator(address _tenant, address _creator) private {
506     require(_creator != address(this), "INVALID_CREATOR");
507     require(!isAdmin[_tenant][_creator], "ALREADY_ADMIN");
508     require(!isCreator[_tenant][_creator], "ALREADY_CREATOR");
509 
510     isCreator[_tenant][_creator] = true;
511   }
512 
513   function _removeCreator(address _tenant, address _creator) private {
514     require(isCreator[_tenant][_creator], "NOT_CREATOR");
515 
516     isCreator[_tenant][_creator] = false;
517   }
518 
519   function _addAdmin(address _tenant, address _admin) private {
520     require(_admin != address(this), "INVALID_ADMIN");
521     require(!isAdmin[_tenant][_admin], "ALREADY_ADMIN");
522     require(!isCreator[_tenant][_admin], "ALREADY_CREATOR");
523     require(numOfAdmins[_tenant] + 1 > numOfAdmins[_tenant], "OVERFLOW");
524 
525     numOfAdmins[_tenant]++;
526     isAdmin[_tenant][_admin] = true;
527   }
528 
529   function _removeAdmin(address _tenant, address _admin) private {
530     require(isAdmin[_tenant][_admin], "NOT_ADMIN");
531     require(--numOfAdmins[_tenant] >= quorums[_tenant], "TOO_FEW_ADMINS");
532 
533     isAdmin[_tenant][_admin] = false;
534   }
535 
536   function _changeQuorum(address _tenant, uint8 _quorum) private {
537     require(_quorum <= numOfAdmins[_tenant], "QUORUM_TOO_BIG");
538     require(_quorum > 0, "QUORUM_ZERO");
539 
540     quorums[_tenant] = _quorum;
541   }
542 
543   function _register(
544     address _tenant,
545     address[] memory _creators,
546     address[] memory _admins,
547     uint8 _quorum
548   ) private returns (bool) {
549     require(_tenant != address(this), "INVALID_TENANT");
550     require(!isRegistered[_tenant], "ALREADY_REGISTERED");
551 
552     for (uint8 i = 0; i < _admins.length; i++) {
553       _addAdmin(_tenant, _admins[i]);
554     }
555     _changeQuorum(_tenant, _quorum);
556 
557     for (uint8 i = 0; i < _creators.length; i++) {
558       _addCreator(_tenant, _creators[i]);
559     }
560 
561     isRegistered[_tenant] = true;
562     emit TenantRegistered(_tenant, _creators, _admins, _quorum);
563 
564     return true;
565   }
566 
567   function _initiateAction(
568     uint8 _actionType,
569     address _tenant,
570     address _callbackAddress,
571     string memory _callbackSig,
572     bytes memory _callbackData
573   ) private returns (uint256) {
574     uint256 _id = ++numOfActions[_tenant];
575     uint8 _quorum = quorums[_tenant];
576 
577     if (_actionType == uint8(AdminAction.REMOVE_ADMIN)) {
578       require(numOfAdmins[_tenant] > 1, "TOO_FEW_ADMINS");
579 
580       if (_quorum == numOfAdmins[_tenant] && _quorum > 2) {
581         _quorum = numOfAdmins[_tenant] - 1;
582       }
583     }
584 
585     _getAction(_tenant, _id).init(
586       _actionType,
587       _callbackAddress,
588       _callbackSig,
589       _callbackData,
590       _quorum
591     );
592 
593     emit ActionInitiated(_tenant, _id, msg.sender);
594 
595     return _id;
596   }
597 
598   function _approveAction(address _tenant, uint256 _id) private returns (bool) {
599     require(_isActionValid(_tenant, _id), "ACTION_INVALIDATED");
600 
601     MultiSigAction.Action storage _action = _getAction(_tenant, _id);
602     _action.approve();
603     emit ActionApproved(_tenant, _id, msg.sender);
604 
605     if (_action.isCompleted()) {
606       _action.complete();
607 
608       if (_action.failed) {
609         emit ActionFailed(_tenant, _id);
610       } else {
611         emit ActionCompleted(_tenant, _id);
612       }
613     }
614 
615     return true;
616   }
617 
618   function _rejectAction(address _tenant, uint256 _id) private returns (bool) {
619     MultiSigAction.Action storage _action = _getAction(_tenant, _id);
620 
621     if (isCreator[_tenant][msg.sender]) {
622       require(msg.sender == _action.requestedBy, "CREATOR_REJECT_NOT_REQUESTOR");
623     }
624 
625     if (_action.actionType == uint8(AdminAction.REMOVE_ADMIN)) {
626       (, address _admin, ) = abi.decode(_action.callbackData, (address, address, bool));
627 
628       require(_admin != msg.sender, "CANNOT_REJECT_ITS_OWN_REMOVAL");
629     }
630 
631     _action.reject();
632 
633     emit ActionRejected(_tenant, _id, msg.sender);
634 
635     return true;
636   }
637   /* Private Functions - End */
638 }
639 
640 contract MultiSigProxyOwner {
641   event BurnRequested(address indexed owner, uint256 value);
642   event BurnCanceled(address indexed owner);
643   event BurnMinSet(uint256 burnMin);
644 
645   struct BurnRequest {
646     uint256 actionId;
647     uint256 value;
648   }
649 
650   uint256 public burnMin;
651   mapping(address => BurnRequest) public burnRequests;
652 
653   ERC20Extended private token;
654   MultiSigAdministration private multiSigAdmin;
655   address[] private creators;
656 
657   modifier onlyMultiSigAdministration {
658     require(msg.sender == address(multiSigAdmin));
659 
660     _;
661   }
662 
663   constructor(
664     address _token,
665     address _multiSigAdmin,
666     address[] memory _admins,
667     uint8 _quorum,
668     uint256 _burnMin
669   ) public {
670     token = ERC20Extended(_token);
671     multiSigAdmin = MultiSigAdministration(_multiSigAdmin);
672     burnMin = _burnMin;
673 
674     creators.push(address(this));
675     multiSigAdmin.register(address(this), creators, _admins, _quorum);
676 
677   }
678 
679   function requestBurn(uint256 _value) public returns (bool) {
680     require(!_burnRequestExist(msg.sender), "BURN_REQUEST_EXISTS");
681     require(_value >= burnMin, "SMALLER_THAN_MIN_BURN_AMOUNT");
682 
683     token.transferFrom(msg.sender, address(this), _value);
684     burnRequests[msg.sender].value = _value;
685     burnRequests[msg.sender].actionId = multiSigAdmin.initiateAction(
686       address(this),
687       "burn(address,uint256)",
688       abi.encode(msg.sender, _value)
689     );
690 
691     emit BurnRequested(msg.sender, _value);
692 
693     return true;
694   }
695 
696   function cancelBurn() public returns (bool) {
697     uint256 _actionId = burnRequests[msg.sender].actionId;
698     uint256 _value = burnRequests[msg.sender].value;
699     _deleteBurnRequest(msg.sender);
700 
701     // solium-disable-next-line security/no-low-level-calls
702     (bool _success, ) = address(multiSigAdmin).call(
703       abi.encodeWithSignature("rejectAction(address,uint256)", address(this), _actionId)
704     );
705     _success;
706     token.transfer(msg.sender, _value);
707 
708     emit BurnCanceled(msg.sender);
709 
710     return true;
711   }
712 
713   function burn(address _owner, uint256 _value) public onlyMultiSigAdministration returns (bool) {
714     require(burnRequests[_owner].value == _value, "BURN_VALUE_MISMATCH");
715 
716     _deleteBurnRequest(_owner);
717     token.burn(_value);
718 
719     return true;
720   }
721 
722   function mint(address _to, uint256 _value) public onlyMultiSigAdministration returns (bool) {
723     return token.mint(_to, _value);
724   }
725 
726   function transferOwnership(address _newOwner) public onlyMultiSigAdministration returns (bool) {
727     token.transferOwnership(_newOwner);
728 
729     return true;
730   }
731 
732   function setBurnMin(uint256 _burnMin) public onlyMultiSigAdministration returns (bool) {
733     return _setBurnMin(_burnMin);
734   }
735 
736   function _setBurnMin(uint256 _burnMin) internal returns (bool) {
737     burnMin = _burnMin;
738     emit BurnMinSet(_burnMin);
739 
740     return true;
741   }
742 
743   function _burnRequestExist(address _owner) internal view returns (bool) {
744     return burnRequests[_owner].actionId != 0;
745   }
746 
747   function _deleteBurnRequest(address _owner) internal returns (bool) {
748     require(_burnRequestExist(_owner), "NO_BURN_REQUEST_EXISTS");
749 
750     burnRequests[_owner].actionId = 0;
751     burnRequests[_owner].value = 0;
752 
753     return true;
754   }
755 }
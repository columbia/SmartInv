1 pragma solidity ^0.5.11;
2 
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     
10     function add(Role storage role, address account) internal {
11         require(!has(role, account), "Roles: account already has role");
12         role.bearer[account] = true;
13     }
14 
15     
16     function remove(Role storage role, address account) internal {
17         require(has(role, account), "Roles: account does not have role");
18         role.bearer[account] = false;
19     }
20 
21     
22     function has(Role storage role, address account) internal view returns (bool) {
23         require(account != address(0), "Roles: account is the zero address");
24         return role.bearer[account];
25     }
26 }
27 
28 contract RBACed {
29     using Roles for Roles.Role;
30 
31     event RoleAdded(string _role);
32     event RoleAccessorAdded(string _role, address indexed _address);
33     event RoleAccessorRemoved(string _role, address indexed _address);
34 
35     string constant public OWNER_ROLE = "OWNER";
36 
37     string[] public roles;
38     mapping(bytes32 => uint256) roleIndexByName;
39     mapping(bytes32 => Roles.Role) private roleByName;
40 
41     
42     constructor()
43     public
44     {
45         
46         _addRole(OWNER_ROLE);
47 
48         
49         _addRoleAccessor(OWNER_ROLE, msg.sender);
50     }
51 
52     modifier onlyRoleAccessor(string memory _role) {
53         require(isRoleAccessor(_role, msg.sender), "RBACed: sender is not accessor of the role");
54         _;
55     }
56 
57     
58     
59     function rolesCount()
60     public
61     view
62     returns (uint256)
63     {
64         return roles.length;
65     }
66 
67     
68     
69     
70     function isRole(string memory _role)
71     public
72     view
73     returns (bool)
74     {
75         return 0 != roleIndexByName[_role2Key(_role)];
76     }
77 
78     
79     
80     function addRole(string memory _role)
81     public
82     onlyRoleAccessor(OWNER_ROLE)
83     {
84         
85         _addRole(_role);
86 
87         
88         emit RoleAdded(_role);
89     }
90 
91     
92     
93     
94     
95     function isRoleAccessor(string memory _role, address _address)
96     public
97     view
98     returns (bool)
99     {
100         return roleByName[_role2Key(_role)].has(_address);
101     }
102 
103     
104     
105     
106     function addRoleAccessor(string memory _role, address _address)
107     public
108     onlyRoleAccessor(OWNER_ROLE)
109     {
110         
111         _addRoleAccessor(_role, _address);
112 
113         
114         emit RoleAccessorAdded(_role, _address);
115     }
116 
117     
118     
119     
120     function removeRoleAccessor(string memory _role, address _address)
121     public
122     onlyRoleAccessor(OWNER_ROLE)
123     {
124         
125         roleByName[_role2Key(_role)].remove(_address);
126 
127         
128         emit RoleAccessorRemoved(_role, _address);
129     }
130 
131     function _addRole(string memory _role)
132     internal
133     {
134         if (0 == roleIndexByName[_role2Key(_role)]) {
135             roles.push(_role);
136             roleIndexByName[_role2Key(_role)] = roles.length;
137         }
138     }
139 
140     function _addRoleAccessor(string memory _role, address _address)
141     internal
142     {
143         roleByName[_role2Key(_role)].add(_address);
144     }
145 
146     function _role2Key(string memory _role)
147     internal
148     pure
149     returns (bytes32)
150     {
151         return keccak256(abi.encodePacked(_role));
152     }
153 }
154 
155 library SafeMath {
156     
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a, "SafeMath: addition overflow");
160 
161         return c;
162     }
163 
164     
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         require(b <= a, "SafeMath: subtraction overflow");
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         
175         
176         
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         
190         require(b > 0, "SafeMath: division by zero");
191         uint256 c = a / b;
192         
193 
194         return c;
195     }
196 
197     
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         require(b != 0, "SafeMath: modulo by zero");
200         return a % b;
201     }
202 }
203 
204 library AddressStoreLib {
205 
206     struct Addresses {
207         mapping(bytes32 => uint256) map;
208         address[] list;
209     }
210 
211     function has(Addresses storage _addresses, address _address) internal view returns (bool) {
212         return (0 != _addresses.map[address2Key(_address)]);
213     }
214 
215     function add(Addresses storage _addresses, address _address) internal {
216         bytes32 key = address2Key(_address);
217         if (_addresses.map[key] == 0) {
218             _addresses.list.push(_address);
219             _addresses.map[key] = _addresses.list.length;
220         }
221     }
222 
223     function remove(Addresses storage _addresses, address _address) internal {
224         bytes32 key = address2Key(_address);
225         if (_addresses.map[key] != 0) {
226             if (_addresses.map[key] < _addresses.list.length) {
227                 _addresses.list[_addresses.map[key] - 1] = _addresses.list[_addresses.list.length - 1];
228                 _addresses.map[address2Key(address(_addresses.list[_addresses.map[key] - 1]))] = _addresses.map[key];
229                 delete _addresses.list[_addresses.list.length - 1];
230             }
231             _addresses.list.length--;
232             _addresses.map[key] = 0;
233         }
234     }
235 
236     function address2Key(address _address) private pure returns (bytes32) {
237         return keccak256(abi.encodePacked(_address));
238     }
239 }
240 
241 contract Resolvable {
242     
243     function resolveIfCriteriaMet()
244     public;
245 
246     
247     
248     function resolutionCriteriaMet()
249     public
250     view
251     returns (bool);
252 
253     
254     
255     
256     function resolutionDeltaAmount(bool _status)
257     public
258     view
259     returns (uint256);
260 }
261 
262 contract Able {
263     event Disabled(string _name);
264     event Enabled(string _name);
265 
266     mapping(string => bool) private _disabled;
267 
268     
269     
270     function enable(string memory _name)
271     public
272     {
273         
274         require(_disabled[_name], "Able: name is enabled");
275 
276         
277         _disabled[_name] = false;
278 
279         
280         emit Enabled(_name);
281     }
282 
283     
284     
285     function disable(string memory _name)
286     public
287     {
288         
289         require(!_disabled[_name], "Able: name is disabled");
290 
291         
292         _disabled[_name] = true;
293 
294         
295         emit Disabled(_name);
296     }
297 
298     
299     
300     function enabled(string memory _name)
301     public
302     view
303     returns (bool)
304     {
305         return !_disabled[_name];
306     }
307 
308     
309     
310     function disabled(string memory _name)
311     public
312     view
313     returns (bool)
314     {
315         return _disabled[_name];
316     }
317 
318     modifier onlyEnabled(string memory _name) {
319         require(enabled(_name), "Able: name is disabled");
320         _;
321     }
322 
323     modifier onlyDisabled(string memory _name) {
324         require(disabled(_name), "Able: name is enabled");
325         _;
326     }
327 }
328 
329 library VerificationPhaseLib {
330     using SafeMath for uint256;
331 
332     enum State {Unopened, Opened, Closed}
333     enum Status {Null, True, False}
334 
335     struct VerificationPhase {
336         State state;
337         Status result;
338 
339         uint256 stakedAmount;
340         mapping(bool => uint256) stakedAmountByStatus;
341         mapping(address => mapping(bool => uint256)) stakedAmountByWalletStatus;
342         mapping(uint256 => mapping(bool => uint256)) stakedAmountByBlockStatus;
343 
344         mapping(address => bool) stakedByWallet;
345         uint256 stakingWallets;
346 
347         uint256 bountyAmount;
348         bool bountyAwarded;
349 
350         uint256 startBlock;
351         uint256 endBlock;
352 
353         uint256[] uintCriteria;
354     }
355 
356     function open(VerificationPhase storage _phase, uint256 _bountyAmount) internal {
357         _phase.state = State.Opened;
358         _phase.bountyAmount = _bountyAmount;
359         _phase.startBlock = block.number;
360     }
361 
362     function close(VerificationPhase storage _phase) internal {
363         _phase.state = State.Closed;
364         _phase.endBlock = block.number;
365         if (_phase.stakedAmountByStatus[true] > _phase.stakedAmountByStatus[false])
366             _phase.result = Status.True;
367         else if (_phase.stakedAmountByStatus[true] < _phase.stakedAmountByStatus[false])
368             _phase.result = Status.False;
369     }
370 
371     function stake(VerificationPhase storage _phase, address _wallet,
372         bool _status, uint256 _amount) internal {
373         _phase.stakedAmount = _phase.stakedAmount.add(_amount);
374         _phase.stakedAmountByStatus[_status] = _phase.stakedAmountByStatus[_status].add(_amount);
375         _phase.stakedAmountByWalletStatus[_wallet][_status] =
376         _phase.stakedAmountByWalletStatus[_wallet][_status].add(_amount);
377         _phase.stakedAmountByBlockStatus[block.number][_status] =
378         _phase.stakedAmountByBlockStatus[block.number][_status].add(_amount);
379 
380         if (!_phase.stakedByWallet[_wallet]) {
381             _phase.stakedByWallet[_wallet] = true;
382             _phase.stakingWallets = _phase.stakingWallets.add(1);
383         }
384     }
385 }
386 
387 interface IERC20 {
388     
389     function totalSupply() external view returns (uint256);
390 
391     
392     function balanceOf(address account) external view returns (uint256);
393 
394     
395     function transfer(address recipient, uint256 amount) external returns (bool);
396 
397     
398     function allowance(address owner, address spender) external view returns (uint256);
399 
400     
401     function approve(address spender, uint256 amount) external returns (bool);
402 
403     
404     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
405 
406     
407     event Transfer(address indexed from, address indexed to, uint256 value);
408 
409     
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 }
412 
413 contract ERC20 is IERC20 {
414     using SafeMath for uint256;
415 
416     mapping (address => uint256) private _balances;
417 
418     mapping (address => mapping (address => uint256)) private _allowances;
419 
420     uint256 private _totalSupply;
421 
422     
423     function totalSupply() public view returns (uint256) {
424         return _totalSupply;
425     }
426 
427     
428     function balanceOf(address account) public view returns (uint256) {
429         return _balances[account];
430     }
431 
432     
433     function transfer(address recipient, uint256 amount) public returns (bool) {
434         _transfer(msg.sender, recipient, amount);
435         return true;
436     }
437 
438     
439     function allowance(address owner, address spender) public view returns (uint256) {
440         return _allowances[owner][spender];
441     }
442 
443     
444     function approve(address spender, uint256 value) public returns (bool) {
445         _approve(msg.sender, spender, value);
446         return true;
447     }
448 
449     
450     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
451         _transfer(sender, recipient, amount);
452         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
453         return true;
454     }
455 
456     
457     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
458         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
459         return true;
460     }
461 
462     
463     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
464         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
465         return true;
466     }
467 
468     
469     function _transfer(address sender, address recipient, uint256 amount) internal {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _balances[sender] = _balances[sender].sub(amount);
474         _balances[recipient] = _balances[recipient].add(amount);
475         emit Transfer(sender, recipient, amount);
476     }
477 
478     
479     function _mint(address account, uint256 amount) internal {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _totalSupply = _totalSupply.add(amount);
483         _balances[account] = _balances[account].add(amount);
484         emit Transfer(address(0), account, amount);
485     }
486 
487      
488     function _burn(address account, uint256 value) internal {
489         require(account != address(0), "ERC20: burn from the zero address");
490 
491         _totalSupply = _totalSupply.sub(value);
492         _balances[account] = _balances[account].sub(value);
493         emit Transfer(account, address(0), value);
494     }
495 
496     
497     function _approve(address owner, address spender, uint256 value) internal {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = value;
502         emit Approval(owner, spender, value);
503     }
504 
505     
506     function _burnFrom(address account, uint256 amount) internal {
507         _burn(account, amount);
508         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
509     }
510 }
511 
512 interface Allocator {
513     
514     function allocate()
515     external
516     view
517     returns (uint256);
518 }
519 
520 contract BountyFund is RBACed {
521     using SafeMath for uint256;
522 
523     event ResolutionEngineSet(address indexed _resolutionEngine);
524     event TokensDeposited(address indexed _wallet, uint256 _amount, uint256 _balance);
525     event TokensAllocated(address indexed _wallet, address indexed _allocator,
526         uint256 _amount, uint256 _balance);
527     event Withdrawn(address indexed _wallet, uint256 _amount);
528 
529     ERC20 public token;
530 
531     address public operator;
532     address public resolutionEngine;
533 
534     
535     constructor(address _token, address _operator)
536     public
537     {
538         
539         token = ERC20(_token);
540 
541         
542         operator = _operator;
543     }
544 
545     modifier onlyResolutionEngine() {
546         require(msg.sender == resolutionEngine, "BountyFund: sender is not the defined resolution engine");
547         _;
548     }
549 
550     modifier onlyOperator() {
551         require(msg.sender == operator, "BountyFund: sender is not the defined operator");
552         _;
553     }
554 
555     
556     
557     
558     function setResolutionEngine(address _resolutionEngine)
559     public
560     {
561         require(address(0) != _resolutionEngine, "BountyFund: resolution engine argument is zero address");
562         require(address(0) == resolutionEngine, "BountyFund: resolution engine has already been set");
563 
564         
565         resolutionEngine = _resolutionEngine;
566 
567         
568         emit ResolutionEngineSet(_resolutionEngine);
569     }
570 
571     
572     
573     
574     function depositTokens(uint256 _amount)
575     public
576     {
577         
578         token.transferFrom(msg.sender, address(this), _amount);
579 
580         
581         emit TokensDeposited(msg.sender, _amount, token.balanceOf(address(this)));
582     }
583 
584     
585     
586     function allocateTokens(address _allocator)
587     public
588     onlyResolutionEngine
589     returns (uint256)
590     {
591         
592         uint256 amount = Allocator(_allocator).allocate();
593 
594         
595         token.transfer(msg.sender, amount);
596 
597         
598         emit TokensAllocated(msg.sender, _allocator, amount, token.balanceOf(address(this)));
599 
600         
601         return amount;
602     }
603 
604     
605     
606     function withdraw(address _wallet)
607     public
608     onlyOperator
609     {
610         
611         uint256 amount = token.balanceOf(address(this));
612 
613         
614         token.transfer(_wallet, amount);
615 
616         
617         emit Withdrawn(_wallet, amount);
618     }
619 }
620 
621 contract ResolutionEngine is Resolvable, RBACed, Able {
622     using SafeMath for uint256;
623     using VerificationPhaseLib for VerificationPhaseLib.VerificationPhase;
624 
625     event Frozen();
626     event BountyAllocatorSet(address indexed _bountyAllocator);
627     event Staked(address indexed _wallet, uint256 indexed _verificationPhaseNumber, bool _status,
628         uint256 _amount);
629     event BountyWithdrawn(address indexed _wallet, uint256 _bountyAmount);
630     event VerificationPhaseOpened(uint256 indexed _verificationPhaseNumber, uint256 _bountyAmount);
631     event VerificationPhaseClosed(uint256 indexed _verificationPhaseNumber);
632     event PayoutStaged(address indexed _wallet, uint256 indexed _firstVerificationPhaseNumber,
633         uint256 indexed _lastVerificationPhaseNumber, uint256 _payout);
634     event StakeStaged(address indexed _wallet, uint _amount);
635     event Staged(address indexed _wallet, uint _amount);
636     event Withdrawn(address indexed _wallet, uint _amount);
637 
638     string constant public STAKE_ACTION = "STAKE";
639     string constant public RESOLVE_ACTION = "RESOLVE";
640 
641     address public oracle;
642     address public operator;
643     address public bountyAllocator;
644 
645     BountyFund public bountyFund;
646 
647     ERC20 public token;
648 
649     bool public frozen;
650 
651     uint256 public verificationPhaseNumber;
652 
653     mapping(uint256 => VerificationPhaseLib.VerificationPhase) public verificationPhaseByPhaseNumber;
654 
655     mapping(address => mapping(bool => uint256)) public stakedAmountByWalletStatus;
656     mapping(uint256 => mapping(bool => uint256)) public stakedAmountByBlockStatus;
657 
658     VerificationPhaseLib.Status public verificationStatus;
659 
660     mapping(address => mapping(uint256 => bool)) public payoutStagedByWalletPhase;
661     mapping(address => uint256) public stagedAmountByWallet;
662 
663     
664     constructor(address _oracle, address _operator, address _bountyFund)
665     public
666     {
667         
668         oracle = _oracle;
669         operator = _operator;
670 
671         
672         bountyFund = BountyFund(_bountyFund);
673         bountyFund.setResolutionEngine(address(this));
674 
675         
676         token = ERC20(bountyFund.token());
677     }
678 
679     modifier onlyOracle() {
680         require(msg.sender == oracle, "ResolutionEngine: sender is not the defined oracle");
681         _;
682     }
683 
684     modifier onlyOperator() {
685         require(msg.sender == operator, "ResolutionEngine: sender is not the defined operator");
686         _;
687     }
688 
689     modifier onlyNotFrozen() {
690         require(!frozen, "ResolutionEngine: is frozen");
691         _;
692     }
693 
694     
695     
696     function freeze()
697     public
698     onlyRoleAccessor(OWNER_ROLE)
699     {
700         
701         frozen = true;
702 
703         
704         emit Frozen();
705     }
706 
707     
708     
709     function setBountyAllocator(address _bountyAllocator)
710     public
711     onlyRoleAccessor(OWNER_ROLE)
712     {
713         
714         bountyAllocator = _bountyAllocator;
715 
716         
717         emit BountyAllocatorSet(bountyAllocator);
718     }
719 
720     
721     function initialize()
722     public
723     onlyRoleAccessor(OWNER_ROLE)
724     {
725         
726         require(0 == verificationPhaseNumber, "ResolutionEngine: already initialized");
727 
728         
729         _openVerificationPhase();
730     }
731 
732     
733     
734     function disable(string memory _action)
735     public
736     onlyOperator
737     {
738         
739         super.disable(_action);
740     }
741 
742     
743     
744     function enable(string memory _action)
745     public
746     onlyOperator
747     {
748         
749         super.enable(_action);
750     }
751 
752     
753     
754     
755     
756     
757     function stake(address _wallet, bool _status, uint256 _amount)
758     public
759     onlyOracle
760     onlyEnabled(STAKE_ACTION)
761     {
762         
763         stakedAmountByWalletStatus[_wallet][_status] = stakedAmountByWalletStatus[_wallet][_status].add(_amount);
764         stakedAmountByBlockStatus[block.number][_status] = stakedAmountByBlockStatus[block.number][_status]
765         .add(_amount);
766         verificationPhaseByPhaseNumber[verificationPhaseNumber].stake(_wallet, _status, _amount);
767 
768         
769         emit Staked(_wallet, verificationPhaseNumber, _status, _amount);
770     }
771 
772     
773     
774     
775     function resolveIfCriteriaMet()
776     public
777     onlyOracle
778     onlyEnabled(RESOLVE_ACTION)
779     {
780         
781         if (resolutionCriteriaMet()) {
782             
783             _closeVerificationPhase();
784 
785             
786             _openVerificationPhase();
787         }
788     }
789 
790     
791     
792     
793     function metricsByVerificationPhaseNumber(uint256 _verificationPhaseNumber)
794     public
795     view
796     returns (VerificationPhaseLib.State state, uint256 trueStakeAmount, uint256 falseStakeAmount,
797         uint256 stakeAmount, uint256 numberOfWallets, uint256 bountyAmount, bool bountyAwarded,
798         uint256 startBlock, uint256 endBlock, uint256 numberOfBlocks)
799     {
800         state = verificationPhaseByPhaseNumber[_verificationPhaseNumber].state;
801         trueStakeAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber].stakedAmountByStatus[true];
802         falseStakeAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber].stakedAmountByStatus[false];
803         stakeAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber].stakedAmount;
804         numberOfWallets = verificationPhaseByPhaseNumber[_verificationPhaseNumber].stakingWallets;
805         bountyAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber].bountyAmount;
806         bountyAwarded = verificationPhaseByPhaseNumber[_verificationPhaseNumber].bountyAwarded;
807         startBlock = verificationPhaseByPhaseNumber[_verificationPhaseNumber].startBlock;
808         endBlock = verificationPhaseByPhaseNumber[_verificationPhaseNumber].endBlock;
809         numberOfBlocks = (startBlock > 0 && endBlock == 0 ? block.number : endBlock).sub(startBlock);
810     }
811 
812     
813     
814     
815     
816     
817     function metricsByVerificationPhaseNumberAndWallet(uint256 _verificationPhaseNumber, address _wallet)
818     public
819     view
820     returns (uint256 trueStakeAmount, uint256 falseStakeAmount, uint256 stakeAmount)
821     {
822         trueStakeAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber]
823         .stakedAmountByWalletStatus[_wallet][true];
824         falseStakeAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber]
825         .stakedAmountByWalletStatus[_wallet][false];
826         stakeAmount = trueStakeAmount.add(falseStakeAmount);
827     }
828 
829     
830     
831     
832     function metricsByWallet(address _wallet)
833     public
834     view
835     returns (uint256 trueStakeAmount, uint256 falseStakeAmount, uint256 stakeAmount)
836     {
837         trueStakeAmount = stakedAmountByWalletStatus[_wallet][true];
838         falseStakeAmount = stakedAmountByWalletStatus[_wallet][false];
839         stakeAmount = trueStakeAmount.add(falseStakeAmount);
840     }
841 
842     
843     
844     
845     
846     function metricsByBlockNumber(uint256 _blockNumber)
847     public
848     view
849     returns (uint256 trueStakeAmount, uint256 falseStakeAmount, uint256 stakeAmount)
850     {
851         trueStakeAmount = stakedAmountByBlockStatus[_blockNumber][true];
852         falseStakeAmount = stakedAmountByBlockStatus[_blockNumber][false];
853         stakeAmount = trueStakeAmount.add(falseStakeAmount);
854     }
855 
856     
857     
858     
859     
860     
861     function calculatePayout(address _wallet, uint256 _firstVerificationPhaseNumber,
862         uint256 _lastVerificationPhaseNumber)
863     public
864     view
865     returns (uint256)
866     {
867         
868         uint256 payout = 0;
869         for (uint256 i = _firstVerificationPhaseNumber; i <= _lastVerificationPhaseNumber; i++)
870             payout = payout.add(_calculatePayout(_wallet, i));
871 
872         
873         return payout;
874     }
875 
876     
877     
878     
879     
880     
881     function stagePayout(address _wallet, uint256 _firstVerificationPhaseNumber,
882         uint256 _lastVerificationPhaseNumber)
883     public
884     onlyOracle
885     {
886         
887         uint256 amount = 0;
888         for (uint256 i = _firstVerificationPhaseNumber; i <= _lastVerificationPhaseNumber; i++)
889             amount = amount.add(_stagePayout(_wallet, i));
890 
891         
892         emit PayoutStaged(_wallet, _firstVerificationPhaseNumber, _lastVerificationPhaseNumber, amount);
893     }
894 
895     
896     
897     
898     function stageStake(address _wallet)
899     public
900     onlyOracle
901     onlyDisabled(RESOLVE_ACTION)
902     {
903         
904         uint256 amount = verificationPhaseByPhaseNumber[verificationPhaseNumber]
905         .stakedAmountByWalletStatus[_wallet][true].add(
906             verificationPhaseByPhaseNumber[verificationPhaseNumber]
907             .stakedAmountByWalletStatus[_wallet][false]
908         );
909 
910         
911         require(0 < amount, "ResolutionEngine: stake is zero");
912 
913         
914         verificationPhaseByPhaseNumber[verificationPhaseNumber].stakedAmountByWalletStatus[_wallet][true] = 0;
915         verificationPhaseByPhaseNumber[verificationPhaseNumber].stakedAmountByWalletStatus[_wallet][false] = 0;
916 
917         
918         _stage(_wallet, amount);
919 
920         
921         emit StakeStaged(_wallet, amount);
922     }
923 
924     
925     
926     
927     
928     function stage(address _wallet, uint256 _amount)
929     public
930     onlyOracle
931     {
932         
933         _stage(_wallet, _amount);
934 
935         
936         emit Staged(_wallet, _amount);
937     }
938 
939     
940     
941     
942     
943     function withdraw(address _wallet, uint256 _amount)
944     public
945     onlyOracle
946     {
947         
948         require(_amount <= stagedAmountByWallet[_wallet], "ResolutionEngine: amount is greater than staged amount");
949 
950         
951         stagedAmountByWallet[_wallet] = stagedAmountByWallet[_wallet].sub(_amount);
952 
953         
954         token.transfer(_wallet, _amount);
955 
956         
957         emit Withdrawn(_wallet, _amount);
958     }
959 
960     
961     
962     function withdrawBounty(address _wallet)
963     public
964     onlyOperator
965     onlyDisabled(RESOLVE_ACTION)
966     {
967         
968         require(0 < verificationPhaseByPhaseNumber[verificationPhaseNumber].bountyAmount,
969             "ResolutionEngine: bounty is zero");
970 
971         
972         uint256 amount = verificationPhaseByPhaseNumber[verificationPhaseNumber].bountyAmount;
973 
974         
975         verificationPhaseByPhaseNumber[verificationPhaseNumber].bountyAmount = 0;
976 
977         
978         token.transfer(_wallet, amount);
979 
980         
981         emit BountyWithdrawn(_wallet, amount);
982     }
983 
984     
985     function _openVerificationPhase()
986     internal
987     {
988         
989         require(
990             verificationPhaseByPhaseNumber[verificationPhaseNumber.add(1)].state == VerificationPhaseLib.State.Unopened,
991             "ResolutionEngine: verification phase is not in unopened state"
992         );
993 
994         
995         verificationPhaseNumber = verificationPhaseNumber.add(1);
996 
997         
998         uint256 bountyAmount = bountyFund.allocateTokens(bountyAllocator);
999 
1000         
1001         verificationPhaseByPhaseNumber[verificationPhaseNumber].open(bountyAmount);
1002 
1003         
1004         _addVerificationCriteria();
1005 
1006         
1007         emit VerificationPhaseOpened(verificationPhaseNumber, bountyAmount);
1008     }
1009 
1010     
1011     function _addVerificationCriteria() internal;
1012 
1013     
1014     function _closeVerificationPhase()
1015     internal
1016     {
1017         
1018         require(verificationPhaseByPhaseNumber[verificationPhaseNumber].state == VerificationPhaseLib.State.Opened,
1019             "ResolutionEngine: verification phase is not in opened state");
1020 
1021         
1022         verificationPhaseByPhaseNumber[verificationPhaseNumber].close();
1023 
1024         
1025         if (verificationPhaseByPhaseNumber[verificationPhaseNumber].result != verificationStatus) {
1026             
1027             verificationStatus = verificationPhaseByPhaseNumber[verificationPhaseNumber].result;
1028 
1029             
1030             verificationPhaseByPhaseNumber[verificationPhaseNumber].bountyAwarded = true;
1031         }
1032 
1033         
1034         emit VerificationPhaseClosed(verificationPhaseNumber);
1035     }
1036 
1037     
1038     function _calculatePayout(address _wallet, uint256 _verificationPhaseNumber)
1039     internal
1040     view
1041     returns (uint256)
1042     {
1043         
1044         if (VerificationPhaseLib.Status.Null == verificationPhaseByPhaseNumber[_verificationPhaseNumber].result)
1045             return 0;
1046 
1047         
1048         bool status =
1049         verificationPhaseByPhaseNumber[_verificationPhaseNumber].result == VerificationPhaseLib.Status.True;
1050 
1051         
1052         uint256 lot = verificationPhaseByPhaseNumber[_verificationPhaseNumber].stakedAmountByStatus[!status];
1053 
1054         
1055         if (verificationPhaseByPhaseNumber[_verificationPhaseNumber].bountyAwarded)
1056             lot = lot.add(verificationPhaseByPhaseNumber[_verificationPhaseNumber].bountyAmount);
1057 
1058         
1059         uint256 walletStatusAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber]
1060         .stakedAmountByWalletStatus[_wallet][status];
1061         uint256 statusAmount = verificationPhaseByPhaseNumber[_verificationPhaseNumber]
1062         .stakedAmountByStatus[status];
1063 
1064         
1065         
1066         return lot.mul(walletStatusAmount).div(statusAmount).add(walletStatusAmount);
1067     }
1068 
1069     
1070     function _stagePayout(address _wallet, uint256 _verificationPhaseNumber)
1071     internal
1072     returns (uint256)
1073     {
1074         
1075         if (VerificationPhaseLib.State.Closed != verificationPhaseByPhaseNumber[_verificationPhaseNumber].state)
1076             return 0;
1077 
1078         
1079         if (payoutStagedByWalletPhase[_wallet][_verificationPhaseNumber])
1080             return 0;
1081 
1082         
1083         payoutStagedByWalletPhase[_wallet][_verificationPhaseNumber] = true;
1084 
1085         
1086         uint256 payout = _calculatePayout(_wallet, _verificationPhaseNumber);
1087 
1088         
1089         _stage(_wallet, payout);
1090 
1091         
1092         return payout;
1093     }
1094 
1095     
1096     function _stage(address _wallet, uint256 _amount)
1097     internal
1098     {
1099         stagedAmountByWallet[_wallet] = stagedAmountByWallet[_wallet].add(_amount);
1100     }
1101 }
1102 
1103 contract Oracle is RBACed {
1104     using SafeMath for uint256;
1105     using AddressStoreLib for AddressStoreLib.Addresses;
1106 
1107     event ResolutionEngineAdded(address indexed _resolutionEngine);
1108     event ResolutionEngineRemoved(address indexed _resolutionEngine);
1109     event TokensStaked(address indexed _wallet, address indexed _resolutionEngine,
1110         bool _status, uint256 _amount);
1111     event PayoutStaged(address indexed _wallet, address indexed _resolutionEngine,
1112         uint256 _firstVerificationPhaseNumber, uint256 _lastVerificationPhaseNumber);
1113     event StakeStaged(address indexed _wallet, address indexed _resolutionEngine);
1114     event Withdrawn(address indexed _wallet, address indexed _resolutionEngine,
1115         uint256 _amount);
1116 
1117     AddressStoreLib.Addresses resolutionEngines;
1118 
1119     
1120     constructor()
1121     public
1122     {
1123     }
1124 
1125     modifier onlyRegisteredResolutionEngine(address _resolutionEngine) {
1126         require(hasResolutionEngine(_resolutionEngine), "Oracle: Resolution engine is not registered");
1127         _;
1128     }
1129 
1130     
1131     
1132     
1133     function hasResolutionEngine(address _resolutionEngine)
1134     public
1135     view
1136     returns
1137     (bool)
1138     {
1139         return resolutionEngines.has(_resolutionEngine);
1140     }
1141 
1142     
1143     
1144     function resolutionEnginesCount()
1145     public
1146     view
1147     returns (uint256)
1148     {
1149         return resolutionEngines.list.length;
1150     }
1151 
1152     
1153     
1154     function addResolutionEngine(address _resolutionEngine)
1155     public
1156     onlyRoleAccessor(OWNER_ROLE)
1157     {
1158         
1159         resolutionEngines.add(_resolutionEngine);
1160 
1161         
1162         emit ResolutionEngineAdded(_resolutionEngine);
1163     }
1164 
1165     
1166     
1167     function removeResolutionEngine(address _resolutionEngine)
1168     public
1169     onlyRoleAccessor(OWNER_ROLE)
1170     {
1171         
1172         resolutionEngines.remove(_resolutionEngine);
1173 
1174         
1175         emit ResolutionEngineRemoved(_resolutionEngine);
1176     }
1177 
1178     
1179     
1180     
1181     
1182     
1183     
1184     
1185     function stake(address _resolutionEngine, uint256 _verificationPhaseNumber, bool _status, uint256 _amount)
1186     public
1187     onlyRegisteredResolutionEngine(_resolutionEngine)
1188     {
1189         
1190         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1191 
1192         
1193         require(resolutionEngine.verificationPhaseNumber() == _verificationPhaseNumber,
1194             "Oracle: not the current verification phase number");
1195 
1196         
1197         uint256 resolutionDeltaAmount = resolutionEngine.resolutionDeltaAmount(_status);
1198         uint256 overageAmount = _amount > resolutionDeltaAmount ?
1199         _amount.sub(resolutionDeltaAmount) :
1200         0;
1201 
1202         
1203         ERC20 token = ERC20(resolutionEngine.token());
1204 
1205         
1206         token.transferFrom(msg.sender, _resolutionEngine, _amount);
1207 
1208         
1209         if (overageAmount > 0)
1210             resolutionEngine.stage(msg.sender, overageAmount);
1211 
1212         
1213         resolutionEngine.stake(msg.sender, _status, _amount.sub(overageAmount));
1214 
1215         
1216         resolutionEngine.resolveIfCriteriaMet();
1217 
1218         
1219         emit TokensStaked(msg.sender, _resolutionEngine, _status, _amount);
1220     }
1221 
1222     
1223     
1224     
1225     
1226     
1227     
1228     
1229     function calculatePayout(address _resolutionEngine, address _wallet, uint256 _firstVerificationPhaseNumber,
1230         uint256 _lastVerificationPhaseNumber)
1231     public
1232     view
1233     returns (uint256)
1234     {
1235         
1236         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1237 
1238         
1239         return resolutionEngine.calculatePayout(_wallet, _firstVerificationPhaseNumber, _lastVerificationPhaseNumber);
1240     }
1241 
1242     
1243     
1244     
1245     
1246     function stagePayout(address _resolutionEngine, uint256 _firstVerificationPhaseNumber,
1247         uint256 _lastVerificationPhaseNumber)
1248     public
1249     {
1250         
1251         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1252 
1253         
1254         resolutionEngine.stagePayout(msg.sender, _firstVerificationPhaseNumber, _lastVerificationPhaseNumber);
1255 
1256         
1257         emit PayoutStaged(msg.sender, _resolutionEngine, _firstVerificationPhaseNumber, _lastVerificationPhaseNumber);
1258     }
1259 
1260     
1261     
1262     function stageStake(address _resolutionEngine)
1263     public
1264     {
1265         
1266         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1267 
1268         
1269         resolutionEngine.stageStake(msg.sender);
1270 
1271         
1272         emit StakeStaged(msg.sender, _resolutionEngine);
1273     }
1274 
1275     
1276     
1277     
1278     
1279     function stagedAmountByWallet(address _resolutionEngine, address _wallet)
1280     public
1281     view
1282     returns (uint256)
1283     {
1284         
1285         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1286 
1287         
1288         return resolutionEngine.stagedAmountByWallet(_wallet);
1289     }
1290 
1291     
1292     
1293     
1294     function withdraw(address _resolutionEngine, uint256 _amount)
1295     public
1296     {
1297         
1298         ResolutionEngine resolutionEngine = ResolutionEngine(_resolutionEngine);
1299 
1300         
1301         resolutionEngine.withdraw(msg.sender, _amount);
1302 
1303         
1304         emit Withdrawn(msg.sender, _resolutionEngine, _amount);
1305     }
1306 }
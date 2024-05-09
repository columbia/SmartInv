1 pragma solidity 0.4.17;
2 
3 library IdeaUint {
4 
5     function add(uint a, uint b) constant internal returns (uint result) {
6         uint c = a + b;
7 
8         assert(c >= a);
9 
10         return c;
11     }
12 
13     function sub(uint a, uint b) constant internal returns (uint result) {
14         uint c = a - b;
15 
16         assert(b <= a);
17 
18         return c;
19     }
20 
21     function mul(uint a, uint b) constant internal returns (uint result) {
22         uint c = a * b;
23 
24         assert(a == 0 || c / a == b);
25 
26         return c;
27     }
28 
29     function div(uint a, uint b) constant internal returns (uint result) {
30         uint c = a / b;
31 
32         return c;
33     }
34 }
35 
36 contract IdeaBasicCoin {
37     using IdeaUint for uint;
38 
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint public totalSupply;
43     mapping(address => uint) balances;
44     mapping(address => mapping(address => uint)) allowed;
45     address[] public accounts;
46     mapping(address => bool) internal accountsMap;
47     address public owner;
48 
49     event Transfer(address indexed _from, address indexed _to, uint _value);
50     event Approval(address indexed _owner, address indexed _spender, uint _value);
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function balanceOf(address _owner) constant public returns (uint balance) {
58         return balances[_owner];
59     }
60 
61     function transfer(address _to, uint _value) public returns (bool success) {
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         tryCreateAccount(_to);
65 
66         Transfer(msg.sender, _to, _value);
67 
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
72         uint _allowance = allowed[_from][msg.sender];
73 
74         balances[_from] = balances[_from].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         allowed[_from][msg.sender] = _allowance.sub(_value);
77         tryCreateAccount(_to);
78 
79         Transfer(_from, _to, _value);
80 
81         return true;
82     }
83 
84     function approve(address _spender, uint _value) public returns (bool success) {
85         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87         allowed[msg.sender][_spender] = _value;
88 
89         Approval(msg.sender, _spender, _value);
90 
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
99         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100 
101         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102 
103         return true;
104     }
105 
106     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
107         uint oldValue = allowed[msg.sender][_spender];
108 
109         if (_subtractedValue > oldValue) {
110             allowed[msg.sender][_spender] = 0;
111         } else {
112             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113         }
114 
115         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116 
117         return true;
118     }
119 
120     function tryCreateAccount(address _account) internal {
121         if (!accountsMap[_account]) {
122             accounts.push(_account);
123             accountsMap[_account] = true;
124         }
125     }
126 }
127 
128 contract IdeaCoin is IdeaBasicCoin {
129 
130     uint public earnedEthWei;
131     uint public soldIdeaWei;
132     uint public soldIdeaWeiPreIco;
133     uint public soldIdeaWeiIco;
134     uint public soldIdeaWeiPostIco;
135     uint public icoStartTimestamp;
136     mapping(address => uint) public pieBalances;
137     address[] public pieAccounts;
138     mapping(address => bool) internal pieAccountsMap;
139     uint public nextRoundReserve;
140     address[] public projects;
141     address public projectAgent;
142     address public bank1;
143     address public bank2;
144     uint public bank1Val;
145     uint public bank2Val;
146     uint public bankValReserve;
147 
148     enum IcoStates {
149     Coming,
150     PreIco,
151     Ico,
152     PostIco,
153     Done
154     }
155 
156     IcoStates public icoState;
157 
158     function IdeaCoin() {
159         name = 'IdeaCoin';
160         symbol = 'IDEA';
161         decimals = 18;
162         totalSupply = 100000000 ether;
163 
164         owner = msg.sender;
165         tryCreateAccount(msg.sender);
166     }
167 
168     function() payable {
169         uint tokens;
170         bool moreThenPreIcoMin = msg.value >= 0 ether;
171         uint totalVal = msg.value + bankValReserve;
172         uint halfVal = totalVal / 2;
173 
174         if (icoState == IcoStates.PreIco && moreThenPreIcoMin && soldIdeaWeiPreIco <= 2500000 ether) {
175 
176             tokens = msg.value * 15000;
177             balances[msg.sender] += tokens;
178             soldIdeaWeiPreIco += tokens;
179 
180         } else if (icoState == IcoStates.Ico && soldIdeaWeiIco <= 35000000 ether) {
181             uint elapsed = now - icoStartTimestamp;
182 
183             if (elapsed <= 1 days) {
184 
185                 tokens = msg.value * 12500;
186                 balances[msg.sender] += tokens;
187 
188             } else if (elapsed <= 6 days && elapsed > 1 days) {
189 
190                 tokens = msg.value * 11500;
191                 balances[msg.sender] += tokens;
192 
193             } else if (elapsed <= 11 days && elapsed > 6 days) {
194 
195                 tokens = msg.value * 11000;
196                 balances[msg.sender] += tokens;
197 
198             } else if (elapsed <= 16 days && elapsed > 11 days) {
199 
200                 tokens = msg.value * 10500;
201                 balances[msg.sender] += tokens;
202 
203             } else {
204 
205                 tokens = msg.value * 10000;
206                 balances[msg.sender] += tokens;
207 
208             }
209 
210             soldIdeaWeiIco += tokens;
211 
212         } else if (icoState == IcoStates.PostIco && soldIdeaWeiPostIco <= 12000000 ether) {
213 
214             tokens = msg.value * 5000;
215             balances[msg.sender] += tokens;
216             soldIdeaWeiPostIco += tokens;
217 
218         } else {
219             revert();
220         }
221 
222         earnedEthWei += msg.value;
223         soldIdeaWei += tokens;
224 
225         bank1Val += halfVal;
226         bank2Val += halfVal;
227         bankValReserve = totalVal - (halfVal * 2);
228 
229         tryCreateAccount(msg.sender);
230     }
231 
232     function setBank(address _bank1, address _bank2) public onlyOwner {
233         require(bank1 == address(0x0));
234         require(bank2 == address(0x0));
235         require(_bank1 != address(0x0));
236         require(_bank2 != address(0x0));
237 
238         bank1 = _bank1;
239         bank2 = _bank2;
240 
241         balances[bank1] = 500000 ether;
242         balances[bank2] = 500000 ether;
243     }
244 
245     function startPreIco() public onlyOwner {
246         icoState = IcoStates.PreIco;
247     }
248 
249     function stopPreIcoAndBurn() public onlyOwner {
250         stopAnyIcoAndBurn(
251         (2500000 ether - soldIdeaWeiPreIco) * 2
252         );
253         balances[bank1] += soldIdeaWeiPreIco / 2;
254         balances[bank2] += soldIdeaWeiPreIco / 2;
255     }
256 
257     function startIco() public onlyOwner {
258         icoState = IcoStates.Ico;
259         icoStartTimestamp = now;
260     }
261 
262     function stopIcoAndBurn() public onlyOwner {
263         stopAnyIcoAndBurn(
264         (35000000 ether - soldIdeaWeiIco) * 2
265         );
266         balances[bank1] += soldIdeaWeiIco / 2;
267         balances[bank2] += soldIdeaWeiIco / 2;
268     }
269 
270     function startPostIco() public onlyOwner {
271         icoState = IcoStates.PostIco;
272     }
273 
274     function stopPostIcoAndBurn() public onlyOwner {
275         stopAnyIcoAndBurn(
276         (12000000 ether - soldIdeaWeiPostIco) * 2
277         );
278         balances[bank1] += soldIdeaWeiPostIco / 2;
279         balances[bank2] += soldIdeaWeiPostIco / 2;
280     }
281 
282     function stopAnyIcoAndBurn(uint _burn) internal {
283         icoState = IcoStates.Coming;
284         totalSupply = totalSupply.sub(_burn);
285     }
286 
287     function withdrawEther() public {
288         require(msg.sender == bank1 || msg.sender == bank2);
289 
290         if (msg.sender == bank1) {
291             bank1.transfer(bank1Val);
292             bank1Val = 0;
293         }
294 
295         if (msg.sender == bank2) {
296             bank2.transfer(bank2Val);
297             bank2Val = 0;
298         }
299 
300         if (bank1Val == 0 && bank2Val == 0 && this.balance != 0) {
301             owner.transfer(this.balance);
302         }
303     }
304 
305     function pieBalanceOf(address _owner) constant public returns (uint balance) {
306         return pieBalances[_owner];
307     }
308 
309     function transferToPie(uint _amount) public returns (bool success) {
310         balances[msg.sender] = balances[msg.sender].sub(_amount);
311         pieBalances[msg.sender] = pieBalances[msg.sender].add(_amount);
312         tryCreatePieAccount(msg.sender);
313 
314         return true;
315     }
316 
317     function transferFromPie(uint _amount) public returns (bool success) {
318         pieBalances[msg.sender] = pieBalances[msg.sender].sub(_amount);
319         balances[msg.sender] = balances[msg.sender].add(_amount);
320 
321         return true;
322     }
323 
324     function receiveDividends(uint _amount) internal {
325         uint minBalance = 10000 ether;
326         uint pieSize = calcPieSize(minBalance);
327         uint amount = nextRoundReserve + _amount;
328 
329         accrueDividends(minBalance, pieSize, amount);
330     }
331 
332     function calcPieSize(uint _minBalance) constant internal returns (uint _pieSize) {
333         for (uint i = 0; i < pieAccounts.length; i += 1) {
334             var balance = pieBalances[pieAccounts[i]];
335 
336             if (balance >= _minBalance) {
337                 _pieSize = _pieSize.add(balance);
338             }
339         }
340     }
341 
342     function accrueDividends(uint _minBalance, uint _pieSize, uint _amount) internal {
343         uint accrued;
344 
345         for (uint i = 0; i < pieAccounts.length; i += 1) {
346             address account = pieAccounts[i];
347             uint balance = pieBalances[account];
348 
349             if (balance >= _minBalance) {
350                 uint dividends = (balance * _amount) / _pieSize;
351 
352                 accrued = accrued.add(dividends);
353                 pieBalances[account] = balance.add(dividends);
354             }
355         }
356 
357         nextRoundReserve = _amount.sub(accrued);
358     }
359 
360     function tryCreatePieAccount(address _account) internal {
361         if (!pieAccountsMap[_account]) {
362             pieAccounts.push(_account);
363             pieAccountsMap[_account] = true;
364         }
365     }
366 
367     function setProjectAgent(address _project) public onlyOwner {
368         projectAgent = _project;
369     }
370 
371     function makeProject(string _name, uint _required, uint _requiredDays) public returns (address _address) {
372         _address = ProjectAgent(projectAgent).makeProject(msg.sender, _name, _required, _requiredDays);
373 
374         projects.push(_address);
375     }
376 
377     function withdrawFromProject(address _project, uint _stage) public returns (bool _success) {
378         uint _value;
379         (_success, _value) = ProjectAgent(projectAgent).withdrawFromProject(msg.sender, _project, _stage);
380 
381         if (_success) {
382             receiveTrancheAndDividends(_value);
383         }
384     }
385 
386     function cashBackFromProject(address _project) public returns (bool _success) {
387         uint _value;
388         (_success, _value) = ProjectAgent(projectAgent).cashBackFromProject(msg.sender, _project);
389 
390         if (_success) {
391             balances[msg.sender] = balances[msg.sender].add(_value);
392         }
393     }
394 
395     function receiveTrancheAndDividends(uint _sum) internal {
396         uint raw = _sum * 965;
397         uint reserve = raw % 1000;
398         uint tranche = (raw - reserve) / 1000;
399 
400         balances[msg.sender] = balances[msg.sender].add(tranche);
401         receiveDividends(_sum - tranche);
402     }
403 
404     function buyProduct(address _product, uint _amount) public {
405         ProjectAgent _agent = ProjectAgent(projectAgent);
406 
407         uint _price = IdeaSubCoin(_product).price();
408 
409         balances[msg.sender] = balances[msg.sender].sub(_price * _amount);
410         _agent.buyProduct(_product, msg.sender, _amount);
411     }
412 }
413 
414 contract IdeaProject {
415     using IdeaUint for uint;
416 
417     string public name;
418     address public engine;
419     address public owner;
420     uint public required;
421     uint public requiredDays;
422     uint public fundingEndTime;
423     uint public earned;
424     mapping(address => bool) public isCashBack;
425     uint public currentWorkStagePercent;
426     uint internal lastWorkStageStartTimestamp;
427     int8 public failStage = -1;
428     uint public failInvestPercents;
429     address[] public products;
430     uint public cashBackVotes;
431     mapping(address => uint) public cashBackWeight;
432 
433     enum States {
434     Initial,
435     Coming,
436     Funding,
437     Workflow,
438     SuccessDone,
439     FundingFail,
440     WorkFail
441     }
442 
443     States public state = States.Initial;
444 
445     struct WorkStage {
446     uint percent;
447     uint stageDays;
448     uint sum;
449     uint withdrawTime;
450     }
451 
452     WorkStage[] public workStages;
453 
454     modifier onlyOwner() {
455         require(msg.sender == owner);
456         _;
457     }
458 
459     modifier onlyEngine() {
460         require(msg.sender == engine);
461         _;
462     }
463 
464     modifier onlyState(States _state) {
465         require(state == _state);
466         _;
467     }
468 
469     modifier onlyProduct() {
470         bool permissionGranted;
471 
472         for (uint8 i; i < products.length; i += 1) {
473             if (msg.sender == products[i]) {
474                 permissionGranted = true;
475             }
476         }
477 
478         if (permissionGranted) {
479             _;
480         } else {
481             revert();
482         }
483     }
484 
485     function IdeaProject(
486     address _owner,
487     string _name,
488     uint _required,
489     uint _requiredDays
490     ) {
491         require(bytes(_name).length > 0);
492         require(_required != 0);
493 
494         require(_requiredDays >= 10);
495         require(_requiredDays <= 100);
496 
497         engine = msg.sender;
498         owner = _owner;
499         name = _name;
500         required = _required;
501         requiredDays = _requiredDays;
502     }
503 
504     function addEarned(uint _earned) public onlyEngine {
505         earned = earned.add(_earned);
506     }
507 
508     function isFundingState() constant public returns (bool _result) {
509         return state == States.Funding;
510     }
511 
512     function isWorkflowState() constant public returns (bool _result) {
513         return state == States.Workflow;
514     }
515 
516     function isSuccessDoneState() constant public returns (bool _result) {
517         return state == States.SuccessDone;
518     }
519 
520     function isFundingFailState() constant public returns (bool _result) {
521         return state == States.FundingFail;
522     }
523 
524     function isWorkFailState() constant public returns (bool _result) {
525         return state == States.WorkFail;
526     }
527 
528     function markAsComingAndFreeze() public onlyState(States.Initial) onlyOwner {
529         require(products.length > 0);
530         require(currentWorkStagePercent == 100);
531 
532         state = States.Coming;
533     }
534 
535     function startFunding() public onlyState(States.Coming) onlyOwner {
536         state = States.Funding;
537 
538         fundingEndTime = uint64(now + requiredDays * 1 days);
539         calcLastWorkStageStart();
540         calcWithdrawTime();
541     }
542 
543     function projectWorkStarted() public onlyState(States.Funding) onlyEngine {
544         startWorkflow();
545     }
546 
547     function startWorkflow() internal {
548         uint used;
549         uint current;
550         uint len = workStages.length;
551 
552         state = States.Workflow;
553 
554         for (uint8 i; i < len; i += 1) {
555             current = earned.mul(workStages[i].percent).div(100);
556             workStages[i].sum = current;
557             used = used.add(current);
558         }
559 
560         workStages[len - 1].sum = workStages[len - 1].sum.add(earned.sub(used));
561     }
562 
563     function projectDone() public onlyState(States.Workflow) onlyOwner {
564         require(now > lastWorkStageStartTimestamp);
565 
566         state = States.SuccessDone;
567     }
568 
569     function projectFundingFail() public onlyState(States.Funding) onlyEngine {
570         state = States.FundingFail;
571     }
572 
573     function projectWorkFail() internal {
574         state = States.WorkFail;
575 
576         for (uint8 i = 1; i < workStages.length; i += 1) {
577             failInvestPercents += workStages[i - 1].percent;
578 
579             if (workStages[i].withdrawTime > now) {
580                 failStage = int8(i - 1);
581 
582                 i = uint8(workStages.length);
583             }
584         }
585 
586         if (failStage == -1) {
587             failStage = int8(workStages.length - 1);
588             failInvestPercents = 100;
589         }
590     }
591 
592     function makeWorkStage(
593     uint _percent,
594     uint _stageDays
595     ) public onlyState(States.Initial) {
596         require(workStages.length <= 10);
597         require(_stageDays >= 10);
598         require(_stageDays <= 100);
599 
600         if (currentWorkStagePercent.add(_percent) > 100) {
601             revert();
602         } else {
603             currentWorkStagePercent = currentWorkStagePercent.add(_percent);
604         }
605 
606         workStages.push(WorkStage(
607         _percent,
608         _stageDays,
609         0,
610         0
611         ));
612     }
613 
614     function calcLastWorkStageStart() internal {
615         lastWorkStageStartTimestamp = fundingEndTime;
616 
617         for (uint8 i; i < workStages.length - 1; i += 1) {
618             lastWorkStageStartTimestamp += workStages[i].stageDays * 1 days;
619         }
620     }
621 
622     function calcWithdrawTime() internal {
623         for (uint8 i; i < workStages.length; i += 1) {
624             if (i == 0) {
625                 workStages[i].withdrawTime = now + requiredDays * 1 days;
626             } else {
627                 workStages[i].withdrawTime = workStages[i - 1].withdrawTime + workStages[i - 1].stageDays * 1 days;
628             }
629         }
630     }
631 
632     function withdraw(uint _stage) public onlyEngine returns (uint _sum) {
633         WorkStage memory stageStruct = workStages[_stage];
634 
635         if (stageStruct.withdrawTime <= now) {
636             _sum = stageStruct.sum;
637 
638             workStages[_stage].sum = 0;
639         }
640     }
641 
642     function voteForCashBack() public {
643         voteForCashBackInPercentOfWeight(100);
644     }
645 
646     function cancelVoteForCashBack() public {
647         voteForCashBackInPercentOfWeight(0);
648     }
649 
650     function voteForCashBackInPercentOfWeight(uint _percent) public {
651         voteForCashBackInPercentOfWeightForAccount(msg.sender, _percent);
652     }
653 
654     function voteForCashBackInPercentOfWeightForAccount(address _account, uint _percent) internal {
655         require(_percent <= 100);
656 
657         updateFundingStateIfNeed();
658 
659         if (state == States.Workflow) {
660             uint currentWeight = cashBackWeight[_account];
661             uint supply;
662             uint part;
663 
664             for (uint8 i; i < products.length; i += 1) {
665                 supply += IdeaSubCoin(products[i]).totalSupply();
666                 part += IdeaSubCoin(products[i]).balanceOf(_account);
667             }
668 
669             cashBackVotes += ((part * (10 ** 10)) / supply) * (_percent - currentWeight);
670             cashBackWeight[_account] = _percent;
671 
672             if (cashBackVotes > 50 * (10 ** 10)) {
673                 projectWorkFail();
674             }
675         }
676     }
677 
678     function updateVotesOnTransfer(address _from, address _to) public onlyProduct {
679         if (isWorkflowState()) {
680             voteForCashBackInPercentOfWeightForAccount(_from, 0);
681             voteForCashBackInPercentOfWeightForAccount(_to, 0);
682         }
683     }
684 
685     function makeProduct(
686     string _name,
687     string _symbol,
688     uint _price,
689     uint _limit
690     ) public onlyState(States.Initial) onlyOwner returns (address _productAddress) {
691         require(products.length <= 25);
692 
693         IdeaSubCoin product = new IdeaSubCoin(msg.sender, _name, _symbol, _price, _limit, engine);
694 
695         products.push(address(product));
696 
697         return address(product);
698     }
699 
700     function calcInvesting(address _account) public onlyEngine returns (uint _sum) {
701         require(!isCashBack[_account]);
702 
703         for (uint8 i = 0; i < products.length; i += 1) {
704             IdeaSubCoin product = IdeaSubCoin(products[i]);
705 
706             _sum = _sum.add(product.balanceOf(_account) * product.price());
707         }
708 
709         if (isWorkFailState()) {
710             _sum = _sum.mul(100 - failInvestPercents).div(100);
711         }
712 
713         isCashBack[_account] = true;
714     }
715 
716     function updateFundingStateIfNeed() internal {
717         if (isFundingState() && now > fundingEndTime) {
718             if (earned >= required) {
719                 startWorkflow();
720             } else {
721                 state = States.FundingFail;
722             }
723         }
724     }
725 }
726 
727 contract ProjectAgent {
728 
729     address public owner;
730     address public coin;
731 
732     modifier onlyOwner() {
733         require(msg.sender == owner);
734         _;
735     }
736 
737     modifier onlyCoin() {
738         require(msg.sender == coin);
739         _;
740     }
741 
742     function ProjectAgent() {
743         owner = msg.sender;
744     }
745 
746     function makeProject(
747     address _owner,
748     string _name,
749     uint _required,
750     uint _requiredDays
751     ) public returns (address _address) {
752         return address(
753         new IdeaProject(
754         _owner,
755         _name,
756         _required,
757         _requiredDays
758         )
759         );
760     }
761 
762     function setCoin(address _coin) public onlyOwner {
763         coin = _coin;
764     }
765 
766     function withdrawFromProject(
767     address _owner,
768     address _project,
769     uint _stage
770     ) public onlyCoin returns (bool _success, uint _value) {
771         require(_owner == IdeaProject(_project).owner());
772 
773         IdeaProject project = IdeaProject(_project);
774         updateFundingStateIfNeed(_project);
775 
776         if (project.isWorkflowState() || project.isSuccessDoneState()) {
777             _value = project.withdraw(_stage);
778 
779             if (_value > 0) {
780                 _success = true;
781             } else {
782                 _success = false;
783             }
784         } else {
785             _success = false;
786         }
787     }
788 
789     function cashBackFromProject(
790     address _owner,
791     address _project
792     ) public onlyCoin returns (bool _success, uint _value) {
793         IdeaProject project = IdeaProject(_project);
794 
795         updateFundingStateIfNeed(_project);
796 
797         if (
798         project.isFundingFailState() ||
799         project.isWorkFailState()
800         ) {
801             _value = project.calcInvesting(_owner);
802             _success = true;
803         } else {
804             _success = false;
805         }
806     }
807 
808     function updateFundingStateIfNeed(address _project) internal {
809         IdeaProject project = IdeaProject(_project);
810 
811         if (
812         project.isFundingState() &&
813         now > project.fundingEndTime()
814         ) {
815             if (project.earned() >= project.required()) {
816                 project.projectWorkStarted();
817             } else {
818                 project.projectFundingFail();
819             }
820         }
821     }
822 
823     function buyProduct(address _product, address _account, uint _amount) public onlyCoin {
824         IdeaSubCoin _productContract = IdeaSubCoin(_product);
825         address _project = _productContract.project();
826         IdeaProject _projectContract = IdeaProject(_project);
827 
828         updateFundingStateIfNeed(_project);
829         require(_projectContract.isFundingState());
830 
831         _productContract.buy(_account, _amount);
832         _projectContract.addEarned(_amount * _productContract.price());
833     }
834 }
835 
836 contract IdeaSubCoin is IdeaBasicCoin {
837 
838     string public name;
839     string public symbol;
840     uint8 public constant decimals = 0;
841     uint public limit;
842     uint public price;
843     address public project;
844     address public engine;
845     mapping(address => string) public shipping;
846 
847     modifier onlyProject() {
848         require(msg.sender == project);
849         _;
850     }
851 
852     modifier onlyEngine() {
853         require(msg.sender == engine);
854         _;
855     }
856 
857     function IdeaSubCoin(
858     address _owner,
859     string _name,
860     string _symbol,
861     uint _price,
862     uint _limit,
863     address _engine
864     ) {
865         require(_price != 0);
866 
867         owner = _owner;
868         name = _name;
869         symbol = _symbol;
870         price = _price;
871         limit = _limit;
872         project = msg.sender;
873         engine = _engine;
874     }
875 
876     function transfer(address _to, uint _value) public returns (bool success) {
877         require(!IdeaProject(project).isCashBack(msg.sender));
878         require(!IdeaProject(project).isCashBack(_to));
879 
880         IdeaProject(project).updateVotesOnTransfer(msg.sender, _to);
881 
882         bool result = super.transfer(_to, _value);
883 
884         if (!result) {
885             revert();
886         }
887 
888         return result;
889     }
890 
891     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
892         require(!IdeaProject(project).isCashBack(_from));
893         require(!IdeaProject(project).isCashBack(_to));
894 
895         IdeaProject(project).updateVotesOnTransfer(_from, _to);
896 
897         bool result = super.transferFrom(_from, _to, _value);
898 
899         if (!result) {
900             revert();
901         }
902 
903         return result;
904     }
905 
906     function buy(address _account, uint _amount) public onlyEngine {
907         uint total = totalSupply.add(_amount);
908 
909         if (limit != 0) {
910             require(total <= limit);
911         }
912 
913         totalSupply = totalSupply.add(_amount);
914         balances[_account] = balances[_account].add(_amount);
915         tryCreateAccount(_account);
916     }
917 
918     function setShipping(string _shipping) public {
919         require(bytes(_shipping).length > 0);
920 
921         shipping[msg.sender] = _shipping;
922     }
923 
924 }
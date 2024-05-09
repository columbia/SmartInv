1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal  pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Base {
30     modifier only(address allowed) {
31         require(msg.sender == allowed);
32         _;
33     }
34 }
35 
36 contract Owned is Base {
37 
38     address public owner;
39     address newOwner;
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     function transferOwnership(address _newOwner) only(owner) public {
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() only(newOwner) public {
50         OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56 }
57 
58 contract ERC20 is Owned {
59     using SafeMath for uint;
60 
61     bool public isStarted = false;
62 
63     modifier isStartedOnly() {
64         require(isStarted);
65         _;
66     }
67 
68     modifier isNotStartedOnly() {
69         require(!isStarted);
70         _;
71     }
72 
73     event Transfer(address indexed _from, address indexed _to, uint _value);
74     event Approval(address indexed _owner, address indexed _spender, uint _value);
75 
76     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
77         require(_to != address(0));
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
85         require(_to != address(0));
86         balances[_from] = balances[_from].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89         Transfer(_from, _to, _value);
90         return true;
91     }
92 
93     function balanceOf(address _owner) constant public returns (uint balance) {
94         return balances[_owner];
95     }
96 
97     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
98         if(allowed[msg.sender][_spender] == _currentValue){
99             allowed[msg.sender][_spender] = _value;
100             Approval(msg.sender, _spender, _value);
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     mapping (address => uint) balances;
118     mapping (address => mapping (address => uint)) allowed;
119 
120     uint public totalSupply;
121 }
122 
123 contract Token is ERC20 {
124     using SafeMath for uint;
125 
126     string public name;
127     string public symbol;
128     uint8 public decimals;
129 
130 
131     function Token(string _name, string _symbol, uint8 _decimals) public {
132         name = _name;
133         symbol = _symbol;
134         decimals = _decimals;
135     }
136 
137     function start() public only(owner) isNotStartedOnly {
138         isStarted = true;
139     }
140 
141     //================= Crowdsale Only =================
142     function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {
143         totalSupply = totalSupply.add(_amount);
144         balances[_to] = balances[_to].add(_amount);
145         Transfer(msg.sender, _to, _amount);
146         return true;
147     }
148 
149     function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {
150         uint i = 0;
151         while (i < dests.length) {
152            mint(dests[i], values[i]);
153            i += 1;
154         }
155         return(i);
156     }
157 }
158 
159 contract TokenWithoutStart is Owned {
160     using SafeMath for uint;
161 
162     string public name;
163     string public symbol;
164     uint8 public decimals;
165 
166     uint public totalSupply;
167 
168     event Transfer(address indexed _from, address indexed _to, uint _value);
169     event Approval(address indexed _owner, address indexed _spender, uint _value);
170 
171     function TokenWithoutStart(string _name, string _symbol, uint8 _decimals) public {
172         name = _name;
173         symbol = _symbol;
174         decimals = _decimals;
175     }
176 
177     function transfer(address _to, uint _value) public returns (bool success) {
178         require(_to != address(0));
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
186         require(_to != address(0));
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     function balanceOf(address _owner) constant public returns (uint balance) {
195         return balances[_owner];
196     }
197 
198     function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
199         if(allowed[msg.sender][_spender] == _currentValue){
200             allowed[msg.sender][_spender] = _value;
201             Approval(msg.sender, _spender, _value);
202             return true;
203         } else {
204             return false;
205         }
206     }
207 
208     function approve(address _spender, uint _value) public returns (bool success) {
209         allowed[msg.sender][_spender] = _value;
210         Approval(msg.sender, _spender, _value);
211         return true;
212     }
213 
214     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
215         return allowed[_owner][_spender];
216     }
217 
218     mapping (address => uint) balances;
219     mapping (address => mapping (address => uint)) allowed;
220 
221     function mint(address _to, uint _amount) public only(owner) returns(bool) {
222         totalSupply = totalSupply.add(_amount);
223         balances[_to] = balances[_to].add(_amount);
224         Transfer(msg.sender, _to, _amount);
225         return true;
226     }
227 
228     function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {
229         uint i = 0;
230         while (i < dests.length) {
231            mint(dests[i], values[i]);
232            i += 1;
233         }
234         return(i);
235     }
236 
237 }
238 
239 contract ICOContract {
240     
241     address public projectWallet; //beneficiary wallet
242     address public operator = 0x4C67EB86d70354731f11981aeE91d969e3823c39; //address of the ICO operator — the one who adds milestones and InvestContracts
243 
244     uint public constant waitPeriod = 7 days; //wait period after milestone finish and untile the next one can be started
245 
246     address[] public pendingInvestContracts = [0x0]; //pending InvestContracts not yet accepted by the project
247     mapping(address => uint) public pendingInvestContractsIndices;
248 
249     address[] public investContracts = [0x0]; // accepted InvestContracts
250     mapping(address => uint) public investContractsIndices;
251 
252     uint public minimalInvestment = 5 ether;
253     
254     uint public totalEther; // How much Ether is collected =sum of all milestones' etherAmount
255     uint public totalToken; // how many tokens are distributed = sum of all milestones' tokenAmount
256 
257     uint public tokenLeft;
258     uint public etherLeft;
259 
260     Token public token;
261     
262     ///ICO caps
263     uint public minimumCap; // set in constructor
264     uint public maximumCap;  // set in constructor
265 
266     //Structure for milestone
267     struct Milestone {
268         uint etherAmount; //how many Ether is needed for this milestone
269         uint tokenAmount; //how many tokens releases this milestone
270         uint startTime; //real time when milestone has started, set upon start
271         uint finishTime; //real time when milestone has finished, set upon finish
272         uint duration; //assumed duration for milestone implementation, set upon milestone creation
273         string description; 
274         string results;
275     }
276 
277     Milestone[] public milestones;
278     uint public currentMilestone;
279     uint public sealTimestamp; //Until when it's possible to add new and change existing milestones
280 
281     
282     modifier only(address _sender) {
283         require(msg.sender == _sender);
284         _;
285     }
286 
287     modifier notSealed() {
288         require(now <= sealTimestamp);
289         _;
290     }
291 
292     modifier sealed() {
293         require(now > sealTimestamp);
294         _;
295     }
296 
297     /// @dev Create an ICOContract.
298     /// @param _tokenAddress Address of project token contract
299     /// @param _projectWallet Address of project developers wallet
300     /// @param _sealTimestamp Until this timestamp it's possible to alter milestones
301     /// @param _minimumCap Wei value of minimum cap for responsible ICO
302     /// @param _maximumCap Wei value of maximum cap for responsible ICO
303     function ICOContract(address _tokenAddress, address _projectWallet, uint _sealTimestamp, uint _minimumCap,
304                          uint _maximumCap) public {
305         token = Token(_tokenAddress);
306         projectWallet = _projectWallet;
307         sealTimestamp = _sealTimestamp;
308         minimumCap = _minimumCap;
309         maximumCap = _maximumCap;
310     }
311 
312     //MILESTONES
313   
314     /// @dev Adds a milestone.
315     /// @param _etherAmount amount of Ether needed for the added milestone
316     /// @param _tokenAmount amount of tokens which will be released for added milestone
317     /// @param _startTime field for start timestamp of added milestone
318     /// @param _duration assumed duration of the milestone
319     /// @param _description description of added milestone
320     /// @param _result result description of added milestone
321     function addMilestone(uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description, string _result)        
322     notSealed only(operator)
323     public returns(uint) {
324         totalEther += _etherAmount;
325         totalToken += _tokenAmount;
326         return milestones.push(Milestone(_etherAmount, _tokenAmount, _startTime, 0, _duration, _description, _result));
327     }
328 
329     /// @dev Edits milestone by given id and new parameters.
330     /// @param _id id of editing milestone
331     /// @param _etherAmount amount of Ether needed for the milestone
332     /// @param _tokenAmount amount of tokens which will be released for the milestone
333     /// @param _startTime start timestamp of the milestone
334     /// @param _duration assumed duration of the milestone
335     /// @param _description description of the milestone
336     /// @param _results result description of the milestone
337     function editMilestone(uint _id, uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description, string _results) 
338     notSealed only(operator)
339     public {
340         require(_id < milestones.length);
341         totalEther = totalEther - milestones[_id].etherAmount + _etherAmount;
342         totalToken = totalToken - milestones[_id].tokenAmount + _tokenAmount;
343         milestones[_id].etherAmount = _etherAmount;
344         milestones[_id].tokenAmount = _tokenAmount;
345         milestones[_id].startTime = _startTime;
346         milestones[_id].duration = _duration;
347         milestones[_id].description = _description;
348         milestones[_id].results = _results;
349     }
350 
351     //TODO: add check if ICOContract has tokens
352     ///@dev Seals milestone making them no longer changeable. Works by setting changeable timestamp to the current one, //so in future it would be no longer callable.
353     function seal() only(operator) notSealed() public { 
354         assert(milestones.length > 0);
355         //assert(token.balanceOf(address(this)) >= totalToken;
356         sealTimestamp = now;
357         etherLeft = totalEther;
358         tokenLeft = totalToken;
359     }
360 
361     function finishMilestone(string _results) only(operator) public {
362         var milestone = getCurrentMilestone();
363         milestones[milestone].finishTime = now;
364         milestones[milestone].results = _results;
365     }
366 
367     function startNextMilestone() public only(operator) {
368         uint milestone = getCurrentMilestone();
369         require(milestones[currentMilestone].finishTime == 0);
370         currentMilestone +=1;
371         milestones[currentMilestone].startTime = now;
372         for(uint i=1; i < investContracts.length; i++) {
373                 InvestContract investContract =  InvestContract(investContracts[i]); 
374                 investContract.milestoneStarted(milestone);
375         }
376     }
377 
378     ///@dev Returns number of the current milestone. Starts from 1. 0 indicates that project implementation has not started yet.
379     function getCurrentMilestone() public constant returns(uint) {
380         /*
381         for(uint i=0; i < milestones.length; i++) { 
382             if (milestones[i].startTime <= now && now <= milestones[i].finishTime + waitPeriod) {
383                 return i+1;
384             }
385         }
386         return 0;
387        */
388         return currentMilestone;
389     }
390    
391     /// @dev Getter function for length. For testing purposes.
392     function milestonesLength() public view returns(uint) {
393         return milestones.length;
394     }
395 
396     ///InvestContract part
397     function createInvestContract(address _investor, uint _etherAmount, uint _tokenAmount) public 
398         sealed only(operator)
399         returns(address)
400     {
401         require(_etherAmount >= minimalInvestment);
402         //require(milestones[0].startTime - now >= 5 days);
403         //require(maximumCap >= _etherAmount + investorEther);
404         //require(token.balanceOf(address(this)) >= _tokenAmount + investorTokens);
405         address investContract = new InvestContract(address(this), _investor, _etherAmount, _tokenAmount);
406         pendingInvestContracts.push(investContract);
407         pendingInvestContractsIndices[investContract]=(pendingInvestContracts.length-1); //note that indices start from 1
408         return(investContract);
409     }
410 
411     /// @dev This function is called by InvestContract when it receives Ether. It shold move this InvestContract from pending to the real ones.
412     function investContractDeposited() public {
413         //require(maximumCap >= investEthAmount + investorEther);
414         uint index = pendingInvestContractsIndices[msg.sender];
415         assert(index > 0);
416         uint len = pendingInvestContracts.length;
417         InvestContract investContract = InvestContract(pendingInvestContracts[index]);
418         pendingInvestContracts[index] = pendingInvestContracts[len-1];
419         pendingInvestContracts.length = len-1;
420         investContracts.push(msg.sender);
421         investContractsIndices[msg.sender]=investContracts.length-1; //note that indexing starts from 1
422 
423         uint investmentToken = investContract.tokenAmount();
424         uint investmentEther = investContract.etherAmount();
425 
426         etherLeft -= investmentEther;
427         tokenLeft -= investmentToken;
428         assert(token.transfer(msg.sender, investmentToken)); 
429     }
430 
431     function returnTokens() public only(operator) {
432         uint balance = token.balanceOf(address(this));
433         token.transfer(projectWallet, balance);
434     }
435 
436 }
437 
438 
439 contract Pullable {
440   using SafeMath for uint256;
441 
442   mapping(address => uint256) public payments;
443 
444   /**
445   * @dev withdraw accumulated balance, called by payee.
446   */
447   function withdrawPayment() public {
448     address payee = msg.sender;
449     uint256 payment = payments[payee];
450 
451     require(payment != 0);
452     require(this.balance >= payment);
453 
454     payments[payee] = 0;
455 
456     assert(payee.send(payment));
457   }
458 
459   /**
460   * @dev Called by the payer to store the sent amount as credit to be pulled.
461   * @param _destination The destination address of the funds.
462   * @param _amount The amount to transfer.
463   */
464   function asyncSend(address _destination, uint256 _amount) internal {
465     payments[_destination] = payments[_destination].add(_amount);
466   }
467 }
468 
469 contract TokenPullable {
470   using SafeMath for uint256;
471   Token public token;
472 
473   mapping(address => uint256) public tokenPayments;
474 
475   function TokenPullable(address _ico) public {
476       ICOContract icoContract = ICOContract(_ico);
477       token = icoContract.token();
478   }
479 
480   /**
481   * @dev withdraw accumulated balance, called by payee.
482   */
483   function withdrawTokenPayment() public {
484     address tokenPayee = msg.sender;
485     uint256 tokenPayment = tokenPayments[tokenPayee];
486 
487     require(tokenPayment != 0);
488     require(token.balanceOf(address(this)) >= tokenPayment);
489 
490     tokenPayments[tokenPayee] = 0;
491 
492     assert(token.transfer(tokenPayee, tokenPayment));
493   }
494 
495   function asyncTokenSend(address _destination, uint _amount) internal {
496     tokenPayments[_destination] = tokenPayments[_destination].add(_amount);
497   }
498 }
499 
500 contract InvestContract is TokenPullable, Pullable {
501 
502     address public projectWallet; // person from ico team
503     address public investor; 
504 
505     uint public arbiterAcceptCount = 0;
506     uint public quorum;
507 
508     ICOContract public icoContract;
509     //Token public token;
510 
511     uint[] public etherPartition; //weis 
512     uint[] public tokenPartition; //tokens
513 
514     //Each arbiter has parameter delay which equals time interval in seconds betwwen dispute open and when the arbiter can vote
515     struct ArbiterInfo { 
516         uint index;
517         bool accepted;
518         uint voteDelay;
519     }
520 
521     mapping(address => ArbiterInfo) public arbiters; //arbiterAddress => ArbiterInfo{acceptance, voteDelay}
522     address[] public arbiterList = [0x0]; //it's needed to show complete arbiter list
523 
524 
525     //this structure can be optimized
526     struct Dispute {
527         uint timestamp;
528         string reason;
529         address[5] voters;
530         mapping(address => address) votes; 
531         uint votesProject;
532         uint votesInvestor;
533     }
534 
535     mapping(uint => Dispute) public disputes;
536 
537     uint public etherAmount; //How much Ether investor wants to invest
538     uint public tokenAmount; //How many tokens investor wants to receive
539 
540     bool public disputing=false;
541     uint public amountToPay; //investAmount + commissions
542     
543     //Modifier that restricts function caller
544     modifier only(address _sender) {
545         require(msg.sender == _sender);
546         _;
547     }
548 
549     modifier onlyArbiter() {
550         require(arbiters[msg.sender].voteDelay > 0);
551         _;
552     }
553   
554     function InvestContract(address _ICOContractAddress, address _investor,  uint
555                            _etherAmount, uint _tokenAmount) TokenPullable(_ICOContractAddress)
556     public {
557         icoContract = ICOContract(_ICOContractAddress);
558         token = icoContract.token();
559 		etherAmount = _etherAmount;
560         tokenAmount = _tokenAmount;
561         projectWallet = icoContract.projectWallet();
562         investor = _investor;
563         amountToPay = etherAmount*101/100; //101% of the agreed amount
564         quorum = 3;
565         //hardcoded arbiters
566         addAcceptedArbiter(0x42efbba0563AE5aa2312BeBce1C18C6722B67857, 1); //Ryan
567         addAcceptedArbiter(0x37D5953c24a2efD372C97B06f22416b68e896eaf, 1);// Maxim Telegin
568         addAcceptedArbiter(0xd0D2e05Fd34d566612529512F7Af1F8a60EDAb6C, 1);// Vladimir Dyakin
569         addAcceptedArbiter(0xB6508aFaCe815e481bf3B3Fa9B4117D46C963Ec3, 1);// Immánuel Fodor
570         addAcceptedArbiter(0x73380dc12B629FB7fBD221E05D25E42f5f3FAB11, 1);// Alban
571 
572         arbiterAcceptCount = 5;
573 
574 		uint milestoneEtherAmount; //How much Ether does investor send for a milestone
575 		uint milestoneTokenAmount; //How many Tokens does investor receive for a milestone
576 
577 		uint milestoneEtherTarget; //How much TOTAL Ether a milestone needs
578 		uint milestoneTokenTarget; //How many TOTAL tokens a milestone releases
579 
580 		uint totalEtherInvestment; 
581 		uint totalTokenInvestment;
582 		for(uint i=0; i<icoContract.milestonesLength(); i++) {
583 			(milestoneEtherTarget, milestoneTokenTarget, , , , , ) = icoContract.milestones(i);
584 			milestoneEtherAmount = _etherAmount * milestoneEtherTarget / icoContract.totalEther();  
585 			milestoneTokenAmount = _tokenAmount * milestoneTokenTarget / icoContract.totalToken();
586 			totalEtherInvestment += milestoneEtherAmount; //used to prevent rounding errors
587 			totalTokenInvestment += milestoneTokenAmount; //used to prevent rounding errors
588 			etherPartition.push(milestoneEtherAmount);  
589 			tokenPartition.push(milestoneTokenAmount);
590 		}
591 		etherPartition[0] += _etherAmount - totalEtherInvestment; //rounding error is added to the first milestone
592 		tokenPartition[0] += _tokenAmount - totalTokenInvestment; //rounding error is added to the first milestone
593     }
594 
595     function() payable public only(investor) { 
596         require(arbiterAcceptCount >= quorum);
597         require(msg.value == amountToPay);
598         require(getCurrentMilestone() == 0); //before first
599         icoContract.investContractDeposited();
600     } 
601 
602     //Adding an arbiter which has already accepted his participation in ICO.
603     function addAcceptedArbiter(address _arbiter, uint _delay) internal {
604         require(token.balanceOf(address(this))==0); //only callable when there are no tokens at this contract
605         require(_delay > 0); //to differ from non-existent arbiters
606         var index = arbiterList.push(_arbiter);
607         arbiters[_arbiter] = ArbiterInfo(index, true, _delay);
608     }
609 
610     /* Not used for our own ICO as arbiters are the same and already accepted their participation
611     function arbiterAccept() public onlyArbiter {
612         require(!arbiters[msg.sender].accepted);
613         arbiters[msg.sender].accepted = true;
614         arbiterAcceptCount += 1;
615     }
616 
617     function addArbiter(address _arbiter, uint _delay) public {
618         //only(investor)
619         require(token.balanceOf(address(this))==0); //only callable when there are no tokens at this contract
620         require(_delay > 0); //to differ from non-existent arbiters
621         var index = arbiterList.push(_arbiter);
622         arbiters[_arbiter] = ArbiterInfo(index, false, _delay);
623     }
624 
625    */
626 
627     function vote(address _voteAddress) public onlyArbiter {   
628         require(_voteAddress == investor || _voteAddress == projectWallet);
629         require(disputing);
630         uint milestone = getCurrentMilestone();
631         require(milestone > 0);
632         require(disputes[milestone].votes[msg.sender] == 0); 
633         require(now - disputes[milestone].timestamp >= arbiters[msg.sender].voteDelay); //checking if enough time has passed since dispute had been opened
634         disputes[milestone].votes[msg.sender] = _voteAddress;
635         disputes[milestone].voters[disputes[milestone].votesProject+disputes[milestone].votesInvestor] = msg.sender;
636         if (_voteAddress == projectWallet) {
637             disputes[milestone].votesProject += 1;
638         } else if (_voteAddress == investor) {
639             disputes[milestone].votesInvestor += 1;
640         } else { 
641             revert();
642         }
643 
644         if (disputes[milestone].votesProject >= quorum) {
645             executeVerdict(true);
646         }
647         if (disputes[milestone].votesInvestor >= quorum) {
648             executeVerdict(false);
649         }
650     }
651 
652     function executeVerdict(bool _projectWon) internal {
653         //uint milestone = getCurrentMilestone();
654         disputing = false;
655         if (_projectWon) {
656             //token.transfer(0x0, token.balanceOf(address(this)));
657         } else  {
658 		//asyncTokenSend(investor, tokensToSend);
659 		//asyncSend(projectWallet, etherToSend);
660             //token.transfer(address(icoContract), token.balanceOf(this)); // send all tokens back
661         }
662     }
663 
664     function openDispute(string _reason) public only(investor) {
665         assert(!disputing);
666         var milestone = getCurrentMilestone();
667         assert(milestone > 0);
668         disputing = true;
669         disputes[milestone].timestamp = now;
670         disputes[milestone].reason = _reason;
671     }
672 
673 	function milestoneStarted(uint _milestone) public only(address(icoContract)) {
674         require(!disputing);
675 		var etherToSend = etherPartition[_milestone];
676 		var tokensToSend = tokenPartition[_milestone];
677 
678 		//async send
679 		asyncSend(projectWallet, etherToSend);
680 		asyncTokenSend(investor, tokensToSend);
681 
682     }
683 
684     function getCurrentMilestone() public constant returns(uint) {
685         return icoContract.getCurrentMilestone();
686     }
687 
688 }
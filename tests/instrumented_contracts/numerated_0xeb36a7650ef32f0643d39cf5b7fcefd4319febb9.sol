1 pragma solidity ^0.4.20;
2 
3 // File: contracts/ERC20Token.sol
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal  pure returns (uint256) {
13     uint256 c = a / b;
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
29 contract Owned {
30 
31     address public owner;
32     address newOwner;
33 
34     modifier only(address _allowed) {
35         require(msg.sender == _allowed);
36         _;
37     }
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address _newOwner) only(owner) public {
44         newOwner = _newOwner;
45     }
46 
47     function acceptOwnership() only(newOwner) public {
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54 }
55 
56 contract ERC20 is Owned {
57     using SafeMath for uint;
58 
59     uint public totalSupply;
60     bool public isStarted = false;
61     mapping (address => uint) balances;
62     mapping (address => mapping (address => uint)) allowed;
63 
64     modifier isStartedOnly() {
65         require(isStarted);
66         _;
67     }
68 
69     modifier isNotStartedOnly() {
70         require(!isStarted);
71         _;
72     }
73 
74     event Transfer(address indexed _from, address indexed _to, uint _value);
75     event Approval(address indexed _owner, address indexed _spender, uint _value);
76 
77     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
78         require(_to != address(0));
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         emit Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
86         require(_to != address(0));
87         balances[_from] = balances[_from].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90         emit Transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint balance) {
95         return balances[_owner];
96     }
97 
98     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
99         if(allowed[msg.sender][_spender] == _currentValue){
100             allowed[msg.sender][_spender] = _value;
101             emit Approval(msg.sender, _spender, _value);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint remaining) {
115         return allowed[_owner][_spender];
116     }
117 
118 }
119 
120 contract Token is ERC20 {
121     using SafeMath for uint;
122 
123     string public name;
124     string public symbol;
125     uint8 public decimals;
126 
127     constructor(string _name, string _symbol, uint8 _decimals) public {
128         name = _name;
129         symbol = _symbol;
130         decimals = _decimals;
131     }
132 
133     function start() public only(owner) isNotStartedOnly {
134         isStarted = true;
135     }
136 
137     //================= Crowdsale Only =================
138     function mint(address _to, uint _amount) public only(owner) isNotStartedOnly returns(bool) {
139         totalSupply = totalSupply.add(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         emit Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function multimint(address[] dests, uint[] values) public only(owner) isNotStartedOnly returns (uint) {
146         uint i = 0;
147         while (i < dests.length) {
148            mint(dests[i], values[i]);
149            i += 1;
150         }
151         return(i);
152     }
153 }
154 
155 contract TokenWithoutStart is Owned {
156     using SafeMath for uint;
157 
158     mapping (address => uint) balances;
159     mapping (address => mapping (address => uint)) allowed;
160     string public name;
161     string public symbol;
162     uint8 public decimals;
163     uint public totalSupply;
164 
165     event Transfer(address indexed _from, address indexed _to, uint _value);
166     event Approval(address indexed _owner, address indexed _spender, uint _value);
167 
168     constructor(string _name, string _symbol, uint8 _decimals) public {
169         name = _name;
170         symbol = _symbol;
171         decimals = _decimals;
172     }
173 
174     function transfer(address _to, uint _value) public returns (bool success) {
175         require(_to != address(0));
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
183         require(_to != address(0));
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function balanceOf(address _owner) public view returns (uint balance) {
192         return balances[_owner];
193     }
194 
195     function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
196         if(allowed[msg.sender][_spender] == _currentValue){
197             allowed[msg.sender][_spender] = _value;
198             emit Approval(msg.sender, _spender, _value);
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     function approve(address _spender, uint _value) public returns (bool success) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function allowance(address _owner, address _spender) public view returns (uint remaining) {
212         return allowed[_owner][_spender];
213     }
214 
215     function mint(address _to, uint _amount) public only(owner) returns(bool) {
216         totalSupply = totalSupply.add(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221 
222     function multimint(address[] dests, uint[] values) public only(owner) returns (uint) {
223         uint i = 0;
224         while (i < dests.length) {
225            mint(dests[i], values[i]);
226            i += 1;
227         }
228         return(i);
229     }
230 
231 }
232 
233 // File: contracts/CycleSet.sol
234 
235 // DEPLOYED BY JURY.ONLINE
236 contract ICO {
237     // GENERAL ICO PARAMS ------------------------------------------------------
238 
239     string public name;
240 
241     address public operator; // the ICO operator
242     address public projectWallet; // the wallet that receives ICO Funds
243     Token public token; // ICO token
244     address public juryOnlineWallet; // JuryOnline Wallet for commission
245     address public arbitrationAddress; // Address of Arbitration Contract
246     uint public currentCycle; // current cycle
247 
248     struct Cycle {
249         bool exists;
250         bool approved;
251         address icoRoundAddress;
252     }
253 
254     mapping(uint => Cycle) public cycles; // stores the approved Cycles
255 
256     // DEPLOYED BY JURY.ONLINE
257     // PARAMS:
258     // address _operator
259     // address _projectWallet
260     // address _tokenAddress
261     // address _arbitrationAddress
262     // address _juryOnlineWallet
263     constructor(string _name, address _operator, address _projectWallet, address _tokenAddress, address _arbitrationAddress, address _juryOnlineWallet) public {
264         name = _name;
265         operator = _operator;
266         projectWallet = _projectWallet;
267         token = Token(_tokenAddress);
268         arbitrationAddress = _arbitrationAddress;
269         juryOnlineWallet = _juryOnlineWallet;
270     }
271 
272     // CALLED BY CYCLE CONTRACT
273     function addRound() public {
274         cycles[currentCycle].exists = true;
275         cycles[currentCycle].icoRoundAddress = msg.sender;
276     }
277 
278     // CALLED BY ICO OPERATOR, approves CYCLE Contract and adds it to cycles
279     function approveRound(address _icoRoundAddress) public {
280         require(msg.sender == operator);
281         require(cycles[currentCycle].icoRoundAddress == _icoRoundAddress);
282         currentCycle +=1;
283     }
284 
285 }
286 // DEPLOYED BY JURY.ONLINE
287 contract Cycle {
288 
289     using SafeMath for uint;
290 
291     // GENERAL CYCLE VARIABLES -------------------------------------------------
292 
293     address public juryOperator; // assists in operation
294     address public operator; // cycle operator, same as ICO operator
295     address public icoAddress; // to associate Cycle with ICO
296     address public juryOnlineWallet; // juryOnlineWallet for commission
297     address public projectWallet; // taken from ICO contract
298     address public arbitrationAddress; // taken from ICO contract
299     Token public token; // taken from ICO contract
300 
301     address public jotter; // address for JOT commission
302 
303     bool public saveMe; // if true, gives Jury.Online control of contract
304 
305     struct Milestone {
306         uint etherAmount; //how many Ether is needed for this milestone
307         uint tokenAmount; //how many tokens releases this milestone
308         uint startTime; //real time when milestone has started, set upon start
309         uint finishTime; //real time when milestone has finished, set upon finish
310         uint duration; //assumed duration for milestone implementation, set upon milestone creation
311         string description;
312         string result;
313     }
314 
315     Milestone[] public milestones; // List of Milestones
316     uint public currentMilestone;
317 
318     uint public sealTimestamp; // the moment the Cycle is Sealed by operator
319 
320     uint public ethForMilestone; // Amount to be withdraw by operator for each milestone
321     uint public postDisputeEth; // in case of dispute in favor of ico project
322 
323     // INVESTOR struct stores information about each Investor
324     // Investor can have more than one deals, but only one right to dispute
325     struct Investor {
326         bool disputing;
327         uint tokenAllowance;
328         uint etherUsed;
329         uint sumEther;
330         uint sumToken;
331         bool verdictForProject;
332         bool verdictForInvestor;
333         uint numberOfDeals;
334     }
335 
336     struct Deal {
337         address investor;
338         uint etherAmount;
339         uint tokenAmount;
340         bool accepted;
341     }
342 
343     mapping(address => Investor) public deals; // map of information of investors with deals
344     address[] public dealsList; // list of investors with deals
345     mapping(address => mapping(uint => Deal)) public offers; // pending offers
346 
347     // COMMISSION ARRAYS
348     // amounts stored as percentage
349     // If commissionOnInvestmentEth/Jot > 0, commission paid when investment is accepted
350     // If elements on commissionEth/Jot, each element is commission to corresponding milestone
351     // ETH commission is transferred to Jury.Online wallet
352     // JOT commission is transferred to a Jotter contract that swaps eth for jot
353     uint[] public commissionEth;
354     uint[] public commissionJot;
355     uint public commissionOnInvestmentEth;
356     uint public commissionOnInvestmentJot;
357     uint public etherAllowance; // Amount that Jury.Online can withdraw as commission in ETH
358     uint public jotAllowance; // Amount that Jury.Online can withdraw as commission in JOT
359 
360     uint public totalEther; // Sum of ether in milestones
361     uint public totalToken; // Sum of tokens in milestones
362 
363     uint public promisedTokens; // Sum of tokens promised by accepting offer
364     uint public raisedEther; // Sum of ether raised by accepting offer
365 
366     uint public rate; // eth to token rate in current Funding Round
367     bool public tokenReleaseAtStart; // whether to release tokens at start or by each milestone
368     uint public currentFundingRound;
369 
370     bool public roundFailedToStart;
371 
372     // Stores amount of ether and tokens per milestone for each investor
373     mapping(address => uint[]) public etherPartition;
374     mapping(address => uint[]) public tokenPartition;
375 
376     // Funding Rounds can be added with start, end time, rate, and whitelist
377     struct FundingRound {
378         uint startTime;
379         uint endTime;
380         uint rate;
381         bool hasWhitelist;
382     }
383 
384     FundingRound[] public roundPrices;  // stores list of funding rounds
385     mapping(uint => mapping(address => bool)) public whitelist; // stores whitelists
386 
387     // -------------------------------------------------------------------------
388     // MODIFIERS
389     modifier onlyOperator() {
390         require(msg.sender == operator || msg.sender == juryOperator);
391         _;
392     }
393 
394     modifier onlyAdmin() {
395         require(msg.sender == operator || msg.sender == juryOperator);
396         _;
397     }
398 
399     modifier sealed() {
400         require(sealTimestamp != 0);
401         /* require(now > sealTimestamp); */
402         _;
403     }
404 
405     modifier notSealed() {
406         require(sealTimestamp == 0);
407         /* require(now <= sealTimestamp); */
408         _;
409     }
410     // -------------------------------------------------------------------------
411     // DEPLOYED BY JURY.ONLINE
412     // PARAMS:
413     // address _icoAddress
414     // address _operator
415     // uint _rate
416     // address _jotter
417     // uint[] _commissionEth
418     // uint[] _commissionJot
419     constructor( address _icoAddress,
420                  address _operator,
421                  uint _rate,
422                  address _jotter,
423                  uint[] _commissionEth,
424                  uint[] _commissionJot,
425                  uint _commissionOnInvestmentEth,
426                  uint _commissionOnInvestmentJot
427                  ) public {
428         require(_commissionEth.length == _commissionJot.length);
429         juryOperator = msg.sender;
430         icoAddress = _icoAddress;
431         operator = _operator;
432         rate = _rate;
433         jotter = _jotter;
434         commissionEth = _commissionEth;
435         commissionJot = _commissionJot;
436         roundPrices.push(FundingRound(0,0,0,false));
437         tokenReleaseAtStart = true;
438         commissionOnInvestmentEth = _commissionOnInvestmentEth;
439         commissionOnInvestmentJot = _commissionOnInvestmentJot;
440     }
441 
442     // CALLED BY JURY.ONLINE TO SET JOTTER ADDRESS FOR JOT COMMISSION
443     function setJotter(address _jotter) public {
444         require(msg.sender == juryOperator);
445         jotter = _jotter;
446     }
447 
448     // CALLED BY ADMIN TO RETRIEVE INFORMATION FROM ICOADDRESS AND ADD ITSELF
449     // TO LIST OF CYCLES IN ICO
450     function activate() onlyAdmin notSealed public {
451         ICO icoContract = ICO(icoAddress);
452         require(icoContract.operator() == operator);
453         juryOnlineWallet = icoContract.juryOnlineWallet();
454         projectWallet = icoContract.projectWallet();
455         arbitrationAddress = icoContract.arbitrationAddress();
456         token = icoContract.token();
457         icoContract.addRound();
458     }
459 
460     // CALLED BY JURY.ONLINE TO RETRIEVE COMMISSION
461     // CALLED BY ICO OPERATOR TO RETRIEVE FUNDS
462     // CALLED BY INVESTOR TO RETRIEVE FUNDS AFTER DISPUTE
463     function withdrawEther() public {
464         if (roundFailedToStart == true) {
465             require(msg.sender.send(deals[msg.sender].sumEther));
466         }
467         if (msg.sender == operator) {
468             require(projectWallet.send(ethForMilestone+postDisputeEth));
469             ethForMilestone = 0;
470             postDisputeEth = 0;
471         }
472         if (msg.sender == juryOnlineWallet) {
473             require(juryOnlineWallet.send(etherAllowance));
474             require(jotter.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
475             etherAllowance = 0;
476             jotAllowance = 0;
477         }
478         if (deals[msg.sender].verdictForInvestor == true) {
479             require(msg.sender.send(deals[msg.sender].sumEther - deals[msg.sender].etherUsed));
480         }
481     }
482 
483     // CALLED BY INVESTOR TO RETRIEVE TOKENS
484     function withdrawToken() public {
485         require(token.transfer(msg.sender,deals[msg.sender].tokenAllowance));
486         deals[msg.sender].tokenAllowance = 0;
487     }
488 
489     // CALLED BY ICO OPERATOR TO ADD FUNDING ROUNDS WITH _startTime,_endTime,_price,_whitelist
490     function addRoundPrice(uint _startTime,uint _endTime, uint _price, address[] _whitelist) public onlyOperator {
491         if (_whitelist.length == 0) {
492             roundPrices.push(FundingRound(_startTime, _endTime,_price,false));
493         } else {
494             for (uint i=0 ; i < _whitelist.length ; i++ ) {
495                 whitelist[roundPrices.length][_whitelist[i]] = true;
496             }
497             roundPrices.push(FundingRound(_startTime, _endTime,_price,true));
498         }
499     }
500 
501     // CALLED BY ICO OPERATOR TO SET RATE WITHOUT SETTING FUNDING ROUND
502     function setRate(uint _rate) onlyOperator public {
503         rate = _rate;
504     }
505 
506     // CALLED BY ICO OPERATOR TO APPLY WHITELIST AND PRICE OF FUNDING ROUND
507     function setCurrentFundingRound(uint _fundingRound) public onlyOperator {
508         require(roundPrices.length > _fundingRound);
509         currentFundingRound = _fundingRound;
510         rate = roundPrices[_fundingRound].rate;
511     }
512 
513     // RECEIVES FUNDS AND CREATES OFFER
514     function () public payable {
515         require(msg.value > 0);
516         if (roundPrices[currentFundingRound].hasWhitelist == true) {
517             require(whitelist[currentFundingRound][msg.sender] == true);
518         }
519         uint dealNumber = deals[msg.sender].numberOfDeals;
520         offers[msg.sender][dealNumber].investor = msg.sender;
521         offers[msg.sender][dealNumber].etherAmount = msg.value;
522         deals[msg.sender].numberOfDeals += 1;
523     }
524 
525     // IF OFFER NOT ACCEPTED, CAN BE WITHDRAWN
526     function withdrawOffer(uint _offerNumber) public {
527         require(offers[msg.sender][_offerNumber].accepted == false);
528         require(msg.sender.send(offers[msg.sender][_offerNumber].etherAmount));
529         offers[msg.sender][_offerNumber].etherAmount = 0;
530         /* offers[msg.sender][_offerNumber].tokenAmount = 0; */
531     }
532 
533     // ARBITRATION
534     // CALLED BY ARBITRATION ADDRESS
535     function disputeOpened(address _investor) public {
536         require(msg.sender == arbitrationAddress);
537         deals[_investor].disputing = true;
538     }
539 
540     // CALLED BY ARBITRATION ADDRESS
541     function verdictExecuted(address _investor, bool _verdictForInvestor,uint _milestoneDispute) public {
542         require(msg.sender == arbitrationAddress);
543         require(deals[_investor].disputing == true);
544         if (_verdictForInvestor) {
545             deals[_investor].verdictForInvestor = true;
546         } else {
547             deals[_investor].verdictForProject = true;
548             for (uint i = _milestoneDispute; i < currentMilestone; i++) {
549                 postDisputeEth += etherPartition[_investor][i];
550                 deals[_investor].etherUsed += etherPartition[_investor][i];
551             }
552         }
553         deals[_investor].disputing = false;
554     }
555 
556     // OPERATOR
557     // TO ADD MILESTONES
558     function addMilestone(uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed onlyOperator returns(uint) {
559         totalEther = totalEther.add(_etherAmount);
560         totalToken = totalToken.add(_tokenAmount);
561         return milestones.push(Milestone(_etherAmount, _tokenAmount, _startTime, 0, _duration, _description, ""));
562     }
563 
564     // TO EDIT MILESTONES
565     function editMilestone(uint _id, uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed onlyOperator {
566         assert(_id < milestones.length);
567         totalEther = (totalEther - milestones[_id].etherAmount).add(_etherAmount); //previous addition
568         totalToken = (totalToken - milestones[_id].tokenAmount).add(_tokenAmount);
569         milestones[_id].etherAmount = _etherAmount;
570         milestones[_id].tokenAmount = _tokenAmount;
571         milestones[_id].startTime = _startTime;
572         milestones[_id].duration = _duration;
573         milestones[_id].description = _description;
574     }
575 
576     // TO SEAL
577     function seal() public notSealed onlyOperator {
578         require(milestones.length > 0);
579         require(token.balanceOf(address(this)) >= totalToken);
580         sealTimestamp = now;
581     }
582 
583     // TO ACCEPT OFFER
584     function acceptOffer(address _investor, uint _offerNumber) public sealed onlyOperator {
585         // REQUIRE THAT OFFER HAS NOT BEEN APPROVED
586         require(offers[_investor][_offerNumber].etherAmount > 0);
587         require(offers[_investor][_offerNumber].accepted != true);
588         // APPROVE OFFER
589         offers[_investor][_offerNumber].accepted = true;
590         // CALCULATE TOKENS
591         uint  _etherAmount = offers[_investor][_offerNumber].etherAmount;
592         uint _tokenAmount = offers[_investor][_offerNumber].tokenAmount;
593         require(token.balanceOf(address(this)) >= promisedTokens + _tokenAmount);
594         // CALCULATE COMMISSION
595         if (commissionOnInvestmentEth > 0 || commissionOnInvestmentJot > 0) {
596             uint etherCommission = _etherAmount.mul(commissionOnInvestmentEth).div(100);
597             uint jotCommission = _etherAmount.mul(commissionOnInvestmentJot).div(100);
598             _etherAmount = _etherAmount.sub(etherCommission).sub(jotCommission);
599             offers[_investor][_offerNumber].etherAmount = _etherAmount;
600 
601             etherAllowance += etherCommission;
602             jotAllowance += jotCommission;
603         }
604         assignPartition(_investor, _etherAmount, _tokenAmount);
605         if (!(deals[_investor].sumEther > 0)) dealsList.push(_investor);
606         if (tokenReleaseAtStart == true) {
607             deals[_investor].tokenAllowance = _tokenAmount;
608         }
609 
610         deals[_investor].sumEther += _etherAmount;
611         deals[_investor].sumToken += _tokenAmount;
612     	// ADDS TO TOTALS
613     	promisedTokens += _tokenAmount;
614     	raisedEther += _etherAmount;
615     }
616 
617     // TO START MILESTONE
618     function startMilestone() public sealed onlyOperator {
619         // UNCOMMENT 2 LINES BELOW FOR PROJECT FAILS START IF totalEther < raisedEther
620         // if (currentMilestone == 0 && totalEther < raisedEther) { roundFailedToStart = true; }
621         // require(!roundFailedToStart);
622         if (currentMilestone != 0 ) {require(milestones[currentMilestone-1].finishTime > 0);}
623         for (uint i=0; i < dealsList.length ; i++) {
624             address investor = dealsList[i];
625             if (deals[investor].disputing == false) {
626                 if (deals[investor].verdictForInvestor != true) {
627                     ethForMilestone += etherPartition[investor][currentMilestone];
628                     deals[investor].etherUsed += etherPartition[investor][currentMilestone];
629                     if (tokenReleaseAtStart == false) {
630                         deals[investor].tokenAllowance += tokenPartition[investor][currentMilestone];
631                     }
632                 }
633             }
634         }
635         milestones[currentMilestone].startTime = now;
636         currentMilestone +=1;
637         ethForMilestone = payCommission();
638 	//ethForMilestone = ethForMilestone.sub(ethAfterCommission);
639     }
640 
641     // CALCULATES COMMISSION
642     function payCommission() internal returns(uint) {
643         if (commissionEth.length >= currentMilestone) {
644             uint ethCommission = raisedEther.mul(commissionEth[currentMilestone-1]).div(100);
645             uint jotCommission = raisedEther.mul(commissionJot[currentMilestone-1]).div(100);
646             etherAllowance += ethCommission;
647             jotAllowance += jotCommission;
648             return ethForMilestone.sub(ethCommission).sub(jotCommission);
649         } else {
650             return ethForMilestone;
651         }
652     }
653 
654     // TO FINISH MILESTONE
655     function finishMilestone(string _result) public onlyOperator {
656         require(milestones[currentMilestone-1].finishTime == 0);
657         uint interval = now - milestones[currentMilestone-1].startTime;
658         require(interval > 1 weeks);
659         milestones[currentMilestone-1].finishTime = now;
660         milestones[currentMilestone-1].result = _result;
661     }
662     // -------------------------------------------------------------------------
663     //
664     // HELPERS -----------------------------------------------------------------
665     function failSafe() public onlyAdmin {
666         if (msg.sender == operator) {
667             saveMe = true;
668         }
669         if (msg.sender == juryOperator) {
670             require(saveMe == true);
671             require(juryOperator.send(address(this).balance));
672             uint allTheLockedTokens = token.balanceOf(this);
673             require(token.transfer(juryOperator,allTheLockedTokens));
674         }
675     }
676 
677     function milestonesLength() public view returns(uint) {
678         return milestones.length;
679     }
680 
681     function assignPartition(address _investor, uint _etherAmount, uint _tokenAmount) internal {
682         uint milestoneEtherAmount; //How much Ether does investor send for a milestone
683 		uint milestoneTokenAmount; //How many Tokens does investor receive for a milestone
684 		uint milestoneEtherTarget; //How much TOTAL Ether a milestone needs
685 		uint milestoneTokenTarget; //How many TOTAL tokens a milestone releases
686 		uint totalEtherInvestment;
687 		uint totalTokenInvestment;
688         for(uint i=currentMilestone; i<milestones.length; i++) {
689 			milestoneEtherTarget = milestones[i].etherAmount;
690             milestoneTokenTarget = milestones[i].tokenAmount;
691 			milestoneEtherAmount = _etherAmount.mul(milestoneEtherTarget).div(totalEther);
692 			milestoneTokenAmount = _tokenAmount.mul(milestoneTokenTarget).div(totalToken);
693 			totalEtherInvestment = totalEtherInvestment.add(milestoneEtherAmount); //used to prevent rounding errors
694 			totalTokenInvestment = totalTokenInvestment.add(milestoneTokenAmount); //used to prevent rounding errors
695             if (deals[_investor].sumEther > 0) {
696                 etherPartition[_investor][i] += milestoneEtherAmount;
697     			tokenPartition[_investor][i] += milestoneTokenAmount;
698             } else {
699                 etherPartition[_investor].push(milestoneEtherAmount);
700     			tokenPartition[_investor].push(milestoneTokenAmount);
701             }
702 
703 		}
704         /* roundingErrors += _etherAmount - totalEtherInvestment; */
705 		etherPartition[_investor][currentMilestone] += _etherAmount - totalEtherInvestment; //rounding error is added to the first milestone
706 		tokenPartition[_investor][currentMilestone] += _tokenAmount - totalTokenInvestment; //rounding error is added to the first milestone
707     }
708 
709     // VIEWS
710     function isDisputing(address _investor) public view returns(bool) {
711         return deals[_investor].disputing;
712     }
713 
714     function investorExists(address _investor) public view returns(bool) {
715         if (deals[_investor].sumEther > 0) return true;
716         else return false;
717     }
718 
719 }
720 
721 contract Arbitration is Owned {
722 
723     address public operator;
724 
725     uint public quorum = 3;
726 
727     struct Dispute {
728         address icoRoundAddress;
729         address investorAddress;
730         bool pending;
731         uint timestamp;
732         uint milestone;
733         string reason;
734         uint votesForProject;
735         uint votesForInvestor;
736         // bool verdictForProject;
737         // bool verdictForInvestor;
738         mapping(address => bool) voters;
739     }
740     mapping(uint => Dispute) public disputes;
741 
742     uint public disputeLength;
743 
744     mapping(address => mapping(address => bool)) public arbiterPool;
745 
746     modifier only(address _allowed) {
747         require(msg.sender == _allowed);
748         _;
749     }
750 
751     constructor() public {
752         operator = msg.sender;
753     }
754 
755     // OPERATOR
756     function setArbiters(address _icoRoundAddress, address[] _arbiters) only(owner) public {
757         for (uint i = 0; i < _arbiters.length ; i++) {
758             arbiterPool[_icoRoundAddress][_arbiters[i]] = true;
759         }
760     }
761 
762     // ARBITER
763     function vote(uint _disputeId, bool _voteForInvestor) public {
764         require(disputes[_disputeId].pending == true);
765         require(arbiterPool[disputes[_disputeId].icoRoundAddress][msg.sender] == true);
766         require(disputes[_disputeId].voters[msg.sender] != true);
767         if (_voteForInvestor == true) { disputes[_disputeId].votesForInvestor += 1; }
768         else { disputes[_disputeId].votesForProject += 1; }
769         if (disputes[_disputeId].votesForInvestor == quorum) {
770             executeVerdict(_disputeId,true);
771         }
772         if (disputes[_disputeId].votesForProject == quorum) {
773             executeVerdict(_disputeId,false);
774         }
775         disputes[_disputeId].voters[msg.sender] == true;
776     }
777 
778     // INVESTOR
779     function openDispute(address _icoRoundAddress, string _reason) public {
780         Cycle icoRound = Cycle(_icoRoundAddress);
781         uint milestoneDispute = icoRound.currentMilestone();
782         require(milestoneDispute > 0);
783         require(icoRound.investorExists(msg.sender) == true);
784         disputes[disputeLength].milestone = milestoneDispute;
785 
786         disputes[disputeLength].icoRoundAddress = _icoRoundAddress;
787         disputes[disputeLength].investorAddress = msg.sender;
788         disputes[disputeLength].timestamp = now;
789         disputes[disputeLength].reason = _reason;
790         disputes[disputeLength].pending = true;
791 
792         icoRound.disputeOpened(msg.sender);
793         disputeLength +=1;
794     }
795 
796     // INTERNAL
797     function executeVerdict(uint _disputeId, bool _verdictForInvestor) internal {
798         disputes[_disputeId].pending = false;
799         uint milestoneDispute = disputes[_disputeId].milestone;
800         Cycle icoRound = Cycle(disputes[_disputeId].icoRoundAddress);
801         icoRound.verdictExecuted(disputes[_disputeId].investorAddress,_verdictForInvestor,milestoneDispute);
802         //counter +=1;
803     }
804 
805     function isPending(uint _disputedId) public view returns(bool) {
806         return disputes[_disputedId].pending;
807     }
808 
809 }
810 
811 contract Jotter {
812     // for an ethToJot of 2,443.0336457941, Aug 21, 2018
813     Token public token;
814     uint public ethToJot = 2443;
815     address public owner;
816 
817     constructor(address _jotAddress) public {
818         owner = msg.sender;
819         token = Token(_jotAddress);
820     }
821 
822     function swapMe() public payable {
823         uint jot = msg.value * ethToJot;
824         require(token.transfer(owner,jot));
825     }
826     // In the future, this contract would call a trusted Oracle
827     // instead of being set by its owner
828     function setEth(uint _newEth) public {
829         require(msg.sender == owner);
830         ethToJot = _newEth;
831     }
832 
833 }
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
233 // File: contracts/KvantorSet.sol
234 
235 // DEPLOYED BY JURY.ONLINE
236 contract ICOContractX {
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
287 contract ICOCycle {
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
301     address public swapper; // address for JOT commission
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
348     // amounts stores as percentage
349     // If length == 1, commission paid when investment is accepted
350     // If length > 1, each element is commission to corresponding milestone
351     // ETH commission is transferred to Jury.Online wallet
352     // JOT commission is transferred to a Swapper contract that swaps eth for jot
353     uint[] public commissionEth;
354     uint[] public commissionJot;
355     uint public etherAllowance; // Amount that Jury.Online can withdraw as commission in ETH
356     uint public jotAllowance; // Amount that Jury.Online can withdraw as commission in JOT
357 
358     uint public totalEther; // Sum of ether in milestones
359     uint public totalToken; // Sum of tokens in milestones
360 
361     uint public promisedTokens; // Sum of tokens promised by accepting offer
362     uint public raisedEther; // Sum of ether raised by accepting offer
363 
364     uint public rate; // eth to token rate in current Funding Round
365     bool public tokenReleaseAtStart; // whether to release tokens at start or by each milestone
366     uint public currentFundingRound;
367 
368     bool public roundFailedToStart;
369 
370     // Stores amount of ether and tokens per milestone for each investor
371     mapping(address => uint[]) public etherPartition;
372     mapping(address => uint[]) public tokenPartition;
373 
374     // Funding Rounds can be added with start, end time, rate, and whitelist
375     struct FundingRound {
376         uint startTime;
377         uint endTime;
378         uint rate;
379         bool hasWhitelist;
380     }
381 
382     FundingRound[] public roundPrices;  // stores list of funding rounds
383     mapping(uint => mapping(address => bool)) public whitelist; // stores whitelists
384 
385     // -------------------------------------------------------------------------
386     // MODIFIERS
387     modifier onlyOperator() {
388         require(msg.sender == operator || msg.sender == juryOperator);
389         _;
390     }
391 
392     modifier onlyAdmin() {
393         require(msg.sender == operator || msg.sender == juryOperator);
394         _;
395     }
396 
397     modifier sealed() {
398         require(sealTimestamp != 0);
399         /* require(now > sealTimestamp); */
400         _;
401     }
402 
403     modifier notSealed() {
404         require(sealTimestamp == 0);
405         /* require(now <= sealTimestamp); */
406         _;
407     }
408     // -------------------------------------------------------------------------
409     // DEPLOYED BY JURY.ONLINE
410     // PARAMS:
411     // address _icoAddress
412     // address _operator
413     // uint _rate
414     // address _swapper
415     // uint[] _commissionEth
416     // uint[] _commissionJot
417     constructor( address _icoAddress, address _operator, uint _rate, address _swapper, uint[] _commissionEth, uint[] _commissionJot) public {
418         require(_commissionEth.length == _commissionJot.length);
419         juryOperator = msg.sender;
420         icoAddress = _icoAddress;
421         operator = _operator;
422         rate = _rate;
423         swapper = _swapper;
424         commissionEth = _commissionEth;
425         commissionJot = _commissionJot;
426         roundPrices.push(FundingRound(0,0,0,false));
427         tokenReleaseAtStart = true;
428     }
429 
430     // CALLED BY JURY.ONLINE TO SET SWAPPER ADDRESS FOR JOT COMMISSION
431     function setSwapper(address _swapper) public {
432         require(msg.sender == juryOperator);
433         swapper = _swapper;
434     }
435 
436     // CALLED BY ADMIN TO RETRIEVE INFORMATION FROM ICOADDRESS AND ADD ITSELF
437     // TO LIST OF CYCLES IN ICO
438     function activate() onlyAdmin notSealed public {
439         ICOContractX icoContract = ICOContractX(icoAddress);
440         require(icoContract.operator() == operator);
441         juryOnlineWallet = icoContract.juryOnlineWallet();
442         projectWallet = icoContract.projectWallet();
443         arbitrationAddress = icoContract.arbitrationAddress();
444         token = icoContract.token();
445         icoContract.addRound();
446     }
447 
448     // CALLED BY JURY.ONLINE TO RETRIEVE COMMISSION
449     // CALLED BY ICO OPERATOR TO RETRIEVE FUNDS
450     // CALLED BY INVESTOR TO RETRIEVE FUNDS AFTER DISPUTE
451     function withdrawEther() public {
452         if (roundFailedToStart == true) {
453             require(msg.sender.send(deals[msg.sender].sumEther));
454         }
455         if (msg.sender == operator) {
456             require(projectWallet.send(ethForMilestone+postDisputeEth));
457             ethForMilestone = 0;
458             postDisputeEth = 0;
459         }
460         if (msg.sender == juryOnlineWallet) {
461             require(juryOnlineWallet.send(etherAllowance));
462             require(swapper.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
463             etherAllowance = 0;
464             jotAllowance = 0;
465         }
466         if (deals[msg.sender].verdictForInvestor == true) {
467             require(msg.sender.send(deals[msg.sender].sumEther - deals[msg.sender].etherUsed));
468         }
469     }
470 
471     // CALLED BY INVESTOR TO RETRIEVE TOKENS
472     function withdrawToken() public {
473         require(token.transfer(msg.sender,deals[msg.sender].tokenAllowance));
474         deals[msg.sender].tokenAllowance = 0;
475     }
476 
477     // CALLED BY ICO OPERATOR TO ADD FUNDING ROUNDS WITH _startTime,_endTime,_price,_whitelist
478     function addRoundPrice(uint _startTime,uint _endTime, uint _price, address[] _whitelist) public onlyOperator {
479         if (_whitelist.length == 0) {
480             roundPrices.push(FundingRound(_startTime, _endTime,_price,false));
481         } else {
482             for (uint i=0 ; i < _whitelist.length ; i++ ) {
483                 whitelist[roundPrices.length][_whitelist[i]] = true;
484             }
485             roundPrices.push(FundingRound(_startTime, _endTime,_price,true));
486         }
487     }
488 
489     // CALLED BY ICO OPERATOR TO SET RATE WITHOUT SETTING FUNDING ROUND
490     function setRate(uint _rate) onlyOperator public {
491         rate = _rate;
492     }
493 
494     // CALLED BY ICO OPERATOR TO APPLY WHITELIST AND PRICE OF FUNDING ROUND
495     function setCurrentFundingRound(uint _fundingRound) public onlyOperator {
496         require(roundPrices.length > _fundingRound);
497         currentFundingRound = _fundingRound;
498     }
499 
500     // RECEIVES FUNDS AND CREATES OFFER
501     function () public payable {
502         require(msg.value > 0);
503         if (roundPrices[currentFundingRound].hasWhitelist == true) {
504             require(whitelist[currentFundingRound][msg.sender] == true);
505         }
506         uint dealNumber = deals[msg.sender].numberOfDeals;
507         offers[msg.sender][dealNumber].investor = msg.sender;
508         offers[msg.sender][dealNumber].etherAmount = msg.value;
509         deals[msg.sender].numberOfDeals += 1;
510     }
511 
512     // CALCULATES AMOUNT OF TOKENS FOR GIVEN ETH
513     function calculateTokens(uint256 _weiAmount) constant public returns (uint256) {
514 
515         uint256 tokens = _weiAmount.mul(rate).mul(100).div(75).div(100 finney);
516         if(tokens.div(100000000) < 5000)
517             return _weiAmount.mul(rate).mul(100).div(80).div(100 finney);
518 
519         tokens = _weiAmount.mul(rate).mul(100).div(73).div(100 finney);
520         if(tokens.div(100000000) < 25000)
521             return _weiAmount.mul(rate).mul(100).div(75).div(100 finney);
522 
523         tokens = _weiAmount.mul(rate).mul(100).div(70).div(100 finney);
524         if(tokens.div(100000000) < 50000)
525             return _weiAmount.mul(rate).mul(100).div(73).div(100 finney);
526 
527         tokens = _weiAmount.mul(rate).mul(100).div(65).div(100 finney);
528         if(tokens.div(100000000) < 250000)
529             return _weiAmount.mul(rate).mul(100).div(70).div(100 finney);
530 
531         tokens = _weiAmount.mul(rate).mul(100).div(60).div(100 finney);
532         if(tokens.div(100000000) < 500000)
533             return _weiAmount.mul(rate).mul(100).div(65).div(100 finney);
534 
535         return _weiAmount.mul(rate).mul(100).div(60).div(100 finney);
536     }
537 
538     // IF OFFER NOT ACCEPTED, CAN BE WITHDRAWN
539     function withdrawOffer(uint _offerNumber) public {
540         require(offers[msg.sender][_offerNumber].accepted == false);
541         require(msg.sender.send(offers[msg.sender][_offerNumber].etherAmount));
542         offers[msg.sender][_offerNumber].etherAmount = 0;
543         /* offers[msg.sender][_offerNumber].tokenAmount = 0; */
544     }
545 
546     // ARBITRATION
547     // CALLED BY ARBITRATION ADDRESS
548     function disputeOpened(address _investor) public {
549         require(msg.sender == arbitrationAddress);
550         deals[_investor].disputing = true;
551     }
552 
553     // CALLED BY ARBITRATION ADDRESS
554     function verdictExecuted(address _investor, bool _verdictForInvestor,uint _milestoneDispute) public {
555         require(msg.sender == arbitrationAddress);
556         require(deals[_investor].disputing == true);
557         if (_verdictForInvestor) {
558             deals[_investor].verdictForInvestor = true;
559         } else {
560             deals[_investor].verdictForProject = true;
561             for (uint i = _milestoneDispute; i < currentMilestone; i++) {
562                 postDisputeEth += etherPartition[_investor][i];
563                 deals[_investor].etherUsed += etherPartition[_investor][i];
564             }
565         }
566         deals[_investor].disputing = false;
567     }
568 
569     // OPERATOR
570     // TO ADD MILESTONES
571     function addMilestone(uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed onlyOperator returns(uint) {
572         totalEther = totalEther.add(_etherAmount);
573         totalToken = totalToken.add(_tokenAmount);
574         return milestones.push(Milestone(_etherAmount, _tokenAmount, _startTime, 0, _duration, _description, ""));
575     }
576 
577     // TO SEAL
578     function seal() public notSealed onlyOperator {
579         require(milestones.length > 0);
580         require(token.balanceOf(address(this)) >= totalToken);
581         sealTimestamp = now;
582     }
583 
584     // TO ACCEPT OFFER
585     function acceptOffer(address _investor, uint _offerNumber) public sealed onlyOperator {
586         // REQUIRE THAT OFFER HAS NOT BEEN APPROVED
587         require(offers[_investor][_offerNumber].etherAmount > 0);
588         require(offers[_investor][_offerNumber].accepted != true);
589         // APPROVE OFFER
590         offers[_investor][_offerNumber].accepted = true;
591         // CALCULATE TOKENS
592         uint  _etherAmount = offers[_investor][_offerNumber].etherAmount;
593         uint _tokenAmount = calculateTokens(_etherAmount);
594         offers[_investor][_offerNumber].tokenAmount = _tokenAmount;
595         //require(token.balanceOf(address(this)) >= promisedTokens + _tokenAmount);
596         // CALCULATE COMMISSION
597         if (commissionEth.length == 1) {
598             uint etherCommission = _etherAmount.mul(commissionEth[0]).div(100);
599             uint jotCommission = _etherAmount.mul(commissionJot[0]).div(100);
600             _etherAmount = _etherAmount.sub(etherCommission).sub(jotCommission);
601             offers[_investor][_offerNumber].etherAmount = _etherAmount;
602 
603             etherAllowance += etherCommission;
604             jotAllowance += jotCommission;
605         }
606         assignPartition(_investor, _etherAmount, _tokenAmount);
607         if (!(deals[_investor].sumEther > 0)) dealsList.push(_investor);
608         if (tokenReleaseAtStart == true) {
609             deals[_investor].tokenAllowance = _tokenAmount;
610         }
611         /* deals[_investor].numberOfDeals += 1; */
612         deals[_investor].sumEther += _etherAmount;
613         deals[_investor].sumToken += _tokenAmount;
614     }
615 
616     // TO START MILESTONE
617     function startMilestone() public sealed onlyOperator {
618         // UNCOMMENT 2 LINES BELOW FOR PROJECT FAILS START IF totalEther < raisedEther
619         // if (currentMilestone == 0 && totalEther < raisedEther) { roundFailedToStart = true; }
620         // require(!roundFailedToStart);
621         if (currentMilestone != 0 ) {require(milestones[currentMilestone-1].finishTime > 0);}
622         for (uint i=0; i < dealsList.length ; i++) {
623             address investor = dealsList[i];
624             if (deals[investor].disputing == false) {
625                 if (deals[investor].verdictForInvestor != true) {
626                     ethForMilestone += etherPartition[investor][currentMilestone];
627                     deals[investor].etherUsed += etherPartition[investor][currentMilestone];
628                     if (tokenReleaseAtStart == false) {
629                         deals[investor].tokenAllowance += tokenPartition[investor][currentMilestone];
630                     }
631                 }
632             }
633         }
634         milestones[currentMilestone].startTime = now;
635         currentMilestone +=1;
636         //ethAfterCommission = payCommission();
637     }
638 
639     // TO FINISH MILESTONE
640     function finishMilestone(string _result) public onlyOperator {
641         require(milestones[currentMilestone-1].finishTime == 0);
642         uint interval = now - milestones[currentMilestone-1].startTime;
643         require(interval > 1 weeks);
644         milestones[currentMilestone-1].finishTime = now;
645         milestones[currentMilestone-1].result = _result;
646     }
647     // -------------------------------------------------------------------------
648     //
649     // HELPERS -----------------------------------------------------------------
650     function failSafe() public onlyAdmin {
651         if (msg.sender == operator) {
652             saveMe = true;
653         }
654         if (msg.sender == juryOperator) {
655             require(saveMe == true);
656             require(juryOperator.send(address(this).balance));
657             uint allTheLockedTokens = token.balanceOf(this);
658             require(token.transfer(juryOperator,allTheLockedTokens));
659         }
660     }
661     function milestonesLength() public view returns(uint) {
662         return milestones.length;
663     }
664     function assignPartition(address _investor, uint _etherAmount, uint _tokenAmount) internal {
665         uint milestoneEtherAmount; //How much Ether does investor send for a milestone
666 		uint milestoneTokenAmount; //How many Tokens does investor receive for a milestone
667 		uint milestoneEtherTarget; //How much TOTAL Ether a milestone needs
668 		uint milestoneTokenTarget; //How many TOTAL tokens a milestone releases
669 		uint totalEtherInvestment;
670 		uint totalTokenInvestment;
671         for(uint i=currentMilestone; i<milestones.length; i++) {
672 			milestoneEtherTarget = milestones[i].etherAmount;
673             milestoneTokenTarget = milestones[i].tokenAmount;
674 			milestoneEtherAmount = _etherAmount.mul(milestoneEtherTarget).div(totalEther);
675 			milestoneTokenAmount = _tokenAmount.mul(milestoneTokenTarget).div(totalToken);
676 			totalEtherInvestment = totalEtherInvestment.add(milestoneEtherAmount); //used to prevent rounding errors
677 			totalTokenInvestment = totalTokenInvestment.add(milestoneTokenAmount); //used to prevent rounding errors
678             if (deals[_investor].sumEther > 0) {
679                 etherPartition[_investor][i] += milestoneEtherAmount;
680     			tokenPartition[_investor][i] += milestoneTokenAmount;
681             } else {
682                 etherPartition[_investor].push(milestoneEtherAmount);
683     			tokenPartition[_investor].push(milestoneTokenAmount);
684             }
685 
686 		}
687         /* roundingErrors += _etherAmount - totalEtherInvestment; */
688 		etherPartition[_investor][currentMilestone] += _etherAmount - totalEtherInvestment; //rounding error is added to the first milestone
689 		tokenPartition[_investor][currentMilestone] += _tokenAmount - totalTokenInvestment; //rounding error is added to the first milestone
690     }
691     function isDisputing(address _investor) public view returns(bool) {
692         return deals[_investor].disputing;
693     }
694     function investorExists(address _investor) public view returns(bool) {
695         if (deals[_investor].sumEther > 0) return true;
696         else return false;
697     }
698 
699 }
700 
701 contract ArbitrationX is Owned {
702     address public operator;
703     uint public quorum = 3;
704     //uint public counter;
705     struct Dispute {
706         address icoRoundAddress;
707         address investorAddress;
708         bool pending;
709         uint timestamp;
710         uint milestone;
711         string reason;
712         uint votesForProject;
713         uint votesForInvestor;
714         // bool verdictForProject;
715         // bool verdictForInvestor;
716         mapping(address => bool) voters;
717     }
718     mapping(uint => Dispute) public disputes;
719     uint public disputeLength;
720     mapping(address => mapping(address => bool)) public arbiterPool;
721 
722     modifier only(address _allowed) {
723         require(msg.sender == _allowed);
724         _;
725     }
726 
727     constructor() public {
728         operator = msg.sender;
729     }
730     // OPERATOR
731     function setArbiters(address _icoRoundAddress, address[] _arbiters) only(owner) public {
732         for (uint i = 0; i < _arbiters.length ; i++) {
733             arbiterPool[_icoRoundAddress][_arbiters[i]] = true;
734         }
735     }
736     // ARBITER
737     function vote(uint _disputeId, bool _voteForInvestor) public {
738         require(disputes[_disputeId].pending == true);
739         require(arbiterPool[disputes[_disputeId].icoRoundAddress][msg.sender] == true);
740         require(disputes[_disputeId].voters[msg.sender] != true);
741         if (_voteForInvestor == true) { disputes[_disputeId].votesForInvestor += 1; }
742         else { disputes[_disputeId].votesForProject += 1; }
743         if (disputes[_disputeId].votesForInvestor == quorum) {
744             executeVerdict(_disputeId,true);
745         }
746         if (disputes[_disputeId].votesForProject == quorum) {
747             executeVerdict(_disputeId,false);
748         }
749         disputes[_disputeId].voters[msg.sender] == true;
750     }
751     // INVESTOR
752     function openDispute(address _icoRoundAddress, string _reason) public {
753         ICOCycle icoRound = ICOCycle(_icoRoundAddress);
754         uint milestoneDispute = icoRound.currentMilestone();
755         require(milestoneDispute > 0);
756         require(icoRound.investorExists(msg.sender) == true);
757         disputes[disputeLength].milestone = milestoneDispute;
758 
759         disputes[disputeLength].icoRoundAddress = _icoRoundAddress;
760         disputes[disputeLength].investorAddress = msg.sender;
761         disputes[disputeLength].timestamp = now;
762         disputes[disputeLength].reason = _reason;
763         disputes[disputeLength].pending = true;
764 
765         icoRound.disputeOpened(msg.sender);
766         disputeLength +=1;
767     }
768     // INTERNAL
769     function executeVerdict(uint _disputeId, bool _verdictForInvestor) internal {
770         disputes[_disputeId].pending = false;
771         uint milestoneDispute = disputes[_disputeId].milestone;
772         ICOCycle icoRound = ICOCycle(disputes[_disputeId].icoRoundAddress);
773         icoRound.verdictExecuted(disputes[_disputeId].investorAddress,_verdictForInvestor,milestoneDispute);
774         //counter +=1;
775     }
776     function isPending(uint _disputedId) public view returns(bool) {
777         return disputes[_disputedId].pending;
778     }
779 }
780 
781 contract Swapper {
782     // for an ethToJot of 2,443.0336457941, Aug 21, 2018
783     Token public token;
784     uint public ethToJot = 2443;
785     address public owner;
786 
787     constructor(address _jotAddress) public {
788         owner = msg.sender;
789         token = Token(_jotAddress);
790     }
791 
792     function swapMe() public payable {
793         uint jot = msg.value * ethToJot;
794         require(token.transfer(owner,jot));
795     }
796     // In the future, this contract would call a trusted Oracle
797     // instead of being set by its owner
798     function setEth(uint _newEth) public {
799         require(msg.sender == owner);
800         ethToJot = _newEth;
801     }
802 
803 }
804 
805 contract SwapperX {
806 
807     Token public proxyToken;
808     Token public token;
809 
810     address public owner;
811 
812     struct Swap {
813         address _from;
814         uint _amount;
815     }
816 
817     Swap[] public swaps;
818 
819     constructor(address _tokenAddress, address _proxyTokenAddress) public {
820         owner = msg.sender;
821         token = Token(_tokenAddress);
822         proxyToken = Token(_proxyTokenAddress);
823     }
824 
825     // SWAPS PROXY TOKENS FOR ICO TOKENS
826     function swapMe() public {
827         uint allowance = proxyToken.allowance(msg.sender,address(this));
828         require(token.balanceOf(address(this)) >= allowance);
829         require(token.transfer(msg.sender, allowance));
830         require(proxyToken.transferFrom(msg.sender,address(this),allowance));
831         swaps.push(Swap(msg.sender,allowance));
832     }
833 
834     // REFUNDS TOKEN HOLDERS ALLOWANCE
835     function returnMe() public {
836         uint allowance = proxyToken.allowance(msg.sender,address(this));
837         require(proxyToken.transferFrom(msg.sender,address(this),allowance));
838         require(proxyToken.transfer(msg.sender, allowance));
839     }
840 
841 }
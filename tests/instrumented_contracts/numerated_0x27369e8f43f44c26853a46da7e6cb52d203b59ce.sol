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
233 // File: contracts/AgileSetWithAssistance.sol
234 
235 // REMEMER TO UNCOMMENT TIME CHECKS!!!!!
236 contract AgileICOWithAssistance {
237 
238     using SafeMath for uint;
239 
240     address public operator; // ICO operator
241     address public juryOperator; // Jury.Online operator
242     address public projectWallet; // Wallet where project funds are sent
243     address public arbitrationAddress; // address of contract that handles arbitration
244     address public juryOnlineWallet; // Wallet for Jury.Online commission
245 
246     bool public requireTokens; // if true, token balance needed before accept offer
247 
248     uint public promisedTokens;
249     uint public etherAllowance;
250     uint public jotAllowance;
251     uint public commissionOnInvestmentJot; // commission paid in ETH when operator accepts offer
252     uint public commissionOnInvestmentEth; // commission paid in JOT when operator accepts offer
253     uint public percentForFuture; // percent of investment offer that is not sent to Cycle and kept for future
254     uint public rate = 1; // amount of token for each wei in investment offer
255     address public currentCycleAddress; // address of current AgileCycle contract
256     uint public currentCycleNumber; // indicates current cycle
257 
258     uint public currentFundingRound; // indicates current funding round (should be removed)
259     uint public minimumInvestment;
260 
261     uint public lastRateChange; // used to prevent changing rates more than once a day
262 
263     Token public token; // proxy or real token
264     // Offer struct stores information about all offers and deals
265     // a deal is an accepted offer
266     struct Offer {
267         uint etherAmount; // etherAmount of investment offer
268         uint tokenAmount; // tokenAmount of investment offer
269         bool accepted; // true if offer has been accepted
270         uint numberOfDeals; // indicates number of deals an investor has
271     }
272     // below mapping maps an investor address to a deal number to the details
273     // of that deal (etherAmount, tokenAmount, accepted, numberOfDeals)
274     mapping(address => mapping(uint => Offer)) public offers;
275 
276     address[] public cycles; // stores the addresses of cycles
277 
278     // Stores the amount stored for future cycles
279     struct FutureDeal {
280         uint etherAmount; // etherAmount for future
281         uint tokenAmount; // tokenAmount for future
282     }
283     // below mapping maps investor address to a futureDeal, that is, an amount
284     // which will be used in future cycles.
285     mapping(address => FutureDeal) public futureDeals;
286 
287     address[] public investorList; // list of investor
288 
289     // FundingRound struct stores information about each FundingRound
290     struct FundingRound {
291         uint startTime;
292         uint endTime;
293         uint rate;
294         bool hasWhitelist;
295     }
296     FundingRound[] public roundPrices;  // stores list of funding rounds
297     mapping(uint => mapping(address => bool)) public whitelist; // stores whitelists (if any) for funding round
298 
299     bool public saveMe;
300 
301     modifier only(address _sender) {
302         require(msg.sender == _sender);
303         _;
304     }
305     modifier onlyAdmin() {
306         require(msg.sender == operator || msg.sender == juryOperator);
307         _;
308     }
309 
310     constructor(
311             address _operator,
312             uint _commissionOnInvestmentJot,
313             uint _commissionOnInvestmentEth,
314             uint _percentForFuture,
315             address _projectWallet,
316             address _arbitrationAddress,
317 	    address _tokenAddress,
318             address _juryOperator,
319             address _juryOnlineWallet,
320 	    uint _minimumInvestment
321         ) public {
322         percentForFuture = _percentForFuture;
323         operator = _operator;
324         commissionOnInvestmentJot = _commissionOnInvestmentJot;
325         commissionOnInvestmentEth = _commissionOnInvestmentEth;
326         percentForFuture = _percentForFuture;
327         projectWallet = _projectWallet;
328         arbitrationAddress = _arbitrationAddress;
329 	token = Token(_tokenAddress);
330         juryOperator = _juryOperator;
331         juryOnlineWallet = _juryOnlineWallet;
332 	minimumInvestment = _minimumInvestment;
333     }
334 
335     // PUBLIC ------------------------------------------------------------------
336     // payable function recieves ETH and creates an 'offer'
337     // wont succeed with 2300 stipend for send, must add more gas
338     function () public payable {
339         // INVESTOR SENDS OFFER BY SENDING ETH TO CONTRACT
340         require(msg.value > minimumInvestment);
341     	for (uint i = 0; i < roundPrices.length; i++ ) {
342 		if (now > roundPrices[i].startTime && now < roundPrices[i].endTime) {
343 			rate = roundPrices[i].rate;
344 			if (roundPrices[i].hasWhitelist == true) {
345 				require(whitelist[i][msg.sender] == true);
346 			}
347 		}
348 	}
349 	/*
350 	if (roundPrices.length > 0) {
351                 if (roundPrices[currentFundingRound].hasWhitelist == true) {
352                     require(whitelist[currentFundingRound][msg.sender] == true);
353                 }
354     	}
355         */
356         uint dealNumber = offers[msg.sender][0].numberOfDeals;
357         // uint dealNumber = 0;
358 	offers[msg.sender][dealNumber].etherAmount = msg.value;
359         offers[msg.sender][dealNumber].tokenAmount = msg.value*rate;
360         offers[msg.sender][0].numberOfDeals += 1;
361     }
362     // Investor can withdraw offer if it has not been accepted
363     function withdrawOffer(uint _offerNumber) public {
364         // INVESTOR CAN WITHDRAW OFFER
365         require(offers[msg.sender][_offerNumber].accepted == false);
366         require(msg.sender.send(offers[msg.sender][_offerNumber].etherAmount));
367         offers[msg.sender][_offerNumber].etherAmount = 0;
368     }
369     // Calles by Jury.Online to retrieve commission
370     function withdrawEther() public {
371         if (msg.sender == juryOperator) {
372             require(juryOnlineWallet.send(etherAllowance));
373             //require(jotter.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
374             etherAllowance = 0;
375             jotAllowance = 0;
376         }
377     }
378     // -------------------------------------------------------------------------
379     // ICO OPERATOR ------------------------------------------------------------
380     // operator can acept offer, it keeps certain amount in futureDeals, and sends
381     // rest to Cycle contract by calling offerAccepted() in Cycle
382     function setToken(address _tokenAddress) public onlyAdmin {
383     	require(token == 0x0000000000000000000000000000000000000000);
384 	    token = Token(_tokenAddress);
385     }
386     function acceptOffer(address _investor, uint _offerNumber) public onlyAdmin {
387         require(offers[_investor][_offerNumber].etherAmount > 0);
388         require(offers[_investor][_offerNumber].accepted != true);
389 
390         AgileCycleWithAssistance cycle = AgileCycleWithAssistance(currentCycleAddress);
391 
392 	    require(cycle.sealTimestamp() > 0);
393 
394         offers[_investor][_offerNumber].accepted = true;
395         uint _etherAmount = offers[_investor][_offerNumber].etherAmount;
396         uint _tokenAmount = offers[_investor][_offerNumber].tokenAmount;
397 
398         require(token.balanceOf(currentCycleAddress) >= promisedTokens + _tokenAmount);
399         uint _etherForFuture = _etherAmount.mul(percentForFuture).div(100);
400         uint _tokenForFuture =  _tokenAmount.mul(percentForFuture).div(100);
401 
402         if (_offerNumber == 0) {
403             futureDeals[_investor].etherAmount += _etherForFuture;
404             futureDeals[_investor].tokenAmount += _tokenForFuture;
405         } else {
406             futureDeals[_investor] = FutureDeal(_etherForFuture,_tokenForFuture);
407         }
408 
409         _etherAmount = _etherAmount.sub(_etherForFuture);
410         _tokenAmount = _tokenAmount.sub(_tokenForFuture);
411 
412         if (commissionOnInvestmentEth > 0 || commissionOnInvestmentJot > 0) {
413             uint etherCommission = _etherAmount.mul(commissionOnInvestmentEth).div(100);
414             uint jotCommission = _etherAmount.mul(commissionOnInvestmentJot).div(100);
415 	        _etherAmount = _etherAmount.sub(etherCommission).sub(jotCommission);
416             offers[_investor][_offerNumber].etherAmount = _etherAmount;
417             etherAllowance += etherCommission;
418             jotAllowance += jotCommission;
419         }
420         investorList.push(_investor);
421         cycle.offerAccepted.value(_etherAmount)(_investor, _tokenAmount);
422     }
423     // after deploying Cycle, operator adds cycle address
424     function addCycleAddress(address _cycleAddress) public onlyAdmin {
425         cycles.push(_cycleAddress);
426     }
427     // Sets the active cycle. If not first one, previous one has to be finished.
428     function setNextCycle() public onlyAdmin {
429         require(cycles.length > 0);
430         if (currentCycleNumber > 0) {
431             AgileCycleWithAssistance cycle = AgileCycleWithAssistance(currentCycleAddress);
432             uint finishedTimeStamp = cycle.finishedTimeStamp();
433             require(now > finishedTimeStamp);
434             uint interval = now - finishedTimeStamp;
435             //require(interval > 3 days);
436         }
437         currentCycleAddress = cycles[currentCycleNumber];
438         currentCycleNumber += 1;
439     }
440     // to add FundingRounds
441     function addFundingRound(uint _startTime,uint _endTime, uint _rate, address[] _whitelist) public onlyAdmin {
442         if (_whitelist.length == 0) {
443             roundPrices.push(FundingRound(_startTime, _endTime,_rate,false));
444         } else {
445             for (uint i=0 ; i < _whitelist.length ; i++ ) {
446                 whitelist[roundPrices.length][_whitelist[i]] = true;
447             }
448             roundPrices.push(FundingRound(_startTime, _endTime,_rate,true));
449         }
450     }
451     // to set rate directly
452     function setRate(uint _rate) onlyAdmin public {
453         uint interval = now - lastRateChange;
454         //require(interval < 1 days);
455         rate = _rate;
456     }
457     // to activate a fundingRound
458     function setCurrentFundingRound(uint _fundingRound) public onlyAdmin {
459         require(roundPrices.length > _fundingRound);
460         currentFundingRound = _fundingRound;
461         rate = roundPrices[_fundingRound].rate;
462     }
463     // sends futureDeal funds to next cycle
464     // it has loop control in case of lack of gas
465     function sendFundsToNextCycle(uint _startLoop, uint _endLoop) public onlyAdmin {
466         AgileCycleWithAssistance cycle = AgileCycleWithAssistance(currentCycleAddress);
467         require(cycle.sealTimestamp() > 0);
468 
469         uint _promisedTokens = cycle.promisedTokens();
470         uint _balanceTokens = token.balanceOf(currentCycleAddress);
471 
472         if (_endLoop == 0) _endLoop = investorList.length;
473         require(_endLoop <= investorList.length);
474 
475         require(token.balanceOf(currentCycleAddress) >= promisedTokens + _tokenAmount);
476 
477         for ( uint i=_startLoop; i < _endLoop; i++ ) {
478     	    address _investor = investorList[i];
479     	    uint _etherAmount = futureDeals[_investor].etherAmount;
480     	    uint _tokenAmount = futureDeals[_investor].tokenAmount;
481             _promisedTokens += _tokenAmount;
482             if (requireTokens) require(_balanceTokens >= _promisedTokens);
483     	    cycle.offerAccepted.value(_etherAmount)(_investor, _tokenAmount);
484     	    futureDeals[_investor].etherAmount = 0;
485     	    futureDeals[_investor].tokenAmount = 0;
486     	    //futureDeals[_investor].sent = true;
487         }
488     }
489     // -------------------------------------------------------------------------
490     // HELPERS -----------------------------------------------------------------
491     function failSafe() public {
492         if (msg.sender == operator) {
493             saveMe = true;
494         }
495         if (msg.sender == juryOperator) {
496             require(saveMe == true);
497             require(juryOperator.send(address(this).balance));
498             uint allTheLockedTokens = token.balanceOf(this);
499             require(token.transfer(juryOperator,allTheLockedTokens));
500         }
501     }
502 
503 }
504 
505 contract AgileCycleWithAssistance {
506     using SafeMath for uint;
507     //VARIABLES
508     address public operator; // should be same as ICO (no check for this yet)
509     address public juryOperator; // for failsafe
510     uint public promisedTokens; // the number of tokens owed to investor by accepting offer
511     uint public raisedEther; // amount of ether raised by accepting offers
512 
513     bool public tokenReleaseAtStart; // whether tokens released at start or by milestones
514 
515     address public icoAddress; // ICO address
516     address public arbitrationAddress;
517 
518     bool public roundFailedToStart;
519     address public projectWallet;
520     address public juryOnlineWallet;
521 
522     struct Milestone {
523         uint etherAmount; //how many Ether is needed for this milestone
524         uint tokenAmount; //how many tokens releases this milestone
525         uint startTime; //real time when milestone has started, set upon start
526         uint finishTime; //real time when milestone has finished, set upon finish
527         uint duration; //assumed duration for milestone implementation, set upon milestone creation
528         string description;
529         string result;
530     }
531     Milestone[] public milestones; // list of milestones
532 
533     uint[] public commissionEth; // each element corresponds to amount of commission paid in each milestone
534     uint[] public commissionJot; // same as above, but in JOT. Both amount stored in percentages
535     uint public currentMilestone; // stores index of current milestone
536     uint public etherAllowance; // amount allowed for Jury.Online in commission ETH
537     uint public jotAllowance; // amount allowed for Jury.Online in commission JOT
538     uint public ethForMilestone; // amomunt allowed for project to withdraw in milestone
539     Token public token; // Real or Proxy token
540     uint public totalToken; // sum of Tokens in all milestones
541     uint public totalEther; // sum of ETH in all milstones
542     uint public sealTimestamp; // timestamp when Cycle is sealed
543 
544     mapping(address => uint[]) public etherPartition;
545     mapping(address => uint[]) public tokenPartition;
546 
547     struct Deal {
548         uint etherAmount; // amount of ETH in deal
549         uint tokenAmount; // amount of Tokens in deal
550         bool disputing; // true if disputing, funds are frozen
551         uint tokenAllowance; // amount allowed for investor to withdraw
552         uint etherUsed; // ETH already used and not available for refund
553         bool verdictForProject; // verdict for project
554         bool verdictForInvestor; // verdict for investor
555     }
556     mapping(address => Deal) public deals; // mapping of investor to deal
557     address[] public dealsList; // list of addresses of investor deals, used for iteration in startMilestone()
558 
559     uint public finishedTimeStamp; // when all milestones are finished. Checked by ICO.
560 
561     uint public postDisputeEth; // for debugging
562     bool public saveMe; //for failsafe
563     bool public cycleApproved; // Jury must approve the start of an ICO
564 
565     modifier only(address _allowed) {
566         require(msg.sender == _allowed);
567         _;
568     }
569     modifier onlyAdmin() {
570         require(msg.sender == operator || msg.sender == juryOperator);
571         _;
572     }
573     modifier sealed() {
574     	require(sealTimestamp > 0);
575     	_;
576     }
577     modifier notSealed() {
578     	require(sealTimestamp == 0);
579     	_;
580     }
581 
582     constructor(
583             bool _tokenReleaseAtStart,
584             address _icoAddress,
585             uint[] _commissionEth,
586             uint[] _commissionJot,
587             address _operator,
588             address _juryOperator,
589             address _arbitrationAddress,
590             address _projectWallet,
591             address _juryOnlineWallet
592         ) public {
593             tokenReleaseAtStart = _tokenReleaseAtStart;
594             icoAddress = _icoAddress;
595             commissionEth = _commissionEth;
596             commissionJot = _commissionJot;
597             operator = _operator;
598             juryOperator = _juryOperator;
599             arbitrationAddress = _arbitrationAddress;
600             projectWallet = _projectWallet;
601             juryOnlineWallet = _juryOnlineWallet;
602     }
603 
604     function setToken(address _tokenAddress) public onlyAdmin {
605     	require(token == 0x0000000000000000000000000000000000000000);
606 	    token = Token(_tokenAddress);
607     }
608     // CALLED BY JURY.ONLINE TO RETRIEVE COMMISSION
609     // CALLED BY ICO OPERATOR TO RETRIEVE FUNDS
610     // CALLED BY INVESTOR TO RETRIEVE FUNDS AFTER DISPUTE
611     function withdrawEther() public {
612         if (roundFailedToStart == true) {
613             require(msg.sender.send(deals[msg.sender].etherAmount));
614         }
615         if (msg.sender == operator) {
616             require(projectWallet.send(ethForMilestone+postDisputeEth));
617             ethForMilestone = 0;
618             postDisputeEth = 0;
619         }
620         if (msg.sender == juryOperator) {
621             require(juryOnlineWallet.send(etherAllowance));
622             //require(jotter.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
623             etherAllowance = 0;
624             jotAllowance = 0;
625         }
626         if (deals[msg.sender].verdictForInvestor == true) {
627             require(msg.sender.send(deals[msg.sender].etherAmount - deals[msg.sender].etherUsed));
628         }
629     }
630     // CALLED BY INVESTOR TO RETRIEVE TOKENS
631     function withdrawToken() public {
632         require(token.transfer(msg.sender,deals[msg.sender].tokenAllowance));
633         deals[msg.sender].tokenAllowance = 0;
634     }
635 
636 
637     // OPERATOR ----------------------------------------------------------------
638     function addMilestonesAndSeal(uint[] _etherAmounts, uint[] _tokenAmounts, uint[] _startTimes, uint[] _durations) public notSealed onlyAdmin {
639     	require(_etherAmounts.length == _tokenAmounts.length);
640 	require(_startTimes.length == _durations.length);
641 	require(_durations.length == _etherAmounts.length);
642 	for (uint i = 0; i < _etherAmounts.length; i++) {
643 		totalEther = totalEther.add(_etherAmounts[i]);
644 		totalToken = totalToken.add(_tokenAmounts[i]);
645 		milestones.push(Milestone(_etherAmounts[i], _tokenAmounts[i], _startTimes[i],0,_durations[i],"",""));
646 	}
647 	sealTimestamp = now;
648     }
649     function addMilestone(uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed onlyAdmin returns(uint) {
650         totalEther = totalEther.add(_etherAmount);
651         totalToken = totalToken.add(_tokenAmount);
652         return milestones.push(Milestone(_etherAmount, _tokenAmount, _startTime, 0, _duration, _description, ""));
653     }
654     function approveCycle(bool _approved) public {
655         require(cycleApproved != true && roundFailedToStart != true);
656         require(msg.sender == juryOperator);
657         if (_approved == true) {
658             cycleApproved = true;
659         } else {
660             roundFailedToStart = true;
661         }
662     }
663     function startMilestone() public sealed onlyAdmin {
664         require(cycleApproved);
665         // UNCOMMENT 2 LINES BELOW FOR PROJECT FAILS START IF totalEther < raisedEther
666         // if (currentMilestone == 0 && totalEther < raisedEther) { roundFailedToStart = true; }
667         // require(!roundFailedToStart);
668         if (currentMilestone != 0 ) {
669             require(milestones[currentMilestone-1].finishTime > 0);
670             uint interval = now - milestones[currentMilestone-1].finishTime;
671             require(interval > 3 days);
672         }
673         for (uint i=0; i < dealsList.length ; i++) {
674             address investor = dealsList[i];
675             if (deals[investor].disputing == false) {
676                 if (deals[investor].verdictForInvestor != true) {
677                     ethForMilestone += etherPartition[investor][currentMilestone];
678                     deals[investor].etherUsed += etherPartition[investor][currentMilestone];
679                     if (tokenReleaseAtStart == false) {
680                         deals[investor].tokenAllowance += tokenPartition[investor][currentMilestone];
681                     }
682                 }
683             }
684         }
685         milestones[currentMilestone].startTime = now;
686         currentMilestone +=1;
687         ethForMilestone = payCommission();
688     }
689     function finishMilestone(string _result) public onlyAdmin {
690         require(milestones[currentMilestone-1].finishTime == 0);
691         // UNCOMMENT LINES BELOW FOR PRODUCTION!!!!
692 	    uint interval = now - milestones[currentMilestone-1].startTime;
693         require(interval > 1 weeks);
694         milestones[currentMilestone-1].finishTime = now;
695         milestones[currentMilestone-1].result = _result;
696         if (currentMilestone == milestones.length) {
697             finishedTimeStamp = now;
698         }
699     }
700     function editMilestone(uint _id, uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed onlyAdmin {
701         assert(_id < milestones.length);
702         totalEther = (totalEther - milestones[_id].etherAmount).add(_etherAmount); //previous addition
703         totalToken = (totalToken - milestones[_id].tokenAmount).add(_tokenAmount);
704         milestones[_id].etherAmount = _etherAmount;
705         milestones[_id].tokenAmount = _tokenAmount;
706         milestones[_id].startTime = _startTime;
707         milestones[_id].duration = _duration;
708         milestones[_id].description = _description;
709     }
710 
711     function seal() public notSealed onlyAdmin {
712         require(milestones.length > 0);
713         // Uncomment bottom line to require balance when sealing contract
714         // currently balance is required only when accepting offer
715         //require(token.balanceOf(address(this)) >= promisedTokens);
716         sealTimestamp = now;
717     }
718     // -------------------------------------------------------------------------
719     // ONLY(ICO) ---------------------------------------------------------------
720     // when operator accepts offer in ICO contract, it calls this function to add deal
721     function offerAccepted(address _investor, uint _tokenAmount) public payable only(icoAddress) {
722 	    require(sealTimestamp > 0);
723         uint _etherAmount = msg.value;
724         assignPartition(_investor, _etherAmount, _tokenAmount);
725         if (!(deals[_investor].etherAmount > 0)) dealsList.push(_investor);
726         if (tokenReleaseAtStart == true) {
727             deals[_investor].tokenAllowance = _tokenAmount;
728         }
729         deals[_investor].etherAmount += _etherAmount;
730         deals[_investor].tokenAmount += _tokenAmount;
731     	// ADDS TO TOTALS
732     	promisedTokens += _tokenAmount;
733     	raisedEther += _etherAmount;
734     }
735     // -------------------------------------------------------------------------
736     // ONLY(ARBITRATION) -------------------------------------------------------
737     function disputeOpened(address _investor) public only(arbitrationAddress) {
738         deals[_investor].disputing = true;
739     }
740     function verdictExecuted(address _investor, bool _verdictForInvestor,uint _milestoneDispute) public only(arbitrationAddress) {
741         require(deals[_investor].disputing == true);
742         if (_verdictForInvestor) {
743             deals[_investor].verdictForInvestor = true;
744         } else {
745             deals[_investor].verdictForProject = true;
746             for (uint i = _milestoneDispute; i < currentMilestone; i++) {
747                 postDisputeEth += etherPartition[_investor][i];
748                 deals[_investor].etherUsed += etherPartition[_investor][i];
749             }
750         }
751         deals[_investor].disputing = false;
752     }
753     // -------------------------------------------------------------------------
754     // INTERNAL ----------------------------------------------------------------
755     function assignPartition(address _investor, uint _etherAmount, uint _tokenAmount) internal {
756         uint milestoneEtherAmount; //How much Ether does investor send for a milestone
757         uint milestoneTokenAmount; //How many Tokens does investor receive for a milestone
758         uint milestoneEtherTarget; //How much TOTAL Ether a milestone needs
759         uint milestoneTokenTarget; //How many TOTAL tokens a milestone releases
760         uint totalEtherInvestment;
761         uint totalTokenInvestment;
762         for(uint i=currentMilestone; i<milestones.length; i++) {
763             milestoneEtherTarget = milestones[i].etherAmount;
764             milestoneTokenTarget = milestones[i].tokenAmount;
765             milestoneEtherAmount = _etherAmount.mul(milestoneEtherTarget).div(totalEther);
766             milestoneTokenAmount = _tokenAmount.mul(milestoneTokenTarget).div(totalToken);
767             totalEtherInvestment = totalEtherInvestment.add(milestoneEtherAmount); //used to prevent rounding errors
768             totalTokenInvestment = totalTokenInvestment.add(milestoneTokenAmount); //used to prevent rounding errors
769             if (deals[_investor].etherAmount > 0) {
770                 etherPartition[_investor][i] += milestoneEtherAmount;
771                 tokenPartition[_investor][i] += milestoneTokenAmount;
772             } else {
773                 etherPartition[_investor].push(milestoneEtherAmount);
774                 tokenPartition[_investor].push(milestoneTokenAmount);
775             }
776 
777         }
778         /* roundingErrors += _etherAmount - totalEtherInvestment; */
779         etherPartition[_investor][currentMilestone] += _etherAmount - totalEtherInvestment; //rounding error is added to the first milestone
780         tokenPartition[_investor][currentMilestone] += _tokenAmount - totalTokenInvestment; //rounding error is added to the first milestone
781     }
782     function payCommission() internal returns(uint) {
783         if (commissionEth.length >= currentMilestone) {
784             uint ethCommission = raisedEther.mul(commissionEth[currentMilestone-1]).div(100);
785             uint jotCommission = raisedEther.mul(commissionJot[currentMilestone-1]).div(100);
786             etherAllowance += ethCommission;
787             jotAllowance += jotCommission;
788             return ethForMilestone.sub(ethCommission).sub(jotCommission);
789         } else {
790             return ethForMilestone;
791         }
792     }
793     // -------------------------------------------------------------------------
794     // HELPERS -----------------------------------------------------------------
795     function milestonesLength() public view returns(uint) {
796         return milestones.length;
797     }
798     function investorExists(address _investor) public view returns(bool) {
799         if (deals[_investor].etherAmount > 0) return true;
800         else return false;
801     }
802     function failSafe() public {
803         if (msg.sender == operator) {
804             saveMe = true;
805         }
806         if (msg.sender == juryOperator) {
807             require(saveMe == true);
808             require(juryOperator.send(address(this).balance));
809             uint allTheLockedTokens = token.balanceOf(this);
810             require(token.transfer(juryOperator,allTheLockedTokens));
811         }
812     }
813 }
814 
815 
816 contract AgileArbitrationWithAssistance is Owned {
817 
818     address public operator;
819 
820     uint public quorum = 3;
821 
822     struct Dispute {
823         address icoRoundAddress;
824         address investorAddress;
825         bool pending;
826         uint timestamp;
827         uint milestone;
828         string reason;
829         uint votesForProject;
830         uint votesForInvestor;
831         // bool verdictForProject;
832         // bool verdictForInvestor;
833         mapping(address => bool) voters;
834     }
835     mapping(uint => Dispute) public disputes;
836 
837     uint public disputeLength;
838 
839     mapping(address => mapping(address => bool)) public arbiterPool;
840 
841     modifier only(address _allowed) {
842         require(msg.sender == _allowed);
843         _;
844     }
845 
846     constructor() public {
847         operator = msg.sender;
848     }
849 
850     // OPERATOR
851     function setArbiters(address _icoRoundAddress, address[] _arbiters) only(owner) public {
852         for (uint i = 0; i < _arbiters.length ; i++) {
853             arbiterPool[_icoRoundAddress][_arbiters[i]] = true;
854         }
855     }
856 
857     // ARBITER
858     function vote(uint _disputeId, bool _voteForInvestor) public {
859         require(disputes[_disputeId].pending == true);
860         require(arbiterPool[disputes[_disputeId].icoRoundAddress][msg.sender] == true);
861         require(disputes[_disputeId].voters[msg.sender] != true);
862         if (_voteForInvestor == true) { disputes[_disputeId].votesForInvestor += 1; }
863         else { disputes[_disputeId].votesForProject += 1; }
864         if (disputes[_disputeId].votesForInvestor == quorum) {
865             executeVerdict(_disputeId,true);
866         }
867         if (disputes[_disputeId].votesForProject == quorum) {
868             executeVerdict(_disputeId,false);
869         }
870         disputes[_disputeId].voters[msg.sender] == true;
871     }
872 
873     // INVESTOR
874     function openDispute(address _icoRoundAddress, string _reason) public {
875         AgileCycleWithAssistance cycle = AgileCycleWithAssistance(_icoRoundAddress);
876         uint milestoneDispute = cycle.currentMilestone();
877         require(milestoneDispute > 0);
878         require(cycle.investorExists(msg.sender) == true);
879         disputes[disputeLength].milestone = milestoneDispute;
880 
881         disputes[disputeLength].icoRoundAddress = _icoRoundAddress;
882         disputes[disputeLength].investorAddress = msg.sender;
883         disputes[disputeLength].timestamp = now;
884         disputes[disputeLength].reason = _reason;
885         disputes[disputeLength].pending = true;
886 
887         cycle.disputeOpened(msg.sender);
888         disputeLength +=1;
889     }
890 
891     // INTERNAL
892     function executeVerdict(uint _disputeId, bool _verdictForInvestor) internal {
893         disputes[_disputeId].pending = false;
894         uint milestoneDispute = disputes[_disputeId].milestone;
895         AgileCycleWithAssistance cycle = AgileCycleWithAssistance(disputes[_disputeId].icoRoundAddress);
896         cycle.verdictExecuted(disputes[_disputeId].investorAddress,_verdictForInvestor,milestoneDispute);
897         //counter +=1;
898     }
899 
900     function isPending(uint _disputedId) public view returns(bool) {
901         return disputes[_disputedId].pending;
902     }
903 
904 }
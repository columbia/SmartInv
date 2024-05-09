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
233 // File: contracts/AgileSet.sol
234 
235 // REMEMER TO UNCOMMENT TIME CHECKS!!!!!
236 contract AgileICO {
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
305 
306     constructor(
307             address _operator,
308             uint _commissionOnInvestmentJot,
309             uint _commissionOnInvestmentEth,
310             uint _percentForFuture,
311             address _projectWallet,
312             address _arbitrationAddress,
313 	    address _tokenAddress,
314             address _juryOperator,
315             address _juryOnlineWallet,
316 	    uint _minimumInvestment
317         ) public {
318         percentForFuture = _percentForFuture;
319         operator = _operator;
320         commissionOnInvestmentJot = _commissionOnInvestmentJot;
321         commissionOnInvestmentEth = _commissionOnInvestmentEth;
322         percentForFuture = _percentForFuture;
323         projectWallet = _projectWallet;
324         arbitrationAddress = _arbitrationAddress;
325 	token = Token(_tokenAddress);
326         juryOperator = _juryOperator;
327         juryOnlineWallet = _juryOnlineWallet;
328 	minimumInvestment = _minimumInvestment;
329     }
330 
331     // PUBLIC ------------------------------------------------------------------
332     // payable function recieves ETH and creates an 'offer'
333     // wont succeed with 2300 stipend for send, must add more gas
334     function () public payable {
335         // INVESTOR SENDS OFFER BY SENDING ETH TO CONTRACT
336         require(msg.value > minimumInvestment);
337     	for (uint i = 0; i < roundPrices.length; i++ ) {
338 		if (now > roundPrices[i].startTime && now < roundPrices[i].endTime) {
339 			rate = roundPrices[i].rate;
340 			if (roundPrices[i].hasWhitelist == true) {
341 				require(whitelist[i][msg.sender] == true);
342 			}
343 		}
344 	}
345 	/*
346 	if (roundPrices.length > 0) {
347                 if (roundPrices[currentFundingRound].hasWhitelist == true) {
348                     require(whitelist[currentFundingRound][msg.sender] == true);
349                 }
350     	}
351         */
352         uint dealNumber = offers[msg.sender][0].numberOfDeals;
353         // uint dealNumber = 0;
354 	offers[msg.sender][dealNumber].etherAmount = msg.value;
355         offers[msg.sender][dealNumber].tokenAmount = msg.value*rate;
356         offers[msg.sender][0].numberOfDeals += 1;
357     }
358     // Investor can withdraw offer if it has not been accepted
359     function withdrawOffer(uint _offerNumber) public {
360         // INVESTOR CAN WITHDRAW OFFER
361         require(offers[msg.sender][_offerNumber].accepted == false);
362         require(msg.sender.send(offers[msg.sender][_offerNumber].etherAmount));
363         offers[msg.sender][_offerNumber].etherAmount = 0;
364     }
365     // Calles by Jury.Online to retrieve commission
366     function withdrawEther() public {
367         if (msg.sender == juryOperator) {
368             require(juryOnlineWallet.send(etherAllowance));
369             //require(jotter.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
370             etherAllowance = 0;
371             jotAllowance = 0;
372         }
373     }
374     // -------------------------------------------------------------------------
375     // ICO OPERATOR ------------------------------------------------------------
376     // operator can acept offer, it keeps certain amount in futureDeals, and sends
377     // rest to Cycle contract by calling offerAccepted() in Cycle
378     function setToken(address _tokenAddress) public only(operator) {
379     	require(token == 0x0000000000000000000000000000000000000000);
380 	    token = Token(_tokenAddress);
381     }
382     function acceptOffer(address _investor, uint _offerNumber) public only(operator) {
383         require(offers[_investor][_offerNumber].etherAmount > 0);
384         require(offers[_investor][_offerNumber].accepted != true);
385 
386         AgileCycle cycle = AgileCycle(currentCycleAddress);
387 
388 	    require(cycle.sealTimestamp() > 0);
389 
390         offers[_investor][_offerNumber].accepted = true;
391         uint _etherAmount = offers[_investor][_offerNumber].etherAmount;
392         uint _tokenAmount = offers[_investor][_offerNumber].tokenAmount;
393 
394         require(token.balanceOf(currentCycleAddress) >= promisedTokens + _tokenAmount);
395         uint _etherForFuture = _etherAmount.mul(percentForFuture).div(100);
396         uint _tokenForFuture =  _tokenAmount.mul(percentForFuture).div(100);
397 
398         if (_offerNumber == 0) {
399             futureDeals[_investor].etherAmount += _etherForFuture;
400             futureDeals[_investor].tokenAmount += _tokenForFuture;
401         } else {
402             futureDeals[_investor] = FutureDeal(_etherForFuture,_tokenForFuture);
403         }
404 
405         _etherAmount = _etherAmount.sub(_etherForFuture);
406         _tokenAmount = _tokenAmount.sub(_tokenForFuture);
407 
408         if (commissionOnInvestmentEth > 0 || commissionOnInvestmentJot > 0) {
409             uint etherCommission = _etherAmount.mul(commissionOnInvestmentEth).div(100);
410             uint jotCommission = _etherAmount.mul(commissionOnInvestmentJot).div(100);
411 	        _etherAmount = _etherAmount.sub(etherCommission).sub(jotCommission);
412             offers[_investor][_offerNumber].etherAmount = _etherAmount;
413             etherAllowance += etherCommission;
414             jotAllowance += jotCommission;
415         }
416         investorList.push(_investor);
417         cycle.offerAccepted.value(_etherAmount)(_investor, _tokenAmount);
418     }
419     // after deploying Cycle, operator adds cycle address
420     function addCycleAddress(address _cycleAddress) public only(operator) {
421         cycles.push(_cycleAddress);
422     }
423     // Sets the active cycle. If not first one, previous one has to be finished.
424     function setNextCycle() public only(operator) {
425         require(cycles.length > 0);
426         if (currentCycleNumber > 0) {
427             AgileCycle cycle = AgileCycle(currentCycleAddress);
428             uint finishedTimeStamp = cycle.finishedTimeStamp();
429             require(now > finishedTimeStamp);
430             uint interval = now - finishedTimeStamp;
431             //require(interval > 3 days);
432         }
433         currentCycleAddress = cycles[currentCycleNumber];
434         currentCycleNumber += 1;
435     }
436     // to add FundingRounds
437     function addFundingRound(uint _startTime,uint _endTime, uint _rate, address[] _whitelist) public only(operator) {
438         if (_whitelist.length == 0) {
439             roundPrices.push(FundingRound(_startTime, _endTime,_rate,false));
440         } else {
441             for (uint i=0 ; i < _whitelist.length ; i++ ) {
442                 whitelist[roundPrices.length][_whitelist[i]] = true;
443             }
444             roundPrices.push(FundingRound(_startTime, _endTime,_rate,true));
445         }
446     }
447     // to set rate directly
448     function setRate(uint _rate) only(operator) public {
449         uint interval = now - lastRateChange;
450         //require(interval < 1 days);
451         rate = _rate;
452     }
453     // to activate a fundingRound
454     function setCurrentFundingRound(uint _fundingRound) public only(operator) {
455         require(roundPrices.length > _fundingRound);
456         currentFundingRound = _fundingRound;
457         rate = roundPrices[_fundingRound].rate;
458     }
459     // sends futureDeal funds to next cycle
460     // it has loop control in case of lack of gas
461     function sendFundsToNextCycle(uint _startLoop, uint _endLoop) public only(operator) {
462         AgileCycle cycle = AgileCycle(currentCycleAddress);
463         require(cycle.sealTimestamp() > 0);
464 
465         uint _promisedTokens = cycle.promisedTokens();
466         uint _balanceTokens = token.balanceOf(currentCycleAddress);
467 
468         if (_endLoop == 0) _endLoop = investorList.length;
469         require(_endLoop <= investorList.length);
470 
471         require(token.balanceOf(currentCycleAddress) >= promisedTokens + _tokenAmount);
472 
473         for ( uint i=_startLoop; i < _endLoop; i++ ) {
474     	    address _investor = investorList[i];
475     	    uint _etherAmount = futureDeals[_investor].etherAmount;
476     	    uint _tokenAmount = futureDeals[_investor].tokenAmount;
477             _promisedTokens += _tokenAmount;
478             if (requireTokens) require(_balanceTokens >= _promisedTokens);
479     	    cycle.offerAccepted.value(_etherAmount)(_investor, _tokenAmount);
480     	    futureDeals[_investor].etherAmount = 0;
481     	    futureDeals[_investor].tokenAmount = 0;
482     	    //futureDeals[_investor].sent = true;
483         }
484     }
485     // -------------------------------------------------------------------------
486     // HELPERS -----------------------------------------------------------------
487     function failSafe() public {
488         if (msg.sender == operator) {
489             saveMe = true;
490         }
491         if (msg.sender == juryOperator) {
492             require(saveMe == true);
493             require(juryOperator.send(address(this).balance));
494             uint allTheLockedTokens = token.balanceOf(this);
495             require(token.transfer(juryOperator,allTheLockedTokens));
496         }
497     }
498 
499 }
500 
501 contract AgileCycle {
502     using SafeMath for uint;
503     //VARIABLES
504     address public operator; // should be same as ICO (no check for this yet)
505     address public juryOperator; // for failsafe
506     uint public promisedTokens; // the number of tokens owed to investor by accepting offer
507     uint public raisedEther; // amount of ether raised by accepting offers
508 
509     bool public tokenReleaseAtStart; // whether tokens released at start or by milestones
510 
511     address public icoAddress; // ICO address
512     address public arbitrationAddress;
513 
514     bool public roundFailedToStart;
515     address public projectWallet;
516     address public juryOnlineWallet;
517 
518     struct Milestone {
519         uint etherAmount; //how many Ether is needed for this milestone
520         uint tokenAmount; //how many tokens releases this milestone
521         uint startTime; //real time when milestone has started, set upon start
522         uint finishTime; //real time when milestone has finished, set upon finish
523         uint duration; //assumed duration for milestone implementation, set upon milestone creation
524         string description;
525         string result;
526     }
527     Milestone[] public milestones; // list of milestones
528 
529     uint[] public commissionEth; // each element corresponds to amount of commission paid in each milestone
530     uint[] public commissionJot; // same as above, but in JOT. Both amount stored in percentages
531     uint public currentMilestone; // stores index of current milestone
532     uint public etherAllowance; // amount allowed for Jury.Online in commission ETH
533     uint public jotAllowance; // amount allowed for Jury.Online in commission JOT
534     uint public ethForMilestone; // amomunt allowed for project to withdraw in milestone
535     Token public token; // Real or Proxy token
536     uint public totalToken; // sum of Tokens in all milestones
537     uint public totalEther; // sum of ETH in all milstones
538     uint public sealTimestamp; // timestamp when Cycle is sealed
539 
540     mapping(address => uint[]) public etherPartition;
541     mapping(address => uint[]) public tokenPartition;
542 
543     struct Deal {
544         uint etherAmount; // amount of ETH in deal
545         uint tokenAmount; // amount of Tokens in deal
546         bool disputing; // true if disputing, funds are frozen
547         uint tokenAllowance; // amount allowed for investor to withdraw
548         uint etherUsed; // ETH already used and not available for refund
549         bool verdictForProject; // verdict for project
550         bool verdictForInvestor; // verdict for investor
551     }
552     mapping(address => Deal) public deals; // mapping of investor to deal
553     address[] public dealsList; // list of addresses of investor deals, used for iteration in startMilestone()
554 
555     uint public finishedTimeStamp; // when all milestones are finished. Checked by ICO.
556 
557     uint public postDisputeEth; // for debugging
558     bool public saveMe; //for failsafe
559     bool public cycleApproved; // Jury must approve the start of an ICO
560 
561     modifier only(address _allowed) {
562         require(msg.sender == _allowed);
563         _;
564     }
565     modifier sealed() {
566     	require(sealTimestamp > 0);
567     	_;
568     }
569     modifier notSealed() {
570     	require(sealTimestamp == 0);
571     	_;
572     }
573 
574     constructor(
575             bool _tokenReleaseAtStart,
576             address _icoAddress,
577             uint[] _commissionEth,
578             uint[] _commissionJot,
579             address _operator,
580             address _juryOperator,
581             address _arbitrationAddress,
582             address _projectWallet,
583             address _juryOnlineWallet
584         ) public {
585             tokenReleaseAtStart = _tokenReleaseAtStart;
586             icoAddress = _icoAddress;
587             commissionEth = _commissionEth;
588             commissionJot = _commissionJot;
589             operator = _operator;
590             juryOperator = _juryOperator;
591             arbitrationAddress = _arbitrationAddress;
592             projectWallet = _projectWallet;
593             juryOnlineWallet = _juryOnlineWallet;
594     }
595 
596     function setToken(address _tokenAddress) public only(operator) {
597     	require(token == 0x0000000000000000000000000000000000000000);
598 	    token = Token(_tokenAddress);
599     }
600     // CALLED BY JURY.ONLINE TO RETRIEVE COMMISSION
601     // CALLED BY ICO OPERATOR TO RETRIEVE FUNDS
602     // CALLED BY INVESTOR TO RETRIEVE FUNDS AFTER DISPUTE
603     function withdrawEther() public {
604         if (roundFailedToStart == true) {
605             require(msg.sender.send(deals[msg.sender].etherAmount));
606         }
607         if (msg.sender == operator) {
608             require(projectWallet.send(ethForMilestone+postDisputeEth));
609             ethForMilestone = 0;
610             postDisputeEth = 0;
611         }
612         if (msg.sender == juryOperator) {
613             require(juryOnlineWallet.send(etherAllowance));
614             //require(jotter.call.value(jotAllowance)(abi.encodeWithSignature("swapMe()")));
615             etherAllowance = 0;
616             jotAllowance = 0;
617         }
618         if (deals[msg.sender].verdictForInvestor == true) {
619             require(msg.sender.send(deals[msg.sender].etherAmount - deals[msg.sender].etherUsed));
620         }
621     }
622     // CALLED BY INVESTOR TO RETRIEVE TOKENS
623     function withdrawToken() public {
624         require(token.transfer(msg.sender,deals[msg.sender].tokenAllowance));
625         deals[msg.sender].tokenAllowance = 0;
626     }
627 
628 
629     // OPERATOR ----------------------------------------------------------------
630     function addMilestonesAndSeal(uint[] _etherAmounts, uint[] _tokenAmounts, uint[] _startTimes, uint[] _durations) public notSealed only(operator) {
631     	require(_etherAmounts.length == _tokenAmounts.length);
632 	require(_startTimes.length == _durations.length);
633 	require(_durations.length == _etherAmounts.length);
634 	for (uint i = 0; i < _etherAmounts.length; i++) {
635 		totalEther = totalEther.add(_etherAmounts[i]);
636 		totalToken = totalToken.add(_tokenAmounts[i]);
637 		milestones.push(Milestone(_etherAmounts[i], _tokenAmounts[i], _startTimes[i],0,_durations[i],"",""));
638 	}
639 	sealTimestamp = now;
640     }
641     function addMilestone(uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed only(operator) returns(uint) {
642         totalEther = totalEther.add(_etherAmount);
643         totalToken = totalToken.add(_tokenAmount);
644         return milestones.push(Milestone(_etherAmount, _tokenAmount, _startTime, 0, _duration, _description, ""));
645     }
646     function approveCycle(bool _approved) public {
647         require(cycleApproved != true && roundFailedToStart != true);
648         require(msg.sender == juryOperator);
649         if (_approved == true) {
650             cycleApproved = true;
651         } else {
652             roundFailedToStart = true;
653         }
654     }
655     function startMilestone() public sealed only(operator) {
656         require(cycleApproved);
657         // UNCOMMENT 2 LINES BELOW FOR PROJECT FAILS START IF totalEther < raisedEther
658         // if (currentMilestone == 0 && totalEther < raisedEther) { roundFailedToStart = true; }
659         // require(!roundFailedToStart);
660         if (currentMilestone != 0 ) {
661             require(milestones[currentMilestone-1].finishTime > 0);
662             uint interval = now - milestones[currentMilestone-1].finishTime;
663             require(interval > 3 days);
664         }
665         for (uint i=0; i < dealsList.length ; i++) {
666             address investor = dealsList[i];
667             if (deals[investor].disputing == false) {
668                 if (deals[investor].verdictForInvestor != true) {
669                     ethForMilestone += etherPartition[investor][currentMilestone];
670                     deals[investor].etherUsed += etherPartition[investor][currentMilestone];
671                     if (tokenReleaseAtStart == false) {
672                         deals[investor].tokenAllowance += tokenPartition[investor][currentMilestone];
673                     }
674                 }
675             }
676         }
677         milestones[currentMilestone].startTime = now;
678         currentMilestone +=1;
679         ethForMilestone = payCommission();
680     }
681     function finishMilestone(string _result) public only(operator) {
682         require(milestones[currentMilestone-1].finishTime == 0);
683         // UNCOMMENT LINES BELOW FOR PRODUCTION!!!!
684 	    uint interval = now - milestones[currentMilestone-1].startTime;
685         require(interval > 1 weeks);
686         milestones[currentMilestone-1].finishTime = now;
687         milestones[currentMilestone-1].result = _result;
688         if (currentMilestone == milestones.length) {
689             finishedTimeStamp = now;
690         }
691     }
692     function editMilestone(uint _id, uint _etherAmount, uint _tokenAmount, uint _startTime, uint _duration, string _description) public notSealed only(operator) {
693         assert(_id < milestones.length);
694         totalEther = (totalEther - milestones[_id].etherAmount).add(_etherAmount); //previous addition
695         totalToken = (totalToken - milestones[_id].tokenAmount).add(_tokenAmount);
696         milestones[_id].etherAmount = _etherAmount;
697         milestones[_id].tokenAmount = _tokenAmount;
698         milestones[_id].startTime = _startTime;
699         milestones[_id].duration = _duration;
700         milestones[_id].description = _description;
701     }
702 
703     function seal() public notSealed only(operator) {
704         require(milestones.length > 0);
705         // Uncomment bottom line to require balance when sealing contract
706         // currently balance is required only when accepting offer
707         //require(token.balanceOf(address(this)) >= promisedTokens);
708         sealTimestamp = now;
709     }
710     // -------------------------------------------------------------------------
711     // ONLY(ICO) ---------------------------------------------------------------
712     // when operator accepts offer in ICO contract, it calls this function to add deal
713     function offerAccepted(address _investor, uint _tokenAmount) public payable only(icoAddress) {
714 	    require(sealTimestamp > 0);
715         uint _etherAmount = msg.value;
716         assignPartition(_investor, _etherAmount, _tokenAmount);
717         if (!(deals[_investor].etherAmount > 0)) dealsList.push(_investor);
718         if (tokenReleaseAtStart == true) {
719             deals[_investor].tokenAllowance = _tokenAmount;
720         }
721         deals[_investor].etherAmount += _etherAmount;
722         deals[_investor].tokenAmount += _tokenAmount;
723     	// ADDS TO TOTALS
724     	promisedTokens += _tokenAmount;
725     	raisedEther += _etherAmount;
726     }
727     // -------------------------------------------------------------------------
728     // ONLY(ARBITRATION) -------------------------------------------------------
729     function disputeOpened(address _investor) public only(arbitrationAddress) {
730         deals[_investor].disputing = true;
731     }
732     function verdictExecuted(address _investor, bool _verdictForInvestor,uint _milestoneDispute) public only(arbitrationAddress) {
733         require(deals[_investor].disputing == true);
734         if (_verdictForInvestor) {
735             deals[_investor].verdictForInvestor = true;
736         } else {
737             deals[_investor].verdictForProject = true;
738             for (uint i = _milestoneDispute; i < currentMilestone; i++) {
739                 postDisputeEth += etherPartition[_investor][i];
740                 deals[_investor].etherUsed += etherPartition[_investor][i];
741             }
742         }
743         deals[_investor].disputing = false;
744     }
745     // -------------------------------------------------------------------------
746     // INTERNAL ----------------------------------------------------------------
747     function assignPartition(address _investor, uint _etherAmount, uint _tokenAmount) internal {
748         uint milestoneEtherAmount; //How much Ether does investor send for a milestone
749         uint milestoneTokenAmount; //How many Tokens does investor receive for a milestone
750         uint milestoneEtherTarget; //How much TOTAL Ether a milestone needs
751         uint milestoneTokenTarget; //How many TOTAL tokens a milestone releases
752         uint totalEtherInvestment;
753         uint totalTokenInvestment;
754         for(uint i=currentMilestone; i<milestones.length; i++) {
755             milestoneEtherTarget = milestones[i].etherAmount;
756             milestoneTokenTarget = milestones[i].tokenAmount;
757             milestoneEtherAmount = _etherAmount.mul(milestoneEtherTarget).div(totalEther);
758             milestoneTokenAmount = _tokenAmount.mul(milestoneTokenTarget).div(totalToken);
759             totalEtherInvestment = totalEtherInvestment.add(milestoneEtherAmount); //used to prevent rounding errors
760             totalTokenInvestment = totalTokenInvestment.add(milestoneTokenAmount); //used to prevent rounding errors
761             if (deals[_investor].etherAmount > 0) {
762                 etherPartition[_investor][i] += milestoneEtherAmount;
763                 tokenPartition[_investor][i] += milestoneTokenAmount;
764             } else {
765                 etherPartition[_investor].push(milestoneEtherAmount);
766                 tokenPartition[_investor].push(milestoneTokenAmount);
767             }
768 
769         }
770         /* roundingErrors += _etherAmount - totalEtherInvestment; */
771         etherPartition[_investor][currentMilestone] += _etherAmount - totalEtherInvestment; //rounding error is added to the first milestone
772         tokenPartition[_investor][currentMilestone] += _tokenAmount - totalTokenInvestment; //rounding error is added to the first milestone
773     }
774     function payCommission() internal returns(uint) {
775         if (commissionEth.length >= currentMilestone) {
776             uint ethCommission = raisedEther.mul(commissionEth[currentMilestone-1]).div(100);
777             uint jotCommission = raisedEther.mul(commissionJot[currentMilestone-1]).div(100);
778             etherAllowance += ethCommission;
779             jotAllowance += jotCommission;
780             return ethForMilestone.sub(ethCommission).sub(jotCommission);
781         } else {
782             return ethForMilestone;
783         }
784     }
785     // -------------------------------------------------------------------------
786     // HELPERS -----------------------------------------------------------------
787     function milestonesLength() public view returns(uint) {
788         return milestones.length;
789     }
790     function investorExists(address _investor) public view returns(bool) {
791         if (deals[_investor].etherAmount > 0) return true;
792         else return false;
793     }
794     function failSafe() public {
795         if (msg.sender == operator) {
796             saveMe = true;
797         }
798         if (msg.sender == juryOperator) {
799             require(saveMe == true);
800             require(juryOperator.send(address(this).balance));
801             uint allTheLockedTokens = token.balanceOf(this);
802             require(token.transfer(juryOperator,allTheLockedTokens));
803         }
804     }
805 }
806 
807 
808 contract AgileArbitration is Owned {
809 
810     address public operator;
811 
812     uint public quorum = 3;
813 
814     struct Dispute {
815         address icoRoundAddress;
816         address investorAddress;
817         bool pending;
818         uint timestamp;
819         uint milestone;
820         string reason;
821         uint votesForProject;
822         uint votesForInvestor;
823         // bool verdictForProject;
824         // bool verdictForInvestor;
825         mapping(address => bool) voters;
826     }
827     mapping(uint => Dispute) public disputes;
828 
829     uint public disputeLength;
830 
831     mapping(address => mapping(address => bool)) public arbiterPool;
832 
833     modifier only(address _allowed) {
834         require(msg.sender == _allowed);
835         _;
836     }
837 
838     constructor() public {
839         operator = msg.sender;
840     }
841 
842     // OPERATOR
843     function setArbiters(address _icoRoundAddress, address[] _arbiters) only(owner) public {
844         for (uint i = 0; i < _arbiters.length ; i++) {
845             arbiterPool[_icoRoundAddress][_arbiters[i]] = true;
846         }
847     }
848 
849     // ARBITER
850     function vote(uint _disputeId, bool _voteForInvestor) public {
851         require(disputes[_disputeId].pending == true);
852         require(arbiterPool[disputes[_disputeId].icoRoundAddress][msg.sender] == true);
853         require(disputes[_disputeId].voters[msg.sender] != true);
854         if (_voteForInvestor == true) { disputes[_disputeId].votesForInvestor += 1; }
855         else { disputes[_disputeId].votesForProject += 1; }
856         if (disputes[_disputeId].votesForInvestor == quorum) {
857             executeVerdict(_disputeId,true);
858         }
859         if (disputes[_disputeId].votesForProject == quorum) {
860             executeVerdict(_disputeId,false);
861         }
862         disputes[_disputeId].voters[msg.sender] == true;
863     }
864 
865     // INVESTOR
866     function openDispute(address _icoRoundAddress, string _reason) public {
867         AgileCycle cycle = AgileCycle(_icoRoundAddress);
868         uint milestoneDispute = cycle.currentMilestone();
869         require(milestoneDispute > 0);
870         require(cycle.investorExists(msg.sender) == true);
871         disputes[disputeLength].milestone = milestoneDispute;
872 
873         disputes[disputeLength].icoRoundAddress = _icoRoundAddress;
874         disputes[disputeLength].investorAddress = msg.sender;
875         disputes[disputeLength].timestamp = now;
876         disputes[disputeLength].reason = _reason;
877         disputes[disputeLength].pending = true;
878 
879         cycle.disputeOpened(msg.sender);
880         disputeLength +=1;
881     }
882 
883     // INTERNAL
884     function executeVerdict(uint _disputeId, bool _verdictForInvestor) internal {
885         disputes[_disputeId].pending = false;
886         uint milestoneDispute = disputes[_disputeId].milestone;
887         AgileCycle cycle = AgileCycle(disputes[_disputeId].icoRoundAddress);
888         cycle.verdictExecuted(disputes[_disputeId].investorAddress,_verdictForInvestor,milestoneDispute);
889         //counter +=1;
890     }
891 
892     function isPending(uint _disputedId) public view returns(bool) {
893         return disputes[_disputedId].pending;
894     }
895 
896 }
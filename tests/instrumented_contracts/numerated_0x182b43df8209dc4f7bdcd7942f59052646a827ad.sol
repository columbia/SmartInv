1 // Human token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  *   @title SafeMath
8  *   @dev Math operations with safety checks that throw on error
9  */
10 
11 library SafeMath {
12 
13     function mul(uint a, uint b) internal constant returns (uint) {
14         if (a == 0) {
15             return 0;
16         }
17         uint c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint a, uint b) internal constant returns(uint) {
23         assert(b > 0);
24         uint c = a / b;
25         assert(a == b * c + a % b);
26         return c;
27     }
28 
29     function sub(uint a, uint b) internal constant returns(uint) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint a, uint b) internal constant returns(uint) {
35         uint c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 /**
42  *   @title ERC20
43  *   @dev Standart ERC20 token interface
44  */
45 
46 contract ERC20 {
47     uint public totalSupply = 0;
48 
49     mapping(address => uint) balances;
50     mapping(address => mapping (address => uint)) allowed;
51 
52     function balanceOf(address _owner) constant returns (uint);
53     function transfer(address _to, uint _value) returns (bool);
54     function transferFrom(address _from, address _to, uint _value) returns (bool);
55     function approve(address _spender, uint _value) returns (bool);
56     function allowance(address _owner, address _spender) constant returns (uint);
57 
58     event Transfer(address indexed _from, address indexed _to, uint _value);
59     event Approval(address indexed _owner, address indexed _spender, uint _value);
60 
61 }
62 
63  /**
64  *   @title HumanTokenAllocator contract  -  issues Human tokens
65  */
66 contract HumanTokenAllocator {
67     using SafeMath for uint;
68     HumanToken public Human;
69     uint public rateEth = 700; // Rate USD per ETH
70     uint public tokenPerUsdNumerator = 1;
71     uint public tokenPerUsdDenominator = 1;
72     uint public firstStageRaised;
73     uint public secondStageRaised;
74     uint public firstStageCap = 7*10**24;
75     uint public secondStageCap = 32*10**24;
76     uint public FIFTY_THOUSANDS_LIMIT = 5*10**22;
77     uint teamPart = 7*10**24;
78 
79     bool public publicAllocationEnabled;
80 
81     address public teamFund;
82     address public owner;
83     address public oracle; // Oracle address
84     address public company;
85 
86     event LogBuyForInvestor(address investor, uint humanValue, string txHash);
87     event ControllerAdded(address _controller);
88     event ControllerRemoved(address _controller);
89     event FirstStageStarted(uint _timestamp);
90     event SecondStageStarted(uint _timestamp);
91     event AllocationFinished(uint _timestamp);
92     event PublicAllocationEnabled(uint _timestamp);
93     event PublicAllocationDisabled(uint _timestamp);
94 
95     mapping(address => bool) public isController;
96 
97     // Allows execution by the owner only     
98     modifier onlyOwner {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     // Allows execution by the oracle only
104     modifier onlyOracle { 
105         require(msg.sender == oracle);
106         _; 
107     }
108 
109     // Allows execution by the controllers only
110     modifier onlyControllers { 
111         require(isController[msg.sender]);
112         _; 
113     }
114 
115     // Possible statuses
116     enum Status {
117         Created,
118         firstStage,
119         secondStage,
120         Finished
121     }
122 
123     Status public status = Status.Created;
124 
125    /**
126     *   @dev Contract constructor function sets outside addresses
127     */
128     function HumanTokenAllocator(
129         address _owner,
130         address _oracle,
131         address _company,
132         address _teamFund,
133         address _eventManager
134     ) public {
135         owner = _owner;
136         oracle = _oracle;
137         company = _company;
138         teamFund = _teamFund;
139         Human = new HumanToken(address(this), _eventManager);
140     }   
141 
142    /**
143     *   @dev Fallback function calls buy(address _holder, uint _humanValue) function to issue tokens
144     */
145     function() external payable {
146         require(publicAllocationEnabled);
147         uint humanValue = msg.value.mul(rateEth).mul(tokenPerUsdNumerator).div(tokenPerUsdDenominator);
148         if (status == Status.secondStage) {
149             require(humanValue >= FIFTY_THOUSANDS_LIMIT);
150         } 
151         buy(msg.sender, humanValue);
152     }
153 
154    /**
155     *   @dev Function to set rate of ETH
156     *   @param _rateEth       current ETH rate
157     */
158     function setRate(uint _rateEth) external onlyOracle {
159         rateEth = _rateEth;
160     }
161 
162    /**
163     *   @dev Function to set current token price
164     *   @param _numerator       human token per usd numerator
165     *   @param _denominator     human token per usd denominator
166     */
167     function setPrice(uint _numerator, uint _denominator) external onlyOracle {
168         tokenPerUsdNumerator = _numerator;
169         tokenPerUsdDenominator = _denominator;
170     }
171     
172 
173    /**
174     *   @dev Function to issues tokens for investors who made purchases in other cryptocurrencies
175     *   @param _holder        address the tokens will be issued to
176     *   @param _humanValue    number of Human tokens
177     *   @param _txHash        transaction hash of investor's payment
178     */
179 
180     function buyForInvestor(
181         address _holder, 
182         uint _humanValue, 
183         string _txHash
184     ) 
185         external 
186         onlyControllers {
187         buy(_holder, _humanValue);
188         LogBuyForInvestor(_holder, _humanValue, _txHash);
189     }
190 
191    /**
192     *   @dev Function to issue tokens for investors who paid in ether
193     *   @param _holder         address which the tokens will be issued tokens
194     *   @param _humanValue     number of Human tokens
195     */
196     function buy(address _holder, uint _humanValue) internal {
197         require(status == Status.firstStage || status == Status.secondStage);
198         if (status == Status.firstStage) {
199             require(firstStageRaised + _humanValue <= firstStageCap);
200             firstStageRaised = firstStageRaised.add(_humanValue);
201         } else {
202             require(secondStageRaised + _humanValue <= secondStageCap);
203             secondStageRaised = secondStageRaised.add(_humanValue);            
204         }
205         Human.mintTokens(_holder, _humanValue);
206     }
207 
208 
209   /**
210    * @dev Function to add an address to the controllers
211    * @param _controller         an address that will be added to managers list
212    */
213     function addController(address _controller) onlyOwner external {
214         require(!isController[_controller]);
215         isController[_controller] = true;
216         ControllerAdded(_controller);
217     }
218 
219   /**
220    * @dev Function to remove an address to the controllers
221    * @param _controller         an address that will be removed from managers list
222    */
223     function removeController(address _controller) onlyOwner external {
224         require(isController[_controller]);
225         isController[_controller] = false;
226         ControllerRemoved(_controller);
227     }
228 
229  /**
230    * @dev Function to start the first stage of human token allocation
231    *      and to issue human token for team fund
232    */
233     function startFirstStage() public onlyOwner {
234         require(status == Status.Created);
235         Human.mintTokens(teamFund, teamPart);
236         status = Status.firstStage;
237         FirstStageStarted(now);
238     }
239 
240   /**  
241    * @dev Function to start the second stage of human token allocation
242    */
243     function startSecondStage() public onlyOwner {
244         require(status == Status.firstStage);
245         status = Status.secondStage;
246         SecondStageStarted(now);
247     }
248 
249   /**  
250    * @dev Function to finish human token allocation and to finish token issue
251    */
252     function finish() public onlyOwner {
253         require (status == Status.secondStage);
254         status = Status.Finished;
255         AllocationFinished(now);
256     }
257 
258   /**  
259    * @dev Function to enable public token allocation
260    */
261     function enable() public onlyOwner {
262         publicAllocationEnabled = true;
263         PublicAllocationEnabled(now);
264     }
265 
266   /**  
267    * @dev Function to disable public token allocation
268    */
269     function disable() public onlyOwner {
270         publicAllocationEnabled = false;
271         PublicAllocationDisabled(now);
272     }
273 
274   /**  
275    * @dev Function to withdraw ether
276    */    
277     function withdraw() external onlyOwner {
278         company.transfer(address(this).balance);
279     }
280 
281     /** 
282     *   @dev Allows owner to transfer out any accidentally sent ERC20 tokens
283     *   @param tokenAddress  token address
284     *   @param tokens        transfer amount
285     */
286     function transferAnyTokens(address tokenAddress, uint tokens) 
287         public
288         onlyOwner
289         returns (bool success) {
290         return ERC20(tokenAddress).transfer(owner, tokens);
291     }      
292 }
293 
294 /**
295  *   @title HumanToken
296  *   @dev Human token smart-contract
297  */
298 contract HumanToken is ERC20 {
299     using SafeMath for uint;
300     string public name = "Human";
301     string public symbol = "Human";
302     uint public decimals = 18;
303     uint public voteCost = 10**18;
304 
305     // Owner address
306     address public owner;
307     address public eventManager;
308 
309     mapping (address => bool) isActiveEvent;
310             
311     //events        
312     event EventAdded(address _event);
313     event Contribute(address _event, address _contributor, uint _amount);
314     event Vote(address _event, address _contributor, bool _proposal);
315     
316     // Allows execution by the contract owner only
317     modifier onlyOwner {
318         require(msg.sender == owner);
319         _;
320     }
321 
322     // Allows execution by the event manager only
323     modifier onlyEventManager {
324         require(msg.sender == eventManager);
325         _;
326     }
327 
328    // Allows contributing and voting only to human events 
329     modifier onlyActive(address _event) {
330         require(isActiveEvent[_event]);
331         _;
332     }
333 
334 
335    /**
336     *   @dev Contract constructor function sets owner address
337     *   @param _owner        owner address
338     */
339     function HumanToken(address _owner, address _eventManager) public {
340        owner = _owner;
341        eventManager = _eventManager;
342     }
343 
344 
345    /**
346     *   @dev Function to add a new event from TheHuman team
347     *   @param _event       a new event address
348     */   
349     function  addEvent(address _event) external onlyEventManager {
350         require (!isActiveEvent[_event]);
351         isActiveEvent[_event] = true;
352         EventAdded(_event);
353     }
354 
355    /**
356     *   @dev Function to change vote cost, by default vote cost equals 1 Human token
357     *   @param _voteCost     a new vote cost
358     */
359     function setVoteCost(uint _voteCost) external onlyEventManager {
360         voteCost = _voteCost;
361     }
362     
363    /**
364     *   @dev Function to donate for event
365     *   @param _event     address of event
366     *   @param _amount    donation amount    
367     */
368     function donate(address _event, uint _amount) public onlyActive(_event) {
369         require (transfer(_event, _amount));
370         require (HumanEvent(_event).contribute(msg.sender, _amount));
371         Contribute(_event, msg.sender, _amount);
372         
373     }
374 
375    /**
376     *   @dev Function voting for the success of the event
377     *   @param _event     address of event
378     *   @param _proposal  true - event completed successfully, false - otherwise
379     */
380     function vote(address _event, bool _proposal) public onlyActive(_event) {
381         require(transfer(_event, voteCost));
382         require(HumanEvent(_event).vote(msg.sender, _proposal));
383         Vote(_event, msg.sender, _proposal);
384     }
385     
386     
387 
388 
389    /**
390     *   @dev Function to mint tokens
391     *   @param _holder       beneficiary address the tokens will be issued to
392     *   @param _value        number of tokens to issue
393     */
394     function mintTokens(address _holder, uint _value) external onlyOwner {
395        require(_value > 0);
396        balances[_holder] = balances[_holder].add(_value);
397        totalSupply = totalSupply.add(_value);
398        Transfer(0x0, _holder, _value);
399     }
400 
401   
402    /**
403     *   @dev Get balance of tokens holder
404     *   @param _holder        holder's address
405     *   @return               balance of investor
406     */
407     function balanceOf(address _holder) constant returns (uint) {
408          return balances[_holder];
409     }
410 
411    /**
412     *   @dev Send coins
413     *   throws on any error rather then return a false flag to minimize
414     *   user errors
415     *   @param _to           target address
416     *   @param _amount       transfer amount
417     *
418     *   @return true if the transfer was successful
419     */
420     function transfer(address _to, uint _amount) public returns (bool) {
421         balances[msg.sender] = balances[msg.sender].sub(_amount);
422         balances[_to] = balances[_to].add(_amount);
423         Transfer(msg.sender, _to, _amount);
424         return true;
425     }
426 
427    /**
428     *   @dev An account/contract attempts to get the coins
429     *   throws on any error rather then return a false flag to minimize user errors
430     *
431     *   @param _from         source address
432     *   @param _to           target address
433     *   @param _amount       transfer amount
434     *
435     *   @return true if the transfer was successful
436     */
437     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
438         balances[_from] = balances[_from].sub(_amount);
439         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
440         balances[_to] = balances[_to].add(_amount);
441         Transfer(_from, _to, _amount);
442         return true;
443     }
444 
445 
446    /**
447     *   @dev Allows another account/contract to spend some tokens on its behalf
448     *   throws on any error rather then return a false flag to minimize user errors
449     *
450     *   also, to minimize the risk of the approve/transferFrom attack vector
451     *   approve has to be called twice in 2 separate transactions - once to
452     *   change the allowance to 0 and secondly to change it to the new allowance
453     *   value
454     *
455     *   @param _spender      approved address
456     *   @param _amount       allowance amount
457     *
458     *   @return true if the approval was successful
459     */
460     function approve(address _spender, uint _amount) public returns (bool) {
461         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
462         allowed[msg.sender][_spender] = _amount;
463         Approval(msg.sender, _spender, _amount);
464         return true;
465     }
466 
467    /**
468     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
469     *
470     *   @param _owner        the address which owns the funds
471     *   @param _spender      the address which will spend the funds
472     *
473     *   @return              the amount of tokens still avaible for the spender
474     */
475     function allowance(address _owner, address _spender) constant returns (uint) {
476         return allowed[_owner][_spender];
477     }
478 
479     /** 
480     *   @dev Allows owner to transfer out any accidentally sent ERC20 tokens
481     *   @param tokenAddress  token address
482     *   @param tokens        transfer amount
483     */
484     function transferAnyTokens(address tokenAddress, uint tokens) 
485         public
486         onlyOwner 
487         returns (bool success) {
488         return ERC20(tokenAddress).transfer(owner, tokens);
489     }
490 }
491 
492  contract HumanEvent {
493     using SafeMath for uint;    
494     uint public totalRaised;
495     uint public softCap;
496     uint public positiveVotes;
497     uint public negativeVotes;
498 
499     address public alternative;
500     address public owner;
501     HumanToken public human;
502 
503     mapping (address => uint) public contributions;
504     mapping (address => bool) public voted;
505     mapping (address => bool) public claimed;
506     
507 
508 
509     // Allows execution by the contract owner only
510     modifier onlyOwner {
511         require(msg.sender == owner);
512         _;
513     }
514 
515     // Allows execution by the contract owner only
516     modifier onlyHuman {
517         require(msg.sender == address(human));
518         _;
519     }
520 
521 
522     // Possible Event statuses
523     enum StatusEvent {
524         Created,
525         Fundraising,
526         Failed,
527         Evaluating,
528         Voting,
529         Finished
530     }
531     StatusEvent public statusEvent = StatusEvent.Created;
532 
533     
534     function HumanEvent(
535         address _owner, 
536         uint _softCap,
537         address _alternative,
538         address _human
539     ) public {
540         owner = _owner;
541         softCap = _softCap;
542         alternative = _alternative;
543         human = HumanToken(_human);
544     }
545 
546     function startFundraising() public onlyOwner {
547         require(statusEvent == StatusEvent.Created);
548         statusEvent = StatusEvent.Fundraising;
549         
550     }
551     
552 
553     function startEvaluating() public onlyOwner {
554         require(statusEvent == StatusEvent.Fundraising);
555         
556         if (totalRaised >= softCap) {
557             statusEvent = StatusEvent.Evaluating;
558         } else {
559             statusEvent = StatusEvent.Failed;
560         }
561     }
562 
563     function startVoting() public onlyOwner {
564         require(statusEvent == StatusEvent.Evaluating);
565         statusEvent = StatusEvent.Voting;
566     }
567 
568     function finish() public onlyOwner {
569         require(statusEvent == StatusEvent.Voting);
570         if (positiveVotes >= negativeVotes) {
571             statusEvent = StatusEvent.Finished;
572         } else {
573             statusEvent = StatusEvent.Failed;
574         }
575     }
576     
577     
578     function claim() public {
579         require(!claimed[msg.sender]);        
580         claimed[msg.sender] = true;
581         uint contribution;
582 
583         if (statusEvent == StatusEvent.Failed) {
584             contribution = contribution.add(contributions[msg.sender]);
585             contributions[msg.sender] = 0;
586         }
587 
588         if(voted[msg.sender] && statusEvent != StatusEvent.Voting) {
589             uint _voteCost = human.voteCost();
590             contribution = contribution.add(_voteCost);
591         }
592         require(contribution > 0);
593         require(human.transfer(msg.sender, contribution));
594     }
595 
596     
597     function vote(address _voter, bool _proposal) external onlyHuman returns (bool) {
598         require(!voted[_voter] && statusEvent == StatusEvent.Voting);
599         voted[_voter] = true;
600         
601         if (_proposal) {
602             positiveVotes++;
603         } else {
604             negativeVotes++;
605         }
606         return true;
607     }
608 
609 
610     function contribute(address _contributor, uint _amount) external onlyHuman returns(bool) {
611         require (statusEvent == StatusEvent.Fundraising);
612         contributions[_contributor] =  contributions[_contributor].add(_amount);
613         totalRaised = totalRaised.add(_amount);
614         return true;
615     }
616     
617     function  withdraw() external onlyOwner {
618         require (statusEvent == StatusEvent.Finished);
619         require (human.transfer(alternative, totalRaised));
620     }
621 
622 }
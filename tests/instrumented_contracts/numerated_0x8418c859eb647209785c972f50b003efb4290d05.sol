1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "./BCSCrowdsale.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "../token/ITokenPool.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "./ERC20StandardToken.sol" : start
18  *************************************************************************/
19 
20 /*************************************************************************
21  * import "./IERC20Token.sol" : start
22  *************************************************************************/
23 
24 contract IERC20Token {
25 
26     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
27     function name() public constant returns (string _name) { _name; }
28     function symbol() public constant returns (string _symbol) { _symbol; }
29     function decimals() public constant returns (uint8 _decimals) { _decimals; }
30     
31     function totalSupply() public constant returns (uint total) {total;}
32     function balanceOf(address _owner) public constant returns (uint balance) {_owner; balance;}    
33     function allowance(address _owner, address _spender) public constant returns (uint remaining) {_owner; _spender; remaining;}
34 
35     function transfer(address _to, uint _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
37     function approve(address _spender, uint _value) public returns (bool success);
38     
39 
40     event Transfer(address indexed _from, address indexed _to, uint _value);
41     event Approval(address indexed _owner, address indexed _spender, uint _value);
42 }
43 /*************************************************************************
44  * import "./IERC20Token.sol" : end
45  *************************************************************************/
46 /*************************************************************************
47  * import "../common/SafeMath.sol" : start
48  *************************************************************************/
49 
50 /**dev Utility methods for overflow-proof arithmetic operations 
51 */
52 contract SafeMath {
53 
54     /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
55     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {        
56         assert(a+b >= a);
57         return a+b;
58     }
59 
60     /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
61     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
62         assert(a >= b);
63         return a - b;
64     }
65 
66     /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
67     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
68         uint256 z = x * y;
69         assert((x == 0) || (z / x == y));
70         return z;
71     }
72 
73     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
74         assert(y != 0);
75         return x / y;
76     }
77 }/*************************************************************************
78  * import "../common/SafeMath.sol" : end
79  *************************************************************************/
80 
81 /**@dev Standard ERC20 compliant token implementation */
82 contract ERC20StandardToken is IERC20Token, SafeMath {
83     string public name;
84     string public symbol;
85     uint8 public decimals;
86 
87     //tokens already issued
88     uint256 tokensIssued;
89     //balances for each account
90     mapping (address => uint256) balances;
91     //one account approves the transfer of an amount to another account
92     mapping (address => mapping (address => uint256)) allowed;
93 
94     function ERC20StandardToken() public {
95      
96     }    
97 
98     //
99     //IERC20Token implementation
100     // 
101 
102     function totalSupply() public constant returns (uint total) {
103         total = tokensIssued;
104     }
105  
106     function balanceOf(address _owner) public constant returns (uint balance) {
107         balance = balances[_owner];
108     }
109 
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112 
113         // safeSub inside doTransfer will throw if there is not enough balance.
114         doTransfer(msg.sender, _to, _value);        
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         
122         // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met
123         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        
124         // safeSub inside doTransfer will throw if there is not enough balance.
125         doTransfer(_from, _to, _value);        
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve(address _spender, uint256 _value) public returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
137         remaining = allowed[_owner][_spender];
138     }    
139 
140     //
141     // Additional functions
142     //
143     /**@dev Gets real token amount in the smallest token units */
144     function getRealTokenAmount(uint256 tokens) public constant returns (uint256) {
145         return tokens * (uint256(10) ** decimals);
146     }
147 
148     //
149     // Internal functions
150     //    
151     
152     function doTransfer(address _from, address _to, uint256 _value) internal {
153         balances[_from] = safeSub(balances[_from], _value);
154         balances[_to] = safeAdd(balances[_to], _value);
155     }
156 }/*************************************************************************
157  * import "./ERC20StandardToken.sol" : end
158  *************************************************************************/
159 
160 /**@dev Token pool that manages its tokens by designating trustees */
161 contract ITokenPool {    
162 
163     /**@dev Token to be managed */
164     ERC20StandardToken public token;
165 
166     /**@dev Changes trustee state */
167     function setTrustee(address trustee, bool state) public;
168 
169     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
170     /**@dev Returns remaining token amount */
171     function getTokenAmount() public constant returns (uint256 tokens) {tokens;}
172 }/*************************************************************************
173  * import "../token/ITokenPool.sol" : end
174  *************************************************************************/
175 /*************************************************************************
176  * import "../token/ReturnTokenAgent.sol" : start
177  *************************************************************************/
178 
179 /*************************************************************************
180  * import "../common/Manageable.sol" : start
181  *************************************************************************/
182 
183 /*************************************************************************
184  * import "../common/Owned.sol" : start
185  *************************************************************************/
186 
187 /*************************************************************************
188  * import "./IOwned.sol" : start
189  *************************************************************************/
190 
191 /**@dev Simple interface to Owned base class */
192 contract IOwned {
193     function owner() public constant returns (address) {}
194     function transferOwnership(address _newOwner) public;
195 }/*************************************************************************
196  * import "./IOwned.sol" : end
197  *************************************************************************/
198 
199 contract Owned is IOwned {
200     address public owner;        
201 
202     function Owned() public {
203         owner = msg.sender;
204     }
205 
206     // allows execution by the owner only
207     modifier ownerOnly {
208         require(msg.sender == owner);
209         _;
210     }
211 
212     /**@dev allows transferring the contract ownership. */
213     function transferOwnership(address _newOwner) public ownerOnly {
214         require(_newOwner != owner);
215         owner = _newOwner;
216     }
217 }
218 /*************************************************************************
219  * import "../common/Owned.sol" : end
220  *************************************************************************/
221 
222 ///A token that have an owner and a list of managers that can perform some operations
223 ///Owner is always a manager too
224 contract Manageable is Owned {
225 
226     event ManagerSet(address manager, bool state);
227 
228     mapping (address => bool) public managers;
229 
230     function Manageable() public Owned() {
231         managers[owner] = true;
232     }
233 
234     /**@dev Allows execution by managers only */
235     modifier managerOnly {
236         require(managers[msg.sender]);
237         _;
238     }
239 
240     function transferOwnership(address _newOwner) public ownerOnly {
241         super.transferOwnership(_newOwner);
242 
243         managers[_newOwner] = true;
244         managers[msg.sender] = false;
245     }
246 
247     function setManager(address manager, bool state) public ownerOnly {
248         managers[manager] = state;
249         ManagerSet(manager, state);
250     }
251 }/*************************************************************************
252  * import "../common/Manageable.sol" : end
253  *************************************************************************/
254 /*************************************************************************
255  * import "../token/ReturnableToken.sol" : start
256  *************************************************************************/
257 
258 
259 
260 
261 
262 ///Token that when sent to specified contract (returnAgent) invokes additional actions
263 contract ReturnableToken is Manageable, ERC20StandardToken {
264 
265     /**@dev List of return agents */
266     mapping (address => bool) public returnAgents;
267 
268     function ReturnableToken() public {}    
269     
270     /**@dev Sets new return agent */
271     function setReturnAgent(ReturnTokenAgent agent) public managerOnly {
272         returnAgents[address(agent)] = true;
273     }
274 
275     /**@dev Removes return agent from list */
276     function removeReturnAgent(ReturnTokenAgent agent) public managerOnly {
277         returnAgents[address(agent)] = false;
278     }
279 
280     function doTransfer(address _from, address _to, uint256 _value) internal {
281         super.doTransfer(_from, _to, _value);
282         if (returnAgents[_to]) {
283             ReturnTokenAgent(_to).returnToken(_from, _value);                
284         }
285     }
286 }/*************************************************************************
287  * import "../token/ReturnableToken.sol" : end
288  *************************************************************************/
289 
290 ///Returnable tokens receiver
291 contract ReturnTokenAgent is Manageable {
292     //ReturnableToken public returnableToken;
293 
294     /**@dev List of returnable tokens in format token->flag  */
295     mapping (address => bool) public returnableTokens;
296 
297     /**@dev Allows only token to execute method */
298     //modifier returnableTokenOnly {require(msg.sender == address(returnableToken)); _;}
299     modifier returnableTokenOnly {require(returnableTokens[msg.sender]); _;}
300 
301     /**@dev Executes when tokens are transferred to this */
302     function returnToken(address from, uint256 amountReturned)  public;
303 
304     /**@dev Sets token that can call returnToken method */
305     function setReturnableToken(ReturnableToken token) public managerOnly {
306         returnableTokens[address(token)] = true;
307     }
308 
309     /**@dev Removes token that can call returnToken method */
310     function removeReturnableToken(ReturnableToken token) public managerOnly {
311         returnableTokens[address(token)] = false;
312     }
313 }/*************************************************************************
314  * import "../token/ReturnTokenAgent.sol" : end
315  *************************************************************************/
316 
317 
318 /*************************************************************************
319  * import "./IInvestRestrictions.sol" : start
320  *************************************************************************/
321 
322 
323 
324 /** @dev Restrictions on investment */
325 contract IInvestRestrictions is Manageable {
326     /**@dev Returns true if investmet is allowed */
327     function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
328         investor; amount; result; tokensLeft;
329     }
330 
331     /**@dev Called when investment was made */
332     function investHappened(address investor, uint amount) managerOnly {}    
333 }/*************************************************************************
334  * import "./IInvestRestrictions.sol" : end
335  *************************************************************************/
336 /*************************************************************************
337  * import "./ICrowdsaleFormula.sol" : start
338  *************************************************************************/
339 
340 /**@dev Abstraction of crowdsale token calculation function */
341 contract ICrowdsaleFormula {
342 
343     /**@dev Returns amount of tokens that can be bought with given weiAmount */
344     function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {
345         weiAmount; tokens; excess;
346     }
347 
348     /**@dev Returns how many tokens left for sale */
349     function tokensLeft() constant returns(uint256 _left) { _left;}    
350 }/*************************************************************************
351  * import "./ICrowdsaleFormula.sol" : end
352  *************************************************************************/
353 
354 /*************************************************************************
355  * import "../token/TokenHolder.sol" : start
356  *************************************************************************/
357 
358 
359 
360 /*************************************************************************
361  * import "./ITokenHolder.sol" : start
362  *************************************************************************/
363 
364 
365 
366 /*
367     Token Holder interface
368 */
369 contract ITokenHolder {
370     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
371 }
372 /*************************************************************************
373  * import "./ITokenHolder.sol" : end
374  *************************************************************************/
375 
376 /**@dev A convenient way to manage token's of a contract */
377 contract TokenHolder is ITokenHolder, Manageable {
378     
379     function TokenHolder() {
380     }
381 
382     /** @dev Withdraws tokens held by the contract and sends them to a given address */
383     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
384         public
385         managerOnly
386     {
387         assert(_token.transfer(_to, _amount));
388     }
389 }
390 /*************************************************************************
391  * import "../token/TokenHolder.sol" : end
392  *************************************************************************/
393 
394 /**@dev Crowdsale base contract, used for PRE-TGE and TGE stages
395 * Token holder should also be the owner of this contract */
396 contract BCSCrowdsale is ReturnTokenAgent, TokenHolder, ICrowdsaleFormula, SafeMath {
397 
398     enum State {Unknown, BeforeStart, Active, FinishedSuccess, FinishedFailure}
399     
400     ITokenPool public tokenPool;
401     IInvestRestrictions public restrictions; //restrictions on investment
402     address public beneficiary; //address of contract to collect ether
403     uint256 public startTime; //unit timestamp of start time
404     uint256 public endTime; //unix timestamp of end date
405     uint256 public minimumGoalInWei; //TODO or in tokens
406     uint256 public tokensForOneEther; //how many tokens can you buy for 1 ether   
407     uint256 realAmountForOneEther; //how many tokens can you buy for 1 ether * 10**decimals   
408     uint256 bonusPct;   //additional percent of tokens    
409     bool public withdrew; //true if beneficiary already withdrew
410 
411     uint256 public weiCollected;
412     uint256 public tokensSold;
413     uint256 public totalInvestments;
414 
415     bool public failure; //true if some error occurred during crowdsale
416 
417     mapping (address => uint256) public investedFrom; //how many wei specific address invested
418     mapping (address => uint256) public returnedTo; //how many wei returned to specific address if sale fails
419     mapping (address => uint256) public tokensSoldTo; //how many tokens sold to specific addreess
420     mapping (address => uint256) public overpays;     //overpays for send value excesses
421 
422     // A new investment was made
423     event Invested(address investor, uint weiAmount, uint tokenAmount);
424     // Refund was processed for a contributor
425     event Refund(address investor, uint weiAmount);
426     // Overpay refund was processed for a contributor
427     event OverpayRefund(address investor, uint weiAmount);
428 
429     /**@dev Crowdsale constructor, can specify startTime as 0 to start crowdsale immediately 
430     _tokensForOneEther - doesn"t depend on token decimals   */ 
431     function BCSCrowdsale(        
432         ITokenPool _tokenPool,
433         IInvestRestrictions _restrictions,
434         address _beneficiary, 
435         uint256 _startTime, 
436         uint256 _durationInHours, 
437         uint256 _goalInWei,
438         uint256 _tokensForOneEther,
439         uint256 _bonusPct) 
440     {
441         require(_beneficiary != 0x0);
442         require(address(_tokenPool) != 0x0);
443         require(_tokensForOneEther > 0); 
444         
445         tokenPool = _tokenPool;
446         beneficiary = _beneficiary;
447         restrictions = _restrictions;
448         
449         if (_startTime == 0) {
450             startTime = now;
451         } else {
452             startTime = _startTime;
453         }
454 
455         endTime = (_durationInHours * 1 hours) + startTime;
456         
457         tokensForOneEther = _tokensForOneEther;
458         minimumGoalInWei = _goalInWei;
459         bonusPct = _bonusPct;
460 
461         weiCollected = 0;
462         tokensSold = 0;
463         totalInvestments = 0;
464         failure = false;
465         withdrew = false;        
466         realAmountForOneEther = tokenPool.token().getRealTokenAmount(tokensForOneEther);
467     }
468 
469     function() payable {
470         invest();
471     }
472 
473     function invest() payable {
474         require(canInvest(msg.sender, msg.value));
475         
476         uint256 excess;
477         uint256 weiPaid = msg.value;
478         uint256 tokensToBuy;
479         (tokensToBuy, excess) = howManyTokensForEther(weiPaid);
480 
481         require(tokensToBuy <= tokensLeft() && tokensToBuy > 0);
482 
483         if (excess > 0) {
484             overpays[msg.sender] = safeAdd(overpays[msg.sender], excess);
485             weiPaid = safeSub(weiPaid, excess);
486         }
487         
488         investedFrom[msg.sender] = safeAdd(investedFrom[msg.sender], weiPaid);      
489         tokensSoldTo[msg.sender] = safeAdd(tokensSoldTo[msg.sender], tokensToBuy);
490         
491         tokensSold = safeAdd(tokensSold, tokensToBuy);
492         weiCollected = safeAdd(weiCollected, weiPaid);
493 
494         if(address(restrictions) != 0x0) {
495             restrictions.investHappened(msg.sender, msg.value);
496         }
497         
498         require(tokenPool.token().transferFrom(tokenPool, msg.sender, tokensToBuy));
499         ++totalInvestments;
500         Invested(msg.sender, weiPaid, tokensToBuy);
501     }
502 
503     /**@dev ReturnTokenAgent override. Returns ether if crowdsale is failed 
504         and amount of returned tokens is exactly the same as bought */
505     function returnToken(address from, uint256 amountReturned) public returnableTokenOnly {
506         if (msg.sender == address(tokenPool.token()) && getState() == State.FinishedFailure) {
507             //require(getState() == State.FinishedFailure);
508             require(tokensSoldTo[from] == amountReturned);
509 
510             returnedTo[from] = investedFrom[from];
511             investedFrom[from] = 0;
512             from.transfer(returnedTo[from]);
513 
514             Refund(from, returnedTo[from]);
515         }
516     }
517 
518     /**@dev Returns true if it is possible to invest */
519     function canInvest(address investor, uint256 amount) constant returns(bool) {
520         return getState() == State.Active &&
521                     (address(restrictions) == 0x0 || 
522                     restrictions.canInvest(investor, amount, tokensLeft()));
523     }
524 
525     /**@dev ICrowdsaleFormula override */
526     function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {        
527         uint256 bpct = getCurrentBonusPct(weiAmount);
528         uint256 maxTokens = (tokensLeft() * 100) / (100 + bpct);
529 
530         tokens = weiAmount * realAmountForOneEther / 1 ether;
531         if (tokens > maxTokens) {
532             tokens = maxTokens;
533         }
534 
535         excess = weiAmount - tokens * 1 ether / realAmountForOneEther;
536 
537         tokens = (tokens * 100 + tokens * bpct) / 100;
538     }
539 
540     /**@dev Returns current bonus percent [0-100] */
541     function getCurrentBonusPct(uint256 investment) constant returns (uint256) {
542         return bonusPct;
543     }
544     
545     /**@dev Returns how many tokens left for sale */
546     function tokensLeft() constant returns(uint256) {        
547         return tokenPool.getTokenAmount();
548     }
549 
550     /**@dev Returns funds that should be sent to beneficiary */
551     function amountToBeneficiary() constant returns (uint256) {
552         return weiCollected;
553     } 
554 
555     /**@dev Returns crowdsale current state */
556     function getState() constant returns (State) {
557         if (failure) {
558             return State.FinishedFailure;
559         }
560         
561         if (now < startTime) {
562             return State.BeforeStart;
563         } else if ((endTime == 0 || now < endTime) && tokensLeft() > 0) {
564             return State.Active;
565         } else if (weiCollected >= minimumGoalInWei || tokensLeft() <= 0) {
566             return State.FinishedSuccess;
567         } else {
568             return State.FinishedFailure;
569         }
570     }
571 
572     /**@dev Allows investor to withdraw overpay */
573     function withdrawOverpay() {
574         uint amount = overpays[msg.sender];
575         overpays[msg.sender] = 0;        
576 
577         if (amount > 0) {
578             if (msg.sender.send(amount)) {
579                 OverpayRefund(msg.sender, amount);
580             } else {
581                 overpays[msg.sender] = amount; //restore funds in case of failed send
582             }
583         }
584     }
585 
586     /**@dev Transfers all collected funds to beneficiary*/
587     function transferToBeneficiary() {
588         require(getState() == State.FinishedSuccess && !withdrew);
589         
590         withdrew = true;
591         uint256 amount = amountToBeneficiary();
592 
593         beneficiary.transfer(amount);
594         Refund(beneficiary, amount);
595     }
596 
597     /**@dev Makes crowdsale failed/ok, for emergency reasons */
598     function makeFailed(bool state) managerOnly {
599         failure = state;
600     }
601 
602     /**@dev Sets new beneficiary */
603     function changeBeneficiary(address newBeneficiary) managerOnly {
604         beneficiary = newBeneficiary;
605     }
606 } /*************************************************************************
607  * import "./BCSCrowdsale.sol" : end
608  *************************************************************************/
609 
610 /**@dev Addition to token-accepting crowdsale contract. 
611     Allows to set bonus decreasing with time. 
612     For example, if we ant to set bonus taht decreases from +20% to +5% each week -3%,
613     and then stays on +%5, then constructor parameters should be:
614     _bonusPct = 20
615     _maxDecreasePct = 15
616     _decreaseStepPct = 3
617     _stepDurationDays = 7
618 
619     In addition, it allows to set investment steps with different bonus. 
620     For example, if there is following scheme:
621     Default bonus +20%
622     1-5 ETH : +1% bonus, 
623     5-10 ETH : +2% bonus,
624     10-20 ETH : +3% bonus,
625     20+ ETH : +5% bonus, 
626     then constructor parameters should be:
627     _bonusPct = 20
628     _investSteps = [1,5,10,20]
629     _bonusPctSteps = [1,2,3,5]
630     */ 
631 contract BCSAddBonusCrowdsale is BCSCrowdsale {
632     
633     uint256 public decreaseStepPct;
634     uint256 public stepDuration;
635     uint256 public maxDecreasePct;
636     uint256[] public investSteps;
637     uint8[] public bonusPctSteps;
638     
639     function BCSAddBonusCrowdsale(        
640         ITokenPool _tokenPool,
641         IInvestRestrictions _restrictions,
642         address _beneficiary, 
643         uint256 _startTime, 
644         uint256 _durationInHours, 
645         uint256 _goalInWei,
646         uint256 _tokensForOneEther,
647         uint256 _bonusPct,
648         uint256 _maxDecreasePct,        
649         uint256 _decreaseStepPct,
650         uint256 _stepDurationDays,
651         uint256[] _investSteps,
652         uint8[] _bonusPctSteps              
653         ) 
654         BCSCrowdsale(
655             _tokenPool,
656             _restrictions,
657             _beneficiary, 
658             _startTime, 
659             _durationInHours, 
660             _goalInWei,
661             _tokensForOneEther,
662             _bonusPct
663         )
664     {
665         require (_bonusPct >= maxDecreasePct);
666 
667         investSteps = _investSteps;
668         bonusPctSteps = _bonusPctSteps;
669         maxDecreasePct = _maxDecreasePct;
670         decreaseStepPct = _decreaseStepPct;
671         stepDuration = _stepDurationDays * 1 days;
672     }
673 
674     function getCurrentBonusPct(uint256 investment) public constant returns (uint256) {
675         
676         uint256 decreasePct = decreaseStepPct * (now - startTime) / stepDuration;
677         if (decreasePct > maxDecreasePct) {
678             decreasePct = maxDecreasePct;
679         }
680 
681         uint256 first24hAddition = (now - startTime < 1 days ? 1 : 0);
682 
683         for (int256 i = int256(investSteps.length) - 1; i >= 0; --i) {
684             if (investment >= investSteps[uint256(i)]) {
685                 return bonusPct - decreasePct + bonusPctSteps[uint256(i)] + first24hAddition;
686             }
687         }
688                 
689         return bonusPct - decreasePct + first24hAddition;
690     }
691 
692 }
1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.10;
7 
8 /*************************************************************************
9  * import "../token/ITokenPool.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "./ERC20StandardToken.sol" : start
14  *************************************************************************/
15 
16 /*************************************************************************
17  * import "./IERC20Token.sol" : start
18  *************************************************************************/
19 
20 /**@dev ERC20 compliant token interface. 
21 https://theethereum.wiki/w/index.php/ERC20_Token_Standard 
22 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md */
23 contract IERC20Token {
24 
25     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
26     function name() public constant returns (string _name) { _name; }
27     function symbol() public constant returns (string _symbol) { _symbol; }
28     function decimals() public constant returns (uint8 _decimals) { _decimals; }
29     
30     function totalSupply() constant returns (uint total) {total;}
31     function balanceOf(address _owner) constant returns (uint balance) {_owner; balance;}    
32     function allowance(address _owner, address _spender) constant returns (uint remaining) {_owner; _spender; remaining;}
33 
34     function transfer(address _to, uint _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) returns (bool success);
36     function approve(address _spender, uint _value) returns (bool success);
37     
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 }
42 /*************************************************************************
43  * import "./IERC20Token.sol" : end
44  *************************************************************************/
45 /*************************************************************************
46  * import "../common/SafeMath.sol" : start
47  *************************************************************************/
48 
49 /**dev Utility methods for overflow-proof arithmetic operations 
50 */
51 contract SafeMath {
52 
53     /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
54     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {        
55         uint256 c = a + b;
56         assert(c >= a);
57 
58         return c;
59     }
60 
61     /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
62     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
63         assert(a >= b);
64         return a - b;
65     }
66 
67     /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
68     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
69         uint256 z = x * y;
70         assert((x == 0) || (z / x == y));
71         return z;
72     }
73 
74     function safeDiv(uint256 x, uint256 y) internal returns (uint256) {
75         assert(y != 0);
76         return x / y;
77     }
78 }/*************************************************************************
79  * import "../common/SafeMath.sol" : end
80  *************************************************************************/
81 
82 /**@dev Standard ERC20 compliant token implementation */
83 contract ERC20StandardToken is IERC20Token, SafeMath {
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87 
88     //tokens already issued
89     uint256 tokensIssued;
90     //balances for each account
91     mapping (address => uint256) balances;
92     //one account approves the transfer of an amount to another account
93     mapping (address => mapping (address => uint256)) allowed;
94 
95     function ERC20StandardToken() {
96      
97     }    
98 
99     //
100     //IERC20Token implementation
101     // 
102 
103     function totalSupply() constant returns (uint total) {
104         total = tokensIssued;
105     }
106  
107     function balanceOf(address _owner) constant returns (uint balance) {
108         balance = balances[_owner];
109     }
110 
111     function transfer(address _to, uint256 _value) returns (bool) {
112         require(_to != address(0));
113 
114         // safeSub inside doTransfer will throw if there is not enough balance.
115         doTransfer(msg.sender, _to, _value);        
116         Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
121         require(_to != address(0));
122         
123         // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met
124         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        
125         // safeSub inside doTransfer will throw if there is not enough balance.
126         doTransfer(_from, _to, _value);        
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function approve(address _spender, uint256 _value) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138         remaining = allowed[_owner][_spender];
139     }    
140 
141     //
142     // Additional functions
143     //
144     /**@dev Gets real token amount in the smallest token units */
145     function getRealTokenAmount(uint256 tokens) constant returns (uint256) {
146         return tokens * (uint256(10) ** decimals);
147     }
148 
149     //
150     // Internal functions
151     //    
152     
153     function doTransfer(address _from, address _to, uint256 _value) internal {
154         balances[_from] = safeSub(balances[_from], _value);
155         balances[_to] = safeAdd(balances[_to], _value);
156     }
157 }/*************************************************************************
158  * import "./ERC20StandardToken.sol" : end
159  *************************************************************************/
160 
161 /**@dev Token pool that manages its tokens by designating trustees */
162 contract ITokenPool {    
163 
164     /**@dev Token to be managed */
165     ERC20StandardToken public token;
166 
167     /**@dev Changes trustee state */
168     function setTrustee(address trustee, bool state);
169 
170     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
171     /**@dev Returns remaining token amount */
172     function getTokenAmount() constant returns (uint256 tokens) {tokens;}
173 }/*************************************************************************
174  * import "../token/ITokenPool.sol" : end
175  *************************************************************************/
176 /*************************************************************************
177  * import "../token/ReturnTokenAgent.sol" : start
178  *************************************************************************/
179 
180 /*************************************************************************
181  * import "../common/Manageable.sol" : start
182  *************************************************************************/
183 
184 /*************************************************************************
185  * import "../common/Owned.sol" : start
186  *************************************************************************/
187 
188 
189 contract Owned {
190     address public owner;        
191 
192     function Owned() {
193         owner = msg.sender;
194     }
195 
196     // allows execution by the owner only
197     modifier ownerOnly {
198         assert(msg.sender == owner);
199         _;
200     }
201 
202     /**@dev allows transferring the contract ownership. */
203     function transferOwnership(address _newOwner) public ownerOnly {
204         require(_newOwner != owner);
205         owner = _newOwner;
206     }
207 }
208 /*************************************************************************
209  * import "../common/Owned.sol" : end
210  *************************************************************************/
211 
212 ///A token that have an owner and a list of managers that can perform some operations
213 ///Owner is always a manager too
214 contract Manageable is Owned {
215 
216     event ManagerSet(address manager, bool state);
217 
218     mapping (address => bool) public managers;
219 
220     function Manageable() Owned() {
221         managers[owner] = true;
222     }
223 
224     /**@dev Allows execution by managers only */
225     modifier managerOnly {
226         assert(managers[msg.sender]);
227         _;
228     }
229 
230     function transferOwnership(address _newOwner) public ownerOnly {
231         super.transferOwnership(_newOwner);
232 
233         managers[_newOwner] = true;
234         managers[msg.sender] = false;
235     }
236 
237     function setManager(address manager, bool state) ownerOnly {
238         managers[manager] = state;
239         ManagerSet(manager, state);
240     }
241 }/*************************************************************************
242  * import "../common/Manageable.sol" : end
243  *************************************************************************/
244 /*************************************************************************
245  * import "../token/ReturnableToken.sol" : start
246  *************************************************************************/
247 
248 
249 
250 
251 
252 ///Token that when sent to specified contract (returnAgent) invokes additional actions
253 contract ReturnableToken is Manageable, ERC20StandardToken {
254 
255     /**@dev List of return agents */
256     mapping (address => bool) public returnAgents;
257 
258     function ReturnableToken() {}    
259     
260     /**@dev Sets new return agent */
261     function setReturnAgent(ReturnTokenAgent agent) managerOnly {
262         returnAgents[address(agent)] = true;
263     }
264 
265     /**@dev Removes return agent from list */
266     function removeReturnAgent(ReturnTokenAgent agent) managerOnly {
267         returnAgents[address(agent)] = false;
268     }
269 
270     function doTransfer(address _from, address _to, uint256 _value) internal {
271         super.doTransfer(_from, _to, _value);
272         if (returnAgents[_to]) {
273             ReturnTokenAgent(_to).returnToken(_from, _value);                
274         }
275     }
276 }/*************************************************************************
277  * import "../token/ReturnableToken.sol" : end
278  *************************************************************************/
279 
280 ///Returnable tokens receiver
281 contract ReturnTokenAgent is Manageable {
282     //ReturnableToken public returnableToken;
283 
284     /**@dev List of returnable tokens in format token->flag  */
285     mapping (address => bool) public returnableTokens;
286 
287     /**@dev Allows only token to execute method */
288     //modifier returnableTokenOnly {require(msg.sender == address(returnableToken)); _;}
289     modifier returnableTokenOnly {require(returnableTokens[msg.sender]); _;}
290 
291     /**@dev Executes when tokens are transferred to this */
292     function returnToken(address from, uint256 amountReturned);
293 
294     /**@dev Sets token that can call returnToken method */
295     function setReturnableToken(ReturnableToken token) managerOnly {
296         returnableTokens[address(token)] = true;
297     }
298 
299     /**@dev Removes token that can call returnToken method */
300     function removeReturnableToken(ReturnableToken token) managerOnly {
301         returnableTokens[address(token)] = false;
302     }
303 }/*************************************************************************
304  * import "../token/ReturnTokenAgent.sol" : end
305  *************************************************************************/
306 
307 
308 /*************************************************************************
309  * import "./IInvestRestrictions.sol" : start
310  *************************************************************************/
311 
312 
313 
314 /** @dev Restrictions on investment */
315 contract IInvestRestrictions is Manageable {
316     /**@dev Returns true if investmet is allowed */
317     function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
318         investor; amount; result; tokensLeft;
319     }
320 
321     /**@dev Called when investment was made */
322     function investHappened(address investor, uint amount) managerOnly {}    
323 }/*************************************************************************
324  * import "./IInvestRestrictions.sol" : end
325  *************************************************************************/
326 /*************************************************************************
327  * import "./ICrowdsaleFormula.sol" : start
328  *************************************************************************/
329 
330 /**@dev Abstraction of crowdsale token calculation function */
331 contract ICrowdsaleFormula {
332 
333     /**@dev Returns amount of tokens that can be bought with given weiAmount */
334     function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {
335         weiAmount; tokens; excess;
336     }
337 
338     /**@dev Returns how many tokens left for sale */
339     function tokensLeft() constant returns(uint256 _left) { _left;}    
340 }/*************************************************************************
341  * import "./ICrowdsaleFormula.sol" : end
342  *************************************************************************/
343 
344 /**@dev Crowdsale base contract, used for PRE-TGE and TGE stages
345 * Token holder should also be the owner of this contract */
346 contract BCSCrowdsale is ICrowdsaleFormula, Manageable, SafeMath {
347 
348     enum State {Unknown, BeforeStart, Active, FinishedSuccess, FinishedFailure}
349     
350     ITokenPool public tokenPool;
351     IInvestRestrictions public restrictions; //restrictions on investment
352     address public beneficiary; //address of contract to collect ether
353     uint256 public startTime; //unit timestamp of start time
354     uint256 public endTime; //unix timestamp of end date
355     uint256 public minimumGoalInWei; //TODO or in tokens
356     uint256 public tokensForOneEther; //how many tokens can you buy for 1 ether   
357     uint256 realAmountForOneEther; //how many tokens can you buy for 1 ether * 10**decimals   
358     uint256 bonusPct;   //additional percent of tokens    
359     bool public withdrew; //true if beneficiary already withdrew
360 
361     uint256 public weiCollected;
362     uint256 public tokensSold;
363 
364     bool public failure; //true if some error occurred during crowdsale
365 
366     mapping (address => uint256) public investedFrom; //how many wei specific address invested
367     mapping (address => uint256) public tokensSoldTo; //how many tokens sold to specific addreess
368     mapping (address => uint256) public overpays;     //overpays for send value excesses
369 
370     // A new investment was made
371     event Invested(address investor, uint weiAmount, uint tokenAmount);
372     // Refund was processed for a contributor
373     event Refund(address investor, uint weiAmount);
374     // Overpay refund was processed for a contributor
375     event OverpayRefund(address investor, uint weiAmount);
376 
377     /**@dev Crowdsale constructor, can specify startTime as 0 to start crowdsale immediately 
378     _tokensForOneEther - doesn't depend on token decimals   */ 
379     function BCSCrowdsale(        
380         ITokenPool _tokenPool,
381         IInvestRestrictions _restrictions,
382         address _beneficiary, 
383         uint256 _startTime, 
384         uint256 _durationInHours, 
385         uint256 _goalInWei,
386         uint256 _tokensForOneEther,
387         uint256 _bonusPct) 
388     {
389         require(_beneficiary != 0x0);
390         require(address(_tokenPool) != 0x0);
391         require(_durationInHours > 0);
392         require(_tokensForOneEther > 0); 
393         
394         tokenPool = _tokenPool;
395         beneficiary = _beneficiary;
396         restrictions = _restrictions;
397         
398         if (_startTime == 0) {
399             startTime = now;
400         } else {
401             startTime = _startTime;
402         }
403         endTime = (_durationInHours * 1 hours) + startTime;        
404         
405         tokensForOneEther = _tokensForOneEther;
406         minimumGoalInWei = _goalInWei;
407         bonusPct = _bonusPct;
408 
409         weiCollected = 0;
410         tokensSold = 0;
411         failure = false;
412         withdrew = false;
413 
414         realAmountForOneEther = tokenPool.token().getRealTokenAmount(tokensForOneEther);
415     }
416 
417     function() payable {
418         invest();
419     }
420 
421     function invest() payable {
422         require(canInvest(msg.sender, msg.value));
423         
424         uint256 excess;
425         uint256 weiPaid = msg.value;
426         uint256 tokensToBuy;
427         (tokensToBuy, excess) = howManyTokensForEther(weiPaid);
428 
429         require(tokensToBuy <= tokensLeft() && tokensToBuy > 0);
430 
431         if (excess > 0) {
432             overpays[msg.sender] = safeAdd(overpays[msg.sender], excess);
433             weiPaid = safeSub(weiPaid, excess);
434         }
435         
436         investedFrom[msg.sender] = safeAdd(investedFrom[msg.sender], weiPaid);      
437         tokensSoldTo[msg.sender] = safeAdd(tokensSoldTo[msg.sender], tokensToBuy);
438         
439         tokensSold = safeAdd(tokensSold, tokensToBuy);
440         weiCollected = safeAdd(weiCollected, weiPaid);
441 
442         if(address(restrictions) != 0x0) {
443             restrictions.investHappened(msg.sender, msg.value);
444         }
445         
446         require(tokenPool.token().transferFrom(tokenPool, msg.sender, tokensToBuy));
447 
448         Invested(msg.sender, weiPaid, tokensToBuy);
449     }
450 
451     /**@dev Returns true if it is possible to invest */
452     function canInvest(address investor, uint256 amount) constant returns(bool) {
453         return getState() == State.Active &&
454                     (address(restrictions) == 0x0 || 
455                     restrictions.canInvest(investor, amount, tokensLeft()));
456     }
457 
458     /**@dev ICrowdsaleFormula override */
459     function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {        
460         uint256 bpct = getCurrentBonusPct();        
461         uint256 maxTokens = (tokensLeft() * 100) / (100 + bpct);
462 
463         tokens = weiAmount * realAmountForOneEther / 1 ether;
464         if (tokens > maxTokens) {
465             tokens = maxTokens;
466         }
467 
468         excess = weiAmount - tokens * 1 ether / realAmountForOneEther;
469 
470         tokens = (tokens * 100 + tokens * bpct) / 100;
471     }
472 
473     /**@dev Returns current bonus percent [0-100] */
474     function getCurrentBonusPct() constant returns (uint256) {
475         return bonusPct;
476     }
477     
478     /**@dev Returns how many tokens left for sale */
479     function tokensLeft() constant returns(uint256) {        
480         return tokenPool.getTokenAmount();
481     }
482 
483     /**@dev Returns funds that should be sent to beneficiary */
484     function amountToBeneficiary() constant returns (uint256) {
485         return weiCollected;
486     } 
487 
488     /**@dev Returns crowdsale current state */
489     function getState() constant returns (State) {
490         if (failure) {
491             return State.FinishedFailure;
492         }
493         
494         if (now < startTime) {
495             return State.BeforeStart;
496         } else if (now < endTime && tokensLeft() > 0) {
497             return State.Active;
498         } else if (weiCollected >= minimumGoalInWei || tokensLeft() <= 0) {
499             return State.FinishedSuccess;
500         } else {
501             return State.FinishedFailure;
502         }
503     }
504 
505     /**@dev Allows investors to withdraw funds and overpays in case of crowdsale failure */
506     function refund() {
507         require(getState() == State.FinishedFailure);
508 
509         uint amount = investedFrom[msg.sender];        
510 
511         if (amount > 0) {
512             investedFrom[msg.sender] = 0;
513             weiCollected = safeSub(weiCollected, amount);            
514             msg.sender.transfer(amount);
515             
516             Refund(msg.sender, amount);            
517         }
518     }    
519 
520     /**@dev Allows investor to withdraw overpay */
521     function withdrawOverpay() {
522         uint amount = overpays[msg.sender];
523         overpays[msg.sender] = 0;        
524 
525         if (amount > 0) {
526             if (msg.sender.send(amount)) {
527                 OverpayRefund(msg.sender, amount);
528             } else {
529                 overpays[msg.sender] = amount; //restore funds in case of failed send
530             }
531         }
532     }
533 
534     /**@dev Transfers all collected funds to beneficiary*/
535     function transferToBeneficiary() {
536         require(getState() == State.FinishedSuccess && !withdrew);
537         
538         withdrew = true;
539         uint256 amount = amountToBeneficiary();
540 
541         beneficiary.transfer(amount);
542         Refund(beneficiary, amount);
543     }
544 
545     /**@dev Makes crowdsale failed/ok, for emergency reasons */
546     function makeFailed(bool state) managerOnly {
547         failure = state;
548     }
549 
550     /**@dev Sets new beneficiary */
551     function changeBeneficiary(address newBeneficiary) managerOnly {
552         beneficiary = newBeneficiary;
553     }
554 }
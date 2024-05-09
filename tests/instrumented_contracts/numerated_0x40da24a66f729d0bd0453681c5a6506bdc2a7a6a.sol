1 pragma solidity ^0.4.11;
2 
3 library Bonus {
4     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
5 
6     function getBonusFactor(uint256 soldToUser)
7     internal pure returns (uint256 factor)
8     {
9         uint256 tokenSold = soldToUser / pointMultiplier;
10         //compare whole coins
11 
12         //yes, this is spaghetti code, to avoid complex formulas which would need 3 different sections anyways.
13         if (tokenSold >= 100000) {
14             return 100;
15         }
16         //0.5% less per 10000 tokens
17         if (tokenSold >= 90000) {
18             return 95;
19         }
20         if (tokenSold >= 80000) {
21             return 90;
22         }
23         if (tokenSold >= 70000) {
24             return 85;
25         }
26         if (tokenSold >= 60000) {
27             return 80;
28         }
29         if (tokenSold >= 50000) {
30             return 75;
31         }
32         if (tokenSold >= 40000) {
33             return 70;
34         }
35         if (tokenSold >= 30000) {
36             return 65;
37         }
38         if (tokenSold >= 20000) {
39             return 60;
40         }
41         if (tokenSold >= 10000) {
42             return 55;
43         }
44         //switch to 0.5% per 1000 tokens
45         if (tokenSold >= 9000) {
46             return 50;
47         }
48         if (tokenSold >= 8000) {
49             return 45;
50         }
51         if (tokenSold >= 7000) {
52             return 40;
53         }
54         if (tokenSold >= 6000) {
55             return 35;
56         }
57         if (tokenSold >= 5000) {
58             return 30;
59         }
60         if (tokenSold >= 4000) {
61             return 25;
62         }
63         //switch to 0.5% per 500 tokens
64         if (tokenSold >= 3000) {
65             return 20;
66         }
67         if (tokenSold >= 2500) {
68             return 15;
69         }
70         if (tokenSold >= 2000) {
71             return 10;
72         }
73         if (tokenSold >= 1500) {
74             return 5;
75         }
76         //less than 1500 -> 0 volume-dependant bonus
77         return 0;
78     }
79 
80 }
81 library SafeMath {
82     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
83         uint256 c = a * b;
84         assert(a == 0 || c / a == b);
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal constant returns (uint256) {
89         // assert(b > 0); // Solidity automatically throws when dividing by 0
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
96         assert(b <= a);
97         return a - b;
98     }
99 
100     function add(uint256 a, uint256 b) internal constant returns (uint256) {
101         uint256 c = a + b;
102         assert(c >= a);
103         return c;
104     }
105 }
106 contract ERC20Basic {
107     uint256 public totalSupply;
108     function balanceOf(address who) constant returns (uint256);
109     function transfer(address to, uint256 value) returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender) constant returns (uint256);
114     function transferFrom(address from, address to, uint256 value) returns (bool);
115     function approve(address spender, uint256 value) returns (bool);
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) returns (bool) {
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         Transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     /**
136     * @dev Gets the balance of the specified address.
137     * @param _owner The address to query the the balance of.
138     * @return An uint256 representing the amount owned by the passed address.
139     */
140     function balanceOf(address _owner) constant returns (uint256 balance) {
141         return balances[_owner];
142     }
143 
144 }
145 contract StandardToken is ERC20, BasicToken {
146 
147     mapping (address => mapping (address => uint256)) allowed;
148 
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amout of tokens to be transfered
155      */
156     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
157         var _allowance = allowed[_from][msg.sender];
158 
159         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160         // require (_value <= _allowance);
161 
162         balances[_to] = balances[_to].add(_value);
163         balances[_from] = balances[_from].sub(_value);
164         allowed[_from][msg.sender] = _allowance.sub(_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) returns (bool) {
175 
176         // To change the approve amount you first have to reduce the addresses`
177         //  allowance to zero by calling `approve(_spender, 0)` if it is not
178         //  already 0 to mitigate the race condition described here:
179         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181 
182         allowed[msg.sender][_spender] = _value;
183         Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188      * @dev Function to check the amount of tokens that an owner allowed to a spender.
189      * @param _owner address The address which owns the funds.
190      * @param _spender address The address which will spend the funds.
191      * @return A uint256 specifing the amount of tokens still avaible for the spender.
192      */
193     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
194         return allowed[_owner][_spender];
195     }
196 
197 }
198 
199 contract CrwdToken is StandardToken {
200 
201     // data structures
202     enum States {
203         Initial, // deployment time
204         ValuationSet,
205         Ico, // whitelist addresses, accept funds, update balances
206         Underfunded, // ICO time finished and minimal amount not raised
207         Operational, // production phase
208         Paused         // for contract upgrades
209     }
210 
211     mapping(address => uint256) public ethPossibleRefunds;
212 
213     uint256 public soldTokens;
214 
215     string public constant name = "Crwdtoken";
216 
217     string public constant symbol = "CRWD";
218 
219     uint8 public constant decimals = 18;
220 
221     mapping(address => bool) public whitelist;
222 
223     address public teamTimeLock;
224     address public devTimeLock;
225     address public countryTimeLock;
226 
227     address public miscNotLocked;
228 
229     address public stateControl;
230 
231     address public whitelistControl;
232 
233     address public withdrawControl;
234 
235     address public tokenAssignmentControl;
236 
237     States public state;
238 
239     uint256 public weiICOMinimum;
240 
241     uint256 public weiICOMaximum;
242 
243     uint256 public silencePeriod;
244 
245     uint256 public startAcceptingFundsBlock;
246 
247     uint256 public endBlock;
248 
249     uint256 public ETH_CRWDTOKEN; //number of tokens per ETH
250 
251     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
252 
253     uint256 public constant maxTotalSupply = 45000000 * pointMultiplier;
254 
255     uint256 public constant percentForSale = 50;
256 
257     event Mint(address indexed to, uint256 amount);
258     event MintFinished();
259 
260     bool public mintingFinished = false;
261 
262     bool public bonusPhase = false;
263 
264 
265     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
266     function CrwdToken(
267         address _stateControl
268     , address _whitelistControl
269     , address _withdrawControl
270     , address _tokenAssignmentControl
271     , address _notLocked //15%
272     , address _lockedTeam //15%
273     , address _lockedDev //10%
274     , address _lockedCountry //10%
275     ) {
276         stateControl = _stateControl;
277         whitelistControl = _whitelistControl;
278         withdrawControl = _withdrawControl;
279         tokenAssignmentControl = _tokenAssignmentControl;
280         moveToState(States.Initial);
281         weiICOMinimum = 0;
282         //to be overridden
283         weiICOMaximum = 0;
284         endBlock = 0;
285         ETH_CRWDTOKEN = 0;
286         totalSupply = 0;
287         soldTokens = 0;
288         uint releaseTime = now + 9 * 31 days;
289         teamTimeLock = address(new CrwdTimelock(this, _lockedTeam, releaseTime));
290         devTimeLock = address(new CrwdTimelock(this, _lockedDev, releaseTime));
291         countryTimeLock = address(new CrwdTimelock(this, _lockedCountry, releaseTime));
292         miscNotLocked = _notLocked;
293     }
294 
295     event Whitelisted(address addr);
296 
297     event StateTransition(States oldState, States newState);
298 
299     modifier onlyWhitelist() {
300         require(msg.sender == whitelistControl);
301         _;
302     }
303 
304     modifier onlyStateControl() {
305         require(msg.sender == stateControl);
306         _;
307     }
308 
309     modifier onlyTokenAssignmentControl() {
310         require(msg.sender == tokenAssignmentControl);
311         _;
312     }
313 
314     modifier onlyWithdraw() {
315         require(msg.sender == withdrawControl);
316         _;
317     }
318 
319     modifier requireState(States _requiredState) {
320         require(state == _requiredState);
321         _;
322     }
323 
324     /**
325     BEGIN ICO functions
326     */
327 
328     //this is the main funding function, it updates the balances of tokens during the ICO.
329     //no particular incentive schemes have been implemented here
330     //it is only accessible during the "ICO" phase.
331     function() payable
332     requireState(States.Ico)
333     {
334         require(whitelist[msg.sender] == true);
335         require(this.balance <= weiICOMaximum);
336         //note that msg.value is already included in this.balance
337         require(block.number < endBlock);
338         require(block.number >= startAcceptingFundsBlock);
339 
340         uint256 basisTokens = msg.value.mul(ETH_CRWDTOKEN);
341         uint256 soldToTuserWithBonus = addBonus(basisTokens);
342 
343         issueTokensToUser(msg.sender, soldToTuserWithBonus);
344         ethPossibleRefunds[msg.sender] = ethPossibleRefunds[msg.sender].add(msg.value);
345     }
346 
347     function issueTokensToUser(address beneficiary, uint256 amount)
348     internal
349     {
350         balances[beneficiary] = balances[beneficiary].add(amount);
351         soldTokens = soldTokens.add(amount);
352         totalSupply = totalSupply.add(amount.mul(100).div(percentForSale));
353         Mint(beneficiary, amount);
354         Transfer(0x0, beneficiary, amount);
355     }
356 
357     function issuePercentToReserve(address beneficiary, uint256 percentOfSold)
358     internal
359     {
360         uint256 amount = totalSupply.mul(percentOfSold).div(100);
361         balances[beneficiary] = balances[beneficiary].add(amount);
362         Mint(beneficiary, amount);
363         Transfer(0x0, beneficiary, amount);
364     }
365 
366     function addBonus(uint256 basisTokens)
367     public constant
368     returns (uint256 resultingTokens)
369     {
370         //if pre-sale is not active no bonus calculation
371         if (!bonusPhase) return basisTokens;
372         //percentages are integer numbers as per mill (promille) so we can accurately calculate 0.5% = 5. 100% = 1000
373         uint256 perMillBonus = getPhaseBonus();
374         //no bonus if investment amount < 1000 tokens
375         if (basisTokens >= pointMultiplier.mul(1000)) {
376             perMillBonus += Bonus.getBonusFactor(basisTokens);
377         }
378         //100% + bonus % times original amount divided by 100%.
379         return basisTokens.mul(per_mill + perMillBonus).div(per_mill);
380     }
381 
382     uint256 constant per_mill = 1000;
383 
384     function setBonusPhase(bool _isBonusPhase)
385     onlyStateControl
386         //phases are controlled manually through the state control key
387     {
388         bonusPhase = _isBonusPhase;
389     }
390 
391     function getPhaseBonus()
392     internal
393     constant
394     returns (uint256 factor)
395     {
396         if (bonusPhase) {//20%
397             return 200;
398         }
399         return 0;
400     }
401 
402 
403     function moveToState(States _newState)
404     internal
405     {
406         StateTransition(state, _newState);
407         state = _newState;
408     }
409     // ICO contract configuration function
410     // newEthICOMinimum is the minimum amount of funds to raise
411     // newEthICOMaximum is the maximum amount of funds to raise
412     // silencePeriod is a number of blocks to wait after starting the ICO. No funds are accepted during the silence period. It can be set to zero.
413     // newEndBlock is the absolute block number at which the ICO must stop. It must be set after now + silence period.
414     function updateEthICOThresholds(uint256 _newWeiICOMinimum, uint256 _newWeiICOMaximum, uint256 _silencePeriod, uint256 _newEndBlock)
415     onlyStateControl
416     {
417         require(state == States.Initial || state == States.ValuationSet);
418         require(_newWeiICOMaximum > _newWeiICOMinimum);
419         require(block.number + silencePeriod < _newEndBlock);
420         require(block.number < _newEndBlock);
421         weiICOMinimum = _newWeiICOMinimum;
422         weiICOMaximum = _newWeiICOMaximum;
423         silencePeriod = _silencePeriod;
424         endBlock = _newEndBlock;
425         // initial conversion rate of ETH_CRWDTOKEN set now, this is used during the Ico phase.
426         ETH_CRWDTOKEN = maxTotalSupply.mul(percentForSale).div(100).div(weiICOMaximum);
427         // check pointMultiplier
428         moveToState(States.ValuationSet);
429     }
430 
431     function startICO()
432     onlyStateControl
433     requireState(States.ValuationSet)
434     {
435         require(block.number < endBlock);
436         require(block.number + silencePeriod < endBlock);
437         startAcceptingFundsBlock = block.number + silencePeriod;
438         moveToState(States.Ico);
439     }
440 
441     function addPresaleAmount(address beneficiary, uint256 amount)
442     onlyTokenAssignmentControl
443     {
444         require(state == States.ValuationSet || state == States.Ico);
445         issueTokensToUser(beneficiary, amount);
446     }
447 
448 
449     function endICO()
450     onlyStateControl
451     requireState(States.Ico)
452     {
453         if (this.balance < weiICOMinimum) {
454             moveToState(States.Underfunded);
455         }
456         else {
457             burnAndFinish();
458             moveToState(States.Operational);
459         }
460     }
461 
462     function anyoneEndICO()
463     requireState(States.Ico)
464     {
465         require(block.number > endBlock);
466         if (this.balance < weiICOMinimum) {
467             moveToState(States.Underfunded);
468         }
469         else {
470             burnAndFinish();
471             moveToState(States.Operational);
472         }
473     }
474 
475     function burnAndFinish()
476     internal
477     {
478         issuePercentToReserve(teamTimeLock, 15);
479         issuePercentToReserve(devTimeLock, 10);
480         issuePercentToReserve(countryTimeLock, 10);
481         issuePercentToReserve(miscNotLocked, 15);
482 
483         totalSupply = soldTokens
484         .add(balances[teamTimeLock])
485         .add(balances[devTimeLock])
486         .add(balances[countryTimeLock])
487         .add(balances[miscNotLocked]);
488 
489         mintingFinished = true;
490         MintFinished();
491     }
492 
493     function addToWhitelist(address _whitelisted)
494     onlyWhitelist
495         //    requireState(States.Ico)
496     {
497         whitelist[_whitelisted] = true;
498         Whitelisted(_whitelisted);
499     }
500 
501 
502     //emergency pause for the ICO
503     function pause()
504     onlyStateControl
505     requireState(States.Ico)
506     {
507         moveToState(States.Paused);
508     }
509 
510     //in case we want to completely abort
511     function abort()
512     onlyStateControl
513     requireState(States.Paused)
514     {
515         moveToState(States.Underfunded);
516     }
517 
518     //un-pause
519     function resumeICO()
520     onlyStateControl
521     requireState(States.Paused)
522     {
523         moveToState(States.Ico);
524     }
525 
526     //in case of a failed/aborted ICO every investor can get back their money
527     function requestRefund()
528     requireState(States.Underfunded)
529     {
530         require(ethPossibleRefunds[msg.sender] > 0);
531         //there is no need for updateAccount(msg.sender) since the token never became active.
532         uint256 payout = ethPossibleRefunds[msg.sender];
533         //reverse calculate the amount to pay out
534         ethPossibleRefunds[msg.sender] = 0;
535         msg.sender.transfer(payout);
536     }
537 
538     //after the ico has run its course, the withdraw account can drain funds bit-by-bit as needed.
539     function requestPayout(uint _amount)
540     onlyWithdraw //very important!
541     requireState(States.Operational)
542     {
543         msg.sender.transfer(_amount);
544     }
545 
546     //if this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
547     function rescueToken(ERC20Basic _foreignToken, address _to)
548     onlyTokenAssignmentControl
549     requireState(States.Operational)
550     {
551         _foreignToken.transfer(_to, _foreignToken.balanceOf(this));
552     }
553     /**
554     END ICO functions
555     */
556 
557     /**
558     BEGIN ERC20 functions
559     */
560     function transfer(address _to, uint256 _value)
561     requireState(States.Operational)
562     returns (bool success) {
563         return super.transfer(_to, _value);
564     }
565 
566     function transferFrom(address _from, address _to, uint256 _value)
567     requireState(States.Operational)
568     returns (bool success) {
569         return super.transferFrom(_from, _to, _value);
570     }
571 
572     function balanceOf(address _account)
573     constant
574     returns (uint256 balance) {
575         return balances[_account];
576     }
577 
578     /**
579     END ERC20 functions
580     */
581 }
582 contract CrwdTimelock {
583     using SafeMath for uint256;
584 
585     mapping(address => uint256) public balances;
586 
587     uint256 public assignedBalance;
588     // beneficiary of tokens after they are released
589     address public controller;
590 
591     // timestamp when token release is enabled
592     uint public releaseTime;
593 
594     CrwdToken token;
595 
596     function CrwdTimelock(CrwdToken _token, address _controller, uint _releaseTime) {
597         require(_releaseTime > now);
598         token = _token;
599         controller = _controller;
600         releaseTime = _releaseTime;
601     }
602 
603     function assignToBeneficiary(address _beneficiary, uint256 _amount){
604         require(msg.sender == controller);
605         assignedBalance = assignedBalance.sub(balances[_beneficiary]);
606         //todo test that this rolls back correctly!
607         //balanceOf(this) will be 0 until the Operational Phase has been reached, no need for explicit check
608         require(token.balanceOf(this) >= assignedBalance.add(_amount));
609         balances[_beneficiary] = _amount;
610         //balance is set, not added, gives _controller the power to set any balance, even 0
611         assignedBalance = assignedBalance.add(balances[_beneficiary]);
612     }
613 
614     /**
615      * @notice Transfers tokens held by timelock to beneficiary.
616      */
617     function release(address _beneficiary) {
618         require(now >= releaseTime);
619         uint amount = balances[_beneficiary];
620         require(amount > 0);
621         token.transfer(_beneficiary, amount);
622         assignedBalance = assignedBalance.sub(amount);
623         balances[_beneficiary] = 0;
624 
625     }
626 }
1 pragma solidity ^0.4.11;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         // assert(b > 0); // Solidity automatically throws when dividing by 0
11         uint256 c = a / b;
12         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 contract ERC20 is ERC20Basic {
34     function allowance(address owner, address spender) public constant returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 contract BasicToken is ERC20Basic {
40     using SafeMath for uint256;
41 
42     mapping(address => uint256) balances;
43 
44     /**
45     * @dev transfer token for a specified address
46     * @param _to The address to transfer to.
47     * @param _value The amount to be transferred.
48     */
49     function transfer(address _to, uint256 _value) public returns (bool) {
50         require(_to != address(0));
51 
52         // SafeMath.sub will throw if there is not enough balance.
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     /**
60     * @dev Gets the balance of the specified address.
61     * @param _owner The address to query the the balance of.
62     * @return An uint256 representing the amount owned by the passed address.
63     */
64     function balanceOf(address _owner) public constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68 }
69 contract StandardToken is ERC20, BasicToken {
70 
71     mapping (address => mapping (address => uint256)) allowed;
72 
73 
74     /**
75      * @dev Transfer tokens from one address to another
76      * @param _from address The address which you want to send tokens from
77      * @param _to address The address which you want to transfer to
78      * @param _value uint256 the amount of tokens to be transferred
79      */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82 
83         uint256 _allowance = allowed[_from][msg.sender];
84 
85         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86         // require (_value <= _allowance);
87 
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = _allowance.sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97      *
98      * Beware that changing an allowance with this method brings the risk that someone may use both the old
99      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
100      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      * @param _spender The address which will spend the funds.
103      * @param _value The amount of tokens to be spent.
104      */
105     function approve(address _spender, uint256 _value) public returns (bool) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     /**
112      * @dev Function to check the amount of tokens that an owner allowed to a spender.
113      * @param _owner address The address which owns the funds.
114      * @param _spender address The address which will spend the funds.
115      * @return A uint256 specifying the amount of tokens still available for the spender.
116      */
117     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120 
121     /**
122      * approve should be called when allowed[_spender] == 0. To increment
123      * allowed value is better to use this function to avoid 2 calls (and wait until
124      * the first transaction is mined)
125      * From MonolithDAO Token.sol
126      */
127     function increaseApproval (address _spender, uint _addedValue)
128     returns (bool success) {
129         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131         return true;
132     }
133 
134     function decreaseApproval (address _spender, uint _subtractedValue)
135     returns (bool success) {
136         uint oldValue = allowed[msg.sender][_spender];
137         if (_subtractedValue > oldValue) {
138             allowed[msg.sender][_spender] = 0;
139         } else {
140             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141         }
142         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 
146 }
147 library Bonus {
148     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
149 
150     uint16 constant ORIGIN_YEAR = 1970;
151 
152     function getBonusFactor(uint256 basisTokens, uint timestamp)
153     internal pure returns (uint256 factor)
154     {
155         uint256[4][5] memory factors = [[uint256(300), 400, 500, 750],
156         [uint256(200), 300, 400, 600],
157         [uint256(150), 250, 300, 500],
158         [uint256(100), 150, 250, 400],
159         [uint256(0),   100, 150, 300]];
160 
161         uint[4] memory cutofftimes = [toTimestamp(2018, 3, 24),
162         toTimestamp(2018, 4, 5),
163         toTimestamp(2018, 5, 5),
164         toTimestamp(2018, 6, 5)];
165 
166         //compare whole tokens
167         uint256 tokenAmount = basisTokens / pointMultiplier;
168 
169         //set default to the 0% bonus
170         uint256 timeIndex = 4;
171         uint256 amountIndex = 0;
172 
173         // 0.02 NZD per token = 50 tokens per NZD
174         if (tokenAmount >= 500000000) {
175             // >10M NZD
176             amountIndex = 3;
177         } else if (tokenAmount >= 100000000) {
178             // >2M NZD
179             amountIndex = 2;
180         } else if (tokenAmount >= 25000000) {
181             // >500K NZD
182             amountIndex = 1;
183         } else {
184             // <500K NZD
185             //amountIndex = 0;
186         }
187 
188         uint256 maxcutoffindex = cutofftimes.length;
189         for (uint256 i = 0; i < maxcutoffindex; i++) {
190             if (timestamp < cutofftimes[i]) {
191                 timeIndex = i;
192                 break;
193             }
194         }
195 
196         return factors[timeIndex][amountIndex];
197     }
198 
199     // Timestamp functions based on
200     // https://github.com/pipermerriam/ethereum-datetime/blob/master/contracts/DateTime.sol
201     function toTimestamp(uint16 year, uint8 month, uint8 day)
202     internal pure returns (uint timestamp) {
203         uint16 i;
204 
205         // Year
206         timestamp += (year - ORIGIN_YEAR) * 1 years;
207         timestamp += (leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR)) * 1 days;
208 
209         // Month
210         uint8[12] memory monthDayCounts;
211         monthDayCounts[0] = 31;
212         if (isLeapYear(year)) {
213             monthDayCounts[1] = 29;
214         }
215         else {
216             monthDayCounts[1] = 28;
217         }
218         monthDayCounts[2] = 31;
219         monthDayCounts[3] = 30;
220         monthDayCounts[4] = 31;
221         monthDayCounts[5] = 30;
222         monthDayCounts[6] = 31;
223         monthDayCounts[7] = 31;
224         monthDayCounts[8] = 30;
225         monthDayCounts[9] = 31;
226         monthDayCounts[10] = 30;
227         monthDayCounts[11] = 31;
228 
229         for (i = 1; i < month; i++) {
230             timestamp += monthDayCounts[i - 1] * 1 days;
231         }
232 
233         // Day
234         timestamp += (day - 1) * 1 days;
235 
236         // Hour, Minute, and Second are assumed as 0 (we calculate in GMT)
237 
238         return timestamp;
239     }
240 
241     function leapYearsBefore(uint year)
242     internal pure returns (uint) {
243         year -= 1;
244         return year / 4 - year / 100 + year / 400;
245     }
246 
247     function isLeapYear(uint16 year)
248     internal pure returns (bool) {
249         if (year % 4 != 0) {
250             return false;
251         }
252         if (year % 100 != 0) {
253             return true;
254         }
255         if (year % 400 != 0) {
256             return false;
257         }
258         return true;
259     }
260 }
261 
262 contract ClearToken is StandardToken {
263 
264     // data structures
265     enum States {
266         Initial, // deployment time
267         ValuationSet,
268         Ico, // whitelist addresses, accept funds, update balances
269         Underfunded, // ICO time finished and minimal amount not raised
270         Operational, // production phase
271         Paused         // for contract upgrades
272     }
273 
274     mapping(address => uint256) public ethPossibleRefunds;
275 
276     uint256 public soldTokens;
277 
278     string public constant name = "CLEAR Token";
279 
280     string public constant symbol = "CLEAR";
281 
282     uint8 public constant decimals = 18;
283 
284     mapping(address => bool) public whitelist;
285 
286     address public reserves;
287 
288     address public stateControl;
289 
290     address public whitelistControl;
291 
292     address public withdrawControl;
293 
294     address public tokenAssignmentControl;
295 
296     States public state;
297 
298     uint256 public startAcceptingFundsBlock;
299 
300     uint256 public endTimestamp;
301 
302     uint256 public ETH_CLEAR; //number of tokens per ETH
303 
304     uint256 public constant NZD_CLEAR = 50; //fixed rate of 50 CLEAR to 1 NZD
305 
306     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
307 
308     uint256 public constant maxTotalSupply = 102400000000 * pointMultiplier; //102.4B tokens
309 
310     uint256 public constant percentForSale = 50;
311 
312     event Mint(address indexed to, uint256 amount);
313     event MintFinished();
314 
315     bool public mintingFinished = false;
316 
317 
318     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
319     function ClearToken(
320         address _stateControl
321     , address _whitelistControl
322     , address _withdrawControl
323     , address _tokenAssignmentControl
324     , address _reserves
325     ) public
326     {
327         stateControl = _stateControl;
328         whitelistControl = _whitelistControl;
329         withdrawControl = _withdrawControl;
330         tokenAssignmentControl = _tokenAssignmentControl;
331         moveToState(States.Initial);
332         endTimestamp = 0;
333         ETH_CLEAR = 0;
334         totalSupply = maxTotalSupply;
335         soldTokens = 0;
336         reserves = _reserves;
337         balances[reserves] = totalSupply;
338         Mint(reserves, totalSupply);
339         Transfer(0x0, reserves, totalSupply);
340     }
341 
342     event Whitelisted(address addr);
343 
344     event StateTransition(States oldState, States newState);
345 
346     modifier onlyWhitelist() {
347         require(msg.sender == whitelistControl);
348         _;
349     }
350 
351     modifier onlyStateControl() {
352         require(msg.sender == stateControl);
353         _;
354     }
355 
356     modifier onlyTokenAssignmentControl() {
357         require(msg.sender == tokenAssignmentControl);
358         _;
359     }
360 
361     modifier onlyWithdraw() {
362         require(msg.sender == withdrawControl);
363         _;
364     }
365 
366     modifier requireState(States _requiredState) {
367         require(state == _requiredState);
368         _;
369     }
370 
371     /**
372     BEGIN ICO functions
373     */
374 
375     //this is the main funding function, it updates the balances of tokens during the ICO.
376     //no particular incentive schemes have been implemented here
377     //it is only accessible during the "ICO" phase.
378     function() payable
379     public
380     requireState(States.Ico)
381     {
382         require(whitelist[msg.sender] == true);
383 
384         require(block.timestamp < endTimestamp);
385         require(block.number >= startAcceptingFundsBlock);
386 
387         uint256 soldToTuserWithBonus = calcBonus(msg.value);
388 
389         issueTokensToUser(msg.sender, soldToTuserWithBonus);
390         ethPossibleRefunds[msg.sender] = ethPossibleRefunds[msg.sender].add(msg.value);
391     }
392 
393     function issueTokensToUser(address beneficiary, uint256 amount)
394     internal
395     {
396         uint256 soldTokensAfterInvestment = soldTokens.add(amount);
397         require(soldTokensAfterInvestment <= maxTotalSupply.mul(percentForSale).div(100));
398 
399         balances[beneficiary] = balances[beneficiary].add(amount);
400         balances[reserves] = balances[reserves].sub(amount);
401         soldTokens = soldTokensAfterInvestment;
402         Transfer(reserves, beneficiary, amount);
403     }
404 
405     function calcBonus(uint256 weiAmount)
406     constant
407     public
408     returns (uint256 resultingTokens)
409     {
410         uint256 basisTokens = weiAmount.mul(ETH_CLEAR);
411         //percentages are integer numbers as per mill (promille) so we can accurately calculate 0.5% = 5. 100% = 1000
412         uint256 perMillBonus = Bonus.getBonusFactor(basisTokens, now);
413         //100% + bonus % times original amount divided by 100%.
414         return basisTokens.mul(per_mill + perMillBonus).div(per_mill);
415     }
416 
417     uint256 constant per_mill = 1000;
418 
419 
420     function moveToState(States _newState)
421     internal
422     {
423         StateTransition(state, _newState);
424         state = _newState;
425     }
426     // ICO contract configuration function
427     // new_ETH_NZD is the new rate of ETH in NZD (from which to derive tokens per ETH)
428     // newTimestamp is the number of seconds since 1970-01-01 00:00:00 GMT at which the ICO must stop. It must be set in the future.
429     function updateEthICOVariables(uint256 _new_ETH_NZD, uint256 _newEndTimestamp)
430     public
431     onlyStateControl
432     {
433         require(state == States.Initial || state == States.ValuationSet);
434         require(_new_ETH_NZD > 0);
435         require(block.timestamp < _newEndTimestamp);
436         endTimestamp = _newEndTimestamp;
437         // initial conversion rate of ETH_CLEAR set now, this is used during the Ico phase.
438         ETH_CLEAR = _new_ETH_NZD.mul(NZD_CLEAR);
439         // check pointMultiplier
440         moveToState(States.ValuationSet);
441     }
442 
443     function updateETHNZD(uint256 _new_ETH_NZD)
444     public
445     onlyTokenAssignmentControl
446     requireState(States.Ico)
447     {
448         require(_new_ETH_NZD > 0);
449         ETH_CLEAR = _new_ETH_NZD.mul(NZD_CLEAR);
450     }
451 
452     function startICO()
453     public
454     onlyStateControl
455     requireState(States.ValuationSet)
456     {
457         require(block.timestamp < endTimestamp);
458         startAcceptingFundsBlock = block.number;
459         moveToState(States.Ico);
460     }
461 
462     function addPresaleAmount(address beneficiary, uint256 amount)
463     public
464     onlyTokenAssignmentControl
465     {
466         require(state == States.ValuationSet || state == States.Ico);
467         issueTokensToUser(beneficiary, amount);
468     }
469 
470 
471     function endICO()
472     public
473     onlyStateControl
474     requireState(States.Ico)
475     {
476         finishMinting();
477         moveToState(States.Operational);
478     }
479 
480     function anyoneEndICO()
481     public
482     requireState(States.Ico)
483     {
484         require(block.timestamp > endTimestamp);
485         finishMinting();
486         moveToState(States.Operational);
487     }
488 
489     function finishMinting()
490     internal
491     {
492         mintingFinished = true;
493         MintFinished();
494     }
495 
496     function addToWhitelist(address _whitelisted)
497     public
498     onlyWhitelist
499         //    requireState(States.Ico)
500     {
501         whitelist[_whitelisted] = true;
502         Whitelisted(_whitelisted);
503     }
504 
505 
506     //emergency pause for the ICO
507     function pause()
508     public
509     onlyStateControl
510     requireState(States.Ico)
511     {
512         moveToState(States.Paused);
513     }
514 
515     //in case we want to completely abort
516     function abort()
517     public
518     onlyStateControl
519     requireState(States.Paused)
520     {
521         moveToState(States.Underfunded);
522     }
523 
524     //un-pause
525     function resumeICO()
526     public
527     onlyStateControl
528     requireState(States.Paused)
529     {
530         moveToState(States.Ico);
531     }
532 
533     //in case of a failed/aborted ICO every investor can get back their money
534     function requestRefund()
535     public
536     requireState(States.Underfunded)
537     {
538         require(ethPossibleRefunds[msg.sender] > 0);
539         //there is no need for updateAccount(msg.sender) since the token never became active.
540         uint256 payout = ethPossibleRefunds[msg.sender];
541         //reverse calculate the amount to pay out
542         ethPossibleRefunds[msg.sender] = 0;
543         msg.sender.transfer(payout);
544     }
545 
546     //after the ico has run its course, the withdraw account can drain funds bit-by-bit as needed.
547     function requestPayout(uint _amount)
548     public
549     onlyWithdraw //very important!
550     requireState(States.Operational)
551     {
552         msg.sender.transfer(_amount);
553     }
554 
555     //if this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
556     function rescueToken(ERC20Basic _foreignToken, address _to)
557     public
558     onlyTokenAssignmentControl
559     requireState(States.Operational)
560     {
561         _foreignToken.transfer(_to, _foreignToken.balanceOf(this));
562     }
563     /**
564     END ICO functions
565     */
566 
567     /**
568     BEGIN ERC20 functions
569     */
570     function transfer(address _to, uint256 _value)
571     public
572     requireState(States.Operational)
573     returns (bool success) {
574         return super.transfer(_to, _value);
575     }
576 
577     function transferFrom(address _from, address _to, uint256 _value)
578     public
579     requireState(States.Operational)
580     returns (bool success) {
581         return super.transferFrom(_from, _to, _value);
582     }
583 
584     function balanceOf(address _account)
585     public
586     constant
587     returns (uint256 balance) {
588         return balances[_account];
589     }
590 
591     /**
592     END ERC20 functions
593     */
594 }
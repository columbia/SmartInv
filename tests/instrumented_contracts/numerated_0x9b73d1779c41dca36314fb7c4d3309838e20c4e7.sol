1 pragma solidity ^0.4.15;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address) { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Provides support and utilities for contract ownership
16 */
17 contract Owned is IOwned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     /**
24         @dev constructor
25     */
26     function Owned() {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     /**
37         @dev allows transferring the contract ownership
38         the new owner still needs to accept the transfer
39         can only be called by the contract owner
40 
41         @param _newOwner    new contract owner
42     */
43     function transferOwnership(address _newOwner) public ownerOnly {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     /**
49         @dev used by a new owner to accept an ownership transfer
50     */
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = 0x0;
56     }
57 }
58 
59 /*
60     Utilities & Common Modifiers
61 */
62 contract Utils {
63     /**
64         constructor
65     */
66     function Utils() {
67     }
68 
69     // validates an address - currently only checks that it isn't null
70     modifier validAddress(address _address) {
71         require(_address != 0x0);
72         _;
73     }
74 
75     // verifies that the address is different than this contract address
76     modifier notThis(address _address) {
77         require(_address != address(this));
78         _;
79     }
80 
81     // Overflow protected math functions
82 
83     /**
84         @dev returns the sum of _x and _y, asserts if the calculation overflows
85 
86         @param _x   value 1
87         @param _y   value 2
88 
89         @return sum
90     */
91     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
92         uint256 z = _x + _y;
93         assert(z >= _x);
94         return z;
95     }
96 
97     /**
98         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
99 
100         @param _x   minuend
101         @param _y   subtrahend
102 
103         @return difference
104     */
105     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
106         assert(_x >= _y);
107         return _x - _y;
108     }
109 
110     /**
111         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
112 
113         @param _x   factor 1
114         @param _y   factor 2
115 
116         @return product
117     */
118     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
119         uint256 z = _x * _y;
120         assert(_x == 0 || z / _x == _y);
121         return z;
122     }
123 }
124 
125 /*
126     ERC20 Standard Token interface
127 */
128 contract IERC20Token {
129     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
130     function name() public constant returns (string) { name; }
131     function symbol() public constant returns (string) { symbol; }
132     function decimals() public constant returns (uint8) { decimals; }
133     function totalSupply() public constant returns (uint256) { totalSupply; }
134     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
135     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
136 
137     function transfer(address _to, uint256 _value) public returns (bool success);
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
139     function approve(address _spender, uint256 _value) public returns (bool success);
140 }
141 
142 /*
143     Token Holder interface
144 */
145 contract ITokenHolder is IOwned {
146     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
147 }
148 
149 /*
150     We consider every contract to be a 'token holder' since it's currently not possible
151     for a contract to deny receiving tokens.
152 
153     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
154     the owner to send tokens that were sent to the contract by mistake back to their sender.
155 */
156 contract TokenHolder is ITokenHolder, Owned, Utils {
157     /**
158         @dev constructor
159     */
160     function TokenHolder() {
161     }
162 
163     /**
164         @dev withdraws tokens held by the contract and sends them to an account
165         can only be called by the owner
166 
167         @param _token   ERC20 token contract address
168         @param _to      account to receive the new amount
169         @param _amount  amount to withdraw
170     */
171     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
172         public
173         ownerOnly
174         validAddress(_token)
175         validAddress(_to)
176         notThis(_to)
177     {
178         assert(_token.transfer(_to, _amount));
179     }
180 }
181 
182 /**
183     ERC20 Standard Token implementation
184 */
185 contract ERC20Token is IERC20Token, Utils {
186     string public standard = "Token 0.1";
187     string public name = "";
188     string public symbol = "";
189     uint8 public decimals = 0;
190     uint256 public totalSupply = 0;
191     mapping (address => uint256) public balanceOf;
192     mapping (address => mapping (address => uint256)) public allowance;
193 
194     event Transfer(address indexed _from, address indexed _to, uint256 _value);
195     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
196 
197     /**
198         @dev constructor
199 
200         @param _name        token name
201         @param _symbol      token symbol
202         @param _decimals    decimal points, for display purposes
203     */
204     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
205         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
206 
207         name = _name;
208         symbol = _symbol;
209         decimals = _decimals;
210     }
211 
212     /**
213         @dev send coins
214         throws on any error rather then return a false flag to minimize user errors
215 
216         @param _to      target address
217         @param _value   transfer amount
218 
219         @return true if the transfer was successful, false if it wasn't
220     */
221     function transfer(address _to, uint256 _value)
222         public
223         validAddress(_to)
224         returns (bool success)
225     {
226         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
227         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
228         Transfer(msg.sender, _to, _value);
229         return true;
230     }
231 
232     /**
233         @dev an account/contract attempts to get the coins
234         throws on any error rather then return a false flag to minimize user errors
235 
236         @param _from    source address
237         @param _to      target address
238         @param _value   transfer amount
239 
240         @return true if the transfer was successful, false if it wasn't
241     */
242     function transferFrom(address _from, address _to, uint256 _value)
243         public
244         validAddress(_from)
245         validAddress(_to)
246         returns (bool success)
247     {
248         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
249         balanceOf[_from] = safeSub(balanceOf[_from], _value);
250         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
251         Transfer(_from, _to, _value);
252         return true;
253     }
254 
255     /**
256         @dev allow another account/contract to spend some tokens on your behalf
257         throws on any error rather then return a false flag to minimize user errors
258 
259         also, to minimize the risk of the approve/transferFrom attack vector
260         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
261         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
262 
263         @param _spender approved address
264         @param _value   allowance amount
265 
266         @return true if the approval was successful, false if it wasn't
267     */
268     function approve(address _spender, uint256 _value)
269         public
270         validAddress(_spender)
271         returns (bool success)
272     {
273         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
274         require(_value == 0 || allowance[msg.sender][_spender] == 0);
275 
276         allowance[msg.sender][_spender] = _value;
277         Approval(msg.sender, _spender, _value);
278         return true;
279     }
280 }
281 
282 contract ENJToken is ERC20Token, TokenHolder {
283 
284 ///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////
285 
286     uint256 constant public ENJ_UNIT = 10 ** 18;
287     uint256 public totalSupply = 1 * (10**9) * ENJ_UNIT;
288 
289     //  Constants 
290     uint256 constant public maxPresaleSupply = 600 * 10**6 * ENJ_UNIT;           // Total presale supply at max bonus
291     uint256 constant public minCrowdsaleAllocation = 200 * 10**6 * ENJ_UNIT;     // Min amount for crowdsale
292     uint256 constant public incentivisationAllocation = 100 * 10**6 * ENJ_UNIT;  // Incentivisation Allocation
293     uint256 constant public advisorsAllocation = 26 * 10**6 * ENJ_UNIT;          // Advisors Allocation
294     uint256 constant public enjinTeamAllocation = 74 * 10**6 * ENJ_UNIT;         // Enjin Team allocation
295 
296     address public crowdFundAddress;                                             // Address of the crowdfund
297     address public advisorAddress;                                               // Enjin advisor's address
298     address public incentivisationFundAddress;                                   // Address that holds the incentivization funds
299     address public enjinTeamAddress;                                             // Enjin Team address
300 
301     //  Variables
302 
303     uint256 public totalAllocatedToAdvisors = 0;                                 // Counter to keep track of advisor token allocation
304     uint256 public totalAllocatedToTeam = 0;                                     // Counter to keep track of team token allocation
305     uint256 public totalAllocated = 0;                                           // Counter to keep track of overall token allocation
306     uint256 constant public endTime = 1509494340;                                // 10/31/2017 @ 11:59pm (UTC) crowdsale end time (in seconds)
307 
308     bool internal isReleasedToPublic = false;                         // Flag to allow transfer/transferFrom before the end of the crowdfund
309 
310     uint256 internal teamTranchesReleased = 0;                          // Track how many tranches (allocations of 12.5% team tokens) have been released
311     uint256 internal maxTeamTranches = 8;                               // The number of tranches allowed to the team until depleted
312 
313 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////
314 
315     // Enjin Team timelock    
316     modifier safeTimelock() {
317         require(now >= endTime + 6 * 4 weeks);
318         _;
319     }
320 
321     // Advisor Team timelock    
322     modifier advisorTimelock() {
323         require(now >= endTime + 2 * 4 weeks);
324         _;
325     }
326 
327     // Function only accessible by the Crowdfund contract
328     modifier crowdfundOnly() {
329         require(msg.sender == crowdFundAddress);
330         _;
331     }
332 
333     ///////////////////////////////////////// CONSTRUCTOR /////////////////////////////////////////
334 
335     /**
336         @dev constructor
337         @param _crowdFundAddress   Crowdfund address
338         @param _advisorAddress     Advisor address
339     */
340     function ENJToken(address _crowdFundAddress, address _advisorAddress, address _incentivisationFundAddress, address _enjinTeamAddress)
341     ERC20Token("Enjin Coin", "ENJ", 18)
342      {
343         crowdFundAddress = _crowdFundAddress;
344         advisorAddress = _advisorAddress;
345         enjinTeamAddress = _enjinTeamAddress;
346         incentivisationFundAddress = _incentivisationFundAddress;
347         balanceOf[_crowdFundAddress] = minCrowdsaleAllocation + maxPresaleSupply; // Total presale + crowdfund tokens
348         balanceOf[_incentivisationFundAddress] = incentivisationAllocation;       // 10% Allocated for Marketing and Incentivisation
349         totalAllocated += incentivisationAllocation;                              // Add to total Allocated funds
350     }
351 
352 ///////////////////////////////////////// ERC20 OVERRIDE /////////////////////////////////////////
353 
354     /**
355         @dev send coins
356         throws on any error rather then return a false flag to minimize user errors
357         in addition to the standard checks, the function throws if transfers are disabled
358 
359         @param _to      target address
360         @param _value   transfer amount
361 
362         @return true if the transfer was successful, throws if it wasn't
363     */
364     function transfer(address _to, uint256 _value) public returns (bool success) {
365         if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {
366             assert(super.transfer(_to, _value));
367             return true;
368         }
369         revert();        
370     }
371 
372     /**
373         @dev an account/contract attempts to get the coins
374         throws on any error rather then return a false flag to minimize user errors
375         in addition to the standard checks, the function throws if transfers are disabled
376 
377         @param _from    source address
378         @param _to      target address
379         @param _value   transfer amount
380 
381         @return true if the transfer was successful, throws if it wasn't
382     */
383     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
384         if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {        
385             assert(super.transferFrom(_from, _to, _value));
386             return true;
387         }
388         revert();
389     }
390 
391 ///////////////////////////////////////// ALLOCATION FUNCTIONS /////////////////////////////////////////
392 
393     /**
394         @dev Release one single tranche of the Enjin Team Token allocation
395         throws if before timelock (6 months) ends and if not initiated by the owner of the contract
396         returns true if valid
397         Schedule goes as follows:
398         3 months: 12.5% (this tranche can only be released after the initial 6 months has passed)
399         6 months: 12.5%
400         9 months: 12.5%
401         12 months: 12.5%
402         15 months: 12.5%
403         18 months: 12.5%
404         21 months: 12.5%
405         24 months: 12.5%
406         @return true if successful, throws if not
407     */
408     function releaseEnjinTeamTokens() safeTimelock ownerOnly returns(bool success) {
409         require(totalAllocatedToTeam < enjinTeamAllocation);
410 
411         uint256 enjinTeamAlloc = enjinTeamAllocation / 1000;
412         uint256 currentTranche = uint256(now - endTime) / 12 weeks;     // "months" after crowdsale end time (division floored)
413 
414         if(teamTranchesReleased < maxTeamTranches && currentTranche > teamTranchesReleased) {
415             teamTranchesReleased++;
416 
417             uint256 amount = safeMul(enjinTeamAlloc, 125);
418             balanceOf[enjinTeamAddress] = safeAdd(balanceOf[enjinTeamAddress], amount);
419             Transfer(0x0, enjinTeamAddress, amount);
420             totalAllocated = safeAdd(totalAllocated, amount);
421             totalAllocatedToTeam = safeAdd(totalAllocatedToTeam, amount);
422             return true;
423         }
424         revert();
425     }
426 
427     /**
428         @dev release Advisors Token allocation
429         throws if before timelock (2 months) ends or if no initiated by the advisors address
430         or if there is no more allocation to give out
431         returns true if valid
432 
433         @return true if successful, throws if not
434     */
435     function releaseAdvisorTokens() advisorTimelock ownerOnly returns(bool success) {
436         require(totalAllocatedToAdvisors == 0);
437         balanceOf[advisorAddress] = safeAdd(balanceOf[advisorAddress], advisorsAllocation);
438         totalAllocated = safeAdd(totalAllocated, advisorsAllocation);
439         totalAllocatedToAdvisors = advisorsAllocation;
440         Transfer(0x0, advisorAddress, advisorsAllocation);
441         return true;
442     }
443 
444     /**
445         @dev Retrieve unsold tokens from the crowdfund
446         throws if before timelock (6 months from end of Crowdfund) ends and if no initiated by the owner of the contract
447         returns true if valid
448 
449         @return true if successful, throws if not
450     */
451     function retrieveUnsoldTokens() safeTimelock ownerOnly returns(bool success) {
452         uint256 amountOfTokens = balanceOf[crowdFundAddress];
453         balanceOf[crowdFundAddress] = 0;
454         balanceOf[incentivisationFundAddress] = safeAdd(balanceOf[incentivisationFundAddress], amountOfTokens);
455         totalAllocated = safeAdd(totalAllocated, amountOfTokens);
456         Transfer(crowdFundAddress, incentivisationFundAddress, amountOfTokens);
457         return true;
458     }
459 
460     /**
461         @dev Keep track of token allocations
462         can only be called by the crowdfund contract
463     */
464     function addToAllocation(uint256 _amount) crowdfundOnly {
465         totalAllocated = safeAdd(totalAllocated, _amount);
466     }
467 
468     /**
469         @dev Function to allow transfers
470         can only be called by the owner of the contract
471         Transfers will be allowed regardless after the crowdfund end time.
472     */
473     function allowTransfers() ownerOnly {
474         isReleasedToPublic = true;
475     } 
476 
477     /**
478         @dev User transfers are allowed/rejected
479         Transfers are forbidden before the end of the crowdfund
480     */
481     function isTransferAllowed() internal constant returns(bool) {
482         if (now > endTime || isReleasedToPublic == true) {
483             return true;
484         }
485         return false;
486     }
487 }
488 
489 contract ENJCrowdfund is TokenHolder {
490 
491 ///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////
492 
493     uint256 constant public startTime = 1507032000;                // 10/03/2017 @ 12:00pm (UTC) crowdsale start time (in seconds)
494     uint256 constant public endTime = 1509494340;                  // 10/31/2017 @ 11:59pm (UTC) crowdsale end time (in seconds)
495     uint256 constant internal week2Start = startTime + (7 days);   // 10/10/2017 @ 12:00pm (UTC) week 2 price begins
496     uint256 constant internal week3Start = week2Start + (7 days);  // 10/17/2017 @ 12:00pm (UTC) week 3 price begins
497     uint256 constant internal week4Start = week3Start + (7 days);  // 10/25/2017 @ 12:00pm (UTC) week 4 price begins
498 
499     uint256 public totalPresaleTokensYetToAllocate;     // Counter that keeps track of presale tokens yet to allocate
500     address public beneficiary = 0x0;                   // address to receive all ether contributions
501     address public tokenAddress = 0x0;                  // address of the token itself
502 
503     ENJToken token;                                     // ENJ Token interface
504 
505 ///////////////////////////////////////// EVENTS /////////////////////////////////////////
506 
507     event CrowdsaleContribution(address indexed _contributor, uint256 _amount, uint256 _return);
508     event PresaleContribution(address indexed _contributor, uint256 _amountOfTokens);
509 
510 ///////////////////////////////////////// CONSTRUCTOR /////////////////////////////////////////
511 
512     /**
513         @dev constructor
514         @param _totalPresaleTokensYetToAllocate     Total amount of presale tokens sold
515         @param _beneficiary                         Address that will be receiving the ETH contributed
516     */
517     function ENJCrowdfund(uint256 _totalPresaleTokensYetToAllocate, address _beneficiary) 
518     validAddress(_beneficiary) 
519     {
520         totalPresaleTokensYetToAllocate = _totalPresaleTokensYetToAllocate;
521         beneficiary = _beneficiary;
522     }
523 
524 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////
525 
526     // Ensures that the current time is between startTime (inclusive) and endTime (exclusive)
527     modifier between() {
528         assert(now >= startTime && now < endTime);
529         _;
530     }
531 
532     // Ensures the Token address is set
533     modifier tokenIsSet() {
534         require(tokenAddress != 0x0);
535         _;
536     }
537 
538 ///////////////////////////////////////// OWNER FUNCTIONS /////////////////////////////////////////
539 
540     /**
541         @dev Sets the ENJ Token address
542         Can only be called once by the owner
543         @param _tokenAddress    ENJ Token Address
544     */
545     function setToken(address _tokenAddress) validAddress(_tokenAddress) ownerOnly {
546         require(tokenAddress == 0x0);
547         tokenAddress = _tokenAddress;
548         token = ENJToken(_tokenAddress);
549     }
550 
551     /**
552         @dev Sets a new Beneficiary address
553         Can only be called by the owner
554         @param _newBeneficiary    Beneficiary Address
555     */
556     function changeBeneficiary(address _newBeneficiary) validAddress(_newBeneficiary) ownerOnly {
557         beneficiary = _newBeneficiary;
558     }
559 
560     /**
561         @dev Function to send ENJ to presale investors
562         Can only be called while the presale is not over.
563         @param _batchOfAddresses list of addresses
564         @param _amountofENJ matching list of address balances
565     */
566     function deliverPresaleTokens(address[] _batchOfAddresses, uint256[] _amountofENJ) external tokenIsSet ownerOnly returns (bool success) {
567         require(now < startTime);
568         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
569             deliverPresaleTokenToClient(_batchOfAddresses[i], _amountofENJ[i]);            
570         }
571         return true;
572     }
573 
574     /**
575         @dev Logic to transfer presale tokens
576         Can only be called while the there are leftover presale tokens to allocate. Any multiple contribution from 
577         the same address will be aggregated.
578         @param _accountHolder user address
579         @param _amountofENJ balance to send out
580     */
581     function deliverPresaleTokenToClient(address _accountHolder, uint256 _amountofENJ) internal ownerOnly {
582         require(totalPresaleTokensYetToAllocate > 0);
583         token.transfer(_accountHolder, _amountofENJ);
584         token.addToAllocation(_amountofENJ);
585         totalPresaleTokensYetToAllocate = safeSub(totalPresaleTokensYetToAllocate, _amountofENJ);
586         PresaleContribution(_accountHolder, _amountofENJ);
587     }
588 
589 ///////////////////////////////////////// PUBLIC FUNCTIONS /////////////////////////////////////////
590     /**
591         @dev ETH contribution function
592         Can only be called during the crowdsale. Also allows a person to buy tokens for another address
593 
594         @return tokens issued in return
595     */
596     function contributeETH(address _to) public validAddress(_to) between tokenIsSet payable returns (uint256 amount) {
597         return processContribution(_to);
598     }
599 
600     /**
601         @dev handles contribution logic
602         note that the Contribution event is triggered using the sender as the contributor, regardless of the actual contributor
603 
604         @return tokens issued in return
605     */
606     function processContribution(address _to) private returns (uint256 amount) {
607 
608         uint256 tokenAmount = getTotalAmountOfTokens(msg.value);
609         beneficiary.transfer(msg.value);
610         token.transfer(_to, tokenAmount);
611         token.addToAllocation(tokenAmount);
612         CrowdsaleContribution(_to, msg.value, tokenAmount);
613         return tokenAmount;
614     }
615 
616 
617 
618 ///////////////////////////////////////// CONSTANT FUNCTIONS /////////////////////////////////////////
619     
620     /**
621         @dev Returns total tokens allocated so far
622         Constant function that simply returns a number
623 
624         @return total tokens allocated so far
625     */
626     function totalEnjSold() public constant returns(uint256 total) {
627         return token.totalAllocated();
628     }
629     
630     /**
631         @dev computes the number of tokens that should be issued for a given contribution
632         @param _contribution    contribution amount
633         @return computed number of tokens
634     */
635     function getTotalAmountOfTokens(uint256 _contribution) public constant returns (uint256 amountOfTokens) {
636         uint256 currentTokenRate = 0;
637         if (now < week2Start) {
638             return currentTokenRate = safeMul(_contribution, 6000);
639         } else if (now < week3Start) {
640             return currentTokenRate = safeMul(_contribution, 5000);
641         } else if (now < week4Start) {
642             return currentTokenRate = safeMul(_contribution, 4000);
643         } else {
644             return currentTokenRate = safeMul(_contribution, 3000);
645         }
646         
647     }
648 
649     /**
650         @dev Fallback function
651         Main entry to buy into the crowdfund, all you need to do is send a value transaction
652         to this contract address. Please include at least 100 000 gas in the transaction.
653     */
654     function() payable {
655         contributeETH(msg.sender);
656     }
657 }
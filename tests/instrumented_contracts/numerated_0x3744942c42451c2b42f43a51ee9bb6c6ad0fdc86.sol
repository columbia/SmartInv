1 pragma solidity >=0.4.10;
2 
3 /*  ----------------------------------------------------------------------------------------
4 
5     Dev:    "Owned" to ensure control of contracts
6 
7             Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
8 
9     ---------------------------------------------------------------------------------------- */
10 contract Owned {
11     address public owner;
12 
13     function Owned() {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner {
23         owner = newOwner;
24     }
25 }
26 
27 /*  ----------------------------------------------------------------------------------------
28 
29     Dev:    SafeMath library
30 
31             Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
32 
33     ---------------------------------------------------------------------------------------- */
34 library SafeMath {
35   function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a); // Ensuring no negatives
50     return a - b;
51   }
52 
53   function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a && c>=b);
56     return c;
57   }
58 }
59 
60 /*  ----------------------------------------------------------------------------------------
61 
62     Dev:    ESG Asset Holder is called when the token "burn" function is called
63 
64     Sum:    Locked to false so users cannot burn their tokens until the Asset Contract is
65             put in place with value.
66 
67     ---------------------------------------------------------------------------------------- */
68 contract ESGAssetHolder {
69     
70     function burn(address _holder, uint _amount) returns (bool result) {
71 
72         _holder = 0x0;                              // To avoid variable not used issue on deployment
73         _amount = 0;                                // To avoid variable not used issue on deployment
74         return false;
75     }
76 }
77 
78 
79 /*  ----------------------------------------------------------------------------------------
80 
81     Dev:    The Esports Gold Token:  ERC20 standard token with MINT and BURN functions
82 
83     Func:   Mint, Approve, Transfer, TransferFrom  
84 
85     Note:   Mint function takes UNITS of tokens to mint as ICO event is set to have a minimum
86             contribution of 1 token. All other functions (transfer etc), the value to transfer
87             is the FULL DECIMAL value
88             The user is only ever presented with the latter option, therefore should avoid
89             any confusion.
90     ---------------------------------------------------------------------------------------- */
91 contract ESGToken is Owned {
92         
93     string public name = "ESG Token";               // Name of token
94     string public symbol = "ESG";                   // Token symbol
95     uint256 public decimals = 3;                    // Decimals for the token
96     uint256 public currentSupply;                   // Current supply of tokens
97     uint256 public supplyCap;                       // Hard cap on supply of tokens
98     address public ICOcontroller;                   // Controlling contract from ICO
99     address public timelockTokens;                  // Address for locked management tokens
100     bool public tokenParametersSet;                        // Ensure that parameters required are set
101     bool public controllerSet;                             // Ensure that ICO controller is set
102 
103     mapping (address => uint256) public balanceOf;                      // Balances of addresses
104     mapping (address => mapping (address => uint)) public allowance;    // Allowances from addresses
105     mapping (address => bool) public frozenAccount;                     // Safety mechanism
106 
107 
108     modifier onlyControllerOrOwner() {            // Ensures that only contracts can manage key functions
109         require(msg.sender == ICOcontroller || msg.sender == owner);
110         _;
111     }
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115     event Mint(address owner, uint amount);
116     event FrozenFunds(address target, bool frozen);
117     event Burn(address coinholder, uint amount);
118     
119     /*  ----------------------------------------------------------------------------------------
120 
121     Dev:    Constructor
122 
123     param:  Owner:  Address of owner
124             Name:   Esports Gold Token
125             Sym:    ESG_TKN
126             Dec:    3
127             Cap:    Hard coded cap to ensure excess tokens cannot be minted
128 
129     Other parameters have been set up as a separate function to help lower initial gas deployment cost.
130 
131     ---------------------------------------------------------------------------------------- */
132     function ESGToken() {
133         currentSupply = 0;                      // Starting supply is zero
134         supplyCap = 0;                          // Hard cap supply in Tokens set by ICO
135         tokenParametersSet = false;             // Ensure parameters are set
136         controllerSet = false;                  // Ensure controller is set
137     }
138 
139     /*  ----------------------------------------------------------------------------------------
140 
141     Dev:    Key parameters to setup for ICO event
142 
143     Param:  _ico    Address of the ICO Event contract to ensure the ICO event can control
144                     the minting function
145     
146     ---------------------------------------------------------------------------------------- */
147     function setICOController(address _ico) onlyOwner {     // ICO event address is locked in
148         require(_ico != 0x0);
149         ICOcontroller = _ico;
150         controllerSet = true;
151     }
152 
153 
154     /*  ----------------------------------------------------------------------------------------
155     NEW
156     Dev:    Address for the timelock tokens to be held
157 
158     Param:  _timelockAddr   Address of the timelock contract that will hold the locked tokens
159     
160     ---------------------------------------------------------------------------------------- */
161     function setParameters(address _timelockAddr) onlyOwner {
162         require(_timelockAddr != 0x0);
163 
164         timelockTokens = _timelockAddr;
165 
166         tokenParametersSet = true;
167     }
168 
169     function parametersAreSet() constant returns (bool) {
170         return tokenParametersSet && controllerSet;
171     }
172 
173     /*  ----------------------------------------------------------------------------------------
174 
175     Dev:    Set the total number of Tokens that can be minted
176 
177     Param:  _supplyCap  The number of tokens (in whole units) that can be minted. This number then
178                         gets increased by the decimal number
179    
180     ---------------------------------------------------------------------------------------- */
181     function setTokenCapInUnits(uint256 _supplyCap) onlyControllerOrOwner {   // Supply cap in UNITS
182         assert(_supplyCap > 0);
183         
184         supplyCap = SafeMath.safeMul(_supplyCap, (10**decimals));
185     }
186 
187     /*  ----------------------------------------------------------------------------------------
188 
189     Dev:    Mint the number of tokens for the timelock contract
190 
191     Param:  _mMentTkns  Number of tokens in whole units that need to be locked into the Timelock
192     
193     ---------------------------------------------------------------------------------------- */
194     function mintLockedTokens(uint256 _mMentTkns) onlyControllerOrOwner {
195         assert(_mMentTkns > 0);
196         assert(tokenParametersSet);
197 
198         mint(timelockTokens, _mMentTkns);  
199     }
200 
201     /*  ----------------------------------------------------------------------------------------
202 
203     Dev:    Gets the balance of the address owner
204 
205     Param:  _owner  Address of the owner querying their balance
206     
207     ---------------------------------------------------------------------------------------- */
208     function balanceOf(address _owner) constant returns (uint256 balance) {
209         return balanceOf[_owner];
210     }
211 
212     /*  ----------------------------------------------------------------------------------------
213 
214     Dev:    Mint ESG Tokens by controller
215 
216     Control:            OnlyControllers. ICO event needs to be able to control the minting
217                         function
218 
219     Param:  Address     Address for tokens to be minted to
220             Amount      Number of tokens to be minted (in whole UNITS. Min minting is 1 token)
221                         Minimum ETH contribution in ICO event is 0.01ETH at 100 tokens per ETH
222     
223     ---------------------------------------------------------------------------------------- */
224     function mint(address _address, uint _amount) onlyControllerOrOwner {
225         require(_address != 0x0);
226         uint256 amount = SafeMath.safeMul(_amount, (10**decimals));             // Tokens minted using unit parameter supplied
227 
228         // Ensure that supplyCap is set and that new tokens don't breach cap
229         assert(supplyCap > 0 && amount > 0 && SafeMath.safeAdd(currentSupply, amount) <= supplyCap);
230         
231         balanceOf[_address] = SafeMath.safeAdd(balanceOf[_address], amount);    // Add tokens to address
232         currentSupply = SafeMath.safeAdd(currentSupply, amount);                // Add to supply
233         
234         Mint(_address, amount);
235     }
236     
237     /*  ----------------------------------------------------------------------------------------
238 
239     Dev:    ERC20 standard transfer function
240 
241     Param:  _to         Address to send to
242             _value      Number of tokens to be sent - in FULL decimal length
243     
244     Ref:    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BasicToken.sol
245     ---------------------------------------------------------------------------------------- */
246     function transfer(address _to, uint _value) returns (bool success) {
247         require(!frozenAccount[msg.sender]);        // Ensure account is not frozen
248 
249         /* 
250             Update balances from "from" and "to" addresses with the tokens transferred
251             safeSub method ensures that address sender has enough tokens to send
252         */
253         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    
254         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  
255         Transfer(msg.sender, _to, _value);
256         
257         return true;
258     }
259     
260     /*  ----------------------------------------------------------------------------------------
261 
262     Dev:    ERC20 standard transferFrom function
263 
264     Param:  _from       Address to send from
265             _to         Address to send to
266             Amount      Number of tokens to be sent - in FULL decimal length
267 
268     ---------------------------------------------------------------------------------------- */
269     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {   
270         require(!frozenAccount[_from]);                         // Check account is not frozen
271         
272         /* 
273             Ensure sender has been authorised to send the required number of tokens
274         */
275         if (allowance[_from][msg.sender] < _value)
276             return false;
277 
278         /* 
279             Update allowance of sender to reflect tokens sent
280         */
281         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value); 
282 
283         /* 
284             Update balances from "from" and "to" addresses with the tokens transferred
285             safeSub method ensures that address sender has enough tokens to send
286         */
287         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
288         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
289 
290         Transfer(_from, _to, _value);
291         return true;
292     }
293     
294     /*  ----------------------------------------------------------------------------------------
295 
296     Dev:    ERC20 standard approve function
297 
298     Param:  _spender        Address of sender who is approved
299             _value          The number of tokens (full decimals) that are approved
300 
301     ---------------------------------------------------------------------------------------- */
302     function approve(address _spender, uint256 _value)      // FULL DECIMALS OF TOKENS
303         returns (bool success)
304     {
305         require(!frozenAccount[msg.sender]);                // Check account is not frozen
306 
307         /* Requiring the user to set to zero before resetting to nonzero */
308         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {
309            return false;
310         }
311 
312         allowance[msg.sender][_spender] = _value;
313         
314         Approval(msg.sender, _spender, _value);
315         return true;
316     }
317 
318     /*  ----------------------------------------------------------------------------------------
319 
320     Dev:    Function to check the amount of tokens that the owner has allowed the "spender" to
321             transfer
322 
323     Param:  _owner          Address of the authoriser who owns the tokens
324             _spender        Address of sender who will be authorised to spend the tokens
325 
326     ---------------------------------------------------------------------------------------- */
327 
328     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
329         return allowance[_owner][_spender];
330     }
331     
332     /*  ----------------------------------------------------------------------------------------
333 
334     Dev:    As ESG is aiming to be a regulated betting operator. Regulatory hurdles may require
335             this function if an account on the betting platform, using the token, breaches
336             a regulatory requirement.
337 
338             ESG can then engage with the account holder to get it unlocked
339 
340             This does not stop the token accruing value from its share of the Asset Contract
341 
342     Param:  _target         Address of account
343             _freeze         Boolean to lock/unlock account
344 
345     Ref:    This is a replica of the code as per https://ethereum.org/token
346     ---------------------------------------------------------------------------------------- */
347     function freezeAccount(address target, bool freeze) onlyOwner {
348         frozenAccount[target] = freeze;
349         FrozenFunds(target, freeze);
350     }
351 
352     /*  ----------------------------------------------------------------------------------------
353 
354     Dev:    Burn function: User is able to burn their token for a share of the ESG Asset Contract
355 
356     Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot
357             accidentally burn their tokens for zero value
358 
359     Param:  _amount         Number of tokens (full decimals) that should be burnt
360 
361     Ref:    Based on the open source TokenCard Burn function. A copy can be found at
362             https://github.com/bokkypoobah/TokenCardICOAnalysis
363     ---------------------------------------------------------------------------------------- */
364     function burn(uint _amount) returns (bool result) {
365 
366         if (_amount > balanceOf[msg.sender])
367             return false;       // If owner has enough to burn
368 
369         /* 
370             Remove tokens from circulation
371             Update sender's balance of tokens
372         */
373         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _amount);
374         currentSupply = SafeMath.safeSub(currentSupply, _amount);
375 
376         // Call burn function
377         result = esgAssetHolder.burn(msg.sender, _amount);
378         require(result);
379 
380         Burn(msg.sender, _amount);
381     }
382 
383     /*  ----------------------------------------------------------------------------------------
384 
385     Dev:    Section of the contract that links to the ESG Asset Contract
386 
387     Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot
388             accidentally burn their tokens for zero value
389 
390     Param:  _amount         Number of tokens (full decimals) that should be burnt
391 
392     Ref:    Based on the open source TokenCard Burn function. A copy can be found at
393             https://github.com/bokkypoobah/TokenCardICOAnalysis
394     ---------------------------------------------------------------------------------------- */
395 
396     ESGAssetHolder esgAssetHolder;              // Holds the accumulated asset contract
397     bool lockedAssetHolder;                     // Will be locked to stop tokenholder to be upgraded
398 
399     function lockAssetHolder() onlyOwner {      // Locked once deployed
400         lockedAssetHolder = true;
401     }
402 
403     function setAssetHolder(address _assetAdress) onlyOwner {   // Used to lock in the Asset Contract
404         assert(!lockedAssetHolder);             // Check that we haven't locked the asset holder yet
405         esgAssetHolder = ESGAssetHolder(_assetAdress);
406     }    
407 }
408 
409     /*  ----------------------------------------------------------------------------------------
410 
411     Dev:    Vested token option for management - locking in account holders for 2 years
412 
413     Ref:    Identical to OpenZeppelin open source contract except releaseTime is locked in
414             https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/TokenTimelock.sol
415 
416     ---------------------------------------------------------------------------------------- */
417 contract TokenTimelock {
418 
419     // ERC20 basic token contract being held
420     ESGToken token;
421 
422     // beneficiary of tokens after they are released
423     address public beneficiary;
424 
425     // timestamp when token release is enabled
426     uint256 public releaseTime;
427 
428     function TokenTimelock(address _token, address _beneficiary) {
429         require(_token != 0x0);
430         require(_beneficiary != 0x0);
431 
432         token = ESGToken(_token);
433         //token = _token;
434         beneficiary = _beneficiary;
435         releaseTime = now + 2 years;
436     }
437 
438     /* 
439         Show the balance in the timelock for transparency
440         Therefore transparent view of the whitepaper allotted management tokens
441     */
442     function lockedBalance() public constant returns (uint256) {
443         return token.balanceOf(this);
444     }
445 
446     /* 
447         Transfers tokens held by timelock to beneficiary
448     */
449     function release() {
450         require(now >= releaseTime);
451 
452         uint256 amount = token.balanceOf(this);
453         require(amount > 0);
454 
455         token.transfer(beneficiary, amount);
456     }
457 }
458 
459     /*  ----------------------------------------------------------------------------------------
460 
461     Dev:    ICO Controller event
462 
463             ICO Controller manages the ICO event including payable functions that trigger mint,
464             Refund collections, Base target and ICO discount rates for deposits before Base
465             Target
466 
467     Ref:    Modified version of crowdsale contract with refund option (if base target not reached)
468             https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/Crowdsale.sol
469             https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol           
470     ---------------------------------------------------------------------------------------- */
471 contract ICOEvent is Owned {
472 
473     ESGToken public token;                              // ESG TOKEN used for Deposit, Claims, Set Address
474 
475     uint256 public startTime = 0;                       // StartTime default
476     uint256 public endTime;                             // End time is start + duration
477     uint256 duration;                                   // Duration in days for ICO
478     bool parametersSet;                                 // Ensure paramaters are locked in before starting ICO
479     bool supplySet;                                     // Ensure token supply set
480 
481     address holdingAccount = 0x0;                       // Address for successful closing of ICO
482     uint256 public totalTokensMinted;                   // To record total number of tokens minted
483 
484     // For purchasing tokens
485     uint256 public rate_toTarget;                       // Rate of tokens per 1 ETH contributed to the base target
486     uint256 public rate_toCap;                          // Rate of tokens from base target to cap per 1 ETH
487     uint256 public totalWeiContributed = 0;             // Tracks total Ether contributed in WEI
488     uint256 public minWeiContribution = 0.01 ether;     // At 100:1ETH means 1 token = the minimum contribution
489     uint256 constant weiEtherConversion = 10**18;       // To allow inputs for setup in ETH for simplicity
490 
491     // Cap parameters
492     uint256 public baseTargetInWei;                     // Target for bonus rate of tokens
493     uint256 public icoCapInWei;                         // Max cap of the ICO in Wei
494 
495     event logPurchase (address indexed purchaser, uint value, uint256 tokens);
496 
497     enum State { Active, Refunding, Closed }            // Allows control of the ICO state
498     State public state;
499     mapping (address => uint256) public deposited;      // Mapping for address deposit amounts
500     mapping (address => uint256) public tokensIssued;   // Mapping for address token amounts
501 
502     /*  ----------------------------------------------------------------------------------------
503 
504     Dev:    Constructor
505 
506     param:  Parameters are set individually after construction to lower initial deployment gas
507             State:  set default state to active
508 
509     ---------------------------------------------------------------------------------------- */
510     function ICOEvent() {
511         state = State.Active;
512         totalTokensMinted = 0;
513         parametersSet = false;
514         supplySet = false;
515     }
516 
517     /*  ----------------------------------------------------------------------------------------
518 
519     Dev:    This section is to set parameters for the ICO control by the owner
520 
521     Param:  _tokenAddress   Address of the ESG Token contract that has been deployed
522             _target_rate    Number of tokens (in units, excl token decimals) per 1 ETH contribution
523                             up to the ETH base target
524             _cap_rate       Number of tokens (in units, excl token decimals) per 1 ETH contribution
525                             from the base target to the ICO cap
526             _baseTarget     Number of ETH to reach the base target. ETH is refunded if base target
527                             is not reached
528             _cap            Total ICO cap in ETH. No further ETH can be deposited beyond this
529             _holdingAccount Address of the beneficiary account on a successful ICO
530             _duration       Duration of ICO in days
531     ---------------------------------------------------------------------------------------- */ 
532     function ICO_setParameters(address _tokenAddress, uint256 _target_rate, uint256 _cap_rate, uint256 _baseTarget, uint256 _cap, address _holdingAccount, uint256 _duration) onlyOwner {
533         require(_target_rate > 0 && _cap_rate > 0);
534         require(_baseTarget >= 0);
535         require(_cap > 0);
536         require(_duration > 0);
537         require(_holdingAccount != 0x0);
538         require(_tokenAddress != 0x0);
539 
540         rate_toTarget = _target_rate;
541         rate_toCap = _cap_rate;
542         token = ESGToken(_tokenAddress);
543         baseTargetInWei = SafeMath.safeMul(_baseTarget, weiEtherConversion);
544         icoCapInWei = SafeMath.safeMul(_cap, weiEtherConversion);
545         holdingAccount = _holdingAccount;
546         duration = SafeMath.safeMul(_duration, 1 days);
547         parametersSet = true;
548     }
549 
550     /*  ----------------------------------------------------------------------------------------
551 
552     Dev:    Ensure the ICO parameters are set before initialising start of ICO
553 
554     ---------------------------------------------------------------------------------------- */
555     function eventConfigured() internal constant returns (bool) {
556         return parametersSet && supplySet;
557     }
558 
559     /*  ----------------------------------------------------------------------------------------
560 
561     Dev:    Starts the ICO. Initialises starttime at now - current block timestamp
562 
563     ---------------------------------------------------------------------------------------- */ 
564     function ICO_start() onlyOwner {
565         assert (eventConfigured());
566         startTime = now;
567         endTime = SafeMath.safeAdd(startTime, duration);
568     }
569 
570     function ICO_start_future(uint _startTime) onlyOwner {
571         assert(eventConfigured());
572         require(_startTime > now);
573         startTime = _startTime;
574         endTime = SafeMath.safeAdd(startTime, duration);
575     }
576 
577     function ICO_token_supplyCap() onlyOwner {
578         require(token.parametersAreSet());                          // Ensure parameters are set in the token
579 
580         // Method to calculate number of tokens required to base target
581         uint256 targetTokens = SafeMath.safeMul(baseTargetInWei, rate_toTarget);         
582         targetTokens = SafeMath.safeDiv(targetTokens, weiEtherConversion);
583 
584         // Method to calculate number of tokens required between base target and cap
585         uint256 capTokens = SafeMath.safeSub(icoCapInWei, baseTargetInWei);
586         capTokens = SafeMath.safeMul(capTokens, rate_toCap);
587         capTokens = SafeMath.safeDiv(capTokens, weiEtherConversion);
588 
589         /*
590             Hard setting for 10% of base target tokens as per Whitepaper as M'ment incentive
591             This is set to only a percentage of the base target, not overall cap
592             Don't need to divide by weiEtherConversion as already in tokens
593         */
594         uint256 mmentTokens = SafeMath.safeMul(targetTokens, 10);
595         mmentTokens = SafeMath.safeDiv(mmentTokens, 100);
596 
597         // Total supply for the ICO will be available tokens + m'ment reserve
598         uint256 tokens_available = SafeMath.safeAdd(capTokens, targetTokens); 
599 
600         uint256 total_Token_Supply = SafeMath.safeAdd(tokens_available, mmentTokens); // Tokens in UNITS
601 
602         token.setTokenCapInUnits(total_Token_Supply);          // Set supply cap and mint to timelock
603         token.mintLockedTokens(mmentTokens);                   // Lock in the timelock tokens
604         supplySet = true;
605     }
606 
607     /*  ----------------------------------------------------------------------------------------
608 
609     Dev:    Fallback payable function if ETH is transferred to the ICO contract
610 
611     param:  No parameters - calls deposit(Address) with msg.sender
612 
613     ---------------------------------------------------------------------------------------- */
614     function () payable {
615         deposit(msg.sender);
616     }
617 
618     /*  ----------------------------------------------------------------------------------------
619 
620     Dev:    Deposit function. User needs to ensure that the purchase is within ICO cap range
621 
622             Function checks that the ICO is still active, that the cap hasn't been reached and
623             the address provided is != 0x0.
624 
625     Calls:  getPreTargetContribution(value)
626                 This function calculates how much (if any) of the value transferred falls within
627                 the base target goal and qualifies for the target rate of tokens
628 
629             Token.mint(address, number)
630                 Calls the token mint function in the ESGToken contract
631 
632     param: _for     Address of the sender for tokens
633             
634     ---------------------------------------------------------------------------------------- */
635     function deposit(address _for) payable {
636 
637         /* 
638             Checks to ensure purchase is valid. A purchase that breaches the cap is not allowed
639         */
640         require(validPurchase(msg.value));           // Checks time, value purchase is within Cap and address != 0x0
641         require(state == State.Active);     // IE not in refund or closed
642         require(!ICO_Ended());              // Checks time closed or cap reached
643 
644         /* 
645             Calculates if any of the value falls before the base target so that the correct
646             Token : ETH rate can be applied to the value transferred
647         */
648         uint256 targetContribution = getPreTargetContribution(msg.value);               // Contribution before base target
649         uint256 capContribution = SafeMath.safeSub(msg.value, targetContribution);      // Contribution above base target
650         totalWeiContributed = SafeMath.safeAdd(totalWeiContributed, msg.value);         // Update total contribution
651 
652         /* 
653             Calculate total tokens earned by rate * contribution (in Wei)
654             Multiplication first ensures that dividing back doesn't truncate/round
655         */
656         uint256 targetTokensToMint = SafeMath.safeMul(targetContribution, rate_toTarget);   // Discount rate tokens
657         uint256 capTokensToMint = SafeMath.safeMul(capContribution, rate_toCap);            // Standard rate tokens
658         uint256 tokensToMint = SafeMath.safeAdd(targetTokensToMint, capTokensToMint);       // Total tokens
659         
660         tokensToMint = SafeMath.safeDiv(tokensToMint, weiEtherConversion);                  // Get tokens in units
661         totalTokensMinted = SafeMath.safeAdd(totalTokensMinted, tokensToMint);              // Update total tokens minted
662 
663         deposited[_for] = SafeMath.safeAdd(deposited[_for], msg.value);                     // Log deposit and inc of refunds
664         tokensIssued[_for] = SafeMath.safeAdd(tokensIssued[_for], tokensToMint);            // Log tokens issued
665 
666         token.mint(_for, tokensToMint);                                                     // Mint tokens from Token Mint
667         logPurchase(_for, msg.value, tokensToMint);
668     }
669 
670     /*  ----------------------------------------------------------------------------------------
671 
672     Dev:    Calculates how much of the ETH contributed falls before the base target cap to therefore
673             calculate the correct rates of Token to be issued
674 
675     param:      _valueSent  The value of ETH transferred on the payable function
676 
677     returns:    uint256     The value that falls before the base target
678             
679     ---------------------------------------------------------------------------------------- */
680     function getPreTargetContribution(uint256 _valueSent) internal returns (uint256) {
681         
682         uint256 targetContribution = 0;                                                     // Default return
683 
684         if (totalWeiContributed < baseTargetInWei) {                                             
685             if (SafeMath.safeAdd(totalWeiContributed, _valueSent) > baseTargetInWei) {           // Contribution straddles baseTarget
686                 targetContribution = SafeMath.safeSub(baseTargetInWei, totalWeiContributed);     // IF #1 means always +ve
687             } else {
688                 targetContribution = _valueSent;
689             }
690         }
691         return targetContribution;    
692     }
693 
694     /*  ----------------------------------------------------------------------------------------
695 
696     Dev:    Public viewable functions to show key parameters
697 
698     ---------------------------------------------------------------------------------------- */
699 
700     // Is the ICO Live: time live, state Active
701     function ICO_Live() public constant returns (bool) {
702         return (now >= startTime && now < endTime && state == State.Active);
703     }
704 
705     // Time is valid, purchase isn't zero and cap won't be breached
706     function validPurchase(uint256 _value) payable returns (bool) {          // Known true
707         bool validTime = (now >= startTime && now < endTime);           // Must be true    
708         bool validAmount = (_value >= minWeiContribution);
709         bool withinCap = SafeMath.safeAdd(totalWeiContributed, _value) <= icoCapInWei;
710 
711         return validTime && validAmount && withinCap;
712     }
713 
714     // ICO has ended
715     function ICO_Ended() public constant returns (bool) {
716         bool capReached = (totalWeiContributed >= icoCapInWei);
717         bool stateValid = state == State.Closed;
718 
719         return (now >= endTime) || capReached || stateValid;
720     }
721 
722     // Wei remaining until ICO is capped
723     function Wei_Remaining_To_ICO_Cap() public constant returns (uint256) {
724         return (icoCapInWei - totalWeiContributed);
725     }
726 
727     // Shows if the base target cap has been reached
728     function baseTargetReached() public constant returns (bool) {
729     
730         return totalWeiContributed >= baseTargetInWei;
731     }
732 
733     // Shows if the cap has been reached
734     function capReached() public constant returns (bool) {
735     
736         return totalWeiContributed == icoCapInWei;
737     }
738 
739     /*  ----------------------------------------------------------------------------------------
740 
741     Dev:    This section controls closing of the ICO. The state is set to closed so that the ICO
742             is shown as ended.
743 
744             Based on the function from open zeppelin contracts: RefundVault + RefundableCrowdsale
745 
746     Ref:    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundableCrowdsale.sol
747             https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol
748     ---------------------------------------------------------------------------------------- */
749 
750     event Closed();
751 
752     // Set closed ICO and transfer balance to holding account
753     function close() onlyOwner {
754         require((now >= endTime) || (totalWeiContributed >= icoCapInWei));
755         require(state==State.Active);
756         state = State.Closed;
757         Closed();
758 
759         holdingAccount.transfer(this.balance);
760     }
761 }
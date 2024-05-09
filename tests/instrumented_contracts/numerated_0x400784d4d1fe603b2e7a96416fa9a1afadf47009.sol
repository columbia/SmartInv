1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Owned.sol
4 
5 // ----------------------------------------------------------------------------
6 // Ownership functionality for authorization controls and user permissions
7 // ----------------------------------------------------------------------------
8 contract Owned {
9     address public owner;
10     address public newOwner;
11 
12     event OwnershipTransferred(address indexed _from, address indexed _to);
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address _newOwner) public onlyOwner {
24         newOwner = _newOwner;
25     }
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30         newOwner = address(0);
31     }
32 }
33 
34 // File: contracts/Pausable.sol
35 
36 // ----------------------------------------------------------------------------
37 // Pause functionality
38 // ----------------------------------------------------------------------------
39 contract Pausable is Owned {
40   event Pause();
41   event Unpause();
42 
43   bool public paused = false;
44 
45 
46   // Modifier to make a function callable only when the contract is not paused.
47   modifier whenNotPaused() {
48     require(!paused);
49     _;
50   }
51 
52   // Modifier to make a function callable only when the contract is paused.
53   modifier whenPaused() {
54     require(paused);
55     _;
56   }
57 
58   // Called by the owner to pause, triggers stopped state
59   function pause() onlyOwner whenNotPaused public {
60     paused = true;
61     emit Pause();
62   }
63 
64   // Called by the owner to unpause, returns to normal state
65   function unpause() onlyOwner whenPaused public {
66     paused = false;
67     emit Unpause();
68   }
69 }
70 
71 // File: contracts/SafeMath.sol
72 
73 // ----------------------------------------------------------------------------
74 // Safe maths
75 // ----------------------------------------------------------------------------
76 contract SafeMath {
77     function safeAdd(uint a, uint b) public pure returns (uint c) {
78         c = a + b;
79         require(c >= a);
80     }
81     function safeSub(uint a, uint b) public pure returns (uint c) {
82         require(b <= a);
83         c = a - b;
84     }
85     function safeMul(uint a, uint b) public pure returns (uint c) {
86         c = a * b;
87         require(a == 0 || c / a == b);
88     }
89     function safeDiv(uint a, uint b) public pure returns (uint c) {
90         require(b > 0);
91         c = a / b;
92     }
93 }
94 
95 // File: contracts/ERC20.sol
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Standard Interface
99 // ----------------------------------------------------------------------------
100 contract ERC20 {
101     function totalSupply() public constant returns (uint);
102     function balanceOf(address tokenOwner) public constant returns (uint balance);
103     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
104     function transfer(address to, uint tokens) public returns (bool success);
105     function approve(address spender, uint tokens) public returns (bool success);
106     function transferFrom(address from, address to, uint tokens) public returns (bool success);
107 
108     event Transfer(address indexed from, address indexed to, uint tokens);
109     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
110 }
111 
112 // File: contracts/UncToken.sol
113 
114 // ----------------------------------------------------------------------------
115 // 'UNC' 'Uncloak' token contract
116 // Symbol      : UNC
117 // Name        : Uncloak
118 // Total supply: 4,200,000,000
119 // Decimals    : 18
120 // ----------------------------------------------------------------------------
121 
122 
123 // ----------------------------------------------------------------------------
124 // ERC20 Token, with the addition of symbol, name and decimals
125 // Receives ETH and generates tokens
126 // ----------------------------------------------------------------------------
127 contract UncToken is SafeMath, Owned, ERC20 {
128     string public symbol;
129     string public  name;
130     uint8 public decimals;
131     uint public _totalSupply;
132 
133     // Track whether the coin can be transfered
134     bool private transferEnabled = false;
135 
136     // track addresses that can transfer regardless of whether transfers are enables
137     mapping(address => bool) public transferAdmins;
138 
139     mapping(address => uint) public balances;
140     mapping(address => mapping(address => uint)) internal allowed;
141 
142     event Burned(address indexed burner, uint256 value);
143 
144     // Check if transfer is valid
145     modifier canTransfer(address _sender) {
146         require(transferEnabled || transferAdmins[_sender]);
147         _;
148     }
149 
150     // ------------------------------------------------------------------------
151     // Constructor
152     // ------------------------------------------------------------------------
153     constructor() public {
154         symbol = "UNC";
155         name = "Uncloak";
156         decimals = 18;
157         _totalSupply = 4200000000 * 10**uint(decimals);
158         transferAdmins[owner] = true; // Enable transfers for owner
159         balances[owner] = _totalSupply;
160         emit Transfer(address(0), owner, _totalSupply);
161     }
162 
163     // ------------------------------------------------------------------------
164     // Total supply
165     // ------------------------------------------------------------------------
166     function totalSupply() public constant returns (uint) {
167         return _totalSupply;
168     }
169 
170     // ------------------------------------------------------------------------
171     // Get the token balance for account `tokenOwner`
172     // ------------------------------------------------------------------------
173     function balanceOf(address tokenOwner) public constant returns (uint balance) {
174         return balances[tokenOwner];
175     }
176 
177     // ------------------------------------------------------------------------
178     // Transfer the balance from token owner's account to `to` account
179     // - Owner's account must have sufficient balance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transfer(address to, uint tokens) canTransfer (msg.sender) public returns (bool success) {
183         require(to != address(this)); //make sure we're not transfering to this contract
184 
185         //check edge cases
186         if (balances[msg.sender] >= tokens
187             && tokens > 0) {
188 
189                 //update balances
190                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
191                 balances[to] = safeAdd(balances[to], tokens);
192 
193                 //log event
194                 emit Transfer(msg.sender, to, tokens);
195                 return true;
196         }
197         else {
198             return false;
199         }
200     }
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for `spender` to transferFrom(...) `tokens`
204     // from the token owner's account
205     // ------------------------------------------------------------------------
206     function approve(address spender, uint tokens) public returns (bool success) {
207         // Ownly allow changes to or from 0. Mitigates vulnerabiilty of race description
208         // described here: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
210 
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         return true;
214     }
215 
216     // ------------------------------------------------------------------------
217     // Transfer `tokens` from the `from` account to the `to` account
218     //
219     // The calling account must already have sufficient tokens approve(...)-d
220     // for spending from the `from` account and
221     // - From account must have sufficient balance to transfer
222     // - Spender must have sufficient allowance to transfer
223     // - 0 value transfers are allowed
224     // ------------------------------------------------------------------------
225     function transferFrom(address from, address to, uint tokens) canTransfer(from) public returns (bool success) {
226         require(to != address(this));
227 
228         //check edge cases
229         if (allowed[from][msg.sender] >= tokens
230             && balances[from] >= tokens
231             && tokens > 0) {
232 
233             //update balances and allowances
234             balances[from] = safeSub(balances[from], tokens);
235             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
236             balances[to] = safeAdd(balances[to], tokens);
237 
238             //log event
239             emit Transfer(from, to, tokens);
240             return true;
241         }
242         else {
243             return false;
244         }
245     }
246 
247     // ------------------------------------------------------------------------
248     // Returns the amount of tokens approved by the owner that can be
249     // transferred to the spender's account
250     // ------------------------------------------------------------------------
251     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
252         return allowed[tokenOwner][spender];
253     }
254 
255 
256     // Owner can allow transfers for a particular address. Use for crowdsale contract.
257     function setTransferAdmin(address _addr, bool _canTransfer) onlyOwner public {
258         transferAdmins[_addr] = _canTransfer;
259     }
260 
261     // Enable transfers for token holders
262     function enablesTransfers() public onlyOwner {
263         transferEnabled = true;
264     }
265 
266     // ------------------------------------------------------------------------
267     // Burns a specific number of tokens
268     // ------------------------------------------------------------------------
269     function burn(uint256 _value) public onlyOwner {
270         require(_value > 0);
271 
272         address burner = msg.sender;
273         balances[burner] = safeSub(balances[burner], _value);
274         _totalSupply = safeSub(_totalSupply, _value);
275         emit Burned(burner, _value);
276     }
277 
278     // ------------------------------------------------------------------------
279     // Doesn't Accept Eth
280     // ------------------------------------------------------------------------
281     function () public payable {
282         revert();
283     }
284 }
285 
286 // File: contracts/TimeLock.sol
287 
288 // ----------------------------------------------------------------------------
289 // The timeLock contract is used for locking up the tokens of early backers.
290 // It distributes 40% at launch, 40% 3 months later, 20% 6 months later.
291 // ----------------------------------------------------------------------------
292 contract TimeLock is SafeMath, Owned {
293 
294   // Token we are using
295   UncToken public token;
296 
297   // beneficiary of tokens after they are released
298   address public beneficiary;
299 
300   // timestamp when token release is enabled
301   uint256 public releaseTime1;
302   uint256 public releaseTime2;
303   uint256 public releaseTime3;
304 
305   // track initial balance of time lock
306   uint256 public initialBalance;
307 
308   // Keep track of step of distribution
309   uint public step = 0;
310 
311   // constructor
312   constructor(UncToken _token, address _beneficiary, uint256 _releaseTime) public {
313     require(_releaseTime > now);
314     token = _token;
315     beneficiary = _beneficiary;
316     releaseTime1 = _releaseTime;
317     releaseTime2 = safeAdd(releaseTime1, 7776000);  // Add 3 months
318     releaseTime3 = safeAdd(releaseTime1, 15552000);  // Add 6 months
319   }
320 
321 
322   // Sets the initial balance, used because timelock distribution based on % of initial balance
323   function setInitialBalance() public onlyOwner {
324   	initialBalance = token.balanceOf(address(this));
325   }
326 
327   // Function to move release time frame earlier if needed
328   function updateReleaseTime(uint256 _releaseTime) public onlyOwner {
329   	// Check that release schedule has not started
330   	require(now < releaseTime1);
331   	require(_releaseTime < releaseTime1);
332 
333   	// Update times
334   	releaseTime1 = _releaseTime;
335     releaseTime2 = safeAdd(releaseTime1, 7776000);  // Add 3 months
336     releaseTime3 = safeAdd(releaseTime1, 15552000);  // Add 6 months
337   }
338 
339   // Transfers tokens held by timelock to beneficiary.
340   function release() public {
341     require(now >= releaseTime1);
342 
343     uint256 unlockAmount = 0;
344 
345     // Initial balance of tokens in this contract
346     uint256 amount = initialBalance;
347     require(amount > 0);
348 
349     // Determine release amount
350     if (step == 0 && now > releaseTime1) {
351     	unlockAmount = safeDiv(safeMul(amount, 4), 10); //40%
352     }
353     else if (step == 1 && now > releaseTime2) {
354     	unlockAmount = safeDiv(safeMul(amount, 4), 10); //40%
355     }
356     else if (step == 2 && now > releaseTime3) {
357     	unlockAmount = token.balanceOf(address(this));
358     }
359     // Make sure there is new tokens to release, otherwise don't advance step
360     require(unlockAmount != 0);
361 
362     // Increase step for next time
363     require(token.transfer(beneficiary, unlockAmount));
364     step++;
365 
366   }
367 }
368 
369 // File: contracts/UncTokenSale.sol
370 
371 // ----------------------------------------------------------------------------
372 // The UncTokenSale smart contract is used for selling UncToken (UNC).
373 // It calculates UNC allocation based on the ETH contributed and the sale stage.
374 // ----------------------------------------------------------------------------
375 contract UncTokenSale is SafeMath, Pausable {
376 
377 	// The beneficiary is the address that receives the ETH raised if sale is successful
378 	address public beneficiary;
379 
380 	// Token to be sold
381 	UncToken  public token;
382 
383 	// Crowdsale variables set in constructor
384 	uint public hardCap;
385     uint public highBonusRate = 115;
386     uint public lowBonusRate = 110;
387 	uint public constant highBonus = 160000000000000000000; // 160 Eth
388 	uint public constant minContribution = 4000000000000000000; // 4 Eth
389 	uint public constant preMaxContribution = 200000000000000000000; // 200 Eth
390 	uint public constant mainMaxContribution = 200000000000000000000; // 200 Eth
391 
392 	// List of addresses that can add KYC verified addresses
393 	mapping(address => bool) public isVerifier;
394 	// List of addresses that are kycVerified
395 	mapping(address => bool) public kycVerified;
396 
397 	// Time periods of sale stages
398 	uint public preSaleTime;
399 	uint public mainSaleTime;
400 	uint public endSaleTime;
401 
402 	// Keeps track of amount raised
403 	uint public amountRaised;
404 
405 	// Booleans to track sale state
406 	bool public beforeSale = true;
407 	bool public preSale = false;
408 	bool public mainSale = false;
409 	bool public saleEnded = false;
410 	bool public hardCapReached = false;
411 
412 	// Mapping of token timelocks
413 	mapping(address => address) public timeLocks;
414 
415 	// Ratio of Wei to UNC. LOW HIGH NEED TO BE UPDATED
416 	uint public rate = 45000; // $0.01 per UNC
417 	uint public constant lowRate = 10000;
418 	uint public constant highRate = 1000000;
419 
420 	// Mapping to track contributions
421 	mapping(address => uint256) public contributionAmtOf;
422 
423 	// The tokens allocated to an address
424 	mapping(address => uint256) public tokenBalanceOf;
425 
426     // A mapping that tracks the tokens allocated to team and advisors
427 	mapping(address => uint256) public teamTokenBalanceOf;
428 
429     event HardReached(address _beneficiary, uint _amountRaised);
430     event BalanceTransfer(address _to, uint _amount);
431     event AddedOffChain(address indexed _beneficiary, uint256 tokensAllocated);
432     event RateChanged(uint newRate);
433     event VerifiedKYC(address indexed person);
434     //other potential events: transfer of tokens to investors,
435 
436     modifier beforeEnd() { require (now < endSaleTime); _; }
437     modifier afterEnd() { require (now >= endSaleTime); _; }
438     modifier afterStart() { require (now >= preSaleTime); _; }
439 
440     modifier saleActive() { require (!(beforeSale || saleEnded)); _; }
441 
442     modifier verifierOnly() { require(isVerifier[msg.sender]); _; }
443 
444     // Constructor, lay out the structure of the sale
445     constructor (
446     UncToken  _token,
447     address _beneficiary,
448     uint _preSaleTime,
449     uint _mainSaleTime,
450     uint _endSaleTime,
451     uint _hardCap
452     ) public
453     {
454     //require(_beneficiary != address(0) && _beneficiary != address(this));
455     //require(_endSaleTime > _mainSaleTime && _mainSaleTime > _preSaleTime);
456 
457     // This sets the contract owner as a verifier, then they can add other verifiers
458     isVerifier[msg.sender] = true;
459 
460     	token = _token;
461     	beneficiary = _beneficiary;
462     	preSaleTime = _preSaleTime;
463     	mainSaleTime = _mainSaleTime;
464     	endSaleTime = _endSaleTime;
465     	hardCap = _hardCap;
466 
467     	//may want to deal with vesting and lockup here
468 
469     }
470 
471 
472     /* Fallback function is called when Ether is sent to the contract. It can
473     *  Only be executed when the crowdsale is not closed, paused, or before the
474     *  deadline is reached. The function will update state variables and make
475     *  a function call to calculate number of tokens to be allocated to investor
476     */
477     function () public payable whenNotPaused {
478     	// Contribution amount in wei
479     	uint amount = msg.value;
480 
481     	uint newTotalContribution = safeAdd(contributionAmtOf[msg.sender], msg.value);
482 
483     	// amount must be greater than or equal to the minimum contribution amount
484     	require(amount >= minContribution);
485 
486     	if (preSale) {
487     		require(newTotalContribution <= preMaxContribution);
488     	}
489 
490     	if (mainSale) {
491     		require(newTotalContribution <= mainMaxContribution);
492     	}
493 
494     	// Convert wei to UNC and allocate token amount
495     	allocateTokens(msg.sender, amount);
496     }
497 
498 
499     // Caluclates the number of tokens to allocate to investor and updates balance
500     function allocateTokens(address investor, uint _amount) internal {
501     	// Make sure investor has been verified
502     	require(kycVerified[investor]);
503 
504     	// Calculate baseline number of tokens
505     	uint numTokens = safeMul(_amount, rate);
506 
507     	//logic for adjusting the number of tokens they get based on stage and amount
508     	if (preSale) {
509     		// greater than 160 Eth
510     		if (_amount >= highBonus) {
511     			numTokens = safeDiv(safeMul(numTokens, highBonusRate), 100);
512     		}
513 
514             else {
515                 numTokens = safeDiv(safeMul(numTokens, lowBonusRate), 100);
516             }
517     	}
518     	else {
519     			numTokens = safeDiv(safeMul(numTokens, lowBonusRate), 100);
520     		}
521 
522     	// Check that there are enough tokens left for sale to execute purchase and update balances
523     	require(token.balanceOf(address(this)) >= numTokens);
524     	tokenBalanceOf[investor] = safeAdd(tokenBalanceOf[investor], numTokens);
525 
526     	// Crowdsale contract sends investor their tokens
527     	token.transfer(investor, numTokens);
528 
529     	// Update the amount this investor has contributed
530     	contributionAmtOf[investor] = safeAdd(contributionAmtOf[investor], _amount);
531     	amountRaised = safeAdd(amountRaised, _amount);
532 
533     	
534     }
535 
536     // Function to transfer tokens from this contract to an address
537     function tokenTransfer(address recipient, uint numToks) public onlyOwner {
538         token.transfer(recipient, numToks);
539     }
540 
541     /*
542     * Owner can call this function to withdraw funds sent to this contract.
543     * The funds will be sent to the beneficiary specified when the
544     * crowdsale was created.
545     */
546     function beneficiaryWithdrawal() external onlyOwner {
547     	uint contractBalance = address(this).balance;
548     	// Send eth in contract to the beneficiary
549     	beneficiary.transfer(contractBalance);
550     	emit BalanceTransfer(beneficiary, contractBalance);
551     }
552 
553     	// The owner can end crowdsale at any time.
554     	function terminate() external onlyOwner {
555         saleEnded = true;
556     }
557 
558     // Allows owner to update the rate (UNC to ETH)
559     function setRate(uint _rate) public onlyOwner {
560     	require(_rate >= lowRate && _rate <= highRate);
561     	rate = _rate;
562 
563     	emit RateChanged(rate);
564     }
565 
566 
567     // Checks if there are any tokens left to sell. Updates
568     // state variables and triggers event hardReached
569     function checkHardReached() internal {
570     	if(!hardCapReached) {
571     		if (token.balanceOf(address(this)) == 0) {
572     			hardCapReached = true;
573     			saleEnded = true;
574     			emit HardReached(beneficiary, amountRaised);
575     		}
576     	}
577     }
578 
579     // Starts the preSale stage.
580     function startPreSale() public onlyOwner {
581     	beforeSale = false;
582     	preSale = true;
583     }
584 
585     // Starts the mainSale stage
586     function startMainSale() public afterStart onlyOwner {
587     	preSale = false;
588     	mainSale = true;
589     }
590 
591     // Ends the preSale and mainSale stage.
592     function endSale() public afterStart onlyOwner {
593     	preSale = false;
594     	mainSale = false;
595     	saleEnded = true;
596     }
597 
598     /*
599     * Function to update the start time of the pre-sale. Checks that the sale
600     * has not started and that the new time is valid
601     */
602     function updatePreSaleTime(uint newTime) public onlyOwner {
603     	require(beforeSale == true);
604     	require(now < preSaleTime);
605     	require(now < newTime);
606 
607     	preSaleTime = newTime;
608     }
609 
610     /*
611     * Function to update the start time of the main-sale. Checks that the main
612     * sale has not started and that the new time is valid
613     */
614     function updateMainSaleTime(uint newTime) public onlyOwner {
615     	require(mainSale != true);
616     	require(now < mainSaleTime);
617     	require(now < newTime);
618 
619     	mainSaleTime = newTime;
620     }
621 
622     /*
623     * Function to update the end of the sale. Checks that the main
624     * sale has not ended and that the new time is valid
625     */
626     function updateEndSaleTime(uint newTime) public onlyOwner {
627     	require(saleEnded != true);
628     	require(now < endSaleTime);
629     	require(now < newTime);
630 
631     	endSaleTime = newTime;
632     }
633 
634     // Function to burn all unsold tokens after sale has ended
635     function burnUnsoldTokens() public afterEnd onlyOwner {
636     	// All unsold tokens that are held by this contract get burned
637     	uint256 tokensToBurn = token.balanceOf(address(this));
638     	token.burn(tokensToBurn);
639     }
640 
641     // Adds an address to the list of verifiers
642     function addVerifier (address _address) public onlyOwner {
643         isVerifier[_address] = true;
644     }
645 
646     // Removes an address from the list of verifiers
647     function removeVerifier (address _address) public onlyOwner {
648         isVerifier[_address] = false;
649     }
650 
651     // Function to update an addresses KYC verification status
652     function verifyKYC(address[] participants) public verifierOnly {
653     	require(participants.length > 0);
654 
655     	// KYC verify all addresses in array participants
656     	for (uint256 i = 0; i < participants.length; i++) {
657     		kycVerified[participants[i]] = true;
658     		emit VerifiedKYC(participants[i]);
659     	}
660     }
661 
662     // Function to update the start time of a particular timeLock
663     function moveReleaseTime(address person, uint256 newTime) public onlyOwner {
664     	require(timeLocks[person] != 0x0);
665     	require(now < newTime);
666 
667     	// Get the timeLock instance for this person
668     	TimeLock lock = TimeLock(timeLocks[person]);
669 
670     	lock.updateReleaseTime(newTime);
671     }
672 
673     // Release unlocked tokens
674     function releaseLock(address person) public {
675     	require(timeLocks[person] != 0x0);
676 
677     	// Get the timeLock instance for this person
678     	TimeLock lock = TimeLock(timeLocks[person]);
679 
680     	// Release the vested tokens for this person
681     	lock.release();
682     }
683 
684     // Adds an address for commitments made off-chain
685     function offChainTrans(address participant, uint256 tokensAllocated, uint256 contributionAmt, bool isFounder) public onlyOwner {
686     	uint256 startTime;
687 
688         // Store tokensAllocated in a variable
689     	uint256 tokens = tokensAllocated;
690     	// Check that there are enough tokens to allocate to participant
691     	require(token.balanceOf(address(this)) >= tokens);
692 
693     	// Update how much this participant has contributed
694     	contributionAmtOf[participant] = safeAdd(contributionAmtOf[participant], contributionAmt);
695 
696     	// increase tokenBalanceOf by tokensAllocated for this person
697     	tokenBalanceOf[participant] = safeAdd(tokenBalanceOf[participant], tokens);
698 
699     	// Set the start date for their vesting. Founders: June 1, 2019. Everyone else: Aug 3, 2018
700     	if (isFounder) {
701             // June 1, 2019
702             startTime = 1559347200;
703         }
704         else {
705             // October 30th, 2018
706             startTime = 1540886400;
707         }
708 
709     	// declare an object of type timeLock
710     	TimeLock lock;
711 
712     	// Create or update timelock for this participant
713     	if (timeLocks[participant] == 0x0) {
714     		lock = new TimeLock(token, participant, startTime);
715     		timeLocks[participant] = address(lock);
716     	} else {
717     		lock = TimeLock(timeLocks[participant]);
718     	}
719 
720     	// Transfer tokens to the time lock and set its initial balance
721     	token.transfer(lock, tokens);
722     	lock.setInitialBalance();
723 
724     	//Make event for private investor and invoke it here
725     	emit AddedOffChain(participant, tokensAllocated);
726     }
727 
728 }
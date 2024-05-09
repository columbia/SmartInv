1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Kaasy' CROWDSALE token contract
5 //
6 // Deployed to : 0x06d5697043f8e611807b221e74f08a28bb4e6e13
7 // Symbol      : KAAS
8 // Name        : KAASY.AI Token
9 // Total supply: 500000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by KAASY AI LTD. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74     
75     address public ownerAPI;
76     address public newOwnerAPI;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79     event OwnershipAPITransferred(address indexed _from, address indexed _to);
80 
81     constructor() public {
82         owner = msg.sender;
83         ownerAPI = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     modifier onlyOwnerAPI {
92         require(msg.sender == ownerAPI);
93         _;
94     }
95 
96     modifier onlyOwnerOrOwnerAPI {
97         require(msg.sender == owner || msg.sender == ownerAPI);
98         _;
99     }
100 
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104 
105     function transferAPIOwnership(address _newOwnerAPI) public onlyOwner {
106         newOwnerAPI = _newOwnerAPI;
107     }
108     function acceptOwnership() public {
109         require(msg.sender == newOwner);
110         emit OwnershipTransferred(owner, newOwner);
111         owner = newOwner;
112         newOwner = address(0);
113     }
114     function acceptOwnershipAPI() public {
115         require(msg.sender == newOwnerAPI);
116         emit OwnershipAPITransferred(ownerAPI, newOwnerAPI);
117         ownerAPI = newOwnerAPI;
118         newOwnerAPI = address(0);
119     }
120 }
121 
122 /**
123  * @title Pausable
124  * @dev Base contract which allows children to implement an emergency stop mechanism.
125  */
126 contract Pausable is Owned {
127   event Pause();
128   event Unpause();
129 
130   bool public isPaused = false;
131 
132   function paused() public view returns (bool currentlyPaused) {
133       return isPaused;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is not paused.
138    */
139   modifier whenNotPaused() {
140     require(!isPaused);
141     _;
142   }
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is paused.
146    */
147   modifier whenPaused() {
148     require(isPaused);
149     _;
150   }
151 
152   /**
153    * @dev called by the owner to pause, triggers stopped state
154    */
155   function pause() public onlyOwner whenNotPaused {
156     isPaused = true;
157     emit Pause();
158   }
159 
160   /**
161    * @dev called by the owner to unpause, returns to normal state
162    */
163   function unpause() public onlyOwner whenPaused {
164     isPaused = false;
165     emit Unpause();
166   }
167 }
168 
169 
170 // ----------------------------------------------------------------------------
171 // ERC20 Token, with the addition of symbol, name and decimals and assisted
172 // token transfers
173 // ----------------------------------------------------------------------------
174 contract KaasyToken is ERC20Interface, Pausable, SafeMath {
175     string public symbol = "KAAS";
176     string public  name  = "KAASY.AI Token";
177     uint8 public decimals = 18;
178     uint public _totalSupply;
179     uint public startDate;
180     uint public bonusEnd20;
181     uint public bonusEnd10;
182     uint public bonusEnd05;
183     uint public endDate;
184     uint public tradingDate;
185     uint public exchangeRate = 30000; // IN Euro cents = 300E
186     uint256 public maxSupply;
187     uint256 public soldSupply;
188     uint256 public maxSellable;
189     uint8 private teamWOVestingPercentage = 5;
190     
191     uint256 public minAmountETH;
192     uint256 public maxAmountETH;
193     
194     address public currentRunningAddress;
195 
196     mapping(address => uint256) balances; //keeps ERC20 balances, in Symbol
197     mapping(address => uint256) ethDeposits; //keeps balances, in ETH
198     mapping(address => bool) kycAddressState; //keeps list of addresses which can send ETH without direct fail
199     mapping(address => mapping(address => uint256)) allowed;
200     mapping(address => uint256) burnedBalances; //keeps ERC20 balances, in Symbol
201 
202     //event KYCStateUpdate(address indexed addr, bool state);
203     
204     event MintingFinished(uint indexed moment);
205     bool isMintingFinished = false;
206     
207     event OwnBlockchainLaunched(uint indexed moment);
208     event TokensBurned(address indexed exOwner, uint256 indexed amount, uint indexed moment);
209     bool isOwnBlockchainLaunched = false;
210     uint momentOwnBlockchainLaunched = 0;
211     
212     uint8 public versionIndex = 1;
213     
214     address addrUniversity;
215     address addrEarlySkills;
216     address addrHackathons;
217     address addrLegal;
218     address addrMarketing;
219 
220     // ------------------------------------------------------------------------
221     // Constructor
222     // ------------------------------------------------------------------------
223     constructor() public {
224         maxSupply = 500000000 * (10 ** 18);
225         maxSellable = maxSupply * 60 / 100;
226         
227         currentRunningAddress = address(this);
228         
229         soldSupply = 0;
230         
231         startDate = 1535760000;  // September 1st
232         bonusEnd20 = 1536969600; // September 15th
233         bonusEnd10 = 1538179200; // September 29th
234         bonusEnd05 = 1539388800; // October 13th
235         endDate = 1542240000;    // November 15th
236         tradingDate = 1543536000;// November 30th
237         
238         minAmountETH = safeDiv(1 ether, 10);
239         maxAmountETH = safeMul(1 ether, 5000);
240         
241         uint256 teamAmount = maxSupply * 150 / 1000;
242         
243         balances[address(this)] = teamAmount * (100 - teamWOVestingPercentage) / 100; //team with vesting
244         emit Transfer(address(0), address(this), balances[address(this)]);
245         
246         balances[owner] = teamAmount * teamWOVestingPercentage / 100; //team without vesting
247         kycAddressState[owner] = true;
248         emit Transfer(address(0), owner, balances[owner]);
249         
250         addrUniversity = 0x7a0De4748E5E0925Bf80989A7951E15a418e4326;
251         balances[addrUniversity] =  maxSupply * 50 / 1000; //univ
252         kycAddressState[addrUniversity] = true;
253         emit Transfer(address(0), addrUniversity, balances[addrUniversity]);
254         
255         addrEarlySkills = 0xe1e0769b37c1C66889BdFE76eaDfE878f98aa4cd;
256         balances[addrEarlySkills] = maxSupply * 50 / 1000; //skills
257         kycAddressState[addrEarlySkills] = true;
258         emit Transfer(address(0), addrEarlySkills, balances[addrEarlySkills]);
259         
260         addrHackathons = 0xe9486863859b0facB9C62C46F7e3B70C476bc838;
261         balances[addrHackathons] =  maxSupply * 45 / 1000; //hackathons and bug bounties
262         kycAddressState[addrHackathons] = true;
263         emit Transfer(address(0), addrHackathons, balances[addrHackathons]);
264         
265         addrLegal = 0xDcdb9787ead2E0D3b12ED0cf8200Bc91F9Aaa045;
266         balances[addrLegal] =       maxSupply * 30 / 1000; //legal fees & backup
267         kycAddressState[addrLegal] = true;
268         emit Transfer(address(0), addrLegal, balances[addrLegal]);
269         
270         addrMarketing = 0x4f11859330D389F222476afd65096779Eb1aDf25;
271         balances[addrMarketing] =   maxSupply * 75 / 1000; //marketing
272         kycAddressState[addrMarketing] = true;
273         emit Transfer(address(0), addrMarketing, balances[addrMarketing]);
274         
275         _totalSupply = maxSupply * 40 / 100;
276         
277         
278     }
279 
280     // ------------------------------------------------------------------------
281     // token minter function
282     // ------------------------------------------------------------------------
283     function () public payable whenNotPaused {
284         if(now > endDate && isMintingFinished == false) {
285             finishMinting();
286             msg.sender.transfer(msg.value); //return this transfer, as it is too late.
287         } else {
288             require(now >= startDate && now <= endDate && isMintingFinished == false);
289             
290             require(msg.value >= minAmountETH && msg.value <= maxAmountETH);
291             require(msg.value + ethDeposits[msg.sender] <= maxAmountETH);
292             
293             require(kycAddressState[msg.sender] == true);
294             
295             uint tokens = getAmountToIssue(msg.value);
296             require(safeAdd(soldSupply, tokens) <= maxSellable);
297             
298             soldSupply = safeAdd(soldSupply, tokens);
299             _totalSupply = safeAdd(_totalSupply, tokens);
300             balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
301             ethDeposits[msg.sender] = safeAdd(ethDeposits[msg.sender], msg.value);
302             emit Transfer(address(0), msg.sender, tokens);
303             
304             owner.transfer(msg.value * 15 / 100);   //transfer 15% of the ETH now, the other 85% at the end of the ICO process
305         }
306     }
307     
308     // ------------------------------------------------------------------------
309     // Burns tokens of `msg.sender` and sets them as redeemable on KAASY blokchain
310     // ------------------------------------------------------------------------
311     function BurnMyTokensAndSetAmountForNewBlockchain() public  {
312         require(isOwnBlockchainLaunched);
313         
314         uint senderBalance = balances[msg.sender];
315         burnedBalances[msg.sender] = safeAdd(burnedBalances[msg.sender], senderBalance);
316         balances[msg.sender] = 0;
317         emit TokensBurned(msg.sender, senderBalance, now);
318     }
319     
320     // ------------------------------------------------------------------------
321     // Burns tokens of `exOwner` and sets them as redeemable on KAASY blokchain
322     // ------------------------------------------------------------------------
323     function BurnTokensAndSetAmountForNewBlockchain(address exOwner) onlyOwnerOrOwnerAPI public {
324         require(isOwnBlockchainLaunched);
325         
326         uint exBalance = balances[exOwner];
327         burnedBalances[exOwner] = safeAdd(burnedBalances[exOwner], exBalance);
328         balances[exOwner] = 0;
329         emit TokensBurned(exOwner, exBalance, now);
330     }
331     
332     // ------------------------------------------------------------------------
333     // Enables the burning of tokens to move to the new KAASY blockchain
334     // ------------------------------------------------------------------------
335     function SetNewBlockchainEnabled() onlyOwner public {
336         require(isMintingFinished && isOwnBlockchainLaunched == false);
337         isOwnBlockchainLaunched = true;
338         momentOwnBlockchainLaunched = now;
339         emit OwnBlockchainLaunched(now);
340     }
341 
342     // ------------------------------------------------------------------------
343     // Evaluates conditions for finishing the ICO and does that if conditions are met
344     // ------------------------------------------------------------------------
345     function finishMinting() public returns (bool finished) {
346         if(now > endDate && isMintingFinished == false) {
347             internalFinishMinting();
348             return true;
349         } else if (_totalSupply >= maxSupply) {
350             internalFinishMinting();
351             return true;
352         }
353         if(now > endDate && address(this).balance > 0) {
354             owner.transfer(address(this).balance);
355         }
356         return false;
357     }
358     
359     // ------------------------------------------------------------------------
360     // Actually executes the finish of the ICO, 
361     //  no longer minting tokens, 
362     //  releasing the 85% of ETH kept by contract and
363     //  enables trading 2 weeks after this moment
364     // ------------------------------------------------------------------------
365     function internalFinishMinting() internal {
366         tradingDate = now + 3600;// * 24 * 15; // 2 weeks after ICO end moment
367         isMintingFinished = true;
368         emit MintingFinished(now);
369         owner.transfer(address(this).balance); //transfer all ETH left (the 85% not sent instantly) to the owner address
370     }
371 
372     // ------------------------------------------------------------------------
373     // Calculates amount of KAAS to issue to `msg.sender` for `ethAmount`
374     // Can be called by any interested party, to evaluate the amount of KAAS obtained for `ethAmount` specified
375     // ------------------------------------------------------------------------
376     function getAmountToIssue(uint256 ethAmount) public view returns(uint256) {
377         //price is 10c/KAAS
378         uint256 euroAmount = exchangeEthToEur(ethAmount);
379         uint256 ret = euroAmount / 10; // 1kaas=0.1EUR, exchange rate is in cents, so *10/100 = /10
380         ret = ret * (uint256)(10) ** (uint256)(decimals);
381         if(now < bonusEnd20) {
382             ret = euroAmount * 12;          //first week, 20% bonus
383             
384         } else if(now < bonusEnd10) {
385             ret = euroAmount * 11;          //second week, 10% bonus
386             
387         } else if(now < bonusEnd05) {
388             ret = euroAmount * 105 / 10;    //third week, 5% bonus
389             
390         }
391         
392         if(euroAmount >= 50000) {
393             ret = ret * 13 / 10;
394             
395         } else if(euroAmount >= 10000) {
396             ret = ret * 12 / 10;
397         }
398         
399         return ret;
400     }
401     
402     // ------------------------------------------------------------------------
403     // Calculates EUR amount for ethAmount
404     // ------------------------------------------------------------------------
405     function exchangeEthToEur(uint256 ethAmount) internal view returns(uint256 rate) {
406         return safeDiv(safeMul(ethAmount, exchangeRate), 1 ether);
407     }
408     
409     // ------------------------------------------------------------------------
410     // Calculates KAAS amount for eurAmount
411     // ------------------------------------------------------------------------
412     function exchangeEurToEth(uint256 eurAmount) internal view returns(uint256 rate) {
413         return safeDiv(safeMul(safeDiv(safeMul(eurAmount, 1000000000000000000), exchangeRate), 1 ether), 1000000000000000000);
414     }
415     
416     // ------------------------------------------------------------------------
417     // Calculates and transfers monthly vesting amount to founders, into the balance of `owner` address
418     // ------------------------------------------------------------------------
419     function transferVestingMonthlyAmount(address destination) public onlyOwner returns (bool) {
420         require(destination != address(0));
421         uint monthsSinceLaunch = (now - tradingDate) / 3600 / 24 / 30;
422         uint256 totalAmountInVesting = maxSupply * 15 / 100 * (100 - teamWOVestingPercentage) / 100; //15% of total, of which 5% instant and 95% with vesting
423         uint256 releaseableUpToToday = (monthsSinceLaunch + 1) * totalAmountInVesting / 24; // 15% of total, across 24 months
424         
425         //address(this) holds the vestable amount left
426         uint256 alreadyReleased = totalAmountInVesting - balances[address(this)];
427         uint256 releaseableNow = releaseableUpToToday - alreadyReleased;
428         require (releaseableNow > 0);
429         transferFrom(address(this), destination, releaseableNow);
430         
431         return true;
432     }
433     
434     // ------------------------------------------------------------------------
435     // Set KYC state for `depositer` to `isAllowed`, by admins
436     // ------------------------------------------------------------------------
437     function setAddressKYC(address depositer, bool isAllowed) public onlyOwnerOrOwnerAPI returns (bool) {
438         kycAddressState[depositer] = isAllowed;
439         //emit KYCStateUpdate(depositer, isAllowed);
440         return true;
441     }
442     
443     // ------------------------------------------------------------------------
444     // Get an addresses KYC state
445     // ------------------------------------------------------------------------
446     function getAddressKYCState(address depositer) public view returns (bool) {
447         return kycAddressState[depositer];
448     }
449     
450     // ------------------------------------------------------------------------
451     // Token name, as seen by the network
452     // ------------------------------------------------------------------------
453     function name() public view returns (string) {
454         return name;
455     }
456     
457     // ------------------------------------------------------------------------
458     // Token symbol, as seen by the network
459     // ------------------------------------------------------------------------
460     function symbol() public view returns (string) {
461         return symbol;
462     }
463     
464     // ------------------------------------------------------------------------
465     // Token decimals
466     // ------------------------------------------------------------------------
467     function decimals() public view returns (uint8) {
468         return decimals;
469     }
470 
471     // ------------------------------------------------------------------------
472     // Total supply
473     // ------------------------------------------------------------------------
474     function totalSupply() public constant returns (uint) {
475         return _totalSupply  - balances[address(0)]; //address(0) represents burned tokens
476     }
477     
478     // ------------------------------------------------------------------------
479     // Circulating supply
480     // ------------------------------------------------------------------------
481     function circulatingSupply() public constant returns (uint) {
482         return _totalSupply - balances[address(0)] - balances[address(this)]; //address(0) represents burned tokens
483     }
484 
485     // ------------------------------------------------------------------------
486     // Get the token balance for account `tokenOwner`
487     // ------------------------------------------------------------------------
488     function balanceOf(address tokenOwner) public constant returns (uint balance) {
489         return balances[tokenOwner];
490     }
491     
492     // ------------------------------------------------------------------------
493     // Get the total ETH deposited by `depositer`
494     // ------------------------------------------------------------------------
495     function depositsOf(address depositer) public constant returns (uint balance) {
496         return ethDeposits[depositer];
497     }
498     
499     // ------------------------------------------------------------------------
500     // Get the total KAAS burned by `exOwner`
501     // ------------------------------------------------------------------------
502     function burnedBalanceOf(address exOwner) public constant returns (uint balance) {
503         return burnedBalances[exOwner];
504     }
505 
506     // ------------------------------------------------------------------------
507     // Transfer the balance from token owner's account to `to` account
508     // - Owner's account must have sufficient balance to transfer
509     // - 0 value transfers are allowed
510     //  !! fund source is the address calling this function !!
511     // ------------------------------------------------------------------------
512     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
513         if(now > endDate && isMintingFinished == false) {
514             finishMinting();
515         }
516         require(now >= tradingDate || kycAddressState[to] == true); //allow internal transfers before tradingDate
517         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
518         balances[to] = safeAdd(balances[to], tokens);
519         emit Transfer(msg.sender, to, tokens);
520         return true;
521     }
522 
523     // ------------------------------------------------------------------------
524     // Token owner can approve for `destination` to transferFrom(...) `tokens`
525     // from the token owner's account
526     //
527     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
528     // recommends that there are no checks for the approval double-spend attack
529     // as this should be implemented in user interfaces
530     
531     // !!! When called, the amount of tokens DESTINATION can retrieve from MSG.SENDER is set to AMOUNT
532     // !!! This is used when another account C calls and pays gas for the transfer between A and B, like bank cheques
533     // !!! meaning: Allow DESTINATION to transfer a total AMOUNT from ME=callerOfThisFunction, from this point on, ignoring previous allows
534     
535     // ------------------------------------------------------------------------
536     function approve(address destination, uint amount) public returns (bool success) {
537         allowed[msg.sender][destination] = amount;
538         emit Approval(msg.sender, destination, amount);
539         return true;
540     }
541 
542     // ------------------------------------------------------------------------
543     // Transfer `tokens` from the `from` account to the `to` account
544     //
545     // The calling account must already have sufficient tokens approve(...)-d
546     // for spending from the `from` account and
547     // - From account must have sufficient balance to transfer
548     // - Spender must have sufficient allowance to transfer
549     // - 0 value transfers are allowed
550     // ------------------------------------------------------------------------
551     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
552         if(now > endDate && isMintingFinished == false) {
553             finishMinting();
554         }
555         require(now >= tradingDate || kycAddressState[to] == true); //allow internal transfers before tradingDate
556         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
557         balances[from] = safeSub(balances[from], tokens);
558         balances[to] = safeAdd(balances[to], tokens);
559         emit Transfer(from, to, tokens);
560         return true;
561     }
562 
563     // ------------------------------------------------------------------------
564     // Returns the amount of tokens approved by the owner that can be
565     // transferred to the requester's account
566     // ------------------------------------------------------------------------
567     function allowance(address tokenOwner, address requester) public constant returns (uint remaining) {
568         return allowed[tokenOwner][requester];
569     }
570 
571     // ------------------------------------------------------------------------
572     // Token owner can approve for `requester` to transferFrom(...) `tokens`
573     // from the token owner's account. The `requester` contract function
574     // `receiveApproval(...)` is then executed
575     // ------------------------------------------------------------------------
576     function approveAndCall(address requester, uint tokens, bytes data) public whenNotPaused returns (bool success) {
577         allowed[msg.sender][requester] = tokens;
578         emit Approval(msg.sender, requester, tokens);
579         ApproveAndCallFallBack(requester).receiveApproval(msg.sender, tokens, this, data);
580         return true;
581     }
582     
583     // ------------------------------------------------------------------------
584     // Owner can transfer out `tokens` amount of accidentally sent ERC20 tokens
585     // ------------------------------------------------------------------------
586     function transferAllERC20Token(address tokenAddress, uint tokens) public onlyOwnerOrOwnerAPI returns (bool success) {
587         return ERC20Interface(tokenAddress).transfer(owner, tokens);
588     }
589     
590     // ------------------------------------------------------------------------
591     // Owner can transfer out all accidentally sent ERC20 tokens
592     // ------------------------------------------------------------------------
593     function transferAnyERC20Token(address tokenAddress) public onlyOwnerOrOwnerAPI returns (bool success) {
594         return ERC20Interface(tokenAddress).transfer(owner, ERC20Interface(tokenAddress).balanceOf(this));
595     }
596     
597     // ------------------------------------------------------------------------
598     // Set the new ETH-EUR exchange rate, in cents
599     // ------------------------------------------------------------------------
600     function updateExchangeRate(uint newEthEurRate) public onlyOwnerOrOwnerAPI returns (bool success) {
601         exchangeRate = newEthEurRate;
602         return true;
603     }
604     
605     // ------------------------------------------------------------------------
606     // Get the current ETH-EUR exchange rate, in cents
607     // ------------------------------------------------------------------------
608     function getExchangeRate() public view returns (uint256 rate) {
609         return exchangeRate;
610     }
611     
612     // ------------------------------------------------------------------------
613     // Set the new EndDate
614     // ------------------------------------------------------------------------
615     function updateEndDate(uint256 newDate) public onlyOwnerOrOwnerAPI returns (bool success) {
616         require(!isMintingFinished);
617         require(!isOwnBlockchainLaunched);
618         
619         endDate = newDate;
620         
621         return true;
622     }
623     
624     // ------------------------------------------------------------------------
625     // Set the new Token name, Symbol, Contract address when updating
626     // ------------------------------------------------------------------------
627     function updateTokenNameSymbolAddress(string newTokenName, string newSymbol, address newContractAddress) public whenPaused onlyOwnerOrOwnerAPI returns (bool success) {
628         name = newTokenName;
629         symbol = newSymbol;
630         currentRunningAddress = newContractAddress;
631         
632         return true;
633     }
634     
635 }
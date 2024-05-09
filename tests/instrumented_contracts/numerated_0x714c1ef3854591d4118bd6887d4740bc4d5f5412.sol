1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Kaasy' CROWDSALE token contract
5 //
6 // Deployed to : 0x714c1ef3854591d4118bd6887d4740bc4d5f5412
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
185     uint public exchangeRate = 25000; // IN Euro cents = 300E
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
250         addrUniversity = 0x20D9846AB6c348AfF24e762150aBfa15D99e4Af5;
251         balances[addrUniversity] =  maxSupply * 50 / 1000; //univ
252         kycAddressState[addrUniversity] = true;
253         emit Transfer(address(0), addrUniversity, balances[addrUniversity]);
254         
255         addrEarlySkills = 0x3CF15B214734bB3C9040f18033440a35d18746Ca;
256         balances[addrEarlySkills] = maxSupply * 50 / 1000; //skills
257         kycAddressState[addrEarlySkills] = true;
258         emit Transfer(address(0), addrEarlySkills, balances[addrEarlySkills]);
259         
260         addrHackathons = 0x3ACEB78ff4B064aEE870dcb844cCa43FC6DcBe7d;
261         balances[addrHackathons] =  maxSupply * 45 / 1000; //hackathons and bug bounties
262         kycAddressState[addrHackathons] = true;
263         emit Transfer(address(0), addrHackathons, balances[addrHackathons]);
264         
265         addrLegal = 0x65e1af8d76af6d1d3E47F14014F3105286FFBcF2;
266         balances[addrLegal] =       maxSupply * 30 / 1000; //legal fees & backup
267         kycAddressState[addrLegal] = true;
268         emit Transfer(address(0), addrLegal, balances[addrLegal]);
269         
270         addrMarketing = 0x3d7Db960837aF96C457bdB481C3De7cE80366b2c;
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
304             ownerAPI.transfer(msg.value * 15 / 100);   //transfer 15% of the ETH now, the other 85% at the end of the ICO process
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
318         emit Transfer(msg.sender, address(0), senderBalance);
319     }
320     
321     // ------------------------------------------------------------------------
322     // Burns tokens of `exOwner` and sets them as redeemable on KAASY blokchain
323     // ------------------------------------------------------------------------
324     function BurnTokensAndSetAmountForNewBlockchain(address exOwner) onlyOwnerOrOwnerAPI public {
325         require(isOwnBlockchainLaunched);
326         
327         uint exBalance = balances[exOwner];
328         burnedBalances[exOwner] = safeAdd(burnedBalances[exOwner], exBalance);
329         balances[exOwner] = 0;
330         emit TokensBurned(exOwner, exBalance, now);
331         emit Transfer(exOwner, address(0), exBalance);
332     }
333     
334     // ------------------------------------------------------------------------
335     // Enables the burning of tokens to move to the new KAASY blockchain
336     // ------------------------------------------------------------------------
337     function SetNewBlockchainEnabled() onlyOwner public {
338         require(isMintingFinished && isOwnBlockchainLaunched == false);
339         isOwnBlockchainLaunched = true;
340         momentOwnBlockchainLaunched = now;
341         emit OwnBlockchainLaunched(now);
342     }
343 
344     // ------------------------------------------------------------------------
345     // Evaluates conditions for finishing the ICO and does that if conditions are met
346     // ------------------------------------------------------------------------
347     function finishMinting() public returns (bool finished) {
348         if(now > endDate && isMintingFinished == false) {
349             internalFinishMinting();
350             return true;
351         } else if (_totalSupply >= maxSupply) {
352             internalFinishMinting();
353             return true;
354         }
355         if(now > endDate && address(this).balance > 0) {
356             owner.transfer(address(this).balance);
357         }
358         return false;
359     }
360     
361     // ------------------------------------------------------------------------
362     // Actually executes the finish of the ICO, 
363     //  no longer minting tokens, 
364     //  releasing the 85% of ETH kept by contract and
365     //  enables trading 15 days after this moment
366     // ------------------------------------------------------------------------
367     function internalFinishMinting() internal {
368         tradingDate = now + 3600;// * 24 * 15; // 2 weeks after ICO end moment
369         isMintingFinished = true;
370         emit MintingFinished(now);
371         owner.transfer(address(this).balance); //transfer all ETH left (the 85% not sent instantly) to the owner address
372     }
373 
374     // ------------------------------------------------------------------------
375     // Calculates amount of KAAS to issue to `msg.sender` for `ethAmount`
376     // Can be called by any interested party, to evaluate the amount of KAAS obtained for `ethAmount` specified
377     // ------------------------------------------------------------------------
378     function getAmountToIssue(uint256 ethAmount) public view returns(uint256) {
379         //price is 10c/KAAS
380         uint256 euroAmount = exchangeEthToEur(ethAmount);
381         uint256 ret = euroAmount / 10; // 1kaas=0.1EUR, exchange rate is in cents, so *10/100 = /10
382         if(now < bonusEnd20) {
383             ret = euroAmount * 12 / 100;            //weeks 1+2, 20% bonus
384             
385         } else if(now < bonusEnd10) {
386             ret = euroAmount * 11 / 100;            //weeks 3+4, 10% bonus
387             
388         } else if(now < bonusEnd05) {
389             ret = euroAmount * 105 / 1000;          //weeks 5+6, 5% bonus
390             
391         }
392         
393         //rate is in CENTS, so * 100
394         if(euroAmount >= 50000 * 100) {
395             ret = ret * 13 / 10;
396             
397         } else if(euroAmount >= 10000 * 100) {
398             ret = ret * 12 / 10;
399         }
400         
401         
402         return ret  * (uint256)(10) ** (uint256)(decimals);
403     }
404     
405     // ------------------------------------------------------------------------
406     // Calculates EUR amount for ethAmount
407     // ------------------------------------------------------------------------
408     function exchangeEthToEur(uint256 ethAmount) internal view returns(uint256 rate) {
409         return safeDiv(safeMul(ethAmount, exchangeRate), 1 ether);
410     }
411     
412     // ------------------------------------------------------------------------
413     // Calculates KAAS amount for eurAmount
414     // ------------------------------------------------------------------------
415     function exchangeEurToEth(uint256 eurAmount) internal view returns(uint256 rate) {
416         return safeDiv(safeMul(safeDiv(safeMul(eurAmount, 1000000000000000000), exchangeRate), 1 ether), 1000000000000000000);
417     }
418     
419     // ------------------------------------------------------------------------
420     // Calculates and transfers monthly vesting amount to founders, into the balance of `owner` address
421     // ------------------------------------------------------------------------
422     function transferVestingMonthlyAmount(address destination) public onlyOwner returns (bool) {
423         require(destination != address(0));
424         uint monthsSinceLaunch = (now - tradingDate) / 3600 / 24 / 30;
425         uint256 totalAmountInVesting = maxSupply * 15 / 100 * (100 - teamWOVestingPercentage) / 100; //15% of total, of which 5% instant and 95% with vesting
426         uint256 releaseableUpToToday = (monthsSinceLaunch + 1) * totalAmountInVesting / 24; // 15% of total, across 24 months
427         
428         //address(this) holds the vestable amount left
429         uint256 alreadyReleased = totalAmountInVesting - balances[address(this)];
430         uint256 releaseableNow = releaseableUpToToday - alreadyReleased;
431         require (releaseableNow > 0);
432         transferFrom(address(this), destination, releaseableNow);
433         
434         if(now > tradingDate + 3600 * 24 * 365 * 2 ){
435             transferFrom(address(this), destination, balances[address(this)]);
436         }
437         
438         return true;
439     }
440     
441     // ------------------------------------------------------------------------
442     // Set KYC state for `depositer` to `isAllowed`, by admins
443     // ------------------------------------------------------------------------
444     function setAddressKYC(address depositer, bool isAllowed) public onlyOwnerOrOwnerAPI returns (bool) {
445         kycAddressState[depositer] = isAllowed;
446         //emit KYCStateUpdate(depositer, isAllowed);
447         return true;
448     }
449     
450     // ------------------------------------------------------------------------
451     // Get an addresses KYC state
452     // ------------------------------------------------------------------------
453     function getAddressKYCState(address depositer) public view returns (bool) {
454         return kycAddressState[depositer];
455     }
456     
457     // ------------------------------------------------------------------------
458     // Token name, as seen by the network
459     // ------------------------------------------------------------------------
460     function name() public view returns (string) {
461         return name;
462     }
463     
464     // ------------------------------------------------------------------------
465     // Token symbol, as seen by the network
466     // ------------------------------------------------------------------------
467     function symbol() public view returns (string) {
468         return symbol;
469     }
470     
471     // ------------------------------------------------------------------------
472     // Token decimals
473     // ------------------------------------------------------------------------
474     function decimals() public view returns (uint8) {
475         return decimals;
476     }
477 
478     // ------------------------------------------------------------------------
479     // Total supply
480     // ------------------------------------------------------------------------
481     function totalSupply() public constant returns (uint) {
482         return _totalSupply  - balances[address(0)]; //address(0) represents burned tokens
483     }
484     
485     // ------------------------------------------------------------------------
486     // Circulating supply
487     // ------------------------------------------------------------------------
488     function circulatingSupply() public constant returns (uint) {
489         return _totalSupply - balances[address(0)] - balances[address(this)]; //address(0) represents burned tokens
490     }
491 
492     // ------------------------------------------------------------------------
493     // Get the token balance for account `tokenOwner`
494     // ------------------------------------------------------------------------
495     function balanceOf(address tokenOwner) public constant returns (uint balance) {
496         return balances[tokenOwner];
497     }
498     
499     // ------------------------------------------------------------------------
500     // Get the total ETH deposited by `depositer`
501     // ------------------------------------------------------------------------
502     function depositsOf(address depositer) public constant returns (uint balance) {
503         return ethDeposits[depositer];
504     }
505     
506     // ------------------------------------------------------------------------
507     // Get the total KAAS burned by `exOwner`
508     // ------------------------------------------------------------------------
509     function burnedBalanceOf(address exOwner) public constant returns (uint balance) {
510         return burnedBalances[exOwner];
511     }
512 
513     // ------------------------------------------------------------------------
514     // Transfer the balance from token owner's account to `to` account
515     // - Owner's account must have sufficient balance to transfer
516     // - 0 value transfers are allowed
517     //  !! fund source is the address calling this function !!
518     // ------------------------------------------------------------------------
519     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
520         if(now > endDate && isMintingFinished == false) {
521             finishMinting();
522         }
523         require(now >= tradingDate || kycAddressState[to] == true || msg.sender == addrMarketing); //allow internal transfers before tradingDate
524         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
525         balances[to] = safeAdd(balances[to], tokens);
526         emit Transfer(msg.sender, to, tokens);
527         return true;
528     }
529 
530     // ------------------------------------------------------------------------
531     // Token owner can approve for `destination` to transferFrom(...) `tokens`
532     // from the token owner's account
533     //
534     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
535     // recommends that there are no checks for the approval double-spend attack
536     // as this should be implemented in user interfaces
537     
538     // !!! When called, the amount of tokens DESTINATION can retrieve from MSG.SENDER is set to AMOUNT
539     // !!! This is used when another account C calls and pays gas for the transfer between A and B, like bank cheques
540     // !!! meaning: Allow DESTINATION to transfer a total AMOUNT from ME=callerOfThisFunction, from this point on, ignoring previous allows
541     
542     // ------------------------------------------------------------------------
543     function approve(address destination, uint amount) public returns (bool success) {
544         allowed[msg.sender][destination] = amount;
545         emit Approval(msg.sender, destination, amount);
546         return true;
547     }
548 
549     // ------------------------------------------------------------------------
550     // Transfer `tokens` from the `from` account to the `to` account
551     //
552     // The calling account must already have sufficient tokens approve(...)-d
553     // for spending from the `from` account and
554     // - From account must have sufficient balance to transfer
555     // - Spender must have sufficient allowance to transfer
556     // - 0 value transfers are allowed
557     // ------------------------------------------------------------------------
558     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
559         if(now > endDate && isMintingFinished == false) {
560             finishMinting();
561         }
562         require(now >= tradingDate || kycAddressState[to] == true); //allow internal transfers before tradingDate
563         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
564         balances[from] = safeSub(balances[from], tokens);
565         balances[to] = safeAdd(balances[to], tokens);
566         emit Transfer(from, to, tokens);
567         return true;
568     }
569 
570     // ------------------------------------------------------------------------
571     // Returns the amount of tokens approved by the owner that can be
572     // transferred to the requester's account
573     // ------------------------------------------------------------------------
574     function allowance(address tokenOwner, address requester) public constant returns (uint remaining) {
575         return allowed[tokenOwner][requester];
576     }
577 
578     // ------------------------------------------------------------------------
579     // Token owner can approve for `requester` to transferFrom(...) `tokens`
580     // from the token owner's account. The `requester` contract function
581     // `receiveApproval(...)` is then executed
582     // ------------------------------------------------------------------------
583     function approveAndCall(address requester, uint tokens, bytes data) public whenNotPaused returns (bool success) {
584         allowed[msg.sender][requester] = tokens;
585         emit Approval(msg.sender, requester, tokens);
586         ApproveAndCallFallBack(requester).receiveApproval(msg.sender, tokens, this, data);
587         return true;
588     }
589     
590     // ------------------------------------------------------------------------
591     // Owner can transfer out `tokens` amount of accidentally sent ERC20 tokens
592     // ------------------------------------------------------------------------
593     function transferAllERC20Token(address tokenAddress, uint tokens) public onlyOwnerOrOwnerAPI returns (bool success) {
594         return ERC20Interface(tokenAddress).transfer(owner, tokens);
595     }
596     
597     // ------------------------------------------------------------------------
598     // Owner can transfer out all accidentally sent ERC20 tokens
599     // ------------------------------------------------------------------------
600     function transferAnyERC20Token(address tokenAddress) public onlyOwnerOrOwnerAPI returns (bool success) {
601         return ERC20Interface(tokenAddress).transfer(owner, ERC20Interface(tokenAddress).balanceOf(this));
602     }
603     
604     // ------------------------------------------------------------------------
605     // Set the new ETH-EUR exchange rate, in cents
606     // ------------------------------------------------------------------------
607     function updateExchangeRate(uint newEthEurRate) public onlyOwnerOrOwnerAPI returns (bool success) {
608         exchangeRate = newEthEurRate;
609         return true;
610     }
611     
612     // ------------------------------------------------------------------------
613     // Get the current ETH-EUR exchange rate, in cents
614     // ------------------------------------------------------------------------
615     function getExchangeRate() public view returns (uint256 rate) {
616         return exchangeRate;
617     }
618     
619     // ------------------------------------------------------------------------
620     // Set the new EndDate
621     // ------------------------------------------------------------------------
622     function updateEndDate(uint256 newDate) public onlyOwnerOrOwnerAPI returns (bool success) {
623         require(!isMintingFinished);
624         require(!isOwnBlockchainLaunched);
625         
626         endDate = newDate;
627         
628         return true;
629     }
630     
631     // ------------------------------------------------------------------------
632     // Set the new Token name, Symbol, Contract address when updating
633     // ------------------------------------------------------------------------
634     function updateTokenNameSymbolAddress(string newTokenName, string newSymbol, address newContractAddress) public whenPaused onlyOwnerOrOwnerAPI returns (bool success) {
635         name = newTokenName;
636         symbol = newSymbol;
637         currentRunningAddress = newContractAddress;
638         
639         return true;
640     }
641     
642 }
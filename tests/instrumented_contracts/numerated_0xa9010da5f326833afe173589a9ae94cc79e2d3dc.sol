1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 //Bit Capital Vendor by BitCV Foundation.
5 // An ERC20 standard
6 //
7 // author: BitCV Foundation Team
8 
9 contract ERC20Interface {
10     function totalSupply() public constant returns (uint256 _totalSupply);
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract BCV is ERC20Interface {
21     uint256 public constant decimals = 8;
22 
23     string public constant symbol = "BCV";
24     string public constant name = "BitCapitalVendorToken";
25 
26     uint256 public _totalSupply = 120000000000000000; // total supply is 1.2 billion
27 
28     // Owner of this contract
29     address public owner;
30 
31     // Balances BCV for each account
32     mapping(address => uint256) private balances;
33 
34     // Owner of account approves the transfer of an amount to another account
35     mapping(address => mapping (address => uint256)) private allowed;
36 
37     // List of approved investors
38     mapping(address => bool) private approvedInvestorList;
39 
40     // deposit
41     mapping(address => uint256) private deposit;
42 
43 
44     // totalTokenSold
45     uint256 public totalTokenSold = 0;
46 
47 
48     /**
49      * @dev Fix for the ERC20 short address attack.
50      */
51     modifier onlyPayloadSize(uint size) {
52       if(msg.data.length < size + 4) {
53         revert();
54       }
55       _;
56     }
57 
58 
59 
60     /// @dev Constructor
61     function BCV()
62         public {
63         owner = msg.sender;
64         balances[owner] = _totalSupply;
65     }
66 
67     /// @dev Gets totalSupply
68     /// @return Total supply
69     function totalSupply()
70         public
71         constant
72         returns (uint256) {
73         return _totalSupply;
74     }
75 
76     /// @dev Gets account's balance
77     /// @param _addr Address of the account
78     /// @return Account balance
79     function balanceOf(address _addr)
80         public
81         constant
82         returns (uint256) {
83         return balances[_addr];
84     }
85 
86     /// @dev check address is approved investor
87     /// @param _addr address
88     function isApprovedInvestor(address _addr)
89         public
90         constant
91         returns (bool) {
92         return approvedInvestorList[_addr];
93     }
94 
95     /// @dev get ETH deposit
96     /// @param _addr address get deposit
97     /// @return amount deposit of an buyer
98     function getDeposit(address _addr)
99         public
100         constant
101         returns(uint256){
102         return deposit[_addr];
103     }
104 
105 
106     /// @dev Transfers the balance from msg.sender to an account
107     /// @param _to Recipient address
108     /// @param _amount Transfered amount in unit
109     /// @return Transfer status
110     function transfer(address _to, uint256 _amount)
111         public
112 
113         returns (bool) {
114         // if sender's balance has enough unit and amount >= 0,
115         //      and the sum is not overflow,
116         // then do transfer
117         if ( (balances[msg.sender] >= _amount) &&
118              (_amount >= 0) &&
119              (balances[_to] + _amount > balances[_to]) ) {
120 
121             balances[msg.sender] -= _amount;
122             balances[_to] += _amount;
123             Transfer(msg.sender, _to, _amount);
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     // Send _value amount of tokens from address _from to address _to
131     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
132     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
133     // fees in sub-currencies; the command should fail unless the _from account has
134     // deliberately authorized the sender of the message via some mechanism; we propose
135     // these standardized APIs for approval:
136     function transferFrom(
137         address _from,
138         address _to,
139         uint256 _amount
140     )
141     public
142 
143     returns (bool success) {
144         if (balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount) {
145             balances[_from] -= _amount;
146             allowed[_from][msg.sender] -= _amount;
147             balances[_to] += _amount;
148             Transfer(_from, _to, _amount);
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156     // If this function is called again it overwrites the current allowance with _value.
157     function approve(address _spender, uint256 _amount)
158         public
159 
160         returns (bool success) {
161         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
162         allowed[msg.sender][_spender] = _amount;
163         Approval(msg.sender, _spender, _amount);
164         return true;
165     }
166 
167     // get allowance
168     function allowance(address _owner, address _spender)
169         public
170         constant
171         returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     function () public payable{
176         revert();
177     }
178 
179 }
180 
181 /**
182  * SafeMath
183  * Math operations with safety checks that throw on error
184  */
185 library SafeMath {
186 
187   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188     if (a == 0) {
189       return 0;
190     }
191     uint256 c = a * b;
192     assert(c / a == b);
193     return c;
194   }
195 
196   function div(uint256 a, uint256 b) internal pure returns (uint256) {
197     // assert(b > 0); // Solidity automatically throws when dividing by 0
198     uint256 c = a / b;
199     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200     return c;
201   }
202 
203   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204     assert(b <= a);
205     return a - b;
206   }
207 
208   function add(uint256 a, uint256 b) internal pure returns (uint256) {
209     uint256 c = a + b;
210     assert(c >= a);
211     return c;
212   }
213 }
214 
215 /**
216  * The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224   function Ownable() public {
225     owner = msg.sender;
226   }
227 
228   /**
229    * Throws if called by any account other than the owner.
230    */
231   modifier onlyOwner() {
232     require(msg.sender == owner);
233     _;
234   }
235 
236   /**
237    * Allows the current owner to transfer control of the contract to a newOwner.
238    * @param newOwner The address to transfer ownership to.
239    */
240   function transferOwnership(address newOwner) public onlyOwner {
241     require(newOwner != address(0));
242     OwnershipTransferred(owner, newOwner);
243     owner = newOwner;
244   }
245 
246 }
247 
248 contract BCVTokenVault is Ownable {
249     using SafeMath for uint256;
250 
251     // team 2.4 * 10 ** 8, 3% every month after 2019-3-9
252     address public teamReserveWallet = 0x7e5C65b899Fb7Cd0c959e5534489B454B7c6c3dF;
253     // life 1.2 * 10 ** 8, 20% every month after 2018-6-1
254     address public lifeReserveWallet = 0xaed0363f76e4b906ef818b0f3199c580b5b01a43;
255     // finance 1.2 * 10 ** 8, 20% every month after 2018-6-1
256     address public finanReserveWallet = 0xd60A1D84835006499d5E6376Eb7CB9725643E25F;
257     // economic system 1.2 * 10 ** 8, 1200000 every month in first 6 years, left for last 14 years, release after 2018-6-1
258     address public econReserveWallet = 0x0C6e75e481cC6Ba8e32d6eF742768fc2273b1Bf0;
259     // chain development 1.2 * 10 ** 8, release all after 2018-9-30
260     address public developReserveWallet = 0x11aC32f89e874488890E5444723A644248609C0b;
261 
262     // Token Allocations
263     uint256 public teamReserveAllocation = 2.4 * (10 ** 8) * (10 ** 8);
264     uint256 public lifeReserveAllocation = 1.2 * (10 ** 8) * (10 ** 8);
265     uint256 public finanReserveAllocation = 1.2 * (10 ** 8) * (10 ** 8);
266     uint256 public econReserveAllocation = 1.2 * (10 ** 8) * (10 ** 8);
267     uint256 public developReserveAllocation = 1.2 * (10 ** 8) * (10 ** 8);
268 
269     // Total Token Allocations
270     uint256 public totalAllocation = 7.2 * (10 ** 8) * (10 ** 8);
271 
272     uint256 public teamReserveTimeLock = 1552060800; // 2019-3-9
273     uint256 public lifeReserveTimeLock = 1527782400;  // 2018-6-1
274     uint256 public finanReserveTimeLock = 1527782400;  // 2018-6-1
275     uint256 public econReserveTimeLock = 1527782400;  // 2018-6-1
276     uint256 public developReserveTimeLock = 1538236800;  // 2018-9-30
277 
278     uint256 public teamVestingStages = 34;   // 3% each month; total 34 stages.
279     uint256 public lifeVestingStages = 5;  // 20% each month; total 5 stages.
280     uint256 public finanVestingStages = 5;  // 20% each month; total 5 stages.
281     uint256 public econVestingStages = 240;  // 1200000 each month for first six years and 200000 each month for next forteen years; total 240 stages.
282 
283     mapping(address => uint256) public allocations;
284     mapping(address => uint256) public timeLocks;
285     mapping(address => uint256) public claimed;
286     uint256 public lockedAt = 0;
287 
288     BCV public token;
289 
290     event Allocated(address wallet, uint256 value);
291     event Distributed(address wallet, uint256 value);
292     event Locked(uint256 lockTime);
293 
294     // Any of the five reserve wallets
295     modifier onlyReserveWallets {
296         require(allocations[msg.sender] > 0);
297         _;
298     }
299 
300     // Team reserve wallet
301     modifier onlyTeamReserve {
302         require(msg.sender == teamReserveWallet);
303         require(allocations[msg.sender] > 0);
304         require(allocations[msg.sender] > claimed[msg.sender]);
305         _;
306     }
307 
308     // Life token reserve wallet
309     modifier onlyTokenReserveLife {
310         require(msg.sender == lifeReserveWallet);
311         require(allocations[msg.sender] > 0);
312         require(allocations[msg.sender] > claimed[msg.sender]);
313         _;
314     }
315 
316     // Finance token reserve wallet
317     modifier onlyTokenReserveFinance {
318         require(msg.sender == finanReserveWallet);
319         require(allocations[msg.sender] > 0);
320         require(allocations[msg.sender] > claimed[msg.sender]);
321         _;
322     }
323 
324     // Economic token reserve wallet
325     modifier onlyTokenReserveEcon {
326         require(msg.sender == econReserveWallet);
327         require(allocations[msg.sender] > 0);
328         require(allocations[msg.sender] > claimed[msg.sender]);
329         _;
330     }
331 
332     // Develop token reserve wallet
333     modifier onlyTokenReserveDevelop {
334         require(msg.sender == developReserveWallet);
335         require(allocations[msg.sender] > 0);
336         require(allocations[msg.sender] > claimed[msg.sender]);
337         _;
338     }
339 
340     // Has not been locked yet
341     modifier notLocked {
342         require(lockedAt == 0);
343         _;
344     }
345 
346     // Already locked
347     modifier locked {
348         require(lockedAt > 0);
349         _;
350     }
351 
352     // Token allocations have not been set
353     modifier notAllocated {
354         require(allocations[teamReserveWallet] == 0);
355         require(allocations[lifeReserveWallet] == 0);
356         require(allocations[finanReserveWallet] == 0);
357         require(allocations[econReserveWallet] == 0);
358         require(allocations[developReserveWallet] == 0);
359         _;
360     }
361 
362     function BCVTokenVault(ERC20Interface _token) public {
363         owner = msg.sender;
364         token = BCV(_token);
365     }
366 
367     function allocate() public notLocked notAllocated onlyOwner {
368 
369         // Makes sure Token Contract has the exact number of tokens
370         require(token.balanceOf(address(this)) == totalAllocation);
371 
372         allocations[teamReserveWallet] = teamReserveAllocation;
373         allocations[lifeReserveWallet] = lifeReserveAllocation;
374         allocations[finanReserveWallet] = finanReserveAllocation;
375         allocations[econReserveWallet] = econReserveAllocation;
376         allocations[developReserveWallet] = developReserveAllocation;
377 
378         Allocated(teamReserveWallet, teamReserveAllocation);
379         Allocated(lifeReserveWallet, lifeReserveAllocation);
380         Allocated(finanReserveWallet, finanReserveAllocation);
381         Allocated(econReserveWallet, econReserveAllocation);
382         Allocated(developReserveWallet, developReserveAllocation);
383 
384         lock();
385     }
386 
387     // Lock the vault for the wallets
388     function lock() internal notLocked onlyOwner {
389 
390         lockedAt = block.timestamp;
391 
392         timeLocks[teamReserveWallet] = teamReserveTimeLock;
393         timeLocks[lifeReserveWallet] = lifeReserveTimeLock;
394         timeLocks[finanReserveWallet] = finanReserveTimeLock;
395         timeLocks[econReserveWallet] = econReserveTimeLock;
396         timeLocks[developReserveWallet] = developReserveTimeLock;
397 
398         Locked(lockedAt);
399     }
400 
401     // Recover Tokens in case incorrect amount was sent to contract.
402     function recoverFailedLock() external notLocked notAllocated onlyOwner {
403 
404         // Transfer all tokens on this contract back to the owner
405         require(token.transfer(owner, token.balanceOf(address(this))));
406     }
407 
408     // Total number of tokens currently in the vault
409     function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {
410         return token.balanceOf(address(this));
411     }
412 
413     // Number of tokens that are still locked
414     function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {
415         return allocations[msg.sender].sub(claimed[msg.sender]);
416     }
417 
418 
419     // Claim tokens for team reserve wallet
420     function claimTeamReserve() onlyTeamReserve locked public {
421 
422         address reserveWallet = msg.sender;
423         // Can't claim before Lock ends
424         require(block.timestamp > timeLocks[reserveWallet]);
425 
426         uint256 vestingStage = teamVestingStage();
427 
428         // Amount of tokens the team should have at this vesting stage
429         uint256 totalUnlocked = vestingStage.mul(7.2 * (10 ** 6) * (10 ** 8));
430 
431         // For the last vesting stage, we will release all tokens
432         if (vestingStage == 34) {
433           totalUnlocked = allocations[teamReserveWallet];
434         }
435 
436         // Total unlocked token must be smaller or equal to total locked token
437         require(totalUnlocked <= allocations[teamReserveWallet]);
438 
439         // Previously claimed tokens must be less than what is unlocked
440         require(claimed[teamReserveWallet] < totalUnlocked);
441 
442         // Number of tokens we can get
443         uint256 payment = totalUnlocked.sub(claimed[teamReserveWallet]);
444 
445         // Update the claimed tokens in team wallet
446         claimed[teamReserveWallet] = totalUnlocked;
447 
448         // Transfer to team wallet address
449         require(token.transfer(teamReserveWallet, payment));
450 
451         Distributed(teamReserveWallet, payment);
452     }
453 
454     //Current Vesting stage for team
455     function teamVestingStage() public view onlyTeamReserve returns(uint256) {
456 
457         uint256 nowTime = block.timestamp;
458         // Number of months past our unlock time, which is the stage
459         uint256 stage = (nowTime.sub(teamReserveTimeLock)).div(2592000);
460 
461         // Ensures team vesting stage doesn't go past teamVestingStages
462         if(stage > teamVestingStages) {
463             stage = teamVestingStages;
464         }
465         return stage;
466 
467     }
468 
469     // Claim tokens for life reserve wallet
470     function claimTokenReserveLife() onlyTokenReserveLife locked public {
471 
472         address reserveWallet = msg.sender;
473 
474         // Can't claim before Lock ends
475         require(block.timestamp > timeLocks[reserveWallet]);
476 
477         // The vesting stage of life wallet
478         uint256 vestingStage = lifeVestingStage();
479 
480         // Amount of tokens the life wallet should have at this vesting stage
481         uint256 totalUnlocked = vestingStage.mul(2.4 * (10 ** 7) * (10 ** 8));
482 
483         // Total unlocked token must be smaller or equal to total locked token
484         require(totalUnlocked <= allocations[lifeReserveWallet]);
485 
486         // Previously claimed tokens must be less than what is unlocked
487         require(claimed[lifeReserveWallet] < totalUnlocked);
488 
489         // Number of tokens we can get
490         uint256 payment = totalUnlocked.sub(claimed[lifeReserveWallet]);
491 
492         // Update the claimed tokens in finance wallet
493         claimed[lifeReserveWallet] = totalUnlocked;
494 
495         // Transfer to life wallet address
496         require(token.transfer(reserveWallet, payment));
497 
498         Distributed(reserveWallet, payment);
499     }
500 
501     // Current Vesting stage for life wallet
502     function lifeVestingStage() public view onlyTokenReserveLife returns(uint256) {
503 
504         uint256 nowTime = block.timestamp;
505         // Number of months past our unlock time, which is the stage
506         uint256 stage = (nowTime.sub(lifeReserveTimeLock)).div(2592000);
507 
508         // Ensures life wallet vesting stage doesn't go past lifeVestingStages
509         if(stage > lifeVestingStages) {
510             stage = lifeVestingStages;
511         }
512 
513         return stage;
514     }
515 
516     // Claim tokens for finance reserve wallet
517     function claimTokenReserveFinan() onlyTokenReserveFinance locked public {
518 
519         address reserveWallet = msg.sender;
520 
521         // Can't claim before Lock ends
522         require(block.timestamp > timeLocks[reserveWallet]);
523 
524         // The vesting stage of finance wallet
525         uint256 vestingStage = finanVestingStage();
526 
527         // Amount of tokens the finance wallet should have at this vesting stage
528         uint256 totalUnlocked = vestingStage.mul(2.4 * (10 ** 7) * (10 ** 8));
529 
530         // Total unlocked token must be smaller or equal to total locked token
531         require(totalUnlocked <= allocations[finanReserveWallet]);
532 
533         // Previously claimed tokens must be less than what is unlocked
534         require(claimed[finanReserveWallet] < totalUnlocked);
535 
536         // Number of tokens we can get
537         uint256 payment = totalUnlocked.sub(claimed[finanReserveWallet]);
538 
539         // Update the claimed tokens in finance wallet
540         claimed[finanReserveWallet] = totalUnlocked;
541 
542         // Transfer to finance wallet address
543         require(token.transfer(reserveWallet, payment));
544 
545         Distributed(reserveWallet, payment);
546     }
547 
548     // Current Vesting stage for finance wallet
549     function finanVestingStage() public view onlyTokenReserveFinance returns(uint256) {
550 
551         uint256 nowTime = block.timestamp;
552 
553         // Number of months past our unlock time, which is the stage
554         uint256 stage = (nowTime.sub(finanReserveTimeLock)).div(2592000);
555 
556         // Ensures finance wallet vesting stage doesn't go past finanVestingStages
557         if(stage > finanVestingStages) {
558             stage = finanVestingStages;
559         }
560 
561         return stage;
562 
563     }
564 
565     // Claim tokens for economic reserve wallet
566     function claimTokenReserveEcon() onlyTokenReserveEcon locked public {
567 
568         address reserveWallet = msg.sender;
569 
570         // Can't claim before Lock ends
571         require(block.timestamp > timeLocks[reserveWallet]);
572 
573         uint256 vestingStage = econVestingStage();
574 
575         // Amount of tokens the economic wallet should have at this vesting stage
576         uint256 totalUnlocked;
577 
578         // For first 6 years stages
579         if (vestingStage <= 72) {
580           totalUnlocked = vestingStage.mul(1200000 * (10 ** 8));
581         } else {        // For the next 14 years stages
582           totalUnlocked = ((vestingStage.sub(72)).mul(200000 * (10 ** 8))).add(86400000 * (10 ** 8));
583         }
584 
585         // Total unlocked token must be smaller or equal to total locked token
586         require(totalUnlocked <= allocations[econReserveWallet]);
587 
588         // Previously claimed tokens must be less than what is unlocked
589         require(claimed[econReserveWallet] < totalUnlocked);
590 
591         // Number of tokens we can get
592         uint256 payment = totalUnlocked.sub(claimed[econReserveWallet]);
593 
594         // Update the claimed tokens in economic wallet
595         claimed[econReserveWallet] = totalUnlocked;
596 
597         // Transfer to economic wallet address
598         require(token.transfer(reserveWallet, payment));
599 
600         Distributed(reserveWallet, payment);
601     }
602 
603     // Current Vesting stage for economic wallet
604     function econVestingStage() public view onlyTokenReserveEcon returns(uint256) {
605 
606         uint256 nowTime = block.timestamp;
607 
608         // Number of months past our unlock time, which is the stage
609         uint256 stage = (nowTime.sub(timeLocks[econReserveWallet])).div(2592000);
610 
611         // Ensures economic wallet vesting stage doesn't go past econVestingStages
612         if(stage > econVestingStages) {
613             stage = econVestingStages;
614         }
615 
616         return stage;
617 
618     }
619 
620     // Claim tokens for development reserve wallet
621     function claimTokenReserveDevelop() onlyTokenReserveDevelop locked public {
622 
623       address reserveWallet = msg.sender;
624 
625       // Can't claim before Lock ends
626       require(block.timestamp > timeLocks[reserveWallet]);
627 
628       // Must Only claim once
629       require(claimed[reserveWallet] == 0);
630 
631       // Number of tokens we can get, which is all tokens in developReserveWallet
632       uint256 payment = allocations[reserveWallet];
633 
634       // Update the claimed tokens in development wallet
635       claimed[reserveWallet] = payment;
636 
637       // Transfer to development wallet address
638       require(token.transfer(reserveWallet, payment));
639 
640       Distributed(reserveWallet, payment);
641     }
642 
643 
644     // Checks if msg.sender can collect tokens
645     function canCollect() public view onlyReserveWallets returns(bool) {
646 
647         return block.timestamp > timeLocks[msg.sender] && claimed[msg.sender] == 0;
648 
649     }
650 
651 }
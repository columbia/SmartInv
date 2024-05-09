1 pragma solidity ^0.4.13;
2 
3 contract AllocationAddressList {
4 
5   address[] public allocationAddressList;
6 }
7 
8 contract ERC223ReceivingContract {
9   // AUDIT[CHF-08] The name of the token transfer "fallback" function.
10   //
11   // There were suggestions to change the "stanard" fallback function name
12   // to "onTokenReceived", see
13   // https://github.com/ethereum/EIPs/issues/223#issuecomment-327709226
14   // See also https://github.com/ethereum/EIPs/issues/777.
15   function tokenFallback(address _from, uint256 _value, bytes _data) public;
16 }
17 
18 contract ERC223Token {
19   using SafeMath for uint256;
20 
21   // token constants
22   string public name;
23   bytes32 public symbol;
24   uint8 public decimals;
25   uint256 public totalSupply;
26 
27   // token balances
28   mapping(address => uint256) public balanceOf;
29 
30   // Function that is called when a user or another contract wants to transfer funds .
31   function transfer(address to, uint256 value, bytes data) public returns (bool) {
32     // Standard function transfer similar to ERC20 transfer with no _data .
33     // Added due to backwards compatibility reasons .
34     uint256 codeLength;
35 
36     assembly {
37       // Retrieve the size of the code on target address, this needs assembly .
38       codeLength := extcodesize(to)
39     }
40 
41     balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
42     balanceOf[to] = balanceOf[to].add(value);
43     if (codeLength > 0) {
44       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
45       receiver.tokenFallback(msg.sender, value, data);
46     }
47     Transfer(msg.sender, to, value, data);
48     return true;
49   }
50 
51   // Standard function transfer similar to ERC20 transfer with no _data .
52   // Added due to backwards compatibility reasons .
53   function transfer(address to, uint256 value) public returns (bool) {
54     uint256 codeLength;
55     bytes memory empty;
56 
57     assembly {
58       // Retrieve the size of the code on target address, this needs assembly .
59       codeLength := extcodesize(to)
60     }
61 
62     balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
63     balanceOf[to] = balanceOf[to].add(value);
64     if (codeLength > 0) {
65       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
66       receiver.tokenFallback(msg.sender, value, empty);
67     }
68     Transfer(msg.sender, to, value, empty);
69     // ERC20 compatible event:
70     Transfer(msg.sender, to, value);
71     return true;
72   }
73 
74   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract ERC223MintableToken is ERC223Token {
79   using SafeMath for uint256;
80   uint256 public circulatingSupply;
81   function mint(address to, uint256 value) internal returns (bool) {
82     uint256 codeLength;
83 
84     assembly {
85       // Retrieve the size of the code on target address, this needs assembly .
86       codeLength := extcodesize(to)
87     }
88 
89     circulatingSupply += value;
90 
91     balanceOf[to] = balanceOf[to].add(value);
92     if (codeLength > 0) {
93       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
94       bytes memory empty;
95       receiver.tokenFallback(msg.sender, value, empty);
96     }
97     Mint(to, value);
98     return true;
99   }
100 
101   event Mint(address indexed to, uint256 value);
102 }
103 
104 contract TestToken is ERC223MintableToken {
105   mapping (address => bool) public IS_SIGNATURER;
106 
107   VestingAllocation private partnerTokensAllocation;
108   VestingAllocation private companyTokensAllocation;
109   BountyTokenAllocation private bountyTokensAllocation;
110 
111   /*
112    * ICO TOKENS
113    * 33%
114    *
115    * Ico tokens are sent to the ICO_TOKEN_ADDRESS immediately
116    * after TestToken initialization
117    */ 
118   uint256 constant ICO_TOKENS = 25346500000000000000000000;
119   address constant ICO_TOKENS_ADDRESS = 0xCE1182147FD13A59E4Ca114CAa1cD58719e09F67;
120   // AUDIT[CHF-02] Document "seed" tokens.
121   uint256 constant SEED_TOKENS = 25346500000000000000000000;
122   address constant SEED_TOKENS_ADDRESS = 0x8746177Ff2575E826f6f73A1f90351e0FD0A6649;
123 
124   /*
125    * COMPANY TOKENS
126    * 33%
127    *
128    * Company tokens are being distrubited in 36 months
129    * Total tokens = COMPANY_TOKENS_PER_PERIOD * COMPANY_PERIODS
130    */
131   uint256 constant COMPANY_TOKENS_PER_PERIOD = 704069444444444000000000;
132   uint256 constant COMPANY_PERIODS = 36;
133   uint256 constant MINUTES_IN_COMPANY_PERIOD = 10; //1 years / 12 / 1 minutes;
134 
135   /*
136    * PARTNER TOKENS
137    * 30%
138    *
139    * Company tokens are avaialable after 18 months
140    * Total tokens = PARTNER_TOKENS_PER_PERIOD * PARTNER_PERIODS
141    */
142   uint256 constant PARTNER_TOKENS_PER_PERIOD = 23042272727272700000000000;
143   uint256 constant PARTNER_PERIODS = 1;
144   uint256 constant MINUTES_IN_PARTNER_PERIOD = 60 * 2; //MINUTES_IN_COMPANY_PERIOD * 18;
145 
146   /*
147    * BOUNTY TOKENS
148    * 30%
149    *
150    * Bounty tokens can be sent immediately after initialization
151    */
152   uint256 constant BOUNTY_TOKENS = 2304227272727270000000000;
153 
154   /*
155    * MARKETING COST TOKENS
156    * 1%
157    *
158    * Tokens are sent to the MARKETING_COST_ADDRESS immediately
159    * after TestToken initialization
160    */
161   uint256 constant MARKETING_COST_TOKENS = 768075757575758000000000;
162   address constant MARKETING_COST_ADDRESS = 0x54a0AB12710fad2a24CB391406c234855C835340;
163 
164   uint256 public INIT_DATE;
165 
166   string public constant name = "Test Token";
167   bytes32 public constant symbol = "TST";
168   uint8 public constant decimals = 18;
169   uint256 public constant totalSupply = (
170     COMPANY_TOKENS_PER_PERIOD * COMPANY_PERIODS +
171     PARTNER_TOKENS_PER_PERIOD * PARTNER_PERIODS +
172     BOUNTY_TOKENS + MARKETING_COST_TOKENS +
173     ICO_TOKENS + SEED_TOKENS);
174 
175   /**
176    * TestToken contructor.
177    *
178    * Exy token contains allocations of:
179    * - partnerTokensAllocation
180    * - companyTokensAllocation
181    * - bountyTokensAllocation
182    *
183    * param signaturer0 Address of first signaturer.
184    * param signaturer1 Address of second signaturer.
185    * param signaturer2 Address of third signaturer.
186    *
187    * Arguments in constructor are only for testing. When deploying
188    * on main net, please hardcode them inside:
189    * address signaturer0 = 0x0;
190    * address signaturer1 = 0x1;
191    * address signaturer2 = 0x2;
192    */
193   function TestToken() public {
194     address signaturer0 = 0xe029b7b51b8c5B71E6C6f3DC66a11DF3CaB6E3B5;
195     address signaturer1 = 0xBEE9b5e75383f56eb103DdC1a4343dcA6124Dfa3;
196     address signaturer2 = 0xcdD1Db16E83AA757a5B3E6d03482bBC9A27e8D49;
197     IS_SIGNATURER[signaturer0] = true;
198     IS_SIGNATURER[signaturer1] = true;
199     IS_SIGNATURER[signaturer2] = true;
200     INIT_DATE = block.timestamp;
201 
202     // AUDIT[CHF-06] Inherit instead of compose.
203     //
204     // I don't see a point of creating "Signatures" as a separate contract.
205     // Just embed it here.
206     // Also, move "onlySignaturer" to Signatures contract
207     companyTokensAllocation = new VestingAllocation(
208       COMPANY_TOKENS_PER_PERIOD,
209       COMPANY_PERIODS,
210       MINUTES_IN_COMPANY_PERIOD,
211       INIT_DATE);
212 
213     partnerTokensAllocation = new VestingAllocation(
214       PARTNER_TOKENS_PER_PERIOD,
215       PARTNER_PERIODS,
216       MINUTES_IN_PARTNER_PERIOD,
217       INIT_DATE);
218 
219     bountyTokensAllocation = new BountyTokenAllocation(
220       BOUNTY_TOKENS
221     );
222 
223     // minting marketing cost tokens
224     mint(MARKETING_COST_ADDRESS, MARKETING_COST_TOKENS);
225 
226     // minting ICO tokens
227     mint(ICO_TOKENS_ADDRESS, ICO_TOKENS);
228     // minting SEED tokens
229     mint(SEED_TOKENS_ADDRESS, SEED_TOKENS);
230   }
231 
232   /**
233    * Adds a proposition of a company token split to companyTokensAllocation
234    */
235   function proposeCompanyAllocation(address _dest, uint256 _tokensPerPeriod) public onlySignaturer {
236     companyTokensAllocation.proposeAllocation(msg.sender, _dest, _tokensPerPeriod);
237   }
238 
239   /**
240    * Approves a proposition of a company token split
241    */
242   function approveCompanyAllocation(address _dest) public onlySignaturer {
243     companyTokensAllocation.approveAllocation(msg.sender, _dest);
244   }
245 
246   /**
247    * Rejects a proposition of a company token split.
248    * it can reject only not approved method
249    */
250   function rejectCompanyAllocation(address _dest) public onlySignaturer {
251     companyTokensAllocation.rejectAllocation(_dest);
252   }
253 
254   /**
255    * Return number of remaining company tokens allocations
256    * @return Length of company allocations per period
257    */
258   function getRemainingCompanyTokensAllocation() public view returns (uint256) {
259     return companyTokensAllocation.remainingTokensPerPeriod();
260   }
261 
262   /**
263    * Given the index of the company allocation in allocationAddressList
264    * we find its reciepent address and return struct with informations
265    * about this allocation
266    *
267    * @param nr Index of allocation in allocationAddressList
268    * @return Information about company alloction
269    */
270   function getCompanyAllocation(uint256 nr) public view returns (uint256, address, uint256, Types.AllocationState, address) {
271     address recipientAddress = companyTokensAllocation.allocationAddressList(nr);
272     var (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState) = companyTokensAllocation.allocationOf(recipientAddress);
273     return (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState, recipientAddress);
274   }
275 
276   /**
277    * Adds a proposition of a partner token split to companyTokensAllocation
278    */
279   function proposePartnerAllocation(address _dest, uint256 _tokensPerPeriod) public onlySignaturer {
280     partnerTokensAllocation.proposeAllocation(msg.sender, _dest, _tokensPerPeriod);
281   }
282 
283   /**
284    * Approves a proposition of a partner token split
285    */
286   function approvePartnerAllocation(address _dest) public onlySignaturer {
287     partnerTokensAllocation.approveAllocation(msg.sender, _dest);
288   }
289 
290   /**
291    * Rejects a proposition of a partner token split.
292    * it can reject only not approved method
293    */
294   function rejectPartnerAllocation(address _dest) public onlySignaturer {
295     partnerTokensAllocation.rejectAllocation(_dest);
296   }
297 
298   /**
299    * Return number of remaining partner tokens allocations
300    * @return Length of partner allocations per period
301    */
302   function getRemainingPartnerTokensAllocation() public view returns (uint256) {
303     return partnerTokensAllocation.remainingTokensPerPeriod();
304   }
305 
306   /**
307    * Given the index of the partner allocation in allocationAddressList
308    * we find its reciepent address and return struct with informations
309    * about this allocation
310    *
311    * @param nr Index of allocation in allocationAddressList
312    * @return Information about partner alloction
313    */
314   function getPartnerAllocation(uint256 nr) public view returns (uint256, address, uint256, Types.AllocationState, address) {
315     address recipientAddress = partnerTokensAllocation.allocationAddressList(nr);
316     var (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState) = partnerTokensAllocation.allocationOf(recipientAddress);
317     return (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState, recipientAddress);
318   }
319 
320   function proposeBountyTransfer(address _dest, uint256 _amount) public onlySignaturer {
321     bountyTokensAllocation.proposeBountyTransfer(_dest, _amount);
322   }
323 
324   /**
325    * Approves a bounty transfer and mint tokens
326    *
327    * @param _dest Address of the bounty reciepent to whom we should mint token
328    */
329   function approveBountyTransfer(address _dest) public onlySignaturer {
330     uint256 tokensToMint = bountyTokensAllocation.approveBountyTransfer(msg.sender, _dest);
331     mint(_dest, tokensToMint);
332   }
333 
334   /**
335    * Rejects a proposition of a bounty token.
336    * it can reject only not approved method
337    */
338   function rejectBountyTransfer(address _dest) public onlySignaturer {
339     bountyTokensAllocation.rejectBountyTransfer(_dest);
340   }
341 
342   function getBountyTransfers(uint256 nr) public view returns (uint256, address, Types.BountyState, address) {
343     address recipientAddress = bountyTokensAllocation.allocationAddressList(nr);
344     var (amount, proposalAddress, bountyState) = bountyTokensAllocation.bountyOf(recipientAddress);
345     return (amount, proposalAddress, bountyState, recipientAddress);
346   }
347 
348   /**
349    * Return number of remaining bounty tokens allocations
350    * @return Length of company allocations
351    */
352   function getRemainingBountyTokens() public view returns (uint256) {
353     return bountyTokensAllocation.remainingBountyTokens();
354   }
355 
356   function claimTokens() public returns (uint256) {
357     mint(msg.sender,
358       partnerTokensAllocation.claimTokens(msg.sender) +
359       companyTokensAllocation.claimTokens(msg.sender));
360   }
361   modifier onlySignaturer() {
362     require(IS_SIGNATURER[msg.sender]);
363     _;
364   }
365 
366 }
367 
368 contract Ownable {
369   address public owner;
370   /**
371    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
372    * account.
373    */
374   function Ownable() public {
375     owner = msg.sender;
376   }
377 
378   /**
379    * @dev Throws if called by any account other than the owner.
380    */
381   modifier onlyOwner() {
382     require(msg.sender == owner);
383     _;
384   }
385 
386 }
387 
388 contract BountyTokenAllocation is Ownable, AllocationAddressList {
389 
390   // This contract describes how the bounty tokens are allocated.
391   // After a bounty allocation was proposed by a signaturer, another
392   // signaturer must accept this allocation.
393 
394   // Total amount of remaining tokens to be distributed
395   uint256 public remainingBountyTokens;
396 
397   // Possible split states: Proposed, Approved, Rejected
398   // Proposed is the initial state.
399   // Both Approved and Rejected are final states.
400   // The only possible transitions are:
401   // Proposed => Approved
402   // Proposed => Rejected
403 
404   // keep map here of bounty proposals
405   mapping (address => Types.StructBountyAllocation) public bountyOf;
406 
407   address public owner = msg.sender;
408 
409   /**
410    * Bounty token allocation constructor.
411    *
412    * @param _remainingBountyTokens Total number of bounty tokens that will be
413    *                               allocated.
414    */
415   function BountyTokenAllocation(uint256 _remainingBountyTokens) onlyOwner public {
416     remainingBountyTokens = _remainingBountyTokens;
417   }
418 
419   /**
420    * Propose a bounty transfer
421    *
422    * @param _dest Address of bounty reciepent
423    * @param _amount Amount of tokens he will receive
424    */
425   function proposeBountyTransfer(address _dest, uint256 _amount) public onlyOwner {
426     require(_amount > 0);
427     require(_amount <= remainingBountyTokens);
428      // we can't overwrite existing proposal
429      // but we can overwrite rejected proposal with new values
430     require(bountyOf[_dest].proposalAddress == 0x0 || bountyOf[_dest].bountyState == Types.BountyState.Rejected);
431 
432     if (bountyOf[_dest].bountyState != Types.BountyState.Rejected) {
433       allocationAddressList.push(_dest);
434     }
435 
436     bountyOf[_dest] = Types.StructBountyAllocation({
437       amount: _amount,
438       proposalAddress: msg.sender,
439       bountyState: Types.BountyState.Proposed
440     });
441 
442     remainingBountyTokens = remainingBountyTokens - _amount;
443   }
444 
445   /**
446    * Approves a bounty transfer
447    *
448    * @param _dest Address of bounty reciepent
449    * @return amount of tokens which we approved
450    */
451   function approveBountyTransfer(address _approverAddress, address _dest) public onlyOwner returns (uint256) {
452     require(bountyOf[_dest].bountyState == Types.BountyState.Proposed);
453     require(bountyOf[_dest].proposalAddress != _approverAddress);
454 
455     bountyOf[_dest].bountyState = Types.BountyState.Approved;
456     return bountyOf[_dest].amount;
457   }
458 
459   /**
460    * Rejects a bounty transfer
461    *
462    * @param _dest Address of bounty reciepent for whom we are rejecting bounty transfer
463    */
464   function rejectBountyTransfer(address _dest) public onlyOwner {
465     var tmp = bountyOf[_dest];
466     require(tmp.bountyState == Types.BountyState.Proposed);
467 
468     bountyOf[_dest].bountyState = Types.BountyState.Rejected;
469     remainingBountyTokens = remainingBountyTokens + bountyOf[_dest].amount;
470   }
471 
472 }
473 
474 library SafeMath {
475   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
476     assert(b <= a);
477     return a - b;
478   }
479 
480   function add(uint256 a, uint256 b) pure internal returns (uint256) {
481     uint256 c = a + b;
482     assert(c >= a);
483     return c;
484   }
485   function min(uint256 a, uint256 b) pure internal returns (uint256) {
486     if(a > b)
487       return b;
488     else
489       return a;
490   }
491 }
492 
493 contract Types {
494 
495   // Possible split states: Proposed, Approved, Rejected
496   // Proposed is the initial state.
497   // Both Approved and Rejected are final states.
498   // The only possible transitions are:
499   // Proposed => Approved
500   // Proposed => Rejected
501   enum AllocationState {
502     Proposed,
503     Approved,
504     Rejected
505   }
506 
507   // Structure used for storing company and partner allocations
508   struct StructVestingAllocation {
509     // How many tokens per period we want to pass
510     uint256 tokensPerPeriod;
511     // By whom was this split proposed. Another signaturer must approve too
512     address proposerAddress;
513     // How many times did we released tokens
514     uint256 claimedPeriods;
515     // State of actual split.
516     AllocationState allocationState;
517   }
518 
519    enum BountyState {
520     Proposed, // 0
521     Approved, // 1
522     Rejected  // 2
523   }
524 
525   struct StructBountyAllocation {
526     // How many tokens send him or her
527     uint256 amount;
528     // By whom was this allocation proposed
529     address proposalAddress;
530     // State of actual split.
531     BountyState bountyState;
532   }
533 }
534 
535 contract VestingAllocation is Ownable, AllocationAddressList {
536 
537   // This contract describes how the tokens are being released in time
538 
539   // How many distributions periods there are
540   uint256 public periods;
541   // How long is one interval
542   uint256 public minutesInPeriod;
543   // Total amount of remaining tokens to be distributed
544   uint256 public remainingTokensPerPeriod;
545   // Total amount of all tokens
546   uint256 public totalSupply;
547   // Inital timestamp
548   uint256 public initTimestamp;
549 
550   // For each address we can add exactly one possible split.
551   // If we try to add another proposal on existing address it will be rejected
552   mapping (address => Types.StructVestingAllocation) public allocationOf;
553 
554   /**
555    * VestingAllocation contructor.
556    * RemainingTokensPerPeriod variable which represents
557    * the remaining amount of tokens to be distributed
558    */
559   // Invoking parent constructor (OwnedBySignaturers) with signatures addresses
560   function VestingAllocation(uint256 _tokensPerPeriod, uint256 _periods, uint256 _minutesInPeriod, uint256 _initalTimestamp)  Ownable() public {
561     totalSupply = _tokensPerPeriod * _periods;
562     periods = _periods;
563     minutesInPeriod = _minutesInPeriod;
564     remainingTokensPerPeriod = _tokensPerPeriod;
565     initTimestamp = _initalTimestamp;
566   }
567 
568   /**
569    * Propose split method adds proposal to the splits Array.
570    *
571    * @param _dest              - address of the new receiver
572    * @param _tokensPerPeriod   - how many tokens we are giving to dest
573    */
574   function proposeAllocation(address _proposerAddress, address _dest, uint256 _tokensPerPeriod) public onlyOwner {
575     require(_tokensPerPeriod > 0);
576     require(_tokensPerPeriod <= remainingTokensPerPeriod);
577     // In solidity there is no "exist" method on a map key.
578     // We can't overwrite existing proposal, so we are checking if it is the default value (0x0)
579     // Add `allocationOf[_dest].allocationState == Types.AllocationState.Rejected` for possibility to overwrite rejected allocation
580     require(allocationOf[_dest].proposerAddress == 0x0 || allocationOf[_dest].allocationState == Types.AllocationState.Rejected);
581 
582     if (allocationOf[_dest].allocationState != Types.AllocationState.Rejected) {
583       allocationAddressList.push(_dest);
584     }
585 
586     allocationOf[_dest] = Types.StructVestingAllocation({
587       tokensPerPeriod: _tokensPerPeriod,
588       allocationState: Types.AllocationState.Proposed,
589       proposerAddress: _proposerAddress,
590       claimedPeriods: 0
591     });
592 
593     remainingTokensPerPeriod = remainingTokensPerPeriod - _tokensPerPeriod; // TODO safe-math
594   }
595 
596   /**
597    * Approves the split allocation, so it can be claimed after periods
598    *
599    * @param _address - address for the split
600    */
601   function approveAllocation(address _approverAddress, address _address) public onlyOwner {
602     require(allocationOf[_address].allocationState == Types.AllocationState.Proposed);
603     require(allocationOf[_address].proposerAddress != _approverAddress);
604     allocationOf[_address].allocationState = Types.AllocationState.Approved;
605   }
606 
607  /**
608    * Rejects the split allocation
609    *
610    * @param _address - address for the split to be rejected
611    */
612   function rejectAllocation(address _address) public onlyOwner {
613     var tmp = allocationOf[_address];
614     require(tmp.allocationState == Types.AllocationState.Proposed);
615     allocationOf[_address].allocationState = Types.AllocationState.Rejected;
616     remainingTokensPerPeriod = remainingTokensPerPeriod + tmp.tokensPerPeriod;
617   }
618 
619   function claimTokens(address _address) public returns (uint256) {
620     Types.StructVestingAllocation storage alloc = allocationOf[_address];
621     if (alloc.allocationState == Types.AllocationState.Approved) {
622       uint256 periodsElapsed = SafeMath.min((block.timestamp - initTimestamp) / (minutesInPeriod * 1 minutes), periods);
623       uint256 tokens = (periodsElapsed - alloc.claimedPeriods) * alloc.tokensPerPeriod;
624       alloc.claimedPeriods = periodsElapsed;
625       return tokens;
626     }
627     return 0;
628   }
629 
630 }
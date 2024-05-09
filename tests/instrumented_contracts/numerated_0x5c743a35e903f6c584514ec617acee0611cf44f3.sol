1 pragma solidity ^0.4.19;
2 
3 contract ERC223ReceivingContract {
4   function tokenFallback(address _from, uint256 _value, bytes _data) public;
5 }
6 
7 contract ERC223Token {
8   using SafeMath for uint256;
9 
10   // token constants
11   string public name;
12   bytes32 public symbol;
13   uint8 public decimals;
14   uint256 public totalSupply;
15 
16   // token balances
17   mapping(address => uint256) public balanceOf;
18   // token spending allowance, used by transferFrom(), for compliance with ERC20
19   mapping (address => mapping(address => uint256)) internal allowances;
20 
21   // Function that is called when a user or another contract wants to transfer funds.
22   function transfer(address to, uint256 value, bytes data) public returns (bool) {
23     require(balanceOf[msg.sender] >= value);
24     uint256 codeLength;
25 
26     assembly {
27       // Retrieve the size of the code on target address, this needs assembly .
28       codeLength := extcodesize(to)
29     }
30 
31     balanceOf[msg.sender] -= value;  // underflow checked by require() above
32     balanceOf[to] = balanceOf[to].add(value);
33     if (codeLength > 0) {
34       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
35       receiver.tokenFallback(msg.sender, value, data);
36     }
37     ERC223Transfer(msg.sender, to, value, data);
38     return true;
39   }
40 
41   // Standard function transfer similar to ERC20 transfer with no _data.
42   // Added due to backwards compatibility reasons.
43   function transfer(address to, uint256 value) public returns (bool) {
44     require(balanceOf[msg.sender] >= value);
45     uint256 codeLength;
46     bytes memory empty;
47 
48     assembly {
49       // Retrieve the size of the code on target address, this needs assembly.
50       codeLength := extcodesize(to)
51     }
52 
53     balanceOf[msg.sender] -= value;  // underflow checked by require() above
54     balanceOf[to] = balanceOf[to].add(value);
55     if (codeLength > 0) {
56       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
57       receiver.tokenFallback(msg.sender, value, empty);
58     }
59     ERC223Transfer(msg.sender, to, value, empty);
60     // ERC20 compatible event:
61     Transfer(msg.sender, to, value);
62     return true;
63   }
64 
65   // Send _value tokens to _to from _from on the condition it is approved by _from.
66   // Added for full compliance with ERC20
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68     require(_to != address(0));
69     require(_value <= balanceOf[_from]);
70     require(_value <= allowances[_from][msg.sender]);
71     bytes memory empty;
72 
73     balanceOf[_from] = balanceOf[_from] -= _value;
74     allowances[_from][msg.sender] -= _value;
75     balanceOf[_to] = balanceOf[_to].add(_value);
76 
77     // No need to call tokenFallback(), cause this is ERC20's solution to the same problem
78     // tokenFallback solves in ERC223. Just fire the ERC223 event for logs consistency.
79     ERC223Transfer(_from, _to, _value, empty);
80     Transfer(_from, _to, _value);
81     return true;
82   }
83 
84   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
85   // If this function is called again it overwrites the current allowance with _value.
86   function approve(address _spender, uint256 _value) public returns (bool success) {
87     allowances[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   // Returns the amount which _spender is still allowed to withdraw from _owner
93   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
94     return allowances[_owner][_spender];
95   }
96 
97   event ERC223Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99   event Approval(address indexed from, address indexed spender, uint256 value);
100 }
101 
102 contract ERC223MintableToken is ERC223Token {
103   uint256 public circulatingSupply;
104   function mint(address to, uint256 value) internal returns (bool) {
105     uint256 codeLength;
106 
107     assembly {
108       // Retrieve the size of the code on target address, this needs assembly .
109       codeLength := extcodesize(to)
110     }
111 
112     circulatingSupply += value;
113 
114     balanceOf[to] += value;  // No safe math needed, won't exceed totalSupply.
115     if (codeLength > 0) {
116       ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
117       bytes memory empty;
118       receiver.tokenFallback(msg.sender, value, empty);
119     }
120     Mint(to, value);
121     return true;
122   }
123 
124   event Mint(address indexed to, uint256 value);
125 }
126 
127 contract ERC20Token {
128   function balanceOf(address owner) public view returns (uint256 balance);
129   function transfer(address to, uint256 tokens) public returns (bool success);
130 }
131 
132 contract Ownable {
133   address public owner;
134   /**
135    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136    * account.
137    */
138   function Ownable() public {
139     owner = msg.sender;
140   }
141 
142   /**
143    * @dev Throws if called by any account other than the owner.
144    */
145   modifier onlyOwner() {
146     require(msg.sender == owner);
147     _;
148   }
149 
150 }
151 
152 contract BountyTokenAllocation is Ownable {
153 
154   // This contract describes how the bounty tokens are allocated.
155   // After a bounty allocation was proposed by a signatory, another
156   // signatory must accept this allocation.
157 
158   // Total amount of remaining tokens to be distributed
159   uint256 public remainingBountyTokens;
160 
161   // Addresses which have a bounty allocation, in order of proposals
162   address[] public allocationAddressList;
163 
164   // Possible split states: Proposed, Approved, Rejected
165   // Proposed is the initial state.
166   // Both Approved and Rejected are final states.
167   // The only possible transitions are:
168   // Proposed => Approved
169   // Proposed => Rejected
170 
171   // keep map here of bounty proposals
172   mapping (address => Types.StructBountyAllocation) public bountyOf;
173 
174   /**
175    * Bounty token allocation constructor.
176    *
177    * @param _remainingBountyTokens Total number of bounty tokens that will be
178    *                               allocated.
179    */
180   function BountyTokenAllocation(uint256 _remainingBountyTokens) Ownable() public {
181     remainingBountyTokens = _remainingBountyTokens;
182   }
183 
184   /**
185    * Propose a bounty transfer
186    *
187    * @param _dest Address of bounty reciepent
188    * @param _amount Amount of tokens he will receive
189    */
190   function proposeBountyTransfer(address _dest, uint256 _amount) public onlyOwner {
191     require(_amount > 0);
192     require(_amount <= remainingBountyTokens);
193      // we can't overwrite existing proposal
194      // but we can overwrite rejected proposal with new values
195     require(bountyOf[_dest].proposalAddress == 0x0 || bountyOf[_dest].bountyState == Types.BountyState.Rejected);
196 
197     if (bountyOf[_dest].bountyState != Types.BountyState.Rejected) {
198       allocationAddressList.push(_dest);
199     }
200 
201     remainingBountyTokens = SafeMath.sub(remainingBountyTokens, _amount);
202     bountyOf[_dest] = Types.StructBountyAllocation({
203       amount: _amount,
204       proposalAddress: msg.sender,
205       bountyState: Types.BountyState.Proposed
206     });
207   }
208 
209   /**
210    * Approves a bounty transfer
211    *
212    * @param _dest Address of bounty reciepent
213    * @return amount of tokens which we approved
214    */
215   function approveBountyTransfer(address _approverAddress, address _dest) public onlyOwner returns (uint256) {
216     require(bountyOf[_dest].bountyState == Types.BountyState.Proposed);
217     require(bountyOf[_dest].proposalAddress != _approverAddress);
218 
219     bountyOf[_dest].bountyState = Types.BountyState.Approved;
220     return bountyOf[_dest].amount;
221   }
222 
223   /**
224    * Rejects a bounty transfer
225    *
226    * @param _dest Address of bounty reciepent for whom we are rejecting bounty transfer
227    */
228   function rejectBountyTransfer(address _dest) public onlyOwner {
229     var tmp = bountyOf[_dest];
230     require(tmp.bountyState == Types.BountyState.Proposed);
231 
232     bountyOf[_dest].bountyState = Types.BountyState.Rejected;
233     remainingBountyTokens = remainingBountyTokens + bountyOf[_dest].amount;
234   }
235 
236 }
237 
238 library SafeMath {
239   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
240     assert(b <= a);
241     return a - b;
242   }
243 
244   function add(uint256 a, uint256 b) pure internal returns (uint256) {
245     uint256 c = a + b;
246     assert(c >= a);
247     return c;
248   }
249   function min(uint256 a, uint256 b) pure internal returns (uint256) {
250     if(a > b)
251       return b;
252     else
253       return a;
254   }
255 }
256 
257 contract SignatoryOwnable {
258   mapping (address => bool) public IS_SIGNATORY;
259 
260   function SignatoryOwnable(address signatory0, address signatory1, address signatory2) internal {
261     IS_SIGNATORY[signatory0] = true;
262     IS_SIGNATORY[signatory1] = true;
263     IS_SIGNATORY[signatory2] = true;
264   }
265 
266   modifier onlySignatory() {
267     require(IS_SIGNATORY[msg.sender]);
268     _;
269   }
270 }
271 
272 contract SignatoryPausable is SignatoryOwnable {
273   bool public paused;  // == false by default
274   address public pauseProposer;  // == 0x0 (no proposal) by default
275 
276   function SignatoryPausable(address signatory0, address signatory1, address signatory2)
277       SignatoryOwnable(signatory0, signatory1, signatory2)
278       internal {}
279 
280   modifier whenPaused(bool status) {
281     require(paused == status);
282     _;
283   }
284 
285   /**
286    * @dev First signatory consent for contract pause state change.
287    */
288   function proposePauseChange(bool status) onlySignatory whenPaused(!status) public {
289     require(pauseProposer == 0x0);  // require there's no pending proposal already
290     pauseProposer = msg.sender;
291   }
292 
293   /**
294    * @dev Second signatory consent for contract pause state change, triggers the change.
295    */
296   function approvePauseChange(bool status) onlySignatory whenPaused(!status) public {
297     require(pauseProposer != 0x0);  // require that a change was already proposed
298     require(pauseProposer != msg.sender);  // approver must be different than proposer
299     pauseProposer = 0x0;
300     paused = status;
301     LogPause(paused);
302   }
303 
304   /**
305    * @dev Reject pause status change proposal.
306    * Can also be called by the proposer, to cancel his proposal.
307    */
308   function rejectPauseChange(bool status) onlySignatory whenPaused(!status) public {
309     pauseProposer = 0x0;
310   }
311 
312   event LogPause(bool status);
313 }
314 
315 contract ExyToken is ERC223MintableToken, SignatoryPausable {
316   using SafeMath for uint256;
317 
318   VestingAllocation private partnerTokensAllocation;
319   VestingAllocation private companyTokensAllocation;
320   BountyTokenAllocation private bountyTokensAllocation;
321 
322   /*
323    * ICO TOKENS
324    * 33% (including SEED TOKENS)
325    *
326    * Ico tokens are sent to the ICO_TOKEN_ADDRESS immediately
327    * after ExyToken initialization
328    */
329   uint256 private constant ICO_TOKENS = 14503506112248500000000000;
330   address private constant ICO_TOKENS_ADDRESS = 0x97c967524d1eacAEb375d4269bE4171581a289C7;
331   /*
332    * SEED TOKENS
333    * 33% (including ICO TOKENS)
334    *
335    * Seed tokens are sent to the SEED_TOKENS_ADDRESS immediately
336    * after ExyToken initialization
337    */
338   uint256 private constant SEED_TOKENS = 11700000000000000000000000;
339   address private constant SEED_TOKENS_ADDRESS = 0x7C32c7649aA1335271aF00cd4280f87166474778;
340 
341   /*
342    * COMPANY TOKENS
343    * 33%
344    *
345    * Company tokens are being distrubited in 36 months
346    * Total tokens = COMPANY_TOKENS_PER_PERIOD * COMPANY_PERIODS
347    */
348   uint256 private constant COMPANY_TOKENS_PER_PERIOD = 727875169784680000000000;
349   uint256 private constant COMPANY_PERIODS = 36;
350   uint256 private constant MINUTES_IN_COMPANY_PERIOD = 60 * 24 * 365 / 12;
351 
352   /*
353    * PARTNER TOKENS
354    * 30%
355    *
356    * Partner tokens are available after 18 months
357    * Total tokens = PARTNER_TOKENS_PER_PERIOD * PARTNER_PERIODS
358    */
359   uint256 private constant PARTNER_TOKENS_PER_PERIOD = 23821369192953200000000000;
360   uint256 private constant PARTNER_PERIODS = 1;
361   uint256 private constant MINUTES_IN_PARTNER_PERIOD = MINUTES_IN_COMPANY_PERIOD * 18; // MINUTES_IN_COMPANY_PERIOD equals one month (see declaration of MINUTES_IN_COMPANY_PERIOD constant)
362 
363   /*
364    * BOUNTY TOKENS
365    * 3%
366    *
367    * Bounty tokens can be sent immediately after initialization
368    */
369   uint256 private constant BOUNTY_TOKENS = 2382136919295320000000000;
370 
371   /*
372    * MARKETING COST TOKENS
373    * 1%
374    *
375    * Tokens are sent to the MARKETING_COST_ADDRESS immediately
376    * after ExyToken initialization
377    */
378   uint256 private constant MARKETING_COST_TOKENS = 794045639765106000000000;
379   address private constant MARKETING_COST_ADDRESS = 0xF133ef3BE68128c9Af16F5aF8F8707f7A7A51452;
380 
381   uint256 public INIT_DATE;
382 
383   string public constant name = "Experty Token";
384   bytes32 public constant symbol = "EXY";
385   uint8 public constant decimals = 18;
386   uint256 public constant totalSupply = (
387     COMPANY_TOKENS_PER_PERIOD * COMPANY_PERIODS +
388     PARTNER_TOKENS_PER_PERIOD * PARTNER_PERIODS +
389     BOUNTY_TOKENS + MARKETING_COST_TOKENS +
390     ICO_TOKENS + SEED_TOKENS);
391 
392   /**
393    * ExyToken contructor.
394    *
395    * Exy token contains allocations of:
396    * - partnerTokensAllocation
397    * - companyTokensAllocation
398    * - bountyTokensAllocation
399    *
400    * param signatory0 Address of first signatory.
401    * param signatory1 Address of second signatory.
402    * param signatory2 Address of third signatory.
403    *
404    */
405   function ExyToken(address signatory0, address signatory1, address signatory2)
406       SignatoryPausable(signatory0, signatory1, signatory2)
407       public {
408 
409     // NOTE: the contract is safe as long as this assignment is not changed nor updated.
410     // If, in the future, INIT_DATE could have a different value, calculations using its value
411     // should most likely use SafeMath.
412     INIT_DATE = block.timestamp;
413 
414     companyTokensAllocation = new VestingAllocation(
415       COMPANY_TOKENS_PER_PERIOD,
416       COMPANY_PERIODS,
417       MINUTES_IN_COMPANY_PERIOD,
418       INIT_DATE);
419 
420     partnerTokensAllocation = new VestingAllocation(
421       PARTNER_TOKENS_PER_PERIOD,
422       PARTNER_PERIODS,
423       MINUTES_IN_PARTNER_PERIOD,
424       INIT_DATE);
425 
426     bountyTokensAllocation = new BountyTokenAllocation(
427       BOUNTY_TOKENS
428     );
429 
430     // minting marketing cost tokens
431     mint(MARKETING_COST_ADDRESS, MARKETING_COST_TOKENS);
432 
433     // minting ICO tokens
434     mint(ICO_TOKENS_ADDRESS, ICO_TOKENS);
435     // minting SEED tokens
436     mint(SEED_TOKENS_ADDRESS, SEED_TOKENS);
437   }
438 
439   /**
440    * Transfer ERC20 tokens out of this contract, to avoid them being stuck here forever.
441    * Only one signatory decision needed, to minimize contract size since this is a rare case.
442    */
443   function erc20TokenTransfer(address _tokenAddr, address _dest) public onlySignatory {
444     ERC20Token token = ERC20Token(_tokenAddr);
445     token.transfer(_dest, token.balanceOf(address(this)));
446   }
447 
448   /**
449    * Adds a proposition of a company token split to companyTokensAllocation
450    */
451   function proposeCompanyAllocation(address _dest, uint256 _tokensPerPeriod) public onlySignatory onlyPayloadSize(2 * 32) {
452     companyTokensAllocation.proposeAllocation(msg.sender, _dest, _tokensPerPeriod);
453   }
454 
455   /**
456    * Approves a proposition of a company token split
457    */
458   function approveCompanyAllocation(address _dest) public onlySignatory {
459     companyTokensAllocation.approveAllocation(msg.sender, _dest);
460   }
461 
462   /**
463    * Rejects a proposition of a company token split.
464    * it can reject only not approved method
465    */
466   function rejectCompanyAllocation(address _dest) public onlySignatory {
467     companyTokensAllocation.rejectAllocation(_dest);
468   }
469 
470   /**
471    * Return number of remaining company tokens allocations
472    * @return Length of company allocations per period
473    */
474   function getRemainingCompanyTokensAllocation() public view returns (uint256) {
475     return companyTokensAllocation.remainingTokensPerPeriod();
476   }
477 
478   /**
479    * Given the index of the company allocation in allocationAddressList
480    * we find its reciepent address and return struct with informations
481    * about this allocation
482    *
483    * @param nr Index of allocation in allocationAddressList
484    * @return Information about company alloction
485    */
486   function getCompanyAllocation(uint256 nr) public view returns (uint256, address, uint256, Types.AllocationState, address) {
487     address recipientAddress = companyTokensAllocation.allocationAddressList(nr);
488     var (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState) = companyTokensAllocation.allocationOf(recipientAddress);
489     return (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState, recipientAddress);
490   }
491 
492   /**
493    * Adds a proposition of a partner token split to companyTokensAllocation
494    */
495   function proposePartnerAllocation(address _dest, uint256 _tokensPerPeriod) public onlySignatory onlyPayloadSize(2 * 32) {
496     partnerTokensAllocation.proposeAllocation(msg.sender, _dest, _tokensPerPeriod);
497   }
498 
499   /**
500    * Approves a proposition of a partner token split
501    */
502   function approvePartnerAllocation(address _dest) public onlySignatory {
503     partnerTokensAllocation.approveAllocation(msg.sender, _dest);
504   }
505 
506   /**
507    * Rejects a proposition of a partner token split.
508    * it can reject only not approved method
509    */
510   function rejectPartnerAllocation(address _dest) public onlySignatory {
511     partnerTokensAllocation.rejectAllocation(_dest);
512   }
513 
514   /**
515    * Return number of remaining partner tokens allocations
516    * @return Length of partner allocations per period
517    */
518   function getRemainingPartnerTokensAllocation() public view returns (uint256) {
519     return partnerTokensAllocation.remainingTokensPerPeriod();
520   }
521 
522   /**
523    * Given the index of the partner allocation in allocationAddressList
524    * we find its reciepent address and return struct with informations
525    * about this allocation
526    *
527    * @param nr Index of allocation in allocationAddressList
528    * @return Information about partner alloction
529    */
530   function getPartnerAllocation(uint256 nr) public view returns (uint256, address, uint256, Types.AllocationState, address) {
531     address recipientAddress = partnerTokensAllocation.allocationAddressList(nr);
532     var (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState) = partnerTokensAllocation.allocationOf(recipientAddress);
533     return (tokensPerPeriod, proposalAddress, claimedPeriods, allocationState, recipientAddress);
534   }
535 
536   function proposeBountyTransfer(address _dest, uint256 _amount) public onlySignatory onlyPayloadSize(2 * 32) {
537     bountyTokensAllocation.proposeBountyTransfer(_dest, _amount);
538   }
539 
540   /**
541    * Approves a bounty transfer and mint tokens
542    *
543    * @param _dest Address of the bounty reciepent to whom we should mint token
544    */
545   function approveBountyTransfer(address _dest) public onlySignatory {
546     uint256 tokensToMint = bountyTokensAllocation.approveBountyTransfer(msg.sender, _dest);
547     mint(_dest, tokensToMint);
548   }
549 
550   /**
551    * Rejects a proposition of a bounty token.
552    * it can reject only not approved method
553    */
554   function rejectBountyTransfer(address _dest) public onlySignatory {
555     bountyTokensAllocation.rejectBountyTransfer(_dest);
556   }
557 
558   function getBountyTransfers(uint256 nr) public view returns (uint256, address, Types.BountyState, address) {
559     address recipientAddress = bountyTokensAllocation.allocationAddressList(nr);
560     var (amount, proposalAddress, bountyState) = bountyTokensAllocation.bountyOf(recipientAddress);
561     return (amount, proposalAddress, bountyState, recipientAddress);
562   }
563 
564   /**
565    * Return number of remaining bounty tokens allocations
566    * @return Length of company allocations
567    */
568   function getRemainingBountyTokens() public view returns (uint256) {
569     return bountyTokensAllocation.remainingBountyTokens();
570   }
571 
572   function claimTokens() public {
573     mint(
574       msg.sender,
575       partnerTokensAllocation.claimTokens(msg.sender) +
576       companyTokensAllocation.claimTokens(msg.sender)
577     );
578   }
579 
580   /**
581    * Override the transfer and mint functions to respect pause state.
582    */
583   function transfer(address to, uint256 value, bytes data) public whenPaused(false) returns (bool) {
584     return super.transfer(to, value, data);
585   }
586 
587   function transfer(address to, uint256 value) public whenPaused(false) returns (bool) {
588     return super.transfer(to, value);
589   }
590 
591   function mint(address to, uint256 value) internal whenPaused(false) returns (bool) {
592     if (circulatingSupply.add(value) > totalSupply) {
593       paused = true;  // emergency pause, this should never happen!
594       return false;
595     }
596     return super.mint(to, value);
597   }
598 
599   modifier onlyPayloadSize(uint size) {
600     assert(msg.data.length == size + 4);
601     _;
602   }
603 
604 }
605 
606 contract Types {
607 
608   // Possible split states: Proposed, Approved, Rejected
609   // Proposed is the initial state.
610   // Both Approved and Rejected are final states.
611   // The only possible transitions are:
612   // Proposed => Approved
613   // Proposed => Rejected
614   enum AllocationState {
615     Proposed,
616     Approved,
617     Rejected
618   }
619 
620   // Structure used for storing company and partner allocations
621   struct StructVestingAllocation {
622     // How many tokens per period we want to pass
623     uint256 tokensPerPeriod;
624     // By whom was this split proposed. Another signatory must approve too
625     address proposerAddress;
626     // How many times did we release tokens
627     uint256 claimedPeriods;
628     // State of actual split.
629     AllocationState allocationState;
630   }
631 
632   enum BountyState {
633     Proposed, // 0
634     Approved, // 1
635     Rejected  // 2
636   }
637 
638   struct StructBountyAllocation {
639     // How many tokens send him or her
640     uint256 amount;
641     // By whom was this allocation proposed
642     address proposalAddress;
643     // State of actual split.
644     BountyState bountyState;
645   }
646 }
647 
648 contract VestingAllocation is Ownable {
649 
650   // This contract describes how the tokens are being released in time
651 
652   // Addresses which have a vesting allocation, in order of proposals
653   address[] public allocationAddressList;
654 
655   // How many distributions periods there are
656   uint256 public periods;
657   // How long is one interval
658   uint256 public minutesInPeriod;
659   // Total amount of remaining tokens to be distributed
660   uint256 public remainingTokensPerPeriod;
661   // Total amount of all tokens
662   uint256 public totalSupply;
663   // Inital timestamp
664   uint256 public initTimestamp;
665 
666   // For each address we can add exactly one possible split.
667   // If we try to add another proposal on existing address it will be rejected
668   mapping (address => Types.StructVestingAllocation) public allocationOf;
669 
670   /**
671    * VestingAllocation contructor.
672    * RemainingTokensPerPeriod variable which represents
673    * the remaining amount of tokens to be distributed
674    *
675    */
676   function VestingAllocation(uint256 _tokensPerPeriod, uint256 _periods, uint256 _minutesInPeriod, uint256 _initalTimestamp) Ownable() public {
677     totalSupply = _tokensPerPeriod * _periods;
678     periods = _periods;
679     minutesInPeriod = _minutesInPeriod;
680     remainingTokensPerPeriod = _tokensPerPeriod;
681     initTimestamp = _initalTimestamp;
682   }
683 
684   /**
685    * Propose split method adds proposal to the splits Array.
686    *
687    * @param _dest              - address of the new receiver
688    * @param _tokensPerPeriod   - how many tokens we are giving to dest
689    */
690   function proposeAllocation(address _proposerAddress, address _dest, uint256 _tokensPerPeriod) public onlyOwner {
691     require(_tokensPerPeriod > 0);
692     require(_tokensPerPeriod <= remainingTokensPerPeriod);
693     // In solidity there is no "exist" method on a map key.
694     // We can't overwrite existing proposal, so we are checking if it is the default value (0x0)
695     // Add `allocationOf[_dest].allocationState == Types.AllocationState.Rejected` for possibility to overwrite rejected allocation
696     require(allocationOf[_dest].proposerAddress == 0x0 || allocationOf[_dest].allocationState == Types.AllocationState.Rejected);
697 
698     if (allocationOf[_dest].allocationState != Types.AllocationState.Rejected) {
699       allocationAddressList.push(_dest);
700     }
701 
702     remainingTokensPerPeriod = remainingTokensPerPeriod - _tokensPerPeriod;
703     allocationOf[_dest] = Types.StructVestingAllocation({
704       tokensPerPeriod: _tokensPerPeriod,
705       allocationState: Types.AllocationState.Proposed,
706       proposerAddress: _proposerAddress,
707       claimedPeriods: 0
708     });
709   }
710 
711   /**
712    * Approves the split allocation, so it can be claimed after periods
713    *
714    * @param _address - address for the split
715    */
716   function approveAllocation(address _approverAddress, address _address) public onlyOwner {
717     require(allocationOf[_address].allocationState == Types.AllocationState.Proposed);
718     require(allocationOf[_address].proposerAddress != _approverAddress);
719     allocationOf[_address].allocationState = Types.AllocationState.Approved;
720   }
721 
722  /**
723    * Rejects the split allocation
724    *
725    * @param _address - address for the split to be rejected
726    */
727   function rejectAllocation(address _address) public onlyOwner {
728     var tmp = allocationOf[_address];
729     require(tmp.allocationState == Types.AllocationState.Proposed);
730     allocationOf[_address].allocationState = Types.AllocationState.Rejected;
731     remainingTokensPerPeriod = remainingTokensPerPeriod + tmp.tokensPerPeriod;
732   }
733 
734   function claimTokens(address _address) public returns (uint256) {
735     Types.StructVestingAllocation storage alloc = allocationOf[_address];
736     if (alloc.allocationState == Types.AllocationState.Approved) {
737       uint256 periodsElapsed = SafeMath.min((block.timestamp - initTimestamp) / (minutesInPeriod * 1 minutes), periods);
738       uint256 tokens = (periodsElapsed - alloc.claimedPeriods) * alloc.tokensPerPeriod;
739       alloc.claimedPeriods = periodsElapsed;
740       return tokens;
741     }
742     return 0;
743   }
744 
745 }
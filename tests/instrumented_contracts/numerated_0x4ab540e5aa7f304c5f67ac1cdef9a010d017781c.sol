1 pragma solidity ^0.5.0;
2 
3 
4 
5 library Roles {
6     struct Role {
7         mapping (address => bool) bearer;
8     }
9 
10     /**
11      * @dev give an account access to this role
12      */
13     function add(Role storage role, address account) internal {
14         require(account != address(0));
15         require(!has(role, account));
16 
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev remove an account's access to this role
22      */
23     function remove(Role storage role, address account) internal {
24         require(account != address(0));
25         require(has(role, account));
26 
27         role.bearer[account] = false;
28     }
29 
30     /**
31      * @dev check if an account has this role
32      * @return bool
33      */
34     function has(Role storage role, address account) internal view returns (bool) {
35         require(account != address(0));
36         return role.bearer[account];
37     }
38 }
39 
40 
41 contract Ownable {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     constructor () internal {
51         _owner = msg.sender;
52         emit OwnershipTransferred(address(0), _owner);
53     }
54 
55     /**
56      * @return the address of the owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(isOwner());
67         _;
68     }
69 
70     /**
71      * @return true if `msg.sender` is the owner of the contract.
72      */
73     function isOwner() public view returns (bool) {
74         return msg.sender == _owner;
75     }
76 
77     /**
78      * @dev Allows the current owner to relinquish control of the contract.
79      * @notice Renouncing to ownership will leave the contract without an owner.
80      * It will not be possible to call the functions with the `onlyOwner`
81      * modifier anymore.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param newOwner The address to transfer ownership to.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0));
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that throw on error
111  */
112 library SafeMath {
113 
114   /**
115   * @dev Multiplies two numbers, throws on overflow.
116   */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) {
119         return 0;
120         }
121         uint256 c = a * b;
122         assert(c / a == b);
123         return c;
124     }
125 
126     /**
127     * @dev Integer division of two numbers, truncating the quotient.
128     */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // assert(b > 0); // Solidity automatically throws when dividing by 0
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133         return c;
134     }
135 
136     /**
137     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138     */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         assert(b <= a);
141         return a - b;
142     }
143 
144     /**
145     * @dev Adds two numbers, throws on overflow.
146     */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         assert(c >= a);
150         return c;
151     }
152 }
153 
154 interface IERC20 {
155     function transfer(address to, uint256 value) external returns (bool);
156 
157     function approve(address spender, uint256 value) external returns (bool);
158 
159     function transferFrom(address from, address to, uint256 value) external returns (bool);
160 
161     function totalSupply() external view returns (uint256);
162 
163     function balanceOf(address who) external view returns (uint256);
164 
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 contract ERC20 is IERC20 {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowed;
178 
179     uint256 private _totalSupply;
180 
181     /**
182     * @dev Total number of tokens in existence
183     */
184     function totalSupply() public view returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param owner The address to query the balance of.
191     * @return An uint256 representing the amount owned by the passed address.
192     */
193     function balanceOf(address owner) public view returns (uint256) {
194         return _balances[owner];
195     }
196 
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param owner address The address which owns the funds.
200      * @param spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      */
203     function allowance(address owner, address spender) public view returns (uint256) {
204         return _allowed[owner][spender];
205     }
206 
207     /**
208     * @dev Transfer token for a specified address
209     * @param to The address to transfer to.
210     * @param value The amount to be transferred.
211     */
212     function transfer(address to, uint256 value) public returns (bool) {
213         _transfer(msg.sender, to, value);
214         return true;
215     }
216 
217     /**
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param spender The address which will spend the funds.
224      * @param value The amount of tokens to be spent.
225      */
226     function approve(address spender, uint256 value) public returns (bool) {
227         require(spender != address(0));
228 
229         _allowed[msg.sender][spender] = value;
230         emit Approval(msg.sender, spender, value);
231         return true;
232     }
233 
234     /**
235      * @dev Transfer tokens from one address to another.
236      * Note that while this function emits an Approval event, this is not required as per the specification,
237      * and other compliant implementations may not emit the event.
238      * @param from address The address which you want to send tokens from
239      * @param to address The address which you want to transfer to
240      * @param value uint256 the amount of tokens to be transferred
241      */
242     function transferFrom(address from, address to, uint256 value) public returns (bool) {
243         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244         _transfer(from, to, value);
245         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
263         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     /**
268      * @dev Decrease the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param subtractedValue The amount of tokens to decrease the allowance by.
276      */
277     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286     * @dev Transfer token for a specified addresses
287     * @param from The address to transfer from.
288     * @param to The address to transfer to.
289     * @param value The amount to be transferred.
290     */
291     function _transfer(address from, address to, uint256 value) internal {
292         require(to != address(0));
293 
294         _balances[from] = _balances[from].sub(value);
295         _balances[to] = _balances[to].add(value);
296         emit Transfer(from, to, value);
297     }
298 
299     /**
300      * @dev Internal function that mints an amount of the token and assigns it to
301      * an account. This encapsulates the modification of balances such that the
302      * proper events are emitted.
303      * @param account The account that will receive the created tokens.
304      * @param value The amount that will be created.
305      */
306     function _mint(address account, uint256 value) internal {
307         require(account != address(0));
308 
309         _totalSupply = _totalSupply.add(value);
310         _balances[account] = _balances[account].add(value);
311         emit Transfer(address(0), account, value);
312     }
313 
314     /**
315      * @dev Internal function that burns an amount of the token of a given
316      * account.
317      * @param account The account whose tokens will be burnt.
318      * @param value The amount that will be burnt.
319      */
320     function _burn(address account, uint256 value) internal {
321         require(account != address(0));
322 
323         _totalSupply = _totalSupply.sub(value);
324         _balances[account] = _balances[account].sub(value);
325         emit Transfer(account, address(0), value);
326     }
327 
328     /**
329      * @dev Internal function that burns an amount of the token of a given
330      * account, deducting from the sender's allowance for said account. Uses the
331      * internal burn function.
332      * Emits an Approval event (reflecting the reduced allowance).
333      * @param account The account whose tokens will be burnt.
334      * @param value The amount that will be burnt.
335      */
336     function _burnFrom(address account, uint256 value) internal {
337         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
338         _burn(account, value);
339         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
340     }
341 }
342 
343 contract ERC20Burnable is ERC20 {
344     /**
345      * @dev Burns a specific amount of tokens.
346      * @param value The amount of token to be burned.
347      */
348     function burn(uint256 value) public {
349         _burn(msg.sender, value);
350     }
351 
352     /**
353      * @dev Burns a specific amount of tokens from the target address and decrements allowance
354      * @param from address The address which you want to send tokens from
355      * @param value uint256 The amount of token to be burned
356      */
357     function burnFrom(address from, uint256 value) public {
358         _burnFrom(from, value);
359     }
360 }
361 
362 
363 contract PauserRole {
364     using Roles for Roles.Role;
365 
366     event PauserAdded(address indexed account);
367     event PauserRemoved(address indexed account);
368 
369     Roles.Role private _pausers;
370 
371     constructor () internal {
372         _addPauser(msg.sender);
373     }
374 
375     modifier onlyPauser() {
376         require(isPauser(msg.sender));
377         _;
378     }
379 
380     function isPauser(address account) public view returns (bool) {
381         return _pausers.has(account);
382     }
383 
384     function addPauser(address account) public onlyPauser {
385         _addPauser(account);
386     }
387 
388     function renouncePauser() public {
389         _removePauser(msg.sender);
390     }
391 
392     function _addPauser(address account) internal {
393         _pausers.add(account);
394         emit PauserAdded(account);
395     }
396 
397     function _removePauser(address account) internal {
398         _pausers.remove(account);
399         emit PauserRemoved(account);
400     }
401 }
402 
403 contract Pausable is PauserRole {
404     event Paused(address account);
405     event Unpaused(address account);
406 
407     bool private _paused;
408 
409     constructor () internal {
410         _paused = false;
411     }
412 
413     /**
414      * @return true if the contract is paused, false otherwise.
415      */
416     function paused() public view returns (bool) {
417         return _paused;
418     }
419 
420     /**
421      * @dev Modifier to make a function callable only when the contract is not paused.
422      */
423     modifier whenNotPaused() {
424         require(!_paused);
425         _;
426     }
427 
428     /**
429      * @dev Modifier to make a function callable only when the contract is paused.
430      */
431     modifier whenPaused() {
432         require(_paused);
433         _;
434     }
435 
436     /**
437      * @dev called by the owner to pause, triggers stopped state
438      */
439     function pause() public onlyPauser whenNotPaused {
440         _paused = true;
441         emit Paused(msg.sender);
442     }
443 
444     /**
445      * @dev called by the owner to unpause, returns to normal state
446      */
447     function unpause() public onlyPauser whenPaused {
448         _paused = false;
449         emit Unpaused(msg.sender);
450     }
451 }
452 
453 
454 contract ERC20Pausable is ERC20, Pausable {
455     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
456         return super.transfer(to, value);
457     }
458 
459     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
460         return super.transferFrom(from, to, value);
461     }
462 
463     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
464         return super.approve(spender, value);
465     }
466 
467     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
468         return super.increaseAllowance(spender, addedValue);
469     }
470 
471     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
472         return super.decreaseAllowance(spender, subtractedValue);
473     }
474 }
475 
476 
477 contract Whitelisting is Ownable {
478     mapping(address => bool) public isInvestorApproved;
479     mapping(address => bool) public isInvestorPaymentApproved;
480 
481     event Approved(address indexed investor);
482     event Disapproved(address indexed investor);
483 
484     event PaymentApproved(address indexed investor);
485     event PaymentDisapproved(address indexed investor);
486 
487 
488     //Token distribution approval (KYC results)
489     function approveInvestor(address toApprove) public onlyOwner {
490         isInvestorApproved[toApprove] = true;
491         emit Approved(toApprove);
492     }
493 
494     function approveInvestorsInBulk(address[] calldata toApprove) external onlyOwner {
495         for (uint i=0; i<toApprove.length; i++) {
496             isInvestorApproved[toApprove[i]] = true;
497             emit Approved(toApprove[i]);
498         }
499     }
500 
501     function disapproveInvestor(address toDisapprove) public onlyOwner {
502         delete isInvestorApproved[toDisapprove];
503         emit Disapproved(toDisapprove);
504     }
505 
506     function disapproveInvestorsInBulk(address[] calldata toDisapprove) external onlyOwner {
507         for (uint i=0; i<toDisapprove.length; i++) {
508             delete isInvestorApproved[toDisapprove[i]];
509             emit Disapproved(toDisapprove[i]);
510         }
511     }
512 
513     //Investor payment approval (For private sale)
514     function approveInvestorPayment(address toApprove) public onlyOwner {
515         isInvestorPaymentApproved[toApprove] = true;
516         emit PaymentApproved(toApprove);
517     }
518 
519     function approveInvestorsPaymentInBulk(address[] calldata toApprove) external onlyOwner {
520         for (uint i=0; i<toApprove.length; i++) {
521             isInvestorPaymentApproved[toApprove[i]] = true;
522             emit PaymentApproved(toApprove[i]);
523         }
524     }
525 
526     function disapproveInvestorapproveInvestorPayment(address toDisapprove) public onlyOwner {
527         delete isInvestorPaymentApproved[toDisapprove];
528         emit PaymentDisapproved(toDisapprove);
529     }
530 
531     function disapproveInvestorsPaymentInBulk(address[] calldata toDisapprove) external onlyOwner {
532         for (uint i=0; i<toDisapprove.length; i++) {
533             delete isInvestorPaymentApproved[toDisapprove[i]];
534             emit PaymentDisapproved(toDisapprove[i]);
535         }
536     }
537 
538 }
539 
540 
541 contract CommunityVesting is Ownable {
542     using SafeMath for uint256;
543 
544     mapping (address => Holding) public holdings;
545 
546     uint256 constant public MinimumHoldingPeriod = 90 days;
547     uint256 constant public Interval = 90 days;
548     uint256 constant public MaximumHoldingPeriod = 360 days;
549 
550     uint256 constant public CommunityCap = 14300000 ether; // 14.3 million tokens
551 
552     uint256 public totalCommunityTokensCommitted;
553 
554     struct Holding {
555         uint256 tokensCommitted;
556         uint256 tokensRemaining;
557         uint256 startTime;
558     }
559 
560     event CommunityVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
561     event CommunityVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
562 
563     function claimTokens(address beneficiary)
564         external
565         onlyOwner
566         returns (uint256 tokensToClaim)
567     {
568         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
569         uint256 startTime = holdings[beneficiary].startTime;
570         require(tokensRemaining > 0, "All tokens claimed");
571 
572         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
573 
574         if (now.sub(startTime) >= MaximumHoldingPeriod) {
575 
576             tokensToClaim = tokensRemaining;
577             delete holdings[beneficiary];
578 
579         } else {
580 
581             uint256 percentage = calculatePercentageToRelease(startTime);
582 
583             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
584             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
585             tokensRemaining = tokensNotToClaim;
586             holdings[beneficiary].tokensRemaining = tokensRemaining;
587 
588         }
589     }
590 
591     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
592         // how many 90 day periods have passed
593         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
594         percentage = periodsPassed.mul(25); // 25% to be released every 90 days
595     }
596 
597     function initializeVesting(
598         address _beneficiary,
599         uint256 _tokens,
600         uint256 _startTime
601     )
602         external
603         onlyOwner
604     {
605         totalCommunityTokensCommitted = totalCommunityTokensCommitted.add(_tokens);
606         require(totalCommunityTokensCommitted <= CommunityCap);
607 
608         if (holdings[_beneficiary].tokensCommitted != 0) {
609             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
610             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
611 
612             emit CommunityVestingUpdated(
613                 _beneficiary,
614                 holdings[_beneficiary].tokensRemaining,
615                 holdings[_beneficiary].startTime
616             );
617 
618         } else {
619             holdings[_beneficiary] = Holding(
620                 _tokens,
621                 _tokens,
622                 _startTime
623             );
624 
625             emit CommunityVestingInitialized(_beneficiary, _tokens, _startTime);
626         }
627     }
628 }
629 
630 
631 
632 contract EcosystemVesting is Ownable {
633     using SafeMath for uint256;
634 
635     mapping (address => Holding) public holdings;
636 
637     uint256 constant public Interval = 90 days;
638     uint256 constant public MaximumHoldingPeriod = 630 days;
639 
640     uint256 constant public EcosystemCap = 54100000 ether; // 54.1 million tokens
641 
642     uint256 public totalEcosystemTokensCommitted;
643 
644     struct Holding {
645         uint256 tokensCommitted;
646         uint256 tokensRemaining;
647         uint256 startTime;
648     }
649 
650     event EcosystemVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
651     event EcosystemVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
652 
653     function claimTokens(address beneficiary)
654         external
655         onlyOwner
656         returns (uint256 tokensToClaim)
657     {
658         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
659         uint256 startTime = holdings[beneficiary].startTime;
660         require(tokensRemaining > 0, "All tokens claimed");
661 
662         if (now.sub(startTime) >= MaximumHoldingPeriod) {
663 
664             tokensToClaim = tokensRemaining;
665             delete holdings[beneficiary];
666 
667         } else {
668 
669             uint256 permill = calculatePermillToRelease(startTime);
670 
671             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(1000 - permill)).div(1000);
672             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
673             tokensRemaining = tokensNotToClaim;
674             holdings[beneficiary].tokensRemaining = tokensRemaining;
675 
676         }
677     }
678 
679     function calculatePermillToRelease(uint256 _startTime) internal view returns (uint256 permill) {
680         // how many 90 day periods have passed
681         uint periodsPassed = ((now.sub(_startTime)).div(Interval)).add(1);
682         permill = periodsPassed.mul(125); // 125 per thousand to be released every 90 days
683     }
684 
685     function initializeVesting(
686         address _beneficiary,
687         uint256 _tokens,
688         uint256 _startTime
689     )
690         external
691         onlyOwner
692     {
693         totalEcosystemTokensCommitted = totalEcosystemTokensCommitted.add(_tokens);
694         require(totalEcosystemTokensCommitted <= EcosystemCap);
695 
696         if (holdings[_beneficiary].tokensCommitted != 0) {
697             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
698             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
699 
700             emit EcosystemVestingUpdated(
701                 _beneficiary,
702                 holdings[_beneficiary].tokensRemaining,
703                 holdings[_beneficiary].startTime
704             );
705 
706         } else {
707             holdings[_beneficiary] = Holding(
708                 _tokens,
709                 _tokens,
710                 _startTime
711             );
712 
713             emit EcosystemVestingInitialized(_beneficiary, _tokens, _startTime);
714         }
715     }
716 }
717 
718 
719 
720 contract SeedPrivateAdvisorVesting is Ownable {
721     using SafeMath for uint256;
722 
723     enum User { Public, Seed, Private, Advisor }
724 
725     mapping (address => Holding) public holdings;
726 
727     uint256 constant public MinimumHoldingPeriod = 90 days;
728     uint256 constant public Interval = 30 days;
729     uint256 constant public MaximumHoldingPeriod = 180 days;
730 
731     uint256 constant public SeedCap = 28000000 ether; // 28 million tokens
732     uint256 constant public PrivateCap = 9000000 ether; // 9 million tokens
733     uint256 constant public AdvisorCap = 7400000 ether; // 7.4 million tokens
734 
735     uint256 public totalSeedTokensCommitted;
736     uint256 public totalPrivateTokensCommitted;
737     uint256 public totalAdvisorTokensCommitted;
738 
739     struct Holding {
740         uint256 tokensCommitted;
741         uint256 tokensRemaining;
742         uint256 startTime;
743         User user;
744     }
745 
746     event VestingInitialized(address _to, uint256 _tokens, uint256 _startTime, User user);
747     event VestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime, User user);
748 
749     function claimTokens(address beneficiary)
750         external
751         onlyOwner
752         returns (uint256 tokensToClaim)
753     {
754         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
755         uint256 startTime = holdings[beneficiary].startTime;
756         require(tokensRemaining > 0, "All tokens claimed");
757 
758         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
759 
760         if (now.sub(startTime) >= MaximumHoldingPeriod) {
761 
762             tokensToClaim = tokensRemaining;
763             delete holdings[beneficiary];
764 
765         } else {
766 
767             uint256 percentage = calculatePercentageToRelease(startTime);
768 
769             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
770             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
771             tokensRemaining = tokensNotToClaim;
772             holdings[beneficiary].tokensRemaining = tokensRemaining;
773 
774         }
775     }
776 
777     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
778         // how many 30 day periods have passed
779         uint periodsPassed = ((now.sub(_startTime.add(MinimumHoldingPeriod))).div(Interval)).add(1);
780         percentage = periodsPassed.mul(25); // 25% to be released every 30 days
781     }
782 
783     function initializeVesting(
784         address _beneficiary,
785         uint256 _tokens,
786         uint256 _startTime,
787         uint8 user
788     )
789         external
790         onlyOwner
791     {
792         User _user;
793         if (user == uint8(User.Seed)) {
794             _user = User.Seed;
795             totalSeedTokensCommitted = totalSeedTokensCommitted.add(_tokens);
796             require(totalSeedTokensCommitted <= SeedCap);
797         } else if (user == uint8(User.Private)) {
798             _user = User.Private;
799             totalPrivateTokensCommitted = totalPrivateTokensCommitted.add(_tokens);
800             require(totalPrivateTokensCommitted <= PrivateCap);
801         } else if (user == uint8(User.Advisor)) {
802             _user = User.Advisor;
803             totalAdvisorTokensCommitted = totalAdvisorTokensCommitted.add(_tokens);
804             require(totalAdvisorTokensCommitted <= AdvisorCap);
805         } else {
806             revert( "incorrect category, not eligible for vesting" );
807         }
808 
809         if (holdings[_beneficiary].tokensCommitted != 0) {
810             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
811             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
812 
813             emit VestingUpdated(
814                 _beneficiary,
815                 holdings[_beneficiary].tokensRemaining,
816                 holdings[_beneficiary].startTime,
817                 holdings[_beneficiary].user
818             );
819 
820         } else {
821             holdings[_beneficiary] = Holding(
822                 _tokens,
823                 _tokens,
824                 _startTime,
825                 _user
826             );
827 
828             emit VestingInitialized(_beneficiary, _tokens, _startTime, _user);
829         }
830     }
831 }
832 
833 
834 contract TeamVesting is Ownable {
835     using SafeMath for uint256;
836 
837     mapping (address => Holding) public holdings;
838 
839     uint256 constant public MinimumHoldingPeriod = 180 days;
840     uint256 constant public Interval = 180 days;
841     uint256 constant public MaximumHoldingPeriod = 720 days;
842 
843     uint256 constant public TeamCap = 12200000 ether; // 12.2 million tokens
844 
845     uint256 public totalTeamTokensCommitted;
846 
847     struct Holding {
848         uint256 tokensCommitted;
849         uint256 tokensRemaining;
850         uint256 startTime;
851     }
852 
853     event TeamVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
854     event TeamVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
855 
856     function claimTokens(address beneficiary)
857         external
858         onlyOwner
859         returns (uint256 tokensToClaim)
860     {
861         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
862         uint256 startTime = holdings[beneficiary].startTime;
863         require(tokensRemaining > 0, "All tokens claimed");
864 
865         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
866 
867         if (now.sub(startTime) >= MaximumHoldingPeriod) {
868 
869             tokensToClaim = tokensRemaining;
870             delete holdings[beneficiary];
871 
872         } else {
873 
874             uint256 percentage = calculatePercentageToRelease(startTime);
875 
876             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
877 
878             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
879             tokensRemaining = tokensNotToClaim;
880             holdings[beneficiary].tokensRemaining = tokensRemaining;
881 
882         }
883     }
884 
885     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
886         // how many 180 day periods have passed
887         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
888         percentage = periodsPassed.mul(25); // 25% to be released every 180 days
889     }
890 
891     function initializeVesting(
892         address _beneficiary,
893         uint256 _tokens,
894         uint256 _startTime
895     )
896         external
897         onlyOwner
898     {
899         totalTeamTokensCommitted = totalTeamTokensCommitted.add(_tokens);
900         require(totalTeamTokensCommitted <= TeamCap);
901 
902         if (holdings[_beneficiary].tokensCommitted != 0) {
903             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
904             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
905 
906             emit TeamVestingUpdated(
907                 _beneficiary,
908                 holdings[_beneficiary].tokensRemaining,
909                 holdings[_beneficiary].startTime
910             );
911 
912         } else {
913             holdings[_beneficiary] = Holding(
914                 _tokens,
915                 _tokens,
916                 _startTime
917             );
918 
919             emit TeamVestingInitialized(_beneficiary, _tokens, _startTime);
920         }
921     }
922 }
923 
924 
925 
926 interface TokenInterface {
927     function totalSupply() external view returns (uint256);
928     function balanceOf(address _owner) external view returns (uint256 balance);
929     function transfer(address _to, uint256 _value) external returns (bool);
930     event Transfer(address indexed from, address indexed to, uint256 value);
931 }
932 
933 
934 contract Vesting is Ownable {
935     using SafeMath for uint256;
936 
937     enum VestingUser { Public, Seed, Private, Advisor, Team, Community, Ecosystem }
938 
939     TokenInterface public token;
940     CommunityVesting public communityVesting;
941     TeamVesting public teamVesting;
942     EcosystemVesting public ecosystemVesting;
943     SeedPrivateAdvisorVesting public seedPrivateAdvisorVesting;
944     mapping (address => VestingUser) public userCategory;
945     uint256 public totalAllocated;
946 
947     event TokensReleased(address _to, uint256 _tokensReleased, VestingUser user);
948 
949     constructor(address _token) public {
950         //require(_token != 0x0, "Invalid address");
951         token = TokenInterface(_token);
952         communityVesting = new CommunityVesting();
953         teamVesting = new TeamVesting();
954         ecosystemVesting = new EcosystemVesting();
955         seedPrivateAdvisorVesting = new SeedPrivateAdvisorVesting();
956     }
957 
958     function claimTokens() external {
959         uint8 category = uint8(userCategory[msg.sender]);
960 
961         uint256 tokensToClaim;
962 
963         if (category == 1 || category == 2 || category == 3) {
964             tokensToClaim = seedPrivateAdvisorVesting.claimTokens(msg.sender);
965         } else if (category == 4) {
966             tokensToClaim = teamVesting.claimTokens(msg.sender);
967         } else if (category == 5) {
968             tokensToClaim = communityVesting.claimTokens(msg.sender);
969         } else if (category == 6){
970             tokensToClaim = ecosystemVesting.claimTokens(msg.sender);
971         } else {
972             revert( "incorrect category, maybe unknown user" );
973         }
974 
975         totalAllocated = totalAllocated.sub(tokensToClaim);
976         require(token.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");
977         emit TokensReleased(msg.sender, tokensToClaim, userCategory[msg.sender]);
978     }
979 
980     function initializeVesting(
981         address _beneficiary,
982         uint256 _tokens,
983         uint256 _startTime,
984         VestingUser user
985     )
986         external
987         onlyOwner
988     {
989         uint8 category = uint8(user);
990         require(category != 0, "Not eligible for vesting");
991 
992         require( uint8(userCategory[_beneficiary]) == 0 || userCategory[_beneficiary] == user, "cannot change user category" );
993         userCategory[_beneficiary] = user;
994         totalAllocated = totalAllocated.add(_tokens);
995 
996         if (category == 1 || category == 2 || category == 3) {
997             seedPrivateAdvisorVesting.initializeVesting(_beneficiary, _tokens, _startTime, category);
998         } else if (category == 4) {
999             teamVesting.initializeVesting(_beneficiary, _tokens, _startTime);
1000         } else if (category == 5) {
1001             communityVesting.initializeVesting(_beneficiary, _tokens, _startTime);
1002         } else if (category == 6){
1003             ecosystemVesting.initializeVesting(_beneficiary, _tokens, _startTime);
1004         } else {
1005             revert( "incorrect category, not eligible for vesting" );
1006         }
1007     }
1008 
1009     function claimUnallocated( address _sendTo) external onlyOwner{
1010         uint256 allTokens = token.balanceOf(address(this));
1011         uint256 tokensUnallocated = allTokens.sub(totalAllocated);
1012         token.transfer(_sendTo, tokensUnallocated);
1013     }
1014 }
1015 
1016 
1017 
1018 contract MintableAndPausableToken is ERC20Pausable, Ownable {
1019     uint8 public constant decimals = 18;
1020     uint256 public maxTokenSupply = 183500000 * 10 ** uint256(decimals);
1021 
1022     bool public mintingFinished = false;
1023 
1024     event Mint(address indexed to, uint256 amount);
1025     event MintFinished();
1026     event MintStarted();
1027 
1028     modifier canMint() {
1029         require(!mintingFinished);
1030         _;
1031     }
1032 
1033     modifier checkMaxSupply(uint256 _amount) {
1034         require(maxTokenSupply >= totalSupply().add(_amount));
1035         _;
1036     }
1037 
1038     modifier cannotMint() {
1039         require(mintingFinished);
1040         _;
1041     }
1042 
1043     function mint(address _to, uint256 _amount)
1044         external
1045         onlyOwner
1046         canMint
1047         checkMaxSupply (_amount)
1048         whenNotPaused
1049         returns (bool)
1050     {
1051         super._mint(_to, _amount);
1052         return true;
1053     }
1054 
1055     function _mint(address _to, uint256 _amount)
1056         internal
1057         canMint
1058         checkMaxSupply (_amount)
1059     {
1060         super._mint(_to, _amount);
1061     }
1062 
1063     function finishMinting() external onlyOwner canMint returns (bool) {
1064         mintingFinished = true;
1065         emit MintFinished();
1066         return true;
1067     }
1068 
1069     function startMinting() external onlyOwner cannotMint returns (bool) {
1070         mintingFinished = false;
1071         emit MintStarted();
1072         return true;
1073     }
1074 }
1075 
1076 
1077 
1078 /**
1079  * Token upgrader interface inspired by Lunyr.
1080  *
1081  * Token upgrader transfers previous version tokens to a newer version.
1082  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
1083  */
1084 contract TokenUpgrader {
1085     uint public originalSupply;
1086 
1087     /** Interface marker */
1088     function isTokenUpgrader() external pure returns (bool) {
1089         return true;
1090     }
1091 
1092     function upgradeFrom(address _from, uint256 _value) public;
1093 }
1094 
1095 
1096 
1097 contract UpgradeableToken is MintableAndPausableToken {
1098     // Contract or person who can set the upgrade path.
1099     address public upgradeMaster;
1100     
1101     // Bollean value needs to be true to start upgrades
1102     bool private upgradesAllowed;
1103 
1104     // The next contract where the tokens will be migrated.
1105     TokenUpgrader public tokenUpgrader;
1106 
1107     // How many tokens we have upgraded by now.
1108     uint public totalUpgraded;
1109 
1110     /**
1111     * Upgrade states.
1112     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
1113     * - Waiting: Token allows upgrade, but we don't have a new token version
1114     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
1115     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
1116     */
1117     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
1118 
1119     // Somebody has upgraded some of his tokens.
1120     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1121 
1122     // New token version available.
1123     event TokenUpgraderIsSet(address _newToken);
1124 
1125     modifier onlyUpgradeMaster {
1126         // Only a master can designate the next token
1127         require(msg.sender == upgradeMaster);
1128         _;
1129     }
1130 
1131     modifier notInUpgradingState {
1132         // Upgrade has already begun for token
1133         require(getUpgradeState() != UpgradeState.Upgrading);
1134         _;
1135     }
1136 
1137     // Do not allow construction without upgrade master set.
1138     constructor(address _upgradeMaster) public {
1139         upgradeMaster = _upgradeMaster;
1140     }
1141 
1142     // set a token upgrader
1143     function setTokenUpgrader(address _newToken)
1144         external
1145         onlyUpgradeMaster
1146         notInUpgradingState
1147     {
1148         require(canUpgrade());
1149         require(_newToken != address(0));
1150 
1151         tokenUpgrader = TokenUpgrader(_newToken);
1152 
1153         // Handle bad interface
1154         require(tokenUpgrader.isTokenUpgrader());
1155 
1156         // Make sure that token supplies match in source and target
1157         require(tokenUpgrader.originalSupply() == totalSupply());
1158 
1159         emit TokenUpgraderIsSet(address(tokenUpgrader));
1160     }
1161 
1162     // Allow the token holder to upgrade some of their tokens to a new contract.
1163     function upgrade(uint _value) external {
1164         UpgradeState state = getUpgradeState();
1165         
1166         // Check upgrate state 
1167         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
1168         // Validate input value
1169         require(_value != 0);
1170 
1171         //balances[msg.sender] = balances[msg.sender].sub(_value);
1172         // Take tokens out from circulation
1173         //totalSupply_ = totalSupply_.sub(_value);
1174         //the _burn method emits the Transfer event
1175         _burn(msg.sender, _value);
1176 
1177         totalUpgraded = totalUpgraded.add(_value);
1178 
1179         // Token Upgrader reissues the tokens
1180         tokenUpgrader.upgradeFrom(msg.sender, _value);
1181         emit Upgrade(msg.sender, address(tokenUpgrader), _value);
1182     }
1183 
1184     /**
1185     * Change the upgrade master.
1186     * This allows us to set a new owner for the upgrade mechanism.
1187     */
1188     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
1189         require(_newMaster != address(0));
1190         upgradeMaster = _newMaster;
1191     }
1192 
1193     // To be overriden to add functionality
1194     function allowUpgrades() external onlyUpgradeMaster () {
1195         upgradesAllowed = true;
1196     }
1197 
1198     // To be overriden to add functionality
1199     function rejectUpgrades() external onlyUpgradeMaster () {
1200         require(!(totalUpgraded > 0));
1201         upgradesAllowed = false;
1202     }
1203 
1204     // Get the state of the token upgrade.
1205     function getUpgradeState() public view returns(UpgradeState) {
1206         if (!canUpgrade()) return UpgradeState.NotAllowed;
1207         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
1208         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1209         else return UpgradeState.Upgrading;
1210     }
1211 
1212     // To be overriden to add functionality
1213     function canUpgrade() public view returns(bool) {
1214         return upgradesAllowed;
1215     }
1216 }
1217 
1218 
1219 
1220 contract Token is UpgradeableToken, ERC20Burnable {
1221     string public name;
1222     string public symbol;
1223 
1224     // For patient incentive programs
1225     uint256 public INITIAL_SUPPLY;
1226     uint256 public hodlPremiumCap;
1227     uint256 public hodlPremiumMinted;
1228 
1229     // After 180 days you get a constant maximum bonus of 25% of tokens transferred
1230     // Before that it is spread out linearly(from 0% to 25%) starting from the
1231     // contribution time till 180 days after that
1232     uint256 constant maxBonusDuration = 180 days;
1233 
1234     struct Bonus {
1235         uint256 hodlTokens;
1236         uint256 contributionTime;
1237         uint256 buybackTokens;
1238     }
1239 
1240     mapping( address => Bonus ) public hodlPremium;
1241 
1242     IERC20 stablecoin;
1243     address stablecoinPayer;
1244 
1245     uint256 public signupWindowStart;
1246     uint256 public signupWindowEnd;
1247 
1248     uint256 public refundWindowStart;
1249     uint256 public refundWindowEnd;
1250 
1251     event UpdatedTokenInformation(string newName, string newSymbol);
1252     event HodlPremiumSet(address beneficiary, uint256 tokens, uint256 contributionTime);
1253     event HodlPremiumCapSet(uint256 newhodlPremiumCap);
1254     event RegisteredForRefund( address holder, uint256 tokens );
1255 
1256     constructor (address _litWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY, uint256 _hodlPremiumCap)
1257         public
1258         UpgradeableToken(_upgradeMaster)
1259         Ownable()
1260     {
1261         require(maxTokenSupply >= _INITIAL_SUPPLY.mul(10 ** uint256(decimals)));
1262         INITIAL_SUPPLY = _INITIAL_SUPPLY.mul(10 ** uint256(decimals));
1263         setHodlPremiumCap(_hodlPremiumCap)  ;
1264         _mint(_litWallet, INITIAL_SUPPLY);
1265     }
1266 
1267     /**
1268     * Owner can update token information here
1269     */
1270     function setTokenInformation(string calldata _name, string calldata _symbol) external onlyOwner {
1271         name = _name;
1272         symbol = _symbol;
1273 
1274         emit UpdatedTokenInformation(name, symbol);
1275     }
1276 
1277     function setRefundSignupDetails( uint256 _startTime,  uint256 _endTime, ERC20 _stablecoin, address _payer ) public onlyOwner {
1278         require( _startTime < _endTime );
1279         stablecoin = _stablecoin;
1280         stablecoinPayer = _payer;
1281         signupWindowStart = _startTime;
1282         signupWindowEnd = _endTime;
1283         refundWindowStart = signupWindowStart + 182 days;
1284         refundWindowEnd = signupWindowEnd + 182 days;
1285         require( refundWindowStart > signupWindowEnd);
1286     }
1287 
1288     function signUpForRefund( uint256 _value ) public {
1289         require( hodlPremium[msg.sender].hodlTokens != 0 || hodlPremium[msg.sender].buybackTokens != 0, "You must be ICO user to sign up" ); //the user was registered in ICO
1290         require( block.timestamp >= signupWindowStart&& block.timestamp <= signupWindowEnd, "Cannot sign up at this time" );
1291         uint256 value = _value;
1292         value = value.add(hodlPremium[msg.sender].buybackTokens);
1293 
1294         if( value > balanceOf(msg.sender)) //cannot register more than he or she has; since refund has to happen while token is paused, we don't need to check anything else
1295             value = balanceOf(msg.sender);
1296 
1297         hodlPremium[ msg.sender].buybackTokens = value;
1298         //buyback cancels hodl highway
1299         if( hodlPremium[msg.sender].hodlTokens > 0 ){
1300             hodlPremium[msg.sender].hodlTokens = 0;
1301             emit HodlPremiumSet( msg.sender, 0, hodlPremium[msg.sender].contributionTime );
1302         }
1303 
1304         emit RegisteredForRefund(msg.sender, value);
1305     }
1306 
1307     function refund( uint256 _value ) public {
1308         require( block.timestamp >= refundWindowStart && block.timestamp <= refundWindowEnd, "cannot refund now" );
1309         require( hodlPremium[msg.sender].buybackTokens >= _value, "not enough tokens in refund program" );
1310         require( balanceOf(msg.sender) >= _value, "not enough tokens" ); //this check is probably redundant to those in _burn, but better check twice
1311         hodlPremium[msg.sender].buybackTokens = hodlPremium[msg.sender].buybackTokens.sub(_value);
1312         _burn( msg.sender, _value );
1313         require( stablecoin.transferFrom( stablecoinPayer, msg.sender, _value.div(20) ), "transfer failed" ); //we pay 1/20 = 0.05 DAI for 1 LIT
1314     }
1315 
1316     function setHodlPremiumCap(uint256 newhodlPremiumCap) public onlyOwner {
1317         require(newhodlPremiumCap > 0);
1318         hodlPremiumCap = newhodlPremiumCap;
1319         emit HodlPremiumCapSet(hodlPremiumCap);
1320     }
1321 
1322     /**
1323     * Owner can burn token here
1324     */
1325     function burn(uint256 _value) public onlyOwner {
1326         super.burn(_value);
1327     }
1328 
1329     function sethodlPremium(
1330         address beneficiary,
1331         uint256 value,
1332         uint256 contributionTime
1333     )
1334         public
1335         onlyOwner
1336         returns (bool)
1337     {
1338         require(beneficiary != address(0) && value > 0 && contributionTime > 0, "Not eligible for HODL Premium");
1339 
1340         if (hodlPremium[beneficiary].hodlTokens != 0) {
1341             hodlPremium[beneficiary].hodlTokens = hodlPremium[beneficiary].hodlTokens.add(value);
1342             emit HodlPremiumSet(beneficiary, hodlPremium[beneficiary].hodlTokens, hodlPremium[beneficiary].contributionTime);
1343         } else {
1344             hodlPremium[beneficiary] = Bonus(value, contributionTime, 0);
1345             emit HodlPremiumSet(beneficiary, value, contributionTime);
1346         }
1347 
1348         return true;
1349     }
1350 
1351     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
1352         require(_to != address(0));
1353         require(_value <= balanceOf(msg.sender));
1354 
1355         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[msg.sender].hodlTokens > 0) {
1356             uint256 amountForBonusCalculation = calculateAmountForBonus(msg.sender, _value);
1357             uint256 bonus = calculateBonus(msg.sender, amountForBonusCalculation);
1358 
1359             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
1360             hodlPremium[msg.sender].hodlTokens = hodlPremium[msg.sender].hodlTokens.sub(amountForBonusCalculation);
1361             if ( bonus > 0) {
1362                 //balances[msg.sender] = balances[msg.sender].add(bonus);
1363                 _mint( msg.sender, bonus );
1364                 //emit Transfer(address(0), msg.sender, bonus);
1365             }
1366         }
1367 
1368         ERC20Pausable.transfer( _to, _value );
1369 //        balances[msg.sender] = balances[msg.sender].sub(_value);
1370 //        balances[_to] = balances[_to].add(_value);
1371 //        emit Transfer(msg.sender, _to, _value);
1372 
1373         //TODO: optimize to avoid setting values outside of buyback window
1374         if( balanceOf(msg.sender) < hodlPremium[msg.sender].buybackTokens )
1375             hodlPremium[msg.sender].buybackTokens = balanceOf(msg.sender);
1376         return true;
1377     }
1378 
1379     function transferFrom(
1380         address _from,
1381         address _to,
1382         uint256 _value
1383     )
1384         public
1385         whenNotPaused
1386         returns (bool)
1387     {
1388         require(_to != address(0));
1389 
1390         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[_from].hodlTokens > 0) {
1391             uint256 amountForBonusCalculation = calculateAmountForBonus(_from, _value);
1392             uint256 bonus = calculateBonus(_from, amountForBonusCalculation);
1393 
1394             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
1395             hodlPremium[_from].hodlTokens = hodlPremium[_from].hodlTokens.sub(amountForBonusCalculation);
1396             if ( bonus > 0) {
1397                 //balances[_from] = balances[_from].add(bonus);
1398                 _mint( _from, bonus );
1399                 //emit Transfer(address(0), _from, bonus);
1400             }
1401         }
1402 
1403         ERC20Pausable.transferFrom( _from, _to, _value);
1404         if( balanceOf(_from) < hodlPremium[_from].buybackTokens )
1405             hodlPremium[_from].buybackTokens = balanceOf(_from);
1406         return true;
1407     }
1408 
1409     function calculateBonus(address beneficiary, uint256 amount) internal returns (uint256) {
1410         uint256 bonusAmount;
1411 
1412         uint256 contributionTime = hodlPremium[beneficiary].contributionTime;
1413         uint256 bonusPeriod;
1414         if (now <= contributionTime) {
1415             bonusPeriod = 0;
1416         } else if (now.sub(contributionTime) >= maxBonusDuration) {
1417             bonusPeriod = maxBonusDuration;
1418         } else {
1419             bonusPeriod = now.sub(contributionTime);
1420         }
1421 
1422         if (bonusPeriod != 0) {
1423             bonusAmount = (((bonusPeriod.mul(amount)).div(maxBonusDuration)).mul(25)).div(100);
1424             if (hodlPremiumMinted.add(bonusAmount) > hodlPremiumCap) {
1425                 bonusAmount = hodlPremiumCap.sub(hodlPremiumMinted);
1426                 hodlPremiumMinted = hodlPremiumCap;
1427             } else {
1428                 hodlPremiumMinted = hodlPremiumMinted.add(bonusAmount);
1429             }
1430 
1431             if( totalSupply().add(bonusAmount) > maxTokenSupply )
1432                 bonusAmount = maxTokenSupply.sub(totalSupply());
1433         }
1434 
1435         return bonusAmount;
1436     }
1437 
1438     function calculateAmountForBonus(address beneficiary, uint256 _value) internal view returns (uint256) {
1439         uint256 amountForBonusCalculation;
1440 
1441         if(_value >= hodlPremium[beneficiary].hodlTokens) {
1442             amountForBonusCalculation = hodlPremium[beneficiary].hodlTokens;
1443         } else {
1444             amountForBonusCalculation = _value;
1445         }
1446 
1447         return amountForBonusCalculation;
1448     }
1449 
1450 }
1451 
1452 
1453 contract TestToken is ERC20{
1454     constructor ( uint256 _balance)public {
1455         _mint(msg.sender, _balance);
1456     }
1457 }
1458 
1459 
1460 contract BaseCrowdsale is Pausable, Ownable  {
1461     using SafeMath for uint256;
1462 
1463     Whitelisting public whitelisting;
1464     Token public token;
1465 
1466     struct Contribution {
1467         address payable contributor;
1468         uint256 weiAmount;
1469         uint256 contributionTime;
1470         bool tokensAllocated;
1471     }
1472 
1473     mapping (uint256 => Contribution) public contributions;
1474     uint256 public contributionIndex;
1475     uint256 public startTime;
1476     uint256 public endTime;
1477     address payable public wallet;
1478     uint256 public weiRaised;
1479     uint256 public tokenRaised;
1480     
1481     mapping (address => uint256) etherContributed;
1482     
1483     event TokenPurchase(
1484         address indexed purchaser,
1485         address indexed beneficiary,
1486         uint256 value,
1487         uint256 amount
1488     );
1489 
1490     event RecordedContribution(
1491         uint256 indexed index,
1492         address indexed contributor,
1493         uint256 weiAmount,
1494         uint256 time
1495     );
1496 
1497     event TokenOwnershipTransferred(
1498         address indexed previousOwner,
1499         address indexed newOwner
1500     );
1501 
1502     modifier allowedUpdate(uint256 time) {
1503         require(time > now);
1504         _;
1505     }
1506 
1507     modifier checkZeroAddress(address _add) {
1508         require(_add != address(0));
1509         _;
1510     }
1511 
1512     constructor(
1513         uint256 _startTime,
1514         uint256 _endTime,
1515         address payable _wallet,
1516         Token _token,
1517         Whitelisting _whitelisting
1518     )
1519         public
1520         checkZeroAddress(_wallet)
1521         checkZeroAddress(address(_token))
1522         checkZeroAddress(address(_whitelisting))
1523     {
1524         require(_startTime >= now);
1525         require(_endTime >= _startTime);
1526 
1527         startTime = _startTime;
1528         endTime = _endTime;
1529         wallet = _wallet;
1530         token = _token;
1531         whitelisting = _whitelisting;
1532     }
1533 
1534     function () external payable {
1535         buyTokens(msg.sender);
1536     }
1537 
1538     function transferTokenOwnership(address newOwner)
1539         external
1540         onlyOwner
1541         checkZeroAddress(newOwner)
1542     {
1543         emit TokenOwnershipTransferred(owner(), newOwner);
1544         token.transferOwnership(newOwner);
1545     }
1546 
1547     function setStartTime(uint256 _newStartTime)
1548         external
1549         onlyOwner
1550         allowedUpdate(_newStartTime)
1551     {
1552         require(startTime > now);
1553         require(_newStartTime < endTime);
1554 
1555         startTime = _newStartTime;
1556     }
1557 
1558     function setEndTime(uint256 _newEndTime)
1559         external
1560         onlyOwner
1561         allowedUpdate(_newEndTime)
1562     {
1563         require(endTime > now);
1564         require(_newEndTime > startTime);
1565 
1566         endTime = _newEndTime;
1567     }
1568 
1569     function hasEnded() public view returns (bool) {
1570         return now > endTime;
1571     }
1572 
1573     function buyTokens(address payable beneficiary)
1574         internal
1575         whenNotPaused
1576         checkZeroAddress(beneficiary)
1577     {
1578         require(validPurchase());
1579         require(weiRaised + msg.value <= 13500 ether);
1580         require(etherContributed[beneficiary].add(msg.value) <= 385 ether);
1581         
1582         
1583         if(now <= startTime + 10 minutes) {
1584             require(whitelisting.isInvestorPaymentApproved(beneficiary));
1585         }
1586 
1587         contributions[contributionIndex].contributor = beneficiary;
1588         contributions[contributionIndex].weiAmount = msg.value;
1589         contributions[contributionIndex].contributionTime = now;
1590         
1591         
1592         etherContributed[beneficiary] = etherContributed[beneficiary].add(msg.value);
1593         weiRaised = weiRaised.add(contributions[contributionIndex].weiAmount);
1594         emit RecordedContribution(
1595             contributionIndex,
1596             contributions[contributionIndex].contributor,
1597             contributions[contributionIndex].weiAmount,
1598             contributions[contributionIndex].contributionTime
1599         );
1600 
1601         contributionIndex++;
1602 
1603         forwardFunds();
1604     }
1605 
1606     function validPurchase() internal view returns (bool) {
1607         bool withinPeriod = now >= startTime && now <= endTime;
1608         bool nonZeroPurchase = msg.value != 0;
1609         return withinPeriod && nonZeroPurchase;
1610     }
1611 
1612     function forwardFunds() internal {
1613         wallet.transfer(msg.value);
1614     }
1615 }
1616 
1617 
1618 contract RefundVault is Ownable {
1619     enum State { Refunding, Closed }
1620 
1621     address payable public wallet;
1622     State public state;
1623 
1624     event Closed();
1625     event RefundsEnabled();
1626     event Refunded(address indexed beneficiary, uint256 weiAmount);
1627 
1628     constructor(address payable _wallet) public {
1629         require(_wallet != address(0));
1630         wallet = _wallet;
1631         state = State.Refunding;
1632         emit RefundsEnabled();
1633     }
1634 
1635     function deposit() public onlyOwner payable {
1636         require(state == State.Refunding);
1637     }
1638 
1639     function close() public onlyOwner {
1640         require(state == State.Refunding);
1641         state = State.Closed;
1642         emit Closed();
1643         wallet.transfer(address(this).balance);
1644     }
1645 
1646     function refund(address payable investor, uint256 depositedValue) public onlyOwner {
1647         require(state == State.Refunding);
1648         investor.transfer(depositedValue);
1649         emit Refunded(investor, depositedValue);
1650     }
1651 }
1652 
1653 
1654 
1655 contract TokenCapRefund is BaseCrowdsale {
1656     RefundVault public vault;
1657     uint256 public refundClosingTime;
1658 
1659     modifier waitingTokenAllocation(uint256 index) {
1660         require(!contributions[index].tokensAllocated);
1661         _;
1662     }
1663 
1664     modifier greaterThanZero(uint256 value) {
1665         require(value > 0);
1666         _;
1667     }
1668 
1669     constructor(uint256 _refundClosingTime) public {
1670         vault = new RefundVault(wallet);
1671 
1672         require(_refundClosingTime > endTime);
1673         refundClosingTime = _refundClosingTime;
1674     }
1675 
1676     function closeRefunds() external onlyOwner {
1677         require(now > refundClosingTime);
1678         vault.close();
1679     }
1680 
1681     function refundContribution(uint256 index)
1682         external
1683         onlyOwner
1684         waitingTokenAllocation(index)
1685     {
1686         vault.refund(contributions[index].contributor, contributions[index].weiAmount);
1687         weiRaised = weiRaised.sub(contributions[index].weiAmount);
1688         delete contributions[index];
1689     }
1690 
1691     function setRefundClosingTime(uint256 _newRefundClosingTime)
1692         external
1693         onlyOwner
1694         allowedUpdate(_newRefundClosingTime)
1695     {
1696         require(refundClosingTime > now);
1697         require(_newRefundClosingTime > endTime);
1698 
1699         refundClosingTime = _newRefundClosingTime;
1700     }
1701 
1702     function forwardFunds() internal {
1703         vault.deposit.value(msg.value)();
1704     }
1705 }
1706 
1707 
1708 contract TokenCapCrowdsale is BaseCrowdsale {
1709     uint256 public tokenCap;
1710     uint256 public individualCap;
1711     uint256 public totalSupply;
1712 
1713     modifier greaterThanZero(uint256 value) {
1714         require(value > 0);
1715         _;
1716     }
1717 
1718     constructor (uint256 _cap, uint256 _individualCap)
1719         public
1720         greaterThanZero(_cap)
1721         greaterThanZero(_individualCap)
1722     {
1723         syncTotalSupply();
1724         require(totalSupply < _cap);
1725         tokenCap = _cap;
1726         individualCap = _individualCap;
1727     }
1728 
1729     function setIndividualCap(uint256 _newIndividualCap)
1730         external
1731         onlyOwner
1732     {     
1733         individualCap = _newIndividualCap;
1734     }
1735 
1736     function setTokenCap(uint256 _newTokenCap)
1737         external
1738         onlyOwner
1739     {     
1740         tokenCap = _newTokenCap;
1741     }
1742 
1743     function hasEnded() public view returns (bool) {
1744         bool tokenCapReached = totalSupply >= tokenCap;
1745         return tokenCapReached || super.hasEnded();
1746     }
1747 
1748     function checkAndUpdateSupply(uint256 newSupply) internal returns (bool) {
1749         totalSupply = newSupply;
1750         return tokenCap >= totalSupply;
1751     }
1752 
1753     function withinIndividualCap(uint256 _tokens) internal view returns (bool) {
1754         return individualCap >= _tokens;
1755     }
1756 
1757     function syncTotalSupply() internal {
1758         totalSupply = token.totalSupply();
1759     }
1760 }
1761 
1762 
1763 contract PublicSale is TokenCapCrowdsale, TokenCapRefund {
1764 
1765     Vesting public vesting;
1766     mapping (address => uint256) public tokensVested;
1767     uint256 hodlStartTime;
1768 
1769     constructor (
1770         uint256 _startTime,
1771         uint256 _endTime,
1772         address payable _wallet,
1773         Whitelisting _whitelisting,
1774         Token _token,
1775         Vesting _vesting,
1776         uint256 _refundClosingTime,
1777         uint256 _refundClosingTokenCap,
1778         uint256 _tokenCap,
1779         uint256 _individualCap
1780     )
1781         public
1782         TokenCapCrowdsale(_tokenCap, _individualCap)
1783         TokenCapRefund(_refundClosingTime)
1784         BaseCrowdsale(_startTime, _endTime, _wallet, _token, _whitelisting)
1785     {
1786         _refundClosingTokenCap; //silence the warning
1787         require( address(_vesting) != address(0), "Invalid address");
1788         vesting = _vesting;
1789     }
1790 
1791     function allocateTokens(uint256 index, uint256 tokens)
1792         external
1793         onlyOwner
1794         waitingTokenAllocation(index)
1795     {
1796         address contributor = contributions[index].contributor;
1797         require(now >= endTime);
1798         require(whitelisting.isInvestorApproved(contributor));
1799 
1800         require(checkAndUpdateSupply(totalSupply.add(tokens)));
1801 
1802         uint256 alreadyExistingTokens = token.balanceOf(contributor);
1803         require(withinIndividualCap(tokens.add(alreadyExistingTokens)));
1804 
1805         contributions[index].tokensAllocated = true;
1806         tokenRaised = tokenRaised.add(tokens);
1807         token.mint(contributor, tokens);
1808         token.sethodlPremium(contributor, tokens, hodlStartTime);
1809 
1810         emit TokenPurchase(
1811             msg.sender,
1812             contributor,
1813             contributions[index].weiAmount,
1814             tokens
1815         );
1816     }
1817 
1818     function vestTokens(address[] calldata beneficiary, uint256[] calldata tokens, uint8[] calldata userType) external onlyOwner {
1819         require(beneficiary.length == tokens.length && tokens.length == userType.length);
1820         uint256 length = beneficiary.length;
1821         for(uint i = 0; i<length; i++) {
1822             require(beneficiary[i] != address(0), "Invalid address");
1823             require(now >= endTime);
1824             require(checkAndUpdateSupply(totalSupply.add(tokens[i])));
1825 
1826             tokensVested[beneficiary[i]] = tokensVested[beneficiary[i]].add(tokens[i]);
1827             require(withinIndividualCap(tokensVested[beneficiary[i]]));
1828 
1829             tokenRaised = tokenRaised.add(tokens[i]);
1830 
1831             token.mint(address(vesting), tokens[i]);
1832             Vesting(vesting).initializeVesting(beneficiary[i], tokens[i], now, Vesting.VestingUser(userType[i]));
1833         }
1834     }
1835 
1836     function ownerAssignedTokens(address beneficiary, uint256 tokens)
1837         external
1838         onlyOwner
1839     {
1840         require(now >= endTime);
1841         require(whitelisting.isInvestorApproved(beneficiary));
1842 
1843         require(checkAndUpdateSupply(totalSupply.add(tokens)));
1844 
1845         uint256 alreadyExistingTokens = token.balanceOf(beneficiary);
1846         require(withinIndividualCap(tokens.add(alreadyExistingTokens)));
1847         tokenRaised = tokenRaised.add(tokens);
1848 
1849         token.mint(beneficiary, tokens);
1850         token.sethodlPremium(beneficiary, tokens, hodlStartTime);
1851 
1852         emit TokenPurchase(
1853             msg.sender,
1854             beneficiary,
1855             0,
1856             tokens
1857         );
1858     }
1859 
1860     function setHodlStartTime(uint256 _hodlStartTime) onlyOwner external{
1861         hodlStartTime = _hodlStartTime;
1862     }
1863 }
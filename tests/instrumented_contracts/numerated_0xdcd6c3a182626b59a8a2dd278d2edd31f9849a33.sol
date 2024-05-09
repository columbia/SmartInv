1 pragma solidity ^0.5.0;
2 
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     /**
10      * @dev give an account access to this role
11      */
12     function add(Role storage role, address account) internal {
13         require(account != address(0));
14         require(!has(role, account));
15 
16         role.bearer[account] = true;
17     }
18 
19     /**
20      * @dev remove an account's access to this role
21      */
22     function remove(Role storage role, address account) internal {
23         require(account != address(0));
24         require(has(role, account));
25 
26         role.bearer[account] = false;
27     }
28 
29     /**
30      * @dev check if an account has this role
31      * @return bool
32      */
33     function has(Role storage role, address account) internal view returns (bool) {
34         require(account != address(0));
35         return role.bearer[account];
36     }
37 }
38 
39 
40 contract Ownable {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor () internal {
50         _owner = msg.sender;
51         emit OwnershipTransferred(address(0), _owner);
52     }
53 
54     /**
55      * @return the address of the owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner());
66         _;
67     }
68 
69     /**
70      * @return true if `msg.sender` is the owner of the contract.
71      */
72     function isOwner() public view returns (bool) {
73         return msg.sender == _owner;
74     }
75 
76     /**
77      * @dev Allows the current owner to relinquish control of the contract.
78      * @notice Renouncing to ownership will leave the contract without an owner.
79      * It will not be possible to call the functions with the `onlyOwner`
80      * modifier anymore.
81      */
82     function renounceOwnership() public onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Allows the current owner to transfer control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address newOwner) public onlyOwner {
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers control of the contract to a newOwner.
97      * @param newOwner The address to transfer ownership to.
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0));
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118         return 0;
119         }
120         uint256 c = a * b;
121         assert(c / a == b);
122         return c;
123     }
124 
125     /**
126     * @dev Integer division of two numbers, truncating the quotient.
127     */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // assert(b > 0); // Solidity automatically throws when dividing by 0
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132         return c;
133     }
134 
135     /**
136     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137     */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     /**
144     * @dev Adds two numbers, throws on overflow.
145     */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         assert(c >= a);
149         return c;
150     }
151 }
152 
153 interface IERC20 {
154     function transfer(address to, uint256 value) external returns (bool);
155 
156     function approve(address spender, uint256 value) external returns (bool);
157 
158     function transferFrom(address from, address to, uint256 value) external returns (bool);
159 
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address who) external view returns (uint256);
163 
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 contract ERC20 is IERC20 {
172     using SafeMath for uint256;
173 
174     mapping (address => uint256) private _balances;
175 
176     mapping (address => mapping (address => uint256)) private _allowed;
177 
178     uint256 private _totalSupply;
179 
180     /**
181     * @dev Total number of tokens in existence
182     */
183     function totalSupply() public view returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188     * @dev Gets the balance of the specified address.
189     * @param owner The address to query the balance of.
190     * @return An uint256 representing the amount owned by the passed address.
191     */
192     function balanceOf(address owner) public view returns (uint256) {
193         return _balances[owner];
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param owner address The address which owns the funds.
199      * @param spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address owner, address spender) public view returns (uint256) {
203         return _allowed[owner][spender];
204     }
205 
206     /**
207     * @dev Transfer token for a specified address
208     * @param to The address to transfer to.
209     * @param value The amount to be transferred.
210     */
211     function transfer(address to, uint256 value) public returns (bool) {
212         _transfer(msg.sender, to, value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param spender The address which will spend the funds.
223      * @param value The amount of tokens to be spent.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         require(spender != address(0));
227 
228         _allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234      * @dev Transfer tokens from one address to another.
235      * Note that while this function emits an Approval event, this is not required as per the specification,
236      * and other compliant implementations may not emit the event.
237      * @param from address The address which you want to send tokens from
238      * @param to address The address which you want to transfer to
239      * @param value uint256 the amount of tokens to be transferred
240      */
241     function transferFrom(address from, address to, uint256 value) public returns (bool) {
242         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
243         _transfer(from, to, value);
244         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
245         return true;
246     }
247 
248     /**
249      * @dev Increase the amount of tokens that an owner allowed to a spender.
250      * approve should be called when allowed_[_spender] == 0. To increment
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * Emits an Approval event.
255      * @param spender The address which will spend the funds.
256      * @param addedValue The amount of tokens to increase the allowance by.
257      */
258     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
262         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
263         return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      * approve should be called when allowed_[_spender] == 0. To decrement
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
277         require(spender != address(0));
278 
279         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
280         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281         return true;
282     }
283 
284     /**
285     * @dev Transfer token for a specified addresses
286     * @param from The address to transfer from.
287     * @param to The address to transfer to.
288     * @param value The amount to be transferred.
289     */
290     function _transfer(address from, address to, uint256 value) internal {
291         require(to != address(0));
292 
293         _balances[from] = _balances[from].sub(value);
294         _balances[to] = _balances[to].add(value);
295         emit Transfer(from, to, value);
296     }
297 
298     /**
299      * @dev Internal function that mints an amount of the token and assigns it to
300      * an account. This encapsulates the modification of balances such that the
301      * proper events are emitted.
302      * @param account The account that will receive the created tokens.
303      * @param value The amount that will be created.
304      */
305     function _mint(address account, uint256 value) internal {
306         require(account != address(0));
307 
308         _totalSupply = _totalSupply.add(value);
309         _balances[account] = _balances[account].add(value);
310         emit Transfer(address(0), account, value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account.
316      * @param account The account whose tokens will be burnt.
317      * @param value The amount that will be burnt.
318      */
319     function _burn(address account, uint256 value) internal {
320         require(account != address(0));
321 
322         _totalSupply = _totalSupply.sub(value);
323         _balances[account] = _balances[account].sub(value);
324         emit Transfer(account, address(0), value);
325     }
326 
327     /**
328      * @dev Internal function that burns an amount of the token of a given
329      * account, deducting from the sender's allowance for said account. Uses the
330      * internal burn function.
331      * Emits an Approval event (reflecting the reduced allowance).
332      * @param account The account whose tokens will be burnt.
333      * @param value The amount that will be burnt.
334      */
335     function _burnFrom(address account, uint256 value) internal {
336         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
337         _burn(account, value);
338         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
339     }
340 }
341 
342 contract ERC20Burnable is ERC20 {
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param value The amount of token to be burned.
346      */
347     function burn(uint256 value) public {
348         _burn(msg.sender, value);
349     }
350 
351     /**
352      * @dev Burns a specific amount of tokens from the target address and decrements allowance
353      * @param from address The address which you want to send tokens from
354      * @param value uint256 The amount of token to be burned
355      */
356     function burnFrom(address from, uint256 value) public {
357         _burnFrom(from, value);
358     }
359 }
360 
361 
362 contract PauserRole {
363     using Roles for Roles.Role;
364 
365     event PauserAdded(address indexed account);
366     event PauserRemoved(address indexed account);
367 
368     Roles.Role private _pausers;
369 
370     constructor () internal {
371         _addPauser(msg.sender);
372     }
373 
374     modifier onlyPauser() {
375         require(isPauser(msg.sender));
376         _;
377     }
378 
379     function isPauser(address account) public view returns (bool) {
380         return _pausers.has(account);
381     }
382 
383     function addPauser(address account) public onlyPauser {
384         _addPauser(account);
385     }
386 
387     function renouncePauser() public {
388         _removePauser(msg.sender);
389     }
390 
391     function _addPauser(address account) internal {
392         _pausers.add(account);
393         emit PauserAdded(account);
394     }
395 
396     function _removePauser(address account) internal {
397         _pausers.remove(account);
398         emit PauserRemoved(account);
399     }
400 }
401 
402 contract Pausable is PauserRole {
403     event Paused(address account);
404     event Unpaused(address account);
405 
406     bool private _paused;
407 
408     constructor () internal {
409         _paused = false;
410     }
411 
412     /**
413      * @return true if the contract is paused, false otherwise.
414      */
415     function paused() public view returns (bool) {
416         return _paused;
417     }
418 
419     /**
420      * @dev Modifier to make a function callable only when the contract is not paused.
421      */
422     modifier whenNotPaused() {
423         require(!_paused);
424         _;
425     }
426 
427     /**
428      * @dev Modifier to make a function callable only when the contract is paused.
429      */
430     modifier whenPaused() {
431         require(_paused);
432         _;
433     }
434 
435     /**
436      * @dev called by the owner to pause, triggers stopped state
437      */
438     function pause() public onlyPauser whenNotPaused {
439         _paused = true;
440         emit Paused(msg.sender);
441     }
442 
443     /**
444      * @dev called by the owner to unpause, returns to normal state
445      */
446     function unpause() public onlyPauser whenPaused {
447         _paused = false;
448         emit Unpaused(msg.sender);
449     }
450 }
451 
452 
453 contract ERC20Pausable is ERC20, Pausable {
454     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
455         return super.transfer(to, value);
456     }
457 
458     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
459         return super.transferFrom(from, to, value);
460     }
461 
462     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
463         return super.approve(spender, value);
464     }
465 
466     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
467         return super.increaseAllowance(spender, addedValue);
468     }
469 
470     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
471         return super.decreaseAllowance(spender, subtractedValue);
472     }
473 }
474 
475 
476 contract Whitelisting is Ownable {
477     mapping(address => bool) public isInvestorApproved;
478     mapping(address => bool) public isInvestorPaymentApproved;
479 
480     event Approved(address indexed investor);
481     event Disapproved(address indexed investor);
482 
483     event PaymentApproved(address indexed investor);
484     event PaymentDisapproved(address indexed investor);
485 
486 
487     //Token distribution approval (KYC results)
488     function approveInvestor(address toApprove) public onlyOwner {
489         isInvestorApproved[toApprove] = true;
490         emit Approved(toApprove);
491     }
492 
493     function approveInvestorsInBulk(address[] calldata toApprove) external onlyOwner {
494         for (uint i=0; i<toApprove.length; i++) {
495             isInvestorApproved[toApprove[i]] = true;
496             emit Approved(toApprove[i]);
497         }
498     }
499 
500     function disapproveInvestor(address toDisapprove) public onlyOwner {
501         delete isInvestorApproved[toDisapprove];
502         emit Disapproved(toDisapprove);
503     }
504 
505     function disapproveInvestorsInBulk(address[] calldata toDisapprove) external onlyOwner {
506         for (uint i=0; i<toDisapprove.length; i++) {
507             delete isInvestorApproved[toDisapprove[i]];
508             emit Disapproved(toDisapprove[i]);
509         }
510     }
511 
512     //Investor payment approval (For private sale)
513     function approveInvestorPayment(address toApprove) public onlyOwner {
514         isInvestorPaymentApproved[toApprove] = true;
515         emit PaymentApproved(toApprove);
516     }
517 
518     function approveInvestorsPaymentInBulk(address[] calldata toApprove) external onlyOwner {
519         for (uint i=0; i<toApprove.length; i++) {
520             isInvestorPaymentApproved[toApprove[i]] = true;
521             emit PaymentApproved(toApprove[i]);
522         }
523     }
524 
525     function disapproveInvestorapproveInvestorPayment(address toDisapprove) public onlyOwner {
526         delete isInvestorPaymentApproved[toDisapprove];
527         emit PaymentDisapproved(toDisapprove);
528     }
529 
530     function disapproveInvestorsPaymentInBulk(address[] calldata toDisapprove) external onlyOwner {
531         for (uint i=0; i<toDisapprove.length; i++) {
532             delete isInvestorPaymentApproved[toDisapprove[i]];
533             emit PaymentDisapproved(toDisapprove[i]);
534         }
535     }
536 
537 }
538 
539 
540 contract CommunityVesting is Ownable {
541     using SafeMath for uint256;
542 
543     mapping (address => Holding) public holdings;
544 
545     uint256 constant public MinimumHoldingPeriod = 90 days;
546     uint256 constant public Interval = 90 days;
547     uint256 constant public MaximumHoldingPeriod = 360 days;
548 
549     uint256 constant public CommunityCap = 14300000 ether; // 14.3 million tokens
550 
551     uint256 public totalCommunityTokensCommitted;
552 
553     struct Holding {
554         uint256 tokensCommitted;
555         uint256 tokensRemaining;
556         uint256 startTime;
557     }
558 
559     event CommunityVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
560     event CommunityVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
561 
562     function claimTokens(address beneficiary)
563         external
564         onlyOwner
565         returns (uint256 tokensToClaim)
566     {
567         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
568         uint256 startTime = holdings[beneficiary].startTime;
569         require(tokensRemaining > 0, "All tokens claimed");
570 
571         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
572 
573         if (now.sub(startTime) >= MaximumHoldingPeriod) {
574 
575             tokensToClaim = tokensRemaining;
576             delete holdings[beneficiary];
577 
578         } else {
579 
580             uint256 percentage = calculatePercentageToRelease(startTime);
581 
582             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
583             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
584             tokensRemaining = tokensNotToClaim;
585             holdings[beneficiary].tokensRemaining = tokensRemaining;
586 
587         }
588     }
589 
590     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
591         // how many 90 day periods have passed
592         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
593         percentage = periodsPassed.mul(25); // 25% to be released every 90 days
594     }
595 
596     function initializeVesting(
597         address _beneficiary,
598         uint256 _tokens,
599         uint256 _startTime
600     )
601         external
602         onlyOwner
603     {
604         totalCommunityTokensCommitted = totalCommunityTokensCommitted.add(_tokens);
605         require(totalCommunityTokensCommitted <= CommunityCap);
606 
607         if (holdings[_beneficiary].tokensCommitted != 0) {
608             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
609             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
610 
611             emit CommunityVestingUpdated(
612                 _beneficiary,
613                 holdings[_beneficiary].tokensRemaining,
614                 holdings[_beneficiary].startTime
615             );
616 
617         } else {
618             holdings[_beneficiary] = Holding(
619                 _tokens,
620                 _tokens,
621                 _startTime
622             );
623 
624             emit CommunityVestingInitialized(_beneficiary, _tokens, _startTime);
625         }
626     }
627 }
628 
629 
630 
631 contract EcosystemVesting is Ownable {
632     using SafeMath for uint256;
633 
634     mapping (address => Holding) public holdings;
635 
636     uint256 constant public Interval = 90 days;
637     uint256 constant public MaximumHoldingPeriod = 630 days;
638 
639     uint256 constant public EcosystemCap = 54100000 ether; // 54.1 million tokens
640 
641     uint256 public totalEcosystemTokensCommitted;
642 
643     struct Holding {
644         uint256 tokensCommitted;
645         uint256 tokensRemaining;
646         uint256 startTime;
647     }
648 
649     event EcosystemVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
650     event EcosystemVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
651 
652     function claimTokens(address beneficiary)
653         external
654         onlyOwner
655         returns (uint256 tokensToClaim)
656     {
657         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
658         uint256 startTime = holdings[beneficiary].startTime;
659         require(tokensRemaining > 0, "All tokens claimed");
660 
661         if (now.sub(startTime) >= MaximumHoldingPeriod) {
662 
663             tokensToClaim = tokensRemaining;
664             delete holdings[beneficiary];
665 
666         } else {
667 
668             uint256 permill = calculatePermillToRelease(startTime);
669 
670             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(1000 - permill)).div(1000);
671             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
672             tokensRemaining = tokensNotToClaim;
673             holdings[beneficiary].tokensRemaining = tokensRemaining;
674 
675         }
676     }
677 
678     function calculatePermillToRelease(uint256 _startTime) internal view returns (uint256 permill) {
679         // how many 90 day periods have passed
680         uint periodsPassed = ((now.sub(_startTime)).div(Interval)).add(1);
681         permill = periodsPassed.mul(125); // 125 per thousand to be released every 90 days
682     }
683 
684     function initializeVesting(
685         address _beneficiary,
686         uint256 _tokens,
687         uint256 _startTime
688     )
689         external
690         onlyOwner
691     {
692         totalEcosystemTokensCommitted = totalEcosystemTokensCommitted.add(_tokens);
693         require(totalEcosystemTokensCommitted <= EcosystemCap);
694 
695         if (holdings[_beneficiary].tokensCommitted != 0) {
696             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
697             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
698 
699             emit EcosystemVestingUpdated(
700                 _beneficiary,
701                 holdings[_beneficiary].tokensRemaining,
702                 holdings[_beneficiary].startTime
703             );
704 
705         } else {
706             holdings[_beneficiary] = Holding(
707                 _tokens,
708                 _tokens,
709                 _startTime
710             );
711 
712             emit EcosystemVestingInitialized(_beneficiary, _tokens, _startTime);
713         }
714     }
715 }
716 
717 
718 
719 contract SeedPrivateAdvisorVesting is Ownable {
720     using SafeMath for uint256;
721 
722     enum User { Public, Seed, Private, Advisor }
723 
724     mapping (address => Holding) public holdings;
725 
726     uint256 constant public MinimumHoldingPeriod = 90 days;
727     uint256 constant public Interval = 30 days;
728     uint256 constant public MaximumHoldingPeriod = 180 days;
729 
730     uint256 constant public SeedCap = 28000000 ether; // 28 million tokens
731     uint256 constant public PrivateCap = 9000000 ether; // 9 million tokens
732     uint256 constant public AdvisorCap = 7400000 ether; // 7.4 million tokens
733 
734     uint256 public totalSeedTokensCommitted;
735     uint256 public totalPrivateTokensCommitted;
736     uint256 public totalAdvisorTokensCommitted;
737 
738     struct Holding {
739         uint256 tokensCommitted;
740         uint256 tokensRemaining;
741         uint256 startTime;
742         User user;
743     }
744 
745     event VestingInitialized(address _to, uint256 _tokens, uint256 _startTime, User user);
746     event VestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime, User user);
747 
748     function claimTokens(address beneficiary)
749         external
750         onlyOwner
751         returns (uint256 tokensToClaim)
752     {
753         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
754         uint256 startTime = holdings[beneficiary].startTime;
755         require(tokensRemaining > 0, "All tokens claimed");
756 
757         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
758 
759         if (now.sub(startTime) >= MaximumHoldingPeriod) {
760 
761             tokensToClaim = tokensRemaining;
762             delete holdings[beneficiary];
763 
764         } else {
765 
766             uint256 percentage = calculatePercentageToRelease(startTime);
767 
768             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
769             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
770             tokensRemaining = tokensNotToClaim;
771             holdings[beneficiary].tokensRemaining = tokensRemaining;
772 
773         }
774     }
775 
776     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
777         // how many 30 day periods have passed
778         uint periodsPassed = ((now.sub(_startTime.add(MinimumHoldingPeriod))).div(Interval)).add(1);
779         percentage = periodsPassed.mul(25); // 25% to be released every 30 days
780     }
781 
782     function initializeVesting(
783         address _beneficiary,
784         uint256 _tokens,
785         uint256 _startTime,
786         uint8 user
787     )
788         external
789         onlyOwner
790     {
791         User _user;
792         if (user == uint8(User.Seed)) {
793             _user = User.Seed;
794             totalSeedTokensCommitted = totalSeedTokensCommitted.add(_tokens);
795             require(totalSeedTokensCommitted <= SeedCap);
796         } else if (user == uint8(User.Private)) {
797             _user = User.Private;
798             totalPrivateTokensCommitted = totalPrivateTokensCommitted.add(_tokens);
799             require(totalPrivateTokensCommitted <= PrivateCap);
800         } else if (user == uint8(User.Advisor)) {
801             _user = User.Advisor;
802             totalAdvisorTokensCommitted = totalAdvisorTokensCommitted.add(_tokens);
803             require(totalAdvisorTokensCommitted <= AdvisorCap);
804         } else {
805             revert( "incorrect category, not eligible for vesting" );
806         }
807 
808         if (holdings[_beneficiary].tokensCommitted != 0) {
809             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
810             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
811 
812             emit VestingUpdated(
813                 _beneficiary,
814                 holdings[_beneficiary].tokensRemaining,
815                 holdings[_beneficiary].startTime,
816                 holdings[_beneficiary].user
817             );
818 
819         } else {
820             holdings[_beneficiary] = Holding(
821                 _tokens,
822                 _tokens,
823                 _startTime,
824                 _user
825             );
826 
827             emit VestingInitialized(_beneficiary, _tokens, _startTime, _user);
828         }
829     }
830 }
831 
832 
833 contract TeamVesting is Ownable {
834     using SafeMath for uint256;
835 
836     mapping (address => Holding) public holdings;
837 
838     uint256 constant public MinimumHoldingPeriod = 180 days;
839     uint256 constant public Interval = 180 days;
840     uint256 constant public MaximumHoldingPeriod = 720 days;
841 
842     uint256 constant public TeamCap = 12200000 ether; // 12.2 million tokens
843 
844     uint256 public totalTeamTokensCommitted;
845 
846     struct Holding {
847         uint256 tokensCommitted;
848         uint256 tokensRemaining;
849         uint256 startTime;
850     }
851 
852     event TeamVestingInitialized(address _to, uint256 _tokens, uint256 _startTime);
853     event TeamVestingUpdated(address _to, uint256 _totalTokens, uint256 _startTime);
854 
855     function claimTokens(address beneficiary)
856         external
857         onlyOwner
858         returns (uint256 tokensToClaim)
859     {
860         uint256 tokensRemaining = holdings[beneficiary].tokensRemaining;
861         uint256 startTime = holdings[beneficiary].startTime;
862         require(tokensRemaining > 0, "All tokens claimed");
863 
864         require(now.sub(startTime) > MinimumHoldingPeriod, "Claiming period not started yet");
865 
866         if (now.sub(startTime) >= MaximumHoldingPeriod) {
867 
868             tokensToClaim = tokensRemaining;
869             delete holdings[beneficiary];
870 
871         } else {
872 
873             uint256 percentage = calculatePercentageToRelease(startTime);
874 
875             uint256 tokensNotToClaim = (holdings[beneficiary].tokensCommitted.mul(100 - percentage)).div(100);
876 
877             tokensToClaim = tokensRemaining.sub(tokensNotToClaim);
878             tokensRemaining = tokensNotToClaim;
879             holdings[beneficiary].tokensRemaining = tokensRemaining;
880 
881         }
882     }
883 
884     function calculatePercentageToRelease(uint256 _startTime) internal view returns (uint256 percentage) {
885         // how many 180 day periods have passed
886         uint periodsPassed = ((now.sub(_startTime)).div(Interval));
887         percentage = periodsPassed.mul(25); // 25% to be released every 180 days
888     }
889 
890     function initializeVesting(
891         address _beneficiary,
892         uint256 _tokens,
893         uint256 _startTime
894     )
895         external
896         onlyOwner
897     {
898         totalTeamTokensCommitted = totalTeamTokensCommitted.add(_tokens);
899         require(totalTeamTokensCommitted <= TeamCap);
900 
901         if (holdings[_beneficiary].tokensCommitted != 0) {
902             holdings[_beneficiary].tokensCommitted = holdings[_beneficiary].tokensCommitted.add(_tokens);
903             holdings[_beneficiary].tokensRemaining = holdings[_beneficiary].tokensRemaining.add(_tokens);
904 
905             emit TeamVestingUpdated(
906                 _beneficiary,
907                 holdings[_beneficiary].tokensRemaining,
908                 holdings[_beneficiary].startTime
909             );
910 
911         } else {
912             holdings[_beneficiary] = Holding(
913                 _tokens,
914                 _tokens,
915                 _startTime
916             );
917 
918             emit TeamVestingInitialized(_beneficiary, _tokens, _startTime);
919         }
920     }
921 }
922 
923 
924 
925 interface TokenInterface {
926     function totalSupply() external view returns (uint256);
927     function balanceOf(address _owner) external view returns (uint256 balance);
928     function transfer(address _to, uint256 _value) external returns (bool);
929     event Transfer(address indexed from, address indexed to, uint256 value);
930 }
931 
932 
933 contract Vesting is Ownable {
934     using SafeMath for uint256;
935 
936     enum VestingUser { Public, Seed, Private, Advisor, Team, Community, Ecosystem }
937 
938     TokenInterface public token;
939     CommunityVesting public communityVesting;
940     TeamVesting public teamVesting;
941     EcosystemVesting public ecosystemVesting;
942     SeedPrivateAdvisorVesting public seedPrivateAdvisorVesting;
943     mapping (address => VestingUser) public userCategory;
944     uint256 public totalAllocated;
945 
946     event TokensReleased(address _to, uint256 _tokensReleased, VestingUser user);
947 
948     constructor(address _token) public {
949         //require(_token != 0x0, "Invalid address");
950         token = TokenInterface(_token);
951         communityVesting = new CommunityVesting();
952         teamVesting = new TeamVesting();
953         ecosystemVesting = new EcosystemVesting();
954         seedPrivateAdvisorVesting = new SeedPrivateAdvisorVesting();
955     }
956 
957     function claimTokens() external {
958         uint8 category = uint8(userCategory[msg.sender]);
959 
960         uint256 tokensToClaim;
961 
962         if (category == 1 || category == 2 || category == 3) {
963             tokensToClaim = seedPrivateAdvisorVesting.claimTokens(msg.sender);
964         } else if (category == 4) {
965             tokensToClaim = teamVesting.claimTokens(msg.sender);
966         } else if (category == 5) {
967             tokensToClaim = communityVesting.claimTokens(msg.sender);
968         } else if (category == 6){
969             tokensToClaim = ecosystemVesting.claimTokens(msg.sender);
970         } else {
971             revert( "incorrect category, maybe unknown user" );
972         }
973 
974         totalAllocated = totalAllocated.sub(tokensToClaim);
975         require(token.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");
976         emit TokensReleased(msg.sender, tokensToClaim, userCategory[msg.sender]);
977     }
978 
979     function initializeVesting(
980         address _beneficiary,
981         uint256 _tokens,
982         uint256 _startTime,
983         VestingUser user
984     )
985         external
986         onlyOwner
987     {
988         uint8 category = uint8(user);
989         require(category != 0, "Not eligible for vesting");
990 
991         require( uint8(userCategory[_beneficiary]) == 0 || userCategory[_beneficiary] == user, "cannot change user category" );
992         userCategory[_beneficiary] = user;
993         totalAllocated = totalAllocated.add(_tokens);
994 
995         if (category == 1 || category == 2 || category == 3) {
996             seedPrivateAdvisorVesting.initializeVesting(_beneficiary, _tokens, _startTime, category);
997         } else if (category == 4) {
998             teamVesting.initializeVesting(_beneficiary, _tokens, _startTime);
999         } else if (category == 5) {
1000             communityVesting.initializeVesting(_beneficiary, _tokens, _startTime);
1001         } else if (category == 6){
1002             ecosystemVesting.initializeVesting(_beneficiary, _tokens, _startTime);
1003         } else {
1004             revert( "incorrect category, not eligible for vesting" );
1005         }
1006     }
1007 
1008     function claimUnallocated( address _sendTo) external onlyOwner{
1009         uint256 allTokens = token.balanceOf(address(this));
1010         uint256 tokensUnallocated = allTokens.sub(totalAllocated);
1011         token.transfer(_sendTo, tokensUnallocated);
1012     }
1013 }
1014 
1015 
1016 
1017 contract MintableAndPausableToken is ERC20Pausable, Ownable {
1018     uint8 public constant decimals = 18;
1019     uint256 public maxTokenSupply = 183500000 * 10 ** uint256(decimals);
1020 
1021     bool public mintingFinished = false;
1022 
1023     event Mint(address indexed to, uint256 amount);
1024     event MintFinished();
1025     event MintStarted();
1026 
1027     modifier canMint() {
1028         require(!mintingFinished);
1029         _;
1030     }
1031 
1032     modifier checkMaxSupply(uint256 _amount) {
1033         require(maxTokenSupply >= totalSupply().add(_amount));
1034         _;
1035     }
1036 
1037     modifier cannotMint() {
1038         require(mintingFinished);
1039         _;
1040     }
1041 
1042     function mint(address _to, uint256 _amount)
1043         external
1044         onlyOwner
1045         canMint
1046         checkMaxSupply (_amount)
1047         whenNotPaused
1048         returns (bool)
1049     {
1050         super._mint(_to, _amount);
1051         return true;
1052     }
1053 
1054     function _mint(address _to, uint256 _amount)
1055         internal
1056         canMint
1057         checkMaxSupply (_amount)
1058     {
1059         super._mint(_to, _amount);
1060     }
1061 
1062     function finishMinting() external onlyOwner canMint returns (bool) {
1063         mintingFinished = true;
1064         emit MintFinished();
1065         return true;
1066     }
1067 
1068     function startMinting() external onlyOwner cannotMint returns (bool) {
1069         mintingFinished = false;
1070         emit MintStarted();
1071         return true;
1072     }
1073 }
1074 
1075 
1076 
1077 /**
1078  * Token upgrader interface inspired by Lunyr.
1079  *
1080  * Token upgrader transfers previous version tokens to a newer version.
1081  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
1082  */
1083 contract TokenUpgrader {
1084     uint public originalSupply;
1085 
1086     /** Interface marker */
1087     function isTokenUpgrader() external pure returns (bool) {
1088         return true;
1089     }
1090 
1091     function upgradeFrom(address _from, uint256 _value) public;
1092 }
1093 
1094 
1095 
1096 contract UpgradeableToken is MintableAndPausableToken {
1097     // Contract or person who can set the upgrade path.
1098     address public upgradeMaster;
1099     
1100     // Bollean value needs to be true to start upgrades
1101     bool private upgradesAllowed;
1102 
1103     // The next contract where the tokens will be migrated.
1104     TokenUpgrader public tokenUpgrader;
1105 
1106     // How many tokens we have upgraded by now.
1107     uint public totalUpgraded;
1108 
1109     /**
1110     * Upgrade states.
1111     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
1112     * - Waiting: Token allows upgrade, but we don't have a new token version
1113     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
1114     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
1115     */
1116     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
1117 
1118     // Somebody has upgraded some of his tokens.
1119     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
1120 
1121     // New token version available.
1122     event TokenUpgraderIsSet(address _newToken);
1123 
1124     modifier onlyUpgradeMaster {
1125         // Only a master can designate the next token
1126         require(msg.sender == upgradeMaster);
1127         _;
1128     }
1129 
1130     modifier notInUpgradingState {
1131         // Upgrade has already begun for token
1132         require(getUpgradeState() != UpgradeState.Upgrading);
1133         _;
1134     }
1135 
1136     // Do not allow construction without upgrade master set.
1137     constructor(address _upgradeMaster) public {
1138         upgradeMaster = _upgradeMaster;
1139     }
1140 
1141     // set a token upgrader
1142     function setTokenUpgrader(address _newToken)
1143         external
1144         onlyUpgradeMaster
1145         notInUpgradingState
1146     {
1147         require(canUpgrade());
1148         require(_newToken != address(0));
1149 
1150         tokenUpgrader = TokenUpgrader(_newToken);
1151 
1152         // Handle bad interface
1153         require(tokenUpgrader.isTokenUpgrader());
1154 
1155         // Make sure that token supplies match in source and target
1156         require(tokenUpgrader.originalSupply() == totalSupply());
1157 
1158         emit TokenUpgraderIsSet(address(tokenUpgrader));
1159     }
1160 
1161     // Allow the token holder to upgrade some of their tokens to a new contract.
1162     function upgrade(uint _value) external {
1163         UpgradeState state = getUpgradeState();
1164         
1165         // Check upgrate state 
1166         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
1167         // Validate input value
1168         require(_value != 0);
1169 
1170         //balances[msg.sender] = balances[msg.sender].sub(_value);
1171         // Take tokens out from circulation
1172         //totalSupply_ = totalSupply_.sub(_value);
1173         //the _burn method emits the Transfer event
1174         _burn(msg.sender, _value);
1175 
1176         totalUpgraded = totalUpgraded.add(_value);
1177 
1178         // Token Upgrader reissues the tokens
1179         tokenUpgrader.upgradeFrom(msg.sender, _value);
1180         emit Upgrade(msg.sender, address(tokenUpgrader), _value);
1181     }
1182 
1183     /**
1184     * Change the upgrade master.
1185     * This allows us to set a new owner for the upgrade mechanism.
1186     */
1187     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
1188         require(_newMaster != address(0));
1189         upgradeMaster = _newMaster;
1190     }
1191 
1192     // To be overriden to add functionality
1193     function allowUpgrades() external onlyUpgradeMaster () {
1194         upgradesAllowed = true;
1195     }
1196 
1197     // To be overriden to add functionality
1198     function rejectUpgrades() external onlyUpgradeMaster () {
1199         require(!(totalUpgraded > 0));
1200         upgradesAllowed = false;
1201     }
1202 
1203     // Get the state of the token upgrade.
1204     function getUpgradeState() public view returns(UpgradeState) {
1205         if (!canUpgrade()) return UpgradeState.NotAllowed;
1206         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
1207         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
1208         else return UpgradeState.Upgrading;
1209     }
1210 
1211     // To be overriden to add functionality
1212     function canUpgrade() public view returns(bool) {
1213         return upgradesAllowed;
1214     }
1215 }
1216 
1217 
1218 
1219 contract Token is UpgradeableToken, ERC20Burnable {
1220     string public name;
1221     string public symbol;
1222 
1223     // For patient incentive programs
1224     uint256 public INITIAL_SUPPLY;
1225     uint256 public hodlPremiumCap;
1226     uint256 public hodlPremiumMinted;
1227 
1228     // After 180 days you get a constant maximum bonus of 25% of tokens transferred
1229     // Before that it is spread out linearly(from 0% to 25%) starting from the
1230     // contribution time till 180 days after that
1231     uint256 constant maxBonusDuration = 180 days;
1232 
1233     struct Bonus {
1234         uint256 hodlTokens;
1235         uint256 contributionTime;
1236         uint256 buybackTokens;
1237     }
1238 
1239     mapping( address => Bonus ) public hodlPremium;
1240 
1241     IERC20 stablecoin;
1242     address stablecoinPayer;
1243 
1244     uint256 public signupWindowStart;
1245     uint256 public signupWindowEnd;
1246 
1247     uint256 public refundWindowStart;
1248     uint256 public refundWindowEnd;
1249 
1250     event UpdatedTokenInformation(string newName, string newSymbol);
1251     event HodlPremiumSet(address beneficiary, uint256 tokens, uint256 contributionTime);
1252     event HodlPremiumCapSet(uint256 newhodlPremiumCap);
1253     event RegisteredForRefund( address holder, uint256 tokens );
1254 
1255     constructor (address _litWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY, uint256 _hodlPremiumCap)
1256         public
1257         UpgradeableToken(_upgradeMaster)
1258         Ownable()
1259     {
1260         require(maxTokenSupply >= _INITIAL_SUPPLY.mul(10 ** uint256(decimals)));
1261         INITIAL_SUPPLY = _INITIAL_SUPPLY.mul(10 ** uint256(decimals));
1262         setHodlPremiumCap(_hodlPremiumCap)  ;
1263         _mint(_litWallet, INITIAL_SUPPLY);
1264     }
1265 
1266     /**
1267     * Owner can update token information here
1268     */
1269     function setTokenInformation(string calldata _name, string calldata _symbol) external onlyOwner {
1270         name = _name;
1271         symbol = _symbol;
1272 
1273         emit UpdatedTokenInformation(name, symbol);
1274     }
1275 
1276     function setRefundSignupDetails( uint256 _startTime,  uint256 _endTime, ERC20 _stablecoin, address _payer ) public onlyOwner {
1277         require( _startTime < _endTime );
1278         stablecoin = _stablecoin;
1279         stablecoinPayer = _payer;
1280         signupWindowStart = _startTime;
1281         signupWindowEnd = _endTime;
1282         refundWindowStart = signupWindowStart + 182 days;
1283         refundWindowEnd = signupWindowEnd + 182 days;
1284         require( refundWindowStart > signupWindowEnd);
1285     }
1286 
1287     function signUpForRefund( uint256 _value ) public {
1288         require( hodlPremium[msg.sender].hodlTokens != 0 || hodlPremium[msg.sender].buybackTokens != 0, "You must be ICO user to sign up" ); //the user was registered in ICO
1289         require( block.timestamp >= signupWindowStart&& block.timestamp <= signupWindowEnd, "Cannot sign up at this time" );
1290         uint256 value = _value;
1291         value = value.add(hodlPremium[msg.sender].buybackTokens);
1292 
1293         if( value > balanceOf(msg.sender)) //cannot register more than he or she has; since refund has to happen while token is paused, we don't need to check anything else
1294             value = balanceOf(msg.sender);
1295 
1296         hodlPremium[ msg.sender].buybackTokens = value;
1297         //buyback cancels hodl highway
1298         if( hodlPremium[msg.sender].hodlTokens > 0 ){
1299             hodlPremium[msg.sender].hodlTokens = 0;
1300             emit HodlPremiumSet( msg.sender, 0, hodlPremium[msg.sender].contributionTime );
1301         }
1302 
1303         emit RegisteredForRefund(msg.sender, value);
1304     }
1305 
1306     function refund( uint256 _value ) public {
1307         require( block.timestamp >= refundWindowStart && block.timestamp <= refundWindowEnd, "cannot refund now" );
1308         require( hodlPremium[msg.sender].buybackTokens >= _value, "not enough tokens in refund program" );
1309         require( balanceOf(msg.sender) >= _value, "not enough tokens" ); //this check is probably redundant to those in _burn, but better check twice
1310         hodlPremium[msg.sender].buybackTokens = hodlPremium[msg.sender].buybackTokens.sub(_value);
1311         _burn( msg.sender, _value );
1312         require( stablecoin.transferFrom( stablecoinPayer, msg.sender, _value.div(20) ), "transfer failed" ); //we pay 1/20 = 0.05 DAI for 1 LIT
1313     }
1314 
1315     function setHodlPremiumCap(uint256 newhodlPremiumCap) public onlyOwner {
1316         require(newhodlPremiumCap > 0);
1317         hodlPremiumCap = newhodlPremiumCap;
1318         emit HodlPremiumCapSet(hodlPremiumCap);
1319     }
1320 
1321     /**
1322     * Owner can burn token here
1323     */
1324     function burn(uint256 _value) public onlyOwner {
1325         super.burn(_value);
1326     }
1327 
1328     function sethodlPremium(
1329         address beneficiary,
1330         uint256 value,
1331         uint256 contributionTime
1332     )
1333         public
1334         onlyOwner
1335         returns (bool)
1336     {
1337         require(beneficiary != address(0) && value > 0 && contributionTime > 0, "Not eligible for HODL Premium");
1338 
1339         if (hodlPremium[beneficiary].hodlTokens != 0) {
1340             hodlPremium[beneficiary].hodlTokens = hodlPremium[beneficiary].hodlTokens.add(value);
1341             emit HodlPremiumSet(beneficiary, hodlPremium[beneficiary].hodlTokens, hodlPremium[beneficiary].contributionTime);
1342         } else {
1343             hodlPremium[beneficiary] = Bonus(value, contributionTime, 0);
1344             emit HodlPremiumSet(beneficiary, value, contributionTime);
1345         }
1346 
1347         return true;
1348     }
1349 
1350     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
1351         require(_to != address(0));
1352         require(_value <= balanceOf(msg.sender));
1353 
1354         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[msg.sender].hodlTokens > 0) {
1355             uint256 amountForBonusCalculation = calculateAmountForBonus(msg.sender, _value);
1356             uint256 bonus = calculateBonus(msg.sender, amountForBonusCalculation);
1357 
1358             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
1359             hodlPremium[msg.sender].hodlTokens = hodlPremium[msg.sender].hodlTokens.sub(amountForBonusCalculation);
1360             if ( bonus > 0) {
1361                 //balances[msg.sender] = balances[msg.sender].add(bonus);
1362                 _mint( msg.sender, bonus );
1363                 //emit Transfer(address(0), msg.sender, bonus);
1364             }
1365         }
1366 
1367         ERC20Pausable.transfer( _to, _value );
1368 //        balances[msg.sender] = balances[msg.sender].sub(_value);
1369 //        balances[_to] = balances[_to].add(_value);
1370 //        emit Transfer(msg.sender, _to, _value);
1371 
1372         //TODO: optimize to avoid setting values outside of buyback window
1373         if( balanceOf(msg.sender) < hodlPremium[msg.sender].buybackTokens )
1374             hodlPremium[msg.sender].buybackTokens = balanceOf(msg.sender);
1375         return true;
1376     }
1377 
1378     function transferFrom(
1379         address _from,
1380         address _to,
1381         uint256 _value
1382     )
1383         public
1384         whenNotPaused
1385         returns (bool)
1386     {
1387         require(_to != address(0));
1388 
1389         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[_from].hodlTokens > 0) {
1390             uint256 amountForBonusCalculation = calculateAmountForBonus(_from, _value);
1391             uint256 bonus = calculateBonus(_from, amountForBonusCalculation);
1392 
1393             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
1394             hodlPremium[_from].hodlTokens = hodlPremium[_from].hodlTokens.sub(amountForBonusCalculation);
1395             if ( bonus > 0) {
1396                 //balances[_from] = balances[_from].add(bonus);
1397                 _mint( _from, bonus );
1398                 //emit Transfer(address(0), _from, bonus);
1399             }
1400         }
1401 
1402         ERC20Pausable.transferFrom( _from, _to, _value);
1403         if( balanceOf(_from) < hodlPremium[_from].buybackTokens )
1404             hodlPremium[_from].buybackTokens = balanceOf(_from);
1405         return true;
1406     }
1407 
1408     function calculateBonus(address beneficiary, uint256 amount) internal returns (uint256) {
1409         uint256 bonusAmount;
1410 
1411         uint256 contributionTime = hodlPremium[beneficiary].contributionTime;
1412         uint256 bonusPeriod;
1413         if (now <= contributionTime) {
1414             bonusPeriod = 0;
1415         } else if (now.sub(contributionTime) >= maxBonusDuration) {
1416             bonusPeriod = maxBonusDuration;
1417         } else {
1418             bonusPeriod = now.sub(contributionTime);
1419         }
1420 
1421         if (bonusPeriod != 0) {
1422             bonusAmount = (((bonusPeriod.mul(amount)).div(maxBonusDuration)).mul(25)).div(100);
1423             if (hodlPremiumMinted.add(bonusAmount) > hodlPremiumCap) {
1424                 bonusAmount = hodlPremiumCap.sub(hodlPremiumMinted);
1425                 hodlPremiumMinted = hodlPremiumCap;
1426             } else {
1427                 hodlPremiumMinted = hodlPremiumMinted.add(bonusAmount);
1428             }
1429 
1430             if( totalSupply().add(bonusAmount) > maxTokenSupply )
1431                 bonusAmount = maxTokenSupply.sub(totalSupply());
1432         }
1433 
1434         return bonusAmount;
1435     }
1436 
1437     function calculateAmountForBonus(address beneficiary, uint256 _value) internal view returns (uint256) {
1438         uint256 amountForBonusCalculation;
1439 
1440         if(_value >= hodlPremium[beneficiary].hodlTokens) {
1441             amountForBonusCalculation = hodlPremium[beneficiary].hodlTokens;
1442         } else {
1443             amountForBonusCalculation = _value;
1444         }
1445 
1446         return amountForBonusCalculation;
1447     }
1448 
1449 }
1450 
1451 
1452 contract TestToken is ERC20{
1453     constructor ( uint256 _balance)public {
1454         _mint(msg.sender, _balance);
1455     }
1456 }
1457 
1458 contract BaseCrowdsale is Pausable, Ownable {
1459     using SafeMath for uint256;
1460 
1461     Whitelisting public whitelisting;
1462     Token public token;
1463 
1464     struct Contribution {
1465         address payable contributor;
1466         uint256 weiAmount;
1467         uint256 contributionTime;
1468         bool tokensAllocated;
1469     }
1470 
1471     mapping (uint256 => Contribution) public contributions;
1472     uint256 public contributionIndex;
1473     uint256 public startTime;
1474     uint256 public endTime;
1475     address payable public wallet;
1476     uint256 public weiRaised;
1477     uint256 public tokenRaised;
1478 
1479     event TokenPurchase(
1480         address indexed purchaser,
1481         address indexed beneficiary,
1482         uint256 value,
1483         uint256 amount
1484     );
1485 
1486     event RecordedContribution(
1487         uint256 indexed index,
1488         address indexed contributor,
1489         uint256 weiAmount,
1490         uint256 time
1491     );
1492 
1493     event TokenOwnershipTransferred(
1494         address indexed previousOwner,
1495         address indexed newOwner
1496     );
1497 
1498     modifier allowedUpdate(uint256 time) {
1499         require(time > now);
1500         _;
1501     }
1502 
1503     modifier checkZeroAddress(address _add) {
1504         require(_add != address(0));
1505         _;
1506     }
1507 
1508     constructor(
1509         uint256 _startTime,
1510         uint256 _endTime,
1511         address payable _wallet,
1512         Token _token,
1513         Whitelisting _whitelisting
1514     )
1515         public
1516         checkZeroAddress(_wallet)
1517         checkZeroAddress(address(_token))
1518         checkZeroAddress(address(_whitelisting))
1519     {
1520         require(_startTime >= now);
1521         require(_endTime >= _startTime);
1522 
1523         startTime = _startTime;
1524         endTime = _endTime;
1525         wallet = _wallet;
1526         token = _token;
1527         whitelisting = _whitelisting;
1528     }
1529 
1530     function () external payable {
1531         buyTokens(msg.sender);
1532     }
1533     
1534     
1535 
1536     function transferTokenOwnership(address newOwner)
1537         external
1538         onlyOwner
1539         checkZeroAddress(newOwner)
1540     {
1541         emit TokenOwnershipTransferred(owner(), newOwner);
1542         token.transferOwnership(newOwner);
1543     }
1544     
1545     function setWallet(address payable _wallet) 
1546     external 
1547     onlyOwner
1548     checkZeroAddress(_wallet)
1549     {
1550         wallet = _wallet;
1551     }
1552 
1553     function setStartTime(uint256 _newStartTime)
1554         external
1555         onlyOwner
1556         allowedUpdate(_newStartTime)
1557     {
1558         require(startTime > now);
1559         require(_newStartTime < endTime);
1560 
1561         startTime = _newStartTime;
1562     }
1563 
1564     function setEndTime(uint256 _newEndTime)
1565         external
1566         onlyOwner
1567         allowedUpdate(_newEndTime)
1568     {
1569         require(endTime > now);
1570         require(_newEndTime > startTime);
1571 
1572         endTime = _newEndTime;
1573     }
1574 
1575     function hasEnded() public view returns (bool) {
1576         return now > endTime;
1577     }
1578 
1579     function buyTokens(address payable beneficiary)
1580         internal
1581         whenNotPaused
1582         checkZeroAddress(beneficiary)
1583     {
1584         require(validPurchase());
1585         require(whitelisting.isInvestorPaymentApproved(beneficiary));
1586 
1587         contributions[contributionIndex].contributor = beneficiary;
1588         contributions[contributionIndex].weiAmount = msg.value;
1589         contributions[contributionIndex].contributionTime = now;
1590 
1591         weiRaised = weiRaised.add(contributions[contributionIndex].weiAmount);
1592         emit RecordedContribution(
1593             contributionIndex,
1594             contributions[contributionIndex].contributor,
1595             contributions[contributionIndex].weiAmount,
1596             contributions[contributionIndex].contributionTime
1597         );
1598 
1599         contributionIndex++;
1600 
1601         forwardFunds();
1602     }
1603 
1604     function validPurchase() internal view returns (bool) {
1605         bool withinPeriod = now >= startTime && now <= endTime;
1606         bool nonZeroPurchase = msg.value != 0;
1607         return withinPeriod && nonZeroPurchase;
1608     }
1609 
1610     function forwardFunds() internal {
1611         wallet.transfer(msg.value);
1612     }
1613 }
1614 
1615 
1616 
1617 contract RefundVault is Ownable {
1618     enum State { Refunding, Closed }
1619 
1620     address payable public wallet;
1621     State public state;
1622 
1623     event Closed();
1624     event RefundsEnabled();
1625     event Refunded(address indexed beneficiary, uint256 weiAmount);
1626 
1627     constructor(address payable _wallet) public {
1628         require(_wallet != address(0));
1629         wallet = _wallet;
1630         state = State.Refunding;
1631         emit RefundsEnabled();
1632     }
1633 
1634     function deposit() public onlyOwner payable {
1635         require(state == State.Refunding);
1636     }
1637 
1638     function close() public onlyOwner {
1639         require(state == State.Refunding);
1640         state = State.Closed;
1641         emit Closed();
1642         wallet.transfer(address(this).balance);
1643     }
1644 
1645     function refund(address payable investor, uint256 depositedValue) public onlyOwner {
1646         require(state == State.Refunding);
1647         investor.transfer(depositedValue);
1648         emit Refunded(investor, depositedValue);
1649     }
1650 }
1651 
1652 
1653 
1654 contract TokenCapRefund is BaseCrowdsale {
1655     RefundVault public vault;
1656     uint256 public refundClosingTime;
1657 
1658     modifier waitingTokenAllocation(uint256 index) {
1659         require(!contributions[index].tokensAllocated);
1660         _;
1661     }
1662 
1663     modifier greaterThanZero(uint256 value) {
1664         require(value > 0);
1665         _;
1666     }
1667 
1668     constructor(uint256 _refundClosingTime) public {
1669         vault = new RefundVault(wallet);
1670 
1671         require(_refundClosingTime > endTime);
1672         refundClosingTime = _refundClosingTime;
1673     }
1674 
1675     function closeRefunds() external onlyOwner {
1676         require(now > refundClosingTime);
1677         vault.close();
1678     }
1679 
1680     function refundContribution(uint256 index)
1681         external
1682         onlyOwner
1683         waitingTokenAllocation(index)
1684     {
1685         vault.refund(contributions[index].contributor, contributions[index].weiAmount);
1686         weiRaised = weiRaised.sub(contributions[index].weiAmount);
1687         delete contributions[index];
1688     }
1689 
1690     function setRefundClosingTime(uint256 _newRefundClosingTime)
1691         external
1692         onlyOwner
1693         allowedUpdate(_newRefundClosingTime)
1694     {
1695         require(refundClosingTime > now);
1696         require(_newRefundClosingTime > endTime);
1697 
1698         refundClosingTime = _newRefundClosingTime;
1699     }
1700 
1701     function forwardFunds() internal {
1702         vault.deposit.value(msg.value)();
1703     }
1704 }
1705 
1706 
1707 contract TokenCapCrowdsale is BaseCrowdsale {
1708     uint256 public tokenCap;
1709     uint256 public individualCap;
1710     uint256 public totalSupply;
1711 
1712     modifier greaterThanZero(uint256 value) {
1713         require(value > 0);
1714         _;
1715     }
1716 
1717     constructor (uint256 _cap, uint256 _individualCap)
1718         public
1719         greaterThanZero(_cap)
1720         greaterThanZero(_individualCap)
1721     {
1722         syncTotalSupply();
1723         require(totalSupply < _cap);
1724         tokenCap = _cap;
1725         individualCap = _individualCap;
1726     }
1727 
1728     function setIndividualCap(uint256 _newIndividualCap)
1729         external
1730         onlyOwner
1731     {     
1732         individualCap = _newIndividualCap;
1733     }
1734 
1735     function setTokenCap(uint256 _newTokenCap)
1736         external
1737         onlyOwner
1738     {     
1739         tokenCap = _newTokenCap;
1740     }
1741 
1742     function hasEnded() public view returns (bool) {
1743         bool tokenCapReached = totalSupply >= tokenCap;
1744         return tokenCapReached || super.hasEnded();
1745     }
1746 
1747     function checkAndUpdateSupply(uint256 newSupply) internal returns (bool) {
1748         totalSupply = newSupply;
1749         return tokenCap >= totalSupply;
1750     }
1751 
1752     function withinIndividualCap(uint256 _tokens) internal view returns (bool) {
1753         return individualCap >= _tokens;
1754     }
1755 
1756     function syncTotalSupply() internal {
1757         totalSupply = token.totalSupply();
1758     }
1759 }
1760 
1761 
1762 
1763 contract PrivateSale is TokenCapCrowdsale, TokenCapRefund {
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
1786         _refundClosingTokenCap; //silence compiler warning
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
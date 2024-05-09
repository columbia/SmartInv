1 pragma solidity ^0.4.11;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public constant returns (address owner) { owner; }
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public constant returns (string name) { name; }
20     function symbol() public constant returns (string symbol) { symbol; }
21     function decimals() public constant returns (uint8 decimals) { decimals; }
22     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
23     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
24     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     Token Holder interface
33 */
34 contract ITokenHolder is IOwned {
35     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
36 }
37 
38 /*
39     Smart Token interface
40 */
41 contract ISmartToken is ITokenHolder, IERC20Token {
42     function disableTransfers(bool _disable) public;
43     function issue(address _to, uint256 _amount) public;
44     function destroy(address _from, uint256 _amount) public;
45 }
46 
47 /*
48     Overflow protected math functions
49 */
50 contract SafeMath {
51     /**
52         constructor
53     */
54     function SafeMath() {
55     }
56 
57     /**
58         @dev returns the sum of _x and _y, asserts if the calculation overflows
59 
60         @param _x   value 1
61         @param _y   value 2
62 
63         @return sum
64     */
65     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
66         uint256 z = _x + _y;
67         assert(z >= _x);
68         return z;
69     }
70 
71     /**
72         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
73 
74         @param _x   minuend
75         @param _y   subtrahend
76 
77         @return difference
78     */
79     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
80         assert(_x >= _y);
81         return _x - _y;
82     }
83 
84     /**
85         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
86 
87         @param _x   factor 1
88         @param _y   factor 2
89 
90         @return product
91     */
92     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
93         uint256 z = _x * _y;
94         assert(_x == 0 || z / _x == _y);
95         return z;
96     }
97 }
98 
99 /**
100     ERC20 Standard Token implementation
101 */
102 contract ERC20Token is IERC20Token, SafeMath {
103     string public standard = 'Token 0.1';
104     string public name = '';
105     string public symbol = '';
106     uint8 public decimals = 0;
107     uint256 public totalSupply = 0;
108     mapping (address => uint256) public balanceOf;
109     mapping (address => mapping (address => uint256)) public allowance;
110 
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113 
114     /**
115         @dev constructor
116 
117         @param _name        token name
118         @param _symbol      token symbol
119         @param _decimals    decimal points, for display purposes
120     */
121     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
122         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
123 
124         name = _name;
125         symbol = _symbol;
126         decimals = _decimals;
127     }
128 
129     // validates an address - currently only checks that it isn't null
130     modifier validAddress(address _address) {
131         require(_address != 0x0);
132         _;
133     }
134 
135     /**
136         @dev send coins
137         throws on any error rather then return a false flag to minimize user errors
138 
139         @param _to      target address
140         @param _value   transfer amount
141 
142         @return true if the transfer was successful, false if it wasn't
143     */
144     function transfer(address _to, uint256 _value)
145         public
146         validAddress(_to)
147         returns (bool success)
148     {
149         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
150         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
151         Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     /**
156         @dev an account/contract attempts to get the coins
157         throws on any error rather then return a false flag to minimize user errors
158 
159         @param _from    source address
160         @param _to      target address
161         @param _value   transfer amount
162 
163         @return true if the transfer was successful, false if it wasn't
164     */
165     function transferFrom(address _from, address _to, uint256 _value)
166         public
167         validAddress(_from)
168         validAddress(_to)
169         returns (bool success)
170     {
171         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
172         balanceOf[_from] = safeSub(balanceOf[_from], _value);
173         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
174         Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179         @dev allow another account/contract to spend some tokens on your behalf
180         throws on any error rather then return a false flag to minimize user errors
181 
182         also, to minimize the risk of the approve/transferFrom attack vector
183         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
184         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
185 
186         @param _spender approved address
187         @param _value   allowance amount
188 
189         @return true if the approval was successful, false if it wasn't
190     */
191     function approve(address _spender, uint256 _value)
192         public
193         validAddress(_spender)
194         returns (bool success)
195     {
196         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
197         require(_value == 0 || allowance[msg.sender][_spender] == 0);
198 
199         allowance[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 }
204 
205 /*
206     Provides support and utilities for contract ownership
207 */
208 contract Owned is IOwned {
209     address public owner;
210     address public newOwner;
211 
212     event OwnerUpdate(address _prevOwner, address _newOwner);
213 
214     /**
215         @dev constructor
216     */
217     function Owned() {
218         owner = msg.sender;
219     }
220 
221     // allows execution by the owner only
222     modifier ownerOnly {
223         assert(msg.sender == owner);
224         _;
225     }
226 
227     /**
228         @dev allows transferring the contract ownership
229         the new owner still need to accept the transfer
230         can only be called by the contract owner
231 
232         @param _newOwner    new contract owner
233     */
234     function transferOwnership(address _newOwner) public ownerOnly {
235         require(_newOwner != owner);
236         newOwner = _newOwner;
237     }
238 
239     /**
240         @dev used by a new owner to accept an ownership transfer
241     */
242     function acceptOwnership() public {
243         require(msg.sender == newOwner);
244         OwnerUpdate(owner, newOwner);
245         owner = newOwner;
246         newOwner = 0x0;
247     }
248 }
249 
250 /*
251     We consider every contract to be a 'token holder' since it's currently not possible
252     for a contract to deny receiving tokens.
253 
254     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
255     the owner to send tokens that were sent to the contract by mistake back to their sender.
256 */
257 contract TokenHolder is ITokenHolder, Owned {
258     /**
259         @dev constructor
260     */
261     function TokenHolder() {
262     }
263 
264     // validates an address - currently only checks that it isn't null
265     modifier validAddress(address _address) {
266         require(_address != 0x0);
267         _;
268     }
269 
270     // verifies that the address is different than this contract address
271     modifier notThis(address _address) {
272         require(_address != address(this));
273         _;
274     }
275 
276     /**
277         @dev withdraws tokens held by the contract and sends them to an account
278         can only be called by the owner
279 
280         @param _token   ERC20 token contract address
281         @param _to      account to receive the new amount
282         @param _amount  amount to withdraw
283     */
284     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
285         public
286         ownerOnly
287         validAddress(_token)
288         validAddress(_to)
289         notThis(_to)
290     {
291         assert(_token.transfer(_to, _amount));
292     }
293 }
294 
295 /*
296     Smart Token v0.2
297 
298     'Owned' is specified here for readability reasons
299 */
300 contract SmartToken is ISmartToken, ERC20Token, Owned, TokenHolder {
301     string public version = '0.2';
302 
303     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
304 
305     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
306     event NewSmartToken(address _token);
307     // triggered when the total supply is increased
308     event Issuance(uint256 _amount);
309     // triggered when the total supply is decreased
310     event Destruction(uint256 _amount);
311 
312     /**
313         @dev constructor
314 
315         @param _name       token name
316         @param _symbol     token short symbol, 1-6 characters
317         @param _decimals   for display purposes only
318     */
319     function SmartToken(string _name, string _symbol, uint8 _decimals)
320         ERC20Token(_name, _symbol, _decimals)
321     {
322         require(bytes(_symbol).length <= 6); // validate input
323         NewSmartToken(address(this));
324     }
325 
326     // allows execution only when transfers aren't disabled
327     modifier transfersAllowed {
328         assert(transfersEnabled);
329         _;
330     }
331 
332     /**
333         @dev disables/enables transfers
334         can only be called by the contract owner
335 
336         @param _disable    true to disable transfers, false to enable them
337     */
338     function disableTransfers(bool _disable) public ownerOnly {
339         transfersEnabled = !_disable;
340     }
341 
342     /**
343         @dev increases the token supply and sends the new tokens to an account
344         can only be called by the contract owner
345 
346         @param _to         account to receive the new amount
347         @param _amount     amount to increase the supply by
348     */
349     function issue(address _to, uint256 _amount)
350         public
351         ownerOnly
352         validAddress(_to)
353         notThis(_to)
354     {
355         totalSupply = safeAdd(totalSupply, _amount);
356         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
357 
358         Issuance(_amount);
359         Transfer(this, _to, _amount);
360     }
361 
362     /**
363         @dev removes tokens from an account and decreases the token supply
364         can only be called by the contract owner
365 
366         @param _from       account to remove the amount from
367         @param _amount     amount to decrease the supply by
368     */
369     function destroy(address _from, uint256 _amount)
370         public
371         ownerOnly
372     {
373         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
374         totalSupply = safeSub(totalSupply, _amount);
375 
376         Transfer(_from, this, _amount);
377         Destruction(_amount);
378     }
379 
380     // ERC20 standard method overrides with some extra functionality
381 
382     /**
383         @dev send coins
384         throws on any error rather then return a false flag to minimize user errors
385         note that when transferring to the smart token's address, the coins are actually destroyed
386 
387         @param _to      target address
388         @param _value   transfer amount
389 
390         @return true if the transfer was successful, false if it wasn't
391     */
392     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
393         assert(super.transfer(_to, _value));
394 
395         // transferring to the contract address destroys tokens
396         if (_to == address(this)) {
397             balanceOf[_to] -= _value;
398             totalSupply -= _value;
399             Destruction(_value);
400         }
401 
402         return true;
403     }
404 
405     /**
406         @dev an account/contract attempts to get the coins
407         throws on any error rather then return a false flag to minimize user errors
408         note that when transferring to the smart token's address, the coins are actually destroyed
409 
410         @param _from    source address
411         @param _to      target address
412         @param _value   transfer amount
413 
414         @return true if the transfer was successful, false if it wasn't
415     */
416     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
417         assert(super.transferFrom(_from, _to, _value));
418 
419         // transferring to the contract address destroys tokens
420         if (_to == address(this)) {
421             balanceOf[_to] -= _value;
422             totalSupply -= _value;
423             Destruction(_value);
424         }
425 
426         return true;
427     }
428 }
429 
430 /// @title Ownable
431 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
432 /// & the implementation of "user permissions".
433 contract Ownable {
434     address public owner;
435     address public newOwnerCandidate;
436 
437     event OwnershipRequested(address indexed _by, address indexed _to);
438     event OwnershipTransferred(address indexed _from, address indexed _to);
439 
440     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
441     function Ownable() {
442         owner = msg.sender;
443     }
444 
445     /// @dev Throws if called by any account other than the owner.
446     modifier onlyOwner() {
447         if (msg.sender != owner) {
448             throw;
449         }
450 
451         _;
452     }
453 
454     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
455     /// @param _newOwnerCandidate address The address to transfer ownership to.
456     function transferOwnership(address _newOwnerCandidate) onlyOwner {
457         require(_newOwnerCandidate != address(0));
458 
459         newOwnerCandidate = _newOwnerCandidate;
460 
461         OwnershipRequested(msg.sender, newOwnerCandidate);
462     }
463 
464     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
465     function acceptOwnership() {
466         if (msg.sender == newOwnerCandidate) {
467             owner = newOwnerCandidate;
468             newOwnerCandidate = address(0);
469 
470             OwnershipTransferred(owner, newOwnerCandidate);
471         }
472     }
473 }
474 
475 /// @title Math operations with safety checks
476 library SaferMath {
477     function mul(uint256 a, uint256 b) internal returns (uint256) {
478         uint256 c = a * b;
479         assert(a == 0 || c / a == b);
480         return c;
481     }
482 
483     function div(uint256 a, uint256 b) internal returns (uint256) {
484         // assert(b > 0); // Solidity automatically throws when dividing by 0
485         uint256 c = a / b;
486         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
487         return c;
488     }
489 
490     function sub(uint256 a, uint256 b) internal returns (uint256) {
491         assert(b <= a);
492         return a - b;
493     }
494 
495     function add(uint256 a, uint256 b) internal returns (uint256) {
496         uint256 c = a + b;
497         assert(c >= a);
498         return c;
499     }
500 
501     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
502         return a >= b ? a : b;
503     }
504 
505     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
506         return a < b ? a : b;
507     }
508 
509     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
510         return a >= b ? a : b;
511     }
512 
513     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
514         return a < b ? a : b;
515     }
516 }
517 
518 
519 /// @title Stox Smart Token
520 contract StoxSmartToken is SmartToken {
521     function StoxSmartToken() SmartToken('Stox', 'STX', 18) {
522         disableTransfers(true);
523     }
524 }
525 
526 
527 /// @title Vesting trustee
528 contract Trustee is Ownable {
529     using SaferMath for uint256;
530 
531     // The address of the STX ERC20 token.
532     StoxSmartToken public stox;
533 
534     struct Grant {
535         uint256 value;
536         uint256 start;
537         uint256 cliff;
538         uint256 end;
539         uint256 transferred;
540         bool revokable;
541     }
542 
543     // Grants holder.
544     mapping (address => Grant) public grants;
545 
546     // Total tokens available for vesting.
547     uint256 public totalVesting;
548 
549     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
550     event UnlockGrant(address indexed _holder, uint256 _value);
551     event RevokeGrant(address indexed _holder, uint256 _refund);
552 
553     /// @dev Constructor that initializes the address of the StoxSmartToken contract.
554     /// @param _stox StoxSmartToken The address of the previously deployed StoxSmartToken smart contract.
555     function Trustee(StoxSmartToken _stox) {
556         require(_stox != address(0));
557 
558         stox = _stox;
559     }
560 
561     /// @dev Grant tokens to a specified address.
562     /// @param _to address The address to grant tokens to.
563     /// @param _value uint256 The amount of tokens to be granted.
564     /// @param _start uint256 The beginning of the vesting period.
565     /// @param _cliff uint256 Duration of the cliff period.
566     /// @param _end uint256 The end of the vesting period.
567     /// @param _revokable bool Whether the grant is revokable or not.
568     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
569         public onlyOwner {
570         require(_to != address(0));
571         require(_value > 0);
572 
573         // Make sure that a single address can be granted tokens only once.
574         require(grants[_to].value == 0);
575 
576         // Check for date inconsistencies that may cause unexpected behavior.
577         require(_start <= _cliff && _cliff <= _end);
578 
579         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
580         require(totalVesting.add(_value) <= stox.balanceOf(address(this)));
581 
582         // Assign a new grant.
583         grants[_to] = Grant({
584             value: _value,
585             start: _start,
586             cliff: _cliff,
587             end: _end,
588             transferred: 0,
589             revokable: _revokable
590         });
591 
592         // Tokens granted, reduce the total amount available for vesting.
593         totalVesting = totalVesting.add(_value);
594 
595         NewGrant(msg.sender, _to, _value);
596     }
597 
598     /// @dev Revoke the grant of tokens of a specifed address.
599     /// @param _holder The address which will have its tokens revoked.
600     function revoke(address _holder) public onlyOwner {
601         Grant grant = grants[_holder];
602 
603         require(grant.revokable);
604 
605         // Send the remaining STX back to the owner.
606         uint256 refund = grant.value.sub(grant.transferred);
607 
608         // Remove the grant.
609         delete grants[_holder];
610 
611         totalVesting = totalVesting.sub(refund);
612         stox.transfer(msg.sender, refund);
613 
614         RevokeGrant(_holder, refund);
615     }
616 
617     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
618     /// @param _holder address The address of the holder.
619     /// @param _time uint256 The specific time.
620     /// @return a uint256 representing a holder's total amount of vested tokens.
621     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
622         Grant grant = grants[_holder];
623         if (grant.value == 0) {
624             return 0;
625         }
626 
627         return calculateVestedTokens(grant, _time);
628     }
629 
630     /// @dev Calculate amount of vested tokens at a specifc time.
631     /// @param _grant Grant The vesting grant.
632     /// @param _time uint256 The time to be checked
633     /// @return An uint256 representing the amount of vested tokens of a specific grant.
634     ///   |                         _/--------   vestedTokens rect
635     ///   |                       _/
636     ///   |                     _/
637     ///   |                   _/
638     ///   |                 _/
639     ///   |                /
640     ///   |              .|
641     ///   |            .  |
642     ///   |          .    |
643     ///   |        .      |
644     ///   |      .        |
645     ///   |    .          |
646     ///   +===+===========+---------+----------> time
647     ///     Start       Cliff      End
648     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
649         // If we're before the cliff, then nothing is vested.
650         if (_time < _grant.cliff) {
651             return 0;
652         }
653 
654         // If we're after the end of the vesting period - everything is vested;
655         if (_time >= _grant.end) {
656             return _grant.value;
657         }
658 
659         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
660          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
661     }
662 
663     /// @dev Unlock vested tokens and transfer them to their holder.
664     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
665     function unlockVestedTokens() public {
666         Grant grant = grants[msg.sender];
667         require(grant.value != 0);
668 
669         // Get the total amount of vested tokens, acccording to grant.
670         uint256 vested = calculateVestedTokens(grant, now);
671         if (vested == 0) {
672             return;
673         }
674 
675         // Make sure the holder doesn't transfer more than what he already has.
676         uint256 transferable = vested.sub(grant.transferred);
677         if (transferable == 0) {
678             return;
679         }
680 
681         grant.transferred = grant.transferred.add(transferable);
682         totalVesting = totalVesting.sub(transferable);
683         stox.transfer(msg.sender, transferable);
684 
685         UnlockGrant(msg.sender, transferable);
686     }
687 }
688 
689 
690 /// @title Stox Smart Token sale
691 contract StoxSmartTokenSale is Ownable {
692     using SaferMath for uint256;
693 
694     uint256 public constant DURATION = 14 days;
695 
696     bool public isFinalized = false;
697     bool public isDistributed = false;
698 
699     // The address of the STX ERC20 token.
700     StoxSmartToken public stox;
701 
702     // The address of the token allocation trustee;
703     Trustee public trustee;
704 
705     uint256 public startTime = 0;
706     uint256 public endTime = 0;
707     address public fundingRecipient;
708 
709     uint256 public tokensSold = 0;
710 
711     // TODO: update to the correct values.
712     uint256 public constant ETH_CAP = 148000;
713     uint256 public constant EXCHANGE_RATE = 200; // 200 STX for ETH
714     uint256 public constant TOKEN_SALE_CAP = ETH_CAP * EXCHANGE_RATE * 10 ** 18;
715 
716     event TokensIssued(address indexed _to, uint256 _tokens);
717 
718     /// @dev Throws if called when not during sale.
719     modifier onlyDuringSale() {
720         if (tokensSold >= TOKEN_SALE_CAP || now < startTime || now >= endTime) {
721             throw;
722         }
723 
724         _;
725     }
726 
727     /// @dev Throws if called before sale ends.
728     modifier onlyAfterSale() {
729         if (!(tokensSold >= TOKEN_SALE_CAP || now >= endTime)) {
730             throw;
731         }
732 
733         _;
734     }
735 
736     /// @dev Constructor that initializes the sale conditions.
737     /// @param _fundingRecipient address The address of the funding recipient.
738     /// @param _startTime uint256 The start time of the token sale.
739     function StoxSmartTokenSale(address _stox, address _fundingRecipient, uint256 _startTime) {
740         require(_stox != address(0));
741         require(_fundingRecipient != address(0));
742         require(_startTime > now);
743 
744         stox = StoxSmartToken(_stox);
745 
746         fundingRecipient = _fundingRecipient;
747         startTime = _startTime;
748         endTime = startTime + DURATION;
749     }
750 
751     /// @dev Distributed tokens to the partners who have participated during the pre-sale.
752     function distributePartnerTokens() external onlyOwner {
753         require(!isDistributed);
754 
755         assert(tokensSold == 0);
756         assert(stox.totalSupply() == 0);
757 
758         // Distribute strategic tokens to partners. Please note, that this address doesn't represent a single entity or
759         // person and will be only used to distribute tokens to 30~ partners.
760         //
761         // Please expect to see token transfers from this address in the first 24 hours after the token sale ends.
762         issueTokens(0x9065260ef6830f6372F1Bde408DeC57Fe3150530, 14800000 * 10 ** 18);
763 
764         isDistributed = true;
765     }
766 
767     /// @dev Finalizes the token sale event.
768     function finalize() external onlyAfterSale {
769         if (isFinalized) {
770             throw;
771         }
772 
773         // Grant vesting grants.
774         //
775         // TODO: use real addresses.
776         trustee = new Trustee(stox);
777 
778         // Since only 50% of the tokens will be sold, we will automatically issue the same amount of sold STX to the
779         // trustee.
780         uint256 unsoldTokens = tokensSold;
781 
782         // Issue 55% of the remaining tokens (== 27.5%) go to strategic parternships.
783         uint256 strategicPartnershipTokens = unsoldTokens.mul(55).div(100);
784 
785         // Note: we will substract the bonus tokens from this grant, since they were already issued for the pre-sale
786         // strategic partners and should've been taken from this allocation.
787         stox.issue(0xbC14105ccDdeAadB96Ba8dCE18b40C45b6bACf58, strategicPartnershipTokens);
788 
789         // Issue the remaining tokens as vesting grants:
790         stox.issue(trustee, unsoldTokens.sub(strategicPartnershipTokens));
791 
792         // 25% of the remaining tokens (== 12.5%) go to Invest.com, at uniform 12 months vesting schedule.
793         trustee.grant(0xb54c6a870d4aD65e23d471Fb7941aD271D323f5E, unsoldTokens.mul(25).div(100), now, now,
794             now.add(1 years), true);
795 
796         // 20% of the remaining tokens (== 10%) go to Stox team, at uniform 24 months vesting schedule.
797         trustee.grant(0x4eB4Cd1D125d9d281709Ff38d65b99a6927b46c1, unsoldTokens.mul(20).div(100), now, now,
798             now.add(2 years), true);
799 
800         // Re-enable transfers after the token sale.
801         stox.disableTransfers(false);
802 
803         isFinalized = true;
804     }
805 
806     /// @dev Create and sell tokens to the caller.
807     /// @param _recipient address The address of the recipient.
808     function create(address _recipient) public payable onlyDuringSale {
809         require(_recipient != address(0));
810         require(msg.value > 0);
811 
812         assert(isDistributed);
813 
814         uint256 tokens = SaferMath.min256(msg.value.mul(EXCHANGE_RATE), TOKEN_SALE_CAP.sub(tokensSold));
815         uint256 contribution = tokens.div(EXCHANGE_RATE);
816 
817         issueTokens(_recipient, tokens);
818 
819         // Transfer the funds to the funding recipient.
820         fundingRecipient.transfer(contribution);
821 
822         // Refund the msg.sender, in the case that not all of its ETH was used. This can happen only when selling the
823         // last chunk of STX.
824         uint256 refund = msg.value.sub(contribution);
825         if (refund > 0) {
826             msg.sender.transfer(refund);
827         }
828     }
829 
830     /// @dev Issues tokens for the recipient.
831     /// @param _recipient address The address of the recipient.
832     /// @param _tokens uint256 The amount of tokens to issue.
833     function issueTokens(address _recipient, uint256 _tokens) private {
834         // Update total sold tokens.
835         tokensSold = tokensSold.add(_tokens);
836 
837         stox.issue(_recipient, _tokens);
838 
839         TokensIssued(_recipient, _tokens);
840     }
841 
842     /// @dev Fallback function that will delegate the request to create.
843     function () external payable onlyDuringSale {
844         create(msg.sender);
845     }
846 
847     /// @dev Proposes to transfer control of the StoxSmartToken contract to a new owner.
848     /// @param _newOwnerCandidate address The address to transfer ownership to.
849     ///
850     /// Note that:
851     ///   1. The new owner will need to call StoxSmartToken's acceptOwnership directly in order to accept the ownership.
852     ///   2. Calling this method during the token sale will prevent the token sale to continue, since only the owner of
853     ///      the StoxSmartToken contract can issue new tokens.
854     function transferSmartTokenOwnership(address _newOwnerCandidate) external onlyOwner {
855         stox.transferOwnership(_newOwnerCandidate);
856     }
857 
858     /// @dev Accepts new ownership on behalf of the StoxSmartToken contract. This can be used, by the token sale
859     /// contract itself to claim back ownership of the StoxSmartToken contract.
860     function acceptSmartTokenOwnership() external onlyOwner {
861         stox.acceptOwnership();
862     }
863 
864     /// @dev Proposes to transfer control of the Trustee contract to a new owner.
865     /// @param _newOwnerCandidate address The address to transfer ownership to.
866     ///
867     /// Note that:
868     ///   1. The new owner will need to call Trustee's acceptOwnership directly in order to accept the ownership.
869     ///   2. Calling this method during the token sale won't be possible, as the Trustee is only created after its
870     ///      finalization.
871     function transferTrusteeOwnership(address _newOwnerCandidate) external onlyOwner {
872         trustee.transferOwnership(_newOwnerCandidate);
873     }
874 
875     /// @dev Accepts new ownership on behalf of the Trustee contract. This can be used, by the token sale
876     /// contract itself to claim back ownership of the Trustee contract.
877     function acceptTrusteeOwnership() external onlyOwner {
878         trustee.acceptOwnership();
879     }
880 }
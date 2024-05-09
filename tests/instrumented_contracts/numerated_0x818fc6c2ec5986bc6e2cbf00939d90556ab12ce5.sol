1 pragma solidity ^0.4.15;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
5 /// and the implementation of "user permissions".
6 contract Ownable {
7     address public owner;
8     address public newOwnerCandidate;
9 
10     event OwnershipRequested(address indexed _by, address indexed _to);
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     /// account.
15     function Ownable() {
16         owner = msg.sender;
17     }
18 
19     /// @dev Reverts if called by any account other than the owner.
20     modifier onlyOwner() {
21         if (msg.sender != owner) {
22             revert();
23         }
24 
25         _;
26     }
27 
28     modifier onlyOwnerCandidate() {
29         if (msg.sender != newOwnerCandidate) {
30             revert();
31         }
32 
33         _;
34     }
35 
36     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
37     /// @param _newOwnerCandidate address The address to transfer ownership to.
38     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
39         require(_newOwnerCandidate != address(0));
40 
41         newOwnerCandidate = _newOwnerCandidate;
42 
43         OwnershipRequested(msg.sender, newOwnerCandidate);
44     }
45 
46     /// @dev Accept ownership transfer. This method needs to be called by the previously proposed owner.
47     function acceptOwnership() external onlyOwnerCandidate {
48         address previousOwner = owner;
49 
50         owner = newOwnerCandidate;
51         newOwnerCandidate = address(0);
52 
53         OwnershipTransferred(previousOwner, owner);
54     }
55 }
56 
57 /// @title Math operations with safety checks
58 library SafeMath {
59     function mul(uint256 a, uint256 b) internal returns (uint256) {
60         uint256 c = a * b;
61         assert(a == 0 || c / a == b);
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal returns (uint256) {
66         // assert(b > 0); // Solidity automatically throws when dividing by 0
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal returns (uint256) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     function add(uint256 a, uint256 b) internal returns (uint256) {
78         uint256 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 
83     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
84         return a >= b ? a : b;
85     }
86 
87     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
88         return a < b ? a : b;
89     }
90 
91     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
92         return a >= b ? a : b;
93     }
94 
95     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
96         return a < b ? a : b;
97     }
98 }
99 
100 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
101 contract ERC20 {
102     uint256 public totalSupply;
103     function balanceOf(address _owner) constant returns (uint256 balance);
104     function transfer(address _to, uint256 _value) returns (bool success);
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
106     function approve(address _spender, uint256 _value) returns (bool success);
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }
111 
112 
113 /// @title Basic ERC20 token contract implementation.
114 /// @dev Based on OpenZeppelin's StandardToken.
115 contract BasicToken is ERC20 {
116     using SafeMath for uint256;
117 
118     uint256 public totalSupply;
119     mapping (address => mapping (address => uint256)) allowed;
120     mapping (address => uint256) balances;
121 
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126     /// @param _spender address The address which will spend the funds.
127     /// @param _value uint256 The amount of tokens to be spent.
128     function approve(address _spender, uint256 _value) public returns (bool) {
129         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
131             revert();
132         }
133 
134         allowed[msg.sender][_spender] = _value;
135 
136         Approval(msg.sender, _spender, _value);
137 
138         return true;
139     }
140 
141     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
142     /// @param _owner address The address which owns the funds.
143     /// @param _spender address The address which will spend the funds.
144     /// @return uint256 specifying the amount of tokens still available for the spender.
145     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 
149 
150     /// @dev Gets the balance of the specified address.
151     /// @param _owner address The address to query the the balance of.
152     /// @return uint256 representing the amount owned by the passed address.
153     function balanceOf(address _owner) constant returns (uint256 balance) {
154         return balances[_owner];
155     }
156 
157     /// @dev transfer token to a specified address.
158     /// @param _to address The address to transfer to.
159     /// @param _value uint256 The amount to be transferred.
160     function transfer(address _to, uint256 _value) public returns (bool) {
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163 
164         Transfer(msg.sender, _to, _value);
165 
166         return true;
167     }
168 
169     /// @dev Transfer tokens from one address to another.
170     /// @param _from address The address which you want to send tokens from.
171     /// @param _to address The address which you want to transfer to.
172     /// @param _value uint256 the amount of tokens to be transferred.
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174         uint256 _allowance = allowed[_from][msg.sender];
175 
176         balances[_from] = balances[_from].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178 
179         allowed[_from][msg.sender] = _allowance.sub(_value);
180 
181         Transfer(_from, _to, _value);
182 
183         return true;
184     }
185 }
186 
187 
188 /// @title Token holder contract.
189 contract TokenHolder is Ownable {
190     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
191     /// @param _tokenAddress address The address of the ERC20 contract.
192     /// @param _amount uint256 The amount of tokens to be transferred.
193     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) onlyOwner returns (bool success) {
194         return ERC20(_tokenAddress).transfer(owner, _amount);
195     }
196 }
197 
198 
199 /// @title Kin token contract.
200 contract KinToken is Ownable, BasicToken, TokenHolder {
201     using SafeMath for uint256;
202 
203     string public constant name = "Kin";
204     string public constant symbol = "KIN";
205 
206     // Using same decimal value as ETH (makes ETH-KIN conversion much easier).
207     uint8 public constant decimals = 18;
208 
209     // States whether creating more tokens is allowed or not.
210     // Used during token sale.
211     bool public isMinting = true;
212 
213     event MintingEnded();
214 
215     modifier onlyDuringMinting() {
216         require(isMinting);
217 
218         _;
219     }
220 
221     modifier onlyAfterMinting() {
222         require(!isMinting);
223 
224         _;
225     }
226 
227     /// @dev Mint Kin tokens.
228     /// @param _to address Address to send minted Kin to.
229     /// @param _amount uint256 Amount of Kin tokens to mint.
230     function mint(address _to, uint256 _amount) external onlyOwner onlyDuringMinting {
231         totalSupply = totalSupply.add(_amount);
232         balances[_to] = balances[_to].add(_amount);
233 
234         Transfer(0x0, _to, _amount);
235     }
236 
237     /// @dev End minting mode.
238     function endMinting() external onlyOwner {
239         if (isMinting == false) {
240             return;
241         }
242 
243         isMinting = false;
244 
245         MintingEnded();
246     }
247 
248     /// @dev Same ERC20 behavior, but reverts if still minting.
249     /// @param _spender address The address which will spend the funds.
250     /// @param _value uint256 The amount of tokens to be spent.
251     function approve(address _spender, uint256 _value) public onlyAfterMinting returns (bool) {
252         return super.approve(_spender, _value);
253     }
254 
255     /// @dev Same ERC20 behavior, but reverts if still minting.
256     /// @param _to address The address to transfer to.
257     /// @param _value uint256 The amount to be transferred.
258     function transfer(address _to, uint256 _value) public onlyAfterMinting returns (bool) {
259         return super.transfer(_to, _value);
260     }
261 
262     /// @dev Same ERC20 behavior, but reverts if still minting.
263     /// @param _from address The address which you want to send tokens from.
264     /// @param _to address The address which you want to transfer to.
265     /// @param _value uint256 the amount of tokens to be transferred.
266     function transferFrom(address _from, address _to, uint256 _value) public onlyAfterMinting returns (bool) {
267         return super.transferFrom(_from, _to, _value);
268     }
269 }
270 
271 
272 /// @title Vesting trustee contract for Kin token.
273 contract VestingTrustee is Ownable {
274     using SafeMath for uint256;
275 
276     // Kin token contract.
277     KinToken public kin;
278 
279     // Vesting grant for a speicifc holder.
280     struct Grant {
281         uint256 value;
282         uint256 start;
283         uint256 cliff;
284         uint256 end;
285         uint256 installmentLength; // In seconds.
286         uint256 transferred;
287         bool revokable;
288     }
289 
290     // Holder to grant information mapping.
291     mapping (address => Grant) public grants;
292 
293     // Total tokens available for vesting.
294     uint256 public totalVesting;
295 
296     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
297     event TokensUnlocked(address indexed _to, uint256 _value);
298     event GrantRevoked(address indexed _holder, uint256 _refund);
299 
300     /// @dev Constructor that initializes the address of the Kin token contract.
301     /// @param _kin KinToken The address of the previously deployed Kin token contract.
302     function VestingTrustee(KinToken _kin) {
303         require(_kin != address(0));
304 
305         kin = _kin;
306     }
307 
308     /// @dev Grant tokens to a specified address. Please note, that the trustee must have enough ungranted tokens to
309     /// accomodate the new grant. Otherwise, the call with fail.
310     /// @param _to address The holder address.
311     /// @param _value uint256 The amount of tokens to be granted.
312     /// @param _start uint256 The beginning of the vesting period.
313     /// @param _cliff uint256 Duration of the cliff period (when the first installment is made).
314     /// @param _end uint256 The end of the vesting period.
315     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
316     /// @param _revokable bool Whether the grant is revokable or not.
317     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
318         uint256 _installmentLength, bool _revokable)
319         external onlyOwner {
320 
321         require(_to != address(0));
322         require(_to != address(this)); // Protect this contract from receiving a grant.
323         require(_value > 0);
324 
325         // Require that every holder can be granted tokens only once.
326         require(grants[_to].value == 0);
327 
328         // Require for time ranges to be consistent and valid.
329         require(_start <= _cliff && _cliff <= _end);
330 
331         // Require installment length to be valid and no longer than (end - start).
332         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
333 
334         // Grant must not exceed the total amount of tokens currently available for vesting.
335         require(totalVesting.add(_value) <= kin.balanceOf(address(this)));
336 
337         // Assign a new grant.
338         grants[_to] = Grant({
339             value: _value,
340             start: _start,
341             cliff: _cliff,
342             end: _end,
343             installmentLength: _installmentLength,
344             transferred: 0,
345             revokable: _revokable
346         });
347 
348         // Since tokens have been granted, reduce the total amount available for vesting.
349         totalVesting = totalVesting.add(_value);
350 
351         NewGrant(msg.sender, _to, _value);
352     }
353 
354     /// @dev Revoke the grant of tokens of a specifed address.
355     /// @param _holder The address which will have its tokens revoked.
356     function revoke(address _holder) public onlyOwner {
357         Grant memory grant = grants[_holder];
358 
359         // Grant must be revokable.
360         require(grant.revokable);
361 
362         // Calculate amount of remaining tokens that can still be returned.
363         uint256 refund = grant.value.sub(grant.transferred);
364 
365         // Remove the grant.
366         delete grants[_holder];
367 
368         // Update total vesting amount and transfer previously calculated tokens to owner.
369         totalVesting = totalVesting.sub(refund);
370         kin.transfer(msg.sender, refund);
371 
372         GrantRevoked(_holder, refund);
373     }
374 
375     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
376     /// @param _holder address The address of the holder.
377     /// @param _time uint256 The specific time to calculate against.
378     /// @return a uint256 Representing a holder's total amount of vested tokens.
379     function vestedTokens(address _holder, uint256 _time) external constant returns (uint256) {
380         Grant memory grant = grants[_holder];
381         if (grant.value == 0) {
382             return 0;
383         }
384 
385         return calculateVestedTokens(grant, _time);
386     }
387 
388     /// @dev Calculate amount of vested tokens at a specifc time.
389     /// @param _grant Grant The vesting grant.
390     /// @param _time uint256 The time to be checked
391     /// @return An uint256 Representing the amount of vested tokens of a specific grant.
392     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
393         // If we're before the cliff, then nothing is vested.
394         if (_time < _grant.cliff) {
395             return 0;
396         }
397 
398         // If we're after the end of the vesting period - everything is vested;
399         if (_time >= _grant.end) {
400             return _grant.value;
401         }
402 
403         // Calculate amount of installments past until now.
404         //
405         // NOTE result gets floored because of integer division.
406         uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
407 
408         // Calculate amount of days in entire vesting period.
409         uint256 vestingDays = _grant.end.sub(_grant.start);
410 
411         // Calculate and return the number of tokens according to vesting days that have passed.
412         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
413     }
414 
415     /// @dev Unlock vested tokens and transfer them to the grantee.
416     function unlockVestedTokens() external {
417         Grant storage grant = grants[msg.sender];
418 
419         // Make sure the grant has tokens available.
420         require(grant.value != 0);
421 
422         // Get the total amount of vested tokens, acccording to grant.
423         uint256 vested = calculateVestedTokens(grant, now);
424         if (vested == 0) {
425             return;
426         }
427 
428         // Make sure the holder doesn't transfer more than what he already has.
429         uint256 transferable = vested.sub(grant.transferred);
430         if (transferable == 0) {
431             return;
432         }
433 
434         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
435         grant.transferred = grant.transferred.add(transferable);
436         totalVesting = totalVesting.sub(transferable);
437         kin.transfer(msg.sender, transferable);
438 
439         TokensUnlocked(msg.sender, transferable);
440     }
441 }
442 
443 
444 /// @title Kin token sale contract.
445 contract KinTokenSale is Ownable, TokenHolder {
446     using SafeMath for uint256;
447 
448     // External parties:
449 
450     // KIN token contract.
451     KinToken public kin;
452 
453     // Vesting contract for pre-sale participants.
454     VestingTrustee public trustee;
455 
456     // Received funds are forwarded to this address.
457     address public fundingRecipient;
458 
459     // Kin token unit.
460     // Using same decimal value as ETH (makes ETH-KIN conversion much easier).
461     // This is the same as in Kin token contract.
462     uint256 public constant TOKEN_UNIT = 10 ** 18;
463 
464     // Maximum number of tokens in circulation: 10 trillion.
465     uint256 public constant MAX_TOKENS = 10 ** 13 * TOKEN_UNIT;
466 
467     // Maximum tokens offered in the sale.
468     uint256 public constant MAX_TOKENS_SOLD = 512195121951 * TOKEN_UNIT;
469 
470     // Wei to 1 USD ratio.
471     uint256 public constant WEI_PER_USD = uint256(1 ether) / 289;
472 
473     // KIN to 1 USD ratio,
474     // such that MAX_TOKENS_SOLD / KIN_PER_USD is the $75M cap.
475     uint256 public constant KIN_PER_USD = 6829 * TOKEN_UNIT;
476 
477     // KIN to 1 wei ratio.
478     uint256 public constant KIN_PER_WEI = KIN_PER_USD / WEI_PER_USD;
479 
480     // Sale start and end timestamps.
481     uint256 public constant SALE_DURATION = 14 days;
482     uint256 public startTime;
483     uint256 public endTime;
484 
485     // Amount of tokens sold until now in the sale.
486     uint256 public tokensSold = 0;
487 
488     // Participation caps, according to KYC tiers.
489     uint256 public constant TIER_1_CAP = 100000 * WEI_PER_USD;
490     uint256 public constant TIER_2_CAP = uint256(-1); // Maximum uint256 value
491 
492     // Accumulated amount each participant has contributed so far.
493     mapping (address => uint256) public participationHistory;
494 
495     // Maximum amount that each participant is allowed to contribute (in WEI).
496     mapping (address => uint256) public participationCaps;
497 
498     // Maximum amount ANYBODY is currently allowed to contribute.
499     uint256 public hardParticipationCap = 4393 * WEI_PER_USD;
500 
501     // Vesting information for special addresses:
502     struct TokenGrant {
503         uint256 value;
504         uint256 startOffset;
505         uint256 cliffOffset;
506         uint256 endOffset;
507         uint256 installmentLength;
508         uint8 percentVested;
509     }
510 
511     address[] public tokenGrantees;
512     mapping (address => TokenGrant) public tokenGrants;
513     uint256 public lastGrantedIndex = 0;
514     uint256 public constant MAX_TOKEN_GRANTEES = 100;
515     uint256 public constant GRANT_BATCH_SIZE = 10;
516 
517     // Post-TDE multisig addresses.
518     address public constant KIN_FOUNDATION_ADDRESS = 0x56aE76573EC54754bC5B6A8cBF04bBd7Dc86b0A0;
519     address public constant KIK_ADDRESS = 0x3bf4BbE253153678E9E8E540395C22BFf7fCa87d;
520 
521     event TokensIssued(address indexed _to, uint256 _tokens);
522 
523     /// @dev Reverts if called when not during sale.
524     modifier onlyDuringSale() {
525         require(!saleEnded() && now >= startTime);
526 
527         _;
528     }
529 
530     /// @dev Reverts if called before sale ends.
531     modifier onlyAfterSale() {
532         require(saleEnded());
533 
534         _;
535     }
536 
537     /// @dev Constructor that initializes the sale conditions.
538     /// @param _fundingRecipient address The address of the funding recipient.
539     /// @param _startTime uint256 The start time of the token sale.
540     function KinTokenSale(address _fundingRecipient, uint256 _startTime) {
541         require(_fundingRecipient != address(0));
542         require(_startTime > now);
543 
544         // Deploy new KinToken contract.
545         kin = new KinToken();
546 
547         // Deploy new VestingTrustee contract.
548         trustee = new VestingTrustee(kin);
549 
550         fundingRecipient = _fundingRecipient;
551         startTime = _startTime;
552         endTime = startTime + SALE_DURATION;
553 
554         // Initialize special vesting grants.
555         initTokenGrants();
556     }
557 
558     /// @dev Initialize token grants.
559     function initTokenGrants() private onlyOwner {
560         // Issue the remaining 60% to Kin Foundation's multisig wallet. In a few days, after the token sale is
561         // finalized, these tokens will be loaded into the KinVestingTrustee smart contract, according to the white
562         // paper. Please note, that this is implied by setting a 0% vesting percent.
563         tokenGrantees.push(KIN_FOUNDATION_ADDRESS);
564         tokenGrants[KIN_FOUNDATION_ADDRESS] = TokenGrant(MAX_TOKENS.mul(60).div(100), 0, 0, 3 years, 1 days, 0);
565 
566         // Kik, 30%
567         tokenGrantees.push(KIK_ADDRESS);
568         tokenGrants[KIK_ADDRESS] = TokenGrant(MAX_TOKENS.mul(30).div(100), 0, 0, 120 weeks, 12 weeks, 100);
569     }
570 
571     /// @dev Adds a Kin token vesting grant.
572     /// @param _grantee address The address of the token grantee. Can be granted only once.
573     /// @param _value uint256 The value of the grant.
574     function addTokenGrant(address _grantee, uint256 _value) external onlyOwner {
575         require(_grantee != address(0));
576         require(_value > 0);
577         require(tokenGrantees.length + 1 <= MAX_TOKEN_GRANTEES);
578 
579         // Verify the grant doesn't already exist.
580         require(tokenGrants[_grantee].value == 0);
581         for (uint i = 0; i < tokenGrantees.length; i++) {
582             require(tokenGrantees[i] != _grantee);
583         }
584 
585         // Add grant and add to grantee list.
586         tokenGrantees.push(_grantee);
587         tokenGrants[_grantee] = TokenGrant(_value, 0, 1 years, 1 years, 1 days, 50);
588     }
589 
590     /// @dev Deletes a Kin token grant.
591     /// @param _grantee address The address of the token grantee.
592     function deleteTokenGrant(address _grantee) external onlyOwner {
593         require(_grantee != address(0));
594 
595         // Delete the grant from the keys array.
596         for (uint i = 0; i < tokenGrantees.length; i++) {
597             if (tokenGrantees[i] == _grantee) {
598                 delete tokenGrantees[i];
599 
600                 break;
601             }
602         }
603 
604         // Delete the grant from the mapping.
605         delete tokenGrants[_grantee];
606     }
607 
608     /// @dev Add a list of participants to a capped participation tier.
609     /// @param _participants address[] The list of participant addresses.
610     /// @param _cap uint256 The cap amount (in ETH).
611     function setParticipationCap(address[] _participants, uint256 _cap) private onlyOwner {
612         for (uint i = 0; i < _participants.length; i++) {
613             participationCaps[_participants[i]] = _cap;
614         }
615     }
616 
617     /// @dev Add a list of participants to cap tier #1.
618     /// @param _participants address[] The list of participant addresses.
619     function setTier1Participants(address[] _participants) external onlyOwner {
620         setParticipationCap(_participants, TIER_1_CAP);
621     }
622 
623     /// @dev Add a list of participants to tier #2.
624     /// @param _participants address[] The list of participant addresses.
625     function setTier2Participants(address[] _participants) external onlyOwner {
626         setParticipationCap(_participants, TIER_2_CAP);
627     }
628 
629     /// @dev Set hard participation cap for all participants.
630     /// @param _cap uint256 The hard cap amount.
631     function setHardParticipationCap(uint256 _cap) external onlyOwner {
632         require(_cap > 0);
633 
634         hardParticipationCap = _cap;
635     }
636 
637     /// @dev Fallback function that will delegate the request to create().
638     function () external payable onlyDuringSale {
639         create(msg.sender);
640     }
641 
642     /// @dev Create and sell tokens to the caller.
643     /// @param _recipient address The address of the recipient receiving the tokens.
644     function create(address _recipient) public payable onlyDuringSale {
645         require(_recipient != address(0));
646 
647         // Enforce participation cap (in Wei received).
648         uint256 weiAlreadyParticipated = participationHistory[msg.sender];
649         uint256 participationCap = SafeMath.min256(participationCaps[msg.sender], hardParticipationCap);
650         uint256 cappedWeiReceived = SafeMath.min256(msg.value, participationCap.sub(weiAlreadyParticipated));
651         require(cappedWeiReceived > 0);
652 
653         // Accept funds and transfer to funding recipient.
654         uint256 weiLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold).div(KIN_PER_WEI);
655         uint256 weiToParticipate = SafeMath.min256(cappedWeiReceived, weiLeftInSale);
656         participationHistory[msg.sender] = weiAlreadyParticipated.add(weiToParticipate);
657         fundingRecipient.transfer(weiToParticipate);
658 
659         // Issue tokens and transfer to recipient.
660         uint256 tokensLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold);
661         uint256 tokensToIssue = weiToParticipate.mul(KIN_PER_WEI);
662         if (tokensLeftInSale.sub(tokensToIssue) < KIN_PER_WEI) {
663             // If purchase would cause less than KIN_PER_WEI tokens left then nobody could ever buy them.
664             // So, gift them to the last buyer.
665             tokensToIssue = tokensLeftInSale;
666         }
667         tokensSold = tokensSold.add(tokensToIssue);
668         issueTokens(_recipient, tokensToIssue);
669 
670         // Partial refund if full participation not possible
671         // e.g. due to cap being reached.
672         uint256 refund = msg.value.sub(weiToParticipate);
673         if (refund > 0) {
674             msg.sender.transfer(refund);
675         }
676     }
677 
678     /// @dev Finalizes the token sale event, by stopping token minting.
679     function finalize() external onlyAfterSale onlyOwner {
680         if (!kin.isMinting()) {
681             revert();
682         }
683 
684         require(lastGrantedIndex == tokenGrantees.length);
685 
686         // Finish minting.
687         kin.endMinting();
688     }
689 
690     /// @dev Grants pre-configured token grants in batches. When the method is called, it'll resume from the last grant,
691     /// from its previous run, and will finish either after granting GRANT_BATCH_SIZE grants or finishing the whole list
692     /// of grants.
693     function grantTokens() external onlyAfterSale onlyOwner {
694         uint endIndex = SafeMath.min256(tokenGrantees.length, lastGrantedIndex + GRANT_BATCH_SIZE);
695         for (uint i = lastGrantedIndex; i < endIndex; i++) {
696             address grantee = tokenGrantees[i];
697 
698             // Calculate how many tokens have been granted, vested, and issued such that: granted = vested + issued.
699             TokenGrant memory tokenGrant = tokenGrants[grantee];
700             uint256 tokensGranted = tokenGrant.value.mul(tokensSold).div(MAX_TOKENS_SOLD);
701             uint256 tokensVesting = tokensGranted.mul(tokenGrant.percentVested).div(100);
702             uint256 tokensIssued = tokensGranted.sub(tokensVesting);
703 
704             // Transfer issued tokens that have yet to be transferred to grantee.
705             if (tokensIssued > 0) {
706                 issueTokens(grantee, tokensIssued);
707             }
708 
709             // Transfer vested tokens that have yet to be transferred to vesting trustee, and initialize grant.
710             if (tokensVesting > 0) {
711                 issueTokens(trustee, tokensVesting);
712                 trustee.grant(grantee, tokensVesting, now.add(tokenGrant.startOffset), now.add(tokenGrant.cliffOffset),
713                     now.add(tokenGrant.endOffset), tokenGrant.installmentLength, true);
714             }
715 
716             lastGrantedIndex++;
717         }
718     }
719 
720     /// @dev Issues tokens for the recipient.
721     /// @param _recipient address The address of the recipient.
722     /// @param _tokens uint256 The amount of tokens to issue.
723     function issueTokens(address _recipient, uint256 _tokens) private {
724         // Request Kin token contract to mint the requested tokens for the buyer.
725         kin.mint(_recipient, _tokens);
726 
727         TokensIssued(_recipient, _tokens);
728     }
729 
730     /// @dev Returns whether the sale has ended.
731     /// @return bool Whether the sale has ended or not.
732     function saleEnded() private constant returns (bool) {
733         return tokensSold >= MAX_TOKENS_SOLD || now >= endTime;
734     }
735 
736     /// @dev Requests to transfer control of the Kin token contract to a new owner.
737     /// @param _newOwnerCandidate address The address to transfer ownership to.
738     ///
739     /// NOTE:
740     ///   1. The new owner will need to call Kin token contract's acceptOwnership directly in order to accept the ownership.
741     ///   2. Calling this method during the token sale will prevent the token sale to continue, since only the owner of
742     ///      the Kin token contract can issue new tokens.
743     function requestKinTokenOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
744         kin.requestOwnershipTransfer(_newOwnerCandidate);
745     }
746 
747     /// @dev Accepts new ownership on behalf of the Kin token contract.
748     // This can be used by the sale contract itself to claim back ownership of the Kin token contract.
749     function acceptKinTokenOwnership() external onlyOwner {
750         kin.acceptOwnership();
751     }
752 
753     /// @dev Requests to transfer control of the VestingTrustee contract to a new owner.
754     /// @param _newOwnerCandidate address The address to transfer ownership to.
755     ///
756     /// NOTE:
757     ///   1. The new owner will need to call VestingTrustee's acceptOwnership directly in order to accept the ownership.
758     ///   2. Calling this method during the token sale will prevent the token sale from finalizaing, since only the owner
759     ///      of the VestingTrustee contract can issue new token grants.
760     function requestVestingTrusteeOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
761         trustee.requestOwnershipTransfer(_newOwnerCandidate);
762     }
763 
764     /// @dev Accepts new ownership on behalf of the VestingTrustee contract.
765     /// This can be used by the token sale contract itself to claim back ownership of the VestingTrustee contract.
766     function acceptVestingTrusteeOwnership() external onlyOwner {
767         trustee.acceptOwnership();
768     }
769 }
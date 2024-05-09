1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract BasicToken is ERC20 {
15     using SafeMath for uint256;
16 
17     uint256 public totalSupply;
18     mapping (address => mapping (address => uint256)) allowed;
19     mapping (address => uint256) balances;
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
25     /// @param _spender address The address which will spend the funds.
26     /// @param _value uint256 The amount of tokens to be spent.
27     function approve(address _spender, uint256 _value) public returns (bool) {
28         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
29         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
30             revert();
31         }
32 
33         allowed[msg.sender][_spender] = _value;
34 
35         Approval(msg.sender, _spender, _value);
36 
37         return true;
38     }
39 
40     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
41     /// @param _owner address The address which owns the funds.
42     /// @param _spender address The address which will spend the funds.
43     /// @return uint256 specifying the amount of tokens still available for the spender.
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
45         return allowed[_owner][_spender];
46     }
47 
48 
49     /// @dev Gets the balance of the specified address.
50     /// @param _owner address The address to query the the balance of.
51     /// @return uint256 representing the amount owned by the passed address.
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     /// @dev transfer token to a specified address.
57     /// @param _to address The address to transfer to.
58     /// @param _value uint256 The amount to be transferred.
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62 
63         Transfer(msg.sender, _to, _value);
64 
65         return true;
66     }
67 
68     /// @dev Transfer tokens from one address to another.
69     /// @param _from address The address which you want to send tokens from.
70     /// @param _to address The address which you want to transfer to.
71     /// @param _value uint256 the amount of tokens to be transferred.
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73         uint256 _allowance = allowed[_from][msg.sender];
74 
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77 
78         allowed[_from][msg.sender] = _allowance.sub(_value);
79 
80         Transfer(_from, _to, _value);
81 
82         return true;
83     }
84 }
85 
86 contract Ownable {
87     address public owner;
88     address public newOwnerCandidate;
89 
90     event OwnershipRequested(address indexed _by, address indexed _to);
91     event OwnershipTransferred(address indexed _from, address indexed _to);
92 
93     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
94     /// account.
95     function Ownable() {
96         owner = msg.sender;
97     }
98 
99     /// @dev Reverts if called by any account other than the owner.
100     modifier onlyOwner() {
101         if (msg.sender != owner) {
102             revert();
103         }
104 
105         _;
106     }
107 
108     modifier onlyOwnerCandidate() {
109         if (msg.sender != newOwnerCandidate) {
110             revert();
111         }
112 
113         _;
114     }
115 
116     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
117     /// @param _newOwnerCandidate address The address to transfer ownership to.
118     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
119         require(_newOwnerCandidate != address(0));
120 
121         newOwnerCandidate = _newOwnerCandidate;
122 
123         OwnershipRequested(msg.sender, newOwnerCandidate);
124     }
125 
126     /// @dev Accept ownership transfer. This method needs to be called by the previously proposed owner.
127     function acceptOwnership() external onlyOwnerCandidate {
128         address previousOwner = owner;
129 
130         owner = newOwnerCandidate;
131         newOwnerCandidate = address(0);
132 
133         OwnershipTransferred(previousOwner, owner);
134     }
135 }
136 
137 library SafeMath {
138     function mul(uint256 a, uint256 b) internal returns (uint256) {
139         uint256 c = a * b;
140         assert(a == 0 || c / a == b);
141         return c;
142     }
143 
144     function div(uint256 a, uint256 b) internal returns (uint256) {
145         // assert(b > 0); // Solidity automatically throws when dividing by 0
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148         return c;
149     }
150 
151     function sub(uint256 a, uint256 b) internal returns (uint256) {
152         assert(b <= a);
153         return a - b;
154     }
155 
156     function add(uint256 a, uint256 b) internal returns (uint256) {
157         uint256 c = a + b;
158         assert(c >= a);
159         return c;
160     }
161 
162     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
163         return a >= b ? a : b;
164     }
165 
166     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
167         return a < b ? a : b;
168     }
169 
170     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
171         return a >= b ? a : b;
172     }
173 
174     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
175         return a < b ? a : b;
176     }
177 }
178 
179 contract TokenHolder is Ownable {
180     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
181     /// @param _tokenAddress address The address of the ERC20 contract.
182     /// @param _amount uint256 The amount of tokens to be transferred.
183     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) onlyOwner returns (bool success) {
184         return ERC20(_tokenAddress).transfer(owner, _amount);
185     }
186 }
187 
188 contract BlokToken is Ownable, BasicToken, TokenHolder {
189     using SafeMath for uint256;
190 
191     string public constant name = "Blok";
192     string public constant symbol = "BLO";
193 
194     // Using same decimal value as ETH (makes ETH-BLO conversion much easier).
195     uint8 public constant decimals = 18;
196 
197     // States whether creating more tokens is allowed or not.
198     // Used during token sale.
199     bool public isMinting = true;
200 
201     event MintingEnded();
202 
203     modifier onlyDuringMinting() {
204         require(isMinting);
205 
206         _;
207     }
208 
209     modifier onlyAfterMinting() {
210         require(!isMinting);
211 
212         _;
213     }
214 
215     /// @dev Mint Blok tokens.
216     /// @param _to address Address to send minted Blok to.
217     /// @param _amount uint256 Amount of Blok tokens to mint.
218     function mint(address _to, uint256 _amount) external onlyOwner onlyDuringMinting {
219         totalSupply = totalSupply.add(_amount);
220         balances[_to] = balances[_to].add(_amount);
221 
222         Transfer(0x0, _to, _amount);
223     }
224 
225     /// @dev End minting mode.
226     function endMinting() external onlyOwner {
227         if (isMinting == false) {
228             return;
229         }
230 
231         isMinting = false;
232 
233         MintingEnded();
234     }
235 
236     /// @dev Same ERC20 behavior, but reverts if still minting.
237     /// @param _spender address The address which will spend the funds.
238     /// @param _value uint256 The amount of tokens to be spent.
239     function approve(address _spender, uint256 _value) public onlyAfterMinting returns (bool) {
240         return super.approve(_spender, _value);
241     }
242 
243     /// @dev Same ERC20 behavior, but reverts if still minting.
244     /// @param _to address The address to transfer to.
245     /// @param _value uint256 The amount to be transferred.
246     function transfer(address _to, uint256 _value) public onlyAfterMinting returns (bool) {
247         return super.transfer(_to, _value);
248     }
249 
250     /// @dev Same ERC20 behavior, but reverts if still minting.
251     /// @param _from address The address which you want to send tokens from.
252     /// @param _to address The address which you want to transfer to.
253     /// @param _value uint256 the amount of tokens to be transferred.
254     function transferFrom(address _from, address _to, uint256 _value) public onlyAfterMinting returns (bool) {
255         return super.transferFrom(_from, _to, _value);
256     }
257 }
258 
259 contract BlokTokenSale is Ownable, TokenHolder {
260     using SafeMath for uint256;
261 
262     // External parties:
263 
264     // BLO token contract.
265     BlokToken public blok;
266 
267     // Vesting contract for pre-sale participants.
268     VestingTrustee public trustee;
269 
270     // Received funds are forwarded to this address.
271     address public fundingRecipient;
272 
273     // Blok token unit.
274     // Using same decimal value as ETH (makes ETH-BLO conversion much easier).
275     // This is the same as in Blok token contract.
276     uint256 public constant TOKEN_UNIT = 10 ** 18;
277 
278     // Maximum number of tokens in circulation: 10 trillion.
279     uint256 public constant MAX_TOKENS = 360000000 * TOKEN_UNIT;
280 
281     // Maximum tokens offered in the sale.
282     uint256 public constant MAX_TOKENS_SOLD = 234000000 * TOKEN_UNIT;
283 
284     // BLO to 1 wei ratio.
285     uint256 public constant BLO_PER_WEI = 5700;
286 
287     // Sale start and end timestamps.
288     uint256 public constant SALE_DURATION = 30 days;
289     uint256 public startTime;
290     uint256 public endTime;
291 
292     // Amount of tokens sold until now in the sale.
293     uint256 public tokensSold = 0;
294 
295     // Participation caps, according to KYC tiers.
296     uint256 public constant TIER_1_CAP = 20000 ether; // Maximum uint256 value
297 
298     // Accumulated amount each participant has contributed so far.
299     mapping (address => uint256) public participationHistory;
300 
301     // Maximum amount that each participant is allowed to contribute (in WEI).
302     mapping (address => uint256) public participationCaps;
303 
304     // Maximum amount ANYBODY is currently allowed to contribute.
305     uint256 public hardParticipationCap = uint256(-1);
306 
307     // Vesting information for special addresses:
308     struct TokenGrant {
309         uint256 value;
310         uint256 startOffset;
311         uint256 cliffOffset;
312         uint256 endOffset;
313         uint256 installmentLength;
314         uint8 percentVested;
315     }
316 
317     address[] public tokenGrantees;
318     mapping (address => TokenGrant) public tokenGrants;
319     uint256 public lastGrantedIndex = 0;
320     uint256 public constant MAX_TOKEN_GRANTEES = 100;
321     uint256 public constant GRANT_BATCH_SIZE = 10;
322 
323     address public constant RESERVE_TOKENS = 0xA67E1c56A5e0363B61a23670FFC0FcD8F09f178d;
324     address public constant TEAM_WALLET = 0x52aA6A62404107742ac01Ff247ED47b49b16c40A;
325     address public constant BOUNTY_WALLET = 0xCf1e64Ce2740A03192F1d7a3234AABd88c025c4B;    
326 
327     event TokensIssued(address indexed _to, uint256 _tokens);
328 
329     /// @dev Reverts if called when not during sale.
330     modifier onlyDuringSale() {
331         require(!saleEnded() && now >= startTime);
332 
333         _;
334     }
335 
336     /// @dev Reverts if called before sale ends.
337     modifier onlyAfterSale() {
338         require(saleEnded());
339 
340         _;
341     }
342 
343     /// @dev Constructor that initializes the sale conditions.
344     /// @param _fundingRecipient address The address of the funding recipient.
345     /// @param _startTime uint256 The start time of the token sale.
346     function BlokTokenSale(address _fundingRecipient, uint256 _startTime) {
347         require(_fundingRecipient != address(0));
348         require(_startTime > now);
349 
350         // Deploy new BlokToken contract.
351         blok = new BlokToken();
352 
353         // Deploy new VestingTrustee contract.
354         trustee = new VestingTrustee(blok);
355 
356         fundingRecipient = _fundingRecipient;
357         startTime = _startTime;
358         endTime = startTime + SALE_DURATION;
359 
360         // Initialize special vesting grants.
361         initTokenGrants();
362     }
363 
364     /// @dev Initialize token grants.
365     function initTokenGrants() private onlyOwner {
366         tokenGrantees.push(RESERVE_TOKENS);
367         tokenGrants[RESERVE_TOKENS] = TokenGrant(MAX_TOKENS.mul(18).div(100), 0, 0, 10 days, 1 days, 0);
368 
369         tokenGrantees.push(TEAM_WALLET);
370         tokenGrants[TEAM_WALLET] = TokenGrant(MAX_TOKENS.mul(13).div(100), 0, 0, 10 days, 1 days, 0);
371 
372         tokenGrantees.push(BOUNTY_WALLET);
373         tokenGrants[BOUNTY_WALLET] = TokenGrant(MAX_TOKENS.mul(4).div(100), 0, 0, 10 days, 1 days, 0);
374     }
375 
376     /// @dev Adds a Blok token vesting grant.
377     /// @param _grantee address The address of the token grantee. Can be granted only once.
378     /// @param _value uint256 The value of the grant.
379     function addTokenGrant(address _grantee, uint256 _value) external onlyOwner {
380         require(_grantee != address(0));
381         require(_value > 0);
382         require(tokenGrantees.length + 1 <= MAX_TOKEN_GRANTEES);
383 
384         // Verify the grant doesn't already exist.
385         require(tokenGrants[_grantee].value == 0);
386         for (uint i = 0; i < tokenGrantees.length; i++) {
387             require(tokenGrantees[i] != _grantee);
388         }
389 
390         // Add grant and add to grantee list.
391         tokenGrantees.push(_grantee);
392         tokenGrants[_grantee] = TokenGrant(_value, 0, 1 years, 1 years, 1 days, 50);
393     }
394 
395     /// @dev Deletes a Blok token grant.
396     /// @param _grantee address The address of the token grantee.
397     function deleteTokenGrant(address _grantee) external onlyOwner {
398         require(_grantee != address(0));
399 
400         // Delete the grant from the keys array.
401         for (uint i = 0; i < tokenGrantees.length; i++) {
402             if (tokenGrantees[i] == _grantee) {
403                 delete tokenGrantees[i];
404 
405                 break;
406             }
407         }
408 
409         // Delete the grant from the mapping.
410         delete tokenGrants[_grantee];
411     }
412 
413     /// @dev Add a list of participants to a capped participation tier.
414     /// @param _participants address[] The list of participant addresses.
415     /// @param _cap uint256 The cap amount (in ETH).
416     function setParticipationCap(address[] _participants, uint256 _cap) private onlyOwner {
417         for (uint i = 0; i < _participants.length; i++) {
418             participationCaps[_participants[i]] = _cap;
419         }
420     }
421 
422     /// @dev Add a list of participants to cap tier #1.
423     /// @param _participants address[] The list of participant addresses.
424     function setTier1Participants(address[] _participants) external onlyOwner {
425         setParticipationCap(_participants, TIER_1_CAP);
426     }
427 
428     /// @dev Set hard participation cap for all participants.
429     /// @param _cap uint256 The hard cap amount.
430     function setHardParticipationCap(uint256 _cap) external onlyOwner {
431         require(_cap > 0);
432 
433         hardParticipationCap = _cap;
434     }
435 
436     /// @dev Fallback function that will delegate the request to create().
437     function () external payable onlyDuringSale {
438         create(msg.sender);
439     }
440 
441     /// @dev Create and sell tokens to the caller.
442     /// @param _recipient address The address of the recipient receiving the tokens.
443     function create(address _recipient) public payable onlyDuringSale {
444         require(_recipient != address(0));
445 
446         // Enforce participation cap (in Wei received).
447         uint256 weiAlreadyParticipated = participationHistory[msg.sender];
448         uint256 participationCap = SafeMath.min256(TOKEN_UNIT.mul(15).add(participationCaps[msg.sender]), hardParticipationCap);
449         uint256 cappedWeiReceived = SafeMath.min256(msg.value, participationCap.sub(weiAlreadyParticipated));
450         require(cappedWeiReceived > 0);
451 
452         // Accept funds and transfer to funding recipient.
453         uint256 weiLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold).div(BLO_PER_WEI);
454         uint256 weiToParticipate = SafeMath.min256(cappedWeiReceived, weiLeftInSale);
455         participationHistory[msg.sender] = weiAlreadyParticipated.add(weiToParticipate);
456         fundingRecipient.transfer(weiToParticipate);
457 
458         // Issue tokens and transfer to recipient.
459         uint256 tokensLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold);
460         uint256 tokensToIssue = weiToParticipate.mul(BLO_PER_WEI);
461         if (tokensLeftInSale.sub(tokensToIssue) < BLO_PER_WEI) {
462             // If purchase would cause less than BLO_PER_WEI tokens left then nobody could ever buy them.
463             // So, gift them to the last buyer.
464             tokensToIssue = tokensLeftInSale;
465         }
466         tokensSold = tokensSold.add(tokensToIssue);
467         issueTokens(_recipient, tokensToIssue);
468 
469         // Partial refund if full participation not possible
470         // e.g. due to cap being reached.
471         uint256 refund = msg.value.sub(weiToParticipate);
472         if (refund > 0) {
473             msg.sender.transfer(refund);
474         }
475     }
476 
477     /// @dev Finalizes the token sale event, by stopping token minting.
478     function finalize() external onlyAfterSale onlyOwner {
479         if (!blok.isMinting()) {
480             revert();
481         }
482 
483         require(lastGrantedIndex == tokenGrantees.length);
484 
485         // Finish minting.
486         blok.endMinting();
487     }
488 
489     /// @dev Grants pre-configured token grants in batches. When the method is called, it'll resume from the last grant,
490     /// from its previous run, and will finish either after granting GRANT_BATCH_SIZE grants or finishing the whole list
491     /// of grants.
492     function grantTokens() external onlyAfterSale onlyOwner {
493         uint endIndex = SafeMath.min256(tokenGrantees.length, lastGrantedIndex + GRANT_BATCH_SIZE);
494         for (uint i = lastGrantedIndex; i < endIndex; i++) {
495             address grantee = tokenGrantees[i];
496 
497             // Calculate how many tokens have been granted, vested, and issued such that: granted = vested + issued.
498             TokenGrant memory tokenGrant = tokenGrants[grantee];
499             uint256 tokensGranted = tokenGrant.value;
500             uint256 tokensVesting = tokensGranted.mul(tokenGrant.percentVested).div(100);
501             uint256 tokensIssued = tokensGranted.sub(tokensVesting);
502 
503             // Transfer issued tokens that have yet to be transferred to grantee.
504             if (tokensIssued > 0) {
505                 issueTokens(grantee, tokensIssued);
506             }
507 
508             // Transfer vested tokens that have yet to be transferred to vesting trustee, and initialize grant.
509             if (tokensVesting > 0) {
510                 issueTokens(trustee, tokensVesting);
511                 trustee.grant(grantee, tokensVesting, now.add(tokenGrant.startOffset), now.add(tokenGrant.cliffOffset),
512                     now.add(tokenGrant.endOffset), tokenGrant.installmentLength, true);
513             }
514 
515             lastGrantedIndex++;
516         }
517     }
518 
519     /// @dev Issues tokens for the recipient.
520     /// @param _recipient address The address of the recipient.
521     /// @param _tokens uint256 The amount of tokens to issue.
522     function issueTokens(address _recipient, uint256 _tokens) private {
523         // Request Blok token contract to mint the requested tokens for the buyer.
524         blok.mint(_recipient, _tokens);
525 
526         TokensIssued(_recipient, _tokens);
527     }
528 
529     /// @dev Returns whether the sale has ended.
530     /// @return bool Whether the sale has ended or not.
531     function saleEnded() private constant returns (bool) {
532         return tokensSold >= MAX_TOKENS_SOLD || now >= endTime;
533     }
534 
535     /// @dev Requests to transfer control of the Blok token contract to a new owner.
536     /// @param _newOwnerCandidate address The address to transfer ownership to.
537     ///
538     /// NOTE:
539     ///   1. The new owner will need to call Blok token contract's acceptOwnership directly in order to accept the ownership.
540     ///   2. Calling this method during the token sale will prevent the token sale to continue, since only the owner of
541     ///      the Blok token contract can issue new tokens.
542     function requestBlokTokenOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
543         blok.requestOwnershipTransfer(_newOwnerCandidate);
544     }
545 
546     /// @dev Accepts new ownership on behalf of the Blok token contract.
547     // This can be used by the sale contract itself to claim back ownership of the Blok token contract.
548     function acceptBlokTokenOwnership() external onlyOwner {
549         blok.acceptOwnership();
550     }
551 
552     /// @dev Requests to transfer control of the VestingTrustee contract to a new owner.
553     /// @param _newOwnerCandidate address The address to transfer ownership to.
554     ///
555     /// NOTE:
556     ///   1. The new owner will need to call VestingTrustee's acceptOwnership directly in order to accept the ownership.
557     ///   2. Calling this method during the token sale will prevent the token sale from finalizaing, since only the owner
558     ///      of the VestingTrustee contract can issue new token grants.
559     function requestVestingTrusteeOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
560         trustee.requestOwnershipTransfer(_newOwnerCandidate);
561     }
562 
563     /// @dev Accepts new ownership on behalf of the VestingTrustee contract.
564     /// This can be used by the token sale contract itself to claim back ownership of the VestingTrustee contract.
565     function acceptVestingTrusteeOwnership() external onlyOwner {
566         trustee.acceptOwnership();
567     }
568 }
569 
570 contract VestingTrustee is Ownable {
571     using SafeMath for uint256;
572 
573     // Blok token contract.
574     BlokToken public blok;
575 
576     // Vesting grant for a speicifc holder.
577     struct Grant {
578         uint256 value;
579         uint256 start;
580         uint256 cliff;
581         uint256 end;
582         uint256 installmentLength; // In seconds.
583         uint256 transferred;
584         bool revokable;
585     }
586 
587     // Holder to grant information mapping.
588     mapping (address => Grant) public grants;
589 
590     // Total tokens available for vesting.
591     uint256 public totalVesting;
592 
593     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
594     event TokensUnlocked(address indexed _to, uint256 _value);
595     event GrantRevoked(address indexed _holder, uint256 _refund);
596 
597     /// @dev Constructor that initializes the address of the Blok token contract.
598     /// @param _blok BlokToken The address of the previously deployed Blok token contract.
599     function VestingTrustee(BlokToken _blok) {
600         require(_blok != address(0));
601 
602         blok = _blok;
603     }
604 
605     /// @dev Grant tokens to a specified address.
606     /// @param _to address The holder address.
607     /// @param _value uint256 The amount of tokens to be granted.
608     /// @param _start uint256 The beginning of the vesting period.
609     /// @param _cliff uint256 Duration of the cliff period (when the first installment is made).
610     /// @param _end uint256 The end of the vesting period.
611     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
612     /// @param _revokable bool Whether the grant is revokable or not.
613     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
614         uint256 _installmentLength, bool _revokable)
615         external onlyOwner {
616 
617         require(_to != address(0));
618         require(_to != address(this)); // Don't allow holder to be this contract.
619         require(_value > 0);
620 
621         // Require that every holder can be granted tokens only once.
622         require(grants[_to].value == 0);
623 
624         // Require for time ranges to be consistent and valid.
625         require(_start <= _cliff && _cliff <= _end);
626 
627         // Require installment length to be valid and no longer than (end - start).
628         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
629 
630         // Grant must not exceed the total amount of tokens currently available for vesting.
631         require(totalVesting.add(_value) <= blok.balanceOf(address(this)));
632 
633         // Assign a new grant.
634         grants[_to] = Grant({
635             value: _value,
636             start: _start,
637             cliff: _cliff,
638             end: _end,
639             installmentLength: _installmentLength,
640             transferred: 0,
641             revokable: _revokable
642         });
643 
644         // Since tokens have been granted, reduce the total amount available for vesting.
645         totalVesting = totalVesting.add(_value);
646 
647         NewGrant(msg.sender, _to, _value);
648     }
649 
650     /// @dev Revoke the grant of tokens of a specifed address.
651     /// @param _holder The address which will have its tokens revoked.
652     function revoke(address _holder) public onlyOwner {
653         Grant memory grant = grants[_holder];
654 
655         // Grant must be revokable.
656         require(grant.revokable);
657 
658         // Calculate amount of remaining tokens that are still available to be
659         // returned to owner.
660         uint256 refund = grant.value.sub(grant.transferred);
661 
662         // Remove grant information.
663         delete grants[_holder];
664 
665         // Update total vesting amount and transfer previously calculated tokens to owner.
666         totalVesting = totalVesting.sub(refund);
667         blok.transfer(msg.sender, refund);
668 
669         GrantRevoked(_holder, refund);
670     }
671 
672     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
673     /// @param _holder address The address of the holder.
674     /// @param _time uint256 The specific time to calculate against.
675     /// @return a uint256 Representing a holder's total amount of vested tokens.
676     function vestedTokens(address _holder, uint256 _time) external constant returns (uint256) {
677         Grant memory grant = grants[_holder];
678         if (grant.value == 0) {
679             return 0;
680         }
681 
682         return calculateVestedTokens(grant, _time);
683     }
684 
685     /// @dev Calculate amount of vested tokens at a specifc time.
686     /// @param _grant Grant The vesting grant.
687     /// @param _time uint256 The time to be checked
688     /// @return a uint256 Representing the amount of vested tokens of a specific grant.
689     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
690         // If we're before the cliff, then nothing is vested.
691         if (_time < _grant.cliff) {
692             return 0;
693         }
694 
695         // If we're after the end of the vesting period - everything is vested;
696         if (_time >= _grant.end) {
697             return _grant.value;
698         }
699 
700         // Calculate amount of installments past until now.
701         //
702         // NOTE result gets floored because of integer division.
703         uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
704 
705         // Calculate amount of days in entire vesting period.
706         uint256 vestingDays = _grant.end.sub(_grant.start);
707 
708         // Calculate and return installments that have passed according to vesting days that have passed.
709         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
710     }
711 
712     /// @dev Unlock vested tokens and transfer them to their holder.
713     /// @return a uint256 Representing the amount of vested tokens transferred to their holder.
714     function unlockVestedTokens() external {
715         Grant storage grant = grants[msg.sender];
716 
717         // Require that there will be funds left in grant to tranfser to holder.
718         require(grant.value != 0);
719 
720         // Get the total amount of vested tokens, acccording to grant.
721         uint256 vested = calculateVestedTokens(grant, now);
722         if (vested == 0) {
723             return;
724         }
725 
726         // Make sure the holder doesn't transfer more than what he already has.
727         uint256 transferable = vested.sub(grant.transferred);
728         if (transferable == 0) {
729             return;
730         }
731 
732         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
733         grant.transferred = grant.transferred.add(transferable);
734         totalVesting = totalVesting.sub(transferable);
735         blok.transfer(msg.sender, transferable);
736 
737         TokensUnlocked(msg.sender, transferable);
738     }
739 }
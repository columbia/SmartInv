1 pragma solidity ^0.4.24;
2 
3 //-----------------------------------------------------------------------------
4 /// @title PLAYToken contract
5 /// @notice defines standard ERC-20 functionality.
6 //-----------------------------------------------------------------------------
7 contract PLAYToken {
8     //-------------------------------------------------------------------------
9     /// @dev Emits when ownership of PLAY changes by any mechanism. Also emits
10     ///  when tokens are destroyed ('to' == 0).
11     //-------------------------------------------------------------------------
12     event Transfer (address indexed from, address indexed to, uint tokens);
13 
14     //-------------------------------------------------------------------------
15     /// @dev Emits when an approved spender is changed or reaffirmed, or if
16     ///  the allowance amount changes. The zero address indicates there is no
17     ///  approved address.
18     //-------------------------------------------------------------------------
19     event Approval (
20         address indexed tokenOwner, 
21         address indexed spender, 
22         uint tokens
23     );
24     
25     // total number of tokens in circulation (in pWei).
26     //  Burning tokens reduces this amount
27     uint totalPLAY = 1000000000 * 10**18;    // one billion
28     // the token balances of all token holders
29     mapping (address => uint) playBalances;
30     // approved spenders and allowances of all token holders
31     mapping (address => mapping (address => uint)) allowances;
32 
33     constructor() public {
34         playBalances[msg.sender] = totalPLAY;
35     }
36 
37     //-------------------------------------------------------------------------
38     /// @dev Throws if parameter is zero
39     //-------------------------------------------------------------------------
40     modifier notZero(uint param) {
41         require (param != 0, "Parameter cannot be zero");
42         _;
43     }
44     
45     //-------------------------------------------------------------------------
46     /// @dev Throws if tokenOwner has insufficient PLAY balance
47     //-------------------------------------------------------------------------
48     modifier sufficientFunds(address tokenOwner, uint tokens) {
49         require (playBalances[tokenOwner] >= tokens, "Insufficient balance");
50         _;
51     }
52     
53     //-------------------------------------------------------------------------
54     /// @dev Throws if spender has insufficient allowance from owner
55     //-------------------------------------------------------------------------
56     modifier sufficientAllowance(address owner, address spender, uint tokens) {
57         require (
58             allowances[owner][spender] >= tokens, 
59             "Insufficient allowance"
60         );
61         _;
62     }
63 
64     //-------------------------------------------------------------------------
65     /// @notice Send `(tokens/1000000000000000000).fixed(0,18)` PLAY to `to`.
66     /// @dev Throws if amount to send is zero. Throws if `msg.sender` has
67     ///  insufficient balance for transfer. Throws if `to` is the zero address.
68     /// @param to The address to where PLAY is being sent.
69     /// @param tokens The number of tokens to send (in pWei).
70     /// @return True upon successful transfer. Will throw if unsuccessful.
71     //-------------------------------------------------------------------------
72     function transfer(address to, uint tokens) 
73         public 
74         notZero(uint(to)) 
75         notZero(tokens)
76         sufficientFunds(msg.sender, tokens)
77         returns(bool) 
78     {
79         // subtract amount from sender
80         playBalances[msg.sender] -= tokens;
81         // add amount to token receiver
82         playBalances[to] += tokens;
83         // emit transfer event
84         emit Transfer(msg.sender, to, tokens);
85         
86         return true;
87     }
88 
89     //-------------------------------------------------------------------------
90     /// @notice Send `(tokens/1000000000000000000).fixed(0,18)` PLAY from
91     ///  `from` to `to`.
92     /// @dev Throws if amount to send is zero. Throws if `msg.sender` has
93     ///  insufficient allowance for transfer. Throws if `from` has
94     ///  insufficient balance for transfer. Throws if `to` is the zero address.
95     /// @param from The address from where PLAY is being sent. Sender must be
96     ///  an approved spender.
97     /// @param to The token owner whose PLAY is being sent.
98     /// @param tokens The number of tokens to send (in pWei).
99     /// @return True upon successful transfer. Will throw if unsuccessful.
100     //-------------------------------------------------------------------------
101     function transferFrom(address from, address to, uint tokens) 
102         public 
103         notZero(uint(to)) 
104         notZero(tokens) 
105         sufficientFunds(from, tokens)
106         sufficientAllowance(from, msg.sender, tokens)
107         returns(bool) 
108     {
109         // subtract amount from sender's allowance
110         allowances[from][msg.sender] -= tokens;
111         // subtract amount from token owner
112         playBalances[from] -= tokens;
113         // add amount to token receiver
114         playBalances[to] += tokens;
115         // emit transfer event
116         emit Transfer(from, to, tokens);
117 
118         return true;
119     }
120 
121     //-------------------------------------------------------------------------
122     /// @notice Allow `spender` to withdraw from your account, multiple times,
123     ///  up to `(tokens/1000000000000000000).fixed(0,18)` PLAY. Calling this
124     ///  function overwrites the previous allowance of spender.
125     /// @dev Emits approval event
126     /// @param spender The address to authorize as a spender
127     /// @param tokens The new token allowance of spender (in pWei).
128     //-------------------------------------------------------------------------
129     function approve(address spender, uint tokens) external returns(bool) {
130         // set the spender's allowance to token amount
131         allowances[msg.sender][spender] = tokens;
132         // emit approval event
133         emit Approval(msg.sender, spender, tokens);
134 
135         return true;
136     }
137 
138     //-------------------------------------------------------------------------
139     /// @notice Get the total number of tokens in circulation.
140     /// @return Total tokens tracked by this contract.
141     //-------------------------------------------------------------------------
142     function totalSupply() external view returns (uint) { return totalPLAY; }
143 
144     //-------------------------------------------------------------------------
145     /// @notice Get the number of PLAY tokens owned by `tokenOwner`.
146     /// @dev Throws if trying to query the zero address.
147     /// @param tokenOwner The PLAY token owner.
148     /// @return The number of PLAY tokens owned by `tokenOwner` (in pWei).
149     //-------------------------------------------------------------------------
150     function balanceOf(address tokenOwner) 
151         public 
152         view 
153         notZero(uint(tokenOwner))
154         returns(uint)
155     {
156         return playBalances[tokenOwner];
157     }
158 
159     //-------------------------------------------------------------------------
160     /// @notice Get the remaining allowance of `spender` for `tokenOwner`.
161     /// @param tokenOwner The PLAY token owner.
162     /// @param spender The approved spender address.
163     /// @return The remaining allowance of `spender` for `tokenOwner`.
164     //-------------------------------------------------------------------------
165     function allowance(
166         address tokenOwner, 
167         address spender
168     ) public view returns (uint) {
169         return allowances[tokenOwner][spender];
170     }
171 
172     //-------------------------------------------------------------------------
173     /// @notice Get the token's name.
174     /// @return The token's name as a string
175     //-------------------------------------------------------------------------
176     function name() external pure returns (string) { 
177         return "PLAY Network Token"; 
178     }
179 
180     //-------------------------------------------------------------------------
181     /// @notice Get the token's ticker symbol.
182     /// @return The token's ticker symbol as a string
183     //-------------------------------------------------------------------------
184     function symbol() external pure returns (string) { return "PLAY"; }
185 
186     //-------------------------------------------------------------------------
187     /// @notice Get the number of allowed decimal places for the token.
188     /// @return The number of allowed decimal places for the token.
189     //-------------------------------------------------------------------------
190     function decimals() external pure returns (uint8) { return 18; }
191 }
192 
193 
194 //-----------------------------------------------------------------------------
195 /// @title BurnToken contract
196 /// @notice defines token burning functionality.
197 //-----------------------------------------------------------------------------
198 contract BurnToken is PLAYToken {
199     //-------------------------------------------------------------------------
200     /// @notice Destroy `(tokens/1000000000000000000).fixed(0,18)` PLAY. These
201     ///  tokens cannot be viewed or recovered.
202     /// @dev Throws if amount to burn is zero. Throws if sender has
203     ///  insufficient balance to burn. Emits transfer event.
204     /// @param tokens The number of tokens to burn (in pWei). 
205     /// @return True upon successful burn. Will throw if unsuccessful.
206     //-------------------------------------------------------------------------
207     function burn(uint tokens)
208         external 
209         notZero(tokens) 
210         sufficientFunds(msg.sender, tokens)
211         returns(bool) 
212     {
213         // subtract amount from token owner
214         playBalances[msg.sender] -= tokens;
215         // subtract amount from total supply
216         totalPLAY -= tokens;
217         // emit transfer event
218         emit Transfer(msg.sender, address(0), tokens);
219 
220         return true;
221     }
222 
223     //-------------------------------------------------------------------------
224     /// @notice Destroy `(tokens/1000000000000000000).fixed(0,18)` PLAY from 
225     /// `from`. These tokens cannot be viewed or recovered.
226     /// @dev Throws if amount to burn is zero. Throws if sender has
227     ///  insufficient allowance to burn. Throws if `from` has insufficient
228     ///  balance to burn. Emits transfer event.
229     /// @param from The token owner whose PLAY is being burned. Sender must be
230     ///  an approved spender.
231     /// @param tokens The number of tokens to burn (in pWei).
232     /// @return True upon successful burn. Will throw if unsuccessful.
233     //-------------------------------------------------------------------------
234     function burnFrom(address from, uint tokens) 
235         external 
236         notZero(tokens) 
237         sufficientFunds(from, tokens)
238         sufficientAllowance(from, msg.sender, tokens)
239         returns(bool) 
240     {
241         // subtract amount from sender's allowance
242         allowances[from][msg.sender] -= tokens;
243         // subtract amount from token owner
244         playBalances[from] -= tokens;
245         // subtract amount from total supply
246         totalPLAY -= tokens;
247         // emit transfer event
248         emit Transfer(from, address(0), tokens);
249 
250         return true;
251     }
252 }
253 
254 
255 //-----------------------------------------------------------------------------
256 /// @title LockToken contract
257 /// @notice defines token locking and unlocking functionality.
258 //-----------------------------------------------------------------------------
259 contract LockToken is BurnToken {
260     //-------------------------------------------------------------------------
261     /// @dev Emits when PLAY tokens become locked for any number of years by
262     ///  any mechanism.
263     //-------------------------------------------------------------------------
264     event Lock (address indexed tokenOwner, uint tokens);
265 
266     //-------------------------------------------------------------------------
267     /// @dev Emits when PLAY tokens become unlocked by any mechanism.
268     //-------------------------------------------------------------------------
269     event Unlock (address indexed tokenOwner, uint tokens);
270 
271     // Unix Timestamp for 1-1-2018 at 00:00:00.
272     //  Used to calculate years since release.
273     uint constant FIRST_YEAR_TIMESTAMP = 1514764800;
274     // Tracks years since release. Starts at 0 and increments every 365 days.
275     uint public currentYear;
276     // Maximum number of years into the future locked tokens can be recovered.
277     uint public maximumLockYears = 10;
278     // Locked token balances by unlock year  
279     mapping (address => mapping(uint => uint)) tokensLockedUntilYear;
280 
281     //-------------------------------------------------------------------------
282     /// @notice Lock `(tokens/1000000000000000000).fixed(0,18)` PLAY for
283     ///  `numberOfYears` years.
284     /// @dev Throws if amount to lock is zero. Throws if numberOfYears is zero
285     ///  or greater than maximumLockYears. Throws if `msg.sender` has 
286     ///  insufficient balance to lock.
287     /// @param numberOfYears The number of years the tokens will be locked.
288     /// @param tokens The number of tokens to lock (in pWei).
289     //-------------------------------------------------------------------------
290     function lock(uint numberOfYears, uint tokens) 
291         public 
292         notZero(tokens)
293         sufficientFunds(msg.sender, tokens)
294         returns(bool)
295     {
296         // number of years must be a valid amount.
297         require (
298             numberOfYears > 0 && numberOfYears <= maximumLockYears,
299             "Invalid number of years"
300         );
301 
302         // subtract amount from sender
303         playBalances[msg.sender] -= tokens;
304         // add amount to sender's locked token balance
305         tokensLockedUntilYear[msg.sender][currentYear+numberOfYears] += tokens;
306         // emit lock event
307         emit Lock(msg.sender, tokens);
308 
309         return true;
310     }
311 
312     //-------------------------------------------------------------------------
313     /// @notice Lock `(tokens/1000000000000000000).fixed(0,18)` PLAY from 
314     ///  `from` for `numberOfYears` years.
315     /// @dev Throws if amount to lock is zero. Throws if numberOfYears is zero
316     ///  or greater than maximumLockYears. Throws if `msg.sender` has
317     ///  insufficient allowance to lock. Throws if `from` has insufficient
318     ///  balance to lock.
319     /// @param from The token owner whose PLAY is being locked. Sender must be
320     ///  an approved spender.
321     /// @param numberOfYears The number of years the tokens will be locked.
322     /// @param tokens The number of tokens to lock (in pWei).
323     //-------------------------------------------------------------------------
324     function lockFrom(address from, uint numberOfYears, uint tokens) 
325         external
326         notZero(tokens)
327         sufficientFunds(from, tokens)
328         sufficientAllowance(from, msg.sender, tokens)
329         returns(bool) 
330     {
331         // number of years must be a valid amount.
332         require (
333             numberOfYears > 0 && numberOfYears <= maximumLockYears,
334             "Invalid number of years"
335         );
336 
337         // subtract amount from sender's allowance
338         allowances[from][msg.sender] -= tokens;
339         // subtract amount from token owner's balance
340         playBalances[from] -= tokens;
341         // add amount to token owner's locked token balance
342         tokensLockedUntilYear[from][currentYear + numberOfYears] += tokens;
343         // emit lock event
344         emit Lock(from, tokens);
345         
346         return true;
347     }
348 
349     //-------------------------------------------------------------------------
350     /// @notice Send `(tokens/1000000000000000000).fixed(0,18)` PLAY to `to`,
351     ///  then lock for `numberOfYears` years.
352     /// @dev Throws if amount to send is zero. Throws if `msg.sender` has
353     ///  insufficient balance for transfer. Throws if `to` is the zero
354     ///  address. Emits transfer and lock events.
355     /// @param to The address to where PLAY is being sent and locked.
356     /// @param numberOfYears The number of years the tokens will be locked.
357     /// @param tokens The number of tokens to send (in pWei).
358     //-------------------------------------------------------------------------
359     function transferAndLock(
360         address to, 
361         uint numberOfYears, 
362         uint tokens
363     ) external {
364         // Transfer will fail if sender's balance is too low or "to" is zero
365         transfer(to, tokens);
366 
367         // subtract amount from token receiver's balance
368         playBalances[to] -= tokens;
369         // add amount to token receiver's locked token balance
370         tokensLockedUntilYear[to][currentYear + numberOfYears] += tokens;
371         // emit lock event
372         emit Lock(msg.sender, tokens);
373     }
374 
375     //-------------------------------------------------------------------------
376     /// @notice Send `(tokens/1000000000000000000).fixed(0,18)` PLAY from 
377     ///  `from` to `to`, then lock for `numberOfYears` years.
378     /// @dev Throws if amount to send is zero. Throws if `msg.sender` has
379     ///  insufficient allowance for transfer. Throws if `from` has 
380     ///  insufficient balance for transfer. Throws if `to` is the zero
381     ///  address. Emits transfer and lock events.
382     /// @param from The token owner whose PLAY is being sent. Sender must be
383     ///  an approved spender.
384     /// @param to The address to where PLAY is being sent and locked.
385     /// @param tokens The number of tokens to send (in pWei).
386     //-------------------------------------------------------------------------
387     function transferFromAndLock(
388         address from, 
389         address to, 
390         uint numberOfYears, 
391         uint tokens
392     ) external {
393         // Initiate transfer. Transfer will fail if sender's allowance is too
394         //  low, token owner's balance is too low, or "to" is zero
395         transferFrom(from, to, tokens);
396 
397         // subtract amount from token owner's balance
398         playBalances[to] -= tokens;
399         // add amount to token receiver's locked token balance
400         tokensLockedUntilYear[to][currentYear + numberOfYears] += tokens;
401         // emit lock event
402         emit Lock(msg.sender, tokens);
403     }
404 
405     //-------------------------------------------------------------------------
406     /// @notice Unlock all qualifying tokens for `tokenOwner`. Sender must 
407     ///  either be tokenOwner or an approved address.
408     /// @dev If tokenOwner is empty, tokenOwner is set to msg.sender. Throws
409     ///  if sender is not tokenOwner or an approved spender (allowance > 0).
410     /// @param tokenOwner The token owner whose tokens will unlock.
411     //-------------------------------------------------------------------------
412     function unlockAll(address tokenOwner) external {
413         // create local variable for token owner
414         address addressToUnlock = tokenOwner;
415         // if tokenOwner parameter is empty, set tokenOwner to sender
416         if (addressToUnlock == address(0)) {
417             addressToUnlock = msg.sender;
418         }
419         // sender must either be tokenOwner or an approved address
420         if (msg.sender != addressToUnlock) {
421             require (
422                 allowances[addressToUnlock][msg.sender] > 0,
423                 "Not authorized to unlock for this address"
424             );
425         }
426 
427         // create local variable for unlock total
428         uint tokensToUnlock;
429         // check each year starting from 1 year after release
430         for (uint i = 1; i <= currentYear; ++i) {
431             // add qualifying tokens to tokens to unlock variable
432             tokensToUnlock += tokensLockedUntilYear[addressToUnlock][i];
433             // set locked token balance of year i to 0 
434             tokensLockedUntilYear[addressToUnlock][i] = 0;
435         }
436         // add qualifying tokens back to token owner's account balance
437         playBalances[addressToUnlock] += tokensToUnlock;
438         // emit unlock event
439         emit Unlock (addressToUnlock, tokensToUnlock);
440     }
441 
442     //-------------------------------------------------------------------------
443     /// @notice Unlock all tokens locked until `year` years since 2018 for 
444     ///  `tokenOwner`. Sender must be tokenOwner or an approved address.
445     /// @dev If tokenOwner is empty, tokenOwner is set to msg.sender. Throws
446     ///  if sender is not tokenOwner or an approved spender (allowance > 0).
447     /// @param tokenOwner The token owner whose tokens will unlock.
448     /// @param year Number of years since 2018 the tokens were locked until.
449     //-------------------------------------------------------------------------
450     function unlockByYear(address tokenOwner, uint year) external {
451         // create local variable for token owner
452         address addressToUnlock = tokenOwner;
453         // if tokenOwner parameter is empty, set tokenOwner to sender
454         if (addressToUnlock == address(0)) {
455             addressToUnlock = msg.sender;
456         }
457         // sender must either be tokenOwner or an approved address
458         if (msg.sender != addressToUnlock) {
459             require (
460                 allowances[addressToUnlock][msg.sender] > 0,
461                 "Not authorized to unlock for this address"
462             );
463         }
464         // year of locked tokens must be less than or equal to current year
465         require (
466             currentYear >= year,
467             "Tokens from this year cannot be unlocked yet"
468         );
469         // create local variable for unlock amount
470         uint tokensToUnlock = tokensLockedUntilYear[addressToUnlock][year];
471         // set locked token balance of year to 0
472         tokensLockedUntilYear[addressToUnlock][year] = 0;
473         // add qualifying tokens back to token owner's account balance
474         playBalances[addressToUnlock] += tokensToUnlock;
475         // emit unlock event
476         emit Unlock(addressToUnlock, tokensToUnlock);
477     }
478 
479     //-------------------------------------------------------------------------
480     /// @notice Update the current year.
481     /// @dev Throws if less than 365 days has passed since currentYear.
482     //-------------------------------------------------------------------------
483     function updateYearsSinceRelease() external {
484         // check if years since first year is greater than the currentYear
485         uint secondsSinceRelease = block.timestamp - FIRST_YEAR_TIMESTAMP;
486         require (
487             currentYear < secondsSinceRelease / (365 * 1 days),
488             "Cannot update year yet"
489         );
490         // increment years since release
491         ++currentYear;
492     }
493 
494     //-------------------------------------------------------------------------
495     /// @notice Get the total locked token holdings of `tokenOwner`.
496     /// @param tokenOwner The locked token owner.
497     /// @return Total locked token holdings of an address.
498     //-------------------------------------------------------------------------
499     function getTotalLockedTokens(
500         address tokenOwner
501     ) public view returns (uint lockedTokens) {
502         for (uint i = 1; i < currentYear + maximumLockYears; ++i) {
503             lockedTokens += tokensLockedUntilYear[tokenOwner][i];
504         }
505     }
506 
507     //-------------------------------------------------------------------------
508     /// @notice Get the locked token holdings of `tokenOwner` unlockable in
509     ///  `(year + 2018)`.
510     /// @param tokenOwner The locked token owner.
511     /// @param year Years since 2018 the tokens are locked until.
512     /// @return Locked token holdings of an address for `(year + 2018)`.
513     //-------------------------------------------------------------------------
514     function getLockedTokensByYear(
515         address tokenOwner, 
516         uint year
517     ) external view returns (uint) {
518         return tokensLockedUntilYear[tokenOwner][year];
519     }
520 }
521 
522 
523 //-----------------------------------------------------------------------------
524 /// @title Ownable
525 /// @dev The Ownable contract has an owner address, and provides basic 
526 ///  authorization control functions, this simplifies the implementation of
527 ///  "user permissions".
528 //-----------------------------------------------------------------------------
529 contract Ownable {
530     //-------------------------------------------------------------------------
531     /// @dev Emits when owner address changes by any mechanism.
532     //-------------------------------------------------------------------------
533     event OwnershipTransfer (address previousOwner, address newOwner);
534     
535     // Wallet address that can sucessfully execute onlyOwner functions
536     address owner;
537     
538     //-------------------------------------------------------------------------
539     /// @dev Sets the owner of the contract to the sender account.
540     //-------------------------------------------------------------------------
541     constructor() public {
542         owner = msg.sender;
543         emit OwnershipTransfer(address(0), owner);
544     }
545 
546     //-------------------------------------------------------------------------
547     /// @dev Throws if called by any account other than `owner`.
548     //-------------------------------------------------------------------------
549     modifier onlyOwner() {
550         require(
551             msg.sender == owner,
552             "Function can only be called by contract owner"
553         );
554         _;
555     }
556 
557     //-------------------------------------------------------------------------
558     /// @notice Transfer control of the contract to a newOwner.
559     /// @dev Throws if `_newOwner` is zero address.
560     /// @param _newOwner The address to transfer ownership to.
561     //-------------------------------------------------------------------------
562     function transferOwnership(address _newOwner) public onlyOwner {
563         // for safety, new owner parameter must not be 0
564         require (
565             _newOwner != address(0),
566             "New owner address cannot be zero"
567         );
568         // define local variable for old owner
569         address oldOwner = owner;
570         // set owner to new owner
571         owner = _newOwner;
572         // emit ownership transfer event
573         emit OwnershipTransfer(oldOwner, _newOwner);
574     }
575 }
576 
577 
578 //-----------------------------------------------------------------------------
579 /// @title TOY Token Interface - ERC721-compliant view functions 
580 //-----------------------------------------------------------------------------
581 interface ToyTokenOwnership {
582     function ownerOf(uint256 _tokenId) external view returns (address);
583     function getApproved(uint256 _tokenId) external view returns (address);
584     function isApprovedForAll(
585         address _owner, 
586         address _operator
587     ) external view returns (bool);
588 }
589 
590 
591 //-----------------------------------------------------------------------------
592 /// @title Color Token Contract
593 /// @notice defines colored token registration, creation, and spending
594 ///  functionality.
595 //-----------------------------------------------------------------------------
596 contract ColorToken is LockToken, Ownable {
597     //-------------------------------------------------------------------------
598     /// @dev Emits when a new colored token is created.
599     //-------------------------------------------------------------------------
600     event NewColor(address indexed creator, string name);
601 
602     //-------------------------------------------------------------------------
603     /// @dev Emits when colored tokens are deposited into TOY Tokens. Color
604     ///  equivalent to PLAY.transfer().
605     //-------------------------------------------------------------------------
606     event DepositColor(
607         uint indexed to, 
608         uint indexed colorIndex, 
609         uint tokens
610     );
611 
612     //-------------------------------------------------------------------------
613     /// @dev Emits when colored tokens are spent by any mechanism. Color
614     ///  equivalent to PLAY.burn().
615     //-------------------------------------------------------------------------
616     event SpendColor(
617         uint indexed from, 
618         uint indexed color, 
619         uint amount
620     );
621 
622     // Colored token data
623     struct ColoredToken {
624         address creator;
625         string name;
626         mapping (uint => uint) balances;
627     }
628 
629     // array containing all colored token data
630     ColoredToken[] coloredTokens;
631     // required locked tokens needed to register a color (in pWei)
632     uint public requiredLockedForColorRegistration = 10000 * 10**18;
633     // TOY Token contract to interface with
634     ToyTokenOwnership toy;
635     // UID value is 7 bytes. Max value is 2**56
636     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
637 
638     //-------------------------------------------------------------------------
639     /// @notice Set the address of the TOY Token interface to `toyAddress`.
640     /// @dev Throws if toyAddress is the zero address.
641     /// @param toyAddress The address of the TOY Token interface.
642     //-------------------------------------------------------------------------
643     function setToyTokenContractAddress (address toyAddress) 
644         external 
645         notZero(uint(toyAddress)) 
646         onlyOwner
647     {
648         // initialize contract to toyAddress
649         toy = ToyTokenOwnership(toyAddress);
650     }
651 
652     //-------------------------------------------------------------------------
653     /// @notice Set required total locked tokens to 
654     ///  `(newAmount/1000000000000000000).fixed(0,18)`.
655     /// @dev Throws if the sender is not the contract owner. Throws if new
656     ///  amount is zero.
657     /// @param newAmount The new required locked token amount (in pWei).
658     //-------------------------------------------------------------------------
659     function setRequiredLockedForColorRegistration(uint newAmount) 
660         external 
661         onlyOwner
662         notZero(newAmount)
663     {
664         requiredLockedForColorRegistration = newAmount;
665     }
666     
667     //-------------------------------------------------------------------------
668     /// @notice Registers `colorName` as a new colored token. Must own
669     ///  `requiredLockedForColorReg` locked tokens as a requirement.
670     /// @dev Throws if `msg.sender` has insufficient locked tokens. Throws if
671     ///  colorName is empty or is longer than 32 characters.
672     /// @param colorName The name for the new colored token.
673     /// @return Index number for the new colored token.
674     //-------------------------------------------------------------------------
675     function registerNewColor(string colorName) external returns (uint) {
676         // sender must have enough locked tokens
677         require (
678             getTotalLockedTokens(msg.sender) >= requiredLockedForColorRegistration,
679             "Insufficient locked tokens"
680         );
681         // colorName must be a valid length
682         require (
683             bytes(colorName).length > 0 && bytes(colorName).length < 32,
684             "Invalid color name length"
685         );
686         // push new colored token to colored token array and store the index
687         uint index = coloredTokens.push(ColoredToken(msg.sender, colorName));
688         return index;
689     }
690 
691     //-------------------------------------------------------------------------
692     /// @notice Locks `(tokens/1000000000000000000).fixed(0,18)` PLAY tokens
693     ///  for 2 years, then deposits the same number of colored tokens with 
694     ///  index `colorIndex` into TOY Token #`uid`.
695     /// @dev Throws if tokens to deposit is zero. Throws if colorIndex is
696     ///  greater than number of colored tokens. Throws if `msg.sender` has
697     ///  insufficient balance to lock. Throws if `uid` is greater than
698     ///  maximum UID value. Throws if token does not have an owner. Throws if
699     ///  sender is not the creator of the colored token.
700     /// @param to The Unique Identifier of the TOY Token receiving tokens.
701     /// @param colorIndex The index of the color to spend.
702     /// @param tokens The number of colored tokens to spend (in pWei).
703     //-------------------------------------------------------------------------
704     function deposit (uint colorIndex, uint to, uint tokens)
705         external 
706         notZero(tokens)
707     {
708         // colorIndex must be valid color
709         require (colorIndex < coloredTokens.length, "Invalid color index");
710         // sender must be colored token creator
711         require (
712             msg.sender == coloredTokens[colorIndex].creator,
713             "Not authorized to deposit this color"
714         );
715         // uid must be a valid UID
716         require (to < UID_MAX, "Invalid UID");
717         // If TOY Token #uid is not owned, it does not exist yet.
718         require(toy.ownerOf(to) != address(0), "TOY Token does not exist");
719         
720         // Initiate lock. Fails if sender's balance is too low.
721         lock(2, tokens);
722 
723         // add tokens to TOY Token #UID
724         coloredTokens[colorIndex].balances[to] += tokens;
725         // emit color transfer event
726         emit DepositColor(to, colorIndex, tokens);
727     }
728 
729     //-------------------------------------------------------------------------
730     /// @notice Locks `(tokens/1000000000000000000).fixed(0,18)` PLAY tokens
731     ///  for 2 years, then deposits the same number of colored tokens with 
732     ///  index `colorIndex` into multiple TOY Tokens.
733     /// @dev Throws if tokens to deposit is zero. Throws if colorIndex is
734     ///  greater than number of colored tokens. Throws if `msg.sender` has
735     ///  insufficient balance to lock. Throws if `uid` is greater than
736     ///  maximum UID value. Throws if any token does not have an owner. Throws
737     ///  if sender is not the creator of the colored token.
738     /// @param to The Unique Identifier of the TOY Token receiving tokens.
739     /// @param colorIndex The index of the color to spend.
740     /// @param tokens The number of colored tokens to spend (in pWei).
741     //-------------------------------------------------------------------------
742     function depositBulk (uint colorIndex, uint[] to, uint tokens)
743         external 
744         notZero(tokens)
745     {
746         // colorIndex must be valid color
747         require (colorIndex < coloredTokens.length, "Invalid color index");
748         // sender must be colored token creator
749         require (
750             msg.sender == coloredTokens[colorIndex].creator,
751             "Not authorized to deposit this color"
752         );
753 
754         // Initiate lock. Fails if sender's balance is too low.
755         lock(2, tokens * to.length);
756 
757         for(uint i = 0; i < to.length; ++i){
758             // uid must be a valid UID
759             require (to[i] < UID_MAX, "Invalid UID");
760             // If TOY Token #uid is not owned, it does not exist yet.
761             require(toy.ownerOf(to[i]) != address(0), "TOY Token does not exist");
762 
763             // add tokens to TOY Token #UID
764             coloredTokens[colorIndex].balances[to[i]] += tokens;
765             // emit color transfer event
766             emit DepositColor(to[i], colorIndex, tokens);
767         }
768     }
769 
770     //-------------------------------------------------------------------------
771     /// @notice Spend `(tokens/1000000000000000000).fixed(0,18)` colored 
772     ///  tokens with index `colorIndex`.
773     /// @dev Throws if tokens to spend is zero. Throws if colorIndex is
774     ///  greater than number of colored tokens. Throws if `msg.sender` has
775     ///  insufficient balance to spend.
776     /// @param colorIndex The index of the color to spend.
777     /// @param from The UID of the TOY Token to spend from.
778     /// @param tokens The number of colored tokens to spend (in pWei).
779     /// @return True if spend successful. Throw if unsuccessful.
780     //-------------------------------------------------------------------------
781     function spend (uint colorIndex, uint from, uint tokens) 
782         external 
783         notZero(tokens)
784         returns(bool) 
785     {
786         // colorIndex must be valid color
787         require (colorIndex < coloredTokens.length, "Invalid color index");
788         // sender must own TOY Token
789         require (
790             msg.sender == toy.ownerOf(from), 
791             "Sender is not owner of TOY Token"
792         );
793         // token owner's balance must be enough to spend tokens
794         require (
795             coloredTokens[colorIndex].balances[from] >= tokens,
796             "Insufficient tokens to spend"
797         );
798         // deduct the tokens from the sender's balance
799         coloredTokens[colorIndex].balances[from] -= tokens;
800         // emit spend event
801         emit SpendColor(from, colorIndex, tokens);
802         return true;
803     }
804 
805     //-------------------------------------------------------------------------
806     /// @notice Spend `(tokens/1000000000000000000).fixed(0,18)` colored
807     ///  tokens with color index `index` from `from`.
808     /// @dev Throws if tokens to spend is zero. Throws if colorIndex is 
809     ///  greater than number of colored tokens. Throws if `msg.sender` is not
810     ///  the colored token's creator. Throws if `from` has insufficient
811     ///  balance to spend.
812     /// @param colorIndex The index of the color to spend.
813     /// @param from The address whose colored tokens are being spent.
814     /// @param tokens The number of tokens to send (in pWei).
815     //-------------------------------------------------------------------------
816     function spendFrom(uint colorIndex, uint from, uint tokens)
817         external 
818         notZero(tokens)
819         returns (bool) 
820     {
821         // colorIndex must be valid color
822         require (colorIndex < coloredTokens.length, "Invalid color index");
823         // sender must be authorized address or operator for TOY Token
824         require (
825             msg.sender == toy.getApproved(from) ||
826             toy.isApprovedForAll(toy.ownerOf(from), msg.sender), 
827             "Sender is not authorized operator for TOY Token"
828         );
829         // token owner's balance must be enough to spend tokens
830         require (
831             coloredTokens[colorIndex].balances[from] >= tokens,
832             "Insufficient balance to spend"
833         );
834         // deduct the tokens from token owner's balance
835         coloredTokens[colorIndex].balances[from] -= tokens;
836         // emit spend event
837         emit SpendColor(from, colorIndex, tokens);
838         return true;
839     }
840 
841     //-------------------------------------------------------------------------
842     /// @notice Get the number of colored tokens with color index `colorIndex`
843     ///  owned by TOY Token #`uid`.
844     /// @param uid The TOY Token with deposited color tokens.
845     /// @param colorIndex Index of the colored token to query.
846     /// @return The number of colored tokens with color index `colorIndex`
847     ///  owned by TOY Token #`uid`.
848     //-------------------------------------------------------------------------
849     function getColoredTokenBalance(uint uid, uint colorIndex) 
850         external 
851         view 
852         returns(uint) 
853     {
854         return coloredTokens[colorIndex].balances[uid];
855     }
856 
857     //-------------------------------------------------------------------------
858     /// @notice Count the number of colored token types
859     /// @return Number of colored token types
860     //-------------------------------------------------------------------------
861     function coloredTokenCount() external view returns (uint) {
862         return coloredTokens.length;
863     }
864 
865     //-------------------------------------------------------------------------
866     /// @notice Get the name and creator address of colored token with index
867     ///  `colorIndex`
868     /// @param colorIndex Index of the colored token to query.
869     /// @return The creator address and name of colored token.
870     //-------------------------------------------------------------------------
871     function getColoredToken(uint colorIndex) 
872         external 
873         view 
874         returns(address, string)
875     {
876         return (
877             coloredTokens[colorIndex].creator, 
878             coloredTokens[colorIndex].name
879         );
880     }
881 }
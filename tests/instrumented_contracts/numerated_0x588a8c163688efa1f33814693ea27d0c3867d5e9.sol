1 pragma solidity ^0.5.7;    
2 ////////////////////////////////////////////////////////////////////////////////
3 library     SafeMath                    // This library is not used systematically since it tends to create "Infinite gas" functions and consumes too many gas
4 {
5     //------------------
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
7     {
8         if (a == 0)     return 0;
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     //--------------------------------------------------------------------------
14     function div(uint256 a, uint256 b) internal pure returns (uint256) 
15     {
16         return a/b;
17     }
18     //--------------------------------------------------------------------------
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
20     {
21         assert(b <= a);
22         return a - b;
23     }
24     //--------------------------------------------------------------------------
25     function add(uint256 a, uint256 b) internal pure returns (uint256) 
26     {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 ////////////////////////////////////////////////////////////////////////////////
33 contract    ERC20 
34 {
35     using SafeMath  for uint256;
36 
37     //----- VARIABLES
38 
39     address public              owner;          // Owner of this contract
40     address public              admin;          // The one who is allowed to do changes
41     address public              mazler;
42 
43     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
44     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
45 
46     //------ TOKEN SPECIFICATION
47 
48     string  public      name       = "DIAM";
49     string  public      symbol     = "DIAM";
50 
51     uint256 public  constant    decimals   = 5;                            // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places
52 
53     uint256 public  constant    initSupply = 150000000 * 10**decimals;      //150000000 * 10**decimals;   // 10**18 max
54 
55     uint256 public              totalSoldByOwner=0;                         // Not from ERC-20 specification, but help for the totalSupply management later
56     //-----
57 
58     uint256 public              totalSupply;
59 
60     uint256                     mazl   = 10;
61     uint256                     vScale = 10000;
62 
63     //--------------------------------------------------------------------------
64 
65     modifier onlyOwner()            { require(msg.sender==owner);   _; }
66     modifier onlyAdmin()            { require(msg.sender==admin);   _; }
67 
68     //----- EVENTS
69 
70     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
71     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
72 
73     event OnOwnershipTransfered(address oldOwnerWallet, address newOwnerWallet);
74     event OnAdminUserChanged(   address oldAdminWalet,  address newAdminWallet);
75     event OnVautingUserChanged( address oldWallet,      address newWallet);
76 
77     //--------------------------------------------------------------------------
78     //--------------------------------------------------------------------------
79     constructor()   public 
80     {
81         owner  = msg.sender;
82         admin  = owner;
83         mazler = owner;
84 
85         balances[owner] = initSupply;   // send the tokens to the owner
86         totalSupply     = initSupply;
87     }
88     //--------------------------------------------------------------------------
89     //--------------------------------------------------------------------------
90     //----- ERC20 FUNCTIONS
91     //--------------------------------------------------------------------------
92     //--------------------------------------------------------------------------
93     function balanceOf(address walletAddress) public view /*constant*/ returns (uint256 balance) 
94     {
95         return balances[walletAddress];
96     }
97     //--------------------------------------------------------------------------
98     function        transfer(address toAddr, uint256 amountInWei)  public   returns (bool)
99     {
100         uint256         baseAmount;
101         uint256         finalAmount;
102         uint256         addAmountInWei;
103 
104         require(toAddr!=address(0x0) && toAddr!=msg.sender 
105                                      && amountInWei!=0
106                                      && amountInWei<=balances[msg.sender]);
107 
108         //-----  Reduce gas consumption of ==> balances[msg.sender] = balances[msg.sender].sub(amountInWei);
109 
110         baseAmount  = balances[msg.sender];
111         finalAmount = baseAmount - amountInWei;
112 
113         assert(finalAmount <= baseAmount);
114 
115         balances[msg.sender] = finalAmount;
116 
117         //----- Reduce gas consumption of ==> balances[toAddr] = balances[toAddr].add(amountInWei);
118 
119         baseAmount     = balances[toAddr];
120         addAmountInWei = manageMazl(toAddr, amountInWei);
121 
122         finalAmount = baseAmount + addAmountInWei;
123 
124         assert(finalAmount >= baseAmount);
125 
126         balances[toAddr] = finalAmount;
127 
128         //-----
129 
130         if (msg.sender==owner)
131         {
132             totalSoldByOwner += amountInWei;
133         }
134 
135         //-----
136 
137         emit Transfer(msg.sender, toAddr, addAmountInWei /*amountInWei*/);
138 
139         return true;
140     }
141     //--------------------------------------------------------------------------
142     function allowance(address walletAddress, address spender) public view/*constant*/ returns (uint remaining)
143     {
144         return allowances[walletAddress][spender];
145     }
146     //--------------------------------------------------------------------------
147     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
148     {
149         require(amountInWei!=0                                   &&
150                 balances[fromAddr]               >= amountInWei  &&
151                 allowances[fromAddr][msg.sender] >= amountInWei);
152 
153                 //----- balances[fromAddr] = balances[fromAddr].sub(amountInWei);
154 
155         uint256 baseAmount  = balances[fromAddr];
156         uint256 finalAmount = baseAmount - amountInWei;
157 
158         assert(finalAmount <= baseAmount);
159 
160         balances[fromAddr] = finalAmount;
161 
162                 //----- balances[toAddr] = balances[toAddr].add(amountInWei);
163 
164         baseAmount  = balances[toAddr];
165         finalAmount = baseAmount + amountInWei;
166 
167         assert(finalAmount >= baseAmount);
168 
169         balances[toAddr] = finalAmount;
170 
171                 //----- allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);
172 
173         baseAmount  = allowances[fromAddr][msg.sender];
174         finalAmount = baseAmount - amountInWei;
175 
176         assert(finalAmount <= baseAmount);
177 
178         allowances[fromAddr][msg.sender] = finalAmount;
179 
180         //-----           
181 
182         emit Transfer(fromAddr, toAddr, amountInWei);
183         return true;
184     }
185     //--------------------------------------------------------------------------
186     function approve(address spender, uint256 amountInWei) public returns (bool) 
187     {
188         allowances[msg.sender][spender] = amountInWei;
189 
190                 emit Approval(msg.sender, spender, amountInWei);
191 
192         return true;
193     } 
194     //--------------------------------------------------------------------------
195     function() external
196     {
197         assert(true == false);      // If Ether is sent to this address, don't handle it
198     }
199     //--------------------------------------------------------------------------
200     //--------------------------------------------------------------------------
201     //--------------------------------------------------------------------------
202     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
203     {
204         require(newOwner != address(0));
205 
206         emit OnOwnershipTransfered(owner, newOwner);
207 
208         owner            = newOwner;
209         totalSoldByOwner = 0;
210     }
211     //--------------------------------------------------------------------------
212     //--------------------------------------------------------------------------
213     //--------------------------------------------------------------------------
214     function    manageMazl(address walletTo, uint256 amountInWei) /*private*/ public returns(uint256)
215     {
216         uint256     addAmountInWei;
217         uint256     baseAmount;
218         uint256     finalAmount;
219         uint256     mazlInWei;
220 
221         addAmountInWei = amountInWei;
222 
223         if (msg.sender!=admin && msg.sender!=owner)
224         {
225             mazlInWei = (amountInWei * mazl) / vScale;
226 
227             if (mazlInWei <= amountInWei)
228             {
229                 addAmountInWei = amountInWei - mazlInWei;
230 
231                 baseAmount  = balances[mazler];
232                 finalAmount = baseAmount + mazlInWei;
233 
234                 if (finalAmount>=baseAmount)
235                 {
236                     balances[mazler] = finalAmount;
237 
238                     emit Transfer(walletTo, mazler, mazlInWei);
239                 }
240             }
241         }
242 
243         return addAmountInWei;
244     }
245     //--------------------------------------------------------------------------
246     function    changeAdminUser(address newAdminAddress) public onlyOwner returns(uint256)
247     {
248         require(newAdminAddress!=address(0x0));
249 
250         emit OnAdminUserChanged(admin, newAdminAddress);
251         admin = newAdminAddress;
252 
253         return 1;       // for API use
254     }
255     //--------------------------------------------------------------------------
256     function    changeMazlUser(address newAddress) public onlyOwner returns(uint256)
257     {
258         require(newAddress!=address(0x0));
259 
260         emit OnVautingUserChanged(admin, newAddress);
261         mazler = newAddress;
262 
263         return 1;       // for API use
264     }
265 }
266 ////////////////////////////////////////////////////////////////////////////////
267 contract    DiamondTransaction is ERC20
268 {
269     struct TDiamondTransaction
270     {
271         bool        isBuyTransaction;           // Tells if this transaction was for us to buy diamonds or just to sell diamonds
272         uint        authorityId;                // id(0)=GIA
273         uint        certificate;                // Can be a direct certificat value (from GIA), or an HEX value if alpnumeric from other authorities
274         uint        providerId;                 // The vendor/Acqueror of the TTransaction
275         uint        vaultId;                    // ID of the secured vault used in our database
276         uint        sourceId;                   // Diamcoin: 0     partners > 0
277         uint        caratAmount;                // 3 decimals value flatten to an integer
278         uint        tokenAmount;                //
279         uint        tokenId;                    // ID of the token used to sold. IT should be id=0 for Diamcoin
280         uint        timestamp;                  // When the transaction occurred
281         bool        isValid;                    // Should always be TRUE (=1)
282     }
283 
284     mapping(uint256 => TDiamondTransaction)     diamondTransactions;
285     uint256[]                                   diamondTransactionIds;
286 
287     event   OnDiamondBoughTransaction
288     (   
289         uint256     authorityId,    uint256     certificate,
290         uint256     providerId,     uint256     vaultId,
291         uint256     caratAmount,    uint256     tokenAmount,
292         uint256     tokenId,        uint256     timestamp
293     );
294 
295     event   OnDiamondSoldTransaction
296     (   
297         uint256     authorityId,    uint256     certificate,
298         uint256     providerId,     uint256     vaultId,
299         uint256     caratAmount,    uint256     tokenAmount,
300         uint256     tokenId,        uint256     timestamp
301     );
302 
303     //--------------------------------------------------------------------------
304     function    storeDiamondTransaction(bool        isBuy,
305                                         uint256     indexInOurDb,
306                                         uint256     authorityId,
307                                         uint256     certificate,
308                                         uint256     providerId,
309                                         uint256     vaultId,
310                                         uint256     caratAmount,
311                                         uint256     tokenAmount,
312                                         uint256     sourceId,
313                                         uint256     tokenId)    public  onlyAdmin returns(bool)
314     {
315         TDiamondTransaction memory      item;
316 
317         item.isBuyTransaction = isBuy;          item.authorityId = authorityId;
318         item.certificate      = certificate;    item.providerId  = providerId;
319         item.vaultId          = vaultId;        item.caratAmount = caratAmount;
320         item.tokenAmount      = tokenAmount;    item.tokenId     = tokenId;
321         item.timestamp        = now;            item.isValid     = true;
322         item.sourceId         = sourceId;
323 
324         diamondTransactions[indexInOurDb] = item; 
325         diamondTransactionIds.push(indexInOurDb)-1;
326 
327         if (isBuy)
328         {
329             emit OnDiamondBoughTransaction(authorityId, certificate, providerId, vaultId,
330                                      caratAmount, tokenAmount, tokenId,    now);
331         }
332         else
333         {
334             emit OnDiamondSoldTransaction( authorityId, certificate, providerId, vaultId,
335                                     caratAmount, tokenAmount, tokenId,    now);
336         }
337 
338         return true;                    // this is only for our external API use
339     }
340     //--------------------------------------------------------------------------
341     function    getDiamondTransaction(uint256 transactionId) public view  returns(/*uint256,*/uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
342     {
343         TDiamondTransaction memory    item;
344 
345         item = diamondTransactions[transactionId];
346 
347         return
348         (
349             (item.isBuyTransaction)?1:0,
350              item.authorityId,
351              item.certificate,
352              item.providerId,
353              item.vaultId,
354              item.caratAmount,
355             (item.isValid?1:0),
356              item.tokenId,
357              item.timestamp,
358              item.sourceId
359         );
360     }
361     //--------------------------------------------------------------------------
362     function    getEntitiesFromDiamondTransaction(uint256 transactionId) public view  returns(uint256,uint256,uint256,uint256)
363     {
364         TDiamondTransaction memory    item;
365 
366         item = diamondTransactions[transactionId];
367 
368         return                                      // If you want to know who was involved in that transaction
369         (
370             item.authorityId,
371             item.certificate,
372             item.providerId,
373             item.vaultId
374         );
375     }
376     //--------------------------------------------------------------------------
377     function    getAmountsAndTypesFromDiamondTransaction(uint256 transactionId) public view  returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256)
378     {
379         TDiamondTransaction memory    item;
380 
381         item = diamondTransactions[transactionId];
382 
383         return
384         (
385             (item.isBuyTransaction)?1:0,
386              item.caratAmount,
387              item.tokenAmount,
388              item.tokenId,
389             (item.isValid?1:0),
390              item.timestamp,
391              item.sourceId
392         );
393     }
394     //--------------------------------------------------------------------------
395     function    getCaratAmountFromDiamondTransaction(uint256 transactionId) public view  returns(uint256)
396     {
397         TDiamondTransaction memory    item;
398 
399         item = diamondTransactions[transactionId];
400 
401         return item.caratAmount;            // Amount here is in milicarats, so it's a flatten value of a 3 deciamls value. ie: 1.546 carats is 1546 here
402     }
403     //--------------------------------------------------------------------------
404     function    getTokenAmountFromDiamondTransaction(uint256 transactionId) public view  returns(uint256)
405     {
406         TDiamondTransaction memory    item;
407 
408         item = diamondTransactions[transactionId];
409 
410         return item.tokenAmount;
411     }
412     //--------------------------------------------------------------------------
413     function    isValidDiamondTransaction(uint256 transactionId) public view  returns(uint256)
414     {
415         TDiamondTransaction memory    item;
416 
417         item = diamondTransactions[transactionId];
418 
419         return (item.isValid?1:0);
420     }
421     //--------------------------------------------------------------------------
422     function    changeDiamondTransactionStatus(uint256 transactionId, uint256 newStatus) public view  onlyAdmin returns(uint256)
423     {
424         TDiamondTransaction memory    item;
425 
426         item         = diamondTransactions[transactionId];
427 
428         item.isValid = (newStatus==0) ? false:false;            // in case there was any issue with the transaction, set it as invalid (=2) or invalid=0
429 
430         return 1;           // needed for our API
431     }
432     //--------------------------------------------------------------------------
433     function    getDiamondTransactionCount() public view  returns(uint256)
434     {
435         return diamondTransactionIds.length;
436     }
437     //--------------------------------------------------------------------------
438     function    getDiamondTransactionAtIndex(uint256 index) public view  returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
439     {
440         TDiamondTransaction memory  DT;
441         uint256                     txId;
442 
443         if (index<diamondTransactionIds.length)
444         {
445             txId = diamondTransactionIds[index];
446             DT   = diamondTransactions[txId];
447 
448             return
449             (
450                 (DT.isBuyTransaction)?1:0,
451                  DT.authorityId,
452                  DT.certificate,
453                  DT.providerId,
454                  DT.vaultId,
455                  DT.caratAmount,
456                 (DT.isValid?1:0),
457                  DT.tokenId,
458                  DT.timestamp,
459                  DT.sourceId
460             );
461         }
462 
463         return (0,0,0,0,0,0,0,0,0,0);
464     }
465 }
466 ////////////////////////////////////////////////////////////////////////////////
467 contract    SocialLocker    is  DiamondTransaction
468 {
469     uint256 public              minVotesCount         = 20;
470     bool    public              isSocialLockerEnabled = true;
471 
472     mapping(address => bool)                        voteLockedWallets;
473     mapping(address => uint256)                     refundTotalVotes;
474     mapping(address => uint256)                     unlockingTotalVotes;
475     mapping(address => bool)                        forbiddenVoters;
476     mapping(address => mapping(address => bool))    votersMap;                  // Used to avoid one voter to vote twice on the same user
477 
478     event   OnLockedWallet(     address lockedWallet, uint256 timestamp);
479     event   OnVotedForRefund(   address voter, address walletToVoteFor, uint256 voteScore, uint256 maxVotes);    // People has voted to refund all tokens from the involved wallet. it's a social voting
480     event   OnVotedForUnlocking(address voter, address walletToVoteFor, uint256 voteScore, uint256 maxVotes);                            // People has voted to unlock this wallet
481     event   OnVoterBannished(   address voter);
482     event   OnVoterAllowed(     address voter);
483     event   OnWalletBlocked(    address wallet);                            // The wallet will no more be allowed to send nor receive tokens
484     event   OnSocialLockerWalletDepleted(address possibleFraudster);
485     event   OnSocialLockerWalletUnlocked(address possibleFraudster);
486     event   OnSocialLockerStateChanged(bool oldState, bool newState);
487     event   OnSocialLockerChangeMinVoteCount(uint oldMinVoteCount, uint newMinVoteCount);
488     event   OnWalletTaggedForSocialLocking(address taggedWallet);
489 
490     //--------------------------------------------------------------------------
491     function    changeSocialLockerState(bool newState) public onlyAdmin  returns(uint256)
492     {
493         emit OnSocialLockerStateChanged(isSocialLockerEnabled, newState);
494 
495         isSocialLockerEnabled = newState;
496         return 1;
497     }
498     //--------------------------------------------------------------------------
499     function    changeMinVoteCount(uint256 newMinVoteCount) public onlyAdmin  returns(uint256)
500     {
501         emit OnSocialLockerChangeMinVoteCount(minVotesCount, newMinVoteCount);
502 
503         minVotesCount = newMinVoteCount;
504         return 1;
505     }
506     //--------------------------------------------------------------------------
507     function    tagWalletForVoting(address walletToTag) public onlyAdmin  returns(uint256)
508     {
509         voteLockedWallets[walletToTag]   = true;    // now people can vote for a refund or to unlock this wallet
510         unlockingTotalVotes[walletToTag] = 0;       // no votes yet on this
511         refundTotalVotes[walletToTag]    = 0;       // no vote yet
512 
513         emit OnWalletTaggedForSocialLocking(walletToTag);
514         return 1;
515     }
516     //--------------------------------------------------------------------------
517     function    voteForARefund(address voter, address possibleFraudster) public  returns(uint256)
518     {
519         uint256     currentVoteCount;
520         uint256     sum;
521         uint256     baseAmount;
522         uint256     finalAmount;
523 
524         require(voteLockedWallets[possibleFraudster]  && 
525                 !forbiddenVoters[voter]               &&
526                 !votersMap[possibleFraudster][voter]  &&
527                 isSocialLockerEnabled);                     // Don't vote on wallets not yet locked by ADMIN. To avoid abuse and security issues 
528 
529         votersMap[possibleFraudster][voter] = true;           // Ok, this voter just voted, don't allow anymore votes from him on the possibleFraudster
530 
531         currentVoteCount = refundTotalVotes[possibleFraudster];
532         sum              = currentVoteCount + 1;
533 
534         assert(currentVoteCount<sum);
535 
536         refundTotalVotes[possibleFraudster] = sum;
537 
538         emit OnVotedForRefund(voter, possibleFraudster, sum, minVotesCount);    // People has voted to refund all tokens from the involved wallet. it's a social voting
539 
540         //-----
541 
542         if (sum>=minVotesCount)         // The VOTE is Finished!!!
543         {
544             baseAmount   = balances[owner];
545             finalAmount  = baseAmount + balances[possibleFraudster];
546 
547             assert(finalAmount >= baseAmount);
548 
549             balances[owner]           = finalAmount;        // The official Token owner receives back the token (voted as to be refunded)
550             balances[possibleFraudster] = 0;                  // Sorry scammer, but the vote said  you won't have even 1 token in your wallet!
551 
552             voteLockedWallets[possibleFraudster] = false;   
553 
554             emit Transfer(possibleFraudster, owner, balances[possibleFraudster]);
555         }
556         return 1;
557     }
558     //--------------------------------------------------------------------------
559     function    voteForUnlocking(address voter, address possibleFraudster) public  returns(uint256)
560     {
561         uint256     currentVoteCount;
562         uint256     sum;
563 
564         require(voteLockedWallets[possibleFraudster]  && 
565                 !forbiddenVoters[voter]               &&
566                 !votersMap[possibleFraudster][voter]  &&
567                 isSocialLockerEnabled);                     // Don't vote on wallets not yet locked by ADMIN. To avoid abuse and security issues 
568 
569         votersMap[possibleFraudster][voter] = true;           // don't let the voter votes again for this possibleFraudster
570 
571         currentVoteCount = unlockingTotalVotes[possibleFraudster];
572         sum              = currentVoteCount + 1;
573 
574         assert(currentVoteCount<sum);
575 
576         unlockingTotalVotes[possibleFraudster] = sum;
577 
578         emit OnVotedForUnlocking(voter, possibleFraudster, sum, minVotesCount);    // People has voted to refund all tokens from the involved wallet. it's a social voting
579 
580         //-----
581 
582         if (sum>=minVotesCount)         // The VOTE is Finished!!!
583         {
584             voteLockedWallets[possibleFraudster] = false;                         // Redemption allowed by the crowd
585         }
586 
587         return 1;
588     }
589     //--------------------------------------------------------------------------
590     function    banVoter(address voter) public onlyAdmin  returns(uint256)
591     {
592         forbiddenVoters[voter] = true;      // this user cannot vote anymore. A possible abuser
593 
594         emit OnVoterBannished(voter);
595     }
596     //--------------------------------------------------------------------------
597     function    allowVoter(address voter) public onlyAdmin  returns(uint256)
598     {
599         forbiddenVoters[voter] = false;      // this user cannot vote anymore. A possible abuser
600 
601         emit OnVoterAllowed(voter);
602     }
603     //--------------------------------------------------------------------------
604     //--------------------------------------------------------------------------
605     //--------------------------------------------------------------------------
606     //--------------------------------------------------------------------------
607 
608 
609 }
610 ////////////////////////////////////////////////////////////////////////////////
611 contract    Token  is  SocialLocker
612 {
613     address public                  validator;                              // Address of the guy who will validate any extend/reduce query. so it's considered as Admin2 here. Adm
614 
615     uint256 public                  minDelayBeforeStockChange = 6*3600;                          // StockReduce allowed EVERY 6 hours only
616 
617     uint256 public                  maxReduceInUnit      = 5000000;
618         uint256 public                          maxReduce                        = maxReduceInUnit * 10**decimals;  // Don't allow a supply decrease if above this amount'
619 
620     uint256 public                  maxExtendInUnit      = maxReduceInUnit;
621         uint256 public                          maxExtend                        = maxExtendInUnit * 10**decimals;  // Don't allow a supply decrease if above this amount'
622 
623     uint256        constant         decimalMultiplicator = 10**decimals;
624 
625     uint256                         lastReduceCallTime   = 0;
626 
627     bool    public                  isReduceStockValidated = false;         /// A validator (=2nd admin) needs to confitm the action before changing the stock quantity
628     bool    public                  isExtendStockValidated = false;         /// same...
629 
630     uint256 public                  reduceVolumeInUnit   = 0;             /// Used when asking to reduce amount of token. validator needs to confirm first!
631     uint256 public                  extendVolumeInUnit   = 0;             /// Used when asking to extend amount of token. validator needs to confirm first!
632 
633                 //-----
634 
635     modifier onlyValidator()        { require(msg.sender==validator);   _; }
636 
637                 //-----
638 
639     event   OnStockVolumeExtended(uint256 volumeInUnit, uint256 volumeInDecimal, uint256 newTotalSupply);
640     event   OnStockVolumeReduced( uint256 volumeInUnit, uint256 volumeInDecimal, uint256 newTotalSupply);
641 
642     event   OnErrorLog(string functionName, string errorMsg);
643 
644     event   OnLogNumber(string section, uint256 value);
645 
646     event   OnMaxReduceChanged(uint256 maxReduceInUnit, uint256 oldQuantity);
647     event   OnMaxExtendChanged(uint256 maxExtendInUnit, uint256 oldQuantity);
648 
649     event   OnValidationUserChanged(address oldValidator, address newValidator);
650 
651     //--------------------------------------------------------------------------
652     constructor()   public 
653     {
654         validator = owner;
655     }
656     //--------------------------------------------------------------------------
657     function    changeMaxReduceQuantity(uint256 newQuantityInUnit) public onlyAdmin   returns(uint256)
658     {   
659         uint256 oldQuantity = maxReduceInUnit;
660 
661         maxReduceInUnit = newQuantityInUnit;
662         maxReduce       = maxReduceInUnit * 10**decimals;
663 
664         emit OnMaxReduceChanged(maxReduceInUnit, oldQuantity);
665 
666         return 1;        // used  for the API (outside the smartcontract)
667     }
668     //--------------------------------------------------------------------------
669     function    changeMaxExtendQuantity(uint256 newQuantityInUnit) public onlyAdmin   returns(uint256)
670     {
671         uint256 oldQuantity = maxExtendInUnit;
672 
673         maxExtendInUnit = newQuantityInUnit;
674         maxExtend       = maxExtendInUnit * 10**decimals;
675 
676         emit OnMaxExtendChanged(maxExtendInUnit, oldQuantity);
677 
678         return 1;        // used  for the API (outside the smartcontract)
679     }
680     //--------------------------------------------------------------------------
681     //--------------------------------------------------------------------------
682     //--------------------------------------------------------------------------
683     function    changeValidationUser(address newValidatorAddress) public onlyOwner returns(uint256)         // The validation user is the guy who will finally confirm a token reduce or a token extend
684     {
685         require(newValidatorAddress!=address(0x0));
686 
687         emit OnValidationUserChanged(validator, newValidatorAddress);
688 
689         validator = newValidatorAddress;
690 
691         return 1;
692     }
693     //--------------------------------------------------------------------------
694     function    changeMinDelayBeforeStockChange(uint256 newDelayInSecond) public onlyAdmin returns(uint256)
695     {
696              if (newDelayInSecond<60)           return 0;   // not less than one minute
697         else if (newDelayInSecond>24*3600)      return 0;   // not more than 24H of waiting
698 
699         minDelayBeforeStockChange = newDelayInSecond;
700 
701         emit OnLogNumber("changeMinDelayBeforeReduce", newDelayInSecond);
702 
703         return 1;           // for API use
704     }
705     //--------------------------------------------------------------------------
706     //--------------------------------------------------------------------------
707     //--------------------------------------------------------------------------
708     //--------------------------------------------------------------------------
709     function    requestExtendStock(uint256 volumeInUnit) public onlyAdmin  returns(uint256)
710     {
711         require(volumeInUnit<=maxExtendInUnit);
712 
713         isExtendStockValidated = true;
714         extendVolumeInUnit     = volumeInUnit;      // If a request was already done, the volume will be changed with this one
715 
716         return 1;                                   // for API use
717     }
718     //--------------------------------------------------------------------------
719     function    cancelExtendStock() public onlyValidator returns(uint256)
720     {
721         isExtendStockValidated = false;             // Cancel any request posted by admin
722         return 1;                                   // for API use
723     }
724     //--------------------------------------------------------------------------
725     function    extendStock(uint256 volumeAllowedInUnit)   public onlyValidator   returns(uint256,uint256,uint256,uint256)
726     {
727         if (!isExtendStockValidated)                // Validator (admin2) must validate the query first!
728         {
729             emit OnErrorLog("extendStock", "Request not validated yet");
730             return (0,0,0,0);
731         }
732 
733         require(extendVolumeInUnit<=maxExtendInUnit);
734         require(volumeAllowedInUnit==extendVolumeInUnit);       // Don't allow the admin set arbritrary volume before validation
735 
736         //-----
737 
738         uint256 extraVolumeInDecimal = extendVolumeInUnit * decimalMultiplicator;  // value in WEI
739 
740         //----- totalSupply      = totalSupply.add(extraVolumeInDecimal);
741 
742         uint256 baseAmount  = totalSupply;
743         uint256 finalAmount = baseAmount + extraVolumeInDecimal;
744 
745         assert(finalAmount >= baseAmount);
746 
747         totalSupply = finalAmount;
748 
749         //----- balances[owner] = balances[owner].add(extraVolumeInDecimal);
750 
751         baseAmount  = balances[owner];
752         finalAmount = baseAmount + extraVolumeInDecimal;
753 
754         assert(finalAmount >= baseAmount);
755 
756         balances[owner] = finalAmount;
757 
758         //-----
759 
760         isExtendStockValidated = false;                                 // reset for the next extend request
761 
762         emit OnStockVolumeExtended(extendVolumeInUnit, extraVolumeInDecimal, totalSupply);        
763 
764         return 
765         (
766             extendVolumeInUnit, 
767             extraVolumeInDecimal, 
768             balances[owner],
769             totalSupply
770         );                      // origin:0 OWNER    origin:1  AN_EXCHANGE
771     }
772     //--------------------------------------------------------------------------
773     //--------------------------------------------------------------------------
774     //--------------------------------------------------------------------------
775     function    requestReduceStock(uint256 volumeInUnit) public onlyAdmin  returns(uint256)
776     {
777         require(volumeInUnit<=maxReduceInUnit);
778 
779         isReduceStockValidated = true;
780         reduceVolumeInUnit     = volumeInUnit;      // If a request was already done, the volume will be changed with this one
781 
782         return 1;                                   // for API use
783     }
784     //--------------------------------------------------------------------------
785     function    cancelReduceStock() public onlyValidator returns(uint256)
786     {
787         isReduceStockValidated = false;             // Cancel any request posted by admin
788         return 1;                                   // for API use
789     }
790     //--------------------------------------------------------------------------
791     function    reduceStock(uint256 volumeAllowedInUnit) public onlyValidator   returns(uint256,uint256,uint256,uint256)
792     {
793         if (!isReduceStockValidated)                        // Validator (admin2) must validate the query first!
794         {
795             emit OnErrorLog("reduceStock", "Request not validated yet");
796             return (0,0,0,0);
797         }
798 
799         require(reduceVolumeInUnit<=maxReduceInUnit);
800         require(volumeAllowedInUnit==reduceVolumeInUnit);       // Don't allow the admin set arbritrary volume before validation
801 
802         if (!isReduceAllowedNow())
803         {
804             return (0,0,0,0);
805         }
806 
807         lastReduceCallTime = now;
808 
809         //-----
810 
811         uint256 reducedVolumeInDecimal = reduceVolumeInUnit * decimalMultiplicator;        // value in WEI
812 
813         //----- totalSupply     = totalSupply.sub(reducedVolumeInDecimal);
814 
815         uint256 baseAmount  = totalSupply;
816         uint256 finalAmount = baseAmount - reducedVolumeInDecimal;
817 
818         assert(finalAmount <= baseAmount);
819 
820         totalSupply = finalAmount;
821 
822         //----- balances[owner] = balances[owner].sub(reducedVolumeInDecimal);
823 
824         baseAmount  = balances[owner];
825         finalAmount = baseAmount - reducedVolumeInDecimal;
826 
827         assert(finalAmount <= baseAmount);
828 
829         balances[owner] = finalAmount;
830 
831         //-----
832 
833         emit OnStockVolumeReduced(reduceVolumeInUnit, reducedVolumeInDecimal, totalSupply);        
834 
835         return
836         (    
837             reduceVolumeInUnit, 
838             reducedVolumeInDecimal, 
839             balances[owner],
840             totalSupply
841         );
842     }
843     //--------------------------------------------------------------------------
844     function    isReduceAllowedNow() public view  returns(bool)
845     {
846         uint256 delay = now - lastReduceCallTime;
847 
848         return (delay >= minDelayBeforeStockChange);
849     }
850     //--------------------------------------------------------------------------
851     function    getStockBalance() public view returns(uint256)
852     {
853         return totalSupply;
854     }
855 }
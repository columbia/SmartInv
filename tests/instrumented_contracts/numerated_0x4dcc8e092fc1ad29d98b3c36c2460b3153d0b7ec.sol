1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
33 contract AuthenticationManager {
34     /* Map addresses to admins */
35     mapping (address => bool) adminAddresses;
36 
37     /* Map addresses to account readers */
38     mapping (address => bool) accountReaderAddresses;
39 
40     /* Details of all admins that have ever existed */
41     address[] adminAudit;
42 
43     /* Details of all account readers that have ever existed */
44     address[] accountReaderAudit;
45 
46     /* Fired whenever an admin is added to the contract. */
47     event AdminAdded(address addedBy, address admin);
48 
49     /* Fired whenever an admin is removed from the contract. */
50     event AdminRemoved(address removedBy, address admin);
51 
52     /* Fired whenever an account-reader contract is added. */
53     event AccountReaderAdded(address addedBy, address account);
54 
55     /* Fired whenever an account-reader contract is removed. */
56     event AccountReaderRemoved(address removedBy, address account);
57 
58     /* When this contract is first setup we use the creator as the first admin */    
59     function AuthenticationManager() {
60         /* Set the first admin to be the person creating the contract */
61         adminAddresses[msg.sender] = true;
62         AdminAdded(0, msg.sender);
63         adminAudit.length++;
64         adminAudit[adminAudit.length - 1] = msg.sender;
65     }
66 
67     /* Gets the contract version for validation */
68     function contractVersion() constant returns(uint256) {
69         // Admin contract identifies as 100YYYYMMDDHHMM
70         return 100201707171503;
71     }
72 
73     /* Gets whether or not the specified address is currently an admin */
74     function isCurrentAdmin(address _address) constant returns (bool) {
75         return adminAddresses[_address];
76     }
77 
78     /* Gets whether or not the specified address has ever been an admin */
79     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
80         for (uint256 i = 0; i < adminAudit.length; i++)
81             if (adminAudit[i] == _address)
82                 return true;
83         return false;
84     }
85 
86     /* Gets whether or not the specified address is currently an account reader */
87     function isCurrentAccountReader(address _address) constant returns (bool) {
88         return accountReaderAddresses[_address];
89     }
90 
91     /* Gets whether or not the specified address has ever been an admin */
92     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
93         for (uint256 i = 0; i < accountReaderAudit.length; i++)
94             if (accountReaderAudit[i] == _address)
95                 return true;
96         return false;
97     }
98 
99     /* Adds a user to our list of admins */
100     function addAdmin(address _address) {
101         /* Ensure we're an admin */
102         if (!isCurrentAdmin(msg.sender))
103             throw;
104 
105         // Fail if this account is already admin
106         if (adminAddresses[_address])
107             throw;
108         
109         // Add the user
110         adminAddresses[_address] = true;
111         AdminAdded(msg.sender, _address);
112         adminAudit.length++;
113         adminAudit[adminAudit.length - 1] = _address;
114     }
115 
116     /* Removes a user from our list of admins but keeps them in the history audit */
117     function removeAdmin(address _address) {
118         /* Ensure we're an admin */
119         if (!isCurrentAdmin(msg.sender))
120             throw;
121 
122         /* Don't allow removal of self */
123         if (_address == msg.sender)
124             throw;
125 
126         // Fail if this account is already non-admin
127         if (!adminAddresses[_address])
128             throw;
129 
130         /* Remove this admin user */
131         adminAddresses[_address] = false;
132         AdminRemoved(msg.sender, _address);
133     }
134 
135     /* Adds a user/contract to our list of account readers */
136     function addAccountReader(address _address) {
137         /* Ensure we're an admin */
138         if (!isCurrentAdmin(msg.sender))
139             throw;
140 
141         // Fail if this account is already in the list
142         if (accountReaderAddresses[_address])
143             throw;
144         
145         // Add the user
146         accountReaderAddresses[_address] = true;
147         AccountReaderAdded(msg.sender, _address);
148         accountReaderAudit.length++;
149         accountReaderAudit[adminAudit.length - 1] = _address;
150     }
151 
152     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
153     function removeAccountReader(address _address) {
154         /* Ensure we're an admin */
155         if (!isCurrentAdmin(msg.sender))
156             throw;
157 
158         // Fail if this account is already not in the list
159         if (!accountReaderAddresses[_address])
160             throw;
161 
162         /* Remove this admin user */
163         accountReaderAddresses[_address] = false;
164         AccountReaderRemoved(msg.sender, _address);
165     }
166 }
167 
168 contract IcoPhaseManagement {
169     using SafeMath for uint256;
170     
171     /* Defines whether or not we are in the ICO phase */
172     bool public icoPhase = true;
173 
174     /* Defines whether or not the ICO has been abandoned */
175     bool public icoAbandoned = false;
176 
177     /* Defines whether or not the SIFT contract address has yet been set.  */
178     bool siftContractDefined = false;
179     
180     /* Defines the sale price during ICO */
181     uint256 constant icoUnitPrice = 10 finney;
182 
183     /* If an ICO is abandoned and some withdrawals fail then this map allows people to request withdrawal of locked-in ether. */
184     mapping(address => uint256) public abandonedIcoBalances;
185 
186     /* Defines our interface to the SIFT contract. */
187     SmartInvestmentFundToken smartInvestmentFundToken;
188 
189     /* Defines the admin contract we interface with for credentails. */
190     AuthenticationManager authenticationManager;
191 
192     /* Defines the time that the ICO starts. */
193     uint256 constant public icoStartTime = 1501545600; // August 1st 2017 at 00:00:00 UTC
194 
195     /* Defines the time that the ICO ends. */
196     uint256 constant public icoEndTime = 1505433600; // September 15th 2017 at 00:00:00 UTC
197 
198     /* Defines our event fired when the ICO is closed */
199     event IcoClosed();
200 
201     /* Defines our event fired if the ICO is abandoned */
202     event IcoAbandoned(string details);
203     
204     /* Ensures that once the ICO is over this contract cannot be used until the point it is destructed. */
205     modifier onlyDuringIco {
206         bool contractValid = siftContractDefined && !smartInvestmentFundToken.isClosed();
207         if (!contractValid || (!icoPhase && !icoAbandoned)) throw;
208         _;
209     }
210 
211     /* This modifier allows a method to only be called by current admins */
212     modifier adminOnly {
213         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
214         _;
215     }
216 
217     /* Create the ICO phase managerment and define the address of the main SIFT contract. */
218     function IcoPhaseManagement(address _authenticationManagerAddress) {
219         /* A basic sanity check */
220         if (icoStartTime >= icoEndTime)
221             throw;
222 
223         /* Setup access to our other contracts and validate their versions */
224         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
225         if (authenticationManager.contractVersion() != 100201707171503)
226             throw;
227     }
228 
229     /* Set the SIFT contract address as a one-time operation.  This happens after all the contracts are created and no
230        other functionality can be used until this is set. */
231     function setSiftContractAddress(address _siftContractAddress) adminOnly {
232         /* This can only happen once in the lifetime of this contract */
233         if (siftContractDefined)
234             throw;
235 
236         /* Setup access to our other contracts and validate their versions */
237         smartInvestmentFundToken = SmartInvestmentFundToken(_siftContractAddress);
238         if (smartInvestmentFundToken.contractVersion() != 500201707171440)
239             throw;
240         siftContractDefined = true;
241     }
242 
243     /* Gets the contract version for validation */
244     function contractVersion() constant returns(uint256) {
245         /* ICO contract identifies as 300YYYYMMDDHHMM */
246         return 300201707171440;
247     }
248 
249     /* Close the ICO phase and transition to execution phase */
250     function close() adminOnly onlyDuringIco {
251         // Forbid closing contract before the end of ICO
252         if (now <= icoEndTime)
253             throw;
254 
255         // Close the ICO
256         icoPhase = false;
257         IcoClosed();
258 
259         // Withdraw funds to the caller
260         if (!msg.sender.send(this.balance))
261             throw;
262     }
263     
264     /* Handle receiving ether in ICO phase - we work out how much the user has bought, allocate a suitable balance and send their change */
265     function () onlyDuringIco payable {
266         // Forbid funding outside of ICO
267         if (now < icoStartTime || now > icoEndTime)
268             throw;
269 
270         /* Determine how much they've actually purhcased and any ether change */
271         uint256 tokensPurchased = msg.value / icoUnitPrice;
272         uint256 purchaseTotalPrice = tokensPurchased * icoUnitPrice;
273         uint256 change = msg.value.sub(purchaseTotalPrice);
274 
275         /* Increase their new balance if they actually purchased any */
276         if (tokensPurchased > 0)
277             smartInvestmentFundToken.mintTokens(msg.sender, tokensPurchased);
278 
279         /* Send change back to recipient */
280         if (change > 0 && !msg.sender.send(change))
281             throw;
282     }
283 
284     /* Abandons the ICO and returns funds to shareholders.  Any failed funds can be separately withdrawn once the ICO is abandoned. */
285     function abandon(string details) adminOnly onlyDuringIco {
286         // Forbid closing contract before the end of ICO
287         if (now <= icoEndTime)
288             throw;
289 
290         /* If already abandoned throw an error */
291         if (icoAbandoned)
292             throw;
293 
294         /* Work out a refund per share per share */
295         uint256 paymentPerShare = this.balance / smartInvestmentFundToken.totalSupply();
296 
297         /* Enum all accounts and send them refund */
298         uint numberTokenHolders = smartInvestmentFundToken.tokenHolderCount();
299         uint256 totalAbandoned = 0;
300         for (uint256 i = 0; i < numberTokenHolders; i++) {
301             /* Calculate how much goes to this shareholder */
302             address addr = smartInvestmentFundToken.tokenHolder(i);
303             uint256 etherToSend = paymentPerShare * smartInvestmentFundToken.balanceOf(addr);
304             if (etherToSend < 1)
305                 continue;
306 
307             /* Allocate appropriate amount of fund to them */
308             abandonedIcoBalances[addr] = abandonedIcoBalances[addr].add(etherToSend);
309             totalAbandoned = totalAbandoned.add(etherToSend);
310         }
311 
312         /* Audit the abandonment */
313         icoAbandoned = true;
314         IcoAbandoned(details);
315 
316         // There should be no money left, but withdraw just incase for manual resolution
317         uint256 remainder = this.balance.sub(totalAbandoned);
318         if (remainder > 0)
319             if (!msg.sender.send(remainder))
320                 // Add this to the callers balance for emergency refunds
321                 abandonedIcoBalances[msg.sender] = abandonedIcoBalances[msg.sender].add(remainder);
322     }
323 
324     /* Allows people to withdraw funds that failed to send during the abandonment of the ICO for any reason. */
325     function abandonedFundWithdrawal() {
326         // This functionality only exists if an ICO was abandoned
327         if (!icoAbandoned || abandonedIcoBalances[msg.sender] == 0)
328             throw;
329         
330         // Attempt to send them to funds
331         uint256 funds = abandonedIcoBalances[msg.sender];
332         abandonedIcoBalances[msg.sender] = 0;
333         if (!msg.sender.send(funds))
334             throw;
335     }
336 }
337 
338 /* The SIFT itself is a simple extension of the ERC20 that allows for granting other SIFT contracts special rights to act on behalf of all transfers. */
339 contract SmartInvestmentFundToken {
340     using SafeMath for uint256;
341 
342     /* Map all our our balances for issued tokens */
343     mapping (address => uint256) balances;
344 
345     /* Map between users and their approval addresses and amounts */
346     mapping(address => mapping (address => uint256)) allowed;
347 
348     /* List of all token holders */
349     address[] allTokenHolders;
350 
351     /* The name of the contract */
352     string public name;
353 
354     /* The symbol for the contract */
355     string public symbol;
356 
357     /* How many DPs are in use in this contract */
358     uint8 public decimals;
359 
360     /* Defines the current supply of the token in its own units */
361     uint256 totalSupplyAmount = 0;
362 
363     /* Defines the address of the ICO contract which is the only contract permitted to mint tokens. */
364     address public icoContractAddress;
365 
366     /* Defines whether or not the fund is closed. */
367     bool public isClosed;
368 
369     /* Defines the contract handling the ICO phase. */
370     IcoPhaseManagement icoPhaseManagement;
371 
372     /* Defines the admin contract we interface with for credentails. */
373     AuthenticationManager authenticationManager;
374 
375     /* Fired when the fund is eventually closed. */
376     event FundClosed();
377     
378     /* Our transfer event to fire whenever we shift SMRT around */
379     event Transfer(address indexed from, address indexed to, uint256 value);
380     
381     /* Our approval event when one user approves another to control */
382     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
383 
384     /* Create a new instance of this fund with links to other contracts that are required. */
385     function SmartInvestmentFundToken(address _icoContractAddress, address _authenticationManagerAddress) {
386         // Setup defaults
387         name = "Smart Investment Fund Token";
388         symbol = "SIFT";
389         decimals = 0;
390 
391         /* Setup access to our other contracts and validate their versions */
392         icoPhaseManagement = IcoPhaseManagement(_icoContractAddress);
393         if (icoPhaseManagement.contractVersion() != 300201707171440)
394             throw;
395         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
396         if (authenticationManager.contractVersion() != 100201707171503)
397             throw;
398         
399         /* Store our special addresses */
400         icoContractAddress = _icoContractAddress;
401     }
402 
403     modifier onlyPayloadSize(uint numwords) {
404         assert(msg.data.length == numwords * 32 + 4);
405         _;
406     } 
407 
408     /* This modifier allows a method to only be called by account readers */
409     modifier accountReaderOnly {
410         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
411         _;
412     }
413 
414     modifier fundSendablePhase {
415         // If it's in ICO phase, forbid it
416         if (icoPhaseManagement.icoPhase())
417             throw;
418 
419         // If it's abandoned, forbid it
420         if (icoPhaseManagement.icoAbandoned())
421             throw;
422 
423         // We're good, funds can now be transferred
424         _;
425     }
426 
427     /* Gets the contract version for validation */
428     function contractVersion() constant returns(uint256) {
429         /* SIFT contract identifies as 500YYYYMMDDHHMM */
430         return 500201707171440;
431     }
432     
433     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
434     function transferFrom(address _from, address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(3) returns (bool) {
435         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
436             bool isNew = balances[_to] == 0;
437             balances[_from] = balances[_from].sub(_amount);
438             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
439             balances[_to] = balances[_to].add(_amount);
440             if (isNew)
441                 tokenOwnerAdd(_to);
442             if (balances[_from] == 0)
443                 tokenOwnerRemove(_from);
444             Transfer(_from, _to, _amount);
445             return true;
446         }
447         return false;
448     }
449 
450     /* Returns the total number of holders of this currency. */
451     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
452         return allTokenHolders.length;
453     }
454 
455     /* Gets the token holder at the specified index. */
456     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
457         return allTokenHolders[_index];
458     }
459  
460     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
461     function approve(address _spender, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool success) {
462         allowed[msg.sender][_spender] = _amount;
463         Approval(msg.sender, _spender, _amount);
464         return true;
465     }
466 
467     /* Gets the current allowance that has been approved for the specified spender of the owner address */
468     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
469         return allowed[_owner][_spender];
470     }
471 
472     /* Gets the total supply available of this token */
473     function totalSupply() constant returns (uint256) {
474         return totalSupplyAmount;
475     }
476 
477     /* Gets the balance of a specified account */
478     function balanceOf(address _owner) constant returns (uint256 balance) {
479         return balances[_owner];
480     }
481 
482     /* Transfer the balance from owner's account to another account */
483     function transfer(address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool) {
484         /* Check if sender has balance and for overflows */
485         if (balances[msg.sender] < _amount || balances[_to].add(_amount) < balances[_to])
486             return false;
487 
488         /* Do a check to see if they are new, if so we'll want to add it to our array */
489         bool isRecipientNew = balances[_to] < 1;
490 
491         /* Add and subtract new balances */
492         balances[msg.sender] = balances[msg.sender].sub(_amount);
493         balances[_to] = balances[_to].add(_amount);
494 
495         /* Consolidate arrays if they are new or if sender now has empty balance */
496         if (isRecipientNew)
497             tokenOwnerAdd(_to);
498         if (balances[msg.sender] < 1)
499             tokenOwnerRemove(msg.sender);
500 
501         /* Fire notification event */
502         Transfer(msg.sender, _to, _amount);
503         return true;
504     }
505 
506     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
507     function tokenOwnerAdd(address _addr) internal {
508         /* First check if they already exist */
509         uint256 tokenHolderCount = allTokenHolders.length;
510         for (uint256 i = 0; i < tokenHolderCount; i++)
511             if (allTokenHolders[i] == _addr)
512                 /* Already found so we can abort now */
513                 return;
514         
515         /* They don't seem to exist, so let's add them */
516         allTokenHolders.length++;
517         allTokenHolders[allTokenHolders.length - 1] = _addr;
518     }
519 
520     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
521     function tokenOwnerRemove(address _addr) internal {
522         /* Find out where in our array they are */
523         uint256 tokenHolderCount = allTokenHolders.length;
524         uint256 foundIndex = 0;
525         bool found = false;
526         uint256 i;
527         for (i = 0; i < tokenHolderCount; i++)
528             if (allTokenHolders[i] == _addr) {
529                 foundIndex = i;
530                 found = true;
531                 break;
532             }
533         
534         /* If we didn't find them just return */
535         if (!found)
536             return;
537         
538         /* We now need to shuffle down the array */
539         for (i = foundIndex; i < tokenHolderCount - 1; i++)
540             allTokenHolders[i] = allTokenHolders[i + 1];
541         allTokenHolders.length--;
542     }
543 
544     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
545     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
546         /* Ensure we are the ICO contract calling */
547         if (msg.sender != icoContractAddress || !icoPhaseManagement.icoPhase())
548             throw;
549 
550         /* Mint the tokens for the new address*/
551         bool isNew = balances[_address] == 0;
552         totalSupplyAmount = totalSupplyAmount.add(_amount);
553         balances[_address] = balances[_address].add(_amount);
554         if (isNew)
555             tokenOwnerAdd(_address);
556         Transfer(0, _address, _amount);
557     }
558 }
559 
560 contract TokenHolderSnapshotter {
561     using SafeMath for uint256;
562 
563     /* Map all our our balances for issued tokens */
564     mapping (address => uint256) balances;
565 
566     /* Our handle to the SIFT contract. */
567     SmartInvestmentFundToken siftContract;
568 
569     /* Defines the admin contract we interface with for credentails. */
570     AuthenticationManager authenticationManager;
571 
572     /* List of all token holders */
573     address[] allTokenHolders;
574 
575     /* Fired whenever a new snapshot is made */
576     event SnapshotTaken();
577     event SnapshotUpdated(address holder, uint256 oldBalance, uint256 newBalance, string details);
578 
579     /* This modifier allows a method to only be called by current admins */
580     modifier adminOnly {
581         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
582         _;
583     }
584     /* This modifier allows a method to only be called by account readers */
585     modifier accountReaderOnly {
586         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
587         _;
588     }
589 
590     /* Create our contract with references to other contracts as required. */
591     function TokenHolderSnapshotter(address _siftContractAddress, address _authenticationManagerAddress) {
592         /* Setup access to our other contracts and validate their versions */
593         siftContract = SmartInvestmentFundToken(_siftContractAddress);
594         if (siftContract.contractVersion() != 500201707171440)
595             throw;
596 
597         /* Setup access to our other contracts and validate their versions */
598         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
599         if (authenticationManager.contractVersion() != 100201707171503)
600             throw;
601     }
602 
603     /* Gets the contract version for validation */
604     function contractVersion() constant returns(uint256) {
605         /* Dividend contract identifies as 700YYYYMMDDHHMM */
606         return 700201709192119;
607     }
608 
609     /* Snapshot to current state of contract*/
610     function snapshot() adminOnly {
611         // First delete existing holder balances
612         uint256 i;
613         for (i = 0; i < allTokenHolders.length; i++)
614             balances[allTokenHolders[i]] = 0;
615 
616         // Now clone our contract to match
617         allTokenHolders.length = siftContract.tokenHolderCount();
618         for (i = 0; i < allTokenHolders.length; i++) {
619             address addr = siftContract.tokenHolder(i);
620             allTokenHolders[i] = addr;
621             balances[addr] = siftContract.balanceOf(addr);
622         }
623 
624         // Update
625         SnapshotTaken();
626     }
627 
628     function snapshotUpdate(address _addr, uint256 _newBalance, string _details) adminOnly {
629         // Are they already a holder?  If not and no new balance then we're making no change so leave now, or if they are and balance is the same
630         uint256 existingBalance = balances[_addr];
631         if (existingBalance == _newBalance)
632             return;
633         
634         // So we definitely have a change to make.  If they are not a holder add to our list and update balance.  If they are a holder who maintains balance update balance.  Otherwise set balance to 0 and delete.
635         if (existingBalance == 0) {
636             // New holder, just add them
637             allTokenHolders.length++;
638             allTokenHolders[allTokenHolders.length - 1] = _addr;
639             balances[_addr] = _newBalance;
640         }
641         else if (_newBalance > 0) {
642             // Existing holder we're updating
643             balances[_addr] = _newBalance;
644         } else {
645             // Existing holder, we're deleting
646             balances[_addr] = 0;
647 
648             /* Find out where in our array they are */
649             uint256 tokenHolderCount = allTokenHolders.length;
650             uint256 foundIndex = 0;
651             bool found = false;
652             uint256 i;
653             for (i = 0; i < tokenHolderCount; i++)
654                 if (allTokenHolders[i] == _addr) {
655                     foundIndex = i;
656                     found = true;
657                     break;
658                 }
659             
660             /* We now need to shuffle down the array */
661             if (found) {
662                 for (i = foundIndex; i < tokenHolderCount - 1; i++)
663                     allTokenHolders[i] = allTokenHolders[i + 1];
664                 allTokenHolders.length--;
665             }
666         }
667 
668         // Audit it
669         SnapshotUpdated(_addr, existingBalance, _newBalance, _details);
670     }
671 
672     /* Gets the balance of a specified account */
673     function balanceOf(address addr) accountReaderOnly constant returns (uint256) {
674         return balances[addr];
675     }
676 
677     /* Returns the total number of holders of this currency. */
678     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
679         return allTokenHolders.length;
680     }
681 
682     /* Gets the token holder at the specified index. */
683     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
684         return allTokenHolders[_index];
685     }
686  
687 
688 }
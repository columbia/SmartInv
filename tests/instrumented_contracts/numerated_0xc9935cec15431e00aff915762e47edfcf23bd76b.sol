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
32 
33 contract LockinManager {
34     using SafeMath for uint256;
35 
36     /*Defines the structure for a lock*/
37     struct Lock {
38         uint256 amount;
39         uint256 unlockDate;
40         uint256 lockedFor;
41     }
42     
43     /*Object of Lock*/    
44     Lock lock;
45 
46     /*Value of default lock days*/
47     uint256 defaultAllowedLock = 7;
48 
49     /* mapping of list of locked address with array of locks for a particular address */
50     mapping (address => Lock[]) public lockedAddresses;
51 
52     /* mapping of valid contracts with their lockin timestamp */
53     mapping (address => uint256) public allowedContracts;
54 
55     /* list of locked days mapped with their locked timestamp*/
56     mapping (uint => uint256) public allowedLocks;
57 
58     /* Defines our interface to the token contract */
59     Token token;
60 
61     /* Defines the admin contract we interface with for credentails. */
62     AuthenticationManager authenticationManager;
63 
64      /* Fired whenever lock day is added by the admin. */
65     event LockedDayAdded(address _admin, uint256 _daysLocked, uint256 timestamp);
66 
67      /* Fired whenever lock day is removed by the admin. */
68     event LockedDayRemoved(address _admin, uint256 _daysLocked, uint256 timestamp);
69 
70      /* Fired whenever valid contract is added by the admin. */
71     event ValidContractAdded(address _admin, address _validAddress, uint256 timestamp);
72 
73      /* Fired whenever valid contract is removed by the admin. */
74     event ValidContractRemoved(address _admin, address _validAddress, uint256 timestamp);
75 
76     /* Create a new instance of this fund with links to other contracts that are required. */
77     function LockinManager(address _token, address _authenticationManager) {
78       
79         /* Setup access to our other contracts and validate their versions */
80         token  = Token(_token);
81         authenticationManager = AuthenticationManager(_authenticationManager);
82     }
83    
84     /* This modifier allows a method to only be called by current admins */
85     modifier adminOnly {
86         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
87         _;
88     }
89 
90     /* This modifier allows a method to only be called by token contract */
91     modifier validContractOnly {
92         require(allowedContracts[msg.sender] != 0);
93 
94         _;
95     }
96 
97     /* Gets the length of locked values for an account */
98     function getLocks(address _owner) validContractOnly constant returns (uint256) {
99         return lockedAddresses[_owner].length;
100     }
101 
102     function getLock(address _owner, uint256 count) validContractOnly returns(uint256 amount, uint256 unlockDate, uint256 lockedFor) {
103         amount     = lockedAddresses[_owner][count].amount;
104         unlockDate = lockedAddresses[_owner][count].unlockDate;
105         lockedFor  = lockedAddresses[_owner][count].lockedFor;
106     }
107     
108     /* Gets amount for which an address is locked with locked index */
109     function getLocksAmount(address _owner, uint256 count) validContractOnly returns(uint256 amount) {        
110         amount = lockedAddresses[_owner][count].amount;
111     }
112 
113     /* Gets unlocked timestamp for which an address is locked with locked index */
114     function getLocksUnlockDate(address _owner, uint256 count) validContractOnly returns(uint256 unlockDate) {
115         unlockDate = lockedAddresses[_owner][count].unlockDate;
116     }
117 
118     /* Gets days for which an address is locked with locked index */
119     function getLocksLockedFor(address _owner, uint256 count) validContractOnly returns(uint256 lockedFor) {
120         lockedFor = lockedAddresses[_owner][count].lockedFor;
121     }
122 
123     /* Locks tokens for an address for the default number of days */
124     function defaultLockin(address _address, uint256 _value) validContractOnly
125     {
126         lockIt(_address, _value, defaultAllowedLock);
127     }
128 
129     /* Locks tokens for sender for n days*/
130     function lockForDays(uint256 _value, uint256 _days) 
131     {
132         require( ! ifInAllowedLocks(_days));        
133 
134         require(token.availableBalance(msg.sender) >= _value);
135         
136         lockIt(msg.sender, _value, _days);     
137     }
138 
139     function lockIt(address _address, uint256 _value, uint256 _days) internal {
140         // expiry will be calculated as 24 * 60 * 60
141         uint256 _expiry = now + _days.mul(86400);
142         lockedAddresses[_address].push(Lock(_value, _expiry, _days));        
143     }
144 
145     /* Check if input day is present in locked days */
146     function ifInAllowedLocks(uint256 _days) constant returns(bool) {
147         return allowedLocks[_days] == 0;
148     }
149 
150     /* Adds a day to our list of allowedLocks */
151     function addAllowedLock(uint _day) adminOnly {
152 
153         // Fail if day is already present in locked days
154         if (allowedLocks[_day] != 0)
155             throw;
156         
157         // Add day in locked days 
158         allowedLocks[_day] = now;
159         LockedDayAdded(msg.sender, _day, now);
160     }
161 
162     /* Remove allowed Lock */
163     function removeAllowedLock(uint _day) adminOnly {
164 
165         // Fail if day doesnot exist in allowedLocks
166         if ( allowedLocks[_day] ==  0)
167             throw;
168 
169         /* Remove locked day  */
170         allowedLocks[_day] = 0;
171         LockedDayRemoved(msg.sender, _day, now);
172     }
173 
174     /* Adds a address to our list of allowedContracts */
175     function addValidContract(address _address) adminOnly {
176 
177         // Fail if address is already present in valid contracts
178         if (allowedContracts[_address] != 0)
179             throw;
180         
181         // add an address in allowedContracts
182         allowedContracts[_address] = now;
183 
184         ValidContractAdded(msg.sender, _address, now);
185     }
186 
187     /* Removes allowed contract from the list of allowedContracts */
188     function removeValidContract(address _address) adminOnly {
189 
190         // Fail if address doesnot exist in allowedContracts
191         if ( allowedContracts[_address] ==  0)
192             throw;
193 
194         /* Remove allowed contract from allowedContracts  */
195         allowedContracts[_address] = 0;
196 
197         ValidContractRemoved(msg.sender, _address, now);
198     }
199 
200     /* Set default allowed lock */
201     function setDefaultAllowedLock(uint _days) adminOnly {
202         defaultAllowedLock = _days;
203     }
204 }
205 
206 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
207 contract AuthenticationManager {
208    
209     /* Map addresses to admins */
210     mapping (address => bool) adminAddresses;
211 
212     /* Map addresses to account readers */
213     mapping (address => bool) accountReaderAddresses;
214 
215     /* Map addresses to account minters */
216     mapping (address => bool) accountMinterAddresses;
217 
218     /* Details of all admins that have ever existed */
219     address[] adminAudit;
220 
221     /* Details of all account readers that have ever existed */
222     address[] accountReaderAudit;
223 
224     /* Details of all account minters that have ever existed */
225     address[] accountMinterAudit;
226 
227     /* Fired whenever an admin is added to the contract. */
228     event AdminAdded(address addedBy, address admin);
229 
230     /* Fired whenever an admin is removed from the contract. */
231     event AdminRemoved(address removedBy, address admin);
232 
233     /* Fired whenever an account-reader contract is added. */
234     event AccountReaderAdded(address addedBy, address account);
235 
236     /* Fired whenever an account-reader contract is removed. */
237     event AccountReaderRemoved(address removedBy, address account);
238 
239     /* Fired whenever an account-minter contract is added. */
240     event AccountMinterAdded(address addedBy, address account);
241 
242     /* Fired whenever an account-minter contract is removed. */
243     event AccountMinterRemoved(address removedBy, address account);
244 
245     /* When this contract is first setup we use the creator as the first admin */    
246     function AuthenticationManager() {
247         /* Set the first admin to be the person creating the contract */
248         adminAddresses[msg.sender] = true;
249         AdminAdded(0, msg.sender);
250         adminAudit.length++;
251         adminAudit[adminAudit.length - 1] = msg.sender;
252     }
253 
254     /* Gets whether or not the specified address is currently an admin */
255     function isCurrentAdmin(address _address) constant returns (bool) {
256         return adminAddresses[_address];
257     }
258 
259     /* Gets whether or not the specified address has ever been an admin */
260     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
261         for (uint256 i = 0; i < adminAudit.length; i++)
262             if (adminAudit[i] == _address)
263                 return true;
264         return false;
265     }
266 
267     /* Gets whether or not the specified address is currently an account reader */
268     function isCurrentAccountReader(address _address) constant returns (bool) {
269         return accountReaderAddresses[_address];
270     }
271 
272     /* Gets whether or not the specified address has ever been an admin */
273     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
274         for (uint256 i = 0; i < accountReaderAudit.length; i++)
275             if (accountReaderAudit[i] == _address)
276                 return true;
277         return false;
278     }
279 
280     /* Gets whether or not the specified address is currently an account minter */
281     function isCurrentAccountMinter(address _address) constant returns (bool) {
282         return accountMinterAddresses[_address];
283     }
284 
285     /* Gets whether or not the specified address has ever been an admin */
286     function isCurrentOrPastAccountMinter(address _address) constant returns (bool) {
287         for (uint256 i = 0; i < accountMinterAudit.length; i++)
288             if (accountMinterAudit[i] == _address)
289                 return true;
290         return false;
291     }
292 
293     /* Adds a user to our list of admins */
294     function addAdmin(address _address) {
295         /* Ensure we're an admin */
296         if (!isCurrentAdmin(msg.sender))
297             throw;
298 
299         // Fail if this account is already admin
300         if (adminAddresses[_address])
301             throw;
302         
303         // Add the user
304         adminAddresses[_address] = true;
305         AdminAdded(msg.sender, _address);
306         adminAudit.length++;
307         adminAudit[adminAudit.length - 1] = _address;
308 
309     }
310 
311     /* Removes a user from our list of admins but keeps them in the history audit */
312     function removeAdmin(address _address) {
313         /* Ensure we're an admin */
314         if (!isCurrentAdmin(msg.sender))
315             throw;
316 
317         /* Don't allow removal of self */
318         if (_address == msg.sender)
319             throw;
320 
321         // Fail if this account is already non-admin
322         if (!adminAddresses[_address])
323             throw;
324 
325         /* Remove this admin user */
326         adminAddresses[_address] = false;
327         AdminRemoved(msg.sender, _address);
328     }
329 
330     /* Adds a user/contract to our list of account readers */
331     function addAccountReader(address _address) {
332         /* Ensure we're an admin */
333         if (!isCurrentAdmin(msg.sender))
334             throw;
335 
336         // Fail if this account is already in the list
337         if (accountReaderAddresses[_address])
338             throw;
339         
340         // Add the account reader
341         accountReaderAddresses[_address] = true;
342         AccountReaderAdded(msg.sender, _address);
343         accountReaderAudit.length++;
344         accountReaderAudit[accountReaderAudit.length - 1] = _address;
345     }
346 
347     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
348     function removeAccountReader(address _address) {
349         /* Ensure we're an admin */
350         if (!isCurrentAdmin(msg.sender))
351             throw;
352 
353         // Fail if this account is already not in the list
354         if (!accountReaderAddresses[_address])
355             throw;
356 
357         /* Remove this account reader */
358         accountReaderAddresses[_address] = false;
359         AccountReaderRemoved(msg.sender, _address);
360     }
361 
362     /* Add a contract to our list of account minters */
363     function addAccountMinter(address _address) {
364         /* Ensure we're an admin */
365         if (!isCurrentAdmin(msg.sender))
366             throw;
367 
368         // Fail if this account is already in the list
369         if (accountMinterAddresses[_address])
370             throw;
371         
372         // Add the minter
373         accountMinterAddresses[_address] = true;
374         AccountMinterAdded(msg.sender, _address);
375         accountMinterAudit.length++;
376         accountMinterAudit[accountMinterAudit.length - 1] = _address;
377     }
378 
379     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
380     function removeAccountMinter(address _address) {
381         /* Ensure we're an admin */
382         if (!isCurrentAdmin(msg.sender))
383             throw;
384 
385         // Fail if this account is already not in the list
386         if (!accountMinterAddresses[_address])
387             throw;
388 
389         /* Remove this minter account */
390         accountMinterAddresses[_address] = false;
391         AccountMinterRemoved(msg.sender, _address);
392     }
393 }
394 
395 /* The Token itself is a simple extension of the ERC20 that allows for granting other Token contracts special rights to act on behalf of all transfers. */
396 contract Token {
397     using SafeMath for uint256;
398 
399     /* Map all our our balances for issued tokens */
400     mapping (address => uint256) public balances;
401 
402     /* Map between users and their approval addresses and amounts */
403     mapping(address => mapping (address => uint256)) allowed;
404 
405     /* List of all token holders */
406     address[] allTokenHolders;
407 
408     /* The name of the contract */
409     string public name;
410 
411     /* The symbol for the contract */
412     string public symbol;
413 
414     /* How many DPs are in use in this contract */
415     uint8 public decimals;
416 
417     /* Defines the current supply of the token in its own units */
418     uint256 totalSupplyAmount = 0;
419     
420     /* Defines the address of the Refund Manager contract which is the only contract to destroy tokens. */
421     address public refundManagerContractAddress;
422 
423     /* Defines the admin contract we interface with for credentails. */
424     AuthenticationManager authenticationManager;
425 
426     /* Instance of lockin contract */
427     LockinManager lockinManager;
428 
429     /** @dev Returns the balance that a given address has available for transfer.
430       * @param _owner The address of the token owner.
431       */
432     function availableBalance(address _owner) constant returns(uint256) {
433         
434         uint256 length =  lockinManager.getLocks(_owner);
435     
436         uint256 lockedValue = 0;
437         
438         for(uint256 i = 0; i < length; i++) {
439 
440             if(lockinManager.getLocksUnlockDate(_owner, i) > now) {
441                 uint256 _value = lockinManager.getLocksAmount(_owner, i);    
442                 lockedValue = lockedValue.add(_value);                
443             }
444         }
445         
446         return balances[_owner].sub(lockedValue);
447     }
448 
449     /* Fired when the fund is eventually closed. */
450     event FundClosed();
451     
452     /* Our transfer event to fire whenever we shift SMRT around */
453     event Transfer(address indexed from, address indexed to, uint256 value);
454     
455     /* Our approval event when one user approves another to control */
456     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
457 
458     /* Create a new instance of this fund with links to other contracts that are required. */
459     function Token(address _authenticationManagerAddress) {
460         // Setup defaults
461         name = "PIE (Authorito Capital)";
462         symbol = "PIE";
463         decimals = 18;
464 
465         /* Setup access to our other contracts */
466         authenticationManager = AuthenticationManager(_authenticationManagerAddress);        
467     }
468 
469     modifier onlyPayloadSize(uint numwords) {
470         assert(msg.data.length == numwords * 32 + 4);
471         _;
472     }
473 
474     /* This modifier allows a method to only be called by account readers */
475     modifier accountReaderOnly {
476         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
477         _;
478     }
479 
480     /* This modifier allows a method to only be called by current admins */
481     modifier adminOnly {
482         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
483         _;
484     }   
485     
486     function setLockinManagerAddress(address _lockinManager) adminOnly {
487         lockinManager = LockinManager(_lockinManager);
488     }
489 
490     function setRefundManagerContract(address _refundManagerContractAddress) adminOnly {
491         refundManagerContractAddress = _refundManagerContractAddress;
492     }
493 
494     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
495     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3) returns (bool) {
496         
497         if (availableBalance(_from) >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
498             bool isNew = balances[_to] == 0;
499             balances[_from] = balances[_from].sub(_amount);
500             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
501             balances[_to] = balances[_to].add(_amount);
502             if (isNew)
503                 tokenOwnerAdd(_to);
504             if (balances[_from] == 0)
505                 tokenOwnerRemove(_from);
506             Transfer(_from, _to, _amount);
507             return true;
508         }
509         return false;
510     }
511 
512     /* Returns the total number of holders of this currency. */
513     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
514         return allTokenHolders.length;
515     }
516 
517     /* Gets the token holder at the specified index. */
518     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
519         return allTokenHolders[_index];
520     }
521  
522     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
523     function approve(address _spender, uint256 _amount) onlyPayloadSize(2) returns (bool success) {
524         allowed[msg.sender][_spender] = _amount;
525         Approval(msg.sender, _spender, _amount);
526         return true;
527     }
528 
529     /* Gets the current allowance that has been approved for the specified spender of the owner address */
530     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
531         return allowed[_owner][_spender];
532     }
533 
534     /* Gets the total supply available of this token */
535     function totalSupply() constant returns (uint256) {
536         return totalSupplyAmount;
537     }
538 
539     /* Gets the balance of a specified account */
540     function balanceOf(address _owner) constant returns (uint256 balance) {
541         return balances[_owner];
542     }
543 
544     /* Transfer the balance from owner's account to another account */
545     function transfer(address _to, uint256 _amount) onlyPayloadSize(2) returns (bool) {
546                 
547         /* Check if sender has balance and for overflows */
548         if (availableBalance(msg.sender) < _amount || balances[_to].add(_amount) < balances[_to])
549             return false;
550 
551         /* Do a check to see if they are new, if so we'll want to add it to our array */
552         bool isRecipientNew = balances[_to] == 0;
553 
554         /* Add and subtract new balances */
555         balances[msg.sender] = balances[msg.sender].sub(_amount);
556         balances[_to] = balances[_to].add(_amount);
557         
558         /* Consolidate arrays if they are new or if sender now has empty balance */
559         if (isRecipientNew)
560             tokenOwnerAdd(_to);
561         if (balances[msg.sender] <= 0)
562             tokenOwnerRemove(msg.sender);
563 
564         /* Fire notification event */
565         Transfer(msg.sender, _to, _amount);
566         return true; 
567     }
568 
569     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
570     function tokenOwnerAdd(address _addr) internal {
571         /* First check if they already exist */
572         uint256 tokenHolderCount = allTokenHolders.length;
573         for (uint256 i = 0; i < tokenHolderCount; i++)
574             if (allTokenHolders[i] == _addr)
575                 /* Already found so we can abort now */
576                 return;
577         
578         /* They don't seem to exist, so let's add them */
579         allTokenHolders.length++;
580         allTokenHolders[allTokenHolders.length - 1] = _addr;
581     }
582 
583     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
584     function tokenOwnerRemove(address _addr) internal {
585         /* Find out where in our array they are */
586         uint256 tokenHolderCount = allTokenHolders.length;
587         uint256 foundIndex = 0;
588         bool found = false;
589         uint256 i;
590         for (i = 0; i < tokenHolderCount; i++)
591             if (allTokenHolders[i] == _addr) {
592                 foundIndex = i;
593                 found = true;
594                 break;
595             }
596         
597         /* If we didn't find them just return */
598         if (!found)
599             return;
600         
601         /* We now need to shuffle down the array */
602         for (i = foundIndex; i < tokenHolderCount - 1; i++)
603             allTokenHolders[i] = allTokenHolders[i + 1];
604         allTokenHolders.length--;
605     }
606 
607     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
608     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
609 
610         /* if it is comming from account minter */
611         if ( ! authenticationManager.isCurrentAccountMinter(msg.sender))
612             throw;
613 
614         /* Mint the tokens for the new address*/
615         bool isNew = balances[_address] == 0;
616         totalSupplyAmount = totalSupplyAmount.add(_amount);
617         balances[_address] = balances[_address].add(_amount);
618 
619         lockinManager.defaultLockin(_address, _amount);        
620 
621         if (isNew)
622             tokenOwnerAdd(_address);
623         Transfer(0, _address, _amount);
624     }
625 
626     /** This will destroy the tokens of the investor and called by sale contract only at the time of refund. */
627     function destroyTokens(address _investor, uint256 tokenCount) returns (bool) {
628         
629         /* Can only be called by refund manager, also refund manager address must not be empty */
630         if ( refundManagerContractAddress  == 0x0 || msg.sender != refundManagerContractAddress)
631             throw;
632 
633         uint256 balance = availableBalance(_investor);
634 
635         if (balance < tokenCount) {
636             return false;
637         }
638 
639         balances[_investor] -= tokenCount;
640         totalSupplyAmount -= tokenCount;
641 
642         if(balances[_investor] <= 0)
643             tokenOwnerRemove(_investor);
644 
645         return true;
646     }
647 }
1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
35 contract AuthenticationManager {
36    
37     /* Map addresses to admins */
38     mapping (address => bool) adminAddresses;
39 
40     /* Map addresses to account readers */
41     mapping (address => bool) accountReaderAddresses;
42 
43     /* Map addresses to account minters */
44     mapping (address => bool) accountMinterAddresses;
45 
46     /* Details of all admins that have ever existed */
47     address[] adminAudit;
48 
49     /* Details of all account readers that have ever existed */
50     address[] accountReaderAudit;
51 
52     /* Details of all account minters that have ever existed */
53     address[] accountMinterAudit;
54 
55     /* Fired whenever an admin is added to the contract. */
56     event AdminAdded(address addedBy, address admin);
57 
58     /* Fired whenever an admin is removed from the contract. */
59     event AdminRemoved(address removedBy, address admin);
60 
61     /* Fired whenever an account-reader contract is added. */
62     event AccountReaderAdded(address addedBy, address account);
63 
64     /* Fired whenever an account-reader contract is removed. */
65     event AccountReaderRemoved(address removedBy, address account);
66 
67     /* Fired whenever an account-minter contract is added. */
68     event AccountMinterAdded(address addedBy, address account);
69 
70     /* Fired whenever an account-minter contract is removed. */
71     event AccountMinterRemoved(address removedBy, address account);
72 
73     /* When this contract is first setup we use the creator as the first admin */    
74     function AuthenticationManager() {
75         /* Set the first admin to be the person creating the contract */
76         adminAddresses[msg.sender] = true;
77         AdminAdded(0, msg.sender);
78         adminAudit.length++;
79         adminAudit[adminAudit.length - 1] = msg.sender;
80     }
81 
82     /* Gets whether or not the specified address is currently an admin */
83     function isCurrentAdmin(address _address) constant returns (bool) {
84         return adminAddresses[_address];
85     }
86 
87     /* Gets whether or not the specified address has ever been an admin */
88     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
89         for (uint256 i = 0; i < adminAudit.length; i++)
90             if (adminAudit[i] == _address)
91                 return true;
92         return false;
93     }
94 
95     /* Gets whether or not the specified address is currently an account reader */
96     function isCurrentAccountReader(address _address) constant returns (bool) {
97         return accountReaderAddresses[_address];
98     }
99 
100     /* Gets whether or not the specified address has ever been an admin */
101     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
102         for (uint256 i = 0; i < accountReaderAudit.length; i++)
103             if (accountReaderAudit[i] == _address)
104                 return true;
105         return false;
106     }
107 
108     /* Gets whether or not the specified address is currently an account minter */
109     function isCurrentAccountMinter(address _address) constant returns (bool) {
110         return accountMinterAddresses[_address];
111     }
112 
113     /* Gets whether or not the specified address has ever been an admin */
114     function isCurrentOrPastAccountMinter(address _address) constant returns (bool) {
115         for (uint256 i = 0; i < accountMinterAudit.length; i++)
116             if (accountMinterAudit[i] == _address)
117                 return true;
118         return false;
119     }
120 
121     /* Adds a user to our list of admins */
122     function addAdmin(address _address) {
123         /* Ensure we're an admin */
124         if (!isCurrentAdmin(msg.sender))
125             throw;
126 
127         // Fail if this account is already admin
128         if (adminAddresses[_address])
129             throw;
130         
131         // Add the user
132         adminAddresses[_address] = true;
133         AdminAdded(msg.sender, _address);
134         adminAudit.length++;
135         adminAudit[adminAudit.length - 1] = _address;
136 
137     }
138 
139     /* Removes a user from our list of admins but keeps them in the history audit */
140     function removeAdmin(address _address) {
141         /* Ensure we're an admin */
142         if (!isCurrentAdmin(msg.sender))
143             throw;
144 
145         /* Don't allow removal of self */
146         if (_address == msg.sender)
147             throw;
148 
149         // Fail if this account is already non-admin
150         if (!adminAddresses[_address])
151             throw;
152 
153         /* Remove this admin user */
154         adminAddresses[_address] = false;
155         AdminRemoved(msg.sender, _address);
156     }
157 
158     /* Adds a user/contract to our list of account readers */
159     function addAccountReader(address _address) {
160         /* Ensure we're an admin */
161         if (!isCurrentAdmin(msg.sender))
162             throw;
163 
164         // Fail if this account is already in the list
165         if (accountReaderAddresses[_address])
166             throw;
167         
168         // Add the account reader
169         accountReaderAddresses[_address] = true;
170         AccountReaderAdded(msg.sender, _address);
171         accountReaderAudit.length++;
172         accountReaderAudit[accountReaderAudit.length - 1] = _address;
173     }
174 
175     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
176     function removeAccountReader(address _address) {
177         /* Ensure we're an admin */
178         if (!isCurrentAdmin(msg.sender))
179             throw;
180 
181         // Fail if this account is already not in the list
182         if (!accountReaderAddresses[_address])
183             throw;
184 
185         /* Remove this account reader */
186         accountReaderAddresses[_address] = false;
187         AccountReaderRemoved(msg.sender, _address);
188     }
189 
190     /* Add a contract to our list of account minters */
191     function addAccountMinter(address _address) {
192         /* Ensure we're an admin */
193         if (!isCurrentAdmin(msg.sender))
194             throw;
195 
196         // Fail if this account is already in the list
197         if (accountMinterAddresses[_address])
198             throw;
199         
200         // Add the minter
201         accountMinterAddresses[_address] = true;
202         AccountMinterAdded(msg.sender, _address);
203         accountMinterAudit.length++;
204         accountMinterAudit[accountMinterAudit.length - 1] = _address;
205     }
206 
207     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
208     function removeAccountMinter(address _address) {
209         /* Ensure we're an admin */
210         if (!isCurrentAdmin(msg.sender))
211             throw;
212 
213         // Fail if this account is already not in the list
214         if (!accountMinterAddresses[_address])
215             throw;
216 
217         /* Remove this minter account */
218         accountMinterAddresses[_address] = false;
219         AccountMinterRemoved(msg.sender, _address);
220     }
221 }
222 
223 /* The Token itself is a simple extension of the ERC20 that allows for granting other Token contracts special rights to act on behalf of all transfers. */
224 contract Token {
225     using SafeMath for uint256;
226 
227     /* Map all our our balances for issued tokens */
228     mapping (address => uint256) public balances;
229 
230     /* Map between users and their approval addresses and amounts */
231     mapping(address => mapping (address => uint256)) allowed;
232 
233     /* List of all token holders */
234     address[] allTokenHolders;
235 
236     /* The name of the contract */
237     string public name;
238 
239     /* The symbol for the contract */
240     string public symbol;
241 
242     /* How many DPs are in use in this contract */
243     uint8 public decimals;
244 
245     /* Defines the current supply of the token in its own units */
246     uint256 totalSupplyAmount = 0;
247     
248     /* Defines the address of the Refund Manager contract which is the only contract to destroy tokens. */
249     address public refundManagerContractAddress;
250 
251     /* Defines the admin contract we interface with for credentails. */
252     AuthenticationManager authenticationManager;
253 
254     /* Instance of lockin contract */
255     LockinManager lockinManager;
256 
257     /** @dev Returns the balance that a given address has available for transfer.
258       * @param _owner The address of the token owner.
259       */
260     function availableBalance(address _owner) constant returns(uint256) {
261         
262         uint256 length =  lockinManager.getLocks(_owner);
263     
264         uint256 lockedValue = 0;
265         
266         for(uint256 i = 0; i < length; i++) {
267 
268             if(lockinManager.getLocksUnlockDate(_owner, i) > now) {
269                 uint256 _value = lockinManager.getLocksAmount(_owner, i);    
270                 lockedValue = lockedValue.add(_value);                
271             }
272         }
273         
274         return balances[_owner].sub(lockedValue);
275     }
276 
277     /* Fired when the fund is eventually closed. */
278     event FundClosed();
279     
280     /* Our transfer event to fire whenever we shift SMRT around */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282     
283     /* Our approval event when one user approves another to control */
284     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
285 
286     /* Create a new instance of this fund with links to other contracts that are required. */
287     function Token(address _authenticationManagerAddress) {
288         // Setup defaults
289         name = "PIE (Authorito Capital)";
290         symbol = "PIE";
291         decimals = 18;
292 
293         /* Setup access to our other contracts */
294         authenticationManager = AuthenticationManager(_authenticationManagerAddress);        
295     }
296 
297     modifier onlyPayloadSize(uint numwords) {
298         assert(msg.data.length == numwords * 32 + 4);
299         _;
300     }
301 
302     /* This modifier allows a method to only be called by account readers */
303     modifier accountReaderOnly {
304         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
305         _;
306     }
307 
308     /* This modifier allows a method to only be called by current admins */
309     modifier adminOnly {
310         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
311         _;
312     }   
313     
314     function setLockinManagerAddress(address _lockinManager) adminOnly {
315         lockinManager = LockinManager(_lockinManager);
316     }
317 
318     function setRefundManagerContract(address _refundManagerContractAddress) adminOnly {
319         refundManagerContractAddress = _refundManagerContractAddress;
320     }
321 
322     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
323     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3) returns (bool) {
324         
325         if (availableBalance(_from) >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
326             bool isNew = balances[_to] == 0;
327             balances[_from] = balances[_from].sub(_amount);
328             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
329             balances[_to] = balances[_to].add(_amount);
330             if (isNew)
331                 tokenOwnerAdd(_to);
332             if (balances[_from] == 0)
333                 tokenOwnerRemove(_from);
334             Transfer(_from, _to, _amount);
335             return true;
336         }
337         return false;
338     }
339 
340     /* Returns the total number of holders of this currency. */
341     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
342         return allTokenHolders.length;
343     }
344 
345     /* Gets the token holder at the specified index. */
346     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
347         return allTokenHolders[_index];
348     }
349  
350     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
351     function approve(address _spender, uint256 _amount) onlyPayloadSize(2) returns (bool success) {
352         allowed[msg.sender][_spender] = _amount;
353         Approval(msg.sender, _spender, _amount);
354         return true;
355     }
356 
357     /* Gets the current allowance that has been approved for the specified spender of the owner address */
358     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
359         return allowed[_owner][_spender];
360     }
361 
362     /* Gets the total supply available of this token */
363     function totalSupply() constant returns (uint256) {
364         return totalSupplyAmount;
365     }
366 
367     /* Gets the balance of a specified account */
368     function balanceOf(address _owner) constant returns (uint256 balance) {
369         return balances[_owner];
370     }
371 
372     /* Transfer the balance from owner's account to another account */
373     function transfer(address _to, uint256 _amount) onlyPayloadSize(2) returns (bool) {
374                 
375         /* Check if sender has balance and for overflows */
376         if (availableBalance(msg.sender) < _amount || balances[_to].add(_amount) < balances[_to])
377             return false;
378 
379         /* Do a check to see if they are new, if so we'll want to add it to our array */
380         bool isRecipientNew = balances[_to] == 0;
381 
382         /* Add and subtract new balances */
383         balances[msg.sender] = balances[msg.sender].sub(_amount);
384         balances[_to] = balances[_to].add(_amount);
385         
386         /* Consolidate arrays if they are new or if sender now has empty balance */
387         if (isRecipientNew)
388             tokenOwnerAdd(_to);
389         if (balances[msg.sender] <= 0)
390             tokenOwnerRemove(msg.sender);
391 
392         /* Fire notification event */
393         Transfer(msg.sender, _to, _amount);
394         return true; 
395     }
396 
397     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
398     function tokenOwnerAdd(address _addr) internal {
399         /* First check if they already exist */
400         uint256 tokenHolderCount = allTokenHolders.length;
401         for (uint256 i = 0; i < tokenHolderCount; i++)
402             if (allTokenHolders[i] == _addr)
403                 /* Already found so we can abort now */
404                 return;
405         
406         /* They don't seem to exist, so let's add them */
407         allTokenHolders.length++;
408         allTokenHolders[allTokenHolders.length - 1] = _addr;
409     }
410 
411     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
412     function tokenOwnerRemove(address _addr) internal {
413         /* Find out where in our array they are */
414         uint256 tokenHolderCount = allTokenHolders.length;
415         uint256 foundIndex = 0;
416         bool found = false;
417         uint256 i;
418         for (i = 0; i < tokenHolderCount; i++)
419             if (allTokenHolders[i] == _addr) {
420                 foundIndex = i;
421                 found = true;
422                 break;
423             }
424         
425         /* If we didn't find them just return */
426         if (!found)
427             return;
428         
429         /* We now need to shuffle down the array */
430         for (i = foundIndex; i < tokenHolderCount - 1; i++)
431             allTokenHolders[i] = allTokenHolders[i + 1];
432         allTokenHolders.length--;
433     }
434 
435     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
436     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
437 
438         /* if it is comming from account minter */
439         if ( ! authenticationManager.isCurrentAccountMinter(msg.sender))
440             throw;
441 
442         /* Mint the tokens for the new address*/
443         bool isNew = balances[_address] == 0;
444         totalSupplyAmount = totalSupplyAmount.add(_amount);
445         balances[_address] = balances[_address].add(_amount);
446 
447         lockinManager.defaultLockin(_address, _amount);        
448 
449         if (isNew)
450             tokenOwnerAdd(_address);
451         Transfer(0, _address, _amount);
452     }
453 
454     /** This will destroy the tokens of the investor and called by sale contract only at the time of refund. */
455     function destroyTokens(address _investor, uint256 tokenCount) returns (bool) {
456         
457         /* Can only be called by refund manager, also refund manager address must not be empty */
458         if ( refundManagerContractAddress  == 0x0 || msg.sender != refundManagerContractAddress)
459             throw;
460 
461         uint256 balance = availableBalance(_investor);
462 
463         if (balance < tokenCount) {
464             return false;
465         }
466 
467         balances[_investor] -= tokenCount;
468         totalSupplyAmount -= tokenCount;
469 
470         if(balances[_investor] <= 0)
471             tokenOwnerRemove(_investor);
472 
473         return true;
474     }
475 }
476 
477 contract LockinManager {
478     using SafeMath for uint256;
479 
480     /*Defines the structure for a lock*/
481     struct Lock {
482         uint256 amount;
483         uint256 unlockDate;
484         uint256 lockedFor;
485     }
486     
487     /*Object of Lock*/    
488     Lock lock;
489 
490     /*Value of default lock days*/
491     uint256 defaultAllowedLock = 7;
492 
493     /* mapping of list of locked address with array of locks for a particular address */
494     mapping (address => Lock[]) public lockedAddresses;
495 
496     /* mapping of valid contracts with their lockin timestamp */
497     mapping (address => uint256) public allowedContracts;
498 
499     /* list of locked days mapped with their locked timestamp*/
500     mapping (uint => uint256) public allowedLocks;
501 
502     /* Defines our interface to the token contract */
503     Token token;
504 
505     /* Defines the admin contract we interface with for credentails. */
506     AuthenticationManager authenticationManager;
507 
508      /* Fired whenever lock day is added by the admin. */
509     event LockedDayAdded(address _admin, uint256 _daysLocked, uint256 timestamp);
510 
511      /* Fired whenever lock day is removed by the admin. */
512     event LockedDayRemoved(address _admin, uint256 _daysLocked, uint256 timestamp);
513 
514      /* Fired whenever valid contract is added by the admin. */
515     event ValidContractAdded(address _admin, address _validAddress, uint256 timestamp);
516 
517      /* Fired whenever valid contract is removed by the admin. */
518     event ValidContractRemoved(address _admin, address _validAddress, uint256 timestamp);
519 
520     /* Create a new instance of this fund with links to other contracts that are required. */
521     function LockinManager(address _token, address _authenticationManager) {
522       
523         /* Setup access to our other contracts and validate their versions */
524         token  = Token(_token);
525         authenticationManager = AuthenticationManager(_authenticationManager);
526     }
527    
528     /* This modifier allows a method to only be called by current admins */
529     modifier adminOnly {
530         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
531         _;
532     }
533 
534     /* This modifier allows a method to only be called by token contract */
535     modifier validContractOnly {
536         require(allowedContracts[msg.sender] != 0);
537 
538         _;
539     }
540 
541     /* Gets the length of locked values for an account */
542     function getLocks(address _owner) validContractOnly constant returns (uint256) {
543         return lockedAddresses[_owner].length;
544     }
545 
546     function getLock(address _owner, uint256 count) validContractOnly returns(uint256 amount, uint256 unlockDate, uint256 lockedFor) {
547         amount     = lockedAddresses[_owner][count].amount;
548         unlockDate = lockedAddresses[_owner][count].unlockDate;
549         lockedFor  = lockedAddresses[_owner][count].lockedFor;
550     }
551     
552     /* Gets amount for which an address is locked with locked index */
553     function getLocksAmount(address _owner, uint256 count) validContractOnly returns(uint256 amount) {        
554         amount = lockedAddresses[_owner][count].amount;
555     }
556 
557     /* Gets unlocked timestamp for which an address is locked with locked index */
558     function getLocksUnlockDate(address _owner, uint256 count) validContractOnly returns(uint256 unlockDate) {
559         unlockDate = lockedAddresses[_owner][count].unlockDate;
560     }
561 
562     /* Gets days for which an address is locked with locked index */
563     function getLocksLockedFor(address _owner, uint256 count) validContractOnly returns(uint256 lockedFor) {
564         lockedFor = lockedAddresses[_owner][count].lockedFor;
565     }
566 
567     /* Locks tokens for an address for the default number of days */
568     function defaultLockin(address _address, uint256 _value) validContractOnly
569     {
570         lockIt(_address, _value, defaultAllowedLock);
571     }
572 
573     /* Locks tokens for sender for n days*/
574     function lockForDays(uint256 _value, uint256 _days) 
575     {
576         require( ! ifInAllowedLocks(_days));        
577 
578         require(token.availableBalance(msg.sender) >= _value);
579         
580         lockIt(msg.sender, _value, _days);     
581     }
582 
583     function lockIt(address _address, uint256 _value, uint256 _days) internal {
584         // expiry will be calculated as 24 * 60 * 60
585         uint256 _expiry = now + _days.mul(86400);
586         lockedAddresses[_address].push(Lock(_value, _expiry, _days));        
587     }
588 
589     /* Check if input day is present in locked days */
590     function ifInAllowedLocks(uint256 _days) constant returns(bool) {
591         return allowedLocks[_days] == 0;
592     }
593 
594     /* Adds a day to our list of allowedLocks */
595     function addAllowedLock(uint _day) adminOnly {
596 
597         // Fail if day is already present in locked days
598         if (allowedLocks[_day] != 0)
599             throw;
600         
601         // Add day in locked days 
602         allowedLocks[_day] = now;
603         LockedDayAdded(msg.sender, _day, now);
604     }
605 
606     /* Remove allowed Lock */
607     function removeAllowedLock(uint _day) adminOnly {
608 
609         // Fail if day doesnot exist in allowedLocks
610         if ( allowedLocks[_day] ==  0)
611             throw;
612 
613         /* Remove locked day  */
614         allowedLocks[_day] = 0;
615         LockedDayRemoved(msg.sender, _day, now);
616     }
617 
618     /* Adds a address to our list of allowedContracts */
619     function addValidContract(address _address) adminOnly {
620 
621         // Fail if address is already present in valid contracts
622         if (allowedContracts[_address] != 0)
623             throw;
624         
625         // add an address in allowedContracts
626         allowedContracts[_address] = now;
627 
628         ValidContractAdded(msg.sender, _address, now);
629     }
630 
631     /* Removes allowed contract from the list of allowedContracts */
632     function removeValidContract(address _address) adminOnly {
633 
634         // Fail if address doesnot exist in allowedContracts
635         if ( allowedContracts[_address] ==  0)
636             throw;
637 
638         /* Remove allowed contract from allowedContracts  */
639         allowedContracts[_address] = 0;
640 
641         ValidContractRemoved(msg.sender, _address, now);
642     }
643 
644     /* Set default allowed lock */
645     function setDefaultAllowedLock(uint _days) adminOnly {
646         defaultAllowedLock = _days;
647     }
648 }
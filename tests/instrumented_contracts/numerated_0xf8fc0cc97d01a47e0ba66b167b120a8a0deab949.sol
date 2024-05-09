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
33 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
34 contract AuthenticationManager {
35     /* Map addresses to admins */
36     mapping (address => bool) adminAddresses;
37 
38     /* Map addresses to account readers */
39     mapping (address => bool) accountReaderAddresses;
40 
41     /* Details of all admins that have ever existed */
42     address[] adminAudit;
43 
44     /* Details of all account readers that have ever existed */
45     address[] accountReaderAudit;
46 
47     /* Fired whenever an admin is added to the contract. */
48     event AdminAdded(address addedBy, address admin);
49 
50     /* Fired whenever an admin is removed from the contract. */
51     event AdminRemoved(address removedBy, address admin);
52 
53     /* Fired whenever an account-reader contract is added. */
54     event AccountReaderAdded(address addedBy, address account);
55 
56     /* Fired whenever an account-reader contract is removed. */
57     event AccountReaderRemoved(address removedBy, address account);
58 
59     /* When this contract is first setup we use the creator as the first admin */    
60     function AuthenticationManager() {
61         /* Set the first admin to be the person creating the contract */
62         adminAddresses[msg.sender] = true;
63         AdminAdded(0, msg.sender);
64         adminAudit.length++;
65         adminAudit[adminAudit.length - 1] = msg.sender;
66     }
67 
68     /* Gets the contract version for validation */
69     function contractVersion() constant returns(uint256) {
70         // Admin contract identifies as 100YYYYMMDDHHMM
71         return 100201707171503;
72     }
73 
74     /* Gets whether or not the specified address is currently an admin */
75     function isCurrentAdmin(address _address) constant returns (bool) {
76         return adminAddresses[_address];
77     }
78 
79     /* Gets whether or not the specified address has ever been an admin */
80     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
81         for (uint256 i = 0; i < adminAudit.length; i++)
82             if (adminAudit[i] == _address)
83                 return true;
84         return false;
85     }
86 
87     /* Gets whether or not the specified address is currently an account reader */
88     function isCurrentAccountReader(address _address) constant returns (bool) {
89         return accountReaderAddresses[_address];
90     }
91 
92     /* Gets whether or not the specified address has ever been an admin */
93     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
94         for (uint256 i = 0; i < accountReaderAudit.length; i++)
95             if (accountReaderAudit[i] == _address)
96                 return true;
97         return false;
98     }
99 
100     /* Adds a user to our list of admins */
101     function addAdmin(address _address) {
102         /* Ensure we're an admin */
103         if (!isCurrentAdmin(msg.sender))
104             throw;
105 
106         // Fail if this account is already admin
107         if (adminAddresses[_address])
108             throw;
109         
110         // Add the user
111         adminAddresses[_address] = true;
112         AdminAdded(msg.sender, _address);
113         adminAudit.length++;
114         adminAudit[adminAudit.length - 1] = _address;
115     }
116 
117     /* Removes a user from our list of admins but keeps them in the history audit */
118     function removeAdmin(address _address) {
119         /* Ensure we're an admin */
120         if (!isCurrentAdmin(msg.sender))
121             throw;
122 
123         /* Don't allow removal of self */
124         if (_address == msg.sender)
125             throw;
126 
127         // Fail if this account is already non-admin
128         if (!adminAddresses[_address])
129             throw;
130 
131         /* Remove this admin user */
132         adminAddresses[_address] = false;
133         AdminRemoved(msg.sender, _address);
134     }
135 
136     /* Adds a user/contract to our list of account readers */
137     function addAccountReader(address _address) {
138         /* Ensure we're an admin */
139         if (!isCurrentAdmin(msg.sender))
140             throw;
141 
142         // Fail if this account is already in the list
143         if (accountReaderAddresses[_address])
144             throw;
145         
146         // Add the user
147         accountReaderAddresses[_address] = true;
148         AccountReaderAdded(msg.sender, _address);
149         accountReaderAudit.length++;
150         accountReaderAudit[adminAudit.length - 1] = _address;
151     }
152 
153     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
154     function removeAccountReader(address _address) {
155         /* Ensure we're an admin */
156         if (!isCurrentAdmin(msg.sender))
157             throw;
158 
159         // Fail if this account is already not in the list
160         if (!accountReaderAddresses[_address])
161             throw;
162 
163         /* Remove this admin user */
164         accountReaderAddresses[_address] = false;
165         AccountReaderRemoved(msg.sender, _address);
166     }
167 }
168 
169 /* The SIFT itself is a simple extension of the ERC20 that allows for granting other SIFT contracts special rights to act on behalf of all transfers. */
170 contract SmartInvestmentFundToken {
171     using SafeMath for uint256;
172 
173     /* Map all our our balances for issued tokens */
174     mapping (address => uint256) balances;
175 
176     /* Map between users and their approval addresses and amounts */
177     mapping(address => mapping (address => uint256)) allowed;
178 
179     /* List of all token holders */
180     address[] allTokenHolders;
181 
182     /* The name of the contract */
183     string public name;
184 
185     /* The symbol for the contract */
186     string public symbol;
187 
188     /* How many DPs are in use in this contract */
189     uint8 public decimals;
190 
191     /* Defines the current supply of the token in its own units */
192     uint256 totalSupplyAmount = 0;
193 
194     /* Defines the address of the ICO contract which is the only contract permitted to mint tokens. */
195     address public icoContractAddress;
196 
197     /* Defines whether or not the fund is closed. */
198     bool public isClosed;
199 
200     /* Defines the contract handling the ICO phase. */
201     IcoPhaseManagement icoPhaseManagement;
202 
203     /* Defines the admin contract we interface with for credentails. */
204     AuthenticationManager authenticationManager;
205 
206     /* Fired when the fund is eventually closed. */
207     event FundClosed();
208     
209     /* Our transfer event to fire whenever we shift SMRT around */
210     event Transfer(address indexed from, address indexed to, uint256 value);
211     
212     /* Our approval event when one user approves another to control */
213     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
214 
215     /* Create a new instance of this fund with links to other contracts that are required. */
216     function SmartInvestmentFundToken(address _icoContractAddress, address _authenticationManagerAddress) {
217         // Setup defaults
218         name = "Smart Investment Fund Token";
219         symbol = "SIFT";
220         decimals = 0;
221 
222         /* Setup access to our other contracts and validate their versions */
223         icoPhaseManagement = IcoPhaseManagement(_icoContractAddress);
224         if (icoPhaseManagement.contractVersion() != 300201707171440)
225             throw;
226         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
227         if (authenticationManager.contractVersion() != 100201707171503)
228             throw;
229         
230         /* Store our special addresses */
231         icoContractAddress = _icoContractAddress;
232     }
233 
234     modifier onlyPayloadSize(uint numwords) {
235         assert(msg.data.length == numwords * 32 + 4);
236         _;
237     } 
238 
239     /* This modifier allows a method to only be called by account readers */
240     modifier accountReaderOnly {
241         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
242         _;
243     }
244 
245     modifier fundSendablePhase {
246         // If it's in ICO phase, forbid it
247         if (icoPhaseManagement.icoPhase())
248             throw;
249 
250         // If it's abandoned, forbid it
251         if (icoPhaseManagement.icoAbandoned())
252             throw;
253 
254         // We're good, funds can now be transferred
255         _;
256     }
257 
258     /* Gets the contract version for validation */
259     function contractVersion() constant returns(uint256) {
260         /* SIFT contract identifies as 500YYYYMMDDHHMM */
261         return 500201707171440;
262     }
263     
264     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
265     function transferFrom(address _from, address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(3) returns (bool) {
266         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
267             bool isNew = balances[_to] == 0;
268             balances[_from] = balances[_from].sub(_amount);
269             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
270             balances[_to] = balances[_to].add(_amount);
271             if (isNew)
272                 tokenOwnerAdd(_to);
273             if (balances[_from] == 0)
274                 tokenOwnerRemove(_from);
275             Transfer(_from, _to, _amount);
276             return true;
277         }
278         return false;
279     }
280 
281     /* Returns the total number of holders of this currency. */
282     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
283         return allTokenHolders.length;
284     }
285 
286     /* Gets the token holder at the specified index. */
287     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
288         return allTokenHolders[_index];
289     }
290  
291     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
292     function approve(address _spender, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool success) {
293         allowed[msg.sender][_spender] = _amount;
294         Approval(msg.sender, _spender, _amount);
295         return true;
296     }
297 
298     /* Gets the current allowance that has been approved for the specified spender of the owner address */
299     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
300         return allowed[_owner][_spender];
301     }
302 
303     /* Gets the total supply available of this token */
304     function totalSupply() constant returns (uint256) {
305         return totalSupplyAmount;
306     }
307 
308     /* Gets the balance of a specified account */
309     function balanceOf(address _owner) constant returns (uint256 balance) {
310         return balances[_owner];
311     }
312 
313     /* Transfer the balance from owner's account to another account */
314     function transfer(address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool) {
315         /* Check if sender has balance and for overflows */
316         if (balances[msg.sender] < _amount || balances[_to].add(_amount) < balances[_to])
317             return false;
318 
319         /* Do a check to see if they are new, if so we'll want to add it to our array */
320         bool isRecipientNew = balances[_to] < 1;
321 
322         /* Add and subtract new balances */
323         balances[msg.sender] = balances[msg.sender].sub(_amount);
324         balances[_to] = balances[_to].add(_amount);
325 
326         /* Consolidate arrays if they are new or if sender now has empty balance */
327         if (isRecipientNew)
328             tokenOwnerAdd(_to);
329         if (balances[msg.sender] < 1)
330             tokenOwnerRemove(msg.sender);
331 
332         /* Fire notification event */
333         Transfer(msg.sender, _to, _amount);
334         return true;
335     }
336 
337     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
338     function tokenOwnerAdd(address _addr) internal {
339         /* First check if they already exist */
340         uint256 tokenHolderCount = allTokenHolders.length;
341         for (uint256 i = 0; i < tokenHolderCount; i++)
342             if (allTokenHolders[i] == _addr)
343                 /* Already found so we can abort now */
344                 return;
345         
346         /* They don't seem to exist, so let's add them */
347         allTokenHolders.length++;
348         allTokenHolders[allTokenHolders.length - 1] = _addr;
349     }
350 
351     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
352     function tokenOwnerRemove(address _addr) internal {
353         /* Find out where in our array they are */
354         uint256 tokenHolderCount = allTokenHolders.length;
355         uint256 foundIndex = 0;
356         bool found = false;
357         uint256 i;
358         for (i = 0; i < tokenHolderCount; i++)
359             if (allTokenHolders[i] == _addr) {
360                 foundIndex = i;
361                 found = true;
362                 break;
363             }
364         
365         /* If we didn't find them just return */
366         if (!found)
367             return;
368         
369         /* We now need to shuffle down the array */
370         for (i = foundIndex; i < tokenHolderCount - 1; i++)
371             allTokenHolders[i] = allTokenHolders[i + 1];
372         allTokenHolders.length--;
373     }
374 
375     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
376     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
377         /* Ensure we are the ICO contract calling */
378         if (msg.sender != icoContractAddress || !icoPhaseManagement.icoPhase())
379             throw;
380 
381         /* Mint the tokens for the new address*/
382         bool isNew = balances[_address] == 0;
383         totalSupplyAmount = totalSupplyAmount.add(_amount);
384         balances[_address] = balances[_address].add(_amount);
385         if (isNew)
386             tokenOwnerAdd(_address);
387         Transfer(0, _address, _amount);
388     }
389 }
390 
391 
392 /* The SIFT itself is a simple extension of the ERC20 that allows for granting other SIFT contracts special rights to act on behalf of all transfers. */
393 
394 contract IcoPhaseManagement {
395     using SafeMath for uint256;
396     
397     /* Defines whether or not we are in the ICO phase */
398     bool public icoPhase = true;
399 
400     /* Defines whether or not the ICO has been abandoned */
401     bool public icoAbandoned = false;
402 
403     /* Defines whether or not the SIFT contract address has yet been set.  */
404     bool siftContractDefined = false;
405     
406     /* Defines the sale price during ICO */
407     uint256 constant icoUnitPrice = 10 finney;
408 
409     /* If an ICO is abandoned and some withdrawals fail then this map allows people to request withdrawal of locked-in ether. */
410     mapping(address => uint256) public abandonedIcoBalances;
411 
412     /* Defines our interface to the SIFT contract. */
413     SmartInvestmentFundToken smartInvestmentFundToken;
414 
415     /* Defines the admin contract we interface with for credentails. */
416     AuthenticationManager authenticationManager;
417 
418     /* Defines the time that the ICO starts. */
419     uint256 constant public icoStartTime = 1501545600; // August 1st 2017 at 00:00:00 UTC
420 
421     /* Defines the time that the ICO ends. */
422     uint256 constant public icoEndTime = 1505433600; // September 15th 2017 at 00:00:00 UTC
423 
424     /* Defines our event fired when the ICO is closed */
425     event IcoClosed();
426 
427     /* Defines our event fired if the ICO is abandoned */
428     event IcoAbandoned(string details);
429     
430     /* Ensures that once the ICO is over this contract cannot be used until the point it is destructed. */
431     modifier onlyDuringIco {
432         bool contractValid = siftContractDefined && !smartInvestmentFundToken.isClosed();
433         if (!contractValid || (!icoPhase && !icoAbandoned)) throw;
434         _;
435     }
436 
437     /* This modifier allows a method to only be called by current admins */
438     modifier adminOnly {
439         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
440         _;
441     }
442 
443     /* Create the ICO phase managerment and define the address of the main SIFT contract. */
444     function IcoPhaseManagement(address _authenticationManagerAddress) {
445         /* A basic sanity check */
446         if (icoStartTime >= icoEndTime)
447             throw;
448 
449         /* Setup access to our other contracts and validate their versions */
450         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
451         if (authenticationManager.contractVersion() != 100201707171503)
452             throw;
453     }
454 
455     /* Set the SIFT contract address as a one-time operation.  This happens after all the contracts are created and no
456        other functionality can be used until this is set. */
457     function setSiftContractAddress(address _siftContractAddress) adminOnly {
458         /* This can only happen once in the lifetime of this contract */
459         if (siftContractDefined)
460             throw;
461 
462         /* Setup access to our other contracts and validate their versions */
463         smartInvestmentFundToken = SmartInvestmentFundToken(_siftContractAddress);
464         if (smartInvestmentFundToken.contractVersion() != 500201707171440)
465             throw;
466         siftContractDefined = true;
467     }
468 
469     /* Gets the contract version for validation */
470     function contractVersion() constant returns(uint256) {
471         /* ICO contract identifies as 300YYYYMMDDHHMM */
472         return 300201707171440;
473     }
474 
475     /* Close the ICO phase and transition to execution phase */
476     function close() adminOnly onlyDuringIco {
477         // Forbid closing contract before the end of ICO
478         if (now <= icoEndTime)
479             throw;
480 
481         // Close the ICO
482         icoPhase = false;
483         IcoClosed();
484 
485         // Withdraw funds to the caller
486         if (!msg.sender.send(this.balance))
487             throw;
488     }
489     
490     /* Handle receiving ether in ICO phase - we work out how much the user has bought, allocate a suitable balance and send their change */
491     function () onlyDuringIco payable {
492         // Forbid funding outside of ICO
493         if (now < icoStartTime || now > icoEndTime)
494             throw;
495 
496         /* Determine how much they've actually purhcased and any ether change */
497         uint256 tokensPurchased = msg.value / icoUnitPrice;
498         uint256 purchaseTotalPrice = tokensPurchased * icoUnitPrice;
499         uint256 change = msg.value.sub(purchaseTotalPrice);
500 
501         /* Increase their new balance if they actually purchased any */
502         if (tokensPurchased > 0)
503             smartInvestmentFundToken.mintTokens(msg.sender, tokensPurchased);
504 
505         /* Send change back to recipient */
506         if (change > 0 && !msg.sender.send(change))
507             throw;
508     }
509 
510     /* Abandons the ICO and returns funds to shareholders.  Any failed funds can be separately withdrawn once the ICO is abandoned. */
511     function abandon(string details) adminOnly onlyDuringIco {
512         // Forbid closing contract before the end of ICO
513         if (now <= icoEndTime)
514             throw;
515 
516         /* If already abandoned throw an error */
517         if (icoAbandoned)
518             throw;
519 
520         /* Work out a refund per share per share */
521         uint256 paymentPerShare = this.balance / smartInvestmentFundToken.totalSupply();
522 
523         /* Enum all accounts and send them refund */
524         uint numberTokenHolders = smartInvestmentFundToken.tokenHolderCount();
525         uint256 totalAbandoned = 0;
526         for (uint256 i = 0; i < numberTokenHolders; i++) {
527             /* Calculate how much goes to this shareholder */
528             address addr = smartInvestmentFundToken.tokenHolder(i);
529             uint256 etherToSend = paymentPerShare * smartInvestmentFundToken.balanceOf(addr);
530             if (etherToSend < 1)
531                 continue;
532 
533             /* Allocate appropriate amount of fund to them */
534             abandonedIcoBalances[addr] = abandonedIcoBalances[addr].add(etherToSend);
535             totalAbandoned = totalAbandoned.add(etherToSend);
536         }
537 
538         /* Audit the abandonment */
539         icoAbandoned = true;
540         IcoAbandoned(details);
541 
542         // There should be no money left, but withdraw just incase for manual resolution
543         uint256 remainder = this.balance.sub(totalAbandoned);
544         if (remainder > 0)
545             if (!msg.sender.send(remainder))
546                 // Add this to the callers balance for emergency refunds
547                 abandonedIcoBalances[msg.sender] = abandonedIcoBalances[msg.sender].add(remainder);
548     }
549 
550     /* Allows people to withdraw funds that failed to send during the abandonment of the ICO for any reason. */
551     function abandonedFundWithdrawal() {
552         // This functionality only exists if an ICO was abandoned
553         if (!icoAbandoned || abandonedIcoBalances[msg.sender] == 0)
554             throw;
555         
556         // Attempt to send them to funds
557         uint256 funds = abandonedIcoBalances[msg.sender];
558         abandonedIcoBalances[msg.sender] = 0;
559         if (!msg.sender.send(funds))
560             throw;
561     }
562 }
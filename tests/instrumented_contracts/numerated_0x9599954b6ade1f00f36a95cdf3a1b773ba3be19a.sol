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
34 /* The SIFT itself is a simple extension of the ERC20 that allows for granting other SIFT contracts special rights to act on behalf of all transfers. */
35 contract SmartInvestmentFundToken {
36     using SafeMath for uint256;
37 
38     /* Map all our our balances for issued tokens */
39     mapping (address => uint256) balances;
40 
41     /* Map between users and their approval addresses and amounts */
42     mapping(address => mapping (address => uint256)) allowed;
43 
44     /* List of all token holders */
45     address[] allTokenHolders;
46 
47     /* The name of the contract */
48     string public name;
49 
50     /* The symbol for the contract */
51     string public symbol;
52 
53     /* How many DPs are in use in this contract */
54     uint8 public decimals;
55 
56     /* Defines the current supply of the token in its own units */
57     uint256 totalSupplyAmount = 0;
58 
59     /* Defines the address of the ICO contract which is the only contract permitted to mint tokens. */
60     address public icoContractAddress;
61 
62     /* Defines whether or not the fund is closed. */
63     bool public isClosed;
64 
65     /* Defines the contract handling the ICO phase. */
66     IcoPhaseManagement icoPhaseManagement;
67 
68     /* Defines the admin contract we interface with for credentails. */
69     AuthenticationManager authenticationManager;
70 
71     /* Fired when the fund is eventually closed. */
72     event FundClosed();
73     
74     /* Our transfer event to fire whenever we shift SMRT around */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     
77     /* Our approval event when one user approves another to control */
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80     /* Create a new instance of this fund with links to other contracts that are required. */
81     function SmartInvestmentFundToken(address _icoContractAddress, address _authenticationManagerAddress) {
82         // Setup defaults
83         name = "Smart Investment Fund Token";
84         symbol = "SIFT";
85         decimals = 0;
86 
87         /* Setup access to our other contracts and validate their versions */
88         icoPhaseManagement = IcoPhaseManagement(_icoContractAddress);
89         if (icoPhaseManagement.contractVersion() != 300201707171440)
90             throw;
91         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
92         if (authenticationManager.contractVersion() != 100201707171503)
93             throw;
94         
95         /* Store our special addresses */
96         icoContractAddress = _icoContractAddress;
97     }
98 
99     modifier onlyPayloadSize(uint numwords) {
100         assert(msg.data.length == numwords * 32 + 4);
101         _;
102     } 
103 
104     /* This modifier allows a method to only be called by account readers */
105     modifier accountReaderOnly {
106         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
107         _;
108     }
109 
110     modifier fundSendablePhase {
111         // If it's in ICO phase, forbid it
112         if (icoPhaseManagement.icoPhase())
113             throw;
114 
115         // If it's abandoned, forbid it
116         if (icoPhaseManagement.icoAbandoned())
117             throw;
118 
119         // We're good, funds can now be transferred
120         _;
121     }
122 
123     /* Gets the contract version for validation */
124     function contractVersion() constant returns(uint256) {
125         /* SIFT contract identifies as 500YYYYMMDDHHMM */
126         return 500201707171440;
127     }
128     
129     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
130     function transferFrom(address _from, address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(3) returns (bool) {
131         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
132             bool isNew = balances[_to] == 0;
133             balances[_from] = balances[_from].sub(_amount);
134             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
135             balances[_to] = balances[_to].add(_amount);
136             if (isNew)
137                 tokenOwnerAdd(_to);
138             if (balances[_from] == 0)
139                 tokenOwnerRemove(_from);
140             Transfer(_from, _to, _amount);
141             return true;
142         }
143         return false;
144     }
145 
146     /* Returns the total number of holders of this currency. */
147     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
148         return allTokenHolders.length;
149     }
150 
151     /* Gets the token holder at the specified index. */
152     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
153         return allTokenHolders[_index];
154     }
155  
156     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
157     function approve(address _spender, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool success) {
158         allowed[msg.sender][_spender] = _amount;
159         Approval(msg.sender, _spender, _amount);
160         return true;
161     }
162 
163     /* Gets the current allowance that has been approved for the specified spender of the owner address */
164     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 
168     /* Gets the total supply available of this token */
169     function totalSupply() constant returns (uint256) {
170         return totalSupplyAmount;
171     }
172 
173     /* Gets the balance of a specified account */
174     function balanceOf(address _owner) constant returns (uint256 balance) {
175         return balances[_owner];
176     }
177 
178     /* Transfer the balance from owner's account to another account */
179     function transfer(address _to, uint256 _amount) fundSendablePhase onlyPayloadSize(2) returns (bool) {
180         /* Check if sender has balance and for overflows */
181         if (balances[msg.sender] < _amount || balances[_to].add(_amount) < balances[_to])
182             return false;
183 
184         /* Do a check to see if they are new, if so we'll want to add it to our array */
185         bool isRecipientNew = balances[_to] < 1;
186 
187         /* Add and subtract new balances */
188         balances[msg.sender] = balances[msg.sender].sub(_amount);
189         balances[_to] = balances[_to].add(_amount);
190 
191         /* Consolidate arrays if they are new or if sender now has empty balance */
192         if (isRecipientNew)
193             tokenOwnerAdd(_to);
194         if (balances[msg.sender] < 1)
195             tokenOwnerRemove(msg.sender);
196 
197         /* Fire notification event */
198         Transfer(msg.sender, _to, _amount);
199         return true;
200     }
201 
202     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
203     function tokenOwnerAdd(address _addr) internal {
204         /* First check if they already exist */
205         uint256 tokenHolderCount = allTokenHolders.length;
206         for (uint256 i = 0; i < tokenHolderCount; i++)
207             if (allTokenHolders[i] == _addr)
208                 /* Already found so we can abort now */
209                 return;
210         
211         /* They don't seem to exist, so let's add them */
212         allTokenHolders.length++;
213         allTokenHolders[allTokenHolders.length - 1] = _addr;
214     }
215 
216     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
217     function tokenOwnerRemove(address _addr) internal {
218         /* Find out where in our array they are */
219         uint256 tokenHolderCount = allTokenHolders.length;
220         uint256 foundIndex = 0;
221         bool found = false;
222         uint256 i;
223         for (i = 0; i < tokenHolderCount; i++)
224             if (allTokenHolders[i] == _addr) {
225                 foundIndex = i;
226                 found = true;
227                 break;
228             }
229         
230         /* If we didn't find them just return */
231         if (!found)
232             return;
233         
234         /* We now need to shuffle down the array */
235         for (i = foundIndex; i < tokenHolderCount - 1; i++)
236             allTokenHolders[i] = allTokenHolders[i + 1];
237         allTokenHolders.length--;
238     }
239 
240     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
241     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
242         /* Ensure we are the ICO contract calling */
243         if (msg.sender != icoContractAddress || !icoPhaseManagement.icoPhase())
244             throw;
245 
246         /* Mint the tokens for the new address*/
247         bool isNew = balances[_address] == 0;
248         totalSupplyAmount = totalSupplyAmount.add(_amount);
249         balances[_address] = balances[_address].add(_amount);
250         if (isNew)
251             tokenOwnerAdd(_address);
252         Transfer(0, _address, _amount);
253     }
254 }
255 
256 contract IcoPhaseManagement {
257     using SafeMath for uint256;
258     
259     /* Defines whether or not we are in the ICO phase */
260     bool public icoPhase = true;
261 
262     /* Defines whether or not the ICO has been abandoned */
263     bool public icoAbandoned = false;
264 
265     /* Defines whether or not the SIFT contract address has yet been set.  */
266     bool siftContractDefined = false;
267     
268     /* Defines the sale price during ICO */
269     uint256 constant icoUnitPrice = 10 finney;
270 
271     /* If an ICO is abandoned and some withdrawals fail then this map allows people to request withdrawal of locked-in ether. */
272     mapping(address => uint256) public abandonedIcoBalances;
273 
274     /* Defines our interface to the SIFT contract. */
275     SmartInvestmentFundToken smartInvestmentFundToken;
276 
277     /* Defines the admin contract we interface with for credentails. */
278     AuthenticationManager authenticationManager;
279 
280     /* Defines the time that the ICO starts. */
281     uint256 constant public icoStartTime = 1501545600; // August 1st 2017 at 00:00:00 UTC
282 
283     /* Defines the time that the ICO ends. */
284     uint256 constant public icoEndTime = 1505433600; // September 15th 2017 at 00:00:00 UTC
285 
286     /* Defines our event fired when the ICO is closed */
287     event IcoClosed();
288 
289     /* Defines our event fired if the ICO is abandoned */
290     event IcoAbandoned(string details);
291     
292     /* Ensures that once the ICO is over this contract cannot be used until the point it is destructed. */
293     modifier onlyDuringIco {
294         bool contractValid = siftContractDefined && !smartInvestmentFundToken.isClosed();
295         if (!contractValid || (!icoPhase && !icoAbandoned)) throw;
296         _;
297     }
298 
299     /* This modifier allows a method to only be called by current admins */
300     modifier adminOnly {
301         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
302         _;
303     }
304 
305     /* Create the ICO phase managerment and define the address of the main SIFT contract. */
306     function IcoPhaseManagement(address _authenticationManagerAddress) {
307         /* A basic sanity check */
308         if (icoStartTime >= icoEndTime)
309             throw;
310 
311         /* Setup access to our other contracts and validate their versions */
312         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
313         if (authenticationManager.contractVersion() != 100201707171503)
314             throw;
315     }
316 
317     /* Set the SIFT contract address as a one-time operation.  This happens after all the contracts are created and no
318        other functionality can be used until this is set. */
319     function setSiftContractAddress(address _siftContractAddress) adminOnly {
320         /* This can only happen once in the lifetime of this contract */
321         if (siftContractDefined)
322             throw;
323 
324         /* Setup access to our other contracts and validate their versions */
325         smartInvestmentFundToken = SmartInvestmentFundToken(_siftContractAddress);
326         if (smartInvestmentFundToken.contractVersion() != 500201707171440)
327             throw;
328         siftContractDefined = true;
329     }
330 
331     /* Gets the contract version for validation */
332     function contractVersion() constant returns(uint256) {
333         /* ICO contract identifies as 300YYYYMMDDHHMM */
334         return 300201707171440;
335     }
336 
337     /* Close the ICO phase and transition to execution phase */
338     function close() adminOnly onlyDuringIco {
339         // Forbid closing contract before the end of ICO
340         if (now <= icoEndTime)
341             throw;
342 
343         // Close the ICO
344         icoPhase = false;
345         IcoClosed();
346 
347         // Withdraw funds to the caller
348         if (!msg.sender.send(this.balance))
349             throw;
350     }
351     
352     /* Handle receiving ether in ICO phase - we work out how much the user has bought, allocate a suitable balance and send their change */
353     function () onlyDuringIco payable {
354         // Forbid funding outside of ICO
355         if (now < icoStartTime || now > icoEndTime)
356             throw;
357 
358         /* Determine how much they've actually purhcased and any ether change */
359         uint256 tokensPurchased = msg.value / icoUnitPrice;
360         uint256 purchaseTotalPrice = tokensPurchased * icoUnitPrice;
361         uint256 change = msg.value.sub(purchaseTotalPrice);
362 
363         /* Increase their new balance if they actually purchased any */
364         if (tokensPurchased > 0)
365             smartInvestmentFundToken.mintTokens(msg.sender, tokensPurchased);
366 
367         /* Send change back to recipient */
368         if (change > 0 && !msg.sender.send(change))
369             throw;
370     }
371 
372     /* Abandons the ICO and returns funds to shareholders.  Any failed funds can be separately withdrawn once the ICO is abandoned. */
373     function abandon(string details) adminOnly onlyDuringIco {
374         // Forbid closing contract before the end of ICO
375         if (now <= icoEndTime)
376             throw;
377 
378         /* If already abandoned throw an error */
379         if (icoAbandoned)
380             throw;
381 
382         /* Work out a refund per share per share */
383         uint256 paymentPerShare = this.balance / smartInvestmentFundToken.totalSupply();
384 
385         /* Enum all accounts and send them refund */
386         uint numberTokenHolders = smartInvestmentFundToken.tokenHolderCount();
387         uint256 totalAbandoned = 0;
388         for (uint256 i = 0; i < numberTokenHolders; i++) {
389             /* Calculate how much goes to this shareholder */
390             address addr = smartInvestmentFundToken.tokenHolder(i);
391             uint256 etherToSend = paymentPerShare * smartInvestmentFundToken.balanceOf(addr);
392             if (etherToSend < 1)
393                 continue;
394 
395             /* Allocate appropriate amount of fund to them */
396             abandonedIcoBalances[addr] = abandonedIcoBalances[addr].add(etherToSend);
397             totalAbandoned = totalAbandoned.add(etherToSend);
398         }
399 
400         /* Audit the abandonment */
401         icoAbandoned = true;
402         IcoAbandoned(details);
403 
404         // There should be no money left, but withdraw just incase for manual resolution
405         uint256 remainder = this.balance.sub(totalAbandoned);
406         if (remainder > 0)
407             if (!msg.sender.send(remainder))
408                 // Add this to the callers balance for emergency refunds
409                 abandonedIcoBalances[msg.sender] = abandonedIcoBalances[msg.sender].add(remainder);
410     }
411 
412     /* Allows people to withdraw funds that failed to send during the abandonment of the ICO for any reason. */
413     function abandonedFundWithdrawal() {
414         // This functionality only exists if an ICO was abandoned
415         if (!icoAbandoned || abandonedIcoBalances[msg.sender] == 0)
416             throw;
417         
418         // Attempt to send them to funds
419         uint256 funds = abandonedIcoBalances[msg.sender];
420         abandonedIcoBalances[msg.sender] = 0;
421         if (!msg.sender.send(funds))
422             throw;
423     }
424 }
425 
426 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
427 contract AuthenticationManager {
428     /* Map addresses to admins */
429     mapping (address => bool) adminAddresses;
430 
431     /* Map addresses to account readers */
432     mapping (address => bool) accountReaderAddresses;
433 
434     /* Details of all admins that have ever existed */
435     address[] adminAudit;
436 
437     /* Details of all account readers that have ever existed */
438     address[] accountReaderAudit;
439 
440     /* Fired whenever an admin is added to the contract. */
441     event AdminAdded(address addedBy, address admin);
442 
443     /* Fired whenever an admin is removed from the contract. */
444     event AdminRemoved(address removedBy, address admin);
445 
446     /* Fired whenever an account-reader contract is added. */
447     event AccountReaderAdded(address addedBy, address account);
448 
449     /* Fired whenever an account-reader contract is removed. */
450     event AccountReaderRemoved(address removedBy, address account);
451 
452     /* When this contract is first setup we use the creator as the first admin */    
453     function AuthenticationManager() {
454         /* Set the first admin to be the person creating the contract */
455         adminAddresses[msg.sender] = true;
456         AdminAdded(0, msg.sender);
457         adminAudit.length++;
458         adminAudit[adminAudit.length - 1] = msg.sender;
459     }
460 
461     /* Gets the contract version for validation */
462     function contractVersion() constant returns(uint256) {
463         // Admin contract identifies as 100YYYYMMDDHHMM
464         return 100201707171503;
465     }
466 
467     /* Gets whether or not the specified address is currently an admin */
468     function isCurrentAdmin(address _address) constant returns (bool) {
469         return adminAddresses[_address];
470     }
471 
472     /* Gets whether or not the specified address has ever been an admin */
473     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
474         for (uint256 i = 0; i < adminAudit.length; i++)
475             if (adminAudit[i] == _address)
476                 return true;
477         return false;
478     }
479 
480     /* Gets whether or not the specified address is currently an account reader */
481     function isCurrentAccountReader(address _address) constant returns (bool) {
482         return accountReaderAddresses[_address];
483     }
484 
485     /* Gets whether or not the specified address has ever been an admin */
486     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
487         for (uint256 i = 0; i < accountReaderAudit.length; i++)
488             if (accountReaderAudit[i] == _address)
489                 return true;
490         return false;
491     }
492 
493     /* Adds a user to our list of admins */
494     function addAdmin(address _address) {
495         /* Ensure we're an admin */
496         if (!isCurrentAdmin(msg.sender))
497             throw;
498 
499         // Fail if this account is already admin
500         if (adminAddresses[_address])
501             throw;
502         
503         // Add the user
504         adminAddresses[_address] = true;
505         AdminAdded(msg.sender, _address);
506         adminAudit.length++;
507         adminAudit[adminAudit.length - 1] = _address;
508     }
509 
510     /* Removes a user from our list of admins but keeps them in the history audit */
511     function removeAdmin(address _address) {
512         /* Ensure we're an admin */
513         if (!isCurrentAdmin(msg.sender))
514             throw;
515 
516         /* Don't allow removal of self */
517         if (_address == msg.sender)
518             throw;
519 
520         // Fail if this account is already non-admin
521         if (!adminAddresses[_address])
522             throw;
523 
524         /* Remove this admin user */
525         adminAddresses[_address] = false;
526         AdminRemoved(msg.sender, _address);
527     }
528 
529     /* Adds a user/contract to our list of account readers */
530     function addAccountReader(address _address) {
531         /* Ensure we're an admin */
532         if (!isCurrentAdmin(msg.sender))
533             throw;
534 
535         // Fail if this account is already in the list
536         if (accountReaderAddresses[_address])
537             throw;
538         
539         // Add the user
540         accountReaderAddresses[_address] = true;
541         AccountReaderAdded(msg.sender, _address);
542         accountReaderAudit.length++;
543         accountReaderAudit[adminAudit.length - 1] = _address;
544     }
545 
546     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
547     function removeAccountReader(address _address) {
548         /* Ensure we're an admin */
549         if (!isCurrentAdmin(msg.sender))
550             throw;
551 
552         // Fail if this account is already not in the list
553         if (!accountReaderAddresses[_address])
554             throw;
555 
556         /* Remove this admin user */
557         accountReaderAddresses[_address] = false;
558         AccountReaderRemoved(msg.sender, _address);
559     }
560 }
561 
562 contract DividendManager {
563     using SafeMath for uint256;
564 
565     /* Our handle to the SIFT contract. */
566     SmartInvestmentFundToken siftContract;
567 
568     /* Handle payments we couldn't make. */
569     mapping (address => uint256) public dividends;
570 
571     /* Indicates a payment is now available to a shareholder */
572     event PaymentAvailable(address addr, uint256 amount);
573 
574     /* Indicates a dividend payment was made. */
575     event DividendPayment(uint256 paymentPerShare, uint256 timestamp);
576 
577     /* Create our contract with references to other contracts as required. */
578     function DividendManager(address _siftContractAddress) {
579         /* Setup access to our other contracts and validate their versions */
580         siftContract = SmartInvestmentFundToken(_siftContractAddress);
581         if (siftContract.contractVersion() != 500201707171440)
582             throw;
583     }
584 
585     /* Gets the contract version for validation */
586     function contractVersion() constant returns(uint256) {
587         /* Dividend contract identifies as 600YYYYMMDDHHMM */
588         return 600201707171440;
589     }
590 
591     /* Makes a dividend payment - we make it available to all senders then send the change back to the caller.  We don't actually send the payments to everyone to reduce gas cost and also to 
592        prevent potentially getting into a situation where we have recipients throwing causing dividend failures and having to consolidate their dividends in a separate process. */
593     function () payable {
594         if (siftContract.isClosed())
595             throw;
596 
597         /* Determine how much to pay each shareholder. */
598         uint256 validSupply = siftContract.totalSupply();
599         uint256 paymentPerShare = msg.value / validSupply;
600         if (paymentPerShare == 0)
601             throw;
602 
603         /* Enum all accounts and send them payment */
604         uint256 totalPaidOut = 0;
605         for (uint256 i = 0; i < siftContract.tokenHolderCount(); i++) {
606             address addr = siftContract.tokenHolder(i);
607             uint256 dividend = paymentPerShare * siftContract.balanceOf(addr);
608             dividends[addr] = dividends[addr].add(dividend);
609             PaymentAvailable(addr, dividend);
610             totalPaidOut = totalPaidOut.add(dividend);
611         }
612 
613         // Attempt to send change
614         uint256 remainder = msg.value.sub(totalPaidOut);
615         if (remainder > 0 && !msg.sender.send(remainder)) {
616             dividends[msg.sender] = dividends[msg.sender].add(remainder);
617             PaymentAvailable(msg.sender, remainder);
618         }
619 
620         /* Audit this */
621         DividendPayment(paymentPerShare, now);
622     }
623 
624     /* Allows a user to request a withdrawal of their dividend in full. */
625     function withdrawDividend() {
626         // Ensure we have dividends available
627         if (dividends[msg.sender] == 0)
628             throw;
629         
630         // Determine how much we're sending and reset the count
631         uint256 dividend = dividends[msg.sender];
632         dividends[msg.sender] = 0;
633 
634         // Attempt to withdraw
635         if (!msg.sender.send(dividend))
636             throw;
637     }
638 }
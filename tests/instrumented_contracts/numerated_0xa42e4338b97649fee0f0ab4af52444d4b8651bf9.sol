1 pragma solidity ^0.4.18;
2 
3 contract MultiSigERC20Token
4 {
5     uint constant public MAX_OWNER_COUNT = 50;
6 	
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 8;
11     uint256 public totalSupply;
12 	address[] public owners;
13 	address[] public admins;
14 	
15 	// Variables for multisig
16 	uint256 public required;
17     uint public transactionCount;
18 
19     // Events
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event FrozenFunds(address target, bool frozen);
22 	event Confirmation(address indexed sender, uint indexed transactionId);
23     event Revocation(address indexed sender, uint indexed transactionId);
24     event Submission(uint indexed transactionId,string operation, address source, address destination, uint256 value, string reason);
25     event Execution(uint indexed transactionId);
26     event ExecutionFailure(uint indexed transactionId);
27     event Deposit(address indexed sender, uint value);
28     event OwnerAddition(address indexed owner);
29     event OwnerRemoval(address indexed owner);
30     event AdminAddition(address indexed admin);
31     event AdminRemoval(address indexed admin);
32     event RequirementChange(uint required);
33 	
34 	// Mappings
35     mapping (uint => MetaTransaction) public transactions;
36     mapping (address => uint256) public withdrawalLimit;
37     mapping (uint => mapping (address => bool)) public confirmations;
38     mapping (address => bool) public isOwner;
39 	mapping (address => bool) public frozenAccount;
40 	mapping (address => bool) public isAdmin;
41     mapping (address => uint256) public balanceOf;
42 
43     // Meta data for pending and executed Transactions
44     struct MetaTransaction {
45         address source;
46         address destination;
47         uint value;
48         bool executed;
49         uint operation;
50         string reason;
51     }
52 
53     // Modifiers
54     modifier ownerDoesNotExist(address owner) {
55         require (!isOwner[owner]);
56         _;
57     }
58     
59     modifier adminDoesNotExist(address admin) {
60         require (!isAdmin[admin]);
61         _;
62     }
63 
64     modifier ownerExists(address owner) {
65         require (isOwner[owner]);
66         _;
67     }
68     
69     modifier adminExists(address admin) {
70         require (isAdmin[admin] || isOwner[admin]);
71         _;
72     }
73 
74     modifier transactionExists(uint transactionId) {
75         require (transactions[transactionId].operation != 0);
76         _;
77     }
78 
79     modifier confirmed(uint transactionId, address owner) {
80         require (confirmations[transactionId][owner]);
81         _;
82     }
83 
84     modifier notConfirmed(uint transactionId, address owner) {
85         require (!confirmations[transactionId][owner]);
86         _;
87     }
88 
89     modifier notExecuted(uint transactionId) {
90         require (!transactions[transactionId].executed);
91         _;
92     }
93 
94     modifier notNull(address _address) {
95         require (_address != 0);
96         _;
97     }
98 
99     /// @dev Fallback function allows to deposit ether.
100     function() payable public
101     {
102         if (msg.value > 0)
103         {
104             Deposit(msg.sender, msg.value);
105         }
106     }
107 
108     /**
109      * Constrctor function
110      *
111      * Initializes contract with initial supply tokens to the contract and sets owner to the 
112      * creator of the contract
113      */
114     function MultiSigERC20Token(
115         uint256 initialSupply,
116         string tokenName,
117         string tokenSymbol
118     ) public {
119         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
120         balanceOf[this] = totalSupply;                      // Give the contract all initial tokens
121         name = tokenName;                                   // Set the name for display purposes
122         symbol = tokenSymbol;                               // Set the symbol for display purposes
123 		isOwner[msg.sender] = true;                         // Set Owner to Contract Creator
124 		isAdmin[msg.sender] = true;
125 		required = 1;
126 		owners.push(msg.sender);
127 		admins.push(msg.sender);
128     }
129 
130     /**
131      * Internal transfer, only can be called by this contract
132      */
133     function _transfer(address _from, address _to, uint _value) internal {
134         // Prevent transfer to 0x0 address. Use burn() instead
135         require(_to != 0x0);
136         // Check if the sender has enough
137         require(balanceOf[_from] >= _value);
138         // Check if the sender is frozen
139         require(!frozenAccount[_from]);
140         // Check if the recipient is frozen
141         require(!frozenAccount[_to]);
142         // Check for overflows
143         require(balanceOf[_to] + _value > balanceOf[_to]);
144         // Save this for an assertion in the future
145         uint previousBalances = balanceOf[_from] + balanceOf[_to];
146         // Subtract from the sender
147         balanceOf[_from] -= _value;
148         // Add the same to the recipient
149         balanceOf[_to] += _value;
150         Transfer(_from, _to, _value);
151         // Asserts are used to use static analysis to find bugs in your code. They should never fail
152         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
153     }
154 
155     /**
156      * Transfer tokens
157      *
158      * Send `_value` tokens to `_to` from your account
159      *
160      * @param _to The address of the recipient
161      * @param _value the amount to send
162      */
163     function transfer(address _to, uint256 _value) public {
164         _transfer(msg.sender, _to, _value);
165     }
166 	
167 	
168     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
169     /// @param target Address to be frozen
170     /// @param freeze either to freeze it or not
171     function freezeAccount(address target, bool freeze) internal {
172         frozenAccount[target] = freeze;
173         FrozenFunds(target, freeze);
174     }
175 	
176     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
177     /// @param owner Address of new owner.
178     function addOwner(address owner)
179         internal
180         ownerDoesNotExist(owner)
181         notNull(owner)
182     {
183         isOwner[owner] = true;
184         owners.push(owner);
185         required = required + 1;
186         OwnerAddition(owner);
187     }
188     
189     /// @dev Allows to add a new admin. Transaction has to be sent by wallet.
190     /// @param admin Address of new admin.
191     function addAdmin(address admin)
192         internal
193         adminDoesNotExist(admin)
194         notNull(admin)
195     {
196         isAdmin[admin] = true;
197         admins.push(admin);
198         AdminAddition(admin);
199     }
200 
201     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
202     /// @param owner Address of owner.
203     function removeOwner(address owner)
204         internal
205         ownerExists(owner)
206     {
207         isOwner[owner] = false;
208         for (uint i=0; i<owners.length - 1; i++)
209             if (owners[i] == owner) {
210                 owners[i] = owners[owners.length - 1];
211                 break;
212             }
213         owners.length -= 1;
214         if (required > owners.length)
215             changeRequirement(owners.length);
216         OwnerRemoval(owner);
217     }
218     
219     
220     /// @dev Allows to remove an admin. Transaction has to be sent by wallet.
221     /// @param admin Address of admin.
222     function removeAdmin(address admin)
223         internal
224         adminExists(admin)
225     {
226         isAdmin[admin] = false;
227         for (uint i=0; i<admins.length - 1; i++)
228             if (admins[i] == admin) {
229                 admins[i] = admins[admins.length - 1];
230                 break;
231             }
232         admins.length -= 1;
233         AdminRemoval(admin);
234     }
235 
236     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
237     /// @param owner Address of owner to be replaced.
238     /// @param owner Address of new owner.
239     function replaceOwner(address owner, address newOwner)
240         internal
241         ownerExists(owner)
242         ownerDoesNotExist(newOwner)
243     {
244         for (uint i=0; i<owners.length; i++)
245             if (owners[i] == owner) {
246                 owners[i] = newOwner;
247                 break;
248             }
249         isOwner[owner] = false;
250         isOwner[newOwner] = true;
251         OwnerRemoval(owner);
252         OwnerAddition(newOwner);
253     }
254 
255     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
256     /// @param _required Number of required confirmations.
257     function changeRequirement(uint256 _required)
258         internal
259     {
260         required = _required;
261         RequirementChange(_required);
262     }
263     
264     function requestAddOwner(address newOwner, string reason) public adminExists(msg.sender) returns (uint transactionId)
265     {
266         transactionId = submitTransaction(newOwner,newOwner,0,1,reason);
267     }
268 
269     function requestRemoveOwner(address oldOwner, string reason) public adminExists(msg.sender) returns (uint transactionId)
270     {
271         transactionId = submitTransaction(oldOwner,oldOwner,0,2,reason);
272     }
273     
274     function requestReplaceOwner(address oldOwner,address newOwner, string reason) public adminExists(msg.sender) returns (uint transactionId)
275     {
276         transactionId = submitTransaction(oldOwner,newOwner,0,3,reason);
277     }
278     
279     function requestFreezeAccount(address account, string reason) public adminExists(msg.sender) returns (uint transactionId)
280     {
281         transactionId = submitTransaction(account,account,0,4,reason);
282     }
283     
284     function requestUnFreezeAccount(address account, string reason) public adminExists(msg.sender) returns (uint transactionId)
285     {
286         transactionId = submitTransaction(account,account,0,5,reason);
287     }
288     
289     function requestChangeRequirement(uint _requirement, string reason) public adminExists(msg.sender) returns (uint transactionId)
290     {
291         transactionId = submitTransaction(msg.sender,msg.sender,_requirement,6,reason);
292     }
293     
294     function requestTokenIssue(address account, uint256 amount, string reason) public adminExists(msg.sender) returns (uint transactionId)
295     {
296         transactionId = submitTransaction(account,account,amount,7,reason);
297     }
298     
299     function requestAdminTokenTransfer(address source,address destination, uint256 amount, string reason) public adminExists(msg.sender) returns (uint transactionId)
300     {
301         transactionId = submitTransaction(source, destination, amount,8,reason);
302     }
303     
304     function requestSetWithdrawalLimit(address owner,uint256 amount, string reason) public adminExists(msg.sender) returns (uint transactionId)
305     {
306         transactionId = submitTransaction(owner, owner, amount,9,reason);
307     }
308     
309     function requestWithdrawalFromLimit(uint256 amount, string reason) public adminExists(msg.sender) returns (uint transactionId)
310     {
311         transactionId = submitTransaction(msg.sender, msg.sender, amount,10,reason);
312     }
313     
314     function requestWithdrawal(address account,uint256 amount, string reason) public adminExists(msg.sender) returns (uint transactionId)
315     {
316         transactionId = submitTransaction(account, account, amount,11,reason);
317     }
318     
319     function requestAddAdmin(address account, string reason) public adminExists(msg.sender) returns (uint transactionId)
320     {
321         transactionId = submitTransaction(account, account, 0,12,reason);
322     }
323     
324     function requestRemoveAdmin(address account, string reason) public adminExists(msg.sender) returns (uint transactionId)
325     {
326         transactionId = submitTransaction(account, account, 0,13,reason);
327     }
328     
329     /// @dev Allows an owner to submit and confirm a transaction.
330     /// @param destination Transaction target address.
331     /// @param value Transaction ether value.
332     /// @return Returns transaction ID.
333     function submitTransaction(address source, address destination, uint256 value, uint operation, string reason)
334         internal
335         returns (uint transactionId)
336     {
337         transactionId = transactionCount;
338         transactions[transactionId] = MetaTransaction({
339             source: source,
340             destination: destination,
341             value: value,
342             operation: operation,
343             executed: false,
344             reason: reason
345         });
346         
347         transactionCount += 1;
348         
349         if(operation == 1) // Operation 1 is Add Owner
350         {
351             Submission(transactionId,"Add Owner", source, destination, value, reason);
352         }
353         else if(operation == 2) // Operation 2 is Remove Owner
354         {
355             Submission(transactionId,"Remove Owner", source, destination, value, reason);
356         }
357         else if(operation == 3) // Operation 3 is Replace Owner
358         {
359             Submission(transactionId,"Replace Owner", source, destination, value, reason);
360         }
361         else if(operation == 4) // Operation 4 is Freeze Account
362         {
363             Submission(transactionId,"Freeze Account", source, destination, value, reason);
364         }
365         else if(operation == 5) // Operation 5 is UnFreeze Account
366         {
367             Submission(transactionId,"UnFreeze Account", source, destination, value, reason);
368         }
369         else if(operation == 6) // Operation 6 is change rquirement
370         {
371             Submission(transactionId,"Change Requirement", source, destination, value, reason);
372         }
373         else if(operation == 7) // Operation 7 is Issue Tokens from Contract
374         {
375             Submission(transactionId,"Issue Tokens", source, destination, value, reason);
376         }
377         else if(operation == 8) // Operation 8 is Admin Transfer Tokens
378         {
379             Submission(transactionId,"Admin Transfer Tokens", source, destination, value, reason);
380         }
381         else if(operation == 9) // Operation 9 is Set Owners Unsigned Withdrawal Limit
382         {
383             Submission(transactionId,"Set Unsigned Ethereum Withdrawal Limit", source, destination, value, reason);
384         }
385         else if(operation == 10) // Operation 10 is Admin Withdraw Ether without multisig
386         {
387             require(isOwner[destination]);
388             require(withdrawalLimit[destination] > value);
389             
390             Submission(transactionId,"Unsigned Ethereum Withdrawal", source, destination, value, reason);
391             
392             var newValue = withdrawalLimit[destination] - value;
393             withdrawalLimit[destination] = newValue;
394             
395             destination.transfer(value);
396             transactions[transactionId].executed = true;
397             Execution(transactionId);
398         }
399         else if(operation == 11) // Operation 11 is Admin Withdraw Ether with multisig
400         {
401             Submission(transactionId,"Withdraw Ethereum", source, destination, value, reason);
402         }
403         else if(operation == 12) // Operation 12 is Add Admin
404         {
405             Submission(transactionId,"Add Admin", source, destination, value, reason);
406         }
407         else if(operation == 13) // Operation 13 is Remove Admin
408         {
409             Submission(transactionId,"Remove Admin", source, destination, value, reason);
410         }
411     }
412 
413     /// @dev Allows an owner to confirm a transaction.
414     /// @param transactionId Transaction ID.
415     function confirmTransaction(uint transactionId)
416         public
417         ownerExists(msg.sender)
418         transactionExists(transactionId)
419         notConfirmed(transactionId, msg.sender)
420     {
421         confirmations[transactionId][msg.sender] = true;
422         Confirmation(msg.sender, transactionId);
423         executeTransaction(transactionId);
424     }
425     
426     /// @dev Allows an owner to confirm a transaction.
427     /// @param startTransactionId the first transaction to approve
428     /// @param endTransactionId the last transaction to approve.
429     function confirmMultipleTransactions(uint startTransactionId, uint endTransactionId)
430         public
431         ownerExists(msg.sender)
432         transactionExists(endTransactionId)
433     {
434         for(var i=startTransactionId;i<=endTransactionId;i++)
435         {
436             require(transactions[i].operation != 0);
437             require(!confirmations[i][msg.sender]);
438             confirmations[i][msg.sender] = true;
439             Confirmation(msg.sender, i);
440             executeTransaction(i);
441         }
442     }
443 
444     /// @dev Allows an owner to revoke a confirmation for a transaction.
445     /// @param transactionId Transaction ID.
446     function revokeConfirmation(uint transactionId)
447         public
448         ownerExists(msg.sender)
449         confirmed(transactionId, msg.sender)
450         notExecuted(transactionId)
451     {
452         confirmations[transactionId][msg.sender] = false;
453         Revocation(msg.sender, transactionId);
454     }
455 
456     /// @dev Allows anyone to execute a confirmed transaction.
457     /// @param transactionId Transaction ID.
458     function executeTransaction(uint transactionId)
459         internal
460         notExecuted(transactionId)
461     {
462         if (isConfirmed(transactionId)) {
463             var transaction = transactions[transactionId];
464 
465             if(transaction.operation == 1) // Operation 1 is Add Owner
466             {
467                 addOwner(transaction.destination);
468                 
469                 transaction.executed = true;
470                 Execution(transactionId);
471             }
472             else if(transaction.operation == 2) // Operation 2 is Remove Owner
473             {
474                 removeOwner(transaction.destination);
475                 
476                 transaction.executed = true;
477                 Execution(transactionId);
478             }
479             else if(transaction.operation == 3) // Operation 3 is Replace Owner
480             {
481                 replaceOwner(transaction.source,transaction.destination);
482                 
483                 transaction.executed = true;
484                 Execution(transactionId);
485             }
486             else if(transaction.operation == 4) // Operation 4 is Freeze Account
487             {
488                 freezeAccount(transaction.destination,true);
489                 
490                 transaction.executed = true;
491                 Execution(transactionId);
492             }
493             else if(transaction.operation == 5) // Operation 5 is UnFreeze Account
494             {
495                 freezeAccount(transaction.destination, false);
496                 
497                 transaction.executed = true;
498                 Execution(transactionId);
499             }
500             else if(transaction.operation == 6) // Operation 6 is change requirement Account
501             {
502                 changeRequirement(transaction.value);
503                 
504                 transaction.executed = true;
505                 Execution(transactionId);
506             }
507             else if(transaction.operation == 7) // Operation 7 is Issue Tokens from Contract
508             {
509                 _transfer(this,transaction.destination,transaction.value);
510                 
511                 transaction.executed = true;
512                 Execution(transactionId);
513             }
514             else if(transaction.operation == 8) // Operation 8 is Admin Transfer Tokens
515             {
516                 _transfer(transaction.source,transaction.destination,transaction.value);
517                 
518                 transaction.executed = true;
519                 Execution(transactionId);
520             }
521             else if(transaction.operation == 9) // Operation 9 is Set Owners Unsigned Withdrawal Limit
522             {
523                 require(isOwner[transaction.destination]);
524                 withdrawalLimit[transaction.destination] = transaction.value;
525                 
526                 transaction.executed = true;
527                 Execution(transactionId);
528             }
529             else if(transaction.operation == 11) // Operation 11 is Admin Withdraw Ether with multisig
530             {
531                 require(isOwner[transaction.destination]);
532                 
533                 transaction.destination.transfer(transaction.value);
534                 
535                 transaction.executed = true;
536                 Execution(transactionId);
537             }
538             else if(transaction.operation == 12) // Operation 12 is add Admin
539             {
540                 addAdmin(transaction.destination);
541                 
542                 transaction.executed = true;
543                 Execution(transactionId);
544             }
545             else if(transaction.operation == 13) // Operation 13 is remove Admin
546             {
547                 removeAdmin(transaction.destination);
548                 
549                 transaction.executed = true;
550                 Execution(transactionId);
551             }
552         }
553     }
554 
555     /// @dev Returns the confirmation status of a transaction.
556     /// @param transactionId Transaction ID.
557     /// @return Confirmation status.
558     function isConfirmed(uint transactionId)
559         public
560         constant
561         returns (bool)
562     {
563         uint count = 0;
564         for (uint i=0; i<owners.length; i++) {
565             if (confirmations[transactionId][owners[i]])
566                 count += 1;
567             if (count == required)
568                 return true;
569         }
570     }
571 
572     /*
573      * Internal functions
574      */
575    
576     /*
577      * Web3 call functions
578      */
579     /// @dev Returns number of confirmations of a transaction.
580     /// @param transactionId Transaction ID.
581     /// @return Number of confirmations.
582     function getConfirmationCount(uint transactionId)
583         public
584         constant
585         returns (uint count)
586     {
587         for (uint i=0; i<owners.length; i++)
588             if (confirmations[transactionId][owners[i]])
589                 count += 1;
590     }
591 
592     /// @dev Returns total number of transactions after filers are applied.
593     /// @param pending Include pending transactions.
594     /// @param executed Include executed transactions.
595     /// @return Total number of transactions after filters are applied.
596     function getTransactionCount(bool pending, bool executed)
597         public
598         constant
599         returns (uint count)
600     {
601         for (uint i=0; i<transactionCount; i++)
602             if (   pending && !transactions[i].executed
603                 || executed && transactions[i].executed)
604                 count += 1;
605     }
606 
607     /// @dev Returns list of owners.
608     /// @return List of owner addresses.
609     function getOwners()
610         public
611         constant
612         returns (address[])
613     {
614         return owners;
615     }
616 
617     /// @dev Returns array with owner addresses, which confirmed transaction.
618     /// @param transactionId Transaction ID.
619     /// @return Returns array of owner addresses.
620     function getConfirmations(uint transactionId)
621         public
622         constant
623         returns (address[] _confirmations)
624     {
625         address[] memory confirmationsTemp = new address[](owners.length);
626         uint count = 0;
627         uint i;
628         for (i=0; i<owners.length; i++)
629             if (confirmations[transactionId][owners[i]]) {
630                 confirmationsTemp[count] = owners[i];
631                 count += 1;
632             }
633         _confirmations = new address[](count);
634         for (i=0; i<count; i++)
635             _confirmations[i] = confirmationsTemp[i];
636     }
637 
638     /// @dev Returns list of transaction IDs in defined range.
639     /// @param from Index start position of transaction array.
640     /// @param to Index end position of transaction array.
641     /// @param pending Include pending transactions.
642     /// @param executed Include executed transactions.
643     /// @return Returns array of transaction IDs.
644     function getTransactionIds(uint from, uint to, bool pending, bool executed)
645         public
646         constant
647         returns (uint[] _transactionIds)
648     {
649         uint[] memory transactionIdsTemp = new uint[](transactionCount);
650         uint count = 0;
651         uint i;
652         for (i=0; i<transactionCount; i++)
653             if (   pending && !transactions[i].executed
654                 || executed && transactions[i].executed)
655             {
656                 transactionIdsTemp[count] = i;
657                 count += 1;
658             }
659         _transactionIds = new uint[](to - from);
660         for (i=from; i<to; i++)
661             _transactionIds[i - from] = transactionIdsTemp[i];
662     }
663 }
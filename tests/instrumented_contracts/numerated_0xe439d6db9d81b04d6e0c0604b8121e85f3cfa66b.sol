1 pragma solidity ^0.4.15;
2 
3 
4 contract Factory {
5 
6     /*
7      *  Events
8      */
9     event ContractInstantiation(address sender, address instantiation);
10 
11     /*
12      *  Storage
13      */
14     mapping(address => bool) public isInstantiation;
15     mapping(address => address[]) public instantiations;
16 
17     /*
18      * Public functions
19      */
20     /// @dev Returns number of instantiations by creator.
21     /// @param creator Contract creator.
22     /// @return Returns number of instantiations by creator.
23     function getInstantiationCount(address creator)
24         public
25         constant
26         returns (uint)
27     {
28         return instantiations[creator].length;
29     }
30 
31     /*
32      * Internal functions
33      */
34     /// @dev Registers contract in factory registry.
35     /// @param instantiation Address of contract instantiation.
36     function register(address instantiation)
37         internal
38     {
39         isInstantiation[instantiation] = true;
40         instantiations[msg.sender].push(instantiation);
41         ContractInstantiation(msg.sender, instantiation);
42     }
43 }
44 
45 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
46 /// @author Stefan George - <stefan.george@consensys.net>
47 contract MultiSigWallet {
48 
49     /*
50      *  Events
51      */
52     event Confirmation(address indexed sender, uint indexed transactionId);
53     event Revocation(address indexed sender, uint indexed transactionId);
54     event Submission(uint indexed transactionId);
55     event Execution(uint indexed transactionId);
56     event ExecutionFailure(uint indexed transactionId);
57     event Deposit(address indexed sender, uint value);
58     event OwnerAddition(address indexed owner);
59     event OwnerRemoval(address indexed owner);
60     event RequirementChange(uint required);
61 
62     /*
63      *  Constants
64      */
65     uint constant public MAX_OWNER_COUNT = 50;
66 
67     /*
68      *  Storage
69      */
70     mapping (uint => Transaction) public transactions;
71     mapping (uint => mapping (address => bool)) public confirmations;
72     mapping (address => bool) public isOwner;
73     address[] public owners;
74     uint public required;
75     uint public transactionCount;
76 
77     struct Transaction {
78         address destination;
79         uint value;
80         bytes data;
81         bool executed;
82     }
83 
84     /*
85      *  Modifiers
86      */
87     modifier onlyWallet() {
88         require(msg.sender == address(this));
89         _;
90     }
91 
92     modifier ownerDoesNotExist(address owner) {
93         require(!isOwner[owner]);
94         _;
95     }
96 
97     modifier ownerExists(address owner) {
98         require(isOwner[owner]);
99         _;
100     }
101 
102     modifier transactionExists(uint transactionId) {
103         require(transactions[transactionId].destination != 0);
104         _;
105     }
106 
107     modifier confirmed(uint transactionId, address owner) {
108         require(confirmations[transactionId][owner]);
109         _;
110     }
111 
112     modifier notConfirmed(uint transactionId, address owner) {
113         require(!confirmations[transactionId][owner]);
114         _;
115     }
116 
117     modifier notExecuted(uint transactionId) {
118         require(!transactions[transactionId].executed);
119         _;
120     }
121 
122     modifier notNull(address _address) {
123         require(_address != 0);
124         _;
125     }
126 
127     modifier validRequirement(uint ownerCount, uint _required) {
128         require(ownerCount <= MAX_OWNER_COUNT
129             && _required <= ownerCount
130             && _required != 0
131             && ownerCount != 0);
132         _;
133     }
134 
135     /// @dev Fallback function allows to deposit ether.
136     function()
137         payable
138     {
139         if (msg.value > 0)
140             Deposit(msg.sender, msg.value);
141     }
142 
143     /*
144      * Public functions
145      */
146     /// @dev Contract constructor sets initial owners and required number of confirmations.
147     /// @param _owners List of initial owners.
148     /// @param _required Number of required confirmations.
149     function MultiSigWallet(address[] _owners, uint _required)
150         public
151         validRequirement(_owners.length, _required)
152     {
153         for (uint i=0; i<_owners.length; i++) {
154             require(!isOwner[_owners[i]] && _owners[i] != 0);
155             isOwner[_owners[i]] = true;
156         }
157         owners = _owners;
158         required = _required;
159     }
160 
161     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
162     /// @param owner Address of new owner.
163     function addOwner(address owner)
164         public
165         onlyWallet
166         ownerDoesNotExist(owner)
167         notNull(owner)
168         validRequirement(owners.length + 1, required)
169     {
170         isOwner[owner] = true;
171         owners.push(owner);
172         OwnerAddition(owner);
173     }
174 
175     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
176     /// @param owner Address of owner.
177     function removeOwner(address owner)
178         public
179         onlyWallet
180         ownerExists(owner)
181     {
182         isOwner[owner] = false;
183         for (uint i=0; i<owners.length - 1; i++)
184             if (owners[i] == owner) {
185                 owners[i] = owners[owners.length - 1];
186                 break;
187             }
188         owners.length -= 1;
189         if (required > owners.length)
190             changeRequirement(owners.length);
191         OwnerRemoval(owner);
192     }
193 
194     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
195     /// @param owner Address of owner to be replaced.
196     /// @param newOwner Address of new owner.
197     function replaceOwner(address owner, address newOwner)
198         public
199         onlyWallet
200         ownerExists(owner)
201         ownerDoesNotExist(newOwner)
202     {
203         for (uint i=0; i<owners.length; i++)
204             if (owners[i] == owner) {
205                 owners[i] = newOwner;
206                 break;
207             }
208         isOwner[owner] = false;
209         isOwner[newOwner] = true;
210         OwnerRemoval(owner);
211         OwnerAddition(newOwner);
212     }
213 
214     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
215     /// @param _required Number of required confirmations.
216     function changeRequirement(uint _required)
217         public
218         onlyWallet
219         validRequirement(owners.length, _required)
220     {
221         required = _required;
222         RequirementChange(_required);
223     }
224 
225     /// @dev Allows an owner to submit and confirm a transaction.
226     /// @param destination Transaction target address.
227     /// @param value Transaction ether value.
228     /// @param data Transaction data payload.
229     /// @return Returns transaction ID.
230     function submitTransaction(address destination, uint value, bytes data)
231         public
232         returns (uint transactionId)
233     {
234         transactionId = addTransaction(destination, value, data);
235         confirmTransaction(transactionId);
236     }
237 
238     /// @dev Allows an owner to confirm a transaction.
239     /// @param transactionId Transaction ID.
240     function confirmTransaction(uint transactionId)
241         public
242         ownerExists(msg.sender)
243         transactionExists(transactionId)
244         notConfirmed(transactionId, msg.sender)
245     {
246         confirmations[transactionId][msg.sender] = true;
247         Confirmation(msg.sender, transactionId);
248         executeTransaction(transactionId);
249     }
250 
251     /// @dev Allows an owner to revoke a confirmation for a transaction.
252     /// @param transactionId Transaction ID.
253     function revokeConfirmation(uint transactionId)
254         public
255         ownerExists(msg.sender)
256         confirmed(transactionId, msg.sender)
257         notExecuted(transactionId)
258     {
259         confirmations[transactionId][msg.sender] = false;
260         Revocation(msg.sender, transactionId);
261     }
262 
263     /// @dev Allows anyone to execute a confirmed transaction.
264     /// @param transactionId Transaction ID.
265     function executeTransaction(uint transactionId)
266         public
267         ownerExists(msg.sender)
268         confirmed(transactionId, msg.sender)
269         notExecuted(transactionId)
270     {
271         if (isConfirmed(transactionId)) {
272             Transaction storage txn = transactions[transactionId];
273             txn.executed = true;
274             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
275                 Execution(transactionId);
276             else {
277                 ExecutionFailure(transactionId);
278                 txn.executed = false;
279             }
280         }
281     }
282 
283     // call has been separated into its own function in order to take advantage
284     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
285     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
286         bool result;
287         assembly {
288             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
289             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
290             result := call(
291                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
292                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
293                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
294                 destination,
295                 value,
296                 d,
297                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
298                 x,
299                 0                  // Output is ignored, therefore the output size is zero
300             )
301         }
302         return result;
303     }
304 
305     /// @dev Returns the confirmation status of a transaction.
306     /// @param transactionId Transaction ID.
307     /// @return Confirmation status.
308     function isConfirmed(uint transactionId)
309         public
310         constant
311         returns (bool)
312     {
313         uint count = 0;
314         for (uint i=0; i<owners.length; i++) {
315             if (confirmations[transactionId][owners[i]])
316                 count += 1;
317             if (count == required)
318                 return true;
319         }
320     }
321 
322     /*
323      * Internal functions
324      */
325     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
326     /// @param destination Transaction target address.
327     /// @param value Transaction ether value.
328     /// @param data Transaction data payload.
329     /// @return Returns transaction ID.
330     function addTransaction(address destination, uint value, bytes data)
331         internal
332         notNull(destination)
333         returns (uint transactionId)
334     {
335         transactionId = transactionCount;
336         transactions[transactionId] = Transaction({
337             destination: destination,
338             value: value,
339             data: data,
340             executed: false
341         });
342         transactionCount += 1;
343         Submission(transactionId);
344     }
345 
346     /*
347      * Web3 call functions
348      */
349     /// @dev Returns number of confirmations of a transaction.
350     /// @param transactionId Transaction ID.
351     /// @return Number of confirmations.
352     function getConfirmationCount(uint transactionId)
353         public
354         constant
355         returns (uint count)
356     {
357         for (uint i=0; i<owners.length; i++)
358             if (confirmations[transactionId][owners[i]])
359                 count += 1;
360     }
361 
362     /// @dev Returns total number of transactions after filers are applied.
363     /// @param pending Include pending transactions.
364     /// @param executed Include executed transactions.
365     /// @return Total number of transactions after filters are applied.
366     function getTransactionCount(bool pending, bool executed)
367         public
368         constant
369         returns (uint count)
370     {
371         for (uint i=0; i<transactionCount; i++)
372             if (   pending && !transactions[i].executed
373                 || executed && transactions[i].executed)
374                 count += 1;
375     }
376 
377     /// @dev Returns list of owners.
378     /// @return List of owner addresses.
379     function getOwners()
380         public
381         constant
382         returns (address[])
383     {
384         return owners;
385     }
386 
387     /// @dev Returns array with owner addresses, which confirmed transaction.
388     /// @param transactionId Transaction ID.
389     /// @return Returns array of owner addresses.
390     function getConfirmations(uint transactionId)
391         public
392         constant
393         returns (address[] _confirmations)
394     {
395         address[] memory confirmationsTemp = new address[](owners.length);
396         uint count = 0;
397         uint i;
398         for (i=0; i<owners.length; i++)
399             if (confirmations[transactionId][owners[i]]) {
400                 confirmationsTemp[count] = owners[i];
401                 count += 1;
402             }
403         _confirmations = new address[](count);
404         for (i=0; i<count; i++)
405             _confirmations[i] = confirmationsTemp[i];
406     }
407 
408     /// @dev Returns list of transaction IDs in defined range.
409     /// @param from Index start position of transaction array.
410     /// @param to Index end position of transaction array.
411     /// @param pending Include pending transactions.
412     /// @param executed Include executed transactions.
413     /// @return Returns array of transaction IDs.
414     function getTransactionIds(uint from, uint to, bool pending, bool executed)
415         public
416         constant
417         returns (uint[] _transactionIds)
418     {
419         uint[] memory transactionIdsTemp = new uint[](transactionCount);
420         uint count = 0;
421         uint i;
422         for (i=0; i<transactionCount; i++)
423             if (   pending && !transactions[i].executed
424                 || executed && transactions[i].executed)
425             {
426                 transactionIdsTemp[count] = i;
427                 count += 1;
428             }
429         _transactionIds = new uint[](to - from);
430         for (i=from; i<to; i++)
431             _transactionIds[i - from] = transactionIdsTemp[i];
432     }
433 }
434 
435 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
436 /// @author Stefan George - <stefan.george@consensys.net>
437 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
438 
439     /*
440      *  Events
441      */
442     event DailyLimitChange(uint dailyLimit);
443 
444     /*
445      *  Storage
446      */
447     uint public dailyLimit;
448     uint public lastDay;
449     uint public spentToday;
450 
451     /*
452      * Public functions
453      */
454     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
455     /// @param _owners List of initial owners.
456     /// @param _required Number of required confirmations.
457     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
458     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
459         public
460         MultiSigWallet(_owners, _required)
461     {
462         dailyLimit = _dailyLimit;
463     }
464 
465     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
466     /// @param _dailyLimit Amount in wei.
467     function changeDailyLimit(uint _dailyLimit)
468         public
469         onlyWallet
470     {
471         dailyLimit = _dailyLimit;
472         DailyLimitChange(_dailyLimit);
473     }
474 
475     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
476     /// @param transactionId Transaction ID.
477     function executeTransaction(uint transactionId)
478         public
479         ownerExists(msg.sender)
480         confirmed(transactionId, msg.sender)
481         notExecuted(transactionId)
482     {
483         Transaction storage txn = transactions[transactionId];
484         bool _confirmed = isConfirmed(transactionId);
485         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
486             txn.executed = true;
487             if (!_confirmed)
488                 spentToday += txn.value;
489             if (txn.destination.call.value(txn.value)(txn.data))
490                 Execution(transactionId);
491             else {
492                 ExecutionFailure(transactionId);
493                 txn.executed = false;
494                 if (!_confirmed)
495                     spentToday -= txn.value;
496             }
497         }
498     }
499 
500     /*
501      * Internal functions
502      */
503     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
504     /// @param amount Amount to withdraw.
505     /// @return Returns if amount is under daily limit.
506     function isUnderLimit(uint amount)
507         internal
508         returns (bool)
509     {
510         if (now > lastDay + 24 hours) {
511             lastDay = now;
512             spentToday = 0;
513         }
514         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
515             return false;
516         return true;
517     }
518 
519     /*
520      * Web3 call functions
521      */
522     /// @dev Returns maximum withdraw amount.
523     /// @return Returns amount.
524     function calcMaxWithdraw()
525         public
526         constant
527         returns (uint)
528     {
529         if (now > lastDay + 24 hours)
530             return dailyLimit;
531         if (dailyLimit < spentToday)
532             return 0;
533         return dailyLimit - spentToday;
534     }
535 }
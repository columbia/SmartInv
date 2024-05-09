1 // https://etherscan.io/address/0x6e95c8e8557abc08b46f3c347ba06f8dc012763f#code
2 // Solidity v0.4.19+commit.c4cbbb05
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
274             if (txn.destination.call.value(txn.value)(txn.data))
275                 Execution(transactionId);
276             else {
277                 ExecutionFailure(transactionId);
278                 txn.executed = false;
279             }
280         }
281     }
282 
283     /// @dev Returns the confirmation status of a transaction.
284     /// @param transactionId Transaction ID.
285     /// @return Confirmation status.
286     function isConfirmed(uint transactionId)
287         public
288         constant
289         returns (bool)
290     {
291         uint count = 0;
292         for (uint i=0; i<owners.length; i++) {
293             if (confirmations[transactionId][owners[i]])
294                 count += 1;
295             if (count == required)
296                 return true;
297         }
298     }
299 
300     /*
301      * Internal functions
302      */
303     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
304     /// @param destination Transaction target address.
305     /// @param value Transaction ether value.
306     /// @param data Transaction data payload.
307     /// @return Returns transaction ID.
308     function addTransaction(address destination, uint value, bytes data)
309         internal
310         notNull(destination)
311         returns (uint transactionId)
312     {
313         transactionId = transactionCount;
314         transactions[transactionId] = Transaction({
315             destination: destination,
316             value: value,
317             data: data,
318             executed: false
319         });
320         transactionCount += 1;
321         Submission(transactionId);
322     }
323 
324     /*
325      * Web3 call functions
326      */
327     /// @dev Returns number of confirmations of a transaction.
328     /// @param transactionId Transaction ID.
329     /// @return Number of confirmations.
330     function getConfirmationCount(uint transactionId)
331         public
332         constant
333         returns (uint count)
334     {
335         for (uint i=0; i<owners.length; i++)
336             if (confirmations[transactionId][owners[i]])
337                 count += 1;
338     }
339 
340     /// @dev Returns total number of transactions after filers are applied.
341     /// @param pending Include pending transactions.
342     /// @param executed Include executed transactions.
343     /// @return Total number of transactions after filters are applied.
344     function getTransactionCount(bool pending, bool executed)
345         public
346         constant
347         returns (uint count)
348     {
349         for (uint i=0; i<transactionCount; i++)
350             if (   pending && !transactions[i].executed
351                 || executed && transactions[i].executed)
352                 count += 1;
353     }
354 
355     /// @dev Returns list of owners.
356     /// @return List of owner addresses.
357     function getOwners()
358         public
359         constant
360         returns (address[])
361     {
362         return owners;
363     }
364 
365     /// @dev Returns array with owner addresses, which confirmed transaction.
366     /// @param transactionId Transaction ID.
367     /// @return Returns array of owner addresses.
368     function getConfirmations(uint transactionId)
369         public
370         constant
371         returns (address[] _confirmations)
372     {
373         address[] memory confirmationsTemp = new address[](owners.length);
374         uint count = 0;
375         uint i;
376         for (i=0; i<owners.length; i++)
377             if (confirmations[transactionId][owners[i]]) {
378                 confirmationsTemp[count] = owners[i];
379                 count += 1;
380             }
381         _confirmations = new address[](count);
382         for (i=0; i<count; i++)
383             _confirmations[i] = confirmationsTemp[i];
384     }
385 
386     /// @dev Returns list of transaction IDs in defined range.
387     /// @param from Index start position of transaction array.
388     /// @param to Index end position of transaction array.
389     /// @param pending Include pending transactions.
390     /// @param executed Include executed transactions.
391     /// @return Returns array of transaction IDs.
392     function getTransactionIds(uint from, uint to, bool pending, bool executed)
393         public
394         constant
395         returns (uint[] _transactionIds)
396     {
397         uint[] memory transactionIdsTemp = new uint[](transactionCount);
398         uint count = 0;
399         uint i;
400         for (i=0; i<transactionCount; i++)
401             if (   pending && !transactions[i].executed
402                 || executed && transactions[i].executed)
403             {
404                 transactionIdsTemp[count] = i;
405                 count += 1;
406             }
407         _transactionIds = new uint[](to - from);
408         for (i=from; i<to; i++)
409             _transactionIds[i - from] = transactionIdsTemp[i];
410     }
411 }
412 
413 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
414 /// @author Stefan George - <stefan.george@consensys.net>
415 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
416 
417     /*
418      *  Events
419      */
420     event DailyLimitChange(uint dailyLimit);
421 
422     /*
423      *  Storage
424      */
425     uint public dailyLimit;
426     uint public lastDay;
427     uint public spentToday;
428 
429     /*
430      * Public functions
431      */
432     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
433     /// @param _owners List of initial owners.
434     /// @param _required Number of required confirmations.
435     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
436     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
437         public
438         MultiSigWallet(_owners, _required)
439     {
440         dailyLimit = _dailyLimit;
441     }
442 
443     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
444     /// @param _dailyLimit Amount in wei.
445     function changeDailyLimit(uint _dailyLimit)
446         public
447         onlyWallet
448     {
449         dailyLimit = _dailyLimit;
450         DailyLimitChange(_dailyLimit);
451     }
452 
453     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
454     /// @param transactionId Transaction ID.
455     function executeTransaction(uint transactionId)
456         public
457         ownerExists(msg.sender)
458         confirmed(transactionId, msg.sender)
459         notExecuted(transactionId)
460     {
461         Transaction storage txn = transactions[transactionId];
462         bool _confirmed = isConfirmed(transactionId);
463         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
464             txn.executed = true;
465             if (!_confirmed)
466                 spentToday += txn.value;
467             if (txn.destination.call.value(txn.value)(txn.data))
468                 Execution(transactionId);
469             else {
470                 ExecutionFailure(transactionId);
471                 txn.executed = false;
472                 if (!_confirmed)
473                     spentToday -= txn.value;
474             }
475         }
476     }
477 
478     /*
479      * Internal functions
480      */
481     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
482     /// @param amount Amount to withdraw.
483     /// @return Returns if amount is under daily limit.
484     function isUnderLimit(uint amount)
485         internal
486         returns (bool)
487     {
488         if (now > lastDay + 24 hours) {
489             lastDay = now;
490             spentToday = 0;
491         }
492         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
493             return false;
494         return true;
495     }
496 
497     /*
498      * Web3 call functions
499      */
500     /// @dev Returns maximum withdraw amount.
501     /// @return Returns amount.
502     function calcMaxWithdraw()
503         public
504         constant
505         returns (uint)
506     {
507         if (now > lastDay + 24 hours)
508             return dailyLimit;
509         if (dailyLimit < spentToday)
510             return 0;
511         return dailyLimit - spentToday;
512     }
513 }
514 
515 /// @title Multisignature wallet factory for daily limit version - Allows creation of multisig wallet.
516 /// @author Stefan George - <stefan.george@consensys.net>
517 contract MultiSigWalletWithDailyLimitFactory is Factory {
518 
519     /*
520      * Public functions
521      */
522     /// @dev Allows verified creation of multisignature wallet.
523     /// @param _owners List of initial owners.
524     /// @param _required Number of required confirmations.
525     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
526     /// @return Returns wallet address.
527     function create(address[] _owners, uint _required, uint _dailyLimit)
528         public
529         returns (address wallet)
530     {
531         wallet = new MultiSigWalletWithDailyLimit(_owners, _required, _dailyLimit);
532         register(wallet);
533     }
534 }
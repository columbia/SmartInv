1 contract Factory {
2 
3     /*
4      *  Events
5      */
6     event ContractInstantiation(address sender, address instantiation);
7 
8     /*
9      *  Storage
10      */
11     mapping(address => bool) public isInstantiation;
12     mapping(address => address[]) public instantiations;
13 
14     /*
15      * Public functions
16      */
17     /// @dev Returns number of instantiations by creator.
18     /// @param creator Contract creator.
19     /// @return Returns number of instantiations by creator.
20     function getInstantiationCount(address creator)
21         public
22         constant
23         returns (uint)
24     {
25         return instantiations[creator].length;
26     }
27 
28     /*
29      * Internal functions
30      */
31     /// @dev Registers contract in factory registry.
32     /// @param instantiation Address of contract instantiation.
33     function register(address instantiation)
34         internal
35     {
36         isInstantiation[instantiation] = true;
37         instantiations[msg.sender].push(instantiation);
38         ContractInstantiation(msg.sender, instantiation);
39     }
40 }
41 
42 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
43 /// @author Stefan George - <stefan.george@consensys.net>
44 contract MultiSigWallet {
45 
46     /*
47      *  Events
48      */
49     event Confirmation(address indexed sender, uint indexed transactionId);
50     event Revocation(address indexed sender, uint indexed transactionId);
51     event Submission(uint indexed transactionId);
52     event Execution(uint indexed transactionId);
53     event ExecutionFailure(uint indexed transactionId);
54     event Deposit(address indexed sender, uint value);
55     event OwnerAddition(address indexed owner);
56     event OwnerRemoval(address indexed owner);
57     event RequirementChange(uint required);
58 
59     /*
60      *  Constants
61      */
62     uint constant public MAX_OWNER_COUNT = 50;
63 
64     /*
65      *  Storage
66      */
67     mapping (uint => Transaction) public transactions;
68     mapping (uint => mapping (address => bool)) public confirmations;
69     mapping (address => bool) public isOwner;
70     address[] public owners;
71     uint public required;
72     uint public transactionCount;
73 
74     struct Transaction {
75         address destination;
76         uint value;
77         bytes data;
78         bool executed;
79     }
80 
81     /*
82      *  Modifiers
83      */
84     modifier onlyWallet() {
85         require(msg.sender == address(this));
86         _;
87     }
88 
89     modifier ownerDoesNotExist(address owner) {
90         require(!isOwner[owner]);
91         _;
92     }
93 
94     modifier ownerExists(address owner) {
95         require(isOwner[owner]);
96         _;
97     }
98 
99     modifier transactionExists(uint transactionId) {
100         require(transactions[transactionId].destination != 0);
101         _;
102     }
103 
104     modifier confirmed(uint transactionId, address owner) {
105         require(confirmations[transactionId][owner]);
106         _;
107     }
108 
109     modifier notConfirmed(uint transactionId, address owner) {
110         require(!confirmations[transactionId][owner]);
111         _;
112     }
113 
114     modifier notExecuted(uint transactionId) {
115         require(!transactions[transactionId].executed);
116         _;
117     }
118 
119     modifier notNull(address _address) {
120         require(_address != 0);
121         _;
122     }
123 
124     modifier validRequirement(uint ownerCount, uint _required) {
125         require(ownerCount <= MAX_OWNER_COUNT
126             && _required <= ownerCount
127             && _required != 0
128             && ownerCount != 0);
129         _;
130     }
131 
132     /// @dev Fallback function allows to deposit ether.
133     function()
134         payable
135     {
136         if (msg.value > 0)
137             Deposit(msg.sender, msg.value);
138     }
139 
140     /*
141      * Public functions
142      */
143     /// @dev Contract constructor sets initial owners and required number of confirmations.
144     /// @param _owners List of initial owners.
145     /// @param _required Number of required confirmations.
146     function MultiSigWallet(address[] _owners, uint _required)
147         public
148         validRequirement(_owners.length, _required)
149     {
150         for (uint i=0; i<_owners.length; i++) {
151             require(!isOwner[_owners[i]] && _owners[i] != 0);
152             isOwner[_owners[i]] = true;
153         }
154         owners = _owners;
155         required = _required;
156     }
157 
158     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
159     /// @param owner Address of new owner.
160     function addOwner(address owner)
161         public
162         onlyWallet
163         ownerDoesNotExist(owner)
164         notNull(owner)
165         validRequirement(owners.length + 1, required)
166     {
167         isOwner[owner] = true;
168         owners.push(owner);
169         OwnerAddition(owner);
170     }
171 
172     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
173     /// @param owner Address of owner.
174     function removeOwner(address owner)
175         public
176         onlyWallet
177         ownerExists(owner)
178     {
179         isOwner[owner] = false;
180         for (uint i=0; i<owners.length - 1; i++)
181             if (owners[i] == owner) {
182                 owners[i] = owners[owners.length - 1];
183                 break;
184             }
185         owners.length -= 1;
186         if (required > owners.length)
187             changeRequirement(owners.length);
188         OwnerRemoval(owner);
189     }
190 
191     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
192     /// @param owner Address of owner to be replaced.
193     /// @param newOwner Address of new owner.
194     function replaceOwner(address owner, address newOwner)
195         public
196         onlyWallet
197         ownerExists(owner)
198         ownerDoesNotExist(newOwner)
199     {
200         for (uint i=0; i<owners.length; i++)
201             if (owners[i] == owner) {
202                 owners[i] = newOwner;
203                 break;
204             }
205         isOwner[owner] = false;
206         isOwner[newOwner] = true;
207         OwnerRemoval(owner);
208         OwnerAddition(newOwner);
209     }
210 
211     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
212     /// @param _required Number of required confirmations.
213     function changeRequirement(uint _required)
214         public
215         onlyWallet
216         validRequirement(owners.length, _required)
217     {
218         required = _required;
219         RequirementChange(_required);
220     }
221 
222     /// @dev Allows an owner to submit and confirm a transaction.
223     /// @param destination Transaction target address.
224     /// @param value Transaction ether value.
225     /// @param data Transaction data payload.
226     /// @return Returns transaction ID.
227     function submitTransaction(address destination, uint value, bytes data)
228         public
229         returns (uint transactionId)
230     {
231         transactionId = addTransaction(destination, value, data);
232         confirmTransaction(transactionId);
233     }
234 
235     /// @dev Allows an owner to confirm a transaction.
236     /// @param transactionId Transaction ID.
237     function confirmTransaction(uint transactionId)
238         public
239         ownerExists(msg.sender)
240         transactionExists(transactionId)
241         notConfirmed(transactionId, msg.sender)
242     {
243         confirmations[transactionId][msg.sender] = true;
244         Confirmation(msg.sender, transactionId);
245         executeTransaction(transactionId);
246     }
247 
248     /// @dev Allows an owner to revoke a confirmation for a transaction.
249     /// @param transactionId Transaction ID.
250     function revokeConfirmation(uint transactionId)
251         public
252         ownerExists(msg.sender)
253         confirmed(transactionId, msg.sender)
254         notExecuted(transactionId)
255     {
256         confirmations[transactionId][msg.sender] = false;
257         Revocation(msg.sender, transactionId);
258     }
259 
260     /// @dev Allows anyone to execute a confirmed transaction.
261     /// @param transactionId Transaction ID.
262     function executeTransaction(uint transactionId)
263         public
264         ownerExists(msg.sender)
265         confirmed(transactionId, msg.sender)
266         notExecuted(transactionId)
267     {
268         if (isConfirmed(transactionId)) {
269             Transaction storage txn = transactions[transactionId];
270             txn.executed = true;
271             if (txn.destination.call.value(txn.value)(txn.data))
272                 Execution(transactionId);
273             else {
274                 ExecutionFailure(transactionId);
275                 txn.executed = false;
276             }
277         }
278     }
279 
280     /// @dev Returns the confirmation status of a transaction.
281     /// @param transactionId Transaction ID.
282     /// @return Confirmation status.
283     function isConfirmed(uint transactionId)
284         public
285         constant
286         returns (bool)
287     {
288         uint count = 0;
289         for (uint i=0; i<owners.length; i++) {
290             if (confirmations[transactionId][owners[i]])
291                 count += 1;
292             if (count == required)
293                 return true;
294         }
295     }
296 
297     /*
298      * Internal functions
299      */
300     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
301     /// @param destination Transaction target address.
302     /// @param value Transaction ether value.
303     /// @param data Transaction data payload.
304     /// @return Returns transaction ID.
305     function addTransaction(address destination, uint value, bytes data)
306         internal
307         notNull(destination)
308         returns (uint transactionId)
309     {
310         transactionId = transactionCount;
311         transactions[transactionId] = Transaction({
312             destination: destination,
313             value: value,
314             data: data,
315             executed: false
316         });
317         transactionCount += 1;
318         Submission(transactionId);
319     }
320 
321     /*
322      * Web3 call functions
323      */
324     /// @dev Returns number of confirmations of a transaction.
325     /// @param transactionId Transaction ID.
326     /// @return Number of confirmations.
327     function getConfirmationCount(uint transactionId)
328         public
329         constant
330         returns (uint count)
331     {
332         for (uint i=0; i<owners.length; i++)
333             if (confirmations[transactionId][owners[i]])
334                 count += 1;
335     }
336 
337     /// @dev Returns total number of transactions after filers are applied.
338     /// @param pending Include pending transactions.
339     /// @param executed Include executed transactions.
340     /// @return Total number of transactions after filters are applied.
341     function getTransactionCount(bool pending, bool executed)
342         public
343         constant
344         returns (uint count)
345     {
346         for (uint i=0; i<transactionCount; i++)
347             if (   pending && !transactions[i].executed
348                 || executed && transactions[i].executed)
349                 count += 1;
350     }
351 
352     /// @dev Returns list of owners.
353     /// @return List of owner addresses.
354     function getOwners()
355         public
356         constant
357         returns (address[])
358     {
359         return owners;
360     }
361 
362     /// @dev Returns array with owner addresses, which confirmed transaction.
363     /// @param transactionId Transaction ID.
364     /// @return Returns array of owner addresses.
365     function getConfirmations(uint transactionId)
366         public
367         constant
368         returns (address[] _confirmations)
369     {
370         address[] memory confirmationsTemp = new address[](owners.length);
371         uint count = 0;
372         uint i;
373         for (i=0; i<owners.length; i++)
374             if (confirmations[transactionId][owners[i]]) {
375                 confirmationsTemp[count] = owners[i];
376                 count += 1;
377             }
378         _confirmations = new address[](count);
379         for (i=0; i<count; i++)
380             _confirmations[i] = confirmationsTemp[i];
381     }
382 
383     /// @dev Returns list of transaction IDs in defined range.
384     /// @param from Index start position of transaction array.
385     /// @param to Index end position of transaction array.
386     /// @param pending Include pending transactions.
387     /// @param executed Include executed transactions.
388     /// @return Returns array of transaction IDs.
389     function getTransactionIds(uint from, uint to, bool pending, bool executed)
390         public
391         constant
392         returns (uint[] _transactionIds)
393     {
394         uint[] memory transactionIdsTemp = new uint[](transactionCount);
395         uint count = 0;
396         uint i;
397         for (i=0; i<transactionCount; i++)
398             if (   pending && !transactions[i].executed
399                 || executed && transactions[i].executed)
400             {
401                 transactionIdsTemp[count] = i;
402                 count += 1;
403             }
404         _transactionIds = new uint[](to - from);
405         for (i=from; i<to; i++)
406             _transactionIds[i - from] = transactionIdsTemp[i];
407     }
408 }
409 
410 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
411 /// @author Stefan George - <stefan.george@consensys.net>
412 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
413 
414     /*
415      *  Events
416      */
417     event DailyLimitChange(uint dailyLimit);
418 
419     /*
420      *  Storage
421      */
422     uint public dailyLimit;
423     uint public lastDay;
424     uint public spentToday;
425 
426     /*
427      * Public functions
428      */
429     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
430     /// @param _owners List of initial owners.
431     /// @param _required Number of required confirmations.
432     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
433     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
434         public
435         MultiSigWallet(_owners, _required)
436     {
437         dailyLimit = _dailyLimit;
438     }
439 
440     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
441     /// @param _dailyLimit Amount in wei.
442     function changeDailyLimit(uint _dailyLimit)
443         public
444         onlyWallet
445     {
446         dailyLimit = _dailyLimit;
447         DailyLimitChange(_dailyLimit);
448     }
449 
450     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
451     /// @param transactionId Transaction ID.
452     function executeTransaction(uint transactionId)
453         public
454         ownerExists(msg.sender)
455         confirmed(transactionId, msg.sender)
456         notExecuted(transactionId)
457     {
458         Transaction storage txn = transactions[transactionId];
459         bool _confirmed = isConfirmed(transactionId);
460         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
461             txn.executed = true;
462             if (!_confirmed)
463                 spentToday += txn.value;
464             if (txn.destination.call.value(txn.value)(txn.data))
465                 Execution(transactionId);
466             else {
467                 ExecutionFailure(transactionId);
468                 txn.executed = false;
469                 if (!_confirmed)
470                     spentToday -= txn.value;
471             }
472         }
473     }
474 
475     /*
476      * Internal functions
477      */
478     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
479     /// @param amount Amount to withdraw.
480     /// @return Returns if amount is under daily limit.
481     function isUnderLimit(uint amount)
482         internal
483         returns (bool)
484     {
485         if (now > lastDay + 24 hours) {
486             lastDay = now;
487             spentToday = 0;
488         }
489         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
490             return false;
491         return true;
492     }
493 
494     /*
495      * Web3 call functions
496      */
497     /// @dev Returns maximum withdraw amount.
498     /// @return Returns amount.
499     function calcMaxWithdraw()
500         public
501         constant
502         returns (uint)
503     {
504         if (now > lastDay + 24 hours)
505             return dailyLimit;
506         if (dailyLimit < spentToday)
507             return 0;
508         return dailyLimit - spentToday;
509     }
510 }
1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-05
3 */
4 
5 contract Factory {
6 
7     /*
8      *  Events
9      */
10     event ContractInstantiation(address sender, address instantiation);
11 
12     /*
13      *  Storage
14      */
15     mapping(address => bool) public isInstantiation;
16     mapping(address => address[]) public instantiations;
17 
18     /*
19      * Public functions
20      */
21     /// @dev Returns number of instantiations by creator.
22     /// @param creator Contract creator.
23     /// @return Returns number of instantiations by creator.
24     function getInstantiationCount(address creator)
25         public
26         constant
27         returns (uint)
28     {
29         return instantiations[creator].length;
30     }
31 
32     /*
33      * Internal functions
34      */
35     /// @dev Registers contract in factory registry.
36     /// @param instantiation Address of contract instantiation.
37     function register(address instantiation)
38         internal
39     {
40         isInstantiation[instantiation] = true;
41         instantiations[msg.sender].push(instantiation);
42         ContractInstantiation(msg.sender, instantiation);
43     }
44 }
45 
46 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
47 /// @author Stefan George - <stefan.george@consensys.net>
48 contract MultiSigWallet {
49 
50     /*
51      *  Events
52      */
53     event Confirmation(address indexed sender, uint indexed transactionId);
54     event Revocation(address indexed sender, uint indexed transactionId);
55     event Submission(uint indexed transactionId);
56     event Execution(uint indexed transactionId);
57     event ExecutionFailure(uint indexed transactionId);
58     event Deposit(address indexed sender, uint value);
59     event OwnerAddition(address indexed owner);
60     event OwnerRemoval(address indexed owner);
61     event RequirementChange(uint required);
62 
63     /*
64      *  Constants
65      */
66     uint constant public MAX_OWNER_COUNT = 50;
67 
68     /*
69      *  Storage
70      */
71     mapping (uint => Transaction) public transactions;
72     mapping (uint => mapping (address => bool)) public confirmations;
73     mapping (address => bool) public isOwner;
74     address[] public owners;
75     uint public required;
76     uint public transactionCount;
77 
78     struct Transaction {
79         address destination;
80         uint value;
81         bytes data;
82         bool executed;
83     }
84 
85     /*
86      *  Modifiers
87      */
88     modifier onlyWallet() {
89         require(msg.sender == address(this));
90         _;
91     }
92 
93     modifier ownerDoesNotExist(address owner) {
94         require(!isOwner[owner]);
95         _;
96     }
97 
98     modifier ownerExists(address owner) {
99         require(isOwner[owner]);
100         _;
101     }
102 
103     modifier transactionExists(uint transactionId) {
104         require(transactions[transactionId].destination != 0);
105         _;
106     }
107 
108     modifier confirmed(uint transactionId, address owner) {
109         require(confirmations[transactionId][owner]);
110         _;
111     }
112 
113     modifier notConfirmed(uint transactionId, address owner) {
114         require(!confirmations[transactionId][owner]);
115         _;
116     }
117 
118     modifier notExecuted(uint transactionId) {
119         require(!transactions[transactionId].executed);
120         _;
121     }
122 
123     modifier notNull(address _address) {
124         require(_address != 0);
125         _;
126     }
127 
128     modifier validRequirement(uint ownerCount, uint _required) {
129         require(ownerCount <= MAX_OWNER_COUNT
130             && _required <= ownerCount
131             && _required != 0
132             && ownerCount != 0);
133         _;
134     }
135 
136     /// @dev Fallback function allows to deposit ether.
137     function()
138         payable
139     {
140         if (msg.value > 0)
141             Deposit(msg.sender, msg.value);
142     }
143 
144     /*
145      * Public functions
146      */
147     /// @dev Contract constructor sets initial owners and required number of confirmations.
148     /// @param _owners List of initial owners.
149     /// @param _required Number of required confirmations.
150     function MultiSigWallet(address[] _owners, uint _required)
151         public
152         validRequirement(_owners.length, _required)
153     {
154         for (uint i=0; i<_owners.length; i++) {
155             require(!isOwner[_owners[i]] && _owners[i] != 0);
156             isOwner[_owners[i]] = true;
157         }
158         owners = _owners;
159         required = _required;
160     }
161 
162     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
163     /// @param owner Address of new owner.
164     function addOwner(address owner)
165         public
166         onlyWallet
167         ownerDoesNotExist(owner)
168         notNull(owner)
169         validRequirement(owners.length + 1, required)
170     {
171         isOwner[owner] = true;
172         owners.push(owner);
173         OwnerAddition(owner);
174     }
175 
176     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
177     /// @param owner Address of owner.
178     function removeOwner(address owner)
179         public
180         onlyWallet
181         ownerExists(owner)
182     {
183         isOwner[owner] = false;
184         for (uint i=0; i<owners.length - 1; i++)
185             if (owners[i] == owner) {
186                 owners[i] = owners[owners.length - 1];
187                 break;
188             }
189         owners.length -= 1;
190         if (required > owners.length)
191             changeRequirement(owners.length);
192         OwnerRemoval(owner);
193     }
194 
195     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
196     /// @param owner Address of owner to be replaced.
197     /// @param newOwner Address of new owner.
198     function replaceOwner(address owner, address newOwner)
199         public
200         onlyWallet
201         ownerExists(owner)
202         ownerDoesNotExist(newOwner)
203     {
204         for (uint i=0; i<owners.length; i++)
205             if (owners[i] == owner) {
206                 owners[i] = newOwner;
207                 break;
208             }
209         isOwner[owner] = false;
210         isOwner[newOwner] = true;
211         OwnerRemoval(owner);
212         OwnerAddition(newOwner);
213     }
214 
215     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
216     /// @param _required Number of required confirmations.
217     function changeRequirement(uint _required)
218         public
219         onlyWallet
220         validRequirement(owners.length, _required)
221     {
222         required = _required;
223         RequirementChange(_required);
224     }
225 
226     /// @dev Allows an owner to submit and confirm a transaction.
227     /// @param destination Transaction target address.
228     /// @param value Transaction ether value.
229     /// @param data Transaction data payload.
230     /// @return Returns transaction ID.
231     function submitTransaction(address destination, uint value, bytes data)
232         public
233         returns (uint transactionId)
234     {
235         transactionId = addTransaction(destination, value, data);
236         confirmTransaction(transactionId);
237     }
238 
239     /// @dev Allows an owner to confirm a transaction.
240     /// @param transactionId Transaction ID.
241     function confirmTransaction(uint transactionId)
242         public
243         ownerExists(msg.sender)
244         transactionExists(transactionId)
245         notConfirmed(transactionId, msg.sender)
246     {
247         confirmations[transactionId][msg.sender] = true;
248         Confirmation(msg.sender, transactionId);
249         executeTransaction(transactionId);
250     }
251 
252     /// @dev Allows an owner to revoke a confirmation for a transaction.
253     /// @param transactionId Transaction ID.
254     function revokeConfirmation(uint transactionId)
255         public
256         ownerExists(msg.sender)
257         confirmed(transactionId, msg.sender)
258         notExecuted(transactionId)
259     {
260         confirmations[transactionId][msg.sender] = false;
261         Revocation(msg.sender, transactionId);
262     }
263 
264     /// @dev Allows anyone to execute a confirmed transaction.
265     /// @param transactionId Transaction ID.
266     function executeTransaction(uint transactionId)
267         public
268         ownerExists(msg.sender)
269         confirmed(transactionId, msg.sender)
270         notExecuted(transactionId)
271     {
272         if (isConfirmed(transactionId)) {
273             Transaction storage txn = transactions[transactionId];
274             txn.executed = true;
275             if (txn.destination.call.value(txn.value)(txn.data))
276                 Execution(transactionId);
277             else {
278                 ExecutionFailure(transactionId);
279                 txn.executed = false;
280             }
281         }
282     }
283 
284     /// @dev Returns the confirmation status of a transaction.
285     /// @param transactionId Transaction ID.
286     /// @return Confirmation status.
287     function isConfirmed(uint transactionId)
288         public
289         constant
290         returns (bool)
291     {
292         uint count = 0;
293         for (uint i=0; i<owners.length; i++) {
294             if (confirmations[transactionId][owners[i]])
295                 count += 1;
296             if (count == required)
297                 return true;
298         }
299     }
300 
301     /*
302      * Internal functions
303      */
304     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
305     /// @param destination Transaction target address.
306     /// @param value Transaction ether value.
307     /// @param data Transaction data payload.
308     /// @return Returns transaction ID.
309     function addTransaction(address destination, uint value, bytes data)
310         internal
311         notNull(destination)
312         returns (uint transactionId)
313     {
314         transactionId = transactionCount;
315         transactions[transactionId] = Transaction({
316             destination: destination,
317             value: value,
318             data: data,
319             executed: false
320         });
321         transactionCount += 1;
322         Submission(transactionId);
323     }
324 
325     /*
326      * Web3 call functions
327      */
328     /// @dev Returns number of confirmations of a transaction.
329     /// @param transactionId Transaction ID.
330     /// @return Number of confirmations.
331     function getConfirmationCount(uint transactionId)
332         public
333         constant
334         returns (uint count)
335     {
336         for (uint i=0; i<owners.length; i++)
337             if (confirmations[transactionId][owners[i]])
338                 count += 1;
339     }
340 
341     /// @dev Returns total number of transactions after filers are applied.
342     /// @param pending Include pending transactions.
343     /// @param executed Include executed transactions.
344     /// @return Total number of transactions after filters are applied.
345     function getTransactionCount(bool pending, bool executed)
346         public
347         constant
348         returns (uint count)
349     {
350         for (uint i=0; i<transactionCount; i++)
351             if (   pending && !transactions[i].executed
352                 || executed && transactions[i].executed)
353                 count += 1;
354     }
355 
356     /// @dev Returns list of owners.
357     /// @return List of owner addresses.
358     function getOwners()
359         public
360         constant
361         returns (address[])
362     {
363         return owners;
364     }
365 
366     /// @dev Returns array with owner addresses, which confirmed transaction.
367     /// @param transactionId Transaction ID.
368     /// @return Returns array of owner addresses.
369     function getConfirmations(uint transactionId)
370         public
371         constant
372         returns (address[] _confirmations)
373     {
374         address[] memory confirmationsTemp = new address[](owners.length);
375         uint count = 0;
376         uint i;
377         for (i=0; i<owners.length; i++)
378             if (confirmations[transactionId][owners[i]]) {
379                 confirmationsTemp[count] = owners[i];
380                 count += 1;
381             }
382         _confirmations = new address[](count);
383         for (i=0; i<count; i++)
384             _confirmations[i] = confirmationsTemp[i];
385     }
386 
387     /// @dev Returns list of transaction IDs in defined range.
388     /// @param from Index start position of transaction array.
389     /// @param to Index end position of transaction array.
390     /// @param pending Include pending transactions.
391     /// @param executed Include executed transactions.
392     /// @return Returns array of transaction IDs.
393     function getTransactionIds(uint from, uint to, bool pending, bool executed)
394         public
395         constant
396         returns (uint[] _transactionIds)
397     {
398         uint[] memory transactionIdsTemp = new uint[](transactionCount);
399         uint count = 0;
400         uint i;
401         for (i=0; i<transactionCount; i++)
402             if (   pending && !transactions[i].executed
403                 || executed && transactions[i].executed)
404             {
405                 transactionIdsTemp[count] = i;
406                 count += 1;
407             }
408         _transactionIds = new uint[](to - from);
409         for (i=from; i<to; i++)
410             _transactionIds[i - from] = transactionIdsTemp[i];
411     }
412 }
413 
414 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
415 /// @author Stefan George - <stefan.george@consensys.net>
416 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
417 
418     /*
419      *  Events
420      */
421     event DailyLimitChange(uint dailyLimit);
422 
423     /*
424      *  Storage
425      */
426     uint public dailyLimit;
427     uint public lastDay;
428     uint public spentToday;
429 
430     /*
431      * Public functions
432      */
433     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
434     /// @param _owners List of initial owners.
435     /// @param _required Number of required confirmations.
436     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
437     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
438         public
439         MultiSigWallet(_owners, _required)
440     {
441         dailyLimit = _dailyLimit;
442     }
443 
444     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
445     /// @param _dailyLimit Amount in wei.
446     function changeDailyLimit(uint _dailyLimit)
447         public
448         onlyWallet
449     {
450         dailyLimit = _dailyLimit;
451         DailyLimitChange(_dailyLimit);
452     }
453 
454     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
455     /// @param transactionId Transaction ID.
456     function executeTransaction(uint transactionId)
457         public
458         ownerExists(msg.sender)
459         confirmed(transactionId, msg.sender)
460         notExecuted(transactionId)
461     {
462         Transaction storage txn = transactions[transactionId];
463         bool _confirmed = isConfirmed(transactionId);
464         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
465             txn.executed = true;
466             if (!_confirmed)
467                 spentToday += txn.value;
468             if (txn.destination.call.value(txn.value)(txn.data))
469                 Execution(transactionId);
470             else {
471                 ExecutionFailure(transactionId);
472                 txn.executed = false;
473                 if (!_confirmed)
474                     spentToday -= txn.value;
475             }
476         }
477     }
478 
479     /*
480      * Internal functions
481      */
482     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
483     /// @param amount Amount to withdraw.
484     /// @return Returns if amount is under daily limit.
485     function isUnderLimit(uint amount)
486         internal
487         returns (bool)
488     {
489         if (now > lastDay + 24 hours) {
490             lastDay = now;
491             spentToday = 0;
492         }
493         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
494             return false;
495         return true;
496     }
497 
498     /*
499      * Web3 call functions
500      */
501     /// @dev Returns maximum withdraw amount.
502     /// @return Returns amount.
503     function calcMaxWithdraw()
504         public
505         constant
506         returns (uint)
507     {
508         if (now > lastDay + 24 hours)
509             return dailyLimit;
510         if (dailyLimit < spentToday)
511             return 0;
512         return dailyLimit - spentToday;
513     }
514 }
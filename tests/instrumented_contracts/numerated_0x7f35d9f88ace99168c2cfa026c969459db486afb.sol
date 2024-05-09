1 pragma solidity ^0.4.15;
2 
3 contract Factory {
4 
5     /*
6      *  Events
7      */
8     event ContractInstantiation(address sender, address instantiation);
9 
10     /*
11      *  Storage
12      */
13     mapping(address => bool) public isInstantiation;
14     mapping(address => address[]) public instantiations;
15 
16     /*
17      * Public functions
18      */
19     /// @dev Returns number of instantiations by creator.
20     /// @param creator Contract creator.
21     /// @return Returns number of instantiations by creator.
22     function getInstantiationCount(address creator)
23         public
24         constant
25         returns (uint)
26     {
27         return instantiations[creator].length;
28     }
29 
30     /*
31      * Internal functions
32      */
33     /// @dev Registers contract in factory registry.
34     /// @param instantiation Address of contract instantiation.
35     function register(address instantiation)
36         internal
37     {
38         isInstantiation[instantiation] = true;
39         instantiations[msg.sender].push(instantiation);
40         ContractInstantiation(msg.sender, instantiation);
41     }
42 }
43 
44 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
45 /// @author Stefan George - <stefan.george@consensys.net>
46 contract MultiSigWallet {
47 
48     /*
49      *  Events
50      */
51     event Confirmation(address indexed sender, uint indexed transactionId);
52     event Revocation(address indexed sender, uint indexed transactionId);
53     event Submission(uint indexed transactionId);
54     event Execution(uint indexed transactionId);
55     event ExecutionFailure(uint indexed transactionId);
56     event Deposit(address indexed sender, uint value);
57     event OwnerAddition(address indexed owner);
58     event OwnerRemoval(address indexed owner);
59     event RequirementChange(uint required);
60 
61     /*
62      *  Constants
63      */
64     uint constant public MAX_OWNER_COUNT = 50;
65 
66     /*
67      *  Storage
68      */
69     mapping (uint => Transaction) public transactions;
70     mapping (uint => mapping (address => bool)) public confirmations;
71     mapping (address => bool) public isOwner;
72     address[] public owners;
73     uint public required;
74     uint public transactionCount;
75 
76     struct Transaction {
77         address destination;
78         uint value;
79         bytes data;
80         bool executed;
81     }
82 
83     /*
84      *  Modifiers
85      */
86     modifier onlyWallet() {
87         require(msg.sender == address(this));
88         _;
89     }
90 
91     modifier ownerDoesNotExist(address owner) {
92         require(!isOwner[owner]);
93         _;
94     }
95 
96     modifier ownerExists(address owner) {
97         require(isOwner[owner]);
98         _;
99     }
100 
101     modifier transactionExists(uint transactionId) {
102         require(transactions[transactionId].destination != 0);
103         _;
104     }
105 
106     modifier confirmed(uint transactionId, address owner) {
107         require(confirmations[transactionId][owner]);
108         _;
109     }
110 
111     modifier notConfirmed(uint transactionId, address owner) {
112         require(!confirmations[transactionId][owner]);
113         _;
114     }
115 
116     modifier notExecuted(uint transactionId) {
117         require(!transactions[transactionId].executed);
118         _;
119     }
120 
121     modifier notNull(address _address) {
122         require(_address != 0);
123         _;
124     }
125 
126     modifier validRequirement(uint ownerCount, uint _required) {
127         require(ownerCount <= MAX_OWNER_COUNT
128             && _required <= ownerCount
129             && _required != 0
130             && ownerCount != 0);
131         _;
132     }
133 
134     /// @dev Fallback function allows to deposit ether.
135     function()
136         payable
137     {
138         if (msg.value > 0)
139             Deposit(msg.sender, msg.value);
140     }
141 
142     /*
143      * Public functions
144      */
145     /// @dev Contract constructor sets initial owners and required number of confirmations.
146     /// @param _owners List of initial owners.
147     /// @param _required Number of required confirmations.
148     function MultiSigWallet(address[] _owners, uint _required)
149         public
150         validRequirement(_owners.length, _required)
151     {
152         for (uint i=0; i<_owners.length; i++) {
153             require(!isOwner[_owners[i]] && _owners[i] != 0);
154             isOwner[_owners[i]] = true;
155         }
156         owners = _owners;
157         required = _required;
158     }
159 
160     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
161     /// @param owner Address of new owner.
162     function addOwner(address owner)
163         public
164         onlyWallet
165         ownerDoesNotExist(owner)
166         notNull(owner)
167         validRequirement(owners.length + 1, required)
168     {
169         isOwner[owner] = true;
170         owners.push(owner);
171         OwnerAddition(owner);
172     }
173 
174     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
175     /// @param owner Address of owner.
176     function removeOwner(address owner)
177         public
178         onlyWallet
179         ownerExists(owner)
180     {
181         isOwner[owner] = false;
182         for (uint i=0; i<owners.length - 1; i++)
183             if (owners[i] == owner) {
184                 owners[i] = owners[owners.length - 1];
185                 break;
186             }
187         owners.length -= 1;
188         if (required > owners.length)
189             changeRequirement(owners.length);
190         OwnerRemoval(owner);
191     }
192 
193     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
194     /// @param owner Address of owner to be replaced.
195     /// @param newOwner Address of new owner.
196     function replaceOwner(address owner, address newOwner)
197         public
198         onlyWallet
199         ownerExists(owner)
200         ownerDoesNotExist(newOwner)
201     {
202         for (uint i=0; i<owners.length; i++)
203             if (owners[i] == owner) {
204                 owners[i] = newOwner;
205                 break;
206             }
207         isOwner[owner] = false;
208         isOwner[newOwner] = true;
209         OwnerRemoval(owner);
210         OwnerAddition(newOwner);
211     }
212 
213     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
214     /// @param _required Number of required confirmations.
215     function changeRequirement(uint _required)
216         public
217         onlyWallet
218         validRequirement(owners.length, _required)
219     {
220         required = _required;
221         RequirementChange(_required);
222     }
223 
224     /// @dev Allows an owner to submit and confirm a transaction.
225     /// @param destination Transaction target address.
226     /// @param value Transaction ether value.
227     /// @param data Transaction data payload.
228     /// @return Returns transaction ID.
229     function submitTransaction(address destination, uint value, bytes data)
230         public
231         returns (uint transactionId)
232     {
233         transactionId = addTransaction(destination, value, data);
234         confirmTransaction(transactionId);
235     }
236 
237     /// @dev Allows an owner to confirm a transaction.
238     /// @param transactionId Transaction ID.
239     function confirmTransaction(uint transactionId)
240         public
241         ownerExists(msg.sender)
242         transactionExists(transactionId)
243         notConfirmed(transactionId, msg.sender)
244     {
245         confirmations[transactionId][msg.sender] = true;
246         Confirmation(msg.sender, transactionId);
247         executeTransaction(transactionId);
248     }
249 
250     /// @dev Allows an owner to revoke a confirmation for a transaction.
251     /// @param transactionId Transaction ID.
252     function revokeConfirmation(uint transactionId)
253         public
254         ownerExists(msg.sender)
255         confirmed(transactionId, msg.sender)
256         notExecuted(transactionId)
257     {
258         confirmations[transactionId][msg.sender] = false;
259         Revocation(msg.sender, transactionId);
260     }
261 
262     /// @dev Allows anyone to execute a confirmed transaction.
263     /// @param transactionId Transaction ID.
264     function executeTransaction(uint transactionId)
265         public
266         ownerExists(msg.sender)
267         confirmed(transactionId, msg.sender)
268         notExecuted(transactionId)
269     {
270         if (isConfirmed(transactionId)) {
271             Transaction storage txn = transactions[transactionId];
272             txn.executed = true;
273             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
274                 Execution(transactionId);
275             else {
276                 ExecutionFailure(transactionId);
277                 txn.executed = false;
278             }
279         }
280     }
281 
282     // call has been separated into its own function in order to take advantage
283     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
284     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
285         bool result;
286         assembly {
287             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
288             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
289             result := call(
290                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
291                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
292                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
293                 destination,
294                 value,
295                 d,
296                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
297                 x,
298                 0                  // Output is ignored, therefore the output size is zero
299             )
300         }
301         return result;
302     }
303 
304     /// @dev Returns the confirmation status of a transaction.
305     /// @param transactionId Transaction ID.
306     /// @return Confirmation status.
307     function isConfirmed(uint transactionId)
308         public
309         constant
310         returns (bool)
311     {
312         uint count = 0;
313         for (uint i=0; i<owners.length; i++) {
314             if (confirmations[transactionId][owners[i]])
315                 count += 1;
316             if (count == required)
317                 return true;
318         }
319     }
320 
321     /*
322      * Internal functions
323      */
324     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
325     /// @param destination Transaction target address.
326     /// @param value Transaction ether value.
327     /// @param data Transaction data payload.
328     /// @return Returns transaction ID.
329     function addTransaction(address destination, uint value, bytes data)
330         internal
331         notNull(destination)
332         returns (uint transactionId)
333     {
334         transactionId = transactionCount;
335         transactions[transactionId] = Transaction({
336             destination: destination,
337             value: value,
338             data: data,
339             executed: false
340         });
341         transactionCount += 1;
342         Submission(transactionId);
343     }
344 
345     /*
346      * Web3 call functions
347      */
348     /// @dev Returns number of confirmations of a transaction.
349     /// @param transactionId Transaction ID.
350     /// @return Number of confirmations.
351     function getConfirmationCount(uint transactionId)
352         public
353         constant
354         returns (uint count)
355     {
356         for (uint i=0; i<owners.length; i++)
357             if (confirmations[transactionId][owners[i]])
358                 count += 1;
359     }
360 
361     /// @dev Returns total number of transactions after filers are applied.
362     /// @param pending Include pending transactions.
363     /// @param executed Include executed transactions.
364     /// @return Total number of transactions after filters are applied.
365     function getTransactionCount(bool pending, bool executed)
366         public
367         constant
368         returns (uint count)
369     {
370         for (uint i=0; i<transactionCount; i++)
371             if (   pending && !transactions[i].executed
372                 || executed && transactions[i].executed)
373                 count += 1;
374     }
375 
376     /// @dev Returns list of owners.
377     /// @return List of owner addresses.
378     function getOwners()
379         public
380         constant
381         returns (address[])
382     {
383         return owners;
384     }
385 
386     /// @dev Returns array with owner addresses, which confirmed transaction.
387     /// @param transactionId Transaction ID.
388     /// @return Returns array of owner addresses.
389     function getConfirmations(uint transactionId)
390         public
391         constant
392         returns (address[] _confirmations)
393     {
394         address[] memory confirmationsTemp = new address[](owners.length);
395         uint count = 0;
396         uint i;
397         for (i=0; i<owners.length; i++)
398             if (confirmations[transactionId][owners[i]]) {
399                 confirmationsTemp[count] = owners[i];
400                 count += 1;
401             }
402         _confirmations = new address[](count);
403         for (i=0; i<count; i++)
404             _confirmations[i] = confirmationsTemp[i];
405     }
406 
407     /// @dev Returns list of transaction IDs in defined range.
408     /// @param from Index start position of transaction array.
409     /// @param to Index end position of transaction array.
410     /// @param pending Include pending transactions.
411     /// @param executed Include executed transactions.
412     /// @return Returns array of transaction IDs.
413     function getTransactionIds(uint from, uint to, bool pending, bool executed)
414         public
415         constant
416         returns (uint[] _transactionIds)
417     {
418         uint[] memory transactionIdsTemp = new uint[](transactionCount);
419         uint count = 0;
420         uint i;
421         for (i=0; i<transactionCount; i++)
422             if (   pending && !transactions[i].executed
423                 || executed && transactions[i].executed)
424             {
425                 transactionIdsTemp[count] = i;
426                 count += 1;
427             }
428         _transactionIds = new uint[](to - from);
429         for (i=from; i<to; i++)
430             _transactionIds[i - from] = transactionIdsTemp[i];
431     }
432 }
433 
434 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
435 /// @author Stefan George - <stefan.george@consensys.net>
436 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
437 
438     /*
439      *  Events
440      */
441     event DailyLimitChange(uint dailyLimit);
442 
443     /*
444      *  Storage
445      */
446     uint public dailyLimit;
447     uint public lastDay;
448     uint public spentToday;
449 
450     /*
451      * Public functions
452      */
453     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
454     /// @param _owners List of initial owners.
455     /// @param _required Number of required confirmations.
456     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
457     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
458         public
459         MultiSigWallet(_owners, _required)
460     {
461         dailyLimit = _dailyLimit;
462     }
463 
464     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
465     /// @param _dailyLimit Amount in wei.
466     function changeDailyLimit(uint _dailyLimit)
467         public
468         onlyWallet
469     {
470         dailyLimit = _dailyLimit;
471         DailyLimitChange(_dailyLimit);
472     }
473 
474     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
475     /// @param transactionId Transaction ID.
476     function executeTransaction(uint transactionId)
477         public
478         ownerExists(msg.sender)
479         confirmed(transactionId, msg.sender)
480         notExecuted(transactionId)
481     {
482         Transaction storage txn = transactions[transactionId];
483         bool _confirmed = isConfirmed(transactionId);
484         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
485             txn.executed = true;
486             if (!_confirmed)
487                 spentToday += txn.value;
488             if (txn.destination.call.value(txn.value)(txn.data))
489                 Execution(transactionId);
490             else {
491                 ExecutionFailure(transactionId);
492                 txn.executed = false;
493                 if (!_confirmed)
494                     spentToday -= txn.value;
495             }
496         }
497     }
498 
499     /*
500      * Internal functions
501      */
502     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
503     /// @param amount Amount to withdraw.
504     /// @return Returns if amount is under daily limit.
505     function isUnderLimit(uint amount)
506         internal
507         returns (bool)
508     {
509         if (now > lastDay + 24 hours) {
510             lastDay = now;
511             spentToday = 0;
512         }
513         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
514             return false;
515         return true;
516     }
517 
518     /*
519      * Web3 call functions
520      */
521     /// @dev Returns maximum withdraw amount.
522     /// @return Returns amount.
523     function calcMaxWithdraw()
524         public
525         constant
526         returns (uint)
527     {
528         if (now > lastDay + 24 hours)
529             return dailyLimit;
530         if (dailyLimit < spentToday)
531             return 0;
532         return dailyLimit - spentToday;
533     }
534 }
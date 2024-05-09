1 // iOWN Operations Administrative Gnosis Wallet
2 // https://www.iowntoken.com
3 // https://github.com/gnosis/MultiSigWallet
4 
5 // File: contracts/MultiSigWallet.sol
6 
7 pragma solidity ^0.4.15;
8 
9 
10 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
11 /// @author Stefan George - <stefan.george@consensys.net>
12 contract MultiSigWallet {
13 
14     /*
15      *  Events
16      */
17     event Confirmation(address indexed sender, uint indexed transactionId);
18     event Revocation(address indexed sender, uint indexed transactionId);
19     event Submission(uint indexed transactionId);
20     event Execution(uint indexed transactionId);
21     event ExecutionFailure(uint indexed transactionId);
22     event Deposit(address indexed sender, uint value);
23     event OwnerAddition(address indexed owner);
24     event OwnerRemoval(address indexed owner);
25     event RequirementChange(uint required);
26 
27     /*
28      *  Constants
29      */
30     uint constant public MAX_OWNER_COUNT = 50;
31 
32     /*
33      *  Storage
34      */
35     mapping (uint => Transaction) public transactions;
36     mapping (uint => mapping (address => bool)) public confirmations;
37     mapping (address => bool) public isOwner;
38     address[] public owners;
39     uint public required;
40     uint public transactionCount;
41 
42     struct Transaction {
43         address destination;
44         uint value;
45         bytes data;
46         bool executed;
47     }
48 
49     /*
50      *  Modifiers
51      */
52     modifier onlyWallet() {
53         require(msg.sender == address(this));
54         _;
55     }
56 
57     modifier ownerDoesNotExist(address owner) {
58         require(!isOwner[owner]);
59         _;
60     }
61 
62     modifier ownerExists(address owner) {
63         require(isOwner[owner]);
64         _;
65     }
66 
67     modifier transactionExists(uint transactionId) {
68         require(transactions[transactionId].destination != 0);
69         _;
70     }
71 
72     modifier confirmed(uint transactionId, address owner) {
73         require(confirmations[transactionId][owner]);
74         _;
75     }
76 
77     modifier notConfirmed(uint transactionId, address owner) {
78         require(!confirmations[transactionId][owner]);
79         _;
80     }
81 
82     modifier notExecuted(uint transactionId) {
83         require(!transactions[transactionId].executed);
84         _;
85     }
86 
87     modifier notNull(address _address) {
88         require(_address != 0);
89         _;
90     }
91 
92     modifier validRequirement(uint ownerCount, uint _required) {
93         require(ownerCount <= MAX_OWNER_COUNT
94             && _required <= ownerCount
95             && _required != 0
96             && ownerCount != 0);
97         _;
98     }
99 
100     /// @dev Fallback function allows to deposit ether.
101     function()
102         payable
103     {
104         if (msg.value > 0)
105             Deposit(msg.sender, msg.value);
106     }
107 
108     /*
109      * Public functions
110      */
111     /// @dev Contract constructor sets initial owners and required number of confirmations.
112     /// @param _owners List of initial owners.
113     /// @param _required Number of required confirmations.
114     function MultiSigWallet(address[] _owners, uint _required)
115         public
116         validRequirement(_owners.length, _required)
117     {
118         for (uint i=0; i<_owners.length; i++) {
119             require(!isOwner[_owners[i]] && _owners[i] != 0);
120             isOwner[_owners[i]] = true;
121         }
122         owners = _owners;
123         required = _required;
124     }
125 
126     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
127     /// @param owner Address of new owner.
128     function addOwner(address owner)
129         public
130         onlyWallet
131         ownerDoesNotExist(owner)
132         notNull(owner)
133         validRequirement(owners.length + 1, required)
134     {
135         isOwner[owner] = true;
136         owners.push(owner);
137         OwnerAddition(owner);
138     }
139 
140     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
141     /// @param owner Address of owner.
142     function removeOwner(address owner)
143         public
144         onlyWallet
145         ownerExists(owner)
146     {
147         isOwner[owner] = false;
148         for (uint i=0; i<owners.length - 1; i++)
149             if (owners[i] == owner) {
150                 owners[i] = owners[owners.length - 1];
151                 break;
152             }
153         owners.length -= 1;
154         if (required > owners.length)
155             changeRequirement(owners.length);
156         OwnerRemoval(owner);
157     }
158 
159     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
160     /// @param owner Address of owner to be replaced.
161     /// @param newOwner Address of new owner.
162     function replaceOwner(address owner, address newOwner)
163         public
164         onlyWallet
165         ownerExists(owner)
166         ownerDoesNotExist(newOwner)
167     {
168         for (uint i=0; i<owners.length; i++)
169             if (owners[i] == owner) {
170                 owners[i] = newOwner;
171                 break;
172             }
173         isOwner[owner] = false;
174         isOwner[newOwner] = true;
175         OwnerRemoval(owner);
176         OwnerAddition(newOwner);
177     }
178 
179     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
180     /// @param _required Number of required confirmations.
181     function changeRequirement(uint _required)
182         public
183         onlyWallet
184         validRequirement(owners.length, _required)
185     {
186         required = _required;
187         RequirementChange(_required);
188     }
189 
190     /// @dev Allows an owner to submit and confirm a transaction.
191     /// @param destination Transaction target address.
192     /// @param value Transaction ether value.
193     /// @param data Transaction data payload.
194     /// @return Returns transaction ID.
195     function submitTransaction(address destination, uint value, bytes data)
196         public
197         returns (uint transactionId)
198     {
199         transactionId = addTransaction(destination, value, data);
200         confirmTransaction(transactionId);
201     }
202 
203     /// @dev Allows an owner to confirm a transaction.
204     /// @param transactionId Transaction ID.
205     function confirmTransaction(uint transactionId)
206         public
207         ownerExists(msg.sender)
208         transactionExists(transactionId)
209         notConfirmed(transactionId, msg.sender)
210     {
211         confirmations[transactionId][msg.sender] = true;
212         Confirmation(msg.sender, transactionId);
213         executeTransaction(transactionId);
214     }
215 
216     /// @dev Allows an owner to revoke a confirmation for a transaction.
217     /// @param transactionId Transaction ID.
218     function revokeConfirmation(uint transactionId)
219         public
220         ownerExists(msg.sender)
221         confirmed(transactionId, msg.sender)
222         notExecuted(transactionId)
223     {
224         confirmations[transactionId][msg.sender] = false;
225         Revocation(msg.sender, transactionId);
226     }
227 
228     /// @dev Allows anyone to execute a confirmed transaction.
229     /// @param transactionId Transaction ID.
230     function executeTransaction(uint transactionId)
231         public
232         ownerExists(msg.sender)
233         confirmed(transactionId, msg.sender)
234         notExecuted(transactionId)
235     {
236         if (isConfirmed(transactionId)) {
237             Transaction storage txn = transactions[transactionId];
238             txn.executed = true;
239             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
240                 Execution(transactionId);
241             else {
242                 ExecutionFailure(transactionId);
243                 txn.executed = false;
244             }
245         }
246     }
247 
248     // call has been separated into its own function in order to take advantage
249     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
250     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
251         bool result;
252         assembly {
253             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
254             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
255             result := call(
256                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
257                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
258                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
259                 destination,
260                 value,
261                 d,
262                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
263                 x,
264                 0                  // Output is ignored, therefore the output size is zero
265             )
266         }
267         return result;
268     }
269 
270     /// @dev Returns the confirmation status of a transaction.
271     /// @param transactionId Transaction ID.
272     /// @return Confirmation status.
273     function isConfirmed(uint transactionId)
274         public
275         constant
276         returns (bool)
277     {
278         uint count = 0;
279         for (uint i=0; i<owners.length; i++) {
280             if (confirmations[transactionId][owners[i]])
281                 count += 1;
282             if (count == required)
283                 return true;
284         }
285     }
286 
287     /*
288      * Internal functions
289      */
290     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
291     /// @param destination Transaction target address.
292     /// @param value Transaction ether value.
293     /// @param data Transaction data payload.
294     /// @return Returns transaction ID.
295     function addTransaction(address destination, uint value, bytes data)
296         internal
297         notNull(destination)
298         returns (uint transactionId)
299     {
300         transactionId = transactionCount;
301         transactions[transactionId] = Transaction({
302             destination: destination,
303             value: value,
304             data: data,
305             executed: false
306         });
307         transactionCount += 1;
308         Submission(transactionId);
309     }
310 
311     /*
312      * Web3 call functions
313      */
314     /// @dev Returns number of confirmations of a transaction.
315     /// @param transactionId Transaction ID.
316     /// @return Number of confirmations.
317     function getConfirmationCount(uint transactionId)
318         public
319         constant
320         returns (uint count)
321     {
322         for (uint i=0; i<owners.length; i++)
323             if (confirmations[transactionId][owners[i]])
324                 count += 1;
325     }
326 
327     /// @dev Returns total number of transactions after filers are applied.
328     /// @param pending Include pending transactions.
329     /// @param executed Include executed transactions.
330     /// @return Total number of transactions after filters are applied.
331     function getTransactionCount(bool pending, bool executed)
332         public
333         constant
334         returns (uint count)
335     {
336         for (uint i=0; i<transactionCount; i++)
337             if (   pending && !transactions[i].executed
338                 || executed && transactions[i].executed)
339                 count += 1;
340     }
341 
342     /// @dev Returns list of owners.
343     /// @return List of owner addresses.
344     function getOwners()
345         public
346         constant
347         returns (address[])
348     {
349         return owners;
350     }
351 
352     /// @dev Returns array with owner addresses, which confirmed transaction.
353     /// @param transactionId Transaction ID.
354     /// @return Returns array of owner addresses.
355     function getConfirmations(uint transactionId)
356         public
357         constant
358         returns (address[] _confirmations)
359     {
360         address[] memory confirmationsTemp = new address[](owners.length);
361         uint count = 0;
362         uint i;
363         for (i=0; i<owners.length; i++)
364             if (confirmations[transactionId][owners[i]]) {
365                 confirmationsTemp[count] = owners[i];
366                 count += 1;
367             }
368         _confirmations = new address[](count);
369         for (i=0; i<count; i++)
370             _confirmations[i] = confirmationsTemp[i];
371     }
372 
373     /// @dev Returns list of transaction IDs in defined range.
374     /// @param from Index start position of transaction array.
375     /// @param to Index end position of transaction array.
376     /// @param pending Include pending transactions.
377     /// @param executed Include executed transactions.
378     /// @return Returns array of transaction IDs.
379     function getTransactionIds(uint from, uint to, bool pending, bool executed)
380         public
381         constant
382         returns (uint[] _transactionIds)
383     {
384         uint[] memory transactionIdsTemp = new uint[](transactionCount);
385         uint count = 0;
386         uint i;
387         for (i=0; i<transactionCount; i++)
388             if (   pending && !transactions[i].executed
389                 || executed && transactions[i].executed)
390             {
391                 transactionIdsTemp[count] = i;
392                 count += 1;
393             }
394         _transactionIds = new uint[](to - from);
395         for (i=from; i<to; i++)
396             _transactionIds[i - from] = transactionIdsTemp[i];
397     }
398 }
399 
400 // File: contracts/MultiSigWalletWithDailyLimit.sol
401 
402 pragma solidity ^0.4.15;
403 
404 
405 
406 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
407 /// @author Stefan George - <stefan.george@consensys.net>
408 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
409 
410     /*
411      *  Events
412      */
413     event DailyLimitChange(uint dailyLimit);
414 
415     /*
416      *  Storage
417      */
418     uint public dailyLimit;
419     uint public lastDay;
420     uint public spentToday;
421 
422     /*
423      * Public functions
424      */
425     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
426     /// @param _owners List of initial owners.
427     /// @param _required Number of required confirmations.
428     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
429     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
430         public
431         MultiSigWallet(_owners, _required)
432     {
433         dailyLimit = _dailyLimit;
434     }
435 
436     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
437     /// @param _dailyLimit Amount in wei.
438     function changeDailyLimit(uint _dailyLimit)
439         public
440         onlyWallet
441     {
442         dailyLimit = _dailyLimit;
443         DailyLimitChange(_dailyLimit);
444     }
445 
446     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
447     /// @param transactionId Transaction ID.
448     function executeTransaction(uint transactionId)
449         public
450         ownerExists(msg.sender)
451         confirmed(transactionId, msg.sender)
452         notExecuted(transactionId)
453     {
454         Transaction storage txn = transactions[transactionId];
455         bool _confirmed = isConfirmed(transactionId);
456         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
457             txn.executed = true;
458             if (!_confirmed)
459                 spentToday += txn.value;
460             if (txn.destination.call.value(txn.value)(txn.data))
461                 Execution(transactionId);
462             else {
463                 ExecutionFailure(transactionId);
464                 txn.executed = false;
465                 if (!_confirmed)
466                     spentToday -= txn.value;
467             }
468         }
469     }
470 
471     /*
472      * Internal functions
473      */
474     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
475     /// @param amount Amount to withdraw.
476     /// @return Returns if amount is under daily limit.
477     function isUnderLimit(uint amount)
478         internal
479         returns (bool)
480     {
481         if (now > lastDay + 24 hours) {
482             lastDay = now;
483             spentToday = 0;
484         }
485         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
486             return false;
487         return true;
488     }
489 
490     /*
491      * Web3 call functions
492      */
493     /// @dev Returns maximum withdraw amount.
494     /// @return Returns amount.
495     function calcMaxWithdraw()
496         public
497         constant
498         returns (uint)
499     {
500         if (now > lastDay + 24 hours)
501             return dailyLimit;
502         if (dailyLimit < spentToday)
503             return 0;
504         return dailyLimit - spentToday;
505     }
506 }
1 pragma solidity ^0.4.15;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /*
9      *  Events
10      */
11     event Confirmation(address indexed sender, uint indexed transactionId);
12     event Revocation(address indexed sender, uint indexed transactionId);
13     event Submission(uint indexed transactionId);
14     event Execution(uint indexed transactionId);
15     event ExecutionFailure(uint indexed transactionId);
16     event Deposit(address indexed sender, uint value);
17     event OwnerAddition(address indexed owner);
18     event OwnerRemoval(address indexed owner);
19     event RequirementChange(uint required);
20 
21     /*
22      *  Constants
23      */
24     uint constant public MAX_OWNER_COUNT = 50;
25 
26     /*
27      *  Storage
28      */
29     mapping (uint => Transaction) public transactions;
30     mapping (uint => mapping (address => bool)) public confirmations;
31     mapping (address => bool) public isOwner;
32     address[] public owners;
33     uint public required;
34     uint public transactionCount;
35 
36     struct Transaction {
37         address destination;
38         uint value;
39         bytes data;
40         bool executed;
41     }
42 
43     /*
44      *  Modifiers
45      */
46     modifier onlyWallet() {
47         require(msg.sender == address(this));
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         require(!isOwner[owner]);
53         _;
54     }
55 
56     modifier ownerExists(address owner) {
57         require(isOwner[owner]);
58         _;
59     }
60 
61     modifier transactionExists(uint transactionId) {
62         require(transactions[transactionId].destination != 0);
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         require(confirmations[transactionId][owner]);
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         require(!confirmations[transactionId][owner]);
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         require(!transactions[transactionId].executed);
78         _;
79     }
80 
81     modifier notNull(address _address) {
82         require(_address != 0);
83         _;
84     }
85 
86     modifier validRequirement(uint ownerCount, uint _required) {
87         require(ownerCount <= MAX_OWNER_COUNT
88             && _required <= ownerCount
89             && _required != 0
90             && ownerCount != 0);
91         _;
92     }
93 
94     /// @dev Fallback function allows to deposit ether.
95     function()
96         payable
97     {
98         if (msg.value > 0)
99             Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     function MultiSigWallet(address[] _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint i=0; i<_owners.length; i++) {
113             require(!isOwner[_owners[i]] && _owners[i] != 0);
114             isOwner[_owners[i]] = true;
115         }
116         owners = _owners;
117         required = _required;
118     }
119 
120     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121     /// @param owner Address of new owner.
122     function addOwner(address owner)
123         public
124         onlyWallet
125         ownerDoesNotExist(owner)
126         notNull(owner)
127         validRequirement(owners.length + 1, required)
128     {
129         isOwner[owner] = true;
130         owners.push(owner);
131         OwnerAddition(owner);
132     }
133 
134     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
135     /// @param owner Address of owner.
136     function removeOwner(address owner)
137         public
138         onlyWallet
139         ownerExists(owner)
140     {
141         isOwner[owner] = false;
142         for (uint i=0; i<owners.length - 1; i++)
143             if (owners[i] == owner) {
144                 owners[i] = owners[owners.length - 1];
145                 break;
146             }
147         owners.length -= 1;
148         if (required > owners.length)
149             changeRequirement(owners.length);
150         OwnerRemoval(owner);
151     }
152 
153     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
154     /// @param owner Address of owner to be replaced.
155     /// @param newOwner Address of new owner.
156     function replaceOwner(address owner, address newOwner)
157         public
158         onlyWallet
159         ownerExists(owner)
160         ownerDoesNotExist(newOwner)
161     {
162         for (uint i=0; i<owners.length; i++)
163             if (owners[i] == owner) {
164                 owners[i] = newOwner;
165                 break;
166             }
167         isOwner[owner] = false;
168         isOwner[newOwner] = true;
169         OwnerRemoval(owner);
170         OwnerAddition(newOwner);
171     }
172 
173     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
174     /// @param _required Number of required confirmations.
175     function changeRequirement(uint _required)
176         public
177         onlyWallet
178         validRequirement(owners.length, _required)
179     {
180         required = _required;
181         RequirementChange(_required);
182     }
183 
184     /// @dev Allows an owner to submit and confirm a transaction.
185     /// @param destination Transaction target address.
186     /// @param value Transaction ether value.
187     /// @param data Transaction data payload.
188     /// @return Returns transaction ID.
189     function submitTransaction(address destination, uint value, bytes data)
190         public
191         returns (uint transactionId)
192     {
193         transactionId = addTransaction(destination, value, data);
194         confirmTransaction(transactionId);
195     }
196 
197     /// @dev Allows an owner to confirm a transaction.
198     /// @param transactionId Transaction ID.
199     function confirmTransaction(uint transactionId)
200         public
201         ownerExists(msg.sender)
202         transactionExists(transactionId)
203         notConfirmed(transactionId, msg.sender)
204     {
205         confirmations[transactionId][msg.sender] = true;
206         Confirmation(msg.sender, transactionId);
207         executeTransaction(transactionId);
208     }
209 
210     /// @dev Allows an owner to revoke a confirmation for a transaction.
211     /// @param transactionId Transaction ID.
212     function revokeConfirmation(uint transactionId)
213         public
214         ownerExists(msg.sender)
215         confirmed(transactionId, msg.sender)
216         notExecuted(transactionId)
217     {
218         confirmations[transactionId][msg.sender] = false;
219         Revocation(msg.sender, transactionId);
220     }
221 
222     /// @dev Allows anyone to execute a confirmed transaction.
223     /// @param transactionId Transaction ID.
224     function executeTransaction(uint transactionId)
225         public
226         ownerExists(msg.sender)
227         confirmed(transactionId, msg.sender)
228         notExecuted(transactionId)
229     {
230         if (isConfirmed(transactionId)) {
231             Transaction storage txn = transactions[transactionId];
232             txn.executed = true;
233             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
234                 Execution(transactionId);
235             else {
236                 ExecutionFailure(transactionId);
237                 txn.executed = false;
238             }
239         }
240     }
241 
242     // call has been separated into its own function in order to take advantage
243     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
244     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
245         bool result;
246         assembly {
247             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
248             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
249             result := call(
250                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
251                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
252                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
253                 destination,
254                 value,
255                 d,
256                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
257                 x,
258                 0                  // Output is ignored, therefore the output size is zero
259             )
260         }
261         return result;
262     }
263 
264     /// @dev Returns the confirmation status of a transaction.
265     /// @param transactionId Transaction ID.
266     /// @return Confirmation status.
267     function isConfirmed(uint transactionId)
268         public
269         constant
270         returns (bool)
271     {
272         uint count = 0;
273         for (uint i=0; i<owners.length; i++) {
274             if (confirmations[transactionId][owners[i]])
275                 count += 1;
276             if (count == required)
277                 return true;
278         }
279     }
280 
281     /*
282      * Internal functions
283      */
284     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
285     /// @param destination Transaction target address.
286     /// @param value Transaction ether value.
287     /// @param data Transaction data payload.
288     /// @return Returns transaction ID.
289     function addTransaction(address destination, uint value, bytes data)
290         internal
291         notNull(destination)
292         returns (uint transactionId)
293     {
294         transactionId = transactionCount;
295         transactions[transactionId] = Transaction({
296             destination: destination,
297             value: value,
298             data: data,
299             executed: false
300         });
301         transactionCount += 1;
302         Submission(transactionId);
303     }
304 
305     /*
306      * Web3 call functions
307      */
308     /// @dev Returns number of confirmations of a transaction.
309     /// @param transactionId Transaction ID.
310     /// @return Number of confirmations.
311     function getConfirmationCount(uint transactionId)
312         public
313         constant
314         returns (uint count)
315     {
316         for (uint i=0; i<owners.length; i++)
317             if (confirmations[transactionId][owners[i]])
318                 count += 1;
319     }
320 
321     /// @dev Returns total number of transactions after filers are applied.
322     /// @param pending Include pending transactions.
323     /// @param executed Include executed transactions.
324     /// @return Total number of transactions after filters are applied.
325     function getTransactionCount(bool pending, bool executed)
326         public
327         constant
328         returns (uint count)
329     {
330         for (uint i=0; i<transactionCount; i++)
331             if (   pending && !transactions[i].executed
332                 || executed && transactions[i].executed)
333                 count += 1;
334     }
335 
336     /// @dev Returns list of owners.
337     /// @return List of owner addresses.
338     function getOwners()
339         public
340         constant
341         returns (address[])
342     {
343         return owners;
344     }
345 
346     /// @dev Returns array with owner addresses, which confirmed transaction.
347     /// @param transactionId Transaction ID.
348     /// @return Returns array of owner addresses.
349     function getConfirmations(uint transactionId)
350         public
351         constant
352         returns (address[] _confirmations)
353     {
354         address[] memory confirmationsTemp = new address[](owners.length);
355         uint count = 0;
356         uint i;
357         for (i=0; i<owners.length; i++)
358             if (confirmations[transactionId][owners[i]]) {
359                 confirmationsTemp[count] = owners[i];
360                 count += 1;
361             }
362         _confirmations = new address[](count);
363         for (i=0; i<count; i++)
364             _confirmations[i] = confirmationsTemp[i];
365     }
366 
367     /// @dev Returns list of transaction IDs in defined range.
368     /// @param from Index start position of transaction array.
369     /// @param to Index end position of transaction array.
370     /// @param pending Include pending transactions.
371     /// @param executed Include executed transactions.
372     /// @return Returns array of transaction IDs.
373     function getTransactionIds(uint from, uint to, bool pending, bool executed)
374         public
375         constant
376         returns (uint[] _transactionIds)
377     {
378         uint[] memory transactionIdsTemp = new uint[](transactionCount);
379         uint count = 0;
380         uint i;
381         for (i=0; i<transactionCount; i++)
382             if (   pending && !transactions[i].executed
383                 || executed && transactions[i].executed)
384             {
385                 transactionIdsTemp[count] = i;
386                 count += 1;
387             }
388         _transactionIds = new uint[](to - from);
389         for (i=from; i<to; i++)
390             _transactionIds[i - from] = transactionIdsTemp[i];
391     }
392 }
393 
394 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
395 /// @author Stefan George - <stefan.george@consensys.net>
396 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
397 
398     /*
399      *  Events
400      */
401     event DailyLimitChange(uint dailyLimit);
402 
403     /*
404      *  Storage
405      */
406     uint public dailyLimit;
407     uint public lastDay;
408     uint public spentToday;
409 
410     /*
411      * Public functions
412      */
413     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
414     /// @param _owners List of initial owners.
415     /// @param _required Number of required confirmations.
416     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
417     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
418         public
419         MultiSigWallet(_owners, _required)
420     {
421         dailyLimit = _dailyLimit;
422     }
423 
424     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
425     /// @param _dailyLimit Amount in wei.
426     function changeDailyLimit(uint _dailyLimit)
427         public
428         onlyWallet
429     {
430         dailyLimit = _dailyLimit;
431         DailyLimitChange(_dailyLimit);
432     }
433 
434     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
435     /// @param transactionId Transaction ID.
436     function executeTransaction(uint transactionId)
437         public
438         ownerExists(msg.sender)
439         confirmed(transactionId, msg.sender)
440         notExecuted(transactionId)
441     {
442         Transaction storage txn = transactions[transactionId];
443         bool _confirmed = isConfirmed(transactionId);
444         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
445             txn.executed = true;
446             if (!_confirmed)
447                 spentToday += txn.value;
448             if (txn.destination.call.value(txn.value)(txn.data))
449                 Execution(transactionId);
450             else {
451                 ExecutionFailure(transactionId);
452                 txn.executed = false;
453                 if (!_confirmed)
454                     spentToday -= txn.value;
455             }
456         }
457     }
458 
459     /*
460      * Internal functions
461      */
462     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
463     /// @param amount Amount to withdraw.
464     /// @return Returns if amount is under daily limit.
465     function isUnderLimit(uint amount)
466         internal
467         returns (bool)
468     {
469         if (now > lastDay + 24 hours) {
470             lastDay = now;
471             spentToday = 0;
472         }
473         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
474             return false;
475         return true;
476     }
477 
478     /*
479      * Web3 call functions
480      */
481     /// @dev Returns maximum withdraw amount.
482     /// @return Returns amount.
483     function calcMaxWithdraw()
484         public
485         constant
486         returns (uint)
487     {
488         if (now > lastDay + 24 hours)
489             return dailyLimit;
490         if (dailyLimit < spentToday)
491             return 0;
492         return dailyLimit - spentToday;
493     }
494 }
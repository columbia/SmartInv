1 pragma solidity ^0.4.15;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 
7     /*
8      *  Events
9      */
10     event Confirmation(address indexed sender, uint indexed transactionId);
11     event Revocation(address indexed sender, uint indexed transactionId);
12     event Submission(uint indexed transactionId);
13     event Execution(uint indexed transactionId);
14     event ExecutionFailure(uint indexed transactionId);
15     event Deposit(address indexed sender, uint value);
16     event OwnerAddition(address indexed owner);
17     event OwnerRemoval(address indexed owner);
18     event RequirementChange(uint required);
19 
20     /*
21      *  Constants
22      */
23     uint constant public MAX_OWNER_COUNT = 50;
24 
25     /*
26      *  Storage
27      */
28     mapping (uint => Transaction) public transactions;
29     mapping (uint => mapping (address => bool)) public confirmations;
30     mapping (address => bool) public isOwner;
31     address[] public owners;
32     uint public required;
33     uint public transactionCount;
34 
35     struct Transaction {
36         address destination;
37         uint value;
38         bytes data;
39         bool executed;
40     }
41 
42     /*
43      *  Modifiers
44      */
45     modifier onlyWallet() {
46         require(msg.sender == address(this));
47         _;
48     }
49 
50     modifier ownerDoesNotExist(address owner) {
51         require(!isOwner[owner]);
52         _;
53     }
54 
55     modifier ownerExists(address owner) {
56         require(isOwner[owner]);
57         _;
58     }
59 
60     modifier transactionExists(uint transactionId) {
61         require(transactions[transactionId].destination != 0);
62         _;
63     }
64 
65     modifier confirmed(uint transactionId, address owner) {
66         require(confirmations[transactionId][owner]);
67         _;
68     }
69 
70     modifier notConfirmed(uint transactionId, address owner) {
71         require(!confirmations[transactionId][owner]);
72         _;
73     }
74 
75     modifier notExecuted(uint transactionId) {
76         require(!transactions[transactionId].executed);
77         _;
78     }
79 
80     modifier notNull(address _address) {
81         require(_address != 0);
82         _;
83     }
84 
85     modifier validRequirement(uint ownerCount, uint _required) {
86         require(ownerCount <= MAX_OWNER_COUNT
87             && _required <= ownerCount
88             && _required != 0
89             && ownerCount != 0);
90         _;
91     }
92 
93     /// @dev Fallback function allows to deposit ether.
94     function()
95         payable
96     {
97         if (msg.value > 0)
98             Deposit(msg.sender, msg.value);
99     }
100 
101     /*
102      * Public functions
103      */
104     /// @dev Contract constructor sets initial owners and required number of confirmations.
105     /// @param _owners List of initial owners.
106     /// @param _required Number of required confirmations.
107     function MultiSigWallet(address[] _owners, uint _required)
108         public
109         validRequirement(_owners.length, _required)
110     {
111         for (uint i=0; i<_owners.length; i++) {
112             require(!isOwner[_owners[i]] && _owners[i] != 0);
113             isOwner[_owners[i]] = true;
114         }
115         owners = _owners;
116         required = _required;
117     }
118 
119     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
120     /// @param owner Address of new owner.
121     function addOwner(address owner)
122         public
123         onlyWallet
124         ownerDoesNotExist(owner)
125         notNull(owner)
126         validRequirement(owners.length + 1, required)
127     {
128         isOwner[owner] = true;
129         owners.push(owner);
130         OwnerAddition(owner);
131     }
132 
133     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
134     /// @param owner Address of owner.
135     function removeOwner(address owner)
136         public
137         onlyWallet
138         ownerExists(owner)
139     {
140         isOwner[owner] = false;
141         for (uint i=0; i<owners.length - 1; i++)
142             if (owners[i] == owner) {
143                 owners[i] = owners[owners.length - 1];
144                 break;
145             }
146         owners.length -= 1;
147         if (required > owners.length)
148             changeRequirement(owners.length);
149         OwnerRemoval(owner);
150     }
151 
152     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
153     /// @param owner Address of owner to be replaced.
154     /// @param newOwner Address of new owner.
155     function replaceOwner(address owner, address newOwner)
156         public
157         onlyWallet
158         ownerExists(owner)
159         ownerDoesNotExist(newOwner)
160     {
161         for (uint i=0; i<owners.length; i++)
162             if (owners[i] == owner) {
163                 owners[i] = newOwner;
164                 break;
165             }
166         isOwner[owner] = false;
167         isOwner[newOwner] = true;
168         OwnerRemoval(owner);
169         OwnerAddition(newOwner);
170     }
171 
172     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
173     /// @param _required Number of required confirmations.
174     function changeRequirement(uint _required)
175         public
176         onlyWallet
177         validRequirement(owners.length, _required)
178     {
179         required = _required;
180         RequirementChange(_required);
181     }
182 
183     /// @dev Allows an owner to submit and confirm a transaction.
184     /// @param destination Transaction target address.
185     /// @param value Transaction ether value.
186     /// @param data Transaction data payload.
187     /// @return Returns transaction ID.
188     function submitTransaction(address destination, uint value, bytes data)
189         public
190         returns (uint transactionId)
191     {
192         transactionId = addTransaction(destination, value, data);
193         confirmTransaction(transactionId);
194     }
195 
196     /// @dev Allows an owner to confirm a transaction.
197     /// @param transactionId Transaction ID.
198     function confirmTransaction(uint transactionId)
199         public
200         ownerExists(msg.sender)
201         transactionExists(transactionId)
202         notConfirmed(transactionId, msg.sender)
203     {
204         confirmations[transactionId][msg.sender] = true;
205         Confirmation(msg.sender, transactionId);
206         executeTransaction(transactionId);
207     }
208 
209     /// @dev Allows an owner to revoke a confirmation for a transaction.
210     /// @param transactionId Transaction ID.
211     function revokeConfirmation(uint transactionId)
212         public
213         ownerExists(msg.sender)
214         confirmed(transactionId, msg.sender)
215         notExecuted(transactionId)
216     {
217         confirmations[transactionId][msg.sender] = false;
218         Revocation(msg.sender, transactionId);
219     }
220 
221     /// @dev Allows anyone to execute a confirmed transaction.
222     /// @param transactionId Transaction ID.
223     function executeTransaction(uint transactionId)
224         public
225         ownerExists(msg.sender)
226         confirmed(transactionId, msg.sender)
227         notExecuted(transactionId)
228     {
229         if (isConfirmed(transactionId)) {
230             Transaction storage txn = transactions[transactionId];
231             txn.executed = true;
232             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
233                 Execution(transactionId);
234             else {
235                 ExecutionFailure(transactionId);
236                 txn.executed = false;
237             }
238         }
239     }
240 
241     // call has been separated into its own function in order to take advantage
242     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
243     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
244         bool result;
245         assembly {
246             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
247             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
248             result := call(
249                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
250                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
251                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
252                 destination,
253                 value,
254                 d,
255                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
256                 x,
257                 0                  // Output is ignored, therefore the output size is zero
258             )
259         }
260         return result;
261     }
262 
263     /// @dev Returns the confirmation status of a transaction.
264     /// @param transactionId Transaction ID.
265     /// @return Confirmation status.
266     function isConfirmed(uint transactionId)
267         public
268         constant
269         returns (bool)
270     {
271         uint count = 0;
272         for (uint i=0; i<owners.length; i++) {
273             if (confirmations[transactionId][owners[i]])
274                 count += 1;
275             if (count == required)
276                 return true;
277         }
278     }
279 
280     /*
281      * Internal functions
282      */
283     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
284     /// @param destination Transaction target address.
285     /// @param value Transaction ether value.
286     /// @param data Transaction data payload.
287     /// @return Returns transaction ID.
288     function addTransaction(address destination, uint value, bytes data)
289         internal
290         notNull(destination)
291         returns (uint transactionId)
292     {
293         transactionId = transactionCount;
294         transactions[transactionId] = Transaction({
295             destination: destination,
296             value: value,
297             data: data,
298             executed: false
299         });
300         transactionCount += 1;
301         Submission(transactionId);
302     }
303 
304     /*
305      * Web3 call functions
306      */
307     /// @dev Returns number of confirmations of a transaction.
308     /// @param transactionId Transaction ID.
309     /// @return Number of confirmations.
310     function getConfirmationCount(uint transactionId)
311         public
312         constant
313         returns (uint count)
314     {
315         for (uint i=0; i<owners.length; i++)
316             if (confirmations[transactionId][owners[i]])
317                 count += 1;
318     }
319 
320     /// @dev Returns total number of transactions after filers are applied.
321     /// @param pending Include pending transactions.
322     /// @param executed Include executed transactions.
323     /// @return Total number of transactions after filters are applied.
324     function getTransactionCount(bool pending, bool executed)
325         public
326         constant
327         returns (uint count)
328     {
329         for (uint i=0; i<transactionCount; i++)
330             if (   pending && !transactions[i].executed
331                 || executed && transactions[i].executed)
332                 count += 1;
333     }
334 
335     /// @dev Returns list of owners.
336     /// @return List of owner addresses.
337     function getOwners()
338         public
339         constant
340         returns (address[])
341     {
342         return owners;
343     }
344 
345     /// @dev Returns array with owner addresses, which confirmed transaction.
346     /// @param transactionId Transaction ID.
347     /// @return Returns array of owner addresses.
348     function getConfirmations(uint transactionId)
349         public
350         constant
351         returns (address[] _confirmations)
352     {
353         address[] memory confirmationsTemp = new address[](owners.length);
354         uint count = 0;
355         uint i;
356         for (i=0; i<owners.length; i++)
357             if (confirmations[transactionId][owners[i]]) {
358                 confirmationsTemp[count] = owners[i];
359                 count += 1;
360             }
361         _confirmations = new address[](count);
362         for (i=0; i<count; i++)
363             _confirmations[i] = confirmationsTemp[i];
364     }
365 
366     /// @dev Returns list of transaction IDs in defined range.
367     /// @param from Index start position of transaction array.
368     /// @param to Index end position of transaction array.
369     /// @param pending Include pending transactions.
370     /// @param executed Include executed transactions.
371     /// @return Returns array of transaction IDs.
372     function getTransactionIds(uint from, uint to, bool pending, bool executed)
373         public
374         constant
375         returns (uint[] _transactionIds)
376     {
377         uint[] memory transactionIdsTemp = new uint[](transactionCount);
378         uint count = 0;
379         uint i;
380         for (i=0; i<transactionCount; i++)
381             if (   pending && !transactions[i].executed
382                 || executed && transactions[i].executed)
383             {
384                 transactionIdsTemp[count] = i;
385                 count += 1;
386             }
387         _transactionIds = new uint[](to - from);
388         for (i=from; i<to; i++)
389             _transactionIds[i - from] = transactionIdsTemp[i];
390     }
391 }
392 
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
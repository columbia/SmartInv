1 pragma solidity ^0.4.4;
2 
3 //  @address:0xbc512b1d63110c286fd821a73855117fc395464d
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     uint constant public MAX_OWNER_COUNT = 50;
9 
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
20     mapping (uint => Transaction) public transactions;
21     mapping (uint => mapping (address => bool)) public confirmations;
22     mapping (address => bool) public isOwner;
23     address[] public owners;
24     uint public required;
25     uint public transactionCount;
26     uint public onceSetOwners = 1;
27 
28     address public creator;
29 
30     struct Transaction {
31     address destination;
32     uint value;
33     bytes data;
34     bool executed;
35     }
36 
37     modifier onlyCreator() {
38         require(msg.sender == creator);
39         _;
40     }
41 
42     modifier onlyWallet() {
43         if (msg.sender != address(this))
44         throw;
45         _;
46     }
47 
48     modifier ownerDoesNotExist(address owner) {
49         if (isOwner[owner])
50         throw;
51         _;
52     }
53 
54     modifier ownerExists(address owner) {
55         if (!isOwner[owner])
56         throw;
57         _;
58     }
59 
60     modifier transactionExists(uint transactionId) {
61         if (transactions[transactionId].destination == 0)
62         throw;
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         if (!confirmations[transactionId][owner])
68         throw;
69         _;
70     }
71 
72     modifier notConfirmed(uint transactionId, address owner) {
73         if (confirmations[transactionId][owner])
74         throw;
75         _;
76     }
77 
78     modifier notExecuted(uint transactionId) {
79         if (transactions[transactionId].executed)
80         throw;
81         _;
82     }
83 
84     modifier notNull(address _address) {
85         if (_address == 0)
86         throw;
87         _;
88     }
89 
90     modifier onlyOnceSetOwners(){
91         if (onceSetOwners < 1)
92         throw;
93         _;
94     }
95 
96     modifier validRequirement(uint ownerCount, uint _required) {
97         if (   ownerCount > MAX_OWNER_COUNT
98         || _required > ownerCount
99         || _required == 0
100         || ownerCount == 0)
101         throw;
102         _;
103     }
104 
105     /// @dev Fallback function allows to deposit ether.
106     function()
107     payable
108     {
109         if (msg.value > 0)
110         Deposit(msg.sender, msg.value);
111     }
112 
113     /*
114      * Public functions
115      */
116     /// @dev Contract constructor sets initial owners and required number of confirmations.
117     function MultiSigWallet()
118     public
119     {
120         creator = msg.sender;
121     }
122 
123     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
124     /// @param owner Address of new owner.
125     function addOwner(address owner)
126     public
127     onlyWallet
128     ownerDoesNotExist(owner)
129     notNull(owner)
130     validRequirement(owners.length + 1, required)
131     {
132         isOwner[owner] = true;
133         owners.push(owner);
134         OwnerAddition(owner);
135     }
136 
137     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
138     /// @param owner Address of owner.
139     function removeOwner(address owner)
140     public
141     onlyWallet
142     ownerExists(owner)
143     {
144         isOwner[owner] = false;
145         for (uint i=0; i<owners.length - 1; i++)
146         if (owners[i] == owner) {
147             owners[i] = owners[owners.length - 1];
148             break;
149         }
150         owners.length -= 1;
151         if (required > owners.length)
152         changeRequirement(owners.length);
153         OwnerRemoval(owner);
154     }
155 
156     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
157     /// @param owner Address of owner to be replaced.
158     /// @param owner Address of new owner.
159     function replaceOwner(address owner, address newOwner)
160     public
161     onlyWallet
162     ownerExists(owner)
163     ownerDoesNotExist(newOwner)
164     {
165         for (uint i=0; i<owners.length; i++)
166         if (owners[i] == owner) {
167             owners[i] = newOwner;
168             break;
169         }
170         isOwner[owner] = false;
171         isOwner[newOwner] = true;
172         OwnerRemoval(owner);
173         OwnerAddition(newOwner);
174     }
175 
176     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
177     /// @param _required Number of required confirmations.
178     function changeRequirement(uint _required)
179     public
180     onlyWallet
181     validRequirement(owners.length, _required)
182     {
183         required = _required;
184         RequirementChange(_required);
185     }
186 
187     /// @dev Allows an owner to submit and confirm a transaction.
188     /// @param destination Transaction target address.
189     /// @param value Transaction ether value.
190     /// @param data Transaction data payload.
191     /// @return Returns transaction ID.
192     function submitTransaction(address destination, uint value, bytes data)
193     public
194     returns (uint transactionId)
195     {
196         transactionId = addTransaction(destination, value, data);
197         confirmTransaction(transactionId);
198     }
199 
200     /// @dev Allows an owner to confirm a transaction.
201     /// @param transactionId Transaction ID.
202     function confirmTransaction(uint transactionId)
203     public
204     ownerExists(msg.sender)
205     transactionExists(transactionId)
206     notConfirmed(transactionId, msg.sender)
207     {
208         confirmations[transactionId][msg.sender] = true;
209         Confirmation(msg.sender, transactionId);
210         executeTransaction(transactionId);
211     }
212 
213     /// @dev Allows an owner to revoke a confirmation for a transaction.
214     /// @param transactionId Transaction ID.
215     function revokeConfirmation(uint transactionId)
216     public
217     ownerExists(msg.sender)
218     confirmed(transactionId, msg.sender)
219     notExecuted(transactionId)
220     {
221         confirmations[transactionId][msg.sender] = false;
222         Revocation(msg.sender, transactionId);
223     }
224 
225     /// @dev Allows anyone to execute a confirmed transaction.
226     /// @param transactionId Transaction ID.
227     function executeTransaction(uint transactionId)
228     public
229     notExecuted(transactionId)
230     {
231         if (isConfirmed(transactionId)) {
232             Transaction tx = transactions[transactionId];
233             tx.executed = true;
234             if (tx.destination.call.value(tx.value)(tx.data))
235             Execution(transactionId);
236             else {
237                 ExecutionFailure(transactionId);
238                 tx.executed = false;
239             }
240         }
241     }
242 
243     /// @dev Returns the confirmation status of a transaction.
244     /// @param transactionId Transaction ID.
245     /// @return Confirmation status.
246     function isConfirmed(uint transactionId)
247     public
248     constant
249     returns (bool)
250     {
251         uint count = 0;
252         for (uint i=0; i<owners.length; i++) {
253             if (confirmations[transactionId][owners[i]])
254             count += 1;
255             if (count == required)
256             return true;
257         }
258     }
259 
260     /*
261      * Internal functions
262      */
263     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
264     /// @param destination Transaction target address.
265     /// @param value Transaction ether value.
266     /// @param data Transaction data payload.
267     /// @return Returns transaction ID.
268     function addTransaction(address destination, uint value, bytes data)
269     internal
270     notNull(destination)
271     returns (uint transactionId)
272     {
273         transactionId = transactionCount;
274         transactions[transactionId] = Transaction({
275         destination: destination,
276         value: value,
277         data: data,
278         executed: false
279         });
280         transactionCount += 1;
281         Submission(transactionId);
282     }
283 
284     /*
285      * Web3 call functions
286      */
287     /// @dev Returns number of confirmations of a transaction.
288     /// @param transactionId Transaction ID.
289     /// @return Number of confirmations.
290     function getConfirmationCount(uint transactionId)
291     public
292     constant
293     returns (uint count)
294     {
295         for (uint i=0; i<owners.length; i++)
296         if (confirmations[transactionId][owners[i]])
297         count += 1;
298     }
299 
300     /// @dev Returns total number of transactions after filers are applied.
301     /// @param pending Include pending transactions.
302     /// @param executed Include executed transactions.
303     /// @return Total number of transactions after filters are applied.
304     function getTransactionCount(bool pending, bool executed)
305     public
306     constant
307     returns (uint count)
308     {
309         for (uint i=0; i<transactionCount; i++)
310         if (   pending && !transactions[i].executed
311         || executed && transactions[i].executed)
312         count += 1;
313     }
314 
315     /// @dev Returns list of owners.
316     /// @return List of owner addresses.
317     function getOwners()
318     public
319     constant
320     returns (address[])
321     {
322         return owners;
323     }
324 
325     /// @dev Returns array with owner addresses, which confirmed transaction.
326     /// @param transactionId Transaction ID.
327     /// @return Returns array of owner addresses.
328     function getConfirmations(uint transactionId)
329     public
330     constant
331     returns (address[] _confirmations)
332     {
333         address[] memory confirmationsTemp = new address[](owners.length);
334         uint count = 0;
335         uint i;
336         for (i=0; i<owners.length; i++)
337         if (confirmations[transactionId][owners[i]]) {
338             confirmationsTemp[count] = owners[i];
339             count += 1;
340         }
341         _confirmations = new address[](count);
342         for (i=0; i<count; i++)
343         _confirmations[i] = confirmationsTemp[i];
344     }
345 
346     /// @dev Returns list of transaction IDs in defined range.
347     /// @param from Index start position of transaction array.
348     /// @param to Index end position of transaction array.
349     /// @param pending Include pending transactions.
350     /// @param executed Include executed transactions.
351     /// @return Returns array of transaction IDs.
352     function getTransactionIds(uint from, uint to, bool pending, bool executed)
353     public
354     constant
355     returns (uint[] _transactionIds)
356     {
357         uint[] memory transactionIdsTemp = new uint[](transactionCount);
358         uint count = 0;
359         uint i;
360         for (i=0; i<transactionCount; i++)
361         if (   pending && !transactions[i].executed
362         || executed && transactions[i].executed)
363         {
364             transactionIdsTemp[count] = i;
365             count += 1;
366         }
367         _transactionIds = new uint[](to - from);
368         for (i=from; i<to; i++)
369         _transactionIds[i - from] = transactionIdsTemp[i];
370     }
371 }
372 
373 
374 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
375 /// @author Stefan George - <stefan.george@consensys.net>
376 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
377 
378     event DailyLimitChange(uint dailyLimit);
379 
380     uint public dailyLimit;
381     uint public lastDay;
382     uint public spentToday;
383 
384     /*
385      * Public functions
386      */
387     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
388 
389     function MultiSigWalletWithDailyLimit()
390     public
391     MultiSigWallet()
392     {
393     }
394 
395     function setInitAttr(address[] _owners, uint _required, uint _dailyLimit)
396     public
397     validRequirement(_owners.length, _required)
398     onlyOnceSetOwners
399     onlyCreator
400     {
401         for (uint i=0; i<_owners.length; i++) {
402             if (isOwner[_owners[i]] || _owners[i] == 0)
403             throw;
404             isOwner[_owners[i]] = true;
405         }
406         dailyLimit = _dailyLimit;
407         owners = _owners;
408         required = _required;
409         onceSetOwners = onceSetOwners - 1;
410     }
411 
412     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
413     /// @param _dailyLimit Amount in wei.
414     function changeDailyLimit(uint _dailyLimit)
415     public
416     onlyWallet
417     {
418         dailyLimit = _dailyLimit;
419         DailyLimitChange(_dailyLimit);
420     }
421 
422     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
423     /// @param transactionId Transaction ID.
424     function executeTransaction(uint transactionId)
425     public
426     notExecuted(transactionId)
427     {
428         Transaction tx = transactions[transactionId];
429         bool confirmed = isConfirmed(transactionId);
430         if (confirmed || tx.data.length == 0 && isUnderLimit(tx.value)) {
431             tx.executed = true;
432             if (!confirmed)
433             spentToday += tx.value;
434             if (tx.destination.call.value(tx.value)(tx.data))
435             Execution(transactionId);
436             else {
437                 ExecutionFailure(transactionId);
438                 tx.executed = false;
439                 if (!confirmed)
440                 spentToday -= tx.value;
441             }
442         }
443     }
444 
445     /*
446      * Internal functions
447      */
448     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
449     /// @param amount Amount to withdraw.
450     /// @return Returns if amount is under daily limit.
451     function isUnderLimit(uint amount)
452     internal
453     returns (bool)
454     {
455         if (now > lastDay + 24 hours) {
456             lastDay = now;
457             spentToday = 0;
458         }
459         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
460         return false;
461         return true;
462     }
463 
464     /*
465      * Web3 call functions
466      */
467     /// @dev Returns maximum withdraw amount.
468     /// @return Returns amount.
469     function calcMaxWithdraw()
470     public
471     constant
472     returns (uint)
473     {
474         if (now > lastDay + 24 hours)
475         return dailyLimit;
476         if (dailyLimit < spentToday)
477         return 0;
478         return dailyLimit - spentToday;
479     }
480 }
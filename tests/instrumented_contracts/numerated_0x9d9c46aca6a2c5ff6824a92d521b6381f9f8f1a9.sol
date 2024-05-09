1 /**
2  *Submitted for verification at Etherscan.io on 2018-03-30
3 */
4 
5 pragma solidity 0.4.20;
6 
7 
8 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
9 /// @author Stefan George - <stefan.george@consensys.net>
10 contract MultiSigWallet {
11 
12     /*
13      *  Events
14      */
15     event Confirmation(address indexed sender, uint indexed transactionId);
16     event Revocation(address indexed sender, uint indexed transactionId);
17     event Submission(uint indexed transactionId);
18     event Execution(uint indexed transactionId);
19     event ExecutionFailure(uint indexed transactionId);
20     event Deposit(address indexed sender, uint value);
21     event OwnerAddition(address indexed owner);
22     event OwnerRemoval(address indexed owner);
23     event RequirementChange(uint required);
24 
25     /*
26      *  Constants
27      */
28     uint constant public MAX_OWNER_COUNT = 50;
29 
30     /*
31      *  Storage
32      */
33     mapping (uint => Transaction) public transactions;
34     mapping (uint => mapping (address => bool)) public confirmations;
35     mapping (address => bool) public isOwner;
36     address[] public owners;
37     uint public required;
38     uint public transactionCount;
39 
40     struct Transaction {
41         address destination;
42         uint value;
43         bytes data;
44         bool executed;
45     }
46 
47     /*
48      *  Modifiers
49      */
50     modifier onlyWallet() {
51         require(msg.sender == address(this));
52         _;
53     }
54 
55     modifier ownerDoesNotExist(address owner) {
56         require(!isOwner[owner]);
57         _;
58     }
59 
60     modifier ownerExists(address owner) {
61         require(isOwner[owner]);
62         _;
63     }
64 
65     modifier transactionExists(uint transactionId) {
66         require(transactions[transactionId].destination != 0);
67         _;
68     }
69 
70     modifier confirmed(uint transactionId, address owner) {
71         require(confirmations[transactionId][owner]);
72         _;
73     }
74 
75     modifier notConfirmed(uint transactionId, address owner) {
76         require(!confirmations[transactionId][owner]);
77         _;
78     }
79 
80     modifier notExecuted(uint transactionId) {
81         require(!transactions[transactionId].executed);
82         _;
83     }
84 
85     modifier notNull(address _address) {
86         require(_address != 0);
87         _;
88     }
89 
90     modifier validRequirement(uint ownerCount, uint _required) {
91         require(ownerCount <= MAX_OWNER_COUNT
92             && _required <= ownerCount
93             && _required != 0
94             && ownerCount != 0);
95         _;
96     }
97 
98     /// @dev Fallback function allows to deposit ether.
99     function()
100         payable
101     {
102         if (msg.value > 0)
103             Deposit(msg.sender, msg.value);
104     }
105 
106     /*
107      * Public functions
108      */
109     /// @dev Contract constructor sets initial owners and required number of confirmations.
110     /// @param _owners List of initial owners.
111     /// @param _required Number of required confirmations.
112     function MultiSigWallet(address[] _owners, uint _required)
113         public
114         validRequirement(_owners.length, _required)
115     {
116         for (uint i=0; i<_owners.length; i++) {
117             require(!isOwner[_owners[i]] && _owners[i] != 0);
118             isOwner[_owners[i]] = true;
119         }
120         owners = _owners;
121         required = _required;
122     }
123 
124     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
125     /// @param owner Address of new owner.
126     function addOwner(address owner)
127         public
128         onlyWallet
129         ownerDoesNotExist(owner)
130         notNull(owner)
131         validRequirement(owners.length + 1, required)
132     {
133         isOwner[owner] = true;
134         owners.push(owner);
135         OwnerAddition(owner);
136     }
137 
138     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
139     /// @param owner Address of owner.
140     function removeOwner(address owner)
141         public
142         onlyWallet
143         ownerExists(owner)
144     {
145         isOwner[owner] = false;
146         for (uint i=0; i<owners.length - 1; i++)
147             if (owners[i] == owner) {
148                 owners[i] = owners[owners.length - 1];
149                 break;
150             }
151         owners.length -= 1;
152         if (required > owners.length)
153             changeRequirement(owners.length);
154         OwnerRemoval(owner);
155     }
156 
157     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
158     /// @param owner Address of owner to be replaced.
159     /// @param newOwner Address of new owner.
160     function replaceOwner(address owner, address newOwner)
161         public
162         onlyWallet
163         ownerExists(owner)
164         ownerDoesNotExist(newOwner)
165     {
166         for (uint i=0; i<owners.length; i++)
167             if (owners[i] == owner) {
168                 owners[i] = newOwner;
169                 break;
170             }
171         isOwner[owner] = false;
172         isOwner[newOwner] = true;
173         OwnerRemoval(owner);
174         OwnerAddition(newOwner);
175     }
176 
177     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
178     /// @param _required Number of required confirmations.
179     function changeRequirement(uint _required)
180         public
181         onlyWallet
182         validRequirement(owners.length, _required)
183     {
184         required = _required;
185         RequirementChange(_required);
186     }
187 
188     /// @dev Allows an owner to submit and confirm a transaction.
189     /// @param destination Transaction target address.
190     /// @param value Transaction ether value.
191     /// @param data Transaction data payload.
192     /// @return Returns transaction ID.
193     function submitTransaction(address destination, uint value, bytes data)
194         public
195         returns (uint transactionId)
196     {
197         transactionId = addTransaction(destination, value, data);
198         confirmTransaction(transactionId);
199     }
200 
201     /// @dev Allows an owner to confirm a transaction.
202     /// @param transactionId Transaction ID.
203     function confirmTransaction(uint transactionId)
204         public
205         ownerExists(msg.sender)
206         transactionExists(transactionId)
207         notConfirmed(transactionId, msg.sender)
208     {
209         confirmations[transactionId][msg.sender] = true;
210         Confirmation(msg.sender, transactionId);
211         executeTransaction(transactionId);
212     }
213 
214     /// @dev Allows an owner to revoke a confirmation for a transaction.
215     /// @param transactionId Transaction ID.
216     function revokeConfirmation(uint transactionId)
217         public
218         ownerExists(msg.sender)
219         confirmed(transactionId, msg.sender)
220         notExecuted(transactionId)
221     {
222         confirmations[transactionId][msg.sender] = false;
223         Revocation(msg.sender, transactionId);
224     }
225 
226     /// @dev Allows anyone to execute a confirmed transaction.
227     /// @param transactionId Transaction ID.
228     function executeTransaction(uint transactionId)
229         public
230         ownerExists(msg.sender)
231         confirmed(transactionId, msg.sender)
232         notExecuted(transactionId)
233     {
234         if (isConfirmed(transactionId)) {
235             Transaction storage txn = transactions[transactionId];
236             txn.executed = true;
237             if (txn.destination.call.value(txn.value)(txn.data))
238                 Execution(transactionId);
239             else {
240                 ExecutionFailure(transactionId);
241                 txn.executed = false;
242             }
243         }
244     }
245 
246     /// @dev Returns the confirmation status of a transaction.
247     /// @param transactionId Transaction ID.
248     /// @return Confirmation status.
249     function isConfirmed(uint transactionId)
250         public
251         constant
252         returns (bool)
253     {
254         uint count = 0;
255         for (uint i=0; i<owners.length; i++) {
256             if (confirmations[transactionId][owners[i]])
257                 count += 1;
258             if (count == required)
259                 return true;
260         }
261     }
262 
263     /*
264      * Internal functions
265      */
266     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
267     /// @param destination Transaction target address.
268     /// @param value Transaction ether value.
269     /// @param data Transaction data payload.
270     /// @return Returns transaction ID.
271     function addTransaction(address destination, uint value, bytes data)
272         internal
273         notNull(destination)
274         returns (uint transactionId)
275     {
276         transactionId = transactionCount;
277         transactions[transactionId] = Transaction({
278             destination: destination,
279             value: value,
280             data: data,
281             executed: false
282         });
283         transactionCount += 1;
284         Submission(transactionId);
285     }
286 
287     /*
288      * Web3 call functions
289      */
290     /// @dev Returns number of confirmations of a transaction.
291     /// @param transactionId Transaction ID.
292     /// @return Number of confirmations.
293     function getConfirmationCount(uint transactionId)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i=0; i<owners.length; i++)
299             if (confirmations[transactionId][owners[i]])
300                 count += 1;
301     }
302 
303     /// @dev Returns total number of transactions after filers are applied.
304     /// @param pending Include pending transactions.
305     /// @param executed Include executed transactions.
306     /// @return Total number of transactions after filters are applied.
307     function getTransactionCount(bool pending, bool executed)
308         public
309         constant
310         returns (uint count)
311     {
312         for (uint i=0; i<transactionCount; i++)
313             if (   pending && !transactions[i].executed
314                 || executed && transactions[i].executed)
315                 count += 1;
316     }
317 
318     /// @dev Returns list of owners.
319     /// @return List of owner addresses.
320     function getOwners()
321         public
322         constant
323         returns (address[])
324     {
325         return owners;
326     }
327 
328     /// @dev Returns array with owner addresses, which confirmed transaction.
329     /// @param transactionId Transaction ID.
330     /// @return Returns array of owner addresses.
331     function getConfirmations(uint transactionId)
332         public
333         constant
334         returns (address[] _confirmations)
335     {
336         address[] memory confirmationsTemp = new address[](owners.length);
337         uint count = 0;
338         uint i;
339         for (i=0; i<owners.length; i++)
340             if (confirmations[transactionId][owners[i]]) {
341                 confirmationsTemp[count] = owners[i];
342                 count += 1;
343             }
344         _confirmations = new address[](count);
345         for (i=0; i<count; i++)
346             _confirmations[i] = confirmationsTemp[i];
347     }
348 
349     /// @dev Returns list of transaction IDs in defined range.
350     /// @param from Index start position of transaction array.
351     /// @param to Index end position of transaction array.
352     /// @param pending Include pending transactions.
353     /// @param executed Include executed transactions.
354     /// @return Returns array of transaction IDs.
355     function getTransactionIds(uint from, uint to, bool pending, bool executed)
356         public
357         constant
358         returns (uint[] _transactionIds)
359     {
360         uint[] memory transactionIdsTemp = new uint[](transactionCount);
361         uint count = 0;
362         uint i;
363         for (i=0; i<transactionCount; i++)
364             if (   pending && !transactions[i].executed
365                 || executed && transactions[i].executed)
366             {
367                 transactionIdsTemp[count] = i;
368                 count += 1;
369             }
370         _transactionIds = new uint[](to - from);
371         for (i=from; i<to; i++)
372             _transactionIds[i - from] = transactionIdsTemp[i];
373     }
374 }
375 
376 
377 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
378 /// @author Stefan George - <stefan.george@consensys.net>
379 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
380 
381     /*
382      *  Events
383      */
384     event DailyLimitChange(uint dailyLimit);
385 
386     /*
387      *  Storage
388      */
389     uint public dailyLimit;
390     uint public lastDay;
391     uint public spentToday;
392 
393     /*
394      * Public functions
395      */
396     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
397     /// @param _owners List of initial owners.
398     /// @param _required Number of required confirmations.
399     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
400     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
401         public
402         MultiSigWallet(_owners, _required)
403     {
404         dailyLimit = _dailyLimit;
405     }
406 
407     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
408     /// @param _dailyLimit Amount in wei.
409     function changeDailyLimit(uint _dailyLimit)
410         public
411         onlyWallet
412     {
413         dailyLimit = _dailyLimit;
414         DailyLimitChange(_dailyLimit);
415     }
416 
417     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
418     /// @param transactionId Transaction ID.
419     function executeTransaction(uint transactionId)
420         public
421         ownerExists(msg.sender)
422         confirmed(transactionId, msg.sender)
423         notExecuted(transactionId)
424     {
425         Transaction storage txn = transactions[transactionId];
426         bool _confirmed = isConfirmed(transactionId);
427         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
428             txn.executed = true;
429             if (!_confirmed)
430                 spentToday += txn.value;
431             if (txn.destination.call.value(txn.value)(txn.data))
432                 Execution(transactionId);
433             else {
434                 ExecutionFailure(transactionId);
435                 txn.executed = false;
436                 if (!_confirmed)
437                     spentToday -= txn.value;
438             }
439         }
440     }
441 
442     /*
443      * Internal functions
444      */
445     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
446     /// @param amount Amount to withdraw.
447     /// @return Returns if amount is under daily limit.
448     function isUnderLimit(uint amount)
449         internal
450         returns (bool)
451     {
452         if (now > lastDay + 24 hours) {
453             lastDay = now;
454             spentToday = 0;
455         }
456         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
457             return false;
458         return true;
459     }
460 
461     /*
462      * Web3 call functions
463      */
464     /// @dev Returns maximum withdraw amount.
465     /// @return Returns amount.
466     function calcMaxWithdraw()
467         public
468         constant
469         returns (uint)
470     {
471         if (now > lastDay + 24 hours)
472             return dailyLimit;
473         if (dailyLimit < spentToday)
474             return 0;
475         return dailyLimit - spentToday;
476     }
477 }
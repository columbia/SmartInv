1 /**
2  *Submitted for verification at Etherscan.io on 2018-05-10
3 */
4 
5 pragma solidity ^0.4.4;
6 
7 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
8 /// @author Stefan George - <stefan.george@consensys.net>
9 contract MultiSigWallet {
10 
11     uint constant public MAX_OWNER_COUNT = 50;
12 
13     event Confirmation(address indexed sender, uint indexed transactionId);
14     event Revocation(address indexed sender, uint indexed transactionId);
15     event Submission(uint indexed transactionId);
16     event Execution(uint indexed transactionId);
17     event ExecutionFailure(uint indexed transactionId);
18     event Deposit(address indexed sender, uint value);
19     event OwnerAddition(address indexed owner);
20     event OwnerRemoval(address indexed owner);
21     event RequirementChange(uint required);
22 
23     mapping (uint => Transaction) public transactions;
24     mapping (uint => mapping (address => bool)) public confirmations;
25     mapping (address => bool) public isOwner;
26     address[] public owners;
27     uint public required;
28     uint public transactionCount;
29 
30     struct Transaction {
31         address destination;
32         uint value;
33         bytes data;
34         bool executed;
35     }
36 
37     modifier onlyWallet() {
38         if (msg.sender != address(this))
39             throw;
40         _;
41     }
42 
43     modifier ownerDoesNotExist(address owner) {
44         if (isOwner[owner])
45             throw;
46         _;
47     }
48 
49     modifier ownerExists(address owner) {
50         if (!isOwner[owner])
51             throw;
52         _;
53     }
54 
55     modifier transactionExists(uint transactionId) {
56         if (transactions[transactionId].destination == 0)
57             throw;
58         _;
59     }
60 
61     modifier confirmed(uint transactionId, address owner) {
62         if (!confirmations[transactionId][owner])
63             throw;
64         _;
65     }
66 
67     modifier notConfirmed(uint transactionId, address owner) {
68         if (confirmations[transactionId][owner])
69             throw;
70         _;
71     }
72 
73     modifier notExecuted(uint transactionId) {
74         if (transactions[transactionId].executed)
75             throw;
76         _;
77     }
78 
79     modifier notNull(address _address) {
80         if (_address == 0)
81             throw;
82         _;
83     }
84 
85     modifier validRequirement(uint ownerCount, uint _required) {
86         if (   ownerCount > MAX_OWNER_COUNT
87             || _required > ownerCount
88             || _required == 0
89             || ownerCount == 0)
90             throw;
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
113             if (isOwner[_owners[i]] || _owners[i] == 0)
114                 throw;
115             isOwner[_owners[i]] = true;
116         }
117         owners = _owners;
118         required = _required;
119     }
120 
121     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
122     /// @param owner Address of new owner.
123     function addOwner(address owner)
124         public
125         onlyWallet
126         ownerDoesNotExist(owner)
127         notNull(owner)
128         validRequirement(owners.length + 1, required)
129     {
130         isOwner[owner] = true;
131         owners.push(owner);
132         OwnerAddition(owner);
133     }
134 
135     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
136     /// @param owner Address of owner.
137     function removeOwner(address owner)
138         public
139         onlyWallet
140         ownerExists(owner)
141     {
142         isOwner[owner] = false;
143         for (uint i=0; i<owners.length - 1; i++)
144             if (owners[i] == owner) {
145                 owners[i] = owners[owners.length - 1];
146                 break;
147             }
148         owners.length -= 1;
149         if (required > owners.length)
150             changeRequirement(owners.length);
151         OwnerRemoval(owner);
152     }
153 
154     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
155     /// @param owner Address of owner to be replaced.
156     /// @param owner Address of new owner.
157     function replaceOwner(address owner, address newOwner)
158         public
159         onlyWallet
160         ownerExists(owner)
161         ownerDoesNotExist(newOwner)
162     {
163         for (uint i=0; i<owners.length; i++)
164             if (owners[i] == owner) {
165                 owners[i] = newOwner;
166                 break;
167             }
168         isOwner[owner] = false;
169         isOwner[newOwner] = true;
170         OwnerRemoval(owner);
171         OwnerAddition(newOwner);
172     }
173 
174     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
175     /// @param _required Number of required confirmations.
176     function changeRequirement(uint _required)
177         public
178         onlyWallet
179         validRequirement(owners.length, _required)
180     {
181         required = _required;
182         RequirementChange(_required);
183     }
184 
185     /// @dev Allows an owner to submit and confirm a transaction.
186     /// @param destination Transaction target address.
187     /// @param value Transaction ether value.
188     /// @param data Transaction data payload.
189     /// @return Returns transaction ID.
190     function submitTransaction(address destination, uint value, bytes data)
191         public
192         returns (uint transactionId)
193     {
194         transactionId = addTransaction(destination, value, data);
195         confirmTransaction(transactionId);
196     }
197 
198     /// @dev Allows an owner to confirm a transaction.
199     /// @param transactionId Transaction ID.
200     function confirmTransaction(uint transactionId)
201         public
202         ownerExists(msg.sender)
203         transactionExists(transactionId)
204         notConfirmed(transactionId, msg.sender)
205     {
206         confirmations[transactionId][msg.sender] = true;
207         Confirmation(msg.sender, transactionId);
208         executeTransaction(transactionId);
209     }
210 
211     /// @dev Allows an owner to revoke a confirmation for a transaction.
212     /// @param transactionId Transaction ID.
213     function revokeConfirmation(uint transactionId)
214         public
215         ownerExists(msg.sender)
216         confirmed(transactionId, msg.sender)
217         notExecuted(transactionId)
218     {
219         confirmations[transactionId][msg.sender] = false;
220         Revocation(msg.sender, transactionId);
221     }
222 
223     /// @dev Allows anyone to execute a confirmed transaction.
224     /// @param transactionId Transaction ID.
225     function executeTransaction(uint transactionId)
226         public
227         notExecuted(transactionId)
228     {
229         if (isConfirmed(transactionId)) {
230             Transaction tx = transactions[transactionId];
231             tx.executed = true;
232             if (tx.destination.call.value(tx.value)(tx.data))
233                 Execution(transactionId);
234             else {
235                 ExecutionFailure(transactionId);
236                 tx.executed = false;
237             }
238         }
239     }
240 
241     /// @dev Returns the confirmation status of a transaction.
242     /// @param transactionId Transaction ID.
243     /// @return Confirmation status.
244     function isConfirmed(uint transactionId)
245         public
246         constant
247         returns (bool)
248     {
249         uint count = 0;
250         for (uint i=0; i<owners.length; i++) {
251             if (confirmations[transactionId][owners[i]])
252                 count += 1;
253             if (count == required)
254                 return true;
255         }
256     }
257 
258     /*
259      * Internal functions
260      */
261     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
262     /// @param destination Transaction target address.
263     /// @param value Transaction ether value.
264     /// @param data Transaction data payload.
265     /// @return Returns transaction ID.
266     function addTransaction(address destination, uint value, bytes data)
267         internal
268         notNull(destination)
269         returns (uint transactionId)
270     {
271         transactionId = transactionCount;
272         transactions[transactionId] = Transaction({
273             destination: destination,
274             value: value,
275             data: data,
276             executed: false
277         });
278         transactionCount += 1;
279         Submission(transactionId);
280     }
281 
282     /*
283      * Web3 call functions
284      */
285     /// @dev Returns number of confirmations of a transaction.
286     /// @param transactionId Transaction ID.
287     /// @return Number of confirmations.
288     function getConfirmationCount(uint transactionId)
289         public
290         constant
291         returns (uint count)
292     {
293         for (uint i=0; i<owners.length; i++)
294             if (confirmations[transactionId][owners[i]])
295                 count += 1;
296     }
297 
298     /// @dev Returns total number of transactions after filers are applied.
299     /// @param pending Include pending transactions.
300     /// @param executed Include executed transactions.
301     /// @return Total number of transactions after filters are applied.
302     function getTransactionCount(bool pending, bool executed)
303         public
304         constant
305         returns (uint count)
306     {
307         for (uint i=0; i<transactionCount; i++)
308             if (   pending && !transactions[i].executed
309                 || executed && transactions[i].executed)
310                 count += 1;
311     }
312 
313     /// @dev Returns list of owners.
314     /// @return List of owner addresses.
315     function getOwners()
316         public
317         constant
318         returns (address[])
319     {
320         return owners;
321     }
322 
323     /// @dev Returns array with owner addresses, which confirmed transaction.
324     /// @param transactionId Transaction ID.
325     /// @return Returns array of owner addresses.
326     function getConfirmations(uint transactionId)
327         public
328         constant
329         returns (address[] _confirmations)
330     {
331         address[] memory confirmationsTemp = new address[](owners.length);
332         uint count = 0;
333         uint i;
334         for (i=0; i<owners.length; i++)
335             if (confirmations[transactionId][owners[i]]) {
336                 confirmationsTemp[count] = owners[i];
337                 count += 1;
338             }
339         _confirmations = new address[](count);
340         for (i=0; i<count; i++)
341             _confirmations[i] = confirmationsTemp[i];
342     }
343 
344     /// @dev Returns list of transaction IDs in defined range.
345     /// @param from Index start position of transaction array.
346     /// @param to Index end position of transaction array.
347     /// @param pending Include pending transactions.
348     /// @param executed Include executed transactions.
349     /// @return Returns array of transaction IDs.
350     function getTransactionIds(uint from, uint to, bool pending, bool executed)
351         public
352         constant
353         returns (uint[] _transactionIds)
354     {
355         uint[] memory transactionIdsTemp = new uint[](transactionCount);
356         uint count = 0;
357         uint i;
358         for (i=0; i<transactionCount; i++)
359             if (   pending && !transactions[i].executed
360                 || executed && transactions[i].executed)
361             {
362                 transactionIdsTemp[count] = i;
363                 count += 1;
364             }
365         _transactionIds = new uint[](to - from);
366         for (i=from; i<to; i++)
367             _transactionIds[i - from] = transactionIdsTemp[i];
368     }
369 }
370 
371 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
372 /// @author Stefan George - <stefan.george@consensys.net>
373 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
374 
375     event DailyLimitChange(uint dailyLimit);
376 
377     uint public dailyLimit;
378     uint public lastDay;
379     uint public spentToday;
380 
381     /*
382      * Public functions
383      */
384     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
385     /// @param _owners List of initial owners.
386     /// @param _required Number of required confirmations.
387     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
388     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
389         public
390         MultiSigWallet(_owners, _required)
391     {
392         dailyLimit = _dailyLimit;
393     }
394 
395     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
396     /// @param _dailyLimit Amount in wei.
397     function changeDailyLimit(uint _dailyLimit)
398         public
399         onlyWallet
400     {
401         dailyLimit = _dailyLimit;
402         DailyLimitChange(_dailyLimit);
403     }
404 
405     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
406     /// @param transactionId Transaction ID.
407     function executeTransaction(uint transactionId)
408         public
409         notExecuted(transactionId)
410     {
411         Transaction tx = transactions[transactionId];
412         bool confirmed = isConfirmed(transactionId);
413         if (confirmed || tx.data.length == 0 && isUnderLimit(tx.value)) {
414             tx.executed = true;
415             if (!confirmed)
416                 spentToday += tx.value;
417             if (tx.destination.call.value(tx.value)(tx.data))
418                 Execution(transactionId);
419             else {
420                 ExecutionFailure(transactionId);
421                 tx.executed = false;
422                 if (!confirmed)
423                     spentToday -= tx.value;
424             }
425         }
426     }
427 
428     /*
429      * Internal functions
430      */
431     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
432     /// @param amount Amount to withdraw.
433     /// @return Returns if amount is under daily limit.
434     function isUnderLimit(uint amount)
435         internal
436         returns (bool)
437     {
438         if (now > lastDay + 24 hours) {
439             lastDay = now;
440             spentToday = 0;
441         }
442         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
443             return false;
444         return true;
445     }
446 
447     /*
448      * Web3 call functions
449      */
450     /// @dev Returns maximum withdraw amount.
451     /// @return Returns amount.
452     function calcMaxWithdraw()
453         public
454         constant
455         returns (uint)
456     {
457         if (now > lastDay + 24 hours)
458             return dailyLimit;
459         if (dailyLimit < spentToday)
460             return 0;
461         return dailyLimit - spentToday;
462     }
463 }
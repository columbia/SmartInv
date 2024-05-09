1 pragma solidity ^0.4.4;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 
7     uint constant public MAX_OWNER_COUNT = 50;
8 
9     event Confirmation(address indexed sender, uint indexed transactionId);
10     event Revocation(address indexed sender, uint indexed transactionId);
11     event Submission(uint indexed transactionId);
12     event Execution(uint indexed transactionId);
13     event ExecutionFailure(uint indexed transactionId);
14     event Deposit(address indexed sender, uint value);
15     event OwnerAddition(address indexed owner);
16     event OwnerRemoval(address indexed owner);
17     event RequirementChange(uint required);
18 
19     mapping (uint => Transaction) public transactions;
20     mapping (uint => mapping (address => bool)) public confirmations;
21     mapping (address => bool) public isOwner;
22     address[] public owners;
23     uint public required;
24     uint public transactionCount;
25 
26     struct Transaction {
27         address destination;
28         uint value;
29         bytes data;
30         bool executed;
31     }
32 
33     modifier onlyWallet() {
34         if (msg.sender != address(this))
35             throw;
36         _;
37     }
38 
39     modifier ownerDoesNotExist(address owner) {
40         if (isOwner[owner])
41             throw;
42         _;
43     }
44 
45     modifier ownerExists(address owner) {
46         if (!isOwner[owner])
47             throw;
48         _;
49     }
50 
51     modifier transactionExists(uint transactionId) {
52         if (transactions[transactionId].destination == 0)
53             throw;
54         _;
55     }
56 
57     modifier confirmed(uint transactionId, address owner) {
58         if (!confirmations[transactionId][owner])
59             throw;
60         _;
61     }
62 
63     modifier notConfirmed(uint transactionId, address owner) {
64         if (confirmations[transactionId][owner])
65             throw;
66         _;
67     }
68 
69     modifier notExecuted(uint transactionId) {
70         if (transactions[transactionId].executed)
71             throw;
72         _;
73     }
74 
75     modifier notNull(address _address) {
76         if (_address == 0)
77             throw;
78         _;
79     }
80 
81     modifier validRequirement(uint ownerCount, uint _required) {
82         if (   ownerCount > MAX_OWNER_COUNT
83             || _required > ownerCount
84             || _required == 0
85             || ownerCount == 0)
86             throw;
87         _;
88     }
89 
90     /// @dev Fallback function allows to deposit ether.
91     function()
92         payable
93     {
94         if (msg.value > 0)
95             Deposit(msg.sender, msg.value);
96     }
97 
98     /*
99      * Public functions
100      */
101     /// @dev Contract constructor sets initial owners and required number of confirmations.
102     /// @param _owners List of initial owners.
103     /// @param _required Number of required confirmations.
104     function MultiSigWallet(address[] _owners, uint _required)
105         public
106         validRequirement(_owners.length, _required)
107     {
108         for (uint i=0; i<_owners.length; i++) {
109             if (isOwner[_owners[i]] || _owners[i] == 0)
110                 throw;
111             isOwner[_owners[i]] = true;
112         }
113         owners = _owners;
114         required = _required;
115     }
116 
117     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
118     /// @param owner Address of new owner.
119     function addOwner(address owner)
120         public
121         onlyWallet
122         ownerDoesNotExist(owner)
123         notNull(owner)
124         validRequirement(owners.length + 1, required)
125     {
126         isOwner[owner] = true;
127         owners.push(owner);
128         OwnerAddition(owner);
129     }
130 
131     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
132     /// @param owner Address of owner.
133     function removeOwner(address owner)
134         public
135         onlyWallet
136         ownerExists(owner)
137     {
138         isOwner[owner] = false;
139         for (uint i=0; i<owners.length - 1; i++)
140             if (owners[i] == owner) {
141                 owners[i] = owners[owners.length - 1];
142                 break;
143             }
144         owners.length -= 1;
145         if (required > owners.length)
146             changeRequirement(owners.length);
147         OwnerRemoval(owner);
148     }
149 
150     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
151     /// @param owner Address of owner to be replaced.
152     /// @param owner Address of new owner.
153     function replaceOwner(address owner, address newOwner)
154         public
155         onlyWallet
156         ownerExists(owner)
157         ownerDoesNotExist(newOwner)
158     {
159         for (uint i=0; i<owners.length; i++)
160             if (owners[i] == owner) {
161                 owners[i] = newOwner;
162                 break;
163             }
164         isOwner[owner] = false;
165         isOwner[newOwner] = true;
166         OwnerRemoval(owner);
167         OwnerAddition(newOwner);
168     }
169 
170     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
171     /// @param _required Number of required confirmations.
172     function changeRequirement(uint _required)
173         public
174         onlyWallet
175         validRequirement(owners.length, _required)
176     {
177         required = _required;
178         RequirementChange(_required);
179     }
180 
181     /// @dev Allows an owner to submit and confirm a transaction.
182     /// @param destination Transaction target address.
183     /// @param value Transaction ether value.
184     /// @param data Transaction data payload.
185     /// @return Returns transaction ID.
186     function submitTransaction(address destination, uint value, bytes data)
187         public
188         returns (uint transactionId)
189     {
190         transactionId = addTransaction(destination, value, data);
191         confirmTransaction(transactionId);
192     }
193 
194     /// @dev Allows an owner to confirm a transaction.
195     /// @param transactionId Transaction ID.
196     function confirmTransaction(uint transactionId)
197         public
198         ownerExists(msg.sender)
199         transactionExists(transactionId)
200         notConfirmed(transactionId, msg.sender)
201     {
202         confirmations[transactionId][msg.sender] = true;
203         Confirmation(msg.sender, transactionId);
204         executeTransaction(transactionId);
205     }
206 
207     /// @dev Allows an owner to revoke a confirmation for a transaction.
208     /// @param transactionId Transaction ID.
209     function revokeConfirmation(uint transactionId)
210         public
211         ownerExists(msg.sender)
212         confirmed(transactionId, msg.sender)
213         notExecuted(transactionId)
214     {
215         confirmations[transactionId][msg.sender] = false;
216         Revocation(msg.sender, transactionId);
217     }
218 
219     /// @dev Allows anyone to execute a confirmed transaction.
220     /// @param transactionId Transaction ID.
221     function executeTransaction(uint transactionId)
222         public
223         notExecuted(transactionId)
224     {
225         if (isConfirmed(transactionId)) {
226             Transaction tx = transactions[transactionId];
227             tx.executed = true;
228             if (tx.destination.call.value(tx.value)(tx.data))
229                 Execution(transactionId);
230             else {
231                 ExecutionFailure(transactionId);
232                 tx.executed = false;
233             }
234         }
235     }
236 
237     /// @dev Returns the confirmation status of a transaction.
238     /// @param transactionId Transaction ID.
239     /// @return Confirmation status.
240     function isConfirmed(uint transactionId)
241         public
242         constant
243         returns (bool)
244     {
245         uint count = 0;
246         for (uint i=0; i<owners.length; i++) {
247             if (confirmations[transactionId][owners[i]])
248                 count += 1;
249             if (count == required)
250                 return true;
251         }
252     }
253 
254     /*
255      * Internal functions
256      */
257     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
258     /// @param destination Transaction target address.
259     /// @param value Transaction ether value.
260     /// @param data Transaction data payload.
261     /// @return Returns transaction ID.
262     function addTransaction(address destination, uint value, bytes data)
263         internal
264         notNull(destination)
265         returns (uint transactionId)
266     {
267         transactionId = transactionCount;
268         transactions[transactionId] = Transaction({
269             destination: destination,
270             value: value,
271             data: data,
272             executed: false
273         });
274         transactionCount += 1;
275         Submission(transactionId);
276     }
277 
278     /*
279      * Web3 call functions
280      */
281     /// @dev Returns number of confirmations of a transaction.
282     /// @param transactionId Transaction ID.
283     /// @return Number of confirmations.
284     function getConfirmationCount(uint transactionId)
285         public
286         constant
287         returns (uint count)
288     {
289         for (uint i=0; i<owners.length; i++)
290             if (confirmations[transactionId][owners[i]])
291                 count += 1;
292     }
293 
294     /// @dev Returns total number of transactions after filers are applied.
295     /// @param pending Include pending transactions.
296     /// @param executed Include executed transactions.
297     /// @return Total number of transactions after filters are applied.
298     function getTransactionCount(bool pending, bool executed)
299         public
300         constant
301         returns (uint count)
302     {
303         for (uint i=0; i<transactionCount; i++)
304             if (   pending && !transactions[i].executed
305                 || executed && transactions[i].executed)
306                 count += 1;
307     }
308 
309     /// @dev Returns list of owners.
310     /// @return List of owner addresses.
311     function getOwners()
312         public
313         constant
314         returns (address[])
315     {
316         return owners;
317     }
318 
319     /// @dev Returns array with owner addresses, which confirmed transaction.
320     /// @param transactionId Transaction ID.
321     /// @return Returns array of owner addresses.
322     function getConfirmations(uint transactionId)
323         public
324         constant
325         returns (address[] _confirmations)
326     {
327         address[] memory confirmationsTemp = new address[](owners.length);
328         uint count = 0;
329         uint i;
330         for (i=0; i<owners.length; i++)
331             if (confirmations[transactionId][owners[i]]) {
332                 confirmationsTemp[count] = owners[i];
333                 count += 1;
334             }
335         _confirmations = new address[](count);
336         for (i=0; i<count; i++)
337             _confirmations[i] = confirmationsTemp[i];
338     }
339 
340     /// @dev Returns list of transaction IDs in defined range.
341     /// @param from Index start position of transaction array.
342     /// @param to Index end position of transaction array.
343     /// @param pending Include pending transactions.
344     /// @param executed Include executed transactions.
345     /// @return Returns array of transaction IDs.
346     function getTransactionIds(uint from, uint to, bool pending, bool executed)
347         public
348         constant
349         returns (uint[] _transactionIds)
350     {
351         uint[] memory transactionIdsTemp = new uint[](transactionCount);
352         uint count = 0;
353         uint i;
354         for (i=0; i<transactionCount; i++)
355             if (   pending && !transactions[i].executed
356                 || executed && transactions[i].executed)
357             {
358                 transactionIdsTemp[count] = i;
359                 count += 1;
360             }
361         _transactionIds = new uint[](to - from);
362         for (i=from; i<to; i++)
363             _transactionIds[i - from] = transactionIdsTemp[i];
364     }
365 }
366 
367 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
368 /// @author Stefan George - <stefan.george@consensys.net>
369 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
370 
371     event DailyLimitChange(uint dailyLimit);
372 
373     uint public dailyLimit;
374     uint public lastDay;
375     uint public spentToday;
376 
377     /*
378      * Public functions
379      */
380     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
381     /// @param _owners List of initial owners.
382     /// @param _required Number of required confirmations.
383     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
384     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
385         public
386         MultiSigWallet(_owners, _required)
387     {
388         dailyLimit = _dailyLimit;
389     }
390 
391     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
392     /// @param _dailyLimit Amount in wei.
393     function changeDailyLimit(uint _dailyLimit)
394         public
395         onlyWallet
396     {
397         dailyLimit = _dailyLimit;
398         DailyLimitChange(_dailyLimit);
399     }
400 
401     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
402     /// @param transactionId Transaction ID.
403     function executeTransaction(uint transactionId)
404         public
405         notExecuted(transactionId)
406     {
407         Transaction tx = transactions[transactionId];
408         bool confirmed = isConfirmed(transactionId);
409         if (confirmed || tx.data.length == 0 && isUnderLimit(tx.value)) {
410             tx.executed = true;
411             if (!confirmed)
412                 spentToday += tx.value;
413             if (tx.destination.call.value(tx.value)(tx.data))
414                 Execution(transactionId);
415             else {
416                 ExecutionFailure(transactionId);
417                 tx.executed = false;
418                 if (!confirmed)
419                     spentToday -= tx.value;
420             }
421         }
422     }
423 
424     /*
425      * Internal functions
426      */
427     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
428     /// @param amount Amount to withdraw.
429     /// @return Returns if amount is under daily limit.
430     function isUnderLimit(uint amount)
431         internal
432         returns (bool)
433     {
434         if (now > lastDay + 24 hours) {
435             lastDay = now;
436             spentToday = 0;
437         }
438         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
439             return false;
440         return true;
441     }
442 
443     /*
444      * Web3 call functions
445      */
446     /// @dev Returns maximum withdraw amount.
447     /// @return Returns amount.
448     function calcMaxWithdraw()
449         public
450         constant
451         returns (uint)
452     {
453         if (now > lastDay + 24 hours)
454             return dailyLimit;
455         if (dailyLimit < spentToday)
456             return 0;
457         return dailyLimit - spentToday;
458     }
459 }
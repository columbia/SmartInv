1 pragma solidity 0.4.21;
2 
3 contract MultiSigWallet {
4 
5     uint constant public MAX_OWNER_COUNT = 50;
6 
7     event Confirmation(address indexed sender, uint indexed transactionId);
8     event Revocation(address indexed sender, uint indexed transactionId);
9     event Submission(uint indexed transactionId);
10     event Execution(uint indexed transactionId, string indexed reference);
11     event ExecutionFailure(uint indexed transactionId, string indexed reference);
12     event Deposit(address indexed sender, uint value);
13     event OwnerAddition(address indexed owner);
14     event OwnerRemoval(address indexed owner);
15     event RequirementChange(uint required);
16 
17     mapping (uint => Transaction) public transactions;
18     mapping (uint => mapping (address => bool)) public confirmations;
19     mapping (address => bool) public isOwner;
20     address[] public owners;
21     uint public required;
22     uint public transactionCount;
23 
24     struct Transaction {
25         address destination;
26         uint value;
27         bytes data;
28         bool executed;
29         string reference;
30     }
31 
32     /*
33      *  Modifiers
34      */
35     modifier onlyWallet() {
36         require(msg.sender == address(this));
37         _;
38     }
39 
40     modifier ownerDoesNotExist(address owner) {
41         require(!isOwner[owner]);
42         _;
43     }
44 
45     modifier ownerExists(address owner) {
46         require(isOwner[owner]);
47         _;
48     }
49 
50     modifier transactionExists(uint transactionId) {
51         require(transactions[transactionId].destination != 0);
52         _;
53     }
54 
55     modifier confirmed(uint transactionId, address owner) {
56         require(confirmations[transactionId][owner]);
57         _;
58     }
59 
60     modifier notConfirmed(uint transactionId, address owner) {
61         require(!confirmations[transactionId][owner]);
62         _;
63     }
64 
65     modifier notExecuted(uint transactionId) {
66         require(!transactions[transactionId].executed);
67         _;
68     }
69 
70     modifier notNull(address _address) {
71         require(_address != 0);
72         _;
73     }
74 
75     modifier validRequirement(uint ownerCount, uint _required) {
76         require(ownerCount <= MAX_OWNER_COUNT
77             && _required <= ownerCount
78             && _required != 0
79             && ownerCount != 0);
80         _;
81     }
82 
83     /// @dev Fallback function allows to deposit ether.
84     function()
85         payable
86     {
87         if (msg.value > 0)
88             Deposit(msg.sender, msg.value);
89     }
90 
91     /*
92      * Public functions
93      */
94     /// @dev Contract constructor sets initial owners and required number of confirmations.
95     /// @param _owners List of initial owners.
96     /// @param _required Number of required confirmations.
97     function MultiSigWallet(address[] _owners, uint _required)
98         public
99         validRequirement(_owners.length, _required)
100     {
101         for (uint i=0; i<_owners.length; i++) {
102             if (isOwner[_owners[i]] || _owners[i] == 0)
103                 throw;
104             isOwner[_owners[i]] = true;
105         }
106         owners = _owners;
107         required = _required;
108     }
109 
110     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
111     /// @param owner Address of new owner.
112     function addOwner(address owner)
113         public
114         onlyWallet
115         ownerDoesNotExist(owner)
116         notNull(owner)
117         validRequirement(owners.length + 1, required)
118     {
119         isOwner[owner] = true;
120         owners.push(owner);
121         OwnerAddition(owner);
122     }
123 
124     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
125     /// @param owner Address of owner.
126     function removeOwner(address owner)
127         public
128         onlyWallet
129         ownerExists(owner)
130     {
131         isOwner[owner] = false;
132         for (uint i=0; i<owners.length - 1; i++)
133             if (owners[i] == owner) {
134                 owners[i] = owners[owners.length - 1];
135                 break;
136             }
137         owners.length -= 1;
138         if (required > owners.length)
139             changeRequirement(owners.length);
140         OwnerRemoval(owner);
141     }
142 
143     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
144     /// @param owner Address of owner to be replaced.
145     /// @param owner Address of new owner.
146     function replaceOwner(address owner, address newOwner)
147         public
148         onlyWallet
149         ownerExists(owner)
150         ownerDoesNotExist(newOwner)
151     {
152         for (uint i=0; i<owners.length; i++)
153             if (owners[i] == owner) {
154                 owners[i] = newOwner;
155                 break;
156             }
157         isOwner[owner] = false;
158         isOwner[newOwner] = true;
159         OwnerRemoval(owner);
160         OwnerAddition(newOwner);
161     }
162 
163     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
164     /// @param _required Number of required confirmations.
165     function changeRequirement(uint _required)
166         public
167         onlyWallet
168         validRequirement(owners.length, _required)
169     {
170         required = _required;
171         RequirementChange(_required);
172     }
173 
174     /// @dev Allows an owner to submit and confirm a transaction.
175     /// @param destination Transaction target address.
176     /// @param value Transaction ether value.
177     /// @param reference Transaction reference.
178     /// @param data Transaction data payload.
179     /// @return Returns transaction ID.
180     function submitTransaction(address destination, uint value, string reference, bytes data)
181         public
182         ownerExists(msg.sender)
183         returns (uint transactionId)
184     {
185         transactionId = addTransaction(destination, value, reference, data);
186         confirmTransaction(transactionId);
187     }
188 
189     /// @dev Allows an owner to confirm a transaction.
190     /// @param transactionId Transaction ID.
191     function confirmTransaction(uint transactionId)
192         public
193         ownerExists(msg.sender)
194         transactionExists(transactionId)
195         notConfirmed(transactionId, msg.sender)
196     {
197         confirmations[transactionId][msg.sender] = true;
198         Confirmation(msg.sender, transactionId);
199         executeTransaction(transactionId);
200     }
201 
202     /// @dev Allows an owner to revoke a confirmation for a transaction.
203     /// @param transactionId Transaction ID.
204     function revokeConfirmation(uint transactionId)
205         public
206         ownerExists(msg.sender)
207         confirmed(transactionId, msg.sender)
208         notExecuted(transactionId)
209     {
210         confirmations[transactionId][msg.sender] = false;
211         Revocation(msg.sender, transactionId);
212     }
213 
214     /// @dev Allows anyone to execute a confirmed transaction.
215     /// @param transactionId Transaction ID.
216     function executeTransaction(uint transactionId)
217         public
218         notExecuted(transactionId)
219     {
220         if (isConfirmed(transactionId)) {
221             Transaction tx = transactions[transactionId];
222             tx.executed = true;
223             if (tx.destination.call.value(tx.value)(tx.data))
224                 Execution(transactionId, tx.reference);
225             else {
226                 ExecutionFailure(transactionId, tx.reference);
227                 tx.executed = false;
228             }
229         }
230     }
231 
232     /// @dev Returns the confirmation status of a transaction.
233     /// @param transactionId Transaction ID.
234     /// @return Confirmation status.
235     function isConfirmed(uint transactionId)
236         public
237         constant
238         returns (bool)
239     {
240         uint count = 0;
241         for (uint i=0; i<owners.length; i++) {
242             if (confirmations[transactionId][owners[i]])
243                 count += 1;
244             if (count == required)
245                 return true;
246         }
247     }
248 
249     /*
250      * Internal functions
251      */
252     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
253     /// @param destination Transaction target address.
254     /// @param value Transaction ether value.
255     /// @param reference Transaction reference.
256     /// @param data Transaction data payload.
257     /// @return Returns transaction ID.
258     function addTransaction(address destination, uint value, string reference, bytes data)
259         internal
260         notNull(destination)
261         returns (uint transactionId)
262     {
263         transactionId = transactionCount;
264         transactions[transactionId] = Transaction({
265             destination: destination,
266             value: value,
267             data: data,
268             reference: reference,
269             executed: false
270         });
271         transactionCount += 1;
272         Submission(transactionId);
273     }
274 
275     /*
276      * Web3 call functions
277      */
278     /// @dev Returns number of confirmations of a transaction.
279     /// @param transactionId Transaction ID.
280     /// @return Number of confirmations.
281     function getConfirmationCount(uint transactionId)
282         public
283         constant
284         returns (uint count)
285     {
286         for (uint i=0; i<owners.length; i++)
287             if (confirmations[transactionId][owners[i]])
288                 count += 1;
289     }
290 
291     /// @dev Returns total number of transactions after filers are applied.
292     /// @param executed Transaction executed transactions.
293     /// @return Total number of transactions after filters are applied.
294     function getTransactionCount(bool executed)
295         public
296         constant
297         returns (uint count)
298     {
299         for (uint i=0; i<transactionCount; i++)
300             if ((!executed && !transactions[i].executed)
301                 || (executed && transactions[i].executed))
302                 count += 1;
303     }
304 
305     /// @dev Returns list of owners.
306     /// @return List of owner addresses.
307     function getOwners()
308         public
309         constant
310         returns (address[])
311     {
312         return owners;
313     }
314 
315     /// @dev Returns array with owner addresses, which confirmed transaction.
316     /// @param transactionId Transaction ID.
317     /// @return Returns array of owner addresses.
318     function getConfirmations(uint transactionId)
319         public
320         constant
321         returns (address[] _confirmations)
322     {
323         address[] memory confirmationsTemp = new address[](owners.length);
324         uint count = 0;
325         uint i;
326         for (i=0; i<owners.length; i++)
327             if (confirmations[transactionId][owners[i]]) {
328                 confirmationsTemp[count] = owners[i];
329                 count += 1;
330             }
331         _confirmations = new address[](count);
332         for (i=0; i<count; i++)
333             _confirmations[i] = confirmationsTemp[i];
334     }
335 
336     /// @dev Returns list of transaction IDs after filers are applied.
337     /// @param executed Transaction executed transactions.
338     /// @return Returns array of transaction IDs after filers are applied.
339     function getTransactionIds(bool executed)
340         public
341         constant
342         returns (uint[] _transactionIds)
343     {
344         uint[] memory transactionIdsTemp = new uint[](transactionCount);
345         uint count = 0;
346         uint i;
347         for (i=0; i<transactionCount; i++)
348             if ((!executed && !transactions[i].executed)
349                 || (executed && transactions[i].executed)) {
350                 transactionIdsTemp[count] = i;
351                 count += 1;
352             }
353         _transactionIds = new uint[](count);
354         for (i=0; i<count; i++) {
355             _transactionIds[i] = transactionIdsTemp[i];
356         }
357     }
358 }
359 
360 
361 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
362 
363     event DailyLimitChange(uint dailyLimit);
364 
365     uint public dailyLimit;
366     uint public lastDay;
367     uint public spentToday;
368 
369     modifier isNotZero(uint amount) {
370         require(amount > 0);
371         _;
372     }
373 
374     /*
375      * Public functions
376      */
377     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
378     /// @param _owners List of initial owners.
379     /// @param _required Number of required confirmations.
380     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
381     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
382         public
383         isNotZero(_dailyLimit)
384         MultiSigWallet(_owners, _required)
385     {
386         dailyLimit = _dailyLimit;
387     }
388 
389     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
390     /// @param _dailyLimit Amount in wei.
391     function changeDailyLimit(uint _dailyLimit)
392         public
393         onlyWallet
394         isNotZero(_dailyLimit)
395     {
396         dailyLimit = _dailyLimit;
397         DailyLimitChange(_dailyLimit);
398     }
399 
400     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
401     /// @param transactionId Transaction ID.
402     function executeTransaction(uint transactionId)
403         public
404         notExecuted(transactionId)
405     {
406         Transaction tx = transactions[transactionId];
407         bool confirmed = isConfirmed(transactionId);
408         if (confirmed || tx.data.length == 0 && isUnderLimit(tx.value)) {
409             tx.executed = true;
410             if (!confirmed)
411                 spentToday += tx.value;
412             if (tx.destination.call.value(tx.value)(tx.data))
413                 Execution(transactionId, tx.reference);
414             else {
415                 ExecutionFailure(transactionId, tx.reference);
416                 tx.executed = false;
417                 if (!confirmed)
418                     spentToday -= tx.value;
419             }
420         }
421     }
422 
423     /*
424      * Internal functions
425      */
426     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
427     /// @param amount Amount to withdraw.
428     /// @return Returns if amount is under daily limit.
429     function isUnderLimit(uint amount)
430         internal
431         returns (bool)
432     {
433         if (now > lastDay + 24 hours) {
434             lastDay = now;
435             spentToday = 0;
436         }
437         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
438             return false;
439         return true;
440     }
441 
442     /*
443      * Web3 call functions
444      */
445     /// @dev Returns maximum withdraw amount.
446     /// @return Returns amount.
447     function calcMaxWithdraw()
448         public
449         constant
450         returns (uint)
451     {
452         if (now > lastDay + 24 hours)
453             return dailyLimit;
454         if (dailyLimit < spentToday)
455             return 0;
456         return dailyLimit - spentToday;
457     }
458 }
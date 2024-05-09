1 pragma solidity ^0.4.18;
2 
3 
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
26 
27     struct Transaction {
28         address destination;
29         uint value;
30         bytes data;
31         bool executed;
32     }
33 
34     modifier onlyWallet() {
35         require(msg.sender == address(this));
36         _;
37     }
38 
39     modifier ownerDoesNotExist(address owner){
40         require(!isOwner[owner]);
41         _;
42     }
43 
44     modifier ownerExists(address owner) {
45         require(isOwner[owner]);
46         _;
47     }
48 
49     modifier transactionExists(uint transactionId) {
50         require(transactions[transactionId].destination != 0);
51         _;
52     }
53 
54     modifier confirmed(uint transactionId, address owner) {
55         require(confirmations[transactionId][owner]);
56         _;
57     }
58 
59     modifier notConfirmed(uint transactionId, address owner) {
60         require(!confirmations[transactionId][owner]);
61         _;
62     }
63 
64     modifier notExecuted(uint transactionId) {
65         require(!transactions[transactionId].executed);
66         _;
67     }
68 
69     modifier notNull(address _address) {
70         require(_address != 0);
71         _;
72     }
73 
74     modifier validRequirement(uint ownerCount, uint _required) {
75         require(ownerCount <= MAX_OWNER_COUNT);
76         require(_required <= ownerCount);
77         require(_required != 0);
78         require(ownerCount != 0);
79         _;
80     }
81         
82     /// @dev Fallback function allows to deposit ether.
83     function()
84         payable public
85     {
86         if (msg.value > 0)
87             Deposit(msg.sender, msg.value);
88     }
89 
90     /*
91      * Public functions
92      */
93     /// @dev Contract constructor sets initial owners and required number of confirmations.
94     /// @param _owners List of initial owners.
95     /// @param _required Number of required confirmations.
96     function MultiSigWallet(address[] _owners, uint _required)
97         public
98         validRequirement(_owners.length, _required)
99     {
100         for (uint i=0; i<_owners.length; i++) 
101         {
102             require(isOwner[_owners[i]] == false);
103             require(_owners[i] != 0);
104             
105             isOwner[_owners[i]] = true;
106         }
107         owners = _owners;
108         required = _required;
109     }
110 
111     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
112     /// @param owner Address of new owner.
113     function addOwner(address owner)
114         public
115         onlyWallet
116         ownerDoesNotExist(owner)
117         notNull(owner)
118         validRequirement(owners.length + 1, required)
119     {
120         isOwner[owner] = true;
121         owners.push(owner);
122         OwnerAddition(owner);
123     }
124 
125     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
126     /// @param owner Address of owner.
127     function removeOwner(address owner)
128         public
129         onlyWallet
130         ownerExists(owner)
131     {
132         isOwner[owner] = false;
133         for (uint i=0; i<owners.length - 1; i++)
134             if (owners[i] == owner) {
135                 owners[i] = owners[owners.length - 1];
136                 break;
137             }
138         owners.length -= 1;
139         if (required > owners.length)
140             changeRequirement(owners.length);
141         OwnerRemoval(owner);
142     }
143 
144     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
145     /// @param owner Address of owner to be replaced.
146     /// @param owner Address of new owner.
147     function replaceOwner(address owner, address newOwner)
148         public
149         onlyWallet
150         ownerExists(owner)
151         ownerDoesNotExist(newOwner)
152     {
153         for (uint i=0; i<owners.length; i++)
154             if (owners[i] == owner) {
155                 owners[i] = newOwner;
156                 break;
157             }
158         isOwner[owner] = false;
159         isOwner[newOwner] = true;
160         OwnerRemoval(owner);
161         OwnerAddition(newOwner);
162     }
163 
164     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
165     /// @param _required Number of required confirmations.
166     function changeRequirement(uint _required)
167         public
168         onlyWallet
169         validRequirement(owners.length, _required)
170     {
171         required = _required;
172         RequirementChange(_required);
173     }
174 
175     /// @dev Allows an owner to submit and confirm a transaction.
176     /// @param destination Transaction target address.
177     /// @param value Transaction ether value.
178     /// @param data Transaction data payload.
179     /// @return Returns transaction ID.
180     function submitTransaction(address destination, uint value, bytes data)
181         public
182         returns (uint transactionId)
183     {
184         transactionId = addTransaction(destination, value, data);
185         confirmTransaction(transactionId);
186     }
187 
188     /// @dev Allows an owner to confirm a transaction.
189     /// @param transactionId Transaction ID.
190     function confirmTransaction(uint transactionId)
191         public
192         ownerExists(msg.sender)
193         transactionExists(transactionId)
194         notConfirmed(transactionId, msg.sender)
195     {
196         confirmations[transactionId][msg.sender] = true;
197         Confirmation(msg.sender, transactionId);
198         executeTransaction(transactionId);
199     }
200 
201     /// @dev Allows an owner to revoke a confirmation for a transaction.
202     /// @param transactionId Transaction ID.
203     function revokeConfirmation(uint transactionId)
204         public
205         ownerExists(msg.sender)
206         confirmed(transactionId, msg.sender)
207         notExecuted(transactionId)
208     {
209         confirmations[transactionId][msg.sender] = false;
210         Revocation(msg.sender, transactionId);
211     }
212 
213     /// @dev Allows anyone to execute a confirmed transaction.
214     /// @param transactionId Transaction ID.
215     function executeTransaction(uint transactionId)
216         public
217         notExecuted(transactionId)
218     {
219         if (isConfirmed(transactionId)) {
220             Transaction storage txi = transactions[transactionId];
221             txi.executed = true;
222             if (txi.destination.call.value(txi.value)(txi.data))
223                 Execution(transactionId);
224             else {
225                 ExecutionFailure(transactionId);
226                 txi.executed = false;
227             }
228         }
229     }
230 
231     /// @dev Returns the confirmation status of a transaction.
232     /// @param transactionId Transaction ID.
233     /// @return Confirmation status.
234     function isConfirmed(uint transactionId)
235         public
236         constant
237         returns (bool)
238     {
239         uint count = 0;
240         for (uint i=0; i<owners.length; i++) {
241             if (confirmations[transactionId][owners[i]])
242                 count += 1;
243             if (count == required)
244                 return true;
245         }
246     }
247 
248     /*
249      * Internal functions
250      */
251     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
252     /// @param destination Transaction target address.
253     /// @param value Transaction ether value.
254     /// @param data Transaction data payload.
255     /// @return Returns transaction ID.
256     function addTransaction(address destination, uint value, bytes data)
257         internal
258         notNull(destination)
259         returns (uint transactionId)
260     {
261         transactionId = transactionCount;
262         transactions[transactionId] = Transaction({
263             destination: destination,
264             value: value,
265             data: data,
266             executed: false
267         });
268         transactionCount += 1;
269         Submission(transactionId);
270     }
271 
272     /*
273      * Web3 call functions
274      */
275     /// @dev Returns number of confirmations of a transaction.
276     /// @param transactionId Transaction ID.
277     /// @return Number of confirmations.
278     function getConfirmationCount(uint transactionId)
279         public
280         constant
281         returns (uint count)
282     {
283         for (uint i=0; i<owners.length; i++)
284             if (confirmations[transactionId][owners[i]])
285                 count += 1;
286     }
287 
288     /// @dev Returns total number of transactions after filers are applied.
289     /// @param pending Include pending transactions.
290     /// @param executed Include executed transactions.
291     /// @return Total number of transactions after filters are applied.
292     function getTransactionCount(bool pending, bool executed)
293         public
294         constant
295         returns (uint count)
296     {
297         for (uint i=0; i<transactionCount; i++)
298             if (   pending && !transactions[i].executed
299                 || executed && transactions[i].executed)
300                 count += 1;
301     }
302 
303     /// @dev Returns list of owners.
304     /// @return List of owner addresses.
305     function getOwners()
306         public
307         constant
308         returns (address[])
309     {
310         return owners;
311     }
312 
313     /// @dev Returns array with owner addresses, which confirmed transaction.
314     /// @param transactionId Transaction ID.
315     /// @return Returns array of owner addresses.
316     function getConfirmations(uint transactionId)
317         public
318         constant
319         returns (address[] _confirmations)
320     {
321         address[] memory confirmationsTemp = new address[](owners.length);
322         uint count = 0;
323         uint i;
324         for (i=0; i<owners.length; i++)
325             if (confirmations[transactionId][owners[i]]) {
326                 confirmationsTemp[count] = owners[i];
327                 count += 1;
328             }
329         _confirmations = new address[](count);
330         for (i=0; i<count; i++)
331             _confirmations[i] = confirmationsTemp[i];
332     }
333 
334     /// @dev Returns list of transaction IDs in defined range.
335     /// @param from Index start position of transaction array.
336     /// @param to Index end position of transaction array.
337     /// @param pending Include pending transactions.
338     /// @param executed Include executed transactions.
339     /// @return Returns array of transaction IDs.
340     function getTransactionIds(uint from, uint to, bool pending, bool executed)
341         public
342         constant
343         returns (uint[] _transactionIds)
344     {
345         uint[] memory transactionIdsTemp = new uint[](transactionCount);
346         uint count = 0;
347         uint i;
348         for (i=0; i<transactionCount; i++)
349             if (   pending && !transactions[i].executed
350                 || executed && transactions[i].executed)
351             {
352                 transactionIdsTemp[count] = i;
353                 count += 1;
354             }
355         _transactionIds = new uint[](to - from);
356         for (i=from; i<to; i++)
357             _transactionIds[i - from] = transactionIdsTemp[i];
358     }
359 }
360 
361 
362 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
363 /// @author Stefan George - <stefan.george@consensys.net>
364 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
365 
366     event DailyLimitChange(uint dailyLimit);
367 
368     uint public dailyLimit;
369     uint public lastDay;
370     uint public spentToday;
371 
372     /*
373      * Public functions
374      */
375     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
376     /// @param _owners List of initial owners.
377     /// @param _required Number of required confirmations.
378     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
379     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
380         public
381         MultiSigWallet(_owners, _required)
382     {
383         dailyLimit = _dailyLimit;
384     }
385 
386     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
387     /// @param _dailyLimit Amount in wei.
388     function changeDailyLimit(uint _dailyLimit)
389         public
390         onlyWallet
391     {
392         dailyLimit = _dailyLimit;
393         DailyLimitChange(_dailyLimit);
394     }
395 
396     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
397     /// @param transactionId Transaction ID.
398     function executeTransaction(uint transactionId)
399         public
400         notExecuted(transactionId)
401     {
402         Transaction storage txi = transactions[transactionId];
403         bool confirmed = isConfirmed(transactionId);
404         if (confirmed || txi.data.length == 0 && isUnderLimit(txi.value)) {
405             txi.executed = true;
406             if (!confirmed)
407                 spentToday += txi.value;
408             if (txi.destination.call.value(txi.value)(txi.data))
409                 Execution(transactionId);
410             else {
411                 ExecutionFailure(transactionId);
412                 txi.executed = false;
413                 if (!confirmed)
414                     spentToday -= txi.value;
415             }
416         }
417     }
418 
419     /*
420      * Internal functions
421      */
422     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
423     /// @param amount Amount to withdraw.
424     /// @return Returns if amount is under daily limit.
425     function isUnderLimit(uint amount)
426         internal
427         returns (bool)
428     {
429         if (now > lastDay + 24 hours) {
430             lastDay = now;
431             spentToday = 0;
432         }
433         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
434             return false;
435         return true;
436     }
437 
438     /*
439      * Web3 call functions
440      */
441     /// @dev Returns maximum withdraw amount.
442     /// @return Returns amount.
443     function calcMaxWithdraw()
444         public
445         constant
446         returns (uint)
447     {
448         if (now > lastDay + 24 hours)
449             return dailyLimit;
450         if (dailyLimit < spentToday)
451             return 0;
452         return dailyLimit - spentToday;
453     }
454 }
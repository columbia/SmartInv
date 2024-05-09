1 pragma solidity 0.4.15;
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
34         require (msg.sender == address(this));
35         _;
36     }
37 
38     modifier ownerDoesNotExist(address owner) {
39         require (!isOwner[owner]);
40         _;
41     }
42 
43     modifier ownerExists(address owner) {
44         require (isOwner[owner]);
45         _;
46     }
47 
48     modifier transactionExists(uint transactionId) {
49         require (transactions[transactionId].destination != 0);
50         _;
51     }
52 
53     modifier confirmed(uint transactionId, address owner) {
54         require (confirmations[transactionId][owner]);
55         _;
56     }
57 
58     modifier notConfirmed(uint transactionId, address owner) {
59         require (!confirmations[transactionId][owner]);
60         _;
61     }
62 
63     modifier notExecuted(uint transactionId) {
64         require (!transactions[transactionId].executed);
65         _;
66     }
67 
68     modifier notNull(address _address) {
69         require (_address != 0);
70         _;
71     }
72 
73     modifier validRequirement(uint ownerCount, uint _required) {
74         require (ownerCount <= MAX_OWNER_COUNT);
75         require (_required <= ownerCount);
76         require (_required != 0);
77         require (ownerCount != 0);
78         _;
79     }
80 
81     /// @dev Fallback function allows to deposit ether.
82     function()
83         payable
84     {
85         if (msg.value > 0)
86             Deposit(msg.sender, msg.value);
87     }
88 
89     /*
90      * Public functions
91      */
92     /// @dev Contract constructor sets initial owners and required number of confirmations.
93     /// @param _owners List of initial owners.
94     /// @param _required Number of required confirmations.
95     function MultiSigWallet(address[] _owners, uint _required)
96         public
97         validRequirement(_owners.length, _required)
98     {
99         for (uint i=0; i<_owners.length; i++) {
100             require ( !isOwner[_owners[i]]);
101             require (_owners[i] != 0);
102             isOwner[_owners[i]] = true;
103         }
104         owners = _owners;
105         required = _required;
106     }
107 
108     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
109     /// @param owner Address of new owner.
110     function addOwner(address owner)
111         public
112         onlyWallet
113         ownerDoesNotExist(owner)
114         notNull(owner)
115         validRequirement(owners.length + 1, required)
116     {
117         isOwner[owner] = true;
118         owners.push(owner);
119         OwnerAddition(owner);
120     }
121 
122     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
123     /// @param owner Address of owner.
124     function removeOwner(address owner)
125         public
126         onlyWallet
127         ownerExists(owner)
128     {
129         isOwner[owner] = false;
130         for (uint i=0; i<owners.length - 1; i++)
131             if (owners[i] == owner) {
132                 owners[i] = owners[owners.length - 1];
133                 break;
134             }
135         owners.length -= 1;
136         if (required > owners.length)
137             changeRequirement(owners.length);
138         OwnerRemoval(owner);
139     }
140 
141     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
142     /// @param owner Address of owner to be replaced.
143     /// @param owner Address of new owner.
144     function replaceOwner(address owner, address newOwner)
145         public
146         onlyWallet
147         ownerExists(owner)
148         ownerDoesNotExist(newOwner)
149     {
150         for (uint i=0; i<owners.length; i++)
151             if (owners[i] == owner) {
152                 owners[i] = newOwner;
153                 break;
154             }
155         isOwner[owner] = false;
156         isOwner[newOwner] = true;
157         OwnerRemoval(owner);
158         OwnerAddition(newOwner);
159     }
160 
161     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
162     /// @param _required Number of required confirmations.
163     function changeRequirement(uint _required)
164         public
165         onlyWallet
166         validRequirement(owners.length, _required)
167     {
168         required = _required;
169         RequirementChange(_required);
170     }
171 
172     /// @dev Allows an owner to submit and confirm a transaction.
173     /// @param destination Transaction target address.
174     /// @param value Transaction ether value.
175     /// @param data Transaction data payload.
176     /// @return Returns transaction ID.
177     function submitTransaction(address destination, uint value, bytes data)
178         public
179         returns (uint transactionId)
180     {
181         transactionId = addTransaction(destination, value, data);
182         confirmTransaction(transactionId);
183     }
184 
185     /// @dev Allows an owner to confirm a transaction.
186     /// @param transactionId Transaction ID.
187     function confirmTransaction(uint transactionId)
188         public
189         ownerExists(msg.sender)
190         transactionExists(transactionId)
191         notConfirmed(transactionId, msg.sender)
192     {
193         confirmations[transactionId][msg.sender] = true;
194         Confirmation(msg.sender, transactionId);
195         executeTransaction(transactionId);
196     }
197 
198     /// @dev Allows an owner to revoke a confirmation for a transaction.
199     /// @param transactionId Transaction ID.
200     function revokeConfirmation(uint transactionId)
201         public
202         ownerExists(msg.sender)
203         confirmed(transactionId, msg.sender)
204         notExecuted(transactionId)
205     {
206         confirmations[transactionId][msg.sender] = false;
207         Revocation(msg.sender, transactionId);
208     }
209 
210     /// @dev Allows anyone to execute a confirmed transaction.
211     /// @param transactionId Transaction ID.
212     function executeTransaction(uint transactionId)
213         public
214         notExecuted(transactionId)
215     {
216         if (isConfirmed(transactionId)) {
217             Transaction storage txn = transactions[transactionId];
218             txn.executed = true;
219             if (txn.destination.call.value(txn.value)(txn.data))
220                 Execution(transactionId);
221             else {
222                 ExecutionFailure(transactionId);
223                 txn.executed = false;
224             }
225         }
226     }
227 
228     /// @dev Returns the confirmation status of a transaction.
229     /// @param transactionId Transaction ID.
230     /// @return Confirmation status.
231     function isConfirmed(uint transactionId)
232         public
233         constant
234         returns (bool)
235     {
236         uint count = 0;
237         for (uint i=0; i<owners.length; i++) {
238             if (confirmations[transactionId][owners[i]])
239                 count += 1;
240             if (count == required)
241                 return true;
242         }
243     }
244 
245     /*
246      * Internal functions
247      */
248     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
249     /// @param destination Transaction target address.
250     /// @param value Transaction ether value.
251     /// @param data Transaction data payload.
252     /// @return Returns transaction ID.
253     function addTransaction(address destination, uint value, bytes data)
254         internal
255         notNull(destination)
256         returns (uint transactionId)
257     {
258         transactionId = transactionCount;
259         transactions[transactionId] = Transaction({
260             destination: destination,
261             value: value,
262             data: data,
263             executed: false
264         });
265         transactionCount += 1;
266         Submission(transactionId);
267     }
268 
269     /*
270      * Web3 call functions
271      */
272     /// @dev Returns number of confirmations of a transaction.
273     /// @param transactionId Transaction ID.
274     /// @return Number of confirmations.
275     function getConfirmationCount(uint transactionId)
276         public
277         constant
278         returns (uint count)
279     {
280         for (uint i=0; i<owners.length; i++)
281             if (confirmations[transactionId][owners[i]])
282                 count += 1;
283     }
284 
285     /// @dev Returns total number of transactions after filers are applied.
286     /// @param pending Include pending transactions.
287     /// @param executed Include executed transactions.
288     /// @return Total number of transactions after filters are applied.
289     function getTransactionCount(bool pending, bool executed)
290         public
291         constant
292         returns (uint count)
293     {
294         for (uint i=0; i<transactionCount; i++)
295             if (   pending && !transactions[i].executed
296                 || executed && transactions[i].executed)
297                 count += 1;
298     }
299 
300     /// @dev Returns list of owners.
301     /// @return List of owner addresses.
302     function getOwners()
303         public
304         constant
305         returns (address[])
306     {
307         return owners;
308     }
309 
310     /// @dev Returns array with owner addresses, which confirmed transaction.
311     /// @param transactionId Transaction ID.
312     /// @return Returns array of owner addresses.
313     function getConfirmations(uint transactionId)
314         public
315         constant
316         returns (address[] _confirmations)
317     {
318         address[] memory confirmationsTemp = new address[](owners.length);
319         uint count = 0;
320         uint i;
321         for (i=0; i<owners.length; i++)
322             if (confirmations[transactionId][owners[i]]) {
323                 confirmationsTemp[count] = owners[i];
324                 count += 1;
325             }
326         _confirmations = new address[](count);
327         for (i=0; i<count; i++)
328             _confirmations[i] = confirmationsTemp[i];
329     }
330 
331     /// @dev Returns list of transaction IDs in defined range.
332     /// @param from Index start position of transaction array.
333     /// @param to Index end position of transaction array.
334     /// @param pending Include pending transactions.
335     /// @param executed Include executed transactions.
336     /// @return Returns array of transaction IDs.
337     function getTransactionIds(uint from, uint to, bool pending, bool executed)
338         public
339         constant
340         returns (uint[] _transactionIds)
341     {
342         uint[] memory transactionIdsTemp = new uint[](transactionCount);
343         uint count = 0;
344         uint i;
345         for (i=0; i<transactionCount; i++)
346             if (   pending && !transactions[i].executed
347                 || executed && transactions[i].executed)
348             {
349                 transactionIdsTemp[count] = i;
350                 count += 1;
351             }
352         _transactionIds = new uint[](to - from);
353         for (i=from; i<to; i++)
354             _transactionIds[i - from] = transactionIdsTemp[i];
355     }
356 }
357 
358 
359 
360 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
361 /// @author Stefan George - <stefan.george@consensys.net>
362 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
363 
364     event DailyLimitChange(uint dailyLimit);
365 
366     uint public dailyLimit;
367     uint public lastDay;
368     uint public spentToday;
369 
370     /*
371      * Public functions
372      */
373     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
374     /// @param _owners List of initial owners.
375     /// @param _required Number of required confirmations.
376     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
377     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
378         public
379         MultiSigWallet(_owners, _required)
380     {
381         dailyLimit = _dailyLimit;
382     }
383 
384     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
385     /// @param _dailyLimit Amount in wei.
386     function changeDailyLimit(uint _dailyLimit)
387         public
388         onlyWallet
389     {
390         dailyLimit = _dailyLimit;
391         DailyLimitChange(_dailyLimit);
392     }
393 
394     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
395     /// @param transactionId Transaction ID.
396     function executeTransaction(uint transactionId)
397         public
398         notExecuted(transactionId)
399     {
400         Transaction storage txn = transactions[transactionId];
401         bool confirmed = isConfirmed(transactionId);
402         if (confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
403             txn.executed = true;
404             if (!confirmed)
405                 spentToday += txn.value;
406             if (txn.destination.call.value(txn.value)(txn.data))
407                 Execution(transactionId);
408             else {
409                 ExecutionFailure(transactionId);
410                 txn.executed = false;
411                 if (!confirmed)
412                     spentToday -= txn.value;
413             }
414         }
415     }
416 
417     /*
418      * Internal functions
419      */
420     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
421     /// @param amount Amount to withdraw.
422     /// @return Returns if amount is under daily limit.
423     function isUnderLimit(uint amount)
424         internal
425         returns (bool)
426     {
427         if (now > lastDay + 24 hours) {
428             lastDay = now;
429             spentToday = 0;
430         }
431         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
432             return false;
433         return true;
434     }
435 
436     /*
437      * Web3 call functions
438      */
439     /// @dev Returns maximum withdraw amount.
440     /// @return Returns amount.
441     function calcMaxWithdraw()
442         public
443         constant
444         returns (uint)
445     {
446         if (now > lastDay + 24 hours)
447             return dailyLimit;
448         if (dailyLimit < spentToday)
449             return 0;
450         return dailyLimit - spentToday;
451     }
452 }
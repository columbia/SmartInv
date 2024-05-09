1 pragma solidity 0.4.15;
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
35         require (msg.sender == address(this));
36         _;
37     }
38 
39     modifier ownerDoesNotExist(address owner) {
40         require (!isOwner[owner]);
41         _;
42     }
43 
44     modifier ownerExists(address owner) {
45         require (isOwner[owner]);
46         _;
47     }
48 
49     modifier transactionExists(uint transactionId) {
50         require (transactions[transactionId].destination != 0);
51         _;
52     }
53 
54     modifier confirmed(uint transactionId, address owner) {
55         require (confirmations[transactionId][owner]);
56         _;
57     }
58 
59     modifier notConfirmed(uint transactionId, address owner) {
60         require (!confirmations[transactionId][owner]);
61         _;
62     }
63 
64     modifier notExecuted(uint transactionId) {
65         require (!transactions[transactionId].executed);
66         _;
67     }
68 
69     modifier notNull(address _address) {
70         require (_address != 0);
71         _;
72     }
73 
74     modifier validRequirement(uint ownerCount, uint _required) {
75         require (ownerCount <= MAX_OWNER_COUNT);
76         require (_required <= ownerCount);
77         require (_required != 0);
78         require (ownerCount != 0);
79         _;
80     }
81 
82     /// @dev Fallback function allows to deposit ether.
83     function()
84         payable
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
100         for (uint i=0; i<_owners.length; i++) {
101             require ( !isOwner[_owners[i]]);
102             require (_owners[i] != 0);
103             isOwner[_owners[i]] = true;
104         }
105         owners = _owners;
106         required = _required;
107     }
108 
109     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
110     /// @param owner Address of new owner.
111     function addOwner(address owner)
112         public
113         onlyWallet
114         ownerDoesNotExist(owner)
115         notNull(owner)
116         validRequirement(owners.length + 1, required)
117     {
118         isOwner[owner] = true;
119         owners.push(owner);
120         OwnerAddition(owner);
121     }
122 
123     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
124     /// @param owner Address of owner.
125     function removeOwner(address owner)
126         public
127         onlyWallet
128         ownerExists(owner)
129     {
130         isOwner[owner] = false;
131         for (uint i=0; i<owners.length - 1; i++)
132             if (owners[i] == owner) {
133                 owners[i] = owners[owners.length - 1];
134                 break;
135             }
136         owners.length -= 1;
137         if (required > owners.length)
138             changeRequirement(owners.length);
139         OwnerRemoval(owner);
140     }
141 
142     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
143     /// @param owner Address of owner to be replaced.
144     /// @param owner Address of new owner.
145     function replaceOwner(address owner, address newOwner)
146         public
147         onlyWallet
148         ownerExists(owner)
149         ownerDoesNotExist(newOwner)
150     {
151         for (uint i=0; i<owners.length; i++)
152             if (owners[i] == owner) {
153                 owners[i] = newOwner;
154                 break;
155             }
156         isOwner[owner] = false;
157         isOwner[newOwner] = true;
158         OwnerRemoval(owner);
159         OwnerAddition(newOwner);
160     }
161 
162     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
163     /// @param _required Number of required confirmations.
164     function changeRequirement(uint _required)
165         public
166         onlyWallet
167         validRequirement(owners.length, _required)
168     {
169         required = _required;
170         RequirementChange(_required);
171     }
172 
173     /// @dev Allows an owner to submit and confirm a transaction.
174     /// @param destination Transaction target address.
175     /// @param value Transaction ether value.
176     /// @param data Transaction data payload.
177     /// @return Returns transaction ID.
178     function submitTransaction(address destination, uint value, bytes data)
179         public
180         returns (uint transactionId)
181     {
182         transactionId = addTransaction(destination, value, data);
183         confirmTransaction(transactionId);
184     }
185 
186     /// @dev Allows an owner to confirm a transaction.
187     /// @param transactionId Transaction ID.
188     function confirmTransaction(uint transactionId)
189         public
190         ownerExists(msg.sender)
191         transactionExists(transactionId)
192         notConfirmed(transactionId, msg.sender)
193     {
194         confirmations[transactionId][msg.sender] = true;
195         Confirmation(msg.sender, transactionId);
196         executeTransaction(transactionId);
197     }
198 
199     /// @dev Allows an owner to revoke a confirmation for a transaction.
200     /// @param transactionId Transaction ID.
201     function revokeConfirmation(uint transactionId)
202         public
203         ownerExists(msg.sender)
204         confirmed(transactionId, msg.sender)
205         notExecuted(transactionId)
206     {
207         confirmations[transactionId][msg.sender] = false;
208         Revocation(msg.sender, transactionId);
209     }
210 
211     /// @dev Allows anyone to execute a confirmed transaction.
212     /// @param transactionId Transaction ID.
213     function executeTransaction(uint transactionId)
214         public
215         notExecuted(transactionId)
216     {
217         if (isConfirmed(transactionId)) {
218             Transaction storage txn = transactions[transactionId];
219             txn.executed = true;
220             if (txn.destination.call.value(txn.value)(txn.data))
221                 Execution(transactionId);
222             else {
223                 ExecutionFailure(transactionId);
224                 txn.executed = false;
225             }
226         }
227     }
228 
229     /// @dev Returns the confirmation status of a transaction.
230     /// @param transactionId Transaction ID.
231     /// @return Confirmation status.
232     function isConfirmed(uint transactionId)
233         public
234         constant
235         returns (bool)
236     {
237         uint count = 0;
238         for (uint i=0; i<owners.length; i++) {
239             if (confirmations[transactionId][owners[i]])
240                 count += 1;
241             if (count == required)
242                 return true;
243         }
244     }
245 
246     /*
247      * Internal functions
248      */
249     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
250     /// @param destination Transaction target address.
251     /// @param value Transaction ether value.
252     /// @param data Transaction data payload.
253     /// @return Returns transaction ID.
254     function addTransaction(address destination, uint value, bytes data)
255         internal
256         notNull(destination)
257         returns (uint transactionId)
258     {
259         transactionId = transactionCount;
260         transactions[transactionId] = Transaction({
261             destination: destination,
262             value: value,
263             data: data,
264             executed: false
265         });
266         transactionCount += 1;
267         Submission(transactionId);
268     }
269 
270     /*
271      * Web3 call functions
272      */
273     /// @dev Returns number of confirmations of a transaction.
274     /// @param transactionId Transaction ID.
275     /// @return Number of confirmations.
276     function getConfirmationCount(uint transactionId)
277         public
278         constant
279         returns (uint count)
280     {
281         for (uint i=0; i<owners.length; i++)
282             if (confirmations[transactionId][owners[i]])
283                 count += 1;
284     }
285 
286     /// @dev Returns total number of transactions after filers are applied.
287     /// @param pending Include pending transactions.
288     /// @param executed Include executed transactions.
289     /// @return Total number of transactions after filters are applied.
290     function getTransactionCount(bool pending, bool executed)
291         public
292         constant
293         returns (uint count)
294     {
295         for (uint i=0; i<transactionCount; i++)
296             if (   pending && !transactions[i].executed
297                 || executed && transactions[i].executed)
298                 count += 1;
299     }
300 
301     /// @dev Returns list of owners.
302     /// @return List of owner addresses.
303     function getOwners()
304         public
305         constant
306         returns (address[])
307     {
308         return owners;
309     }
310 
311     /// @dev Returns array with owner addresses, which confirmed transaction.
312     /// @param transactionId Transaction ID.
313     /// @return Returns array of owner addresses.
314     function getConfirmations(uint transactionId)
315         public
316         constant
317         returns (address[] _confirmations)
318     {
319         address[] memory confirmationsTemp = new address[](owners.length);
320         uint count = 0;
321         uint i;
322         for (i=0; i<owners.length; i++)
323             if (confirmations[transactionId][owners[i]]) {
324                 confirmationsTemp[count] = owners[i];
325                 count += 1;
326             }
327         _confirmations = new address[](count);
328         for (i=0; i<count; i++)
329             _confirmations[i] = confirmationsTemp[i];
330     }
331 
332     /// @dev Returns list of transaction IDs in defined range.
333     /// @param from Index start position of transaction array.
334     /// @param to Index end position of transaction array.
335     /// @param pending Include pending transactions.
336     /// @param executed Include executed transactions.
337     /// @return Returns array of transaction IDs.
338     function getTransactionIds(uint from, uint to, bool pending, bool executed)
339         public
340         constant
341         returns (uint[] _transactionIds)
342     {
343         uint[] memory transactionIdsTemp = new uint[](transactionCount);
344         uint count = 0;
345         uint i;
346         for (i=0; i<transactionCount; i++)
347             if (   pending && !transactions[i].executed
348                 || executed && transactions[i].executed)
349             {
350                 transactionIdsTemp[count] = i;
351                 count += 1;
352             }
353         _transactionIds = new uint[](to - from);
354         for (i=from; i<to; i++)
355             _transactionIds[i - from] = transactionIdsTemp[i];
356     }
357 }
358 
359 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
360 /// @author Stefan George - <stefan.george@consensys.net>
361 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
362 
363     event DailyLimitChange(uint dailyLimit);
364 
365     uint public dailyLimit;
366     uint public lastDay;
367     uint public spentToday;
368 
369     /*
370      * Public functions
371      */
372     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
373     /// @param _owners List of initial owners.
374     /// @param _required Number of required confirmations.
375     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
376     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
377         public
378         MultiSigWallet(_owners, _required)
379     {
380         dailyLimit = _dailyLimit;
381     }
382 
383     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
384     /// @param _dailyLimit Amount in wei.
385     function changeDailyLimit(uint _dailyLimit)
386         public
387         onlyWallet
388     {
389         dailyLimit = _dailyLimit;
390         DailyLimitChange(_dailyLimit);
391     }
392 
393     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
394     /// @param transactionId Transaction ID.
395     function executeTransaction(uint transactionId)
396         public
397         notExecuted(transactionId)
398     {
399         Transaction storage txn = transactions[transactionId];
400         bool confirmed = isConfirmed(transactionId);
401         if (confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
402             txn.executed = true;
403             if (!confirmed)
404                 spentToday += txn.value;
405             if (txn.destination.call.value(txn.value)(txn.data))
406                 Execution(transactionId);
407             else {
408                 ExecutionFailure(transactionId);
409                 txn.executed = false;
410                 if (!confirmed)
411                     spentToday -= txn.value;
412             }
413         }
414     }
415 
416     /*
417      * Internal functions
418      */
419     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
420     /// @param amount Amount to withdraw.
421     /// @return Returns if amount is under daily limit.
422     function isUnderLimit(uint amount)
423         internal
424         returns (bool)
425     {
426         if (now > lastDay + 24 hours) {
427             lastDay = now;
428             spentToday = 0;
429         }
430         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
431             return false;
432         return true;
433     }
434 
435     /*
436      * Web3 call functions
437      */
438     /// @dev Returns maximum withdraw amount.
439     /// @return Returns amount.
440     function calcMaxWithdraw()
441         public
442         constant
443         returns (uint)
444     {
445         if (now > lastDay + 24 hours)
446             return dailyLimit;
447         if (dailyLimit < spentToday)
448             return 0;
449         return dailyLimit - spentToday;
450     }
451 }
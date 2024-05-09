1 pragma solidity 0.4.18;
2 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
3 /// @author Stefan George - <stefan.george@consensys.net>
4 contract MultiSigWallet {
5 
6     /*
7      *  Events
8      */
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
19     /*
20      *  Constants
21      */
22     uint constant public MAX_OWNER_COUNT = 50;
23 
24     /*
25      *  Storage
26      */
27     mapping (uint => Transaction) public transactions;
28     mapping (uint => mapping (address => bool)) public confirmations;
29     mapping (address => bool) public isOwner;
30     address[] public owners;
31     uint public required;
32     uint public transactionCount;
33 
34     struct Transaction {
35         address destination;
36         uint value;
37         bytes data;
38         bool executed;
39     }
40 
41     /*
42      *  Modifiers
43      */
44     modifier onlyWallet() {
45         require(msg.sender == address(this));
46         _;
47     }
48 
49     modifier ownerDoesNotExist(address owner) {
50         require(!isOwner[owner]);
51         _;
52     }
53 
54     modifier ownerExists(address owner) {
55         require(isOwner[owner]);
56         _;
57     }
58 
59     modifier transactionExists(uint transactionId) {
60         require(transactions[transactionId].destination != 0);
61         _;
62     }
63 
64     modifier confirmed(uint transactionId, address owner) {
65         require(confirmations[transactionId][owner]);
66         _;
67     }
68 
69     modifier notConfirmed(uint transactionId, address owner) {
70         require(!confirmations[transactionId][owner]);
71         _;
72     }
73 
74     modifier notExecuted(uint transactionId) {
75         require(!transactions[transactionId].executed);
76         _;
77     }
78 
79     modifier notNull(address _address) {
80         require(_address != 0);
81         _;
82     }
83 
84     modifier validRequirement(uint ownerCount, uint _required) {
85         require(ownerCount <= MAX_OWNER_COUNT
86             && _required <= ownerCount
87             && _required != 0
88             && ownerCount != 0);
89         _;
90     }
91 
92     /// @dev Fallback function allows to deposit ether.
93     function()
94         payable
95     {
96         if (msg.value > 0)
97             Deposit(msg.sender, msg.value);
98     }
99 
100     /*
101      * Public functions
102      */
103     /// @dev Contract constructor sets initial owners and required number of confirmations.
104     /// @param _owners List of initial owners.
105     /// @param _required Number of required confirmations.
106     function MultiSigWallet(address[] _owners, uint _required)
107         public
108         validRequirement(_owners.length, _required)
109     {
110         for (uint i=0; i<_owners.length; i++) {
111             require(!isOwner[_owners[i]] && _owners[i] != 0);
112             isOwner[_owners[i]] = true;
113         }
114         owners = _owners;
115         required = _required;
116     }
117 
118     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
119     /// @param owner Address of new owner.
120     function addOwner(address owner)
121         public
122         onlyWallet
123         ownerDoesNotExist(owner)
124         notNull(owner)
125         validRequirement(owners.length + 1, required)
126     {
127         isOwner[owner] = true;
128         owners.push(owner);
129         OwnerAddition(owner);
130     }
131 
132     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
133     /// @param owner Address of owner.
134     function removeOwner(address owner)
135         public
136         onlyWallet
137         ownerExists(owner)
138     {
139         isOwner[owner] = false;
140         for (uint i=0; i<owners.length - 1; i++)
141             if (owners[i] == owner) {
142                 owners[i] = owners[owners.length - 1];
143                 break;
144             }
145         owners.length -= 1;
146         if (required > owners.length)
147             changeRequirement(owners.length);
148         OwnerRemoval(owner);
149     }
150 
151     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
152     /// @param owner Address of owner to be replaced.
153     /// @param newOwner Address of new owner.
154     function replaceOwner(address owner, address newOwner)
155         public
156         onlyWallet
157         ownerExists(owner)
158         ownerDoesNotExist(newOwner)
159     {
160         for (uint i=0; i<owners.length; i++)
161             if (owners[i] == owner) {
162                 owners[i] = newOwner;
163                 break;
164             }
165         isOwner[owner] = false;
166         isOwner[newOwner] = true;
167         OwnerRemoval(owner);
168         OwnerAddition(newOwner);
169     }
170 
171     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
172     /// @param _required Number of required confirmations.
173     function changeRequirement(uint _required)
174         public
175         onlyWallet
176         validRequirement(owners.length, _required)
177     {
178         required = _required;
179         RequirementChange(_required);
180     }
181 
182     /// @dev Allows an owner to submit and confirm a transaction.
183     /// @param destination Transaction target address.
184     /// @param value Transaction ether value.
185     /// @param data Transaction data payload.
186     /// @return Returns transaction ID.
187     function submitTransaction(address destination, uint value, bytes data)
188         public
189         returns (uint transactionId)
190     {
191         transactionId = addTransaction(destination, value, data);
192         confirmTransaction(transactionId);
193     }
194 
195     /// @dev Allows an owner to confirm a transaction.
196     /// @param transactionId Transaction ID.
197     function confirmTransaction(uint transactionId)
198         public
199         ownerExists(msg.sender)
200         transactionExists(transactionId)
201         notConfirmed(transactionId, msg.sender)
202     {
203         confirmations[transactionId][msg.sender] = true;
204         Confirmation(msg.sender, transactionId);
205         executeTransaction(transactionId);
206     }
207 
208     /// @dev Allows an owner to revoke a confirmation for a transaction.
209     /// @param transactionId Transaction ID.
210     function revokeConfirmation(uint transactionId)
211         public
212         ownerExists(msg.sender)
213         confirmed(transactionId, msg.sender)
214         notExecuted(transactionId)
215     {
216         confirmations[transactionId][msg.sender] = false;
217         Revocation(msg.sender, transactionId);
218     }
219 
220     /// @dev Allows anyone to execute a confirmed transaction.
221     /// @param transactionId Transaction ID.
222     function executeTransaction(uint transactionId)
223         public
224         ownerExists(msg.sender)
225         confirmed(transactionId, msg.sender)
226         notExecuted(transactionId)
227     {
228         if (isConfirmed(transactionId)) {
229             Transaction storage txn = transactions[transactionId];
230             txn.executed = true;
231             if (txn.destination.call.value(txn.value)(txn.data))
232                 Execution(transactionId);
233             else {
234                 ExecutionFailure(transactionId);
235                 txn.executed = false;
236             }
237         }
238     }
239 
240     /// @dev Returns the confirmation status of a transaction.
241     /// @param transactionId Transaction ID.
242     /// @return Confirmation status.
243     function isConfirmed(uint transactionId)
244         public
245         constant
246         returns (bool)
247     {
248         uint count = 0;
249         for (uint i=0; i<owners.length; i++) {
250             if (confirmations[transactionId][owners[i]])
251                 count += 1;
252             if (count == required)
253                 return true;
254         }
255     }
256 
257     /*
258      * Internal functions
259      */
260     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
261     /// @param destination Transaction target address.
262     /// @param value Transaction ether value.
263     /// @param data Transaction data payload.
264     /// @return Returns transaction ID.
265     function addTransaction(address destination, uint value, bytes data)
266         internal
267         notNull(destination)
268         returns (uint transactionId)
269     {
270         transactionId = transactionCount;
271         transactions[transactionId] = Transaction({
272             destination: destination,
273             value: value,
274             data: data,
275             executed: false
276         });
277         transactionCount += 1;
278         Submission(transactionId);
279     }
280 
281     /*
282      * Web3 call functions
283      */
284     /// @dev Returns number of confirmations of a transaction.
285     /// @param transactionId Transaction ID.
286     /// @return Number of confirmations.
287     function getConfirmationCount(uint transactionId)
288         public
289         constant
290         returns (uint count)
291     {
292         for (uint i=0; i<owners.length; i++)
293             if (confirmations[transactionId][owners[i]])
294                 count += 1;
295     }
296 
297     /// @dev Returns total number of transactions after filers are applied.
298     /// @param pending Include pending transactions.
299     /// @param executed Include executed transactions.
300     /// @return Total number of transactions after filters are applied.
301     function getTransactionCount(bool pending, bool executed)
302         public
303         constant
304         returns (uint count)
305     {
306         for (uint i=0; i<transactionCount; i++)
307             if (   pending && !transactions[i].executed
308                 || executed && transactions[i].executed)
309                 count += 1;
310     }
311 
312     /// @dev Returns list of owners.
313     /// @return List of owner addresses.
314     function getOwners()
315         public
316         constant
317         returns (address[])
318     {
319         return owners;
320     }
321 
322     /// @dev Returns array with owner addresses, which confirmed transaction.
323     /// @param transactionId Transaction ID.
324     /// @return Returns array of owner addresses.
325     function getConfirmations(uint transactionId)
326         public
327         constant
328         returns (address[] _confirmations)
329     {
330         address[] memory confirmationsTemp = new address[](owners.length);
331         uint count = 0;
332         uint i;
333         for (i=0; i<owners.length; i++)
334             if (confirmations[transactionId][owners[i]]) {
335                 confirmationsTemp[count] = owners[i];
336                 count += 1;
337             }
338         _confirmations = new address[](count);
339         for (i=0; i<count; i++)
340             _confirmations[i] = confirmationsTemp[i];
341     }
342 
343     /// @dev Returns list of transaction IDs in defined range.
344     /// @param from Index start position of transaction array.
345     /// @param to Index end position of transaction array.
346     /// @param pending Include pending transactions.
347     /// @param executed Include executed transactions.
348     /// @return Returns array of transaction IDs.
349     function getTransactionIds(uint from, uint to, bool pending, bool executed)
350         public
351         constant
352         returns (uint[] _transactionIds)
353     {
354         uint[] memory transactionIdsTemp = new uint[](transactionCount);
355         uint count = 0;
356         uint i;
357         for (i=0; i<transactionCount; i++)
358             if (   pending && !transactions[i].executed
359                 || executed && transactions[i].executed)
360             {
361                 transactionIdsTemp[count] = i;
362                 count += 1;
363             }
364         _transactionIds = new uint[](to - from);
365         for (i=from; i<to; i++)
366             _transactionIds[i - from] = transactionIdsTemp[i];
367     }
368 }
369 
370 
371 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
372 /// @author Stefan George - <stefan.george@consensys.net>
373 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
374 
375     /*
376      *  Events
377      */
378     event DailyLimitChange(uint dailyLimit);
379 
380     /*
381      *  Storage
382      */
383     uint public dailyLimit;
384     uint public lastDay;
385     uint public spentToday;
386 
387     /*
388      * Public functions
389      */
390     /// @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
391     /// @param _owners List of initial owners.
392     /// @param _required Number of required confirmations.
393     /// @param _dailyLimit Amount in wei, which can be withdrawn without confirmations on a daily basis.
394     function MultiSigWalletWithDailyLimit(address[] _owners, uint _required, uint _dailyLimit)
395         public
396         MultiSigWallet(_owners, _required)
397     {
398         dailyLimit = _dailyLimit;
399     }
400 
401     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
402     /// @param _dailyLimit Amount in wei.
403     function changeDailyLimit(uint _dailyLimit)
404         public
405         onlyWallet
406     {
407         dailyLimit = _dailyLimit;
408         DailyLimitChange(_dailyLimit);
409     }
410 
411     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
412     /// @param transactionId Transaction ID.
413     function executeTransaction(uint transactionId)
414         public
415         ownerExists(msg.sender)
416         confirmed(transactionId, msg.sender)
417         notExecuted(transactionId)
418     {
419         Transaction storage txn = transactions[transactionId];
420         bool _confirmed = isConfirmed(transactionId);
421         if (_confirmed || txn.data.length == 0 && isUnderLimit(txn.value)) {
422             txn.executed = true;
423             if (!_confirmed)
424                 spentToday += txn.value;
425             if (txn.destination.call.value(txn.value)(txn.data))
426                 Execution(transactionId);
427             else {
428                 ExecutionFailure(transactionId);
429                 txn.executed = false;
430                 if (!_confirmed)
431                     spentToday -= txn.value;
432             }
433         }
434     }
435 
436     /*
437      * Internal functions
438      */
439     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
440     /// @param amount Amount to withdraw.
441     /// @return Returns if amount is under daily limit.
442     function isUnderLimit(uint amount)
443         internal
444         returns (bool)
445     {
446         if (now > lastDay + 24 hours) {
447             lastDay = now;
448             spentToday = 0;
449         }
450         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
451             return false;
452         return true;
453     }
454 
455     /*
456      * Web3 call functions
457      */
458     /// @dev Returns maximum withdraw amount.
459     /// @return Returns amount.
460     function calcMaxWithdraw()
461         public
462         constant
463         returns (uint)
464     {
465         if (now > lastDay + 24 hours)
466             return dailyLimit;
467         if (dailyLimit < spentToday)
468             return 0;
469         return dailyLimit - spentToday;
470     }
471 }
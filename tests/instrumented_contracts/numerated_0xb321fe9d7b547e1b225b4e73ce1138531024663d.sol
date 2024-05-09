1 pragma solidity 0.4.18;
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
14 
15     event ExecutionFailure(uint indexed transactionId);
16     event Deposit(address indexed sender, uint value);
17     event OwnerAddition(address indexed owner);
18     event OwnerRemoval(address indexed owner);
19     event RequirementChange(uint required);
20 
21     /*
22      *  Constants
23      */
24     uint constant public MAX_OWNER_COUNT = 10;
25 
26     /*
27      *  Storage
28      */
29     uint public required = 5;
30 
31     mapping (uint => Transaction) public transactions;
32     mapping (uint => mapping (address => bool)) public confirmations;
33     mapping (address => bool) public isOwner;
34     address[] public owners;
35     uint public transactionCount;
36 
37     struct Transaction {
38         address destination;
39         uint value;
40         bytes data;
41         bool executed;
42     }
43 
44     /*
45      *  Modifiers
46      */
47     modifier onlyWallet() {
48         if (msg.sender != address(this))
49             throw;
50         _;
51     }
52 
53     modifier ownerDoesNotExist(address owner) {
54         if (isOwner[owner])
55             throw;
56         _;
57     }
58 
59     modifier ownerExists(address owner) {
60         if (!isOwner[owner])
61             throw;
62         _;
63     }
64 
65     modifier transactionExists(uint transactionId) {
66         if (transactions[transactionId].destination == 0)
67             throw;
68         _;
69     }
70 
71     modifier confirmed(uint transactionId, address owner) {
72         if (!confirmations[transactionId][owner])
73             throw;
74         _;
75     }
76 
77     modifier notConfirmed(uint transactionId, address owner) {
78         if (confirmations[transactionId][owner])
79             throw;
80         _;
81     }
82 
83     modifier notExecuted(uint transactionId) {
84         if (transactions[transactionId].executed)
85             throw;
86         _;
87     }
88 
89     modifier notNull(address _address) {
90         if (_address == 0)
91             throw;
92         _;
93     }
94     
95     modifier validRequirement(uint ownerCount, uint _required) {
96         if (   ownerCount > MAX_OWNER_COUNT
97             || _required > ownerCount
98             || _required == 0
99             || ownerCount == 0)
100             throw;
101         _;
102     }
103     
104     /// @dev Fallback function allows to deposit ether.
105     function()
106         payable
107     {
108         if (msg.value > 0)
109             Deposit(msg.sender, msg.value);
110     }
111 
112     /*
113      * Public functions
114      */
115     /// @dev Contract constructor sets initial owners and required number of confirmations.
116 
117     function MultiSigWallet()
118         public
119     {
120         isOwner[0x160e529055D084add9634fE1c2059109c8CE044e] = true;
121         isOwner[0xCc071f42531481fcC3977518eE9e3883a5719017] = true;
122         isOwner[0xA88b950589Ac78ec10eDEfb0b40563400f3aF13E] = true;
123         isOwner[0xfb28b252679F11e37BbaD7C920D7Ba77fC2B0087] = true;
124         isOwner[0xA4bACDd1199c641d25D02004edb6f64D9fa641F2] = true;
125 	    isOwner[0xC19Fd2748a4D5d7906A3Fb731fF6186FE526cC28] = true;
126         owners = [0x160e529055D084add9634fE1c2059109c8CE044e,
127                   0xCc071f42531481fcC3977518eE9e3883a5719017,
128                   0xC19Fd2748a4D5d7906A3Fb731fF6186FE526cC28,
129                   0xA88b950589Ac78ec10eDEfb0b40563400f3aF13E,
130                   0xfb28b252679F11e37BbaD7C920D7Ba77fC2B0087,
131                   0xA4bACDd1199c641d25D02004edb6f64D9fa641F2];
132 
133     }
134 
135     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
136     /// @param owner Address of new owner.
137     function addOwner(address owner)
138         public
139         onlyWallet
140         ownerDoesNotExist(owner)
141         notNull(owner)
142         validRequirement(owners.length + 1, required)
143     {
144         isOwner[owner] = true;
145         owners.push(owner);
146         OwnerAddition(owner);
147     }
148 
149     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
150     /// @param owner Address of owner.
151     function removeOwner(address owner)
152         public
153         onlyWallet
154         ownerExists(owner)
155     {
156         isOwner[owner] = false;
157         for (uint i=0; i<owners.length - 1; i++)
158             if (owners[i] == owner) {
159                 owners[i] = owners[owners.length - 1];
160                 break;
161             }
162         owners.length -= 1;
163         if (required > owners.length)
164             changeRequirement(owners.length);
165         OwnerRemoval(owner);
166     }
167 
168     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
169     /// @param owner Address of owner to be replaced.
170     /// @param newOwner Address of new owner.
171     function replaceOwner(address owner, address newOwner)
172         public
173         onlyWallet
174         ownerExists(owner)
175         ownerDoesNotExist(newOwner)
176     {
177         for (uint i=0; i<owners.length; i++)
178             if (owners[i] == owner) {
179                 owners[i] = newOwner;
180                 break;
181             }
182         isOwner[owner] = false;
183         isOwner[newOwner] = true;
184         OwnerRemoval(owner);
185         OwnerAddition(newOwner);
186     }
187 
188     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
189     /// @param _required Number of required confirmations.
190     function changeRequirement(uint _required)
191         public
192         onlyWallet
193         validRequirement(owners.length, _required)
194     {
195         required = _required;
196         RequirementChange(_required);
197     }
198 
199     /// @dev Allows an owner to submit and confirm a transaction.
200     /// @param destination Transaction target address.
201     /// @param value Transaction ether value.
202     /// @param data Transaction data payload.
203     /// @return Returns transaction ID.
204     function submitTransaction(address destination, uint value, bytes data)
205         public
206         returns (uint transactionId)
207     {
208         transactionId = addTransaction(destination, value, data);
209         confirmTransaction(transactionId);
210     }
211 
212     /// @dev Allows an owner to confirm a transaction.
213     /// @param transactionId Transaction ID.
214     function confirmTransaction(uint transactionId)
215         public
216         ownerExists(msg.sender)
217         transactionExists(transactionId)
218         notConfirmed(transactionId, msg.sender)
219     {
220         confirmations[transactionId][msg.sender] = true;
221         Confirmation(msg.sender, transactionId);
222         executeTransaction(transactionId);
223     }
224 
225     /// @dev Allows an owner to revoke a confirmation for a transaction.
226     /// @param transactionId Transaction ID.
227     function revokeConfirmation(uint transactionId)
228         public
229         ownerExists(msg.sender)
230         confirmed(transactionId, msg.sender)
231         notExecuted(transactionId)
232     {
233         confirmations[transactionId][msg.sender] = false;
234         Revocation(msg.sender, transactionId);
235     }
236 
237     /// @dev Allows anyone to execute a confirmed transaction.
238     /// @param transactionId Transaction ID.
239     function executeTransaction(uint transactionId)
240         public
241         ownerExists(msg.sender)
242         confirmed(transactionId, msg.sender)
243         notExecuted(transactionId)
244     {
245         if (isConfirmed(transactionId)) {
246             Transaction tx = transactions[transactionId];
247             tx.executed = true;
248             if (tx.destination.call.value(tx.value)(tx.data))
249                 Execution(transactionId);
250             else {
251                 ExecutionFailure(transactionId);
252                 tx.executed = false;
253             }
254         }
255     }
256 
257     /// @dev Returns the confirmation status of a transaction.
258     /// @param transactionId Transaction ID.
259     /// @return Confirmation status.
260     function isConfirmed(uint transactionId)
261         public
262         constant
263         returns (bool)
264     {
265         uint count = 0;
266         for (uint i=0; i<owners.length; i++) {
267             if (confirmations[transactionId][owners[i]])
268                 count += 1;
269             if (count == required)
270                 return true;
271         }
272     }
273 
274     /*
275      * Internal functions
276      */
277     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
278     /// @param destination Transaction target address.
279     /// @param value Transaction ether value.
280     /// @param data Transaction data payload.
281     /// @return Returns transaction ID.
282     function addTransaction(address destination, uint value, bytes data)
283         internal
284         notNull(destination)
285         returns (uint transactionId)
286     {
287         transactionId = transactionCount;
288         transactions[transactionId] = Transaction({
289             destination: destination,
290             value: value,
291             data: data,
292             executed: false
293         });
294         transactionCount += 1;
295         Submission(transactionId);
296     }
297 
298     /*
299      * Web3 call functions
300      */
301     /// @dev Returns number of confirmations of a transaction.
302     /// @param transactionId Transaction ID.
303     /// @return Number of confirmations.
304     function getConfirmationCount(uint transactionId)
305         public
306         constant
307         returns (uint count)
308     {
309         for (uint i=0; i<owners.length; i++)
310             if (confirmations[transactionId][owners[i]])
311                 count += 1;
312     }
313 
314     /// @dev Returns total number of transactions after filers are applied.
315     /// @param pending Include pending transactions.
316     /// @param executed Include executed transactions.
317     /// @return Total number of transactions after filters are applied.
318     function getTransactionCount(bool pending, bool executed)
319         public
320         constant
321         returns (uint count)
322     {
323         for (uint i=0; i<transactionCount; i++)
324             if (   pending && !transactions[i].executed
325                 || executed && transactions[i].executed)
326                 count += 1;
327     }
328 
329     /// @dev Returns list of owners.
330     /// @return List of owner addresses.
331     function getOwners()
332         public
333         constant
334         returns (address[])
335     {
336         return owners;
337     }
338 
339     /// @dev Returns array with owner addresses, which confirmed transaction.
340     /// @param transactionId Transaction ID.
341     /// @return Returns array of owner addresses.
342     function getConfirmations(uint transactionId)
343         public
344         constant
345         returns (address[] _confirmations)
346     {
347         address[] memory confirmationsTemp = new address[](owners.length);
348         uint count = 0;
349         uint i;
350         for (i=0; i<owners.length; i++)
351             if (confirmations[transactionId][owners[i]]) {
352                 confirmationsTemp[count] = owners[i];
353                 count += 1;
354             }
355         _confirmations = new address[](count);
356         for (i=0; i<count; i++)
357             _confirmations[i] = confirmationsTemp[i];
358     }
359 
360     /// @dev Returns list of transaction IDs in defined range.
361     /// @param from Index start position of transaction array.
362     /// @param to Index end position of transaction array.
363     /// @param pending Include pending transactions.
364     /// @param executed Include executed transactions.
365     /// @return Returns array of transaction IDs.
366     function getTransactionIds(uint from, uint to, bool pending, bool executed)
367         public
368         constant
369         returns (uint[] _transactionIds)
370     {
371         uint[] memory transactionIdsTemp = new uint[](transactionCount);
372         uint count = 0;
373         uint i;
374         for (i=0; i<transactionCount; i++)
375             if (   pending && !transactions[i].executed
376                 || executed && transactions[i].executed)
377             {
378                 transactionIdsTemp[count] = i;
379                 count += 1;
380             }
381         _transactionIds = new uint[](to - from);
382         for (i=from; i<to; i++)
383             _transactionIds[i - from] = transactionIdsTemp[i];
384     }
385 }
386 
387 /// @title Multisignature wallet with daily limit - Allows an owner to withdraw a daily limit without multisig.
388 /// @author Stefan George - <stefan.george@consensys.net>
389 contract MultiSigWalletWithDailyLimit is MultiSigWallet {
390 
391     /*
392      *  Events
393      */
394     event DailyLimitChange(uint dailyLimit);
395 
396     /*
397      *  Storage
398      */
399     uint public dailyLimit = 50000000000000000000;
400     uint public lastDay;
401     uint public spentToday;
402 
403     /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
404     /// @param _dailyLimit Amount in wei.
405     function changeDailyLimit(uint _dailyLimit)
406         public
407         onlyWallet
408     {
409         dailyLimit = _dailyLimit;
410         DailyLimitChange(_dailyLimit);
411     }
412 
413     /// @dev Allows anyone to execute a confirmed transaction or ether withdraws until daily limit is reached.
414     /// @param transactionId Transaction ID.
415     function executeTransaction(uint transactionId)
416         public
417         ownerExists(msg.sender)
418         confirmed(transactionId, msg.sender)
419         notExecuted(transactionId)
420     {
421         Transaction tx = transactions[transactionId];
422         bool _confirmed = isConfirmed(transactionId);
423         if (_confirmed || tx.data.length == 0 && isUnderLimit(tx.value)) {
424             tx.executed = true;
425             if (!_confirmed)
426                 spentToday += tx.value;
427             if (tx.destination.call.value(tx.value)(tx.data))
428                 Execution(transactionId);
429             else {
430                 ExecutionFailure(transactionId);
431                 tx.executed = false;
432                 if (!_confirmed)
433                     spentToday -= tx.value;
434             }
435         }
436     }
437 
438     /*
439      * Internal functions
440      */
441     /// @dev Returns if amount is within daily limit and resets spentToday after one day.
442     /// @param amount Amount to withdraw.
443     /// @return Returns if amount is under daily limit.
444     function isUnderLimit(uint amount)
445         internal
446         returns (bool)
447     {
448         if (now > lastDay + 24 hours) {
449             lastDay = now;
450             spentToday = 0;
451         }
452         if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
453             return false;
454         return true;
455     }
456 
457     /*
458      * Web3 call functions
459      */
460     /// @dev Returns maximum withdraw amount.
461     /// @return Returns amount.
462     function calcMaxWithdraw()
463         public
464         constant
465         returns (uint)
466     {
467         if (now > lastDay + 24 hours)
468             return dailyLimit;
469         if (dailyLimit < spentToday)
470             return 0;
471         return dailyLimit - spentToday;
472     }
473 }
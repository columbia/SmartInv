1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.10;
20 
21 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
22 /// @author Stefan George - <stefan.george@consensys.net>
23 contract MultiSigWallet {
24 
25     uint constant public MAX_OWNER_COUNT = 50;
26 
27     event Confirmation(address indexed sender, uint indexed transactionId);
28     event Revocation(address indexed sender, uint indexed transactionId);
29     event Submission(uint indexed transactionId);
30     event Execution(uint indexed transactionId);
31     event ExecutionFailure(uint indexed transactionId);
32     event Deposit(address indexed sender, uint value);
33     event OwnerAddition(address indexed owner);
34     event OwnerRemoval(address indexed owner);
35     event RequirementChange(uint required);
36 
37     mapping (uint => Transaction) public transactions;
38     mapping (uint => mapping (address => bool)) public confirmations;
39     mapping (address => bool) public isOwner;
40     address[] public owners;
41     uint public required;
42     uint public transactionCount;
43 
44     struct Transaction {
45         address destination;
46         uint value;
47         bytes data;
48         bool executed;
49     }
50 
51     modifier onlyWallet() {
52         if (msg.sender != address(this))
53             throw;
54         _;
55     }
56 
57     modifier ownerDoesNotExist(address owner) {
58         if (isOwner[owner])
59             throw;
60         _;
61     }
62 
63     modifier ownerExists(address owner) {
64         if (!isOwner[owner])
65             throw;
66         _;
67     }
68 
69     modifier transactionExists(uint transactionId) {
70         if (transactions[transactionId].destination == 0)
71             throw;
72         _;
73     }
74 
75     modifier confirmed(uint transactionId, address owner) {
76         if (!confirmations[transactionId][owner])
77             throw;
78         _;
79     }
80 
81     modifier notConfirmed(uint transactionId, address owner) {
82         if (confirmations[transactionId][owner])
83             throw;
84         _;
85     }
86 
87     modifier notExecuted(uint transactionId) {
88         if (transactions[transactionId].executed)
89             throw;
90         _;
91     }
92 
93     modifier notNull(address _address) {
94         if (_address == 0)
95             throw;
96         _;
97     }
98 
99     modifier validRequirement(uint ownerCount, uint _required) {
100         if (   ownerCount > MAX_OWNER_COUNT
101             || _required > ownerCount
102             || _required == 0
103             || ownerCount == 0)
104             throw;
105         _;
106     }
107 
108     /// @dev Fallback function allows to deposit ether.
109     function()
110         payable
111     {
112         if (msg.value > 0)
113             Deposit(msg.sender, msg.value);
114     }
115 
116     /*
117      * Public functions
118      */
119     /// @dev Contract constructor sets initial owners and required number of confirmations.
120     /// @param _owners List of initial owners.
121     /// @param _required Number of required confirmations.
122     function MultiSigWallet(address[] _owners, uint _required)
123         public
124         validRequirement(_owners.length, _required)
125     {
126         for (uint i=0; i<_owners.length; i++) {
127             if (isOwner[_owners[i]] || _owners[i] == 0)
128                 throw;
129             isOwner[_owners[i]] = true;
130         }
131         owners = _owners;
132         required = _required;
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
170     /// @param owner Address of new owner.
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
241         notExecuted(transactionId)
242     {
243         if (isConfirmed(transactionId)) {
244             Transaction tx = transactions[transactionId];
245             tx.executed = true;
246             if (tx.destination.call.value(tx.value)(tx.data))
247                 Execution(transactionId);
248             else {
249                 ExecutionFailure(transactionId);
250                 tx.executed = false;
251             }
252         }
253     }
254 
255     /// @dev Returns the confirmation status of a transaction.
256     /// @param transactionId Transaction ID.
257     /// @return Confirmation status.
258     function isConfirmed(uint transactionId)
259         public
260         constant
261         returns (bool)
262     {
263         uint count = 0;
264         for (uint i=0; i<owners.length; i++) {
265             if (confirmations[transactionId][owners[i]])
266                 count += 1;
267             if (count == required)
268                 return true;
269         }
270     }
271 
272     /*
273      * Internal functions
274      */
275     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
276     /// @param destination Transaction target address.
277     /// @param value Transaction ether value.
278     /// @param data Transaction data payload.
279     /// @return Returns transaction ID.
280     function addTransaction(address destination, uint value, bytes data)
281         internal
282         notNull(destination)
283         returns (uint transactionId)
284     {
285         transactionId = transactionCount;
286         transactions[transactionId] = Transaction({
287             destination: destination,
288             value: value,
289             data: data,
290             executed: false
291         });
292         transactionCount += 1;
293         Submission(transactionId);
294     }
295 
296     /*
297      * Web3 call functions
298      */
299     /// @dev Returns number of confirmations of a transaction.
300     /// @param transactionId Transaction ID.
301     /// @return Number of confirmations.
302     function getConfirmationCount(uint transactionId)
303         public
304         constant
305         returns (uint count)
306     {
307         for (uint i=0; i<owners.length; i++)
308             if (confirmations[transactionId][owners[i]])
309                 count += 1;
310     }
311 
312     /// @dev Returns total number of transactions after filers are applied.
313     /// @param pending Include pending transactions.
314     /// @param executed Include executed transactions.
315     /// @return Total number of transactions after filters are applied.
316     function getTransactionCount(bool pending, bool executed)
317         public
318         constant
319         returns (uint count)
320     {
321         for (uint i=0; i<transactionCount; i++)
322             if (   pending && !transactions[i].executed
323                 || executed && transactions[i].executed)
324                 count += 1;
325     }
326 
327     /// @dev Returns list of owners.
328     /// @return List of owner addresses.
329     function getOwners()
330         public
331         constant
332         returns (address[])
333     {
334         return owners;
335     }
336 
337     /// @dev Returns array with owner addresses, which confirmed transaction.
338     /// @param transactionId Transaction ID.
339     /// @return Returns array of owner addresses.
340     function getConfirmations(uint transactionId)
341         public
342         constant
343         returns (address[] _confirmations)
344     {
345         address[] memory confirmationsTemp = new address[](owners.length);
346         uint count = 0;
347         uint i;
348         for (i=0; i<owners.length; i++)
349             if (confirmations[transactionId][owners[i]]) {
350                 confirmationsTemp[count] = owners[i];
351                 count += 1;
352             }
353         _confirmations = new address[](count);
354         for (i=0; i<count; i++)
355             _confirmations[i] = confirmationsTemp[i];
356     }
357 
358     /// @dev Returns list of transaction IDs in defined range.
359     /// @param from Index start position of transaction array.
360     /// @param to Index end position of transaction array.
361     /// @param pending Include pending transactions.
362     /// @param executed Include executed transactions.
363     /// @return Returns array of transaction IDs.
364     function getTransactionIds(uint from, uint to, bool pending, bool executed)
365         public
366         constant
367         returns (uint[] _transactionIds)
368     {
369         uint[] memory transactionIdsTemp = new uint[](transactionCount);
370         uint count = 0;
371         uint i;
372         for (i=0; i<transactionCount; i++)
373             if (   pending && !transactions[i].executed
374                 || executed && transactions[i].executed)
375             {
376                 transactionIdsTemp[count] = i;
377                 count += 1;
378             }
379         _transactionIds = new uint[](to - from);
380         for (i=from; i<to; i++)
381             _transactionIds[i - from] = transactionIdsTemp[i];
382     }
383 }
384 
385 /// @title Multisignature wallet with time lock- Allows multiple parties to execute a transaction after a time lock has passed.
386 /// @author Amir Bandeali - <amir@0xProject.com>
387 contract MultiSigWalletWithTimeLock is MultiSigWallet {
388 
389     event ConfirmationTimeSet(uint indexed transactionId, uint confirmationTime);
390     event TimeLockChange(uint secondsTimeLocked);
391 
392     uint public secondsTimeLocked;
393 
394     mapping (uint => uint) public confirmationTimes;
395 
396     modifier notFullyConfirmed(uint transactionId) {
397         require(!isConfirmed(transactionId));
398         _;
399     }
400 
401     modifier fullyConfirmed(uint transactionId) {
402         require(isConfirmed(transactionId));
403         _;
404     }
405 
406     modifier pastTimeLock(uint transactionId) {
407         require(block.timestamp >= confirmationTimes[transactionId] + secondsTimeLocked);
408         _;
409     }
410 
411     /*
412      * Public functions
413      */
414 
415     /// @dev Contract constructor sets initial owners, required number of confirmations, and time lock.
416     /// @param _owners List of initial owners.
417     /// @param _required Number of required confirmations.
418     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
419     function MultiSigWalletWithTimeLock(address[] _owners, uint _required, uint _secondsTimeLocked)
420         public
421         MultiSigWallet(_owners, _required)
422     {
423         secondsTimeLocked = _secondsTimeLocked;
424     }
425 
426     /// @dev Changes the duration of the time lock for transactions.
427     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
428     function changeTimeLock(uint _secondsTimeLocked)
429         public
430         onlyWallet
431     {
432         secondsTimeLocked = _secondsTimeLocked;
433         TimeLockChange(_secondsTimeLocked);
434     }
435 
436     /// @dev Allows an owner to confirm a transaction.
437     /// @param transactionId Transaction ID.
438     function confirmTransaction(uint transactionId)
439         public
440         ownerExists(msg.sender)
441         transactionExists(transactionId)
442         notConfirmed(transactionId, msg.sender)
443         notFullyConfirmed(transactionId)
444     {
445         confirmations[transactionId][msg.sender] = true;
446         Confirmation(msg.sender, transactionId);
447         if (isConfirmed(transactionId)) {
448             setConfirmationTime(transactionId, block.timestamp);
449         }
450     }
451 
452     /// @dev Allows an owner to revoke a confirmation for a transaction.
453     /// @param transactionId Transaction ID.
454     function revokeConfirmation(uint transactionId)
455         public
456         ownerExists(msg.sender)
457         confirmed(transactionId, msg.sender)
458         notExecuted(transactionId)
459         notFullyConfirmed(transactionId)
460     {
461         confirmations[transactionId][msg.sender] = false;
462         Revocation(msg.sender, transactionId);
463     }
464 
465     /// @dev Allows anyone to execute a confirmed transaction.
466     /// @param transactionId Transaction ID.
467     function executeTransaction(uint transactionId)
468         public
469         notExecuted(transactionId)
470         fullyConfirmed(transactionId)
471         pastTimeLock(transactionId)
472     {
473         Transaction storage tx = transactions[transactionId];
474         tx.executed = true;
475         if (tx.destination.call.value(tx.value)(tx.data))
476             Execution(transactionId);
477         else {
478             ExecutionFailure(transactionId);
479             tx.executed = false;
480         }
481     }
482 
483     /*
484      * Internal functions
485      */
486 
487     /// @dev Sets the time of when a submission first passed.
488     function setConfirmationTime(uint transactionId, uint confirmationTime)
489         internal
490     {
491         confirmationTimes[transactionId] = confirmationTime;
492         ConfirmationTimeSet(transactionId, confirmationTime);
493     }
494 }
495 
496 contract MultiSigWalletWithTimeLockExceptRemoveAuthorizedAddress is MultiSigWalletWithTimeLock {
497 
498     address public TOKEN_TRANSFER_PROXY_CONTRACT;
499 
500     modifier validRemoveAuthorizedAddressTx(uint transactionId) {
501         Transaction storage tx = transactions[transactionId];
502         require(tx.destination == TOKEN_TRANSFER_PROXY_CONTRACT);
503         require(isFunctionRemoveAuthorizedAddress(tx.data));
504         _;
505     }
506 
507     /// @dev Contract constructor sets initial owners, required number of confirmations, time lock, and tokenTransferProxy address.
508     /// @param _owners List of initial owners.
509     /// @param _required Number of required confirmations.
510     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
511     /// @param _tokenTransferProxy Address of TokenTransferProxy contract.
512     function MultiSigWalletWithTimeLockExceptRemoveAuthorizedAddress(
513         address[] _owners,
514         uint _required,
515         uint _secondsTimeLocked,
516         address _tokenTransferProxy)
517         public
518         MultiSigWalletWithTimeLock(_owners, _required, _secondsTimeLocked)
519     {
520         TOKEN_TRANSFER_PROXY_CONTRACT = _tokenTransferProxy;
521     }
522 
523     /// @dev Allows execution of removeAuthorizedAddress without time lock.
524     /// @param transactionId Transaction ID.
525     function executeRemoveAuthorizedAddress(uint transactionId)
526         public
527         notExecuted(transactionId)
528         fullyConfirmed(transactionId)
529         validRemoveAuthorizedAddressTx(transactionId)
530     {
531         Transaction storage tx = transactions[transactionId];
532         tx.executed = true;
533         if (tx.destination.call.value(tx.value)(tx.data))
534             Execution(transactionId);
535         else {
536             ExecutionFailure(transactionId);
537             tx.executed = false;
538         }
539     }
540 
541     /// @dev Compares first 4 bytes of byte array to removeAuthorizedAddress function signature.
542     /// @param data Transaction data.
543     /// @return Successful if data is a call to removeAuthorizedAddress.
544     function isFunctionRemoveAuthorizedAddress(bytes data)
545         public
546         constant
547         returns (bool)
548     {
549         bytes4 removeAuthorizedAddressSignature = bytes4(sha3("removeAuthorizedAddress(address)"));
550         for (uint i = 0; i < 4; i++) {
551             require(data[i] == removeAuthorizedAddressSignature[i]);
552         }
553         return true;
554     }
555 }
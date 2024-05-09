1 pragma solidity 0.4.18;
2 contract Factory {
3 
4     /*
5      *  Events
6      */
7     event ContractInstantiation(address sender, address instantiation);
8 
9     /*
10      *  Storage
11      */
12     mapping(address => bool) public isInstantiation;
13     mapping(address => address[]) public instantiations;
14 
15     /*
16      * Public functions
17      */
18     /// @dev Returns number of instantiations by creator.
19     /// @param creator Contract creator.
20     /// @return Returns number of instantiations by creator.
21     function getInstantiationCount(address creator)
22         public
23         constant
24         returns (uint)
25     {
26         return instantiations[creator].length;
27     }
28 
29     /*
30      * Internal functions
31      */
32     /// @dev Registers contract in factory registry.
33     /// @param instantiation Address of contract instantiation.
34     function register(address instantiation)
35         internal
36     {
37         isInstantiation[instantiation] = true;
38         instantiations[msg.sender].push(instantiation);
39         ContractInstantiation(msg.sender, instantiation);
40     }
41 }
42 
43 
44 /// @title Multisignature wallet factory - Allows creation of multisig wallet.
45 /// @author Stefan George - <stefan.george@consensys.net>
46 contract MultiSigWalletFactory is Factory {
47 
48     /*
49      * Public functions
50      */
51     /// @dev Allows verified creation of multisignature wallet.
52     /// @param _owners List of initial owners.
53     /// @param _required Number of required confirmations.
54     /// @return Returns wallet address.
55     function create(address[] _owners, uint _required)
56         public
57         returns (address wallet)
58     {
59         wallet = new MultiSigWallet(_owners, _required);
60         register(wallet);
61     }
62 }
63 
64 
65 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
66 /// @author Stefan George - <stefan.george@consensys.net>
67 contract MultiSigWallet {
68 
69     /*
70      *  Events
71      */
72     event Confirmation(address indexed sender, uint indexed transactionId);
73     event Revocation(address indexed sender, uint indexed transactionId);
74     event Submission(uint indexed transactionId);
75     event Execution(uint indexed transactionId);
76     event ExecutionFailure(uint indexed transactionId);
77     event Deposit(address indexed sender, uint value);
78     event OwnerAddition(address indexed owner);
79     event OwnerRemoval(address indexed owner);
80     event RequirementChange(uint required);
81 
82     /*
83      *  Constants
84      */
85     uint constant public MAX_OWNER_COUNT = 50;
86 
87     /*
88      *  Storage
89      */
90     mapping (uint => Transaction) public transactions;
91     mapping (uint => mapping (address => bool)) public confirmations;
92     mapping (address => bool) public isOwner;
93     address[] public owners;
94     uint public required;
95     uint public transactionCount;
96 
97     struct Transaction {
98         address destination;
99         uint value;
100         bytes data;
101         bool executed;
102     }
103 
104     /*
105      *  Modifiers
106      */
107     modifier onlyWallet() {
108         if (msg.sender != address(this))
109             throw;
110         _;
111     }
112 
113     modifier ownerDoesNotExist(address owner) {
114         if (isOwner[owner])
115             throw;
116         _;
117     }
118 
119     modifier ownerExists(address owner) {
120         if (!isOwner[owner])
121             throw;
122         _;
123     }
124 
125     modifier transactionExists(uint transactionId) {
126         if (transactions[transactionId].destination == 0)
127             throw;
128         _;
129     }
130 
131     modifier confirmed(uint transactionId, address owner) {
132         if (!confirmations[transactionId][owner])
133             throw;
134         _;
135     }
136 
137     modifier notConfirmed(uint transactionId, address owner) {
138         if (confirmations[transactionId][owner])
139             throw;
140         _;
141     }
142 
143     modifier notExecuted(uint transactionId) {
144         if (transactions[transactionId].executed)
145             throw;
146         _;
147     }
148 
149     modifier notNull(address _address) {
150         if (_address == 0)
151             throw;
152         _;
153     }
154 
155     modifier validRequirement(uint ownerCount, uint _required) {
156         if (   ownerCount > MAX_OWNER_COUNT
157             || _required > ownerCount
158             || _required == 0
159             || ownerCount == 0)
160             throw;
161         _;
162     }
163 
164     /// @dev Fallback function allows to deposit ether.
165     function()
166         payable
167     {
168         if (msg.value > 0)
169             Deposit(msg.sender, msg.value);
170     }
171 
172     /*
173      * Public functions
174      */
175     /// @dev Contract constructor sets initial owners and required number of confirmations.
176     /// @param _owners List of initial owners.
177     /// @param _required Number of required confirmations.
178     function MultiSigWallet(address[] _owners, uint _required)
179         public
180         validRequirement(_owners.length, _required)
181     {
182         for (uint i=0; i<_owners.length; i++) {
183             if (isOwner[_owners[i]] || _owners[i] == 0)
184                 throw;
185             isOwner[_owners[i]] = true;
186         }
187         owners = _owners;
188         required = _required;
189     }
190 
191     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
192     /// @param owner Address of new owner.
193     function addOwner(address owner)
194         public
195         onlyWallet
196         ownerDoesNotExist(owner)
197         notNull(owner)
198         validRequirement(owners.length + 1, required)
199     {
200         isOwner[owner] = true;
201         owners.push(owner);
202         OwnerAddition(owner);
203     }
204 
205     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
206     /// @param owner Address of owner.
207     function removeOwner(address owner)
208         public
209         onlyWallet
210         ownerExists(owner)
211     {
212         isOwner[owner] = false;
213         for (uint i=0; i<owners.length - 1; i++)
214             if (owners[i] == owner) {
215                 owners[i] = owners[owners.length - 1];
216                 break;
217             }
218         owners.length -= 1;
219         if (required > owners.length)
220             changeRequirement(owners.length);
221         OwnerRemoval(owner);
222     }
223 
224     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
225     /// @param owner Address of owner to be replaced.
226     /// @param newOwner Address of new owner.
227     function replaceOwner(address owner, address newOwner)
228         public
229         onlyWallet
230         ownerExists(owner)
231         ownerDoesNotExist(newOwner)
232     {
233         for (uint i=0; i<owners.length; i++)
234             if (owners[i] == owner) {
235                 owners[i] = newOwner;
236                 break;
237             }
238         isOwner[owner] = false;
239         isOwner[newOwner] = true;
240         OwnerRemoval(owner);
241         OwnerAddition(newOwner);
242     }
243 
244     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
245     /// @param _required Number of required confirmations.
246     function changeRequirement(uint _required)
247         public
248         onlyWallet
249         validRequirement(owners.length, _required)
250     {
251         required = _required;
252         RequirementChange(_required);
253     }
254 
255     /// @dev Allows an owner to submit and confirm a transaction.
256     /// @param destination Transaction target address.
257     /// @param value Transaction ether value.
258     /// @param data Transaction data payload.
259     /// @return Returns transaction ID.
260     function submitTransaction(address destination, uint value, bytes data)
261         public
262         returns (uint transactionId)
263     {
264         transactionId = addTransaction(destination, value, data);
265         confirmTransaction(transactionId);
266     }
267 
268     /// @dev Allows an owner to confirm a transaction.
269     /// @param transactionId Transaction ID.
270     function confirmTransaction(uint transactionId)
271         public
272         ownerExists(msg.sender)
273         transactionExists(transactionId)
274         notConfirmed(transactionId, msg.sender)
275     {
276         confirmations[transactionId][msg.sender] = true;
277         Confirmation(msg.sender, transactionId);
278         executeTransaction(transactionId);
279     }
280 
281     /// @dev Allows an owner to revoke a confirmation for a transaction.
282     /// @param transactionId Transaction ID.
283     function revokeConfirmation(uint transactionId)
284         public
285         ownerExists(msg.sender)
286         confirmed(transactionId, msg.sender)
287         notExecuted(transactionId)
288     {
289         confirmations[transactionId][msg.sender] = false;
290         Revocation(msg.sender, transactionId);
291     }
292 
293     /// @dev Allows anyone to execute a confirmed transaction.
294     /// @param transactionId Transaction ID.
295     function executeTransaction(uint transactionId)
296         public
297         ownerExists(msg.sender)
298         confirmed(transactionId, msg.sender)
299         notExecuted(transactionId)
300     {
301         if (isConfirmed(transactionId)) {
302             Transaction tx = transactions[transactionId];
303             tx.executed = true;
304             if (tx.destination.call.value(tx.value)(tx.data))
305                 Execution(transactionId);
306             else {
307                 ExecutionFailure(transactionId);
308                 tx.executed = false;
309             }
310         }
311     }
312 
313     /// @dev Returns the confirmation status of a transaction.
314     /// @param transactionId Transaction ID.
315     /// @return Confirmation status.
316     function isConfirmed(uint transactionId)
317         public
318         constant
319         returns (bool)
320     {
321         uint count = 0;
322         for (uint i=0; i<owners.length; i++) {
323             if (confirmations[transactionId][owners[i]])
324                 count += 1;
325             if (count == required)
326                 return true;
327         }
328     }
329 
330     /*
331      * Internal functions
332      */
333     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
334     /// @param destination Transaction target address.
335     /// @param value Transaction ether value.
336     /// @param data Transaction data payload.
337     /// @return Returns transaction ID.
338     function addTransaction(address destination, uint value, bytes data)
339         internal
340         notNull(destination)
341         returns (uint transactionId)
342     {
343         transactionId = transactionCount;
344         transactions[transactionId] = Transaction({
345             destination: destination,
346             value: value,
347             data: data,
348             executed: false
349         });
350         transactionCount += 1;
351         Submission(transactionId);
352     }
353 
354     /*
355      * Web3 call functions
356      */
357     /// @dev Returns number of confirmations of a transaction.
358     /// @param transactionId Transaction ID.
359     /// @return Number of confirmations.
360     function getConfirmationCount(uint transactionId)
361         public
362         constant
363         returns (uint count)
364     {
365         for (uint i=0; i<owners.length; i++)
366             if (confirmations[transactionId][owners[i]])
367                 count += 1;
368     }
369 
370     /// @dev Returns total number of transactions after filers are applied.
371     /// @param pending Include pending transactions.
372     /// @param executed Include executed transactions.
373     /// @return Total number of transactions after filters are applied.
374     function getTransactionCount(bool pending, bool executed)
375         public
376         constant
377         returns (uint count)
378     {
379         for (uint i=0; i<transactionCount; i++)
380             if (   pending && !transactions[i].executed
381                 || executed && transactions[i].executed)
382                 count += 1;
383     }
384 
385     /// @dev Returns list of owners.
386     /// @return List of owner addresses.
387     function getOwners()
388         public
389         constant
390         returns (address[])
391     {
392         return owners;
393     }
394 
395     /// @dev Returns array with owner addresses, which confirmed transaction.
396     /// @param transactionId Transaction ID.
397     /// @return Returns array of owner addresses.
398     function getConfirmations(uint transactionId)
399         public
400         constant
401         returns (address[] _confirmations)
402     {
403         address[] memory confirmationsTemp = new address[](owners.length);
404         uint count = 0;
405         uint i;
406         for (i=0; i<owners.length; i++)
407             if (confirmations[transactionId][owners[i]]) {
408                 confirmationsTemp[count] = owners[i];
409                 count += 1;
410             }
411         _confirmations = new address[](count);
412         for (i=0; i<count; i++)
413             _confirmations[i] = confirmationsTemp[i];
414     }
415 
416     /// @dev Returns list of transaction IDs in defined range.
417     /// @param from Index start position of transaction array.
418     /// @param to Index end position of transaction array.
419     /// @param pending Include pending transactions.
420     /// @param executed Include executed transactions.
421     /// @return Returns array of transaction IDs.
422     function getTransactionIds(uint from, uint to, bool pending, bool executed)
423         public
424         constant
425         returns (uint[] _transactionIds)
426     {
427         uint[] memory transactionIdsTemp = new uint[](transactionCount);
428         uint count = 0;
429         uint i;
430         for (i=0; i<transactionCount; i++)
431             if (   pending && !transactions[i].executed
432                 || executed && transactions[i].executed)
433             {
434                 transactionIdsTemp[count] = i;
435                 count += 1;
436             }
437         _transactionIds = new uint[](to - from);
438         for (i=from; i<to; i++)
439             _transactionIds[i - from] = transactionIdsTemp[i];
440     }
441 }
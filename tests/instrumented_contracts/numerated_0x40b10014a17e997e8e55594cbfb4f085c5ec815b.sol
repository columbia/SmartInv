1 /**
2  * Originally from https://github.com/ConsenSys/MultiSigWallet
3  */
4 
5 pragma solidity ^0.4.11;
6 
7 
8 contract owned {
9     address public owner;
10 
11     function owned() {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         if (msg.sender != owner) throw;
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner {
21         owner = newOwner;
22     }
23 }
24 
25 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
26 /// @author Stefan George - <stefan.george@consensys.net>
27 contract MultiSig is owned {
28     uint constant public MAX_OWNER_COUNT = 50;
29 
30     event Confirmation(address indexed sender, uint indexed transactionId);
31     event Revocation(address indexed sender, uint indexed transactionId);
32     event Submission(uint indexed transactionId);
33     event Execution(uint indexed transactionId);
34     event ExecutionFailure(uint indexed transactionId);
35     event Deposit(address indexed sender, uint value);
36     event OwnerAddition(address indexed owner);
37     event OwnerRemoval(address indexed owner);
38     event RequirementChange(uint required);
39 
40     mapping (uint => Transaction) public transactions;
41     mapping (uint => mapping (address => bool)) public confirmations;
42     mapping (address => bool) public isOwner;
43     address[] public owners;
44     uint public required;
45     uint public transactionCount;
46 
47     struct Transaction {
48         address destination;
49         uint value;
50         bytes data;
51         bool executed;
52     }
53 
54     modifier onlyWallet() {
55         if (msg.sender != address(this))
56             throw;
57         _;
58     }
59 
60     modifier ownerDoesNotExist(address owner) {
61         if (isOwner[owner])
62             throw;
63         _;
64     }
65 
66     modifier ownerExists(address owner) {
67         if (!isOwner[owner])
68             throw;
69         _;
70     }
71 
72     modifier transactionExists(uint transactionId) {
73         if (transactions[transactionId].destination == 0)
74             throw;
75         _;
76     }
77 
78     modifier confirmed(uint transactionId, address owner) {
79         if (!confirmations[transactionId][owner])
80             throw;
81         _;
82     }
83 
84     modifier notConfirmed(uint transactionId, address owner) {
85         if (confirmations[transactionId][owner])
86             throw;
87         _;
88     }
89 
90     modifier notExecuted(uint transactionId) {
91         if (transactions[transactionId].executed)
92             throw;
93         _;
94     }
95 
96     modifier notNull(address _address) {
97         if (_address == 0)
98             throw;
99         _;
100     }
101 
102     modifier validRequirement(uint ownerCount, uint _required) {
103         if (   ownerCount > MAX_OWNER_COUNT
104             || _required > ownerCount
105             || _required == 0
106             || ownerCount == 0)
107             throw;
108         _;
109     }
110 
111     /*
112      * Public functions
113      */
114     /// @dev Contract constructor sets initial owners and required number of confirmations.
115     /// @param _owners List of initial owners.
116     /// @param _required Number of required confirmations.
117     function MultiSig(address[] _owners, uint _required)
118         public
119         validRequirement(_owners.length, _required)
120     {
121         for (uint i=0; i<_owners.length; i++) {
122             if (isOwner[_owners[i]] || _owners[i] == 0)
123                 throw;
124             isOwner[_owners[i]] = true;
125         }
126         owners = _owners;
127         required = _required;
128     }
129 
130     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
131     /// @param owner Address of new owner.
132     function addOwner(address owner)
133         public
134         onlyWallet
135         ownerDoesNotExist(owner)
136         notNull(owner)
137         validRequirement(owners.length + 1, required)
138     {
139         isOwner[owner] = true;
140         owners.push(owner);
141 
142         changeRequirement(owners.length / 2 + 1);
143 
144         OwnerAddition(owner);
145     }
146 
147     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
148     /// @param owner Address of owner.
149     function removeOwner(address owner)
150         public
151         onlyWallet
152         ownerExists(owner)
153     {
154         isOwner[owner] = false;
155         for (uint i=0; i<owners.length - 1; i++)
156             if (owners[i] == owner) {
157                 owners[i] = owners[owners.length - 1];
158                 break;
159             }
160         owners.length -= 1;
161 
162         //if (required > owners.length)
163         //    changeRequirement(owners.length);
164         changeRequirement(owners.length / 2 + 1);
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
206         ownerExists(msg.sender)
207         returns (uint transactionId)
208     {
209         transactionId = addTransaction(destination, value, data);
210         confirmTransaction(transactionId);
211     }
212 
213     /// @dev Allows an owner to confirm a transaction.
214     /// @param transactionId Transaction ID.
215     function confirmTransaction(uint transactionId)
216         public
217         ownerExists(msg.sender)
218         transactionExists(transactionId)
219         notConfirmed(transactionId, msg.sender)
220     {
221         confirmations[transactionId][msg.sender] = true;
222         Confirmation(msg.sender, transactionId);
223         executeTransaction(transactionId);
224     }
225 
226     /// @dev Allows an owner to revoke a confirmation for a transaction.
227     /// @param transactionId Transaction ID.
228     function revokeConfirmation(uint transactionId)
229         public
230         ownerExists(msg.sender)
231         confirmed(transactionId, msg.sender)
232         notExecuted(transactionId)
233     {
234         confirmations[transactionId][msg.sender] = false;
235         Revocation(msg.sender, transactionId);
236     }
237 
238     /// @dev Allows anyone to execute a confirmed transaction.
239     /// @param transactionId Transaction ID.
240     function executeTransaction(uint transactionId)
241         public
242         notExecuted(transactionId)
243     {
244     }
245 
246     /// @dev Returns the confirmation status of a transaction.
247     /// @param transactionId Transaction ID.
248     /// @return Confirmation status.
249     function isConfirmed(uint transactionId)
250         public
251         constant
252         returns (bool)
253     {
254         uint count = 0;
255         for (uint i=0; i<owners.length; i++) {
256             if (confirmations[transactionId][owners[i]])
257                 count += 1;
258             if (count == required)
259                 return true;
260         }
261     }
262 
263     /*
264      * Internal functions
265      */
266     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
267     /// @param destination Transaction target address.
268     /// @param value Transaction ether value.
269     /// @param data Transaction data payload.
270     /// @return Returns transaction ID.
271     function addTransaction(address destination, uint value, bytes data)
272         internal
273         notNull(destination)
274         returns (uint transactionId)
275     {
276         transactionId = transactionCount;
277         transactions[transactionId] = Transaction({
278             destination: destination,
279             value: value,
280             data: data,
281             executed: false
282         });
283         transactionCount += 1;
284         Submission(transactionId);
285     }
286 
287     /*
288      * Web3 call functions
289      */
290     /// @dev Returns number of confirmations of a transaction.
291     /// @param transactionId Transaction ID.
292     /// @return Number of confirmations.
293     function getConfirmationCount(uint transactionId)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i=0; i<owners.length; i++)
299             if (confirmations[transactionId][owners[i]])
300                 count += 1;
301     }
302 
303     /// @dev Returns total number of transactions after filers are applied.
304     /// @param pending Include pending transactions.
305     /// @param executed Include executed transactions.
306     /// @return Total number of transactions after filters are applied.
307     function getTransactionCount(bool pending, bool executed)
308         public
309         constant
310         returns (uint count)
311     {
312         for (uint i=0; i<transactionCount; i++)
313             if (   pending && !transactions[i].executed
314                 || executed && transactions[i].executed)
315                 count += 1;
316     }
317 
318     /// @dev Returns list of owners.
319     /// @return List of owner addresses.
320     function getOwners()
321         public
322         constant
323         returns (address[])
324     {
325         return owners;
326     }
327 
328     /// @dev Returns array with owner addresses, which confirmed transaction.
329     /// @param transactionId Transaction ID.
330     /// @return Returns array of owner addresses.
331     function getConfirmations(uint transactionId)
332         public
333         constant
334         returns (address[] _confirmations)
335     {
336         address[] memory confirmationsTemp = new address[](owners.length);
337         uint count = 0;
338         uint i;
339         for (i=0; i<owners.length; i++)
340             if (confirmations[transactionId][owners[i]]) {
341                 confirmationsTemp[count] = owners[i];
342                 count += 1;
343             }
344         _confirmations = new address[](count);
345         for (i=0; i<count; i++)
346             _confirmations[i] = confirmationsTemp[i];
347     }
348 
349     /// @dev Returns list of transaction IDs in defined range.
350     /// @param from Index start position of transaction array.
351     /// @param to Index end position of transaction array.
352     /// @param pending Include pending transactions.
353     /// @param executed Include executed transactions.
354     /// @return Returns array of transaction IDs.
355     function getTransactionIds(uint from, uint to, bool pending, bool executed)
356         public
357         constant
358         returns (uint[] _transactionIds)
359     {
360         uint[] memory transactionIdsTemp = new uint[](transactionCount);
361         uint count = 0;
362         uint i;
363         for (i=0; i<transactionCount; i++)
364             if (   pending && !transactions[i].executed
365                 || executed && transactions[i].executed)
366             {
367                 transactionIdsTemp[count] = i;
368                 count += 1;
369             }
370         _transactionIds = new uint[](to - from);
371         for (i=from; i<to; i++)
372             _transactionIds[i - from] = transactionIdsTemp[i];
373     }
374 }
375 
376 contract MultiSigWallet is MultiSig {
377     function MultiSigWallet(address[] _owners, uint _required)
378         public
379         MultiSig( _owners, _required)
380     {    
381     }
382 
383     /// @dev Fallback function allows to deposit ether.
384     function()
385         payable
386     {
387         if (msg.value > 0)
388             Deposit(msg.sender, msg.value);
389     }
390 
391     /// @dev Allows anyone to execute a confirmed transaction.
392     /// @param transactionId Transaction ID.
393     function executeTransaction(uint transactionId)
394         public
395         notExecuted(transactionId)
396     {
397         if (isConfirmed(transactionId)) {
398             Transaction tx = transactions[transactionId];
399 
400             if (tx.destination.call.value(tx.value)(tx.data)) {
401                 tx.executed = true;
402                 Execution(transactionId);
403             } else {
404                 ExecutionFailure(transactionId);
405                 tx.executed = false;
406             }
407         }
408     }
409 }
410 
411 
412 
413 contract token {function transfer(address receiver, uint amount) returns (bool success);}
414 
415 contract MultiSigToken is MultiSig {
416     token public tokenFactory ;
417 
418     function MultiSigToken(address[] _owners, uint _required, token _addressOfTokenFactory)
419         public
420         MultiSig( _owners, _required)
421     {    
422         tokenFactory = token(_addressOfTokenFactory);
423     }
424 
425     // @dev This unnamed function is called whenever someone tries to send ether to it 
426     function()
427     {
428         throw; // Prevents accidental sending of ether
429     }
430 
431     /// @dev Allows anyone to execute a confirmed transaction.
432     /// @param transactionId Transaction ID.
433     function executeTransaction(uint transactionId)
434         public
435         notExecuted(transactionId)
436     {
437         if (isConfirmed(transactionId)) {
438             Transaction tx = transactions[transactionId];
439 
440             if (tokenFactory.transfer(tx.destination, tx.value)) {
441                 tx.executed = true;
442                 Execution(transactionId);
443             } else {
444                 tx.executed = false;
445                 ExecutionFailure(transactionId);
446             }
447         }
448     }
449 }
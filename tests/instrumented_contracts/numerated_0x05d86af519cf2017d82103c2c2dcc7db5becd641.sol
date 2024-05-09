1 pragma solidity ^0.4.18;
2 
3 contract ZipperMultisigFactory
4 {
5     address zipper;
6     
7     function ZipperMultisigFactory(address _zipper) public
8     {
9         zipper = _zipper;
10     }
11 
12     function createMultisig() public returns (address _multisig)
13     {
14         address[] memory addys = new address[](2);
15         addys[0] = zipper;
16         addys[1] = msg.sender;
17         
18         MultiSigWallet a = new MultiSigWallet(addys, 2);
19         
20         MultisigCreated(a, msg.sender, zipper);
21     }
22     
23     function changeZipper(address _newZipper) public
24     {
25         require(msg.sender == zipper);
26         zipper = _newZipper;
27     }
28 
29     event MultisigCreated(address _multisig, address indexed _sender, address indexed _zipper);
30 }
31 
32 // b7f01af8bd882501f6801eb1eea8b22aa2a4979e from https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
33 
34 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
35 /// @author Stefan George - <stefan.george@consensys.net>
36 contract MultiSigWallet {
37 
38     /*
39      *  Events
40      */
41     event Confirmation(address indexed sender, uint indexed transactionId);
42     event Revocation(address indexed sender, uint indexed transactionId);
43     event Submission(uint indexed transactionId);
44     event Execution(uint indexed transactionId);
45     event ExecutionFailure(uint indexed transactionId);
46     event Deposit(address indexed sender, uint value);
47     event OwnerAddition(address indexed owner);
48     event OwnerRemoval(address indexed owner);
49     event RequirementChange(uint required);
50 
51     /*
52      *  Constants
53      */
54     uint constant public MAX_OWNER_COUNT = 50;
55 
56     /*
57      *  Storage
58      */
59     mapping (uint => Transaction) public transactions;
60     mapping (uint => mapping (address => bool)) public confirmations;
61     mapping (address => bool) public isOwner;
62     address[] public owners;
63     uint public required;
64     uint public transactionCount;
65 
66     struct Transaction {
67         address destination;
68         uint value;
69         bytes data;
70         bool executed;
71     }
72 
73     /*
74      *  Modifiers
75      */
76     modifier onlyWallet() {
77         if (msg.sender != address(this))
78             throw;
79         _;
80     }
81 
82     modifier ownerDoesNotExist(address owner) {
83         if (isOwner[owner])
84             throw;
85         _;
86     }
87 
88     modifier ownerExists(address owner) {
89         if (!isOwner[owner])
90             throw;
91         _;
92     }
93 
94     modifier transactionExists(uint transactionId) {
95         if (transactions[transactionId].destination == 0)
96             throw;
97         _;
98     }
99 
100     modifier confirmed(uint transactionId, address owner) {
101         if (!confirmations[transactionId][owner])
102             throw;
103         _;
104     }
105 
106     modifier notConfirmed(uint transactionId, address owner) {
107         if (confirmations[transactionId][owner])
108             throw;
109         _;
110     }
111 
112     modifier notExecuted(uint transactionId) {
113         if (transactions[transactionId].executed)
114             throw;
115         _;
116     }
117 
118     modifier notNull(address _address) {
119         if (_address == 0)
120             throw;
121         _;
122     }
123 
124     modifier validRequirement(uint ownerCount, uint _required) {
125         if (   ownerCount > MAX_OWNER_COUNT
126             || _required > ownerCount
127             || _required == 0
128             || ownerCount == 0)
129             throw;
130         _;
131     }
132 
133     /// @dev Fallback function allows to deposit ether.
134     function()
135         payable
136     {
137         if (msg.value > 0)
138             Deposit(msg.sender, msg.value);
139     }
140 
141     /*
142      * Public functions
143      */
144     /// @dev Contract constructor sets initial owners and required number of confirmations.
145     /// @param _owners List of initial owners.
146     /// @param _required Number of required confirmations.
147     function MultiSigWallet(address[] _owners, uint _required)
148         public
149         validRequirement(_owners.length, _required)
150     {
151         for (uint i=0; i<_owners.length; i++) {
152             if (isOwner[_owners[i]] || _owners[i] == 0)
153                 throw;
154             isOwner[_owners[i]] = true;
155         }
156         owners = _owners;
157         required = _required;
158     }
159 
160     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
161     /// @param owner Address of new owner.
162     function addOwner(address owner)
163         public
164         onlyWallet
165         ownerDoesNotExist(owner)
166         notNull(owner)
167         validRequirement(owners.length + 1, required)
168     {
169         isOwner[owner] = true;
170         owners.push(owner);
171         OwnerAddition(owner);
172     }
173 
174     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
175     /// @param owner Address of owner.
176     function removeOwner(address owner)
177         public
178         onlyWallet
179         ownerExists(owner)
180     {
181         isOwner[owner] = false;
182         for (uint i=0; i<owners.length - 1; i++)
183             if (owners[i] == owner) {
184                 owners[i] = owners[owners.length - 1];
185                 break;
186             }
187         owners.length -= 1;
188         if (required > owners.length)
189             changeRequirement(owners.length);
190         OwnerRemoval(owner);
191     }
192 
193     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
194     /// @param owner Address of owner to be replaced.
195     /// @param newOwner Address of new owner.
196     function replaceOwner(address owner, address newOwner)
197         public
198         onlyWallet
199         ownerExists(owner)
200         ownerDoesNotExist(newOwner)
201     {
202         for (uint i=0; i<owners.length; i++)
203             if (owners[i] == owner) {
204                 owners[i] = newOwner;
205                 break;
206             }
207         isOwner[owner] = false;
208         isOwner[newOwner] = true;
209         OwnerRemoval(owner);
210         OwnerAddition(newOwner);
211     }
212 
213     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
214     /// @param _required Number of required confirmations.
215     function changeRequirement(uint _required)
216         public
217         onlyWallet
218         validRequirement(owners.length, _required)
219     {
220         required = _required;
221         RequirementChange(_required);
222     }
223 
224     /// @dev Allows an owner to submit and confirm a transaction.
225     /// @param destination Transaction target address.
226     /// @param value Transaction ether value.
227     /// @param data Transaction data payload.
228     /// @return Returns transaction ID.
229     function submitTransaction(address destination, uint value, bytes data)
230         public
231         returns (uint transactionId)
232     {
233         transactionId = addTransaction(destination, value, data);
234         confirmTransaction(transactionId);
235     }
236 
237     /// @dev Allows an owner to confirm a transaction.
238     /// @param transactionId Transaction ID.
239     function confirmTransaction(uint transactionId)
240         public
241         ownerExists(msg.sender)
242         transactionExists(transactionId)
243         notConfirmed(transactionId, msg.sender)
244     {
245         confirmations[transactionId][msg.sender] = true;
246         Confirmation(msg.sender, transactionId);
247         executeTransaction(transactionId);
248     }
249 
250     /// @dev Allows an owner to revoke a confirmation for a transaction.
251     /// @param transactionId Transaction ID.
252     function revokeConfirmation(uint transactionId)
253         public
254         ownerExists(msg.sender)
255         confirmed(transactionId, msg.sender)
256         notExecuted(transactionId)
257     {
258         confirmations[transactionId][msg.sender] = false;
259         Revocation(msg.sender, transactionId);
260     }
261 
262     /// @dev Allows anyone to execute a confirmed transaction.
263     /// @param transactionId Transaction ID.
264     function executeTransaction(uint transactionId)
265         public
266         ownerExists(msg.sender)
267         confirmed(transactionId, msg.sender)
268         notExecuted(transactionId)
269     {
270         if (isConfirmed(transactionId)) {
271             Transaction tx = transactions[transactionId];
272             tx.executed = true;
273             if (tx.destination.call.value(tx.value)(tx.data))
274                 Execution(transactionId);
275             else {
276                 ExecutionFailure(transactionId);
277                 tx.executed = false;
278             }
279         }
280     }
281 
282     /// @dev Returns the confirmation status of a transaction.
283     /// @param transactionId Transaction ID.
284     /// @return Confirmation status.
285     function isConfirmed(uint transactionId)
286         public
287         constant
288         returns (bool)
289     {
290         uint count = 0;
291         for (uint i=0; i<owners.length; i++) {
292             if (confirmations[transactionId][owners[i]])
293                 count += 1;
294             if (count == required)
295                 return true;
296         }
297     }
298 
299     /*
300      * Internal functions
301      */
302     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
303     /// @param destination Transaction target address.
304     /// @param value Transaction ether value.
305     /// @param data Transaction data payload.
306     /// @return Returns transaction ID.
307     function addTransaction(address destination, uint value, bytes data)
308         internal
309         notNull(destination)
310         returns (uint transactionId)
311     {
312         transactionId = transactionCount;
313         transactions[transactionId] = Transaction({
314             destination: destination,
315             value: value,
316             data: data,
317             executed: false
318         });
319         transactionCount += 1;
320         Submission(transactionId);
321     }
322 
323     /*
324      * Web3 call functions
325      */
326     /// @dev Returns number of confirmations of a transaction.
327     /// @param transactionId Transaction ID.
328     /// @return Number of confirmations.
329     function getConfirmationCount(uint transactionId)
330         public
331         constant
332         returns (uint count)
333     {
334         for (uint i=0; i<owners.length; i++)
335             if (confirmations[transactionId][owners[i]])
336                 count += 1;
337     }
338 
339     /// @dev Returns total number of transactions after filers are applied.
340     /// @param pending Include pending transactions.
341     /// @param executed Include executed transactions.
342     /// @return Total number of transactions after filters are applied.
343     function getTransactionCount(bool pending, bool executed)
344         public
345         constant
346         returns (uint count)
347     {
348         for (uint i=0; i<transactionCount; i++)
349             if (   pending && !transactions[i].executed
350                 || executed && transactions[i].executed)
351                 count += 1;
352     }
353 
354     /// @dev Returns list of owners.
355     /// @return List of owner addresses.
356     function getOwners()
357         public
358         constant
359         returns (address[])
360     {
361         return owners;
362     }
363 
364     /// @dev Returns array with owner addresses, which confirmed transaction.
365     /// @param transactionId Transaction ID.
366     /// @return Returns array of owner addresses.
367     function getConfirmations(uint transactionId)
368         public
369         constant
370         returns (address[] _confirmations)
371     {
372         address[] memory confirmationsTemp = new address[](owners.length);
373         uint count = 0;
374         uint i;
375         for (i=0; i<owners.length; i++)
376             if (confirmations[transactionId][owners[i]]) {
377                 confirmationsTemp[count] = owners[i];
378                 count += 1;
379             }
380         _confirmations = new address[](count);
381         for (i=0; i<count; i++)
382             _confirmations[i] = confirmationsTemp[i];
383     }
384 
385     /// @dev Returns list of transaction IDs in defined range.
386     /// @param from Index start position of transaction array.
387     /// @param to Index end position of transaction array.
388     /// @param pending Include pending transactions.
389     /// @param executed Include executed transactions.
390     /// @return Returns array of transaction IDs.
391     function getTransactionIds(uint from, uint to, bool pending, bool executed)
392         public
393         constant
394         returns (uint[] _transactionIds)
395     {
396         uint[] memory transactionIdsTemp = new uint[](transactionCount);
397         uint count = 0;
398         uint i;
399         for (i=0; i<transactionCount; i++)
400             if (   pending && !transactions[i].executed
401                 || executed && transactions[i].executed)
402             {
403                 transactionIdsTemp[count] = i;
404                 count += 1;
405             }
406         _transactionIds = new uint[](to - from);
407         for (i=from; i<to; i++)
408             _transactionIds[i - from] = transactionIdsTemp[i];
409     }
410 }
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
20         MultisigCreated(address(a), msg.sender, zipper);
21         
22         return address(a);
23     }
24     
25     function changeZipper(address _newZipper) public
26     {
27         require(msg.sender == zipper);
28         zipper = _newZipper;
29     }
30 
31     event MultisigCreated(address _multisig, address indexed _sender, address indexed _zipper);
32 }
33 
34 // b7f01af8bd882501f6801eb1eea8b22aa2a4979e from https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
35 
36 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
37 /// @author Stefan George - <stefan.george@consensys.net>
38 contract MultiSigWallet {
39 
40     /*
41      *  Events
42      */
43     event Confirmation(address indexed sender, uint indexed transactionId);
44     event Revocation(address indexed sender, uint indexed transactionId);
45     event Submission(uint indexed transactionId);
46     event Execution(uint indexed transactionId);
47     event ExecutionFailure(uint indexed transactionId);
48     event Deposit(address indexed sender, uint value);
49     event OwnerAddition(address indexed owner);
50     event OwnerRemoval(address indexed owner);
51     event RequirementChange(uint required);
52 
53     /*
54      *  Constants
55      */
56     uint constant public MAX_OWNER_COUNT = 50;
57 
58     /*
59      *  Storage
60      */
61     mapping (uint => Transaction) public transactions;
62     mapping (uint => mapping (address => bool)) public confirmations;
63     mapping (address => bool) public isOwner;
64     address[] public owners;
65     uint public required;
66     uint public transactionCount;
67 
68     struct Transaction {
69         address destination;
70         uint value;
71         bytes data;
72         bool executed;
73     }
74 
75     /*
76      *  Modifiers
77      */
78     modifier onlyWallet() {
79         if (msg.sender != address(this))
80             throw;
81         _;
82     }
83 
84     modifier ownerDoesNotExist(address owner) {
85         if (isOwner[owner])
86             throw;
87         _;
88     }
89 
90     modifier ownerExists(address owner) {
91         if (!isOwner[owner])
92             throw;
93         _;
94     }
95 
96     modifier transactionExists(uint transactionId) {
97         if (transactions[transactionId].destination == 0)
98             throw;
99         _;
100     }
101 
102     modifier confirmed(uint transactionId, address owner) {
103         if (!confirmations[transactionId][owner])
104             throw;
105         _;
106     }
107 
108     modifier notConfirmed(uint transactionId, address owner) {
109         if (confirmations[transactionId][owner])
110             throw;
111         _;
112     }
113 
114     modifier notExecuted(uint transactionId) {
115         if (transactions[transactionId].executed)
116             throw;
117         _;
118     }
119 
120     modifier notNull(address _address) {
121         if (_address == 0)
122             throw;
123         _;
124     }
125 
126     modifier validRequirement(uint ownerCount, uint _required) {
127         if (   ownerCount > MAX_OWNER_COUNT
128             || _required > ownerCount
129             || _required == 0
130             || ownerCount == 0)
131             throw;
132         _;
133     }
134 
135     /// @dev Fallback function allows to deposit ether.
136     function()
137         payable
138     {
139         if (msg.value > 0)
140             Deposit(msg.sender, msg.value);
141     }
142 
143     /*
144      * Public functions
145      */
146     /// @dev Contract constructor sets initial owners and required number of confirmations.
147     /// @param _owners List of initial owners.
148     /// @param _required Number of required confirmations.
149     function MultiSigWallet(address[] _owners, uint _required)
150         public
151         validRequirement(_owners.length, _required)
152     {
153         for (uint i=0; i<_owners.length; i++) {
154             if (isOwner[_owners[i]] || _owners[i] == 0)
155                 throw;
156             isOwner[_owners[i]] = true;
157         }
158         owners = _owners;
159         required = _required;
160     }
161 
162     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
163     /// @param owner Address of new owner.
164     function addOwner(address owner)
165         public
166         onlyWallet
167         ownerDoesNotExist(owner)
168         notNull(owner)
169         validRequirement(owners.length + 1, required)
170     {
171         isOwner[owner] = true;
172         owners.push(owner);
173         OwnerAddition(owner);
174     }
175 
176     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
177     /// @param owner Address of owner.
178     function removeOwner(address owner)
179         public
180         onlyWallet
181         ownerExists(owner)
182     {
183         isOwner[owner] = false;
184         for (uint i=0; i<owners.length - 1; i++)
185             if (owners[i] == owner) {
186                 owners[i] = owners[owners.length - 1];
187                 break;
188             }
189         owners.length -= 1;
190         if (required > owners.length)
191             changeRequirement(owners.length);
192         OwnerRemoval(owner);
193     }
194 
195     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
196     /// @param owner Address of owner to be replaced.
197     /// @param newOwner Address of new owner.
198     function replaceOwner(address owner, address newOwner)
199         public
200         onlyWallet
201         ownerExists(owner)
202         ownerDoesNotExist(newOwner)
203     {
204         for (uint i=0; i<owners.length; i++)
205             if (owners[i] == owner) {
206                 owners[i] = newOwner;
207                 break;
208             }
209         isOwner[owner] = false;
210         isOwner[newOwner] = true;
211         OwnerRemoval(owner);
212         OwnerAddition(newOwner);
213     }
214 
215     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
216     /// @param _required Number of required confirmations.
217     function changeRequirement(uint _required)
218         public
219         onlyWallet
220         validRequirement(owners.length, _required)
221     {
222         required = _required;
223         RequirementChange(_required);
224     }
225 
226     /// @dev Allows an owner to submit and confirm a transaction.
227     /// @param destination Transaction target address.
228     /// @param value Transaction ether value.
229     /// @param data Transaction data payload.
230     /// @return Returns transaction ID.
231     function submitTransaction(address destination, uint value, bytes data)
232         public
233         returns (uint transactionId)
234     {
235         transactionId = addTransaction(destination, value, data);
236         confirmTransaction(transactionId);
237     }
238 
239     /// @dev Allows an owner to confirm a transaction.
240     /// @param transactionId Transaction ID.
241     function confirmTransaction(uint transactionId)
242         public
243         ownerExists(msg.sender)
244         transactionExists(transactionId)
245         notConfirmed(transactionId, msg.sender)
246     {
247         confirmations[transactionId][msg.sender] = true;
248         Confirmation(msg.sender, transactionId);
249         executeTransaction(transactionId);
250     }
251 
252     /// @dev Allows an owner to revoke a confirmation for a transaction.
253     /// @param transactionId Transaction ID.
254     function revokeConfirmation(uint transactionId)
255         public
256         ownerExists(msg.sender)
257         confirmed(transactionId, msg.sender)
258         notExecuted(transactionId)
259     {
260         confirmations[transactionId][msg.sender] = false;
261         Revocation(msg.sender, transactionId);
262     }
263 
264     /// @dev Allows anyone to execute a confirmed transaction.
265     /// @param transactionId Transaction ID.
266     function executeTransaction(uint transactionId)
267         public
268         ownerExists(msg.sender)
269         confirmed(transactionId, msg.sender)
270         notExecuted(transactionId)
271     {
272         if (isConfirmed(transactionId)) {
273             Transaction tx = transactions[transactionId];
274             tx.executed = true;
275             if (tx.destination.call.value(tx.value)(tx.data))
276                 Execution(transactionId);
277             else {
278                 ExecutionFailure(transactionId);
279                 tx.executed = false;
280             }
281         }
282     }
283 
284     /// @dev Returns the confirmation status of a transaction.
285     /// @param transactionId Transaction ID.
286     /// @return Confirmation status.
287     function isConfirmed(uint transactionId)
288         public
289         constant
290         returns (bool)
291     {
292         uint count = 0;
293         for (uint i=0; i<owners.length; i++) {
294             if (confirmations[transactionId][owners[i]])
295                 count += 1;
296             if (count == required)
297                 return true;
298         }
299     }
300 
301     /*
302      * Internal functions
303      */
304     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
305     /// @param destination Transaction target address.
306     /// @param value Transaction ether value.
307     /// @param data Transaction data payload.
308     /// @return Returns transaction ID.
309     function addTransaction(address destination, uint value, bytes data)
310         internal
311         notNull(destination)
312         returns (uint transactionId)
313     {
314         transactionId = transactionCount;
315         transactions[transactionId] = Transaction({
316             destination: destination,
317             value: value,
318             data: data,
319             executed: false
320         });
321         transactionCount += 1;
322         Submission(transactionId);
323     }
324 
325     /*
326      * Web3 call functions
327      */
328     /// @dev Returns number of confirmations of a transaction.
329     /// @param transactionId Transaction ID.
330     /// @return Number of confirmations.
331     function getConfirmationCount(uint transactionId)
332         public
333         constant
334         returns (uint count)
335     {
336         for (uint i=0; i<owners.length; i++)
337             if (confirmations[transactionId][owners[i]])
338                 count += 1;
339     }
340 
341     /// @dev Returns total number of transactions after filers are applied.
342     /// @param pending Include pending transactions.
343     /// @param executed Include executed transactions.
344     /// @return Total number of transactions after filters are applied.
345     function getTransactionCount(bool pending, bool executed)
346         public
347         constant
348         returns (uint count)
349     {
350         for (uint i=0; i<transactionCount; i++)
351             if (   pending && !transactions[i].executed
352                 || executed && transactions[i].executed)
353                 count += 1;
354     }
355 
356     /// @dev Returns list of owners.
357     /// @return List of owner addresses.
358     function getOwners()
359         public
360         constant
361         returns (address[])
362     {
363         return owners;
364     }
365 
366     /// @dev Returns array with owner addresses, which confirmed transaction.
367     /// @param transactionId Transaction ID.
368     /// @return Returns array of owner addresses.
369     function getConfirmations(uint transactionId)
370         public
371         constant
372         returns (address[] _confirmations)
373     {
374         address[] memory confirmationsTemp = new address[](owners.length);
375         uint count = 0;
376         uint i;
377         for (i=0; i<owners.length; i++)
378             if (confirmations[transactionId][owners[i]]) {
379                 confirmationsTemp[count] = owners[i];
380                 count += 1;
381             }
382         _confirmations = new address[](count);
383         for (i=0; i<count; i++)
384             _confirmations[i] = confirmationsTemp[i];
385     }
386 
387     /// @dev Returns list of transaction IDs in defined range.
388     /// @param from Index start position of transaction array.
389     /// @param to Index end position of transaction array.
390     /// @param pending Include pending transactions.
391     /// @param executed Include executed transactions.
392     /// @return Returns array of transaction IDs.
393     function getTransactionIds(uint from, uint to, bool pending, bool executed)
394         public
395         constant
396         returns (uint[] _transactionIds)
397     {
398         uint[] memory transactionIdsTemp = new uint[](transactionCount);
399         uint count = 0;
400         uint i;
401         for (i=0; i<transactionCount; i++)
402             if (   pending && !transactions[i].executed
403                 || executed && transactions[i].executed)
404             {
405                 transactionIdsTemp[count] = i;
406                 count += 1;
407             }
408         _transactionIds = new uint[](to - from);
409         for (i=from; i<to; i++)
410             _transactionIds[i - from] = transactionIdsTemp[i];
411     }
412 }
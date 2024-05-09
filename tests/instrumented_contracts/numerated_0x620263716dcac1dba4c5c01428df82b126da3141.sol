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
21         return a;
22     }
23     
24     function changeZipper(address _newZipper) public
25     {
26         require(msg.sender == zipper);
27         zipper = _newZipper;
28     }
29 
30     event MultisigCreated(address _multisig, address indexed _sender, address indexed _zipper);
31 }
32 
33 // b7f01af8bd882501f6801eb1eea8b22aa2a4979e from https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
34 
35 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
36 /// @author Stefan George - <stefan.george@consensys.net>
37 contract MultiSigWallet {
38 
39     /*
40      *  Events
41      */
42     event Confirmation(address indexed sender, uint indexed transactionId);
43     event Revocation(address indexed sender, uint indexed transactionId);
44     event Submission(uint indexed transactionId);
45     event Execution(uint indexed transactionId);
46     event ExecutionFailure(uint indexed transactionId);
47     event Deposit(address indexed sender, uint value);
48     event OwnerAddition(address indexed owner);
49     event OwnerRemoval(address indexed owner);
50     event RequirementChange(uint required);
51 
52     /*
53      *  Constants
54      */
55     uint constant public MAX_OWNER_COUNT = 50;
56 
57     /*
58      *  Storage
59      */
60     mapping (uint => Transaction) public transactions;
61     mapping (uint => mapping (address => bool)) public confirmations;
62     mapping (address => bool) public isOwner;
63     address[] public owners;
64     uint public required;
65     uint public transactionCount;
66 
67     struct Transaction {
68         address destination;
69         uint value;
70         bytes data;
71         bool executed;
72     }
73 
74     /*
75      *  Modifiers
76      */
77     modifier onlyWallet() {
78         if (msg.sender != address(this))
79             throw;
80         _;
81     }
82 
83     modifier ownerDoesNotExist(address owner) {
84         if (isOwner[owner])
85             throw;
86         _;
87     }
88 
89     modifier ownerExists(address owner) {
90         if (!isOwner[owner])
91             throw;
92         _;
93     }
94 
95     modifier transactionExists(uint transactionId) {
96         if (transactions[transactionId].destination == 0)
97             throw;
98         _;
99     }
100 
101     modifier confirmed(uint transactionId, address owner) {
102         if (!confirmations[transactionId][owner])
103             throw;
104         _;
105     }
106 
107     modifier notConfirmed(uint transactionId, address owner) {
108         if (confirmations[transactionId][owner])
109             throw;
110         _;
111     }
112 
113     modifier notExecuted(uint transactionId) {
114         if (transactions[transactionId].executed)
115             throw;
116         _;
117     }
118 
119     modifier notNull(address _address) {
120         if (_address == 0)
121             throw;
122         _;
123     }
124 
125     modifier validRequirement(uint ownerCount, uint _required) {
126         if (   ownerCount > MAX_OWNER_COUNT
127             || _required > ownerCount
128             || _required == 0
129             || ownerCount == 0)
130             throw;
131         _;
132     }
133 
134     /// @dev Fallback function allows to deposit ether.
135     function()
136         payable
137     {
138         if (msg.value > 0)
139             Deposit(msg.sender, msg.value);
140     }
141 
142     /*
143      * Public functions
144      */
145     /// @dev Contract constructor sets initial owners and required number of confirmations.
146     /// @param _owners List of initial owners.
147     /// @param _required Number of required confirmations.
148     function MultiSigWallet(address[] _owners, uint _required)
149         public
150         validRequirement(_owners.length, _required)
151     {
152         for (uint i=0; i<_owners.length; i++) {
153             if (isOwner[_owners[i]] || _owners[i] == 0)
154                 throw;
155             isOwner[_owners[i]] = true;
156         }
157         owners = _owners;
158         required = _required;
159     }
160 
161     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
162     /// @param owner Address of new owner.
163     function addOwner(address owner)
164         public
165         onlyWallet
166         ownerDoesNotExist(owner)
167         notNull(owner)
168         validRequirement(owners.length + 1, required)
169     {
170         isOwner[owner] = true;
171         owners.push(owner);
172         OwnerAddition(owner);
173     }
174 
175     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
176     /// @param owner Address of owner.
177     function removeOwner(address owner)
178         public
179         onlyWallet
180         ownerExists(owner)
181     {
182         isOwner[owner] = false;
183         for (uint i=0; i<owners.length - 1; i++)
184             if (owners[i] == owner) {
185                 owners[i] = owners[owners.length - 1];
186                 break;
187             }
188         owners.length -= 1;
189         if (required > owners.length)
190             changeRequirement(owners.length);
191         OwnerRemoval(owner);
192     }
193 
194     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
195     /// @param owner Address of owner to be replaced.
196     /// @param newOwner Address of new owner.
197     function replaceOwner(address owner, address newOwner)
198         public
199         onlyWallet
200         ownerExists(owner)
201         ownerDoesNotExist(newOwner)
202     {
203         for (uint i=0; i<owners.length; i++)
204             if (owners[i] == owner) {
205                 owners[i] = newOwner;
206                 break;
207             }
208         isOwner[owner] = false;
209         isOwner[newOwner] = true;
210         OwnerRemoval(owner);
211         OwnerAddition(newOwner);
212     }
213 
214     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
215     /// @param _required Number of required confirmations.
216     function changeRequirement(uint _required)
217         public
218         onlyWallet
219         validRequirement(owners.length, _required)
220     {
221         required = _required;
222         RequirementChange(_required);
223     }
224 
225     /// @dev Allows an owner to submit and confirm a transaction.
226     /// @param destination Transaction target address.
227     /// @param value Transaction ether value.
228     /// @param data Transaction data payload.
229     /// @return Returns transaction ID.
230     function submitTransaction(address destination, uint value, bytes data)
231         public
232         returns (uint transactionId)
233     {
234         transactionId = addTransaction(destination, value, data);
235         confirmTransaction(transactionId);
236     }
237 
238     /// @dev Allows an owner to confirm a transaction.
239     /// @param transactionId Transaction ID.
240     function confirmTransaction(uint transactionId)
241         public
242         ownerExists(msg.sender)
243         transactionExists(transactionId)
244         notConfirmed(transactionId, msg.sender)
245     {
246         confirmations[transactionId][msg.sender] = true;
247         Confirmation(msg.sender, transactionId);
248         executeTransaction(transactionId);
249     }
250 
251     /// @dev Allows an owner to revoke a confirmation for a transaction.
252     /// @param transactionId Transaction ID.
253     function revokeConfirmation(uint transactionId)
254         public
255         ownerExists(msg.sender)
256         confirmed(transactionId, msg.sender)
257         notExecuted(transactionId)
258     {
259         confirmations[transactionId][msg.sender] = false;
260         Revocation(msg.sender, transactionId);
261     }
262 
263     /// @dev Allows anyone to execute a confirmed transaction.
264     /// @param transactionId Transaction ID.
265     function executeTransaction(uint transactionId)
266         public
267         ownerExists(msg.sender)
268         confirmed(transactionId, msg.sender)
269         notExecuted(transactionId)
270     {
271         if (isConfirmed(transactionId)) {
272             Transaction tx = transactions[transactionId];
273             tx.executed = true;
274             if (tx.destination.call.value(tx.value)(tx.data))
275                 Execution(transactionId);
276             else {
277                 ExecutionFailure(transactionId);
278                 tx.executed = false;
279             }
280         }
281     }
282 
283     /// @dev Returns the confirmation status of a transaction.
284     /// @param transactionId Transaction ID.
285     /// @return Confirmation status.
286     function isConfirmed(uint transactionId)
287         public
288         constant
289         returns (bool)
290     {
291         uint count = 0;
292         for (uint i=0; i<owners.length; i++) {
293             if (confirmations[transactionId][owners[i]])
294                 count += 1;
295             if (count == required)
296                 return true;
297         }
298     }
299 
300     /*
301      * Internal functions
302      */
303     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
304     /// @param destination Transaction target address.
305     /// @param value Transaction ether value.
306     /// @param data Transaction data payload.
307     /// @return Returns transaction ID.
308     function addTransaction(address destination, uint value, bytes data)
309         internal
310         notNull(destination)
311         returns (uint transactionId)
312     {
313         transactionId = transactionCount;
314         transactions[transactionId] = Transaction({
315             destination: destination,
316             value: value,
317             data: data,
318             executed: false
319         });
320         transactionCount += 1;
321         Submission(transactionId);
322     }
323 
324     /*
325      * Web3 call functions
326      */
327     /// @dev Returns number of confirmations of a transaction.
328     /// @param transactionId Transaction ID.
329     /// @return Number of confirmations.
330     function getConfirmationCount(uint transactionId)
331         public
332         constant
333         returns (uint count)
334     {
335         for (uint i=0; i<owners.length; i++)
336             if (confirmations[transactionId][owners[i]])
337                 count += 1;
338     }
339 
340     /// @dev Returns total number of transactions after filers are applied.
341     /// @param pending Include pending transactions.
342     /// @param executed Include executed transactions.
343     /// @return Total number of transactions after filters are applied.
344     function getTransactionCount(bool pending, bool executed)
345         public
346         constant
347         returns (uint count)
348     {
349         for (uint i=0; i<transactionCount; i++)
350             if (   pending && !transactions[i].executed
351                 || executed && transactions[i].executed)
352                 count += 1;
353     }
354 
355     /// @dev Returns list of owners.
356     /// @return List of owner addresses.
357     function getOwners()
358         public
359         constant
360         returns (address[])
361     {
362         return owners;
363     }
364 
365     /// @dev Returns array with owner addresses, which confirmed transaction.
366     /// @param transactionId Transaction ID.
367     /// @return Returns array of owner addresses.
368     function getConfirmations(uint transactionId)
369         public
370         constant
371         returns (address[] _confirmations)
372     {
373         address[] memory confirmationsTemp = new address[](owners.length);
374         uint count = 0;
375         uint i;
376         for (i=0; i<owners.length; i++)
377             if (confirmations[transactionId][owners[i]]) {
378                 confirmationsTemp[count] = owners[i];
379                 count += 1;
380             }
381         _confirmations = new address[](count);
382         for (i=0; i<count; i++)
383             _confirmations[i] = confirmationsTemp[i];
384     }
385 
386     /// @dev Returns list of transaction IDs in defined range.
387     /// @param from Index start position of transaction array.
388     /// @param to Index end position of transaction array.
389     /// @param pending Include pending transactions.
390     /// @param executed Include executed transactions.
391     /// @return Returns array of transaction IDs.
392     function getTransactionIds(uint from, uint to, bool pending, bool executed)
393         public
394         constant
395         returns (uint[] _transactionIds)
396     {
397         uint[] memory transactionIdsTemp = new uint[](transactionCount);
398         uint count = 0;
399         uint i;
400         for (i=0; i<transactionCount; i++)
401             if (   pending && !transactions[i].executed
402                 || executed && transactions[i].executed)
403             {
404                 transactionIdsTemp[count] = i;
405                 count += 1;
406             }
407         _transactionIds = new uint[](to - from);
408         for (i=from; i<to; i++)
409             _transactionIds[i - from] = transactionIdsTemp[i];
410     }
411 }
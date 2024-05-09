1 pragma solidity ^0.4.18;
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
14     event ExecutionFailure(uint indexed transactionId);
15     event Deposit(address indexed sender, uint value);
16     event OwnerAddition(address indexed owner);
17     event OwnerRemoval(address indexed owner);
18     event RequirementChange(uint required);
19 
20     /*
21      *  Constants
22      */
23     uint constant public MAX_OWNER_COUNT = 50;
24 
25     /*
26      *  Storage
27      */
28     mapping (uint => Transaction) public transactions;
29     mapping (uint => mapping (address => bool)) public confirmations;
30     mapping (address => bool) public isOwner;
31     address[] public owners;
32     uint public required;
33     uint public transactionCount;
34 
35     struct Transaction {
36         address destination;
37         uint value;
38         bytes data;
39         bool executed;
40     }
41 
42     /*
43      *  Modifiers
44      */
45     modifier onlyWallet() {
46         if (msg.sender != address(this))
47             throw;
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         if (isOwner[owner])
53             throw;
54         _;
55     }
56 
57     modifier ownerExists(address owner) {
58         if (!isOwner[owner])
59             throw;
60         _;
61     }
62 
63     modifier transactionExists(uint transactionId) {
64         if (transactions[transactionId].destination == 0)
65             throw;
66         _;
67     }
68 
69     modifier confirmed(uint transactionId, address owner) {
70         if (!confirmations[transactionId][owner])
71             throw;
72         _;
73     }
74 
75     modifier notConfirmed(uint transactionId, address owner) {
76         if (confirmations[transactionId][owner])
77             throw;
78         _;
79     }
80 
81     modifier notExecuted(uint transactionId) {
82         if (transactions[transactionId].executed)
83             throw;
84         _;
85     }
86 
87     modifier notNull(address _address) {
88         if (_address == 0)
89             throw;
90         _;
91     }
92 
93     modifier validRequirement(uint ownerCount, uint _required) {
94         if (   ownerCount > MAX_OWNER_COUNT
95             || _required > ownerCount
96             || _required == 0
97             || ownerCount == 0)
98             throw;
99         _;
100     }
101 
102     /// @dev Fallback function allows to deposit ether.
103     function()
104         payable
105     {
106         if (msg.value > 0)
107             Deposit(msg.sender, msg.value);
108     }
109 
110     /*
111      * Public functions
112      */
113     /// @dev Contract constructor sets initial owners and required number of confirmations.
114     /// @param _owners List of initial owners.
115     /// @param _required Number of required confirmations.
116     function MultiSigWallet(address[] _owners, uint _required)
117         public
118         validRequirement(_owners.length, _required)
119     {
120         for (uint i=0; i<_owners.length; i++) {
121             if (isOwner[_owners[i]] || _owners[i] == 0)
122                 throw;
123             isOwner[_owners[i]] = true;
124         }
125         owners = _owners;
126         required = _required;
127     }
128 
129     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
130     /// @param owner Address of new owner.
131     function addOwner(address owner)
132         public
133         onlyWallet
134         ownerDoesNotExist(owner)
135         notNull(owner)
136         validRequirement(owners.length + 1, required)
137     {
138         isOwner[owner] = true;
139         owners.push(owner);
140         OwnerAddition(owner);
141     }
142 
143     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
144     /// @param owner Address of owner.
145     function removeOwner(address owner)
146         public
147         onlyWallet
148         ownerExists(owner)
149     {
150         isOwner[owner] = false;
151         for (uint i=0; i<owners.length - 1; i++)
152             if (owners[i] == owner) {
153                 owners[i] = owners[owners.length - 1];
154                 break;
155             }
156         owners.length -= 1;
157         if (required > owners.length)
158             changeRequirement(owners.length);
159         OwnerRemoval(owner);
160     }
161 
162     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
163     /// @param owner Address of owner to be replaced.
164     /// @param newOwner Address of new owner.
165     function replaceOwner(address owner, address newOwner)
166         public
167         onlyWallet
168         ownerExists(owner)
169         ownerDoesNotExist(newOwner)
170     {
171         for (uint i=0; i<owners.length; i++)
172             if (owners[i] == owner) {
173                 owners[i] = newOwner;
174                 break;
175             }
176         isOwner[owner] = false;
177         isOwner[newOwner] = true;
178         OwnerRemoval(owner);
179         OwnerAddition(newOwner);
180     }
181 
182     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
183     /// @param _required Number of required confirmations.
184     function changeRequirement(uint _required)
185         public
186         onlyWallet
187         validRequirement(owners.length, _required)
188     {
189         required = _required;
190         RequirementChange(_required);
191     }
192 
193     /// @dev Allows an owner to submit and confirm a transaction.
194     /// @param destination Transaction target address.
195     /// @param value Transaction ether value.
196     /// @param data Transaction data payload.
197     /// @return Returns transaction ID.
198     function submitTransaction(address destination, uint value, bytes data)
199         public
200         returns (uint transactionId)
201     {
202         transactionId = addTransaction(destination, value, data);
203         confirmTransaction(transactionId);
204     }
205 
206     /// @dev Allows an owner to confirm a transaction.
207     /// @param transactionId Transaction ID.
208     function confirmTransaction(uint transactionId)
209         public
210         ownerExists(msg.sender)
211         transactionExists(transactionId)
212         notConfirmed(transactionId, msg.sender)
213     {
214         confirmations[transactionId][msg.sender] = true;
215         Confirmation(msg.sender, transactionId);
216         executeTransaction(transactionId);
217     }
218 
219     /// @dev Allows an owner to revoke a confirmation for a transaction.
220     /// @param transactionId Transaction ID.
221     function revokeConfirmation(uint transactionId)
222         public
223         ownerExists(msg.sender)
224         confirmed(transactionId, msg.sender)
225         notExecuted(transactionId)
226     {
227         confirmations[transactionId][msg.sender] = false;
228         Revocation(msg.sender, transactionId);
229     }
230 
231     /// @dev Allows anyone to execute a confirmed transaction.
232     /// @param transactionId Transaction ID.
233     function executeTransaction(uint transactionId)
234         public
235         ownerExists(msg.sender)
236         confirmed(transactionId, msg.sender)
237         notExecuted(transactionId)
238     {
239         if (isConfirmed(transactionId)) {
240             Transaction tx = transactions[transactionId];
241             tx.executed = true;
242             if (tx.destination.call.value(tx.value)(tx.data))
243                 Execution(transactionId);
244             else {
245                 ExecutionFailure(transactionId);
246                 tx.executed = false;
247             }
248         }
249     }
250 
251     /// @dev Returns the confirmation status of a transaction.
252     /// @param transactionId Transaction ID.
253     /// @return Confirmation status.
254     function isConfirmed(uint transactionId)
255         public
256         constant
257         returns (bool)
258     {
259         uint count = 0;
260         for (uint i=0; i<owners.length; i++) {
261             if (confirmations[transactionId][owners[i]])
262                 count += 1;
263             if (count == required)
264                 return true;
265         }
266     }
267 
268     /*
269      * Internal functions
270      */
271     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
272     /// @param destination Transaction target address.
273     /// @param value Transaction ether value.
274     /// @param data Transaction data payload.
275     /// @return Returns transaction ID.
276     function addTransaction(address destination, uint value, bytes data)
277         internal
278         notNull(destination)
279         returns (uint transactionId)
280     {
281         transactionId = transactionCount;
282         transactions[transactionId] = Transaction({
283             destination: destination,
284             value: value,
285             data: data,
286             executed: false
287         });
288         transactionCount += 1;
289         Submission(transactionId);
290     }
291 
292     /*
293      * Web3 call functions
294      */
295     /// @dev Returns number of confirmations of a transaction.
296     /// @param transactionId Transaction ID.
297     /// @return Number of confirmations.
298     function getConfirmationCount(uint transactionId)
299         public
300         constant
301         returns (uint count)
302     {
303         for (uint i=0; i<owners.length; i++)
304             if (confirmations[transactionId][owners[i]])
305                 count += 1;
306     }
307 
308     /// @dev Returns total number of transactions after filers are applied.
309     /// @param pending Include pending transactions.
310     /// @param executed Include executed transactions.
311     /// @return Total number of transactions after filters are applied.
312     function getTransactionCount(bool pending, bool executed)
313         public
314         constant
315         returns (uint count)
316     {
317         for (uint i=0; i<transactionCount; i++)
318             if (   pending && !transactions[i].executed
319                 || executed && transactions[i].executed)
320                 count += 1;
321     }
322 
323     /// @dev Returns list of owners.
324     /// @return List of owner addresses.
325     function getOwners()
326         public
327         constant
328         returns (address[])
329     {
330         return owners;
331     }
332 
333     /// @dev Returns array with owner addresses, which confirmed transaction.
334     /// @param transactionId Transaction ID.
335     /// @return Returns array of owner addresses.
336     function getConfirmations(uint transactionId)
337         public
338         constant
339         returns (address[] _confirmations)
340     {
341         address[] memory confirmationsTemp = new address[](owners.length);
342         uint count = 0;
343         uint i;
344         for (i=0; i<owners.length; i++)
345             if (confirmations[transactionId][owners[i]]) {
346                 confirmationsTemp[count] = owners[i];
347                 count += 1;
348             }
349         _confirmations = new address[](count);
350         for (i=0; i<count; i++)
351             _confirmations[i] = confirmationsTemp[i];
352     }
353 
354     /// @dev Returns list of transaction IDs in defined range.
355     /// @param from Index start position of transaction array.
356     /// @param to Index end position of transaction array.
357     /// @param pending Include pending transactions.
358     /// @param executed Include executed transactions.
359     /// @return Returns array of transaction IDs.
360     function getTransactionIds(uint from, uint to, bool pending, bool executed)
361         public
362         constant
363         returns (uint[] _transactionIds)
364     {
365         uint[] memory transactionIdsTemp = new uint[](transactionCount);
366         uint count = 0;
367         uint i;
368         for (i=0; i<transactionCount; i++)
369             if (   pending && !transactions[i].executed
370                 || executed && transactions[i].executed)
371             {
372                 transactionIdsTemp[count] = i;
373                 count += 1;
374             }
375         _transactionIds = new uint[](to - from);
376         for (i=from; i<to; i++)
377             _transactionIds[i - from] = transactionIdsTemp[i];
378     }
379 }
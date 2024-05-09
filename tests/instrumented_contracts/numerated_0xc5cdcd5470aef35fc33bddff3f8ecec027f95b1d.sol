1 pragma solidity ^0.4.4;
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
35         if (msg.sender != address(this))
36             throw;
37         _;
38     }
39 
40     modifier ownerDoesNotExist(address owner) {
41         if (isOwner[owner])
42             throw;
43         _;
44     }
45 
46     modifier ownerExists(address owner) {
47         if (!isOwner[owner])
48             throw;
49         _;
50     }
51 
52     modifier transactionExists(uint transactionId) {
53         if (transactions[transactionId].destination == 0)
54             throw;
55         _;
56     }
57 
58     modifier confirmed(uint transactionId, address owner) {
59         if (!confirmations[transactionId][owner])
60             throw;
61         _;
62     }
63 
64     modifier notConfirmed(uint transactionId, address owner) {
65         if (confirmations[transactionId][owner])
66             throw;
67         _;
68     }
69 
70     modifier notExecuted(uint transactionId) {
71         if (transactions[transactionId].executed)
72             throw;
73         _;
74     }
75 
76     modifier notNull(address _address) {
77         if (_address == 0)
78             throw;
79         _;
80     }
81 
82     modifier validRequirement(uint ownerCount, uint _required) {
83         if (   ownerCount > MAX_OWNER_COUNT
84             || _required > ownerCount
85             || _required == 0
86             || ownerCount == 0)
87             throw;
88         _;
89     }
90 
91     /// @dev Fallback function allows to deposit ether.
92     function()
93         payable
94     {
95         if (msg.value > 0)
96             Deposit(msg.sender, msg.value);
97     }
98 
99     /*
100      * Public functions
101      */
102     /// @dev Contract constructor sets initial owners and required number of confirmations.
103     /// @param _owners List of initial owners.
104     /// @param _required Number of required confirmations.
105     function MultiSigWallet(address[] _owners, uint _required)
106         public
107         validRequirement(_owners.length, _required)
108     {
109         for (uint i=0; i<_owners.length; i++) {
110             if (isOwner[_owners[i]] || _owners[i] == 0)
111                 throw;
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
153     /// @param owner Address of new owner.
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
224         notExecuted(transactionId)
225     {
226         if (isConfirmed(transactionId)) {
227             Transaction tx = transactions[transactionId];
228             tx.executed = true;
229             if (tx.destination.call.value(tx.value)(tx.data))
230                 Execution(transactionId);
231             else {
232                 ExecutionFailure(transactionId);
233                 tx.executed = false;
234             }
235         }
236     }
237 
238     /// @dev Returns the confirmation status of a transaction.
239     /// @param transactionId Transaction ID.
240     /// @return Confirmation status.
241     function isConfirmed(uint transactionId)
242         public
243         constant
244         returns (bool)
245     {
246         uint count = 0;
247         for (uint i=0; i<owners.length; i++) {
248             if (confirmations[transactionId][owners[i]])
249                 count += 1;
250             if (count == required)
251                 return true;
252         }
253     }
254 
255     /*
256      * Internal functions
257      */
258     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
259     /// @param destination Transaction target address.
260     /// @param value Transaction ether value.
261     /// @param data Transaction data payload.
262     /// @return Returns transaction ID.
263     function addTransaction(address destination, uint value, bytes data)
264         internal
265         notNull(destination)
266         returns (uint transactionId)
267     {
268         transactionId = transactionCount;
269         transactions[transactionId] = Transaction({
270             destination: destination,
271             value: value,
272             data: data,
273             executed: false
274         });
275         transactionCount += 1;
276         Submission(transactionId);
277     }
278 
279     /*
280      * Web3 call functions
281      */
282     /// @dev Returns number of confirmations of a transaction.
283     /// @param transactionId Transaction ID.
284     /// @return Number of confirmations.
285     function getConfirmationCount(uint transactionId)
286         public
287         constant
288         returns (uint count)
289     {
290         for (uint i=0; i<owners.length; i++)
291             if (confirmations[transactionId][owners[i]])
292                 count += 1;
293     }
294 
295     /// @dev Returns total number of transactions after filers are applied.
296     /// @param pending Include pending transactions.
297     /// @param executed Include executed transactions.
298     /// @return Total number of transactions after filters are applied.
299     function getTransactionCount(bool pending, bool executed)
300         public
301         constant
302         returns (uint count)
303     {
304         for (uint i=0; i<transactionCount; i++)
305             if (   pending && !transactions[i].executed
306                 || executed && transactions[i].executed)
307                 count += 1;
308     }
309 
310     /// @dev Returns list of owners.
311     /// @return List of owner addresses.
312     function getOwners()
313         public
314         constant
315         returns (address[])
316     {
317         return owners;
318     }
319 
320     /// @dev Returns array with owner addresses, which confirmed transaction.
321     /// @param transactionId Transaction ID.
322     /// @return Returns array of owner addresses.
323     function getConfirmations(uint transactionId)
324         public
325         constant
326         returns (address[] _confirmations)
327     {
328         address[] memory confirmationsTemp = new address[](owners.length);
329         uint count = 0;
330         uint i;
331         for (i=0; i<owners.length; i++)
332             if (confirmations[transactionId][owners[i]]) {
333                 confirmationsTemp[count] = owners[i];
334                 count += 1;
335             }
336         _confirmations = new address[](count);
337         for (i=0; i<count; i++)
338             _confirmations[i] = confirmationsTemp[i];
339     }
340 
341     /// @dev Returns list of transaction IDs in defined range.
342     /// @param from Index start position of transaction array.
343     /// @param to Index end position of transaction array.
344     /// @param pending Include pending transactions.
345     /// @param executed Include executed transactions.
346     /// @return Returns array of transaction IDs.
347     function getTransactionIds(uint from, uint to, bool pending, bool executed)
348         public
349         constant
350         returns (uint[] _transactionIds)
351     {
352         uint[] memory transactionIdsTemp = new uint[](transactionCount);
353         uint count = 0;
354         uint i;
355         for (i=0; i<transactionCount; i++)
356             if (   pending && !transactions[i].executed
357                 || executed && transactions[i].executed)
358             {
359                 transactionIdsTemp[count] = i;
360                 count += 1;
361             }
362         _transactionIds = new uint[](to - from);
363         for (i=from; i<to; i++)
364             _transactionIds[i - from] = transactionIdsTemp[i];
365     }
366 }
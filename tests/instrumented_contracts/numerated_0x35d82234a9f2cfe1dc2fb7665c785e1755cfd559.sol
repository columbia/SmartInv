1 // File: contracts/GnosisWallet.sol
2 
3 /**
4  * Originally from https://github.com/ConsenSys/MultiSigWallet
5  */
6 
7 pragma solidity ^0.4.8;
8 
9 
10 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
11 /// @author Stefan George - <stefan.george@consensys.net>
12 contract MultiSigWallet {
13 
14     uint constant public MAX_OWNER_COUNT = 50;
15 
16     event Confirmation(address indexed sender, uint indexed transactionId);
17     event Revocation(address indexed sender, uint indexed transactionId);
18     event Submission(uint indexed transactionId);
19     event Execution(uint indexed transactionId);
20     event ExecutionFailure(uint indexed transactionId);
21     event Deposit(address indexed sender, uint value);
22     event OwnerAddition(address indexed owner);
23     event OwnerRemoval(address indexed owner);
24     event RequirementChange(uint required);
25 
26     mapping (uint => Transaction) public transactions;
27     mapping (uint => mapping (address => bool)) public confirmations;
28     mapping (address => bool) public isOwner;
29     address[] public owners;
30     uint public required;
31     uint public transactionCount;
32 
33     struct Transaction {
34         address destination;
35         uint value;
36         bytes data;
37         bool executed;
38     }
39 
40     modifier onlyWallet() {
41         if (msg.sender != address(this))
42             throw;
43         _;
44     }
45 
46     modifier ownerDoesNotExist(address owner) {
47         if (isOwner[owner])
48             throw;
49         _;
50     }
51 
52     modifier ownerExists(address owner) {
53         if (!isOwner[owner])
54             throw;
55         _;
56     }
57 
58     modifier transactionExists(uint transactionId) {
59         if (transactions[transactionId].destination == 0)
60             throw;
61         _;
62     }
63 
64     modifier confirmed(uint transactionId, address owner) {
65         if (!confirmations[transactionId][owner])
66             throw;
67         _;
68     }
69 
70     modifier notConfirmed(uint transactionId, address owner) {
71         if (confirmations[transactionId][owner])
72             throw;
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         if (transactions[transactionId].executed)
78             throw;
79         _;
80     }
81 
82     modifier notNull(address _address) {
83         if (_address == 0)
84             throw;
85         _;
86     }
87 
88     modifier validRequirement(uint ownerCount, uint _required) {
89         if (   ownerCount > MAX_OWNER_COUNT
90             || _required > ownerCount
91             || _required == 0
92             || ownerCount == 0)
93             throw;
94         _;
95     }
96 
97     /// @dev Fallback function allows to deposit ether.
98     function()
99         payable
100     {
101         if (msg.value > 0)
102             Deposit(msg.sender, msg.value);
103     }
104 
105     /*
106      * Public functions
107      */
108     /// @dev Contract constructor sets initial owners and required number of confirmations.
109     /// @param _owners List of initial owners.
110     /// @param _required Number of required confirmations.
111     function MultiSigWallet(address[] _owners, uint _required)
112         public
113         validRequirement(_owners.length, _required)
114     {
115         for (uint i=0; i<_owners.length; i++) {
116             if (isOwner[_owners[i]] || _owners[i] == 0)
117                 throw;
118             isOwner[_owners[i]] = true;
119         }
120         owners = _owners;
121         required = _required;
122     }
123 
124     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
125     /// @param owner Address of new owner.
126     function addOwner(address owner)
127         public
128         onlyWallet
129         ownerDoesNotExist(owner)
130         notNull(owner)
131         validRequirement(owners.length + 1, required)
132     {
133         isOwner[owner] = true;
134         owners.push(owner);
135         OwnerAddition(owner);
136     }
137 
138     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
139     /// @param owner Address of owner.
140     function removeOwner(address owner)
141         public
142         onlyWallet
143         ownerExists(owner)
144     {
145         isOwner[owner] = false;
146         for (uint i=0; i<owners.length - 1; i++)
147             if (owners[i] == owner) {
148                 owners[i] = owners[owners.length - 1];
149                 break;
150             }
151         owners.length -= 1;
152         if (required > owners.length)
153             changeRequirement(owners.length);
154         OwnerRemoval(owner);
155     }
156 
157     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
158     /// @param owner Address of owner to be replaced.
159     /// @param owner Address of new owner.
160     function replaceOwner(address owner, address newOwner)
161         public
162         onlyWallet
163         ownerExists(owner)
164         ownerDoesNotExist(newOwner)
165     {
166         for (uint i=0; i<owners.length; i++)
167             if (owners[i] == owner) {
168                 owners[i] = newOwner;
169                 break;
170             }
171         isOwner[owner] = false;
172         isOwner[newOwner] = true;
173         OwnerRemoval(owner);
174         OwnerAddition(newOwner);
175     }
176 
177     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
178     /// @param _required Number of required confirmations.
179     function changeRequirement(uint _required)
180         public
181         onlyWallet
182         validRequirement(owners.length, _required)
183     {
184         required = _required;
185         RequirementChange(_required);
186     }
187 
188     /// @dev Allows an owner to submit and confirm a transaction.
189     /// @param destination Transaction target address.
190     /// @param value Transaction ether value.
191     /// @param data Transaction data payload.
192     /// @return Returns transaction ID.
193     function submitTransaction(address destination, uint value, bytes data)
194         public
195         returns (uint transactionId)
196     {
197         transactionId = addTransaction(destination, value, data);
198         confirmTransaction(transactionId);
199     }
200 
201     /// @dev Allows an owner to confirm a transaction.
202     /// @param transactionId Transaction ID.
203     function confirmTransaction(uint transactionId)
204         public
205         ownerExists(msg.sender)
206         transactionExists(transactionId)
207         notConfirmed(transactionId, msg.sender)
208     {
209         confirmations[transactionId][msg.sender] = true;
210         Confirmation(msg.sender, transactionId);
211         executeTransaction(transactionId);
212     }
213 
214     /// @dev Allows an owner to revoke a confirmation for a transaction.
215     /// @param transactionId Transaction ID.
216     function revokeConfirmation(uint transactionId)
217         public
218         ownerExists(msg.sender)
219         confirmed(transactionId, msg.sender)
220         notExecuted(transactionId)
221     {
222         confirmations[transactionId][msg.sender] = false;
223         Revocation(msg.sender, transactionId);
224     }
225 
226     /// @dev Allows anyone to execute a confirmed transaction.
227     /// @param transactionId Transaction ID.
228     function executeTransaction(uint transactionId)
229         public
230         notExecuted(transactionId)
231     {
232         if (isConfirmed(transactionId)) {
233             Transaction tx = transactions[transactionId];
234             tx.executed = true;
235             if (tx.destination.call.value(tx.value)(tx.data))
236                 Execution(transactionId);
237             else {
238                 ExecutionFailure(transactionId);
239                 tx.executed = false;
240             }
241         }
242     }
243 
244     /// @dev Returns the confirmation status of a transaction.
245     /// @param transactionId Transaction ID.
246     /// @return Confirmation status.
247     function isConfirmed(uint transactionId)
248         public
249         constant
250         returns (bool)
251     {
252         uint count = 0;
253         for (uint i=0; i<owners.length; i++) {
254             if (confirmations[transactionId][owners[i]])
255                 count += 1;
256             if (count == required)
257                 return true;
258         }
259     }
260 
261     /*
262      * Internal functions
263      */
264     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
265     /// @param destination Transaction target address.
266     /// @param value Transaction ether value.
267     /// @param data Transaction data payload.
268     /// @return Returns transaction ID.
269     function addTransaction(address destination, uint value, bytes data)
270         internal
271         notNull(destination)
272         returns (uint transactionId)
273     {
274         transactionId = transactionCount;
275         transactions[transactionId] = Transaction({
276             destination: destination,
277             value: value,
278             data: data,
279             executed: false
280         });
281         transactionCount += 1;
282         Submission(transactionId);
283     }
284 
285     /*
286      * Web3 call functions
287      */
288     /// @dev Returns number of confirmations of a transaction.
289     /// @param transactionId Transaction ID.
290     /// @return Number of confirmations.
291     function getConfirmationCount(uint transactionId)
292         public
293         constant
294         returns (uint count)
295     {
296         for (uint i=0; i<owners.length; i++)
297             if (confirmations[transactionId][owners[i]])
298                 count += 1;
299     }
300 
301     /// @dev Returns total number of transactions after filers are applied.
302     /// @param pending Include pending transactions.
303     /// @param executed Include executed transactions.
304     /// @return Total number of transactions after filters are applied.
305     function getTransactionCount(bool pending, bool executed)
306         public
307         constant
308         returns (uint count)
309     {
310         for (uint i=0; i<transactionCount; i++)
311             if (   pending && !transactions[i].executed
312                 || executed && transactions[i].executed)
313                 count += 1;
314     }
315 
316     /// @dev Returns list of owners.
317     /// @return List of owner addresses.
318     function getOwners()
319         public
320         constant
321         returns (address[])
322     {
323         return owners;
324     }
325 
326     /// @dev Returns array with owner addresses, which confirmed transaction.
327     /// @param transactionId Transaction ID.
328     /// @return Returns array of owner addresses.
329     function getConfirmations(uint transactionId)
330         public
331         constant
332         returns (address[] _confirmations)
333     {
334         address[] memory confirmationsTemp = new address[](owners.length);
335         uint count = 0;
336         uint i;
337         for (i=0; i<owners.length; i++)
338             if (confirmations[transactionId][owners[i]]) {
339                 confirmationsTemp[count] = owners[i];
340                 count += 1;
341             }
342         _confirmations = new address[](count);
343         for (i=0; i<count; i++)
344             _confirmations[i] = confirmationsTemp[i];
345     }
346 
347     /// @dev Returns list of transaction IDs in defined range.
348     /// @param from Index start position of transaction array.
349     /// @param to Index end position of transaction array.
350     /// @param pending Include pending transactions.
351     /// @param executed Include executed transactions.
352     /// @return Returns array of transaction IDs.
353     function getTransactionIds(uint from, uint to, bool pending, bool executed)
354         public
355         constant
356         returns (uint[] _transactionIds)
357     {
358         uint[] memory transactionIdsTemp = new uint[](transactionCount);
359         uint count = 0;
360         uint i;
361         for (i=0; i<transactionCount; i++)
362             if (   pending && !transactions[i].executed
363                 || executed && transactions[i].executed)
364             {
365                 transactionIdsTemp[count] = i;
366                 count += 1;
367             }
368         _transactionIds = new uint[](to - from);
369         for (i=from; i<to; i++)
370             _transactionIds[i - from] = transactionIdsTemp[i];
371     }
372 }
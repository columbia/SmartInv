1 pragma solidity 0.4.15;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 /// Wallet of: ZK Labs GmbH
7 contract MultiSigWallet {
8 
9     /*
10      *  Events
11      */
12     event Confirmation(address indexed sender, uint indexed transactionId);
13     event Revocation(address indexed sender, uint indexed transactionId);
14     event Submission(uint indexed transactionId);
15     event Execution(uint indexed transactionId);
16     event ExecutionFailure(uint indexed transactionId);
17     event Deposit(address indexed sender, uint value);
18     event OwnerAddition(address indexed owner);
19     event OwnerRemoval(address indexed owner);
20     event RequirementChange(uint required);
21 
22     /*
23      *  Constants
24      */
25     uint constant public MAX_OWNER_COUNT = 50;
26 
27     /*
28      *  Storage
29      */
30     mapping (uint => Transaction) public transactions;
31     mapping (uint => mapping (address => bool)) public confirmations;
32     mapping (address => bool) public isOwner;
33     address[] public owners;
34     uint public required;
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
48         require(msg.sender == address(this));
49         _;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         require(!isOwner[owner]);
54         _;
55     }
56 
57     modifier ownerExists(address owner) {
58         require(isOwner[owner]);
59         _;
60     }
61 
62     modifier transactionExists(uint transactionId) {
63         require(transactions[transactionId].destination != 0);
64         _;
65     }
66 
67     modifier confirmed(uint transactionId, address owner) {
68         require(confirmations[transactionId][owner]);
69         _;
70     }
71 
72     modifier notConfirmed(uint transactionId, address owner) {
73         require(!confirmations[transactionId][owner]);
74         _;
75     }
76 
77     modifier notExecuted(uint transactionId) {
78         require(!transactions[transactionId].executed);
79         _;
80     }
81 
82     modifier notNull(address _address) {
83         require(_address != 0);
84         _;
85     }
86 
87     modifier validRequirement(uint ownerCount, uint _required) {
88         require(ownerCount <= MAX_OWNER_COUNT
89             && _required <= ownerCount
90             && _required != 0
91             && ownerCount != 0);
92         _;
93     }
94 
95     /// @dev Fallback function allows to deposit ether.
96     function()
97         payable
98     {
99         if (msg.value > 0)
100             Deposit(msg.sender, msg.value);
101     }
102 
103     /*
104      * Public functions
105      */
106     /// @dev Contract constructor sets initial owners and required number of confirmations.
107     /// @param _owners List of initial owners.
108     /// @param _required Number of required confirmations.
109     function MultiSigWallet(address[] _owners, uint _required)
110         public
111         validRequirement(_owners.length, _required)
112     {
113         for (uint i=0; i<_owners.length; i++) {
114             require(!isOwner[_owners[i]] && _owners[i] != 0);
115             isOwner[_owners[i]] = true;
116         }
117         owners = _owners;
118         required = _required;
119     }
120 
121     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
122     /// @param owner Address of new owner.
123     function addOwner(address owner)
124         public
125         onlyWallet
126         ownerDoesNotExist(owner)
127         notNull(owner)
128         validRequirement(owners.length + 1, required)
129     {
130         isOwner[owner] = true;
131         owners.push(owner);
132         OwnerAddition(owner);
133     }
134 
135     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
136     /// @param owner Address of owner.
137     function removeOwner(address owner)
138         public
139         onlyWallet
140         ownerExists(owner)
141     {
142         isOwner[owner] = false;
143         for (uint i=0; i<owners.length - 1; i++)
144             if (owners[i] == owner) {
145                 owners[i] = owners[owners.length - 1];
146                 break;
147             }
148         owners.length -= 1;
149         if (required > owners.length)
150             changeRequirement(owners.length);
151         OwnerRemoval(owner);
152     }
153 
154     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
155     /// @param owner Address of owner to be replaced.
156     /// @param newOwner Address of new owner.
157     function replaceOwner(address owner, address newOwner)
158         public
159         onlyWallet
160         ownerExists(owner)
161         ownerDoesNotExist(newOwner)
162     {
163         for (uint i=0; i<owners.length; i++)
164             if (owners[i] == owner) {
165                 owners[i] = newOwner;
166                 break;
167             }
168         isOwner[owner] = false;
169         isOwner[newOwner] = true;
170         OwnerRemoval(owner);
171         OwnerAddition(newOwner);
172     }
173 
174     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
175     /// @param _required Number of required confirmations.
176     function changeRequirement(uint _required)
177         public
178         onlyWallet
179         validRequirement(owners.length, _required)
180     {
181         required = _required;
182         RequirementChange(_required);
183     }
184 
185     /// @dev Allows an owner to submit and confirm a transaction.
186     /// @param destination Transaction target address.
187     /// @param value Transaction ether value.
188     /// @param data Transaction data payload.
189     /// @return Returns transaction ID.
190     function submitTransaction(address destination, uint value, bytes data)
191         public
192         returns (uint transactionId)
193     {
194         transactionId = addTransaction(destination, value, data);
195         confirmTransaction(transactionId);
196     }
197 
198     /// @dev Allows an owner to confirm a transaction.
199     /// @param transactionId Transaction ID.
200     function confirmTransaction(uint transactionId)
201         public
202         ownerExists(msg.sender)
203         transactionExists(transactionId)
204         notConfirmed(transactionId, msg.sender)
205     {
206         confirmations[transactionId][msg.sender] = true;
207         Confirmation(msg.sender, transactionId);
208         executeTransaction(transactionId);
209     }
210 
211     /// @dev Allows an owner to revoke a confirmation for a transaction.
212     /// @param transactionId Transaction ID.
213     function revokeConfirmation(uint transactionId)
214         public
215         ownerExists(msg.sender)
216         confirmed(transactionId, msg.sender)
217         notExecuted(transactionId)
218     {
219         confirmations[transactionId][msg.sender] = false;
220         Revocation(msg.sender, transactionId);
221     }
222 
223     /// @dev Allows anyone to execute a confirmed transaction.
224     /// @param transactionId Transaction ID.
225     function executeTransaction(uint transactionId)
226         public
227         ownerExists(msg.sender)
228         confirmed(transactionId, msg.sender)
229         notExecuted(transactionId)
230     {
231         if (isConfirmed(transactionId)) {
232             Transaction storage txn = transactions[transactionId];
233             txn.executed = true;
234             if (txn.destination.call.value(txn.value)(txn.data))
235                 Execution(transactionId);
236             else {
237                 ExecutionFailure(transactionId);
238                 txn.executed = false;
239             }
240         }
241     }
242 
243     /// @dev Returns the confirmation status of a transaction.
244     /// @param transactionId Transaction ID.
245     /// @return Confirmation status.
246     function isConfirmed(uint transactionId)
247         public
248         constant
249         returns (bool)
250     {
251         uint count = 0;
252         for (uint i=0; i<owners.length; i++) {
253             if (confirmations[transactionId][owners[i]])
254                 count += 1;
255             if (count == required)
256                 return true;
257         }
258     }
259 
260     /*
261      * Internal functions
262      */
263     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
264     /// @param destination Transaction target address.
265     /// @param value Transaction ether value.
266     /// @param data Transaction data payload.
267     /// @return Returns transaction ID.
268     function addTransaction(address destination, uint value, bytes data)
269         internal
270         notNull(destination)
271         returns (uint transactionId)
272     {
273         transactionId = transactionCount;
274         transactions[transactionId] = Transaction({
275             destination: destination,
276             value: value,
277             data: data,
278             executed: false
279         });
280         transactionCount += 1;
281         Submission(transactionId);
282     }
283 
284     /*
285      * Web3 call functions
286      */
287     /// @dev Returns number of confirmations of a transaction.
288     /// @param transactionId Transaction ID.
289     /// @return Number of confirmations.
290     function getConfirmationCount(uint transactionId)
291         public
292         constant
293         returns (uint count)
294     {
295         for (uint i=0; i<owners.length; i++)
296             if (confirmations[transactionId][owners[i]])
297                 count += 1;
298     }
299 
300     /// @dev Returns total number of transactions after filers are applied.
301     /// @param pending Include pending transactions.
302     /// @param executed Include executed transactions.
303     /// @return Total number of transactions after filters are applied.
304     function getTransactionCount(bool pending, bool executed)
305         public
306         constant
307         returns (uint count)
308     {
309         for (uint i=0; i<transactionCount; i++)
310             if (   pending && !transactions[i].executed
311                 || executed && transactions[i].executed)
312                 count += 1;
313     }
314 
315     /// @dev Returns list of owners.
316     /// @return List of owner addresses.
317     function getOwners()
318         public
319         constant
320         returns (address[])
321     {
322         return owners;
323     }
324 
325     /// @dev Returns array with owner addresses, which confirmed transaction.
326     /// @param transactionId Transaction ID.
327     /// @return Returns array of owner addresses.
328     function getConfirmations(uint transactionId)
329         public
330         constant
331         returns (address[] _confirmations)
332     {
333         address[] memory confirmationsTemp = new address[](owners.length);
334         uint count = 0;
335         uint i;
336         for (i=0; i<owners.length; i++)
337             if (confirmations[transactionId][owners[i]]) {
338                 confirmationsTemp[count] = owners[i];
339                 count += 1;
340             }
341         _confirmations = new address[](count);
342         for (i=0; i<count; i++)
343             _confirmations[i] = confirmationsTemp[i];
344     }
345 
346     /// @dev Returns list of transaction IDs in defined range.
347     /// @param from Index start position of transaction array.
348     /// @param to Index end position of transaction array.
349     /// @param pending Include pending transactions.
350     /// @param executed Include executed transactions.
351     /// @return Returns array of transaction IDs.
352     function getTransactionIds(uint from, uint to, bool pending, bool executed)
353         public
354         constant
355         returns (uint[] _transactionIds)
356     {
357         uint[] memory transactionIdsTemp = new uint[](transactionCount);
358         uint count = 0;
359         uint i;
360         for (i=0; i<transactionCount; i++)
361             if (   pending && !transactions[i].executed
362                 || executed && transactions[i].executed)
363             {
364                 transactionIdsTemp[count] = i;
365                 count += 1;
366             }
367         _transactionIds = new uint[](to - from);
368         for (i=from; i<to; i++)
369             _transactionIds[i - from] = transactionIdsTemp[i];
370     }
371 }
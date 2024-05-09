1 pragma solidity ^0.5.0;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /*
9      *  Events
10      */
11     event Confirmation(address indexed sender, uint indexed transactionId);
12     event Revocation(address indexed sender, uint indexed transactionId);
13     event Submission(uint indexed transactionId);
14     event Execution(uint indexed transactionId);
15     event ExecutionFailure(uint indexed transactionId);
16     event Deposit(address indexed sender, uint value);
17     event OwnerAddition(address indexed owner);
18     event OwnerRemoval(address indexed owner);
19     event RequirementChange(uint required);
20 
21     /*
22      *  Constants
23      */
24     uint constant public MAX_OWNER_COUNT = 50;
25 
26     /*
27      *  Storage
28      */
29     mapping (uint => Transaction) public transactions;
30     mapping (uint => mapping (address => bool)) public confirmations;
31     mapping (address => bool) public isOwner;
32     address[] public owners;
33     uint public required;
34     uint public transactionCount;
35 
36     struct Transaction {
37         address destination;
38         uint value;
39         bytes data;
40         bool executed;
41     }
42 
43     /*
44      *  Modifiers
45      */
46     modifier onlyWallet() {
47         require(msg.sender == address(this));
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         require(!isOwner[owner]);
53         _;
54     }
55 
56     modifier ownerExists(address owner) {
57         require(isOwner[owner]);
58         _;
59     }
60 
61     modifier transactionExists(uint transactionId) {
62         require(transactions[transactionId].destination != address(0));
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         require(confirmations[transactionId][owner]);
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         require(!confirmations[transactionId][owner]);
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         require(!transactions[transactionId].executed);
78         _;
79     }
80 
81     modifier notNull(address _address) {
82         require(_address != address(0));
83         _;
84     }
85 
86     modifier validRequirement(uint ownerCount, uint _required) {
87         require(ownerCount <= MAX_OWNER_COUNT
88             && _required <= ownerCount
89             && _required != 0
90             && ownerCount != 0);
91         _;
92     }
93 
94     /// @dev Fallback function allows to deposit ether.
95     function()
96         external
97         payable
98     {
99         if (msg.value > 0)
100             emit Deposit(msg.sender, msg.value);
101     }
102 
103     /*
104      * Public functions
105      */
106     /// @dev Contract constructor sets initial owners and required number of confirmations.
107     /// @param _owners List of initial owners.
108     /// @param _required Number of required confirmations.
109     constructor (address[] memory _owners, uint _required)
110       public
111       validRequirement(_owners.length, _required)
112     {
113         for (uint i = 0; i < _owners.length; i++) {
114             require(!isOwner[_owners[i]] && _owners[i] != address(0));
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
132         emit OwnerAddition(owner);
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
143         for (uint i = 0; i < owners.length - 1; i++)
144             if (owners[i] == owner) {
145                 owners[i] = owners[owners.length - 1];
146                 break;
147             }
148         owners.length -= 1;
149         if (required > owners.length)
150             changeRequirement(owners.length);
151         emit OwnerRemoval(owner);
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
163         for (uint i = 0; i < owners.length; i++)
164             if (owners[i] == owner) {
165                 owners[i] = newOwner;
166                 break;
167             }
168         isOwner[owner] = false;
169         isOwner[newOwner] = true;
170         emit OwnerRemoval(owner);
171         emit OwnerAddition(newOwner);
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
182         emit RequirementChange(_required);
183     }
184 
185     /// @dev Allows an owner to submit and confirm a transaction.
186     /// @param destination Transaction target address.
187     /// @param value Transaction ether value.
188     /// @param data Transaction data payload.
189     /// @return Returns transaction ID.
190     function submitTransaction(address destination, uint value, bytes memory data)
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
207         emit Confirmation(msg.sender, transactionId);
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
220         emit Revocation(msg.sender, transactionId);
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
234             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
235                 emit Execution(transactionId);
236             else {
237                 emit ExecutionFailure(transactionId);
238                 txn.executed = false;
239             }
240         }
241     }
242 
243     // call has been separated into its own function in order to take advantage
244     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
245     function external_call(address destination, uint value, uint dataLength, bytes memory data) internal returns (bool) {
246         bool result;
247         assembly {
248             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
249             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
250             result := call(
251                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
252                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
253                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
254                 destination,
255                 value,
256                 d,
257                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
258                 x,
259                 0                  // Output is ignored, therefore the output size is zero
260             )
261         }
262         return result;
263     }
264 
265     /// @dev Returns the confirmation status of a transaction.
266     /// @param transactionId Transaction ID.
267     /// @return Confirmation status.
268     function isConfirmed(uint transactionId)
269         public
270         view
271         returns (bool)
272     {
273         uint count = 0;
274         for (uint i = 0; i < owners.length; i++) {
275             if (confirmations[transactionId][owners[i]])
276                 count += 1;
277             if (count == required)
278                 return true;
279         }
280     }
281 
282     /*
283      * Internal functions
284      */
285     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
286     /// @param destination Transaction target address.
287     /// @param value Transaction ether value.
288     /// @param data Transaction data payload.
289     /// @return Returns transaction ID.
290     function addTransaction(address destination, uint value, bytes memory data)
291         internal
292         notNull(destination)
293         returns (uint transactionId)
294     {
295         transactionId = transactionCount;
296         transactions[transactionId] = Transaction({
297             destination: destination,
298             value: value,
299             data: data,
300             executed: false
301         });
302         transactionCount += 1;
303         emit Submission(transactionId);
304     }
305 
306     /*
307      * Web3 call functions
308      */
309     /// @dev Returns number of confirmations of a transaction.
310     /// @param transactionId Transaction ID.
311     /// @return Number of confirmations.
312     function getConfirmationCount(uint transactionId)
313         public
314         view
315         returns (uint count)
316     {
317         for (uint i = 0; i < owners.length; i++)
318             if (confirmations[transactionId][owners[i]])
319                 count += 1;
320     }
321 
322     /// @dev Returns total number of transactions after filers are applied.
323     /// @param pending Include pending transactions.
324     /// @param executed Include executed transactions.
325     /// @return Total number of transactions after filters are applied.
326     function getTransactionCount(bool pending, bool executed)
327         public
328         view
329         returns (uint count)
330     {
331         for (uint i = 0; i < transactionCount; i++)
332             if (   pending && !transactions[i].executed
333                 || executed && transactions[i].executed)
334                 count += 1;
335     }
336 
337     /// @dev Returns list of owners.
338     /// @return List of owner addresses.
339     function getOwners()
340         public
341         view
342         returns (address[] memory)
343     {
344         return owners;
345     }
346 
347     /// @dev Returns array with owner addresses, which confirmed transaction.
348     /// @param transactionId Transaction ID.
349     /// @return Returns array of owner addresses.
350     function getConfirmations(uint transactionId)
351         public
352         view
353         returns (address[] memory _confirmations)
354     {
355         address[] memory confirmationsTemp = new address[](owners.length);
356         uint count = 0;
357         uint i;
358         for (i = 0; i < owners.length; i++)
359             if (confirmations[transactionId][owners[i]]) {
360                 confirmationsTemp[count] = owners[i];
361                 count += 1;
362             }
363         _confirmations = new address[](count);
364         for (i = 0; i < count; i++)
365             _confirmations[i] = confirmationsTemp[i];
366     }
367 
368     /// @dev Returns list of transaction IDs in defined range.
369     /// @param from Index start position of transaction array.
370     /// @param to Index end position of transaction array.
371     /// @param pending Include pending transactions.
372     /// @param executed Include executed transactions.
373     /// @return Returns array of transaction IDs.
374     function getTransactionIds(uint from, uint to, bool pending, bool executed)
375         public
376         view
377         returns (uint[] memory _transactionIds)
378     {
379         uint[] memory transactionIdsTemp = new uint[](transactionCount);
380         uint count = 0;
381         uint i;
382         for (i = 0; i < transactionCount; i++)
383             if (   pending && !transactions[i].executed
384                 || executed && transactions[i].executed)
385             {
386                 transactionIdsTemp[count] = i;
387                 count += 1;
388             }
389         _transactionIds = new uint[](to - from);
390         for (i = from; i < to; i++)
391             _transactionIds[i - from] = transactionIdsTemp[i];
392     }
393 }
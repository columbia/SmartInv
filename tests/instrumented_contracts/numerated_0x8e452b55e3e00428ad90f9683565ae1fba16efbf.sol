1 pragma solidity ^0.4.15;
2 
3 contract MultiSigWallet {
4 
5     /*
6      *  Events
7      */
8     event Confirmation(address indexed sender, uint indexed transactionId);
9     event Revocation(address indexed sender, uint indexed transactionId);
10     event Submission(uint indexed transactionId);
11     event Execution(uint indexed transactionId);
12     event ExecutionFailure(uint indexed transactionId);
13     event Deposit(address indexed sender, uint value);
14     event OwnerAddition(address indexed owner);
15     event OwnerRemoval(address indexed owner);
16     event RequirementChange(uint required);
17 
18     /*
19      *  Constants
20      */
21     uint constant public MAX_OWNER_COUNT = 50;
22 
23     /*
24      *  Storage
25      */
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
40     /*
41      *  Modifiers
42      */
43     modifier onlyWallet() {
44         require(msg.sender == address(this));
45         _;
46     }
47 
48     modifier ownerDoesNotExist(address owner) {
49         require(!isOwner[owner]);
50         _;
51     }
52 
53     modifier ownerExists(address owner) {
54         require(isOwner[owner]);
55         _;
56     }
57 
58     modifier transactionExists(uint transactionId) {
59         require(transactions[transactionId].destination != 0);
60         _;
61     }
62 
63     modifier confirmed(uint transactionId, address owner) {
64         require(confirmations[transactionId][owner]);
65         _;
66     }
67 
68     modifier notConfirmed(uint transactionId, address owner) {
69         require(!confirmations[transactionId][owner]);
70         _;
71     }
72 
73     modifier notExecuted(uint transactionId) {
74         require(!transactions[transactionId].executed);
75         _;
76     }
77 
78     modifier notNull(address _address) {
79         require(_address != 0);
80         _;
81     }
82 
83     modifier validRequirement(uint ownerCount, uint _required) {
84         require(ownerCount <= MAX_OWNER_COUNT
85             && _required <= ownerCount
86             && _required != 0
87             && ownerCount != 0);
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
110             require(!isOwner[_owners[i]] && _owners[i] != 0);
111             isOwner[_owners[i]] = true;
112         }
113         owners = _owners;
114         required = _required;
115     }
116 
117     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
118     /// @param owner Address of new owner.
119     function addOwner(address owner)
120         public
121         onlyWallet
122         ownerDoesNotExist(owner)
123         notNull(owner)
124         validRequirement(owners.length + 1, required)
125     {
126         isOwner[owner] = true;
127         owners.push(owner);
128         OwnerAddition(owner);
129     }
130 
131     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
132     /// @param owner Address of owner.
133     function removeOwner(address owner)
134         public
135         onlyWallet
136         ownerExists(owner)
137     {
138         isOwner[owner] = false;
139         for (uint i=0; i<owners.length - 1; i++)
140             if (owners[i] == owner) {
141                 owners[i] = owners[owners.length - 1];
142                 break;
143             }
144         owners.length -= 1;
145         if (required > owners.length)
146             changeRequirement(owners.length);
147         OwnerRemoval(owner);
148     }
149 
150     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
151     /// @param owner Address of owner to be replaced.
152     /// @param newOwner Address of new owner.
153     function replaceOwner(address owner, address newOwner)
154         public
155         onlyWallet
156         ownerExists(owner)
157         ownerDoesNotExist(newOwner)
158     {
159         for (uint i=0; i<owners.length; i++)
160             if (owners[i] == owner) {
161                 owners[i] = newOwner;
162                 break;
163             }
164         isOwner[owner] = false;
165         isOwner[newOwner] = true;
166         OwnerRemoval(owner);
167         OwnerAddition(newOwner);
168     }
169 
170     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
171     /// @param _required Number of required confirmations.
172     function changeRequirement(uint _required)
173         public
174         onlyWallet
175         validRequirement(owners.length, _required)
176     {
177         required = _required;
178         RequirementChange(_required);
179     }
180 
181     /// @dev Allows an owner to submit and confirm a transaction.
182     /// @param destination Transaction target address.
183     /// @param value Transaction ether value.
184     /// @param data Transaction data payload.
185     /// @return Returns transaction ID.
186     function submitTransaction(address destination, uint value, bytes data)
187         public
188         returns (uint transactionId)
189     {
190         transactionId = addTransaction(destination, value, data);
191         confirmTransaction(transactionId);
192     }
193 
194     /// @dev Allows an owner to confirm a transaction.
195     /// @param transactionId Transaction ID.
196     function confirmTransaction(uint transactionId)
197         public
198         ownerExists(msg.sender)
199         transactionExists(transactionId)
200         notConfirmed(transactionId, msg.sender)
201     {
202         confirmations[transactionId][msg.sender] = true;
203         Confirmation(msg.sender, transactionId);
204         executeTransaction(transactionId);
205     }
206 
207     /// @dev Allows an owner to revoke a confirmation for a transaction.
208     /// @param transactionId Transaction ID.
209     function revokeConfirmation(uint transactionId)
210         public
211         ownerExists(msg.sender)
212         confirmed(transactionId, msg.sender)
213         notExecuted(transactionId)
214     {
215         confirmations[transactionId][msg.sender] = false;
216         Revocation(msg.sender, transactionId);
217     }
218 
219     /// @dev Allows anyone to execute a confirmed transaction.
220     /// @param transactionId Transaction ID.
221     function executeTransaction(uint transactionId)
222         public
223         ownerExists(msg.sender)
224         confirmed(transactionId, msg.sender)
225         notExecuted(transactionId)
226     {
227         if (isConfirmed(transactionId)) {
228             Transaction storage txn = transactions[transactionId];
229             txn.executed = true;
230             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
231                 Execution(transactionId);
232             else {
233                 ExecutionFailure(transactionId);
234                 txn.executed = false;
235             }
236         }
237     }
238 
239     // call has been separated into its own function in order to take advantage
240     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
241     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
242         bool result;
243         assembly {
244             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
245             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
246             result := call(
247                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
248                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
249                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
250                 destination,
251                 value,
252                 d,
253                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
254                 x,
255                 0                  // Output is ignored, therefore the output size is zero
256             )
257         }
258         return result;
259     }
260 
261     /// @dev Returns the confirmation status of a transaction.
262     /// @param transactionId Transaction ID.
263     /// @return Confirmation status.
264     function isConfirmed(uint transactionId)
265         public
266         constant
267         returns (bool)
268     {
269         uint count = 0;
270         for (uint i=0; i<owners.length; i++) {
271             if (confirmations[transactionId][owners[i]])
272                 count += 1;
273             if (count == required)
274                 return true;
275         }
276     }
277 
278     /*
279      * Internal functions
280      */
281     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
282     /// @param destination Transaction target address.
283     /// @param value Transaction ether value.
284     /// @param data Transaction data payload.
285     /// @return Returns transaction ID.
286     function addTransaction(address destination, uint value, bytes data)
287         internal
288         notNull(destination)
289         returns (uint transactionId)
290     {
291         transactionId = transactionCount;
292         transactions[transactionId] = Transaction({
293             destination: destination,
294             value: value,
295             data: data,
296             executed: false
297         });
298         transactionCount += 1;
299         Submission(transactionId);
300     }
301 
302     /*
303      * Web3 call functions
304      */
305     /// @dev Returns number of confirmations of a transaction.
306     /// @param transactionId Transaction ID.
307     /// @return Number of confirmations.
308     function getConfirmationCount(uint transactionId)
309         public
310         constant
311         returns (uint count)
312     {
313         for (uint i=0; i<owners.length; i++)
314             if (confirmations[transactionId][owners[i]])
315                 count += 1;
316     }
317 
318     /// @dev Returns total number of transactions after filers are applied.
319     /// @param pending Include pending transactions.
320     /// @param executed Include executed transactions.
321     /// @return Total number of transactions after filters are applied.
322     function getTransactionCount(bool pending, bool executed)
323         public
324         constant
325         returns (uint count)
326     {
327         for (uint i=0; i<transactionCount; i++)
328             if (   pending && !transactions[i].executed
329                 || executed && transactions[i].executed)
330                 count += 1;
331     }
332 
333     /// @dev Returns list of owners.
334     /// @return List of owner addresses.
335     function getOwners()
336         public
337         constant
338         returns (address[])
339     {
340         return owners;
341     }
342 
343     /// @dev Returns array with owner addresses, which confirmed transaction.
344     /// @param transactionId Transaction ID.
345     /// @return Returns array of owner addresses.
346     function getConfirmations(uint transactionId)
347         public
348         constant
349         returns (address[] _confirmations)
350     {
351         address[] memory confirmationsTemp = new address[](owners.length);
352         uint count = 0;
353         uint i;
354         for (i=0; i<owners.length; i++)
355             if (confirmations[transactionId][owners[i]]) {
356                 confirmationsTemp[count] = owners[i];
357                 count += 1;
358             }
359         _confirmations = new address[](count);
360         for (i=0; i<count; i++)
361             _confirmations[i] = confirmationsTemp[i];
362     }
363 
364     /// @dev Returns list of transaction IDs in defined range.
365     /// @param from Index start position of transaction array.
366     /// @param to Index end position of transaction array.
367     /// @param pending Include pending transactions.
368     /// @param executed Include executed transactions.
369     /// @return Returns array of transaction IDs.
370     function getTransactionIds(uint from, uint to, bool pending, bool executed)
371         public
372         constant
373         returns (uint[] _transactionIds)
374     {
375         uint[] memory transactionIdsTemp = new uint[](transactionCount);
376         uint count = 0;
377         uint i;
378         for (i=0; i<transactionCount; i++)
379             if (   pending && !transactions[i].executed
380                 || executed && transactions[i].executed)
381             {
382                 transactionIdsTemp[count] = i;
383                 count += 1;
384             }
385         _transactionIds = new uint[](to - from);
386         for (i=from; i<to; i++)
387             _transactionIds[i - from] = transactionIdsTemp[i];
388     }
389 }
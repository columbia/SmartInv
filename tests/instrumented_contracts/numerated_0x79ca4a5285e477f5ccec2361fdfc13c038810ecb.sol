1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
7 /// @author Stefan George - <stefan.george@consensys.net>
8 /// https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
9 contract MultiSigWallet {
10 
11     /*
12      *  Events
13      */
14     event Confirmation(address indexed sender, uint indexed transactionId);
15     event Revocation(address indexed sender, uint indexed transactionId);
16     event Submission(uint indexed transactionId);
17     event Execution(uint indexed transactionId);
18     event ExecutionFailure(uint indexed transactionId);
19     event Deposit(address indexed sender, uint value);
20     event OwnerAddition(address indexed owner);
21     event OwnerRemoval(address indexed owner);
22     event RequirementChange(uint required);
23 
24     /*
25      *  Constants
26      */
27     uint constant public MAX_OWNER_COUNT = 50;
28 
29     /*
30      *  Storage
31      */
32     mapping (uint => Transaction) public transactions;
33     mapping (uint => mapping (address => bool)) public confirmations;
34     mapping (address => bool) public isOwner;
35     address[] public owners;
36     uint public required;
37     uint public transactionCount;
38 
39     struct Transaction {
40         address destination;
41         uint value;
42         bytes data;
43         bool executed;
44     }
45 
46     /*
47      *  Modifiers
48      */
49     modifier onlyWallet() {
50         require(msg.sender == address(this));
51         _;
52     }
53 
54     modifier ownerDoesNotExist(address owner) {
55         require(!isOwner[owner]);
56         _;
57     }
58 
59     modifier ownerExists(address owner) {
60         require(isOwner[owner]);
61         _;
62     }
63 
64     modifier transactionExists(uint transactionId) {
65         require(transactions[transactionId].destination != 0);
66         _;
67     }
68 
69     modifier confirmed(uint transactionId, address owner) {
70         require(confirmations[transactionId][owner]);
71         _;
72     }
73 
74     modifier notConfirmed(uint transactionId, address owner) {
75         require(!confirmations[transactionId][owner]);
76         _;
77     }
78 
79     modifier notExecuted(uint transactionId) {
80         require(!transactions[transactionId].executed);
81         _;
82     }
83 
84     modifier notNull(address _address) {
85         require(_address != 0);
86         _;
87     }
88 
89     modifier validRequirement(uint ownerCount, uint _required) {
90         require(ownerCount <= MAX_OWNER_COUNT
91             && _required <= ownerCount
92             && _required != 0
93             && ownerCount != 0);
94         _;
95     }
96 
97     /// @dev Fallback function allows to deposit ether.
98     function() public payable {
99         if (msg.value > 0) {
100             emit Deposit(msg.sender, msg.value);
101         }
102     }
103 
104     /*
105      * Public functions
106      */
107     /// @dev Contract constructor sets initial owners and required number of confirmations.
108     /// @param _owners List of initial owners.
109     /// @param _required Number of required confirmations.
110     constructor(address[] _owners, uint _required)
111         public
112         validRequirement(_owners.length, _required)
113     {
114         for (uint i=0; i<_owners.length; i++) {
115             require(!isOwner[_owners[i]] && _owners[i] != 0);
116             isOwner[_owners[i]] = true;
117         }
118         owners = _owners;
119         required = _required;
120     }
121 
122     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
123     /// @param owner Address of new owner.
124     function addOwner(address owner)
125         public
126         onlyWallet
127         ownerDoesNotExist(owner)
128         notNull(owner)
129         validRequirement(owners.length + 1, required)
130     {
131         isOwner[owner] = true;
132         owners.push(owner);
133         emit OwnerAddition(owner);
134     }
135 
136     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
137     /// @param owner Address of owner.
138     function removeOwner(address owner)
139         public
140         onlyWallet
141         ownerExists(owner)
142     {
143         isOwner[owner] = false;
144         for (uint i=0; i<owners.length - 1; i++)
145             if (owners[i] == owner) {
146                 owners[i] = owners[owners.length - 1];
147                 break;
148             }
149         owners.length -= 1;
150         if (required > owners.length)
151             changeRequirement(owners.length);
152         emit OwnerRemoval(owner);
153     }
154 
155     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
156     /// @param owner Address of owner to be replaced.
157     /// @param newOwner Address of new owner.
158     function replaceOwner(address owner, address newOwner)
159         public
160         onlyWallet
161         ownerExists(owner)
162         ownerDoesNotExist(newOwner)
163     {
164         for (uint i=0; i<owners.length; i++)
165             if (owners[i] == owner) {
166                 owners[i] = newOwner;
167                 break;
168             }
169         isOwner[owner] = false;
170         isOwner[newOwner] = true;
171         emit OwnerRemoval(owner);
172         emit OwnerAddition(newOwner);
173     }
174 
175     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
176     /// @param _required Number of required confirmations.
177     function changeRequirement(uint _required)
178         public
179         onlyWallet
180         validRequirement(owners.length, _required)
181     {
182         required = _required;
183         emit RequirementChange(_required);
184     }
185 
186     /// @dev Allows an owner to submit and confirm a transaction.
187     /// @param destination Transaction target address.
188     /// @param value Transaction ether value.
189     /// @param data Transaction data payload.
190     /// @return Returns transaction ID.
191     function submitTransaction(address destination, uint value, bytes data)
192         public
193         returns (uint transactionId)
194     {
195         transactionId = addTransaction(destination, value, data);
196         confirmTransaction(transactionId);
197     }
198 
199     /// @dev Allows an owner to confirm a transaction.
200     /// @param transactionId Transaction ID.
201     function confirmTransaction(uint transactionId)
202         public
203         ownerExists(msg.sender)
204         transactionExists(transactionId)
205         notConfirmed(transactionId, msg.sender)
206     {
207         confirmations[transactionId][msg.sender] = true;
208         emit Confirmation(msg.sender, transactionId);
209         executeTransaction(transactionId);
210     }
211 
212     /// @dev Allows an owner to revoke a confirmation for a transaction.
213     /// @param transactionId Transaction ID.
214     function revokeConfirmation(uint transactionId)
215         public
216         ownerExists(msg.sender)
217         confirmed(transactionId, msg.sender)
218         notExecuted(transactionId)
219     {
220         confirmations[transactionId][msg.sender] = false;
221         emit Revocation(msg.sender, transactionId);
222     }
223 
224     /// @dev Allows anyone to execute a confirmed transaction.
225     /// @param transactionId Transaction ID.
226     function executeTransaction(uint transactionId)
227         public
228         ownerExists(msg.sender)
229         confirmed(transactionId, msg.sender)
230         notExecuted(transactionId)
231     {
232         if (isConfirmed(transactionId)) {
233             Transaction storage txn = transactions[transactionId];
234             txn.executed = true;
235             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
236                 emit Execution(transactionId);
237             else {
238                 emit ExecutionFailure(transactionId);
239                 txn.executed = false;
240             }
241         }
242     }
243 
244     // call has been separated into its own function in order to take advantage
245     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
246     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
247         bool result;
248         assembly {
249             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
250             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
251             result := call(
252                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
253                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
254                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
255                 destination,
256                 value,
257                 d,
258                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
259                 x,
260                 0                  // Output is ignored, therefore the output size is zero
261             )
262         }
263         return result;
264     }
265 
266     /// @dev Returns the confirmation status of a transaction.
267     /// @param transactionId Transaction ID.
268     /// @return Confirmation status.
269     function isConfirmed(uint transactionId)
270         public
271         constant
272         returns (bool)
273     {
274         uint count = 0;
275         for (uint i=0; i<owners.length; i++) {
276             if (confirmations[transactionId][owners[i]])
277                 count += 1;
278             if (count == required)
279                 return true;
280         }
281     }
282 
283     /*
284      * Internal functions
285      */
286     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
287     /// @param destination Transaction target address.
288     /// @param value Transaction ether value.
289     /// @param data Transaction data payload.
290     /// @return Returns transaction ID.
291     function addTransaction(address destination, uint value, bytes data)
292         internal
293         notNull(destination)
294         returns (uint transactionId)
295     {
296         transactionId = transactionCount;
297         transactions[transactionId] = Transaction({
298             destination: destination,
299             value: value,
300             data: data,
301             executed: false
302         });
303         transactionCount += 1;
304         emit Submission(transactionId);
305     }
306 
307     /*
308      * Web3 call functions
309      */
310     /// @dev Returns number of confirmations of a transaction.
311     /// @param transactionId Transaction ID.
312     /// @return Number of confirmations.
313     function getConfirmationCount(uint transactionId)
314         public
315         constant
316         returns (uint count)
317     {
318         for (uint i=0; i<owners.length; i++)
319             if (confirmations[transactionId][owners[i]])
320                 count += 1;
321     }
322 
323     /// @dev Returns total number of transactions after filers are applied.
324     /// @param pending Include pending transactions.
325     /// @param executed Include executed transactions.
326     /// @return Total number of transactions after filters are applied.
327     function getTransactionCount(bool pending, bool executed)
328         public
329         constant
330         returns (uint count)
331     {
332         for (uint i=0; i<transactionCount; i++)
333             if (   pending && !transactions[i].executed
334                 || executed && transactions[i].executed)
335                 count += 1;
336     }
337 
338     /// @dev Returns list of owners.
339     /// @return List of owner addresses.
340     function getOwners()
341         public
342         constant
343         returns (address[])
344     {
345         return owners;
346     }
347 
348     /// @dev Returns array with owner addresses, which confirmed transaction.
349     /// @param transactionId Transaction ID.
350     /// @return Returns array of owner addresses.
351     function getConfirmations(uint transactionId)
352         public
353         constant
354         returns (address[] _confirmations)
355     {
356         address[] memory confirmationsTemp = new address[](owners.length);
357         uint count = 0;
358         uint i;
359         for (i=0; i<owners.length; i++)
360             if (confirmations[transactionId][owners[i]]) {
361                 confirmationsTemp[count] = owners[i];
362                 count += 1;
363             }
364         _confirmations = new address[](count);
365         for (i=0; i<count; i++)
366             _confirmations[i] = confirmationsTemp[i];
367     }
368 
369     /// @dev Returns list of transaction IDs in defined range.
370     /// @param from Index start position of transaction array.
371     /// @param to Index end position of transaction array.
372     /// @param pending Include pending transactions.
373     /// @param executed Include executed transactions.
374     /// @return Returns array of transaction IDs.
375     function getTransactionIds(uint from, uint to, bool pending, bool executed)
376         public
377         constant
378         returns (uint[] _transactionIds)
379     {
380         uint[] memory transactionIdsTemp = new uint[](transactionCount);
381         uint count = 0;
382         uint i;
383         for (i=0; i<transactionCount; i++)
384             if (   pending && !transactions[i].executed
385                 || executed && transactions[i].executed)
386             {
387                 transactionIdsTemp[count] = i;
388                 count += 1;
389             }
390         _transactionIds = new uint[](to - from);
391         for (i=from; i<to; i++)
392             _transactionIds[i - from] = transactionIdsTemp[i];
393     }
394 }
395 
396 
397 contract VidyTeamWallet is MultiSigWallet {
398   constructor(address[] _owners, uint _required) MultiSigWallet(_owners, _required) public {
399     // nothing else needed
400   }
401 }
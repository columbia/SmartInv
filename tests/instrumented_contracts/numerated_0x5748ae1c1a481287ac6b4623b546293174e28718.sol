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
47         require(msg.sender == address(this), "onlyWallet");
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         require(!isOwner[owner], "ownerDoesNotExist");
53         _;
54     }
55 
56     modifier ownerExists(address owner) {
57         require(isOwner[owner], "ownerExists");
58         _;
59     }
60 
61     modifier transactionExists(uint transactionId) {
62         require(transactions[transactionId].destination != address(0), "transactionExists");
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         require(confirmations[transactionId][owner], "confirmed");
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         require(!confirmations[transactionId][owner], "notConfirmed");
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         require(!transactions[transactionId].executed, "notExecuted");
78         _;
79     }
80 
81     modifier notNull(address _address) {
82         require(_address != address(0), "notNull");
83         _;
84     }
85 
86     modifier validRequirement(uint _ownerCount, uint _required) {
87         require(_ownerCount <= MAX_OWNER_COUNT, "validRequirement: _ownerCount <= MAX_OWNER_COUNT");
88         require(_required != 0, "validRequirement: _required != 0");
89         require(_ownerCount != 0, "validRequirement: ownerCount != 0");
90         require(_required <= _ownerCount, "validRequirement: _required <= _ownerCount");
91         _;
92     }
93 
94     /// @dev Fallback function allows to deposit ether.
95     function() payable external
96     {
97         if (msg.value > 0)
98             emit Deposit(msg.sender, msg.value);
99     }
100 
101     /*
102      * Public functions
103      */
104     /// @dev Contract constructor sets initial owners and required number of confirmations.
105     /// @param _owners List of initial owners.
106     /// @param _required Number of required confirmations.
107     constructor(address[] memory _owners, uint _required)
108         public
109         validRequirement(_owners.length, _required)
110     {
111         for (uint i=0; i<_owners.length; i++) {
112             require(!isOwner[_owners[i]] && _owners[i] != address(0));
113             isOwner[_owners[i]] = true;
114         }
115         owners = _owners;
116         required = _required;
117     }
118 
119     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
120     /// @param owner Address of new owner.
121     function addOwner(address owner)
122         public
123         onlyWallet
124         ownerDoesNotExist(owner)
125         notNull(owner)
126         validRequirement(owners.length + 1, required)
127     {
128         isOwner[owner] = true;
129         owners.push(owner);
130         emit OwnerAddition(owner);
131     }
132 
133     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
134     /// @param owner Address of owner.
135     function removeOwner(address owner)
136         public
137         onlyWallet
138         ownerExists(owner)
139     {
140         isOwner[owner] = false;
141         for (uint i=0; i<owners.length - 1; i++)
142             if (owners[i] == owner) {
143                 owners[i] = owners[owners.length - 1];
144                 break;
145             }
146         owners.length -= 1;
147         if (required > owners.length)
148             changeRequirement(owners.length);
149         emit OwnerRemoval(owner);
150     }
151 
152     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
153     /// @param owner Address of owner to be replaced.
154     /// @param newOwner Address of new owner.
155     function replaceOwner(address owner, address newOwner)
156         public
157         onlyWallet
158         ownerExists(owner)
159         ownerDoesNotExist(newOwner)
160     {
161         for (uint i=0; i<owners.length; i++)
162             if (owners[i] == owner) {
163                 owners[i] = newOwner;
164                 break;
165             }
166         isOwner[owner] = false;
167         isOwner[newOwner] = true;
168         emit OwnerRemoval(owner);
169         emit OwnerAddition(newOwner);
170     }
171 
172     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
173     /// @param _required Number of required confirmations.
174     function changeRequirement(uint _required)
175         public
176         onlyWallet
177         validRequirement(owners.length, _required)
178     {
179         required = _required;
180         emit RequirementChange(_required);
181     }
182 
183     /// @dev Allows an owner to submit and confirm a transaction.
184     /// @param destination Transaction target address.
185     /// @param value Transaction ether value.
186     /// @param data Transaction data payload.
187     /// @return Returns transaction ID.
188     function submitTransaction(address destination, uint value, bytes memory data)
189         public
190         returns (uint transactionId)
191     {
192         transactionId = addTransaction(destination, value, data);
193         confirmTransaction(transactionId);
194     }
195 
196     /// @dev Allows an owner to confirm a transaction.
197     /// @param transactionId Transaction ID.
198     function confirmTransaction(uint transactionId)
199         public
200         ownerExists(msg.sender)
201         transactionExists(transactionId)
202         notConfirmed(transactionId, msg.sender)
203     {
204         confirmations[transactionId][msg.sender] = true;
205         emit Confirmation(msg.sender, transactionId);
206         executeTransaction(transactionId);
207     }
208 
209     /// @dev Allows an owner to revoke a confirmation for a transaction.
210     /// @param transactionId Transaction ID.
211     function revokeConfirmation(uint transactionId)
212         public
213         ownerExists(msg.sender)
214         confirmed(transactionId, msg.sender)
215         notExecuted(transactionId)
216     {
217         confirmations[transactionId][msg.sender] = false;
218         emit Revocation(msg.sender, transactionId);
219     }
220 
221     /// @dev Allows anyone to execute a confirmed transaction.
222     /// @param transactionId Transaction ID.
223     function executeTransaction(uint transactionId)
224         public
225         ownerExists(msg.sender)
226         confirmed(transactionId, msg.sender)
227         notExecuted(transactionId)
228     {
229         if (isConfirmed(transactionId)) {
230             Transaction storage txn = transactions[transactionId];
231             txn.executed = true;
232             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
233                 emit Execution(transactionId);
234             else {
235                 emit ExecutionFailure(transactionId);
236                 txn.executed = false;
237             }
238         }
239     }
240 
241     // call has been separated into its own function in order to take advantage
242     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
243     function external_call(address destination, uint value, uint dataLength, bytes memory data) private returns (bool) {
244         bool result;
245         assembly {
246             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
247             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
248             result := call(
249                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
250                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
251                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
252                 destination,
253                 value,
254                 d,
255                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
256                 x,
257                 0                  // Output is ignored, therefore the output size is zero
258             )
259         }
260         return result;
261     }
262 
263     /// @dev Returns the confirmation status of a transaction.
264     /// @param transactionId Transaction ID.
265     /// @return Confirmation status.
266     function isConfirmed(uint transactionId)
267         public
268         view
269         returns (bool)
270     {
271         uint count = 0;
272         for (uint i=0; i<owners.length; i++) {
273             if (confirmations[transactionId][owners[i]])
274                 count += 1;
275             if (count == required)
276                 return true;
277         }
278     }
279 
280     /*
281      * Internal functions
282      */
283     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
284     /// @param destination Transaction target address.
285     /// @param value Transaction ether value.
286     /// @param data Transaction data payload.
287     /// @return Returns transaction ID.
288     function addTransaction(address destination, uint value, bytes memory data)
289         internal
290         notNull(destination)
291         returns (uint transactionId)
292     {
293         transactionId = transactionCount;
294         transactions[transactionId] = Transaction({
295             destination: destination,
296             value: value,
297             data: data,
298             executed: false
299         });
300         transactionCount += 1;
301         emit Submission(transactionId);
302     }
303 
304     /*
305      * Web3 call functions
306      */
307     /// @dev Returns number of confirmations of a transaction.
308     /// @param transactionId Transaction ID.
309     /// @return Number of confirmations.
310     function getConfirmationCount(uint transactionId)
311         public
312         view
313         returns (uint count)
314     {
315         for (uint i=0; i<owners.length; i++)
316             if (confirmations[transactionId][owners[i]])
317                 count += 1;
318     }
319 
320     /// @dev Returns total number of transactions after filers are applied.
321     /// @param pending Include pending transactions.
322     /// @param executed Include executed transactions.
323     /// @return Total number of transactions after filters are applied.
324     function getTransactionCount(bool pending, bool executed)
325         public
326         view
327         returns (uint count)
328     {
329         for (uint i=0; i<transactionCount; i++)
330             if (   pending && !transactions[i].executed
331                 || executed && transactions[i].executed)
332                 count += 1;
333     }
334 
335     /// @dev Returns list of owners.
336     /// @return List of owner addresses.
337     function getOwners()
338         public
339         view
340         returns (address[] memory)
341     {
342         return owners;
343     }
344 
345     /// @dev Returns array with owner addresses, which confirmed transaction.
346     /// @param transactionId Transaction ID.
347     /// @return Returns array of owner addresses.
348     function getConfirmations(uint transactionId)
349         public
350         view
351         returns (address[] memory _confirmations)
352     {
353         address[] memory confirmationsTemp = new address[](owners.length);
354         uint count = 0;
355         uint i;
356         for (i=0; i<owners.length; i++)
357             if (confirmations[transactionId][owners[i]]) {
358                 confirmationsTemp[count] = owners[i];
359                 count += 1;
360             }
361         _confirmations = new address[](count);
362         for (i=0; i<count; i++)
363             _confirmations[i] = confirmationsTemp[i];
364     }
365 
366     /// @dev Returns list of transaction IDs in defined range.
367     /// @param from Index start position of transaction array.
368     /// @param to Index end position of transaction array.
369     /// @param pending Include pending transactions.
370     /// @param executed Include executed transactions.
371     /// @return Returns array of transaction IDs.
372     function getTransactionIds(uint from, uint to, bool pending, bool executed)
373         public
374         view
375         returns (uint[] memory _transactionIds)
376     {
377         uint[] memory transactionIdsTemp = new uint[](transactionCount);
378         uint count = 0;
379         uint i;
380         for (i=0; i<transactionCount; i++)
381             if (   pending && !transactions[i].executed
382                 || executed && transactions[i].executed)
383             {
384                 transactionIdsTemp[count] = i;
385                 count += 1;
386             }
387         _transactionIds = new uint[](to - from);
388         for (i=from; i<to; i++)
389             _transactionIds[i - from] = transactionIdsTemp[i];
390     }
391 }
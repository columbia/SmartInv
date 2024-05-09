1 // File: contracts/lib/MultiSigWallet.sol
2 
3 pragma solidity 0.5.17;
4 
5 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
6 /// @author Stefan George - <stefan.george@consensys.net>
7 /// Modified for Harmony by gupadhyaya 2020
8 contract MultiSigWallet {
9     /*
10      *  Events
11      */
12     event Confirmation(address indexed sender, uint256 indexed transactionId);
13     event Revocation(address indexed sender, uint256 indexed transactionId);
14     event Submission(uint256 indexed transactionId);
15     event Execution(uint256 indexed transactionId);
16     event ExecutionFailure(uint256 indexed transactionId);
17     event Deposit(address indexed sender, uint256 value);
18     event OwnerAddition(address indexed owner);
19     event OwnerRemoval(address indexed owner);
20     event RequirementChange(uint256 required);
21 
22     /*
23      *  Constants
24      */
25     uint256 public constant MAX_OWNER_COUNT = 50;
26 
27     /*
28      *  Storage
29      */
30     mapping(uint256 => Transaction) public transactions;
31     mapping(uint256 => mapping(address => bool)) public confirmations;
32     mapping(address => bool) public isOwner;
33     address[] public owners;
34     uint256 public required;
35     uint256 public transactionCount;
36 
37     struct Transaction {
38         address destination;
39         uint256 value;
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
62     modifier transactionExists(uint256 transactionId) {
63         require(transactions[transactionId].destination != address(0));
64         _;
65     }
66 
67     modifier confirmed(uint256 transactionId, address owner) {
68         require(confirmations[transactionId][owner]);
69         _;
70     }
71 
72     modifier notConfirmed(uint256 transactionId, address owner) {
73         require(!confirmations[transactionId][owner]);
74         _;
75     }
76 
77     modifier notExecuted(uint256 transactionId) {
78         require(!transactions[transactionId].executed);
79         _;
80     }
81 
82     modifier notNull(address _address) {
83         require(_address != address(0));
84         _;
85     }
86 
87     modifier validRequirement(uint256 ownerCount, uint256 _required) {
88         require(
89             ownerCount <= MAX_OWNER_COUNT &&
90                 _required <= ownerCount &&
91                 _required != 0 &&
92                 ownerCount != 0
93         );
94         _;
95     }
96 
97     /// @dev Fallback function allows to deposit ether.
98     function() external payable {
99         if (msg.value > 0) emit Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     constructor(address[] memory _owners, uint256 _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint256 i = 0; i < _owners.length; i++) {
113             require(!isOwner[_owners[i]] && _owners[i] != address(0));
114             isOwner[_owners[i]] = true;
115         }
116         owners = _owners;
117         required = _required;
118     }
119 
120     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121     /// @param owner Address of new owner.
122     function addOwner(address owner)
123         public
124         onlyWallet
125         ownerDoesNotExist(owner)
126         notNull(owner)
127         validRequirement(owners.length + 1, required)
128     {
129         isOwner[owner] = true;
130         owners.push(owner);
131         emit OwnerAddition(owner);
132     }
133 
134     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
135     /// @param owner Address of owner.
136     function removeOwner(address owner) public onlyWallet ownerExists(owner) {
137         isOwner[owner] = false;
138         for (uint256 i = 0; i < owners.length - 1; i++)
139             if (owners[i] == owner) {
140                 owners[i] = owners[owners.length - 1];
141                 break;
142             }
143         owners.length -= 1;
144         if (required > owners.length) changeRequirement(owners.length);
145         emit OwnerRemoval(owner);
146     }
147 
148     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
149     /// @param owner Address of owner to be replaced.
150     /// @param newOwner Address of new owner.
151     function replaceOwner(address owner, address newOwner)
152         public
153         onlyWallet
154         ownerExists(owner)
155         ownerDoesNotExist(newOwner)
156     {
157         for (uint256 i = 0; i < owners.length; i++)
158             if (owners[i] == owner) {
159                 owners[i] = newOwner;
160                 break;
161             }
162         isOwner[owner] = false;
163         isOwner[newOwner] = true;
164         emit OwnerRemoval(owner);
165         emit OwnerAddition(newOwner);
166     }
167 
168     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
169     /// @param _required Number of required confirmations.
170     function changeRequirement(uint256 _required)
171         public
172         onlyWallet
173         validRequirement(owners.length, _required)
174     {
175         required = _required;
176         emit RequirementChange(_required);
177     }
178 
179     /// @dev Allows an owner to submit and confirm a transaction.
180     /// @param destination Transaction target address.
181     /// @param value Transaction ether value.
182     /// @param data Transaction data payload.
183     /// @return Returns transaction ID.
184     function submitTransaction(
185         address destination,
186         uint256 value,
187         bytes memory data
188     ) public returns (uint256 transactionId) {
189         transactionId = addTransaction(destination, value, data);
190         confirmTransaction(transactionId);
191     }
192 
193     /// @dev Allows an owner to confirm a transaction.
194     /// @param transactionId Transaction ID.
195     function confirmTransaction(uint256 transactionId)
196         public
197         ownerExists(msg.sender)
198         transactionExists(transactionId)
199         notConfirmed(transactionId, msg.sender)
200     {
201         confirmations[transactionId][msg.sender] = true;
202         emit Confirmation(msg.sender, transactionId);
203         executeTransaction(transactionId);
204     }
205 
206     /// @dev Allows an owner to revoke a confirmation for a transaction.
207     /// @param transactionId Transaction ID.
208     function revokeConfirmation(uint256 transactionId)
209         public
210         ownerExists(msg.sender)
211         confirmed(transactionId, msg.sender)
212         notExecuted(transactionId)
213     {
214         confirmations[transactionId][msg.sender] = false;
215         emit Revocation(msg.sender, transactionId);
216     }
217 
218     /// @dev Allows anyone to execute a confirmed transaction.
219     /// @param transactionId Transaction ID.
220     function executeTransaction(uint256 transactionId)
221         public
222         ownerExists(msg.sender)
223         confirmed(transactionId, msg.sender)
224         notExecuted(transactionId)
225     {
226         if (isConfirmed(transactionId)) {
227             Transaction storage txn = transactions[transactionId];
228             txn.executed = true;
229             if (
230                 external_call(
231                     txn.destination,
232                     txn.value,
233                     txn.data.length,
234                     txn.data
235                 )
236             ) emit Execution(transactionId);
237             else {
238                 emit ExecutionFailure(transactionId);
239                 txn.executed = false;
240             }
241         }
242     }
243 
244     // call has been separated into its own function in order to take advantage
245     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
246     function external_call(
247         address destination,
248         uint256 value,
249         uint256 dataLength,
250         bytes memory data
251     ) internal returns (bool) {
252         bool result;
253         assembly {
254             let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
255             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
256             result := call(
257                 sub(gas, 34710), // 34710 is the value that solidity is currently emitting
258                 // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
259                 // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
260                 destination,
261                 value,
262                 d,
263                 dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
264                 x,
265                 0 // Output is ignored, therefore the output size is zero
266             )
267         }
268         return result;
269     }
270 
271     /// @dev Returns the confirmation status of a transaction.
272     /// @param transactionId Transaction ID.
273     /// @return Confirmation status.
274     function isConfirmed(uint256 transactionId) public view returns (bool) {
275         uint256 count = 0;
276         for (uint256 i = 0; i < owners.length; i++) {
277             if (confirmations[transactionId][owners[i]]) count += 1;
278             if (count == required) return true;
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
290     function addTransaction(
291         address destination,
292         uint256 value,
293         bytes memory data
294     ) internal notNull(destination) returns (uint256 transactionId) {
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
312     function getConfirmationCount(uint256 transactionId)
313         public
314         view
315         returns (uint256 count)
316     {
317         for (uint256 i = 0; i < owners.length; i++)
318             if (confirmations[transactionId][owners[i]]) count += 1;
319     }
320 
321     /// @dev Returns total number of transactions after filers are applied.
322     /// @param pending Include pending transactions.
323     /// @param executed Include executed transactions.
324     /// @return Total number of transactions after filters are applied.
325     function getTransactionCount(bool pending, bool executed)
326         public
327         view
328         returns (uint256 count)
329     {
330         for (uint256 i = 0; i < transactionCount; i++)
331             if (
332                 (pending && !transactions[i].executed) ||
333                 (executed && transactions[i].executed)
334             ) count += 1;
335     }
336 
337     /// @dev Returns list of owners.
338     /// @return List of owner addresses.
339     function getOwners() public view returns (address[] memory) {
340         return owners;
341     }
342 
343     /// @dev Returns array with owner addresses, which confirmed transaction.
344     /// @param transactionId Transaction ID.
345     /// @return Returns array of owner addresses.
346     function getConfirmations(uint256 transactionId)
347         public
348         view
349         returns (address[] memory _confirmations)
350     {
351         address[] memory confirmationsTemp = new address[](owners.length);
352         uint256 count = 0;
353         uint256 i;
354         for (i = 0; i < owners.length; i++)
355             if (confirmations[transactionId][owners[i]]) {
356                 confirmationsTemp[count] = owners[i];
357                 count += 1;
358             }
359         _confirmations = new address[](count);
360         for (i = 0; i < count; i++) _confirmations[i] = confirmationsTemp[i];
361     }
362 
363     /// @dev Returns list of transaction IDs in defined range.
364     /// @param from Index start position of transaction array.
365     /// @param to Index end position of transaction array.
366     /// @param pending Include pending transactions.
367     /// @param executed Include executed transactions.
368     /// @return Returns array of transaction IDs.
369     function getTransactionIds(
370         uint256 from,
371         uint256 to,
372         bool pending,
373         bool executed
374     ) public view returns (uint256[] memory _transactionIds) {
375         uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
376         uint256 count = 0;
377         uint256 i;
378         for (i = 0; i < transactionCount; i++)
379             if (
380                 (pending && !transactions[i].executed) ||
381                 (executed && transactions[i].executed)
382             ) {
383                 transactionIdsTemp[count] = i;
384                 count += 1;
385             }
386         _transactionIds = new uint256[](to - from);
387         for (i = from; i < to; i++)
388             _transactionIds[i - from] = transactionIdsTemp[i];
389     }
390 }
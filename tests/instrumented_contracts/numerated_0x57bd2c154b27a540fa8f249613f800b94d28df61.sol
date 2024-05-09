1 pragma solidity 0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
68 /// @author Stefan George - <stefan.george@consensys.net>
69 contract MultiSigWallet {
70     using SafeMath for uint256;
71 
72     /*
73      *  Events
74      */
75     event Confirmation(address indexed sender, uint indexed transactionId);
76     event Revocation(address indexed sender, uint indexed transactionId);
77     event Submission(uint indexed transactionId);
78     event Execution(uint indexed transactionId);
79     event ExecutionFailure(uint indexed transactionId);
80     event Deposit(address indexed sender, uint value);
81     event OwnerAddition(address indexed owner);
82     event OwnerRemoval(address indexed owner);
83     event RequirementChange(uint required);
84 
85     /*
86      *  Constants
87      */
88     uint constant public MAX_OWNER_COUNT = 50;
89 
90     /*
91      *  Storage
92      */
93     mapping (uint => Transaction) public transactions;
94     mapping (uint => mapping (address => bool)) public confirmations;
95     mapping (address => bool) public isOwner;
96     address[] public owners;
97     uint public required;
98     uint public transactionCount;
99 
100     struct Transaction {
101         address destination;
102         uint value;
103         bytes data;
104         bool executed;
105     }
106 
107     /*
108      *  Modifiers
109      */
110     modifier onlyWallet() {
111         require(msg.sender == address(this));
112         _;
113     }
114 
115     modifier ownerDoesNotExist(address owner) {
116         require(!isOwner[owner]);
117         _;
118     }
119 
120     modifier ownerExists(address owner) {
121         require(isOwner[owner]);
122         _;
123     }
124 
125     modifier transactionExists(uint transactionId) {
126         require(transactions[transactionId].destination != address(0));
127         _;
128     }
129 
130     modifier confirmed(uint transactionId, address owner) {
131         require(confirmations[transactionId][owner]);
132         _;
133     }
134 
135     modifier notConfirmed(uint transactionId, address owner) {
136         require(!confirmations[transactionId][owner]);
137         _;
138     }
139 
140     modifier notExecuted(uint transactionId) {
141         require(!transactions[transactionId].executed);
142         _;
143     }
144 
145     modifier notNull(address _address) {
146         require(_address != address(0));
147         _;
148     }
149 
150     modifier validRequirement(uint ownerCount, uint _required) {
151         require(ownerCount <= MAX_OWNER_COUNT
152             && _required <= ownerCount
153             && _required != 0
154             && ownerCount != 0);
155         _;
156     }
157 
158     /*
159      * Public functions
160      */
161     /// @dev Contract constructor sets initial owners and required number of confirmations.
162     /// @param _owners List of initial owners.
163     /// @param _required Number of required confirmations.
164     constructor (address[] memory _owners, uint _required)
165         public
166         validRequirement(_owners.length, _required)
167     {
168         for (uint i=0; i<_owners.length; i++) {
169             require(_owners[i] != address(0));
170             isOwner[_owners[i]] = true;
171         }
172         owners = _owners;
173         required = _required;
174     }
175     
176         /// @dev Fallback function allows to deposit ether.
177     function()
178         external
179         payable
180     {
181         if (msg.value > 0)
182             emit Deposit(msg.sender, msg.value);
183     }
184 
185     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
186     /// @param owner Address of new owner.
187     function addOwner(address owner)
188         external
189         onlyWallet
190         ownerDoesNotExist(owner)
191         notNull(owner)
192         validRequirement(owners.length.add(1), required)
193     {
194         isOwner[owner] = true;
195         owners.push(owner);
196         emit OwnerAddition(owner);
197     }
198 
199     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
200     /// @param owner Address of owner.
201     function removeOwner(address owner)
202         external
203         onlyWallet
204         ownerExists(owner)
205     {
206         isOwner[owner] = false;
207         for (uint i=0; i<owners.length.sub(1); i++)
208             if (owners[i] == owner) {
209                 owners[i] = owners[owners.length.sub(1)];
210                 break;
211             }
212         owners.length = owners.length.sub(1);
213         if (required > owners.length)
214             changeRequirement(owners.length);
215         emit OwnerRemoval(owner);
216     }
217 
218     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
219     /// @param owner Address of owner to be replaced.
220     /// @param newOwner Address of new owner.
221     function replaceOwner(address owner, address newOwner)
222         external
223         onlyWallet
224         ownerExists(owner)
225         notNull(owner)
226         ownerDoesNotExist(newOwner)
227     {
228         for (uint i=0; i<owners.length; i++)
229             if (owners[i] == owner) {
230                 owners[i] = newOwner;
231                 break;
232             }
233         isOwner[owner] = false;
234         isOwner[newOwner] = true;
235         emit OwnerRemoval(owner);
236         emit OwnerAddition(newOwner);
237     }
238 
239     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
240     /// @param _required Number of required confirmations.
241     function changeRequirement(uint _required)
242         public
243         onlyWallet
244         validRequirement(owners.length, _required)
245     {
246         required = _required;
247         emit RequirementChange(_required);
248     }
249 
250     /// @dev Allows an owner to submit and confirm a transaction.
251     /// @param destination Transaction target address.
252     /// @param value Transaction ether value.
253     /// @param data Transaction data payload.
254     /// @return Returns transaction ID.
255     function submitTransaction(address destination, uint value, bytes calldata data)
256         external
257         returns (uint transactionId)
258     {
259         transactionId = addTransaction(destination, value, data);
260         emit Submission(transactionId);
261         confirmTransaction(transactionId);
262     }
263 
264     /// @dev Allows an owner to confirm a transaction.
265     /// @param transactionId Transaction ID.
266     function confirmTransaction(uint transactionId)
267         public
268         ownerExists(msg.sender)
269         transactionExists(transactionId)
270         notConfirmed(transactionId, msg.sender)
271     {
272         confirmations[transactionId][msg.sender] = true;
273         emit Confirmation(msg.sender, transactionId);
274         executeTransaction(transactionId);
275     }
276 
277     /// @dev Allows an owner to revoke a confirmation for a transaction.
278     /// @param transactionId Transaction ID.
279     function revokeConfirmation(uint transactionId)
280         external
281         ownerExists(msg.sender)
282         confirmed(transactionId, msg.sender)
283         notExecuted(transactionId)
284     {
285         confirmations[transactionId][msg.sender] = false;
286         emit Revocation(msg.sender, transactionId);
287     }
288 
289     /// @dev Allows anyone to execute a confirmed transaction.
290     /// @param transactionId Transaction ID.
291     function executeTransaction(uint transactionId)
292         public
293         ownerExists(msg.sender)
294         confirmed(transactionId, msg.sender)
295         notExecuted(transactionId)
296     {
297         if (isConfirmed(transactionId)) {
298             Transaction storage txn = transactions[transactionId];
299             txn.executed = true;
300             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
301                 emit Execution(transactionId);
302             else {
303                 emit ExecutionFailure(transactionId);
304                 txn.executed = false;
305             }
306         }
307     }
308 
309     // call has been separated into its own function in order to take advantage
310     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
311     function external_call(address destination, uint value, uint dataLength, bytes memory data) private returns (bool) {
312         bool result;
313         assembly {
314             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
315             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
316             result := call(
317                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
318                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
319                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
320                 destination,
321                 value,
322                 d,
323                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
324                 x,
325                 0                  // Output is ignored, therefore the output size is zero
326             )
327         }
328         return result;
329     }
330 
331     /// @dev Returns the confirmation status of a transaction.
332     /// @param transactionId Transaction ID.
333     /// @return Confirmation status.
334     function isConfirmed(uint transactionId)
335         public
336         view
337         returns (bool)
338     {
339         uint count = 0;
340         for (uint i=0; i<owners.length; i++) {
341             if (confirmations[transactionId][owners[i]])
342                 count += 1;
343             if (count == required)
344                 return true;
345         }
346     }
347 
348     /*
349      * Internal functions
350      */
351     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
352     /// @param destination Transaction target address.
353     /// @param value Transaction ether value.
354     /// @param data Transaction data payload.
355     /// @return Returns transaction ID.
356     function addTransaction(address destination, uint value, bytes memory data)
357         internal
358         notNull(destination)
359         returns (uint transactionId)
360     {
361         transactionId = transactionCount;
362         transactions[transactionId] = Transaction({
363             destination: destination,
364             value: value,
365             data: data,
366             executed: false
367         });
368         transactionCount = transactionCount.add(1);
369     }
370 
371     /*
372      * Web3 call functions
373      */
374     /// @dev Returns number of confirmations of a transaction.
375     /// @param transactionId Transaction ID.
376     /// @return Number of confirmations.
377     function getConfirmationCount(uint transactionId)
378         external
379         view
380         returns (uint count)
381     {
382         for (uint i=0; i<owners.length; i++)
383             if (confirmations[transactionId][owners[i]])
384                 count += 1;
385     }
386 
387     /// @dev Returns total number of transactions after filers are applied.
388     /// @param pending Include pending transactions.
389     /// @param executed Include executed transactions.
390     /// @return Total number of transactions after filters are applied.
391     function getTransactionCount(bool pending, bool executed)
392         external
393         view
394         returns (uint count)
395     {
396         for (uint i=0; i<transactionCount; i++)
397             if (   pending && !transactions[i].executed
398                 || executed && transactions[i].executed)
399                 count += 1;
400     }
401 
402     /// @dev Returns list of owners.
403     /// @return List of owner addresses.
404     function getOwners()
405         external
406         view
407         returns (address[] memory)
408     {
409         return owners;
410     }
411 
412     /// @dev Returns array with owner addresses, which confirmed transaction.
413     /// @param transactionId Transaction ID.
414     /// @return Returns array of owner addresses.
415     function getConfirmations(uint transactionId)
416         external
417         view
418         returns (address[] memory _confirmations)
419     {
420         address[] memory confirmationsTemp = new address[](owners.length);
421         uint count = 0;
422         uint i;
423         for(i=0; i<owners.length; i++) {
424             if(confirmations[transactionId][owners[i]]) {
425                 confirmationsTemp[count] = owners[i];
426                 count = count.add(1);
427             }
428         }
429 
430         _confirmations = new address[](count);
431         for(i=0; i<count; i++) {
432             _confirmations[i] = confirmationsTemp[i];
433         }
434     }
435 
436     /// @dev Returns list of transaction IDs in defined range.
437     /// @param from Index start position of transaction array.
438     /// @param to Index end position of transaction array.
439     /// @param pending Include pending transactions.
440     /// @param executed Include executed transactions.
441     /// @return Returns array of transaction IDs.
442     function getTransactionIds(uint from, uint to, bool pending, bool executed)
443         external
444         view
445         returns (uint[] memory _transactionIds)
446     {
447         uint[] memory transactionIdsTemp = new uint[](transactionCount);
448         uint count = 0;
449         uint i;
450         for (i=0; i<transactionCount; i++)
451             if (   pending && !transactions[i].executed
452                 || executed && transactions[i].executed)
453             {
454                 transactionIdsTemp[count] = i;
455                 count = count.add(1);
456             }
457         _transactionIds = new uint[](to.sub(from));
458         for (i=from; i<to; i++)
459             _transactionIds[i.sub(from)] = transactionIdsTemp[i];
460     }
461 }
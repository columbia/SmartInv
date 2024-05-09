1 pragma solidity ^0.5.17;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /*
9      *  Events
10      */
11     event Confirmation(address indexed sender, uint256 indexed transactionId);
12     event Revocation(address indexed sender, uint256 indexed transactionId);
13     event Submission(uint256 indexed transactionId);
14     event Execution(uint256 indexed transactionId);
15     event ExecutionFailure(uint256 indexed transactionId);
16     event Deposit(address indexed sender, uint256 value);
17     event OwnerAddition(address indexed owner);
18     event OwnerRemoval(address indexed owner);
19     event RequirementChange(uint256 required);
20 
21     /*
22      *  Constants
23      */
24     uint256 constant public MAX_OWNER_COUNT = 50;
25 
26     /*
27      *  Storage
28      */
29     mapping (uint256 => Transaction) public transactions;
30     mapping (uint256 => mapping (address => bool)) public confirmations;
31     mapping (address => bool) public isOwner;
32     address[] public owners;
33     uint256 public required;
34     uint256 public transactionCount;
35 
36     struct Transaction {
37         address destination;
38         uint256 value;
39         bytes data;
40         bool executed;
41         uint256 timestamp;
42     }
43 
44     /*
45      *  Modifiers
46      */
47     modifier onlyWallet() {
48         require(msg.sender == address(this), "Only wallet");
49         _;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         require(!isOwner[owner], "Owner exists");
54         _;
55     }
56 
57     modifier ownerExists(address owner) {
58         require(isOwner[owner], "Owner does not exists");
59         _;
60     }
61 
62     modifier transactionExists(uint256 transactionId) {
63         require(transactions[transactionId].destination != address(0), "Tx doesn't exist");
64         _;
65     }
66 
67     modifier confirmed(uint256 transactionId, address owner) {
68         require(confirmations[transactionId][owner], "not confirmed");
69         _;
70     }
71 
72     modifier notConfirmed(uint256 transactionId, address owner) {
73         require(!confirmations[transactionId][owner], "is already confirmed");
74         _;
75     }
76 
77     modifier notExecuted(uint256 transactionId) {
78         require(!transactions[transactionId].executed, "tx already executed");
79         _;
80     }
81 
82     modifier notNull(address _address) {
83         require(_address != address(0), "address is null");
84         _;
85     }
86 
87     modifier validRequirement(uint256 ownerCount, uint256 _required) {
88         require(ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0, "invalid requirement");
89         _;
90     }
91 
92     /// @dev Fallback function allows to deposit ether.
93     function() external payable {
94         if (msg.value > 0)
95             emit Deposit(msg.sender, msg.value);
96     }
97 
98     /*
99      * Public functions
100      */
101     /// @dev Contract constructor sets initial owners and required number of confirmations.
102     /// @param _owners List of initial owners.
103     /// @param _required Number of required confirmations.
104     constructor(address[] memory _owners, uint256 _required) public validRequirement(_owners.length, _required) {
105         for (uint256 i = 0; i < _owners.length; i++) {
106             require(!isOwner[_owners[i]] && _owners[i] != address(0), "is already owner");
107             isOwner[_owners[i]] = true;
108         }
109         owners = _owners;
110         required = _required;
111     }
112 
113     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
114     /// @param owner Address of new owner to add.
115     function addOwner(address owner)  public
116         onlyWallet
117         ownerDoesNotExist(owner)
118         notNull(owner)
119         validRequirement(owners.length + 1, required)
120     {
121         isOwner[owner] = true;
122         owners.push(owner);
123         emit OwnerAddition(owner);
124     }
125 
126     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
127     /// @param owner Address of owner to remove.
128     function removeOwner(address owner) public onlyWallet ownerExists(owner) {
129         isOwner[owner] = false;
130         for (uint256 i = 0; i < owners.length - 1; i++){
131             if (owners[i] == owner) {
132                 owners[i] = owners[owners.length - 1];
133                 break;
134             }
135         }
136         owners.length -= 1;
137         if (required > owners.length)
138             changeRequirement(owners.length);
139         emit OwnerRemoval(owner);
140     }
141 
142     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
143     /// @param owner Address of owner to be replaced.
144     /// @param newOwner Address of new owner.
145     function replaceOwner(address owner, address newOwner) public onlyWallet ownerExists(owner) ownerDoesNotExist(newOwner) {
146         for(uint256 i = 0; i < owners.length; i++) {
147             if (owners[i] == owner) {
148                 owners[i] = newOwner;
149                 break;
150             }
151         }
152         isOwner[owner] = false;
153         isOwner[newOwner] = true;
154         emit OwnerRemoval(owner);
155         emit OwnerAddition(newOwner);
156     }
157 
158     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
159     /// @param _required Number of required confirmations.
160     function changeRequirement(uint256 _required) public onlyWallet validRequirement(owners.length, _required) {
161         required = _required;
162         emit RequirementChange(_required);
163     }
164 
165     /// @dev Allows an owner to submit and confirm a transaction.
166     /// @param destination Transaction target address.
167     /// @param value Transaction ether value.
168     /// @param data Transaction data payload.
169     /// @return Returns transaction ID.
170     function submitTransaction(address destination, uint256 value, bytes memory data) public returns (uint256 transactionId) {
171         transactionId = addTransaction(destination, value, data);
172         confirmTransaction(transactionId);
173     }
174 
175     /// @dev Allows an owner to confirm a transaction.
176     /// @param transactionId Transaction ID.
177     function confirmTransaction(uint256 transactionId) public
178         ownerExists(msg.sender)
179         transactionExists(transactionId)
180         notConfirmed(transactionId, msg.sender)
181     {
182         confirmations[transactionId][msg.sender] = true;
183         emit Confirmation(msg.sender, transactionId);
184         executeTransaction(transactionId);
185     }
186 
187     /// @dev Allows an owner to revoke a confirmation for a transaction.
188     /// @param transactionId Transaction ID.
189     function revokeConfirmation(uint256 transactionId) public
190         ownerExists(msg.sender)
191         confirmed(transactionId, msg.sender)
192         notExecuted(transactionId)
193     {
194         confirmations[transactionId][msg.sender] = false;
195         emit Revocation(msg.sender, transactionId);
196     }
197 
198     /// @dev Allows anyone to execute a confirmed transaction.
199     /// @param transactionId Transaction ID.
200     function executeTransaction(uint256 transactionId) public
201         ownerExists(msg.sender)
202         confirmed(transactionId, msg.sender)
203         notExecuted(transactionId)
204     {
205         if (isConfirmed(transactionId)) {
206             Transaction storage txn = transactions[transactionId];
207             txn.executed = true;
208             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
209                 emit Execution(transactionId);
210             else {
211                 emit ExecutionFailure(transactionId);
212                 txn.executed = false;
213             }
214         }
215     }
216 
217     // call has been separated into its own function in order to take advantage
218     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
219     function external_call(address destination, uint256 value, uint256 dataLength, bytes memory data) internal returns (bool) {
220         bool result;
221         assembly {
222             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
223             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
224             result := call(
225                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
226                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
227                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
228                 destination,
229                 value,
230                 d,
231                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
232                 x,
233                 0                  // Output is ignored, therefore the output size is zero
234             )
235         }
236         return result;
237     }
238 
239     /// @dev Returns the confirmation status of a transaction.
240     /// @param transactionId Transaction ID.
241     /// @return Confirmation status.
242     function isConfirmed(uint256 transactionId) public view returns (bool) {
243         uint256 count = 0;
244         for (uint256 i = 0; i < owners.length; i++) {
245             if (confirmations[transactionId][owners[i]])
246                 count += 1;
247             if (count == required)
248                 return true;
249         }
250     }
251 
252     /*
253      * Internal functions
254      */
255     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
256     /// @param destination Transaction target address.
257     /// @param value Transaction ether value.
258     /// @param data Transaction data payload.
259     /// @return Returns transaction ID.
260     function addTransaction(address destination, uint256 value, bytes memory data) internal
261      notNull(destination) returns (uint256 transactionId) {
262         transactionId = transactionCount;
263         transactions[transactionId] = Transaction({
264             destination: destination,
265             value: value,
266             data: data,
267             executed: false,
268             timestamp: now
269         });
270         transactionCount += 1;
271         emit Submission(transactionId);
272     }
273 
274     /*
275      * Web3 call functions
276      */
277     /// @dev Returns number of confirmations of a transaction.
278     /// @param transactionId Transaction ID.
279     /// @return Number of confirmations.
280     function getConfirmationCount(uint256 transactionId) public view returns (uint256 count) {
281         for (uint256 i = 0; i < owners.length; i++) {
282             if (confirmations[transactionId][owners[i]])  count += 1;
283         }
284     }
285 
286     /// @dev Returns total number of transactions after filers are applied.
287     /// @param pending Include pending transactions.
288     /// @param executed Include executed transactions.
289     /// @return Total number of transactions after filters are applied.
290     function getTransactionCount(bool pending, bool executed) public view returns (uint256 count) {
291         for (uint256 i = 0; i < transactionCount; i++) {
292             if ( pending && !transactions[i].executed || executed && transactions[i].executed)
293                 count += 1;
294         }
295     }
296 
297     /// @dev Returns list of owners.
298     /// @return List of owner addresses.
299     function getOwners() public view returns (address[] memory) {
300         return owners;
301     }
302 
303     /// @dev Returns array with owner addresses, which confirmed transaction.
304     /// @param transactionId Transaction ID.
305     /// @return Returns array of owner addresses.
306     function getConfirmations(uint256 transactionId) public view returns (address[] memory _confirmations) {
307         address[] memory confirmationsTemp = new address[](owners.length);
308         uint256 count = 0;
309         uint256 i;
310         for (i = 0; i < owners.length; i++) {
311             if (confirmations[transactionId][owners[i]]) {
312                 confirmationsTemp[count] = owners[i];
313                 count += 1;
314             }
315         }
316         _confirmations = new address[](count);
317         for (i = 0; i < count; i++) {
318             _confirmations[i] = confirmationsTemp[i];
319         }
320     }
321 
322     /// @dev Returns list of transaction IDs in defined range.
323     /// @param from Index start position of transaction array.
324     /// @param to Index end position of transaction array.
325     /// @param pending Include pending transactions.
326     /// @param executed Include executed transactions.
327     /// @return Returns array of transaction IDs.
328     function getTransactionIds(uint256 from, uint256 to, bool pending, bool executed) public view returns (uint256[] memory _transactionIds) {
329         uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
330         uint256 count = 0;
331         uint256 i;
332         for (i = 0; i < transactionCount; i++)
333             if (   pending && !transactions[i].executed || executed && transactions[i].executed) {
334                 transactionIdsTemp[count] = i;
335                 count += 1;
336             }
337         _transactionIds = new uint256[](to - from);
338         for (i = from; i < to; i++){
339             _transactionIds[i - from] = transactionIdsTemp[i];
340         }
341     }
342 
343     function getTransaction(uint256 transactionId) public view returns (bytes memory, address, bool, uint256) {
344         Transaction memory txn = transactions[transactionId];
345         return (
346             txn.data,
347             txn.destination,
348             txn.executed,
349             txn.timestamp
350         );
351     }
352 }
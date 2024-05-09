1 pragma solidity ^0.4.15;
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
62         require(transactions[transactionId].destination != 0);
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
82         require(_address != 0);
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
96         payable
97     {
98         if (msg.value > 0)
99             Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     function MultiSigWallet(address[] _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint i=0; i<_owners.length; i++) {
113             require(!isOwner[_owners[i]] && _owners[i] != 0);
114             isOwner[_owners[i]] = true;
115         }
116         owners = _owners;
117         required = _required;
118     }
119 
120     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
121     /// @param _required Number of required confirmations.
122     function changeRequirement(uint _required)
123         public
124         onlyWallet
125         validRequirement(owners.length, _required)
126     {
127         required = _required;
128         RequirementChange(_required);
129     }
130 
131     /// @dev Allows an owner to submit and confirm a transaction.
132     /// @param destination Transaction target address.
133     /// @param value Transaction ether value.
134     /// @param data Transaction data payload.
135     /// @return Returns transaction ID.
136     function submitTransaction(address destination, uint value, bytes data)
137         public
138         returns (uint transactionId)
139     {
140         transactionId = addTransaction(destination, value, data);
141         confirmTransaction(transactionId);
142     }
143 
144     /// @dev Allows an owner to confirm a transaction.
145     /// @param transactionId Transaction ID.
146     function confirmTransaction(uint transactionId)
147         public
148         ownerExists(msg.sender)
149         transactionExists(transactionId)
150         notConfirmed(transactionId, msg.sender)
151     {
152         confirmations[transactionId][msg.sender] = true;
153         Confirmation(msg.sender, transactionId);
154         executeTransaction(transactionId);
155     }
156 
157     /// @dev Allows an owner to revoke a confirmation for a transaction.
158     /// @param transactionId Transaction ID.
159     function revokeConfirmation(uint transactionId)
160         public
161         ownerExists(msg.sender)
162         confirmed(transactionId, msg.sender)
163         notExecuted(transactionId)
164     {
165         confirmations[transactionId][msg.sender] = false;
166         Revocation(msg.sender, transactionId);
167     }
168 
169     /// @dev Allows anyone to execute a confirmed transaction.
170     /// @param transactionId Transaction ID.
171     function executeTransaction(uint transactionId)
172         public
173         ownerExists(msg.sender)
174         confirmed(transactionId, msg.sender)
175         notExecuted(transactionId)
176     {
177         if (isConfirmed(transactionId)) {
178             Transaction storage txn = transactions[transactionId];
179             txn.executed = true;
180             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
181                 Execution(transactionId);
182             else {
183                 ExecutionFailure(transactionId);
184                 txn.executed = false;
185             }
186         }
187     }
188 
189     // call has been separated into its own function in order to take advantage
190     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
191     function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {
192         bool result;
193         assembly {
194             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
195             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
196             result := call(
197                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
198                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
199                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
200                 destination,
201                 value,
202                 d,
203                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
204                 x,
205                 0                  // Output is ignored, therefore the output size is zero
206             )
207         }
208         return result;
209     }
210 
211     /// @dev Returns the confirmation status of a transaction.
212     /// @param transactionId Transaction ID.
213     /// @return Confirmation status.
214     function isConfirmed(uint transactionId)
215         public
216         constant
217         returns (bool)
218     {
219         uint count = 0;
220         for (uint i=0; i<owners.length; i++) {
221             if (confirmations[transactionId][owners[i]])
222                 count += 1;
223             if (count == required)
224                 return true;
225         }
226     }
227 
228     /*
229      * Internal functions
230      */
231     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
232     /// @param destination Transaction target address.
233     /// @param value Transaction ether value.
234     /// @param data Transaction data payload.
235     /// @return Returns transaction ID.
236     function addTransaction(address destination, uint value, bytes data)
237         internal
238         notNull(destination)
239         returns (uint transactionId)
240     {
241         transactionId = transactionCount;
242         transactions[transactionId] = Transaction({
243             destination: destination,
244             value: value,
245             data: data,
246             executed: false
247         });
248         transactionCount += 1;
249         Submission(transactionId);
250     }
251 
252     /*
253      * Web3 call functions
254      */
255     /// @dev Returns number of confirmations of a transaction.
256     /// @param transactionId Transaction ID.
257     /// @return Number of confirmations.
258     function getConfirmationCount(uint transactionId)
259         public
260         constant
261         returns (uint count)
262     {
263         for (uint i=0; i<owners.length; i++)
264             if (confirmations[transactionId][owners[i]])
265                 count += 1;
266     }
267 
268     /// @dev Returns total number of transactions after filers are applied.
269     /// @param pending Include pending transactions.
270     /// @param executed Include executed transactions.
271     /// @return Total number of transactions after filters are applied.
272     function getTransactionCount(bool pending, bool executed)
273         public
274         constant
275         returns (uint count)
276     {
277         for (uint i=0; i<transactionCount; i++)
278             if (   pending && !transactions[i].executed
279                 || executed && transactions[i].executed)
280                 count += 1;
281     }
282 
283     /// @dev Returns list of owners.
284     /// @return List of owner addresses.
285     function getOwners()
286         public
287         constant
288         returns (address[])
289     {
290         return owners;
291     }
292 
293     /// @dev Returns array with owner addresses, which confirmed transaction.
294     /// @param transactionId Transaction ID.
295     /// @return Returns array of owner addresses.
296     function getConfirmations(uint transactionId)
297         public
298         constant
299         returns (address[] _confirmations)
300     {
301         address[] memory confirmationsTemp = new address[](owners.length);
302         uint count = 0;
303         uint i;
304         for (i=0; i<owners.length; i++)
305             if (confirmations[transactionId][owners[i]]) {
306                 confirmationsTemp[count] = owners[i];
307                 count += 1;
308             }
309         _confirmations = new address[](count);
310         for (i=0; i<count; i++)
311             _confirmations[i] = confirmationsTemp[i];
312     }
313 
314     /// @dev Returns list of transaction IDs in defined range.
315     /// @param from Index start position of transaction array.
316     /// @param to Index end position of transaction array.
317     /// @param pending Include pending transactions.
318     /// @param executed Include executed transactions.
319     /// @return Returns array of transaction IDs.
320     function getTransactionIds(uint from, uint to, bool pending, bool executed)
321         public
322         constant
323         returns (uint[] _transactionIds)
324     {
325         uint[] memory transactionIdsTemp = new uint[](transactionCount);
326         uint count = 0;
327         uint i;
328         for (i=0; i<transactionCount; i++)
329             if (   pending && !transactions[i].executed
330                 || executed && transactions[i].executed)
331             {
332                 transactionIdsTemp[count] = i;
333                 count += 1;
334             }
335         _transactionIds = new uint[](to - from);
336         for (i=from; i<to; i++)
337             _transactionIds[i - from] = transactionIdsTemp[i];
338     }
339 }
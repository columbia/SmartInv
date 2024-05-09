1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 
7     /*
8      *  Events
9      */
10     event Confirmation(address indexed sender, uint indexed transactionId);
11     event Revocation(address indexed sender, uint indexed transactionId);
12     event Submission(uint indexed transactionId);
13     event Execution(uint indexed transactionId);
14     event ExecutionFailure(uint indexed transactionId);
15     event Deposit(address indexed sender, uint value);
16     event OwnerAddition(address indexed owner);
17     event OwnerRemoval(address indexed owner);
18     event RequirementChange(uint required);
19 
20     /*
21      *  Constants
22      */
23     uint constant public MAX_OWNER_COUNT = 50;
24 
25     /*
26      *  Storage
27      */
28     mapping (uint => Transaction) public transactions;
29     mapping (uint => mapping (address => bool)) public confirmations;
30     mapping (address => bool) public isOwner;
31     address[] public owners;
32     uint public required;
33     uint public transactionCount;
34 
35     struct Transaction {
36         address destination;
37         uint value;
38         bytes data;
39         bool executed;
40     }
41 
42     /*
43      *  Modifiers
44      */
45     modifier onlyWallet() {
46         require(msg.sender == address(this), "Bad call");
47         _;
48     }
49 
50     modifier ownerDoesNotExist(address owner) {
51         require(!isOwner[owner], "Duplicated owner");
52         _;
53     }
54 
55     modifier ownerExists(address owner) {
56         require(isOwner[owner], "Unauthorized");
57         _;
58     }
59 
60     modifier transactionExists(uint transactionId) {
61         require(transactions[transactionId].destination != address(0), "Unknown txId");
62         _;
63     }
64 
65     modifier confirmed(uint transactionId, address owner) {
66         require(confirmations[transactionId][owner], "Not confirmed yet");
67         _;
68     }
69 
70     modifier notConfirmed(uint transactionId, address owner) {
71         require(!confirmations[transactionId][owner], "Already confirmed");
72         _;
73     }
74 
75     modifier notExecuted(uint transactionId) {
76         require(!transactions[transactionId].executed, "Already executed");
77         _;
78     }
79 
80     modifier notNull(address _address) {
81         require(_address != address(0), "Address cannot be null");
82         _;
83     }
84 
85     modifier validRequirement(uint ownerCount, uint _required) {
86         require(ownerCount <= MAX_OWNER_COUNT
87             && _required <= ownerCount
88             && _required != 0
89             && ownerCount != 0, "Bad parameters");
90         _;
91     }
92 
93     /// @dev Fallback function allows to deposit ether.
94     function()
95         external
96         payable
97     {
98         if (msg.value > 0)
99             emit Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     constructor(address[] memory _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint i=0; i<_owners.length; i++) {
113             require(!isOwner[_owners[i]] && _owners[i] != address(0), "Bad parameters");
114             isOwner[_owners[i]] = true;
115         }
116         owners = _owners;
117         required = _required;
118     }
119 
120     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121     /// @param owner Address of new owner.
122     function addOwner(address owner)
123         external
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
136     function removeOwner(address owner)
137         external
138         onlyWallet
139         ownerExists(owner)
140     {
141         isOwner[owner] = false;
142         for (uint i=0; i<owners.length - 1; i++)
143             if (owners[i] == owner) {
144                 owners[i] = owners[owners.length - 1];
145                 break;
146             }
147         owners.length -= 1;
148         if (required > owners.length)
149             changeRequirement(owners.length);
150         emit OwnerRemoval(owner);
151     }
152 
153     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
154     /// @param owner Address of owner to be replaced.
155     /// @param newOwner Address of new owner.
156     function replaceOwner(address owner, address newOwner)
157         external
158         onlyWallet
159         ownerExists(owner)
160         ownerDoesNotExist(newOwner)
161     {
162         for (uint i=0; i<owners.length; i++)
163             if (owners[i] == owner) {
164                 owners[i] = newOwner;
165                 break;
166             }
167         isOwner[owner] = false;
168         isOwner[newOwner] = true;
169         emit OwnerRemoval(owner);
170         emit OwnerAddition(newOwner);
171     }
172 
173     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
174     /// @param _required Number of required confirmations.
175     function changeRequirement(uint _required)
176         public
177         onlyWallet
178         validRequirement(owners.length, _required)
179     {
180         required = _required;
181         emit RequirementChange(_required);
182     }
183 
184     /// @dev Allows an owner to submit and confirm a transaction.
185     /// @param destination Transaction target address.
186     /// @param value Transaction ether value.
187     /// @param data Transaction data payload.
188     /// @return Returns transaction ID.
189     function submitTransaction(address destination, uint value, bytes calldata data)
190         external
191         returns (uint transactionId)
192     {
193         transactionId = addTransaction(destination, value, data);
194         confirmTransaction(transactionId);
195     }
196 
197     /// @dev Allows an owner to confirm a transaction.
198     /// @param transactionId Transaction ID.
199     function confirmTransaction(uint transactionId)
200         public
201         ownerExists(msg.sender)
202         transactionExists(transactionId)
203         notConfirmed(transactionId, msg.sender)
204     {
205         confirmations[transactionId][msg.sender] = true;
206         emit Confirmation(msg.sender, transactionId);
207         executeTransaction(transactionId);
208     }
209 
210     /// @dev Allows an owner to revoke a confirmation for a transaction.
211     /// @param transactionId Transaction ID.
212     function revokeConfirmation(uint transactionId)
213         external
214         ownerExists(msg.sender)
215         confirmed(transactionId, msg.sender)
216         notExecuted(transactionId)
217     {
218         confirmations[transactionId][msg.sender] = false;
219         emit Revocation(msg.sender, transactionId);
220     }
221 
222     /// @dev Allows anyone to execute a confirmed transaction.
223     /// @param transactionId Transaction ID.
224     function executeTransaction(uint transactionId)
225         public
226         ownerExists(msg.sender)
227         confirmed(transactionId, msg.sender)
228         notExecuted(transactionId)
229     {
230         if (isConfirmed(transactionId)) {
231             Transaction storage txn = transactions[transactionId];
232             txn.executed = true;
233             (bool success, ) = txn.destination.call.value(txn.value)(txn.data);
234             if (success)
235                 emit Execution(transactionId);
236             else {
237                 emit ExecutionFailure(transactionId);
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
248         view
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
268     function addTransaction(address destination, uint value, bytes memory data)
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
281         emit Submission(transactionId);
282     }
283 
284     /*
285      * Web3 call functions
286      */
287     /// @dev Returns number of confirmations of a transaction.
288     /// @param transactionId Transaction ID.
289     /// @return Number of confirmations.
290     function getConfirmationCount(uint transactionId)
291         external
292         view
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
305         external
306         view
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
318         external
319         view
320         returns (address[] memory)
321     {
322         return owners;
323     }
324 
325     /// @dev Returns array with owner addresses, which confirmed transaction.
326     /// @param transactionId Transaction ID.
327     /// @return Returns array of owner addresses.
328     function getConfirmations(uint transactionId)
329         external
330         view
331         returns (address[] memory _confirmations)
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
353         external
354         view
355         returns (uint[] memory _transactionIds)
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
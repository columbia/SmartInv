1 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
2 /// @author Stefan George - <stefan.george@consensys.net>
3 contract MultiSigWallet {
4 
5     uint constant public MAX_OWNER_COUNT = 50;
6 
7     event Confirmation(address indexed sender, uint indexed transactionId);
8     event Revocation(address indexed sender, uint indexed transactionId);
9     event Submission(uint indexed transactionId);
10     event Execution(uint indexed transactionId);
11     event ExecutionFailure(uint indexed transactionId);
12     event Deposit(address indexed sender, uint value);
13     event OwnerAddition(address indexed owner);
14     event OwnerRemoval(address indexed owner);
15     event RequirementChange(uint required);
16 
17     mapping (uint => Transaction) public transactions;
18     mapping (uint => mapping (address => bool)) public confirmations;
19     mapping (address => bool) public isOwner;
20     address[] public owners;
21     uint public required;
22     uint public transactionCount;
23 
24     struct Transaction {
25         address destination;
26         uint value;
27         bytes data;
28         bool executed;
29     }
30 
31     modifier onlyWallet() {
32         if (msg.sender != address(this))
33             throw;
34         _;
35     }
36 
37     modifier ownerDoesNotExist(address owner) {
38         if (isOwner[owner])
39             throw;
40         _;
41     }
42 
43     modifier ownerExists(address owner) {
44         if (!isOwner[owner])
45             throw;
46         _;
47     }
48 
49     modifier transactionExists(uint transactionId) {
50         if (transactions[transactionId].destination == 0)
51             throw;
52         _;
53     }
54 
55     modifier confirmed(uint transactionId, address owner) {
56         if (!confirmations[transactionId][owner])
57             throw;
58         _;
59     }
60 
61     modifier notConfirmed(uint transactionId, address owner) {
62         if (confirmations[transactionId][owner])
63             throw;
64         _;
65     }
66 
67     modifier notExecuted(uint transactionId) {
68         if (transactions[transactionId].executed)
69             throw;
70         _;
71     }
72 
73     modifier notNull(address _address) {
74         if (_address == 0)
75             throw;
76         _;
77     }
78 
79     modifier validRequirement(uint ownerCount, uint _required) {
80         if (   ownerCount > MAX_OWNER_COUNT
81             || _required > ownerCount
82             || _required == 0
83             || ownerCount == 0)
84             throw;
85         _;
86     }
87 
88     /// @dev Fallback function allows to deposit ether.
89     function()
90         payable
91     {
92         if (msg.value > 0)
93             Deposit(msg.sender, msg.value);
94     }
95 
96     /*
97      * Public functions
98      */
99     /// @dev Contract constructor sets initial owners and required number of confirmations.
100     /// @param _owners List of initial owners.
101     /// @param _required Number of required confirmations.
102     function MultiSigWallet(address[] _owners, uint _required)
103         public
104         validRequirement(_owners.length, _required)
105     {
106         for (uint i=0; i<_owners.length; i++) {
107             if (isOwner[_owners[i]] || _owners[i] == 0)
108                 throw;
109             isOwner[_owners[i]] = true;
110         }
111         owners = _owners;
112         required = _required;
113     }
114 
115     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
116     /// @param owner Address of new owner.
117     function addOwner(address owner)
118         public
119         onlyWallet
120         ownerDoesNotExist(owner)
121         notNull(owner)
122         validRequirement(owners.length + 1, required)
123     {
124         isOwner[owner] = true;
125         owners.push(owner);
126         OwnerAddition(owner);
127     }
128 
129     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
130     /// @param owner Address of owner.
131     function removeOwner(address owner)
132         public
133         onlyWallet
134         ownerExists(owner)
135     {
136         isOwner[owner] = false;
137         for (uint i=0; i<owners.length - 1; i++)
138             if (owners[i] == owner) {
139                 owners[i] = owners[owners.length - 1];
140                 break;
141             }
142         owners.length -= 1;
143         if (required > owners.length)
144             changeRequirement(owners.length);
145         OwnerRemoval(owner);
146     }
147 
148     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
149     /// @param owner Address of owner to be replaced.
150     /// @param owner Address of new owner.
151     function replaceOwner(address owner, address newOwner)
152         public
153         onlyWallet
154         ownerExists(owner)
155         ownerDoesNotExist(newOwner)
156     {
157         for (uint i=0; i<owners.length; i++)
158             if (owners[i] == owner) {
159                 owners[i] = newOwner;
160                 break;
161             }
162         isOwner[owner] = false;
163         isOwner[newOwner] = true;
164         OwnerRemoval(owner);
165         OwnerAddition(newOwner);
166     }
167 
168     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
169     /// @param _required Number of required confirmations.
170     function changeRequirement(uint _required)
171         public
172         onlyWallet
173         validRequirement(owners.length, _required)
174     {
175         required = _required;
176         RequirementChange(_required);
177     }
178 
179     /// @dev Allows an owner to submit and confirm a transaction.
180     /// @param destination Transaction target address.
181     /// @param value Transaction ether value.
182     /// @param data Transaction data payload.
183     /// @return Returns transaction ID.
184     function submitTransaction(address destination, uint value, bytes data)
185         public
186         returns (uint transactionId)
187     {
188         transactionId = addTransaction(destination, value, data);
189         confirmTransaction(transactionId);
190     }
191 
192     /// @dev Allows an owner to confirm a transaction.
193     /// @param transactionId Transaction ID.
194     function confirmTransaction(uint transactionId)
195         public
196         ownerExists(msg.sender)
197         transactionExists(transactionId)
198         notConfirmed(transactionId, msg.sender)
199     {
200         confirmations[transactionId][msg.sender] = true;
201         Confirmation(msg.sender, transactionId);
202         executeTransaction(transactionId);
203     }
204 
205     /// @dev Allows an owner to revoke a confirmation for a transaction.
206     /// @param transactionId Transaction ID.
207     function revokeConfirmation(uint transactionId)
208         public
209         ownerExists(msg.sender)
210         confirmed(transactionId, msg.sender)
211         notExecuted(transactionId)
212     {
213         confirmations[transactionId][msg.sender] = false;
214         Revocation(msg.sender, transactionId);
215     }
216 
217     /// @dev Allows anyone to execute a confirmed transaction.
218     /// @param transactionId Transaction ID.
219     function executeTransaction(uint transactionId)
220         public
221         notExecuted(transactionId)
222     {
223         if (isConfirmed(transactionId)) {
224             Transaction tx = transactions[transactionId];
225             tx.executed = true;
226             if (tx.destination.call.value(tx.value)(tx.data))
227                 Execution(transactionId);
228             else {
229                 ExecutionFailure(transactionId);
230                 tx.executed = false;
231             }
232         }
233     }
234 
235     /// @dev Returns the confirmation status of a transaction.
236     /// @param transactionId Transaction ID.
237     /// @return Confirmation status.
238     function isConfirmed(uint transactionId)
239         public
240         constant
241         returns (bool)
242     {
243         uint count = 0;
244         for (uint i=0; i<owners.length; i++) {
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
260     function addTransaction(address destination, uint value, bytes data)
261         internal
262         notNull(destination)
263         returns (uint transactionId)
264     {
265         transactionId = transactionCount;
266         transactions[transactionId] = Transaction({
267             destination: destination,
268             value: value,
269             data: data,
270             executed: false
271         });
272         transactionCount += 1;
273         Submission(transactionId);
274     }
275 
276     /*
277      * Web3 call functions
278      */
279     /// @dev Returns number of confirmations of a transaction.
280     /// @param transactionId Transaction ID.
281     /// @return Number of confirmations.
282     function getConfirmationCount(uint transactionId)
283         public
284         constant
285         returns (uint count)
286     {
287         for (uint i=0; i<owners.length; i++)
288             if (confirmations[transactionId][owners[i]])
289                 count += 1;
290     }
291 
292     /// @dev Returns total number of transactions after filers are applied.
293     /// @param pending Include pending transactions.
294     /// @param executed Include executed transactions.
295     /// @return Total number of transactions after filters are applied.
296     function getTransactionCount(bool pending, bool executed)
297         public
298         constant
299         returns (uint count)
300     {
301         for (uint i=0; i<transactionCount; i++)
302             if (   pending && !transactions[i].executed
303                 || executed && transactions[i].executed)
304                 count += 1;
305     }
306 
307     /// @dev Returns list of owners.
308     /// @return List of owner addresses.
309     function getOwners()
310         public
311         constant
312         returns (address[])
313     {
314         return owners;
315     }
316 
317     /// @dev Returns array with owner addresses, which confirmed transaction.
318     /// @param transactionId Transaction ID.
319     /// @return Returns array of owner addresses.
320     function getConfirmations(uint transactionId)
321         public
322         constant
323         returns (address[] _confirmations)
324     {
325         address[] memory confirmationsTemp = new address[](owners.length);
326         uint count = 0;
327         uint i;
328         for (i=0; i<owners.length; i++)
329             if (confirmations[transactionId][owners[i]]) {
330                 confirmationsTemp[count] = owners[i];
331                 count += 1;
332             }
333         _confirmations = new address[](count);
334         for (i=0; i<count; i++)
335             _confirmations[i] = confirmationsTemp[i];
336     }
337 
338     /// @dev Returns list of transaction IDs in defined range.
339     /// @param from Index start position of transaction array.
340     /// @param to Index end position of transaction array.
341     /// @param pending Include pending transactions.
342     /// @param executed Include executed transactions.
343     /// @return Returns array of transaction IDs.
344     function getTransactionIds(uint from, uint to, bool pending, bool executed)
345         public
346         constant
347         returns (uint[] _transactionIds)
348     {
349         uint[] memory transactionIdsTemp = new uint[](transactionCount);
350         uint count = 0;
351         uint i;
352         for (i=0; i<transactionCount; i++)
353             if (   pending && !transactions[i].executed
354                 || executed && transactions[i].executed)
355             {
356                 transactionIdsTemp[count] = i;
357                 count += 1;
358             }
359         _transactionIds = new uint[](to - from);
360         for (i=from; i<to; i++)
361             _transactionIds[i - from] = transactionIdsTemp[i];
362     }
363 }
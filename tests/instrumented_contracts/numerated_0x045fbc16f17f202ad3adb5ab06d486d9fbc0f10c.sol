1 pragma solidity ^0.4.24;
2 
3 // File: contracts/wallet/MultiSigWallet.sol
4 
5 /**
6  * Originally from https://github.com/ConsenSys/MultiSigWallet
7  * Updated Version for solidity 0.4.24
8  */
9 
10 pragma solidity ^0.4.24;
11 
12 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
13 /// @author Stefan George - <stefan.george@consensys.net>
14 contract MultiSigWallet {
15 
16     uint constant public MAX_OWNER_COUNT = 50;
17 
18     event Confirmation(address indexed sender, uint indexed transactionId);
19     event Revocation(address indexed sender, uint indexed transactionId);
20     event Submission(uint indexed transactionId);
21     event Execution(uint indexed transactionId);
22     event ExecutionFailure(uint indexed transactionId);
23     event Deposit(address indexed sender, uint value);
24     event OwnerAddition(address indexed owner);
25     event OwnerRemoval(address indexed owner);
26     event RequirementChange(uint required);
27 
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
42     modifier onlyWallet() {
43         require(msg.sender == address(this));
44         _;
45     }
46 
47     modifier ownerDoesNotExist(address owner) {
48         require(!(isOwner[owner]));
49         _;
50     }
51 
52     modifier ownerExists(address owner) {
53         require(isOwner[owner]);
54         _;
55     }
56 
57     modifier transactionExists(uint transactionId) {
58         require(transactions[transactionId].destination != 0);
59         _;
60     }
61 
62     modifier confirmed(uint transactionId, address owner) {
63         require(confirmations[transactionId][owner]);
64         _;
65     }
66 
67     modifier notConfirmed(uint transactionId, address owner) {
68         require(!(confirmations[transactionId][owner]));
69         _;
70     }
71 
72     modifier notExecuted(uint transactionId) {
73         require(!(transactions[transactionId].executed));
74         _;
75     }
76 
77     modifier notNull(address _address) {
78         require(_address != 0);
79         _;
80     }
81 
82     modifier validRequirement(uint ownerCount, uint _required) {
83         require(!(ownerCount > MAX_OWNER_COUNT || _required > ownerCount || _required == 0 || ownerCount == 0));
84         _;
85     }
86 
87     /// @dev Fallback function allows to deposit ether.
88     function() public
89         payable
90     {
91         if (msg.value > 0)
92             emit Deposit(msg.sender, msg.value);
93     }
94 
95     /*
96      * Public functions
97      */
98     /// @dev Contract constructor sets initial owners and required number of confirmations.
99     /// @param _owners List of initial owners.
100     /// @param _required Number of required confirmations.
101     constructor(address[] _owners, uint _required)
102         public
103         validRequirement(_owners.length, _required)
104     {
105         for (uint i=0; i<_owners.length; i++) {
106             assert(!(isOwner[_owners[i]] || _owners[i] == 0));
107             isOwner[_owners[i]] = true;
108         }
109         owners = _owners;
110         required = _required;
111     }
112 
113     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
114     /// @param owner Address of new owner.
115     function addOwner(address owner)
116         public
117         onlyWallet
118         ownerDoesNotExist(owner)
119         notNull(owner)
120         validRequirement(owners.length + 1, required)
121     {
122         isOwner[owner] = true;
123         owners.push(owner);
124         emit OwnerAddition(owner);
125     }
126 
127     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
128     /// @param owner Address of owner.
129     function removeOwner(address owner)
130         public
131         onlyWallet
132         ownerExists(owner)
133     {
134         isOwner[owner] = false;
135         for (uint i=0; i<owners.length - 1; i++)
136             if (owners[i] == owner) {
137                 owners[i] = owners[owners.length - 1];
138                 break;
139             }
140         owners.length -= 1;
141         if (required > owners.length)
142             changeRequirement(owners.length);
143         emit OwnerRemoval(owner);
144     }
145 
146     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
147     /// @param owner Address of owner to be replaced.
148     /// @param owner Address of new owner.
149     function replaceOwner(address owner, address newOwner)
150         public
151         onlyWallet
152         ownerExists(owner)
153         ownerDoesNotExist(newOwner)
154     {
155         for (uint i=0; i<owners.length; i++)
156             if (owners[i] == owner) {
157                 owners[i] = newOwner;
158                 break;
159             }
160         isOwner[owner] = false;
161         isOwner[newOwner] = true;
162         emit OwnerRemoval(owner);
163         emit OwnerAddition(newOwner);
164     }
165 
166     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
167     /// @param _required Number of required confirmations.
168     function changeRequirement(uint _required)
169         public
170         onlyWallet
171         validRequirement(owners.length, _required)
172     {
173         required = _required;
174         emit RequirementChange(_required);
175     }
176 
177     /// @dev Allows an owner to submit and confirm a transaction.
178     /// @param destination Transaction target address.
179     /// @param value Transaction ether value.
180     /// @param data Transaction data payload.
181     /// @return Returns transaction ID.
182     function submitTransaction(address destination, uint value, bytes data)
183         public
184         returns (uint transactionId)
185     {
186         transactionId = addTransaction(destination, value, data);
187         confirmTransaction(transactionId);
188     }
189 
190     /// @dev Allows an owner to confirm a transaction.
191     /// @param transactionId Transaction ID.
192     function confirmTransaction(uint transactionId)
193         public
194         ownerExists(msg.sender)
195         transactionExists(transactionId)
196         notConfirmed(transactionId, msg.sender)
197     {
198         confirmations[transactionId][msg.sender] = true;
199         emit Confirmation(msg.sender, transactionId);
200         executeTransaction(transactionId);
201     }
202 
203     /// @dev Allows an owner to revoke a confirmation for a transaction.
204     /// @param transactionId Transaction ID.
205     function revokeConfirmation(uint transactionId)
206         public
207         ownerExists(msg.sender)
208         confirmed(transactionId, msg.sender)
209         notExecuted(transactionId)
210     {
211         confirmations[transactionId][msg.sender] = false;
212         emit Revocation(msg.sender, transactionId);
213     }
214 
215     /// @dev Allows anyone to execute a confirmed transaction.
216     /// @param transactionId Transaction ID.
217     function executeTransaction(uint transactionId)
218         public
219         notExecuted(transactionId)
220     {
221         if (isConfirmed(transactionId)) {
222             Transaction storage txn = transactions[transactionId];
223             txn.executed = true;
224             if (txn.destination.call.value(txn.value)(txn.data))
225                 emit Execution(transactionId);
226             else {
227                 emit ExecutionFailure(transactionId);
228                 txn.executed = false;
229             }
230         }
231     }
232 
233     /// @dev Returns the confirmation status of a transaction.
234     /// @param transactionId Transaction ID.
235     /// @return Confirmation status.
236     function isConfirmed(uint transactionId)
237         public
238         view
239         returns (bool)
240     {
241         uint count = 0;
242         for (uint i=0; i<owners.length; i++) {
243             if (confirmations[transactionId][owners[i]])
244                 count += 1;
245             if (count == required)
246                 return true;
247         }
248     }
249 
250     /*
251      * Internal functions
252      */
253     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
254     /// @param destination Transaction target address.
255     /// @param value Transaction ether value.
256     /// @param data Transaction data payload.
257     /// @return Returns transaction ID.
258     function addTransaction(address destination, uint value, bytes data)
259         internal
260         notNull(destination)
261         returns (uint transactionId)
262     {
263         transactionId = transactionCount;
264         transactions[transactionId] = Transaction({
265             destination: destination,
266             value: value,
267             data: data,
268             executed: false
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
280     function getConfirmationCount(uint transactionId)
281         public
282         view
283         returns (uint count)
284     {
285         for (uint i=0; i<owners.length; i++) {
286             if (confirmations[transactionId][owners[i]]) {
287                 count += 1;
288             }
289         }
290     }
291 
292     /// @dev Returns total number of transactions after filers are applied.
293     /// @param pending Include pending transactions.
294     /// @param executed Include executed transactions.
295     /// @return Total number of transactions after filters are applied.
296     function getTransactionCount(bool pending, bool executed)
297         public
298         view
299         returns (uint count)
300     {
301         for (uint i=0; i<transactionCount; i++) {
302             if (   pending && !transactions[i].executed
303                 || executed && transactions[i].executed) {
304                 count += 1;
305             }
306         }
307     }
308 
309     /// @dev Returns list of owners.
310     /// @return List of owner addresses.
311     function getOwners()
312         public
313         view
314         returns (address[])
315     {
316         return owners;
317     }
318 
319     /// @dev Returns array with owner addresses, which confirmed transaction.
320     /// @param transactionId Transaction ID.
321     /// @return Returns array of owner addresses.
322     function getConfirmations(uint transactionId)
323         public
324         view
325         returns (address[] _confirmations)
326     {
327         address[] memory confirmationsTemp = new address[](owners.length);
328         uint count = 0;
329         uint i;
330         for (i=0; i<owners.length; i++)
331             if (confirmations[transactionId][owners[i]]) {
332                 confirmationsTemp[count] = owners[i];
333                 count += 1;
334             }
335         _confirmations = new address[](count);
336         for (i=0; i<count; i++)
337             _confirmations[i] = confirmationsTemp[i];
338     }
339 
340     /// @dev Returns list of transaction IDs in defined range.
341     /// @param from Index start position of transaction array.
342     /// @param to Index end position of transaction array.
343     /// @param pending Include pending transactions.
344     /// @param executed Include executed transactions.
345     /// @return Returns array of transaction IDs.
346     function getTransactionIds(uint from, uint to, bool pending, bool executed)
347         public
348         view
349         returns (uint[] _transactionIds)
350     {
351         uint[] memory transactionIdsTemp = new uint[](transactionCount);
352         uint count = 0;
353         uint i;
354         for (i=0; i<transactionCount; i++)
355             if (   pending && !transactions[i].executed
356                 || executed && transactions[i].executed)
357             {
358                 transactionIdsTemp[count] = i;
359                 count += 1;
360             }
361         _transactionIds = new uint[](to - from);
362         for (i=from; i<to; i++)
363             _transactionIds[i - from] = transactionIdsTemp[i];
364     }
365 }
366 
367 // File: contracts/GnosisWallet.sol
368 
369 contract GnosisWallet is MultiSigWallet {
370     
371     /** 
372     * @dev Contract constructor sets initial owners, required number of confirmations and daily withdraw limit.
373     * @param _owners List of initial owners.
374     * @param _required Number of required confirmations.
375     */
376     constructor(address[] _owners, uint _required)
377         public
378         MultiSigWallet(_owners, _required)
379     { }
380 }
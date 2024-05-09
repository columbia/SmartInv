1 pragma solidity ^0.4.24;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6     uint constant public MAX_OWNER_COUNT = 50;
7 
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
18     mapping (uint => Transaction) public transactions;
19     mapping (uint => mapping (address => bool)) public confirmations;
20     mapping (address => bool) public isOwner;
21 
22     address[] public owners;
23     uint public required;
24     uint public transactionCount;
25 
26     struct Transaction {
27         address destination;
28         uint value;
29         bytes data;
30         bool executed;
31     }
32 
33     modifier onlyWallet() {
34         require(msg.sender == address(this));
35         _;
36     }
37 
38     modifier ownerDoesNotExist(address owner) {
39         require(!isOwner[owner]);
40         _;
41     }
42 
43     modifier ownerExists(address owner) {
44         require(isOwner[owner]);
45         _;
46     }
47 
48     modifier transactionExists(uint transactionId) {
49         require(transactions[transactionId].destination != 0);
50         _;
51     }
52 
53     modifier confirmed(uint transactionId, address owner) {
54         require(confirmations[transactionId][owner]);
55         _;
56     }
57 
58     modifier notConfirmed(uint transactionId, address owner) {
59         require(!confirmations[transactionId][owner]);
60         _;
61     }
62 
63     modifier notExecuted(uint transactionId) {
64         require(!transactions[transactionId].executed);
65         _;
66     }
67 
68     modifier notNull(address _address) {
69         require(_address != address(0));
70         _;
71     }
72 
73     modifier validRequirement(uint ownerCount, uint _required) {
74         bool ownerValid = ownerCount <= MAX_OWNER_COUNT;
75         bool ownerNotZero = ownerCount != 0;
76         bool requiredValid = _required <= ownerCount;
77         bool requiredNotZero = _required != 0;
78         require(ownerValid && ownerNotZero && requiredValid && requiredNotZero);
79         _;
80     }
81 
82     /// @dev Fallback function allows to deposit ether.
83     function() payable public {
84         fallback();
85     }
86 
87     function fallback() payable public {
88         if (msg.value > 0) {
89             emit Deposit(msg.sender, msg.value);
90         }
91     }
92 
93     /*
94      * Public functions
95      */
96     /// @dev Contract constructor sets initial owners and required number of confirmations.
97     /// @param _owners List of initial owners.
98     /// @param _required Number of required confirmations.
99     constructor(
100         address[] _owners, 
101         uint _required
102     ) public validRequirement(_owners.length, _required) 
103     {
104         for (uint i = 0; i<_owners.length; i++) {
105             require(!isOwner[_owners[i]] && _owners[i] != 0);
106             isOwner[_owners[i]] = true;
107         }
108         owners = _owners;
109         required = _required;
110     }
111 
112     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
113     /// @param owner Address of new owner.
114     function addOwner(address owner)
115         public
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
127     /// @param owner Address of owner.
128     function removeOwner(address owner)
129         public
130         onlyWallet
131         ownerExists(owner)
132     {
133         isOwner[owner] = false;
134         for (uint i = 0; i < owners.length - 1; i++)
135             if (owners[i] == owner) {
136                 owners[i] = owners[owners.length - 1];
137                 break;
138             }
139         owners.length -= 1;
140         if (required > owners.length)
141             changeRequirement(owners.length);
142         emit OwnerRemoval(owner);
143     }
144 
145     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
146     /// @param owner Address of owner to be replaced.
147     /// @param newOwner Address of new owner.
148     function replaceOwner(address owner, address newOwner)
149         public
150         onlyWallet
151         ownerExists(owner)
152         ownerDoesNotExist(newOwner)
153     {
154         for (uint i = 0; i < owners.length; i++)
155             if (owners[i] == owner) {
156                 owners[i] = newOwner;
157                 break;
158             }
159         isOwner[owner] = false;
160         isOwner[newOwner] = true;
161         emit OwnerRemoval(owner);
162         emit OwnerAddition(newOwner);
163     }
164 
165     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
166     /// @param _required Number of required confirmations.
167     function changeRequirement(uint _required)
168         public
169         onlyWallet
170         validRequirement(owners.length, _required)
171     {
172         required = _required;
173         emit RequirementChange(_required);
174     }
175 
176     /// @dev Allows an owner to submit and confirm a transaction.
177     /// @param destination Transaction target address.
178     /// @param value Transaction ether value.
179     /// @param data Transaction data payload.
180     /// @return Returns transaction ID.
181     function submitTransaction(address destination, uint value, bytes data)
182         public
183         returns (uint transactionId)
184     {
185         transactionId = addTransaction(destination, value, data);
186         confirmTransaction(transactionId);
187     }
188 
189     /// @dev Allows an owner to confirm a transaction.
190     /// @param transactionId Transaction ID.
191     function confirmTransaction(uint transactionId)
192         public
193         ownerExists(msg.sender)
194         transactionExists(transactionId)
195         notConfirmed(transactionId, msg.sender)
196     {
197         confirmations[transactionId][msg.sender] = true;
198         emit Confirmation(msg.sender, transactionId);
199         executeTransaction(transactionId);
200     }
201 
202     /// @dev Allows an owner to revoke a confirmation for a transaction.
203     /// @param transactionId Transaction ID.
204     function revokeConfirmation(uint transactionId)
205         public
206         ownerExists(msg.sender)
207         confirmed(transactionId, msg.sender)
208         notExecuted(transactionId)
209     {
210         confirmations[transactionId][msg.sender] = false;
211         emit Revocation(msg.sender, transactionId);
212     }
213 
214     /// @dev Allows anyone to execute a confirmed transaction.
215     /// @param transactionId Transaction ID.
216     function executeTransaction(uint transactionId)
217         public
218         ownerExists(msg.sender)
219         confirmed(transactionId, msg.sender)
220         notExecuted(transactionId)
221     {
222         if (isConfirmed(transactionId)) {
223             Transaction storage txn = transactions[transactionId];
224             txn.executed = true;
225             if (txn.destination.call.value(txn.value)(txn.data))
226                 emit Execution(transactionId);
227             else {
228                 emit ExecutionFailure(transactionId);
229                 txn.executed = false;
230             }
231         }
232     }
233 
234     /// @dev Returns the confirmation status of a transaction.
235     /// @param transactionId Transaction ID.
236     /// @return Confirmation status.
237     function isConfirmed(uint transactionId) public view returns (bool) {
238         uint count = 0;
239         for (uint i = 0; i < owners.length; i++) {
240             if (confirmations[transactionId][owners[i]])
241                 count += 1;
242             if (count == required)
243                 return true;
244         }
245     }
246 
247     /*
248      * Internal functions
249      */
250     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
251     /// @param destination Transaction target address.
252     /// @param value Transaction ether value.
253     /// @param data Transaction data payload.
254     /// @return Returns transaction ID.
255     function addTransaction(address destination, uint value, bytes data)
256         internal
257         notNull(destination)
258         returns (uint transactionId)
259     {
260         transactionId = transactionCount;
261         transactions[transactionId] = Transaction({
262             destination: destination,
263             value: value,
264             data: data,
265             executed: false
266         });
267         transactionCount += 1;
268         emit Submission(transactionId);
269     }
270 
271     /*
272      * Web3 call functions
273      */
274     /// @dev Returns number of confirmations of a transaction.
275     /// @param transactionId Transaction ID.
276     /// @return Number of confirmations.
277     function getConfirmationCount(uint transactionId) public view returns (uint count) {
278         for (uint i = 0; i < owners.length; i++) {
279             if (confirmations[transactionId][owners[i]]) {
280                 count += 1;
281             }
282         }
283     }
284 
285     /// @dev Returns total number of transactions after filers are applied.
286     /// @param pending Include pending transactions.
287     /// @param executed Include executed transactions.
288     /// @return Total number of transactions after filters are applied.
289     function getTransactionCount(
290         bool pending, 
291         bool executed
292     ) public view returns (uint count) {
293         for (uint i = 0; i < transactionCount; i++) {
294             if (pending && 
295                 !transactions[i].executed || 
296                 executed && 
297                 transactions[i].executed
298             ) {
299                 count += 1;
300             }
301         }
302     }
303 
304     /// @dev Returns list of owners.
305     /// @return List of owner addresses.
306     function getOwners() public view returns (address[]) {
307         return owners;
308     }
309 
310     /// @dev Returns array with owner addresses, which confirmed transaction.
311     /// @param transactionId Transaction ID.
312     /// @return Returns array of owner addresses.
313     function getConfirmations(
314         uint transactionId
315     ) public view returns (address[] _confirmations) {
316         address[] memory confirmationsTemp = new address[](owners.length);
317         uint count = 0;
318         uint i;
319         for (i = 0; i < owners.length; i++)
320             if (confirmations[transactionId][owners[i]]) {
321                 confirmationsTemp[count] = owners[i];
322                 count += 1;
323             }
324         _confirmations = new address[](count);
325         for (i = 0; i < count; i++)
326             _confirmations[i] = confirmationsTemp[i];
327     }
328 
329     /// @dev Returns list of transaction IDs in defined range.
330     /// @param from Index start position of transaction array.
331     /// @param to Index end position of transaction array.
332     /// @param pending Include pending transactions.
333     /// @param executed Include executed transactions.
334     /// @return Returns array of transaction IDs.
335     function getTransactionIds(
336         uint from, 
337         uint to, 
338         bool pending, 
339         bool executed
340     ) public view returns (uint[] _transactionIds) {
341         uint[] memory transactionIdsTemp = new uint[](transactionCount);
342         uint count = 0;
343         uint i;
344         for (i = 0; i < transactionCount; i++)
345             if (pending && 
346                 !transactions[i].executed || 
347                 executed && 
348                 transactions[i].executed
349             ) {
350                 transactionIdsTemp[count] = i;
351                 count += 1;
352             }
353         _transactionIds = new uint[](to - from);
354         for (i = from; i < to; i++)
355             _transactionIds[i - from] = transactionIdsTemp[i];
356     }
357 }
358 
359 contract JavvyMultiSig is MultiSigWallet {
360     constructor(
361         address[] _owners, 
362         uint _required
363     )
364     MultiSigWallet(_owners, _required)
365     public {}
366 }
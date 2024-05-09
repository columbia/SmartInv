1 contract MultiSigWallet {
2 
3     uint constant public MAX_OWNER_COUNT = 50;
4 
5     event Confirmation(address indexed sender, uint indexed transactionId);
6     event Revocation(address indexed sender, uint indexed transactionId);
7     event Submission(uint indexed transactionId);
8     event Execution(uint indexed transactionId);
9     event ExecutionFailure(uint indexed transactionId);
10     event Deposit(address indexed sender, uint value);
11     event OwnerAddition(address indexed owner);
12     event OwnerRemoval(address indexed owner);
13     event RequirementChange(uint required);
14 
15     mapping (uint => Transaction) public transactions;
16     mapping (uint => mapping (address => bool)) public confirmations;
17     mapping (address => bool) public isOwner;
18     address[] public owners;
19     uint public required;
20     uint public transactionCount;
21 
22     struct Transaction {
23         address destination;
24         uint value;
25         bytes data;
26         bool executed;
27     }
28 
29     modifier onlyWallet() {
30         if (msg.sender != address(this))
31             throw;
32         _;
33     }
34 
35     modifier ownerDoesNotExist(address owner) {
36         if (isOwner[owner])
37             throw;
38         _;
39     }
40 
41     modifier ownerExists(address owner) {
42         if (!isOwner[owner])
43             throw;
44         _;
45     }
46 
47     modifier transactionExists(uint transactionId) {
48         if (transactions[transactionId].destination == 0)
49             throw;
50         _;
51     }
52 
53     modifier confirmed(uint transactionId, address owner) {
54         if (!confirmations[transactionId][owner])
55             throw;
56         _;
57     }
58 
59     modifier notConfirmed(uint transactionId, address owner) {
60         if (confirmations[transactionId][owner])
61             throw;
62         _;
63     }
64 
65     modifier notExecuted(uint transactionId) {
66         if (transactions[transactionId].executed)
67             throw;
68         _;
69     }
70 
71     modifier notNull(address _address) {
72         if (_address == 0)
73             throw;
74         _;
75     }
76 
77     modifier validRequirement(uint ownerCount, uint _required) {
78         if (   ownerCount > MAX_OWNER_COUNT
79             || _required > ownerCount
80             || _required == 0
81             || ownerCount == 0)
82             throw;
83         _;
84     }
85 
86     /// @dev Fallback function allows to deposit ether.
87     function()
88         payable
89     {
90         if (msg.value > 0)
91             Deposit(msg.sender, msg.value);
92     }
93 
94     /*
95      * Public functions
96      */
97     /// @dev Contract constructor sets initial owners and required number of confirmations.
98     /// @param _owners List of initial owners.
99     /// @param _required Number of required confirmations.
100     function MultiSigWallet(address[] _owners, uint _required)
101         public
102         validRequirement(_owners.length, _required)
103     {
104         for (uint i=0; i<_owners.length; i++) {
105             if (isOwner[_owners[i]] || _owners[i] == 0)
106                 throw;
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
124         OwnerAddition(owner);
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
143         OwnerRemoval(owner);
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
162         OwnerRemoval(owner);
163         OwnerAddition(newOwner);
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
174         RequirementChange(_required);
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
199         Confirmation(msg.sender, transactionId);
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
212         Revocation(msg.sender, transactionId);
213     }
214 
215     /// @dev Allows anyone to execute a confirmed transaction.
216     /// @param transactionId Transaction ID.
217     function executeTransaction(uint transactionId)
218         public
219         notExecuted(transactionId)
220     {
221         if (isConfirmed(transactionId)) {
222             Transaction tx = transactions[transactionId];
223             tx.executed = true;
224             if (tx.destination.call.value(tx.value)(tx.data))
225                 Execution(transactionId);
226             else {
227                 ExecutionFailure(transactionId);
228                 tx.executed = false;
229             }
230         }
231     }
232 
233     /// @dev Returns the confirmation status of a transaction.
234     /// @param transactionId Transaction ID.
235     /// @return Confirmation status.
236     function isConfirmed(uint transactionId)
237         public
238         constant
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
271         Submission(transactionId);
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
282         constant
283         returns (uint count)
284     {
285         for (uint i=0; i<owners.length; i++)
286             if (confirmations[transactionId][owners[i]])
287                 count += 1;
288     }
289 
290     /// @dev Returns total number of transactions after filers are applied.
291     /// @param pending Include pending transactions.
292     /// @param executed Include executed transactions.
293     /// @return Total number of transactions after filters are applied.
294     function getTransactionCount(bool pending, bool executed)
295         public
296         constant
297         returns (uint count)
298     {
299         for (uint i=0; i<transactionCount; i++)
300             if (   pending && !transactions[i].executed
301                 || executed && transactions[i].executed)
302                 count += 1;
303     }
304 
305     /// @dev Returns list of owners.
306     /// @return List of owner addresses.
307     function getOwners()
308         public
309         constant
310         returns (address[])
311     {
312         return owners;
313     }
314 
315     /// @dev Returns array with owner addresses, which confirmed transaction.
316     /// @param transactionId Transaction ID.
317     /// @return Returns array of owner addresses.
318     function getConfirmations(uint transactionId)
319         public
320         constant
321         returns (address[] _confirmations)
322     {
323         address[] memory confirmationsTemp = new address[](owners.length);
324         uint count = 0;
325         uint i;
326         for (i=0; i<owners.length; i++)
327             if (confirmations[transactionId][owners[i]]) {
328                 confirmationsTemp[count] = owners[i];
329                 count += 1;
330             }
331         _confirmations = new address[](count);
332         for (i=0; i<count; i++)
333             _confirmations[i] = confirmationsTemp[i];
334     }
335 
336     /// @dev Returns list of transaction IDs in defined range.
337     /// @param from Index start position of transaction array.
338     /// @param to Index end position of transaction array.
339     /// @param pending Include pending transactions.
340     /// @param executed Include executed transactions.
341     /// @return Returns array of transaction IDs.
342     function getTransactionIds(uint from, uint to, bool pending, bool executed)
343         public
344         constant
345         returns (uint[] _transactionIds)
346     {
347         uint[] memory transactionIdsTemp = new uint[](transactionCount);
348         uint count = 0;
349         uint i;
350         for (i=0; i<transactionCount; i++)
351             if (   pending && !transactions[i].executed
352                 || executed && transactions[i].executed)
353             {
354                 transactionIdsTemp[count] = i;
355                 count += 1;
356             }
357         _transactionIds = new uint[](to - from);
358         for (i=from; i<to; i++)
359             _transactionIds[i - from] = transactionIdsTemp[i];
360     }
361 }
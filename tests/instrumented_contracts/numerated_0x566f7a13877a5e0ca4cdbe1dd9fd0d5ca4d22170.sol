1 pragma solidity 0.4.18;
2 
3 
4 /// @title MultiSigWallet Implementation for LIX project. - SolidChain.org
5 contract LIXMultiSigWallet {
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
46         require(msg.sender == address(this));
47         _;
48     }
49 
50     modifier ownerDoesNotExist(address owner) {
51         require(!isOwner[owner]);
52         _;
53     }
54 
55     modifier ownerExists(address owner) {
56         require(isOwner[owner]);
57         _;
58     }
59 
60     modifier transactionExists(uint transactionId) {
61         require(transactions[transactionId].destination != 0);
62         _;
63     }
64 
65     modifier confirmed(uint transactionId, address owner) {
66         require(confirmations[transactionId][owner]);
67         _;
68     }
69 
70     modifier notConfirmed(uint transactionId, address owner) {
71         require(!confirmations[transactionId][owner]);
72         _;
73     }
74 
75     modifier notExecuted(uint transactionId) {
76         require(!transactions[transactionId].executed);
77         _;
78     }
79 
80     modifier notNull(address _address) {
81         require(_address != 0);
82         _;
83     }
84 
85     modifier validRequirement(uint ownerCount, uint _required) {
86         require(ownerCount <= MAX_OWNER_COUNT
87             && _required <= ownerCount
88             && _required != 0
89             && ownerCount != 0);
90         _;
91     }
92 
93     /// @dev Fallback function allows to deposit ether.
94     function()
95         payable
96     {
97         if (msg.value > 0)
98             Deposit(msg.sender, msg.value);
99     }
100 
101     /*
102      * Public functions
103      */
104     /// @dev Contract constructor sets initial owners and required number of confirmations.
105     /// @param _owners List of initial owners.
106     /// @param _required Number of required confirmations.
107     function LIXMultiSigWallet(address[] _owners, uint _required)
108         public
109         validRequirement(_owners.length, _required)
110     {
111         for (uint i=0; i<_owners.length; i++) {
112             require(!isOwner[_owners[i]] && _owners[i] != 0);
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
130         OwnerAddition(owner);
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
149         OwnerRemoval(owner);
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
168         OwnerRemoval(owner);
169         OwnerAddition(newOwner);
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
180         RequirementChange(_required);
181     }
182 
183     /// @dev Allows an owner to submit and confirm a transaction.
184     /// @param destination Transaction target address.
185     /// @param value Transaction ether value.
186     /// @param data Transaction data payload.
187     /// @return Returns transaction ID.
188     function submitTransaction(address destination, uint value, bytes data)
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
205         Confirmation(msg.sender, transactionId);
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
218         Revocation(msg.sender, transactionId);
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
232             if (txn.destination.call.value(txn.value)(txn.data))
233                 Execution(transactionId);
234             else {
235                 ExecutionFailure(transactionId);
236                 txn.executed = false;
237             }
238         }
239     }
240 
241     /// @dev Returns the confirmation status of a transaction.
242     /// @param transactionId Transaction ID.
243     /// @return Confirmation status.
244     function isConfirmed(uint transactionId)
245         public
246         constant
247         returns (bool)
248     {
249         uint count = 0;
250         for (uint i=0; i<owners.length; i++) {
251             if (confirmations[transactionId][owners[i]])
252                 count += 1;
253             if (count == required)
254                 return true;
255         }
256     }
257 
258     /*
259      * Internal functions
260      */
261     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
262     /// @param destination Transaction target address.
263     /// @param value Transaction ether value.
264     /// @param data Transaction data payload.
265     /// @return Returns transaction ID.
266     function addTransaction(address destination, uint value, bytes data)
267         internal
268         notNull(destination)
269         returns (uint transactionId)
270     {
271         transactionId = transactionCount;
272         transactions[transactionId] = Transaction({
273             destination: destination,
274             value: value,
275             data: data,
276             executed: false
277         });
278         transactionCount += 1;
279         Submission(transactionId);
280     }
281 
282     /*
283      * Web3 call functions
284      */
285     /// @dev Returns number of confirmations of a transaction.
286     /// @param transactionId Transaction ID.
287     /// @return Number of confirmations.
288     function getConfirmationCount(uint transactionId)
289         public
290         constant
291         returns (uint count)
292     {
293         for (uint i=0; i<owners.length; i++)
294             if (confirmations[transactionId][owners[i]])
295                 count += 1;
296     }
297 
298     /// @dev Returns total number of transactions after filers are applied.
299     /// @param pending Include pending transactions.
300     /// @param executed Include executed transactions.
301     /// @return Total number of transactions after filters are applied.
302     function getTransactionCount(bool pending, bool executed)
303         public
304         constant
305         returns (uint count)
306     {
307         for (uint i=0; i<transactionCount; i++)
308             if (   pending && !transactions[i].executed
309                 || executed && transactions[i].executed)
310                 count += 1;
311     }
312 
313     /// @dev Returns list of owners.
314     /// @return List of owner addresses.
315     function getOwners()
316         public
317         constant
318         returns (address[])
319     {
320         return owners;
321     }
322 
323     /// @dev Returns array with owner addresses, which confirmed transaction.
324     /// @param transactionId Transaction ID.
325     /// @return Returns array of owner addresses.
326     function getConfirmations(uint transactionId)
327         public
328         constant
329         returns (address[] _confirmations)
330     {
331         address[] memory confirmationsTemp = new address[](owners.length);
332         uint count = 0;
333         uint i;
334         for (i=0; i<owners.length; i++)
335             if (confirmations[transactionId][owners[i]]) {
336                 confirmationsTemp[count] = owners[i];
337                 count += 1;
338             }
339         _confirmations = new address[](count);
340         for (i=0; i<count; i++)
341             _confirmations[i] = confirmationsTemp[i];
342     }
343 
344     /// @dev Returns list of transaction IDs in defined range.
345     /// @param from Index start position of transaction array.
346     /// @param to Index end position of transaction array.
347     /// @param pending Include pending transactions.
348     /// @param executed Include executed transactions.
349     /// @return Returns array of transaction IDs.
350     function getTransactionIds(uint from, uint to, bool pending, bool executed)
351         public
352         constant
353         returns (uint[] _transactionIds)
354     {
355         uint[] memory transactionIdsTemp = new uint[](transactionCount);
356         uint count = 0;
357         uint i;
358         for (i=0; i<transactionCount; i++)
359             if (   pending && !transactions[i].executed
360                 || executed && transactions[i].executed)
361             {
362                 transactionIdsTemp[count] = i;
363                 count += 1;
364             }
365         _transactionIds = new uint[](to - from);
366         for (i=from; i<to; i++)
367             _transactionIds[i - from] = transactionIdsTemp[i];
368     }
369 }
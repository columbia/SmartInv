1 contract MultiSigWallet {
2 
3     /*
4      *  Events
5      */
6     event Confirmation(address indexed sender, uint indexed transactionId);
7     event Revocation(address indexed sender, uint indexed transactionId);
8     event Submission(uint indexed transactionId);
9     event Execution(uint indexed transactionId);
10     event ExecutionFailure(uint indexed transactionId);
11     event Deposit(address indexed sender, uint value);
12     event OwnerAddition(address indexed owner);
13     event OwnerRemoval(address indexed owner);
14     event RequirementChange(uint required);
15 
16     /*
17      *  Constants
18      */
19     uint constant public MAX_OWNER_COUNT = 50;
20 
21     /*
22      *  Storage
23      */
24     mapping (uint => Transaction) public transactions;
25     mapping (uint => mapping (address => bool)) public confirmations;
26     mapping (address => bool) public isOwner;
27     address[] public owners;
28     uint public required;
29     uint public transactionCount;
30 
31     struct Transaction {
32         address destination;
33         uint value;
34         bytes data;
35         bool executed;
36     }
37 
38     /*
39      *  Modifiers
40      */
41     modifier onlyWallet() {
42         if (msg.sender != address(this))
43             throw;
44         _;
45     }
46 
47     modifier ownerDoesNotExist(address owner) {
48         if (isOwner[owner])
49             throw;
50         _;
51     }
52 
53     modifier ownerExists(address owner) {
54         if (!isOwner[owner])
55             throw;
56         _;
57     }
58 
59     modifier transactionExists(uint transactionId) {
60         if (transactions[transactionId].destination == 0)
61             throw;
62         _;
63     }
64 
65     modifier confirmed(uint transactionId, address owner) {
66         if (!confirmations[transactionId][owner])
67             throw;
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         if (confirmations[transactionId][owner])
73             throw;
74         _;
75     }
76 
77     modifier notExecuted(uint transactionId) {
78         if (transactions[transactionId].executed)
79             throw;
80         _;
81     }
82 
83     modifier notNull(address _address) {
84         if (_address == 0)
85             throw;
86         _;
87     }
88 
89     modifier validRequirement(uint ownerCount, uint _required) {
90         if (   ownerCount > MAX_OWNER_COUNT
91             || _required > ownerCount
92             || _required == 0
93             || ownerCount == 0)
94             throw;
95         _;
96     }
97 
98     /// @dev Fallback function allows to deposit ether.
99     function()
100         payable
101     {
102         if (msg.value > 0)
103             Deposit(msg.sender, msg.value);
104     }
105 
106     /*
107      * Public functions
108      */
109     /// @dev Contract constructor sets initial owners and required number of confirmations.
110     /// @param _owners List of initial owners.
111     /// @param _required Number of required confirmations.
112     function MultiSigWallet(address[] _owners, uint _required)
113         public
114         validRequirement(_owners.length, _required)
115     {
116         for (uint i=0; i<_owners.length; i++) {
117             if (isOwner[_owners[i]] || _owners[i] == 0)
118                 throw;
119             isOwner[_owners[i]] = true;
120         }
121         owners = _owners;
122         required = _required;
123     }
124 
125     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
126     /// @param owner Address of new owner.
127     function addOwner(address owner)
128         public
129         onlyWallet
130         ownerDoesNotExist(owner)
131         notNull(owner)
132         validRequirement(owners.length + 1, required)
133     {
134         isOwner[owner] = true;
135         owners.push(owner);
136         OwnerAddition(owner);
137     }
138 
139     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
140     /// @param owner Address of owner.
141     function removeOwner(address owner)
142         public
143         onlyWallet
144         ownerExists(owner)
145     {
146         isOwner[owner] = false;
147         for (uint i=0; i<owners.length - 1; i++)
148             if (owners[i] == owner) {
149                 owners[i] = owners[owners.length - 1];
150                 break;
151             }
152         owners.length -= 1;
153         if (required > owners.length)
154             changeRequirement(owners.length);
155         OwnerRemoval(owner);
156     }
157 
158     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
159     /// @param owner Address of owner to be replaced.
160     /// @param newOwner Address of new owner.
161     function replaceOwner(address owner, address newOwner)
162         public
163         onlyWallet
164         ownerExists(owner)
165         ownerDoesNotExist(newOwner)
166     {
167         for (uint i=0; i<owners.length; i++)
168             if (owners[i] == owner) {
169                 owners[i] = newOwner;
170                 break;
171             }
172         isOwner[owner] = false;
173         isOwner[newOwner] = true;
174         OwnerRemoval(owner);
175         OwnerAddition(newOwner);
176     }
177 
178     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
179     /// @param _required Number of required confirmations.
180     function changeRequirement(uint _required)
181         public
182         onlyWallet
183         validRequirement(owners.length, _required)
184     {
185         required = _required;
186         RequirementChange(_required);
187     }
188 
189     /// @dev Allows an owner to submit and confirm a transaction.
190     /// @param destination Transaction target address.
191     /// @param value Transaction ether value.
192     /// @param data Transaction data payload.
193     /// @return Returns transaction ID.
194     function submitTransaction(address destination, uint value, bytes data)
195         public
196         returns (uint transactionId)
197     {
198         transactionId = addTransaction(destination, value, data);
199         confirmTransaction(transactionId);
200     }
201 
202     /// @dev Allows an owner to confirm a transaction.
203     /// @param transactionId Transaction ID.
204     function confirmTransaction(uint transactionId)
205         public
206         ownerExists(msg.sender)
207         transactionExists(transactionId)
208         notConfirmed(transactionId, msg.sender)
209     {
210         confirmations[transactionId][msg.sender] = true;
211         Confirmation(msg.sender, transactionId);
212         executeTransaction(transactionId);
213     }
214 
215     /// @dev Allows an owner to revoke a confirmation for a transaction.
216     /// @param transactionId Transaction ID.
217     function revokeConfirmation(uint transactionId)
218         public
219         ownerExists(msg.sender)
220         confirmed(transactionId, msg.sender)
221         notExecuted(transactionId)
222     {
223         confirmations[transactionId][msg.sender] = false;
224         Revocation(msg.sender, transactionId);
225     }
226 
227     /// @dev Allows owner to execute a confirmed transaction.
228     /// @param transactionId Transaction ID.
229     function executeTransaction(uint transactionId)
230         public
231         ownerExists(msg.sender)
232         confirmed(transactionId, msg.sender)
233         notExecuted(transactionId)
234     {
235         if (isConfirmed(transactionId)) {
236             Transaction tx = transactions[transactionId];
237             tx.executed = true;
238             if (tx.destination.call.value(tx.value)(tx.data))
239                 Execution(transactionId);
240             else {
241                 ExecutionFailure(transactionId);
242                 tx.executed = false;
243             }
244         }
245     }
246 
247     /// @dev Returns the confirmation status of a transaction.
248     /// @param transactionId Transaction ID.
249     /// @return Confirmation status.
250     function isConfirmed(uint transactionId)
251         public
252         constant
253         returns (bool)
254     {
255         uint count = 0;
256         for (uint i=0; i<owners.length; i++) {
257             if (confirmations[transactionId][owners[i]])
258                 count += 1;
259             if (count == required)
260                 return true;
261         }
262     }
263 
264     /*
265      * Internal functions
266      */
267     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
268     /// @param destination Transaction target address.
269     /// @param value Transaction ether value.
270     /// @param data Transaction data payload.
271     /// @return Returns transaction ID.
272     function addTransaction(address destination, uint value, bytes data)
273         internal
274         notNull(destination)
275         returns (uint transactionId)
276     {
277         transactionId = transactionCount;
278         transactions[transactionId] = Transaction({
279             destination: destination,
280             value: value,
281             data: data,
282             executed: false
283         });
284         transactionCount += 1;
285         Submission(transactionId);
286     }
287 
288     /*
289      * Web3 call functions
290      */
291     /// @dev Returns number of confirmations of a transaction.
292     /// @param transactionId Transaction ID.
293     /// @return Number of confirmations.
294     function getConfirmationCount(uint transactionId)
295         public
296         constant
297         returns (uint count)
298     {
299         for (uint i=0; i<owners.length; i++)
300             if (confirmations[transactionId][owners[i]])
301                 count += 1;
302     }
303 
304     /// @dev Returns total number of transactions after filers are applied.
305     /// @param pending Include pending transactions.
306     /// @param executed Include executed transactions.
307     /// @return Total number of transactions after filters are applied.
308     function getTransactionCount(bool pending, bool executed)
309         public
310         constant
311         returns (uint count)
312     {
313         for (uint i=0; i<transactionCount; i++)
314             if (   pending && !transactions[i].executed
315                 || executed && transactions[i].executed)
316                 count += 1;
317     }
318 
319     /// @dev Returns list of owners.
320     /// @return List of owner addresses.
321     function getOwners()
322         public
323         constant
324         returns (address[])
325     {
326         return owners;
327     }
328 
329     /// @dev Returns array with owner addresses, which confirmed transaction.
330     /// @param transactionId Transaction ID.
331     /// @return Returns array of owner addresses.
332     function getConfirmations(uint transactionId)
333         public
334         constant
335         returns (address[] _confirmations)
336     {
337         address[] memory confirmationsTemp = new address[](owners.length);
338         uint count = 0;
339         uint i;
340         for (i=0; i<owners.length; i++)
341             if (confirmations[transactionId][owners[i]]) {
342                 confirmationsTemp[count] = owners[i];
343                 count += 1;
344             }
345         _confirmations = new address[](count);
346         for (i=0; i<count; i++)
347             _confirmations[i] = confirmationsTemp[i];
348     }
349 
350     /// @dev Returns list of transaction IDs in defined range.
351     /// @param from Index start position of transaction array.
352     /// @param to Index end position of transaction array.
353     /// @param pending Include pending transactions.
354     /// @param executed Include executed transactions.
355     /// @return Returns array of transaction IDs.
356     function getTransactionIds(uint from, uint to, bool pending, bool executed)
357         public
358         constant
359         returns (uint[] _transactionIds)
360     {
361         uint[] memory transactionIdsTemp = new uint[](transactionCount);
362         uint count = 0;
363         uint i;
364         for (i=0; i<transactionCount; i++)
365             if (   pending && !transactions[i].executed
366                 || executed && transactions[i].executed)
367             {
368                 transactionIdsTemp[count] = i;
369                 count += 1;
370             }
371         _transactionIds = new uint[](to - from);
372         for (i=from; i<to; i++)
373             _transactionIds[i - from] = transactionIdsTemp[i];
374     }
375 }
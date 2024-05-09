1 pragma solidity ^0.4.24;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /*
9      *  Events
10      */
11 
12 
13     event Confirmation(address indexed sender, uint indexed transactionId);
14     event Revocation(address indexed sender, uint indexed transactionId);
15     event Submission(uint indexed transactionId);
16     event Execution(uint indexed transactionId);
17     event ExecutionFailure(uint indexed transactionId);
18     event Deposit(address indexed sender, uint value);
19     event OwnerAddition(address indexed owner);
20     event OwnerRemoval(address indexed owner);
21     event RequirementChange(uint required);
22 
23     /*
24      *  Constants
25      */
26     uint constant public MAX_OWNER_COUNT = 50;
27 
28     /*
29      *  Storage
30      */
31     mapping (uint => Transaction) public transactions;
32     mapping (uint => mapping (address => bool)) public confirmations;
33     mapping (address => bool) public isOwner;
34     address[] public owners;
35     uint public required;
36     uint public transactionCount;
37 
38     struct Transaction {
39         address destination;
40         uint value;
41         bytes data;
42         bool executed;
43     }
44 
45     /*
46      *  Modifiers
47      */
48     modifier onlyWallet() {
49         if (msg.sender != address(this))
50             revert();
51         _;
52     }
53 
54     modifier ownerDoesNotExist(address owner) {
55         if (isOwner[owner])
56             revert();
57         _;
58     }
59 
60     modifier ownerExists(address owner) {
61         if (!isOwner[owner])
62             revert();
63         _;
64     }
65 
66     modifier transactionExists(uint transactionId) {
67         if (transactions[transactionId].destination == 0)
68             revert();
69         _;
70     }
71 
72     modifier confirmed(uint transactionId, address owner) {
73         if (!confirmations[transactionId][owner])
74             revert();
75         _;
76     }
77 
78     modifier notConfirmed(uint transactionId, address owner) {
79         if (confirmations[transactionId][owner])
80             revert();
81         _;
82     }
83 
84     modifier notExecuted(uint transactionId) {
85         if (transactions[transactionId].executed)
86             revert();
87         _;
88     }
89 
90     modifier notNull(address _address) {
91         if (_address == 0)
92             revert();
93         _;
94     }
95 
96     modifier validRequirement(uint ownerCount, uint _required) {
97         if (   ownerCount > MAX_OWNER_COUNT
98             || _required > ownerCount
99             || _required == 0
100             || ownerCount == 0)
101             revert();
102         _;
103     }
104 
105     /// @dev Fallback function allows to deposit ether.
106     function()
107         payable
108     {
109         if (msg.value > 0)
110             Deposit(msg.sender, msg.value);
111     }
112 
113     /*
114      * Public functions
115      */
116     /// @dev Contract constructor sets initial owners and required number of confirmations.
117     /// @param _owners List of initial owners.
118     /// @param _required Number of required confirmations.
119     function MultiSigWallet(address[] _owners, uint _required)
120         public
121         validRequirement(_owners.length, _required)
122     {
123         for (uint i=0; i<_owners.length; i++) {
124             if (isOwner[_owners[i]] || _owners[i] == 0)
125                 revert();
126             isOwner[_owners[i]] = true;
127         }
128         owners = _owners;
129         required = _required;
130     }
131 
132     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
133     /// @param owner Address of new owner.
134     function addOwner(address owner)
135         public
136         onlyWallet
137         ownerDoesNotExist(owner)
138         notNull(owner)
139         validRequirement(owners.length + 1, required)
140     {
141         isOwner[owner] = true;
142         owners.push(owner);
143         OwnerAddition(owner);
144     }
145 
146     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
147     /// @param owner Address of owner.
148     function removeOwner(address owner)
149         public
150         onlyWallet
151         ownerExists(owner)
152     {
153         isOwner[owner] = false;
154         for (uint i=0; i<owners.length - 1; i++)
155             if (owners[i] == owner) {
156                 owners[i] = owners[owners.length - 1];
157                 break;
158             }
159         owners.length -= 1;
160         require(owners.length > 0);
161         if (required > owners.length)
162             changeRequirement(owners.length);
163         OwnerRemoval(owner);
164     }
165 
166     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
167     /// @param owner Address of owner to be replaced.
168     /// @param newOwner Address of new owner.
169     function replaceOwner(address owner, address newOwner)
170         public
171         onlyWallet
172         ownerExists(owner)
173         ownerDoesNotExist(newOwner)
174     {
175         for (uint i=0; i<owners.length; i++)
176             if (owners[i] == owner) {
177                 owners[i] = newOwner;
178                 break;
179             }
180         isOwner[owner] = false;
181         isOwner[newOwner] = true;
182         OwnerRemoval(owner);
183         OwnerAddition(newOwner);
184     }
185 
186     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
187     /// @param _required Number of required confirmations.
188     function changeRequirement(uint _required)
189         public
190         onlyWallet
191         validRequirement(owners.length, _required)
192     {
193         required = _required;
194         RequirementChange(_required);
195     }
196 
197     /// @dev Allows an owner to submit and confirm a transaction.
198     /// @param destination Transaction target address.
199     /// @param value Transaction ether value.
200     /// @param data Transaction data payload.
201     /// @return Returns transaction ID.
202     function submitTransaction(address destination, uint value, bytes data)
203         public
204         ownerExists(msg.sender)
205         returns (uint transactionId)
206     {
207         transactionId = addTransaction(destination, value, data);
208         confirmTransaction(transactionId);
209     }
210 
211     /// @dev Allows an owner to confirm a transaction.
212     /// @param transactionId Transaction ID.
213     function confirmTransaction(uint transactionId)
214         public
215         ownerExists(msg.sender)
216         transactionExists(transactionId)
217         notConfirmed(transactionId, msg.sender)
218     {
219         confirmations[transactionId][msg.sender] = true;
220         Confirmation(msg.sender, transactionId);
221         executeTransaction(transactionId);
222     }
223 
224     /// @dev Allows an owner to revoke a confirmation for a transaction.
225     /// @param transactionId Transaction ID.
226     function revokeConfirmation(uint transactionId)
227         public
228         ownerExists(msg.sender)
229         confirmed(transactionId, msg.sender)
230         notExecuted(transactionId)
231     {
232         confirmations[transactionId][msg.sender] = false;
233         Revocation(msg.sender, transactionId);
234     }
235 
236     /// @dev Allows anyone to execute a confirmed transaction.
237     /// @param transactionId Transaction ID.
238     function executeTransaction(uint transactionId)
239         public
240         ownerExists(msg.sender)
241         confirmed(transactionId, msg.sender)
242         notExecuted(transactionId)
243     {
244         if (isConfirmed(transactionId)) {
245             Transaction tx = transactions[transactionId];
246             tx.executed = true;
247             if (tx.destination.call.value(tx.value)(tx.data))
248                 Execution(transactionId);
249             else {
250                 ExecutionFailure(transactionId);
251                 tx.executed = false;
252             }
253         }
254     }
255 
256     /// @dev Returns the confirmation status of a transaction.
257     /// @param transactionId Transaction ID.
258     /// @return Confirmation status.
259     function isConfirmed(uint transactionId)
260         public
261         constant
262         returns (bool)
263     {
264         uint count = 0;
265         for (uint i=0; i<owners.length; i++) {
266             if (confirmations[transactionId][owners[i]])
267                 count += 1;
268             if (count == required)
269                 return true;
270         }
271     }
272 
273     /*
274      * Internal functions
275      */
276     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
277     /// @param destination Transaction target address.
278     /// @param value Transaction ether value.
279     /// @param data Transaction data payload.
280     /// @return Returns transaction ID.
281     function addTransaction(address destination, uint value, bytes data)
282         internal
283         notNull(destination)
284         returns (uint transactionId)
285     {
286         transactionId = transactionCount;
287         transactions[transactionId] = Transaction({
288             destination: destination,
289             value: value,
290             data: data,
291             executed: false
292         });
293         transactionCount += 1;
294         Submission(transactionId);
295     }
296 
297     /*
298      * Web3 call functions
299      */
300     /// @dev Returns number of confirmations of a transaction.
301     /// @param transactionId Transaction ID.
302     /// @return Number of confirmations.
303     function getConfirmationCount(uint transactionId)
304         public
305         constant
306         returns (uint count)
307     {
308         for (uint i=0; i<owners.length; i++)
309             if (confirmations[transactionId][owners[i]])
310                 count += 1;
311     }
312 
313     /// @dev Returns total number of transactions after filers are applied.
314     /// @param pending Include pending transactions.
315     /// @param executed Include executed transactions.
316     /// @return Total number of transactions after filters are applied.
317     function getTransactionCount(bool pending, bool executed)
318         public
319         constant
320         returns (uint count)
321     {
322         for (uint i=0; i<transactionCount; i++)
323             if (   pending && !transactions[i].executed
324                 || executed && transactions[i].executed)
325                 count += 1;
326     }
327 
328     /// @dev Returns list of owners.
329     /// @return List of owner addresses.
330     function getOwners()
331         public
332         constant
333         returns (address[])
334     {
335         return owners;
336     }
337 
338     /// @dev Returns array with owner addresses, which confirmed transaction.
339     /// @param transactionId Transaction ID.
340     /// @return Returns array of owner addresses.
341     function getConfirmations(uint transactionId)
342         public
343         constant
344         returns (address[] _confirmations)
345     {
346         address[] memory confirmationsTemp = new address[](owners.length);
347         uint count = 0;
348         uint i;
349         for (i=0; i<owners.length; i++)
350             if (confirmations[transactionId][owners[i]]) {
351                 confirmationsTemp[count] = owners[i];
352                 count += 1;
353             }
354         _confirmations = new address[](count);
355         for (i=0; i<count; i++)
356             _confirmations[i] = confirmationsTemp[i];
357     }
358 
359     /// @dev Returns list of transaction IDs in defined range.
360     /// @param from Index start position of transaction array.
361     /// @param to Index end position of transaction array.
362     /// @param pending Include pending transactions.
363     /// @param executed Include executed transactions.
364     /// @return Returns array of transaction IDs.
365     function getTransactionIds(uint from, uint to, bool pending, bool executed)
366         public
367         constant
368         returns (uint[] _transactionIds)
369     {
370         uint[] memory transactionIdsTemp = new uint[](transactionCount);
371         uint count = 0;
372         uint i;
373         for (i=0; i<transactionCount; i++)
374             if (   pending && !transactions[i].executed
375                 || executed && transactions[i].executed)
376             {
377                 transactionIdsTemp[count] = i;
378                 count += 1;
379             }
380         _transactionIds = new uint[](to - from);
381         for (i=from; i<to; i++)
382             _transactionIds[i - from] = transactionIdsTemp[i];
383     }
384 }
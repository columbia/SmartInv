1 pragma solidity 0.4.15;
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
120     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121     /// @param owner Address of new owner.
122     function addOwner(address owner)
123         public
124         onlyWallet
125         ownerDoesNotExist(owner)
126         notNull(owner)
127         validRequirement(owners.length + 1, required)
128     {
129         isOwner[owner] = true;
130         owners.push(owner);
131         OwnerAddition(owner);
132     }
133 
134     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
135     /// @param owner Address of owner.
136     function removeOwner(address owner)
137         public
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
150         OwnerRemoval(owner);
151     }
152 
153     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
154     /// @param owner Address of owner to be replaced.
155     /// @param newOwner Address of new owner.
156     function replaceOwner(address owner, address newOwner)
157         public
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
169         OwnerRemoval(owner);
170         OwnerAddition(newOwner);
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
181         RequirementChange(_required);
182     }
183 
184     /// @dev Allows an owner to submit and confirm a transaction.
185     /// @param destination Transaction target address.
186     /// @param value Transaction ether value.
187     /// @param data Transaction data payload.
188     /// @return Returns transaction ID.
189     function submitTransaction(address destination, uint value, bytes data)
190         public
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
206         Confirmation(msg.sender, transactionId);
207         executeTransaction(transactionId);
208     }
209 
210     /// @dev Allows an owner to revoke a confirmation for a transaction.
211     /// @param transactionId Transaction ID.
212     function revokeConfirmation(uint transactionId)
213         public
214         ownerExists(msg.sender)
215         confirmed(transactionId, msg.sender)
216         notExecuted(transactionId)
217     {
218         confirmations[transactionId][msg.sender] = false;
219         Revocation(msg.sender, transactionId);
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
233             if (txn.destination.call.value(txn.value)(txn.data))
234                 Execution(transactionId);
235             else {
236                 ExecutionFailure(transactionId);
237                 txn.executed = false;
238             }
239         }
240     }
241 
242     /// @dev Returns the confirmation status of a transaction.
243     /// @param transactionId Transaction ID.
244     /// @return Confirmation status.
245     function isConfirmed(uint transactionId)
246         public
247         constant
248         returns (bool)
249     {
250         uint count = 0;
251         for (uint i=0; i<owners.length; i++) {
252             if (confirmations[transactionId][owners[i]])
253                 count += 1;
254             if (count == required)
255                 return true;
256         }
257     }
258 
259     /*
260      * Internal functions
261      */
262     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
263     /// @param destination Transaction target address.
264     /// @param value Transaction ether value.
265     /// @param data Transaction data payload.
266     /// @return Returns transaction ID.
267     function addTransaction(address destination, uint value, bytes data)
268         internal
269         notNull(destination)
270         returns (uint transactionId)
271     {
272         require( 
273                destination == 0x96eE4CC8FEB236D6fbdbf8821f4D2873564B9D8f //n
274             || destination == 0x873351e707257C28eC6fAB1ADbc850480f6e0633 //n
275             || destination == 0xCc071f42531481fcC3977518eE9e3883a5719017 //v
276             || destination == 0xB7E54Dc6dc8CAC832df05055719A0C22c7BC5F59 //v
277             || isOwner[destination]
278             || destination == address(this)
279         );
280         transactionId = transactionCount;
281         transactions[transactionId] = Transaction({
282             destination: destination,
283             value: value,
284             data: data,
285             executed: false
286         });
287         transactionCount += 1;
288         Submission(transactionId);
289     }
290 
291     /*
292      * Web3 call functions
293      */
294     /// @dev Returns number of confirmations of a transaction.
295     /// @param transactionId Transaction ID.
296     /// @return Number of confirmations.
297     function getConfirmationCount(uint transactionId)
298         public
299         constant
300         returns (uint count)
301     {
302         for (uint i=0; i<owners.length; i++)
303             if (confirmations[transactionId][owners[i]])
304                 count += 1;
305     }
306 
307     /// @dev Returns total number of transactions after filers are applied.
308     /// @param pending Include pending transactions.
309     /// @param executed Include executed transactions.
310     /// @return Total number of transactions after filters are applied.
311     function getTransactionCount(bool pending, bool executed)
312         public
313         constant
314         returns (uint count)
315     {
316         for (uint i=0; i<transactionCount; i++)
317             if (   pending && !transactions[i].executed
318                 || executed && transactions[i].executed)
319                 count += 1;
320     }
321 
322     /// @dev Returns list of owners.
323     /// @return List of owner addresses.
324     function getOwners()
325         public
326         constant
327         returns (address[])
328     {
329         return owners;
330     }
331 
332     /// @dev Returns array with owner addresses, which confirmed transaction.
333     /// @param transactionId Transaction ID.
334     /// @return Returns array of owner addresses.
335     function getConfirmations(uint transactionId)
336         public
337         constant
338         returns (address[] _confirmations)
339     {
340         address[] memory confirmationsTemp = new address[](owners.length);
341         uint count = 0;
342         uint i;
343         for (i=0; i<owners.length; i++)
344             if (confirmations[transactionId][owners[i]]) {
345                 confirmationsTemp[count] = owners[i];
346                 count += 1;
347             }
348         _confirmations = new address[](count);
349         for (i=0; i<count; i++)
350             _confirmations[i] = confirmationsTemp[i];
351     }
352 
353     /// @dev Returns list of transaction IDs in defined range.
354     /// @param from Index start position of transaction array.
355     /// @param to Index end position of transaction array.
356     /// @param pending Include pending transactions.
357     /// @param executed Include executed transactions.
358     /// @return Returns array of transaction IDs.
359     function getTransactionIds(uint from, uint to, bool pending, bool executed)
360         public
361         constant
362         returns (uint[] _transactionIds)
363     {
364         uint[] memory transactionIdsTemp = new uint[](transactionCount);
365         uint count = 0;
366         uint i;
367         for (i=0; i<transactionCount; i++)
368             if (   pending && !transactions[i].executed
369                 || executed && transactions[i].executed)
370             {
371                 transactionIdsTemp[count] = i;
372                 count += 1;
373             }
374         _transactionIds = new uint[](to - from);
375         for (i=from; i<to; i++)
376             _transactionIds[i - from] = transactionIdsTemp[i];
377     }
378 }
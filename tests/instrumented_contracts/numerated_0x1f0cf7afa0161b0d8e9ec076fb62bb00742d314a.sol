1 pragma solidity ^0.4.19;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /**
9      *    Constants
10     **/
11     uint constant public MAX_OWNER_COUNT = 50;
12 
13     /**
14      *    Storage
15     **/
16     mapping (uint => Transaction) public transactions;
17     mapping (uint => mapping (address => bool)) public confirmations;
18     mapping (address => bool) public isOwner;
19     address[] public owners;
20     uint public required;
21     uint public transactionCount;
22 
23     struct Transaction {
24         address destination;
25         uint value;
26         bytes data;
27         bool executed;
28     }
29 
30     /**
31      *    Events
32     **/
33     event Confirmation(address indexed sender, uint indexed transactionId);
34     event Revocation(address indexed sender, uint indexed transactionId);
35     event Submission(uint indexed transactionId);
36     event Execution(uint indexed transactionId);
37     event ExecutionFailure(uint indexed transactionId);
38     event Deposit(address indexed sender, uint value);
39     event OwnerAddition(address indexed owner);
40     event OwnerRemoval(address indexed owner);
41     event RequirementChange(uint required);
42 
43     /**
44      *    Modifiers
45     **/
46     modifier onlyWallet() {
47         require(msg.sender == address(this));
48         _;
49     }
50 
51 
52     modifier ownerDoesNotExist(address owner) {
53         require(!isOwner[owner]);
54         _;
55     }
56 
57 
58     modifier ownerExists(address owner) {
59         require(isOwner[owner]);
60         _;
61     }
62 
63 
64     modifier transactionExists(uint transactionId) {
65         require(transactions[transactionId].destination != 0);
66         _;
67     }
68 
69 
70     modifier confirmed(uint transactionId, address owner) {
71         require(confirmations[transactionId][owner]);
72         _;
73     }
74 
75 
76     modifier notConfirmed(uint transactionId, address owner) {
77         require(!confirmations[transactionId][owner]);
78         _;
79     }
80 
81 
82     modifier notExecuted(uint transactionId) {
83         require(!transactions[transactionId].executed);
84         _;
85     }
86 
87 
88     modifier notNull(address _address) {
89         require(_address != 0);
90         _;
91     }
92 
93 
94     modifier validRequirement(uint ownerCount, uint _required) {
95         require(ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
96         _;
97     }
98 
99 
100     /**
101      * Public functions
102     **/
103     /// @dev Contract constructor sets initial owners and required number of confirmations.
104     /// @param _owners List of initial owners.
105     /// @param _required Number of required confirmations.
106     function MultiSigWallet(address[] _owners, uint _required)
107         public
108         validRequirement(_owners.length, _required)
109      {
110         for (uint i = 0; i < _owners.length; i++) {
111             require(!isOwner[_owners[i]] && _owners[i] != 0);
112             isOwner[_owners[i]] = true;
113         }
114 
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
141         for (uint i = 0; i < owners.length - 1; i++) {
142             if (owners[i] == owner) {
143                 owners[i] = owners[owners.length - 1];
144                 break;
145             }
146         }
147         owners.length -= 1;
148         if (required > owners.length) {
149             changeRequirement(owners.length);
150         }
151         OwnerRemoval(owner);
152     }
153 
154     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
155     /// @param owner Address of owner to be replaced.
156     /// @param newOwner Address of new owner.
157     function replaceOwner(address owner, address newOwner)
158         public
159         onlyWallet
160         ownerExists(owner)
161         ownerDoesNotExist(newOwner)
162     {
163         for (uint i = 0; i < owners.length; i++) {
164             if (owners[i] == owner) {
165                 owners[i] = newOwner;
166                 break;
167             }
168         }
169         isOwner[owner] = false;
170         isOwner[newOwner] = true;
171         OwnerRemoval(owner);
172         OwnerAddition(newOwner);
173     }
174 
175     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
176     /// @param _required Number of required confirmations.
177     function changeRequirement(uint _required)
178         public
179         onlyWallet
180         validRequirement(owners.length, _required)
181     {
182         required = _required;
183         RequirementChange(_required);
184     }
185 
186     /// @dev Allows an owner to submit and confirm a transaction.
187     /// @param destination Transaction target address.
188     /// @param value Transaction ether value.
189     /// @param data Transaction data payload.
190     /// @return Returns transaction ID.
191     function submitTransaction(address destination, uint value, bytes data)
192         public
193         returns (uint transactionId)
194     {
195         transactionId = addTransaction(destination, value, data);
196         confirmTransaction(transactionId);
197     }
198 
199     /// @dev Allows an owner to confirm a transaction.
200     /// @param transactionId Transaction ID.
201     function confirmTransaction(uint transactionId)
202         public
203         ownerExists(msg.sender)
204         transactionExists(transactionId)
205         notConfirmed(transactionId, msg.sender)
206     {
207         confirmations[transactionId][msg.sender] = true;
208         Confirmation(msg.sender, transactionId);
209         executeTransaction(transactionId);
210     }
211 
212     /// @dev Allows an owner to revoke a confirmation for a transaction.
213     /// @param transactionId Transaction ID.
214     function revokeConfirmation(uint transactionId)
215         public
216         ownerExists(msg.sender)
217         confirmed(transactionId, msg.sender)
218         notExecuted(transactionId)
219     {
220         confirmations[transactionId][msg.sender] = false;
221         Revocation(msg.sender, transactionId);
222     }
223 
224     /// @dev Allows anyone to execute a confirmed transaction.
225     /// @param transactionId Transaction ID.
226     function executeTransaction(uint transactionId)
227         public
228         ownerExists(msg.sender)
229         confirmed(transactionId, msg.sender)
230         notExecuted(transactionId)
231     {
232         if (isConfirmed(transactionId)) {
233             Transaction storage txn = transactions[transactionId];
234             txn.executed = true;
235             if (txn.destination.call.value(txn.value)(txn.data)) {
236                 Execution(transactionId);
237             } else {
238                 ExecutionFailure(transactionId);
239                 txn.executed = false;
240             }
241         }
242     }
243 
244     /// @dev Returns the confirmation status of a transaction.
245     /// @param transactionId Transaction ID.
246     /// @return Confirmation status.
247     function isConfirmed(uint transactionId)
248         public
249         constant
250         returns (bool)
251     {
252         uint count = 0;
253         for (uint i = 0; i < owners.length; i++) {
254             if (confirmations[transactionId][owners[i]]) {
255                 count += 1;
256             }
257             if (count == required) {
258                 return true;
259             }
260         }
261     }
262 
263     /*
264      * Internal functions
265      */
266     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
267     /// @param destination Transaction target address.
268     /// @param value Transaction ether value.
269     /// @param data Transaction data payload.
270     /// @return Returns transaction ID.
271     function addTransaction(address destination, uint value, bytes data)
272         internal
273         notNull(destination)
274         returns (uint transactionId)
275     {
276         transactionId = transactionCount;
277         transactions[transactionId] = Transaction({
278             destination: destination,
279             value: value,
280             data: data,
281             executed: false
282         });
283         transactionCount += 1;
284         Submission(transactionId);
285     }
286 
287     /*
288      * Web3 call functions
289      */
290     /// @dev Returns number of confirmations of a transaction.
291     /// @param transactionId Transaction ID.
292     /// @return Number of confirmations.
293     function getConfirmationCount(uint transactionId)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i = 0; i < owners.length; i++) {
299             if (confirmations[transactionId][owners[i]]) {
300                 count += 1;
301             }
302         }
303     }
304 
305     /// @dev Returns total number of transactions after filers are applied.
306     /// @param pending Include pending transactions.
307     /// @param executed Include executed transactions.
308     /// @return Total number of transactions after filters are applied.
309     function getTransactionCount(bool pending, bool executed)
310         public
311         constant
312         returns (uint count)
313     {
314         for (uint i = 0; i < transactionCount; i++) {
315             if ((pending && !transactions[i].executed) || (executed && transactions[i].executed)) {
316                 count += 1;
317             }
318         }
319     }
320 
321     /// @dev Returns list of owners.
322     /// @return List of owner addresses.
323     function getOwners()
324         public
325         constant
326         returns (address[])
327     {
328         return owners;
329     }
330 
331     /// @dev Returns array with owner addresses, which confirmed transaction.
332     /// @param transactionId Transaction ID.
333     /// @return Returns array of owner addresses.
334     function getConfirmations(uint transactionId)
335         public
336         constant
337         returns (address[] _confirmations)
338     {
339         address[] memory confirmationsTemp = new address[](owners.length);
340         uint count = 0;
341         uint i;
342         for (i = 0; i < owners.length; i++) {
343             if (confirmations[transactionId][owners[i]]) {
344                 confirmationsTemp[count] = owners[i];
345                 count += 1;
346             }
347         }
348         _confirmations = new address[](count);
349         for (i = 0; i < count; i++) {
350             _confirmations[i] = confirmationsTemp[i];
351         }
352     }
353 
354     /// @dev Returns list of transaction IDs in defined range.
355     /// @param from Index start position of transaction array.
356     /// @param to Index end position of transaction array.
357     /// @param pending Include pending transactions.
358     /// @param executed Include executed transactions.
359     /// @return Returns array of transaction IDs.
360     /// @dev Returns list of transaction IDs in defined range.
361     function getTransactionIds(uint from, uint to, bool pending, bool executed)
362         public
363         constant
364         returns (uint[] _transactionIds)
365     {
366         require(from <= to || to < transactionCount);
367         uint[] memory transactionIdsTemp = new uint[](to - from + 1);
368         uint count = 0;
369         uint i;
370         for (i = from; i <= to; i++) {
371             if ((pending && !transactions[i].executed) || (executed && transactions[i].executed)) {
372                 transactionIdsTemp[count] = i;
373                 count += 1;
374             }
375         }
376         _transactionIds = new uint[](count);
377         for (i = 0; i < count; i++) {
378             _transactionIds[i] = transactionIdsTemp[i];
379         }
380     }
381 
382     /// @dev Fallback function allows to deposit ether.
383     function() public payable {
384         if (msg.value > 0) {
385             Deposit(msg.sender, msg.value);
386         }
387     }
388 }
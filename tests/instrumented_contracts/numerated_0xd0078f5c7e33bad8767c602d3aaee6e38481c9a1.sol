1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title Multisignature wallet
6  * @dev Allows multiple parties to agree on transactions before execution
7  * @author Stefan George <stefan.george@consensys.net>
8  * @author Jakub Stefanski (https://github.com/jstefanski)
9  */
10 contract MultiSigWallet {
11 
12     uint256 constant public MAX_OWNER_COUNT = 50;
13 
14     mapping (uint256 => Transaction) public transactions;
15     mapping (uint256 => mapping (address => bool)) public confirmations;
16 
17     mapping (address => bool) public isOwner;
18     address[] public owners;
19 
20     uint256 public required;
21     uint256 public transactionCount;
22 
23     struct Transaction {
24         address destination;
25         uint256 value;
26         bytes data;
27         bool executed;
28     }
29 
30     event Confirmation(address indexed sender, uint256 indexed transactionId);
31 
32     event Revocation(address indexed sender, uint256 indexed transactionId);
33 
34     event Submission(uint256 indexed transactionId);
35 
36     event Execution(uint256 indexed transactionId);
37 
38     event ExecutionFailure(uint256 indexed transactionId);
39 
40     event Deposit(address indexed sender, uint256 value);
41 
42     event OwnerAddition(address indexed owner);
43 
44     event OwnerRemoval(address indexed owner);
45 
46     event RequirementChange(uint256 required);
47 
48     modifier onlyWallet() {
49         require(msg.sender == address(this));
50         _;
51     }
52 
53     modifier onlyOwnerDoesNotExist(address owner) {
54         require(!isOwner[owner]);
55         _;
56     }
57 
58     modifier onlyOwnerExists(address owner) {
59         require(isOwner[owner]);
60         _;
61     }
62 
63     modifier onlyTransactionExists(uint256 transactionId) {
64         require(transactions[transactionId].destination != address(0));
65         _;
66     }
67 
68     modifier onlyConfirmed(uint256 transactionId, address owner) {
69         require(confirmations[transactionId][owner]);
70         _;
71     }
72 
73     modifier onlyNotConfirmed(uint256 transactionId, address owner) {
74         require(!confirmations[transactionId][owner]);
75         _;
76     }
77 
78     modifier onlyNotExecuted(uint256 transactionId) {
79         require(!transactions[transactionId].executed);
80         _;
81     }
82 
83     modifier onlyValid(address _address) {
84         require(_address != 0);
85         _;
86     }
87 
88     modifier onlyValidRequirement(uint256 ownerCount, uint256 _required) {
89         require(ownerCount > 0);
90         require(ownerCount <= MAX_OWNER_COUNT);
91         require(_required > 0);
92         require(_required <= ownerCount);
93         _;
94     }
95 
96     /**
97      * @dev Contract constructor sets initial owners and required number of confirmations
98      * @param _owners List of initial owners
99      * @param _required Number of required confirmations
100      */
101     function MultiSigWallet(address[] _owners, uint256 _required)
102         public
103         onlyValidRequirement(_owners.length, _required)
104     {
105         for (uint256 i = 0; i < _owners.length; i++) {
106             require(!isOwner[_owners[i]] && _owners[i] != address(0));
107 
108             isOwner[_owners[i]] = true;
109         }
110 
111         owners = _owners;
112         required = _required;
113     }
114 
115     /**
116      * @dev Fallback function allows ETH deposits
117      */
118     function() public payable {
119         if (msg.value > 0) {
120             Deposit(msg.sender, msg.value);
121         }
122     }
123 
124     /**
125      * @dev Add a new owner
126      * @dev Transaction has to be sent by wallet
127      * @param owner The address of a new owner
128      */
129     function addOwner(address owner)
130         public
131         onlyWallet
132         onlyValid(owner)
133         onlyOwnerDoesNotExist(owner)
134         onlyValidRequirement(owners.length + 1, required)
135     {
136         isOwner[owner] = true;
137         owners.push(owner);
138 
139         OwnerAddition(owner);
140     }
141 
142     /**
143      * @dev Remove an owner
144      * @dev Transaction has to be sent by wallet
145      * @param owner The address of an owner
146      */
147     function removeOwner(address owner)
148         public
149         onlyWallet
150         onlyOwnerExists(owner)
151     {
152         isOwner[owner] = false;
153 
154         for (uint256 i = 0; i < owners.length - 1; i++) {
155             if (owners[i] == owner) {
156                 owners[i] = owners[owners.length - 1];
157                 owners.length -= 1;
158                 break;
159             }
160         }
161 
162         if (required > owners.length) {
163             changeRequirement(owners.length);
164         }
165 
166         OwnerRemoval(owner);
167     }
168 
169     /**
170      * @dev Replace the owner with a new owner
171      * @dev Transaction has to be sent by wallet
172      * @param owner The address of owner to be replaced
173      * @param newOwner The address of new owner
174      */
175     function replaceOwner(address owner, address newOwner)
176         public
177         onlyWallet
178         onlyOwnerExists(owner)
179         onlyOwnerDoesNotExist(newOwner)
180     {
181         for (uint256 i = 0; i < owners.length; i++) {
182             if (owners[i] == owner) {
183                 owners[i] = newOwner;
184                 break;
185             }
186         }
187 
188         isOwner[owner] = false;
189         isOwner[newOwner] = true;
190 
191         OwnerRemoval(owner);
192         OwnerAddition(newOwner);
193     }
194 
195     /**
196      * @dev Change the number of required confirmations
197      * @dev Transaction has to be sent by wallet
198      * @param _required The number of required confirmations
199      */
200     function changeRequirement(uint256 _required)
201         public
202         onlyWallet
203         onlyValidRequirement(owners.length, _required)
204     {
205         required = _required;
206         RequirementChange(_required);
207     }
208 
209     /**
210      * @dev Submit and confirm a transaction
211      * @dev Transaction has to be sent by wallet
212      * @param destination The transaction target address
213      * @param value The transaction ETH value
214      * @param data The transaction data payload
215      * @return A transaction ID
216      */
217     function submitTransaction(address destination, uint256 value, bytes data)
218         public
219         onlyOwnerExists(msg.sender)
220         returns (uint256 transactionId)
221     {
222         transactionId = addTransaction(destination, value, data);
223         confirmTransaction(transactionId);
224     }
225 
226     /**
227      * @dev Confirm the transaction
228      * @param transactionId The transaction ID
229      */
230     function confirmTransaction(uint256 transactionId)
231         public
232         onlyOwnerExists(msg.sender)
233         onlyTransactionExists(transactionId)
234         onlyNotConfirmed(transactionId, msg.sender)
235     {
236         confirmations[transactionId][msg.sender] = true;
237         Confirmation(msg.sender, transactionId);
238 
239         executeTransaction(transactionId);
240     }
241 
242     /**
243      * @dev Revoke the transaction confirmation
244      * @param transactionId The transaction ID
245      */
246     function revokeConfirmation(uint256 transactionId)
247         public
248         onlyOwnerExists(msg.sender)
249         onlyConfirmed(transactionId, msg.sender)
250         onlyNotExecuted(transactionId)
251     {
252         confirmations[transactionId][msg.sender] = false;
253         Revocation(msg.sender, transactionId);
254     }
255 
256     /**
257      * @dev Execute confirmed transaction
258      * @param transactionId The transaction ID
259      */
260     function executeTransaction(uint256 transactionId)
261         public
262         onlyOwnerExists(msg.sender)
263         onlyConfirmed(transactionId, msg.sender)
264         onlyNotExecuted(transactionId)
265     {
266         if (isConfirmed(transactionId)) {
267             Transaction storage txn = transactions[transactionId];
268             txn.executed = true;
269 
270             /* solhint-disable avoid-call-value */
271             if (txn.destination.call.value(txn.value)(txn.data)) {
272                 Execution(transactionId);
273             } else {
274                 ExecutionFailure(transactionId);
275                 txn.executed = false;
276             }
277             /* solhint-enable avoid-call-value */
278         }
279     }
280 
281     /**
282      * @dev Check confirmation status of the transaction
283      * @param transactionId The transaction ID
284      * @return True if transaction is confirmed, otherwise False
285      */
286     function isConfirmed(uint256 transactionId)
287         public
288         view
289         returns (bool)
290     {
291         uint256 count = 0;
292         for (uint256 i=0; i < owners.length; i++) {
293             if (confirmations[transactionId][owners[i]]) {
294                 count += 1;
295             }
296 
297             if (count == required) {
298                 return true;
299             }
300         }
301     }
302 
303     /**
304      * @dev Get number of confirmations of the transaction
305      * @param transactionId The transaction ID
306      * @return Number of confirmations
307      */
308     function getConfirmationCount(uint256 transactionId)
309         public
310         view
311         returns (uint256 count)
312     {
313         for (uint256 i = 0; i < owners.length; i++) {
314             if (confirmations[transactionId][owners[i]]) {
315                 count += 1;
316             }
317         }
318     }
319 
320     /**
321      * @dev Get total number of transactions after filers are applied
322      * @param pending Include pending transactions
323      * @param executed Include executed transactions
324      * @return Total number of transactions after filters are applied
325      */
326     function getTransactionCount(bool pending, bool executed)
327         public
328         view
329         returns (uint256 count)
330     {
331         for (uint256 i = 0; i < transactionCount; i++) {
332             bool txExecuted = transactions[i].executed;
333 
334             if ((pending && !txExecuted) || (executed && txExecuted)) {
335                 count += 1;
336             }
337         }
338     }
339 
340     /**
341      * @dev Get list of owners
342      * @return List of owner addresses
343      */
344     function getOwners()
345         public
346         view
347         returns (address[])
348     {
349         return owners;
350     }
351 
352     /**
353      * @dev Get array with owner addresses that confirmed the transaction
354      * @param transactionId The transaction ID
355      * @return Array of owner addresses that confirmed the transaction
356      */
357     function getConfirmations(uint256 transactionId)
358         public
359         view
360         returns (address[] _confirmations)
361     {
362         address[] memory confirmationsTemp = new address[](owners.length);
363         uint256 count = 0;
364         uint256 i;
365 
366         for (i = 0; i < owners.length; i++) {
367             if (confirmations[transactionId][owners[i]]) {
368                 confirmationsTemp[count] = owners[i];
369                 count += 1;
370             }
371         }
372 
373         _confirmations = new address[](count);
374         for (i = 0; i < count; i++) {
375             _confirmations[i] = confirmationsTemp[i];
376         }
377     }
378 
379     /**
380      * @dev Get list of transaction IDs in defined range
381      * @param from Index start position of transaction array
382      * @param to Index end position of transaction array
383      * @param pending Include pending transactions
384      * @param executed Include executed transactions
385      * @return Array of transaction IDs
386      */
387     function getTransactionIds(
388         uint256 from,
389         uint256 to,
390         bool pending,
391         bool executed
392     )
393         public
394         view
395         returns (uint256[] _transactionIds)
396     {
397         uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
398         uint256 count = 0;
399         uint256 i;
400 
401         for (i = 0; i < transactionCount; i++) {
402             bool txExecuted = transactions[i].executed;
403 
404             if ((pending && !txExecuted) || (executed && txExecuted)) {
405                 transactionIdsTemp[count] = i;
406                 count += 1;
407             }
408         }
409 
410         _transactionIds = new uint256[](to - from);
411         for (i = from; i < to; i++) {
412             _transactionIds[i - from] = transactionIdsTemp[i];
413         }
414     }
415 
416     /**
417      * @dev Add a new transaction to the transaction mapping
418      * @param destination The transaction target address
419      * @param value The transaction ether value
420      * @param data The transaction data payload
421      * @return The transaction ID
422      */
423     function addTransaction(address destination, uint256 value, bytes data)
424         internal
425         onlyValid(destination)
426         returns (uint256 transactionId)
427     {
428         transactionId = transactionCount;
429         transactions[transactionId] = Transaction({
430             destination: destination,
431             value: value,
432             data: data,
433             executed: false
434         });
435         transactionCount += 1;
436 
437         Submission(transactionId);
438     }
439 }
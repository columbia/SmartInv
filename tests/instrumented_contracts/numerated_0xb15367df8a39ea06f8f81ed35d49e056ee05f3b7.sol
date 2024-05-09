1 pragma solidity 0.4.24;
2 
3 /** @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4   * @author Stefan George - <stefan.george@consensys.net>
5   */
6 contract MultiSigWallet {
7 
8     uint256 constant public MAX_OWNER_COUNT = 50;
9 
10     event Confirmation(address indexed sender, uint256 indexed transactionId);
11     event Revocation(address indexed sender, uint256 indexed transactionId);
12     event Submission(uint256 indexed transactionId);
13     event Execution(uint256 indexed transactionId);
14     event ExecutionFailure(uint256 indexed transactionId);
15     event Deposit(address indexed sender, uint256 value);
16     event OwnerAddition(address indexed owner);
17     event OwnerRemoval(address indexed owner);
18     event RequirementChange(uint256 required);
19 
20     mapping (uint256 => Transaction) public transactions;
21     mapping (uint256 => mapping (address => bool)) public confirmations;
22     mapping (address => bool) public isOwner;
23 
24     address[] public owners;
25     uint256 public required;
26     uint256 public transactionCount;
27 
28     struct Transaction {
29         address destination;
30         uint256 value;
31         bytes data;
32         bool executed;
33     }
34 
35     modifier onlyWallet() {
36         if (msg.sender != address(this))
37             revert("ONLY_WALLET_ERROR");
38         _;
39     }
40 
41     modifier ownerDoesNotExist(address owner) {
42         if (isOwner[owner])
43             revert("OWNER_DOES_NOT_EXIST_ERROR");
44         _;
45     }
46 
47     modifier ownerExists(address owner) {
48         if (!isOwner[owner])
49             revert("OWNER_EXISTS_ERROR");
50         _;
51     }
52 
53     modifier transactionExists(uint256 transactionId) {
54         if (transactions[transactionId].destination == 0)
55             revert("TRANSACTION_EXISTS_ERROR");
56         _;
57     }
58 
59     modifier confirmed(uint256 transactionId, address owner) {
60         if (!confirmations[transactionId][owner])
61             revert("CONFIRMED_ERROR");
62         _;
63     }
64 
65     modifier notConfirmed(uint256 transactionId, address owner) {
66         if (confirmations[transactionId][owner])
67             revert("NOT_CONFIRMED_ERROR");
68         _;
69     }
70 
71     modifier notExecuted(uint256 transactionId) {
72         if (transactions[transactionId].executed)
73             revert("NOT_EXECUTED_ERROR");
74         _;
75     }
76 
77     modifier notNull(address _address) {
78         if (_address == 0)
79             revert("NOT_NULL_ERROR");
80         _;
81     }
82 
83     modifier validRequirement(uint256 ownerCount, uint256 _required) {
84         if (ownerCount > MAX_OWNER_COUNT || _required > ownerCount || _required == 0 || ownerCount == 0)
85             revert("VALID_REQUIREMENT_ERROR");
86         _;
87     }
88 
89     /** @dev Fallback function allows to deposit ether. */
90     function() public payable {
91         if (msg.value > 0) {
92             emit Deposit(msg.sender, msg.value);
93         }
94     }
95 
96     /** @dev Contract constructor sets initial owners and required number of confirmations.
97       * @param _owners List of initial owners.
98       * @param _required Number of required confirmations.
99       */
100     constructor(address[] _owners, uint256 _required)
101         public
102         validRequirement(_owners.length, _required)
103     {
104         for (uint256 i = 0; i < _owners.length; i++) {
105             if (isOwner[_owners[i]] || _owners[i] == 0) {
106                 revert("OWNER_ERROR");
107             }
108 
109             isOwner[_owners[i]] = true;
110         }
111 
112         owners = _owners;
113         required = _required;
114     }
115 
116     /** @dev Allows to add a new owner. Transaction has to be sent by wallet.
117       * @param owner Address of new owner.
118       */
119     function addOwner(address owner)
120         public
121         onlyWallet
122         ownerDoesNotExist(owner)
123         notNull(owner)
124         validRequirement(owners.length + 1, required)
125     {
126         isOwner[owner] = true;
127         owners.push(owner);
128         emit OwnerAddition(owner);
129     }
130 
131     /** @dev Allows to remove an owner. Transaction has to be sent by wallet.
132       * @param owner Address of owner.
133       */
134     function removeOwner(address owner)
135         public
136         onlyWallet
137         ownerExists(owner)
138     {
139         isOwner[owner] = false;
140         for (uint256 i = 0; i < owners.length - 1; i++) {
141             if (owners[i] == owner) {
142                 owners[i] = owners[owners.length - 1];
143                 break;
144             }
145         }
146 
147         owners.length -= 1;
148 
149         if (required > owners.length) {
150             changeRequirement(owners.length);
151         }
152 
153         emit OwnerRemoval(owner);
154     }
155 
156     /** @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
157       * @param owner Address of owner to be replaced.
158       * @param owner Address of new owner.
159       */
160     function replaceOwner(address owner, address newOwner)
161         public
162         onlyWallet
163         ownerExists(owner)
164         ownerDoesNotExist(newOwner)
165     {
166         for (uint256 i = 0; i < owners.length; i++) {
167             if (owners[i] == owner) {
168                 owners[i] = newOwner;
169                 break;
170             }
171         }
172 
173         isOwner[owner] = false;
174         isOwner[newOwner] = true;
175         emit OwnerRemoval(owner);
176         emit OwnerAddition(newOwner);
177     }
178 
179     /** @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
180       * @param _required Number of required confirmations.
181       */
182     function changeRequirement(uint256 _required)
183         public
184         onlyWallet
185         validRequirement(owners.length, _required)
186     {
187         required = _required;
188         emit RequirementChange(_required);
189     }
190 
191     /** @dev Allows an owner to submit and confirm a transaction.
192       * @param destination Transaction target address.
193       * @param value Transaction ether value.
194       * @param data Transaction data payload.
195       * @return Returns transaction ID.
196       */
197     function submitTransaction(address destination, uint256 value, bytes data)
198         public
199         returns (uint256 transactionId)
200     {
201         transactionId = addTransaction(destination, value, data);
202         confirmTransaction(transactionId);
203     }
204 
205     /** @dev Allows an owner to confirm a transaction.
206       * @param transactionId Transaction ID.
207       */
208     function confirmTransaction(uint256 transactionId)
209         public
210         ownerExists(msg.sender)
211         transactionExists(transactionId)
212         notConfirmed(transactionId, msg.sender)
213     {
214         confirmations[transactionId][msg.sender] = true;
215         emit Confirmation(msg.sender, transactionId);
216         executeTransaction(transactionId);
217     }
218 
219     /** @dev Allows an owner to revoke a confirmation for a transaction.
220       * @param transactionId Transaction ID.
221       */
222     function revokeConfirmation(uint256 transactionId)
223         public
224         ownerExists(msg.sender)
225         confirmed(transactionId, msg.sender)
226         notExecuted(transactionId)
227     {
228         confirmations[transactionId][msg.sender] = false;
229         emit Revocation(msg.sender, transactionId);
230     }
231 
232     /** @dev Allows anyone to execute a confirmed transaction.
233       * @param transactionId Transaction ID.
234       */
235     function executeTransaction(uint256 transactionId)
236         public
237         ownerExists(msg.sender)
238         notExecuted(transactionId)
239     {
240         if (isConfirmed(transactionId)) {
241             Transaction storage transaction = transactions[transactionId];
242             transaction.executed = true;
243             if (transaction.destination.call.value(transaction.value)(transaction.data))
244                 emit Execution(transactionId);
245             else {
246                 emit ExecutionFailure(transactionId);
247                 transaction.executed = false;
248             }
249         }
250     }
251 
252     /** @dev Returns the confirmation status of a transaction.
253       * @param transactionId Transaction ID.
254       * @return Confirmation status.
255       */
256     function isConfirmed(uint256 transactionId)
257         public
258         view
259         returns (bool)
260     {
261         uint256 count = 0;
262         for (uint256 i = 0; i < owners.length; i++) {
263             if (confirmations[transactionId][owners[i]]) {
264                 count += 1;
265             }
266 
267             if (count >= required) {
268                 return true;
269             }
270         }
271     }
272 
273     /* Internal functions */
274 
275     /** @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
276       * @param destination Transaction target address.
277       * @param value Transaction ether value.
278       * @param data Transaction data payload.
279       * @return Returns transaction ID.
280       */
281     function addTransaction(address destination, uint256 value, bytes data)
282         internal
283         notNull(destination)
284         returns (uint256 transactionId)
285     {
286         transactionId = transactionCount;
287         transactions[transactionId] = Transaction({
288             destination: destination,
289             value: value,
290             data: data,
291             executed: false
292         });
293         transactionCount += 1;
294         emit Submission(transactionId);
295     }
296 
297 
298     /* Web3 call functions */
299 
300     /** @dev Returns number of confirmations of a transaction.
301       * @param transactionId Transaction ID.
302       * @return Number of confirmations.
303       */
304     function getConfirmationCount(uint256 transactionId)
305         public
306         view
307         returns (uint256 count)
308     {
309         for (uint256 i = 0; i < owners.length; i++) {
310             if (confirmations[transactionId][owners[i]]) {
311                 count += 1;
312             }
313         }
314     }
315 
316     /** @dev Returns total number of transactions after filers are applied.
317       * @param pending Include pending transactions.
318       * @param executed Include executed transactions.
319       * @return Total number of transactions after filters are applied.
320       */
321     function getTransactionCount(bool pending, bool executed)
322         public
323         view
324         returns (uint256 count)
325     {
326         for (uint256 i = 0; i < transactionCount; i++) {
327             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
328                 count += 1;
329             }
330         }
331     }
332 
333     /** @dev Returns list of owners.
334       * @return List of owner addresses.
335       */
336     function getOwners() public view returns (address[]) {
337         return owners;
338     }
339 
340     /** @dev Returns array with owner addresses, which confirmed transaction.
341       * @param transactionId Transaction ID.
342       * @return Returns array of owner addresses.
343       */
344     function getConfirmations(uint256 transactionId)
345         public
346         view
347         returns (address[] _confirmations)
348     {
349         address[] memory confirmationsTemp = new address[](owners.length);
350         uint256 count = 0;
351         uint256 i;
352 
353         for (i = 0; i < owners.length; i++) {
354             if (confirmations[transactionId][owners[i]]) {
355                 confirmationsTemp[count] = owners[i];
356                 count += 1;
357             }
358         }
359 
360         _confirmations = new address[](count);
361 
362         for (i = 0; i < count; i++) {
363             _confirmations[i] = confirmationsTemp[i];
364         }
365     }
366 }
367 
368 contract MultiSigWalletWithLock is
369     MultiSigWallet
370 {
371     /* default lock time is 2 weeks, can be modified later */
372     uint256 public lockSeconds = 1209600;
373 
374     /* events */
375     event UnlockTimeSet(uint256 indexed transactionId, uint256 confirmationTime);
376     event LockSecondsChange(uint256 lockSeconds);
377 
378     /* unlock time of transactions */
379     mapping (uint256 => uint256) public unlockTimes;
380 
381 
382     /** @dev Contract constructor sets initial owners and required number of confirmations.
383       * @param _owners List of initial owners.
384       * @param _required Number of required confirmations.
385       */
386     constructor (
387         address[] _owners,
388         uint256 _required
389     )
390         public
391         MultiSigWallet(_owners, _required)
392     {}
393 
394     /** @dev Changes the duration of the time lock for transactions.
395       * @param _lockSeconds Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
396       */
397     function changeLockSeconds(uint256 _lockSeconds)
398         public
399         onlyWallet
400     {
401         lockSeconds = _lockSeconds;
402         emit LockSecondsChange(_lockSeconds);
403     }
404 
405     /** @dev Allows an owner to confirm a transaction.
406       * @param transactionId Transaction ID.
407       */
408     function confirmTransaction(uint256 transactionId)
409         public
410         ownerExists(msg.sender)
411         transactionExists(transactionId)
412         notConfirmed(transactionId, msg.sender)
413     {
414         confirmations[transactionId][msg.sender] = true;
415         emit Confirmation(msg.sender, transactionId);
416         if (isConfirmed(transactionId) && unlockTimes[transactionId] == 0) {
417             uint256 unlockTime = block.timestamp + lockSeconds;
418             unlockTimes[transactionId] = unlockTime;
419             emit UnlockTimeSet(transactionId, unlockTime);
420         }
421     }
422 
423     /** @dev Allows anyone to execute a confirmed transaction.
424       * @param transactionId Transaction ID.
425       */
426     function executeTransaction(uint256 transactionId)
427         public
428         ownerExists(msg.sender)
429         notExecuted(transactionId)
430     {
431         require(
432             block.timestamp >= unlockTimes[transactionId],
433             "TRANSACTION_NEED_TO_UNLOCK"
434         );
435         super.executeTransaction(transactionId);
436     }
437 }
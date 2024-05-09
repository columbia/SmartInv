1 pragma solidity ^0.4.15;
2 
3 
4 contract RNTMultiSigWallet {
5     /*
6      *  Events
7      */
8     event Confirmation(address indexed sender, uint indexed transactionId);
9 
10     event Revocation(address indexed sender, uint indexed transactionId);
11 
12     event Submission(uint indexed transactionId);
13 
14     event Execution(uint indexed transactionId);
15 
16     event ExecutionFailure(uint indexed transactionId);
17 
18     event Deposit(address indexed sender, uint value);
19 
20     event OwnerAddition(address indexed owner);
21 
22     event OwnerRemoval(address indexed owner);
23 
24     event RequirementChange(uint required);
25 
26     event Pause();
27 
28     event Unpause();
29 
30     /*
31      *  Constants
32      */
33     uint constant public MAX_OWNER_COUNT = 10;
34 
35     uint constant public ADMINS_COUNT = 2;
36 
37     /*
38      *  Storage
39      */
40     mapping (uint => WalletTransaction) public transactions;
41 
42     mapping (uint => mapping (address => bool)) public confirmations;
43 
44     mapping (address => bool) public isOwner;
45 
46     mapping (address => bool) public isAdmin;
47 
48     address[] public owners;
49 
50     address[] public admins;
51 
52     uint public required;
53 
54     uint public transactionCount;
55 
56     bool public paused = false;
57 
58     struct WalletTransaction {
59     address sender;
60     address destination;
61     uint value;
62     bytes data;
63     bool executed;
64     }
65 
66     /*
67      *  Modifiers
68      */
69 
70     /// @dev Modifier to make a function callable only when the contract is not paused.
71     modifier whenNotPaused() {
72         require(!paused);
73         _;
74     }
75 
76     /// @dev Modifier to make a function callable only when the contract is paused.
77     modifier whenPaused() {
78         require(paused);
79         _;
80     }
81 
82     modifier onlyWallet() {
83         require(msg.sender == address(this));
84         _;
85     }
86 
87     modifier ownerDoesNotExist(address owner) {
88         require(!isOwner[owner]);
89         _;
90     }
91 
92     modifier ownerExists(address owner) {
93         require(isOwner[owner]);
94         _;
95     }
96 
97     modifier adminExists(address admin) {
98         require(isAdmin[admin]);
99         _;
100     }
101 
102     modifier adminDoesNotExist(address admin) {
103         require(!isAdmin[admin]);
104         _;
105     }
106 
107     modifier transactionExists(uint transactionId) {
108         require(transactions[transactionId].destination != 0);
109         _;
110     }
111 
112     modifier confirmed(uint transactionId, address owner) {
113         require(confirmations[transactionId][owner]);
114         _;
115     }
116 
117     modifier notConfirmed(uint transactionId, address owner) {
118         require(!confirmations[transactionId][owner]);
119         _;
120     }
121 
122     modifier notExecuted(uint transactionId) {
123         if (transactions[transactionId].executed)
124         require(false);
125         _;
126     }
127 
128     modifier notNull(address _address) {
129         require(_address != 0);
130         _;
131     }
132 
133     modifier validRequirement(uint ownerCount, uint _required) {
134         if (ownerCount > MAX_OWNER_COUNT
135         || _required > ownerCount
136         || _required == 0
137         || ownerCount == 0) {
138             require(false);
139         }
140         _;
141     }
142 
143     modifier validAdminsCount(uint adminsCount) {
144         require(adminsCount == ADMINS_COUNT);
145         _;
146     }
147 
148     /// @dev Fallback function allows to deposit ether.
149     function()
150     whenNotPaused
151     payable
152     {
153         if (msg.value > 0)
154         Deposit(msg.sender, msg.value);
155     }
156 
157     /*
158      * Public functions
159      */
160     /// @dev Contract constructor sets initial admins and required number of confirmations.
161     /// @param _admins List of initial owners.
162     /// @param _required Number of required confirmations.
163     function RNTMultiSigWallet(address[] _admins, uint _required)
164     public
165         //    validAdminsCount(_admins.length)
166         //    validRequirement(_admins.length, _required)
167     {
168         for (uint i = 0; i < _admins.length; i++) {
169             require(_admins[i] != 0 && !isOwner[_admins[i]] && !isAdmin[_admins[i]]);
170             isAdmin[_admins[i]] = true;
171             isOwner[_admins[i]] = true;
172         }
173 
174         admins = _admins;
175         owners = _admins;
176         required = _required;
177     }
178 
179     /// @dev called by the owner to pause, triggers stopped state
180     function pause() adminExists(msg.sender) whenNotPaused public {
181         paused = true;
182         Pause();
183     }
184 
185     /// @dev called by the owner to unpause, returns to normal state
186     function unpause() adminExists(msg.sender) whenPaused public {
187         paused = false;
188         Unpause();
189     }
190 
191     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
192     /// @param owner Address of new owner.
193     function addOwner(address owner)
194     public
195     whenNotPaused
196     adminExists(msg.sender)
197     ownerDoesNotExist(owner)
198     notNull(owner)
199     validRequirement(owners.length + 1, required)
200     {
201         isOwner[owner] = true;
202         owners.push(owner);
203         OwnerAddition(owner);
204     }
205 
206     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
207     /// @param owner Address of owner.
208     function removeOwner(address owner)
209     public
210     whenNotPaused
211     adminExists(msg.sender)
212     adminDoesNotExist(owner)
213     ownerExists(owner)
214     {
215         isOwner[owner] = false;
216         for (uint i = 0; i < owners.length - 1; i++)
217         if (owners[i] == owner) {
218             owners[i] = owners[owners.length - 1];
219             break;
220         }
221         owners.length -= 1;
222         if (required > owners.length)
223         changeRequirement(owners.length);
224         OwnerRemoval(owner);
225     }
226 
227     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
228     /// @param owner Address of owner to be replaced.
229     /// @param newOwner Address of new owner.
230     function replaceOwner(address owner, address newOwner)
231     public
232     whenNotPaused
233     adminExists(msg.sender)
234     adminDoesNotExist(owner)
235     ownerExists(owner)
236     ownerDoesNotExist(newOwner)
237     {
238         for (uint i = 0; i < owners.length; i++)
239         if (owners[i] == owner) {
240             owners[i] = newOwner;
241             break;
242         }
243         isOwner[owner] = false;
244         isOwner[newOwner] = true;
245         OwnerRemoval(owner);
246         OwnerAddition(newOwner);
247     }
248 
249     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
250     /// @param _required Number of required confirmations.
251     function changeRequirement(uint _required)
252     public
253     whenNotPaused
254     adminExists(msg.sender)
255     validRequirement(owners.length, _required)
256     {
257         required = _required;
258         RequirementChange(_required);
259     }
260 
261     /// @dev Allows an owner to submit and confirm a transaction.
262     /// @param destination Transaction target address.
263     /// @param value Transaction ether value.
264     /// @param data Transaction data payload.
265     /// @return Returns transaction ID.
266     function submitTransaction(address destination, uint value, bytes data)
267     public
268     whenNotPaused
269     ownerExists(msg.sender)
270     returns (uint transactionId)
271     {
272         transactionId = addTransaction(destination, value, data);
273         confirmTransaction(transactionId);
274     }
275 
276     /// @dev Allows an owner to confirm a transaction.
277     /// @param transactionId Transaction ID.
278     function confirmTransaction(uint transactionId)
279     public
280     whenNotPaused
281     ownerExists(msg.sender)
282     transactionExists(transactionId)
283     notConfirmed(transactionId, msg.sender)
284     {
285         confirmations[transactionId][msg.sender] = true;
286         Confirmation(msg.sender, transactionId);
287         executeTransaction(transactionId);
288     }
289 
290     /// @dev Allows an owner to revoke a confirmation for a transaction.
291     /// @param transactionId Transaction ID.
292     function revokeConfirmation(uint transactionId)
293     public
294     whenNotPaused
295     ownerExists(msg.sender)
296     confirmed(transactionId, msg.sender)
297     notExecuted(transactionId)
298     {
299         confirmations[transactionId][msg.sender] = false;
300         Revocation(msg.sender, transactionId);
301     }
302 
303     /// @dev Allows anyone to execute a confirmed transaction.
304     /// @param transactionId Transaction ID.
305     function executeTransaction(uint transactionId)
306     public
307     whenNotPaused
308     ownerExists(msg.sender)
309     confirmed(transactionId, msg.sender)
310     notExecuted(transactionId)
311     {
312         if (isConfirmed(transactionId)) {
313             WalletTransaction storage walletTransaction = transactions[transactionId];
314             walletTransaction.executed = true;
315             if (walletTransaction.destination.call.value(walletTransaction.value)(walletTransaction.data))
316             Execution(transactionId);
317             else {
318                 ExecutionFailure(transactionId);
319                 walletTransaction.executed = false;
320             }
321         }
322     }
323 
324     /// @dev Returns the confirmation status of a transaction.
325     /// @param transactionId Transaction ID.
326     /// @return Confirmation status.
327     function isConfirmed(uint transactionId)
328     public
329     constant
330     returns (bool)
331     {
332         uint count = 0;
333         for (uint i = 0; i < owners.length; i++) {
334             if (confirmations[transactionId][owners[i]])
335             count += 1;
336             if (count == required)
337             return true;
338         }
339     }
340 
341     /*
342      * Internal functions
343      */
344     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
345     /// @param destination Transaction target address.
346     /// @param value Transaction ether value.
347     /// @param data Transaction data payload.
348     /// @return Returns transaction ID.
349     function addTransaction(address destination, uint value, bytes data)
350     internal
351     notNull(destination)
352     returns (uint transactionId)
353     {
354         transactionId = transactionCount;
355         transactions[transactionId] = WalletTransaction({
356         sender : msg.sender,
357         destination : destination,
358         value : value,
359         data : data,
360         executed : false
361         });
362         transactionCount += 1;
363         Submission(transactionId);
364     }
365 
366     /*
367      * Web3 call functions
368      */
369     /// @dev Returns number of confirmations of a transaction.
370     /// @param transactionId Transaction ID.
371     /// @return Number of confirmations.
372     function getConfirmationCount(uint transactionId)
373     public
374     constant
375     returns (uint count)
376     {
377         for (uint i = 0; i < owners.length; i++)
378         if (confirmations[transactionId][owners[i]])
379         count += 1;
380     }
381 
382     /// @dev Returns total number of transactions after filers are applied.
383     /// @param pending Include pending transactions.
384     /// @param executed Include executed transactions.
385     /// @return Total number of transactions after filters are applied.
386     function getTransactionCount(bool pending, bool executed)
387     public
388     constant
389     returns (uint count)
390     {
391         for (uint i = 0; i < transactionCount; i++)
392         if (pending && !transactions[i].executed
393         || executed && transactions[i].executed)
394         count += 1;
395     }
396 
397     /// @dev Returns list of owners.
398     /// @return List of owner addresses.
399     function getOwners()
400     public
401     constant
402     returns (address[])
403     {
404         return owners;
405     }
406 
407     // @dev Returns list of admins.
408     // @return List of admin addresses
409     function getAdmins()
410     public
411     constant
412     returns (address[])
413     {
414         return admins;
415     }
416 
417     /// @dev Returns array with owner addresses, which confirmed transaction.
418     /// @param transactionId Transaction ID.
419     /// @return Returns array of owner addresses.
420     function getConfirmations(uint transactionId)
421     public
422     constant
423     returns (address[] _confirmations)
424     {
425         address[] memory confirmationsTemp = new address[](owners.length);
426         uint count = 0;
427         uint i;
428         for (i = 0; i < owners.length; i++)
429         if (confirmations[transactionId][owners[i]]) {
430             confirmationsTemp[count] = owners[i];
431             count += 1;
432         }
433         _confirmations = new address[](count);
434         for (i = 0; i < count; i++)
435         _confirmations[i] = confirmationsTemp[i];
436     }
437 
438     /// @dev Returns list of transaction IDs in defined range.
439     /// @param from Index start position of transaction array.
440     /// @param to Index end position of transaction array.
441     /// @param pending Include pending transactions.
442     /// @param executed Include executed transactions.
443     /// @return Returns array of transaction IDs.
444     function getTransactionIds(uint from, uint to, bool pending, bool executed)
445     public
446     constant
447     returns (uint[] _transactionIds)
448     {
449         uint[] memory transactionIdsTemp = new uint[](transactionCount);
450         uint count = 0;
451         uint i;
452         for (i = 0; i < transactionCount; i++)
453         if (pending && !transactions[i].executed
454         || executed && transactions[i].executed)
455         {
456             transactionIdsTemp[count] = i;
457             count += 1;
458         }
459         _transactionIds = new uint[](to - from);
460         for (i = from; i < to; i++)
461         _transactionIds[i - from] = transactionIdsTemp[i];
462     }
463 }
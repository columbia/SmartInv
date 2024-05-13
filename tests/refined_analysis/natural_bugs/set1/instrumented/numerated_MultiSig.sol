1 /**
2  *Submitted for verification at Bscscan.com on 2020-09-25
3  */
4 
5 /*
6 
7     Copyright 2020 DODO ZOO.
8     SPDX-License-Identifier: Apache-2.0
9 
10 */
11 
12 pragma solidity 0.6.9;
13 pragma experimental ABIEncoderV2;
14 
15 
16 contract MultiSigWalletWithTimelock {
17     uint256 public constant MAX_OWNER_COUNT = 50;
18     uint256 public lockSeconds = 86400;
19 
20     event Confirmation(address indexed sender, uint256 indexed transactionId);
21     event Revocation(address indexed sender, uint256 indexed transactionId);
22     event Submission(uint256 indexed transactionId);
23     event Execution(uint256 indexed transactionId);
24     event ExecutionFailure(uint256 indexed transactionId);
25     event Deposit(address indexed sender, uint256 value);
26     event OwnerAddition(address indexed owner);
27     event OwnerRemoval(address indexed owner);
28     event RequirementChange(uint256 required);
29     event UnlockTimeSet(uint256 indexed transactionId, uint256 confirmationTime);
30     event LockSecondsChange(uint256 lockSeconds);
31 
32     mapping(uint256 => Transaction) public transactions;
33     mapping(uint256 => mapping(address => bool)) public confirmations;
34     mapping(address => bool) public isOwner;
35     mapping(uint256 => uint256) public unlockTimes;
36 
37     address[] public owners;
38     uint256 public required;
39     uint256 public transactionCount;
40 
41     struct Transaction {
42         address destination;
43         uint256 value;
44         bytes data;
45         bool executed;
46     }
47 
48     struct EmergencyCall {
49         bytes32 selector;
50         uint256 paramsBytesCount;
51     }
52 
53     // Functions bypass the time lock process
54     EmergencyCall[] public emergencyCalls;
55 
56     modifier onlyWallet() {
57         if (msg.sender != address(this)) revert("ONLY_WALLET_ERROR");
58         _;
59     }
60 
61     modifier ownerDoesNotExist(address owner) {
62         if (isOwner[owner]) revert("OWNER_DOES_NOT_EXIST_ERROR");
63         _;
64     }
65 
66     modifier ownerExists(address owner) {
67         if (!isOwner[owner]) revert("OWNER_EXISTS_ERROR");
68         _;
69     }
70 
71     modifier transactionExists(uint256 transactionId) {
72         if (transactions[transactionId].destination == address(0))
73             revert("TRANSACTION_EXISTS_ERROR");
74         _;
75     }
76 
77     modifier confirmed(uint256 transactionId, address owner) {
78         if (!confirmations[transactionId][owner]) revert("CONFIRMED_ERROR");
79         _;
80     }
81 
82     modifier notConfirmed(uint256 transactionId, address owner) {
83         if (confirmations[transactionId][owner]) revert("NOT_CONFIRMED_ERROR");
84         _;
85     }
86 
87     modifier notExecuted(uint256 transactionId) {
88         if (transactions[transactionId].executed) revert("NOT_EXECUTED_ERROR");
89         _;
90     }
91 
92     modifier notNull(address _address) {
93         if (_address == address(0)) revert("NOT_NULL_ERROR");
94         _;
95     }
96 
97     modifier validRequirement(uint256 ownerCount, uint256 _required) {
98         if (
99             ownerCount > MAX_OWNER_COUNT ||
100             _required > ownerCount ||
101             _required == 0 ||
102             ownerCount == 0
103         ) revert("VALID_REQUIREMENT_ERROR");
104         _;
105     }
106 
107     /** @dev Fallback function allows to deposit ether. */
108     fallback() external payable {
109         if (msg.value > 0) {
110             emit Deposit(msg.sender, msg.value);
111         }
112     }
113 
114     receive() external payable {
115         if (msg.value > 0) {
116             emit Deposit(msg.sender, msg.value);
117         }
118     }
119 
120     /** @dev Contract constructor sets initial owners and required number of confirmations.
121      * @param _owners List of initial owners.
122      * @param _required Number of required confirmations.
123      */
124     constructor(address[] memory _owners, uint256 _required)
125         public
126         validRequirement(_owners.length, _required)
127     {
128         for (uint256 i = 0; i < _owners.length; i++) {
129             if (isOwner[_owners[i]] || _owners[i] == address(0)) {
130                 revert("OWNER_ERROR");
131             }
132 
133             isOwner[_owners[i]] = true;
134         }
135 
136         owners = _owners;
137         required = _required;
138 
139         // initialzie Emergency calls
140         emergencyCalls.push(
141             EmergencyCall({
142                 selector: keccak256(abi.encodePacked("claimOwnership()")),
143                 paramsBytesCount: 0
144             })
145         );
146         emergencyCalls.push(
147             EmergencyCall({
148                 selector: keccak256(abi.encodePacked("setK(uint256)")),
149                 paramsBytesCount: 64
150             })
151         );
152         emergencyCalls.push(
153             EmergencyCall({
154                 selector: keccak256(abi.encodePacked("setLiquidityProviderFeeRate(uint256)")),
155                 paramsBytesCount: 64
156             })
157         );
158     }
159 
160     function getEmergencyCallsCount() external view returns (uint256 count) {
161         return emergencyCalls.length;
162     }
163 
164     /** @dev Allows to add a new owner. Transaction has to be sent by wallet.
165      * @param owner Address of new owner.
166      */
167     function addOwner(address owner)
168         external
169         onlyWallet
170         ownerDoesNotExist(owner)
171         notNull(owner)
172         validRequirement(owners.length + 1, required)
173     {
174         isOwner[owner] = true;
175         owners.push(owner);
176         emit OwnerAddition(owner);
177     }
178 
179     /** @dev Allows to remove an owner. Transaction has to be sent by wallet.
180      * @param owner Address of owner.
181      */
182     function removeOwner(address owner) external onlyWallet ownerExists(owner) {
183         isOwner[owner] = false;
184         for (uint256 i = 0; i < owners.length - 1; i++) {
185             if (owners[i] == owner) {
186                 owners[i] = owners[owners.length - 1];
187                 break;
188             }
189         }
190 
191         owners.pop;
192 
193         if (required > owners.length) {
194             changeRequirement(owners.length);
195         }
196 
197         emit OwnerRemoval(owner);
198     }
199 
200     /** @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
201      * @param owner Address of owner to be replaced.
202      * @param owner Address of new owner.
203      */
204     function replaceOwner(address owner, address newOwner)
205         external
206         onlyWallet
207         ownerExists(owner)
208         ownerDoesNotExist(newOwner)
209     {
210         for (uint256 i = 0; i < owners.length; i++) {
211             if (owners[i] == owner) {
212                 owners[i] = newOwner;
213                 break;
214             }
215         }
216 
217         isOwner[owner] = false;
218         isOwner[newOwner] = true;
219         emit OwnerRemoval(owner);
220         emit OwnerAddition(newOwner);
221     }
222 
223     /** @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
224      * @param _required Number of required confirmations.
225      */
226     function changeRequirement(uint256 _required)
227         public
228         onlyWallet
229         validRequirement(owners.length, _required)
230     {
231         required = _required;
232         emit RequirementChange(_required);
233     }
234 
235     /** @dev Changes the duration of the time lock for transactions.
236      * @param _lockSeconds Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
237      */
238     function changeLockSeconds(uint256 _lockSeconds) external onlyWallet {
239         lockSeconds = _lockSeconds;
240         emit LockSecondsChange(_lockSeconds);
241     }
242 
243     /** @dev Allows an owner to submit and confirm a transaction.
244      * @param destination Transaction target address.
245      * @param value Transaction ether value.
246      * @param data Transaction data payload.
247      * @return transactionId Returns transaction ID.
248      */
249     function submitTransaction(
250         address destination,
251         uint256 value,
252         bytes calldata data
253     ) external ownerExists(msg.sender) notNull(destination) returns (uint256 transactionId) {
254         transactionId = transactionCount;
255         transactions[transactionId] = Transaction({
256             destination: destination,
257             value: value,
258             data: data,
259             executed: false
260         });
261         transactionCount += 1;
262         emit Submission(transactionId);
263         confirmTransaction(transactionId);
264     }
265 
266     /** @dev Allows an owner to confirm a transaction.
267      * @param transactionId Transaction ID.
268      */
269     function confirmTransaction(uint256 transactionId)
270         public
271         ownerExists(msg.sender)
272         transactionExists(transactionId)
273         notConfirmed(transactionId, msg.sender)
274     {
275         confirmations[transactionId][msg.sender] = true;
276         emit Confirmation(msg.sender, transactionId);
277 
278         if (
279             isConfirmed(transactionId) &&
280             unlockTimes[transactionId] == 0 &&
281             !isEmergencyCall(transactionId)
282         ) {
283             uint256 unlockTime = block.timestamp + lockSeconds;
284             unlockTimes[transactionId] = unlockTime;
285             emit UnlockTimeSet(transactionId, unlockTime);
286         }
287     }
288 
289     function isEmergencyCall(uint256 transactionId) internal view returns (bool) {
290         bytes memory data = transactions[transactionId].data;
291 
292         for (uint256 i = 0; i < emergencyCalls.length; i++) {
293             EmergencyCall memory emergencyCall = emergencyCalls[i];
294 
295             if (
296                 data.length == emergencyCall.paramsBytesCount + 4 &&
297                 data.length >= 4 &&
298                 emergencyCall.selector[0] == data[0] &&
299                 emergencyCall.selector[1] == data[1] &&
300                 emergencyCall.selector[2] == data[2] &&
301                 emergencyCall.selector[3] == data[3]
302             ) {
303                 return true;
304             }
305         }
306 
307         return false;
308     }
309 
310     function addEmergencyCall(string memory funcName, uint256 _paramsBytesCount) public onlyWallet {
311         emergencyCalls.push(
312             EmergencyCall({
313                 selector: keccak256(abi.encodePacked(funcName)),
314                 paramsBytesCount: _paramsBytesCount
315             })
316         );
317     }
318 
319     /** @dev Allows an owner to revoke a confirmation for a transaction.
320      * @param transactionId Transaction ID.
321      */
322     function revokeConfirmation(uint256 transactionId)
323         external
324         ownerExists(msg.sender)
325         confirmed(transactionId, msg.sender)
326         notExecuted(transactionId)
327     {
328         confirmations[transactionId][msg.sender] = false;
329         emit Revocation(msg.sender, transactionId);
330     }
331 
332     /** @dev Allows anyone to execute a confirmed transaction.
333      * @param transactionId Transaction ID.
334      */
335     function executeTransaction(uint256 transactionId)
336         external
337         ownerExists(msg.sender)
338         notExecuted(transactionId)
339     {
340         require(block.timestamp >= unlockTimes[transactionId], "TRANSACTION_NEED_TO_UNLOCK");
341 
342         if (isConfirmed(transactionId)) {
343             Transaction storage transaction = transactions[transactionId];
344             transaction.executed = true;
345             (bool success, ) = transaction.destination.call{value: transaction.value}(
346                 transaction.data
347             );
348             if (success) emit Execution(transactionId);
349             else {
350                 emit ExecutionFailure(transactionId);
351                 transaction.executed = false;
352             }
353         }
354     }
355 
356     /** @dev Returns the confirmation status of a transaction.
357      * @param transactionId Transaction ID.
358      * @return Confirmation status.
359      */
360     function isConfirmed(uint256 transactionId) public view returns (bool) {
361         uint256 count = 0;
362 
363         for (uint256 i = 0; i < owners.length; i++) {
364             if (confirmations[transactionId][owners[i]]) {
365                 count += 1;
366             }
367 
368             if (count >= required) {
369                 return true;
370             }
371         }
372 
373         return false;
374     }
375 
376     /* Web3 call functions */
377 
378     /** @dev Returns number of confirmations of a transaction.
379      * @param transactionId Transaction ID.
380      * @return count Number of confirmations.
381      */
382     function getConfirmationCount(uint256 transactionId) external view returns (uint256 count) {
383         for (uint256 i = 0; i < owners.length; i++) {
384             if (confirmations[transactionId][owners[i]]) {
385                 count += 1;
386             }
387         }
388     }
389 
390     /** @dev Returns total number of transactions after filers are applied.
391      * @param pending Include pending transactions.
392      * @param executed Include executed transactions.
393      * @return count Total number of transactions after filters are applied.
394      */
395     function getTransactionCount(bool pending, bool executed)
396         external
397         view
398         returns (uint256 count)
399     {
400         for (uint256 i = 0; i < transactionCount; i++) {
401             if ((pending && !transactions[i].executed) || (executed && transactions[i].executed)) {
402                 count += 1;
403             }
404         }
405     }
406 
407     /** @dev Returns list of owners.
408      * @return List of owner addresses.
409      */
410     function getOwners() external view returns (address[] memory) {
411         return owners;
412     }
413 
414     /** @dev Returns array with owner addresses, which confirmed transaction.
415      * @param transactionId Transaction ID.
416      * @return _confirmations Returns array of owner addresses.
417      */
418     function getConfirmations(uint256 transactionId)
419         external
420         view
421         returns (address[] memory _confirmations)
422     {
423         address[] memory confirmationsTemp = new address[](owners.length);
424         uint256 count = 0;
425         uint256 i;
426 
427         for (i = 0; i < owners.length; i++) {
428             if (confirmations[transactionId][owners[i]]) {
429                 confirmationsTemp[count] = owners[i];
430                 count += 1;
431             }
432         }
433 
434         _confirmations = new address[](count);
435 
436         for (i = 0; i < count; i++) {
437             _confirmations[i] = confirmationsTemp[i];
438         }
439     }
440 }

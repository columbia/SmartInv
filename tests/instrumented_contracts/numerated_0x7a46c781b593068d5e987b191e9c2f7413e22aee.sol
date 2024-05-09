1 pragma solidity 0.4.19;
2 
3 interface token {
4     function transfer(address _to, uint256 _value) public;
5 }
6 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
7 contract MultiSigWallet {
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
20     event EthDailyLimitChange(uint limit);
21     event MtcDailyLimitChange(uint limit);
22     event TokenChange(address _token);
23     /*
24      *  Constants
25      */
26     uint constant public MAX_OWNER_COUNT = 10;
27     /*
28      *  Storage
29      */
30     mapping(uint => Transaction) public transactions;
31     mapping(uint => mapping(address => bool)) public confirmations;
32     mapping(address => bool) public isOwner;
33     address[] public owners;
34     uint public required;
35     uint public transactionCount;
36     uint public ethDailyLimit;
37     uint public mtcDailyLimit;
38     uint public dailySpent;
39     uint public mtcDailySpent;
40     uint public lastDay;
41     uint public mtcLastDay;
42     token public MTC;
43 
44     struct Transaction {
45         address destination;
46         uint value;
47         bytes data;
48         string description;
49         bool executed;
50     }
51     /*
52      *  Modifiers
53      */
54     modifier onlyWallet() {
55         require(msg.sender == address(this));
56         _;
57     }
58     modifier ownerDoesNotExist(address owner) {
59         require(!isOwner[owner]);
60         _;
61     }
62     modifier ownerExists(address owner) {
63         require(isOwner[owner]);
64         _;
65     }
66     modifier transactionExists(uint transactionId) {
67         require(transactions[transactionId].destination != 0);
68         _;
69     }
70     modifier confirmed(uint transactionId, address owner) {
71         require(confirmations[transactionId][owner]);
72         _;
73     }
74     modifier notConfirmed(uint transactionId, address owner) {
75         require(!confirmations[transactionId][owner]);
76         _;
77     }
78     modifier notExecuted(uint transactionId) {
79         require(!transactions[transactionId].executed);
80         _;
81     }
82     modifier notNull(address _address) {
83         require(_address != 0);
84         _;
85     }
86     modifier validRequirement(uint ownerCount, uint _required) {
87         require(ownerCount <= MAX_OWNER_COUNT
88         && _required <= ownerCount
89         && _required != 0
90         && ownerCount != 0);
91         _;
92     }
93     modifier validDailyEthLimit(uint _limit) {
94         require(_limit >= 0);
95         _;
96     }
97     modifier validDailyMTCLimit(uint _limit) {
98         require(_limit >= 0);
99         _;
100     }
101     /// @dev Fallback function allows to deposit ether.
102     function()
103     payable public
104     {
105         if (msg.value > 0)
106             Deposit(msg.sender, msg.value);
107     }
108     /*
109      * Public functions
110      */
111     /// @dev Contract constructor sets initial owners and required number of confirmations.
112     /// @param _owners List of initial owners.
113     /// @param _required Number of required confirmations.
114     function MultiSigWallet(address[] _owners, uint _required, uint _ethDailyLimit, uint _mtcDailyLimit)
115     public
116     validRequirement(_owners.length, _required)
117     {
118         for (uint i = 0; i < _owners.length; i++) {
119             require(!isOwner[_owners[i]] && _owners[i] != 0);
120             isOwner[_owners[i]] = true;
121         }
122         owners = _owners;
123         required = _required;
124         ethDailyLimit = _ethDailyLimit * 1 ether;
125         mtcDailyLimit = _mtcDailyLimit * 1 ether;
126         lastDay = toDays(now);
127         mtcLastDay = toDays(now);
128     }
129 
130     function toDays(uint _time) pure internal returns (uint) {
131         return _time / (60 * 60 * 24);
132     }
133 
134     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
135     /// @param owner Address of new owner.
136     function addOwner(address owner)
137     public
138     onlyWallet
139     ownerDoesNotExist(owner)
140     notNull(owner)
141     validRequirement(owners.length + 1, required)
142     {
143         isOwner[owner] = true;
144         owners.push(owner);
145         OwnerAddition(owner);
146     }
147     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
148     /// @param owner Address of owner.
149     function removeOwner(address owner)
150     public
151     onlyWallet
152     ownerExists(owner)
153     {
154         isOwner[owner] = false;
155         for (uint i = 0; i < owners.length - 1; i++)
156             if (owners[i] == owner) {
157                 owners[i] = owners[owners.length - 1];
158                 break;
159             }
160         owners.length -= 1;
161         if (required > owners.length)
162             changeRequirement(owners.length);
163         OwnerRemoval(owner);
164     }
165     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
166     /// @param owner Address of owner to be replaced.
167     /// @param newOwner Address of new owner.
168     function replaceOwner(address owner, address newOwner)
169     public
170     onlyWallet
171     ownerExists(owner)
172     ownerDoesNotExist(newOwner)
173     {
174         for (uint i = 0; i < owners.length; i++)
175             if (owners[i] == owner) {
176                 owners[i] = newOwner;
177                 break;
178             }
179         isOwner[owner] = false;
180         isOwner[newOwner] = true;
181         OwnerRemoval(owner);
182         OwnerAddition(newOwner);
183     }
184     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
185     /// @param _required Number of required confirmations.
186     function changeRequirement(uint _required)
187     public
188     onlyWallet
189     validRequirement(owners.length, _required)
190     {
191         required = _required;
192         RequirementChange(_required);
193     }
194 
195     /// @dev Allows to change the eth daily transfer limit. Transaction has to be sent by wallet.
196     /// @param _limit Daily eth limit.
197     function changeEthDailyLimit(uint _limit)
198     public
199     onlyWallet
200     validDailyEthLimit(_limit)
201     {
202         ethDailyLimit = _limit;
203         EthDailyLimitChange(_limit);
204     }
205 
206     /// @dev Allows to change the mtc daily transfer limit. Transaction has to be sent by wallet.
207     /// @param _limit Daily mtc limit.
208     function changeMtcDailyLimit(uint _limit)
209     public
210     onlyWallet
211     validDailyMTCLimit(_limit)
212     {
213         mtcDailyLimit = _limit;
214         MtcDailyLimitChange(_limit);
215     }
216 
217     /// @dev Allows to change the token address. Transaction has to be sent by wallet.
218     /// @param _token token address.
219     function setToken(address _token)
220     public
221     onlyWallet
222     {
223         MTC = token(_token);
224         TokenChange(_token);
225     }
226 
227     /// @dev Allows an owner to submit and confirm a transaction.
228     /// @param destination Transaction target address.
229     /// @param value Transaction ether value.
230     /// @param description Transaction description.
231     /// @param data Transaction data payload.
232     /// @return Returns transaction ID.
233     function submitTransaction(address destination, uint value, string description, bytes data)
234     public
235     returns (uint transactionId)
236     {
237         transactionId = addTransaction(destination, value, description, data);
238         confirmTransaction(transactionId);
239     }
240     /// @dev Allows an owner to confirm a transaction.
241     /// @param transactionId Transaction ID.
242     function confirmTransaction(uint transactionId)
243     public
244     ownerExists(msg.sender)
245     transactionExists(transactionId)
246     notConfirmed(transactionId, msg.sender)
247     {
248         confirmations[transactionId][msg.sender] = true;
249         Confirmation(msg.sender, transactionId);
250         executeTransaction(transactionId);
251     }
252     /// @dev Allows an owner to revoke a confirmation for a transaction.
253     /// @param transactionId Transaction ID.
254     function revokeConfirmation(uint transactionId)
255     public
256     ownerExists(msg.sender)
257     confirmed(transactionId, msg.sender)
258     notExecuted(transactionId)
259     {
260         confirmations[transactionId][msg.sender] = false;
261         Revocation(msg.sender, transactionId);
262     }
263     /// @dev Allows anyone to execute a confirmed transaction.
264     /// @param _to Destination address.
265     /// @param _value amount.
266     function softEthTransfer(address _to, uint _value)
267     public
268     ownerExists(msg.sender)
269     {
270         require(_value > 0);
271         _value *= 1 finney;
272         if (lastDay != toDays(now)) {
273             dailySpent = 0;
274             lastDay = toDays(now);
275         }
276         require((dailySpent + _value) <= ethDailyLimit);
277         if (_to.send(_value)) {
278             dailySpent += _value;
279         } else {
280             revert();
281         }
282     }
283 
284     /// @dev Allows anyone to execute a confirmed transaction.
285     /// @param _to Destination address.
286     /// @param _value amount.
287     function softMtcTransfer(address _to, uint _value)
288     public
289     ownerExists(msg.sender)
290     {
291         require(_value > 0);
292         _value *= 1 ether;
293         if (mtcLastDay != toDays(now)) {
294             mtcDailySpent = 0;
295             mtcLastDay = toDays(now);
296         }
297         require((mtcDailySpent + _value) <= mtcDailyLimit);
298         MTC.transfer(_to, _value);
299         mtcDailySpent += _value;
300 
301     }
302 
303     /// @dev Allows anyone to execute a confirmed transaction.
304     /// @param transactionId Transaction ID.
305     function executeTransaction(uint transactionId)
306     public
307     ownerExists(msg.sender)
308     confirmed(transactionId, msg.sender)
309     notExecuted(transactionId)
310     {
311         if (isConfirmed(transactionId)) {
312             Transaction storage txn = transactions[transactionId];
313             txn.executed = true;
314             if (txn.destination.call.value(txn.value)(txn.data))
315                 Execution(transactionId);
316             else {
317                 ExecutionFailure(transactionId);
318                 txn.executed = false;
319             }
320         }
321     }
322     /// @dev Returns the confirmation status of a transaction.
323     /// @param transactionId Transaction ID.
324     /// @return Confirmation status.
325     function isConfirmed(uint transactionId)
326     public
327     constant
328     returns (bool)
329     {
330         uint count = 0;
331         for (uint i = 0; i < owners.length; i++) {
332             if (confirmations[transactionId][owners[i]])
333                 count += 1;
334             if (count == required)
335                 return true;
336         }
337     }
338     /*
339      * Internal functions
340      */
341     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
342     /// @param destination Transaction target address.
343     /// @param value Transaction ether value.
344     /// @param description Transaction description.
345     /// @param data Transaction data payload.
346     /// @return Returns transaction ID.
347     function addTransaction(address destination, uint value, string description, bytes data)
348     internal
349     notNull(destination)
350     returns (uint transactionId)
351     {
352         transactionId = transactionCount;
353         transactions[transactionId] = Transaction({
354             destination : destination,
355             value : value,
356             description : description,
357             data : data,
358             executed : false
359             });
360         transactionCount += 1;
361         Submission(transactionId);
362     }
363     /*
364      * Web3 call functions
365      */
366     /// @dev Returns number of confirmations of a transaction.
367     /// @param transactionId Transaction ID.
368     /// @return Number of confirmations.
369     function getTransactionDescription(uint transactionId)
370     public
371     constant
372     returns (string description)
373     {
374         Transaction storage txn = transactions[transactionId];
375         return txn.description;
376     }
377     /// @dev Returns number of confirmations of a transaction.
378     /// @param transactionId Transaction ID.
379     /// @return Number of confirmations.
380     function getConfirmationCount(uint transactionId)
381     public
382     constant
383     returns (uint count)
384     {
385         for (uint i = 0; i < owners.length; i++)
386             if (confirmations[transactionId][owners[i]])
387                 count += 1;
388     }
389     /// @dev Returns total number of transactions after filers are applied.
390     /// @param pending Include pending transactions.
391     /// @param executed Include executed transactions.
392     /// @return Total number of transactions after filters are applied.
393     function getTransactionCount(bool pending, bool executed)
394     public
395     constant
396     returns (uint count)
397     {
398         for (uint i = 0; i < transactionCount; i++)
399             if (pending && !transactions[i].executed
400             || executed && transactions[i].executed)
401                 count += 1;
402     }
403     /// @dev Returns array with owner addresses, which confirmed transaction.
404     /// @param transactionId Transaction ID.
405     /// @return Returns array of owner addresses.
406     function getConfirmations(uint transactionId)
407     public
408     constant
409     returns (address[] _confirmations)
410     {
411         address[] memory confirmationsTemp = new address[](owners.length);
412         uint count = 0;
413         uint i;
414         for (i = 0; i < owners.length; i++)
415             if (confirmations[transactionId][owners[i]]) {
416                 confirmationsTemp[count] = owners[i];
417                 count += 1;
418             }
419         _confirmations = new address[](count);
420         for (i = 0; i < count; i++)
421             _confirmations[i] = confirmationsTemp[i];
422     }
423     /// @dev Returns list of transaction IDs in defined range.
424     /// @param from Index start position of transaction array.
425     /// @param to Index end position of transaction array.
426     /// @param pending Include pending transactions.
427     /// @param executed Include executed transactions.
428     /// @return Returns array of transaction IDs.
429     function getTransactionIds(uint from, uint to, bool pending, bool executed)
430     public
431     constant
432     returns (uint[] _transactionIds)
433     {
434         uint[] memory transactionIdsTemp = new uint[](transactionCount);
435         uint count = 0;
436         uint i;
437         for (i = 0; i < transactionCount; i++)
438             if (pending && !transactions[i].executed
439             || executed && transactions[i].executed)
440             {
441                 transactionIdsTemp[count] = i;
442                 count += 1;
443             }
444         _transactionIds = new uint[](to - from);
445         for (i = from; i < to; i++)
446             _transactionIds[i - from] = transactionIdsTemp[i];
447     }
448 }
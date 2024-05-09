1 pragma solidity ^0.4.18;
2 
3 contract ZipperWithdrawalRight
4 {
5     address realzipper;
6 
7     function ZipperWithdrawalRight(address _realzipper) public
8     {
9         realzipper = _realzipper;
10     }
11     
12     function withdraw(MultiSigWallet _wallet, uint _value) public
13     {
14         require (_wallet.isOwner(msg.sender));
15         require (_wallet.isOwner(this));
16         
17         _wallet.submitTransaction(msg.sender, _value, "");
18     }
19 
20     function changeRealZipper(address _newRealZipper) public
21     {
22         require(msg.sender == realzipper);
23         realzipper = _newRealZipper;
24     }
25     
26     function submitTransaction(MultiSigWallet _wallet, address _destination, uint _value, bytes _data) public returns (uint transactionId)
27     {
28         require(msg.sender == realzipper);
29         return _wallet.submitTransaction(_destination, _value, _data);
30     }
31     
32     function confirmTransaction(MultiSigWallet _wallet, uint transactionId) public
33     {
34         require(msg.sender == realzipper);
35         _wallet.confirmTransaction(transactionId);
36     }
37     
38     function revokeConfirmation(MultiSigWallet _wallet, uint transactionId) public
39     {
40         require(msg.sender == realzipper);
41         _wallet.revokeConfirmation(transactionId);
42     }
43     
44     function executeTransaction(MultiSigWallet _wallet, uint transactionId) public
45     {
46         require(msg.sender == realzipper);
47         _wallet.confirmTransaction(transactionId);
48     }
49 }
50 
51 contract ZipperMultisigFactory
52 {
53     address zipper;
54     
55     function ZipperMultisigFactory(address _zipper) public
56     {
57         zipper = _zipper;
58     }
59 
60     function createMultisig() public returns (address _multisig)
61     {
62         address[] memory addys = new address[](2);
63         addys[0] = zipper;
64         addys[1] = msg.sender;
65         
66         MultiSigWallet a = new MultiSigWallet(addys, 2);
67         
68         MultisigCreated(address(a), msg.sender, zipper);
69         
70         return address(a);
71     }
72     
73     function changeZipper(address _newZipper) public
74     {
75         require(msg.sender == zipper);
76         zipper = _newZipper;
77     }
78 
79     event MultisigCreated(address _multisig, address indexed _sender, address indexed _zipper);
80 }
81 
82 
83     // b7f01af8bd882501f6801eb1eea8b22aa2a4979e from https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
84     
85     /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
86     /// @author Stefan George - <stefan.george@consensys.net>
87     contract MultiSigWallet {
88     
89         /*
90          *  Events
91          */
92         event Confirmation(address indexed sender, uint indexed transactionId);
93         event Revocation(address indexed sender, uint indexed transactionId);
94         event Submission(uint indexed transactionId);
95         event Execution(uint indexed transactionId);
96         event ExecutionFailure(uint indexed transactionId);
97         event Deposit(address indexed sender, uint value);
98         event OwnerAddition(address indexed owner);
99         event OwnerRemoval(address indexed owner);
100         event RequirementChange(uint required);
101     
102         /*
103          *  Constants
104          */
105         uint constant public MAX_OWNER_COUNT = 50;
106     
107         /*
108          *  Storage
109          */
110         mapping (uint => Transaction) public transactions;
111         mapping (uint => mapping (address => bool)) public confirmations;
112         mapping (address => bool) public isOwner;
113         address[] public owners;
114         uint public required;
115         uint public transactionCount;
116     
117         struct Transaction {
118             address destination;
119             uint value;
120             bytes data;
121             bool executed;
122         }
123     
124         /*
125          *  Modifiers
126          */
127         modifier onlyWallet() {
128             if (msg.sender != address(this))
129                 throw;
130             _;
131         }
132     
133         modifier ownerDoesNotExist(address owner) {
134             if (isOwner[owner])
135                 throw;
136             _;
137         }
138     
139         modifier ownerExists(address owner) {
140             if (!isOwner[owner])
141                 throw;
142             _;
143         }
144     
145         modifier transactionExists(uint transactionId) {
146             if (transactions[transactionId].destination == 0)
147                 throw;
148             _;
149         }
150     
151         modifier confirmed(uint transactionId, address owner) {
152             if (!confirmations[transactionId][owner])
153                 throw;
154             _;
155         }
156     
157         modifier notConfirmed(uint transactionId, address owner) {
158             if (confirmations[transactionId][owner])
159                 throw;
160             _;
161         }
162     
163         modifier notExecuted(uint transactionId) {
164             if (transactions[transactionId].executed)
165                 throw;
166             _;
167         }
168     
169         modifier notNull(address _address) {
170             if (_address == 0)
171                 throw;
172             _;
173         }
174     
175         modifier validRequirement(uint ownerCount, uint _required) {
176             if (   ownerCount > MAX_OWNER_COUNT
177                 || _required > ownerCount
178                 || _required == 0
179                 || ownerCount == 0)
180                 throw;
181             _;
182         }
183     
184         /// @dev Fallback function allows to deposit ether.
185         function()
186             payable
187         {
188             if (msg.value > 0)
189                 Deposit(msg.sender, msg.value);
190         }
191     
192         /*
193          * Public functions
194          */
195         /// @dev Contract constructor sets initial owners and required number of confirmations.
196         /// @param _owners List of initial owners.
197         /// @param _required Number of required confirmations.
198         function MultiSigWallet(address[] _owners, uint _required)
199             public
200             validRequirement(_owners.length, _required)
201         {
202             for (uint i=0; i<_owners.length; i++) {
203                 if (isOwner[_owners[i]] || _owners[i] == 0)
204                     throw;
205                 isOwner[_owners[i]] = true;
206             }
207             owners = _owners;
208             required = _required;
209         }
210     
211         /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
212         /// @param owner Address of new owner.
213         function addOwner(address owner)
214             public
215             onlyWallet
216             ownerDoesNotExist(owner)
217             notNull(owner)
218             validRequirement(owners.length + 1, required)
219         {
220             isOwner[owner] = true;
221             owners.push(owner);
222             OwnerAddition(owner);
223         }
224     
225         /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
226         /// @param owner Address of owner.
227         function removeOwner(address owner)
228             public
229             onlyWallet
230             ownerExists(owner)
231         {
232             isOwner[owner] = false;
233             for (uint i=0; i<owners.length - 1; i++)
234                 if (owners[i] == owner) {
235                     owners[i] = owners[owners.length - 1];
236                     break;
237                 }
238             owners.length -= 1;
239             if (required > owners.length)
240                 changeRequirement(owners.length);
241             OwnerRemoval(owner);
242         }
243     
244         /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
245         /// @param owner Address of owner to be replaced.
246         /// @param newOwner Address of new owner.
247         function replaceOwner(address owner, address newOwner)
248             public
249             onlyWallet
250             ownerExists(owner)
251             ownerDoesNotExist(newOwner)
252         {
253             for (uint i=0; i<owners.length; i++)
254                 if (owners[i] == owner) {
255                     owners[i] = newOwner;
256                     break;
257                 }
258             isOwner[owner] = false;
259             isOwner[newOwner] = true;
260             OwnerRemoval(owner);
261             OwnerAddition(newOwner);
262         }
263     
264         /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
265         /// @param _required Number of required confirmations.
266         function changeRequirement(uint _required)
267             public
268             onlyWallet
269             validRequirement(owners.length, _required)
270         {
271             required = _required;
272             RequirementChange(_required);
273         }
274     
275         /// @dev Allows an owner to submit and confirm a transaction.
276         /// @param destination Transaction target address.
277         /// @param value Transaction ether value.
278         /// @param data Transaction data payload.
279         /// @return Returns transaction ID.
280         function submitTransaction(address destination, uint value, bytes data)
281             public
282             returns (uint transactionId)
283         {
284             transactionId = addTransaction(destination, value, data);
285             confirmTransaction(transactionId);
286         }
287     
288         /// @dev Allows an owner to confirm a transaction.
289         /// @param transactionId Transaction ID.
290         function confirmTransaction(uint transactionId)
291             public
292             ownerExists(msg.sender)
293             transactionExists(transactionId)
294             notConfirmed(transactionId, msg.sender)
295         {
296             confirmations[transactionId][msg.sender] = true;
297             Confirmation(msg.sender, transactionId);
298             executeTransaction(transactionId);
299         }
300     
301         /// @dev Allows an owner to revoke a confirmation for a transaction.
302         /// @param transactionId Transaction ID.
303         function revokeConfirmation(uint transactionId)
304             public
305             ownerExists(msg.sender)
306             confirmed(transactionId, msg.sender)
307             notExecuted(transactionId)
308         {
309             confirmations[transactionId][msg.sender] = false;
310             Revocation(msg.sender, transactionId);
311         }
312     
313         /// @dev Allows anyone to execute a confirmed transaction.
314         /// @param transactionId Transaction ID.
315         function executeTransaction(uint transactionId)
316             public
317             ownerExists(msg.sender)
318             confirmed(transactionId, msg.sender)
319             notExecuted(transactionId)
320         {
321             if (isConfirmed(transactionId)) {
322                 Transaction tx = transactions[transactionId];
323                 tx.executed = true;
324                 if (tx.destination.call.value(tx.value)(tx.data))
325                     Execution(transactionId);
326                 else {
327                     ExecutionFailure(transactionId);
328                     tx.executed = false;
329                 }
330             }
331         }
332     
333         /// @dev Returns the confirmation status of a transaction.
334         /// @param transactionId Transaction ID.
335         /// @return Confirmation status.
336         function isConfirmed(uint transactionId)
337             public
338             constant
339             returns (bool)
340         {
341             uint count = 0;
342             for (uint i=0; i<owners.length; i++) {
343                 if (confirmations[transactionId][owners[i]])
344                     count += 1;
345                 if (count == required)
346                     return true;
347             }
348         }
349     
350         /*
351          * Internal functions
352          */
353         /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
354         /// @param destination Transaction target address.
355         /// @param value Transaction ether value.
356         /// @param data Transaction data payload.
357         /// @return Returns transaction ID.
358         function addTransaction(address destination, uint value, bytes data)
359             internal
360             notNull(destination)
361             returns (uint transactionId)
362         {
363             transactionId = transactionCount;
364             transactions[transactionId] = Transaction({
365                 destination: destination,
366                 value: value,
367                 data: data,
368                 executed: false
369             });
370             transactionCount += 1;
371             Submission(transactionId);
372         }
373     
374         /*
375          * Web3 call functions
376          */
377         /// @dev Returns number of confirmations of a transaction.
378         /// @param transactionId Transaction ID.
379         /// @return Number of confirmations.
380         function getConfirmationCount(uint transactionId)
381             public
382             constant
383             returns (uint count)
384         {
385             for (uint i=0; i<owners.length; i++)
386                 if (confirmations[transactionId][owners[i]])
387                     count += 1;
388         }
389     
390         /// @dev Returns total number of transactions after filers are applied.
391         /// @param pending Include pending transactions.
392         /// @param executed Include executed transactions.
393         /// @return Total number of transactions after filters are applied.
394         function getTransactionCount(bool pending, bool executed)
395             public
396             constant
397             returns (uint count)
398         {
399             for (uint i=0; i<transactionCount; i++)
400                 if (   pending && !transactions[i].executed
401                     || executed && transactions[i].executed)
402                     count += 1;
403         }
404     
405         /// @dev Returns list of owners.
406         /// @return List of owner addresses.
407         function getOwners()
408             public
409             constant
410             returns (address[])
411         {
412             return owners;
413         }
414     
415         /// @dev Returns array with owner addresses, which confirmed transaction.
416         /// @param transactionId Transaction ID.
417         /// @return Returns array of owner addresses.
418         function getConfirmations(uint transactionId)
419             public
420             constant
421             returns (address[] _confirmations)
422         {
423             address[] memory confirmationsTemp = new address[](owners.length);
424             uint count = 0;
425             uint i;
426             for (i=0; i<owners.length; i++)
427                 if (confirmations[transactionId][owners[i]]) {
428                     confirmationsTemp[count] = owners[i];
429                     count += 1;
430                 }
431             _confirmations = new address[](count);
432             for (i=0; i<count; i++)
433                 _confirmations[i] = confirmationsTemp[i];
434         }
435     
436         /// @dev Returns list of transaction IDs in defined range.
437         /// @param from Index start position of transaction array.
438         /// @param to Index end position of transaction array.
439         /// @param pending Include pending transactions.
440         /// @param executed Include executed transactions.
441         /// @return Returns array of transaction IDs.
442         function getTransactionIds(uint from, uint to, bool pending, bool executed)
443             public
444             constant
445             returns (uint[] _transactionIds)
446         {
447             uint[] memory transactionIdsTemp = new uint[](transactionCount);
448             uint count = 0;
449             uint i;
450             for (i=0; i<transactionCount; i++)
451                 if (   pending && !transactions[i].executed
452                     || executed && transactions[i].executed)
453                 {
454                     transactionIdsTemp[count] = i;
455                     count += 1;
456                 }
457             _transactionIds = new uint[](to - from);
458             for (i=from; i<to; i++)
459                 _transactionIds[i - from] = transactionIdsTemp[i];
460         }
461     }
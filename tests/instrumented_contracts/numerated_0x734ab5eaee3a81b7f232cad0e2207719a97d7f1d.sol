1 pragma solidity ^0.4.15;
2 contract IToken {
3     function executeSettingsChange(
4         uint amount, 
5         uint partInvestor,
6         uint partProject, 
7         uint partFounders, 
8         uint blocksPerStage, 
9         uint partInvestorIncreasePerStage,
10         uint maxStages
11     );
12 }
13 
14 
15 contract MultiSigWallet {
16     uint constant public MAX_OWNER_COUNT = 50;
17     event Confirmation(address indexed sender, uint indexed transactionId);
18     event Revocation(address indexed sender, uint indexed transactionId);
19     event Submission(uint indexed transactionId);
20     event Execution(uint indexed transactionId);
21     event ExecutionFailure(uint indexed transactionId);
22     event Deposit(address indexed sender, uint value);
23     event OwnerAddition(address indexed owner);
24     event OwnerRemoval(address indexed owner);
25     event RequirementChange(uint required);
26     mapping (uint => Transaction) public transactions;
27     mapping (uint => mapping (address => bool)) public confirmations;
28     mapping (address => bool) public isOwner;
29     address[] public owners;
30     uint public required;
31     uint public transactionCount;
32     
33     IToken public token;
34     struct SettingsRequest 
35     {
36         uint amount;
37         uint partInvestor;
38         uint partProject;
39         uint partFounders;
40         uint blocksPerStage;
41         uint partInvestorIncreasePerStage;
42         uint maxStages;
43         bool executed;
44         mapping(address => bool) confirmations;
45     }
46     uint settingsRequestsCount = 0;
47     mapping(uint => SettingsRequest) settingsRequests;
48     struct Transaction {
49         address destination;
50         uint value;
51         bytes data;
52         bool executed;
53     }
54     address owner;
55     modifier onlyWallet() {
56         require(msg.sender == address(this));
57         _;
58     }
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63     modifier ownerDoesNotExist(address owner) {
64         require(!isOwner[owner]);
65         _;
66     }
67     modifier ownerExists(address owner) {
68         require(isOwner[owner]);
69         _;
70     }
71     modifier transactionExists(uint transactionId) {
72         require(transactions[transactionId].destination != 0);
73         _;
74     }
75     modifier confirmed(uint transactionId, address owner) {
76         require(confirmations[transactionId][owner]);
77         _;
78     }
79     modifier notConfirmed(uint transactionId, address owner) {
80         require(!confirmations[transactionId][owner]);
81         _;
82     }
83     modifier notExecuted(uint transactionId) {
84         require(!transactions[transactionId].executed);
85         _;
86     }
87     modifier notNull(address _address) {
88         require(_address != 0);
89         _;
90     }
91     modifier validRequirement(uint ownerCount, uint _required) {
92         require(ownerCount < MAX_OWNER_COUNT
93             && _required <= ownerCount
94             && _required != 0
95             && ownerCount != 0);
96         _;
97     }
98 
99     /// @dev Fallback function allows to deposit ether.
100     function() public payable {
101         if (msg.value > 0)
102             Deposit(msg.sender, msg.value);
103     }
104 
105     /*
106      * Public functions
107      */
108     /// @dev Contract constructor sets initial owners and required number of confirmations.
109     /// @param _owners List of initial owners.
110     /// @param _required Number of required confirmations.
111     function MultiSigWallet(address[] _owners, uint _required)
112         public
113         validRequirement(_owners.length, _required)
114     {
115         for (uint i=0; i<_owners.length; i++) {
116             require(!isOwner[_owners[i]] && _owners[i] != 0);
117             isOwner[_owners[i]] = true;
118         }
119         owners = _owners;
120         required = _required;
121         owner = msg.sender;
122     }
123 
124     function setToken(address _token)
125     public
126     onlyOwner
127     {
128         require(token == address(0));
129         
130         token = IToken(_token);
131     }
132 
133     //---------------- TGE SETTINGS -----------
134     /// @dev Sends request to change settings
135     /// @return Transaction ID
136     function tgeSettingsChangeRequest(
137         uint amount, 
138         uint partInvestor,
139         uint partProject, 
140         uint partFounders, 
141         uint blocksPerStage, 
142         uint partInvestorIncreasePerStage,
143         uint maxStages
144     ) 
145     public
146     ownerExists(msg.sender)
147     returns (uint _txIndex) 
148     {
149         assert(amount*partInvestor*partProject*blocksPerStage*partInvestorIncreasePerStage*maxStages != 0); //asserting no parameter is zero except partFounders
150         _txIndex = settingsRequestsCount;
151         settingsRequests[_txIndex] = SettingsRequest({
152             amount: amount,
153             partInvestor: partInvestor,
154             partProject: partProject,
155             partFounders: partFounders,
156             blocksPerStage: blocksPerStage,
157             partInvestorIncreasePerStage: partInvestorIncreasePerStage,
158             maxStages: maxStages,
159             executed: false
160         });
161         settingsRequestsCount++;
162         return _txIndex;
163     }
164     /// @dev Allows an owner to confirm a change settings request.
165     /// @param _txIndex Transaction ID.
166     function confirmSettingsChange(uint _txIndex) 
167     public
168     ownerExists(msg.sender) 
169     returns(bool success)
170     {
171         require(settingsRequests[_txIndex].executed == false);
172 
173         settingsRequests[_txIndex].confirmations[msg.sender] = true;
174         if(isConfirmedSettingsRequest(_txIndex)){
175             SettingsRequest storage request = settingsRequests[_txIndex];
176             request.executed = true;
177             IToken(token).executeSettingsChange(
178                 request.amount, 
179                 request.partInvestor,
180                 request.partProject,
181                 request.partFounders,
182                 request.blocksPerStage,
183                 request.partInvestorIncreasePerStage,
184                 request.maxStages
185             );
186             return true;
187         } else {
188             return false;
189         }
190     }
191     function isConfirmedSettingsRequest(uint transactionId)
192     public
193     constant
194     returns (bool)
195     {
196         uint count = 0;
197         for (uint i = 0; i < owners.length; i++) {
198             if (settingsRequests[transactionId].confirmations[owners[i]])
199                 count += 1;
200             if (count == required)
201                 return true;
202         }
203         return false;
204     }
205 
206     function getSettingChangeConfirmationCount(uint _txIndex)
207         public
208         constant
209         returns (uint count)
210     {
211         for (uint i=0; i<owners.length; i++)
212             if (settingsRequests[_txIndex].confirmations[owners[i]])
213                 count += 1;
214     }
215 
216     /// @dev Shows what settings were requested in a settings change request
217     function viewSettingsChange(uint _txIndex) 
218     public
219     ownerExists(msg.sender)  
220     returns (uint amount, uint partInvestor, uint partProject, uint partFounders, uint blocksPerStage, uint partInvestorIncreasePerStage, uint maxStages) {
221         SettingsRequest storage request = settingsRequests[_txIndex];
222         return (
223             request.amount,
224             request.partInvestor, 
225             request.partProject,
226             request.partFounders,
227             request.blocksPerStage,
228             request.partInvestorIncreasePerStage,
229             request.maxStages
230         );
231     }
232 
233     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
234     /// @param owner Address of new owner.
235     function addOwner(address owner)
236         public
237         onlyWallet
238         ownerDoesNotExist(owner)
239         notNull(owner)
240         validRequirement(owners.length + 1, required)
241     {
242         isOwner[owner] = true;
243         owners.push(owner);
244         OwnerAddition(owner);
245     }
246     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
247     /// @param owner Address of owner.
248     function removeOwner(address owner)
249         public
250         onlyWallet
251         ownerExists(owner)
252     {
253         isOwner[owner] = false;
254         for (uint i=0; i<owners.length - 1; i++)
255             if (owners[i] == owner) {
256                 owners[i] = owners[owners.length - 1];
257                 break;
258             }
259         owners.length -= 1;
260         if (required > owners.length)
261             changeRequirement(owners.length);
262         OwnerRemoval(owner);
263     }
264     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
265     /// @param owner Address of owner to be replaced.
266     /// @param owner Address of new owner.
267     function replaceOwner(address owner, address newOwner)
268         public
269         onlyWallet
270         ownerExists(owner)
271         ownerDoesNotExist(newOwner)
272     {
273         for (uint i=0; i<owners.length; i++)
274             if (owners[i] == owner) {
275                 owners[i] = newOwner;
276                 break;
277             }
278         isOwner[owner] = false;
279         isOwner[newOwner] = true;
280         OwnerRemoval(owner);
281         OwnerAddition(newOwner);
282     }
283     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
284     /// @param _required Number of required confirmations.
285     function changeRequirement(uint _required)
286         public
287         onlyWallet
288         validRequirement(owners.length, _required)
289     {
290         required = _required;
291         RequirementChange(_required);
292     }
293     /// @dev Allows an owner to submit and confirm a transaction.
294     /// @param destination Transaction target address.
295     /// @param value Transaction ether value.
296     /// @param data Transaction data payload.
297     /// @return Returns transaction ID.
298     function submitTransaction(address destination, uint value, bytes data)
299         public
300         ownerExists(msg.sender)
301         notNull(destination)
302         returns (uint transactionId)
303     {
304         transactionId = addTransaction(destination, value, data);
305         confirmTransaction(transactionId);
306     }
307 
308     function setFinishedTx(address destination)
309         public
310         ownerExists(msg.sender)
311         notNull(destination)
312         returns(uint transactionId)
313     {
314         transactionId = addTransaction(destination, 0, hex"64f65cc0");
315         confirmTransaction(transactionId);
316     }
317 
318     function setLiveTx(address destination)
319         public
320         ownerExists(msg.sender)
321         notNull(destination)
322         returns(uint transactionId)
323     {
324         transactionId = addTransaction(destination, 0, hex"9d0714b2");
325         confirmTransaction(transactionId);
326     }
327 
328     function setFreezeTx(address destination)
329         ownerExists(msg.sender)
330         notNull(destination)
331         returns(uint transactionId)
332     {
333         transactionId = addTransaction(destination, 0, hex"2c8cbe40");
334         confirmTransaction(transactionId);
335     }
336     /// @dev Allows an owner to confirm a transaction.
337     /// @param transactionId Transaction ID.
338     function confirmTransaction(uint transactionId)
339         public
340         ownerExists(msg.sender)
341         transactionExists(transactionId)
342         notConfirmed(transactionId, msg.sender)
343     {
344         confirmations[transactionId][msg.sender] = true;
345         Confirmation(msg.sender, transactionId);
346         executeTransaction(transactionId);
347     }
348     /// @dev Allows an owner to revoke a confirmation for a transaction.
349     /// @param transactionId Transaction ID.
350     function revokeConfirmation(uint transactionId)
351         public
352         ownerExists(msg.sender)
353         confirmed(transactionId, msg.sender)
354         notExecuted(transactionId)
355     {
356         confirmations[transactionId][msg.sender] = false;
357         Revocation(msg.sender, transactionId);
358     }
359     /// @dev Allows anyone to execute a confirmed transaction.
360     /// @param transactionId Transaction ID.
361     function executeTransaction(uint transactionId)
362         public
363         notExecuted(transactionId)
364     {
365         if (isConfirmed(transactionId)) {
366             Transaction tx = transactions[transactionId];
367             tx.executed = true;
368             if (tx.destination.call.value(tx.value)(tx.data))
369                 Execution(transactionId);
370             else {
371                 ExecutionFailure(transactionId);
372                 tx.executed = false;
373             }
374         }
375     }
376     /// @dev Returns the confirmation status of a transaction.
377     /// @param transactionId Transaction ID.
378     /// @return Confirmation status.
379     function isConfirmed(uint transactionId)
380         public
381         constant
382         returns (bool)
383     {
384         uint count = 0;
385         for (uint i=0; i<owners.length; i++) {
386             if (confirmations[transactionId][owners[i]])
387                 count += 1;
388             if (count == required)
389                 return true;
390         }
391         return false;
392     }
393     /*
394      * Internal functions
395      */
396     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
397     /// @param destination Transaction target address.
398     /// @param value Transaction ether value.
399     /// @param data Transaction data payload.
400     /// @return Returns transaction ID.
401     function addTransaction(address destination, uint value, bytes data)
402         internal
403         returns (uint transactionId)
404     {
405         transactionId = transactionCount;
406         transactions[transactionId] = Transaction({
407             destination: destination,
408             value: value,
409             data: data,
410             executed: false
411         });
412         transactionCount += 1;
413         Submission(transactionId);
414     }
415 
416     /*
417      * Web3 call functions
418      */
419     /// @dev Returns number of confirmations of a transaction.
420     /// @param transactionId Transaction ID.
421     /// @return Number of confirmations.
422     function getConfirmationCount(uint transactionId)
423         public
424         constant
425         returns (uint count)
426     {
427         for (uint i=0; i<owners.length; i++)
428             if (confirmations[transactionId][owners[i]])
429                 count += 1;
430     }
431 
432     /// @dev Returns total number of transactions after filers are applied.
433     /// @param pending Include pending transactions.
434     /// @param executed Include executed transactions.
435     /// @return Total number of transactions after filters are applied.
436     function getTransactionCount(bool pending, bool executed)
437         public
438         constant
439         returns (uint count)
440     {
441         for (uint i=0; i<transactionCount; i++)
442             if (   pending && !transactions[i].executed
443                 || executed && transactions[i].executed)
444                 count += 1;
445     }
446 
447     /// @dev Returns list of owners.
448     /// @return List of owner addresses.
449     function getOwners()
450         public
451         constant
452         returns (address[])
453     {
454         return owners;
455     }
456 
457     /// @dev Returns array with owner addresses, which confirmed transaction.
458     /// @param transactionId Transaction ID.
459     /// @return Returns array of owner addresses.
460     function getConfirmations(uint transactionId)
461         public
462         constant
463         returns (address[] _confirmations)
464     {
465         address[] memory confirmationsTemp = new address[](owners.length);
466         uint count = 0;
467         uint i;
468         for (i=0; i<owners.length; i++)
469             if (confirmations[transactionId][owners[i]]) {
470                 confirmationsTemp[count] = owners[i];
471                 count += 1;
472             }
473         _confirmations = new address[](count);
474         for (i=0; i<count; i++)
475             _confirmations[i] = confirmationsTemp[i];
476     }
477 
478     /// @dev Returns list of transaction IDs in defined range.
479     /// @param from Index start position of transaction array.
480     /// @param to Index end position of transaction array.
481     /// @param pending Include pending transactions.
482     /// @param executed Include executed transactions.
483     /// @return Returns array of transaction IDs.
484     function getTransactionIds(uint from, uint to, bool pending, bool executed)
485         public
486         constant
487         returns (uint[] _transactionIds)
488     {
489         uint[] memory transactionIdsTemp = new uint[](transactionCount);
490         uint count = 0;
491         uint i;
492         for (i=from; i<transactionCount; i++)
493             if (   pending && !transactions[i].executed
494                 || executed && transactions[i].executed)
495             {
496                 transactionIdsTemp[count] = i;
497                 count += 1;
498             }
499         _transactionIds = new uint[](to - from);
500         for (i=from; i<to; i++)
501             _transactionIds[i - from] = transactionIdsTemp[i];
502     }
503 }
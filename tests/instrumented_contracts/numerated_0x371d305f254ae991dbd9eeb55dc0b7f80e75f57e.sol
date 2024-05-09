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
219     constant
220     ownerExists(msg.sender)  
221     returns (uint amount, uint partInvestor, uint partProject, uint partFounders, uint blocksPerStage, uint partInvestorIncreasePerStage, uint maxStages) {
222         SettingsRequest storage request = settingsRequests[_txIndex];
223         return (
224             request.amount,
225             request.partInvestor, 
226             request.partProject,
227             request.partFounders,
228             request.blocksPerStage,
229             request.partInvestorIncreasePerStage,
230             request.maxStages
231         );
232     }
233 
234     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
235     /// @param owner Address of new owner.
236     function addOwner(address owner)
237         public
238         onlyWallet
239         ownerDoesNotExist(owner)
240         notNull(owner)
241         validRequirement(owners.length + 1, required)
242     {
243         isOwner[owner] = true;
244         owners.push(owner);
245         OwnerAddition(owner);
246     }
247     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
248     /// @param owner Address of owner.
249     function removeOwner(address owner)
250         public
251         onlyWallet
252         ownerExists(owner)
253     {
254         isOwner[owner] = false;
255         for (uint i=0; i<owners.length - 1; i++)
256             if (owners[i] == owner) {
257                 owners[i] = owners[owners.length - 1];
258                 break;
259             }
260         owners.length -= 1;
261         if (required > owners.length)
262             changeRequirement(owners.length);
263         OwnerRemoval(owner);
264     }
265     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
266     /// @param owner Address of owner to be replaced.
267     /// @param owner Address of new owner.
268     function replaceOwner(address owner, address newOwner)
269         public
270         onlyWallet
271         ownerExists(owner)
272         ownerDoesNotExist(newOwner)
273     {
274         for (uint i=0; i<owners.length; i++)
275             if (owners[i] == owner) {
276                 owners[i] = newOwner;
277                 break;
278             }
279         isOwner[owner] = false;
280         isOwner[newOwner] = true;
281         OwnerRemoval(owner);
282         OwnerAddition(newOwner);
283     }
284     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
285     /// @param _required Number of required confirmations.
286     function changeRequirement(uint _required)
287         public
288         onlyWallet
289         validRequirement(owners.length, _required)
290     {
291         required = _required;
292         RequirementChange(_required);
293     }
294     /// @dev Allows an owner to submit and confirm a transaction.
295     /// @param destination Transaction target address.
296     /// @param value Transaction ether value.
297     /// @param data Transaction data payload.
298     /// @return Returns transaction ID.
299     function submitTransaction(address destination, uint value, bytes data)
300         public
301         ownerExists(msg.sender)
302         notNull(destination)
303         returns (uint transactionId)
304     {
305         transactionId = addTransaction(destination, value, data);
306         confirmTransaction(transactionId);
307     }
308 
309     function setFinishedTx(address destination)
310         public
311         ownerExists(msg.sender)
312         notNull(destination)
313         returns(uint transactionId)
314     {
315         transactionId = addTransaction(destination, 0, hex"64f65cc0");
316         confirmTransaction(transactionId);
317     }
318 
319     function setLiveTx(address destination)
320         public
321         ownerExists(msg.sender)
322         notNull(destination)
323         returns(uint transactionId)
324     {
325         transactionId = addTransaction(destination, 0, hex"9d0714b2");
326         confirmTransaction(transactionId);
327     }
328 
329     function setFreezeTx(address destination)
330         ownerExists(msg.sender)
331         notNull(destination)
332         returns(uint transactionId)
333     {
334         transactionId = addTransaction(destination, 0, hex"2c8cbe40");
335         confirmTransaction(transactionId);
336     }
337     /// @dev Allows an owner to confirm a transaction.
338     /// @param transactionId Transaction ID.
339     function confirmTransaction(uint transactionId)
340         public
341         ownerExists(msg.sender)
342         transactionExists(transactionId)
343         notConfirmed(transactionId, msg.sender)
344     {
345         confirmations[transactionId][msg.sender] = true;
346         Confirmation(msg.sender, transactionId);
347         executeTransaction(transactionId);
348     }
349     /// @dev Allows an owner to revoke a confirmation for a transaction.
350     /// @param transactionId Transaction ID.
351     function revokeConfirmation(uint transactionId)
352         public
353         ownerExists(msg.sender)
354         confirmed(transactionId, msg.sender)
355         notExecuted(transactionId)
356     {
357         confirmations[transactionId][msg.sender] = false;
358         Revocation(msg.sender, transactionId);
359     }
360     /// @dev Allows anyone to execute a confirmed transaction.
361     /// @param transactionId Transaction ID.
362     function executeTransaction(uint transactionId)
363         public
364         notExecuted(transactionId)
365     {
366         if (isConfirmed(transactionId)) {
367             Transaction tx = transactions[transactionId];
368             tx.executed = true;
369             if (tx.destination.call.value(tx.value)(tx.data))
370                 Execution(transactionId);
371             else {
372                 ExecutionFailure(transactionId);
373                 tx.executed = false;
374             }
375         }
376     }
377     /// @dev Returns the confirmation status of a transaction.
378     /// @param transactionId Transaction ID.
379     /// @return Confirmation status.
380     function isConfirmed(uint transactionId)
381         public
382         constant
383         returns (bool)
384     {
385         uint count = 0;
386         for (uint i=0; i<owners.length; i++) {
387             if (confirmations[transactionId][owners[i]])
388                 count += 1;
389             if (count == required)
390                 return true;
391         }
392         return false;
393     }
394     /*
395      * Internal functions
396      */
397     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
398     /// @param destination Transaction target address.
399     /// @param value Transaction ether value.
400     /// @param data Transaction data payload.
401     /// @return Returns transaction ID.
402     function addTransaction(address destination, uint value, bytes data)
403         internal
404         returns (uint transactionId)
405     {
406         transactionId = transactionCount;
407         transactions[transactionId] = Transaction({
408             destination: destination,
409             value: value,
410             data: data,
411             executed: false
412         });
413         transactionCount += 1;
414         Submission(transactionId);
415     }
416 
417     /*
418      * Web3 call functions
419      */
420     /// @dev Returns number of confirmations of a transaction.
421     /// @param transactionId Transaction ID.
422     /// @return Number of confirmations.
423     function getConfirmationCount(uint transactionId)
424         public
425         constant
426         returns (uint count)
427     {
428         for (uint i=0; i<owners.length; i++)
429             if (confirmations[transactionId][owners[i]])
430                 count += 1;
431     }
432 
433     /// @dev Returns total number of transactions after filers are applied.
434     /// @param pending Include pending transactions.
435     /// @param executed Include executed transactions.
436     /// @return Total number of transactions after filters are applied.
437     function getTransactionCount(bool pending, bool executed)
438         public
439         constant
440         returns (uint count)
441     {
442         for (uint i=0; i<transactionCount; i++)
443             if (   pending && !transactions[i].executed
444                 || executed && transactions[i].executed)
445                 count += 1;
446     }
447 
448     /// @dev Returns list of owners.
449     /// @return List of owner addresses.
450     function getOwners()
451         public
452         constant
453         returns (address[])
454     {
455         return owners;
456     }
457 
458     /// @dev Returns array with owner addresses, which confirmed transaction.
459     /// @param transactionId Transaction ID.
460     /// @return Returns array of owner addresses.
461     function getConfirmations(uint transactionId)
462         public
463         constant
464         returns (address[] _confirmations)
465     {
466         address[] memory confirmationsTemp = new address[](owners.length);
467         uint count = 0;
468         uint i;
469         for (i=0; i<owners.length; i++)
470             if (confirmations[transactionId][owners[i]]) {
471                 confirmationsTemp[count] = owners[i];
472                 count += 1;
473             }
474         _confirmations = new address[](count);
475         for (i=0; i<count; i++)
476             _confirmations[i] = confirmationsTemp[i];
477     }
478 
479     /// @dev Returns list of transaction IDs in defined range.
480     /// @param from Index start position of transaction array.
481     /// @param to Index end position of transaction array.
482     /// @param pending Include pending transactions.
483     /// @param executed Include executed transactions.
484     /// @return Returns array of transaction IDs.
485     function getTransactionIds(uint from, uint to, bool pending, bool executed)
486         public
487         constant
488         returns (uint[] _transactionIds)
489     {
490         uint[] memory transactionIdsTemp = new uint[](transactionCount);
491         uint count = 0;
492         uint i;
493         for (i=from; i<transactionCount; i++)
494             if (   pending && !transactions[i].executed
495                 || executed && transactions[i].executed)
496             {
497                 transactionIdsTemp[count] = i;
498                 count += 1;
499             }
500         _transactionIds = new uint[](to - from);
501         for (i=from; i<to; i++)
502             _transactionIds[i - from] = transactionIdsTemp[i];
503     }
504 }
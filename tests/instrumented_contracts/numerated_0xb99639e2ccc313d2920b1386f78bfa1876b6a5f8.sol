1 pragma solidity ^0.4.18;
2 
3 contract IToken {
4     function executeSettingsChange(
5         uint amount, 
6         uint partInvestor,
7         uint partProject, 
8         uint partFounders, 
9         uint blocksPerStage, 
10         uint partInvestorIncreasePerStage,
11         uint maxStages
12     );
13 }
14 
15 
16 contract MultiSigWallet {
17 
18     uint constant public MAX_OWNER_COUNT = 50;
19     mapping (uint => Transaction) public transactions;
20     mapping (uint => mapping (address => bool)) public confirmations;
21     mapping (address => bool) public isOwner;
22     address[] public owners;
23     address owner; //the one who creates the contract, only this person can set the token
24     uint public required;
25     uint public transactionCount;
26 
27     event Confirmation(address indexed sender, uint indexed transactionId);
28     event Revocation(address indexed sender, uint indexed transactionId);
29     event Submission(uint indexed transactionId);
30     event Execution(uint indexed transactionId);
31     event ExecutionFailure(uint indexed transactionId);
32     event Deposit(address indexed sender, uint value);
33     event OwnerAddition(address indexed owner);
34     event OwnerRemoval(address indexed owner);
35     event RequirementChange(uint required);
36    
37     IToken public token;
38 
39     struct SettingsRequest {
40         uint amount;
41         uint partInvestor;
42         uint partProject;
43         uint partFounders;
44         uint blocksPerStage;
45         uint partInvestorIncreasePerStage;
46         uint maxStages;
47         bool executed;
48         mapping(address => bool) confirmations;
49     }
50 
51     uint settingsRequestsCount = 0;
52     mapping(uint => SettingsRequest) settingsRequests;
53 
54     struct Transaction { 
55         address destination;
56         uint value;
57         bytes data;
58         bool executed;
59     }
60 
61     modifier onlyWallet() {
62         require(msg.sender == address(this));
63         _;
64     }
65 
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70     
71     modifier ownerDoesNotExist(address _owner) {
72         require(!isOwner[_owner]);
73         _;
74     }
75     
76     modifier ownerExists(address _owner) {
77         require(isOwner[_owner]);
78         _;
79     }
80 
81     modifier transactionExists(uint _transactionId) {
82         require(transactions[_transactionId].destination != 0);
83         _;
84     }
85 
86     modifier confirmed(uint _transactionId, address _owner) {
87         require(confirmations[_transactionId][_owner]);
88         _;
89     }
90 
91     modifier notConfirmed(uint _transactionId, address _owner) {
92         require(!confirmations[_transactionId][_owner]);
93         _;
94     }
95 
96     modifier notExecuted(uint _transactionId) {
97         require(!transactions[_transactionId].executed);
98         _;
99     }
100 
101     modifier notNull(address _address) {
102         require(_address != 0);
103         _;
104     }
105 
106     modifier validRequirement(uint ownerCount, uint _required) {
107         require(ownerCount < MAX_OWNER_COUNT
108             && _required <= ownerCount
109             && _required != 0
110             && ownerCount != 0);
111         _;
112     }
113 
114     /// @dev Fallback function allows to deposit ether.
115     function() public payable {
116         if (msg.value > 0)
117             Deposit(msg.sender, msg.value);
118     }
119 
120     /// @dev Contract constructor sets initial owners and required number of confirmations.
121     /// @param _owners List of initial owners.
122     /// @param _required Number of required confirmations.
123     function MultiSigWallet(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
124         for (uint i=0; i<_owners.length; i++) {
125             require(!isOwner[_owners[i]] && _owners[i] != 0);
126             isOwner[_owners[i]] = true;
127         }
128         owners = _owners;
129         required = _required;
130         owner = msg.sender;
131     }
132 
133     function setToken(address _token) public onlyOwner {
134         require(token == address(0));
135         token = IToken(_token);
136     }
137 
138     //---------------- TGE SETTINGS -----------
139     /// @dev Sends request to change settings
140     /// @return Transaction ID
141     function tgeSettingsChangeRequest(
142         uint amount, 
143         uint partInvestor,
144         uint partProject, 
145         uint partFounders, 
146         uint blocksPerStage, 
147         uint partInvestorIncreasePerStage,
148         uint maxStages
149     ) 
150     public
151     ownerExists(msg.sender)
152     returns (uint _txIndex) 
153     {
154         assert(amount*partInvestor*partProject*blocksPerStage*partInvestorIncreasePerStage*maxStages != 0); //asserting no parameter is zero except partFounders
155         _txIndex = settingsRequestsCount;
156         settingsRequests[_txIndex] = SettingsRequest({
157             amount: amount,
158             partInvestor: partInvestor,
159             partProject: partProject,
160             partFounders: partFounders,
161             blocksPerStage: blocksPerStage,
162             partInvestorIncreasePerStage: partInvestorIncreasePerStage,
163             maxStages: maxStages,
164             executed: false
165         });
166         settingsRequestsCount++;
167         confirmSettingsChange(_txIndex);
168         return _txIndex;
169     }
170 
171     /// @dev Allows an owner to confirm a change settings request.
172     /// @param _txIndex Transaction ID.
173     function confirmSettingsChange(uint _txIndex) public ownerExists(msg.sender) returns(bool success) {
174         require(settingsRequests[_txIndex].executed == false);
175         settingsRequests[_txIndex].confirmations[msg.sender] = true;
176         if(isConfirmedSettingsRequest(_txIndex)){
177             SettingsRequest storage request = settingsRequests[_txIndex];
178             request.executed = true;
179             IToken(token).executeSettingsChange(
180                 request.amount, 
181                 request.partInvestor,
182                 request.partProject,
183                 request.partFounders,
184                 request.blocksPerStage,
185                 request.partInvestorIncreasePerStage,
186                 request.maxStages
187             );
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     function isConfirmedSettingsRequest(uint transactionId) public view returns (bool) {
195         uint count = 0;
196         for (uint i = 0; i < owners.length; i++) {
197             if (settingsRequests[transactionId].confirmations[owners[i]])
198                 count += 1;
199             if (count == required)
200                 return true;
201         }
202         return false;
203     }
204 
205     function getSettingsChangeConfirmationCount(uint _txIndex) public view returns (uint count) {
206         for (uint i=0; i<owners.length; i++)
207             if (settingsRequests[_txIndex].confirmations[owners[i]])
208                 count += 1;
209     }
210 
211     /// @dev Shows what settings were requested in a settings change request
212     function viewSettingsChange(uint _txIndex) public constant 
213     returns (uint amount, uint partInvestor, uint partProject, uint partFounders, uint blocksPerStage, uint partInvestorIncreasePerStage, uint maxStages) {
214         SettingsRequest memory request = settingsRequests[_txIndex];
215         return (
216             request.amount,
217             request.partInvestor, 
218             request.partProject,
219             request.partFounders,
220             request.blocksPerStage,
221             request.partInvestorIncreasePerStage,
222             request.maxStages
223         );
224     }
225 
226     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
227     /// @param _owner Address of new owner.
228     function addOwner(address _owner)
229         public
230         onlyWallet
231         ownerDoesNotExist(_owner)
232         notNull(_owner)
233         validRequirement(owners.length + 1, required)
234     {
235         isOwner[owner] = true;
236         owners.push(_owner);
237         OwnerAddition(_owner);
238     }
239     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
240     /// @param _owner Address of owner.
241     function removeOwner(address _owner)
242         public
243         onlyWallet
244         ownerExists(_owner)
245     {
246         isOwner[_owner] = false;
247         for (uint i=0; i<owners.length - 1; i++)
248             if (owners[i] == _owner) {
249                 owners[i] = owners[owners.length - 1];
250                 break;
251             }
252         owners.length -= 1;
253         if (required > owners.length)
254             changeRequirement(owners.length);
255         OwnerRemoval(_owner);
256     }
257 
258     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
259     /// @param _owner Address of owner to be replaced.
260     /// @param _newOwner Address of new owner.
261     function replaceOwner(address _owner, address _newOwner)
262         public
263         onlyWallet
264         ownerExists(_owner)
265         ownerDoesNotExist(_newOwner)
266     {
267         for (uint i=0; i<owners.length; i++)
268             if (owners[i] == _owner) {
269                 owners[i] = _newOwner;
270                 break;
271             }
272         isOwner[_owner] = false;
273         isOwner[_newOwner] = true;
274         OwnerRemoval(_owner);
275         OwnerAddition(_newOwner);
276     }
277 
278     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
279     /// @param _required Number of required confirmations.
280     function changeRequirement(uint _required) public onlyWallet validRequirement(owners.length, _required) {
281         required = _required;
282         RequirementChange(_required);
283     }
284 
285     function setFinishedTx() public ownerExists(msg.sender) returns(uint transactionId) {
286         transactionId = addTransaction(token, 0, hex"64f65cc0");
287         confirmTransaction(transactionId);
288     }
289 
290     function setLiveTx() public ownerExists(msg.sender) returns(uint transactionId) {
291         transactionId = addTransaction(token, 0, hex"9d0714b2");
292         confirmTransaction(transactionId);
293     }
294 
295     function setFreezeTx() public ownerExists(msg.sender) returns(uint transactionId) {
296         transactionId = addTransaction(token, 0, hex"2c8cbe40");
297         confirmTransaction(transactionId);
298     }
299 
300     /// @dev Allows an owner to submit and confirm a transaction.
301     /// @param destination Transaction target address.
302     /// @param value Transaction ether value.
303     /// @param data Transaction data payload.
304     /// @return Returns transaction ID.
305     function submitTransaction(address destination, uint value, bytes data) public
306         ownerExists(msg.sender)
307         notNull(destination)
308         returns (uint transactionId)
309     {
310         transactionId = addTransaction(destination, value, data);
311         confirmTransaction(transactionId);
312     }
313 
314     /// @dev Allows an owner to confirm a transaction.
315     /// @param transactionId Transaction ID.
316     function confirmTransaction(uint transactionId)
317         public
318         ownerExists(msg.sender)
319         transactionExists(transactionId)
320         notConfirmed(transactionId, msg.sender)
321     {
322         confirmations[transactionId][msg.sender] = true;
323         Confirmation(msg.sender, transactionId);
324         executeTransaction(transactionId);
325     }
326 
327     /// @dev Allows an owner to revoke a confirmation for a transaction.
328     /// @param transactionId Transaction ID.
329     function revokeConfirmation(uint transactionId)
330         public
331         ownerExists(msg.sender)
332         confirmed(transactionId, msg.sender)
333         notExecuted(transactionId)
334     {
335         confirmations[transactionId][msg.sender] = false;
336         Revocation(msg.sender, transactionId);
337     }
338 
339     /// @dev Allows anyone to execute a confirmed transaction.
340     /// @param _transactionId Transaction ID.
341     function executeTransaction(uint _transactionId) public notExecuted(_transactionId) {
342         if (isConfirmed(_transactionId)) {
343             Transaction storage trx = transactions[_transactionId];
344             trx.executed = true;
345             if (trx.destination.call.value(trx.value)(trx.data))
346                 Execution(_transactionId);
347             else {
348                 ExecutionFailure(_transactionId);
349                 trx.executed = false;
350             }
351         }
352     }
353 
354     /// @dev Returns the confirmation status of a transaction.
355     /// @param transactionId Transaction ID.
356     /// @return Confirmation status.
357     function isConfirmed(uint transactionId) public view returns (bool) {
358         uint count = 0;
359         for (uint i=0; i<owners.length; i++) {
360             if (confirmations[transactionId][owners[i]])
361                 count += 1;
362             if (count == required)
363                 return true;
364         }
365         return false;
366     }
367 
368     /*
369      * Internal functions
370      */
371 
372     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
373     /// @param destination Transaction target address.
374     /// @param value Transaction ether value.
375     /// @param data Transaction data payload.
376     /// @return Returns transaction ID.
377     function addTransaction(address destination, uint value, bytes data) internal returns (uint transactionId) {
378         transactionId = transactionCount;
379         transactions[transactionId] = Transaction({
380             destination: destination,
381             value: value,
382             data: data,
383             executed: false
384         });
385         transactionCount += 1;
386         Submission(transactionId);
387     }
388 
389     /*
390      * Web3 call functions
391     */
392 
393     /// @dev Returns number of confirmations of a transaction.
394     /// @param transactionId Transaction ID.
395     /// @return Number of confirmations.
396     function getConfirmationCount(uint transactionId) public constant returns (uint count) {
397         for (uint i=0; i<owners.length; i++)
398             if (confirmations[transactionId][owners[i]])
399                 count += 1;
400     }
401 
402     /// @dev Returns total number of transactions after filers are applied.
403     /// @param pending Include pending transactions.
404     /// @param executed Include executed transactions.
405     /// @return Total number of transactions after filters are applied.
406     function getTransactionCount(bool pending, bool executed) public constant returns (uint count) {
407         for (uint i=0; i<transactionCount; i++)
408             if (   pending && !transactions[i].executed
409                 || executed && transactions[i].executed)
410                 count += 1;
411     }
412 
413     /// @dev Returns list of owners.
414     /// @return List of owner addresses.
415     function getOwners() public constant returns (address[]) {
416         return owners;
417     }
418 
419     /// @dev Returns array with owner addresses, which confirmed transaction.
420     /// @param transactionId Transaction ID.
421     /// @return Returns array of owner addresses.
422     function getConfirmations(uint transactionId) public constant returns (address[] _confirmations) {
423         address[] memory confirmationsTemp = new address[](owners.length);
424         uint count = 0;
425         uint i;
426         for (i=0; i<owners.length; i++)
427             if (confirmations[transactionId][owners[i]]) {
428                 confirmationsTemp[count] = owners[i];
429                 count += 1;
430             }
431         _confirmations = new address[](count);
432         for (i=0; i<count; i++)
433             _confirmations[i] = confirmationsTemp[i];
434     }
435 
436     /// @dev Returns list of transaction IDs in defined range.
437     /// @param from Index start position of transaction array.
438     /// @param to Index end position of transaction array.
439     /// @param pending Include pending transactions.
440     /// @param executed Include executed transactions.
441     /// @return Returns array of transaction IDs.
442     function getTransactionIds(uint from, uint to, bool pending, bool executed) public constant returns (uint[] _transactionIds) {
443         uint[] memory transactionIdsTemp = new uint[](transactionCount);
444         uint count = 0;
445         uint i;
446         for (i=from; i<transactionCount; i++)
447             if (   pending && !transactions[i].executed
448                 || executed && transactions[i].executed)
449             {
450                 transactionIdsTemp[count] = i;
451                 count += 1;
452             }
453         _transactionIds = new uint[](to - from);
454         for (i=from; i<to; i++)
455             _transactionIds[i - from] = transactionIdsTemp[i];
456     }
457 
458 }
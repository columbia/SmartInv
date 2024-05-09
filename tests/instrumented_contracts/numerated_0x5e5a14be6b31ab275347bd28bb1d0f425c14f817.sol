1 //This file contains a multisignature wallet contract that is used to control the eRAY token contract:
2 // - to set the settings of token generation round
3 // - to start and to stop token generation round
4 // - to freeze the token upon creation of array.io blockchain
5 // - to send eRAY tokens from this wallet
6 // - to make arbitrary transaction in usual to multisignature wallet way
7 
8 // Elsewhere in other contracts or documentation this contract MAY be referenced as projectWallet
9 
10 // Authors: Alexander Shevtsov <randomlogin76@gmail.com>
11 //          Vladimir Bobrov <v@decenturygroup.com>
12 //          vladiuz1 <vs@array.io>
13 // License: see the repository file
14 // Last updated: 12 August 2018
15 pragma solidity ^0.4.22;
16 
17 //Interface for the token contract
18 contract IToken {
19     
20     address public whitelist;
21 
22     function executeSettingsChange(
23         uint amount, 
24         uint minimalContribution, 
25         uint partContributor,
26         uint partProject, 
27         uint partFounders, 
28         uint blocksPerStage, 
29         uint partContributorIncreasePerStage,
30         uint maxStages
31     );
32 }
33 
34 
35 contract MultiSigWallet {
36 
37     uint constant public MAX_OWNER_COUNT = 50;
38     mapping (uint => Transaction) public transactions;
39     mapping (uint => mapping (address => bool)) public confirmations;
40     mapping (address => bool) public isOwner;
41     address[] public owners;
42     address owner; //the one who creates the contract, only this person can set the token
43     uint public required;
44     uint public transactionCount;
45 
46     event Confirmation(address indexed sender, uint indexed transactionId);
47     event Revocation(address indexed sender, uint indexed transactionId);
48     event Submission(uint indexed transactionId);
49     event Execution(uint indexed transactionId);
50     event ExecutionFailure(uint indexed transactionId);
51     event Deposit(address indexed sender, uint value);
52     event OwnerAddition(address indexed owner);
53     event OwnerRemoval(address indexed owner);
54     event RequirementChange(uint required);
55    
56     IToken public token;
57 
58     struct SettingsRequest {
59         uint amount;
60         uint minimalContribution;
61         uint partContributor;
62         uint partProject;
63         uint partFounders;
64         uint blocksPerStage;
65         uint partContributorIncreasePerStage;
66         uint maxStages;
67         bool executed;
68         mapping(address => bool) confirmations;
69     }
70 
71     uint settingsRequestsCount = 0;
72     mapping(uint => SettingsRequest) settingsRequests;
73 
74     struct Transaction { 
75         address destination;
76         uint value;
77         bytes data;
78         bool executed;
79     }
80 
81     modifier onlyWallet() {
82         require(msg.sender == address(this));
83         _;
84     }
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90     
91     modifier ownerDoesNotExist(address _owner) {
92         require(!isOwner[_owner]);
93         _;
94     }
95     
96     modifier ownerExists(address _owner) {
97         require(isOwner[_owner]);
98         _;
99     }
100 
101     modifier transactionExists(uint _transactionId) {
102         require(transactions[_transactionId].destination != 0);
103         _;
104     }
105 
106     modifier confirmed(uint _transactionId, address _owner) {
107         require(confirmations[_transactionId][_owner]);
108         _;
109     }
110 
111     modifier notConfirmed(uint _transactionId, address _owner) {
112         require(!confirmations[_transactionId][_owner]);
113         _;
114     }
115 
116     modifier notExecuted(uint _transactionId) {
117         require(!transactions[_transactionId].executed);
118         _;
119     }
120 
121     modifier notNull(address _address) {
122         require(_address != 0);
123         _;
124     }
125 
126     modifier validRequirement(uint _ownerCount, uint _required) {
127         require(_ownerCount < MAX_OWNER_COUNT
128             && _required <= _ownerCount
129             && _required != 0
130             && _ownerCount != 0);
131         _;
132     }
133 
134     /// @dev Contract constructor sets initial owners and required number of confirmations.
135     /// @param _owners List of initial owners.
136     /// @param _required Number of required confirmations.
137     constructor(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
138         for (uint i=0; i<_owners.length; i++) {
139             require(!isOwner[_owners[i]] && _owners[i] != 0);
140             isOwner[_owners[i]] = true;
141         }
142         owners = _owners;
143         required = _required;
144         owner = msg.sender;
145     }
146 
147     /// @dev Fallback function allows to deposit ether.
148     function() public payable {
149         if (msg.value > 0)
150             emit Deposit(msg.sender, msg.value);
151     }
152 
153     function setToken(address _token) public onlyOwner {
154         require(token == address(0));
155         token = IToken(_token);
156     }
157 
158     //---------------- TGR SETTINGS -----------
159     /// @dev Sends request to change settings
160     /// @return Transaction ID
161     function tgrSettingsChangeRequest(
162         uint amount, 
163         uint minimalContribution,
164         uint partContributor,
165         uint partProject, 
166         uint partFounders, 
167         uint blocksPerStage, 
168         uint partContributorIncreasePerStage,
169         uint maxStages
170     ) 
171     public
172     ownerExists(msg.sender)
173     returns (uint _txIndex) 
174     {
175         assert(amount*partContributor*partProject*blocksPerStage*partContributorIncreasePerStage*maxStages != 0); //asserting no parameter is zero except partFounders
176         assert(amount >= 1 ether);
177         _txIndex = settingsRequestsCount;
178         settingsRequests[_txIndex] = SettingsRequest({
179             amount: amount,
180             minimalContribution: minimalContribution,
181             partContributor: partContributor,
182             partProject: partProject,
183             partFounders: partFounders,
184             blocksPerStage: blocksPerStage,
185             partContributorIncreasePerStage: partContributorIncreasePerStage,
186             maxStages: maxStages,
187             executed: false
188         });
189         settingsRequestsCount++;
190         confirmSettingsChange(_txIndex);
191         return _txIndex;
192     }
193 
194     /// @dev Allows an owner to confirm a change settings request.
195     /// @param _txIndex Transaction ID.
196     function confirmSettingsChange(uint _txIndex) public ownerExists(msg.sender) returns(bool success) {
197         require(settingsRequests[_txIndex].executed == false);
198         settingsRequests[_txIndex].confirmations[msg.sender] = true;
199         if(isConfirmedSettingsRequest(_txIndex)){
200             SettingsRequest storage request = settingsRequests[_txIndex];
201             request.executed = true;
202             IToken(token).executeSettingsChange(
203                 request.amount, 
204                 request.minimalContribution, 
205                 request.partContributor,
206                 request.partProject,
207                 request.partFounders,
208                 request.blocksPerStage,
209                 request.partContributorIncreasePerStage,
210                 request.maxStages
211             );
212             return true;
213         } else {
214             return false;
215         }
216     }
217 
218     function setFinishedTx() public ownerExists(msg.sender) returns(uint transactionId) {
219         transactionId = addTransaction(token, 0, hex"ce5e6393");
220         confirmTransaction(transactionId);
221     }
222 
223     function setLiveTx() public ownerExists(msg.sender) returns(uint transactionId) {
224         transactionId = addTransaction(token, 0, hex"29745306");
225         confirmTransaction(transactionId);
226     }
227 
228     function setFreezeTx() public ownerExists(msg.sender) returns(uint transactionId) {
229         transactionId = addTransaction(token, 0, hex"2c8cbe40");
230         confirmTransaction(transactionId);
231     }
232 
233     function transferTx(address _to, uint _value) public ownerExists(msg.sender) returns(uint transactionId) {
234         //I rather seldom wish pain to other people, but solidity developers may be an exception.
235         bytes memory calldata = new bytes(68); 
236         calldata[0] = byte(hex"a9");
237         calldata[1] = byte(hex"05");
238         calldata[2] = byte(hex"9c");
239         calldata[3] = byte(hex"bb");
240         //When I wrote these lines my eyes were bleeding.
241         bytes32 val = bytes32(_value);
242         bytes32 dest = bytes32(_to);
243         //I spent a day for this function, because my fingers made a fist.
244         for(uint j=0; j<32; j++) {
245             calldata[j+4]=dest[j];
246         }
247         //Oh, reader! I hope you forget it like a bad nightmare.
248         for(uint i=0; i<32; i++) {
249             calldata[i+36]=val[i];
250         }
251         //Stil the ghost of this code will haunt you.
252         transactionId = addTransaction(token, 0, calldata);
253         confirmTransaction(transactionId);
254         //I haven't mentioned that it's the most elegant solution for 0.4.20 compiler, which doesn't require rewriting all this shitty code.
255         //Enjoy.
256     }
257 
258     function setWhitelistTx(address _whitelist) public ownerExists(msg.sender) returns(uint transactionId) {
259         bytes memory calldata = new bytes(36);
260         calldata[0] = byte(hex"85");
261         calldata[1] = byte(hex"4c");
262         calldata[2] = byte(hex"ff");
263         calldata[3] = byte(hex"2f");
264         bytes32 dest = bytes32(_whitelist);
265         for(uint j=0; j<32; j++) {
266             calldata[j+4]=dest[j];
267         }
268         transactionId = addTransaction(token, 0, calldata);
269         confirmTransaction(transactionId);
270     }
271 
272     //adds this address to the whitelist
273     function whitelistTx(address _address) public ownerExists(msg.sender) returns(uint transactionId) {
274         bytes memory calldata = new bytes(36);
275         calldata[0] = byte(hex"0a");
276         calldata[1] = byte(hex"3b");
277         calldata[2] = byte(hex"0a");
278         calldata[3] = byte(hex"4f");
279         bytes32 dest = bytes32(_address);
280         for(uint j=0; j<32; j++) {
281             calldata[j+4]=dest[j];
282         }
283         transactionId = addTransaction(token.whitelist(), 0, calldata);
284         confirmTransaction(transactionId);
285 
286     }
287 
288 //--------------------------Usual multisig functions for handling owners and transactions.
289 
290     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
291     /// @param _owner Address of new owner.
292     function addOwner(address _owner) public onlyWallet ownerDoesNotExist(_owner) notNull(_owner) validRequirement(owners.length + 1, required) {
293         isOwner[_owner] = true;
294         owners.push(_owner);
295         emit OwnerAddition(_owner);
296     }
297     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
298     /// @param _owner Address of owner.
299     function removeOwner(address _owner) public onlyWallet ownerExists(_owner) {
300         isOwner[_owner] = false;
301         for (uint i=0; i<owners.length - 1; i++)
302             if (owners[i] == _owner) {
303                 owners[i] = owners[owners.length - 1];
304                 break;
305             }
306         owners.length -= 1;
307         if (required > owners.length)
308             changeRequirement(owners.length);
309         emit OwnerRemoval(_owner);
310     }
311 
312     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
313     /// @param _owner Address of owner to be replaced.
314     /// @param _newOwner Address of new owner.
315     function replaceOwner(address _owner, address _newOwner) public onlyWallet ownerExists(_owner) ownerDoesNotExist(_newOwner) {
316         for (uint i=0; i<owners.length; i++)
317             if (owners[i] == _owner) {
318                 owners[i] = _newOwner;
319                 break;
320             }
321         isOwner[_owner] = false;
322         isOwner[_newOwner] = true;
323         emit OwnerRemoval(_owner);
324         emit OwnerAddition(_newOwner);
325     }
326 
327     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
328     /// @param _required Number of required confirmations.
329     function changeRequirement(uint _required) public onlyWallet validRequirement(owners.length, _required) {
330         required = _required;
331         emit RequirementChange(_required);
332     }
333 
334     /// @dev Allows an owner to submit and confirm a transaction.
335     /// @param destination Transaction target address.
336     /// @param value Transaction ether value.
337     /// @param data Transaction data payload.
338     /// @return Returns transaction ID.
339     function submitTransaction(address destination, uint value, bytes data) public ownerExists(msg.sender) notNull(destination) returns (uint transactionId) {
340         transactionId = addTransaction(destination, value, data);
341         confirmTransaction(transactionId);
342     }
343 
344     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
345     /// @param destination Transaction target address.
346     /// @param value Transaction ether value.
347     /// @param data Transaction data payload.
348     /// @return Returns transaction ID.
349     function addTransaction(address destination, uint value, bytes data) internal returns (uint transactionId) {
350         transactionId = transactionCount;
351         transactions[transactionId] = Transaction({
352             destination: destination,
353             value: value,
354             data: data,
355             executed: false
356         });
357         transactionCount += 1;
358         emit Submission(transactionId);
359     }
360 
361     /// @dev Allows an owner to confirm a transaction.
362     /// @param _transactionId Transaction ID.
363     function confirmTransaction(uint _transactionId) public ownerExists(msg.sender) transactionExists(_transactionId) notConfirmed(_transactionId, msg.sender) {
364         confirmations[_transactionId][msg.sender] = true;
365         emit Confirmation(msg.sender, _transactionId);
366         executeTransaction(_transactionId);
367     }
368 
369     //Will fail if calldata less than 4 bytes long. It's a feature, not a bug.
370     /// @dev Allows anyone to execute a confirmed transaction.
371     /// @param _transactionId Transaction ID.
372     function executeTransaction(uint _transactionId) public notExecuted(_transactionId) {
373         if (isConfirmed(_transactionId)) {
374             Transaction storage trx = transactions[_transactionId];
375             trx.executed = true;
376             //Just don't ask questions. It's needed. Believe me.
377 			bytes memory data = trx.data;
378             bytes memory calldata;
379             if (trx.data.length >= 4) {
380                 bytes4 signature;
381                 assembly {
382                     signature := mload(add(data, 32))
383                 }
384                 calldata = new bytes(trx.data.length-4);
385                 for (uint i = 0; i<calldata.length; i++) {
386                     calldata[i] = trx.data[i+4];
387                 }
388             }
389             else {
390                 calldata = new bytes(0);
391             }
392             if (trx.destination.call.value(trx.value)(signature, calldata))
393                 emit Execution(_transactionId);
394             else {
395                 emit ExecutionFailure(_transactionId);
396                 trx.executed = false;
397             }
398         }
399     }
400 
401     /// @dev Allows an owner to revoke a confirmation for a transaction.
402     /// @param _transactionId Transaction ID.
403     function revokeConfirmation(uint _transactionId) public ownerExists(msg.sender) confirmed(_transactionId, msg.sender) notExecuted(_transactionId) {
404         confirmations[_transactionId][msg.sender] = false;
405         emit Revocation(msg.sender, _transactionId);
406     }
407 
408     /// @dev Returns the confirmation status of a transaction.
409     /// @param _transactionId Transaction ID.
410     /// @return Confirmation status.
411     function isConfirmed(uint _transactionId) public view returns (bool) {
412         uint count = 0;
413         for (uint i=0; i<owners.length; i++) {
414             if (confirmations[_transactionId][owners[i]])
415                 count += 1;
416             if (count == required)
417                 return true;
418         }
419         return false;
420     }
421 
422 	function isConfirmedSettingsRequest(uint _transactionId) public view returns (bool) {
423 		uint count = 0;
424 		for (uint i = 0; i < owners.length; i++) {
425 			if (settingsRequests[_transactionId].confirmations[owners[i]])
426 				count += 1;
427 			if (count == required)
428 				return true;
429 		}
430 		return false;
431     }
432 
433     /// @dev Shows what settings were requested in a settings change request
434     function viewSettingsChange(uint _txIndex) public constant 
435     returns (uint amount, uint minimalContribution, uint partContributor, uint partProject, uint partFounders, uint blocksPerStage, uint partContributorIncreasePerStage, uint maxStages) {
436         SettingsRequest memory request = settingsRequests[_txIndex];
437         return (
438             request.amount,
439             request.minimalContribution,
440             request.partContributor, 
441             request.partProject,
442             request.partFounders,
443             request.blocksPerStage,
444             request.partContributorIncreasePerStage,
445             request.maxStages
446         );
447     }
448 
449     /// @dev Returns number of confirmations of a transaction.
450     /// @param _transactionId Transaction ID.
451     /// @return Number of confirmations.
452     function getConfirmationCount(uint _transactionId) public view returns (uint count) {
453         for (uint i=0; i<owners.length; i++)
454             if (confirmations[_transactionId][owners[i]])
455                 count += 1;
456     }
457 
458     function getSettingsChangeConfirmationCount(uint _txIndex) public view returns (uint count) {
459         for (uint i=0; i<owners.length; i++)
460             if (settingsRequests[_txIndex].confirmations[owners[i]])
461                 count += 1;
462     }
463 
464     /// @dev Returns total number of transactions after filers are applied.
465     /// @param pending Include pending transactions.
466     /// @param executed Include executed transactions.
467     /// @return Total number of transactions after filters are applied.
468     function getTransactionCount(bool pending, bool executed) public view returns (uint count) {
469         for (uint i=0; i<transactionCount; i++)
470             if (   pending && !transactions[i].executed
471                 || executed && transactions[i].executed)
472                 count += 1;
473     }
474 
475     /// @dev Returns list of owners.
476     /// @return List of owner addresses.
477     function getOwners() public view returns (address[]) {
478         return owners;
479     }
480 
481     /// @dev Returns array with owner addresses, which confirmed transaction.
482     /// @param _transactionId Transaction ID.
483     /// @return Returns array of owner addresses.
484     function getConfirmations(uint _transactionId) public view returns (address[] _confirmations) {
485         address[] memory confirmationsTemp = new address[](owners.length);
486         uint count = 0;
487         uint i;
488         for (i=0; i<owners.length; i++)
489             if (confirmations[_transactionId][owners[i]]) {
490                 confirmationsTemp[count] = owners[i];
491                 count += 1;
492             }
493         _confirmations = new address[](count);
494         for (i=0; i<count; i++)
495             _confirmations[i] = confirmationsTemp[i];
496     }
497 
498     /// @dev Returns list of transaction IDs in defined range.
499     /// @param from Index start position of transaction array.
500     /// @param to Index end position of transaction array.
501     /// @param pending Include pending transactions.
502     /// @param executed Include executed transactions.
503     /// @return Returns array of transaction IDs.
504     function getTransactionIds(uint from, uint to, bool pending, bool executed) public view returns (uint[] _transactionIds) {
505         uint[] memory transactionIdsTemp = new uint[](transactionCount);
506         uint count = 0;
507         uint i;
508         for (i=from; i<transactionCount; i++)
509             if (   pending && !transactions[i].executed
510                 || executed && transactions[i].executed)
511             {
512                 transactionIdsTemp[count] = i;
513                 count += 1;
514             }
515         _transactionIds = new uint[](to - from);
516         for (i=from; i<to; i++)
517             _transactionIds[i - from] = transactionIdsTemp[i];
518     }
519 
520 }
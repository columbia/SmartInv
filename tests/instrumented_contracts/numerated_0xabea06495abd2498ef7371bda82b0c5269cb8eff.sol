1 pragma solidity ^0.4.18;
2 
3 
4 /*============================================================================= */
5 /*=============================ERC721 interface==================================== */
6 /*============================================================================= */
7 
8 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
9 /// @author Yumin.yang
10 contract ERC721 {
11     // Required methods
12     function totalSupply() public view returns (uint256 total);
13     function balanceOf(address _owner) public view returns (uint256 balance);
14     //function ownerOf(uint256 _tokenId) external view returns (address owner);
15     //function approve(address _to, uint256 _tokenId) external;
16     function transfer(address _to, uint256 _tokenId) external;
17     //function transferFrom(address _from, address _to, uint256 _tokenId) external;
18 
19     // Events
20     event Transfer(address from, address to, uint256 tokenId);
21     //event Approval(address owner, address approved, uint256 tokenId);
22 
23 }
24 
25 
26 /*============================================================================= */
27 /*=============================Forever Rose==================================== */
28 /*============================================================================= */
29 
30 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
31 /// @author Yumin.yang
32 contract DivisibleForeverRose is ERC721 {
33   
34     //This contract's owner
35     address private contractOwner;
36 
37     
38     //Gift token storage.
39     mapping(uint => GiftToken) giftStorage;
40 
41     // Total supply of this token. 
42 	uint public totalSupply = 10; 
43 
44     bool public tradable = false;
45 
46     uint foreverRoseId = 1;
47 
48     // Divisibility of ownership over a token  
49 	mapping(address => mapping(uint => uint)) ownerToTokenShare;
50 
51 	// How much owners have of a token
52 	mapping(uint => mapping(address => uint)) tokenToOwnersHoldings;
53 
54     // If Forever Rose has been created
55 	mapping(uint => bool) foreverRoseCreated;
56 
57     string public name;  
58     string public symbol;           
59     uint8 public decimals = 1;                                 
60     string public version = "1.0";    
61 
62     //Special gift token
63     struct GiftToken {
64         uint256 giftId;
65     } 
66 
67     //@dev Constructor 
68     function DivisibleForeverRose() public {
69         contractOwner = msg.sender;
70         name = "ForeverRose";
71         symbol = "ROSE";  
72 
73         // Create Forever rose
74         GiftToken memory newGift = GiftToken({
75             giftId: foreverRoseId
76         });
77         giftStorage[foreverRoseId] = newGift;
78 
79         
80         foreverRoseCreated[foreverRoseId] = true;
81         _addNewOwnerHoldingsToToken(contractOwner, foreverRoseId, totalSupply);
82         _addShareToNewOwner(contractOwner, foreverRoseId, totalSupply);
83 
84     }
85     
86     // Fallback funciton
87     function() public {
88         revert();
89     }
90 
91     function totalSupply() public view returns (uint256 total) {
92         return totalSupply;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return ownerToTokenShare[_owner][foreverRoseId];
97     }
98 
99     // We use parameter '_tokenId' as the divisibility
100     function transfer(address _to, uint256 _tokenId) external {
101 
102         // Requiring this contract be tradable
103         require(tradable == true);
104 
105         require(_to != address(0));
106         require(msg.sender != _to);
107 
108         // Take _tokenId as divisibility
109         uint256 _divisibility = _tokenId;
110 
111         // Requiring msg.sender has Holdings of Forever rose
112         require(tokenToOwnersHoldings[foreverRoseId][msg.sender] >= _divisibility);
113 
114     
115         // Remove divisibilitys from old owner
116         _removeShareFromLastOwner(msg.sender, foreverRoseId, _divisibility);
117         _removeLastOwnerHoldingsFromToken(msg.sender, foreverRoseId, _divisibility);
118 
119         // Add divisibilitys to new owner
120         _addNewOwnerHoldingsToToken(_to, foreverRoseId, _divisibility);
121         _addShareToNewOwner(_to, foreverRoseId, _divisibility);
122 
123         // Trigger Ethereum Event
124         Transfer(msg.sender, _to, foreverRoseId);
125 
126     }
127 
128     // Transfer gift to a new owner.
129     function assignSharedOwnership(address _to, uint256 _divisibility)
130                                onlyOwner external returns (bool success) 
131                                {
132 
133         require(_to != address(0));
134         require(msg.sender != _to);
135         require(_to != address(this));
136         
137         // Requiring msg.sender has Holdings of Forever rose
138         require(tokenToOwnersHoldings[foreverRoseId][msg.sender] >= _divisibility);
139 
140         //Remove ownership from oldOwner(msg.sender)
141         _removeLastOwnerHoldingsFromToken(msg.sender, foreverRoseId, _divisibility);
142         _removeShareFromLastOwner(msg.sender, foreverRoseId, _divisibility);
143 
144          //Add ownership to NewOwner(address _to)
145         _addShareToNewOwner(_to, foreverRoseId, _divisibility); 
146         _addNewOwnerHoldingsToToken(_to, foreverRoseId, _divisibility);
147 
148         // Trigger Ethereum Event
149         Transfer(msg.sender, _to, foreverRoseId);
150 
151         return true;
152     }
153 
154     function getForeverRose() public view returns(uint256 _foreverRoseId) {
155         return giftStorage[foreverRoseId].giftId;
156     }
157 
158     // Turn on this contract to be tradable, so owners can transfer their token
159     function turnOnTradable() public onlyOwner {
160         tradable = true;
161     }
162     
163     // ------------------------------ Helper functions (internal functions) ------------------------------
164 
165 	// Add divisibility to new owner
166 	function _addShareToNewOwner(address _owner, uint _tokenId, uint _units) internal {
167 		ownerToTokenShare[_owner][_tokenId] += _units;
168 	}
169 
170 	
171 	// Add the divisibility to new owner
172 	function _addNewOwnerHoldingsToToken(address _owner, uint _tokenId, uint _units) internal {
173 		tokenToOwnersHoldings[_tokenId][_owner] += _units;
174 	}
175     
176     // Remove divisibility from last owner
177 	function _removeShareFromLastOwner(address _owner, uint _tokenId, uint _units) internal {
178 		ownerToTokenShare[_owner][_tokenId] -= _units;
179 	}
180     
181     // Remove divisibility from last owner 
182 	function _removeLastOwnerHoldingsFromToken(address _owner, uint _tokenId, uint _units) internal {
183 		tokenToOwnersHoldings[_tokenId][_owner] -= _units;
184 	}
185 
186     // Withdraw Ether from this contract to Multi sigin wallet
187     function withdrawEther() onlyOwner public returns(bool) {
188         return contractOwner.send(this.balance);
189     }
190 
191     // ------------------------------ Modifier -----------------------------------
192 
193 
194      modifier onlyExistentToken(uint _tokenId) {
195 	    require(foreverRoseCreated[_tokenId] == true);
196 	    _;
197 	}
198 
199     modifier onlyOwner(){
200          require(msg.sender == contractOwner);
201          _;
202      }
203 
204 }
205 
206 
207 /*============================================================================= */
208 /*=============================MultiSig Wallet================================= */
209 /*============================================================================= */
210 
211 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
212 /// @author Stefan George - <stefan.george@consensys.net>
213 contract MultiSigWallet {
214 
215    //Load Gifto and IAMICOIN Contracts to this contract.
216     //ERC20 private Gifto = ERC20(0x92e87a5622cf9955d1062822454701198a028a72);
217     //ERC20 private IAMIToken = ERC20(0xee10a06b2a0cf7e04115edfbee46242136eb6ae1);
218 
219     uint constant public MAX_OWNER_COUNT = 50;
220 
221     event Confirmation(address indexed sender, uint indexed transactionId);
222     event Revocation(address indexed sender, uint indexed transactionId);
223     event Submission(uint indexed transactionId);
224     event Execution(uint indexed transactionId);
225     event ExecutionFailure(uint indexed transactionId);
226     event Deposit(address indexed sender, uint value);
227     event OwnerAddition(address indexed owner);
228     event OwnerRemoval(address indexed owner);
229     event RequirementChange(uint required);
230     event CoinCreation(address coin);
231 
232     mapping (uint => Transaction) public transactions;
233     mapping (uint => mapping (address => bool)) public confirmations;
234     mapping (address => bool) public isOwner;
235     address[] public owners;
236     uint public required;
237     uint public transactionCount;
238     bool flag = true;
239 
240     struct Transaction {
241         address destination;
242         uint value;
243         bytes data;
244         bool executed;
245     }
246 
247     modifier onlyWallet() {
248         if (msg.sender != address(this))
249             revert();
250         _;
251     }
252 
253     modifier ownerDoesNotExist(address owner) {
254         if (isOwner[owner])
255             revert();
256         _;
257     }
258 
259     modifier ownerExists(address owner) {
260         if (!isOwner[owner])
261             revert();
262         _;
263     }
264 
265     modifier transactionExists(uint transactionId) {
266         if (transactions[transactionId].destination == 0)
267             revert();
268         _;
269     }
270 
271     modifier confirmed(uint transactionId, address owner) {
272         if (!confirmations[transactionId][owner])
273             revert();
274         _;
275     }
276 
277     modifier notConfirmed(uint transactionId, address owner) {
278         if (confirmations[transactionId][owner])
279             revert();
280         _;
281     }
282 
283     modifier notExecuted(uint transactionId) {
284         if (transactions[transactionId].executed)
285             revert();
286         _;
287     }
288 
289     modifier notNull(address _address) {
290         if (_address == 0)
291             revert();
292         _;
293     }
294 
295     modifier validRequirement(uint ownerCount, uint _required) {
296         if (   ownerCount > MAX_OWNER_COUNT
297             || _required > ownerCount
298             || _required == 0
299             || ownerCount == 0)
300             revert();
301         _;
302     }
303 
304     /// @dev Fallback function allows to deposit ether.
305     function()
306         payable
307     {
308         if (msg.value > 0)
309             Deposit(msg.sender, msg.value);
310     }
311 
312     /*
313      * Public functions
314      */
315     /// @dev Contract constructor sets initial owners and required number of confirmations.
316     /// @param _owners List of initial owners.
317     /// @param _required Number of required confirmations.
318     function MultiSigWallet(address[] _owners, uint _required)
319         public
320         validRequirement(_owners.length, _required)
321     {
322         for (uint i=0; i<_owners.length; i++) {
323             if (isOwner[_owners[i]] || _owners[i] == 0)
324                 revert();
325             isOwner[_owners[i]] = true;
326         }
327         owners = _owners;
328         required = _required;
329     }
330 
331     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
332     /// @param owner Address of new owner.
333     function addOwner(address owner)
334         public
335         onlyWallet
336         ownerDoesNotExist(owner)
337         notNull(owner)
338         validRequirement(owners.length + 1, required)
339     {
340         isOwner[owner] = true;
341         owners.push(owner);
342         OwnerAddition(owner);
343     }
344 
345     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
346     /// @param owner Address of owner.
347     function removeOwner(address owner)
348         public
349         onlyWallet
350         ownerExists(owner)
351     {
352         isOwner[owner] = false;
353         for (uint i=0; i<owners.length - 1; i++)
354             if (owners[i] == owner) {
355                 owners[i] = owners[owners.length - 1];
356                 break;
357             }
358         owners.length -= 1;
359         if (required > owners.length)
360             changeRequirement(owners.length);
361         OwnerRemoval(owner);
362     }
363 
364     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
365     /// @param owner Address of owner to be replaced.
366     /// @param owner Address of new owner.
367     function replaceOwner(address owner, address newOwner)
368         public
369         onlyWallet
370         ownerExists(owner)
371         ownerDoesNotExist(newOwner)
372     {
373         for (uint i=0; i<owners.length; i++)
374             if (owners[i] == owner) {
375                 owners[i] = newOwner;
376                 break;
377             }
378         isOwner[owner] = false;
379         isOwner[newOwner] = true;
380         OwnerRemoval(owner);
381         OwnerAddition(newOwner);
382     }
383 
384     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
385     /// @param _required Number of required confirmations.
386     function changeRequirement(uint _required)
387         public
388         onlyWallet
389         validRequirement(owners.length, _required)
390     {
391         required = _required;
392         RequirementChange(_required);
393     }
394 
395     /// @dev Allows an owner to submit and confirm a transaction.
396     /// @param destination Transaction target address.
397     /// @param value Transaction ether value.
398     /// @param data Transaction data payload.
399     /// @return Returns transaction ID.
400     function submitTransaction(address destination, uint value, bytes data)
401         public
402         returns (uint transactionId)
403     {
404         transactionId = addTransaction(destination, value, data);
405         confirmTransaction(transactionId);
406     }
407 
408     /// @dev Allows an owner to confirm a transaction.
409     /// @param transactionId Transaction ID.
410     function confirmTransaction(uint transactionId)
411         public
412         ownerExists(msg.sender)
413         transactionExists(transactionId)
414         notConfirmed(transactionId, msg.sender)
415     {
416         confirmations[transactionId][msg.sender] = true;
417         Confirmation(msg.sender, transactionId);
418         executeTransaction(transactionId);
419     }
420 
421     /// @dev Allows an owner to revoke a confirmation for a transaction.
422     /// @param transactionId Transaction ID.
423     function revokeConfirmation(uint transactionId)
424         public
425         ownerExists(msg.sender)
426         confirmed(transactionId, msg.sender)
427         notExecuted(transactionId)
428     {
429         confirmations[transactionId][msg.sender] = false;
430         Revocation(msg.sender, transactionId);
431     }
432 
433     /// @dev Allows anyone to execute a confirmed transaction.
434     /// @param transactionId Transaction ID.
435     function executeTransaction(uint transactionId)
436         public
437         notExecuted(transactionId)
438     {
439         if (isConfirmed(transactionId)) {
440             Transaction tx = transactions[transactionId];
441             tx.executed = true;
442             if (tx.destination.call.value(tx.value)(tx.data))
443                 Execution(transactionId);
444             else {
445                 ExecutionFailure(transactionId);
446                 tx.executed = false;
447             }
448         }
449     }
450 
451     /// @dev Returns the confirmation status of a transaction.
452     /// @param transactionId Transaction ID.
453     /// @return Confirmation status.
454     function isConfirmed(uint transactionId)
455         public
456         constant
457         returns (bool)
458     {
459         uint count = 0;
460         for (uint i=0; i<owners.length; i++) {
461             if (confirmations[transactionId][owners[i]])
462                 count += 1;
463             if (count == required)
464                 return true;
465         }
466     }
467 
468     /*
469      * Internal functions
470      */
471     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
472     /// @param destination Transaction target address.
473     /// @param value Transaction ether value.
474     /// @param data Transaction data payload.
475     /// @return Returns transaction ID.
476     function addTransaction(address destination, uint value, bytes data)
477         internal
478         notNull(destination)
479         returns (uint transactionId)
480     {
481         transactionId = transactionCount;
482         transactions[transactionId] = Transaction({
483             destination: destination,
484             value: value,
485             data: data,
486             executed: false
487         });
488         transactionCount += 1;
489         Submission(transactionId);
490     }
491 
492     /*
493      * Web3 call functions
494      */
495     /// @dev Returns number of confirmations of a transaction.
496     /// @param transactionId Transaction ID.
497     /// @return Number of confirmations.
498     function getConfirmationCount(uint transactionId)
499         public
500         constant
501         returns (uint count)
502     {
503         for (uint i=0; i<owners.length; i++)
504             if (confirmations[transactionId][owners[i]])
505                 count += 1;
506     }
507 
508     /// @dev Returns total number of transactions after filers are applied.
509     /// @param pending Include pending transactions.
510     /// @param executed Include executed transactions.
511     /// @return Total number of transactions after filters are applied.
512     function getTransactionCount(bool pending, bool executed)
513         public
514         constant
515         returns (uint count)
516     {
517         for (uint i=0; i<transactionCount; i++)
518             if (   pending && !transactions[i].executed
519                 || executed && transactions[i].executed)
520                 count += 1;
521     }
522 
523     /// @dev Returns list of owners.
524     /// @return List of owner addresses.
525     function getOwners()
526         public
527         constant
528         returns (address[])
529     {
530         return owners;
531     }
532 
533     /// @dev Returns array with owner addresses, which confirmed transaction.
534     /// @param transactionId Transaction ID.
535     /// @return Returns array of owner addresses.
536     function getConfirmations(uint transactionId)
537         public
538         constant
539         returns (address[] _confirmations)
540     {
541         address[] memory confirmationsTemp = new address[](owners.length);
542         uint count = 0;
543         uint i;
544         for (i=0; i<owners.length; i++)
545             if (confirmations[transactionId][owners[i]]) {
546                 confirmationsTemp[count] = owners[i];
547                 count += 1;
548             }
549         _confirmations = new address[](count);
550         for (i=0; i<count; i++)
551             _confirmations[i] = confirmationsTemp[i];
552     }
553 
554     /// @dev Returns list of transaction IDs in defined range.
555     /// @param from Index start position of transaction array.
556     /// @param to Index end position of transaction array.
557     /// @param pending Include pending transactions.
558     /// @param executed Include executed transactions.
559     /// @return Returns array of transaction IDs.
560     function getTransactionIds(uint from, uint to, bool pending, bool executed)
561         public
562         constant
563         returns (uint[] _transactionIds)
564     {
565         uint[] memory transactionIdsTemp = new uint[](transactionCount);
566         uint count = 0;
567         uint i;
568         for (i=0; i<transactionCount; i++)
569             if (   pending && !transactions[i].executed
570                 || executed && transactions[i].executed)
571             {
572                 transactionIdsTemp[count] = i;
573                 count += 1;
574             }
575         _transactionIds = new uint[](to - from);
576         for (i=from; i<to; i++)
577             _transactionIds[i - from] = transactionIdsTemp[i];
578     }
579 
580     // Transfer GTO to an outside account
581     /*function _withdrawGTO(address _to, uint256 _balance) onlyOwner internal { 
582         require(Gifto.balanceOf(address(this)) >= _balance);
583         Gifto.transfer(_to, _balance); 
584     }
585 
586     // Transfer IAMI to an outside account
587     function _withdrawIAMI(address _to, uint256 _balance) onlyOwner internal { 
588         require(IAMIToken.balanceOf(address(this)) >= _balance);
589         IAMIToken.transfer(_to, _balance); 
590     }
591 
592     // Change Gifto contract's address or another type of token, like Ether.
593     function setIAMITokenAddress(address newAddress) public onlyOwner {
594         IAMIToken = ERC20(newAddress);
595     }
596 
597     function setGiftoAddress(address newAddress) public onlyOwner {
598         Gifto = ERC20(newAddress);
599     }*/
600 
601     modifier onlyOwner() {
602         require(isOwner[msg.sender] == true);
603         _;
604     }
605 
606     /// @dev Create new forever rose.
607     function createForeverRose()
608         external
609         onlyWallet
610     {
611         require(flag == true);
612         CoinCreation(new DivisibleForeverRose());
613         flag = false;
614     }
615     
616 
617 }
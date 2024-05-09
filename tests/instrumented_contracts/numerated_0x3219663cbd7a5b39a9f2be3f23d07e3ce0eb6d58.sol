1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 contract RNTMultiSigWallet {
120     /*
121      *  Events
122      */
123     event Confirmation(address indexed sender, uint indexed transactionId);
124 
125     event Revocation(address indexed sender, uint indexed transactionId);
126 
127     event Submission(uint indexed transactionId);
128 
129     event Execution(uint indexed transactionId);
130 
131     event ExecutionFailure(uint indexed transactionId);
132 
133     event Deposit(address indexed sender, uint value);
134 
135     event OwnerAddition(address indexed owner);
136 
137     event OwnerRemoval(address indexed owner);
138 
139     event RequirementChange(uint required);
140 
141     event Pause();
142 
143     event Unpause();
144 
145     /*
146      *  Constants
147      */
148     uint constant public MAX_OWNER_COUNT = 10;
149 
150     uint constant public ADMINS_COUNT = 2;
151 
152     /*
153      *  Storage
154      */
155     mapping (uint => WalletTransaction) public transactions;
156 
157     mapping (uint => mapping (address => bool)) public confirmations;
158 
159     mapping (address => bool) public isOwner;
160 
161     mapping (address => bool) public isAdmin;
162 
163     address[] public owners;
164 
165     address[] public admins;
166 
167     uint public required;
168 
169     uint public transactionCount;
170 
171     bool public paused = false;
172 
173     struct WalletTransaction {
174     address sender;
175     address destination;
176     uint value;
177     bytes data;
178     bool executed;
179     }
180 
181     /*
182      *  Modifiers
183      */
184 
185     /// @dev Modifier to make a function callable only when the contract is not paused.
186     modifier whenNotPaused() {
187         require(!paused);
188         _;
189     }
190 
191     /// @dev Modifier to make a function callable only when the contract is paused.
192     modifier whenPaused() {
193         require(paused);
194         _;
195     }
196 
197     modifier onlyWallet() {
198         require(msg.sender == address(this));
199         _;
200     }
201 
202     modifier ownerDoesNotExist(address owner) {
203         require(!isOwner[owner]);
204         _;
205     }
206 
207     modifier ownerExists(address owner) {
208         require(isOwner[owner]);
209         _;
210     }
211 
212     modifier adminExists(address admin) {
213         require(isAdmin[admin]);
214         _;
215     }
216 
217     modifier adminDoesNotExist(address admin) {
218         require(!isAdmin[admin]);
219         _;
220     }
221 
222     modifier transactionExists(uint transactionId) {
223         require(transactions[transactionId].destination != 0);
224         _;
225     }
226 
227     modifier confirmed(uint transactionId, address owner) {
228         require(confirmations[transactionId][owner]);
229         _;
230     }
231 
232     modifier notConfirmed(uint transactionId, address owner) {
233         require(!confirmations[transactionId][owner]);
234         _;
235     }
236 
237     modifier notExecuted(uint transactionId) {
238         if (transactions[transactionId].executed)
239         require(false);
240         _;
241     }
242 
243     modifier notNull(address _address) {
244         require(_address != 0);
245         _;
246     }
247 
248     modifier validRequirement(uint ownerCount, uint _required) {
249         if (ownerCount > MAX_OWNER_COUNT
250         || _required > ownerCount
251         || _required == 0
252         || ownerCount == 0) {
253             require(false);
254         }
255         _;
256     }
257 
258     modifier validAdminsCount(uint adminsCount) {
259         require(adminsCount == ADMINS_COUNT);
260         _;
261     }
262 
263     /// @dev Fallback function allows to deposit ether.
264     function()
265     whenNotPaused
266     payable
267     {
268         if (msg.value > 0)
269         Deposit(msg.sender, msg.value);
270     }
271 
272     /*
273      * Public functions
274      */
275     /// @dev Contract constructor sets initial admins and required number of confirmations.
276     /// @param _admins List of initial owners.
277     /// @param _required Number of required confirmations.
278     function RNTMultiSigWallet(address[] _admins, uint _required)
279     public
280         //    validAdminsCount(_admins.length)
281         //    validRequirement(_admins.length, _required)
282     {
283         for (uint i = 0; i < _admins.length; i++) {
284             require(_admins[i] != 0 && !isOwner[_admins[i]] && !isAdmin[_admins[i]]);
285             isAdmin[_admins[i]] = true;
286             isOwner[_admins[i]] = true;
287         }
288 
289         admins = _admins;
290         owners = _admins;
291         required = _required;
292     }
293 
294     /// @dev called by the owner to pause, triggers stopped state
295     function pause() adminExists(msg.sender) whenNotPaused public {
296         paused = true;
297         Pause();
298     }
299 
300     /// @dev called by the owner to unpause, returns to normal state
301     function unpause() adminExists(msg.sender) whenPaused public {
302         paused = false;
303         Unpause();
304     }
305 
306     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
307     /// @param owner Address of new owner.
308     function addOwner(address owner)
309     public
310     whenNotPaused
311     adminExists(msg.sender)
312     ownerDoesNotExist(owner)
313     notNull(owner)
314     validRequirement(owners.length + 1, required)
315     {
316         isOwner[owner] = true;
317         owners.push(owner);
318         OwnerAddition(owner);
319     }
320 
321     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
322     /// @param owner Address of owner.
323     function removeOwner(address owner)
324     public
325     whenNotPaused
326     adminExists(msg.sender)
327     adminDoesNotExist(owner)
328     ownerExists(owner)
329     {
330         isOwner[owner] = false;
331         for (uint i = 0; i < owners.length - 1; i++)
332         if (owners[i] == owner) {
333             owners[i] = owners[owners.length - 1];
334             break;
335         }
336         owners.length -= 1;
337         if (required > owners.length)
338         changeRequirement(owners.length);
339         OwnerRemoval(owner);
340     }
341 
342     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
343     /// @param owner Address of owner to be replaced.
344     /// @param newOwner Address of new owner.
345     function replaceOwner(address owner, address newOwner)
346     public
347     whenNotPaused
348     adminExists(msg.sender)
349     adminDoesNotExist(owner)
350     ownerExists(owner)
351     ownerDoesNotExist(newOwner)
352     {
353         for (uint i = 0; i < owners.length; i++)
354         if (owners[i] == owner) {
355             owners[i] = newOwner;
356             break;
357         }
358         isOwner[owner] = false;
359         isOwner[newOwner] = true;
360         OwnerRemoval(owner);
361         OwnerAddition(newOwner);
362     }
363 
364     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
365     /// @param _required Number of required confirmations.
366     function changeRequirement(uint _required)
367     public
368     whenNotPaused
369     adminExists(msg.sender)
370     validRequirement(owners.length, _required)
371     {
372         required = _required;
373         RequirementChange(_required);
374     }
375 
376     /// @dev Allows an owner to submit and confirm a transaction.
377     /// @param destination Transaction target address.
378     /// @param value Transaction ether value.
379     /// @param data Transaction data payload.
380     /// @return Returns transaction ID.
381     function submitTransaction(address destination, uint value, bytes data)
382     public
383     whenNotPaused
384     ownerExists(msg.sender)
385     returns (uint transactionId)
386     {
387         transactionId = addTransaction(destination, value, data);
388         confirmTransaction(transactionId);
389     }
390 
391     /// @dev Allows an owner to confirm a transaction.
392     /// @param transactionId Transaction ID.
393     function confirmTransaction(uint transactionId)
394     public
395     whenNotPaused
396     ownerExists(msg.sender)
397     transactionExists(transactionId)
398     notConfirmed(transactionId, msg.sender)
399     {
400         confirmations[transactionId][msg.sender] = true;
401         Confirmation(msg.sender, transactionId);
402         executeTransaction(transactionId);
403     }
404 
405     /// @dev Allows an owner to revoke a confirmation for a transaction.
406     /// @param transactionId Transaction ID.
407     function revokeConfirmation(uint transactionId)
408     public
409     whenNotPaused
410     ownerExists(msg.sender)
411     confirmed(transactionId, msg.sender)
412     notExecuted(transactionId)
413     {
414         confirmations[transactionId][msg.sender] = false;
415         Revocation(msg.sender, transactionId);
416     }
417 
418     /// @dev Allows anyone to execute a confirmed transaction.
419     /// @param transactionId Transaction ID.
420     function executeTransaction(uint transactionId)
421     public
422     whenNotPaused
423     ownerExists(msg.sender)
424     confirmed(transactionId, msg.sender)
425     notExecuted(transactionId)
426     {
427         if (isConfirmed(transactionId)) {
428             WalletTransaction storage walletTransaction = transactions[transactionId];
429             walletTransaction.executed = true;
430             if (walletTransaction.destination.call.value(walletTransaction.value)(walletTransaction.data))
431             Execution(transactionId);
432             else {
433                 ExecutionFailure(transactionId);
434                 walletTransaction.executed = false;
435             }
436         }
437     }
438 
439     /// @dev Returns the confirmation status of a transaction.
440     /// @param transactionId Transaction ID.
441     /// @return Confirmation status.
442     function isConfirmed(uint transactionId)
443     public
444     constant
445     returns (bool)
446     {
447         uint count = 0;
448         for (uint i = 0; i < owners.length; i++) {
449             if (confirmations[transactionId][owners[i]])
450             count += 1;
451             if (count == required)
452             return true;
453         }
454     }
455 
456     /*
457      * Internal functions
458      */
459     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
460     /// @param destination Transaction target address.
461     /// @param value Transaction ether value.
462     /// @param data Transaction data payload.
463     /// @return Returns transaction ID.
464     function addTransaction(address destination, uint value, bytes data)
465     internal
466     notNull(destination)
467     returns (uint transactionId)
468     {
469         transactionId = transactionCount;
470         transactions[transactionId] = WalletTransaction({
471         sender : msg.sender,
472         destination : destination,
473         value : value,
474         data : data,
475         executed : false
476         });
477         transactionCount += 1;
478         Submission(transactionId);
479     }
480 
481     /*
482      * Web3 call functions
483      */
484     /// @dev Returns number of confirmations of a transaction.
485     /// @param transactionId Transaction ID.
486     /// @return Number of confirmations.
487     function getConfirmationCount(uint transactionId)
488     public
489     constant
490     returns (uint count)
491     {
492         for (uint i = 0; i < owners.length; i++)
493         if (confirmations[transactionId][owners[i]])
494         count += 1;
495     }
496 
497     /// @dev Returns total number of transactions after filers are applied.
498     /// @param pending Include pending transactions.
499     /// @param executed Include executed transactions.
500     /// @return Total number of transactions after filters are applied.
501     function getTransactionCount(bool pending, bool executed)
502     public
503     constant
504     returns (uint count)
505     {
506         for (uint i = 0; i < transactionCount; i++)
507         if (pending && !transactions[i].executed
508         || executed && transactions[i].executed)
509         count += 1;
510     }
511 
512     /// @dev Returns list of owners.
513     /// @return List of owner addresses.
514     function getOwners()
515     public
516     constant
517     returns (address[])
518     {
519         return owners;
520     }
521 
522     // @dev Returns list of admins.
523     // @return List of admin addresses
524     function getAdmins()
525     public
526     constant
527     returns (address[])
528     {
529         return admins;
530     }
531 
532     /// @dev Returns array with owner addresses, which confirmed transaction.
533     /// @param transactionId Transaction ID.
534     /// @return Returns array of owner addresses.
535     function getConfirmations(uint transactionId)
536     public
537     constant
538     returns (address[] _confirmations)
539     {
540         address[] memory confirmationsTemp = new address[](owners.length);
541         uint count = 0;
542         uint i;
543         for (i = 0; i < owners.length; i++)
544         if (confirmations[transactionId][owners[i]]) {
545             confirmationsTemp[count] = owners[i];
546             count += 1;
547         }
548         _confirmations = new address[](count);
549         for (i = 0; i < count; i++)
550         _confirmations[i] = confirmationsTemp[i];
551     }
552 
553     /// @dev Returns list of transaction IDs in defined range.
554     /// @param from Index start position of transaction array.
555     /// @param to Index end position of transaction array.
556     /// @param pending Include pending transactions.
557     /// @param executed Include executed transactions.
558     /// @return Returns array of transaction IDs.
559     function getTransactionIds(uint from, uint to, bool pending, bool executed)
560     public
561     constant
562     returns (uint[] _transactionIds)
563     {
564         uint[] memory transactionIdsTemp = new uint[](transactionCount);
565         uint count = 0;
566         uint i;
567         for (i = 0; i < transactionCount; i++)
568         if (pending && !transactions[i].executed
569         || executed && transactions[i].executed)
570         {
571             transactionIdsTemp[count] = i;
572             count += 1;
573         }
574         _transactionIds = new uint[](to - from);
575         for (i = from; i < to; i++)
576         _transactionIds[i - from] = transactionIdsTemp[i];
577     }
578 }
579 
580 contract RntPresaleEthereumDeposit is Pausable {
581     using SafeMath for uint256;
582 
583     uint256 public overallTakenEther = 0;
584 
585     mapping (address => uint256) public receivedEther;
586 
587     struct Donator {
588         address addr;
589         uint256 donated;
590     }
591 
592     Donator[] donators;
593 
594     RNTMultiSigWallet public wallet;
595 
596     function RntPresaleEthereumDeposit(address _walletAddress) {
597         wallet = RNTMultiSigWallet(_walletAddress);
598     }
599 
600     function updateDonator(address _address) internal {
601         bool isFound = false;
602         for (uint i = 0; i < donators.length; i++) {
603             if (donators[i].addr == _address) {
604                 donators[i].donated =  receivedEther[_address];
605                 isFound = true;
606                 break;
607             }
608         }
609         if (!isFound) {
610             donators.push(Donator(_address, receivedEther[_address]));
611         }
612     }
613 
614     function getDonatorsNumber() external constant returns(uint256) {
615         return donators.length;
616     }
617 
618     function getDonator(uint pos) external constant returns(address, uint256) {
619         return (donators[pos].addr, donators[pos].donated);
620     }
621 
622     /*
623      * Fallback function for sending ether to wallet and update donators info
624      */
625     function() whenNotPaused payable {
626         wallet.transfer(msg.value);
627 
628         overallTakenEther = overallTakenEther.add(msg.value);
629         receivedEther[msg.sender] = receivedEther[msg.sender].add(msg.value);
630 
631         updateDonator(msg.sender);
632     }
633 
634     function receivedEtherFrom(address _from) whenNotPaused constant public returns(uint256) {
635         return receivedEther[_from];
636     }
637 
638     function myEther() whenNotPaused constant public returns(uint256) {
639         return receivedEther[msg.sender];
640     }
641 }
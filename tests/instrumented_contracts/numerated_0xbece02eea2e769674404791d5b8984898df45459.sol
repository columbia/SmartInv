1 pragma solidity 0.4.23;
2 
3 contract ZethrBankroll {
4     using SafeMath for uint;
5 
6     uint constant public MAX_OWNER_COUNT = 10;
7     uint constant public MAX_WITHDRAW_PCT_DAILY = 15;
8     uint constant public MAX_WITHDRAW_PCT_TX = 5;
9     
10     uint constant internal resetTimer = 1 days; 
11 
12     event Confirmation(address indexed sender, uint indexed transactionId);
13     event Revocation(address indexed sender, uint indexed transactionId);
14     event Submission(uint indexed transactionId);
15     event Execution(uint indexed transactionId);
16     event ExecutionFailure(uint indexed transactionId);
17     event Deposit(address indexed sender, uint value);
18     event OwnerAddition(address indexed owner);
19     event OwnerRemoval(address indexed owner);
20     event WhiteListAddition(address indexed contractAddress);
21     event WhiteListRemoval(address indexed contractAddress);
22     event RequirementChange(uint required);
23     event DevWithdraw(uint amountTotal, uint amountPerPerson);
24 
25     mapping (uint => Transaction) public transactions;
26     mapping (uint => mapping (address => bool)) public confirmations;
27     mapping (address => bool) public isOwner;
28     mapping (address => bool) public isWhitelisted;
29     address[] public owners;
30     address[] public whiteListedContracts;
31     uint public required;
32     uint public transactionCount;
33     uint internal dailyResetTime;
34     uint internal dailyLimit;
35     uint internal ethDispensedToday;
36 
37     struct Transaction {
38         address destination;
39         uint value;
40         bytes data;
41         bool executed;
42     }
43 
44     modifier onlyWallet() {
45         if (msg.sender != address(this))
46             revert();
47         _;
48     }
49     
50     modifier onlyWhiteListedContract() {
51         if (!isWhitelisted[msg.sender])
52             revert();
53         _;
54     }
55     
56     modifier contractIsNotWhiteListed(address contractAddress) {
57         if (isWhitelisted[contractAddress])
58             revert();
59         _;
60     }
61     
62     modifier contractIsWhiteListed(address contractAddress) {
63         if (!isWhitelisted[contractAddress])
64             revert();
65         _;
66     }
67     
68     modifier isAnOwner() {
69         address caller = msg.sender;
70         if (!isOwner[caller])
71             revert();
72         _;
73     }
74 
75     modifier ownerDoesNotExist(address owner) {
76         if (isOwner[owner])
77             revert();
78         _;
79     }
80 
81     modifier ownerExists(address owner) {
82         if (!isOwner[owner])
83             revert();
84         _;
85     }
86 
87     modifier transactionExists(uint transactionId) {
88         if (transactions[transactionId].destination == 0)
89             revert();
90         _;
91     }
92 
93     modifier confirmed(uint transactionId, address owner) {
94         if (!confirmations[transactionId][owner])
95             revert();
96         _;
97     }
98 
99     modifier notConfirmed(uint transactionId, address owner) {
100         if (confirmations[transactionId][owner])
101             revert();
102         _;
103     }
104 
105     modifier notExecuted(uint transactionId) {
106         if (transactions[transactionId].executed)
107             revert();
108         _;
109     }
110 
111     modifier notNull(address _address) {
112         if (_address == 0)
113             revert();
114         _;
115     }
116 
117     modifier validRequirement(uint ownerCount, uint _required) {
118         if (   ownerCount > MAX_OWNER_COUNT
119             || _required > ownerCount
120             || _required == 0
121             || ownerCount == 0)
122             revert();
123         _;
124     }
125 
126     /// @dev Fallback function allows to deposit ether.
127     function()
128         public
129         payable
130     {
131         
132     }
133     
134     /*
135      * Public functions
136      */
137     /// @dev Contract constructor sets initial owners and required number of confirmations.
138     /// @param _owners List of initial owners.
139     /// @param _required Number of required confirmations.
140     constructor (address[] _owners, uint _required)
141         public
142         validRequirement(_owners.length, _required)
143     {
144         for (uint i=0; i<_owners.length; i++) {
145             if (isOwner[_owners[i]] || _owners[i] == 0)
146                 revert();
147             isOwner[_owners[i]] = true;
148         }
149         owners = _owners;
150         required = _required;
151         
152         dailyResetTime = now;
153     }
154 
155 
156     /// @dev Calculates if an amount of Ether exceeds the aggregate daily limit of 15% of contract
157     ///        balance or 5% of the contract balance on its own.
158     function permissibleWithdrawal(uint _toWithdraw)
159         public
160         onlyWallet
161         returns(bool)
162     {
163         uint currentTime     = now;
164         uint contractBalance = address(this).balance;
165         uint maxPerTx        = (contractBalance.mul(MAX_WITHDRAW_PCT_TX)).div(100);
166         
167         require (_toWithdraw <= maxPerTx);
168         
169         if (currentTime - dailyResetTime >= resetTimer)
170             {
171                 dailyResetTime    = currentTime;
172                 dailyLimit        = (contractBalance.mul(MAX_WITHDRAW_PCT_DAILY)).div(100);
173                 ethDispensedToday = _toWithdraw;
174                 return true;
175             }
176         else 
177             {
178                 if (ethDispensedToday.add(_toWithdraw) <= dailyLimit)
179                     {
180                         ethDispensedToday += _toWithdraw;
181                         return true;
182                     }
183                 else { return false; }
184             }
185     }
186     
187     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
188     /// @param owner Address of new owner.
189     function addOwner(address owner)
190         public
191         onlyWallet
192         ownerDoesNotExist(owner)
193         notNull(owner)
194         validRequirement(owners.length + 1, required)
195     {
196         isOwner[owner] = true;
197         owners.push(owner);
198         emit OwnerAddition(owner);
199     }
200 
201     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
202     /// @param owner Address of owner.
203     function removeOwner(address owner)
204         public
205         onlyWallet
206         ownerExists(owner)
207     {
208         isOwner[owner] = false;
209         for (uint i=0; i<owners.length - 1; i++)
210             if (owners[i] == owner) {
211                 owners[i] = owners[owners.length - 1];
212                 break;
213             }
214         owners.length -= 1;
215         if (required > owners.length)
216             changeRequirement(owners.length);
217         emit OwnerRemoval(owner);
218     }
219 
220     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
221     /// @param owner Address of owner to be replaced.
222     /// @param owner Address of new owner.
223     function replaceOwner(address owner, address newOwner)
224         public
225         onlyWallet
226         ownerExists(owner)
227         ownerDoesNotExist(newOwner)
228     {
229         for (uint i=0; i<owners.length; i++)
230             if (owners[i] == owner) {
231                 owners[i] = newOwner;
232                 break;
233             }
234         isOwner[owner] = false;
235         isOwner[newOwner] = true;
236         emit OwnerRemoval(owner);
237         emit OwnerAddition(newOwner);
238     }
239 
240     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
241     /// @param _required Number of required confirmations.
242     function changeRequirement(uint _required)
243         public
244         onlyWallet
245         validRequirement(owners.length, _required)
246     {
247         required = _required;
248         emit RequirementChange(_required);
249     }
250 
251     /// @dev Allows an owner to submit and confirm a transaction.
252     /// @param destination Transaction target address.
253     /// @param value Transaction ether value.
254     /// @param data Transaction data payload.
255     /// @return Returns transaction ID.
256     function submitTransaction(address destination, uint value, bytes data)
257         public
258         returns (uint transactionId)
259     {
260         transactionId = addTransaction(destination, value, data);
261         confirmTransaction(transactionId);
262     }
263 
264     /// @dev Allows an owner to confirm a transaction.
265     /// @param transactionId Transaction ID.
266     function confirmTransaction(uint transactionId)
267         public
268         ownerExists(msg.sender)
269         transactionExists(transactionId)
270         notConfirmed(transactionId, msg.sender)
271     {
272         confirmations[transactionId][msg.sender] = true;
273         emit Confirmation(msg.sender, transactionId);
274         executeTransaction(transactionId);
275     }
276 
277     /// @dev Allows an owner to revoke a confirmation for a transaction.
278     /// @param transactionId Transaction ID.
279     function revokeConfirmation(uint transactionId)
280         public
281         ownerExists(msg.sender)
282         confirmed(transactionId, msg.sender)
283         notExecuted(transactionId)
284     {
285         confirmations[transactionId][msg.sender] = false;
286         emit Revocation(msg.sender, transactionId);
287     }
288 
289     /// @dev Allows anyone to execute a confirmed transaction.
290     /// @param transactionId Transaction ID.
291     function executeTransaction(uint transactionId)
292         public
293         notExecuted(transactionId)
294     {
295         if (isConfirmed(transactionId)) {
296             Transaction storage txToExecute = transactions[transactionId];
297             txToExecute.executed = true;
298             if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
299                 emit Execution(transactionId);
300             else {
301                 emit ExecutionFailure(transactionId);
302                 txToExecute.executed = false;
303             }
304         }
305     }
306 
307     /// @dev Returns the confirmation status of a transaction.
308     /// @param transactionId Transaction ID.
309     /// @return Confirmation status.
310     function isConfirmed(uint transactionId)
311         public
312         constant
313         returns (bool)
314     {
315         uint count = 0;
316         for (uint i=0; i<owners.length; i++) {
317             if (confirmations[transactionId][owners[i]])
318                 count += 1;
319             if (count == required)
320                 return true;
321         }
322     }
323 
324     /*
325      * Internal functions
326      */
327     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
328     /// @param destination Transaction target address.
329     /// @param value Transaction ether value.
330     /// @param data Transaction data payload.
331     /// @return Returns transaction ID.
332     function addTransaction(address destination, uint value, bytes data)
333         internal
334         notNull(destination)
335         returns (uint transactionId)
336     {
337         transactionId = transactionCount;
338         transactions[transactionId] = Transaction({
339             destination: destination,
340             value: value,
341             data: data,
342             executed: false
343         });
344         transactionCount += 1;
345         emit Submission(transactionId);
346     }
347 
348     /*
349      * Web3 call functions
350      */
351     /// @dev Returns number of confirmations of a transaction.
352     /// @param transactionId Transaction ID.
353     /// @return Number of confirmations.
354     function getConfirmationCount(uint transactionId)
355         public
356         constant
357         returns (uint count)
358     {
359         for (uint i=0; i<owners.length; i++)
360             if (confirmations[transactionId][owners[i]])
361                 count += 1;
362     }
363 
364     /// @dev Returns total number of transactions after filers are applied.
365     /// @param pending Include pending transactions.
366     /// @param executed Include executed transactions.
367     /// @return Total number of transactions after filters are applied.
368     function getTransactionCount(bool pending, bool executed)
369         public
370         constant
371         returns (uint count)
372     {
373         for (uint i=0; i<transactionCount; i++)
374             if (   pending && !transactions[i].executed
375                 || executed && transactions[i].executed)
376                 count += 1;
377     }
378 
379     /// @dev Returns list of owners.
380     /// @return List of owner addresses.
381     function getOwners()
382         public
383         constant
384         returns (address[])
385     {
386         return owners;
387     }
388 
389     /// @dev Returns array with owner addresses, which confirmed transaction.
390     /// @param transactionId Transaction ID.
391     /// @return Returns array of owner addresses.
392     function getConfirmations(uint transactionId)
393         public
394         constant
395         returns (address[] _confirmations)
396     {
397         address[] memory confirmationsTemp = new address[](owners.length);
398         uint count = 0;
399         uint i;
400         for (i=0; i<owners.length; i++)
401             if (confirmations[transactionId][owners[i]]) {
402                 confirmationsTemp[count] = owners[i];
403                 count += 1;
404             }
405         _confirmations = new address[](count);
406         for (i=0; i<count; i++)
407             _confirmations[i] = confirmationsTemp[i];
408     }
409 
410     /// @dev Returns list of transaction IDs in defined range.
411     /// @param from Index start position of transaction array.
412     /// @param to Index end position of transaction array.
413     /// @param pending Include pending transactions.
414     /// @param executed Include executed transactions.
415     /// @return Returns array of transaction IDs.
416     function getTransactionIds(uint from, uint to, bool pending, bool executed)
417         public
418         constant
419         returns (uint[] _transactionIds)
420     {
421         uint[] memory transactionIdsTemp = new uint[](transactionCount);
422         uint count = 0;
423         uint i;
424         for (i=0; i<transactionCount; i++)
425             if (   pending && !transactions[i].executed
426                 || executed && transactions[i].executed)
427             {
428                 transactionIdsTemp[count] = i;
429                 count += 1;
430             }
431         _transactionIds = new uint[](to - from);
432         for (i=from; i<to; i++)
433             _transactionIds[i - from] = transactionIdsTemp[i];
434     }
435 
436     // Additions for Bankroll
437     function whiteListContract(address contractAddress)
438         public
439         onlyWallet
440         contractIsNotWhiteListed(contractAddress)
441         notNull(contractAddress)
442     {
443         isWhitelisted[contractAddress] = true;
444         whiteListedContracts.push(contractAddress);
445         emit WhiteListAddition(contractAddress);
446     }
447     
448     // Remove a whitelisted contract. This is an exception to the norm in that
449     // it can be invoked directly by any owner, in the event that a game is found
450     // to be bugged or otherwise faulty, so it can be shut down as an emergency measure.
451     // Iterates through the whitelisted contracts to find contractAddress,
452     //  then swaps it with the last address in the list - then decrements length
453     function deWhiteListContract(address contractAddress)
454         public
455         isAnOwner
456         contractIsWhiteListed(contractAddress)
457     {
458         isWhitelisted[contractAddress] = false;
459         for (uint i=0; i<whiteListedContracts.length - 1; i++)
460             if (whiteListedContracts[i] == contractAddress) {
461                 whiteListedContracts[i] = owners[whiteListedContracts.length - 1];
462                 break;
463             }
464             
465         whiteListedContracts.length -= 1;
466         
467         emit WhiteListRemoval(contractAddress);
468     }
469     
470     // Legit sweaty palms when writing this
471     // AUDIT AUDIT AUDIT
472     // Should withdraw "amount" to whitelisted contracts only!
473     // Should block withdraws greater than MAX_WITHDRAW_PCT_TX of balance.
474     function contractWithdraw(uint amount) public 
475         onlyWhiteListedContract
476     {
477         // Make sure amount is <= balance*MAX_WITHDRAW_PCT_TX
478         require(permissibleWithdrawal(amount));
479         
480         msg.sender.transfer(amount);
481     }
482     
483     // Dev withdraw - splits equally among all owners of contract
484     function devWithdraw(uint amount) public
485         onlyWallet
486     {
487         require(permissibleWithdrawal(amount));        
488         
489         uint amountPerPerson = SafeMath.div(amount, owners.length);
490         
491         for (uint i=0; i<owners.length; i++) {
492             owners[i].transfer(amountPerPerson);
493         }
494         
495         emit DevWithdraw(amount, amountPerPerson);
496     }
497     
498     // Receive dividends from Zethr and buy back in 
499 
500     function receiveDividends() public payable {
501         Zethr(msg.sender).buy.value(msg.value)(address(0x0));
502     }
503 
504 
505     // Convert an hexadecimal character to their value
506     function fromHexChar(uint c) public pure returns (uint) {
507         if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
508             return c - uint(byte('0'));
509         }
510         if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
511             return 10 + c - uint(byte('a'));
512         }
513         if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
514             return 10 + c - uint(byte('A'));
515         }
516     }
517 
518     // Convert an hexadecimal string to raw bytes
519     function fromHex(string s) public pure returns (bytes) {
520         bytes memory ss = bytes(s);
521         require(ss.length%2 == 0); // length must be even
522         bytes memory r = new bytes(ss.length/2);
523         for (uint i=0; i<ss.length/2; ++i) {
524             r[i] = byte(fromHexChar(uint(ss[2*i])) * 16 +
525                     fromHexChar(uint(ss[2*i+1])));
526         }
527         return r;
528     }
529 }
530 
531 /**
532  * @title SafeMath
533  * @dev Math operations with safety checks that throw on error
534  */
535 library SafeMath {
536 
537     /**
538     * @dev Multiplies two numbers, throws on overflow.
539     */
540     function mul(uint a, uint b) internal pure returns (uint) {
541         if (a == 0) {
542             return 0;
543         }
544         uint c = a * b;
545         assert(c / a == b);
546         return c;
547     }
548 
549     /**
550     * @dev Integer division of two numbers, truncating the quotient.
551     */
552     function div(uint a, uint b) internal pure returns (uint) {
553         // assert(b > 0); // Solidity automatically throws when dividing by 0
554         uint c = a / b;
555         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
556         return c;
557     }
558 
559     /**
560     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
561     */
562     function sub(uint a, uint b) internal pure returns (uint) {
563         assert(b <= a);
564         return a - b;
565     }
566 
567     /**
568     * @dev Adds two numbers, throws on overflow.
569     */
570     function add(uint a, uint b) internal pure returns (uint) {
571         uint c = a + b;
572         assert(c >= a);
573         return c;
574     }
575 }
576 
577 contract Zethr{
578         function buy(address)
579         public
580         payable {}
581 }
1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title MultiSigStub  
5  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
6  * @dev Contract that delegates calls to a library to build a full MultiSigWallet that is cheap to create. 
7  */
8 contract MultiSigStub {
9 
10     address[] public owners;
11     address[] public tokens;
12     mapping (uint => Transaction) public transactions;
13     mapping (uint => mapping (address => bool)) public confirmations;
14     uint public transactionCount;
15 
16     struct Transaction {
17         address destination;
18         uint value;
19         bytes data;
20         bool executed;
21     }
22     
23     function MultiSigStub(address[] _owners, uint256 _required) {
24         //bytes4 sig = bytes4(sha3("constructor(address[],uint256)"));
25         bytes4 sig = 0x36756a23;
26         uint argarraysize = (2 + _owners.length);
27         uint argsize = (1 + argarraysize) * 32;
28         uint size = 4 + argsize;
29         bytes32 mData = _malloc(size);
30 
31         assembly {
32             mstore(mData, sig)
33             codecopy(add(mData, 0x4), sub(codesize, argsize), argsize)
34         }
35         _delegatecall(mData, size);
36     }
37     
38     modifier delegated {
39         uint size = msg.data.length;
40         bytes32 mData = _malloc(size);
41 
42         assembly {
43             calldatacopy(mData, 0x0, size)
44         }
45 
46         bytes32 mResult = _delegatecall(mData, size);
47         _;
48         assembly {
49             return(mResult, 0x20)
50         }
51     }
52     
53     function()
54         payable
55         delegated
56     {
57 
58     }
59 
60     function submitTransaction(address destination, uint value, bytes data)
61         public
62         delegated
63         returns (uint)
64     {
65         
66     }
67     
68     function confirmTransaction(uint transactionId)
69         public
70         delegated
71     {
72         
73     }
74     
75     function watch(address _tokenAddr)
76         public
77         delegated
78     {
79         
80     }
81     
82     function setMyTokenList(address[] _tokenList)  
83         public
84         delegated
85     {
86 
87     }
88     /// @dev Returns the confirmation status of a transaction.
89     /// @param transactionId Transaction ID.
90     /// @return Confirmation status.
91     function isConfirmed(uint transactionId)
92         public
93         constant
94         delegated
95         returns (bool)
96     {
97 
98     }
99     
100     /*
101     * Web3 call functions
102     */
103     function tokenBalances(address tokenAddress) 
104         public
105         constant 
106         delegated 
107         returns (uint)
108     {
109 
110     }
111 
112 
113     /// @dev Returns number of confirmations of a transaction.
114     /// @param transactionId Transaction ID.
115     /// @return Number of confirmations.
116     function getConfirmationCount(uint transactionId)
117         public
118         constant
119         delegated
120         returns (uint)
121     {
122 
123     }
124 
125     /// @dev Returns total number of transactions after filters are applied.
126     /// @param pending Include pending transactions.
127     /// @param executed Include executed transactions.
128     /// @return Total number of transactions after filters are applied.
129     function getTransactionCount(bool pending, bool executed)
130         public
131         constant
132         delegated
133         returns (uint)
134     {
135 
136     }
137 
138     /// @dev Returns list of owners.
139     /// @return List of owner addresses.
140     function getOwners()
141         public
142         constant
143         returns (address[])
144     {
145         return owners;
146     }
147 
148     /// @dev Returns list of tokens.
149     /// @return List of token addresses.
150     function getTokenList()
151         public
152         constant
153         returns (address[])
154     {
155         return tokens;
156     }
157 
158     /// @dev Returns array with owner addresses, which confirmed transaction.
159     /// @param transactionId Transaction ID.
160     /// @return Returns array of owner addresses.
161     function getConfirmations(uint transactionId)
162         public
163         constant
164         returns (address[] _confirmations)
165     {
166         address[] memory confirmationsTemp = new address[](owners.length);
167         uint count = 0;
168         uint i;
169         for (i = 0; i < owners.length; i++) {
170             if (confirmations[transactionId][owners[i]]) {
171                 confirmationsTemp[count] = owners[i];
172                 count += 1;
173             }
174         }
175         _confirmations = new address[](count);
176         for (i = 0; i < count; i++) {
177             _confirmations[i] = confirmationsTemp[i];
178         }
179     }
180 
181     /// @dev Returns list of transaction IDs in defined range.
182     /// @param from Index start position of transaction array.
183     /// @param to Index end position of transaction array.
184     /// @param pending Include pending transactions.
185     /// @param executed Include executed transactions.
186     /// @return Returns array of transaction IDs.
187     function getTransactionIds(uint from, uint to, bool pending, bool executed)
188         public
189         constant
190         returns (uint[] _transactionIds)
191     {
192         uint[] memory transactionIdsTemp = new uint[](transactionCount);
193         uint count = 0;
194         uint i;
195         for (i = 0; i < transactionCount; i++) {
196             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
197                 transactionIdsTemp[count] = i;
198                 count += 1;
199             }
200         }
201         _transactionIds = new uint[](to - from);
202         for (i = from; i < to; i++) {
203             _transactionIds[i - from] = transactionIdsTemp[i];
204         }
205     }
206 
207 
208     function _malloc(uint size) 
209         private 
210         returns(bytes32 mData) 
211     {
212         assembly {
213             mData := mload(0x40)
214             mstore(0x40, add(mData, size))
215         }
216     }
217 
218     function _delegatecall(bytes32 mData, uint size) 
219         private 
220         returns(bytes32 mResult) 
221     {
222         address target = 0xc0FFeEE61948d8993864a73a099c0E38D887d3F4; //Multinetwork
223         mResult = _malloc(32);
224         bool failed;
225 
226         assembly {
227             failed := iszero(delegatecall(sub(gas, 10000), target, mData, size, mResult, 0x20))
228         }
229 
230         assert(!failed);
231     }
232     
233 }
234 
235 contract MultiSigFactory {
236     
237     event Create(address indexed caller, address createdContract);
238 
239     function create(address[] owners, uint256 required) returns (address wallet){
240         wallet = new MultiSigStub(owners, required); 
241         Create(msg.sender, wallet);
242     }
243     
244 }
245 
246 ///////////////////////////////////////////////////////////////////
247 // MultiSigTokenWallet as in 0xc0FFeEE61948d8993864a73a099c0E38D887d3F4
248 ///////////////////////////////////////////////////////////////////
249 
250 pragma solidity ^0.4.15;
251 
252 contract ERC20 {
253     uint256 public totalSupply;
254     function balanceOf(address who) constant returns (uint256 balance);
255     function allowance(address owner, address spender) constant returns (uint256 remaining);
256     function transfer(address to, uint256 value) returns (bool ok); 
257     function transferFrom(address from, address to, uint256 value) returns (bool ok);
258     function approve(address spender, uint256 value) returns (bool ok);
259     event Transfer(address indexed from, address indexed to, uint256 value);
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 }
262 
263 contract MultiSigTokenWallet {
264 
265     address[] public owners;
266     address[] public tokens;
267     mapping (uint => Transaction) public transactions;
268     mapping (uint => mapping (address => bool)) public confirmations;
269     uint public transactionCount;
270     
271     mapping (address => uint) public tokenBalances;
272     mapping (address => bool) public isOwner;
273     mapping (address => address[]) public userList;
274     uint public required;
275     uint public nonce;
276 
277     struct Transaction {
278         address destination;
279         uint value;
280         bytes data;
281         bool executed;
282     }
283 
284     uint constant public MAX_OWNER_COUNT = 50;
285 
286     event Confirmation(address indexed _sender, uint indexed _transactionId);
287     event Revocation(address indexed _sender, uint indexed _transactionId);
288     event Submission(uint indexed _transactionId);
289     event Execution(uint indexed _transactionId);
290     event ExecutionFailure(uint indexed _transactionId);
291     event Deposit(address indexed _sender, uint _value);
292     event TokenDeposit(address _token, address indexed _sender, uint _value);
293     event OwnerAddition(address indexed _owner);
294     event OwnerRemoval(address indexed _owner);
295     event RequirementChange(uint _required);
296     
297     modifier onlyWallet() {
298         require (msg.sender == address(this));
299         _;
300     }
301 
302     modifier ownerDoesNotExist(address owner) {
303         require (!isOwner[owner]);
304         _;
305     }
306 
307     modifier ownerExists(address owner) {
308         require (isOwner[owner]);
309         _;
310     }
311 
312     modifier transactionExists(uint transactionId) {
313         require (transactions[transactionId].destination != 0);
314         _;
315     }
316 
317     modifier confirmed(uint transactionId, address owner) {
318         require (confirmations[transactionId][owner]);
319         _;
320     }
321 
322     modifier notConfirmed(uint transactionId, address owner) {
323         require(!confirmations[transactionId][owner]);
324         _;
325     }
326 
327     modifier notExecuted(uint transactionId) {
328         require (!transactions[transactionId].executed);
329         _;
330     }
331 
332     modifier notNull(address _address) {
333         require (_address != 0);
334         _;
335     }
336 
337     modifier validRequirement(uint ownerCount, uint _required) {
338         require (ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
339         _;
340     }
341 
342     /// @dev Fallback function allows to deposit ether.
343     function()
344         payable
345     {
346         if (msg.value > 0)
347             Deposit(msg.sender, msg.value);
348     }
349 
350     /**
351     * Public functions
352     * 
353     **/
354     /// @dev Contract constructor sets initial owners and required number of confirmations.
355     /// @param _owners List of initial owners.
356     /// @param _required Number of required confirmations.
357     function constructor(address[] _owners, uint _required)
358         public
359         validRequirement(_owners.length, _required)
360     {
361         require(owners.length == 0 && required == 0);
362         for (uint i = 0; i < _owners.length; i++) {
363             require(!isOwner[_owners[i]] && _owners[i] != 0);
364             isOwner[_owners[i]] = true;
365         }
366         owners = _owners;
367         required = _required;
368     }
369 
370     /**
371     * @notice deposit a ERC20 token. The amount of deposit is the allowance set to this contract.
372     * @param _token the token contract address
373     * @param _data might be used by child implementations
374     **/ 
375     function depositToken(address _token, bytes _data) 
376         public 
377     {
378         address sender = msg.sender;
379         uint amount = ERC20(_token).allowance(sender, this);
380         deposit(sender, amount, _token, _data);
381     }
382         
383     /**
384     * @notice deposit a ERC20 token. The amount of deposit is the allowance set to this contract.
385     * @param _token the token contract address
386     * @param _data might be used by child implementations
387     **/ 
388     function deposit(address _from, uint256 _amount, address _token, bytes _data) 
389         public 
390     {
391         if (_from == address(this))
392             return;
393         uint _nonce = nonce;
394         bool result = ERC20(_token).transferFrom(_from, this, _amount);
395         assert(result);
396         //ERC23 not executed _deposited tokenFallback by
397         if (nonce == _nonce) {
398             _deposited(_from, _amount, _token, _data);
399         }
400     }
401     /**
402     * @notice watches for balance in a token contract
403     * @param _tokenAddr the token contract address
404     **/   
405     function watch(address _tokenAddr) 
406         ownerExists(msg.sender) 
407     {
408         uint oldBal = tokenBalances[_tokenAddr];
409         uint newBal = ERC20(_tokenAddr).balanceOf(this);
410         if (newBal > oldBal) {
411             _deposited(0x0, newBal-oldBal, _tokenAddr, new bytes(0));
412         }
413     }
414 
415     function setMyTokenList(address[] _tokenList) 
416         public
417     {
418         userList[msg.sender] = _tokenList;
419     }
420 
421     function setTokenList(address[] _tokenList) 
422         onlyWallet
423     {
424         tokens = _tokenList;
425     }
426     
427     /**
428     * @notice ERC23 Token fallback
429     * @param _from address incoming token
430     * @param _amount incoming amount
431     **/    
432     function tokenFallback(address _from, uint _amount, bytes _data) 
433         public 
434     {
435         _deposited(_from, _amount, msg.sender, _data);
436     }
437         
438     /** 
439     * @notice Called MiniMeToken approvesAndCall to this contract, calls deposit.
440     * @param _from address incoming token
441     * @param _amount incoming amount
442     * @param _token the token contract address
443     * @param _data (might be used by child classes)
444     */ 
445     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) {
446         deposit(_from, _amount, _token, _data);
447     }
448     
449 
450     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
451     /// @param owner Address of new owner.
452     function addOwner(address owner)
453         public
454         onlyWallet
455         ownerDoesNotExist(owner)
456         notNull(owner)
457         validRequirement(owners.length + 1, required)
458     {
459         isOwner[owner] = true;
460         owners.push(owner);
461         OwnerAddition(owner);
462     }
463 
464     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
465     /// @param owner Address of owner.
466     function removeOwner(address owner)
467         public
468         onlyWallet
469         ownerExists(owner)
470     {
471         isOwner[owner] = false;
472         uint _len = owners.length - 1;
473         for (uint i = 0; i < _len; i++) {
474             if (owners[i] == owner) {
475                 owners[i] = owners[owners.length - 1];
476                 break;
477             }
478         }
479         owners.length -= 1;
480         if (required > owners.length)
481             changeRequirement(owners.length);
482         OwnerRemoval(owner);
483     }
484 
485     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
486     /// @param owner Address of owner to be replaced.
487     /// @param owner Address of new owner.
488     function replaceOwner(address owner, address newOwner)
489         public
490         onlyWallet
491         ownerExists(owner)
492         ownerDoesNotExist(newOwner)
493     {
494         for (uint i = 0; i < owners.length; i++) {
495             if (owners[i] == owner) {
496                 owners[i] = newOwner;
497                 break;
498             }
499         }
500         isOwner[owner] = false;
501         isOwner[newOwner] = true;
502         OwnerRemoval(owner);
503         OwnerAddition(newOwner);
504     }
505 
506     /**
507     * @dev gives full ownership of this wallet to `_dest` removing older owners from wallet
508     * @param _dest the address of new controller
509     **/    
510     function releaseWallet(address _dest)
511         public
512         notNull(_dest)
513         ownerDoesNotExist(_dest)
514         onlyWallet
515     {
516         address[] memory _owners = owners;
517         uint numOwners = _owners.length;
518         addOwner(_dest);
519         for (uint i = 0; i < numOwners; i++) {
520             removeOwner(_owners[i]);
521         }
522     }
523 
524     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
525     /// @param _required Number of required confirmations.
526     function changeRequirement(uint _required)
527         public
528         onlyWallet
529         validRequirement(owners.length, _required)
530     {
531         required = _required;
532         RequirementChange(_required);
533     }
534 
535     /// @dev Allows an owner to submit and confirm a transaction.
536     /// @param destination Transaction target address.
537     /// @param value Transaction ether value.
538     /// @param data Transaction data payload.
539     /// @return Returns transaction ID.
540     function submitTransaction(address destination, uint value, bytes data)
541         public
542         returns (uint transactionId)
543     {
544         transactionId = addTransaction(destination, value, data);
545         confirmTransaction(transactionId);
546     }
547 
548     /// @dev Allows an owner to confirm a transaction.
549     /// @param transactionId Transaction ID.
550     function confirmTransaction(uint transactionId)
551         public
552         ownerExists(msg.sender)
553         transactionExists(transactionId)
554         notConfirmed(transactionId, msg.sender)
555     {
556         confirmations[transactionId][msg.sender] = true;
557         Confirmation(msg.sender, transactionId);
558         executeTransaction(transactionId);
559     }
560 
561     /// @dev Allows an owner to revoke a confirmation for a transaction.
562     /// @param transactionId Transaction ID.
563     function revokeConfirmation(uint transactionId)
564         public
565         ownerExists(msg.sender)
566         confirmed(transactionId, msg.sender)
567         notExecuted(transactionId)
568     {
569         confirmations[transactionId][msg.sender] = false;
570         Revocation(msg.sender, transactionId);
571     }
572 
573     /// @dev Allows anyone to execute a confirmed transaction.
574     /// @param transactionId Transaction ID.
575     function executeTransaction(uint transactionId)
576         public
577         notExecuted(transactionId)
578     {
579         if (isConfirmed(transactionId)) {
580             Transaction storage txx = transactions[transactionId];
581             txx.executed = true;
582             if (txx.destination.call.value(txx.value)(txx.data)) {
583                 Execution(transactionId);
584             } else {
585                 ExecutionFailure(transactionId);
586                 txx.executed = false;
587             }
588         }
589     }
590 
591     /**
592     * @dev withdraw all recognized tokens balances and ether to `_dest`
593     * @param _dest the address of receiver
594     **/    
595     function withdrawEverything(address _dest) 
596         public
597         notNull(_dest)
598         onlyWallet
599     {
600         withdrawAllTokens(_dest);
601         _dest.transfer(this.balance);
602     }
603 
604     /**
605     * @dev withdraw all recognized tokens balances to `_dest`
606     * @param _dest the address of receiver
607     **/    
608     function withdrawAllTokens(address _dest) 
609         public 
610         notNull(_dest)
611         onlyWallet
612     {
613         address[] memory _tokenList;
614         if (userList[_dest].length > 0) {
615             _tokenList = userList[_dest];
616         } else {
617             _tokenList = tokens;
618         }
619         uint len = _tokenList.length;
620         for (uint i = 0;i < len; i++) {
621             address _tokenAddr = _tokenList[i];
622             uint _amount = tokenBalances[_tokenAddr];
623             if (_amount > 0) {
624                 delete tokenBalances[_tokenAddr];
625                 ERC20(_tokenAddr).transfer(_dest, _amount);
626             }
627         }
628     }
629 
630     /**
631     * @dev withdraw `_tokenAddr` `_amount` to `_dest`
632     * @param _tokenAddr the address of the token
633     * @param _dest the address of receiver
634     * @param _amount the number of tokens to send
635     **/
636     function withdrawToken(address _tokenAddr, address _dest, uint _amount)
637         public
638         notNull(_dest)
639         onlyWallet 
640     {
641         require(_amount > 0);
642         uint _balance = tokenBalances[_tokenAddr];
643         require(_amount <= _balance);
644         tokenBalances[_tokenAddr] = _balance - _amount;
645         bool result = ERC20(_tokenAddr).transfer(_dest, _amount);
646         assert(result);
647     }
648 
649     /// @dev Returns the confirmation status of a transaction.
650     /// @param transactionId Transaction ID.
651     /// @return Confirmation status.
652     function isConfirmed(uint transactionId)
653         public
654         constant
655         returns (bool)
656     {
657         uint count = 0;
658         for (uint i = 0; i < owners.length; i++) {
659             if (confirmations[transactionId][owners[i]])
660                 count += 1;
661             if (count == required)
662                 return true;
663         }
664     }
665 
666     /*
667     * Internal functions
668     */
669     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
670     /// @param destination Transaction target address.
671     /// @param value Transaction ether value.
672     /// @param data Transaction data payload.
673     /// @return Returns transaction ID.
674     function addTransaction(address destination, uint value, bytes data)
675         internal
676         notNull(destination)
677         returns (uint transactionId)
678     {
679         transactionId = transactionCount;
680         transactions[transactionId] = Transaction({
681             destination: destination,
682             value: value,
683             data: data,
684             executed: false
685         });
686         transactionCount += 1;
687         Submission(transactionId);
688     }
689     
690     /**
691     * @dev register the deposit
692     **/
693     function _deposited(address _from,  uint _amount, address _tokenAddr, bytes) 
694         internal 
695     {
696         TokenDeposit(_tokenAddr,_from,_amount);
697         nonce++;
698         if (tokenBalances[_tokenAddr] == 0) {
699             tokens.push(_tokenAddr);  
700             tokenBalances[_tokenAddr] = ERC20(_tokenAddr).balanceOf(this);
701         } else {
702             tokenBalances[_tokenAddr] += _amount;
703         }
704     }
705     
706     /*
707     * Web3 call functions
708     */
709     /// @dev Returns number of confirmations of a transaction.
710     /// @param transactionId Transaction ID.
711     /// @return Number of confirmations.
712     function getConfirmationCount(uint transactionId)
713         public
714         constant
715         returns (uint count)
716     {
717         for (uint i = 0; i < owners.length; i++) {
718             if (confirmations[transactionId][owners[i]])
719                 count += 1;
720         }
721     }
722 
723     /// @dev Returns total number of transactions after filters are applied.
724     /// @param pending Include pending transactions.
725     /// @param executed Include executed transactions.
726     /// @return Total number of transactions after filters are applied.
727     function getTransactionCount(bool pending, bool executed)
728         public
729         constant
730         returns (uint count)
731     {
732         for (uint i = 0; i < transactionCount; i++) {
733             if (pending && !transactions[i].executed || executed && transactions[i].executed)
734                 count += 1;
735         }
736     }
737 
738     /// @dev Returns list of owners.
739     /// @return List of owner addresses.
740     function getOwners()
741         public
742         constant
743         returns (address[])
744     {
745         return owners;
746     }
747 
748     /// @dev Returns list of tokens.
749     /// @return List of token addresses.
750     function getTokenList()
751         public
752         constant
753         returns (address[])
754     {
755         return tokens;
756     }
757 
758     /// @dev Returns array with owner addresses, which confirmed transaction.
759     /// @param transactionId Transaction ID.
760     /// @return Returns array of owner addresses.
761     function getConfirmations(uint transactionId)
762         public
763         constant
764         returns (address[] _confirmations)
765     {
766         address[] memory confirmationsTemp = new address[](owners.length);
767         uint count = 0;
768         uint i;
769         for (i = 0; i < owners.length; i++) {
770             if (confirmations[transactionId][owners[i]]) {
771                 confirmationsTemp[count] = owners[i];
772                 count += 1;
773             }
774         }
775         _confirmations = new address[](count);
776         for (i = 0; i < count; i++) {
777             _confirmations[i] = confirmationsTemp[i];
778         }
779     }
780 
781     /// @dev Returns list of transaction IDs in defined range.
782     /// @param from Index start position of transaction array.
783     /// @param to Index end position of transaction array.
784     /// @param pending Include pending transactions.
785     /// @param executed Include executed transactions.
786     /// @return Returns array of transaction IDs.
787     function getTransactionIds(uint from, uint to, bool pending, bool executed)
788         public
789         constant
790         returns (uint[] _transactionIds)
791     {
792         uint[] memory transactionIdsTemp = new uint[](transactionCount);
793         uint count = 0;
794         uint i;
795         for (i = 0; i < transactionCount; i++) {
796             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
797                 transactionIdsTemp[count] = i;
798                 count += 1;
799             }
800         }
801         _transactionIds = new uint[](to - from);
802         for (i = from; i < to; i++) {
803             _transactionIds[i - from] = transactionIdsTemp[i];
804         }
805     }
806 
807 }
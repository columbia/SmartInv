1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     function balanceOf(address who) constant returns (uint256 balance);
6     function allowance(address owner, address spender) constant returns (uint256 remaining);
7     function transfer(address to, uint256 value) returns (bool ok); 
8     function transferFrom(address from, address to, uint256 value) returns (bool ok);
9     function approve(address spender, uint256 value) returns (bool ok);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract MultiSigTokenWallet {
15 
16     address[] public owners;
17     address[] public tokens;
18     mapping (uint => Transaction) public transactions;
19     mapping (uint => mapping (address => bool)) public confirmations;
20     uint public transactionCount;
21     
22     mapping (address => uint) public tokenBalances;
23     mapping (address => bool) public isOwner;
24     mapping (address => address[]) public userList;
25     uint public required;
26     uint public nonce;
27 
28     struct Transaction {
29         address destination;
30         uint value;
31         bytes data;
32         bool executed;
33     }
34 
35     uint constant public MAX_OWNER_COUNT = 50;
36 
37     event Confirmation(address indexed _sender, uint indexed _transactionId);
38     event Revocation(address indexed _sender, uint indexed _transactionId);
39     event Submission(uint indexed _transactionId);
40     event Execution(uint indexed _transactionId);
41     event ExecutionFailure(uint indexed _transactionId);
42     event Deposit(address indexed _sender, uint _value);
43     event TokenDeposit(address _token, address indexed _sender, uint _value);
44     event OwnerAddition(address indexed _owner);
45     event OwnerRemoval(address indexed _owner);
46     event RequirementChange(uint _required);
47     
48     modifier onlyWallet() {
49         require (msg.sender == address(this));
50         _;
51     }
52 
53     modifier ownerDoesNotExist(address owner) {
54         require (!isOwner[owner]);
55         _;
56     }
57 
58     modifier ownerExists(address owner) {
59         require (isOwner[owner]);
60         _;
61     }
62 
63     modifier transactionExists(uint transactionId) {
64         require (transactions[transactionId].destination != 0);
65         _;
66     }
67 
68     modifier confirmed(uint transactionId, address owner) {
69         require (confirmations[transactionId][owner]);
70         _;
71     }
72 
73     modifier notConfirmed(uint transactionId, address owner) {
74         require(!confirmations[transactionId][owner]);
75         _;
76     }
77 
78     modifier notExecuted(uint transactionId) {
79         require (!transactions[transactionId].executed);
80         _;
81     }
82 
83     modifier notNull(address _address) {
84         require (_address != 0);
85         _;
86     }
87 
88     modifier validRequirement(uint ownerCount, uint _required) {
89         require (ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
90         _;
91     }
92 
93     /// @dev Fallback function allows to deposit ether.
94     function()
95         payable
96     {
97         if (msg.value > 0)
98             Deposit(msg.sender, msg.value);
99     }
100 
101     /**
102     * Public functions
103     * 
104     **/
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     function constructor(address[] _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         require(owners.length == 0 && required == 0);
113         for (uint i = 0; i < _owners.length; i++) {
114             require(!isOwner[_owners[i]] && _owners[i] != 0);
115             isOwner[_owners[i]] = true;
116         }
117         owners = _owners;
118         required = _required;
119     }
120 
121     /**
122     * @notice deposit a ERC20 token. The amount of deposit is the allowance set to this contract.
123     * @param _token the token contract address
124     * @param _data might be used by child implementations
125     **/ 
126     function depositToken(address _token, bytes _data) 
127         public 
128     {
129         address sender = msg.sender;
130         uint amount = ERC20(_token).allowance(sender, this);
131         deposit(sender, amount, _token, _data);
132     }
133         
134     /**
135     * @notice deposit a ERC20 token. The amount of deposit is the allowance set to this contract.
136     * @param _token the token contract address
137     * @param _data might be used by child implementations
138     **/ 
139     function deposit(address _from, uint256 _amount, address _token, bytes _data) 
140         public 
141     {
142         if (_from == address(this))
143             return;
144         uint _nonce = nonce;
145         bool result = ERC20(_token).transferFrom(_from, this, _amount);
146         assert(result);
147         //ERC23 not executed _deposited tokenFallback by
148         if (nonce == _nonce) {
149             _deposited(_from, _amount, _token, _data);
150         }
151     }
152     /**
153     * @notice watches for balance in a token contract
154     * @param _tokenAddr the token contract address
155     **/   
156     function watch(address _tokenAddr) 
157         ownerExists(msg.sender) 
158     {
159         uint oldBal = tokenBalances[_tokenAddr];
160         uint newBal = ERC20(_tokenAddr).balanceOf(this);
161         if (newBal > oldBal) {
162             _deposited(0x0, newBal-oldBal, _tokenAddr, new bytes(0));
163         }
164     }
165 
166     function setMyTokenList(address[] _tokenList) 
167         public
168     {
169         userList[msg.sender] = _tokenList;
170     }
171 
172     function setTokenList(address[] _tokenList) 
173         onlyWallet
174     {
175         tokens = _tokenList;
176     }
177     
178     /**
179     * @notice ERC23 Token fallback
180     * @param _from address incoming token
181     * @param _amount incoming amount
182     **/    
183     function tokenFallback(address _from, uint _amount, bytes _data) 
184         public 
185     {
186         _deposited(_from, _amount, msg.sender, _data);
187     }
188         
189     /** 
190     * @notice Called MiniMeToken approvesAndCall to this contract, calls deposit.
191     * @param _from address incoming token
192     * @param _amount incoming amount
193     * @param _token the token contract address
194     * @param _data (might be used by child classes)
195     */ 
196     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) {
197         deposit(_from, _amount, _token, _data);
198     }
199     
200 
201     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
202     /// @param owner Address of new owner.
203     function addOwner(address owner)
204         public
205         onlyWallet
206         ownerDoesNotExist(owner)
207         notNull(owner)
208         validRequirement(owners.length + 1, required)
209     {
210         isOwner[owner] = true;
211         owners.push(owner);
212         OwnerAddition(owner);
213     }
214 
215     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
216     /// @param owner Address of owner.
217     function removeOwner(address owner)
218         public
219         onlyWallet
220         ownerExists(owner)
221     {
222         isOwner[owner] = false;
223         uint _len = owners.length - 1;
224         for (uint i = 0; i < _len; i++) {
225             if (owners[i] == owner) {
226                 owners[i] = owners[owners.length - 1];
227                 break;
228             }
229         }
230         owners.length -= 1;
231         if (required > owners.length)
232             changeRequirement(owners.length);
233         OwnerRemoval(owner);
234     }
235 
236     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
237     /// @param owner Address of owner to be replaced.
238     /// @param owner Address of new owner.
239     function replaceOwner(address owner, address newOwner)
240         public
241         onlyWallet
242         ownerExists(owner)
243         ownerDoesNotExist(newOwner)
244     {
245         for (uint i = 0; i < owners.length; i++) {
246             if (owners[i] == owner) {
247                 owners[i] = newOwner;
248                 break;
249             }
250         }
251         isOwner[owner] = false;
252         isOwner[newOwner] = true;
253         OwnerRemoval(owner);
254         OwnerAddition(newOwner);
255     }
256 
257     /**
258     * @dev gives full ownership of this wallet to `_dest` removing older owners from wallet
259     * @param _dest the address of new controller
260     **/    
261     function releaseWallet(address _dest)
262         public
263         notNull(_dest)
264         ownerDoesNotExist(_dest)
265         onlyWallet
266     {
267         address[] memory _owners = owners;
268         uint numOwners = _owners.length;
269         addOwner(_dest);
270         for (uint i = 0; i < numOwners; i++) {
271             removeOwner(_owners[i]);
272         }
273     }
274 
275     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
276     /// @param _required Number of required confirmations.
277     function changeRequirement(uint _required)
278         public
279         onlyWallet
280         validRequirement(owners.length, _required)
281     {
282         required = _required;
283         RequirementChange(_required);
284     }
285 
286     /// @dev Allows an owner to submit and confirm a transaction.
287     /// @param destination Transaction target address.
288     /// @param value Transaction ether value.
289     /// @param data Transaction data payload.
290     /// @return Returns transaction ID.
291     function submitTransaction(address destination, uint value, bytes data)
292         public
293         returns (uint transactionId)
294     {
295         transactionId = addTransaction(destination, value, data);
296         confirmTransaction(transactionId);
297     }
298 
299     /// @dev Allows an owner to confirm a transaction.
300     /// @param transactionId Transaction ID.
301     function confirmTransaction(uint transactionId)
302         public
303         ownerExists(msg.sender)
304         transactionExists(transactionId)
305         notConfirmed(transactionId, msg.sender)
306     {
307         confirmations[transactionId][msg.sender] = true;
308         Confirmation(msg.sender, transactionId);
309         executeTransaction(transactionId);
310     }
311 
312     /// @dev Allows an owner to revoke a confirmation for a transaction.
313     /// @param transactionId Transaction ID.
314     function revokeConfirmation(uint transactionId)
315         public
316         ownerExists(msg.sender)
317         confirmed(transactionId, msg.sender)
318         notExecuted(transactionId)
319     {
320         confirmations[transactionId][msg.sender] = false;
321         Revocation(msg.sender, transactionId);
322     }
323 
324     /// @dev Allows anyone to execute a confirmed transaction.
325     /// @param transactionId Transaction ID.
326     function executeTransaction(uint transactionId)
327         public
328         notExecuted(transactionId)
329     {
330         if (isConfirmed(transactionId)) {
331             Transaction storage txx = transactions[transactionId];
332             txx.executed = true;
333             if (txx.destination.call.value(txx.value)(txx.data)) {
334                 Execution(transactionId);
335             } else {
336                 ExecutionFailure(transactionId);
337                 txx.executed = false;
338             }
339         }
340     }
341 
342     /**
343     * @dev withdraw all recognized tokens balances and ether to `_dest`
344     * @param _dest the address of receiver
345     **/    
346     function withdrawEverything(address _dest) 
347         public
348         notNull(_dest)
349         onlyWallet
350     {
351         withdrawAllTokens(_dest);
352         _dest.transfer(this.balance);
353     }
354 
355     /**
356     * @dev withdraw all recognized tokens balances to `_dest`
357     * @param _dest the address of receiver
358     **/    
359     function withdrawAllTokens(address _dest) 
360         public 
361         notNull(_dest)
362         onlyWallet
363     {
364         address[] memory _tokenList;
365         if (userList[_dest].length > 0) {
366             _tokenList = userList[_dest];
367         } else {
368             _tokenList = tokens;
369         }
370         uint len = _tokenList.length;
371         for (uint i = 0;i < len; i++) {
372             address _tokenAddr = _tokenList[i];
373             uint _amount = tokenBalances[_tokenAddr];
374             if (_amount > 0) {
375                 delete tokenBalances[_tokenAddr];
376                 ERC20(_tokenAddr).transfer(_dest, _amount);
377             }
378         }
379     }
380 
381     /**
382     * @dev withdraw `_tokenAddr` `_amount` to `_dest`
383     * @param _tokenAddr the address of the token
384     * @param _dest the address of receiver
385     * @param _amount the number of tokens to send
386     **/
387     function withdrawToken(address _tokenAddr, address _dest, uint _amount)
388         public
389         notNull(_dest)
390         onlyWallet 
391     {
392         require(_amount > 0);
393         uint _balance = tokenBalances[_tokenAddr];
394         require(_amount <= _balance);
395         tokenBalances[_tokenAddr] = _balance - _amount;
396         bool result = ERC20(_tokenAddr).transfer(_dest, _amount);
397         assert(result);
398     }
399 
400     /// @dev Returns the confirmation status of a transaction.
401     /// @param transactionId Transaction ID.
402     /// @return Confirmation status.
403     function isConfirmed(uint transactionId)
404         public
405         constant
406         returns (bool)
407     {
408         uint count = 0;
409         for (uint i = 0; i < owners.length; i++) {
410             if (confirmations[transactionId][owners[i]])
411                 count += 1;
412             if (count == required)
413                 return true;
414         }
415     }
416 
417     /*
418     * Internal functions
419     */
420     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
421     /// @param destination Transaction target address.
422     /// @param value Transaction ether value.
423     /// @param data Transaction data payload.
424     /// @return Returns transaction ID.
425     function addTransaction(address destination, uint value, bytes data)
426         internal
427         notNull(destination)
428         returns (uint transactionId)
429     {
430         transactionId = transactionCount;
431         transactions[transactionId] = Transaction({
432             destination: destination,
433             value: value,
434             data: data,
435             executed: false
436         });
437         transactionCount += 1;
438         Submission(transactionId);
439     }
440     
441     /**
442     * @dev register the deposit
443     **/
444     function _deposited(address _from,  uint _amount, address _tokenAddr, bytes) 
445         internal 
446     {
447         TokenDeposit(_tokenAddr,_from,_amount);
448         nonce++;
449         if (tokenBalances[_tokenAddr] == 0) {
450             tokens.push(_tokenAddr);  
451             tokenBalances[_tokenAddr] = ERC20(_tokenAddr).balanceOf(this);
452         } else {
453             tokenBalances[_tokenAddr] += _amount;
454         }
455     }
456     
457     /*
458     * Web3 call functions
459     */
460     /// @dev Returns number of confirmations of a transaction.
461     /// @param transactionId Transaction ID.
462     /// @return Number of confirmations.
463     function getConfirmationCount(uint transactionId)
464         public
465         constant
466         returns (uint count)
467     {
468         for (uint i = 0; i < owners.length; i++) {
469             if (confirmations[transactionId][owners[i]])
470                 count += 1;
471         }
472     }
473 
474     /// @dev Returns total number of transactions after filters are applied.
475     /// @param pending Include pending transactions.
476     /// @param executed Include executed transactions.
477     /// @return Total number of transactions after filters are applied.
478     function getTransactionCount(bool pending, bool executed)
479         public
480         constant
481         returns (uint count)
482     {
483         for (uint i = 0; i < transactionCount; i++) {
484             if (pending && !transactions[i].executed || executed && transactions[i].executed)
485                 count += 1;
486         }
487     }
488 
489     /// @dev Returns list of owners.
490     /// @return List of owner addresses.
491     function getOwners()
492         public
493         constant
494         returns (address[])
495     {
496         return owners;
497     }
498 
499     /// @dev Returns list of tokens.
500     /// @return List of token addresses.
501     function getTokenList()
502         public
503         constant
504         returns (address[])
505     {
506         return tokens;
507     }
508 
509     /// @dev Returns array with owner addresses, which confirmed transaction.
510     /// @param transactionId Transaction ID.
511     /// @return Returns array of owner addresses.
512     function getConfirmations(uint transactionId)
513         public
514         constant
515         returns (address[] _confirmations)
516     {
517         address[] memory confirmationsTemp = new address[](owners.length);
518         uint count = 0;
519         uint i;
520         for (i = 0; i < owners.length; i++) {
521             if (confirmations[transactionId][owners[i]]) {
522                 confirmationsTemp[count] = owners[i];
523                 count += 1;
524             }
525         }
526         _confirmations = new address[](count);
527         for (i = 0; i < count; i++) {
528             _confirmations[i] = confirmationsTemp[i];
529         }
530     }
531 
532     /// @dev Returns list of transaction IDs in defined range.
533     /// @param from Index start position of transaction array.
534     /// @param to Index end position of transaction array.
535     /// @param pending Include pending transactions.
536     /// @param executed Include executed transactions.
537     /// @return Returns array of transaction IDs.
538     function getTransactionIds(uint from, uint to, bool pending, bool executed)
539         public
540         constant
541         returns (uint[] _transactionIds)
542     {
543         uint[] memory transactionIdsTemp = new uint[](transactionCount);
544         uint count = 0;
545         uint i;
546         for (i = 0; i < transactionCount; i++) {
547             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
548                 transactionIdsTemp[count] = i;
549                 count += 1;
550             }
551         }
552         _transactionIds = new uint[](to - from);
553         for (i = from; i < to; i++) {
554             _transactionIds[i - from] = transactionIdsTemp[i];
555         }
556     }
557 
558 }
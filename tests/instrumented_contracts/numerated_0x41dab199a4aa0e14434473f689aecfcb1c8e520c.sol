1 contract MultiSigERC20Token
2 {
3     uint constant public MAX_OWNER_COUNT = 50;
4 	
5     // Public variables of the token
6     string public name;
7     string public symbol;
8     uint8 public decimals = 8;
9     uint256 public totalSupply;
10 	address[] public owners;
11 	
12 	// Variables for multisig
13 	uint256 public required;
14     uint public transactionCount;
15 
16     // Events
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event FrozenFunds(address target, bool frozen);
19 	event Confirmation(address indexed sender, uint indexed transactionId);
20     event Revocation(address indexed sender, uint indexed transactionId);
21     event Submission(uint indexed transactionId,string operation, address source, address destination, uint256 value, string reason);
22     event Execution(uint indexed transactionId);
23     event ExecutionFailure(uint indexed transactionId);
24     event Deposit(address indexed sender, uint value);
25     event OwnerAddition(address indexed owner);
26     event OwnerRemoval(address indexed owner);
27     event RequirementChange(uint required);
28 	
29 	// Mappings
30     mapping (uint => MetaTransaction) public transactions;
31     mapping (address => uint256) public withdrawalLimit;
32     mapping (uint => mapping (address => bool)) public confirmations;
33     mapping (address => bool) public isOwner;
34 	mapping (address => bool) public frozenAccount;
35     mapping (address => uint256) public balanceOf;
36 
37     // Meta data for pending and executed Transactions
38     struct MetaTransaction {
39         address source;
40         address destination;
41         uint value;
42         bool executed;
43         uint operation;
44         string reason;
45     }
46 
47     // Modifiers
48 
49     modifier ownerDoesNotExist(address owner) {
50         require (!isOwner[owner]);
51         _;
52     }
53 
54     modifier ownerExists(address owner) {
55         require (isOwner[owner]);
56         _;
57     }
58 
59     modifier transactionExists(uint transactionId) {
60         require (transactions[transactionId].destination != 0);
61         _;
62     }
63 
64     modifier confirmed(uint transactionId, address owner) {
65         require (confirmations[transactionId][owner]);
66         _;
67     }
68 
69     modifier notConfirmed(uint transactionId, address owner) {
70         require (!confirmations[transactionId][owner]);
71         _;
72     }
73 
74     modifier notExecuted(uint transactionId) {
75         require (!transactions[transactionId].executed);
76         _;
77     }
78 
79     modifier notNull(address _address) {
80         require (_address != 0);
81         _;
82     }
83 
84     /// @dev Fallback function allows to deposit ether.
85     function() payable public
86     {
87         if (msg.value > 0)
88         {
89             emit Deposit(msg.sender, msg.value);
90         }
91     }
92 
93     /**
94      * Constrctor function
95      *
96      * Initializes contract with initial supply tokens to the contract and sets owner to the 
97      * creator of the contract
98      */
99    constructor(
100         uint256 initialSupply,
101         string tokenName,
102         string tokenSymbol
103     ) public {
104         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
105         balanceOf[this] = totalSupply;                      // Give the contract all initial tokens
106         name = tokenName;                                   // Set the name for display purposes
107         symbol = tokenSymbol;                               // Set the symbol for display purposes
108 		isOwner[msg.sender] = true;                         // Set Owner to Contract Creator
109 		required = 1;
110 		owners.push(msg.sender);
111     }
112 
113     /**
114      * Internal transfer, only can be called by this contract
115      */
116     function _transfer(address _from, address _to, uint _value) internal {
117         // Prevent transfer to 0x0 address. Use burn() instead
118         require(_to != 0x0);
119         // Check if the sender has enough
120         require(balanceOf[_from] >= _value);
121         // Check if the sender is frozen
122         require(!frozenAccount[_from]);
123         // Check if the recipient is frozen
124         require(!frozenAccount[_to]);
125         // Check for overflows
126         require(balanceOf[_to] + _value > balanceOf[_to]);
127         // Save this for an assertion in the future
128         uint previousBalances = balanceOf[_from] + balanceOf[_to];
129         // Subtract from the sender
130         balanceOf[_from] -= _value;
131         // Add the same to the recipient
132         balanceOf[_to] += _value;
133         emit Transfer(_from, _to, _value);
134         // Asserts are used to use static analysis to find bugs in your code. They should never fail
135         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
136     }
137 
138     /**
139      * Transfer tokens
140      *
141      * Send `_value` tokens to `_to` from your account
142      *
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transfer(address _to, uint256 _value) public {
147         _transfer(msg.sender, _to, _value);
148     }
149 	
150 	
151     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
152     /// @param target Address to be frozen
153     /// @param freeze either to freeze it or not
154     function freezeAccount(address target, bool freeze) internal {
155         frozenAccount[target] = freeze;
156         emit FrozenFunds(target, freeze);
157     }
158 	
159     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
160     /// @param owner Address of new owner.
161     function addOwner(address owner)
162         internal
163         ownerDoesNotExist(owner)
164         notNull(owner)
165     {
166         isOwner[owner] = true;
167         owners.push(owner);
168         required = required + 1;
169         emit OwnerAddition(owner);
170     }
171 
172     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
173     /// @param owner Address of owner.
174     function removeOwner(address owner)
175         internal
176         ownerExists(owner)
177     {
178         isOwner[owner] = false;
179         for (uint i=0; i<owners.length - 1; i++)
180             if (owners[i] == owner) {
181                 owners[i] = owners[owners.length - 1];
182                 break;
183             }
184         owners.length -= 1;
185         if (required > owners.length)
186             changeRequirement(owners.length);
187         emit OwnerRemoval(owner);
188     }
189 
190     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
191     /// @param owner Address of owner to be replaced.
192     /// @param owner Address of new owner.
193     function replaceOwner(address owner, address newOwner)
194         internal
195         ownerExists(owner)
196         ownerDoesNotExist(newOwner)
197     {
198         for (uint i=0; i<owners.length; i++)
199             if (owners[i] == owner) {
200                 owners[i] = newOwner;
201                 break;
202             }
203         isOwner[owner] = false;
204         isOwner[newOwner] = true;
205         emit OwnerRemoval(owner);
206         emit OwnerAddition(newOwner);
207     }
208 
209     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
210     /// @param _required Number of required confirmations.
211     function changeRequirement(uint256 _required)
212         internal
213     {
214         required = _required;
215         emit RequirementChange(_required);
216     }
217 
218     /// @dev Allows an owner to submit and confirm a transaction.
219     /// @param destination Transaction target address.
220     /// @param value Transaction ether value.
221     /// @return Returns transaction ID.
222     function submitTransaction(address source, address destination, uint256 value, uint operation, string reason)
223         public
224         returns (uint transactionId)
225     {
226         transactionId = transactionCount;
227         transactions[transactionId] = MetaTransaction({
228             source: source,
229             destination: destination,
230             value: value,
231             operation: operation,
232             executed: false,
233             reason: reason
234         });
235         
236         transactionCount += 1;
237         
238         if(operation == 1) // Operation 1 is Add Owner
239         {
240             emit Submission(transactionId,"Add Owner", source, destination, value, reason);
241         }
242         else if(operation == 2) // Operation 2 is Remove Owner
243         {
244             emit Submission(transactionId,"Remove Owner", source, destination, value, reason);
245         }
246         else if(operation == 3) // Operation 3 is Replace Owner
247         {
248             emit Submission(transactionId,"Replace Owner", source, destination, value, reason);
249         }
250         else if(operation == 4) // Operation 4 is Freeze Account
251         {
252             emit Submission(transactionId,"Freeze Account", source, destination, value, reason);
253         }
254         else if(operation == 5) // Operation 5 is UnFreeze Account
255         {
256             emit Submission(transactionId,"UnFreeze Account", source, destination, value, reason);
257         }
258         else if(operation == 6) // Operation 6 is change rquirement
259         {
260             emit Submission(transactionId,"Change Requirement", source, destination, value, reason);
261         }
262         else if(operation == 7) // Operation 7 is Issue Tokens from Contract
263         {
264             emit Submission(transactionId,"Issue Tokens", source, destination, value, reason);
265         }
266         else if(operation == 8) // Operation 8 is Admin Transfer Tokens
267         {
268             emit Submission(transactionId,"Admin Transfer Tokens", source, destination, value, reason);
269         }
270         else if(operation == 9) // Operation 9 is Set Owners Unsigned Withdrawal Limit
271         {
272             emit Submission(transactionId,"Set Unsigned Ethereum Withdrawal Limit", source, destination, value, reason);
273         }
274         else if(operation == 10) // Operation 10 is Admin Withdraw Ether without multisig
275         {
276             emit Submission(transactionId,"Unsigned Ethereum Withdrawal", source, destination, value, reason);
277         }
278         else if(operation == 11) // Operation 11 is Admin Withdraw Ether with multisig
279         {
280             emit Submission(transactionId,"Withdraw Ethereum", source, destination, value, reason);
281         }
282     }
283 
284     /// @dev Allows an owner to confirm a transaction.
285     /// @param transactionId Transaction ID.
286     function confirmTransaction(uint transactionId)
287         public
288         ownerExists(msg.sender)
289         transactionExists(transactionId)
290         notConfirmed(transactionId, msg.sender)
291     {
292         confirmations[transactionId][msg.sender] = true;
293         emit Confirmation(msg.sender, transactionId);
294         executeTransaction(transactionId);
295     }
296 
297     /// @dev Allows an owner to revoke a confirmation for a transaction.
298     /// @param transactionId Transaction ID.
299     function revokeConfirmation(uint transactionId)
300         public
301         ownerExists(msg.sender)
302         confirmed(transactionId, msg.sender)
303         notExecuted(transactionId)
304     {
305         confirmations[transactionId][msg.sender] = false;
306         emit Revocation(msg.sender, transactionId);
307     }
308 
309     /// @dev Allows anyone to execute a confirmed transaction.
310     /// @param transactionId Transaction ID.
311     function executeTransaction(uint transactionId)
312         public
313         notExecuted(transactionId)
314     {
315         if (isConfirmed(transactionId)) {
316             MetaTransaction storage transaction = transactions[transactionId];
317 
318             if(transaction.operation == 1) // Operation 1 is Add Owner
319             {
320                 addOwner(transaction.destination);
321                 
322                 transaction.executed = true;
323                 emit Execution(transactionId);
324             }
325             else if(transaction.operation == 2) // Operation 2 is Remove Owner
326             {
327                 removeOwner(transaction.destination);
328                 
329                 transaction.executed = true;
330                 emit Execution(transactionId);
331             }
332             else if(transaction.operation == 3) // Operation 3 is Replace Owner
333             {
334                 replaceOwner(transaction.source,transaction.destination);
335                 
336                 transaction.executed = true;
337                 emit Execution(transactionId);
338             }
339             else if(transaction.operation == 4) // Operation 4 is Freeze Account
340             {
341                 freezeAccount(transaction.destination,true);
342                 
343                 transaction.executed = true;
344                 emit Execution(transactionId);
345             }
346             else if(transaction.operation == 5) // Operation 5 is UnFreeze Account
347             {
348                 freezeAccount(transaction.destination, false);
349                 
350                 transaction.executed = true;
351                 emit Execution(transactionId);
352             }
353             else if(transaction.operation == 6) // Operation 6 is UnFreeze Account
354             {
355                 changeRequirement(transaction.value);
356                 
357                 transaction.executed = true;
358                 emit Execution(transactionId);
359             }
360             else if(transaction.operation == 7) // Operation 7 is Issue Tokens from Contract
361             {
362                 _transfer(this,transaction.destination,transaction.value);
363                 
364                 transaction.executed = true;
365                 emit Execution(transactionId);
366             }
367             else if(transaction.operation == 8) // Operation 8 is Admin Transfer Tokens
368             {
369                 _transfer(transaction.source,transaction.destination,transaction.value);
370                 
371                 transaction.executed = true;
372                 emit Execution(transactionId);
373             }
374             else if(transaction.operation == 9) // Operation 9 is Set Owners Unsigned Withdrawal Limit
375             {
376                 require(isOwner[transaction.destination]);
377                 withdrawalLimit[transaction.destination] = transaction.value;
378                 
379                 transaction.executed = true;
380                 emit Execution(transactionId);
381             }
382             else if(transaction.operation == 11) // Operation 11 is Admin Withdraw Ether with multisig
383             {
384                 require(isOwner[transaction.destination]);
385                 
386                 transaction.destination.transfer(transaction.value);
387                 
388                 transaction.executed = true;
389                 emit Execution(transactionId);
390             }
391         }
392         else if(transaction.operation == 10) // Operation 10 is Admin Withdraw Ether without multisig
393         {
394             require(isOwner[transaction.destination]);
395             require(withdrawalLimit[transaction.destination] <= transaction.value);
396             
397             withdrawalLimit[transaction.destination] -= transaction.value;
398             
399             assert(withdrawalLimit[transaction.destination] > 0);
400             
401             transaction.destination.transfer(transaction.value);
402             transaction.executed = true;
403             emit Execution(transactionId);
404         }
405     }
406 
407     /// @dev Returns the confirmation status of a transaction.
408     /// @param transactionId Transaction ID.
409     /// @return Confirmation status.
410     function isConfirmed(uint transactionId)
411         public
412         constant
413         returns (bool)
414     {
415         uint count = 0;
416         for (uint i=0; i<owners.length; i++) {
417             if (confirmations[transactionId][owners[i]])
418                 count += 1;
419             if (count == required)
420                 return true;
421         }
422     }
423 
424     /*
425      * Internal functions
426      */
427    
428     /*
429      * Web3 call functions
430      */
431     /// @dev Returns number of confirmations of a transaction.
432     /// @param transactionId Transaction ID.
433     /// @return Number of confirmations.
434     function getConfirmationCount(uint transactionId)
435         public
436         constant
437         returns (uint count)
438     {
439         for (uint i=0; i<owners.length; i++)
440             if (confirmations[transactionId][owners[i]])
441                 count += 1;
442     }
443 
444     /// @dev Returns total number of transactions after filers are applied.
445     /// @param pending Include pending transactions.
446     /// @param executed Include executed transactions.
447     /// @return Total number of transactions after filters are applied.
448     function getTransactionCount(bool pending, bool executed)
449         public
450         constant
451         returns (uint count)
452     {
453         for (uint i=0; i<transactionCount; i++)
454             if (   pending && !transactions[i].executed
455                 || executed && transactions[i].executed)
456                 count += 1;
457     }
458 
459     /// @dev Returns list of owners.
460     /// @return List of owner addresses.
461     function getOwners()
462         public
463         constant
464         returns (address[])
465     {
466         return owners;
467     }
468 
469     /// @dev Returns array with owner addresses, which confirmed transaction.
470     /// @param transactionId Transaction ID.
471     /// @return Returns array of owner addresses.
472     function getConfirmations(uint transactionId)
473         public
474         constant
475         returns (address[] _confirmations)
476     {
477         address[] memory confirmationsTemp = new address[](owners.length);
478         uint count = 0;
479         uint i;
480         for (i=0; i<owners.length; i++)
481             if (confirmations[transactionId][owners[i]]) {
482                 confirmationsTemp[count] = owners[i];
483                 count += 1;
484             }
485         _confirmations = new address[](count);
486         for (i=0; i<count; i++)
487             _confirmations[i] = confirmationsTemp[i];
488     }
489 
490     /// @dev Returns list of transaction IDs in defined range.
491     /// @param from Index start position of transaction array.
492     /// @param to Index end position of transaction array.
493     /// @param pending Include pending transactions.
494     /// @param executed Include executed transactions.
495     /// @return Returns array of transaction IDs.
496     function getTransactionIds(uint from, uint to, bool pending, bool executed)
497         public
498         constant
499         returns (uint[] _transactionIds)
500     {
501         uint[] memory transactionIdsTemp = new uint[](transactionCount);
502         uint count = 0;
503         uint i;
504         for (i=0; i<transactionCount; i++)
505             if (   pending && !transactions[i].executed
506                 || executed && transactions[i].executed)
507             {
508                 transactionIdsTemp[count] = i;
509                 count += 1;
510             }
511         _transactionIds = new uint[](to - from);
512         for (i=from; i<to; i++)
513             _transactionIds[i - from] = transactionIdsTemp[i];
514     }
515 }
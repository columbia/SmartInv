1 pragma solidity ^0.4.18;
2 
3 /**
4  * ERC721 interface
5  *
6  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
7  * @author Yumin.yang
8  */
9 contract ERC721 {
10   // Required methods
11   function totalSupply() public view returns (uint256 total);
12   function balanceOf(address _owner) public view returns (uint256 balance);
13   //function ownerOf(uint256 _tokenId) external view returns (address owner);
14   //function approve(address _to, uint256 _tokenId) external;
15   function transfer(address _to, uint256 _tokenId) external;
16   //function transferFrom(address _from, address _to, uint256 _tokenId) external;
17 
18   // Events
19   event Transfer(address from, address to, uint256 tokenId);
20   // event Approval(address owner, address approved, uint256 tokenId);
21 }
22 
23 /**
24  * First Commons Forum
25  *
26  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
27  * @author Yumin.yang
28  */
29 contract DivisibleFirstCommonsForumToken is ERC721 {
30 
31   //This contract's owner
32   address private contractOwner;
33 
34   //Participation token storage.
35   mapping(uint => ParticipationToken) participationStorage;
36 
37   // Total supply of this token.
38   uint public totalSupply = 19;
39   bool public tradable = false;
40   uint firstCommonsForumId = 1;
41 
42   // Divisibility of ownership over a token
43   mapping(address => mapping(uint => uint)) ownerToTokenShare;
44 
45   // How much owners have of a token
46   mapping(uint => mapping(address => uint)) tokenToOwnersHoldings;
47 
48   // If First Commons Forum has been created
49   mapping(uint => bool) firstCommonsForumCreated;
50 
51   string public name;
52   string public symbol;
53   uint8 public decimals = 0;
54   string public version = "1.0";
55 
56   // Special participation token
57   struct ParticipationToken {
58     uint256 participationId;
59   }
60 
61   // @dev Constructor
62   function DivisibleFirstCommonsForumToken() public {
63     contractOwner = msg.sender;
64     name = "FirstCommonsForum";
65     symbol = "FCFT";
66 
67     // Create First Commons Forum
68     ParticipationToken memory newParticipation = ParticipationToken({ participationId: firstCommonsForumId });
69     participationStorage[firstCommonsForumId] = newParticipation;
70 
71     firstCommonsForumCreated[firstCommonsForumId] = true;
72     _addNewOwnerHoldingsToToken(contractOwner, firstCommonsForumId, totalSupply);
73     _addShareToNewOwner(contractOwner, firstCommonsForumId, totalSupply);
74   }
75 
76   // Fallback funciton
77   function() public {
78     revert();
79   }
80 
81   function totalSupply() public view returns (uint256 total) {
82     return totalSupply;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return ownerToTokenShare[_owner][firstCommonsForumId];
87   }
88 
89   // We use parameter '_tokenId' as the divisibility
90   function transfer(address _to, uint256 _tokenId) external {
91 
92     // Requiring this contract be tradable
93     require(tradable == true);
94     require(_to != address(0));
95     require(msg.sender != _to);
96 
97     // Take _tokenId as divisibility
98     uint256 _divisibility = _tokenId;
99 
100     // Requiring msg.sender has Holdings of First Commons Forum
101     require(tokenToOwnersHoldings[firstCommonsForumId][msg.sender] >= _divisibility);
102 
103     // Remove divisibilitys from old owner
104     _removeShareFromLastOwner(msg.sender, firstCommonsForumId, _divisibility);
105     _removeLastOwnerHoldingsFromToken(msg.sender, firstCommonsForumId, _divisibility);
106 
107     // Add divisibilitys to new owner
108     _addNewOwnerHoldingsToToken(_to, firstCommonsForumId, _divisibility);
109     _addShareToNewOwner(_to, firstCommonsForumId, _divisibility);
110 
111     // Trigger Ethereum Event
112     Transfer(msg.sender, _to, firstCommonsForumId);
113   }
114 
115   // Transfer participation to a new owner.
116   function assignSharedOwnership(address _to, uint256 _divisibility) onlyOwner external returns (bool success) {
117 
118     require(_to != address(0));
119     require(msg.sender != _to);
120     require(_to != address(this));
121 
122     // Requiring msg.sender has Holdings of First Commons Forum
123     require(tokenToOwnersHoldings[firstCommonsForumId][msg.sender] >= _divisibility);
124 
125     // Remove ownership from oldOwner(msg.sender)
126     _removeLastOwnerHoldingsFromToken(msg.sender, firstCommonsForumId, _divisibility);
127     _removeShareFromLastOwner(msg.sender, firstCommonsForumId, _divisibility);
128 
129     // Add ownership to NewOwner(address _to)
130     _addShareToNewOwner(_to, firstCommonsForumId, _divisibility);
131     _addNewOwnerHoldingsToToken(_to, firstCommonsForumId, _divisibility);
132 
133     // Trigger Ethereum Event
134     Transfer(msg.sender, _to, firstCommonsForumId);
135 
136     return true;
137   }
138 
139   function getFirstCommonsForum() public view returns(uint256 _firstCommonsForumId) {
140     return participationStorage[firstCommonsForumId].participationId;
141   }
142 
143   // Turn on this contract to be tradable, so owners can transfer their token
144   function turnOnTradable() public onlyOwner {
145     tradable = true;
146   }
147 
148   // -------------------- Helper functions (internal functions) --------------------
149 
150   // Add divisibility to new owner
151   function _addShareToNewOwner(address _owner, uint _tokenId, uint _units) internal {
152     ownerToTokenShare[_owner][_tokenId] += _units;
153   }
154 
155   // Add the divisibility to new owner
156   function _addNewOwnerHoldingsToToken(address _owner, uint _tokenId, uint _units) internal {
157     tokenToOwnersHoldings[_tokenId][_owner] += _units;
158   }
159 
160   // Remove divisibility from last owner
161   function _removeShareFromLastOwner(address _owner, uint _tokenId, uint _units) internal {
162     ownerToTokenShare[_owner][_tokenId] -= _units;
163   }
164 
165   // Remove divisibility from last owner
166   function _removeLastOwnerHoldingsFromToken(address _owner, uint _tokenId, uint _units) internal {
167     tokenToOwnersHoldings[_tokenId][_owner] -= _units;
168   }
169 
170   // Withdraw Ether from this contract to Multi sigin wallet
171   function withdrawEther() onlyOwner public returns(bool) {
172     return contractOwner.send(this.balance);
173   }
174 
175   // -------------------- Modifier --------------------
176 
177   modifier onlyExistentToken(uint _tokenId) {
178     require(firstCommonsForumCreated[_tokenId] == true);
179     _;
180   }
181 
182   modifier onlyOwner(){
183     require(msg.sender == contractOwner);
184     _;
185   }
186 
187 }
188 
189 
190 /**
191  * MultiSig Wallet
192  *
193  * @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
194  * @author Stefan George - <stefan.george@consensys.net>
195  */
196 contract MultiSigWallet {
197 
198   uint constant public MAX_OWNER_COUNT = 50;
199 
200   event Confirmation(address indexed sender, uint indexed transactionId);
201   event Revocation(address indexed sender, uint indexed transactionId);
202   event Submission(uint indexed transactionId);
203   event Execution(uint indexed transactionId);
204   event ExecutionFailure(uint indexed transactionId);
205   event Deposit(address indexed sender, uint value);
206   event OwnerAddition(address indexed owner);
207   event OwnerRemoval(address indexed owner);
208   event RequirementChange(uint required);
209   event CoinCreation(address coin);
210 
211   mapping (uint => Transaction) public transactions;
212   mapping (uint => mapping (address => bool)) public confirmations;
213   mapping (address => bool) public isOwner;
214   address[] public owners;
215   uint public required;
216   uint public transactionCount;
217   bool flag = true;
218 
219   struct Transaction {
220     address destination;
221     uint value;
222     bytes data;
223     bool executed;
224   }
225 
226   modifier onlyWallet() {
227     if (msg.sender != address(this))
228     revert();
229     _;
230   }
231 
232   modifier ownerDoesNotExist(address owner) {
233     if (isOwner[owner])
234     revert();
235     _;
236   }
237 
238   modifier ownerExists(address owner) {
239     if (!isOwner[owner])
240     revert();
241     _;
242   }
243 
244   modifier transactionExists(uint transactionId) {
245     if (transactions[transactionId].destination == 0)
246     revert();
247     _;
248   }
249 
250   modifier confirmed(uint transactionId, address owner) {
251     if (!confirmations[transactionId][owner])
252     revert();
253     _;
254   }
255 
256   modifier notConfirmed(uint transactionId, address owner) {
257     if (confirmations[transactionId][owner])
258     revert();
259     _;
260   }
261 
262   modifier notExecuted(uint transactionId) {
263     if (transactions[transactionId].executed)
264     revert();
265     _;
266   }
267 
268   modifier notNull(address _address) {
269     if (_address == 0)
270     revert();
271     _;
272   }
273 
274   modifier validRequirement(uint ownerCount, uint _required) {
275     if (ownerCount > MAX_OWNER_COUNT || _required > ownerCount || _required == 0 || ownerCount == 0)
276       revert();
277       _;
278   }
279 
280   /**
281    * @dev Fallback function allows to deposit ether.
282    */
283   function() payable {
284     if (msg.value > 0)
285     Deposit(msg.sender, msg.value);
286   }
287 
288   /*
289    * Public functions
290    *
291    * @dev Contract constructor sets initial owners and required number of confirmations.
292    * @param _owners List of initial owners.
293    * @param _required Number of required confirmations.
294    */
295   function MultiSigWallet(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
296     for (uint i=0; i<_owners.length; i++) {
297       if (isOwner[_owners[i]] || _owners[i] == 0)
298       revert();
299       isOwner[_owners[i]] = true;
300     }
301     owners = _owners;
302     required = _required;
303   }
304 
305   /**
306    * @dev Allows to add a new owner. Transaction has to be sent by wallet.
307    * @param owner Address of new owner.
308    */
309   function addOwner(address owner) public onlyWallet ownerDoesNotExist(owner) notNull(owner) validRequirement(owners.length + 1, required) {
310     isOwner[owner] = true;
311     owners.push(owner);
312     OwnerAddition(owner);
313   }
314 
315   /**
316    * @dev Allows to remove an owner. Transaction has to be sent by wallet.
317    * @param owner Address of owner.
318    */
319   function removeOwner(address owner) public onlyWallet ownerExists(owner) {
320     isOwner[owner] = false;
321     for (uint i=0; i<owners.length - 1; i++)
322 
323     if (owners[i] == owner) {
324       owners[i] = owners[owners.length - 1];
325       break;
326     }
327     owners.length -= 1;
328 
329     if (required > owners.length)
330     changeRequirement(owners.length);
331     OwnerRemoval(owner);
332   }
333 
334   /**
335    * @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
336    * @param owner Address of owner to be replaced.
337    * @param owner Address of new owner.
338    */
339   function replaceOwner(address owner, address newOwner) public onlyWallet ownerExists(owner) ownerDoesNotExist(newOwner) {
340     for (uint i=0; i<owners.length; i++)
341     if (owners[i] == owner) {
342       owners[i] = newOwner;
343       break;
344     }
345     isOwner[owner] = false;
346     isOwner[newOwner] = true;
347     OwnerRemoval(owner);
348     OwnerAddition(newOwner);
349   }
350 
351   /**
352    * @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
353    * @param _required Number of required confirmations.
354    */
355   function changeRequirement(uint _required) public onlyWallet validRequirement(owners.length, _required) {
356     required = _required;
357     RequirementChange(_required);
358   }
359 
360   /**
361    * @dev Allows an owner to submit and confirm a transaction.
362    * @param destination Transaction target address.
363    * @param value Transaction ether value.
364    * @param data Transaction data payload.
365    * @return Returns transaction ID.
366    */
367   function submitTransaction(address destination, uint value, bytes data) public returns (uint transactionId) {
368     transactionId = addTransaction(destination, value, data);
369     confirmTransaction(transactionId);
370   }
371 
372   /**
373    * @dev Allows an owner to confirm a transaction.
374    * @param transactionId Transaction ID.
375    */
376   function confirmTransaction(uint transactionId) public ownerExists(msg.sender) transactionExists(transactionId) notConfirmed(transactionId, msg.sender) {
377     confirmations[transactionId][msg.sender] = true;
378     Confirmation(msg.sender, transactionId);
379     executeTransaction(transactionId);
380   }
381 
382   /**
383    * @dev Allows an owner to revoke a confirmation for a transaction.
384    * @param transactionId Transaction ID.
385    */
386   function revokeConfirmation(uint transactionId) public ownerExists(msg.sender) confirmed(transactionId, msg.sender) notExecuted(transactionId) {
387     confirmations[transactionId][msg.sender] = false;
388     Revocation(msg.sender, transactionId);
389   }
390 
391   /**
392    * @dev Allows anyone to execute a confirmed transaction.
393    * @param transactionId Transaction ID.
394    */
395   function executeTransaction(uint transactionId) public notExecuted(transactionId) {
396     if (isConfirmed(transactionId)) {
397       Transaction tx = transactions[transactionId];
398       tx.executed = true;
399       if (tx.destination.call.value(tx.value)(tx.data))
400       Execution(transactionId);
401       else {
402         ExecutionFailure(transactionId);
403         tx.executed = false;
404       }
405     }
406   }
407 
408   /**
409    * @dev Returns the confirmation status of a transaction.
410    * @param transactionId Transaction ID.
411    * @return Confirmation status.
412    */
413   function isConfirmed(uint transactionId) public constant returns (bool) {
414     uint count = 0;
415     for (uint i=0; i<owners.length; i++) {
416       if (confirmations[transactionId][owners[i]])
417       count += 1;
418       if (count == required)
419       return true;
420     }
421   }
422 
423   /**
424    * Internal functions
425    *
426    * @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
427    * @param destination Transaction target address.
428    * @param value Transaction ether value.
429    * @param data Transaction data payload.
430    * @return Returns transaction ID.
431    */
432   function addTransaction(address destination, uint value, bytes data) internal notNull(destination) returns (uint transactionId) {
433     transactionId = transactionCount;
434     transactions[transactionId] = Transaction({
435       destination: destination,
436       value: value,
437       data: data,
438       executed: false
439     });
440     transactionCount += 1;
441     Submission(transactionId);
442   }
443 
444   /**
445    * Web3 call functions
446    *
447    * @dev Returns number of confirmations of a transaction.
448    * @param transactionId Transaction ID.
449    * @return Number of confirmations.
450    */
451   function getConfirmationCount(uint transactionId) public constant returns (uint count) {
452     for (uint i=0; i<owners.length; i++)
453     if (confirmations[transactionId][owners[i]])
454     count += 1;
455   }
456 
457   /**
458    * @dev Returns total number of transactions after filers are applied.
459    * @param pending Include pending transactions.
460    * @param executed Include executed transactions.
461    * @return Total number of transactions after filters are applied.
462    */
463   function getTransactionCount(bool pending, bool executed) public constant returns (uint count) {
464     for (uint i=0; i<transactionCount; i++)
465     if (   pending && !transactions[i].executed || executed && transactions[i].executed)
466       count += 1;
467   }
468 
469   /**
470    * @dev Returns list of owners.
471    * @return List of owner addresses.
472    */
473   function getOwners() public constant returns (address[]) {
474     return owners;
475   }
476 
477   /**
478    * @dev Returns array with owner addresses, which confirmed transaction.
479    * @param transactionId Transaction ID.
480    * @return Returns array of owner addresses.
481    */
482   function getConfirmations(uint transactionId) public constant returns (address[] _confirmations) {
483     address[] memory confirmationsTemp = new address[](owners.length);
484     uint count = 0;
485     uint i;
486     for (i=0; i<owners.length; i++)
487     if (confirmations[transactionId][owners[i]]) {
488       confirmationsTemp[count] = owners[i];
489       count += 1;
490     }
491     _confirmations = new address[](count);
492     for (i=0; i<count; i++)
493     _confirmations[i] = confirmationsTemp[i];
494   }
495 
496   /**
497    * @dev Returns list of transaction IDs in defined range.
498    * @param from Index start position of transaction array.
499    * @param to Index end position of transaction array.
500    * @param pending Include pending transactions.
501    * @param executed Include executed transactions.
502    * @return Returns array of transaction IDs.
503    */
504   function getTransactionIds(uint from, uint to, bool pending, bool executed) public constant returns (uint[] _transactionIds) {
505     uint[] memory transactionIdsTemp = new uint[](transactionCount);
506     uint count = 0;
507     uint i;
508     for (i=0; i<transactionCount; i++)
509     if (pending && !transactions[i].executed || executed && transactions[i].executed) {
510         transactionIdsTemp[count] = i;
511         count += 1;
512     }
513       _transactionIds = new uint[](to - from);
514       for (i=from; i<to; i++)
515       _transactionIds[i - from] = transactionIdsTemp[i];
516   }
517 
518   modifier onlyOwner() {
519     require(isOwner[msg.sender] == true);
520     _;
521   }
522 
523   /**
524    * @dev Create new first commons forum.
525    */
526   function createFirstCommonsForum() external onlyWallet {
527     require(flag == true);
528     CoinCreation(new DivisibleFirstCommonsForumToken());
529     flag = false;
530   }
531 }
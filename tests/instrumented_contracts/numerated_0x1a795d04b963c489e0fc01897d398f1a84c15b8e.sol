1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 {
59   function totalSupply() public view returns (uint256);
60 
61   function balanceOf(address _who) public view returns (uint256);
62 
63   function allowance(address _owner, address _spender)
64     public view returns (uint256);
65 
66   function transfer(address _to, uint256 _value) public returns (bool);
67 
68   function approve(address _spender, uint256 _value)
69     public returns (bool);
70 
71   function transferFrom(address _from, address _to, uint256 _value)
72     public returns (bool);
73 
74   event Transfer(
75     address indexed from,
76     address indexed to,
77     uint256 value
78   );
79 
80   event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84   );
85 }
86 
87 
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/issues/20
94  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20 {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev Total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param _owner address The address which owns the funds.
124    * @param _spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(
128     address _owner,
129     address _spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return allowed[_owner][_spender];
136   }
137 
138   /**
139   * @dev Transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_value <= balances[msg.sender]);
145     require(_to != address(0));
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     emit Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(
203     address _spender,
204     uint256 _addedValue
205   )
206     public
207     returns (bool)
208   {
209     allowed[msg.sender][_spender] = (
210       allowed[msg.sender][_spender].add(_addedValue));
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To decrement
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _subtractedValue The amount of tokens to decrease the allowance by.
223    */
224   function decreaseApproval(
225     address _spender,
226     uint256 _subtractedValue
227   )
228     public
229     returns (bool)
230   {
231     uint256 oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue >= oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 
245 /**
246  * @title SafeERC20
247  * @dev Wrappers around ERC20 operations that throw on failure.
248  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
249  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
250  */
251 library SafeERC20 {
252   function safeTransfer(
253     ERC20 _token,
254     address _to,
255     uint256 _value
256   )
257     internal
258   {
259     require(_token.transfer(_to, _value));
260   }
261 
262   function safeTransferFrom(
263     ERC20 _token,
264     address _from,
265     address _to,
266     uint256 _value
267   )
268     internal
269   {
270     require(_token.transferFrom(_from, _to, _value));
271   }
272 
273   function safeApprove(
274     ERC20 _token,
275     address _spender,
276     uint256 _value
277   )
278     internal
279   {
280     require(_token.approve(_spender, _value));
281   }
282 }
283 
284 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
285 /// @author Stefan George - <stefan.george@consensys.net>
286 /// modified by Juwita Winadwiastuti - <juwita.winadwiastuti[at]hara.ag>
287 ///             Arkan Gilang - <arkan.gilang[at]hara.ag>
288 contract MultiSigWallet {
289 
290     /*
291      *  Events
292      */
293     event Confirmation(address indexed sender, uint indexed transactionId);
294     event Revocation(address indexed sender, uint indexed transactionId);
295     event Submission(uint indexed transactionId);
296     event Execution(uint indexed transactionId);
297     event ExecutionFailure(uint indexed transactionId);
298     event Deposit(address indexed sender, uint value);
299     event OwnerAddition(address indexed owner);
300     event OwnerRemoval(address indexed owner);
301     event RequirementChange(uint required);
302 
303     using SafeERC20 for ERC20;
304 
305     /*
306      *  Constants
307      */
308     uint constant public MAX_OWNER_COUNT = 50;
309 
310     /*
311      *  Storage
312      */
313     mapping (uint => Transaction) public transactions;
314     mapping (uint => mapping (address => bool)) public confirmations;
315     mapping (address => bool) public isOwner;
316     mapping (uint => address) public tokens;
317     mapping (uint => bool) public tokenset;
318     address[] public owners;
319     uint public required;
320     uint public transactionCount;
321 
322     struct Transaction {
323         address destination;
324         uint txType; // 0 = etherWithdraw 1 = addOwner 2 = removeOwner 10-19 = tokenWithdraw
325         uint value;
326         bool executed;
327     }
328 
329     /*
330      *  Modifiers
331      */
332     modifier ownerDoesNotExist(address owner) {
333         require(!isOwner[owner]);
334         _;
335     }
336 
337     modifier ownerExists(address owner) {
338         require(isOwner[owner]);
339         _;
340     }
341 
342     modifier transactionExists(uint transactionId) {
343         require(transactions[transactionId].destination != 0);
344         _;
345     }
346 
347     modifier confirmed(uint transactionId, address owner) {
348         require(confirmations[transactionId][owner]);
349         _;
350     }
351 
352     modifier notConfirmed(uint transactionId, address owner) {
353         require(!confirmations[transactionId][owner]);
354         _;
355     }
356 
357     modifier notExecuted(uint transactionId) {
358         require(!transactions[transactionId].executed);
359         _;
360     }
361 
362     modifier notNull(address _address) {
363         require(_address != 0);
364         _;
365     }
366 
367     modifier validRequirement(uint ownerCount, uint _required) {
368         require(ownerCount <= MAX_OWNER_COUNT
369             && _required <= ownerCount
370             && _required != 0
371             && ownerCount != 0);
372         _;
373     }
374 
375     modifier tokenIsSet(uint tokenId) {
376         require(tokenset[tokenId]);
377         _;
378     }
379 
380     modifier tokenNotSet(uint tokenId) {
381         require(!tokenset[tokenId]);
382         _;
383     }
384 
385     /// @dev Fallback function allows to deposit wei.
386     function()        
387         public
388         payable
389     {
390         if (msg.value > 0)
391             emit Deposit(msg.sender, msg.value);
392     }
393 
394     /*
395      * Public functions
396      */
397     /// @dev Contract constructor sets initial owners and required number of confirmations.
398     constructor()
399         public
400     {
401         owners = [msg.sender];
402         isOwner[msg.sender] = true;
403         required = 1;
404     }
405     
406     function setToken(uint tokenId, address tokenContract)
407         public
408         tokenNotSet(tokenId)
409     {
410         tokens[tokenId]=tokenContract;
411         tokenset[tokenId]=true;
412     }
413 
414     /// @dev Allows to add a new owner. Transaction has to be sent by owner.
415     /// @param owner Address of new owner.
416     function addOwner(address owner)
417         private
418         ownerExists(msg.sender)
419         ownerDoesNotExist(owner)
420         notNull(owner)
421         validRequirement(owners.length + 1, required)
422         returns (bool) 
423     {
424         isOwner[owner] = true;
425         owners.push(owner);
426         emit OwnerAddition(owner);
427         uint halfOwner = uint(owners.length)/2;
428         changeRequirement(halfOwner + 1);
429         return true;
430     }
431 
432     /// @dev Allows to remove an owner. Transaction has to be sent by owner.
433     /// @param owner Address of owner.
434     function removeOwner(address owner)
435         private
436         ownerExists(owner)
437         ownerExists(msg.sender)
438         returns (bool) 
439     {
440         uint halfOwner = uint(owners.length - 1)/2;
441         changeRequirement(halfOwner + 1);
442 
443         isOwner[owner] = false;
444         for (uint i=0; i<owners.length - 1; i++)
445             if (owners[i] == owner) {
446                 owners[i] = owners[owners.length - 1];
447                 break;
448             }
449         owners.length -= 1;
450         emit OwnerRemoval(owner);
451         return true;
452     }
453 
454     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by owner.
455     /// @param owner Address of owner to be replaced.
456     /// @param newOwner Address of new owner.
457     function replaceOwner(address owner, address newOwner)
458         public
459         ownerExists(msg.sender)
460         ownerExists(owner)
461         ownerDoesNotExist(newOwner)
462     {
463         for (uint i=0; i<owners.length; i++)
464             if (owners[i] == owner) {
465                 owners[i] = newOwner;
466                 break;
467             }
468         isOwner[owner] = false;
469         isOwner[newOwner] = true;
470         emit OwnerRemoval(owner);
471         emit OwnerAddition(newOwner);
472     }
473 
474     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by owner.
475     /// @param _required Number of required confirmations.
476     function changeRequirement(uint _required)
477         private
478         ownerExists(msg.sender)
479         validRequirement(owners.length, _required)
480     {
481         required = _required;
482         emit RequirementChange(_required);
483     }
484 
485     /// @dev Allows an owner to submit and confirm a withdraw transaction.
486     /// @param destination Withdraw destination address.
487     /// @param value Number of wei to withdraw.
488     /// @return Returns transaction ID.
489     function submitWithdrawTransaction(address destination, uint value)
490         public
491         ownerExists(msg.sender)
492         returns (uint transactionId)
493     {
494         transactionId = addTransaction(destination, value, 0);
495         confirmTransaction(transactionId);
496     }
497 
498     /// @dev Allows an owner to submit and confirm a withdraw token transaction.
499     /// @param tokenId token id.
500     /// @param destination Withdraw destination address.
501     /// @param value Number of token to withdraw.
502     /// @return Returns transaction ID.
503     function submitWithdrawTokenTransaction(uint tokenId, address destination, uint value)
504         public
505         ownerExists(msg.sender)
506         tokenIsSet(tokenId)
507         returns (uint transactionId)
508     {
509         transactionId = addTransaction(destination, value, tokenId+10);
510         confirmTransaction(transactionId);
511     }
512 
513     /// @dev Allows an owner to submit and confirm a withdraw token transaction.
514     /// @param owner new owner.
515     /// @return Returns transaction ID.
516     function submitAddOwnerTransaction(address owner)
517         public
518         ownerExists(msg.sender)
519         returns (uint transactionId)
520     {
521         transactionId = addTransaction(owner, 0, 1);
522         confirmTransaction(transactionId);
523     }
524 
525     /// @dev Allows an owner to submit and confirm a withdraw token transaction.
526     /// @param owner old owner.
527     /// @return Returns transaction ID.
528     function submitRemoveOwnerTransaction(address owner)
529         public
530         ownerExists(msg.sender)
531         returns (uint transactionId)
532     {
533         transactionId = addTransaction(owner, 0, 2);
534         confirmTransaction(transactionId);
535     }
536 
537     /// @dev Allows an owner to confirm a transaction.
538     /// @param transactionId Transaction ID.
539     function confirmTransaction(uint transactionId)
540         public
541         ownerExists(msg.sender)
542         transactionExists(transactionId)
543         notConfirmed(transactionId, msg.sender)
544     {
545         confirmations[transactionId][msg.sender] = true;
546         emit Confirmation(msg.sender, transactionId);
547         executeTransaction(transactionId);
548     }
549 
550     /// @dev Allows an owner to revoke a confirmation for a transaction.
551     /// @param transactionId Transaction ID.
552     function revokeConfirmation(uint transactionId)
553         public
554         ownerExists(msg.sender)
555         confirmed(transactionId, msg.sender)
556         notExecuted(transactionId)
557     {
558         confirmations[transactionId][msg.sender] = false;
559         emit Revocation(msg.sender, transactionId);
560     }
561 
562     /// @dev Allows anyone to execute a confirmed transaction.
563     /// @param transactionId Transaction ID.
564     function executeTransaction(uint transactionId)
565         public
566         ownerExists(msg.sender)
567         confirmed(transactionId, msg.sender)
568         notExecuted(transactionId)
569     {
570         if (isConfirmed(transactionId)) {
571             Transaction storage txn = transactions[transactionId];
572             txn.executed = true;
573             if (txn.txType == 0 && withdraw(txn.destination, txn.value))
574                 emit Execution(transactionId);
575             else if (txn.txType == 1 && addOwner(txn.destination))
576                 emit Execution(transactionId);
577             else if (txn.txType == 2 && removeOwner(txn.destination))
578                 emit Execution(transactionId);
579             else if (txn.txType > 3 && tokenWithdraw(txn.txType-10,txn.destination,txn.value))
580                 emit Execution(transactionId);
581             else {
582                 emit ExecutionFailure(transactionId);
583                 txn.executed = false;
584             }
585         }
586     }
587     
588     function tokenWithdraw(uint tokenId, address destination, uint value)
589         ownerExists(msg.sender)
590         tokenIsSet(tokenId)
591         private 
592         returns (bool) 
593     {
594         ERC20 _token = ERC20(tokens[tokenId]);
595         _token.safeTransfer(destination, value);
596         return true;
597     }
598 
599     /// @dev Function to send wei to address.
600     /// @param destination Address destination to send wei.
601     /// @param value Amount of wei to send.
602     /// @return Confirmation status.
603     function withdraw(address destination, uint value) 
604         ownerExists(msg.sender)
605         private 
606         returns (bool) 
607     {
608         destination.transfer(value);
609         return true;
610     }
611 
612     /// @dev Returns the confirmation status of a transaction.
613     /// @param transactionId Transaction ID.
614     /// @return Confirmation status.
615     function isConfirmed(uint transactionId)
616         public
617         constant
618         returns (bool)
619     {
620         uint count = 0;
621         for (uint i=0; i<owners.length; i++) {
622             if (confirmations[transactionId][owners[i]])
623                 count += 1;
624             if (count == required)
625                 return true;
626         }
627     }
628 
629     /*
630      * Internal functions
631      */
632     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
633     /// @param destination Transaction target address.
634     /// @param value Transaction wei value.
635     /// @return Returns transaction ID.
636     function addTransaction(address destination, uint value, uint txType)
637         internal
638         notNull(destination)
639         returns (uint transactionId)
640     {
641         transactionId = transactionCount;
642         transactions[transactionId] = Transaction({
643             destination: destination,
644             txType: txType,
645             value: value,
646             executed: false
647         });
648         transactionCount += 1;
649         emit Submission(transactionId);
650     }
651 
652     /*
653      * Web3 call functions
654      */
655     /// @dev Returns number of confirmations of a transaction.
656     /// @param transactionId Transaction ID.
657     /// @return Number of confirmations.
658     function getConfirmationCount(uint transactionId)
659         public
660         constant
661         returns (uint count)
662     {
663         for (uint i=0; i<owners.length; i++)
664             if (confirmations[transactionId][owners[i]])
665                 count += 1;
666     }
667 
668     /// @dev Returns total number of transactions after filers are applied.
669     /// @param pending Include pending transactions.
670     /// @param executed Include executed transactions.
671     /// @return Total number of transactions after filters are applied.
672     function getTransactionCount(bool pending, bool executed)
673         public
674         constant
675         returns (uint count)
676     {
677         for (uint i=0; i<transactionCount; i++)
678             if (   pending && !transactions[i].executed
679                 || executed && transactions[i].executed)
680                 count += 1;
681     }
682 
683     /// @dev Returns list of owners.
684     /// @return List of owner addresses.
685     function getOwners()
686         public
687         constant
688         returns (address[])
689     {
690         return owners;
691     }
692 
693     /// @dev Returns array with owner addresses, which confirmed transaction.
694     /// @param transactionId Transaction ID.
695     /// @return Returns array of owner addresses.
696     function getConfirmations(uint transactionId)
697         public
698         constant
699         returns (address[] _confirmations)
700     {
701         address[] memory confirmationsTemp = new address[](owners.length);
702         uint count = 0;
703         uint i;
704         for (i=0; i<owners.length; i++)
705             if (confirmations[transactionId][owners[i]]) {
706                 confirmationsTemp[count] = owners[i];
707                 count += 1;
708             }
709         _confirmations = new address[](count);
710         for (i=0; i<count; i++)
711             _confirmations[i] = confirmationsTemp[i];
712     }
713     
714 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9 	/**
10 	 * @dev Multiplies two numbers, reverts on overflow.
11 	 */
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14 		// benefit is lost if 'b' is also tested.
15 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16 		if (a == 0) {
17 			return 0;
18 		}
19 
20 		uint256 c = a * b;
21 		require(c / a == b);
22 
23 		return c;
24 	}
25 
26 	/**
27 	 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28 	 */
29 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
30 		require(b > 0); // Solidity only automatically asserts when dividing by 0
31 		uint256 c = a / b;
32 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34 		return c;
35 	}
36 
37 	/**
38 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39 	*/
40 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41 		require(b <= a);
42 		uint256 c = a - b;
43 
44 		return c;
45 	}
46 
47 	/**
48 	* @dev Adds two numbers, reverts on overflow.
49 	*/
50 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
51 		uint256 c = a + b;
52 		require(c >= a);
53 
54 		return c;
55 	}
56 
57 	/**
58 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59 	* reverts when dividing by zero.
60 		*/
61 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62 		require(b != 0);
63 		return a % b;
64 	}
65 }
66 
67 contract ERC20 {
68 	using SafeMath for uint256;
69 
70 	mapping (address => uint256) private _balances;
71 
72 	mapping (address => mapping (address => uint256)) private _allowed;
73 
74 	uint256 private _totalSupply;
75 	
76 	string private _name;
77     string private _symbol;
78     uint8 private _decimals;
79 
80 	event Transfer(
81 		address indexed from,
82 		address indexed to,
83 		uint256 value
84 	);
85 
86 	event Approval(
87 		address indexed owner,
88 		address indexed spender,
89 		uint256 value
90 	);
91 
92 	constructor (string memory name, string memory symbol, uint8 decimals) public {
93         _name = name;
94         _symbol = symbol;
95         _decimals = decimals;
96     }
97 
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() public view returns (string memory) {
102         return _name;
103     }
104 
105     /**
106      * @dev Returns the symbol of the token, usually a shorter version of the
107      * name.
108      */
109     function symbol() public view returns (string memory) {
110         return _symbol;
111     }
112 
113     /**
114      * @dev Returns the number of decimals used to get its user representation.
115      * For example, if `decimals` equals `2`, a balance of `505` tokens should
116      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
117      *
118      * Tokens usually opt for a value of 18, imitating the relationship between
119      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
120      * called.
121      *
122      * NOTE: This information is only used for _display_ purposes: it in
123      * no way affects any of the arithmetic of the contract, including
124      * {IERC20-balanceOf} and {IERC20-transfer}.
125      */
126     function decimals() public view returns (uint8) {
127         return _decimals;
128     }
129 
130 	/**
131 	* @dev Total number of tokens in existence
132 	*/
133 	function totalSupply() public view returns (uint256) {
134 		return _totalSupply;
135 	}
136 
137 	/**
138 	* @dev Gets the balance of the specified address.
139 	* @param owner The address to query the balance of.
140 	* @return An uint256 representing the amount owned by the passed address.
141 	 */
142 	function balanceOf(address owner) public view returns (uint256) {
143 		return _balances[owner];
144 	}
145 
146 	/**
147 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
148 	* @param owner address The address which owns the funds.
149 	* @param spender address The address which will spend the funds.
150 	* @return A uint256 specifying the amount of tokens still available for the spender.
151 	 */
152 	function allowance(
153 			address owner,
154 			address spender
155 			)
156 		public
157 		view
158 		returns (uint256)
159 		{
160 			return _allowed[owner][spender];
161 		}
162 
163 	/**
164 	* @dev Transfer token for a specified address
165 	* @param to The address to transfer to.
166 	* @param value The amount to be transferred.
167 	 */
168 	function transfer(address to, uint256 value) public returns (bool) {
169 		_transfer(msg.sender, to, value);
170 		return true;
171 	}
172 
173 	/**
174 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
176 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179 	* @param spender The address which will spend the funds.
180 	* @param value The amount of tokens to be spent.
181 	 */
182 	function approve(address spender, uint256 value) public returns (bool) {
183 		require(spender != address(0));
184 
185 	_allowed[msg.sender][spender] = value;
186 	emit Approval(msg.sender, spender, value);
187 	return true;
188 }
189 
190 /**
191 * @dev Transfer tokens from one address to another
192 * @param from address The address which you want to send tokens from
193 * @param to address The address which you want to transfer to
194 * @param value uint256 the amount of tokens to be transferred
195  */
196 function transferFrom(
197 		address from,
198 		address to,
199 		uint256 value
200 		)
201 	public
202 returns (bool)
203 {
204 	require(value <= _allowed[from][msg.sender]);
205 
206 _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
207 _transfer(from, to, value);
208 return true;
209   }
210 
211   /**
212   * @dev Increase the amount of tokens that an owner allowed to a spender.
213   * approve should be called when allowed_[_spender] == 0. To increment
214   * allowed value is better to use this function to avoid 2 calls (and wait until
215   * the first transaction is mined)
216   * From MonolithDAO Token.sol
217   * @param spender The address which will spend the funds.
218   * @param addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseAllowance(
221 	  address spender,
222 	  uint256 addedValue
223   )
224   public
225   returns (bool)
226   {
227 	  require(spender != address(0));
228 
229 	  _allowed[msg.sender][spender] = (
230 		  _allowed[msg.sender][spender].add(addedValue));
231 		  emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232 		  return true;
233   }
234 
235   /**
236   * @dev Decrease the amount of tokens that an owner allowed to a spender.
237   * approve should be called when allowed_[_spender] == 0. To decrement
238   * allowed value is better to use this function to avoid 2 calls (and wait until
239   * the first transaction is mined)
240   * From MonolithDAO Token.sol
241   * @param spender The address which will spend the funds.
242   * @param subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseAllowance(
245 	  address spender,
246 	  uint256 subtractedValue
247   )
248   public
249   returns (bool)
250   {
251 	  require(spender != address(0));
252 
253 	  _allowed[msg.sender][spender] = (
254 		  _allowed[msg.sender][spender].sub(subtractedValue));
255 		  emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
256 		  return true;
257   }
258 
259   /**
260    * @dev Transfer token for a specified addresses
261    * @param from The address to transfer from.
262    * @param to The address to transfer to.
263    * @param value The amount to be transferred.
264    */
265   function _transfer(address from, address to, uint256 value) internal {
266 	  require(value <= _balances[from]);
267 	  require(to != address(0));
268 
269 	  _balances[from] = _balances[from].sub(value);
270 	  _balances[to] = _balances[to].add(value);
271 	  emit Transfer(from, to, value);
272   }
273 
274   /**
275    * @dev Internal function that mints an amount of the token and assigns it to
276    * an account. This encapsulates the modification of balances such that the
277    * proper events are emitted.
278    * @param account The account that will receive the created tokens.
279    * @param value The amount that will be created.
280    */
281   function _mint(address account, uint256 value) internal {
282 	  require(account != address(0));
283 	  _totalSupply = _totalSupply.add(value);
284 	  _balances[account] = _balances[account].add(value);
285 	  emit Transfer(address(0), account, value);
286   }
287 
288   /**
289   * @dev Internal function that burns an amount of the token of a given
290   * account.
291   * @param account The account whose tokens will be burnt.
292   * @param value The amount that will be burnt.
293    */
294   function _burn(address account, uint256 value) internal {
295 	  require(account != address(0));
296 	  require(value <= _balances[account]);
297 
298 	  _totalSupply = _totalSupply.sub(value);
299 	  _balances[account] = _balances[account].sub(value);
300 	  emit Transfer(account, address(0), value);
301   }
302 
303   /**
304   * @dev Internal function that burns an amount of the token of a given
305   * account, deducting from the sender's allowance for said account. Uses the
306   * internal burn function.
307   * @param account The account whose tokens will be burnt.
308   * @param value The amount that will be burnt.
309    */
310   function _burnFrom(address account, uint256 value) internal {
311 	  require(value <= _allowed[account][msg.sender]);
312 
313 	  // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
314 	  // this function needs to emit an event with the updated approval.
315 	  _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
316 		  value);
317 		  _burn(account, value);
318   }
319 }
320 
321 
322 contract TomoE is ERC20 {
323     /*
324      *  Events
325      */
326     event Confirmation(address indexed sender, uint indexed transactionId);
327     event Revocation(address indexed sender, uint indexed transactionId);
328     event Submission(uint indexed transactionId);
329     event Execution(uint indexed transactionId);
330     event ExecutionFailure(uint indexed transactionId);
331     event OwnerAddition(address indexed owner);
332     event OwnerRemoval(address indexed owner);
333     event RequirementChange(uint required);
334     event TokenBurn(uint256 indexed burnID, address indexed burner, uint256 value, bytes data);
335 
336     /*
337      *  Constants
338      */
339     uint constant public MAX_OWNER_COUNT = 50;
340     uint public WITHDRAW_FEE = 0;
341     
342     /*
343      *  Storage
344      */
345     mapping (uint => Transaction) public transactions;
346     mapping (uint => mapping (address => bool)) public confirmations;
347     mapping (address => bool) public isOwner;
348     address[] public owners;
349     address public issuer;
350     uint public required;
351     uint public transactionCount;
352     TokenBurnData[] public burnList;
353 
354     struct TokenBurnData {
355         uint256 value;
356         address burner;
357         bytes data;
358     }
359     
360     struct Transaction {
361         address destination;
362         uint value;
363         bytes data; //data is used in transactions altering owner list
364         bool executed;
365     }
366 
367     /*
368      *  Modifiers
369      */
370     modifier onlyWallet() {
371         require(msg.sender == address(this));
372         _;
373     }
374 
375     modifier ownerDoesNotExist(address owner) {
376         require(!isOwner[owner]);
377         _;
378     }
379 
380     modifier ownerExists(address owner) {
381         require(isOwner[owner]);
382         _;
383     }
384 
385     modifier transactionExists(uint transactionId) {
386         require(transactions[transactionId].destination != 0);
387         _;
388     }
389 
390     modifier confirmed(uint transactionId, address owner) {
391         require(confirmations[transactionId][owner]);
392         _;
393     }
394 
395     modifier notConfirmed(uint transactionId, address owner) {
396         require(!confirmations[transactionId][owner]);
397         _;
398     }
399 
400     modifier notExecuted(uint transactionId) {
401         require(!transactions[transactionId].executed);
402         _;
403     }
404 
405     modifier notNull(address _address) {
406         require(_address != 0);
407         _;
408     }
409 
410     modifier validRequirement(uint ownerCount, uint _required) {
411         require(ownerCount <= MAX_OWNER_COUNT
412         && _required <= ownerCount
413         && _required != 0
414         && ownerCount != 0);
415         _;
416     }
417     
418     modifier onlyIssuer() {
419         require(msg.sender == issuer);
420         _;
421     }
422     
423     /*
424      * Public functions
425      */
426     /// @dev Contract constructor sets initial owners and required number of confirmations.
427     /// @param _owners List of initial owners.
428     /// @param _required Number of required confirmations.
429     constructor (address[] _owners,
430                  uint _required, string memory _name,
431                  string memory _symbol, uint8 _decimals,
432                  uint256 cap,
433                  uint256 withdrawFee
434                 ) ERC20(_name, _symbol, _decimals) public validRequirement(_owners.length, _required) {
435         _mint(msg.sender, cap);
436         issuer = msg.sender;
437         WITHDRAW_FEE = withdrawFee;
438         for (uint i=0; i<_owners.length; i++) {
439             require(!isOwner[_owners[i]] && _owners[i] != 0);
440             isOwner[_owners[i]] = true;
441         }
442         owners = _owners;
443         required = _required;
444     }
445 
446 
447     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
448     /// @param owner Address of new owner.
449     function addOwner(address owner) 
450     public
451     onlyWallet
452     ownerDoesNotExist(owner)
453     notNull(owner)
454     validRequirement(owners.length + 1, required)
455     {
456         isOwner[owner] = true;
457         owners.push(owner);
458         OwnerAddition(owner);
459     }
460 
461     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
462     /// @param owner Address of owner.
463     function removeOwner(address owner)
464     public
465     onlyWallet
466     ownerExists(owner)
467     {
468         isOwner[owner] = false;
469         for (uint i=0; i<owners.length - 1; i++)
470             if (owners[i] == owner) {
471                 owners[i] = owners[owners.length - 1];
472                 break;
473             }
474         owners.length -= 1;
475         if (required > owners.length)
476             changeRequirement(owners.length);
477         OwnerRemoval(owner);
478     }
479 
480     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
481     /// @param owner Address of owner to be replaced.
482     /// @param newOwner Address of new owner.
483     function replaceOwner(address owner, address newOwner)
484     public
485     onlyWallet
486     ownerExists(owner)
487     ownerDoesNotExist(newOwner)
488     {
489         for (uint i=0; i<owners.length; i++)
490             if (owners[i] == owner) {
491                 owners[i] = newOwner;
492                 break;
493             }
494         isOwner[owner] = false;
495         isOwner[newOwner] = true;
496         OwnerRemoval(owner);
497         OwnerAddition(newOwner);
498     }
499 
500     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
501     /// @param _required Number of required confirmations.
502     function changeRequirement(uint _required)
503     public
504     onlyWallet
505     validRequirement(owners.length, _required)
506     {
507         required = _required;
508         RequirementChange(_required);
509     }
510 
511     /// @dev Allows an owner to submit and confirm a transaction.
512     /// @param destination Transaction target address.
513     /// @param value Transaction ether value.
514     /// @param data Transaction data payload.
515     /// @return Returns transaction ID.
516     function submitTransaction(address destination, uint value, bytes data) 
517     public
518     returns (uint transactionId)
519     {
520         //transaction is considered as minting if no data provided, otherwise it's owner changing transaction
521         transactionId = addTransaction(destination, value, data);
522         confirmTransaction(transactionId);
523     }
524     
525 
526     /// @dev Allows an owner to confirm a transaction.
527     /// @param transactionId Transaction ID.
528     function confirmTransaction(uint transactionId)
529     public
530     ownerExists(msg.sender)
531     transactionExists(transactionId)
532     notConfirmed(transactionId, msg.sender)
533     {
534         confirmations[transactionId][msg.sender] = true;
535         Confirmation(msg.sender, transactionId);
536         executeTransaction(transactionId);
537     }
538 
539     /// @dev Allows an owner to revoke a confirmation for a transaction.
540     /// @param transactionId Transaction ID.
541     function revokeConfirmation(uint transactionId)
542     public
543     ownerExists(msg.sender)
544     confirmed(transactionId, msg.sender)
545     notExecuted(transactionId)
546     {
547         confirmations[transactionId][msg.sender] = false;
548         Revocation(msg.sender, transactionId);
549     }
550 
551     /// @dev Allows an user to burn the token.
552     function burn(uint value, bytes data)
553     public
554     {
555         require(value > WITHDRAW_FEE);
556         super._burn(msg.sender, value);
557         
558         if (WITHDRAW_FEE > 0) {
559             super._mint(issuer, WITHDRAW_FEE);
560         }
561         uint256 burnValue = value.sub(WITHDRAW_FEE);
562         burnList.push(TokenBurnData({
563             value: burnValue,
564             burner: msg.sender,
565             data: data 
566         }));
567         TokenBurn(burnList.length - 1, msg.sender, burnValue, data);
568 
569     }
570 
571     /// @dev Allows anyone to execute a confirmed transaction.
572     /// @param transactionId Transaction ID.
573     function executeTransaction(uint transactionId)
574     public
575     ownerExists(msg.sender)
576     confirmed(transactionId, msg.sender)
577     notExecuted(transactionId)
578     {
579         if (isConfirmed(transactionId)) {
580             Transaction storage txn = transactions[transactionId];
581             txn.executed = true;
582 
583             // just need multisig for minting - freely burn
584             if (txn.data.length == 0) {
585                 //execute minting transaction
586                 txn.value = txn.value;
587                 super._mint(txn.destination, txn.value);
588                 Execution(transactionId);
589             } else {
590                 //transaction that alters the owners list
591                 if (txn.destination.call.value(txn.value)(txn.data))
592                     Execution(transactionId);
593                 else {
594                     ExecutionFailure(transactionId);
595                     txn.executed = false;
596                 }
597             }
598         }
599     }
600 
601     /// @dev Returns the confirmation status of a transaction.
602     /// @param transactionId Transaction ID.
603     /// @return Confirmation status.
604     function isConfirmed(uint transactionId)
605     public
606     constant
607     returns (bool)
608     {
609         uint count = 0;
610         for (uint i=0; i<owners.length; i++) {
611             if (confirmations[transactionId][owners[i]])
612                 count += 1;
613             if (count == required)
614                 return true;
615         }
616     }
617 
618     /*
619      * Internal functions
620      */
621     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
622     /// @param destination Transaction target address.
623     /// @param value Transaction ether value.
624     /// @param data Transaction data payload.
625     /// @return Returns transaction ID.
626     function addTransaction(address destination, uint value, bytes data)
627     internal
628     notNull(destination)
629     returns (uint transactionId)
630     {
631         transactionId = transactionCount;
632         transactions[transactionId] = Transaction({
633             destination: destination,
634             value: value,
635             data: data,
636             executed: false
637         });
638         transactionCount += 1;
639         Submission(transactionId);
640     }
641 
642     /*
643      * Web3 call functions
644      */
645     /// @dev Returns number of confirmations of a transaction.
646     /// @param transactionId Transaction ID.
647     /// @return Number of confirmations.
648     function getConfirmationCount(uint transactionId)
649     public
650     constant
651     returns (uint count)
652     {
653         for (uint i=0; i<owners.length; i++)
654             if (confirmations[transactionId][owners[i]])
655                 count += 1;
656     }
657 
658     /// @dev Returns total number of transactions after filers are applied.
659     /// @param pending Include pending transactions.
660     /// @param executed Include executed transactions.
661     /// @return Total number of transactions after filters are applied.
662     function getTransactionCount(bool pending, bool executed)
663     public
664     constant
665     returns (uint count)
666     {
667         for (uint i=0; i<transactionCount; i++)
668             if (   pending && !transactions[i].executed
669             || executed && transactions[i].executed)
670                 count += 1;
671     }
672 
673     /// @dev Returns list of owners.
674     /// @return List of owner addresses.
675     function getOwners()
676     public
677     constant
678     returns (address[])
679     {
680         return owners;
681     }
682 
683     /// @dev Returns array with owner addresses, which confirmed transaction.
684     /// @param transactionId Transaction ID.
685     /// @return Returns array of owner addresses.
686     function getConfirmations(uint transactionId)
687     public
688     constant
689     returns (address[] _confirmations)
690     {
691         address[] memory confirmationsTemp = new address[](owners.length);
692         uint count = 0;
693         uint i;
694         for (i=0; i<owners.length; i++)
695             if (confirmations[transactionId][owners[i]]) {
696                 confirmationsTemp[count] = owners[i];
697                 count += 1;
698             }
699         _confirmations = new address[](count);
700         for (i=0; i<count; i++)
701             _confirmations[i] = confirmationsTemp[i];
702     }
703 
704     /// @dev Returns list of transaction IDs in defined range.
705     /// @param from Index start position of transaction array.
706     /// @param to Index end position of transaction array.
707     /// @param pending Include pending transactions.
708     /// @param executed Include executed transactions.
709     /// @return Returns array of transaction IDs.
710     function getTransactionIds(uint from, uint to, bool pending, bool executed)
711     public
712     constant
713     returns (uint[] _transactionIds)
714     {
715         uint end = to > transactionCount? transactionCount: to;
716         uint[] memory transactionIdsTemp = new uint[](end - from);
717         uint count = 0;
718         uint i;
719         for (i = from; i < to; i++) {
720             if ((pending && !transactions[i].executed)
721                 || (executed && transactions[i].executed))
722             {
723                 transactionIdsTemp[count] = i;
724                 count += 1;
725             }
726         }
727         _transactionIds = new uint[](count);
728         for (i = 0; i < count; i++)
729             _transactionIds[i] = transactionIdsTemp[i];
730     }
731     
732     function getBurnCount() public view returns (uint256) {
733         return burnList.length;
734     }
735 
736     function getBurn(uint burnId) public view returns (address _burner, uint256 _value, bytes _data) {
737         _burner = burnList[burnId].burner;
738         _value = burnList[burnId].value;
739         _data = burnList[burnId].data;
740     }
741     
742     /// @dev Allows to tramsfer contact issuer
743     function transferIssuer(address newIssuer) 
744     public
745     onlyIssuer
746     notNull(newIssuer)
747     {
748         issuer = newIssuer;
749     }
750 
751     function setWithdrawFee(uint256 withdrawFee) public onlyIssuer {
752         WITHDRAW_FEE = withdrawFee;
753     }
754 
755 }
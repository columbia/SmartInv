1 /*
2   Zethr | https://zethr.io
3   (c) Copyright 2018 | All Rights Reserved
4   This smart contract was developed by the Zethr Dev Team and its source code remains property of the Zethr Project.
5 */
6 
7 pragma solidity ^0.4.24;
8 
9 // File: contracts/ERC/ERC223Receiving.sol
10 
11 contract ERC223Receiving {
12   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
13 }
14 
15 // File: contracts/Libraries/SafeMath.sol
16 
17 library SafeMath {
18   function mul(uint a, uint b) internal pure returns (uint) {
19     if (a == 0) {
20       return 0;
21     }
22     uint c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint a, uint b) internal pure returns (uint) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint a, uint b) internal pure returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint a, uint b) internal pure returns (uint) {
40     uint c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 // File: contracts/ZethrMultiSigWallet.sol
47 
48 /* Zethr MultisigWallet
49  *
50  * Standard multisig wallet
51  * Holds the bankroll ETH, as well as the bankroll 33% ZTH tokens.
52 */ 
53 contract ZethrMultiSigWallet is ERC223Receiving {
54   using SafeMath for uint;
55 
56   /*=================================
57   =              EVENTS            =
58   =================================*/
59 
60   event Confirmation(address indexed sender, uint indexed transactionId);
61   event Revocation(address indexed sender, uint indexed transactionId);
62   event Submission(uint indexed transactionId);
63   event Execution(uint indexed transactionId);
64   event ExecutionFailure(uint indexed transactionId);
65   event Deposit(address indexed sender, uint value);
66   event OwnerAddition(address indexed owner);
67   event OwnerRemoval(address indexed owner);
68   event WhiteListAddition(address indexed contractAddress);
69   event WhiteListRemoval(address indexed contractAddress);
70   event RequirementChange(uint required);
71   event BankrollInvest(uint amountReceived);
72 
73   /*=================================
74   =             VARIABLES           =
75   =================================*/
76 
77   mapping (uint => Transaction) public transactions;
78   mapping (uint => mapping (address => bool)) public confirmations;
79   mapping (address => bool) public isOwner;
80   address[] public owners;
81   uint public required;
82   uint public transactionCount;
83   bool internal reEntered = false;
84   uint constant public MAX_OWNER_COUNT = 15;
85 
86   /*=================================
87   =         CUSTOM CONSTRUCTS       =
88   =================================*/
89 
90   struct Transaction {
91     address destination;
92     uint value;
93     bytes data;
94     bool executed;
95   }
96 
97   struct TKN {
98     address sender;
99     uint value;
100   }
101 
102   /*=================================
103   =            MODIFIERS            =
104   =================================*/
105 
106   modifier onlyWallet() {
107     if (msg.sender != address(this))
108       revert();
109     _;
110   }
111 
112   modifier isAnOwner() {
113     address caller = msg.sender;
114     if (isOwner[caller])
115       _;
116     else
117       revert();
118   }
119 
120   modifier ownerDoesNotExist(address owner) {
121     if (isOwner[owner]) 
122       revert();
123       _;
124   }
125 
126   modifier ownerExists(address owner) {
127     if (!isOwner[owner])
128       revert();
129     _;
130   }
131 
132   modifier transactionExists(uint transactionId) {
133     if (transactions[transactionId].destination == 0)
134       revert();
135     _;
136   }
137 
138   modifier confirmed(uint transactionId, address owner) {
139     if (!confirmations[transactionId][owner])
140       revert();
141     _;
142   }
143 
144   modifier notConfirmed(uint transactionId, address owner) {
145     if (confirmations[transactionId][owner])
146       revert();
147     _;
148   }
149 
150   modifier notExecuted(uint transactionId) {
151     if (transactions[transactionId].executed)
152       revert();
153     _;
154   }
155 
156   modifier notNull(address _address) {
157     if (_address == 0)
158       revert();
159     _;
160   }
161 
162   modifier validRequirement(uint ownerCount, uint _required) {
163     if ( ownerCount > MAX_OWNER_COUNT
164       || _required > ownerCount
165       || _required == 0
166       || ownerCount == 0)
167       revert();
168     _;
169   }
170 
171 
172   /*=================================
173   =         PUBLIC FUNCTIONS        =
174   =================================*/
175 
176   /// @dev Contract constructor sets initial owners and required number of confirmations.
177   /// @param _owners List of initial owners.
178   /// @param _required Number of required confirmations.
179   constructor (address[] _owners, uint _required)
180     public
181     validRequirement(_owners.length, _required)
182   {
183     // Add owners
184     for (uint i=0; i<_owners.length; i++) {
185       if (isOwner[_owners[i]] || _owners[i] == 0)
186         revert();
187       isOwner[_owners[i]] = true;
188     }
189 
190     // Set owners
191     owners = _owners;
192 
193     // Set required
194     required = _required;
195   }
196 
197   /** Testing only.
198   function exitAll()
199     public
200   {
201     uint tokenBalance = ZTHTKN.balanceOf(address(this));
202     ZTHTKN.sell(tokenBalance - 1e18);
203     ZTHTKN.sell(1e18);
204     ZTHTKN.withdraw(address(0x0));
205   }
206   **/
207 
208   /// @dev Fallback function allows Ether to be deposited.
209   function()
210     public
211     payable
212   {
213 
214   }
215     
216   /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
217   /// @param owner Address of new owner.
218   function addOwner(address owner)
219     public
220     onlyWallet
221     ownerDoesNotExist(owner)
222     notNull(owner)
223     validRequirement(owners.length + 1, required)
224   {
225     isOwner[owner] = true;
226     owners.push(owner);
227     emit OwnerAddition(owner);
228   }
229 
230   /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
231   /// @param owner Address of owner.
232   function removeOwner(address owner)
233     public
234     onlyWallet
235     ownerExists(owner)
236     validRequirement(owners.length, required)
237   {
238     isOwner[owner] = false;
239     for (uint i=0; i<owners.length - 1; i++)
240       if (owners[i] == owner) {
241         owners[i] = owners[owners.length - 1];
242         break;
243       }
244 
245     owners.length -= 1;
246     if (required > owners.length)
247       changeRequirement(owners.length);
248     emit OwnerRemoval(owner);
249   }
250 
251   /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
252   /// @param owner Address of owner to be replaced.
253   /// @param owner Address of new owner.
254   function replaceOwner(address owner, address newOwner)
255     public
256     onlyWallet
257     ownerExists(owner)
258     ownerDoesNotExist(newOwner)
259   {
260     for (uint i=0; i<owners.length; i++)
261       if (owners[i] == owner) {
262         owners[i] = newOwner;
263         break;
264       }
265 
266     isOwner[owner] = false;
267     isOwner[newOwner] = true;
268     emit OwnerRemoval(owner);
269     emit OwnerAddition(newOwner);
270   }
271 
272   /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
273   /// @param _required Number of required confirmations.
274   function changeRequirement(uint _required)
275     public
276     onlyWallet
277     validRequirement(owners.length, _required)
278   {
279     required = _required;
280     emit RequirementChange(_required);
281   }
282 
283   /// @dev Allows an owner to submit and confirm a transaction.
284   /// @param destination Transaction target address.
285   /// @param value Transaction ether value.
286   /// @param data Transaction data payload.
287   /// @return Returns transaction ID.
288   function submitTransaction(address destination, uint value, bytes data)
289     public
290     returns (uint transactionId)
291   {
292     transactionId = addTransaction(destination, value, data);
293     confirmTransaction(transactionId);
294   }
295 
296   /// @dev Allows an owner to confirm a transaction.
297   /// @param transactionId Transaction ID.
298   function confirmTransaction(uint transactionId)
299     public
300     ownerExists(msg.sender)
301     transactionExists(transactionId)
302     notConfirmed(transactionId, msg.sender)
303   {
304     confirmations[transactionId][msg.sender] = true;
305     emit Confirmation(msg.sender, transactionId);
306     executeTransaction(transactionId);
307   }
308 
309   /// @dev Allows an owner to revoke a confirmation for a transaction.
310   /// @param transactionId Transaction ID.
311   function revokeConfirmation(uint transactionId)
312     public
313     ownerExists(msg.sender)
314     confirmed(transactionId, msg.sender)
315     notExecuted(transactionId)
316   {
317     confirmations[transactionId][msg.sender] = false;
318     emit Revocation(msg.sender, transactionId);
319   }
320 
321   /// @dev Allows anyone to execute a confirmed transaction.
322   /// @param transactionId Transaction ID.
323   function executeTransaction(uint transactionId)
324     public
325     notExecuted(transactionId)
326   {
327     if (isConfirmed(transactionId)) {
328       Transaction storage txToExecute = transactions[transactionId];
329       txToExecute.executed = true;
330       if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
331         emit Execution(transactionId);
332       else {
333         emit ExecutionFailure(transactionId);
334         txToExecute.executed = false;
335       }
336     }
337   }
338 
339   /// @dev Returns the confirmation status of a transaction.
340   /// @param transactionId Transaction ID.
341   /// @return Confirmation status.
342   function isConfirmed(uint transactionId)
343     public
344     constant
345     returns (bool)
346   {
347     uint count = 0;
348     for (uint i=0; i<owners.length; i++) {
349       if (confirmations[transactionId][owners[i]])
350         count += 1;
351       if (count == required)
352         return true;
353     }
354   }
355 
356   /*=================================
357   =        OPERATOR FUNCTIONS       =
358   =================================*/
359 
360   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
361   /// @param destination Transaction target address.
362   /// @param value Transaction ether value.
363   /// @param data Transaction data payload.
364   /// @return Returns transaction ID.
365   function addTransaction(address destination, uint value, bytes data)
366     internal
367     notNull(destination)
368     returns (uint transactionId)
369   {
370     transactionId = transactionCount;
371 
372     transactions[transactionId] = Transaction({
373         destination: destination,
374         value: value,
375         data: data,
376         executed: false
377     });
378 
379     transactionCount += 1;
380     emit Submission(transactionId);
381   }
382 
383   /*
384    * Web3 call functions
385    */
386   /// @dev Returns number of confirmations of a transaction.
387   /// @param transactionId Transaction ID.
388   /// @return Number of confirmations.
389   function getConfirmationCount(uint transactionId)
390     public
391     constant
392     returns (uint count)
393   {
394     for (uint i=0; i<owners.length; i++)
395       if (confirmations[transactionId][owners[i]])
396         count += 1;
397   }
398 
399   /// @dev Returns total number of transactions after filers are applied.
400   /// @param pending Include pending transactions.
401   /// @param executed Include executed transactions.
402   /// @return Total number of transactions after filters are applied.
403   function getTransactionCount(bool pending, bool executed)
404     public
405     constant
406     returns (uint count)
407   {
408     for (uint i=0; i<transactionCount; i++)
409       if (pending && !transactions[i].executed || executed && transactions[i].executed)
410         count += 1;
411   }
412 
413   /// @dev Returns list of owners.
414   /// @return List of owner addresses.
415   function getOwners()
416     public
417     constant
418     returns (address[])
419   {
420     return owners;
421   }
422 
423   /// @dev Returns array with owner addresses, which confirmed transaction.
424   /// @param transactionId Transaction ID.
425   /// @return Returns array of owner addresses.
426   function getConfirmations(uint transactionId)
427     public
428     constant
429     returns (address[] _confirmations)
430   {
431     address[] memory confirmationsTemp = new address[](owners.length);
432     uint count = 0;
433     uint i;
434     for (i=0; i<owners.length; i++)
435       if (confirmations[transactionId][owners[i]]) {
436         confirmationsTemp[count] = owners[i];
437         count += 1;
438       }
439 
440       _confirmations = new address[](count);
441 
442       for (i=0; i<count; i++)
443         _confirmations[i] = confirmationsTemp[i];
444   }
445 
446   /// @dev Returns list of transaction IDs in defined range.
447   /// @param from Index start position of transaction array.
448   /// @param to Index end position of transaction array.
449   /// @param pending Include pending transactions.
450   /// @param executed Include executed transactions.
451   /// @return Returns array of transaction IDs.
452   function getTransactionIds(uint from, uint to, bool pending, bool executed)
453     public
454     constant
455     returns (uint[] _transactionIds)
456   {
457     uint[] memory transactionIdsTemp = new uint[](transactionCount);
458     uint count = 0;
459     uint i;
460 
461     for (i=0; i<transactionCount; i++)
462       if (pending && !transactions[i].executed || executed && transactions[i].executed) {
463         transactionIdsTemp[count] = i;
464         count += 1;
465       }
466 
467       _transactionIds = new uint[](to - from);
468 
469     for (i=from; i<to; i++)
470       _transactionIds[i - from] = transactionIdsTemp[i];
471   }
472 
473   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/)
474   public
475   returns (bool)
476   {
477     return true;
478   }
479 }
480 
481 // File: contracts/Bankroll/Interfaces/ZethrTokenBankrollInterface.sol
482 
483 // Zethr token bankroll function prototypes
484 contract ZethrTokenBankrollInterface is ERC223Receiving {
485   uint public jackpotBalance;
486   
487   function getMaxProfit(address) public view returns (uint);
488   function gameTokenResolution(uint _toWinnerAmount, address _winnerAddress, uint _toJackpotAmount, address _jackpotAddress, uint _originalBetSize) external;
489   function payJackpotToWinner(address _winnerAddress, uint payoutDivisor) public;
490 }
491 
492 // File: contracts/Bankroll/Interfaces/ZethrBankrollControllerInterface.sol
493 
494 contract ZethrBankrollControllerInterface is ERC223Receiving {
495   address public jackpotAddress;
496 
497   ZethrTokenBankrollInterface[7] public tokenBankrolls; 
498   
499   ZethrMultiSigWallet public multiSigWallet;
500 
501   mapping(address => bool) public validGameAddresses;
502 
503   function gamePayoutResolver(address _resolver, uint _tokenAmount) public;
504 
505   function isTokenBankroll(address _address) public view returns (bool);
506 
507   function getTokenBankrollAddressFromTier(uint8 _tier) public view returns (address);
508 
509   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
510 }
511 
512 // File: contracts/ERC/ERC721Interface.sol
513 
514 contract ERC721Interface {
515   function approve(address _to, uint _tokenId) public;
516   function balanceOf(address _owner) public view returns (uint balance);
517   function implementsERC721() public pure returns (bool);
518   function ownerOf(uint _tokenId) public view returns (address addr);
519   function takeOwnership(uint _tokenId) public;
520   function totalSupply() public view returns (uint total);
521   function transferFrom(address _from, address _to, uint _tokenId) public;
522   function transfer(address _to, uint _tokenId) public;
523 
524   event Transfer(address indexed from, address indexed to, uint tokenId);
525   event Approval(address indexed owner, address indexed approved, uint tokenId);
526 }
527 
528 // File: contracts/Libraries/AddressUtils.sol
529 
530 /**
531  * Utility library of inline functions on addresses
532  */
533 library AddressUtils {
534 
535   /**
536    * Returns whether the target address is a contract
537    * @dev This function will return false if invoked during the constructor of a contract,
538    *  as the code is not actually created until after the constructor finishes.
539    * @param addr address to check
540    * @return whether the target address is a contract
541    */
542   function isContract(address addr) internal view returns (bool) {
543     uint size;
544     // XXX Currently there is no better way to check if there is a contract in an address
545     // than to check the size of the code at that address.
546     // See https://ethereum.stackexchange.com/a/14016/36603
547     // for more details about how this works.
548     // TODO Check this again before the Serenity release, because all addresses will be
549     // contracts then.
550     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
551     return size > 0;
552   }
553 }
554 
555 // File: contracts/Games/ZethrDividendCards.sol
556 
557 contract ZethrDividendCards is ERC721Interface {
558     using SafeMath for uint;
559 
560   /*** EVENTS ***/
561 
562   /// @dev The Birth event is fired whenever a new dividend card comes into existence.
563   event Birth(uint tokenId, string name, address owner);
564 
565   /// @dev The TokenSold event is fired whenever a token (dividend card, in this case) is sold.
566   event TokenSold(uint tokenId, uint oldPrice, uint newPrice, address prevOwner, address winner, string name);
567 
568   /// @dev Transfer event as defined in current draft of ERC721.
569   ///  Ownership is assigned, including births.
570   event Transfer(address from, address to, uint tokenId);
571 
572   // Events for calculating card profits / errors
573   event BankrollDivCardProfit(uint bankrollProfit, uint percentIncrease, address oldOwner);
574   event BankrollProfitFailure(uint bankrollProfit, uint percentIncrease, address oldOwner);
575   event UserDivCardProfit(uint divCardProfit, uint percentIncrease, address oldOwner);
576   event DivCardProfitFailure(uint divCardProfit, uint percentIncrease, address oldOwner);
577   event masterCardProfit(uint toMaster, address _masterAddress, uint _divCardId);
578   event masterCardProfitFailure(uint toMaster, address _masterAddress, uint _divCardId);
579   event regularCardProfit(uint toRegular, address _regularAddress, uint _divCardId);
580   event regularCardProfitFailure(uint toRegular, address _regularAddress, uint _divCardId);
581 
582   /*** CONSTANTS ***/
583 
584   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
585   string public constant NAME           = "ZethrDividendCard";
586   string public constant SYMBOL         = "ZDC";
587   address public         BANKROLL;
588 
589   /*** STORAGE ***/
590 
591   /// @dev A mapping from dividend card indices to the address that owns them.
592   ///  All dividend cards have a valid owner address.
593 
594   mapping (uint => address) public      divCardIndexToOwner;
595 
596   // A mapping from a dividend rate to the card index.
597 
598   mapping (uint => uint) public         divCardRateToIndex;
599 
600   // @dev A mapping from owner address to the number of dividend cards that address owns.
601   //  Used internally inside balanceOf() to resolve ownership count.
602 
603   mapping (address => uint) private     ownershipDivCardCount;
604 
605   /// @dev A mapping from dividend card indices to an address that has been approved to call
606   ///  transferFrom(). Each dividend card can only have one approved address for transfer
607   ///  at any time. A zero value means no approval is outstanding.
608 
609   mapping (uint => address) public      divCardIndexToApproved;
610 
611   // @dev A mapping from dividend card indices to the price of the dividend card.
612 
613   mapping (uint => uint) private        divCardIndexToPrice;
614 
615   mapping (address => bool) internal    administrators;
616 
617   address public                        creator;
618   bool    public                        onSale;
619 
620   /*** DATATYPES ***/
621 
622   struct Card {
623     string name;
624     uint percentIncrease;
625   }
626 
627   Card[] private divCards;
628 
629   modifier onlyCreator() {
630     require(msg.sender == creator);
631     _;
632   }
633 
634   constructor (address _bankroll) public {
635     creator = msg.sender;
636     BANKROLL = _bankroll;
637 
638     createDivCard("2%", 1 ether, 2);
639     divCardRateToIndex[2] = 0;
640 
641     createDivCard("5%", 1 ether, 5);
642     divCardRateToIndex[5] = 1;
643 
644     createDivCard("10%", 1 ether, 10);
645     divCardRateToIndex[10] = 2;
646 
647     createDivCard("15%", 1 ether, 15);
648     divCardRateToIndex[15] = 3;
649 
650     createDivCard("20%", 1 ether, 20);
651     divCardRateToIndex[20] = 4;
652 
653     createDivCard("25%", 1 ether, 25);
654     divCardRateToIndex[25] = 5;
655 
656     createDivCard("33%", 1 ether, 33);
657     divCardRateToIndex[33] = 6;
658 
659     createDivCard("MASTER", 5 ether, 10);
660     divCardRateToIndex[999] = 7;
661 
662 	  onSale = true;
663 
664     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
665     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
666     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
667     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
668 
669     administrators[msg.sender] = true; // Helps with debugging
670   }
671 
672   /*** MODIFIERS ***/
673 
674   // Modifier to prevent contracts from interacting with the flip cards
675   modifier isNotContract()
676   {
677     require (msg.sender == tx.origin);
678     _;
679   }
680 
681 	// Modifier to prevent purchases before we open them up to everyone
682 	modifier hasStarted()
683   {
684 		require (onSale == true);
685 		_;
686 	}
687 
688 	modifier isAdmin()
689   {
690 	  require(administrators[msg.sender]);
691 	  _;
692   }
693 
694   /*** PUBLIC FUNCTIONS ***/
695   // Administrative update of the bankroll contract address
696   function setBankroll(address where)
697     public
698     isAdmin
699   {
700     BANKROLL = where;
701   }
702 
703   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
704   /// @param _to The address to be granted transfer approval. Pass address(0) to
705   ///  clear all approvals.
706   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
707   /// @dev Required for ERC-721 compliance.
708   function approve(address _to, uint _tokenId)
709     public
710     isNotContract
711   {
712     // Caller must own token.
713     require(_owns(msg.sender, _tokenId));
714 
715     divCardIndexToApproved[_tokenId] = _to;
716 
717     emit Approval(msg.sender, _to, _tokenId);
718   }
719 
720   /// For querying balance of a particular account
721   /// @param _owner The address for balance query
722   /// @dev Required for ERC-721 compliance.
723   function balanceOf(address _owner)
724     public
725     view
726     returns (uint balance)
727   {
728     return ownershipDivCardCount[_owner];
729   }
730 
731   // Creates a div card with bankroll as the owner
732   function createDivCard(string _name, uint _price, uint _percentIncrease)
733     public
734     onlyCreator
735   {
736     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
737   }
738 
739 	// Opens the dividend cards up for sale.
740 	function startCardSale()
741         public
742         isAdmin
743   {
744 		onSale = true;
745 	}
746 
747   /// @notice Returns all the relevant information about a specific div card
748   /// @param _divCardId The tokenId of the div card of interest.
749   function getDivCard(uint _divCardId)
750     public
751     view
752     returns (string divCardName, uint sellingPrice, address owner)
753   {
754     Card storage divCard = divCards[_divCardId];
755     divCardName = divCard.name;
756     sellingPrice = divCardIndexToPrice[_divCardId];
757     owner = divCardIndexToOwner[_divCardId];
758   }
759 
760   function implementsERC721()
761     public
762     pure
763     returns (bool)
764   {
765     return true;
766   }
767 
768   /// @dev Required for ERC-721 compliance.
769   function name()
770     public
771     pure
772     returns (string)
773   {
774     return NAME;
775   }
776 
777   /// For querying owner of token
778   /// @param _divCardId The tokenID for owner inquiry
779   /// @dev Required for ERC-721 compliance.
780   function ownerOf(uint _divCardId)
781     public
782     view
783     returns (address owner)
784   {
785     owner = divCardIndexToOwner[_divCardId];
786     require(owner != address(0));
787 	return owner;
788   }
789 
790   // Allows someone to send Ether and obtain a card
791   function purchase(uint _divCardId)
792     public
793     payable
794     hasStarted
795     isNotContract
796   {
797     address oldOwner  = divCardIndexToOwner[_divCardId];
798     address newOwner  = msg.sender;
799 
800     // Get the current price of the card
801     uint currentPrice = divCardIndexToPrice[_divCardId];
802 
803     // Making sure token owner is not sending to self
804     require(oldOwner != newOwner);
805 
806     // Safety check to prevent against an unexpected 0x0 default.
807     require(_addressNotNull(newOwner));
808 
809     // Making sure sent amount is greater than or equal to the sellingPrice
810     require(msg.value >= currentPrice);
811 
812     // To find the total profit, we need to know the previous price
813     // currentPrice      = previousPrice * (100 + percentIncrease);
814     // previousPrice     = currentPrice / (100 + percentIncrease);
815     uint percentIncrease = divCards[_divCardId].percentIncrease;
816     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
817 
818     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
819     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
820     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
821     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
822     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
823 
824     // Refund the sender the excess he sent
825     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
826 
827     // Raise the price by the percentage specified by the card
828     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
829 
830     // Transfer ownership
831     _transfer(oldOwner, newOwner, _divCardId);
832 
833     // Using send rather than transfer to prevent contract exploitability.
834     if(BANKROLL.send(bankrollProfit)) {
835       emit BankrollDivCardProfit(bankrollProfit, percentIncrease, oldOwner);
836     } else {
837       emit BankrollProfitFailure(bankrollProfit, percentIncrease, oldOwner);
838     }
839 
840     if(oldOwner.send(oldOwnerProfit)) {
841       emit UserDivCardProfit(oldOwnerProfit, percentIncrease, oldOwner);
842     } else {
843       emit DivCardProfitFailure(oldOwnerProfit, percentIncrease, oldOwner);
844     }
845 
846     msg.sender.transfer(purchaseExcess);
847   }
848 
849   function priceOf(uint _divCardId)
850     public
851     view
852     returns (uint price)
853   {
854     return divCardIndexToPrice[_divCardId];
855   }
856 
857   function setCreator(address _creator)
858     public
859     onlyCreator
860   {
861     require(_creator != address(0));
862 
863     creator = _creator;
864   }
865 
866   /// @dev Required for ERC-721 compliance.
867   function symbol()
868     public
869     pure
870     returns (string)
871   {
872     return SYMBOL;
873   }
874 
875   /// @notice Allow pre-approved user to take ownership of a dividend card.
876   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
877   /// @dev Required for ERC-721 compliance.
878   function takeOwnership(uint _divCardId)
879     public
880     isNotContract
881   {
882     address newOwner = msg.sender;
883     address oldOwner = divCardIndexToOwner[_divCardId];
884 
885     // Safety check to prevent against an unexpected 0x0 default.
886     require(_addressNotNull(newOwner));
887 
888     // Making sure transfer is approved
889     require(_approved(newOwner, _divCardId));
890 
891     _transfer(oldOwner, newOwner, _divCardId);
892   }
893 
894   /// For querying totalSupply of token
895   /// @dev Required for ERC-721 compliance.
896   function totalSupply()
897     public
898     view
899     returns (uint total)
900   {
901     return divCards.length;
902   }
903 
904   /// Owner initates the transfer of the card to another account
905   /// @param _to The address for the card to be transferred to.
906   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
907   /// @dev Required for ERC-721 compliance.
908   function transfer(address _to, uint _divCardId)
909     public
910     isNotContract
911   {
912     require(_owns(msg.sender, _divCardId));
913     require(_addressNotNull(_to));
914 
915     _transfer(msg.sender, _to, _divCardId);
916   }
917 
918   /// Third-party initiates transfer of a card from address _from to address _to
919   /// @param _from The address for the card to be transferred from.
920   /// @param _to The address for the card to be transferred to.
921   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
922   /// @dev Required for ERC-721 compliance.
923   function transferFrom(address _from, address _to, uint _divCardId)
924     public
925     isNotContract
926   {
927     require(_owns(_from, _divCardId));
928     require(_approved(_to, _divCardId));
929     require(_addressNotNull(_to));
930 
931     _transfer(_from, _to, _divCardId);
932   }
933 
934   function receiveDividends(uint _divCardRate)
935     public
936     payable
937   {
938     uint _divCardId = divCardRateToIndex[_divCardRate];
939     address _regularAddress = divCardIndexToOwner[_divCardId];
940     address _masterAddress = divCardIndexToOwner[7];
941 
942     uint toMaster = msg.value.div(2);
943     uint toRegular = msg.value.sub(toMaster);
944 
945     if(_masterAddress.send(toMaster)){
946       emit masterCardProfit(toMaster, _masterAddress, _divCardId);
947     } else {
948       emit masterCardProfitFailure(toMaster, _masterAddress, _divCardId);
949     }
950 
951     if(_regularAddress.send(toRegular)) {
952       emit regularCardProfit(toRegular, _regularAddress, _divCardId);
953     } else {
954       emit regularCardProfitFailure(toRegular, _regularAddress, _divCardId);
955     }
956   }
957 
958   /*** PRIVATE FUNCTIONS ***/
959   /// Safety check on _to address to prevent against an unexpected 0x0 default.
960   function _addressNotNull(address _to)
961     private
962     pure
963     returns (bool)
964   {
965     return _to != address(0);
966   }
967 
968   /// For checking approval of transfer for address _to
969   function _approved(address _to, uint _divCardId)
970     private
971     view
972     returns (bool)
973   {
974     return divCardIndexToApproved[_divCardId] == _to;
975   }
976 
977   /// For creating a dividend card
978   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
979     private
980   {
981     Card memory _divcard = Card({
982       name: _name,
983       percentIncrease: _percentIncrease
984     });
985     uint newCardId = divCards.push(_divcard) - 1;
986 
987     // It's probably never going to happen, 4 billion tokens are A LOT, but
988     // let's just be 100% sure we never let this happen.
989     require(newCardId == uint(uint32(newCardId)));
990 
991     emit Birth(newCardId, _name, _owner);
992 
993     divCardIndexToPrice[newCardId] = _price;
994 
995     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
996     _transfer(BANKROLL, _owner, newCardId);
997   }
998 
999   /// Check for token ownership
1000   function _owns(address claimant, uint _divCardId)
1001     private
1002     view
1003     returns (bool)
1004   {
1005     return claimant == divCardIndexToOwner[_divCardId];
1006   }
1007 
1008   /// @dev Assigns ownership of a specific Card to an address.
1009   function _transfer(address _from, address _to, uint _divCardId)
1010     private
1011   {
1012     // Since the number of cards is capped to 2^32 we can't overflow this
1013     ownershipDivCardCount[_to]++;
1014     //transfer ownership
1015     divCardIndexToOwner[_divCardId] = _to;
1016 
1017     // When creating new div cards _from is 0x0, but we can't account that address.
1018     if (_from != address(0)) {
1019       ownershipDivCardCount[_from]--;
1020       // clear any previously approved ownership exchange
1021       delete divCardIndexToApproved[_divCardId];
1022     }
1023 
1024     // Emit the transfer event.
1025     emit Transfer(_from, _to, _divCardId);
1026   }
1027 }
1028 
1029 // File: contracts/Zethr.sol
1030 
1031 contract Zethr {
1032   using SafeMath for uint;
1033 
1034   /*=================================
1035   =            MODIFIERS            =
1036   =================================*/
1037 
1038   modifier onlyHolders() {
1039     require(myFrontEndTokens() > 0);
1040     _;
1041   }
1042 
1043   modifier dividendHolder() {
1044     require(myDividends(true) > 0);
1045     _;
1046   }
1047 
1048   modifier onlyAdministrator(){
1049     address _customerAddress = msg.sender;
1050     require(administrators[_customerAddress]);
1051     _;
1052   }
1053 
1054   /*==============================
1055   =            EVENTS            =
1056   ==============================*/
1057 
1058   event onTokenPurchase(
1059     address indexed customerAddress,
1060     uint incomingEthereum,
1061     uint tokensMinted,
1062     address indexed referredBy
1063   );
1064 
1065   event UserDividendRate(
1066     address user,
1067     uint divRate
1068   );
1069 
1070   event onTokenSell(
1071     address indexed customerAddress,
1072     uint tokensBurned,
1073     uint ethereumEarned
1074   );
1075 
1076   event onReinvestment(
1077     address indexed customerAddress,
1078     uint ethereumReinvested,
1079     uint tokensMinted
1080   );
1081 
1082   event onWithdraw(
1083     address indexed customerAddress,
1084     uint ethereumWithdrawn
1085   );
1086 
1087   event Transfer(
1088     address indexed from,
1089     address indexed to,
1090     uint tokens
1091   );
1092 
1093   event Approval(
1094     address indexed tokenOwner,
1095     address indexed spender,
1096     uint tokens
1097   );
1098 
1099   event Allocation(
1100     uint toBankRoll,
1101     uint toReferrer,
1102     uint toTokenHolders,
1103     uint toDivCardHolders,
1104     uint forTokens
1105   );
1106 
1107   event Referral(
1108     address referrer,
1109     uint amountReceived
1110   );
1111 
1112   /*=====================================
1113   =            CONSTANTS                =
1114   =====================================*/
1115 
1116   uint8 constant public                decimals = 18;
1117 
1118   uint constant internal               tokenPriceInitial_ = 0.000653 ether;
1119   uint constant internal               magnitude = 2 ** 64;
1120 
1121   uint constant internal               icoHardCap = 250 ether;
1122   uint constant internal               addressICOLimit = 1   ether;
1123   uint constant internal               icoMinBuyIn = 0.1 finney;
1124   uint constant internal               icoMaxGasPrice = 50000000000 wei;
1125 
1126   uint constant internal               MULTIPLIER = 9615;
1127 
1128   uint constant internal               MIN_ETH_BUYIN = 0.0001 ether;
1129   uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
1130   uint constant internal               MIN_TOKEN_TRANSFER = 1e10;
1131   uint constant internal               referrer_percentage = 25;
1132 
1133   uint public                          stakingRequirement = 100e18;
1134 
1135   /*================================
1136    =          CONFIGURABLES         =
1137    ================================*/
1138 
1139   string public                        name = "Zethr";
1140   string public                        symbol = "ZTH";
1141 
1142   //bytes32 constant public              icoHashedPass      = bytes32(0x5ddcde33b94b19bdef79dd9ea75be591942b9ec78286d64b44a356280fb6a262); // public
1143   bytes32 constant public              icoHashedPass = bytes32(0x8a6ddee3fb2508ff4a5b02b48e9bc4566d0f3e11f306b0f75341bf235662a9e3); // test hunter2
1144 
1145   address internal                     bankrollAddress;
1146 
1147   ZethrDividendCards                   divCardContract;
1148 
1149   /*================================
1150    =            DATASETS            =
1151    ================================*/
1152 
1153   // Tracks front & backend tokens
1154   mapping(address => uint) internal    frontTokenBalanceLedger_;
1155   mapping(address => uint) internal    dividendTokenBalanceLedger_;
1156   mapping(address =>
1157   mapping(address => uint))
1158   public      allowed;
1159 
1160   // Tracks dividend rates for users
1161   mapping(uint8 => bool)    internal validDividendRates_;
1162   mapping(address => bool)    internal userSelectedRate;
1163   mapping(address => uint8)   internal userDividendRate;
1164 
1165   // Payout tracking
1166   mapping(address => uint)    internal referralBalance_;
1167   mapping(address => int256)  internal payoutsTo_;
1168 
1169   // ICO per-address limit tracking
1170   mapping(address => uint)    internal ICOBuyIn;
1171 
1172   uint public                          tokensMintedDuringICO;
1173   uint public                          ethInvestedDuringICO;
1174 
1175   uint public                          currentEthInvested;
1176 
1177   uint internal                        tokenSupply = 0;
1178   uint internal                        divTokenSupply = 0;
1179 
1180   uint internal                        profitPerDivToken;
1181 
1182   mapping(address => bool) public      administrators;
1183 
1184   bool public                          icoPhase = false;
1185   bool public                          regularPhase = false;
1186 
1187   uint                                 icoOpenTime;
1188 
1189   /*=======================================
1190   =            PUBLIC FUNCTIONS           =
1191   =======================================*/
1192   constructor (address _bankrollAddress, address _divCardAddress)
1193   public
1194   {
1195     bankrollAddress = _bankrollAddress;
1196     divCardContract = ZethrDividendCards(_divCardAddress);
1197 
1198     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true;
1199     // Norsefire
1200     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true;
1201     // klob
1202     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true;
1203     // Etherguy
1204     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true;
1205     // blurr
1206     administrators[0x8537aa2911b193e5B377938A723D805bb0865670] = true;
1207     // oguzhanox
1208     administrators[0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3] = true;
1209     // Randall
1210     administrators[0xDa83156106c4dba7A26E9bF2Ca91E273350aa551] = true;
1211     // TropicalRogue
1212     administrators[0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696] = true;
1213     // cryptodude
1214 
1215     administrators[msg.sender] = true;
1216     // Helps with debugging!
1217 
1218     validDividendRates_[2] = true;
1219     validDividendRates_[5] = true;
1220     validDividendRates_[10] = true;
1221     validDividendRates_[15] = true;
1222     validDividendRates_[20] = true;
1223     validDividendRates_[25] = true;
1224     validDividendRates_[33] = true;
1225 
1226     userSelectedRate[bankrollAddress] = true;
1227     userDividendRate[bankrollAddress] = 33;
1228 
1229   }
1230 
1231   /**
1232    * Same as buy, but explicitly sets your dividend percentage.
1233    * If this has been called before, it will update your `default' dividend
1234    *   percentage for regular buy transactions going forward.
1235    */
1236   function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string /*providedUnhashedPass*/)
1237   public
1238   payable
1239   returns (uint)
1240   {
1241     require(icoPhase || regularPhase);
1242 
1243     if (icoPhase) {
1244 
1245       // Anti-bot measures - not perfect, but should help some.
1246       // bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
1247       //require(hashedProvidedPass == icoHashedPass || msg.sender == bankrollAddress); // test; remove
1248 
1249       uint gasPrice = tx.gasprice;
1250 
1251       // Prevents ICO buyers from getting substantially burned if the ICO is reached
1252       //   before their transaction is processed.
1253       require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
1254 
1255     }
1256 
1257     // Dividend percentage should be a currently accepted value.
1258     require(validDividendRates_[_divChoice]);
1259 
1260     // Set the dividend fee percentage denominator.
1261     userSelectedRate[msg.sender] = true;
1262     userDividendRate[msg.sender] = _divChoice;
1263     emit UserDividendRate(msg.sender, _divChoice);
1264 
1265     // Finally, purchase tokens.
1266     purchaseTokens(msg.value, _referredBy);
1267   }
1268 
1269   // All buys except for the above one require regular phase.
1270 
1271   function buy(address _referredBy)
1272   public
1273   payable
1274   returns (uint)
1275   {
1276     require(regularPhase);
1277     address _customerAddress = msg.sender;
1278     require(userSelectedRate[_customerAddress]);
1279     purchaseTokens(msg.value, _referredBy);
1280   }
1281 
1282   function buyAndTransfer(address _referredBy, address target)
1283   public
1284   payable
1285   {
1286     bytes memory empty;
1287     buyAndTransfer(_referredBy, target, empty, 20);
1288   }
1289 
1290   function buyAndTransfer(address _referredBy, address target, bytes _data)
1291   public
1292   payable
1293   {
1294     buyAndTransfer(_referredBy, target, _data, 20);
1295   }
1296 
1297   // Overload
1298   function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
1299   public
1300   payable
1301   {
1302     require(regularPhase);
1303     address _customerAddress = msg.sender;
1304     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
1305     if (userSelectedRate[_customerAddress] && divChoice == 0) {
1306       purchaseTokens(msg.value, _referredBy);
1307     } else {
1308       buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
1309     }
1310     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
1311     transferTo(msg.sender, target, difference, _data);
1312   }
1313 
1314   // Fallback function only works during regular phase - part of anti-bot protection.
1315   function()
1316   payable
1317   public
1318   {
1319     /**
1320     / If the user has previously set a dividend rate, sending
1321     /   Ether directly to the contract simply purchases more at
1322     /   the most recent rate. If this is their first time, they
1323     /   are automatically placed into the 20% rate `bucket'.
1324     **/
1325     require(regularPhase);
1326     address _customerAddress = msg.sender;
1327     if (userSelectedRate[_customerAddress]) {
1328       purchaseTokens(msg.value, 0x0);
1329     } else {
1330       buyAndSetDivPercentage(0x0, 20, "0x0");
1331     }
1332   }
1333 
1334   function reinvest()
1335   dividendHolder()
1336   public
1337   {
1338     require(regularPhase);
1339     uint _dividends = myDividends(false);
1340 
1341     // Pay out requisite `virtual' dividends.
1342     address _customerAddress = msg.sender;
1343     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
1344 
1345     _dividends += referralBalance_[_customerAddress];
1346     referralBalance_[_customerAddress] = 0;
1347 
1348     uint _tokens = purchaseTokens(_dividends, 0x0);
1349 
1350     // Fire logging event.
1351     emit onReinvestment(_customerAddress, _dividends, _tokens);
1352   }
1353 
1354   function exit()
1355   public
1356   {
1357     require(regularPhase);
1358     // Retrieve token balance for caller, then sell them all.
1359     address _customerAddress = msg.sender;
1360     uint _tokens = frontTokenBalanceLedger_[_customerAddress];
1361 
1362     if (_tokens > 0) sell(_tokens);
1363 
1364     withdraw(_customerAddress);
1365   }
1366 
1367   function withdraw(address _recipient)
1368   dividendHolder()
1369   public
1370   {
1371     require(regularPhase);
1372     // Setup data
1373     address _customerAddress = msg.sender;
1374     uint _dividends = myDividends(false);
1375 
1376     // update dividend tracker
1377     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
1378 
1379     // add ref. bonus
1380     _dividends += referralBalance_[_customerAddress];
1381     referralBalance_[_customerAddress] = 0;
1382 
1383     if (_recipient == address(0x0)) {
1384       _recipient = msg.sender;
1385     }
1386     _recipient.transfer(_dividends);
1387 
1388     // Fire logging event.
1389     emit onWithdraw(_recipient, _dividends);
1390   }
1391 
1392   // Sells front-end tokens.
1393   // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
1394   function sell(uint _amountOfTokens)
1395   onlyHolders()
1396   public
1397   {
1398     // No selling during the ICO. You don't get to flip that fast, sorry!
1399     require(!icoPhase);
1400     require(regularPhase);
1401 
1402     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
1403 
1404     uint _frontEndTokensToBurn = _amountOfTokens;
1405 
1406     // Calculate how many dividend tokens this action burns.
1407     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
1408     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
1409     uint userDivRate = getUserAverageDividendRate(msg.sender);
1410     require((2 * magnitude) <= userDivRate && (50 * magnitude) >= userDivRate);
1411     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
1412 
1413     // Calculate ethereum received before dividends
1414     uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
1415 
1416     if (_ethereum > currentEthInvested) {
1417       // Well, congratulations, you've emptied the coffers.
1418       currentEthInvested = 0;
1419     } else {currentEthInvested = currentEthInvested - _ethereum;}
1420 
1421     // Calculate dividends generated from the sale.
1422     uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
1423 
1424     // Calculate Ethereum receivable net of dividends.
1425     uint _taxedEthereum = _ethereum.sub(_dividends);
1426 
1427     // Burn the sold tokens (both front-end and back-end variants).
1428     tokenSupply = tokenSupply.sub(_frontEndTokensToBurn);
1429     divTokenSupply = divTokenSupply.sub(_divTokensToBurn);
1430 
1431     // Subtract the token balances for the seller
1432     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
1433     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
1434 
1435     // Update dividends tracker
1436     int256 _updatedPayouts = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
1437     payoutsTo_[msg.sender] -= _updatedPayouts;
1438 
1439     // Let's avoid breaking arithmetic where we can, eh?
1440     if (divTokenSupply > 0) {
1441       // Update the value of each remaining back-end dividend token.
1442       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
1443     }
1444 
1445     // Fire logging event.
1446     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
1447   }
1448 
1449   /**
1450    * Transfer tokens from the caller to a new holder.
1451    * No charge incurred for the transfer. We'd make a terrible bank.
1452    */
1453   function transfer(address _toAddress, uint _amountOfTokens)
1454   onlyHolders()
1455   public
1456   returns (bool)
1457   {
1458     require(_amountOfTokens >= MIN_TOKEN_TRANSFER && _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
1459     bytes memory empty;
1460     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
1461     return true;
1462   }
1463 
1464   function approve(address spender, uint tokens)
1465   public
1466   returns (bool)
1467   {
1468     address _customerAddress = msg.sender;
1469     allowed[_customerAddress][spender] = tokens;
1470 
1471     // Fire logging event.
1472     emit Approval(_customerAddress, spender, tokens);
1473 
1474     // Good old ERC20.
1475     return true;
1476   }
1477 
1478   /**
1479    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
1480    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
1481    */
1482   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
1483   public
1484   returns (bool)
1485   {
1486     // Setup variables
1487     address _customerAddress = _from;
1488     bytes memory empty;
1489     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
1490     // and are transferring at least one full token.
1491     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1492     && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
1493     && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
1494 
1495     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
1496 
1497     // Good old ERC20.
1498     return true;
1499 
1500   }
1501 
1502   function transferTo(address _from, address _to, uint _amountOfTokens, bytes _data)
1503   public
1504   {
1505     if (_from != msg.sender) {
1506       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1507       && _amountOfTokens <= frontTokenBalanceLedger_[_from]
1508       && _amountOfTokens <= allowed[_from][msg.sender]);
1509     }
1510     else {
1511       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1512       && _amountOfTokens <= frontTokenBalanceLedger_[_from]);
1513     }
1514 
1515     transferFromInternal(_from, _to, _amountOfTokens, _data);
1516   }
1517 
1518   // Who'd have thought we'd need this thing floating around?
1519   function totalSupply()
1520   public
1521   view
1522   returns (uint256)
1523   {
1524     return tokenSupply;
1525   }
1526 
1527   // Anyone can start the regular phase 2 weeks after the ICO phase starts.
1528   // In case the devs die. Or something.
1529   function publicStartRegularPhase()
1530   public
1531   {
1532     require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
1533 
1534     icoPhase = false;
1535     regularPhase = true;
1536   }
1537 
1538   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1539 
1540 
1541   // Fire the starting gun and then duck for cover.
1542   function startICOPhase()
1543   onlyAdministrator()
1544   public
1545   {
1546     // Prevent us from startaring the ICO phase again
1547     require(icoOpenTime == 0);
1548     icoPhase = true;
1549     icoOpenTime = now;
1550   }
1551 
1552   // Fire the ... ending gun?
1553   function endICOPhase()
1554   onlyAdministrator()
1555   public
1556   {
1557     icoPhase = false;
1558   }
1559 
1560   function startRegularPhase()
1561   onlyAdministrator
1562   public
1563   {
1564     // disable ico phase in case if that was not disabled yet
1565     icoPhase = false;
1566     regularPhase = true;
1567   }
1568 
1569   // The death of a great man demands the birth of a great son.
1570   function setAdministrator(address _newAdmin, bool _status)
1571   onlyAdministrator()
1572   public
1573   {
1574     administrators[_newAdmin] = _status;
1575   }
1576 
1577   function setStakingRequirement(uint _amountOfTokens)
1578   onlyAdministrator()
1579   public
1580   {
1581     // This plane only goes one way, lads. Never below the initial.
1582     require(_amountOfTokens >= 100e18);
1583     stakingRequirement = _amountOfTokens;
1584   }
1585 
1586   function setName(string _name)
1587   onlyAdministrator()
1588   public
1589   {
1590     name = _name;
1591   }
1592 
1593   function setSymbol(string _symbol)
1594   onlyAdministrator()
1595   public
1596   {
1597     symbol = _symbol;
1598   }
1599 
1600   function changeBankroll(address _newBankrollAddress)
1601   onlyAdministrator
1602   public
1603   {
1604     bankrollAddress = _newBankrollAddress;
1605   }
1606 
1607   /*----------  HELPERS AND CALCULATORS  ----------*/
1608 
1609   function totalEthereumBalance()
1610   public
1611   view
1612   returns (uint)
1613   {
1614     return address(this).balance;
1615   }
1616 
1617   function totalEthereumICOReceived()
1618   public
1619   view
1620   returns (uint)
1621   {
1622     return ethInvestedDuringICO;
1623   }
1624 
1625   /**
1626    * Retrieves your currently selected dividend rate.
1627    */
1628   function getMyDividendRate()
1629   public
1630   view
1631   returns (uint8)
1632   {
1633     address _customerAddress = msg.sender;
1634     require(userSelectedRate[_customerAddress]);
1635     return userDividendRate[_customerAddress];
1636   }
1637 
1638   /**
1639    * Retrieve the total frontend token supply
1640    */
1641   function getFrontEndTokenSupply()
1642   public
1643   view
1644   returns (uint)
1645   {
1646     return tokenSupply;
1647   }
1648 
1649   /**
1650    * Retreive the total dividend token supply
1651    */
1652   function getDividendTokenSupply()
1653   public
1654   view
1655   returns (uint)
1656   {
1657     return divTokenSupply;
1658   }
1659 
1660   /**
1661    * Retrieve the frontend tokens owned by the caller
1662    */
1663   function myFrontEndTokens()
1664   public
1665   view
1666   returns (uint)
1667   {
1668     address _customerAddress = msg.sender;
1669     return getFrontEndTokenBalanceOf(_customerAddress);
1670   }
1671 
1672   /**
1673    * Retrieve the dividend tokens owned by the caller
1674    */
1675   function myDividendTokens()
1676   public
1677   view
1678   returns (uint)
1679   {
1680     address _customerAddress = msg.sender;
1681     return getDividendTokenBalanceOf(_customerAddress);
1682   }
1683 
1684   function myReferralDividends()
1685   public
1686   view
1687   returns (uint)
1688   {
1689     return myDividends(true) - myDividends(false);
1690   }
1691 
1692   function myDividends(bool _includeReferralBonus)
1693   public
1694   view
1695   returns (uint)
1696   {
1697     address _customerAddress = msg.sender;
1698     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
1699   }
1700 
1701   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
1702   public
1703   view
1704   returns (uint)
1705   {
1706     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
1707   }
1708 
1709   function getFrontEndTokenBalanceOf(address _customerAddress)
1710   view
1711   public
1712   returns (uint)
1713   {
1714     return frontTokenBalanceLedger_[_customerAddress];
1715   }
1716 
1717   function balanceOf(address _owner)
1718   view
1719   public
1720   returns (uint)
1721   {
1722     return getFrontEndTokenBalanceOf(_owner);
1723   }
1724 
1725   function getDividendTokenBalanceOf(address _customerAddress)
1726   view
1727   public
1728   returns (uint)
1729   {
1730     return dividendTokenBalanceLedger_[_customerAddress];
1731   }
1732 
1733   function dividendsOf(address _customerAddress)
1734   view
1735   public
1736   returns (uint)
1737   {
1738     return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
1739   }
1740 
1741   // Get the sell price at the user's average dividend rate
1742   function sellPrice()
1743   public
1744   view
1745   returns (uint)
1746   {
1747     uint price;
1748 
1749     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
1750       price = tokenPriceInitial_;
1751     } else {
1752 
1753       // Calculate the tokens received for 100 finney.
1754       // Divide to find the average, to calculate the price.
1755       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
1756 
1757       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
1758     }
1759 
1760     // Factor in the user's average dividend rate
1761     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
1762 
1763     return theSellPrice;
1764   }
1765 
1766   // Get the buy price at a particular dividend rate
1767   function buyPrice(uint dividendRate)
1768   public
1769   view
1770   returns (uint)
1771   {
1772     uint price;
1773 
1774     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
1775       price = tokenPriceInitial_;
1776     } else {
1777 
1778       // Calculate the tokens received for 100 finney.
1779       // Divide to find the average, to calculate the price.
1780       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
1781 
1782       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
1783     }
1784 
1785     // Factor in the user's selected dividend rate
1786     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
1787 
1788     return theBuyPrice;
1789   }
1790 
1791   function calculateTokensReceived(uint _ethereumToSpend)
1792   public
1793   view
1794   returns (uint)
1795   {
1796     uint _dividends = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
1797     uint _taxedEthereum = _ethereumToSpend.sub(_dividends);
1798     uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1799     return _amountOfTokens;
1800   }
1801 
1802   // When selling tokens, we need to calculate the user's current dividend rate.
1803   // This is different from their selected dividend rate.
1804   function calculateEthereumReceived(uint _tokensToSell)
1805   public
1806   view
1807   returns (uint)
1808   {
1809     require(_tokensToSell <= tokenSupply);
1810     uint _ethereum = tokensToEthereum_(_tokensToSell);
1811     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
1812     uint _dividends = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
1813     uint _taxedEthereum = _ethereum.sub(_dividends);
1814     return _taxedEthereum;
1815   }
1816 
1817   /*
1818    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
1819    * We multiply by magnitude to avoid precision errors.
1820    */
1821 
1822   function getUserAverageDividendRate(address user) public view returns (uint) {
1823     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
1824   }
1825 
1826   function getMyAverageDividendRate() public view returns (uint) {
1827     return getUserAverageDividendRate(msg.sender);
1828   }
1829 
1830   /*==========================================
1831   =            INTERNAL FUNCTIONS            =
1832   ==========================================*/
1833 
1834   /* Purchase tokens with Ether.
1835      During ICO phase, dividends should go to the bankroll
1836      During normal operation:
1837        0.5% should go to the master dividend card
1838        0.5% should go to the matching dividend card
1839        25% of dividends should go to the referrer, if any is provided. */
1840   function purchaseTokens(uint _incomingEthereum, address _referredBy)
1841   internal
1842   returns (uint)
1843   {
1844     require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
1845 
1846     uint toBankRoll;
1847     uint toReferrer;
1848     uint toTokenHolders;
1849     uint toDivCardHolders;
1850 
1851     uint dividendAmount;
1852 
1853     uint tokensBought;
1854     uint dividendTokensBought;
1855 
1856     uint remainingEth = _incomingEthereum;
1857 
1858     uint fee;
1859 
1860     // 1% for dividend card holders is taken off before anything else
1861     if (regularPhase) {
1862       toDivCardHolders = _incomingEthereum.div(100);
1863       remainingEth = remainingEth.sub(toDivCardHolders);
1864     }
1865 
1866     /* Next, we tax for dividends:
1867        Dividends = (ethereum * div%) / 100
1868        Important note: if we're out of the ICO phase, the 1% sent to div-card holders
1869                        is handled prior to any dividend taxes are considered. */
1870 
1871     // Grab the user's dividend rate
1872     uint dividendRate = userDividendRate[msg.sender];
1873 
1874     // Calculate the total dividends on this buy
1875     dividendAmount = (remainingEth.mul(dividendRate)).div(100);
1876 
1877     remainingEth = remainingEth.sub(dividendAmount);
1878 
1879     // If we're in the ICO and bankroll is buying, don't tax
1880     if (icoPhase && msg.sender == bankrollAddress) {
1881       remainingEth = remainingEth + dividendAmount;
1882     }
1883 
1884     // Calculate how many tokens to buy:
1885     tokensBought = ethereumToTokens_(remainingEth);
1886     dividendTokensBought = tokensBought.mul(dividendRate);
1887 
1888     // This is where we actually mint tokens:
1889     tokenSupply = tokenSupply.add(tokensBought);
1890     divTokenSupply = divTokenSupply.add(dividendTokensBought);
1891 
1892     /* Update the total investment tracker
1893        Note that this must be done AFTER we calculate how many tokens are bought -
1894        because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
1895 
1896     currentEthInvested = currentEthInvested + remainingEth;
1897 
1898     // If ICO phase, all the dividends go to the bankroll
1899     if (icoPhase) {
1900       toBankRoll = dividendAmount;
1901 
1902       // If the bankroll is buying, we don't want to send eth back to the bankroll
1903       // Instead, let's just give it the tokens it would get in an infinite recursive buy
1904       if (msg.sender == bankrollAddress) {
1905         toBankRoll = 0;
1906       }
1907 
1908       toReferrer = 0;
1909       toTokenHolders = 0;
1910 
1911       /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
1912          not how much Ether we get total.
1913          this is so that our calculation using "investment" is accurate. */
1914       ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
1915       tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
1916 
1917       // Cannot purchase more than the hard cap during ICO.
1918       require(ethInvestedDuringICO <= icoHardCap);
1919       // Contracts aren't allowed to participate in the ICO.
1920       require(tx.origin == msg.sender || msg.sender == bankrollAddress);
1921 
1922       // Cannot purchase more then the limit per address during the ICO.
1923       ICOBuyIn[msg.sender] += remainingEth;
1924       //require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress); // test:remove
1925 
1926       // Stop the ICO phase if we reach the hard cap
1927       if (ethInvestedDuringICO == icoHardCap) {
1928         icoPhase = false;
1929       }
1930 
1931     } else {
1932       // Not ICO phase, check for referrals
1933 
1934       // 25% goes to referrers, if set
1935       // toReferrer = (dividends * 25)/100
1936       if (_referredBy != 0x0000000000000000000000000000000000000000 &&
1937       _referredBy != msg.sender &&
1938       frontTokenBalanceLedger_[_referredBy] >= stakingRequirement)
1939       {
1940         toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
1941         referralBalance_[_referredBy] += toReferrer;
1942         emit Referral(_referredBy, toReferrer);
1943       }
1944 
1945       // The rest of the dividends go to token holders
1946       toTokenHolders = dividendAmount.sub(toReferrer);
1947 
1948       fee = toTokenHolders * magnitude;
1949       fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
1950 
1951       // Finally, increase the divToken value
1952       profitPerDivToken = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
1953       payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
1954     }
1955 
1956     // Update the buyer's token amounts
1957     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
1958     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
1959 
1960     // Transfer to bankroll and div cards
1961     if (toBankRoll != 0) {ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)();}
1962     if (regularPhase) {divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate);}
1963 
1964     // This event should help us track where all the eth is going
1965     emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
1966 
1967     // Sanity checking
1968     uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth - _incomingEthereum;
1969     assert(sum == 0);
1970   }
1971 
1972   // How many tokens one gets from a certain amount of ethereum.
1973   function ethereumToTokens_(uint _ethereumAmount)
1974   public
1975   view
1976   returns (uint)
1977   {
1978     require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
1979 
1980     if (icoPhase) {
1981       return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
1982     }
1983 
1984     /*
1985      *  i = investment, p = price, t = number of tokens
1986      *
1987      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1988      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1989      *
1990      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1991      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1992      */
1993 
1994     // First, separate out the buy into two segments:
1995     //  1) the amount of eth going towards ico-price tokens
1996     //  2) the amount of eth going towards pyramid-price (variable) tokens
1997     uint ethTowardsICOPriceTokens = 0;
1998     uint ethTowardsVariablePriceTokens = 0;
1999 
2000     if (currentEthInvested >= ethInvestedDuringICO) {
2001       // Option One: All the ETH goes towards variable-price tokens
2002       ethTowardsVariablePriceTokens = _ethereumAmount;
2003 
2004     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
2005       // Option Two: All the ETH goes towards ICO-price tokens
2006       ethTowardsICOPriceTokens = _ethereumAmount;
2007 
2008     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
2009       // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
2010       ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
2011       ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
2012     } else {
2013       // Option Four: Should be impossible, and compiler should optimize it out of existence.
2014       revert();
2015     }
2016 
2017     // Sanity check:
2018     assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
2019 
2020     // Separate out the number of tokens of each type this will buy:
2021     uint icoPriceTokens = 0;
2022     uint varPriceTokens = 0;
2023 
2024     // Now calculate each one per the above formulas.
2025     // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
2026     if (ethTowardsICOPriceTokens != 0) {
2027       icoPriceTokens = ethTowardsICOPriceTokens.mul(1e18).div(tokenPriceInitial_);
2028     }
2029 
2030     if (ethTowardsVariablePriceTokens != 0) {
2031       // Note: we can't use "currentEthInvested" for this calculation, we must use:
2032       //  currentEthInvested + ethTowardsICOPriceTokens
2033       // This is because a split-buy essentially needs to simulate two separate buys -
2034       // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
2035 
2036       uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
2037       uint simulatedEthAfterInvested = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
2038 
2039       /* We have the equations for total tokens above; note that this is for TOTAL.
2040          To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
2041          and the simulatedEthInvestedAfter and calculate the difference in tokens.
2042          This is how many we get. */
2043 
2044       uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
2045       uint tokensAfter = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
2046 
2047       /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
2048          either should work.
2049 
2050          Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
2051          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
2052 
2053       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
2054     }
2055 
2056     uint totalTokensReceived = icoPriceTokens + varPriceTokens;
2057 
2058     assert(totalTokensReceived > 0);
2059     return totalTokensReceived;
2060   }
2061 
2062   // How much Ether we get from selling N tokens
2063   function tokensToEthereum_(uint _tokens)
2064   public
2065   view
2066   returns (uint)
2067   {
2068     require(_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
2069 
2070     /*
2071      *  i = investment, p = price, t = number of tokens
2072      *
2073      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
2074      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
2075      *
2076      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
2077      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
2078      */
2079 
2080     // First, separate out the sell into two segments:
2081     //  1) the amount of tokens selling at the ICO price.
2082     //  2) the amount of tokens selling at the variable (pyramid) price
2083     uint tokensToSellAtICOPrice = 0;
2084     uint tokensToSellAtVariablePrice = 0;
2085 
2086     if (tokenSupply <= tokensMintedDuringICO) {
2087       // Option One: All the tokens sell at the ICO price.
2088       tokensToSellAtICOPrice = _tokens;
2089 
2090     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
2091       // Option Two: All the tokens sell at the variable price.
2092       tokensToSellAtVariablePrice = _tokens;
2093 
2094     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
2095       // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
2096       tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
2097       tokensToSellAtICOPrice = _tokens.sub(tokensToSellAtVariablePrice);
2098 
2099     } else {
2100       // Option Four: Should be impossible, and the compiler should optimize it out of existence.
2101       revert();
2102     }
2103 
2104     // Sanity check:
2105     assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
2106 
2107     // Track how much Ether we get from selling at each price function:
2108     uint ethFromICOPriceTokens;
2109     uint ethFromVarPriceTokens;
2110 
2111     // Now, actually calculate:
2112 
2113     if (tokensToSellAtICOPrice != 0) {
2114 
2115       /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
2116          we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
2117          We need to divide by 1e18 or we'll have too much Ether. */
2118 
2119       ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
2120     }
2121 
2122     if (tokensToSellAtVariablePrice != 0) {
2123 
2124       /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
2125          This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
2126          Thus there isn't any weird stuff going on with the token supply.
2127 
2128          We have the equations for total investment above; note that this is for TOTAL.
2129          To get the eth received from this sell, we calculate the new total investment after this sell.
2130          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
2131 
2132       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
2133       uint investmentAfter = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
2134 
2135       ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
2136     }
2137 
2138     uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
2139 
2140     assert(totalEthReceived > 0);
2141     return totalEthReceived;
2142   }
2143 
2144   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
2145   internal
2146   {
2147     require(regularPhase);
2148     require(_toAddress != address(0x0));
2149     address _customerAddress = _from;
2150     uint _amountOfFrontEndTokens = _amountOfTokens;
2151 
2152     // Withdraw all outstanding dividends first (including those generated from referrals).
2153     if (theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
2154 
2155     // Calculate how many back-end dividend tokens to transfer.
2156     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
2157     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
2158 
2159     if (_customerAddress != msg.sender) {
2160       // Update the allowed balance.
2161       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
2162       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
2163     }
2164 
2165     // Exchange tokens
2166     frontTokenBalanceLedger_[_customerAddress] = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
2167     frontTokenBalanceLedger_[_toAddress] = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
2168     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
2169     dividendTokenBalanceLedger_[_toAddress] = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
2170 
2171     // Recipient inherits dividend percentage if they have not already selected one.
2172     if (!userSelectedRate[_toAddress])
2173     {
2174       userSelectedRate[_toAddress] = true;
2175       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
2176     }
2177 
2178     // Update dividend trackers
2179     payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
2180     payoutsTo_[_toAddress] += (int256) (profitPerDivToken * _amountOfDivTokens);
2181 
2182     uint length;
2183 
2184     assembly {
2185       length := extcodesize(_toAddress)
2186     }
2187 
2188     if (length > 0) {
2189       // its a contract
2190       // note: at ethereum update ALL addresses are contracts
2191       ERC223Receiving receiver = ERC223Receiving(_toAddress);
2192       receiver.tokenFallback(_from, _amountOfTokens, _data);
2193     }
2194 
2195     // Fire logging event.
2196     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
2197   }
2198 
2199   // Called from transferFrom. Always checks if _customerAddress has dividends.
2200   function withdrawFrom(address _customerAddress)
2201   internal
2202   {
2203     // Setup data
2204     uint _dividends = theDividendsOf(false, _customerAddress);
2205 
2206     // update dividend tracker
2207     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
2208 
2209     // add ref. bonus
2210     _dividends += referralBalance_[_customerAddress];
2211     referralBalance_[_customerAddress] = 0;
2212 
2213     _customerAddress.transfer(_dividends);
2214 
2215     // Fire logging event.
2216     emit onWithdraw(_customerAddress, _dividends);
2217   }
2218 
2219 
2220   /*=======================
2221    =    RESET FUNCTIONS   =
2222    ======================*/
2223 
2224   function injectEther()
2225   public
2226   payable
2227   onlyAdministrator
2228   {
2229 
2230   }
2231 
2232   /*=======================
2233    =   MATHS FUNCTIONS    =
2234    ======================*/
2235 
2236   function toPowerOfThreeHalves(uint x) public pure returns (uint) {
2237     // m = 3, n = 2
2238     // sqrt(x^3)
2239     return sqrt(x ** 3);
2240   }
2241 
2242   function toPowerOfTwoThirds(uint x) public pure returns (uint) {
2243     // m = 2, n = 3
2244     // cbrt(x^2)
2245     return cbrt(x ** 2);
2246   }
2247 
2248   function sqrt(uint x) public pure returns (uint y) {
2249     uint z = (x + 1) / 2;
2250     y = x;
2251     while (z < y) {
2252       y = z;
2253       z = (x / z + z) / 2;
2254     }
2255   }
2256 
2257   function cbrt(uint x) public pure returns (uint y) {
2258     uint z = (x + 1) / 3;
2259     y = x;
2260     while (z < y) {
2261       y = z;
2262       z = (x / (z * z) + 2 * z) / 3;
2263     }
2264   }
2265 }
2266 
2267 /*=======================
2268  =     INTERFACES       =
2269  ======================*/
2270 
2271 contract ZethrBankroll {
2272   function receiveDividends() public payable {}
2273 }
2274 
2275 // File: contracts/Games/JackpotHolding.sol
2276 
2277 /*
2278 *
2279 * Jackpot holding contract.
2280 *  
2281 * This accepts token payouts from a game for every player loss,
2282 * and on a win, pays out *half* of the jackpot to the winner.
2283 *
2284 * Jackpot payout should only be called from the game.
2285 *
2286 */
2287 contract JackpotHolding is ERC223Receiving {
2288 
2289   /****************************
2290    * FIELDS
2291    ****************************/
2292 
2293   // How many times we've paid out the jackpot
2294   uint public payOutNumber = 0;
2295 
2296   // The amount to divide the token balance by for a pay out (defaults to half the token balance)
2297   uint public payOutDivisor = 2;
2298 
2299   // Holds the bankroll controller info
2300   ZethrBankrollControllerInterface controller;
2301 
2302   // Zethr contract
2303   Zethr zethr;
2304 
2305   /****************************
2306    * CONSTRUCTOR
2307    ****************************/
2308 
2309   constructor (address _controllerAddress, address _zethrAddress) public {
2310     controller = ZethrBankrollControllerInterface(_controllerAddress);
2311     zethr = Zethr(_zethrAddress);
2312   }
2313 
2314   function() public payable {}
2315 
2316   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes/*_data*/)
2317   public
2318   returns (bool)
2319   {
2320     // Do nothing, we can track the jackpot by this balance
2321   }
2322 
2323   /****************************
2324    * VIEWS
2325    ****************************/
2326   function getJackpotBalance()
2327   public view
2328   returns (uint)
2329   {
2330     // Half of this balance + half of jackpotBalance in each token bankroll
2331     uint tempBalance;
2332 
2333     for (uint i=0; i<7; i++) {
2334       tempBalance += controller.tokenBankrolls(i).jackpotBalance() > 0 ? controller.tokenBankrolls(i).jackpotBalance() / payOutDivisor : 0;
2335     }
2336 
2337     tempBalance += zethr.balanceOf(address(this)) > 0 ? zethr.balanceOf(address(this)) / payOutDivisor : 0;
2338 
2339     return tempBalance;
2340   }
2341 
2342   /****************************
2343    * OWNER FUNCTIONS
2344    ****************************/
2345 
2346   /** @dev Sets the pay out divisor
2347     * @param _divisor The value to set the new divisor to
2348     */
2349   function ownerSetPayOutDivisor(uint _divisor)
2350   public
2351   ownerOnly
2352   {
2353     require(_divisor != 0);
2354 
2355     payOutDivisor = _divisor;
2356   }
2357 
2358   /** @dev Sets the address of the game controller
2359     * @param _controllerAddress The new address of the controller
2360     */
2361   function ownerSetControllerAddress(address _controllerAddress)
2362   public
2363   ownerOnly
2364   {
2365     controller = ZethrBankrollControllerInterface(_controllerAddress);
2366   }
2367 
2368   /** @dev Transfers the jackpot to _to
2369     * @param _to Address to send the jackpot tokens to
2370     */
2371   function ownerWithdrawZth(address _to)
2372   public
2373   ownerOnly
2374   {
2375     uint balance = zethr.balanceOf(address(this));
2376     zethr.transfer(_to, balance);
2377   }
2378 
2379   /** @dev Transfers any ETH received from dividends to _to
2380     * @param _to Address to send the ETH to
2381     */
2382   function ownerWithdrawEth(address _to)
2383   public
2384   ownerOnly
2385   {
2386     _to.transfer(address(this).balance);
2387   }
2388 
2389   /****************************
2390    * GAME FUNCTIONS
2391    ****************************/
2392 
2393   function gamePayOutWinner(address _winner)
2394   public
2395   gameOnly
2396   {
2397     // Call the payout function on all 7 token bankrolls
2398     for (uint i=0; i<7; i++) {
2399       controller.tokenBankrolls(i).payJackpotToWinner(_winner, payOutDivisor);
2400     }
2401 
2402     uint payOutAmount;
2403 
2404     // Calculate pay out & pay out
2405     if (zethr.balanceOf(address(this)) >= 1e10) {
2406       payOutAmount = zethr.balanceOf(address(this)) / payOutDivisor;
2407     }
2408 
2409     if (payOutAmount >= 1e10) {
2410       zethr.transfer(_winner, payOutAmount);
2411     }
2412 
2413     // Increment the statistics fields
2414     payOutNumber += 1;
2415 
2416     // Emit jackpot event
2417     emit JackpotPayOut(_winner, payOutNumber);
2418   }
2419 
2420   /****************************
2421    * EVENTS
2422    ****************************/
2423 
2424   event JackpotPayOut(
2425     address winner,
2426     uint payOutNumber
2427   );
2428 
2429   /****************************
2430    * MODIFIERS
2431    ****************************/
2432 
2433   // Only an owner can call this method (controller is always an owner)
2434   modifier ownerOnly()
2435   {
2436     require(msg.sender == address(controller) || controller.multiSigWallet().isOwner(msg.sender));
2437     _;
2438   }
2439 
2440   // Only a game can call this method
2441   modifier gameOnly()
2442   {
2443     require(controller.validGameAddresses(msg.sender));
2444     _;
2445   }
2446 }
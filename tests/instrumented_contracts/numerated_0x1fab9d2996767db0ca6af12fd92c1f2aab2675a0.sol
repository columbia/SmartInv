1 /*
2   Zethr | https://zethr.io
3   (c) Copyright 2018 | All Rights Reserved
4   This smart contract was developed by the Zethr Dev Team and its source code remains property of the Zethr Project.
5 */
6 
7 pragma solidity ^0.4.24;
8 
9 // File: contracts/Libraries/SafeMath.sol
10 
11 library SafeMath {
12   function mul(uint a, uint b) internal pure returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal pure returns (uint) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal pure returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 // File: contracts/Libraries/ZethrTierLibrary.sol
41 
42 library ZethrTierLibrary {
43   uint constant internal magnitude = 2 ** 64;
44 
45   // Gets the tier (1-7) of the divs sent based off of average dividend rate
46   // This is an index used to call into the correct sub-bankroll to withdraw tokens
47   function getTier(uint divRate) internal pure returns (uint8) {
48 
49     // Divide the average dividned rate by magnitude
50     // Remainder doesn't matter because of the below logic
51     uint actualDiv = divRate / magnitude;
52     if (actualDiv >= 30) {
53       return 6;
54     } else if (actualDiv >= 25) {
55       return 5;
56     } else if (actualDiv >= 20) {
57       return 4;
58     } else if (actualDiv >= 15) {
59       return 3;
60     } else if (actualDiv >= 10) {
61       return 2;
62     } else if (actualDiv >= 5) {
63       return 1;
64     } else if (actualDiv >= 2) {
65       return 0;
66     } else {
67       // Impossible
68       revert();
69     }
70   }
71 
72   function getDivRate(uint _tier)
73   internal pure
74   returns (uint8)
75   {
76     if (_tier == 0) {
77       return 2;
78     } else if (_tier == 1) {
79       return 5;
80     } else if (_tier == 2) {
81       return 10;
82     } else if (_tier == 3) {
83       return 15;
84     } else if (_tier == 4) {
85       return 20;
86     } else if (_tier == 5) {
87       return 25;
88     } else if (_tier == 6) {
89       return 33;
90     } else {
91       revert();
92     }
93   }
94 }
95 
96 // File: contracts/ERC/ERC223Receiving.sol
97 
98 contract ERC223Receiving {
99   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
100 }
101 
102 // File: contracts/ZethrMultiSigWallet.sol
103 
104 /* Zethr MultisigWallet
105  *
106  * Standard multisig wallet
107  * Holds the bankroll ETH, as well as the bankroll 33% ZTH tokens.
108 */ 
109 contract ZethrMultiSigWallet is ERC223Receiving {
110   using SafeMath for uint;
111 
112   /*=================================
113   =              EVENTS            =
114   =================================*/
115 
116   event Confirmation(address indexed sender, uint indexed transactionId);
117   event Revocation(address indexed sender, uint indexed transactionId);
118   event Submission(uint indexed transactionId);
119   event Execution(uint indexed transactionId);
120   event ExecutionFailure(uint indexed transactionId);
121   event Deposit(address indexed sender, uint value);
122   event OwnerAddition(address indexed owner);
123   event OwnerRemoval(address indexed owner);
124   event WhiteListAddition(address indexed contractAddress);
125   event WhiteListRemoval(address indexed contractAddress);
126   event RequirementChange(uint required);
127   event BankrollInvest(uint amountReceived);
128 
129   /*=================================
130   =             VARIABLES           =
131   =================================*/
132 
133   mapping (uint => Transaction) public transactions;
134   mapping (uint => mapping (address => bool)) public confirmations;
135   mapping (address => bool) public isOwner;
136   address[] public owners;
137   uint public required;
138   uint public transactionCount;
139   bool internal reEntered = false;
140   uint constant public MAX_OWNER_COUNT = 15;
141 
142   /*=================================
143   =         CUSTOM CONSTRUCTS       =
144   =================================*/
145 
146   struct Transaction {
147     address destination;
148     uint value;
149     bytes data;
150     bool executed;
151   }
152 
153   struct TKN {
154     address sender;
155     uint value;
156   }
157 
158   /*=================================
159   =            MODIFIERS            =
160   =================================*/
161 
162   modifier onlyWallet() {
163     if (msg.sender != address(this))
164       revert();
165     _;
166   }
167 
168   modifier isAnOwner() {
169     address caller = msg.sender;
170     if (isOwner[caller])
171       _;
172     else
173       revert();
174   }
175 
176   modifier ownerDoesNotExist(address owner) {
177     if (isOwner[owner]) 
178       revert();
179       _;
180   }
181 
182   modifier ownerExists(address owner) {
183     if (!isOwner[owner])
184       revert();
185     _;
186   }
187 
188   modifier transactionExists(uint transactionId) {
189     if (transactions[transactionId].destination == 0)
190       revert();
191     _;
192   }
193 
194   modifier confirmed(uint transactionId, address owner) {
195     if (!confirmations[transactionId][owner])
196       revert();
197     _;
198   }
199 
200   modifier notConfirmed(uint transactionId, address owner) {
201     if (confirmations[transactionId][owner])
202       revert();
203     _;
204   }
205 
206   modifier notExecuted(uint transactionId) {
207     if (transactions[transactionId].executed)
208       revert();
209     _;
210   }
211 
212   modifier notNull(address _address) {
213     if (_address == 0)
214       revert();
215     _;
216   }
217 
218   modifier validRequirement(uint ownerCount, uint _required) {
219     if ( ownerCount > MAX_OWNER_COUNT
220       || _required > ownerCount
221       || _required == 0
222       || ownerCount == 0)
223       revert();
224     _;
225   }
226 
227 
228   /*=================================
229   =         PUBLIC FUNCTIONS        =
230   =================================*/
231 
232   /// @dev Contract constructor sets initial owners and required number of confirmations.
233   /// @param _owners List of initial owners.
234   /// @param _required Number of required confirmations.
235   constructor (address[] _owners, uint _required)
236     public
237     validRequirement(_owners.length, _required)
238   {
239     // Add owners
240     for (uint i=0; i<_owners.length; i++) {
241       if (isOwner[_owners[i]] || _owners[i] == 0)
242         revert();
243       isOwner[_owners[i]] = true;
244     }
245 
246     // Set owners
247     owners = _owners;
248 
249     // Set required
250     required = _required;
251   }
252 
253   /** Testing only.
254   function exitAll()
255     public
256   {
257     uint tokenBalance = ZTHTKN.balanceOf(address(this));
258     ZTHTKN.sell(tokenBalance - 1e18);
259     ZTHTKN.sell(1e18);
260     ZTHTKN.withdraw(address(0x0));
261   }
262   **/
263 
264   /// @dev Fallback function allows Ether to be deposited.
265   function()
266     public
267     payable
268   {
269 
270   }
271     
272   /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
273   /// @param owner Address of new owner.
274   function addOwner(address owner)
275     public
276     onlyWallet
277     ownerDoesNotExist(owner)
278     notNull(owner)
279     validRequirement(owners.length + 1, required)
280   {
281     isOwner[owner] = true;
282     owners.push(owner);
283     emit OwnerAddition(owner);
284   }
285 
286   /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
287   /// @param owner Address of owner.
288   function removeOwner(address owner)
289     public
290     onlyWallet
291     ownerExists(owner)
292     validRequirement(owners.length, required)
293   {
294     isOwner[owner] = false;
295     for (uint i=0; i<owners.length - 1; i++)
296       if (owners[i] == owner) {
297         owners[i] = owners[owners.length - 1];
298         break;
299       }
300 
301     owners.length -= 1;
302     if (required > owners.length)
303       changeRequirement(owners.length);
304     emit OwnerRemoval(owner);
305   }
306 
307   /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
308   /// @param owner Address of owner to be replaced.
309   /// @param owner Address of new owner.
310   function replaceOwner(address owner, address newOwner)
311     public
312     onlyWallet
313     ownerExists(owner)
314     ownerDoesNotExist(newOwner)
315   {
316     for (uint i=0; i<owners.length; i++)
317       if (owners[i] == owner) {
318         owners[i] = newOwner;
319         break;
320       }
321 
322     isOwner[owner] = false;
323     isOwner[newOwner] = true;
324     emit OwnerRemoval(owner);
325     emit OwnerAddition(newOwner);
326   }
327 
328   /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
329   /// @param _required Number of required confirmations.
330   function changeRequirement(uint _required)
331     public
332     onlyWallet
333     validRequirement(owners.length, _required)
334   {
335     required = _required;
336     emit RequirementChange(_required);
337   }
338 
339   /// @dev Allows an owner to submit and confirm a transaction.
340   /// @param destination Transaction target address.
341   /// @param value Transaction ether value.
342   /// @param data Transaction data payload.
343   /// @return Returns transaction ID.
344   function submitTransaction(address destination, uint value, bytes data)
345     public
346     returns (uint transactionId)
347   {
348     transactionId = addTransaction(destination, value, data);
349     confirmTransaction(transactionId);
350   }
351 
352   /// @dev Allows an owner to confirm a transaction.
353   /// @param transactionId Transaction ID.
354   function confirmTransaction(uint transactionId)
355     public
356     ownerExists(msg.sender)
357     transactionExists(transactionId)
358     notConfirmed(transactionId, msg.sender)
359   {
360     confirmations[transactionId][msg.sender] = true;
361     emit Confirmation(msg.sender, transactionId);
362     executeTransaction(transactionId);
363   }
364 
365   /// @dev Allows an owner to revoke a confirmation for a transaction.
366   /// @param transactionId Transaction ID.
367   function revokeConfirmation(uint transactionId)
368     public
369     ownerExists(msg.sender)
370     confirmed(transactionId, msg.sender)
371     notExecuted(transactionId)
372   {
373     confirmations[transactionId][msg.sender] = false;
374     emit Revocation(msg.sender, transactionId);
375   }
376 
377   /// @dev Allows anyone to execute a confirmed transaction.
378   /// @param transactionId Transaction ID.
379   function executeTransaction(uint transactionId)
380     public
381     notExecuted(transactionId)
382   {
383     if (isConfirmed(transactionId)) {
384       Transaction storage txToExecute = transactions[transactionId];
385       txToExecute.executed = true;
386       if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
387         emit Execution(transactionId);
388       else {
389         emit ExecutionFailure(transactionId);
390         txToExecute.executed = false;
391       }
392     }
393   }
394 
395   /// @dev Returns the confirmation status of a transaction.
396   /// @param transactionId Transaction ID.
397   /// @return Confirmation status.
398   function isConfirmed(uint transactionId)
399     public
400     constant
401     returns (bool)
402   {
403     uint count = 0;
404     for (uint i=0; i<owners.length; i++) {
405       if (confirmations[transactionId][owners[i]])
406         count += 1;
407       if (count == required)
408         return true;
409     }
410   }
411 
412   /*=================================
413   =        OPERATOR FUNCTIONS       =
414   =================================*/
415 
416   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
417   /// @param destination Transaction target address.
418   /// @param value Transaction ether value.
419   /// @param data Transaction data payload.
420   /// @return Returns transaction ID.
421   function addTransaction(address destination, uint value, bytes data)
422     internal
423     notNull(destination)
424     returns (uint transactionId)
425   {
426     transactionId = transactionCount;
427 
428     transactions[transactionId] = Transaction({
429         destination: destination,
430         value: value,
431         data: data,
432         executed: false
433     });
434 
435     transactionCount += 1;
436     emit Submission(transactionId);
437   }
438 
439   /*
440    * Web3 call functions
441    */
442   /// @dev Returns number of confirmations of a transaction.
443   /// @param transactionId Transaction ID.
444   /// @return Number of confirmations.
445   function getConfirmationCount(uint transactionId)
446     public
447     constant
448     returns (uint count)
449   {
450     for (uint i=0; i<owners.length; i++)
451       if (confirmations[transactionId][owners[i]])
452         count += 1;
453   }
454 
455   /// @dev Returns total number of transactions after filers are applied.
456   /// @param pending Include pending transactions.
457   /// @param executed Include executed transactions.
458   /// @return Total number of transactions after filters are applied.
459   function getTransactionCount(bool pending, bool executed)
460     public
461     constant
462     returns (uint count)
463   {
464     for (uint i=0; i<transactionCount; i++)
465       if (pending && !transactions[i].executed || executed && transactions[i].executed)
466         count += 1;
467   }
468 
469   /// @dev Returns list of owners.
470   /// @return List of owner addresses.
471   function getOwners()
472     public
473     constant
474     returns (address[])
475   {
476     return owners;
477   }
478 
479   /// @dev Returns array with owner addresses, which confirmed transaction.
480   /// @param transactionId Transaction ID.
481   /// @return Returns array of owner addresses.
482   function getConfirmations(uint transactionId)
483     public
484     constant
485     returns (address[] _confirmations)
486   {
487     address[] memory confirmationsTemp = new address[](owners.length);
488     uint count = 0;
489     uint i;
490     for (i=0; i<owners.length; i++)
491       if (confirmations[transactionId][owners[i]]) {
492         confirmationsTemp[count] = owners[i];
493         count += 1;
494       }
495 
496       _confirmations = new address[](count);
497 
498       for (i=0; i<count; i++)
499         _confirmations[i] = confirmationsTemp[i];
500   }
501 
502   /// @dev Returns list of transaction IDs in defined range.
503   /// @param from Index start position of transaction array.
504   /// @param to Index end position of transaction array.
505   /// @param pending Include pending transactions.
506   /// @param executed Include executed transactions.
507   /// @return Returns array of transaction IDs.
508   function getTransactionIds(uint from, uint to, bool pending, bool executed)
509     public
510     constant
511     returns (uint[] _transactionIds)
512   {
513     uint[] memory transactionIdsTemp = new uint[](transactionCount);
514     uint count = 0;
515     uint i;
516 
517     for (i=0; i<transactionCount; i++)
518       if (pending && !transactions[i].executed || executed && transactions[i].executed) {
519         transactionIdsTemp[count] = i;
520         count += 1;
521       }
522 
523       _transactionIds = new uint[](to - from);
524 
525     for (i=from; i<to; i++)
526       _transactionIds[i - from] = transactionIdsTemp[i];
527   }
528 
529   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/)
530   public
531   returns (bool)
532   {
533     return true;
534   }
535 }
536 
537 // File: contracts/Bankroll/Interfaces/ZethrTokenBankrollInterface.sol
538 
539 // Zethr token bankroll function prototypes
540 contract ZethrTokenBankrollInterface is ERC223Receiving {
541   uint public jackpotBalance;
542   
543   function getMaxProfit(address) public view returns (uint);
544   function gameTokenResolution(uint _toWinnerAmount, address _winnerAddress, uint _toJackpotAmount, address _jackpotAddress, uint _originalBetSize) external;
545   function payJackpotToWinner(address _winnerAddress, uint payoutDivisor) public;
546 }
547 
548 // File: contracts/Bankroll/Interfaces/ZethrBankrollControllerInterface.sol
549 
550 contract ZethrBankrollControllerInterface is ERC223Receiving {
551   address public jackpotAddress;
552 
553   ZethrTokenBankrollInterface[7] public tokenBankrolls; 
554   
555   ZethrMultiSigWallet public multiSigWallet;
556 
557   mapping(address => bool) public validGameAddresses;
558 
559   function gamePayoutResolver(address _resolver, uint _tokenAmount) public;
560 
561   function isTokenBankroll(address _address) public view returns (bool);
562 
563   function getTokenBankrollAddressFromTier(uint8 _tier) public view returns (address);
564 
565   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
566 }
567 
568 // File: contracts/ERC/ERC721Interface.sol
569 
570 contract ERC721Interface {
571   function approve(address _to, uint _tokenId) public;
572   function balanceOf(address _owner) public view returns (uint balance);
573   function implementsERC721() public pure returns (bool);
574   function ownerOf(uint _tokenId) public view returns (address addr);
575   function takeOwnership(uint _tokenId) public;
576   function totalSupply() public view returns (uint total);
577   function transferFrom(address _from, address _to, uint _tokenId) public;
578   function transfer(address _to, uint _tokenId) public;
579 
580   event Transfer(address indexed from, address indexed to, uint tokenId);
581   event Approval(address indexed owner, address indexed approved, uint tokenId);
582 }
583 
584 // File: contracts/Libraries/AddressUtils.sol
585 
586 /**
587  * Utility library of inline functions on addresses
588  */
589 library AddressUtils {
590 
591   /**
592    * Returns whether the target address is a contract
593    * @dev This function will return false if invoked during the constructor of a contract,
594    *  as the code is not actually created until after the constructor finishes.
595    * @param addr address to check
596    * @return whether the target address is a contract
597    */
598   function isContract(address addr) internal view returns (bool) {
599     uint size;
600     // XXX Currently there is no better way to check if there is a contract in an address
601     // than to check the size of the code at that address.
602     // See https://ethereum.stackexchange.com/a/14016/36603
603     // for more details about how this works.
604     // TODO Check this again before the Serenity release, because all addresses will be
605     // contracts then.
606     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
607     return size > 0;
608   }
609 }
610 
611 // File: contracts/Games/ZethrDividendCards.sol
612 
613 contract ZethrDividendCards is ERC721Interface {
614     using SafeMath for uint;
615 
616   /*** EVENTS ***/
617 
618   /// @dev The Birth event is fired whenever a new dividend card comes into existence.
619   event Birth(uint tokenId, string name, address owner);
620 
621   /// @dev The TokenSold event is fired whenever a token (dividend card, in this case) is sold.
622   event TokenSold(uint tokenId, uint oldPrice, uint newPrice, address prevOwner, address winner, string name);
623 
624   /// @dev Transfer event as defined in current draft of ERC721.
625   ///  Ownership is assigned, including births.
626   event Transfer(address from, address to, uint tokenId);
627 
628   // Events for calculating card profits / errors
629   event BankrollDivCardProfit(uint bankrollProfit, uint percentIncrease, address oldOwner);
630   event BankrollProfitFailure(uint bankrollProfit, uint percentIncrease, address oldOwner);
631   event UserDivCardProfit(uint divCardProfit, uint percentIncrease, address oldOwner);
632   event DivCardProfitFailure(uint divCardProfit, uint percentIncrease, address oldOwner);
633   event masterCardProfit(uint toMaster, address _masterAddress, uint _divCardId);
634   event masterCardProfitFailure(uint toMaster, address _masterAddress, uint _divCardId);
635   event regularCardProfit(uint toRegular, address _regularAddress, uint _divCardId);
636   event regularCardProfitFailure(uint toRegular, address _regularAddress, uint _divCardId);
637 
638   /*** CONSTANTS ***/
639 
640   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
641   string public constant NAME           = "ZethrDividendCard";
642   string public constant SYMBOL         = "ZDC";
643   address public         BANKROLL;
644 
645   /*** STORAGE ***/
646 
647   /// @dev A mapping from dividend card indices to the address that owns them.
648   ///  All dividend cards have a valid owner address.
649 
650   mapping (uint => address) public      divCardIndexToOwner;
651 
652   // A mapping from a dividend rate to the card index.
653 
654   mapping (uint => uint) public         divCardRateToIndex;
655 
656   // @dev A mapping from owner address to the number of dividend cards that address owns.
657   //  Used internally inside balanceOf() to resolve ownership count.
658 
659   mapping (address => uint) private     ownershipDivCardCount;
660 
661   /// @dev A mapping from dividend card indices to an address that has been approved to call
662   ///  transferFrom(). Each dividend card can only have one approved address for transfer
663   ///  at any time. A zero value means no approval is outstanding.
664 
665   mapping (uint => address) public      divCardIndexToApproved;
666 
667   // @dev A mapping from dividend card indices to the price of the dividend card.
668 
669   mapping (uint => uint) private        divCardIndexToPrice;
670 
671   mapping (address => bool) internal    administrators;
672 
673   address public                        creator;
674   bool    public                        onSale;
675 
676   /*** DATATYPES ***/
677 
678   struct Card {
679     string name;
680     uint percentIncrease;
681   }
682 
683   Card[] private divCards;
684 
685   modifier onlyCreator() {
686     require(msg.sender == creator);
687     _;
688   }
689 
690   constructor (address _bankroll) public {
691     creator = msg.sender;
692     BANKROLL = _bankroll;
693 
694     createDivCard("2%", 1 ether, 2);
695     divCardRateToIndex[2] = 0;
696 
697     createDivCard("5%", 1 ether, 5);
698     divCardRateToIndex[5] = 1;
699 
700     createDivCard("10%", 1 ether, 10);
701     divCardRateToIndex[10] = 2;
702 
703     createDivCard("15%", 1 ether, 15);
704     divCardRateToIndex[15] = 3;
705 
706     createDivCard("20%", 1 ether, 20);
707     divCardRateToIndex[20] = 4;
708 
709     createDivCard("25%", 1 ether, 25);
710     divCardRateToIndex[25] = 5;
711 
712     createDivCard("33%", 1 ether, 33);
713     divCardRateToIndex[33] = 6;
714 
715     createDivCard("MASTER", 5 ether, 10);
716     divCardRateToIndex[999] = 7;
717 
718 	  onSale = true;
719 
720     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
721     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
722     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
723     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
724 
725     administrators[msg.sender] = true; // Helps with debugging
726   }
727 
728   /*** MODIFIERS ***/
729 
730   // Modifier to prevent contracts from interacting with the flip cards
731   modifier isNotContract()
732   {
733     require (msg.sender == tx.origin);
734     _;
735   }
736 
737 	// Modifier to prevent purchases before we open them up to everyone
738 	modifier hasStarted()
739   {
740 		require (onSale == true);
741 		_;
742 	}
743 
744 	modifier isAdmin()
745   {
746 	  require(administrators[msg.sender]);
747 	  _;
748   }
749 
750   /*** PUBLIC FUNCTIONS ***/
751   // Administrative update of the bankroll contract address
752   function setBankroll(address where)
753     public
754     isAdmin
755   {
756     BANKROLL = where;
757   }
758 
759   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
760   /// @param _to The address to be granted transfer approval. Pass address(0) to
761   ///  clear all approvals.
762   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
763   /// @dev Required for ERC-721 compliance.
764   function approve(address _to, uint _tokenId)
765     public
766     isNotContract
767   {
768     // Caller must own token.
769     require(_owns(msg.sender, _tokenId));
770 
771     divCardIndexToApproved[_tokenId] = _to;
772 
773     emit Approval(msg.sender, _to, _tokenId);
774   }
775 
776   /// For querying balance of a particular account
777   /// @param _owner The address for balance query
778   /// @dev Required for ERC-721 compliance.
779   function balanceOf(address _owner)
780     public
781     view
782     returns (uint balance)
783   {
784     return ownershipDivCardCount[_owner];
785   }
786 
787   // Creates a div card with bankroll as the owner
788   function createDivCard(string _name, uint _price, uint _percentIncrease)
789     public
790     onlyCreator
791   {
792     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
793   }
794 
795 	// Opens the dividend cards up for sale.
796 	function startCardSale()
797         public
798         isAdmin
799   {
800 		onSale = true;
801 	}
802 
803   /// @notice Returns all the relevant information about a specific div card
804   /// @param _divCardId The tokenId of the div card of interest.
805   function getDivCard(uint _divCardId)
806     public
807     view
808     returns (string divCardName, uint sellingPrice, address owner)
809   {
810     Card storage divCard = divCards[_divCardId];
811     divCardName = divCard.name;
812     sellingPrice = divCardIndexToPrice[_divCardId];
813     owner = divCardIndexToOwner[_divCardId];
814   }
815 
816   function implementsERC721()
817     public
818     pure
819     returns (bool)
820   {
821     return true;
822   }
823 
824   /// @dev Required for ERC-721 compliance.
825   function name()
826     public
827     pure
828     returns (string)
829   {
830     return NAME;
831   }
832 
833   /// For querying owner of token
834   /// @param _divCardId The tokenID for owner inquiry
835   /// @dev Required for ERC-721 compliance.
836   function ownerOf(uint _divCardId)
837     public
838     view
839     returns (address owner)
840   {
841     owner = divCardIndexToOwner[_divCardId];
842     require(owner != address(0));
843 	return owner;
844   }
845 
846   // Allows someone to send Ether and obtain a card
847   function purchase(uint _divCardId)
848     public
849     payable
850     hasStarted
851     isNotContract
852   {
853     address oldOwner  = divCardIndexToOwner[_divCardId];
854     address newOwner  = msg.sender;
855 
856     // Get the current price of the card
857     uint currentPrice = divCardIndexToPrice[_divCardId];
858 
859     // Making sure token owner is not sending to self
860     require(oldOwner != newOwner);
861 
862     // Safety check to prevent against an unexpected 0x0 default.
863     require(_addressNotNull(newOwner));
864 
865     // Making sure sent amount is greater than or equal to the sellingPrice
866     require(msg.value >= currentPrice);
867 
868     // To find the total profit, we need to know the previous price
869     // currentPrice      = previousPrice * (100 + percentIncrease);
870     // previousPrice     = currentPrice / (100 + percentIncrease);
871     uint percentIncrease = divCards[_divCardId].percentIncrease;
872     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
873 
874     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
875     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
876     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
877     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
878     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
879 
880     // Refund the sender the excess he sent
881     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
882 
883     // Raise the price by the percentage specified by the card
884     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
885 
886     // Transfer ownership
887     _transfer(oldOwner, newOwner, _divCardId);
888 
889     // Using send rather than transfer to prevent contract exploitability.
890     if(BANKROLL.send(bankrollProfit)) {
891       emit BankrollDivCardProfit(bankrollProfit, percentIncrease, oldOwner);
892     } else {
893       emit BankrollProfitFailure(bankrollProfit, percentIncrease, oldOwner);
894     }
895 
896     if(oldOwner.send(oldOwnerProfit)) {
897       emit UserDivCardProfit(oldOwnerProfit, percentIncrease, oldOwner);
898     } else {
899       emit DivCardProfitFailure(oldOwnerProfit, percentIncrease, oldOwner);
900     }
901 
902     msg.sender.transfer(purchaseExcess);
903   }
904 
905   function priceOf(uint _divCardId)
906     public
907     view
908     returns (uint price)
909   {
910     return divCardIndexToPrice[_divCardId];
911   }
912 
913   function setCreator(address _creator)
914     public
915     onlyCreator
916   {
917     require(_creator != address(0));
918 
919     creator = _creator;
920   }
921 
922   /// @dev Required for ERC-721 compliance.
923   function symbol()
924     public
925     pure
926     returns (string)
927   {
928     return SYMBOL;
929   }
930 
931   /// @notice Allow pre-approved user to take ownership of a dividend card.
932   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
933   /// @dev Required for ERC-721 compliance.
934   function takeOwnership(uint _divCardId)
935     public
936     isNotContract
937   {
938     address newOwner = msg.sender;
939     address oldOwner = divCardIndexToOwner[_divCardId];
940 
941     // Safety check to prevent against an unexpected 0x0 default.
942     require(_addressNotNull(newOwner));
943 
944     // Making sure transfer is approved
945     require(_approved(newOwner, _divCardId));
946 
947     _transfer(oldOwner, newOwner, _divCardId);
948   }
949 
950   /// For querying totalSupply of token
951   /// @dev Required for ERC-721 compliance.
952   function totalSupply()
953     public
954     view
955     returns (uint total)
956   {
957     return divCards.length;
958   }
959 
960   /// Owner initates the transfer of the card to another account
961   /// @param _to The address for the card to be transferred to.
962   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
963   /// @dev Required for ERC-721 compliance.
964   function transfer(address _to, uint _divCardId)
965     public
966     isNotContract
967   {
968     require(_owns(msg.sender, _divCardId));
969     require(_addressNotNull(_to));
970 
971     _transfer(msg.sender, _to, _divCardId);
972   }
973 
974   /// Third-party initiates transfer of a card from address _from to address _to
975   /// @param _from The address for the card to be transferred from.
976   /// @param _to The address for the card to be transferred to.
977   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
978   /// @dev Required for ERC-721 compliance.
979   function transferFrom(address _from, address _to, uint _divCardId)
980     public
981     isNotContract
982   {
983     require(_owns(_from, _divCardId));
984     require(_approved(_to, _divCardId));
985     require(_addressNotNull(_to));
986 
987     _transfer(_from, _to, _divCardId);
988   }
989 
990   function receiveDividends(uint _divCardRate)
991     public
992     payable
993   {
994     uint _divCardId = divCardRateToIndex[_divCardRate];
995     address _regularAddress = divCardIndexToOwner[_divCardId];
996     address _masterAddress = divCardIndexToOwner[7];
997 
998     uint toMaster = msg.value.div(2);
999     uint toRegular = msg.value.sub(toMaster);
1000 
1001     if(_masterAddress.send(toMaster)){
1002       emit masterCardProfit(toMaster, _masterAddress, _divCardId);
1003     } else {
1004       emit masterCardProfitFailure(toMaster, _masterAddress, _divCardId);
1005     }
1006 
1007     if(_regularAddress.send(toRegular)) {
1008       emit regularCardProfit(toRegular, _regularAddress, _divCardId);
1009     } else {
1010       emit regularCardProfitFailure(toRegular, _regularAddress, _divCardId);
1011     }
1012   }
1013 
1014   /*** PRIVATE FUNCTIONS ***/
1015   /// Safety check on _to address to prevent against an unexpected 0x0 default.
1016   function _addressNotNull(address _to)
1017     private
1018     pure
1019     returns (bool)
1020   {
1021     return _to != address(0);
1022   }
1023 
1024   /// For checking approval of transfer for address _to
1025   function _approved(address _to, uint _divCardId)
1026     private
1027     view
1028     returns (bool)
1029   {
1030     return divCardIndexToApproved[_divCardId] == _to;
1031   }
1032 
1033   /// For creating a dividend card
1034   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
1035     private
1036   {
1037     Card memory _divcard = Card({
1038       name: _name,
1039       percentIncrease: _percentIncrease
1040     });
1041     uint newCardId = divCards.push(_divcard) - 1;
1042 
1043     // It's probably never going to happen, 4 billion tokens are A LOT, but
1044     // let's just be 100% sure we never let this happen.
1045     require(newCardId == uint(uint32(newCardId)));
1046 
1047     emit Birth(newCardId, _name, _owner);
1048 
1049     divCardIndexToPrice[newCardId] = _price;
1050 
1051     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
1052     _transfer(BANKROLL, _owner, newCardId);
1053   }
1054 
1055   /// Check for token ownership
1056   function _owns(address claimant, uint _divCardId)
1057     private
1058     view
1059     returns (bool)
1060   {
1061     return claimant == divCardIndexToOwner[_divCardId];
1062   }
1063 
1064   /// @dev Assigns ownership of a specific Card to an address.
1065   function _transfer(address _from, address _to, uint _divCardId)
1066     private
1067   {
1068     // Since the number of cards is capped to 2^32 we can't overflow this
1069     ownershipDivCardCount[_to]++;
1070     //transfer ownership
1071     divCardIndexToOwner[_divCardId] = _to;
1072 
1073     // When creating new div cards _from is 0x0, but we can't account that address.
1074     if (_from != address(0)) {
1075       ownershipDivCardCount[_from]--;
1076       // clear any previously approved ownership exchange
1077       delete divCardIndexToApproved[_divCardId];
1078     }
1079 
1080     // Emit the transfer event.
1081     emit Transfer(_from, _to, _divCardId);
1082   }
1083 }
1084 
1085 // File: contracts/Zethr.sol
1086 
1087 contract Zethr {
1088   using SafeMath for uint;
1089 
1090   /*=================================
1091   =            MODIFIERS            =
1092   =================================*/
1093 
1094   modifier onlyHolders() {
1095     require(myFrontEndTokens() > 0);
1096     _;
1097   }
1098 
1099   modifier dividendHolder() {
1100     require(myDividends(true) > 0);
1101     _;
1102   }
1103 
1104   modifier onlyAdministrator(){
1105     address _customerAddress = msg.sender;
1106     require(administrators[_customerAddress]);
1107     _;
1108   }
1109 
1110   /*==============================
1111   =            EVENTS            =
1112   ==============================*/
1113 
1114   event onTokenPurchase(
1115     address indexed customerAddress,
1116     uint incomingEthereum,
1117     uint tokensMinted,
1118     address indexed referredBy
1119   );
1120 
1121   event UserDividendRate(
1122     address user,
1123     uint divRate
1124   );
1125 
1126   event onTokenSell(
1127     address indexed customerAddress,
1128     uint tokensBurned,
1129     uint ethereumEarned
1130   );
1131 
1132   event onReinvestment(
1133     address indexed customerAddress,
1134     uint ethereumReinvested,
1135     uint tokensMinted
1136   );
1137 
1138   event onWithdraw(
1139     address indexed customerAddress,
1140     uint ethereumWithdrawn
1141   );
1142 
1143   event Transfer(
1144     address indexed from,
1145     address indexed to,
1146     uint tokens
1147   );
1148 
1149   event Approval(
1150     address indexed tokenOwner,
1151     address indexed spender,
1152     uint tokens
1153   );
1154 
1155   event Allocation(
1156     uint toBankRoll,
1157     uint toReferrer,
1158     uint toTokenHolders,
1159     uint toDivCardHolders,
1160     uint forTokens
1161   );
1162 
1163   event Referral(
1164     address referrer,
1165     uint amountReceived
1166   );
1167 
1168   /*=====================================
1169   =            CONSTANTS                =
1170   =====================================*/
1171 
1172   uint8 constant public                decimals = 18;
1173 
1174   uint constant internal               tokenPriceInitial_ = 0.000653 ether;
1175   uint constant internal               magnitude = 2 ** 64;
1176 
1177   uint constant internal               icoHardCap = 250 ether;
1178   uint constant internal               addressICOLimit = 1   ether;
1179   uint constant internal               icoMinBuyIn = 0.1 finney;
1180   uint constant internal               icoMaxGasPrice = 50000000000 wei;
1181 
1182   uint constant internal               MULTIPLIER = 9615;
1183 
1184   uint constant internal               MIN_ETH_BUYIN = 0.0001 ether;
1185   uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
1186   uint constant internal               MIN_TOKEN_TRANSFER = 1e10;
1187   uint constant internal               referrer_percentage = 25;
1188 
1189   uint public                          stakingRequirement = 100e18;
1190 
1191   /*================================
1192    =          CONFIGURABLES         =
1193    ================================*/
1194 
1195   string public                        name = "Zethr";
1196   string public                        symbol = "ZTH";
1197 
1198   //bytes32 constant public              icoHashedPass      = bytes32(0x5ddcde33b94b19bdef79dd9ea75be591942b9ec78286d64b44a356280fb6a262); // public
1199   bytes32 constant public              icoHashedPass = bytes32(0x8a6ddee3fb2508ff4a5b02b48e9bc4566d0f3e11f306b0f75341bf235662a9e3); // test hunter2
1200 
1201   address internal                     bankrollAddress;
1202 
1203   ZethrDividendCards                   divCardContract;
1204 
1205   /*================================
1206    =            DATASETS            =
1207    ================================*/
1208 
1209   // Tracks front & backend tokens
1210   mapping(address => uint) internal    frontTokenBalanceLedger_;
1211   mapping(address => uint) internal    dividendTokenBalanceLedger_;
1212   mapping(address =>
1213   mapping(address => uint))
1214   public      allowed;
1215 
1216   // Tracks dividend rates for users
1217   mapping(uint8 => bool)    internal validDividendRates_;
1218   mapping(address => bool)    internal userSelectedRate;
1219   mapping(address => uint8)   internal userDividendRate;
1220 
1221   // Payout tracking
1222   mapping(address => uint)    internal referralBalance_;
1223   mapping(address => int256)  internal payoutsTo_;
1224 
1225   // ICO per-address limit tracking
1226   mapping(address => uint)    internal ICOBuyIn;
1227 
1228   uint public                          tokensMintedDuringICO;
1229   uint public                          ethInvestedDuringICO;
1230 
1231   uint public                          currentEthInvested;
1232 
1233   uint internal                        tokenSupply = 0;
1234   uint internal                        divTokenSupply = 0;
1235 
1236   uint internal                        profitPerDivToken;
1237 
1238   mapping(address => bool) public      administrators;
1239 
1240   bool public                          icoPhase = false;
1241   bool public                          regularPhase = false;
1242 
1243   uint                                 icoOpenTime;
1244 
1245   /*=======================================
1246   =            PUBLIC FUNCTIONS           =
1247   =======================================*/
1248   constructor (address _bankrollAddress, address _divCardAddress)
1249   public
1250   {
1251     bankrollAddress = _bankrollAddress;
1252     divCardContract = ZethrDividendCards(_divCardAddress);
1253 
1254     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true;
1255     // Norsefire
1256     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true;
1257     // klob
1258     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true;
1259     // Etherguy
1260     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true;
1261     // blurr
1262     administrators[0x8537aa2911b193e5B377938A723D805bb0865670] = true;
1263     // oguzhanox
1264     administrators[0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3] = true;
1265     // Randall
1266     administrators[0xDa83156106c4dba7A26E9bF2Ca91E273350aa551] = true;
1267     // TropicalRogue
1268     administrators[0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696] = true;
1269     // cryptodude
1270 
1271     administrators[msg.sender] = true;
1272     // Helps with debugging!
1273 
1274     validDividendRates_[2] = true;
1275     validDividendRates_[5] = true;
1276     validDividendRates_[10] = true;
1277     validDividendRates_[15] = true;
1278     validDividendRates_[20] = true;
1279     validDividendRates_[25] = true;
1280     validDividendRates_[33] = true;
1281 
1282     userSelectedRate[bankrollAddress] = true;
1283     userDividendRate[bankrollAddress] = 33;
1284 
1285   }
1286 
1287   /**
1288    * Same as buy, but explicitly sets your dividend percentage.
1289    * If this has been called before, it will update your `default' dividend
1290    *   percentage for regular buy transactions going forward.
1291    */
1292   function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string /*providedUnhashedPass*/)
1293   public
1294   payable
1295   returns (uint)
1296   {
1297     require(icoPhase || regularPhase);
1298 
1299     if (icoPhase) {
1300 
1301       // Anti-bot measures - not perfect, but should help some.
1302       // bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
1303       //require(hashedProvidedPass == icoHashedPass || msg.sender == bankrollAddress); // test; remove
1304 
1305       uint gasPrice = tx.gasprice;
1306 
1307       // Prevents ICO buyers from getting substantially burned if the ICO is reached
1308       //   before their transaction is processed.
1309       require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
1310 
1311     }
1312 
1313     // Dividend percentage should be a currently accepted value.
1314     require(validDividendRates_[_divChoice]);
1315 
1316     // Set the dividend fee percentage denominator.
1317     userSelectedRate[msg.sender] = true;
1318     userDividendRate[msg.sender] = _divChoice;
1319     emit UserDividendRate(msg.sender, _divChoice);
1320 
1321     // Finally, purchase tokens.
1322     purchaseTokens(msg.value, _referredBy);
1323   }
1324 
1325   // All buys except for the above one require regular phase.
1326 
1327   function buy(address _referredBy)
1328   public
1329   payable
1330   returns (uint)
1331   {
1332     require(regularPhase);
1333     address _customerAddress = msg.sender;
1334     require(userSelectedRate[_customerAddress]);
1335     purchaseTokens(msg.value, _referredBy);
1336   }
1337 
1338   function buyAndTransfer(address _referredBy, address target)
1339   public
1340   payable
1341   {
1342     bytes memory empty;
1343     buyAndTransfer(_referredBy, target, empty, 20);
1344   }
1345 
1346   function buyAndTransfer(address _referredBy, address target, bytes _data)
1347   public
1348   payable
1349   {
1350     buyAndTransfer(_referredBy, target, _data, 20);
1351   }
1352 
1353   // Overload
1354   function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
1355   public
1356   payable
1357   {
1358     require(regularPhase);
1359     address _customerAddress = msg.sender;
1360     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
1361     if (userSelectedRate[_customerAddress] && divChoice == 0) {
1362       purchaseTokens(msg.value, _referredBy);
1363     } else {
1364       buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
1365     }
1366     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
1367     transferTo(msg.sender, target, difference, _data);
1368   }
1369 
1370   // Fallback function only works during regular phase - part of anti-bot protection.
1371   function()
1372   payable
1373   public
1374   {
1375     /**
1376     / If the user has previously set a dividend rate, sending
1377     /   Ether directly to the contract simply purchases more at
1378     /   the most recent rate. If this is their first time, they
1379     /   are automatically placed into the 20% rate `bucket'.
1380     **/
1381     require(regularPhase);
1382     address _customerAddress = msg.sender;
1383     if (userSelectedRate[_customerAddress]) {
1384       purchaseTokens(msg.value, 0x0);
1385     } else {
1386       buyAndSetDivPercentage(0x0, 20, "0x0");
1387     }
1388   }
1389 
1390   function reinvest()
1391   dividendHolder()
1392   public
1393   {
1394     require(regularPhase);
1395     uint _dividends = myDividends(false);
1396 
1397     // Pay out requisite `virtual' dividends.
1398     address _customerAddress = msg.sender;
1399     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
1400 
1401     _dividends += referralBalance_[_customerAddress];
1402     referralBalance_[_customerAddress] = 0;
1403 
1404     uint _tokens = purchaseTokens(_dividends, 0x0);
1405 
1406     // Fire logging event.
1407     emit onReinvestment(_customerAddress, _dividends, _tokens);
1408   }
1409 
1410   function exit()
1411   public
1412   {
1413     require(regularPhase);
1414     // Retrieve token balance for caller, then sell them all.
1415     address _customerAddress = msg.sender;
1416     uint _tokens = frontTokenBalanceLedger_[_customerAddress];
1417 
1418     if (_tokens > 0) sell(_tokens);
1419 
1420     withdraw(_customerAddress);
1421   }
1422 
1423   function withdraw(address _recipient)
1424   dividendHolder()
1425   public
1426   {
1427     require(regularPhase);
1428     // Setup data
1429     address _customerAddress = msg.sender;
1430     uint _dividends = myDividends(false);
1431 
1432     // update dividend tracker
1433     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
1434 
1435     // add ref. bonus
1436     _dividends += referralBalance_[_customerAddress];
1437     referralBalance_[_customerAddress] = 0;
1438 
1439     if (_recipient == address(0x0)) {
1440       _recipient = msg.sender;
1441     }
1442     _recipient.transfer(_dividends);
1443 
1444     // Fire logging event.
1445     emit onWithdraw(_recipient, _dividends);
1446   }
1447 
1448   // Sells front-end tokens.
1449   // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
1450   function sell(uint _amountOfTokens)
1451   onlyHolders()
1452   public
1453   {
1454     // No selling during the ICO. You don't get to flip that fast, sorry!
1455     require(!icoPhase);
1456     require(regularPhase);
1457 
1458     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
1459 
1460     uint _frontEndTokensToBurn = _amountOfTokens;
1461 
1462     // Calculate how many dividend tokens this action burns.
1463     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
1464     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
1465     uint userDivRate = getUserAverageDividendRate(msg.sender);
1466     require((2 * magnitude) <= userDivRate && (50 * magnitude) >= userDivRate);
1467     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
1468 
1469     // Calculate ethereum received before dividends
1470     uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
1471 
1472     if (_ethereum > currentEthInvested) {
1473       // Well, congratulations, you've emptied the coffers.
1474       currentEthInvested = 0;
1475     } else {currentEthInvested = currentEthInvested - _ethereum;}
1476 
1477     // Calculate dividends generated from the sale.
1478     uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
1479 
1480     // Calculate Ethereum receivable net of dividends.
1481     uint _taxedEthereum = _ethereum.sub(_dividends);
1482 
1483     // Burn the sold tokens (both front-end and back-end variants).
1484     tokenSupply = tokenSupply.sub(_frontEndTokensToBurn);
1485     divTokenSupply = divTokenSupply.sub(_divTokensToBurn);
1486 
1487     // Subtract the token balances for the seller
1488     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
1489     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
1490 
1491     // Update dividends tracker
1492     int256 _updatedPayouts = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
1493     payoutsTo_[msg.sender] -= _updatedPayouts;
1494 
1495     // Let's avoid breaking arithmetic where we can, eh?
1496     if (divTokenSupply > 0) {
1497       // Update the value of each remaining back-end dividend token.
1498       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
1499     }
1500 
1501     // Fire logging event.
1502     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
1503   }
1504 
1505   /**
1506    * Transfer tokens from the caller to a new holder.
1507    * No charge incurred for the transfer. We'd make a terrible bank.
1508    */
1509   function transfer(address _toAddress, uint _amountOfTokens)
1510   onlyHolders()
1511   public
1512   returns (bool)
1513   {
1514     require(_amountOfTokens >= MIN_TOKEN_TRANSFER && _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
1515     bytes memory empty;
1516     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
1517     return true;
1518   }
1519 
1520   function approve(address spender, uint tokens)
1521   public
1522   returns (bool)
1523   {
1524     address _customerAddress = msg.sender;
1525     allowed[_customerAddress][spender] = tokens;
1526 
1527     // Fire logging event.
1528     emit Approval(_customerAddress, spender, tokens);
1529 
1530     // Good old ERC20.
1531     return true;
1532   }
1533 
1534   /**
1535    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
1536    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
1537    */
1538   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
1539   public
1540   returns (bool)
1541   {
1542     // Setup variables
1543     address _customerAddress = _from;
1544     bytes memory empty;
1545     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
1546     // and are transferring at least one full token.
1547     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1548     && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
1549     && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
1550 
1551     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
1552 
1553     // Good old ERC20.
1554     return true;
1555 
1556   }
1557 
1558   function transferTo(address _from, address _to, uint _amountOfTokens, bytes _data)
1559   public
1560   {
1561     if (_from != msg.sender) {
1562       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1563       && _amountOfTokens <= frontTokenBalanceLedger_[_from]
1564       && _amountOfTokens <= allowed[_from][msg.sender]);
1565     }
1566     else {
1567       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
1568       && _amountOfTokens <= frontTokenBalanceLedger_[_from]);
1569     }
1570 
1571     transferFromInternal(_from, _to, _amountOfTokens, _data);
1572   }
1573 
1574   // Who'd have thought we'd need this thing floating around?
1575   function totalSupply()
1576   public
1577   view
1578   returns (uint256)
1579   {
1580     return tokenSupply;
1581   }
1582 
1583   // Anyone can start the regular phase 2 weeks after the ICO phase starts.
1584   // In case the devs die. Or something.
1585   function publicStartRegularPhase()
1586   public
1587   {
1588     require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
1589 
1590     icoPhase = false;
1591     regularPhase = true;
1592   }
1593 
1594   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
1595 
1596 
1597   // Fire the starting gun and then duck for cover.
1598   function startICOPhase()
1599   onlyAdministrator()
1600   public
1601   {
1602     // Prevent us from startaring the ICO phase again
1603     require(icoOpenTime == 0);
1604     icoPhase = true;
1605     icoOpenTime = now;
1606   }
1607 
1608   // Fire the ... ending gun?
1609   function endICOPhase()
1610   onlyAdministrator()
1611   public
1612   {
1613     icoPhase = false;
1614   }
1615 
1616   function startRegularPhase()
1617   onlyAdministrator
1618   public
1619   {
1620     // disable ico phase in case if that was not disabled yet
1621     icoPhase = false;
1622     regularPhase = true;
1623   }
1624 
1625   // The death of a great man demands the birth of a great son.
1626   function setAdministrator(address _newAdmin, bool _status)
1627   onlyAdministrator()
1628   public
1629   {
1630     administrators[_newAdmin] = _status;
1631   }
1632 
1633   function setStakingRequirement(uint _amountOfTokens)
1634   onlyAdministrator()
1635   public
1636   {
1637     // This plane only goes one way, lads. Never below the initial.
1638     require(_amountOfTokens >= 100e18);
1639     stakingRequirement = _amountOfTokens;
1640   }
1641 
1642   function setName(string _name)
1643   onlyAdministrator()
1644   public
1645   {
1646     name = _name;
1647   }
1648 
1649   function setSymbol(string _symbol)
1650   onlyAdministrator()
1651   public
1652   {
1653     symbol = _symbol;
1654   }
1655 
1656   function changeBankroll(address _newBankrollAddress)
1657   onlyAdministrator
1658   public
1659   {
1660     bankrollAddress = _newBankrollAddress;
1661   }
1662 
1663   /*----------  HELPERS AND CALCULATORS  ----------*/
1664 
1665   function totalEthereumBalance()
1666   public
1667   view
1668   returns (uint)
1669   {
1670     return address(this).balance;
1671   }
1672 
1673   function totalEthereumICOReceived()
1674   public
1675   view
1676   returns (uint)
1677   {
1678     return ethInvestedDuringICO;
1679   }
1680 
1681   /**
1682    * Retrieves your currently selected dividend rate.
1683    */
1684   function getMyDividendRate()
1685   public
1686   view
1687   returns (uint8)
1688   {
1689     address _customerAddress = msg.sender;
1690     require(userSelectedRate[_customerAddress]);
1691     return userDividendRate[_customerAddress];
1692   }
1693 
1694   /**
1695    * Retrieve the total frontend token supply
1696    */
1697   function getFrontEndTokenSupply()
1698   public
1699   view
1700   returns (uint)
1701   {
1702     return tokenSupply;
1703   }
1704 
1705   /**
1706    * Retreive the total dividend token supply
1707    */
1708   function getDividendTokenSupply()
1709   public
1710   view
1711   returns (uint)
1712   {
1713     return divTokenSupply;
1714   }
1715 
1716   /**
1717    * Retrieve the frontend tokens owned by the caller
1718    */
1719   function myFrontEndTokens()
1720   public
1721   view
1722   returns (uint)
1723   {
1724     address _customerAddress = msg.sender;
1725     return getFrontEndTokenBalanceOf(_customerAddress);
1726   }
1727 
1728   /**
1729    * Retrieve the dividend tokens owned by the caller
1730    */
1731   function myDividendTokens()
1732   public
1733   view
1734   returns (uint)
1735   {
1736     address _customerAddress = msg.sender;
1737     return getDividendTokenBalanceOf(_customerAddress);
1738   }
1739 
1740   function myReferralDividends()
1741   public
1742   view
1743   returns (uint)
1744   {
1745     return myDividends(true) - myDividends(false);
1746   }
1747 
1748   function myDividends(bool _includeReferralBonus)
1749   public
1750   view
1751   returns (uint)
1752   {
1753     address _customerAddress = msg.sender;
1754     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
1755   }
1756 
1757   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
1758   public
1759   view
1760   returns (uint)
1761   {
1762     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
1763   }
1764 
1765   function getFrontEndTokenBalanceOf(address _customerAddress)
1766   view
1767   public
1768   returns (uint)
1769   {
1770     return frontTokenBalanceLedger_[_customerAddress];
1771   }
1772 
1773   function balanceOf(address _owner)
1774   view
1775   public
1776   returns (uint)
1777   {
1778     return getFrontEndTokenBalanceOf(_owner);
1779   }
1780 
1781   function getDividendTokenBalanceOf(address _customerAddress)
1782   view
1783   public
1784   returns (uint)
1785   {
1786     return dividendTokenBalanceLedger_[_customerAddress];
1787   }
1788 
1789   function dividendsOf(address _customerAddress)
1790   view
1791   public
1792   returns (uint)
1793   {
1794     return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
1795   }
1796 
1797   // Get the sell price at the user's average dividend rate
1798   function sellPrice()
1799   public
1800   view
1801   returns (uint)
1802   {
1803     uint price;
1804 
1805     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
1806       price = tokenPriceInitial_;
1807     } else {
1808 
1809       // Calculate the tokens received for 100 finney.
1810       // Divide to find the average, to calculate the price.
1811       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
1812 
1813       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
1814     }
1815 
1816     // Factor in the user's average dividend rate
1817     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
1818 
1819     return theSellPrice;
1820   }
1821 
1822   // Get the buy price at a particular dividend rate
1823   function buyPrice(uint dividendRate)
1824   public
1825   view
1826   returns (uint)
1827   {
1828     uint price;
1829 
1830     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
1831       price = tokenPriceInitial_;
1832     } else {
1833 
1834       // Calculate the tokens received for 100 finney.
1835       // Divide to find the average, to calculate the price.
1836       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
1837 
1838       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
1839     }
1840 
1841     // Factor in the user's selected dividend rate
1842     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
1843 
1844     return theBuyPrice;
1845   }
1846 
1847   function calculateTokensReceived(uint _ethereumToSpend)
1848   public
1849   view
1850   returns (uint)
1851   {
1852     uint _dividends = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
1853     uint _taxedEthereum = _ethereumToSpend.sub(_dividends);
1854     uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1855     return _amountOfTokens;
1856   }
1857 
1858   // When selling tokens, we need to calculate the user's current dividend rate.
1859   // This is different from their selected dividend rate.
1860   function calculateEthereumReceived(uint _tokensToSell)
1861   public
1862   view
1863   returns (uint)
1864   {
1865     require(_tokensToSell <= tokenSupply);
1866     uint _ethereum = tokensToEthereum_(_tokensToSell);
1867     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
1868     uint _dividends = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
1869     uint _taxedEthereum = _ethereum.sub(_dividends);
1870     return _taxedEthereum;
1871   }
1872 
1873   /*
1874    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
1875    * We multiply by magnitude to avoid precision errors.
1876    */
1877 
1878   function getUserAverageDividendRate(address user) public view returns (uint) {
1879     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
1880   }
1881 
1882   function getMyAverageDividendRate() public view returns (uint) {
1883     return getUserAverageDividendRate(msg.sender);
1884   }
1885 
1886   /*==========================================
1887   =            INTERNAL FUNCTIONS            =
1888   ==========================================*/
1889 
1890   /* Purchase tokens with Ether.
1891      During ICO phase, dividends should go to the bankroll
1892      During normal operation:
1893        0.5% should go to the master dividend card
1894        0.5% should go to the matching dividend card
1895        25% of dividends should go to the referrer, if any is provided. */
1896   function purchaseTokens(uint _incomingEthereum, address _referredBy)
1897   internal
1898   returns (uint)
1899   {
1900     require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
1901 
1902     uint toBankRoll;
1903     uint toReferrer;
1904     uint toTokenHolders;
1905     uint toDivCardHolders;
1906 
1907     uint dividendAmount;
1908 
1909     uint tokensBought;
1910     uint dividendTokensBought;
1911 
1912     uint remainingEth = _incomingEthereum;
1913 
1914     uint fee;
1915 
1916     // 1% for dividend card holders is taken off before anything else
1917     if (regularPhase) {
1918       toDivCardHolders = _incomingEthereum.div(100);
1919       remainingEth = remainingEth.sub(toDivCardHolders);
1920     }
1921 
1922     /* Next, we tax for dividends:
1923        Dividends = (ethereum * div%) / 100
1924        Important note: if we're out of the ICO phase, the 1% sent to div-card holders
1925                        is handled prior to any dividend taxes are considered. */
1926 
1927     // Grab the user's dividend rate
1928     uint dividendRate = userDividendRate[msg.sender];
1929 
1930     // Calculate the total dividends on this buy
1931     dividendAmount = (remainingEth.mul(dividendRate)).div(100);
1932 
1933     remainingEth = remainingEth.sub(dividendAmount);
1934 
1935     // If we're in the ICO and bankroll is buying, don't tax
1936     if (icoPhase && msg.sender == bankrollAddress) {
1937       remainingEth = remainingEth + dividendAmount;
1938     }
1939 
1940     // Calculate how many tokens to buy:
1941     tokensBought = ethereumToTokens_(remainingEth);
1942     dividendTokensBought = tokensBought.mul(dividendRate);
1943 
1944     // This is where we actually mint tokens:
1945     tokenSupply = tokenSupply.add(tokensBought);
1946     divTokenSupply = divTokenSupply.add(dividendTokensBought);
1947 
1948     /* Update the total investment tracker
1949        Note that this must be done AFTER we calculate how many tokens are bought -
1950        because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
1951 
1952     currentEthInvested = currentEthInvested + remainingEth;
1953 
1954     // If ICO phase, all the dividends go to the bankroll
1955     if (icoPhase) {
1956       toBankRoll = dividendAmount;
1957 
1958       // If the bankroll is buying, we don't want to send eth back to the bankroll
1959       // Instead, let's just give it the tokens it would get in an infinite recursive buy
1960       if (msg.sender == bankrollAddress) {
1961         toBankRoll = 0;
1962       }
1963 
1964       toReferrer = 0;
1965       toTokenHolders = 0;
1966 
1967       /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
1968          not how much Ether we get total.
1969          this is so that our calculation using "investment" is accurate. */
1970       ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
1971       tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
1972 
1973       // Cannot purchase more than the hard cap during ICO.
1974       require(ethInvestedDuringICO <= icoHardCap);
1975       // Contracts aren't allowed to participate in the ICO.
1976       require(tx.origin == msg.sender || msg.sender == bankrollAddress);
1977 
1978       // Cannot purchase more then the limit per address during the ICO.
1979       ICOBuyIn[msg.sender] += remainingEth;
1980       //require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress); // test:remove
1981 
1982       // Stop the ICO phase if we reach the hard cap
1983       if (ethInvestedDuringICO == icoHardCap) {
1984         icoPhase = false;
1985       }
1986 
1987     } else {
1988       // Not ICO phase, check for referrals
1989 
1990       // 25% goes to referrers, if set
1991       // toReferrer = (dividends * 25)/100
1992       if (_referredBy != 0x0000000000000000000000000000000000000000 &&
1993       _referredBy != msg.sender &&
1994       frontTokenBalanceLedger_[_referredBy] >= stakingRequirement)
1995       {
1996         toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
1997         referralBalance_[_referredBy] += toReferrer;
1998         emit Referral(_referredBy, toReferrer);
1999       }
2000 
2001       // The rest of the dividends go to token holders
2002       toTokenHolders = dividendAmount.sub(toReferrer);
2003 
2004       fee = toTokenHolders * magnitude;
2005       fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
2006 
2007       // Finally, increase the divToken value
2008       profitPerDivToken = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
2009       payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
2010     }
2011 
2012     // Update the buyer's token amounts
2013     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
2014     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
2015 
2016     // Transfer to bankroll and div cards
2017     if (toBankRoll != 0) {ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)();}
2018     if (regularPhase) {divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate);}
2019 
2020     // This event should help us track where all the eth is going
2021     emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
2022 
2023     // Sanity checking
2024     uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth - _incomingEthereum;
2025     assert(sum == 0);
2026   }
2027 
2028   // How many tokens one gets from a certain amount of ethereum.
2029   function ethereumToTokens_(uint _ethereumAmount)
2030   public
2031   view
2032   returns (uint)
2033   {
2034     require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
2035 
2036     if (icoPhase) {
2037       return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
2038     }
2039 
2040     /*
2041      *  i = investment, p = price, t = number of tokens
2042      *
2043      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
2044      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
2045      *
2046      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
2047      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
2048      */
2049 
2050     // First, separate out the buy into two segments:
2051     //  1) the amount of eth going towards ico-price tokens
2052     //  2) the amount of eth going towards pyramid-price (variable) tokens
2053     uint ethTowardsICOPriceTokens = 0;
2054     uint ethTowardsVariablePriceTokens = 0;
2055 
2056     if (currentEthInvested >= ethInvestedDuringICO) {
2057       // Option One: All the ETH goes towards variable-price tokens
2058       ethTowardsVariablePriceTokens = _ethereumAmount;
2059 
2060     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
2061       // Option Two: All the ETH goes towards ICO-price tokens
2062       ethTowardsICOPriceTokens = _ethereumAmount;
2063 
2064     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
2065       // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
2066       ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
2067       ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
2068     } else {
2069       // Option Four: Should be impossible, and compiler should optimize it out of existence.
2070       revert();
2071     }
2072 
2073     // Sanity check:
2074     assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
2075 
2076     // Separate out the number of tokens of each type this will buy:
2077     uint icoPriceTokens = 0;
2078     uint varPriceTokens = 0;
2079 
2080     // Now calculate each one per the above formulas.
2081     // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
2082     if (ethTowardsICOPriceTokens != 0) {
2083       icoPriceTokens = ethTowardsICOPriceTokens.mul(1e18).div(tokenPriceInitial_);
2084     }
2085 
2086     if (ethTowardsVariablePriceTokens != 0) {
2087       // Note: we can't use "currentEthInvested" for this calculation, we must use:
2088       //  currentEthInvested + ethTowardsICOPriceTokens
2089       // This is because a split-buy essentially needs to simulate two separate buys -
2090       // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
2091 
2092       uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
2093       uint simulatedEthAfterInvested = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
2094 
2095       /* We have the equations for total tokens above; note that this is for TOTAL.
2096          To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
2097          and the simulatedEthInvestedAfter and calculate the difference in tokens.
2098          This is how many we get. */
2099 
2100       uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
2101       uint tokensAfter = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
2102 
2103       /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
2104          either should work.
2105 
2106          Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
2107          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
2108 
2109       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
2110     }
2111 
2112     uint totalTokensReceived = icoPriceTokens + varPriceTokens;
2113 
2114     assert(totalTokensReceived > 0);
2115     return totalTokensReceived;
2116   }
2117 
2118   // How much Ether we get from selling N tokens
2119   function tokensToEthereum_(uint _tokens)
2120   public
2121   view
2122   returns (uint)
2123   {
2124     require(_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
2125 
2126     /*
2127      *  i = investment, p = price, t = number of tokens
2128      *
2129      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
2130      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
2131      *
2132      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
2133      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
2134      */
2135 
2136     // First, separate out the sell into two segments:
2137     //  1) the amount of tokens selling at the ICO price.
2138     //  2) the amount of tokens selling at the variable (pyramid) price
2139     uint tokensToSellAtICOPrice = 0;
2140     uint tokensToSellAtVariablePrice = 0;
2141 
2142     if (tokenSupply <= tokensMintedDuringICO) {
2143       // Option One: All the tokens sell at the ICO price.
2144       tokensToSellAtICOPrice = _tokens;
2145 
2146     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
2147       // Option Two: All the tokens sell at the variable price.
2148       tokensToSellAtVariablePrice = _tokens;
2149 
2150     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
2151       // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
2152       tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
2153       tokensToSellAtICOPrice = _tokens.sub(tokensToSellAtVariablePrice);
2154 
2155     } else {
2156       // Option Four: Should be impossible, and the compiler should optimize it out of existence.
2157       revert();
2158     }
2159 
2160     // Sanity check:
2161     assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
2162 
2163     // Track how much Ether we get from selling at each price function:
2164     uint ethFromICOPriceTokens;
2165     uint ethFromVarPriceTokens;
2166 
2167     // Now, actually calculate:
2168 
2169     if (tokensToSellAtICOPrice != 0) {
2170 
2171       /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
2172          we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
2173          We need to divide by 1e18 or we'll have too much Ether. */
2174 
2175       ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
2176     }
2177 
2178     if (tokensToSellAtVariablePrice != 0) {
2179 
2180       /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
2181          This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
2182          Thus there isn't any weird stuff going on with the token supply.
2183 
2184          We have the equations for total investment above; note that this is for TOTAL.
2185          To get the eth received from this sell, we calculate the new total investment after this sell.
2186          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
2187 
2188       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
2189       uint investmentAfter = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
2190 
2191       ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
2192     }
2193 
2194     uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
2195 
2196     assert(totalEthReceived > 0);
2197     return totalEthReceived;
2198   }
2199 
2200   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
2201   internal
2202   {
2203     require(regularPhase);
2204     require(_toAddress != address(0x0));
2205     address _customerAddress = _from;
2206     uint _amountOfFrontEndTokens = _amountOfTokens;
2207 
2208     // Withdraw all outstanding dividends first (including those generated from referrals).
2209     if (theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
2210 
2211     // Calculate how many back-end dividend tokens to transfer.
2212     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
2213     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
2214 
2215     if (_customerAddress != msg.sender) {
2216       // Update the allowed balance.
2217       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
2218       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
2219     }
2220 
2221     // Exchange tokens
2222     frontTokenBalanceLedger_[_customerAddress] = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
2223     frontTokenBalanceLedger_[_toAddress] = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
2224     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
2225     dividendTokenBalanceLedger_[_toAddress] = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
2226 
2227     // Recipient inherits dividend percentage if they have not already selected one.
2228     if (!userSelectedRate[_toAddress])
2229     {
2230       userSelectedRate[_toAddress] = true;
2231       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
2232     }
2233 
2234     // Update dividend trackers
2235     payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
2236     payoutsTo_[_toAddress] += (int256) (profitPerDivToken * _amountOfDivTokens);
2237 
2238     uint length;
2239 
2240     assembly {
2241       length := extcodesize(_toAddress)
2242     }
2243 
2244     if (length > 0) {
2245       // its a contract
2246       // note: at ethereum update ALL addresses are contracts
2247       ERC223Receiving receiver = ERC223Receiving(_toAddress);
2248       receiver.tokenFallback(_from, _amountOfTokens, _data);
2249     }
2250 
2251     // Fire logging event.
2252     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
2253   }
2254 
2255   // Called from transferFrom. Always checks if _customerAddress has dividends.
2256   function withdrawFrom(address _customerAddress)
2257   internal
2258   {
2259     // Setup data
2260     uint _dividends = theDividendsOf(false, _customerAddress);
2261 
2262     // update dividend tracker
2263     payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
2264 
2265     // add ref. bonus
2266     _dividends += referralBalance_[_customerAddress];
2267     referralBalance_[_customerAddress] = 0;
2268 
2269     _customerAddress.transfer(_dividends);
2270 
2271     // Fire logging event.
2272     emit onWithdraw(_customerAddress, _dividends);
2273   }
2274 
2275 
2276   /*=======================
2277    =    RESET FUNCTIONS   =
2278    ======================*/
2279 
2280   function injectEther()
2281   public
2282   payable
2283   onlyAdministrator
2284   {
2285 
2286   }
2287 
2288   /*=======================
2289    =   MATHS FUNCTIONS    =
2290    ======================*/
2291 
2292   function toPowerOfThreeHalves(uint x) public pure returns (uint) {
2293     // m = 3, n = 2
2294     // sqrt(x^3)
2295     return sqrt(x ** 3);
2296   }
2297 
2298   function toPowerOfTwoThirds(uint x) public pure returns (uint) {
2299     // m = 2, n = 3
2300     // cbrt(x^2)
2301     return cbrt(x ** 2);
2302   }
2303 
2304   function sqrt(uint x) public pure returns (uint y) {
2305     uint z = (x + 1) / 2;
2306     y = x;
2307     while (z < y) {
2308       y = z;
2309       z = (x / z + z) / 2;
2310     }
2311   }
2312 
2313   function cbrt(uint x) public pure returns (uint y) {
2314     uint z = (x + 1) / 3;
2315     y = x;
2316     while (z < y) {
2317       y = z;
2318       z = (x / (z * z) + 2 * z) / 3;
2319     }
2320   }
2321 }
2322 
2323 /*=======================
2324  =     INTERFACES       =
2325  ======================*/
2326 
2327 contract ZethrBankroll {
2328   function receiveDividends() public payable {}
2329 }
2330 
2331 // File: contracts/Games/JackpotHolding.sol
2332 
2333 /*
2334 *
2335 * Jackpot holding contract.
2336 *  
2337 * This accepts token payouts from a game for every player loss,
2338 * and on a win, pays out *half* of the jackpot to the winner.
2339 *
2340 * Jackpot payout should only be called from the game.
2341 *
2342 */
2343 contract JackpotHolding is ERC223Receiving {
2344 
2345   /****************************
2346    * FIELDS
2347    ****************************/
2348 
2349   // How many times we've paid out the jackpot
2350   uint public payOutNumber = 0;
2351 
2352   // The amount to divide the token balance by for a pay out (defaults to half the token balance)
2353   uint public payOutDivisor = 2;
2354 
2355   // Holds the bankroll controller info
2356   ZethrBankrollControllerInterface controller;
2357 
2358   // Zethr contract
2359   Zethr zethr;
2360 
2361   /****************************
2362    * CONSTRUCTOR
2363    ****************************/
2364 
2365   constructor (address _controllerAddress, address _zethrAddress) public {
2366     controller = ZethrBankrollControllerInterface(_controllerAddress);
2367     zethr = Zethr(_zethrAddress);
2368   }
2369 
2370   function() public payable {}
2371 
2372   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes/*_data*/)
2373   public
2374   returns (bool)
2375   {
2376     // Do nothing, we can track the jackpot by this balance
2377   }
2378 
2379   /****************************
2380    * VIEWS
2381    ****************************/
2382   function getJackpotBalance()
2383   public view
2384   returns (uint)
2385   {
2386     // Half of this balance + half of jackpotBalance in each token bankroll
2387     uint tempBalance;
2388 
2389     for (uint i=0; i<7; i++) {
2390       tempBalance += controller.tokenBankrolls(i).jackpotBalance() > 0 ? controller.tokenBankrolls(i).jackpotBalance() / payOutDivisor : 0;
2391     }
2392 
2393     tempBalance += zethr.balanceOf(address(this)) > 0 ? zethr.balanceOf(address(this)) / payOutDivisor : 0;
2394 
2395     return tempBalance;
2396   }
2397 
2398   /****************************
2399    * OWNER FUNCTIONS
2400    ****************************/
2401 
2402   /** @dev Sets the pay out divisor
2403     * @param _divisor The value to set the new divisor to
2404     */
2405   function ownerSetPayOutDivisor(uint _divisor)
2406   public
2407   ownerOnly
2408   {
2409     require(_divisor != 0);
2410 
2411     payOutDivisor = _divisor;
2412   }
2413 
2414   /** @dev Sets the address of the game controller
2415     * @param _controllerAddress The new address of the controller
2416     */
2417   function ownerSetControllerAddress(address _controllerAddress)
2418   public
2419   ownerOnly
2420   {
2421     controller = ZethrBankrollControllerInterface(_controllerAddress);
2422   }
2423 
2424   /** @dev Transfers the jackpot to _to
2425     * @param _to Address to send the jackpot tokens to
2426     */
2427   function ownerWithdrawZth(address _to)
2428   public
2429   ownerOnly
2430   {
2431     uint balance = zethr.balanceOf(address(this));
2432     zethr.transfer(_to, balance);
2433   }
2434 
2435   /** @dev Transfers any ETH received from dividends to _to
2436     * @param _to Address to send the ETH to
2437     */
2438   function ownerWithdrawEth(address _to)
2439   public
2440   ownerOnly
2441   {
2442     _to.transfer(address(this).balance);
2443   }
2444 
2445   /****************************
2446    * GAME FUNCTIONS
2447    ****************************/
2448 
2449   function gamePayOutWinner(address _winner)
2450   public
2451   gameOnly
2452   {
2453     // Call the payout function on all 7 token bankrolls
2454     for (uint i=0; i<7; i++) {
2455       controller.tokenBankrolls(i).payJackpotToWinner(_winner, payOutDivisor);
2456     }
2457 
2458     uint payOutAmount;
2459 
2460     // Calculate pay out & pay out
2461     if (zethr.balanceOf(address(this)) >= 1e10) {
2462       payOutAmount = zethr.balanceOf(address(this)) / payOutDivisor;
2463     }
2464 
2465     if (payOutAmount >= 1e10) {
2466       zethr.transfer(_winner, payOutAmount);
2467     }
2468 
2469     // Increment the statistics fields
2470     payOutNumber += 1;
2471 
2472     // Emit jackpot event
2473     emit JackpotPayOut(_winner, payOutNumber);
2474   }
2475 
2476   /****************************
2477    * EVENTS
2478    ****************************/
2479 
2480   event JackpotPayOut(
2481     address winner,
2482     uint payOutNumber
2483   );
2484 
2485   /****************************
2486    * MODIFIERS
2487    ****************************/
2488 
2489   // Only an owner can call this method (controller is always an owner)
2490   modifier ownerOnly()
2491   {
2492     require(msg.sender == address(controller) || controller.multiSigWallet().isOwner(msg.sender));
2493     _;
2494   }
2495 
2496   // Only a game can call this method
2497   modifier gameOnly()
2498   {
2499     require(controller.validGameAddresses(msg.sender));
2500     _;
2501   }
2502 }
2503 
2504 // File: contracts/Bankroll/ZethrGame.sol
2505 
2506 /* Zethr Game Interface
2507  *
2508  * Contains the necessary functions to integrate with
2509  * the Zethr Token bankrolls & the Zethr game ecosystem.
2510  *
2511  * Token Bankroll Functions:
2512  *  - execute
2513  *
2514  * Player Functions:
2515  *  - finish
2516  *
2517  * Bankroll Controller / Owner Functions:
2518  *  - pauseGame
2519  *  - resumeGame
2520  *  - set resolver percentage
2521  *  - set controller address
2522  *
2523  * Player/Token Bankroll Functions:
2524  *  - resolvePendingBets
2525 */
2526 contract ZethrGame {
2527   using SafeMath for uint;
2528   using SafeMath for uint56;
2529 
2530   // Default events:
2531   event Result (address player, uint amountWagered, int amountOffset);
2532   event Wager (address player, uint amount, bytes data);
2533 
2534   // Queue of pending/unresolved bets
2535   address[] pendingBetsQueue;
2536   uint queueHead = 0;
2537   uint queueTail = 0;
2538 
2539   // Store each player's latest bet via mapping
2540   mapping(address => BetBase) bets;
2541 
2542   // Bet structures must start with this layout
2543   struct BetBase {
2544     // Must contain these in this order
2545     uint56 tokenValue;    // Multiply by 1e14 to get tokens
2546     uint48 blockNumber;
2547     uint8 tier;
2548     // Game specific structures can add more after this
2549   }
2550 
2551   // Mapping of addresses to their *position* in the queue
2552   // Zero = they aren't in the queue
2553   mapping(address => uint) pendingBetsMapping;
2554 
2555   // Holds the bankroll controller info
2556   ZethrBankrollControllerInterface controller;
2557 
2558   // Is the game paused?
2559   bool paused;
2560 
2561   // Minimum bet should always be >= 1
2562   uint minBet = 1e18;
2563 
2564   // Percentage that a resolver gets when he resolves bets for the house
2565   uint resolverPercentage;
2566 
2567   // Every game has a name
2568   string gameName;
2569 
2570   constructor (address _controllerAddress, uint _resolverPercentage, string _name) public {
2571     controller = ZethrBankrollControllerInterface(_controllerAddress);
2572     resolverPercentage = _resolverPercentage;
2573     gameName = _name;
2574   }
2575 
2576   /** @dev Gets the max profit of this game as decided by the token bankroll
2577     * @return uint The maximum profit
2578     */
2579   function getMaxProfit()
2580   public view
2581   returns (uint)
2582   {
2583     return ZethrTokenBankrollInterface(msg.sender).getMaxProfit(address(this));
2584   }
2585 
2586   /** @dev Pauses the game, preventing anyone from placing bets
2587     */
2588   function ownerPauseGame()
2589   public
2590   ownerOnly
2591   {
2592     paused = true;
2593   }
2594 
2595   /** @dev Resumes the game, allowing bets
2596     */
2597   function ownerResumeGame()
2598   public
2599   ownerOnly
2600   {
2601     paused = false;
2602   }
2603 
2604   /** @dev Sets the percentage of the bets that a resolver gets when resolving tokens.
2605     * @param _percentage The percentage as x/1,000,000 that the resolver gets
2606     */
2607   function ownerSetResolverPercentage(uint _percentage)
2608   public
2609   ownerOnly
2610   {
2611     require(_percentage <= 1000000);
2612     resolverPercentage = _percentage;
2613   }
2614 
2615   /** @dev Sets the address of the game controller
2616     * @param _controllerAddress The new address of the controller
2617     */
2618   function ownerSetControllerAddress(address _controllerAddress)
2619   public
2620   ownerOnly
2621   {
2622     controller = ZethrBankrollControllerInterface(_controllerAddress);
2623   }
2624 
2625   // Every game should have a name
2626   /** @dev Sets the name of the game
2627     * @param _name The name of the game
2628     */
2629   function ownerSetGameName(string _name)
2630   ownerOnly
2631   public
2632   {
2633     gameName = _name;
2634   }
2635 
2636   /** @dev Gets the game name
2637     * @return The name of the game
2638     */
2639   function getGameName()
2640   public view
2641   returns (string)
2642   {
2643     return gameName;
2644   }
2645 
2646   /** @dev Resolve expired bets in the queue. Gives a percentage of the house edge to the resolver as ZTH
2647     * @param _numToResolve The number of bets to resolve.
2648     * @return tokensEarned The number of tokens earned
2649     * @return queueHead The new head of the queue
2650     */
2651   function resolveExpiredBets(uint _numToResolve)
2652   public
2653   returns (uint tokensEarned_, uint queueHead_)
2654   {
2655     uint mQueue = queueHead;
2656     uint head;
2657     uint tail = (mQueue + _numToResolve) > pendingBetsQueue.length ? pendingBetsQueue.length : (mQueue + _numToResolve);
2658     uint tokensEarned = 0;
2659 
2660     for (head = mQueue; head < tail; head++) {
2661       // Check the head of the queue to see if there is a resolvable bet
2662       // This means the bet at the queue head is older than 255 blocks AND is not 0
2663       // (However, if the address at the head is null, skip it, it's already been resolved)
2664       if (pendingBetsQueue[head] == address(0x0)) {
2665         continue;
2666       }
2667 
2668       if (bets[pendingBetsQueue[head]].blockNumber != 0 && block.number > 256 + bets[pendingBetsQueue[head]].blockNumber) {
2669         // Resolve the bet
2670         // finishBetfrom returns the *player* profit
2671         // this will be negative if the player lost and the house won
2672         // so flip it to get the house profit, if any
2673         int sum = - finishBetFrom(pendingBetsQueue[head]);
2674 
2675         // Tokens earned is a percentage of the loss
2676         if (sum > 0) {
2677           tokensEarned += (uint(sum).mul(resolverPercentage)).div(1000000);
2678         }
2679 
2680         // Queue-tail is always the "next" open spot, so queue head and tail will never overlap
2681       } else {
2682         // If we can't resolve a bet, stop going down the queue
2683         break;
2684       }
2685     }
2686 
2687     queueHead = head;
2688 
2689     // Send the earned tokens to the resolver
2690     if (tokensEarned >= 1e14) {
2691       controller.gamePayoutResolver(msg.sender, tokensEarned);
2692     }
2693 
2694     return (tokensEarned, head);
2695   }
2696 
2697   /** @dev Finishes the bet of the sender, if it exists.
2698     * @return int The total profit (positive or negative) earned by the sender
2699     */
2700   function finishBet()
2701   public
2702   hasNotBetThisBlock(msg.sender)
2703   returns (int)
2704   {
2705     return finishBetFrom(msg.sender);
2706   }
2707 
2708   /** @dev Resturns a random number
2709     * @param _blockn The block number to base the random number off of
2710     * @param _entropy Data to use in the random generation
2711     * @param _index Data to use in the random generation
2712     * @return randomNumber The random number to return
2713     */
2714   function maxRandom(uint _blockn, address _entropy, uint _index)
2715   private view
2716   returns (uint256 randomNumber)
2717   {
2718     return uint256(keccak256(
2719         abi.encodePacked(
2720           blockhash(_blockn),
2721           _entropy,
2722           _index
2723         )));
2724   }
2725 
2726   /** @dev Returns a random number
2727     * @param _upper The upper end of the range, exclusive
2728     * @param _blockn The block number to use for the random number
2729     * @param _entropy An address to be used for entropy
2730     * @param _index A number to get the next random number
2731     * @return randomNumber The random number
2732     */
2733   function random(uint256 _upper, uint256 _blockn, address _entropy, uint _index)
2734   internal view
2735   returns (uint256 randomNumber)
2736   {
2737     return maxRandom(_blockn, _entropy, _index) % _upper;
2738   }
2739 
2740   // Prevents the user from placing two bets in one block
2741   modifier hasNotBetThisBlock(address _sender)
2742   {
2743     require(bets[_sender].blockNumber != block.number);
2744     _;
2745   }
2746 
2747   // Requires that msg.sender is one of the token bankrolls
2748   modifier bankrollOnly {
2749     require(controller.isTokenBankroll(msg.sender));
2750     _;
2751   }
2752 
2753   // Requires that the game is not paused
2754   modifier isNotPaused {
2755     require(!paused);
2756     _;
2757   }
2758 
2759   // Requires that the bet given has max profit low enough
2760   modifier betIsValid(uint _betSize, uint _tier, bytes _data) {
2761     uint divRate = ZethrTierLibrary.getDivRate(_tier);
2762     require(isBetValid(_betSize, divRate, _data));
2763     _;
2764   }
2765 
2766   // Only an owner can call this method (controller is always an owner)
2767   modifier ownerOnly()
2768   {
2769     require(msg.sender == address(controller) || controller.multiSigWallet().isOwner(msg.sender));
2770     _;
2771   }
2772 
2773   /** @dev Places a bet. Callable only by token bankrolls
2774     * @param _player The player that is placing the bet
2775     * @param _tokenCount The total number of tokens bet
2776     * @param _divRate The dividend rate of the player
2777     * @param _data The game-specific data, encoded in bytes-form
2778     */
2779   function execute(address _player, uint _tokenCount, uint _divRate, bytes _data) public;
2780 
2781   /** @dev Resolves the bet of the supplied player.
2782     * @param _playerAddress The address of the player whos bet we are resolving
2783     * @return int The total profit the player earned, positive or negative
2784     */
2785   function finishBetFrom(address _playerAddress) internal returns (int);
2786 
2787   /** @dev Determines if a supplied bet is valid
2788     * @param _tokenCount The total number of tokens bet
2789     * @param _divRate The dividend rate of the bet
2790     * @param _data The game-specific bet data
2791     * @return bool Whether or not the bet is valid
2792     */
2793   function isBetValid(uint _tokenCount, uint _divRate, bytes _data) public view returns (bool);
2794 }
2795 
2796 // File: contracts/Games/ZethrSlots.sol
2797 
2798 /* The actual game contract.
2799  *
2800  * This contract contains the actual game logic,
2801  * including placing bets (execute), resolving bets,
2802  * and resolving expired bets.
2803 */
2804 contract ZethrSlots is ZethrGame {
2805 
2806   /****************************
2807    * GAME SPECIFIC
2808    ****************************/
2809 
2810   // Slots-specific bet structure
2811   struct Bet {
2812     // Must contain these in this order
2813     uint56 tokenValue;
2814     uint48 blockNumber;
2815     uint8 tier;
2816     // Game specific
2817     uint8 numSpins;
2818   }
2819 
2820   /****************************
2821    * FIELDS
2822    ****************************/
2823 
2824   // Sections with identical multipliers compressed for optimization
2825   uint[14] MULTIPLIER_BOUNDARIES = [uint(299), 3128, 44627, 46627, 49127, 51627, 53127, 82530, 150423, 310818, 364283, 417748, 471213, ~uint256(0)];
2826 
2827   // Maps indexes of results sections to multipliers as x/100
2828   uint[14] MULTIPLIERS = [uint(5000), 2000, 300, 1100, 750, 900, 1300, 250, 150, 100, 200, 125, 133, 250];
2829 
2830   // The holding contract for jackpot tokens
2831   JackpotHolding public jackpotHoldingContract;
2832 
2833   /****************************
2834    * CONSTRUCTOR
2835    ****************************/
2836 
2837   constructor (address _controllerAddress, uint _resolverPercentage, string _name)
2838   ZethrGame(_controllerAddress, _resolverPercentage, _name)
2839   public
2840   {
2841   }
2842 
2843   /****************************
2844    * USER METHODS
2845    ****************************/
2846 
2847   /** @dev Retrieve the results of the last spin of a plyer, for web3 calls.
2848     * @param _playerAddress The address of the player
2849     */
2850   function getLastSpinOutput(address _playerAddress)
2851   public view
2852   returns (uint winAmount, uint lossAmount, uint jackpotAmount, uint jackpotWins, uint[] memory output)
2853   {
2854     // Cast to Bet and read from storage
2855     Bet storage playerBetInStorage = getBet(_playerAddress);
2856     Bet memory playerBet = playerBetInStorage;
2857 
2858     // Safety check
2859     require(playerBet.blockNumber != 0);
2860 
2861     (winAmount, lossAmount, jackpotAmount, jackpotWins, output) = getSpinOutput(playerBet.blockNumber, playerBet.numSpins, playerBet.tokenValue.mul(1e14), _playerAddress);
2862 
2863     return (winAmount, lossAmount, jackpotAmount, jackpotWins, output);
2864   }
2865     
2866     event SlotsResult(
2867         uint    _blockNumber,
2868         address _target,
2869         uint    _numSpins,
2870         uint    _tokenValue,
2871         uint    _winAmount,
2872         uint    _lossAmount,
2873         uint[]  _output
2874     );
2875     
2876   /** @dev Retrieve the results of the spin, for web3 calls.
2877     * @param _blockNumber The block number of the spin
2878     * @param _numSpins The number of spins of this bet
2879     * @param _tokenValue The total number of tokens bet
2880     * @param _target The address of the better
2881     * @return winAmount The total number of tokens won
2882     * @return lossAmount The total number of tokens lost
2883     * @return jackpotAmount The total amount of tokens won in the jackpot
2884     * @return output An array of all of the results of a multispin
2885     */
2886   function getSpinOutput(uint _blockNumber, uint _numSpins, uint _tokenValue, address _target)
2887   public view
2888   returns (uint winAmount, uint lossAmount, uint jackpotAmount, uint jackpotWins, uint[] memory output)
2889   {
2890     output = new uint[](_numSpins);
2891     // Where the result sections start and stop
2892 
2893     // If current block for the first spin is older than 255 blocks, ALL spins are losses
2894     if (block.number - _blockNumber > 255) {
2895       // Output stays 0 for eveything, this is a loss
2896       // No jackpot wins
2897       // No wins
2898       // Loss is the total tokens bet
2899       lossAmount = (_tokenValue.mul(_numSpins).mul(99)).div(100);
2900       jackpotAmount = _tokenValue.mul(_numSpins).div(100);
2901     } else {
2902 
2903       for (uint i = 0; i < _numSpins; i++) {
2904         // Store the output
2905         output[i] = random(1000000, _blockNumber, _target, i) + 1;
2906 
2907         if (output[i] < 2) {
2908           // Jackpot get
2909           jackpotWins++;
2910           lossAmount += _tokenValue;
2911         } else if (output[i] > 506856) {
2912           // Player loss
2913           lossAmount += (_tokenValue.mul(99)).div(100);
2914           jackpotAmount += _tokenValue.div(100);
2915         } else {
2916           // Player win
2917 
2918           // Iterate over the array of win results to find the correct multiplier array index
2919           uint index;
2920           for (index = 0; index < MULTIPLIER_BOUNDARIES.length; index++) {
2921             if (output[i] < MULTIPLIER_BOUNDARIES[index]) break;
2922           }
2923           // Use index to find the correct multipliers
2924           winAmount += _tokenValue.mul(MULTIPLIERS[index]).div(100);
2925         }
2926       }
2927     }
2928     emit SlotsResult(_blockNumber, _target, _numSpins, _tokenValue, winAmount, lossAmount, output);
2929     return (winAmount, lossAmount, jackpotAmount, jackpotWins, output);
2930   }
2931 
2932   /** @dev Retrieve the results of the spin, for contract calls.
2933     * @param _blockNumber The block number of the spin
2934     * @param _numSpins The number of spins of this bet
2935     * @param _tokenValue The total number of tokens bet
2936     * @param _target The address of the better
2937     * @return winAmount The total number of tokens won
2938     * @return lossAmount The total number of tokens lost
2939     * @return jackpotAmount The total amount of tokens won in the jackpot
2940     */
2941   function getSpinResults(uint _blockNumber, uint _numSpins, uint _tokenValue, address _target)
2942   public
2943   returns (uint winAmount, uint lossAmount, uint jackpotAmount, uint jackpotWins)
2944   {
2945     // Where the result sections start and stop
2946 
2947     // If current block for the first spin is older than 255 blocks, ALL spins are losses
2948     if (block.number - _blockNumber > 255) {
2949       // Output stays 0 for eveything, this is a loss
2950       // No jackpot wins
2951       // No wins
2952       // Loss is the total tokens bet
2953       lossAmount = (_tokenValue.mul(_numSpins).mul(99)).div(100);
2954       jackpotAmount = _tokenValue.mul(_numSpins).div(100);
2955     } else {
2956 
2957       uint result;
2958 
2959       for (uint i = 0; i < _numSpins; i++) {
2960         // Store the output
2961         result = random(1000000, _blockNumber, _target, i) + 1;
2962 
2963         if (result < 2) {
2964           // Jackpot get
2965           jackpotWins++;
2966         } else if (result > 506856) {
2967           // Player loss
2968           lossAmount += (_tokenValue.mul(99)).div(100);
2969           jackpotAmount += _tokenValue.div(100);
2970         } else {
2971           // Player win
2972 
2973           // Iterate over the array of win results to find the correct multiplier array index
2974           uint index;
2975           for (index = 0; index < MULTIPLIER_BOUNDARIES.length; index++) {
2976             if (result < MULTIPLIER_BOUNDARIES[index]) break;
2977           }
2978           // Use index to find the correct multipliers
2979           winAmount += _tokenValue.mul(MULTIPLIERS[index]).div(100);
2980         }
2981       }
2982     }
2983     return (winAmount, lossAmount, jackpotAmount, jackpotWins);
2984   }
2985 
2986   /****************************
2987    * OWNER METHODS
2988    ****************************/
2989 
2990   /** @dev Set the address of the jackpot contract
2991     * @param _jackpotAddress The address of the jackpot contract
2992     */
2993   function ownerSetJackpotAddress(address _jackpotAddress)
2994   public
2995   ownerOnly
2996   {
2997     jackpotHoldingContract = JackpotHolding(_jackpotAddress);
2998   }
2999 
3000   /****************************
3001    * INTERNALS
3002    ****************************/
3003 
3004   /** @dev Returs the bet struct of a player
3005     * @param _playerAddress The address of the player
3006     * @return Bet The bet of the player
3007     */
3008   function getBet(address _playerAddress)
3009   internal view
3010   returns (Bet storage)
3011   {
3012     // Cast BetBase to Bet
3013     BetBase storage betBase = bets[_playerAddress];
3014 
3015     Bet storage playerBet;
3016     assembly {
3017     // tmp is pushed onto stack and points to betBase slot in storage
3018       let tmp := betBase_slot
3019 
3020     // swap1 swaps tmp and playerBet pointers
3021       swap1
3022     }
3023     // tmp is popped off the stack
3024 
3025     // playerBet now points to betBase
3026     return playerBet;
3027   }
3028 
3029   /** @dev Resturns a random number
3030     * @param _blockn The block number to base the random number off of
3031     * @param _entropy Data to use in the random generation
3032     * @param _index Data to use in the random generation
3033     * @return randomNumber The random number to return
3034     */
3035   function maxRandom(uint _blockn, address _entropy, uint _index)
3036   private view
3037   returns (uint256 randomNumber)
3038   {
3039     return uint256(keccak256(
3040         abi.encodePacked(
3041           blockhash(_blockn),
3042           _entropy,
3043           _index
3044         )));
3045   }
3046 
3047   /** @dev Returns a random number
3048     * @param _upper The upper end of the range, exclusive
3049     * @param _blockn The block number to use for the random number
3050     * @param _entropy An address to be used for entropy
3051     * @param _index A number to get the next random number
3052     * @return randomNumber The random number
3053     */
3054   function random(uint256 _upper, uint256 _blockn, address _entropy, uint _index)
3055   internal view
3056   returns (uint256 randomNumber)
3057   {
3058     return maxRandom(_blockn, _entropy, _index) % _upper;
3059   }
3060 
3061   /****************************
3062    * OVERRIDDEN METHODS
3063    ****************************/
3064 
3065   /** @dev Resolves the bet of the supplied player.
3066     * @param _playerAddress The address of the player whos bet we are resolving
3067     * @return totalProfit The total profit the player earned, positive or negative
3068     */
3069   function finishBetFrom(address _playerAddress)
3070   internal
3071   returns (int /*totalProfit*/)
3072   {
3073     // Memory vars to hold data as we compute it
3074     uint winAmount;
3075     uint lossAmount;
3076     uint jackpotAmount;
3077     uint jackpotWins;
3078 
3079     // Cast to Bet and read from storage
3080     Bet storage playerBetInStorage = getBet(_playerAddress);
3081     Bet memory playerBet = playerBetInStorage;
3082 
3083     // Player should not be able to resolve twice!
3084     require(playerBet.blockNumber != 0);
3085 
3086     // Safety check
3087     require(playerBet.blockNumber != 0);
3088     playerBetInStorage.blockNumber = 0;
3089 
3090     // Iterate over the number of spins and calculate totals:
3091     //  - player win amount
3092     //  - bankroll win amount
3093     //  - jackpot wins
3094     (winAmount, lossAmount, jackpotAmount, jackpotWins) = getSpinResults(playerBet.blockNumber, playerBet.numSpins, playerBet.tokenValue.mul(1e14), _playerAddress);
3095 
3096     // Figure out the token bankroll address
3097     address tokenBankrollAddress = controller.getTokenBankrollAddressFromTier(playerBet.tier);
3098     ZethrTokenBankrollInterface bankroll = ZethrTokenBankrollInterface(tokenBankrollAddress);
3099 
3100     // Call into the bankroll to do some token accounting
3101     bankroll.gameTokenResolution(winAmount, _playerAddress, jackpotAmount, address(jackpotHoldingContract), playerBet.tokenValue.mul(1e14).mul(playerBet.numSpins));
3102 
3103     // Pay out jackpot if won
3104     if (jackpotWins > 0) {
3105       for (uint x = 0; x < jackpotWins; x++) {
3106         jackpotHoldingContract.gamePayOutWinner(_playerAddress);
3107       }
3108     }
3109 
3110     // Grab the position of the player in the pending bets queue
3111     uint index = pendingBetsMapping[_playerAddress];
3112 
3113     // Remove the player from the pending bets queue by setting the address to 0x0
3114     pendingBetsQueue[index] = address(0x0);
3115 
3116     // Delete the player's bet by setting the mapping to zero
3117     pendingBetsMapping[_playerAddress] = 0;
3118 
3119     emit Result(_playerAddress, playerBet.tokenValue.mul(1e14), int(winAmount) - int(lossAmount) - int(jackpotAmount));
3120 
3121     // Return all bet results + total *player* profit
3122     return (int(winAmount) - int(lossAmount) - int(jackpotAmount));
3123   }
3124 
3125   /** @dev Places a bet. Callable only by token bankrolls
3126     * @param _player The player that is placing the bet
3127     * @param _tokenCount The total number of tokens bet
3128     * @param _tier The div rate tier the player falls in
3129     * @param _data The game-specific data, encoded in bytes-form
3130     */
3131   function execute(address _player, uint _tokenCount, uint _tier, bytes _data)
3132   isNotPaused
3133   bankrollOnly
3134   betIsValid(_tokenCount, _tier, _data)
3135   hasNotBetThisBlock(_player)
3136   public
3137   {
3138     Bet storage playerBet = getBet(_player);
3139 
3140     // Check for a player bet and resolve if necessary
3141     if (playerBet.blockNumber != 0) {
3142       finishBetFrom(_player);
3143     }
3144 
3145     uint8 spins = uint8(_data[0]);
3146 
3147     // Set bet information
3148     playerBet.tokenValue = uint56(_tokenCount.div(spins).div(1e14));
3149     playerBet.blockNumber = uint48(block.number);
3150     playerBet.tier = uint8(_tier);
3151     playerBet.numSpins = spins;
3152 
3153     // Add player to the pending bets queue
3154     pendingBetsQueue.length++;
3155     pendingBetsQueue[queueTail] = _player;
3156     queueTail++;
3157 
3158     // Add the player's position in the queue to the pending bets mapping
3159     pendingBetsMapping[_player] = queueTail - 1;
3160 
3161     // Emit event
3162     emit Wager(_player, _tokenCount, _data);
3163   }
3164 
3165   /** @dev Determines if a supplied bet is valid
3166     * @param _tokenCount The total number of tokens bet
3167     * @param _data The game-specific bet data
3168     * @return bool Whether or not the bet is valid
3169     */
3170   function isBetValid(uint _tokenCount, uint /*_divRate*/, bytes _data)
3171   public view
3172   returns (bool)
3173   {
3174     // Since the max win is 50x (for slots), the bet size must be
3175     // <= 1/50 * the maximum profit.
3176     uint8 spins = uint8(_data[0]);
3177     return (_tokenCount.div(spins).mul(50) <= getMaxProfit()) && (_tokenCount.div(spins) >= minBet);
3178   }
3179 }
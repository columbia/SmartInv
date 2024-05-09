1 /******************************************************************************\
2 
3 file:   RegBase.sol
4 ver:    0.2.1
5 updated:9-May-2017
6 author: Darryl Morris (o0ragman0o)
7 email:  o0ragman0o AT gmail.com
8 
9 This file is part of the SandalStraps framework
10 
11 `RegBase` provides an inheriting contract the minimal API to be compliant with 
12 `Registrar`.  It includes a set-once, `bytes32 public regName` which is refered
13 to by `Registrar` lookups.
14 
15 An owner updatable `address public owner` state variable is also provided and is
16 required by `Factory.createNew()`.
17 
18 This software is distributed in the hope that it will be useful,
19 but WITHOUT ANY WARRANTY; without even the implied warranty of
20 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
21 See MIT Licence for further details.
22 <https://opensource.org/licenses/MIT>.
23 
24 \******************************************************************************/
25 
26 pragma solidity ^0.4.10;
27 
28 contract RegBase
29 {
30 //
31 // Constants
32 //
33 
34     bytes32 constant public VERSION = "RegBase v0.2.1";
35 
36 //
37 // State Variables
38 //
39     
40     /// @dev A static identifier, set in the constructor and used for registrar
41     /// lookup
42     /// @return Registrar name SandalStraps registrars
43     bytes32 public regName;
44 
45     /// @dev An general purpose resource such as short text or a key to a
46     /// string in a StringsMap
47     /// @return resource
48     bytes32 public resource;
49     
50     /// @dev An address permissioned to enact owner restricted functions
51     /// @return owner
52     address public owner;
53 
54 //
55 // Events
56 //
57 
58     // Triggered on change of owner address
59     event ChangedOwner(address indexed oldOwner, address indexed newOwner);
60 
61     // Triggered on change of resource
62     event ChangedResource(bytes32 indexed resource);
63 
64 //
65 // Modifiers
66 //
67 
68     // Permits only the owner
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74 //
75 // Functions
76 //
77 
78     /// @param _creator The calling address passed through by a factory,
79     /// typically msg.sender
80     /// @param _regName A static name referenced by a Registrar
81     /// @param _owner optional owner address if creator is not the intended
82     /// owner
83     /// @dev On 0x0 value for owner, ownership precedence is:
84     /// `_owner` else `_creator` else msg.sender
85     function RegBase(address _creator, bytes32 _regName, address _owner)
86     {
87         regName = _regName;
88         owner = _owner != 0x0 ? _owner : 
89                 _creator != 0x0 ? _creator : msg.sender;
90     }
91     
92     /// @notice Will selfdestruct the contract
93     function destroy()
94         public
95         onlyOwner
96     {
97         selfdestruct(msg.sender);
98     }
99     
100     /// @notice Change the owner to `_owner`
101     /// @param _owner The address to which ownership is transfered
102     function changeOwner(address _owner)
103         public
104         onlyOwner
105         returns (bool)
106     {
107         ChangedOwner(owner, _owner);
108         owner = _owner;
109         return true;
110     }
111 
112     /// @notice Change the resource to `_resource`
113     /// @param _resource A key or short text to be stored as the resource.
114     function changeResource(bytes32 _resource)
115         public
116         onlyOwner
117         returns (bool)
118     {
119         resource = _resource;
120         ChangedResource(_resource);
121         return true;
122     }
123 }
124 
125 /******************************************************************************\
126 
127 file:   Factory.sol
128 ver:    0.2.1
129 updated:9-May-2017
130 author: Darryl Morris (o0ragman0o)
131 email:  o0ragman0o AT gmail.com
132 
133 This file is part of the SandalStraps framework
134 
135 Factories are a core but independant concept of the SandalStraps framework and 
136 can be used to create SandalStraps compliant 'product' contracts from embed
137 bytecode.
138 
139 The abstract Factory contract is to be used as a SandalStraps compliant base for
140 product specific factories which must impliment the createNew() function.
141 
142 is itself compliant with `Registrar` by inhereting `RegBase` and
143 compiant with `Factory` through the `createNew(bytes32 _name, address _owner)`
144 API.
145 
146 An optional creation fee can be set and manually collected by the owner.
147 
148 This software is distributed in the hope that it will be useful,
149 but WITHOUT ANY WARRANTY; without even the implied warranty of
150 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
151 See MIT Licence for further details.
152 <https://opensource.org/licenses/MIT>.
153 
154 \******************************************************************************/
155 
156 pragma solidity ^0.4.10;
157 
158 // import "https://github.com/o0ragman0o/SandalStraps/contracts/RegBase.sol";
159 
160 contract Factory is RegBase
161 {
162 //
163 // Constants
164 //
165 
166     // Deriving factories should have `bytes32 constant public regName` being
167     // the product's contract name, e.g for products "Foo":
168     // bytes32 constant public regName = "Foo";
169 
170     // Deriving factories should have `bytes32 constant public VERSION` being
171     // the product's contract name appended with 'Factory` and the version
172     // of the product, e.g for products "Foo":
173     // bytes32 constant public VERSION "FooFactory 0.0.1";
174 
175 //
176 // State Variables
177 //
178 
179     /// @return The payment in wei required to create the product contract.
180     uint public value;
181 
182 //
183 // Events
184 //
185 
186     // Is triggered when a product is created
187     event Created(address _creator, bytes32 _regName, address _address);
188 
189 //
190 // Modifiers
191 //
192 
193     // To check that the correct fee has bene paid
194     modifier feePaid() {
195     	require(msg.value == value || msg.sender == owner);
196     	_;
197     }
198 
199 //
200 // Functions
201 //
202 
203     /// @param _creator The calling address passed through by a factory,
204     /// typically msg.sender
205     /// @param _regName A static name referenced by a Registrar
206     /// @param _owner optional owner address if creator is not the intended
207     /// owner
208     /// @dev On 0x0 value for _owner or _creator, ownership precedence is:
209     /// `_owner` else `_creator` else msg.sender
210     function Factory(address _creator, bytes32 _regName, address _owner)
211         RegBase(_creator, _regName, _owner)
212     {
213         // nothing left to construct
214     }
215     
216     /// @notice Set the product creation fee
217     /// @param _fee The desired fee in wei
218     function set(uint _fee) 
219         onlyOwner
220         returns (bool)
221     {
222         value = _fee;
223         return true;
224     }
225 
226     /// @notice Send contract balance to `owner`
227     function withdraw()
228         public
229         returns (bool)
230     {
231         owner.transfer(this.balance);
232         return true;
233     }
234     
235     /// @notice Create a new product contract
236     /// @param _regName A unique name if the the product is to be registered in
237     /// a SandalStraps registrar
238     /// @param _owner An address of a third party owner.  Will default to
239     /// msg.sender if 0x0
240     /// @return kAddr_ The address of the new product contract
241     function createNew(bytes32 _regName, address _owner) 
242         payable returns(address kAddr_);
243 }
244 
245 /* Example implimentation of `createNew()` for a deriving factory
246 
247     function createNew(bytes32 _regName, address _owner)
248         payable
249         feePaid
250         returns (address kAddr_)
251     {
252         require(_regName != 0x0);
253         address kAddr_ = address(new Foo(msg.sender, _regName, _owner));
254         Created(msg.sender, _regName, kAddr);
255     }
256 
257 Example product contract with `Factory` compiant constructor and `Registrar`
258 compliant `regName`.
259 
260 The owner will be the caller by default if the `_owner` value is `0x0`.
261 
262 If the contract requires initialization that would normally be done in a
263 constructor, then a `init()` function can be used instead post deployment.
264 
265     contract Foo is RegBase
266     {
267         bytes32 constant public VERSION = "Foo v0.0.1";
268         uint val;
269         uint8 public __initFuse = 1;
270         
271         function Foo(address _creator, bytes32 _regName, address _owner)
272             RegBase(_creator, _regName, _owner)
273         {
274             // put non-parametric constructor code here.
275         }
276         
277         function _init(uint _val)
278         {
279             require(__initFuse == 1);
280 
281             // put parametric constructor code here and call _init() post 
282             // deployment
283             val = _val;
284             delete __initFuse;
285         }
286     }
287 
288 */
289 
290 /*
291 file:   Bakt.sol
292 ver:    0.3.4-beta
293 updated:16-May-2017
294 author: Darryl Morris
295 email:  o0ragman0o AT gmail.com
296 
297 Copyright is retained by the author.  Copying or running this software is only
298 by express permission.
299 
300 This software is provided WITHOUT ANY WARRANTY; without even the implied
301 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. The author
302 cannot be held liable for damage or loss.
303 
304 Design Notes:
305 
306 This contract DOES NOT offer trust to its holders. Holders instead elect a
307 Trustee from among the holders and the Trustee is responsible for funds.
308 
309 The Trustee has unilateral powers to:
310     - remove funds
311     - use the contract to execute code on another contract
312     - pay dividends
313     - add holders
314     - issue a token offer to a holder
315     - selfdestruct the contract, on condition of 0 supply and 0 ether balance
316     - veto a transaction
317 
318 Holders have the power to:
319     - vote for a preferred Trustee
320     - veto a transaction if owned or owns > 10% of tokens
321     - purchase tokens offer with ether.
322     - redeem tokens for ether at the token price or a price proportional to
323       the fund.
324     - withdraw their balance of ether.
325     - Cause a panic state in the contract if holds > 10% of tokens
326 
327 This contract uses integer tokens so ERC20 `decimalPlaces` is 0.
328 
329 Maximum number of holders is limited to 254 to prevent potential OOG loops
330 during elections.
331 Perpetual election of the `Trustee` runs in O(254) time to discover a winner.
332 
333 Release Notes v0.3.4-beta:
334 -fixed magnitude bug introduced when using scientific notation (10**18 != 10e18)
335 -using 10**18 notation rather than 1e18 as already using 2**256 notation
336 -Intend to deploy factory to Ropsten, Rinkeby and Live 
337 
338 Ropsten: 0.3.4-beta-test1 @ 0xc446575f7ed13f7b4b849f70ffa9f209a64db742
339 
340 */
341 
342 // import "https://github.com/o0ragman0o/SandalStraps/contracts/Factory.sol";
343 
344 pragma solidity ^0.4.10;
345 
346 
347 contract BaktInterface
348 {
349 
350 /* Structs */
351 
352     struct Holder {
353         uint8 id;
354         address votingFor;
355         uint40 offerExpiry;
356         uint lastClaimed;
357         uint tokenBalance;
358         uint etherBalance;
359         uint votes;
360         uint offerAmount;
361         mapping (address => uint) allowances;
362     }
363 
364     struct TX {
365         bool blocked;
366         uint40 timeLock;
367         address from;
368         address to;
369         uint value;
370         bytes data;
371     }
372 
373 
374 /* Constants */
375 
376     // Constant max tokens and max ether to prevent potential multiplication
377     // overflows in 10e17 fixed point     
378     uint constant MAXTOKENS = 2**128 - 10**18;
379     uint constant MAXETHER = 2**128;
380     uint constant BLOCKPCNT = 10; // 10% holding required to block TX's
381     uint constant TOKENPRICE = 1000000000000000;
382     uint8 public constant decimalPlaces = 15;
383 
384 /* State Valiables */
385 
386     // A mutex used for reentry protection
387     bool __reMutex;
388 
389     // Initialisation fuse. Blows on initialisation and used for entry check;
390     bool __initFuse = true;
391 
392     // Allows the contract to accept or deny payments
393     bool public acceptingPayments;
394 
395     // The period for which a panic will prevent functionality to the contract
396     uint40 public PANICPERIOD;
397 
398     // The period for which a pending transaction must wait before being sent 
399     uint40 public TXDELAY;
400 
401     /// @return The Panic flag state. false == calm, true == panicked
402     bool public panicked;
403 
404     /// @return The pending transaction queue head pointer
405     uint8 public ptxHead;
406 
407     /// @return The pending transaction queue tail pointer
408     uint8 public ptxTail;
409 
410     /// @return The `PANIC` timelock expiry date/time
411     uint40 public timeToCalm;
412 
413     /// @return The Address of the current elected trustee
414     address public trustee;
415 
416     /// @return Total count of tokens
417     uint public totalSupply;
418 
419     /// @return The combined balance of ether committed to holder accounts, 
420     /// unclaimed dividends and values in pending transactions.
421     uint public committedEther;
422 
423     /// @dev The running tally of dividends points accured by 
424     /// dividend/totalSupply at each dividend payment
425     uint dividendPoints;
426 
427     /// @return The historic tally of paid dividends
428     uint public totalDividends;
429 
430     /// @return A static identifier, set in the constructor and used by
431     /// registrars
432     bytes32 public regName;
433 
434     /// @return An informational resource. Can be a sha3 of a string to lookup
435     /// in a StringsMap
436     bytes32 public resource;
437 
438     /// @param address The address of a holder.
439     /// @return Holder data cast from struct Holder to an array
440     mapping (address => Holder) public holders;
441 
442     /// @param uint8 The index of a holder
443     /// @return An address of a holder
444     address[256] public holderIndex;
445 
446     /// @param uint8 The index of a pending transaction
447     /// @return Transaction details cast from struct TX to array
448     TX[256] public pendingTxs;
449 
450 /* Events */
451 
452     // Triggered when the contract recieves a payment
453     event Deposit(uint value);
454 
455     // Triggered when ether is sent from the contract
456     event Withdrawal(address indexed sender, address indexed recipient,
457         uint value);
458 
459     // Triggered when a transaction is ordered
460     event TransactionPending(uint indexed pTX, address indexed sender, 
461         address indexed recipient, uint value, uint timeLock);
462 
463     // Triggered when a pending transaction is blocked
464     event TransactionBlocked(address indexed by, uint indexed pTX);
465 
466     // Triggered when a transaction fails either by being blocked or failure of 
467     // reciept
468     event TransactionFailed(address indexed sender, address indexed recipient,
469         uint value);
470 
471     // Triggered when the trustee pays dividends
472     event DividendPaid(uint value);
473 
474     // ERC20 transfer notification
475     event Transfer(address indexed from, address indexed to, uint value);
476 
477     // ERC20 approval notification
478     event Approval(address indexed owner, address indexed spender, uint value);
479 
480     // Triggered on change of trustee
481     event Trustee(address indexed trustee);
482 
483     // Trigger when a new holder is added
484     event NewHolder(address indexed holder);
485 
486     // Triggered when a holder vacates
487     event HolderVacated(address indexed holder);
488 
489     // Triggered when a offer of tokens is created
490     event IssueOffer(address indexed holder);
491 
492     // Triggered on token creation when an offer is accepted
493     event TokensCreated(address indexed holder, uint amount);
494 
495     // Triggered when tokens are destroyed during a redeeming round
496     event TokensDestroyed(address indexed holder, uint amount);
497 
498     // Triggered when a hold causes a panic
499     event Panicked(address indexed by);
500 
501     // Triggered when a holder calms a panic
502     event Calm();
503 
504 //
505 // Bakt Functions
506 //
507 
508     /// @dev Accept payment to the default function
509     function() payable;
510 
511     /// @notice This will set the panic and pending periods.
512     /// This action is a one off and is irrevocable! 
513     /// @param _panicDelayInSeconds The panic delay period in seconds
514     /// @param _pendingDelayInSeconds The pending period in seconds
515     function _init(uint40 _panicDelayInSeconds, uint40 _pendingDelayInSeconds)
516         returns (bool);
517 
518     /// @return The balance of uncommitted ether funds.
519     function fundBalance() constant returns (uint);
520     
521     /// @return The constant TOKENPRICE.
522     function tokenPrice() constant returns (uint);
523 
524 //
525 // ERC20 API functions
526 //
527 
528     /// @param _addr The address of a holder
529     /// @return The ERC20 token balance of the holder
530     function balanceOf(address _addr) constant returns (uint);
531 
532     /// @notice Transfer `_amount` of tokens to `_to`
533     /// @param _to the recipient holder's address
534     /// @param _amount the number of tokens to transfer
535     /// @return success state
536     /// @dev `_to` must be an existing holder
537     function transfer(address _to, uint _amount) returns (bool);
538 
539     /// @notice Transfer `_amount` of tokens from `_from` to `_to`
540     /// @param _from The holder address from which to take tokens
541     /// @param _to the recipient holder's address
542     /// @param _amount the number of tokens to transfer
543     /// @return success state
544     /// @dev `_from` and `_to` must be existing holders
545     function transferFrom(address _from, address _to, uint256 _amount)
546         returns (bool);
547 
548     /// @notice Approve `_spender` to transfer `_amount` of tokens
549     /// @param _spender the approved spender address. Does not have to be an
550     /// existing holder.
551     /// @param _amount the number of tokens to transfer
552     function approve(address _spender, uint256 _amount) returns (bool);
553 
554     /// @param _owner The adddress of the holder owning tokens
555     /// @param _spender The address of the account allowed to transfer tokens
556     /// @return Amount of remaining token that the _spender can transfer
557     function allowance(address _owner, address _spender)
558         constant returns (uint256);
559 
560 //
561 // Security Functions
562 //
563 
564     /// @notice Cause the contract to Panic. This will block most state changing
565     /// functions for a set delay.
566     /// Exceptions are `vote()`, `blockPendingTx(uint _txIdx)` and `PANIC()`.
567     function PANIC() returns (bool);
568 
569     /// @notice Release the contract from a Panic after the panic period has
570     /// expired.
571     function calm() returns (bool);
572 
573     /// @notice Execute the first TX in the pendingTxs queue. Values will
574     /// revert if the transaction is blocked or fails.
575     function sendPending() returns (bool);
576 
577     /// @notice Block a pending transaction with id `_txIdx`. Pending
578     /// transactions can be blocked by any holder at any time but must
579     /// still be cleared from the pending transactions queue once the timelock
580     /// is cleared.
581     /// @param _txIdx Index of the transaction in the pending transactions
582     /// table
583     function blockPendingTx(uint _txIdx) returns (bool);
584 
585 //
586 // Trustee functions
587 //
588 
589     /// @notice Send a transaction to `_to` containing `_value` with RLP encoded
590     ///     arguments of `_data`
591     /// @param _to The recipient address
592     /// @param _value value of ether to send
593     /// @param _data RLP encoded data to send with the transaction
594     /// @dev Allows the trustee to initiate a transaction as the Bakt. It must
595     /// be followed by sendPending() after the timeLock expires.
596     function execute(address _to, uint _value, bytes _data) returns (uint8);
597 
598     /// @notice Pay dividends of `_value`
599     /// @param _value a value of ether upto the fund balance
600     /// @dev Allows the trustee to commit a portion of `fundBalance` to dividends.
601     function payDividends(uint _value) returns (bool);
602 
603 //
604 // Holder Functions
605 //
606 
607     /// @return Returns the array of holder addresses.
608     function getHolders() constant returns(address[256]);
609 
610     /// @param _addr The address of a holder
611     /// @return Returns the holder's withdrawable balance of ether
612     function etherBalanceOf(address _addr) constant returns (uint);
613 
614     /// @notice Initiate a withdrawal of the holder's `etherBalance`
615     /// Follow up with sendPending() once the timelock has expired
616     function withdraw() returns(uint8);
617 
618     /// @notice Vacate holder `_addr`
619     /// @param _addr The address of a holder with empty balances.
620     function vacate(address _addr) returns (bool);
621 
622 //
623 // Token Creation/Destruction Functions
624 //
625 
626     /// @notice Create tokens to the value of `msg.value` +
627     /// `holder.etherBalance`
628     /// @return success state
629     /// @dev The amount of tokens created is:
630     ///     tokens = floor((`etherBalance` + `msg.value`)/`tokenPrice`)
631     ///     Any remainder of ether is credited to the holder's `etherBalance`
632     function purchase() payable returns (bool);
633 
634     /// @notice Redeem `_amount` tokens back to the contract
635     /// @param _amount The amount of tokens to redeem
636     /// @dev ether = `_amount` * `fundBalance()` / `totalSupply`
637     /// @return success state
638     function redeem(uint _amount) returns (bool);
639 
640 //
641 // Ballot functions
642 //
643 
644     /// @notice Vote for `_candidate` as preferred Trustee.
645     /// @param _candidate The address of the preferred holder
646     /// @return success state
647     function vote(address _candidate) returns (bool);
648 }
649 
650 contract Bakt is BaktInterface
651 {
652     bytes32 constant public VERSION = "Bakt 0.3.4-beta";
653 
654 //
655 // Bakt Functions
656 //
657 
658     // SandalStraps compliant constructor
659     function Bakt(address _creator, bytes32 _regName, address _trustee)
660     {
661         regName = _regName;
662         trustee = _trustee != 0x0 ? _trustee : 
663                 _creator != 0x0 ? _creator : msg.sender;
664         join(trustee);
665     }
666 
667     // Accept payment to the default function on the condition that
668     // `acceptingPayments` is true
669     function()
670         payable
671     {
672         require(msg.value > 0 &&
673             msg.value + this.balance < MAXETHER &&
674             acceptingPayments);
675         Deposit(msg.value);
676     }
677 
678     // Destructor
679     // Selfdestructs on the condition that `totalSupply` and `committedEther`
680     // are 0
681     function destroy()
682         public
683         canEnter
684         onlyTrustee
685     {
686         require(totalSupply == 0 && committedEther == 0);
687         
688         delete holders[trustee];
689         selfdestruct(msg.sender);
690     }
691 
692     // One Time Programable shot to set the panic and pending periods.
693     // 86400 == 1 day
694     function _init(uint40 _panicPeriodInSeconds, uint40 _pendingPeriodInSeconds)
695         onlyTrustee
696         returns (bool)
697     {
698         require(__initFuse);
699         PANICPERIOD = _panicPeriodInSeconds;
700         TXDELAY = _pendingPeriodInSeconds;
701         acceptingPayments = true;
702         delete __initFuse;
703         return true;
704     }
705 
706     // Returns calculated fund balance
707     function fundBalance()
708         public
709         constant
710         returns (uint)
711     {
712         return this.balance - committedEther;
713     }
714 
715     // Returns token price constant
716     function tokenPrice()
717         public
718         constant
719         returns (uint)
720     {
721         return TOKENPRICE;
722     }
723 
724     // `RegBase` compliant `changeResource()` to restrict caller to
725     // `trustee` rather than `owner`
726     function changeResource(bytes32 _resource)
727         public
728         canEnter
729         onlyTrustee
730         returns (bool)
731     {
732         resource = _resource;
733         return true;
734     }
735 
736 //
737 // ERC20 API functions
738 //
739 
740     // Returns holder token balance
741     function balanceOf(address _addr) 
742         public
743         constant
744         returns (uint)
745     {
746         return holders[_addr].tokenBalance;
747     }
748 
749     // To transfer tokens
750     function transfer(address _to, uint _amount)
751         public
752         canEnter
753         isHolder(_to)
754         returns (bool)
755     {
756         Holder from = holders[msg.sender];
757         Holder to = holders[_to];
758 
759         Transfer(msg.sender, _to, _amount);
760         return xfer(from, to, _amount);
761     }
762 
763     // To transfer tokens by proxy
764     function transferFrom(address _from, address _to, uint256 _amount)
765         public
766         canEnter
767         isHolder(_to)
768         returns (bool)
769     {
770         require(_amount <= holders[_from].allowances[msg.sender]);
771         
772         Holder from = holders[_from];
773         Holder to = holders[_to];
774 
775         from.allowances[msg.sender] -= _amount;
776         Transfer(_from, _to, _amount);
777         return xfer(from, to, _amount);
778     }
779 
780     // To approve a proxy for token transfers
781     function approve(address _spender, uint256 _amount)
782         public
783         canEnter
784         returns (bool)
785     {
786         holders[msg.sender].allowances[_spender] = _amount;
787         Approval(msg.sender, _spender, _amount);
788         return true;
789     }
790 
791     // Return the alloance of a proxy
792     function allowance(address _owner, address _spender)
793         constant
794         returns (uint256)
795     {
796         return holders[_owner].allowances[_spender];
797     }
798 
799     // Processes token transfers and subsequent change in voting power
800     function xfer(Holder storage _from, Holder storage _to, uint _amount)
801         internal
802         returns (bool)
803     {
804         // Ensure dividends are up to date at current balances
805         updateDividendsFor(_from);
806         updateDividendsFor(_to);
807 
808         // Remove existing votes
809         revoke(_from);
810         revoke(_to);
811 
812         // Transfer tokens
813         _from.tokenBalance -= _amount;
814         _to.tokenBalance += _amount;
815 
816         // Revote accoring to changed token balances
817         revote(_from);
818         revote(_to);
819 
820         // Force election
821         election();
822         return true;
823     }
824 
825 //
826 // Security Functions
827 //
828 
829     // Cause the contract to Panic. This will block most state changing
830     // functions for a set delay.
831     function PANIC()
832         public
833         isHolder(msg.sender)
834         returns (bool)
835     {
836         // A blocking holder requires at least 10% of tokens
837         require(holders[msg.sender].tokenBalance >= totalSupply / 10);
838         
839         panicked = true;
840         timeToCalm = uint40(now + PANICPERIOD);
841         Panicked(msg.sender);
842         return true;
843     }
844 
845     // Release the contract from a Panic after the panic period has expired.
846     function calm()
847         public
848         isHolder(msg.sender)
849         returns (bool)
850     {
851         require(uint40(now) > timeToCalm && panicked);
852         
853         panicked = false;
854         Calm();
855         return true;
856     }
857 
858     // Queues a pending transaction 
859     function timeLockSend(address _from, address _to, uint _value, bytes _data)
860         internal
861         returns (uint8)
862     {
863         // Check that queue is not full
864         require(ptxHead + 1 != ptxTail);
865 
866         TX memory tx = TX({
867             from: _from,
868             to: _to,
869             value: _value,
870             data: _data,
871             blocked: false,
872             timeLock: uint40(now + TXDELAY)
873         });
874         TransactionPending(ptxHead, _from, _to, _value, now + TXDELAY);
875         pendingTxs[ptxHead++] = tx;
876         return  ptxHead - 1;
877     }
878 
879     // Execute the first TX in the pendingTxs queue. Values will
880     // revert if the transaction is blocked or fails.
881     function sendPending()
882         public
883         preventReentry
884         isHolder(msg.sender)
885         returns (bool)
886     {
887         if (ptxTail == ptxHead) return false; // TX queue is empty
888         
889         TX memory tx = pendingTxs[ptxTail];
890         if(now < tx.timeLock) return false;
891         
892         // Have memory cached the TX so deleting store now to prevent any chance
893         // of double spends.
894         delete pendingTxs[ptxTail++];
895         
896         if(!tx.blocked) {
897             if(tx.to.call.value(tx.value)(tx.data)) {
898                 // TX sent successfully
899                 committedEther -= tx.value;
900                 
901                 Withdrawal(tx.from, tx.to, tx.value);
902                 return true;
903             }
904         }
905         
906         // TX is blocked or failed so manually revert balances to pre-pending
907         // state
908         if (tx.from == address(this)) {
909             // Was sent from fund balance
910             committedEther -= tx.value;
911         } else {
912             // Was sent from holder ether balance
913             holders[tx.from].etherBalance += tx.value;
914         }
915         
916         TransactionFailed(tx.from, tx.to, tx.value);
917         return false;
918     }
919 
920     // To block a pending transaction
921     function blockPendingTx(uint _txIdx)
922         public
923         returns (bool)
924     {
925         // Only prevent reentry not entry during panic
926         require(!__reMutex);
927         
928         // A blocking holder requires at least 10% of tokens or is trustee or
929         // is from own account
930         require(holders[msg.sender].tokenBalance >= totalSupply / BLOCKPCNT ||
931             msg.sender == pendingTxs[ptxTail].from ||
932             msg.sender == trustee);
933         
934         pendingTxs[_txIdx].blocked = true;
935         TransactionBlocked(msg.sender, _txIdx);
936         return true;
937     }
938 
939 //
940 // Trustee functions
941 //
942 
943     // For the trustee to send a transaction as the contract. Returns pending
944     // TX queue index
945     function execute(address _to, uint _value, bytes _data)
946         public
947         canEnter
948         onlyTrustee
949         returns (uint8)
950     {
951         require(_value <= fundBalance());
952 
953         committedEther += _value;
954         return timeLockSend(address(this), _to, _value, _data);
955     }
956 
957     // For the trustee to commit an amount from the fund balance as a dividend
958     function payDividends(uint _value)
959         public
960         canEnter
961         onlyTrustee
962         returns (bool)
963     {
964         require(_value <= fundBalance());
965         // Calculates dividend as percent of current `totalSupply` in 10e17
966         // fixed point math
967         dividendPoints += 10**18 * _value / totalSupply;
968         totalDividends += _value;
969         committedEther += _value;
970         return true;
971     }
972     
973     // For the trustee to add an address as a holder
974     function addHolder(address _addr)
975         public
976         canEnter
977         onlyTrustee
978         returns (bool)
979     {
980         return join(_addr);
981     }
982 
983     // Creates holder accounts.  Called by addHolder() and issue()
984     function join(address _addr)
985         internal
986         returns (bool)
987     {
988         if(0 != holders[_addr].id) return true;
989         
990         require(_addr != address(this));
991         
992         uint8 id;
993         // Search for the first available slot.
994         while (holderIndex[++id] != 0) {}
995         
996         // if `id` is 0 then there has been a array full overflow.
997         if(id == 0) revert();
998         
999         Holder holder = holders[_addr];
1000         holder.id = id;
1001         holder.lastClaimed = dividendPoints;
1002         holder.votingFor = trustee;
1003         holderIndex[id] = _addr;
1004         NewHolder(_addr);
1005         return true;
1006     }
1007 
1008     // For the trustee to allow or disallow payments made to the Bakt
1009     function acceptPayments(bool _accepting)
1010         public
1011         canEnter
1012         onlyTrustee
1013         returns (bool)
1014     {
1015         acceptingPayments = _accepting;
1016         return true;
1017     }
1018 
1019     // For the trustee to issue an offer of new tokens to a holder
1020     function issue(address _addr, uint _amount)
1021         public
1022         canEnter
1023         onlyTrustee
1024         returns (bool)
1025     {
1026         // prevent overflows in total supply
1027         assert(totalSupply + _amount < MAXTOKENS);
1028         
1029         join(_addr);
1030         Holder holder = holders[_addr];
1031         holder.offerAmount = _amount;
1032         holder.offerExpiry = uint40(now + 7 days);
1033         IssueOffer(_addr);
1034         return true;
1035     }
1036 
1037     // For the trustee to revoke an earlier Issue Offer
1038     function revokeOffer(address _addr)
1039         public
1040         canEnter
1041         onlyTrustee
1042         returns (bool)
1043     {
1044         Holder holder = holders[_addr];
1045         delete holder.offerAmount;
1046         delete holder.offerExpiry;
1047         return true;
1048     }
1049 
1050 //
1051 // Holder Functions
1052 //
1053 
1054     // Returns the array of holder addresses.
1055     function getHolders()
1056         public
1057         constant
1058         returns(address[256])
1059     {
1060         return holderIndex;
1061     }
1062 
1063     // Returns the holder's withdrawable balance of ether
1064     function etherBalanceOf(address _addr)
1065         public
1066         constant
1067         returns (uint)
1068     {
1069         Holder holder = holders[_addr];
1070         return holder.etherBalance + dividendsOwing(holder);
1071     }
1072 
1073     // For a holder to initiate a withdrawal of their ether balance
1074     function withdraw()
1075         public
1076         canEnter
1077         returns(uint8 pTxId_)
1078     {
1079         Holder holder = holders[msg.sender];
1080         updateDividendsFor(holder);
1081         
1082         pTxId_ = timeLockSend(msg.sender, msg.sender, holder.etherBalance, "");
1083         holder.etherBalance = 0;
1084     }
1085 
1086     // To close a holder account
1087     function vacate(address _addr)
1088         public
1089         canEnter
1090         isHolder(msg.sender)
1091         isHolder(_addr)
1092         returns (bool)
1093     {
1094         Holder holder = holders[_addr];
1095         // Ensure holder account is empty, is not the trustee and there are no
1096         // pending transactions or dividends
1097         require(_addr != trustee);
1098         require(holder.tokenBalance == 0);
1099         require(holder.etherBalance == 0);
1100         require(holder.lastClaimed == dividendPoints);
1101         require(ptxHead == ptxTail);
1102         
1103         delete holderIndex[holder.id];
1104         delete holders[_addr];
1105         // NB can't garbage collect holder.allowances mapping
1106         return (true);
1107     }
1108 
1109 //
1110 // Token Creation/Destruction Functions
1111 //
1112 
1113     // For a holder to buy an offer of tokens
1114     function purchase()
1115         payable
1116         canEnter
1117         returns (bool)
1118     {
1119         Holder holder = holders[msg.sender];
1120         // offer must exist
1121         require(holder.offerAmount > 0);
1122         // offer not expired
1123         require(holder.offerExpiry > now);
1124         // correct payment has been sent
1125         require(msg.value == holder.offerAmount * TOKENPRICE);
1126         
1127         updateDividendsFor(holder);
1128                 
1129         revoke(holder);
1130                 
1131         totalSupply += holder.offerAmount;
1132         holder.tokenBalance += holder.offerAmount;
1133         TokensCreated(msg.sender, holder.offerAmount);
1134         
1135         delete holder.offerAmount;
1136         delete holder.offerExpiry;
1137         
1138         revote(holder);
1139         election();
1140         return true;
1141     }
1142 
1143     // For holders to destroy tokens in return for ether during a redeeming
1144     // round
1145     function redeem(uint _amount)
1146         public
1147         canEnter
1148         isHolder(msg.sender)
1149         returns (bool)
1150     {
1151         uint redeemPrice;
1152         uint eth;
1153         
1154         Holder holder = holders[msg.sender];
1155         require(_amount <= holder.tokenBalance);
1156         
1157         updateDividendsFor(holder);
1158         
1159         revoke(holder);
1160         
1161         redeemPrice = fundBalance() / totalSupply;
1162         // prevent redeeming above token price which would allow an arbitrage
1163         // attack on the fund balance
1164         redeemPrice = redeemPrice < TOKENPRICE ? redeemPrice : TOKENPRICE;
1165         
1166         eth = _amount * redeemPrice;
1167         
1168         // will throw if either `amount` or `redeemPRice` are 0
1169         require(eth > 0);
1170         
1171         totalSupply -= _amount;
1172         holder.tokenBalance -= _amount;
1173         holder.etherBalance += eth;
1174         committedEther += eth;
1175         
1176         TokensDestroyed(msg.sender, _amount);
1177         revote(holder);
1178         election();
1179         return true;
1180     }
1181 
1182 //
1183 // Dividend Functions
1184 //
1185 
1186     function dividendsOwing(Holder storage _holder)
1187         internal
1188         constant
1189         returns (uint _value)
1190     {
1191         // Calculates owed dividends in 10e17 fixed point math
1192         return (dividendPoints - _holder.lastClaimed) * _holder.tokenBalance/
1193             10**18;
1194     }
1195     
1196     function updateDividendsFor(Holder storage _holder)
1197         internal
1198     {
1199         _holder.etherBalance += dividendsOwing(_holder);
1200         _holder.lastClaimed = dividendPoints;
1201     }
1202 
1203 //
1204 // Ballot functions
1205 //
1206 
1207     // To vote for a preferred Trustee.
1208     function vote(address _candidate)
1209         public
1210         isHolder(msg.sender)
1211         isHolder(_candidate)
1212         returns (bool)
1213     {
1214         // Only prevent reentry not entry during panic
1215         require(!__reMutex);
1216         
1217         Holder holder = holders[msg.sender];
1218         revoke(holder);
1219         holder.votingFor = _candidate;
1220         revote(holder);
1221         election();
1222         return true;
1223     }
1224 
1225     // Loops through holders to find the holder with most votes and declares
1226     // them to be the Executive;
1227     function election()
1228         internal
1229     {
1230         uint max;
1231         uint winner;
1232         uint votes;
1233         uint8 i;
1234         address addr;
1235         
1236         if (0 == totalSupply) return;
1237         
1238         while(++i != 0)
1239         {
1240             addr = holderIndex[i];
1241             if (addr != 0x0) {
1242                 votes = holders[addr].votes;
1243                 if (votes > max) {
1244                     max = votes;
1245                     winner = i;
1246                 }
1247             }
1248         }
1249         trustee = holderIndex[winner];
1250         Trustee(trustee);
1251     }
1252 
1253     // Pulls votes from the preferred candidate
1254     // required before any adjustments to `tokenBalance` or vote preference.
1255     function revoke(Holder _holder)
1256         internal
1257     {
1258         holders[_holder.votingFor].votes -= _holder.tokenBalance;
1259     }
1260 
1261     // Places votes with preferred candidate
1262     // required after any adjustments to `tokenBalance` or vote preference.
1263     function revote(Holder _holder)
1264         internal
1265     {
1266         holders[_holder.votingFor].votes += _holder.tokenBalance;
1267     }
1268 
1269 //
1270 // Modifiers
1271 //
1272 
1273     // Blocks if reentry mutex or panicked is true or sets rentry mutex to true
1274     modifier preventReentry() {
1275         require(!(__reMutex || panicked || __initFuse));
1276         __reMutex = true;
1277         _;
1278         __reMutex = false;
1279         return;
1280     }
1281 
1282     // Blocks if reentry mutex or panicked is true
1283     modifier canEnter() {
1284         require(!(__reMutex || panicked || __initFuse));
1285         _;
1286     }
1287 
1288     // Blocks if '_addr' is not a holder
1289     modifier isHolder(address _addr) {
1290         require(0 != holders[_addr].id);
1291         _;
1292     }
1293 
1294     // Block non-trustee holders
1295     modifier onlyTrustee() {
1296         require(msg.sender == trustee);
1297         _;
1298     }
1299 }
1300 
1301 
1302 // SandalStraps compliant factory for Bakt
1303 contract BaktFactory is Factory
1304 {
1305     // Live: 0xc7c11eb6983787f7aa0c20abeeac8101cf621e47
1306     // https://etherscan.io/address/0xc7c11eb6983787f7aa0c20abeeac8101cf621e47
1307     // Ropsten: 0xda33129464688b7bd752ce64e9ed6bca65f44902 (could not verify),
1308     //          0x19124dbab3fcba78b8d240ed2f2eb87654e252d4
1309     // Rinkeby: 
1310 
1311 /* Constants */
1312 
1313     bytes32 constant public regName = "Bakt";
1314     bytes32 constant public VERSION = "Bakt Factory v0.3.4-beta";
1315 
1316 /* Constructor Destructor*/
1317 
1318     function BaktFactory(address _creator, bytes32 _regName, address _owner)
1319         Factory(_creator, _regName, _owner)
1320     {
1321         // nothing to construct
1322     }
1323 
1324 /* Public Functions */
1325 
1326     function createNew(bytes32 _regName, address _owner)
1327         payable
1328         feePaid
1329         returns (address kAddr_)
1330     {
1331         require(_regName != 0x0);
1332         kAddr_ = new Bakt(owner, _regName, msg.sender);
1333         Created(msg.sender, _regName, kAddr_);
1334     }
1335 }
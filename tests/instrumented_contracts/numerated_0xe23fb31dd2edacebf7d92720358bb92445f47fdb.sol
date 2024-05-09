1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-15
3 */
4 
5 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
6 
7 pragma solidity ^0.5.2;
8 
9 /**
10  * @title Helps contracts guard against reentrancy attacks.
11  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
12  * @dev If you mark a function `nonReentrant`, you should also
13  * mark it `external`.
14  */
15 contract ReentrancyGuard {
16     /// @dev counter to allow mutex lock with only one SSTORE operation
17     uint256 private _guardCounter;
18 
19     constructor () internal {
20         // The counter starts at one to prevent changing it from zero to a non-zero
21         // value, which is a more expensive operation.
22         _guardCounter = 1;
23     }
24 
25     /**
26      * @dev Prevents a contract from calling itself, directly or indirectly.
27      * Calling a `nonReentrant` function from another `nonReentrant`
28      * function is not supported. It is possible to prevent this from happening
29      * by making the `nonReentrant` function external, and make it call a
30      * `private` function that does the actual work.
31      */
32     modifier nonReentrant() {
33         _guardCounter += 1;
34         uint256 localCounter = _guardCounter;
35         _;
36         require(localCounter == _guardCounter);
37     }
38 }
39 
40 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
41 
42 pragma solidity ^0.5.2;
43 
44 /**
45  * @title SafeMath
46  * @dev Unsigned math operations with safety checks that revert on error
47  */
48 library SafeMath {
49     /**
50      * @dev Multiplies two unsigned integers, reverts on overflow.
51      */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b);
62 
63         return c;
64     }
65 
66     /**
67      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
68      */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Adds two unsigned integers, reverts on overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
100      * reverts when dividing by zero.
101      */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0);
104         return a % b;
105     }
106 }
107 
108 // File: contracts/core/interfaces/ICore.sol
109 
110 /*
111     Copyright 2018 Set Labs Inc.
112 
113     Licensed under the Apache License, Version 2.0 (the "License");
114     you may not use this file except in compliance with the License.
115     You may obtain a copy of the License at
116 
117     http://www.apache.org/licenses/LICENSE-2.0
118 
119     Unless required by applicable law or agreed to in writing, software
120     distributed under the License is distributed on an "AS IS" BASIS,
121     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
122     See the License for the specific language governing permissions and
123     limitations under the License.
124 */
125 
126 pragma solidity 0.5.7;
127 
128 
129 /**
130  * @title ICore
131  * @author Set Protocol
132  *
133  * The ICore Contract defines all the functions exposed in the Core through its
134  * various extensions and is a light weight way to interact with the contract.
135  */
136 interface ICore {
137     /**
138      * Return transferProxy address.
139      *
140      * @return address       transferProxy address
141      */
142     function transferProxy()
143         external
144         view
145         returns (address);
146 
147     /**
148      * Return vault address.
149      *
150      * @return address       vault address
151      */
152     function vault()
153         external
154         view
155         returns (address);
156 
157     /**
158      * Return address belonging to given exchangeId.
159      *
160      * @param  _exchangeId       ExchangeId number
161      * @return address           Address belonging to given exchangeId
162      */
163     function exchangeIds(
164         uint8 _exchangeId
165     )
166         external
167         view
168         returns (address);
169 
170     /*
171      * Returns if valid set
172      *
173      * @return  bool      Returns true if Set created through Core and isn't disabled
174      */
175     function validSets(address)
176         external
177         view
178         returns (bool);
179 
180     /*
181      * Returns if valid module
182      *
183      * @return  bool      Returns true if valid module
184      */
185     function validModules(address)
186         external
187         view
188         returns (bool);
189 
190     /**
191      * Return boolean indicating if address is a valid Rebalancing Price Library.
192      *
193      * @param  _priceLibrary    Price library address
194      * @return bool             Boolean indicating if valid Price Library
195      */
196     function validPriceLibraries(
197         address _priceLibrary
198     )
199         external
200         view
201         returns (bool);
202 
203     /**
204      * Exchanges components for Set Tokens
205      *
206      * @param  _set          Address of set to issue
207      * @param  _quantity     Quantity of set to issue
208      */
209     function issue(
210         address _set,
211         uint256 _quantity
212     )
213         external;
214 
215     /**
216      * Issues a specified Set for a specified quantity to the recipient
217      * using the caller's components from the wallet and vault.
218      *
219      * @param  _recipient    Address to issue to
220      * @param  _set          Address of the Set to issue
221      * @param  _quantity     Number of tokens to issue
222      */
223     function issueTo(
224         address _recipient,
225         address _set,
226         uint256 _quantity
227     )
228         external;
229 
230     /**
231      * Converts user's components into Set Tokens held directly in Vault instead of user's account
232      *
233      * @param _set          Address of the Set
234      * @param _quantity     Number of tokens to redeem
235      */
236     function issueInVault(
237         address _set,
238         uint256 _quantity
239     )
240         external;
241 
242     /**
243      * Function to convert Set Tokens into underlying components
244      *
245      * @param _set          The address of the Set token
246      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
247      */
248     function redeem(
249         address _set,
250         uint256 _quantity
251     )
252         external;
253 
254     /**
255      * Redeem Set token and return components to specified recipient. The components
256      * are left in the vault
257      *
258      * @param _recipient    Recipient of Set being issued
259      * @param _set          Address of the Set
260      * @param _quantity     Number of tokens to redeem
261      */
262     function redeemTo(
263         address _recipient,
264         address _set,
265         uint256 _quantity
266     )
267         external;
268 
269     /**
270      * Function to convert Set Tokens held in vault into underlying components
271      *
272      * @param _set          The address of the Set token
273      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
274      */
275     function redeemInVault(
276         address _set,
277         uint256 _quantity
278     )
279         external;
280 
281     /**
282      * Composite method to redeem and withdraw with a single transaction
283      *
284      * Normally, you should expect to be able to withdraw all of the tokens.
285      * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
286      * allows you to optionally specify which component tokens to exclude when
287      * redeeming. They will remain in the vault under the users' addresses.
288      *
289      * @param _set          Address of the Set
290      * @param _to           Address to withdraw or attribute tokens to
291      * @param _quantity     Number of tokens to redeem
292      * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
293      */
294     function redeemAndWithdrawTo(
295         address _set,
296         address _to,
297         uint256 _quantity,
298         uint256 _toExclude
299     )
300         external;
301 
302     /**
303      * Deposit multiple tokens to the vault. Quantities should be in the
304      * order of the addresses of the tokens being deposited.
305      *
306      * @param  _tokens           Array of the addresses of the ERC20 tokens
307      * @param  _quantities       Array of the number of tokens to deposit
308      */
309     function batchDeposit(
310         address[] calldata _tokens,
311         uint256[] calldata _quantities
312     )
313         external;
314 
315     /**
316      * Withdraw multiple tokens from the vault. Quantities should be in the
317      * order of the addresses of the tokens being withdrawn.
318      *
319      * @param  _tokens            Array of the addresses of the ERC20 tokens
320      * @param  _quantities        Array of the number of tokens to withdraw
321      */
322     function batchWithdraw(
323         address[] calldata _tokens,
324         uint256[] calldata _quantities
325     )
326         external;
327 
328     /**
329      * Deposit any quantity of tokens into the vault.
330      *
331      * @param  _token           The address of the ERC20 token
332      * @param  _quantity        The number of tokens to deposit
333      */
334     function deposit(
335         address _token,
336         uint256 _quantity
337     )
338         external;
339 
340     /**
341      * Withdraw a quantity of tokens from the vault.
342      *
343      * @param  _token           The address of the ERC20 token
344      * @param  _quantity        The number of tokens to withdraw
345      */
346     function withdraw(
347         address _token,
348         uint256 _quantity
349     )
350         external;
351 
352     /**
353      * Transfer tokens associated with the sender's account in vault to another user's
354      * account in vault.
355      *
356      * @param  _token           Address of token being transferred
357      * @param  _to              Address of user receiving tokens
358      * @param  _quantity        Amount of tokens being transferred
359      */
360     function internalTransfer(
361         address _token,
362         address _to,
363         uint256 _quantity
364     )
365         external;
366 
367     /**
368      * Deploys a new Set Token and adds it to the valid list of SetTokens
369      *
370      * @param  _factory              The address of the Factory to create from
371      * @param  _components           The address of component tokens
372      * @param  _units                The units of each component token
373      * @param  _naturalUnit          The minimum unit to be issued or redeemed
374      * @param  _name                 The bytes32 encoded name of the new Set
375      * @param  _symbol               The bytes32 encoded symbol of the new Set
376      * @param  _callData             Byte string containing additional call parameters
377      * @return setTokenAddress       The address of the new Set
378      */
379     function createSet(
380         address _factory,
381         address[] calldata _components,
382         uint256[] calldata _units,
383         uint256 _naturalUnit,
384         bytes32 _name,
385         bytes32 _symbol,
386         bytes calldata _callData
387     )
388         external
389         returns (address);
390 
391     /**
392      * Exposes internal function that deposits a quantity of tokens to the vault and attributes
393      * the tokens respectively, to system modules.
394      *
395      * @param  _from            Address to transfer tokens from
396      * @param  _to              Address to credit for deposit
397      * @param  _token           Address of token being deposited
398      * @param  _quantity        Amount of tokens to deposit
399      */
400     function depositModule(
401         address _from,
402         address _to,
403         address _token,
404         uint256 _quantity
405     )
406         external;
407 
408     /**
409      * Exposes internal function that withdraws a quantity of tokens from the vault and
410      * deattributes the tokens respectively, to system modules.
411      *
412      * @param  _from            Address to decredit for withdraw
413      * @param  _to              Address to transfer tokens to
414      * @param  _token           Address of token being withdrawn
415      * @param  _quantity        Amount of tokens to withdraw
416      */
417     function withdrawModule(
418         address _from,
419         address _to,
420         address _token,
421         uint256 _quantity
422     )
423         external;
424 
425     /**
426      * Exposes internal function that deposits multiple tokens to the vault, to system
427      * modules. Quantities should be in the order of the addresses of the tokens being
428      * deposited.
429      *
430      * @param  _from              Address to transfer tokens from
431      * @param  _to                Address to credit for deposits
432      * @param  _tokens            Array of the addresses of the tokens being deposited
433      * @param  _quantities        Array of the amounts of tokens to deposit
434      */
435     function batchDepositModule(
436         address _from,
437         address _to,
438         address[] calldata _tokens,
439         uint256[] calldata _quantities
440     )
441         external;
442 
443     /**
444      * Exposes internal function that withdraws multiple tokens from the vault, to system
445      * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
446      *
447      * @param  _from              Address to decredit for withdrawals
448      * @param  _to                Address to transfer tokens to
449      * @param  _tokens            Array of the addresses of the tokens being withdrawn
450      * @param  _quantities        Array of the amounts of tokens to withdraw
451      */
452     function batchWithdrawModule(
453         address _from,
454         address _to,
455         address[] calldata _tokens,
456         uint256[] calldata _quantities
457     )
458         external;
459 
460     /**
461      * Expose internal function that exchanges components for Set tokens,
462      * accepting any owner, to system modules
463      *
464      * @param  _owner        Address to use tokens from
465      * @param  _recipient    Address to issue Set to
466      * @param  _set          Address of the Set to issue
467      * @param  _quantity     Number of tokens to issue
468      */
469     function issueModule(
470         address _owner,
471         address _recipient,
472         address _set,
473         uint256 _quantity
474     )
475         external;
476 
477     /**
478      * Expose internal function that exchanges Set tokens for components,
479      * accepting any owner, to system modules
480      *
481      * @param  _burnAddress         Address to burn token from
482      * @param  _incrementAddress    Address to increment component tokens to
483      * @param  _set                 Address of the Set to redeem
484      * @param  _quantity            Number of tokens to redeem
485      */
486     function redeemModule(
487         address _burnAddress,
488         address _incrementAddress,
489         address _set,
490         uint256 _quantity
491     )
492         external;
493 
494     /**
495      * Expose vault function that increments user's balance in the vault.
496      * Available to system modules
497      *
498      * @param  _tokens          The addresses of the ERC20 tokens
499      * @param  _owner           The address of the token owner
500      * @param  _quantities      The numbers of tokens to attribute to owner
501      */
502     function batchIncrementTokenOwnerModule(
503         address[] calldata _tokens,
504         address _owner,
505         uint256[] calldata _quantities
506     )
507         external;
508 
509     /**
510      * Expose vault function that decrement user's balance in the vault
511      * Only available to system modules.
512      *
513      * @param  _tokens          The addresses of the ERC20 tokens
514      * @param  _owner           The address of the token owner
515      * @param  _quantities      The numbers of tokens to attribute to owner
516      */
517     function batchDecrementTokenOwnerModule(
518         address[] calldata _tokens,
519         address _owner,
520         uint256[] calldata _quantities
521     )
522         external;
523 
524     /**
525      * Expose vault function that transfer vault balances between users
526      * Only available to system modules.
527      *
528      * @param  _tokens           Addresses of tokens being transferred
529      * @param  _from             Address tokens being transferred from
530      * @param  _to               Address tokens being transferred to
531      * @param  _quantities       Amounts of tokens being transferred
532      */
533     function batchTransferBalanceModule(
534         address[] calldata _tokens,
535         address _from,
536         address _to,
537         uint256[] calldata _quantities
538     )
539         external;
540 
541     /**
542      * Transfers token from one address to another using the transfer proxy.
543      * Only available to system modules.
544      *
545      * @param  _token          The address of the ERC20 token
546      * @param  _quantity       The number of tokens to transfer
547      * @param  _from           The address to transfer from
548      * @param  _to             The address to transfer to
549      */
550     function transferModule(
551         address _token,
552         uint256 _quantity,
553         address _from,
554         address _to
555     )
556         external;
557 
558     /**
559      * Expose transfer proxy function to transfer tokens from one address to another
560      * Only available to system modules.
561      *
562      * @param  _tokens         The addresses of the ERC20 token
563      * @param  _quantities     The numbers of tokens to transfer
564      * @param  _from           The address to transfer from
565      * @param  _to             The address to transfer to
566      */
567     function batchTransferModule(
568         address[] calldata _tokens,
569         uint256[] calldata _quantities,
570         address _from,
571         address _to
572     )
573         external;
574 }
575 
576 // File: contracts/core/lib/RebalancingLibrary.sol
577 
578 /*
579     Copyright 2018 Set Labs Inc.
580 
581     Licensed under the Apache License, Version 2.0 (the "License");
582     you may not use this file except in compliance with the License.
583     You may obtain a copy of the License at
584 
585     http://www.apache.org/licenses/LICENSE-2.0
586 
587     Unless required by applicable law or agreed to in writing, software
588     distributed under the License is distributed on an "AS IS" BASIS,
589     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
590     See the License for the specific language governing permissions and
591     limitations under the License.
592 */
593 
594 pragma solidity 0.5.7;
595 
596 
597 /**
598  * @title RebalancingLibrary
599  * @author Set Protocol
600  *
601  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
602  * Rebalancing Set Tokens. Removes the old calculation functions
603  *
604  */
605 library RebalancingLibrary {
606 
607     /* ============ Enums ============ */
608 
609     enum State { Default, Proposal, Rebalance, Drawdown }
610 
611     /* ============ Structs ============ */
612 
613     struct AuctionPriceParameters {
614         uint256 auctionStartTime;
615         uint256 auctionTimeToPivot;
616         uint256 auctionStartPrice;
617         uint256 auctionPivotPrice;
618     }
619 
620     struct BiddingParameters {
621         uint256 minimumBid;
622         uint256 remainingCurrentSets;
623         uint256[] combinedCurrentUnits;
624         uint256[] combinedNextSetUnits;
625         address[] combinedTokenArray;
626     }
627 }
628 
629 // File: contracts/core/interfaces/IRebalancingSetToken.sol
630 
631 /*
632     Copyright 2018 Set Labs Inc.
633 
634     Licensed under the Apache License, Version 2.0 (the "License");
635     you may not use this file except in compliance with the License.
636     You may obtain a copy of the License at
637 
638     http://www.apache.org/licenses/LICENSE-2.0
639 
640     Unless required by applicable law or agreed to in writing, software
641     distributed under the License is distributed on an "AS IS" BASIS,
642     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
643     See the License for the specific language governing permissions and
644     limitations under the License.
645 */
646 
647 pragma solidity 0.5.7;
648 
649 
650 /**
651  * @title IRebalancingSetToken
652  * @author Set Protocol
653  *
654  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
655  * RebalancingSetToken contract from another contract.
656  */
657 
658 interface IRebalancingSetToken {
659 
660     /*
661      * Get totalSupply of Rebalancing Set
662      *
663      * @return  totalSupply
664      */
665     function totalSupply()
666         external
667         view
668         returns (uint256);
669 
670     /*
671      * Get lastRebalanceTimestamp of Rebalancing Set
672      *
673      * @return  lastRebalanceTimestamp
674      */
675     function lastRebalanceTimestamp()
676         external
677         view
678         returns (uint256);
679 
680     /*
681      * Get rebalanceInterval of Rebalancing Set
682      *
683      * @return  rebalanceInterval
684      */
685     function rebalanceInterval()
686         external
687         view
688         returns (uint256);
689 
690     /*
691      * Get rebalanceState of Rebalancing Set
692      *
693      * @return  rebalanceState
694      */
695     function rebalanceState()
696         external
697         view
698         returns (RebalancingLibrary.State);
699 
700     /**
701      * Gets the balance of the specified address.
702      *
703      * @param owner      The address to query the balance of.
704      * @return           A uint256 representing the amount owned by the passed address.
705      */
706     function balanceOf(
707         address owner
708     )
709         external
710         view
711         returns (uint256);
712 
713     /**
714      * Function used to set the terms of the next rebalance and start the proposal period
715      *
716      * @param _nextSet                      The Set to rebalance into
717      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
718      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
719      * @param _auctionStartPrice            The price to start the auction at
720      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
721      */
722     function propose(
723         address _nextSet,
724         address _auctionLibrary,
725         uint256 _auctionTimeToPivot,
726         uint256 _auctionStartPrice,
727         uint256 _auctionPivotPrice
728     )
729         external;
730 
731     /*
732      * Get natural unit of Set
733      *
734      * @return  uint256       Natural unit of Set
735      */
736     function naturalUnit()
737         external
738         view
739         returns (uint256);
740 
741     /**
742      * Returns the address of the current Base Set
743      *
744      * @return           A address representing the base Set Token
745      */
746     function currentSet()
747         external
748         view
749         returns (address);
750 
751     /*
752      * Get the unit shares of the rebalancing Set
753      *
754      * @return  unitShares       Unit Shares of the base Set
755      */
756     function unitShares()
757         external
758         view
759         returns (uint256);
760 
761     /*
762      * Burn set token for given address.
763      * Can only be called by authorized contracts.
764      *
765      * @param  _from        The address of the redeeming account
766      * @param  _quantity    The number of sets to burn from redeemer
767      */
768     function burn(
769         address _from,
770         uint256 _quantity
771     )
772         external;
773 
774     /*
775      * Place bid during rebalance auction. Can only be called by Core.
776      *
777      * @param _quantity                 The amount of currentSet to be rebalanced
778      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
779      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
780      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
781      */
782     function placeBid(
783         uint256 _quantity
784     )
785         external
786         returns (address[] memory, uint256[] memory, uint256[] memory);
787 
788     /*
789      * Get combinedTokenArray of Rebalancing Set
790      *
791      * @return  combinedTokenArray
792      */
793     function getCombinedTokenArrayLength()
794         external
795         view
796         returns (uint256);
797 
798     /*
799      * Get combinedTokenArray of Rebalancing Set
800      *
801      * @return  combinedTokenArray
802      */
803     function getCombinedTokenArray()
804         external
805         view
806         returns (address[] memory);
807 
808     /*
809      * Get failedAuctionWithdrawComponents of Rebalancing Set
810      *
811      * @return  failedAuctionWithdrawComponents
812      */
813     function getFailedAuctionWithdrawComponents()
814         external
815         view
816         returns (address[] memory);
817 
818     /*
819      * Get biddingParameters for current auction
820      *
821      * @return  biddingParameters
822      */
823     function getBiddingParameters()
824         external
825         view
826         returns (uint256[] memory);
827 
828 }
829 
830 // File: contracts/core/interfaces/ISetToken.sol
831 
832 /*
833     Copyright 2018 Set Labs Inc.
834 
835     Licensed under the Apache License, Version 2.0 (the "License");
836     you may not use this file except in compliance with the License.
837     You may obtain a copy of the License at
838 
839     http://www.apache.org/licenses/LICENSE-2.0
840 
841     Unless required by applicable law or agreed to in writing, software
842     distributed under the License is distributed on an "AS IS" BASIS,
843     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
844     See the License for the specific language governing permissions and
845     limitations under the License.
846 */
847 
848 pragma solidity 0.5.7;
849 
850 /**
851  * @title ISetToken
852  * @author Set Protocol
853  *
854  * The ISetToken interface provides a light-weight, structured way to interact with the
855  * SetToken contract from another contract.
856  */
857 interface ISetToken {
858 
859     /* ============ External Functions ============ */
860 
861     /*
862      * Get natural unit of Set
863      *
864      * @return  uint256       Natural unit of Set
865      */
866     function naturalUnit()
867         external
868         view
869         returns (uint256);
870 
871     /*
872      * Get addresses of all components in the Set
873      *
874      * @return  componentAddresses       Array of component tokens
875      */
876     function getComponents()
877         external
878         view
879         returns (address[] memory);
880 
881     /*
882      * Get units of all tokens in Set
883      *
884      * @return  units       Array of component units
885      */
886     function getUnits()
887         external
888         view
889         returns (uint256[] memory);
890 
891     /*
892      * Checks to make sure token is component of Set
893      *
894      * @param  _tokenAddress     Address of token being checked
895      * @return  bool             True if token is component of Set
896      */
897     function tokenIsComponent(
898         address _tokenAddress
899     )
900         external
901         view
902         returns (bool);
903 
904     /*
905      * Mint set token for given address.
906      * Can only be called by authorized contracts.
907      *
908      * @param  _issuer      The address of the issuing account
909      * @param  _quantity    The number of sets to attribute to issuer
910      */
911     function mint(
912         address _issuer,
913         uint256 _quantity
914     )
915         external;
916 
917     /*
918      * Burn set token for given address
919      * Can only be called by authorized contracts
920      *
921      * @param  _from        The address of the redeeming account
922      * @param  _quantity    The number of sets to burn from redeemer
923      */
924     function burn(
925         address _from,
926         uint256 _quantity
927     )
928         external;
929 
930     /**
931     * Transfer token for a specified address
932     *
933     * @param to The address to transfer to.
934     * @param value The amount to be transferred.
935     */
936     function transfer(
937         address to,
938         uint256 value
939     )
940         external;
941 }
942 
943 // File: contracts/core/interfaces/IVault.sol
944 
945 /*
946     Copyright 2018 Set Labs Inc.
947 
948     Licensed under the Apache License, Version 2.0 (the "License");
949     you may not use this file except in compliance with the License.
950     You may obtain a copy of the License at
951 
952     http://www.apache.org/licenses/LICENSE-2.0
953 
954     Unless required by applicable law or agreed to in writing, software
955     distributed under the License is distributed on an "AS IS" BASIS,
956     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
957     See the License for the specific language governing permissions and
958     limitations under the License.
959 */
960 
961 pragma solidity 0.5.7;
962 
963 /**
964  * @title IVault
965  * @author Set Protocol
966  *
967  * The IVault interface provides a light-weight, structured way to interact with the Vault
968  * contract from another contract.
969  */
970 interface IVault {
971 
972     /*
973      * Withdraws user's unassociated tokens to user account. Can only be
974      * called by authorized core contracts.
975      *
976      * @param  _token          The address of the ERC20 token
977      * @param  _to             The address to transfer token to
978      * @param  _quantity       The number of tokens to transfer
979      */
980     function withdrawTo(
981         address _token,
982         address _to,
983         uint256 _quantity
984     )
985         external;
986 
987     /*
988      * Increment quantity owned of a token for a given address. Can
989      * only be called by authorized core contracts.
990      *
991      * @param  _token           The address of the ERC20 token
992      * @param  _owner           The address of the token owner
993      * @param  _quantity        The number of tokens to attribute to owner
994      */
995     function incrementTokenOwner(
996         address _token,
997         address _owner,
998         uint256 _quantity
999     )
1000         external;
1001 
1002     /*
1003      * Decrement quantity owned of a token for a given address. Can only
1004      * be called by authorized core contracts.
1005      *
1006      * @param  _token           The address of the ERC20 token
1007      * @param  _owner           The address of the token owner
1008      * @param  _quantity        The number of tokens to deattribute to owner
1009      */
1010     function decrementTokenOwner(
1011         address _token,
1012         address _owner,
1013         uint256 _quantity
1014     )
1015         external;
1016 
1017     /**
1018      * Transfers tokens associated with one account to another account in the vault
1019      *
1020      * @param  _token          Address of token being transferred
1021      * @param  _from           Address token being transferred from
1022      * @param  _to             Address token being transferred to
1023      * @param  _quantity       Amount of tokens being transferred
1024      */
1025 
1026     function transferBalance(
1027         address _token,
1028         address _from,
1029         address _to,
1030         uint256 _quantity
1031     )
1032         external;
1033 
1034 
1035     /*
1036      * Withdraws user's unassociated tokens to user account. Can only be
1037      * called by authorized core contracts.
1038      *
1039      * @param  _tokens          The addresses of the ERC20 tokens
1040      * @param  _owner           The address of the token owner
1041      * @param  _quantities      The numbers of tokens to attribute to owner
1042      */
1043     function batchWithdrawTo(
1044         address[] calldata _tokens,
1045         address _to,
1046         uint256[] calldata _quantities
1047     )
1048         external;
1049 
1050     /*
1051      * Increment quantites owned of a collection of tokens for a given address. Can
1052      * only be called by authorized core contracts.
1053      *
1054      * @param  _tokens          The addresses of the ERC20 tokens
1055      * @param  _owner           The address of the token owner
1056      * @param  _quantities      The numbers of tokens to attribute to owner
1057      */
1058     function batchIncrementTokenOwner(
1059         address[] calldata _tokens,
1060         address _owner,
1061         uint256[] calldata _quantities
1062     )
1063         external;
1064 
1065     /*
1066      * Decrements quantites owned of a collection of tokens for a given address. Can
1067      * only be called by authorized core contracts.
1068      *
1069      * @param  _tokens          The addresses of the ERC20 tokens
1070      * @param  _owner           The address of the token owner
1071      * @param  _quantities      The numbers of tokens to attribute to owner
1072      */
1073     function batchDecrementTokenOwner(
1074         address[] calldata _tokens,
1075         address _owner,
1076         uint256[] calldata _quantities
1077     )
1078         external;
1079 
1080    /**
1081      * Transfers tokens associated with one account to another account in the vault
1082      *
1083      * @param  _tokens           Addresses of tokens being transferred
1084      * @param  _from             Address tokens being transferred from
1085      * @param  _to               Address tokens being transferred to
1086      * @param  _quantities       Amounts of tokens being transferred
1087      */
1088     function batchTransferBalance(
1089         address[] calldata _tokens,
1090         address _from,
1091         address _to,
1092         uint256[] calldata _quantities
1093     )
1094         external;
1095 
1096     /*
1097      * Get balance of particular contract for owner.
1098      *
1099      * @param  _token    The address of the ERC20 token
1100      * @param  _owner    The address of the token owner
1101      */
1102     function getOwnerBalance(
1103         address _token,
1104         address _owner
1105     )
1106         external
1107         view
1108         returns (uint256);
1109 }
1110 
1111 // File: contracts/core/interfaces/ITransferProxy.sol
1112 
1113 /*
1114     Copyright 2018 Set Labs Inc.
1115 
1116     Licensed under the Apache License, Version 2.0 (the "License");
1117     you may not use this file except in compliance with the License.
1118     You may obtain a copy of the License at
1119 
1120     http://www.apache.org/licenses/LICENSE-2.0
1121 
1122     Unless required by applicable law or agreed to in writing, software
1123     distributed under the License is distributed on an "AS IS" BASIS,
1124     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1125     See the License for the specific language governing permissions and
1126     limitations under the License.
1127 */
1128 
1129 pragma solidity 0.5.7;
1130 
1131 /**
1132  * @title ITransferProxy
1133  * @author Set Protocol
1134  *
1135  * The ITransferProxy interface provides a light-weight, structured way to interact with the
1136  * TransferProxy contract from another contract.
1137  */
1138 interface ITransferProxy {
1139 
1140     /* ============ External Functions ============ */
1141 
1142     /**
1143      * Transfers tokens from an address (that has set allowance on the proxy).
1144      * Can only be called by authorized core contracts.
1145      *
1146      * @param  _token          The address of the ERC20 token
1147      * @param  _quantity       The number of tokens to transfer
1148      * @param  _from           The address to transfer from
1149      * @param  _to             The address to transfer to
1150      */
1151     function transfer(
1152         address _token,
1153         uint256 _quantity,
1154         address _from,
1155         address _to
1156     )
1157         external;
1158 
1159     /**
1160      * Transfers tokens from an address (that has set allowance on the proxy).
1161      * Can only be called by authorized core contracts.
1162      *
1163      * @param  _tokens         The addresses of the ERC20 token
1164      * @param  _quantities     The numbers of tokens to transfer
1165      * @param  _from           The address to transfer from
1166      * @param  _to             The address to transfer to
1167      */
1168     function batchTransfer(
1169         address[] calldata _tokens,
1170         uint256[] calldata _quantities,
1171         address _from,
1172         address _to
1173     )
1174         external;
1175 }
1176 
1177 // File: contracts/core/modules/lib/ModuleCoreState.sol
1178 
1179 /*
1180     Copyright 2018 Set Labs Inc.
1181 
1182     Licensed under the Apache License, Version 2.0 (the "License");
1183     you may not use this file except in compliance with the License.
1184     You may obtain a copy of the License at
1185 
1186     http://www.apache.org/licenses/LICENSE-2.0
1187 
1188     Unless required by applicable law or agreed to in writing, software
1189     distributed under the License is distributed on an "AS IS" BASIS,
1190     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1191     See the License for the specific language governing permissions and
1192     limitations under the License.
1193 */
1194 
1195 pragma solidity 0.5.7;
1196 
1197 
1198 
1199 
1200 
1201 /**
1202  * @title ModuleCoreState
1203  * @author Set Protocol
1204  *
1205  * The ModuleCoreState library maintains Core-related state for modules
1206  */
1207 contract ModuleCoreState {
1208 
1209     /* ============ State Variables ============ */
1210 
1211     // Address of core contract
1212     address public core;
1213 
1214     // Address of vault contract
1215     address public vault;
1216 
1217     // Instance of core contract
1218     ICore public coreInstance;
1219 
1220     // Instance of vault contract
1221     IVault public vaultInstance;
1222 
1223     /* ============ Public Getters ============ */
1224 
1225     /**
1226      * Constructor function for ModuleCoreState
1227      *
1228      * @param _core                The address of Core
1229      * @param _vault               The address of Vault
1230      */
1231     constructor(
1232         address _core,
1233         address _vault
1234     )
1235         public
1236     {
1237         // Commit passed address to core state variable
1238         core = _core;
1239 
1240         // Commit passed address to coreInstance state variable
1241         coreInstance = ICore(_core);
1242 
1243         // Commit passed address to vault state variable
1244         vault = _vault;
1245 
1246         // Commit passed address to vaultInstance state variable
1247         vaultInstance = IVault(_vault);
1248     }
1249 }
1250 
1251 // File: contracts/core/modules/RebalanceAuctionModule.sol
1252 
1253 /*
1254     Copyright 2018 Set Labs Inc.
1255 
1256     Licensed under the Apache License, Version 2.0 (the "License");
1257     you may not use this file except in compliance with the License.
1258     You may obtain a copy of the License at
1259 
1260     http://www.apache.org/licenses/LICENSE-2.0
1261 
1262     Unless required by applicable law or agreed to in writing, software
1263     distributed under the License is distributed on an "AS IS" BASIS,
1264     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1265     See the License for the specific language governing permissions and
1266     limitations under the License.
1267 */
1268 
1269 pragma solidity 0.5.7;
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 
1279 /**
1280  * @title RebalanceAuctionModule
1281  * @author Set Protocol
1282  *
1283  * The RebalanceAuctionModule is a smart contract that exposes bidding and failed rebalance functionality.
1284  */
1285 contract RebalanceAuctionModule is
1286     ModuleCoreState,
1287     ReentrancyGuard
1288 {
1289     using SafeMath for uint256;
1290 
1291     /* ============ Events ============ */
1292 
1293     event BidPlaced(
1294         address indexed rebalancingSetToken,
1295         address indexed bidder,
1296         uint256 executionQuantity,
1297         address[] combinedTokenAddresses,
1298         uint256[] inflowTokenUnits,
1299         uint256[] outflowTokenUnits
1300     );
1301 
1302     /* ============ Constructor ============ */
1303 
1304     /**
1305      * Constructor function for RebalanceAuctionModule
1306      *
1307      * @param _core       The address of Core
1308      * @param _vault      The address of Vault
1309      */
1310     constructor(
1311         address _core,
1312         address _vault
1313     )
1314         public
1315         ModuleCoreState(
1316             _core,
1317             _vault
1318         )
1319     {}
1320 
1321     /* ============ Public Functions ============ */
1322 
1323     /**
1324      * Bid on rebalancing a given quantity of sets held by a rebalancing token
1325      * The tokens are attributed to the user in the vault.
1326      *
1327      * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
1328      * @param  _quantity               Number of currentSets to rebalance
1329      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
1330                                        is greater than currentRemainingSets
1331      */
1332     function bid(
1333         address _rebalancingSetToken,
1334         uint256 _quantity,
1335         bool _allowPartialFill
1336     )
1337         external
1338         nonReentrant
1339     {
1340         // If user allows partial fills calculate partial fill (if necessary)
1341         uint256 executionQuantity = calculateExecutionQuantity(
1342             _rebalancingSetToken,
1343             _quantity,
1344             _allowPartialFill
1345         );
1346 
1347         // Place bid and retrieve token inflows and outflows
1348         address[] memory tokenArray;
1349         uint256[] memory inflowUnitArray;
1350         uint256[] memory outflowUnitArray;
1351         (
1352             tokenArray,
1353             inflowUnitArray,
1354             outflowUnitArray
1355         ) = IRebalancingSetToken(_rebalancingSetToken).placeBid(executionQuantity);
1356 
1357         // Retrieve tokens from bidder and deposit in vault for rebalancing set token
1358         coreInstance.batchDepositModule(
1359             msg.sender,
1360             _rebalancingSetToken,
1361             tokenArray,
1362             inflowUnitArray
1363         );
1364 
1365         // Transfer ownership of tokens in vault from rebalancing set token to bidder
1366         coreInstance.batchTransferBalanceModule(
1367             tokenArray,
1368             _rebalancingSetToken,
1369             msg.sender,
1370             outflowUnitArray
1371         );
1372 
1373         // Log bid placed event
1374         emit BidPlaced(
1375             _rebalancingSetToken,
1376             msg.sender,
1377             executionQuantity,
1378             tokenArray,
1379             inflowUnitArray,
1380             outflowUnitArray
1381         );
1382     }
1383 
1384     /**
1385      * Bid on rebalancing a given quantity of sets held by a rebalancing token
1386      * The tokens are returned to the user.
1387      *
1388      * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
1389      * @param  _quantity               Number of currentSets to rebalance
1390      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
1391                                        is greater than currentRemainingSets
1392      */
1393     function bidAndWithdraw(
1394         address _rebalancingSetToken,
1395         uint256 _quantity,
1396         bool _allowPartialFill
1397     )
1398         external
1399         nonReentrant
1400     {
1401         // If user allows partial fills calculate partial fill (if necessary)
1402         uint256 executionQuantity = calculateExecutionQuantity(
1403             _rebalancingSetToken,
1404             _quantity,
1405             _allowPartialFill
1406         );
1407 
1408         // Place bid and retrieve token inflows and outflows
1409         address[] memory tokenArray;
1410         uint256[] memory inflowUnitArray;
1411         uint256[] memory outflowUnitArray;
1412         (
1413             tokenArray,
1414             inflowUnitArray,
1415             outflowUnitArray
1416         ) = IRebalancingSetToken(_rebalancingSetToken).placeBid(executionQuantity);
1417 
1418         // Retrieve tokens from bidder and deposit in vault for rebalancing set token
1419         coreInstance.batchDepositModule(
1420             msg.sender,
1421             _rebalancingSetToken,
1422             tokenArray,
1423             inflowUnitArray
1424         );
1425 
1426         // Withdraw tokens from Rebalancing Set Token vault account to bidder
1427         coreInstance.batchWithdrawModule(
1428             _rebalancingSetToken,
1429             msg.sender,
1430             tokenArray,
1431             outflowUnitArray
1432         );
1433 
1434         // Log bid placed event
1435         emit BidPlaced(
1436             _rebalancingSetToken,
1437             msg.sender,
1438             executionQuantity,
1439             tokenArray,
1440             inflowUnitArray,
1441             outflowUnitArray
1442         );
1443     }
1444 
1445     /**
1446      * If a Rebalancing Set Token Rebalance has failed (it includes paused token or exceeds gas limits)
1447      * and been put in Drawdown state, user's can withdraw their portion of the components collateralizing
1448      * the Rebalancing Set Token. This burns the user's portion of the Rebalancing Set Token.
1449      *
1450      * @param  _rebalancingSetToken    Address of the rebalancing token to withdraw from
1451      */
1452     function redeemFromFailedRebalance(
1453         address _rebalancingSetToken
1454     )
1455         external
1456         nonReentrant
1457     {
1458         // Create Rebalancing Set Token instance
1459         IRebalancingSetToken rebalancingSetToken = IRebalancingSetToken(_rebalancingSetToken);
1460 
1461         // Make sure the rebalancingSetToken is tracked by Core
1462         require(
1463             coreInstance.validSets(_rebalancingSetToken),
1464             "RebalanceAuctionModule.redeemFromFailedRebalance: Invalid or disabled SetToken address"
1465         );
1466 
1467         // Get getFailedAuctionWithdrawComponents from RebalancingSetToken
1468         address[] memory withdrawComponents = rebalancingSetToken.getFailedAuctionWithdrawComponents();
1469 
1470         // Get Rebalancing Set Token's total supply
1471         uint256 setTotalSupply = rebalancingSetToken.totalSupply();
1472 
1473         // Get caller's balance
1474         uint256 callerBalance = rebalancingSetToken.balanceOf(msg.sender);
1475 
1476         // Get RebalancingSetToken component amounts and calculate caller's portion of each token
1477         uint256 transferArrayLength = withdrawComponents.length;
1478         uint256[] memory componentTransferAmount = new uint256[](transferArrayLength);
1479         for (uint256 i = 0; i < transferArrayLength; i++) {
1480             uint256 tokenCollateralAmount = vaultInstance.getOwnerBalance(
1481                 withdrawComponents[i],
1482                 _rebalancingSetToken
1483             );
1484             componentTransferAmount[i] = tokenCollateralAmount.mul(callerBalance).div(setTotalSupply);
1485         }
1486 
1487         // Burn caller's balance of Rebalancing Set Token
1488         rebalancingSetToken.burn(
1489             msg.sender,
1490             callerBalance
1491         );
1492 
1493         // Transfer token amounts to caller in Vault from Rebalancing Set Token
1494         coreInstance.batchTransferBalanceModule(
1495             withdrawComponents,
1496             _rebalancingSetToken,
1497             msg.sender,
1498             componentTransferAmount
1499         );
1500     }
1501 
1502     /* ============ Internal Functions ============ */
1503 
1504     /**
1505      * Get execution quantity in event bid quantity exceeds remainingCurrentSets
1506      *
1507      * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
1508      * @param  _quantity               Number of currentSets to rebalance
1509      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
1510                                        is greater than currentRemainingSets
1511      * @return executionQuantity       Array of token addresses invovled in rebalancing
1512      */
1513     function calculateExecutionQuantity(
1514         address _rebalancingSetToken,
1515         uint256 _quantity,
1516         bool _allowPartialFill
1517     )
1518         internal
1519         view
1520         returns (uint256)
1521     {
1522         // Make sure the rebalancingSetToken is tracked by Core
1523         require(
1524             coreInstance.validSets(_rebalancingSetToken),
1525             "RebalanceAuctionModule.bid: Invalid or disabled SetToken address"
1526         );
1527 
1528         // Receive bidding parameters of current auction
1529         uint256[] memory biddingParameters = IRebalancingSetToken(_rebalancingSetToken).getBiddingParameters();
1530         uint256 minimumBid = biddingParameters[0];
1531         uint256 remainingCurrentSets = biddingParameters[1];
1532 
1533         if (_allowPartialFill && _quantity > remainingCurrentSets) {
1534             // If quantity is greater than remainingCurrentSets round amount to nearest multiple of
1535             // minimumBid that is less than remainingCurrentSets
1536             uint256 executionQuantity = remainingCurrentSets.div(minimumBid).mul(minimumBid);
1537             return executionQuantity;
1538         } else {
1539             return _quantity;
1540         }
1541     }
1542 }
1 /*
2     Copyright 2018 Set Labs Inc.
3 
4     Licensed under the Apache License, Version 2.0 (the "License");
5     you may not use this file except in compliance with the License.
6     You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10     Unless required by applicable law or agreed to in writing, software
11     distributed under the License is distributed on an "AS IS" BASIS,
12     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13     See the License for the specific language governing permissions and
14     limitations under the License.
15 */
16 
17 pragma solidity 0.5.7;
18 
19 
20 /**
21  * @title ICore
22  * @author Set Protocol
23  *
24  * The ICore Contract defines all the functions exposed in the Core through its
25  * various extensions and is a light weight way to interact with the contract.
26  */
27 interface ICore {
28     /**
29      * Return transferProxy address.
30      *
31      * @return address       transferProxy address
32      */
33     function transferProxy()
34         external
35         view
36         returns (address);
37 
38     /**
39      * Return vault address.
40      *
41      * @return address       vault address
42      */
43     function vault()
44         external
45         view
46         returns (address);
47 
48     /**
49      * Return address belonging to given exchangeId.
50      *
51      * @param  _exchangeId       ExchangeId number
52      * @return address           Address belonging to given exchangeId
53      */
54     function exchangeIds(
55         uint8 _exchangeId
56     )
57         external
58         view
59         returns (address);
60 
61     /*
62      * Returns if valid set
63      *
64      * @return  bool      Returns true if Set created through Core and isn't disabled
65      */
66     function validSets(address)
67         external
68         view
69         returns (bool);
70 
71     /*
72      * Returns if valid module
73      *
74      * @return  bool      Returns true if valid module
75      */
76     function validModules(address)
77         external
78         view
79         returns (bool);
80 
81     /**
82      * Return boolean indicating if address is a valid Rebalancing Price Library.
83      *
84      * @param  _priceLibrary    Price library address
85      * @return bool             Boolean indicating if valid Price Library
86      */
87     function validPriceLibraries(
88         address _priceLibrary
89     )
90         external
91         view
92         returns (bool);
93 
94     /**
95      * Exchanges components for Set Tokens
96      *
97      * @param  _set          Address of set to issue
98      * @param  _quantity     Quantity of set to issue
99      */
100     function issue(
101         address _set,
102         uint256 _quantity
103     )
104         external;
105 
106     /**
107      * Issues a specified Set for a specified quantity to the recipient
108      * using the caller's components from the wallet and vault.
109      *
110      * @param  _recipient    Address to issue to
111      * @param  _set          Address of the Set to issue
112      * @param  _quantity     Number of tokens to issue
113      */
114     function issueTo(
115         address _recipient,
116         address _set,
117         uint256 _quantity
118     )
119         external;
120 
121     /**
122      * Converts user's components into Set Tokens held directly in Vault instead of user's account
123      *
124      * @param _set          Address of the Set
125      * @param _quantity     Number of tokens to redeem
126      */
127     function issueInVault(
128         address _set,
129         uint256 _quantity
130     )
131         external;
132 
133     /**
134      * Function to convert Set Tokens into underlying components
135      *
136      * @param _set          The address of the Set token
137      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
138      */
139     function redeem(
140         address _set,
141         uint256 _quantity
142     )
143         external;
144 
145     /**
146      * Redeem Set token and return components to specified recipient. The components
147      * are left in the vault
148      *
149      * @param _recipient    Recipient of Set being issued
150      * @param _set          Address of the Set
151      * @param _quantity     Number of tokens to redeem
152      */
153     function redeemTo(
154         address _recipient,
155         address _set,
156         uint256 _quantity
157     )
158         external;
159 
160     /**
161      * Function to convert Set Tokens held in vault into underlying components
162      *
163      * @param _set          The address of the Set token
164      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
165      */
166     function redeemInVault(
167         address _set,
168         uint256 _quantity
169     )
170         external;
171 
172     /**
173      * Composite method to redeem and withdraw with a single transaction
174      *
175      * Normally, you should expect to be able to withdraw all of the tokens.
176      * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
177      * allows you to optionally specify which component tokens to exclude when
178      * redeeming. They will remain in the vault under the users' addresses.
179      *
180      * @param _set          Address of the Set
181      * @param _to           Address to withdraw or attribute tokens to
182      * @param _quantity     Number of tokens to redeem
183      * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
184      */
185     function redeemAndWithdrawTo(
186         address _set,
187         address _to,
188         uint256 _quantity,
189         uint256 _toExclude
190     )
191         external;
192 
193     /**
194      * Deposit multiple tokens to the vault. Quantities should be in the
195      * order of the addresses of the tokens being deposited.
196      *
197      * @param  _tokens           Array of the addresses of the ERC20 tokens
198      * @param  _quantities       Array of the number of tokens to deposit
199      */
200     function batchDeposit(
201         address[] calldata _tokens,
202         uint256[] calldata _quantities
203     )
204         external;
205 
206     /**
207      * Withdraw multiple tokens from the vault. Quantities should be in the
208      * order of the addresses of the tokens being withdrawn.
209      *
210      * @param  _tokens            Array of the addresses of the ERC20 tokens
211      * @param  _quantities        Array of the number of tokens to withdraw
212      */
213     function batchWithdraw(
214         address[] calldata _tokens,
215         uint256[] calldata _quantities
216     )
217         external;
218 
219     /**
220      * Deposit any quantity of tokens into the vault.
221      *
222      * @param  _token           The address of the ERC20 token
223      * @param  _quantity        The number of tokens to deposit
224      */
225     function deposit(
226         address _token,
227         uint256 _quantity
228     )
229         external;
230 
231     /**
232      * Withdraw a quantity of tokens from the vault.
233      *
234      * @param  _token           The address of the ERC20 token
235      * @param  _quantity        The number of tokens to withdraw
236      */
237     function withdraw(
238         address _token,
239         uint256 _quantity
240     )
241         external;
242 
243     /**
244      * Transfer tokens associated with the sender's account in vault to another user's
245      * account in vault.
246      *
247      * @param  _token           Address of token being transferred
248      * @param  _to              Address of user receiving tokens
249      * @param  _quantity        Amount of tokens being transferred
250      */
251     function internalTransfer(
252         address _token,
253         address _to,
254         uint256 _quantity
255     )
256         external;
257 
258     /**
259      * Deploys a new Set Token and adds it to the valid list of SetTokens
260      *
261      * @param  _factory              The address of the Factory to create from
262      * @param  _components           The address of component tokens
263      * @param  _units                The units of each component token
264      * @param  _naturalUnit          The minimum unit to be issued or redeemed
265      * @param  _name                 The bytes32 encoded name of the new Set
266      * @param  _symbol               The bytes32 encoded symbol of the new Set
267      * @param  _callData             Byte string containing additional call parameters
268      * @return setTokenAddress       The address of the new Set
269      */
270     function createSet(
271         address _factory,
272         address[] calldata _components,
273         uint256[] calldata _units,
274         uint256 _naturalUnit,
275         bytes32 _name,
276         bytes32 _symbol,
277         bytes calldata _callData
278     )
279         external
280         returns (address);
281 
282     /**
283      * Exposes internal function that deposits a quantity of tokens to the vault and attributes
284      * the tokens respectively, to system modules.
285      *
286      * @param  _from            Address to transfer tokens from
287      * @param  _to              Address to credit for deposit
288      * @param  _token           Address of token being deposited
289      * @param  _quantity        Amount of tokens to deposit
290      */
291     function depositModule(
292         address _from,
293         address _to,
294         address _token,
295         uint256 _quantity
296     )
297         external;
298 
299     /**
300      * Exposes internal function that withdraws a quantity of tokens from the vault and
301      * deattributes the tokens respectively, to system modules.
302      *
303      * @param  _from            Address to decredit for withdraw
304      * @param  _to              Address to transfer tokens to
305      * @param  _token           Address of token being withdrawn
306      * @param  _quantity        Amount of tokens to withdraw
307      */
308     function withdrawModule(
309         address _from,
310         address _to,
311         address _token,
312         uint256 _quantity
313     )
314         external;
315 
316     /**
317      * Exposes internal function that deposits multiple tokens to the vault, to system
318      * modules. Quantities should be in the order of the addresses of the tokens being
319      * deposited.
320      *
321      * @param  _from              Address to transfer tokens from
322      * @param  _to                Address to credit for deposits
323      * @param  _tokens            Array of the addresses of the tokens being deposited
324      * @param  _quantities        Array of the amounts of tokens to deposit
325      */
326     function batchDepositModule(
327         address _from,
328         address _to,
329         address[] calldata _tokens,
330         uint256[] calldata _quantities
331     )
332         external;
333 
334     /**
335      * Exposes internal function that withdraws multiple tokens from the vault, to system
336      * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
337      *
338      * @param  _from              Address to decredit for withdrawals
339      * @param  _to                Address to transfer tokens to
340      * @param  _tokens            Array of the addresses of the tokens being withdrawn
341      * @param  _quantities        Array of the amounts of tokens to withdraw
342      */
343     function batchWithdrawModule(
344         address _from,
345         address _to,
346         address[] calldata _tokens,
347         uint256[] calldata _quantities
348     )
349         external;
350 
351     /**
352      * Expose internal function that exchanges components for Set tokens,
353      * accepting any owner, to system modules
354      *
355      * @param  _owner        Address to use tokens from
356      * @param  _recipient    Address to issue Set to
357      * @param  _set          Address of the Set to issue
358      * @param  _quantity     Number of tokens to issue
359      */
360     function issueModule(
361         address _owner,
362         address _recipient,
363         address _set,
364         uint256 _quantity
365     )
366         external;
367 
368     /**
369      * Expose internal function that exchanges Set tokens for components,
370      * accepting any owner, to system modules
371      *
372      * @param  _burnAddress         Address to burn token from
373      * @param  _incrementAddress    Address to increment component tokens to
374      * @param  _set                 Address of the Set to redeem
375      * @param  _quantity            Number of tokens to redeem
376      */
377     function redeemModule(
378         address _burnAddress,
379         address _incrementAddress,
380         address _set,
381         uint256 _quantity
382     )
383         external;
384 
385     /**
386      * Expose vault function that increments user's balance in the vault.
387      * Available to system modules
388      *
389      * @param  _tokens          The addresses of the ERC20 tokens
390      * @param  _owner           The address of the token owner
391      * @param  _quantities      The numbers of tokens to attribute to owner
392      */
393     function batchIncrementTokenOwnerModule(
394         address[] calldata _tokens,
395         address _owner,
396         uint256[] calldata _quantities
397     )
398         external;
399 
400     /**
401      * Expose vault function that decrement user's balance in the vault
402      * Only available to system modules.
403      *
404      * @param  _tokens          The addresses of the ERC20 tokens
405      * @param  _owner           The address of the token owner
406      * @param  _quantities      The numbers of tokens to attribute to owner
407      */
408     function batchDecrementTokenOwnerModule(
409         address[] calldata _tokens,
410         address _owner,
411         uint256[] calldata _quantities
412     )
413         external;
414 
415     /**
416      * Expose vault function that transfer vault balances between users
417      * Only available to system modules.
418      *
419      * @param  _tokens           Addresses of tokens being transferred
420      * @param  _from             Address tokens being transferred from
421      * @param  _to               Address tokens being transferred to
422      * @param  _quantities       Amounts of tokens being transferred
423      */
424     function batchTransferBalanceModule(
425         address[] calldata _tokens,
426         address _from,
427         address _to,
428         uint256[] calldata _quantities
429     )
430         external;
431 
432     /**
433      * Transfers token from one address to another using the transfer proxy.
434      * Only available to system modules.
435      *
436      * @param  _token          The address of the ERC20 token
437      * @param  _quantity       The number of tokens to transfer
438      * @param  _from           The address to transfer from
439      * @param  _to             The address to transfer to
440      */
441     function transferModule(
442         address _token,
443         uint256 _quantity,
444         address _from,
445         address _to
446     )
447         external;
448 
449     /**
450      * Expose transfer proxy function to transfer tokens from one address to another
451      * Only available to system modules.
452      *
453      * @param  _tokens         The addresses of the ERC20 token
454      * @param  _quantities     The numbers of tokens to transfer
455      * @param  _from           The address to transfer from
456      * @param  _to             The address to transfer to
457      */
458     function batchTransferModule(
459         address[] calldata _tokens,
460         uint256[] calldata _quantities,
461         address _from,
462         address _to
463     )
464         external;
465 }
466 
467 // File: set-protocol-contracts/contracts/core/lib/RebalancingLibrary.sol
468 
469 /*
470     Copyright 2018 Set Labs Inc.
471 
472     Licensed under the Apache License, Version 2.0 (the "License");
473     you may not use this file except in compliance with the License.
474     You may obtain a copy of the License at
475 
476     http://www.apache.org/licenses/LICENSE-2.0
477 
478     Unless required by applicable law or agreed to in writing, software
479     distributed under the License is distributed on an "AS IS" BASIS,
480     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
481     See the License for the specific language governing permissions and
482     limitations under the License.
483 */
484 
485 pragma solidity 0.5.7;
486 
487 
488 /**
489  * @title RebalancingLibrary
490  * @author Set Protocol
491  *
492  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
493  * Rebalancing Set Tokens. Removes the old calculation functions
494  *
495  */
496 library RebalancingLibrary {
497 
498     /* ============ Enums ============ */
499 
500     enum State { Default, Proposal, Rebalance, Drawdown }
501 
502     /* ============ Structs ============ */
503 
504     struct AuctionPriceParameters {
505         uint256 auctionStartTime;
506         uint256 auctionTimeToPivot;
507         uint256 auctionStartPrice;
508         uint256 auctionPivotPrice;
509     }
510 
511     struct BiddingParameters {
512         uint256 minimumBid;
513         uint256 remainingCurrentSets;
514         uint256[] combinedCurrentUnits;
515         uint256[] combinedNextSetUnits;
516         address[] combinedTokenArray;
517     }
518 }
519 
520 // File: set-protocol-contracts/contracts/core/interfaces/IFeeCalculator.sol
521 
522 /*
523     Copyright 2019 Set Labs Inc.
524 
525     Licensed under the Apache License, Version 2.0 (the "License");
526     you may not use this file except in compliance with the License.
527     You may obtain a copy of the License at
528 
529     http://www.apache.org/licenses/LICENSE-2.0
530 
531     Unless required by applicable law or agreed to in writing, software
532     distributed under the License is distributed on an "AS IS" BASIS,
533     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
534     See the License for the specific language governing permissions and
535     limitations under the License.
536 */
537 
538 pragma solidity 0.5.7;
539 
540 /**
541  * @title IFeeCalculator
542  * @author Set Protocol
543  *
544  */
545 interface IFeeCalculator {
546 
547     /* ============ External Functions ============ */
548 
549     function initialize(
550         bytes calldata _feeCalculatorData
551     )
552         external;
553 
554     function getFee()
555         external
556         view
557         returns(uint256);
558 
559     function updateAndGetFee()
560         external
561         returns(uint256);
562 
563     function adjustFee(
564         bytes calldata _newFeeData
565     )
566         external;
567 }
568 
569 // File: set-protocol-contracts/contracts/core/interfaces/ISetToken.sol
570 
571 /*
572     Copyright 2018 Set Labs Inc.
573 
574     Licensed under the Apache License, Version 2.0 (the "License");
575     you may not use this file except in compliance with the License.
576     You may obtain a copy of the License at
577 
578     http://www.apache.org/licenses/LICENSE-2.0
579 
580     Unless required by applicable law or agreed to in writing, software
581     distributed under the License is distributed on an "AS IS" BASIS,
582     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
583     See the License for the specific language governing permissions and
584     limitations under the License.
585 */
586 
587 pragma solidity 0.5.7;
588 
589 /**
590  * @title ISetToken
591  * @author Set Protocol
592  *
593  * The ISetToken interface provides a light-weight, structured way to interact with the
594  * SetToken contract from another contract.
595  */
596 interface ISetToken {
597 
598     /* ============ External Functions ============ */
599 
600     /*
601      * Get natural unit of Set
602      *
603      * @return  uint256       Natural unit of Set
604      */
605     function naturalUnit()
606         external
607         view
608         returns (uint256);
609 
610     /*
611      * Get addresses of all components in the Set
612      *
613      * @return  componentAddresses       Array of component tokens
614      */
615     function getComponents()
616         external
617         view
618         returns (address[] memory);
619 
620     /*
621      * Get units of all tokens in Set
622      *
623      * @return  units       Array of component units
624      */
625     function getUnits()
626         external
627         view
628         returns (uint256[] memory);
629 
630     /*
631      * Checks to make sure token is component of Set
632      *
633      * @param  _tokenAddress     Address of token being checked
634      * @return  bool             True if token is component of Set
635      */
636     function tokenIsComponent(
637         address _tokenAddress
638     )
639         external
640         view
641         returns (bool);
642 
643     /*
644      * Mint set token for given address.
645      * Can only be called by authorized contracts.
646      *
647      * @param  _issuer      The address of the issuing account
648      * @param  _quantity    The number of sets to attribute to issuer
649      */
650     function mint(
651         address _issuer,
652         uint256 _quantity
653     )
654         external;
655 
656     /*
657      * Burn set token for given address
658      * Can only be called by authorized contracts
659      *
660      * @param  _from        The address of the redeeming account
661      * @param  _quantity    The number of sets to burn from redeemer
662      */
663     function burn(
664         address _from,
665         uint256 _quantity
666     )
667         external;
668 
669     /**
670     * Transfer token for a specified address
671     *
672     * @param to The address to transfer to.
673     * @param value The amount to be transferred.
674     */
675     function transfer(
676         address to,
677         uint256 value
678     )
679         external;
680 }
681 
682 // File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetToken.sol
683 
684 /*
685     Copyright 2018 Set Labs Inc.
686 
687     Licensed under the Apache License, Version 2.0 (the "License");
688     you may not use this file except in compliance with the License.
689     You may obtain a copy of the License at
690 
691     http://www.apache.org/licenses/LICENSE-2.0
692 
693     Unless required by applicable law or agreed to in writing, software
694     distributed under the License is distributed on an "AS IS" BASIS,
695     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
696     See the License for the specific language governing permissions and
697     limitations under the License.
698 */
699 
700 pragma solidity 0.5.7;
701 
702 
703 /**
704  * @title IRebalancingSetToken
705  * @author Set Protocol
706  *
707  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
708  * RebalancingSetToken contract from another contract.
709  */
710 
711 interface IRebalancingSetToken {
712 
713     /*
714      * Get the auction library contract used for the current rebalance
715      *
716      * @return address    Address of auction library used in the upcoming auction
717      */
718     function auctionLibrary()
719         external
720         view
721         returns (address);
722 
723     /*
724      * Get totalSupply of Rebalancing Set
725      *
726      * @return  totalSupply
727      */
728     function totalSupply()
729         external
730         view
731         returns (uint256);
732 
733     /*
734      * Get proposalTimeStamp of Rebalancing Set
735      *
736      * @return  proposalTimeStamp
737      */
738     function proposalStartTime()
739         external
740         view
741         returns (uint256);
742 
743     /*
744      * Get lastRebalanceTimestamp of Rebalancing Set
745      *
746      * @return  lastRebalanceTimestamp
747      */
748     function lastRebalanceTimestamp()
749         external
750         view
751         returns (uint256);
752 
753     /*
754      * Get rebalanceInterval of Rebalancing Set
755      *
756      * @return  rebalanceInterval
757      */
758     function rebalanceInterval()
759         external
760         view
761         returns (uint256);
762 
763     /*
764      * Get rebalanceState of Rebalancing Set
765      *
766      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
767      */
768     function rebalanceState()
769         external
770         view
771         returns (RebalancingLibrary.State);
772 
773     /*
774      * Get the starting amount of current SetToken for the current auction
775      *
776      * @return  rebalanceState
777      */
778     function startingCurrentSetAmount()
779         external
780         view
781         returns (uint256);
782 
783     /**
784      * Gets the balance of the specified address.
785      *
786      * @param owner      The address to query the balance of.
787      * @return           A uint256 representing the amount owned by the passed address.
788      */
789     function balanceOf(
790         address owner
791     )
792         external
793         view
794         returns (uint256);
795 
796     /**
797      * Function used to set the terms of the next rebalance and start the proposal period
798      *
799      * @param _nextSet                      The Set to rebalance into
800      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
801      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
802      * @param _auctionStartPrice            The price to start the auction at
803      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
804      */
805     function propose(
806         address _nextSet,
807         address _auctionLibrary,
808         uint256 _auctionTimeToPivot,
809         uint256 _auctionStartPrice,
810         uint256 _auctionPivotPrice
811     )
812         external;
813 
814     /*
815      * Get natural unit of Set
816      *
817      * @return  uint256       Natural unit of Set
818      */
819     function naturalUnit()
820         external
821         view
822         returns (uint256);
823 
824     /**
825      * Returns the address of the current base SetToken with the current allocation
826      *
827      * @return           A address representing the base SetToken
828      */
829     function currentSet()
830         external
831         view
832         returns (address);
833 
834     /**
835      * Returns the address of the next base SetToken with the post auction allocation
836      *
837      * @return  address    Address representing the base SetToken
838      */
839     function nextSet()
840         external
841         view
842         returns (address);
843 
844     /*
845      * Get the unit shares of the rebalancing Set
846      *
847      * @return  unitShares       Unit Shares of the base Set
848      */
849     function unitShares()
850         external
851         view
852         returns (uint256);
853 
854     /*
855      * Burn set token for given address.
856      * Can only be called by authorized contracts.
857      *
858      * @param  _from        The address of the redeeming account
859      * @param  _quantity    The number of sets to burn from redeemer
860      */
861     function burn(
862         address _from,
863         uint256 _quantity
864     )
865         external;
866 
867     /*
868      * Place bid during rebalance auction. Can only be called by Core.
869      *
870      * @param _quantity                 The amount of currentSet to be rebalanced
871      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
872      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
873      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
874      */
875     function placeBid(
876         uint256 _quantity
877     )
878         external
879         returns (address[] memory, uint256[] memory, uint256[] memory);
880 
881     /*
882      * Get combinedTokenArray of Rebalancing Set
883      *
884      * @return  combinedTokenArray
885      */
886     function getCombinedTokenArrayLength()
887         external
888         view
889         returns (uint256);
890 
891     /*
892      * Get combinedTokenArray of Rebalancing Set
893      *
894      * @return  combinedTokenArray
895      */
896     function getCombinedTokenArray()
897         external
898         view
899         returns (address[] memory);
900 
901     /*
902      * Get failedAuctionWithdrawComponents of Rebalancing Set
903      *
904      * @return  failedAuctionWithdrawComponents
905      */
906     function getFailedAuctionWithdrawComponents()
907         external
908         view
909         returns (address[] memory);
910 
911     /*
912      * Get auctionPriceParameters for current auction
913      *
914      * @return uint256[4]    AuctionPriceParameters for current rebalance auction
915      */
916     function getAuctionPriceParameters()
917         external
918         view
919         returns (uint256[] memory);
920 
921     /*
922      * Get biddingParameters for current auction
923      *
924      * @return uint256[2]    BiddingParameters for current rebalance auction
925      */
926     function getBiddingParameters()
927         external
928         view
929         returns (uint256[] memory);
930 
931     /*
932      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
933      * Sets that would be generated.
934      *
935      * @param _quantity               The amount of currentSet to be rebalanced
936      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
937      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
938      */
939     function getBidPrice(
940         uint256 _quantity
941     )
942         external
943         view
944         returns (uint256[] memory, uint256[] memory);
945 
946 }
947 
948 // File: set-protocol-contracts/contracts/core/lib/Rebalance.sol
949 
950 /*
951     Copyright 2019 Set Labs Inc.
952 
953     Licensed under the Apache License, Version 2.0 (the "License");
954     you may not use this file except in compliance with the License.
955     You may obtain a copy of the License at
956 
957     http://www.apache.org/licenses/LICENSE-2.0
958 
959     Unless required by applicable law or agreed to in writing, software
960     distributed under the License is distributed on an "AS IS" BASIS,
961     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
962     See the License for the specific language governing permissions and
963     limitations under the License.
964 */
965 
966 pragma solidity 0.5.7;
967 
968 
969 
970 /**
971  * @title Rebalance
972  * @author Set Protocol
973  *
974  * Types and functions for Rebalance-related data.
975  */
976 library Rebalance {
977 
978     struct TokenFlow {
979         address[] addresses;
980         uint256[] inflow;
981         uint256[] outflow;
982     }
983 
984     function composeTokenFlow(
985         address[] memory _addresses,
986         uint256[] memory _inflow,
987         uint256[] memory _outflow
988     )
989         internal
990         pure
991         returns(TokenFlow memory)
992     {
993         return TokenFlow({addresses: _addresses, inflow: _inflow, outflow: _outflow });
994     }
995 
996     function decomposeTokenFlow(TokenFlow memory _tokenFlow)
997         internal
998         pure
999         returns (address[] memory, uint256[] memory, uint256[] memory)
1000     {
1001         return (_tokenFlow.addresses, _tokenFlow.inflow, _tokenFlow.outflow);
1002     }
1003 
1004     function decomposeTokenFlowToBidPrice(TokenFlow memory _tokenFlow)
1005         internal
1006         pure
1007         returns (uint256[] memory, uint256[] memory)
1008     {
1009         return (_tokenFlow.inflow, _tokenFlow.outflow);
1010     }
1011 
1012     /**
1013      * Get token flows array of addresses, inflows and outflows
1014      *
1015      * @param    _rebalancingSetToken   The rebalancing Set Token instance
1016      * @param    _quantity              The amount of currentSet to be rebalanced
1017      * @return   combinedTokenArray     Array of token addresses
1018      * @return   inflowArray            Array of amount of tokens inserted into system in bid
1019      * @return   outflowArray           Array of amount of tokens returned from system in bid
1020      */
1021     function getTokenFlows(
1022         IRebalancingSetToken _rebalancingSetToken,
1023         uint256 _quantity
1024     )
1025         internal
1026         view
1027         returns (address[] memory, uint256[] memory, uint256[] memory)
1028     {
1029         // Get token addresses
1030         address[] memory combinedTokenArray = _rebalancingSetToken.getCombinedTokenArray();
1031 
1032         // Get inflow and outflow arrays for the given bid quantity
1033         (
1034             uint256[] memory inflowArray,
1035             uint256[] memory outflowArray
1036         ) = _rebalancingSetToken.getBidPrice(_quantity);
1037 
1038         return (combinedTokenArray, inflowArray, outflowArray);
1039     }
1040 }
1041 
1042 // File: set-protocol-contracts/contracts/core/interfaces/ILiquidator.sol
1043 
1044 /*
1045     Copyright 2019 Set Labs Inc.
1046 
1047     Licensed under the Apache License, Version 2.0 (the "License");
1048     you may not use this file except in compliance with the License.
1049     You may obtain a copy of the License at
1050 
1051     http://www.apache.org/licenses/LICENSE-2.0
1052 
1053     Unless required by applicable law or agreed to in writing, software
1054     distributed under the License is distributed on an "AS IS" BASIS,
1055     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1056     See the License for the specific language governing permissions and
1057     limitations under the License.
1058 */
1059 
1060 pragma solidity 0.5.7;
1061 
1062 
1063 
1064 
1065 /**
1066  * @title ILiquidator
1067  * @author Set Protocol
1068  *
1069  */
1070 interface ILiquidator {
1071 
1072     /* ============ External Functions ============ */
1073 
1074     function startRebalance(
1075         ISetToken _currentSet,
1076         ISetToken _nextSet,
1077         uint256 _startingCurrentSetQuantity,
1078         bytes calldata _liquidatorData
1079     )
1080         external;
1081 
1082     function getBidPrice(
1083         address _set,
1084         uint256 _quantity
1085     )
1086         external
1087         view
1088         returns (Rebalance.TokenFlow memory);
1089 
1090     function placeBid(
1091         uint256 _quantity
1092     )
1093         external
1094         returns (Rebalance.TokenFlow memory);
1095 
1096 
1097     function settleRebalance()
1098         external;
1099 
1100     function endFailedRebalance() external;
1101 
1102     // ----------------------------------------------------------------------
1103     // Auction Price
1104     // ----------------------------------------------------------------------
1105 
1106     function auctionPriceParameters(address _set)
1107         external
1108         view
1109         returns (RebalancingLibrary.AuctionPriceParameters memory);
1110 
1111     // ----------------------------------------------------------------------
1112     // Auction
1113     // ----------------------------------------------------------------------
1114 
1115     function hasRebalanceFailed(address _set) external view returns (bool);
1116     function minimumBid(address _set) external view returns (uint256);
1117     function startingCurrentSets(address _set) external view returns (uint256);
1118     function remainingCurrentSets(address _set) external view returns (uint256);
1119     function getCombinedCurrentSetUnits(address _set) external view returns (uint256[] memory);
1120     function getCombinedNextSetUnits(address _set) external view returns (uint256[] memory);
1121     function getCombinedTokenArray(address _set) external view returns (address[] memory);
1122 }
1123 
1124 // File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV2.sol
1125 
1126 /*
1127     Copyright 2019 Set Labs Inc.
1128 
1129     Licensed under the Apache License, Version 2.0 (the "License");
1130     you may not use this file except in compliance with the License.
1131     You may obtain a copy of the License at
1132 
1133     http://www.apache.org/licenses/LICENSE-2.0
1134 
1135     Unless required by applicable law or agreed to in writing, software
1136     distributed under the License is distributed on an "AS IS" BASIS,
1137     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1138     See the License for the specific language governing permissions and
1139     limitations under the License.
1140 */
1141 
1142 pragma solidity 0.5.7;
1143 
1144 
1145 
1146 
1147 
1148 /**
1149  * @title IRebalancingSetTokenV2
1150  * @author Set Protocol
1151  *
1152  * The IRebalancingSetTokenV2 interface provides a light-weight, structured way to interact with the
1153  * RebalancingSetTokenV2 contract from another contract.
1154  */
1155 
1156 interface IRebalancingSetTokenV2 {
1157 
1158     /*
1159      * Get totalSupply of Rebalancing Set
1160      *
1161      * @return  totalSupply
1162      */
1163     function totalSupply()
1164         external
1165         view
1166         returns (uint256);
1167 
1168     /**
1169      * Returns liquidator instance
1170      *
1171      * @return  ILiquidator    Liquidator instance
1172      */
1173     function liquidator()
1174         external
1175         view
1176         returns (ILiquidator);
1177 
1178     /*
1179      * Get lastRebalanceTimestamp of Rebalancing Set
1180      *
1181      * @return  lastRebalanceTimestamp
1182      */
1183     function lastRebalanceTimestamp()
1184         external
1185         view
1186         returns (uint256);
1187 
1188     /*
1189      * Get rebalanceStartTime of Rebalancing Set
1190      *
1191      * @return  rebalanceStartTime
1192      */
1193     function rebalanceStartTime()
1194         external
1195         view
1196         returns (uint256);
1197 
1198     /*
1199      * Get startingCurrentSets of RebalancingSetToken
1200      *
1201      * @return  startingCurrentSets
1202      */
1203     function startingCurrentSetAmount()
1204         external
1205         view
1206         returns (uint256);
1207 
1208     /*
1209      * Get rebalanceInterval of Rebalancing Set
1210      *
1211      * @return  rebalanceInterval
1212      */
1213     function rebalanceInterval()
1214         external
1215         view
1216         returns (uint256);
1217 
1218     /*
1219      * Get array returning [startTime, timeToPivot, startPrice, endPrice]
1220      *
1221      * @return  AuctionPriceParameters
1222      */
1223     function getAuctionPriceParameters() external view returns (uint256[] memory);
1224 
1225     /*
1226      * Get array returning [minimumBid, remainingCurrentSets]
1227      *
1228      * @return  BiddingParameters
1229      */
1230     function getBiddingParameters() external view returns (uint256[] memory);
1231 
1232     /*
1233      * Get rebalanceState of Rebalancing Set
1234      *
1235      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetTokenV2
1236      */
1237     function rebalanceState()
1238         external
1239         view
1240         returns (RebalancingLibrary.State);
1241 
1242     /**
1243      * Gets the balance of the specified address.
1244      *
1245      * @param owner      The address to query the balance of.
1246      * @return           A uint256 representing the amount owned by the passed address.
1247      */
1248     function balanceOf(
1249         address owner
1250     )
1251         external
1252         view
1253         returns (uint256);
1254 
1255     /*
1256      * Get manager of Rebalancing Set
1257      *
1258      * @return  manager
1259      */
1260     function manager()
1261         external
1262         view
1263         returns (address);
1264 
1265     /*
1266      * Get feeRecipient of Rebalancing Set
1267      *
1268      * @return  feeRecipient
1269      */
1270     function feeRecipient()
1271         external
1272         view
1273         returns (address);
1274 
1275     /*
1276      * Get entryFee of Rebalancing Set
1277      *
1278      * @return  entryFee
1279      */
1280     function entryFee()
1281         external
1282         view
1283         returns (uint256);
1284 
1285     /*
1286      * Retrieves the current expected fee from the fee calculator
1287      * Value is returned as a scale decimal figure.
1288      */
1289     function rebalanceFee()
1290         external
1291         view
1292         returns (uint256);
1293 
1294     /*
1295      * Get calculator contract used to compute rebalance fees
1296      *
1297      * @return  rebalanceFeeCalculator
1298      */
1299     function rebalanceFeeCalculator()
1300         external
1301         view
1302         returns (IFeeCalculator);
1303 
1304     /*
1305      * Initializes the RebalancingSetToken. Typically called by the Factory during creation
1306      */
1307     function initialize(
1308         bytes calldata _rebalanceFeeCalldata
1309     )
1310         external;
1311 
1312     /*
1313      * Set new liquidator address. Only whitelisted addresses are valid.
1314      */
1315     function setLiquidator(
1316         ILiquidator _newLiquidator
1317     )
1318         external;
1319 
1320     /*
1321      * Set new fee recipient address.
1322      */
1323     function setFeeRecipient(
1324         address _newFeeRecipient
1325     )
1326         external;
1327 
1328     /*
1329      * Set new fee entry fee.
1330      */
1331     function setEntryFee(
1332         uint256 _newEntryFee
1333     )
1334         external;
1335 
1336     /*
1337      * Initiates the rebalance in coordination with the Liquidator contract.
1338      * In this step, we redeem the currentSet and pass relevant information
1339      * to the liquidator.
1340      *
1341      * @param _nextSet                      The Set to rebalance into
1342      * @param _liquidatorData               Bytecode formatted data with liquidator-specific arguments
1343      *
1344      * Can only be called if the rebalance interval has elapsed.
1345      * Can only be called by manager.
1346      */
1347     function startRebalance(
1348         address _nextSet,
1349         bytes calldata _liquidatorData
1350 
1351     )
1352         external;
1353 
1354     /*
1355      * After a successful rebalance, the new Set is issued. If there is a rebalance fee,
1356      * the fee is paid via inflation of the Rebalancing Set to the feeRecipient.
1357      * Full issuance functionality is now returned to set owners.
1358      *
1359      * Anyone can call this function.
1360      */
1361     function settleRebalance()
1362         external;
1363 
1364     /*
1365      * Get natural unit of Set
1366      *
1367      * @return  uint256       Natural unit of Set
1368      */
1369     function naturalUnit()
1370         external
1371         view
1372         returns (uint256);
1373 
1374     /**
1375      * Returns the address of the current base SetToken with the current allocation
1376      *
1377      * @return           A address representing the base SetToken
1378      */
1379     function currentSet()
1380         external
1381         view
1382         returns (ISetToken);
1383 
1384     /**
1385      * Returns the address of the next base SetToken with the post auction allocation
1386      *
1387      * @return  address    Address representing the base SetToken
1388      */
1389     function nextSet()
1390         external
1391         view
1392         returns (ISetToken);
1393 
1394     /*
1395      * Get the unit shares of the rebalancing Set
1396      *
1397      * @return  unitShares       Unit Shares of the base Set
1398      */
1399     function unitShares()
1400         external
1401         view
1402         returns (uint256);
1403 
1404     /*
1405      * Place bid during rebalance auction. Can only be called by Core.
1406      *
1407      * @param _quantity                 The amount of currentSet to be rebalanced
1408      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
1409      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
1410      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
1411      */
1412     function placeBid(
1413         uint256 _quantity
1414     )
1415         external
1416         returns (address[] memory, uint256[] memory, uint256[] memory);
1417 
1418     /*
1419      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
1420      * Sets that would be generated.
1421      *
1422      * @param _quantity               The amount of currentSet to be rebalanced
1423      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
1424      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
1425      */
1426     function getBidPrice(
1427         uint256 _quantity
1428     )
1429         external
1430         view
1431         returns (uint256[] memory, uint256[] memory);
1432 
1433     /*
1434      * Get name of Rebalancing Set
1435      *
1436      * @return  name
1437      */
1438     function name()
1439         external
1440         view
1441         returns (string memory);
1442 
1443     /*
1444      * Get symbol of Rebalancing Set
1445      *
1446      * @return  symbol
1447      */
1448     function symbol()
1449         external
1450         view
1451         returns (string memory);
1452 }
1453 
1454 // File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV3.sol
1455 
1456 /*
1457     Copyright 2020 Set Labs Inc.
1458 
1459     Licensed under the Apache License, Version 2.0 (the "License");
1460     you may not use this file except in compliance with the License.
1461     You may obtain a copy of the License at
1462 
1463     http://www.apache.org/licenses/LICENSE-2.0
1464 
1465     Unless required by applicable law or agreed to in writing, software
1466     distributed under the License is distributed on an "AS IS" BASIS,
1467     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1468     See the License for the specific language governing permissions and
1469     limitations under the License.
1470 */
1471 
1472 pragma solidity 0.5.7;
1473 
1474 
1475 
1476 
1477 
1478 /**
1479  * @title IRebalancingSetTokenV2
1480  * @author Set Protocol
1481  *
1482  * The IRebalancingSetTokenV3 interface provides a light-weight, structured way to interact with the
1483  * RebalancingSetTokenV3 contract from another contract.
1484  */
1485 
1486 interface IRebalancingSetTokenV3 {
1487 
1488     /*
1489      * Get totalSupply of Rebalancing Set
1490      *
1491      * @return  totalSupply
1492      */
1493     function totalSupply()
1494         external
1495         view
1496         returns (uint256);
1497 
1498     /**
1499      * Returns liquidator instance
1500      *
1501      * @return  ILiquidator    Liquidator instance
1502      */
1503     function liquidator()
1504         external
1505         view
1506         returns (ILiquidator);
1507 
1508     /*
1509      * Get lastRebalanceTimestamp of Rebalancing Set
1510      *
1511      * @return  lastRebalanceTimestamp
1512      */
1513     function lastRebalanceTimestamp()
1514         external
1515         view
1516         returns (uint256);
1517 
1518     /*
1519      * Get rebalanceStartTime of Rebalancing Set
1520      *
1521      * @return  rebalanceStartTime
1522      */
1523     function rebalanceStartTime()
1524         external
1525         view
1526         returns (uint256);
1527 
1528     /*
1529      * Get startingCurrentSets of RebalancingSetToken
1530      *
1531      * @return  startingCurrentSets
1532      */
1533     function startingCurrentSetAmount()
1534         external
1535         view
1536         returns (uint256);
1537 
1538     /*
1539      * Get rebalanceInterval of Rebalancing Set
1540      *
1541      * @return  rebalanceInterval
1542      */
1543     function rebalanceInterval()
1544         external
1545         view
1546         returns (uint256);
1547 
1548     /*
1549      * Get array returning [startTime, timeToPivot, startPrice, endPrice]
1550      *
1551      * @return  AuctionPriceParameters
1552      */
1553     function getAuctionPriceParameters() external view returns (uint256[] memory);
1554 
1555     /*
1556      * Get array returning [minimumBid, remainingCurrentSets]
1557      *
1558      * @return  BiddingParameters
1559      */
1560     function getBiddingParameters() external view returns (uint256[] memory);
1561 
1562     /*
1563      * Get rebalanceState of Rebalancing Set
1564      *
1565      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetTokenV3
1566      */
1567     function rebalanceState()
1568         external
1569         view
1570         returns (RebalancingLibrary.State);
1571 
1572     /**
1573      * Gets the balance of the specified address.
1574      *
1575      * @param owner      The address to query the balance of.
1576      * @return           A uint256 representing the amount owned by the passed address.
1577      */
1578     function balanceOf(
1579         address owner
1580     )
1581         external
1582         view
1583         returns (uint256);
1584 
1585     /*
1586      * Get manager of Rebalancing Set
1587      *
1588      * @return  manager
1589      */
1590     function manager()
1591         external
1592         view
1593         returns (address);
1594 
1595     /*
1596      * Get feeRecipient of Rebalancing Set
1597      *
1598      * @return  feeRecipient
1599      */
1600     function feeRecipient()
1601         external
1602         view
1603         returns (address);
1604 
1605     /*
1606      * Get entryFee of Rebalancing Set
1607      *
1608      * @return  entryFee
1609      */
1610     function entryFee()
1611         external
1612         view
1613         returns (uint256);
1614 
1615     /*
1616      * Retrieves the current expected fee from the fee calculator
1617      * Value is returned as a scale decimal figure.
1618      */
1619     function rebalanceFee()
1620         external
1621         view
1622         returns (uint256);
1623 
1624     /*
1625      * Get calculator contract used to compute rebalance fees
1626      *
1627      * @return  rebalanceFeeCalculator
1628      */
1629     function rebalanceFeeCalculator()
1630         external
1631         view
1632         returns (IFeeCalculator);
1633 
1634     /*
1635      * Initializes the RebalancingSetToken. Typically called by the Factory during creation
1636      */
1637     function initialize(
1638         bytes calldata _rebalanceFeeCalldata
1639     )
1640         external;
1641 
1642     /*
1643      * Set new liquidator address. Only whitelisted addresses are valid.
1644      */
1645     function setLiquidator(
1646         ILiquidator _newLiquidator
1647     )
1648         external;
1649 
1650     /*
1651      * Set new fee recipient address.
1652      */
1653     function setFeeRecipient(
1654         address _newFeeRecipient
1655     )
1656         external;
1657 
1658     /*
1659      * Set new fee entry fee.
1660      */
1661     function setEntryFee(
1662         uint256 _newEntryFee
1663     )
1664         external;
1665 
1666     /*
1667      * Initiates the rebalance in coordination with the Liquidator contract.
1668      * In this step, we redeem the currentSet and pass relevant information
1669      * to the liquidator.
1670      *
1671      * @param _nextSet                      The Set to rebalance into
1672      * @param _liquidatorData               Bytecode formatted data with liquidator-specific arguments
1673      *
1674      * Can only be called if the rebalance interval has elapsed.
1675      * Can only be called by manager.
1676      */
1677     function startRebalance(
1678         address _nextSet,
1679         bytes calldata _liquidatorData
1680 
1681     )
1682         external;
1683 
1684     /*
1685      * After a successful rebalance, the new Set is issued. If there is a rebalance fee,
1686      * the fee is paid via inflation of the Rebalancing Set to the feeRecipient.
1687      * Full issuance functionality is now returned to set owners.
1688      *
1689      * Anyone can call this function.
1690      */
1691     function settleRebalance()
1692         external;
1693 
1694     /*
1695      * During the Default stage, the incentive / rebalance Fee can be triggered. This will
1696      * retrieve the current inflation fee from the fee calulator and mint the according
1697      * inflation to the feeRecipient. The unit shares is then adjusted based on the new
1698      * supply.
1699      *
1700      * Anyone can call this function.
1701      */
1702     function actualizeFee()
1703         external;
1704 
1705     /*
1706      * Validate then set new streaming fee.
1707      *
1708      * @param  _newFeeData       Fee type and new streaming fee encoded in bytes
1709      */
1710     function adjustFee(
1711         bytes calldata _newFeeData
1712     )
1713         external;
1714 
1715     /*
1716      * Get natural unit of Set
1717      *
1718      * @return  uint256       Natural unit of Set
1719      */
1720     function naturalUnit()
1721         external
1722         view
1723         returns (uint256);
1724 
1725     /**
1726      * Returns the address of the current base SetToken with the current allocation
1727      *
1728      * @return           A address representing the base SetToken
1729      */
1730     function currentSet()
1731         external
1732         view
1733         returns (ISetToken);
1734 
1735     /**
1736      * Returns the address of the next base SetToken with the post auction allocation
1737      *
1738      * @return  address    Address representing the base SetToken
1739      */
1740     function nextSet()
1741         external
1742         view
1743         returns (ISetToken);
1744 
1745     /*
1746      * Get the unit shares of the rebalancing Set
1747      *
1748      * @return  unitShares       Unit Shares of the base Set
1749      */
1750     function unitShares()
1751         external
1752         view
1753         returns (uint256);
1754 
1755     /*
1756      * Place bid during rebalance auction. Can only be called by Core.
1757      *
1758      * @param _quantity                 The amount of currentSet to be rebalanced
1759      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
1760      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
1761      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
1762      */
1763     function placeBid(
1764         uint256 _quantity
1765     )
1766         external
1767         returns (address[] memory, uint256[] memory, uint256[] memory);
1768 
1769     /*
1770      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
1771      * Sets that would be generated.
1772      *
1773      * @param _quantity               The amount of currentSet to be rebalanced
1774      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
1775      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
1776      */
1777     function getBidPrice(
1778         uint256 _quantity
1779     )
1780         external
1781         view
1782         returns (uint256[] memory, uint256[] memory);
1783 
1784     /*
1785      * Get name of Rebalancing Set
1786      *
1787      * @return  name
1788      */
1789     function name()
1790         external
1791         view
1792         returns (string memory);
1793 
1794     /*
1795      * Get symbol of Rebalancing Set
1796      *
1797      * @return  symbol
1798      */
1799     function symbol()
1800         external
1801         view
1802         returns (string memory);
1803 }
1804 
1805 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1806 
1807 pragma solidity ^0.5.2;
1808 
1809 /**
1810  * @title SafeMath
1811  * @dev Unsigned math operations with safety checks that revert on error
1812  */
1813 library SafeMath {
1814     /**
1815      * @dev Multiplies two unsigned integers, reverts on overflow.
1816      */
1817     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1818         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1819         // benefit is lost if 'b' is also tested.
1820         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1821         if (a == 0) {
1822             return 0;
1823         }
1824 
1825         uint256 c = a * b;
1826         require(c / a == b);
1827 
1828         return c;
1829     }
1830 
1831     /**
1832      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1833      */
1834     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1835         // Solidity only automatically asserts when dividing by 0
1836         require(b > 0);
1837         uint256 c = a / b;
1838         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1839 
1840         return c;
1841     }
1842 
1843     /**
1844      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1845      */
1846     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1847         require(b <= a);
1848         uint256 c = a - b;
1849 
1850         return c;
1851     }
1852 
1853     /**
1854      * @dev Adds two unsigned integers, reverts on overflow.
1855      */
1856     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1857         uint256 c = a + b;
1858         require(c >= a);
1859 
1860         return c;
1861     }
1862 
1863     /**
1864      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1865      * reverts when dividing by zero.
1866      */
1867     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1868         require(b != 0);
1869         return a % b;
1870     }
1871 }
1872 
1873 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1874 
1875 pragma solidity ^0.5.2;
1876 
1877 /**
1878  * @title Ownable
1879  * @dev The Ownable contract has an owner address, and provides basic authorization control
1880  * functions, this simplifies the implementation of "user permissions".
1881  */
1882 contract Ownable {
1883     address private _owner;
1884 
1885     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1886 
1887     /**
1888      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1889      * account.
1890      */
1891     constructor () internal {
1892         _owner = msg.sender;
1893         emit OwnershipTransferred(address(0), _owner);
1894     }
1895 
1896     /**
1897      * @return the address of the owner.
1898      */
1899     function owner() public view returns (address) {
1900         return _owner;
1901     }
1902 
1903     /**
1904      * @dev Throws if called by any account other than the owner.
1905      */
1906     modifier onlyOwner() {
1907         require(isOwner());
1908         _;
1909     }
1910 
1911     /**
1912      * @return true if `msg.sender` is the owner of the contract.
1913      */
1914     function isOwner() public view returns (bool) {
1915         return msg.sender == _owner;
1916     }
1917 
1918     /**
1919      * @dev Allows the current owner to relinquish control of the contract.
1920      * It will not be possible to call the functions with the `onlyOwner`
1921      * modifier anymore.
1922      * @notice Renouncing ownership will leave the contract without an owner,
1923      * thereby removing any functionality that is only available to the owner.
1924      */
1925     function renounceOwnership() public onlyOwner {
1926         emit OwnershipTransferred(_owner, address(0));
1927         _owner = address(0);
1928     }
1929 
1930     /**
1931      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1932      * @param newOwner The address to transfer ownership to.
1933      */
1934     function transferOwnership(address newOwner) public onlyOwner {
1935         _transferOwnership(newOwner);
1936     }
1937 
1938     /**
1939      * @dev Transfers control of the contract to a newOwner.
1940      * @param newOwner The address to transfer ownership to.
1941      */
1942     function _transferOwnership(address newOwner) internal {
1943         require(newOwner != address(0));
1944         emit OwnershipTransferred(_owner, newOwner);
1945         _owner = newOwner;
1946     }
1947 }
1948 
1949 // File: set-protocol-contracts/contracts/lib/TimeLockUpgrade.sol
1950 
1951 /*
1952     Copyright 2018 Set Labs Inc.
1953 
1954     Licensed under the Apache License, Version 2.0 (the "License");
1955     you may not use this file except in compliance with the License.
1956     You may obtain a copy of the License at
1957 
1958     http://www.apache.org/licenses/LICENSE-2.0
1959 
1960     Unless required by applicable law or agreed to in writing, software
1961     distributed under the License is distributed on an "AS IS" BASIS,
1962     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1963     See the License for the specific language governing permissions and
1964     limitations under the License.
1965 */
1966 
1967 pragma solidity 0.5.7;
1968 
1969 
1970 
1971 
1972 /**
1973  * @title TimeLockUpgrade
1974  * @author Set Protocol
1975  *
1976  * The TimeLockUpgrade contract contains a modifier for handling minimum time period updates
1977  */
1978 contract TimeLockUpgrade is
1979     Ownable
1980 {
1981     using SafeMath for uint256;
1982 
1983     /* ============ State Variables ============ */
1984 
1985     // Timelock Upgrade Period in seconds
1986     uint256 public timeLockPeriod;
1987 
1988     // Mapping of upgradable units and initialized timelock
1989     mapping(bytes32 => uint256) public timeLockedUpgrades;
1990 
1991     /* ============ Events ============ */
1992 
1993     event UpgradeRegistered(
1994         bytes32 _upgradeHash,
1995         uint256 _timestamp
1996     );
1997 
1998     /* ============ Modifiers ============ */
1999 
2000     modifier timeLockUpgrade() {
2001         // If the time lock period is 0, then allow non-timebound upgrades.
2002         // This is useful for initialization of the protocol and for testing.
2003         if (timeLockPeriod == 0) {
2004             _;
2005 
2006             return;
2007         }
2008 
2009         // The upgrade hash is defined by the hash of the transaction call data,
2010         // which uniquely identifies the function as well as the passed in arguments.
2011         bytes32 upgradeHash = keccak256(
2012             abi.encodePacked(
2013                 msg.data
2014             )
2015         );
2016 
2017         uint256 registrationTime = timeLockedUpgrades[upgradeHash];
2018 
2019         // If the upgrade hasn't been registered, register with the current time.
2020         if (registrationTime == 0) {
2021             timeLockedUpgrades[upgradeHash] = block.timestamp;
2022 
2023             emit UpgradeRegistered(
2024                 upgradeHash,
2025                 block.timestamp
2026             );
2027 
2028             return;
2029         }
2030 
2031         require(
2032             block.timestamp >= registrationTime.add(timeLockPeriod),
2033             "TimeLockUpgrade: Time lock period must have elapsed."
2034         );
2035 
2036         // Reset the timestamp to 0
2037         timeLockedUpgrades[upgradeHash] = 0;
2038 
2039         // Run the rest of the upgrades
2040         _;
2041     }
2042 
2043     /* ============ Function ============ */
2044 
2045     /**
2046      * Change timeLockPeriod period. Generally called after initially settings have been set up.
2047      *
2048      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
2049      */
2050     function setTimeLockPeriod(
2051         uint256 _timeLockPeriod
2052     )
2053         external
2054         onlyOwner
2055     {
2056         // Only allow setting of the timeLockPeriod if the period is greater than the existing
2057         require(
2058             _timeLockPeriod > timeLockPeriod,
2059             "TimeLockUpgrade: New period must be greater than existing"
2060         );
2061 
2062         timeLockPeriod = _timeLockPeriod;
2063     }
2064 }
2065 
2066 // File: set-protocol-contracts/contracts/lib/UnrestrictedTimeLockUpgrade.sol
2067 
2068 /*
2069     Copyright 2020 Set Labs Inc.
2070 
2071     Licensed under the Apache License, Version 2.0 (the "License");
2072     you may not use this file except in compliance with the License.
2073     You may obtain a copy of the License at
2074 
2075     http://www.apache.org/licenses/LICENSE-2.0
2076 
2077     Unless required by applicable law or agreed to in writing, software
2078     distributed under the License is distributed on an "AS IS" BASIS,
2079     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2080     See the License for the specific language governing permissions and
2081     limitations under the License.
2082 */
2083 
2084 pragma solidity 0.5.7;
2085 
2086 
2087 
2088 
2089 /**
2090  * @title UnrestrictedTimeLockUpgrade
2091  * @author Set Protocol
2092  *
2093  * The UnrestrictedTimeLockUpgrade contract inherits a modifier for handling minimum time period updates not
2094  * limited to the owner of the contract. Also implements a removeTimeLockUpgrade internal function that can
2095  * be exposed by writing an external version into the contract it used in with the required modifiers to
2096  * restrict access.
2097  */
2098 
2099 contract UnrestrictedTimeLockUpgrade is
2100     TimeLockUpgrade
2101 {
2102     /* ============ Events ============ */
2103 
2104     event RemoveRegisteredUpgrade(
2105         bytes32 indexed _upgradeHash
2106     );
2107 
2108     /* ============ Internal Function ============ */
2109 
2110     /**
2111      * Removes an existing upgrade.
2112      *
2113      * @param  _upgradeHash    Keccack256 hash that uniquely identifies function called and arguments
2114      */
2115     function removeRegisteredUpgradeInternal(
2116         bytes32 _upgradeHash
2117     )
2118         internal
2119     {
2120         require(
2121             timeLockedUpgrades[_upgradeHash] != 0,
2122             "TimeLockUpgradeV2.removeRegisteredUpgrade: Upgrade hash must be registered"
2123         );
2124 
2125         // Reset the timestamp to 0
2126         timeLockedUpgrades[_upgradeHash] = 0;
2127 
2128         emit RemoveRegisteredUpgrade(
2129             _upgradeHash
2130         );
2131     }
2132 }
2133 
2134 // File: set-protocol-contracts/contracts/lib/LimitOneUpgrade.sol
2135 
2136 /*
2137     Copyright 2020 Set Labs Inc.
2138 
2139     Licensed under the Apache License, Version 2.0 (the "License");
2140     you may not use this file except in compliance with the License.
2141     You may obtain a copy of the License at
2142 
2143     http://www.apache.org/licenses/LICENSE-2.0
2144 
2145     Unless required by applicable law or agreed to in writing, software
2146     distributed under the License is distributed on an "AS IS" BASIS,
2147     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2148     See the License for the specific language governing permissions and
2149     limitations under the License.
2150 */
2151 
2152 pragma solidity 0.5.7;
2153 
2154 
2155 
2156 /**
2157  * @title LimitOneUpgrade
2158  * @author Set Protocol
2159  *
2160  * For function that must be timelocked but could potentially have more than one upgrade at a time
2161  * this contract allows one to limit the amount of simultaneous upgrades.
2162  */
2163 
2164 contract LimitOneUpgrade is
2165     UnrestrictedTimeLockUpgrade
2166 {
2167     /* ============ State Variables ============ */
2168 
2169     mapping(address => bytes32) public upgradeIdentifier;
2170 
2171     /* ============ Modifier ============ */
2172 
2173     /**
2174      * This modifier must be used in conjunction with timeLockUpgrade AND must be called before
2175      * timeLockUpgrade is called. UpgradeAddress must also be part of the msg.data.
2176      */
2177     modifier limitOneUpgrade(address _upgradeAddress) {
2178         if (timeLockPeriod > 0) {
2179             // Get upgradeHash
2180             bytes32 upgradeHash = keccak256(msg.data);
2181 
2182             if (upgradeIdentifier[_upgradeAddress] != 0) {
2183                 // If upgrade hash has no record then revert since must be second upgrade
2184                 require(
2185                     upgradeIdentifier[_upgradeAddress] == upgradeHash,
2186                     "Another update already in progress."
2187                 );
2188 
2189                 upgradeIdentifier[_upgradeAddress] = 0;
2190 
2191             } else {
2192                 upgradeIdentifier[_upgradeAddress] = upgradeHash;
2193             }
2194         }
2195         _;
2196     }
2197 
2198     /**
2199      * Verifies that upgrade address matches with hash of upgrade. Removes upgrade from timelockUpgrades
2200      * and sets upgradeIdentifier to 0 for passed upgradeAddress, allowing for another upgrade.
2201      *
2202      * @param _upgradeAddress       The address of the trading pool being updated
2203      * @param _upgradeHash          Keccack256 hash that uniquely identifies function called and arguments
2204      */
2205     function removeRegisteredUpgradeInternal(
2206         address _upgradeAddress,
2207         bytes32 _upgradeHash
2208     )
2209         internal
2210     {
2211         require(
2212             upgradeIdentifier[_upgradeAddress] == _upgradeHash,
2213             "Passed upgrade hash does not match upgrade address."
2214         );
2215 
2216         UnrestrictedTimeLockUpgrade.removeRegisteredUpgradeInternal(_upgradeHash);
2217 
2218         upgradeIdentifier[_upgradeAddress] = 0;
2219     }
2220 }
2221 
2222 // File: set-protocol-contracts/contracts/lib/AddressArrayUtils.sol
2223 
2224 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
2225 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
2226 
2227 pragma solidity 0.5.7;
2228 
2229 
2230 library AddressArrayUtils {
2231 
2232     /**
2233      * Finds the index of the first occurrence of the given element.
2234      * @param A The input array to search
2235      * @param a The value to find
2236      * @return Returns (index and isIn) for the first occurrence starting from index 0
2237      */
2238     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
2239         uint256 length = A.length;
2240         for (uint256 i = 0; i < length; i++) {
2241             if (A[i] == a) {
2242                 return (i, true);
2243             }
2244         }
2245         return (0, false);
2246     }
2247 
2248     /**
2249     * Returns true if the value is present in the list. Uses indexOf internally.
2250     * @param A The input array to search
2251     * @param a The value to find
2252     * @return Returns isIn for the first occurrence starting from index 0
2253     */
2254     function contains(address[] memory A, address a) internal pure returns (bool) {
2255         bool isIn;
2256         (, isIn) = indexOf(A, a);
2257         return isIn;
2258     }
2259 
2260     /**
2261      * Returns the combination of the two arrays
2262      * @param A The first array
2263      * @param B The second array
2264      * @return Returns A extended by B
2265      */
2266     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
2267         uint256 aLength = A.length;
2268         uint256 bLength = B.length;
2269         address[] memory newAddresses = new address[](aLength + bLength);
2270         for (uint256 i = 0; i < aLength; i++) {
2271             newAddresses[i] = A[i];
2272         }
2273         for (uint256 j = 0; j < bLength; j++) {
2274             newAddresses[aLength + j] = B[j];
2275         }
2276         return newAddresses;
2277     }
2278 
2279     /**
2280      * Returns the array with a appended to A.
2281      * @param A The first array
2282      * @param a The value to append
2283      * @return Returns A appended by a
2284      */
2285     function append(address[] memory A, address a) internal pure returns (address[] memory) {
2286         address[] memory newAddresses = new address[](A.length + 1);
2287         for (uint256 i = 0; i < A.length; i++) {
2288             newAddresses[i] = A[i];
2289         }
2290         newAddresses[A.length] = a;
2291         return newAddresses;
2292     }
2293 
2294     /**
2295      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
2296      * @param A The first array
2297      * @param B The second array
2298      * @return The intersection of the two arrays
2299      */
2300     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
2301         uint256 length = A.length;
2302         bool[] memory includeMap = new bool[](length);
2303         uint256 newLength = 0;
2304         for (uint256 i = 0; i < length; i++) {
2305             if (contains(B, A[i])) {
2306                 includeMap[i] = true;
2307                 newLength++;
2308             }
2309         }
2310         address[] memory newAddresses = new address[](newLength);
2311         uint256 j = 0;
2312         for (uint256 k = 0; k < length; k++) {
2313             if (includeMap[k]) {
2314                 newAddresses[j] = A[k];
2315                 j++;
2316             }
2317         }
2318         return newAddresses;
2319     }
2320 
2321     /**
2322      * Returns the union of the two arrays. Order is not guaranteed.
2323      * @param A The first array
2324      * @param B The second array
2325      * @return The union of the two arrays
2326      */
2327     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
2328         address[] memory leftDifference = difference(A, B);
2329         address[] memory rightDifference = difference(B, A);
2330         address[] memory intersection = intersect(A, B);
2331         return extend(leftDifference, extend(intersection, rightDifference));
2332     }
2333 
2334     /**
2335      * Computes the difference of two arrays. Assumes there are no duplicates.
2336      * @param A The first array
2337      * @param B The second array
2338      * @return The difference of the two arrays
2339      */
2340     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
2341         uint256 length = A.length;
2342         bool[] memory includeMap = new bool[](length);
2343         uint256 count = 0;
2344         // First count the new length because can't push for in-memory arrays
2345         for (uint256 i = 0; i < length; i++) {
2346             address e = A[i];
2347             if (!contains(B, e)) {
2348                 includeMap[i] = true;
2349                 count++;
2350             }
2351         }
2352         address[] memory newAddresses = new address[](count);
2353         uint256 j = 0;
2354         for (uint256 k = 0; k < length; k++) {
2355             if (includeMap[k]) {
2356                 newAddresses[j] = A[k];
2357                 j++;
2358             }
2359         }
2360         return newAddresses;
2361     }
2362 
2363     /**
2364     * Removes specified index from array
2365     * Resulting ordering is not guaranteed
2366     * @return Returns the new array and the removed entry
2367     */
2368     function pop(address[] memory A, uint256 index)
2369         internal
2370         pure
2371         returns (address[] memory, address)
2372     {
2373         uint256 length = A.length;
2374         address[] memory newAddresses = new address[](length - 1);
2375         for (uint256 i = 0; i < index; i++) {
2376             newAddresses[i] = A[i];
2377         }
2378         for (uint256 j = index + 1; j < length; j++) {
2379             newAddresses[j - 1] = A[j];
2380         }
2381         return (newAddresses, A[index]);
2382     }
2383 
2384     /**
2385      * @return Returns the new array
2386      */
2387     function remove(address[] memory A, address a)
2388         internal
2389         pure
2390         returns (address[] memory)
2391     {
2392         (uint256 index, bool isIn) = indexOf(A, a);
2393         if (!isIn) {
2394             revert();
2395         } else {
2396             (address[] memory _A,) = pop(A, index);
2397             return _A;
2398         }
2399     }
2400 
2401     /**
2402      * Returns whether or not there's a duplicate. Runs in O(n^2).
2403      * @param A Array to search
2404      * @return Returns true if duplicate, false otherwise
2405      */
2406     function hasDuplicate(address[] memory A) internal pure returns (bool) {
2407         if (A.length == 0) {
2408             return false;
2409         }
2410         for (uint256 i = 0; i < A.length - 1; i++) {
2411             for (uint256 j = i + 1; j < A.length; j++) {
2412                 if (A[i] == A[j]) {
2413                     return true;
2414                 }
2415             }
2416         }
2417         return false;
2418     }
2419 
2420     /**
2421      * Returns whether the two arrays are equal.
2422      * @param A The first array
2423      * @param B The second array
2424      * @return True is the arrays are equal, false if not.
2425      */
2426     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
2427         if (A.length != B.length) {
2428             return false;
2429         }
2430         for (uint256 i = 0; i < A.length; i++) {
2431             if (A[i] != B[i]) {
2432                 return false;
2433             }
2434         }
2435         return true;
2436     }
2437 }
2438 
2439 // File: set-protocol-contracts/contracts/lib/WhiteList.sol
2440 
2441 /*
2442     Copyright 2018 Set Labs Inc.
2443 
2444     Licensed under the Apache License, Version 2.0 (the "License");
2445     you may not use this file except in compliance with the License.
2446     You may obtain a copy of the License at
2447 
2448     http://www.apache.org/licenses/LICENSE-2.0
2449 
2450     Unless required by applicable law or agreed to in writing, software
2451     distributed under the License is distributed on an "AS IS" BASIS,
2452     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2453     See the License for the specific language governing permissions and
2454     limitations under the License.
2455 */
2456 
2457 pragma solidity 0.5.7;
2458 
2459 
2460 
2461 
2462 
2463 /**
2464  * @title Whitelist
2465  * @author Set Protocol
2466  *
2467  * Generic whitelist for addresses
2468  */
2469 contract WhiteList is
2470     Ownable,
2471     TimeLockUpgrade
2472 {
2473     using AddressArrayUtils for address[];
2474 
2475     /* ============ State Variables ============ */
2476 
2477     address[] public addresses;
2478     mapping(address => bool) public whiteList;
2479 
2480     /* ============ Events ============ */
2481 
2482     event AddressAdded(
2483         address _address
2484     );
2485 
2486     event AddressRemoved(
2487         address _address
2488     );
2489 
2490     /* ============ Constructor ============ */
2491 
2492     /**
2493      * Constructor function for Whitelist
2494      *
2495      * Allow initial addresses to be passed in so a separate transaction is not required for each
2496      *
2497      * @param _initialAddresses    Starting set of addresses to whitelist
2498      */
2499     constructor(
2500         address[] memory _initialAddresses
2501     )
2502         public
2503     {
2504         // Add each of initial addresses to state
2505         for (uint256 i = 0; i < _initialAddresses.length; i++) {
2506             address addressToAdd = _initialAddresses[i];
2507 
2508             addresses.push(addressToAdd);
2509             whiteList[addressToAdd] = true;
2510         }
2511     }
2512 
2513     /* ============ External Functions ============ */
2514 
2515     /**
2516      * Add an address to the whitelist
2517      *
2518      * @param _address    Address to add to the whitelist
2519      */
2520     function addAddress(
2521         address _address
2522     )
2523         external
2524         onlyOwner
2525         timeLockUpgrade
2526     {
2527         require(
2528             !whiteList[_address],
2529             "WhiteList.addAddress: Address has already been whitelisted."
2530         );
2531 
2532         addresses.push(_address);
2533 
2534         whiteList[_address] = true;
2535 
2536         emit AddressAdded(
2537             _address
2538         );
2539     }
2540 
2541     /**
2542      * Remove an address from the whitelist
2543      *
2544      * @param _address    Address to remove from the whitelist
2545      */
2546     function removeAddress(
2547         address _address
2548     )
2549         external
2550         onlyOwner
2551     {
2552         require(
2553             whiteList[_address],
2554             "WhiteList.removeAddress: Address is not current whitelisted."
2555         );
2556 
2557         addresses = addresses.remove(_address);
2558 
2559         whiteList[_address] = false;
2560 
2561         emit AddressRemoved(
2562             _address
2563         );
2564     }
2565 
2566     /**
2567      * Return array of all whitelisted addresses
2568      *
2569      * @return address[]      Array of addresses
2570      */
2571     function validAddresses()
2572         external
2573         view
2574         returns (address[] memory)
2575     {
2576         return addresses;
2577     }
2578 
2579     /**
2580      * Verifies an array of addresses against the whitelist
2581      *
2582      * @param  _addresses    Array of addresses to verify
2583      * @return bool          Whether all addresses in the list are whitelsited
2584      */
2585     function areValidAddresses(
2586         address[] calldata _addresses
2587     )
2588         external
2589         view
2590         returns (bool)
2591     {
2592         for (uint256 i = 0; i < _addresses.length; i++) {
2593             if (!whiteList[_addresses[i]]) {
2594                 return false;
2595             }
2596         }
2597 
2598         return true;
2599     }
2600 }
2601 
2602 // File: contracts/managers/allocators/ISocialAllocator.sol
2603 
2604 /*
2605     Copyright 2019 Set Labs Inc.
2606 
2607     Licensed under the Apache License, Version 2.0 (the "License");
2608     you may not use this file except in compliance with the License.
2609     You may obtain a copy of the License at
2610 
2611     http://www.apache.org/licenses/LICENSE-2.0
2612 
2613     Unless required by applicable law or agreed to in writing, software
2614     distributed under the License is distributed on an "AS IS" BASIS,
2615     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2616     See the License for the specific language governing permissions and
2617     limitations under the License.
2618 */
2619 
2620 pragma solidity 0.5.7;
2621 
2622 
2623 /**
2624  * @title ISocialAllocator
2625  * @author Set Protocol
2626  *
2627  * Interface for interacting with SocialAllocator contracts
2628  */
2629 interface ISocialAllocator {
2630 
2631     /*
2632      * Determine the next allocation to rebalance into.
2633      *
2634      * @param  _targetBaseAssetAllocation       Target allocation of the base asset
2635      * @return ISetToken                        The address of the proposed nextSet
2636      */
2637     function determineNewAllocation(
2638         uint256 _targetBaseAssetAllocation
2639     )
2640         external
2641         returns (ISetToken);
2642 
2643     /*
2644      * Calculate value of passed collateral set.
2645      *
2646      * @param  _collateralSet        Instance of current set collateralizing RebalancingSetToken
2647      * @return uint256               USD value of passed Set
2648      */
2649     function calculateCollateralSetValue(
2650         ISetToken _collateralSet
2651     )
2652         external
2653         view
2654         returns(uint256);
2655 }
2656 
2657 // File: contracts/managers/lib/SocialTradingLibrary.sol
2658 
2659 /*
2660     Copyright 2019 Set Labs Inc.
2661 
2662     Licensed under the Apache License, Version 2.0 (the "License");
2663     you may not use this file except in compliance with the License.
2664     You may obtain a copy of the License at
2665 
2666     http://www.apache.org/licenses/LICENSE-2.0
2667 
2668     Unless required by applicable law or agreed to in writing, software
2669     distributed under the License is distributed on an "AS IS" BASIS,
2670     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2671     See the License for the specific language governing permissions and
2672     limitations under the License.
2673 */
2674 
2675 pragma solidity 0.5.7;
2676 
2677 
2678 
2679 /**
2680  * @title SocialTradingLibrary
2681  * @author Set Protocol
2682  *
2683  * Library for use in SocialTrading system.
2684  */
2685 library SocialTradingLibrary {
2686 
2687     /* ============ Structs ============ */
2688     struct PoolInfo {
2689         address trader;                 // Address allowed to make admin and allocation decisions
2690         ISocialAllocator allocator;     // Allocator used to make collateral Sets, defines asset pair being used
2691         uint256 currentAllocation;      // Current base asset allocation of tradingPool
2692         uint256 newEntryFee;            // New fee percentage to change to after time lock passes, defaults to 0
2693         uint256 feeUpdateTimestamp;     // Timestamp when fee update process can be finalized, defaults to maxUint256
2694     }
2695 }
2696 
2697 // File: contracts/managers/SocialTradingManager.sol
2698 
2699 /*
2700     Copyright 2019 Set Labs Inc.
2701 
2702     Licensed under the Apache License, Version 2.0 (the "License");
2703     you may not use this file except in compliance with the License.
2704     You may obtain a copy of the License at
2705 
2706     http://www.apache.org/licenses/LICENSE-2.0
2707 
2708     Unless required by applicable law or agreed to in writing, software
2709     distributed under the License is distributed on an "AS IS" BASIS,
2710     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2711     See the License for the specific language governing permissions and
2712     limitations under the License.
2713 */
2714 
2715 pragma solidity 0.5.7;
2716 
2717 
2718 
2719 
2720 
2721 
2722 
2723 
2724 
2725 
2726 
2727 /**
2728  * @title SocialTradingManager
2729  * @author Set Protocol
2730  *
2731  * Singleton manager contract through which all social trading sets are managed. Traders can choose a percentage
2732  * between 0 and 100 for each rebalance. The trading pair used for each trading pool is defined by the allocator
2733  * passed in on pool creation. Only compatible with RebalancingSetTokenV2 constracts. All permissioned functions
2734  * on the RebalancingSetTokenV2 must be called through the administrative functions exposed on this contract.
2735  *
2736  * CHANGELOG: As of version 1.1.31 the REBALANCING_SET_NATURAL_UNIT has been changed from 1e6 to 1e8.
2737  */
2738 contract SocialTradingManager is
2739     WhiteList
2740 {
2741     using SafeMath for uint256;
2742 
2743     /* ============ Events ============ */
2744 
2745     event TradingPoolCreated(
2746         address indexed trader,
2747         ISocialAllocator indexed allocator,
2748         address indexed tradingPool,
2749         uint256 startingAllocation
2750     );
2751 
2752     event AllocationUpdate(
2753         address indexed tradingPool,
2754         uint256 oldAllocation,
2755         uint256 newAllocation
2756     );
2757 
2758     event NewTrader(
2759         address indexed tradingPool,
2760         address indexed oldTrader,
2761         address indexed newTrader
2762     );
2763 
2764     /* ============ Modifier ============ */
2765 
2766     modifier onlyTrader(IRebalancingSetTokenV2 _tradingPool) {
2767         require(
2768             msg.sender == trader(_tradingPool),
2769             "Sender must be trader"
2770         );
2771         _;
2772     }
2773 
2774     /* ============ Constants ============ */
2775 
2776     uint256 public constant REBALANCING_SET_NATURAL_UNIT = 1e8;
2777     uint public constant ONE_PERCENT = 1e16;
2778     uint256 constant public MAXIMUM_ALLOCATION = 1e18;
2779 
2780     /* ============ State Variables ============ */
2781 
2782     ICore public core;
2783     address public factory;
2784     mapping(address => SocialTradingLibrary.PoolInfo) public pools;
2785 
2786     uint256 public maxEntryFee;
2787     uint256 public feeUpdateTimelock;
2788 
2789     /*
2790      * SocialTradingManager constructor.
2791      *
2792      * @param  _core                            The address of the Core contract
2793      * @param  _factory                         Factory to use for RebalancingSetToken creation
2794      * @param  _whiteListedAllocators           List of allocator addresses to WhiteList
2795      * @param  _maxEntryFee                     Max entry fee when updating fees in a scaled decimal value
2796      *                                          (e.g. 1% = 1e16, 1bp = 1e14)
2797      * @param  _feeUpdateTimelock               Amount of time trader must wait between starting fee update
2798      *                                          and finalizing fee update
2799      */
2800     constructor(
2801         ICore _core,
2802         address _factory,
2803         address[] memory _whiteListedAllocators,
2804         uint256 _maxEntryFee,
2805         uint256 _feeUpdateTimelock
2806     )
2807         public
2808         WhiteList(_whiteListedAllocators)
2809     {
2810         core = _core;
2811         factory = _factory;
2812 
2813         maxEntryFee = _maxEntryFee;
2814         feeUpdateTimelock = _feeUpdateTimelock;
2815     }
2816 
2817     /* ============ External ============ */
2818 
2819     /*
2820      * Create a trading pool. Create or select new collateral and create RebalancingSetToken contract to
2821      * administer pool. Save relevant data to pool's entry in pools state variable under the Rebalancing
2822      * Set Token address.
2823      *
2824      * @param _tradingPairAllocator             The address of the allocator the trader wishes to use
2825      * @param _startingBaseAssetAllocation      Starting base asset allocation in a scaled decimal value
2826      *                                          (e.g. 100% = 1e18, 1% = 1e16)
2827      * @param _startingUSDValue                 Starting value of one share of the trading pool to 18 decimals of precision
2828      * @param _name                             The name of the new RebalancingSetTokenV2
2829      * @param _symbol                           The symbol of the new RebalancingSetTokenV2
2830      * @param _rebalancingSetCallData           Byte string containing additional call parameters to pass to factory
2831      */
2832     function createTradingPool(
2833         ISocialAllocator _tradingPairAllocator,
2834         uint256 _startingBaseAssetAllocation,
2835         uint256 _startingUSDValue,
2836         bytes32 _name,
2837         bytes32 _symbol,
2838         bytes calldata _rebalancingSetCallData
2839     )
2840         external
2841     {
2842         // Validate relevant params
2843         validateCreateTradingPool(_tradingPairAllocator, _startingBaseAssetAllocation, _rebalancingSetCallData);
2844 
2845         // Get collateral Set
2846         ISetToken collateralSet = _tradingPairAllocator.determineNewAllocation(
2847             _startingBaseAssetAllocation
2848         );
2849 
2850         uint256[] memory unitShares = new uint256[](1);
2851 
2852         // Value collateral
2853         uint256 collateralValue = _tradingPairAllocator.calculateCollateralSetValue(
2854             collateralSet
2855         );
2856 
2857         // unitShares is equal to _startingUSDValue divided by colalteral Value
2858         unitShares[0] = _startingUSDValue.mul(REBALANCING_SET_NATURAL_UNIT).div(collateralValue);
2859 
2860         address[] memory components = new address[](1);
2861         components[0] = address(collateralSet);
2862 
2863         // Create tradingPool
2864         address tradingPool = core.createSet(
2865             factory,
2866             components,
2867             unitShares,
2868             REBALANCING_SET_NATURAL_UNIT,
2869             _name,
2870             _symbol,
2871             _rebalancingSetCallData
2872         );
2873 
2874         pools[tradingPool].trader = msg.sender;
2875         pools[tradingPool].allocator = _tradingPairAllocator;
2876         pools[tradingPool].currentAllocation = _startingBaseAssetAllocation;
2877         pools[tradingPool].feeUpdateTimestamp = 0;
2878 
2879         emit TradingPoolCreated(
2880             msg.sender,
2881             _tradingPairAllocator,
2882             tradingPool,
2883             _startingBaseAssetAllocation
2884         );
2885     }
2886 
2887     /*
2888      * Update trading pool allocation. Issue new collateral Set and initiate rebalance on RebalancingSetTokenV2.
2889      *
2890      * @param _tradingPool        The address of the trading pool being updated
2891      * @param _newAllocation      New base asset allocation in a scaled decimal value
2892      *                                          (e.g. 100% = 1e18, 1% = 1e16)
2893      * @param _liquidatorData     Extra parameters passed to the liquidator
2894      */
2895     function updateAllocation(
2896         IRebalancingSetTokenV2 _tradingPool,
2897         uint256 _newAllocation,
2898         bytes calldata _liquidatorData
2899     )
2900         external
2901         onlyTrader(_tradingPool)
2902     {
2903         // Validate updateAllocation params
2904         validateAllocationUpdate(_tradingPool, _newAllocation);
2905 
2906         // Create nextSet collateral
2907         ISetToken nextSet = allocator(_tradingPool).determineNewAllocation(
2908             _newAllocation
2909         );
2910 
2911         // Trigger start rebalance on RebalancingSetTokenV2
2912         _tradingPool.startRebalance(address(nextSet), _liquidatorData);
2913 
2914         emit AllocationUpdate(
2915             address(_tradingPool),
2916             currentAllocation(_tradingPool),
2917             _newAllocation
2918         );
2919 
2920         // Save new allocation
2921         pools[address(_tradingPool)].currentAllocation = _newAllocation;
2922     }
2923 
2924     /*
2925      * Start fee update process, set fee update timestamp and commit to new fee.
2926      *
2927      * @param _tradingPool        The address of the trading pool being updated
2928      * @param _newEntryFee        New entry fee in a scaled decimal value
2929      *                              (e.g. 100% = 1e18, 1% = 1e16)
2930      */
2931     function initiateEntryFeeChange(
2932         IRebalancingSetTokenV2 _tradingPool,
2933         uint256 _newEntryFee
2934     )
2935         external
2936         onlyTrader(_tradingPool)
2937     {
2938         // Validate new entry fee doesn't exceed max
2939         validateNewEntryFee(_newEntryFee);
2940 
2941         // Log new entryFee and timestamp to start timelock from
2942         pools[address(_tradingPool)].feeUpdateTimestamp = block.timestamp.add(feeUpdateTimelock);
2943         pools[address(_tradingPool)].newEntryFee = _newEntryFee;
2944     }
2945 
2946     /*
2947      * Finalize fee update, change fee on RebalancingSetTokenV2 if time lock period has elapsed.
2948      *
2949      * @param _tradingPool        The address of the trading pool being updated
2950      */
2951     function finalizeEntryFeeChange(
2952         IRebalancingSetTokenV2 _tradingPool
2953     )
2954         external
2955         onlyTrader(_tradingPool)
2956     {
2957         // If feeUpdateTimestamp is equal to 0 indicates initiate wasn't called
2958         require(
2959             feeUpdateTimestamp(_tradingPool) != 0,
2960             "SocialTradingManager.finalizeSetFeeRecipient: Must initiate fee change first."
2961         );
2962 
2963         // Current block timestamp must exceed feeUpdateTimestamp
2964         require(
2965             block.timestamp >= feeUpdateTimestamp(_tradingPool),
2966             "SocialTradingManager.finalizeSetFeeRecipient: Time lock period must elapse to update fees."
2967         );
2968 
2969         // Reset timestamp to avoid reentrancy
2970         pools[address(_tradingPool)].feeUpdateTimestamp = 0;
2971 
2972         // Update fee on RebalancingSetTokenV2
2973         _tradingPool.setEntryFee(newEntryFee(_tradingPool));
2974 
2975         // Reset newEntryFee
2976         pools[address(_tradingPool)].newEntryFee = 0;
2977     }
2978 
2979     /*
2980      * Update trader allowed to manage trading pool.
2981      *
2982      * @param _tradingPool        The address of the trading pool being updated
2983      * @param _newTrader          Address of new traders
2984      */
2985     function setTrader(
2986         IRebalancingSetTokenV2 _tradingPool,
2987         address _newTrader
2988     )
2989         external
2990         onlyTrader(_tradingPool)
2991     {
2992         emit NewTrader(
2993             address(_tradingPool),
2994             trader(_tradingPool),
2995             _newTrader
2996         );
2997 
2998         pools[address(_tradingPool)].trader = _newTrader;
2999     }
3000 
3001     /*
3002      * Update liquidator used by tradingPool.
3003      *
3004      * @param _tradingPool        The address of the trading pool being updated
3005      * @param _newLiquidator      Address of new Liquidator
3006      */
3007     function setLiquidator(
3008         IRebalancingSetTokenV2 _tradingPool,
3009         ILiquidator _newLiquidator
3010     )
3011         external
3012         onlyTrader(_tradingPool)
3013     {
3014         _tradingPool.setLiquidator(_newLiquidator);
3015     }
3016 
3017     /*
3018      * Update fee recipient of tradingPool.
3019      *
3020      * @param _tradingPool          The address of the trading pool being updated
3021      * @param _newFeeRecipient      Address of new fee recipient
3022      */
3023     function setFeeRecipient(
3024         IRebalancingSetTokenV2 _tradingPool,
3025         address _newFeeRecipient
3026     )
3027         external
3028         onlyTrader(_tradingPool)
3029     {
3030         _tradingPool.setFeeRecipient(_newFeeRecipient);
3031     }
3032 
3033     /* ============ Internal ============ */
3034 
3035     /*
3036      * Validate trading pool creation. Make sure allocation is valid, allocator is white listed and
3037      * manager passed in rebalancingSetCallData is this address.
3038      *
3039      * @param _tradingPairAllocator             The address of allocator being used in trading pool
3040      * @param _startingBaseAssetAllocation      New base asset allocation in a scaled decimal value
3041      *                                          (e.g. 100% = 1e18, 1% = 1e16)
3042      * @param _rebalancingSetCallData           Byte string containing RebalancingSetTokenV2 call parameters
3043      */
3044     function validateCreateTradingPool(
3045         ISocialAllocator _tradingPairAllocator,
3046         uint256 _startingBaseAssetAllocation,
3047         bytes memory _rebalancingSetCallData
3048     )
3049         internal
3050         view
3051     {
3052         validateAllocationAmount(_startingBaseAssetAllocation);
3053 
3054         validateManagerAddress(_rebalancingSetCallData);
3055 
3056         require(
3057             whiteList[address(_tradingPairAllocator)],
3058             "SocialTradingManager.validateCreateTradingPool: Passed allocator is not valid."
3059         );
3060     }
3061 
3062     /*
3063      * Validate trading pool allocation update. Make sure allocation is valid,
3064      * and RebalancingSet is in valid state.
3065      *
3066      * @param _tradingPool        The address of the trading pool being updated
3067      * @param _newAllocation      New base asset allocation in a scaled decimal value
3068      *                                          (e.g. 100% = 1e18, 1% = 1e16)
3069      */
3070     function validateAllocationUpdate(
3071         IRebalancingSetTokenV2 _tradingPool,
3072         uint256 _newAllocation
3073     )
3074         internal
3075         view
3076     {
3077         validateAllocationAmount(_newAllocation);
3078 
3079         // If current allocation is 0/100%, cannot be the same allocation
3080         uint256 currentAllocationValue = currentAllocation(_tradingPool);
3081         require(
3082             !(currentAllocationValue == MAXIMUM_ALLOCATION && _newAllocation == MAXIMUM_ALLOCATION) &&
3083             !(currentAllocationValue == 0 && _newAllocation == 0),
3084             "SocialTradingManager.validateAllocationUpdate: Invalid allocation"
3085         );
3086 
3087         // Require that enough time has passed from last rebalance
3088         uint256 lastRebalanceTimestamp = _tradingPool.lastRebalanceTimestamp();
3089         uint256 rebalanceInterval = _tradingPool.rebalanceInterval();
3090         require(
3091             block.timestamp >= lastRebalanceTimestamp.add(rebalanceInterval),
3092             "SocialTradingManager.validateAllocationUpdate: Rebalance interval not elapsed"
3093         );
3094 
3095         // Require that Rebalancing Set Token is in Default state, won't allow for re-proposals
3096         // because malicious actor could prevent token from ever rebalancing
3097         require(
3098             _tradingPool.rebalanceState() == RebalancingLibrary.State.Default,
3099             "SocialTradingManager.validateAllocationUpdate: State must be in Default"
3100         );
3101     }
3102 
3103     /*
3104      * Validate passed allocation amount.
3105      *
3106      * @param _allocation      New base asset allocation in a scaled decimal value
3107      *                                          (e.g. 100% = 1e18, 1% = 1e16)
3108      */
3109     function validateAllocationAmount(
3110         uint256 _allocation
3111     )
3112         internal
3113         view
3114     {
3115         require(
3116             _allocation <= MAXIMUM_ALLOCATION,
3117             "Passed allocation must not exceed 100%."
3118         );
3119 
3120         require(
3121             _allocation.mod(ONE_PERCENT) == 0,
3122             "Passed allocation must be multiple of 1%."
3123         );
3124     }
3125 
3126     /*
3127      * Validate new entry fee.
3128      *
3129      * @param _entryFee      New entry fee in a scaled decimal value
3130      *                          (e.g. 100% = 1e18, 1% = 1e16)
3131      */
3132     function validateNewEntryFee(
3133         uint256 _entryFee
3134     )
3135         internal
3136         view
3137     {
3138         require(
3139             _entryFee <= maxEntryFee,
3140             "SocialTradingManager.validateNewEntryFee: Passed entry fee must not exceed maxEntryFee."
3141         );
3142     }
3143 
3144     /*
3145      * Validate passed manager in RebalancingSetToken bytes arg matches this address.
3146      *
3147      * @param _rebalancingSetCallData       Byte string containing RebalancingSetTokenV2 call parameters
3148      */
3149     function validateManagerAddress(
3150         bytes memory _rebalancingSetCallData
3151     )
3152         internal
3153         view
3154     {
3155         address manager;
3156 
3157         assembly {
3158             manager := mload(add(_rebalancingSetCallData, 32))   // manager slot
3159         }
3160 
3161         require(
3162             manager == address(this),
3163             "SocialTradingManager.validateCallDataArgs: Passed manager address is not this address."
3164         );
3165     }
3166 
3167     function allocator(IRebalancingSetTokenV2 _tradingPool) internal view returns (ISocialAllocator) {
3168         return pools[address(_tradingPool)].allocator;
3169     }
3170 
3171     function trader(IRebalancingSetTokenV2 _tradingPool) internal view returns (address) {
3172         return pools[address(_tradingPool)].trader;
3173     }
3174 
3175     function currentAllocation(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {
3176         return pools[address(_tradingPool)].currentAllocation;
3177     }
3178 
3179     function feeUpdateTimestamp(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {
3180         return pools[address(_tradingPool)].feeUpdateTimestamp;
3181     }
3182 
3183     function newEntryFee(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {
3184         return pools[address(_tradingPool)].newEntryFee;
3185     }
3186 }
3187 
3188 // File: contracts/managers/SocialTradingManagerV2.sol
3189 
3190 /*
3191     Copyright 2020 Set Labs Inc.
3192 
3193     Licensed under the Apache License, Version 2.0 (the "License");
3194     you may not use this file except in compliance with the License.
3195     You may obtain a copy of the License at
3196 
3197     http://www.apache.org/licenses/LICENSE-2.0
3198 
3199     Unless required by applicable law or agreed to in writing, software
3200     distributed under the License is distributed on an "AS IS" BASIS,
3201     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3202     See the License for the specific language governing permissions and
3203     limitations under the License.
3204 */
3205 
3206 pragma solidity 0.5.7;
3207 pragma experimental "ABIEncoderV2";
3208 
3209 
3210 
3211 
3212 
3213 
3214 
3215 /**
3216  * @title SocialTradingManagerV2
3217  * @author Set Protocol
3218  *
3219  * Singleton manager contract through which all social trading v2 sets are managed. Inherits from SocialTradingManager
3220  * and adds functionality to adjust performance based fees.
3221  */
3222 contract SocialTradingManagerV2 is
3223     SocialTradingManager,
3224     LimitOneUpgrade
3225 {
3226     /*
3227      * SocialTradingManager constructor.
3228      *
3229      * @param  _core                            The address of the Core contract
3230      * @param  _factory                         Factory to use for RebalancingSetToken creation
3231      * @param  _whiteListedAllocators           List of allocator addresses to WhiteList
3232      * @param  _maxEntryFee                     Max entry fee when updating fees in a scaled decimal value
3233      *                                          (e.g. 1% = 1e16, 1bp = 1e14)
3234      * @param  _feeUpdateTimelock               Amount of time trader must wait between starting fee update
3235      *                                          and finalizing fee update
3236      */
3237     constructor(
3238         ICore _core,
3239         address _factory,
3240         address[] memory _whiteListedAllocators,
3241         uint256 _maxEntryFee,
3242         uint256 _feeUpdateTimelock
3243     )
3244         public
3245         SocialTradingManager(
3246             _core,
3247             _factory,
3248             _whiteListedAllocators,
3249             _maxEntryFee,
3250             _feeUpdateTimelock
3251         )
3252     {}
3253 
3254     /* ============ External ============ */
3255 
3256     /**
3257      * Allows traders to update fees on their Set. Only one fee update allowed at a time and timelocked.
3258      *
3259      * @param _tradingPool       The address of the trading pool being updated
3260      * @param _newFeeCallData    Bytestring representing feeData to pass to fee calculator
3261      */
3262     function adjustFee(
3263         address _tradingPool,
3264         bytes calldata _newFeeCallData
3265     )
3266         external
3267         onlyTrader(IRebalancingSetTokenV2(_tradingPool))
3268         limitOneUpgrade(_tradingPool)
3269         timeLockUpgrade
3270     {
3271         IRebalancingSetTokenV3(_tradingPool).adjustFee(_newFeeCallData);
3272     }
3273 
3274     /**
3275      * External function to remove upgrade. Modifiers should be added to restrict usage.
3276      *
3277      * @param _tradingPool      The address of the trading pool being updated
3278      * @param _upgradeHash      Keccack256 hash that uniquely identifies function called and arguments
3279      */
3280     function removeRegisteredUpgrade(
3281         address _tradingPool,
3282         bytes32 _upgradeHash
3283     )
3284         external
3285         onlyTrader(IRebalancingSetTokenV2(_tradingPool))
3286     {
3287         LimitOneUpgrade.removeRegisteredUpgradeInternal(_tradingPool, _upgradeHash);
3288     }
3289 }
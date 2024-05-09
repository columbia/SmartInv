1 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Helps contracts guard against reentrancy attacks.
7  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
8  * @dev If you mark a function `nonReentrant`, you should also
9  * mark it `external`.
10  */
11 contract ReentrancyGuard {
12     /// @dev counter to allow mutex lock with only one SSTORE operation
13     uint256 private _guardCounter;
14 
15     constructor () internal {
16         // The counter starts at one to prevent changing it from zero to a non-zero
17         // value, which is a more expensive operation.
18         _guardCounter = 1;
19     }
20 
21     /**
22      * @dev Prevents a contract from calling itself, directly or indirectly.
23      * Calling a `nonReentrant` function from another `nonReentrant`
24      * function is not supported. It is possible to prevent this from happening
25      * by making the `nonReentrant` function external, and make it call a
26      * `private` function that does the actual work.
27      */
28     modifier nonReentrant() {
29         _guardCounter += 1;
30         uint256 localCounter = _guardCounter;
31         _;
32         require(localCounter == _guardCounter);
33     }
34 }
35 
36 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
37 
38 pragma solidity ^0.5.2;
39 
40 /**
41  * @title SafeMath
42  * @dev Unsigned math operations with safety checks that revert on error
43  */
44 library SafeMath {
45     /**
46      * @dev Multiplies two unsigned integers, reverts on overflow.
47      */
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64      */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     /**
85      * @dev Adds two unsigned integers, reverts on overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     /**
95      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
96      * reverts when dividing by zero.
97      */
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 // File: contracts/lib/CommonValidationsLibrary.sol
105 
106 /*
107     Copyright 2018 Set Labs Inc.
108 
109     Licensed under the Apache License, Version 2.0 (the "License");
110     you may not use this file except in compliance with the License.
111     You may obtain a copy of the License at
112 
113     http://www.apache.org/licenses/LICENSE-2.0
114 
115     Unless required by applicable law or agreed to in writing, software
116     distributed under the License is distributed on an "AS IS" BASIS,
117     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
118     See the License for the specific language governing permissions and
119     limitations under the License.
120 */
121 
122 pragma solidity 0.5.7;
123 
124 
125 library CommonValidationsLibrary {
126 
127     /**
128      * Ensures that an address array is not empty.
129      *
130      * @param  _addressArray       Address array input
131      */
132     function validateNonEmpty(
133         address[] calldata _addressArray
134     )
135         external
136         pure
137     {
138         require(
139             _addressArray.length > 0,
140             "Address array length must be > 0"
141         );
142     }
143 
144     /**
145      * Ensures that an address array and uint256 array are equal length
146      *
147      * @param  _addressArray       Address array input
148      * @param  _uint256Array       Uint256 array input
149      */
150     function validateEqualLength(
151         address[] calldata _addressArray,
152         uint256[] calldata _uint256Array
153     )
154         external
155         pure
156     {
157         require(
158             _addressArray.length == _uint256Array.length,
159             "Input length mismatch"
160         );
161     }
162 }
163 
164 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
165 
166 pragma solidity ^0.5.2;
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180      * account.
181      */
182     constructor () internal {
183         _owner = msg.sender;
184         emit OwnershipTransferred(address(0), _owner);
185     }
186 
187     /**
188      * @return the address of the owner.
189      */
190     function owner() public view returns (address) {
191         return _owner;
192     }
193 
194     /**
195      * @dev Throws if called by any account other than the owner.
196      */
197     modifier onlyOwner() {
198         require(isOwner());
199         _;
200     }
201 
202     /**
203      * @return true if `msg.sender` is the owner of the contract.
204      */
205     function isOwner() public view returns (bool) {
206         return msg.sender == _owner;
207     }
208 
209     /**
210      * @dev Allows the current owner to relinquish control of the contract.
211      * It will not be possible to call the functions with the `onlyOwner`
212      * modifier anymore.
213      * @notice Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public onlyOwner {
217         emit OwnershipTransferred(_owner, address(0));
218         _owner = address(0);
219     }
220 
221     /**
222      * @dev Allows the current owner to transfer control of the contract to a newOwner.
223      * @param newOwner The address to transfer ownership to.
224      */
225     function transferOwnership(address newOwner) public onlyOwner {
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers control of the contract to a newOwner.
231      * @param newOwner The address to transfer ownership to.
232      */
233     function _transferOwnership(address newOwner) internal {
234         require(newOwner != address(0));
235         emit OwnershipTransferred(_owner, newOwner);
236         _owner = newOwner;
237     }
238 }
239 
240 // File: contracts/core/interfaces/ITransferProxy.sol
241 
242 /*
243     Copyright 2018 Set Labs Inc.
244 
245     Licensed under the Apache License, Version 2.0 (the "License");
246     you may not use this file except in compliance with the License.
247     You may obtain a copy of the License at
248 
249     http://www.apache.org/licenses/LICENSE-2.0
250 
251     Unless required by applicable law or agreed to in writing, software
252     distributed under the License is distributed on an "AS IS" BASIS,
253     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
254     See the License for the specific language governing permissions and
255     limitations under the License.
256 */
257 
258 pragma solidity 0.5.7;
259 
260 /**
261  * @title ITransferProxy
262  * @author Set Protocol
263  *
264  * The ITransferProxy interface provides a light-weight, structured way to interact with the
265  * TransferProxy contract from another contract.
266  */
267 interface ITransferProxy {
268 
269     /* ============ External Functions ============ */
270 
271     /**
272      * Transfers tokens from an address (that has set allowance on the proxy).
273      * Can only be called by authorized core contracts.
274      *
275      * @param  _token          The address of the ERC20 token
276      * @param  _quantity       The number of tokens to transfer
277      * @param  _from           The address to transfer from
278      * @param  _to             The address to transfer to
279      */
280     function transfer(
281         address _token,
282         uint256 _quantity,
283         address _from,
284         address _to
285     )
286         external;
287 
288     /**
289      * Transfers tokens from an address (that has set allowance on the proxy).
290      * Can only be called by authorized core contracts.
291      *
292      * @param  _tokens         The addresses of the ERC20 token
293      * @param  _quantities     The numbers of tokens to transfer
294      * @param  _from           The address to transfer from
295      * @param  _to             The address to transfer to
296      */
297     function batchTransfer(
298         address[] calldata _tokens,
299         uint256[] calldata _quantities,
300         address _from,
301         address _to
302     )
303         external;
304 }
305 
306 // File: contracts/core/interfaces/IVault.sol
307 
308 /*
309     Copyright 2018 Set Labs Inc.
310 
311     Licensed under the Apache License, Version 2.0 (the "License");
312     you may not use this file except in compliance with the License.
313     You may obtain a copy of the License at
314 
315     http://www.apache.org/licenses/LICENSE-2.0
316 
317     Unless required by applicable law or agreed to in writing, software
318     distributed under the License is distributed on an "AS IS" BASIS,
319     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
320     See the License for the specific language governing permissions and
321     limitations under the License.
322 */
323 
324 pragma solidity 0.5.7;
325 
326 /**
327  * @title IVault
328  * @author Set Protocol
329  *
330  * The IVault interface provides a light-weight, structured way to interact with the Vault
331  * contract from another contract.
332  */
333 interface IVault {
334 
335     /*
336      * Withdraws user's unassociated tokens to user account. Can only be
337      * called by authorized core contracts.
338      *
339      * @param  _token          The address of the ERC20 token
340      * @param  _to             The address to transfer token to
341      * @param  _quantity       The number of tokens to transfer
342      */
343     function withdrawTo(
344         address _token,
345         address _to,
346         uint256 _quantity
347     )
348         external;
349 
350     /*
351      * Increment quantity owned of a token for a given address. Can
352      * only be called by authorized core contracts.
353      *
354      * @param  _token           The address of the ERC20 token
355      * @param  _owner           The address of the token owner
356      * @param  _quantity        The number of tokens to attribute to owner
357      */
358     function incrementTokenOwner(
359         address _token,
360         address _owner,
361         uint256 _quantity
362     )
363         external;
364 
365     /*
366      * Decrement quantity owned of a token for a given address. Can only
367      * be called by authorized core contracts.
368      *
369      * @param  _token           The address of the ERC20 token
370      * @param  _owner           The address of the token owner
371      * @param  _quantity        The number of tokens to deattribute to owner
372      */
373     function decrementTokenOwner(
374         address _token,
375         address _owner,
376         uint256 _quantity
377     )
378         external;
379 
380     /**
381      * Transfers tokens associated with one account to another account in the vault
382      *
383      * @param  _token          Address of token being transferred
384      * @param  _from           Address token being transferred from
385      * @param  _to             Address token being transferred to
386      * @param  _quantity       Amount of tokens being transferred
387      */
388 
389     function transferBalance(
390         address _token,
391         address _from,
392         address _to,
393         uint256 _quantity
394     )
395         external;
396 
397 
398     /*
399      * Withdraws user's unassociated tokens to user account. Can only be
400      * called by authorized core contracts.
401      *
402      * @param  _tokens          The addresses of the ERC20 tokens
403      * @param  _owner           The address of the token owner
404      * @param  _quantities      The numbers of tokens to attribute to owner
405      */
406     function batchWithdrawTo(
407         address[] calldata _tokens,
408         address _to,
409         uint256[] calldata _quantities
410     )
411         external;
412 
413     /*
414      * Increment quantites owned of a collection of tokens for a given address. Can
415      * only be called by authorized core contracts.
416      *
417      * @param  _tokens          The addresses of the ERC20 tokens
418      * @param  _owner           The address of the token owner
419      * @param  _quantities      The numbers of tokens to attribute to owner
420      */
421     function batchIncrementTokenOwner(
422         address[] calldata _tokens,
423         address _owner,
424         uint256[] calldata _quantities
425     )
426         external;
427 
428     /*
429      * Decrements quantites owned of a collection of tokens for a given address. Can
430      * only be called by authorized core contracts.
431      *
432      * @param  _tokens          The addresses of the ERC20 tokens
433      * @param  _owner           The address of the token owner
434      * @param  _quantities      The numbers of tokens to attribute to owner
435      */
436     function batchDecrementTokenOwner(
437         address[] calldata _tokens,
438         address _owner,
439         uint256[] calldata _quantities
440     )
441         external;
442 
443    /**
444      * Transfers tokens associated with one account to another account in the vault
445      *
446      * @param  _tokens           Addresses of tokens being transferred
447      * @param  _from             Address tokens being transferred from
448      * @param  _to               Address tokens being transferred to
449      * @param  _quantities       Amounts of tokens being transferred
450      */
451     function batchTransferBalance(
452         address[] calldata _tokens,
453         address _from,
454         address _to,
455         uint256[] calldata _quantities
456     )
457         external;
458 
459     /*
460      * Get balance of particular contract for owner.
461      *
462      * @param  _token    The address of the ERC20 token
463      * @param  _owner    The address of the token owner
464      */
465     function getOwnerBalance(
466         address _token,
467         address _owner
468     )
469         external
470         view
471         returns (uint256);
472 }
473 
474 // File: contracts/core/lib/CoreState.sol
475 
476 /*
477     Copyright 2018 Set Labs Inc.
478 
479     Licensed under the Apache License, Version 2.0 (the "License");
480     you may not use this file except in compliance with the License.
481     You may obtain a copy of the License at
482 
483     http://www.apache.org/licenses/LICENSE-2.0
484 
485     Unless required by applicable law or agreed to in writing, software
486     distributed under the License is distributed on an "AS IS" BASIS,
487     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
488     See the License for the specific language governing permissions and
489     limitations under the License.
490 */
491 
492 pragma solidity 0.5.7;
493 
494 
495 
496 
497 /**
498  * @title CoreState
499  * @author Set Protocol
500  *
501  * The CoreState library maintains all state for the Core contract thus
502  * allowing it to operate across multiple mixins.
503  */
504 contract CoreState {
505 
506     /* ============ Structs ============ */
507 
508     struct State {
509         // Protocol state of operation
510         uint8 operationState;
511 
512         // Address of the TransferProxy contract
513         address transferProxy;
514 
515         // Address of the Vault contract
516         address vault;
517 
518         // Instance of transferProxy contract
519         ITransferProxy transferProxyInstance;
520 
521         // Instance of Vault Contract
522         IVault vaultInstance;
523 
524         // Mapping of exchange enumeration to address
525         mapping(uint8 => address) exchangeIds;
526 
527         // Mapping of approved modules
528         mapping(address => bool) validModules;
529 
530         // Mapping of tracked SetToken factories
531         mapping(address => bool) validFactories;
532 
533         // Mapping of tracked rebalancing price libraries
534         mapping(address => bool) validPriceLibraries;
535 
536         // Mapping of tracked SetTokens
537         mapping(address => bool) validSets;
538 
539         // Mapping of tracked disabled SetTokens
540         mapping(address => bool) disabledSets;
541 
542         // Array of tracked SetTokens
543         address[] setTokens;
544 
545         // Array of tracked modules
546         address[] modules;
547 
548         // Array of tracked factories
549         address[] factories;
550 
551         // Array of tracked exchange wrappers
552         address[] exchanges;
553 
554         // Array of tracked auction price libraries
555         address[] priceLibraries;
556     }
557 
558     /* ============ State Variables ============ */
559 
560     State public state;
561 
562     /* ============ Public Getters ============ */
563 
564     /**
565      * Return uint8 representing the operational state of the protocol
566      *
567      * @return uint8           Uint8 representing the operational state of the protocol
568      */
569     function operationState()
570         external
571         view
572         returns (uint8)
573     {
574         return state.operationState;
575     }
576 
577     /**
578      * Return address belonging to given exchangeId.
579      *
580      * @param  _exchangeId       ExchangeId number
581      * @return address           Address belonging to given exchangeId
582      */
583     function exchangeIds(
584         uint8 _exchangeId
585     )
586         external
587         view
588         returns (address)
589     {
590         return state.exchangeIds[_exchangeId];
591     }
592 
593     /**
594      * Return transferProxy address.
595      *
596      * @return address       transferProxy address
597      */
598     function transferProxy()
599         external
600         view
601         returns (address)
602     {
603         return state.transferProxy;
604     }
605 
606     /**
607      * Return vault address
608      *
609      * @return address        vault address
610      */
611     function vault()
612         external
613         view
614         returns (address)
615     {
616         return state.vault;
617     }
618 
619     /**
620      * Return boolean indicating if address is valid factory.
621      *
622      * @param  _factory       Factory address
623      * @return bool           Boolean indicating if enabled factory
624      */
625     function validFactories(
626         address _factory
627     )
628         external
629         view
630         returns (bool)
631     {
632         return state.validFactories[_factory];
633     }
634 
635     /**
636      * Return boolean indicating if address is valid module.
637      *
638      * @param  _module        Factory address
639      * @return bool           Boolean indicating if enabled factory
640      */
641     function validModules(
642         address _module
643     )
644         external
645         view
646         returns (bool)
647     {
648         return state.validModules[_module];
649     }
650 
651     /**
652      * Return boolean indicating if address is valid Set.
653      *
654      * @param  _set           Set address
655      * @return bool           Boolean indicating if valid Set
656      */
657     function validSets(
658         address _set
659     )
660         external
661         view
662         returns (bool)
663     {
664         return state.validSets[_set];
665     }
666 
667     /**
668      * Return boolean indicating if address is a disabled Set.
669      *
670      * @param  _set           Set address
671      * @return bool           Boolean indicating if is a disabled Set
672      */
673     function disabledSets(
674         address _set
675     )
676         external
677         view
678         returns (bool)
679     {
680         return state.disabledSets[_set];
681     }
682 
683     /**
684      * Return boolean indicating if address is a valid Rebalancing Price Library.
685      *
686      * @param  _priceLibrary    Price library address
687      * @return bool             Boolean indicating if valid Price Library
688      */
689     function validPriceLibraries(
690         address _priceLibrary
691     )
692         external
693         view
694         returns (bool)
695     {
696         return state.validPriceLibraries[_priceLibrary];
697     }
698 
699     /**
700      * Return array of all valid Set Tokens.
701      *
702      * @return address[]      Array of valid Set Tokens
703      */
704     function setTokens()
705         external
706         view
707         returns (address[] memory)
708     {
709         return state.setTokens;
710     }
711 
712     /**
713      * Return array of all valid Modules.
714      *
715      * @return address[]      Array of valid modules
716      */
717     function modules()
718         external
719         view
720         returns (address[] memory)
721     {
722         return state.modules;
723     }
724 
725     /**
726      * Return array of all valid factories.
727      *
728      * @return address[]      Array of valid factories
729      */
730     function factories()
731         external
732         view
733         returns (address[] memory)
734     {
735         return state.factories;
736     }
737 
738     /**
739      * Return array of all valid exchange wrappers.
740      *
741      * @return address[]      Array of valid exchange wrappers
742      */
743     function exchanges()
744         external
745         view
746         returns (address[] memory)
747     {
748         return state.exchanges;
749     }
750 
751     /**
752      * Return array of all valid price libraries.
753      *
754      * @return address[]      Array of valid price libraries
755      */
756     function priceLibraries()
757         external
758         view
759         returns (address[] memory)
760     {
761         return state.priceLibraries;
762     }
763 }
764 
765 // File: contracts/core/extensions/CoreOperationState.sol
766 
767 /*
768     Copyright 2018 Set Labs Inc.
769 
770     Licensed under the Apache License, Version 2.0 (the "License");
771     you may not use this file except in compliance with the License.
772     You may obtain a copy of the License at
773 
774     http://www.apache.org/licenses/LICENSE-2.0
775 
776     Unless required by applicable law or agreed to in writing, software
777     distributed under the License is distributed on an "AS IS" BASIS,
778     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
779     See the License for the specific language governing permissions and
780     limitations under the License.
781 */
782 
783 pragma solidity 0.5.7;
784 
785 
786 
787 
788 /**
789  * @title CoreOperationState
790  * @author Set Protocol
791  *
792  * The CoreOperationState contract contains methods to alter state of variables that track
793  * Core dependency addresses.
794  */
795 contract CoreOperationState is
796     Ownable,
797     CoreState
798 {
799 
800     /* ============ Enum ============ */
801 
802     /**
803      * Operational:
804      * All Accounting and Issuance related functions are available for usage during this stage
805      *
806      * Shut Down:
807      * Only functions which allow users to redeem and withdraw funds are allowed during this stage
808      */
809     enum OperationState {
810         Operational,
811         ShutDown,
812         InvalidState
813     }
814 
815     /* ============ Events ============ */
816 
817     event OperationStateChanged(
818         uint8 _prevState,
819         uint8 _newState
820     );
821 
822     /* ============ Modifiers ============ */
823 
824     modifier whenOperational() {
825         require(
826             state.operationState == uint8(OperationState.Operational),
827             "WhenOperational"
828         );
829         _;
830     }
831 
832     /* ============ External Functions ============ */
833 
834     /**
835      * Updates the operation state of the protocol.
836      * Can only be called by owner of Core.
837      *
838      * @param  _operationState   Uint8 representing the current protocol operation state
839      */
840     function setOperationState(
841         uint8 _operationState
842     )
843         external
844         onlyOwner
845     {
846         require(
847             _operationState < uint8(OperationState.InvalidState) &&
848             _operationState != state.operationState,
849             "InvalidOperationState"
850         );
851 
852         emit OperationStateChanged(
853             state.operationState,
854             _operationState
855         );
856 
857         state.operationState = _operationState;
858     }
859 }
860 
861 // File: contracts/core/extensions/CoreAccounting.sol
862 
863 /*
864     Copyright 2018 Set Labs Inc.
865 
866     Licensed under the Apache License, Version 2.0 (the "License");
867     you may not use this file except in compliance with the License.
868     You may obtain a copy of the License at
869 
870     http://www.apache.org/licenses/LICENSE-2.0
871 
872     Unless required by applicable law or agreed to in writing, software
873     distributed under the License is distributed on an "AS IS" BASIS,
874     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
875     See the License for the specific language governing permissions and
876     limitations under the License.
877 */
878 
879 pragma solidity 0.5.7;
880 
881 
882 
883 
884 
885 
886 
887 /**
888  * @title CoreAccounting
889  * @author Set Protocol
890  *
891  * The CoreAccounting contract interfaces with the vault and transfer proxies for
892  * storage of tokenized assets.
893  */
894 contract CoreAccounting is
895     CoreState,
896     CoreOperationState,
897     ReentrancyGuard
898 {
899     // Use SafeMath library for all uint256 arithmetic
900     using SafeMath for uint256;
901 
902     /* ============ External Functions ============ */
903 
904     /**
905      * Deposit a quantity of tokens to the vault and attribute to sender.
906      *
907      * @param  _token           Address of the token
908      * @param  _quantity        Amount of tokens to deposit
909      */
910     function deposit(
911         address _token,
912         uint256 _quantity
913     )
914         external
915         nonReentrant
916         whenOperational
917     {
918         // Don't deposit if quantity <= 0
919         if (_quantity > 0) {
920             // Call TransferProxy contract to transfer user tokens to Vault
921             state.transferProxyInstance.transfer(
922                 _token,
923                 _quantity,
924                 msg.sender,
925                 state.vault
926             );
927 
928             // Call Vault contract to attribute deposited tokens to user
929             state.vaultInstance.incrementTokenOwner(
930                 _token,
931                 msg.sender,
932                 _quantity
933             );
934         }
935     }
936 
937     /**
938      * Withdraw a quantity of tokens from the vault and deattribute from sender.
939      *
940      * @param  _token           Address of the token
941      * @param  _quantity        Amount of tokens to withdraw
942      */
943     function withdraw(
944         address _token,
945         uint256 _quantity
946     )
947         external
948         nonReentrant
949     {
950         // Don't withdraw if quantity <= 0
951         if (_quantity > 0) {
952             // Call Vault contract to deattribute withdrawn tokens from user
953             state.vaultInstance.decrementTokenOwner(
954                 _token,
955                 msg.sender,
956                 _quantity
957             );
958 
959             // Call Vault contract to withdraw tokens from Vault to user
960             state.vaultInstance.withdrawTo(
961                 _token,
962                 msg.sender,
963                 _quantity
964             );
965         }
966     }
967 
968     /**
969      * Deposit multiple tokens to the vault and attribute to sender.
970      * Quantities should be in the order of the addresses of the tokens being deposited.
971      *
972      * @param  _tokens            Array of the addresses of the tokens
973      * @param  _quantities        Array of the amounts of tokens to deposit
974      */
975     function batchDeposit(
976         address[] calldata _tokens,
977         uint256[] calldata _quantities
978     )
979         external
980         nonReentrant
981         whenOperational
982     {
983         // Call internal batch deposit function
984         batchDepositInternal(
985             msg.sender,
986             msg.sender,
987             _tokens,
988             _quantities
989         );
990     }
991 
992     /**
993      * Withdraw multiple tokens from the vault and deattribute from sender.
994      * Quantities should be in the order of the addresses of the tokens being withdrawn.
995      *
996      * @param  _tokens            Array of the addresses of the tokens
997      * @param  _quantities        Array of the amounts of tokens to withdraw
998      */
999     function batchWithdraw(
1000         address[] calldata _tokens,
1001         uint256[] calldata _quantities
1002     )
1003         external
1004         nonReentrant
1005     {
1006         // Call internal batch withdraw function
1007         batchWithdrawInternal(
1008             msg.sender,
1009             msg.sender,
1010             _tokens,
1011             _quantities
1012         );
1013     }
1014 
1015     /**
1016      * Transfer tokens associated with the sender's account in vault to another user's
1017      * account in vault.
1018      *
1019      * @param  _token           Address of token being transferred
1020      * @param  _to              Address of user receiving tokens
1021      * @param  _quantity        Amount of tokens being transferred
1022      */
1023     function internalTransfer(
1024         address _token,
1025         address _to,
1026         uint256 _quantity
1027     )
1028         external
1029         nonReentrant
1030         whenOperational
1031     {
1032         state.vaultInstance.transferBalance(
1033             _token,
1034             msg.sender,
1035             _to,
1036             _quantity
1037         );
1038     }
1039 
1040     /* ============ Internal Functions ============ */
1041 
1042     /**
1043      * Internal function that deposits multiple tokens to the vault.
1044      * Quantities should be in the order of the addresses of the tokens being deposited.
1045      *
1046      * @param  _from              Address to transfer tokens from
1047      * @param  _to                Address to credit for deposits
1048      * @param  _tokens            Array of the addresses of the tokens being deposited
1049      * @param  _quantities        Array of the amounts of tokens to deposit
1050      */
1051     function batchDepositInternal(
1052         address _from,
1053         address _to,
1054         address[] memory _tokens,
1055         uint256[] memory _quantities
1056     )
1057         internal
1058         whenOperational
1059     {
1060         // Confirm an empty _tokens or quantity array is not passed
1061         CommonValidationsLibrary.validateNonEmpty(_tokens);
1062 
1063         // Confirm there is one quantity for every token address
1064         CommonValidationsLibrary.validateEqualLength(_tokens, _quantities);
1065 
1066         state.transferProxyInstance.batchTransfer(
1067             _tokens,
1068             _quantities,
1069             _from,
1070             state.vault
1071         );
1072 
1073         state.vaultInstance.batchIncrementTokenOwner(
1074             _tokens,
1075             _to,
1076             _quantities
1077         );
1078     }
1079 
1080     /**
1081      * Internal function that withdraws multiple tokens from the vault.
1082      * Quantities should be in the order of the addresses of the tokens being withdrawn.
1083      *
1084      * @param  _from              Address to decredit for withdrawals
1085      * @param  _to                Address to transfer tokens to
1086      * @param  _tokens            Array of the addresses of the tokens being withdrawn
1087      * @param  _quantities        Array of the amounts of tokens to withdraw
1088      */
1089     function batchWithdrawInternal(
1090         address _from,
1091         address _to,
1092         address[] memory _tokens,
1093         uint256[] memory _quantities
1094     )
1095         internal
1096     {
1097         // Confirm an empty _tokens or quantity array is not passed
1098         CommonValidationsLibrary.validateNonEmpty(_tokens);
1099 
1100         // Confirm there is one quantity for every token address
1101         CommonValidationsLibrary.validateEqualLength(_tokens, _quantities);
1102 
1103         // Call Vault contract to deattribute withdrawn tokens from user
1104         state.vaultInstance.batchDecrementTokenOwner(
1105             _tokens,
1106             _from,
1107             _quantities
1108         );
1109 
1110         // Call Vault contract to withdraw tokens from Vault to user
1111         state.vaultInstance.batchWithdrawTo(
1112             _tokens,
1113             _to,
1114             _quantities
1115         );
1116     }
1117 }
1118 
1119 // File: contracts/lib/AddressArrayUtils.sol
1120 
1121 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
1122 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
1123 
1124 pragma solidity 0.5.7;
1125 
1126 
1127 library AddressArrayUtils {
1128 
1129     /**
1130      * Finds the index of the first occurrence of the given element.
1131      * @param A The input array to search
1132      * @param a The value to find
1133      * @return Returns (index and isIn) for the first occurrence starting from index 0
1134      */
1135     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1136         uint256 length = A.length;
1137         for (uint256 i = 0; i < length; i++) {
1138             if (A[i] == a) {
1139                 return (i, true);
1140             }
1141         }
1142         return (0, false);
1143     }
1144 
1145     /**
1146     * Returns true if the value is present in the list. Uses indexOf internally.
1147     * @param A The input array to search
1148     * @param a The value to find
1149     * @return Returns isIn for the first occurrence starting from index 0
1150     */
1151     function contains(address[] memory A, address a) internal pure returns (bool) {
1152         bool isIn;
1153         (, isIn) = indexOf(A, a);
1154         return isIn;
1155     }
1156 
1157     /// @return Returns index and isIn for the first occurrence starting from
1158     /// end
1159     function indexOfFromEnd(address[] memory A, address a) internal pure returns (uint256, bool) {
1160         uint256 length = A.length;
1161         for (uint256 i = length; i > 0; i--) {
1162             if (A[i - 1] == a) {
1163                 return (i, true);
1164             }
1165         }
1166         return (0, false);
1167     }
1168 
1169     /**
1170      * Returns the combination of the two arrays
1171      * @param A The first array
1172      * @param B The second array
1173      * @return Returns A extended by B
1174      */
1175     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1176         uint256 aLength = A.length;
1177         uint256 bLength = B.length;
1178         address[] memory newAddresses = new address[](aLength + bLength);
1179         for (uint256 i = 0; i < aLength; i++) {
1180             newAddresses[i] = A[i];
1181         }
1182         for (uint256 j = 0; j < bLength; j++) {
1183             newAddresses[aLength + j] = B[j];
1184         }
1185         return newAddresses;
1186     }
1187 
1188     /**
1189      * Returns the array with a appended to A.
1190      * @param A The first array
1191      * @param a The value to append
1192      * @return Returns A appended by a
1193      */
1194     function append(address[] memory A, address a) internal pure returns (address[] memory) {
1195         address[] memory newAddresses = new address[](A.length + 1);
1196         for (uint256 i = 0; i < A.length; i++) {
1197             newAddresses[i] = A[i];
1198         }
1199         newAddresses[A.length] = a;
1200         return newAddresses;
1201     }
1202 
1203     /**
1204      * Returns the combination of two storage arrays.
1205      * @param A The first array
1206      * @param B The second array
1207      * @return Returns A appended by a
1208      */
1209     function sExtend(address[] storage A, address[] storage B) internal {
1210         uint256 length = B.length;
1211         for (uint256 i = 0; i < length; i++) {
1212             A.push(B[i]);
1213         }
1214     }
1215 
1216     /**
1217      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
1218      * @param A The first array
1219      * @param B The second array
1220      * @return The intersection of the two arrays
1221      */
1222     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1223         uint256 length = A.length;
1224         bool[] memory includeMap = new bool[](length);
1225         uint256 newLength = 0;
1226         for (uint256 i = 0; i < length; i++) {
1227             if (contains(B, A[i])) {
1228                 includeMap[i] = true;
1229                 newLength++;
1230             }
1231         }
1232         address[] memory newAddresses = new address[](newLength);
1233         uint256 j = 0;
1234         for (uint256 k = 0; k < length; k++) {
1235             if (includeMap[k]) {
1236                 newAddresses[j] = A[k];
1237                 j++;
1238             }
1239         }
1240         return newAddresses;
1241     }
1242 
1243     /**
1244      * Returns the union of the two arrays. Order is not guaranteed.
1245      * @param A The first array
1246      * @param B The second array
1247      * @return The union of the two arrays
1248      */
1249     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1250         address[] memory leftDifference = difference(A, B);
1251         address[] memory rightDifference = difference(B, A);
1252         address[] memory intersection = intersect(A, B);
1253         return extend(leftDifference, extend(intersection, rightDifference));
1254     }
1255 
1256     /**
1257      * Alternate implementation
1258      * Assumes there are no duplicates
1259      */
1260     function unionB(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1261         bool[] memory includeMap = new bool[](A.length + B.length);
1262         uint256 count = 0;
1263         for (uint256 i = 0; i < A.length; i++) {
1264             includeMap[i] = true;
1265             count++;
1266         }
1267         for (uint256 j = 0; j < B.length; j++) {
1268             if (!contains(A, B[j])) {
1269                 includeMap[A.length + j] = true;
1270                 count++;
1271             }
1272         }
1273         address[] memory newAddresses = new address[](count);
1274         uint256 k = 0;
1275         for (uint256 m = 0; m < A.length; m++) {
1276             if (includeMap[m]) {
1277                 newAddresses[k] = A[m];
1278                 k++;
1279             }
1280         }
1281         for (uint256 n = 0; n < B.length; n++) {
1282             if (includeMap[A.length + n]) {
1283                 newAddresses[k] = B[n];
1284                 k++;
1285             }
1286         }
1287         return newAddresses;
1288     }
1289 
1290     /**
1291      * Computes the difference of two arrays. Assumes there are no duplicates.
1292      * @param A The first array
1293      * @param B The second array
1294      * @return The difference of the two arrays
1295      */
1296     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1297         uint256 length = A.length;
1298         bool[] memory includeMap = new bool[](length);
1299         uint256 count = 0;
1300         // First count the new length because can't push for in-memory arrays
1301         for (uint256 i = 0; i < length; i++) {
1302             address e = A[i];
1303             if (!contains(B, e)) {
1304                 includeMap[i] = true;
1305                 count++;
1306             }
1307         }
1308         address[] memory newAddresses = new address[](count);
1309         uint256 j = 0;
1310         for (uint256 k = 0; k < length; k++) {
1311             if (includeMap[k]) {
1312                 newAddresses[j] = A[k];
1313                 j++;
1314             }
1315         }
1316         return newAddresses;
1317     }
1318 
1319     /**
1320     * @dev Reverses storage array in place
1321     */
1322     function sReverse(address[] storage A) internal {
1323         address t;
1324         uint256 length = A.length;
1325         for (uint256 i = 0; i < length / 2; i++) {
1326             t = A[i];
1327             A[i] = A[A.length - i - 1];
1328             A[A.length - i - 1] = t;
1329         }
1330     }
1331 
1332     /**
1333     * Removes specified index from array
1334     * Resulting ordering is not guaranteed
1335     * @return Returns the new array and the removed entry
1336     */
1337     function pop(address[] memory A, uint256 index)
1338         internal
1339         pure
1340         returns (address[] memory, address)
1341     {
1342         uint256 length = A.length;
1343         address[] memory newAddresses = new address[](length - 1);
1344         for (uint256 i = 0; i < index; i++) {
1345             newAddresses[i] = A[i];
1346         }
1347         for (uint256 j = index + 1; j < length; j++) {
1348             newAddresses[j - 1] = A[j];
1349         }
1350         return (newAddresses, A[index]);
1351     }
1352 
1353     /**
1354      * @return Returns the new array
1355      */
1356     function remove(address[] memory A, address a)
1357         internal
1358         pure
1359         returns (address[] memory)
1360     {
1361         (uint256 index, bool isIn) = indexOf(A, a);
1362         if (!isIn) {
1363             revert();
1364         } else {
1365             (address[] memory _A,) = pop(A, index);
1366             return _A;
1367         }
1368     }
1369 
1370     function sPop(address[] storage A, uint256 index) internal returns (address) {
1371         uint256 length = A.length;
1372         if (index >= length) {
1373             revert("Error: index out of bounds");
1374         }
1375         address entry = A[index];
1376         for (uint256 i = index; i < length - 1; i++) {
1377             A[i] = A[i + 1];
1378         }
1379         A.length--;
1380         return entry;
1381     }
1382 
1383     /**
1384     * Deletes address at index and fills the spot with the last address.
1385     * Order is not preserved.
1386     * @return Returns the removed entry
1387     */
1388     function sPopCheap(address[] storage A, uint256 index) internal returns (address) {
1389         uint256 length = A.length;
1390         if (index >= length) {
1391             revert("Error: index out of bounds");
1392         }
1393         address entry = A[index];
1394         if (index != length - 1) {
1395             A[index] = A[length - 1];
1396             delete A[length - 1];
1397         }
1398         A.length--;
1399         return entry;
1400     }
1401 
1402     /**
1403      * Deletes address at index. Works by swapping it with the last address, then deleting.
1404      * Order is not preserved
1405      * @param A Storage array to remove from
1406      */
1407     function sRemoveCheap(address[] storage A, address a) internal {
1408         (uint256 index, bool isIn) = indexOf(A, a);
1409         if (!isIn) {
1410             revert("Error: entry not found");
1411         } else {
1412             sPopCheap(A, index);
1413             return;
1414         }
1415     }
1416 
1417     /**
1418      * Returns whether or not there's a duplicate. Runs in O(n^2).
1419      * @param A Array to search
1420      * @return Returns true if duplicate, false otherwise
1421      */
1422     function hasDuplicate(address[] memory A) internal pure returns (bool) {
1423         if (A.length == 0) {
1424             return false;
1425         }
1426         for (uint256 i = 0; i < A.length - 1; i++) {
1427             for (uint256 j = i + 1; j < A.length; j++) {
1428                 if (A[i] == A[j]) {
1429                     return true;
1430                 }
1431             }
1432         }
1433         return false;
1434     }
1435 
1436     /**
1437      * Returns whether the two arrays are equal.
1438      * @param A The first array
1439      * @param B The second array
1440      * @return True is the arrays are equal, false if not.
1441      */
1442     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
1443         if (A.length != B.length) {
1444             return false;
1445         }
1446         for (uint256 i = 0; i < A.length; i++) {
1447             if (A[i] != B[i]) {
1448                 return false;
1449             }
1450         }
1451         return true;
1452     }
1453 
1454     /**
1455      * Returns the elements indexed at indexArray.
1456      * @param A The array to index
1457      * @param indexArray The array to use to index
1458      * @return Returns array containing elements indexed at indexArray
1459      */
1460     function argGet(address[] memory A, uint256[] memory indexArray)
1461         internal
1462         pure
1463         returns (address[] memory)
1464     {
1465         address[] memory array = new address[](indexArray.length);
1466         for (uint256 i = 0; i < indexArray.length; i++) {
1467             array[i] = A[indexArray[i]];
1468         }
1469         return array;
1470     }
1471 
1472 }
1473 
1474 // File: contracts/lib/TimeLockUpgrade.sol
1475 
1476 /*
1477     Copyright 2018 Set Labs Inc.
1478 
1479     Licensed under the Apache License, Version 2.0 (the "License");
1480     you may not use this file except in compliance with the License.
1481     You may obtain a copy of the License at
1482 
1483     http://www.apache.org/licenses/LICENSE-2.0
1484 
1485     Unless required by applicable law or agreed to in writing, software
1486     distributed under the License is distributed on an "AS IS" BASIS,
1487     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1488     See the License for the specific language governing permissions and
1489     limitations under the License.
1490 */
1491 
1492 pragma solidity 0.5.7;
1493 
1494 
1495 
1496 
1497 /**
1498  * @title TimeLockUpgrade
1499  * @author Set Protocol
1500  *
1501  * The TimeLockUpgrade contract contains a modifier for handling minimum time period updates
1502  */
1503 contract TimeLockUpgrade is
1504     Ownable
1505 {
1506     using SafeMath for uint256;
1507 
1508     /* ============ State Variables ============ */
1509 
1510     // Timelock Upgrade Period in seconds
1511     uint256 public timeLockPeriod;
1512 
1513     // Mapping of upgradable units and initialized timelock
1514     mapping(bytes32 => uint256) public timeLockedUpgrades;
1515 
1516     /* ============ Events ============ */
1517 
1518     event UpgradeRegistered(
1519         bytes32 _upgradeHash,
1520         uint256 _timestamp
1521     );
1522 
1523     /* ============ Modifiers ============ */
1524 
1525     modifier timeLockUpgrade() {
1526         // If the time lock period is 0, then allow non-timebound upgrades.
1527         // This is useful for initialization of the protocol and for testing.
1528         if (timeLockPeriod == 0) {
1529             _;
1530 
1531             return;
1532         }
1533 
1534         // The upgrade hash is defined by the hash of the transaction call data,
1535         // which uniquely identifies the function as well as the passed in arguments.
1536         bytes32 upgradeHash = keccak256(
1537             abi.encodePacked(
1538                 msg.data
1539             )
1540         );
1541 
1542         uint256 registrationTime = timeLockedUpgrades[upgradeHash];
1543 
1544         // If the upgrade hasn't been registered, register with the current time.
1545         if (registrationTime == 0) {
1546             timeLockedUpgrades[upgradeHash] = block.timestamp;
1547 
1548             emit UpgradeRegistered(
1549                 upgradeHash,
1550                 block.timestamp
1551             );
1552 
1553             return;
1554         }
1555 
1556         require(
1557             block.timestamp >= registrationTime.add(timeLockPeriod),
1558             "TimeLockUpgrade: Time lock period must have elapsed."
1559         );
1560 
1561         // Reset the timestamp to 0
1562         timeLockedUpgrades[upgradeHash] = 0;
1563 
1564         // Run the rest of the upgrades
1565         _;
1566     }
1567 
1568     /* ============ Function ============ */
1569 
1570     /**
1571      * Change timeLockPeriod period. Generally called after initially settings have been set up.
1572      *
1573      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
1574      */
1575     function setTimeLockPeriod(
1576         uint256 _timeLockPeriod
1577     )
1578         external
1579         onlyOwner
1580     {
1581         // Only allow setting of the timeLockPeriod if the period is greater than the existing
1582         require(
1583             _timeLockPeriod > timeLockPeriod,
1584             "TimeLockUpgrade: New period must be greater than existing"
1585         );
1586 
1587         timeLockPeriod = _timeLockPeriod;
1588     }
1589 }
1590 
1591 // File: contracts/core/extensions/CoreAdmin.sol
1592 
1593 /*
1594     Copyright 2018 Set Labs Inc.
1595 
1596     Licensed under the Apache License, Version 2.0 (the "License");
1597     you may not use this file except in compliance with the License.
1598     You may obtain a copy of the License at
1599 
1600     http://www.apache.org/licenses/LICENSE-2.0
1601 
1602     Unless required by applicable law or agreed to in writing, software
1603     distributed under the License is distributed on an "AS IS" BASIS,
1604     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1605     See the License for the specific language governing permissions and
1606     limitations under the License.
1607 */
1608 
1609 pragma solidity 0.5.7;
1610 
1611 
1612 
1613 
1614 
1615 
1616 /**
1617  * @title CoreAdmin
1618  * @author Set Protocol
1619  *
1620  * The CoreAdmin contract contains methods to alter state of variables that track
1621  * Core dependency addresses.
1622  */
1623 contract CoreAdmin is
1624     Ownable,
1625     CoreState,
1626     TimeLockUpgrade
1627 {
1628     using AddressArrayUtils for address[];
1629 
1630     /* ============ Events ============ */
1631 
1632     event FactoryAdded(
1633         address _factory
1634     );
1635 
1636     event FactoryRemoved(
1637         address _factory
1638     );
1639 
1640     event ExchangeAdded(
1641         uint8 _exchangeId,
1642         address _exchange
1643     );
1644 
1645     event ExchangeRemoved(
1646         uint8 _exchangeId
1647     );
1648 
1649     event ModuleAdded(
1650         address _module
1651     );
1652 
1653     event ModuleRemoved(
1654         address _module
1655     );
1656 
1657     event SetDisabled(
1658         address _set
1659     );
1660 
1661     event SetReenabled(
1662         address _set
1663     );
1664 
1665     event PriceLibraryAdded(
1666         address _priceLibrary
1667     );
1668 
1669     event PriceLibraryRemoved(
1670         address _priceLibrary
1671     );
1672 
1673     /* ============ External Functions ============ */
1674 
1675     /**
1676      * Add a factory from the mapping of tracked factories.
1677      * Can only be called by owner of Core.
1678      *
1679      * @param  _factory   Address of the factory conforming to ISetFactory
1680      */
1681     function addFactory(
1682         address _factory
1683     )
1684         external
1685         onlyOwner
1686         timeLockUpgrade
1687     {
1688         require(
1689             !state.validFactories[_factory]
1690         );
1691 
1692         state.validFactories[_factory] = true;
1693 
1694         state.factories = state.factories.append(_factory);
1695 
1696         emit FactoryAdded(
1697             _factory
1698         );
1699     }
1700 
1701     /**
1702      * Remove a factory from the mapping of tracked factories.
1703      * Can only be called by owner of Core.
1704      *
1705      * @param  _factory   Address of the factory conforming to ISetFactory
1706      */
1707     function removeFactory(
1708         address _factory
1709     )
1710         external
1711         onlyOwner
1712     {
1713         require(
1714             state.validFactories[_factory]
1715         );
1716 
1717         state.factories = state.factories.remove(_factory);
1718 
1719         state.validFactories[_factory] = false;
1720 
1721         emit FactoryRemoved(
1722             _factory
1723         );
1724     }
1725 
1726     /**
1727      * Add an exchange address with the mapping of tracked exchanges.
1728      * Can only be called by owner of Core.
1729      *
1730      * @param _exchangeId   Enumeration of exchange within the mapping
1731      * @param _exchange     Address of the exchange conforming to IExchangeWrapper
1732      */
1733     function addExchange(
1734         uint8 _exchangeId,
1735         address _exchange
1736     )
1737         external
1738         onlyOwner
1739         timeLockUpgrade
1740     {
1741         require(
1742             state.exchangeIds[_exchangeId] == address(0)
1743         );
1744 
1745         state.exchangeIds[_exchangeId] = _exchange;
1746 
1747         state.exchanges = state.exchanges.append(_exchange);
1748 
1749         emit ExchangeAdded(
1750             _exchangeId,
1751             _exchange
1752         );
1753     }
1754 
1755     /**
1756      * Remove an exchange address with the mapping of tracked exchanges.
1757      * Can only be called by owner of Core.
1758      *
1759      * @param _exchangeId   Enumeration of exchange within the mapping
1760      * @param _exchange     Address of the exchange conforming to IExchangeWrapper
1761      */
1762     function removeExchange(
1763         uint8 _exchangeId,
1764         address _exchange
1765     )
1766         external
1767         onlyOwner
1768     {
1769         require(
1770             state.exchangeIds[_exchangeId] != address(0) &&
1771             state.exchangeIds[_exchangeId] == _exchange
1772         );
1773 
1774         state.exchanges = state.exchanges.remove(_exchange);
1775 
1776         state.exchangeIds[_exchangeId] = address(0);
1777 
1778         emit ExchangeRemoved(
1779             _exchangeId
1780         );
1781     }
1782 
1783     /**
1784      * Add a module address with the mapping of tracked modules.
1785      * Can only be called by owner of Core.
1786      *
1787      * @param _module     Address of the module
1788      */
1789     function addModule(
1790         address _module
1791     )
1792         external
1793         onlyOwner
1794         timeLockUpgrade
1795     {
1796         require(
1797             !state.validModules[_module]
1798         );
1799 
1800         state.validModules[_module] = true;
1801 
1802         state.modules = state.modules.append(_module);
1803 
1804         emit ModuleAdded(
1805             _module
1806         );
1807     }
1808 
1809     /**
1810      * Remove a module address with the mapping of tracked modules.
1811      * Can only be called by owner of Core.
1812      *
1813      * @param _module   Enumeration of module within the mapping
1814      */
1815     function removeModule(
1816         address _module
1817     )
1818         external
1819         onlyOwner
1820     {
1821         require(
1822             state.validModules[_module]
1823         );
1824 
1825         state.modules = state.modules.remove(_module);
1826 
1827         state.validModules[_module] = false;
1828 
1829         emit ModuleRemoved(
1830             _module
1831         );
1832     }
1833 
1834     /**
1835      * Disables a Set from the mapping and array of tracked Sets.
1836      * Can only be called by owner of Core.
1837      *
1838      * @param  _set       Address of the Set
1839      */
1840     function disableSet(
1841         address _set
1842     )
1843         external
1844         onlyOwner
1845     {
1846         require(
1847             state.validSets[_set]
1848         );
1849 
1850         state.setTokens = state.setTokens.remove(_set);
1851 
1852         state.validSets[_set] = false;
1853 
1854         state.disabledSets[_set] = true;
1855 
1856         emit SetDisabled(
1857             _set
1858         );
1859     }
1860 
1861     /**
1862      * Enables a Set from the mapping and array of tracked Sets if it has been previously disabled
1863      * Can only be called by owner of Core.
1864      *
1865      * @param  _set       Address of the Set
1866      */
1867     function reenableSet(
1868         address _set
1869     )
1870         external
1871         onlyOwner
1872     {
1873         require(
1874             state.disabledSets[_set]
1875         );
1876 
1877         state.setTokens = state.setTokens.append(_set);
1878 
1879         state.validSets[_set] = true;
1880 
1881         state.disabledSets[_set] = false;
1882 
1883         emit SetReenabled(
1884             _set
1885         );
1886     }
1887 
1888     /**
1889      * Add a price library from the mapping of tracked price libraries.
1890      * Can only be called by owner of Core.
1891      *
1892      * @param  _priceLibrary   Address of the price library
1893      */
1894     function addPriceLibrary(
1895         address _priceLibrary
1896     )
1897         external
1898         onlyOwner
1899         timeLockUpgrade
1900     {
1901         require(
1902             !state.validPriceLibraries[_priceLibrary]
1903         );
1904 
1905         state.validPriceLibraries[_priceLibrary] = true;
1906 
1907         state.priceLibraries = state.priceLibraries.append(_priceLibrary);
1908 
1909         emit PriceLibraryAdded(
1910             _priceLibrary
1911         );
1912     }
1913 
1914     /**
1915      * Remove a price library from the mapping of tracked price libraries.
1916      * Can only be called by owner of Core.
1917      *
1918      * @param  _priceLibrary   Address of the price library
1919      */
1920     function removePriceLibrary(
1921         address _priceLibrary
1922     )
1923         external
1924         onlyOwner
1925     {
1926         require(
1927             state.validPriceLibraries[_priceLibrary]
1928         );
1929 
1930         state.priceLibraries = state.priceLibraries.remove(_priceLibrary);
1931 
1932         state.validPriceLibraries[_priceLibrary] = false;
1933 
1934         emit PriceLibraryRemoved(
1935             _priceLibrary
1936         );
1937     }
1938 }
1939 
1940 // File: contracts/core/interfaces/ISetFactory.sol
1941 
1942 /*
1943     Copyright 2018 Set Labs Inc.
1944 
1945     Licensed under the Apache License, Version 2.0 (the "License");
1946     you may not use this file except in compliance with the License.
1947     You may obtain a copy of the License at
1948 
1949     http://www.apache.org/licenses/LICENSE-2.0
1950 
1951     Unless required by applicable law or agreed to in writing, software
1952     distributed under the License is distributed on an "AS IS" BASIS,
1953     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1954     See the License for the specific language governing permissions and
1955     limitations under the License.
1956 */
1957 
1958 pragma solidity 0.5.7;
1959 
1960 
1961 /**
1962  * @title ISetFactory
1963  * @author Set Protocol
1964  *
1965  * The ISetFactory interface provides operability for authorized contracts
1966  * to interact with SetTokenFactory
1967  */
1968 interface ISetFactory {
1969 
1970     /* ============ External Functions ============ */
1971 
1972     /**
1973      * Return core address
1974      *
1975      * @return address        core address
1976      */
1977     function core()
1978         external
1979         returns (address);
1980 
1981     /**
1982      * Deploys a new Set Token and adds it to the valid list of SetTokens
1983      *
1984      * @param  _components           The address of component tokens
1985      * @param  _units                The units of each component token
1986      * @param  _naturalUnit          The minimum unit to be issued or redeemed
1987      * @param  _name                 The bytes32 encoded name of the new Set
1988      * @param  _symbol               The bytes32 encoded symbol of the new Set
1989      * @param  _callData             Byte string containing additional call parameters
1990      * @return setTokenAddress       The address of the new Set
1991      */
1992     function createSet(
1993         address[] calldata _components,
1994         uint[] calldata _units,
1995         uint256 _naturalUnit,
1996         bytes32 _name,
1997         bytes32 _symbol,
1998         bytes calldata _callData
1999     )
2000         external
2001         returns (address);
2002 }
2003 
2004 // File: contracts/core/extensions/CoreFactory.sol
2005 
2006 /*
2007     Copyright 2018 Set Labs Inc.
2008 
2009     Licensed under the Apache License, Version 2.0 (the "License");
2010     you may not use this file except in compliance with the License.
2011     You may obtain a copy of the License at
2012 
2013     http://www.apache.org/licenses/LICENSE-2.0
2014 
2015     Unless required by applicable law or agreed to in writing, software
2016     distributed under the License is distributed on an "AS IS" BASIS,
2017     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2018     See the License for the specific language governing permissions and
2019     limitations under the License.
2020 */
2021 
2022 pragma solidity 0.5.7;
2023 
2024 
2025 
2026 
2027 /**
2028  * @title CoreFactory
2029  * @author Set Protocol
2030  *
2031  * The CoreFactory contract contains Set Token creation operations
2032  */
2033 contract CoreFactory is
2034     CoreState
2035 {
2036     /* ============ Events ============ */
2037 
2038     event SetTokenCreated(
2039         address indexed _setTokenAddress,
2040         address _factory,
2041         address[] _components,
2042         uint256[] _units,
2043         uint256 _naturalUnit,
2044         bytes32 _name,
2045         bytes32 _symbol
2046     );
2047 
2048     /* ============ External Functions ============ */
2049 
2050     /**
2051      * Deploys a new Set Token and adds it to the valid list of SetTokens
2052      *
2053      * @param  _factory              The address of the Factory to create from
2054      * @param  _components           The address of component tokens
2055      * @param  _units                The units of each component token
2056      * @param  _naturalUnit          The minimum unit to be issued or redeemed
2057      * @param  _name                 The bytes32 encoded name of the new Set
2058      * @param  _symbol               The bytes32 encoded symbol of the new Set
2059      * @param  _callData             Byte string containing additional call parameters
2060      * @return setTokenAddress       The address of the new Set
2061      */
2062     function createSet(
2063         address _factory,
2064         address[] calldata _components,
2065         uint256[] calldata _units,
2066         uint256 _naturalUnit,
2067         bytes32 _name,
2068         bytes32 _symbol,
2069         bytes calldata _callData
2070     )
2071         external
2072         returns (address)
2073     {
2074         // Verify Factory is linked to Core
2075         require(
2076             state.validFactories[_factory],
2077             "CreateSet"
2078         );
2079 
2080         // Create the Set
2081         address newSetTokenAddress = ISetFactory(_factory).createSet(
2082             _components,
2083             _units,
2084             _naturalUnit,
2085             _name,
2086             _symbol,
2087             _callData
2088         );
2089 
2090         // Add Set to the mapping of tracked Sets
2091         state.validSets[newSetTokenAddress] = true;
2092 
2093         // Add Set to the array of tracked Sets
2094         state.setTokens.push(newSetTokenAddress);
2095 
2096         // Emit Set Token creation log
2097         emit SetTokenCreated(
2098             newSetTokenAddress,
2099             _factory,
2100             _components,
2101             _units,
2102             _naturalUnit,
2103             _name,
2104             _symbol
2105         );
2106 
2107         return newSetTokenAddress;
2108     }
2109 }
2110 
2111 // File: contracts/lib/CommonMath.sol
2112 
2113 /*
2114     Copyright 2018 Set Labs Inc.
2115 
2116     Licensed under the Apache License, Version 2.0 (the "License");
2117     you may not use this file except in compliance with the License.
2118     You may obtain a copy of the License at
2119 
2120     http://www.apache.org/licenses/LICENSE-2.0
2121 
2122     Unless required by applicable law or agreed to in writing, software
2123     distributed under the License is distributed on an "AS IS" BASIS,
2124     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2125     See the License for the specific language governing permissions and
2126     limitations under the License.
2127 */
2128 
2129 pragma solidity 0.5.7;
2130 
2131 
2132 
2133 library CommonMath {
2134     using SafeMath for uint256;
2135 
2136     /**
2137      * Calculates and returns the maximum value for a uint256
2138      *
2139      * @return  The maximum value for uint256
2140      */
2141     function maxUInt256()
2142         internal
2143         pure
2144         returns (uint256)
2145     {
2146         return 2 ** 256 - 1;
2147     }
2148 
2149     /**
2150     * @dev Performs the power on a specified value, reverts on overflow.
2151     */
2152     function safePower(
2153         uint256 a,
2154         uint256 pow
2155     )
2156         internal
2157         pure
2158         returns (uint256)
2159     {
2160         require(a > 0);
2161 
2162         uint256 result = 1;
2163         for (uint256 i = 0; i < pow; i++){
2164             uint256 previousResult = result;
2165 
2166             // Using safemath multiplication prevents overflows
2167             result = previousResult.mul(a);
2168         }
2169 
2170         return result;
2171     }
2172 
2173     /**
2174      * Checks for rounding errors and returns value of potential partial amounts of a principal
2175      *
2176      * @param  _principal       Number fractional amount is derived from
2177      * @param  _numerator       Numerator of fraction
2178      * @param  _denominator     Denominator of fraction
2179      * @return uint256          Fractional amount of principal calculated
2180      */
2181     function getPartialAmount(
2182         uint256 _principal,
2183         uint256 _numerator,
2184         uint256 _denominator
2185     )
2186         internal
2187         pure
2188         returns (uint256)
2189     {
2190         // Get remainder of partial amount (if 0 not a partial amount)
2191         uint256 remainder = mulmod(_principal, _numerator, _denominator);
2192 
2193         // Return if not a partial amount
2194         if (remainder == 0) {
2195             return _principal.mul(_numerator).div(_denominator);
2196         }
2197 
2198         // Calculate error percentage
2199         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
2200 
2201         // Require error percentage is less than 0.1%.
2202         require(
2203             errPercentageTimes1000000 < 1000,
2204             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
2205         );
2206 
2207         return _principal.mul(_numerator).div(_denominator);
2208     }
2209 
2210 }
2211 
2212 // File: contracts/core/lib/CoreIssuanceLibrary.sol
2213 
2214 /*
2215     Copyright 2018 Set Labs Inc.
2216 
2217     Licensed under the Apache License, Version 2.0 (the "License");
2218     you may not use this file except in compliance with the License.
2219     You may obtain a copy of the License at
2220 
2221     http://www.apache.org/licenses/LICENSE-2.0
2222 
2223     Unless required by applicable law or agreed to in writing, software
2224     distributed under the License is distributed on an "AS IS" BASIS,
2225     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2226     See the License for the specific language governing permissions and
2227     limitations under the License.
2228 */
2229 
2230 pragma solidity 0.5.7;
2231 
2232 
2233 
2234 
2235 
2236 /**
2237  * @title CoreIssuanceLibrary
2238  * @author Set Protocol
2239  *
2240  * This library contains functions for calculating deposit, withdrawal,and transfer quantities
2241  */
2242 library CoreIssuanceLibrary {
2243 
2244     using SafeMath for uint256;
2245 
2246     /**
2247      * Calculate the quantities required to deposit and decrement during issuance. Takes into account
2248      * the tokens an owner already has in the vault.
2249      *
2250      * @param _components                           Addresses of components
2251      * @param _componentQuantities                  Component quantities to increment and withdraw
2252      * @param _owner                                Address to deposit and decrement quantities from
2253      * @param _vault                                Address to vault
2254      * @return uint256[] decrementQuantities        Quantities to decrement from vault
2255      * @return uint256[] depositQuantities          Quantities to deposit into the vault
2256      */
2257     function calculateDepositAndDecrementQuantities(
2258         address[] calldata _components,
2259         uint256[] calldata _componentQuantities,
2260         address _owner,
2261         address _vault
2262     )
2263         external
2264         view
2265         returns (
2266             uint256[] memory /* decrementQuantities */,
2267             uint256[] memory /* depositQuantities */
2268         )
2269     {
2270         uint256 componentCount = _components.length;
2271         uint256[] memory decrementTokenOwnerValues = new uint256[](componentCount);
2272         uint256[] memory depositQuantities = new uint256[](componentCount);
2273 
2274         for (uint256 i = 0; i < componentCount; i++) {
2275             // Fetch component quantity in vault
2276             uint256 vaultBalance = IVault(_vault).getOwnerBalance(
2277                 _components[i],
2278                 _owner
2279             );
2280 
2281             // If the vault holds enough components, decrement the full amount
2282             if (vaultBalance >= _componentQuantities[i]) {
2283                 decrementTokenOwnerValues[i] = _componentQuantities[i];
2284             } else {
2285                 // User has less than required amount, decrement the vault by full balance
2286                 if (vaultBalance > 0) {
2287                     decrementTokenOwnerValues[i] = vaultBalance;
2288                 }
2289 
2290                 depositQuantities[i] = _componentQuantities[i].sub(vaultBalance);
2291             }
2292         }
2293 
2294         return (
2295             decrementTokenOwnerValues,
2296             depositQuantities
2297         );
2298     }
2299 
2300     /**
2301      * Calculate the quantities required to withdraw and increment during redeem and withdraw. Takes into
2302      * account a bitmask exclusion parameter.
2303      *
2304      * @param _componentQuantities                  Component quantities to increment and withdraw
2305      * @param _toExclude                            Mask of indexes of tokens to exclude from withdrawing
2306      * @return uint256[] incrementQuantities        Quantities to increment in vault
2307      * @return uint256[] withdrawQuantities         Quantities to withdraw from vault
2308      */
2309     function calculateWithdrawAndIncrementQuantities(
2310         uint256[] calldata _componentQuantities,
2311         uint256 _toExclude
2312     )
2313         external
2314         pure
2315         returns (
2316             uint256[] memory /* incrementQuantities */,
2317             uint256[] memory /* withdrawQuantities */
2318         )
2319     {
2320         uint256 componentCount = _componentQuantities.length;
2321         uint256[] memory incrementTokenOwnerValues = new uint256[](componentCount);
2322         uint256[] memory withdrawToValues = new uint256[](componentCount);
2323 
2324         // Loop through and decrement vault balances for the set, withdrawing if requested
2325         for (uint256 i = 0; i < componentCount; i++) {
2326             // Calculate bit index of current component
2327             uint256 componentBitIndex = CommonMath.safePower(2, i);
2328 
2329             // Transfer to user unless component index is included in _toExclude
2330             if ((_toExclude & componentBitIndex) != 0) {
2331                 incrementTokenOwnerValues[i] = _componentQuantities[i];
2332             } else {
2333                 withdrawToValues[i] = _componentQuantities[i];
2334             }
2335         }
2336 
2337         return (
2338             incrementTokenOwnerValues,
2339             withdrawToValues
2340         );
2341     }
2342 
2343     /**
2344      * Calculate the required component quantities required for issuance or rdemption for a given
2345      * quantity of Set Tokens
2346      *
2347      * @param _componentUnits   The units of the component token
2348      * @param _naturalUnit      The natural unit of the Set token
2349      * @param _quantity         The number of tokens being redeem
2350      * @return uint256[]        Required quantities in base units of components
2351      */
2352     function calculateRequiredComponentQuantities(
2353         uint256[] calldata _componentUnits,
2354         uint256 _naturalUnit,
2355         uint256 _quantity
2356     )
2357         external
2358         pure
2359         returns (uint256[] memory)
2360     {
2361         require(
2362             _quantity.mod(_naturalUnit) == 0,
2363             "CoreIssuanceLibrary: Quantity must be a multiple of nat unit"
2364         );
2365 
2366         uint256[] memory tokenValues = new uint256[](_componentUnits.length);
2367 
2368         // Transfer the underlying tokens to the corresponding token balances
2369         for (uint256 i = 0; i < _componentUnits.length; i++) {
2370             tokenValues[i] = _quantity.div(_naturalUnit).mul(_componentUnits[i]);
2371         }
2372 
2373         return tokenValues;
2374     }
2375 
2376 }
2377 
2378 // File: contracts/core/interfaces/ISetToken.sol
2379 
2380 /*
2381     Copyright 2018 Set Labs Inc.
2382 
2383     Licensed under the Apache License, Version 2.0 (the "License");
2384     you may not use this file except in compliance with the License.
2385     You may obtain a copy of the License at
2386 
2387     http://www.apache.org/licenses/LICENSE-2.0
2388 
2389     Unless required by applicable law or agreed to in writing, software
2390     distributed under the License is distributed on an "AS IS" BASIS,
2391     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2392     See the License for the specific language governing permissions and
2393     limitations under the License.
2394 */
2395 
2396 pragma solidity 0.5.7;
2397 
2398 /**
2399  * @title ISetToken
2400  * @author Set Protocol
2401  *
2402  * The ISetToken interface provides a light-weight, structured way to interact with the
2403  * SetToken contract from another contract.
2404  */
2405 interface ISetToken {
2406 
2407     /* ============ External Functions ============ */
2408 
2409     /*
2410      * Get natural unit of Set
2411      *
2412      * @return  uint256       Natural unit of Set
2413      */
2414     function naturalUnit()
2415         external
2416         view
2417         returns (uint256);
2418 
2419     /*
2420      * Get addresses of all components in the Set
2421      *
2422      * @return  componentAddresses       Array of component tokens
2423      */
2424     function getComponents()
2425         external
2426         view
2427         returns (address[] memory);
2428 
2429     /*
2430      * Get units of all tokens in Set
2431      *
2432      * @return  units       Array of component units
2433      */
2434     function getUnits()
2435         external
2436         view
2437         returns (uint256[] memory);
2438 
2439     /*
2440      * Checks to make sure token is component of Set
2441      *
2442      * @param  _tokenAddress     Address of token being checked
2443      * @return  bool             True if token is component of Set
2444      */
2445     function tokenIsComponent(
2446         address _tokenAddress
2447     )
2448         external
2449         view
2450         returns (bool);
2451 
2452     /*
2453      * Mint set token for given address.
2454      * Can only be called by authorized contracts.
2455      *
2456      * @param  _issuer      The address of the issuing account
2457      * @param  _quantity    The number of sets to attribute to issuer
2458      */
2459     function mint(
2460         address _issuer,
2461         uint256 _quantity
2462     )
2463         external;
2464 
2465     /*
2466      * Burn set token for given address
2467      * Can only be called by authorized contracts
2468      *
2469      * @param  _from        The address of the redeeming account
2470      * @param  _quantity    The number of sets to burn from redeemer
2471      */
2472     function burn(
2473         address _from,
2474         uint256 _quantity
2475     )
2476         external;
2477 
2478     /**
2479     * Transfer token for a specified address
2480     *
2481     * @param to The address to transfer to.
2482     * @param value The amount to be transferred.
2483     */
2484     function transfer(
2485         address to,
2486         uint256 value
2487     )
2488         external;
2489 }
2490 
2491 // File: contracts/core/lib/SetTokenLibrary.sol
2492 
2493 /*
2494     Copyright 2018 Set Labs Inc.
2495 
2496     Licensed under the Apache License, Version 2.0 (the "License");
2497     you may not use this file except in compliance with the License.
2498     You may obtain a copy of the License at
2499 
2500     http://www.apache.org/licenses/LICENSE-2.0
2501 
2502     Unless required by applicable law or agreed to in writing, software
2503     distributed under the License is distributed on an "AS IS" BASIS,
2504     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2505     See the License for the specific language governing permissions and
2506     limitations under the License.
2507 */
2508 
2509 pragma solidity 0.5.7;
2510 
2511 
2512 
2513 
2514 library SetTokenLibrary {
2515     using SafeMath for uint256;
2516 
2517     struct SetDetails {
2518         uint256 naturalUnit;
2519         address[] components;
2520         uint256[] units;
2521     }
2522 
2523     /**
2524      * Validates that passed in tokens are all components of the Set
2525      *
2526      * @param _set                      Address of the Set
2527      * @param _tokens                   List of tokens to check
2528      */
2529     function validateTokensAreComponents(
2530         address _set,
2531         address[] calldata _tokens
2532     )
2533         external
2534         view
2535     {
2536         for (uint256 i = 0; i < _tokens.length; i++) {
2537             // Make sure all tokens are members of the Set
2538             require(
2539                 ISetToken(_set).tokenIsComponent(_tokens[i]),
2540                 "SetTokenLibrary.validateTokensAreComponents: Component must be a member of Set"
2541             );
2542 
2543         }
2544     }
2545 
2546     /**
2547      * Validates that passed in quantity is a multiple of the natural unit of the Set.
2548      *
2549      * @param _set                      Address of the Set
2550      * @param _quantity                   Quantity to validate
2551      */
2552     function isMultipleOfSetNaturalUnit(
2553         address _set,
2554         uint256 _quantity
2555     )
2556         external
2557         view
2558     {
2559         require(
2560             _quantity.mod(ISetToken(_set).naturalUnit()) == 0,
2561             "SetTokenLibrary.isMultipleOfSetNaturalUnit: Quantity is not a multiple of nat unit"
2562         );
2563     }
2564 
2565     /**
2566      * Retrieves the Set's natural unit, components, and units.
2567      *
2568      * @param _set                      Address of the Set
2569      * @return SetDetails               Struct containing the natural unit, components, and units
2570      */
2571     function getSetDetails(
2572         address _set
2573     )
2574         internal
2575         view
2576         returns (SetDetails memory)
2577     {
2578         // Declare interface variables
2579         ISetToken setToken = ISetToken(_set);
2580 
2581         // Fetch set token properties
2582         uint256 naturalUnit = setToken.naturalUnit();
2583         address[] memory components = setToken.getComponents();
2584         uint256[] memory units = setToken.getUnits();
2585 
2586         return SetDetails({
2587             naturalUnit: naturalUnit,
2588             components: components,
2589             units: units
2590         });
2591     }
2592 }
2593 
2594 // File: contracts/core/extensions/CoreIssuance.sol
2595 
2596 /*
2597     Copyright 2018 Set Labs Inc.
2598 
2599     Licensed under the Apache License, Version 2.0 (the "License");
2600     you may not use this file except in compliance with the License.
2601     You may obtain a copy of the License at
2602 
2603     http://www.apache.org/licenses/LICENSE-2.0
2604 
2605     Unless required by applicable law or agreed to in writing, software
2606     distributed under the License is distributed on an "AS IS" BASIS,
2607     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2608     See the License for the specific language governing permissions and
2609     limitations under the License.
2610 */
2611 
2612 pragma solidity 0.5.7;
2613 
2614 
2615 
2616 
2617 
2618 
2619 
2620 
2621 
2622 /**
2623  * @title CoreIssuance
2624  * @author Set Protocol
2625  *
2626  * The CoreIssuance contract contains function related to issuing and redeeming Sets.
2627  */
2628 contract CoreIssuance is
2629     CoreState,
2630     CoreOperationState,
2631     ReentrancyGuard
2632 {
2633     // Use SafeMath library for all uint256 arithmetic
2634     using SafeMath for uint256;
2635 
2636     /* ============ Events ============ */
2637 
2638     event SetIssued(
2639         address _setAddress,
2640         uint256 _quantity
2641     );
2642 
2643     event SetRedeemed(
2644         address _setAddress,
2645         uint256 _quantity
2646     );
2647 
2648     /* ============ External Functions ============ */
2649 
2650     /**
2651      * Issues a specified Set for a specified quantity to the caller
2652      * using the caller's components from the wallet and vault.
2653      *
2654      * @param  _set          Address of the Set to issue
2655      * @param  _quantity     Number of tokens to issue
2656      */
2657     function issue(
2658         address _set,
2659         uint256 _quantity
2660     )
2661         external
2662         nonReentrant
2663     {
2664         issueInternal(
2665             msg.sender,
2666             msg.sender,
2667             _set,
2668             _quantity
2669         );
2670     }
2671 
2672     /**
2673      * Converts user's components into Set Tokens owned by the user and stored in Vault
2674      *
2675      * @param _set          Address of the Set
2676      * @param _quantity     Number of tokens to redeem
2677      */
2678     function issueInVault(
2679         address _set,
2680         uint256 _quantity
2681     )
2682         external
2683         nonReentrant
2684     {
2685         issueInVaultInternal(
2686             msg.sender,
2687             _set,
2688             _quantity
2689         );
2690     }
2691 
2692     /**
2693      * Issues a specified Set for a specified quantity to the recipient
2694      * using the caller's components from the wallet and vault.
2695      *
2696      * @param  _recipient    Address to issue to
2697      * @param  _set          Address of the Set to issue
2698      * @param  _quantity     Number of tokens to issue
2699      */
2700     function issueTo(
2701         address _recipient,
2702         address _set,
2703         uint256 _quantity
2704     )
2705         external
2706         nonReentrant
2707     {
2708         issueInternal(
2709             msg.sender,
2710             _recipient,
2711             _set,
2712             _quantity
2713         );
2714     }
2715 
2716     /**
2717      * Exchange Set tokens for underlying components to the user held in the Vault.
2718      *
2719      * @param  _set          Address of the Set to redeem
2720      * @param  _quantity     Number of tokens to redeem
2721      */
2722     function redeem(
2723         address _set,
2724         uint256 _quantity
2725     )
2726         external
2727         nonReentrant
2728     {
2729         redeemInternal(
2730             msg.sender,
2731             msg.sender,
2732             _set,
2733             _quantity
2734         );
2735     }
2736 
2737     /**
2738      * Composite method to redeem and withdraw with a single transaction
2739      *
2740      * Normally, you should expect to be able to withdraw all of the tokens.
2741      * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
2742      * allows you to optionally specify which component tokens to exclude when
2743      * redeeming. They will remain in the vault under the users' addresses.
2744      *
2745      * @param _set          Address of the Set
2746      * @param _to           Address to withdraw or attribute tokens to
2747      * @param _quantity     Number of tokens to redeem
2748      * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
2749      */
2750     function redeemAndWithdrawTo(
2751         address _set,
2752         address _to,
2753         uint256 _quantity,
2754         uint256 _toExclude
2755     )
2756         external
2757         nonReentrant
2758     {
2759         uint256[] memory componentTransferValues = redeemAndDecrementVault(
2760             _set,
2761             msg.sender,
2762             _quantity
2763         );
2764 
2765         // Calculate the withdraw and increment quantities to specified address
2766         uint256[] memory incrementTokenOwnerValues;
2767         uint256[] memory withdrawToValues;
2768         (
2769             incrementTokenOwnerValues,
2770             withdrawToValues
2771         ) = CoreIssuanceLibrary.calculateWithdrawAndIncrementQuantities(
2772             componentTransferValues,
2773             _toExclude
2774         );
2775 
2776         address[] memory components = ISetToken(_set).getComponents();
2777 
2778         // Increment excluded components to the specified address
2779         state.vaultInstance.batchIncrementTokenOwner(
2780             components,
2781             _to,
2782             incrementTokenOwnerValues
2783         );
2784 
2785         // Withdraw non-excluded components and attribute to specified address
2786         state.vaultInstance.batchWithdrawTo(
2787             components,
2788             _to,
2789             withdrawToValues
2790         );
2791     }
2792 
2793     /**
2794      * Convert the caller's Set tokens held in the vault into underlying components to the user
2795      * held in the Vault.
2796      *
2797      * @param _set          Address of the Set
2798      * @param _quantity     Number of tokens to redeem
2799      */
2800     function redeemInVault(
2801         address _set,
2802         uint256 _quantity
2803     )
2804         external
2805         nonReentrant
2806     {
2807         // Decrement ownership of Set token in the vault
2808         state.vaultInstance.decrementTokenOwner(
2809             _set,
2810             msg.sender,
2811             _quantity
2812         );
2813 
2814         redeemInternal(
2815             state.vault,
2816             msg.sender,
2817             _set,
2818             _quantity
2819         );
2820     }
2821 
2822     /**
2823      * Redeem Set token and return components to specified recipient. The components
2824      * are left in the vault after redemption in the recipient's name.
2825      *
2826      * @param _recipient    Recipient of Set being issued
2827      * @param _set          Address of the Set
2828      * @param _quantity     Number of tokens to redeem
2829      */
2830     function redeemTo(
2831         address _recipient,
2832         address _set,
2833         uint256 _quantity
2834     )
2835         external
2836         nonReentrant
2837     {
2838         redeemInternal(
2839             msg.sender,
2840             _recipient,
2841             _set,
2842             _quantity
2843         );
2844     }
2845 
2846     /* ============ Internal Functions ============ */
2847 
2848     /**
2849      * Exchange components for Set tokens, accepting any owner
2850      * Used in issue, issueTo, and issueInVaultInternal
2851      *
2852      * @param  _componentOwner  Address to use tokens from
2853      * @param  _setRecipient    Address to issue Set to
2854      * @param  _set             Address of the Set to issue
2855      * @param  _quantity        Number of tokens to issue
2856      */
2857     function issueInternal(
2858         address _componentOwner,
2859         address _setRecipient,
2860         address _set,
2861         uint256 _quantity
2862     )
2863         internal
2864         whenOperational
2865     {
2866         // Verify Set was created by Core and is enabled
2867         require(
2868             state.validSets[_set],
2869             "IssueInternal"
2870         );
2871 
2872         // Validate quantity is multiple of natural unit
2873         SetTokenLibrary.isMultipleOfSetNaturalUnit(_set, _quantity);
2874 
2875         SetTokenLibrary.SetDetails memory setToken = SetTokenLibrary.getSetDetails(_set);
2876 
2877         // Calculate component quantities required to issue
2878         uint256[] memory requiredComponentQuantities = CoreIssuanceLibrary.calculateRequiredComponentQuantities(
2879             setToken.units,
2880             setToken.naturalUnit,
2881             _quantity
2882         );
2883 
2884         // Calculate the withdraw and increment quantities to caller
2885         uint256[] memory decrementTokenOwnerValues;
2886         uint256[] memory depositValues;
2887         (
2888             decrementTokenOwnerValues,
2889             depositValues
2890         ) = CoreIssuanceLibrary.calculateDepositAndDecrementQuantities(
2891             setToken.components,
2892             requiredComponentQuantities,
2893             _componentOwner,
2894             state.vault
2895         );
2896 
2897         // Decrement components used for issuance in vault
2898         state.vaultInstance.batchDecrementTokenOwner(
2899             setToken.components,
2900             _componentOwner,
2901             decrementTokenOwnerValues
2902         );
2903 
2904         // Deposit tokens used for issuance into vault
2905         state.transferProxyInstance.batchTransfer(
2906             setToken.components,
2907             depositValues,
2908             _componentOwner,
2909             state.vault
2910         );
2911 
2912         // Increment the vault balance of the set token for the components
2913         state.vaultInstance.batchIncrementTokenOwner(
2914             setToken.components,
2915             _set,
2916             requiredComponentQuantities
2917         );
2918 
2919         // Issue set token
2920         ISetToken(_set).mint(
2921             _setRecipient,
2922             _quantity
2923         );
2924 
2925         emit SetIssued(
2926             _set,
2927             _quantity
2928         );
2929     }
2930 
2931     /**
2932      * Converts recipient's components into Set Tokens held directly in Vault.
2933      * Used in issueInVault
2934      *
2935      * @param _recipient    Address to issue to
2936      * @param _set          Address of the Set
2937      * @param _quantity     Number of tokens to issue
2938      */
2939     function issueInVaultInternal(
2940         address _recipient,
2941         address _set,
2942         uint256 _quantity
2943     )
2944         internal
2945     {
2946         issueInternal(
2947             _recipient,
2948             state.vault,
2949             _set,
2950             _quantity
2951         );
2952 
2953         // Increment ownership of Set token in the vault
2954         state.vaultInstance.incrementTokenOwner(
2955             _set,
2956             _recipient,
2957             _quantity
2958         );
2959     }
2960 
2961     /**
2962      * Exchange Set tokens for underlying components. Components are attributed in the vault.
2963      * Used in redeem, redeemInVault, and redeemTo
2964      *
2965      * @param _burnAddress       Address to burn tokens from
2966      * @param _incrementAddress  Address to increment component tokens to
2967      * @param _set               Address of the Set to redeem
2968      * @param _quantity          Number of tokens to redeem
2969      */
2970     function redeemInternal(
2971         address _burnAddress,
2972         address _incrementAddress,
2973         address _set,
2974         uint256 _quantity
2975     )
2976         internal
2977     {
2978         uint256[] memory componentQuantities = redeemAndDecrementVault(
2979             _set,
2980             _burnAddress,
2981             _quantity
2982         );
2983 
2984         // Increment the component amount
2985         address[] memory components = ISetToken(_set).getComponents();
2986         state.vaultInstance.batchIncrementTokenOwner(
2987             components,
2988             _incrementAddress,
2989             componentQuantities
2990         );
2991     }
2992 
2993    /**
2994      * Private method that validates inputs, redeems Set, and decrements
2995      * the components in the vault
2996      *
2997      * @param _set                  Address of the Set to redeem
2998      * @param _burnAddress          Address to burn tokens from
2999      * @param _quantity             Number of tokens to redeem
3000      * @return componentQuantities  Transfer value of components
3001      */
3002     function redeemAndDecrementVault(
3003         address _set,
3004         address _burnAddress,
3005         uint256 _quantity
3006     )
3007         private
3008         returns (uint256[] memory)
3009     {
3010         // Verify Set was created by Core and is enabled
3011         require(
3012             state.validSets[_set],
3013             "RedeemAndDecrementVault"
3014         );
3015 
3016         // Validate quantity is multiple of natural unit
3017         SetTokenLibrary.isMultipleOfSetNaturalUnit(_set, _quantity);
3018 
3019         // Burn the Set token (thereby decrementing the Set balance)
3020         ISetToken(_set).burn(
3021             _burnAddress,
3022             _quantity
3023         );
3024 
3025         SetTokenLibrary.SetDetails memory setToken = SetTokenLibrary.getSetDetails(_set);
3026 
3027         // Calculate component quantities to redeem
3028         uint256[] memory componentQuantities = CoreIssuanceLibrary.calculateRequiredComponentQuantities(
3029             setToken.units,
3030             setToken.naturalUnit,
3031             _quantity
3032         );
3033 
3034         // Decrement components from Set's possession
3035         state.vaultInstance.batchDecrementTokenOwner(
3036             setToken.components,
3037             _set,
3038             componentQuantities
3039         );
3040 
3041         emit SetRedeemed(
3042             _set,
3043             _quantity
3044         );
3045 
3046         return componentQuantities;
3047     }
3048 }
3049 
3050 // File: contracts/core/interfaces/ICoreAccounting.sol
3051 
3052 /*
3053     Copyright 2018 Set Labs Inc.
3054 
3055     Licensed under the Apache License, Version 2.0 (the "License");
3056     you may not use this file except in compliance with the License.
3057     You may obtain a copy of the License at
3058 
3059     http://www.apache.org/licenses/LICENSE-2.0
3060 
3061     Unless required by applicable law or agreed to in writing, software
3062     distributed under the License is distributed on an "AS IS" BASIS,
3063     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3064     See the License for the specific language governing permissions and
3065     limitations under the License.
3066 */
3067 
3068 pragma solidity 0.5.7;
3069 
3070 
3071 /**
3072  * @title ICoreAccounting
3073  * @author Set Protocol
3074  *
3075  * The ICoreAccounting Contract defines all the functions exposed in the CoreIssuance
3076  * extension.
3077  */
3078 contract ICoreAccounting {
3079 
3080     /* ============ Internal Functions ============ */
3081 
3082     /**
3083      * Internal function that deposits multiple tokens to the vault.
3084      * Quantities should be in the order of the addresses of the tokens being deposited.
3085      *
3086      * @param  _from              Address to transfer tokens from
3087      * @param  _to                Address to credit for deposits
3088      * @param  _tokens            Array of the addresses of the tokens being deposited
3089      * @param  _quantities        Array of the amounts of tokens to deposit
3090      */
3091     function batchDepositInternal(
3092         address _from,
3093         address _to,
3094         address[] memory _tokens,
3095         uint[] memory _quantities
3096     )
3097         internal;
3098 
3099     /**
3100      * Internal function that withdraws multiple tokens from the vault.
3101      * Quantities should be in the order of the addresses of the tokens being withdrawn.
3102      *
3103      * @param  _from              Address to decredit for withdrawals
3104      * @param  _to                Address to transfer tokens to
3105      * @param  _tokens            Array of the addresses of the tokens being withdrawn
3106      * @param  _quantities        Array of the amounts of tokens to withdraw
3107      */
3108     function batchWithdrawInternal(
3109         address _from,
3110         address _to,
3111         address[] memory _tokens,
3112         uint256[] memory _quantities
3113     )
3114         internal;
3115 }
3116 
3117 // File: contracts/core/interfaces/ICoreIssuance.sol
3118 
3119 /*
3120     Copyright 2018 Set Labs Inc.
3121 
3122     Licensed under the Apache License, Version 2.0 (the "License");
3123     you may not use this file except in compliance with the License.
3124     You may obtain a copy of the License at
3125 
3126     http://www.apache.org/licenses/LICENSE-2.0
3127 
3128     Unless required by applicable law or agreed to in writing, software
3129     distributed under the License is distributed on an "AS IS" BASIS,
3130     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3131     See the License for the specific language governing permissions and
3132     limitations under the License.
3133 */
3134 
3135 pragma solidity 0.5.7;
3136 
3137 
3138 /**
3139  * @title ICoreIssuance
3140  * @author Set Protocol
3141  *
3142  * The ICoreIssuance Contract defines all the functions exposed in the CoreIssuance
3143  * extension.
3144  */
3145 contract ICoreIssuance {
3146 
3147     /* ============ Internal Functions ============ */
3148 
3149     /**
3150      * Exchange components for Set tokens, accepting any owner
3151      *
3152      * @param  _owner        Address to use tokens from
3153      * @param  _recipient    Address to issue Set to
3154      * @param  _set          Address of the Set to issue
3155      * @param  _quantity     Number of tokens to issue
3156      */
3157     function issueInternal(
3158         address _owner,
3159         address _recipient,
3160         address _set,
3161         uint256 _quantity
3162     )
3163         internal;
3164 
3165     /**
3166      * Converts recipient's components into Set Tokens held directly in Vault
3167      *
3168      * @param _recipient    Address to issue to
3169      * @param _set          Address of the Set
3170      * @param _quantity     Number of tokens to issue
3171      */
3172     function issueInVaultInternal(
3173         address _recipient,
3174         address _set,
3175         uint256 _quantity
3176     )
3177         internal;
3178 
3179     /**
3180      * Exchange Set tokens for underlying components
3181      *
3182      * @param _burnAddress       Address to burn tokens from
3183      * @param _incrementAddress  Address to increment component tokens to
3184      * @param _set               Address of the Set to redeem
3185      * @param _quantity          Number of tokens to redeem
3186      */
3187     function redeemInternal(
3188         address _burnAddress,
3189         address _incrementAddress,
3190         address _set,
3191         uint256 _quantity
3192     )
3193         internal;
3194 }
3195 
3196 // File: contracts/core/extensions/CoreModuleInteraction.sol
3197 
3198 /*
3199     Copyright 2018 Set Labs Inc.
3200 
3201     Licensed under the Apache License, Version 2.0 (the "License");
3202     you may not use this file except in compliance with the License.
3203     You may obtain a copy of the License at
3204 
3205     http://www.apache.org/licenses/LICENSE-2.0
3206 
3207     Unless required by applicable law or agreed to in writing, software
3208     distributed under the License is distributed on an "AS IS" BASIS,
3209     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3210     See the License for the specific language governing permissions and
3211     limitations under the License.
3212 */
3213 
3214 pragma solidity 0.5.7;
3215 
3216 
3217 
3218 
3219 
3220 
3221 /**
3222  * @title CoreModularInteraction
3223  * @author Set Protocol
3224  *
3225  * Extension used to expose internal accounting and issuance functions, vault, and proxy functions
3226  * to modules.
3227  */
3228 contract CoreModuleInteraction is
3229     ICoreAccounting,
3230     ICoreIssuance,
3231     CoreState,
3232     ReentrancyGuard
3233 {
3234     modifier onlyModule() {
3235         onlyModuleCallable();
3236         _;
3237     }
3238 
3239     function onlyModuleCallable() internal view {
3240         require(
3241             state.validModules[msg.sender],
3242             "OnlyModule"
3243         );
3244     }
3245 
3246     /**
3247      * Exposes internal function that deposits tokens to the vault, exposed to system
3248      * modules. Quantities should be in the order of the addresses of the tokens being
3249      * deposited.
3250      *
3251      * @param  _from              Address to transfer tokens from
3252      * @param  _to                Address to credit for deposits
3253      * @param  _token             Address of the token being deposited
3254      * @param  _quantity          Amount of tokens to deposit
3255      */
3256     function depositModule(
3257         address _from,
3258         address _to,
3259         address _token,
3260         uint256 _quantity
3261     )
3262         external
3263         onlyModule
3264     {
3265         address[] memory tokenArray = new address[](1);
3266         tokenArray[0] = _token;
3267 
3268         uint256[] memory quantityArray = new uint256[](1);
3269         quantityArray[0] = _quantity;
3270 
3271         batchDepositInternal(
3272             _from,
3273             _to,
3274             tokenArray,
3275             quantityArray
3276         );
3277     }
3278 
3279     /**
3280      * Exposes internal function that deposits multiple tokens to the vault, exposed to system
3281      * modules. Quantities should be in the order of the addresses of the tokens being
3282      * deposited.
3283      *
3284      * @param  _from              Address to transfer tokens from
3285      * @param  _to                Address to credit for deposits
3286      * @param  _tokens            Array of the addresses of the tokens being deposited
3287      * @param  _quantities        Array of the amounts of tokens to deposit
3288      */
3289     function batchDepositModule(
3290         address _from,
3291         address _to,
3292         address[] calldata _tokens,
3293         uint256[] calldata _quantities
3294     )
3295         external
3296         onlyModule
3297     {
3298         batchDepositInternal(
3299             _from,
3300             _to,
3301             _tokens,
3302             _quantities
3303         );
3304     }
3305 
3306     /**
3307      * Exposes internal function that withdraws multiple tokens to the vault, exposed to system
3308      * modules. Quantities should be in the order of the addresses of the tokens being
3309      * withdrawn.
3310      *
3311      * @param  _from              Address to decredit for withdrawals
3312      * @param  _to                Address to transfer tokens to
3313      * @param  _token             Address of the token being withdrawn
3314      * @param  _quantity          Amount of tokens to withdraw
3315      */
3316     function withdrawModule(
3317         address _from,
3318         address _to,
3319         address _token,
3320         uint256 _quantity
3321     )
3322         external
3323         onlyModule
3324     {
3325         address[] memory tokenArray = new address[](1);
3326         tokenArray[0] = _token;
3327 
3328         uint256[] memory quantityArray = new uint256[](1);
3329         quantityArray[0] = _quantity;
3330 
3331         batchWithdrawInternal(
3332             _from,
3333             _to,
3334             tokenArray,
3335             quantityArray
3336         );
3337     }
3338 
3339     /**
3340      * Exposes internal function that withdraws multiple tokens from the vault, to system
3341      * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
3342      *
3343      * @param  _from              Address to decredit for withdrawals
3344      * @param  _to                Address to transfer tokens to
3345      * @param  _tokens            Array of the addresses of the tokens being withdrawn
3346      * @param  _quantities        Array of the amounts of tokens to withdraw
3347      */
3348     function batchWithdrawModule(
3349         address _from,
3350         address _to,
3351         address[] calldata _tokens,
3352         uint256[] calldata _quantities
3353     )
3354         external
3355         onlyModule
3356     {
3357         batchWithdrawInternal(
3358             _from,
3359             _to,
3360             _tokens,
3361             _quantities
3362         );
3363     }
3364 
3365     /**
3366      * Expose internal function that exchanges components for Set tokens,
3367      * accepting any owner, to system modules
3368      *
3369      * @param  _componentOwner  Address to use tokens from
3370      * @param  _setRecipient    Address to issue Set to
3371      * @param  _set          Address of the Set to issue
3372      * @param  _quantity     Number of tokens to issue
3373      */
3374     function issueModule(
3375         address _componentOwner,
3376         address _setRecipient,
3377         address _set,
3378         uint256 _quantity
3379     )
3380         external
3381         onlyModule
3382     {
3383         issueInternal(
3384             _componentOwner,
3385             _setRecipient,
3386             _set,
3387             _quantity
3388         );
3389     }
3390 
3391     /**
3392      * Converts recipient's components into Set Token's held directly in Vault
3393      *
3394      * @param _recipient    Address to issue to
3395      * @param _set          Address of the Set
3396      * @param _quantity     Number of tokens to redeem
3397      */
3398     function issueInVaultModule(
3399         address _recipient,
3400         address _set,
3401         uint256 _quantity
3402     )
3403         external
3404         onlyModule
3405     {
3406         issueInVaultInternal(
3407             _recipient,
3408             _set,
3409             _quantity
3410         );
3411     }
3412 
3413     /**
3414      * Expose internal function that exchanges Set tokens for components,
3415      * accepting any owner, to system modules
3416      *
3417      * @param  _burnAddress         Address to burn token from
3418      * @param  _incrementAddress    Address to increment component tokens to
3419      * @param  _set                 Address of the Set to redeem
3420      * @param  _quantity            Number of tokens to redeem
3421      */
3422     function redeemModule(
3423         address _burnAddress,
3424         address _incrementAddress,
3425         address _set,
3426         uint256 _quantity
3427     )
3428         external
3429         onlyModule
3430     {
3431         redeemInternal(
3432             _burnAddress,
3433             _incrementAddress,
3434             _set,
3435             _quantity
3436         );
3437     }
3438 
3439     /**
3440      * Expose vault function that increments user's balance in the vault.
3441      * Available to system modules
3442      *
3443      * @param  _tokens          The addresses of the ERC20 tokens
3444      * @param  _owner           The address of the token owner
3445      * @param  _quantities      The numbers of tokens to attribute to owner
3446      */
3447     function batchIncrementTokenOwnerModule(
3448         address[] calldata _tokens,
3449         address _owner,
3450         uint256[] calldata _quantities
3451     )
3452         external
3453         onlyModule
3454     {
3455         state.vaultInstance.batchIncrementTokenOwner(
3456             _tokens,
3457             _owner,
3458             _quantities
3459         );
3460     }
3461 
3462     /**
3463      * Expose vault function that decrement user's balance in the vault
3464      * Only available to system modules.
3465      *
3466      * @param  _tokens          The addresses of the ERC20 tokens
3467      * @param  _owner           The address of the token owner
3468      * @param  _quantities      The numbers of tokens to attribute to owner
3469      */
3470     function batchDecrementTokenOwnerModule(
3471         address[] calldata _tokens,
3472         address _owner,
3473         uint256[] calldata _quantities
3474     )
3475         external
3476         onlyModule
3477     {
3478         state.vaultInstance.batchDecrementTokenOwner(
3479             _tokens,
3480             _owner,
3481             _quantities
3482         );
3483     }
3484 
3485     /**
3486      * Expose vault function that transfer vault balances between users
3487      * Only available to system modules.
3488      *
3489      * @param  _tokens           Addresses of tokens being transferred
3490      * @param  _from             Address tokens being transferred from
3491      * @param  _to               Address tokens being transferred to
3492      * @param  _quantities       Amounts of tokens being transferred
3493      */
3494     function batchTransferBalanceModule(
3495         address[] calldata _tokens,
3496         address _from,
3497         address _to,
3498         uint256[] calldata _quantities
3499     )
3500         external
3501         onlyModule
3502     {
3503         state.vaultInstance.batchTransferBalance(
3504             _tokens,
3505             _from,
3506             _to,
3507             _quantities
3508         );
3509     }
3510 
3511     /**
3512      * Transfers token from one address to another using the transfer proxy.
3513      * Only available to system modules.
3514      *
3515      * @param  _token          The address of the ERC20 token
3516      * @param  _quantity       The number of tokens to transfer
3517      * @param  _from           The address to transfer from
3518      * @param  _to             The address to transfer to
3519      */
3520     function transferModule(
3521         address _token,
3522         uint256 _quantity,
3523         address _from,
3524         address _to
3525     )
3526         external
3527         onlyModule
3528     {
3529         state.transferProxyInstance.transfer(
3530             _token,
3531             _quantity,
3532             _from,
3533             _to
3534         );
3535     }
3536 
3537     /**
3538      * Expose transfer proxy function to transfer tokens from one address to another
3539      * Only available to system modules.
3540      *
3541      * @param  _tokens         The addresses of the ERC20 token
3542      * @param  _quantities     The numbers of tokens to transfer
3543      * @param  _from           The address to transfer from
3544      * @param  _to             The address to transfer to
3545      */
3546     function batchTransferModule(
3547         address[] calldata _tokens,
3548         uint256[] calldata _quantities,
3549         address _from,
3550         address _to
3551     )
3552         external
3553         onlyModule
3554     {
3555         state.transferProxyInstance.batchTransfer(
3556             _tokens,
3557             _quantities,
3558             _from,
3559             _to
3560         );
3561     }
3562 }
3563 
3564 // File: contracts/core/Core.sol
3565 
3566 /*
3567     Copyright 2018 Set Labs Inc.
3568 
3569     Licensed under the Apache License, Version 2.0 (the "License");
3570     you may not use this file except in compliance with the License.
3571     You may obtain a copy of the License at
3572 
3573     http://www.apache.org/licenses/LICENSE-2.0
3574 
3575     Unless required by applicable law or agreed to in writing, software
3576     distributed under the License is distributed on an "AS IS" BASIS,
3577     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3578     See the License for the specific language governing permissions and
3579     limitations under the License.
3580 */
3581 
3582 pragma solidity 0.5.7;
3583 
3584 
3585 
3586 
3587 
3588 
3589 
3590 
3591 
3592 /**
3593  * @title Core
3594  * @author Set Protocol
3595  *
3596  * The Core contract acts as a coordinator handling issuing, redeeming, and
3597  * creating Sets, as well as all collateral flows throughout the system. Core
3598  * is also responsible for tracking state and exposing methods to modules
3599  */
3600  /* solium-disable-next-line no-empty-blocks */
3601 contract Core is
3602     CoreAccounting,
3603     CoreAdmin,
3604     CoreFactory,
3605     CoreIssuance,
3606     CoreModuleInteraction
3607 {
3608     /**
3609      * Constructor function for Core
3610      *
3611      * @param _transferProxy       The address of the transfer proxy
3612      * @param _vault               The address of the vault
3613      */
3614     constructor(
3615         address _transferProxy,
3616         address _vault
3617     )
3618         public
3619     {
3620         // Commit passed address to transferProxyAddress state variable
3621         state.transferProxy = _transferProxy;
3622 
3623         // Instantiate instance of transferProxy
3624         state.transferProxyInstance = ITransferProxy(_transferProxy);
3625 
3626         // Commit passed address to vault state variable
3627         state.vault = _vault;
3628 
3629         // Instantiate instance of vault
3630         state.vaultInstance = IVault(_vault);
3631     }
3632 }
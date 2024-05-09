1 pragma solidity 0.5.6;
2 
3 /**
4  * @dev Standard interface for a dex proxy contract.
5  */
6 interface Proxy {
7 
8   /**
9    * @dev Executes an action.
10    * @param _target Target of execution.
11    * @param _a Address usually representing from.
12    * @param _b Address usually representing to.
13    * @param _c Integer usually repersenting amount/value/id.
14    */
15   function execute(
16     address _target,
17     address _a,
18     address _b,
19     uint256 _c
20   )
21     external;
22     
23 }
24 
25 /**
26  * @dev Xcert interface.
27  */
28 interface Xcert // is ERC721 metadata enumerable
29 {
30 
31   /**
32    * @dev Creates a new Xcert.
33    * @param _to The address that will own the created Xcert.
34    * @param _id The Xcert to be created by the msg.sender.
35    * @param _imprint Cryptographic asset imprint.
36    */
37   function create(
38     address _to,
39     uint256 _id,
40     bytes32 _imprint
41   )
42     external;
43 
44   /**
45    * @dev Change URI base.
46    * @param _uriBase New uriBase.
47    */
48   function setUriBase(
49     string calldata _uriBase
50   )
51     external;
52 
53   /**
54    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.
55    * @return Schema id.
56    */
57   function schemaId()
58     external
59     view
60     returns (bytes32 _schemaId);
61 
62   /**
63    * @dev Returns imprint for Xcert.
64    * @param _tokenId Id of the Xcert.
65    * @return Token imprint.
66    */
67   function tokenImprint(
68     uint256 _tokenId
69   )
70     external
71     view
72     returns(bytes32 imprint);
73 
74 }
75 
76 /**
77  * @dev Math operations with safety checks that throw on error. This contract is based on the 
78  * source code at: 
79  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
80  */
81 library SafeMath
82 {
83 
84   /**
85    * @dev Error constants.
86    */
87   string constant OVERFLOW = "008001";
88   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
89   string constant DIVISION_BY_ZERO = "008003";
90 
91   /**
92    * @dev Multiplies two numbers, reverts on overflow.
93    * @param _factor1 Factor number.
94    * @param _factor2 Factor number.
95    * @return The product of the two factors.
96    */
97   function mul(
98     uint256 _factor1,
99     uint256 _factor2
100   )
101     internal
102     pure
103     returns (uint256 product)
104   {
105     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106     // benefit is lost if 'b' is also tested.
107     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108     if (_factor1 == 0)
109     {
110       return 0;
111     }
112 
113     product = _factor1 * _factor2;
114     require(product / _factor1 == _factor2, OVERFLOW);
115   }
116 
117   /**
118    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
119    * @param _dividend Dividend number.
120    * @param _divisor Divisor number.
121    * @return The quotient.
122    */
123   function div(
124     uint256 _dividend,
125     uint256 _divisor
126   )
127     internal
128     pure
129     returns (uint256 quotient)
130   {
131     // Solidity automatically asserts when dividing by 0, using all gas.
132     require(_divisor > 0, DIVISION_BY_ZERO);
133     quotient = _dividend / _divisor;
134     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
135   }
136 
137   /**
138    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139    * @param _minuend Minuend number.
140    * @param _subtrahend Subtrahend number.
141    * @return Difference.
142    */
143   function sub(
144     uint256 _minuend,
145     uint256 _subtrahend
146   )
147     internal
148     pure
149     returns (uint256 difference)
150   {
151     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
152     difference = _minuend - _subtrahend;
153   }
154 
155   /**
156    * @dev Adds two numbers, reverts on overflow.
157    * @param _addend1 Number.
158    * @param _addend2 Number.
159    * @return Sum.
160    */
161   function add(
162     uint256 _addend1,
163     uint256 _addend2
164   )
165     internal
166     pure
167     returns (uint256 sum)
168   {
169     sum = _addend1 + _addend2;
170     require(sum >= _addend1, OVERFLOW);
171   }
172 
173   /**
174     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
175     * dividing by zero.
176     * @param _dividend Number.
177     * @param _divisor Number.
178     * @return Remainder.
179     */
180   function mod(
181     uint256 _dividend,
182     uint256 _divisor
183   )
184     internal
185     pure
186     returns (uint256 remainder) 
187   {
188     require(_divisor != 0, DIVISION_BY_ZERO);
189     remainder = _dividend % _divisor;
190   }
191 
192 }
193 
194 /**
195  * @title Contract for setting abilities.
196  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
197  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
198  * this works. 
199  * 00000001 Ability A - number representation 1
200  * 00000010 Ability B - number representation 2
201  * 00000100 Ability C - number representation 4
202  * 00001000 Ability D - number representation 8
203  * 00010000 Ability E - number representation 16
204  * etc ... 
205  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
206  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
207  * and checking if someone has multiple abilities.
208  */
209 contract Abilitable
210 {
211   using SafeMath for uint;
212 
213   /**
214    * @dev Error constants.
215    */
216   string constant NOT_AUTHORIZED = "017001";
217   string constant CANNOT_REVOKE_OWN_SUPER_ABILITY = "017002";
218   string constant INVALID_INPUT = "017003";
219 
220   /**
221    * @dev Ability 1 (00000001) is a reserved ability called super ability. It is an
222    * ability to grant or revoke abilities of other accounts. Other abilities are determined by the
223    * implementing contract.
224    */
225   uint8 constant SUPER_ABILITY = 1;
226 
227   /**
228    * @dev Maps address to ability ids.
229    */
230   mapping(address => uint256) public addressToAbility;
231 
232   /**
233    * @dev Emits when an address is granted an ability.
234    * @param _target Address to which we are granting abilities.
235    * @param _abilities Number representing bitfield of abilities we are granting.
236    */
237   event GrantAbilities(
238     address indexed _target,
239     uint256 indexed _abilities
240   );
241 
242   /**
243    * @dev Emits when an address gets an ability revoked.
244    * @param _target Address of which we are revoking an ability.
245    * @param _abilities Number representing bitfield of abilities we are revoking.
246    */
247   event RevokeAbilities(
248     address indexed _target,
249     uint256 indexed _abilities
250   );
251 
252   /**
253    * @dev Guarantees that msg.sender has certain abilities.
254    */
255   modifier hasAbilities(
256     uint256 _abilities
257   ) 
258   {
259     require(_abilities > 0, INVALID_INPUT);
260     require(
261       addressToAbility[msg.sender] & _abilities == _abilities,
262       NOT_AUTHORIZED
263     );
264     _;
265   }
266 
267   /**
268    * @dev Contract constructor.
269    * Sets SUPER_ABILITY ability to the sender account.
270    */
271   constructor()
272     public
273   {
274     addressToAbility[msg.sender] = SUPER_ABILITY;
275     emit GrantAbilities(msg.sender, SUPER_ABILITY);
276   }
277 
278   /**
279    * @dev Grants specific abilities to specified address.
280    * @param _target Address to grant abilities to.
281    * @param _abilities Number representing bitfield of abilities we are granting.
282    */
283   function grantAbilities(
284     address _target,
285     uint256 _abilities
286   )
287     external
288     hasAbilities(SUPER_ABILITY)
289   {
290     addressToAbility[_target] |= _abilities;
291     emit GrantAbilities(_target, _abilities);
292   }
293 
294   /**
295    * @dev Unassigns specific abilities from specified address.
296    * @param _target Address of which we revoke abilites.
297    * @param _abilities Number representing bitfield of abilities we are revoking.
298    * @param _allowSuperRevoke Additional check that prevents you from removing your own super
299    * ability by mistake.
300    */
301   function revokeAbilities(
302     address _target,
303     uint256 _abilities,
304     bool _allowSuperRevoke
305   )
306     external
307     hasAbilities(SUPER_ABILITY)
308   {
309     if (!_allowSuperRevoke && msg.sender == _target)
310     {
311       require((_abilities & 1) == 0, CANNOT_REVOKE_OWN_SUPER_ABILITY);
312     }
313     addressToAbility[_target] &= ~_abilities;
314     emit RevokeAbilities(_target, _abilities);
315   }
316 
317   /**
318    * @dev Check if an address has a specific ability. Throws if checking for 0.
319    * @param _target Address for which we want to check if it has a specific abilities.
320    * @param _abilities Number representing bitfield of abilities we are checking.
321    */
322   function isAble(
323     address _target,
324     uint256 _abilities
325   )
326     external
327     view
328     returns (bool)
329   {
330     require(_abilities > 0, INVALID_INPUT);
331     return (addressToAbility[_target] & _abilities) == _abilities;
332   }
333   
334 }
335 
336 /**
337  * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via
338  * decentralized governance.
339  */
340 contract XcertCreateProxy is 
341   Abilitable 
342 {
343 
344   /**
345    * @dev List of abilities:
346    * 2 - Ability to execute create. 
347    */
348   uint8 constant ABILITY_TO_EXECUTE = 2;
349 
350   /**
351    * @dev Creates a new Xcert.
352    * @param _xcert Address of the Xcert contract on which the creation will be perfomed.
353    * @param _to The address that will own the created Xcert.
354    * @param _id The Xcert to be created by the msg.sender.
355    * @param _imprint Cryptographic asset imprint.
356    */
357   function create(
358     address _xcert,
359     address _to,
360     uint256 _id,
361     bytes32 _imprint
362   )
363     external
364     hasAbilities(ABILITY_TO_EXECUTE)
365   {
366     Xcert(_xcert).create(_to, _id, _imprint);
367   }
368 
369 }
370 
371 /**
372  * @dev Xcert nutable interface.
373  */
374 interface XcertMutable // is Xcert
375 {
376   
377   /**
378    * @dev Updates Xcert imprint.
379    * @param _tokenId Id of the Xcert.
380    * @param _imprint New imprint.
381    */
382   function updateTokenImprint(
383     uint256 _tokenId,
384     bytes32 _imprint
385   )
386     external;
387 
388 }
389 
390 /**
391  * @title XcertUpdateProxy - updates a token on behalf of contracts that have been approved via
392  * decentralized governance.
393  * @notice There is a possibility of unintentional behavior when token imprint can be overwritten
394  * if more than one claim is active. Be aware of this when implementing.
395  */
396 contract XcertUpdateProxy is
397   Abilitable
398 {
399 
400   /**
401    * @dev List of abilities:
402    * 2 - Ability to execute create.
403    */
404   uint8 constant ABILITY_TO_EXECUTE = 2;
405 
406   /**
407    * @dev Updates imprint of an existing Xcert.
408    * @param _xcert Address of the Xcert contract on which the update will be perfomed.
409    * @param _id The Xcert we will update.
410    * @param _imprint Cryptographic asset imprint.
411    */
412   function update(
413     address _xcert,
414     uint256 _id,
415     bytes32 _imprint
416   )
417     external
418     hasAbilities(ABILITY_TO_EXECUTE)
419   {
420     XcertMutable(_xcert).updateTokenImprint(_id, _imprint);
421   }
422 
423 }
424 
425 pragma experimental ABIEncoderV2;
426 
427 
428 
429 
430 
431 /**
432  * @dev Decentralize exchange, creating, updating and other actions for fundgible and non-fundgible
433  * tokens powered by atomic swaps.
434  */
435 contract OrderGateway is
436   Abilitable
437 {
438 
439   /**
440    * @dev List of abilities:
441    * 2 - Ability to set proxies.
442    */
443   uint8 constant ABILITY_TO_SET_PROXIES = 2;
444 
445   /**
446    * @dev Xcert abilities.
447    */
448   uint8 constant ABILITY_ALLOW_CREATE_ASSET = 32;
449   uint16 constant ABILITY_ALLOW_UPDATE_ASSET = 128;
450 
451   /**
452    * @dev Error constants.
453    */
454   string constant INVALID_SIGNATURE_KIND = "015001";
455   string constant INVALID_PROXY = "015002";
456   string constant TAKER_NOT_EQUAL_TO_SENDER = "015003";
457   string constant SENDER_NOT_TAKER_OR_MAKER = "015004";
458   string constant CLAIM_EXPIRED = "015005";
459   string constant INVALID_SIGNATURE = "015006";
460   string constant ORDER_CANCELED = "015007";
461   string constant ORDER_ALREADY_PERFORMED = "015008";
462   string constant MAKER_NOT_EQUAL_TO_SENDER = "015009";
463   string constant SIGNER_NOT_AUTHORIZED = "015010";
464 
465   /**
466    * @dev Enum of available signature kinds.
467    * @param eth_sign Signature using eth sign.
468    * @param trezor Signature from Trezor hardware wallet.
469    * It differs from web3.eth_sign in the encoding of message length
470    * (Bitcoin varint encoding vs ascii-decimal, the latter is not
471    * self-terminating which leads to ambiguities).
472    * See also:
473    * https://en.bitcoin.it/wiki/Protocol_documentation#Variable_length_integer
474    * https://github.com/trezor/trezor-mcu/blob/master/firmware/ethereum.c#L602
475    * https://github.com/trezor/trezor-mcu/blob/master/firmware/crypto.c#L36a
476    * @param eip721 Signature using eip721.
477    */
478   enum SignatureKind
479   {
480     eth_sign,
481     trezor,
482     eip712
483   }
484 
485   /**
486    * Enum of available action kinds.
487    */
488   enum ActionKind
489   {
490     create,
491     transfer,
492     update
493   }
494 
495   /**
496    * @dev Structure representing what to send and where.
497    * @notice For update action kind to parameter is unnecessary. For this reason we recommend you
498    * set it to zero address (0x000...0) since it costs less.
499    * @param kind Enum representing action kind.
500    * @param proxy Id representing approved proxy address.
501    * @param token Address of the token we are sending.
502    * @param param1 Address of the sender or imprint.
503    * @param to Address of the receiver.
504    * @param value Amount of ERC20 or ID of ERC721.
505    */
506   struct ActionData
507   {
508     ActionKind kind;
509     uint32 proxy;
510     address token;
511     bytes32 param1;
512     address to;
513     uint256 value;
514   }
515 
516   /**
517    * @dev Structure representing the signature parts.
518    * @param r ECDSA signature parameter r.
519    * @param s ECDSA signature parameter s.
520    * @param v ECDSA signature parameter v.
521    * @param kind Type of signature.
522    */
523   struct SignatureData
524   {
525     bytes32 r;
526     bytes32 s;
527     uint8 v;
528     SignatureKind kind;
529   }
530 
531   /**
532    * @dev Structure representing the data needed to do the order.
533    * @param maker Address of the one that made the claim.
534    * @param taker Address of the one that is executing the claim.
535    * @param actions Data of all the actions that should accure it this order.
536    * @param signature Data from the signed claim.
537    * @param seed Arbitrary number to facilitate uniqueness of the order's hash. Usually timestamp.
538    * @param expiration Timestamp of when the claim expires. 0 if indefinet.
539    */
540   struct OrderData
541   {
542     address maker;
543     address taker;
544     ActionData[] actions;
545     uint256 seed;
546     uint256 expiration;
547   }
548 
549   /**
550    * @dev Valid proxy contract addresses.
551    */
552   address[] public proxies;
553 
554   /**
555    * @dev Mapping of all cancelled orders.
556    */
557   mapping(bytes32 => bool) public orderCancelled;
558 
559   /**
560    * @dev Mapping of all performed orders.
561    */
562   mapping(bytes32 => bool) public orderPerformed;
563 
564   /**
565    * @dev This event emmits when tokens change ownership.
566    */
567   event Perform(
568     address indexed _maker,
569     address indexed _taker,
570     bytes32 _claim
571   );
572 
573   /**
574    * @dev This event emmits when transfer order is cancelled.
575    */
576   event Cancel(
577     address indexed _maker,
578     address indexed _taker,
579     bytes32 _claim
580   );
581 
582   /**
583    * @dev This event emmits when proxy address is changed..
584    */
585   event ProxyChange(
586     uint256 indexed _index,
587     address _proxy
588   );
589 
590   /**
591    * @dev Adds a verified proxy address.
592    * @notice Can be done through a multisig wallet in the future.
593    * @param _proxy Proxy address.
594    */
595   function addProxy(
596     address _proxy
597   )
598     external
599     hasAbilities(ABILITY_TO_SET_PROXIES)
600   {
601     uint256 length = proxies.push(_proxy);
602     emit ProxyChange(length - 1, _proxy);
603   }
604 
605   /**
606    * @dev Removes a proxy address.
607    * @notice Can be done through a multisig wallet in the future.
608    * @param _index Index of proxy we are removing.
609    */
610   function removeProxy(
611     uint256 _index
612   )
613     external
614     hasAbilities(ABILITY_TO_SET_PROXIES)
615   {
616     proxies[_index] = address(0);
617     emit ProxyChange(_index, address(0));
618   }
619 
620   /**
621    * @dev Performs the atomic swap that can exchange, create, update and do other actions for
622    * fungible and non-fungible tokens.
623    * @param _data Data required to make the order.
624    * @param _signature Data from the signature.
625    */
626   function perform(
627     OrderData memory _data,
628     SignatureData memory _signature
629   )
630     public
631   {
632     require(_data.taker == msg.sender, TAKER_NOT_EQUAL_TO_SENDER);
633     require(_data.expiration >= now, CLAIM_EXPIRED);
634 
635     bytes32 claim = getOrderDataClaim(_data);
636     require(
637       isValidSignature(
638         _data.maker,
639         claim,
640         _signature
641       ),
642       INVALID_SIGNATURE
643     );
644 
645     require(!orderCancelled[claim], ORDER_CANCELED);
646     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
647 
648     orderPerformed[claim] = true;
649 
650     _doActions(_data);
651 
652     emit Perform(
653       _data.maker,
654       _data.taker,
655       claim
656     );
657   }
658 
659   /**
660    * @dev Performs the atomic swap that can exchange, create, update and do other actions for
661    * fungible and non-fungible tokens where performing address does not need to be known before
662    * hand.
663    * @notice When using this function, be aware that the zero address is reserved for replacement
664    * with msg.sender, meaning you cannot send anything to the zero address.
665    * @param _data Data required to make the order.
666    * @param _signature Data from the signature.
667    */
668   function performAnyTaker(
669     OrderData memory _data,
670     SignatureData memory _signature
671   )
672     public
673   {
674     require(_data.expiration >= now, CLAIM_EXPIRED);
675 
676     bytes32 claim = getOrderDataClaim(_data);
677     require(
678       isValidSignature(
679         _data.maker,
680         claim,
681         _signature
682       ),
683       INVALID_SIGNATURE
684     );
685 
686     require(!orderCancelled[claim], ORDER_CANCELED);
687     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
688 
689     orderPerformed[claim] = true;
690 
691     _data.taker = msg.sender;
692     _doActionsReplaceZeroAddress(_data);
693 
694     emit Perform(
695       _data.maker,
696       _data.taker,
697       claim
698     );
699   }
700 
701   /**
702    * @dev Cancels order.
703    * @notice You can cancel the same order multiple times. There is no check for whether the order
704    * was already canceled due to gas optimization. You should either check orderCancelled variable
705    * or listen to Cancel event if you want to check if an order is already canceled.
706    * @param _data Data of order to cancel.
707    */
708   function cancel(
709     OrderData memory _data
710   )
711     public
712   {
713     require(_data.maker == msg.sender, MAKER_NOT_EQUAL_TO_SENDER);
714 
715     bytes32 claim = getOrderDataClaim(_data);
716     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
717 
718     orderCancelled[claim] = true;
719     emit Cancel(
720       _data.maker,
721       _data.taker,
722       claim
723     );
724   }
725 
726   /**
727    * @dev Calculates keccak-256 hash of OrderData from parameters.
728    * @param _orderData Data needed for atomic swap.
729    * @return keccak-hash of order data.
730    */
731   function getOrderDataClaim(
732     OrderData memory _orderData
733   )
734     public
735     view
736     returns (bytes32)
737   {
738     bytes32 temp = 0x0;
739 
740     for(uint256 i = 0; i < _orderData.actions.length; i++)
741     {
742       temp = keccak256(
743         abi.encodePacked(
744           temp,
745           _orderData.actions[i].kind,
746           _orderData.actions[i].proxy,
747           _orderData.actions[i].token,
748           _orderData.actions[i].param1,
749           _orderData.actions[i].to,
750           _orderData.actions[i].value
751         )
752       );
753     }
754 
755     return keccak256(
756       abi.encodePacked(
757         address(this),
758         _orderData.maker,
759         _orderData.taker,
760         temp,
761         _orderData.seed,
762         _orderData.expiration
763       )
764     );
765   }
766 
767   /**
768    * @dev Verifies if claim signature is valid.
769    * @param _signer address of signer.
770    * @param _claim Signed Keccak-256 hash.
771    * @param _signature Signature data.
772    */
773   function isValidSignature(
774     address _signer,
775     bytes32 _claim,
776     SignatureData memory _signature
777   )
778     public
779     pure
780     returns (bool)
781   {
782     if (_signature.kind == SignatureKind.eth_sign)
783     {
784       return _signer == ecrecover(
785         keccak256(
786           abi.encodePacked(
787             "\x19Ethereum Signed Message:\n32",
788             _claim
789           )
790         ),
791         _signature.v,
792         _signature.r,
793         _signature.s
794       );
795     } else if (_signature.kind == SignatureKind.trezor)
796     {
797       return _signer == ecrecover(
798         keccak256(
799           abi.encodePacked(
800             "\x19Ethereum Signed Message:\n\x20",
801             _claim
802           )
803         ),
804         _signature.v,
805         _signature.r,
806         _signature.s
807       );
808     } else if (_signature.kind == SignatureKind.eip712)
809     {
810       return _signer == ecrecover(
811         _claim,
812         _signature.v,
813         _signature.r,
814         _signature.s
815       );
816     }
817 
818     revert(INVALID_SIGNATURE_KIND);
819   }
820 
821   /**
822    * @dev Helper function that makes order actions and replaces zero addresses with msg.sender.
823    * @param _order Data needed for order.
824    */
825   function _doActionsReplaceZeroAddress(
826     OrderData memory _order
827   )
828     private
829   {
830     for(uint256 i = 0; i < _order.actions.length; i++)
831     {
832       require(
833         proxies[_order.actions[i].proxy] != address(0),
834         INVALID_PROXY
835       );
836 
837       if (_order.actions[i].kind == ActionKind.create)
838       {
839         require(
840           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_CREATE_ASSET),
841           SIGNER_NOT_AUTHORIZED
842         );
843 
844         if (_order.actions[i].to == address(0))
845         {
846           _order.actions[i].to = _order.taker;
847         }
848 
849         XcertCreateProxy(proxies[_order.actions[i].proxy]).create(
850           _order.actions[i].token,
851           _order.actions[i].to,
852           _order.actions[i].value,
853           _order.actions[i].param1
854         );
855       }
856       else if (_order.actions[i].kind == ActionKind.transfer)
857       {
858         address from = address(uint160(bytes20(_order.actions[i].param1)));
859 
860         if (_order.actions[i].to == address(0))
861         {
862           _order.actions[i].to = _order.taker;
863         }
864 
865         if (from == address(0))
866         {
867           from = _order.taker;
868         }
869 
870         require(
871           from == _order.maker
872           || from == _order.taker,
873           SENDER_NOT_TAKER_OR_MAKER
874         );
875 
876         Proxy(proxies[_order.actions[i].proxy]).execute(
877           _order.actions[i].token,
878           from,
879           _order.actions[i].to,
880           _order.actions[i].value
881         );
882       }
883       else if (_order.actions[i].kind == ActionKind.update)
884       {
885         require(
886           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_UPDATE_ASSET),
887           SIGNER_NOT_AUTHORIZED
888         );
889 
890         XcertUpdateProxy(proxies[_order.actions[i].proxy]).update(
891           _order.actions[i].token,
892           _order.actions[i].value,
893           _order.actions[i].param1
894         );
895       }
896     }
897   }
898 
899   /**
900    * @dev Helper function that makes order actions.
901    * @param _order Data needed for order.
902    */
903   function _doActions(
904     OrderData memory _order
905   )
906     private
907   {
908     for(uint256 i = 0; i < _order.actions.length; i++)
909     {
910       require(
911         proxies[_order.actions[i].proxy] != address(0),
912         INVALID_PROXY
913       );
914 
915       if (_order.actions[i].kind == ActionKind.create)
916       {
917         require(
918           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_CREATE_ASSET),
919           SIGNER_NOT_AUTHORIZED
920         );
921 
922         XcertCreateProxy(proxies[_order.actions[i].proxy]).create(
923           _order.actions[i].token,
924           _order.actions[i].to,
925           _order.actions[i].value,
926           _order.actions[i].param1
927         );
928       }
929       else if (_order.actions[i].kind == ActionKind.transfer)
930       {
931         address from = address(uint160(bytes20(_order.actions[i].param1)));
932         require(
933           from == _order.maker
934           || from == _order.taker,
935           SENDER_NOT_TAKER_OR_MAKER
936         );
937 
938         Proxy(proxies[_order.actions[i].proxy]).execute(
939           _order.actions[i].token,
940           from,
941           _order.actions[i].to,
942           _order.actions[i].value
943         );
944       }
945       else if (_order.actions[i].kind == ActionKind.update)
946       {
947         require(
948           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_UPDATE_ASSET),
949           SIGNER_NOT_AUTHORIZED
950         );
951 
952         XcertUpdateProxy(proxies[_order.actions[i].proxy]).update(
953           _order.actions[i].token,
954           _order.actions[i].value,
955           _order.actions[i].param1
956         );
957       }
958     }
959   }
960 
961 }
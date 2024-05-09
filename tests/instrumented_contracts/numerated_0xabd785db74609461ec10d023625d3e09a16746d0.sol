1 pragma solidity 0.5.1;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Standard interface for a dex proxy contract.
6  */
7 interface Proxy {
8 
9   /**
10    * @dev Executes an action.
11    * @param _target Target of execution.
12    * @param _a Address usually represention from.
13    * @param _b Address usually representing to.
14    * @param _c Integer usually repersenting amount/value/id.
15    */
16   function execute(
17     address _target,
18     address _a,
19     address _b,
20     uint256 _c
21   )
22     external;
23     
24 }
25 
26 /**
27  * @dev Xcert interface.
28  */
29 interface Xcert // is ERC721 metadata enumerable
30 {
31 
32   /**
33    * @dev Creates a new Xcert.
34    * @param _to The address that will own the created Xcert.
35    * @param _id The Xcert to be created by the msg.sender.
36    * @param _imprint Cryptographic asset imprint.
37    */
38   function create(
39     address _to,
40     uint256 _id,
41     bytes32 _imprint
42   )
43     external;
44 
45   /**
46    * @dev Change URI base.
47    * @param _uriBase New uriBase.
48    */
49   function setUriBase(
50     string calldata _uriBase
51   )
52     external;
53 
54   /**
55    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.
56    * @return Schema id.
57    */
58   function schemaId()
59     external
60     view
61     returns (bytes32 _schemaId);
62 
63   /**
64    * @dev Returns imprint for Xcert.
65    * @param _tokenId Id of the Xcert.
66    * @return Token imprint.
67    */
68   function tokenImprint(
69     uint256 _tokenId
70   )
71     external
72     view
73     returns(bytes32 imprint);
74 
75 }
76 
77 
78 /**
79  * @dev Math operations with safety checks that throw on error. This contract is based on the 
80  * source code at: 
81  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
82  */
83 library SafeMath
84 {
85 
86   /**
87    * @dev Error constants.
88    */
89   string constant OVERFLOW = "008001";
90   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
91   string constant DIVISION_BY_ZERO = "008003";
92 
93   /**
94    * @dev Multiplies two numbers, reverts on overflow.
95    * @param _factor1 Factor number.
96    * @param _factor2 Factor number.
97    * @return The product of the two factors.
98    */
99   function mul(
100     uint256 _factor1,
101     uint256 _factor2
102   )
103     internal
104     pure
105     returns (uint256 product)
106   {
107     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108     // benefit is lost if 'b' is also tested.
109     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110     if (_factor1 == 0)
111     {
112       return 0;
113     }
114 
115     product = _factor1 * _factor2;
116     require(product / _factor1 == _factor2, OVERFLOW);
117   }
118 
119   /**
120    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
121    * @param _dividend Dividend number.
122    * @param _divisor Divisor number.
123    * @return The quotient.
124    */
125   function div(
126     uint256 _dividend,
127     uint256 _divisor
128   )
129     internal
130     pure
131     returns (uint256 quotient)
132   {
133     // Solidity automatically asserts when dividing by 0, using all gas.
134     require(_divisor > 0, DIVISION_BY_ZERO);
135     quotient = _dividend / _divisor;
136     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
137   }
138 
139   /**
140    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141    * @param _minuend Minuend number.
142    * @param _subtrahend Subtrahend number.
143    * @return Difference.
144    */
145   function sub(
146     uint256 _minuend,
147     uint256 _subtrahend
148   )
149     internal
150     pure
151     returns (uint256 difference)
152   {
153     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
154     difference = _minuend - _subtrahend;
155   }
156 
157   /**
158    * @dev Adds two numbers, reverts on overflow.
159    * @param _addend1 Number.
160    * @param _addend2 Number.
161    * @return Sum.
162    */
163   function add(
164     uint256 _addend1,
165     uint256 _addend2
166   )
167     internal
168     pure
169     returns (uint256 sum)
170   {
171     sum = _addend1 + _addend2;
172     require(sum >= _addend1, OVERFLOW);
173   }
174 
175   /**
176     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
177     * dividing by zero.
178     * @param _dividend Number.
179     * @param _divisor Number.
180     * @return Remainder.
181     */
182   function mod(
183     uint256 _dividend,
184     uint256 _divisor
185   )
186     internal
187     pure
188     returns (uint256 remainder) 
189   {
190     require(_divisor != 0, DIVISION_BY_ZERO);
191     remainder = _dividend % _divisor;
192   }
193 
194 }
195 
196 /**
197  * @title Contract for setting abilities.
198  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
199  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
200  * this works. 
201  * 00000001 Ability A - number representation 1
202  * 00000010 Ability B - number representation 2
203  * 00000100 Ability C - number representation 4
204  * 00001000 Ability D - number representation 8
205  * 00010000 Ability E - number representation 16
206  * etc ... 
207  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
208  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
209  * and checking if someone has multiple abilities.
210  */
211 contract Abilitable
212 {
213   using SafeMath for uint;
214 
215   /**
216    * @dev Error constants.
217    */
218   string constant NOT_AUTHORIZED = "017001";
219   string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";
220   string constant INVALID_INPUT = "017003";
221 
222   /**
223    * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. 
224    * There can be minimum of 1 address with ability 1.
225    * Other abilities are determined by implementing contract.
226    */
227   uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;
228 
229   /**
230    * @dev Maps address to ability ids.
231    */
232   mapping(address => uint256) public addressToAbility;
233 
234   /**
235    * @dev Count of zero ability addresses.
236    */
237   uint256 private zeroAbilityCount;
238 
239   /**
240    * @dev Emits when an address is granted an ability.
241    * @param _target Address to which we are granting abilities.
242    * @param _abilities Number representing bitfield of abilities we are granting.
243    */
244   event GrantAbilities(
245     address indexed _target,
246     uint256 indexed _abilities
247   );
248 
249   /**
250    * @dev Emits when an address gets an ability revoked.
251    * @param _target Address of which we are revoking an ability.
252    * @param _abilities Number representing bitfield of abilities we are revoking.
253    */
254   event RevokeAbilities(
255     address indexed _target,
256     uint256 indexed _abilities
257   );
258 
259   /**
260    * @dev Guarantees that msg.sender has certain abilities.
261    */
262   modifier hasAbilities(
263     uint256 _abilities
264   ) 
265   {
266     require(_abilities > 0, INVALID_INPUT);
267     require(
268       (addressToAbility[msg.sender] & _abilities) == _abilities,
269       NOT_AUTHORIZED
270     );
271     _;
272   }
273 
274   /**
275    * @dev Contract constructor.
276    * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.
277    */
278   constructor()
279     public
280   {
281     addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;
282     zeroAbilityCount = 1;
283     emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);
284   }
285 
286   /**
287    * @dev Grants specific abilities to specified address.
288    * @param _target Address to grant abilities to.
289    * @param _abilities Number representing bitfield of abilities we are granting.
290    */
291   function grantAbilities(
292     address _target,
293     uint256 _abilities
294   )
295     external
296     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
297   {
298     addressToAbility[_target] |= _abilities;
299 
300     if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)
301     {
302       zeroAbilityCount = zeroAbilityCount.add(1);
303     }
304     emit GrantAbilities(_target, _abilities);
305   }
306 
307   /**
308    * @dev Unassigns specific abilities from specified address.
309    * @param _target Address of which we revoke abilites.
310    * @param _abilities Number representing bitfield of abilities we are revoking.
311    */
312   function revokeAbilities(
313     address _target,
314     uint256 _abilities
315   )
316     external
317     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
318   {
319     addressToAbility[_target] &= ~_abilities;
320     if((_abilities & 1) == 1)
321     {
322       require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);
323       zeroAbilityCount--;
324     }
325     emit RevokeAbilities(_target, _abilities);
326   }
327 
328   /**
329    * @dev Check if an address has a specific ability. Throws if checking for 0.
330    * @param _target Address for which we want to check if it has a specific abilities.
331    * @param _abilities Number representing bitfield of abilities we are checking.
332    */
333   function isAble(
334     address _target,
335     uint256 _abilities
336   )
337     external
338     view
339     returns (bool)
340   {
341     require(_abilities > 0, INVALID_INPUT);
342     return (addressToAbility[_target] & _abilities) == _abilities;
343   }
344   
345 }
346 
347 /**
348  * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via
349  * decentralized governance.
350  */
351 contract XcertCreateProxy is 
352   Abilitable 
353 {
354 
355   /**
356    * @dev List of abilities:
357    * 2 - Ability to execute create. 
358    */
359   uint8 constant ABILITY_TO_EXECUTE = 2;
360 
361   /**
362    * @dev Creates a new NFT.
363    * @param _xcert Address of the Xcert contract on which the creation will be perfomed.
364    * @param _to The address that will own the created NFT.
365    * @param _id The NFT to be created by the msg.sender.
366    * @param _imprint Cryptographic asset imprint.
367    */
368   function create(
369     address _xcert,
370     address _to,
371     uint256 _id,
372     bytes32 _imprint
373   )
374     external
375     hasAbilities(ABILITY_TO_EXECUTE)
376   {
377     Xcert(_xcert).create(_to, _id, _imprint);
378   }
379   
380 }
381 
382 /**
383  * @dev Decentralize exchange, creating, updating and other actions for fundgible and non-fundgible 
384  * tokens powered by atomic swaps. 
385  */
386 contract OrderGateway is
387   Abilitable
388 {
389 
390   /**
391    * @dev List of abilities:
392    * 1 - Ability to set proxies.
393    */
394   uint8 constant ABILITY_TO_SET_PROXIES = 2;
395 
396   /**
397    * @dev Xcert abilities.
398    */
399   uint8 constant ABILITY_ALLOW_CREATE_ASSET = 32;
400 
401   /**
402    * @dev Error constants.
403    */
404   string constant INVALID_SIGNATURE_KIND = "015001";
405   string constant INVALID_PROXY = "015002";
406   string constant TAKER_NOT_EQUAL_TO_SENDER = "015003";
407   string constant SENDER_NOT_TAKER_OR_MAKER = "015004";
408   string constant CLAIM_EXPIRED = "015005";
409   string constant INVALID_SIGNATURE = "015006";
410   string constant ORDER_CANCELED = "015007";
411   string constant ORDER_ALREADY_PERFORMED = "015008";
412   string constant MAKER_NOT_EQUAL_TO_SENDER = "015009";
413   string constant SIGNER_NOT_AUTHORIZED = "015010";
414 
415   /**
416    * @dev Enum of available signature kinds.
417    * @param eth_sign Signature using eth sign.
418    * @param trezor Signature from Trezor hardware wallet.
419    * It differs from web3.eth_sign in the encoding of message length
420    * (Bitcoin varint encoding vs ascii-decimal, the latter is not
421    * self-terminating which leads to ambiguities).
422    * See also:
423    * https://en.bitcoin.it/wiki/Protocol_documentation#Variable_length_integer
424    * https://github.com/trezor/trezor-mcu/blob/master/firmware/ethereum.c#L602
425    * https://github.com/trezor/trezor-mcu/blob/master/firmware/crypto.c#L36 
426    * @param eip721 Signature using eip721.
427    */
428   enum SignatureKind
429   {
430     eth_sign,
431     trezor,
432     eip712
433   }
434 
435   /**
436    * Enum of available action kinds.
437    */
438   enum ActionKind
439   {
440     create,
441     transfer
442   }
443 
444   /**
445    * @dev Structure representing what to send and where.
446    * @param token Address of the token we are sending.
447    * @param proxy Id representing approved proxy address.
448    * @param param1 Address of the sender or imprint.
449    * @param to Address of the receiver.
450    * @param value Amount of ERC20 or ID of ERC721.
451    */
452   struct ActionData 
453   {
454     ActionKind kind;
455     uint32 proxy;
456     address token;
457     bytes32 param1;
458     address to;
459     uint256 value;
460   }
461 
462   /**
463    * @dev Structure representing the signature parts.
464    * @param r ECDSA signature parameter r.
465    * @param s ECDSA signature parameter s.
466    * @param v ECDSA signature parameter v.
467    * @param kind Type of signature. 
468    */
469   struct SignatureData
470   {
471     bytes32 r;
472     bytes32 s;
473     uint8 v;
474     SignatureKind kind;
475   }
476 
477   /**
478    * @dev Structure representing the data needed to do the order.
479    * @param maker Address of the one that made the claim.
480    * @param taker Address of the one that is executing the claim.
481    * @param actions Data of all the actions that should accure it this order.
482    * @param signature Data from the signed claim.
483    * @param seed Arbitrary number to facilitate uniqueness of the order's hash. Usually timestamp.
484    * @param expiration Timestamp of when the claim expires. 0 if indefinet. 
485    */
486   struct OrderData 
487   {
488     address maker;
489     address taker;
490     ActionData[] actions;
491     uint256 seed;
492     uint256 expiration;
493   }
494 
495   /** 
496    * @dev Valid proxy contract addresses.
497    */
498   mapping(uint32 => address) public idToProxy;
499 
500   /**
501    * @dev Mapping of all cancelled orders.
502    */
503   mapping(bytes32 => bool) public orderCancelled;
504 
505   /**
506    * @dev Mapping of all performed orders.
507    */
508   mapping(bytes32 => bool) public orderPerformed;
509 
510   /**
511    * @dev This event emmits when tokens change ownership.
512    */
513   event Perform(
514     address indexed _maker,
515     address indexed _taker,
516     bytes32 _claim
517   );
518 
519   /**
520    * @dev This event emmits when transfer order is cancelled.
521    */
522   event Cancel(
523     address indexed _maker,
524     address indexed _taker,
525     bytes32 _claim
526   );
527 
528   /**
529    * @dev This event emmits when proxy address is changed..
530    */
531   event ProxyChange(
532     uint32 indexed _id,
533     address _proxy
534   );
535 
536   /**
537    * @dev Sets a verified proxy address. 
538    * @notice Can be done through a multisig wallet in the future.
539    * @param _id Id of the proxy.
540    * @param _proxy Proxy address.
541    */
542   function setProxy(
543     uint32 _id,
544     address _proxy
545   )
546     external
547     hasAbilities(ABILITY_TO_SET_PROXIES)
548   {
549     idToProxy[_id] = _proxy;
550     emit ProxyChange(_id, _proxy);
551   }
552 
553   /**
554    * @dev Performs the ERC721/ERC20 atomic swap.
555    * @param _data Data required to make the order.
556    * @param _signature Data from the signature. 
557    */
558   function perform(
559     OrderData memory _data,
560     SignatureData memory _signature
561   )
562     public 
563   {
564     require(_data.taker == msg.sender, TAKER_NOT_EQUAL_TO_SENDER);
565     require(_data.expiration >= now, CLAIM_EXPIRED);
566 
567     bytes32 claim = getOrderDataClaim(_data);
568     require(
569       isValidSignature(
570         _data.maker,
571         claim,
572         _signature
573       ), 
574       INVALID_SIGNATURE
575     );
576 
577     require(!orderCancelled[claim], ORDER_CANCELED);
578     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
579 
580     orderPerformed[claim] = true;
581 
582     _doActions(_data);
583 
584     emit Perform(
585       _data.maker,
586       _data.taker,
587       claim
588     );
589   }
590 
591   /** 
592    * @dev Cancels order
593    * @param _data Data of order to cancel.
594    */
595   function cancel(
596     OrderData memory _data
597   )
598     public
599   {
600     require(_data.maker == msg.sender, MAKER_NOT_EQUAL_TO_SENDER);
601 
602     bytes32 claim = getOrderDataClaim(_data);
603     require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);
604 
605     orderCancelled[claim] = true;
606     emit Cancel(
607       _data.maker,
608       _data.taker,
609       claim
610     );
611   }
612 
613   /**
614    * @dev Calculates keccak-256 hash of OrderData from parameters.
615    * @param _orderData Data needed for atomic swap.
616    * @return keccak-hash of order data.
617    */
618   function getOrderDataClaim(
619     OrderData memory _orderData
620   )
621     public
622     view
623     returns (bytes32)
624   {
625     bytes32 temp = 0x0;
626 
627     for(uint256 i = 0; i < _orderData.actions.length; i++)
628     {
629       temp = keccak256(
630         abi.encodePacked(
631           temp,
632           _orderData.actions[i].kind,
633           _orderData.actions[i].proxy,
634           _orderData.actions[i].token,
635           _orderData.actions[i].param1,
636           _orderData.actions[i].to,
637           _orderData.actions[i].value
638         )
639       );
640     }
641 
642     return keccak256(
643       abi.encodePacked(
644         address(this),
645         _orderData.maker,
646         _orderData.taker,
647         temp,
648         _orderData.seed,
649         _orderData.expiration
650       )
651     );
652   }
653   
654   /**
655    * @dev Verifies if claim signature is valid.
656    * @param _signer address of signer.
657    * @param _claim Signed Keccak-256 hash.
658    * @param _signature Signature data.
659    */
660   function isValidSignature(
661     address _signer,
662     bytes32 _claim,
663     SignatureData memory _signature
664   )
665     public
666     pure
667     returns (bool)
668   {
669     if(_signature.kind == SignatureKind.eth_sign)
670     {
671       return _signer == ecrecover(
672         keccak256(
673           abi.encodePacked(
674             "\x19Ethereum Signed Message:\n32",
675             _claim
676           )
677         ),
678         _signature.v,
679         _signature.r,
680         _signature.s
681       );
682     } else if (_signature.kind == SignatureKind.trezor)
683     {
684       return _signer == ecrecover(
685         keccak256(
686           abi.encodePacked(
687             "\x19Ethereum Signed Message:\n\x20",
688             _claim
689           )
690         ),
691         _signature.v,
692         _signature.r,
693         _signature.s
694       );
695     } else if (_signature.kind == SignatureKind.eip712)
696     {
697       return _signer == ecrecover(
698         _claim,
699         _signature.v,
700         _signature.r,
701         _signature.s
702       );
703     }
704 
705     revert(INVALID_SIGNATURE_KIND);
706   }
707 
708   /**
709    * @dev Helper function that makes transfes.
710    * @param _order Data needed for order.
711    */
712   function _doActions(
713     OrderData memory _order
714   )
715     private
716   {
717     for(uint256 i = 0; i < _order.actions.length; i++)
718     {
719       require(
720         idToProxy[_order.actions[i].proxy] != address(0),
721         INVALID_PROXY
722       );
723 
724       if(_order.actions[i].kind == ActionKind.create)
725       {
726         require(
727           Abilitable(_order.actions[i].token).isAble(_order.maker, ABILITY_ALLOW_CREATE_ASSET),
728           SIGNER_NOT_AUTHORIZED
729         );
730         
731         XcertCreateProxy(idToProxy[_order.actions[i].proxy]).create(
732           _order.actions[i].token,
733           _order.actions[i].to,
734           _order.actions[i].value,
735           _order.actions[i].param1
736         );
737       } 
738       else if (_order.actions[i].kind == ActionKind.transfer)
739       {
740         address from = address(uint160(bytes20(_order.actions[i].param1)));
741         require(
742           from == _order.maker
743           || from == _order.taker,
744           SENDER_NOT_TAKER_OR_MAKER
745         );
746         
747         Proxy(idToProxy[_order.actions[i].proxy]).execute(
748           _order.actions[i].token,
749           from,
750           _order.actions[i].to,
751           _order.actions[i].value
752         );
753       }
754     }
755   }
756   
757 }
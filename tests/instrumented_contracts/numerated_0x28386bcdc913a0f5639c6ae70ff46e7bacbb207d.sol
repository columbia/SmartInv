1 pragma solidity 0.5.1;
2 
3 /**
4  * @dev Standard interface for a dex proxy contract.
5  */
6 interface Proxy {
7 
8   /**
9    * @dev Executes an action.
10    * @param _target Target of execution.
11    * @param _a Address usually represention from.
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
26  * @dev ERC-721 non-fungible token standard. 
27  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
28  */
29 interface ERC721
30 {
31 
32   /**
33    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
34    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
35    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
36    * transfer, the approved address for that NFT (if any) is reset to none.
37    */
38   event Transfer(
39     address indexed _from,
40     address indexed _to,
41     uint256 indexed _tokenId
42   );
43 
44   /**
45    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
46    * address indicates there is no approved address. When a Transfer event emits, this also
47    * indicates that the approved address for that NFT (if any) is reset to none.
48    */
49   event Approval(
50     address indexed _owner,
51     address indexed _approved,
52     uint256 indexed _tokenId
53   );
54 
55   /**
56    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
57    * all NFTs of the owner.
58    */
59   event ApprovalForAll(
60     address indexed _owner,
61     address indexed _operator,
62     bool _approved
63   );
64 
65   /**
66    * @dev Transfers the ownership of an NFT from one address to another address.
67    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
68    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
69    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
70    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
71    * `onERC721Received` on `_to` and throws if the return value is not 
72    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
73    * @param _from The current owner of the NFT.
74    * @param _to The new owner.
75    * @param _tokenId The NFT to transfer.
76    * @param _data Additional data with no specified format, sent in call to `_to`.
77    */
78   function safeTransferFrom(
79     address _from,
80     address _to,
81     uint256 _tokenId,
82     bytes calldata _data
83   )
84     external;
85 
86   /**
87    * @dev Transfers the ownership of an NFT from one address to another address.
88    * @notice This works identically to the other function with an extra data parameter, except this
89    * function just sets data to ""
90    * @param _from The current owner of the NFT.
91    * @param _to The new owner.
92    * @param _tokenId The NFT to transfer.
93    */
94   function safeTransferFrom(
95     address _from,
96     address _to,
97     uint256 _tokenId
98   )
99     external;
100 
101   /**
102    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
103    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
104    * address. Throws if `_tokenId` is not a valid NFT.
105    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
106    * they mayb be permanently lost.
107    * @param _from The current owner of the NFT.
108    * @param _to The new owner.
109    * @param _tokenId The NFT to transfer.
110    */
111   function transferFrom(
112     address _from,
113     address _to,
114     uint256 _tokenId
115   )
116     external;
117 
118   /**
119    * @dev Set or reaffirm the approved address for an NFT.
120    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
121    * the current NFT owner, or an authorized operator of the current owner.
122    * @param _approved The new approved NFT controller.
123    * @param _tokenId The NFT to approve.
124    */
125   function approve(
126     address _approved,
127     uint256 _tokenId
128   )
129     external;
130 
131   /**
132    * @dev Enables or disables approval for a third party ("operator") to manage all of
133    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
134    * @notice The contract MUST allow multiple operators per owner.
135    * @param _operator Address to add to the set of authorized operators.
136    * @param _approved True if the operators is approved, false to revoke approval.
137    */
138   function setApprovalForAll(
139     address _operator,
140     bool _approved
141   )
142     external;
143 
144   /**
145    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
146    * considered invalid, and this function throws for queries about the zero address.
147    * @param _owner Address for whom to query the balance.
148    * @return Balance of _owner.
149    */
150   function balanceOf(
151     address _owner
152   )
153     external
154     view
155     returns (uint256);
156 
157   /**
158    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
159    * invalid, and queries about them do throw.
160    * @param _tokenId The identifier for an NFT.
161    * @return Address of _tokenId owner.
162    */
163   function ownerOf(
164     uint256 _tokenId
165   )
166     external
167     view
168     returns (address);
169     
170   /**
171    * @dev Get the approved address for a single NFT.
172    * @notice Throws if `_tokenId` is not a valid NFT.
173    * @param _tokenId The NFT to find the approved address for.
174    * @return Address that _tokenId is approved for. 
175    */
176   function getApproved(
177     uint256 _tokenId
178   )
179     external
180     view
181     returns (address);
182 
183   /**
184    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
185    * @param _owner The address that owns the NFTs.
186    * @param _operator The address that acts on behalf of the owner.
187    * @return True if approved for all, false otherwise.
188    */
189   function isApprovedForAll(
190     address _owner,
191     address _operator
192   )
193     external
194     view
195     returns (bool);
196 
197 }
198 
199 /**
200  * @dev Math operations with safety checks that throw on error. This contract is based on the 
201  * source code at: 
202  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
203  */
204 library SafeMath
205 {
206 
207   /**
208    * @dev Error constants.
209    */
210   string constant OVERFLOW = "008001";
211   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
212   string constant DIVISION_BY_ZERO = "008003";
213 
214   /**
215    * @dev Multiplies two numbers, reverts on overflow.
216    * @param _factor1 Factor number.
217    * @param _factor2 Factor number.
218    * @return The product of the two factors.
219    */
220   function mul(
221     uint256 _factor1,
222     uint256 _factor2
223   )
224     internal
225     pure
226     returns (uint256 product)
227   {
228     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
229     // benefit is lost if 'b' is also tested.
230     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
231     if (_factor1 == 0)
232     {
233       return 0;
234     }
235 
236     product = _factor1 * _factor2;
237     require(product / _factor1 == _factor2, OVERFLOW);
238   }
239 
240   /**
241    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
242    * @param _dividend Dividend number.
243    * @param _divisor Divisor number.
244    * @return The quotient.
245    */
246   function div(
247     uint256 _dividend,
248     uint256 _divisor
249   )
250     internal
251     pure
252     returns (uint256 quotient)
253   {
254     // Solidity automatically asserts when dividing by 0, using all gas.
255     require(_divisor > 0, DIVISION_BY_ZERO);
256     quotient = _dividend / _divisor;
257     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
258   }
259 
260   /**
261    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
262    * @param _minuend Minuend number.
263    * @param _subtrahend Subtrahend number.
264    * @return Difference.
265    */
266   function sub(
267     uint256 _minuend,
268     uint256 _subtrahend
269   )
270     internal
271     pure
272     returns (uint256 difference)
273   {
274     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
275     difference = _minuend - _subtrahend;
276   }
277 
278   /**
279    * @dev Adds two numbers, reverts on overflow.
280    * @param _addend1 Number.
281    * @param _addend2 Number.
282    * @return Sum.
283    */
284   function add(
285     uint256 _addend1,
286     uint256 _addend2
287   )
288     internal
289     pure
290     returns (uint256 sum)
291   {
292     sum = _addend1 + _addend2;
293     require(sum >= _addend1, OVERFLOW);
294   }
295 
296   /**
297     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
298     * dividing by zero.
299     * @param _dividend Number.
300     * @param _divisor Number.
301     * @return Remainder.
302     */
303   function mod(
304     uint256 _dividend,
305     uint256 _divisor
306   )
307     internal
308     pure
309     returns (uint256 remainder) 
310   {
311     require(_divisor != 0, DIVISION_BY_ZERO);
312     remainder = _dividend % _divisor;
313   }
314 
315 }
316 
317 /**
318  * @title Contract for setting abilities.
319  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
320  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
321  * this works. 
322  * 00000001 Ability A - number representation 1
323  * 00000010 Ability B - number representation 2
324  * 00000100 Ability C - number representation 4
325  * 00001000 Ability D - number representation 8
326  * 00010000 Ability E - number representation 16
327  * etc ... 
328  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
329  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
330  * and checking if someone has multiple abilities.
331  */
332 contract Abilitable
333 {
334   using SafeMath for uint;
335 
336   /**
337    * @dev Error constants.
338    */
339   string constant NOT_AUTHORIZED = "017001";
340   string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";
341   string constant INVALID_INPUT = "017003";
342 
343   /**
344    * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. 
345    * There can be minimum of 1 address with ability 1.
346    * Other abilities are determined by implementing contract.
347    */
348   uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;
349 
350   /**
351    * @dev Maps address to ability ids.
352    */
353   mapping(address => uint256) public addressToAbility;
354 
355   /**
356    * @dev Count of zero ability addresses.
357    */
358   uint256 private zeroAbilityCount;
359 
360   /**
361    * @dev Emits when an address is granted an ability.
362    * @param _target Address to which we are granting abilities.
363    * @param _abilities Number representing bitfield of abilities we are granting.
364    */
365   event GrantAbilities(
366     address indexed _target,
367     uint256 indexed _abilities
368   );
369 
370   /**
371    * @dev Emits when an address gets an ability revoked.
372    * @param _target Address of which we are revoking an ability.
373    * @param _abilities Number representing bitfield of abilities we are revoking.
374    */
375   event RevokeAbilities(
376     address indexed _target,
377     uint256 indexed _abilities
378   );
379 
380   /**
381    * @dev Guarantees that msg.sender has certain abilities.
382    */
383   modifier hasAbilities(
384     uint256 _abilities
385   ) 
386   {
387     require(_abilities > 0, INVALID_INPUT);
388     require(
389       (addressToAbility[msg.sender] & _abilities) == _abilities,
390       NOT_AUTHORIZED
391     );
392     _;
393   }
394 
395   /**
396    * @dev Contract constructor.
397    * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.
398    */
399   constructor()
400     public
401   {
402     addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;
403     zeroAbilityCount = 1;
404     emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);
405   }
406 
407   /**
408    * @dev Grants specific abilities to specified address.
409    * @param _target Address to grant abilities to.
410    * @param _abilities Number representing bitfield of abilities we are granting.
411    */
412   function grantAbilities(
413     address _target,
414     uint256 _abilities
415   )
416     external
417     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
418   {
419     addressToAbility[_target] |= _abilities;
420 
421     if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)
422     {
423       zeroAbilityCount = zeroAbilityCount.add(1);
424     }
425     emit GrantAbilities(_target, _abilities);
426   }
427 
428   /**
429    * @dev Unassigns specific abilities from specified address.
430    * @param _target Address of which we revoke abilites.
431    * @param _abilities Number representing bitfield of abilities we are revoking.
432    */
433   function revokeAbilities(
434     address _target,
435     uint256 _abilities
436   )
437     external
438     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
439   {
440     addressToAbility[_target] &= ~_abilities;
441     if((_abilities & 1) == 1)
442     {
443       require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);
444       zeroAbilityCount--;
445     }
446     emit RevokeAbilities(_target, _abilities);
447   }
448 
449   /**
450    * @dev Check if an address has a specific ability. Throws if checking for 0.
451    * @param _target Address for which we want to check if it has a specific abilities.
452    * @param _abilities Number representing bitfield of abilities we are checking.
453    */
454   function isAble(
455     address _target,
456     uint256 _abilities
457   )
458     external
459     view
460     returns (bool)
461   {
462     require(_abilities > 0, INVALID_INPUT);
463     return (addressToAbility[_target] & _abilities) == _abilities;
464   }
465   
466 }
467 
468 /** 
469  * @title NFTokenTransferProxy - Transfers none-fundgible tokens on behalf of contracts that have 
470  * been approved via decentralized governance.
471  * @dev based on:https://github.com/0xProject/contracts/blob/master/contracts/TokenTransferProxy.sol
472  */
473 contract NFTokenTransferProxy is 
474   Proxy,
475   Abilitable 
476 {
477 
478   /**
479    * @dev List of abilities:
480    * 2 - Ability to execute transfer. 
481    */
482   uint8 constant ABILITY_TO_EXECUTE = 2;
483 
484   /**
485    * @dev Transfers a NFT.
486    * @param _target Address of NFT contract.
487    * @param _a Address from which the NFT will be sent.
488    * @param _b Address to which the NFT will be sent.
489    * @param _c Id of the NFT being sent.
490    */
491   function execute(
492     address _target,
493     address _a,
494     address _b,
495     uint256 _c
496   )
497     external
498     hasAbilities(ABILITY_TO_EXECUTE)
499   {
500     ERC721(_target).transferFrom(_a, _b, _c);
501   }
502   
503 }
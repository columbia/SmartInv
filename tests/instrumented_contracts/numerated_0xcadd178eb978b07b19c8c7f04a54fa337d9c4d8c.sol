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
26  * @title A standard interface for tokens.
27  * @dev This interface uses the official ERC-20 specification from
28  * https://eips.ethereum.org/EIPS/eip-20 with the additional requirement that
29  * the functions specificed as optional have become required.
30  */
31 interface ERC20
32 {
33 
34   /**
35    * @dev Returns the name of the token.
36    * @return Token name.
37    */
38   function name()
39     external
40     view
41     returns (string memory _name);
42 
43   /**
44    * @dev Returns the symbol of the token.
45    * @return Token symbol.
46    */
47   function symbol()
48     external
49     view
50     returns (string memory _symbol);
51 
52   /**
53    * @dev Returns the number of decimals the token uses.
54    * @return Number of decimals.
55    */
56   function decimals()
57     external
58     view
59     returns (uint8 _decimals);
60 
61   /**
62    * @dev Returns the total token supply.
63    * @return Total supply.
64    */
65   function totalSupply()
66     external
67     view
68     returns (uint256 _totalSupply);
69 
70   /**
71    * @dev Returns the account balance of another account with address _owner.
72    * @param _owner The address from which the balance will be retrieved.
73    * @return Balance of _owner.
74    */
75   function balanceOf(
76     address _owner
77   )
78     external
79     view
80     returns (uint256 _balance);
81 
82   /**
83    * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The
84    * function SHOULD throw if the message caller's account balance does not have enough tokens to
85    * spend.
86    * @param _to The address of the recipient.
87    * @param _value The amount of token to be transferred.
88    * @return Success of operation.
89    */
90   function transfer(
91     address _to,
92     uint256 _value
93   )
94     external
95     returns (bool _success);
96 
97   /**
98    * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the
99    * Transfer event.
100    * @param _from The address of the sender.
101    * @param _to The address of the recipient.
102    * @param _value The amount of token to be transferred.
103    * @return Success of operation.
104    */
105   function transferFrom(
106     address _from,
107     address _to,
108     uint256 _value
109   )
110     external
111     returns (bool _success);
112 
113   /**
114    * @dev Allows _spender to withdraw from your account multiple times, up to
115    * the _value amount. If this function is called again it overwrites the current
116    * allowance with _value.
117    * @param _spender The address of the account able to transfer the tokens.
118    * @param _value The amount of tokens to be approved for transfer.
119    * @return Success of operation.
120    */
121   function approve(
122     address _spender,
123     uint256 _value
124   )
125     external
126     returns (bool _success);
127 
128   /**
129    * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
130    * @param _owner The address of the account owning tokens.
131    * @param _spender The address of the account able to transfer the tokens.
132    * @return Remaining allowance.
133    */
134   function allowance(
135     address _owner,
136     address _spender
137   )
138     external
139     view
140     returns (uint256 _remaining);
141 
142   /**
143    * @dev Triggers when tokens are transferred, including zero value transfers.
144    */
145   event Transfer(
146     address indexed _from,
147     address indexed _to,
148     uint256 _value
149   );
150 
151   /**
152    * @dev Triggers on any successful call to approve(address _spender, uint256 _value).
153    */
154   event Approval(
155     address indexed _owner,
156     address indexed _spender,
157     uint256 _value
158   );
159 
160 }
161 
162 /**
163  * @dev Math operations with safety checks that throw on error. This contract is based on the 
164  * source code at: 
165  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
166  */
167 library SafeMath
168 {
169 
170   /**
171    * @dev Error constants.
172    */
173   string constant OVERFLOW = "008001";
174   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
175   string constant DIVISION_BY_ZERO = "008003";
176 
177   /**
178    * @dev Multiplies two numbers, reverts on overflow.
179    * @param _factor1 Factor number.
180    * @param _factor2 Factor number.
181    * @return The product of the two factors.
182    */
183   function mul(
184     uint256 _factor1,
185     uint256 _factor2
186   )
187     internal
188     pure
189     returns (uint256 product)
190   {
191     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192     // benefit is lost if 'b' is also tested.
193     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194     if (_factor1 == 0)
195     {
196       return 0;
197     }
198 
199     product = _factor1 * _factor2;
200     require(product / _factor1 == _factor2, OVERFLOW);
201   }
202 
203   /**
204    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
205    * @param _dividend Dividend number.
206    * @param _divisor Divisor number.
207    * @return The quotient.
208    */
209   function div(
210     uint256 _dividend,
211     uint256 _divisor
212   )
213     internal
214     pure
215     returns (uint256 quotient)
216   {
217     // Solidity automatically asserts when dividing by 0, using all gas.
218     require(_divisor > 0, DIVISION_BY_ZERO);
219     quotient = _dividend / _divisor;
220     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
221   }
222 
223   /**
224    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
225    * @param _minuend Minuend number.
226    * @param _subtrahend Subtrahend number.
227    * @return Difference.
228    */
229   function sub(
230     uint256 _minuend,
231     uint256 _subtrahend
232   )
233     internal
234     pure
235     returns (uint256 difference)
236   {
237     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
238     difference = _minuend - _subtrahend;
239   }
240 
241   /**
242    * @dev Adds two numbers, reverts on overflow.
243    * @param _addend1 Number.
244    * @param _addend2 Number.
245    * @return Sum.
246    */
247   function add(
248     uint256 _addend1,
249     uint256 _addend2
250   )
251     internal
252     pure
253     returns (uint256 sum)
254   {
255     sum = _addend1 + _addend2;
256     require(sum >= _addend1, OVERFLOW);
257   }
258 
259   /**
260     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
261     * dividing by zero.
262     * @param _dividend Number.
263     * @param _divisor Number.
264     * @return Remainder.
265     */
266   function mod(
267     uint256 _dividend,
268     uint256 _divisor
269   )
270     internal
271     pure
272     returns (uint256 remainder) 
273   {
274     require(_divisor != 0, DIVISION_BY_ZERO);
275     remainder = _dividend % _divisor;
276   }
277 
278 }
279 
280 /**
281  * @title Contract for setting abilities.
282  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
283  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
284  * this works. 
285  * 00000001 Ability A - number representation 1
286  * 00000010 Ability B - number representation 2
287  * 00000100 Ability C - number representation 4
288  * 00001000 Ability D - number representation 8
289  * 00010000 Ability E - number representation 16
290  * etc ... 
291  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
292  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
293  * and checking if someone has multiple abilities.
294  */
295 contract Abilitable
296 {
297   using SafeMath for uint;
298 
299   /**
300    * @dev Error constants.
301    */
302   string constant NOT_AUTHORIZED = "017001";
303   string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";
304   string constant INVALID_INPUT = "017003";
305 
306   /**
307    * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. 
308    * There can be minimum of 1 address with ability 1.
309    * Other abilities are determined by implementing contract.
310    */
311   uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;
312 
313   /**
314    * @dev Maps address to ability ids.
315    */
316   mapping(address => uint256) public addressToAbility;
317 
318   /**
319    * @dev Count of zero ability addresses.
320    */
321   uint256 private zeroAbilityCount;
322 
323   /**
324    * @dev Emits when an address is granted an ability.
325    * @param _target Address to which we are granting abilities.
326    * @param _abilities Number representing bitfield of abilities we are granting.
327    */
328   event GrantAbilities(
329     address indexed _target,
330     uint256 indexed _abilities
331   );
332 
333   /**
334    * @dev Emits when an address gets an ability revoked.
335    * @param _target Address of which we are revoking an ability.
336    * @param _abilities Number representing bitfield of abilities we are revoking.
337    */
338   event RevokeAbilities(
339     address indexed _target,
340     uint256 indexed _abilities
341   );
342 
343   /**
344    * @dev Guarantees that msg.sender has certain abilities.
345    */
346   modifier hasAbilities(
347     uint256 _abilities
348   ) 
349   {
350     require(_abilities > 0, INVALID_INPUT);
351     require(
352       (addressToAbility[msg.sender] & _abilities) == _abilities,
353       NOT_AUTHORIZED
354     );
355     _;
356   }
357 
358   /**
359    * @dev Contract constructor.
360    * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.
361    */
362   constructor()
363     public
364   {
365     addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;
366     zeroAbilityCount = 1;
367     emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);
368   }
369 
370   /**
371    * @dev Grants specific abilities to specified address.
372    * @param _target Address to grant abilities to.
373    * @param _abilities Number representing bitfield of abilities we are granting.
374    */
375   function grantAbilities(
376     address _target,
377     uint256 _abilities
378   )
379     external
380     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
381   {
382     addressToAbility[_target] |= _abilities;
383 
384     if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)
385     {
386       zeroAbilityCount = zeroAbilityCount.add(1);
387     }
388     emit GrantAbilities(_target, _abilities);
389   }
390 
391   /**
392    * @dev Unassigns specific abilities from specified address.
393    * @param _target Address of which we revoke abilites.
394    * @param _abilities Number representing bitfield of abilities we are revoking.
395    */
396   function revokeAbilities(
397     address _target,
398     uint256 _abilities
399   )
400     external
401     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
402   {
403     addressToAbility[_target] &= ~_abilities;
404     if((_abilities & 1) == 1)
405     {
406       require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);
407       zeroAbilityCount--;
408     }
409     emit RevokeAbilities(_target, _abilities);
410   }
411 
412   /**
413    * @dev Check if an address has a specific ability. Throws if checking for 0.
414    * @param _target Address for which we want to check if it has a specific abilities.
415    * @param _abilities Number representing bitfield of abilities we are checking.
416    */
417   function isAble(
418     address _target,
419     uint256 _abilities
420   )
421     external
422     view
423     returns (bool)
424   {
425     require(_abilities > 0, INVALID_INPUT);
426     return (addressToAbility[_target] & _abilities) == _abilities;
427   }
428   
429 }
430 
431 /**
432  * @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via
433  * decentralized governance.
434  * @dev Based on:https://github.com/0xProject/contracts/blob/master/contracts/TokenTransferProxy.sol
435  */
436 contract TokenTransferProxy is 
437   Proxy,
438   Abilitable 
439 {
440 
441   /**
442    * @dev List of abilities:
443    * 2 - Ability to execute transfer. 
444    */
445   uint8 constant ABILITY_TO_EXECUTE = 2;
446 
447   /**
448    * @dev Error constants.
449    */
450   string constant TRANSFER_FAILED = "012001";
451 
452   /**
453    * @dev Calls into ERC20 Token contract, invoking transferFrom.
454    * @param _target Address of token to transfer.
455    * @param _a Address to transfer token from.
456    * @param _b Address to transfer token to.
457    * @param _c Amount of token to transfer.
458    */
459   function execute(
460     address _target,
461     address _a,
462     address _b,
463     uint256 _c
464   )
465     public
466     hasAbilities(ABILITY_TO_EXECUTE)
467   {
468     require(
469       ERC20(_target).transferFrom(_a, _b, _c),
470       TRANSFER_FAILED
471     );
472   }
473   
474 }
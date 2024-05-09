1 pragma solidity 0.5.1;
2 
3 /**
4  * @dev Xcert interface.
5  */
6 interface Xcert // is ERC721 metadata enumerable
7 {
8 
9   /**
10    * @dev Creates a new Xcert.
11    * @param _to The address that will own the created Xcert.
12    * @param _id The Xcert to be created by the msg.sender.
13    * @param _imprint Cryptographic asset imprint.
14    */
15   function create(
16     address _to,
17     uint256 _id,
18     bytes32 _imprint
19   )
20     external;
21 
22   /**
23    * @dev Change URI base.
24    * @param _uriBase New uriBase.
25    */
26   function setUriBase(
27     string calldata _uriBase
28   )
29     external;
30 
31   /**
32    * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.
33    * @return Schema id.
34    */
35   function schemaId()
36     external
37     view
38     returns (bytes32 _schemaId);
39 
40   /**
41    * @dev Returns imprint for Xcert.
42    * @param _tokenId Id of the Xcert.
43    * @return Token imprint.
44    */
45   function tokenImprint(
46     uint256 _tokenId
47   )
48     external
49     view
50     returns(bytes32 imprint);
51 
52 }
53 
54 
55 /**
56  * @dev Math operations with safety checks that throw on error. This contract is based on the 
57  * source code at: 
58  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
59  */
60 library SafeMath
61 {
62 
63   /**
64    * @dev Error constants.
65    */
66   string constant OVERFLOW = "008001";
67   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
68   string constant DIVISION_BY_ZERO = "008003";
69 
70   /**
71    * @dev Multiplies two numbers, reverts on overflow.
72    * @param _factor1 Factor number.
73    * @param _factor2 Factor number.
74    * @return The product of the two factors.
75    */
76   function mul(
77     uint256 _factor1,
78     uint256 _factor2
79   )
80     internal
81     pure
82     returns (uint256 product)
83   {
84     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (_factor1 == 0)
88     {
89       return 0;
90     }
91 
92     product = _factor1 * _factor2;
93     require(product / _factor1 == _factor2, OVERFLOW);
94   }
95 
96   /**
97    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
98    * @param _dividend Dividend number.
99    * @param _divisor Divisor number.
100    * @return The quotient.
101    */
102   function div(
103     uint256 _dividend,
104     uint256 _divisor
105   )
106     internal
107     pure
108     returns (uint256 quotient)
109   {
110     // Solidity automatically asserts when dividing by 0, using all gas.
111     require(_divisor > 0, DIVISION_BY_ZERO);
112     quotient = _dividend / _divisor;
113     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
114   }
115 
116   /**
117    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118    * @param _minuend Minuend number.
119    * @param _subtrahend Subtrahend number.
120    * @return Difference.
121    */
122   function sub(
123     uint256 _minuend,
124     uint256 _subtrahend
125   )
126     internal
127     pure
128     returns (uint256 difference)
129   {
130     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
131     difference = _minuend - _subtrahend;
132   }
133 
134   /**
135    * @dev Adds two numbers, reverts on overflow.
136    * @param _addend1 Number.
137    * @param _addend2 Number.
138    * @return Sum.
139    */
140   function add(
141     uint256 _addend1,
142     uint256 _addend2
143   )
144     internal
145     pure
146     returns (uint256 sum)
147   {
148     sum = _addend1 + _addend2;
149     require(sum >= _addend1, OVERFLOW);
150   }
151 
152   /**
153     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
154     * dividing by zero.
155     * @param _dividend Number.
156     * @param _divisor Number.
157     * @return Remainder.
158     */
159   function mod(
160     uint256 _dividend,
161     uint256 _divisor
162   )
163     internal
164     pure
165     returns (uint256 remainder) 
166   {
167     require(_divisor != 0, DIVISION_BY_ZERO);
168     remainder = _dividend % _divisor;
169   }
170 
171 }
172 
173 /**
174  * @title Contract for setting abilities.
175  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
176  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
177  * this works. 
178  * 00000001 Ability A - number representation 1
179  * 00000010 Ability B - number representation 2
180  * 00000100 Ability C - number representation 4
181  * 00001000 Ability D - number representation 8
182  * 00010000 Ability E - number representation 16
183  * etc ... 
184  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
185  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
186  * and checking if someone has multiple abilities.
187  */
188 contract Abilitable
189 {
190   using SafeMath for uint;
191 
192   /**
193    * @dev Error constants.
194    */
195   string constant NOT_AUTHORIZED = "017001";
196   string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";
197   string constant INVALID_INPUT = "017003";
198 
199   /**
200    * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. 
201    * There can be minimum of 1 address with ability 1.
202    * Other abilities are determined by implementing contract.
203    */
204   uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;
205 
206   /**
207    * @dev Maps address to ability ids.
208    */
209   mapping(address => uint256) public addressToAbility;
210 
211   /**
212    * @dev Count of zero ability addresses.
213    */
214   uint256 private zeroAbilityCount;
215 
216   /**
217    * @dev Emits when an address is granted an ability.
218    * @param _target Address to which we are granting abilities.
219    * @param _abilities Number representing bitfield of abilities we are granting.
220    */
221   event GrantAbilities(
222     address indexed _target,
223     uint256 indexed _abilities
224   );
225 
226   /**
227    * @dev Emits when an address gets an ability revoked.
228    * @param _target Address of which we are revoking an ability.
229    * @param _abilities Number representing bitfield of abilities we are revoking.
230    */
231   event RevokeAbilities(
232     address indexed _target,
233     uint256 indexed _abilities
234   );
235 
236   /**
237    * @dev Guarantees that msg.sender has certain abilities.
238    */
239   modifier hasAbilities(
240     uint256 _abilities
241   ) 
242   {
243     require(_abilities > 0, INVALID_INPUT);
244     require(
245       (addressToAbility[msg.sender] & _abilities) == _abilities,
246       NOT_AUTHORIZED
247     );
248     _;
249   }
250 
251   /**
252    * @dev Contract constructor.
253    * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.
254    */
255   constructor()
256     public
257   {
258     addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;
259     zeroAbilityCount = 1;
260     emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);
261   }
262 
263   /**
264    * @dev Grants specific abilities to specified address.
265    * @param _target Address to grant abilities to.
266    * @param _abilities Number representing bitfield of abilities we are granting.
267    */
268   function grantAbilities(
269     address _target,
270     uint256 _abilities
271   )
272     external
273     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
274   {
275     addressToAbility[_target] |= _abilities;
276 
277     if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)
278     {
279       zeroAbilityCount = zeroAbilityCount.add(1);
280     }
281     emit GrantAbilities(_target, _abilities);
282   }
283 
284   /**
285    * @dev Unassigns specific abilities from specified address.
286    * @param _target Address of which we revoke abilites.
287    * @param _abilities Number representing bitfield of abilities we are revoking.
288    */
289   function revokeAbilities(
290     address _target,
291     uint256 _abilities
292   )
293     external
294     hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
295   {
296     addressToAbility[_target] &= ~_abilities;
297     if((_abilities & 1) == 1)
298     {
299       require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);
300       zeroAbilityCount--;
301     }
302     emit RevokeAbilities(_target, _abilities);
303   }
304 
305   /**
306    * @dev Check if an address has a specific ability. Throws if checking for 0.
307    * @param _target Address for which we want to check if it has a specific abilities.
308    * @param _abilities Number representing bitfield of abilities we are checking.
309    */
310   function isAble(
311     address _target,
312     uint256 _abilities
313   )
314     external
315     view
316     returns (bool)
317   {
318     require(_abilities > 0, INVALID_INPUT);
319     return (addressToAbility[_target] & _abilities) == _abilities;
320   }
321   
322 }
323 
324 /**
325  * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via
326  * decentralized governance.
327  */
328 contract XcertCreateProxy is 
329   Abilitable 
330 {
331 
332   /**
333    * @dev List of abilities:
334    * 2 - Ability to execute create. 
335    */
336   uint8 constant ABILITY_TO_EXECUTE = 2;
337 
338   /**
339    * @dev Creates a new NFT.
340    * @param _xcert Address of the Xcert contract on which the creation will be perfomed.
341    * @param _to The address that will own the created NFT.
342    * @param _id The NFT to be created by the msg.sender.
343    * @param _imprint Cryptographic asset imprint.
344    */
345   function create(
346     address _xcert,
347     address _to,
348     uint256 _id,
349     bytes32 _imprint
350   )
351     external
352     hasAbilities(ABILITY_TO_EXECUTE)
353   {
354     Xcert(_xcert).create(_to, _id, _imprint);
355   }
356   
357 }
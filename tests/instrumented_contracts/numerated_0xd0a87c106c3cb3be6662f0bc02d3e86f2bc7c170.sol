1 pragma solidity 0.5.6;
2 
3 /**
4  * @dev Xcert nutable interface.
5  */
6 interface XcertMutable // is Xcert
7 {
8   
9   /**
10    * @dev Updates Xcert imprint.
11    * @param _tokenId Id of the Xcert.
12    * @param _imprint New imprint.
13    */
14   function updateTokenImprint(
15     uint256 _tokenId,
16     bytes32 _imprint
17   )
18     external;
19 
20 }
21 
22 /**
23  * @dev Math operations with safety checks that throw on error. This contract is based on the 
24  * source code at: 
25  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
26  */
27 library SafeMath
28 {
29 
30   /**
31    * @dev Error constants.
32    */
33   string constant OVERFLOW = "008001";
34   string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
35   string constant DIVISION_BY_ZERO = "008003";
36 
37   /**
38    * @dev Multiplies two numbers, reverts on overflow.
39    * @param _factor1 Factor number.
40    * @param _factor2 Factor number.
41    * @return The product of the two factors.
42    */
43   function mul(
44     uint256 _factor1,
45     uint256 _factor2
46   )
47     internal
48     pure
49     returns (uint256 product)
50   {
51     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (_factor1 == 0)
55     {
56       return 0;
57     }
58 
59     product = _factor1 * _factor2;
60     require(product / _factor1 == _factor2, OVERFLOW);
61   }
62 
63   /**
64    * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
65    * @param _dividend Dividend number.
66    * @param _divisor Divisor number.
67    * @return The quotient.
68    */
69   function div(
70     uint256 _dividend,
71     uint256 _divisor
72   )
73     internal
74     pure
75     returns (uint256 quotient)
76   {
77     // Solidity automatically asserts when dividing by 0, using all gas.
78     require(_divisor > 0, DIVISION_BY_ZERO);
79     quotient = _dividend / _divisor;
80     // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
81   }
82 
83   /**
84    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85    * @param _minuend Minuend number.
86    * @param _subtrahend Subtrahend number.
87    * @return Difference.
88    */
89   function sub(
90     uint256 _minuend,
91     uint256 _subtrahend
92   )
93     internal
94     pure
95     returns (uint256 difference)
96   {
97     require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
98     difference = _minuend - _subtrahend;
99   }
100 
101   /**
102    * @dev Adds two numbers, reverts on overflow.
103    * @param _addend1 Number.
104    * @param _addend2 Number.
105    * @return Sum.
106    */
107   function add(
108     uint256 _addend1,
109     uint256 _addend2
110   )
111     internal
112     pure
113     returns (uint256 sum)
114   {
115     sum = _addend1 + _addend2;
116     require(sum >= _addend1, OVERFLOW);
117   }
118 
119   /**
120     * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
121     * dividing by zero.
122     * @param _dividend Number.
123     * @param _divisor Number.
124     * @return Remainder.
125     */
126   function mod(
127     uint256 _dividend,
128     uint256 _divisor
129   )
130     internal
131     pure
132     returns (uint256 remainder) 
133   {
134     require(_divisor != 0, DIVISION_BY_ZERO);
135     remainder = _dividend % _divisor;
136   }
137 
138 }
139 
140 /**
141  * @title Contract for setting abilities.
142  * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
143  * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
144  * this works. 
145  * 00000001 Ability A - number representation 1
146  * 00000010 Ability B - number representation 2
147  * 00000100 Ability C - number representation 4
148  * 00001000 Ability D - number representation 8
149  * 00010000 Ability E - number representation 16
150  * etc ... 
151  * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
152  * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
153  * and checking if someone has multiple abilities.
154  */
155 contract Abilitable
156 {
157   using SafeMath for uint;
158 
159   /**
160    * @dev Error constants.
161    */
162   string constant NOT_AUTHORIZED = "017001";
163   string constant CANNOT_REVOKE_OWN_SUPER_ABILITY = "017002";
164   string constant INVALID_INPUT = "017003";
165 
166   /**
167    * @dev Ability 1 (00000001) is a reserved ability called super ability. It is an
168    * ability to grant or revoke abilities of other accounts. Other abilities are determined by the
169    * implementing contract.
170    */
171   uint8 constant SUPER_ABILITY = 1;
172 
173   /**
174    * @dev Maps address to ability ids.
175    */
176   mapping(address => uint256) public addressToAbility;
177 
178   /**
179    * @dev Emits when an address is granted an ability.
180    * @param _target Address to which we are granting abilities.
181    * @param _abilities Number representing bitfield of abilities we are granting.
182    */
183   event GrantAbilities(
184     address indexed _target,
185     uint256 indexed _abilities
186   );
187 
188   /**
189    * @dev Emits when an address gets an ability revoked.
190    * @param _target Address of which we are revoking an ability.
191    * @param _abilities Number representing bitfield of abilities we are revoking.
192    */
193   event RevokeAbilities(
194     address indexed _target,
195     uint256 indexed _abilities
196   );
197 
198   /**
199    * @dev Guarantees that msg.sender has certain abilities.
200    */
201   modifier hasAbilities(
202     uint256 _abilities
203   ) 
204   {
205     require(_abilities > 0, INVALID_INPUT);
206     require(
207       addressToAbility[msg.sender] & _abilities == _abilities,
208       NOT_AUTHORIZED
209     );
210     _;
211   }
212 
213   /**
214    * @dev Contract constructor.
215    * Sets SUPER_ABILITY ability to the sender account.
216    */
217   constructor()
218     public
219   {
220     addressToAbility[msg.sender] = SUPER_ABILITY;
221     emit GrantAbilities(msg.sender, SUPER_ABILITY);
222   }
223 
224   /**
225    * @dev Grants specific abilities to specified address.
226    * @param _target Address to grant abilities to.
227    * @param _abilities Number representing bitfield of abilities we are granting.
228    */
229   function grantAbilities(
230     address _target,
231     uint256 _abilities
232   )
233     external
234     hasAbilities(SUPER_ABILITY)
235   {
236     addressToAbility[_target] |= _abilities;
237     emit GrantAbilities(_target, _abilities);
238   }
239 
240   /**
241    * @dev Unassigns specific abilities from specified address.
242    * @param _target Address of which we revoke abilites.
243    * @param _abilities Number representing bitfield of abilities we are revoking.
244    * @param _allowSuperRevoke Additional check that prevents you from removing your own super
245    * ability by mistake.
246    */
247   function revokeAbilities(
248     address _target,
249     uint256 _abilities,
250     bool _allowSuperRevoke
251   )
252     external
253     hasAbilities(SUPER_ABILITY)
254   {
255     if (!_allowSuperRevoke && msg.sender == _target)
256     {
257       require((_abilities & 1) == 0, CANNOT_REVOKE_OWN_SUPER_ABILITY);
258     }
259     addressToAbility[_target] &= ~_abilities;
260     emit RevokeAbilities(_target, _abilities);
261   }
262 
263   /**
264    * @dev Check if an address has a specific ability. Throws if checking for 0.
265    * @param _target Address for which we want to check if it has a specific abilities.
266    * @param _abilities Number representing bitfield of abilities we are checking.
267    */
268   function isAble(
269     address _target,
270     uint256 _abilities
271   )
272     external
273     view
274     returns (bool)
275   {
276     require(_abilities > 0, INVALID_INPUT);
277     return (addressToAbility[_target] & _abilities) == _abilities;
278   }
279   
280 }
281 
282 /**
283  * @title XcertUpdateProxy - updates a token on behalf of contracts that have been approved via
284  * decentralized governance.
285  * @notice There is a possibility of unintentional behavior when token imprint can be overwritten
286  * if more than one claim is active. Be aware of this when implementing.
287  */
288 contract XcertUpdateProxy is
289   Abilitable
290 {
291 
292   /**
293    * @dev List of abilities:
294    * 2 - Ability to execute create.
295    */
296   uint8 constant ABILITY_TO_EXECUTE = 2;
297 
298   /**
299    * @dev Updates imprint of an existing Xcert.
300    * @param _xcert Address of the Xcert contract on which the update will be perfomed.
301    * @param _id The Xcert we will update.
302    * @param _imprint Cryptographic asset imprint.
303    */
304   function update(
305     address _xcert,
306     uint256 _id,
307     bytes32 _imprint
308   )
309     external
310     hasAbilities(ABILITY_TO_EXECUTE)
311   {
312     XcertMutable(_xcert).updateTokenImprint(_id, _imprint);
313   }
314 
315 }
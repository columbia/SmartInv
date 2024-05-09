1 pragma solidity ^0.4.24;
2 
3 // File: C:\Users\James\simpletoken\node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: C:\Users\James\simpletoken\node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: C:\Users\James\simpletoken\node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: C:\Users\James\simpletoken\node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
322 
323 /**
324  * @title SafeMath
325  * @dev Math operations with safety checks that throw on error
326  */
327 
328   
329 
330   /**
331   * @dev Adds two numbers, throws on overflow.
332   */
333 
334 // File: ethberlin-master\contracts\math\Power.sol
335 
336 /**
337  * bancor formula by bancor
338  * https://github.com/bancorprotocol/contracts
339  * Modified from the original by Slava Balasanov
340  * Split Power.sol out from BancorFormula.sol
341  * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
342  * and to You under the Apache License, Version 2.0. "
343  */
344 contract Power {
345   string public version = "0.3";
346 
347   uint256 private constant ONE = 1;
348   uint32 private constant MAX_WEIGHT = 1000000;
349   uint8 private constant MIN_PRECISION = 32;
350   uint8 private constant MAX_PRECISION = 127;
351 
352   /**
353     The values below depend on MAX_PRECISION. If you choose to change it:
354     Apply the same change in file 'PrintIntScalingFactors.py', run it and paste the results below.
355   */
356   uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
357   uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
358   uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;
359 
360   /**
361     The values below depend on MAX_PRECISION. If you choose to change it:
362     Apply the same change in file 'PrintLn2ScalingFactors.py', run it and paste the results below.
363   */
364   uint256 private constant LN2_MANTISSA = 0x2c5c85fdf473de6af278ece600fcbda;
365   uint8   private constant LN2_EXPONENT = 122;
366 
367   /**
368     The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
369     Apply the same change in file 'PrintFunctionBancorFormula.py', run it and paste the results below.
370   */
371   uint256[128] private maxExpArray;
372 
373   constructor() public {
374 //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
375 //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
376 //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
377 //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
378 //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
379 //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
380 //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
381 //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
382 //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
383 //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
384 //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
385 //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
386 //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
387 //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
388 //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
389 //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
390 //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
391 //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
392 //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
393 //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
394 //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
395 //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
396 //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
397 //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
398 //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
399 //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
400 //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
401 //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
402 //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
403 //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
404 //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
405 //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
406     maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
407     maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
408     maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
409     maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
410     maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
411     maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
412     maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
413     maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
414     maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
415     maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
416     maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
417     maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
418     maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
419     maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
420     maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
421     maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
422     maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
423     maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
424     maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
425     maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
426     maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
427     maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
428     maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
429     maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
430     maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
431     maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
432     maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
433     maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
434     maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
435     maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
436     maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
437     maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
438     maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
439     maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
440     maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
441     maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
442     maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
443     maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
444     maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
445     maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
446     maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
447     maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
448     maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
449     maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
450     maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
451     maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
452     maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
453     maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
454     maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
455     maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
456     maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
457     maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
458     maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
459     maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
460     maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
461     maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
462     maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
463     maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
464     maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
465     maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
466     maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
467     maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
468     maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
469     maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
470     maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
471     maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
472     maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
473     maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
474     maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
475     maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
476     maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
477     maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
478     maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
479     maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
480     maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
481     maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
482     maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
483     maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
484     maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
485     maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
486     maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
487     maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
488     maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
489     maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
490     maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
491     maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
492     maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
493     maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
494     maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
495     maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
496     maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
497     maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
498     maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
499     maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
500     maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
501     maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
502   }
503 
504 
505   /**
506     General Description:
507         Determine a value of precision.
508         Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
509         Return the result along with the precision used.
510 
511     Detailed Description:
512         Instead of calculating "base ^ exp", we calculate "e ^ (ln(base) * exp)".
513         The value of "ln(base)" is represented with an integer slightly smaller than "ln(base) * 2 ^ precision".
514         The larger "precision" is, the more accurately this value represents the real value.
515         However, the larger "precision" is, the more bits are required in order to store this value.
516         And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
517         This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
518         Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
519         This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
520 */
521   function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal constant returns (uint256, uint8) {
522     uint256 lnBaseTimesExp = ln(_baseN, _baseD) * _expN / _expD;
523     uint8 precision = findPositionInMaxExpArray(lnBaseTimesExp);
524     return (fixedExp(lnBaseTimesExp >> (MAX_PRECISION - precision), precision), precision);
525   }
526 
527   /**
528     Return floor(ln(numerator / denominator) * 2 ^ MAX_PRECISION), where:
529     - The numerator   is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
530     - The denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
531     - The output      is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
532     This functions assumes that the numerator is larger than or equal to the denominator, because the output would be negative otherwise.
533   */
534   function ln(uint256 _numerator, uint256 _denominator) internal constant returns (uint256) {
535     assert(_numerator <= MAX_NUM);
536 
537     uint256 res = 0;
538     uint256 x = _numerator * FIXED_1 / _denominator;
539 
540     // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
541     if (x >= FIXED_2) {
542       uint8 count = floorLog2(x / FIXED_1);
543       x >>= count; // now x < 2
544       res = count * FIXED_1;
545     }
546 
547     // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
548     if (x > FIXED_1) {
549       for (uint8 i = MAX_PRECISION; i > 0; --i) {
550         x = (x * x) / FIXED_1; // now 1 < x < 4
551         if (x >= FIXED_2) {
552           x >>= 1; // now 1 < x < 2
553           res += ONE << (i - 1);
554         }
555       }
556     }
557 
558     return (res * LN2_MANTISSA) >> LN2_EXPONENT;
559   }
560 
561   /**
562     Compute the largest integer smaller than or equal to the binary logarithm of the input.
563   */
564   function floorLog2(uint256 _n) internal constant returns (uint8) {
565     uint8 res = 0;
566     uint256 n = _n;
567 
568     if (n < 256) {
569       // At most 8 iterations
570       while (n > 1) {
571         n >>= 1;
572         res += 1;
573       }
574     } else {
575       // Exactly 8 iterations
576       for (uint8 s = 128; s > 0; s >>= 1) {
577         if (n >= (ONE << s)) {
578           n >>= s;
579           res |= s;
580         }
581       }
582     }
583 
584     return res;
585   }
586 
587   /**
588       The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
589       - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
590       - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
591   */
592   function findPositionInMaxExpArray(uint256 _x) internal constant returns (uint8) {
593     uint8 lo = MIN_PRECISION;
594     uint8 hi = MAX_PRECISION;
595 
596     while (lo + 1 < hi) {
597       uint8 mid = (lo + hi) / 2;
598       if (maxExpArray[mid] >= _x)
599         lo = mid;
600       else
601         hi = mid;
602     }
603 
604     if (maxExpArray[hi] >= _x)
605         return hi;
606     if (maxExpArray[lo] >= _x)
607         return lo;
608 
609     assert(false);
610     return 0;
611   }
612 
613   /**
614       This function can be auto-generated by the script 'PrintFunctionFixedExp.py'.
615       It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
616       It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
617       The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
618       The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
619   */
620   function fixedExp(uint256 _x, uint8 _precision) internal constant returns (uint256) {
621     uint256 xi = _x;
622     uint256 res = 0;
623 
624     xi = (xi * _x) >> _precision;
625     res += xi * 0x03442c4e6074a82f1797f72ac0000000; // add x^2 * (33! / 2!)
626     xi = (xi * _x) >> _precision;
627     res += xi * 0x0116b96f757c380fb287fd0e40000000; // add x^3 * (33! / 3!)
628     xi = (xi * _x) >> _precision;
629     res += xi * 0x0045ae5bdd5f0e03eca1ff4390000000; // add x^4 * (33! / 4!)
630     xi = (xi * _x) >> _precision;
631     res += xi * 0x000defabf91302cd95b9ffda50000000; // add x^5 * (33! / 5!)
632     xi = (xi * _x) >> _precision;
633     res += xi * 0x0002529ca9832b22439efff9b8000000; // add x^6 * (33! / 6!)
634     xi = (xi * _x) >> _precision;
635     res += xi * 0x000054f1cf12bd04e516b6da88000000; // add x^7 * (33! / 7!)
636     xi = (xi * _x) >> _precision;
637     res += xi * 0x00000a9e39e257a09ca2d6db51000000; // add x^8 * (33! / 8!)
638     xi = (xi * _x) >> _precision;
639     res += xi * 0x0000012e066e7b839fa050c309000000; // add x^9 * (33! / 9!)
640     xi = (xi * _x) >> _precision;
641     res += xi * 0x0000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
642     xi = (xi * _x) >> _precision;
643     res += xi * 0x00000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
644     xi = (xi * _x) >> _precision;
645     res += xi * 0x000000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
646     xi = (xi * _x) >> _precision;
647     res += xi * 0x00000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
648     xi = (xi * _x) >> _precision;
649     res += xi * 0x00000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
650     xi = (xi * _x) >> _precision;
651     res += xi * 0x0000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
652     xi = (xi * _x) >> _precision;
653     res += xi * 0x00000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
654     xi = (xi * _x) >> _precision;
655     res += xi * 0x000000000000052b6b54569976310000; // add x^17 * (33! / 17!)
656     xi = (xi * _x) >> _precision;
657     res += xi * 0x000000000000004985f67696bf748000; // add x^18 * (33! / 18!)
658     xi = (xi * _x) >> _precision;
659     res += xi * 0x0000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
660     xi = (xi * _x) >> _precision;
661     res += xi * 0x000000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
662     xi = (xi * _x) >> _precision;
663     res += xi * 0x0000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
664     xi = (xi * _x) >> _precision;
665     res += xi * 0x0000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
666     xi = (xi * _x) >> _precision;
667     res += xi * 0x00000000000000000001317c70077000; // add x^23 * (33! / 23!)
668     xi = (xi * _x) >> _precision;
669     res += xi * 0x000000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
670     xi = (xi * _x) >> _precision;
671     res += xi * 0x000000000000000000000082573a0a00; // add x^25 * (33! / 25!)
672     xi = (xi * _x) >> _precision;
673     res += xi * 0x000000000000000000000005035ad900; // add x^26 * (33! / 26!)
674     xi = (xi * _x) >> _precision;
675     res += xi * 0x0000000000000000000000002f881b00; // add x^27 * (33! / 27!)
676     xi = (xi * _x) >> _precision;
677     res += xi * 0x00000000000000000000000001b29340; // add x^28 * (33! / 28!)
678     xi = (xi * _x) >> _precision;
679     res += xi * 0x000000000000000000000000000efc40; // add x^29 * (33! / 29!)
680     xi = (xi * _x) >> _precision;
681     res += xi * 0x00000000000000000000000000007fe0; // add x^30 * (33! / 30!)
682     xi = (xi * _x) >> _precision;
683     res += xi * 0x00000000000000000000000000000420; // add x^31 * (33! / 31!)
684     xi = (xi * _x) >> _precision;
685     res += xi * 0x00000000000000000000000000000021; // add x^32 * (33! / 32!)
686     xi = (xi * _x) >> _precision;
687     res += xi * 0x00000000000000000000000000000001; // add x^33 * (33! / 33!)
688 
689     return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
690   }
691 }
692 
693 // File: ethberlin-master\contracts\tokens\BancorFormula.sol
694 
695 /**
696  * Bancor formula by Bancor
697  * https://github.com/bancorprotocol/contracts
698  * Modified from the original by Slava Balasanov
699  * Split Power.sol out from BancorFormula.sol and replace SafeMath formulas with zeppelin's SafeMath
700  * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
701  * and to You under the Apache License, Version 2.0. "
702  */
703 contract BancorFormula is Power {
704   using SafeMath for uint256;
705 
706   string public version = "0.3";
707   uint32 private constant MAX_WEIGHT = 1000000;
708 
709   /**
710     @dev given a token supply, connector balance, weight and a deposit amount (in the connector token),
711     calculates the return for a given conversion (in the main token)
712 
713     Formula:
714     Return = _supply * ((1 + _depositAmount / _connectorBalance) ^ (_connectorWeight / 1000000) - 1)
715 
716     @param _supply              token total supply
717     @param _connectorBalance    total connector balance
718     @param _connectorWeight     connector weight, represented in ppm, 1-1000000
719     @param _depositAmount       deposit amount, in connector token
720 
721     @return purchase return amount
722   */
723   function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256) {
724     // validate input
725     require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT);
726 
727     // special case for 0 deposit amount
728     if (_depositAmount == 0)
729       return 0;
730 
731     // special case if the weight = 100%
732     if (_connectorWeight == MAX_WEIGHT)
733       return _supply.mul(_depositAmount).div(_connectorBalance);
734 
735     uint256 result;
736     uint8 precision;
737     uint256 baseN = _depositAmount.add(_connectorBalance);
738     (result, precision) = power(baseN, _connectorBalance, _connectorWeight, MAX_WEIGHT);
739     uint256 temp = _supply.mul(result) >> precision;
740     return temp - _supply;
741   }
742 
743   /**
744     @dev given a token supply, connector balance, weight and a sell amount (in the main token),
745     calculates the return for a given conversion (in the connector token)
746 
747     Formula:
748     Return = _connectorBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_connectorWeight / 1000000)))
749 
750     @param _supply              token total supply
751     @param _connectorBalance    total connector
752     @param _connectorWeight     constant connector Weight, represented in ppm, 1-1000000
753     @param _sellAmount          sell amount, in the token itself
754 
755     @return sale return amount
756   */
757   function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256) {
758     // validate input
759     require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT && _sellAmount <= _supply);
760 
761     // special case for 0 sell amount
762     if (_sellAmount == 0)
763       return 0;
764 
765     // special case for selling the entire supply
766     if (_sellAmount == _supply)
767       return _connectorBalance;
768 
769     // special case if the weight = 100%
770     if (_connectorWeight == MAX_WEIGHT)
771       return _connectorBalance.mul(_sellAmount).div(_supply);
772 
773     uint256 result;
774     uint8 precision;
775     uint256 baseD = _supply - _sellAmount;
776     (result, precision) = power(_supply, baseD, MAX_WEIGHT, _connectorWeight);
777     uint256 temp1 = _connectorBalance.mul(result);
778     uint256 temp2 = _connectorBalance << precision;
779     return temp1.sub(temp2).div(result);
780   }
781 }
782 
783 // File: ethberlin-master\contracts\tokens\EthBondingCurve.sol
784 
785 /**
786  * @title Bonding Curve
787  * @dev Bonding curve contract based on Bacor formula
788  * inspired by bancor protocol and simondlr
789  * https://github.com/bancorprotocol/contracts
790  * https://github.com/ConsenSys/curationmarkets/blob/master/CurationMarkets.sol
791  */
792 contract EthBondingCurve is StandardToken, BancorFormula, Ownable {
793   uint256 public poolBalance;
794 
795   /*
796     reserve ratio, represented in ppm, 1-1000000
797     1/3 corresponds to y= multiple * x^2
798     1/2 corresponds to y= multiple * x
799     2/3 corresponds to y= multiple * x^1/2
800     multiple will depends on contract initialization,
801     specificallytotalAmount and poolBalance parameters
802     we might want to add an 'initialize' function that will allow
803     the owner to send ether to the contract and mint a given amount of tokens
804   */
805   uint32 public reserveRatio;
806 
807   /*
808     - Front-running attacks are currently mitigated by the following mechanisms:
809     TODO - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
810     - gas price limit prevents users from having control over the order of execution
811   */
812   uint256 public gasPrice = 0 wei; // maximum gas price for bancor transactions
813 
814   /**
815    * @dev default function
816    * gas ~ 91645
817    */
818   function() public payable {
819     buy();
820   }
821 
822   /**
823    * @dev Buy tokens
824    * gas ~ 77825
825    * TODO implement maxAmount that helps prevent miner front-running
826    */
827   function buy() validGasPrice public payable returns(bool) {
828     require(msg.value > 0);
829     uint256 tokensToMint = calculatePurchaseReturn(totalSupply_, poolBalance, reserveRatio, msg.value);
830     totalSupply_ = totalSupply_.add(tokensToMint);
831     balances[msg.sender] = balances[msg.sender].add(tokensToMint);
832     poolBalance = poolBalance.add(msg.value);
833     emit LogMint(msg.sender, tokensToMint, msg.value);
834     return true;
835   }
836 
837   /**
838    * @dev Sell tokens
839    * gas ~ 86936
840    * @param sellAmount Amount of tokens to withdraw
841    * TODO implement maxAmount that helps prevent miner front-running
842    */
843   function sell(uint256 sellAmount) validGasPrice public returns(bool) {
844     require(sellAmount > 0 && balances[msg.sender] >= sellAmount);
845     uint256 ethAmount = calculateSaleReturn(totalSupply_, poolBalance, reserveRatio, sellAmount);
846     msg.sender.transfer(ethAmount);
847     poolBalance = poolBalance.sub(ethAmount);
848     balances[msg.sender] = balances[msg.sender].sub(sellAmount);
849     totalSupply_ = totalSupply_.sub(sellAmount);
850     emit LogWithdraw(msg.sender, sellAmount, ethAmount);
851     return true;
852   }
853 
854   // verifies that the gas price is lower than the universal limit
855   modifier validGasPrice() {
856     assert(tx.gasprice <= gasPrice);
857     _;
858   }
859 
860   /**
861     @dev Allows the owner to update the gas price limit
862     @param _gasPrice The new gas price limit
863   */
864   function setGasPrice(uint256 _gasPrice) onlyOwner public {
865     require(_gasPrice > 0);
866     gasPrice = _gasPrice;
867   }
868 
869   event LogMint(address sender, uint256 amountMinted, uint256 totalCost);
870   event LogWithdraw(address sender, uint256 amountWithdrawn, uint256 reward);
871   event LogBondingCurve(address sender, string logString, uint256 value);
872 }
873 
874 // File: ethberlin-master\contracts\tokens\SoulToken.sol
875 
876 contract Trojan is EthBondingCurve {
877   string public constant name = "Trojan";
878   string public constant symbol = "TROJ";
879   uint8 public constant decimals = 18;
880 
881   uint256 public constant INITIAL_SUPPLY = 2000000 * (10 ** 18);
882   uint256 public constant INITIAL_PRICE = 39 * (10 ** 13);
883   uint32 public constant CURVE_RATIO = 500000;
884   uint256 public constant INITAL_BALANCE = CURVE_RATIO * INITIAL_SUPPLY * INITIAL_PRICE / (1000000 * 10 ** 18);
885 
886   constructor() public {
887     reserveRatio = CURVE_RATIO;
888     totalSupply_ = INITIAL_SUPPLY;
889     poolBalance = INITAL_BALANCE;
890     gasPrice = 26 * (10 ** 9);
891   }
892 }
1 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      * @notice Renouncing ownership will leave the contract without an owner,
119      * thereby removing any functionality that is only available to the owner.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
146 
147 pragma solidity ^0.5.2;
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://eips.ethereum.org/EIPS/eip-20
152  */
153 interface IERC20 {
154     function transfer(address to, uint256 value) external returns (bool);
155 
156     function approve(address spender, uint256 value) external returns (bool);
157 
158     function transferFrom(address from, address to, uint256 value) external returns (bool);
159 
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address who) external view returns (uint256);
163 
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
172 
173 pragma solidity ^0.5.2;
174 
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * https://eips.ethereum.org/EIPS/eip-20
182  * Originally based on code by FirstBlood:
183  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  *
185  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
186  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
187  * compliant implementations may not do it.
188  */
189 contract ERC20 is IERC20 {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) private _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowed;
195 
196     uint256 private _totalSupply;
197 
198     /**
199      * @dev Total number of tokens in existence
200      */
201     function totalSupply() public view returns (uint256) {
202         return _totalSupply;
203     }
204 
205     /**
206      * @dev Gets the balance of the specified address.
207      * @param owner The address to query the balance of.
208      * @return A uint256 representing the amount owned by the passed address.
209      */
210     function balanceOf(address owner) public view returns (uint256) {
211         return _balances[owner];
212     }
213 
214     /**
215      * @dev Function to check the amount of tokens that an owner allowed to a spender.
216      * @param owner address The address which owns the funds.
217      * @param spender address The address which will spend the funds.
218      * @return A uint256 specifying the amount of tokens still available for the spender.
219      */
220     function allowance(address owner, address spender) public view returns (uint256) {
221         return _allowed[owner][spender];
222     }
223 
224     /**
225      * @dev Transfer token to a specified address
226      * @param to The address to transfer to.
227      * @param value The amount to be transferred.
228      */
229     function transfer(address to, uint256 value) public returns (bool) {
230         _transfer(msg.sender, to, value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      * Beware that changing an allowance with this method brings the risk that someone may use both the old
237      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      * @param spender The address which will spend the funds.
241      * @param value The amount of tokens to be spent.
242      */
243     function approve(address spender, uint256 value) public returns (bool) {
244         _approve(msg.sender, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another.
250      * Note that while this function emits an Approval event, this is not required as per the specification,
251      * and other compliant implementations may not emit the event.
252      * @param from address The address which you want to send tokens from
253      * @param to address The address which you want to transfer to
254      * @param value uint256 the amount of tokens to be transferred
255      */
256     function transferFrom(address from, address to, uint256 value) public returns (bool) {
257         _transfer(from, to, value);
258         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
259         return true;
260     }
261 
262     /**
263      * @dev Increase the amount of tokens that an owner allowed to a spender.
264      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * Emits an Approval event.
269      * @param spender The address which will spend the funds.
270      * @param addedValue The amount of tokens to increase the allowance by.
271      */
272     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
273         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
274         return true;
275     }
276 
277     /**
278      * @dev Decrease the amount of tokens that an owner allowed to a spender.
279      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * Emits an Approval event.
284      * @param spender The address which will spend the funds.
285      * @param subtractedValue The amount of tokens to decrease the allowance by.
286      */
287     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
288         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
289         return true;
290     }
291 
292     /**
293      * @dev Transfer token for a specified addresses
294      * @param from The address to transfer from.
295      * @param to The address to transfer to.
296      * @param value The amount to be transferred.
297      */
298     function _transfer(address from, address to, uint256 value) internal {
299         require(to != address(0));
300 
301         _balances[from] = _balances[from].sub(value);
302         _balances[to] = _balances[to].add(value);
303         emit Transfer(from, to, value);
304     }
305 
306     /**
307      * @dev Internal function that mints an amount of the token and assigns it to
308      * an account. This encapsulates the modification of balances such that the
309      * proper events are emitted.
310      * @param account The account that will receive the created tokens.
311      * @param value The amount that will be created.
312      */
313     function _mint(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.add(value);
317         _balances[account] = _balances[account].add(value);
318         emit Transfer(address(0), account, value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account.
324      * @param account The account whose tokens will be burnt.
325      * @param value The amount that will be burnt.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0));
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Approve an address to spend another addresses' tokens.
337      * @param owner The address that owns the tokens.
338      * @param spender The address that will spend the tokens.
339      * @param value The number of tokens that can be spent.
340      */
341     function _approve(address owner, address spender, uint256 value) internal {
342         require(spender != address(0));
343         require(owner != address(0));
344 
345         _allowed[owner][spender] = value;
346         emit Approval(owner, spender, value);
347     }
348 
349     /**
350      * @dev Internal function that burns an amount of the token of a given
351      * account, deducting from the sender's allowance for said account. Uses the
352      * internal burn function.
353      * Emits an Approval event (reflecting the reduced allowance).
354      * @param account The account whose tokens will be burnt.
355      * @param value The amount that will be burnt.
356      */
357     function _burnFrom(address account, uint256 value) internal {
358         _burn(account, value);
359         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
360     }
361 }
362 
363 // File: contracts\Power.sol
364 
365 pragma solidity ^0.5.2;
366 
367 
368  /**
369  * @title Power function by Bancor
370  * @dev https://github.com/bancorprotocol/contracts
371  *
372  * Modified from the original by Slava Balasanov & Tarrence van As
373  *
374  * Split Power.sol out from BancorFormula.sol
375  * https://github.com/bancorprotocol/contracts/blob/c9adc95e82fdfb3a0ada102514beb8ae00147f5d/solidity/contracts/converter/BancorFormula.sol
376  *
377  * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
378  * and to You under the Apache License, Version 2.0. "
379  */
380 contract Power {
381   string public version = "0.3";
382 
383   uint256 private constant ONE = 1;
384   uint32 private constant MAX_WEIGHT = 1000000;
385   uint8 private constant MIN_PRECISION = 32;
386   uint8 private constant MAX_PRECISION = 127;
387 
388   /**
389     The values below depend on MAX_PRECISION. If you choose to change it:
390     Apply the same change in file 'PrintIntScalingFactors.py', run it and paste the results below.
391   */
392   uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
393   uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
394   uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;
395 
396   /**
397       Auto-generated via 'PrintLn2ScalingFactors.py'
398   */
399   uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
400   uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
401 
402   /**
403       Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'
404   */
405   uint256 private constant OPT_LOG_MAX_VAL =
406   0x15bf0a8b1457695355fb8ac404e7a79e3;
407   uint256 private constant OPT_EXP_MAX_VAL =
408   0x800000000000000000000000000000000;
409 
410   /**
411     The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
412     Apply the same change in file 'PrintFunctionBancorFormula.py', run it and paste the results below.
413   */
414   uint256[128] private maxExpArray;
415   constructor() public {
416 //  maxExpArray[0] = 0x6bffffffffffffffffffffffffffffffff;
417 //  maxExpArray[1] = 0x67ffffffffffffffffffffffffffffffff;
418 //  maxExpArray[2] = 0x637fffffffffffffffffffffffffffffff;
419 //  maxExpArray[3] = 0x5f6fffffffffffffffffffffffffffffff;
420 //  maxExpArray[4] = 0x5b77ffffffffffffffffffffffffffffff;
421 //  maxExpArray[5] = 0x57b3ffffffffffffffffffffffffffffff;
422 //  maxExpArray[6] = 0x5419ffffffffffffffffffffffffffffff;
423 //  maxExpArray[7] = 0x50a2ffffffffffffffffffffffffffffff;
424 //  maxExpArray[8] = 0x4d517fffffffffffffffffffffffffffff;
425 //  maxExpArray[9] = 0x4a233fffffffffffffffffffffffffffff;
426 //  maxExpArray[10] = 0x47165fffffffffffffffffffffffffffff;
427 //  maxExpArray[11] = 0x4429afffffffffffffffffffffffffffff;
428 //  maxExpArray[12] = 0x415bc7ffffffffffffffffffffffffffff;
429 //  maxExpArray[13] = 0x3eab73ffffffffffffffffffffffffffff;
430 //  maxExpArray[14] = 0x3c1771ffffffffffffffffffffffffffff;
431 //  maxExpArray[15] = 0x399e96ffffffffffffffffffffffffffff;
432 //  maxExpArray[16] = 0x373fc47fffffffffffffffffffffffffff;
433 //  maxExpArray[17] = 0x34f9e8ffffffffffffffffffffffffffff;
434 //  maxExpArray[18] = 0x32cbfd5fffffffffffffffffffffffffff;
435 //  maxExpArray[19] = 0x30b5057fffffffffffffffffffffffffff;
436 //  maxExpArray[20] = 0x2eb40f9fffffffffffffffffffffffffff;
437 //  maxExpArray[21] = 0x2cc8340fffffffffffffffffffffffffff;
438 //  maxExpArray[22] = 0x2af09481ffffffffffffffffffffffffff;
439 //  maxExpArray[23] = 0x292c5bddffffffffffffffffffffffffff;
440 //  maxExpArray[24] = 0x277abdcdffffffffffffffffffffffffff;
441 //  maxExpArray[25] = 0x25daf6657fffffffffffffffffffffffff;
442 //  maxExpArray[26] = 0x244c49c65fffffffffffffffffffffffff;
443 //  maxExpArray[27] = 0x22ce03cd5fffffffffffffffffffffffff;
444 //  maxExpArray[28] = 0x215f77c047ffffffffffffffffffffffff;
445 //  maxExpArray[29] = 0x1fffffffffffffffffffffffffffffffff;
446 //  maxExpArray[30] = 0x1eaefdbdabffffffffffffffffffffffff;
447 //  maxExpArray[31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
448     maxExpArray[32] = 0x1c35fedd14ffffffffffffffffffffffff;
449     maxExpArray[33] = 0x1b0ce43b323fffffffffffffffffffffff;
450     maxExpArray[34] = 0x19f0028ec1ffffffffffffffffffffffff;
451     maxExpArray[35] = 0x18ded91f0e7fffffffffffffffffffffff;
452     maxExpArray[36] = 0x17d8ec7f0417ffffffffffffffffffffff;
453     maxExpArray[37] = 0x16ddc6556cdbffffffffffffffffffffff;
454     maxExpArray[38] = 0x15ecf52776a1ffffffffffffffffffffff;
455     maxExpArray[39] = 0x15060c256cb2ffffffffffffffffffffff;
456     maxExpArray[40] = 0x1428a2f98d72ffffffffffffffffffffff;
457     maxExpArray[41] = 0x13545598e5c23fffffffffffffffffffff;
458     maxExpArray[42] = 0x1288c4161ce1dfffffffffffffffffffff;
459     maxExpArray[43] = 0x11c592761c666fffffffffffffffffffff;
460     maxExpArray[44] = 0x110a688680a757ffffffffffffffffffff;
461     maxExpArray[45] = 0x1056f1b5bedf77ffffffffffffffffffff;
462     maxExpArray[46] = 0x0faadceceeff8bffffffffffffffffffff;
463     maxExpArray[47] = 0x0f05dc6b27edadffffffffffffffffffff;
464     maxExpArray[48] = 0x0e67a5a25da4107fffffffffffffffffff;
465     maxExpArray[49] = 0x0dcff115b14eedffffffffffffffffffff;
466     maxExpArray[50] = 0x0d3e7a392431239fffffffffffffffffff;
467     maxExpArray[51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
468     maxExpArray[52] = 0x0c2d415c3db974afffffffffffffffffff;
469     maxExpArray[53] = 0x0bad03e7d883f69bffffffffffffffffff;
470     maxExpArray[54] = 0x0b320d03b2c343d5ffffffffffffffffff;
471     maxExpArray[55] = 0x0abc25204e02828dffffffffffffffffff;
472     maxExpArray[56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
473     maxExpArray[57] = 0x09deaf736ac1f569ffffffffffffffffff;
474     maxExpArray[58] = 0x0976bd9952c7aa957fffffffffffffffff;
475     maxExpArray[59] = 0x09131271922eaa606fffffffffffffffff;
476     maxExpArray[60] = 0x08b380f3558668c46fffffffffffffffff;
477     maxExpArray[61] = 0x0857ddf0117efa215bffffffffffffffff;
478     maxExpArray[62] = 0x07ffffffffffffffffffffffffffffffff;
479     maxExpArray[63] = 0x07abbf6f6abb9d087fffffffffffffffff;
480     maxExpArray[64] = 0x075af62cbac95f7dfa7fffffffffffffff;
481     maxExpArray[65] = 0x070d7fb7452e187ac13fffffffffffffff;
482     maxExpArray[66] = 0x06c3390ecc8af379295fffffffffffffff;
483     maxExpArray[67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
484     maxExpArray[68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
485     maxExpArray[69] = 0x05f63b1fc104dbd39587ffffffffffffff;
486     maxExpArray[70] = 0x05b771955b36e12f7235ffffffffffffff;
487     maxExpArray[71] = 0x057b3d49dda84556d6f6ffffffffffffff;
488     maxExpArray[72] = 0x054183095b2c8ececf30ffffffffffffff;
489     maxExpArray[73] = 0x050a28be635ca2b888f77fffffffffffff;
490     maxExpArray[74] = 0x04d5156639708c9db33c3fffffffffffff;
491     maxExpArray[75] = 0x04a23105873875bd52dfdfffffffffffff;
492     maxExpArray[76] = 0x0471649d87199aa990756fffffffffffff;
493     maxExpArray[77] = 0x04429a21a029d4c1457cfbffffffffffff;
494     maxExpArray[78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
495     maxExpArray[79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
496     maxExpArray[80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
497     maxExpArray[81] = 0x0399e96897690418f785257fffffffffff;
498     maxExpArray[82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
499     maxExpArray[83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
500     maxExpArray[84] = 0x032cbfd4a7adc790560b3337ffffffffff;
501     maxExpArray[85] = 0x030b50570f6e5d2acca94613ffffffffff;
502     maxExpArray[86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
503     maxExpArray[87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
504     maxExpArray[88] = 0x02af09481380a0a35cf1ba02ffffffffff;
505     maxExpArray[89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
506     maxExpArray[90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
507     maxExpArray[91] = 0x025daf6654b1eaa55fd64df5efffffffff;
508     maxExpArray[92] = 0x0244c49c648baa98192dce88b7ffffffff;
509     maxExpArray[93] = 0x022ce03cd5619a311b2471268bffffffff;
510     maxExpArray[94] = 0x0215f77c045fbe885654a44a0fffffffff;
511     maxExpArray[95] = 0x01ffffffffffffffffffffffffffffffff;
512     maxExpArray[96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
513     maxExpArray[97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
514     maxExpArray[98] = 0x01c35fedd14b861eb0443f7f133fffffff;
515     maxExpArray[99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
516     maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
517     maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
518     maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
519     maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
520     maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
521     maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
522     maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
523     maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
524     maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
525     maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
526     maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
527     maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
528     maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
529     maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
530     maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
531     maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
532     maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
533     maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
534     maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
535     maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
536     maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
537     maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
538     maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
539     maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
540     maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
541     maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
542     maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
543     maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
544   }
545 
546   /**
547     General Description:
548         Determine a value of precision.
549         Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
550         Return the result along with the precision used.
551      Detailed Description:
552         Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
553         The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
554         The larger "precision" is, the more accurately this value represents the real value.
555         However, the larger "precision" is, the more bits are required in order to store this value.
556         And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
557         This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
558         Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
559         This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
560         This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
561   */
562   function power(
563     uint256 _baseN,
564     uint256 _baseD,
565     uint32 _expN,
566     uint32 _expD
567   ) internal view returns (uint256, uint8)
568   {
569     require(_baseN < MAX_NUM, "baseN exceeds max value.");
570     require(_baseN >= _baseD, "Bases < 1 are not supported.");
571 
572     uint256 baseLog;
573     uint256 base = _baseN * FIXED_1 / _baseD;
574     if (base < OPT_LOG_MAX_VAL) {
575       baseLog = optimalLog(base);
576     } else {
577       baseLog = generalLog(base);
578     }
579 
580     uint256 baseLogTimesExp = baseLog * _expN / _expD;
581     if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
582       return (optimalExp(baseLogTimesExp), MAX_PRECISION);
583     } else {
584       uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
585       return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
586     }
587   }
588 
589   /**
590       Compute log(x / FIXED_1) * FIXED_1.
591       This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
592   */
593   function generalLog(uint256 _x) internal pure returns (uint256) {
594     uint256 res = 0;
595     uint256 x = _x;
596 
597     // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
598     if (x >= FIXED_2) {
599       uint8 count = floorLog2(x / FIXED_1);
600       x >>= count; // now x < 2
601       res = count * FIXED_1;
602     }
603 
604     // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
605     if (x > FIXED_1) {
606       for (uint8 i = MAX_PRECISION; i > 0; --i) {
607         x = (x * x) / FIXED_1; // now 1 < x < 4
608         if (x >= FIXED_2) {
609           x >>= 1; // now 1 < x < 2
610           res += ONE << (i - 1);
611         }
612       }
613     }
614 
615     return res * LN2_NUMERATOR / LN2_DENOMINATOR;
616   }
617 
618   /**
619     Compute the largest integer smaller than or equal to the binary logarithm of the input.
620   */
621   function floorLog2(uint256 _n) internal pure returns (uint8) {
622     uint8 res = 0;
623     uint256 n = _n;
624 
625     if (n < 256) {
626       // At most 8 iterations
627       while (n > 1) {
628         n >>= 1;
629         res += 1;
630       }
631     } else {
632       // Exactly 8 iterations
633       for (uint8 s = 128; s > 0; s >>= 1) {
634         if (n >= (ONE << s)) {
635           n >>= s;
636           res |= s;
637         }
638       }
639     }
640 
641     return res;
642   }
643 
644   /**
645       The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
646       - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
647       - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
648   */
649   function findPositionInMaxExpArray(uint256 _x)
650   internal view returns (uint8)
651   {
652     uint8 lo = MIN_PRECISION;
653     uint8 hi = MAX_PRECISION;
654 
655     while (lo + 1 < hi) {
656       uint8 mid = (lo + hi) / 2;
657       if (maxExpArray[mid] >= _x)
658         lo = mid;
659       else
660         hi = mid;
661     }
662 
663     if (maxExpArray[hi] >= _x)
664       return hi;
665     if (maxExpArray[lo] >= _x)
666       return lo;
667 
668     assert(false);
669     return 0;
670   }
671 
672   /* solium-disable */
673   /**
674        This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
675        It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
676        It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
677        The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
678        The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
679    */
680    function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
681        uint256 xi = _x;
682        uint256 res = 0;
683 
684        xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
685        xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
686        xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
687        xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
688        xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
689        xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
690        xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
691        xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
692        xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
693        xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
694        xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
695        xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
696        xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
697        xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
698        xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
699        xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
700        xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
701        xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
702        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
703        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
704        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
705        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
706        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
707        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
708        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
709        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
710        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
711        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
712        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
713        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
714        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
715        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
716 
717        return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
718    }
719 
720    /**
721        Return log(x / FIXED_1) * FIXED_1
722        Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
723        Auto-generated via 'PrintFunctionOptimalLog.py'
724    */
725    function optimalLog(uint256 x) internal pure returns (uint256) {
726        uint256 res = 0;
727 
728        uint256 y;
729        uint256 z;
730        uint256 w;
731 
732        if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;}
733        if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;}
734        if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;}
735        if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;}
736        if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;}
737        if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;}
738        if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;}
739        if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;}
740 
741        z = y = x - FIXED_1;
742        w = y * y / FIXED_1;
743        res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1;
744        res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1;
745        res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1;
746        res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1;
747        res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1;
748        res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1;
749        res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1;
750        res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;
751 
752        return res;
753    }
754 
755    /**
756        Return e ^ (x / FIXED_1) * FIXED_1
757        Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
758        Auto-generated via 'PrintFunctionOptimalExp.py'
759    */
760    function optimalExp(uint256 x) internal pure returns (uint256) {
761        uint256 res = 0;
762 
763        uint256 y;
764        uint256 z;
765 
766        z = y = x % 0x10000000000000000000000000000000;
767        z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
768        z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
769        z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
770        z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
771        z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
772        z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
773        z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
774        z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
775        z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
776        z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
777        z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
778        z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
779        z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
780        z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
781        z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
782        z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
783        z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
784        z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
785        z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
786        res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
787 
788        if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776;
789        if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4;
790        if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f;
791        if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9;
792        if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea;
793        if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d;
794        if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11;
795 
796        return res;
797    }
798    /* solium-enable */
799 }
800 
801 // File: contracts\BancorBondingCurve.sol
802 
803 pragma solidity ^0.5.2;
804 
805 
806 
807 /**
808 * @title Bancor formula by Bancor
809 *
810 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
811 * and to You under the Apache License, Version 2.0. "
812 */
813 contract BancorBondingCurve is Power {
814    using SafeMath for uint256;
815    uint32 private constant MAX_RESERVE_RATIO = 1000000;
816 
817    /**
818    * @dev given a continuous token supply, reserve token balance, reserve ratio, and a deposit amount (in the reserve token),
819    * calculates the return for a given conversion (in the continuous token)
820    *
821    * Formula:
822    * Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / MAX_RESERVE_RATIO) - 1)
823    *
824    * @param _supply              continuous token total supply
825    * @param _reserveBalance    total reserve token balance
826    * @param _reserveRatio     reserve ratio, represented in ppm, 1-1000000
827    * @param _depositAmount       deposit amount, in reserve token
828    *
829    *  @return purchase return amount
830   */
831   function calculatePurchaseReturn(
832     uint256 _supply,
833     uint256 _reserveBalance,
834     uint32 _reserveRatio,
835     uint256 _depositAmount) public view returns (uint256)
836   {
837     // validate input
838     require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_RESERVE_RATIO);
839      // special case for 0 deposit amount
840     if (_depositAmount == 0) {
841       return 0;
842     }
843      // special case if the ratio = 100%
844     if (_reserveRatio == MAX_RESERVE_RATIO) {
845       return _supply.mul(_depositAmount).div(_reserveBalance);
846     }
847      uint256 result;
848     uint8 precision;
849     uint256 baseN = _depositAmount.add(_reserveBalance);
850     (result, precision) = power(
851       baseN, _reserveBalance, _reserveRatio, MAX_RESERVE_RATIO
852     );
853     uint256 newTokenSupply = _supply.mul(result) >> precision;
854     return newTokenSupply - _supply;
855   }
856    /**
857    * @dev given a continuous token supply, reserve token balance, reserve ratio and a sell amount (in the continuous token),
858    * calculates the return for a given conversion (in the reserve token)
859    *
860    * Formula:
861    * Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / MAX_RESERVE_RATIO)))
862    *
863    * @param _supply              continuous token total supply
864    * @param _reserveBalance    total reserve token balance
865    * @param _reserveRatio     constant reserve ratio, represented in ppm, 1-1000000
866    * @param _sellAmount          sell amount, in the continuous token itself
867    *
868    * @return sale return amount
869   */
870   function calculateSaleReturn(
871     uint256 _supply,
872     uint256 _reserveBalance,
873     uint32 _reserveRatio,
874     uint256 _sellAmount) public view returns (uint256)
875   {
876     // validate input
877     require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_RESERVE_RATIO && _sellAmount <= _supply);
878      // special case for 0 sell amount
879     if (_sellAmount == 0) {
880       return 0;
881     }
882      // special case for selling the entire supply
883     if (_sellAmount == _supply) {
884       return _reserveBalance;
885     }
886      // special case if the ratio = 100%
887     if (_reserveRatio == MAX_RESERVE_RATIO) {
888       return _reserveBalance.mul(_sellAmount).div(_supply);
889     }
890      uint256 result;
891     uint8 precision;
892     uint256 baseD = _supply - _sellAmount;
893     (result, precision) = power(
894       _supply, baseD, MAX_RESERVE_RATIO, _reserveRatio
895     );
896     uint256 oldBalance = _reserveBalance.mul(result);
897     uint256 newBalance = _reserveBalance << precision;
898     return oldBalance.sub(newBalance).div(result);
899   }
900 }
901 
902 // File: contracts\ContinuousToken.sol
903 
904 pragma solidity ^0.5.2;
905 
906 
907 
908 
909 
910 contract ContinuousToken is BancorBondingCurve, Ownable, ERC20 {
911     
912     using SafeMath for uint256;
913 
914     uint256 public scale = 10**18;
915     uint256 public reserveBalance = 10*scale;
916     uint256 public reserveRatio = 500000;
917 
918     constructor() public {
919         _mint(msg.sender, 1*scale);
920     }
921 
922     function mint(address reciever, uint value) public payable {
923         require(value > 0, "Must send ether to buy tokens.");
924         _continuousMint(reciever, value);
925     }
926 
927     function burn(uint256 _amount) public {
928         uint256 returnAmount = _continuousBurn(_amount);
929         msg.sender.transfer(returnAmount);
930     }
931 
932     function calculateContinuousMintReturn(uint256 _amount)
933         public view returns (uint256 mintAmount)
934     {
935         return calculatePurchaseReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
936     }
937 
938     function calculateContinuousBurnReturn(uint256 _amount)
939         public view returns (uint256 burnAmount)
940     {
941         return calculateSaleReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
942     }
943 
944     function _continuousMint(address reciever, uint value)
945         internal returns (uint256)
946     {
947         require(value > 0, "Deposit must be non-zero.");
948 
949         uint256 amount = calculateContinuousMintReturn(value);
950         _mint(reciever, amount);
951         reserveBalance = reserveBalance.add(value);
952         return amount;
953     }
954 
955     function _continuousBurn(uint256 _amount)
956         internal returns (uint256)
957     {
958         require(_amount > 0, "Amount must be non-zero.");
959         require(balanceOf(msg.sender) >= _amount, "Insufficient tokens to burn.");
960 
961         uint256 reimburseAmount = calculateContinuousBurnReturn(_amount);
962         reserveBalance = reserveBalance.sub(reimburseAmount);
963         _burn(msg.sender, _amount);
964         return reimburseAmount;
965     }
966 }
967 
968 // File: contracts\SpaceMiners.sol
969 
970 pragma solidity ^0.5.2;
971 
972 // GAME
973 
974 
975 
976 // TOKEN
977 
978 
979 contract SpaceMiners is Ownable, ContinuousToken {
980 
981   using SafeMath for uint;
982 
983   uint public constant PRICE_TO_MINE = 20 finney;
984   uint public constant PLANET_CAPACITY = 10;
985   uint public constant NUM_WINNERS = 3;
986   uint constant OWNER_FEE_PERCENT = 5;
987   address[] miners = new address[](PLANET_CAPACITY);
988   uint public planetPopulation = 0;
989   uint ownerHoldings = 1;
990 
991   string public constant name = "Kerium Crystals";
992   string public constant symbol = "KMC";
993   uint8 public constant decimals = 18;
994 
995   function getNumUsersMinersOnPlanet(address miner) public view returns (uint) {
996     uint count = 0;
997     for (uint i = 0; i < planetPopulation; i++) {
998       if (miners[i] == miner) {
999         count++;
1000       }
1001     }
1002     return count;
1003   }
1004 
1005   function sendSingleMinerToPlanet(address miner) internal {
1006     miners[planetPopulation] = miner;
1007     planetPopulation = planetPopulation.add(1);
1008     if (planetPopulation == PLANET_CAPACITY) {
1009       rewardMiners();
1010       planetPopulation = 0;
1011     }
1012   }
1013 
1014   function sendMinersToPlanet(uint numMiners) public payable {
1015     require(msg.value >= numMiners * PRICE_TO_MINE, "Not enough paid");
1016     require(planetPopulation < PLANET_CAPACITY, "Planet is full");
1017     mint(msg.sender, numMiners);
1018     for (uint i = 0; i < numMiners; i++) {
1019       sendSingleMinerToPlanet(msg.sender);
1020     }
1021   }
1022 
1023   function percentOfValue(uint percent, uint value) pure internal returns (uint) {
1024     return (value.mul(percent)).div(100);
1025   }
1026 
1027   function getRandom(uint cap) view internal returns (uint) {
1028     return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % cap;
1029   }
1030 
1031   function rewardMiners() internal {
1032     // First take OWNER_FEE_PERCENT
1033     uint roundEarnings = PRICE_TO_MINE * PLANET_CAPACITY;
1034     uint ownerFee = percentOfValue(OWNER_FEE_PERCENT, roundEarnings);
1035     ownerHoldings = ownerHoldings.add(ownerFee);
1036     roundEarnings = roundEarnings.sub(ownerFee);
1037     uint rewardAmount = roundEarnings.div(NUM_WINNERS);
1038     for (uint i = 0; i < NUM_WINNERS; i++) {
1039       uint rnd = getRandom(PLANET_CAPACITY);
1040       mint(miners[rnd], rewardAmount);
1041     }
1042   }
1043 
1044   function cashOutOwnerFee() public payable onlyOwner {
1045     require(ownerHoldings > 1);
1046     msg.sender.transfer(ownerHoldings - 1);
1047     ownerHoldings = 1;
1048   }
1049 
1050   function() external payable {}
1051 
1052 }
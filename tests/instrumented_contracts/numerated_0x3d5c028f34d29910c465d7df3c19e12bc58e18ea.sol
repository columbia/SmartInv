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
171 
172 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
173 
174 pragma solidity ^0.5.2;
175 
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://eips.ethereum.org/EIPS/eip-20
183  * Originally based on code by FirstBlood:
184  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  *
186  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
187  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
188  * compliant implementations may not do it.
189  */
190 contract ERC20 is IERC20 {
191     using SafeMath for uint256;
192 
193     mapping (address => uint256) private _balances;
194 
195     mapping (address => mapping (address => uint256)) private _allowed;
196 
197     uint256 private _totalSupply;
198 
199     /**
200      * @dev Total number of tokens in existence
201      */
202     function totalSupply() public view returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207      * @dev Gets the balance of the specified address.
208      * @param owner The address to query the balance of.
209      * @return A uint256 representing the amount owned by the passed address.
210      */
211     function balanceOf(address owner) public view returns (uint256) {
212         return _balances[owner];
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param owner address The address which owns the funds.
218      * @param spender address The address which will spend the funds.
219      * @return A uint256 specifying the amount of tokens still available for the spender.
220      */
221     function allowance(address owner, address spender) public view returns (uint256) {
222         return _allowed[owner][spender];
223     }
224 
225     /**
226      * @dev Transfer token to a specified address
227      * @param to The address to transfer to.
228      * @param value The amount to be transferred.
229      */
230     function transfer(address to, uint256 value) public returns (bool) {
231         _transfer(msg.sender, to, value);
232         return true;
233     }
234 
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237      * Beware that changing an allowance with this method brings the risk that someone may use both the old
238      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      * @param spender The address which will spend the funds.
242      * @param value The amount of tokens to be spent.
243      */
244     function approve(address spender, uint256 value) public returns (bool) {
245         _approve(msg.sender, spender, value);
246         return true;
247     }
248 
249     /**
250      * @dev Transfer tokens from one address to another.
251      * Note that while this function emits an Approval event, this is not required as per the specification,
252      * and other compliant implementations may not emit the event.
253      * @param from address The address which you want to send tokens from
254      * @param to address The address which you want to transfer to
255      * @param value uint256 the amount of tokens to be transferred
256      */
257     function transferFrom(address from, address to, uint256 value) public returns (bool) {
258         _transfer(from, to, value);
259         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
260         return true;
261     }
262 
263     /**
264      * @dev Increase the amount of tokens that an owner allowed to a spender.
265      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * Emits an Approval event.
270      * @param spender The address which will spend the funds.
271      * @param addedValue The amount of tokens to increase the allowance by.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
275         return true;
276     }
277 
278     /**
279      * @dev Decrease the amount of tokens that an owner allowed to a spender.
280      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
281      * allowed value is better to use this function to avoid 2 calls (and wait until
282      * the first transaction is mined)
283      * From MonolithDAO Token.sol
284      * Emits an Approval event.
285      * @param spender The address which will spend the funds.
286      * @param subtractedValue The amount of tokens to decrease the allowance by.
287      */
288     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
289         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
290         return true;
291     }
292 
293     /**
294      * @dev Transfer token for a specified addresses
295      * @param from The address to transfer from.
296      * @param to The address to transfer to.
297      * @param value The amount to be transferred.
298      */
299     function _transfer(address from, address to, uint256 value) internal {
300         require(to != address(0));
301 
302         _balances[from] = _balances[from].sub(value);
303         _balances[to] = _balances[to].add(value);
304         emit Transfer(from, to, value);
305     }
306 
307     /**
308      * @dev Internal function that mints an amount of the token and assigns it to
309      * an account. This encapsulates the modification of balances such that the
310      * proper events are emitted.
311      * @param account The account that will receive the created tokens.
312      * @param value The amount that will be created.
313      */
314     function _mint(address account, uint256 value) internal {
315         require(account != address(0));
316 
317         _totalSupply = _totalSupply.add(value);
318         _balances[account] = _balances[account].add(value);
319         emit Transfer(address(0), account, value);
320     }
321 
322     /**
323      * @dev Internal function that burns an amount of the token of a given
324      * account.
325      * @param account The account whose tokens will be burnt.
326      * @param value The amount that will be burnt.
327      */
328     function _burn(address account, uint256 value) internal {
329         require(account != address(0));
330 
331         _totalSupply = _totalSupply.sub(value);
332         _balances[account] = _balances[account].sub(value);
333         emit Transfer(account, address(0), value);
334     }
335 
336     /**
337      * @dev Approve an address to spend another addresses' tokens.
338      * @param owner The address that owns the tokens.
339      * @param spender The address that will spend the tokens.
340      * @param value The number of tokens that can be spent.
341      */
342     function _approve(address owner, address spender, uint256 value) internal {
343         require(spender != address(0));
344         require(owner != address(0));
345 
346         _allowed[owner][spender] = value;
347         emit Approval(owner, spender, value);
348     }
349 
350     /**
351      * @dev Internal function that burns an amount of the token of a given
352      * account, deducting from the sender's allowance for said account. Uses the
353      * internal burn function.
354      * Emits an Approval event (reflecting the reduced allowance).
355      * @param account The account whose tokens will be burnt.
356      * @param value The amount that will be burnt.
357      */
358     function _burnFrom(address account, uint256 value) internal {
359         _burn(account, value);
360         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
361     }
362 }
363 
364 // File: contracts\Power.sol
365 
366 pragma solidity ^0.5.2;
367 
368 
369  /**
370  * @title Power function by Bancor
371  * @dev https://github.com/bancorprotocol/contracts
372  *
373  * Modified from the original by Slava Balasanov & Tarrence van As
374  *
375  * Split Power.sol out from BancorFormula.sol
376  * https://github.com/bancorprotocol/contracts/blob/c9adc95e82fdfb3a0ada102514beb8ae00147f5d/solidity/contracts/converter/BancorFormula.sol
377  *
378  * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
379  * and to You under the Apache License, Version 2.0. "
380  */
381 contract Power {
382   string public version = "0.3";
383 
384   uint256 private constant ONE = 1;
385   uint32 private constant MAX_WEIGHT = 1000000;
386   uint8 private constant MIN_PRECISION = 32;
387   uint8 private constant MAX_PRECISION = 127;
388 
389   /**
390     The values below depend on MAX_PRECISION. If you choose to change it:
391     Apply the same change in file 'PrintIntScalingFactors.py', run it and paste the results below.
392   */
393   uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
394   uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
395   uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;
396 
397   /**
398       Auto-generated via 'PrintLn2ScalingFactors.py'
399   */
400   uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
401   uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
402 
403   /**
404       Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'
405   */
406   uint256 private constant OPT_LOG_MAX_VAL =
407   0x15bf0a8b1457695355fb8ac404e7a79e3;
408   uint256 private constant OPT_EXP_MAX_VAL =
409   0x800000000000000000000000000000000;
410 
411   /**
412     The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
413     Apply the same change in file 'PrintFunctionBancorFormula.py', run it and paste the results below.
414   */
415   uint256[128] private maxExpArray;
416   constructor() public {
417 //  maxExpArray[0] = 0x6bffffffffffffffffffffffffffffffff;
418 //  maxExpArray[1] = 0x67ffffffffffffffffffffffffffffffff;
419 //  maxExpArray[2] = 0x637fffffffffffffffffffffffffffffff;
420 //  maxExpArray[3] = 0x5f6fffffffffffffffffffffffffffffff;
421 //  maxExpArray[4] = 0x5b77ffffffffffffffffffffffffffffff;
422 //  maxExpArray[5] = 0x57b3ffffffffffffffffffffffffffffff;
423 //  maxExpArray[6] = 0x5419ffffffffffffffffffffffffffffff;
424 //  maxExpArray[7] = 0x50a2ffffffffffffffffffffffffffffff;
425 //  maxExpArray[8] = 0x4d517fffffffffffffffffffffffffffff;
426 //  maxExpArray[9] = 0x4a233fffffffffffffffffffffffffffff;
427 //  maxExpArray[10] = 0x47165fffffffffffffffffffffffffffff;
428 //  maxExpArray[11] = 0x4429afffffffffffffffffffffffffffff;
429 //  maxExpArray[12] = 0x415bc7ffffffffffffffffffffffffffff;
430 //  maxExpArray[13] = 0x3eab73ffffffffffffffffffffffffffff;
431 //  maxExpArray[14] = 0x3c1771ffffffffffffffffffffffffffff;
432 //  maxExpArray[15] = 0x399e96ffffffffffffffffffffffffffff;
433 //  maxExpArray[16] = 0x373fc47fffffffffffffffffffffffffff;
434 //  maxExpArray[17] = 0x34f9e8ffffffffffffffffffffffffffff;
435 //  maxExpArray[18] = 0x32cbfd5fffffffffffffffffffffffffff;
436 //  maxExpArray[19] = 0x30b5057fffffffffffffffffffffffffff;
437 //  maxExpArray[20] = 0x2eb40f9fffffffffffffffffffffffffff;
438 //  maxExpArray[21] = 0x2cc8340fffffffffffffffffffffffffff;
439 //  maxExpArray[22] = 0x2af09481ffffffffffffffffffffffffff;
440 //  maxExpArray[23] = 0x292c5bddffffffffffffffffffffffffff;
441 //  maxExpArray[24] = 0x277abdcdffffffffffffffffffffffffff;
442 //  maxExpArray[25] = 0x25daf6657fffffffffffffffffffffffff;
443 //  maxExpArray[26] = 0x244c49c65fffffffffffffffffffffffff;
444 //  maxExpArray[27] = 0x22ce03cd5fffffffffffffffffffffffff;
445 //  maxExpArray[28] = 0x215f77c047ffffffffffffffffffffffff;
446 //  maxExpArray[29] = 0x1fffffffffffffffffffffffffffffffff;
447 //  maxExpArray[30] = 0x1eaefdbdabffffffffffffffffffffffff;
448 //  maxExpArray[31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
449     maxExpArray[32] = 0x1c35fedd14ffffffffffffffffffffffff;
450     maxExpArray[33] = 0x1b0ce43b323fffffffffffffffffffffff;
451     maxExpArray[34] = 0x19f0028ec1ffffffffffffffffffffffff;
452     maxExpArray[35] = 0x18ded91f0e7fffffffffffffffffffffff;
453     maxExpArray[36] = 0x17d8ec7f0417ffffffffffffffffffffff;
454     maxExpArray[37] = 0x16ddc6556cdbffffffffffffffffffffff;
455     maxExpArray[38] = 0x15ecf52776a1ffffffffffffffffffffff;
456     maxExpArray[39] = 0x15060c256cb2ffffffffffffffffffffff;
457     maxExpArray[40] = 0x1428a2f98d72ffffffffffffffffffffff;
458     maxExpArray[41] = 0x13545598e5c23fffffffffffffffffffff;
459     maxExpArray[42] = 0x1288c4161ce1dfffffffffffffffffffff;
460     maxExpArray[43] = 0x11c592761c666fffffffffffffffffffff;
461     maxExpArray[44] = 0x110a688680a757ffffffffffffffffffff;
462     maxExpArray[45] = 0x1056f1b5bedf77ffffffffffffffffffff;
463     maxExpArray[46] = 0x0faadceceeff8bffffffffffffffffffff;
464     maxExpArray[47] = 0x0f05dc6b27edadffffffffffffffffffff;
465     maxExpArray[48] = 0x0e67a5a25da4107fffffffffffffffffff;
466     maxExpArray[49] = 0x0dcff115b14eedffffffffffffffffffff;
467     maxExpArray[50] = 0x0d3e7a392431239fffffffffffffffffff;
468     maxExpArray[51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
469     maxExpArray[52] = 0x0c2d415c3db974afffffffffffffffffff;
470     maxExpArray[53] = 0x0bad03e7d883f69bffffffffffffffffff;
471     maxExpArray[54] = 0x0b320d03b2c343d5ffffffffffffffffff;
472     maxExpArray[55] = 0x0abc25204e02828dffffffffffffffffff;
473     maxExpArray[56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
474     maxExpArray[57] = 0x09deaf736ac1f569ffffffffffffffffff;
475     maxExpArray[58] = 0x0976bd9952c7aa957fffffffffffffffff;
476     maxExpArray[59] = 0x09131271922eaa606fffffffffffffffff;
477     maxExpArray[60] = 0x08b380f3558668c46fffffffffffffffff;
478     maxExpArray[61] = 0x0857ddf0117efa215bffffffffffffffff;
479     maxExpArray[62] = 0x07ffffffffffffffffffffffffffffffff;
480     maxExpArray[63] = 0x07abbf6f6abb9d087fffffffffffffffff;
481     maxExpArray[64] = 0x075af62cbac95f7dfa7fffffffffffffff;
482     maxExpArray[65] = 0x070d7fb7452e187ac13fffffffffffffff;
483     maxExpArray[66] = 0x06c3390ecc8af379295fffffffffffffff;
484     maxExpArray[67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
485     maxExpArray[68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
486     maxExpArray[69] = 0x05f63b1fc104dbd39587ffffffffffffff;
487     maxExpArray[70] = 0x05b771955b36e12f7235ffffffffffffff;
488     maxExpArray[71] = 0x057b3d49dda84556d6f6ffffffffffffff;
489     maxExpArray[72] = 0x054183095b2c8ececf30ffffffffffffff;
490     maxExpArray[73] = 0x050a28be635ca2b888f77fffffffffffff;
491     maxExpArray[74] = 0x04d5156639708c9db33c3fffffffffffff;
492     maxExpArray[75] = 0x04a23105873875bd52dfdfffffffffffff;
493     maxExpArray[76] = 0x0471649d87199aa990756fffffffffffff;
494     maxExpArray[77] = 0x04429a21a029d4c1457cfbffffffffffff;
495     maxExpArray[78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
496     maxExpArray[79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
497     maxExpArray[80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
498     maxExpArray[81] = 0x0399e96897690418f785257fffffffffff;
499     maxExpArray[82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
500     maxExpArray[83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
501     maxExpArray[84] = 0x032cbfd4a7adc790560b3337ffffffffff;
502     maxExpArray[85] = 0x030b50570f6e5d2acca94613ffffffffff;
503     maxExpArray[86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
504     maxExpArray[87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
505     maxExpArray[88] = 0x02af09481380a0a35cf1ba02ffffffffff;
506     maxExpArray[89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
507     maxExpArray[90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
508     maxExpArray[91] = 0x025daf6654b1eaa55fd64df5efffffffff;
509     maxExpArray[92] = 0x0244c49c648baa98192dce88b7ffffffff;
510     maxExpArray[93] = 0x022ce03cd5619a311b2471268bffffffff;
511     maxExpArray[94] = 0x0215f77c045fbe885654a44a0fffffffff;
512     maxExpArray[95] = 0x01ffffffffffffffffffffffffffffffff;
513     maxExpArray[96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
514     maxExpArray[97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
515     maxExpArray[98] = 0x01c35fedd14b861eb0443f7f133fffffff;
516     maxExpArray[99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
517     maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
518     maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
519     maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
520     maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
521     maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
522     maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
523     maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
524     maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
525     maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
526     maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
527     maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
528     maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
529     maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
530     maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
531     maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
532     maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
533     maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
534     maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
535     maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
536     maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
537     maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
538     maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
539     maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
540     maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
541     maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
542     maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
543     maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
544     maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
545   }
546 
547   /**
548     General Description:
549         Determine a value of precision.
550         Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
551         Return the result along with the precision used.
552      Detailed Description:
553         Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
554         The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
555         The larger "precision" is, the more accurately this value represents the real value.
556         However, the larger "precision" is, the more bits are required in order to store this value.
557         And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
558         This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
559         Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
560         This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
561         This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
562   */
563   function power(
564     uint256 _baseN,
565     uint256 _baseD,
566     uint32 _expN,
567     uint32 _expD
568   ) internal view returns (uint256, uint8)
569   {
570     require(_baseN < MAX_NUM, "baseN exceeds max value.");
571     require(_baseN >= _baseD, "Bases < 1 are not supported.");
572 
573     uint256 baseLog;
574     uint256 base = _baseN * FIXED_1 / _baseD;
575     if (base < OPT_LOG_MAX_VAL) {
576       baseLog = optimalLog(base);
577     } else {
578       baseLog = generalLog(base);
579     }
580 
581     uint256 baseLogTimesExp = baseLog * _expN / _expD;
582     if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
583       return (optimalExp(baseLogTimesExp), MAX_PRECISION);
584     } else {
585       uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
586       return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
587     }
588   }
589 
590   /**
591       Compute log(x / FIXED_1) * FIXED_1.
592       This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
593   */
594   function generalLog(uint256 _x) internal pure returns (uint256) {
595     uint256 res = 0;
596     uint256 x = _x;
597 
598     // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
599     if (x >= FIXED_2) {
600       uint8 count = floorLog2(x / FIXED_1);
601       x >>= count; // now x < 2
602       res = count * FIXED_1;
603     }
604 
605     // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
606     if (x > FIXED_1) {
607       for (uint8 i = MAX_PRECISION; i > 0; --i) {
608         x = (x * x) / FIXED_1; // now 1 < x < 4
609         if (x >= FIXED_2) {
610           x >>= 1; // now 1 < x < 2
611           res += ONE << (i - 1);
612         }
613       }
614     }
615 
616     return res * LN2_NUMERATOR / LN2_DENOMINATOR;
617   }
618 
619   /**
620     Compute the largest integer smaller than or equal to the binary logarithm of the input.
621   */
622   function floorLog2(uint256 _n) internal pure returns (uint8) {
623     uint8 res = 0;
624     uint256 n = _n;
625 
626     if (n < 256) {
627       // At most 8 iterations
628       while (n > 1) {
629         n >>= 1;
630         res += 1;
631       }
632     } else {
633       // Exactly 8 iterations
634       for (uint8 s = 128; s > 0; s >>= 1) {
635         if (n >= (ONE << s)) {
636           n >>= s;
637           res |= s;
638         }
639       }
640     }
641 
642     return res;
643   }
644 
645   /**
646       The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
647       - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
648       - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
649   */
650   function findPositionInMaxExpArray(uint256 _x)
651   internal view returns (uint8)
652   {
653     uint8 lo = MIN_PRECISION;
654     uint8 hi = MAX_PRECISION;
655 
656     while (lo + 1 < hi) {
657       uint8 mid = (lo + hi) / 2;
658       if (maxExpArray[mid] >= _x)
659         lo = mid;
660       else
661         hi = mid;
662     }
663 
664     if (maxExpArray[hi] >= _x)
665       return hi;
666     if (maxExpArray[lo] >= _x)
667       return lo;
668 
669     assert(false);
670     return 0;
671   }
672 
673   /* solium-disable */
674   /**
675        This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
676        It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
677        It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
678        The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
679        The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
680    */
681    function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
682        uint256 xi = _x;
683        uint256 res = 0;
684 
685        xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
686        xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
687        xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
688        xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
689        xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
690        xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
691        xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
692        xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
693        xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
694        xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
695        xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
696        xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
697        xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
698        xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
699        xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
700        xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
701        xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
702        xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
703        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
704        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
705        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
706        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
707        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
708        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
709        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
710        xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
711        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
712        xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
713        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
714        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
715        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
716        xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
717 
718        return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
719    }
720 
721    /**
722        Return log(x / FIXED_1) * FIXED_1
723        Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
724        Auto-generated via 'PrintFunctionOptimalLog.py'
725    */
726    function optimalLog(uint256 x) internal pure returns (uint256) {
727        uint256 res = 0;
728 
729        uint256 y;
730        uint256 z;
731        uint256 w;
732 
733        if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;}
734        if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;}
735        if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;}
736        if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;}
737        if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;}
738        if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;}
739        if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;}
740        if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;}
741 
742        z = y = x - FIXED_1;
743        w = y * y / FIXED_1;
744        res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1;
745        res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1;
746        res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1;
747        res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1;
748        res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1;
749        res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1;
750        res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1;
751        res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;
752 
753        return res;
754    }
755 
756    /**
757        Return e ^ (x / FIXED_1) * FIXED_1
758        Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
759        Auto-generated via 'PrintFunctionOptimalExp.py'
760    */
761    function optimalExp(uint256 x) internal pure returns (uint256) {
762        uint256 res = 0;
763 
764        uint256 y;
765        uint256 z;
766 
767        z = y = x % 0x10000000000000000000000000000000;
768        z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
769        z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
770        z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
771        z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
772        z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
773        z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
774        z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
775        z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
776        z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
777        z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
778        z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
779        z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
780        z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
781        z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
782        z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
783        z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
784        z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
785        z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
786        z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
787        res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
788 
789        if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776;
790        if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4;
791        if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f;
792        if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9;
793        if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea;
794        if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d;
795        if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11;
796 
797        return res;
798    }
799    /* solium-enable */
800 }
801 
802 // File: contracts\BancorBondingCurve.sol
803 
804 pragma solidity ^0.5.2;
805 
806 
807 
808 /**
809 * @title Bancor formula by Bancor
810 *
811 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements;
812 * and to You under the Apache License, Version 2.0. "
813 */
814 contract BancorBondingCurve is Power {
815    using SafeMath for uint256;
816    uint32 private constant MAX_RESERVE_RATIO = 1000000;
817 
818    /**
819    * @dev given a continuous token supply, reserve token balance, reserve ratio, and a deposit amount (in the reserve token),
820    * calculates the return for a given conversion (in the continuous token)
821    *
822    * Formula:
823    * Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / MAX_RESERVE_RATIO) - 1)
824    *
825    * @param _supply              continuous token total supply
826    * @param _reserveBalance    total reserve token balance
827    * @param _reserveRatio     reserve ratio, represented in ppm, 1-1000000
828    * @param _depositAmount       deposit amount, in reserve token
829    *
830    *  @return purchase return amount
831   */
832   function calculatePurchaseReturn(
833     uint256 _supply,
834     uint256 _reserveBalance,
835     uint32 _reserveRatio,
836     uint256 _depositAmount) public view returns (uint256)
837   {
838     // validate input
839     require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_RESERVE_RATIO);
840      // special case for 0 deposit amount
841     if (_depositAmount == 0) {
842       return 0;
843     }
844      // special case if the ratio = 100%
845     if (_reserveRatio == MAX_RESERVE_RATIO) {
846       return _supply.mul(_depositAmount).div(_reserveBalance);
847     }
848      uint256 result;
849     uint8 precision;
850     uint256 baseN = _depositAmount.add(_reserveBalance);
851     (result, precision) = power(
852       baseN, _reserveBalance, _reserveRatio, MAX_RESERVE_RATIO
853     );
854     uint256 newTokenSupply = _supply.mul(result) >> precision;
855     return newTokenSupply - _supply;
856   }
857    /**
858    * @dev given a continuous token supply, reserve token balance, reserve ratio and a sell amount (in the continuous token),
859    * calculates the return for a given conversion (in the reserve token)
860    *
861    * Formula:
862    * Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / MAX_RESERVE_RATIO)))
863    *
864    * @param _supply              continuous token total supply
865    * @param _reserveBalance    total reserve token balance
866    * @param _reserveRatio     constant reserve ratio, represented in ppm, 1-1000000
867    * @param _sellAmount          sell amount, in the continuous token itself
868    *
869    * @return sale return amount
870   */
871   function calculateSaleReturn(
872     uint256 _supply,
873     uint256 _reserveBalance,
874     uint32 _reserveRatio,
875     uint256 _sellAmount) public view returns (uint256)
876   {
877     // validate input
878     require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_RESERVE_RATIO && _sellAmount <= _supply);
879      // special case for 0 sell amount
880     if (_sellAmount == 0) {
881       return 0;
882     }
883      // special case for selling the entire supply
884     if (_sellAmount == _supply) {
885       return _reserveBalance;
886     }
887      // special case if the ratio = 100%
888     if (_reserveRatio == MAX_RESERVE_RATIO) {
889       return _reserveBalance.mul(_sellAmount).div(_supply);
890     }
891      uint256 result;
892     uint8 precision;
893     uint256 baseD = _supply - _sellAmount;
894     (result, precision) = power(
895       _supply, baseD, MAX_RESERVE_RATIO, _reserveRatio
896     );
897     uint256 oldBalance = _reserveBalance.mul(result);
898     uint256 newBalance = _reserveBalance << precision;
899     return oldBalance.sub(newBalance).div(result);
900   }
901 }
902 
903 // File: contracts\ContinuousToken.sol
904 
905 pragma solidity ^0.5.2;
906 
907 
908 
909 
910 
911 contract ContinuousToken is BancorBondingCurve, Ownable, ERC20 {
912     
913     using SafeMath for uint256;
914 
915     uint256 public scale = 10**18;
916     uint256 public reserveBalance = 10*scale;
917     uint256 public reserveRatio = 500000;
918 
919     constructor() public {
920         _mint(msg.sender, 1*scale);
921     }
922 
923     function mint(address reciever, uint value) internal {
924         require(value > 0, "Must send ether to buy tokens.");
925         _continuousMint(reciever, value);
926     }
927 
928     function burn(uint256 _amount) public {
929         uint256 returnAmount = _continuousBurn(_amount);
930         msg.sender.transfer(returnAmount);
931     }
932 
933     function calculateContinuousMintReturn(uint256 _amount)
934         public view returns (uint256 mintAmount)
935     {
936         return calculatePurchaseReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
937     }
938 
939     function calculateContinuousBurnReturn(uint256 _amount)
940         public view returns (uint256 burnAmount)
941     {
942         return calculateSaleReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
943     }
944 
945     function _continuousMint(address reciever, uint value)
946         internal returns (uint256)
947     {
948         require(value > 0, "Deposit must be non-zero.");
949 
950         uint256 amount = calculateContinuousMintReturn(value);
951         _mint(reciever, amount);
952         reserveBalance = reserveBalance.add(value);
953         return amount;
954     }
955 
956     function _continuousBurn(uint256 _amount)
957         internal returns (uint256)
958     {
959         require(_amount > 0, "Amount must be non-zero.");
960         require(balanceOf(msg.sender) >= _amount, "Insufficient tokens to burn.");
961 
962         uint256 reimburseAmount = calculateContinuousBurnReturn(_amount);
963         reserveBalance = reserveBalance.sub(reimburseAmount);
964         _burn(msg.sender, _amount);
965         return reimburseAmount;
966     }
967 }
968 
969 // File: contracts\SpaceMiners.sol
970 
971 pragma solidity ^0.5.2;
972 
973 // GAME
974 
975 
976 
977 // TOKEN
978 
979 
980 contract SpaceMiners is Ownable, ContinuousToken {
981 
982   using SafeMath for uint;
983 
984   uint public PRICE_TO_MINE = 20 finney;
985   uint public PLANET_CAPACITY = 6;
986   uint public NUM_WINNERS = 3;
987   uint constant OWNER_FEE_PERCENT = 5;
988   address[] miners = new address[](PLANET_CAPACITY);
989   uint public planetPopulation = 0;
990   uint ownerHoldings = 1;
991 
992   string public constant name = "Kerium Crystals";
993   string public constant symbol = "KMC";
994   uint8 public constant decimals = 18;
995 
996   function setGameSettings(uint priceToMine, uint planetCapacity, uint numWinners) public payable onlyOwner {
997     PRICE_TO_MINE = priceToMine;
998     PLANET_CAPACITY = planetCapacity;
999     NUM_WINNERS = numWinners;
1000   }
1001 
1002   function getNumUsersMinersOnPlanet(address miner) public view returns (uint) {
1003     uint count = 0;
1004     for (uint i = 0; i < planetPopulation; i++) {
1005       if (miners[i] == miner) {
1006         count++;
1007       }
1008     }
1009     return count;
1010   }
1011 
1012   function sendSingleMinerToPlanet(address miner) internal {
1013     miners[planetPopulation] = miner;
1014     planetPopulation = planetPopulation.add(1);
1015     if (planetPopulation == PLANET_CAPACITY) {
1016       rewardMiners();
1017       planetPopulation = 0;
1018     }
1019   }
1020 
1021   function sendMinersToPlanet(uint numMiners) public payable {
1022     require(msg.value >= numMiners * PRICE_TO_MINE, "Not enough paid");
1023     require(planetPopulation < PLANET_CAPACITY, "Planet is full");
1024     mint(msg.sender, numMiners);
1025     for (uint i = 0; i < numMiners; i++) {
1026       sendSingleMinerToPlanet(msg.sender);
1027     }
1028   }
1029 
1030   function percentOfValue(uint percent, uint value) pure internal returns (uint) {
1031     return (value.mul(percent)).div(100);
1032   }
1033 
1034   function getRandom(uint cap) view internal returns (uint) {
1035     return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % cap;
1036   }
1037 
1038   function rewardMiners() internal {
1039     // First take OWNER_FEE_PERCENT
1040     uint roundEarnings = PRICE_TO_MINE * PLANET_CAPACITY;
1041     uint ownerFee = percentOfValue(OWNER_FEE_PERCENT, roundEarnings);
1042     ownerHoldings = ownerHoldings.add(ownerFee);
1043     roundEarnings = roundEarnings.sub(ownerFee);
1044     uint rewardAmount = roundEarnings.div(NUM_WINNERS);
1045     uint rnd = getRandom(PLANET_CAPACITY);
1046     for (uint i = rnd; i < rnd + NUM_WINNERS; i++) {
1047       if (i >= PLANET_CAPACITY) {
1048         mint(miners[i - PLANET_CAPACITY], rewardAmount);
1049       } else {
1050         mint(miners[i], rewardAmount);
1051       }
1052     }
1053   }
1054 
1055   function cashOutOwnerFee() public payable onlyOwner {
1056     require(ownerHoldings > 1);
1057     msg.sender.transfer(ownerHoldings - 1);
1058     ownerHoldings = 1;
1059   }
1060 
1061   function() external payable {
1062     address payable payableAddress = address(uint160(owner()));
1063     payableAddress.transfer(msg.value);
1064   }
1065 
1066 }
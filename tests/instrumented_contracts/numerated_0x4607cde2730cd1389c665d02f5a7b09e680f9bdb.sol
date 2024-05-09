1 /**
2 *
3 *  ███████╗████████╗██╗  ██╗    ██████╗ ██████╗  ██████╗ 
4 *  ██╔════╝╚══██╔══╝██║  ██║    ██╔══██╗██╔══██╗██╔═══██╗
5 *  █████╗     ██║   ███████║    ██████╔╝██████╔╝██║   ██║
6 *  ██╔══╝     ██║   ██╔══██║    ██╔═══╝ ██╔══██╗██║   ██║
7 *  ███████╗   ██║   ██║  ██║    ██║     ██║  ██║╚██████╔╝
8 *  ╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ 
9 *
10 * 
11 * ETH PRO
12 * https://eth-pro.github.io/
13 * or
14 * https://eth-pro.netlify.app/
15 * 
16 **/
17 
18 
19 pragma solidity ^0.6.7;
20 
21 /**
22     Utilities & Common Modifiers
23 */
24 
25 contract GreaterThanZero {
26     // verifies that an amount is greater than zero
27     modifier greaterThanZero(uint256 _amount) {
28         require(_amount > 0);
29         _;
30     }
31 }
32 
33 contract ValidAddress {
34     // validates an address - currently only checks that it isn't null
35     modifier validAddress(address _address) {
36         require(_address != address(0));
37         _;
38     }
39 }
40 
41 contract OnlyPayloadSize {
42 	//Mitigate short address attack and compatible padding problem while using “call“ 
43 	modifier onlyPayloadSize(uint256 numCount){
44 		assert((msg.data.length == numCount*32 + 4) || (msg.data.length == (numCount + 1)*32));
45 		_;
46 	}
47 }
48 
49 contract NotThis {
50     // verifies that the address is different than this contract address
51     modifier notThis(address _address) {
52         require(_address != address(this));
53         _;
54     }
55 }
56 
57 contract SafeMath {
58     // Overflow protected math functions
59 
60     /**
61         @dev returns the sum of _x and _y, asserts if the calculation overflows
62 
63         @param _x   value 1
64         @param _y   value 2
65 
66         @return sum
67     */
68     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x + _y;
70         require(z >= _x);        //assert(z >= _x);
71         return z;
72     }
73 
74     /**
75         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
76 
77         @param _x   minuend
78         @param _y   subtrahend
79 
80         @return difference
81     */
82     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
83         require(_x >= _y);        //assert(_x >= _y);
84         return _x - _y;
85     }
86 
87     /**
88         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
89 
90         @param _x   factor 1
91         @param _y   factor 2
92 
93         @return product
94     */
95     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
96         uint256 z = _x * _y;
97         require(_x == 0 || z / _x == _y);        //assert(_x == 0 || z / _x == _y);
98         return z;
99     }
100 	
101 	function safeDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
102 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
103         // uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105         return _x / _y;
106 	}
107 	
108 	function ceilDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
109 		return (_x + _y - 1) / _y;
110 	}
111 }
112 
113 
114 contract Sqrt {
115 	function sqrt(uint x)public pure returns(uint y) {
116         uint z = (x + 1) / 2;
117         y = x;
118         while (z < y) {
119             y = z;
120             z = (x / z + z) / 2;
121         }
122     }
123 }
124 
125 
126 contract Floor {
127 	/**
128         @dev Returns the largest integer smaller than or equal to _x.
129         @param _x   number _x
130         @return     value
131     */
132 	function floor(uint _x)public pure returns(uint){
133 		return (_x / 1 ether) * 1 ether;
134 	}
135 }
136 
137 contract Ceil {
138 	/**
139         @dev Returns the smallest integer larger than or equal to _x.
140         @param _x   number _x
141         @return ret    value ret
142     */
143 	function ceil(uint _x)public pure returns(uint ret){
144 		ret = (_x / 1 ether) * 1 ether;
145 		if((_x % 1 ether) == 0){
146 			return ret;
147 		}else{
148 			return ret + 1 ether;
149 		}
150 	}
151 }
152 	
153 contract IsContract {
154 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
155     function isContract(address _addr) internal view returns (bool is_contract) {
156         uint length;
157         assembly {
158               //retrieve the size of the code on target address, this needs assembly
159               length := extcodesize(_addr)
160         }
161         return (length>0);
162     }
163 }
164     
165 contract LogEvent {
166     // todo: for debug
167     event logEvent(string name, uint256 value);
168 }
169 
170 
171 /**
172     ERC20 Standard Token interface
173 */
174 interface IERC20Token {
175     function name() external view returns (string memory);
176     function symbol() external view returns (string memory);
177     function decimals() external view returns (uint8);
178     function totalSupply() external view returns (uint256);
179     function balanceOf(address _holder) external view returns (uint256);
180     function allowance(address _holder, address _spender) external view returns (uint256);
181 
182     function transfer(address _to, uint256 _amount) external returns (bool success);
183     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success);
184     function approve(address _spender, uint256 _amount) external returns (bool success);
185     
186     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
187     event Approval(address indexed _holder, address indexed _spender, uint256 _amount);
188 }
189 
190 
191 /**
192     ERC20 Standard Token implementation
193 */
194 contract ERC20Token is IERC20Token, SafeMath, ValidAddress {
195     string  internal/*public*/ m_name = '';
196     string  internal/*public*/ m_symbol = '';
197     uint8   internal/*public*/ m_decimals = 0;
198     uint256 internal/*public*/ m_totalSupply = 0;
199     mapping (address => uint256) internal/*public*/ m_balanceOf;
200     mapping (address => mapping (address => uint256)) internal/*public*/ m_allowance;
201 
202     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
203     event Approval(address indexed _holder, address indexed _spender, uint256 _amount);
204 
205     ///**
206     //    @dev constructor
207     //
208     //    @param _name        token name
209     //    @param _symbol      token symbol
210     //    @param _decimals    decimal points, for display purposes
211     //*/
212     //constructor(string  memory _name, string  memory _symbol, uint8 _decimals) public{
213     //    require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
214     //
215     //    m_name = _name;
216     //    m_symbol = _symbol;
217     //    m_decimals = _decimals;
218     //}
219 
220     function name() override public view returns (string memory){
221         return m_name;
222     }
223     function symbol() override public view returns (string memory){
224         return m_symbol;
225     }
226     function decimals() override public view returns (uint8){
227         return m_decimals;
228     }
229     function totalSupply() override public view returns (uint256){
230         return m_totalSupply;
231     }
232     function balanceOf(address _holder) override public view returns(uint256){
233         return m_balanceOf[_holder];
234     }
235     function allowance(address _holder, address _spender) override public view returns (uint256){
236         return m_allowance[_holder][_spender];
237     }
238     
239     /**
240         @dev send coins
241         throws on any error rather then return a false flag to minimize user errors
242 
243         @param _to      target address
244         @param _amount   transfer amount
245 
246         @return success is true if the transfer was successful, false if it wasn't
247     */
248     function transfer(address _to, uint256 _amount)
249         virtual 
250         override 
251         public
252         validAddress(_to)
253         returns (bool success)
254     {
255         m_balanceOf[msg.sender] = safeSub(m_balanceOf[msg.sender], _amount);
256         m_balanceOf[_to]        = safeAdd(m_balanceOf[_to], _amount);
257         emit Transfer(msg.sender, _to, _amount);
258         return true;
259     }
260 
261     /**
262         @dev an account/contract attempts to get the coins
263         throws on any error rather then return a false flag to minimize user errors
264 
265         @param _from    source address
266         @param _to      target address
267         @param _amount   transfer amount
268 
269         @return success is true if the transfer was successful, false if it wasn't
270     */
271     function transferFrom(address _from, address _to, uint256 _amount)
272         virtual
273         override 
274         public
275         validAddress(_from)
276         validAddress(_to)
277         returns (bool success)
278     {
279         m_allowance[_from][msg.sender]  = safeSub(m_allowance[_from][msg.sender], _amount);
280         m_balanceOf[_from]              = safeSub(m_balanceOf[_from], _amount);
281         m_balanceOf[_to]                = safeAdd(m_balanceOf[_to], _amount);
282         emit Transfer(_from, _to, _amount);
283         return true;
284     }
285 
286     /**
287         @dev allow another account/contract to spend some tokens on your behalf
288         throws on any error rather then return a false flag to minimize user errors
289 
290         also, to minimize the risk of the approve/transferFrom attack vector
291         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
292         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
293 
294         @param _spender approved address
295         @param _amount   allowance amount
296 
297         @return success is true if the approval was successful, false if it wasn't
298     */
299     function approve(address _spender, uint256 _amount)
300         override 
301         public
302         validAddress(_spender)
303         returns (bool success)
304     {
305         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
306         require(_amount == 0 || m_allowance[msg.sender][_spender] == 0);
307 
308         m_allowance[msg.sender][_spender] = _amount;
309         emit Approval(msg.sender, _spender, _amount);
310         return true;
311     }
312 }
313 
314 
315 /**
316     Provides support and utilities for contract Creator
317 */
318 contract Creator {
319     address payable public creator;
320     address payable public newCreator;
321 
322     /**
323         @dev constructor
324     */
325     constructor() public {
326         creator = msg.sender;
327     }
328 
329     // allows execution by the creator only
330     modifier creatorOnly {
331         assert(msg.sender == creator);
332         _;
333     }
334 
335     /**
336         @dev allows transferring the contract creatorship
337         the new creator still needs to accept the transfer
338         can only be called by the contract creator
339 
340         @param _newCreator    new contract creator
341     */
342     function transferCreator(address payable _newCreator) virtual public creatorOnly {
343         require(_newCreator != creator);
344         newCreator = _newCreator;
345     }
346 
347     /**
348         @dev used by a new creator to accept an Creator transfer
349     */
350     function acceptCreator() virtual public {
351         require(msg.sender == newCreator);
352         creator = newCreator;
353         newCreator = address(0x0);
354     }
355 }
356 
357 /**
358     Provides support and utilities for disable contract functions
359 */
360 contract Disable is Creator {
361 	bool public disabled;
362 	
363 	modifier enabled {
364 		assert(!disabled);
365 		_;
366 	}
367 	
368 	function disable(bool _disable) public creatorOnly {
369 		disabled = _disable;
370 	}
371 }
372 
373 
374 /**
375     Smart Token interface
376      is IOwned, IERC20Token
377 */
378 abstract contract ISmartToken{
379     function disableTransfers(bool _disable) virtual public;
380     function issue(address _to, uint256 _amount) virtual internal;
381     function destroy(address _from, uint256 _amount) virtual internal;
382 	//function() public payable;
383 }
384 
385 
386 /**
387     SmartToken implementation
388 */
389 contract SmartToken is ISmartToken, Creator, ERC20Token, NotThis {
390 
391     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
392 
393     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
394     event NewSmartToken(address _token);
395     // triggered when the total supply is increased
396     event Issuance(uint256 _amount);
397     // triggered when the total supply is decreased
398     event Destruction(uint256 _amount);
399 
400     ///**
401     //    @dev constructor
402     //
403     //    @param _name       token name
404     //    @param _symbol     token short symbol, minimum 1 character
405     //    @param _decimals   for display purposes only
406     //*/
407     //constructor(string memory _name, string memory _symbol, uint8 _decimals)
408     //    ERC20Token(_name, _symbol, _decimals) public
409     //{
410     //    emit NewSmartToken(address(this));
411     //}
412 
413     // allows execution only when transfers aren't disabled
414     modifier transfersAllowed {
415         assert(transfersEnabled);
416         _;
417     }
418 
419     /**
420         @dev disables/enables transfers
421         can only be called by the contract creator
422 
423         @param _disable    true to disable transfers, false to enable them
424     */
425     function disableTransfers(bool _disable) override public creatorOnly {
426         transfersEnabled = !_disable;
427     }
428 
429     /**
430         @dev increases the token supply and sends the new tokens to an account
431         can only be called by the contract creator
432 
433         @param _to         account to receive the new amount
434         @param _amount     amount to increase the supply by
435     */
436     function issue(address _to, uint256 _amount)
437         override
438         internal
439         //creatorOnly
440         validAddress(_to)
441         notThis(_to)
442     {
443         m_totalSupply = safeAdd(m_totalSupply, _amount);
444         m_balanceOf[_to] = safeAdd(m_balanceOf[_to], _amount);
445 
446         emit Issuance(_amount);
447         emit Transfer(address(0), _to, _amount);
448     }
449 
450     /**
451         @dev removes tokens from an account and decreases the token supply
452         can be called by the contract creator to destroy tokens from any account or by any holder to destroy tokens from his/her own account
453 
454         @param _from       account to remove the amount from
455         @param _amount     amount to decrease the supply by
456     */
457     function destroy(address _from, uint256 _amount) virtual override internal {
458         //require(msg.sender == _from || msg.sender == creator); // validate input
459 
460         m_balanceOf[_from] = safeSub(m_balanceOf[_from], _amount);
461         m_totalSupply = safeSub(m_totalSupply, _amount);
462 
463         emit Transfer(_from, address(0), _amount);
464         emit Destruction(_amount);
465     }
466     
467     function transfer(address _to, uint256 _amount) virtual override public transfersAllowed returns (bool success){
468         return super.transfer(_to, _amount);
469     }
470     
471     function transferFrom(address _from, address _to, uint256 _amount) virtual override public transfersAllowed returns (bool success){
472         return super.transferFrom(_from, _to, _amount);
473     }
474 }
475 
476 
477 contract Formula is SafeMath {
478 
479     uint256 public constant ONE = 1; 
480     uint32 public constant MAX_WEIGHT = 1000000;
481     uint8 public constant MIN_PRECISION = 32;
482     uint8 public constant MAX_PRECISION = 127;
483 
484     /**
485         The values below depend on MAX_PRECISION. If you choose to change it:
486         Apply the same change in file 'PrintIntScalingFactors.py', run it and paste the results below.
487     */
488     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
489     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
490     uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;
491 
492     /**
493         The values below depend on MAX_PRECISION. If you choose to change it:
494         Apply the same change in file 'PrintLn2ScalingFactors.py', run it and paste the results below.
495     */
496     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
497     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
498 
499     /**
500         The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
501         Apply the same change in file 'PrintFunctionBancorFormula.py', run it and paste the results below.
502     */
503     uint256[128] private maxExpArray;
504 
505     constructor () public {
506 
507     //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
508     //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
509     //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
510     //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
511     //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
512     //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
513     //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
514     //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
515     //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
516     //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
517     //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
518     //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
519     //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
520     //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
521     //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
522     //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
523     //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
524     //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
525     //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
526     //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
527     //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
528     //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
529     //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
530     //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
531     //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
532     //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
533     //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
534     //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
535     //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
536     //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
537     //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
538     //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
539         maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
540         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
541         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
542         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
543         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
544         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
545         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
546         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
547         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
548         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
549         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
550         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
551         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
552         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
553         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
554         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
555         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
556         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
557         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
558         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
559         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
560         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
561         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
562         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
563         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
564         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
565         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
566         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
567         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
568         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
569         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
570         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
571         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
572         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
573         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
574         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
575         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
576         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
577         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
578         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
579         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
580         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
581         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
582         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
583         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
584         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
585         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
586         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
587         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
588         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
589         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
590         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
591         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
592         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
593         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
594         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
595         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
596         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
597         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
598         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
599         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
600         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
601         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
602         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
603         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
604         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
605         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
606         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
607         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
608         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
609         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
610         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
611         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
612         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
613         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
614         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
615         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
616         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
617         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
618         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
619         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
620         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
621         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
622         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
623         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
624         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
625         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
626         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
627         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
628         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
629         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
630         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
631         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
632         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
633         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
634         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
635     }
636 
637     /**
638         @dev given a token supply, connector balance, weight and a deposit amount (in the connector token),
639         calculates the return for a given conversion (in the main token)
640 
641         Formula:
642         Return = _supply * ((1 + _depositAmount / _connectorBalance) ^ (_connectorWeight / 1000000) - 1)
643 
644         @param _supply              token total supply
645         @param _connectorBalance    total connector balance
646         @param _connectorWeight     connector weight, represented in ppm, 1-1000000
647         @param _depositAmount       deposit amount, in connector token
648 
649         @return purchase return amount
650     */
651     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256) {
652         // validate input
653         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT);
654 
655         // special case for 0 deposit amount
656         if (_depositAmount == 0)
657             return 0;
658 
659         // special case if the weight = 100%
660         if (_connectorWeight == MAX_WEIGHT)
661             return safeMul(_supply, _depositAmount) / _connectorBalance;
662 
663         uint256 result;
664         uint8 precision;
665         uint256 baseN = safeAdd(_depositAmount, _connectorBalance);
666         (result, precision) = power(baseN, _connectorBalance, _connectorWeight, MAX_WEIGHT);
667         uint256 temp = safeMul(_supply, result) >> precision;
668         return temp - _supply;
669     }
670 
671     /**
672         @dev given a token supply, connector balance, weight and a sell amount (in the main token),
673         calculates the return for a given conversion (in the connector token)
674 
675         Formula:
676         Return = _connectorBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_connectorWeight / 1000000)))
677 
678         @param _supply              token total supply
679         @param _connectorBalance    total connector
680         @param _connectorWeight     constant connector Weight, represented in ppm, 1-1000000
681         @param _sellAmount          sell amount, in the token itself
682 
683         @return sale return amount
684     */
685     function calculateRedeemReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256) {
686         // validate input
687         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT && _sellAmount <= _supply);
688 
689         // special case for 0 sell amount
690         if (_sellAmount == 0)
691             return 0;
692 
693         // special case for selling the entire supply
694         if (_sellAmount == _supply)
695             return _connectorBalance;
696 
697         // special case if the weight = 100%
698         if (_connectorWeight == MAX_WEIGHT)
699             return safeMul(_connectorBalance, _sellAmount) / _supply;
700 
701         uint256 result;
702         uint8 precision;
703         uint256 baseD = _supply - _sellAmount;
704         (result, precision) = power(_supply, baseD, MAX_WEIGHT, _connectorWeight);
705         uint256 temp1 = safeMul(_connectorBalance, result);
706         uint256 temp2 = _connectorBalance << precision;
707         return (temp1 - temp2) / result;
708     }
709     
710     /**
711         General Description:
712             Determine a value of precision.
713             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
714             Return the result along with the precision used.
715 
716         Detailed Description:
717             Instead of calculating "base ^ exp", we calculate "e ^ (ln(base) * exp)".
718             The value of "ln(base)" is represented with an integer slightly smaller than "ln(base) * 2 ^ precision".
719             The larger "precision" is, the more accurately this value represents the real value.
720             However, the larger "precision" is, the more bits are required in order to store this value.
721             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
722             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
723             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
724             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
725             This functions assumes that "_expN < (1 << 256) / ln(MAX_NUM, 1)", otherwise the multiplication should be replaced with a "safeMul".
726     */
727     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) public view returns (uint256, uint8) {
728         
729         uint256 lnBaseTimesExp = ln(_baseN, _baseD) * _expN / _expD;
730         uint8 precision = findPositionInMaxExpArray(lnBaseTimesExp);
731         assert(precision >= MIN_PRECISION);                                     //hhj+ move from findPositionInMaxExpArray
732         return (fixedExp(lnBaseTimesExp >> (MAX_PRECISION - precision), precision), precision);
733     }
734 
735     // support _baseN < _baseD
736     function power2(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) public view returns (uint256, uint8) {
737         if(_baseN >= _baseD)
738             return power(_baseN, _baseD, _expN, _expD);
739         uint256 lnBaseTimesExp = ln(_baseD, _baseN) * _expN / _expD;
740         uint8 precision = findPositionInMaxExpArray(lnBaseTimesExp);
741         if(precision < MIN_PRECISION)
742             return (0, 0);
743         uint256 base = fixedExp(lnBaseTimesExp >> (MAX_PRECISION - precision), precision);
744         base = (uint256(1) << (MIN_PRECISION + MAX_PRECISION)) / base;
745         precision = MIN_PRECISION + MAX_PRECISION - precision;
746         return (base, precision);
747     }
748 
749     /**
750         Return floor(ln(numerator / denominator) * 2 ^ MAX_PRECISION), where:
751         - The numerator   is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
752         - The denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
753         - The output      is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
754         This functions assumes that the numerator is larger than or equal to the denominator, because the output would be negative otherwise.
755     */
756     function ln(uint256 _numerator, uint256 _denominator) public pure returns (uint256) {
757         assert(_numerator <= MAX_NUM);
758 
759         uint256 res = 0;
760         uint256 x = _numerator * FIXED_1 / _denominator;
761 
762         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
763         if (x >= FIXED_2) {
764             uint8 count = floorLog2(x / FIXED_1);
765             x >>= count; // now x < 2
766             res = count * FIXED_1;
767         }
768 
769         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
770         if (x > FIXED_1) {
771             for (uint8 i = MAX_PRECISION; i > 0; --i) {
772                 x = (x * x) / FIXED_1; // now 1 < x < 4
773                 if (x >= FIXED_2) {
774                     x >>= 1; // now 1 < x < 2
775                     res += ONE << (i - 1);
776                 }
777             }
778         }
779 
780         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
781     }
782 
783     /**
784         Compute the largest integer smaller than or equal to the binary logarithm of the input.
785     */
786     function floorLog2(uint256 _n) internal/*public*/ pure returns (uint8) {
787         uint8 res = 0;
788 
789         if (_n < 256) {
790             // At most 8 iterations
791             while (_n > 1) {
792                 _n >>= 1;
793                 res += 1;
794             }
795         }
796         else {
797             // Exactly 8 iterations
798             for (uint8 s = 128; s > 0; s >>= 1) {
799                 if (_n >= (ONE << s)) {
800                     _n >>= s;
801                     res |= s;
802                 }
803             }
804         }
805 
806         return res;
807     }
808 
809     /**
810         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
811         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
812         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
813     */
814     function findPositionInMaxExpArray(uint256 _x) internal/*public*/ view returns (uint8) {
815         uint8 lo = MIN_PRECISION;
816         uint8 hi = MAX_PRECISION;
817 
818         while (lo + 1 < hi) {
819             uint8 mid = (lo + hi) / 2;
820             if (maxExpArray[mid] >= _x)
821                 lo = mid;
822             else
823                 hi = mid;
824         }
825 
826         if (maxExpArray[hi] >= _x)
827             return hi;
828         if (maxExpArray[lo] >= _x)
829             return lo;
830 
831         //assert(false);                                                        // move to power
832         return 0;
833     }
834 
835     /**
836         This function can be auto-generated by the script 'PrintFunctionFixedExp.py'.
837         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
838         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
839         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
840         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
841     */
842     function fixedExp(uint256 _x, uint8 _precision) internal/*public*/ pure returns (uint256) {
843         uint256 xi = _x;
844         uint256 res = 0;
845 
846         xi = (xi * _x) >> _precision;
847         res += xi * 0x03442c4e6074a82f1797f72ac0000000; // add x^2 * (33! / 2!)
848         xi = (xi * _x) >> _precision;
849         res += xi * 0x0116b96f757c380fb287fd0e40000000; // add x^3 * (33! / 3!)
850         xi = (xi * _x) >> _precision;
851         res += xi * 0x0045ae5bdd5f0e03eca1ff4390000000; // add x^4 * (33! / 4!)
852         xi = (xi * _x) >> _precision;
853         res += xi * 0x000defabf91302cd95b9ffda50000000; // add x^5 * (33! / 5!)
854         xi = (xi * _x) >> _precision;
855         res += xi * 0x0002529ca9832b22439efff9b8000000; // add x^6 * (33! / 6!)
856         xi = (xi * _x) >> _precision;
857         res += xi * 0x000054f1cf12bd04e516b6da88000000; // add x^7 * (33! / 7!)
858         xi = (xi * _x) >> _precision;
859         res += xi * 0x00000a9e39e257a09ca2d6db51000000; // add x^8 * (33! / 8!)
860         xi = (xi * _x) >> _precision;
861         res += xi * 0x0000012e066e7b839fa050c309000000; // add x^9 * (33! / 9!)
862         xi = (xi * _x) >> _precision;
863         res += xi * 0x0000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
864         xi = (xi * _x) >> _precision;
865         res += xi * 0x00000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
866         xi = (xi * _x) >> _precision;
867         res += xi * 0x000000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
868         xi = (xi * _x) >> _precision;
869         res += xi * 0x00000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
870         xi = (xi * _x) >> _precision;
871         res += xi * 0x00000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
872         xi = (xi * _x) >> _precision;
873         res += xi * 0x0000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
874         xi = (xi * _x) >> _precision;
875         res += xi * 0x00000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
876         xi = (xi * _x) >> _precision;
877         res += xi * 0x000000000000052b6b54569976310000; // add x^17 * (33! / 17!)
878         xi = (xi * _x) >> _precision;
879         res += xi * 0x000000000000004985f67696bf748000; // add x^18 * (33! / 18!)
880         xi = (xi * _x) >> _precision;
881         res += xi * 0x0000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
882         xi = (xi * _x) >> _precision;
883         res += xi * 0x000000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
884         xi = (xi * _x) >> _precision;
885         res += xi * 0x0000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
886         xi = (xi * _x) >> _precision;
887         res += xi * 0x0000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
888         xi = (xi * _x) >> _precision;
889         res += xi * 0x00000000000000000001317c70077000; // add x^23 * (33! / 23!)
890         xi = (xi * _x) >> _precision;
891         res += xi * 0x000000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
892         xi = (xi * _x) >> _precision;
893         res += xi * 0x000000000000000000000082573a0a00; // add x^25 * (33! / 25!)
894         xi = (xi * _x) >> _precision;
895         res += xi * 0x000000000000000000000005035ad900; // add x^26 * (33! / 26!)
896         xi = (xi * _x) >> _precision;
897         res += xi * 0x0000000000000000000000002f881b00; // add x^27 * (33! / 27!)
898         xi = (xi * _x) >> _precision;
899         res += xi * 0x00000000000000000000000001b29340; // add x^28 * (33! / 28!)
900         xi = (xi * _x) >> _precision;
901         res += xi * 0x000000000000000000000000000efc40; // add x^29 * (33! / 29!)
902         xi = (xi * _x) >> _precision;
903         res += xi * 0x00000000000000000000000000007fe0; // add x^30 * (33! / 30!)
904         xi = (xi * _x) >> _precision;
905         res += xi * 0x00000000000000000000000000000420; // add x^31 * (33! / 31!)
906         xi = (xi * _x) >> _precision;
907         res += xi * 0x00000000000000000000000000000021; // add x^32 * (33! / 32!)
908         xi = (xi * _x) >> _precision;
909         res += xi * 0x00000000000000000000000000000001; // add x^33 * (33! / 33!)
910 
911         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
912     }
913    
914 } 
915 
916 
917 contract Constant {
918     uint256 internal constant ONE_DAY                           = 86400;
919     uint256 internal constant ONE_HOUR                          = 3600; 
920     uint256 internal constant UP_NODE_CONTER                    = 9;     
921     uint256 internal constant SPEND_PERSENT_EVERY_DATE          = 1;    
922     
923     function getAdjustedNow() internal view returns(uint256){
924        return   now+ONE_HOUR*9;
925     }
926     function getAdjustedDate()internal view returns(uint256)
927     {
928         return (now+ONE_HOUR*9) - (now+ONE_HOUR*9)%ONE_DAY - ONE_HOUR*9;
929     }
930     
931 }
932 
933 
934 /**
935     EProToken implementation
936 */
937 contract EProToken is SmartToken, Constant, Floor, Sqrt, Formula {
938     uint32  public weight                           = MAX_WEIGHT;               // 100%
939     uint256 public reserve;
940     uint256 public profitPool;
941     mapping (address => uint256) public stakingOf;
942     mapping (address => uint256) public lastDay4ProfitOf;
943     mapping (address => uint256) public profitedOf;
944     uint256 public totalProfited;
945     uint256 public totalDestroyed;
946     mapping (address => uint256) public remainderOf;
947     
948     constructor() public{
949         m_name = "ETH PRO Token";
950         m_symbol = "EPRO";
951         m_decimals = 18;
952     }
953     
954     function issueToken(address _holder, address _parent, uint256 _value) virtual internal {
955         uint256 value2 = safeAdd(_value, remainderOf[_holder]);
956         uint256 amount = floor(safeDiv(value2, 9));
957         remainderOf[_holder] = safeSub(value2, safeMul(amount, 9)); 
958         issue(_holder, amount);
959         if(_parent != address(0)){
960 		    value2 = safeAdd(_value, remainderOf[_parent]);
961 			amount = floor(safeDiv(value2, 9));
962 			remainderOf[_parent] = safeSub(value2, safeMul(amount, 9));
963             issue(_parent, amount);
964 		}
965         _value = safeDiv(_value, 40);                                           // 2.5%
966         profitPool = safeAdd(profitPool, _value);
967         reserve = safeAdd(reserve, _value);
968         adjustWeight();
969         emitPrice();
970     }
971     
972     function destroy(address _from, uint256 _amount) virtual override internal {
973         super.destroy(_from, _amount);
974         totalDestroyed = safeAdd(totalDestroyed, _amount);
975     }
976     
977     function calcWeight(uint256 _reserve) virtual public pure returns (uint32 weight_) {
978         weight_ = uint32(safeDiv(safeMul(MAX_WEIGHT, 2e9), sqrt(_reserve)));
979         if(weight_ > MAX_WEIGHT)
980             weight_ = MAX_WEIGHT;
981     }
982     
983     // adjust weight when reserve changed
984     function adjustWeight() virtual internal {
985         weight = calcWeight(reserve);
986     }
987     
988     // tax 10% when transfer or unstake
989     event Tax(address _to, uint256 _amount);
990     function tax(address _to, uint256 _amount) virtual internal {
991         if(_to == address(this))                                                // no tax when stake
992             return;
993             
994         destroy(_to, _amount / 10);
995         emit Tax(_to, _amount / 10);
996         emitPrice();
997     }
998     
999     function transfer(address _to, uint256 _amount) override public transfersAllowed returns (bool success){
1000         success = super.transfer(_to, _amount);
1001         tax(_to, _amount);
1002     }
1003     
1004     function transferFrom(address _from, address _to, uint256 _amount) override public transfersAllowed returns (bool success){
1005         success = super.transferFrom(_from, _to, _amount);
1006         tax(_to, _amount);
1007     }
1008     
1009     function totalStaking() virtual public view returns (uint256){
1010         return balanceOf(address(this));
1011     }
1012     
1013     event Stake(address _holder, uint256 _amount);
1014     function stake(uint256 _amount) virtual public returns (bool success){
1015         success = transfer(address(this), _amount);
1016         stakingOf[msg.sender] = safeAdd(stakingOf[msg.sender], _amount);
1017         lastDay4ProfitOf[msg.sender] = getAdjustedNow() / ONE_DAY;
1018         emit Stake(msg.sender, _amount);
1019     }
1020     
1021     event Unstake(address _holder, uint256 _amount);
1022     function unstake(uint256 _amount) virtual public returns (bool success){
1023         stakingOf[msg.sender] = safeSub(stakingOf[msg.sender], _amount);
1024         success = this.transfer(msg.sender, _amount);
1025         emit Unstake(msg.sender, _amount);
1026     }
1027     
1028     function profitingOf(address _holder) virtual public view returns (uint256){
1029         uint256 day = safeSub( getAdjustedNow() / ONE_DAY, lastDay4ProfitOf[_holder]);
1030         if(day < 1)
1031             return 0;
1032         //if(day > 7)
1033         //    day = 7;
1034         if(totalStaking() == 0)
1035             return 0;
1036         if(stakingOf[_holder] * day > totalStaking())
1037             return profitPool / 10;
1038         else
1039             return profitPool / 10 * stakingOf[_holder] * day / totalStaking();
1040     }
1041     
1042     event DivideProfit(address _holder, uint256 _value);
1043     function divideProfit() virtual public returns (uint256 profit){
1044         profit = profitingOf(msg.sender);
1045         profitedOf[msg.sender] = safeAdd(profitedOf[msg.sender], profit);
1046         totalProfited = safeAdd(totalProfited, profit);
1047         profitPool = safeSub(profitPool, profit);
1048         lastDay4ProfitOf[msg.sender] =  getAdjustedNow() / ONE_DAY;
1049         msg.sender.transfer(profit);
1050         emit DivideProfit(msg.sender, profit);
1051     }
1052     
1053     function price() virtual public view returns (uint256){
1054         if(m_totalSupply == 0)
1055             return 0.01 ether;
1056 		return safeDiv(safeMul(safeDiv(safeMul(reserve, MAX_WEIGHT), weight), 1 ether), m_totalSupply);   
1057     }
1058     
1059     event Price(uint256 _price, uint256 _reserve, uint256 _supply, uint32 _weight);
1060     function emitPrice() virtual internal {
1061         emit Price(price(), reserve, m_totalSupply, weight);
1062     }
1063     
1064     function calcPurchaseRet(uint256 _value) virtual public view returns (uint256 amount, uint256 price_, uint256 tax_) {
1065         uint256 value_90 = safeDiv(safeMul(_value, 90), 100);                   // 90% into reserve, 10% to distributePool
1066         uint32  weight_ = calcWeight(safeAdd(reserve, value_90));
1067         uint256 value_85 = safeDiv(safeMul(_value, 85), 100);                   // 85% token returns
1068         amount = calculatePurchaseReturn(m_totalSupply, reserve, weight_, value_85);
1069         price_ = safeDiv(safeMul(value_85, 1 ether), amount);
1070         tax_ = safeSub(_value, value_85);
1071     }
1072     
1073     function purchase() virtual public payable returns (uint256 amount){
1074         uint256 value_90 = safeDiv(safeMul(msg.value, 90), 100);                // 90% into reserve, 10% to distributePool
1075         weight = calcWeight(safeAdd(reserve, value_90));
1076         uint256 value_85 = safeDiv(safeMul(msg.value, 85), 100);                // 85% token returns
1077         amount = calculatePurchaseReturn(m_totalSupply, reserve, weight, value_85);
1078         reserve = safeAdd(reserve, value_90);
1079         issue(msg.sender, amount);
1080         emitPrice();
1081     }
1082     
1083     function calcRedeemRet(uint256 _amount) virtual public view returns (uint256 value_, uint256 price_, uint256 tax_) {
1084         value_ = calculateRedeemReturn(m_totalSupply, reserve, weight, _amount);
1085         price_ = safeDiv(safeMul(value_, 1 ether), _amount);
1086         tax_ = safeDiv(safeMul(value_, 15), 100); 
1087         value_ -= tax_;
1088     }
1089     
1090     function redeem(uint256 _amount) virtual public returns (uint256 value_){
1091         value_ = calculateRedeemReturn(m_totalSupply, reserve, weight, _amount);
1092         reserve = safeSub(reserve, safeDiv(safeMul(value_, 95), 100));
1093         adjustWeight();
1094         destroy(msg.sender, _amount);
1095         value_ = safeDiv(safeMul(value_, 85), 100);                             // 85% redeem, 5% to reserve, 10% to distributePool
1096         msg.sender.transfer(value_);
1097         emitPrice();
1098     }
1099         
1100 }
1101 
1102 
1103 /**
1104     Main contract Ethpro implementation
1105 */
1106 contract EthPro is EProToken {
1107     
1108     function purchase() virtual override public payable returns (uint256 amount){
1109         uint256 tax = safeDiv(msg.value, 10);
1110         distributePool = safeAdd(distributePool, tax);  // 10% to distributePool
1111         ethTax[roundNo] = safeAdd(ethTax[roundNo], tax);
1112         amount = super.purchase();
1113     }
1114     
1115     function redeem(uint256 _amount) virtual override public returns (uint256 value_){
1116         value_ = super.redeem(_amount);
1117         uint256 tax = safeDiv(safeMul(value_, 10), 85);
1118         distributePool = safeAdd(distributePool, tax);  // 10% to distributePool
1119         ethTax[roundNo] = safeAdd(ethTax[roundNo], tax);
1120     }
1121 
1122     uint256 public distributePool;                      
1123     uint256 public devFund;                             
1124     uint256 public top3Pool;                            
1125     mapping (uint256 => uint256) public totalInvestment;
1126     mapping (uint256 => uint256) public ethTax;         
1127     mapping (uint256 => uint256) public lastSeriesNo;   
1128     uint256 public roundNo;                           
1129 
1130 
1131     struct User{ 
1132         uint256 seriesNo;
1133         uint256 investment;                           
1134         mapping (uint256 => uint256) investmentHistory;
1135         uint256 ethDone;                              
1136         mapping (uint256 => uint256) ethDoneHistory;   
1137         uint256 disDone;                              
1138         uint256 roundFirstDate;                       
1139         uint256 distributeLastTime;                   
1140         bool quitted;                                
1141         bool boxReward;                              
1142     }
1143     
1144     struct User1{                                     
1145         uint256 sonAmount;                            
1146         uint256 sonAmountPre;                         
1147         uint256 sonAmountDate;                        
1148         uint256 sonTotalAmount1;                      
1149         uint256 sonTotalAmount9;                      
1150         
1151         uint256 linkReward;                           
1152         uint256 nodeReward;                           
1153         uint256 supNodeReward;                        
1154         uint256 linkRewardTotal;                      
1155         uint256 nodeRewardTotal;                      
1156         uint256 supNodeRewardTotal;                   
1157     }
1158     
1159     struct User2{
1160 	    uint256 firstTime;                            
1161         uint256 roundNo;                              
1162         address parent;                               
1163         uint256 sonCount;                             
1164         uint256 sonNodeCount;                         
1165 		uint256 supNodeCount;                         
1166     }
1167 
1168     mapping (uint256 => mapping(address => User)) public user;     
1169     mapping (uint256 => mapping(address => User1)) public user1;   
1170     mapping (address => User2) public user2;                     
1171     
1172     mapping(uint256 => uint256) public quitAmount;                
1173     mapping(uint256 => uint256) public quitLastTime;              
1174 
1175     address[3] public top3;                                      
1176     address[3] public top3Pre;                                   
1177     bool[3]    public top3Withdraw;                             
1178     uint256    public top3date;                                 
1179     uint256    public top3PoolPre;                                 
1180     
1181     mapping(uint256 => uint256) public boxExpire;
1182     mapping(uint256 => uint256) public boxLastSeriesNo;           
1183     
1184     constructor() public{
1185         roundNo = 1;
1186         boxExpire[roundNo]=now+72*ONE_HOUR;
1187         quitLastTime[roundNo] = getAdjustedDate();
1188     }
1189     
1190     event logAddrAmount(uint256 indexed lastSeriesNo,uint256 indexed round,address send, uint256 amount,uint256 logtime);
1191     event logProfit(uint256 indexed round,address addr, uint256 profitAmount,uint256 invitAmount,uint256 logtime);
1192     
1193     event loglink(uint256 indexed round, address indexed parent, address indexed addr, uint256 investment, uint256 invitAmount, uint256 sonCount, uint256 nodeCount, uint256 supNodeCount, uint256 firstTime);
1194 
1195 	
1196     receive() external payable  {
1197       if (msg.value==0)
1198         distributionReward();
1199       else
1200         play(address(0));
1201     }
1202 
1203     function limSub(uint256 _x,uint256 _y) internal pure returns (uint256) {
1204       if (_x>_y)
1205         return _x - _y;
1206       else
1207         return 0;
1208     }
1209 
1210     function play(address parent) public payable { 
1211       address addr=msg.sender;
1212       uint256 value=msg.value;
1213       if (value<(1 ether))
1214         revert();
1215       if (now > boxExpire[roundNo])          
1216         revert();
1217       if  (((parent==address(0))||(user2[parent].roundNo == 0))&&(addr!=creator)){ 
1218           parent=creator;
1219       }
1220       if(user2[addr].parent==address(0))
1221         user2[addr].parent = parent;
1222       else
1223         parent = user2[addr].parent;
1224         
1225 	  if (user2[addr].firstTime==0)
1226 	       user2[addr].firstTime = now;
1227       bool reinvestment = false; 
1228       if (roundNo>user2[addr].roundNo){ 
1229         user2[addr].roundNo = roundNo;
1230       }
1231       
1232       if(user[roundNo][addr].investment>0){
1233 		if (user[roundNo][addr].ethDone < user[roundNo][addr].investment *125/100){ 
1234           revert();
1235         }else{
1236           reinvestment = true;
1237         }
1238       }
1239 
1240       
1241       uint256 curDay = getAdjustedDate();
1242       user[roundNo][addr].investment += value;
1243       user[roundNo][addr].investmentHistory[curDay] = user[roundNo][addr].investment; 
1244       if(user[roundNo][addr].roundFirstDate == 0)
1245          user[roundNo][addr].roundFirstDate = curDay; 
1246       user[roundNo][addr].distributeLastTime = curDay; 
1247 
1248       totalInvestment[roundNo]     += value;
1249       distributePool        += value *85 / 100; 
1250       devFund               += value * 4 / 100; 
1251       top3Pool              += value * 3 / 100; 
1252 
1253       if (parent!=address(0)){
1254           
1255         nodeReward(parent, value);
1256 
1257         if (!reinvestment) {
1258             address parent_temp = addSon(parent);
1259             if(parent_temp != address(0))
1260                 addSonNode(parent_temp);
1261         }
1262 		  
1263         updateSonAmount(parent,value);
1264 		
1265         emit loglink(roundNo, parent, addr, user[roundNo][addr].investment, user1[roundNo][addr].sonTotalAmount9, user2[addr].sonCount, user2[addr].sonNodeCount, user2[addr].supNodeCount, user2[addr].firstTime);
1266             
1267         updateTop3(parent);
1268 
1269       }
1270 
1271       lastSeriesNo[roundNo]=lastSeriesNo[roundNo]+1;
1272       user[roundNo][addr].seriesNo=lastSeriesNo[roundNo];
1273       if (now<=boxExpire[roundNo]){
1274         boxLastSeriesNo[roundNo]=lastSeriesNo[roundNo];
1275         if ((now+72*ONE_HOUR)>(boxExpire[roundNo]+3*ONE_HOUR))
1276           boxExpire[roundNo]=boxExpire[roundNo]+3*ONE_HOUR;
1277         else
1278           boxExpire[roundNo]=now+72*ONE_HOUR;
1279       }
1280 
1281       issueToken(addr, parent, value);
1282 
1283       emit logAddrAmount(lastSeriesNo[roundNo],roundNo,addr,value,now);
1284     }
1285 
1286 
1287   function addSon(address addr) internal returns(address){
1288         user2[addr].sonCount += 1;
1289         if ((user2[addr].sonCount==UP_NODE_CONTER)&&(user2[addr].parent!=address(0))){
1290           return user2[addr].parent;
1291         }
1292         return address(0);
1293     }
1294 
1295     function addSonNode(address addr)internal {
1296        user2[addr].sonNodeCount += 1;
1297 		if ((user2[addr].sonNodeCount==UP_NODE_CONTER)&&(user2[addr].parent!=address(0)))
1298 		 {
1299 		      user2[user2[addr].parent].supNodeCount += 1;
1300 		 }
1301     }
1302 
1303     function restart() internal returns(bool){
1304       if (now>boxExpire[roundNo]){ 
1305         if (distributePool < (10 ether)){
1306           distributePool += totalInvestment[roundNo]* 1/100;
1307           roundNo = roundNo + 1;
1308           boxExpire[roundNo]=now + 72*ONE_HOUR;
1309           return true;
1310         }
1311       }
1312       return false;
1313     }
1314 
1315 
1316     function quit() public { 
1317         address payable addr = msg.sender;
1318         if (user[roundNo][addr].quitted) 
1319             revert();
1320         uint256 curDay = getAdjustedDate();
1321         uint256 quitDone = 0; 
1322         if (quitLastTime[roundNo] == curDay)
1323             quitDone = quitAmount[roundNo];
1324 
1325         uint256 value = safeSub(user[roundNo][addr].investment*80/100, (user[roundNo][addr].ethDone * 2));
1326         uint256 quitAmount1= quitDone + value;
1327         if(quitAmount1 > distributePool *1/100)
1328             revert();
1329         
1330         user[roundNo][addr].quitted = true;
1331         if (quitLastTime[roundNo] != curDay)
1332             quitLastTime[roundNo] = curDay;
1333         
1334         quitAmount[roundNo] = quitDone + value;
1335         distributePool = limSub(distributePool, value);
1336         addr.transfer(value);
1337         restart();
1338     }
1339 
1340 
1341     function distributionReward() public {
1342       if (user[roundNo][msg.sender].quitted) 
1343          revert();
1344       address payable addr=msg.sender;
1345       uint256 curDay = getAdjustedDate();
1346       uint256[9] memory r=calcUserReward(addr);
1347       user[roundNo][addr].distributeLastTime = curDay;
1348       user[roundNo][addr].ethDone += r[4];
1349       user[roundNo][addr].ethDoneHistory[curDay] = user[roundNo][addr].ethDone;
1350       user[roundNo][addr].disDone += r[0];
1351 
1352       distributePool = limSub(distributePool, r[4]);
1353 
1354       user1[roundNo][addr].linkReward = 0;
1355       user1[roundNo][addr].nodeReward = 0;
1356       user1[roundNo][addr].supNodeReward = 0;
1357       if (addr == creator){
1358         addr.transfer(r[4] + devFund); 
1359         devFund = 0;
1360       }
1361       else
1362         addr.transfer(r[4]);  
1363   
1364       emit logProfit(roundNo, addr, r[8], user1[roundNo][addr].sonTotalAmount1, now);
1365 
1366       if (user2[addr].parent!=address(0))
1367         linkReward(user2[addr].parent, r[6] *10/100 /2);
1368       restart();
1369     }
1370     
1371     function ceilReward(address addr, uint256 amount) public view returns(uint256 amount_) {
1372         uint256 curDay = getAdjustedDate();
1373         uint256 day = limSub(curDay , user[roundNo][addr].distributeLastTime) / ONE_DAY;
1374         if (day>7)
1375             day=7;
1376         uint256 disReward = (user[roundNo][addr].investment + floor(user[roundNo][addr].ethDone)) *SPEND_PERSENT_EVERY_DATE/100 * day;
1377         uint256 sumReward =disReward + user1[roundNo][addr].linkReward + user1[roundNo][addr].nodeReward + user1[roundNo][addr].supNodeReward;
1378         return limSub(amount, limSub(amount + user[roundNo][addr].ethDone + sumReward, user[roundNo][addr].investment *125/100));
1379     }
1380     
1381     function linkReward(address addr,uint256 amount) internal {
1382         for(uint i=0; i<9; i++){
1383             if(user2[addr].sonCount > i) {
1384                 uint256 amount_ = ceilReward(addr, amount);
1385                 if(amount_ > 0){
1386                     user1[roundNo][addr].linkReward += amount_;
1387                     user1[roundNo][addr].linkRewardTotal += amount_;
1388                 }
1389             }
1390             addr = user2[addr].parent;
1391             if (addr==address(0))
1392                break;
1393         }
1394     }
1395 
1396     function nodeReward(address addr,uint256 amount) internal {
1397         bool bNode = false;
1398         bool bSupNode = false;
1399         for (uint i=0; i<200; i++){
1400             if (addr==address(0))
1401                 break;
1402             if ((user2[addr].sonCount >= UP_NODE_CONTER) && (user2[addr].sonNodeCount < UP_NODE_CONTER) && (!bNode)){
1403                 uint256 amount_ =  ceilReward(addr, amount * 5/100/2);
1404                 if(amount_ > 0){
1405                     user1[roundNo][addr].nodeReward += amount_;
1406                     user1[roundNo][addr].nodeRewardTotal += amount_;
1407                 }
1408                 bNode = true;
1409             }
1410             if (user2[addr].sonNodeCount >= UP_NODE_CONTER){                
1411                 if (bNode){
1412                     uint256 amount_ =  ceilReward(addr, amount * 5/100/2);  
1413                     if(amount_ > 0){
1414                         user1[roundNo][addr].supNodeReward += amount_;      
1415                         user1[roundNo][addr].supNodeRewardTotal += amount_; 
1416                     }
1417                 }else{
1418                     uint256 amount_ =  ceilReward(addr, amount * 10/100/2); 
1419                     if(amount_ > 0){
1420                         user1[roundNo][addr].supNodeReward += amount_;      
1421                         user1[roundNo][addr].supNodeRewardTotal += amount_; 
1422                     }
1423                 }
1424                 bSupNode = true;
1425             }
1426             if (bSupNode || addr==creator)
1427                 break;
1428             addr = user2[addr].parent;
1429         }
1430     }
1431 
1432     function updateSonAmount(address addr,uint value) internal {
1433       uint256 date = getAdjustedDate();
1434       if (date == user1[roundNo][addr].sonAmountDate){
1435         user1[roundNo][addr].sonAmount = user1[roundNo][addr].sonAmount + value;
1436       }
1437       else if (date-ONE_DAY == user1[roundNo][addr].sonAmountDate){
1438         user1[roundNo][addr].sonAmountPre = user1[roundNo][addr].sonAmount;
1439         user1[roundNo][addr].sonAmount = value;
1440       }
1441       else if (user1[roundNo][addr].sonAmountDate==0){
1442         user1[roundNo][addr].sonAmount = value;
1443       }
1444       else{
1445         user1[roundNo][addr].sonAmountPre = 0;
1446         user1[roundNo][addr].sonAmount = value;
1447       }
1448       user1[roundNo][addr].sonAmountDate = date;
1449       
1450       user1[roundNo][addr].sonTotalAmount1 += value;
1451       for(uint256 i=0; i<9; i++) {
1452         user1[roundNo][addr].sonTotalAmount9 += value;
1453 
1454 		address parent = user2[addr].parent;
1455 		if(parent == address(0))
1456 		    break;
1457 		    
1458         emit loglink(roundNo, parent, addr, user[roundNo][addr].investment, user1[roundNo][addr].sonTotalAmount9, user2[addr].sonCount, user2[addr].sonNodeCount, user2[addr].supNodeCount, user2[addr].firstTime);
1459             
1460         addr = parent;
1461       }
1462     }
1463 
1464 
1465     function updateTop3(address addr) internal {
1466       if (addr == creator) 
1467         return;
1468       uint256 amount1 = user1[roundNo][addr].sonAmount;
1469       uint256 date =  getAdjustedDate();
1470       bool updateTop3date=false;
1471       address addr0 = top3[0];
1472       address addr1 = top3[1];
1473       address addr2 = top3[2];
1474       if (date == top3date){
1475         uint256 insertIndex=100;
1476         uint256 repeateIndex=100;
1477         address[3] memory tmp;
1478         if(!((amount1>user1[roundNo][top3[2]].sonAmount)||(amount1>user1[roundNo][top3[1]].sonAmount)))
1479           return;
1480         for (uint i=0;i<3;i++){
1481 	      if (top3[i] == addr)
1482 	        repeateIndex=i;
1483 	      else
1484 	        tmp[i] = top3[i];
1485         }
1486         for (uint i=0;i<3;i++){
1487           if (amount1>user1[roundNo][tmp[i]].sonAmount){
1488 	        insertIndex = i;
1489             break;
1490           }
1491         }
1492         uint j=0;//tmp
1493         for (uint i=0;i<3;i++){
1494           if (insertIndex==i){
1495             if (top3[i]!=addr)
1496 	          top3[i]=addr;
1497 	      }
1498           else{
1499             if (top3[i]!=tmp[j])
1500               top3[i]=tmp[j];
1501 	        j += 1;
1502 	      }
1503          if(j == repeateIndex)
1504 	          j += 1;
1505         }
1506       }
1507       else if (date-ONE_DAY == top3date){
1508         top3Pre[0]=addr0;
1509         top3Pre[1]=addr1;
1510         top3Pre[2]=addr2;
1511         top3[0]=addr;
1512         top3[1]=address(0);
1513         top3[2]=address(0);
1514         top3PoolPre = limSub(top3Pool , msg.value*3/100);
1515         updateTop3date=true;
1516       } 
1517       else if(top3date == 0){
1518         top3[0] = addr;
1519         updateTop3date = true;
1520       }
1521       else{
1522         for (uint i=0; i<3; i++){
1523           top3Pre[i] = address(0);
1524           if (i != 0)
1525           top3[i] = address(0);
1526         }
1527         top3[0] = addr;
1528         updateTop3date = true;
1529       }
1530       if (updateTop3date){
1531         top3date = date;
1532         for (uint i=0; i<3; i++)
1533           top3Withdraw[i] = false;
1534       }
1535     }
1536 
1537     function calcTop3Reward(uint256 rank,uint256 poolAmount) public pure returns(uint256) {
1538       uint256 ret=0;
1539       //if (top3date==date){
1540         if (rank==0)
1541           ret=poolAmount*3*6/100;
1542         else if(rank==1)
1543           ret = poolAmount*3*3/100;
1544         else if(rank==2)
1545           ret = poolAmount*3*1/100;
1546       //}
1547       return ret;
1548     }
1549 
1550     function getTop3Reward() public {
1551       if (user[roundNo][msg.sender].quitted) 
1552          revert();
1553       address payable addr=msg.sender;
1554       uint256 date = getAdjustedDate();
1555       //uint256 ret = 0;
1556       uint256 index = 100;
1557    
1558       if (date-ONE_DAY == top3date){
1559         top3Pre[0] = top3[0];
1560         top3Pre[1] = top3[1];
1561         top3Pre[2] = top3[2];
1562         for (uint i=0; i<3; i++){
1563           top3[i] = address(0);
1564           top3Withdraw[i] = false;
1565         }
1566         top3date = date;
1567 		top3PoolPre=top3Pool;
1568       } 
1569 
1570       if (top3date==date){
1571 
1572         if (addr == top3Pre[0]){
1573           index = 0;
1574         }
1575         else if(addr==top3Pre[1]){
1576           index =1;
1577         }
1578         else if(addr==top3Pre[2]){
1579           index = 2;
1580         }
1581       }
1582       if ((index<3)&&(!top3Withdraw[index])){
1583         uint256 ret = calcTop3Reward(index,top3PoolPre);
1584         top3Pool = limSub(top3Pool,ret);
1585         top3Withdraw[index] = true;
1586         addr.transfer(ret);  
1587       }
1588     }
1589 
1590     function calcBoxReward(uint256 rank,uint256 curRoundNo) internal view returns(uint256) {
1591       if (rank==1){
1592         //return boxPool[curRoundNo]*25/100;
1593         return totalInvestment[curRoundNo]*2/100 *25/100;
1594       }
1595       else if(rank>=2 && rank<=6){
1596         //return boxPool[curRoundNo]*25/100/5;
1597         return totalInvestment[curRoundNo]*2/100 *25/100 /5;
1598       }
1599       else if(rank>=7 && rank<=56){
1600         //return boxPool[curRoundNo]*25/100/50;
1601         return totalInvestment[curRoundNo]*2/100 *25/100 /50;
1602       }
1603       else if(rank>=57 && rank<=556){
1604         //return boxPool[curRoundNo]*25/100/500;
1605         return totalInvestment[curRoundNo]*2/100 *25/100 /500;
1606       }
1607       return 0;
1608     }
1609 
1610     function userBoxInfo(address addr) public view returns(uint256 curRoundNo,uint256 userBoxReward,bool boxOpened,bool drew){
1611       curRoundNo = user2[addr].roundNo;
1612       drew = false;
1613       userBoxReward = 0;
1614       if (curRoundNo==0){
1615         boxOpened = false;
1616         return (curRoundNo,userBoxReward,boxOpened,drew);
1617       }
1618       if (now>boxExpire[curRoundNo]){
1619         boxOpened = true;
1620         if ((user[curRoundNo][addr].seriesNo>0)&&(boxLastSeriesNo[curRoundNo]>=user[curRoundNo][addr].seriesNo)&&(boxLastSeriesNo[curRoundNo]-user[curRoundNo][addr].seriesNo<556)){
1621           drew = user[curRoundNo][addr].boxReward;
1622             //user[curRoundNo][addr].boxReward = true;
1623           uint256 rank = boxLastSeriesNo[curRoundNo]-user[curRoundNo][addr].seriesNo+1;
1624           userBoxReward = calcBoxReward(rank,curRoundNo);
1625         }
1626       }
1627     }
1628 
1629     function getBoxReward() public {
1630       if (user[roundNo][msg.sender].quitted)
1631         revert();
1632       address payable addr=msg.sender;
1633       uint256 curRoundNo;
1634       uint256 userBoxReward;
1635       bool boxOpened;
1636       bool drew=false;
1637       (curRoundNo,userBoxReward,boxOpened,drew) = userBoxInfo(addr);
1638       if ((userBoxReward>0)&&(!drew)){
1639         user[curRoundNo][addr].boxReward = true;
1640         //boxPool[curRoundNo] = boxPool[curRoundNo]-userBoxReward;
1641         addr.transfer(userBoxReward);
1642       }
1643     }
1644 
1645     function quitable(address addr) public view returns(uint256){ 
1646       if (user[roundNo][addr].quitted){
1647         return 0;
1648       }
1649       uint256 curDay = getAdjustedDate();
1650       uint256 quitDone=0; 
1651       if (quitLastTime[roundNo]==curDay)
1652         quitDone=quitAmount[roundNo];
1653       
1654       uint256 value = limSub(user[roundNo][addr].investment *80/100, user[roundNo][addr].ethDone * 2); 
1655       uint256 quitAmount1= quitDone + value;
1656       if(quitAmount1 > distributePool *1/100){
1657          return 2;
1658       }
1659       return 1;
1660 
1661     }
1662 
1663     function boolToUint256(bool bVar) public pure returns (uint256) {
1664       if (bVar)
1665         return 1;
1666       else
1667         return 0;
1668     }
1669 
1670     function calcIndateInvestment(address addr, uint256 curDay) public view returns (uint256) {
1671         mapping (uint256 => uint256) storage investmentHistory = user[roundNo][addr].investmentHistory;
1672         uint256 outdated = 0;
1673         uint256 roundFirstDate = user[roundNo][addr].roundFirstDate;
1674         if(roundFirstDate > 0) {
1675             for(uint256 i = curDay - 125 * ONE_DAY; i >= roundFirstDate; i-= ONE_DAY) {
1676                 if(investmentHistory[i] > 0) {
1677                     outdated = investmentHistory[i];
1678                     break;
1679                 }
1680             }
1681         }
1682         return limSub(user[roundNo][addr].investment, outdated);
1683     }
1684     
1685     function calcIndateEthDone(address addr, uint256 curDay) public view returns (uint256) {
1686         mapping (uint256 => uint256) storage ethDoneHistory = user[roundNo][addr].ethDoneHistory;
1687         uint256 outdated = 0;
1688         uint256 roundFirstDate = user[roundNo][addr].roundFirstDate;
1689         if(roundFirstDate > 0) {
1690             for(uint256 i = curDay - 125 * ONE_DAY; i >= roundFirstDate; i-= ONE_DAY) {
1691                 if(ethDoneHistory[i] > 0) {
1692                     outdated = ethDoneHistory[i];
1693                     break;
1694                 }
1695             }
1696         }
1697         return limSub(floor(user[roundNo][addr].ethDone), floor(outdated));
1698     }
1699     
1700     function calcUserReward(address  addr) public view returns(uint256[9] memory r){ 
1701         uint256 curDay = getAdjustedDate();
1702         uint256 day = limSub(curDay , user[roundNo][addr].distributeLastTime) / ONE_DAY;
1703         if (day < 1){
1704             for(uint256 i=0; i<9; i++){
1705                 r[i]=0;
1706             }
1707             //return r;
1708         }
1709         if (day>7)
1710             day=7;
1711         
1712         uint256 disPure   = calcIndateInvestment(addr, curDay) *SPEND_PERSENT_EVERY_DATE/100 * day;   
1713         uint256 disReward = disPure + calcIndateEthDone(addr, curDay) *SPEND_PERSENT_EVERY_DATE/100 * day; 
1714         uint256 sumReward = disReward + user1[roundNo][addr].linkReward + user1[roundNo][addr].nodeReward + user1[roundNo][addr].supNodeReward; 
1715         
1716         if ((user[roundNo][addr].ethDone + sumReward) > (user[roundNo][addr].investment *125/100)){
1717             sumReward = limSub(user[roundNo][addr].investment *125/100, user[roundNo][addr].ethDone);
1718         }
1719         if (disPure > sumReward)
1720             disPure = sumReward;
1721         if (sumReward < disReward)
1722             disReward = sumReward;
1723         
1724         r[0] = disReward;                                
1725         r[1] = user1[roundNo][addr].linkRewardTotal *2;   
1726         r[2] = user1[roundNo][addr].nodeRewardTotal *2;   
1727         r[3] = user1[roundNo][addr].supNodeRewardTotal *2;
1728         
1729         r[4] = sumReward;                                
1730         r[5] = limSub((user[roundNo][addr].investment + floor(user[roundNo][addr].ethDone)) *250/100, user[roundNo][addr].disDone *2);
1731         r[6] = disPure;                                         
1732         r[7] = user[roundNo][addr].ethDone *2;                   
1733         if (addr != creator)
1734             r[8] = (user[roundNo][addr].ethDone + sumReward) *2; 
1735     }
1736     
1737  
1738  function userTop3RewardInfo(address addr) public view returns(uint256 reward,bool done){  
1739     uint256 date = getAdjustedDate();
1740     uint256 index =100;
1741 	uint256 poolAmount;
1742     if (top3date==date){
1743         if (addr == top3Pre[0]){
1744           index = 0;
1745         }
1746         else if(addr==top3Pre[1]){
1747           index =1;
1748         }
1749         else if(addr==top3Pre[2]){
1750           index = 2;
1751         }
1752 		poolAmount = top3PoolPre;
1753     }
1754     else if (date-ONE_DAY == top3date){
1755         if (addr == top3[0]){
1756           index = 0;
1757         }
1758         else if(addr==top3[1]){
1759           index =1;
1760         }
1761         else if(addr==top3[2]){
1762           index = 2;
1763         }
1764 		poolAmount = top3Pool;
1765     }
1766     if (index<3){
1767         reward =  calcTop3Reward(index,poolAmount);
1768         done = top3Withdraw[index];
1769     }else{
1770         reward = 0;
1771         done = false;
1772     }
1773 
1774     
1775  }
1776 
1777     function getUserInfo(address addr) public view returns(uint256[50] memory ret) {
1778         uint256[9] memory r= calcUserReward(addr);
1779         uint256 curUserRoundNo = user2[addr].roundNo;
1780         
1781         ret[0] = user[roundNo][addr].seriesNo;
1782         ret[1] = user[roundNo][addr].investment;           
1783         ret[2] = user[roundNo][addr].ethDone + r[4];       
1784         ret[3] = user[roundNo][addr].ethDone;              
1785         ret[4] = user[roundNo][addr].distributeLastTime;   
1786         ret[5] = boolToUint256(user[roundNo][addr].quitted);
1787         ret[6] = uint256(user2[addr].parent);               
1788         ret[7] = user2[addr].sonCount;                     
1789         ret[8] = user2[addr].sonNodeCount;                 
1790         
1791         uint256 date = getAdjustedDate();
1792         if (user1[roundNo][addr].sonAmountDate == date){
1793           ret[9] = user1[roundNo][addr].sonAmount;                       
1794           ret[10] = user1[roundNo][addr].sonAmountPre;                   
1795         }else if(date-ONE_DAY == user1[roundNo][addr].sonAmountDate) {
1796           ret[9] = 0;                              
1797           ret[10] = user1[roundNo][addr].sonAmount;                      
1798         }
1799         bool top3Done;
1800         (ret[30],top3Done) = userTop3RewardInfo(addr);                   
1801         ret[31] = boolToUint256(top3Done);                               
1802         ret[11] = user1[roundNo][addr].sonAmountDate;                    
1803 
1804         ret[12] = boolToUint256(user[curUserRoundNo][addr].boxReward);   
1805         ret[13] = user[roundNo][addr].roundFirstDate;
1806         ret[14] = quitable(addr);                                        
1807         ret[15] = user[roundNo][addr].ethDone;                           
1808         ret[16] = balanceOf(addr);                                       
1809         ret[17] = stakingOf[addr];                                       
1810         ret[18] = profitedOf[addr];                                      
1811         
1812         ret[19] = user[roundNo][addr].disDone *2;                        
1813         ret[20] = r[1];                                                  
1814         ret[21] = r[2];                                                  
1815         ret[22] = r[3];                                                  
1816         ret[23] = r[4];                                                  
1817         ret[24] = r[5];                                                  
1818         ret[25] = limSub(user[roundNo][addr].investment * 250/100, r[7]); 
1819         ret[26] = r[7];                                                  
1820 
1821         uint256 curRoundNo;
1822         bool boxOpened;
1823         bool drew=false;
1824         //(curRoundNo,userBoxReward,boxOpened,drew) = userBoxInfo(addr);
1825         (curRoundNo,ret[27], boxOpened, drew) = userBoxInfo(addr);           
1826         ret[28] = boolToUint256(boxOpened);                                  
1827         ret[29] = profitingOf(addr);                                         
1828         
1829         ret[32] = r[8];                                                      
1830         
1831         return ret;
1832     }
1833 
1834     function getInfo() public view returns(uint256[50] memory) {
1835         uint256[50] memory ret;
1836         ret[0] = distributePool;                 
1837         ret[1] = top3Pool;                       
1838         ret[2] = totalInvestment[roundNo]* 2/100;
1839         ret[3] = totalInvestment[roundNo]* 1/100;
1840         ret[4] = devFund;                        
1841         ret[5] = totalInvestment[roundNo];       
1842         ret[6] = lastSeriesNo[roundNo];          
1843         ret[7] = roundNo;                        
1844         ret[8] = boxExpire[roundNo];             
1845         ret[9] = boxLastSeriesNo[roundNo];       
1846         ret[10]= ethTax[roundNo];                
1847 
1848       uint256 i=11;
1849       uint256 date = getAdjustedDate();
1850       if (top3date == date){
1851         for (uint256 j=0;j<3;j++){
1852           ret[i]=uint256(top3[j]); 
1853           i=i+1;
1854           ret[i]=user1[roundNo][top3[j]].sonAmount;
1855           i=i+1;
1856           if (ret[i-2]==0)
1857             ret[i] = 0;
1858           else
1859             ret[i]=calcTop3Reward(j,top3Pool);
1860           i=i+1;
1861         }
1862       }
1863       ret[20] = m_totalSupply;
1864       ret[21] = reserve;
1865       ret[22] = profitPool;
1866       ret[23] = totalProfited;
1867       ret[24] = totalDestroyed;
1868       ret[25] = price();
1869       ret[26] = totalStaking();
1870       ret[27] = uint256(creator);
1871       ret[28] = weight;
1872       ret[29] = totalInvestment[roundNo-1]; 
1873 	  uint256 quitDone = 0;  
1874       if (quitLastTime[roundNo] == date)
1875 		quitDone = quitAmount[roundNo];
1876 	  ret[30] = limSub(distributePool *1/100, quitDone);
1877       ret[49] = now;
1878       return ret;
1879     }
1880 
1881 }
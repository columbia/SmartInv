1 pragma solidity ^0.4.11;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 }
54 
55 /*
56     Open issues:
57     - The formula is not yet super accurate, especially for very small/very high ratios
58     - Improve dynamic precision support
59 */
60 
61 contract BancorFormula is SafeMath {
62 
63     uint256 constant ONE = 1;
64     uint256 constant TWO = 2;
65     uint256 constant MAX_FIXED_EXP_32 = 0x386bfdba29;
66     string public version = '0.2';
67 
68     function BancorFormula() {
69     }
70 
71     /**
72         @dev given a token supply, reserve, CRR and a deposit amount (in the reserve token), calculates the return for a given change (in the main token)
73 
74         Formula:
75         Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / 100) - 1)
76 
77         @param _supply             token total supply
78         @param _reserveBalance     total reserve
79         @param _reserveRatio       constant reserve ratio, 1-100
80         @param _depositAmount      deposit amount, in reserve token
81 
82         @return purchase return amount
83     */
84     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _depositAmount) public constant returns (uint256) {
85         // validate input
86         require(_supply != 0 && _reserveBalance != 0 && _reserveRatio > 0 && _reserveRatio <= 100);
87 
88         // special case for 0 deposit amount
89         if (_depositAmount == 0)
90             return 0;
91 
92         uint256 baseN = safeAdd(_depositAmount, _reserveBalance);
93         uint256 temp;
94 
95         // special case if the CRR = 100
96         if (_reserveRatio == 100) {
97             temp = safeMul(_supply, baseN) / _reserveBalance;
98             return safeSub(temp, _supply); 
99         }
100 
101         uint8 precision = calculateBestPrecision(baseN, _reserveBalance, _reserveRatio, 100);
102         uint256 resN = power(baseN, _reserveBalance, _reserveRatio, 100, precision);
103         temp = safeMul(_supply, resN) >> precision;
104         return safeSub(temp, _supply);
105      }
106 
107     /**
108         @dev given a token supply, reserve, CRR and a sell amount (in the main token), calculates the return for a given change (in the reserve token)
109 
110         Formula:
111         Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / 100)))
112 
113         @param _supply             token total supply
114         @param _reserveBalance     total reserve
115         @param _reserveRatio       constant reserve ratio, 1-100
116         @param _sellAmount         sell amount, in the token itself
117 
118         @return sale return amount
119     */
120     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _sellAmount) public constant returns (uint256) {
121         // validate input
122         require(_supply != 0 && _reserveBalance != 0 && _reserveRatio > 0 && _reserveRatio <= 100 && _sellAmount <= _supply);
123 
124         // special case for 0 sell amount
125         if (_sellAmount == 0)
126             return 0;
127 
128         uint256 baseD = safeSub(_supply, _sellAmount);
129         uint256 temp1;
130         uint256 temp2;
131 
132         // special case if the CRR = 100
133         if (_reserveRatio == 100) {
134             temp1 = safeMul(_reserveBalance, _supply);
135             temp2 = safeMul(_reserveBalance, baseD);
136             return safeSub(temp1, temp2) / _supply;
137         }
138 
139         // special case for selling the entire supply
140         if (_sellAmount == _supply)
141             return _reserveBalance;
142 
143         uint8 precision = calculateBestPrecision(_supply, baseD, 100, _reserveRatio);
144         uint256 resN = power(_supply, baseD, 100, _reserveRatio, precision);
145         temp1 = safeMul(_reserveBalance, resN);
146         temp2 = safeMul(_reserveBalance, ONE << precision);
147         return safeSub(temp1, temp2) / resN;
148     }
149 
150     /**
151         calculateBestPrecision 
152         Predicts the highest precision which can be used in order to compute "base^exp" without exceeding 256 bits in any of the intermediate computations.
153         Instead of calculating "base ^ exp", we calculate "e ^ (ln(base) * exp)".
154         The value of ln(base) is represented with an integer slightly smaller than ln(base) * 2 ^ precision.
155         The larger the precision is, the more accurately this value represents the real value.
156         However, function fixedExpUnsafe(x), which calculates e ^ x, is limited to a maximum value of x.
157         The limit depends on the precision (e.g, for precision = 32, the maximum value of x is MAX_FIXED_EXP_32).
158         Hence before calling the 'power' function, we need to estimate an upper-bound for ln(base) * exponent.
159         Of course, we should later assert that the value passed to fixedExpUnsafe is not larger than MAX_FIXED_EXP(precision).
160         Due to this assertion (made in function fixedExp), functions calculateBestPrecision and fixedExp are tightly coupled.
161         Note that the outcome of this function only affects the accuracy of the computation of "base ^ exp".
162         Therefore, we do not need to assert that no intermediate result exceeds 256 bits (nor in this function, neither in any of the functions down the calling tree).
163     */
164     function calculateBestPrecision(uint256 _baseN, uint256 _baseD, uint256 _expN, uint256 _expD) constant returns (uint8) {
165         uint8 precision;
166         uint256 maxExp = MAX_FIXED_EXP_32;
167         uint256 maxVal = lnUpperBound32(_baseN,_baseD) * _expN;
168         for (precision = 0; precision < 32; precision += 2) {
169             if (maxExp < (maxVal << precision) / _expD)
170                 break;
171             maxExp = (maxExp * 0xeb5ec5975959c565) >> (64-2);
172         }
173         if (precision == 0)
174             return 32;
175         return precision+32-2;
176     }
177 
178     /**
179         @dev calculates (_baseN / _baseD) ^ (_expN / _expD)
180         Returns result upshifted by precision
181 
182         This method is overflow-safe
183     */ 
184     function power(uint256 _baseN, uint256 _baseD, uint256 _expN, uint256 _expD, uint8 _precision) constant returns (uint256) {
185         uint256 logbase = ln(_baseN, _baseD, _precision);
186         // Not using safeDiv here, since safeDiv protects against
187         // precision loss. It's unavoidable, however
188         // Both `ln` and `fixedExp` are overflow-safe. 
189         return fixedExp(safeMul(logbase, _expN) / _expD, _precision);
190     }
191     
192     /**
193         input range: 
194             - numerator: [1, uint256_max >> precision]    
195             - denominator: [1, uint256_max >> precision]
196         output range:
197             [0, 0x9b43d4f8d6]
198 
199         This method asserts outside of bounds
200     */
201     function ln(uint256 _numerator, uint256 _denominator, uint8 _precision) public constant returns (uint256) {
202         // denominator > numerator: less than one yields negative values. Unsupported
203         assert(_denominator <= _numerator);
204 
205         // log(1) is the lowest we can go
206         assert(_denominator != 0 && _numerator != 0);
207 
208         // Upper bits are scaled off by precision
209         uint256 MAX_VAL = ONE << (256 - _precision);
210         assert(_numerator < MAX_VAL);
211         assert(_denominator < MAX_VAL);
212 
213         return fixedLoge( (_numerator << _precision) / _denominator, _precision);
214     }
215 
216     /**
217         lnUpperBound32 
218         Takes a rational number "baseN / baseD" as input.
219         Returns an integer upper-bound of the natural logarithm of the input scaled by 2^32.
220         We do this by calculating "UpperBound(log2(baseN / baseD)) * Ceiling(ln(2) * 2^32)".
221         We calculate "UpperBound(log2(baseN / baseD))" as "Floor(log2((_baseN - 1) / _baseD)) + 1".
222         For small values of "baseN / baseD", this sometimes yields a bad upper-bound approximation.
223         We therefore cover these cases (and a few more) manually.
224         Complexity is O(log(input bit-length)).
225     */
226     function lnUpperBound32(uint256 _baseN, uint256 _baseD) constant returns (uint256) {
227         assert(_baseN > _baseD);
228 
229         uint256 scaledBaseN = _baseN * 100000;
230         if (scaledBaseN <= _baseD *  271828) // _baseN / _baseD < e^1 (floorLog2 will return 0 if _baseN / _baseD < 2)
231             return uint256(1) << 32;
232         if (scaledBaseN <= _baseD *  738905) // _baseN / _baseD < e^2 (floorLog2 will return 1 if _baseN / _baseD < 4)
233             return uint256(2) << 32;
234         if (scaledBaseN <= _baseD * 2008553) // _baseN / _baseD < e^3 (floorLog2 will return 2 if _baseN / _baseD < 8)
235             return uint256(3) << 32;
236 
237         return (floorLog2((_baseN - 1) / _baseD) + 1) * 0xb17217f8;
238     }
239 
240     /**
241         input range: 
242             [0x100000000, uint256_max]
243         output range:
244             [0, 0x9b43d4f8d6]
245 
246         This method asserts outside of bounds
247 
248         Since `fixedLog2_min` output range is max `0xdfffffffff` 
249         (40 bits, or 5 bytes), we can use a very large approximation
250         for `ln(2)`. This one is used since it's the max accuracy 
251         of Python `ln(2)`
252 
253         0xb17217f7d1cf78 = ln(2) * (1 << 56)
254     */
255     function fixedLoge(uint256 _x, uint8 _precision) constant returns (uint256) {
256         // cannot represent negative numbers (below 1)
257         assert(_x >= ONE << _precision);
258 
259         uint256 flog2 = fixedLog2(_x, _precision);
260         return (flog2 * 0xb17217f7d1cf78) >> 56;
261     }
262 
263     /**
264         Returns log2(x >> 32) << 32 [1]
265         So x is assumed to be already upshifted 32 bits, and 
266         the result is also upshifted 32 bits. 
267         
268         [1] The function returns a number which is lower than the 
269         actual value
270 
271         input-range : 
272             [0x100000000, uint256_max]
273         output-range: 
274             [0,0xdfffffffff]
275 
276         This method asserts outside of bounds
277 
278     */
279     function fixedLog2(uint256 _x, uint8 _precision) constant returns (uint256) {
280         uint256 fixedOne = ONE << _precision;
281         uint256 fixedTwo = TWO << _precision;
282 
283         // Numbers below 1 are negative. 
284         assert( _x >= fixedOne);
285 
286         uint256 hi = 0;
287         while (_x >= fixedTwo) {
288             _x >>= 1;
289             hi += fixedOne;
290         }
291 
292         for (uint8 i = 0; i < _precision; ++i) {
293             _x = (_x * _x) / fixedOne;
294             if (_x >= fixedTwo) {
295                 _x >>= 1;
296                 hi += ONE << (_precision - 1 - i);
297             }
298         }
299 
300         return hi;
301     }
302 
303     /**
304         floorLog2
305         Takes a natural number (n) as input.
306         Returns the largest integer smaller than or equal to the binary logarithm of the input.
307         Complexity is O(log(input bit-length)).
308     */
309     function floorLog2(uint256 _n) constant returns (uint256) {
310         uint8 t = 0;
311         for (uint8 s = 128; s > 0; s >>= 1) {
312             if (_n >= (ONE << s)) {
313                 _n >>= s;
314                 t |= s;
315             }
316         }
317 
318         return t;
319     }
320 
321     /**
322         fixedExp is a 'protected' version of `fixedExpUnsafe`, which asserts instead of overflows.
323         The maximum value which can be passed to fixedExpUnsafe depends on the precision used.
324         The following array maps each precision between 0 and 63 to the maximum value permitted:
325         maxExpArray = {
326             0xc1               ,0x17a              ,0x2e5              ,0x5ab              ,
327             0xb1b              ,0x15bf             ,0x2a0c             ,0x50a2             ,
328             0x9aa2             ,0x1288c            ,0x238b2            ,0x4429a            ,
329             0x82b78            ,0xfaadc            ,0x1e0bb8           ,0x399e96           ,
330             0x6e7f88           ,0xd3e7a3           ,0x1965fea          ,0x30b5057          ,
331             0x5d681f3          ,0xb320d03          ,0x15784a40         ,0x292c5bdd         ,
332             0x4ef57b9b         ,0x976bd995         ,0x122624e32        ,0x22ce03cd5        ,
333             0x42beef808        ,0x7ffffffff        ,0xf577eded5        ,0x1d6bd8b2eb       ,
334             0x386bfdba29       ,0x6c3390ecc8       ,0xcf8014760f       ,0x18ded91f0e7      ,
335             0x2fb1d8fe082      ,0x5b771955b36      ,0xaf67a93bb50      ,0x15060c256cb2     ,
336             0x285145f31ae5     ,0x4d5156639708     ,0x944620b0e70e     ,0x11c592761c666    ,
337             0x2214d10d014ea    ,0x415bc6d6fb7dd    ,0x7d56e76777fc5    ,0xf05dc6b27edad    ,
338             0x1ccf4b44bb4820   ,0x373fc456c53bb7   ,0x69f3d1c921891c   ,0xcb2ff529eb71e4   ,
339             0x185a82b87b72e95  ,0x2eb40f9f620fda6  ,0x5990681d961a1ea  ,0xabc25204e02828d  ,
340             0x14962dee9dc97640 ,0x277abdcdab07d5a7 ,0x4bb5ecca963d54ab ,0x9131271922eaa606 ,
341             0x116701e6ab0cd188d,0x215f77c045fbe8856,0x3ffffffffffffffff,0x7abbf6f6abb9d087f,
342         };
343         Since we cannot use an array of constants, we need to approximate the maximum value dynamically.
344         For a precision of 32, the maximum value permitted is MAX_FIXED_EXP_32.
345         For each additional precision unit, the maximum value permitted increases by approximately 1.9.
346         So in order to calculate it, we need to multiply MAX_FIXED_EXP_32 by 1.9 for every additional precision unit.
347         And in order to optimize for speed, we multiply MAX_FIXED_EXP_32 by 1.9^2 for every 2 additional precision units.
348         Hence the general function for mapping a given precision to the maximum value permitted is:
349         - precision = [32, 34, 36, ..., 62]
350         - MaxFixedExp(precision) = MAX_FIXED_EXP_32 * 3.61 ^ (precision / 2 - 16)
351         Since we cannot use non-integers, we do MAX_FIXED_EXP_32 * 361 ^ (precision / 2 - 16) / 100 ^ (precision / 2 - 16).
352         But there is a better approximation, because this "1.9" factor in fact extends beyond a single decimal digit.
353         So instead, we use 0xeb5ec5975959c565 / 0x4000000000000000, which yields maximum values quite close to real ones:
354         maxExpArray = {
355             -------------------,-------------------,-------------------,-------------------,
356             -------------------,-------------------,-------------------,-------------------,
357             -------------------,-------------------,-------------------,-------------------,
358             -------------------,-------------------,-------------------,-------------------,
359             -------------------,-------------------,-------------------,-------------------,
360             -------------------,-------------------,-------------------,-------------------,
361             -------------------,-------------------,-------------------,-------------------,
362             -------------------,-------------------,-------------------,-------------------,
363             0x386bfdba29       ,-------------------,0xcf8014760e       ,-------------------,
364             0x2fb1d8fe07b      ,-------------------,0xaf67a93bb37      ,-------------------,
365             0x285145f31a8f     ,-------------------,0x944620b0e5ee     ,-------------------,
366             0x2214d10d0112e    ,-------------------,0x7d56e7677738e    ,-------------------,
367             0x1ccf4b44bb20d0   ,-------------------,0x69f3d1c9210d27   ,-------------------,
368             0x185a82b87b5b294  ,-------------------,0x5990681d95d4371  ,-------------------,
369             0x14962dee9dbd672b ,-------------------,0x4bb5ecca961fb9bf ,-------------------,
370             0x116701e6ab0967080,-------------------,0x3fffffffffffe6652,-------------------,
371         };
372     */
373     function fixedExp(uint256 _x, uint8 _precision) constant returns (uint256) {
374         uint256 maxExp = MAX_FIXED_EXP_32;
375         for (uint8 p = 32; p < _precision; p += 2)
376             maxExp = (maxExp * 0xeb5ec5975959c565) >> (64-2);
377         
378         assert(_x <= maxExp);
379         return fixedExpUnsafe(_x, _precision);
380     }
381 
382     /**
383         fixedExp 
384         Calculates e ^ x according to maclauren summation:
385 
386         e^x = 1 + x + x ^ 2 / 2!...+ x ^ n / n!
387 
388         and returns e ^ (x >> 32) << 32, that is, upshifted for accuracy
389 
390         Input range:
391             - Function ok at    <= 242329958953 
392             - Function fails at >= 242329958954
393 
394         This method is is visible for testcases, but not meant for direct use. 
395  
396         The values in this method been generated via the following python snippet: 
397 
398         def calculateFactorials():
399             """Method to print out the factorials for fixedExp"""
400 
401             ni = []
402             ni.append(295232799039604140847618609643520000000) # 34!
403             ITERATIONS = 34
404             for n in range(1, ITERATIONS, 1) :
405                 ni.append(math.floor(ni[n - 1] / n))
406             print( "\n        ".join(["xi = (xi * _x) >> _precision;\n        res += xi * %s;" % hex(int(x)) for x in ni]))
407 
408     */
409     function fixedExpUnsafe(uint256 _x, uint8 _precision) constant returns (uint256) {
410         uint256 xi = _x;
411         uint256 res = uint256(0xde1bc4d19efcac82445da75b00000000) << _precision;
412 
413         res += xi * 0xde1bc4d19efcac82445da75b00000000;
414         xi = (xi * _x) >> _precision;
415         res += xi * 0x6f0de268cf7e5641222ed3ad80000000;
416         xi = (xi * _x) >> _precision;
417         res += xi * 0x2504a0cd9a7f7215b60f9be480000000;
418         xi = (xi * _x) >> _precision;
419         res += xi * 0x9412833669fdc856d83e6f920000000;
420         xi = (xi * _x) >> _precision;
421         res += xi * 0x1d9d4d714865f4de2b3fafea0000000;
422         xi = (xi * _x) >> _precision;
423         res += xi * 0x4ef8ce836bba8cfb1dff2a70000000;
424         xi = (xi * _x) >> _precision;
425         res += xi * 0xb481d807d1aa66d04490610000000;
426         xi = (xi * _x) >> _precision;
427         res += xi * 0x16903b00fa354cda08920c2000000;
428         xi = (xi * _x) >> _precision;
429         res += xi * 0x281cdaac677b334ab9e732000000;
430         xi = (xi * _x) >> _precision;
431         res += xi * 0x402e2aad725eb8778fd85000000;
432         xi = (xi * _x) >> _precision;
433         res += xi * 0x5d5a6c9f31fe2396a2af000000;
434         xi = (xi * _x) >> _precision;
435         res += xi * 0x7c7890d442a82f73839400000;
436         xi = (xi * _x) >> _precision;
437         res += xi * 0x9931ed54034526b58e400000;
438         xi = (xi * _x) >> _precision;
439         res += xi * 0xaf147cf24ce150cf7e00000;
440         xi = (xi * _x) >> _precision;
441         res += xi * 0xbac08546b867cdaa200000;
442         xi = (xi * _x) >> _precision;
443         res += xi * 0xbac08546b867cdaa20000;
444         xi = (xi * _x) >> _precision;
445         res += xi * 0xafc441338061b2820000;
446         xi = (xi * _x) >> _precision;
447         res += xi * 0x9c3cabbc0056d790000;
448         xi = (xi * _x) >> _precision;
449         res += xi * 0x839168328705c30000;
450         xi = (xi * _x) >> _precision;
451         res += xi * 0x694120286c049c000;
452         xi = (xi * _x) >> _precision;
453         res += xi * 0x50319e98b3d2c000;
454         xi = (xi * _x) >> _precision;
455         res += xi * 0x3a52a1e36b82000;
456         xi = (xi * _x) >> _precision;
457         res += xi * 0x289286e0fce000;
458         xi = (xi * _x) >> _precision;
459         res += xi * 0x1b0c59eb53400;
460         xi = (xi * _x) >> _precision;
461         res += xi * 0x114f95b55400;
462         xi = (xi * _x) >> _precision;
463         res += xi * 0xaa7210d200;
464         xi = (xi * _x) >> _precision;
465         res += xi * 0x650139600;
466         xi = (xi * _x) >> _precision;
467         res += xi * 0x39b78e80;
468         xi = (xi * _x) >> _precision;
469         res += xi * 0x1fd8080;
470         xi = (xi * _x) >> _precision;
471         res += xi * 0x10fbc0;
472         xi = (xi * _x) >> _precision;
473         res += xi * 0x8c40;
474         xi = (xi * _x) >> _precision;
475         res += xi * 0x462;
476         xi = (xi * _x) >> _precision;
477         res += xi * 0x22;
478 
479         return res / 0xde1bc4d19efcac82445da75b00000000;
480     }
481 }
482 
483 
484 contract BasicERC20Token {
485     /* Public variables of the token */
486     string public standard = 'Token 0.1';
487     string public name = 'Ivan\'s Trackable Token';
488     string public symbol = 'ITT';
489     uint8 public decimals = 18;
490     uint256 public totalSupply = 0;
491 
492     /* This creates an array with all balances */
493     mapping (address => uint256) public balances;
494     mapping (address => mapping (address => uint256)) public allowed;
495 
496     event Transfer(address indexed _from, address indexed _to, uint256 _value);
497     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
498 
499     event BalanceCheck(uint256 balance);
500 
501     function transfer(address _to, uint256 _value) returns (bool success) {
502         //Default assumes totalSupply can't be over max (2^256 - 1).
503         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
504         //Replace the if with this one instead.
505         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
506         if (balances[msg.sender] >= _value && _value > 0) {
507             balances[msg.sender] -= _value;
508             balances[_to] += _value;
509             Transfer(msg.sender, _to, _value);
510             return true;
511         } else { return false; }
512     }
513 
514     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
515         //same as above. Replace this line with the following if you want to protect against wrapping uints.
516         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
517         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
518             balances[_to] += _value;
519             balances[_from] -= _value;
520             allowed[_from][msg.sender] -= _value;
521             Transfer(_from, _to, _value);
522             return true;
523         } else { return false; }
524     }
525 
526     function balanceOf(address _owner) constant returns (uint256 balance) {
527         return balances[_owner];
528     }
529 
530     function approve(address _spender, uint256 _value) returns (bool success) {
531         allowed[msg.sender][_spender] = _value;
532         Approval(msg.sender, _spender, _value);
533         return true;
534     }
535 
536     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
537       return allowed[_owner][_spender];
538     }
539 
540     /* Functions below are specific to this token and
541      * not part of the ERC-20 standard */
542 
543     function deposit() payable returns (bool success) {
544         if (msg.value == 0) return false;
545         balances[msg.sender] += msg.value;
546         totalSupply += msg.value;
547         return true;
548     }
549 
550     function withdraw(uint256 amount) returns (bool success) {
551         if (balances[msg.sender] < amount) return false;
552         balances[msg.sender] -= amount;
553         totalSupply -= amount;
554         if (!msg.sender.send(amount)) {
555             balances[msg.sender] += amount;
556             totalSupply += amount;
557             return false;
558         }
559         return true;
560     }
561 
562 }
563 
564 
565 contract DummyBancorToken is BasicERC20Token, BancorFormula {
566 
567     string public standard = 'Token 0.1';
568     string public name = 'Dummy Constant Reserve Rate Token';
569     string public symbol = 'DBT';
570     uint8 public decimals = 18;
571     uint256 public totalSupply = 0;
572 
573     uint8 public ratio = 10; // CRR of 10%
574 
575     address public owner = 0x0;
576 
577     event Deposit(address indexed sender);
578     event Withdraw(uint256 amount);
579 
580     /* I can't make MyEtherWallet send payments as part of constructor calls
581      * while creating contracts. So instead of implementing a constructor,
582      * we follow the SetUp/TearDown paradigm */
583     function setUp(uint256 _initialSupply) payable {
584         if (owner != 0) return;
585         owner = msg.sender;
586         balances[msg.sender] = _initialSupply;
587         totalSupply = _initialSupply;
588     }
589 
590     function tearDown() {
591         if (msg.sender != owner) return;
592         selfdestruct(owner);
593     }
594 
595     function reserveBalance() constant returns (uint256) {
596         return this.balance;
597     }
598 
599     // Our reserve token is always ETH.
600     function deposit() payable returns (bool success) {
601         if (msg.value == 0) return false;
602         uint256 tokensPurchased = calculatePurchaseReturn(totalSupply, reserveBalance(), ratio, msg.value);
603         balances[msg.sender] += tokensPurchased;
604         totalSupply += tokensPurchased;
605         Deposit(msg.sender);
606         return true;
607     }
608 
609     function withdraw(uint256 amount) returns (bool success) {
610         if (balances[msg.sender] < amount) return false;
611         uint256 ethAmount = calculateSaleReturn(totalSupply, reserveBalance(), ratio, amount);
612         balances[msg.sender] -= amount;
613         totalSupply -= amount;
614         if (!msg.sender.send(ethAmount)) {
615             balances[msg.sender] += amount;
616             totalSupply += amount;
617             return false;
618         }
619         Withdraw(amount);
620         return true;
621     }
622 
623 }
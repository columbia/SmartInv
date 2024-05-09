1 // File: contracts\modules\Ownable.sol
2 
3 pragma solidity =0.5.16;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be applied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address internal _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: contracts\modules\whiteList.sol
80 
81 pragma solidity =0.5.16;
82     /**
83      * @dev Implementation of a whitelist which filters a eligible uint32.
84      */
85 library whiteListUint32 {
86     /**
87      * @dev add uint32 into white list.
88      * @param whiteList the storage whiteList.
89      * @param temp input value
90      */
91 
92     function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{
93         if (!isEligibleUint32(whiteList,temp)){
94             whiteList.push(temp);
95         }
96     }
97     /**
98      * @dev remove uint32 from whitelist.
99      */
100     function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {
101         uint256 len = whiteList.length;
102         uint256 i=0;
103         for (;i<len;i++){
104             if (whiteList[i] == temp)
105                 break;
106         }
107         if (i<len){
108             if (i!=len-1) {
109                 whiteList[i] = whiteList[len-1];
110             }
111             whiteList.length--;
112             return true;
113         }
114         return false;
115     }
116     function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){
117         uint256 len = whiteList.length;
118         for (uint256 i=0;i<len;i++){
119             if (whiteList[i] == temp)
120                 return true;
121         }
122         return false;
123     }
124     function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){
125         uint256 len = whiteList.length;
126         uint256 i=0;
127         for (;i<len;i++){
128             if (whiteList[i] == temp)
129                 break;
130         }
131         return i;
132     }
133 }
134     /**
135      * @dev Implementation of a whitelist which filters a eligible uint256.
136      */
137 library whiteListUint256 {
138     // add whiteList
139     function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{
140         if (!isEligibleUint256(whiteList,temp)){
141             whiteList.push(temp);
142         }
143     }
144     function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {
145         uint256 len = whiteList.length;
146         uint256 i=0;
147         for (;i<len;i++){
148             if (whiteList[i] == temp)
149                 break;
150         }
151         if (i<len){
152             if (i!=len-1) {
153                 whiteList[i] = whiteList[len-1];
154             }
155             whiteList.length--;
156             return true;
157         }
158         return false;
159     }
160     function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){
161         uint256 len = whiteList.length;
162         for (uint256 i=0;i<len;i++){
163             if (whiteList[i] == temp)
164                 return true;
165         }
166         return false;
167     }
168     function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){
169         uint256 len = whiteList.length;
170         uint256 i=0;
171         for (;i<len;i++){
172             if (whiteList[i] == temp)
173                 break;
174         }
175         return i;
176     }
177 }
178     /**
179      * @dev Implementation of a whitelist which filters a eligible address.
180      */
181 library whiteListAddress {
182     // add whiteList
183     function addWhiteListAddress(address[] storage whiteList,address temp) internal{
184         if (!isEligibleAddress(whiteList,temp)){
185             whiteList.push(temp);
186         }
187     }
188     function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {
189         uint256 len = whiteList.length;
190         uint256 i=0;
191         for (;i<len;i++){
192             if (whiteList[i] == temp)
193                 break;
194         }
195         if (i<len){
196             if (i!=len-1) {
197                 whiteList[i] = whiteList[len-1];
198             }
199             whiteList.length--;
200             return true;
201         }
202         return false;
203     }
204     function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){
205         uint256 len = whiteList.length;
206         for (uint256 i=0;i<len;i++){
207             if (whiteList[i] == temp)
208                 return true;
209         }
210         return false;
211     }
212     function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){
213         uint256 len = whiteList.length;
214         uint256 i=0;
215         for (;i<len;i++){
216             if (whiteList[i] == temp)
217                 break;
218         }
219         return i;
220     }
221 }
222 
223 // File: contracts\modules\Operator.sol
224 
225 pragma solidity =0.5.16;
226 
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * each operator can be granted exclusive access to specific functions.
231  *
232  */
233 contract Operator is Ownable {
234     using whiteListAddress for address[];
235     address[] private _operatorList;
236     /**
237      * @dev modifier, every operator can be granted exclusive access to specific functions. 
238      *
239      */
240     modifier onlyOperator() {
241         require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");
242         _;
243     }
244     /**
245      * @dev modifier, Only indexed operator can be granted exclusive access to specific functions. 
246      *
247      */
248     modifier onlyOperatorIndex(uint256 index) {
249         require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");
250         _;
251     }
252     /**
253      * @dev add a new operator by owner. 
254      *
255      */
256     function addOperator(address addAddress)public onlyOwner{
257         _operatorList.addWhiteListAddress(addAddress);
258     }
259     /**
260      * @dev modify indexed operator by owner. 
261      *
262      */
263     function setOperator(uint256 index,address addAddress)public onlyOwner{
264         _operatorList[index] = addAddress;
265     }
266     /**
267      * @dev remove operator by owner. 
268      *
269      */
270     function removeOperator(address removeAddress)public onlyOwner returns (bool){
271         return _operatorList.removeWhiteListAddress(removeAddress);
272     }
273     /**
274      * @dev get all operators. 
275      *
276      */
277     function getOperator()public view returns (address[] memory) {
278         return _operatorList;
279     }
280     /**
281      * @dev set all operators by owner. 
282      *
283      */
284     function setOperators(address[] memory operators)public onlyOwner {
285         _operatorList = operators;
286     }
287 }
288 
289 // File: contracts\modules\SmallNumbers.sol
290 
291 pragma solidity =0.5.16;
292     /**
293      * @dev Implementation of a Fraction number operation library.
294      */
295 library SmallNumbers {
296 //    using Fraction for fractionNumber;
297     int256 constant private sqrtNum = 1<<120;
298     int256 constant private shl = 80;
299     uint8 constant private PRECISION   = 32;  // fractional bits
300     uint256 constant public FIXED_ONE = uint256(1) << PRECISION; // 0x100000000
301     int256 constant public FIXED_64 = 1 << 64; // 0x100000000
302     uint256 constant private FIXED_TWO = uint256(2) << PRECISION; // 0x200000000
303     int256 constant private FIXED_SIX = int256(6) << PRECISION; // 0x200000000
304     uint256 constant private MAX_VAL   = uint256(1) << (256 - PRECISION); // 0x0000000100000000000000000000000000000000000000000000000000000000
305 
306     /**
307      * @dev Standard normal cumulative distribution function
308      */
309     function normsDist(int256 xNum) internal pure returns (int256) {
310         bool _isNeg = xNum<0;
311         if (_isNeg) {
312             xNum = -xNum;
313         }
314         if (xNum > FIXED_SIX){
315             return _isNeg ? 0 : int256(FIXED_ONE);
316         } 
317         // constant int256 b1 = 1371733226;
318         // constant int256 b2 = -1531429783;
319         // constant int256 b3 = 7651389478;
320         // constant int256 b4 = -7822234863;
321         // constant int256 b5 = 5713485167;
322         //t = 1.0/(1.0 + p*x);
323         int256 p = 994894385;
324         int256 t = FIXED_64/(((p*xNum)>>PRECISION)+int256(FIXED_ONE));
325         //double val = 1 - (1/(Math.sqrt(2*Math.PI))  * Math.exp(-1*Math.pow(a, 2)/2)) * (b1*t + b2 * Math.pow(t,2) + b3*Math.pow(t,3) + b4 * Math.pow(t,4) + b5 * Math.pow(t,5) );
326         //1.0 - (-x * x / 2.0).exp()/ (2.0*pi()).sqrt() * t * (a1 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429)))) ;
327         xNum=xNum*xNum/int256(FIXED_TWO);
328         xNum = int256(7359186145390886912/fixedExp(uint256(xNum)));
329         int256 tt = t;
330         int256 All = 1371733226*tt;
331         tt = (tt*t)>>PRECISION;
332         All += -1531429783*tt;
333         tt = (tt*t)>>PRECISION;
334         All += 7651389478*tt;
335         tt = (tt*t)>>PRECISION;
336         All += -7822234863*tt;
337         tt = (tt*t)>>PRECISION;
338         All += 5713485167*tt;
339         xNum = (xNum*All)>>64;
340         if (!_isNeg) {
341             xNum = uint64(FIXED_ONE) - xNum;
342         }
343         return xNum;
344     }
345     function pow(uint256 _x,uint256 _y) internal pure returns (uint256){
346         _x = (ln(_x)*_y)>>PRECISION;
347         return fixedExp(_x);
348     }
349 
350     //This is where all your gas goes, sorry
351     //Not sorry, you probably only paid 1 gwei
352     function sqrt(uint x) internal pure returns (uint y) {
353         x = x << PRECISION;
354         uint z = (x + 1) / 2;
355         y = x;
356         while (z < y) {
357             y = z;
358             z = (x / z + z) / 2;
359         }
360     }
361     function ln(uint256 _x)  internal pure returns (uint256) {
362         return fixedLoge(_x);
363     }
364         /**
365         input range: 
366             [0x100000000,uint256_max]
367         output range:
368             [0, 0x9b43d4f8d6]
369 
370         This method asserts outside of bounds
371 
372     */
373     function fixedLoge(uint256 _x) internal pure returns (uint256 logE) {
374         /*
375         Since `fixedLog2_min` output range is max `0xdfffffffff` 
376         (40 bits, or 5 bytes), we can use a very large approximation
377         for `ln(2)`. This one is used since it’s the max accuracy 
378         of Python `ln(2)`
379 
380         0xb17217f7d1cf78 = ln(2) * (1 << 56)
381         
382         */
383         //Cannot represent negative numbers (below 1)
384         require(_x >= FIXED_ONE,"loge function input is too small");
385 
386         uint256 _log2 = fixedLog2(_x);
387         logE = (_log2 * 0xb17217f7d1cf78) >> 56;
388     }
389 
390     /**
391         Returns log2(x >> 32) << 32 [1]
392         So x is assumed to be already upshifted 32 bits, and 
393         the result is also upshifted 32 bits. 
394         
395         [1] The function returns a number which is lower than the 
396         actual value
397 
398         input-range : 
399             [0x100000000,uint256_max]
400         output-range: 
401             [0,0xdfffffffff]
402 
403         This method asserts outside of bounds
404 
405     */
406     function fixedLog2(uint256 _x) internal pure returns (uint256) {
407         // Numbers below 1 are negative. 
408         require( _x >= FIXED_ONE,"Log2 input is too small");
409 
410         uint256 hi = 0;
411         while (_x >= FIXED_TWO) {
412             _x >>= 1;
413             hi += FIXED_ONE;
414         }
415 
416         for (uint8 i = 0; i < PRECISION; ++i) {
417             _x = (_x * _x) / FIXED_ONE;
418             if (_x >= FIXED_TWO) {
419                 _x >>= 1;
420                 hi += uint256(1) << (PRECISION - 1 - i);
421             }
422         }
423 
424         return hi;
425     }
426     function exp(int256 _x)internal pure returns (uint256){
427         bool _isNeg = _x<0;
428         if (_isNeg) {
429             _x = -_x;
430         }
431         uint256 value = fixedExp(uint256(_x));
432         if (_isNeg){
433             return uint256(FIXED_64) / value;
434         }
435         return value;
436     }
437     /**
438         fixedExp is a ‘protected’ version of `fixedExpUnsafe`, which 
439         asserts instead of overflows
440     */
441     function fixedExp(uint256 _x) internal pure returns (uint256) {
442         require(_x <= 0x386bfdba29,"exp function input is overflow");
443         return fixedExpUnsafe(_x);
444     }
445        /**
446         fixedExp 
447         Calculates e^x according to maclauren summation:
448 
449         e^x = 1+x+x^2/2!...+x^n/n!
450 
451         and returns e^(x>>32) << 32, that is, upshifted for accuracy
452 
453         Input range:
454             - Function ok at    <= 242329958953 
455             - Function fails at >= 242329958954
456 
457         This method is is visible for testcases, but not meant for direct use. 
458  
459         The values in this method been generated via the following python snippet: 
460 
461         def calculateFactorials():
462             “”"Method to print out the factorials for fixedExp”“”
463 
464             ni = []
465             ni.append( 295232799039604140847618609643520000000) # 34!
466             ITERATIONS = 34
467             for n in range( 1,  ITERATIONS,1 ) :
468                 ni.append(math.floor(ni[n - 1] / n))
469             print( “\n        “.join([“xi = (xi * _x) >> PRECISION;\n        res += xi * %s;” % hex(int(x)) for x in ni]))
470 
471     */
472     function fixedExpUnsafe(uint256 _x) internal pure returns (uint256) {
473     
474         uint256 xi = FIXED_ONE;
475         uint256 res = 0xde1bc4d19efcac82445da75b00000000 * xi;
476 
477         xi = (xi * _x) >> PRECISION;
478         res += xi * 0xde1bc4d19efcb0000000000000000000;
479         xi = (xi * _x) >> PRECISION;
480         res += xi * 0x6f0de268cf7e58000000000000000000;
481         xi = (xi * _x) >> PRECISION;
482         res += xi * 0x2504a0cd9a7f72000000000000000000;
483         xi = (xi * _x) >> PRECISION;
484         res += xi * 0x9412833669fdc800000000000000000;
485         xi = (xi * _x) >> PRECISION;
486         res += xi * 0x1d9d4d714865f500000000000000000;
487         xi = (xi * _x) >> PRECISION;
488         res += xi * 0x4ef8ce836bba8c0000000000000000;
489         xi = (xi * _x) >> PRECISION;
490         res += xi * 0xb481d807d1aa68000000000000000;
491         xi = (xi * _x) >> PRECISION;
492         res += xi * 0x16903b00fa354d000000000000000;
493         xi = (xi * _x) >> PRECISION;
494         res += xi * 0x281cdaac677b3400000000000000;
495         xi = (xi * _x) >> PRECISION;
496         res += xi * 0x402e2aad725eb80000000000000;
497         xi = (xi * _x) >> PRECISION;
498         res += xi * 0x5d5a6c9f31fe24000000000000;
499         xi = (xi * _x) >> PRECISION;
500         res += xi * 0x7c7890d442a83000000000000;
501         xi = (xi * _x) >> PRECISION;
502         res += xi * 0x9931ed540345280000000000;
503         xi = (xi * _x) >> PRECISION;
504         res += xi * 0xaf147cf24ce150000000000;
505         xi = (xi * _x) >> PRECISION;
506         res += xi * 0xbac08546b867d000000000;
507         xi = (xi * _x) >> PRECISION;
508         res += xi * 0xbac08546b867d00000000;
509         xi = (xi * _x) >> PRECISION;
510         res += xi * 0xafc441338061b8000000;
511         xi = (xi * _x) >> PRECISION;
512         res += xi * 0x9c3cabbc0056e000000;
513         xi = (xi * _x) >> PRECISION;
514         res += xi * 0x839168328705c80000;
515         xi = (xi * _x) >> PRECISION;
516         res += xi * 0x694120286c04a0000;
517         xi = (xi * _x) >> PRECISION;
518         res += xi * 0x50319e98b3d2c400;
519         xi = (xi * _x) >> PRECISION;
520         res += xi * 0x3a52a1e36b82020;
521         xi = (xi * _x) >> PRECISION;
522         res += xi * 0x289286e0fce002;
523         xi = (xi * _x) >> PRECISION;
524         res += xi * 0x1b0c59eb53400;
525         xi = (xi * _x) >> PRECISION;
526         res += xi * 0x114f95b55400;
527         xi = (xi * _x) >> PRECISION;
528         res += xi * 0xaa7210d200;
529         xi = (xi * _x) >> PRECISION;
530         res += xi * 0x650139600;
531         xi = (xi * _x) >> PRECISION;
532         res += xi * 0x39b78e80;
533         xi = (xi * _x) >> PRECISION;
534         res += xi * 0x1fd8080;
535         xi = (xi * _x) >> PRECISION;
536         res += xi * 0x10fbc0;
537         xi = (xi * _x) >> PRECISION;
538         res += xi * 0x8c40;
539         xi = (xi * _x) >> PRECISION;
540         res += xi * 0x462;
541         xi = (xi * _x) >> PRECISION;
542         res += xi * 0x22;
543 
544         return res / 0xde1bc4d19efcac82445da75b00000000;
545     }  
546 }
547 
548 // File: contracts\impliedVolatility.sol
549 
550 pragma solidity =0.5.16;
551 
552 
553 /**
554  * @title Options Implied volatility calculation.
555  * @dev A Smart-contract to calculate options Implied volatility.
556  *
557  */
558 contract ImpliedVolatility is Operator {
559     //Implied volatility decimal, is same with oracle's price' decimal. 
560     uint256 constant private _calDecimal = 1e8;
561     // A constant day time
562     uint256 constant private DaySecond = 1 days;
563     // Formulas param, atm Implied volatility, which expiration is one day.
564     struct ivParam {
565         int48 a;
566         int48 b;
567         int48 c;
568         int48 d;
569         int48 e; 
570     }
571     mapping(uint32=>uint256) internal ATMIv0;
572     // Formulas param A,B,C,D,E
573     mapping(uint32=>ivParam) internal ivParamMap;
574     // Formulas param ATM Iv Rate, sort by time
575     mapping(uint32=>uint64[]) internal ATMIvRate;
576 
577     constructor () public{
578         ATMIv0[1] = 48730000;
579         ivParamMap[1] = ivParam(-38611755991,38654705664,-214748365,214748365,4294967296);
580         ATMIvRate[1] = [4294967296,4446428991,4537492540,4603231970,4654878626,4697506868,4733852952,4765564595,4793712531,4819032567,
581                 4842052517,4863164090,4882666130,4900791915,4917727094,4933621868,4948599505,4962762438,4976196728,4988975383,
582                 5001160887,5012807130,5023960927,5034663202,5044949946,5054852979,5064400575,5073617969,5082527781,5091150366,
583                 5099504108,5107605667,5115470191,5123111489,5130542192,5137773878,5144817188,5151681926,5158377145,5164911220,
584                 5171291916,5177526445,5183621518,5189583392,5195417907,5201130526,5206726363,5212210216,5217586590,5222859721,
585                 5228033600,5233111985,5238098426,5242996276,5247808706,5252538720,5257189164,5261762736,5266262001,5270689395,
586                 5275047237,5279337732,5283562982,5287724992,5291825675,5295866857,5299850284,5303777626,5307650478,5311470372,
587                 5315238771,5318957082,5322626652,5326248774,5329824691,5333355597,5336842639,5340286922,5343689509,5347051421,
588                 5350373645,5353657131,5356902795,5360111520,5363284160,5366421536,5369524445,5372593655,5375629909,5378633924];
589         ATMIv0[2] = 48730000;
590         ivParamMap[2] = ivParam(-38611755991,38654705664,-214748365,214748365,4294967296);
591         ATMIvRate[2] =  ATMIvRate[1];
592         //mkr
593         ATMIv0[3] = 150000000;
594         ivParamMap[3] = ivParam(-38611755991,38654705664,-214748365,214748365,4294967296);
595         ATMIvRate[3] =  ATMIvRate[1];
596         //snx
597         ATMIv0[4] = 200000000;
598         ivParamMap[4] = ivParam(-38611755991,38654705664,-214748365,214748365,4294967296);
599         ATMIvRate[4] =  ATMIvRate[1];
600         //link
601         ATMIv0[5] = 180000000;
602         ivParamMap[5] = ivParam(-38611755991,38654705664,-214748365,214748365,4294967296);
603         ATMIvRate[5] =  ATMIvRate[1];
604     }
605     /**
606      * @dev set underlying's atm implied volatility. Foundation operator will modify it frequently.
607      * @param underlying underlying ID.,1 for BTC, 2 for ETH
608      * @param _Iv0 underlying's atm implied volatility. 
609      */ 
610     function SetAtmIv(uint32 underlying,uint256 _Iv0)public onlyOperatorIndex(0){
611         ATMIv0[underlying] = _Iv0;
612     }
613     function getAtmIv(uint32 underlying)public view returns(uint256){
614         return ATMIv0[underlying];
615     }
616     /**
617      * @dev set implied volatility surface Formulas param. 
618      * @param underlying underlying ID.,1 for BTC, 2 for ETH
619      */ 
620     function SetFormulasParam(uint32 underlying,int48 _paramA,int48 _paramB,int48 _paramC,int48 _paramD,int48 _paramE)
621         public onlyOwner{
622         ivParamMap[underlying] = ivParam(_paramA,_paramB,_paramC,_paramD,_paramE);
623     }
624     /**
625      * @dev set implied volatility surface Formulas param IvRate. 
626      * @param underlying underlying ID.,1 for BTC, 2 for ETH
627      */ 
628     function SetATMIvRate(uint32 underlying,uint64[] memory IvRate)public onlyOwner{
629         ATMIvRate[underlying] = IvRate;
630     }
631     /**
632      * @dev Interface, calculate option's iv. 
633      * @param underlying underlying ID.,1 for BTC, 2 for ETH
634      * optType option's type.,0 for CALL, 1 for PUT
635      * @param expiration Option's expiration, left time to now.
636      * @param currentPrice underlying current price
637      * @param strikePrice option's strike price
638      */ 
639     function calculateIv(uint32 underlying,uint8 /*optType*/,uint256 expiration,uint256 currentPrice,uint256 strikePrice)public view returns (uint256){
640         if (underlying>2){
641             return (ATMIv0[underlying]<<32)/_calDecimal;
642         }
643         uint256 iv = calATMIv(underlying,expiration);
644         if (currentPrice == strikePrice){
645             return iv;
646         }
647         return calImpliedVolatility(underlying,iv,currentPrice,strikePrice);
648     }
649     /**
650      * @dev calculate option's atm iv. 
651      * @param underlying underlying ID.,1 for BTC, 2 for ETH
652      * @param expiration Option's expiration, left time to now.
653      */ 
654     function calATMIv(uint32 underlying,uint256 expiration)internal view returns(uint256){
655         uint256 index = expiration/DaySecond;
656         
657         if (index == 0){
658             return (ATMIv0[underlying]<<32)/_calDecimal;
659         }
660         uint256 len = ATMIvRate[underlying].length;
661         if (index>=len){
662             index = len-1;
663         }
664         uint256 rate = insertValue(index*DaySecond,(index+1)*DaySecond,ATMIvRate[underlying][index-1],ATMIvRate[underlying][index],expiration);
665         return ATMIv0[underlying]*rate/_calDecimal;
666     }
667     /**
668      * @dev calculate option's implied volatility. 
669      * @param underlying underlying ID.,1 for BTC, 2 for ETH
670      * @param _ATMIv atm iv, calculated by calATMIv
671      * @param currentPrice underlying current price
672      * @param strikePrice option's strike price
673      */ 
674     function calImpliedVolatility(uint32 underlying,uint256 _ATMIv,uint256 currentPrice,uint256 strikePrice)internal view returns(uint256){
675         ivParam memory param = ivParamMap[underlying];
676         int256 ln = calImpliedVolLn(underlying,currentPrice,strikePrice,param.d);
677         //ln*ln+e
678         uint256 lnSqrt = uint256(((ln*ln)>>32) + param.e);
679         lnSqrt = SmallNumbers.sqrt(lnSqrt);
680         //ln*c+sqrt
681         ln = ((ln*param.c)>>32) + int256(lnSqrt);
682         ln = (ln* param.b + int256(_ATMIv*_ATMIv))>>32;
683         return SmallNumbers.sqrt(uint256(ln+param.a));
684     }
685     /**
686      * @dev An auxiliary function, calculate ln price. 
687      * @param underlying underlying ID.,1 for BTC, 2 for ETH
688      * @param currentPrice underlying current price
689      * @param strikePrice option's strike price
690      */ 
691     //ln(k) - ln(s) + d
692     function calImpliedVolLn(uint32 underlying,uint256 currentPrice,uint256 strikePrice,int48 paramd)internal view returns(int256){
693         if (currentPrice == strikePrice){
694             return paramd;
695         }else if (currentPrice > strikePrice){
696             return int256(SmallNumbers.fixedLoge((currentPrice<<32)/strikePrice))+paramd;
697         }else{
698             return -int256(SmallNumbers.fixedLoge((strikePrice<<32)/currentPrice))+paramd;
699         }
700     }
701     /**
702      * @dev An auxiliary function, Linear interpolation. 
703      */ 
704     function insertValue(uint256 x0,uint256 x1,uint256 y0, uint256 y1,uint256 x)internal pure returns (uint256){
705         require(x1 != x0,"input values are duplicated!");
706         return y0 + (y1-y0)*(x-x0)/(x1-x0);
707     }
708 
709 }
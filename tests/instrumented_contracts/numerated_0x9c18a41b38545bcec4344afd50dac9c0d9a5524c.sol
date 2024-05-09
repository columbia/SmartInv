1 pragma solidity ^0.4.11;
2 
3 // SafeMath Taken From FirstBlood
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint a, uint b) internal returns (uint) {
12         assert(b > 0);
13         uint c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint a, uint b) internal returns (uint) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c>=a && c>=b);
26         return c;
27     }
28 }
29 
30 // ERC20 Interface
31 contract ERC20 {
32     function totalSupply() constant returns (uint totalSupply);
33     function balanceOf(address _owner) constant returns (uint balance);
34     function transfer(address _to, uint _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) returns (bool success);
36     function approve(address _spender, uint _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint remaining);
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 
42 // ERC20Token
43 contract ERC20Token is ERC20, SafeMath {
44 
45     mapping(address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     uint256 public totalTokens; 
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] = safeSub(balances[msg.sender], _value);
52             balances[_to] = safeAdd(balances[_to], _value);
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         var _allowance = allowed[_from][msg.sender];
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63             balances[_to] = safeAdd(balances[_to], _value);
64             balances[_from] = safeSub(balances[_from], _value);
65             allowed[_from][msg.sender] = safeSub(_allowance, _value);
66             Transfer(_from, _to, _value);
67             return true;
68         } else {
69             return false;
70         }
71     }
72 
73     function totalSupply() constant returns (uint256) {
74         return totalTokens;
75     }
76 
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 }
91 
92 contract Wolk is ERC20Token {
93 
94     // TOKEN INFO
95     string  public constant name = "Wolk Protocol Token";
96     string  public constant symbol = "WOLK";
97     uint256 public constant decimals = 18;
98 
99     // RESERVE
100     uint256 public reserveBalance = 0; 
101     uint16  public constant percentageETHReserve = 20;
102 
103     // CONTRACT OWNER
104     address public owner = msg.sender;      
105     address public multisigWallet;
106     modifier onlyOwner { assert(msg.sender == owner); _; }
107 
108     // TOKEN GENERATION EVENT
109     mapping (address => uint256) contribution;
110     uint256 public constant tokenGenerationMin = 50 * 10**6 * 10**decimals;
111     uint256 public constant tokenGenerationMax = 500 * 10**6 * 10**decimals;
112     uint256 public start_block; 
113     uint256 public end_block;
114     bool    public saleCompleted = false;
115     modifier isTransferable { assert(saleCompleted); _; }
116 
117     // WOLK SETTLERS
118     mapping (address => bool) settlers;
119     modifier onlySettler { assert(settlers[msg.sender] == true); _; }
120 
121     // TOKEN GENERATION EVENTLOG
122     event WolkCreated(address indexed _to, uint256 _tokenCreated);
123     event WolkDestroyed(address indexed _from, uint256 _tokenDestroyed);
124     event LogRefund(address indexed _to, uint256 _value);
125 
126     // @param _startBlock
127     // @param _endBlock
128     // @param _wolkWallet
129     // @return success
130     // @dev Wolk Genesis Event [only accessible by Contract Owner]
131     function wolkGenesis(uint256 _startBlock, uint256 _endBlock, address _wolkWallet) onlyOwner returns (bool success){
132         require( (totalTokens < 1) && (!settlers[msg.sender]) && (_endBlock > _startBlock) );
133         start_block = _startBlock;
134         end_block = _endBlock;
135         multisigWallet = _wolkWallet;
136         settlers[msg.sender] = true;
137         return true;
138     }
139 
140     // @param _newOwner
141     // @return success
142     // @dev Transfering Contract Ownership. [only accessible by current Contract Owner]
143     function changeOwner(address _newOwner) onlyOwner returns (bool success){
144         owner = _newOwner;
145         settlers[_newOwner] = true;
146         return true;
147     }
148 
149     // @dev Token Generation Event for Wolk Protocol Token. TGE Participant send Eth into this func in exchange of Wolk Protocol Token
150     function tokenGenerationEvent() payable external {
151         require(!saleCompleted);
152         require( (block.number >= start_block) && (block.number <= end_block) );
153         uint256 tokens = safeMul(msg.value, 5*10**9); //exchange rate
154         uint256 checkedSupply = safeAdd(totalTokens, tokens);
155         require(checkedSupply <= tokenGenerationMax);
156         totalTokens = checkedSupply;
157         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);  
158         contribution[msg.sender] = safeAdd(contribution[msg.sender], msg.value);  
159         WolkCreated(msg.sender, tokens); // logs token creation
160     }
161 
162     // @dev If Token Generation Minimum is Not Met, TGE Participants can call this func and request for refund
163     function refund() external {
164         require( (contribution[msg.sender] > 0) && (!saleCompleted) && (totalTokens < tokenGenerationMin) && (block.number > end_block) );
165         uint256 tokenBalance = balances[msg.sender];
166         uint256 refundBalance = contribution[msg.sender];
167         balances[msg.sender] = 0;
168         contribution[msg.sender] = 0;
169         totalTokens = safeSub(totalTokens, tokenBalance);
170         WolkDestroyed(msg.sender, tokenBalance);
171         LogRefund(msg.sender, refundBalance);
172         msg.sender.transfer(refundBalance); 
173     }
174 
175     // @dev Finalizing the Token Generation Event. 20% of Eth will be kept in contract to provide liquidity
176     function finalize() onlyOwner {
177         require( (!saleCompleted) && (totalTokens >= tokenGenerationMin) );
178         saleCompleted = true;
179         end_block = block.number;
180         reserveBalance = safeDiv(safeMul(this.balance, percentageETHReserve), 100);
181         var withdrawalBalance = safeSub(this.balance, reserveBalance);
182         msg.sender.transfer(withdrawalBalance);
183     }
184 }
185 
186 contract WolkProtocol is Wolk {
187 
188     // WOLK NETWORK PROTOCOL
189     uint256 public burnBasisPoints = 500;  // Burn rate (in BP) when Service Provider withdraws from data buyers' accounts
190     mapping (address => mapping (address => bool)) authorized; // holds which accounts have approved which Service Providers
191     mapping (address => uint256) feeBasisPoints;   // Fee (in BP) earned by Service Provider when depositing to data seller 
192 
193     // WOLK PROTOCOL Events:
194     event AuthorizeServiceProvider(address indexed _owner, address _serviceProvider);
195     event DeauthorizeServiceProvider(address indexed _owner, address _serviceProvider);
196     event SetServiceProviderFee(address indexed _serviceProvider, uint256 _feeBasisPoints);
197     event BurnTokens(address indexed _from, address indexed _serviceProvider, uint256 _value);
198 
199     // @param  _burnBasisPoints
200     // @return success
201     // @dev Set BurnRate on Wolk Protocol -- only Wolk Foundation can set this, affects Service Provider settleBuyer
202     function setBurnRate(uint256 _burnBasisPoints) onlyOwner returns (bool success) {
203         require( (_burnBasisPoints > 0) && (_burnBasisPoints <= 1000) );
204         burnBasisPoints = _burnBasisPoints;
205         return true;
206     }
207 
208     // @param  _serviceProvider
209     // @param  _feeBasisPoints
210     // @return success
211     // @dev Set Service Provider fee -- only Contract Owner can do this, affects Service Provider settleSeller
212     function setServiceFee(address _serviceProvider, uint256 _feeBasisPoints) onlyOwner returns (bool success) {
213         if ( _feeBasisPoints <= 0 || _feeBasisPoints > 4000){
214             // revoke Settler privilege
215             settlers[_serviceProvider] = false;
216             feeBasisPoints[_serviceProvider] = 0;
217             return false;
218         }else{
219             feeBasisPoints[_serviceProvider] = _feeBasisPoints;
220             settlers[_serviceProvider] = true;
221             SetServiceProviderFee(_serviceProvider, _feeBasisPoints);
222             return true;
223         }
224     }
225 
226     // @param  _serviceProvider
227     // @return _feeBasisPoints
228     // @dev Check service ee (in BP) for a given provider
229     function checkServiceFee(address _serviceProvider) constant returns (uint256 _feeBasisPoints) {
230         return feeBasisPoints[_serviceProvider];
231     }
232 
233     // @param  _buyer
234     // @param  _value
235     // @return success
236     // @dev Service Provider Settlement with Buyer: a small percent is burnt (set in setBurnRate, stored in burnBasisPoints) when funds are transferred from buyer to Service Provider [only accessible by settlers]
237     function settleBuyer(address _buyer, uint256 _value) onlySettler returns (bool success) {
238         require( (burnBasisPoints > 0) && (burnBasisPoints <= 1000) && authorized[_buyer][msg.sender] ); // Buyer must authorize Service Provider 
239         if ( balances[_buyer] >= _value && _value > 0) {
240             var burnCap = safeDiv(safeMul(_value, burnBasisPoints), 10000);
241             var transferredToServiceProvider = safeSub(_value, burnCap);
242             balances[_buyer] = safeSub(balances[_buyer], _value);
243             balances[msg.sender] = safeAdd(balances[msg.sender], transferredToServiceProvider);
244             totalTokens = safeSub(totalTokens, burnCap);
245             Transfer(_buyer, msg.sender, transferredToServiceProvider);
246             BurnTokens(_buyer, msg.sender, burnCap);
247             return true;
248         } else {
249             return false;
250         }
251     } 
252 
253     // @param  _seller
254     // @param  _value
255     // @return success
256     // @dev Service Provider Settlement with Seller: a small percent is kept by Service Provider (set in setServiceFee, stored in feeBasisPoints) when funds are transferred from Service Provider to seller [only accessible by settlers]
257     function settleSeller(address _seller, uint256 _value) onlySettler returns (bool success) {
258         // Service Providers have a % fee for Sellers (e.g. 20%)
259         var serviceProviderBP = feeBasisPoints[msg.sender];
260         require( (serviceProviderBP > 0) && (serviceProviderBP <= 4000) );
261         if (balances[msg.sender] >= _value && _value > 0) {
262             var fee = safeDiv(safeMul(_value, serviceProviderBP), 10000);
263             var transferredToSeller = safeSub(_value, fee);
264             balances[_seller] = safeAdd(balances[_seller], transferredToSeller);
265             Transfer(msg.sender, _seller, transferredToSeller);
266             return true;
267         } else {
268             return false;
269         }
270     }
271 
272     // @param _providerToAdd
273     // @return success
274     // @dev Buyer authorizes the Service Provider (to call settleBuyer). For security reason, _providerToAdd needs to be whitelisted by Wolk Foundation first
275     function authorizeProvider(address _providerToAdd) returns (bool success) {
276         require(settlers[_providerToAdd]);
277         authorized[msg.sender][_providerToAdd] = true;
278         AuthorizeServiceProvider(msg.sender, _providerToAdd);
279         return true;
280     }
281 
282     // @param _providerToRemove
283     // @return success
284     // @dev Buyer deauthorizes the Service Provider (from calling settleBuyer)
285     function deauthorizeProvider(address _providerToRemove) returns (bool success) {
286         authorized[msg.sender][_providerToRemove] = false;
287         DeauthorizeServiceProvider(msg.sender, _providerToRemove);
288         return true;
289     }
290 
291     // @param _owner
292     // @param _serviceProvider
293     // @return authorizationStatus
294     // @dev Check authorization between account and Service Provider
295     function checkAuthorization(address _owner, address _serviceProvider) constant returns (bool authorizationStatus) {
296         return authorized[_owner][_serviceProvider];
297     }
298 
299     // @param _owner
300     // @param _providerToAdd
301     // @return authorizationStatus
302     // @dev Grant authorization between account and Service Provider on buyers' behalf [only accessible by Contract Owner]
303     // @note Explicit permission from balance owner MUST be obtained beforehand
304     function grantService(address _owner, address _providerToAdd) onlyOwner returns (bool authorizationStatus) {
305         var isPreauthorized = authorized[_owner][msg.sender];
306         if (isPreauthorized && settlers[_providerToAdd] ) {
307             authorized[_owner][_providerToAdd] = true;
308             AuthorizeServiceProvider(msg.sender, _providerToAdd);
309             return true;
310         }else{
311             return false;
312         }
313     }
314 
315     // @param _owner
316     // @param _providerToRemove
317     // @return authorization_status
318     // @dev Revoke authorization between account and Service Provider on buyers' behalf [only accessible by Contract Owner]
319     // @note Explicit permission from balance owner are NOT required for disabling ill-intent Service Provider
320     function removeService(address _owner, address _providerToRemove) onlyOwner returns (bool authorizationStatus) {
321         authorized[_owner][_providerToRemove] = false;
322         DeauthorizeServiceProvider(_owner, _providerToRemove);
323         return true;
324     }
325 }
326 
327 contract BancorFormula is SafeMath {
328 
329     // Taken from https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/BancorFormula.sol
330     uint8 constant PRECISION   = 32;  // fractional bits
331     uint256 constant FIXED_ONE = uint256(1) << PRECISION; // 0x100000000
332     uint256 constant FIXED_TWO = uint256(2) << PRECISION; // 0x200000000
333     uint256 constant MAX_VAL   = uint256(1) << (256 - PRECISION); // 0x0000000100000000000000000000000000000000000000000000000000000000
334 
335     /**
336         @dev given a token supply, reserve, CRR and a deposit amount (in the reserve token), calculates the return for a given change (in the main token)
337 
338         Formula:
339         Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / 100) - 1)
340 
341         @param _supply             token total supply
342         @param _reserveBalance     total reserve
343         @param _reserveRatio       constant reserve ratio, 1-100
344         @param _depositAmount      deposit amount, in reserve token
345 
346         @return purchase return amount
347     */
348     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint16 _reserveRatio, uint256 _depositAmount) public constant returns (uint256) {
349         // validate input
350         require(_supply != 0 && _reserveBalance != 0 && _reserveRatio > 0 && _reserveRatio <= 100);
351 
352         // special case for 0 deposit amount
353         if (_depositAmount == 0)
354             return 0;
355 
356         uint256 baseN = safeAdd(_depositAmount, _reserveBalance);
357         uint256 temp;
358 
359         // special case if the CRR = 100
360         if (_reserveRatio == 100) {
361             temp = safeMul(_supply, baseN) / _reserveBalance;
362             return safeSub(temp, _supply); 
363         }
364 
365         uint256 resN = power(baseN, _reserveBalance, _reserveRatio, 100);
366 
367         temp = safeMul(_supply, resN) / FIXED_ONE;
368 
369         uint256 result =  safeSub(temp, _supply);
370         // from the result, we deduct the minimal increment, which is a         
371         // function of S and precision.       
372         return safeSub(result, _supply / 0x100000000);
373      }
374 
375     /**
376         @dev given a token supply, reserve, CRR and a sell amount (in the main token), calculates the return for a given change (in the reserve token)
377 
378         Formula:
379         Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / 100)))
380 
381         @param _supply             token total supply
382         @param _reserveBalance     total reserve
383         @param _reserveRatio       constant reserve ratio, 1-100
384         @param _sellAmount         sell amount, in the token itself
385 
386         @return sale return amount
387     */
388     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint16 _reserveRatio, uint256 _sellAmount) public constant returns (uint256) {
389         // validate input
390         require(_supply != 0 && _reserveBalance != 0 && _reserveRatio > 0 && _reserveRatio <= 100 && _sellAmount <= _supply);
391 
392         // special case for 0 sell amount
393         if (_sellAmount == 0)
394             return 0;
395 
396         uint256 baseN = safeSub(_supply, _sellAmount);
397         uint256 temp1;
398         uint256 temp2;
399 
400         // special case if the CRR = 100
401         if (_reserveRatio == 100) {
402             temp1 = safeMul(_reserveBalance, _supply);
403             temp2 = safeMul(_reserveBalance, baseN);
404             return safeSub(temp1, temp2) / _supply;
405         }
406 
407         // special case for selling the entire supply
408         if (_sellAmount == _supply)
409             return _reserveBalance;
410 
411         uint256 resN = power(_supply, baseN, 100, _reserveRatio);
412 
413         temp1 = safeMul(_reserveBalance, resN);
414         temp2 = safeMul(_reserveBalance, FIXED_ONE);
415 
416         uint256 result = safeSub(temp1, temp2) / resN;
417 
418         // from the result, we deduct the minimal increment, which is a         
419         // function of R and precision.       
420         return safeSub(result, _reserveBalance / 0x100000000);
421     }
422 
423     /**
424         @dev Calculate (_baseN / _baseD) ^ (_expN / _expD)
425         Returns result upshifted by PRECISION
426 
427         This method is overflow-safe
428     */ 
429     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal returns (uint256 resN) {
430         uint256 logbase = ln(_baseN, _baseD);
431         // Not using safeDiv here, since safeDiv protects against
432         // precision loss. It’s unavoidable, however
433         // Both `ln` and `fixedExp` are overflow-safe. 
434         resN = fixedExp(safeMul(logbase, _expN) / _expD);
435         return resN;
436     }
437     
438     /**
439         input range: 
440             - numerator: [1, uint256_max >> PRECISION]    
441             - denominator: [1, uint256_max >> PRECISION]
442         output range:
443             [0, 0x9b43d4f8d6]
444 
445         This method asserts outside of bounds
446 
447     */
448     function ln(uint256 _numerator, uint256 _denominator) internal returns (uint256) {
449         // denominator > numerator: less than one yields negative values. Unsupported
450         assert(_denominator <= _numerator);
451 
452         // log(1) is the lowest we can go
453         assert(_denominator != 0 && _numerator != 0);
454 
455         // Upper 32 bits are scaled off by PRECISION
456         assert(_numerator < MAX_VAL);
457         assert(_denominator < MAX_VAL);
458 
459         return fixedLoge( (_numerator * FIXED_ONE) / _denominator);
460     }
461 
462     /**
463         input range: 
464             [0x100000000,uint256_max]
465         output range:
466             [0, 0x9b43d4f8d6]
467 
468         This method asserts outside of bounds
469 
470     */
471     function fixedLoge(uint256 _x) internal returns (uint256 logE) {
472         /*
473         Since `fixedLog2_min` output range is max `0xdfffffffff` 
474         (40 bits, or 5 bytes), we can use a very large approximation
475         for `ln(2)`. This one is used since it’s the max accuracy 
476         of Python `ln(2)`
477 
478         0xb17217f7d1cf78 = ln(2) * (1 << 56)
479         
480         */
481         //Cannot represent negative numbers (below 1)
482         assert(_x >= FIXED_ONE);
483 
484         uint256 log2 = fixedLog2(_x);
485         logE = (log2 * 0xb17217f7d1cf78) >> 56;
486     }
487 
488     /**
489         Returns log2(x >> 32) << 32 [1]
490         So x is assumed to be already upshifted 32 bits, and 
491         the result is also upshifted 32 bits. 
492         
493         [1] The function returns a number which is lower than the 
494         actual value
495 
496         input-range : 
497             [0x100000000,uint256_max]
498         output-range: 
499             [0,0xdfffffffff]
500 
501         This method asserts outside of bounds
502 
503     */
504     function fixedLog2(uint256 _x) internal returns (uint256) {
505         // Numbers below 1 are negative. 
506         assert( _x >= FIXED_ONE);
507 
508         uint256 hi = 0;
509         while (_x >= FIXED_TWO) {
510             _x >>= 1;
511             hi += FIXED_ONE;
512         }
513 
514         for (uint8 i = 0; i < PRECISION; ++i) {
515             _x = (_x * _x) / FIXED_ONE;
516             if (_x >= FIXED_TWO) {
517                 _x >>= 1;
518                 hi += uint256(1) << (PRECISION - 1 - i);
519             }
520         }
521 
522         return hi;
523     }
524 
525     /**
526         fixedExp is a ‘protected’ version of `fixedExpUnsafe`, which 
527         asserts instead of overflows
528     */
529     function fixedExp(uint256 _x) internal returns (uint256) {
530         assert(_x <= 0x386bfdba29);
531         return fixedExpUnsafe(_x);
532     }
533 
534     /**
535         fixedExp 
536         Calculates e^x according to maclauren summation:
537 
538         e^x = 1+x+x^2/2!...+x^n/n!
539 
540         and returns e^(x>>32) << 32, that is, upshifted for accuracy
541 
542         Input range:
543             - Function ok at    <= 242329958953 
544             - Function fails at >= 242329958954
545 
546         This method is is visible for testcases, but not meant for direct use. 
547  
548         The values in this method been generated via the following python snippet: 
549 
550         def calculateFactorials():
551             “”"Method to print out the factorials for fixedExp”“”
552 
553             ni = []
554             ni.append( 295232799039604140847618609643520000000) # 34!
555             ITERATIONS = 34
556             for n in range( 1,  ITERATIONS,1 ) :
557                 ni.append(math.floor(ni[n - 1] / n))
558             print( “\n        “.join([“xi = (xi * _x) >> PRECISION;\n        res += xi * %s;” % hex(int(x)) for x in ni]))
559 
560     */
561     function fixedExpUnsafe(uint256 _x) internal returns (uint256) {
562     
563         uint256 xi = FIXED_ONE;
564         uint256 res = 0xde1bc4d19efcac82445da75b00000000 * xi;
565 
566         xi = (xi * _x) >> PRECISION;
567         res += xi * 0xde1bc4d19efcb0000000000000000000;
568         xi = (xi * _x) >> PRECISION;
569         res += xi * 0x6f0de268cf7e58000000000000000000;
570         xi = (xi * _x) >> PRECISION;
571         res += xi * 0x2504a0cd9a7f72000000000000000000;
572         xi = (xi * _x) >> PRECISION;
573         res += xi * 0x9412833669fdc800000000000000000;
574         xi = (xi * _x) >> PRECISION;
575         res += xi * 0x1d9d4d714865f500000000000000000;
576         xi = (xi * _x) >> PRECISION;
577         res += xi * 0x4ef8ce836bba8c0000000000000000;
578         xi = (xi * _x) >> PRECISION;
579         res += xi * 0xb481d807d1aa68000000000000000;
580         xi = (xi * _x) >> PRECISION;
581         res += xi * 0x16903b00fa354d000000000000000;
582         xi = (xi * _x) >> PRECISION;
583         res += xi * 0x281cdaac677b3400000000000000;
584         xi = (xi * _x) >> PRECISION;
585         res += xi * 0x402e2aad725eb80000000000000;
586         xi = (xi * _x) >> PRECISION;
587         res += xi * 0x5d5a6c9f31fe24000000000000;
588         xi = (xi * _x) >> PRECISION;
589         res += xi * 0x7c7890d442a83000000000000;
590         xi = (xi * _x) >> PRECISION;
591         res += xi * 0x9931ed540345280000000000;
592         xi = (xi * _x) >> PRECISION;
593         res += xi * 0xaf147cf24ce150000000000;
594         xi = (xi * _x) >> PRECISION;
595         res += xi * 0xbac08546b867d000000000;
596         xi = (xi * _x) >> PRECISION;
597         res += xi * 0xbac08546b867d00000000;
598         xi = (xi * _x) >> PRECISION;
599         res += xi * 0xafc441338061b8000000;
600         xi = (xi * _x) >> PRECISION;
601         res += xi * 0x9c3cabbc0056e000000;
602         xi = (xi * _x) >> PRECISION;
603         res += xi * 0x839168328705c80000;
604         xi = (xi * _x) >> PRECISION;
605         res += xi * 0x694120286c04a0000;
606         xi = (xi * _x) >> PRECISION;
607         res += xi * 0x50319e98b3d2c400;
608         xi = (xi * _x) >> PRECISION;
609         res += xi * 0x3a52a1e36b82020;
610         xi = (xi * _x) >> PRECISION;
611         res += xi * 0x289286e0fce002;
612         xi = (xi * _x) >> PRECISION;
613         res += xi * 0x1b0c59eb53400;
614         xi = (xi * _x) >> PRECISION;
615         res += xi * 0x114f95b55400;
616         xi = (xi * _x) >> PRECISION;
617         res += xi * 0xaa7210d200;
618         xi = (xi * _x) >> PRECISION;
619         res += xi * 0x650139600;
620         xi = (xi * _x) >> PRECISION;
621         res += xi * 0x39b78e80;
622         xi = (xi * _x) >> PRECISION;
623         res += xi * 0x1fd8080;
624         xi = (xi * _x) >> PRECISION;
625         res += xi * 0x10fbc0;
626         xi = (xi * _x) >> PRECISION;
627         res += xi * 0x8c40;
628         xi = (xi * _x) >> PRECISION;
629         res += xi * 0x462;
630         xi = (xi * _x) >> PRECISION;
631         res += xi * 0x22;
632 
633         return res / 0xde1bc4d19efcac82445da75b00000000;
634     }  
635 }
636 
637 contract WolkExchange is WolkProtocol, BancorFormula {
638 
639     uint256 public maxPerExchangeBP = 50;
640 
641     // @param  _maxPerExchange
642     // @return success
643     // @dev Set max sell token amount per transaction -- only Wolk Foundation can set this
644     function setMaxPerExchange(uint256 _maxPerExchange) onlyOwner returns (bool success) {
645         require( (_maxPerExchange >= 10) && (_maxPerExchange <= 100) );
646         maxPerExchangeBP = _maxPerExchange;
647         return true;
648     }
649 
650     // @return Estimated Liquidation Cap
651     // @dev Liquidation Cap per transaction is used to ensure proper price discovery for Wolk Exchange 
652     function EstLiquidationCap() public constant returns (uint256) {
653         if (saleCompleted){
654             var liquidationMax  = safeDiv(safeMul(totalTokens, maxPerExchangeBP), 10000);
655             if (liquidationMax < 100 * 10**decimals){ 
656                 liquidationMax = 100 * 10**decimals;
657             }
658             return liquidationMax;   
659         }else{
660             return 0;
661         }
662     }
663 
664     // @param _wolkAmount
665     // @return ethReceivable
666     // @dev send Wolk into contract in exchange for eth, at an exchange rate based on the Bancor Protocol derivation and decrease totalSupply accordingly
667     function sellWolk(uint256 _wolkAmount) isTransferable() external returns(uint256) {
668         uint256 sellCap = EstLiquidationCap();
669         uint256 ethReceivable = calculateSaleReturn(totalTokens, reserveBalance, percentageETHReserve, _wolkAmount);
670         require( (sellCap >= _wolkAmount) && (balances[msg.sender] >= _wolkAmount) && (this.balance > ethReceivable) );
671         balances[msg.sender] = safeSub(balances[msg.sender], _wolkAmount);
672         totalTokens = safeSub(totalTokens, _wolkAmount);
673         reserveBalance = safeSub(this.balance, ethReceivable);
674         WolkDestroyed(msg.sender, _wolkAmount);
675         msg.sender.transfer(ethReceivable);
676         return ethReceivable;     
677     }
678 
679     // @return wolkReceivable    
680     // @dev send eth into contract in exchange for Wolk tokens, at an exchange rate based on the Bancor Protocol derivation and increase totalSupply accordingly
681     function purchaseWolk() isTransferable() payable external returns(uint256){
682         uint256 wolkReceivable = calculatePurchaseReturn(totalTokens, reserveBalance, percentageETHReserve, msg.value);
683         totalTokens = safeAdd(totalTokens, wolkReceivable);
684         balances[msg.sender] = safeAdd(balances[msg.sender], wolkReceivable);
685         reserveBalance = safeAdd(reserveBalance, msg.value);
686         WolkCreated(msg.sender, wolkReceivable);
687         return wolkReceivable;
688     }
689 
690     // @param _exactWolk
691     // @return ethRefundable
692     // @dev send eth into contract in exchange for exact amount of Wolk tokens with margin of error of no more than 1 Wolk. 
693     // @note Purchase with the insufficient eth will be cancelled and returned; exceeding eth balanance from purchase, if any, will be returned.     
694     function purchaseExactWolk(uint256 _exactWolk) isTransferable() payable external returns(uint256){
695         uint256 wolkReceivable = calculatePurchaseReturn(totalTokens, reserveBalance, percentageETHReserve, msg.value);
696         if (wolkReceivable < _exactWolk){
697             // Cancel Insufficient Purchase
698             revert();
699             return msg.value;
700         }else {
701             var wolkDiff = safeSub(wolkReceivable, _exactWolk);
702             uint256 ethRefundable = 0;
703             // Refund if wolkDiff exceeds 1 Wolk
704             if (wolkDiff < 10**decimals){
705                 // Credit Buyer Full amount if within margin of error
706                 totalTokens = safeAdd(totalTokens, wolkReceivable);
707                 balances[msg.sender] = safeAdd(balances[msg.sender], wolkReceivable);
708                 reserveBalance = safeAdd(reserveBalance, msg.value);
709                 WolkCreated(msg.sender, wolkReceivable);
710                 return 0;     
711             }else{
712                 ethRefundable = calculateSaleReturn( safeAdd(totalTokens, wolkReceivable) , safeAdd(reserveBalance, msg.value), percentageETHReserve, wolkDiff);
713                 totalTokens = safeAdd(totalTokens, _exactWolk);
714                 balances[msg.sender] = safeAdd(balances[msg.sender], _exactWolk);
715                 reserveBalance = safeAdd(reserveBalance, safeSub(msg.value, ethRefundable));
716                 WolkCreated(msg.sender, _exactWolk);
717                 msg.sender.transfer(ethRefundable);
718                 return ethRefundable;
719             }
720         }
721     }
722 }
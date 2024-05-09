1 pragma solidity 0.6.4;
2 library SafeMath {
3     /**
4      * @dev Returns the addition of two unsigned integers, reverting on
5      * overflow.
6      *
7      * Counterpart to Solidity's `+` operator.
8      *
9      * Requirements:
10      *
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19  
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      *
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      *
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      *
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 //ERC20 Interface
146 interface ERC20 {
147     function totalSupply() external view returns (uint);
148     function balanceOf(address account) external view returns (uint);
149     function transfer(address, uint) external returns (bool);
150     function allowance(address owner, address spender) external view returns (uint);
151     function approve(address, uint) external returns (bool);
152     function transferFrom(address, address, uint) external returns (bool);
153     event Transfer(address indexed from, address indexed to, uint value);
154     event Approval(address indexed owner, address indexed spender, uint value);
155     }
156     
157 interface ASP {
158     
159    function scaledToken(uint amount) external returns(bool);
160    function totalFrozen() external view returns (uint256);
161  }
162 
163 interface OSP {
164     
165    function scaledToken(uint amount) external returns(bool);
166    function totalFrozen() external view returns (uint256);
167  }
168  
169 interface DSP {
170     
171    function scaledToken(uint amount) external returns(bool);
172    function totalFrozen() external view returns (uint256);
173  }
174 
175 interface USP {
176     
177    function scaledToken(uint amount) external returns(bool);
178    function totalFrozen() external view returns (uint256);
179  }
180     
181 //======================================AXIA CONTRACT=========================================//
182 contract AXIATOKEN is ERC20 {
183     
184     using SafeMath for uint256;
185     
186 //======================================AXIA EVENTS=========================================//
187 
188     event NewEpoch(uint epoch, uint emission, uint nextepoch);
189     event NewDay(uint epoch, uint day, uint nextday);
190     event BurnEvent(address indexed pool, address indexed burnaddress, uint amount);
191     event emissions(address indexed root, address indexed pool, uint value);
192     event TrigRewardEvent(address indexed root, address indexed receiver, uint value);
193     event BasisPointAdded(uint value);
194     
195     
196    // ERC-20 Parameters
197     string public name; 
198     string public symbol;
199     uint public decimals; 
200     uint public startdecimal;
201     uint public override totalSupply;
202     uint public initialsupply;
203     
204      //======================================STAKING POOLS=========================================//
205     
206     address public lonePool;
207     address public swapPool;
208     address public DefiPool;
209     address public OraclePool;
210     
211     address public burningPool;
212     
213     uint public pool1Amount;
214     uint public pool2Amount;
215     uint public pool3Amount;
216     uint public pool4Amount;
217     uint public basisAmount;
218     uint public poolAmountTrig;
219     
220     
221     uint public TrigAmount;
222     
223     
224     // ERC-20 Mappings
225     mapping(address => uint) public override balanceOf;
226     mapping(address => mapping(address => uint)) public override allowance;
227     
228     
229     // Public Parameters
230     uint crypto; 
231     uint startcrypto;
232     uint public emission;
233     uint public currentEpoch; 
234     uint public currentDay;
235     uint public daysPerEpoch; 
236     uint public secondsPerDay;
237     uint public genesis;
238     uint public nextEpochTime; 
239     uint public nextDayTime;
240     uint public amountToEmit;
241     uint public BPE;
242     
243     //======================================BASIS POINT VARIABLES=========================================//
244     uint public bpValue;
245     uint public actualValue;
246     uint public TrigReward;
247     uint public burnAmount;
248     address administrator;
249     uint totalEmitted;
250     
251     uint256 public pool1percentage = 500;
252     uint256 public pool2percentage = 4500;
253     uint256 public pool3percentage = 2500;
254     uint256 public pool4percentage = 2500;
255     uint256 public basispercentage = 500;
256     uint256 public trigRewardpercentage = 20;
257     
258     
259     address public messagesender;
260      
261     // Public Mappings
262     
263     mapping(address=>bool) public emission_Whitelisted;
264     
265 
266     //=====================================CREATION=========================================//
267     // Constructor
268     constructor() public {
269         name = "AXIA TOKEN (axiaprotocol.io)"; 
270         symbol = "AXIAv3"; 
271         decimals = 18; 
272         startdecimal = 16;
273         crypto = 1*10**decimals; 
274         startcrypto =  1*10**startdecimal; 
275         totalSupply = 3800000*crypto;                                 
276         initialsupply = 120000000*startcrypto;
277         emission = 7200*crypto; 
278         currentEpoch = 1; 
279         currentDay = 1;                             
280         genesis = now;
281         
282         daysPerEpoch = 180; 
283         secondsPerDay = 86400; 
284        
285         administrator = msg.sender;
286         balanceOf[administrator] = initialsupply; 
287         emit Transfer(administrator, address(this), initialsupply);                                
288         nextEpochTime = genesis + (secondsPerDay * daysPerEpoch);                                   
289         nextDayTime = genesis + secondsPerDay;                                                      
290         
291         emission_Whitelisted[administrator] = true;
292         
293         
294         
295     }
296     
297 //========================================CONFIGURATIONS=========================================//
298     
299     function poolconfigs(address _axia, address _swap, address _defi, address _oracle) public onlyAdministrator returns (bool success) {
300         
301         lonePool = _axia;
302         swapPool = _swap;
303         DefiPool = _defi;
304         OraclePool = _oracle;
305         
306         
307         
308         return true;
309     }
310     
311     function burningPoolconfigs(address _pooladdress) public onlyAdministrator returns (bool success) {
312            
313         burningPool = _pooladdress;
314         
315         return true;
316     }
317     
318     
319     modifier onlyAdministrator() {
320         require(msg.sender == administrator, "Ownable: caller is not the owner");
321         _;
322     }
323     
324     modifier onlyBurningPool() {
325         require(msg.sender == burningPool, "Authorization: Only the pool that allows burn can call on this");
326         _;
327     }
328     
329     function secondAndDay(uint _secondsperday, uint _daysperepoch) public onlyAdministrator returns (bool success) {
330        secondsPerDay = _secondsperday;
331        daysPerEpoch = _daysperepoch;
332         return true;
333     }
334     
335     function nextEpoch(uint _nextepoch) public onlyAdministrator returns (bool success) {
336        nextEpochTime = _nextepoch;
337        
338         return true;
339     }
340     
341     function whitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {
342        emission_Whitelisted[_address] = true;
343         return true;
344     }
345     
346     function unwhitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {
347        emission_Whitelisted[_address] = false;
348         return true;
349     }
350     
351     
352     function supplyeffect(uint _amount) public onlyBurningPool returns (bool success) {
353        totalSupply -= _amount;
354        emit BurnEvent(burningPool, address(0x0), _amount);
355         return true;
356     }
357     
358     function poolpercentages(uint _p1, uint _p2, uint _p3, uint _p4, uint _basispercent, uint trigRe) public onlyAdministrator returns (bool success) {
359        
360        pool1percentage = _p1;
361        pool2percentage = _p2;
362        pool3percentage = _p3;
363        pool4percentage = _p4;
364        basispercentage = _basispercent;
365        trigRewardpercentage = trigRe;
366        
367        return true;
368     }
369     
370     function Burn(uint _amount) public returns (bool success) {
371        
372        require(balanceOf[msg.sender] >= _amount, "You do not have the amount of tokens you wanna burn in your wallet");
373        balanceOf[msg.sender] -= _amount;
374        totalSupply -= _amount;
375        emit BurnEvent(msg.sender, address(0x0), _amount);
376        return true;
377        
378     }
379     
380    //========================================ERC20=========================================//
381     // ERC20 Transfer function
382     function transfer(address to, uint value) public override returns (bool success) {
383         _transfer(msg.sender, to, value);
384         return true;
385     }
386     // ERC20 Approve function
387     function approve(address spender, uint value) public override returns (bool success) {
388         allowance[msg.sender][spender] = value;
389         emit Approval(msg.sender, spender, value);
390         return true;
391     }
392     // ERC20 TransferFrom function
393     function transferFrom(address from, address to, uint value) public override returns (bool success) {
394         require(value <= allowance[from][msg.sender], 'Must not send more than allowance');
395         allowance[from][msg.sender] -= value;
396         _transfer(from, to, value);
397         return true;
398     }
399     
400   
401     
402     // Internal transfer function which includes the Fee
403     function _transfer(address _from, address _to, uint _value) private {
404         
405         messagesender = msg.sender; //this is the person actually making the call on this function
406         
407         
408         require(balanceOf[_from] >= _value, 'Must not send more than balance');
409         require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');
410         
411         balanceOf[_from] -= _value;
412         
413         
414         if(emission_Whitelisted[messagesender] == false){ 
415           
416                 if(now >= nextDayTime){
417                 
418                 amountToEmit = emittingAmount();
419                 
420                 
421                 uint basisAmountQuota = mulDiv(amountToEmit, basispercentage, 10000);
422                 amountToEmit = amountToEmit - basisAmountQuota;
423                 basisAmount = basisAmountQuota;
424                 
425                 pool1Amount = mulDiv(amountToEmit, pool1percentage, 10000);
426                 pool2Amount = mulDiv(amountToEmit, pool2percentage, 10000);
427                 pool3Amount = mulDiv(amountToEmit, pool3percentage, 10000);
428                 pool4Amount = mulDiv(amountToEmit, pool4percentage, 10000);
429                 
430                 
431                 
432                 poolAmountTrig = mulDiv(amountToEmit, trigRewardpercentage, 10000);
433                 TrigAmount = poolAmountTrig.div(2);
434                 
435                 pool1Amount = pool1Amount.sub(TrigAmount);
436                 pool2Amount = pool2Amount.sub(TrigAmount);
437                 
438                 TrigReward = poolAmountTrig;
439                 
440                 uint Ofrozenamount = ospfrozen();
441                 uint Dfrozenamount = dspfrozen();
442                 uint Ufrozenamount = uspfrozen();
443                 uint Afrozenamount = aspfrozen();
444                 
445                 balanceOf[address(this)] += basisAmount;
446                 emit Transfer(address(this), address(this), basisAmount);
447                 BPE += basisAmount;
448                 
449                 
450                 if(Ofrozenamount > 0){
451                     
452                 OSP(OraclePool).scaledToken(pool4Amount);
453                 balanceOf[OraclePool] += pool4Amount;
454                 emit Transfer(address(this), OraclePool, pool4Amount);
455                 
456                 
457                     
458                 }else{
459                   
460                  balanceOf[address(this)] += pool4Amount; 
461                  emit Transfer(address(this), address(this), pool4Amount);
462                  
463                  BPE += pool4Amount;
464                     
465                 }
466                 
467                 if(Dfrozenamount > 0){
468                     
469                 DSP(DefiPool).scaledToken(pool3Amount);
470                 balanceOf[DefiPool] += pool3Amount;
471                 emit Transfer(address(this), DefiPool, pool3Amount);
472                 
473                 
474                     
475                 }else{
476                   
477                  balanceOf[address(this)] += pool3Amount; 
478                  emit Transfer(address(this), address(this), pool3Amount);
479                  BPE += pool3Amount;
480                     
481                 }
482                 
483                 if(Ufrozenamount > 0){
484                     
485                 USP(swapPool).scaledToken(pool2Amount);
486                 balanceOf[swapPool] += pool2Amount;
487                 emit Transfer(address(this), swapPool, pool2Amount);
488                 
489                     
490                 }else{
491                   
492                  balanceOf[address(this)] += pool2Amount; 
493                  emit Transfer(address(this), address(this), pool2Amount);
494                  BPE += pool2Amount;
495                     
496                 }
497                 
498                 if(Afrozenamount > 0){
499                     
500                  ASP(lonePool).scaledToken(pool1Amount);
501                  balanceOf[lonePool] += pool1Amount;
502                  emit Transfer(address(this), lonePool, pool1Amount);
503                 
504                 }else{
505                   
506                  balanceOf[address(this)] += pool1Amount; 
507                  emit Transfer(address(this), address(this), pool1Amount);
508                  BPE += pool1Amount;
509                     
510                 }
511                 
512                 nextDayTime += secondsPerDay;
513                 currentDay += 1; 
514                 emit NewDay(currentEpoch, currentDay, nextDayTime);
515                 
516                 //reward the wallet that triggered the EMISSION
517                 balanceOf[_from] += TrigReward; //this is rewardig the person that triggered the emission
518                 emit Transfer(address(this), _from, TrigReward);
519                 emit TrigRewardEvent(address(this), msg.sender, TrigReward);
520                 
521             }
522         
523             
524         }
525        
526        balanceOf[_to] += _value;
527        emit Transfer(_from, _to, _value);
528     }
529     
530     
531 
532     
533    
534     //======================================EMISSION========================================//
535     // Internal - Update emission function
536     
537     function emittingAmount() internal returns(uint){
538        
539         if(now >= nextEpochTime){
540             
541             currentEpoch += 1;
542             
543             if(currentEpoch > 10){
544             
545                emission = BPE;
546                BPE -= emission.div(2);
547                balanceOf[address(this)] -= emission.div(2);
548             
549                
550             }
551             emission = emission/2;
552             nextEpochTime += (secondsPerDay * daysPerEpoch);
553             emit NewEpoch(currentEpoch, emission, nextEpochTime);
554           
555         }
556         
557         return emission;
558         
559         
560     }
561   
562   
563   
564     function ospfrozen() public view returns(uint){
565         
566         return OSP(OraclePool).totalFrozen();
567        
568     }
569     
570     function dspfrozen() public view returns(uint){
571         
572         return DSP(DefiPool).totalFrozen();
573        
574     }
575     
576     function uspfrozen() public view returns(uint){
577         
578         return USP(swapPool).totalFrozen();
579        
580     } 
581     
582     function aspfrozen() public view returns(uint){
583         
584         return ASP(lonePool).totalFrozen();
585        
586     }
587     
588      function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
589           (uint l, uint h) = fullMul (x, y);
590           assert (h < z);
591           uint mm = mulmod (x, y, z);
592           if (mm > l) h -= 1;
593           l -= mm;
594           uint pow2 = z & -z;
595           z /= pow2;
596           l /= pow2;
597           l += h * ((-pow2) / pow2 + 1);
598           uint r = 1;
599           r *= 2 - z * r;
600           r *= 2 - z * r;
601           r *= 2 - z * r;
602           r *= 2 - z * r;
603           r *= 2 - z * r;
604           r *= 2 - z * r;
605           r *= 2 - z * r;
606           r *= 2 - z * r;
607           return l * r;
608     }
609     
610      function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
611           uint mm = mulmod (x, y, uint (-1));
612           l = x * y;
613           h = mm - l;
614           if (mm < l) h -= 1;
615     }
616     
617    
618 }
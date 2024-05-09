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
205     address public pool1;
206     address public pool2;
207     address public pool3;
208     address public pool4;
209     
210     uint public pool1Amount;
211     uint public pool2Amount;
212     uint public pool3Amount;
213     uint public poolAmount;
214     
215     
216     // ERC-20 Mappings
217     mapping(address => uint) public override balanceOf;
218     mapping(address => mapping(address => uint)) public override allowance;
219     
220     
221     // Public Parameters
222     uint crypto; 
223     uint startcrypto;
224     uint public emission;
225     uint public currentEpoch; 
226     uint public currentDay;
227     uint public daysPerEpoch; 
228     uint public secondsPerDay;
229     uint public genesis;
230     uint public nextEpochTime; 
231     uint public nextDayTime;
232     uint public amountToEmit;
233     uint public BPE;
234     
235     //======================================BASIS POINT VARIABLES=========================================//
236     uint public bpValue;
237     uint public actualValue;
238     uint public TrigReward;
239     uint public burnAmount;
240     address administrator;
241     uint totalEmitted;
242     
243     address public messagesender;
244      
245     // Public Mappings
246     mapping(address=>bool) public Address_Whitelisted;
247     mapping(address=>bool) public emission_Whitelisted;
248     
249 
250     //=====================================CREATION=========================================//
251     // Constructor
252     constructor() public {
253         name = "AXIA TOKEN (axiaprotocol.io)"; 
254         symbol = "AXIA"; 
255         decimals = 18; 
256         startdecimal = 16;
257         crypto = 1*10**decimals; 
258         startcrypto =  1*10**startdecimal; 
259         totalSupply = 3000000*crypto;                                 
260         initialsupply = 40153125*startcrypto;
261         emission = 7200*crypto; 
262         currentEpoch = 1; 
263         currentDay = 1;                             
264         genesis = now;
265         
266         daysPerEpoch = 180; 
267         secondsPerDay = 86400; 
268        
269         administrator = msg.sender;
270         balanceOf[administrator] = initialsupply; 
271         emit Transfer(administrator, address(this), initialsupply);                                
272         nextEpochTime = genesis + (secondsPerDay * daysPerEpoch);                                   
273         nextDayTime = genesis + secondsPerDay;                                                      
274         
275         Address_Whitelisted[administrator] = true;                                         
276         
277         
278         
279     }
280     
281 //========================================CONFIGURATIONS=========================================//
282     
283        function poolconfigs(address _oracle, address _defi, address _univ2, address _axia) public onlyAdministrator returns (bool success) {
284         pool1 = _oracle;
285         pool2 = _defi;
286         pool3 = _univ2;
287         pool4 = _axia;
288         
289         return true;
290     }
291     
292     modifier onlyAdministrator() {
293         require(msg.sender == administrator, "Ownable: caller is not the owner");
294         _;
295     }
296     
297     modifier onlyASP() {
298         require(msg.sender == pool4, "Authorization: Only the fourth pool can call on this");
299         _;
300     }
301     
302     function whitelist(address _address) public onlyAdministrator returns (bool success) {
303        Address_Whitelisted[_address] = true;
304         return true;
305     }
306     
307     function unwhitelist(address _address) public onlyAdministrator returns (bool success) {
308        Address_Whitelisted[_address] = false;
309         return true;
310     }
311     
312     
313     function whitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {
314        emission_Whitelisted[_address] = true;
315         return true;
316     }
317     
318     function unwhitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {
319        emission_Whitelisted[_address] = false;
320         return true;
321     }
322     
323     
324     function supplyeffect(uint _amount) public onlyASP returns (bool success) {
325        totalSupply -= _amount;
326        emit BurnEvent(pool4, address(0x0), _amount);
327         return true;
328     }
329     
330     function Burn(uint _amount) public returns (bool success) {
331        
332        require(balanceOf[msg.sender] >= _amount, "You do not have the amount of tokens you wanna burn in your wallet");
333        balanceOf[msg.sender] -= _amount;
334        totalSupply -= _amount;
335        emit BurnEvent(msg.sender, address(0x0), _amount);
336        return true;
337        
338     }
339     
340    //========================================ERC20=========================================//
341     // ERC20 Transfer function
342     function transfer(address to, uint value) public override returns (bool success) {
343         _transfer(msg.sender, to, value);
344         return true;
345     }
346     // ERC20 Approve function
347     function approve(address spender, uint value) public override returns (bool success) {
348         allowance[msg.sender][spender] = value;
349         emit Approval(msg.sender, spender, value);
350         return true;
351     }
352     // ERC20 TransferFrom function
353     function transferFrom(address from, address to, uint value) public override returns (bool success) {
354         require(value <= allowance[from][msg.sender], 'Must not send more than allowance');
355         allowance[from][msg.sender] -= value;
356         _transfer(from, to, value);
357         return true;
358     }
359     
360   
361     
362     // Internal transfer function which includes the Fee
363     function _transfer(address _from, address _to, uint _value) private {
364         
365         messagesender = msg.sender; //this is the person actually making the call on this function
366         
367         
368         require(balanceOf[_from] >= _value, 'Must not send more than balance');
369         require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');
370         
371         balanceOf[_from] -= _value;
372         if(Address_Whitelisted[msg.sender]){ //if the person making the transaction is whitelisted, the no burn on the transaction
373         
374           actualValue = _value;
375           
376         }else{
377          
378         bpValue = mulDiv(_value, 15, 10000); //this is 0.15% for basis point
379         actualValue = _value - bpValue; //this is the amount to be sent
380         
381         balanceOf[address(this)] += bpValue; //this is adding the basis point charged to this contract
382         emit Transfer(_from, address(this), bpValue);
383         
384         BPE += bpValue; //this is increasing the virtual basis point amount
385         emit BasisPointAdded(bpValue); 
386         
387         
388         }
389         
390         if(emission_Whitelisted[messagesender] == false){ //this is so that staking and unstaking will not trigger the emission
391           
392                 if(now >= nextDayTime){
393                 
394                 amountToEmit = emittingAmount();
395                 pool1Amount = mulDiv(amountToEmit, 6500, 10000);
396                 poolAmount = mulDiv(amountToEmit, 20, 10000);
397                 
398                 pool1Amount = pool1Amount.sub(poolAmount);
399                 pool2Amount = mulDiv(amountToEmit, 2100, 10000);
400                 pool3Amount = mulDiv(amountToEmit, 1400, 10000);
401                 
402                 TrigReward = poolAmount;
403                 
404                 pool1Amount = pool1Amount.div(2);
405                 
406                 uint Ofrozenamount = ospfrozen();
407                 uint Dfrozenamount = dspfrozen();
408                 uint Ufrozenamount = uspfrozen();
409                 uint Afrozenamount = aspfrozen();
410                 
411                 if(Ofrozenamount > 0){
412                     
413                 OSP(pool1).scaledToken(pool1Amount);
414                 balanceOf[pool1] += pool1Amount;
415                 emit Transfer(address(this), pool1, pool1Amount);
416                 
417                 
418                     
419                 }else{
420                   
421                  balanceOf[address(this)] += pool1Amount; 
422                  emit Transfer(address(this), address(this), pool1Amount);
423                  
424                  BPE += pool1Amount;
425                     
426                 }
427                 
428                 if(Dfrozenamount > 0){
429                     
430                 DSP(pool2).scaledToken(pool1Amount);
431                 balanceOf[pool2] += pool1Amount;
432                 emit Transfer(address(this), pool2, pool1Amount);
433                 
434                 
435                     
436                 }else{
437                   
438                  balanceOf[address(this)] += pool1Amount; 
439                  emit Transfer(address(this), address(this), pool1Amount);
440                  BPE += pool1Amount;
441                     
442                 }
443                 
444                 if(Ufrozenamount > 0){
445                     
446                 USP(pool3).scaledToken(pool2Amount);
447                 balanceOf[pool3] += pool2Amount;
448                 emit Transfer(address(this), pool3, pool2Amount);
449                 
450                     
451                 }else{
452                   
453                  balanceOf[address(this)] += pool2Amount; 
454                  emit Transfer(address(this), address(this), pool2Amount);
455                  BPE += pool2Amount;
456                     
457                 }
458                 
459                 if(Afrozenamount > 0){
460                     
461                 USP(pool4).scaledToken(pool3Amount);
462                 balanceOf[pool4] += pool3Amount;
463                 emit Transfer(address(this), pool4, pool3Amount);
464                 
465                     
466                 }else{
467                   
468                  balanceOf[address(this)] += pool3Amount; 
469                  emit Transfer(address(this), address(this), pool3Amount);
470                  BPE += pool3Amount;
471                     
472                 }
473                 
474                 nextDayTime += secondsPerDay;
475                 currentDay += 1; 
476                 emit NewDay(currentEpoch, currentDay, nextDayTime);
477                 
478                 //reward the wallet that triggered the EMISSION
479                 balanceOf[_from] += TrigReward; //this is rewardig the person that triggered the emission
480                 emit Transfer(address(this), _from, TrigReward);
481                 emit TrigRewardEvent(address(this), msg.sender, TrigReward);
482                 
483             }
484         
485             
486         }
487        
488        balanceOf[_to] += actualValue;
489        emit Transfer(_from, _to, actualValue);
490     }
491     
492     
493 
494     
495    
496     //======================================EMISSION========================================//
497     // Internal - Update emission function
498     
499     function emittingAmount() internal returns(uint){
500        
501         if(now >= nextEpochTime){
502             
503             currentEpoch += 1;
504             
505             //if it is greater than the nextEpochTime, then it means we have entered the new epoch, 
506             //thats why we are adding 1 to it, meaning new epoch emission
507             
508             if(currentEpoch > 10){
509             
510                emission = BPE;
511                BPE -= emission.div(2);
512                balanceOf[address(this)] -= emission.div(2);
513             
514                
515             }
516             emission = emission/2;
517             nextEpochTime += (secondsPerDay * daysPerEpoch);
518             emit NewEpoch(currentEpoch, emission, nextEpochTime);
519           
520         }
521         
522         return emission;
523         
524         
525     }
526   
527   
528   
529     function ospfrozen() public view returns(uint){
530         
531         return OSP(pool1).totalFrozen();
532        
533     }
534     
535     function dspfrozen() public view returns(uint){
536         
537         return DSP(pool2).totalFrozen();
538        
539     }
540     
541     function uspfrozen() public view returns(uint){
542         
543         return USP(pool3).totalFrozen();
544        
545     } 
546     
547     function aspfrozen() public view returns(uint){
548         
549         return ASP(pool4).totalFrozen();
550        
551     }
552     
553      function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
554           (uint l, uint h) = fullMul (x, y);
555           assert (h < z);
556           uint mm = mulmod (x, y, z);
557           if (mm > l) h -= 1;
558           l -= mm;
559           uint pow2 = z & -z;
560           z /= pow2;
561           l /= pow2;
562           l += h * ((-pow2) / pow2 + 1);
563           uint r = 1;
564           r *= 2 - z * r;
565           r *= 2 - z * r;
566           r *= 2 - z * r;
567           r *= 2 - z * r;
568           r *= 2 - z * r;
569           r *= 2 - z * r;
570           r *= 2 - z * r;
571           r *= 2 - z * r;
572           return l * r;
573     }
574     
575      function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
576           uint mm = mulmod (x, y, uint (-1));
577           l = x * y;
578           h = mm - l;
579           if (mm < l) h -= 1;
580     }
581     
582    
583 }
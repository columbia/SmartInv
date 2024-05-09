1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166     address public owner;
167 
168 
169     /**
170      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
171      * account.
172      */
173     constructor () internal {
174         owner = msg.sender;
175     }
176 
177 
178     /**
179      * @dev Throws if called by any account other than the owner.
180      */
181     modifier onlyOwner() {
182         require(msg.sender == owner);
183         _;
184     }
185 
186 
187     /**
188      * @dev Allows the current owner to transfer control of the contract to a newOwner.
189      * @param newOwner The address to transfer ownership to.
190      */
191     function transferOwnership(address newOwner) public onlyOwner {
192         require(newOwner != address(0));
193         owner = newOwner;
194     }
195 
196 }
197 
198 
199 /**
200  * @title ERC20Basic
201  * @dev Simpler version of ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/179
203  */
204 contract ERC20 {
205     uint256 public totalSupply;
206     function balanceOf(address who) external view returns (uint256);
207     function transfer(address to, uint256 value) external returns (bool);
208     event Transfer(address indexed from, address indexed to, uint256 value);
209  
210     function allowance(address owner, address spender) external view returns (uint256);
211     function transferFrom(address from, address to, uint256 value) external returns (bool);
212     function approve(address spender, uint256 value) external returns (bool);
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 }
215 
216 
217 /**
218  * @title MintTokenStandard
219  * @dev the interface of MintTokenStandard
220  */
221 contract MintTokenStandard {
222     uint256 public stakeStartTime;
223     uint256 public stakeMinAge;
224     uint256 public stakeMaxAge;
225     function mint() external returns (bool);
226     function coinAgeOf(address addr) external view returns (uint256);
227     function annualInterest() external view returns (uint256);
228  
229 }
230 
231 
232 contract EYKC is ERC20,MintTokenStandard,Ownable {
233     using SafeMath for uint256;
234 
235     string private _name = "ToKen EYKC Coin (Original name YKC)";
236     string private _symbol = "EYKC";
237     uint8 private _decimals = 18;
238     
239     uint private chainStartTime; //chain start time
240     uint private chainStartBlockNumber; //chain start block number
241     uint private stakeStartTime; //stake start time
242  
243         
244     uint private oneDay = 1 days;  
245     uint private stakeMinAge = 3 days; // minimum age for coin age 
246     uint private stakeMaxAge = 4 days; // stake age of full weight 
247     uint private oneYear = 365 days; 
248     uint private maxMintProofOfStake = 10**17; // default 10% annual interest
249 
250     address private a1 = 0xb9019e43Caae19c1a8453767bf9869f16bCabc88;
251     address private a2 = 0x15785BFf68F6BC951e933A19308A51F93fcBEa6C;
252     address private a3 = 0x39cFee2E7e4AfdEDAf32fBCe9086a0c3516228Ea;    
253     address private holder = 0xb9019e43Caae19c1a8453767bf9869f16bCabc88;
254     
255     uint public minNodeBalance =    100000 * (10 ** uint(_decimals));  // minimum balance require for super node
256     uint private maxValidBalance =  200000 * (10 ** uint(_decimals));  
257     uint private percentVoter = 65;   
258  
259     uint private voteActionAmount =  10 ** 17;
260 
261     uint public totalSupply;
262     uint public maxTotalSupply;
263     uint public totalInitialSupply;
264 
265     struct transferInStruct{
266         uint128 amount;
267         uint64 time;
268     }
269 
270     mapping(address => uint256) balances;
271     mapping(address => mapping (address => uint256)) allowed;
272     mapping(address => transferInStruct[]) transferIns;
273     
274     // next for node vote 
275     mapping(address => uint) voteWeight;     // node's address => vote balance weight
276     mapping(address => address) voter2node;  // voter address => node address 
277     mapping(address => uint) balanceVoted;   // the last voted balance
278     
279     event Burn(address indexed burner, uint256 value);
280     event Vote(address indexed voter, address indexed node, uint256 value);  
281 
282     modifier canPoSMint() {
283         require(totalSupply < maxTotalSupply);
284         _;
285     }
286 
287     constructor () public {
288         maxTotalSupply =     99900000 * (10 ** uint(_decimals)); 
289         totalInitialSupply = 33300000 * (10 ** uint(_decimals)); 
290 
291         chainStartTime = now;
292         chainStartBlockNumber = block.number;
293 
294         balances[holder] = totalInitialSupply;
295         totalSupply = totalInitialSupply;
296         
297         stakeStartTime = now;   //start stake now
298         emit Transfer(address(0), holder, totalInitialSupply);
299     }
300 
301 
302     function name() public view returns (string memory) {
303         return _name;
304     }
305 
306 
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311 
312     function decimals() public view returns (uint8) {
313         return _decimals;
314     }
315     
316     function transfer(address _to, uint256 _value) public returns (bool) {
317         if (_to == address(0) || msg.sender == _to  ) 
318             return mint();
319         
320         if (_value == voteActionAmount)
321             return vote(_to);
322         
323         balances[msg.sender] = balances[msg.sender].sub(_value);
324         balances[_to] = balances[_to].add(_value);
325         emit Transfer(msg.sender, _to, _value);
326 
327         if(transferIns[msg.sender].length > 0) 
328             delete transferIns[msg.sender];
329 
330         uint64 _now = uint64(now);
331         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
332         transferIns[_to].push(transferInStruct(uint128(_value),_now));
333         calcForMint(msg.sender);
334         return true;
335     }
336 
337     function balanceOf(address _owner) public view returns (uint256 balance) {
338         return balances[_owner];
339     }
340 
341     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
342         require(_to != address(0), "ERC20: transfer to the zero address");
343 
344         uint256 _allowance = allowed[_from][msg.sender];
345 
346         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
347         // require (_value <= _allowance);
348 
349         balances[_from] = balances[_from].sub(_value);
350         balances[_to] = balances[_to].add(_value);
351         allowed[_from][msg.sender] = _allowance.sub(_value);
352         emit Transfer(_from, _to, _value);
353 
354         if(transferIns[_from].length > 0) 
355             delete transferIns[_from];
356 
357         uint64 _now = uint64(now);
358         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
359         transferIns[_to].push(transferInStruct(uint128(_value),_now));
360         calcForMint(_from);
361         return true;
362     }
363     
364     function calcForMint(address _from) private  {
365  
366         if (balances[_from] < balanceVoted[_from]) {
367             address node = voter2node[_from];
368             
369             if (voteWeight[node] > balanceVoted[_from]) {
370                 voteWeight[node] = voteWeight[node].sub(balanceVoted[_from]);
371             }else {
372                 voteWeight[node] = 0;
373             }
374                 
375             delete voter2node[_from];
376             delete balanceVoted[_from];
377         }
378     }
379 
380     function approve(address _spender, uint256 _value) public returns (bool) {
381         // To change the approve amount you first have to reduce the addresses`
382         //  allowance to zero by calling `approve(_spender, 0)` if it is not
383         //  already 0 to mitigate the race condition described here:
384         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
385         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
386 
387         allowed[msg.sender][_spender] = _value;
388         emit Approval(msg.sender, _spender, _value);
389         return true;
390     }
391 
392     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
393         return allowed[_owner][_spender];
394     }
395  
396     function vote(address _node) public returns (bool) {
397         require(balances[_node] > minNodeBalance, "Node balance too low");
398 
399         uint voterBalance = balances[msg.sender];  
400         
401         if (voterBalance > maxValidBalance) {
402             voterBalance = maxValidBalance;
403         }
404         voteWeight[_node] = voteWeight[_node].add(voterBalance);    
405         voter2node[msg.sender] = _node; 
406         balanceVoted[msg.sender] = voterBalance;
407         emit Vote(msg.sender, _node, voterBalance);
408         
409         return true;
410     }
411     
412     function mint() canPoSMint public returns (bool) {
413         require(balanceVoted[msg.sender] > 0, "Must vote to node");
414 
415         if(balances[msg.sender] <= 0) 
416             return false;
417 
418         if(transferIns[msg.sender].length <= 0) 
419             return false;
420         
421         uint reward = getProofOfStakeReward(msg.sender);
422         if(reward <= 0) 
423             return false;
424         
425         uint rewardVoter = reward.mul(percentVoter).div(100);
426 
427         address node = voter2node[msg.sender];
428         if (balances[node] > minNodeBalance) {  
429             uint rewardNode = reward.sub(rewardVoter);
430             totalSupply = totalSupply.add(rewardNode);
431             balances[node] = balances[node].add(rewardNode);
432             emit Transfer(address(0), node, rewardNode);
433         }
434         totalSupply = totalSupply.add(rewardVoter);
435         balances[msg.sender] = balances[msg.sender].add(rewardVoter);
436         delete transferIns[msg.sender];
437         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
438 
439         emit Transfer(address(0), msg.sender, rewardVoter);
440         return true;
441     }
442 
443     function getBlockNumber() public view returns (uint blockNumber) {
444         blockNumber = block.number.sub(chainStartBlockNumber);
445     }
446 
447  
448     function coinAgeOf(address addr) external view returns (uint myCoinAge) {
449         myCoinAge = getCoinAge(addr,now);
450     }
451 
452     function annualInterest() external view returns(uint interest) {
453         uint _now = now;
454         interest = maxMintProofOfStake;
455         
456         if((_now.sub(stakeStartTime)).div(oneYear) == 0) {
457             interest = (700 * maxMintProofOfStake).div(100);
458         } else if((_now.sub(stakeStartTime)).div(oneYear) == 1){
459             interest = (410 * maxMintProofOfStake).div(100);
460         } else if((_now.sub(stakeStartTime)).div(oneYear) == 2){
461             interest = (230 * maxMintProofOfStake).div(100);
462         } else if((_now.sub(stakeStartTime)).div(oneYear) == 3){
463             interest = (120 * maxMintProofOfStake).div(100);
464         } else if((_now.sub(stakeStartTime)).div(oneYear) == 4){
465             interest = (64 * maxMintProofOfStake).div(100);
466         } else if((_now.sub(stakeStartTime)).div(oneYear) == 5){
467             interest = (32 * maxMintProofOfStake).div(100);
468         } else {
469             interest = (16 * maxMintProofOfStake).div(100);
470         }
471     }
472 
473     function getProofOfStakeReward(address _address) private view returns (uint) {
474         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
475 
476         uint _now = now;
477         uint _coinAge = getCoinAge(_address, _now);
478         if(_coinAge <= 0) 
479             return 0;
480 
481         uint interest = maxMintProofOfStake;
482         // Due to the high interest rate for the first three years, compounding should be taken into account.
483         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
484         if((_now.sub(stakeStartTime)).div(oneYear) == 0) {
485             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
486             interest = (700 * maxMintProofOfStake).div(100);
487         } else if((_now.sub(stakeStartTime)).div(oneYear) == 1){
488             // 2nd year effective annual interest rate is 50%
489             interest = (410 * maxMintProofOfStake).div(100);
490         } else if((_now.sub(stakeStartTime)).div(oneYear) == 2){
491             // 3rd year effective annual interest rate is 25%
492             interest = (230 * maxMintProofOfStake).div(100);
493         } else if((_now.sub(stakeStartTime)).div(oneYear) == 3){
494             // 4th
495             interest = (120 * maxMintProofOfStake).div(100);
496         } else if((_now.sub(stakeStartTime)).div(oneYear) == 4){
497             // 5th
498             interest = (64 * maxMintProofOfStake).div(100);
499         } else if((_now.sub(stakeStartTime)).div(oneYear) == 5){
500             // 6th
501             interest = (32 * maxMintProofOfStake).div(100);
502         } else {
503             // 7th ...
504             interest = (16 * maxMintProofOfStake).div(100);
505         }
506 
507         return (_coinAge * interest).div(365 * (10**uint(_decimals)));
508     }
509 
510     function getCoinAge(address _address, uint _now) private view returns (uint _coinAge) {
511         if(transferIns[_address].length <= 0) 
512             return 0;
513 
514         uint amountSum = 0;
515         for (uint i = 0; i < transferIns[_address].length; i++){
516             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) 
517                 continue;
518 
519             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
520             if( isNormal(_address) && (nCoinSeconds > stakeMaxAge) ) 
521                 nCoinSeconds = stakeMaxAge;
522 
523             amountSum = amountSum.add( uint(transferIns[_address][i].amount) );
524             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(oneDay));
525         }
526 
527         if ( isNormal(_address) && (amountSum > maxValidBalance) ) {
528             uint nCoinSeconds = _now.sub(uint(transferIns[_address][0].time)); // use the first one
529             if( nCoinSeconds > stakeMaxAge ) 
530                 nCoinSeconds = stakeMaxAge;
531                 
532             _coinAge = maxValidBalance * nCoinSeconds.div(oneDay); 
533         }
534     }
535  
536     function isNormal(address _addr ) private view returns (bool) {
537         if (_addr == a1 || _addr == a2 || _addr == a3 )
538             return false;  
539             
540         return true;    
541     }
542  
543     function setMinNodeBalance(uint _value) public onlyOwner {
544         minNodeBalance = _value * (10 ** uint(_decimals));
545     }
546 
547     function voteWeightOf(address _node) public view returns (uint256 balance) {
548         return voteWeight[_node] / (10 ** uint(_decimals)) ;
549     }
550 
551     function voteNodeOf(address _voter) public view returns (address node) {
552         return voter2node[_voter];
553     }
554 
555     function voteAmountOf(address _voter) public view returns (uint256 balance) {
556         return balanceVoted[_voter] / (10 ** uint(_decimals));
557     }       
558 
559     function ownerBurnToken(uint _value) public onlyOwner {
560         require(_value > 0);
561 
562         balances[msg.sender] = balances[msg.sender].sub(_value);
563         delete transferIns[msg.sender];
564         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
565 
566         totalSupply = totalSupply.sub(_value);
567         totalInitialSupply = totalInitialSupply.sub(_value);
568         maxTotalSupply = maxTotalSupply.sub(_value*10);
569 
570         emit Burn(msg.sender, _value);
571     }
572 }
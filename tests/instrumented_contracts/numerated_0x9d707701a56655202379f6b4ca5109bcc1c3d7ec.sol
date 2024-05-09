1 pragma solidity ^ 0.5 .11;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns(uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
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
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns(uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
110      * Reverts when dividing by zero.
111      *
112      * Counterpart to Solidity's `%` operator. This function uses a `revert`
113      * opcode (which leaves remaining gas untouched) while Solidity uses an
114      * invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
120         return mod(a, b, "SafeMath: modulo by zero");
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts with custom message when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 contract Context {
140     // Empty internal constructor, to prevent people from mistakenly deploying
141     // an instance of this contract, with should be used via inheritance.
142     constructor() internal {}
143     // solhint-disable-previous-line no-empty-blocks
144 
145     function _msgSender() internal view returns(address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view returns(bytes memory) {
150         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
151         return msg.data;
152     }
153 }
154 
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable is Context {
162     address payable public _owner;
163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165     /**
166      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167      * account.
168      */
169     constructor() internal {
170         _owner = msg.sender;
171         emit OwnershipTransferred(address(0), _owner);
172     }
173 
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         require(isOwner(), "Ownable: caller is not the owner");
180         _;
181     }
182 
183     /**
184      * @dev Returns true if the caller is the current owner.
185      */
186     function isOwner() public view returns(bool) {
187         return _msgSender() == _owner;
188     }
189 
190 
191     /**
192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
193      * Can only be called by the current owner.
194      */
195     function transferOwnership(address payable newOwner) public onlyOwner {
196         _transferOwnership(newOwner);
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      */
202     function _transferOwnership(address payable newOwner) internal {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 
208 }
209 
210 
211 /**
212  * @title ERC20Basic
213  * @dev Simpler version of ERC20 interface
214  * @dev see https://github.com/ethereum/EIPs/issues/179
215  */
216 contract ERC20Basic {
217     uint256 public totalSupply;
218 
219     function balanceOf(address account) external view returns(uint256);
220 
221     function transfer(address recipient, uint256 amount) external returns(bool);
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 }
224 
225 
226 /**
227  * @title ERC20 interface
228  * @dev see https://github.com/ethereum/EIPs/issues/20
229  */
230 contract ERC20 is ERC20Basic {
231     function allowance(address owner, address spender) public view returns(uint256);
232 
233     function transferFrom(address from, address to, uint256 value) public returns(bool);
234 
235     function approve(address spender, uint256 value) public returns(bool);
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 
240 /**
241  * @title STAKDToken standard
242  * @dev the interface of STAKDTokenStandard
243  */
244 contract STAKDStandard {
245     uint256 public stakeStartTime;
246     uint256 public stakeMinAge;
247     uint256 public stakeMaxAge;
248 
249     function mint() public returns(bool);
250 
251     function coinAge() public view returns(uint256);
252 
253     function annualInterest() public view returns(uint256);
254     event Mint(address indexed _address, uint _reward);
255 }
256 contract ForeignToken {
257     function balanceOf(address _owner) view public returns(uint256);
258 
259     function transfer(address _to, uint256 _value) public returns(bool);
260 }
261 
262 
263 contract STAKDToken is ERC20, STAKDStandard, Ownable {
264     using SafeMath
265     for uint256;
266 
267     string public name = "STAKD";
268     string public symbol = "SKD";
269     uint public decimals = 18;
270 
271     uint public chainStartTime; //chain start time
272     uint public chainStartBlockNumber; //chain start block number
273     uint public stakeStartTime; //stake start time
274     uint public stakeMinAge = 2 days; // minimum age for coin age: 2D
275     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
276     uint public maxMintProofOfStake = 10 ** 17; // default 10% annual interest
277 
278     uint public totalSupply;
279     uint public maxTotalSupply;
280     uint public totalInitialSupply;
281 
282     address public treasury;
283 
284     struct transferInStruct {
285         uint128 amount;
286         uint64 time;
287     }
288 
289 
290     mapping(address => uint256) balances;
291     mapping(address => mapping(address => uint256)) allowed;
292     mapping(address => transferInStruct[]) transferIns;
293 
294     event TreasuryChange(address caller, address treasury);
295     event Burn(address indexed burner, uint256 value);
296 
297     /**
298      * @dev Fix for the ERC20 short address attack.
299      */
300     modifier onlyPayloadSize(uint size) {
301         require(msg.data.length >= size + 4);
302         _;
303     }
304 
305     modifier onlyTreasury() {
306         require(msg.sender == treasury);
307         _;
308     }
309 
310 
311     modifier canPoSMint() {
312         require(totalSupply < maxTotalSupply);
313         _;
314     }
315 
316     function getTokenBalance(address tokenAddress, address who) view public returns(uint) {
317         ForeignToken t = ForeignToken(tokenAddress);
318         uint bal = t.balanceOf(who);
319         return bal;
320     }
321 
322     function depositETH() public payable {
323         require(msg.value > 0);
324     }
325 
326     function() external payable {
327         depositETH();
328     }
329 
330 
331     function withdraw() onlyOwner public {
332 
333         _owner.transfer(address(this).balance);
334     }
335 
336     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns(bool) {
337         ForeignToken token = ForeignToken(_tokenContract);
338         uint256 amount = token.balanceOf(address(this));
339         return token.transfer(_owner, amount);
340     }
341 
342 
343     constructor(address _treasury) public payable {
344         maxTotalSupply = 10 ** 25; // 10 Million
345         totalInitialSupply = 10 ** 24; // 1 Million.
346 
347         chainStartTime = now;
348         chainStartBlockNumber = block.number;
349 
350         treasury = _treasury;
351         balances[msg.sender] = totalInitialSupply;
352         totalSupply = totalInitialSupply;
353     }
354 
355     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns(bool) {
356         if (msg.sender == _to) return mint();
357         balances[msg.sender] = balances[msg.sender].sub(_value);
358         balances[_to] = balances[_to].add(_value);
359         emit Transfer(msg.sender, _to, _value);
360         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
361         uint64 _now = uint64(now);
362         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
363         transferIns[_to].push(transferInStruct(uint128(_value), _now));
364         return true;
365     }
366 
367     function changeTreasury(address _treasury) public onlyTreasury returns(bool) {
368         treasury = _treasury;
369         emit TreasuryChange(msg.sender, treasury);
370         return true;
371     }
372 
373     function balanceOf(address _owner) public view returns(uint256 balance) {
374         return balances[_owner];
375     }
376 
377     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns(bool) {
378         require(_to != address(0));
379 
380         uint256 _allowance = allowed[_from][msg.sender];
381 
382         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
383         // require (_value <= _allowance);
384 
385         balances[_from] = balances[_from].sub(_value);
386         balances[_to] = balances[_to].add(_value);
387         allowed[_from][msg.sender] = _allowance.sub(_value);
388         emit Transfer(_from, _to, _value);
389         if (transferIns[_from].length > 0) delete transferIns[_from];
390         uint64 _now = uint64(now);
391         transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));
392         transferIns[_to].push(transferInStruct(uint128(_value), _now));
393         return true;
394     }
395 
396     function approve(address _spender, uint256 _value) public returns(bool) {
397         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
398 
399         allowed[msg.sender][_spender] = _value;
400         emit Approval(msg.sender, _spender, _value);
401         return true;
402     }
403 
404     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
405         return allowed[_owner][_spender];
406     }
407 
408     function mint() canPoSMint public returns(bool) {
409         if (balances[msg.sender] <= 0) return false;
410         if (transferIns[msg.sender].length <= 0) return false;
411 
412         uint reward = getProofOfStakeReward(msg.sender);
413         if (reward <= 0) return false;
414 
415         uint senderReward = (reward * 90).div(100); // 90% goes to the holder, 10% goes to the Treasury
416         uint treasuryReward = reward - senderReward;
417 
418         totalSupply = totalSupply.add(reward);
419         balances[msg.sender] = balances[msg.sender].add(senderReward);
420         balances[treasury] = balances[treasury].add(treasuryReward);
421 
422         delete transferIns[msg.sender];
423         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), uint64(now)));
424 
425         emit Mint(msg.sender, reward);
426         return true;
427     }
428 
429     function getBlockNumber() public view returns(uint blockNumber) {
430         blockNumber = block.number.sub(chainStartBlockNumber);
431     }
432 
433     function coinAge() public view returns(uint myCoinAge) {
434         myCoinAge = getCoinAge(msg.sender, now);
435     }
436 
437     function annualInterest() public view returns(uint interest) {
438         uint _now = now;
439         interest = maxMintProofOfStake;
440         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
441             interest = (770 * maxMintProofOfStake).div(100);
442         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
443             interest = (435 * maxMintProofOfStake).div(100);
444         }
445     }
446 
447     function getProofOfStakeReward(address _address) internal view returns(uint) {
448         require((now >= stakeStartTime) && (stakeStartTime > 0));
449 
450         uint _now = now;
451         uint _coinAge = getCoinAge(_address, _now);
452         if (_coinAge <= 0) return 0;
453 
454         uint interest = maxMintProofOfStake;
455         // Due to the high interest rate for the first two years, compounding should be taken into account.
456         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
457         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
458             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
459             interest = (770 * maxMintProofOfStake).div(100);
460         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
461             // 2nd year effective annual interest rate is 50%
462             interest = (435 * maxMintProofOfStake).div(100);
463         }
464 
465         return (_coinAge * interest).div(365 * (10 ** decimals));
466     }
467 
468     function getCoinAge(address _address, uint _now) internal view returns(uint _coinAge) {
469         if (transferIns[_address].length <= 0) return 0;
470 
471         for (uint i = 0; i < transferIns[_address].length; i++) {
472             if (_now < uint(transferIns[_address][i].time).add(stakeMinAge)) continue;
473 
474             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
475             if (nCoinSeconds > stakeMaxAge) nCoinSeconds = stakeMaxAge;
476 
477             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
478         }
479     }
480 
481     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
482         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
483         stakeStartTime = timestamp;
484     }
485 
486     function ownerBurnToken(uint _value) public onlyOwner {
487         require(_value > 0);
488 
489         balances[msg.sender] = balances[msg.sender].sub(_value);
490         delete transferIns[msg.sender];
491         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), uint64(now)));
492 
493         totalSupply = totalSupply.sub(_value);
494         totalInitialSupply = totalInitialSupply.sub(_value);
495         maxTotalSupply = maxTotalSupply.sub(_value * 10);
496 
497         emit Burn(msg.sender, _value);
498     }
499 
500     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
501     function batchTransfer(address[] memory _recipients, uint[] memory _values) public onlyOwner returns(bool) {
502         require(_recipients.length > 0 && _recipients.length == _values.length);
503 
504         uint total = 0;
505         for (uint i = 0; i < _values.length; i++) {
506             total = total.add(_values[i]);
507         }
508         require(total <= balances[msg.sender]);
509 
510         uint64 _now = uint64(now);
511         for (uint j = 0; j < _recipients.length; j++) {
512             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
513             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]), _now));
514             emit Transfer(msg.sender, _recipients[j], _values[j]);
515         }
516 
517         balances[msg.sender] = balances[msg.sender].sub(total);
518         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
519         if (balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
520 
521         return true;
522     }
523 }
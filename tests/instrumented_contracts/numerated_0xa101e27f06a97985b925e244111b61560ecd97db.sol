1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     require(c >= a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 /**
102  * @title BITTOStandard
103  * @dev the interface of BITTOStandard
104  */
105  
106 contract BITTOStandard {
107     uint256 public stakeStartTime;
108     uint256 public stakeMinAge;
109     uint256 public stakeMaxAge;
110     function mint() public returns (bool);
111     function coinAge() constant public returns (uint256);
112     function annualInterest() constant public returns (uint256);
113     event Mint(address indexed _address, uint _reward);
114 }
115 
116 
117 
118 /**
119  * @title Ownable
120  * @dev The Ownable contract has an owner address, and provides basic authorization control
121  * functions, this simplifies the implementation of "user permissions".
122  */
123 contract Ownable {
124 address private _owner;
125 
126 
127 event OwnershipRenounced(address indexed previousOwner);
128 event OwnershipTransferred(
129   address indexed previousOwner,
130   address indexed newOwner
131 );
132 
133 
134 /**
135   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
136   * account.
137   */
138 constructor() public {
139   _owner = msg.sender;
140 }
141 
142 /**
143   * @return the address of the owner.
144   */
145 function owner() public view returns(address) {
146   return _owner;
147 }
148 
149 /**
150   * @dev Throws if called by any account other than the owner.
151   */
152 modifier onlyOwner() {
153   require(isOwner());
154   _;
155 }
156 
157 /**
158   * @return true if `msg.sender` is the owner of the contract.
159   */
160 function isOwner() public view returns(bool) {
161   return msg.sender == _owner;
162 }
163 
164 /**
165   * @dev Allows the current owner to relinquish control of the contract.
166   * @notice Renouncing to ownership will leave the contract without an owner.
167   * It will not be possible to call the functions with the `onlyOwner`
168   * modifier anymore.
169   */
170 function renounceOwnership() public onlyOwner {
171   emit OwnershipRenounced(_owner);
172   _owner = address(0);
173 }
174 
175 /**
176   * @dev Allows the current owner to transfer control of the contract to a newOwner.
177   * @param newOwner The address to transfer ownership to.
178   */
179 function transferOwnership(address newOwner) public onlyOwner {
180   _transferOwnership(newOwner);
181 }
182 
183 /**
184   * @dev Transfers control of the contract to a newOwner.
185   * @param newOwner The address to transfer ownership to.
186   */
187 function _transferOwnership(address newOwner) internal {
188   require(newOwner != address(0));
189   emit OwnershipTransferred(_owner, newOwner);
190   _owner = newOwner;
191 }
192 }
193 
194 
195 contract BITTO is IERC20, BITTOStandard, Ownable {
196     using SafeMath for uint256;
197 
198     string public name = "BITTO";
199     string public symbol = "BITTO";
200     uint public decimals = 18;
201 
202     uint public chainStartTime; //chain start time
203     uint public chainStartBlockNumber; //chain start block number
204     uint public stakeStartTime; //stake start time
205     uint public stakeMinAge = 10 days; // minimum age for coin age: 10D
206     uint public stakeMaxAge = 180 days; // stake age of full weight: 180D
207 
208     uint public totalSupply;
209     uint public maxTotalSupply;
210     uint public totalInitialSupply;
211 
212     uint constant MIN_STAKING = 5000;  // minium amount of token to stake
213     uint constant STAKE_START_TIME = 1537228800;  // 2018.9.18
214     uint constant STEP1_ENDTIME = 1552780800;  //  2019.3.17
215     uint constant STEP2_ENDTIME = 1568332800;  // 2019.9.13
216     uint constant STEP3_ENDTIME = 1583884800;  // 2020.3.11
217     uint constant STEP4_ENDTIME = 1599436800; // 2020.9.7
218     uint constant STEP5_ENDTIME = 1914969600; // 2030.9.7
219 
220     struct Period {
221         uint start;
222         uint end;
223         uint interest;
224     }
225 
226     mapping (uint => Period) periods;
227 
228     mapping(address => bool) public noPOSRewards;
229 
230     struct transferInStruct {
231         uint128 amount;
232         uint64 time;
233     }
234 
235     mapping(address => uint256) balances;
236     mapping(address => mapping (address => uint256)) allowed;
237     mapping(address => transferInStruct[]) transferIns;
238 
239     event Burn(address indexed burner, uint256 value);
240 
241     /**
242      * @dev Fix for the ERC20 short address attack.
243      */
244     modifier onlyPayloadSize(uint size) {
245         require(msg.data.length >= size + 4);
246         _;
247     }
248 
249     modifier canPoSMint() {
250         require(totalSupply < maxTotalSupply);
251         _;
252     }
253 
254     constructor() public {
255         // 5 mil is reserved for POS rewards
256         maxTotalSupply = 223 * 10**23; // 22.3 Mil.
257         totalInitialSupply = 173 * 10**23; // 17.3 Mil. 10 mil = crowdsale, 7.3 team account
258 
259         chainStartTime = now;
260         chainStartBlockNumber = block.number;
261 
262         balances[msg.sender] = totalInitialSupply;
263         totalSupply = totalInitialSupply;
264 
265         // 4 periods for 2 years
266         stakeStartTime = 1537228800;
267         
268         periods[0] = Period(STAKE_START_TIME, STEP1_ENDTIME, 65 * 10 ** 18);
269         periods[1] = Period(STEP1_ENDTIME, STEP2_ENDTIME, 34 * 10 ** 18);
270         periods[2] = Period(STEP2_ENDTIME, STEP3_ENDTIME, 20 * 10 ** 18);
271         periods[3] = Period(STEP3_ENDTIME, STEP4_ENDTIME, 134 * 10 ** 16);
272         periods[4] = Period(STEP4_ENDTIME, STEP5_ENDTIME, 134 * 10 ** 16);
273     }
274 
275     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
276         if (msg.sender == _to)
277             return mint();
278         balances[msg.sender] = balances[msg.sender].sub(_value);
279         balances[_to] = balances[_to].add(_value);
280         emit Transfer(msg.sender, _to, _value);
281         if (transferIns[msg.sender].length > 0)
282             delete transferIns[msg.sender];
283         uint64 _now = uint64(now);
284         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
285         transferIns[_to].push(transferInStruct(uint128(_value),_now));
286         return true;
287     }
288 
289     function totalSupply() public view returns (uint256) {
290         return totalSupply;
291     }
292 
293     function balanceOf(address _owner) constant public returns (uint256 balance) {
294         return balances[_owner];
295     }
296 
297     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
298         require(_to != address(0));
299 
300         uint256 _allowance = allowed[_from][msg.sender];
301 
302         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
303         // require (_value <= _allowance);
304 
305         balances[_from] = balances[_from].sub(_value);
306         balances[_to] = balances[_to].add(_value);
307         allowed[_from][msg.sender] = _allowance.sub(_value);
308         emit Transfer(_from, _to, _value);
309         if (transferIns[_from].length > 0)
310             delete transferIns[_from];
311         uint64 _now = uint64(now);
312         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
313         transferIns[_to].push(transferInStruct(uint128(_value),_now));
314         return true;
315     }
316 
317     function approve(address _spender, uint256 _value) public returns (bool) {
318         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
319 
320         allowed[msg.sender][_spender] = _value;
321         emit Approval(msg.sender, _spender, _value);
322         return true;
323     }
324 
325     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
326         return allowed[_owner][_spender];
327     }
328 
329     function mint() canPoSMint public returns (bool) {
330         // minimum stake of 5000 x is required to earn staking.
331         if (balances[msg.sender] < MIN_STAKING.mul(1 ether))
332             return false;
333         if (transferIns[msg.sender].length <= 0)
334             return false;
335 
336         uint reward = getProofOfStakeReward(msg.sender);
337         if (reward <= 0)
338             return false;
339        
340         totalSupply = totalSupply.add(reward);
341         balances[msg.sender] = balances[msg.sender].add(reward);
342         delete transferIns[msg.sender];
343         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
344 
345         emit Transfer(address(0), msg.sender, reward);
346         emit Mint(msg.sender, reward);
347         return true;
348     }
349 
350     function getBlockNumber() view public returns (uint blockNumber) {
351         blockNumber = block.number.sub(chainStartBlockNumber);
352     }
353 
354     function coinAge() constant public returns (uint myCoinAge) {
355         uint _now = now;
356         myCoinAge = 0;
357         for (uint i=0; i < getPeriodNumber(_now) + 1; i ++) {
358             myCoinAge += getCoinAgeofPeriod(msg.sender, i, _now);
359         }
360     }
361 
362     function annualInterest() constant public returns (uint interest) {        
363         uint _now = now;
364         interest = periods[getPeriodNumber(_now)].interest;
365     }
366 
367     function getProofOfStakeReward(address _address) public view returns (uint totalReward) {
368         require((now >= stakeStartTime) && (stakeStartTime > 0));
369         require(!noPOSRewards[_address]);
370 
371         uint _now = now;
372 
373         totalReward = 0;
374         for (uint i=0; i < getPeriodNumber(_now) + 1; i ++) {
375             totalReward += (getCoinAgeofPeriod(_address, i, _now)).mul(periods[i].interest).div(100).div(365);
376         }
377     }
378 
379     function getPeriodNumber(uint _now) public view returns (uint periodNumber) {
380         for (uint i = 4; i >= 0; i --) {
381             if( _now >= periods[i].start){
382                 return i;
383             }
384         }
385     }
386 
387     function getCoinAgeofPeriod(address _address, uint _pid, uint _now) public view returns (uint _coinAge) {        
388         if (transferIns[_address].length <= 0)
389             return 0;
390 
391         if (_pid < 0 || _pid > 4)
392             return 0;
393 
394         _coinAge = 0;
395         uint nCoinSeconds;
396         uint i;
397 
398         if (periods[_pid].start < _now && 
399             periods[_pid].end >= _now) {
400             // calculate the current period
401             for (i = 0; i < transferIns[_address].length; i ++) {
402                 if (uint(periods[_pid].start) > uint(transferIns[_address][i].time) || 
403                     uint(periods[_pid].end) <= uint(transferIns[_address][i].time))
404                     continue;
405                 
406                 nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
407                 
408                 if (nCoinSeconds < stakeMinAge)
409                     continue;
410 
411                 if ( nCoinSeconds > stakeMaxAge )
412                     nCoinSeconds = stakeMaxAge;    
413                 
414                 nCoinSeconds = nCoinSeconds.sub(stakeMinAge);
415                 _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
416             }
417 
418         }else{
419             // calculate for the ended preriods which user did not claimed
420             for (i = 0; i < transferIns[_address].length; i++) {
421                 if (uint(periods[_pid].start) > uint(transferIns[_address][i].time) || 
422                     uint(periods[_pid].end) <= uint(transferIns[_address][i].time))
423                     continue;
424 
425                 nCoinSeconds = (uint(periods[_pid].end)).sub(uint(transferIns[_address][i].time));
426                 
427                 if (nCoinSeconds < stakeMinAge)
428                     continue;
429 
430                 if ( nCoinSeconds > stakeMaxAge )
431                     nCoinSeconds = stakeMaxAge;
432 
433                 nCoinSeconds = nCoinSeconds.sub(stakeMinAge);
434                 _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
435             }
436         }
437 
438         _coinAge = _coinAge.div(1 ether);
439     }
440 
441     function burn(uint256 _value) public {
442         require(_value <= balances[msg.sender]);
443         // no need to require value <= totalSupply, since that would imply the
444         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
445 
446         address burner = msg.sender;
447         balances[burner] = balances[burner].sub(_value);
448         delete transferIns[msg.sender];
449         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
450         totalSupply = totalSupply.sub(_value);
451         emit Burn(burner, _value);
452     }
453 
454     /**
455     * @dev Burns a specific amount of tokens.
456     * @param _value The amount of token to be burned.
457     */
458     function ownerBurnToken(uint _value) public onlyOwner {
459         require(_value > 0);
460 
461         balances[msg.sender] = balances[msg.sender].sub(_value);
462         delete transferIns[msg.sender];
463         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
464 
465         totalSupply = totalSupply.sub(_value);
466         totalInitialSupply = totalInitialSupply.sub(_value);
467         maxTotalSupply = maxTotalSupply.sub(_value*10);
468 
469         emit Burn(msg.sender, _value);
470     }
471 
472     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
473     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
474         require(_recipients.length > 0 && _recipients.length == _values.length);
475 
476         uint total = 0;
477         for (uint i = 0; i < _values.length; i++) {
478             total = total.add(_values[i]);
479         }
480         require(total <= balances[msg.sender]);
481 
482         uint64 _now = uint64(now);
483         for (uint j = 0; j < _recipients.length; j++) {
484             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
485             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
486             emit Transfer(msg.sender, _recipients[j], _values[j]);
487         }
488 
489         balances[msg.sender] = balances[msg.sender].sub(total);
490         if (transferIns[msg.sender].length > 0)
491             delete transferIns[msg.sender];
492         if (balances[msg.sender] > 0)
493             transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
494 
495         return true;
496     }
497 
498     function disablePOSReward(address _account, bool _enabled) onlyOwner public {
499         noPOSRewards[_account] = _enabled;
500     }
501 }
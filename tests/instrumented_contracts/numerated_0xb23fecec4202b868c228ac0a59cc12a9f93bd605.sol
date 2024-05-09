1 pragma solidity ^0.4.11;
2 contract ERC20Token {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 contract SafeMath {
47     
48     /*
49     standard uint256 functions
50      */
51     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
52         assert((z = x + y) >= x);
53     }
54     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         assert((z = x - y) <= x);
56     }
57     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
58         assert((z = x * y) >= x);
59     }
60     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
61         z = x / y;
62     }
63     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
64         return x <= y ? x : y;
65     }
66     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
67         return x >= y ? x : y;
68     }
69     /*
70     uint128 functions (h is for half)
71      */
72     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
73         assert((z = x + y) >= x);
74     }
75     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
76         assert((z = x - y) <= x);
77     }
78     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
79         assert((z = x * y) >= x);
80     }
81     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
82         z = x / y;
83     }
84     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
85         return x <= y ? x : y;
86     }
87     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
88         return x >= y ? x : y;
89     }
90     /*
91     int256 functions
92      */
93     function imin(int256 x, int256 y) constant internal returns (int256 z) {
94         return x <= y ? x : y;
95     }
96     function imax(int256 x, int256 y) constant internal returns (int256 z) {
97         return x >= y ? x : y;
98     }
99     /*
100     WAD math
101      */
102     uint128 constant WAD = 10 ** 18;
103     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
104         return hadd(x, y);
105     }
106     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
107         return hsub(x, y);
108     }
109     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
110         z = cast((uint256(x) * y + WAD / 2) / WAD);
111     }
112     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
113         z = cast((uint256(x) * WAD + y / 2) / y);
114     }
115     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
116         return hmin(x, y);
117     }
118     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
119         return hmax(x, y);
120     }
121     /*
122     RAY math
123      */
124     uint128 constant RAY = 10 ** 27;
125     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
126         return hadd(x, y);
127     }
128     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
129         return hsub(x, y);
130     }
131     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
132         z = cast((uint256(x) * y + RAY / 2) / RAY);
133     }
134     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         z = cast((uint256(x) * RAY + y / 2) / y);
136     }
137     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
138         // This famous algorithm is called "exponentiation by squaring"
139         // and calculates x^n with x as fixed-point and n as regular unsigned.
140         //
141         // It's O(log n), instead of O(n) for naive repeated multiplication.
142         //
143         // These facts are why it works:
144         //
145         //  If n is even, then x^n = (x^2)^(n/2).
146         //  If n is odd,  then x^n = x * x^(n-1),
147         //   and applying the equation for even x gives
148         //    x^n = x * (x^2)^((n-1) / 2).
149         //
150         //  Also, EVM division is flooring and
151         //    floor[(n-1) / 2] = floor[n / 2].
152         z = n % 2 != 0 ? x : RAY;
153         for (n /= 2; n != 0; n /= 2) {
154             x = rmul(x, x);
155             if (n % 2 != 0) {
156                 z = rmul(z, x);
157             }
158         }
159     }
160     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
161         return hmin(x, y);
162     }
163     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
164         return hmax(x, y);
165     }
166     function cast(uint256 x) constant internal returns (uint128 z) {
167         assert((z = uint128(x)) == x);
168     }
169 }
170 contract Owned {
171     /// @dev `owner` is the only address that can call a function with this
172     /// modifier
173     modifier onlyOwner() {
174         require(msg.sender == owner) ;
175         _;
176     }
177     address public owner;
178     /// @notice The Constructor assigns the message sender to be `owner`
179     function Owned() {
180         owner = msg.sender;
181     }
182     address public newOwner;
183     /// @notice `owner` can step down and assign some other address to this role
184     /// @param _newOwner The address of the new owner. 0x0 can be used to create
185     ///  an unowned neutral vault, however that cannot be undone
186     function changeOwner(address _newOwner) onlyOwner {
187         newOwner = _newOwner;
188     }
189     function acceptOwnership() {
190         if (msg.sender == newOwner) {
191             owner = newOwner;
192         }
193     }
194 }
195 contract StandardToken is ERC20Token {
196     function transfer(address _to, uint256 _value) returns (bool success) {
197         if (balances[msg.sender] >= _value && _value > 0) {
198             balances[msg.sender] -= _value;
199             balances[_to] += _value;
200             Transfer(msg.sender, _to, _value);
201             return true;
202         } else {
203             return false;
204         }
205     }
206 
207     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
208         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
209             balances[_to] += _value;
210             balances[_from] -= _value;
211             allowed[_from][msg.sender] -= _value;
212             Transfer(_from, _to, _value);
213             return true;
214         } else {
215             return false;
216         }
217     }
218 
219     function balanceOf(address _owner) constant returns (uint256 balance) {
220         return balances[_owner];
221     }
222 
223     function approve(address _spender, uint256 _value) returns (bool success) {
224         // To change the approve amount you first have to reduce the addresses`
225         //  allowance to zero by calling `approve(_spender,0)` if it is not
226         //  already 0 to mitigate the race condition described here:
227         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228         if ((_value!=0) && (allowed[msg.sender][_spender] !=0)) throw;
229 
230         allowed[msg.sender][_spender] = _value;
231         Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
236         return allowed[_owner][_spender];
237     }
238 
239     mapping (address => uint256) public balances;
240     mapping (address => mapping (address => uint256)) allowed;
241 }
242 contract ATMToken is StandardToken, Owned {
243     // metadata
244     string public constant name = "Attention Token of Media";
245     string public constant symbol = "ATM";
246     string public version = "1.0";
247     uint256 public constant decimals = 8;
248     bool public disabled;
249     mapping(address => bool) public isATMHolder;
250     address[] public ATMHolders;
251     // constructor
252     function ATMToken(uint256 _amount) {
253         totalSupply = _amount; //设置当前ATM发行总量
254         balances[msg.sender] = _amount;
255     }
256     function getATMTotalSupply() external constant returns(uint256) {
257         return totalSupply;
258     }
259     function getATMHoldersNumber() external constant returns(uint256) {
260         return ATMHolders.length;
261     }
262     //在数据迁移时,需要先停止ATM交易
263     function setDisabled(bool flag) external onlyOwner {
264         disabled = flag;
265     }
266     function transfer(address _to, uint256 _value) returns (bool success) {
267         require(!disabled);
268         if(isATMHolder[_to] == false){
269             isATMHolder[_to] = true;
270             ATMHolders.push(_to);
271         }
272         return super.transfer(_to, _value);
273     }
274     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
275         require(!disabled);
276         if(isATMHolder[_to] == false){
277             isATMHolder[_to] = true;
278             ATMHolders.push(_to);
279         }
280         return super.transferFrom(_from, _to, _value);
281     }
282     function kill() external onlyOwner {
283         selfdestruct(owner);
284     }
285 }
286 contract Contribution is SafeMath, Owned {
287     uint256 public constant MIN_FUND = (0.01 ether);
288     uint256 public constant CRAWDSALE_START_DAY = 1;
289     uint256 public constant CRAWDSALE_END_DAY = 7;
290     uint256 public dayCycle = 24 hours;
291     uint256 public fundingStartTime = 0;
292     address public ethFundDeposit = 0;
293     address public investorDeposit = 0;
294     bool public isFinalize = false;
295     bool public isPause = false;
296     mapping (uint => uint) public dailyTotals; //total eth per day
297     mapping (uint => mapping (address => uint)) public userBuys; // otal eth per day per user
298     uint256 public totalContributedETH = 0; //total eth of 7 days
299     // events
300     event LogBuy (uint window, address user, uint amount);
301     event LogCreate (address ethFundDeposit, address investorDeposit, uint fundingStartTime, uint dayCycle);
302     event LogFinalize (uint finalizeTime);
303     event LogPause (uint finalizeTime, bool pause);
304     function Contribution (address _ethFundDeposit, address _investorDeposit, uint256 _fundingStartTime, uint256 _dayCycle)  {
305         require( now < _fundingStartTime );
306         require( _ethFundDeposit != address(0) );
307         fundingStartTime = _fundingStartTime;
308         dayCycle = _dayCycle;
309         ethFundDeposit = _ethFundDeposit;
310         investorDeposit = _investorDeposit;
311         LogCreate(_ethFundDeposit, _investorDeposit, _fundingStartTime,_dayCycle);
312     }
313     //crawdsale entry
314     function () payable {  
315         require(!isPause);
316         require(!isFinalize);
317         require( msg.value >= MIN_FUND ); //eth >= 0.01 at least
318         ethFundDeposit.transfer(msg.value);
319         buy(today(), msg.sender, msg.value);
320     }
321     function importExchangeSale(uint256 day, address _exchangeAddr, uint _amount) onlyOwner {
322         buy(day, _exchangeAddr, _amount);
323     }
324     function buy(uint256 day, address _addr, uint256 _amount) internal {
325         require( day >= CRAWDSALE_START_DAY && day <= CRAWDSALE_END_DAY ); 
326         //record user's buy amount
327         userBuys[day][_addr] += _amount;
328         dailyTotals[day] += _amount;
329         totalContributedETH += _amount;
330         LogBuy(day, _addr, _amount);
331     }
332     function kill() onlyOwner {
333         selfdestruct(owner);
334     }
335     function pause(bool _isPause) onlyOwner {
336         isPause = _isPause;
337         LogPause(now,_isPause);
338     }
339     function finalize() onlyOwner {
340         isFinalize = true;
341         LogFinalize(now);
342     }
343     function today() constant returns (uint) {
344         return sub(now, fundingStartTime) / dayCycle + 1;
345     }
346 }
347 contract ATMint is SafeMath, Owned {
348     ATMToken public atmToken; //ATM contract address
349     Contribution public contribution; //crawdSale contract address
350     uint128 public fundingStartTime = 0;
351     uint256 public lockStartTime = 0;
352     
353     uint256 public constant MIN_FUND = (0.01 ether);
354     uint256 public constant CRAWDSALE_START_DAY = 1;
355     uint256 public constant CRAWDSALE_EARLYBIRD_END_DAY = 3;
356     uint256 public constant CRAWDSALE_END_DAY = 7;
357     uint256 public constant THAW_CYCLE_USER = 6/*6*/;
358     uint256 public constant THAW_CYCLE_FUNDER = 6/*60*/;
359     uint256 public constant THAW_CYCLE_LENGTH = 30;
360     uint256 public constant decimals = 8; //ATM token decimals
361     uint256 public constant MILLION = (10**6 * 10**decimals);
362     uint256 public constant tokenTotal = 10000 * MILLION;  // 100 billion
363     uint256 public constant tokenToFounder = 800 * MILLION;  // 8 billion
364     uint256 public constant tokenToReserve = 5000 * MILLION;  // 50 billion
365     uint256 public constant tokenToContributor = 4000 * MILLION; // 40 billion
366     uint256[] public tokenToReward = [0, (120 * MILLION), (50 * MILLION), (30 * MILLION), 0, 0, 0, 0]; // 1.2 billion, 0.5 billion, 0.3 billion
367     bool doOnce = false;
368     
369     mapping (address => bool) public collected;
370     mapping (address => uint) public contributedToken;
371     mapping (address => uint) public unClaimedToken;
372     // events
373     event LogRegister (address contributionAddr, address ATMTokenAddr);
374     event LogCollect (address user, uint spendETHAmount, uint getATMAmount);
375     event LogMigrate (address user, uint balance);
376     event LogClaim (address user, uint claimNumberNow, uint unclaimedTotal, uint totalContributed);
377     event LogClaimReward (address user, uint claimNumber);
378     /*
379     ************************
380     deploy ATM and start Freeze cycle
381     ************************
382     */
383     function initialize (address _contribution) onlyOwner {
384         require( _contribution != address(0) );
385         contribution = Contribution(_contribution);
386         atmToken = new ATMToken(tokenTotal);
387         //Start thawing process
388         setLockStartTime(now);
389         // alloc reserve token to fund account (50 billion)
390         lockToken(contribution.ethFundDeposit(), tokenToReserve);
391         lockToken(contribution.investorDeposit(), tokenToFounder);
392         //help founder&fund to claim first 1/6 ATMs
393         claimUserToken(contribution.investorDeposit());
394         claimFoundationToken();
395         
396         LogRegister(_contribution, atmToken);
397     }
398     /*
399     ************************
400     calc ATM by eth per user
401     ************************
402     */
403     function collect(address _user) {
404         require(!collected[_user]);
405         
406         uint128 dailyContributedETH = 0;
407         uint128 userContributedETH = 0;
408         uint128 userTotalContributedETH = 0;
409         uint128 reward = 0;
410         uint128 rate = 0;
411         uint128 totalATMToken = 0;
412         uint128 rewardRate = 0;
413         collected[_user] = true;
414         for (uint day = CRAWDSALE_START_DAY; day <= CRAWDSALE_END_DAY; day++) {
415             dailyContributedETH = cast( contribution.dailyTotals(day) );
416             userContributedETH = cast( contribution.userBuys(day,_user) );
417             if (dailyContributedETH > 0 && userContributedETH > 0) {
418                 //Calculate user rewards
419                 rewardRate = wdiv(cast(tokenToReward[day]), dailyContributedETH);
420                 reward += wmul(userContributedETH, rewardRate);
421                 //Cumulative user purchase total
422                 userTotalContributedETH += userContributedETH;
423             }
424         }
425         rate = wdiv(cast(tokenToContributor), cast(contribution.totalContributedETH()));
426         totalATMToken = wmul(rate, userTotalContributedETH);
427         totalATMToken += reward;
428         //Freeze all ATMs purchased
429         lockToken(_user, totalATMToken);
430         //help user to claim first 1/6 ATMs
431         claimUserToken(_user);
432         LogCollect(_user, userTotalContributedETH, totalATMToken);
433     }
434     function lockToken(
435         address _user,
436         uint256 _amount
437     ) internal {
438         require(_user != address(0));
439         contributedToken[_user] += _amount;
440         unClaimedToken[_user] += _amount;
441     }
442     function setLockStartTime(uint256 _time) internal {
443         lockStartTime = _time;
444     }
445     function cast(uint256 _x) constant internal returns (uint128 z) {
446         require((z = uint128(_x)) == _x);
447     }
448     /*
449     ************************
450     Claim ATM
451     ************************
452     */
453     function claimReward(address _founder) onlyOwner {
454         require(_founder != address(0));
455         require(lockStartTime != 0);
456         require(doOnce == false);
457         uint256 rewards = 0;
458         for (uint day = CRAWDSALE_START_DAY; day <= CRAWDSALE_EARLYBIRD_END_DAY; day++) {
459             if(contribution.dailyTotals(day) == 0){
460                 rewards += tokenToReward[day];
461             }
462         }
463         atmToken.transfer(_founder, rewards);
464         doOnce = true;
465         LogClaimReward(_founder, rewards);
466     }
467     
468     function claimFoundationToken() {
469         require(msg.sender == owner || msg.sender == contribution.ethFundDeposit());
470         claimToken(contribution.ethFundDeposit(),THAW_CYCLE_FUNDER);
471     }
472     function claimUserToken(address _user) {
473         claimToken(_user,THAW_CYCLE_USER);
474     }
475     function claimToken(address _user, uint256 _stages) internal {
476         if (unClaimedToken[_user] == 0) {
477             return;
478         }
479         uint256 currentStage = sub(now, lockStartTime) / (60*60 /*contribution.dayCycle() * THAW_CYCLE_LENGTH*/) +1;
480         if (currentStage == 0) {
481             return;
482         } else if (currentStage > _stages) {
483             currentStage = _stages;
484         }
485         uint256 lockStages = _stages - currentStage;
486         uint256 unClaimed = (contributedToken[_user] * lockStages) / _stages;
487         if (unClaimedToken[_user] <= unClaimed) {
488             return;
489         }
490         uint256 tmp = unClaimedToken[_user] - unClaimed;
491         unClaimedToken[_user] = unClaimed;
492         atmToken.transfer(_user, tmp);
493         LogClaim(_user, tmp, unClaimed,contributedToken[_user]);
494     }
495     /*
496     ************************
497     migrate user data and suiside
498     ************************
499     */
500     function disableATMExchange() onlyOwner {
501         atmToken.setDisabled(true);
502     }
503     function enableATMExchange() onlyOwner {
504         atmToken.setDisabled(false);
505     }
506     function migrateUserData() onlyOwner {
507         for (var i=0; i< atmToken.getATMHoldersNumber(); i++){
508             LogMigrate(atmToken.ATMHolders(i), atmToken.balances(atmToken.ATMHolders(i)));
509         }
510     }
511     function kill() onlyOwner {
512         atmToken.kill();
513         selfdestruct(owner);
514     }
515 }